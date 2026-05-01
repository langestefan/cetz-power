#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Rotate to set the conduction direction. The triangle always
  // points from `in` toward `out` — `angle:` decides which world
  // direction that is.
  diode("d-up",    (0, 0))                  // current upward (default)
  diode("d-right", (1.4, 0), angle: -90deg) // current rightward
  diode("d-down",  (2.8, 0), angle: 180deg) // current downward
  diode("d-left",  (4.2, 0), angle: 90deg)  // current leftward
})
