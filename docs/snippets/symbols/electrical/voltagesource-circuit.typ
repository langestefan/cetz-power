#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Bus-to-bus AC source — the symbol orients itself along the
  // in→out line, draws its own leads to the bus mid-points, and
  // exposes `in` / `out` for further wiring.
  bus("b1", (0, 0), length: 1.2, angle: 90deg)
  bus("b2", (3, 0), length: 1.2, angle: 90deg)
  voltagesource("v", "b1.mid", "b2.mid", kind: "ac")
})
