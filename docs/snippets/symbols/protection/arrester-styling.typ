#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Geometry and colour overrides; `head-fill` defaults to the
  // stroke paint.
  arrester(
    "a",
    (0, 0),
    (2.4, 0),
    length: 0.9,
    width: 0.4,
    head-length: 0.3,
    head-width: 0.22,
    stroke: 1pt + blue,
    label: [MOV],
  )
})
