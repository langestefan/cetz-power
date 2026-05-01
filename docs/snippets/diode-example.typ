#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Default: hollow triangle, both leads. Current flows from `in` (bottom)
  // to `out` (top).
  diode("d", (0, 0))
})
