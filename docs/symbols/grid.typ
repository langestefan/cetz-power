#import "/src/lib.typ" as pg

== External grid

Single-terminal connection representing "the grid beyond this point" —
an infinite bus. Drawn as a cross-hatched square.

=== Example

#pg.diagram(length: 1.2cm, {
  import pg: *
  external-grid("g", (0, 0), label: [132 kV \ 500 MVA])
  bus("b", (-1.5, -1.5), (1.5, -1.5), taps: 1)
  wire("g.default", "b.tap1")
})

```typst
external-grid("g", (0, 0), label: [132 kV \ 500 MVA])
```

=== Parameters

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Name*], [*Default*], [*Description*],
  [`size`],   [`0.5`],  [Side length of the square.],
  [`lead`],   [`0.2`],  [Stub from connection point to the bottom of the square.],
  [`fill`],   [`none`], [Fill colour of the square.],
  [`stroke`], [`0.8pt`],[Stroke override.],
)

=== Anchors

`in` (= connection point, `(0,0)`), `center`, `north` (top of the square),
`default`.

=== Rotation

Rotate with `angle:` when you want the symbol to stick out of a horizontal
bus instead of hanging below one:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 3, angle: 90deg, taps: 3)
  external-grid("g", "b.tap3", angle: 90deg)
})

```typst
external-grid("g", "b.tap3", angle: 90deg)
```
