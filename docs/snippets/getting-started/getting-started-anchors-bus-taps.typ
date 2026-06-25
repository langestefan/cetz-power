#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // `taps: 4` declares four evenly-spaced anchors named tap1..tap4.
  bus("b1", (0, 0), length: 4, taps: 4, label: [HV])
  load("l1", "b1.tap1")
  load("l2", "b1.tap2")
  load("l3", "b1.tap3")
  load("l4", "b1.tap4")
})
