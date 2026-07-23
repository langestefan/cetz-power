#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Collinear bars: U around them (below by default), label on the run.
#test({
  bus("a", (0, 0), length: 2, label: [A])
  bus("b", (4, 0), length: 2, label: [B])
  link("a", "b", label: [NA2XS2Y 3×240])
})

// Collinear bars, U flipped above.
#test({
  bus("a", (0, 0), length: 2)
  bus("b", (4, 0), length: 2)
  link("a", "b", side: "north", clearance: 0.4)
})

// Facing parallel bars: a single straight perpendicular conductor,
// landing opposite the `from:` tap.
#test({
  bus("a", (0, 0), length: 3)
  bus("b", (0.4, -2), length: 3)
  link("a", "b", from: 0.3, label: [500 m])
})

// Offset parallel bars: Z-route halfway between them.
#test({
  bus("a", (0, 0), length: 2)
  bus("b", (3.5, -2.5), length: 2)
  link("a", "b", label: [Z])
})

// Perpendicular bars: L with both joins perpendicular.
#test({
  bus("a", (0, 0), length: 2)
  bus("b", (4, -1), length: 2, angle: 90deg)
  link("a", "b", from: 0.7, to: 0.6, label: [L])
})

// Vertical collinear bars: the U defaults to the east side.
#test({
  bus("a", (0, 0), length: 1.6, angle: 90deg)
  bus("b", (0, 3), length: 1.6, angle: 90deg)
  link("a", "b", label: [tie])
})

// Cable kind and stroke pass through to the wire.
#test({
  bus("a", (0, 0), length: 2)
  bus("b", (4, 0), length: 2)
  link("a", "b", kind: "cable", stroke: 1pt + blue)
})
