#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Two buses on the same set of three-phase rails: Bus-i is wye-
// connected (with an earthed neutral), Bus-j is delta-connected.
// Both windings are drawn in skeleton mode (`body: false`) — the
// symbol exposes its anchors without painting any geometry, and
// every component on top hangs off those named anchors. The dashed
// gap between the two halves is the conventional "rails continue
// elsewhere" notation, just like the original textbook diagram.
#diagram(length: 1.1cm, {
  // ── Common phase rail layout ─────────────────────────────────
  let xL       = -0.7
  let xWyeR    =  2.7
  let xDeltaL  =  3.9
  let xR       =  7.3
  let yA       =  1.2
  let yB       = -1.5
  let yC       = -2.3
  let wcx      =  1.0
  let dcx      =  5.6

  // ── Bus-i: wye on the left ───────────────────────────────────
  wye("y", (wcx, 0), size: 1.2, body: false)
  currentsource("ia", "y.neutral", "y.v", kind: "ac")
  currentsource("ib", "y.neutral", "y.u", kind: "ac")
  currentsource("ic", "y.neutral", "y.w", kind: "ac")
  ground("g", "y.neutral", width: 0.3, lead: 0.1)
  cetz.draw.line("y.u", ("y.u", "|-", (0, yB)))
  cetz.draw.line("y.w", ("y.w", "|-", (0, yC)))

  // ── Bus-j: delta on the right ────────────────────────────────
  delta("d", (dcx, 0), size: 1.2, body: false)
  currentsource("sab", "d.v", "d.u", kind: "ac")
  currentsource("sbc", "d.u", "d.w", kind: "ac")
  currentsource("sca", "d.w", "d.v", kind: "ac")
  cetz.draw.line("d.u", ("d.u", "|-", (0, yB)))
  cetz.draw.line("d.w", ("d.w", "|-", (0, yC)))

  // ── Phase rails: solid · dashed · solid ──────────────────────
  let dashed = (paint: black, thickness: 0.8pt, dash: "dashed")
  for y in (yA, yB, yC) {
    cetz.draw.line((xL,      y), (xWyeR,    y))
    cetz.draw.line((xWyeR,   y), (xDeltaL,  y), stroke: dashed)
    cetz.draw.line((xDeltaL, y), (xR,       y))
  }

  cetz.draw.content((xL - 0.1, yA), text(size: 8pt, [Phase A]), anchor: "east")
  cetz.draw.content((xL - 0.1, yB), text(size: 8pt, [Phase B]), anchor: "east")
  cetz.draw.content((xL - 0.1, yC), text(size: 8pt, [Phase C]), anchor: "east")

  // ── Bus-tap dots ─────────────────────────────────────────────
  for p in (
    "y.v", ("y.u", "|-", (0, yB)), ("y.w", "|-", (0, yC)),
    "d.v", ("d.u", "|-", (0, yB)), ("d.w", "|-", (0, yC)),
  ) {
    cetz.draw.circle(p, radius: 0.06, stroke: none, fill: black)
  }

  // ── Source labels ────────────────────────────────────────────
  cetz.draw.content((wcx + 0.45, 0.6),  text(size: 9pt, $s_i^a$), anchor: "west")
  cetz.draw.content((wcx - 0.95, 0.05), text(size: 9pt, $s_i^b$), anchor: "south-east")
  cetz.draw.content((wcx + 0.95, 0.05), text(size: 9pt, $s_i^c$), anchor: "south-west")

  cetz.draw.content((dcx - 0.95, 0.6),   text(size: 9pt, $s_j^(a b)$), anchor: "south-east")
  cetz.draw.content((dcx,        -0.95), text(size: 9pt, $s_j^(b c)$), anchor: "north", padding: 0.18)
  cetz.draw.content((dcx + 0.95, 0.6),   text(size: 9pt, $s_j^(c a)$), anchor: "south-west")

  // ── Vertex / tap labels ──────────────────────────────────────
  for (anchor, label) in (
    ("y.v",                       [a]),
    (("y.u", "|-", (0, yB)),      [b]),
    (("y.w", "|-", (0, yC)),      [c]),
    ("d.v",                       [a]),
    (("d.u", "|-", (0, yB)),      [b]),
    (("d.w", "|-", (0, yC)),      [c]),
  ) {
    let above = label == [a]
    cetz.draw.content(
      anchor,
      text(size: 9pt, label),
      anchor: if above { "south" } else { "north" },
      padding: 0.14,
    )
  }

  // ── Bus titles + connection captions ─────────────────────────
  cetz.draw.content((wcx, yA + 0.7),  text(size: 10pt, weight: "bold", [Bus-#emph[i]]))
  cetz.draw.content((wcx, yC - 0.45), text(size: 9pt, [Wye-Connection]))
  cetz.draw.content((dcx, yA + 0.7),  text(size: 10pt, weight: "bold", [Bus-#emph[j]]))
  cetz.draw.content((dcx, yC - 0.45), text(size: 9pt, [Delta-Connection]))
})
