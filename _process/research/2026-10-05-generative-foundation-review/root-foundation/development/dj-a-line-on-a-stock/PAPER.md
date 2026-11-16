# Steps 3 to 7 on paper: one model, not five

*AI-written (Fable), 16 November 2026, a working record. Kept in this study folder as it stood when the Lean landed; [the note](NOTE.md) says what came of it. Where it names a file beside it: `readers.json`, `stage-a-review.json`, `web-join.json`, `passes-review.json`, `repair-review.json` and `last-fixes-review.json` are the six files in `readers/`, in that order; the `BRIEF-…` files are in `briefs/`; `sim.py`, `worked.py` and the readers' and implementers' scripts are in `sim/`. Nothing here is proved. It is the candidate, written before any Lean and before any reader, with what would count as nothing having changed frozen below. Corrections are appended with their date and never overwrite.*

## Why one model

Ren, 16 November (01:40 WIB): the aim is a map that is joined and simple, not results said again. Steps 1 and 2 landed in one model: a way and a level (`Becoming/TurningInTime.lean`, on `RegimeMargin`, with `WayOfUnits` and the lock of `RuleCapture` and `PoolFromCourse` joined to it). The plan's steps 3 to 7 were written as five separate tries. This page asks whether they are five statements about one model that extends that one, so that each lands as a law of it and the built examples come out as cases.

## The candidate model: lines on a stock ("L")

`WayOfUnits` has a way as a list of units, each with a need and a use; a unit goes on while the level meets its need; the level is `RegimeMargin.step giving (taken w) x`. Every unit there leaves exactly itself. L lets a unit leave offspring:

- a type `U` of units, with `need use : U → Nat` and `kids : U → List U`;
- `after w x` = for each `u` in `w`, in order: `kids u` if `need u ≤ x`, nothing otherwise;
- `taken w` = the sum of `use u` over `w`; `left w x = RegimeMargin.step giving (taken w) x = (x - taken w) + giving (x - taken w)`;
- `Goes (w, x)` = some `u` in `w` has `need u ≤ x`; the net is `Law.stepWhile Goes (TurningInTime.pair after left)`; the course is its orbit.

`WayOfUnits` is the case `kids u = [u]` on `U = Nat × Nat`. The Lean's descent vocabulary (`kids : α → List α`, `SelectionTerm.Generations`, `offspringCount`) is the same shape with the level left out.

Nothing in L chooses. Which units go on is fixed by the level against their needs; the level is made by what the units draw.

## Candidate laws (each can fail)

**A. Who goes on (plan step 3).**
- A1. `after w x = after w x'` wherever `x` and `x'` meet the same needs in `w` (for all `u ∈ w`: `need u ≤ x ↔ need u ≤ x'`). Alikeness: all that reaches the way from the level is which needs it meets.
- A2. The number of `v` in `after w x` is the sum over `u ∈ w` with `need u ≤ x` of the number of `v` in `kids u`. Unequal continuing: what each leaves.
- A3. Two courses from `(w, x)` and `(w, x')`: as long as every need in the way is met on both, the two ways are equal at every step, whatever the two levels do.
- A4. A worked pair: two starts that differ only in level, equal ways for several steps while one level falls toward its point of no return, and then one line ends and the other never does.

**B. A line that grows overdraws (plan step 5).** Given: `giving 0 = 0`; a bound `hi` that the level never passes under any draw; every need positive; offspring need no more than their parent (`need v ≤ need u` for `v ∈ kids u`); every unit's offspring together draw more than it did (`use u < taken (kids u)`). Then:
- B1. from any start, at some step some unit's need is not met (the overdraw is concluded, not given);
- B2. the net ends.
- Kept countermodels expected: (i) offspring that need more than their parent and are shed each step (a way `[A, B]` that goes on forever with every unit "growing"); (ii) equality in place of strict growth (a way that holds forever); (iii) a share that rises as a ratio while the number of drawers does not.
- On the lock: a `Locked` way whose share is a number of drawers that rises at every favoured step has `draws` (the floor on the use) and `below` (the start already overdrawing) of `locked_ends_with_net_regime` as conclusions at some step, so it ends still locked with no overdraw given.

