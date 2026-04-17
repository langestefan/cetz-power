#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})
