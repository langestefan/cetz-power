// Busbar — the primary organising element of a single-line diagram.
//
// A bus is a thick line. It has a configurable `length` and `orientation`,
// and exposes connection anchors:
//
//   * `start`, `mid`, `end` — the three named positions along the bar.
//   * `tap1`, `tap2`, ..., `tapN` — N evenly-spaced taps (if `taps: N` given).
//   * `at-0.25`, `at-0.5`, ... — fractional taps you can request anywhere,
//     but these are computed by the user at call-site, not pre-named.
//
// Two ways to place a bus:
//
//   1. Give one coordinate → bus extends along its local x-axis.
//      Rotate with `angle: 90deg` for a vertical bus.
//
//      ```
//      bus("b1", (0, 0), length: 4, taps: 5)
//      ```
//
//   2. Give two coordinates → bus spans from `a` to `b`; length and
//      orientation are inferred.
//
//      ```
//      bus("b1", (0, 0), (4, 0), taps: 5)
//      ```

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Draw a busbar.
///
/// - name (str): CeTZ group name; used to address anchors (e.g. `"b1.mid"`).
/// - length (float): bar length in CeTZ units, used only when one position is given.
/// - taps (int): number of evenly-spaced tap anchors to create; default `1`.
///   With `taps: 1` a single `tap1` anchor coincides with `mid`.
/// - stroke: stroke override.
/// - label: content (or dict) placed at the `north` of the bar by default.
/// - angle: rotation of the bar (only when a single position is given).
/// -> content
#let bus(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  assert(
    positions.len() in (1, 2),
    message: "bus() takes 1 or 2 positions, got " + str(positions.len()),
  )
  let taps = overrides.at("taps", default: none)
  if taps != none {
    let _ = overrides.remove("taps")
  }
  let length = overrides.at("length", default: none)
  if length != none { let _ = overrides.remove("length") }

  let draw(ctx, positions, style) = {
    let L = if length != none { length } else if positions.len() == 2 {
      // local frame: in=(0,0), out at distance |b - a| on +x axis
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else {
      style.at("length", default: 3)
    }
    let n-taps = if taps != none { taps } else { style.at("taps", default: 1) }
    assert(
      type(n-taps) == int and n-taps >= 1,
      message: "bus taps must be a positive integer, got " + repr(n-taps),
    )

    // The `symbol()` wrapper always puts the origin at the midpoint (either
    // the single caller-supplied position, or the midpoint of the two), so
    // we always draw from (-L/2, 0) to (L/2, 0) in local space.
    let x0 = -L / 2
    let x1 = L / 2

    cetz.draw.line(
      (x0, 0), (x1, 0),
      stroke: style.at("stroke", default: 1.8pt + black),
    )

    // Named anchors along the bar.
    cetz.draw.anchor("start", (x0, 0))
    cetz.draw.anchor("end", (x1, 0))
    cetz.draw.anchor("mid", ((x0 + x1) / 2, 0))
    cetz.draw.anchor("default", ((x0 + x1) / 2, 0))

    // Evenly-spaced taps.
    if n-taps == 1 {
      cetz.draw.anchor("tap1", ((x0 + x1) / 2, 0))
    } else {
      for i in range(n-taps) {
        let t = i / (n-taps - 1)
        cetz.draw.anchor("tap" + str(i + 1), (x0 + t * (x1 - x0), 0))
      }
    }

    // Bounding-box hints for the label's default attachment.
    // "north" sits just above the bar, halfway along.
    cetz.draw.anchor("north", ((x0 + x1) / 2, 0.15))
    cetz.draw.anchor("south", ((x0 + x1) / 2, -0.15))
    cetz.draw.anchor("east",  (x1 + 0.05, 0))
    cetz.draw.anchor("west",  (x0 - 0.05, 0))
  }

  symbol("bus", name, ..positions, ..overrides, draw: draw)
}

/// Convenience: `bus-at(name, bus-anchor, fraction)` returns a local anchor
/// name for a fractional point along `bus-name`. Because CeTZ evaluates
/// anchor strings late, we instead build a coordinate expression.
///
/// Usage:
///
///     #let p = bus-frac("b1", 0.25)
///     wire(p, (3, 1))
///
/// -> coordinate
#let bus-frac(bus-name, fraction) = {
  (bus-name + ".start", fraction, bus-name + ".end")
}
