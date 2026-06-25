#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `drop-angle` aims every drop independently of the run. Here the run is
// tilted but the drops are forced straight down.
#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    ((label: [N1], load: [10 A]), (label: [N2], load: [10 A]), (label: [N3], load: [10 A])),
    angle: 20deg, drop-angle: -90deg, currents: ([30 A], [20 A], [10 A], none))
})
