#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.1cm, {
  // Replicating a published figure: measure image pixels (y-down),
  // let the mapping flip and scale them. `0.01` is the compression
  // knob for the whole layout.
  let P = pixel-map(0.01, height: 300)
  external-grid("g", P(160, 60))
  bus("b1", P(60, 160), P(260, 160))
  wire("g.in", "b1.mid")
  load("l1", P(110, 160), on: "b1", label: [pixel-exact])
})
