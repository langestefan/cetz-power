#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 5.5, taps: 4)
  factory(
    "f1",
    "b.tap1",
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  factory("f2", "b.tap2", box: false)
  factory("f3", "b.tap3", teeth: 4, windows: 4)
  factory("f4", "b.tap4", stroke: blue, window-fill: blue)
})
