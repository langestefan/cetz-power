#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// Control scheme of a grid-side converter, after Figure 8 of
// https://ieeexplore.ieee.org/document/10054041. Solid lines are power
// connections (DC bus → DC link → converter → LC filter → grid
// inductor → PCC); dashed lines are signal connections. The outer-loop
// reference generator tracks P/Q setpoints plus the DC-link voltage,
// the inner PI loop drives the converter, and a PLL synchronises the
// abc → dq0 measurement frame at the filter capacitor.
#diagram(length: 1.1cm, {
  let grey = luma(150)
  let boxfill = luma(238)
  let dashed = (paint: black, thickness: 0.7pt, dash: "dashed")
  // Dashed signal route: polyline with a clean (solid) arrowhead on
  // the last segment.
  let sig(..pts) = {
    let pts = pts.pos()
    if pts.len() > 2 {
      cetz.draw.line(..pts.slice(0, -1), stroke: dashed)
    }
    flow-arrow(
      pts.at(pts.len() - 2),
      pts.at(pts.len() - 1),
      stroke: dashed,
      scale: 0.9,
    )
  }

  // ── Power sources on the DC bus ─────────────────────────────────
  bus("dcbus", (0.55, 5.35), (7.5, 5.35))
  for (i, x) in (1.4, 3.15, 4.9, 6.65).enumerate() {
    let active = i == 2
    let paint = if active { black } else { grey }
    block(
      "src" + str(i),
      (x, 5.9),
      width: 1.5,
      height: 0.7,
      stroke: (if active { 1.1pt } else { 0.8pt }) + paint,
      body: text(fill: paint, style: "italic")[Power \ Source],
    )
    cetz.draw.line((x, 5.55), (x, 5.35), stroke: 0.8pt + paint)
  }

  // ── DC link and converter ───────────────────────────────────────
  wire((4.9, 5.35), (4.9, 5.1))
  block("vdc", (4.9, 4.8), width: 0.6, height: 0.6)
  capacitor(
    "cdc",
    (4.9, 4.5),
    plate-width: 0.3,
    plate-gap: 0.12,
    lead-in: 0.24,
    lead-out: 0.24,
  )
  note((5.25, 4.8), $V_(D C)$, side: "east", distance: 0.05)
  wire((4.9, 4.5), (4.9, 4.15))
  converter("conv", (4.9, 3.7), size: 0.9, kind: "dc-ac")

  // ── Output filter and PCC ───────────────────────────────────────
  // The passives are one-node symbols growing +y from `in`; angle: 90deg
  // lays them leftward with the bumps up.
  block("lcf", (6.15, 3.7), width: 1.1, height: 0.85)
  inductor(
    "lf",
    (6.15, 3.7),
    angle: 90deg,
    bumps: 3,
    bump-radius: 0.07,
    lead-in: 0.065,
    lead-out: 0.065,
  )
  wire((6.15, 3.7), (6.7, 3.7))
  capacitor(
    "cf",
    (6.15, 3.7),
    angle: 180deg,
    plate-width: 0.26,
    plate-gap: 0.09,
    lead-in: 0.12,
    lead-out: 0.11,
  )
  // Thin busbar under the filter capacitor — spans the box, but stops
  // short of its edges.
  cetz.draw.line((5.71, 3.38), (6.59, 3.38), stroke: 0.8pt + black)
  block("lbox", (7.5, 3.7), width: 0.85, height: 0.7)
  inductor(
    "lg",
    (7.925, 3.7),
    angle: 90deg,
    bumps: 4,
    bump-radius: 0.08,
    lead-in: 0.105,
    lead-out: 0.105,
  )
  wire("conv.east", "lcf.west")
  wire("lcf.east", "lbox.west")
  wire("lbox.east", (8.55, 3.7))
  bus("pcc", (8.55, 2.4), (8.55, 5.8))
  note(
    (8.67, 5.35),
    rotate(90deg, reflow: true)[_PCC_],
    side: "east",
    distance: 0.05,
    size: 9pt,
  )

  // ── Control chain ───────────────────────────────────────────────
  block(
    "refgen",
    (1.5, 3.7),
    width: 1.9,
    height: 1.0,
    fill: boxfill,
    body: text(style: "italic", size: 9pt)[Reference \ Generator],
  )
  mixer("mix", (3.1, 3.7), radius: 0.17)
  block("pi", (3.85, 3.7), width: 0.65, height: 0.55, fill: none, body: text(
    style: "italic",
    size: 9pt,
  )[PI])
  note(
    (3.85, 4.05),
    emph[Inner Loop \ Controller],
    side: "north",
    distance: 0.05,
    size: 6pt,
  )
  note(
    (1.35, 4.5),
    emph[Outer Loop \ Controller],
    side: "east",
    distance: 0.05,
    size: 6pt,
  )

  // Setpoints in, reference out, PI to converter.
  sig((0.0, 3.95), (0.55, 3.95))
  note((-0.02, 3.95), $P_i^"ref"$, side: "west", distance: 0.02)
  sig((0.0, 3.45), (0.55, 3.45))
  note((-0.02, 3.45), $Q_i^"ref"$, side: "west", distance: 0.02)
  sig("refgen.east", "mix.west")
  note((2.7, 3.55), $i_(d q)^*$, side: "south", distance: 0.08)
  sig("mix.east", "pi.west")
  sig("pi.east", "conv.west")

  // DC-link voltage into the outer loop.
  sig((4.6, 4.8), (1.2, 4.8), (1.2, 4.2))

  // Measurement frame: V_C at the filter capacitor, PLL, dq0/abc.
  block("dq0", (5.55, 1.85), width: 1.0, height: 0.9)
  cetz.draw.line("dq0.south-west", "dq0.north-east", stroke: 0.8pt + black)
  cetz.draw.content((5.34, 2.09), text(size: 8pt, style: "italic")[dq0])
  cetz.draw.content((5.78, 1.61), text(size: 8pt, style: "italic")[abc])
  block("pll", (6.9, 1.85), width: 0.9, height: 0.6, fill: boxfill, body: text(
    style: "italic",
    size: 9pt,
  )[PLL])

  sig((6.9, 3.7), (6.9, 2.15))
  note((7.0, 3.05), $V_C$, side: "east", distance: 0.05)
  sig((6.9, 2.55), (5.3, 2.55), (5.3, 2.3))
  sig("pll.west", "dq0.east")
  note((6.23, 1.93), $theta$, side: "north", distance: 0.05)

  // Transformed measurements back into the loops.
  sig((5.05, 2.05), (3.1, 2.05), (3.1, 3.53))
  note((3.18, 2.85), $i_(d q)$, side: "east", distance: 0.05)
  sig((5.05, 1.65), (1.5, 1.65), (1.5, 3.2))
  note((2.6, 1.73), $v_(d q)$, side: "north", distance: 0.05)
})
