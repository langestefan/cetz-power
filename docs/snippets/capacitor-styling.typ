#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Per-call overrides for plate width and gap.
  capacitor("c1", (0, 0))                     // defaults
  capacitor("c2", (1.2, 0), plate-width: 0.8) // wider plates
  capacitor("c3", (2.4, 0), plate-gap: 0.3)   // bigger gap

  // Family-level override applies to every capacitor drawn after.
  cetz.draw.set-style(cetz-power: (capacitor: (
    "plate-width": 0.7,
    stroke: 1.4pt + blue,
  )))
  capacitor("c4", (3.8, 0))
  capacitor("c5", (5.0, 0))
})
