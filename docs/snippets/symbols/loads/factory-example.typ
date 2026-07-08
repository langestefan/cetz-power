#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b", (0, 0), length: 4, taps: 3)
  factory("f1", "b.tap1")
  factory("f2", "b.tap2", label: [Plant A])
  factory("f3", "b.tap3", smoke: true)
})
