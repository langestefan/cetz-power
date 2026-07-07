#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.8cm, {
  // The canonical chain: the CT secondary feeds the relay, and the
  // relay trips the breaker over a dashed signal path (a plain dashed
  // line + a flow-arrow for the solid head).
  bus("mv", (0, 0), length: 2.2)
  wire((1.1, 0), (1.1, -2.0))
  ct("ct1", (1.1, -0.8), angle: 90deg)
  breaker("cb", (1.1, -2.0), (1.1, -2.7))
  relay("prot", (2.4, -0.8), "50/51", label: [feeder protection])
  wire((1.26, -0.8), "prot.west")
  let dashed = (paint: black, thickness: 0.7pt, dash: "dashed")
  cetz.draw.line("prot.south", (2.4, -2.35), stroke: dashed)
  flow-arrow((2.4, -2.35), (1.28, -2.35), stroke: dashed)
})
