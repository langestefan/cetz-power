#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `start` is any coordinate — here a bus mid-anchor, so the feeder hangs
// off existing geometry.
#diagram(length: 1.1cm, {
  bus("b", (0, 0), length: 2, angle: 90deg)
  feeder("f", "b.mid",
    ((label: [N1], load: [5 A]), (label: [N2], load: [5 A])),
    lead: 1, spacing: 1.8, currents: ([10 A], [5 A], none))
})
