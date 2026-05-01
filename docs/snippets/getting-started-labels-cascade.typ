#import "/src/lib.typ" as pg
#import "@preview/cetz:0.4.2"
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Family-level default — every bus from here on labels itself below
  // (anchor: "south") with a wider gap. Per-call labels still win,
  // so b3 ignores the family default and goes north instead.
  cetz.draw.set-style(cetz-power: (bus: (
    label: (anchor: "south", distance: 0.35),
  )))
  bus("b1", (0, 0), length: 1.4, label: [HV])
  bus("b2", (2, 0), length: 1.4, label: [MV])
  bus("b3", (4, 0), length: 1.4, label: (
    content: [LV],
    anchor: "north",
  ))
})
