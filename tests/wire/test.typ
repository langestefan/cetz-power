#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Plain wire
#test({
  wire((0, 0), (2, 1))
})

// Elbow wire, horizontal-first
#test({
  wire((0, 0), (2, 0))
  elbow((2, 0), (3, -1.5))
})

// Elbow wire, vertical-first
#test({
  elbow((0, 0), (2, -1.5), corner: "v")
})

// Wire between anchors of two buses
#test({
  bus("b1", (0, 0), length: 2, taps: 1)
  bus("b2", (4, -1), length: 2, taps: 1)
  wire("b1.tap1", "b2.tap1")
  elbow("b1.end", "b2.start")
})

// Custom stroke
#test({
  wire((0, 0), (2, 0), stroke: 2pt + blue)
})

// Multi-point polyline — three or more positional args make a chain
// of straight segments.
#test({
  wire((0, 0), (1, 1), (2, 0), (3, 1))
})

// Polyline with relative coordinates — `(rel: <vec>)` (no `to:`)
// means "offset from the previous point in the list", so this is
// turtle-style routing.
#test({
  wire(
    (0, 0),
    (rel: (1, 0)),
    (rel: (0, -1)),
    (rel: (1, 0)),
  )
})

// Polyline mixing anchor names and relative offsets.
#test({
  bus("b", (0, 0), length: 2, taps: 1)
  wire(
    "b.tap1",
    (rel: (0, -0.6)),
    (rel: (1, 0)),
    (rel: (0, 0.6)),
  )
})

// Polyline mixing all three relative-coord forms in one wire:
// named anchor, `(rel: vec)` (relative to previous point), and
// `(rel: vec, to: anchor)` (relative to a specific named anchor).
#test({
  bus("b1", (0, 0),    length: 1.2, angle: 90deg)
  bus("b2", (2.5, -1), length: 1.2, angle: 90deg)
  wire(
    "b1.mid",
    (rel: (0, -0.4)),
    (rel: (0, 0.3), to: "b2.mid"),
    "b2.mid",
  )
})

// Inline `label:` — caption at wire midpoint, default `north` side.
#test({
  bus("b1", (0, 0), length: 1.2, angle: 90deg)
  bus("b2", (3, 0), length: 1.2, angle: 90deg)
  wire("b1.mid", "b2.mid", label: [Tie cable])
})

// All four cardinal `label-side` values + a custom distance.
#test({
  wire((0, 0),    (3, 0),    label: [north], label-side: "north")
  wire((0, -1),   (3, -1),   label: [south], label-side: "south")
  wire((0, -2),   (3, -2),   label: [east],  label-side: "east")
  wire((0, -3),   (3, -3),   label: [west],  label-side: "west")
  wire((0, -4.5), (3, -4.5), label: [far north],
    label-side: "north", label-distance: 0.4)
})

// Label on a polyline — midpoint is computed from FIRST and LAST
// points, so intermediate corners don't shift the label.
#test({
  wire(
    (0, 0), (1, 1), (2, 0), (3, 1),
    label: [zigzag],
  )
})

// Standalone `note()` for free-floating captions.
#test({
  bus("b", (0, 0), length: 2, taps: 3)
  note("b.tap1", [tap 1], side: "south")
  note("b.tap2", [middle], side: "north")
  note(("b.tap2", 50%, "b.tap3"), [between t2 and t3], side: "south")
  note((1.0, 0.5), [floating], side: "east")
})
