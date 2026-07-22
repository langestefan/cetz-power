#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 7)
  ev-charger("e1", bus-frac("b", 0.15), kind: "charger", label: [DC fast])
  ev-charger("e2", bus-frac("b", 0.5), kind: "ev")
  ev-charger("e3", bus-frac("b", 0.85))
})
