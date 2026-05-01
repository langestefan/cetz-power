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
