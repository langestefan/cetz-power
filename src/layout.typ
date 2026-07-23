// Shared layout geometry — pure functions, no CeTZ drawing.
//
// Everything that turns a direction (an angle or a vector) into a compass
// anchor, or a compass side into its opposite, lives here. Both `symbols/`
// and `helpers/` import this module, which is why it must not import from
// either of them (it depends on nothing but the standard library).

/// The eight compass directions, ordered CCW from the world +x axis in
/// 45° steps: index k is the direction at k·45°.
#let compass-dirs = (
  "east",
  "north-east",
  "north",
  "north-west",
  "west",
  "south-west",
  "south",
  "south-east",
)

/// Map a compass side to its opposite. Used both as a lookup ("which
/// anchor on a label box lands the text on side X of a point") and as a
/// membership check for validating `side:` arguments.
#let compass-opposites = (
  "north": "south",
  "south": "north",
  "east": "west",
  "west": "east",
  "north-east": "south-west",
  "south-west": "north-east",
  "north-west": "south-east",
  "south-east": "north-west",
)

/// Opposite of a compass anchor. Non-compass names fall back to
/// "center" — they're assumed to be symbol-specific anchors and the
/// caller should set an alignment explicitly.
#let opposite(anchor) = compass-opposites.at(anchor, default: "center")

/// Snap an angle to the nearest compass direction.
///
/// Each direction owns the sector centred on its angle: 45° sectors for
/// the eight-way compass, 90° sectors (cardinals only) with
/// `cardinal-only: true` — use the latter when the result must name an
/// anchor every symbol registers (diagonal anchors are not guaranteed).
#let compass-of-angle(a, cardinal-only: false) = {
  let deg = calc.rem(a / 1deg, 360)
  if deg < 0 { deg = deg + 360 }
  if cardinal-only {
    let k = int(calc.rem(calc.round(deg / 90), 4))
    ("east", "north", "west", "south").at(k)
  } else {
    let k = int(calc.rem(calc.round(deg / 45), 8))
    compass-dirs.at(k)
  }
}

/// Snap a direction vector `(x, y)` to the nearest compass direction.
#let compass-of(v, cardinal-only: false) = compass-of-angle(
  calc.atan2(v.at(0), v.at(1)),
  cardinal-only: cardinal-only,
)

/// The perpendicular of an axis, as an angle, preferring the upper
/// half-plane: for a horizontal axis this is +90° (north side); for a
/// vertical axis — where both perpendiculars are horizontal — it
/// resolves the tie to +x (east side). This is the "free side" of a
/// two-node symbol whose connections run along the axis.
#let perp-of(a) = {
  let p = a + 90deg
  let s = calc.sin(p)
  if s < -1e-9 or (calc.abs(s) <= 1e-9 and calc.cos(p) < 0) {
    p = a - 90deg
  }
  p
}

/// Rotate label content upright beside a vertical run: content sitting
/// on the east/west side of a vertical segment reads along it, so it is
/// turned -90° (reflowed); on any other side it is returned unchanged.
#let upright(c, side) = {
  if side in ("east", "west") { rotate(-90deg, reflow: true, c) } else { c }
}
