#import "/src/lib.typ" as pg

= Getting started

== Installation

Once published to Typst Universe:

```typst
#import "@preview/powergretz:0.1.0" as pg
```

Before publication, or for local development, clone the repository and
import directly from the path:

```typst
#import "path/to/powergretz/src/lib.typ" as pg
```

== Your first diagram

Every diagram is wrapped in `pg.diagram({ ... })`, which is a thin wrapper
around `cetz.canvas` that installs `powergretz`'s default styles. Inside the
block, `import pg: *` brings every symbol into scope.

```typst
#pg.diagram({
  import pg: *
  external-grid("g", (0, 1.3),
    label: (content: [132 kV], anchor: "east", distance: 0.2))
  wire("g.in", (0, 0.7))
  transformer("t", (0, 0.7), (0, -0.7),
    label: (content: [132/11 kV], anchor: "east", distance: 0.2))
  bus("b", (-1, -1.3), (1, -1.3), taps: 5)
  wire("t.out", "b.tap3")
  load("l1", "b.tap2", label: [10 MW])
  load("l2", "b.tap4", label: [8 MW])
})
```

#pg.diagram(length: 1.2cm, {
  import pg: *
  external-grid("g", (0, 1.3),
    label: (content: [132 kV], anchor: "east", distance: 0.2))
  wire("g.in", (0, 0.7))
  transformer("t", (0, 0.7), (0, -0.7),
    label: (content: [132/11 kV], anchor: "east", distance: 0.2))
  bus("b", (-1, -1.3), (1, -1.3), taps: 5)
  wire("t.out", "b.tap3")
  load("l1", "b.tap2", label: [10 MW])
  load("l2", "b.tap4", label: [8 MW])
})

== Anchors

Every symbol exposes named anchors you can use as coordinates in subsequent
calls. Examples:

- `bus` — `start`, `mid`, `end`, `tap1..tapN`, `north`, `south`, `east`, `west`
- `transformer` — `in`, `out`, `primary`, `secondary`, `north`, `south`, `center`
- `external-grid` — `in` (= connection point), `north`, `south`, `east`, `west`
- `load` — `in` (= connection point), `tip`, `north`, `south`, `east`, `west`

You refer to an anchor with dotted syntax: `"t1.primary"`, `"b1.tap2"`.

== One-node vs two-node placement

Two-terminal elements like the transformer accept either of two placements:

+ *One position* + an optional `angle:` — the symbol is centred at that
  point. By default the symbol orients along the x-axis; `angle: 90deg`
  makes it vertical.
+ *Two positions* — the symbol spans from the first to the second,
  orienting itself along that line. The two endpoints become the `in`
  and `out` anchors.

```typst
#pg.diagram({
  import pg: *
  // Two-node: spans from (0, 0) to (2, 0), oriented horizontally.
  transformer("t1", (0, 0), (2, 0))
  // One-node with angle: 90deg makes it vertical.
  transformer("t2", (4, 0), angle: 90deg)
})
```

#pg.diagram(length: 1.2cm, {
  import pg: *
  transformer("t1", (0, 0), (2, 0))
  transformer("t2", (4, 0), angle: 90deg)
})

== Styling

Every style can be overridden at three levels:

- *Global* — change every symbol at once:
  ```typst
  cetz.draw.set-style(powergretz: (stroke: 1pt + blue))
  ```
- *Family* — change every transformer:
  ```typst
  cetz.draw.set-style(powergretz: (transformer: (radius: 0.5)))
  ```
- *Per call* — pass as a named argument:
  ```typst
  transformer("t1", (0, 0), (2, 0), radius: 0.5, stroke: red)
  ```

Per-call overrides win, family defaults next, global defaults last.

== Labels

Every symbol accepts a `label:` argument. The simplest form is just
content; the dict form lets you control where it sits.