**C. The exact condition (plan step 4, in L).** The net from `(w, x)` never ends exactly where its course reaches a configuration that holds: not empty, every need met, the way unchanged by the step, and the level at or above the point of no return of what the way draws. `WayOfUnits.unending_iff_holds` is the case `kids u = [u]`. Separately (a reader's question, not this page's candidate): whether `Flow`'s renewed stock has such an exact point, or `RegimeMargin`'s level is a case of `Flow`'s family.

**D. What the course responds to is made by what it kept (plan step 6).** Call two levels alike to a way where they meet the same needs in it (A1's relation). 
- D1. Without new kinds (every `kids u` a list of copies of `u`), the relation only coarsens along a course: levels alike to `w` are alike to every later way. The line comes to respond to less of its stock, never to more.
- D2. With variation (a kid that is not a copy), a level can come to make a difference that made none before; a worked course where that happens in time, and one where it happens too late.
- D3. One statement with both directions: which kinds are in the way at step `n` is fixed by the levels' course through the needs (A), and which levels are alike at step `n` is fixed by the kinds in the way.

**E. Losses (plan step 7).**
- E1. A kind that no unit of the way can reach by descent is never in a later way.
- E2. Who ends at a step is fixed by need against level and by nothing else: a unit's use makes no difference to whether it is among those that end.
- E3. A worked course: `A` (low need, high use) and `B` (high need, low use). Without `A`, `B` goes on forever. With `A`, the level falls, `B` ends and never returns, and `A` goes on forever at a level it holds, its own course the same as on a stock where nothing was lost.

## What would count as nothing having changed (frozen 16 November 2026, before any Lean and any reader)

- **A.** (1) No proof in the module uses A1 and A2 together; the "joint" statement is then two facts set side by side. (2) `WayOfUnits`'s course is not proved to be the case `kids u = [u]`. (3) The statement holds unchanged with the stock removed (a constant level). (4) L's course is not shown to be a family of `SelectionTerm.Generations`, so the Lean's existing identity for unequal continuing does not apply to it.
- **B.** (1) The premise that makes the draw rise speaks of the course (`taken` at step `n`) and not of units. (2) Neither `LineageDrawdown.Drain`'s ending nor a part of `ReadingsSpread.Commons` comes out as a case, and no reason is given. (3) The lock form still takes `draws` or `below` as a premise.
- **C.** The condition is `WayOfUnits.unending_iff_holds` with a premise that assumes a regime along the course in the same way, and covers no way whose units multiply or vary.
- **D.** The alikeness is a relation handed in and not computed from the way; or D1 and D2 are stated for a way that does not change.
- **E.** E1 is `mem_course_iff` reworded with no descent in it; E3 is a computed case with no law under it.
- **For the whole.** If L lands as a module that no existing theorem rests on and that rests on none of `RegimeMargin`, `TurningInTime`, `WayOfUnits`, `RuleCapture`, `SelectionTerm`, it is one more island and the direction has not moved.

## Not in this candidate

A reading at some steps only; amounts in the grammar's own terms beyond `«不穷»` and `«亡»`; a web of several stocks; anything about what should be done.

## 16 November, about 01:55 WIB: first search and a proof route (before the readers' reports)

**Search (`sim.py`, a search and not a proof).** Random worlds of one to three kinds on humps `min z (c - z)`, `c` in 8 to 14, needs 1 to 9, uses 0 to 3, up to three kids.
- B1 (every unit's kids together draw more than it did): 87,739 worlds, none in which every need stayed met for `hi + 2` steps.
- B2 (with `need v ≤ need u` for every kid `v` of `u`): 58,266 worlds, none unending.
- Without that premise: 100 of 29,473 unending. One: needs `[4, 9]`, uses `[2, 1]`, kids `A ↦ [B, A, B]`, `B ↦ [B, B]`, hump 10, way `A B B` at level 8. `A` is met and leaves `B A B`; both `B` (need 9) are not met and leave nothing; the way and the level repeat for ever. Offspring that need more than their parent are born and shed at each step.
- With `≤` in place of `<`: 18,467 of 90,540 unending (a unit that leaves itself holds).

**A worked course for E3** (`worked.py`), on `min z (12 - z)`: `A` = need 1, use 4; `B` = need 11, use 2; each leaves itself; start 11. Together: 11, 10, 8, 8, 8: at step 1 the level 10 is below `B`'s need, `B` leaves nothing and is never in the way again, and `A` goes on for ever at 8, its own point of no return. `B` alone: 11, 12, 12, for ever. `A` alone: 11, 12, 12, for ever.

**Proof route for B2 (constructive, no minimum of a list).** Write `Below m w` for: every unit of `w` has need at most `m`. Claim `S m`: from every `(w, x)` with `x ≤ hi` and `Below m w`, some step of the course has no unit whose need is met. By strong induction on `m`.
- If `x < m`: step once. Every unit of the next way is a kid of a unit met at `x`, so by the premise on needs it needs at most `x`: `Below x` holds of the next way, `x < m`, and the induction gives the step.
- If `m ≤ x`: every unit is met. Inner induction on fuel `hi + 1 - taken w`. If the way is empty, done. Otherwise the next way is all the kids, still `Below m`, and draws at least one more. If the next level is below `m`, the first case applies to it. If not, then the draw was at most the level (a draw above the level sends the level to `giving 0 = 0`, and `m ≤ 0` with a unit present contradicts positive needs), so the fuel is positive and falls.
- Start: any way is `Below m` for `m` the largest need in it.
B1 is the inner induction alone, with no premise on the kids' needs.

**A line within a way.** The same route works for a part of the way picked out by a predicate `G` closed in the sense that each `G`-unit's `G`-kids together draw more than it did and need no more than it: the other units only lower the level further. Conclusion: at some step no `G`-unit's need is met. With `G` everything, the net ends. This is the plan's wording, a line living on a stock, and it lets the law be used in a mixed way.

**Steps 3 and 5 are one landing.** The page's own test for A (some proof must use alikeness and unequal continuing together) is met by B1 and by nothing in A alone: the growth goes on at the same rate while the level falls, because the level makes no difference to who leaves what while needs are met, and that is why the draw passes what the stock gives. So the first landing is the model, A1 to A3, the case `kids u = [u]`, B1, B2 and the kept countermodels; whether it is one more island is the readers' question.

**Law C is false as worded.** "The way unchanged by the step" is not necessary for a line to go on for ever where kinds alternate (`A ↦ [B]`, `B ↦ [A]`) or where a unit of no use multiplies. It is kept for ways whose units leave copies, or dropped; the plan's step 4 is about `Flow`'s stock and waits for the reader.

## 16 November, about 02:05 WIB: what six readers found (workflow wf_1f1760eb-f4d; reports in `readers.json`, their scripts under `readers/`)

Read only; nothing built. Each claim below is a reader's, with its evidence in the report; none is Lean-checked.

**The model is not in the Lean, and its parts are.** No module has units with needs on a renewed level whose offspring multiply (the seven modules on `RegimeMargin.step` have no `kids`; the 24 with `kids` have no `RegimeMargin`). The parts: `SelectionTerm.Generations` (`first`, step-indexed `kids`, `amount`; `born_eq`, `total_flatMap`, `reached_from`, `kept_of_descent`, `kept_iff`), `TurningInTime` (`agrees_until_marked`, `toEnd_iff`, `ends_with_net_regime`), `WayOfUnits`, `GrammarLaws.keep_congr`, `Web.RecruitsThrough.members_alike` with `RecruitsThrough` assumed. Nearest law to B: `LineageRegimes.multiplying_takers_stop`, with nothing given and the growth a premise on the course.

**No statement in the package names both relations.** A scan of every declaration found none with a count word and an alikeness word; the nearest, `share_rises_through`, takes `select` as a free predicate.

**What was wrong or too weak on this page.**
- A1 to A3 hold with the stock removed, so by this page's own test they are the count and the alikeness side by side. With a constant level and no new kinds two courses part at step 0 or never: parting after alike steps needs the stock. What uses both is the count on two stocks (alike levels, one count) and the rise of the draw.
- A4's wording "falls toward its point of no return" is wrong for a way that does not change (a level at or above it never falls). And the fate is **not monotone in the level** once units leave offspring: of 26 random pairs with growth while alike, the higher start ended in 19. One: `A` = need 1, use 3, kids `[B, B]`; `B` = need 3, use 1, kids `[C, B]`; `C` = need 12, use 1, kids `[A]`. From 6: `A`@6, `BB`@6, `CBCB`@8 for ever. From 7: `A`@7, `BB`@8, `CBCB`@12, six units@12, ten@4, sixteen@0, ended. More of the stock met `C`'s need, and `C`'s offspring draws three. So no single level from below is exact for a line that leaves offspring.
- B1 as worded is true of a start with a need already unmet, and false of the empty way. It should say: from a way that is not empty with every need met, a need comes to be unmet. B fails from a start above `hi`, with a need of nothing, and with something given from nothing (each kept).
- B is not what the built examples show. `LineageDrawdown.Drain`'s course is a course of this model (with the gate, the twelve levels agree), but its ending is one multiplying step and then a standing take above what is given: a line that does not shrink and takes more than is given at any level is gone. That weaker law (a reader's "Fall") is met by Drain, Commons' focal line, Habitat's overdrawn line and `MultiplyingTakers`, checked by hand. In those examples a unit whose need is unmet draws nothing; here, as in `WayOfUnits`, it draws in its last step.
- C: confirmed false. What must stand is what the way takes, not the way. A met unit with no kids ends the net with every need met. A simple true law in its place: on a course that goes on, what the way takes is less than the level at every step.
- The stock (plan step 4): the `Flow` family cannot have an exact point on a level, because what is given is a free field there and not a function of the level; `Continuation`'s `Exceeding` and `Alone` are a countermodel already in the files. The regime is a `Flow` on paper (one formation, take `min level H`, give `giving (level - H)`; `Balances` held in all 112 cases tried), and then the two halves of `RegimeMargin.ends_iff_below` are `Flow`'s two one-step laws under `Short` and `Meets`.
- D: D1 is near-trivial and cut in the wrong place (on kinds; it should be on needs). D3 is a definition and A1. What is true and has content: the relation changes at a step exactly where a need is unmet; and for two levels alike to the way, the same needs are in the next way, so **a new difference never arrives because of a difference not yet made**. In this model a reader of the fall cannot form because of the fall; a new need arrives on descent's own schedule. The chapter's open item (01-ROOT line 670: a change of the law of change with no fixed scheme) is not closed by this model: kinds and offspring are given with the carrier.
- E: E1 is `Generations.kept_iff` once the way is a family. E2 is true by definition at one step and false along a course (`With` and `Against`: same needs and sum, different uses, one ends). E3's last clause is false: on one stock inside the regime, **the drawer goes on because the other was lost**; with the other kept, the line ends (all cases tried). A loss that makes no difference to those who drew is found only where the lost unit drew nothing (levels and the others' presence identical with and without it), from a start above `hi`, or on a second stock, where `ReadingsPersist.Habitat` already has it as a law.

