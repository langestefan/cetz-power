#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default (car + pedestal + cable) on a bus
#test({
  bus("b", (0, 0), length: 4)
  ev-charger("evc", bus-frac("b", 0.5))
})

// The three kinds — interior taps, never the bus ends
#test({
  bus("b", (0, 0), length: 7)
  ev-charger("e1", bus-frac("b", 0.15), kind: "charger", label: [DC fast])
  ev-charger("e2", bus-frac("b", 0.5), kind: "ev")
  ev-charger("e3", bus-frac("b", 0.85), kind: "ev-charger")
})

// Bare, filled, and elbow-routed
#test({
  bus("b", (0, 0), length: 7)
  ev-charger("e1", bus-frac("b", 0.15), box: false)
  ev-charger(
    "e2",
    bus-frac("b", 0.5),
    fill: gray.lighten(70%),
    box-fill: yellow.lighten(88%),
  )
  ev-charger("e3", bus-frac("b", 0.85), kind: "charger", elbow: 0.5)
})

// Wiring via compass anchors (no lead — the box west wall is the terminal)
#test({
  bus("b", (0, 0), length: 2, angle: 90deg)
  ev-charger("evc", (1.4, 0.42), kind: "charger", lead: 0)
  wire("b.mid", "evc.west")
})
