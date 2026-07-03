#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Backdrop styles: filled + rounded (plant area, title in a corner),
  // borderless fill, and a title outside the border.
  area(
    "dvpp",
    (0, 0),
    (2.8, 1.8),
    title: text(fill: orange.darken(20%))[DVPP\ area],
    side: "south-west",
    fill: luma(245),
    stroke: (dash: "dashed", paint: luma(120), thickness: 0.6pt),
    radius: 0.12,
  )
  area(
    "tso",
    (3.2, 0),
    (6.0, 1.8),
    title: [TSO area],
    stroke: none,
    fill: rgb(
      "#dce9f2",
    ),
  )
  area(
    "ext",
    (6.4, 0),
    (9.2, 1.8),
    title: [outside title],
    side: "north",
    inside: false,
  )
})
