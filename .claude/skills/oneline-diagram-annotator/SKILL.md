---
name: oneline-diagram-annotator
description: >-
  Detect and annotate the geometry of single-line / one-line electrical diagrams
  (power-system schematics, CIGRE MV/LV benchmark networks, substation or feeder
  one-lines) from an image, producing a clean colour-blind-safe overlay of buses,
  lines, switches, transformers and tap points plus a structured topology. Use this
  whenever the user uploads or points to a schematic and asks to analyse, trace,
  digitise, label, annotate, or "draw" the network, estimate where buses/lines/
  switches are, extract a topology/netlist, or overlay components on the figure —
  even if they don't say the word "skill". Strongly prefer this over eyeballing
  coordinates or free-handing an SVG: the bundled engine RANSAC-locks each bar/
  conductor onto real ink and coverage-refines it, which avoids the classic
  failure of estimates drifting into the gap between two parallel bars.
---

# One-line Diagram Annotator

Reading a power-system one-line diagram by pixel is mostly easy except for one
recurring trap: estimates **drift into the gap between two parallel bars or
conductors**, and lines get attached to the *ends* of busbars where they don't
belong. This skill packages an engine that defeats that (RANSAC consensus + a
coverage-maximising fine-tune) plus the reading rules that make the result
correct rather than merely close.

The division of labour is the key idea: **geometry detection is automatic; the
topology is config you assemble from the image.** Don't try to make the script
guess the whole network — your job is to read the structure (which dot is which
node, what connects to what) and hand the engine good seeds, which it then snaps
onto the real ink.

## When to reach for this

Any schematic image where the user wants buses / lines / switches / transformers
located, traced, labelled, digitised, or turned into a topology or netlist. Works
on hand-read benchmark figures (CIGRE MV, CIGRE LV, IEEE feeders) and on textbook
one-lines. If the diagram is a photo or scan that is rotated/skewed, the engine
has a 2-D mode that follows the tilt (see Step 6).

## Workflow

> **Environment:** this skill ships its own virtualenv at `.venv` (created
> automatically on first use, provides `numpy` + `Pillow`). Run **all** Python
> for this skill with `.venv/bin/python` from the skill directory — e.g.
> `.venv/bin/python scripts/detect.py …`, and for the inline `import annotator`
> snippets run them as `.venv/bin/python - <<'PY' … PY` from `scripts/`.

### Step 1 — Look at the image first
Open and actually view the figure (and crop dense regions at 2-4× to read symbols).
Note the overall structure: where is the source/grid, the main bus(es), each
feeder, the switches, the transformers. A prompt implying an image may not include
one — check.

### Step 2 — Auto-seed the geometry
Run the detector to get candidate bars, conductor columns, node dots and blue
load/flex markers:
```bash
.venv/bin/python scripts/detect.py path/to/diagram.png
# zoom a busy area:
.venv/bin/python scripts/detect.py path/to/diagram.png --region 180 360 470 710
```
Treat the output as *seeds*, not truth. Cross-check anything surprising by
cropping that region and viewing it.

### Step 3 — Assemble a Topology spec
Import the engine and build a `Topology` (see `references/topology_spec.md` for the
full schema and a worked example). Minimum pieces:
- `Bus(label, orient, coord, a, b)` — `orient` is `"h"` or `"v"`; `coord` is the
  bar's constant axis (y for horizontal, x for vertical); `a,b` are the span ends.
- `Edge(label, [(x,y), ...])` — a conductor polyline. Give each inter-node hop its
  own `Edge` so every node becomes a tap point.
- `switches` `[(label, x, y), ...]`, `transformers`
  `[(label, x, cy_top, cy_bot, r), ...]`, `feeders` (black stubs/leads).

### Step 4 — Refine and render
```python
import annotator as A
im, dark, _ = A.build_masks(path)
topo = build_my_topology()          # your Step-3 spec
report = A.refine_all(dark, topo)   # RANSAC lock + coverage fine-tune
A.render(im, topo, "annotated.png") # colour-blind-safe overlay
```
`refine_all` returns per-element coverage `(before, after)`.

