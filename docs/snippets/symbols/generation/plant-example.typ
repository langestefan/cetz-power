#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 2cm, {
  // A hybrid power plant and a PV park feeding the same MV bus.
  bus("mv", (0.2, 1.5), (5.2, 1.5))
  plant("hpp", (1.2, 0), kind: "wind-pv-bess", label: [HPP])
  plant("park", (4.2, 0), kind: "pv2", label: [PV park])
  wire("hpp.north", (1.2, 1.5))
  wire("park.north", (4.2, 1.5))
})
