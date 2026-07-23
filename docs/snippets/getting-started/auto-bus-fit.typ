#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Feeders land at known x positions; let the bar size itself:
  // the fit coordinates plus a symmetric overshoot at both ends.
  let taps = ((0, 0), (1, 0), (2, 0), (3.2, 0))
  for (i, p) in taps.enumerate() {
    load("l" + str(i), p)
  }
  bus("hv", fit: taps, over: 0.3, label: [HV])

  // `over: (ref:, gap:)` computes the overshoot ref/2 − gap/2 that
  // lines this bar's ends up with a reference bar of length `ref`
  // across two connections `gap` apart.
  bus("a", (5.5, -0.55), length: 1.4, angle: 90deg)
  wire((5.5, -0.15), (7, -0.15))
  wire((5.5, -0.95), (7, -0.95))
  bus(
    "b",
    fit: ((7, -0.15), (7, -0.95)),
    over: (ref: 1.4, gap: 0.8),
    label: (content: [aligned], anchor: "east"),
  )
})
