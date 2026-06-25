#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 3, taps: 3)
  bus("b2", (0, -1.5), length: 3, taps: 3)
  wire("b1.tap2", "b2.tap2")
})
