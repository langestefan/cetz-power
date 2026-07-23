#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram({
  // The auto side: east, beside a vertical run …
  transformer("t1", (0, 1), (0, -1), label: [auto])

  // … and the global opt-out — every later label pinned north again.
  cetz.draw.set-style(cetz-power: (label: (anchor: "north")))
  transformer("t2", (2.5, 1), (2.5, -1), label: [pinned])
  load("l1", (4.5, 0.4), label: [north too])
})
