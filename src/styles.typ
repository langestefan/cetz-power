// Default styles for all cetz-power symbols.
//
// Everything is keyed under `ctx.style.cetz-power`. To override globally:
//
//     cetz.draw.set-style(cetz-power: (stroke: 1.2pt))
//
// Or per-symbol family:
//
//     cetz.draw.set-style(cetz-power: (transformer: (radius: 0.4)))
//
// Individual calls can override with named arguments, e.g. `stroke: red`.

#let default = (
  // Base defaults that cascade down to each symbol unless overridden.
  stroke: 0.8pt + black,
  fill: none,
  scale: 1.0,
  // Default label style. Each symbol can override its label sub-dict.
  label: (
    content: none,
    anchor: "north", // where to attach the label on the symbol
    align: auto, // text alignment; auto => opposite of anchor
    distance: 0.15,
    size: 8pt,
  ),

  // ── Wire style (plain connections between symbols) ───────────────
  wire: (
    stroke: 0.8pt + black,
    // Dash pattern applied when a wire is drawn with `kind: "cable"`
    // (any Typst dash spec: "dashed", "dotted", an array pattern, …).
    "cable-dash": "dashed",
  ),

  // ── Bus (busbar) ────────────────────────────────────────────────
  // Buses are length-defined, not symbol-sized.
  bus: (
    stroke: 1.8pt + black, // thicker than wires
    length: 3, // default length in cetz units
    taps: 1, // default tap count
    label: (distance: 0.22),
  ),

  // ── Junction (connection point) ─────────────────────────────────
  // Small circle on a conductor: filled = closed connection, hollow
  // (`open: true`) = open point / netopening. `fill: auto` resolves
  // to the stroke paint when closed and white when open.
  junction: (
    radius: 0.09,
    open: false,
    fill: auto,
    stroke: 0.8pt + black,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Transformer ─────────────────────────────────────────────────
  // "distance" is the centre-to-centre spacing of the two circles.
  // Default ratio d/r ≈ 0.78 gives the tight, clearly-overlapping
  // circles of the conventional two-winding symbol.
  transformer: (
    radius: 0.45,
    distance: 0.35,
    stroke: 0.8pt + black,
    fill: none,
    // In-circle vector-group marks: `vector: ("delta", "wye")` draws
    // the winding glyphs inside the circles (in-side, out-side); they
    // stay upright under rotation.
    vector: none,
    "vector-size": 0.5, // glyph reach as a fraction of the radius
    "vector-stroke": auto, // auto => follow each winding's stroke
    // On-load tap changer: `oltc: true` draws the thin diagonal arrow
    // through both circles (lower-left → upper-right).
    oltc: false,
    "oltc-stroke": 0.7pt + black,
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Autotransformer ─────────────────────────────────────────────
  // Single-line IEC form: one circle (common winding) with the
  // through-conductor looping around it (series winding).
  autotransformer: (
    radius: 0.32,
    stroke: 0.8pt + black,
    fill: none,
    oltc: false,
    "oltc-stroke": 0.7pt + black,
    label: (anchor: "south", distance: 0.15),
  ),

  // ── Three-winding transformer ───────────────────────────────────
  // Trefoil of three overlapping circles (HV left, LV upper-right,
  // TV lower-right). "distance" is the centre-to-centre spacing of the
  // equilateral cluster; the default keeps the three circles clearly
  // distinct while still overlapping.
  transformer3: (
    radius: 0.32,
    distance: 0.42,
    stroke: 0.8pt + black,
    fill: none,
    // In-circle vector-group marks: three entries (hv, lv, tv).
    vector: none,
    "vector-size": 0.5,
    "vector-stroke": auto,
    // Connection points: each terminal exits its circle at the given
    // angle (CCW from +x); `lead` draws a stub of that length out to the
    // anchor (0 = flush on the circle edge).
    lead: 0,
    "hv-angle": 180deg,
    "lv-angle": 60deg,
    "tv-angle": -60deg,
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Current transformer (instrument) ────────────────────────────
  // Circle on the conductor, primary straight through. Secondary taps
  // a compass anchor (they sit on the circle).
  ct: (
    radius: 0.16,
    stroke: 0.8pt + black,
    fill: none,
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Voltage transformer (instrument) ────────────────────────────
  // Small two-winding transformer hanging below a tap point.
  vt: (
    radius: 0.14,
    distance: 0.14,
    lead: 0.15,
    stroke: 0.8pt + black,
    fill: none,
    label: (anchor: "east", distance: 0.15),
  ),

  // ── Load (arrow) ────────────────────────────────────────────────
  load: (
    size: 0.28,
    stroke: 0.8pt + black,
    fill: black, // solid filled triangle — the conventional form
    lead: 0.25, // gap between bus / connection point and arrow base
    // Labels sit directly below the arrow tip by default.
    label: (anchor: "south", distance: 0.1),
  ),

  // ── Photovoltaic panel ──────────────────────────────────────────
  "pv-panel": (
    size: 0.35, // panel width
    aspect: 1.6, // height / width ratio
    stroke: 0.8pt + black,
    fill: none, // panel body fill
    "triangle-fill": none, // inner triangle fill (set to `black` for filled arrow)
    "triangle-height": 0.45, // triangle height as fraction of panel height
    lead: 0.25,
    label: (anchor: "south", distance: 0.1),
  ),

  // ── Machine (rotating machine / source / meter) ────────────────
  // A stroked circle with an optional letter inside. Used for V
  // (voltage source), A (asynchronous machine), G (generator), etc.
  machine: (
    radius: 0.3,
    stroke: 0.8pt + black,
    fill: none,
    "letter-size": 10pt,
    label: (anchor: "north", distance: 0.3),
  ),

  // ── Device block ────────────────────────────────────────────────
  // Labelled rectangular box for "black box" devices (wind, BESS, PV,
  // controllers). `body` is the content centred inside the box; the
  // regular `label` dict captions it on the outside.
  block: (
    stroke: 0.8pt + black,
    fill: none,
    width: 1.15,
    height: 0.55,
    body: none,
    "body-size": 8pt,
    label: (anchor: "south", distance: 0.15),
  ),

  // ── Generation plant (wind / PV / BESS combinations) ────────────
  // Pictogram box for renewable plants. `kind` names the technology
  // mix ("wind", "pv-bess", "wind-pv-bess", …); a token may carry an
  // icon-style number (wind2/wind3 = park with two/three turbines,
  // pv2 = filled panel, pv3 = panel park, bess2 = charged-battery
  // outline). `variant` numbers the rendering: 1 = compartment box,
  // 2 = plain box, 3 = bare icons, 4/5 = single-square composites
  // (all technologies overlapping in one square).
  plant: (
    stroke: 0.8pt + black,
    fill: none,
    kind: "wind",
    variant: 1,
    cell: 0.7, // width of one technology cell
    height: 0.7, // enclosure height
    "icon-scale": 0.85, // icon size as a fraction of the cell
    "icon-stroke": auto, // auto => follow `stroke`
    "icon-fill": auto, // hub dot paint; auto => stroke paint
    label: (anchor: "south", distance: 0.15),
  ),

  // ── Battery ─────────────────────────────────────────────────────
  // IEC cell(s): long (positive) plate over a short (negative) one,
  // repeated `cells` times. Two-pole by default; override
  // `lead-out: 0` for the single-pole form.
  battery: (
    stroke: 0.8pt + black,
    cells: 1,
    "long-width": 0.5,
    "short-width": 0.22,
    gap: 0.12,
    "cell-gap": 0.18,
    "lead-in": 0.3,
    "lead-out": 0.3,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Capacitor ────────────────────────────────────────────────────
  // Two parallel plates with a lead at each end (the symmetric, two-
  // pole textbook form). For a single-line shunt with no ground return,
  // override `lead-out: 0` per call.
  capacitor: (
    stroke: 0.8pt + black,
    "plate-width": 0.5,
    "plate-gap": 0.12,
    "lead-in": 0.3,
    "lead-out": 0.3,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Resistor ─────────────────────────────────────────────────────
  // IEC rectangular form. Symmetric two-pole by default; override
  // `lead-out: 0` for the single-pole / shunt form.
  resistor: (
    stroke: 0.8pt + black,
    fill: none,
    width: 0.3,
    length: 0.7,
    "lead-in": 0.2,
    "lead-out": 0.2,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Inductor ─────────────────────────────────────────────────────
  // IEEE looped form: a chain of semicircular bumps. Symmetric two-
  // pole by default; override `lead-out: 0` for the single-pole form.
  inductor: (
    stroke: 0.8pt + black,
    bumps: 4,
    "bump-radius": 0.1,
    "lead-in": 0.2,
    "lead-out": 0.2,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Diode ────────────────────────────────────────────────────────
  // Triangle pointing in current direction with a perpendicular bar
  // at the cathode. Symmetric two-pole by default; default fill is
  // `none` for the hollow form (pass `fill: black` for the filled
  // textbook version).
  diode: (
    stroke: 0.8pt + black,
    fill: none,
    width: 0.4,
    height: 0.4,
    "lead-in": 0.15,
    "lead-out": 0.15,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Lightning bolt ──────────────────────────────────────────────
  // Zigzag between two endpoints, with an arrowhead at `out` by
  // default. Used to mark phase-to-ground faults / surge events in
  // single-line diagrams.
  bolt: (
    stroke: 1.2pt + black,
    segments: 4,
    amplitude: 0.12,
    arrow: true,
    "arrow-color": black,
    label: (anchor: "east", distance: 0.15),
  ),

  // ── Ground ───────────────────────────────────────────────────────
  // Reference point. Default kind is the IEC earth-electrode (three
  // horizontal lines decreasing in width). `kind: "chassis"` uses a
  // hatched bar; `kind: "signal"` uses a filled downward triangle.
  ground: (
    stroke: 0.8pt + black,
    lead: 0.18,
    width: 0.4,
    kind: "earth",
    label: (anchor: "south", distance: 0.1),
  ),

  // ── Switch / disconnector ───────────────────────────────────────
  // Two-pin switch with a movable bar between them. Default is OPEN
  // (bar tilted up); `closed: true` shows the bar horizontal.
  switch: (
    stroke: 0.8pt + black,
    "switch-length": 0.45,
    "pivot-radius": 0.045,
    "open-angle": 30deg,
    closed: false,
    // Earthing switch: draw the IEC earth-electrode mark at the `out`
    // end (three lines of decreasing length, perpendicular to the axis).
    earthing: false,
    "earth-width": 0.3,
    "earth-gap": 0.07,
    label: (anchor: "north", distance: 0.18),
  ),

  // ── Circuit breaker ─────────────────────────────────────────────
  // Square box on a wire (kind: "square"), or the compact "×" marker
  // used in network-overview diagrams (kind: "cross").
  breaker: (
    stroke: 0.8pt + black,
    fill: none,
    size: 0.3,
    kind: "square",
    // Content centred in the square — `[R]` marks a recloser, `[S]` a
    // sectionalizer. Stays upright under rotation.
    body: none,
    "body-size": 7pt,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Surge arrester ──────────────────────────────────────────────
  // Rectangle on the conductor with a filled arrow inside pointing
  // toward the earthed side (IEC convention). `head-fill: auto`
  // resolves to the stroke paint.
  arrester: (
    stroke: 0.8pt + black,
    fill: none,
    length: 0.6,
    width: 0.26,
    "head-length": 0.2,
    "head-width": 0.15,
    "head-fill": auto,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Protection relay ────────────────────────────────────────────
  // Function box carrying the ANSI device number / IEC function code
  // ("50/51", "87T", "U<"). `kind: "box"` (IEC rectangle, default) or
  // `"circle"` (ANSI device circle). Wire the trip command to a
  // breaker with a dashed flow-arrow.
  relay: (
    stroke: 0.8pt + black,
    fill: none,
    kind: "box",
    width: 0.52,
    height: 0.36,
    radius: 0.24,
    "code-size": 7pt,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Fuse ────────────────────────────────────────────────────────
  // Rectangle with a wire through it (IEC convention).
  fuse: (
    stroke: 0.8pt + black,
    fill: none,
    length: 0.6,
    width: 0.22,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── Voltage source ──────────────────────────────────────────────
  // Two-node circle with internal markings. `kind: "dc"` draws +/−;
  // "ac" / "sin" / "tri" / "saw" / "rect" draw the matching waveform.
  voltagesource: (
    stroke: 0.8pt + black,
    fill: none,
    radius: 0.3,
    kind: "dc",
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Current source ──────────────────────────────────────────────
  // Two-node circle with an internal arrow showing the in→out
  // reference direction. `kind: "ac"` overlays a small sine wave.
  currentsource: (
    stroke: 0.8pt + black,
    fill: none,
    radius: 0.3,
    kind: "dc",
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Power-electronic converter ──────────────────────────────────
  // IEC box-with-diagonal. `kind: "<in>-<out>"` picks the glyph in
  // each triangle: "ac-dc" (rectifier), "dc-ac" (inverter), "ac-ac",
  // "dc-dc". The `in` glyph sits in the upper-left triangle.
  converter: (
    stroke: 0.8pt + black,
    fill: none,
    size: 0.7,
    kind: "ac-dc",
    label: (anchor: "south", distance: 0.15),
  ),

  // ── Control junctions (block-diagram notation) ──────────────────
  // Summing point: circle with an inscribed "+" spanning the circle.
  adder: (
    radius: 0.16,
    stroke: 0.8pt + black,
    fill: none,
    label: (anchor: "north", distance: 0.15),
  ),
  // Mixer / multiplier: circle with an inscribed "×".
  mixer: (
    radius: 0.16,
    stroke: 0.8pt + black,
    fill: none,
    label: (anchor: "north", distance: 0.15),
  ),

  // ── External grid / infinite bus ────────────────────────────────
  grid: (
    size: 0.9,
    // width/height override `size` per-axis to draw a rectangular grid;
    // `none` means "fall back to size" (a square).
    width: none,
    height: none,
    stroke: 0.8pt + black,
    fill: none,
    distance: 0.2, // lead from connection point to symbol
    "line-count": 2, // hatching density
    // Optional fill colour for the inside of the cross-hatched square
    // (drawn beneath the diagonals so the chord lines remain visible
    // on top). Distinct from `fill` only in name — `background` reads
    // more naturally when the intent is "tint the area behind the
    // hatching" rather than "fill a shape".
    background: none,
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Winding configurations (transformer vector groups) ─────────
  // Three primitives — `delta`, `wye`, `zigzag` — sharing a single
  // family dict. `size` is the radius from the centre to each of
  // the three terminals: the circumradius of the delta triangle,
  // the arm length of the wye, and the total reach of each zigzag
  // arm. Default orientation matches IEC clock 0 (the "V" terminal
  // at the top, "U" bottom-left, "W" bottom-right). Rotate with the
  // standard `angle:` arg — e.g. `angle: -150deg` for clock 5.
  winding: (
    stroke: 0.8pt + black,
    fill: none,
    size: 0.6,
    "label-size": 8pt,
    "label-distance": 0.18,
    // Per-terminal labels in (U, V, W) order — uppercase for the
    // primary winding by convention. Pass lowercase via override
    // (`terminals: ("u", "v", "w")`) when drawing the secondary.
    terminals: ("U", "V", "W"),
    // Per-symbol label dict (the OUTSIDE caption — not the per-terminal
    // labels). Default sits north of the symbol.
    label: (anchor: "north", distance: 0.28),
    // Zigzag-specific: how far along the arm the kink sits, as a
    // fraction of `size`. 0.5 = halfway. Smaller values → kink closer
    // to the centre.
    "zigzag-kink": 0.5,
    // Zigzag-specific: lateral offset of the kink from the arm axis,
    // expressed as a fraction of `size`. Larger = wider zigzag.
    "zigzag-offset": 0.18,
    // Skeleton mode — when `false`, the symbol exposes its anchors
    // (terminals, mid-arm/side, neutral, cardinals) but draws no
    // geometry or terminal labels. Lets callers use the symbol as a
    // placement scaffold and overlay their own components without
    // visual collisions.
    body: true,
  ),

  // ── Debug (show anchors, like cetz) ────────────────────────────
  debug: (
    enabled: false,
    radius: 0.05,
    stroke: red,
    fill: red,
    font-size: 5pt,
  ),
)
