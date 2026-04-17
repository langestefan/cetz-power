# powergretz

**Power-system single-line diagrams in Typst, on top of [CeTZ](https://github.com/cetz-package/cetz).**

A small package that gives you the symbols you actually need for drawing one-line diagrams of electrical power systems — transformers, buses, generators, breakers, renewables, storage, converters, measurement.

## Quick example

```typst
#import "@preview/powergretz:0.1.0" as pg

#pg.diagram({
  import pg: *

  // A horizontal bus with 5 tap points
  bus("b1", (0, 0), length: 5, taps: 5)

  // External grid feeding into tap 1
  external-grid("grid", "b1.tap1", angle: 90deg)

  // A 2-winding transformer in the middle
  transformer("t1", "b1.tap3", (3, -2))

  // A load at the bottom of the transformer's secondary
  load("l1", (3, -2))
})
```

## Installation

Via Typst Universe (recommended once published):

```typst
#import "@preview/powergretz:0.1.0" as pg
```

Or vendor locally by cloning the repo and importing from path:

```typst
#import "path/to/powergretz/src/lib.typ" as pg
```

## What's in the box

| Family       | Symbols                                                       |
|--------------|---------------------------------------------------------------|
| Buses        | `bus` (with taps), `bus-frac` (fractional attach points)      |
| Wires        | `wire`, `elbow` (L-shaped corner routing)                     |
| Grid         | `external-grid` (cross-hatched square)                        |
| Transformers | `transformer` (two-winding, overlapping circles)              |
| Loads        | `load` (filled downward arrow, optional `elbow:`)             |

The library is intentionally minimal — extra symbols can be added by
copying the pattern in `src/symbols/<family>.typ`. See `docs/` for
per-symbol reference pages with examples, anchors, and style options.

## Design

- **Symbols have anchors.** Every symbol exposes named anchors (`north`, `south`, `center`, etc.); buses expose `tap1..tapN` plus `start`, `mid`, `end`.
- **One- or two-node placement.** The `transformer` accepts either a single position + `angle:` or two positions; when given two positions it orients itself along the line and draws its own leads.
- **Cascading styles.** A global `set-style(powergretz: (...))` changes defaults; per-family overrides live under e.g. `powergretz.transformer`; per-call arguments override both.
- **Labels everywhere.** Every symbol accepts `label:` as a string, content, or `(content:, anchor:, distance:)` dict.

## Running the tests

```bash
tests/run.sh
```

Compiles every test file into `tests/<name>/out/*.svg` and (if reference images exist in `ref/`) does a rough diff.

## Building the docs

The docs are an [Astro Starlight](https://starlight.astro.build) site under `docs-site/`. Prose is MDX, Typst diagrams are standalone snippets under `docs-site/snippets/` that get pre-compiled to SVG and embedded via a small `<Snippet>` component.

```bash
cd docs-site
npm ci
npm run dev      # live preview at http://localhost:4321/powergretz/
npm run build    # static site → docs-site/dist/
```

The deployed docs are built and pushed to GitHub Pages on every push to `main` by `.github/workflows/docs.yml`.

## License

MIT. See `LICENSE`.
