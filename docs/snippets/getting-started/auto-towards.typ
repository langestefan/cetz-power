#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // `towards:` aims each tip at a coordinate — here three feeder
  // exports converge on one node — and every label stays on the
  // free side as the tips swing around.
  junction("j", (2, -1.4))
  load("l1", (0.4, 0), towards: (2, -1.4), label: [E₁])
  load("l2", (2, 0.4), towards: (2, -1.4), label: [E₂])
  load("l3", (3.6, 0), towards: (2, -1.4), label: [E₃])
})
