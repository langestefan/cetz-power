#import "/tests/harness.typ": test
#import "/src/lib.typ" as pg

// Two-node placement
#test({
  import pg: *
  transformer("t", (0, 0), (2, 0))
})

// Single-node placement with angle
#test({
  import pg: *
  transformer("t", (0, 0), angle: 90deg)
})

// With label
#test({
  import pg: *
  transformer("t", (0, 0), (2, 0), label: [132/33 kV])
})

// Style override: thicker stroke and filled
#test({
  import pg: *
  transformer("t", (0, 0), (2, 0), stroke: 1.2pt + black, fill: yellow.lighten(60%))
})

// Bus-to-bus (common pattern). Leads are drawn automatically.
#test({
  import pg: *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  transformer("t1", "b1.mid", "b2.mid")
})
