# The missing links, tried on paper

*AI-written (Fable, holding the design; board row DJ), 16 November 2026, about 15:35 WIB. A working record, written before any reader of this round. Nothing here is proved and nothing is built. It follows `ONE-SPACE-ON-PAPER.md` beside it, whose try failed all three of its tests.*

## Why links

One more general model is not how the pieces join (the record beside this one). The atlas has 185 dynamics in 108 pieces, 86 of them alone. A reader of 16 November named ten links that would connect the most: four whose law is already in the Lean and has no entry in the atlas, and six that need a law. Ren asked for the meta-attractor (cancer), the generative and the continuation dynamics connected, with transitions and paths.

## What counts as a link (frozen now, before any reader)

A link between two dynamics counts only if all hold:

1. It is one theorem whose statement uses both sides' own definitions as they stand. No new structure is defined to carry it.
2. Its premises are premises the two sides already take, or fewer.
3. It would become false if either side's definition were changed in the respect it speaks of. Otherwise it is a renaming.
4. If it is a path from A to B, the law shows the leaving: from a configuration of A, under a stated premise, the course comes to a configuration of B.

It counts as nothing if: it is two existing theorems set side by side; one module is imported into the other only so that the statement can be written; or the "theorem" restates a definition.

A countermodel that shows two dynamics apart, where the map or a text reads them as one, counts as a finding and is kept.

## The links to try

Already in the Lean, no atlas entry (check that each law shows the leaving):

- `turning-in-time` to `margin-of-a-regime`, by `TurningInTime.unending_iff_above`.
- `closed-capture` to `turning-in-time`, by `TurningInTime.locked_ends_rising` (and `locked_ends_with_net_regime`).
- `capture-through-the-rule` to `closed-capture`, by `ClosedCapture.lock_outlives_loss`.
- `shaping-the-rule-selected-by-what-comes-back` to `capture-through-the-rule`, by `RuleShaping.covering_locks`.

Needing a law:

- **Cancer and the line.** `a-line-on-a-stock` with `confined-rise-within-a-whole` (`Founding.Flow.ConfinedRise.ends` against `LineOnAStock.line_ends`, `need_unmet`): does a closed line whose successors together take more meet the confined rise's premises, so that its excess need not be given? And `a-line-on-a-stock` with `where-a-rising-take-ends`.
- **How a lock forms, then ends.** `RuleShaping.covering_locks`, then `TurningInTime.count_rises`, then `locked_ends_rising`: a loop that comes to lock on a level with a ceiling ends locked.
- **Loss for good and unceasing arising.** `loss-of-renewal-for-good` with `unceasing-generation-needs-renewal`: below the need for good, arising is not unceasing.
- **The regime in the root's language.** `margin-of-a-regime` with `never-leaving-a-guard` (the kernel of "the need is met" is exactly the levels from `H + y` up to `hi`), and with `threshold-in-the-state-plane`.
- **A rule rebuilt from its members, as a pair.** `a-rule-rebuilt-from-the-members-it-limits` with `turning-in-time`.

## Not in this try

Any Lean. Any tracked change, the atlas included. A new view of the map.

## 16 November, 16:05 WIB (from the clock): what the links try found

*AI-written (Fable). Three seats and one refuter, read-only; reports in `links-try.json` beside this file (workflow `wf_ce1f1c8f-7a6`). Searches by script are not proofs.*

**Of the ten links, two are paths the Lean already shows.**

- `shaping-the-rule-selected-by-what-comes-back` to `capture-through-the-rule`, by `RuleShaping.covering_locks`: where what comes back to the shapers alone is read monotonically from their share and covers the cost at every share, a course from a rule covering the cost is locked from the step after its first reading step. Sufficient. It shows the leaving (a worked course is not locked at steps 0 to 2 and locked from 3).
- `turning-in-time` to `margin-of-a-regime`, by `TurningInTime.course_turned` with `unending_iff_above`: from the step after the first marked level the pair's level is the regime's own run under the kept kind's take. Sufficient; the turn is a premise.

**Two more are true and are not paths.** `capture-through-the-rule` with `turning-in-time` is a joining (`locked_ends_rising`: the lock's share, rule and step count read as the pair's way), not an exit: the start is already a pair, and the rise of the use is a free premise. `closed-capture`'s `lock_outlives_loss` is a case of `RuleCapture.locked_stays`, carried by `join_course`: it shows staying.

