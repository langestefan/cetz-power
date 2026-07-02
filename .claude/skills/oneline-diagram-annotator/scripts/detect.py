"""
detect.py — first-pass geometry detection for one-line / single-line diagrams.

Prints candidate BUSES (horizontal & vertical bars), NODE DOTS (filled junctions),
CONDUCTOR COLUMNS/ROWS (line runs) and TOP-CHAIN symbols (switch/transformer) so an
agent can assemble a Topology spec quickly instead of eyeballing every coordinate.

Usage:
    python detect.py path/to/diagram.png
    python detect.py path/to/diagram.png --region x0 y0 x1 y1   # zoom a sub-area

Nothing here is authoritative — it is a SEEDING aid. Always sanity-check the
candidates against the actual image (crop & view) before trusting them, and feed
the seeds into annotator.refine_all(), which RANSAC-locks and coverage-refines them.
"""
import sys
import numpy as np
from PIL import Image

try:
    from scipy import ndimage
    from scipy.ndimage import uniform_filter
    HAVE_SCIPY = True
except Exception:
    HAVE_SCIPY = False


def masks(path, dark_thr=105):
    im = Image.open(path).convert("RGB")
    a = np.asarray(im).astype(int)
    R, G, B = a[..., 0], a[..., 1], a[..., 2]
    dark = (R < dark_thr) & (G < dark_thr) & (B < dark_thr)
    blue = (B > 110) & (B - R > 40) & (B - G > 25)   # load arrows / flex devices
    return im, dark, blue


def _runs(line, ml):
    out, s = [], None
    for i, v in enumerate(line):
        if v and s is None:
            s = i
        elif not v and s is not None:
            if i - 1 - s >= ml:
                out.append((s, i - 1))
            s = None
    if s is not None and len(line) - s >= ml:
        out.append((s, len(line) - 1))
    return out


def horizontal_bars(dark, min_len=55, merge_y=4):
    H, W = dark.shape
    cand = []
    for y in range(H):
        for s, e in _runs(dark[y], min_len):
            cand.append((y, s, e))
    cand.sort()
    used = [False] * len(cand); out = []
    for i, (y, s, e) in enumerate(cand):
        if used[i]:
            continue
        Y, S, E = [y], [s], [e]; used[i] = True
        for j in range(i + 1, len(cand)):
            if used[j]:
                continue
            y2, s2, e2 = cand[j]
            if y2 - y > merge_y:
                break
            if not (e2 < s - 8 or s2 > e + 8):
                Y.append(y2); S.append(s2); E.append(e2); used[j] = True
        out.append((int(np.mean(Y)), min(S), max(E)))
    return sorted(out)


def vertical_bars(dark, min_len=28, merge_x=3):
    H, W = dark.shape
    segs = []
    for x in range(W):
        col = dark[:, x]
        s = None
        for y, v in enumerate(col):
            if v and s is None:
                s = y
            elif not v and s is not None:
                if y - 1 - s >= min_len:
                    segs.append((x, s, y - 1))
                s = None
        if s is not None and H - s >= min_len:
            segs.append((x, s, H - 1))
    segs.sort()
    used = [False] * len(segs); out = []
    for i, (x, y0, y1) in enumerate(segs):
        if used[i]:
            continue
        X, A, B = [x], [y0], [y1]; used[i] = True
        for j in range(i + 1, len(segs)):
            if used[j]:
                continue
            x2, a0, a1 = segs[j]
            if x2 - x > merge_x:
                break
            if not (a1 < y0 - 6 or a0 > y1 + 6):
                X.append(x2); A.append(a0); B.append(a1); used[j] = True
        out.append((int(np.mean(X)), min(A), max(B)))
    return sorted(out)


def node_dots(dark, min_size=6):
    """Filled junction dots = nearly-solid local neighbourhoods."""
    if not HAVE_SCIPY:
        return []
    dens = uniform_filter(dark.astype(float), size=5)
    lbl, n = ndimage.label(dens > 0.85)
    if n == 0:
        return []
    cents = ndimage.center_of_mass(dark > -1, lbl, range(1, n + 1))
    sizes = ndimage.sum(dens > 0.85, lbl, range(1, n + 1))
    dots = [(int(x), int(y)) for (y, x), s in zip(cents, sizes) if s >= min_size]
    return sorted(dots, key=lambda p: (p[1], p[0]))


def main():
    if len(sys.argv) < 2:
        print(__doc__); return
    path = sys.argv[1]
    im, dark, blue = masks(path)
    if "--region" in sys.argv:
        i = sys.argv.index("--region")
        x0, y0, x1, y1 = map(int, sys.argv[i + 1:i + 5])
        sub = np.zeros_like(dark); sub[y0:y1, x0:x1] = dark[y0:y1, x0:x1]; dark = sub

    print(f"# image {im.size[0]}x{im.size[1]}")
    print("\n## horizontal bars  (y, x0-x1, width)")
    for y, a, b in horizontal_bars(dark):
        print(f"  y={y:4d}  x[{a}-{b}]  w={b-a}")
    print("\n## vertical bars / conductor columns  (x, y0-y1, length)")
    for x, a, b in vertical_bars(dark):
        print(f"  x={x:4d}  y[{a}-{b}]  len={b-a}")
    print("\n## node dots  (x, y)")
    for x, y in node_dots(dark):
        print(f"  ({x},{y})")
    by, bx = np.where(blue)
    if len(bx):
        print(f"\n## blue elements (loads / flexible devices): {len(bx)} px, "
              f"x[{bx.min()}-{bx.max()}] y[{by.min()}-{by.max()}]  "
              "(cluster with scipy.ndimage.label for individual markers)")


if __name__ == "__main__":
    main()
