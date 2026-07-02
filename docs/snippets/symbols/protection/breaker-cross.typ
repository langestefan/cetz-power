#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// kind: "cross" — the compact × used in network-overview diagrams to
// mark switchgear positions. Two-node draws the wire through it; the
// one-node form drops the × straight onto an existing run.
#diagram(length: 1.2cm, {
  breaker("cb", (0, 0), (1.6, 0), kind: "cross")
  wire((2.4, 0), (5, 0))
  breaker("x1", (3.2, 0), kind: "cross", size: 0.2)
  breaker("x2", (4.2, 0), kind: "cross", size: 0.2, stroke: 0.8pt + red)
})
