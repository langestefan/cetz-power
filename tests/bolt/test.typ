#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default vertical bolt with arrow.
#test({
  bolt("b", (0, 0), (0, -1.5))
})

// Horizontal, no arrow.
#test({
  bolt("b", (0, 0), (2, 0), arrow: false)
})

// Coloured stroke + matching arrow color.
#test({
  bolt("b", (0, 0), (0, -1.5), stroke: 1.5pt + red, arrow-color: red)
})

// Different segment counts: 2 (Z), 4 (default), 8 (noisy).
#test({
  bolt("b1", (0,   0), (0,   -1.5), segments: 2)
  bolt("b2", (1.0, 0), (1.0, -1.5))
  bolt("b3", (2.0, 0), (2.0, -1.5), segments: 8)
})

// Wider amplitude.
#test({
  bolt("b", (0, 0), (0, -1.5), amplitude: 0.3)
})

// Bus-to-bus diagonal placement.
#test({
  bus("b1", (0, 1), length: 1.0)
  bus("b2", (3, -1), length: 1.0)
  bolt("flt", "b1.mid", "b2.mid", stroke: 1.2pt + red, arrow-color: red)
})
