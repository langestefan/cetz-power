#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // body: marks an automatic device — R = recloser, S = sectionalizer.
  // The letter stays upright however the breaker is oriented.
  wire((0, 0), (0.8, 0))
  breaker("r", (0.8, 0), (2.0, 0), size: 0.36, body: [R], label: [recloser])
  wire((2.0, 0), (2.8, 0))
  breaker(
    "s",
    (3.8, -0.6),
    (3.8, 0.6),
    size: 0.36,
    body: [S],
    label: (content: [sectionalizer], anchor: "east", distance: 0.15),
  )
})
