#import "/src/lib.typ" as pg

== PV panel

A photovoltaic panel — a rectangle with a small downward-pointing
triangle inside the top, indicating power flowing out of the connection
point. Single-terminal: the `in` anchor is at the top of the panel.

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 1.4, angle: 90deg, label: [9])
  pv-panel("pv", bus-frac("b", 1/6), elbow: 0.5, label: [80 m])
})

```typst
bus("b", (0, 0), length: 1.4, angle: 90deg, label: [9])
pv-panel("pv", bus-frac("b", 1/6), elbow: 0.5, label: [80 m])
```

=== Parameters

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Name*], [*Default*], [*Description*],
  [`size`],          [`0.5`],  [Panel width.],
  [`aspect`],        [`1.4`],  [Height-to-width ratio of the rectangle.],
  [`lead`],          [`0.25`], [Stub from the connection point to the top of the panel.],
  [`elbow`],         [`0`],    [If non-zero, route the lead as an L: across by this many units, then down to the panel.],
  [`fill`],          [`none`], [Panel body fill.],
  [`triangle-fill`], [`none`], [Inner triangle fill — set to `black` for a filled-arrow source style.],
  [`stroke`],        [`0.8pt`],[Stroke override.],
)

=== Anchors

`in` (= connection point at the top of the lead), `north` (alias for `in`),
`south` (bottom of panel), `east`, `west`, `center`, `default`.

=== Variants

Filled triangle, wider panel, attached without an elbow:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 1.4, angle: 90deg)
  pv-panel("pv1", "b.start", size: 0.7, triangle-fill: black)
})

```typst
pv-panel("pv1", "b.start", size: 0.7, triangle-fill: black)
```
