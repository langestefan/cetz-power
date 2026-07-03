#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A metered feeder bay: breaker, CT (current) and VT (voltage) on
  // the same run.
  bus("b", (0, 0), length: 1.2, angle: 90deg, label: [MV])
  wire("b.mid", (0.6, 0))
  breaker("q", (0.6, 0), (1.5, 0))
  wire((1.5, 0), (3.8, 0))
  ct("i", (2.2, 0), label: (content: [I], anchor: "north", distance: 0.25))
  vt("u", (3.1, 0), label: [U])
})
