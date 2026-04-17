#import "/src/lib.typ" as pg
#import "@preview/cetz:0.3.2"
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  cetz.draw.set-style(powergretz: (transformer: (fill: yellow.lighten(80%))))
  transformer("t1", (0, 0), (2, 0))
})
