#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// External grid on a bus
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  external-grid("eg", "b.tap2")
})

// External grid at a point with label
#test({
  external-grid("eg", (0, 0), label: [50 MVA \ 132 kV])
})

// Rectangular external grid: wide (width only), tall (height only),
// and a denser wide box, connecting from its east/side anchors.
#test({
  external-grid("wide", (0, 0), width: 1.6)
  external-grid("tall", (3, 0), height: 1.6)
  external-grid(
    "dense",
    (6, 0),
    width: 1.8,
    height: 0.7,
    distance: 0,
    line-count: 4,
  )
  wire("dense.east", (8, 0.35))
})
