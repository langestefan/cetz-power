#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Power-flow annotation above a link between two buses.
  bus("a", (0, 0), length: 1.0, angle: 90deg, label: [A])
  bus("b", (3, 0), length: 1.0, angle: 90deg, label: [B])
  wire("a.mid", "b.mid")
  flow-arrow(("a.mid", 30%, "b.mid"), ("a.mid", 70%, "b.mid"), label: [$P$])
})
