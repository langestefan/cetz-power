#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Two-node placement.
#test({
  autotransformer("t", (0, 0), (2, 0))
})

// Vertical, between two buses, with an OLTC arrow.
#test({
  bus("b1", (0, 0.9), length: 1.4)
  bus("b2", (0, -0.9), length: 1.4)
  autotransformer("t", (0, 0.9), (0, -0.9), oltc: true)
})

// One-node placement + styling overrides.
#test({
  autotransformer(
    "t",
    (0, 0),
    radius: 0.5,
    stroke: 1pt + blue,
    label: [380/220 kV],
  )
})
