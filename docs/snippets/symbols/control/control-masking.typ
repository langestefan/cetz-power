#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // fill: white masks the conductor beneath — place the junction ON a
  // drawn wire instead of splitting the wire in two.
  wire((0, 0), (3, 0))
  adder("a", (1, 0), fill: white)
  mixer("m", (2, 0), fill: white)
})
