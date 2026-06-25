#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Open is the default; pass closed: true for the closed pose. Both
  // forms keep the same `in`/`out` anchors so wiring around them
  // doesn't need to change when the state flips.
  switch("s-open",   (0,  0),    (2,  0))
  switch("s-closed", (0, -1),    (2, -1), closed: true)
})
