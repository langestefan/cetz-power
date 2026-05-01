#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Turtle-style: each `(rel: <vec>)` is "step from where I am now".
  // Useful for routing a stub or jog off a known anchor without
  // having to compute the absolute coordinates.
  bus("b", (0, 0), length: 4, taps: 3)
  wire(
    "b.tap2",
    (rel: (0, -0.5)),     // drop 0.5 down
    (rel: (1.0, 0)),      // jog 1.0 right
    (rel: (0, -0.6)),     // continue 0.6 down to the load
  )
  load("ld", (rel: (1.0, -1.1), to: "b.tap2"))
})
