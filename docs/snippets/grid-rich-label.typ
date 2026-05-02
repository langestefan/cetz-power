#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// A more involved example: tinted fill, thicker stroke, and a
// multi-line label with math content giving the data a power-system
// engineer cares about — short-circuit power, X/R ratio, and the
// nominal voltage.
#diagram(length: 1.2cm, {
  external-grid("g", (0, 0),
    size: 1.0,
    stroke: 1.2pt + rgb("#1a4d8f"),
    fill: rgb("#e8f0fa"),
    line-count: 3,
    label: (
      content: align(center)[
        Upstream grid \
        $S_"sc" = 500 "MVA"$ \
        $X slash R = 10$
      ],
      anchor: "north",
      distance: 0.25,
    ),
  )
})
