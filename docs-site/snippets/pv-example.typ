#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 1.4, angle: 90deg, label: [9])
  pv-panel("pv", bus-frac("b", 1/6), elbow: 0.5, label: [80 m])
})
