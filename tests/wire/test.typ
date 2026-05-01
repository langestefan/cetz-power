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

// Multi-point polyline — three or more positional args make a chain
// of straight segments.
#test({
  wire((0, 0), (1, 1), (2, 0), (3, 1))
})

// Polyline with relative coordinates — `(rel: <vec>)` (no `to:`)
// means "offset from the previous point in the list", so this is
// turtle-style routing.
#test({
  wire(
    (0, 0),
    (rel: (1, 0)),
    (rel: (0, -1)),
    (rel: (1, 0)),
  )
})

// Polyline mixing anchor names and relative offsets.
#test({
  bus("b", (0, 0), length: 2, taps: 1)
  wire(
    "b.tap1",
    (rel: (0, -0.6)),
    (rel: (1, 0)),
    (rel: (0, 0.6)),
  )
})

// Polyline mixing all three relative-coord forms in one wire:
// named anchor, `(rel: vec)` (relative to previous point), and
// `(rel: vec, to: anchor)` (relative to a specific named anchor).
#test({
  bus("b1", (0, 0),    length: 1.2, angle: 90deg)
  bus("b2", (2.5, -1), length: 1.2, angle: 90deg)
  wire(
    "b1.mid",
    (rel: (0, -0.4)),
    (rel: (0, 0.3), to: "b2.mid"),
    "b2.mid",
  )
})
