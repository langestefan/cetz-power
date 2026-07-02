// Delta winding (Δ / D / d) — equilateral triangle with the three phase
// terminals at its vertices. Default orientation matches IEC clock 0:
// V at the top vertex, U bottom-left, W bottom-right. Use `angle:` to
// rotate for other clock numbers (`angle: -clock * 30deg`).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Delta winding configuration.
///
/// Anchors: `u`, `v`, `w` (the three triangle vertices, suitable as
/// wire endpoints), `mid-uv`, `mid-vw`, `mid-wu` (midpoints of each
/// side — handy for placing a component on a side, e.g.
/// `currentsource(name, "d.u", "d.v")` runs along the U-V side and
/// `mid-uv` names its centre point), plus `center`, `north`,
/// `south`, `east`, `west`, and the standard `in` / `out` aliases.
///
/// The three vertex labels follow the `terminals` style key (default
/// `("U", "V", "W")`). Pass `terminals: ("u", "v", "w")` for a
/// secondary winding.
///
/// Pass `body: false` to skip drawing the triangle outline and the
/// per-vertex labels — the anchors are still exposed, so the symbol
/// becomes a placement scaffold for components you draw on the sides
/// (current sources between vertices, for instance).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): centre of the triangle.
/// - size (float): circumradius — distance from centre to each vertex.
/// - terminals (array): three label strings/contents in (U, V, W) order.
/// - body (bool): draw the triangle outline and vertex labels (default
///   `true`). Set to `false` to keep only the anchors.
/// - stroke / fill: passed straight to the triangle outline.
/// - angle (angle): rotation around the centre.
/// - label (content | dict | none): outer caption.
/// -> content
#let delta(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("size", default: 0.6)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let terms = style.at("terminals", default: ("U", "V", "W"))
    let lsize = style.at("label-size", default: 8pt)
    let ldist = style.at("label-distance", default: 0.18)
    let body = style.at("body", default: true)
    let rot = ctx.at("rotation", default: 0deg)

    // Vertices: V at 90°, U at 210°, W at 330°.
    let vert(deg) = (calc.cos(deg) * r, calc.sin(deg) * r)
    let pv = vert(90deg)
    let pu = vert(210deg)
    let pw = vert(330deg)

    if body {
      cetz.draw.line(pu, pv, pw, close: true, stroke: s, fill: f)

      // Per-terminal italic labels, counter-rotated so they stay upright.
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

    // Vertex anchors — by canonical name (u/v/w) and by the user-
    // supplied label, so callers can write `wire("t.U", …)` or
    // `wire("t.u", …)` regardless of which case they passed.
    cetz.draw.anchor("u", pu)
    cetz.draw.anchor("v", pv)
    cetz.draw.anchor("w", pw)
    // Side midpoints — useful for labelling or attaching a per-side
    // component when the body is drawn, or for naming the centre of a
    // user-drawn current source between two vertices when it isn't.
    let mid(a, b) = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
    cetz.draw.anchor("mid-uv", mid(pu, pv))
    cetz.draw.anchor("mid-vw", mid(pv, pw))
    cetz.draw.anchor("mid-wu", mid(pw, pu))
    let alias(name, pos, fallback) = {
      if type(name) == str and name != fallback { cetz.draw.anchor(name, pos) }
    }
    alias(terms.at(0), pu, "u")
    alias(terms.at(1), pv, "v")
    alias(terms.at(2), pw, "w")

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("default", (0, 0))
    // Cardinal anchors sit on the bounding circle at radius `r`,
    // regardless of where the vertices are — handy for the outer label.
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("winding", name, ..positions, ..overrides, draw: draw)
}
