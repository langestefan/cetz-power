// Internal helpers — not part of the public API.

#import "deps.typ": cetz
#import "layout.typ": opposite

/// Resolve a style dict by merging:
///   base defaults <- family defaults <- user overrides
#let resolve-style(ctx, family, overrides) = {
  let pg = ctx.style.at("cetz-power", default: (:))
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
  // The top-level `label` dict is the one nested dict that cascades:
  // a family's label keys overlay it (per key) rather than replacing
  // it wholesale, so e.g. a global
  // `set-style(cetz-power: (label: (anchor: "north")))` reaches every
  // family that doesn't pin its own anchor.
  let base-label = base.at("label", default: (:))
  if base-label.len() > 0 or "label" in fam-defaults {
    let lab = base-label
    for (k, v) in fam-defaults.at("label", default: (:)) {
      lab.insert(k, v)
    }
    merged.insert("label", lab)
  }
  for (k, v) in overrides {
    merged.insert(k, v)
  }
  merged
}

/// Resolve the orientation of a "drop" symbol (load / pv-panel /
/// factory / ev-charger) from its surroundings, instead of a manual
/// `angle:`. Returns a dict `(angle:, elbow:)` where `elbow: auto`
/// means "keep whatever the caller passed".
///
/// - `towards:` a coordinate the tip should aim at — pure rotation.
/// - `on:` the name of the bus the symbol taps. A (mostly) horizontal
///   bus gets a straight perpendicular drop (`side: "north"` flips it
///   above the bar); a (mostly) vertical bus gets the design-rule-8
///   L-bend — across by `elbow`, then down — on the `side: "east"`
///   (default) or `"west"` side of the bar.
///
/// The referenced bus must already be drawn (anchors resolve at draw
/// time), which matches the repo's draw-order convention.
#let drop-orientation(
  ctx,
  tap,
  on: none,
  towards: none,
  side: auto,
  elbow: 0.25,
) = {
  if towards != none {
    let (_ctx, t, target) = cetz.coordinate.resolve(ctx, tap, towards)
    // The tip points along local -y, so aiming it at φ means rotating
    // the symbol to φ + 90°.
    return (angle: cetz.vector.angle2(t, target) + 90deg, elbow: auto)
  }
  let (_ctx, a, b) = cetz.coordinate.resolve(ctx, on + ".start", on + ".end")
  let v = cetz.vector.sub(b, a)
  if calc.abs(v.at(1)) > calc.abs(v.at(0)) {
    // Vertical bus: leave the body perpendicular — an L-bend across,
    // then down — never straight off a tip (design rule 8).
    assert(
      side == auto or side in ("east", "west"),
      message: "side must be \"east\" or \"west\" on a vertical bus, got "
        + repr(side),
    )
    (angle: 0deg, elbow: if side == "west" { -elbow } else { elbow })
  } else {
    // Horizontal bus: straight perpendicular drop below the bar (or
    // above it with side: "north").
    assert(
      side == auto or side in ("north", "south"),
      message: "side must be \"north\" or \"south\" on a horizontal bus, got "
        + repr(side),
    )
    (angle: if side == "north" { 180deg } else { 0deg }, elbow: auto)
  }
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
