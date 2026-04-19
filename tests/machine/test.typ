#import "/tests/harness.typ": test

// Plain circle, no letter.
#test({
  import "/src/lib.typ": *
  machine("m", (0, 0))
})

// Letters: V, A, G, M (positional form).
#test({
  import "/src/lib.typ": *
  machine("v",  (0, 0), "V")
  machine("a",  (1.2, 0), "A")
  machine("g",  (2.4, 0), "G")
  machine("m",  (3.6, 0), "M")
})

// Style overrides: custom radius, stroke colour, fill, larger letter.
#test({
  import "/src/lib.typ": *
  machine("big", (0, 0), letter: "V", radius: 0.5, stroke: 1.2pt + red,
          fill: red.lighten(85%), letter-size: 14pt)
})

// Wire connections via compass-edge anchors.
#test({
  import "/src/lib.typ": *
  machine("v", (0, 0), letter: "V")
  bus("b1", (2, 0), length: 1.2, angle: 90deg)
  wire("v.east", "b1.mid")
})

// External label via the standard label dict.
#test({
  import "/src/lib.typ": *
  machine("gen", (0, 0), letter: "A",
          label: (content: align(center)[Asynchronous \ generator],
                  anchor: "south", distance: 0.35))
})

// Arbitrary content inside (math mode, multi-char).
#test({
  import "/src/lib.typ": *
  machine("phi", (0, 0), letter: [$Phi$], radius: 0.4)
  machine("dg",  (1.5, 0), letter: "DG", radius: 0.4)
})
