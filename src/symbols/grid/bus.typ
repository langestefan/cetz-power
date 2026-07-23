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
/// A third placement form sizes the bar from the connections it must
/// carry: `bus("b", fit: (c1, c2, ...), over: 0.2)` spans the given
/// coordinates plus a symmetric overshoot at both ends — the
/// clean-busbar look of design rules 2 and 14 without hand-deriving
/// the endpoints. The axis is inferred from the points' spread
/// (vertical when they spread more in y) or forced with `angle:`; the
/// bar passes through the points' mean perpendicular offset.
/// `over: (ref: h, gap: g)` computes the overshoot `h/2 − g/2` that
/// lines the bar's ends up with a reference bar of length `h` a gap
/// `g` away (rule 14). The fit coordinates must already be drawn if
/// they are anchors.
///
/// - name (str): CeTZ group name; used to address anchors (e.g. `"b1.mid"`).
/// - length (float): bar length in CeTZ units, used only when one position is given.
/// - taps (int): number of evenly-spaced tap anchors to create; default `1`.
///   With `taps: 1` a single `tap1` anchor coincides with `mid`.
/// - fit (array | none): coordinates the bar must span (alternative to
///   positions).
/// - over (float | dictionary): overshoot past the outermost fit
///   coordinates, or `(ref:, gap:)` for the rule-14 alignment form.
///   Default `0.2`.
/// - stroke: stroke override.
/// - label: content (or dict) placed at the `north` of the bar by default.
/// - angle: rotation of the bar (only when a single position is given;
///   with `fit:` it forces the bar's axis).
/// -> content
#let bus(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let fit = overrides.at("fit", default: none)
  if fit != none { let _ = overrides.remove("fit") }
  let over = overrides.at("over", default: 0.2)
  if "over" in overrides { let _ = overrides.remove("over") }
  if fit != none {
    assert(
      positions.len() == 0,
      message: "bus(): `fit:` replaces the positional coordinates",
    )
    assert(
      type(fit) == array and fit.len() >= 1,
      message: "bus() fit must be an array of coordinates",
    )
    let ang = overrides.at("angle", default: auto)
    if "angle" in overrides { let _ = overrides.remove("angle") }
    return cetz.draw.get-ctx(ctx => {
      let (_ctx, ..pts) = cetz.coordinate.resolve(ctx, ..fit)
      let xs = pts.map(p => p.at(0))
      let ys = pts.map(p => p.at(1))
      let a = if ang == auto {
        // Axis of the larger spread; a single point defaults vertical
        // (the common "bar carrying stacked cables" case).
        if calc.max(..ys) - calc.min(..ys) >= calc.max(..xs) - calc.min(..xs) {
          90deg
        } else { 0deg }
      } else { ang }
      let u = (calc.cos(a), calc.sin(a))
      let pv = (-u.at(1), u.at(0))
      let ts = pts.map(p => p.at(0) * u.at(0) + p.at(1) * u.at(1))
      let os = pts.map(p => p.at(0) * pv.at(0) + p.at(1) * pv.at(1))
      let o = os.sum() / os.len()
      let ov = if type(over) == dictionary {
        over.at("ref") / 2 - over.at("gap", default: 0) / 2
      } else { over }
      // The bar's start→end direction follows the ORDER of the fit
      // points (first toward last), so `bus-frac` fractions and
      // `start`/`end` anchors keep the orientation the caller wrote
      // down — a fit list given top-to-bottom yields a top-down bar.
      let t0 = calc.min(..ts) - ov
      let t1 = calc.max(..ts) + ov
      if ts.last() < ts.first() { (t0, t1) = (t1, t0) }
      bus(
        name,
        (t0 * u.at(0) + o * pv.at(0), t0 * u.at(1) + o * pv.at(1)),
        (t1 * u.at(0) + o * pv.at(0), t1 * u.at(1) + o * pv.at(1)),
        ..overrides,
      )
    })
  }

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
      (x0, 0),
      (x1, 0),
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
    cetz.draw.anchor("east", (x1 + 0.05, 0))
    cetz.draw.anchor("west", (x0 - 0.05, 0))
  }

  symbol("bus", name, ..positions, ..overrides, draw: draw)
}

/// Convenience: `bus-frac(name, fraction)` returns a coordinate a given
/// `fraction` (0..1) of the way from the bus's `start` to its `end`.
/// Because CeTZ evaluates anchor strings late, we build a lerp coordinate
/// rather than a named anchor.
///
/// The fraction is passed as a *ratio* (`fraction * 100%`): CeTZ's lerp
/// coordinate treats a plain float offset as an absolute distance along
/// the segment, but a ratio as a true percentage — so `bus-frac("b1", 0.5)`
/// lands at the midpoint regardless of the bus's length.
///
/// Usage:
///
///     #let p = bus-frac("b1", 0.25)
///     wire(p, (3, 1))
///
/// -> coordinate
#let bus-frac(bus-name, fraction) = {
  (bus-name + ".start", fraction * 100%, bus-name + ".end")
}
