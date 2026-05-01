#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // One global stroke applied to every symbol drawn after this call.
  cetz.draw.set-style(cetz-power: (stroke: 1.2pt + blue))

  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  transformer("t1", "b1.mid", (2.5, 0))
  bus("b2", (2.5, 0), length: 1.4, angle: 90deg)
  load("l1", "b2.mid")
})
