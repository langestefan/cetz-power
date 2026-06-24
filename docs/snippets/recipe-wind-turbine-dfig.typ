#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 8.31: Model van een variabel toerental windturbine met een
// dubbelgevoede inductiegenerator (DFIG). The three-winding transformer
// splits the feed into a stator path (upper, to the generator) and a
// rotor path (lower, via the converter).
#diagram(length: 1.2cm, {
  // A labelled vertical bus with the two P/Q callouts under its bottom
  // corners — shared by both left-hand bars (cf. the fixed-speed recipe).
  let flow-bus(name, pos, title, left, right) = {
    bus(name, pos, length: 1.2, angle: 90deg, label: (content: align(center)[#title]))
    note(name + ".south-west", left, side: "south-west", distance: 0.10, text-align: center)
    note(name + ".south-east", right, side: "south-east", distance: 0.10, text-align: center)
  }

  // A "cable box": two short buses (Mastvoet ← → Gondel) closed top and
  // bottom by a 2-strand multi-wire, forming the rectangle of the figure.
  let cable-box(name, pos, mv, gv, len: 0.7, span: 2.6) = {
    bus(name + "-m", pos, length: len, angle: 90deg,
      label: (content: align(center)[#mv], anchor: "north", distance: 0.15))
    bus(name + "-g", (rel: (span, 0), to: pos), length: len, angle: 90deg,
      label: (content: align(center)[#gv], anchor: "north", distance: 0.15))
    multi-wire(name + "-m", name + "-g", count: 2)
  }

  let upper = 1.0
  let lower = -1.0

  // ── Left feed (main axis) ──────────────────────────────────────
  machine("M1", (0, 0), "V")
  flow-bus("b1", (1.6, 0), [Externe net \ 22,000 kV],
    [2,885 MW \ -0,287 Mvar], [-2,885 MW \ -0,287 Mvar])
  wire("M1.east", "b1.mid")

  flow-bus("b2", (4.2, 0), [Trafo MS \ 22,044 kV],
    [2,890 MW \ 0,258 Mvar], [-2,890 MW \ -0,258 Mvar])
  wire("b1.mid", "b2.mid")

  // Three-winding transformer: HV ← Trafo MS, LV → stator, TV → rotor.
  transformer3("t", (6.4, 0),
    label: (content: [23 / 0,96 / 0,69 kV], anchor: "east", distance: 0.3))
  wire("b2.mid", "t.hv")

  // ── Upper branch: stator ───────────────────────────────────────
  bus("b3", (2*4.2, 1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 0,947 kV], 
  ))
  elbow("t.lv", "b3.mid")
  bus("b5", (3*4.2, 1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Gondel \ 0,954 kV], 
  ))
  multi-wire("b3", "b5", count: 3, from: (0, 0.6), to: (0, 0.6))

  // // ── Upper branch: stator ───────────────────────────────────────
  bus("b4", (2*4.2, -1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 0,717 kV], anchor: "south", 
  ))
  elbow("t.tv", "b4.mid")
    bus("b6", (3*4.2, -1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Gondel \ 0,718 kV], anchor: "south", 
  ))
  multi-wire("b4", "b6", count: 2, from: (0, 0.6), to: (0, 0.6))
  
  // cable-box("cu", (8.4, upper), [Mastvoet \ 0,947 kV], [Gondel \ 0,954 kV])
  // elbow("t.lv", "cu-m.mid", corner: "v")
  // machine("G2", (rel: (1.6, 0), to: "cu-g.mid"), "G",
  //   label: (content: align(center)[2,500 MW \ 0,467 Mvar], anchor: "north", distance: 0.2))
  // wire("cu-g.mid", "G2.west")
  // note((7.3, upper), [2,463 MW \ 0,458 Mvar], side: "north", text-align: center)

  // // ── Lower branch: rotor + converter ────────────────────────────
  // cable-box("cl", (8.4, lower), [Mastvoet \ 0,717 kV], [Gondel \ 0,718 kV])
  // elbow("t.tv", "cl-m.mid", corner: "v")
  // note((7.3, lower), [0,500 MW \ 0,000 Mvar], side: "south", text-align: center)

  // // Converter — dashed box with a wedge (two lines) at its left.
  // let cv = (rel: (1.4, 0), to: "cl-g.mid")
  // wire("cl-g.mid", cv)
  // cetz.draw.rect((rel: (0, -0.5), to: cv), (rel: (1.7, 0.5), to: cv),
  //   stroke: (dash: "dashed", thickness: 0.6pt))
  // cetz.draw.line((rel: (0.15, 0), to: cv), (rel: (0.7, 0.3), to: cv),
  //   stroke: 0.7pt + black)
  // cetz.draw.line((rel: (0.15, 0), to: cv), (rel: (0.7, -0.3), to: cv),
  //   stroke: 0.7pt + black)
  // cetz.draw.content((rel: (0.85, 0.35), to: cv), [Converter])
  // note((rel: (-0.25, -0.12), to: cv), [-0,500 MW \ 0,000 Mvar],
  //   side: "south", text-align: center)

  // // ── Turbine envelope (dashed boundary) ─────────────────────────
  // // Encloses the two cable boxes; the generator and converter sit just
  // // outside on the right, with the feed lines crossing the boundary.
  // cetz.draw.rect((7.6, -2.2), (12.1, 2.2),
  //   stroke: (dash: "dashed", thickness: 0.6pt))
})
