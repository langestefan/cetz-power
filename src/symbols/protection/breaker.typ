// Circuit breaker — drawn as a small square (or rectangle) sitting
// inline on a wire. The conventional SLD notation for a circuit
// breaker that distinguishes it from a plain switch / disconnector.
// Pass `fill:` to colour-code by voltage level if you like.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Circuit breaker. Two-node: pass `in` and `out` and the box sits
/// at the midpoint with leads to the two endpoints.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (the four sides of the box).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints.
/// - size (float): side length of the (square) box.
/// - stroke: standard style override.
/// - fill: box fill (default `none`).
/// - label: standard label dict.
/// -> content
#let breaker(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let sz = style.at("size", default: 0.3)

    if positions.len() != 2 {
      assert(false, message: "breaker() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2
    let half-sz = sz / 2

    let wire-stroke = ctx.style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)
    if half > half-sz {
      cetz.draw.line((-half, 0), (-half-sz, 0), stroke: wire-stroke)
      cetz.draw.line((half-sz, 0), (half, 0), stroke: wire-stroke)
    }

    cetz.draw.rect(
      (-half-sz, -half-sz), (half-sz, half-sz),
      stroke: s, fill: f,
    )

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, half-sz))
    cetz.draw.anchor("south", (0, -half-sz))
    cetz.draw.anchor("east", (half-sz, 0))
    cetz.draw.anchor("west", (-half-sz, 0))
  }

  symbol("breaker", name, ..positions, ..overrides, draw: draw)
}
