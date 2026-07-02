#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// Figure E.1: the modified CIGRE MV network. A 110 kV bus (Bus 0) feeds two
// parallel 110/20 kV transformers (each with an HV-side switch) onto two MV
// feeders. Every numbered point is a real busbar (Buses 1–14), joined by
// phase-marked lines carrying their length. Feeder 1 is a ring closed by
// switches S2/S3; switch S1 (2.0 km) ties the two feeders. Buses 1 and 12 sit
// just outside their feeder boxes. Flexible devices — loads and rooftop PV —
// are blue; the Bus 9 load is a firm (black) load. Connections always tap a
// bus a little in from its ends, and runs are kept orthogonal (no diagonals).
#diagram(length: 1cm, {
  let blue = rgb("#2b7bba")

  // ── Helpers ─────────────────────────────────────────────────────
  // three diagonal phase-conductor ticks across a segment.
  let ticks(p, ang) = cetz.draw.group({
    cetz.draw.set-origin(p)
    cetz.draw.rotate(ang)
    for o in (-0.07, 0.0, 0.07) {
      cetz.draw.line(
        (o - 0.06, -0.085),
        (o + 0.06, 0.085),
        stroke: 0.7pt + black,
      )
    }
  })
  let dl(a, b, c, s) = note(
    (a, 50%, b),
    text(size: 5pt)[#c],
    side: s,
    distance: 0.15,
  )
  let nl(p, c, s) = note(p, text(size: 6pt)[#c], side: s, distance: 0.05)
  // a phase-marked straight line with a length label.
  let link(a, b, lbl, lside, ang) = {
    wire(a, b)
    ticks((a, 35%, b), ang)
    dl(a, b, lbl, lside)
  }
  // horizontal busbar centred at (x, y).
  let bbar(name, x, y, hl) = bus(name, (x - hl, y), (x + hl, y))
  let bload(name, p) = load(
    name,
    p,
    fill: blue,
    stroke: blue,
    size: 0.14,
    lead: 0.14,
  )
  let bpv(name, p) = pv-panel(
    name,
    p,
    size: 0.16,
    aspect: 1.3,
    lead: 0.12,
    stroke: blue,
  )
  // blue LV-feeder transformer hanging from a bus point, with a blue load below.
  // A short blue lead always separates the bus from the transformer.
  let lvfeed(name, p) = {
    let top = (rel: (0, -0.12), to: p)
    let bot = (rel: (0, -0.58), to: p)
    cetz.draw.line(p, top, stroke: blue)
    transformer(name, top, bot, radius: 0.13, distance: 0.16, stroke: blue)
    load(name + "-l", bot, fill: blue, stroke: blue, size: 0.14, lead: 0.12)
  }
  let V = -90deg
  let Hh = 0deg

  // ── Bus 0 (110 kV) + external grid ──────────────────────────────
  external-grid("grid", (2.75, 9.6), size: 0.9)
  bus("b0", (-0.8, 9.6), (6.3, 9.6))
  nl((1.0, 9.6), [0], "north")

  // ── Two 110/20 kV transformer drops ─────────────────────────────
  for (fx, sfx) in ((0, "a"), (5.5, "b")) {
    wire((fx, 9.6), (fx, 9.47)) // lead: bus 0 → switch
    switch("sw" + sfx, (fx, 9.47), (fx, 9.02))
    wire((fx, 9.02), (fx, 8.87)) // lead: switch → transformer
    transformer(
      "tx" + sfx,
      (fx, 8.87),
      (fx, 8.37),
      radius: 0.15,
      distance: 0.18,
    )
    cetz.draw.content((fx - 0.36, 8.6), anchor: "east", [110/20 kV])
  }

  // ════════════════ FEEDER 1 ════════════════
  // Bus 1 — sits OUTSIDE the feeder box (above it).
  bbar("b1", 0, 8.2, 0.5)
  wire((0, 8.37), (0, 8.2))
  nl("b1.end", [1], "east")
  bload("l1", bus-frac("b1", 0.3))
  bpv("pv1", bus-frac("b1", 0.72))
  // Bus 2 — first bus inside the box.
  bbar("b2", 0, 7.2, 0.5)
  link((0, 8.2), (0, 7.2), [2.8 km], "east", V)
  nl("b2.end", [2], "east")
  bpv("pv2", bus-frac("b2", 0.7))
  // Bus 3 — wide bar: a central load, plus two branches ~12 % in from each end.
  bbar("b3", 0, 6.4, 2.2)
  link((0, 7.2), (0, 6.4), [4.4 km], "east", V)
  nl("b3.end", [3], "east")
  bload("l3", bus-frac("b3", 0.5))

  // ── Left ring: 4 → 5 (down) and 4 → 11 → 10 → 9 (down through S3) ──
  // Bus 4 — wide bar; a single left trunk drops Bus 3 → Bus 4 → Bus 5's centre.
  bbar("b4", -1.6, 5.7, 0.9) // spans [-2.5, -0.7]
  link((-2.0, 6.4), (-2.0, 5.7), [0.6 km], "west", V) // Bus 3 → Bus 4 (trunk)
  nl("b4.start", [4], "west")
  bload("l4", (-1.6, 5.7)) // load at centre
  // Bus 5 — left edge aligned with Bus 4; the trunk lands on its centre, the
  //         1.5 km to Bus 6 departs that same centre, the load hangs on the left.
  bbar("b5", -2.0, 4.8, 0.5) // centre -2.0, spans [-2.5, -1.5]
  link((-2.0, 5.7), (-2.0, 4.8), [0.6 km], "west", V) // Bus 4 → Bus 5 centre
  nl("b5.start", [5], "west")
  load("l5", (-2.3, 4.8), size: 0.14, lead: 0.14, fill: black)
  // Bus 11 — same bar as Bus 10, vertically aligned with it; fed via S3 from
  //          Bus 4; load on the left, PV on the right.
  bbar("b11", -0.9, 4.8, 0.45) // centre -0.9, spans [-1.35, -0.45]
  wire((-0.9, 5.7), (-0.9, 5.52)) // lead: Bus 4 → S3 (on the shared centre line)
  switch("s3", (-0.9, 5.07), (-0.9, 5.52)) // hinge at bottom → opens NW
  wire((-0.9, 5.07), (-0.9, 4.8))
  cetz.draw.content((-0.75, 5.5), anchor: "west", text(size: 6pt)[S3])
  cetz.draw.content((-0.75, 5.12), anchor: "west", text(size: 5pt)[0.5 km])
  nl("b11.end", [11], "east")
  bload("l11", bus-frac("b11", 0.2))
  bpv("pv11", bus-frac("b11", 0.8))
  // Bus 10 — identical bar directly below Bus 11; S3, Bus 11 & Bus 10 centres share one x.
  bbar("b10", -0.9, 4.1, 0.45) // centre -0.9, spans [-1.35, -0.45]
  link((-0.9, 4.8), (-0.9, 4.1), [0.3 km], "west", V) // Bus 11 centre → Bus 10 centre (same x as S3)
  nl("b10.end", [10], "east")
  bload("l10", bus-frac("b10", 0.2))
  // Bus 9 — VERTICAL bus, midway between Bus 10 and Bus 7; firm black load.
  bus("b9", (0.1, 2.9), (0.1, 3.6))
  wire((-0.6, 4.1), (-0.6, 3.25))
  wire((-0.6, 3.25), (0.3, 3.25)) // 0.8 km from Bus 10 → Bus 9 centre
  ticks((-0.6, 3.7), V)
  dl((-0.6, 4.1), (-0.6, 3.25), [0.8 km], "west")
  nl((0.3, 3.55), [9], "east")
  load("l9", (0.1, 3.0), elbow: 0.28, lead: 0.2, size: 0.15, fill: black)

  // ── Right chain: 3 → 7 → 8 → 6 (LV-feeder), with 9 tapping Bus 7 ──
  // Bus 7 — load at centre; 1.3 km enters left-of-centre; two leads leave on the right.
  bbar("b7", 1.6, 4.35, 1.0) // spans [0.6, 2.6]
  link((1.6, 6.4), (1.6, 4.35), [1.3 km], "east", V)
  nl("b7.end", [7], "east")
  bload("l7", bus-frac("b7", 0.5)) // load at centre
  // Bus 7 → Bus 9 tap (0.3 km): off Bus 7's left, down then west into Bus 9's centre.
  wire((0.8, 4.35), (0.8, 3.25))
  wire((0.8, 3.25), (0.3, 3.25))
  ticks((0.8, 3.8), V)
  dl((0.8, 4.35), (0.8, 3.25), [0.3 km], "east")
  // Bus 8 — centre sits right of Bus 7's centre so the 1.7 km lead is a right lead.
  bbar("b8", 2.0, 3.45, 0.5) // spans [1.5, 2.5]
  link((2.0, 4.35), (2.0, 3.45), [1.7 km], "east", V) // right lead off Bus 7 → Bus 8 centre
  nl("b8.end", [8], "east")
  bload("l8", bus-frac("b8", 0.15))
  // Bus 6 (LV-feeder 1): S2 lands on its top centre; transformer left, load right.
  bbar("b6", 2.3, 2.5, 0.65) // centre 2.3, spans [1.65, 2.95]
  wire((2.3, 3.45), (2.3, 3.27)) // lead: Bus 8 right side → S2
  switch("s2", (2.3, 2.82), (2.3, 3.27)) // hinge at bottom → opens NW
  wire((2.3, 2.82), (2.3, 2.5)) // lead + ticks → Bus 6 centre
  cetz.draw.content((2.43, 3.06), anchor: "west", text(size: 6pt)[S2])
  cetz.draw.content((2.43, 2.7), anchor: "west", text(size: 5pt)[0.2 km])
  nl("b6.end", [6], "east")
  lvfeed("tx6", bus-frac("b6", 0.18)) // blue LV transformer (left)
  bload("l6", bus-frac("b6", 0.82)) // blue load (right)

  // ── Bus 5 centre → Bus 6 centre along the bottom (two 90° turns). ──
  wire((-2.0, 4.8), (-2.0, 1.2))
  ticks((-2.0, 3.0), V)
  dl((-2.0, 4.8), (-2.0, 1.2), [1.5 km], "west")
  wire((-2.0, 1.2), (2.3, 1.2))
  wire((2.3, 1.2), (2.3, 2.5)) // up into Bus 6's centre

  // ════════════════ FEEDER 2 ════════════════
  // Bus 12 — sits OUTSIDE the feeder box (above it).
  bbar("b12", 5.5, 8.2, 0.5)
  wire((5.5, 8.37), (5.5, 8.2))
  nl((6.05, 8.2), [12], "east")
  bload("l12", bus-frac("b12", 0.25))
  bpv("pv12", bus-frac("b12", 0.74))
  // Bus 13
  bbar("b13", 5.5, 6.3, 0.5)
  wire((5.5, 8.2), (5.5, 6.3))
  ticks((5.5, 7.0), V) // ticks lowered clear of the box top
  dl((5.5, 8.2), (5.5, 6.3), [4.9 km], "east")
  nl((6.05, 6.3), [13], "east")
  bload("l13", bus-frac("b13", 0.25))
  bpv("pv13", bus-frac("b13", 0.74))
  // Bus 14 — plain load on the left, blue LV-feeder 2 (transformer + load) on the right
  bbar("b14", 5.5, 4.6, 0.5)
  link((5.5, 6.3), (5.5, 4.6), [3.0 km], "east", V)
  nl((6.05, 4.6), [14], "east")
  bload("l14", bus-frac("b14", 0.25))
  lvfeed("tx14", bus-frac("b14", 0.78))

  // ── Tie: a right lead off Bus 7 drops just below it, runs east through S1
  //    (inside Feeder 2), then rises into Bus 14's centre line.
  wire((2.4, 4.35), (2.4, 3.95)) // right lead off Bus 7 → tie
  wire((2.4, 3.95), (3.6, 3.95)) // east into Feeder 2 → S1
  switch("s1", (3.6, 3.95), (4.1, 3.95))
  nl((3.85, 4.1), [S1], "north")
  wire((4.1, 3.95), (5.5, 3.95))
  ticks((4.8, 3.95), Hh) // S1 → Bus 14; phase ticks right of S1
  dl((4.1, 3.95), (5.5, 3.95), [2.0 km], "south")
  wire((5.5, 3.95), (5.5, 4.6)) // riser up into Bus 14's centre

  // ── Dashed feeder boundary boxes (small gap between them) ────────
  let dash = (dash: "dashed", paint: black, thickness: 0.5pt)
  cetz.draw.rect((-3.3, 0.9), (3.3, 7.6), stroke: dash)
  cetz.draw.content((-3.2, 7.5), anchor: "north-west", [Feeder 1])
  cetz.draw.rect((3.5, 0.9), (6.6, 7.6), stroke: dash)
  cetz.draw.content((3.6, 7.5), anchor: "north-west", [Feeder 2])
})
