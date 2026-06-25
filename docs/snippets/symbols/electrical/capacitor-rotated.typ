#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // -90deg lays the cap flat: lead extends horizontally, plates run
  // vertical. Useful for in-line wiring along a horizontal feeder.
  capacitor("c1", (0, 0))            // default vertical orientation
  capacitor("c2", (1.5, 0), angle: -90deg)
  capacitor("c3", (3.4, 0), angle: 180deg)
})
