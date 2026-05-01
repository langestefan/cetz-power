#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  diode("d1", (0, 0))                                  // hollow
  diode("d2", (1.0, 0), fill: black)                   // filled
  diode("d3", (2.0, 0), width: 0.6, height: 0.6)       // bigger
  diode("d4", (3.4, 0), bar-width: 0.6)                // wider cathode bar
})
