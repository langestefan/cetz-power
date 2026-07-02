#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// A ring operated open: the hollow junction is the netopening. It is
// drawn AFTER the ring conductor, so its body masks the line and the
// ring reads as split at that point.
#diagram(length: 1.2cm, {
  wire((0, 0), (3, 0), (3, -1.2), (0, -1.2), (0, 0))
  junction("j1", (1, 0)); junction("j2", (2, 0))
  junction("j3", (1, -1.2)); junction("j4", (2, -1.2))
  junction("no", (3, -0.6), open: true, label: (content: [netopening], anchor: "east"))
})
