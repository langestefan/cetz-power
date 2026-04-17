#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  transformer("t1", (0, 0), (2, 0))
  transformer("t2", (4, 0), angle: 90deg)
})
