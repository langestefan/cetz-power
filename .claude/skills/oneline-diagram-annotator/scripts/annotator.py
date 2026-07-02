"""
oneline_annotator.py
=====================
Detect and annotate the geometry of a single-line (one-line) power-system
diagram: bus bars, MV line conductors, switches and line->bus tap points.

The hard part of reading these schematics by pixel is that estimates drift
into the *gap between two parallel bars/conductors*. Two mechanisms guard
against that here:

  1. RANSAC lock  (`ransac_const`)
     A bar is modelled as `coord = const` (a horizontal bar is `y = c`, a
     vertical bar is `x = c`). RANSAC keeps the largest consensus set of dark
     pixels, so the fit snaps onto ONE real bar instead of averaging two close
     ones -> never "stuck between buses".

  2. Coverage fine-tune  (`refine_const`)
     After the lock, the constant coordinate is nudged within +/-search to
     MAXIMISE the fraction of the element that actually overlaps dark ink.
     Error = 1 - coverage, so this is a direct error-minimisation step. This is
     what removes residual offsets (the kind that left a tie line 7 px above a
     switch).

A diagram is described by a `Topology` (approximate human-read seeds + labels).
The pipeline refines every seed to the real ink and renders a colour-blind-safe
overlay (orange / magenta / teal / black — no red-green distinction).

Usage:
    python oneline_annotator.py input.png output.png
"""

from __future__ import annotations
import sys
import math
from dataclasses import dataclass, field

import numpy as np
from PIL import Image, ImageDraw, ImageFont


# --------------------------------------------------------------------------- #
# Masks
# --------------------------------------------------------------------------- #
def build_masks(path: str, dark_thr: int = 110):
    """Return (PIL image, dark mask, blue mask)."""
    im = Image.open(path).convert("RGB")
    a = np.asarray(im).astype(int)
    R, G, B = a[..., 0], a[..., 1], a[..., 2]
    dark = (R < dark_thr) & (G < dark_thr) & (B < dark_thr)
    blue = (B > 110) & (B - R > 40) & (B - G > 25)   # load arrows / flex devices
    return im, dark, blue


# --------------------------------------------------------------------------- #
# Robust 1-D fit (RANSAC) + coverage refinement
# --------------------------------------------------------------------------- #
def ransac_const(values: np.ndarray, tol: float = 2.0, iters: int = 200,
                 min_inliers: int = 15, seed: int = 0):
    """
    Robustly estimate a single constant from `values` (e.g. the y-rows of the
    dark pixels that belong to one horizontal bar). Returns (c, inlier_mask) or
    (None, None) if no dense enough consensus exists.

    Because it maximises a CONSENSUS set rather than minimising mean error, a
    second nearby bar contributes outliers that are rejected instead of pulling
    the estimate into the gap.
    """
    if values.size == 0:
        return None, None
    rng = np.random.default_rng(seed)
    best_c, best_inl, best_n = None, None, -1
    for _ in range(iters):
        c0 = values[rng.integers(values.size)]
        inl = np.abs(values - c0) <= tol
        c = values[inl].mean()                 # local refine
        inl = np.abs(values - c) <= tol        # re-evaluate consensus
        n = int(inl.sum())
        if n > best_n:
            best_n, best_c, best_inl = n, float(values[inl].mean()), inl
    if best_n < min_inliers:
        return None, None
    return best_c, best_inl


def _coverage(dark: np.ndarray, orient: str, c: int, a: int, b: int, half: int):
    """Fraction of the span [a,b] that has dark ink within +/-half of line c."""
    H, W = dark.shape
    a, b = max(0, a), min((W if orient == "h" else H) - 1, b)
    if b <= a:
        return 0.0
    if orient == "h":           # horizontal element at row c
        lo, hi = max(0, c - half), min(H, c + half + 1)
        seg = dark[lo:hi, a:b + 1].any(axis=0)
    else:                       # vertical element at col c
        lo, hi = max(0, c - half), min(W, c + half + 1)
        seg = dark[a:b + 1, lo:hi].any(axis=1)
    return float(seg.mean())


def refine_const(dark, orient, c, a, b, search=5, half=2):
    """Grid-search the constant coordinate +/-search to maximise coverage."""
    best_c, best_cov = c, _coverage(dark, orient, c, a, b, half)
    for cc in range(c - search, c + search + 1):
        cov = _coverage(dark, orient, cc, a, b, half)
        if cov > best_cov:
            best_c, best_cov = cc, cov
    return best_c, best_cov


