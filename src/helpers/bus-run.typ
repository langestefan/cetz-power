// A feeder run with node buses along it: a straight spine whose
// stations sit at length-proportional distances, each a real (named)
// bus tick crossing the spine, with per-segment length labels and an
// optional device hanging off every station.
//
// This is the "line with a number of buses along it" of benchmark
// network figures (CIGRE, urban LV grids): the caller supplies a data
// table and the geometry follows from it.

#import "/src/deps.typ": cetz
#import "/src/layout.typ": compass-of-angle, upright as _upright
#import "/src/symbols/grid/bus.typ": bus
#import "/src/symbols/grid/wire.typ": wire
#import "note.typ": note

/// Draw a run of node buses: spine, labelled segments, devices, ticks.
///
/// Stations are placed along the spine at `length · pitch` from their
/// predecessor (or `lead` when `length` is missing — the short hop off
/// a riser corner). Every station is a real `bus` named
/// `<name>-<station name>`, so downstream code can attach branches and
/// ties by anchor (`"a-5.mid"`) instead of coordinates.
///
/// Draw order per run: spine and labels, then devices, then the bus
/// ticks — so the bars paint over the device lead roots.
///
/// - name (str): base name; station `s` becomes bus `<name>-<s>`.
/// - start (coordinate): where the spine begins (any CeTZ coordinate).
/// - stations (array): one dict per station. Recognised keys:
///     - `name` (str): required — bus name suffix and default caption.
///     - `length` (number | none): cable length of the segment INTO
///       this station; `none`/absent uses `lead` and gets no label.
///     - `device` (function | none): per-station override of the
///       run-level `device` drawer.
///     - `caption` (content | auto | none): text beside the tick;
///       `auto` prints the station name, `none` omits it.
///     - `label` (content | auto | none): segment label; `auto` formats
///       the length via `label-format`, `none` omits it.
///     - `side` (str): per-segment label side (e.g. flip one label
///       `"south"` to dodge a crossing branch).
/// - pitch (float): spine distance per unit of `length`.
/// - lead (float): station distance when `length` is `none`.
/// - bus-length (float): tick length, centred on the spine.
/// - angle (angle): spine direction (`0deg` = right); ticks sit
///   perpendicular and all text stays upright.
/// - tail (float): bare spine drawn past the last station (`0` = none).
/// - label-side (str | auto): default side for segment labels; `auto`
///   picks the perpendicular ("north" on a horizontal run).
/// - caption-side (str | auto): side for station captions; `auto`
///   follows `label-side`.
/// - label-format (function | auto): `length => content`; `auto` gives
///   `[#length m]`.
/// - label-size / caption-size (length): text sizes.
/// - label-gap / caption-gap (float): note distances.
/// - device (function | none): default drawer hung off every station.
///   Called with a dict `(name, at, angle, station)`: a unique base
///   name, the station's spine coordinate, the run angle, and the
///   station dict. Draw anything relative to `at` (a load, PV panel,
///   sub-feeder, …).
/// -> content
#let bus-run(
  name,
  start,
  stations,
  pitch: 0.05,
  lead: 0.45,
  bus-length: 1,
  angle: 0deg,
  tail: 0,
  label-side: auto,
  caption-side: auto,
  label-format: auto,
  label-size: 5.5pt,
  caption-size: 8pt,
  label-gap: 0.05,
  caption-gap: 0.08,
  device: none,
) = {
  let (ux, uy) = (calc.cos(angle), calc.sin(angle))
  let (px, py) = (-uy, ux) // perpendicular (the "up" side of the run)
  // point at distance d along the spine, offset o to the side
  let P(d, o) = (rel: (d * ux + o * px, d * uy + o * py), to: start)

  let fmt = if label-format == auto { l => [#l m] } else { label-format }
  let lside = if label-side == auto {
    // compass of the perpendicular: "north" on a horizontal run
    compass-of-angle(angle + 90deg)
  } else { label-side }
  let cside = if caption-side == auto { lside } else { caption-side }

  // resolve station distances from the length data
  let placed = ()
  let d = 0
  for st in stations {
    let len = st.at("length", default: none)
    d += if len == none { lead } else { len * pitch }
    placed.push((d: d, len: len, st: st))
  }

  // 1. spine hops with their segment labels
  let prev = 0
  for e in placed {
    wire(P(prev, 0), P(e.d, 0))
    let lbl = e.st.at("label", default: auto)
    if lbl == auto { lbl = if e.len == none { none } else { fmt(e.len) } }
    if lbl != none {
      let side = e.st.at("side", default: lside)
      note(
        (P(prev, 0), 50%, P(e.d, 0)),
        _upright(lbl, side),
        side: side,
        distance: label-gap,
        size: label-size,
      )
    }
    prev = e.d
  }
  if tail > 0 { wire(P(prev, 0), P(prev + tail, 0)) }

  // 2. devices (before the ticks: bars paint over the lead roots)
  for e in placed {
    let dev = e.st.at("device", default: device)
    if dev != none {
      dev((
        name: name + "-" + e.st.name + "-dev",
        at: P(e.d, 0),
        angle: angle,
        station: e.st,
      ))
    }
  }

  // 3. the node buses and their captions
  for e in placed {
    bus(name + "-" + e.st.name, P(e.d, -bus-length / 2), P(e.d, bus-length / 2))
    let cap = e.st.at("caption", default: auto)
    if cap == auto { cap = e.st.name }
    if cap != none {
      note(
        P(e.d, bus-length / 2),
        cap,
        side: cside,
        distance: caption-gap,
        size: caption-size,
      )
    }
  }
}
