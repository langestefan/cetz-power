// Wires — plain lines between points, or elbow (L-shape) connections.
//
// Not a full "symbol" — no style-family resolution. Wires are the
// glue between named anchors of symbols and buses. They optionally
// accept a `label:` argument that drops a text caption at the
// midpoint of the polyline (see the `wire` doc-comment below).

#import "/src/deps.typ": cetz

// Look up the wire stroke from the active cetz-power style, or fall back.
#let _wire-stroke(ctx, override) = {
  if override != auto { return override }
  ctx.style
    .at("cetz-power", default: (:))
    .at("wire", default: (:))
    .at("stroke", default: 0.8pt + black)
}

// Map "the side of the anchor I want my label to sit on" to "the
// anchor on the label that should land at the supplied position" —
// they're opposite compass directions. Used by `wire(..., label: …)`
// and by `helpers.typ::note`. Duplicated here (kept in sync) to
// avoid an import cycle between this file and helpers.typ.
#let _opposite-side = (
  "north":      "south",
  "south":      "north",
  "east":       "west",
  "west":       "east",
  "north-east": "south-west",
  "south-west": "north-east",
  "north-west": "south-east",
  "south-east": "north-west",
)

/// Wire — a straight segment or a multi-point polyline.
///
/// Pass two or more coordinates as positional arguments; consecutive
/// pairs are joined by straight segments. There is no smoothing, no
/// label, and no style-family cascade — wires are just thin lines
/// drawn at the active `cetz-power.wire.stroke`.
///
/// ## Coordinate forms accepted
///
/// Every positional argument is a CeTZ coordinate, so any of these
/// forms is valid (and they can be freely mixed in one call):
///
/// - **Anchor name** as a string — `"b1.tap2"`, `"t1.primary"`, …
/// - **Absolute tuple** — `(1.5, -0.4)`, `(x, y)`.
/// - **Relative offset from the previous point** — `(rel: <vec>)`
///   with **no** `to:` field. The offset is added to the most-recent
///   coordinate in the list. This is the "turtle" form — useful for
///   chaining short steps off a known anchor without computing each
///   point's absolute position.
/// - **Relative offset from a named anchor** — `(rel: <vec>, to: <coord>)`.
///   The offset is added to the supplied anchor (ignoring whatever
///   was the previous point in the list).
///
/// ## Examples
///
/// Two anchors — the most common case:
///
///     wire("b1.tap2", "t1.in")
///
/// Polyline through three or more anchors:
///
///     wire("La.in", "Lb.in", "Lc.in")
///
/// Turtle-style routing off a single anchor — each `(rel: <vec>)`
/// is "step from where I am now":
///
///     wire(
///       "b.tap2",
///       (rel: (0, -0.5)),      // drop 0.5 down
///       (rel: (1.2, 0)),       // step 1.2 right
///       (rel: (0, 0.5)),       // back up 0.5
///     )
///
/// Mix and match — anchors, absolute coords, and relative offsets in
/// one wire:
///
///     wire(
///       "b1.end",
///       (rel: (0.5, 0)),
///       (3, -1),
///       "b2.start",
///     )
///
/// ## Inline labels
///
/// Pass `label: <content>` to drop a text caption at the midpoint of
/// the polyline (the lerp-50 % between the FIRST and LAST positional
/// points). `label-side:` picks which side of the midpoint the text
/// sits on — `"north"` / `"south"` / `"east"` / `"west"` plus the
/// four 45° diagonals; defaults to `"north"` (above the wire).
///
///     wire("a.in", "b.in", label: [Kabel])
///     wire("a.in", "b.in", label: [Cable], label-side: "south")
///     wire("K3.tap2", "L1.in", label: [Belasting], label-distance: 0.2)
///
/// For full positioning control or for labels that aren't tied to a
/// wire, use the standalone `note()` helper instead.
///
/// - ..points (coordinates): two or more positional coordinates in
///   any of the forms listed above.
/// - stroke: stroke override; defaults to `cetz-power.wire.stroke`.
/// - label: optional caption content placed at the wire midpoint.
/// - label-side: compass side of the midpoint the label sits on.
///   Default `"north"`.
/// - label-distance: gap between the wire and the label edge in canvas
///   units. Default `0.15`.
/// - label-align: text alignment within the label box (`auto` to
///   inherit cetz's default; pass `left` / `center` / `right` to
///   override).
/// - label-size: font size for the label. Default `7pt`.
/// -> content
#let wire(..args) = {
  let pts = args.pos()
  let named = args.named()
  let stroke = named.at("stroke", default: auto)
  let label = named.at("label", default: none)
  let label-side = named.at("label-side", default: "north")
  let label-distance = named.at("label-distance", default: 0.15)
  let label-align = named.at("label-align", default: auto)
  let label-size = named.at("label-size", default: 7pt)
  assert(
    pts.len() >= 2,
    message: "wire() needs at least two positions, got " + str(pts.len()),
  )
  cetz.draw.get-ctx(ctx => {
    cetz.draw.line(..pts, stroke: _wire-stroke(ctx, stroke))

    if label != none {
      assert(
        label-side in _opposite-side,
        message: "wire label-side must be a compass direction, got " + repr(label-side),
      )
      // Midpoint of the first and last positional coordinates.
      let mid = (pts.first(), 50%, pts.last())
      let aligned = if label-align == auto { label } else { align(label-align, label) }
      cetz.draw.content(
        mid,
        anchor: _opposite-side.at(label-side),
        padding: label-distance,
        text(size: label-size, aligned),
      )
    }
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
