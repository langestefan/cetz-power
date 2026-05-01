#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default circuit breaker.
#test({
  breaker("b", (0, 0), (2, 0))
})

// Larger box.
#test({
  breaker("b", (0, 0), (2, 0), size: 0.5)
})

// Filled body (e.g. colour-code by voltage level).
#test({
  breaker("b", (0, 0), (2, 0), fill: red.lighten(60%))
})

// Connected between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  breaker("cb", "b1.mid", "b2.mid")
})

// Diagonal placement.
#test({
  breaker("b", (0, 0), (2, 1))
})

// With a label.
#test({
  breaker("b", (0, 0), (2, 0), label: [CB₁])
})
