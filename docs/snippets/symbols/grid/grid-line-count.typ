#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// `line-count` controls the hatching density. The two main diagonals
// (corner-to-corner) are added as soon as n >= 1; further chord pairs
// at evenly-spaced offsets are added on top for higher n. n=0 is a
// bare square with no hatching.
#diagram(length: 1.2cm, {
  for (i, n) in (0, 1, 2, 3, 4, 5, 6).enumerate() {
    external-grid("g" + str(n), (i * 1.4, 0),
      line-count: n,
      label: [n = #n],
    )
  }
})
