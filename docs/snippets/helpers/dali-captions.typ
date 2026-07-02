#import "/src/lib.typ": *
#set page(margin: 8pt, width: auto, height: auto)
#set text(size: 7pt)

#diagram(length: 1cm, {
  wire((-1, 0), (4, 0))
  dali("m", (1.5, 0), label: [Meter])
  note("m-ct.west", [I], side: "west") // left of the clamp
  note("m-vt.east", [U], side: "east") // right of the transformer
})
