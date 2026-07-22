#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 7)
  factory(
    "f1",
    bus-frac("b", 0.15),
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  factory("f2", bus-frac("b", 0.38), box: false)
  factory("f3", bus-frac("b", 0.62), teeth: 4, windows: 4)
  factory("f4", bus-frac("b", 0.85), stroke: blue, window-fill: blue)
})
