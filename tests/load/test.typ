#import "/tests/harness.typ": test
#import "/src/lib.typ" as pg

// Default load on a bus
#test({
  import pg: *
  bus("b", (0, 0), length: 3, taps: 3)
  load("l", "b.tap2")
})

// Load with label
#test({
  import pg: *
  bus("b", (0, 0), length: 3, taps: 3)
  load("l", "b.tap2", label: [10 MW])
})

// Multiple loads, mixing default and elbow connections.
#test({
  import pg: *
  bus("b", (0, 0), length: 4, taps: 4)
  load("l1", "b.tap1")
  load("l2", "b.tap2", elbow: 0.4)
  load("l3", "b.tap3", angle: 180deg)
  load("l4", "b.tap4", fill: none)
})
