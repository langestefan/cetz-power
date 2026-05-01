#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  inductor("l", "b1.mid", angle: -90deg)
  wire("l.out", "b2.mid")
})
