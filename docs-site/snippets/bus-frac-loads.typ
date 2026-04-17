#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 4)
  load("l1", bus-frac("b1", 0.25))
  load("l2", bus-frac("b1", 0.50))
  load("l3", bus-frac("b1", 0.75))
})
