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
    cetz.draw.set-origin(p); cetz.draw.rotate(ang)
    for o in (-0.07, 0.0, 0.07) {
      cetz.draw.line((o - 0.06, -0.085), (o + 0.06, 0.085), stroke: 0.7pt + black)
    }
  })
  let dl(a, b, c, s) = note((a, 50%, b), text(size: 5pt)[#c], side: s, distance: 0.06)
  let nl(p, c, s) = note(p, text(size: 6pt)[#c], side: s, distance: 0.05)
  // a phase-marked straight line with a length label.
  let link(a, b, lbl, lside, ang) = { wire(a, b); ticks((a, 35%, b), ang); dl(a, b, lbl, lside) }
  // horizontal busbar centred at (x, y).
  let bbar(name, x, y, hl) = bus(name, (x - hl, y), (x + hl, y))
  let bload(name, p) = load(name, p, fill: blue, stroke: blue, size: 0.14, lead: 0.14)
  let bpv(name, p) = pv-panel(name, p, size: 0.16, aspect: 1.3, lead: 0.12, stroke: blue)
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
  external-grid("grid", (2.75, 10.0), size: 0.9)
  bus("b0", (-0.8, 10), (6.3, 10)); nl((1.0, 10), [0], "north")

  // ── Two 110/20 kV transformer drops ─────────────────────────────
  for (fx, sfx) in ((0, "a"), (5.5, "b")) {
    wire((fx, 10), (fx, 9.87))                              // lead: bus 0 → switch
    switch("sw" + sfx, (fx, 9.87), (fx, 9.42))
    wire((fx, 9.42), (fx, 9.25))                            // lead: switch → transformer
    transformer("tx" + sfx, (fx, 9.25), (fx, 8.75), radius: 0.15, distance: 0.18)
    cetz.draw.content((fx - 0.36, 9.0), anchor: "east", [110/20 kV])
  }

  // ════════════════ FEEDER 1 ════════════════
  // Bus 1 — sits OUTSIDE the feeder box (above it).
  bbar("b1", 0, 8.2, 0.5)
  wire((0, 8.75), (0, 8.2))
  nl("b1.end", [1], "east"); bload("l1", bus-frac("b1", 0.3)); bpv("pv1", bus-frac("b1", 0.72))
  // Bus 2 — first bus inside the box.
  bbar("b2", 0, 7.0, 0.5)
  link((0, 8.2), (0, 7.0), [2.8 km], "east", V)
  nl("b2.end", [2], "east"); bpv("pv2", bus-frac("b2", 0.7))
  // Bus 3 — wide bar: a central load, plus two branches ~12 % in from each end.
  bbar("b3", 0, 5.8, 2.2)
  link((0, 7.0), (0, 5.8), [4.4 km], "east", V)
  nl("b3.end", [3], "east"); bload("l3", bus-frac("b3", 0.5))

  // ── Left ring: 4 → 5 (down) and 4 → 11 → 10 → 9 (down through S3) ──
  // Bus 4 — fed straight down from Bus 3's left branch (x = -1.67).
  bbar("b4", -1.6, 5.1, 0.7)
  link((-1.67, 5.8), (-1.67, 5.1), [0.6 km], "west", V)
  nl("b4.start", [4], "west"); bload("l4", (-1.9, 5.1))
  // Bus 5 (left) — its centre routes to Bus 6 along the bottom.
  bbar("b5", -2.3, 4.2, 0.6)
  link((-2.1, 5.1), (-2.1, 4.2), [0.6 km], "west", V)
  nl("b5.start", [5], "west")
  // Bus 11 (right) through the vertical disconnector S3 (opens NW).
  bbar("b11", -0.9, 4.2, 0.6)
  wire((-1.15, 5.1), (-1.15, 4.92))                        // lead: Bus 4 → S3
  switch("s3", (-1.15, 4.47), (-1.15, 4.92))               // hinge at bottom → opens NW
  wire((-1.15, 4.47), (-1.15, 4.2)); ticks((-1.15, 4.33), V)
  cetz.draw.content((-0.93, 4.92), anchor: "west", text(size: 6pt)[S3])
  cetz.draw.content((-0.93, 4.5), anchor: "west", text(size: 5pt)[0.5 km])
  nl("b11.end", [11], "east"); bpv("pv11", bus-frac("b11", 0.85)); bload("l11", bus-frac("b11", 0.55))
  // Bus 10
  bbar("b10", -0.9, 3.5, 0.5)
  link((-1.15, 4.2), (-1.15, 3.5), [0.3 km], "west", V)
  nl("b10.end", [10], "east"); bload("l10", bus-frac("b10", 0.42))
  // Bus 9 — VERTICAL bus, midway between Bus 10 and Bus 7; firm black load.
  bus("b9", (0.3, 2.3), (0.3, 3.0))
  wire((-0.6, 3.5), (-0.6, 2.85)); wire((-0.6, 2.85), (0.3, 2.85))   // 0.8 km from Bus 10
  ticks((-0.6, 3.18), V); dl((-0.6, 3.5), (-0.6, 2.85), [0.8 km], "west")
  nl((0.3, 2.95), [9], "east")
  load("l9", (0.3, 2.4), elbow: 0.28, lead: 0.2, size: 0.15, fill: black)

  // ── Right chain: 3 → 7 → 8 → 6 (LV-feeder), with 9 tapping Bus 7 ──
  // Bus 7
  bbar("b7", 1.6, 3.75, 1.0)
  link((1.67, 5.8), (1.67, 3.75), [1.3 km], "east", V)
  nl("b7.end", [7], "east"); bload("l7", bus-frac("b7", 0.33))
  // Bus 7 → Bus 9 tap (0.3 km): down off Bus 7 (clear of Bus 8), then west to Bus 9.
  wire((1.0, 3.75), (1.0, 2.6)); wire((1.0, 2.6), (0.3, 2.6))
  ticks((1.0, 3.18), V); dl((1.0, 3.75), (1.0, 2.6), [0.3 km], "east")
  // Bus 8
  bbar("b8", 1.6, 2.85, 0.5)
  link((1.67, 3.75), (1.67, 2.85), [1.7 km], "east", V)
  nl("b8.end", [8], "east"); bload("l8", bus-frac("b8", 0.3))
  // Bus 6 (LV-feeder 1): transformer LEFT, Bus 5 route to CENTER, S2 on the RIGHT.
  bbar("b6", 1.6, 1.9, 0.6)
  wire((1.85, 2.85), (1.85, 2.67))                         // lead: Bus 8 → S2
  switch("s2", (1.85, 2.22), (1.85, 2.67))                 // hinge at bottom → opens NW
  wire((1.85, 2.22), (1.85, 1.9)); ticks((1.85, 1.98), V)  // lead + ticks → Bus 6 (right side)
  cetz.draw.content((1.98, 2.46), anchor: "west", text(size: 6pt)[S2])
  cetz.draw.content((1.98, 2.1), anchor: "west", text(size: 5pt)[0.2 km])
  nl("b6.end", [6], "east")
  lvfeed("tx6", bus-frac("b6", 0.2))                       // blue transformer load (left)
  bload("l6", bus-frac("b6", 0.71))                        // blue regular load (right, under S2)
  cetz.draw.content((1.0, 0.95), anchor: "north-west", [LV-feeder 1])

  // ── Bus 5 centre → Bus 6 centre along the bottom (two 90° turns). ──
  wire((-2.3, 4.2), (-2.3, 0.6)); ticks((-2.3, 3.4), V)
  dl((-2.3, 4.2), (-2.3, 0.6), [1.5 km], "west")
  wire((-2.3, 0.6), (1.6, 0.6))
  wire((1.6, 0.6), (1.6, 1.9))                             // up into Bus 6's centre

  // ════════════════ FEEDER 2 ════════════════
  // Bus 12 — sits OUTSIDE the feeder box (above it).
  bbar("b12", 5.5, 8.2, 0.5)
  wire((5.5, 8.75), (5.5, 8.2))
  nl((6.05, 8.2), [12], "east"); bload("l12", bus-frac("b12", 0.25)); bpv("pv12", bus-frac("b12", 0.74))
  // Bus 13
  bbar("b13", 5.5, 6.0, 0.5)
  link((5.5, 8.2), (5.5, 6.0), [4.9 km], "east", V)
  nl((6.05, 6.0), [13], "east"); bload("l13", bus-frac("b13", 0.25)); bpv("pv13", bus-frac("b13", 0.74))
  // Bus 14 — plain load on the left, blue LV-feeder 2 (transformer + load) on the right
  bbar("b14", 5.5, 4.0, 0.5)
  link((5.5, 6.0), (5.5, 4.0), [3.0 km], "east", V)
  nl((6.05, 4.0), [14], "east")
  bload("l14", bus-frac("b14", 0.25))
  lvfeed("tx14", bus-frac("b14", 0.78))
  cetz.draw.content((5.62, 3.0), anchor: "north-west", [LV-feeder 2])

  // ── Tie: Bus 7 goes down, turns east through S1 (inside Feeder 2),
  //    then turns north up Bus 14's centre line.
  wire((5.5, 4.0), (5.5, 1.6))                             // Bus 14 centre line / north riser
  wire((2.45, 3.75), (2.45, 1.6))                          // Bus 7 down (clear of Buses 8 & 6)
  wire((2.45, 1.6), (4.7, 1.6)); ticks((3.1, 1.6), Hh)     // east, 2.0 km
  dl((2.45, 1.6), (4.7, 1.6), [2.0 km], "south")
  switch("s1", (4.7, 1.6), (5.2, 1.6)); nl((4.95, 1.75), [S1], "north")
  wire((5.2, 1.6), (5.5, 1.6))                             // into the north riser

  // ── Dashed feeder boundary boxes (small gap between them) ────────
  let dash = (dash: "dashed", paint: black, thickness: 0.5pt)
  cetz.draw.rect((-3.3, 0.4), (3.3, 7.5), stroke: dash)
  cetz.draw.content((-3.2, 7.4), anchor: "north-west", [Feeder 1])
  cetz.draw.rect((4.3, 0.4), (6.6, 7.5), stroke: dash)
  cetz.draw.content((4.4, 7.4), anchor: "north-west", [Feeder 2])
})
