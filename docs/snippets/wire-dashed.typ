#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Three substations in a row. Sub A and Sub B are connected by
  // an existing solid feeder; Sub C is a planned addition wired
  // back to Sub B by a future dashed tie-line. The full CeTZ
  // stroke dict `(paint: ..., thickness: ..., dash: ...)` lets you
  // combine colour, thickness, and dash pattern in one override.
  bus("subA", (0, 0), length: 1.2, angle: 90deg, label: [Sub A])
  bus("subB", (3, 0), length: 1.2, angle: 90deg, label: [Sub B])
  bus("subC", (6, 0), length: 1.2, angle: 90deg, label: (
    content: align(center)[Sub C \ (planned)],
  ))

  // Existing — default solid stroke
  wire("subA.mid", "subB.mid")

  // Planned future tie-line — darker grey, thicker, dashed
  wire("subB.mid", "subC.mid",
    stroke: (
      paint: gray.darken(40%),
      thickness: 1.5pt,
      dash: "dashed",
    ),
  )
})
