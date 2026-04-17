// Core building blocks for power-system symbols.
//
// Every symbol in `src/symbols/*` calls `symbol()` to register a named
// CeTZ group with anchors. Anchors are how callers attach wires, labels,
// and child symbols. The primitive also handles:
//
//   * style resolution (merging family defaults with per-call overrides)
//   * coordinate resolution (one-node: placed at point, two-node: spans)
//   * label rendering with sensible defaults
//   * optional debug rendering of anchors

#import "deps.typ": cetz
#import "styles.typ": default as default-styles
#import "utils.typ": resolve-style, label-anchor-for-angle, normalise-scale, opposite

#let _angle-type = angle

/// Low-level constructor used by every powergretz symbol.
///
/// Symbol authors pass a `draw` closure with signature
/// `(ctx, positions, style) => { ... cetz draw calls ... }`. The closure is
/// invoked inside a translated/rotated CeTZ group, so it can draw in the
/// symbol's local frame with (0, 0) at the symbol's origin.
///
/// The `positions` argument is the list of resolved coordinates. For a
/// one-node symbol it has one entry; for a two-node (in/out) symbol it
/// has two entries in local space (`in` becomes (0, 0), `out` lies on
/// the +x axis at the distance between nodes).
///
/// The `style` dict is the fully-merged style for this family.
///
/// - family (str): name under `powergretz.*` in the style dict
/// - name (str): unique CeTZ group name
/// - draw (function): closure that draws the symbol in local space
/// - label (content | str | dict | none): label to render next to the symbol
/// - angle (angle): rotation (only allowed for one-node symbols)
/// -> content
#let symbol(
  family,
  name,
  draw: none,
  label: none,
  angle: 0deg,
  ..positions-and-overrides,
) = {
  let positions = positions-and-overrides.pos()
  let overrides = positions-and-overrides.named()

  assert(
    positions.len() in (1, 2),
    message: "symbol() takes 1 or 2 positions, got " + str(positions.len()),
  )
  assert(
    type(angle) == _angle-type,
    message: "angle must be an angle (e.g. 90deg)",
  )
  assert(
    positions.len() == 1 or angle == 0deg,
    message: "cannot use `angle:` on a two-node symbol (direction is set by nodes)",
  )
  assert(
    type(name) == str and name.len() > 0,
    message: "symbol name must be a non-empty string",
  )

  cetz.draw.group(name: name, ctx => {
    // Preserve caller's top-level style so overrides don't leak after this group.
    let keep-style = ctx.style
    let style = resolve-style(ctx, family, overrides)

    // Resolve coordinates. We only accept bare coordinates here; no
    // auto-naming or side-effects on the context beyond what cetz does.
    let (ctx, ..resolved) = cetz.coordinate.resolve(ctx, ..positions)

    let origin
    let effective-angle = angle
    if resolved.len() == 1 {
      origin = resolved.first()
      // Expose "in" and "out" on the one-node symbol as aliases for the origin.
      cetz.draw.anchor("in", resolved.first())
      cetz.draw.anchor("out", resolved.first())
    } else {
      // Two-node: place at midpoint, rotate so x-axis points from in -> out.
      let a = resolved.first()
      let b = resolved.last()
      effective-angle = cetz.vector.angle2(a, b)
      // Use midpoint via a lerp; we want the symbol centered between the nodes.
      origin = (a, 50%, b)
      cetz.draw.anchor("in", a)
      cetz.draw.anchor("out", b)
    }

    cetz.draw.set-origin(origin)
    cetz.draw.rotate(effective-angle)

    // Let the draw fn see the rotation angle if it needs to counter-rotate text.
    let ctx-with-rot = ctx
    ctx-with-rot.insert("rotation", effective-angle)

    // Apply scale from style.
    let sc = normalise-scale(style.at("scale", default: 1.0))
    cetz.draw.scale(x: sc.x, y: sc.y)

    // Draw the symbol.
    cetz.draw.group(name: "shape", {
      draw(ctx-with-rot, resolved, style)
    })
    cetz.draw.copy-anchors("shape")

    // Restore outer style.
    cetz.draw.set-style(..keep-style)
  })

  // Label — drawn OUTSIDE the rotated group, in world frame, so text
  // stays upright regardless of the symbol's rotation.
  //
  // The `anchor:` style/option specifies a WORLD-SPACE compass direction
  // ("north", "east", ...) where the label sits relative to the symbol.
  // We translate that into the corresponding LOCAL anchor of the symbol
  // (rotated back through -effective-angle) and attach there.
  let lbl = if type(label) == dictionary { label.at("content", default: none) } else { label }
  if lbl != none {
    cetz.draw.get-ctx(ctx => {
      let style = resolve-style(ctx, family, positions-and-overrides.named())
      let label-style = style.at("label", default: (:))
      let lbl-dict = if type(label) == dictionary { label } else { (content: lbl) }
      let ls = (:)
      for (k, v) in label-style { ls.insert(k, v) }
      for (k, v) in lbl-dict { ls.insert(k, v) }

      // Re-compute effective angle (same logic as in the group body).
      let effective-angle-outer = angle
      if positions.len() == 2 {
        let (_ctx, a, b) = cetz.coordinate.resolve(ctx, ..positions)
        effective-angle-outer = cetz.vector.angle2(a, b)
      }

      // World-space anchor direction. Default: "north" (above the symbol).
      let world-anchor = ls.at("anchor", default: "north")

      // Known compass names — only these get rotated into the symbol's local
      // frame. Any other string is taken to name a specific anchor the symbol
      // defined itself (e.g. "label-west" on a load), and we attach directly.
      //
      // Angles are CCW from world +x axis: east=0, north=90, west=180, south=270.
      // To find the LOCAL anchor whose rotated position lands at the requested
      // world direction, we subtract the symbol's effective-angle.
      let compass = (
        east: 0, "north-east": 45, north: 90, "north-west": 135,
        west: 180, "south-west": 225, south: 270, "south-east": 315,
      )
      let local-anchor = if type(world-anchor) != str {
        world-anchor
      } else if world-anchor not in compass {
        world-anchor
      } else {
        let world-deg = compass.at(world-anchor)
        let local-deg = calc.rem(world-deg - effective-angle-outer / 1deg, 360)
        if local-deg < 0 { local-deg = local-deg + 360 }
        // Snap: each cardinal owns a 45° sector centred on its angle.
        if local-deg < 22.5 or local-deg >= 337.5 { "east" }
        else if local-deg < 67.5 { "north-east" }
        else if local-deg < 112.5 { "north" }
        else if local-deg < 157.5 { "north-west" }
        else if local-deg < 202.5 { "west" }
        else if local-deg < 247.5 { "south-west" }
        else if local-deg < 292.5 { "south" }
        else { "south-east" }
      }

      let attach = if type(local-anchor) == str {
        name + ".shape." + local-anchor
      } else {
        local-anchor
      }

      // Text-align is in world-space (text box anchor). Default: opposite
      // of the world anchor, so text extends AWAY from the symbol.
      let text-align = ls.at("align", default: auto)
      if text-align == auto {
        text-align = if type(world-anchor) == str { opposite(world-anchor) } else { "center" }
      }

      cetz.draw.content(
        attach,
        anchor: text-align,
        padding: ls.at("distance", default: 0.15),
        text(size: ls.at("size", default: 8pt), ls.content),
      )
    })
  }

  // Leave the "pen" at the last position — mirrors cetz's expectation
  // so `line((), (rel: (1, 0)))` continues from where the symbol ended.
  cetz.draw.move-to(positions.last())
}
