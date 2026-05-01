#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: 4 bumps, symmetric two-pole.
#test({
  inductor("l", (0, 0))
})

// Single-pole shunt form.
#test({
  inductor("l", (0, 0), lead-out: 0)
})

// Override bump count and radius.
#test({
  inductor("l1", (0, 0), bumps: 3, bump-radius: 0.15)
  inductor("l2", (1, 0), bumps: 6, bump-radius: 0.08)
})

// Series inductor between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  inductor("l", "b1.mid", angle: -90deg)
  wire("l.out", "b2.mid")
})

// Rotated.
#test({
  inductor("l", (0, 0), angle: -90deg)
})

// With a label.
#test({
  inductor("l", (0, 0), label: [L₁])
})
