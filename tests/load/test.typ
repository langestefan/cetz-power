#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default load on a bus
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  load("l", "b.tap2")
})

// Load with label
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  load("l", "b.tap2", label: [10 MW])
})

// Multiple loads, mixing default and elbow connections.
#test({
  bus("b", (0, 0), length: 4, taps: 4)
  load("l1", "b.tap1")
  load("l2", "b.tap2", elbow: 0.4)
  load("l3", "b.tap3", angle: 180deg)
  load("l4", "b.tap4", fill: none)
})

// Context-aware placement off a horizontal bus: straight drop below by
// default, `side: "north"` above; labels follow the tip automatically.
#test({
  bus("b", (0, 0), (3, 0))
  load("l1", bus-frac("b", 0.3), on: "b", label: [below])
  load("l2", bus-frac("b", 0.7), on: "b", side: "north", label: [above])
})

// Context-aware placement off a vertical bus: automatic rule-8 L-bend
// (east by default, west on request).
#test({
  bus("v", (0, -1), (0, 1))
  load("l1", bus-frac("v", 0.3), on: "v", label: [east])
  load("l2", bus-frac("v", 0.7), on: "v", side: "west", label: [west])
})

// `towards:` aims the tip at a coordinate.
#test({
  junction("j", (0, 0))
  load("l", (0, 0), towards: (1, -1), label: [aimed])
})
