#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `feeder` is reentrant — a drop can be another feeder, so taps branch into
// sub-feeders (a radial tree). The sub-feeder uses smaller drops to fit.
#diagram(length: 1cm, {
  feeder("main", (0, 0),
    (
      (label: [A], draw: info => {
        feeder(info.name, info.at,
          ((label: [], load: [2 A]), (label: [], load: [2 A])),
          angle: -90deg, lead: 0.9, spacing: 1.1, drop: 0.7,
          tx-radius: 0.13, tx-distance: 0.14, load-size: 0.18, load-lead: 0.08,
          extend: 0.4)
      }),
      (label: [B], load: [6 A]),
    ),
    spacing: 3.6, currents: ([12 A], [6 A], none))
})
