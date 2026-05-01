#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Tie cable between two substations on either side of a road.
  // The endpoints are anchored to each substation's busbar (so they
  // move with the buses), but the route is pinned to two specific
  // pole positions in between (absolute coordinates from the
  // geographic layout). A short relative stub on the way out of the
  // switchroom keeps the cable visually clear of the bus.
  bus("subA", (0, 0),    length: 1.0, angle: 90deg, label: [Sub A])
  bus("subB", (5, -1.5), length: 1.0, angle: 90deg, label: [Sub B])
  wire(
    "subA.mid",          // anchored start
    (rel: (0.4, 0)),     // brief stub out of the switchroom
    (2.5, 0),            // pole 1 (geographic coord)
    (3.5, -1.5),         // pole 2 (geographic coord)
    "subB.mid",          // anchored end
  )
})
