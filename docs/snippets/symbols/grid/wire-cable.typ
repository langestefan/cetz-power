#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // kind: "cable" re-dashes the wire stroke, so underground cables
  // read differently from overhead lines. Works on elbows too.
  bus("a", (0, 0), length: 1, angle: 90deg)
  bus("b", (3, 0), length: 1, angle: 90deg)
  wire("a.mid", "b.mid", kind: "cable", label: [630 mm² cable])
  wire((0, -0.9), (3, -0.9), label: [overhead line], label-side: "south")
  elbow((3, -1.8), (4.2, -1.0), corner: "h", kind: "cable")
})
