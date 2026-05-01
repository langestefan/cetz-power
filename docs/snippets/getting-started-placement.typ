#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Two-node: spans from (0, 0) to (2, 0), oriented horizontally.
  transformer("t1", (0, 0), (2, 0))
  // One-node with angle: 90deg makes it vertical.
  transformer("t2", (4, 0), angle: 90deg)
})
