#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 4, taps: 3)
  wire("b.tap2", (0, -1.2))
  load("ld", (0, -1.2))
})
