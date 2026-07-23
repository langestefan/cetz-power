#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 2, label: [A])
  bus("b2", (5, 0), length: 2, label: [B])
  bus("b3", (5, -2.5), length: 2, label: (content: [C], anchor: "south"))

  // Wire labels default to the free side — and turn upright
  // automatically beside a vertical conductor.
  wire("b1.end", "b2.start", label: [NA2XS2Y 3×240])
  wire("b2.mid", "b3.mid", label: [500 m])

  // Segment-form note: caption between two anchors, at any fraction,
  // on either side.
  note("b1.end", "b2.start", [joint], at: 0.25, side: "south")
})
