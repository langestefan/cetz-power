#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 8pt)

// Phase to Phase, "Netten voor distributie van elektriciteit", fig. 2.8 —
// a distribution network with hoofdring (main ring), subring and uitloper
// (spur). A 150 kV rail feeds two 150/10 kV transformers onto a double
// 10 kV rail; the main ring leaves one rail section, runs across the top,
// and returns along the bottom; a subring nests inside it and a spur
// hangs off the bottom row. Connection points are `junction`s: filled =
// closed, hollow = open; the ring is operated open at the two
// "netopeningen" (open `switch` blades near the top-right node). The ×
// marks are the switchgear positions (`breaker(kind: "cross")`) at the
// transformer bays, the rail coupling and the feeder heads. Junctions
// are drawn after the conductors so open points mask the line beneath.
#diagram(length: 1cm, {
  let s = 0.016                        // image-pixel → cm (compression knob)
  let H = 340
  let P(x, y) = (x * s, (H - y) * s)   // flip y (image is y-down)

  let xb(n, p, ..o) = breaker("x" + str(n), p, kind: "cross", size: 0.22, ..o)

  // ── conductors ──────────────────────────────────────────────────
  cetz.draw.line(P(35, 74), P(73, 74), stroke: 0.8pt + red)    // HV bays
  cetz.draw.line(P(35, 160), P(73, 160), stroke: 0.8pt + red)
  wire(P(122, 74), P(206, 74))                                 // MV bays
  wire(P(122, 160), P(206, 160))
  wire(P(163, 202), P(206, 202))                               // rail coupling
  wire(P(163, 131), P(683, 131))                               // hoofdring, top
  wire(P(705, 131), P(720, 131), P(720, 245))                  // hoofdring, right
  wire(P(163, 245), P(720, 245))                               // hoofdring, bottom
  wire(P(406, 131), P(406, 174), P(677, 174), P(677, 157))     // subring
  wire(P(449, 245), P(449, 288), P(634, 288))                  // uitloper

  // ── rails ───────────────────────────────────────────────────────
  bus("hv", P(35, 46), P(35, 190), stroke: 1.8pt + red)
  bus("ms1", P(163, 46), P(163, 270))
  bus("ms2", P(206, 46), P(206, 270))

  // ── 150/10 kV transformers (HV winding red) ─────────────────────
  transformer("t1", P(73, 74), P(122, 74),
    radius: 0.23, distance: 0.28, primary-stroke: 0.8pt + red)
  transformer("t2", P(73, 160), P(122, 160),
    radius: 0.23, distance: 0.28, primary-stroke: 0.8pt + red)

  // ── switchgear (× = breaker position) ───────────────────────────
  xb(1, P(46, 74), stroke: 0.8pt + red); xb(2, P(46, 160), stroke: 0.8pt + red)
  xb(3, P(145, 74)); xb(4, P(145, 160))                        // MV sides
  xb(5, P(185, 202))                                           // rail coupling
  xb(6, P(222, 131)); xb(7, P(222, 245))                       // ring feeder heads
  xb(8, P(406, 148)); xb(9, P(449, 262))                       // subring / spur taps

  // ── the two netopeningen: open blades at the top-right node ─────
  switch("no1", P(684, 131), P(705, 131),      // blade = full 21 px gap:
    switch-length: 21 * s, pivot-radius: 0, open-angle: -30deg)
  switch("no2", P(677, 157), P(677, 138),      // no leftover stub slivers
    switch-length: 19 * s, pivot-radius: 0)

  // ── connection points (after the wires: open ones mask them) ────
  let closed = ((163, 74), (163, 131), (163, 202), (206, 202), (206, 245),
    (320, 131), (406, 131), (477, 131), (520, 131), (606, 131), (677, 131),
    (406, 174), (463, 174), (534, 174), (620, 174),
    (363, 245), (449, 245), (492, 245), (563, 245), (648, 245), (720, 245),
    (477, 288), (563, 288), (634, 288))
  for (i, q) in closed.enumerate() { junction("j" + str(i), P(..q)) }
  let open-pts = ((206, 74), (206, 131), (163, 160), (206, 160), (163, 245))
  for (i, q) in open-pts.enumerate() { junction("o" + str(i), P(..q), open: true) }

  // ── captions ────────────────────────────────────────────────────
  cetz.draw.content(P(108, 14), [Onderstation])
  cetz.draw.content(P(32, 28), [150 kV])
  cetz.draw.content(P(139, 28), [10 kV])
  cetz.draw.content(P(201, 28), [10 kV])
  cetz.draw.content(P(694, 108), [Netopeningen])
  cetz.draw.content(P(773, 182), [Hoofdring])
  cetz.draw.content(P(507, 200), [Subring])
  cetz.draw.content(P(533, 312), [Uitloper])
})
