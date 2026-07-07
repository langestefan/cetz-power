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
#import "/src/symbols/grid/winding-mark.typ": winding-mark

/// Three-winding transformer (trefoil of three overlapping circles).
///
/// A one-node symbol: place with a single position plus optional
/// `angle:`. The three circle centres form an equilateral triangle
/// whose centroid is the symbol origin; `distance` is the centre-to-
/// centre spacing (triangle side) and `radius` the circle radius.
///
/// Terminal anchors sit where each winding's wire exits its circle:
///
///   * `hv` / `primary` / `in` — left circle (high voltage)
///   * `lv` / `secondary`      — upper-right circle
///   * `tv` / `tertiary`       — lower-right circle
///
/// plus `center`, `north`, `south`, `east`, `west`.
///
/// By default each terminal exits its circle radially from the centroid
/// (HV at 180°, LV at 60°, TV at −60°). Control where the connection
/// points land with the per-terminal `hv-angle` / `lv-angle` / `tv-angle`
/// exit directions, and push them further out (with a drawn lead stub)
/// via `lead`. Both are backward-compatible: the defaults reproduce the
/// flush-on-the-circle terminals.
///
/// Each winding can be styled independently — `primary-stroke` /
/// `primary-fill`, `secondary-stroke` / `secondary-fill`, and
/// `tertiary-stroke` / `tertiary-fill` — all defaulting to the unified
/// `stroke` / `fill`. A lead stub picks up its winding's stroke.
///
/// - name (str): CeTZ group name.
/// - radius (float): radius of each circle (style override).
/// - distance (float): centre-to-centre spacing of the circles.
/// - lead (float): length of the lead stub drawn from each circle edge
///   to its terminal anchor. `0` (default) keeps the anchor on the edge.
/// - vector (array | none): winding marks drawn inside the circles —
///   three entries (hv, lv, tv), each `"delta"`, `"wye"`, `"zigzag"`
///   or `none`, e.g. `vector: ("delta", "wye", "wye")`. Marks stay
///   upright regardless of `angle:`. vector-size / vector-stroke as
///   on `transformer`.
/// - hv-angle / lv-angle / tv-angle (angle): direction in which each
///   terminal exits its circle, measured CCW from +x. Defaults
///   `180deg` / `60deg` / `-60deg`.
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
    // In-circle marks need room: widen the trefoil spacing until the
    // marks clear the neighbouring circles' outlines (see the same
    // clamp in `transformer`). A larger explicit `distance` wins.
    let vector = style.at("vector", default: none)
    let g = r * style.at("vector-size", default: 0.45)
    if vector != none { d = calc.max(d, r + 1.15 * g) }
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let ps = style.at("primary-stroke", default: s)
    let ss = style.at("secondary-stroke", default: s)
    let ts = style.at("tertiary-stroke", default: s)
    let pf = style.at("primary-fill", default: f)
    let sf = style.at("secondary-fill", default: f)
    let tf = style.at("tertiary-fill", default: f)
    let lead = style.at("lead", default: 0)
    let a-hv = style.at("hv-angle", default: 180deg)
    let a-lv = style.at("lv-angle", default: 60deg)
    let a-tv = style.at("tv-angle", default: -60deg)

    // Equilateral triangle of circle centres, centroid at the origin,
    // one vertex pointing left (-x). Circumradius R = side / sqrt(3).
    let rt3 = calc.sqrt(3)
    let cap-R = d / rt3
    let c-hv = (-cap-R, 0)
    let c-lv = (cap-R / 2, d / 2)
    let c-tv = (cap-R / 2, -d / 2)

    // A winding's wire leaves its circle at angle `a`; the terminal
    // anchor is `lead` beyond the edge, the stub running from edge to it.
    // Returns (anchor-point, edge-point). With the default angles and
    // lead = 0 this reproduces the flush radial terminals.
    let term(c, a) = {
      let (cx, cy) = c
      let (dx, dy) = (calc.cos(a), calc.sin(a))
      ((cx + (r + lead) * dx, cy + (r + lead) * dy), (cx + r * dx, cy + r * dy))
    }
    let (t-hv, e-hv) = term(c-hv, a-hv)
    let (t-lv, e-lv) = term(c-lv, a-lv)
    let (t-tv, e-tv) = term(c-tv, a-tv)

    // Fills first (stroke none) then strokes (fill none), so a later
    // circle's fill can't occlude an earlier circle's stroke in the
    // overlap regions.
    cetz.draw.circle(c-hv, radius: r, stroke: none, fill: pf)
    cetz.draw.circle(c-lv, radius: r, stroke: none, fill: sf)
    cetz.draw.circle(c-tv, radius: r, stroke: none, fill: tf)
    cetz.draw.circle(c-hv, radius: r, stroke: ps, fill: none)
    cetz.draw.circle(c-lv, radius: r, stroke: ss, fill: none)
    cetz.draw.circle(c-tv, radius: r, stroke: ts, fill: none)

    // In-circle vector-group marks, counter-rotated so they stay
    // upright however the symbol is rotated.
    if vector != none {
      assert(
        type(vector) == array and vector.len() == 3,
        message: "transformer3 vector: expects three entries (hv, lv, tv)",
      )
      let vs = style.at("vector-stroke", default: auto)
      let rot = -ctx.at("rotation", default: 0deg)
      for (c, kind, ws) in (
        (c-hv, vector.at(0), ps),
        (c-lv, vector.at(1), ss),
        (c-tv, vector.at(2), ts),
      ) {
        if kind != none {
          winding-mark(c, kind, g, if vs == auto { ws } else { vs }, rot)
        }
      }
    }

    // Lead stubs (each in its winding's stroke), only when lead > 0.
    if lead > 0 {
      cetz.draw.line(e-hv, t-hv, stroke: ps)
      cetz.draw.line(e-lv, t-lv, stroke: ss)
      cetz.draw.line(e-tv, t-tv, stroke: ts)
    }

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
