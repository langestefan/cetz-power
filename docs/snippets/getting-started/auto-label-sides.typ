#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Horizontal run: labels land north, beside the conductor.
  transformer("t1", (0, 0), (2, 0), label: [T₁])
  fuse("f1", (3, 0), (4.2, 0), label: [F₁])

  // Vertical run: the same plain calls put labels east.
  transformer("t2", (6, 0.8), (6, -0.8), label: [T₂])

  // `upright: true` turns an east/west label to read along the run.
  transformer("t3", (8.5, 0.8), (8.5, -0.8), label: (
    content: [110/10 kV],
    upright: true,
  ))

  // One-node symbols follow their free side: a load's label sits
  // beside the arrow tip, wherever `angle:` points it.
  bus("b", (0, -2), length: 2.5)
  load("l1", bus-frac("b", 0.25), label: [L₁])
  load("l2", bus-frac("b", 0.75), label: [L₂])
})
