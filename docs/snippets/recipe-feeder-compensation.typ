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
  let x-tr   = 1.6         // feeding transformer
  let x-ms   = 2.9         // MS busbar node (top feeder starts here)
  let x-step = 4.0         // where the 57 A drop meets the bottom feeder
  let comp-y = -1.1        // compensation / step-down junction height

  // Station data shared by both feeders (only the numbering differs).
  let stations(p) = (
    (label: [Netstation #(p)1 \ 10,430 kV], load: [10 A \ 230 V]),
    (label: [Netstation #(p)2 \ 10,412 kV], load: [10 A \ 230 V]),
    (label: [Netstation #(p)3 \ 10,398 kV], load: [10 A \ 230 V]),
  )

  // ── Source ─────────────────────────────────────────────────────
  machine("V", (0, topy), "V")
  cetz.draw.content((0, topy + 0.7), align(center)[Onderstation HS \ 150,000 kV])
  cetz.draw.content((0, topy - 0.55), align(center)[Voedende net \ 7 A])
  transformer("tr", (x-tr, topy), radius: 0.28, distance: 0.3)
  cetz.draw.content((x-tr, topy - 0.6), [Voedingstransformator])
  cetz.draw.content((x-ms, topy + 0.7), align(center)[Onderstation MS \ 10,451 kV])
  wire("V.east", "tr.in")
  wire("tr.out", (x-ms, topy))
  note(((0 + x-tr) / 2, topy), [7 A], side: "north")
  note(((x-tr + x-ms) / 2, topy), [93 A], side: "north")

  // ── Feeders (same helper, different data) ──────────────────────
  feeder("top", (x-ms, topy), stations("1"),
    currents: ([56 A], [47 A], [38 A], [28 A]), lead: 2.2, drop-angle: -45deg, drop: 1.1)
  feeder("bot", (x-step, boty), stations("2"),
    currents: (none, [47 A], [38 A], [28 A]), lead: 1.2, drop-angle: -45deg, drop: 1.1)

  // ── Compensation + step down to the bottom feeder ──────────────
  wire((x-ms, topy), (x-ms, comp-y))          // drop from the MS node
  let cp = (x-ms - 0.5, comp-y)               // wire end = tip of the ">"
  wire((x-ms, comp-y), cp)
  cetz.draw.line((rel: (-0.3, 0.22), to: cp), cp, (rel: (-0.3, -0.22), to: cp),
    stroke: 0.8pt + black)
  cetz.draw.content((rel: (-0.2, -0.6), to: cp), align(center)[Compensatie \ 19 A])

  elbow((x-ms, comp-y), (x-step, boty), corner: "h")
  note(((x-ms + x-step) / 2, comp-y), [57 A], side: "north")
})
