#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Yz5 — wye primary, zigzag secondary at clock 5 (-150°).
#diagram(length: 1.2cm, {
  wye("p", (0, 0))
  zigzag("s", (2, 0), terminals: ("u", "v", "w"), angle: -150deg)
})
