#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Dy11 — primary delta, secondary wye rotated by 11 × 30° = 330° clockwise
// (the standard distribution-transformer vector group).
#diagram(length: 1.2cm, {
  delta("hv", (0, 0), label: [HV])
  wye("lv", (2.5, 0), terminals: ("u", "v", "w"), angle: -330deg, label: [LV])
})
