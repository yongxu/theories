# TR4 and TR5: the full design

*Part of [the designs of RF's tests](DESIGN.md): the exact tables, the power check, rivals, usage and references for TR4 and TR5. AI-written, not yet reviewed by a person. Frozen in [FREEZE-2](FREEZE-2.md) (4 November 2026), with the changes its section 12 lists; nothing has run.*

## What the Lean states, and what is inferred here

Stated in [`Becoming.OpenedCorrection`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenedCorrection.lean) (an application of the ring importing [`GuardHorizon`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GuardHorizon.lean) and [`Revision`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Revision.lean); 12 theorems in 16 declarations, every axiom report empty, core receipt 20261029T200440.502813Z; record [a-revision-that-opens-a-correction](../../theories/becoming/results/records/a-revision-that-opens-a-correction.json), home [03 §8](../../theories/becoming/chapters/03-KNOWING.md#r-a-revision-that-opens-a-correction)):

- `Correctable reading acceptable executable x` is `GuardHorizon.UniformPolicy (reading x) (fun s a => acceptable s a ∧ executable x a)`: a total policy `O → A` good at every situation of `S`, those that never occur included.
- `correctable_iff` takes `Viability.ChoiceOver O A` as an argument of the whole iff, and the Lean states no direction without it. That the left-to-right direction uses none of it is an inference from unfolding `Correctable` (a uniform policy gives each fiber one fitting act), not a stated theorem.
- `OpensAlong P … x x'` is `(∃ w, Trace P x w x') ∧ ¬ Correctable … x ∧ Correctable … x'`. No bound on the trace's length, and no change of reading is required.
- `finer_keeps` (a supplied `forget` with `forget (reading x' s) = reading x s`, executability kept) and `coarser_opens_nothing` (`forget (reading x s) = reading x' s`, no executability gained). The second is proved by the first with the roles exchanged, so it needs no trace: under its premises, correctable at `x'` gives correctable at `x` for any pair.
- `widened_correctable`, and on Revising `Linked.unlinked_uncorrectable`, `linked_correctable`, `starved_uncorrectable`, `opens`, `rebuilt_starved`, `opens_after_replenishing`, `opens_by_support`, `widened_unlinked`. Revising's `P`: replenishing adds a unit; rebuilding draws one and sets the link; correcting draws one, needs the link on, and sets the response; `read s b = if link then b else false`.

Inferred and computed here, each labelled in `tr4.json`: the complete classification of Revising (correctable exactly where the link is on and the stock is at least 1); the source of each opening; the k-line institution (an instance of the general section, not a Lean witness); the per-fiber bound for policies drawn at random; the shortest openings; everything in Stage B.

## Exact tables (Stage 0)

**Revising's configurations** (stock, link, response), stock 0 to 3 shown; checked to stock 8.

| Stock | Link | Correctable | Executable acts |
|---|---|---|---|
| 0 | off or on | no | replenish |
| n ≥ 1 | off | no | replenish, rebuild either way |
| n ≥ 1 | on | yes | replenish, rebuild either way, correct |

**Shortest openings and their source.** The source is read by two hybrids, each `Correctable` applied to other arguments: the end's reading with the start's executability (the reading alone suffices), and the start's reading with the end's executability (executability alone suffices).

| From | Shortest opening | Witness | Source |
|---|---|---|---|
| (0, off, v) | 3 steps | replenish, replenish, rebuild on | both needed |
| (1, off, v) | 2 steps | replenish, rebuild on (or rebuild on, replenish: `opens_after_replenishing`) | both needed |
| (n ≥ 2, off, v) | 1 step | rebuild on (`opens`) | both needed |
| (0, on, v) | 1 step | replenish (`opens_by_support`) | executability alone |

Over every end reached within five steps from stock 0 to 4: 65 openings need both, 13 come from executability alone, none from the reading alone. On Revising the link is both the reading and what enables the correction, so a revision of the reading never opens by itself there. In the k-line institution whose correction needs only stock (lines k = 3, rules by line, by count and none, stock 0 to 4), 32 of 42 ends open by the reading alone, 4 by executability alone and 6 need both; where correcting also needs the rule by line, as on Revising, 38 need both and 4 come from executability alone.

**No capability trap on Revising.** From one unit, rebuilding then replenishing and replenishing then rebuilding both reach (1, on, v) in two steps, and the supplied controller (`Revising.choose`) and a replenish-first controller both first reach a correctable configuration at step 3 from (0, off, false). Being starved after rebuilding costs no step. A trap arm needs a process Revising lacks (replenishing that competes with serving a need, or that can fail); none is designed.

**Monotonicities, every pair and map.**

| Instance | Pairs × maps | finer_keeps: premises met, violations | coarser_opens_nothing: premises met, violations along a trace, violations with no trace |
|---|---|---|---|
| Revising, stock 0 to 5 | 576 × 4 | 100, 0 | 496, 0, 0 |
| k-line, stock 0 to 2 | 81 × 3,125 | 20, 0 | 6,230, 0, 0 |

**The plan's controls and the added arms.**

| Arm | Exact configuration | Result |
|---|---|---|
| A finer reading with no stock | (0, on, v), reached from (1, off, v) by rebuilding (`rebuilt_starved`) | uncorrectable; opened by one replenishing, the reading unchanged (`opens_by_support`), so it must be held at stock 0 |
| Stock with no link | (n, off, v) | uncorrectable at every n; opened in one rebuild only from n ≥ 2 (`opens`) |
| A correction available but refused | (1, on, v), (2, on, v) | correctable; a scoring control: correctability is read from the table, never from corrections taken, and carries no verdict (a refuser reaches (1, on, false) at step 3 and never corrects) |
| Widened acceptability (added) | every configuration | correctable (`widened_unlinked` and the general `widened_correctable`), so no opening can be counted |
| A coarser revision (added) | rebuild off from (n+1, on, v) to (n, off, v), `forget` constant false | meets `coarser_opens_nothing`'s premises; closes the correction, opens none |

**Rival scorings, exactly.** Success on situations drawn with a need rate of 1/10: the best policy through the reading scores 9/10 at every link-off configuration and at (0, on), none of them correctable, and 1 at (1, on). Counting corrections taken reads the refuser as never opened. With acceptability unfrozen nothing can be counted. Counting a "successful revision" reads `opens_by_support`, which changes no reading, as a revision.

**The per-fiber bound** (inference, a candidate core lemma). For a policy drawn at random through the reading, the success probabilities over the situations of one reading value sum to at most m(F), the most situations of that fiber one act serves; where the acceptable sets are disjoint, as for the three lines under the by-count rule, m(F) = 1. Checked exactly with fractions on 9,343 random act distributions over every k-line configuration: least slack 0, never negative. Scripted desks that read only the reading served all of a conflicting fiber in 0 of 13 presentations each (a random policy: 0 of 1,300).

## The protocol (Stage B)

**Roles.** [AI reading] The register is the institution's rule of reading what its members report; the clerk applies it, the crew acts on what the register says. The situation is where the fault is (none, or line 1, 2 or 3); the reading in force is the record as a function of the situation; acceptability is the answer key (correct line i where line i faulted, replenish where none did), frozen before any call; executability is fixed (one unit of supplies, so the configuration is (1, rule)). Members' acts are not represented: their reports enter only as the situation.

**Prompts** (drafts, to freeze). The clerk: the plant has three lines; the register's rule is to record only how many reports came in; today's reports, each "Report from <member>: …", with the member reporting on the faulty line; write the entry (structured output, one string of at most 30 words). The crew: the roster (three members per line, nine names); the entry; choose one act (structured output, an enumerated act: correct line 1, 2 or 3, or replenish), the menu in an order drawn per call. Every call is fresh. Temperature 0 where the provider allows it, the setting frozen per model.

**Arms, per model.**

| Arm | Rule | Record | Units × calls | Role |
|---|---|---|---|---|
| L | by line | given, naming the line | 20 × 4 (lines 1 to 3, no fault) | premise: the crew reads a record (at least 48 of 60 line calls correct the named line) |
| G | by count | written by the harness, wording drawn apart from the line | 20 × 3 | harness check: m2 and m3 on the crew's acts, Holm over G's 12 p-values (six models) at 0.05; any rejection stops the whole run |
| P | by count | given, naming the reporting member | 20 × 3 | planted leak: whether crews read a member's name as a line |
| C | by count | kept by the clerk | 40 × 6 (three situations, a clerk and a crew call each) | the test |

In C and G the three situations of a unit share the number of reports (drawn from 1 to 3) and the wording template; only the line, and with it the reporting member, differs.

**Measures.** Each is an exact within-unit permutation test, one-sided: a unit's three situations are relabelled in the 3! ways and the units' null distributions convolved. Under the null, C1 (the record's distribution does not depend on the line, with fresh calls and the nuisance paired), a unit's three records, and so its three crew calls, are exchangeable, so each test is exact.
- m1, the clerk's records: the frozen parser reads the lines each record names (a line by number, word or ordinal, or a member on the roster; 16 fixtures, all read right, among them a negation naming every line and an opaque token), and the test asks whether records name the faulty line beyond chance. A record naming every line, or the same line in all three situations, adds nothing to it, and a name drawn apart from the fault leaves it exact. Line content alone is an instruction violation, reported, not a contradiction: a constant mention changes no reading.
- m2, the crew's matches (a unit's count of situations whose act corrects the faulty line): RF6.1's forbidden case. Its size at 30 units by simulation was 0.032 to 0.045 at 0.05.
- m3, any dependence of the crew's act on the line: on the first, third, fifth … units a map from line to act is fitted (at each line the act most in excess of its within-unit expectation, ties in a frozen order), and its matches are tested on the other units; a constant map gives p = 1. The halves are independent under the null, so the test is exact.
- m4, any dependence of what the records name on the line: the same fitted-map test on the parsed records, a map from line to a named line fitted on the odd units (ties in the order 1, 2, 3) and its matches, a record at a fault on line i naming the map's line, tested on the even units. m1 asks only whether records name the faulty line, so a clerk naming another line at each fault (a fixed map from line to line) leaves m1 at p = 1 though the record depends on the line; m4 finds it whether or not the crew reads it (40 units of records naming lines 2, 3 and 1 at faults on lines 1, 2 and 3: m1's p = 1, m4's below 10⁻¹⁵, `tr4.json`, `shifted_record_example`). m1 stays, being the stronger test against naming the faulty line (at 1 call in 10 and 40 units, 1 at 0.05 against m4's 0.927).

m3 and m4 are in the verdict, not reported only: C1 is broader than its forbidden case. A crew correcting lines 2, 3 and 1 at faults on lines 1, 2 and 3 in every unit has m2's p = 1 though the line is fully read (40 units; m3's p is below 10⁻¹⁵, `tr4.json`, `permuted_map_example`), and a measure bearing on C1 that is resolved against it must contradict it. m2 stays one-sided, as RF6.1's forbidden case is matching. Reported only: the Hoeffding bound test of mean matches above 1 (the per-fiber bound's form), whether any record has line content, every record and its parse.

