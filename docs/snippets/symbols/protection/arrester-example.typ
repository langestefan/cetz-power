#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The canonical shunt form: phase conductor → arrester → earth,
  // arrow pointing toward the earthed side.
  bus("b", (0, 0), length: 1.6, label: [HV])
  arrester("a", "b.mid", (0, -1.5))
  ground("g", "a.out")
})
