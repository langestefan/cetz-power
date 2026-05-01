#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Series cap between two buses. Default has both leads, so the cap
  // exposes both `in` and `out`. Rotate -90deg to lay it flat along a
  // horizontal wire.
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  capacitor("c1", "b1.mid", angle: -90deg)
  capacitor("c2", "c1.out", angle: -90deg)
  wire("c2.out", "b2.mid")
})
