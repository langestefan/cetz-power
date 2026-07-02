#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Bare symbol at the origin.
#test({
  transformer3("t", (0, 0))
})

// Rotated.
#test({
  transformer3("t", (0, 0), angle: 90deg)
})

// With a label.
#test({
  transformer3("t", (0, 0), label: [23 / 0,96 / 0,69 kV])
})

// Per-winding styling.
#test({
  transformer3(
    "t",
    (0, 0),
    primary-stroke: 1.2pt + black,
    secondary-stroke: red,
    tertiary-stroke: blue,
  )
})

// DFIG split: HV from a bus, two secondaries fanning into two branches.
#test({
  bus("b", (0, 0), length: 1.4, angle: 90deg)
  transformer3("t", (2, 0))
  wire("b.mid", "t.hv")
  wire("t.lv", (rel: (1.5, 0), to: "t.lv"))
  wire("t.tv", (rel: (1.5, 0), to: "t.tv"))
})

// Lead stubs on every terminal.
#test({
  transformer3("t", (0, 0), lead: 0.4)
})

// Custom exit angles: LV straight up, TV straight down, HV unchanged.
#test({
  transformer3("t", (0, 0), lv-angle: 90deg, tv-angle: -90deg)
})

// Angles + leads together, anchors still drive the wires.
#test({
  transformer3("t", (0, 0), lead: 0.5, lv-angle: 90deg, tv-angle: -90deg)
  wire("t.lv", (rel: (0, 1), to: "t.lv"))
  wire("t.tv", (rel: (0, -1), to: "t.tv"))
  wire("t.hv", (rel: (-1, 0), to: "t.hv"))
})
