#import "/src/lib.typ" as pg

#set page(margin: 10pt, width: auto, height: auto)

= Smoke test: bus

#pg.diagram({
  import pg: *
  bus("b1", (0, 0), length: 4, taps: 5)
})

= Two-node bus + wire

#pg.diagram({
  import pg: *
  bus("b1", (0, 0), (4, 0), taps: 5)
  wire("b1.tap3", (3, -2))
})

= Vertical bus with angle

#pg.diagram({
  import pg: *
  bus("b1", (0, 0), length: 3, taps: 4, angle: 90deg)
})

= Elbow wire

#pg.diagram({
  import pg: *
  bus("b1", (0, 0), (4, 0), taps: 3)
  elbow("b1.tap2", (2, -1.5))
})
