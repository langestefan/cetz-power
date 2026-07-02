#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Delta-connected three-phase current injection. Skeleton mode on
// the delta symbol (`body: false`) exposes the three vertex anchors
// without drawing the triangle outline — each side is then a
// two-node `currentsource` between two vertex anchors, and the
// sources' built-in leads form the triangle for us.
#diagram(length: 1.1cm, {
  let cx = 1.0
  let xL = -0.7
  let xR = 2.7
  let yA = 1.2 // matches d.v.y
  let yB = -1.5 // below d.u and d.w (whose y = -0.6) so the
  let yC = -2.3 // bottom side of the triangle clears Phase B.

  // ── Skeleton delta: anchors only, no triangle ────────────────
  delta("d", (cx, 0), size: 1.2, body: false)

  // ── Three AC current sources, one per triangle side ──────────
  // The reference direction (in → out) walks the loop a → b → c → a.
  currentsource("sab", "d.v", "d.u", kind: "ac")
  currentsource("sbc", "d.u", "d.w", kind: "ac")
  currentsource("sca", "d.w", "d.v", kind: "ac")

  // Stubs from u and w down to their phase rails.
  cetz.draw.line("d.u", ("d.u", "|-", (0, yB)))
  cetz.draw.line("d.w", ("d.w", "|-", (0, yC)))

  // ── Phase rails ──────────────────────────────────────────────
  cetz.draw.line((xL, yA), (xR, yA))
  cetz.draw.line((xL, yB), (xR, yB))
  cetz.draw.line((xL, yC), (xR, yC))

  cetz.draw.content((xL - 0.1, yA), text(size: 8pt, [Phase A]), anchor: "east")
  cetz.draw.content((xL - 0.1, yB), text(size: 8pt, [Phase B]), anchor: "east")
  cetz.draw.content((xL - 0.1, yC), text(size: 8pt, [Phase C]), anchor: "east")

  // ── Vertex / bus-tap dots ────────────────────────────────────
  cetz.draw.circle("d.v", radius: 0.06, stroke: none, fill: black)
  cetz.draw.circle(
    ("d.u", "|-", (0, yB)),
    radius: 0.06,
    stroke: none,
    fill: black,
  )
  cetz.draw.circle(
    ("d.w", "|-", (0, yC)),
    radius: 0.06,
    stroke: none,
    fill: black,
  )

  // ── Source labels (absolute coords, near each side's mid) ────
  cetz.draw.content(
    (0.05, 0.6),
    text(size: 9pt, $s_j^(a b)$),
    anchor: "south-east",
  )
  cetz.draw.content(
    (1.0, -0.95),
    text(size: 9pt, $s_j^(b c)$),
    anchor: "north",
    padding: 0.18,
  )
  cetz.draw.content(
    (1.95, 0.6),
    text(size: 9pt, $s_j^(c a)$),
    anchor: "south-west",
  )

  // ── Vertex labels ────────────────────────────────────────────
  cetz.draw.content("d.v", text(size: 9pt, [a]), anchor: "south", padding: 0.16)
  cetz.draw.content(
    ("d.u", "|-", (0, yB)),
    text(size: 9pt, [b]),
    anchor: "north",
    padding: 0.14,
  )
  cetz.draw.content(
    ("d.w", "|-", (0, yC)),
    text(size: 9pt, [c]),
    anchor: "north",
    padding: 0.14,
  )

  // ── Captions ─────────────────────────────────────────────────
  cetz.draw.content((cx, yA + 0.7), text(
    size: 10pt,
    weight: "bold",
    [Bus-#emph[j]],
  ))
  cetz.draw.content((cx, yC - 0.45), text(size: 9pt, [Delta-Connection]))
})
