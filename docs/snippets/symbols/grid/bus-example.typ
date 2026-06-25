#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 5, taps: 5)
  // Little stubs to show the tap points.
  for i in range(1, 6) {
    wire("b1.tap" + str(i), (rel: (0, -0.4), to: "b1.tap" + str(i)))
  }
})
