#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // All four coordinate forms in one wire:
  //   1. Named anchor — `"b1.mid"` (the start)
  //   2. `(rel: <vec>)` — offset from the previous point (b1.mid + (0, -0.4))
  //   3. `(rel: <vec>, to: <anchor>)` — offset from a specific anchor,
  //      ignoring the previous point (b2.mid + (0, 0.3))
  //   4. Named anchor — `"b2.mid"` (the end)
  //
  // Useful when a wire has to approach an anchor from a known
  // distance / direction without computing the absolute position.
  bus("b1", (0, 0),    length: 1.2, angle: 90deg)
  bus("b2", (2.5, -1), length: 1.2, angle: 90deg)
  wire(
    "b1.mid",
    (rel: (0, -0.4)),
    (rel: (0, 0.3), to: "b2.mid"),
    "b2.mid",
  )
})
