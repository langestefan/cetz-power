#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The most common case: drop a caption above a wire by passing
  // `label:`. Default position is `north` (above the midpoint).
  bus("b1", (0, 0), length: 1.2, angle: 90deg, label: [Sub A])
  bus("b2", (3, 0), length: 1.2, angle: 90deg, label: [Sub B])
  wire("b1.mid", "b2.mid", label: [Tie cable])
})
