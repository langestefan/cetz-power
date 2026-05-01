// Resistor — IEC rectangular form (the convention used in European
// power-system single-line diagrams). The IEEE zigzag is sometimes
// preferred in North American schematics but the rectangle is the
// dominant style in SLDs, so we ship the rectangle as the default.
//
// Default form is the symmetric two-pole textbook resistor: a lead
// from `in` up to the bottom edge of the rectangle, the body, then a
// matching upper lead ending at `out`. Pass `lead-out: 0` to suppress
// the upper lead and the `out` anchor (single-pole / shunt form).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Resistor — IEC rectangle with a lead at each end.
///
/// Default orientation: `in` at the bottom, `out` at the top. Pass
/// `angle:` to rotate (`-90deg` lays it flat with leads horizontal).
///
/// Anchors: `in` (= `default`, = `south`), `out` (top of the upper
/// lead — present only when `lead-out > 0`), `north` (top of the
/// upper lead, or the top edge of the body if `lead-out: 0`), `east`
/// and `west` (right / left edges at body midpoint), `center` (centre
/// of the body).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - width (float): width of the rectangle (style override).
/// - length (float): length of the rectangle along the lead axis.
/// - lead-in (float): length of the lead from `in` up to the body.
/// - lead-out (float): length of the lead above the body. Default
///   non-zero (symmetric two-pole). Set to `0` for the single-pole
///   / shunt form.
/// - stroke: stroke for both leads and the body outline.
/// - fill: body fill (default `none`).
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let resistor(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let w = style.at("width", default: 0.3)
    let len = style.at("length", default: 0.7)
    let li = style.at("lead-in", default: 0.2)
    let lo = style.at("lead-out", default: 0.2)

    let bottom-y = li
    let top-y = bottom-y + len
    let mid-y = (bottom-y + top-y) / 2
    let out-y = top-y + lo

    if li > 0 { cetz.draw.line((0, 0), (0, bottom-y), stroke: s) }
    cetz.draw.rect((-w / 2, bottom-y), (w / 2, top-y), stroke: s, fill: f)
    if lo > 0 { cetz.draw.line((0, top-y), (0, out-y), stroke: s) }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("center", (0, mid-y))
    cetz.draw.anchor("east", (w / 2, mid-y))
    cetz.draw.anchor("west", (-w / 2, mid-y))
    if lo > 0 {
      cetz.draw.anchor("out", (0, out-y))
      cetz.draw.anchor("north", (0, out-y))
    } else {
      cetz.draw.anchor("north", (0, top-y))
    }
  }

  symbol("resistor", name, ..positions, ..overrides, draw: draw)
}
