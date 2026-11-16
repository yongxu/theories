AI-written, 16 November 2026. A reader (Fable) swept every registering text of this landing against the theorem statements, after the "together" repairs and the five new premise rows (branch at 220c36f09, clean tree). It read Becoming.lean's four bullets, README.md and README.zh.md's four rows, check_becoming.py's SCOPE, the records a-line-on-a-stock (all fields), turning-in-time and a-way-of-units (the fields this branch changed), the atlas entry a-line-on-a-stock with its premises and the five new rows of six/mapping.json, and the map card, clause by clause beside LineOnAStock.lean, LineOnAStockCases.lean and the statements of TurningInTime.lean and WayOfUnits.lean that the texts name. It built, rendered and edited nothing. Its countermodels below are computed by hand on min z (12 − z); none is in Lean. Its findings are kept as it gave them, each followed by what was done with it (AI-written, by the agent that applied them, before the third core run). The four Lean modules did not change.

## Must fix

**MF1.** a-line-on-a-stock.json, statement.en and statement.zh. English: "... if kids take more, a need is unmet within hi + 1 steps, the level below a start need if they need no more; if the same, under the regime, the net never ends exactly where its course holds." Chinese: "所取相等时，在沿途体制前提下，网永不终止当且仅当进程走到守得住处。" unending_iff_holds asks `(even : ∀ u, taken use (kids u) = use u) (some : ∀ u, kids u ≠ []) (down : ∀ u v, v ∈ kids u → need v ≤ need u)`, `Needing`, `FromNothing`, `x ≤ hi` and the regime along the course. (1) English only: "if [kids take] the same" read of each kid fails on Doubling (a unit taking one and leaving two of itself) from ([()], 12): the regime holds at the ways of 1, 2, 4, 8, 16 units, ([()], 12) holds, and the net ends at step 5. (2) Both languages: down and "every unit has kids" are missing from the middle case ("if they need no more" / "后代所需不多于亲代，则" belongs to the clause before); a unit A (needs 1, takes 1) leaving B (needs 100, takes 1, leaves B), from ([A], 12), holds at the start, the regime holds at [A], and the net ends at step 1. Proposed: en "A way reads the level only by needs met. Capped at hi, nothing from nothing, positive needs met at first, each unit with kids, none needing more: if they together take more, the level is below a start need by step hi + 1; if the same, under the regime, the net never ends just where its course holds." (it gives up the clause without down, "a need is unmet within hi + 1 steps", which the claim still says); zh "方式只凭哪些所需被满足来读取水位。水位以 hi 为上限、无中不生有、所需皆为正、起点皆满足、每个单元都有后代且后代所需不多于它时：其后代合起来所取更多，则 hi + 1 步内水位低于起点满足过的某个所需，此前只是传承的世代；合起来所取相等，则在沿途体制前提下，网永不终止当且仅当进程走到守得住处。"

*Applied*, as proposed, after reading falls_to_unmet and unending_iff_holds in LineOnAStock.lean: the first case is falls_to_unmet (its `grows` already implies every unit has kids, so the shared premise asks nothing more of it), the second is unending_iff_holds with all its premises on kids named. The English is 300 characters, at the hard cap of 300 (the reader counted 299); the Chinese 148 of 150.

**MF2.** a-line-on-a-stock.json, hypotheses[4].en: "Kids that take more: each unit's kids together take more than it (grows), asked of every unit for need_unmet, falls_to_unmet, way_ends and one_need_ends, of every unit of a closed line for line_ends. For fall: kids together taking no less, ..." line_ends asks `(grows : ∀ u, S u → use u < lineTake S use (kids u))` and fall `(keeps : ∀ u, S u → use u ≤ lineTake S use (kids u))`; `lineTake S` counts only the kids of the line. Read as worded (all kids together), both laws fail: for line_ends, D (needs 1, takes 1) leaving D and O, O (needs 1, takes 5) leaving nothing, line {D}, from ([D], 12): D's kids together take 6, the course is ([D, O], 12) from step 1 on, and D never goes; for fall, D (takes 7) leaving E and O, E (takes 1) leaving E, O (takes 6) leaving nothing, all needing 1, line {D, E}, from ([D], 12): the course comes to ([E], 12) and stays. Proposed: "Each unit's kids together take more than it (grows): asked of every unit for need_unmet, falls_to_unmet, way_ends and one_need_ends; for line_ends, each unit of a closed line has kids of the line that together take more than it. For fall: a closed line of one need m, each unit with kids of the line that together take no less than it, giving 0 below m, and the line taking at the start more than every giving."

*Applied*, as proposed (410 characters, within the item cap of 420); the binders of line_ends and fall were read in LineOnAStock.lean.

