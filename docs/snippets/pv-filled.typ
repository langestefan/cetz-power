#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 1.4, angle: 90deg)
  pv-panel("pv1", "b.start", size: 0.7, triangle-fill: black)
})
