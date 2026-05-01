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
