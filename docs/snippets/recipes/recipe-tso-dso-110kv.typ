#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// The realistic 110 kV distribution grid of Belz et al. 2024 (e+i 141,
// doi:10.1007/s00502-024-01294-x, Fig. 2): a meshed sub-transmission network
// with 34 stations (S_1..S_34) coupled to the transmission grid at two PCC
// substations, M-Stadt (double busbar) and K-Dorf (single bar, amber tie
// circuits). S_24 and S_14 are the other double-busbar hubs; generation
// plants are the sine circles, neighbouring subsystems leave as arrows.
// Layout is a cleaned-up orthogonal redraw of the figure: bays cross both
// bars of a double busbar with a filled junction on the selected bar and an
// open (hollow) one on the other; couplers are the small breaker loops.
#diagram(length: 1cm, {
  let grn = rgb("#2e8b2e")
  let amber = rgb("#b45f1d")
  let peach = rgb("#f6cfae")
  let wstroke = 0.8pt + grn

  // Pixel map of the source figure (1999 x 1624 px, y down).
  let s = 0.008
  let H = 1624
  let P = pixel-map(s, height: H)

  cetz.draw.set-style(cetz-power: (
    stroke: wstroke,
    wire: (stroke: wstroke),
    bus: (stroke: 1.7pt + grn),
    junction: (stroke: wstroke, radius: 0.055),
    load: (stroke: wstroke, fill: white, size: 0.16, lead: 0.22),
    voltagesource: (stroke: wstroke, radius: 0.17),
    machine: (stroke: wstroke, radius: 0.17),
    breaker: (stroke: wstroke, size: 0.12),
    ground: (stroke: wstroke),
  ))

  // ── Helpers ─────────────────────────────────────────────────────
  let nl(p, c, sd) = note(p, text(size: 6.5pt)[#c], side: sd, distance: 0.12)
  let sub(p, sd) = note(
    p,
    text(size: 6pt, style: "italic")[Subsystem],
    side: sd,
    distance: 0.1,
  )
  let dot(x, y) = junction("j" + str(x) + "-" + str(y), P(x, y))
  let odot(x, y) = junction("o" + str(x) + "-" + str(y), P(x, y), open: true)
  // double-busbar bay marks: filled junction on the selected bar, open on
  // the other (the bay wire itself is drawn by the caller).
  let jpair(x, ya, yb, sel) = {
    junction("ja" + str(x) + "-" + str(ya), P(x, ya), open: sel != "a")
    junction("jb" + str(x) + "-" + str(yb), P(x, yb), open: sel != "b")
  }
  // bar-to-bar coupler: the left leg connects the top bar, the right leg
  // the bottom bar (crossing the other bar), with a breaker in the bridge.
  let coupler(name, xa, xb, ya, yb, yc) = {
    wire(P(xa, ya), P(xa, yc), P(xb, yc), P(xb, yb))
    breaker(name, P((xa + xb) / 2, yc))
  }
  let farrow(a, b) = flow-arrow(a, b, stroke: wstroke)

  // ── PCC area boxes + titles (backdrops first) ───────────────────
  area("ms-box", P(815, 300), P(1560, 105), stroke: none, fill: peach)
  area("kd-box", P(150, 1600), P(1100, 1415), stroke: none, fill: peach)
  cetz.draw.content(P(1188, 152), text(size: 9pt, weight: "bold")[M-Stadt])
  cetz.draw.content(P(430, 1548), text(size: 9pt, weight: "bold")[K-Dorf])
  cetz.draw.content(
    P(770, 195),
    anchor: "east",
    text(size: 11pt, weight: "bold")[PCC],
  )
  cetz.draw.content(
    P(120, 1478),
    anchor: "east",
    text(size: 11pt, weight: "bold")[PCC],
  )

  // ── Conductors (wires first: bars later cover the bay roots) ────
  // M-Stadt feeders, left to right.
  wire(P(860, 205), P(860, 330), P(820, 330)) // S_30 plant bay
  wire(P(930, 205), P(930, 460)) // feeder A -> S_29 upper bar
  cetz.draw.line(P(905, 460), P(905, 520), stroke: (
    paint: grn,
    thickness: 0.8pt,
    dash: "dashed",
  )) // S_29 open link (netopening)
  wire(P(930, 520), P(930, 700), P(820, 700), P(820, 818)) // S_29 -> S_27 -> S_24
  wire(P(930, 627), P(888, 627)) // S_27 plant tap
  wire(P(1000, 205), P(1000, 700), P(1075, 700), P(1075, 818)) // feeder B -> S_31/S_28 -> S_24
  wire(P(1000, 390), P(1040, 390)) // S_31 plant tap
  wire(P(1000, 575), P(960, 575)) // S_28 tap
  wire(P(1170, 205), P(1170, 1045), P(1410, 1045), P(1410, 1178)) // feeder C -> S_14
  wire(P(1170, 545), P(1130, 545)) // S_34 tap
  wire(P(1230, 205), P(1230, 465)) // feeder D -> S_32/S_33 spur
  wire(P(1230, 380), P(1350, 380)) // -> S_32
  wire(P(1230, 465), P(1350, 465)) // -> S_33
  wire(P(1390, 205), P(1390, 1075), P(1745, 1075), P(1745, 1178)) // feeder E -> S_14
  // feeder F: M-Stadt -> S_1 -> riser -> S_2/S_3/S_4 cluster
  wire(
    P(1460, 205),
    P(1460, 318),
    P(1880, 318),
    P(1880, 135),
    P(1570, 135),
    P(1570, 45),
  )
  wire(P(1645, 135), P(1645, 210)) // -> S_3
  wire(P(1830, 135), P(1830, 210)) // -> S_2
  wire(P(1695, 258), P(1695, 318)) // S_1 west drop
  wire(P(1780, 258), P(1780, 360)) // S_1 east drop -> S_9/S_10 line
  wire(P(1610, 780), P(1610, 360), P(1905, 360), P(1905, 845)) // S_11 <- line -> S_6
  wire(P(1610, 520), P(1680, 520)) // S_10 taps
  wire(P(1610, 635), P(1680, 635))
  wire(P(1905, 455), P(1865, 455)) // S_9 plant tap
  wire(P(1905, 645), P(1865, 645)) // S_8 plant tap
  wire(P(1905, 740), P(1865, 740)) // S_7 plant tap
  wire(P(1640, 45), P(1640, 90), P(1925, 90), P(1925, 45)) // S_4 -> S_5
  wire(P(1965, 45), P(1965, 845)) // S_5 -> S_6

  // S_11 -> S_12 double link, S_12 -> S_14 twin drops.
  wire(P(1480, 780), P(1480, 940))
  wire(P(1505, 780), P(1505, 940))
  wire(P(1530, 940), P(1530, 1178))
  wire(P(1600, 940), P(1600, 1178))

  // West ties from S_25/S_26 and S_23.
  wire(P(460, 655), P(1105, 655), P(1105, 818)) // tie 1 -> S_24 right side
  wire(P(460, 745), P(740, 745), P(740, 818)) // tie 2 -> S_24
  wire(P(585, 608), P(585, 655)) // S_26 left drop -> tie 1
  wire(P(665, 608), P(665, 745)) // S_26 right drop -> tie 2 (crosses tie 1)
  wire(P(460, 875), P(713, 875), P(713, 790)) // S_23 -> S_24 south bay

  // S_24 south side: subsystem stubs + long feeders.
  wire(P(880, 818), P(880, 880))
  wire(P(960, 818), P(960, 880))
  wire(P(1040, 818), P(1040, 880))
  wire(P(770, 818), P(770, 1262)) // -> S_21/S_22 run R1
  wire(P(570, 1155), P(570, 1262), P(830, 1262)) // R1: S_22 - S_21a - feeder
  wire(P(690, 1215), P(690, 1262)) // S_21a drop
  wire(P(830, 1215), P(830, 1312)) // S_21b drop (junction onto R1)
  wire(P(600, 1155), P(600, 1312), P(830, 1312)) // R2: S_22 - S_21b

  // S_22 accessories.
  wire(P(625, 1155), P(625, 1060)) // subsystem riser
  wire(P(490, 1155), P(490, 1245)) // plant drop
  // K-Dorf <-> S_22 amber double circuit.
  cetz.draw.line(
    P(250, 1500),
    P(250, 1130),
    P(360, 1130),
    stroke: 0.9pt + amber,
  )
  cetz.draw.line(
    P(290, 1500),
    P(290, 1190),
    P(390, 1190),
    stroke: 0.9pt + amber,
  )
  wire(P(360, 1130), P(430, 1130), P(430, 1155))
  wire(P(390, 1190), P(460, 1190), P(460, 1155))
  wire(P(360, 1130), P(360, 1108)) // subsystem departure at the tie node

  // Bottom-right pair of horizontals into S_18: the top line comes from
  // S_19, the bottom line from K-Dorf (tapped by S_20 on the way).
  wire(P(1445, 1405), P(1445, 1470), P(1700, 1470)) // top line: S_19 -> S_18
  wire(P(1000, 1500), P(1000, 1540), P(1700, 1540)) // bottom: K-Dorf -> S_18
  wire(P(1050, 1385), P(1050, 1540)) // S_20 drops onto the bottom line
  wire(P(1120, 1385), P(1120, 1540))

  // S_19 bays.
  wire(P(1385, 1433), P(1385, 1370)) // subsystem
  wire(P(1505, 1433), P(1505, 1370)) // earthed coil stub

  // S_14 east/south feeders. The twin S_18 drops mirror S_1/S_26: the
  // left vertical lands on the top line, the right one on the bottom line.
  wire(P(1560, 1150), P(1560, 1470)) // -> top line
  wire(P(1630, 1150), P(1630, 1540)) // -> bottom line (crosses the top one)
  wire(P(1665, 1150), P(1665, 1370), P(1900, 1370)) // -> S_16/S_17
  wire(P(1780, 1370), P(1780, 1400)) // S_16 stub
  wire(P(1700, 1150), P(1700, 1290), P(1855, 1290)) // -> S_15 (lower)
  wire(P(1780, 1150), P(1780, 1250), P(1855, 1250)) // -> S_15 (upper)

  // ── Busbars (over the wires, so bars cover the bay roots) ───────
  bus("ms-a", P(830, 205), P(1530, 205))
  bus("ms-b", P(830, 233), P(1530, 233))
  bus("s24-a", P(660, 790), P(1140, 790))
  bus("s24-b", P(660, 818), P(1140, 818))
  bus("s14-a", P(1205, 1150), P(1840, 1150))
  bus("s14-b", P(1205, 1178), P(1840, 1178))
  bus("s19-a", P(1360, 1405), P(1540, 1405))
  bus("s19-b", P(1360, 1433), P(1540, 1433))
  bus("kdorf", P(210, 1500), P(1040, 1500))
  bus("s1", P(1650, 258), P(1830, 258))
  bus("s2", P(1770, 210), P(1895, 210))
  bus("s3", P(1600, 210), P(1700, 210))
  bus("s4", P(1440, 45), P(1680, 45))
  bus("s5", P(1860, 45), P(1990, 45))
  bus("s6", P(1870, 845), P(1990, 845))
  bus("s11", P(1440, 780), P(1650, 780))
  bus("s12", P(1450, 940), P(1660, 940))
  bus("s13", P(1250, 990), P(1360, 990))
  bus("s15", P(1855, 1225), P(1855, 1315))
  bus("s16", P(1745, 1400), P(1815, 1400))
  bus("s17", P(1900, 1340), P(1900, 1400))
  bus("s18", P(1700, 1440), P(1700, 1570))
  bus("s20", P(1015, 1385), P(1155, 1385))
  bus("s21a", P(655, 1215), P(720, 1215))
  bus("s21b", P(795, 1215), P(860, 1215))
  bus("s22", P(400, 1155), P(640, 1155))
  bus("s23", P(460, 850), P(460, 1000))
  bus("s25", P(460, 600), P(460, 780))
  bus("s26", P(545, 608), P(710, 608))
  bus("s28", P(960, 545), P(960, 605))
  bus("s29a", P(878, 460), P(960, 460))
  bus("s29b", P(878, 520), P(960, 520))
  bus("s32", P(1350, 350), P(1350, 410))
  bus("s33", P(1350, 435), P(1350, 495))
  bus("s34", P(1130, 515), P(1130, 575))

  // S_13 twin drops onto S_14 (drawn after the bus so the roots read).
  wire(P(1280, 990), P(1280, 1178))
  wire(P(1330, 990), P(1330, 1178))

  // ── Couplers ────────────────────────────────────────────────────
  coupler("cp-ms", 1040, 1090, 205, 233, 268) // below the M-Stadt bars
  coupler("cp-s24", 935, 985, 790, 818, 758) // above the central S_24 arrow
  coupler("cp-s14", 1480, 1508, 1150, 1178, 1118) // above the S_14 bars
  breaker("br-l1", P(1480, 860)) // S_11 -> S_12 link breakers
  breaker("br-l2", P(1505, 860))

  // ── Junctions (after wires + bars: they mask what is beneath) ───
  // Double-busbar bay pairs.
  for (x, sel) in (
    (860, "b"),
    (930, "a"),
    (1000, "b"),
    (1170, "a"),
    (1230, "b"),
    (1390, "a"),
    (1460, "b"),
  ) {
    jpair(x, 205, 233, sel)
  }
  for (x, sel) in (
    (713, "a"),
    (740, "b"),
    (770, "a"),
    (820, "b"),
    (880, "a"),
    (960, "b"),
    (1040, "a"),
    (1075, "b"),
    (1105, "a"),
  ) {
    jpair(x, 790, 818, sel)
  }
  for (x, sel) in (
    (1240, "a"),
    (1280, "b"),
    (1330, "a"),
    (1370, "b"),
    (1410, "a"),
    (1530, "b"),
    (1560, "a"),
    (1600, "b"),
    (1630, "a"),
    (1665, "b"),
    (1700, "a"),
    (1745, "b"),
    (1780, "a"),
    (1810, "b"),
  ) {
    jpair(x, 1150, 1178, sel)
  }
  for (x, sel) in ((1385, "a"), (1445, "b"), (1505, "a")) {
    jpair(x, 1405, 1433, sel)
  }
  // T-taps and terminals.
  dot(930, 627)
  dot(1000, 390)
  dot(1000, 575)
  dot(1170, 545)
  dot(1230, 380)
  dot(1645, 135)
  dot(1830, 135)
  dot(1695, 318)
  dot(1780, 360)
  dot(1610, 520)
  dot(1610, 635)
  dot(1905, 455)
  dot(1905, 645)
  dot(1905, 740)
  dot(585, 655)
  dot(665, 745)
  dot(690, 1262)
  dot(770, 1262)
  dot(830, 1262)
  dot(1480, 780)
  dot(1505, 780)
  dot(1480, 940)
  dot(1505, 940)
  dot(1530, 940)
  dot(1600, 940)
  dot(1050, 1540)
  dot(1120, 1540)
  dot(1560, 1470)
  dot(1630, 1540)
  dot(1780, 1370)
  dot(560, 1500)
  // Open points (netopenings) on single bars.
  odot(905, 520)
  odot(460, 672)
  odot(460, 940)
  odot(625, 608)

  // ── Plants, ground, loads ───────────────────────────────────────
  voltagesource("vs30", P(800, 330), kind: "sin")
  voltagesource("vs27", P(868, 627), kind: "sin")
  voltagesource("vs31", P(1060, 390), kind: "sin")
  voltagesource("vs9", P(1845, 455), kind: "sin")
  voltagesource("vs8", P(1845, 645), kind: "sin")
  voltagesource("vs7", P(1845, 740), kind: "sin")
  voltagesource("vs22", P(490, 1262), kind: "sin")
  machine("g22", P(540, 1105), "G")
  wire("g22.south", P(540, 1155))
  ground("gnd19", P(1505, 1370), angle: 180deg)
  load("l14a", P(1240, 1178))
  load("l14b", P(1370, 1178))
  load("l14c", P(1810, 1178))
  load("l4", P(1515, 45))

  // ── Subsystem departures ────────────────────────────────────────
  farrow(P(1680, 520), P(1755, 520)) // S_10
  farrow(P(1680, 635), P(1755, 635))
  farrow(P(460, 625), P(385, 625)) // S_25
  farrow(P(460, 715), P(385, 715))
  farrow(P(585, 608), P(585, 530)) // S_26
  farrow(P(665, 608), P(665, 530))
  farrow(P(460, 905), P(385, 905)) // S_23
  farrow(P(460, 975), P(385, 975))
  farrow(P(880, 880), P(880, 940)) // S_24
  farrow(P(960, 880), P(960, 940))
  farrow(P(1040, 880), P(1040, 940))
  farrow(P(625, 1060), P(625, 1005)) // S_22
  farrow(P(360, 1108), P(425, 1108))
  farrow(P(1385, 1370), P(1385, 1325)) // S_19
  sub(P(385, 625), "west")
  sub(P(960, 940), "south")
  sub(P(625, 1005), "north")

  // ── Station labels ──────────────────────────────────────────────
  nl(P(1740, 258), [S_1], "south")
  nl(P(1832, 210), [S_2], "south")
  nl(P(1650, 210), [S_3], "south")
  nl(P(1440, 45), [S_4], "west")
  nl(P(1925, 45), [S_5], "north")
  nl(P(1930, 845), [S_6], "south")
  note("vs7.west", [S_7], side: "west", distance: 0.12)
  note("vs8.west", [S_8], side: "west", distance: 0.12)
  note("vs9.north", [S_9], side: "north", distance: 0.12)
  cetz.draw.content(P(1718, 578), text(size: 6.5pt)[S_10])
  nl(P(1440, 780), [S_11], "west")
  nl(P(1660, 940), [S_12], "east")
  nl(P(1305, 990), [S_13], "north")
  cetz.draw.content(P(1505, 1215), text(size: 6.5pt)[S_14])
  nl(P(1855, 1270), [S_15], "east")
  nl(P(1815, 1400), [S_16], "east")
  nl(P(1900, 1370), [S_17], "east")
  nl(P(1700, 1505), [S_18], "east")
  nl(P(1360, 1419), [S_19], "west")
  nl(P(1085, 1385), [S_20], "north")
  nl(P(758, 1215), [S_21], "north")
  nl(P(400, 1155), [S_22], "west")
  nl(P(460, 862), [S_23], "west")
  nl(P(660, 804), [S_24], "west")
  nl(P(460, 780), [S_25], "south")
  nl(P(545, 608), [S_26], "west")
  note("vs27.west", [S_27], side: "west", distance: 0.12)
  nl(P(960, 575), [S_28], "west")
  nl(P(885, 490), [S_29], "west")
  note("vs30.south", [S_30], side: "south", distance: 0.12)
  note("vs31.south", [S_31], side: "south", distance: 0.12)
  nl(P(1350, 380), [S_32], "east")
  nl(P(1350, 465), [S_33], "east")
  nl(P(1130, 575), [S_34], "south")
})
