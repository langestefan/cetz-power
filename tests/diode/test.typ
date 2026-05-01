#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: hollow triangle, both leads.
#test({
  diode("d", (0, 0))
})

// Filled (textbook engineering form).
#test({
  diode("d", (0, 0), fill: black)
})

// Single-pole.
#test({
  diode("d", (0, 0), lead-out: 0)
})

// Geometry overrides.
#test({
  diode("d", (0, 0), width: 0.6, height: 0.6, bar-width: 0.6)
})

// Series diode between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  diode("d", "b1.mid", angle: -90deg, fill: black)
  wire("d.out", "b2.mid")
})

// Reversed (180deg) — current direction flipped.
#test({
  diode("d", (0, 0), angle: 180deg)
})

// With a label.
#test({
  diode("d", (0, 0), label: [D₁])
})
