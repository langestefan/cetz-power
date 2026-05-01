#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  transformer("t1", (0, 0), (2, 0), radius: 0.3, distance: 0.35)
  transformer("t2", (0, -1.2), (2, -1.2))
  transformer("t3", (0, -2.4), (2, -2.4), radius: 0.6, distance: 0.85)
})
