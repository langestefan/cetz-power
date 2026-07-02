#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Default: closed (filled) connection point.
#test({
  junction("j", (0, 0))
})

// Open point (hollow circle).
#test({
  junction("j", (0, 0), open: true)
})

// On a wire: closed points connect, the open point masks the
// conductor beneath it (draw junctions after wires).
#test({
  wire((0, 0), (3, 0))
  junction("j1", (0.75, 0))
  junction("j2", (1.5, 0))
  junction("j3", (2.25, 0), open: true)
})

// Radius / stroke / fill overrides; label.
#test({
  wire((0, 0), (2, 0))
  junction("j1", (0.5, 0), radius: 0.15, stroke: 0.8pt + red)
  junction("j2", (1.5, 0), open: true, fill: yellow, label: [N1])
})

// Wire stopping at the circle edge via compass anchors.
#test({
  junction("j", (1, 0), open: true, radius: 0.12)
  wire((0, 0), "j.west")
  wire("j.east", (2, 0))
})
