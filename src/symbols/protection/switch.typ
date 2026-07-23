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
///   at each pin. Pass `0` to omit the pin dots and draw just the
///   bare blade.
/// - earthing (bool): `true` draws the IEC earth-electrode mark at
///   the `out` end — the earthing-switch symbol. Aim `out` at the
///   earthed side; nothing further connects there.
/// - earth-width (float): length of the longest earth-mark line.
/// - earth-gap (float): spacing between the three earth-mark lines.
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
    let earthing = style.at("earthing", default: false)
    let ew = style.at("earth-width", default: 0.3)
    let eg = style.at("earth-gap", default: 0.07)

    if positions.len() != 2 {
      assert(false, message: "switch() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2
    let stub = (span - sl) / 2

    let pin-left = (-half + stub, 0)
    let pin-right = (half - stub, 0)

    // Wire stubs from the endpoints to the pins.
    let wire-stroke = ctx
      .style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)
    if stub > 0 {
      cetz.draw.line((-half, 0), pin-left, stroke: wire-stroke)
      cetz.draw.line(pin-right, (half, 0), stroke: wire-stroke)
    }

    // The pins themselves (omitted entirely when pivot-radius is 0 —
    // e.g. the bare netopening blades of network-overview diagrams).
    if pr > 0 {
      cetz.draw.circle(pin-left, radius: pr, stroke: none, fill: black)
      cetz.draw.circle(pin-right, radius: pr, stroke: none, fill: black)
    }

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

    // Earthing switch: the IEC earth-electrode mark (three lines of
    // decreasing length, perpendicular to the axis) at the out end.
    if earthing {
      for (i, w) in ((0, ew), (1, ew * 0.62), (2, ew * 0.28)) {
        cetz.draw.line(
          (half + i * eg, -w / 2),
          (half + i * eg, w / 2),
          stroke: s,
        )
      }
    }

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, sl * calc.sin(oa) + 0.05))
    cetz.draw.anchor("south", (0, -0.1))
  }

  symbol("switch", name, ..positions, ..overrides, label-dir: 90deg, draw: draw)
}
