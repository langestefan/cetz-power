#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  wire((0, 0), (3, 0))
  junction("j1", (0.75, 0))
  junction("j2", (1.5, 0))
  junction("j3", (2.25, 0), open: true)
})
