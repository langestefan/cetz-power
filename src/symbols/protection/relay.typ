// Protection relay — the function box of a protection scheme, carrying
// the ANSI device number or IEC function code ("50/51", "87T", "21",
// "U<", …). Drawn as a rectangle (IEC style, default) or a circle
// (ANSI style). Wire its input from a CT/VT secondary and its trip
// command to a breaker with a dashed arrow (`flow-arrow`).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Protection relay (function box).
///
/// Positional: `relay(name, pos)` or `relay(name, pos, code)`. A named
/// `code:` argument (if given) takes precedence. The code stays
/// upright under rotation.
///
/// Anchors: `center`, edge midpoints (`north`, `south`, `east`,
/// `west`) plus the four corners (box kind) or the 45° circle points
/// (circle kind) — all safe as wire endpoints for measurement inputs
/// and trip outputs.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): where to place the symbol.
/// - code (str | content | none): function code drawn inside —
///   `"50/51"`, `[87T]`, `[U<]`, ….
/// - kind (str): `"box"` (IEC rectangle, default) or `"circle"`
///   (ANSI device circle).
/// - width, height (float): box dimensions (box kind).
/// - radius (float): circle radius (circle kind).
/// - stroke: outline stroke.
/// - fill: body fill.
/// - code-size (length): font size for string codes.
/// - label: external label (standard label dict).
/// - angle (angle): rotation.
/// -> content
#let relay(name, ..args) = {
  let raw = args.pos()
  let overrides = args.named()

  assert(
    raw.len() in (1, 2),
    message: "relay() takes 1 position and an optional code, got "
      + str(raw.len())
      + " positional args",
  )
  let positions = (raw.at(0),)
  let code = if raw.len() == 2 { raw.at(1) } else { none }
  if "code" in overrides {
    code = overrides.at("code")
    let _ = overrides.remove("code")
  }

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let kind = style.at("kind", default: "box")
    assert(
      kind in ("box", "circle"),
      message: "relay kind must be \"box\" or \"circle\", got " + repr(kind),
    )

    if kind == "circle" {
      let r = style.at("radius", default: 0.24)
      cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)
      cetz.draw.anchor("north", (0, r))
      cetz.draw.anchor("south", (0, -r))
      cetz.draw.anchor("east", (r, 0))
      cetz.draw.anchor("west", (-r, 0))
      let corner = r / calc.sqrt(2)
      cetz.draw.anchor("north-east", (corner, corner))
      cetz.draw.anchor("south-east", (corner, -corner))
      cetz.draw.anchor("south-west", (-corner, -corner))
      cetz.draw.anchor("north-west", (-corner, corner))
    } else {
      let hw = style.at("width", default: 0.52) / 2
      let hh = style.at("height", default: 0.36) / 2
      cetz.draw.rect((-hw, -hh), (hw, hh), stroke: s, fill: f)
      cetz.draw.anchor("north", (0, hh))
      cetz.draw.anchor("south", (0, -hh))
      cetz.draw.anchor("east", (hw, 0))
      cetz.draw.anchor("west", (-hw, 0))
      cetz.draw.anchor("north-east", (hw, hh))
      cetz.draw.anchor("north-west", (-hw, hh))
      cetz.draw.anchor("south-east", (hw, -hh))
      cetz.draw.anchor("south-west", (-hw, -hh))
    }

    // cetz `content` text does not inherit the group rotation, so the
    // code stays upright under any orientation without help.
    if code != none {
      cetz.draw.content(
        (0, 0),
        text(size: style.at("code-size", default: 7pt), code),
      )
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("center", (0, 0))
  }

  symbol("relay", name, ..positions, ..overrides, draw: draw)
}
