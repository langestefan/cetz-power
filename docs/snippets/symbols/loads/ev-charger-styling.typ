#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 8)
  ev-charger("e1", bus-frac("b", 0.15), box: false)
  ev-charger(
    "e2",
    bus-frac("b", 0.5),
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  ev-charger("e3", bus-frac("b", 0.85), kind: "charger", stroke: blue)
})
