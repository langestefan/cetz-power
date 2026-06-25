#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Basic DALI: CT clamp around the line, VT on the V tap, box below.
#test({
  wire((-1.5, 0), (1.5, 0))
  dali("d", (0, 0))
})

// Custom I / U captions via the named clamp / transformer anchors.
#test({
  wire((-2, 0), (2, 0))
  dali("d", (0, 0), width: 1.3, lead: 0.5, tail: 0.6)
  note("d-ct.west", [I], side: "west")
  note("d-vt.east", [U], side: "east")
})

// Relabelled + filled box + styled VT, compact, and anchored at box south.
#test({
  wire((-1, 0), (1, 0))
  dali("d", (0, 0), width: 0.6, lead: 0.22, tail: 0.28, box-height: 0.5,
    box-width: 0.9, clamp-radius: 0.1, tx-radius: 0.12, tx-distance: 0.13,
    tx-stroke: blue, label: [M], fill: white)
  cetz.draw.line("d.south", (rel: (0, -0.4), to: "d.south"))
})
