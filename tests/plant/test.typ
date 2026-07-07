#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// The three single technologies in each variant (rows: variant 1..3).
#test({
  for (i, k) in ("wind", "pv", "bess").enumerate() {
    plant("p" + str(i), (i * 1.2, 0), kind: k)
    plant("q" + str(i), (i * 1.2, -1.2), kind: k, variant: 2)
    plant("r" + str(i), (i * 1.2, -2.4), kind: k, variant: 3)
  }
})

// Pairs and the full triple; concatenated kind spelling also parses.
#test({
  plant("wp", (0, 0), kind: "wind-pv")
  plant("wb", (0, -1.2), kind: "wind-bess")
  plant("pb", (0, -2.4), kind: "pv-bess")
  plant("wpb", (0, -3.8), kind: "wind-pv-bess")
  plant("wpb2", (2.6, -3.8), kind: "windpvbess", variant: 2)
})

// Numbered icon styles: wind park, filled PV, PV park, charged battery.
#test({
  plant("w2", (0, 0), kind: "wind2")
  plant("w3", (1.2, 0), kind: "wind3")
  plant("p2", (2.4, 0), kind: "pv2")
  plant("p3", (3.6, 0), kind: "pv3")
  plant("b2", (4.8, 0), kind: "bess2")
  plant("mix", (0.7, -1.3), kind: "wind2-pv2-bess2")
  plant("mix2", (3.1, -1.3), kind: "wind2pv3", variant: 3)
})

// Single-square composites (variants 4 and 5), pairs and singles.
#test({
  plant("c1", (0, 0), kind: "wind-pv-bess", variant: 4)
  plant("c2", (1.3, 0), kind: "wind-pv-bess", variant: 5)
  plant("c3", (2.6, 0), kind: "wind-pv", variant: 4)
  plant("c4", (3.9, 0), kind: "wind-bess", variant: 5)
  plant("c5", (5.2, 0), kind: "pv-bess", variant: 4)
  plant("c6", (6.5, 0), kind: "bess", variant: 4)
})

// Wired via compass anchors, with an outside label.
#test({
  bus("b1", (2.2, 0), length: 1.0, angle: 90deg)
  plant("hpp", (0, 0), kind: "wind-bess", label: [HPP 1])
  wire("hpp.east", "b1.mid")
})

// Two-node placement: body at the midpoint, leads to the endpoints.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (4.2, 0), length: 1.0, angle: 90deg)
  plant("link", "b1.mid", "b2.mid", kind: "wind-pv-bess")
})

// Per-technology south anchors take notes / extra leads.
#test({
  plant("hpp", (0, 0), kind: "wind-pv-bess")
  note("hpp.pv", [PV], side: "south")
})

// Geometry + style overrides.
#test({
  plant("big", (0, 0), kind: "wind-pv", cell: 1.0, height: 0.9, icon-scale: 0.7)
  plant("thin", (0, -1.6), kind: "bess", stroke: 0.5pt + gray, icon-stroke: 0.8pt + black)
})
