// Exercises one variant of every symbol family. If anything's syntactically
// broken this will catch it — used during development to sanity-check.

#import "/src/lib.typ": *

#set page(margin: 10pt, width: auto, height: auto)

= Generators

#diagram({
  ac-generator("g1", (0, 0))
  dc-generator("g2", (1.5, 0))
  sync-generator("g3", (3, 0))
  async-generator("g4", (4.5, 0))
  motor("m1", (6, 0))
})

= Transformers

#diagram({
  transformer("t1", (0, 0), (1.5, 0))
  three-winding-transformer("t2", (3.2, 0))
  autotransformer("t3", (5, 0), (6.5, 0))
})

= Breakers, disconnectors, switches

#diagram({
  circuit-breaker("cb1", (0, 0), (1.5, 0))
  circuit-breaker("cb2", (2, 0), (3.5, 0), closed: true)
  disconnector("d1", (4, 0), (5.5, 0))
  load-break-switch("lbs1", (6, 0), (7.5, 0))
  fuse("f1", (8, 0), (9.5, 0))
  earth-switch("es1", (10.5, 0))
})

= Loads, grid, renewables

#diagram({
  load("l1", (0, 0))
  resistive-load("l2", (1.5, 0))
  external-grid("grid1", (3, 0))
  wind-turbine("w1", (4.5, 0))
  wind-generator("wg1", (6, 0))
  solar-plant("s1", (8, 0))
  solar-cell("sc1", (9.5, 0))
})

= Storage, converters, measurement

#diagram({
  battery("b1", (0, 0))
  bess("bess1", (1.5, 0))
  rectifier("r1", (3.5, 0), (5, 0))
  inverter("inv1", (5.5, 0), (7, 0))
  dc-dc-converter("dc1", (7.5, 0), (9, 0))
  current-transformer("ct1", (9.5, 0), (11, 0))
  potential-transformer("pt1", (11.5, 0))
  relay("r2", (12.5, 0), code: "50")
})

= Phase ticks on a wire

#diagram({
  bus("b1", (0, 0), taps: 2)
  bus("b2", (5, 0), taps: 2)
  wire("b1.tap2", "b2.tap1")
  phase-ticks("b1.tap2", "b2.tap1")
})
