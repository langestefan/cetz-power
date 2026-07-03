#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The four conversion modes `kind:` accepts. The first token names
  // the `in`-side glyph (upper-left), the second the `out` side.
  converter("r", (0, 0), kind: "ac-dc", label: [rectifier])
  converter("i", (1.6, 0), kind: "dc-ac", label: [inverter])
  converter("f", (3.2, 0), kind: "ac-ac", label: [AC/AC])
  converter("d", (4.8, 0), kind: "dc-dc", label: [DC/DC])
})
