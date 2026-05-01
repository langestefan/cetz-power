// Switch / disconnector — a two-terminal switching element drawn as
// a hinge-pin at each end with a movable bar between them. By default
// the bar is shown OPEN (tilted up from the left pin), which is the
// conventional SLD pose used to label a circuit element as a
// disconnector / switch in the diagram. Pass `closed: true` for the
// closed pose.
//
// Two-node placement only — the switch always spans between two
// connection points.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Switch / disconnector. Two-node: pass `in` and `out` and the
/// switch sits between them.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`.
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints.
/// - closed (bool): `false` (default) shows the bar tilted up; `true`
///   shows it horizontal between the two pins.
/// - switch-length (float): length of the switch bar (and the gap it
///   spans on the wire).
/// - open-angle (angle): angle the bar tilts up from horizontal when
///   open. Default `30deg`.
/// - pivot-radius (float): radius of the small filled circles drawn
///   at each pin.
/// - stroke: standard style override.
/// - label: standard label dict.
/// -> content
#let switch(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let sl = style.at("switch-length", default: 0.45)
    let pr = style.at("pivot-radius", default: 0.045)
    let oa = style.at("open-angle", default: 30deg)
    let closed = style.at("closed", default: false)

    if positions.len() != 2 {
      assert(false, message: "switch() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2
    let stub = (span - sl) / 2

    let pin-left = (-half + stub, 0)
    let pin-right = (half - stub, 0)

    // Wire stubs from the endpoints to the pins.
    let wire-stroke = ctx.style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)
    if stub > 0 {
      cetz.draw.line((-half, 0), pin-left, stroke: wire-stroke)
      cetz.draw.line(pin-right, (half, 0), stroke: wire-stroke)
    }

    // The pins themselves.
    cetz.draw.circle(pin-left, radius: pr, stroke: none, fill: black)
    cetz.draw.circle(pin-right, radius: pr, stroke: none, fill: black)

    // The bar.
    if closed {
      cetz.draw.line(pin-left, pin-right, stroke: s)
    } else {
      let bar-end = (
        pin-left.at(0) + sl * calc.cos(oa),
        sl * calc.sin(oa),
      )
      cetz.draw.line(pin-left, bar-end, stroke: s)
    }

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, sl * calc.sin(oa) + 0.05))
    cetz.draw.anchor("south", (0, -0.1))
  }

  symbol("switch", name, ..positions, ..overrides, draw: draw)
}
