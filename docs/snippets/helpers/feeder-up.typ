#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `up: true` hangs the drops above the run; the captions and current
// labels flip to the underside to match.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    (
      (label: [A], load: [5 A]),
      (label: [B], load: [5 A]),
      (label: [C], load: [5 A]),
    ),
    currents: ([15 A], [10 A], [5 A], none),
    up: true,
    extend: 0,
  )
})
