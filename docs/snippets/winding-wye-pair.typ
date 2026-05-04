#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Yy0 vs Yy6 — a primary–secondary pair, in phase and 180° out.
#diagram(length: 1.2cm, {
  wye("p1", (0, 0), label: [Yy0])
  wye("s1", (1.6, 0), terminals: ("u", "v", "w"))

  wye("p2", (4, 0), label: [Yy6])
  wye("s2", (5.6, 0), terminals: ("u", "v", "w"), angle: 180deg)
})
