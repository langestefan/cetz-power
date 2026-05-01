#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Default — uses the family default position (north).
  transformer("t1", (0, 0), (2, 0), label: [default])

  // anchor: "south" puts the text below the symbol.
  transformer("t2", (0, -1.4), (2, -1.4), label: (
    content: [south],
    anchor: "south",
  ))

  // distance: widens the gap between the symbol and the text.
  transformer("t3", (4, 0), (6, 0), label: (
    content: [far north],
    distance: 0.6,
  ))

  // anchor on a non-compass name (transformer's primary anchor).
  transformer("t4", (4, -1.4), (6, -1.4), label: (
    content: [primary],
    anchor: "primary",
    align: "east",
  ))
})
