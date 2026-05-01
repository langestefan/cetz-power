#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default DC (two-node placement).
#test({
  voltagesource("v", (0, 0), (2, 0))
})

// One-node placement (no leads).
#test({
  voltagesource("v", (0, 0))
})

// All AC waveform variants in a row.
#test({
  voltagesource("v1", (0,  0), (2,  0), kind: "ac")
  voltagesource("v2", (3,  0), (5,  0), kind: "sin")
  voltagesource("v3", (6,  0), (8,  0), kind: "tri")
  voltagesource("v4", (9,  0), (11, 0), kind: "saw")
  voltagesource("v5", (12, 0), (14, 0), kind: "rect")
})

// Connected between two buses (verifies leads + anchors).
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  voltagesource("v", "b1.mid", "b2.mid", kind: "ac")
})

// Geometry / styling overrides.
#test({
  voltagesource("v", (0, 0), (2, 0),
    radius: 0.5,
    stroke: 1.4pt + blue,
    fill: yellow.lighten(80%),
  )
})

// Vertical orientation (one-node + angle).
#test({
  voltagesource("v", (0, 0), kind: "ac", angle: 90deg)
})

// With a label.
#test({
  voltagesource("v", (0, 0), (2, 0), label: [V₁])
})
