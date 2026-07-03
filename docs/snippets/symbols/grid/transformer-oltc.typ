#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // On-load tap changer: `oltc: true` draws the thin diagonal arrow
  // through both circles. It scales with radius / distance and
  // rotates with the placement.
  transformer("t1", (0, 0), (2, 0), oltc: true)
  transformer("t2", (3.2, -0.9), (3.2, 0.9), radius: 0.3, oltc: true)
})
