#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 10.16: Fase-aardsluiting in een zwevend MS-net.
// Phase-to-earth fault on an isolated (floating) MV network. Three
// phase conductors (a, b, c) emerge from a wye-connected source on
// the left through their winding inductances. The phase-to-ground
// capacitances are drawn as three shunt caps connecting each
// conductor to the green earth bus. A lightning bolt on phase c
// marks the fault current returning through the ground rail.
#diagram(length: 1.2cm, {
  // Colour palette to match the source figure.
  let r = rgb("#cc1122")     // red — coils, currents, fault arrow
  let b = rgb("#2244aa")     // blue — capacitor leads
  let g = rgb("#33aa33")     // green — ground / earth conductor

  // Phase y-positions and other reference levels.
  let y-a = 2.4
  let y-b = 1.6
  let y-c = 0.8
  let cap-top = -0.05        // cap.in (top of plates)
  let ground-y = -0.6
  let phase-end = 5.4

  // ── Three inductors with `in` ends along a single diagonal ──
  // Each inductor is shifted right by the same step as you go down,
  // so La.in / Lb.in / Lc.in are colinear. A single straight wire
  // through all three left ends then forms the diagonal neutral
  // connection from the top-left of La down to the bottom-right of
  // Lc — one continuous line, no convergence point and no crossing.
  //
  // `lead-in: 0.15` gives each coil a short horizontal stub on its
  // left side, so the diagonal joins a clean lead instead of meeting
  // the first bump head-on (matches the source figure where the
  // bumps start a short distance right of where the diagonal lands).
  let lead = 0.15
  let bump-r = 0.10
  let l-len = lead + 4 * 2 * bump-r        // 0.95
  let la-x = -1.7
  let lb-x = -1.4
  let lc-x = -1.1

  inductor("La", (la-x, y-a), angle: -90deg,
    lead-in: lead, lead-out: 0,
    bumps: 4, bump-radius: bump-r, stroke: 1pt + r)
  inductor("Lb", (lb-x, y-b), angle: -90deg,
    lead-in: lead, lead-out: 0,
    bumps: 4, bump-radius: bump-r, stroke: 1pt + r)
  inductor("Lc", (lc-x, y-c), angle: -90deg,
    lead-in: lead, lead-out: 0,
    bumps: 4, bump-radius: bump-r, stroke: 1pt + r)

  // Source enclosure — sized to wrap the diagonal layout with a
  // small margin on each side.
  cetz.draw.rect(
    (la-x - 0.15, 0.45),
    (lc-x + l-len + 0.15, 2.75),
    stroke: 0.8pt + black,
  )

  // Diagonal neutral connection — one continuous straight line from
  // above La down to below Lc, passing through all three inductor
  // `in` points. La.in / Lb.in / Lc.in are colinear by construction
  // (each inductor is shifted right by the same step), so the four
  // wire segments below render as one straight line. The two outer
  // segments extend the diagonal past La.in and Lc.in so it reads
  // as a prominent left-edge feature.
  let slope-dx-per-dy = (lc-x - la-x) / (y-c - y-a)  // -0.375
  let extend = 0.30
  let diag-top = (
    la-x + extend * slope-dx-per-dy,
    y-a + extend,
  )
  let diag-bot = (
    lc-x - extend * slope-dx-per-dy,
    y-c - extend,
  )
  wire(diag-top, "La.in", stroke: 0.8pt + black)
  wire("La.in",  "Lb.in", stroke: 0.8pt + black)
  wire("Lb.in",  "Lc.in", stroke: 0.8pt + black)
  wire("Lc.in",  diag-bot, stroke: 0.8pt + black)

  // ── Phase wires (black) extending right out of the enclosure ──
  // Connect from each inductor's `out` (right side, end of the bumps
  // — the symbol sets `out` there even when lead-out: 0) to the
  // phase letter at the right edge.
  wire("La.out", (phase-end, y-a))
  wire("Lb.out", (phase-end, y-b))
  wire("Lc.out", (phase-end, y-c))

  // Phase letters at the right edge.
  cetz.draw.content((phase-end + 0.20, y-a), text(weight: "bold", "a"))
  cetz.draw.content((phase-end + 0.20, y-b), text(weight: "bold", "b"))
  cetz.draw.content((phase-end + 0.20, y-c), text(weight: "bold", "c"))

  // ── Per-phase current annotations ──
  // Red arrows on phases a and b point back toward the source; on
  // phase c the current points toward the fault on the right.
  cetz.draw.line((1.5, y-a), (0.5, y-a), stroke: 1pt + r,
    mark: (end: ">", fill: r))
  cetz.draw.content((1.0, y-a + 0.22), text(size: 6pt, fill: r)[$I_(k 1 a)$])

  cetz.draw.line((1.5, y-b), (0.5, y-b), stroke: 1pt + r,
    mark: (end: ">", fill: r))
  cetz.draw.content((1.0, y-b + 0.22), text(size: 6pt, fill: r)[$I_(k 1 b)$])

  cetz.draw.line((0.5, y-c), (1.5, y-c), stroke: 1pt + r,
    mark: (end: ">", fill: r))
  cetz.draw.content((1.0, y-c + 0.22), text(size: 6pt, fill: r)[$I_(k 1 c)$])

  // ── Three phase-to-ground capacitances ──
  // Blue lead from each phase down to its cap, then the cap with
  // angle: 180deg + lead-out: 0 (plates hang below `in`), then a
  // second blue lead from the cap's bottom plate (`c.north` — the
  // local "north" anchor lands at the bottom after rotation) down
  // to the green earth bus.
  let cap1-x = 2.7
  let cap2-x = 3.3
  let cap3-x = 3.9

  wire((cap1-x, y-a), (cap1-x, cap-top), stroke: 1pt + b)
  wire((cap2-x, y-b), (cap2-x, cap-top), stroke: 1pt + b)
  wire((cap3-x, y-c), (cap3-x, cap-top), stroke: 1pt + b)

  capacitor("c1", (cap1-x, cap-top),
    angle: 180deg, lead-in: 0.08, lead-out: 0,
    plate-width: 0.4, plate-gap: 0.10)
  capacitor("c2", (cap2-x, cap-top),
    angle: 180deg, lead-in: 0.08, lead-out: 0,
    plate-width: 0.4, plate-gap: 0.10)
  capacitor("c3", (cap3-x, cap-top),
    angle: 180deg, lead-in: 0.08, lead-out: 0,
    plate-width: 0.4, plate-gap: 0.10)

  // Cap-bottom-to-ground-bus stubs.
  wire("c1.north", (cap1-x, ground-y), stroke: 1pt + b)
  wire("c2.north", (cap2-x, ground-y), stroke: 1pt + b)
  wire("c3.north", (cap3-x, ground-y), stroke: 1pt + b)

  // Charging-current arrows on the upper part of each cap lead (red,
  // pointing up toward the phase line) — same as the source figure.
  cetz.draw.line((cap1-x + 0.12, cap-top + 0.05),
    (cap1-x + 0.12, y-a - 0.10), stroke: 1pt + r,
    mark: (end: ">", fill: r))
  cetz.draw.line((cap2-x + 0.12, cap-top + 0.05),
    (cap2-x + 0.12, y-b - 0.10), stroke: 1pt + r,
    mark: (end: ">", fill: r))

  // ── Lightning bolt on phase c — the fault current `Ikt` ──
  // Reusable `bolt` symbol; spans from phase c down to the ground
  // rail with a colour-matched arrowhead at the ground end.
  let bolt-x = 4.6
  bolt("ikt", (bolt-x, y-c), (bolt-x + 0.1, ground-y),
    stroke: 1.5pt + r, arrow-color: r,
    label: (
      content: text(size: 7pt, fill: r)[$I_(k t)$],
      anchor: "east", distance: 0.15,
    ))

  // ── Ground rail (green) and ground reference symbol ──
  cetz.draw.line((-1.8, ground-y), (phase-end + 0.4, ground-y),
    stroke: 2pt + g)
  // `lead: 0.08` pushes the earth lines just below the rail with a
  // visible stub connecting them.
  ground("earth", (2.5, ground-y), kind: "earth", lead: 0.08)
})
