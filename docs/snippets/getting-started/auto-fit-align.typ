#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // over: (ref:, gap:) computes the overshoot that lines the tall
  // bar's ends up with the short reference bar across the cables.
  bus("ts", (0, 0), length: 1.4, angle: 90deg, label: [TS])
  wire((0, 0.3), (2.2, 0.3))
  wire((0, -0.3), (2.2, -0.3))
  bus(
    "ms",
    fit: ((2.2, 0.3), (2.2, -0.3)),
    over: (ref: 1.4, gap: 0.6),
    label: [MS],
  )
})
