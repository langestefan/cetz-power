#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // The arrow always points from `in` to `out`. To reverse the
  // reference direction, swap the two endpoint coordinates:
  currentsource("forward",  (0, 0),    (2, 0))    // arrow → right
  currentsource("backward", (5, 0),    (3, 0))    // arrow → left

  // AC variant: same arrow, plus a sine squiggle above it.
  currentsource("ac",       (6, 0),    (8, 0), kind: "ac")
})
