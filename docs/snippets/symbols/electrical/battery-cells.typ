#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Multi-cell stacks via `cells:`.
  battery("b1", (0, 0), label: (content: [1], anchor: "south"))
  battery("b2", (1.2, 0), cells: 2, label: (content: [2], anchor: "south"))
  battery("b3", (2.4, 0), cells: 3, label: (content: [3], anchor: "south"))
})
