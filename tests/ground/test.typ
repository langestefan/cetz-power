#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default earth electrode.
#test({
  ground("g", (0, 0))
})

// Chassis ground.
#test({
  ground("g", (0, 0), kind: "chassis")
})

// Signal ground.
#test({
  ground("g", (0, 0), kind: "signal")
})

// Connected to a bus.
#test({
  bus("b", (0, 0), length: 2, taps: 3)
  ground("g1", "b.tap1")
  ground("g2", "b.tap2", kind: "chassis")
  ground("g3", "b.tap3", kind: "signal")
})

// Width / lead overrides.
#test({
  ground("g", (0, 0), width: 0.7, lead: 0.4)
})

// Rotated (so the symbol points sideways).
#test({
  ground("g", (0, 0), angle: 90deg)
})
