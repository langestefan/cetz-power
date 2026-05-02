#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// `background:` tints the inside of the square — the area behind
// the cross-hatching. Use it to colour-code source strength /
// voltage level / system zone without changing the stroke.
#diagram(length: 1.2cm, {
  external-grid("g1", (0, 0),
    background: rgb("#e8f0fa"),
    label: [light blue],
  )
  external-grid("g2", (1.8, 0),
    background: rgb("#fff5d9"),
    line-count: 3,
    label: [denser hatch],
  )
  external-grid("g3", (3.6, 0),
    background: rgb("#ffe6e6"),
    stroke: 1pt + rgb("#cc1122"),
    line-count: 3,
    label: [HV infeed],
  )
})
