#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default horizontal bus
#test({
  bus("b", (0, 0))
})

// With explicit length and taps
#test({
  bus("b", (0, 0), length: 5, taps: 6)
})

// Two-node bus
#test({
  bus("b", (0, 0), (4, 0), taps: 4)
})

// Vertical bus via angle
#test({
  bus("b", (0, 0), length: 3, angle: 90deg, taps: 4)
})

// Diagonal bus via two-node placement
#test({
  bus("b", (0, 0), (3, 2), taps: 3)
})

// Stroke override
#test({
  bus("b", (0, 0), length: 4, taps: 3, stroke: 3pt + red)
})

// Multiple buses + wire via tap anchors
#test({
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})

// bus-frac helper
#test({
  bus("b", (0, 0), length: 4)
  wire(bus-frac("b", 0.25), (1, -1))
  wire(bus-frac("b", 0.75), (3, -1))
})

// fit: the bar spans its connections plus a symmetric overshoot; the
// vertical axis is inferred from the points' spread, and start→end
// follows the order the points are given in.
#test({
  wire((-1, 0.8), (0, 0.8))
  wire((-1, -0.8), (0, -0.8))
  bus("b", fit: ((0, 0.8), (0, -0.8)), over: 0.3)
  wire(bus-frac("b", 0.5), (1, 0))
})

// fit with the rule-14 alignment form: over = ref/2 - gap/2 lines the
// bar's ends up with a reference bar of length `ref` a gap `gap` away.
#test({
  bus("ref", (0, 0), length: 1.4, angle: 90deg)
  wire((0, 0.3), (2, 0.3))
  wire((0, -0.3), (2, -0.3))
  bus("tall", fit: ((2, 0.3), (2, -0.3)), over: (ref: 1.4, gap: 0.6))
})

// fit on a horizontal spread, axis forced explicitly.
#test({
  bus("b", fit: ((0, 0), (3, 0)), over: 0.25, angle: 0deg, taps: 3)
  load("l", "b.tap2", on: "b")
})