**Closed capture and the lock on a stock are two models of one lock, not a path.** The way is shared; the levels cannot be one (at nothing, closed capture's loss still grows by at least one, and the regime's step gives nothing from nothing).

**One small law is worth building.** Below the gate, uptake does not recur: `Flow.below_ends_uptake`, about twelve lines from `stays_below`, `given_zero_below` and `uptake_needs_replenishment_from`. It joins `loss-of-renewal-for-good` with `unceasing-generation-needs-renewal`. My sentence for it was false as written ("below the need for good, arising is not unceasing"): a dependent of lower need that takes nothing arises for ever below its renewers' need. It holds of uptake, not of arising.

**Apart, or renamings.**

- *Cancer and the line: apart, both ways.* `Founding.Flow.ConfinedRise.ends` is a lineage ending with a whole whose conditions fall below their gate and do not return. `LineOnAStock.line_ends` is a line ending alone, on a stock that can recover while other units go on. Countermodel `C`: kinds `a`, `b`, `c` need 17, use 1, 2, 3, kids `[b]`, `[c]`, `[a, a, a, a]`; `O` needs 1, uses 1, leaves itself; giving `min z (17 − z)`; from `([a, O], 17)` the levels run 17 five times, 16, 6, 10, 17, the line is gone from step 6, and `O` goes on. "Kids together take more" and "selection within goes for it" are also apart (world `B`).
- *The regime's kernel* is `ends_iff_below` with both sides negated: a renaming. *`ends_iff_below` is not a case of `leading_exact`*; the docstring at `RegimeMargin.lean:1548` over-says. The join that exists runs the other way (`threshold_regime`).
- *A rule rebuilt from its members* is a pair only as every function is; it gives before it takes.
- *The composition from a lock forming to a lock ending* does not go through `count_rises`: on the carrier counts a tie favours and moves nothing, and the ending there takes no lock.

**The map's numbers** (the refuter's script; an exit naming a dynamic, a case whose general law another dynamic lists, or a joining): now 185 dynamics in 108 pieces, 86 alone, the largest 30. With the two exits, the joining and the case: 104, 84, 40. With the one law built: 103, 84, 49. Counting only links that a law carries, the piece that holds `turning-in-time` goes from 2 dynamics to 12. The confined rise stays alone throughout.

## A lead from it, searched by me, not proved (16:05 WIB)

The cancer seat argued by hand that what decides whether a growing line takes everything with it is the order of needs. I searched it (`coordinator/takes_the_whole.py`).

*Statement.* A closed line of one need `m > 0`, each of whose units has kids of the line that together take more than it; nothing given from nothing; the step under no take keeping levels up to `hi` within `hi`; a start at most `hi` with a unit of the line in the way; and **every unit outside the line needing at least `m`**. Then within `hi + 1` steps no need is met: the line ends, and everything ends with it.

*Search.* 2,658 random small worlds meeting the premises: all ended within `hi + 1` steps (latest at step 5). Where some outside unit needs less than `m` (1,394 worlds), 10 went on for ever; world `C` above is the clean case, where the rest goes on and the stock recovers.

*Why it would hold.* While the level meets `m` the line is met and its take rises by at least one a step (`rise`); the level cannot pass `hi` (`kept_within`); so within `hi + 1` steps the level is below `m`; and then no unit's need is met.

*What it would be.* The first statement here with "it ends the whole it is in" as a conclusion, and a stated condition for it: nothing else can live below the line's need. With world `C` beside it as the kept countermodel: a line that needs more than the rest blooms, crashes, and the rest recovers. In the model's own terms, with no new structure. It is `line_ends` strengthened under one more premise; it does not join the confined rise.

## 16 November, 16:35 WIB (from the clock): a third try, written before its readers: the regulation family

*AI-written (Fable). Nothing here is proved or built.*

**Why.** Ren, 16:11 and after: a boundary is drawn and belongs on the map; value and boundaries emerge from higher-order structures and dynamics, for example the brain of an animal, or a microcontroller running a PID that maintains one or a set of feedback loops; in such a system values and the identification of signals emerge and can be understood. It is not an either-or between what the thing does and what a describer draws.

**What I found by reading headings only** (so: to be checked). The Lean has had this since October, unjoined to this month's centre:

