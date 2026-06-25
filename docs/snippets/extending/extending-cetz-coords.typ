#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// CeTZ primitives accept every coordinate form cetz-power exposes —
// anchor strings, `bus-frac` lerps, `(rel: vec, to: anchor)` offsets.
// Pin a custom annotation to a symbol's anchor and it follows when
// the symbol moves.
#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 1.4, angle: 90deg, label: [HV])
  bus("b2", (3, 0), length: 1.4, angle: 90deg, label: [LV])
  transformer("t", "b1.mid", "b2.mid")

  // CeTZ line + content, both anchored to the transformer's
  // `primary` anchor — no absolute coordinates anywhere.
  cetz.draw.line(
    "t.primary",
    (rel: (-0.2, 0.6), to: "t.primary"),
    stroke: 0.8pt + blue,
    mark: (start: ">", fill: blue),
  )
  cetz.draw.content(
    (rel: (0.1, 0.65), to: "t.primary"),
    anchor: "south-east",
    text(size: 7pt, fill: blue)[HV side],
  )
})