def find_extent(dark, orient, c, a_seed, b_seed, half=2, max_gap=10, pad=40):
    """
    Grow the span around a seed along the bar until a gap > max_gap of blank
    pixels is hit. Returns (a, b) endpoints snapped to the real ink.
    """
    H, W = dark.shape
    if orient == "h":
        line = dark[max(0, c - half):c + half + 1, :].any(axis=0)
        lim = W
    else:
        line = dark[:, max(0, c - half):c + half + 1].any(axis=1)
        lim = H
    lo = max(0, min(a_seed, b_seed) - pad)
    hi = min(lim - 1, max(a_seed, b_seed) + pad)
    mid = (a_seed + b_seed) // 2
    # walk left
    a = mid; gap = 0
    for i in range(mid, lo - 1, -1):
        if line[i]:
            a = i; gap = 0
        else:
            gap += 1
            if gap > max_gap:
                break
    # walk right
    b = mid; gap = 0
    for i in range(mid, hi + 1):
        if line[i]:
            b = i; gap = 0
        else:
            gap += 1
            if gap > max_gap:
                break
    return a, b


# --------------------------------------------------------------------------- #
# Topology description
# --------------------------------------------------------------------------- #
@dataclass
class Bus:
    label: str
    orient: str          # "h" or "v"
    coord: int           # seed y (h) or x (v)
    a: int               # seed span start (x for h, y for v)
    b: int               # seed span end
    # filled after refinement:
    cov: float = 0.0

@dataclass
class Edge:
    label: str
    pts: list            # polyline [(x,y), ...]; constant segments get snapped

@dataclass
class Topology:
    buses: list = field(default_factory=list)
    edges: list = field(default_factory=list)      # MV lines (magenta)
    feeders: list = field(default_factory=list)    # transformer/load stubs (black)
    switches: list = field(default_factory=list)   # (label, x, y) on a conductor
    transformers: list = field(default_factory=list)  # (label, x, cy_top, cy_bot, r)
    generators: list = field(default_factory=list)     # (label, x, y, r) rotating machine
    loads: list = field(default_factory=list)          # (label, x, y) arrow tip; maps to nearest bus
    external_grid: list = field(default_factory=list)   # (label, x0, y0, x1, y1) source block (box)
    pv: list = field(default_factory=list)              # (label, x0, y0, x1, y1) PV panel (box+chevron)


# --------------------------------------------------------------------------- #
# Refinement pipeline
# --------------------------------------------------------------------------- #
def refine_bus(dark, bus: Bus, ransac_win=4, search=5, half=2, grow=True):
    """RANSAC-lock the bar's constant coord, coverage-refine it, and (if grow)
    extend the span to ink. Pass grow=False to keep an explicit, hand-set extent."""
    H, W = dark.shape
    c, a, b = bus.coord, bus.a, bus.b
    if bus.orient == "h":
        ys, xs = np.where(dark[max(0, c - ransac_win):c + ransac_win + 1,
                               max(0, a - 5):b + 6])
        vals = ys + max(0, c - ransac_win)
    else:
        ys, xs = np.where(dark[max(0, a - 5):b + 6,
                               max(0, c - ransac_win):c + ransac_win + 1])
        vals = xs + max(0, c - ransac_win)
    locked, _ = ransac_const(vals.astype(float), tol=2.0)
    if locked is not None:
        c = int(round(locked))
    c, cov = refine_const(dark, bus.orient, c, a, b, search=search, half=half)
    if grow:
        a, b = find_extent(dark, bus.orient, c, a, b, half=half)
    bus.coord, bus.a, bus.b, bus.cov = c, a, b, cov
    return bus


def snap_segment(dark, p0, p1, search=8, half=2):
    """
    Snap one straight (H or V) segment onto the nearest real conductor by
    maximising coverage of its constant coordinate. Diagonal segments are
    returned unchanged. Returns (new_p0, new_p1).
    """
    (x0, y0), (x1, y1) = p0, p1
    if x0 == x1 and y0 != y1:          # vertical -> snap x
        x, _ = refine_const(dark, "v", x0, min(y0, y1), max(y0, y1),
                            search=search, half=half)
        return (x, y0), (x, y1)
    if y0 == y1 and x0 != x1:          # horizontal -> snap y
        y, _ = refine_const(dark, "h", y0, min(x0, x1), max(x0, x1),
                            search=search, half=half)
        return (x0, y), (x1, y)
    return p0, p1                       # diagonal / point


def refine_edge(dark, edge: Edge, search=8):
    pts = edge.pts[:]
    for i in range(len(pts) - 1):
        a, b = snap_segment(dark, pts[i], pts[i + 1], search=search)
        pts[i], pts[i + 1] = a, b       # shared vertices stay consistent
    edge.pts = pts
    return edge


def edge_coverage(dark, edge: Edge, half=2):
    covs = []
    for i in range(len(edge.pts) - 1):
        (x0, y0), (x1, y1) = edge.pts[i], edge.pts[i + 1]
        if x0 == x1 and y0 != y1:
            covs.append(_coverage(dark, "v", x0, min(y0, y1), max(y0, y1), half))
        elif y0 == y1 and x0 != x1:
            covs.append(_coverage(dark, "h", y0, min(x0, x1), max(x0, x1), half))
    return float(np.mean(covs)) if covs else 1.0