**Hosting.** A new module that imports `WayOfUnits`; generalising `WayOfUnits` in place would change 55 of its 85 statements and add no join. `WayOfUnits.taken` is `Prelude.total` at the use, redefined.

## The candidate after the readers (16 November, about 02:10 WIB)

One relation with two ends: the way reads the level only through which needs it meets, and the level reads the way only through what it takes. The laws tried, in the order of the Lean:

1. *Who is in the next way* (`mem_after_iff`), *alike* (`after_alike`), *lines reach each other only through the level* (`after` of an append is the append).
2. *Alike levels, one count.* On any two stocks, while the two levels meet the needs of the way, the ways are equal and are the free generations of the start; the way is a `Generations` family, so the Lean's count identities hold of it.
3. *The case of `WayOfUnits`.*
4. *Rise.* For a line (a predicate offspring inherit exactly) whose units' offspring draw more than they did: at a step where every unit of the line is met, what the line takes rises by at least their number.
5. *Fall.* A line of one need whose units' offspring draw no less than they did, taking more than is given at any level: gone at a later step.
6. *A line that grows ends*, with unequal needs that do not rise along descent; and from a way that is not empty with every need met, a need comes to be unmet.
7. *On a course that goes on, what the way takes is less than the level.*
8. Kept: kids that need more than their parent; equal in place of more; a share that rises while the number of drawers falls; the doubling course 12, 12, 12, 12, 8, 0; the pair in which the higher start ends.

