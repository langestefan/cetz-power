#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Default orientation: HV winding to the left, two secondaries right.
  transformer3("t1", (0, 0))
  // Rotated a quarter turn: HV now points down.
  transformer3("t2", (2.5, 0), angle: -90deg)
})
