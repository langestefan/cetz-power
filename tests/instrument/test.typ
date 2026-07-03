#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// CT on a conductor (two-node: primary straight through).
#test({
  ct("c", (0, 0), (2, 0))
})

// CT dropped onto an existing run (one-node) + secondary to a meter.
#test({
  wire((0, 0), (3, 0))
  ct("c", (1.5, 0))
  machine("m", (1.5, -1.2), "A")
  wire("c.south", "m.north")
})

// VT hanging below a line, measurement drop to a voltmeter.
#test({
  wire((0, 0), (2.5, 0))
  vt("v", (1.25, 0))
  machine("m", (1.25, -1.8), "V")
  wire("v.out", "m.north")
})

// VT pointing up; CT with styling overrides.
#test({
  wire((0, 0), (2.5, 0))
  vt("v", (0.7, 0), angle: 180deg)
  ct("c", (1.8, 0), radius: 0.24, stroke: 1pt + blue, label: [CT1])
})