- `Regulation.lean` (19 October): a level regulated towards a set level `m`, the joint exchange opposing departure on both sides; the bound that is exactly no overshoot; settling at `m`; overshoot that oscillates for ever; a rule reading `ℓ` steps late keeps no band narrower than `2(ℓ + 1)d`.
- `SetPointOptimum.lean` (26 October): an order greatest at a set point of what couples in, "a point of enough", against `Optimum`'s orders that rise with what couples in.
- `Boundaries.lean` (11 October), written on Ren's words of 10 October that a centre's boundary is "also with in the same cognitive system": a boundary of a formation's self is any region that holds it and is closed under the relation; the closure is the least and the whole the greatest.
- A thermostat witness (`overshooting-thermostat-alternates`); `Restoration`, `Reserve`; in the atlas `two-sided-regulation-and-late-reading`, `what-a-set-point-optimum-does-beyond`, `formed-goal-revision-continuation`, `a-reader-rebuilt-from-its-stock-ends-with-it`.

**The guess.** A loop that holds something is where a value and its distinctions are: what it holds is its value, what it reads is the signal it identifies, and the departure it opposes is the boundary it draws. Then the lock would be a loop whose set level is set from its own result; a reading in time would be regulation that does not read too late; and a selection with a point of enough would not overdraw where one that rises with what comes in does.

**The links to try, by the same four conditions as above.**

1. *Reading late.* `Regulation`'s law on a rule that reads `ℓ` steps late, with `TurningInTime`'s first reading before the point of no return. One question in two models: is there a theorem that names both?
2. *Holding as regulating.* Two-sided regulation towards `m` (`Flow.Opposes`, `Flow.WithinGap`, the settling laws) with the regime's holding levels and `LineOnAStock.Holds`: is a level the regime holds a regulated level, and is `m` then a fixed level of the step?
3. *A reader that needs what it reads.* `a-reader-rebuilt-from-its-stock-ends-with-it` with the lock on a level and with `need`.
4. *Enough, against more.* `SetPointOptimum`'s orders nearing a set point with `Optimum`'s rising orders, the lock (`RuleCapture`: a rule that favours a rising share) and the growth laws: does a selection with a point of enough hold where a rising one overdraws, as a theorem naming both; where does joint excess still end it.
5. *A boundary drawn by the loop.* `Boundaries.Boundary` with the closed regions of the centre (`TurningInTime.locked_closed`, the levels from which a standing take holds): is the lock a boundary in that module's sense by a definition unfolded (then: a renaming, or does `Boundaries` say something of it: least, greatest, only the whole).
6. *A value that comes to be.* `formed-goal-revision-continuation`: what is proved there of a goal formed by feedback and revised, on what carrier, and whether anything joins it to a set level or to the lock.

Counted as nothing, as before: two theorems side by side; a statement that restates a definition; a link that needs a new structure.

## 16 November, 17:25 WIB (from the clock): what the third try found

*AI-written (Fable). Two seats and one refuter, read-only; reports in `regulation-links-try.json` beside this file (workflow `wf_e101dc0c-e27`). The refuter checked each line of what the October modules say against the statements. Searches are not proofs.*

**None of the six is a link.** No statement joins regulation, set points or boundaries to the lock, the level or the line by a law.

**Three of my guesses were wrong.**

- *"A selection with a point of enough holds where one that always wants more overdraws."* False both ways, by October's own theorems. An order that rises with what couples in, re-optimizing at every step, keeps a condition for ever exactly where its draw is within the renewal (`Optimum.course_kept_iff`). An order nearing a set point drains like a rising one below the set point, and has a draining optimum at it (`SetPointOptimum`). Holding is decided by the draw against the renewal; the shape of the order decides only how much is drawn.
- *"The lock is a loop whose set level is set from its own result."* The lock holds a closed region of share and rule, and no level; its share only rises. A reader that needs what it reads (`ReaderRebuilding`) and the lock are apart: the lock's rule reads the share, and the level it uses makes no difference to it.
- *"A reading in time is regulation that does not read too late."* Apart. Regulation's lateness is a delay on a record; turning in time is about the levels at which a way responds. A held level is also not a regulated level: the matched heater's room stays at three, and nothing there opposes departure towards four.

**The lock as a boundary** in `Boundaries`' sense is a renaming: that module's boundary is any region closed under a supplied relation, and it holds alike of the locked region, the levels a standing take holds, the levels below, and the whole. **A goal formed from feedback** is in the periphery only, on a finite construction with no level.

**What the Lean holds today of Ren's point** (the refuter's words, checked against the statements):

