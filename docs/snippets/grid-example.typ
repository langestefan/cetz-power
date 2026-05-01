#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  external-grid("g", (0, 0), label: [132 kV \ 500 MVA])
  bus("b", (-1.5, -1.5), (1.5, -1.5), taps: 1)
  wire("g.default", "b.tap1")
})
