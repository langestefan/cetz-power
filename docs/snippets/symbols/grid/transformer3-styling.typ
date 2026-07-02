#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Each winding can be coloured independently. Here HV stays black,
  // the LV (upper) winding is blue and the TV (lower) winding orange.
  transformer3(
    "t",
    (0, 0),
    primary-stroke: 1pt + black,
    secondary-stroke: blue,
    tertiary-stroke: orange,
  )
})
