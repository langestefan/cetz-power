#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A dashed station envelope around part of the network. Areas are
  // backdrops: draw them first, then the symbols on top. The feed
  // crosses the border as a lead; the symbols stay clear of it.
  area("st", (-0.9, -1.15), (3.4, 1.35), title: [Onderstation], side: "north")
  bus("hv", (0, -0.7), (0, 0.7), label: [HV])
  transformer("t", "hv.mid", (2.4, 0), radius: 0.25, distance: 0.2)
  bus("mv", (2.4, -0.6), (2.4, 0.6), label: [MV])
  external-grid("g", (-2.2, 0), angle: 90deg, size: 0.6)
  wire("g.in", "hv.mid")
})
