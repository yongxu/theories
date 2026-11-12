# TT: the cold readings, in short (AI-written, Claude Opus 5.5, 13 November 2026)

Six AI agents read the Lean cold, read only, building nothing: one the held first attempt, three the first round of the landed files, two the second. Then the coordinating session (Fable) read all three files and made the last fixes by hand. The reports are in `readers/`, unchanged. What was done is taken from the plan's log (`drafts/PLAN.md`), `DESIGN-R2.md` and the files as they land; line numbers in the reports are those of the files they read, not of the landed ones.

## The reports

| Report | Read | Findings in short |
|---|---|---|
| [`readers/lean-reader-1.md`](readers/lean-reader-1.md) | the held first attempt (`held/TurningInTime-first-attempt.lean.txt`) | No false statement; the three witness courses right by hand. Its grammar section restated root laws (one exact duplicate, three one-line corollaries); docstrings left out premises without which they are false; a heading named a threshold the theorem does not give; in the exact condition the marks carried nothing. Four high, nine medium. |
| [`readers/v1-statements.md`](readers/v1-statements.md) | round 1, statement against claim | No wrong statement; the witness right; the marks carry weight in `turns_in_time_iff`. Section 6 claimed a join no theorem made; `regularity_in_level` said only that the way's class is not constant; premises missing from "What is given". No high, three medium. |
| [`readers/v2-duplicates.md`](readers/v2-duplicates.md) | round 1, restatement and placement | GrammarPath changed by additions only. GuardedStep re-proved `Law.unending_iff_steps` by its own induction; `regularity_in_level`'s first half holds of every relation. Two high, four medium. |
| [`readers/v3-conformance.md`](readers/v3-conformance.md) | round 1, conformance to the design and the direction | Every designed statement there, none weaker. The same two over-claims; the second ending never shown as a line; the design's `asItWas` not made; new vocabulary not marked. Two high, five medium. |
| [`readers/v4-statements.md`](readers/v4-statements.md) | round 2, statement against claim and vacuity | No false statement, nothing empty or true of every relation; nearly every first-round finding closed. Three prose sentences false or unproved. No high, three medium, eleven low. |
| [`readers/v5-duplicates-conformance.md`](readers/v5-duplicates-conformance.md) | round 2, restatement, placement and conformance | No false statement, no restatement of a package law. The package already has a guarded law the text did not name; the reason given for `decided` is not what the cited law proves. No high, two medium, twelve low. |

## What was done about each high and medium finding

**The held first attempt** (`lean-reader-1.md`). It was held, not fixed, and the module was designed again from the maps (`DESIGN.md`). H1 (restated root laws): the new module states its laws with the root's predicates on one relation, the net, and adds no root law; the one missing tie went into GrammarPath. H2 (missing premises): each law's docstring names all its premises, and the header says which bullet names the main ones. H3 (a threshold not given) and H4 (marks carrying nothing): `turns_in_time_iff` is stated on the course as it was, so the marks carry weight in it (v1 and v3 confirmed this). The mediums: "renew" stays only as the function's name and "carrier" is not used; `left_lt` and the module's own course and lasting notions are gone, the level's laws used as they stand (`Optimum`, `RegimeMargin`); the witness was rebuilt (`Three`).

**Round 1** (v1 to v3), taken in round 2 (`DESIGN-R2.md`):

- `regularity_in_level` (v1 M2, v2 H2, v3 H1): removed; its first half holds of every relation, as the root's `«火之见证不择类»` says of its own witness.
- Section 6's claim (v1 M1, v3 H2): retitled "The lock's courses as courses of the pair, at a need of nothing"; `window_unending` deleted; `net_zero`, `join_is_asItWas` and `window_agrees_until_marked` (from `agrees_until_marked`, not a new induction) added; the section says nothing derives that a lock needs nothing of what it uses.
- GuardedStep's own induction (v2 H1): `stepWhile_unending_iff` now comes from `Law.unending_iff_steps` through the tie `stepWhile_continues_iff` and one private transfer; `Becoming.GrammarRegularity` imported.
- GuardedStep's header (v2 M1, v3 M3): rewritten to say which laws come from the whole step's and which are proved pointwise.
- `stepWhile_fixed` beside `Law.step_fixed` (v2 M2): the one-line proof kept, its docstring names `Law.step_fixed`.
- `regime_levels`' arithmetic (v2 M3): it now uses `RegimeMargin.Adjusted.left_below` and `Adjusted.draw_pos`; the joint induction stays, which v2 itself found needed.
- The composite claim in GrammarPath's header (v2 M4, v3 M2): it now says the GrammarLaws law follows from two of the new ones, is not checked in Lean, and keeps its own proof there.
- Missing premises in "What is given" (v1 M3): `uses`, the one `giving`, `Meets`, `Keeps`, `within`, `high`, `asItWasEnds` with its reason, the given way, `FromNothing`, all added.
- The second ending never a line (v3 M1): `kind_ends_while_net_goes` added, and a conjunct of `Three.turned_and_ends`; in the last fixes `Three.line_ends_while_net_goes`, which applies the root's `«亡而网续则不至终有常»`.
- `asItWas` (v3 M4): made a definition and used throughout.
- New vocabulary (v3 M5): the header says the model's words are labels of its parts, not the root's; 可决 is explained on the pattern of 可续.

**Round 2** (v4, v5), fixed by the coordinating session before the landing:

