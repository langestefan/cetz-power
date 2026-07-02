---
name: cetz-power-diagrams
description: >-
  Author power-system single-line (one-line) diagrams as Typst/CeTZ code with the
  cetz-power package — buses, transformers, machines, loads, switches/breakers, windings,
  PV/wind/BESS blocks, feeders and DALI meters. Use whenever someone wants to draw, build,
  author, or code a power one-line / SLD / substation or feeder schematic / network
  diagram in Typst or cetz-power, replicate a published network figure (IEEE, CIGRE MV/LV)
  as a cetz-power plot, add a recipe/example to the cetz-power package, or fix the layout
  of an existing one (alignment, perpendicular joins, balanced taps, compression, overlaps).
  Distinct from the oneline-diagram-annotator skill, which annotates a raster image — this
  one writes the vector diagram.
---

# Drawing power single-line diagrams with cetz-power

`cetz-power` is a Typst package (a thin wrapper over CeTZ) for power-system single-line
diagrams. This skill is the distilled know-how for authoring clean ones: the symbol API,
the composition patterns the package's own recipes use, and — most importantly — the
**design rules** that make a diagram look professional rather than rough.

## When to use it

Any request to **draw / build / author / code** a power one-line diagram, SLD, substation
or feeder schematic, or network figure in Typst; to **replicate** a benchmark network
(IEEE 9-bus, CIGRE MV/LV, …) as a cetz-power plot; to **add a recipe** to the package; or
to **clean up** an existing diagram's geometry. (To annotate a *raster image* of a diagram
instead, use the `oneline-diagram-annotator` skill.)

## Orientation: the absolute minimum

```typst
#import "@preview/cetz-power:0.1.0": *      // or "/src/lib.typ" inside the repo
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1cm, {                      // diagram{} is REQUIRED (seeds the styles)
  bus("hv", (0, 0), length: 2, label: [HV])
  transformer("t", "hv.mid", (0, -1.5))      // 2-node: spans, orients, draws leads
  bus("lv", (-1, -1.5), (1, -1.5), taps: 3)  // 2-node bus with 3 tap anchors
  wire("t.out", "lv.tap2")
  load("l", "lv.tap1", label: [5 MW])        // 1-node load arrow
})
```

Compile and **look at the result** (zoom the dense parts):
```bash
typst compile --root . file.typ out.png --ppi 200   # snap typst can't write /tmp — use repo
```

## Read these references (in `references/`)

- **`design-rules.md`** — START HERE. The 15 hard-won rules: tap bus interiors/centres,
  perpendicular joins (stub→diagonal→stub), collinear shared verticals, balanced/equidistant
  taps, mirror symmetry, small correctly-aimed loads, use built-in symbols not hand-drawing,
  connect device boxes, keep symbols clear of area boxes, no overlaps, compress by scaling
  the layout, symmetric overshoot. **Plus the authoring loop.** Every diagram should satisfy
  these; most review feedback maps directly to one.
- **`symbol-catalog.md`** — every exported symbol/helper: signature, defaults, anchors,
  1-node vs 2-node, and gotchas. Consult before using a symbol you don't have memorized.
- **`composition-patterns.md`** — how the package's recipes are structured: constants-first,
  helper closures (`nl`, `dl`, `ticks`, `link`, `bbar`, `lvfeed`), anchors + relative
  placement, parametric tap grids, `multi-wire`/`feeder`/`dali`, semantic colour, the
  three-layer style cascade.
- **`replicating-figures.md`** — the pixel-map workflow (`P(x,y) = (x*s, (H-y)*s)`) for
  reproducing a published figure exactly; pairs with the `oneline-diagram-annotator` skill
  for measuring coordinates.

## Worked example

`assets/recipe-ieee9-dvpp.typ` is a complete, reviewed diagram (modified IEEE 9-bus +
MV/DVPP grid) that exercises essentially every rule: a pixel map, perpendicular
mirror-symmetric funnels, collinear shared verticals, three-equidistant-tap buses,
`voltagesource(kind:"sin")` machines, connected wind/BESS/PV blocks, a dashed area box the
leads cross but the symbols clear, and a compressed scale. Read it next to `design-rules.md`
— it is the canonical template for a from-scratch network diagram.

## Where the package lives

The package source (with ~12 recipes and ~120 symbol snippets under `docs/snippets/`) is a
separate repo — when working inside it, import `/src/lib.typ` and add new diagrams under
`docs/snippets/recipes/`. Its `CLAUDE.md` documents the architecture (the `symbol()`
primitive, style resolution, bus/wire specifics, the docs build). The example snippets are
the best source of idioms beyond what's captured here; grep them for a symbol to see real
usage.

## Workflow summary

1. **Plan** the skeleton: buses (orientation + rough place), then conductors, then
   transformers/machines/loads. 2. **Lay out** coordinates — clean cm values, or a pixel map
   when replicating. 3. **Draw** back-to-front: area boxes → buses → transformers → machines
   + stubs → conductors → loads → captions. 4. **Compile and zoom.** 5. **Iterate
   rule-by-rule** against `design-rules.md` until every join is perpendicular and interior,
   taps are balanced, devices are connected, and nothing overlaps.
