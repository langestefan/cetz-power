#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `line-stroke` styles the run itself — here a heavier, colour-coded
// busbar — and `extend-stroke` matches the dashed continuation to it.
#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    ((label: [N1], load: [10 A]), (label: [N2], load: [10 A]), (label: [N3], load: [10 A])),
    currents: ([30 A], [20 A], [10 A], none),
    line-stroke: 1.6pt + blue,
    extend-stroke: (paint: blue, thickness: 1.6pt, dash: "dashed"))
})
