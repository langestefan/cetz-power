#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The arrow points from `in` toward `out` — always aim `out` at
  // the earthed side, whatever the orientation.
  arrester("h", (0, 0), (2, 0))
  note((1, 0.25), [in → out], side: "north", distance: 0.05)
  arrester("v", (3.2, 0.9), (3.2, -0.9))
})
