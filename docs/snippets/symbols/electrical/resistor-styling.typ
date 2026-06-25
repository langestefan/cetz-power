#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Per-call overrides on width, length, and fill.
  resistor("r1", (0, 0))                         // defaults
  resistor("r2", (1, 0), width: 0.5)             // wider body
  resistor("r3", (2.2, 0), length: 1.1)          // longer body
  resistor("r4", (3.4, 0), fill: yellow.lighten(60%))

  // Family-level override applies to every resistor drawn after.
  cetz.draw.set-style(cetz-power: (resistor: (
    width: 0.45,
    stroke: 1.4pt + blue,
  )))
  resistor("r5", (4.6, 0))
})
