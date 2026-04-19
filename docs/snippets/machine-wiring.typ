#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  machine("v", (0, 0), "V")
  bus("b1", (2, 0), length: 1.2, angle: 90deg)
  wire("v.east", "b1.mid")
})
