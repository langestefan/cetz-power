// Lightning bolt — a stylised zigzag drawn between two endpoints.
// Used in single-line diagrams to mark a phase-to-ground fault, a
// surge event, or any other "discharge" indicator. By default the
// bolt carries an arrowhead at the `out` end so it doubles as a
// fault-current direction indicator.
//
// Two-node only — pass `in` and `out` and the bolt zigzags between
// them; the symbol orients itself along the in→out line.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Lightning bolt symbol — zigzag between `in` and `out`.
///
/// Anchors: `in`, `out` (the two endpoints), `center` (midpoint on
/// the in→out line).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints.
/// - segments (int): number of zigzag segments. `4` (default) gives
///   the classic lightning-bolt look (three intermediate kinks);
///   `2` collapses to a single Z; higher values give a noisier zig.
/// - amplitude (float): how far each kink deviates from the centerline.
/// - arrow (bool): whether to draw an arrowhead at the `out` end.
///   Default `true` — useful for indicating fault-current direction.
/// - arrow-color: fill colour for the arrowhead. Defaults to `black`;
///   pass the same colour as `stroke` for a colour-matched arrow.
/// - stroke: stroke for the bolt path (style override).
/// - label: standard label dict.
/// -> content
#let bolt(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 1.2pt + black)
    let n = style.at("segments", default: 4)
    let amp = style.at("amplitude", default: 0.12)
    let arrow = style.at("arrow", default: true)
    let arrow-color = style.at("arrow-color", default: black)

    if positions.len() != 2 {
      assert(false, message: "bolt() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2

    // Local frame: zigzag from (-half, 0) to (half, 0) along +x.
    // Endpoints stay on the centerline; intermediate kinks alternate
    // between +amp and -amp, giving the characteristic zigzag.
    let pts = ()
    for i in range(n + 1) {
      let t = i / n
      let x = -half + t * span
      let y = if i == 0 or i == n {
        0
      } else if calc.rem(i, 2) == 1 {
        amp
      } else {
        -amp
      }
      pts.push((x, y))
    }

    if arrow {
      cetz.draw.line(..pts, stroke: s,
        mark: (end: ">", fill: arrow-color))
    } else {
      cetz.draw.line(..pts, stroke: s)
    }

    cetz.draw.anchor("center", (0, 0))
  }

  symbol("bolt", name, ..positions, ..overrides, draw: draw)
}
