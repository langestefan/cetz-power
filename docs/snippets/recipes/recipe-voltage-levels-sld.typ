#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figure 2.2 (Phase to Phase) redrawn as a single-line diagram: every
// voltage is its own row of busbars, so a station's height reads off
// its voltage. Same topology as recipe-voltage-levels.
#diagram({
  // ── Rows, classes and columns ─────────────────────────────────
  // Rows within a class are `gap` apart; the gap between two classes
  // is `wide`, leaving room for a dashed boundary line above the
  // transformers that sit in it.
  let gap = 0.75
  let wide = 1.15
  let classes = (
    ([EHV], ("380", "220")),
    ([HV], ("150", "110")),
    ([IV], ("50", "25")),
    ([MV], ("20", "10")),
    ([LV], ("0,4",)),
  )
  let kvs = classes.map(c => c.last()).flatten()
  let Y = (:)
  let bounds = () // y of each class boundary, top to bottom
  let y = 0
  for (i, (_, rows)) in classes.enumerate() {
    if i > 0 {
      y -= wide
      // Midway between a transformer body's top (0.615 above its
      // bus) and the bar above.
      bounds.push(y + (0.615 + wide) / 2)
    }
    for (j, kv) in rows.enumerate() {
      if j > 0 { y -= gap }
      Y.insert(kv, y)
    }
  }

  // Everything black except the 0,4 kV level in grey.
  let lv = rgb("#8c8c8c")
  let paint(kv) = if kv == "0,4" { lv } else { black }

  let w = 0.7pt
  let pitch = 1.2 // column pitch
  let X(c) = c * pitch // column → x
  let half = 0.35 // half-length of a single-station bar
  let over = 0.3 // overshoot of a shared bar past its outer taps

  // A bar on row `kv` carrying the given columns: centred on a single
  // column, or fitted over several with a symmetric overshoot.
  let bar(name, kv, ..cs) = {
    let cs = cs.pos()
    let st = 1.8pt + paint(kv)
    if cs.len() == 1 {
      let x = X(cs.first())
      bus(name, (x - half, Y.at(kv)), (x + half, Y.at(kv)), stroke: st)
    } else {
      bus(name, fit: cs.map(c => (X(c), Y.at(kv))), over: over, stroke: st)
    }
  }
  // Vertical link from row `a` down to row `b` in column c: a plain
  // conductor to the row gap above `b`, then the transformer in that
  // gap, so every transformer sits just above the voltage it supplies.
  let tx(c, a, b) = {
    let (x, top) = (X(c), Y.at(b) + gap)
    if Y.at(a) > top { wire((x, Y.at(a)), (x, top), stroke: w + paint(a)) }
    transformer(
      "t" + a + "-" + b + "-" + str(int(c * 10)), // names can't hold '.'
      (x, top),
      (x, Y.at(b)),
      radius: 0.16,
      distance: 0.16,
      primary-stroke: w + paint(a),
      secondary-stroke: w + paint(b),
    )
  }

  // MV stations, one column each, with their feeding level.
  let stations = (
    ("110", "10"),
    ("50", "10"),
    ("25", "10"),
    ("150", "20"),
    ("150", "10"),
    ("110", "20"),
    ("110", "10"),
    ("220", "20"),
  )

  // ── Conductors and transformers (drawn under the bars) ─────────
  // Half columns put a feed midway between the stations it serves.
  tx(4.5, "380", "220")
  tx(0, "380", "110")
  tx(2.5, "380", "150")
  tx(5.5, "220", "110")
  tx(1, "150", "50")
  tx(2, "150", "25")
  for (c, (up, kv)) in stations.enumerate() {
    tx(c, up, kv)
    tx(c, kv, "0,4")
    load("l" + str(c), (X(c), Y.at("0,4")), stroke: w + lv, fill: lv)
  }

  // ── Busbars ────────────────────────────────────────────────────
  bar("b380", "380", 0, 2.5, 4.5)
  bar("b220", "220", 4.5, 5.5, 7)
  bar("b150", "150", 1, 2, 2.5, 3, 4)
  bar("b110a", "110", 0)
  bar("b110b", "110", 5, 5.5, 6)
  bar("b50", "50", 1)
  bar("b25", "25", 2)
  for (c, (_, kv)) in stations.enumerate() {
    bar("mv" + str(c), kv, c)
    bar("lv" + str(c), "0,4", c)
  }

  // ── Voltage scale (left) ───────────────────────────────────────
  for kv in kvs {
    cetz.draw.content(
      (-0.6, Y.at(kv)),
      anchor: "east",
      text(fill: paint(kv))[#kv kV],
    )
  }

  // ── Level classes (right) and dashed boundaries ──────────────
  // Each class gets a bracket ending on its boundary lines; the
  // dashed lines run across the drawing between the rows.
  let bx = X(7) + half + 0.5
  let edges = (Y.at("380") + 0.2, ..bounds, Y.at("0,4") - 0.2)
  for (i, (name, _)) in classes.enumerate() {
    let (y1, y2) = (edges.at(i) - 0.06, edges.at(i + 1) + 0.06)
    cetz.draw.line(
      (bx - 0.12, y1),
      (bx, y1),
      (bx, y2),
      (bx - 0.12, y2),
      stroke: 0.5pt + gray,
    )
    cetz.draw.content((bx + 0.15, (y1 + y2) / 2), anchor: "west", name)
  }
  for b in bounds {
    cetz.draw.line(
      (-1.4, b),
      (bx - 0.12, b),
      stroke: (paint: gray, thickness: 0.5pt, dash: "dashed"),
    )
  }

  // ── Transmission / distribution split (one shared x) ───────────
  // Transmission spans EHV–IV, distribution MV–LV; the split falls
  // on the IV/MV boundary.
  let ax = bx + 0.85
  let split = bounds.at(2)
  let arrow = 1.2pt + black
  for (top, bot, body) in (
    (Y.at("380") + 0.3, split + 0.12, [Transmission]),
    (split - 0.12, Y.at("0,4") - 0.3, [Distribution]),
  ) {
    flow-arrow((ax, (top + bot) / 2), (ax, top), stroke: arrow)
    flow-arrow((ax, (top + bot) / 2), (ax, bot), stroke: arrow)
    // Rotated to read along the shaft; the text's top edge faces it.
    cetz.draw.content(
      (ax + 0.12, (top + bot) / 2),
      angle: 90deg,
      anchor: "north",
      body,
    )
  }
})
