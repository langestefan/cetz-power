#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  transformer("t", "b1.mid", "b2.mid")
})
