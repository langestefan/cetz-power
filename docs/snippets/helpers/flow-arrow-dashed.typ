#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Opposing flows: solid forward, dashed return. The arrowhead of
  // the dashed arrow stays solid — flow-arrow builds the mark stroke
  // itself, which is exactly the CeTZ gotcha it exists to hide.
  flow-arrow((0, 0.25), (1.4, 0.25), label: [$Q_1$])
  flow-arrow(
    (1.4, -0.25),
    (0, -0.25),
    label: [$Q_2$],
    side: "south",
    stroke: (paint: black, thickness: 0.8pt, dash: "dashed"),
  )
})
