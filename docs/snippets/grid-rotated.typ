#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 3, angle: 90deg, taps: 3)
  external-grid("g", "b.tap2", angle: 90deg, label: [132 kV \ 500 MVA])
})
