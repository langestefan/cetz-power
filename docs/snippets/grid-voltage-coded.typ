#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Voltage-level colour coding — the same red / orange / blue
// convention used for buses and feeders. Pair with `line-count`
// to hint at network strength: a denser grid reads as a stiffer
// upstream system.
#diagram(length: 1.2cm, {
  external-grid("hv", (0, 0),
    stroke: 1.2pt + rgb("#cc1122"),
    line-count: 4,
    label: align(center)[HV \ 150 kV],
  )
  external-grid("mv", (1.8, 0),
    stroke: 1pt + rgb("#e8772e"),
    line-count: 2,
    label: align(center)[MV \ 10 kV],
  )
  external-grid("lv", (3.6, 0),
    stroke: 0.8pt + rgb("#1f7ad9"),
    line-count: 1,
    label: align(center)[LV \ 0.4 kV],
  )
})
