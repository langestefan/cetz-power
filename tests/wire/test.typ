#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Plain wire
#test({
  wire((0, 0), (2, 1))
})

// Elbow wire, horizontal-first
#test({
  wire((0, 0), (2, 0))
  elbow((2, 0), (3, -1.5))
})

// Elbow wire, vertical-first
#test({
  elbow((0, 0), (2, -1.5), corner: "v")
})

// Wire between anchors of two buses
#test({
  bus("b1", (0, 0), length: 2, taps: 1)
  bus("b2", (4, -1), length: 2, taps: 1)
  wire("b1.tap1", "b2.tap1")
  elbow("b1.end", "b2.start")
})

// Custom stroke
#test({
  wire((0, 0), (2, 0), stroke: 2pt + blue)
})
