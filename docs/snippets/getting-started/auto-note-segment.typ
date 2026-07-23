#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 2, label: [A])
  bus("b2", (5, 0), length: 2, label: [B])
  bus("b3", (5, -2.5), length: 2, label: (content: [C], anchor: "south"))

  // link() taps each bar's interior and routes perpendicular legs —
  // here a U below the collinear bars — and captions the longest leg.
  link("b1", "b2", label: [NA2XS2Y 3×240])

  // A plain wire between interior taps still labels itself: the
  // caption turns upright beside the vertical conductor.
  wire("b2.mid", "b3.mid", label: [500 m])

  // Segment-form note: caption between two anchors, at any fraction,
  // on either side.
  note("b2.mid", "b3.mid", [joint], at: 0.7, side: "west")
})
