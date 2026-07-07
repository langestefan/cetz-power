// Summing point — the control-block-diagram circle with an inscribed
// "+" (the cross spans the full circle, IEC/textbook form). Inputs sum
// into the output; mark an input's sign with a small +/− `note()`
// beside its arrow.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Summing point (circle with an inscribed plus).
///
/// Anchors: `center`, cardinal edges on the circle (`north`, `south`,
/// `east`, `west`) plus the 45° points (`north-east`, …) — all safe as
/// wire endpoints.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): where to place the symbol.
/// - radius (float): circle radius.
/// - stroke: stroke override.
/// - fill: fill override (default none; set to `white` to mask a
///   conductor passing beneath).
/// - label: external label (standard label dict).
/// - angle (angle): rotation.
/// -> content
#let adder(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.16)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)
    cetz.draw.line((-r, 0), (r, 0), stroke: s)
    cetz.draw.line((0, -r), (0, r), stroke: s)

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
    let corner = r / calc.sqrt(2)
    cetz.draw.anchor("north-east", (corner, corner))
    cetz.draw.anchor("south-east", (corner, -corner))
    cetz.draw.anchor("south-west", (-corner, -corner))
    cetz.draw.anchor("north-west", (-corner, corner))
  }

  symbol("adder", name, ..positions, ..overrides, draw: draw)
}
