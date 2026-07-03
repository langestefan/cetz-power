#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // CT on a conductor: the primary runs straight through the circle;
  // the secondary taps a compass anchor down to the ammeter.
  wire((0, 0), (3, 0))
  ct("c1", (1.5, 0))
  machine("m", (1.5, -1.2), "A")
  wire("c1.south", "m.north")
})
