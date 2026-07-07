#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 2cm, {
  // In-circle vector-group marks: Dy, Yz, and a vertical Dy with OLTC —
  // the marks stay upright however the transformer is oriented.
  transformer("t1", (0, 0), (1.7, 0), vector: ("delta", "wye"), label: [Dyn11])
  transformer(
    "t2",
    (3.0, 0),
    (4.7, 0),
    vector: ("wye", "zigzag"),
    label: [YNzn5],
  )
  transformer(
    "t3",
    (5.9, -0.85),
    (5.9, 0.85),
    vector: ("delta", "wye"),
    oltc: true,
  )
})
