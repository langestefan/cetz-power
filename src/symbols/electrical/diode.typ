// Diode — equilateral triangle pointing in the conventional current
// direction (from anode to cathode), with a perpendicular cathode bar
// at the tip. Default form has both leads (`in` at the anode, `out`
// at the cathode beyond the bar). Pass `lead-out: 0` to suppress the
// upper lead and the `out` anchor.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Diode — anode-to-cathode triangle with a cathode bar.
///
/// Default orientation: `in` at the bottom (anode side), `out` at the
/// top (cathode side); current flows upward from `in` to `out`. Pass
/// `angle:` to rotate (`180deg` flips the diode so current flows
/// downward, `-90deg` lays it flat with current flowing right).
///
/// Anchors: `in` (= `default`, = `south`) at the anode, `out` (top of
/// the upper lead — present only when `lead-out > 0`), `north` (top
/// of the upper lead, or the cathode bar if `lead-out: 0`), `east`
/// and `west` (right / left ends of the triangle base, at the anode
/// side), `center` (centre of the triangle).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - width (float): width of the triangle's base.
/// - height (float): height of the triangle from base to tip.
/// - bar-width (float): width of the cathode bar (defaults to `width`).
/// - lead-in (float): length of the lead from `in` up to the triangle base.
/// - lead-out (float): length of the lead from the cathode bar to `out`.
///   Default non-zero (symmetric two-pole). Set to `0` to suppress.
/// - stroke: stroke for leads, triangle outline, and bar.
/// - fill: triangle fill (default `none`; pass `black` for the filled form).
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let diode(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let w = style.at("width", default: 0.4)
    let h = style.at("height", default: 0.4)
    let bw = style.at("bar-width", default: w)
    let li = style.at("lead-in", default: 0.15)
    let lo = style.at("lead-out", default: 0.15)

    let base-y = li             // triangle base
    let tip-y = base-y + h      // triangle tip = cathode bar position
    let mid-y = (base-y + tip-y) / 2
    let out-y = tip-y + lo

    if li > 0 { cetz.draw.line((0, 0), (0, base-y), stroke: s) }

    // Triangle: base across (-w/2, base-y) — (w/2, base-y), tip at (0, tip-y).
    cetz.draw.line(
      (-w / 2, base-y), (w / 2, base-y), (0, tip-y),
      close: true, stroke: s, fill: f,
    )
    // Cathode bar at the tip.
    cetz.draw.line((-bw / 2, tip-y), (bw / 2, tip-y), stroke: s)

    if lo > 0 { cetz.draw.line((0, tip-y), (0, out-y), stroke: s) }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("center", (0, mid-y))
    cetz.draw.anchor("east", (w / 2, base-y))
    cetz.draw.anchor("west", (-w / 2, base-y))
    if lo > 0 {
      cetz.draw.anchor("out", (0, out-y))
      cetz.draw.anchor("north", (0, out-y))
    } else {
      cetz.draw.anchor("north", (0, tip-y))
    }
  }

  symbol("diode", name, ..positions, ..overrides, draw: draw)
}
