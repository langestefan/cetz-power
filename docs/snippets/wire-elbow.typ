#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), (4, 0), taps: 5)
  elbow("b.tap2", (0.5, -1.5), corner: "v")
  elbow("b.tap4", (4, -1.5), corner: "h")
})
