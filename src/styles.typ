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
    anchor: "north",   // where to attach the label on the symbol
    align: auto,       // text alignment; auto => opposite of anchor
    distance: 0.15,
    size: 8pt,
  ),

  // ── Wire style (plain connections between symbols) ───────────────
  wire: (
    stroke: 0.8pt + black,
  ),

  // ── Bus (busbar) ────────────────────────────────────────────────
  // Buses are length-defined, not symbol-sized.
  bus: (
    stroke: 1.8pt + black,  // thicker than wires
    length: 3,              // default length in cetz units
    taps: 1,                // default tap count
    label: (distance: 0.22),
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
    label: (anchor: "north", distance: 0.2),
  ),

  // ── Load (arrow) ────────────────────────────────────────────────
  load: (
    size: 0.28,
    stroke: 0.8pt + black,
    fill: black,            // solid filled triangle — the conventional form
    lead: 0.25,             // gap between bus / connection point and arrow base
    // Labels sit directly below the arrow tip by default.
    label: (anchor: "south", distance: 0.1),
  ),

  // ── Photovoltaic panel ──────────────────────────────────────────
  "pv-panel": (
    size: 0.35,             // panel width
    aspect: 1.6,             // height / width ratio
    stroke: 0.8pt + black,
    fill: none,             // panel body fill
    "triangle-fill": none,  // inner triangle fill (set to `black` for filled arrow)
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

  // ── External grid / infinite bus ────────────────────────────────
  grid: (
    size: 0.9,
    stroke: 0.8pt + black,
    fill: none,
    distance: 0.2,          // lead from connection point to symbol
    "line-count": 2,        // hatching density
    label: (anchor: "north", distance: 0.2),
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
