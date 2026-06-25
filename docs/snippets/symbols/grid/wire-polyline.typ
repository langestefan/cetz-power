#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A 132 kV transmission line linking three substations in series.
  // The conductor is one physical wire passing through all three
  // bus-mids — one `wire` call expresses that directly, instead of
  // three separate `wire(a, b)` calls.
  bus("subA", (0, 0), length: 1.0, angle: 90deg, label: (
    content: align(center)[Sub A \ 132 kV],
  ))
  bus("subB", (3, 0), length: 1.0, angle: 90deg, label: (
    content: align(center)[Sub B \ 132 kV],
  ))
  bus("subC", (6, 0), length: 1.0, angle: 90deg, label: (
    content: align(center)[Sub C \ 132 kV],
  ))
  wire("subA.mid", "subB.mid", "subC.mid")
})
