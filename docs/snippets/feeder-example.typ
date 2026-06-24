#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

#diagram(length: 1.1cm, {
  feeder("f", (0, 0),
    (
      (label: [N1 \ 10,4 kV], load: [10 A \ 230 V]),
      (label: [N2 \ 10,4 kV], load: [10 A \ 230 V]),
      (label: [N3 \ 10,4 kV], load: [10 A \ 230 V]),
    ),
    currents: ([56 A], [47 A], [38 A], [28 A]))
})
