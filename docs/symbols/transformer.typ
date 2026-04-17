#import "/src/lib.typ" as pg

== Transformer

Two-winding transformer drawn as two overlapping circles along the
connection line. Naturally a two-node element — give it the `in` and
`out` coordinates and it orients itself along that line, drawing leads
from each endpoint to the corresponding circle.

#pg.diagram(length: 1.2cm, {
  import pg: *
  transformer("t1", (0, 0), (2, 0), label: [132/11 kV])
})

```typst
transformer("t1", (0, 0), (2, 0), label: [132/11 kV])
```

=== Parameters

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Name*], [*Default*], [*Description*],
  [`radius`],   [`0.45`], [Radius of each circle.],
  [`distance`], [`0.5`],  [Centre-to-centre distance between the two circles.],
  [`fill`],     [`none`], [Fill colour for the circles.],
  [`stroke`],   [`0.8pt`],[Stroke override.],
  [`label`],    [`none`], [Typical use: voltage rating, e.g. `[132/11 kV]`.],
)

=== Anchors

`in`, `out`, `primary`, `secondary`, `center`, `north`, `south`, `east`,
`west`. `in`/`primary` is the left-hand circle's outer edge; `out`/`secondary`
is the right-hand circle's outer edge (in the symbol's local frame, before
rotation).

=== Placement

`transformer` accepts either two coordinates or one coordinate plus an
`angle:`. With two coordinates the symbol places itself between them and
draws the connecting leads automatically:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  transformer("t", "b1.mid", "b2.mid")
})

```typst
transformer("t", "b1.mid", "b2.mid")
```

With a single coordinate plus `angle:` the symbol is centred at that point
and rotated:

#pg.diagram(length: 1.2cm, {
  import pg: *
  transformer("t1", (0, 0), (2, 0))
  transformer("t2", (4, 0), angle: 90deg)
})

```typst
transformer("t1", (0, 0), (2, 0))
transformer("t2", (4, 0), angle: 90deg)
```

=== Styling

Set per-family defaults with `cetz.draw.set-style` to recolour every
transformer in the diagram:

#pg.diagram(length: 1.2cm, {
  import pg: *
  cetz.draw.set-style(powergretz: (transformer: (fill: yellow.lighten(80%))))
  transformer("t1", (0, 0), (2, 0))
})

```typst
cetz.draw.set-style(powergretz: (transformer: (fill: yellow.lighten(80%))))
transformer("t1", (0, 0), (2, 0))
```
