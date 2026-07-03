#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Plain annotation arrow.
#test({
  flow-arrow((0, 0), (1.2, 0))
})

// Labelled, on both sides.
#test({
  flow-arrow((0, 0), (1.2, 0), label: [$Q_1$])
  flow-arrow((1.2, -0.5), (0, -0.5), label: [$Q_2$], side: "south")
})

// Dashed line — the arrowhead must stay solid.
#test({
  flow-arrow(
    (0, 0),
    (1.5, 0),
    stroke: (paint: black, thickness: 0.8pt, dash: "dashed"),
  )
})

// Coloured + scaled (current annotation on a phase conductor).
#test({
  wire((0, 0), (3, 0))
  flow-arrow((1.8, 0.25), (1.2, 0.25), stroke: 1pt + red, label: text(
    fill: red,
  )[$I_k$])
})

// Anchor / lerp coordinates as endpoints.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (2.5, 0), length: 1.0, angle: 90deg)
  wire("b1.mid", "b2.mid")
  flow-arrow(("b1.mid", 30%, "b2.mid"), ("b1.mid", 70%, "b2.mid"), label: [P])
})
