// Tiny harness used by every `tests/*/test.typ` file.
//
// Pattern: each call to `test(body)` generates one diagram on its own page.
// The SVG renderer we use produces one SVG per page; the `tests/run.sh`
// script renders each file to SVG and can diff against a `ref/` folder.

#import "/src/lib.typ": *

#let test(body) = {
  set page(margin: 4pt, width: auto, height: auto)
  pagebreak(weak: true)
  diagram(body)
}
