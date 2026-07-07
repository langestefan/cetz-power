#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // Multiplication point: a reference scaled by a measured signal.
  mixer("mul", (1.4, 0))
  flow-arrow((0.2, 0), "mul.west", label: [$i^*_(d q)$], side: "north")
  flow-arrow((1.4, -0.9), "mul.south", label: [$i_(d q)$], side: "east")
  flow-arrow("mul.east", (2.6, 0))
})
