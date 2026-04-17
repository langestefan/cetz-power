#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *

  external-grid("eg", (0, 0), label: [132 kV, 500 MVA])
  wire("eg.default", (0, -1.5))

  transformer("t", (0, -1.5), (0, -3), label: [132/11 kV])

  bus("lv", (-2, -3), (2, -3), taps: 3)

  load("l", "lv.tap2", label: [10 MW])
})
