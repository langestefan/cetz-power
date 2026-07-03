// Current transformer (CT) — instrument transformer for current
// measurement. IEC one-line convention: a circle sitting on the
// conductor, with the primary passing straight through. The secondary
// (to the meter or relay) taps one of the circle's compass anchors.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Current transformer. Two-node: pass `in` and `out` and the circle
/// sits at the midpoint with the conductor drawn straight through it.
/// One-node: pass a single position (plus optional `angle:`) to drop
/// the circle onto an existing run.
///
/// Wire the secondary from a compass anchor (they sit ON the circle),
/// perpendicular to the conductor — e.g. `wire("ct1.south", ...)` down
/// to the meter.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (on the circle).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints (or one point).
/// - radius (float): circle radius.
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// -> content
#let ct(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let r = style.at("radius", default: 0.16)

    if positions.len() > 2 {
      assert(false, message: "ct() takes one or two positions")
    }

    let span = if positions.len() == 2 {
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else { 0 }
    let half = span / 2

    // The primary runs straight through the circle: no gap.
    if half > 0 {
      let wire-stroke = ctx
        .style
        .at("cetz-power", default: (:))
        .at("wire", default: (:))
        .at("stroke", default: s)
      cetz.draw.line((-half, 0), (half, 0), stroke: wire-stroke)
    }
    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("ct", name, ..positions, ..overrides, draw: draw)
}
