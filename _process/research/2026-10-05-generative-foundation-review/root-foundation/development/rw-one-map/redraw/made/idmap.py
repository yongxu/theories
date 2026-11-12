# AI-written, 12 November 2026. Reader place ids (round 1 pilot and the 14 family reports) -> the sheet's condition ids.
PILOT = {
 'fixed-rule':'b1.outside','several-ways':'d3.several','all-on-one':'d3.one','shaping-costs':'bs.costs','shaping-pays':'bs.pays',
 'holds-itself':'b1.held','uncounted':'b2.uncounted','judged-inside':'b3.inside','noticers-gone':'b3.gone','felt':'b2.felt',
 'cost-counts':'b2.counted','past-turning-back':'a1.past','ended':'a2.ended','checkers-inside':'b3.checkers','outlives-members':'d2.handed',
 'heard-and-held':'b2.heard',
}
FAMILY = {
 'A-process': {'within-what-returns':'a1.within','faster-than-returns':'a1.over','short':'a2.short','given-back':'a2.supplied','on-something-else':'a2.else','comes-round':'e2.round'},
 'A-sentences': {'within-renewal':'a1.within','past-renewal':'a1.over','short':'a2.short','elsewhere':'a2.else','held-by-another':'d0.line','can-return':'e2.round'},
 'B-process': {'within-what-comes-in':'a1.within','more-than-comes-in':'a1.over','coming-back':'a1.up','left-is-lost':'b0.lost','left-comes-back':'b0.pays'},
 'B-sentences': {'within-renewal':'a1.within','overdrawing':'a1.over','together-over':'b0.together','leaving-lost':'b0.lost','leaving-pays':'b0.pays','growing-back':'a1.up'},
 'D-process': {'looks-same':'c1.same','known-road':'c1.road','ruling-out':'c1.open','checked':'c1.checked','old-look':'c1.old','no-means':'c1.nomeans','at-rest':'e2.rest','no-rest':'e2.norest'},
 'D-sentences': {'looks-the-same':'c1.same','only-where-it-went':'c1.road','behind-the-change':'c1.old','at-rest':'e2.rest','nowhere-to-rest':'e2.norest','past-renewal':'a1.over','within-renewal':'a1.within'},
 'E-process': {'each-keeps-other-going':'d1.round','waiting-on-each-other':'d1.wait','one-link-out':'d1.gap','cannot-rise-alone':'a1.past'},
 'E-sentences': {'giving-goes-round':'d1.round','each-waits':'d1.wait','gives-first':'d1.first','comes-round-again':'e2.round','too-low-alone':'a1.past'},
 'F-process': {'swinging':'e2.swing','coming-round':'e2.round','made-good':'e2.good','at-rest':'e2.rest','nothing-comes-back':'e1.line','results-come-back':'e1.ring'},
 'F-sentences': {'at-rest':'e2.rest','swinging':'e2.swing','coming-round':'e2.round','one-way':'a1.over','growing-on-itself':'e2.grow','in-a-ring':'e1.ring','in-a-line':'e1.line'},
 'G-process': {'at-rest':'e2.rest','running-down':'a1.over','going-round':'e2.round','coming-in-and-going-out':'a1.within','piling-up':'a1.up','more-possible':'a1.new','told-as-one':'d3.merged'},
 'G-sentences': {'at-rest':'e2.rest','running-down':'a1.over','kept-up':'a1.within','building-up':'a1.up','always-new':'a1.new','going-round':'e2.round','told-as-one':'d3.merged'},
 'H-process': {'within-what-comes-back':'a1.within','faster-than-it-comes-back':'a1.over','short-of-need':'a2.short','made-good-again':'a2.supplied','kept-within-bounds':'e2.good','swinging-past-the-mark':'e2.swing','each-depends-on-the-others':'d0.ring'},
 'H-sentences': {'within-renewal':'a1.within','drawing-down':'a1.over','coming-back':'a1.up','within-bounds':'e2.good','swinging':'e2.swing','stalled':'d2.stalled','tied-together':'d0.ring','becomes-other':'a2.else'},
}
