#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: symmetric two-pole resistor.
#test({
  resistor("r", (0, 0))
})

// Single-pole shunt form.
#test({
  resistor("r", (0, 0), lead-out: 0)
})

// Geometry overrides.
#test({
  resistor("r", (0, 0), width: 0.5, length: 1.2, lead-in: 0.4, lead-out: 0.4)
})

// Series resistor between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  resistor("r", "b1.mid", angle: -90deg)
  wire("r.out", "b2.mid")
})

// Rotated 180deg (upside-down).
#test({
  resistor("r", (0, 0), angle: 180deg)
})

// With a label.
#test({
  resistor("r", (0, 0), label: [R₁])
})

// Family-level styling.
#test({
  cetz.draw.set-style(cetz-power: (resistor: (width: 0.5, fill: yellow.lighten(60%))))
  resistor("r1", (0, 0))
  resistor("r2", (1.2, 0))
})
