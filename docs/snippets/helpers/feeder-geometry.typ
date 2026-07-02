#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// Size the drop: a longer `drop`, a larger transformer, a bigger arrow.
// The load caption tracks the arrow tip automatically — no `load-gap` tweak.
#diagram(length: 1.1cm, {
  feeder(
    "f",
    (0, 0),
    ((label: [big], load: [10 A]), (label: [drop], load: [10 A])),
    drop: 1.3,
    tx-radius: 0.3,
    tx-distance: 0.34,
    load-size: 0.34,
  )
})
