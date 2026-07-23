// Wires — plain lines between points, or elbow (L-shape) connections.
//
// Not a full "symbol" — no style-family resolution. Wires are the
// glue between named anchors of symbols and buses. They optionally
// accept a `label:` argument that drops a text caption at the
// midpoint of the polyline (see the `wire` doc-comment below).

#import "/src/deps.typ": cetz
#import "/src/layout.typ": (
  compass-of-angle, compass-opposites as _opposite-side, perp-of, upright,
)

// Look up the wire stroke from the active cetz-power style, or fall back.
// `kind: "cable"` re-dashes the resolved stroke (pattern from the
// `cetz-power.wire.cable-dash` style key) so underground cables read
// differently from overhead lines / plain connections.
#let _wire-stroke(ctx, override, kind: "line") = {
  assert(
    kind in ("line", "cable"),
    message: "wire kind must be \"line\" or \"cable\", got " + repr(kind),
  )
  let wire-style = ctx
    .style
    .at("cetz-power", default: (:))
    .at("wire", default: (:))
  let base = if override != auto { override } else {
    wire-style.at("stroke", default: 0.8pt + black)
  }
  if kind == "line" { return base }
  let st = std.stroke(base)
  (
    paint: if st.paint == auto { black } else { st.paint },
    thickness: if st.thickness == auto { 0.8pt } else { st.thickness },
    dash: wire-style.at("cable-dash", default: "dashed"),
  )
}

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
/// the polyline (halfway between the FIRST and LAST positional
/// points). `label-side:` picks which side of the midpoint the text
/// sits on — `"north"` / `"south"` / `"east"` / `"west"` plus the
/// four 45° diagonals. The default `auto` resolves to the wire's
/// perpendicular: north above a horizontal wire, east beside a
/// vertical one — where `label-upright: auto` also turns the text to
/// read along the conductor.
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
/// - kind (str): `"line"` (default) — solid conductor; `"cable"` —
///   the stroke is re-dashed (pattern from the
///   `cetz-power.wire.cable-dash` style key) to distinguish
///   underground cables from overhead lines.
/// - stroke: stroke override; defaults to `cetz-power.wire.stroke`.
/// - label: optional caption content placed at the wire midpoint.
/// - label-side: compass side of the midpoint the label sits on.
///   Default `auto` — the wire's perpendicular.
/// - label-upright: rotate the caption -90° when it sits east/west
///   (beside a vertical wire) so it reads along the conductor.
///   Default `auto` — on for auto-resolved sides, off for an
///   explicitly passed `label-side`.
/// - label-distance: gap between the wire and the label edge in canvas
///   units. Default `0.15`.
/// - label-align: horizontal alignment of the label box relative to
///   the wire midpoint — `"left"` pins the box's left edge at the
///   midpoint (text extends right), `"center"` centres the box on
///   the midpoint (the default), `"right"` pins the right edge at
///   the midpoint (text extends left). Only meaningful for
///   `label-side: "north"` or `"south"`; ignored for sideways labels.
/// - label-size: font size for the label. Default `7pt`.
/// -> content
#let wire(..args) = {
  let pts = args.pos()
  let named = args.named()
  let stroke = named.at("stroke", default: auto)
  let kind = named.at("kind", default: "line")
  let label = named.at("label", default: none)
  let label-side = named.at("label-side", default: auto)
  let label-upright = named.at("label-upright", default: auto)
  let label-distance = named.at("label-distance", default: 0.15)
  let label-align = named.at("label-align", default: "center")
  let label-size = named.at("label-size", default: 7pt)
  assert(
    label-align in ("left", "center", "right"),
    message: "wire label-align must be \"left\", \"center\", or \"right\", got "
      + repr(label-align),
  )
  assert(
    pts.len() >= 2,
    message: "wire() needs at least two positions, got " + str(pts.len()),
  )
  cetz.draw.get-ctx(ctx => {
    cetz.draw.line(..pts, stroke: _wire-stroke(ctx, stroke, kind: kind))

    if label != none {
      // Resolve every point (handles rel/turtle forms) so the midpoint
      // and the auto side come from real geometry.
      let (_ctx, ..rpts) = cetz.coordinate.resolve(ctx, ..pts)
      let (a, b) = (rpts.first(), rpts.last())
      let side = if label-side == auto {
        // The wire's perpendicular: north above a horizontal wire,
        // east beside a vertical one.
        compass-of-angle(perp-of(cetz.vector.angle2(a, b)))
      } else { label-side }
      assert(
        side in _opposite-side,
        message: "wire label-side must be a compass direction, got "
          + repr(side),
      )
      let up = if label-upright == auto { label-side == auto } else {
        label-upright
      }
      let body = if up { upright(label, side) } else { label }
      let mid = (
        (a.at(0) + b.at(0)) / 2,
        (a.at(1) + b.at(1)) / 2,
      )
      // For side north/south the base anchor is south/north (centred
      // on the midpoint). label-align shifts the anchor horizontally so the
      // label box's left/right edge — instead of its centre — sits on the
      // midpoint, which lets multiple labels be made flush at the same x.
      let base-anchor = _opposite-side.at(side)
      let h-suffix = (left: "-west", center: "", right: "-east").at(label-align)
      let anchor = if side in ("north", "south") {
        base-anchor + h-suffix
      } else {
        base-anchor
      }
      cetz.draw.content(
        mid,
        anchor: anchor,
        padding: label-distance,
        text(size: label-size, body),
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
/// With `stub: d` the elbow instead draws the design-rule-4 join for a
/// run that must move sideways: a perpendicular stub of length `d` out
/// of `a`, a diagonal, and an equal perpendicular stub into `b` — so
/// both ends meet their bars at 90° with no corner point. `corner`
/// picks the stub axis: `"v"` leaves/enters vertically (between
/// horizontal bars), `"h"` horizontally (between vertical bars).
///
/// - a (coordinate): start
/// - b (coordinate): end
/// - corner ("h" | "v"): routing order of the two legs (with `stub:`,
///   the axis of the two end stubs)
/// - stub (float): perpendicular stub length at both ends; `0`
///   (default) draws the plain right-angle corner.
/// - kind (str): `"line"` (default) or `"cable"` — as on `wire()`.
/// - stroke: stroke override
/// -> content
#let elbow(a, b, corner: "h", stub: 0, kind: "line", stroke: auto) = {
  assert(corner in ("h", "v"), message: "corner must be \"h\" or \"v\"")
  cetz.draw.get-ctx(ctx => {
    let s = _wire-stroke(ctx, stroke, kind: kind)
    if stub == 0 {
      // CeTZ perpendicular coordinates: (a, "-|", b) resolves to (b's x,
      // a's y) — the horizontal-first knee — and (a, "|-", b) to (a's x,
      // b's y) — the vertical-first knee.
      let knee = if corner == "h" { (a, "-|", b) } else { (a, "|-", b) }
      cetz.draw.line(a, knee, b, stroke: s)
    } else {
      // Stub → diagonal → equal stub (both joins perpendicular).
      let (_ctx, ra, rb) = cetz.coordinate.resolve(ctx, a, b)
      let axis = if corner == "v" { 1 } else { 0 }
      let sg = if rb.at(axis) >= ra.at(axis) { 1 } else { -1 }
      let step(p, d) = if axis == 1 {
        (p.at(0), p.at(1) + d)
      } else {
        (p.at(0) + d, p.at(1))
      }
      cetz.draw.line(
        a,
        step(ra, sg * stub),
        step(rb, -sg * stub),
        b,
        stroke: s,
      )
    }
  })
}
