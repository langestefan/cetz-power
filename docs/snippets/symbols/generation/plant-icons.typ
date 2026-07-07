#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 2.2cm, {
  // Per-technology icon styles, numbered on the kind token itself.
  let rows = (
    ("wind", "wind2", "wind3", "pv"),
    ("pv2", "pv3", "bess", "bess2"),
  )
  for (r, row) in rows.enumerate() {
    for (i, k) in row.enumerate() {
      plant(
        k,
        (i * 1.35, r * -1.55),
        kind: k,
        label: (content: raw(k), anchor: "south", distance: 0.16),
      )
    }
  }
})
