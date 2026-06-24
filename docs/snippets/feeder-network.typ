#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// A radial pair: two feeders off one riser, each from its own data.
#diagram(length: 1cm, {
  wire((0, 1.6), (0, -1.6))   // riser
  feeder("a", (0, 1.6),
    ((label: [11], load: [10 A]), (label: [12], load: [10 A])),
    lead: 1, spacing: 1.8, currents: ([20 A], [10 A], none))
  feeder("b", (0, -1.6),
    ((label: [21], load: [10 A]), (label: [22], load: [10 A])),
    lead: 1, spacing: 1.8, currents: ([20 A], [10 A], none))
})
