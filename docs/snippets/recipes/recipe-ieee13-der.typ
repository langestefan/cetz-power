#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// IEEE 13-node test feeder with distributed generation. The substation
// (node 650) feeds the trunk through a voltage regulator; XFM-1 steps
// 634 down to 480 V and the 671–692 tie is a (closed) switch. On top of
// the standard feeder, four DER units tie in through their own
// transformers: a wind park at 646, PV + BESS behind XFM-1 at 634, a
// PV park at 680 and a battery at 675 — all drawn with `plant`.
//
// Buses on the horizontal runs are VERTICAL bars, so the runs tap their
// interiors perpendicularly; the junction buses (632, 671) are
// horizontal, and laterals reach them with one L-bend onto an interior
// tap. No conductor ever lands on a bus end.
#diagram(length: 1.1cm, {
  // Vertical node bus centred at (x, y); horizontal junction bus of
  // half-length `hl` centred at (x, y).
  let vbar(name, x, y, ..rest) = bus(name, (x, y - 0.4), (x, y + 0.4), ..rest)
  let hbar(name, x, y, hl, ..rest) = bus(name, (x - hl, y), (x + hl, y), ..rest)
  let sload(name, p, ..rest) = load(name, p, size: 0.2, lead: 0.12, ..rest)

  hbar("n650", 4.8, 4.2, 0.5, label: (content: [650], anchor: "west"))
  hbar("n632", 4.8, 2.1, 0.7, label: (content: [632], anchor: "south-west"))
  hbar("n671", 4.8, 0, 0.7, label: (content: [671], anchor: "south-west"))
  hbar("n652", 1.9, -2.1, 0.5, label: (content: [652], anchor: "west"))
  hbar("n680", 4.8, -2.1, 0.5, label: (content: [680], anchor: "west"))
  vbar("n646", 0, 2.1, label: (content: [646], anchor: "north"))
  vbar("n645", 2.4, 2.1, label: (content: [645], anchor: "north"))
  vbar("n633", 7.2, 2.1, label: (content: [633], anchor: "north"))
  vbar("n634", 9.6, 2.1, label: (content: [634], anchor: "north"))
  vbar("n611", 0, 0, label: (content: [611], anchor: "north"))
  vbar("n684", 2.4, 0, label: (content: [684], anchor: "north"))
  vbar("n692", 7.2, 0, label: (content: [692], anchor: "north"))
  vbar("n675", 9.6, 0, label: (content: [675], anchor: "north"))

  // ── Substation and trunk ────────────────────────────────────────
  external-grid("src", "n650.mid", size: 0.8)
  transformer(
    "reg",
    "n650.mid",
    "n632.mid",
    radius: 0.22,
    distance: 0.22,
    oltc: true,
    label: (content: [Reg.], anchor: "east", distance: 0.18),
  )
  wire("n632.mid", "n671.mid")
  wire("n671.mid", "n680.mid")

  // ── Laterals ────────────────────────────────────────────────────
  // Straight runs tap the vertical bars at their mid height; the
  // junction buses are reached with one L-bend onto an interior tap.
  wire((0, 2.1), (2.4, 2.1)) // 646 – 645
  elbow((2.4, 2.3), bus-frac("n632", 0.25)) // 645 – 632
  elbow(bus-frac("n632", 0.75), (7.2, 2.3), corner: "v") // 632 – 633
  transformer(
    "xfm1",
    (7.2, 2.1),
    (9.6, 2.1),
    radius: 0.2,
    distance: 0.18,
    label: (content: [XFM-1], anchor: "north", distance: 0.16),
  )
  wire((0, 0), (2.4, 0)) // 611 – 684
  elbow((2.4, 0.25), bus-frac("n671", 0.25)) // 684 – 671
  wire(bus-frac("n671", 0.75), (5.15, 0.25)) // 671 – switch stub
  switch("sw", (5.15, 0.25), (6.5, 0.25), closed: true)
  wire((6.5, 0.25), (7.2, 0.25)) // switch – 692
  wire((7.2, 0), (9.6, 0)) // 692 – 675
  elbow((2.4, -0.2), bus-frac("n652", 0.5), corner: "h") // 684 – 652

  // ── Spot loads (elbowed off the vertical bars) ──────────────────
  sload("l646", (0, 1.85), elbow: 0.4)
  sload("l645", (2.4, 1.85), elbow: 0.4)
  sload("l634", (9.6, 1.85), elbow: 0.4)
  sload("l611", (0, -0.25), elbow: 0.4)
  sload("l692", (7.2, -0.25), elbow: 0.4)
  sload("l675", (9.6, -0.25), elbow: 0.4)
  sload("l671", bus-frac("n671", 0.65))
  sload("l652", bus-frac("n652", 0.3))

  // ── DER units (each behind its own transformer) ─────────────────
  // Wind park west of 646.
  transformer("twind", (0, 2.3), (-1.2, 2.3), radius: 0.2, distance: 0.18)
  plant(
    "wind",
    (-1.75, 2.3),
    kind: "wind3",
    label: (content: [Wind park], anchor: "north", distance: 0.16),
  )
  wire((-1.2, 2.3), "wind.east")

  // PV + battery on the 480 V bus behind XFM-1.
  wire((9.6, 2.3), (10.05, 2.3))
  plant(
    "der634",
    (10.75, 2.3),
    kind: "pv-bess2",
    label: (content: [PV + BESS], anchor: "south", distance: 0.16),
  )

  // Battery east of 675.
  transformer("tbess", (9.6, 0.25), (10.8, 0.25), radius: 0.2, distance: 0.18)
  plant(
    "bess",
    (11.35, 0.25),
    kind: "bess2",
    label: (content: [BESS], anchor: "south", distance: 0.16),
  )
  wire((10.8, 0.25), "bess.west")

  // PV park below 680.
  transformer("tpv", "n680.mid", (4.8, -3.3), radius: 0.2, distance: 0.18)
  plant(
    "pvpark",
    (4.8, -3.75),
    kind: "pv3",
    label: (content: [PV park], anchor: "south", distance: 0.16),
  )
  wire((4.8, -3.3), "pvpark.north")
})
