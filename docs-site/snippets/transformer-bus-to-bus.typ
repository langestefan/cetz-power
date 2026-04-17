#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  transformer("t", "b1.mid", "b2.mid")
})
