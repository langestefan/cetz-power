#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// `drop-draw` replaces the whole drop for the feeder. Here every tap is a
// motor instead of a transformer + load.
#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    ((label: [M1],), (label: [M2],), (label: [M3],)),
    currents: ([30 A], [20 A], [10 A], none),
    drop-draw: info => {
      machine(info.name, info.foot, "M")
      wire(info.at, info.name + ".north")
    })
})
