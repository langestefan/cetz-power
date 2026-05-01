#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  transformer("t1", (0, 0), (2, 0))
  transformer("t2", (4, 0), angle: 90deg)
})
