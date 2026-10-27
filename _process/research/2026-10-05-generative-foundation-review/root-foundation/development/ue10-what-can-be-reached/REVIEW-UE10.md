# UE10 review: widening what can be reached

AI-written, 26 October 2026. This is an independent review of board item UE10 (candidate B for the second-order direction of 生生), written for its fix round. Every docstring claim was checked against the Lean, and every probe was built with its axiom report printed. The review edits neither the module nor the design. The probes are evidence; none is proposed for landing as written.

**Reviewed.** [`tree/Becoming/ReachableRanges.lean`](tree/Becoming/ReachableRanges.lean) (645 lines, sha256 `60d1f4e911d283a1b94e10e05b7cfb92f71eedb19b6f39610a344b5ecaa4a6a1`) and [`DESIGN.md`](DESIGN.md) (sha256 `41f67180a59a34de55a1e34e3503d70eee288cfa853fc990936c3774265353d7`). The landing targets are [07 §2 and its Open item](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open) and [08 §8](../../../../../../theories/becoming/chapters/08-METHOD.md#beyond-the-table). The neighbours read were [UE9's note](../ue9-comparing-courses/NOTE.md) and kit module, [UE4's design §3.2](../ue4-second-order/DESIGN.md#32-candidate-b-capacity-widening-of-what-can-be-reached), the [glossary](../../../../../../GLOSSARY.md), and the landed modules named below. Package modules are cited by file and line under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`, which is [this folder](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/) from here.

**Build.** `python3 -B scratch_build.py <probes/tree> Becoming.ReachableRanges …`, run against main's package, reproduces the module's 54 theorems in 82 declarations, every axiom report empty. The copy in the probe tree is byte-identical to the module. The module imports only core modules (Horizon, Population, Admission and LawAlongRun are on `check_becoming.py`'s `CORE` list), and so do the landed modules the proposed instance theorems would use (Labelled, Onward, Extension, Bundles, Lexical, EventualWidening).

## Probes

All probe files are in [`probes/tree/Becoming/`](probes/tree/Becoming/), namespace `Becoming.ProbeUE10`.

| File | Theorems / declarations | Axiom report | Probes |
|---|---|---|---|
| [`ProbeLaws.lean`](probes/tree/Becoming/ProbeLaws.lean) | 39 / 55 | empty | B1–B12 |
| [`ProbeWitnesses.lean`](probes/tree/Becoming/ProbeWitnesses.lean) | 26 / 45 | empty | W1–W6 |
| [`ProbeInstances.lean`](probes/tree/Becoming/ProbeInstances.lean) | 7 / 12 | empty | I1–I5 |
| [`ProbeChains.lean`](probes/tree/Becoming/ProbeChains.lean) | 2 / 2 | empty | B6 on the web |
| [`ProbeLag.lean`](probes/tree/Becoming/ProbeLag.lean) | 6 / 7 | empty | L1 |
| [`ProbeUniverse.lean`](probes/tree/Becoming/ProbeUniverse.lean) | 54 / 82 | empty | the module with `X : Type w` |
| [`ProbeClash.lean`](probes/tree/Becoming/ProbeClash.lean) | 1 / 1 | empty | name clashes |

No probe needs an axiom: none uses `propext`, `Quot.sound` or `Classical.choice`. ProbeInstances and ProbeLag are stated at `Type`, because `Extension`, `Bundles`, `Lexical` and UE9's `strictJoin_trans` are. ProbeLag and ProbeClash import UE9's kit module `Becoming.ComparingCourses`, copied unchanged into the probe tree (sha256 `e5d2cb98…ee6`, the UE9 tree's version at review time), so ProbeLag stands on unlanded work. ProbeClash imports all of `Becoming` together with UE9's and UE10's modules (340 modules) and finds no name clash. `probes/tree/.build` is build output and holds no data.

Probe index:
- **B1** `covers_possible`, `possible_unchanged_of_covers_next`: where every configuration reachable from `s'` starts a course, covering `s'` carries everything possible from `s'`. Along a course, a step whose later configuration covers the earlier leaves the whole possible unchanged.
- **B2** `DeadEnd.widens_reversed`: `true` widens what can be reached over a dead end `false`. Everything is possible from `false` and nothing from `true`.
- **B3** `widens_next_iff_rising`, `law_unique`, `rise_is_law`: on a determined process, the next configuration widens what can be reached over the present one exactly when the course is kept one step late and not conversely. `Rise.process` is a law.
- **B4** `widens_iff_of_greatest`, `widens_of_rangeWidens_greatest`, `greatest_of_unique`, `Fork.greatest_not_unique`: the iff holds wherever each configuration has a course that includes every course from it, and that can happen where courses are not unique.
- **B5** `widens_not_covered`: what widens what can be reached over another is not covered by it.
- **B6** `ChainKeepsWidening` (07's form for any chain of predicates), `.gathers`, `.not_listed`, `chain_of_keepsWidening`, `not_keepsWidening_of_listed_along`, `listed_along_of_listed`, `every_other_step`. ProbeChains adds `chain_of_web_keepsWidening` and `web_not_listed_of_chain`.
- **B7** `Static.converse_fails`: law 3's converse fails.
- **B8** `rangeIncludes_iff`, `rangeExceeds_iff` (the grammar's `«则»`, `«逾»`), `rangeIncludes_conditions_iff`, `rangeWidens_conditions_iff` (07's `Web.Includes` and `Web.Widens`, by `Iff.rfl`).
- **B9** `covers_iff_criteria`: covering is dominance for every criterion on ranges that is closed upward under inclusion.
- **B10** `CoversLater`, `coversLater_next`: with a lag of one step, every configuration of a course covers its successor.
- **B11** `law_possibleWithin_iff`, `climb_is_law`: on a law, the possible within `k` is the course's own admissions over the next `k` steps.
- **B12** `covers_now`, `not_above_wider_now`: covering needs being at least as wide now.
- **W1** `Timing.timing_unseen`, `Timing.late_simulates_early`, `Timing.early_not_simulating_late`: covering is linear-time.
- **W2** `Silent.silent`, `Silent.lag_decides`: silent on 07's pair; a lag decides it.
- **W3** `Calibration.markov_of_designForm`: the design's form of law 1 gives Markov's principle.
- **W4** `possibleWithin_iff_withinMoves`, `possibleWithin_moves'`, `possible_iff_withinMoves`, `possible_of_reach'`, `narrowing_not_returns`, `joint_same_bundles`.
- **W5** `LexicalRuns`, `.irrefl`, `.trans`, `lexical_iff_runs`.
- **W6** `rise_possible_unchanged`, `rise_within_same`.
- **I1** `covers_iff_carries`, `covers_iff_preserves`. **I2** `covers_iff_included`, `widens_iff_extension`. **I3** `lexical_above`. **I4** `joint_no_comparison_through_possible`. **I5** `options_no_comparison_both`.
- **L1** `WidensOrLater`, `.irrefl`, `.trans`, `.not_reversed`, `silent_decided`.

## Findings

### 1. Same-offset covering contains inclusion now, so it never ranks a range that keeps widening above one wider now

*Class:* imprecision (major).

*Location:* the header, lines 9–14 ("07's open item asks for … One candidate is what a course keeps reachable. Here it is read on any process"); `Reaching.Lexical`, lines 319–324; DESIGN §1, and §7 step 3 ("07's Open item narrowed").

*Evidence.* B12 `covers_now` shows that from `Reaching.Covers P adm s s'` and a course from `s'`, `adm s' x → adm s x`. `not_above_wider_now` adds that, with each chosen course starting at its configuration, `adm s' x` and `¬ adm s x` give `¬ Reaching.Widens P adm s s' ∧ ¬ Reaching.Lexical P adm course s s'`. 07's Open item asks for a comparison of a range whose widening keeps widening with one merely wider now. A pair of that kind is exactly one where the second admits now what the first does not. On every such pair, in any process, neither order can rank the first above the second, provided the second starts a course (and, for the lexical order, the chosen courses start at their configurations).

W2 `Silent.silent` shows the silence on a concrete process. On a determined process, the climb from `some 0` widens its own range at every step and `none` admits more now. The two are mixed, and neither `Reaching.Widens` nor `Reaching.Lexical` ranks either above the other. Moreover, on determined processes widening what can be reached is the strict part of inclusion of the two courses (`widens_iff_of_unique`), which is a first-order comparison.

*Fix.*
- (a) State B12 in the module as `Reaching.Covers.now` and `Reaching.not_above_wider_now` (term proofs of a few lines, as in ProbeLaws). Use it as the landing's narrowing of 07's Open item: "What a course keeps reachable, compared at the same offsets, contains inclusion now: it never ranks a range that keeps widening above one wider now (`Reaching.not_above_wider_now`); on a determined process it is widening of the two courses; the lexical order adds only ties of the realized range."
- (b) If UE10 is to bear on the open item, a lag has to enter. Covering with a lag (`CoversLater P adm d s s'`, B10), joined to widening what can be reached by UE9's order lemma, is a strict partial order that contains widening what can be reached and never reverses it. It ranks the climb above `none` (L1 `WidensOrLater.trans`, `.irrefl`, `.not_reversed`, `silent_decided`). It is UE9's lagged order lifted to families of courses, so its standing is UE9's, including whether calling it better is a premise beyond C. Claim it only after UE9 lands.

### 2. `Rise.rises` says the whole possible narrows; on the witness it is unchanged

*Class:* error (major).

*Location:* the `Rise.rises` docstring, lines 387–388; the header, lines 32–34.

*Evidence.* The Lean states `Reaching.Widens process adm (course.state 1) (course.state 0) ∧ ∀ x, Reaching.Possible process adm (course.state 1) x → Reaching.Possible process adm (course.state 0) x`. Its second conjunct is `course.possible_narrows 0`, which holds at every step of every course. In the package, "narrows" is strict: `Clearing.narrows` (Clearing.lean line 261) is `web.Includes l web.level ∧ web.Exceeds l web.level`.

On the witness nothing narrows. The whole possible is the same from both configurations (W6 `rise_possible_unchanged`), and so is the possible within every horizon beyond the present (W6 `rise_within_same`, for `k + 1`): only what each configuration admits now rises. Read non-strictly, the conjunct adds nothing to the witness. Read strictly, it is false of it.

The same holds in general. Where the later configuration covers the earlier, and every configuration reachable from the earlier starts a course, the whole possible is unchanged across the step (B1 `possible_unchanged_of_covers_next`). Widening what can be reached goes together with a strictly narrowing whole possible only through configurations that start no course, and then without bound. In B2 `DeadEnd.widens_reversed`, `true` widens what can be reached over a dead end from which everything is possible, while nothing is possible from `true`.

*Fix.* Change the docstring to: "Widening what can be reached, read at the same offsets from each configuration's own start, can rise along a course, while nothing is added to the whole possible: on this course the whole possible, and the possible within every horizon beyond the present, are the same from both configurations; only what each admits now rises." Add B1 to the module as `Reaching.Covers.possible`, with its premise `∀ t, Reach P s' t → ∃ q : Run P, q.state 0 = t` named in the statement (DESIGN §5 keeps the existence of runs a named premise), and add B2 as the witness that the premise is needed. The design's reading "What rises is what is near, not what is possible" (DESIGN line 54) is not met: on the witness, what is near does not rise.

### 3. The rise is the course compared with itself one step late

*Class:* imprecision (major).

*Location:* `Rise.rises`, lines 387–398; the header, line 33 ("read from each configuration's own start"); the modelling list, line 61.

*Evidence.* `Rise.process` is a law (`rise_is_law : Rise.process = Law.process (fun _ => true) := rfl`), and every run of a law is determined by its start (`law_unique`). B3 `widens_next_iff_rising` applies `widens_iff_of_unique` to the shifted run. Where courses are determined by their starts, `Reaching.Widens P adm (r.state 1) (r.state 0)` holds exactly when `(∀ t x, adm (r.state t) x → adm (r.state (t + 1)) x) ∧ ¬ ∀ t x, adm (r.state (t + 1)) x → adm (r.state t) x`. This is the course compared with itself one step late: UE9's `Delayed.widens_not_withLag`, where the rising course widens itself one step late, the case UE9's lagged order was built to read. With a lag of one step, every configuration of every course covers its successor (B10 `coversLater_next`, by `Run.cons`). Read with a lag, then, nothing rises along a course, in agreement with law 2. The modelling list names "courses compared at the same offsets from their starts", but the docstring presents the rise as a fact about what can be reached.

*Fix.* Say in the docstring and the record that the rise is the same-offset reading of the course's delay. Add `CoversLater` (UE9's `Web.IncludesLater`, read on courses) and `coversLater_next` as the law that reading with a lag removes the rise.

### 4. `KeepsWidening` takes 07's name for a stronger, per-step property

*Class:* imprecision (major).

*Location:* `Reaching.KeepsWidening`, lines 141–145; `KeepsWidening.gathers` and `not_keepsWidening_of_listed`, lines 291–315; the header, lines 35–42.

*Evidence.* 07 §2 and `Web.KeepsWidening` (EventualWidening.lean line 291) read "keeps widening" this way: from some step on nothing admitted is lost, and after every step something is opened at some later step. The module's `KeepsWidening` asks for strict growth at every single step, which is strictly stronger. B6 `every_other_step` gives a chain `x ≤ half n` that keeps widening in 07's form and gains nothing at step 0. Read at `k = 0` on the law of the successor with `adm n x := x ≤ half n`, that chain is the possible within `0` along a course (B11).

Law 3 holds in 07's form for any chain of predicates (B6 `ChainKeepsWidening.gathers` and `.not_listed`), and under a weaker hypothesis than the module's: a list holding what is possible within `k` along the course (`not_keepsWidening_of_listed_along`), which the module's hypothesis implies (`listed_along_of_listed`). The module's per-step form gives 07's form (`chain_of_keepsWidening`). The landed `Web.KeepsWidening.not_listed` is an instance of the same chain law (`chain_of_web_keepsWidening`, `web_not_listed_of_chain` in ProbeChains). Landing the module as it stands would put two senses of "keeps widening" into 07 §2.

*Fix.* Define keeping widening once, for a chain and in 07's form; in the module's idiom, `def KeepsWidening (Q : Nat → X → Prop) : Prop := (∀ n d x, Q n x → Q (n + d) x) ∧ ∀ n, ∃ d x, Q (n + d) x ∧ ¬ Q n x`. State `gathers` and `not_listed` for it, and read the possible within `k` along a course, and the web's admissions by name, as instances. Alternatively, keep the per-step property under a name that says so (for example `WidensAtEveryStep`) and state law 3 in 07's form. Either way, the header's "keeps widening" should carry 07's sense.

### 5. Covering is not option value: it cannot see when a commitment is made

*Class:* credit (major).

*Location:* DESIGN's law 4 reading (line 68: "Ranking by what can be reached is option value in inclusion form") and §4 (line 77: "Law 2's narrowing and law 4's lexical premise are the inclusion forms"); any 08 §8 line drawn from them.

*Evidence.* Covering is linear-time, so it cannot see when a commitment is made. In W1 `Timing.timing_unseen`, `late` steps to `mid`, which then chooses `a` or `b`, while `early` chooses at once. The two cover each other, so neither widens what can be reached over the other. Yet after one step, every course from `late` can still reach both `a` and `b`, and no course from `early` can. `late` simulates `early`, and no simulation relates `late` to `early` (`late_simulates_early`, `early_not_simulating_late`).

Quasi-option value (Arrow and Fisher 1974, QJE 88:312–319; Henry 1974, AER 64:1006–1012), like the value of waiting in real options (Dixit and Pindyck 1994), is the value of deferring an irreversible commitment until information arrives. It needs learning, which the module does not have, and deferral, which covering cannot see.

What the module does restate is twofold:
- the irreversibility premise of those papers (law 2), already credited that way in UE4's §4 table;
- for covering, the lower (Hoare) preorder on families of ranges. B9 `covers_iff_criteria` shows that covering is exactly this: every criterion closed upward under inclusion that some course from `s'` meets, some course from `s` meets. That is the ordinal, unanimous form of a preference for flexibility (Kreps 1979, Econometrica 47:565–577, values a menu through its best member under each possible future preference). That unanimity over Kreps's valuations, with preferences monotone in the range order, gives exactly covering is argued, not proved here, and **needs a check**.

*Fix.* Replace "option value in inclusion form" with "the lower (Hoare) preorder of the families of course ranges: the unanimous preference for flexibility (Kreps 1979), with no probability and no learning". Credit law 2 as Arrow and Fisher's and Henry's irreversibility premise, restated, and say that quasi-option value is not captured, with W1 as the witness. A branching form of covering (simulation with range inclusion, which ranks `late` above `early`) would see deferral. It is optional, and it still has no learning.

### 6. The possible, law 2 and law 3 duplicate landed laws

*Class:* style (major).

*Location:* `Reaching.Possible` and `Reaching.PossibleWithin`, lines 132–139; `Possible.of_reach` and `PossibleWithin.*`, lines 214–233; `Run.possible_narrows_add` and `Run.possible_from_start`, lines 249–257; `Run.possibleWithin_moves`, lines 259–265; `Run.tail_of_trace` and `Run.tail_of_reach`, lines 267–281; law 3, lines 291–315.

*Evidence.* Labelled's `WithinMoves` (Labelled.lean line 924, at `C : Type w`) is a bundle realized together at the end of a trace of at most `n` moves. The probes give these correspondences:
- W4 `possibleWithin_iff_withinMoves`: `PossibleWithin P adm k s x ↔ WithinMoves P adm s k (fun c => c = x)`.
- `possible_iff_withinMoves`, through `withinMoves_iff_reach`.
- `possibleWithin_moves'` is `WithinMoves.before`.
- `possible_of_reach'` is `together_after_reach`, whose docstring ("Along a course nothing becomes realizable together that was not before") is the module's law 2 for bundles.
- `narrowing_not_returns` is `lost_together_not_returns` for one formation.
- `Run.possible_narrows_add r m k` is `Reaching.Possible.of_reach (r.reach m k)` (`Run.reach`, Frame.lean line 231), and `Run.possible_from_start r n` is `Reaching.Possible.of_reach (Onward.reach_of_run r n)`.
- `Run.tail_of_trace` is `Onward.run_of_trace` (Onward.lean line 98) with the tail kept, built by the same `Run.cons` construction.
- Law 3 repeats `Web.KeepsWidening.gathers` and `.not_listed` (EventualWidening.lean lines 322 and 338; see finding 4), and the pigeonhole of KeepingWidening's `Web.KeepsWidening.distinct_configs`.

AGENTS.md asks new results to extend the spine and to connect by instance or equivalence theorems.

*Fix.* Define `Possible` and `PossibleWithin` as the one-formation case of `WithinMoves`, or keep them and land the two bridges as theorems. Derive law 2 from `together_after_reach` and `WithinMoves.before`. Write `possible_narrows_add` and `possible_from_start` as their one-line instances. State `tail_of_trace` as the strong form of `Onward.run_of_trace`, beside it (Onward's owner decides), or cite it. Take law 3 from the chain law of finding 4.

### 7. Covering, widening what can be reached and the lexical order are instances of landed definitions, unconnected

*Class:* style (major).

*Location:* `Reaching.Covers`, `Reaching.Widens`, `Reaching.Lexical`, `Joint`, `Run.RangeIncludes`, `Run.RangeExceeds` (no instance theorems); DESIGN's law 4 reading (C◇) and law 5 reading.

*Evidence.*
- **I1** `covers_iff_carries`, `covers_iff_preserves`: covering is `CarriesProfiles` (Bundles.lean line 65) on the frame of courses. By `carries_iff_preserves`, that is preserving every bundle of (offset, formation) admissions.
- **I2** `covers_iff_included`: covering is inclusion of the ranges some course includes. `widens_iff_extension`: `Reaching.Widens P adm s s' ↔ Extension (reachFrame P adm) (fun _ => True) s' s`, both ways and with no premise. UE4's C◇, "C read on the frame of reachable courses", is therefore exactly `Comparison (reachFrame P adm) (fun _ => True)` (Extension.lean line 57).
- **I5** `options_no_comparison_both`: on `Options`, no strict partial order satisfies C both on the realized courses and on the reachable ranges. This is the lexical premise stated in C's own form.
- **I3** `lexical_above`: `Reaching.Lexical` lies inside `Lexical.Above` (Lexical.lean line 130) of the realized claims, then the reachable ranges. The converse needs the inclusions decided, because `Above` uses the negation of inclusion where the module's first disjunct asks for exceeding.
- **I4** `joint_no_comparison_through_possible`: on `Joint`, no comparison that is read off a description the possible within every horizon determines, and that compares no description with itself, satisfies C◇. This is the law form of `Regimes.no_comparison_through_marginals`, through `Comparison.separates`.
- **B8**: `Run.RangeIncludes` and `Run.RangeExceeds` are the grammar's `«则»` and `«逾»` of what the courses admit (`rangeIncludes_iff`, `rangeExceeds_iff`). With fixed conditions they are 07's `Web.Includes` and `Web.Widens`, by `Iff.rfl` (`rangeIncludes_conditions_iff`, `rangeWidens_conditions_iff`).

*Fix.* Land I1, I2, I3, I5 (or I4) and B8 as instance theorems, in the module or in a small instance module, at `Type` as Extension, Bundles and Lexical are. The record can then say that widening what can be reached is C's extension on the frame of reachable ranges, and the AI readings "C◇" and "the lexical premise" become statements.

### 8. `Joint` separates holding two formations together along a course, not at one configuration

*Class:* imprecision (minor).

*Location:* the `Joint` docstrings, lines 586–641; the header, lines 52–56; DESIGN's law 5 reading, line 72.

*Evidence.* `split` realizes both formations together at its start, and every bundle realizable within any bound is the same from both configurations (W4 `joint_same_bundles`). What `Joint.widens` separates, then, is holding both formations at every offset of one course. The design's "an instance of `Activation.same_marginals_lose_bundle`" is not met at configurations. It is met on the frame of courses, whose claims are (offset, formation) pairs (I1, I4). `same_possibleWithin` holds because both configurations admit both formations now, since the possible within a horizon includes the present. The docstring's account of `split`'s courses ("every course keeps them together only at its start and one of them after it") is not a theorem.

*Fix.* Strengthen `same_possibleWithin` to the bundle form, and write "together at every offset of one course". Either state the course description (after the first step, at `zero` for good or at `one` for good, as `Fork.after` in ProbeLaws does for its fork) or drop it. Connect law 5 through I1 and I4.

### 9. Rise and Climb are determined, so they witness nothing about alternatives

*Class:* imprecision (minor).

*Location:* `Climb`, lines 402–456; `Rise`; the header, lines 40–42.

*Evidence.* `climb_is_law : Climb.process = Law.process (fun n => n + 1) := rfl`, and likewise `rise_is_law`. B11 `law_possibleWithin_iff` shows that on a law, the possible within `k` of a course's configuration at `n` is what that course itself admits at some step from `n` to `n + k`. So `Climb.keeps` is the climb's own range read through a window of `k` steps, and says nothing about alternatives. Together with `widens_iff_of_unique`, this means that on a determined process every notion of the module is a property of single courses. Only `Options` and `Joint` branch.

*Fix.* Say so in `Climb`'s docstring and in the record. Optionally, add a branching witness whose adjacent possible keeps widening through branches not taken.

### 10. Generality

*Class:* style (minor).

*Location:* `widens_iff_of_unique` and `widens_of_rangeWidens`, lines 185–212; `variable {X : Type}`, line 71; `Reaching.Lexical`, line 321; a missing law.

*Evidence.*
- (a) Uniqueness is more than the iff needs. B4 `widens_iff_of_greatest` and `widens_of_rangeWidens_greatest` need only a course from each configuration that includes every course from it. Uniqueness gives one (`greatest_of_unique`), and one exists where uniqueness fails (`Fork.greatest_not_unique`).
- (b) `X : Type` is forced only by law 3, through `mem_cons_cases` (Prelude.lean line 500) and `length_le_of_sub` (Population.lean line 182), both stated at `Type`. ProbeUniverse compiles the module with `{X : Type w}` and law 3 over `{X₀ : Type}` (54 theorems, 82 declarations, empty reports).
- (c) `Reaching.Lexical` takes a course for every configuration. The order on two chosen courses (W5 `LexicalRuns`, `.irrefl`, `.trans`) needs no such function, and it is the module's order wherever the courses start at their configurations (`lexical_iff_runs`).
- (d) Widening what can be reached is one-way against covering (B5 `widens_not_covered`). W1 and L1 use this, but the module does not state it.

*Fix.* Make the changes listed. For (b), either generalize `X` and keep law 3 at `Type`, or ask the owners of Prelude and Population to lift the two lemmas to `Type u`.

### 11. Kauffman's adjacent possible is restated only for a prestated space

*Class:* credit (minor).

*Location:* DESIGN's law 2 reading (line 55) and §4 (line 76); the header's second bullet.

*Evidence.* The module restates the adjacent possible inside a prestated space: one fixed process, a fixed type `X` of formations, and a fixed reading `adm`. Kauffman's later work holds that the biosphere's space of possibilities cannot be prestated (Longo, Montévil and Kauffman 2012, "No entailing laws, but enablement in the evolution of the biosphere", arXiv:1201.2069). The design itself puts the self-changing case outside.

*Fix.* Write: "Kauffman's adjacent possible, restated for a prestated space: within one fixed process the possible within a horizon moves with the actual, and the whole possible never grows. The adjacent possible that cannot be prestated (Longo, Montévil and Kauffman) is outside the module."

### 12. Law 3 is the pigeonhole of finite recurrence, and its converse fails

*Class:* credit (minor).

*Location:* the header's third bullet; DESIGN's law 3 reading (line 61) and §4 (line 80).

*Evidence.* Law 3 is the pigeonhole: an ascending chain in a listed set stops. The package already has it for keeping widening by name (`Web.KeepsWidening.not_listed`) and in KeepingWidening (`Web.KeepsWidening.distinct_configs`, with Novelty's `unbounded_of_distinct_configs`). 08 §8 already credits finite recurrence, and Adams and others (2017, Sci. Rep. 7:997: an isolated system's recurrence as the baseline, and state-dependent rules for open-endedness), for what keeping widening needs. The converse fails. In B7 `Static.converse_fails`, one configuration admits every formation: no list holds the whole possible, and no course keeps the possible within any horizon widening. "The law says why a fixed rule with a listed reach cannot have it" is therefore only the necessary half.

*Fix.* Credit law 3 as the pigeonhole of finite recurrence and point to `Web.KeepsWidening.not_listed`. Add the converse's failure (B7) as a witness or a sentence.

### 13. Opportunity sets: covering is dominance, not set inclusion

*Class:* credit (minor).

*Location:* DESIGN §4, line 78.

*Evidence.* Covering is not set inclusion of what can be chosen. It is inclusion of the down-closures of the families of ranges (I2 `covers_iff_included`), the dominance ordering. In `Rise`, the course from `true` and the course from `false` have different ranges, yet `true` covers `false`. Pattanaik and Xu (1990, Recherches Économiques de Louvain 56:383–390) characterize a ranking by cardinality, not by inclusion. Inclusion is the monotonicity that the opportunity-set rankings share (Jones and Sugden 1982, International Review of Law and Economics 2:47–65). The nearer neighbours are the rankings that order options by a preference and compare sets through their best members, and their lexicographic combinations with cardinality (Bossert, Pattanaik and Xu 1994, JET 63:326–345). The exact correspondence **needs a check**.

*Fix.* Write: "Covering is the dominance ordering of the families of ranges (inclusion of their down-closures, `covers_iff_included`). With options unordered it reduces to set inclusion, the monotonicity the opportunity-set rankings share. Pattanaik and Xu's own ranking counts options, which UE9 excluded."

### 14. The lexical order is the package's two-tier order, near-definitional

*Class:* credit (minor).

*Location:* DESIGN law 4 (lines 63–68); the header's fourth bullet.

*Evidence.* The lexical order is realized widening, composed lexicographically with widening what can be reached on ties: the package's two-tier `Lexical.Above` (I3). `Options.disagree` is UE4's witness and near-definitional. The split between realized and reachable is Sen's distinction between achievement and freedom (Sen 1985, "Well-being, agency and freedom", J. Phil. 82:169–221; the best citation **needs a check**). Lexicographic rules over opportunity sets appear in Bossert, Pattanaik and Xu (1994) (**needs a check**).

*Fix.* Credit the lexical order as the package's two-tier lexical order, read on realized claims and reachable ranges, near-definitional. Cite Sen for the distinction, marked as a neighbour.

### 15. Linear-time: the credit stands, with a witness and a caveat

*Class:* credit (minor).

*Location:* DESIGN law 1, last bullet (line 48); §4 (line 79).

*Evidence.* The credit is correct, and W1 is the witness the design asks for. `late` and `early` have the shape τ.(a + b) against τ.a + τ.b (van Glabbeek 1990, "The linear time – branching time spectrum", CONCUR '90, LNCS 458:278–297): equal under covering, told apart by simulation. Covering compares infinite courses only. A configuration with no course is covered by every configuration (B2), so finite, deadlocking courses are invisible. The nearest point of the spectrum is the infinitary trace preorder with labels ordered by admission (**needs a check** against van Glabbeek's definitions).

*Fix.* Keep the credit. Optionally add W1 to the module as its witness, with the infinite-course caveat in the modelling list (finding 18).

### 16. Assembly theory is an analogy; the open-ended evolution papers are neighbours

*Class:* credit (minor).

*Location:* DESIGN §4, lines 80–81.

*Evidence.* Assembly theory (Sharma and others 2023, Nature 622:321–328) defines an assembly index and a copy number over assembly pathways. The adjacent possible appears there as a cited idea, and no assembly observable is stated in the module. Bedau and others (2000, Artificial Life 6:363–376) and Taylor and others (2016, Artificial Life 22:408–423) pose open-endedness as open problems. Law 3 is a neighbour of that work, not a containment.

*Fix.* List assembly theory as an analogy (the assembly space as a fixed process of construction), not as a restatement. Keep the open-ended evolution papers as neighbours.

### 17. Docstring details

*Class:* imprecision (minor).

*Location, evidence and fix:*
- (a) Lines 58–59, "on a process of a few configurations": `Climb` has a configuration for every natural number, and `Options` has three such families. Say "on small witnesses".
- (b) Lines 31–32, "of a later configuration": `Run.possibleWithin_moves` concerns the next configuration. For a configuration `j` steps on, the horizon is `k + j` (`WithinMoves.after_course`).
- (c) Lines 267 and 276–277, "a tail of": only the states are matched, not the acts. Say "whose states from step `k` on are the other's".
- (d) Lines 305–306: `not_keepsWidening_of_listed`'s docstring says "the adjacent possible", but the theorem holds for every horizon `k`.
- (e) Lines 357–359, "each condition a formation requires there stands at its need": `Dependence.AdmitsAt` (LawAlongRun.lean line 325) is `D.need x g c ≤ D.level x c`. Say "stands at least at its need", as Admission's `FitsBand` docstring does.
- (f) Lines 54–56, `Joint`: see finding 8.
- (g) Lines 45–46 and 551: `Options.no_order_contains_both` concerns this witness. On a determined process, realized widening gives widening what can be reached (`widens_of_rangeWidens`), so the conflict needs branching. Say "on this witness".
- (h) Lines 319–320: the `course` "giving the realized course from each configuration" is not required to start there. The laws about a configuration's realized course need `∀ s, (course s).state 0 = s` (as `Options.course_start` gives); B12 and W5 take it as a premise.

### 18. The modelling list omits what the probes turn on

*Class:* imprecision (minor).

*Location:* lines 59–62.

*Evidence and fix.* Add four items:
- (i) Courses are infinite runs. A configuration that starts no course is covered by every configuration, whatever either admits (B2 `DeadEnd.widens_reversed`).
- (ii) The whole possible and the possible within a horizon read finite traces, while covering reads infinite runs, so the two can disagree (B2). B1 links them under the premise that reachable configurations start courses.
- (iii) Formations are compared by name over one type `X`, fixed across steps, with no re-identification (the point UE9 makes for lags, `NamesAcrossSteps.lag_reads_names`).
- (iv) The realized course is a function on configurations (finding 17h).

### 19. Names

*Class:* style (minor).

- (a) "Narrows" (`Run.possible_narrows`, `Run.possible_narrows_add`, and the header's "The whole possible only narrows") states strict narrowing in the package's sense (`Clearing.narrows`), while the statements say that nothing is added. Use, for example, `Run.possible_of_next`, `Run.possible_of_later` and the header "Nothing is added to the whole possible". This one is needed before landing, because a name must state exactly what its statement means.
- (b) "What can be reached" and the namespace `Reaching`: the glossary's reach (及) is the transitive closure, which is `Possible`, whereas `Covers` and `Widens` compare families of infinite courses. A name that states courses is exact, for example "widening the open courses" with `Courses.Covers` and `Courses.Widens`. `Reaching` fits `Possible` and `PossibleWithin`.
- (c) `Covers` is the package's fourth `Covers`: `MoveOutcomeProcesses.Covers` (MoveOutcomeProcesses.lean line 62), `Becoming.Covers` itself (Locality.lean line 462, a list covering what holds at a step, so outside `namespace Reaching` the bare name means that one) and `GuardHorizon.Covers` (GuardHorizon.lean line 380). Nothing clashes (ProbeClash), but prose needs the namespace.
- (d) `Options` carries the financial sense that AGENTS.md rules out. The package's word is "alternatives", but `Becoming.Alternatives` is already a structure namespace (with `Alternatives.process`), so use something like `KeptAlternative`.
- (e) `Joint` shares its name with the module `Becoming.Joint` (joint differences of a dependence). Use something like `KeptTogether`.

### 20. The AdmitsAt bridge belongs beside AdmitsAt

*Class:* style (minor).

*Location:* lines 355–363.

*Evidence.* `Dependence.admitsAt_iff_admits_along` is `Iff.rfl` between LawAlongRun's `AdmitsAt` and Labelled's `Dependence.along` (Labelled.lean line 596), and nothing in the module uses it. The reading that bears on 07 is B8's: with fixed conditions, range inclusion and widening of courses are 07's `Web.Includes` and `Web.Widens`.

*Fix.* Move the bridge to LawAlongRun, beside `AdmitsAt` (its owner decides), and land B8's two `Iff.rfl` forms in this module.

### 21. Design claims the module does not meet

*Class:* imprecision (minor).

*Evidence.*
- Law 1's iff with exceeding (DESIGN line 47) gives Markov's principle (W3 `markov_of_designForm`, with `Markov` as in Horizon.lean line 367). The module's negative form is the constructive statement, so the design is the one to correct.
- Law 1's linear-time bullet (line 48) is not in the module. W1 is its witness (finding 15).
- Law 2's "What rises is what is near, not what is possible" (line 54) is not met (finding 2).
- Law 3's "a finite cycle keeps it fixed" (line 60) has no witness. B7 gives the one-configuration case of the converse.
- Law 4's C◇ (line 68) is an AI reading in the design, and becomes a definition after I2 (finding 7).
- Law 5's "instance of `Activation.same_marginals_lose_bundle`" (line 72) is not met at configurations (finding 8).
- §4's "the juncture where a loss happens is landed (`Becoming.Junctures`)" (line 77) is not connected. `Junctures` is stated for one configuration, and lists "junctures for sets of configurations or for profiles of several possibilities" as not derived (Junctures.lean lines 60–61). Losing a formation from the whole possible is losing a set of configurations, so it has no juncture yet. The link available is W4's `narrowing_not_returns` (a step that loses a possibility has no way back), the one-formation case of `lost_together_not_returns`.

## What holds

- The order laws (lines 94–183) are correct as stated and need no premise. `widens_iff_of_unique` is the right constructive form (W3).
- Law 2 holds in the non-strict sense, and `possibleWithin_moves` holds as stated. Law 3 holds as stated.
- `Options.disagree` and `Options.tie` show what their docstrings say. Their configurations are separate starts compared from offset `0`, with no shift between stages of one course. `Joint` proves its three theorems.
- No choice enters, and runs are built (`Run.cons`), never chosen. The module imports only core modules, and every axiom report is empty. It clashes with no name in the package or in UE9's kit (ProbeClash).

## Verdict

**Must change before landing.**
1. State that same-offset covering contains inclusion now (B12), and narrow 07's Open item with it. Neither the record nor 07 may suggest that candidate B in this form decides a range that keeps widening against one wider now (finding 1).
2. Correct `Rise.rises` and the header: nothing is added to the whole possible, and on the witness it is unchanged. Add the law linking covering to the whole possible with its premise (B1), and the dead-end witness (B2) (finding 2).
3. Say that the rise is the same-offset reading of the course's delay, and add `coversLater_next` (finding 3).
4. Bring `KeepsWidening` to 07's sense or rename it, and state law 3 for chains (finding 4).
5. Correct the credit. Covering is the Hoare preorder and unanimous flexibility, not option value, and quasi-option value is not captured (W1). Opportunity sets are matched by dominance, not set inclusion. Kauffman's adjacent possible is restated only for a prestated space (findings 5, 11 and 13).
6. Connect by instance theorems instead of duplicating: the possible as `WithinMoves`; law 2 from `together_after_reach`; law 3 shared with `Web.KeepsWidening.not_listed`; covering as `CarriesProfiles`; widening what can be reached as `Extension` on the frame of reachable ranges, so that C◇ is a definition; range inclusion as `Web.Includes` (findings 6 and 7).
7. `Joint`: make no claim that it instantiates `same_marginals_lose_bundle`, and say "together along a course" (finding 8).
8. Fix the words that state a wrong meaning: "narrows" (19a), "stands at its need" (17e), "on this witness" (17g) and the realized course's start (17h). Extend the modelling list (finding 18).

**Optional.**
- The lagged order (L1), if UE10 is to bear on 07's question, after UE9 lands (finding 1b).
- A branching witness for keeping the adjacent possible widening (finding 9).
- The generalizations: a greatest course, `X : Type w`, the lexical order on chosen courses, `widens_not_covered` (finding 10).
- The converse's failure for law 3 (finding 12).
- The remaining credit refinements (findings 14–16).
- The other names (19b–e).
- Moving the AdmitsAt bridge (finding 20).
- Correcting DESIGN.md (finding 21).
- W1 as the module's linear-time witness.
