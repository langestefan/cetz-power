#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

// MV radial distribution feeder — the network used for numerical simulation of
// FOR analysis in A.H. Javed, "Reactive Power Management and Flexibility
// Aggregation in Active Distribution Networks" (TU Eindhoven, 2026), Fig. 5.10.
// A grid source feeds a horizontal main
// feeder carrying node buses v1, v2, v4, v9, … v21; six of those tap up to an
// upper node (v3, v10, v12, v15, v18, v22); a sub-feeder branches off v4 to
// v5/v6/v8 with v7 hanging below v6. Every node except v1 carries a down load.
// Each node is a vertical busbar: the feeder taps its centre, loads leave its
// lower body with an L-bend (across, then down), risers its upper body — every
// tap is interior, never an outer edge. Layout digitised from the figure.
#diagram(length: 1cm, {
  let s = 0.01
  let H = 767
  let P = pixel-map(s, height: H)
  let ym = 304
  let yu = 108
  let ys = 497 // main / upper / sub-feeder rows
  let th = 30 // node-bus half height (px)
  let dyr = 15 // riser tap: upper interior
  let dy1 = 15 // single load tap: lower interior
  let dy_up = 10
  let dy_lo = 20 // dual node: branch (upper body) / load (lower body)
  let dbr = 50 // horizontal run every branch takes before it turns

  let nl(p, n, sd) = note(
    p,
    text(size: 7pt)[$v_(#n)$],
    side: sd,
    distance: 0.08,
  )
  let tick(name, x, y) = bus(name, P(x, y - th), P(x, y + th))
  // load leaves the bus body perpendicular, then bends down (L-bend)
  let dload(name, x, y, dy) = load(
    name,
    P(x, y + dy),
    elbow: 0.13,
    lead: 0.18,
    size: 0.17,
  )

  // ── node data ───────────────────────────────────────────────────
  let mains = (
    ("1", 291),
    ("2", 393),
    ("4", 495),
    ("9", 589),
    ("11", 690),
    ("13", 792),
    ("14", 887),
    ("16", 991),
    ("17", 1089),
    ("19", 1188),
    ("20", 1286),
    ("21", 1386),
  )
  let uppers = (
    ("3", 496, 393),
    ("10", 687, 589),
    ("12", 794, 690),
    ("15", 991, 887),
    ("18", 1187, 1089),
    ("22", 1385, 1286),
  )
  let subs = (("5", 593), ("6", 694), ("8", 795))

  // ── source + main feeder ────────────────────────────────────────
  // the grid supply is the stock external-grid symbol, drawn as a wide
  // rectangle (width ≠ height) sitting on its bottom edge, no lead stub.
  external-grid("grid", P(130.5, 346), width: 1.35, height: 0.84, distance: 0)
  wire("grid.east", P(1386, ym)) // taps every node at its centre

  // ── main nodes: bus + label + load (v1 none; v4 dual, handled below) ──
  for (n, x) in mains {
    tick("v" + n, x, ym)
    nl(P(x, ym - th), n, "north")
    if n != "1" and n != "4" { dload("l" + n, x, ym, dy1) }
  }

  // ── upper taps: leave the main bus upper-interior, up, into upper-bus centre ──
  for (n, ux, mx) in uppers {
    let rx = mx + dbr // same horizontal run for every branch
    wire(P(mx, ym - dyr), P(rx, ym - dyr), P(rx, yu), P(ux, yu))
    tick("v" + n, ux, yu)
    nl(P(ux, yu - th), n, "north")
    dload("l" + n, ux, yu, dy1)
  }

  // ── v4: load + sub-feeder branch (two interior bottom taps) ─────
  dload("l4", 495, ym, dy_lo)
  wire(P(495, ym + dy_up), P(495 + dbr, ym + dy_up), P(495 + dbr, ys)) // branch (upper) above load — no cross, same run
  wire(P(495 + dbr, ys), P(795, ys)) // sub-feeder line (taps v5/v6/v8)
  for (n, x) in subs {
    tick("v" + n, x, ys)
    nl(P(x, ys - th), n, "north")
    if n != "6" { dload("l" + n, x, ys, dy1) }
  }
  // ── v6: load + branch down to v7 (two interior bottom taps) ─────
  dload("l6", 694, ys, dy_lo)
  wire(P(694, ys + dy_up), P(694 + dbr, ys + dy_up), P(694 + dbr, 622), P(
    796,
    622,
  )) // branch above load — no cross, same run
  tick("v7", 796, 620)
  nl(P(796, 620 - th), "7", "north")
  dload("l7", 796, 620, dy1)
})
