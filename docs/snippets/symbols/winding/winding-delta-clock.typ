#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Same shape, four IEC clock numbers. `angle: -clock * 30deg` is the
// rule of thumb: clock 0 leaves V at the top, clock 6 flips it to the
// bottom, and the odd clocks land between.
#diagram(length: 1.2cm, {
  delta("c0",  (0, 0), label: [clock 0])
  delta("c5",  (2, 0), label: [clock 5],  angle: -150deg)
  delta("c6",  (4, 0), label: [clock 6],  angle: -180deg)
  delta("c11", (6, 0), label: [clock 11], angle: -330deg)
})