Later, in the same module: units that take nothing make no difference and can be lost to the others' draw; what is lost never returns unless descent reaches it (`kept_iff`); the relation changes exactly where a need is unmet, and no new difference arrives from one not yet made; the regime as a `Flow`; the lock whose share is a number of drawers.

*Times in the three headings above were first written from guesswork (02:10, 03:30, 03:40) and corrected from the clock at 02:12 WIB.*

## 16 November, 02:45 WIB (from the clock): stage A read, and the join to the webs tried on paper

**Stage A in scratch** (`lean-scratch/Becoming/LineOnAStock.lean`, 1,145 lines, 83 theorems, build `buildA3.log` clean, no axiom; workflow wf_01b357cf-23a; reports in `stage-a-review.json`). Three readers who did not write it: no counterexample to any statement, every worked number recomputed and equal. And: it is joined to the package at definitions and hardly at laws; a dozen facts are proved again; `alike_one_count` is one single-course fact stated twice with "every need met" for alikeness and no count; one direction of `same` is idle; `need_unmet` holds with `hi + 1`; five docstrings say more than their statements; no closed instance for `fall`, `line_ends` on a proper part, `need_unmet`. By this page's frozen tests: A(1) and A(3) fire for the alike laws (they hold with no stock; the two relations meet only inside the rise of the draw), A(2) and A(4) pass, B(1) passes, B(2) fires (no built example is a case). So the next pass turns the import round (`WayOfUnits` rests on the general module and its main theorem becomes the middle case of three: offspring draw more, the same, or less), states alikeness as alikeness, and makes the growing way and the lock two cases of one law of `TurningInTime`.

