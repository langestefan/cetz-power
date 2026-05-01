#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // `note()` is the standalone equivalent of the `wire(label: ...)`
  // shortcut — drops a caption at any anchor, midpoint, or absolute
  // coordinate. Useful when the label isn't tied to a wire (e.g.
  // labelling a tap point on a bus, or annotating an empty area).
  bus("b", (0, 0), length: 4, taps: 4)

  // 1. Label a specific tap by name.
  note("b.tap1", [first tap], side: "south")

  // 2. Mark the midpoint of two anchors via a CeTZ lerp coord.
  note(("b.tap2", 50%, "b.tap3"), [centre], side: "north")

  // 3. Free-floating annotation at an absolute coordinate.
  note((3.0, 0.7), [free coord], side: "east")
})
