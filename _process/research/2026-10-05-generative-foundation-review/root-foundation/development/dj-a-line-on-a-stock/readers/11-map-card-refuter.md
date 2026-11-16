AI-written, 16 November 2026. A reader set to refute (Fable) read the map card for the dynamic "a-line-on-a-stock" (theories/becoming/results/map/cards.json in /Users/ren/tmp/dj/wt, at f2c93e157) against Becoming/LineOnAStock.lean, the atlas entry, its premises and web.json. It built, rendered and edited nothing; it ran the map's checker in memory, which wrote nothing. Its findings are kept below as it gave them, each followed by what was done with it (AI-written, by the agent that applied them, before the second core run). The Lean modules did not change.

## Findings

**F1 (must fix).** cards.json, plain_en and plain_zh, the unending_iff_holds clause. The text says "where kids take exactly what their parent takes, every unit has kids, kids need no more than their parent" / "后代所取恰等于亲代". The Lean asks `(even : ∀ u, taken use (kids u) = use u)`: the kids together. The clause beside it, down, is of each kid, in the same grammatical form, and the same sentence twice writes "together" for grows. Read of each kid, the premise is another one: TwoForOne (P takes two, its two kids one each) falls outside it, and a way whose every kid takes its parent's use doubles its take. Proposed: en "where each unit's kids together take exactly what it takes, every unit has kids, each kid needs no more than its parent and every descendant needs something"; zh "每个单元的后代合起来所取恰等于它、每个单元都有后代、后代所需不多于亲代".

*Applied*, as proposed, in the card. The same phrase stood in four more places of this landing, and they were changed the same way: the atlas entry's mechanism ("Where each unit's kids together take exactly what it takes, under the regime along the course") and its transition-1 edge ("Where each unit's kids together take exactly what it takes, every unit has kids, each kid needs no more than its parent, …"), the name of the premise lineonastock-even in premises.json ("each unit's kids together take exactly what it takes"; its statement already said "together"), and the L2 row of Becoming.LineOnAStock in README.md ("with each unit's kids together taking exactly what it takes") and README.zh.md ("每个单元的后代合起来所取恰等于它"). Becoming.lean and check_becoming.py's SCOPE do not state this premise in words.

**F2.** cards.json, law falls_to_unmet, then_en and then_zh. The text says "At need_unmet's step n, the level is below the need of some unit of the start's way whose need the start met, and below the start level." The statement carries the step itself (`∃ n, 0 < n ∧ n ≤ hi + 1 ∧ (∀ j, j < n → …) ∧ … ∧ (∃ p, p ∈ w ∧ need p ≤ x ∧ (course … n).2 < need p) ∧ (course … n).2 < x`). It is the only then-sentence in cards.json that leans on another theorem's name, and by rank LAWS.md will quote it alone as "An order that is kept" on needs|dependent|stock. Proposed: en "At the first step with an unmet need, a step from 1 to hi + 1 before which every need is met, the level is below the need of some unit of the start's way whose need the start met, and below the start level."; zh "在首次有所需未被满足的那一步（在第 1 步到第 hi + 1 步之间，此前每一步所需都被满足），水位低于起点方式中某个所需曾被起点满足的单元之所需，也低于起点水位。"

*Applied*, as proposed.

