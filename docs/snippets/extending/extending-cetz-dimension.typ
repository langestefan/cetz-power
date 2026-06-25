#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Same radial feeder, with a dimension line below the b2→b3 feeder
// indicating the physical cable distance — the kind of annotation
// you'd find on an as-built network drawing.
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
  // Dimension line: short ticks on the two endpoints, an arrow-headed
  // segment between them, and a caption above. All cetz primitives.
  let y-dim = -1.0
  cetz.draw.line((4.6, y-dim - 0.1), (4.6, y-dim + 0.1), stroke: 0.6pt + black)
  cetz.draw.line((7.0, y-dim - 0.1), (7.0, y-dim + 0.1), stroke: 0.6pt + black)
  cetz.draw.line(
    (4.6, y-dim), (7.0, y-dim),
    stroke: 0.6pt + black,
    mark: (end: ">", fill: black),
  )
  cetz.draw.content(
    ((4.6 + 7.0) / 2, y-dim),
    anchor: "south",
    padding: 0.08,
    text(size: 7pt)[1.2 km],
  )
})
