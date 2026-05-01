// Capacitor — two parallel plates with a lead at each end.
//
// Default form is the symmetric two-pole textbook capacitor: a lead
// from `in` up to the bottom plate, the two plates, then a matching
// upper lead ending at `out`. This is the natural shape for inline /
// series-capacitor wiring and what readers expect when they see a
// capacitor symbol on its own.
//
// Single-line / one-line diagrams sometimes draw a *shunt* cap without
// a return-to-ground wire — pass `lead-out: 0` to suppress the upper
// lead and the `out` anchor.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Capacitor — two parallel plates with a lead at each end (the
/// default symmetric form). Pass `lead-out: 0` for a single-lead shunt
/// cap (no top lead, no `out` anchor).
///
/// Default orientation: `in` is at the bottom and `out` is at the top
/// (when present); the plates lie horizontally between them. Pass
/// `angle:` to rotate (`180deg` flips the symbol upside-down, `-90deg`
/// makes it horizontal with the lead extending right and plates
/// vertical).
///
/// Anchors: `in` (= `default`, = `south`), `out` (top of the upper
/// lead — present only when `lead-out > 0`), `north` (top of the upper
/// lead if `lead-out > 0`, else the top plate), `east` and `west`
/// (right / left plate ends), `center` (between the plates).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - plate-width (float): width of each plate (style override).
/// - plate-gap (float): distance between the two plates.
/// - lead-in (float): length of the lead from `in` up to the bottom plate.
/// - lead-out (float): length of the lead above the top plate. Default
///   is non-zero (symmetric two-pole cap, `out` anchor exposed). Set
///   to `0` to suppress the upper lead and the `out` anchor — the
///   shunt / single-line form.
/// - stroke: stroke for both leads and plates (style override).
/// - plate-stroke: separate stroke override for the plates (defaults to
///   `stroke`). Useful when you want thicker plates than the lead.
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let capacitor(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let plate-stroke = style.at("plate-stroke", default: s)
    let pw = style.at("plate-width", default: 0.5)
    let pg = style.at("plate-gap", default: 0.12)
    let li = style.at("lead-in", default: 0.3)
    let lo = style.at("lead-out", default: 0.3)

    // Geometry along +y. The lead enters from below at the origin and
    // ends at the bottom plate; the second plate sits `plate-gap` above.
    let bottom-y = li
    let top-y = bottom-y + pg
    let mid-y = (bottom-y + top-y) / 2
    let out-y = top-y + lo

    if li > 0 {
      cetz.draw.line((0, 0), (0, bottom-y), stroke: s)
    }
    cetz.draw.line(
      (-pw / 2, bottom-y), (pw / 2, bottom-y),
      stroke: plate-stroke,
    )
    cetz.draw.line(
      (-pw / 2, top-y), (pw / 2, top-y),
      stroke: plate-stroke,
    )
    if lo > 0 {
      cetz.draw.line((0, top-y), (0, out-y), stroke: s)
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("center", (0, mid-y))
    cetz.draw.anchor("east", (pw / 2, mid-y))
    cetz.draw.anchor("west", (-pw / 2, mid-y))
    // `out` always points at the body's far end (the upper lead when
    // lead-out > 0, otherwise the top plate). The outer symbol()
    // wrapper sets a default "out" at the placement point for one-
    // node symbols, which would silently collide with `in`; we
    // override it here so chaining wires off `out` always works.
    let north-y = if lo > 0 { out-y } else { top-y }
    cetz.draw.anchor("out", (0, north-y))
    cetz.draw.anchor("north", (0, north-y))
  }

  symbol("capacitor", name, ..positions, ..overrides, draw: draw)
}
