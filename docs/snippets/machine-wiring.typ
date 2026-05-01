#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  machine("v", (0, 0), "V")
  bus("b1", (2, 0), length: 1.2, angle: 90deg)
  wire("v.east", "b1.mid")
})
