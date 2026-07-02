#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

// TU/e thesis fig. 4.9 — the urban LV benchmark grid: a 150 MVA, 10 kV
// external grid feeds bus 1, an OLTC 10/0.4 kV transformer steps down onto
// bus 2, and three radial 400 V feeders (3–12 with the 6–9 sub-branch,
// 13–22 with the 17–19 and 28/29 sub-branches, 23–34) serve 34 buses in
// total. Five normally-open switches S1–S5 tie the feeder ends together
// along the right edge. Firm loads are black arrows, flexible loads are
// blue, and eight PV panels hang off their buses as chevron boxes.
// Layout digitised from the figure (oneline-diagram-annotator), so the
// geometry matches the original; every connection taps a bus-tick
// interior perpendicular. Buses 20 and 28 are NOT connected — the 28/29
// spur hangs off bus 27, and bus 20 just carries a PV panel. Devices are
// drawn before their buses so the bars paint over the lead roots (a blue
// lead otherwise shows its connection point on top of the bar).
#diagram(length: 1cm, {
  let s = 0.016 // image-pixel → cm (compression knob)
  let H = 808
  let P(x, y) = (x * s, (H - y) * s) // flip y (image is y-down)

  let flex = rgb("#29abe2") // the figure's cyan for flexible devices

  // ── helpers ─────────────────────────────────────────────────────
  let nl(p, c, sd, d: 0.08) = note(p, c, side: sd, distance: d, size: 8pt)
  // segment-length label; vertical runs get rotated text
  let dl(a, b, c, sd) = note(
    (a, 50%, b),
    if sd in ("east", "west") { rotate(-90deg, reflow: true, c) } else { c },
    side: sd,
    distance: 0.05,
    size: 5.5pt,
  )
  // labelled horizontal feeder hop
  let hs(x1, x2, y, c, sd: "north") = {
    wire(P(x1, y), P(x2, y))
    dl(P(x1, y), P(x2, y), c, sd)
  }
  // node bus = vertical tick centred on its feeder row, numbered above
  let half = 32 // px half-length of a tick
  let nbus(n, x, y) = {
    bus(str(n), P(x, y - half), P(x, y + half))
    nl(P(x, y - half), [#n], "north")
  }
  // devices leave a tick's lower body with an L-bend (across, then down)
  let eL = 24 // px below the row where elbows exit
  let ld(n, x, y) = load(
    "l" + str(n),
    P(x, y + eL),
    elbow: 0.26,
    size: 0.18,
    lead: 0.16,
  )
  let fx(n, x, y) = load(
    "f" + str(n),
    P(x, y + eL),
    elbow: 0.26,
    size: 0.18,
    lead: 0.16,
    fill: flex,
    stroke: flex,
  )
  let pv(n, x, y) = pv-panel(
    "pv" + str(n),
    P(x, y + eL),
    elbow: 0.38,
    size: 0.2,
    aspect: 1.6,
    lead: 0.1,
  )
  // normally-open tie switch on the vertical at x, centred on y = c
  let swhalf = 17
  let sw(i, x, c) = {
    switch("s" + str(i), P(x, c - swhalf), P(x, c + swhalf))
    nl(P(x, c), [S#i], "east", d: 0.24)
  }

  // ── source: external grid → bus 1 → OLTC transformer → bus 2 ────
  external-grid("grid", P(160, 410), angle: 90deg, size: 0.62)
  cetz.draw.content(P(134, 360), align(center)[150 MVA,\ 10 kV])
  cetz.draw.content(P(134, 462), align(center)[External\ Grid])
  wire(P(160, 410), P(211, 410))
  wire(P(211, 410), P(228, 410))
  transformer("t12", P(228, 410), P(274, 410), radius: 0.18, distance: 0.2)
  cetz.draw.line(
    P(233, 427),
    P(269, 391), // OLTC arrow through the rings
    stroke: 0.7pt,
    mark: (end: ">", fill: black, scale: 0.5),
  )
  cetz.draw.content(P(251, 451), [10/0.4 kV])
  wire(P(274, 410), P(290, 410))
  bus("1", P(211, 378), P(211, 442))
  nl(P(211, 378), [1], "north")
  bus("2", P(290, 304), P(290, 497))
  nl(P(290, 304), [2], "north")
  cetz.draw.content(P(150, 578), align(
    center,
  )[R = 0.641 Ω/km \ X = 0.085 Ω/km \ Cable capacity = 105 kVA])

  // ── feeder A: bus 2 → 3 4 5 10 11 12 → S2 → 19 ──────────────────
  wire(P(290, 316), P(313, 316), P(313, 183), P(342, 183))
  dl(P(313, 316), P(313, 183), [50 m], "west")
  hs(342, 395, 183, [20 m])
  hs(395, 487, 183, [30 m])
  hs(487, 559, 183, [25 m])
  hs(559, 651, 183, [30 m])
  hs(651, 725, 183, [25 m])
  wire(P(725, 183), P(888, 183), P(888, 220))
  sw(2, 888, 237)
  wire(P(888, 254), P(888, 291), P(828, 291))
  dl(P(888, 291), P(828, 291), [20 m], "north")
  ld(3, 342, 183)
  fx(4, 395, 183)
  pv(5, 487, 183)
  fx(10, 559, 183)
  ld(11, 651, 183)
  pv(12, 725, 183)
  nbus(3, 342, 183)
  nbus(4, 395, 183)
  nbus(5, 487, 183)
  nbus(10, 559, 183)
  nbus(11, 651, 183)
  nbus(12, 725, 183)

  // ── top branch: 5 → 6 7 8 9 → S1 → 12 ───────────────────────────
  wire(P(487, 165), P(524, 165), P(524, 62), P(571, 62))
  dl(P(524, 165), P(524, 62), [35 m], "west")
  hs(571, 624, 62, [20 m])
  hs(624, 717, 62, [30 m])
  hs(717, 788, 62, [25 m])
  wire(P(788, 62), P(852, 62), P(852, 99))
  sw(1, 852, 116)
  wire(P(852, 133), P(852, 169), P(725, 169))
  dl(P(852, 169), P(725, 169), [30 m], "north")
  ld(6, 571, 62)
  fx(7, 624, 62)
  pv(8, 717, 62)
  ld(9, 788, 62)
  nbus(6, 571, 62)
  nbus(7, 624, 62)
  nbus(8, 717, 62)
  nbus(9, 788, 62)

  // ── main feeder: bus 2 → 13 14 15 16 20 21 22 → S4 → 29 ─────────
  hs(290, 381, 410, [40 m])
  hs(381, 476, 410, [30 m])
  hs(476, 548, 410, [25 m])
  hs(548, 602, 410, [20 m])
  hs(602, 676, 410, [25 m], sd: "south") // south: the 17-riser jog is above
  hs(676, 769, 410, [25 m])
  hs(769, 822, 410, [20 m])
  wire(P(822, 410), P(888, 410), P(888, 419))
  sw(4, 888, 436)
  wire(P(888, 453), P(888, 494), P(732, 494))
  dl(P(888, 494), P(732, 494), [5 m], "north")
  pv(13, 381, 410)
  ld(14, 476, 410)
  fx(15, 548, 410)
  ld(16, 602, 410)
  pv(20, 676, 410)
  fx(21, 769, 410)
  ld(22, 822, 410)
  nbus(13, 381, 410)
  nbus(14, 476, 410)
  nbus(15, 548, 410)
  nbus(16, 602, 410)
  nbus(20, 676, 410)
  nbus(21, 769, 410)
  nbus(22, 822, 410)

  // ── 16 branch: 16 → 17 18 19 → S3 → 22 ──────────────────────────
  wire(P(602, 391), P(629, 391), P(629, 304), P(661, 304))
  dl(P(629, 391), P(629, 304), [30 m], "west")
  hs(661, 735, 304, [25 m])
  hs(735, 828, 304, [30 m])
  wire(P(828, 304), P(888, 304), P(888, 350))
  sw(3, 888, 367)
  wire(P(888, 384), P(888, 391), P(822, 391))
  dl(P(888, 391), P(822, 391), [10 m], "north")
  pv(17, 661, 304)
  ld(18, 735, 304)
  fx(19, 828, 304)
  nbus(17, 661, 304)
  nbus(18, 735, 304)
  nbus(19, 828, 304)

  // ── 28/29 spur: 27 → 28 29 → S4/S5 ──────────────────────────────
  wire(P(617, 601), P(644, 601), P(644, 516), P(676, 516)) // 27 → 28 riser
  dl(P(644, 601), P(644, 516), [30 m], "west")
  wire(P(676, 516), P(732, 516))
  dl(P(676, 516), P(732, 516), [20 m], "north")
  wire(P(732, 516), P(865, 516), P(865, 543))
  sw(5, 865, 560)
  wire(P(865, 577), P(865, 620))
  fx(28, 676, 516)
  ld(29, 732, 516)
  nbus(28, 676, 516)
  bus("29", P(732, 476), P(732, 548))
  nl(P(732, 476), [29], "north")

  // ── bottom feeder: bus 2 → 23 24 25 26 27 30 31 → S5 ────────────
  wire(P(290, 485), P(318, 485), P(318, 620), P(343, 620))
  dl(P(318, 485), P(318, 620), [50 m], "west")
  hs(343, 416, 620, [25 m])
  hs(416, 469, 620, [20 m])
  hs(469, 563, 620, [30 m])
  hs(563, 617, 620, [20 m])
  hs(617, 690, 620, [25 m])
  hs(690, 784, 620, [30 m])
  hs(784, 865, 620, [5 m])
  ld(23, 343, 620)
  fx(24, 416, 620)
  pv(25, 469, 620)
  fx(26, 563, 620)
  ld(27, 617, 620)
  ld(30, 690, 620)
  ld(31, 784, 620)
  nbus(23, 343, 620)
  nbus(24, 416, 620)
  nbus(25, 469, 620)
  nbus(26, 563, 620)
  nbus(27, 617, 620)
  nbus(30, 690, 620)
  nbus(31, 784, 620)

  // ── 30 branch: 30 → 32 33 34 ─────────────────────────────────────
  wire(P(690, 629), P(740, 629), P(740, 723), P(780, 723))
  dl(P(740, 629), P(740, 723), [25 m], "west")
  hs(780, 873, 723, [30 m])
  hs(873, 927, 723, [20 m])
  pv(32, 780, 723)
  ld(33, 873, 723)
  fx(34, 927, 723)
  nbus(32, 780, 723)
  nbus(33, 873, 723)
  nbus(34, 927, 723)
})
