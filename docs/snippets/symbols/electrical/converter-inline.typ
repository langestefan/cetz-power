#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Two-node placement: the body sits at the midpoint with leads to
  // the endpoints — an HVDC-style link between two AC buses.
  bus("ac", (0, 0), length: 1.0, angle: 90deg, label: [AC])
  bus("dc", (3, 0), length: 1.0, angle: 90deg, label: [DC])
  converter("c", "ac.mid", "dc.mid")
})