```typst
// Plain content uses the family default position (north / above).
transformer("t1", (0, 0), (2, 0), label: [132/11 kV])

// Dict form overrides any of: content, anchor, align, distance, size.
transformer("t2", (0, -1), (2, -1), label: (
  content: [T₁],
  anchor: "south",    // world-space position relative to the symbol
  align: auto,        // text-box anchor; `auto` = opposite of `anchor`
  distance: 0.2,      // gap between symbol edge and text
  size: 9pt,          // font size
))
```

=== Anchor names are world-space

`anchor:` is interpreted in the *world* frame, not in the symbol's
local frame. So `anchor: "north"` always means "above the symbol on the
page", whether the symbol is rotated or not. `core.typ` rotates the
world direction back through the symbol's `effective-angle` to find the
matching local anchor — that's why `label: [132/11 kV]` on a vertical
two-node transformer correctly lands above its top circle in world
space rather than off to the side in some local frame.

The eight compass anchors are:

#align(center, table(
  columns: (5em, 5em, 5em),
  inset: 6pt, align: center, stroke: none,
  raw("north-west"), raw("north"), raw("north-east"),
  raw("west"),       [],            raw("east"),
  raw("south-west"), raw("south"), raw("south-east"),
))

You can *also* pass a symbol-specific anchor name (`tap1`, `start`,
`end`, `mid`, `tip`, `primary`, `secondary`, …); the label system
attaches there directly without going through the rotation map.

=== Where the family defaults come from

Each symbol has its own default `label` sub-dict in `src/styles.typ`.
Per-call values win, family defaults are next, and the base label style
is the fallback. Here's the cascade for the `bus` family:

#table(
  columns: (auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Layer*], [*What it sets*],
  [Base default],   [`anchor: "north"`, `align: auto`, `distance: 0.15`, `size: 8pt`],
  [Bus family],     [`distance: 0.22` (overrides only the gap)],
  [Per-call],       [Whatever you pass in `label: (...)`],
  [Runtime override], [`cetz.draw.set-style(powergretz: (bus: (label: (...))))`],
)

=== Three increasingly local ways to set bus label position

```typst
// 1. Per-call dict — the usual way.
bus("b1", (0, 0), length: 4, label: (
  content: [HV bus],
  anchor: "south", distance: 0.4,
))

// 2. Set a family default for every bus in this canvas.
cetz.draw.set-style(powergretz: (bus: (
  label: (anchor: "south", distance: 0.3),
)))
bus("b1", (0, 0), label: [HV bus])
bus("b2", (0, -2), label: [LV bus])

// 3. Bypass the label system and place content at any bus anchor.
bus("b1", (0, 0), length: 1.4, angle: 90deg)
cetz.draw.content("b1.end", [HV bus], anchor: "south", padding: 0.15)
```

Use #1 most of the time, #2 when you have many buses styled the same
way, and #3 when you need fine control or want to position multiple
labels around one bus.

=== `align:` controls how the text sits at the anchor point

`anchor:` picks the *position*; `align:` picks where on the text-box
that position lands. `align: auto` (the default) sets it to the opposite
of `anchor:` so the text reads cleanly *away from* the symbol —
e.g. `anchor: "north"` + `align: "south"` puts the south edge of the
text box at the north of the symbol, so the text extends further north.

Override `align:` only when `auto` doesn't pick the right thing — for
example, when you've used a non-compass anchor name and there's no
opposite to compute.

== Wires and elbows

Use `wire(a, b)` to connect two points with a straight line, or
`elbow(a, b, corner: "h")` for an L-shaped routing that goes horizontally
first, then vertically (use `corner: "v"` for the opposite).

```typst
#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), (4, 0), taps: 5)
  wire("b.tap2", (1, -1.5))
  elbow("b.tap4", (4, -1.5), corner: "h")
})
```

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), (4, 0), taps: 5)
  wire("b.tap2", (1, -1.5))
  elbow("b.tap4", (4, -1.5), corner: "h")
})