**F3.** cards.json, plain_en and plain_zh, the line_ends clause. The text says "has kids of the line that together take more than it and has kids that need no more than it". The Lean asks `(down : ∀ u v, S u → v ∈ kids u → need v ≤ need u)`: every kid, of the line or not. README.md, Becoming.lean and SCOPE now say "has kids that each need no more than it"; the card lacks "each" and can be read as some kids. Proposed: en "and has kids that each need no more than it"; zh "它的每个后代所需不多于它" (README.zh.md's words).

*Applied*, as proposed.

**F4.** cards.json, built_cases and misfit (7). The only case shown of unending_iff_holds is EqualInPlaceOfMore.holds_by_law, whose kids are `[()]`, WayOfUnits' case; TwoForOne is listed among what is left out. Proposed: add a built case Becoming.LineOnAStock.TwoForOne.holds_by_law, and drop TwoForOne from misfit (7)'s list.

*Applied.* The built case was checked against TwoForOne in LineOnAStock.lean (P takes two and leaves Q, Q; Q takes one and leaves itself; both need one; giving TurningInTime.Three.giving, min z (12 − z); y := id, hi := 12; the course is ([Q, Q], 4) from step 1; the law used from its right-hand side at k = 0). Its shows_en ends "a case of that law in which P's kids are not P itself" in place of the proposed "its one closed case whose offspring are not the unit itself", since that it is the only such case was not checked here.

**F5.** cards.json, misfit (2). The text says "a way that mixes kids taking more and less (HigherStartEnds) falls under none of the laws". HigherStartEnds.higher_ends is proved by ways_alike, a law of this card, as the card's own fifth built case says. Proposed: "falls under none of the laws that ask one of them (way_ends, need_unmet, falls_to_unmet, line_ends, fall, unending_iff_holds); ways_alike holds of it".

*Applied*, as proposed. LineOnAStock.lean's module docstring says the same "falls under none" (its section on what does not follow); that is passed on to the coordinator, not changed.

**F6.** cards.json, plain_en and plain_zh, last sentence. The list of what is given, not derived, leaves out nothing given from nothing, a premise of need_unmet, falls_to_unmet, way_ends, line_ends and unending_iff_holds. Proposed: en "…and need no more, nothing given from nothing, the cap and the regime are given, not derived."; zh "…所需不多，无中不生有，上限与体制，都是给定的，不是推出来的。"

*Applied*, as proposed.

**F7.** cards.json, law way_ends, "about": 0. Filed on passes-on with sameness "some need of the way met". That sameness is Goes, which the card's needs tie describes ("the net has a next while some need is met"); need_unmet, unending_iff_holds and turning-in-time's ends_with_net sit on needs. As filed, passes-on holds four laws to needs' three and is the dynamic's home in DYNAMICS.md; with about 3 the home is needs. A choice for the coordinator: "about": 3, or keep 0 with sameness "the net goes on".

*Applied* as "about": 3, the sameness kept: way_ends concludes that Goes fails at some step, and Goes is what the needs tie says. This moves the dynamic's home tie in the generated views to needs; the coordinator may choose otherwise before merging.

**F8 (must fix).** theories/becoming/results/atlas/entries/dynamics.json, a-line-on-a-stock, exit 3 edge (not the card; rendered by the same run). The text says "With kids taking no less, one need m, giving at nothing below m and what the line takes at the start more than every giving, the same holds with no cap asked (fall)." The Lean asks `(keeps : ∀ u, S u → use u ≤ lineTake S use (kids u))`, kids of the line, and over is given; read of all kids the law fails. The mechanism's "with every unit's need positive as well, the net ends" is true and only carries need_unmet's start premises, which way_ends does not ask. Proposed: "With one need m, each unit of the line having kids of the line that together take no less than it, giving at nothing below m and, given, what the line takes at the start more than every giving, the same holds with no cap asked (fall)."

*Applied*, as proposed. The mechanism's sentence was left as it is, as the finding says it is true.

## Checked and found fine (the reader's own list, shortened)

The checker ran with no error (185 dynamics; the interactive page within its size limit). All ten law names exist and are atlas declarations; nine evidence lines equal their Lean statements, falls_to_unmet's eliding one conjunct. main_ifs equal the atlas rows' takes for the five laws with a row; the other five say every premise in then_en. Every then_en says what is concluded, with need_unmet's, line_ends' and takes_nothing's disclaimers; exact only for the two iffs. Forms, marks, frames, cast and ties are web.json's and true of the definitions. The seven built cases exist and show what is said (recomputed). No wording that LANDING-WHAT bars is in the card. plain_zh says plain_en clause by clause. The four registering texts and the two records are as the implementer reported; the four modules are byte-identical to the scratch copies.

## The reader's summary

The card is sound against the Lean; F1 and F8 would mislead a reader in the way the first review's must-fix did, and F2 to F7 are improvements. Because the card's sentences become the quoted ones in LAWS.md for several questions (need_unmet and way_ends, unending_iff_holds, falls_to_unmet, gone_from, ways_alike), F2 was worth doing. The stages of the render after the map were not checked by this reader.
