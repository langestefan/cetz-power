// Circuit breaker — drawn as a small square (or rectangle) sitting
// inline on a wire, or, with `kind: "cross"`, as the compact "×" used
// in network-overview diagrams (the Dutch distribution-planning
// convention for a switchgear/breaker position). Pass `fill:` to
// colour-code by voltage level if you like.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Circuit breaker. Two-node: pass `in` and `out` and the body sits
/// at the midpoint with leads to the two endpoints. One-node: pass a
/// single position (plus optional `angle:`) to drop the body as a
/// marker directly onto an existing wire — handy for the `"cross"`
/// kind, which marks breaker positions on long feeder runs.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (the four sides of the body).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints (or one point).
/// - size (float): side length of the square box / span of the cross.
/// - kind (str): `"square"` (default) — the conventional SLD box;
///   `"cross"` — an × on the wire (the line runs through it).
/// - stroke: standard style override.
/// - fill: box fill (default `none`; ignored for `"cross"`).
/// - label: standard label dict.
/// -> content
#let breaker(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let sz = style.at("size", default: 0.3)
    let kind = style.at("kind", default: "square")

    if positions.len() > 2 {
      assert(false, message: "breaker() takes one or two positions")
    }

    let span = if positions.len() == 2 {
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else { 0 }
    let half = span / 2
    let half-sz = sz / 2

    let wire-stroke = ctx.style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)

    if kind == "cross" {
      // The wire runs straight through the ×: no gap.
      if half > 0 {
        cetz.draw.line((-half, 0), (half, 0), stroke: wire-stroke)
      }
      let d = half-sz * 0.7071
      cetz.draw.line((-d, -d), (d, d), stroke: s)
      cetz.draw.line((-d, d), (d, -d), stroke: s)
    } else {
      if half > half-sz {
        cetz.draw.line((-half, 0), (-half-sz, 0), stroke: wire-stroke)
        cetz.draw.line((half-sz, 0), (half, 0), stroke: wire-stroke)
      }
      cetz.draw.rect(
        (-half-sz, -half-sz), (half-sz, half-sz),
        stroke: s, fill: f,
      )
    }

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, half-sz))
    cetz.draw.anchor("south", (0, -half-sz))
    cetz.draw.anchor("east", (half-sz, 0))
    cetz.draw.anchor("west", (-half-sz, 0))
  }

  symbol("breaker", name, ..positions, ..overrides, draw: draw)
}
