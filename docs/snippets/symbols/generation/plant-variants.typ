#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 2.2cm, {
  // Enclosure variants: 1 = compartments, 2 = plain box, 3 = bare
  // icons, 4 / 5 = single-square composites.
  let kinds = ("wind", "pv-bess", "wind-pv-bess")
  for (v, y) in ((1, 0), (2, -1.6), (3, -3.2), (4, -4.8), (5, -6.4)) {
    let x = 0
    for k in kinds {
      let n = k.split("-").len()
      let w = n * 0.7
      let id = k.replace("-", "") + "-" + str(v)
      plant(
        id,
        (x + w / 2, y),
        kind: k,
        variant: v,
        label: (content: raw(id), anchor: "south", distance: 0.16),
      )
      x += w + 0.65
    }
  }
})
