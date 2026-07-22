#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default factory on a bus
#test({
  bus("b", (0, 0), length: 3)
  factory("f", bus-frac("b", 0.5))
})

// Label, smoke (stays inside the box), and window count — interior
// taps, never the bus ends
#test({
  bus("b", (0, 0), length: 5)
  factory("f1", bus-frac("b", 0.15), label: [Plant A])
  factory("f2", bus-frac("b", 0.5), smoke: true)
  factory("f3", bus-frac("b", 0.85), windows: 4)
})

// Elbow routing, bare building, fills, and sizing
#test({
  bus("b", (0, 0), length: 7)
  factory("f1", bus-frac("b", 0.15), elbow: 0.5)
  factory("f2", bus-frac("b", 0.38), box: false)
  factory(
    "f3",
    bus-frac("b", 0.62),
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(85%),
  )
  factory("f4", bus-frac("b", 0.85), width: 1.1, height: 0.9)
})

// Wiring via compass anchors (no lead — the box west wall is the terminal)
#test({
  bus("b", (0, 0), length: 2, angle: 90deg)
  factory("f", (1.4, 0.42), lead: 0)
  wire("b.mid", "f.west")
})
