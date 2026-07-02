#import "/src/lib.typ": *
#set page(margin: 8pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 1.2: Direction of reactive power flow. An HV network (+ SG) feeds
// the T-D interface bus; three HV/MV transformers step down to the MV bus,
// three MV/LV transformers step down to the LV feeders, and DALI sensors
// meter the LV interface. Q1 (solid →) flows TSO→DSO, Q2 (dashed ⇠) DSO→TSO.
#diagram(length: 1cm, {
  // ── Layout ──────────────────────────────────────────────────────
  let yt = 1.7 // top / middle / bottom row heights
  let ym = 0
  let yb = -1.7
  let x-grid = 0 // HV-network connection point
  let x-sg = 1.7 // SG tap
  let x-td = 3.4 // HV busbar
  let hv-out = 4.8 // HV/MV transformer output
  let x-tdi = (x-td + hv-out) / 2 // T-D interface = HV/MV bank (HV→MV)
  let x-mv = 6.6 // MV busbar
  let lv-in = 8.0 // MV/LV output = LV-feeder start
  let x-end = 12.6 // LV feeder end
  let tr-r = 0.23 // transformer circle radius / spacing
  let tr-d = 0.28
  let tso = luma(236) // TSO-area / DSO-area backdrops
  let dso = rgb("#dce9f2")

  // Q-flow arrow pair: solid → above, dashed ⇠ below, clear of the circles.
  let qpair(cx, y) = {
    cetz.draw.line(
      (cx - 0.5, y + 0.62),
      (cx + 0.5, y + 0.62),
      mark: (end: ">", fill: black),
      stroke: 0.8pt + black,
    )
    cetz.draw.line(
      (cx + 0.5, y - 0.62),
      (cx - 0.5, y - 0.62),
      mark: (end: ">", fill: black, stroke: 0.8pt + black),
      stroke: (paint: black, thickness: 0.8pt, dash: "dashed"),
    )
  }

  // ── Area backdrops; the TSO–DSO boundary runs through the HV/MV bank,
  // i.e. the T-D interface where HV becomes MV ────────────────────
  cetz.draw.rect((x-grid - 1.4, -2.5), (x-tdi, 2.9), fill: tso, stroke: none)
  cetz.draw.rect((x-tdi, -2.5), (x-end + 1.0, 2.9), fill: dso, stroke: none)
  cetz.draw.content((0.4, 2.5), text(size: 9pt)[TSO area])
  cetz.draw.content((9.7, 2.5), text(size: 9pt)[DSO area])

  // ── Two vertical busbars: HV bus (left) and MV bus (right) ──────
  bus("td", (x-td, yb - 0.3), (x-td, yt + 0.3))
  bus("mv", (x-mv, yb - 0.3), (x-mv, yt + 0.3))

  // ── HV network + synchronous generator feeding the T-D bus ──────
  external-grid(
    "hv",
    (x-grid, ym),
    angle: 90deg,
    size: 0.8,
    background: luma(190),
  )
  cetz.draw.content((x-grid - 0.6, ym + 0.7), [HV Network])
  wire("hv.in", (x-td, ym))
  voltagesource("sg", (x-sg, ym - 0.75), kind: "ac", radius: 0.28)
  wire((x-sg, ym), "sg.north")
  note("sg.east", [SG], side: "east")

  // ── HV/MV transformers (T-D bus → MV bus) ───────────────────────
  for (y, k) in ((yt, "t"), (ym, "m"), (yb, "b")) {
    transformer(
      "hvmv-" + k,
      (x-td, y),
      (hv-out, y),
      radius: tr-r,
      distance: tr-d,
    )
    wire((hv-out, y), (x-mv, y))
  }
  for y in (yt, yb) {
    cetz.draw.content(((x-td + hv-out) / 2, y + 0.55), [HV/MV])
  }
  cetz.draw.content(((x-td + hv-out) / 2, ym + 0.95), [HV/MV])
  qpair((x-td + hv-out) / 2, ym)
  // The T-D interface is the (middle) HV/MV transformer — where HV becomes MV.
  cetz.draw.content((2.1, 0.9), [T-D interface])
  cetz.draw.line(
    (2.85, 0.85),
    "hvmv-t",
    mark: (end: ">", fill: black),
    stroke: 0.7pt + black,
  )

  // ── MV/LV transformers (MV bus → LV feeders) ────────────────────
  for (y, k) in ((yt, "t"), (ym, "m"), (yb, "b")) {
    transformer(
      "mvlv-" + k,
      (x-mv, y),
      (lv-in, y),
      radius: tr-r,
      distance: tr-d,
    )
  }
  for y in (yt, yb) {
    cetz.draw.content(((x-mv + lv-in) / 2, y + 0.55), [MV/LV])
  }
  cetz.draw.content(((x-mv + lv-in) / 2, ym + 0.95), [MV/LV])
  qpair((x-mv + lv-in) / 2, ym)

  // ── LV feeder: 400/230 V line with DALI metering and loads ──────
  wire((lv-in, ym), (x-end, ym))
  cetz.draw.content((10.3, ym + 0.4), [400/230 V])

  // DALI metering unit: a CT clamp around the LV line (I) + a voltage
  // transformer (V) feeding the box.
  dali(
    "dali",
    (9.1, ym),
    width: 0.55,
    lead: 0.12,
    tail: 0.26,
    box-width: 0.95,
    box-height: 0.5,
    clamp-radius: 0.09,
    tx-radius: 0.1,
    tx-distance: 0.1,
  )

  // LV loads (filled down-arrows).
  for lx in (10.9, 11.5, 12.1) {
    load("ld-" + str(int(lx * 10)), (lx, ym), lead: 0.22, size: 0.3)
  }

  // ── Legend ──────────────────────────────────────────────────────
  let lx = 9.4
  let ly = -1.85
  cetz.draw.line(
    (lx, ly),
    (lx + 0.8, ly),
    mark: (end: ">", fill: black),
    stroke: 0.8pt + black,
  )
  cetz.draw.content((lx + 0.95, ly), anchor: "west", [$Q_1$ TSO to DSO])
  cetz.draw.line(
    (lx + 0.8, ly - 0.42),
    (lx, ly - 0.42),
    mark: (end: ">", fill: black, stroke: 0.8pt + black),
    stroke: (paint: black, thickness: 0.8pt, dash: "dashed"),
  )
  cetz.draw.content((lx + 0.95, ly - 0.42), anchor: "west", [$Q_2$ DSO to TSO])
})
