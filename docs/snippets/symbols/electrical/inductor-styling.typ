#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Bump count and radius let you trade body length for granularity.
  inductor("l1", (0, 0))                           // defaults (4 bumps)
  inductor("l2", (1, 0), bumps: 3)                 // chunkier
  inductor("l3", (2, 0), bumps: 6, bump-radius: 0.08) // long & fine
  inductor("l4", (3.2, 0), stroke: 1.4pt + blue)
})
