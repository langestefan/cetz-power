#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The three `kind:` values give the three standard ground notations.
  ground("g1", (0,   0))                     // earth (default)
  ground("g2", (1.2, 0), kind: "chassis")    // chassis ground
  ground("g3", (2.4, 0), kind: "signal")     // signal / common ground
})
