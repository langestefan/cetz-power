#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Two wires side by side: one at the family-default stroke, one
  // with a per-call override. The third wire restyles a polyline.
  bus("b1", (0, 0),    length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)

  wire("b1.tap1", "b2.tap1")                          // default stroke
  wire("b1.tap2", "b2.tap2", stroke: 2pt + red)       // override on a 2-arg wire
  wire(                                               // override on a polyline
    "b1.tap3",
    (rel: (0, -0.7)),
    (rel: (0.4, -0.5)),
    "b2.tap3",
    stroke: 2pt + blue,
  )
})
