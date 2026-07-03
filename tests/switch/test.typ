#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default open switch / disconnector.
#test({
  switch("s", (0, 0), (2, 0))
})

// Closed switch.
#test({
  switch("s", (0, 0), (2, 0), closed: true)
})

// Different open angle.
#test({
  switch("s", (0, 0), (2, 0), open-angle: 45deg)
})

// Connected between two buses.
#test({
  bus("b1", (0, 0), length: 1.0, angle: 90deg)
  bus("b2", (3, 0), length: 1.0, angle: 90deg)
  switch("s", "b1.mid", "b2.mid")
})

// Diagonal placement.
#test({
  switch("s", (0, 0), (2, 1))
})

// With a label.
#test({
  switch("s", (0, 0), (2, 0), label: [Q₁])
})

// Bare blade: pivot-radius 0 omits the pin dots (netopening style).
#test({
  wire((-0.5, 0), (0, 0))
  switch("s", (0, 0), (0.6, 0), switch-length: 0.3, pivot-radius: 0)
  wire((0.6, 0), (1.1, 0))
})

// Earthing switch: earth mark at the out end, hanging off a bus.
#test({
  bus("b", (0, 0), length: 1.5)
  switch("es", "b.mid", (0, -1.2), earthing: true)
})

// Earthing switch, closed (earthed) pose.
#test({
  switch("es", (0, 0), (1.4, 0), earthing: true, closed: true)
})
