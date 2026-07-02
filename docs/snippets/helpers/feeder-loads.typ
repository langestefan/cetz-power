#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// Per-station `stroke` / `fill` restyle each load arrow independently —
// hollow-thin, thick, or coloured. `tx: false` keeps the focus on the arrows.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    (
      (label: [thin], load: [2 A], stroke: 0.4pt + black, fill: none),
      (label: [thick], load: [5 A], stroke: 1.5pt + black),
      (label: [red], load: [3 A], stroke: red, fill: red),
      (label: [blue], load: [4 A], stroke: blue, fill: blue.lighten(50%)),
    ),
    tx: false,
    spacing: 2.0,
    extend: 0,
  )
})
