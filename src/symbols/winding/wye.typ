// Wye / star winding (Y / y) — three straight arms from a common
// neutral point to the phase terminals. Default orientation matches
// IEC clock 0: V at the top, U bottom-left, W bottom-right.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Wye (star) winding configuration.
///
/// Anchors: `u`, `v`, `w` (the three terminal endpoints), `mid-u`,
/// `mid-v`, `mid-w` (midpoint of each arm — handy for dropping a
/// component on an arm, e.g. `currentsource(name, "y.neutral",
/// "y.mid-v")`), `neutral` (the common centre), plus `center`,
/// `north`, `south`, `east`, `west` and the standard `in` / `out`
/// aliases.
///
/// Pass `body: false` to skip drawing the three arm lines and the
/// per-terminal labels — anchors are still exposed, so the symbol
/// becomes a placement scaffold for components you draw yourself
/// (current sources radiating from the neutral, for instance).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): centre / neutral point.
/// - size (float): arm length.
/// - terminals (array): three label strings/contents in (U, V, W) order.
/// - body (bool): draw the arm geometry and terminal labels (default
///   `true`). Set to `false` to keep only the anchors.
/// - stroke: stroke for the three arms.
/// - angle (angle): rotation around the centre.
/// - label (content | dict | none): outer caption.
/// -> content
#let wye(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("size", default: 0.6)
    let s = style.at("stroke", default: 0.8pt + black)
    let terms = style.at("terminals", default: ("U", "V", "W"))
    let lsize = style.at("label-size", default: 8pt)
    let ldist = style.at("label-distance", default: 0.18)
    let body = style.at("body", default: true)
    let rot = ctx.at("rotation", default: 0deg)

    // Arm endpoints: V at 90°, U at 210°, W at 330°.
    let endp(deg) = (calc.cos(deg) * r, calc.sin(deg) * r)
    let pv = endp(90deg)
    let pu = endp(210deg)
    let pw = endp(330deg)

    if body {
      cetz.draw.line((0, 0), pv, stroke: s)
      cetz.draw.line((0, 0), pu, stroke: s)
      cetz.draw.line((0, 0), pw, stroke: s)

      let lbl(local-pos, out-deg, txt) = {
        let lp = (
          local-pos.at(0) + ldist * calc.cos(out-deg),
          local-pos.at(1) + ldist * calc.sin(out-deg),
        )
        let body = if type(txt) == str { emph(text(size: lsize, txt)) } else {
          text(size: lsize, txt)
        }
        cetz.draw.content(lp, body, angle: -rot)
      }
      lbl(pu, 210deg, terms.at(0))
      lbl(pv, 90deg, terms.at(1))
      lbl(pw, 330deg, terms.at(2))
    }

    cetz.draw.anchor("u", pu)
    cetz.draw.anchor("v", pv)
    cetz.draw.anchor("w", pw)
    // Mid-arm anchors — half-way between the neutral and each terminal.
    cetz.draw.anchor("mid-u", (pu.at(0) / 2, pu.at(1) / 2))
    cetz.draw.anchor("mid-v", (pv.at(0) / 2, pv.at(1) / 2))
    cetz.draw.anchor("mid-w", (pw.at(0) / 2, pw.at(1) / 2))
    let alias(name, pos, fallback) = {
      if type(name) == str and name != fallback { cetz.draw.anchor(name, pos) }
    }
    alias(terms.at(0), pu, "u")
    alias(terms.at(1), pv, "v")
    alias(terms.at(2), pw, "w")

    cetz.draw.anchor("neutral", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("winding", name, ..positions, ..overrides, draw: draw)
}
