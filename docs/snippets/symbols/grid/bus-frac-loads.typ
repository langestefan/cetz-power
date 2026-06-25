#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  bus("b1", (0, 0), length: 4)
  load("l1", bus-frac("b1", 0.25))
  load("l2", bus-frac("b1", 0.50))
  load("l3", bus-frac("b1", 0.75))
})
