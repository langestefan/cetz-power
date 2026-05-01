#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Bus-bonded earth electrode at one end of a busbar.
  bus("b", (0, 0), length: 2, taps: 3)
  ground("g", "b.tap2")
})
