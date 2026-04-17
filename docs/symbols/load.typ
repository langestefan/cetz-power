#import "/src/lib.typ" as pg

== Load

A filled downward triangle — the standard "generic load" symbol on a bus.
Rotate with `angle:` to point it elsewhere; pass `elbow: <units>` to route
the lead as an L-shape (across, then down to the arrow).

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 4, taps: 3)
  load("l1", "b.tap1")
  load("l2", "b.tap2", label: [10 MW])
  load("l3", "b.tap3", elbow: 0.4)
})

```typst
load("l1", "b.tap1")
load("l2", "b.tap2", label: [10 MW])
load("l3", "b.tap3", elbow: 0.4)
```

=== Parameters

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Name*], [*Default*], [*Description*],
  [`size`],   [`0.28`],   [Triangle side length.],
  [`lead`],   [`0.1`],    [Length of the stub wire from the connection point to the arrow's base.],
  [`elbow`],  [`0`],      [If non-zero, route the lead as an L: across by this many units, then down to the arrow.],
  [`stroke`], [`0.8pt`],  [Stroke override.],
  [`fill`],   [`black`],  [Triangle fill — set to `none` for a hollow textbook arrow.],
)

=== Anchors

`in` (= connection point), `south` (= tip of arrow), `north`, `tip`,
`east`, `west`, `default`. The `label-east` / `label-west` anchors sit
half a unit out from the arrow body so labels clear the symbol.
