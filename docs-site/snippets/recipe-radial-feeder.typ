#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

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

  // Load tapped off bus 3 a sixth of the way up from the bottom.
  load("ld", bus-frac("b3", 1/6), elbow: 0.4)
})