def _circle_coverage(dark, cx, cy, r, nsamp=72):
    """Fraction of a circle's circumference (radius r, centre (cx,cy)) on ink."""
    H, W = dark.shape
    hits = 0
    for k in range(nsamp):
        th = 2 * math.pi * k / nsamp
        x = int(round(cx + r * math.cos(th)))
        y = int(round(cy + r * math.sin(th)))
        ok = False
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                yy, xx = y + dy, x + dx
                if 0 <= yy < H and 0 <= xx < W and dark[yy, xx]:
                    ok = True
                    break
            if ok:
                break
        hits += ok
    return hits / nsamp


def fit_transformer(dark, x0, y0, x1, y1, rmin=10, rmax=16):
    """Fit a 2-winding (double-circle) transformer symbol inside the given box.

    Models it as two equal-radius circles whose centres are separated by exactly
    r — each circle passes through the other's centre, the standard 2-winding
    symbol — and searches midpoint, orientation and radius to maximise the
    fraction of each circumference lying on ink (coverage). Scoring the full ring
    makes a lead crossing the circles barely perturb the fit, and the constrained
    geometry locks the true centres instead of drifting toward the leads. Handles
    vertical, horizontal and diagonally-drawn transformers alike.

    Returns a 6-tuple (x1, y1, x2, y2, r) for Topology.transformers (top circle
    first), or None if the box holds no ring.
    """
    best = None
    for r in range(rmin, rmax + 1):
        h = r / 2.0
        for mx in range(x0 + 6, x1 - 6):
            for my in range(y0 + 6, y1 - 6):
                for deg in range(0, 180, 10):
                    a = math.radians(deg)
                    dx, dy = h * math.cos(a), h * math.sin(a)
                    sc = (_circle_coverage(dark, mx + dx, my + dy, r) +
                          _circle_coverage(dark, mx - dx, my - dy, r))
                    if best is None or sc > best[0]:
                        best = (sc, mx, my, deg, r)
    if best is None:
        return None
    _, mx, my, deg, r = best
    h = r / 2.0
    a = math.radians(deg)
    dx, dy = h * math.cos(a), h * math.sin(a)
    c1 = (int(round(mx + dx)), int(round(my + dy)))
    c2 = (int(round(mx - dx)), int(round(my - dy)))
    if c1[1] > c2[1]:
        c1, c2 = c2, c1
    return (c1[0], c1[1], c2[0], c2[1], r)


def fit_generator(dark, x0, y0, x1, y1, rmin=12, rmax=22):
    """Fit a single machine circle (generator / synchronous condenser) by
    maximising circumference coverage over centre and radius. Returns
    (cx, cy, r) for Topology.generators, or None."""
    best = None
    for r in range(rmin, rmax + 1):
        for cx in range(x0 + r - 3, x1 - r + 3):
            for cy in range(y0 + r - 3, y1 - r + 3):
                c = _circle_coverage(dark, cx, cy, r)
                if best is None or c > best[0]:
                    best = (c, cx, cy, r)
    return (best[1], best[2], best[3]) if best else None


def refine_all(dark, topo: Topology, grow=True):
    report = {"buses": {}, "edges": {}}
    for bus in topo.buses:
        before = _coverage(dark, bus.orient, bus.coord, bus.a, bus.b, 2)
        refine_bus(dark, bus, grow=grow)
        report["buses"][bus.label] = (round(before, 3), round(bus.cov, 3))
    for edge in topo.edges:
        before = edge_coverage(dark, edge)
        refine_edge(dark, edge)
        after = edge_coverage(dark, edge)
        report["edges"][edge.label or "(stub)"] = (round(before, 3), round(after, 3))
    return report


# --------------------------------------------------------------------------- #
# Rendering (colour-blind-safe palette)
# --------------------------------------------------------------------------- #
PALETTE = dict(bus=(230, 159, 0), line=(204, 0, 122), switch=(0, 134, 139),
               stub=(0, 0, 0), tap=(240, 200, 0), xfmr=(120, 70, 200),
               gen=(60, 70, 200), load=(0, 0, 0), grid=(60, 70, 200),
               pv=(150, 90, 30))

