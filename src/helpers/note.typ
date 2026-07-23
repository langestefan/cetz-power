// Free-floating text-label helper for captions on coordinates / anchors.

#import "/src/deps.typ": cetz
#import "/src/layout.typ": (
  compass-of-angle, compass-opposites as _opposite-side, perp-of, upright,
)

// Shared placement: put `body` on `side` of `pos`, optionally rotated
// upright (for east/west sides beside a vertical run).
#let _place(pos, body, side, up, distance, text-align, size) = {
  assert(
    side in _opposite-side,
    message: "note() side must be one of "
      + repr(_opposite-side.keys())
      + ", got "
      + repr(side),
  )
  let aligned = if text-align == auto { body } else { align(text-align, body) }
  let turned = if up { upright(aligned, side) } else { aligned }
  cetz.draw.content(
    pos,
    anchor: _opposite-side.at(side),
    padding: distance,
    text(size: size, turned),
  )
}

/// Position a free-floating text label next to a coordinate or anchor,
/// or caption a segment between two coordinates.
///
/// **Point form** — `note(pos, body)` is shorthand for the manual
/// `cetz.draw.content` call you'd otherwise write to put a caption
/// beside a wire midpoint, an anchor, or a tap point. It picks the
/// content's anchor opposite to `side` and uses `padding` for the gap,
/// so the text always sits cleanly on the requested side of `pos`.
///
/// **Segment form** — `note(a, b, body)` captions the segment from `a`
/// to `b` (a conductor, a bus span, …): the label sits at the fraction
/// `at:` along it (midpoint by default), `side: auto` resolves to the
/// segment's perpendicular (north beside a horizontal run, east beside
/// a vertical one), and `upright: auto` turns the text to read along a
/// vertical segment. This replaces the hand-rolled "length label"
/// closures of the recipes.
///
/// ```typst
/// note((5, 0), [Hello])                          // text above (5, 0)
/// note("M1.west", [Motor], side: "west")         // text left of M1
/// note("b1.mid", "b2.mid", [500 m])              // caption on the free side
/// note("a.in", "b.in", [Kabel], at: 0.3)         // 30 % of the way along
/// ```
///
/// - ..args: `pos, body` (point form) or `a, b, body` (segment form).
///   Coordinates take any CeTZ form — anchor name, absolute tuple,
///   lerp `("a", t, "b")`, …
/// - side (str | auto): which side the label sits on. One of
///   `"north"`, `"south"`, `"east"`, `"west"` and the four diagonals.
///   `auto` (default) is `"north"` in point form and the segment's
///   perpendicular in segment form.
/// - distance (float): gap (in canvas units) between the anchor point
///   and the nearest edge of the text. Default `0.15`.
/// - text-align (alignment | auto): how multi-line text aligns inside
///   its bounding box. `auto` (default) leaves cetz's default; pass
///   `left` / `center` / `right` to override.
/// - size (length): font size. Default `7pt` (matches `#set text(size: 7pt)`
///   in most snippets; bump up for larger captions).
/// - upright (bool | auto): rotate the text -90° so it reads along a
///   vertical run when it sits east/west. `auto` (default) does so in
///   segment form only.
/// - at (ratio | float): segment form only — where along `a`→`b` the
///   label anchors. Floats are fractions (`0.3` = 30 %). Default `50%`.
/// -> content
#let note(
  ..args,
  side: auto,
  distance: 0.15,
  text-align: auto,
  size: 7pt,
  upright: auto,
  at: 50%,
) = {
  let pos-args = args.pos()
  assert(
    pos-args.len() in (2, 3),
    message: "note() takes (pos, body) or (a, b, body), got "
      + str(pos-args.len())
      + " arguments",
  )
  if pos-args.len() == 2 {
    let (pos, body) = pos-args
    let s = if side == auto { "north" } else { side }
    let up = if upright == auto { false } else { upright }
    _place(pos, body, s, up, distance, text-align, size)
  } else {
    let (a, b, body) = pos-args
    let t = if type(at) == ratio { at } else { at * 100% }
    cetz.draw.get-ctx(ctx => {
      let (_ctx, ra, rb) = cetz.coordinate.resolve(ctx, a, b)
      let s = if side == auto {
        compass-of-angle(perp-of(cetz.vector.angle2(ra, rb)))
      } else { side }
      let up = if upright == auto { s in ("east", "west") } else { upright }
      _place((a, t, b), body, s, up, distance, text-align, size)
    })
  }
}
