#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 9pt)

// IEEE nine-bus test system with grid-forming converters (after the
// Monte-Carlo stability case study, Fig. 16 of IEEE 11511791): the
// three machine buses 1–3 carry grid-forming converters GFM 1–3, two
// grid-following converter loads (GFL load 1 at bus 5, GFL load 2 at
// bus 8) tie in through their own transformers, a synchronous
// generator SG shares bus 8, and bus 6 carries a constant-power load.
// Laid out mirror-symmetrically about bus 8 / bus 4: perpendicular
// elbow drops off the rail buses, two double-L feeders off the bottom
// of bus 8, and equal-stub diagonal funnels from buses 5 and 6 into
// bus 4. Every converter faces its AC (≈) triangle toward the grid
// connection: boxes left of their connection are "dc-ac", the rest
// keep the default "ac-dc".
#diagram(length: 1cm, {
  let blu = rgb("#2f5496") // GFM labels
  let red = rgb("#c00000") // GFL / SG labels
  let gfm-fill = rgb("#dbe5f1") // light blue converter interior
  let gfl-fill = rgb("#d9d9d9") // grey converter interior

  let nl(p, c, sd) = note(p, text(size: 8pt)[#c], side: sd, distance: 0.06)
  // Converter block: black lines, tinted interior, coloured caption.
  let conv(name, p, lbl, fill, lbl-fill, kind: "ac-dc") = converter(
    name,
    p,
    kind: kind,
    stroke: 0.9pt + black,
    fill: fill,
    label: (content: text(size: 8pt, fill: lbl-fill)[#lbl], distance: 0.12),
  )

  let y1 = -1.15 // GFL-load-2 / SG row
  let y5 = -1.6 // buses 5 and 6
  let y4 = -3.0 // bus 4

  // ── transmission rail: buses 2, 7, 8, 9, 3 (vertical bars) ──────
  bus("b2", (-5.65, -0.45), (-5.65, 0.45))
  nl((-5.65, 0.45), [2], "north")
  bus("b7", (-4.15, -0.45), (-4.15, 0.45))
  nl((-4.15, 0.45), [7], "north")
  bus("b8", (0, -0.45), (0, 0.45))
  nl((0, 0.45), [8], "north")
  bus("b9", (4.15, -0.45), (4.15, 0.45))
  nl((4.15, 0.45), [9], "north")
  bus("b3", (5.65, -0.45), (5.65, 0.45))
  nl((5.65, 0.45), [3], "north")

  // ── lower buses ─────────────────────────────────────────────────
  bus("b5", (-4.3, y5), (-3.1, y5))
  nl((-4.3, y5), [5], "north")
  bus("b6", (3.1, y5), (4.3, y5))
  nl((4.3, y5), [6], "north")
  bus("b4", (-0.8, y4), (0.8, y4))
  nl((0.8, y4), [4], "east")
  bus("b1", (-0.4, -4.2), (0.4, -4.2))
  nl((0.4, -4.2), [1], "north")

  // ── transformers ────────────────────────────────────────────────
  transformer("t27", (-5.65, 0), (-4.15, 0), radius: 0.23, distance: 0.2)
  transformer("t93", (4.15, 0), (5.65, 0), radius: 0.23, distance: 0.2)
  transformer("t41", (0, y4), (0, -4.2), radius: 0.23, distance: 0.2)
  // GFL-load-2 / SG row: bodies equidistant from the bus-8 axis.
  transformer("tl2", (-0.4, y1), (-2.1, y1), radius: 0.23, distance: 0.2)
  transformer("tsg", (0.4, y1), (2.1, y1), radius: 0.23, distance: 0.2)
  transformer("tl1", (-3.9, y5), (-3.9, -2.6), radius: 0.23, distance: 0.2)

  // ── synchronous generator at bus 8 ──────────────────────────────
  voltagesource("sg", (2.42, y1), kind: "sin", radius: 0.32)
  nl((2.42, y1 - 0.32), text(fill: red)[SG], "south")

  // ── conductors ──────────────────────────────────────────────────
  wire((-4.15, 0), (0, 0)) // 7–8
  wire((0, 0), (4.15, 0)) // 8–9
  // bus 8 → GFL-load-2 / SG feeders: two interior exits at the bottom
  // of the bar, each reaching its transformer through two L-bends
  wire((0, -0.25), (-0.4, -0.25))
  wire((-0.4, -0.25), (-0.4, y1))
  wire((0, -0.25), (0.4, -0.25))
  wire((0.4, -0.25), (0.4, y1))
  // bus 7 → bus 5 and bus 9 → bus 6 (mirrored elbow drops onto taps)
  wire((-4.15, -0.25), (-3.9, -0.25))
  wire((-3.9, -0.25), (-3.9, y5))
  wire((4.15, -0.25), (3.9, -0.25))
  wire((3.9, -0.25), (3.9, y5))
  // 5→4 / 6→4 funnels: equal perpendicular stubs + mirrored diagonals
  wire((-3.5, y5), (-3.5, -1.95))
  wire((-3.5, -1.95), (-0.4, -2.65))
  wire((-0.4, -2.65), (-0.4, y4))
  wire((3.5, y5), (3.5, -1.95))
  wire((3.5, -1.95), (0.4, -2.65))
  wire((0.4, -2.65), (0.4, y4))

  // ── converter blocks (AC triangle toward the connection) ────────
  conv("gfm2", (-6.55, 0), [GFM 2], gfm-fill, blu, kind: "dc-ac")
  wire("gfm2.east", (-5.65, 0))
  conv("gfm3", (6.55, 0), [GFM 3], gfm-fill, blu)
  wire("gfm3.west", (5.65, 0))
  conv("gfm1", (0, -4.85), [GFM 1], gfm-fill, blu)
  wire("gfm1.north", (0, -4.2))
  conv("gfl2", (-2.45, y1), [GFL load 2], gfl-fill, red, kind: "dc-ac")
  conv("gfl1", (-3.9, -2.95), [GFL load 1], gfl-fill, red)

  // ── loads ───────────────────────────────────────────────────────
  load("l6", (3.9, y5), fill: black)
})
