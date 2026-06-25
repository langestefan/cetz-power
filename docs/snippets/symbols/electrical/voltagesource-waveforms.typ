#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The full set of waveform variants the `kind:` parameter accepts.
  voltagesource("dc",   (0,  0), (2,  0))                 // default
  voltagesource("ac",   (3,  0), (5,  0), kind: "ac")     // sine wave
  voltagesource("tri",  (6,  0), (8,  0), kind: "tri")    // triangle
  voltagesource("saw",  (9,  0), (11, 0), kind: "saw")    // sawtooth
  voltagesource("rect", (12, 0), (14, 0), kind: "rect")   // square
})
