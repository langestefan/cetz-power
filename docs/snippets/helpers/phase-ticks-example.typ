#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The three-phase conductor mark on a line between two buses.
  bus("a", (0, 0), length: 1.0, angle: 90deg)
  bus("b", (3, 0), length: 1.0, angle: 90deg)
  wire("a.mid", "b.mid")
  phase-ticks(("a.mid", 35%, "b.mid"))
})
