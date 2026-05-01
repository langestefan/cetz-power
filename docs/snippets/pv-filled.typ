#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 1.4, angle: 90deg, label: [9])
  pv-panel("pv", bus-frac("b", 1/6), elbow: 0.5, label: [PV], triangle-fill: black)
})
