#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `extend: 0` ends the run cleanly (no dashed continuation); `tail` sets
// how far it runs past the last station, and `dot: 0` drops the tap dots.
#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    ((label: [A], load: [4 A]), (label: [B], load: [4 A])),
    currents: ([8 A], [4 A], none),
    extend: 0, tail: 0.4, dot: 0)
})
