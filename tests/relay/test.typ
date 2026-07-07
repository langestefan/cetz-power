#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// IEC function boxes and the ANSI device circle.
#test({
  relay("r1", (0, 0), "50/51")
  relay("r2", (1.2, 0), [87T])
  relay("r3", (2.4, 0), [$U <$])
  relay("r4", (3.6, 0), "21", kind: "circle")
})

// The canonical protection chain: CT secondary into the relay, dashed
// trip command to the breaker.
#test({
  bus("b", (0, 0), length: 2.4)
  wire((1.2, 0), (1.2, -1.6))
  ct("ct1", (1.2, -0.5), angle: 90deg)
  breaker("cb", (1.2, -1.6), (1.2, -2.3))
  relay("prot", (2.4, -0.5), "50/51", label: [feeder prot.])
  wire((1.36, -0.5), "prot.west")
  flow-arrow(
    "prot.south",
    (2.4, -1.95),
    stroke: (paint: black, thickness: 0.7pt, dash: "dashed"),
  )
  flow-arrow(
    (2.4, -1.95),
    "cb.east",
    stroke: (paint: black, thickness: 0.7pt, dash: "dashed"),
  )
})

// Style overrides + rotation (code stays upright).
#test({
  relay("r1", (0, 0), "27/59", width: 0.7, fill: luma(240), angle: 90deg)
  relay("r2", (1.4, 0), "V", kind: "circle", radius: 0.3, stroke: blue)
})
