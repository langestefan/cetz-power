#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default fuse.
#test({
  fuse("f", (0, 0), (2, 0))
})

// Geometry overrides.
#test({
  fuse("f", (0, 0), (2, 0), length: 0.9, width: 0.3)
})

// Filled body.
#test({
  fuse("f", (0, 0), (2, 0), fill: yellow.lighten(70%))
})

// Connected between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  fuse("f", "b1.mid", "b2.mid")
})

// Diagonal placement.
#test({
  fuse("f", (0, 0), (2, 1))
})

// With a label.
#test({
  fuse("f", (0, 0), (2, 0), label: [F₁])
})
