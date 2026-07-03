#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A grid-forming converter block, colour-coded and wired to its bus
  // through a compass anchor — the style used in converter-dominated
  // network figures.
  let blu = rgb("#4472c4")
  bus("b1", (1.5, 0), length: 1.0, angle: 90deg, label: [1])
  converter(
    "gfm",
    (0, 0),
    stroke: 0.9pt + blu,
    label: (content: text(fill: blu)[GFM 1], distance: 0.12),
  )
  wire("gfm.east", "b1.mid")
})
