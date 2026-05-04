#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Override `terminals:` to lowercase for the secondary side.
#diagram(length: 1.2cm, {
  wye("p", (0, 0))
  wye("s", (2, 0), terminals: ("u", "v", "w"))
})
