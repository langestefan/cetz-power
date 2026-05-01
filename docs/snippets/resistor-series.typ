#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Series resistor between two buses, rotated -90deg so the leads
  // run horizontal.
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (1.5, 0), length: 1.0, angle: 90deg)
  resistor("r", "b1.mid", angle: -90deg)
  wire("r.out", "b2.mid")
})
