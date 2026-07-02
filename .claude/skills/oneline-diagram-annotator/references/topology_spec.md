# Topology spec — schema & worked example

The engine (`annotator.py`) is driven by a `Topology` you build from the image.
This file is the full reference; read it before assembling a spec.

## Dataclasses

```python
from annotator import Bus, Edge, Topology

Bus(label, orient, coord, a, b)
#   label : str               node name, e.g. "3" or "LV"
#   orient: "h" | "v"         bar orientation
#   coord : int               constant axis  (y if horizontal, x if vertical)
#   a, b  : int               span endpoints (x0,x1 if horizontal; y0,y1 if vertical)

Edge(label, pts)
#   label : str               length text e.g. "2.8 km" / "35m"  ("" = unlabeled)
#   pts   : [(x, y), ...]     polyline; straight H/V sub-segments get snapped

Topology(buses, edges, feeders=[], switches=[], transformers=[],
         generators=[], loads=[])
#   feeders     : [[(x,y),(x,y), ...], ...]   black stubs (machine leads, load drops)
#   switches    : [(label, x, y), ...]        teal markers seated on a conductor
#   transformers: [(label, x, cy_top, cy_bot, r), ...]   vertical 2-winding double-circle
#                 OR (label, x1, y1, x2, y2, r) for circles offset along a diagonal lead
#   generators  : [(label, x, y, r), ...]     indigo single circle (rotating machine)
#   loads       : [(label, x, y[, dir]), ...] arrow at (x,y); dir in down/up/left/right
#   external_grid:[(label, x0, y0, x1, y1), ...] source block, drawn as a box
#   pv          : [(label, x0, y0, x1, y1), ...] PV panel, box + downward chevron
```

## Netlist export

```python
A.netlist_text(topo)   # readable dump (buses, branches with r/x, generators, loads)
A.to_netlist(topo)     # structured dict, elements mapped to nearest bus
```
Impedance labels (`"0.002 + j 0.025 pu"`, `"j0.025 pu"`) are parsed to `r,x`.
Anchor each load's `(x,y)` near the bus it taps — an arrow tip can be closer to the
next bus down and get mis-assigned.

## Conventions that matter

- **Image coordinates**: x→right, y→**down**. (0,0) is top-left.
- **One Edge per inter-node hop.** Tap points are drawn at every Edge endpoint, so
  splitting a feeder into per-hop edges makes each node a visible tap. A single
  multi-vertex Edge only taps its two ends.
- **Tap into bus interiors.** Set an Edge's bus-end x (or y) to the detected
  conductor column, which lands inside the bar — not at `a` or `b`.
- **L-shaped routes** are just polylines with a corner vertex, e.g.
  `Edge("0.8 km", [(257,514),(257,576),(307,576)])` (down then across into a bus).

## Refinement & rendering

```python
import annotator as A
im, dark, _ = A.build_masks(path)
topo = ...                          # your spec
report = A.refine_all(dark, topo)   # axis-aligned RANSAC lock + coverage fine-tune
A.render(im, topo, "out.png")

# report["buses"][label]  -> (coverage_before, coverage_after)
# report["edges"][label]  -> (coverage_before, coverage_after)
```

Skewed scans: replace per-element refinement with `refine_bus_2d` /
`refine_edge_2d` (see SKILL.md Step 6).

## JSON I/O

```python
A.save_topology(topo, "net.json")   # serialise
topo = A.load_topology("net.json")  # reload (round-trips exactly)
```

JSON shape:
```json
{
  "buses":  [{"label":"3","orient":"h","coord":365,"a":195,"b":449}],
  "edges":  [{"label":"1.3 km","pts":[[394,365],[394,498]]}],
  "feeders":[[[310,150],[310,207]]],
  "switches":[["S1",540,525]],
  "transformers":[["T1",310,159,177,13]]
}
```

## Minimal end-to-end example

```python
import annotator as A
from annotator import Bus, Edge, Topology

im, dark, _ = A.build_masks("diagram.png")
topo = Topology(
    buses=[Bus("A","h",100,50,300), Bus("B","h",250,60,200)],
    edges=[Edge("1.0 km", [(120,100),(120,250)])],   # taps interior of both bars
    switches=[("S1",120,180)],
)
print(A.refine_all(dark, topo))
A.render(im, topo, "annotated.png")
```

The bundled `annotator.cigre_mv_topology()` is a complete, real spec (15 buses,
17 edges, 2 transformers, HV breakers) — copy its structure when in doubt.
