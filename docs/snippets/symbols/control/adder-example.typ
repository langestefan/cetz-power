#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // Classic feedback comparison: reference minus feedback.
  adder("sum", (1.4, 0))
  flow-arrow((0.2, 0), "sum.west", label: [$r$], side: "north")
  flow-arrow((1.4, -0.9), "sum.south", label: [$y$], side: "east")
  flow-arrow("sum.east", (2.6, 0), label: [$e$], side: "north")
  note((1.2, 0.16), [$+$], side: "north", distance: 0.02, size: 7pt)
  note((1.56, -0.28), [$-$], side: "east", distance: 0.02, size: 7pt)
})
