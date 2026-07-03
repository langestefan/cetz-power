// Annotation arrow for power-flow / current direction along a
// conductor, with an optional caption beside its midpoint.
//
// CeTZ gotcha this helper encapsulates: a dashed line's arrowhead
// inherits the dash pattern and renders broken unless the mark gets
// its own solid stroke. `flow-arrow` always builds a solid mark stroke
// from the line's paint and thickness, so dashed "return flow" arrows
// come out with clean heads.

#import "/src/deps.typ": cetz
#import "/src/helpers/note.typ": note

/// Draw an annotation arrow from `from` to `to` (arrowhead at `to`),
/// optionally captioned at its midpoint.
///
/// This is for *annotations* — power-flow directions, current arrows,
/// legend entries, tap-changer arrows — not for conductors; use
/// `wire()` for anything that carries the circuit.
///
/// ```typst
/// flow-arrow((0, 0), (1, 0), label: [$Q_1$])
/// flow-arrow((1, -0.4), (0, -0.4), stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))
/// flow-arrow("b1.mid", "t.center", stroke: 0.7pt + red, scale: 0.6)
/// ```
///
/// - from (coordinate): arrow tail — any CeTZ coord (anchor, tuple, lerp).
/// - to (coordinate): arrow tip.
/// - label (content): optional caption beside the arrow midpoint.
/// - side (str): which side of the midpoint the caption sits on
///   (compass direction, as in `note`). Default `"north"`.
/// - distance (float): gap between the midpoint and the caption.
/// - size (length): caption font size. Default `7pt`.
/// - stroke: line stroke — thickness, paint and dash all honoured
///   (e.g. `1pt + red`, or a dict with `dash: "dashed"`). The
///   arrowhead is always drawn solid in the same paint.
/// - scale (float): arrowhead scale. Default `1`.
/// -> content
#let flow-arrow(
  from,
  to,
  label: none,
  side: "north",
  distance: 0.15,
  size: 7pt,
  stroke: 0.8pt + black,
  scale: 1,
) = {
  // Normalise the stroke so the mark can reuse its paint/thickness
  // with the dash stripped (a dashed mark stroke breaks the head).
  let st = std.stroke(stroke)
  let paint = if st.paint == auto { black } else { st.paint }
  let thickness = if st.thickness == auto { 0.8pt } else { st.thickness }

  cetz.draw.line(
    from,
    to,
    stroke: stroke,
    mark: (
      end: ">",
      fill: paint,
      stroke: thickness + paint,
      scale: scale,
    ),
  )
  if label != none {
    note((from, 50%, to), label, side: side, distance: distance, size: size)
  }
}
