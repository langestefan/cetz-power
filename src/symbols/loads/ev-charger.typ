// EV charger — electric-vehicle charging pictogram: a charging pedestal
// (column with a lightning bolt, connector holster and base plinth), a
// side-view car, or both with the charging cable looping between them.
// `kind:` picks the composition; the default box gives the same device-
// box look as `factory` / `plant` / `block`.
//
// Single-terminal: the lead drops from the connection point onto the
// box top (or, bare, onto the pedestal top / car roof). Use `elbow:`
// to route the lead as an L-shape.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

#let _ev-kinds = (
  "ev-charger": (ev: true, charger: true),
  "charger-ev": (ev: true, charger: true),
  "evcharger": (ev: true, charger: true),
  "both": (ev: true, charger: true),
  "charger": (ev: false, charger: true),
  "ev": (ev: true, charger: false),
  "car": (ev: true, charger: false),
)

/// EV charging station / electric vehicle.
///
/// - name (str): CeTZ group name
/// - kind (str): composition — `"ev-charger"` (car + pedestal + cable,
///   the default), `"charger"` (pedestal only), `"ev"` (car only)
/// - height (float): pedestal height; every other part scales with it
/// - lead (float): stub from connection point to the symbol top
/// - elbow (float): if non-zero, route the lead as an L-shape — step
///   horizontally by `elbow` units, then drop down to the symbol
/// - box (bool): enclose the pictogram in a rectangular device box
/// -> content
#let ev-charger(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  let lead = overrides.at("lead", default: none)
  if lead != none { let _ = overrides.remove("lead") }
  let elbow = overrides.at("elbow", default: none)
  if elbow != none { let _ = overrides.remove("elbow") }

  let draw(ctx, positions, style) = {
    let h = style.at("height", default: 0.7)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let boxed = style.at("box", default: true)
    let kind = lower(style.at("kind", default: "ev-charger"))
      .replace(" ", "")
      .replace("_", "-")
    assert(
      kind in _ev-kinds,
      message: "ev-charger(): unknown kind "
        + repr(kind)
        + " (expected \"ev-charger\", \"charger\" or \"ev\")",
    )
    let has-ev = _ev-kinds.at(kind).ev
    let has-charger = _ev-kinds.at(kind).charger
    let l = if lead != none { lead } else { style.at("lead", default: 0.25) }
    let e = if elbow != none { elbow } else { 0 }

    // Lead from origin (connection point) down to the symbol top. Same
    // shape rules as `load`: straight if elbow == 0, L-shape otherwise.
    if e == 0 {
      if l > 0 {
        cetz.draw.line((0, 0), (0, -l), stroke: s)
      }
    } else {
      cetz.draw.line((0, 0), (e, 0), (e, -l), stroke: s)
    }

    // Content extents. The car is lower than the pedestal, so the
    // composition height follows the parts present. Car proportions
    // are digitised from the reference pictogram (sleek sedan, nose
    // left, charge plug on the rear panel).
    let plinth-w = 0.52 * h
    let car-l = 1.6 * h
    let car-h = 0.61 * h
    let gap = 0.30 * h // car rear ↔ pedestal (plug + cable live here)
    let content-w = if has-ev and has-charger {
      car-l + gap + plinth-w
    } else if has-charger {
      plinth-w
    } else { car-l }
    let content-h = if has-charger { h } else { car-h }

    // Placement. Boxed: a SQUARE box hangs centred under the lead
    // (side = the larger content extent plus padding), content centred
    // inside. Bare: the lead lands on the pedestal top centre (or, car
    // only, the roof centre).
    let cl = 0 // content left x
    let ground = 0
    let (box-l, box-r, box-t, box-b) = (0, 0, 0, 0)
    let col-w = 0.36 * h
    if boxed {
      let pad = 0.10 * h
      let side = calc.max(content-w, content-h) + 2 * pad
      box-l = e - side / 2
      box-r = e + side / 2
      box-t = -l
      box-b = box-t - side
      cl = e - content-w / 2
      ground = (box-t + box-b) / 2 - content-h / 2
      cetz.draw.rect(
        (box-l, box-b),
        (box-r, box-t),
        stroke: s,
        fill: style.at("box-fill", default: none),
      )
    } else {
      let anchor-x = if has-charger { content-w - plinth-w / 2 } else {
        0.5 * car-l
      }
      cl = e - anchor-x
      ground = -l - content-h
    }

    // ── Car (side view, nose left, charge port on the rear panel) ────
    // Digitised from the reference pictogram. X is a fraction of the
    // car length; Y a fraction of the rocker→roof height above the
    // rocker line (which sits one wheel radius above ground).
    let (port-x, port-y) = (0, 0) // cable attachment: the plug's face
    if has-ev {
      let rw = 0.13 * h // wheel radius
      let hb = 0.48 * h // rocker line → roof
      let rocker = ground + rw
      let X(fx) = cl + fx * car-l
      let Y(fy) = rocker + fy * hb
      let (w1, w2) = (X(0.185), X(0.77)) // wheel centres
      let arch = rw + 0.045 * h
      // One continuous closed outline — bumper, hood, windshield,
      // roof/fastback, trunk, and a rocker line whose wheel arches are
      // arcs of the same path, so every segment connects exactly.
      let body() = {
        cetz.draw.line(
          (X(0.03), Y(0.0)), // front-bottom corner
          (X(0.005), Y(0.06)),
          (X(0.0), Y(0.20)),
          (X(0.0), Y(0.38)), // bumper face
        )
        cetz.draw.bezier(
          (X(0.0), Y(0.38)),
          (X(0.27), Y(0.66)), // windshield base
          (X(0.005), Y(0.58)), // nose corner
          (X(0.10), Y(0.64)), // hood
        )
        cetz.draw.bezier(
          (X(0.27), Y(0.66)),
          (X(0.465), Y(1.0)), // roof front
          (X(0.33), Y(0.77)),
          (X(0.40), Y(0.95)),
        )
        cetz.draw.bezier(
          (X(0.465), Y(1.0)),
          (X(0.93), Y(0.75)), // trunk lip
          (X(0.60), Y(1.03)), // roof crown
          (X(0.79), Y(0.94)), // fastback
        )
        cetz.draw.bezier(
          (X(0.93), Y(0.75)),
          (X(1.0), Y(0.30)), // rear panel
          (X(0.99), Y(0.70)),
          (X(1.01), Y(0.50)),
        )
        cetz.draw.line(
          (X(1.0), Y(0.30)),
          (X(0.995), Y(0.05)),
          (X(0.97), Y(0.0)), // rear-bottom corner
          (w2 + arch, Y(0.0)),
        )
        cetz.draw.arc(
          (w2 + arch, Y(0.0)),
          start: 0deg,
          stop: 180deg,
          radius: arch,
        )
        cetz.draw.line((w2 - arch, Y(0.0)), (w1 + arch, Y(0.0)))
        cetz.draw.arc(
          (w1 + arch, Y(0.0)),
          start: 0deg,
          stop: 180deg,
          radius: arch,
        )
        cetz.draw.line((w1 - arch, Y(0.0)), (X(0.03), Y(0.0)))
      }
      cetz.draw.merge-path(body(), close: true, stroke: s, fill: f)
      cetz.draw.circle((w1, rocker), radius: rw, stroke: s, fill: f)
      cetz.draw.circle((w2, rocker), radius: rw, stroke: s, fill: f)
      // Windows: windshield-side and fastback-side panes around a
      // B-pillar, both rooted on the beltline.
      cetz.draw.line(
        (X(0.315), Y(0.66)),
        (X(0.475), Y(0.93)),
        (X(0.53), Y(0.93)),
        (X(0.53), Y(0.66)),
        close: true,
        stroke: s,
      )
      cetz.draw.line(
        (X(0.575), Y(0.66)),
        (X(0.575), Y(0.93)),
        (X(0.75), Y(0.66)),
        close: true,
        stroke: s,
      )
      // Charge port: a plug on the rear panel — prongs rooted inside
      // the body, head just outside, drawn in the stroke paint so it
      // reads at symbol scale.
      if has-charger {
        let paint = {
          let p = std.stroke(s).paint
          if p == auto { black } else { p }
        }
        for dy in (-0.038 * h, 0.038 * h) {
          cetz.draw.line(
            (X(0.975), Y(0.60) + dy),
            (X(1.0) + 0.07 * h, Y(0.60) + dy),
            stroke: s,
          )
        }
        cetz.draw.rect(
          (X(1.0) + 0.07 * h, Y(0.60) - 0.08 * h),
          (X(1.0) + 0.185 * h, Y(0.60) + 0.08 * h),
          radius: 0.025 * h,
          stroke: none,
          fill: paint,
        )
        (port-x, port-y) = (X(1.0) + 0.185 * h, Y(0.60))
      }
      cetz.draw.anchor("ev", ((X(0.0) + X(1.0)) / 2, Y(0.45)))
    }

    // ── Charging pedestal ────────────────────────────────────────────
    if has-charger {
      let qx = cl + content-w - plinth-w // plinth left
      let col-l = qx + (plinth-w - col-w) / 2
      let col-r = col-l + col-w
      let plinth-h = 0.06 * h
      cetz.draw.rect(
        (qx, ground),
        (qx + plinth-w, ground + plinth-h),
        stroke: s,
        fill: f,
      )
      cetz.draw.rect(
        (col-l, ground + plinth-h),
        (col-r, ground + h),
        radius: (north: 0.09 * h, south: 0.02 * h),
        stroke: s,
        fill: f,
      )
      // Connector holster on the car-facing side.
      let paint = {
        let p = std.stroke(s).paint
        if p == auto { black } else { p }
      }
      cetz.draw.rect(
        (col-l - 0.06 * h, ground + 0.64 * h),
        (col-l + 0.02 * h, ground + 0.78 * h),
        radius: 0.02 * h,
        stroke: none,
        fill: paint,
      )
      // Lightning bolt, outline form.
      let bx(fx) = col-l + col-w / 2 + (fx - 0.5) * 0.17 * h
      let by(fy) = ground + 0.38 * h + fy * 0.30 * h
      cetz.draw.line(
        (bx(0.62), by(1.0)),
        (bx(0.0), by(0.42)),
        (bx(0.38), by(0.42)),
        (bx(0.28), by(0.0)),
        (bx(1.0), by(0.58)),
        (bx(0.55), by(0.58)),
        close: true,
        stroke: s,
      )
      cetz.draw.anchor("charger", (col-l + col-w / 2, ground + h))
      // Charging cable, holster → the plug on the rear panel. It
      // drops through the gap and hooks up into the plug from below.
      if has-ev {
        cetz.draw.bezier(
          (col-l - 0.06 * h, ground + 0.68 * h),
          (port-x, port-y),
          (col-l - 0.10 * h, ground + 0.22 * h),
          (port-x + 0.24 * h, port-y - 0.24 * h),
          stroke: s,
        )
      }
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("north", (0, 0))
    if boxed {
      // Compass anchors on the box, like `block` / `plant`.
      let box-mid = (box-t + box-b) / 2
      cetz.draw.anchor("south", (e, box-b))
      cetz.draw.anchor("east", (box-r, box-mid))
      cetz.draw.anchor("west", (box-l, box-mid))
      cetz.draw.anchor("center", (e, box-mid))
    } else {
      let mid = ground + content-h / 2
      cetz.draw.anchor("south", (cl + content-w / 2, ground))
      cetz.draw.anchor("east", (cl + content-w, mid))
      cetz.draw.anchor("west", (cl, mid))
      cetz.draw.anchor("center", (cl + content-w / 2, mid))
    }
  }

  symbol("ev-charger", name, ..positions, ..overrides, draw: draw)
}
