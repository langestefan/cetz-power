// Zigzag winding (Z / z) — each of the three arms has a single
// perpendicular kink halfway along its length, giving the
// "broken Y" shape used for interconnected-star transformer
// secondaries. Default orientation matches IEC clock 0.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Zigzag winding configuration.
///
/// Anchors: `u`, `v`, `w` (the three terminal endpoints), `mid-u`,
/// `mid-v`, `mid-w` (the kink point on each arm), `neutral` (the
/// common centre), plus the standard cardinals and `in`/`out`.
///
/// Pass `body: false` to skip drawing the three kinked arms and the
/// per-terminal labels — anchors are still exposed so the symbol can
/// act as a placement scaffold.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): centre / neutral point.
/// - size (float): radial reach from centre to each terminal.
/// - zigzag-kink (float): fraction along the arm (0..1) where the
///   kink sits. Default 0.5 (mid-arm).
/// - zigzag-offset (float): lateral offset of the kink, as a fraction
///   of `size`. Sign of the offset determines which way the kink jogs;
///   the same sense is used for all three arms so the rotational
///   handedness stays consistent.
/// - terminals (array): three label strings/contents in (U, V, W) order.
/// - body (bool): draw the arm geometry and terminal labels (default
///   `true`). Set to `false` to keep only the anchors.
/// - stroke: stroke for the three arms.
/// - angle (angle): rotation around the centre.
/// - label (content | dict | none): outer caption.
/// -> content
#let zigzag(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("size", default: 0.6)
    let s = style.at("stroke", default: 0.8pt + black)
    let terms = style.at("terminals", default: ("U", "V", "W"))
    let lsize = style.at("label-size", default: 8pt)
    let ldist = style.at("label-distance", default: 0.18)
    let kfrac = style.at("zigzag-kink", default: 0.5)
    let ofrac = style.at("zigzag-offset", default: 0.18)
    let body = style.at("body", default: true)
    let rot = ctx.at("rotation", default: 0deg)

    // Endpoint angles: V at 90°, U at 210°, W at 330°.
    let endp(deg) = (calc.cos(deg) * r, calc.sin(deg) * r)
    let pv = endp(90deg)
    let pu = endp(210deg)
    let pw = endp(330deg)

    // Kink point on each arm — at fraction kfrac along the radial
    // axis, then jogged perpendicular by ofrac. Returned for both the
    // line drawing and the `mid-*` anchors so they stay consistent.
    let kink-of(deg) = {
      let kr = kfrac * r
      let jog = ofrac * r
      let perp = deg + 90deg
      (
        kr * calc.cos(deg) + jog * calc.cos(perp),
        kr * calc.sin(deg) + jog * calc.sin(perp),
      )
    }
    let kv = kink-of(90deg)
    let ku = kink-of(210deg)
    let kw = kink-of(330deg)

    if body {
      cetz.draw.line((0, 0), ku, pu, stroke: s)
      cetz.draw.line((0, 0), kv, pv, stroke: s)
      cetz.draw.line((0, 0), kw, pw, stroke: s)

      let lbl(local-pos, out-deg, txt) = {
        let lp = (
          local-pos.at(0) + ldist * calc.cos(out-deg),
          local-pos.at(1) + ldist * calc.sin(out-deg),
        )
        let body = if type(txt) == str { emph(text(size: lsize, txt)) } else { text(size: lsize, txt) }
        cetz.draw.content(lp, body, angle: -rot)
      }
      lbl(pu, 210deg, terms.at(0))
      lbl(pv,  90deg, terms.at(1))
      lbl(pw, 330deg, terms.at(2))
    }

    cetz.draw.anchor("u", pu)
    cetz.draw.anchor("v", pv)
    cetz.draw.anchor("w", pw)
    // The kink point is the natural "mid" of a zigzag arm.
    cetz.draw.anchor("mid-u", ku)
    cetz.draw.anchor("mid-v", kv)
    cetz.draw.anchor("mid-w", kw)
    let alias(name, pos, fallback) = {
      if type(name) == str and name != fallback { cetz.draw.anchor(name, pos) }
    }
    alias(terms.at(0), pu, "u")
    alias(terms.at(1), pv, "v")
    alias(terms.at(2), pw, "w")

    cetz.draw.anchor("neutral", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("north", (0,  r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east",  ( r, 0))
    cetz.draw.anchor("west",  (-r, 0))
  }

  symbol("winding", name, ..positions, ..overrides, draw: draw)
}