- *The value a loop holds* is a number handed in (`m` in `Regulation`, `s` in `SetPointOptimum`), or a field of a rule (the heater's `m`, the reader's set level), or computed (the band `RegimeMargin.holds` keeps; and in the lock the rule, set again from the share at each reading step).
- *The signal* is an object as `Regulation.ReadsLate` and as the window's levels and schedule. `ReadsShare`, `marked` and `AloneOutside` are premises.
- *A boundary* is proved in two places: the point of no return of a standing take, and the locked region. `Boundaries.Boundary` is any region closed under a supplied relation, and nothing there draws one. It does have "true however the boundary is drawn", "true as it is drawn somewhere" and invariance across drawings, for claims about a self.
- A slower loop setting what a faster one holds is `Pace.paced`. In the core no set level stands in its rule's place.
- Nowhere does a set level, a mark or a lateness come to be from the dynamics. No module has all three of a value held, a signal read, and a need of what is read: `Regulation` lacks the need, the centre lacks the set level, the reader lacks the lateness.

**Small things that are true** (not links): the thermostat's rooms are the regime's step by `Rooms.next_open` and could be entered in the atlas as a case of the regime; the two-level course (`Pace`) has a record and no dynamic; the reader under a cut ends (`cut_ends`, a law of one dynamic, about fifty lines, searched on 23,760 starts).

**The same finding a third time.** What is handed in is what is missing: the need, the mark, the offspring, the order, the set level.

## A fourth try, written before its readers (17:30 WIB): a value that is held, and set again

*AI-written (Fable). Nothing here is proved or built. The lead is the refuter's (a set level in the place of the two-level course's rule, by search only); the small probe is mine (`coordinator/held_value.py`, one giving, one start take: a probe, not a proof).*

**The guess.** Put a set level where `Pace.paced` has its rule. A fast loop holds a take: at each step the take moves towards the set level and not past it (`Regulation.Between`, nearer). The stock steps by the regime under that take (`RegimeMargin.step`). At reading steps the set level is set again. Three sources, everything else the same:

- *held fixed*: the regime under a standing take, once the take has reached it;
- *set again from the take itself, above it*: what is held recedes as it is approached;
- *set again from what the stock gave*: what is held follows what it rests on.

**The probe** (tent giving `min z (12 − z)`, need one, start take three): fixed at three, it goes on from six up and ends below; set from itself, it ends from every start, and reading less often only delays it (step 11 against step 17); set from the stock, it goes on from six up, settling at a take of six on a level of twelve.

**What would count as something** (frozen now). All of:

