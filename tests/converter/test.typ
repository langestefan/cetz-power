#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default AC→DC (one-node placement).
#test({
  converter("c", (0, 0))
})

// All four conversion modes in a row.
#test({
  converter("c1", (0, 0), kind: "ac-dc")
  converter("c2", (1.5, 0), kind: "dc-ac")
  converter("c3", (3, 0), kind: "ac-ac")
  converter("c4", (4.5, 0), kind: "dc-dc")
})

// Two-node placement: body at the midpoint, leads to the endpoints.
#test({
  converter("c", (0, 0), (3, 0), kind: "dc-ac")
})

// Inline between two buses (verifies leads + anchors).
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  converter("c", "b1.mid", "b2.mid")
})

// Wired via compass anchors (one-node box beside a bus).
#test({
  bus("b", (1.5, 0), length: 1.0, angle: 90deg)
  converter("c", (0, 0))
  wire("c.east", "b.mid")
})

// Rotated two-node placement (vertical).
#test({
  converter("c", (0, 0), (0, 2.5), kind: "dc-ac")
})

// Styling overrides + label.
#test({
  converter(
    "c",
    (0, 0),
    size: 0.9,
    stroke: 1pt + blue,
    fill: blue.lighten(92%),
    label: [GFM 1],
  )
})
