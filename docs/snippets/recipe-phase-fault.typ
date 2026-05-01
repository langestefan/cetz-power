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

  // ── Source enclosure on the left ──
  cetz.draw.rect((-1.8, 0.45), (-0.45, 2.75), stroke: 0.8pt + black)

  // ── Three inductors inside the enclosure, one per phase ──
  // Horizontal orientation (angle: -90deg) flush against the right
  // side of the box; the in side faces the wye neutral on the left.
  inductor("La", (-1.25, y-a), angle: -90deg,
    lead-in: 0, lead-out: 0,
    bumps: 4, bump-radius: 0.10, stroke: 1pt + r)
  inductor("Lb", (-1.25, y-b), angle: -90deg,
    lead-in: 0, lead-out: 0,
    bumps: 4, bump-radius: 0.10, stroke: 1pt + r)
  inductor("Lc", (-1.25, y-c), angle: -90deg,
    lead-in: 0, lead-out: 0,
    bumps: 4, bump-radius: 0.10, stroke: 1pt + r)

  // ── Wye / star connection — crossed-diagonal layout ──
  // Vertical "neutral collector" line on the left wall. The outer
  // two phases cross-connect to it: La (top inductor) hooks down to
  // the BOTTOM of the collector, Lc (bottom inductor) hooks up to
  // the TOP — the two diagonals cross in the middle of the enclosure,
  // with Lb running horizontally through the crossing point. This is
  // the X-with-horizontal-middle (vertically-mirrored Z) pattern
  // from the source figure.
  let neut-x = -1.7
  wire((neut-x, y-c), (neut-x, y-a), stroke: 1pt + r)  // vertical neutral
  wire((neut-x, y-c), "La.in", stroke: 1pt + r)        // ↗ to top phase
  wire((neut-x, y-b), "Lb.in", stroke: 1pt + r)        // → middle phase
  wire((neut-x, y-a), "Lc.in", stroke: 1pt + r)        // ↘ to bottom phase

  // ── Phase wires (black) extending right out of the enclosure ──
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