1. One theorem in which only the source of the value differs gives different fates from one start: a premise on how the value is set again, not on the course.
2. The lock's ending comes out as a case with a premise derived: `count_rises`'s `rise` and `count`, or `locked_ends_rising`'s `more`, follow from "set again above the take" and "the take moves towards what is held". Or a countermodel shows the lock is not this.
3. A law older than 12 November becomes a case by a definition unfolded (candidates: `Regulation`'s settling laws for the fast loop; `Pace.rule_until_reading` or `Pace.pace_law`; `RegimeMargin.holds` for the fixed value).
4. No new structure: the definitions are `Pace.paced`, `Regulation.Between` and `RegimeMargin.step` as they stand, at chosen types.

**It counts as nothing if** the ending under "from itself" is `rising_takes_all` with the rise restated; if "from the stock" hands the stock's giving to the reading in a way that makes holding true by definition; or if the three sources need three models.

**Questions to answer.** For a value set from itself: does it end from every start under any schedule that reads without end, and what bounds the step. For a value set from the stock: the exact condition for going on, and what a late or sparse reading does to it (is this where `Regulation`'s lateness and `TurningInTime`'s "in time" meet, or are they still apart). For a value with a top (set again above the take but never above `s`): is it the fixed case from the step the top is reached, so that "enough" enters as a bound on how the value is set again and not as an order. Which of need, signal and value are then objects, and which are still handed in.

## 16 November, 17:55 WIB (from the clock): what the fourth try found

*AI-written (Fable). Two seats and one refuter, read-only; reports in `held-value-try.json` beside this file (workflow `wf_dfa3b0ce-429`). Searches are not proofs; the lemmas named are argued, not checked.*

**As a join it fails.** Tests 1 and 4 are met by construction, test 2 only by its countermodel branch, test 3 not at all. Nothing handed in comes to be.

- *One model, by definition only.* The guess is `Pace.paced` at chosen types, with strict nearing added and the order of taking and reading left open. "Only the source of the value differs" is true of the definition and empty as a law: the three fates come from three arguments (the regime's point of no return after the take arrives; the take reaching the top of the level; a conservation that holds in one order of reading).
- *The lock is not a value set again from itself.* The lock ends without ever reading: its share runs away under a rule that stands. The guess, never reading, goes on. `count_rises`'s premise contradicts `Regulation.Between` at equal take and value, so no premise on the setting can give it.
- *"Set again from the stock" is true by how it was built, and is not a holding.* With the take set to what the stock just gave, every amount left is a rest by substitution. No rest opposes departure: of sixteen one-unit changes at rests none returns, and one unit lost ends it at each of the six rests on the tent's rising side. Its fate depends on the order of reading (reading after the step flips 175 of 1,183 starts). Against a fixed value it is never worse on tents and refills, and worse on other givings.
- *My probe sentence over-said.* "Settling at a take of six on a level of twelve" was one of the probe's four printed courses (reading every fourth step from nine). Reading every step from nine it alternates takes of three and four.
- *No old law becomes a case.* Each is used as it stands.

**What survived** (argued on paper; 40,000 random moves, sources, givings and schedules, in both orders of taking, none against; each premise needed):

- *A value that every reading sets above what is taken ends the stock.* On `Pace.paced` at take, level and held value: the take moves between itself and the value and strictly nearer; every reading sets the value above the take; a reading comes in every `L` steps; nothing is given from nothing; with nothing taken a level up to `hi` stays within `hi`; the start is within `hi`. Then the level is nothing by step `(2·hi + 1)·L`, at any pace of reading and whatever else the reading reads. So a course that lasts has a reading that sets the value at or below the take. Without the bound `hi` it is false (giving `z`: the level outruns the take).
- *Under it, one lemma for two endings.* A use of at least `hi` at step `n` leaves the level nothing at step `n + 1`. `rising_takes_all` is its case, and so is the ending above. The refuter: build it only if the lines do not rise.
- *A top.* A value set above the take but never above `s`: the region (value = `s`, take within reach of `s`) is kept, and inside it is the fixed case at `s`. On the tent, tops one to six go on from every start level and seven to twelve end from every one. The top is handed in.

**What it would add for Ren's point, and what it would still hand in** (the refuter's words). It would put the value a loop holds in the state, its course derived, in the centre's own pair. It would still hand in what is read and what is made of it, the order and the schedule, the need, the bound on the level and the top. In a seat's words: it moves what is handed in one level up, from the number to the reading that sets it; the loop hands a value back and does not form one.

## What the four tries of 16 November add up to (17:55 WIB; my reading, not a result)

Each time something handed in was moved into the dynamics, what sets it was handed in one level up: the need; then the take; then the value held; then the reading that sets the value. No model made a value come to be. What could be proved at each level was of one kind: which ways of setting can last, and which end (a take that rises against what the stock can hold; a value set above the take at every reading). The one place in the Lean where the loop closes is the lock, where the rule is set from the share and the share is moved by the rule.

If that is the shape, then there is no top level from which a value is derived, and "a value emerges" would mean: of the ways a value can be set, those that end are gone. That is selection again, one level up. And the map would be one by one law holding at each level, and not by one flat model. This is a guess. No reader has been sent after it.

## 16 November, 18:38 WIB (from the clock): three of the surviving statements, proved in scratch and read

*AI-written (Fable). Three writers, each in its own scratch tree, and one reader each who did not write it (workflow `wf_033a2110-490`; reports in `scratch-proofs.json`; the modules and their build logs copied to `scratch-lean/` beside this file, the working trees in `/Users/ren/tmp/dj/batch17/`). Each module passed the focused scratch build with no error or warning and an empty axiom report for every declaration; I read the three logs myself. No core run, gate or suite was run. Nothing is on main and nothing tracked changed.*

**1. A growing part, and nothing else needing less** (`ScratchTakesTheWhole.lean`, 732 lines, 35 theorems). On the model of `LineOnAStock`: let `S` be any decidable set of units and `m` above nothing. Given that every unit of `S` needs exactly `m`; each unit of `S` has kids of `S` that together take more than it; every unit not of `S` needs at least `m`; nothing is given from nothing; the step under no take keeps every level up to `hi` within `hi`; the start level is at most `hi`; and a unit of `S` is in the start way. Then there is a step `n` at most `hi + 1` with the level at least `m` at every step before it and below `m` at it, and no need is met there, so the net ends (`takes_the_whole`).

- Closure of `S` is not needed for the ending.
- Not concluded: that it is `S`'s take that brings the level below `m` (a start below `m` gives `n = 0`), that the level is nothing or stays low, or that the condition is exact.
- Three premises are shown needed, each by a proved world where the others hold and the net never ends: a unit outside that needs less (world `C`: the growing part is gone from step 6, the other unit goes on, the level is back at seventeen from step 8); no unit of `S` at the start; kids that take the same in place of more.
- **My sentence was wrong.** I wrote that this would be "the first statement here with 'it ends the whole it is in' as a conclusion". `way_ends` and `one_need_ends` already conclude that the whole net ends, where the growing part is everything. What is new is a law for a part among other units.
- The reader: a law inside one dynamic (`a-line-on-a-stock`); it joins nothing. `one_need_ends` follows from it as a corollary, not as an instance, and `ends_all` is re-proved on its lemma, not a case of it. Landed whole it adds about 112 lines.

**2. Below the need of what gives to it, taking does not recur without end** (`ScratchBelowEndsUptake.lean`, 598 lines, 32 theorems). On October's flow: given, from a step `T` on, that the level of a condition after a step with what was taken is its level before with what was given; that whatever takes part and gives to it is supported there and depends on it at a need of at least `m`; and that at `T` its level is below `m`. Then from `T` on the level stays below `m`, nothing is given to it, and it is not the case that something is taken from it at arbitrarily late steps (`below_ends_uptake_from`). Over any `N` steps from `T`, all that is taken is at most the level at `T`.

- No last step of taking is exhibited. What is proved is that taking does not recur without end.
- It is of taking, not of arising: a worked model has every premise and a formation of lower need that takes nothing arising without end (its activity is set so, not read off its support).
- Each of five premises is shown needed by a worked model.
- The reader: **a link by one law**, between `loss-of-renewal-for-good` (`stays_below_at`) and `unceasing-generation-needs-renewal` (`uptake_needs_replenishment_from`). It is a composition of three laws already there, and an exclusion, not a path: an atlas exit would over-say it. Lines rise by about twelve. The head note drops the balance premise twice; the names say "ends" where the Lean says "does not recur".

**3. A held value that every reading sets above what is taken** (`ScratchReach.lean`, 777 lines, 20 theorems). On `Pace.paced` with a take, a level and a held value: given that the take after a move is never below both the take and the value, and rises strictly while below the value; every reading, at every configuration and value, sets the value above the take; every `L` steps in a row hold a reading; the level steps by the regime's step under the take; nothing is given from nothing; the step under no take keeps every level up to `hi` within `hi`; the start level is at most `hi`. Then the level is nothing at step `hi·(L + 1) + 1`, which is at most `(2·hi + 1)·L` (`set_above_takes_all`, `set_above_ends`).

- It holds in all four orders of moving the take and reading the value, so there is no countermodel for an order.
- Less is needed than the paper asked: the take may pass the value.
- Not proved: that the level stays nothing afterwards; anything about a need or a line.
- Six premises are each shown needed by a course in Lean that keeps the level above nothing at every step. One of them shows that some reading is needed, not that bounded gaps are.
- Under it, the reach lemma (a use of at least `hi` at step `n` leaves the level nothing at step `n + 1`), with `rising_takes_all` re-proved as its case. Lines do not fall: about 45 more in `TurningInTime`, and its one-step part is already `LineOnAStock.step_zero`. The refuter's condition for building it (only if lines do not rise) is not met.
- The reader: not a link between atlas dynamics. `Pace.paced` is on no atlas dynamic. It is a second case of the reach lemma beside `rising_takes_all`.

**By the map's own measure.** One link by a law (item 2). Two laws inside one dynamic each. One law on a carrier the atlas does not have. No old proof falls, and lines rise in all three. Writers 1 and 3 each wrote a generalisation of `rising_takes_all` (`rising_floor_takes_all`; `reach_levels`); a landing would keep one.

**What I would land, if Ren says so** (my judgment, 18:38 WIB): item 2 in its family-first form, as a joining and not an exit; item 3's held-value law with its six needed premises, as a small dynamic of its own whose general law is in `turning-in-time`, because it is the first law here about a value a loop holds; of item 1 only world `C` and the short law, without the re-proving of older laws. Not the reach section as written.