For 2-winding (double-circle) transformers, don't hand-place the circles — call
`A.fit_transformer(dark, x0, y0, x1, y1)` on a box around the symbol. It models the
two windings as equal-radius circles separated by exactly r (the standard symbol) and
maximises circumference coverage, so it locks the true centres regardless of whether
the transformer is drawn vertically, horizontally or along a diagonal lead, and ignores
the lead crossing the rings. It returns a 6-tuple `(x1,y1,x2,y2,r)` for `transformers`.
Likewise, fit single machine circles with `A.fit_generator(dark, x0, y0, x1, y1)`
(returns `(cx, cy, r)`); give it a box a little larger than the circle so the search
has room. Both fitters score circumference coverage, so they sit on the real ink
rather than an eyeballed centre.

Note two routing limits when reconstructing lines: a shortest-path conductor-graph
router only follows *orthogonal* segments, so **diagonal lines must be added by hand**;
and it cannot cross a transformer (the circles break the conductor), so **branches
through a transformer are drawn as explicit leads**, not routed — if you leave such a
branch in the auto-router it will mis-route the long way round and draw a spurious line. It RANSAC-locks each
bar's position and, by default, grows its span to the ink. Once you've dialed in
exact bus extents by hand, call `A.refine_all(dark, topo, grow=False)` so the
auto-extent doesn't re-grow a bar back into an adjacent label, tick-mark or tap.

### Step 5 — Verify with the coverage metric, then fix the worst
Coverage = fraction of a drawn element sitting on real ink; **error = 1 − coverage**.
Print the report and inspect anything below ~0.9. Low coverage usually means a
seed is wrong, an orientation is wrong (see Reading Rules), or the span runs over a
blue load stub (legitimately non-dark — fine). Re-view that spot, fix the seed,
re-run. Don't ship without looking at the rendered overlay against the original.

### Step 6 — Skewed / rotated scans
If the bars aren't axis-aligned, use the 2-D path instead of the axis-aligned one:
- `A.refine_bus_2d(dark, bus)` → `(a_pt, b_pt, coverage)` fits a free-orientation bar.
- `A.refine_edge_2d(dark, pts)` → re-finds each tilted conductor and rebuilds the
  polyline by intersecting adjacent fitted lines.
These follow the tilt; the axis-aligned `snap_segment` is a no-op on diagonal
segments and will silently leave skewed conductors unrefined.

### Step 7 — Export a netlist (optional)
If the user wants the network for power-flow/simulation, not just an overlay:
```python
print(A.netlist_text(topo))          # readable dump
nl = A.to_netlist(topo)              # structured dict
```
This associates every element with bus nodes by nearest-bar, turns edges into line
branches and transformers into transformer branches, attaches generators/loads to
their bus, and parses impedance labels like `0.002 + j 0.025 pu` into `r,x`.
**Pitfall:** a load arrow's *tip* can sit closer to the next bus down — anchor the
load coordinate near the bus it taps (the arrow root), not the far end of the arrow.

## Reading Rules (learned the hard way — apply every time)

These are the corrections that separate a sloppy overlay from a correct one:

1. **Connections tap the bus *interior*, never its endpoints.** Conductors — and
   load/elbow stubs — connect along a busbar, not at its extreme end. Seed each drop
   at the detected conductor column (or row), comfortably inside `[a,b]`. If a load
   elbow or tap lands on the very end of the bar, it's wrong: move it inward (e.g. a
   vertical bus's bottom load taps a few px above its lower end).
2. **Check bus orientation — some buses are vertical.** A node drawn as a tall bar
   with lines entering its sides is a *vertical* bus (`orient="v"`), not a
   horizontal one. Misreading this is common and makes the overlay look wrong.
3. **Buses extend to their load taps.** A busbar usually runs out to where its load
   arrow / flexible-device taps off (often one end). Detect the bar generously so
   the orange bar reaches that tap rather than stopping short.
4. **Loads can leave a node with an elbow**, not just a straight drop (down, then
   across, then down to the arrow). Render the stub with the bend.
5. **Seat switches on the real conductor.** A switch sits *on* a line. Snap its
   position to the actual conductor y/x (e.g. via `refine_const`) so the marker
   isn't floating a few pixels above the line.
6. **Annotate the whole top chain.** Don't reduce transformer connections to plain
   stubs — mark the **transformer** (2-winding double-circle), the **breaker/switch**
   above it, and the **HV/source bus**. Many diagrams hide these at the top.
7. **A transformer is a branch, not a line.** Mark its symbol for the overlay, but
   in any exported netlist it is a transformer branch (HV node ↔ LV node) with its
   own impedance/tap — not a line segment.
8. **Trust the coverage number but also your eyes.** The metric only checks that ink
   is under the line, not that the *topology* is electrically correct (right node
   labels, right connectivity). Sanity-check dense clusters manually.
