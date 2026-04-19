#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.6cm, {
  import pg: *
  machine("m", (0, 0), "A",
    label: (content: [NE tag], anchor: "north-east", distance: 0.05))
  // Add more corner labels with extra cetz.draw.content calls if you
  // need several captions around the same machine — the label: dict
  // only takes one.
  cetz.draw.content("m.south-east", anchor: "north-west", padding: 0.05,
    text(size: 7pt)[SE tag])
  cetz.draw.content("m.south-west", anchor: "north-east", padding: 0.05,
    text(size: 7pt)[SW tag])
  cetz.draw.content("m.north-west", anchor: "south-east", padding: 0.05,
    text(size: 7pt)[NW tag])
})
