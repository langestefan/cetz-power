#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `tx: false` drops the transformers — each load hangs straight off its tap.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    (
      (label: [L1], load: [6 A]),
      (label: [L2], load: [6 A]),
      (label: [L3], load: [6 A]),
    ),
    tx: false,
    currents: ([18 A], [12 A], [6 A], none),
  )
})
