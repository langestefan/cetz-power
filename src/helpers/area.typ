// Area / group box — the dashed boundary rectangle that groups part
// of a network (a station envelope, a feeder, a plant area, a turbine
// enclosure), with an optional title tucked into a corner or edge.
//
// The rectangle is a *named* CeTZ element, so its compass anchors
// ("<name>.north-west", "<name>.east", …) stay available for routing
// leads to the boundary or hanging further annotations off it.

#import "/src/deps.typ": cetz
#import "/src/helpers/note.typ": _opposite-side

/// Draw a boundary rectangle between two opposite corners, with an
/// optional title at one of its sides/corners.
///
/// Draw areas *first* — they are backdrops, and anything drawn later
/// sits on top. Design rule: the border may be crossed by leads, but
/// should not slice through a symbol body.
///
/// ```typst
/// area("st", (0, 0), (4, 3), title: [Onderstation], side: "north")
/// area("dvpp", (0, 0), (6, 3), title: [DVPP area], side: "south-west",
///      fill: luma(245), radius: 0.12)
/// wire("st.west", (rel: (-1, 0)))   // the rect's anchors stay usable
/// ```
///
/// - name (str): CeTZ element name — exposes the rectangle's compass
///   anchors for later routing.
/// - a, b (coordinates): two opposite corners.
/// - title (content): optional caption. Default `none`.
/// - side (str): which side/corner of the rectangle the title sits at —
///   a compass direction. Default `"north-west"`.
/// - inside (bool): `true` (default) tucks the title just inside the
///   border; `false` places it just outside.
/// - distance (float): gap between the border and the title.
/// - size (length): title font size (an explicit `text(...)` in `title`
///   overrides it).
/// - text-align (alignment | auto): multi-line title alignment.
/// - stroke: border stroke. Default thin dashed; pass `none` for a
///   borderless backdrop.
/// - fill (color | none): area backdrop fill.
/// - radius (float): corner radius of the rectangle.
/// -> content
#let area(
  name,
  a,
  b,
  title: none,
  side: "north-west",
  inside: true,
  distance: 0.12,
  size: 7pt,
  text-align: auto,
  stroke: (dash: "dashed", thickness: 0.6pt),
  fill: none,
  radius: 0,
) = {
  cetz.draw.rect(a, b, name: name, stroke: stroke, fill: fill, radius: radius)
  if title != none {
    assert(
      side in _opposite-side,
      message: "area() side must be one of "
        + repr(_opposite-side.keys())
        + ", got "
        + repr(side),
    )
    // Inside: the title's own `side` corner lands on the rect's `side`
    // corner and the padding pushes it inward. Outside: the opposite.
    let anchor = if inside { side } else { _opposite-side.at(side) }
    let body = if text-align == auto { title } else { align(text-align, title) }
    cetz.draw.content(
      name + "." + side,
      anchor: anchor,
      padding: distance,
      text(size: size, body),
    )
  }
}
