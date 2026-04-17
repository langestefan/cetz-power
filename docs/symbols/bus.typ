#import "/src/lib.typ" as pg

== Bus

A busbar — a thick bar representing a power bus at a substation, with
evenly-spaced tap points for branch connections.

=== Example

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 5, taps: 5)
  // Little stubs to show the tap points.
  for i in range(1, 6) {
    wire("b1.tap" + str(i), (rel: (0, -0.4), to: "b1.tap" + str(i)))
  }
})

```typst
bus("b1", (0, 0), length: 5, taps: 5)
```

=== Signature

```
bus(name, position, [angle:], [length:], [taps:], [label:], [stroke:])
bus(name, position-a, position-b, [taps:], [label:], [stroke:])
```

=== Parameters

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt, align: left + top, stroke: (x, y) => if y == 0 { (bottom: 0.6pt) },
  [*Name*], [*Default*], [*Description*],
  [`name`],    [required], [Unique CeTZ group name; anchors are addressed as `name.anchor`.],
  [`length`],  [`3`],      [Bar length (CeTZ units). Ignored when two positions are given.],
  [`taps`],    [`1`],      [Number of evenly-spaced tap anchors (`tap1..tapN`).],
  [`angle`],   [`0deg`],   [Rotation. Use `90deg` for a vertical bus. Only for single-position placement.],
  [`stroke`],  [`1.8pt`],  [Stroke override.],
  [`label`],   [`none`],   [Label content or dict.],
)

=== Anchors

The bus exposes:

- `start`, `mid`, `end` — the three defining points along the bar
- `tap1 .. tapN` — evenly-spaced taps for `taps: N`
- `north`, `south`, `east`, `west` — cardinal points for label placement

=== Variants

*Vertical bus* via `angle: 90deg`:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 3, angle: 90deg, taps: 4)
})

*Two-node bus* for diagonal / arbitrary-orientation buses:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), (3, 2), taps: 3)
})

=== Fractional attachment with `bus-frac`

`bus-frac(name, fraction)` returns a *coordinate* — not an anchor name —
that lies a given fraction of the way from the bus's `start` to its `end`.
Use it whenever you want to attach to an arbitrary point on a bus without
having to declare a matching `taps` count up front.

```typst
bus-frac("b1", 0)     // == "b1.start"
bus-frac("b1", 0.5)   // == "b1.mid"
bus-frac("b1", 1)     // == "b1.end"
bus-frac("b1", 0.25)  // a quarter of the way along the bus
```

It works anywhere a coordinate is accepted — `wire`, `transformer`,
`load`, etc. The fraction is taken along whichever orientation the bus
has (horizontal, vertical, or diagonal), so the same expression works
regardless of how the bus is rotated:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 4)
  load("l1", bus-frac("b1", 0.25))
  load("l2", bus-frac("b1", 0.50))
  load("l3", bus-frac("b1", 0.75))
})

```typst
bus("b1", (0, 0), length: 4)
load("l1", bus-frac("b1", 0.25))
load("l2", bus-frac("b1", 0.50))
load("l3", bus-frac("b1", 0.75))
```

Under the hood `bus-frac` is just a CeTZ lerp coordinate
`("name.start", fraction, "name.end")`, evaluated at draw time — so the
fraction can even be a computation, e.g. `bus-frac("b3", 1/6)`.

=== Multiple buses & inter-bus wires

```typst
#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})
```

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})
