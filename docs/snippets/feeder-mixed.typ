#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

// Per-station `draw` puts a different thing at each tap of one run: a
// distribution transformer + load, a motor, and a shunt capacitor.
#diagram(length: 1.2cm, {
  feeder("f", (0, 0),
    (
      (label: [feeder], load: [10 A \ 230 V]),
      (label: [motor], draw: info => {
        machine(info.name, info.foot, "M")
        wire(info.at, info.name + ".north")
      }),
      (label: [cap], draw: info => {
        // capacitor is one-node: hang it off the tap, flipped to point down
        capacitor(info.name, info.at, angle: 180deg, lead-out: 0, lead-in: 0.6)
      }),
    ),
    spacing: 2.6, extend: 0)
})
