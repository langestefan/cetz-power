#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// The station count follows the data list — here five, built with `.map`.
#diagram(length: 0.9cm, {
  feeder("f", (0, 0),
    range(5).map(i => (label: [N#(i + 1)], load: [#(9 - i) A])),
    spacing: 1.8)
})
