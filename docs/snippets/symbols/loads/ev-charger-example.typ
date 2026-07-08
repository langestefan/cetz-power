#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 6, taps: 3)
  ev-charger("e1", "b.tap1", kind: "charger", label: [DC fast])
  ev-charger("e2", "b.tap2", kind: "ev")
  ev-charger("e3", "b.tap3")
})
