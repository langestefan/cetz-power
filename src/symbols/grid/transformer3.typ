// Three-winding transformer — the conventional trefoil of three
// mutually-overlapping circles. Unlike the two-winding `transformer`
// (which is a two-node element that orients itself along its in→out
// line), a three-winding transformer has THREE terminals, so it is a
// one-node symbol: place it at a point and rotate with `angle:`.
//
// Default orientation is "vertex-left": the primary (HV) circle sits on
// the left and the two secondaries are stacked on the right — upper
// (LV) and lower (TV) — so the symbol drops straight into a left→right
// feed that splits into two branches (e.g. the stator + rotor paths of
// a doubly-fed induction generator).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Three-winding transformer (trefoil of three overlapping circles).
///
/// A one-node symbol: place with a single position plus optional
/// `angle:`. The three circle centres form an equilateral triangle
/// whose centroid is the symbol origin; `distance` is the centre-to-
/// centre spacing (triangle side) and `radius` the circle radius.
///
/// Terminal anchors sit on each circle's outer edge, radially from the
/// centroid:
///
///   * `hv` / `primary` / `in` — left circle (high voltage)
///   * `lv` / `secondary`      — upper-right circle
///   * `tv` / `tertiary`       — lower-right circle
///
/// plus `center`, `north`, `south`, `east`, `west`. Wire each terminal
/// to its bus or branch; no leads are drawn automatically (matching the
/// two-winding symbol in one-node mode).
///
/// Each winding can be styled independently — `primary-stroke` /
/// `primary-fill`, `secondary-stroke` / `secondary-fill`, and
/// `tertiary-stroke` / `tertiary-fill` — all defaulting to the unified
/// `stroke` / `fill`.
///
/// - name (str): CeTZ group name.
/// - radius (float): radius of each circle (style override).
/// - distance (float): centre-to-centre spacing of the circles.
/// - stroke / fill: applied to ALL three circles unless overridden
///   per winding.
/// - primary-stroke / primary-fill: override for the HV (left) circle.
/// - secondary-stroke / secondary-fill: override for the LV (upper) circle.
/// - tertiary-stroke / tertiary-fill: override for the TV (lower) circle.
/// - label: optional label.
/// - angle (angle): rotation about the placement point.
/// -> content
#let transformer3(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.32)
    let d = style.at("distance", default: 0.42)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let ps = style.at("primary-stroke", default: s)
    let ss = style.at("secondary-stroke", default: s)
    let ts = style.at("tertiary-stroke", default: s)
    let pf = style.at("primary-fill", default: f)
    let sf = style.at("secondary-fill", default: f)
    let tf = style.at("tertiary-fill", default: f)

    // Equilateral triangle of circle centres, centroid at the origin,
    // one vertex pointing left (-x). Circumradius R = side / sqrt(3).
    let rt3 = calc.sqrt(3)
    let cap-R = d / rt3
    let c-hv = (-cap-R, 0)
    let c-lv = (cap-R / 2, d / 2)
    let c-tv = (cap-R / 2, -d / 2)

    // Terminals sit on each circle's outer edge, radially outward from
    // the centroid — i.e. R + r along each vertex direction.
    let edge = cap-R + r
    let t-hv = (-edge, 0)
    let t-lv = (edge / 2, edge * rt3 / 2)
    let t-tv = (edge / 2, -edge * rt3 / 2)

    // Fills first (stroke none) then strokes (fill none), so a later
    // circle's fill can't occlude an earlier circle's stroke in the
    // overlap regions.
    cetz.draw.circle(c-hv, radius: r, stroke: none, fill: pf)
    cetz.draw.circle(c-lv, radius: r, stroke: none, fill: sf)
    cetz.draw.circle(c-tv, radius: r, stroke: none, fill: tf)
    cetz.draw.circle(c-hv, radius: r, stroke: ps, fill: none)
    cetz.draw.circle(c-lv, radius: r, stroke: ss, fill: none)
    cetz.draw.circle(c-tv, radius: r, stroke: ts, fill: none)

    // Terminal anchors. `in` aliases the HV terminal for natural
    // left-feed; there is no single `out` (two secondaries) — use
    // `lv` / `tv`.
    cetz.draw.anchor("in", t-hv)
    cetz.draw.anchor("primary", t-hv)
    cetz.draw.anchor("hv", t-hv)
    cetz.draw.anchor("secondary", t-lv)
    cetz.draw.anchor("lv", t-lv)
    cetz.draw.anchor("tertiary", t-tv)
    cetz.draw.anchor("tv", t-tv)

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, d / 2 + r + 0.05))
    cetz.draw.anchor("south", (0, -d / 2 - r - 0.05))
    cetz.draw.anchor("east", (cap-R / 2 + r, 0))
    cetz.draw.anchor("west", t-hv)
    cetz.draw.anchor("default", (0, 0))
  }

  symbol("transformer3", name, ..positions, ..overrides, draw: draw)
}
