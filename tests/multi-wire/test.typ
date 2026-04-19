#import "/tests/harness.typ": test

// Default: 3 wires evenly spaced, spanning both buses.
#test({
  import "/src/lib.typ": *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  multi-wire("b1", "b2")
})

// Custom count.
#test({
  import "/src/lib.typ": *
  bus("b1", (0, 0), length: 1.6, angle: 90deg)
  bus("b2", (3, 0), length: 1.6, angle: 90deg)
  multi-wire("b1", "b2", count: 5)
})

// Middle-third bundle (narrow range).
#test({
  import "/src/lib.typ": *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  multi-wire("b1", "b2", count: 3, from: (0.33, 0.67), to: (0.33, 0.67))
})

// Asymmetric fan-out: narrow on b1, wide on b2.
#test({
  import "/src/lib.typ": *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  multi-wire("b1", "b2", count: 3, from: (0.4, 0.6), to: (0, 1))
})

// Single wire — count=1 uses the midpoint of each range.
#test({
  import "/src/lib.typ": *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  multi-wire("b1", "b2", count: 1)
})