- "Sections 4 and 5 say nothing of them" (v4 M1): now says the ending where the net ends and the split do not apply to the capture modules' models and the laws on a kind's class hold at every need.
- `window_through` misdescribed (v4 M2): `window_agrees_until_marked`'s docstring now gives `window_through` and `window_past` as past `K`, and `window_unread` at `K ≤ N`.
- The reason for `decided` (v4 M3, v5 M2): replaced by a Lean witness, `Law.stepWhile_toEnd_decides`; `«尽则有终当且仅当排中»` is named as a neighbour, not as the reason.
- The package's guarded law (v5 M1): `Viability.guardedStep` named in GuardedStep's header, and tied by `Law.stepWhile_guarded_iff` (by `Lasting.guarded_upto_iff`).
- Of the lows, these were fixed too: the AI-written marker in GrammarPath (v4 L1, v3 L10); the witness that the fixed successor cannot be dropped made a Lean statement, `«后不定则至终有常可不同行»` (v4 L2, v2 L2); "that `x` is marked is not a premise" (v4 L3, v5 L7); `locked_at_class` said at the member's class (v4 L6); `FromNothing` in "What is given" (v4 L7); `Optimum.ends_within` and `RegimeMargin.ends_iff_below` glossed with their premises (v4 L8, L9); "three for the kept kind" (v4 L10); the kind laws' premise renamed `other` (v4 L11); the private transfer named in GuardedStep's header (v5 L1); `Law.steps_orbit` cited (v5 L2); `windowRegroup` through `ClosedCapture.loopPart` and `loss` (v5 L3); `DrawHistory.underDraws` named as an identification not stated (v5 L4); the argued sentence marked as argued (v5 L9); a witness for `kind_not_toEnd_of_turn` (v5 L11, v1's vacuity note).

## Low findings left

- That `(true, 6)` lies on a line under the way's class from `(true, 9)` is argued; `Three.line_ends_while_net_goes` proves the step from `(true, 8)` continues and that `(true, 6)` ends while the net goes on (v4 L4, partly met).
- That a regrouped course is a line of `net 0` is the composition of `window_is_pair` and `net_zero`, not stated; the section's title says "at a need of nothing" (v4 L5).
- `ends_with_net`'s premise is still named `renews`, `Optimum.ends_within`'s own name (v5 L5).
- Borrowed words (lock, loss) stand in the header's "What is given" outside section 6, and the name `core_tells` reads as a doer, though its docstring is exact (v5 L6, v3 L2, v3 L4).
- The private `regime_levels`' docstring does not name `FromNothing` or its step premise (v5 L8).
- Declarations that could go without losing a claim were kept by the design: `alike_along`, `ends_with_net_regime`, `unmarked_interval_iff`, `core_tells`, `window_paced`, `stepWhile_step`, `stepWhile_always`, `stepWhile_hasSucc_iff`, and `regime_step_eq` public though used only privately (v5 L10).
- The new GrammarPath laws sit beside their GrammarLaws counterparts, paired only in GrammarPath's header, because GrammarLaws lies upstream (v2 L1).
- Two forms of the decided premise, GrammarPath's and OwnClass's, with no sentence relating them (v2 L3); it is the record's next step.

No third reading round was run: the plan allows two (D4), and no high or medium finding is open.

## After the cold readings: the kit and the atlas entry

- `readers/v6-landing-kit.md` (an AI agent, 13 November, on the prepared landing before any heavy run): registration correct; each public declaration named in exactly one law; links and JSON sound. One high: the atlas entry had no premises, which would have marked family A unread at the render. Five medium: "the lesser use" where the law has no such premise; the record's statement dropping the draw premise; the README rows dropping premises of the exact condition; no Chinese in the records; the near work's counts disagreeing. All were fixed by the coordinating session before the records were bound: the section and the rows reworded, the statement rewritten under its cap, the Chinese of both records' titles, statements and laws written directly, the counts made one.
- `readers/v7-atlas-premises.md` (an AI agent, 13 November): thirteen premises added to the atlas's ledger for this dynamic, ten existing ones reused, the exits' drops and the hypotheses filled. Left out, and said in that report: premises for the declared theorems that no exit, transition or edge names, and joins to `margin-of-a-regime` and `closed-capture`, which the atlas's `compose` roles do not fit.
- `readers/v8-map-card.md` (two AI agents, 13 November, after the first render stopped): the map's data layer asks one card per atlas dynamic and had none for this one. One agent wrote the card from the Lean statements; a second, set to refute it, corrected five sentences (the turning clause had been stated without the regime's premises, under which alone it is exact; "marked" had been left undefined; one misfit sentence said more than `AloneOutside` gives). Left and said in the card's misfit: the map's marks cannot tell this dynamic's two endings apart, and the use and the giving are cast as roles though neither is a second thing in the Lean.
- `readers/v9-follow-up-lean.md` (an AI agent, 13 November, on the follow-up): the two new laws correct, not vacuous (an instance by hand), no duplicate of an existing law; `locked_alone` repeats `locked_stays`'s induction only because its start can have any step count. One high: the rename had to reach the record, the chapter and the atlas, which this landing does. Three medium, fixed: two header sentences left out the premises under which the locked line ends, and section 6's title still said "at a need of nothing". The name `core_tells`, named above as a low finding left, is now `core_apart_below_need`.
