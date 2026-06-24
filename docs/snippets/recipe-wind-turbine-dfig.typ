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

  // ── Lower branch: rotor (Mastvoet → Gondel cable box) ──────────
  bus("b4", (2*4.2, -1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 0,717 kV], anchor: "south",
  ))
  elbow("t.tv", "b4.mid")
    bus("b6", (3*4.2, -1.0), length: 0.6, angle: 90deg, label: (
    content: align(center)[Gondel \ 0,718 kV], anchor: "north",
  ))
  multi-wire("b4", "b6", count: 2, from: (0, 0.6), to: (0, 0.6))
  note((7.0, -1.0), [0,500 MW \ 0,000 Mvar], side: "south", 
    text-align: center)

  // Converter 
  cetz.draw.rect((14.1, -1.65), (16.0, -0.35), name: "conv",
    stroke: (dash: "dashed", thickness: 0.6pt)
  )
  cetz.draw.content("conv.north", anchor: "north", padding: 0.1, [Converter])

  // Generator on the stator path.
  machine("G2", ("conv.center", "|-", "b5.mid"), "G",
    label: (content: align(center)[2,500 MW \ 0,467 Mvar], anchor: "north", distance: 0.2))
  wire("b5.mid", "G2.west")
  note((7.0, 1.0), [2,463 MW \ 0,458 Mvar], side: "north", 
    text-align: center)

  wire("conv.north", "G2.south",  stroke: (dash: "dashed", thickness: 0.6pt))

  // Converter on the rotor path — a dashed rectangle with a wedge whose
  // right side IS the box's left edge (the two lines land on its NW / SW
  // corners).
  let apex = (13.6, -1.0)
  wire("b6.mid", apex)

  // Wedge
  cetz.draw.line(apex, (rel: (0, -0.32), to: "conv.north-west"), 
    stroke: 0.7pt + black)
  cetz.draw.line(apex, (rel: (0, 0.32), to: "conv.south-west"), 
    stroke: 0.7pt + black)

  note((13.2, -1.1), [-0,500 MW \ 0,000 Mvar], side: "south", 
    text-align: center)

  // ── Envelope (dashed boundary) ─────────────────────────
  cetz.draw.rect((12.0, -2.0), (16.2, 2.2),
    stroke: (dash: "dashed", thickness: 0.6pt))
})
