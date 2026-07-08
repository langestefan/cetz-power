#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default (car + pedestal + cable) on a bus
#test({
  bus("b", (0, 0), length: 4, taps: 1)
  ev-charger("evc", "b.tap1")
})

// The three kinds
#test({
  bus("b", (0, 0), length: 6, taps: 3)
  ev-charger("e1", "b.tap1", kind: "charger", label: [DC fast])
  ev-charger("e2", "b.tap2", kind: "ev")
  ev-charger("e3", "b.tap3", kind: "ev-charger")
})

// Bare, filled, and elbow-routed
#test({
  bus("b", (0, 0), length: 6, taps: 3)
  ev-charger("e1", "b.tap1", box: false)
  ev-charger(
    "e2",
    "b.tap2",
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  ev-charger("e3", "b.tap3", kind: "charger", elbow: 0.5)
})

// Wiring via compass anchors (no lead — the box west wall is the terminal)
#test({
  bus("b", (0, 0), length: 2, angle: 90deg)
  ev-charger("evc", (1.4, 0.42), kind: "charger", lead: 0)
  wire("b.mid", "evc.west")
})
