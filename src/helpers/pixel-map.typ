// Pixel-space coordinate mapping for replicating published figures.

/// Build the pixel→canvas mapping function used when digitising a
/// reference image: `let P = pixel-map(0.01, height: 1200)` returns a
/// closure `P(x, y) = (x·scale, (height − y)·scale)` that converts
/// image-pixel coordinates (origin top-left, y growing downward) to
/// canvas coordinates (y growing upward). Every figure-replication
/// recipe uses this instead of re-declaring the closure by hand;
/// `scale` doubles as the compression knob (design rule 13).
///
/// - scale (float): canvas units per image pixel.
/// - height (float): image height in pixels; `0` (default) keeps y
///   growing downward-negative (pure mirror), any other value flips
///   around the image's bottom edge.
/// -> function
#let pixel-map(scale, height: 0) = {
  (x, y) => (x * scale, (height - y) * scale)
}
