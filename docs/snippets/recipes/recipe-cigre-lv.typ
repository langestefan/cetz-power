#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// Figure 3.6: the modified CIGRE LV network. External grid → S2 → MV bus →
// 11/0.4 kV 250 kVA transformer → LV bus, feeding three radial 400 V
// feeders: residential (R1–R13), industrial (I1), commercial (C1–C14).
#diagram(length: 1cm, {
  // ── Layout constants ────────────────────────────────────────────
  let (by, rx, cx) = (6.0, -4.6, 2.7) // LV-bus y; residential / commercial x
  let xm = (rx + cx) / 2 // industrial / transformer = LV-bus centre
  let H = 4.2 // feeder height (LV bus → terminal)
  let (rs, cs, rh, ch, cd, al) = (H / 8, H / 7, 0.72, 0.72, 0.6, 0.4)
  let ybot = by - H
  let ytxt = ybot - 1.0
  let (down, right, left) = ((0, -1), (1, 0), (-1, 0))

  // ── Helpers ─────────────────────────────────────────────────────
  let dot(p) = cetz.draw.circle(p, radius: 0.05, fill: black)
  let nl(p, c, s) = note(p, text(size: 6pt)[#c], side: s, distance: 0.16)
  // length label — the segment form turns east/west labels upright itself
  let dl(a, b, c, s) = note(a, b, c, side: s, distance: 0.04, size: 5pt)
  let seg = wire
  let ld(name, p, ang, lead: al) = load(
    name,
    p,
    angle: ang * 1deg,
    lead: lead,
    size: 0.16,
  )
  let pv(name, p, ang) = pv-panel(
    name,
    p,
    angle: ang * 1deg,
    size: 0.2,
    aspect: 1.7,
    lead: 0.16,
  )
  // `n` node coordinates a `step` apart from `start` along unit vector `dir`.
  let nodes(start, n, step, dir) = range(1, n + 1).map(k => (
    rel: (k * step * dir.at(0), k * step * dir.at(1)),
    to: start,
  ))
  // draw a line start→pts: per hop a segment (length `dist` on `dside`), a
  // dot, and the node label `names.at(i)` on `sides.at(i)`.
  let chain(start, pts, dist, names, sides, dside: "east") = {
    let prev = start
    for (i, p) in pts.enumerate() {
      seg(prev, p)
      dl(prev, p, dist, dside)
      dot(p)
      nl(p, names.at(i), sides.at(i))
      prev = p
    }
  }
  // a load tapped on a node-circle a 30 m branch below `parent`.
  let drop(name, parent, lbl, lside) = {
    let n = (rel: (0, -cd), to: parent)
    seg(parent, n)
    dl(parent, n, [30m], "east")
    dot(n)
    nl(n, lbl, lside)
    ld(name, n, 0)
  }
  let netlabel(x, net) = cetz.draw.content((x, ytxt), align(
    center,
  )[400V line to line \ #net network])

  // ── Top: external grid → S2 → MV bus → transformer → LV bus ─────
  external-grid("grid", (xm, 8.3), size: 0.9)
  cetz.draw.content((xm, 9.7), [External grid])
  seg((xm, 8.3), (xm, 8.0))
  switch("s2", (xm, 8.0), (xm, 7.6))
  nl((xm + 0.12, 7.8), [S2], "east")
  seg((xm, 7.6), (xm, 7.3))
  bus("mv", (xm - 0.85, 7.3), (xm + 0.85, 7.3))
  nl((xm - 0.85, 7.3), [MV Bus], "west")
  nl((xm + 0.85, 7.3), [11kV], "east")
  transformer("tr", (xm, 7.0), (xm, 6.3), radius: 0.22, distance: 0.24)
  seg((xm, 7.3), (xm, 7.0))
  cetz.draw.content((xm + 0.42, 6.65), anchor: "west", [11/0.4 kV \ 250 kVA])
  seg((xm, 6.3), (xm, by))

  // ── LV bus ──────────────────────────────────────────────────────
  bus("lv", (rx - 0.2, by), (cx + 0.2, by))
  cetz.draw.content((rx + 1.9, by + 0.2), anchor: "south", text(
    size: 9pt,
  )[LV Bus])
  cetz.draw.content((1.6, by + 0.2), anchor: "south", [400V])

  // ── Residential feeder ──────────────────────────────────────────
  let R = nodes((rx, by), 7, rs, down)
  chain(
    (rx, by),
    R,
    [35m],
    range(1, 8).map(i => [R#i]),
    ("west", "east", "west", "west", "east", "west", "west"),
  )
  ld("lr1", R.first(), 90)
  ld("lr7", R.last(), 0, lead: rs)
  dl(R.last(), (rel: (0, -rs), to: R.last()), [35m], "east")
  let R8 = (rel: (-rh, 0), to: R.at(1))
  seg(R.at(1), R8)
  dl(R.at(1), R8, [30m], "north")
  dot(R8)
  nl(R8, [R8], "north")
  ld("lr8", R8, -90)
  let Rb = nodes(R.at(2), 3, rh, right)
  chain(
    R.at(2),
    Rb,
    [35m],
    range(9, 12).map(i => [R#i]),
    ("north",) * 3,
    dside: "north",
  )
  drop("lr12", Rb.last(), [R12], "east")
  let R13 = (rel: (-rh, 0), to: R.at(4))
  seg(R.at(4), R13)
  dl(R.at(4), R13, [30m], "north")
  dot(R13)
  nl(R13, [R13], "north")
  ld("lr13", R13, -90)
  netlabel(rx + 0.7, [residential])

  // ── Industrial feeder ───────────────────────────────────────────
  let i1 = (xm, ybot + al)
  seg((xm, by), i1)
  dl((xm, by), i1, [100 m], "west")
  dot(i1)
  nl(i1, [I1], "west")
  ld("li1", i1, 0)
  netlabel(xm, [industrial])

  // ── Commercial feeder ───────────────────────────────────────────
  let C = nodes((cx, by), 6, cs, down)
  chain(
    (cx, by),
    C,
    [30m],
    range(1, 7).map(i => [C#i]),
    ("west", "east", "east", "west", "west", "east"),
  )
  ld("lc6", C.last(), 0, lead: cs)
  dl(C.last(), (rel: (0, -cs), to: C.last()), [30m], "east")
  let Cl = nodes(C.at(1), 2, ch, left)
  chain(C.at(1), Cl, [30m], ([C7], [C8]), ("north",) * 2, dside: "north")
  drop("lc10", Cl.at(0), [C10], "east")
  drop("lc9", Cl.at(1), [C9], "west")
  let Cr = nodes(C.at(3), 2, ch, right)
  chain(C.at(3), Cr, [30m], ([C11], [C12]), ("north",) * 2, dside: "north")
  drop("lc13", Cr.at(0), [C13], "west")
  drop("lc14", Cr.at(1), [C14], "west")
  netlabel(cx, [commercial])

  // ── The three rooftop solar panels (hand-placed) ────────────────
  pv("pvr8", R8, 0)
  pv("pvr9", Rb.first(), 0)
  pv("pvc6", C.last(), -90)
})
