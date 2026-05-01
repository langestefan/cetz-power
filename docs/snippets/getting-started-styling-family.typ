#import "/src/lib.typ" as pg
#import "@preview/cetz:0.4.2"
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Family override — every transformer in this canvas gets a bigger
  // radius. Other symbols are unaffected.
  cetz.draw.set-style(cetz-power: (transformer: (radius: 0.5)))

  transformer("t1", (0, 0), (2.5, 0))
  transformer("t2", (0, -1.6), (2.5, -1.6))
  bus("b1", (4, 0), length: 1.6, angle: 90deg) // bus is unaffected
})
