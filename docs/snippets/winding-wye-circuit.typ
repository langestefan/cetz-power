#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Wye-connected three-phase current injection. Use the wye symbol
// in skeleton mode (`body: false`) — it draws no arms or labels of
// its own, but exposes `neutral` and `u`/`v`/`w` so the rest of the
// scene can hang off named anchors instead of raw coordinates.
#diagram(length: 1.1cm, {
  // Wye terminals at radius 1.2 around (1.0, 0):
  //   v → (1.00,  1.20)  — top
  //   u → (-0.04, -0.60) — lower-left
  //   w → (2.04, -0.60)  — lower-right
  //
  // The phase rails sit OUTSIDE the wye's bounding triangle so the
  // current-source bodies can't graze any rail. Short vertical
  // stubs drop each lower terminal to its rail.
  let cx  =  1.0
  let xL  = -0.7
  let xR  =  2.7
  let yA  =  1.2
  let yB  = -1.5
  let yC  = -2.3

  // ── Skeleton wye: anchors only, no geometry ──────────────────
  wye("y", (cx, 0), size: 1.2, body: false)

  // ── Three AC current sources radiating from the neutral ──────
  currentsource("ia", "y.neutral", "y.v", kind: "ac")
  currentsource("ib", "y.neutral", "y.u", kind: "ac")
  currentsource("ic", "y.neutral", "y.w", kind: "ac")
  ground("g", "y.neutral", width: 0.3, lead: 0.1)

  // Stubs from each lower terminal to its phase rail.
  cetz.draw.line("y.u", ("y.u", "|-", (0, yB)))
  cetz.draw.line("y.w", ("y.w", "|-", (0, yC)))

  // ── Phase rails ──────────────────────────────────────────────
  cetz.draw.line((xL, yA), (xR, yA))
  cetz.draw.line((xL, yB), (xR, yB))
  cetz.draw.line((xL, yC), (xR, yC))

  cetz.draw.content((xL - 0.1, yA), text(size: 8pt, [Phase A]), anchor: "east")
  cetz.draw.content((xL - 0.1, yB), text(size: 8pt, [Phase B]), anchor: "east")
  cetz.draw.content((xL - 0.1, yC), text(size: 8pt, [Phase C]), anchor: "east")

  // ── Bus-tap dots ─────────────────────────────────────────────
  cetz.draw.circle("y.v", radius: 0.06, stroke: none, fill: black)
  cetz.draw.circle(("y.u", "|-", (0, yB)), radius: 0.06, stroke: none, fill: black)
  cetz.draw.circle(("y.w", "|-", (0, yC)), radius: 0.06, stroke: none, fill: black)

  // ── Source labels (absolute coords, near each source body) ───
  cetz.draw.content((1.45, 0.6),  text(size: 9pt, $s_i^a$), anchor: "west")
  cetz.draw.content((0.05, 0.05), text(size: 9pt, $s_i^b$), anchor: "south-east")
  cetz.draw.content((1.95, 0.05), text(size: 9pt, $s_i^c$), anchor: "south-west")

  // ── Vertex / tap labels ──────────────────────────────────────
  cetz.draw.content("y.v",                       text(size: 9pt, [a]), anchor: "south", padding: 0.16)
  cetz.draw.content(("y.u", "|-", (0, yB)),      text(size: 9pt, [b]), anchor: "north", padding: 0.14)
  cetz.draw.content(("y.w", "|-", (0, yC)),      text(size: 9pt, [c]), anchor: "north", padding: 0.14)

  // ── Captions ─────────────────────────────────────────────────
  cetz.draw.content((cx, yA + 0.7),   text(size: 10pt, weight: "bold", [Bus-#emph[i]]))
  cetz.draw.content((cx, yC - 0.45),  text(size: 9pt, [Wye-Connection]))
})
