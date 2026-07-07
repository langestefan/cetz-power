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

// Cross kind: an "x" on the wire (network-overview breaker notation).
#test({
  breaker("b", (0, 0), (2, 0), kind: "cross")
})

// Cross as a one-node marker dropped onto an existing wire.
#test({
  wire((0, 0), (3, 0))
  breaker("x1", (1, 0), kind: "cross", size: 0.2)
  breaker("x2", (2, 0), kind: "cross", size: 0.2, stroke: 0.8pt + red)
})

// One-node square marker with rotation.
#test({
  wire((0, 0), (0, 2))
  breaker("b", (0, 1), angle: 90deg)
})

// Recloser / sectionalizer bodies (upright under rotation).
#test({
  breaker("r", (0, 0), (1.2, 0), size: 0.36, body: [R])
  breaker("s", (2, -0.6), (2, 0.6), size: 0.36, body: [S])
})
