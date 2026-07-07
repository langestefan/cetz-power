#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Defaults: summing point and mixer.
#test({
  adder("a", (0, 0))
  mixer("m", (1, 0))
})

// A feedback comparison: reference in, feedback subtracted, with the
// input signs as small notes.
#test({
  adder("sum", (1.2, 0))
  flow-arrow((0, 0), "sum.west")
  flow-arrow((1.2, -1), "sum.south")
  wire("sum.east", (2.4, 0))
  note((1.02, 0.14), [$+$], side: "north", distance: 0.02, size: 6pt)
  note((1.34, -0.24), [$-$], side: "east", distance: 0.02, size: 6pt)
})

// Style overrides + white fill masking a conductor beneath.
#test({
  wire((0, 0), (2, 0))
  mixer("m", (1, 0), fill: white, radius: 0.22, stroke: 1pt + black)
  adder("a", (3, 0), radius: 0.25, stroke: blue, label: [sum])
})