**The course as a `Web` with a `Flow`: a dictionary** (workflow wf_697e7266-152; a proposer and two refuters, read only; `web-join.json`). The instance is well typed and balances exactly where what the way takes is within the level. Every transfer then unfolds to a statement already had (`Adjusted.step_holds`, `step_below`, `orbit_bound`, `mem_after_iff`, `after_alike`). The general reason, from a refuter: under `Balances` each one-step `Flow` premise is equivalent to its conclusion (taken within given exactly where the level does not fall), so a `Flow` law says something only where what is given and taken is known apart from the level's change; in an instance that computes them from the level's own step every such law is a restatement. The package's own bridge already exists (`Stock.stockFlow`, `stockWeb`, `carried_iff`), and the regime already balances (`RegimeMargin.Adjusted.step_balances`), its fall taken from `Amounts.falls_by_stretch`. What survives, none through the instance: (1) `Flow.family_excess_bounded_at` could be proved from `Amounts.falls_by_stretch`, one law under both families (a fold owed when `Continuation` is next open; not compiled); (2) the plain account over a stretch, in the new module; (3) alikeness iterated along two courses, which the next pass states.

**So the plan's step 4, as it stands on paper.** In the `Flow` family no exact point on a level can be stated, because what is given is a free field there (`Continuation`'s `Exceeding` and `Alone`). Exactness comes with giving as a function of what is left, which is the regime, and the two families already share their law one level down. A further join would be a renaming. With offspring there is no point from below at all: the higher start can be the one that ends.

## 16 November, 04:11 WIB (from the clock): three passes in scratch, five readers, and what a repair is for

*AI-written (Fable). The reports are in `passes-review.json` beside this file (workflow `wf_240dc8dc-142`); the readers' scripts are under `readers-C/` and `readers-AB/`. Searches by script are not proofs.*

