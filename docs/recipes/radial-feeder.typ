#import "/src/lib.typ" as pg

== Radial feeder with step-down transformer

A textbook layout: an external grid feeding a step-down transformer between
two voltage levels, then a downstream bus with a load. The three buses are
drawn as short vertical bars (the canonical "node" depiction in single-line
diagrams), with their numbers as labels above.

#pg.diagram(length: 1.2cm, {
  import pg: *

  // Three bus "nodes", evenly spaced.
  bus("b1", (1.7, 0), length: 1.4, angle: 90deg, label: [1])
  bus("b2", (4.6, 0), length: 1.4, angle: 90deg, label: [2])
  bus("b3", (7.0, 0), length: 1.4, angle: 90deg, label: [3])

  // External grid on the left. `angle: 90deg` rotates the cross-hatched
  // square so that its `in` anchor sits on the right edge — that way the
  // wire from `g.in` to `b1.mid` exits the square cleanly.
  external-grid("g", (0.7, 0), angle: 90deg,
    label: (content: align(center)[50 MVA, \ 10 kV],
            anchor: "north", distance: 0.25))
  wire("g.in", "b1.mid")

  // Step-down transformer between bus 1 (HV) and bus 2 (LV).
  transformer("t", "b1.mid", "b2.mid", label: [10/0.4 kV])

  // Plain feeder line between bus 2 and bus 3.
  wire("b2.mid", "b3.mid")

  // Load tapped off bus 3 a sixth of the way up from the bottom, connected
  // via an elbow so the lead exits the bus horizontally before dropping
  // down to the arrow. `bus-frac` returns a fractional point along the bus.
  load("ld", bus-frac("b3", 1/6), elbow: 0.4)
})

```typst
#pg.diagram(length: 1.2cm, {
  import pg: *

  bus("b1", (1.7, 0), length: 1.4, angle: 90deg, label: [1])
  bus("b2", (4.6, 0), length: 1.4, angle: 90deg, label: [2])
  bus("b3", (7.0, 0), length: 1.4, angle: 90deg, label: [3])

  external-grid("g", (0.7, 0), angle: 90deg,
    label: (content: align(center)[50 MVA, \ 10 kV],
            anchor: "north", distance: 0.25))
  wire("g.in", "b1.mid")

  transformer("t", "b1.mid", "b2.mid", label: [10/0.4 kV])
  wire("b2.mid", "b3.mid")
  load("ld", bus-frac("b3", 1/6), elbow: 0.4)
})
```

Things worth noticing:

- *Buses as nodes.* A single short vertical bus (`length: 1.4, angle: 90deg`)
  is the standard way to draw a busbar that's just a connection point,
  with its number written above.
- *Anchor-driven wiring.* Every wire and two-node element refers to bus
  anchors (`b1.mid`, `b2.mid`, `b3.start`) rather than bare coordinates,
  so adjusting the bus spacing only requires moving the bus origins.
- *Grid orientation.* `angle: 90deg` on the external grid puts the
  cross-hatched square to the *left* of its connection point, so the wire
  to bus 1 emerges from the square's right side rather than passing
  through it.
