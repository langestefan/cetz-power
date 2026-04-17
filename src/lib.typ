// cetz-power — a Typst package for drawing power-system single-line diagrams.
//
// A thin wrapper around CeTZ. Current scope is intentionally minimal:
// buses, wires, the external-grid symbol, two-winding transformers, and
// the generic load arrow.
//
//     #import "@preview/cetz-power:0.1.0" as pg
//     #pg.diagram({
//       import pg: *
//       bus("b1", (0, 0), length: 1.4, angle: 90deg, label: [1])
//       external-grid("g", (-1, 0), angle: 90deg)
//       wire("g.in", "b1.mid")
//       load("ld", bus-frac("b1", 1/6), elbow: 0.4)
//     })

// External dependency (re-exported so users can reach CeTZ if they need to).
#import "deps.typ": cetz

// Canvas wrapper — use this instead of cetz.canvas().
#import "canvas.typ": diagram

// Core building block, exposed so users can define their own symbols.
#import "core.typ": symbol

// Default style dictionary — inspect or extend with `set-style(cetz-power: ...)`.
#import "styles.typ": default as default-styles

// ── Symbols ──────────────────────────────────────────────────────────────

#import "symbols/bus.typ": bus, bus-frac
#import "symbols/wire.typ": wire, elbow
#import "symbols/grid.typ": external-grid
#import "symbols/transformer.typ": transformer
#import "symbols/load.typ": load
#import "symbols/pv.typ": pv-panel