**What was built (green in scratch, every axiom report empty).** Pass C added to `TurningInTime`: `ends_with_net_rising`, `locked_ends_rising`, `count_rises`, `windowAfterShare`, `locked_turns_in_time_share_iff`, `share_corrected_stays`, and two courses in `Three`. Pass A2 turned the import round: `WayOfUnits` rests on `LineOnAStock`, with seven of its theorems proved as cases at `kids u = [u]`, and a general `unending_iff_holds` for units whose kids take what they take. Pass B added `Alike` with `alike_iff`, `needs_after_iff`, `takes_nothing`, `account`, and two built examples (`LineageRegimes.MultiplyingTakers`, `LineageDrawdown.Drain`) set beside the model.

**What five readers found.** No counterexample to any statement and no wrong number (searches of up to 3.4 million small worlds per law; every premise of the main laws has a countermodel when dropped). And these, each of which is a place where my brief or my telling was wrong or said more:

- *The lock.* I had called `ends_with_net_rising` "an overdraw that comes about rather than being given". It concludes an ending. What ends the line is a use that rises by at least one each step against a level that cannot pass `hi`: by step `hi` the use takes the whole level. The rise is a premise (`rises`; on the lock `more`, which `count_rises` gets from two further givens: every favouring rule raises the count, and the use is the count times a positive amount). "No overdraw given" is true of the start only. The bound `2 * hi + 1` was twice the true one; `hi + 1` is reached. In the worked case the old law's premises are met from step 4, so the new case adds four steps held at twelve before an overdraw of the old kind stands.
- *A correction that reaches what the rule is set from.* `locked_turns_in_time_share_iff` is `turns_in_time_iff` instantiated. The correction reaches the share because the reading overwrites it (`sets`, given), not because the share falls under the corrected rule; the overdraw of the course as it was is still given there. That what goes on is the corrected rule was a docstring's inference: no statement joined the two `T`s.
- *Joined, and nothing smaller.* `WayOfUnits` went from 1,182 to 1,257 lines: the bridge added more than it retired, and five of its lemmas were left used by nothing. `LineOnAStock` stood at 2,057 lines with facts proved again that exist (`kept_iff` and `kept_of_descent` of `ReadingsPersist`; `total_flatMap`; `step_falls_by`; two private lemmas of `TurningInTime`).
- *Alikeness and the stock still meet in no law.* `ways_of_alike` is the definition of `Alike` chained (it holds for any `after`); `kids_alike` is its premise read through a definition. Frozen test A(3) still fires for every alike law: they hold with no stock. The stock parts two alike courses only in the closed case `HigherStartEnds`.
- *Units that take nothing.* `takes_nothing` concludes equal levels and equal ways once those units are taken out. Its title said "make no difference", and that is false of whether the net ends: `A` (need 5, use 1) with `C` (need 1, use 0), nothing given, from 5: with `C` the net never ends, without it it ends at step 1.
- *The built examples.* Sizes and levels are equal step by step, by computation; neither example's ending was concluded from a law here, and in `drain` the law `fall` did no work. Frozen test B(2) is met only so far.
- *The middle case.* `unending_iff_holds` is general in its statement, and its only closed instance was the old case (`kids u = [u]`). Frozen test C: the regime along the course is still assumed, as in `WayOfUnits`.

**What the repair is for (briefs `BRIEF-REPAIR-T.md`, `BRIEF-REPAIR-L.md`; workflow `wf_a381e60a-001`).** One public lemma in `TurningInTime` (`rising_takes_all`: a use that rises for `hi` steps takes the whole of a level that cannot pass `hi`) on which the lock's law and the growing way's law both rest, with the bound `hi + 1`. `need_unmet` restated as the law where alikeness and the stock meet: there is a first step with an unmet need, within `hi + 1` steps, and up to it the way is `generation kids j w`, the way on every stock that meets its needs. That is this model's form of the direction's sentence that a selection can use up what sustains it while nothing in it yet differs. The built examples move to their own module, and Drain's family coming to be empty is to be concluded from `fall`. `WayOfUnits` loses what nothing uses and nothing tracked names. Every docstring is read again against its statement.

