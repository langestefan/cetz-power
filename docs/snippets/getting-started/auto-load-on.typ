#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Horizontal bus: `on:` drops the load straight below the bar;
  // `side: "north"` flips it above.
  bus("b1", (0, 0), length: 3)
  load("l1", bus-frac("b1", 0.2), on: "b1", label: [L₁])
  pv-panel("pv", bus-frac("b1", 0.5), on: "b1", side: "north")
  load("l3", bus-frac("b1", 0.8), on: "b1", label: [L₃])

  // Vertical bus: `on:` routes the design-rule L-bend — across,
  // then down. `side: "west"` picks the other side of the bar.
  bus("b2", (5, 0.6), (5, -1.2))
  load("l4", bus-frac("b2", 0.3), on: "b2", label: [east])
  load("l5", bus-frac("b2", 0.7), on: "b2", side: "west", label: [west])

  // `towards:` aims the arrow tip at a coordinate instead.
  load("l6", (7.5, -0.3), towards: (8.5, -1), label: [aimed])
})
