#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Conductor direction via `angle:`; `count:` for other conductor
  // counts (2 = two-wire, 4 = three-phase + neutral).
  wire((0, 0.9), (0, -0.9))
  phase-ticks((0, 0.25), angle: -90deg)
  wire((1.4, 0.9), (1.4, -0.9))
  phase-ticks((1.4, 0.25), angle: -90deg, count: 2)
  wire((2.6, 0), (5.2, 0))
  phase-ticks((3.6, 0), count: 4)
})
