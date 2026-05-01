#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Simple substation: external grid → transformer → LV bus → three loads.
#test({

  external-grid("eg", (0, 0), label: [132 kV \ 500 MVA])
  wire("eg.in", (0, -1.5))
  transformer("t1", (0, -1.5), (0, -3), label: [132/11 kV \ 50 MVA])
  bus("lv", (-3, -3), (3, -3), taps: 5)
  for (i, tap) in ("tap1", "tap3", "tap5").enumerate() {
    let mw = 5 + i * 3
    load("l" + str(i), "lv." + tap, label: [#mw MW])
  }
})

// Radial feeder: three vertical buses bridged by a transformer + a wire,
// load tapped off bus 3 via an elbow.
#test({

  bus("b1", (1.7, 0), length: 1.4, angle: 90deg, label: [1])
  bus("b2", (4.6, 0), length: 1.4, angle: 90deg, label: [2])
  bus("b3", (7.0, 0), length: 1.4, angle: 90deg, label: [3])

  external-grid("g", (0.7, 0), angle: 90deg,
    label: (content: align(center)[50 MVA, \ 10 kV],
            anchor: "north", distance: 0.25))
  wire("g.in", "b1.mid")

  transformer("t", "b1.mid", "b2.mid", label: [10/0.4 kV])
  wire("b2.mid", "b3.mid")
  load("ld", bus-frac("b3", 1/6), elbow: 0.4)
})
