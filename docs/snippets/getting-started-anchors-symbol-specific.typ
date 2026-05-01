#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Two-winding transformer exposes `primary` and `secondary`
  // (aliases for `in` and `out`).
  transformer("t1", (0, 0), (2.5, 0))
  bus("hv",  "t1.primary",   length: 1.2, angle: 90deg, label: [HV])
  bus("lv",  "t1.secondary", length: 1.2, angle: 90deg, label: [LV])

  // Machine exposes the eight compass anchors on its circle.
  machine("m1", (5, 0), "M")
  wire("m1.west",  (rel: (-0.6, 0), to: "m1.west"))
  wire("m1.north", (rel: (0,  0.6), to: "m1.north"))
  wire("m1.east",  (rel: ( 0.6, 0), to: "m1.east"))
})
