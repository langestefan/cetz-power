#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // No `taps:` — use bus-frac for ad-hoc fractional positions.
  bus("b1", (0, 0), length: 4, label: [LV])
  load("l1", bus-frac("b1", 1 / 6))
  load("l2", bus-frac("b1", 0.4))
  load("l3", bus-frac("b1", 0.85))
})
