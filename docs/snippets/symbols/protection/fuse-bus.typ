#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Fuse protecting a feeder off a busbar.
  bus("b", (0, 0), length: 1.0, angle: 90deg)
  fuse("f", "b.mid", (2.5, 0))
  load("ld", (2.5, 0))
})
