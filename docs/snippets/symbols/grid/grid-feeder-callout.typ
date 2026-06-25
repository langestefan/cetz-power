#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Two grids feeding the same bus from opposite sides — a classic
// "two-source" infeed for redundancy studies. Each grid is colour-
// coded after the utility / source it represents, with a side label
// (`label-east` / `label-west`) so the captions sit beside the symbol
// instead of above the lead.
#diagram(length: 1.2cm, {
  external-grid("ua", (0, 0), angle: 90deg,
    stroke: 1pt + rgb("#1f7ad9"),
    line-count: 3,
    label: (content: [Utility A], anchor: "north", distance: 0.25),
  )
  external-grid("ub", (5, 0), angle: -90deg,
    stroke: 1pt + rgb("#cc1122"),
    line-count: 3,
    label: (content: [Utility B], anchor: "north", distance: 0.25),
  )
  bus("tie", (2.5, 0), length: 1.2, angle: 90deg, label: [Common bus])
  wire("ua.in", "tie.mid")
  wire("ub.in", "tie.mid")
})
