#import "/tests/harness.typ": test
#import "/src/lib.typ" as pg

// Bare panel.
#test({
  import pg: *
  pv-panel("p", (0, 0))
})

// Hanging off a bus tap with a label below.
#test({
  import pg: *
  bus("b", (0, 0), length: 1.4, angle: 90deg, label: [9])
  pv-panel("pv", bus-frac("b", 1/6), elbow: 0.5, label: [80 m])
})

// Style overrides: filled triangle, wider panel.
#test({
  import pg: *
  pv-panel("p", (0, 0), size: 0.7, triangle-fill: black)
})
