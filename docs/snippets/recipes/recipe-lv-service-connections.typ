#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

// Phase to Phase, "Netten voor distributie van elektriciteit", figs.
// 2.26-2.28 — the three ways an LV service connection taps a street
// cable: (A.1a) a branch joint (aftakmof) on an LS-hoofdkabel, (A.1b)
// the auxiliary cores (hulpaders) of an LS-combikabel, and (A.1c) an
// OV public-lighting cable with a branch drop and a loop-through
// (rijgsysteem). Each variant shows its cable cross-section on the
// right: phase conductors as coloured circles, the neutral as a
// yellow/blue striped one (a Typst `tiling` fill), and the combikabel
// adds four small auxiliary cores between the main ones. The squares
// are `breaker` boxes (switchgear, transfer points); the dots are
// closed `junction`s (joints, service boxes).
#diagram(length: 1cm, {
  let s = 0.016                        // image-pixel → cm (compression knob)
  let H = 773
  let P(x, y) = (x * s, (H - y) * s)   // flip y (image is y-down)

  let cred = rgb("#e2001a")            // the book's conductor palette
  let cyel = rgb("#ffde00")
  let cblu = rgb("#29abe2")
  let cbrn = rgb("#a97c50")
  let nul-fill = tiling(size: (6pt, 6pt))[
    #place(rect(width: 6pt, height: 6pt, fill: cyel))
    #place(line(start: (0pt, 6pt), end: (6pt, 0pt), stroke: 2.4pt + cblu))
    #place(line(start: (-3pt, 3pt), end: (3pt, -3pt), stroke: 2.4pt + cblu))
    #place(line(start: (3pt, 9pt), end: (9pt, 3pt), stroke: 2.4pt + cblu))
  ]

  // ── helpers ─────────────────────────────────────────────────────
  let lbl(x, y, c, red: false, anchor: "west") = cetz.draw.content(
    P(x, y), anchor: anchor,
    text(size: 7pt, fill: if red { cred } else { black })[#c])
  let sq(n, x, y) = breaker(n, P(x, y), size: 0.2, fill: white)
  let dot(n, x, y) = junction(n, P(x, y), radius: 0.13)
  // MS bus → breaker → transformer → breaker → LS bus, line height y
  let station(tag, y) = {
    wire(P(35, y - 16), P(67, y - 16)); wire(P(35, y + 16), P(67, y + 16))
    wire(P(67, y), P(105, y)); wire(P(180, y), P(224, y))
    bus("ms-" + tag, P(67, y - 34), P(67, y + 34))
    bus("ls-" + tag, P(224, y - 33), P(224, y + 33))
    transformer("tx-" + tag, P(105, y), P(180, y), radius: 0.3, distance: 0.36)
    sq("q1-" + tag, 95, y); sq("q2-" + tag, 194, y)
    cetz.draw.content(P(72, y - 47), [MS])
    cetz.draw.content(P(226, y - 47), [LS])
  }
  // the service-drop ladder: cut + joint + service cable + transfer
  // point (square) + service box (dot), labels beside it
  let drop(tag, x, ytop, ysq, ybot) = {
    wire(P(x, ytop), P(x, ybot))
    sq("op-" + tag, x, ysq)
    dot("ak-" + tag, x, ybot)
  }
  // cable cross-section: sheath + four cores (+ combikabel hulpaders)
  let xsec(tag, cx, cy, cores, aux: false) = {
    cetz.draw.circle(P(cx, cy), radius: 70 * s, stroke: 1.1pt + black, fill: white)
    let off = ((-27, -26), (28, -26), (-27, 26), (28, 26))
    for (i, core) in cores.enumerate() {
      let (dx, dy) = off.at(i)
      cetz.draw.circle(P(cx + dx, cy + dy), radius: 21 * s,
        stroke: 0.9pt + black, fill: core.at(0))
      if core.len() > 1 {
        cetz.draw.content(P(cx + dx, cy + dy),
          text(size: 7pt, style: "italic", fill: core.at(2))[#core.at(1)])
      }
    }
    if aux {
      let hulp = (((0, -55), cred), ((53, 0), cyel), ((0, 55), cblu), ((-53, 0), nul-fill))
      for (i, h) in hulp.enumerate() {
        cetz.draw.circle(P(cx + h.at(0).at(0), cy + h.at(0).at(1)),
          radius: 7 * s, stroke: 0.7pt + black, fill: h.at(1))
      }
    }
  }
  let fases = ((cred, [fase], white), (cyel, [fase], black),
               (nul-fill, [nul], blue.darken(35%)), (cblu, [fase], white))
  let caption(y, c) = cetz.draw.content(P(365, y), text(weight: "bold")[#c])
  let subfig(y, c) = cetz.draw.content(P(82, y), text(size: 10pt, style: "italic")[#c])

  // ── A.1a — branch joint on an LS-hoofdkabel (fig. 2.26) ─────────
  station("a", 89)
  wire(P(224, 89), P(580, 89))                 // LS-hoofdkabel into the sheath
  sq("qa", 249, 89)
  drop("a", 390, 89, 160, 192)
  dot("mof-a", 390, 89)                        // aftakmof
  xsec("a", 642, 89, fases)
  lbl(295, 68, [LS-hoofdkabel], anchor: "center")
  lbl(392, 68, [Aftakmof], anchor: "center")
  lbl(492, 68, [LS-hoofdkabel], anchor: "center")
  lbl(402, 105, [Knip], red: true)
  lbl(402, 124, [Verbinding], red: true)
  lbl(402, 141, [LS-aansluitkabel])
  lbl(402, 160, [Overdrachtspunt], red: true)
  lbl(402, 178, [Aansluitkast])
  subfig(146, [A.1a])
  caption(232, [Figuur 2.26 Aansluiting op een LS-hoofdkabel])

  // ── A.1b — hulpaders of an LS-combikabel (fig. 2.27) ────────────
  station("b", 338)
  wire(P(224, 331), P(590, 331))               // hoofdaders, into the sheath
  wire(P(224, 346), P(590, 346))               // hulpaders, into the sheath
  sq("qb1", 248, 331); sq("qb2", 248, 346)
  // cable outline: dashed, open on the right — top and bottom edges run
  // straight into the cross-section sheath (which masks the overshoot)
  let dashed = (dash: "dashed", thickness: 0.8pt, paint: black)
  cetz.draw.line(P(272, 296), P(272, 375), stroke: dashed)
  cetz.draw.line(P(272, 296), P(590, 296), stroke: dashed)
  cetz.draw.line(P(272, 375), P(590, 375), stroke: dashed)
  drop("b", 390, 346, 425, 457)
  dot("mof-b", 390, 346)
  xsec("b", 642, 337, fases, aux: true)
  lbl(387, 281, [LS-kabel], anchor: "center")
  lbl(317, 315, [Hoofdaders], anchor: "center")
  lbl(315, 361, [Hulpaders], anchor: "center")
  lbl(492, 361, [Hulpaders], anchor: "center")
  lbl(405, 361, [Knip], red: true)
  lbl(402, 389, [Verbinding], red: true)
  lbl(402, 407, [LS-aansluitkabel])
  lbl(402, 425, [Overdrachtspunt], red: true)
  lbl(402, 443, [Aansluitkast])
  subfig(395, [A.1b])
  caption(497, [Figuur 2.27 Aansluiting op de hulpaders van een LS-combikabel])

  // ── A.1c — OV cable, branch drop + loop-through (fig. 2.28) ─────
  station("c", 597)
  wire(P(224, 589), P(370, 589))               // LS-hoofdkabel, continues dashed
  cetz.draw.line(P(378, 589), P(448, 589),
    stroke: (dash: "dashed", thickness: 0.8pt, paint: black))
  wire(P(224, 605), P(580, 605))               // OV-kabel into the sheath
  sq("qc1", 249, 589); sq("qc2", 249, 605)
  drop("c1", 315, 605, 674, 706)               // aftaksysteem
  dot("mof-c", 315, 605)
  wire(P(441, 605), P(441, 659), P(475, 659), P(475, 605))   // rijgsysteem loop
  drop("c2", 458, 659, 689, 706)
  dot("rij1", 441, 605); dot("rij2", 475, 605)
  xsec("c", 642, 605, ((cbrn,), (black,), (cblu,), (white,)))
  lbl(287, 568, [LS-hoofdkabel], anchor: "center")
  lbl(270, 620, [OV-kabel], anchor: "center")
  lbl(326, 621, [Knip], red: true)
  lbl(326, 638, [Verbinding], red: true)
  lbl(326, 653, [LS-aansluitkabel])
  lbl(326, 674, [Overdrachtspunt], red: true)
  lbl(326, 690, [Aansluitkast])
  lbl(486, 621, [Knip], red: true)
  lbl(486, 638, [Verbinding], red: true)
  lbl(486, 653, [Rijgsysteem])
  lbl(486, 689, [Overdrachtspunt], red: true)
  subfig(660, [A.1c])
  caption(755, [Figuur 2.28 Aansluiting op een OV-hoofdkabel met aftaksysteem en met rijgsysteem])
})
