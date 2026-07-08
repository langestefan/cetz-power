#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 7, taps: 3)
  ev-charger("e1", "b.tap1", box: false)
  ev-charger(
    "e2",
    "b.tap2",
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  ev-charger("e3", "b.tap3", kind: "charger", stroke: blue)
})
