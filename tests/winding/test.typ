#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Each shape on its own at clock 0 (default orientation: V on top).
#test({
  delta("d0", (0, 0))
  wye("y0", (2, 0))
  zigzag("z0", (4, 0))
})

// Lowercase secondary terminals.
#test({
  delta("d0", (0, 0), terminals: ("u", "v", "w"))
  wye("y0", (2, 0), terminals: ("u", "v", "w"))
  zigzag("z0", (4, 0), terminals: ("u", "v", "w"))
})

// Outer captions sit clear of the per-terminal labels.
#test({
  delta("d", (0, 0), label: [Δ])
  wye("y", (2, 0), label: [Y])
  zigzag("z", (4, 0), label: [Z])
})

// Rotation by clock number (angle = -clock * 30deg). Reproduces the
// secondary windings from rows Yy0, Yy6, Dy11, Yd5 of the reference.
#test({
  // Yy0 — both upright.
  wye("p1", (0, 0))
  wye("s1", (1.6, 0), terminals: ("u", "v", "w"))

  // Yy6 — secondary rotated 180°.
  wye("p2", (3.6, 0))
  wye("s2", (5.2, 0), terminals: ("u", "v", "w"), angle: 180deg)

  // Dy11 — primary delta, secondary wye rotated -30°.
  delta("p3", (7.2, 0))
  wye("s3", (8.8, 0), terminals: ("u", "v", "w"), angle: -330deg)
})

// Style overrides: bigger, thicker stroke, custom label size.
// Style keys with dashes must be passed via the family dict because
// Typst named arguments don't accept quoted identifiers.
#test({
  cetz.draw.set-style(cetz-power: (
    winding: (size: 0.9, stroke: 1.4pt + black, "label-size": 11pt),
  ))
  delta("d", (0, 0))
})

// Pair a wye-primary with a zigzag-secondary at clock 5
// (Yz5 from the reference image).
#test({
  wye("p", (0, 0))
  zigzag("s", (2, 0), terminals: ("u", "v", "w"), angle: -150deg)
})

// Wires can connect to terminals by name.
#test({
  wye("y", (0, 0))
  bus("b", (2.5, 0), length: 1.6, angle: 90deg)
  wire("y.v", "b.tap1")
})

// Two-winding diagram in the spirit of the reference table:
// a Dy11 transformer drawn from its winding shapes.
#test({
  delta("hv", (0, 0), label: [HV])
  wye("lv", (2.4, 0), terminals: ("u", "v", "w"), angle: -330deg, label: [LV])
})
