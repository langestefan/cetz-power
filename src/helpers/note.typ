// Free-floating text-label helper for captions on coordinates / anchors.

#import "/src/deps.typ": cetz

// Map "the side I want my label to sit on" to "the anchor on the
// label that should land at the supplied position". They're opposites.
// Used by both `note` and `wire(..., label: …)`.
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

/// Position a free-floating text label next to a coordinate or anchor.
///
/// `note(pos, body, side: "north")` is shorthand for the manual
/// `cetz.draw.content` call you'd otherwise write to put a caption
/// beside a wire midpoint, an anchor, or a tap point. It picks the
/// content's anchor opposite to `side` and uses `padding` for the gap,
/// so the text always sits cleanly on the requested side of `pos`.
///
/// ```typst
/// note((5, 0), [Hello], side: "north")           // text above (5, 0)
/// note("M1.west", [Motor], side: "west")          // text left of M1
/// note(("a", 50%, "b"), [Kabel], side: "south")   // below the midpoint of a-b
/// ```
///
/// - pos (coordinate): where to anchor the label — anchor name,
///   absolute tuple, lerp `("a", t, "b")`, or any other CeTZ coord.
/// - body (content): the label content.
/// - side (str): which side of `pos` the label sits on. One of
///   `"north"`, `"south"`, `"east"`, `"west"`, `"north-east"`,
///   `"north-west"`, `"south-east"`, `"south-west"`. Default `"north"`.
/// - distance (float): gap (in canvas units) between `pos` and the
///   nearest edge of the text. Default `0.15`.
/// - text-align (alignment | auto): how multi-line text aligns inside
///   its bounding box. `auto` (default) leaves cetz's default; pass
///   `left` / `center` / `right` to override.
/// - size (length): font size. Default `7pt` (matches `#set text(size: 7pt)`
///   in most snippets; bump up for larger captions).
/// -> content
#let note(
  pos,
  body,
  side: "north",
  distance: 0.15,
  text-align: auto,
  size: 7pt,
) = {
  assert(
    side in _opposite-side,
    message: "note() side must be one of " + repr(_opposite-side.keys())
      + ", got " + repr(side),
  )
  let aligned = if text-align == auto { body } else { align(text-align, body) }
  cetz.draw.content(
    pos,
    anchor: _opposite-side.at(side),
    padding: distance,
    text(size: size, aligned),
  )
}
