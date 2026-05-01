#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Outgoing 11 kV feeder dropping out of the switchgear and
  // routing across to a load that's offset to the right (the load
  // isn't directly under its bus tap because the cable trench runs
  // sideways before turning down). Each `(rel: <vec>)` is "step
  // from where I am now" — the corner positions are easier to
  // think of as offsets than as absolute (x, y) coordinates.
  bus("mv", (0, 0), length: 4, taps: 5, label: [11 kV bus])
  wire(
    "mv.tap2",            // start at tap 2
    (rel: (0, -0.6)),     // drop out of the switchroom
    (rel: (1.5, 0)),      // run horizontal along the cable trench
    (rel: (0, -0.5)),     // turn down into the load
  )
  load("bldg",
    (rel: (1.5, -1.1), to: "mv.tap2"),
    label: [Building load],
  )
})
