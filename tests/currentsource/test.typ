#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default DC (two-node placement).
#test({
  currentsource("i", (0, 0), (2, 0))
})

// One-node placement.
#test({
  currentsource("i", (0, 0))
})

// AC variant — adds a sine wave above the arrow.
#test({
  currentsource("i", (0, 0), (2, 0), kind: "ac")
})

// Reversed direction: swap the two endpoints, the arrow follows.
#test({
  currentsource("i", (2, 0), (0, 0))
})

// Connected between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  currentsource("i", "b1.mid", "b2.mid")
})

// Geometry / styling overrides.
#test({
  currentsource("i", (0, 0), (2, 0), radius: 0.5, stroke: 1.4pt + blue)
})

// With a label.
#test({
  currentsource("i", (0, 0), (2, 0), label: [I₁])
})
