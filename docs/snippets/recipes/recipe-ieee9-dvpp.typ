#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 9pt)

// Häberle (ETH), Fig. 3.15 — Case study III: a modified IEEE nine-bus system
// (synchronous machines SG1–SG3, buses 1–9) with an MV distribution grid (the
// DVPP area, buses d1a/d1b and d2–d8) connected at buses 4 and 6 through the
// two POC transformers. Inside the DVPP a wind plant, a battery (BESS) and a PV
// plant each tie in through their own transformer; the MV loads are drawn as
// constant-power load arrows. Layout digitised from the figure, so the relative
// geometry matches the original. Every connection taps a bus interior (often its
// centre), never an endpoint.
#diagram(length: 1cm, {
  let s = 0.025                  // image-pixel → cm
  let H = 489
  let P(x, y) = (x * s, (H - y) * s)   // flip y (image is y-down)

  let blue = rgb("#9cdcf0")
  let pink = rgb("#f3c9ea")
  let gold = rgb("#f5b426")
  let gray = rgb("#d9d9d9")

  let yc = 60.5                  // transmission line / vertical-bus centre

  // ── helpers ─────────────────────────────────────────────────────
  let nl(p, c, sd) = note(p, text(size: 8pt)[#c], side: sd, distance: 0.06)
  // synchronous machine = the built-in circle-with-sine source, plus a caption.
  let sg(name, p, lbl, lside) = {
    voltagesource(name, p, kind: "sin", radius: 0.5, fill: gray)
    let cx = p.at(0); let cy = p.at(1)
    let off = 0.62                       // outside the r=0.5 circle
    let txt = text(size: 8pt)[#lbl]
    if lside == "south" {
      cetz.draw.content((cx, cy - off), anchor: "north", txt)
    } else {
      cetz.draw.content((cx - off, cy), anchor: "east", txt)
    }
  }
  // coloured device block centred on `c`.
  let devbox(c, fill, lbl) = {
    let w = 1.15; let h = 0.5
    cetz.draw.rect(
      (c.at(0) - w / 2, c.at(1) - h / 2),
      (c.at(0) + w / 2, c.at(1) + h / 2),
      fill: fill, stroke: 0.8pt + black,
    )
    cetz.draw.content(c, text(size: 8pt)[#lbl])
  }
  // load arrow: small, with optional elbow + direction.
  let ld(name, p, ang: 0deg, e: 0) = load(
    name, p, angle: ang, elbow: e, size: 0.2, lead: 0.16, fill: black,
  )

  // ── DVPP background area (drawn first, behind everything) ────────
  cetz.draw.rect(
    P(232, 400), P(680, 217),
    fill: gray.lighten(58%),
    stroke: (dash: "dashed", paint: gray.darken(25%), thickness: 0.6pt),
    radius: 0.12,
  )
  cetz.draw.content(
    P(244, 378), anchor: "west",
    text(size: 8pt, fill: gold.darken(8%))[DVPP\ area],
  )

  // ── transmission buses (vertical, centred on yc) ────────────────
  bus("b2", P(187, 38), P(187, 83)); nl(P(187, 34), [2], "north")
  bus("b7", P(281, 38), P(281, 83)); nl(P(281, 34), [7], "north")
  bus("b8", P(372, 38), P(372, 83)); nl(P(372, 34), [8], "north")
  bus("b9", P(463, 38), P(463, 83)); nl(P(472, 50), [9], "east")
  bus("b3", P(557, 38), P(557, 83)); nl(P(557, 34), [3], "north")
  bus("b1", P(280, 169), P(280, 213)); nl(P(280, 165), [1], "north")

  // ── middle network buses (horizontal) ───────────────────────────
  bus("b5", P(295.5, 104), P(343.5, 104)); nl(P(289.5, 104), [5], "west")
  bus("b6", P(394, 104), P(442, 104)); nl(P(450, 104), [6], "east")
  bus("b4", P(346, 159), P(393.5, 159)); nl(P(401, 159), [4], "east")

  // ── DVPP buses (horizontal) ─────────────────────────────────────
  bus("d1b", P(364, 235), P(411, 235)); nl(P(419, 235), [d1b], "east")
  bus("d1a", P(467.5, 235), P(588.5, 235)); nl(P(596, 235), [d1a], "east")
  bus("d7", P(364, 289), P(411, 289)); nl(P(419, 289), [d7], "east")
  bus("d5", P(452, 289), P(499, 289)); nl(P(507, 289), [d5], "east")
  bus("d2", P(555, 289), P(606, 289)); nl(P(614, 289), [d2], "east")
  bus("d8", P(352, 347), P(399, 347)); nl(P(344, 347), [d8], "west")
  bus("d6", P(440, 347), P(487, 347)); nl(P(432, 347), [d6], "west")
  bus("d3", P(525, 347), P(572, 347)); nl(P(517, 347), [d3], "west")
  bus("d4", P(595, 347), P(642, 347)); nl(P(650, 347), [d4], "east")

  // ── transformers (leads land on bus centres) ────────────────────
  transformer("t27", P(187, yc), P(281, yc), radius: 0.27, distance: 0.24)
  transformer("t93", P(463, yc), P(557, yc), radius: 0.27, distance: 0.24)
  transformer("t14", P(281, 191), P(352, 191), radius: 0.27, distance: 0.24)
  transformer("poc2", P(387.5, 159), P(387.5, 235), radius: 0.27, distance: 0.24)
  transformer("poc1", P(528, 159), P(528, 235), radius: 0.27, distance: 0.24)
  nl(P(401, 200), [POC 2], "east"); nl(P(541, 200), [POC 1], "east")
  transformer("twind", P(327, 317), P(364, 317), radius: 0.14, distance: 0.15)
  transformer("tbess", P(416, 381), P(463.5, 381), radius: 0.14, distance: 0.15)
  transformer("tpv", P(600, 376), P(548.5, 376), radius: 0.14, distance: 0.15)

  // ── generators (straight stubs into bus centres) ────────────────
  sg("sg2", P(141, yc), [SG 2], "south"); wire("sg2.east", P(187, yc))
  sg("sg3", P(593, yc), [SG 3], "south"); wire("sg3.west", P(557, yc))
  sg("sg1", P(237, 191), [SG 1], "west"); wire("sg1.east", P(280, 191))

  // ── transmission conductors ─────────────────────────────────────
  wire(P(281, yc), P(372, yc))                         // 7-8
  wire(P(372, yc), P(463, yc))                         // 8-9
  wire(P(281, 75), P(319.5, 75)); wire(P(319.5, 75), P(319.5, 104))  // 7→5: horizontal off bus 7, down into bus 5 centre
  // 6→9 and the POC 1 feed share one collinear vertical off bus 6 (x432)
  wire(P(432, 104), P(432, 70)); wire(P(432, 70), P(463, 70))     // 6→9
  wire(P(432, 104), P(432, 159)); wire(P(432, 159), P(528, 159))  // bus6 → POC 1 feed
  // 4→5 / 4→6 funnels: perpendicular stub, diagonal, perpendicular stub (no angled bus joins)
  wire(P(335.5, 104), P(335.5, 116)); wire(P(335.5, 116), P(352, 147)); wire(P(352, 147), P(352, 159))  // 4-5 (mirror of 4-6 about bus4 centre)
  wire(P(404, 104), P(404, 116)); wire(P(404, 116), P(387.5, 147)); wire(P(387.5, 147), P(387.5, 159)) // 4-6
  wire(P(352, 191), P(352, 159))                       // bus1 → bus4 riser

  // ── DVPP conductors (vertical links land on bus centres) ────────
  wire(P(387.5, 235), P(387.5, 289))                   // d1b–d7 (both centres)
  wire(P(375.5, 289), P(375.5, 347))                   // d7–d8 (d8 centre)
  wire(P(475.5, 235), P(475.5, 289))                   // d1a–d5 (d5 centre)
  wire(P(580.5, 235), P(580.5, 289))                   // d1a–d2 (d2 centre)
  wire(P(463.5, 289), P(463.5, 347))                   // d5–d6 (d6 centre)
  wire(P(567, 289), P(567, 320)); wire(P(567, 320), P(548.5, 320)); wire(P(548.5, 320), P(548.5, 347))  // d2–d3 (symmetric on d2)
  wire(P(594, 289), P(594, 320)); wire(P(594, 320), P(618.5, 320)); wire(P(618.5, 320), P(618.5, 347))  // d2–d4 (symmetric on d2)
  wire(P(478, 347), P(478, 330)); wire(P(478, 330), P(535, 330)); wire(P(535, 330), P(535, 347))        // d6–d3 (staple; d3 leg aligned with load)
  // device transformer leads up into their bus taps
  wire(P(364, 317), P(364, 347))                       // Twind → d8 (left tap)
  wire(P(463.5, 381), P(463.5, 347))                   // Tbess → d6
  wire(P(548.5, 376), P(548.5, 347))                   // Tpv  → d3
  // device blocks → their transformers (no floating boxes)
  wire(P(316, 317), P(327, 317))                       // wind → Twind
  wire(P(403, 381), P(416, 381))                       // BESS → Tbess
  wire(P(609, 376), P(600, 376))                       // PV → Tpv

  // ── device blocks ───────────────────────────────────────────────
  devbox(P(293, 317), blue, [wind])
  devbox(P(380, 381), pink, [BESS])
  devbox(P(632, 376), gold, [PV])

  // ── loads (constant-power arrows; small, interior taps) ─────────
  ld("l5", P(319.5, 104))                              // bus 5 (down, centre)
  ld("l8", P(372, 72), e: 0.4)                         // bus 8 (right-elbow, down)
  ld("l4", P(369.75, 159), ang: 180deg)                // bus 4 (up, centre)
  ld("l9", P(463, 48), ang: 180deg)                    // bus 9 (up)
  ld("ld5", P(487, 289), ang: 180deg)                  // d5 (up, right tap)
  ld("ld6", P(478, 347))                               // d6 (down)
  ld("ld3", P(535, 347))                               // d3 (down)
  ld("ld4", P(630, 347), ang: 180deg)                  // d4 (up)
  ld("ld7", P(400, 289), ang: 90deg, e: 0.18)          // d7 (up-elbow, right)
  ld("ld8", P(387, 347), ang: 90deg, e: 0.18)          // d8 (up-elbow, right tap)
})
