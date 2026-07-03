#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Two-node placement: the circle sits at the midpoint and the
  // conductor is drawn through it in one call.
  bus("a", (0, 0), length: 1.0, angle: 90deg)
  bus("b", (2.6, 0), length: 1.0, angle: 90deg)
  ct("c1", "a.mid", "b.mid", label: [CT])
})
