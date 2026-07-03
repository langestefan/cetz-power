#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The rectangle is a named CeTZ element, so its compass anchors
  // stay available — here a feed routed to the boundary's west edge.
  area("plant", (0, 0), (2.6, 1.6), title: [Converter], side: "north")
  bus("b", (-1.8, 0.8), length: 1.2, angle: 90deg)
  wire("b.mid", "plant.west")
})
