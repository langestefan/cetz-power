// Exercises one variant of every symbol family. If anything's syntactically
// broken this will catch it — used during development to sanity-check.

#import "/src/lib.typ": *

#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

= Grid

#diagram({
  external-grid("grid", (0, 0.9))
  wire("grid.in", (0, 0))
  bus("b1", (-0.6, 0), (0.6, 0))
  wire("b1.mid", (0, -0.3))
  transformer("t1", (0, -0.3), (0, -1.3), vector: ("delta", "wye"))
  transformer3("t2", (2, -0.6))
  autotransformer("t3", (3.5, 0), (3.5, -1.3), oltc: true)
  wire((4.8, 0), (6.8, 0))
  ct("ct1", (5.3, 0))
  vt("vt1", (6.0, 0))
  junction("j1", (6.8, 0))
  junction("j2", (4.8, 0), open: true)
})

= Generation

#diagram({
  machine("m1", (0, 0), "G")
  block("blk", (1.5, 0), body: [BESS])
  plant("p1", (3.6, 0), kind: "wind-pv-bess")
  plant("p2", (5.6, 0), kind: "wind2", variant: 3)
  pv-panel("pv", (6.8, 0.4))
})

= Loads

#diagram({
  load("l1", (0.3, 0))
  factory("f1", (1.3, 0), smoke: true)
  ev-charger("e1", (3.3, 0))
  ev-charger("e2", (5.5, 0), kind: "charger")
  bus("b", (0, 0), (6.2, 0))
})

= Electrical

#diagram({
  capacitor("c", (0, 0))
  resistor("r", (1.2, 0))
  inductor("l", (2.4, 0))
  diode("d", (3.6, 0))
  voltagesource("v", (5, 0))
  currentsource("i", (6.2, 0))
  battery("bat", (7.4, 0), cells: 2)
  converter("cv", (8.8, 0), kind: "ac-dc")
  ground("g", (10, 0))
  bolt("bo", (11, 0.5), (11, -0.5))
})

= Protection

#diagram({
  switch("s1", (0, 0), (1.5, 0))
  switch("s2", (2, 0), (3.5, 0), closed: true)
  switch("s3", (4, 0), (5.5, 0), earthing: true)
  breaker("cb1", (6, 0), (7.5, 0))
  breaker("cb2", (8, 0), (9.5, 0), kind: "cross")
  fuse("f1", (10, 0), (11.5, 0))
  arrester("a1", (12.5, 0), (12.5, -1.2))
  ground("ag", "a1.out")
  relay("r1", (14, 0), "50/51")
})

= Control and windings

#diagram({
  adder("sum", (0, 0))
  mixer("mul", (1.2, 0))
  delta("d0", (2.8, 0), terminals: ("u", "v", "w"))
  wye("y0", (4.6, 0), terminals: ("u", "v", "w"))
  zigzag("z0", (6.4, 0), terminals: ("u", "v", "w"))
})

= Helpers

#diagram({
  bus("b1", (0, 0), (2, 0), label: [B1])
  bus("b2", (4, -1.5), (6, -1.5), label: (content: [B2], anchor: "south"))
  link("b1", "b2", label: [10 km])
  phase-ticks((1, -0.5), angle: -90deg)
  flow-arrow((4.4, -0.5), (5.6, -0.5), label: [P])
  note((6.5, -1.5), [end], side: "east")
})
