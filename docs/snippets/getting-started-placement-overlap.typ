#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Wide span: leads are drawn from each endpoint to the circles.
  bus("a1", (0, 0), length: 0.6, angle: 90deg)
  bus("a2", (3, 0), length: 0.6, angle: 90deg)
  transformer("t1", "a1.mid", "a2.mid")

  // Narrow span: endpoints fall inside the transformer body, so no
  // leads are drawn — the circles cover the connection points instead.
  bus("b1", (5, 0), length: 0.6, angle: 90deg)
  bus("b2", (5.6, 0), length: 0.6, angle: 90deg)
  transformer("t2", "b1.mid", "b2.mid")
})