def _font(size):
    try:
        return ImageFont.truetype(
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", size)
    except Exception:
        return ImageFont.load_default()


def _nearest_bus(topo, pt):
    """Bus whose bar is closest to point pt (perp distance + overshoot)."""
    x, y = pt; best, bd = None, 1e18
    for b in topo.buses:
        if b.orient == "h":
            over = 0 if b.a <= x <= b.b else min(abs(x - b.a), abs(x - b.b))
            dist = abs(y - b.coord) + over
        else:
            over = 0 if b.a <= y <= b.b else min(abs(y - b.a), abs(y - b.b))
            dist = abs(x - b.coord) + over
        if dist < bd:
            bd, best = dist, b
    return best


def _switch_lean(dark, cx, cy, h=11):
    """Detect an open-switch blade's lean from the image: '\\' or '/'.
    Compares mean dark-x in the upper half vs lower half of the switch window."""
    H, W = dark.shape
    top, bot = [], []
    for dy in range(-h, h + 1):
        y = cy + dy
        if not (0 <= y < H):
            continue
        xs = np.where(dark[y, max(0, cx - h):min(W, cx + h + 1)])[0] + max(0, cx - h)
        if len(xs):
            (top if dy < 0 else bot).append(xs.mean())
    if not top or not bot:
        return "/"
    return "\\" if np.mean(top) < np.mean(bot) else "/"



def render(im, topo: Topology, out_path: str):
    W, H = im.size
    ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(ov)
    f, fs = _font(12), _font(11)
    _a = np.asarray(im.convert("RGB")).astype(int)
    _dark = (_a[..., 0] < 110) & (_a[..., 1] < 110) & (_a[..., 2] < 110)

    for bus in topo.buses:
        c, a, b = bus.coord, bus.a, bus.b
        if bus.orient == "h":
            d.line([a, c, b, c], fill=PALETTE["bus"] + (255,), width=5)
            d.line([a, c - 4, a, c + 4], fill=PALETTE["bus"] + (255,), width=2)
            d.line([b, c - 4, b, c + 4], fill=PALETTE["bus"] + (255,), width=2)
        else:
            d.line([c, a, c, b], fill=PALETTE["bus"] + (255,), width=5)
            d.line([c - 4, a, c + 4, a], fill=PALETTE["bus"] + (255,), width=2)
            d.line([c - 4, b, c + 4, b], fill=PALETTE["bus"] + (255,), width=2)

    for edge in topo.edges:
        flat = [p for xy in edge.pts for p in xy]
        d.line(flat, fill=PALETTE["line"] + (255,), width=3, joint="curve")
        if edge.label:
            mx, my = edge.pts[len(edge.pts) // 2]
            d.text((mx + 6, my - 7), edge.label, fill=PALETTE["line"], font=fs)

    for stub in topo.feeders:
        d.line([p for xy in stub for p in xy],
               fill=PALETTE["stub"] + (255,), width=3, joint="curve")

    for sw in topo.switches:
        lab, x, y = sw[0], sw[1], sw[2]
        lean = sw[3] if len(sw) > 3 else _switch_lean(_dark, x, y)
        if lean == "\\":
            d.line([x - 8, y - 8, x + 8, y + 8], fill=PALETTE["switch"] + (255,), width=4)
        else:
            d.line([x - 8, y + 8, x + 8, y - 8], fill=PALETTE["switch"] + (255,), width=4)
        d.text((x + 7, y - 16), lab, fill=PALETTE["switch"], font=f)

    for t in topo.transformers:          # 5-tuple = vertical stack; 6-tuple = two free centers
        if len(t) == 5:
            lab, x, cy_top, cy_bot, r = t
            centers = [(x, cy_top), (x, cy_bot)]
        else:
            lab, x1, y1, x2, y2, r = t
            centers = [(x1, y1), (x2, y2)]
        for cx, cy in centers:
            d.ellipse([cx - r, cy - r, cx + r, cy + r],
                      outline=PALETTE["xfmr"] + (255,), width=3)
        mx = max(c[0] for c in centers) + r + 2
        my = (centers[0][1] + centers[1][1]) // 2 - 7
        d.text((mx, my), lab, fill=PALETTE["xfmr"], font=fs)

    for lab, x, y, r in topo.generators:          # rotating-machine source: single circle
        d.ellipse([x - r, y - r, x + r, y + r],
                  outline=PALETTE["gen"] + (255,), width=3)
        d.text((x - 6, y + r + 1), lab, fill=PALETTE["gen"], font=fs)

    for lab, x0, y0, x1, y1 in topo.external_grid:   # source block: box (vs circle = machine)
        d.rectangle([x0, y0, x1, y1], outline=PALETTE["grid"] + (255,), width=3)
        d.text((x1 + 4, y0 - 2), lab, fill=PALETTE["grid"], font=fs)

    for lab, x0, y0, x1, y1 in topo.pv:              # PV panel: box + downward chevron
        d.rectangle([x0, y0, x1, y1], outline=PALETTE["pv"] + (255,), width=2)
        mx = (x0 + x1) // 2; top = y0 + 3; bot = y0 + (y1 - y0) // 2
        d.line([x0 + 2, top, mx, bot], fill=PALETTE["pv"] + (255,), width=2)
        d.line([x1 - 2, top, mx, bot], fill=PALETTE["pv"] + (255,), width=2)
        d.text((x1 + 2, y0 - 1), lab, fill=PALETTE["pv"], font=fs)

    for ld in topo.loads:                         # load arrow; optional 4th = direction
        lab, x, y = ld[0], ld[1], ld[2]
        direction = ld[3] if len(ld) > 3 else "down"
        L = 22
        if len(ld) > 3:                           # directional fixed-length arrow
            dx, dy = {"down": (0, 1), "up": (0, -1),
                      "left": (-1, 0), "right": (1, 0)}[direction]
            x0, y0 = x - dx * L, y - dy * L
            d.line([x0, y0, x, y], fill=PALETTE["load"] + (255,), width=3)
            px, py = -dy, dx                       # perpendicular for the head
            d.polygon([(x - dx * 9 + px * 5, y - dy * 9 + py * 5),
                       (x - dx * 9 - px * 5, y - dy * 9 - py * 5), (x, y)],
                      fill=PALETTE["load"] + (255,))
        else:                                      # legacy: down arrow from nearest bus
            bus = _nearest_bus(topo, (x, y))
            y0 = bus.coord if (bus and bus.orient == "h") else y - 28
            d.line([x, y0, x, y], fill=PALETTE["load"] + (255,), width=3)
            d.polygon([(x - 5, y - 9), (x + 5, y - 9), (x, y)],
                      fill=PALETTE["load"] + (255,))

    # tap points = endpoints of edges that land on a bus
    for edge in topo.edges:
        for p in (edge.pts[0], edge.pts[-1]):
            x, y = p
            d.ellipse([x - 4, y - 4, x + 4, y + 4],
                      fill=PALETTE["tap"] + (255,), outline=(60, 40, 0, 255))

    out = Image.alpha_composite(im.convert("RGBA"), ov).convert("RGB")
    out.save(out_path)


# --------------------------------------------------------------------------- #
# Default topology = the modified CIGRE MV figure (seeds = human read)
# --------------------------------------------------------------------------- #
def cigre_mv_topology() -> Topology:
    B = Bus
    buses = [
        B("0", "h", 95, 243, 697), B("1", "h", 207, 276, 359),
        B("2", "h", 269, 276, 344), B("3", "h", 365, 195, 449),
        B("4", "h", 409, 130, 262), B("5", "h", 466, 129, 207),
        B("6", "h", 621, 403, 472), B("7", "h", 498, 350, 454),
        B("8", "h", 557, 383, 460), B("9", "v", 307, 545, 592),
        B("10", "h", 514, 232, 290), B("11", "h", 466, 222, 289),
        B("12", "h", 208, 617, 686), B("13", "h", 340, 618, 687),
        B("14", "h", 422, 617, 687),
    ]
    E = Edge
    edges = [
        E("2.8 km", [(310, 207), (310, 269)]),
        E("4.4 km", [(310, 269), (310, 365)]),
        E("0.6 km", [(226, 365), (226, 409)]),
        E("0.6 km", [(173, 409), (173, 466)]),
        E("1.5 km", [(173, 466), (173, 691)]),
        E("1.3 km", [(394, 365), (394, 498)]),
        E("1.7 km", [(416, 498), (416, 557)]),
        E("0.5 km", [(257, 409), (257, 466)]),          # S3 -> 11
        E("0.3 km", [(257, 466), (257, 514)]),          # 11 -> 10
        E("0.8 km", [(257, 514), (257, 576), (307, 576)]),   # 10 -> bus9
        E("0.3 km", [(307, 576), (360, 576), (360, 498)]),   # bus9 -> 7
        E("0.2 km", [(440, 557), (440, 621)]),
        E("",       [(440, 621), (440, 691)]),          # loop close
        E("",       [(173, 691), (440, 691)]),          # bottom loop rail
        E("2.0 km", [(435, 498), (435, 531), (652, 531), (652, 422)]),
        E("4.9 km", [(652, 208), (652, 340)]),
        E("3.0 km", [(652, 340), (652, 422)]),
    ]
    feeders = [
        [(310, 150), (310, 207)], [(652, 150), (652, 208)],     # 110/20 kV
        [(412, 621), (412, 628)], [(676, 422), (676, 433)],     # LV transformer leads (LV2 vertical, right of bus14)
        [(307, 583), (323, 583), (323, 609)],                   # bus9 elbow load (taps interior)
        [(310, 95), (310, 113)], [(310, 131), (310, 150)],      # HV lead: bus0->Q1->T1
        [(652, 95), (652, 113)], [(652, 131), (652, 150)],      # HV lead: bus0->Q2->T2
        [(460, 64), (460, 95)],                                 # external grid -> HV busbar
    ]
    switches = [("S1", 540, 525), ("S2", 440, 592), ("S3", 250, 440),
                ("Q1", 306, 122), ("Q2", 647, 122)]   # HV breakers on top
    transformers = [("T1", 310, 159, 177, 13), ("T2", 651, 159, 177, 13),
                    ("LV1", 412, 628, 654, 13), ("LV2", 676, 433, 455, 11)]  # 20/0.4 kV
    loads = [("L1", 288, 235), ("L12", 624, 236), ("L13", 625, 368),
             ("L3", 310, 391), ("L4", 146, 437), ("L14", 628, 450),
             ("L11", 231, 494), ("L10", 231, 541), ("L8", 393, 576),
             ("L6", 461, 644), ("L5", 148, 497), ("L7", 394, 520)]   # load arrows (tip near each bus)
    grid = [("Grid", 439, 21, 481, 64)]   # external grid source block
    pv = [("PV1", 326, 208, 338, 232), ("PV2", 326, 269, 338, 294),
          ("PV11", 270, 466, 281, 490), ("PV12", 671, 208, 683, 231),
          ("PV13", 671, 340, 683, 364)]   # blue PV-panel symbols
    return Topology(buses, edges, feeders, switches, transformers,
                    loads=loads, external_grid=grid, pv=pv)


# --------------------------------------------------------------------------- #
def main():
    inp = sys.argv[1] if len(sys.argv) > 1 else "input.png"
    outp = sys.argv[2] if len(sys.argv) > 2 else "annotated.png"
    im, dark, _blue = build_masks(inp)
    topo = cigre_mv_topology()

    report = refine_all(dark, topo)

    bus_cov = np.mean([v[1] for v in report["buses"].values()])
    edge_cov = np.mean([v[1] for v in report["edges"].values()])
    print(f"Mean bus coverage  : {bus_cov:.3f}  (error {1-bus_cov:.3f})")
    print(f"Mean line coverage : {edge_cov:.3f}  (error {1-edge_cov:.3f})")
    worst = sorted(report["buses"].items(), key=lambda kv: kv[1][1])[:3]
    print("Lowest-coverage buses (before, after):",
          {k: v for k, v in worst})

    render(im, topo, outp)
    print(f"Wrote {outp}")


if __name__ == "__main__":
    main()


# =========================================================================== #
# EXTENSION 1 — JSON/YAML topology I/O  (usability; should not change accuracy)
# =========================================================================== #
import json

def topo_to_dict(topo: "Topology") -> dict:
    return {
        "buses":  [dict(label=b.label, orient=b.orient, coord=b.coord,
                        a=b.a, b=b.b) for b in topo.buses],
        "edges":  [dict(label=e.label, pts=[list(p) for p in e.pts])
                   for e in topo.edges],
        "feeders":[[list(p) for p in stub] for stub in topo.feeders],
        "switches":[list(s) for s in topo.switches],
        "transformers":[list(t) for t in topo.transformers],
        "generators":[list(g) for g in topo.generators],
        "loads":[list(l) for l in topo.loads],
        "external_grid":[list(g) for g in topo.external_grid],
        "pv":[list(p) for p in topo.pv],
    }

def topo_from_dict(dd: dict) -> "Topology":
    buses = [Bus(**b) for b in dd["buses"]]
    edges = [Edge(e["label"], [tuple(p) for p in e["pts"]]) for e in dd["edges"]]
    feeders = [[tuple(p) for p in stub] for stub in dd.get("feeders", [])]
    switches = [tuple(s) for s in dd.get("switches", [])]
    transformers = [tuple(t) for t in dd.get("transformers", [])]
    generators = [tuple(g) for g in dd.get("generators", [])]
    loads = [tuple(l) for l in dd.get("loads", [])]
    grid = [tuple(g) for g in dd.get("external_grid", [])]
    pv = [tuple(p) for p in dd.get("pv", [])]
    return Topology(buses, edges, feeders, switches, transformers, generators, loads, grid, pv)

def save_topology(topo: "Topology", path: str):
    with open(path, "w") as fh:
        json.dump(topo_to_dict(topo), fh, indent=2)

def load_topology(path: str) -> "Topology":
    with open(path) as fh:
        return topo_from_dict(json.load(fh))


# =========================================================================== #
# EXTENSION 2 — true 2-D RANSAC segment fit (handles skewed / rotated scans)
# =========================================================================== #
def ransac_line_2d(pts: np.ndarray, tol: float = 2.0, iters: int = 400,
                   min_inliers: int = 15, seed: int = 0):
    """
    Fit a free-orientation line a*x+b*y+c=0 to 2-D dark points by RANSAC, then
    refine the inliers by total-least-squares (PCA). Returns dict with the unit
    direction, the two endpoints (a,b) of the inlier segment, and inlier count.
    Unlike `ransac_const` (which assumes axis-aligned), this follows any tilt.
    """
    n = len(pts)
    if n < 2:
        return None
    rng = np.random.default_rng(seed)
    best_inl, best_n = None, -1
    for _ in range(iters):
        i, j = int(rng.integers(n)), int(rng.integers(n))
        if i == j:
            continue
        p, q = pts[i].astype(float), pts[j].astype(float)
        d = q - p
        L = np.hypot(*d)
        if L < 1e-6:
            continue
        nrm = np.array([-d[1], d[0]]) / L           # unit normal
        dist = np.abs((pts - p) @ nrm)
        inl = dist <= tol
        if inl.sum() > best_n:
            best_n, best_inl = int(inl.sum()), inl
    if best_n < min_inliers:
        return None
    P = pts[best_inl].astype(float)
    c = P.mean(axis=0)
    _, _, vt = np.linalg.svd(P - c)
    direction = vt[0]                                # principal axis (unit)
    t = (P - c) @ direction
    a_pt, b_pt = c + direction * t.min(), c + direction * t.max()
    return dict(center=c, dir=direction, a=a_pt, b=b_pt, inliers=best_n)


def coverage_2d(dark: np.ndarray, a, b, half: int = 2, samples: int | None = None):
    """Coverage along an arbitrarily-oriented segment a->b (perp tolerance)."""
    a = np.asarray(a, float); b = np.asarray(b, float)
    seg = b - a
    L = float(np.hypot(*seg))
    if L < 1:
        return 0.0
    n = samples or max(2, int(L))
    perp = np.array([-seg[1], seg[0]]) / L
    H, W = dark.shape
    hit = 0
    for t in np.linspace(0, 1, n):
        base = a + seg * t
        ok = False
        for s in range(-half, half + 1):
            x = int(round(base[0] + perp[0] * s))
            y = int(round(base[1] + perp[1] * s))
            if 0 <= y < H and 0 <= x < W and dark[y, x]:
                ok = True; break
        hit += ok
    return hit / n


def refine_bus_2d(dark, bus: "Bus", win: int = 6, tol: float = 2.0):
    """
    2-D RANSAC refinement of a bar. Gathers dark pixels in a box around the seed
    segment and fits a free-orientation line. Returns (a_pt, b_pt, coverage).
    """
    if bus.orient == "h":
        y0, y1 = bus.coord - win, bus.coord + win
        x0, x1 = min(bus.a, bus.b) - 5, max(bus.a, bus.b) + 5
    else:
        x0, x1 = bus.coord - win, bus.coord + win
        y0, y1 = min(bus.a, bus.b) - 5, max(bus.a, bus.b) + 5
    H, W = dark.shape
    y0, y1 = max(0, y0), min(H, y1 + 1)
    x0, x1 = max(0, x0), min(W, x1 + 1)
    ys, xs = np.where(dark[y0:y1, x0:x1])
    pts = np.column_stack([xs + x0, ys + y0])
    fit = ransac_line_2d(pts, tol=tol)
    if fit is None:
        return None, None, 0.0
    cov = coverage_2d(dark, fit["a"], fit["b"], half=2)
    return fit["a"], fit["b"], cov


# =========================================================================== #
# EXTENSION 3 — 2-D-aware line refinement (re-find tilted conductors)
# =========================================================================== #
def _oriented_points(dark, p0, p1, half_box):
    """Dark pixels within `half_box` perpendicular of the seed segment p0->p1."""
    p0 = np.array(p0, float); p1 = np.array(p1, float)
    seg = p1 - p0; L = float(np.hypot(*seg))
    if L < 1:
        return np.empty((0, 2))
    u = seg / L; nrm = np.array([-u[1], u[0]])
    H, W = dark.shape
    xs, ys = [p0[0], p1[0]], [p0[1], p1[1]]
    x0 = int(max(0, min(xs) - half_box - 2)); x1 = int(min(W, max(xs) + half_box + 3))
    y0 = int(max(0, min(ys) - half_box - 2)); y1 = int(min(H, max(ys) + half_box + 3))
    yy, xx = np.where(dark[y0:y1, x0:x1])
    P = np.column_stack([xx + x0, yy + y0]).astype(float)
    if len(P) == 0:
        return P
    rel = P - p0
    lon = rel @ u; per = np.abs(rel @ nrm)
    return P[(lon >= -2) & (lon <= L + 2) & (per <= half_box)]


def fit_segment_line(dark, p0, p1, half_box=10, tol=2.0, min_inliers=8):
    """Return (center, unit_dir) of the conductor near p0->p1, or None."""
    pts = _oriented_points(dark, p0, p1, half_box)
    if len(pts) < min_inliers:
        return None
    fit = ransac_line_2d(pts, tol=tol, min_inliers=min_inliers)
    if fit is None:
        return None
    return fit["center"], fit["dir"]


def _intersect(c1, u1, c2, u2):
    M = np.array([[u1[0], -u2[0]], [u1[1], -u2[1]]])
    if abs(np.linalg.det(M)) < 1e-6:
        return None
    t = np.linalg.solve(M, np.array([c2[0] - c1[0], c2[1] - c1[1]]))
    return c1 + t[0] * u1


def _project(c, u, p):
    p = np.array(p, float)
    return c + ((p - c) @ u) * u


def refine_edge_2d(dark, pts, half_box=10):
    """
    2-D refine an edge polyline: fit each segment's supporting line, then rebuild
    vertices (endpoints = projection onto their line; interior = intersection of
    adjacent fitted lines). Falls back to the seed direction where no fit exists.
    Unlike `refine_edge`, this follows tilted conductors instead of only H/V.
    """
    lines = []
    for i in range(len(pts) - 1):
        res = fit_segment_line(dark, pts[i], pts[i + 1], half_box=half_box)
        if res is None:                                  # fallback to seed line
            p0 = np.array(pts[i], float); p1 = np.array(pts[i + 1], float)
            u = (p1 - p0) / (np.hypot(*(p1 - p0)) + 1e-9)
            res = (p0, u)
        lines.append(res)
    new = [None] * len(pts)
    new[0] = _project(*lines[0], pts[0])
    new[-1] = _project(*lines[-1], pts[-1])
    for i in range(1, len(pts) - 1):
        inter = _intersect(*lines[i - 1], *lines[i])
        new[i] = inter if inter is not None else np.array(pts[i], float)
    return [tuple(float(v) for v in p) for p in new]


def polyline_coverage(dark, pts, half=2):
    covs = [coverage_2d(dark, pts[i], pts[i + 1], half=half)
            for i in range(len(pts) - 1)]
    return float(np.mean(covs)) if covs else 1.0


# =========================================================================== #
# EXTENSION 4 — netlist export (nodes + branches for power-flow tools)
# =========================================================================== #
def _parse_impedance(label):
    """Extract R, X from a label like '0.002 + j 0.025 pu' or 'j0.025 pu'."""
    if not label:
        return None
    import re
    s = label.lower().replace(" ", "")
    r = 0.0; x = 0.0
    m = re.match(r"([+-]?\d*\.?\d+)?\+?j([+-]?\d*\.?\d+)", s)
    if m:
        r = float(m.group(1)) if m.group(1) else 0.0
        x = float(m.group(2))
        return dict(r=r, x=x)
    m = re.match(r"j([+-]?\d*\.?\d+)", s)
    if m:
        return dict(r=0.0, x=float(m.group(1)))
    return None


def to_netlist(topo):
    """
    Associate every element with bus nodes (nearest-bar) and return a structured
    netlist. Edges become line branches; transformers become transformer branches
    (HV bus nearest cy_top, LV bus nearest cy_bot); generators and loads attach to
    their nearest bus. Impedance labels like '0.002 + j 0.025 pu' are parsed to r,x.
    """
    nb = lambda p: (_nearest_bus(topo, p).label if topo.buses else None)
    branches = []
    for e in topo.edges:
        z = _parse_impedance(e.label)
        branches.append(dict(type="line", frm=nb(e.pts[0]), to=nb(e.pts[-1]),
                             label=e.label, **(z or {})))
    for t in topo.transformers:
        if len(t) == 5:
            lab, x, cy_t, cy_b, r = t; xt = xb = x
        else:
            lab, xt, cy_t, xb, cy_b, r = t
        branches.append(dict(type="transformer", label=lab,
                             frm=nb((xt, cy_t)), to=nb((xb, cy_b))))
    gens = [dict(bus=nb((x, y)), label=lab) for (lab, x, y, r) in topo.generators]
    loads = [dict(bus=nb((ld[1], ld[2])), label=ld[0]) for ld in topo.loads]
    return dict(buses=[b.label for b in topo.buses],
                branches=branches, generators=gens, loads=loads)


def netlist_text(topo):
    """Human-readable netlist dump."""
    nl = to_netlist(topo)
    out = ["# buses: " + ", ".join(nl["buses"]), "",
           "# branches (from -> to : label  [r, x])"]
    for b in nl["branches"]:
        rx = f"  r={b['r']} x={b['x']}" if "x" in b else ""
        out.append(f"  [{b['type']:11s}] {b['frm']:>3} -> {b['to']:<3} : "
                   f"{b['label']}{rx}")
    out.append("\n# generators (bus : label)")
    out += [f"  {g['bus']} : {g['label']}" for g in nl["generators"]]
    out.append("\n# loads (bus : label)")
    out += [f"  {l['bus']} : {l['label']}" for l in nl["loads"]]
    return "\n".join(out)
