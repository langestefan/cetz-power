#import "/src/lib.typ": *
#set page(margin: 8pt, width: auto, height: auto)
#set text(size: 6.5pt)

// Figuur 9.22: Negatieve belasting ter compensatie van de
// gelijktijdigheid. A feeding substation supplies two MV feeders (drawn
// with the `feeder` helper); each carries three Netstations (tap →
// distribution transformer → LV load), and a negative load
// ("Compensatie") offsets the coincidence.
#diagram(length: 1cm, {
  let topy   = 0           // top feeder height
  let boty   = -3.0        // bottom feeder height
  let x-hs   = 1.6         // HS busbar
  let x-ms   = 4.0         // MS busbar (top feeder starts here)
  let x-step = 4.8         // where the 57 A drop meets the bottom feeder
  let comp-y = -1.1        // MS-bus foot / compensation + step junction
  let x-n1   = 5.6         // first Netstation (shared by both feeders)
  let dx     = 2.5         // station spacing
  let x-end  = 12.2        // both feeders end here, so "28 A" shares an x
  let tail   = x-end - (x-n1 + 2 * dx)   // common tail length
  let dash-len = 0.9       // length of the dashed tail on each feeder
  let bus-h  = 1.1         // HS busbar length
  let ext    = bus-h / 2   // MS bus overshoots each tap by this (top aligns with HS top)

  // Station data shared by both feeders (only the numbering differs).
  let stations(p) = (
    (label: [Netstation #(p)1 \ 10,430 kV], load: [10 A \ 230 V]),
    (label: [Netstation #(p)2 \ 10,412 kV], load: [10 A \ 230 V]),
    (label: [Netstation #(p)3 \ 10,398 kV], load: [10 A \ 230 V]),
  )

  // ── Source ─────────────────────────────────────────────────────
  machine("V", (0, topy), "V")
  cetz.draw.content((0, topy - 0.55), align(center)[Voedende net \ 7 A])

  // Onderstation HS — the 150 kV busbar.
  bus("hs", (x-hs, topy), length: bus-h, angle: 90deg)
  cetz.draw.content((x-hs, topy + ext + 0.3), align(center)[Onderstation HS \ 150,000 kV])
  wire("V.east", "hs.mid")
  note((x-hs * 1.25, topy), [7 A], side: "north")

  // Onderstation MS — the MV busbar (vertical). It taps the transformer +
  // top feeder at `topy` and the compensation + step-down at `comp-y`, and
  // overshoots each by `ext` so its top lines up with the HS busbar.
  bus("ms", (x-ms, topy + ext), (x-ms, comp-y - ext))
  // The MS busbar continues downward (dashed) — more feeders not shown.
  wire((x-ms, comp-y - ext), (x-ms, comp-y - ext - dash-len),
    stroke: (paint: black, thickness: 1.8pt, dash: "dashed"))
  cetz.draw.content((x-ms, topy + ext + 0.3), align(center)[Onderstation MS \ 10,451 kV])

  transformer("tr", "hs.mid", (x-ms, topy), radius: 0.28, distance: 0.3)
  cetz.draw.content(((x-hs + x-ms) / 2, topy - 0.6), [Voedingstransformator])
  note((x-ms*0.9, topy), [93 A], side: "north")

  // ── Feeders — aligned: same station x and same end x ───────────
  feeder("top", (x-ms, topy), stations("1"),
    currents: ([56 A], [47 A], [38 A], [28 A]),
    lead: x-n1 - x-ms, spacing: dx, tail: tail, extend: dash-len,
    drop-angle: -45deg, drop: 1.1)
  feeder("bot", (x-step, boty), stations("2"),
    currents: (none, [47 A], [38 A], [28 A]),
    lead: x-n1 - x-step, spacing: dx, tail: tail, extend: dash-len,
    drop-angle: -45deg, drop: 1.1)

  // ── Compensation + step down to the bottom feeder ──────────────
  let cp = (x-ms - 0.5, comp-y)               // wire end = tip of the ">"
  wire((x-ms, comp-y), cp)
  cetz.draw.line((rel: (-0.3, 0.22), to: cp), cp, (rel: (-0.3, -0.22), to: cp),
    stroke: 0.8pt + black)
  cetz.draw.content((rel: (-0.2, -0.6), to: cp), align(center)[Compensatie \ 19 A])

  elbow((x-ms, comp-y), (x-step, boty), corner: "h")
  note(((x-ms + x-step) / 2, comp-y), [57 A], side: "north")
})
