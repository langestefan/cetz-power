#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Two-node placement: the body sits at the midpoint with leads to
  // the endpoints — an inline device on a link.
  bus("a", (0, 0), length: 1.0, angle: 90deg)
  bus("b", (3.6, 0), length: 1.0, angle: 90deg)
  block("svc", "a.mid", "b.mid", body: [SVC])
})
