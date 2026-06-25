#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // `label-side:` picks which side of the midpoint the label sits
  // on — the eight compass directions are accepted. Use it when
  // the default (above the wire) would clash with another element.
  wire((0,  0),   (3,  0),   label: [north (default)])
  wire((0, -1),   (3, -1),   label: [south], label-side: "south")
  wire((0, -2.2), (3, -2.2),
    label: [further away], label-side: "north", label-distance: 0.35)
})
