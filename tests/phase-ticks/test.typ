#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default three-phase mark on a horizontal conductor.
#test({
  wire((0, 0), (2.5, 0))
  phase-ticks((0.8, 0))
})

// On a vertical run, and with other counts.
#test({
  wire((0, 1), (0, -1))
  phase-ticks((0, 0.3), angle: -90deg)
  wire((1.5, 1), (1.5, -1))
  phase-ticks((1.5, 0.3), angle: -90deg, count: 2)
  wire((3, 0), (5.5, 0))
  phase-ticks((4, 0), count: 4)
})

// Lerp coordinates between bus anchors; styling overrides.
#test({
  bus("a", (0, 0), length: 1.0, angle: 90deg)
  bus("b", (3, 0), length: 1.0, angle: 90deg)
  wire("a.mid", "b.mid")
  phase-ticks(("a.mid", 35%, "b.mid"))
  phase-ticks(
    ("a.mid", 75%, "b.mid"),
    length: 0.3,
    spacing: 0.1,
    stroke: 1pt + blue,
  )
})
