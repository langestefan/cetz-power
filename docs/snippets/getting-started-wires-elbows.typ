#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), (4, 0), taps: 5)
  wire("b.tap2", (1, -1.5))
  elbow("b.tap4", (4, -1.5), corner: "h")
})
