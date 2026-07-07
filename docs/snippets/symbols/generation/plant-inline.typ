#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 2cm, {
  // Two-node placement: body at the midpoint, leads to the endpoints.
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (4.4, 0), length: 1.0, angle: 90deg)
  plant("hpp", "b1.mid", "b2.mid", kind: "wind2-pv-bess")
  // Per-technology south anchors take notes or extra leads.
  note("hpp.pv", [PV], side: "south")
})
