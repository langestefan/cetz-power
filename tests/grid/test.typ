#import "/tests/harness.typ": test
#import "/src/lib.typ" as pg

// External grid on a bus
#test({
  import pg: *
  bus("b", (0, 0), length: 3, taps: 3)
  external-grid("eg", "b.tap2")
})

// External grid at a point with label
#test({
  import pg: *
  external-grid("eg", (0, 0), label: [50 MVA \ 132 kV])
})
