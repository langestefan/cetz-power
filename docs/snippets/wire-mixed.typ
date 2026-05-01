#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Anchor → relative offset → absolute coord → anchor — every
  // coordinate form mixed in one wire call.
  bus("b1", (0, 0),    length: 1.2, angle: 90deg)
  bus("b2", (3, -1.0), length: 1.2, angle: 90deg)
  wire(
    "b1.end",            // start at a named anchor
    (rel: (0.4, 0)),     // step 0.4 right
    (1.6, 0),            // jump to an absolute coord
    (rel: (0, -1.0)),    // drop 1.0 down
    "b2.end",            // and end at another named anchor
  )
})
