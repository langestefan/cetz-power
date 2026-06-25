#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// Figure 3.6: the modified CIGRE LV network. External grid → S2 → MV bus →
// 11/0.4 kV 250 kVA transformer → LV bus, feeding three radial 400 V
// feeders: residential (R1–R13), industrial (I1), commercial (C1–C14).
#diagram(length: 1cm, {
  // ── Layout constants ────────────────────────────────────────────
  let by = 6.0                  // LV bus
  let rx = -4.6                 // residential main line
  let cx = 2.7                  // commercial main line
  let xm = (rx + cx) / 2        // industrial / transformer = LV-bus centre
  let H  = 4.2                  // feeder height: LV bus → terminal base
  let rs = H / 8                // residential vertical step (8 hops to the end)
  let cs = H / 7                // commercial vertical step (7 hops)
  let rh = 0.72                 // residential horizontal step
  let ch = 0.72                 // commercial horizontal step
  let cd = 0.6                  // drop-node depth (a 30 m branch tap)
  let al = 0.4                  // load-arrow lead (gap from node to arrow)
  let ybot = by - H             // common feeder terminal level
  let ytxt = ybot - 1.0         // network-description text baseline

  // ── Helpers ─────────────────────────────────────────────────────
  let dot(p) = cetz.draw.circle(p, radius: 0.05, fill: black)
  let nl(p, c, s) = note(p, text(size: 6pt)[#c], side: s, distance: 0.16)
  // distance label at a segment midpoint; on a vertical segment (side
  // east/west) the text is rotated to run along the line.
  let dl(a, b, c, s) = note((a, 50%, b),
    if s == "east" or s == "west" { rotate(-90deg, reflow: true, c) } else { c },
    side: s, distance: 0.04, size: 5pt)
  let seg(a, b) = wire(a, b)
  // directional load arrow (0 down, 90 right, -90 left)
  let ld(name, p, ang, fill: black, lead: al) = load(name, p, angle: ang * 1deg,
    lead: lead, size: 0.16, fill: fill)
  // thin PV panel (0 down, -90 left, 90 right)
  let pv(name, p, ang) = pv-panel(name, p, angle: ang * 1deg, size: 0.2,
    aspect: 1.7, lead: 0.16)
  // a tapped node (circle) `cd` below `parent`, carrying a load arrow
  let drop(name, parent, dlab, dside, lbl, lside, ang: 0, fill: black) = {
    let n = (rel: (0, -cd), to: parent)
    seg(parent, n); dl(parent, n, dlab, dside); dot(n); nl(n, lbl, lside)
    ld(name, n, ang, fill: fill)
  }

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
  cetz.draw.content((rx + 1.9, by + 0.2), anchor: "south", text(size: 9pt)[LV Bus])
  cetz.draw.content((1.6, by + 0.2), anchor: "south", [400V])

  // ── Industrial feeder: 100 m down to the I1 node, then a load ──
  let i1 = (xm, ybot + al)
  seg((xm, by), i1)
  dl((xm, by), i1, [100 m], "west")
  dot(i1); nl(i1, [I1], "west")
  ld("li1", i1, 0)
  cetz.draw.content((xm, ytxt), align(center)[400V line to line \ industrial network])

  // ── Residential feeder (R1–R13) ─────────────────────────────────
  let R = i => (rx, by - i * rs)
  seg((rx, by), R(1)); dl((rx, by), R(1), [35m], "east")
  for i in range(1, 7) {
    seg(R(i), R(i + 1)); dl(R(i), R(i + 1), [35m], "east"); dot(R(i))
  }
  dot(R(7))
  ld("lr7", R(7), 0, lead: rs); dl(R(7), (rx, ybot), [35m], "east")
  nl(R(1), [R1], "west"); nl(R(2), [R2], "east"); nl(R(3), [R3], "west")
  nl(R(4), [R4], "west"); nl(R(5), [R5], "east"); nl(R(6), [R6], "west")
  nl(R(7), [R7], "west")
  ld("lr1", R(1), 90)
  // R2 → R8 (left): a left load plus a rooftop PV panel
  let R8 = (rx - rh, by - 2 * rs)
  seg(R(2), R8); dl(R(2), R8, [30m], "north"); dot(R8); nl(R8, [R8], "north")
  ld("lr8", R8, -90); pv("pvr8", R8, 0)
  // R3 → R9 → R10 → R11 (right); R9 PV; R11 → R12 (down)
  let R9 = (rx + rh, by - 3 * rs)
  let R10 = (rx + 2 * rh, by - 3 * rs)
  let R11 = (rx + 3 * rh, by - 3 * rs)
  seg(R(3), R9); dl(R(3), R9, [35m], "north"); dot(R9); nl(R9, [R9], "north"); pv("pvr9", R9, 0)
  seg(R9, R10); dl(R9, R10, [35m], "north"); dot(R10); nl(R10, [R10], "north")
  seg(R10, R11); dl(R10, R11, [35m], "north"); dot(R11); nl(R11, [R11], "north")
  drop("lr12", R11, [30m], "east", [R12], "east")
  // R5 → R13 (left): a left load
  let R13 = (rx - rh, by - 5 * rs)
  seg(R(5), R13); dl(R(5), R13, [30m], "north"); dot(R13); nl(R13, [R13], "north")
  ld("lr13", R13, -90)
  cetz.draw.content((rx + 0.7, ytxt), align(center)[400V line to line \ residential network])

  // ── Commercial feeder (C1–C14) ──────────────────────────────────
  let C = i => (cx, by - i * cs)
  seg((cx, by), C(1)); dl((cx, by), C(1), [30m], "east")
  for i in range(1, 6) {
    seg(C(i), C(i + 1)); dl(C(i), C(i + 1), [30m], "east"); dot(C(i))
  }
  dot(C(6))
  ld("lc6b", C(6), 0, lead: cs); dl(C(6), (cx, ybot), [30m], "east")
  nl(C(1), [C1], "west"); nl(C(2), [C2], "east"); nl(C(3), [C3], "east")
  nl(C(4), [C4], "west"); nl(C(5), [C5], "west"); nl(C(6), [C6], "east")
  pv("pvc6", C(6), -90)   // PV to the left of C6
  // C2 → C7 → C8 (left); C7 → C10, C8 → C9 (down)
  let C7 = (cx - ch, by - 2 * cs)
  let C8 = (cx - 2 * ch, by - 2 * cs)
  seg(C(2), C7); dl(C(2), C7, [30m], "north"); dot(C7); nl(C7, [C7], "north")
  seg(C7, C8); dl(C7, C8, [30m], "north"); dot(C8); nl(C8, [C8], "north")
  drop("lc10", C7, [30m], "east", [C10], "east")
  drop("lc9", C8, [30m], "west", [C9], "west")
  // C4 → C11 → C12 (right); C11 → C13 and C12 → C14 (down loads)
  let C11 = (cx + ch, by - 4 * cs)
  let C12 = (cx + 2 * ch, by - 4 * cs)
  seg(C(4), C11); dl(C(4), C11, [30m], "north"); dot(C11); nl(C11, [C11], "north")
  seg(C11, C12); dl(C11, C12, [30m], "north"); dot(C12); nl(C12, [C12], "north")
  drop("lc13", C11, [30m], "east", [C13], "west")
  drop("lc14", C12, [30m], "east", [C14], "west")
  cetz.draw.content((cx, ytxt), align(center)[400V line to line \ commercial network])
})