**MF3.** dynamics.json, a-line-on-a-stock, mechanism.en: "Where each unit's kids together take exactly what it takes, under the regime along the course, the net never ends exactly where its course comes to a configuration that holds;". Read as the two sentences before it are read, each naming its own premises, the A-and-B model of MF1 meets what is named and the net ends from a start that holds; "every unit has kids" is nowhere in the mechanism. Proposed: "Where each unit's kids together take exactly what it takes, every unit has kids and kids need no more than their parent, with nothing given from nothing, every descendant needing something and the start at most hi, under the regime along the course, the net never ends exactly where its course comes to a configuration that holds;"

*Applied*, as proposed.

## Says less

**SL1.** Becoming.lean (LineOnAStock bullet), README.md row, check_becoming.py SCOPE, cards.json plain_en, line_ends: "has kids that each need no more than it" can be read as "has some kids that ..."; read so, KidsNeedMore refutes it. Proposed: "has no kid that needs more than it". The Chinese rows are already exact.

*Applied* in all four.

**SL2.** dynamics.json mechanism.en, last sentence: "that kids take more or the same and need no more". Proposed: "that each unit's kids together take more or the same and each need no more".

*Applied*.

**SL3.** cards.json plain_en and plain_zh, last sentence. Proposed: en "that each unit's kids together take more or the same and each need no more"; zh "所需、用量与后代，每个单元的后代合起来所取更多或相等、各自所需不多于它，无中不生有，上限与体制，都是给定的，不是推出来的。"

*Applied*, both languages.

**SL4.** Becoming.lean (LineOnAStock bullet), check_becoming.py SCOPE: "...; without `down`, or with kids taking the same in place of more, it can go on (...); where every unit needs the same positive amount, it ends within `hi + 1` steps (`LineOnAStock.one_need_ends`)." The last clause can be attached to the countermodels before it. Proposed: "with `grows`, nothing given from nothing, that cap and a start at most `hi`, where every unit needs the same positive amount the net ends within `hi + 1` steps". README.md's order is already clear.

*Applied* in both, checked against one_need_ends (`one`, `pos`, `grows`, `nothing`, `keeps`, `high`). In SCOPE, which does not name binders, `grows` is said "each unit's kids together taking more than it".

**SL5.** For one wording throughout: "with kids taking the same in place of more" to "with a unit's kids together taking the same in place of more", README.zh's "后代所取相等而非更多" to "后代合起来所取相等而非更多", and "a way whose kids take more, or less" to "a way whose units' kids together take more, or less". True as they stand (EqualInPlaceOfMore has one kid per unit).

*Applied* where the phrases stand: Becoming.lean, README.md, README.zh.md, check_becoming.py SCOPE, dynamics.json exits[0] edge and open[1], the record's counterexamples[2], does_not_show[0] (160 of 240) and next_delta (323 of the hard cap 400), and the card's misfit (2). Becoming.lean has no "a way whose kids take more, or less".

**SL6.** README.md and README.zh.md (TurningInTime row), check_becoming.py SCOPE: count_rises is said to give `more` where the share is a natural number every favouring rule raises strictly and the use is that number times a positive amount; it also asks `upper` (favouring kept by a rule not lower) and `fav` (the start's rule favours). Proposed: add "favouring is kept by a rule not lower and the start's rule favours"; zh "份额是每个偏向的规则都使之严格增加的自然数、用量是它乘以一个正数、偏向被不更低的规则保持、起点的规则偏向时，`TurningInTime.count_rises` 给出 `more`".

*Applied* in the three, after reading count_rises in TurningInTime.lean.

**SL7.** turning-in-time.json laws[26] (locked_ends_on_window): "... and the levels in [N, K) marked, no marked level meeting the need where K ≤ N or K ≤ need." `un : K ≤ N ∨ K ≤ need` is a premise. Proposed: en "...; it asks K ≤ N or K ≤ need (un), under which no marked level meets the need."; zh "……[N, K) 中的水位被标记；要求 K ≤ N 或 K ≤ need（un），此时无标记水位满足所需。"

*Applied*, both languages (en 282, zh 167, within 420 and 190).

**SL8.** cards.json misfit (2): "grows, even and down are asked of every unit, or of every unit of a closed line; a way that mixes kids taking more and less (HigherStartEnds) ...". Proposed: "grows and down are asked of every unit, or of every unit of a closed line (grows there of its kids of the line together); even of every unit; a way that mixes units whose kids together take more and less (HigherStartEnds) ..."

*Applied*, as proposed.

## Premise rows

The reader found all five new rows (fall, gone_from, ways_alike, alike_iff, takes_nothing) to match their theorems' binders, the empty lists for the unnamed binders of gone_from and ways_alike truthful, and whether to follow integrate.py's convention of a premise per such binder a coordinator's choice. Nothing changed.

## Passed on, not applied

The Lean docstrings still say "each unit's kids take what it takes (`even`)" (LineOnAStock.lean lines 83, 1124, 1227, and the section title at 1118) and "each unit's kids of `S` take more" (line 45); the binder is printed beside each. Changing them needs a rebuild and a new core run; it is passed to the coordinator, since the four modules stay byte-identical to the scratch copies in this pass.
