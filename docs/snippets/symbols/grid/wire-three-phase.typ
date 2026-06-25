#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Three-phase feeder colour-coded by phase (IEC: red / yellow /
  // blue). Three parallel wires, each tapping a different point on
  // the source busbar and landing at the matching tap on the load
  // bus. A standard pattern in distribution single-lines where the
  // three phases are visually distinguished.
  let r = rgb("#cc1122")
  let y = rgb("#ddaa00")
  let b = rgb("#2244aa")

  bus("src", (0, 0), length: 2, angle: 90deg, taps: 3, label: [Source])
  bus("ld",  (4, 0), length: 2, angle: 90deg, taps: 3, label: [Load])

  wire("src.tap1", "ld.tap1", stroke: 1.4pt + r)
  wire("src.tap2", "ld.tap2", stroke: 1.4pt + y)
  wire("src.tap3", "ld.tap3", stroke: 1.4pt + b)
})
