#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: empty box (one-node placement).
#test({
  block("b", (0, 0))
})

// Body content + colour-coded fills (the wind / BESS / PV row).
#test({
  block("w", (0, 0), body: [wind], fill: rgb("#9cdcf0"))
  block("s", (1.5, 0), body: [BESS], fill: rgb("#f3c9ea"))
  block("p", (3, 0), body: [PV], fill: rgb("#f5b426"))
})

// Wired via compass anchors, with an outside label.
#test({
  bus("b1", (2, 0), length: 1.0, angle: 90deg)
  block("dev", (0, 0), body: [plant], label: [unit 1])
  wire("dev.east", "b1.mid")
})

// Two-node placement: body at the midpoint, leads to the endpoints.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3.5, 0), length: 1.0, angle: 90deg)
  block("link", "b1.mid", "b2.mid", body: [SVC])
})

// Geometry overrides + corner anchors as wire targets.
#test({
  block("c", (0, 0), width: 1.6, height: 0.9, body: [controller])
  wire("c.north-east", (rel: (0.4, 0.4)))
  wire("c.south-east", (rel: (0.4, -0.4)))
})
