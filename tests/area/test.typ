#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: dashed box, title inside the north-west corner.
#test({
  area("a", (0, 0), (3, 2), title: [Feeder 1])
  bus("b1", (1.5, 0.6), length: 1.5)
})

// Title sides: inside north (station envelope) and south-west.
#test({
  area("st", (0, 0), (3, 2), title: [Onderstation], side: "north", size: 9pt)
  area(
    "dv",
    (3.6, 0),
    (6.6, 2),
    title: [DVPP area],
    side: "south-west",
    fill: luma(245),
    radius: 0.12,
  )
})

// Title outside the border.
#test({
  area("a", (0, 0), (3, 1.5), title: [plant], side: "north", inside: false)
})

// Borderless backdrop (fill only).
#test({
  area(
    "bg",
    (0, 0),
    (3.5, 2),
    title: [TSO area],
    stroke: none,
    fill: luma(
      236,
    ),
  )
  bus("b1", (1.7, 0.8), length: 1.5)
})

// The rectangle's anchors stay usable for routing.
#test({
  area("box", (0, 0), (2.5, 1.5), title: [Converter], side: "north")
  bus("b1", (-1.5, 0.75), length: 1.0, angle: 90deg)
  wire("b1.mid", "box.west")
})
