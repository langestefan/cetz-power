// Docs-only helpers.
//
// `demo(...)` is a thin wrapper around `pg.diagram` that fixes a bigger
// per-unit length than CeTZ's default so diagrams are readable on an A4
// page. Using a wrapper keeps individual doc pages focused on their
// examples instead of repeating `length: 1.2cm` everywhere.

#import "/src/lib.typ" as pg

/// Wrap a diagram with a docs-appropriate scale (1.2cm per CeTZ unit).
#let demo(body, ..params) = {
  align(center, pg.diagram(length: 1.2cm, ..params, body))
}

/// Re-export pg so doc pages need a single import.
#let pg = pg
