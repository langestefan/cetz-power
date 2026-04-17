#import "/tests/harness.typ": test
#import "/src/lib.typ" as pg

// Default horizontal bus
#test({
  import pg: *
  bus("b", (0, 0))
})

// With explicit length and taps
#test({
  import pg: *
  bus("b", (0, 0), length: 5, taps: 6)
})

// Two-node bus
#test({
  import pg: *
  bus("b", (0, 0), (4, 0), taps: 4)
})

// Vertical bus via angle
#test({
  import pg: *
  bus("b", (0, 0), length: 3, angle: 90deg, taps: 4)
})

// Diagonal bus via two-node placement
#test({
  import pg: *
  bus("b", (0, 0), (3, 2), taps: 3)
})

// Stroke override
#test({
  import pg: *
  bus("b", (0, 0), length: 4, taps: 3, stroke: 3pt + red)
})

// Multiple buses + wire via tap anchors
#test({
  import pg: *
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})

// bus-frac helper
#test({
  import pg: *
  bus("b", (0, 0), length: 4)
  wire(bus-frac("b", 0.25), (1, -1))
  wire(bus-frac("b", 0.75), (3, -1))
})