9. **Lines are often multi-segment, not a single diagonal.** A bus-to-bus run may go
   horizontal, then diagonal, then vertical into the far bus (and its mirror on the
   other side). Trace the real path row-by-row (`detect.py` columns + a crop) and
   route the polyline through the actual corners — don't approximate it as one
   straight diagonal, or the overlay will float off the conductor.
10. **Rotating-machine circles align with their connection point.** A generator/
    source circle (`S`, `~`) connects to its bus through a short stub at the circle's
    centre height. Place the circle centre on that stub line and add the stub as a
    feeder from the circle edge to the **centre** of the bus — and don't forget the
    stub itself (easy to miss). Detect the circle by its ring centroid, then confirm
    the stub row.
11. **Switch blades have a direction — don't draw them all the same way.** An open
    switch leans `\` or `/`. `render` auto-detects the lean from the image per switch,
    so you usually don't set it; but if you place a switch by hand, pass an explicit
    lean as a 4th tuple element `(label, x, y, "\\")` when the auto-detection can't
    see clean ink. Mirroring every blade the same way is a common, obvious-looking
    error.
12. **Find *all* the loads and devices.** Cluster the coloured (often blue) markers
    and classify: down-arrows are loads, **boxes with a chevron are PV panels**
    (`pv=[...]`), plain boxes are other flexible devices, double-circles are LV
    transformers (`transformers=[...]`). Add every load arrow to `loads=[...]` anchored
    at the bus it taps (arrow root), not the far tip. Load arrows point various ways:
    pass a 4th element `(label, x, y, "left"|"right"|"up"|"down")` so the arrowhead
    faces correctly. Missing a few is easy — verify the count against the figure.
13. **Draw every lead, and lead to the right *point* on the bus.** A device lead is a
    short conductor from the symbol to its bus — e.g. an HV breaker's lead up to the
    HV busbar, or an LV transformer's lead up to a bus. Make it a straight vertical/
    horizontal segment to the actual attachment point (often a bus *side*, not its
    centre), and don't drop the lead entirely (an easy omission for top-of-diagram
    breakers and corner transformers).
14. **Thick bars are buses; thin bars are lines.** On a dense schematic the reliable
    discriminator is stroke weight: a real busbar is drawn bold (ink spans 2+ pixel
    rows/cols), a connecting conductor is a single-pixel line. Detect buses by keeping
    only multi-row/col runs (see `detect.py`'s thickness grouping); otherwise you will
    seed buses onto the lines that merely pass nearby. Also check each bus's
    orientation individually — in a big network some buses are horizontal and some
    vertical, even within the same cluster.
15. **On dense diagrams, place buses exactly and skip auto-refine.** `refine_all`'s
    RANSAC coord-lock helps on clean figures but on a crowded schematic it snaps a bar
    onto a neighbouring parallel line, making buses look displaced or "missing." When
    bars sit close to other ink, seed them precisely from thickness detection and
    render WITHOUT `refine_all` (or with `grow=False` at minimum).

## Output & accessibility

`render` uses a colour-blind-safe palette (no red/green distinction): **orange**
buses, **magenta** lines, **teal** switches/breakers, **violet** transformers,
**black** stubs/loads, **yellow** taps. Keep it. If the user is red-green
colour-blind or asks, this palette already avoids the red/green axis; offer to
push any single colour lighter/darker rather than reintroducing red or green.

Let the figure keep its own text labels when they're legible — don't duplicate
every "35 m" / "R7" with an overlay label, which just clutters. Add overlay labels
only where the original lacks them or you're re-deriving the network.

## Bundled resources
- `scripts/annotator.py` — the engine: masks, RANSAC (`ransac_const`,
  `ransac_line_2d`), coverage fine-tune, bus/edge refinement (axis + 2-D), JSON
  topology I/O (`save_topology`/`load_topology`), `render`, generators/loads, external-grid blocks, and
  `to_netlist`/`netlist_text` for power-flow export. Plus `cigre_mv_topology()` as a
  complete worked spec.
- `scripts/detect.py` — first-pass bar / column / node-dot / blue-marker detector
  for seeding.
- `references/topology_spec.md` — full `Topology` schema, JSON format, and an
  end-to-end example (read this before assembling a spec).
- `references/examples.md` — two complete worked networks (CIGRE MV and CIGRE LV)
  showing how seeds map to the figure.
