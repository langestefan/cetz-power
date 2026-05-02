#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Same radial feeder as the recipe — copied verbatim — with one
// extra cetz primitive: a power-flow arrow drawn on top of the
// feeder line between bus 2 and bus 3 to annotate the direction
// and magnitude of real power flow.
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
  // A power-flow arrow drawn ABOVE the feeder line (b2 → b3),
  // offset upward by 0.35 so it doesn't overlap the wire. Uses
  // cetz's `mark:` argument for the arrowhead.
  cetz.draw.line(
    (4.85, 0.35), (6.85, 0.35),
    stroke: 1pt + blue,
    mark: (end: ">", fill: blue),
  )
  // Caption above the arrow.
  cetz.draw.content(
    (5.85, 0.55),
    anchor: "south",
    text(size: 7pt, fill: blue)[$P = 800 "kW"$],
  )
})
