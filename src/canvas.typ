#import "deps.typ": cetz
#import "styles.typ": default

/// User-facing canvas wrapper.
///
/// Equivalent to `cetz.canvas(...)` but installs the `cetz-power` default
/// style dictionary first, so every symbol can resolve its defaults.
///
/// ```typst
/// #import "@preview/cetz-power:0.1.0": *
/// #diagram({
///   bus("b1", (0, 0))
///   load("ld", "b1.mid")
/// })
/// ```
///
/// - body (content): drawing contents
/// -> content
#let diagram(body, ..params) = {
  let canvas = cetz.canvas(..params, {
    cetz.draw.set-ctx(ctx => {
      ctx.style.insert("cetz-power", default)
      ctx
    })
    body
  })
  // When compiling docs to HTML (`typst compile --features html --input html=true`),
  // wrap the canvas in `html.frame` so it gets rendered as inline SVG. CeTZ
  // canvases otherwise produce nothing in HTML mode because Typst's `layout()`
  // primitive — which CeTZ uses to size itself — is ignored.
  // The `html` module isn't in scope under PDF compilation, but the dead-branch
  // here is never evaluated unless the input flag is set, so PDF builds (used
  // by `tests/run.sh`) keep working.
  if sys.inputs.at("html", default: none) == "true" {
    html.frame(canvas)
  } else {
    canvas
  }
}
