# Replicating an existing figure as a cetz-power diagram

When the goal is to reproduce a specific published one-line (a thesis/paper figure, a
benchmark network), digitise it rather than eyeball it. This is how the IEEE-9 + DVPP
recipe was built.

## 1. Measure the figure in pixel coordinates

You need, for every element, its position in the *source image's* pixel space. The
sibling **`oneline-diagram-annotator`** skill is purpose-built for this — its detector and
RANSAC bar/circle fitters give you exact bus extents, transformer-circle centres, and
machine centres without estimates drifting into the gap between parallel bars. Use it to
produce a table of:

- each **bus**: orientation (h/v), constant axis, and the two span ends — `x[a–b] y=c`;
- each **transformer / machine**: fitted circle centre(s) and radius;
- each **conductor**: the polyline corners;
- each **load/device**: the tap point and arrow direction.

If you don't use that skill, crop the image and overlay a pixel grid (red verticals,
blue horizontals every 10–20 px) to read coordinates by eye — but the fitters are far
more reliable on dense figures.

## 2. Map pixels → cetz coordinates with one helper

Image coordinates are y-**down**; cetz is y-**up**. Define a single mapping and use it
everywhere so the whole figure stays consistent and is trivially re-scalable:

```typst
let s = 0.017            // pixels → cm  (this is your compression knob, see rule 13)
let H = 489              // source image height in px
let P(x, y) = (x * s, (H - y) * s)   // flip y
```

Then every element reads directly from the measured pixel numbers:

```typst
bus("b7", P(281, 38), P(281, 83))                 // vertical bus, px-exact
transformer("t27", P(187, 60.5), P(281, 60.5))    // leads land on the two bus centres
machine("sg2", P(141, 60.5), ...)                  // fitted circle centre
wire(P(281, 84), P(281, 104))                      // measured conductor corner
```

## 3. Apply the design rules on top of the raw measurements

The figure's own geometry is the *starting point*, not the spec. Improve on it:

- snap perpendicular drops onto bus **centres / interiors** (rules 2–3) even if the
  original is a hair off;
- give shared up/down stubs **one collinear x** (rule 5);
- make funnels **perpendicular** with stubs + diagonal (rule 4) and **mirror-symmetric**
  (rule 7) — compute the mirror x as `2*axis − x`;
- balance each bus's taps and **resize the bar** for equal edge margins (rule 6);
- keep loads small and correctly aimed (rule 8).

These often mean nudging a measured coordinate by a few px or recomputing a span — that's
expected. Keep the pixel numbers in comments so the mapping stays auditable.

## 4. Compress with `s`, then re-check

`s` scales the whole layout. Shrinking it shortens every line while the absolute-sized
symbols stay put (rule 13). After changing `s`, **re-verify**: fixed-size symbols grow
relative to the shrunk layout, so a transformer that cleared an area-box edge before may
now intersect it (rule 11) — shrink the largest symbols and reposition the box edge.

## 5. Verify by rendering and zooming

```bash
typst compile --root . docs/snippets/recipes/<name>.typ /abs/out.png --ppi 200
```

Then crop and view the dense clusters (a funnel junction, a 3-tap bus, the device row,
any area-box boundary). Compare against the source figure. Iterate rule-by-rule. A
snap-confined `typst` (e.g. from a snap install) often **cannot write to `/tmp`** — write
the PNG inside the repo (e.g. an ignored `out/` dir) instead.

## Worked reference

`assets/recipe-ieee9-dvpp.typ` (copied into this skill) is a complete, reviewed example
of this whole workflow: a `P(x,y)` pixel map, perpendicular mirror-symmetric funnels,
collinear shared verticals, 3-equidistant-tap buses, connected device boxes, an area box
the leads cross but symbols clear, and a compressed `s`. Read it alongside these rules.
