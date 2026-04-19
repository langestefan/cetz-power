#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  machine("v", (0, 0), "V")
  machine("a", (1.2, 0), "A")
  machine("g", (2.4, 0), "G")
  machine("m", (3.6, 0), "M")
})
