#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default single cell (two-pole).
#test({
  battery("b", (0, 0))
})

// Multi-cell stacks.
#test({
  battery("b1", (0, 0), cells: 2)
  battery("b2", (1.5, 0), cells: 3)
})

// Single-pole / shunt form hanging under a bus.
#test({
  bus("b1", (0, 0), length: 1.5)
  battery("bat", "b1.mid", angle: 180deg, lead-out: 0)
})

// Horizontal placement + label.
#test({
  battery("b", (0, 0), angle: -90deg, label: [48 V])
})

// In-circuit: battery feeding a converter (chained anchors).
#test({
  battery("bat", (0, 0), cells: 2)
  converter("c", (0, 1.6), kind: "dc-ac", angle: 90deg)
  wire("bat.out", (0, 1.25))
  ground("g", (0, 0), angle: 180deg)
})

// Styling overrides.
#test({
  battery(
    "b",
    (0, 0),
    long-width: 0.7,
    short-width: 0.3,
    gap: 0.18,
    stroke: 1.2pt + blue,
  )
})