**Not reached, and kept as open.** A way that changes what it responds to because of the fall (a reader of the fall formed by the fall; `01-ROOT` line 670) is not in this model: here no new difference arrives from one not yet made (`ways_alike`). No exact condition for a way whose kids take more, or less, never ending; with offspring the fate is not monotone in the start level. A share that falls under the corrected rule is not tried. A reading at some steps only is not tried.

## 16 November, 05:30 WIB (from the clock): the repair, the last fixes, and where it stands at landing

*AI-written (Fable). Reports: `repair-review.json` (workflow `wf_a381e60a-001`) and `last-fixes-review.json` (workflow `wf_f3f3df73-b7f`).*

**The repair held, and found one more place where I said more.** After it, three readers found: `TurningInTime.rising_takes_all` is public and both laws rest on it with the bound `hi + 1`; `WayOfUnits` is 1,121 lines against 1,182 tracked, thirteen helpers removed that no proof used and no record names (one, `anyGoes`, is named in a sentence of the record `a-way-of-units`, to be re-said at landing). And: my brief had `need_unmet` carry the sentence "the way uses up what it rests on while nothing in it yet differs". Without `down` the unmet need can be a kid's greater need at a level that never fell (`a` needing one and leaving two `b`s that need thirteen, at twelve). So the sentence needs `down`. A reader's search: 80,216 of 519,621 small worlds without `down` have the level not fallen at the first unmet step; none of 318,594 with it.

**The last fixes.** `falls_to_unmet`: `need_unmet` with `down`, concluding also that some unit of the start way, whose need the start met, needs more than the level at the first unmet step, and that the level there is below the start level. `KidHigherNeed.all_but_down` keeps the case above. `ends_with_net` is now a case of the split it shared with `ends_with_net_rising`. The built examples' docstrings say that the laws add nothing about them. Two verifiers: the lock ready; the line ready after one docstring sentence was completed; sixteen wordings applied by the coordinating session, comments only (`buildR3-1.log`: every axiom report empty, no warning).

**Sizes at landing.** `TurningInTime` 3,092 lines (tracked 2,504); `LineOnAStock` 2,143 (new); `WayOfUnits` 1,126 (tracked 1,182); `LineOnAStockCases` 274 (new). One module got smaller; the whole is larger by about 2,900 lines.

**Frozen tests at landing.** A(3) still fires for the alikeness laws; B(2) is met by the letter only; C fires in part. The rest pass. [The note](NOTE.md) lists each with its theorem.

## 16 November, 07:00 WIB (from the clock): the texts that tell it, and the landing's first stop

*AI-written (Fable). Reports: files 7 to 10 in `readers/` (in scratch they were `texts-review.json`, `texts-verify.json`, `texts-confirm.json` and `landing-review.json`).*

**My telling failed again, before it was committed.** I drafted the plan's re-saying of steps 3 to 7, the direction page's findings and a page of questions for a case from outside, and sent the drafts to three readers while the landing ran. They found a dozen places that said more than the Lean, most by leaving out a premise, most often that offspring need no more than their parent, the premise the readers of the Lean had shown to be needed an hour before. Others: a given overdraw left unsaid beside "no overdraw asked"; "nothing reads the level" told as a result; two worked courses told as a law; the lock's law told as if it were inside this model. [The note](NOTE.md) had the last of these and is corrected. A second round found four clauses still wrong, one of them a premise I had put on the half of a law that needs none; a third reader then found two sentences my edits had made unreadable. A reader set to read as someone outside the work found errors the readers against the Lean did not: "is its draw growing?" would be answered yes by anyone whose case is growing now, where the theorem asks growth at every step, and a bound on steps in the model would be read as a forecast.

**The landing's first stop.** The registering texts, the record, the atlas entry with premise rows for five laws, and this folder were written on a branch and read by three; forty of their findings were applied; the core run passed with every axiom report empty (`20261115T233900.527774Z`). The render then refused: a new dynamic of the atlas needs a card on the map, and none was written. The reviewer of the branch also found the phrase "whose kids take no less than it" in four texts and in the module's own header, where the Lean asks it of the kids of the line. Both are repaired in a second run of the landing, with a second core run.
