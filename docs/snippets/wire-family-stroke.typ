#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Family-level override: every `wire` and `elbow` drawn after
  // this set-style call picks up the new stroke automatically —
  // no per-call repetition. Symbol bodies (the buses, transformer)
  // keep their own strokes.
  cetz.draw.set-style(cetz-power: (wire: (stroke: 1.4pt + orange)))

  bus("b1", (0, 0), length: 1.5, angle: 90deg)
  bus("b2", (3, 0), length: 1.5, angle: 90deg)
  wire("b1.mid", "b2.mid")
  elbow("b1.start", "b2.end", corner: "h")
})
