#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 8.31: Model van een variabel toerental windturbine met een
// dubbelgevoede inductiegenerator (DFIG). The three-winding transformer
// splits the feed into a stator path (upper, to the generator) and a
// rotor path (lower, via the converter).
#diagram(length: 1.2cm, {
  // ── Layout parameters ──────────────────────────────────────────
  // Each column is placed a horizontal distance from the previous one
  // (so tweaking one gap shifts everything downstream). The two branches
  // sit ±`by` above/below the main axis.
  let by     = 1.0    // branch offset: stator at +by, rotor at −by
  let d-net  = 1.6    // V → Externe-net bus
  let d-mv   = 2.6    // Externe-net → Trafo-MS bus
  let d-tx   = 2.2    // Trafo-MS → transformer
  let d-mast = 2.0    // transformer → Mastvoet buses
  let d-gond = 2.5    // Mastvoet → Gondel buses (cable-box span)
  let d-conv = 1.5    // Gondel → converter left edge
  let blen   = 0.6    // cable-box bus length
  let cw     = 1.9    // converter box width
  let ch     = 1.3    // converter box height
  let dashed = (dash: "dashed", thickness: 0.6pt)

  // A labelled vertical bus with two P/Q callouts under its bottom corners.
  let flow-bus(name, pos, title, left, right) = {
    bus(name, pos, length: 1.2, angle: 90deg, label: (content: align(center)[#title]))
    note(name + ".south-west", left, side: "south-west", distance: 0.10, text-align: center)
    note(name + ".south-east", right, side: "south-east", distance: 0.10, text-align: center)
  }

  // ── Left feed (main axis) — each bus a gap right of the last ────
  machine("M1", (0, 0), "V")
  flow-bus("b1", (rel: (d-net, 0), to: "M1"), [Externe net \ 22,000 kV],
    [2,885 MW \ -0,287 Mvar], [-2,885 MW \ -0,287 Mvar])
  wire("M1.east", "b1.mid")

  flow-bus("b2", (rel: (d-mv, 0), to: "b1.mid"), [Trafo MS \ 22,044 kV],
    [2,890 MW \ 0,258 Mvar], [-2,890 MW \ -0,258 Mvar])
  wire("b1.mid", "b2.mid")

  // Three-winding transformer: HV ← Trafo MS, LV → stator, TV → rotor.
  // Aim the secondaries straight up / down so the branch wires leave the
  // LV / TV circles perpendicular (the elbows rise vertically first, then
  // turn into the cable boxes).
  transformer3("t", (rel: (d-tx, 0), to: "b2.mid"),
    lv-angle: 90deg, tv-angle: -90deg,
    label: (content: [23 / 0,96 / 0,69 kV], anchor: "east", distance: 0.3))
  wire("b2.mid", "t.hv")

  // ── Upper branch: stator ───────────────────────────────────────
  bus("b3", (rel: (d-mast, by), to: "t.center"), length: blen, angle: 90deg,
    label: (content: align(center)[Mastvoet \ 0,947 kV]))
  elbow("t.lv", "b3.mid", corner: "v")
  bus("b5", (rel: (d-gond, 0), to: "b3.mid"), length: blen, angle: 90deg,
    label: (content: align(center)[Gondel \ 0,954 kV]))
  multi-wire("b3", "b5", count: 3, from: (0, 0.6), to: (0, 0.6))
  note((rel: (-d-mast / 2, 0), to: "b3.mid"), [2,463 MW \ 0,458 Mvar],
    side: "north", text-align: center)

  // ── Lower branch: rotor (Mastvoet → Gondel cable box) ──────────
  bus("b4", (rel: (d-mast, -by), to: "t.center"), length: blen, angle: 90deg,
    label: (content: align(center)[Mastvoet \ 0,717 kV], anchor: "south"))
  elbow("t.tv", "b4.mid", corner: "v")
  bus("b6", (rel: (d-gond, 0), to: "b4.mid"), length: blen, angle: 90deg,
    label: (content: align(center)[Gondel \ 0,718 kV], anchor: "north"))
  multi-wire("b4", "b6", count: 2, from: (0, 0.6), to: (0, 0.6))
  note((rel: (-d-mast / 2, 0), to: "b4.mid"), [0,500 MW \ 0,000 Mvar],
    side: "south", text-align: center)

  // ── Converter (rotor path) ─────────────────────────────────────
  // Box placed `d-conv` right of the Gondel bus; wedge tip 0.5 left of
  // the box, its base on the box's left edge (lines into NW / SW corners).
  cetz.draw.rect((rel: (d-conv, -ch / 2), to: "b6.mid"),
    (rel: (d-conv + cw, ch / 2), to: "b6.mid"),
    name: "conv", stroke: dashed)
  cetz.draw.content("conv.north", anchor: "north", padding: 0.1, [Converter])

  let apex = (rel: (-0.5, 0), to: "conv.west")
  wire("b6.mid", apex)
  cetz.draw.line(apex, (rel: (0, -0.32), to: "conv.north-west"), stroke: 0.7pt + black)
  cetz.draw.line(apex, (rel: (0, 0.32), to: "conv.south-west"), stroke: 0.7pt + black)
  note((rel: (0.6, -0.1), to: "b6.mid"), [-0,500 MW \ 0,000 Mvar],
    side: "south", text-align: center)

  // ── Generator (stator path) ────────────────────────────────────
  // Horizontally over the converter centre, vertically on the stator bus.
  machine("G2", ("conv.center", "|-", "b5.mid"), "G",
    label: (content: align(center)[2,500 MW \ 0,467 Mvar], anchor: "north", distance: 0.2))
  wire("b5.mid", "G2.west")
  wire("conv.north", "G2.south", stroke: dashed)

  // ── Turbine envelope (dashed boundary) ─────────────────────────
  cetz.draw.rect(
    (rel: (-0.6, -1.0), to: "b6.mid"),
    (rel: (0.2, 1.2), to: ("conv.east", "|-", "b5.mid")),
    stroke: dashed)
})
