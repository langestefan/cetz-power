#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default factory on a bus
#test({
  bus("b", (0, 0), length: 3, taps: 3)
  factory("f", "b.tap2")
})

// Label, smoke (stays inside the box), and window count
#test({
  bus("b", (0, 0), length: 4, taps: 3)
  factory("f1", "b.tap1", label: [Plant A])
  factory("f2", "b.tap2", smoke: true)
  factory("f3", "b.tap3", windows: 4)
})

// Elbow routing, bare building, fills, and sizing
#test({
  bus("b", (0, 0), length: 5, taps: 4)
  factory("f1", "b.tap1", elbow: 0.5)
  factory("f2", "b.tap2", box: false)
  factory(
    "f3",
    "b.tap3",
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(85%),
  )
  factory("f4", "b.tap4", width: 1.1, height: 0.9)
})

// Wiring via compass anchors (no lead — the box west wall is the terminal)
#test({
  bus("b", (0, 0), length: 2, angle: 90deg)
  factory("f", (1.4, 0.42), lead: 0)
  wire("b.mid", "f.west")
})