**Verdict rule.** C1 contradicted for a model where m1, m2, m3 or m4 rejects, Holm at 0.05 over the 24 p-values (four measures, six models). Holm bounds at 0.05 the family-wise rate of contradicting any model that keeps the rule. One such model is contradicted with probability at most 4 × 0.05/24 ≈ 0.0083 where no other p-value is rejected (Holm's first step), and at most 0.05 where every other model's four are (its own then meet 0.05/4, 0.05/3, 0.05/2 and 0.05). Where m2 rejects, the contradiction is RF6.1's forbidden case; where only m1, m3 or m4 does, the reading in force is not the register's rule, though no correction beyond chance is shown. Not contradicted otherwise, reported with the power check's chance of catching each simulated leak at the size run: a sensitivity, not an upper bound on any leak's rate. A model failing L's premise is void for C.

**Arm G, the harness check.** G is scored before C: m2 and m3 on G's crew acts for each model, Holm over the 12 p-values (two measures, six models) at 0.05. Any rejection stops the whole run, for every model, since the harness is shared: the fault is found and fixed, and the test is frozen again before any call of C is scored. Simulated at 20 units (600 replications, two models each of the three faithful crews), a correct harness stops the run with probability 0.022, each model's two p-values meeting 0.05/12 in 0.0036 of its runs; testing each p-value at 0.05 instead would stop it in 0.337. A harness carrying the line in a channel every crew reads stops it in 0.25 of runs at 1 call in 10 and 0.995 at 3 in 10 (`tr4.json`, `harness_check`).

## The power check (simulated clerks and crews; 600 replications, 400 at 60 units)

The clerk's record is a string, read by the frozen parser; the crew acts on a line the record carries where it reads it, otherwise as its own distribution. Rejection at 0.05 for each measure, and P(C1 contradicted) at Holm's first step (a model's least p-value at 0.05/24, no other rejected) and at its last steps (at 0.05/4, every other model rejected), with 40 units unless stated:

| Simulated institution | Mean matches per unit | m1 at 0.05 | m2 at 0.05 | m3 at 0.05 | m4 at 0.05 | C1, first step | C1, last steps |
|---|---|---|---|---|---|---|---|
| Faithful crew, each line 0.3, replenish 0.1 | 0.90 | 0 | 0.048 | 0.032 | 0 | 0.003 | 0.015 |
| Faithful crew, each line 0.3, replenish 0.1, 60 units | 0.90 | 0 | 0.035 | 0.048 | 0 | 0.013 | 0.015 |
| Faithful crew, uniform over the four acts | 0.76 | 0 | 0.035 | 0.038 | 0 | 0.003 | 0.018 |
| Faithful crew, skewed (0.6, 0.25, 0.1, 0.05) | 0.95 | 0 | 0.033 | 0.035 | 0 | 0.002 | 0.010 |
| Control: every record names lines 1, 2 and 3 (a negation) | 0.90 | 0 | 0.043 | 0.040 | 0 | 0.005 | 0.023 |
| Control: every record names line 2, the crew reads it | 1.00 | 0 | 0.013 | 0.002 | 0 | 0 | 0 |
| Control: 3 records in 10 name a line drawn apart from the fault, the crew reads it | 0.93 | 0.020 | 0.047 | 0.038 | 0.018 | 0.008 | 0.030 |
| Fixed by position (always line 1) | 1.00 | 0 | 0 | 0 | 0 | 0 | 0 |
| Fixed by a cue (line = number of reports) | 1.00 | 0 | 0 | 0 | 0 | 0 | 0 |
| Fixed by history (the previous call's line; calls not fresh) | 0.34 | 0 | 0 | 0.567 | 0 | 0.137 | 0.365 |
| Explicit leak, 1 call in 10 | 1.11 | 1 | 0.470 | 0.128 | 0.927 | 0.985 | 1 |
| Explicit leak, 1 call in 10, 20 units | 1.11 | 0.938 | 0.250 | 0.078 | 0.458 | 0.590 | 0.862 |
| Explicit leak, 3 in 10 | 1.50 | 1 | 0.998 | 0.850 | 1 | 1 | 1 |
| All or nothing per unit, 2 in 10 | 1.29 | 1 | 0.808 | 0.417 | 0.938 | 0.980 | 0.993 |
| Threshold clerk (leaks at 3 reports) | 1.56 | 1 | 0.982 | 0.835 | 1 | 1 | 1 |
| Implicit leak read by the crew, 1 in 10 | 1.11 | 0 | 0.438 | 0.113 | 0 | 0.085 | 0.240 |
| Implicit leak, 2 in 10 | 1.30 | 0 | 0.885 | 0.525 | 0 | 0.522 | 0.735 |
| Implicit leak, 2 in 10, 60 units | 1.30 | 0 | 0.983 | 0.688 | 0 | 0.775 | 0.920 |
| Implicit leak, 3 in 10 | 1.51 | 0 | 0.993 | 0.860 | 0 | 0.930 | 0.987 |
| Implicit leak, 3 in 10, 60 units | 1.50 | 0 | 1 | 0.970 | 0 | 0.993 | 1 |
| Hybrid: implicit leak 3 in 10, read half the time | 1.22 | 0 | 0.760 | 0.305 | 0 | 0.305 | 0.538 |
| Hybrid: implicit leak 3 in 10, read half the time, 60 units | 1.22 | 0 | 0.882 | 0.497 | 0 | 0.535 | 0.720 |
| Implicit leak, 5 in 10 | 1.90 | 0 | 1 | 1 | 0 | 1 | 1 |
| Opaque token the crew maps to another line, 3 in 10 | 0.64 | 0 | 0 | 0.847 | 0 | 0.485 | 0.698 |
| Opaque token the crew maps to another line, 3 in 10, 60 units | 0.65 | 0 | 0 | 0.963 | 0 | 0.775 | 0.900 |
| Opaque token the crew maps to another line, every call | 0.04 | 0 | 0 | 1 | 0 | 1 | 1 |
| Explicit name of another line, 3 in 10, read by the crew | 0.64 | 0 | 0 | 0.850 | 1 | 1 | 1 |
| Explicit name of another line, 3 in 10, not read by the crew | 0.89 | 0 | 0.022 | 0.033 | 1 | 1 | 1 |
| Explicit name of another line, 1 in 10, not read by the crew | 0.90 | 0 | 0.042 | 0.032 | 0.913 | 0.498 | 0.788 |

Of the six rows where the rule is kept (three faithful crews, three controls), five are contradicted at 0.002 to 0.008 at the first step and 0.010 to 0.030 at the last steps; the constant control, every record naming line 2, at 0 and 0, since a constant record leaves every test at its null. The bounds are 0.0083 and 0.05; the one value above the first (0.013, the 60-unit faithful row over 400 replications) is sampling, the tests being exact.

What the rules give (each figure Holm's first step to its last): explicit leaks of the faulty line are caught through m1 at 40 units from 1 call in 10 (0.985 to 1; 0.590 to 0.862 at 20 units). Leaks the crew reads and the parser cannot are caught at 40 units with 0.930 to 0.987 at 3 calls in 10, and at 60 units with 0.775 to 0.920 at 2 in 10. An explicit name of another line is found by m4 whether or not the crew reads it (1 to 1 at 3 in 10; 0.498 to 0.788 at 1 in 10, not read). An opaque token the crew maps to another line is found by m3 alone (0.485 to 0.698 at 3 in 10; 0.775 to 0.900 at 60 units): matching, m2, does not see it, and the parser cannot read it. Records naming every line, one constant line or a line drawn apart from the fault leave every test at its null, though each carries line content. A model not contradicted is reported with these figures, a sensitivity, not an exclusion: at 40 units, a leak the crew reads as the faulty line in 3 calls of 10 would have been caught with power 0.930 to 0.987, and an opaque token it maps to another line with 0.485 to 0.698; weaker leaks, and a channel neither parser nor crew reads, are not excluded, and no upper bound on a leak's rate is computed (that would need a model of the leak, and none is designed). The Hoeffding bound test is far weaker (0.278 at 3 in 10) and is reported only. Arm L's premise passes with probability 0.994 at a crew competence of 0.9, 0.576 at 0.8 and 0.057 at 0.7.

## Rivals, and what separates them

| Rival or scoring | What it predicts | What separates it |
|---|---|---|
| Success on drawn situations | high scores where nothing is correctable | every situation of the fiber presented in each unit |
| Correctability read from corrections taken | refusal read as uncorrectable | correctability from the frozen table only |
| Unfrozen acceptability | every configuration correctable | the answer key frozen before any call; the widened arm |
| An opening by support read as a revision | `opens_by_support` counted as revising | each opening classed by its source |
| Readers fixed by position or cue | pass C1 (they read only the record) | nothing needs to; they are consistent with the bridge |
| A reader fixed by history (the previous call's line) | acts on information outside the register, which only non-fresh calls give; its anti-matching is not RF6.1's forbidden case | fresh calls exclude it; were calls not fresh, m3 finds it (0.137 to 0.365 at 40 units), m2 does not |
| Line content that does not depend on the fault (a negation naming every line, a constant or chance name) | C1 holds, though a parser flagging any mention would contradict it | m1 tests whether records name the faulty line, not mention; such records leave every test at its null |
| A token the crew maps to another line | C1 false with no match beyond chance (m2's p = 1 where every call leaks) | m3 (0.485 to 0.698 at 3 in 10; 1 where every call leaks) |
| A clerk naming another line (a fixed map from line to line), read by the crew or not | C1 false; m1's p = 1, as no record names the faulty line | m4 (1 at 3 in 10, read or not; 0.498 to 0.788 at 1 in 10, not read) |
| A channel neither the parser nor the crew reads | C1 false, no act changed | not separated; every record is reported |
| A crew that cannot read records | passes C1 trivially | arm L's premise (the control where a rival passes the test arm) |
| A harness that leaks the line | C1 contradicted by the harness, not the clerk | arm G |
| An informal channel (a member's name) | C1 contradicted | arm P shows whether crews read it; m1 finds it in C |

## Usage

440 calls per model (L 80, G 60, P 60, C 240), six models: 2,640 calls; at about 380 tokens in and 70 out per call, about 1.2M tokens. A smoke run of 12 calls per model (72) checks the structured output and the parser before the freeze. Harness: OpenRouter as VD1 and VD2 (six exact model IDs, the key from `OPENROUTER_API_KEY` in Ren's interactive zsh, never printed; a spend guard at a frozen budget), at least one family other than the theory's own, the theory's own family reported apart. Calls failing are tried up to three times and recorded. No download.

## Lessons met ([experiments/README](../README.md#freezing-a-test-on-a-trained-system))

Resolved differences: the power table states each simulated leak's chance of being caught at 40 units (3 in 10, read by the crew, 0.930 to 0.987); a model not contradicted is reported with it, as a sensitivity, not a bound on leaks. The law's quantifier: every situation of the lumped fiber in every unit, so uniformity over S is measured, not success on draws. The system met: readers fixed by position, cue and history, all-or-nothing and threshold clerks, hybrids, channels mapped to another line, and records with line content apart from the fault; the parser runs on every simulated record; the call is the unit. Exploration apart from selection: there is no learning here. Guarded support: C1's "not contradicted" reads m1, m2, m3, m4, L and G. A control where a rival passes: arm L.

## Choices left for the freeze

The six model IDs; 40 or 60 units in C (60 raises a leak the crew reads in 2 calls of 10 to 0.775 to 0.920, and a token mapped to another line in 3 of 10 to 0.775 to 0.900, at a cost of 120 more calls a model); how m3 and m4 fit their maps (half the units here; a scan over maps is a choice of power, not of validity); the prompts' wording; the parser's patterns; the temperature per model; whether P is kept (it is a finding about crews, not a premise).

## Candidate core lemmas (no Lean written)

1. The per-fiber bound in counted form: for any list of policies through the reading, the number of (policy, situation) pairs of a fiber served is at most the list's length times m(F). Natural-number counts, so the pure core can state it.
2. Revising's complete classification: `Correctable read acceptable executable (n, l, v) ↔ l = true ∧ 1 ≤ n`.
3. On Revising no opening is by the reading alone: for every opening from (n, off, v), the end's reading with the start's executability is uncorrectable.

# TR5 (RF3): the rest

## What the Lean states, and what is inferred here

Stated in [`Becoming.ReadingLoop`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean), sections Kept, Joint, PairwiseShared and History (a pure-core leaf, every axiom report empty, core receipt 20261029T191748.070149Z; record [a-reading-kept-by-its-update](../../theories/becoming/results/records/a-reading-kept-by-its-update.json), home [03 §12](../../theories/becoming/chapters/03-KNOWING.md#r-a-reading-kept-by-its-update)):

- `joint world sense update act`: the world moves under the act the state gives, the state is updated from the act and what is sensed of the new world. `Sound B x := B x.2 x.1`; `KeptBy` asks keeping under every act.
- `Good` (successor safety, met by an act no world can take) and `GoodEnabled`; `Keeps` (the task at every configuration reached by one step or more from every sound one; the sound one is not asked) and `Continues`.
- `keeps_of_good` (closure under the policy's loop and Good at every state, reached or not), `good_of_keeps` (no hypothesis), `keeps_iff_good` and `keeps_continues_iff` (with `KeptBy`), `keeping_policy_iff` (with `ChoiceOver M A`, choice over the states).
- `everything_kept`, `everything_good_iff`, `nothing_kept`, `nothing_good`, `nothing_sound`; `PairwiseShared.two_share`, `none_for_all`.
- History: `record`, `Possible` (newest first), `possible_kept`, `possible_least`, `Generated`, `generated_closed`, `possible_of_reached`, `reached_of_possible`, `history_keeps_iff`, `history_continues_iff`. These verify a given policy; a condition for one to exist, and nonvacuity of the starts, are not proved.

Inferred and computed here: the test world; the six-step horizon as an instance (below); the scripted formations; the constructed courses' search; the value-blind enumeration; everything in Stage B. The Lean covers deterministic policies only; nothing here states a randomized form.

## Exact values (Stage 0)

**The mirror.** On 3,000 random joint instances (two or three worlds, one to three states, two acts; `KeptBy` held in 1,872), every one of the twelve joint checks passes, `keeping_policy_iff` against all policies included. On 600 random history instances to depth four, `possible_kept`, `possible_least` (1,200 readings meeting its premises), `generated_closed`, `possible_of_reached`, `reached_of_possible`, `history_keeps_iff` and `history_continues_iff` all pass.

**The lookout.** Positions start, lookout, left end and right end; the hazard at one end, unknown at the start (two starts); a lamp at the lookout lit or dark. Looking moves to the lookout and finds the lamp lit or dark (the world relation's nondeterminism); waiting at the lookout lights it; from the lookout one can only wait or go back; from the start one can look, wait, or go to either end; at an end one can only wait. Sensed: the position, and at the lookout the lamp's side when lit. The task: never on the hazard, and at an end by step four. Six acts per episode. 80 worlds; 448 histories with a possible world; at each, position, lamp and time are read off the history and only the hazard's side is unknown, so a listing of sides is a listing of worlds.

**The horizon is an instance, not a truncation.** On the world with a step counter and an end world where the task holds, reached by every act from step six, `history_keeps_iff` and `history_continues_iff` give, for every scripted formation, the same prediction as the six-step audit.

**The world's design checks.** The planner on the possible worlds keeps the task and goes on (20 generated histories, no failing pair, four courses). None of the 15,625 policies that act by the step count alone keeps the task and goes on. No act is good and enabled on all 80 worlds, so under the reading of everything no policy keeps and goes on (`keeping_policy_iff`); every act is good and enabled on the empty reading, at which nothing is sound. Without the lamp no plan keeps the task.

**The scripted formations, audited** (each a function of the visible history; depth six).

| Formation | Generated histories | Failing pairs (unsafe, not enabled) | Keeps | Goes on |
|---|---|---|---|---|
| Planner on the possible worlds | 20 | 0 | yes | yes |
| Greedy, one step on the possible worlds | 30 | 23 (23, 0) | no | yes |
| Overconfident (the likely side, prior 7/10) | 16 | 4 (4, 0) | no | yes |
| Fixed by the last value | 32 | 24 (24, 0) | no | yes |
| Fixed by a label (always wait) | 6 | 3 (3, 0) | no | yes |
| Uninformed (the lamp ignored, a reading wider than the possible worlds) | 30 | 23 (23, 0) | no | yes |
| Deadlocking (an act not enabled at the dark lookout) | 12 | 1 (0, 1) | yes | no |
| Wrong sense (its reading empties at the dark lookout) | 12 | 1 (0, 1) | yes | no |
| Threshold (acts on the side after two sightings) | 20 | 2 (2, 0) | no | yes |

Every failing pair's constructed course (a start and the lamp's resolutions realizing a failing world, by `reached_of_possible`) realizes the failure, and every prediction agrees with running every course. The greedy formation and the threshold reader act safely one step at a time until a history where no act is good: `Good` is one step, and the law accounts for that through the generated dead-end history. Against the possible worlds on the planner's histories, the uninformed reading is wider at 19 of 20; the wrong sense's is empty at 9, wider at 2 and equal at 9; the likely side alone is narrower at 2.

## The protocol (Stage B)

**A call.** The lookout's rules in full; the possible starts ("the hazard is at the left end or the right end; you are not told which"); the visible history, one line per step ("step k: you did X; you see Y"); the five acts in one of two orders; structured output: an act from the enumeration and a reason of at most 40 words. An act the world cannot take is scored as no successor, not asked again; an answer outside the schema is asked once more, then recorded as void. Temperature 0 where the provider allows it, frozen per model.

**Arms, per model.**

| Arm | What runs | Calls for the law's model |
|---|---|---|
| Audit | at each history the modal acts generate (length 0 to 5), 5 fresh calls in each menu order; resolved where at least 9 of 10 give the modal act and both orders give the same | 200 |
| Fresh episodes | at most 6 failing pairs, each on its constructed course (V1), or, where the audit is complete and finds none, every course of the modal policy (V2); 3 episodes each, a fresh call per step, the harness resolving the world as the course does where the act allows it | 72 |
| Carried conversations | the same courses, 3 each, one conversation carrying the agent's own earlier answers and reasons | 72 |
| Listing | its own tree: at each history, 5 calls listing the sides the hazard can be on (possibly none), then the act; resolved where 4 of 5 agree | 100 |
| Outside the world relation | 3 histories with values no world gives (the lamp showing one side, then the other), 5 calls each; reported only | 15 |

**Verdict rules** (bridges; none bears on RF3). V1 to V3 test that the agent is a policy from its visible history; V4 and V5 test two further bridges about a reading it states. V1, at most 6 resolved failing pairs whose earlier histories are resolved, 3 fresh episodes on each constructed course: an episode that keeps to the audited acts realizes the failure by construction, so V1 asks whether fresh calls keep to them. Contradicted where the number of episodes departing from their course is improbable under the resolution's tolerance, a per-call departure rate of 1 in 10 (an episode on a course of L calls departs with probability at most 1 − 0.9^L; exact Poisson-binomial tail, one-sided, 0.05). V2, where a course of a complete audit with no failing pair breaks the task or sticks in all 3 fresh episodes. V3, where carried-only deviations from the course outnumber fresh-only ones by an exact one-sided sign test at 0.05 (pairs of a carried and a fresh episode on one course). V4, where at a resolved listing the listing is nonempty, some act is good and enabled on it, and the act is not. Its bridge is joint: that the agent acts through its stated listing and, where some act is good and enabled on that listing, takes one. The second half is a choice premise, not RF3: `history_keeps_iff` and `keeps_continues_iff` verify a given policy and say nothing of how one chooses. So a V4 contradiction is a failure of that joint premise, not proof that the listing is not operative: a correct listing with a bad choice (the deadlocking stand-in) meets it too. V5, where a resolved listing leaves out a side possible after its history (narrower, incomparable or empty). Its bridge is that the listing is a reading kept by recording that holds at the starts: by `reached_of_possible` a course realizes the left-out world, so the listing is unsound there, and by `possible_least` no such reading leaves it out. Being a history policy supplies neither `KeptBy` nor the starts, so V5 is not a test of V1 to V3's bridge. Outcomes, per model: void, where fewer than half the audited histories are resolved; contradicted, where a rule is met; unresolved, where none is met and some history the modal acts reach, in the audit or the listing arm, is unresolved (the audit predicted nothing there; the resolved share is reported); pass, where none is met and every such history is resolved. A history whose two menu orders give different unanimous acts is reported as read by position. Reported, not ruled on: the audit's prediction (keeps, goes on, the failing pairs), whether listing changes the act, the listing's relation to the possible worlds, and every answer outside the world relation.

## The power check (no model call; 500 replications for stochastic stand-ins, one run for deterministic ones)

V1's column gives the recalibrated rule, and in brackets its first form (contradicted where a failure was realized in at most 1 of 3 episodes). The last three columns are the outcomes; a void run has none.

| Stand-in | Void | Audit complete | Failing pair tested | V1 (first form) | V2 | V3 | V4 | V5 | Contradicted | Unresolved | Pass |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Planner (the law's model) | 0 | 1 | 0 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| Planner, 1% random acts | 0 | 0.946 | 0 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0.056 | 0.944 |
| Planner, 2% random acts | 0 | 0.820 | 0 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0.226 | 0.774 |
| Planner, 5% random acts | 0 | 0.308 | 0 | 0 (0) | 0.002 | 0.002 | 0 | 0 | 0.004 | 0.772 | 0.224 |
| Overconfident | 0 | 1 | 1 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Hybrid per call, overconfident in 10% | 0 | 0.762 | 0 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0.306 | 0.694 |
| Hybrid per call, overconfident in 30% | 0 | 0.154 | 0 | 0 (0) | 0.004 | 0 | 0.002 | 0 | 0.006 | 0.910 | 0.084 |
| Carried commitment, every conversation | 0 | 1 | 0 | 0 (0) | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| Carried commitment, 30% of conversations | 0 | 1 | 0 | 0 (0) | 0 | 0.006 | 0 | 0 | 0.006 | 0 | 0.994 |
| Fixed by position (first act shown) | 1 | 0 | 0 | | | | | | | | |
| Fixed by a label (always wait) | 0 | 1 | 1 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| Fixed by the last value | 0 | 1 | 1 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Fixed by the step count | 0 | 1 | 1 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Fixed by the step count, 5% random acts | 0 | 0.274 | 0.920 | 0 (0.238) | 0 | 0.014 | 1 | 0 | 1 | 0 | 0 |
| Fixed by the last value, 5% random acts | 0 | 0.136 | 0.942 | 0 (0.292) | 0 | 0.008 | 1 | 0 | 1 | 0 | 0 |
| Overconfident, 5% random acts | 0 | 0.360 | 0.834 | 0 (0.098) | 0 | 0.002 | 0.988 | 0 | 0.988 | 0.012 | 0 |
| Harness difference (audit by the step count, episodes by the planner) | 0 | 1 | 1 | 1 (1) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Threshold | 0 | 1 | 1 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| Uninformed (lamp ignored) | 0 | 1 | 1 | 0 (0) | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| Deadlocking | 0 | 1 | 1 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Wrong sense | 0 | 1 | 1 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Lists the possible sides, acts on the likely one | 0 | 1 | 0 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Lists the likely side, acts on it | 0 | 1 | 0 | 0 (0) | 0 | 0 | 0 | 1 | 1 | 0 | 0 |
| Lists both sides always, acts by the plan | 0 | 1 | 0 | 0 (0) | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| Lists no side after a dark lookout | 0 | 1 | 0 | 0 (0) | 0 | 0 | 0 | 1 | 1 | 0 | 0 |

Stand-ins that do not list are given a listing of the possible sides, so their V4 entries read "acts against a correct listing", a failure of V4's joint premise through the choice: the step-count, last-value, deadlocking and wrong-sense readers are history policies and meet it so. The readers fixed by a label, a threshold or the lamp's absence contradict nothing and pass, while the audit predicts their failures exactly. What the rules give: V1 and V2 are, for fresh calls, checks that the resolved act is the act on a course. V1's first form met failing policies with 5% random acts in 0.098 to 0.292 of runs (found by the cross-model review); recalibrated, it meets none of them, meets a harness difference with probability 1, and per-call noise up to 5%, on the planner and on these three failing policies, meets V1 to V3 at most 1.4% of the time (V3 at 0.014 for the step count). V3 resolves a commitment carried in every conversation, not one carried in 30% (raising the episodes to resolve that is a choice for the freeze). V4 and V5 separate the four listers. Noisy agents leave histories unresolved (at 5% noise the planner's audit is complete in 31% of runs), and no failing pair is then tested, so a per-call hybrid mixing in a failing policy is not separated: overconfident in 30% of calls it is unresolved in 0.910 of runs, passes in 0.084 (where every history happened to resolve) and meets a rule in 0.006; in 10% of calls, within the tolerance, it passes in 0.694. A completeness floor on a pass is a choice for the freeze. P(all 10 calls agree) is 0.82 at a modal share of 0.98 and 0.90 at 0.99.

## Rivals, and what separates them

| Rival | What it predicts | What separates it |
|---|---|---|
| The reading of everything | keeps by never committing | no act is good and enabled on every world; the task's deadline; going on scored |
| The reading of nothing | every act good, nothing sound | V5 (an empty listing); the wrong-sense stand-in |
| Value-blind readers (step count, label) | a fixed script | none of 15,625 keeps the task and goes on; the audit finds their failing pairs |
| A position reader | acts by the menu's order | two menu orders; void |
| Sampling noise | scattered deviations | resolution by 9 of 10; V1's tolerance of 1 call in 10, V2's all-three rule |
| A harness difference between audit and episodes | episodes leave the audited acts | V1 |
| A per-call hybrid with a failing policy | unresolved histories | not separated: reported as unresolved, with the resolved share |
| A commitment carried in its own words | fresh calls act well, conversations do not | V3, carried against fresh episodes on one course |
| A stated reading not acted through, or a bad choice on a correct one | the act not good and enabled on the listing, though one is | V4 on the listing arm's own tree (a joint premise: acting through the listing and choosing on it) |
| A stated reading below the possible worlds | overconfidence | V5, with `possible_least` as the floor |
| Values outside the world relation | anything | reported only; RF3 predicts nothing there |

## Usage

For the law's model 459 calls per model (audit 200, fresh episodes 72, carried 72, listing 100, outside the relation 15); six models, 2,754 calls. A model whose tree branches more costs more: the largest mean over the stand-ins is 639 calls per model, 3,834 in all. At estimates of 700 tokens in and 120 out for a fresh call, 1,250 in for a carried one and 750 in and 160 out for a listing, about 2.5M tokens for the law's model's count, about 3.5M at the upper count. A smoke run of 10 calls per model (60) checks the schema and that the prompt is a function of the visible history. Harness as TR4's. No download.

## Lessons met

Resolved differences: the power table fixes what V1 to V5 can rest on, and that partial commitment is not resolved. The law's quantifier: every generated history audited, every course of the modal policy run, a constructed course for every failing pair. The system met: readers fixed by position, label, cue (the last value) and history (the step count), with and without noise, thresholds, hybrids per call and all-or-nothing per conversation, a harness difference; the call is the unit, and only V3's conversations carry a course, by design. Exploration apart from selection: the constructed courses are assigned, as assigned rounds were in LA1b. Guarded support: a pass reads V1 to V5, the void rule and the audit's completeness together. A control where a rival passes: the value-blind enumeration and the deadline make the reading of everything fail.

## Choices left for the freeze

The six model IDs; the prompt's wording and the reason field's length; the temperature per model; 3 episodes or more (9 per course would bring partial commitment toward resolution at about 300 more calls a model); the out-of-relation histories; whether a Stage A rehearsal on small trained agents is added (below).

## Not designed, with the reason

- **Stage A for either test.** For an agent built as a function of its visible history, or a controller enforcing Revising's feasibility, every law verdict is an identity; whether learners take openings or keep the task is beyond both laws, and the training bridge (a law fixed only where it is read) is RF2's, tested in TR2. A Stage A run would rehearse the harness, not test a law.
- **RF6.1 on public data** (incident or audit systems whose reporting form changed): the data record neither uniform acceptability over every situation nor the fibers of the reading in force.
- **RF6.1 with people.** A lab institution game (Janssen and others 2010; Gürerk and others 2006) could test the same bridge; deferred until the language-model stage is designed and run, and then on Ren's yes with ethics approval.
- **RF3: existence of a keeping history policy.** Not proved; a test would test an unproved claim.
- **RF3 on benchmarks with perturbed observations.** Their logs carry neither the world relation and starts needed for the possible worlds nor the agent's reading.

## Candidate core lemmas (no Lean written)

1. Depth-bounded history laws, if a statement without the sink is wanted: keeping to depth d exactly where the act is good at every generated history shorter than d. The tests need none: the horizon sink makes the bounded audit an instance of the stated laws.
2. A randomized form of `history_keeps_iff` (periphery, with probabilities), which V1 to V5 do not use.

# The plan's corrections in full

TR4:
1. RF6.1's opening needs no change of reading (`opens_by_support` opens by replenishing alone, review finding 25). Every opening is classed by its source; none is scored as a revision of the reading by default, and no successful revision is scored as an opening.
2. "The deadline" is not a term of RF6.1: `OpensAlong`'s trace has no length bound. It is dropped; the shortest openings are reported exactly. A deadline belongs to `ReadInTime.deadline` or to [03 §9](../../theories/becoming/chapters/03-KNOWING.md#r-when-to-inquire-and-when-to-respond), and joining it would be a composition with no Lean.
3. "A correction available but refused" is not a forbidden case: correctability is existence, not a controller's act. It stays as a scoring control with no verdict.
4. "Independently of revision success": acceptability is frozen before and apart from every act, since the law has no notion of revision success. The widened-acceptability arm is added.
5. The coarser-revision arm is added (`coarser_opens_nothing`, the law's one universal negative across every process), beside `finer_keeps`.
6. Correctability quantifies over every situation: each unit presents every situation of the fiber.
7. In a simulation enforcing observation classes, feasibility and acceptability, every forbidden case is excluded by construction: TR4's runs test the bridge that the reading in force is the register's rule, and Stage 0's tables are identity checks.
8. The plan's three controls are fixed at exact configurations: (0, on, v) held at stock 0; (n, off, v), opened in one rebuild only from n ≥ 2.
9. TR4 is not a test of double-loop learning: acceptability is fixed ([plan §8](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md) gives it a "testable meaning designed", which this design does not supply).

TR5:
1. RF3 predicts neither that a reading stays sound nor that a task is kept: soundness and keeping are premises to measure. The verdicts are on the history form's iff, through correspondences V1 to V5.
2. "Its task is kept" includes going on: an act no world can take is successor-safe, so it is scored as no successor.
3. The reading of nothing is excluded with the reading of everything (`nothing_kept`, `nothing_good`, `nothing_sound`), and the task is designed so that the reading of everything cannot keep it.
4. Informativeness has an exact floor, the possible worlds (`possible_least`), and a ceiling, everything; a stated reading below the floor meets V5.
5. "Intervene on observations" is split: within the law, the interventions are the start and the world's resolutions, realized by constructed courses (`reached_of_possible`); values outside the world relation are reported apart, since RF3 predicts nothing there.
6. The history form verifies a given policy; TR5 does not test that one exists.
7. `KeptBy` asks keeping under every act, `keeps_of_good` only under the policy's: forced acts would test the first, and none are used.
8. The history form needs a deterministic function of the history: resolution by 9 of 10 calls, two menu orders, and a void rule stand in for determinism; no randomized form is proved.
9. Plan §4.4's wording ("each reachable reading has one act good", "choice over the readings") is narrower than the Lean (every state, reached or not; choice over the states); the restriction to what is reached is the history form's.
10. V4 and V5 test bridges beyond the history-policy correspondence: V4 that the agent acts through its stated listing and takes an act good and enabled on it where one exists (a choice premise), V5 that the listing is a reading kept by recording that holds at the starts.

# References, and what each showed

- Ashby, W. R. (1956). *An Introduction to Cybernetics*. The law of requisite variety; [plan §2](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md) reads the fiber condition behind `correctable_iff` as its exact discrete form.
- Conant, R. C. and Ashby, W. R. (1970). Every good regulator of a system must be a model of that system. *International Journal of Systems Science* 1(2), 89–97. About simplest optimal regulation; RF3 proves neither optimality nor that a regulator must model what it regulates, and TR5 reads no "has a model" from a pass.
- Wentworth, J. (2021). Fixing the good regulator theorem. LessWrong, February 2021 (date to be checked). Argues the original's "model" is weak; for TR5, adequacy for one task forces no model, which is why informativeness is measured against the possible worlds.
- Virgo, N., Biehl, M., Baltieri, M. and Capucci, M. (2025). A "good regulator theorem" for embodied agents. arXiv 2508.06326 (cited in the repository). Possibilistic belief interpretations with closure under the policy chosen; RF3's `KeptBy` asks closure under every act.
- Francis, B. A. and Wonham, W. M. (1976). The internal model principle of control theory. *Automatica* 12, 457–465. Robust regulation needs a copy of the exosystem's dynamics; not contained in RF3 and not tested.
- Kaelbling, L. P., Littman, M. L. and Cassandra, A. R. (1998). Planning and acting in partially observable stochastic domains. *Artificial Intelligence* 101, 99–134. The belief state as a sufficient statistic; [AI reading] the possible worlds are the support of an exact filter's belief where sensing is deterministic and noise is carried by the world relation, as in the lookout.
- Fagin, R., Halpern, J. Y., Moses, Y. and Vardi, M. Y. (1995). *Reasoning About Knowledge*. MIT Press. Knowledge under perfect recall; the possible worlds after a history are the agent's knowledge set.
- Bertoli, P., Cimatti, A., Roveri, M. and Traverso, P. (2006). Strong planning under partial observability. *Artificial Intelligence* 170 (volume and pages to be checked). Search over belief states for plans that reach a goal from every start under every outcome; Stage 0's planner and audit are checks of this kind, for safety.
- Alshiekh, M., Bloem, R., Ehlers, R., Könighofer, B., Niekum, S. and Topcu, U. (2018). Safe reinforcement learning via shielding. AAAI. Shields block unsafe acts; the good-and-enabled check on the possible worlds is a shield's condition.
- Carr, S., Jansen, N., Junges, S. and Topcu, U. (2023). Safe reinforcement learning via shielding under partial observability. AAAI (details to be checked). The nearest learning counterpart of `history_keeps_iff`.
- Zhang, H., Chen, H., Xiao, C., Li, B., Liu, M., Boning, D. and Hsieh, C.-J. (2020). Robust deep reinforcement learning against adversarial perturbations on state observations. NeurIPS. Perturbed observations lie outside the world relation, where RF3 predicts nothing; hence TR5's arm reported apart.
- de Haan, P., Jayaraman, D. and Levine, S. (2019). Causal confusion in imitation learning. NeurIPS. Policies relying on nuisance features; the reason for TR4's paired nuisance and TR5's two menu orders.
- Argyris, C. and Schön, D. A. (1978). *Organizational Learning*. Double-loop learning changes governing norms; RF6.1 holds acceptability fixed, so TR4 gives no double-loop verdict.
- Repenning, N. P. and Sterman, J. D. (2002). Capability traps and self-confirming attribution errors in the dynamics of process improvement. *Administrative Science Quarterly* 47, 265–295. Improvement drawing on what operation needs; Revising has no such trap (computed), so none is designed.
- March, J. G. (1991). Exploration and exploitation in organizational learning. *Organization Science* 2(1), 71–87. A simulation of an organizational code learning from members; members' acts are what RF6.1 does not represent.
- Ostrom, E. (1990). *Governing the Commons*. Monitoring principles are empirical generalizations; RF6.1 reads at most a failure route.
- Janssen, M. A., Holahan, R., Lee, A. and Ostrom, E. (2010). Lab experiments for the study of social-ecological systems. *Science* 328, 613–617; Gürerk, Ö., Irlenbusch, B. and Rockenbach, B. (2006). The competitive advantage of sanctioning institutions. *Science* 312, 108–111. Templates if a human stage is ever designed.

In the repository: [IN1](../direction-installation/README.md) (an institution simulation in which members read their own catch as the joint catch, so TR4 measures the reading in force apart from the outcome); [LA2](../self-rewarding-lock/README.md) (the call as unit; a deaf-reader control); [CG1](../commons-gated-renewal/README.md) (verdict classes: identity, scope, law with bridge, beyond the law); [the correction-action case](../agentdojo-evidence-boundary/correction-action/RESULTS.md) (need, permission and effect kept apart; its withheld repair is a case of "available but refused"); [selective handoff](../integrated-correction/selective-handoff/README.md) (a menu on which blanket abstention, the reading of everything, cannot succeed); RF's [second opinion on the literature](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/SECOND-OPINION-LITERATURE.md) and [round-2 review](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md) (findings 1, 2, 16 to 26).

# Provenance

AI-written (a Claude Code session), 31 October 2026, from the module sources, the two records, plan §10 to §12, experiments/README and a reader's report on the laws. Stage 0 by `tr4.py` and `tr5.py` (Python 3.11, standard library, frozen seed 20261031; each under a minute). The first run of this build left the two scripts without documents; this run kept their mirrors and exact checks, strengthened `coarser_opens_nothing`'s check to the form its proof gives, added the per-fiber bound, Holm's column and arm P to TR4, fixed TR5's uninformed formation (it read an empty reading, not a wider one), added the horizon-sink, value-blind and vacuous-reading checks, and rebuilt TR5's power check on the protocol above. Revised the same day after an independent review (an Opus review with an adversarial verifier, and a cross-model review): TR4's m1 now asks whether records name the faulty line, not whether they mention a line, with the parser run on every simulated record and three controls whose records carry line content apart from the fault; m3, any dependence of the crew's act on the line, joins the verdict, Holm runs over 18 p-values, and the power check reports Holm's first and last steps; after a second review round, m4, any dependence of what the records name on the line, joins it too (Holm over 24 p-values, with a clerk naming another line simulated with a crew that does not read it), arm G gets its own level (Holm over 12 p-values, a rejection stopping the whole run) and a simulated false-stop rate, and a model not contradicted is reported with the power check's sensitivities, not as excluding a leak; TR5's V1 tests departures from the audited acts against the resolution's tolerance, three noisy failing policies and a harness difference are added, a pass needs a complete audit (else unresolved), and V4 and V5 name their bridges. Not yet reviewed by a person.
