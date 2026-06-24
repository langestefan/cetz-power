#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// A station with no `load` is a bare labelled tap; `none` currents skip
// a segment's label. `lead` / `spacing` size the run.
#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    (
      (label: [tap 1], load: [3 A]),
      (label: [tap 2],),
      (label: [tap 3], load: [3 A]),
    ),
    lead: 1, spacing: 1.6,
    currents: ([9 A], none, [6 A], [3 A]))
})
