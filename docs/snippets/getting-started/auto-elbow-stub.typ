#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A plain elbow turns one square corner — fine towards a device …
  bus("a1", (0, 0), length: 1.6)
  machine("m", (2.6, -1.8), "G")
  elbow("a1.mid", "m.west", corner: "v")

  // … but a run that must move sideways between bars takes `stub:`,
  // the design-rule join: perpendicular stub, diagonal, equal stub —
  // both ends meet their bars at 90°, on the interior.
  bus("a2", (5.4, 0), length: 1.6)
  bus("b2", (7.8, -1.8), length: 1.6)
  elbow("a2.mid", "b2.mid", corner: "v", stub: 0.4)
})
