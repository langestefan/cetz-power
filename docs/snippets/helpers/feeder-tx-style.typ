#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// Per-station `tx-stroke` / `tx-fill` colour the transformers, the same way
// `stroke` / `fill` colour the load arrows — here each drop is colour-coded.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    (
      (label: [feeder A], load: [10 A], tx-stroke: red, stroke: red, fill: red),
      (
        label: [feeder B],
        load: [8 A],
        tx-stroke: blue,
        tx-fill: blue.lighten(75%),
        stroke: blue,
        fill: blue.lighten(40%),
      ),
    ),
    spacing: 2.6,
    extend: 0,
  )
})
