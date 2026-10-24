# CA1 independent review (22 October 2026)

A separate agent read `Founding.lean` and the landing text (`apply_text.py`, `study_ca1.txt`, `make_record.py`) read-only.
Seven must-fix findings, all applied before landing:

1. `ConfinedRise.selected` was about the whole generation, not the lineage: the rise now requires an amount that marks
   the lineage (positive exactly at its members) at the selected step (`Flow.Rise.selected`).
2. "Only confinement separates the two" was asserted, not proved: `Flow.Rise` split from `Flow.ConfinedRise`, and
   `Body.spread_rise` proves the spreading lineage meets every clause of a rise; text says "among what the base leaves free".
3. "Goes on" overclaimed one generation: renamed `Body.spread_outlasts`, text says it still has a member a generation
   after the body's parts end.
4. "Falls to none" was not proved: `Germline.unsequestered_falls` and `sequestered_rises` now state the sums.
5. The OPENING note omitted exact transmission for `rises_iff_lineages`: added.
6. Readings lacked the AI label in the OPENING note: added ("read (the AI's reading)").
7. "What keeps a part from turning back" overclaimed: narrowed to two ways; removal of parts by the whole is named as
   not stated.

Optional findings taken: `Sequestered` described as an outcome; `raises_iff_carried` glossed as the transmission term
(Price 1970, 1972); "moves" replaced by "rises exactly where"; `Germline.foundings` "by construction"; crediting of the
bottleneck (Grosberg and Strathmann 1998) and transmissible cancers (Metzger et al. 2015); "reduces" for what a germ
line does; Chinese "下一批奠基者携带原奠基者之值"; "policing"/"监管" replaced by removal of parts by the whole's rule;
"drawing past renewal" replaced by drawing while uptake exceeds renewal.
