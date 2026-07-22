#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 5)
  factory("f1", bus-frac("b", 0.15))
  factory("f2", bus-frac("b", 0.5), label: [Plant A])
  factory("f3", bus-frac("b", 0.85), smoke: true)
})
