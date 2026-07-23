#import "/src/lib.typ": *
#set page(margin: 8pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 13.16: MS-transportverbinding met schakelstation. A feeding
// substation (Onderstation) — voltage source → TS busbar → TS/MS
// transformer → OS-MS busbar — supplies a switching station
// (Schakelstation) over a six-cable MV link. Inside the Schakelstation a
// single coupling field (Koppelveld) ties the incoming RS-MS bar to the
// outgoing RS-MS bar, which fans out to six departing feeders.
#diagram(length: 1cm, {
  // ── Layout parameters ──────────────────────────────────────────
  let g = green.darken(20%) // HV feed is drawn green
  let n = 6 // cables in the MV link / departing fan
  let gap = 0.5 // vertical spacing between cables
  let ytop = 0 // top cable
  let ybot = ytop - (n - 1) * gap // bottom cable
  let ts-h = 1.0 // TS busbar length (the short reference bar)
  let forky = ytop - gap / 2 // HV-feed height: the fork sits between …
  // … the top two cables, so it bifurcates
  let over = ts-h / 2 - gap / 2 // bus overshoot past the cables, chosen so
  // the tall bars' tops line up with TS's top
  let x-v = 0 // voltage source
  let x-ts = 1.6 // TS busbar
  let tr-in = 2.7 // TS/MS transformer span …
  let tr-out = 3.9 // … (two-node, along the feed)
  let x-osms = 5.2 // OS-MS busbar (Onderstation outgoing)
  let x-rsms = 8.3 // RS-MS busbar (Schakelstation incoming)
  let x-uit = 11.3 // RS-MS uitgaand busbar
  let out-len = 1.8 // departing-feeder stubs (cross the box edge)
  let box-top = 1.6 // dashed-box top / bottom
  let box-bot = -3.1
  let on-x0 = x-ts - 0.6 // Onderstation box L / R
  let on-x1 = x-osms + 0.7
  let sc-x0 = x-rsms - 0.7 // Schakelstation box L / R — L clears the
  let sc-x1 = x-uit + 0.7 // RS-MS label, stubs cross the R edge
  let feed = 0.8pt // feed-lead / wire weight (matches the cables)
  let dashed = (dash: "dashed", thickness: 0.7pt)

  let tapy(i) = ytop - i * gap // y of the i-th cable
  let bus-top = ytop + over // common top of all four busbars
  let bus-bot = ybot - over // bottom of the three tall busbars
  let koppy = (tapy(4) + tapy(5)) / 2 // Koppelveld height (between two cables)

  // The tall bars overshoot the cables by `over` at each end, so the cables
  // occupy the `band` fraction of each bar (the rest is overshoot). Feeding
  // `multi-wire` this band reproduces the evenly-spaced cable grid exactly.
  let lo = over / (bus-top - bus-bot)
  let band = (lo, 1 - lo)
  let kf = (bus-top - koppy) / (bus-top - bus-bot) // Koppelveld fraction

  // ── Station envelopes (drawn first, behind everything) ─────────
  area(
    "os",
    (on-x0, box-top),
    (on-x1, box-bot),
    title: [Onderstation],
    side: "north",
    size: 9pt,
    distance: 0.09,
    stroke: dashed,
  )
  area(
    "ss",
    (sc-x0, box-top),
    (sc-x1, box-bot),
    title: [Schakelstation],
    side: "north",
    size: 9pt,
    distance: 0.09,
    stroke: dashed,
  )

  // ── HV feed (green): V → TS bar → TS/MS transformer → OS-MS ────
  // The whole feed sits at `forky`, so its lead meets the OS-MS bar between
  // the top two cables (a fork) rather than collinear with the top one.
  machine(
    "V",
    (x-v, forky),
    text(fill: g, size: 9pt)[V],
    stroke: g,
    radius: 0.32,
  )
  note(
    (x-v, forky - 0.35),
    [TS-voeding \ 17.943 MW \ 8.903 Mvar],
    side: "south",
    text-align: center,
  )

  // TS busbar — green, but as thick as the other bars (a plain `stroke: g`
  // would also reset the thickness to 1pt).
  bus("ts", (x-ts, forky), length: ts-h, angle: 90deg, stroke: 1.8pt + g)
  note(
    (x-ts, bus-top + 0.05),
    [TS \ 52.500 kV],
    side: "north",
    text-align: center,
  )
  note(
    (x-ts + 0.7, forky),
    [17.943 MW \ 8.903 Mvar],
    side: "south",
    text-align: center,
    size: 7pt,
  )
  wire("V.east", "ts.mid", stroke: feed + g)

  // TS/MS transformer: primary (TS, green) on the left, secondary (MS,
  // black) on the right so the MS-side circle and lead read as MV. Both
  // leads use the `feed` weight so they match the wires they connect to.
  transformer(
    "trafo",
    (tr-in, forky),
    (tr-out, forky),
    primary-stroke: feed + g,
    secondary-stroke: feed + black,
    radius: 0.26,
    distance: 0.28,
  )
  note(((tr-in + tr-out) / 2, bus-top + 0.05), [TS/MS], side: "north")
  wire("ts.mid", "trafo.in", stroke: feed + g)

  // OS-MS bar; the transformer lead forks into it between cables 0 and 1.
  bus("osms", fit: ((x-osms, ytop), (x-osms, ybot)), over: over)
  note(
    (x-osms, bus-top + 0.05),
    [OS-MS \ 10.512 kV],
    side: "north",
    text-align: center,
  )
  note(
    (x-osms - 0.7, forky),
    [-17.851 MW \ -6.848 Mvar],
    side: "south",
    text-align: center,
    size: 7pt,
  )
  wire("trafo.out", (x-osms, forky), stroke: feed + black)

  // ── MV transport link: OS-MS → RS-MS (six cables) ──────────────
  bus("rsms", fit: ((x-rsms, ytop), (x-rsms, ybot)), over: over)
  note(
    (x-rsms, bus-top + 0.05),
    [RS-MS \ 9.962 kV],
    side: "north",
    text-align: center,
  )
  multi-wire("osms", "rsms", count: n, from: band, to: band)

  // ── Coupling field (Koppelveld): a single bus coupler (count: 1) tying
  // the two RS-MS bars between two cables ────────────────────────
  bus("uit", fit: ((x-uit, ytop), (x-uit, ybot)), over: over)
  note(
    (x-uit - 0.3, bus-top + 0.05),
    [RS-MS uitgaand \ 9.962 kV],
    side: "north",
    text-align: center,
  )
  multi-wire("rsms", "uit", count: 1, from: (kf, kf), to: (kf, kf))
  note(((x-rsms + x-uit) / 2, koppy), [Koppelveld], side: "north")
  cetz.draw.content((x-rsms + 0.15, bus-bot + 0.35), anchor: "north-west", text(
    size: 7pt,
  )[17.005 MW \ 6.991 Mvar])
  cetz.draw.content((x-uit - 0.15, bus-bot + 0.35), anchor: "north-east", text(
    size: 7pt,
  )[-17.005 MW \ -6.991 Mvar])

  // ── Departing feeders off RS-MS uitgaand — a stub fan (offset target,
  // no facing bus) ───────────────────────────────────────────────
  multi-wire("uit", (out-len, 0), count: n, from: band)
})
