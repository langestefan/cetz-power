// Internal helpers — not part of the public API.

#import "deps.typ": cetz

/// Map a "compass" anchor to its opposite. Non-compass names fall back to
/// "center" — they're assumed to be symbol-specific anchors and the caller
/// should set `align:` explicitly.
#let opposite(anchor) = (
  north: "south", south: "north",
  east: "west",   west: "east",
  "north-east": "south-west", "south-west": "north-east",
  "north-west": "south-east", "south-east": "north-west",
).at(anchor, default: "center")

/// Anchor to place a label on given the symbol's bounding rotation angle.
/// For a horizontal symbol (0deg) labels go "north" (above) by default.
#let label-anchor-for-angle(ang) = {
  // Normalise angle to [0, 360)
  let a = calc.rem(ang / 1deg, 360)
  if a < 0 { a = a + 360 }
  // Four quadrants → four cardinal anchors
  if a <= 45 or a > 315 { "north" }
  else if a <= 135 { "west" }
  else if a <= 225 { "south" }
  else { "east" }
}

/// Resolve a style dict by merging:
///   base defaults <- family defaults <- user overrides
#let resolve-style(ctx, family, overrides) = {
  let pg = ctx.style.at("powergretz", default: (:))
  let base = pg
  let fam-defaults = pg.at(family, default: (:))
  // Merge: start from flat top-level, then family, then per-call overrides.
  // We only copy scalar keys that make sense at the top level.
  let merged = (:)
  for (k, v) in base {
    if type(v) != dictionary {
      merged.insert(k, v)
    }
  }
  for (k, v) in fam-defaults {
    merged.insert(k, v)
  }
  for (k, v) in overrides {
    merged.insert(k, v)
  }
  merged
}

/// Convert a scale value (float or (x:, y:)) to a cetz-friendly pair.
#let normalise-scale(s) = {
  if type(s) == float or type(s) == int {
    (x: s, y: s)
  } else if type(s) == dictionary {
    (x: s.at("x", default: 1.0), y: s.at("y", default: 1.0))
  } else {
    (x: 1.0, y: 1.0)
  }
}
