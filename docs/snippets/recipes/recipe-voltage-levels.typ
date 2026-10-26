#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figure 2.2: Voltage levels (Phase to Phase, "Electrical power
// system essentials", chapter 2). The Dutch grid as a ladder of
// voltage-level boxes joined by transformers, all black except the
// 0,4 kV level in grey.
#diagram({
  // Pixel map of the 1372 × 1054 px source figure (origin top-left).
  let P = pixel-map(0.012, height: 1054)

  let lv = rgb("#8c8c8c") // the 0,4 kV level; everything else is black

  let w = 0.7pt
  let side = 87 * 0.012 // voltage boxes are 87 px squares

  // A voltage-level box. Wires are drawn first so the box edge sits
  // on top of each lead root.
  let level(name, x, y, body, paint: black) = block(
    name,
    P(x, y),
    body: body,
    width: side,
    height: side,
    stroke: 1.4pt + paint,
  )
  // Transformer between two points; `a` is the upper (primary) end.
  let tx(name, a, b, lower: black) = transformer(
    name,
    a,
    b,
    radius: 0.2,
    distance: 0.2,
    stroke: w,
    secondary-stroke: w + lower,
  )
  let ln(..pts) = wire(..pts, stroke: w)

  // Column x positions (px) and the MV/LV rows beneath them.
  let cols = (45, 183, 321, 459, 562, 700, 804, 959)
  let mv-kv = ("10", "10", "10", "20", "10", "20", "10", "20")

  // ── Conductors and transformers ────────────────────────────────
  // 380 kV ⇄ 220 kV coupling and the two EHV corner runs.
  tx("t380-220", P(365, 44), P(709, 44))
  ln(P(278, 44), P(45, 44))
  tx("t380-110", P(45, 44), P(45, 226))
  tx("t380-150", P(321, 88), P(321, 226))
  tx("t220-110", P(752, 88), P(752, 226))
  ln(P(795, 44), P(959, 44))
  tx("t220-20", P(959, 44), P(959, 710))

  // 110 kV (left) straight down to its 10 kV station.
  tx("t110-10", P(45, 313), P(45, 710))

  // 150 kV: intermediate levels west and below, two MV feeds east.
  ln(P(278, 269), P(183, 269))
  tx("t150-50", P(183, 269), P(183, 433))
  tx("t150-25", P(321, 313), P(321, 433))
  ln(P(365, 269), P(562, 269))
  tx("t150-20", P(459, 269), P(459, 710))
  tx("t150-10", P(562, 269), P(562, 710))
  tx("t50-10", P(183, 520), P(183, 710))
  tx("t25-10", P(321, 520), P(321, 710))

  // 110 kV (right): one drop splitting into two MV feeds.
  ln(P(752, 313), P(752, 390))
  ln(P(700, 390), P(804, 390))
  tx("t110-20", P(700, 390), P(700, 710))
  tx("t110-10b", P(804, 390), P(804, 710))

  // Every MV station feeds one LV network.
  for x in cols { tx("tlv" + str(x), P(x, 797), P(x, 951), lower: lv) }

  // ── Voltage-level boxes ───────────────────────────────────────
  level("b380", 321, 44, [380 kV])
  level("b220", 752, 44, [220 kV])
  level("b110a", 45, 269, [110 kV])
  level("b150", 321, 269, [150 kV])
  level("b110b", 752, 269, [110 kV])
  level("b50", 183, 476, [50 kV])
  level("b25", 321, 476, [25 kV])
  for (i, x) in cols.enumerate() {
    level("mv" + str(i), x, 753, [#mv-kv.at(i) kV])
    level("lv" + str(i), x, 994, [0,4 kV], paint: lv)
  }

  // ── Level names and the transmission / distribution split ─────
  for (y, name) in (
    (42, [Extra High-voltage]),
    (265, [High-voltage]),
    (474, [Intermediate-voltage]),
    (752, [Medium-voltage]),
    (991, [Low-voltage]),
  ) {
    cetz.draw.content(P(1028, y), anchor: "west", name)
  }

  let frame(name, y, body) = block(
    name,
    P(1279, y),
    body: body,
    width: 180 * 0.012,
    height: 72 * 0.012,
    stroke: w,
  )
  frame("trans", 601, [Transmission])
  frame("dist", 874, [Distribution])
  let arrow = 1.6pt + black
  flow-arrow(P(1322, 565), P(1322, 5), stroke: arrow)
  flow-arrow(P(1322, 637), P(1322, 767), stroke: arrow)
  flow-arrow(P(1345, 838), P(1345, 740), stroke: arrow)
  flow-arrow(P(1345, 910), P(1345, 1052), stroke: arrow)
})
