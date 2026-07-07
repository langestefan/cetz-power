#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // IEC function boxes and the ANSI device circle.
  relay("r1", (0, 0), "50/51")
  relay("r2", (1.2, 0), [87T])
  relay("r3", (2.4, 0), [$U <$])
  relay("r4", (3.6, 0), "21", kind: "circle")
})
