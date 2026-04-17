// Wires — plain lines between points, or elbow (L-shape) connections.
//
// Not a full "symbol" — no label support and no style-family resolution.
// Wires are the glue between named anchors of symbols and buses.

#import "/src/deps.typ": cetz

// Look up the wire stroke from the active cetz-power style, or fall back.
#let _wire-stroke(ctx, override) = {
  if override != auto { return override }
  ctx.style
    .at("cetz-power", default: (:))
    .at("wire", default: (:))
    .at("stroke", default: 0.8pt + black)
}

/// Straight wire from `a` to `b`.
///
/// - a (coordinate): start
/// - b (coordinate): end
/// - stroke: stroke override; defaults to `cetz-power.wire.stroke`
/// -> content
#let wire(a, b, stroke: auto) = {
  cetz.draw.get-ctx(ctx => {
    cetz.draw.line(a, b, stroke: _wire-stroke(ctx, stroke))
  })
}

/// Elbow wire — two orthogonal segments joined at a right-angle corner.
///
/// `corner: "h"` goes horizontally first then vertically; `corner: "v"`
/// vertically first then horizontally. The intermediate point is computed
/// via CeTZ's perpendicular-coordinate syntax, so `a` and `b` can be
/// anchor names or mixed coordinates.
///
/// - a (coordinate): start
/// - b (coordinate): end
/// - corner ("h" | "v"): routing order of the two legs
/// - stroke: stroke override
/// -> content
#let elbow(a, b, corner: "h", stroke: auto) = {
  assert(corner in ("h", "v"), message: "corner must be \"h\" or \"v\"")
  cetz.draw.get-ctx(ctx => {
    let s = _wire-stroke(ctx, stroke)
    // (a, "-|", b) → point with a's x, b's y → vertical-first L
    // (a, "|-", b) → point with b's x, a's y → horizontal-first L
    let knee = if corner == "h" { (a, "|-", b) } else { (a, "-|", b) }
    cetz.draw.line(a, knee, b, stroke: s)
  })
}
