# Composition patterns (how the recipes are built)

Distilled from the package's `docs/snippets/recipes/*.typ`. Every recipe is built the
same way: **constants first, helpers for repetition, anchors + relative positioning,
semantic colour, orthogonal routing, parametric spacing.**

## The shared skeleton

```typst
#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)   // auto page shrinks to content
#set text(size: 8pt)                                  // 6.5–9pt by density

#diagram(length: 1cm, {                               // length = cm-per-unit
  // 1. palette + layout constants + helper closures
  // 2. area boxes (drawn first → behind)
  // 3. buses, transformers, machines, conductors, loads, captions
})
```

## Layout constants before drawing

Bind every position/dimension/spacing up front so the diagram is parametric:

```typst
let x-ms = 4.0; let ytop = 0; let gap = 0.5
let tapy(i) = ytop - i * gap        // indexed spacing — never hardcode each coord
let n = 6; let ybot = ytop - (n - 1) * gap
```

## Helper closures for any repeated composition

If a sequence appears more than once, make it a `let` closure. Canonical ones seen across
recipes (define the ones you need; names are conventional):

```typst
// node label beside a point, on a chosen side
let nl(p, c, s) = note(p, text(size: 6pt)[#c], side: s, distance: 0.16)
// distance/length label on a segment — note's segment form picks the
// perpendicular side itself and turns east/west labels upright
let dl(a, b, c, s) = note(a, b, c, side: s, distance: 0.15, size: 5pt)
// three diagonal phase-conductor ticks across a segment
let ticks(p, ang) = cetz.draw.group({
  cetz.draw.set-origin(p); cetz.draw.rotate(ang)
  for o in (-0.07, 0, 0.07) { cetz.draw.line((o - 0.06, -0.085), (o + 0.06, 0.085), stroke: 0.7pt) }
})
// a phase-marked line + length label in one call
let link(a, b, lbl, lside, ang) = { wire(a, b); ticks((a, 35%, b), ang); dl(a, b, lbl, lside) }
// horizontal busbar centred at (x,y) with half-length hl
let bbar(name, x, y, hl) = bus(name, (x - hl, y), (x + hl, y))
// a blue LV transformer dropping off a bus point, with a load below
let lvfeed(name, p) = {
  let top = (rel: (0, -0.12), to: p); let bot = (rel: (0, -0.58), to: p)
  cetz.draw.line(p, top, stroke: blue)
  transformer(name, top, bot, radius: 0.13, distance: 0.16, stroke: blue)
  load(name + "-l", bot, fill: blue, stroke: blue, size: 0.14, lead: 0.12)
}
```

## Anchors + relative positioning (no bare absolute coords in the body)

Name every bus/symbol, then address sub-parts by anchor and place downstream parts
relative to them:

```typst
transformer("t1", (0,0), (2.5,0))
bus("hv", "t1.primary", length: 1.2, angle: 90deg, label: [HV])   // primary = in
bus("lv", "t1.secondary", length: 1.2, angle: 90deg, label: [LV]) // secondary = out
machine("M1", (rel: (2.5, 0), to: "b.tap6"), "M")                 // relative placement
wire("b1.mid", "b2.mid")
```

Bus anchors: `start`, `mid`, `end`, and `tap1..tapN` when called with `taps: N`.
`bus-frac("b", f)` is an ad-hoc fractional point (the `f` is multiplied by `100%`
internally — a plain float would be read as an absolute distance).

## Parametric grids: evenly-spaced taps and cable bundles

```typst
// indexed tap positions
let nodes(start, n, step, dir) = range(n).map(i => (rel: vector.scale(dir, i*step), to: start))
// fan count wires off a bus, occupying a fractional band on both bars
let band = (lo, 1 - lo)
multi-wire("osms", "rsms", count: n, from: band, to: band)
// free stubs (departing feeders, no facing bar): target is a (dx,dy) offset
multi-wire("uit", (out-len, 0), count: n, from: band)
```

## Composite helpers the library already ships

- `feeder(name, start, stations, currents:, lead:, spacing:, tail:, drop:, drop-angle:)`
  — a whole distribution run: spine + evenly-spaced taps + per-tap transformer/load drop
  + per-segment current labels + dashed continuation.
- `dali(name, pos, width:, lead:, tail:, box-width:, box-height:, ...)` — a CT-clamp +
  voltage-transformer + labelled metering box hanging off a line.
- `note`, `multi-wire` — see above.

Reach for these before composing by hand; see `recipe-feeder-compensation`,
`recipe-reactive-flow`, `recipe-ms-transport`.

## Semantic colour

Colour encodes **role**, not decoration: HV green, MV/LV blue, faults red, firm load
black, flexible/PV blue. Bind the palette once at the top (`let g = green.darken(20%)`)
and pass via per-call `stroke:` / `fill:` overrides — or a family `set-style`.

## Three layers of styling

```typst
cetz.draw.set-style(cetz-power: (stroke: 1.2pt))              // 1. global (all symbols)
cetz.draw.set-style(cetz-power: (transformer: (radius: 0.5)))// 2. per-family
transformer("t", a, b, radius: 0.5, stroke: red)             // 3. per-call (wins)
```

`resolve-style` only flattens *scalar* top-level keys; dict keys like `label:` are not
auto-flattened. A family dict may carry its own `label:` sub-dict.

## Routing: orthogonal only

Keep runs horizontal/vertical with `elbow(a, b, corner: "h"|"v")` or multi-segment
`wire` polylines. A link whose endpoints differ in both x and y renders as an unwanted
diagonal — and a diagonal into a busbar is wrong (see `design-rules.md` rule 4).
