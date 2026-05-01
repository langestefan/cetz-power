#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Three or more positional anchors form a polyline — each
  // consecutive pair is joined by a straight segment.
  bus("b1", (0, 0),    length: 1.2, angle: 90deg)
  bus("b2", (2, 0.6),  length: 1.2, angle: 90deg)
  bus("b3", (4, -0.4), length: 1.2, angle: 90deg)
  wire("b1.mid", "b2.mid", "b3.mid")
})
