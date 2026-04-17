#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  external-grid("g", (0, 1.3),
    label: (content: [132 kV], anchor: "east", distance: 0.2))
  wire("g.in", (0, 0.7))
  transformer("t", (0, 0.7), (0, -0.7),
    label: (content: [132/11 kV], anchor: "east", distance: 0.2))
  bus("b", (-1, -1.3), (1, -1.3), taps: 5)
  wire("t.out", "b.tap3")
  load("l1", "b.tap2", label: [10 MW])
  load("l2", "b.tap4", label: [8 MW])
})
