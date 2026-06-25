#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  cetz.draw.set-style(cetz-power: (transformer: (fill: yellow.lighten(80%))))
  transformer("t1", (0, 0), (2, 0))
})
