#import "/src/lib.typ" as pg
#import "@preview/cetz:0.4.2"
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  machine("default", (0, 0), "V")
  machine("big", (1.5, 0), "V", radius: 0.45, letter-size: 14pt)
  machine("filled", (3, 0), "G",
    stroke: 1.2pt + red, fill: red.lighten(85%))
  machine("math", (4.5, 0), [$Phi$], radius: 0.4)
  machine("multi", (6, 0), "DG", radius: 0.4)
})
