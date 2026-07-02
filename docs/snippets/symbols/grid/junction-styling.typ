#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  wire((0, 0), (3, 0))
  junction("j1", (0.6, 0), radius: 0.14)
  junction("j2", (1.5, 0), stroke: 0.8pt + red)         // fill follows the stroke
  junction("j3", (2.4, 0), open: true, fill: yellow)    // explicit body fill
})
