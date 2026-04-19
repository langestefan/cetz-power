// Rotating-machine / source / meter — a stroked circle with an optional
// character inside. Single-line convention: circled V = voltage source,
// A = asynchronous machine, G = generator, M = motor, W = wattmeter, etc.
// The letter is just content, so you can pass anything ($\Phi$, "DG", …).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Machine symbol (circle with optional inner content).
///
/// Positional: `machine(name, pos)` or `machine(name, pos, letter)`.
/// A named `letter:` argument (if given) takes precedence.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): where to place the symbol.
/// - letter (str | content | none): content drawn inside the circle —
///   a string like `"V"`, math content like `[$Phi$]`, or any content.
/// - radius (float): circle radius (style override).
/// - stroke: stroke override.
/// - fill: fill override (default none).
/// - letter-size (length): font size for string letters.
/// - label: external label (standard label dict).
/// - angle (angle): rotation.
/// -> content
#let machine(name, ..args) = {
  let raw = args.pos()
  let overrides = args.named()

  // Positional form: `machine(name, pos, letter?)`. The coordinate
  // comes first; an optional letter/content can follow. A named
  // `letter:` arg (if given) wins over the positional form.
  assert(
    raw.len() in (1, 2),
    message: "machine() takes 1 position and an optional letter, got "
      + str(raw.len()) + " positional args",
  )
  let positions = (raw.at(0),)
  let letter = if raw.len() == 2 { raw.at(1) } else { none }
  if "letter" in overrides {
    letter = overrides.at("letter")
    let _ = overrides.remove("letter")
  }

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.3)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let lsize = style.at("letter-size", default: 10pt)

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)
    if letter != none {
      let inner = if type(letter) == str { text(size: lsize, letter) } else { letter }
      cetz.draw.content((0, 0), inner)
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("machine", name, ..positions, ..overrides, draw: draw)
}
