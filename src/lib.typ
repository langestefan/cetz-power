// cetz-power — a Typst package for drawing power-system single-line diagrams.
//
// A thin wrapper around CeTZ. Current scope is intentionally minimal:
// buses, wires, the external-grid symbol, two-winding transformers, and
// the generic load arrow.
//
//     #import "@preview/cetz-power:0.1.0": *
//     #diagram({
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
//
// Organised into four families that mirror the docs sidebar and the
// `src/symbols/<family>/` directory layout:
//
//   * grid        — network infrastructure (buses, wires, grids, transformers)
//   * generation  — sources (machines like V/G/M/A, PV panels)
//   * loads       — energy consumers (the generic load arrow)
//   * electrical  — passive components (capacitors, …)

// Grid
#import "symbols/grid/bus.typ": bus, bus-frac
#import "symbols/grid/wire.typ": wire, elbow
#import "symbols/grid/external-grid.typ": external-grid
#import "symbols/grid/transformer.typ": transformer

// Generation
#import "symbols/generation/machine.typ": machine
#import "symbols/generation/pv-panel.typ": pv-panel

// Loads
#import "symbols/loads/load.typ": load

// Electrical components (passive + sources + ground)
#import "symbols/electrical/capacitor.typ": capacitor
#import "symbols/electrical/resistor.typ": resistor
#import "symbols/electrical/inductor.typ": inductor
#import "symbols/electrical/diode.typ": diode
#import "symbols/electrical/voltagesource.typ": voltagesource
#import "symbols/electrical/currentsource.typ": currentsource
#import "symbols/electrical/ground.typ": ground

// Protection & switching
#import "symbols/protection/switch.typ": switch
#import "symbols/protection/breaker.typ": breaker
#import "symbols/protection/fuse.typ": fuse

// ── Composition helpers ─────────────────────────────────────────────────

#import "helpers.typ": multi-wire
