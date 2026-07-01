#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// `width` / `height` override the square `size` per axis, drawing a
// rectangular external grid. The ±45° hatching is clipped to the box, so
// it stays at a true 45° whatever the aspect ratio — a wide or tall box
// is a straight-line cross-hatch, not a stretched X. Either dimension
// defaults to `size` when omitted.
#diagram(length: 1cm, {
  // wide source feeding a bus from its east edge (no lead stub)
  external-grid("g", (0, 0), width: 2.2, height: 1.1, distance: 0)
  bus("b", (3.2, 0.2), (3.2, 0.9))
  wire("g.east", "b.mid")

  // tall variant
  external-grid("t", (5, -0.2), width: 0.9, height: 1.6)
})
