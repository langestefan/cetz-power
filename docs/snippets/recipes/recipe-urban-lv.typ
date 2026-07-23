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
// Each feeder is one `bus-run` call over a station table (segment
// length [m], bus nr, device) at a length-proportional pitch, so bus
// positions follow from the cable data. Branches and ties reference
// the runs' buses by anchor (e.g. "m-16.mid"), never by coordinate.
#diagram(length: 1cm, {
  let flex = rgb("#29abe2") // the figure's cyan for flexible devices

  // ── layout constants ────────────────────────────────────────────
  let k = 0.048 // cm of feeder per metre of cable
  let lead = 0.45 // riser corner → first bus of a run
  let dbr = 0.45 // branch jogs step this far aside before turning
  let dj = 0.29 // jogs/ties leave or enter a tick this far off its row
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
  // length label — the segment form turns east/west labels upright itself
  let dl(a, b, c, sd) = note(a, b, c, side: sd, distance: 0.05, size: 5.5pt)
  // a point on a bus, and that bus' position carried to another row
  let X(b, dx: 0) = (rel: (dx, 0), to: b + ".mid")
  let atY(b, y, dx: 0) = (X(b, dx: dx), "|-", (0, y))
  // station devices: firm load, flexible load, PV panel
  let dev(kind) = info => {
    let p = (rel: (0, -eL), to: info.at)
    if kind == "pv" {
      pv-panel(info.name, p, elbow: 0.38, size: 0.2, aspect: 1.6, lead: 0.1)
    } else if kind == "f" {
      load(
        info.name,
        p,
        elbow: 0.26,
        size: 0.18,
        lead: 0.16,
        fill: flex,
        stroke: flex,
      )
    } else {
      load(info.name, p, elbow: 0.26)
    }
  }
  let (L, F, PV) = (dev("l"), dev("f"), dev("pv"))
  let rn(name, start, st, ..o) = bus-run(
    name,
    start,
    st,
    pitch: k,
    lead: lead,
    ..o,
  )
  // branch riser: leave a bus' body sideways at dy off its row, turn,
  // and climb to the sub-feeder's row (rotated length label)
  let riser(b, y, dy, yto, len) = {
    wire(atY(b, y + dy), atY(b, y + dy, dx: dbr), atY(b, yto, dx: dbr))
    dl(atY(b, y + dy, dx: dbr), atY(b, yto, dx: dbr), [#len m], "west")
  }
  // normally-open tie: run end → down column `col` through the switch
  // → into the destination bus' body (label on the destination side)
  let tie(i, bfrom, yfrom, col, ydest, bdest, len) = {
    let c(y) = (col, "|-", (0, y))
    wire(atY(bfrom, yfrom), c(yfrom), c(yfrom - g))
    wire(c(yfrom - g - sw), c(ydest), atY(bdest, ydest))
    if len != none { dl(c(ydest), atY(bdest, ydest), [#len m], "north") }
    switch("s" + str(i), c(yfrom - g), c(yfrom - g - sw))
    nl(c(yfrom - g - sw / 2), [S#i], "east", d: 0.24)
  }

  // ── substation: external grid → bus 1 → OLTC transformer → bus 2 ─
  external-grid("grid", (2.56, ym), angle: 90deg, size: 0.62)
  cetz.draw.content((2.15, ym + 0.8), align(center)[150 MVA,\ 10 kV])
  cetz.draw.content((2.15, ym - 0.85), align(center)[External\ Grid])
  wire((2.56, ym), (3.38, ym))
  wire((3.38, ym), (3.65, ym))
  transformer(
    "t12",
    (3.65, ym),
    (4.39, ym),
    radius: 0.18,
    distance: 0.2,
    oltc: true,
  )
  cetz.draw.content((4.02, ym - 0.66), [10/0.4 kV])
  wire((4.39, ym), (x2, ym))
  bus("1", (3.38, ym - 0.5), (3.38, ym + 0.5))
  nl((3.38, ym + 0.5), [1], "north")
  bus("2", (x2, yjc - 0.19), (x2, yja + 0.19))
  nl((x2, yja + 0.19), [2], "north")
  cetz.draw.content((2.4, 3.7), align(
    center,
  )[R = 0.641 Ω/km \ X = 0.085 Ω/km \ Cable capacity = 105 kVA])

  // ── the three feeders off bus 2 ──────────────────────────────────
  wire((x2, yja), (x2 + 0.4, yja), (x2 + 0.4, ya)) // 2 → feeder A
  dl((x2 + 0.4, yja), (x2 + 0.4, ya), [50 m], "west")
  wire((x2, yjc), (x2 + 0.4, yjc), (x2 + 0.4, yc)) // 2 → feeder C
  dl((x2 + 0.4, yjc), (x2 + 0.4, yc), [50 m], "west")
  rn(
    "a",
    (x2 + 0.4, ya),
    (
      (name: "3", device: L),
      (name: "4", length: 20, device: F),
      (name: "5", length: 30, device: PV),
      (name: "10", length: 25, device: F),
      (name: "11", length: 30, device: L),
      (name: "12", length: 25, device: PV),
    ),
  )
  rn(
    "m",
    (x2, ym),
    (
      (name: "13", length: 40, device: PV),
      (name: "14", length: 30, device: L),
      (name: "15", length: 25, device: F),
      (name: "16", length: 20, device: L),
      (name: "20", length: 25, device: PV, side: "south"), // 17-riser above
      (name: "21", length: 25, device: F),
      (name: "22", length: 20, device: L),
    ),
  )
  rn(
    "c",
    (x2 + 0.4, yc),
    (
      (name: "23", device: L),
      (name: "24", length: 25, device: F),
      (name: "25", length: 20, device: PV),
      (name: "26", length: 30, device: F),
      (name: "27", length: 20, device: L),
      (name: "30", length: 25, device: L),
      (name: "31", length: 30, device: L),
    ),
  )

  // ── the four sub-feeders, branching off by anchor ────────────────
  riser("a-5", ya, dj, ytop, 35)
  rn("t", atY("a-5", ytop, dx: dbr), (
    (name: "6", device: L),
    (name: "7", length: 20, device: F),
    (name: "8", length: 30, device: PV),
    (name: "9", length: 25, device: L),
  ))
  riser("m-16", ym, dj, yb, 30)
  rn("b", atY("m-16", yb, dx: dbr), (
    (name: "17", device: PV),
    (name: "18", length: 25, device: L),
    (name: "19", length: 30, device: F),
  ))
  riser("c-27", yc, dj, ys, 30)
  rn("s", atY("c-27", ys, dx: dbr), (
    (name: "28", device: F),
    (name: "29", length: 20, device: L),
  ))
  riser("c-30", yc, -0.15, yd, 25) // above 30's load elbow
  rn("d", atY("c-30", yd, dx: dbr), (
    (name: "32", device: PV),
    (name: "33", length: 30, device: L),
    (name: "34", length: 20, device: F),
  ))

  // ── normally-open ties S1..S5 along the right edge ───────────────
  let xtie = X("m-22", dx: tail) // shared S2/S3/S4 column
  tie(1, "t-9", ytop, X("t-9", dx: tail), ya + dj, "a-12", 30)
  tie(2, "a-12", ya, xtie, yb + dj, "b-19", 20)
  tie(3, "b-19", yb, xtie, ym + dj, "m-22", 10)
  tie(4, "m-22", ym, xtie, ys + dj, "s-29", 5)
  let xs5 = X("c-31", dx: tail)
  tie(5, "s-29", ys, xs5, yc, "c-31", none) // lands on feeder C's end
  wire(X("c-31"), (xs5, "|-", (0, yc)))
  dl(X("c-31"), (xs5, "|-", (0, yc)), [5 m], "north")
})
