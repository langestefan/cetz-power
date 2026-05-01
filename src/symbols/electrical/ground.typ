// Ground — reference point. Drawn with a short lead going down from
// the connection point at `in`, then one of three terminal symbols:
//
//   * "earth"   (default) — three horizontal lines decreasing in width.
//                            Protective-earth / earth-electrode notation.
//   * "chassis"            — single horizontal bar with diagonal hatching.
//                            Chassis / frame ground.
//   * "signal"             — filled downward triangle. Common / signal
//                            ground used in low-voltage circuits.
//
// One-node symbol — the `in` anchor lands at the placement point and
// the rest of the symbol extends downward in the local frame.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Ground reference. Default form is the IEC/IEEE earth-electrode
/// symbol (three horizontal lines decreasing in width).
///
/// Anchors: `in` (= `default`, = `north`) at the connection point;
/// `south` at the bottom of the symbol.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - kind (str): `"earth"` (default), `"chassis"`, or `"signal"`.
/// - lead (float): length of the lead from `in` down to the symbol.
/// - width (float): width of the widest horizontal line (or the bar).
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let ground(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let lead = style.at("lead", default: 0.18)
    let w = style.at("width", default: 0.4)
    let kind = style.at("kind", default: "earth")

    if lead > 0 {
      cetz.draw.line((0, 0), (0, -lead), stroke: s)
    }

    let bottom-y = -lead
    let south-y = bottom-y

    if kind == "earth" {
      // Three horizontal lines, each shorter and stacked just below
      // the previous one. The classic earth-electrode notation.
      let widths = (w, w * 0.66, w * 0.33)
      let gap = w * 0.18
      for i in range(widths.len()) {
        let lw = widths.at(i)
        let y = bottom-y - i * gap
        cetz.draw.line((-lw / 2, y), (lw / 2, y), stroke: s)
      }
      south-y = bottom-y - (widths.len() - 1) * gap
    } else if kind == "chassis" {
      // Solid horizontal bar with three short diagonal hatches below.
      cetz.draw.line((-w / 2, bottom-y), (w / 2, bottom-y), stroke: s)
      let hw = w * 0.7
      let h = w * 0.25
      let n = 3
      for i in range(n) {
        let x = -hw / 2 + i * hw / (n - 1)
        cetz.draw.line((x, bottom-y), (x - h * 0.6, bottom-y - h), stroke: s)
      }
      south-y = bottom-y - h
    } else if kind == "signal" {
      // Filled downward-pointing triangle.
      let h = w * 0.6
      cetz.draw.line(
        (-w / 2, bottom-y), (w / 2, bottom-y), (0, bottom-y - h),
        close: true, stroke: s, fill: black,
      )
      south-y = bottom-y - h
    } else {
      assert(false, message: "ground kind must be one of \"earth\", \"chassis\", \"signal\"; got " + repr(kind))
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("north", (0, 0))
    cetz.draw.anchor("south", (0, south-y))
    cetz.draw.anchor("east", (w / 2, bottom-y))
    cetz.draw.anchor("west", (-w / 2, bottom-y))
    cetz.draw.anchor("center", (0, (0 + south-y) / 2))
  }

  symbol("ground", name, ..positions, ..overrides, draw: draw)
}
