#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// `zigzag-kink` is the fraction along the arm where the kink sits;
// `zigzag-offset` is the lateral jog (both as a fraction of `size`).
// Both are passed via the family dict because Typst named arguments
// don't accept hyphenated identifiers.
#diagram(length: 1.2cm, {
  zigzag("a", (0, 0), label: [defaults])

  cetz.draw.set-style(cetz-power: (winding: ("zigzag-offset": 0.30)))
  zigzag("b", (2, 0), label: [wide])

  cetz.draw.set-style(cetz-power: (winding: ("zigzag-kink": 0.3, "zigzag-offset": 0.18)))
  zigzag("c", (4, 0), label: [kink near centre])
})
