#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // VT hanging below a tap on the measured conductor, with the
  // measurement drop wired from its `out` anchor to the voltmeter.
  wire((0, 0), (2.5, 0))
  vt("v1", (1.25, 0))
  machine("m", (1.25, -1.8), "V")
  wire("v1.out", "m.north")
})
