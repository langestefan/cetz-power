#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Horizontal two-node placement (arrow points in → out).
#test({
  arrester("a", (0, 0), (2, 0))
})

// The canonical shunt form: phase conductor → arrester → earth.
#test({
  bus("b", (0, 0), length: 1.5)
  arrester("a", "b.mid", (0, -1.4))
  ground("g", "a.out")
})

// Exact span (no leads: body fills the whole in→out gap).
#test({
  arrester("a", (0, 0), (0, -0.6))
})

// Geometry / styling overrides + label.
#test({
  arrester(
    "a",
    (0, 0),
    (2.4, 0),
    length: 0.9,
    width: 0.4,
    head-length: 0.3,
    head-width: 0.22,
    stroke: 1pt + blue,
    head-fill: red,
    label: [MOV],
  )
})
