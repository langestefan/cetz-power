#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `angle` sets the run's angle of attack. The whole feeder rotates — run,
// taps, and perpendicular drops — while the text stays upright.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    (
      (label: [N1], load: [10 A]),
      (label: [N2], load: [10 A]),
      (label: [N3], load: [10 A]),
    ),
    angle: 22deg,
    currents: ([30 A], [20 A], [10 A], none),
  )
})
