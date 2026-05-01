#import "/src/lib.typ" as pg
#set page(margin: 4pt, width: auto, height: auto)

#pg.diagram(length: 1.2cm, {
  import pg: *
  // Per-call wins over both family and global defaults.
  transformer("t1", (0, 0), (2.5, 0))
  transformer("t2", (0, -1.4), (2.5, -1.4),
    radius: 0.5,
    stroke: 1.2pt + red,
  )
})
