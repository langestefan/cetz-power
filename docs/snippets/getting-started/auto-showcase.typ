#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.1cm, {
  // The only placement decisions left are coordinates: labels pick
  // their free side, loads orient off their bus, and the reserve tie
  // routes its own interior-tapped perpendicular bends.
  external-grid("net", (0, 3.4))
  bus("hv", (-1.3, 2.2), (1.3, 2.2), label: (
    content: [150 kV],
    anchor: "west",
  ))
  wire("net.in", "hv.mid")
  transformer(
    "t1",
    "hv.mid",
    (0, 0.4),
    vector: ("delta", "wye"),
    label: [150/21 kV],
  )
  bus("mv", (-2.4, 0.4), (2.4, 0.4), label: (
    content: [21 kV],
    anchor: "west",
  ))
  load("l1", bus-frac("mv", 0.14), on: "mv", label: [4 MW])
  load("l2", bus-frac("mv", 0.32), on: "mv", label: [6 MW])
  bus("aux", (3.6, 0.4), (5.6, 0.4), label: (content: [aux], anchor: "east"))
  pv-panel("pv", bus-frac("aux", 0.5), on: "aux", side: "north")
  link("mv", "aux", from: 0.9, kind: "cable", label: [reserve])
})
