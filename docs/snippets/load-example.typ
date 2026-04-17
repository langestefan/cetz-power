#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 4, taps: 3)
  load("l1", "b.tap1")
  load("l2", "b.tap2", label: [10 MW])
  load("l3", "b.tap3", elbow: 0.4)
})
