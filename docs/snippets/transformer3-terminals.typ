#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

#diagram(length: 1.2cm, {
  // Default: each terminal exits its circle radially (HV 180°, LV 60°,
  // TV −60°), flush on the edge (lead: 0).
  transformer3("a", (0, 0))
  note((0, -1.2), [default], side: "south", text-align: center)

  // `lead` draws a stub from each circle edge out to the anchor.
  transformer3("b", (2.6, 0), lead: 0.35)
  note((2.6, -1.2), [lead: 0.35], side: "south", text-align: center)

  // Per-terminal angles re-aim the secondaries straight up / down.
  transformer3("c", (5.2, 0), lead: 0.35, lv-angle: 90deg, tv-angle: -90deg)
  note((5.2, -1.2), [lv-angle: 90°\ tv-angle: -90°], side: "south", text-align: center)
})
