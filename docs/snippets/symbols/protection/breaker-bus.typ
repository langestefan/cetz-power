#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Circuit breaker between two buses — the canonical SLD pattern.
  // Pass `fill:` to colour-code by voltage level.
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  breaker("cb", "b1.mid", "b2.mid", fill: red.lighten(70%))
})
