#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Family default — colours every winding in this canvas.
  cetz.draw.set-style(cetz-power: (winding: (
    stroke: 1.0pt + blue.darken(20%),
    fill: blue.lighten(85%),
  )))
  delta("a", (0, 0))
  // Per-call overrides win over both global and family defaults.
  delta("b", (2, 0), stroke: 1.4pt + red, fill: red.lighten(85%))
})
