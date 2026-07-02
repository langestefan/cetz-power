#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

// TU/e thesis fig. 4.9 — the urban LV benchmark grid: a 150 MVA, 10 kV
// external grid feeds bus 1, an OLTC 10/0.4 kV transformer steps down
// onto bus 2, and three radial 400 V feeders serve 34 buses. Five
// normally-open switches S1–S5 tie the feeder ends together along the
// right edge. Firm loads are black arrows, flexible loads blue, PV
// panels chevron boxes. Buses 20 and 28 are NOT connected.
//
// The drawing is data-driven: each feeder is a table of stations
// (segment length [m], bus nr, device) laid out by `run()` at a
// length-proportional pitch, so bus positions follow from the cable
// data instead of hand-placed coordinates. Devices are drawn before
// their buses so the bars paint over the lead roots.
#diagram(length: 1cm, {
  let flex = rgb("#29abe2") // the figure's cyan for flexible devices

  // ── layout constants ────────────────────────────────────────────
  let k = 0.048 // cm of feeder per metre of cable
  let lead = 0.45 // riser corner → first bus of a run
  let dbr = 0.45 // branch jogs step this far aside before turning
  let dj = 0.29 // jogs/ties leave or enter a tick this far off its row
  let half = 0.5 // bus-tick half-length
  let eL = 0.38 // device elbows exit this far below the row
  let tail = 1.0 // run end → its tie-switch column
  let g = 0.55 // row → tie-switch pin
  let sw = 0.54 // tie-switch span
  // feeder rows, top to bottom
  let (ytop, ya, yb, ym, ys, yc, yd) = (12.0, 10.0, 8.05, 6.4, 4.65, 3.0, 1.35)
  let x2 = 4.6 // bus 2 (the LV rail of the substation)
  let (yja, yjc) = (7.9, 5.15) // bus-2 exit jogs of feeders A and C

  // ── helpers ─────────────────────────────────────────────────────
  let nl(p, c, sd, d: 0.08) = note(p, c, side: sd, distance: d, size: 8pt)
  // segment-length label; vertical runs get rotated text
  let dl(a, b, c, sd) = note(
    (a, 50%, b),
    if sd in ("east", "west") { rotate(-90deg, reflow: true, c) } else { c },
    side: sd,
    distance: 0.05,
    size: 5.5pt,
  )
  let ld(n, x, y) = load(
    "l" + str(n),
    (x, y - eL),
    elbow: 0.26,
    size: 0.18,
    lead: 0.16,
  )
  let fx(n, x, y) = load(
    "f" + str(n),
    (x, y - eL),
    elbow: 0.26,
    size: 0.18,
    lead: 0.16,
    fill: flex,
    stroke: flex,
  )
  let pv(n, x, y) = pv-panel(
    "pv" + str(n),
    (x, y - eL),
    elbow: 0.38,
    size: 0.2,
    aspect: 1.6,
    lead: 0.1,
  )

  // place stations along a run: x advances by segment length (or the
  // fixed corner lead when none) — positions follow from the data
  let place(x0, stations) = {
    let x = x0
    let out = ()
    for (len, n, dev) in stations {
      x += if len == none { lead } else { len * k }
      out.push((x, len, n, dev))
    }
    out
  }
  let xof(r, n) = r.find(s => s.at(2) == n).at(0)
  // draw a placed run at row y: labelled wire hops, then devices,
  // then the numbered bus ticks (bars over lead roots)
  let run(y, x0, st, south: ()) = {
    let prev = x0
    for (x, len, n, dev) in st {
      wire((prev, y), (x, y))
      if len != none {
        dl((prev, y), (x, y), [#len m], if n in south { "south" } else {
          "north"
        })
      }
      prev = x
    }
    for (x, len, n, dev) in st {
      if dev == "l" { ld(n, x, y) } else if dev == "f" { fx(n, x, y) } else if (
        dev == "pv"
      ) { pv(n, x, y) }
    }
    for (x, len, n, dev) in st {
      bus(str(n), (x, y - half), (x, y + half))
      nl((x, y + half), [#n], "north")
    }
  }
  // branch riser: leave a tick's body sideways at dy off the row,
  // turn, and climb to the target row (rotated length label)
  let riser(x, y, dy, yto, len) = {
    wire((x, y + dy), (x + dbr, y + dy), (x + dbr, yto))
    dl((x + dbr, y + dy), (x + dbr, yto), [#len m], "west")
  }
  // normally-open tie: run end → down through the switch → into the
  // destination tick's body (length label on the destination side)
  let tie(i, xfrom, yfrom, x, ydest, xdest, len) = {
    wire((xfrom, yfrom), (x, yfrom), (x, yfrom - g))
    wire((x, yfrom - g - sw), (x, ydest), (xdest, ydest))
    if len != none { dl((x, ydest), (xdest, ydest), [#len m], "north") }
    switch("s" + str(i), (x, yfrom - g), (x, yfrom - g - sw))
    nl((x, yfrom - g - sw / 2), [S#i], "east", d: 0.24)
  }

  // ── station data: (segment length [m], bus nr, device) ──────────
  let A = place(x2 + 0.4, (
    (none, 3, "l"),
    (20, 4, "f"),
    (30, 5, "pv"),
    (25, 10, "f"),
    (30, 11, "l"),
    (25, 12, "pv"),
  ))
  let M = place(x2, (
    (40, 13, "pv"),
    (30, 14, "l"),
    (25, 15, "f"),
    (20, 16, "l"),
    (25, 20, "pv"),
    (25, 21, "f"),
    (20, 22, "l"),
  ))
  let C = place(x2 + 0.4, (
    (none, 23, "l"),
    (25, 24, "f"),
    (20, 25, "pv"),
    (30, 26, "f"),
    (20, 27, "l"),
    (25, 30, "l"),
    (30, 31, "l"),
  ))
  let T = place(xof(A, 5) + dbr, (
    (none, 6, "l"),
    (20, 7, "f"),
    (30, 8, "pv"),
    (25, 9, "l"),
  ))
  let B = place(xof(M, 16) + dbr, (
    (none, 17, "pv"),
    (25, 18, "l"),
    (30, 19, "f"),
  ))
  let S = place(xof(C, 27) + dbr, ((none, 28, "f"), (20, 29, "l")))
  let D = place(xof(C, 30) + dbr, (
    (none, 32, "pv"),
    (30, 33, "l"),
    (20, 34, "f"),
  ))

  // ── substation: external grid → bus 1 → OLTC transformer → bus 2 ─
  external-grid("grid", (2.56, ym), angle: 90deg, size: 0.62)
  cetz.draw.content((2.15, ym + 0.8), align(center)[150 MVA,\ 10 kV])
  cetz.draw.content((2.15, ym - 0.85), align(center)[External\ Grid])
  wire((2.56, ym), (3.38, ym))
  wire((3.38, ym), (3.65, ym))
  transformer("t12", (3.65, ym), (4.39, ym), radius: 0.18, distance: 0.2)
  cetz.draw.line(
    (3.73, ym - 0.27),
    (4.3, ym + 0.3), // OLTC arrow through the rings
    stroke: 0.7pt,
    mark: (end: ">", fill: black, scale: 0.5),
  )
  cetz.draw.content((4.02, ym - 0.66), [10/0.4 kV])
  wire((4.39, ym), (x2, ym))
  bus("1", (3.38, ym - half), (3.38, ym + half))
  nl((3.38, ym + half), [1], "north")
  bus("2", (x2, yjc - 0.19), (x2, yja + 0.19))
  nl((x2, yja + 0.19), [2], "north")
  cetz.draw.content((2.4, 3.7), align(
    center,
  )[R = 0.641 Ω/km \ X = 0.085 Ω/km \ Cable capacity = 105 kVA])

  // ── risers off bus 2 and the feeder branches ─────────────────────
  wire((x2, yja), (x2 + 0.4, yja), (x2 + 0.4, ya)) // 2 → feeder A
  dl((x2 + 0.4, yja), (x2 + 0.4, ya), [50 m], "west")
  wire((x2, yjc), (x2 + 0.4, yjc), (x2 + 0.4, yc)) // 2 → feeder C
  dl((x2 + 0.4, yjc), (x2 + 0.4, yc), [50 m], "west")
  riser(xof(A, 5), ya, dj, ytop, 35) // 5 → 6..9
  riser(xof(M, 16), ym, dj, yb, 30) // 16 → 17..19
  riser(xof(C, 27), yc, dj, ys, 30) // 27 → 28/29 spur
  riser(xof(C, 30), yc, -0.15, yd, 25) // 30 → 32..34 (above 30's load elbow)

  // ── the feeder runs ──────────────────────────────────────────────
  run(ya, x2 + 0.4, A)
  run(ym, x2, M, south: (20,)) // south: the 17-riser jog is above
  run(yc, x2 + 0.4, C)
  run(ytop, xof(A, 5) + dbr, T)
  run(yb, xof(M, 16) + dbr, B)
  run(ys, xof(C, 27) + dbr, S)
  run(yd, xof(C, 30) + dbr, D)

  // ── normally-open ties S1..S5 along the right edge ───────────────
  let xtie = xof(M, 22) + tail // shared S2/S3/S4 column
  let xs1 = xof(T, 9) + tail
  let xs5 = xof(C, 31) + tail
  tie(1, xof(T, 9), ytop, xs1, ya + dj, xof(A, 12), 30)
  tie(2, xof(A, 12), ya, xtie, yb + dj, xof(B, 19), 20)
  tie(3, xof(B, 19), yb, xtie, ym + dj, xof(M, 22), 10)
  tie(4, xof(M, 22), ym, xtie, ys + dj, xof(S, 29), 5)
  tie(5, xof(S, 29), ys, xs5, yc, xs5, none) // lands on feeder C's end
  wire((xof(C, 31), yc), (xs5, yc))
  dl((xof(C, 31), yc), (xs5, yc), [5 m], "north")
})
