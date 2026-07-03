#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A BESS unit: battery → DC/AC converter → grid bus, with the
  // converter's DC triangle facing the battery and the AC triangle
  // facing the grid.
  bus("mv", (2.2, 0), length: 1.2, angle: 90deg, label: [MV])
  converter("c", (0, 0), kind: "dc-ac", size: 0.6)
  wire("c.east", "mv.mid")
  battery("bat", (-2.0, 0), angle: -90deg, cells: 2)
  wire("bat.out", "c.west")
})
