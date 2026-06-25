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
  let g       = green.darken(20%)   // HV feed is drawn green
  let n       = 6                   // cables in the MV link / departing fan
  let gap     = 0.5                 // vertical spacing between cables
  let ytop    = 0                   // top cable
  let ybot    = ytop - (n - 1) * gap // bottom cable
  let ts-h    = 1.0                 // TS busbar length (the short reference bar)
  let forky   = ytop - gap / 2      // HV-feed height: the fork sits between …
                                    // … the top two cables, so it bifurcates
  let over    = ts-h / 2 - gap / 2  // bus overshoot past the cables, chosen so
                                    // the tall bars' tops line up with TS's top
  let x-v     = 0                   // voltage source
  let x-ts    = 2                   // TS busbar
  let tr-in   = 2.7                 // TS/MS transformer span …
  let tr-out  = 3.9                 // … (two-node, along the feed)
  let x-osms  = 5.2                 // OS-MS busbar (Onderstation outgoing)
  let x-rsms  = 8.3                 // RS-MS busbar (Schakelstation incoming)
  let x-uit   = 11.3                // RS-MS uitgaand busbar
  let out-len = 1.2                 // length of the departing feeder stubs
  let box-top = 1.6                 // dashed-box top / bottom
  let box-bot = -3.55
  let dashed  = (dash: "dashed", thickness: 0.7pt)

  let tapy(i) = ytop - i * gap      // y of the i-th cable (shared by every bundle)
  let bus-top = ytop + over         // common top of all four busbars
  let bus-bot = ybot - over         // bottom of the three tall busbars
  let koppy   = (tapy(4) + tapy(5)) / 2   // Koppelveld height (between two cables)

  // A bundle of `n` parallel cables between two x-positions, one per cable.
  let bundle(x0, x1) = {
    for i in range(n) {
      let y = tapy(i)
      wire((x0, y), (x1, y))
    }
  }

  // ── Station envelopes (drawn first, behind everything) ─────────
  cetz.draw.rect((x-ts - 0.9, box-top), (x-osms + 0.7, box-bot), stroke: dashed)
  cetz.draw.content(((x-ts - 0.9 + x-osms + 0.7) / 2, box-top - 0.25),
    text(size: 9pt)[Onderstation])
  cetz.draw.rect((x-rsms - 0.4, box-top), (x-uit + out-len + 0.3, box-bot),
    stroke: dashed)
  cetz.draw.content(((x-rsms - 0.4 + x-uit + out-len + 0.3) / 2, box-top - 0.25),
    text(size: 9pt)[Schakelstation])

  // ── HV feed (green): V → TS bar → TS/MS transformer → OS-MS ────
  // The whole feed sits at `forky`, so its lead meets the OS-MS bar between
  // the top two cables (a fork) rather than collinear with the top one.
  machine("V", (x-v, forky), text(fill: g, size: 9pt)[V], stroke: g, radius: 0.32)
  note((x-v, forky - 0.35), [TS-voeding \ 17.943 MW \ 8.903 Mvar], side: "south",
    text-align: center)

  // TS busbar — green, but as thick as the other bars (a plain `stroke: g`
  // would also reset the thickness to 1pt).
  bus("ts", (x-ts, forky), length: ts-h, angle: 90deg, stroke: 1.8pt + g)
  note((x-ts, bus-top + 0.05), [TS \ 52.500 kV], side: "north", text-align: center)
  note((x-ts, forky - ts-h / 2 - 0.05), [17.943 MW \ 8.903 Mvar],
    side: "south", text-align: center)
  wire("V.east", "ts.mid", stroke: g)

  // TS/MS transformer: primary (TS, green) on the left, secondary (MS,
  // black) on the right so the MS-side circle and lead read as MV.
  transformer("trafo", (tr-in, forky), (tr-out, forky),
    primary-stroke: g, secondary-stroke: black, radius: 0.26, distance: 0.28)
  note(((tr-in + tr-out) / 2, bus-top + 0.05), [TS/MS], side: "north")
  wire("ts.mid", "trafo.in", stroke: g)

  // OS-MS bar; the transformer lead forks into it between cables 0 and 1.
  bus("osms", (x-osms, bus-top), (x-osms, bus-bot))
  note((x-osms, bus-top + 0.05), [OS-MS \ 10.512 kV], side: "north", text-align: center)
  note((x-osms - 0.75, forky - 0.2), [-17.851 MW \ -6.848 Mvar], side: "south",
    text-align: center)
  wire("trafo.out", (x-osms, forky))

  // ── MV transport link: OS-MS → RS-MS (six cables) ──────────────
  bus("rsms", (x-rsms, bus-top), (x-rsms, bus-bot))
  note((x-rsms, bus-top + 0.05), [RS-MS \ 9.962 kV], side: "north", text-align: center)
  bundle(x-osms, x-rsms)

  // ── Coupling field (Koppelveld): a single bus coupler between the two
  // RS-MS bars, forking out of each between two cables ───────────
  bus("uit", (x-uit, bus-top), (x-uit, bus-bot))
  note((x-uit, bus-top + 0.05), [RS-MS uitgaand \ 9.962 kV], side: "north",
    text-align: center)
  wire((x-rsms, koppy), (x-uit, koppy))
  note(((x-rsms + x-uit) / 2, koppy), [Koppelveld], side: "north")
  cetz.draw.content((x-rsms + 0.15, bus-bot - 0.15), anchor: "north-west",
    [17.005 MW \ 6.991 Mvar])
  cetz.draw.content((x-uit - 0.15, bus-bot - 0.15), anchor: "north-east",
    [-17.005 MW \ -6.991 Mvar])

  // ── Departing feeders off RS-MS uitgaand ───────────────────────
  bundle(x-uit, x-uit + out-len)
})
