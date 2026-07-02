// Distribution feeder: a run with tapped transformer+load drops,
// per-segment current labels, and a dashed continuation.

#import "/src/deps.typ": cetz
#import "/src/symbols/grid/wire.typ": wire
#import "/src/symbols/grid/transformer.typ": transformer
#import "/src/symbols/loads/load.typ": load
#import "note.typ": note

// Snap a direction vector to the nearest of the eight compass anchors.
#let _compass-of(v) = {
  let deg = calc.atan2(v.at(0), v.at(1)) / 1deg
  let k = int(calc.rem(calc.round(deg / 45) + 8, 8))
  (
    "east",
    "north-east",
    "north",
    "north-west",
    "west",
    "south-west",
    "south",
    "south-east",
  ).at(k)
}

/// Draw a feeder: a straight run with an evenly-spaced tap per station,
/// each optionally carrying a transformer + load "drop", plus per-segment
/// current labels and a dashed continuation. Both feeders of a radial /
/// distribution diagram come from the same call with different data.
///
/// The run is horizontal, starting at `start` and going +x. Station `i`
/// is tapped at `start + (lead + i·spacing, 0)`; the drop hangs below
/// (or above, with `up: true`).
///
/// - name (str): base name; the i-th station's transformer / load get
///   `<name>-t<i>` / `<name>-l<i>` group names.
/// - start (coordinate): where the run begins (any CeTZ coordinate).
/// - stations (array): one dict per station. Recognised keys:
///     - `label` (content | none): caption beside the tap (e.g. station
///       id + voltage), placed opposite the drop.
///     - `load` (content | none): caption under the load arrow (e.g. the
///       LV rating). When present a transformer + load drop is drawn;
///       when absent / `none` the station is a bare labelled tap.
///     - `tx` (bool): per-station override of the feeder `tx` flag — set
///       `false` to hang the load straight off the tap (no transformer).
///     - `stroke` / `fill`: per-station load-arrow styling (thin / thick /
///       coloured), overriding the feeder `load-stroke` / `load-fill`.
///     - `tx-stroke` / `tx-fill`: per-station transformer styling,
///       overriding the feeder `tx-stroke` / `tx-fill`.
///     - `draw` (function): a custom drop drawer for this station,
///       overriding the feeder `drop-draw` (see below). Put anything off
///       the tap — a motor, capacitor, breaker, sub-feeder, …
/// - currents (array): segment labels, one per segment — there are
///   `stations.len() + 1` segments (the lead-in, each inter-station gap,
///   and the tail). `none` entries are skipped (e.g. when the first
///   segment is labelled elsewhere).
/// - lead (float): distance from `start` to the first station.
/// - spacing (float): distance between consecutive stations.
/// - tail (float | auto): distance from the last station to the line end.
///   `auto` (default) uses `lead`.
/// - extend (float): dashed continuation drawn past the end (`0` = none).
/// - angle (angle): direction of the run — the "angle of attack". `0deg`
///   (default) runs horizontally to the right; the whole feeder (stations,
///   drops, labels) rotates with it while text stays upright.
/// - line-stroke (stroke | auto): stroke of the main run. `auto` (default)
///   uses the active `cetz-power.wire.stroke` — pass e.g. `1.4pt + blue`
///   for a heavier or colour-coded feeder line.
/// - extend-stroke (stroke | auto): stroke of the dashed continuation.
///   `auto` (default) reuses the run's thickness and paint and just adds the
///   dash, so the solid run and dashed tail are the same weight.
/// - drop (float): length of the transformer + load drop.
/// - drop-angle (angle | auto): direction every drop travels. `auto`
///   (default) keeps them perpendicular to the run (the `up` side); set an
///   absolute angle (e.g. `-90deg` for straight down) to aim all drops
///   regardless of the run's `angle`. The station captions and current
///   labels stay anchored to the run — only the drops (and their load
///   captions) move.
/// - drop-draw (function | auto): what hangs at each tap. `auto` (default)
///   is the built-in transformer + load. Pass a closure `info => { … }` to
///   draw anything instead (per-station `draw` overrides it). `info` is a
///   dict `(name, at, foot, angle, drop, st)`: a unique base name, the tap
///   coordinate, the drop's end point, the drop direction (angle), the drop
///   length, and the station dict.
/// - up (bool): drop above the run instead of below (current labels and
///   the station caption flip sides to match). Ignored when `drop-angle`
///   is set explicitly.
/// - dot (float): tap-dot radius (`0` = no dot).
/// - label-gap (float): tap-to-station-caption distance.
/// - load-gap (float): gap from the load arrow's tip to its caption, so the
///   caption tracks `drop` / `load-size` and never collides with the arrow.
/// - tx (bool): draw a transformer in each drop (`false` = load only).
/// - tx-radius / tx-distance (float): drop transformer geometry.
/// - tx-stroke / tx-fill: default transformer styling for the feeder
///   (per-station `tx-stroke` / `tx-fill` override these).
/// - load-size / load-lead (float): drop load-arrow geometry.
/// - load-stroke / load-fill: default load-arrow styling for the feeder
///   (per-station `stroke` / `fill` override these).
/// -> content
#let feeder(
  name,
  start,
  stations,
  currents: (),
  lead: 1.7,
  spacing: 2.5,
  tail: auto,
  extend: 0.6,
  line-stroke: auto,
  extend-stroke: auto,
  angle: 0deg,
  drop: 0.95,
  drop-angle: auto,
  drop-draw: auto,
  up: false,
  dot: 0.06,
  label-gap: 0.5,
  load-gap: 0.35,
  tx: true,
  tx-radius: 0.2,
  tx-distance: 0.22,
  tx-stroke: 0.8pt + black,
  tx-fill: none,
  load-size: 0.26,
  load-lead: 0.12,
  load-stroke: 0.8pt + black,
  load-fill: black,
) = {
  let n = stations.len()
  let tail-len = if tail == auto { lead } else { tail }
  let total = lead + calc.max(n - 1, 0) * spacing + tail-len

  // Run direction `u` (the angle of attack) and the perpendicular drop
  // direction `ddv`. Everything is positioned along these two vectors, so
  // `angle` rotates the whole feeder while the labels stay upright.
  let u = (calc.cos(angle), calc.sin(angle))
  // The run's own perpendicular (the `up` side). Captions and current
  // labels are placed against this, so they keep their position relative to
  // the run no matter where `drop-angle` aims the drops.
  let run-perp = if up { angle + 90deg } else { angle - 90deg }
  // Direction the drops travel. `drop-angle: auto` keeps them perpendicular
  // to the run; otherwise every drop points at the given absolute angle.
  let drop-dir = if drop-angle == auto { run-perp } else { drop-angle }
  let rp = (calc.cos(run-perp), calc.sin(run-perp))
  let ddv = (calc.cos(drop-dir), calc.sin(drop-dir))
  let along(d) = (rel: (d * u.at(0), d * u.at(1)), to: start)
  let perp(p, o) = (rel: (o * ddv.at(0), o * ddv.at(1)), to: p) // along the drop
  let rperp(p, o) = (rel: (o * rp.at(0), o * rp.at(1)), to: p) // run's perpendicular

  // Built-in drop: a transformer (unless `tx: false`) + a load arrow, the LV
  // caption tracking the arrow tip. Used as the default `drop-draw`; it takes
  // the same `info` dict that custom drawers receive.
  let default-drop(info) = {
    let st = info.st
    let load-label = st.at("load", default: none)
    if load-label != none {
      let dn = info.name
      let ang = info.angle + 90deg // load arrow points along the drop
      let st-tx = st.at("tx", default: tx)
      let st-stroke = st.at("stroke", default: load-stroke)
      let st-fill = st.at("fill", default: load-fill)
      let st-tx-stroke = st.at("tx-stroke", default: tx-stroke)
      let st-tx-fill = st.at("tx-fill", default: tx-fill)
      if st-tx {
        // Tap → transformer → load.
        transformer(
          dn + "-t",
          info.at,
          info.foot,
          radius: tx-radius,
          distance: tx-distance,
          stroke: st-tx-stroke,
          fill: st-tx-fill,
        )
        load(
          dn + "-l",
          info.foot,
          lead: load-lead,
          size: load-size,
          angle: ang,
          stroke: st-stroke,
          fill: st-fill,
        )
      } else {
        // No transformer: the load hangs straight off the tap.
        load(
          dn + "-l",
          info.at,
          lead: info.drop,
          size: load-size,
          angle: ang,
          stroke: st-stroke,
          fill: st-fill,
        )
      }
      // Caption hangs off the arrow tip (the load's `south` anchor), so it
      // tracks `drop` / `load-size` / `angle` and never collides with it.
      cetz.draw.content(
        (
          rel: (load-gap * ddv.at(0), load-gap * ddv.at(1)),
          to: dn + "-l.south",
        ),
        align(center)[#load-label],
      )
    }
  }

  // Draw the drops FIRST, so the run line can be laid on top of their
  // connecting leads: each lead then meets the run at its edge instead of
  // crossing into it. Tap dots go on last, over the line. The drop itself is
  // pluggable — a per-station `draw`, else the feeder `drop-draw`, else the
  // built-in transformer + load above. Each drawer gets an `info` dict:
  // `(name, at, foot, angle, drop, st)`.
  for (i, st) in stations.enumerate() {
    let tap = along(lead + i * spacing)
    let label = st.at("label", default: none)
    if label != none {
      cetz.draw.content(rperp(tap, -label-gap), align(center)[#label])
    }
    let drawer = st.at("draw", default: if drop-draw == auto {
      default-drop
    } else { drop-draw })
    drawer((
      name: name + "-" + str(i),
      at: tap,
      foot: perp(tap, drop),
      angle: drop-dir,
      drop: drop,
      st: st,
    ))
  }

  // The run + optional dashed continuation, drawn over the drop leads so a
  // contrasting `line-stroke` reads cleanly. The dashed tail inherits the
  // run's exact stroke (thickness + paint) and only adds the dash, so the
  // two read as one line; pass `extend-stroke` to override it.
  cetz.draw.get-ctx(ctx => {
    let run-stroke = if line-stroke == auto {
      ctx
        .style
        .at("cetz-power", default: (:))
        .at("wire", default: (:))
        .at("stroke", default: 0.8pt + black)
    } else { line-stroke }
    cetz.draw.line(start, along(total), stroke: run-stroke)
    if extend > 0 {
      let tail-stroke = if extend-stroke == auto {
        let s = stroke(run-stroke)
        (paint: s.paint, thickness: s.thickness, dash: "dashed")
      } else { extend-stroke }
      cetz.draw.line(along(total), along(total + extend), stroke: tail-stroke)
    }
  })

  // Tap dots, on top of the run line.
  if dot > 0 {
    for i in range(n) {
      cetz.draw.circle(along(lead + i * spacing), radius: dot, fill: black)
    }
  }

  // Per-segment current labels, on the run's perpendicular (opposite the
  // default drop side), independent of `drop-angle`.
  let side = _compass-of((-rp.at(0), -rp.at(1)))
  for (i, c) in currents.enumerate() {
    if c != none {
      let mx = if i == 0 {
        lead / 2
      } else if i < n {
        lead + (i - 0.5) * spacing
      } else {
        lead + calc.max(n - 1, 0) * spacing + tail-len / 2
      }
      note(along(mx), c, side: side)
    }
  }
}
