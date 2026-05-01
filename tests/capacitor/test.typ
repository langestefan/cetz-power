#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default shunt cap — single lead, no top lead, no ground return.
#test({
  capacitor("c", (0, 0))
})

// Connection: cap above a bus, wire from bus tap to c.in.
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  capacitor("c", (1.5, 1.0))
  wire("b.tap2", "c.in")
})

// Geometry overrides: wider plates, bigger gap, longer in-lead.
#test({
  capacitor("c", (0, 0),
    plate-width: 0.9,
    plate-gap: 0.3,
    lead-in: 0.6,
  )
})

// Series cap: lead-out > 0 exposes an `out` anchor for in-line use.
#test({
  bus("b1", (0, 0), length: 1.2, angle: 90deg)
  bus("b2", (3, 0), length: 1.2, angle: 90deg)
  capacitor("c", "b1.mid", lead-in: 0.4, lead-out: 0.4, angle: 90deg)
  wire("c.out", "b2.mid")
})

// Rotated cap (180deg): leads downward, plates below the connection.
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  capacitor("c", "b.tap2", angle: 180deg)
})

// With a label.
#test({
  capacitor("c", (0, 0), label: [Q-comp])
})

// Family-level styling.
#test({
  cetz.draw.set-style(cetz-power: (capacitor: (
    "plate-width": 0.7,
    "plate-gap": 0.18,
    stroke: 1.2pt + blue,
  )))
  capacitor("c1", (0, 0))
  capacitor("c2", (1.5, 0))
  capacitor("c3", (3.0, 0))
})
