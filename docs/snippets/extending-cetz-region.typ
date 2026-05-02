#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Same radial feeder, this time with a dashed bounding box around
// the LV side of the network (everything downstream of the
// transformer) — the kind of "control area" or "study boundary"
// annotation that's common in engineering drawings.
#diagram(length: 1.2cm, {
  bus("b1", (1.7, 0), length: 1.4, angle: 90deg, label: [1])
  bus("b2", (4.6, 0), length: 1.4, angle: 90deg, label: [2])
  bus("b3", (7.0, 0), length: 1.4, angle: 90deg, label: [3])
  external-grid("g", (0.7, 0), angle: 90deg)
  wire("g.in", "b1.mid")
  transformer("t", "b1.mid", "b2.mid", label: [10/0.4 kV])
  wire("b2.mid", "b3.mid")
  load("ld", bus-frac("b3", 1/6), elbow: 0.4)

  // ── cetz extras ──────────────────────────────────────────────────
  // Dashed rectangle around the LV side. cetz.draw.rect takes two
  // opposite corners; we leave the inside unfilled so the symbols
  // underneath stay visible.
  cetz.draw.rect(
    (4.0, -1.4), (8.0, 1.5),
    stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
    fill: none,
  )
  // Caption pinned to the top-left corner of the box.
  cetz.draw.content(
    (4.0, 1.2),
    anchor: "south-west",
    padding: 0.05,
    text(size: 7pt, fill: gray)[LV distribution],
  )
})
