#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 2cm, {
  // Three entries (hv, lv, tv); marks stay upright under `angle:`.
  transformer3("t1", (0, 0), vector: ("delta", "wye", "wye"), label: [Dyn11yn])
  transformer3("t2", (2, 0), angle: 90deg, vector: ("delta", "wye", "zigzag"))
})
