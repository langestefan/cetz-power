#import "/src/lib.typ": *
#set page(margin: 2pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 1.2, angle: 90deg, label: [9])
  pv-panel("pv", bus-frac("b", 1/3), elbow: 0.5, label: [PV])
})
