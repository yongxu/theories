# EL4: giving that waits on giving, under selection

Design, 31 October 2026. AI-written. Part 4 of [EL](NOTE.md), whose board row claims it. Every target states its standing; proved means proved in the core Lean (`Becoming.WindowedWaiting`, `Becoming.PairSelection`, landed as core leaves at receipt 20261101T024359.312453Z, study section 490; [EL's State of the Lean](NOTE.md#state-of-the-lean)). It was first drafted as board item WS and held on branch `ws-claim` (`c72dee114`, kept since 2 November 2026 as `refs/salvage/branches/ws-claim`). That item was never claimed on main and is superseded by this text; the branch's board line is not to be merged. Revised after [EL's review](REVIEW-1.md), every finding on this part taken:
- the windowed law is named for what it is, not "memory", which in 05 means withholding that stays;
- the alternator that defeats a window is added;
- the offspring counts hold only while a formation is supported;
- "the same counts in either region" holds only over a horizon;
- the surplus has a third source, need asymmetry within the pair, so the "forbids" claim on it is withdrawn;
- the inflow-graded laws are reused;
- the cited laws' exact forms (weak favouring, the four-term iff, `withheld_kept`) are fixed;
- the carrier lift for windows and errors is stated;
- the citations are corrected;
- record names are made structural.

Revised again after the Lean rounds (§10 of [EL](NOTE.md#10-the-review-the-lean-rounds-and-what-changed)):
- the carrier is the whole history, with errors as a clock;
- (c), (d) and (e) are stated for the window sizes and steps proved;
- the forbidden conjunction of item 3 is one theorem for every window, and since round 4 for every error pattern spaced at two;
- the bridge to keeping inclusion is existential, and the reason is a theorem;
- the tables are theorems;
- the alternator's take is `⌈n/2⌉`, not `⌊n/2⌋`;
- (c) with errors holds as a law on pairs;
- the third source is the second's slack bound, read inside the pair.

Revised after round 4 and two text reviews (in [reviews/round3.json](reviews/round3.json)):
- `Seat` and `mate` are now `Place` and `other`;
- the strict forms of the echo and of complete assortment are theorems;
- `childless` is no longer vacuous;
- a factor read on a web is bounded under a supplied reading, and EL4c's witnesses are no longer said to bound `β` and `γ`;
- the one-step split is stated for laws keeping mutual giving;
- the factors' reading and the strict iffs are stated as the Lean has them.

It came from a question asked the same day: whether the account explains tit-for-tat with forgiveness.

## In brief

05 §5 proves how giving that waits on giving runs:
- with memory in 05's sense (`waitsAll`), a withholding is absorbed and stays;
- answering the last step (`answers`) returns it around a loop;
- tolerance across what a formation waits on passes a thin withholding out;
- restoring needs a formation that spares what it waits on.

04 proves the selection laws. Nothing joined them, and no law said which law of giving leaves more offspring.

- **EL4a, answering within a window** (proved). In a pair, 05's tolerance of one is giving whatever comes, so a pair passes a withholding out only through time.
  - Among the one-step laws of a pair that keep mutual giving and inclusion, restoring mutual giving after one withholding and answering a constant withholder exclude each other.
  - Among the laws keeping mutual giving, the one law doing both, agreement of one's own last step with the partner's, does not keep inclusion.
  - Answering within a window of two keeps inclusion and does both.
  - No window both absorbs one error and answers a formation erring at no two consecutive steps. The alternator, withholding at every other step, is its instance.
- **EL4b, offspring from what a run brings** (proved, for supplied factors). A pair's run gives each formation what its partner gave it and what it withheld. Read as offspring while it is supported, these feed the multilevel law with pairs as groups.
  - Under complete assortment, answering is weakly favoured exactly where `γ ≤ β`, raised strictly exactly where `γ < β`, and lowered strictly exactly where `β < γ`.
  - Where `β ≤ γ`, no kind rises against withholders in a cohort of pairs, whatever laws it holds and whatever the errors; answering is one case. Reading `β ≤ γ` as giving moving what it draws is an AI reading.
- **EL4c, where what a gift brings beyond what it draws comes from** (witnesses proved; joining them to `β` and `γ` open). There are three sources:
  - renewal from outside, bounded by its flux per step;
  - drawing from beyond the pair, bounded by the slack and the inflow;
  - need asymmetry within the pair, since support is a threshold. The Lean reads this third source as the second's slack bound, with the pair split into family (the receiver) and beyond (the giver).

  Read as a line's rise per step on a balanced web with no dependence beyond broken, a factor is bounded by the slack beyond and the inflow, under that supplied reading. No web statement compares `β` with `γ`, so the sign that decides EL4b's verdicts is not reached from the webs.

Readings, labelled AI, for the chapter and not as formal names:
- `answers` is tit-for-tat;
- `waitsAll` is grim trigger;
- answering within a window of two is tit-for-two-tats;
- agreement is win-stay lose-shift;
- giving whatever comes is unconditional cooperation;
- the window is a deterministic relative of forgiveness. Generous tit-for-tat forgives with a probability, which is not represented.

## 1. What is landed, exactly

| Law | Declaration | Use |
|---|---|---|
| Closed forms: under `waitsAll` a formation gives at `n` exactly where every formation within `n` waits gave at the start; under `answers`, where every formation exactly `n` waits upstream did | `Withholding.waitsAll_closed`, `answers_closed` | the runs read |
| On a loop of `p` waits a withholding returns at every multiple of `p` | `Withholding.withholding_returns` | a pair is a loop of two |
| For a law keeping inclusion, from total withholding it restores where it restores from every start; total withholding stays where nothing gives at the next step | `Tolerance.worst_start`, `restored_stays`, `withheld_kept` | stated for `next : (α → Prop) → α → Prop` run by `Law.run` |
| For the tolerating law: a formation sparing all it waits on gives from step 1; with none, total withholding stays | `Tolerance.sparing_gives`, `total_stays`, `gives_needs_sparing` | in a pair, tolerance one is sparing |
| More tolerance gives no less | `Tolerance.tolerating_mono` | the order a window should extend |
| Selection within and among groups of any sizes, the four-term iff | `SelectionLevels.levels_sized`, `rises_iff_sized` | pairs as groups of two |
| Weak favouring by what comes back to the carriers alone: `favours ↔ c ≤ s`; the strict cost law | `RuleShaping.favours_iff`, `disfavours_iff`; MA3a's strict law | complete assortment |
| A rise paid from beyond, graded by the inflow, breaking a dependence past the slack and the inflow | `Flow.Balances.rise_paid_from_beyond`, `rise_breaks_beyond`, `rise_le_inflow_beyond`, `rise_bounded_by_beyond_inflow`, `breaks_beyond_inflow`, `Flow.favours_breaking_beyond_inflow` | EL4c's second source |
| Selection within what flows in, bounded per step by what is carried in | `SelectionPace.selection_within_carried` | EL4c's first source |
| Support is a threshold, need at most level; only the supported leave descendants | `Supported`, `DescendsAt.supported`, `unsupported_childless` | EL4c's third source; offspring zero once unsupported |
| The selection term on offspring number never runs against it; none exactly where uniform | `Reproduction.never_against`, `none_iff_uniform` | neutrality |

Two facts from the definitions:
- `waitsAll up` is `answers` with each formation also waiting on itself.
- In a pair, `tolerating` with tolerance one is giving whatever comes (`AllBut.of_length_le`).

## 2. Purposes and connections

The purposes are UE and AJ, as for EL:
- **UE.** Evolutionary game theory's account of reciprocity is read on the account and bounded where it takes a fixed benefit beyond cost as given.
- **AJ.** Cooperation under error among humans and trained systems is giving that waits on giving, and how far a window reaches before a withholder draws on it is a question of the joint selection.

Output → input:
- **05 §5's runs → 04's offspring numbers.** This *advances* 04's open item "offspring numbers tied to what a formation gives, so the share laws' premise follows from the flow", for pairs on a supplied pairing with supplied factors. The derivation of the factors from the flow stays open. EL4c's witnesses and its bounds under a supplied reading do not reach it.
- **05's open "thresholds with memory".** Met for windows; amounts of giving stay open.

## 3. EL4a: answering within a window

**Carrier.** The state of a windowed law is the whole history, a configuration on `α × Nat`, where lag `i` holds the configuration `i` steps back. The law `answersWithin w up` writes lag `0` from the lags below `w` and shifts every other lag by one (lag `i` at step `m + i` is lag `0` at step `m`, `lag_shift`). Because every window lives on one carrier:
- `answersWithin` keeps inclusion there directly (`answersWithin_keeps`);
- it keeps inclusion into every wider window (`answersWithin_into`, `window_mono`);
- `worst_start`, `restored_stays` and `withheld_kept` apply as they stand.

Errors are folded into the state as a clock.
- They are a supplied pattern `e : Nat → α → Prop`. The state is `Nat × (α × Nat → Prop)`, and at time `t` the law `answersWithinErring e w up t` applies; it keeps inclusion at each time (`erring_keeps`).
- The clocked run from all giving carries its time and the configuration `erringRun` at each step (`clocked_state`).
- Configurations are Prop-valued, with no decision of giving. The one-step laws of (g) are on decided giving (`Bool`), joined to the Prop laws by bridges.
- Patterns are counted, not given a chance.

**Definitions.**
- `answersWithin w up`: a formation gives at lag `0` where each formation it waits on gave at some lag below `w`. A window of one is `answers` (`window_one`).
- The pair: two formations each waiting on the other (`Pair.Waits`), a loop of two (`Pair.loop`).

**Target laws.**
- (a) *Window one is `answers`* along every course. **Standing:** proved (`window_one`).
- (b) *Windowed laws keep inclusion.* **Standing:** proved: `answersWithin_keeps`, `answersWithin_into`, `window_mono` (a wider window gives no less), `window_worst_start` and `window_restored_stays` (restatements of `Tolerance`'s laws). Where every formation waits on some formation, total withholding is kept at every step and lag (`window_withheld_kept`).
- (c) *A thin withholding in time is absorbed.* **Standing:** proved, as an iff, on the clocked carrier. From all giving, where no formation errs at `w` consecutive steps (`Spaced`), every formation gives at every step exactly where it does not err (`gives_unless_errs`). This is exact: under a window of `w + 1`, `w + 1` consecutive errors at one formation from step `t` make every formation waiting on it withhold at step `t + w + 1`, the step after the last error (`errs_answered`). A window of zero is excluded, since it reads nothing.
- (d) *A constant withholder is answered within the window.* **Standing:** proved in the clocked form, with the bound reached; the unclocked form is proved, but its premise is met only in special runs.
  - *The clocked form.* Under a window of `w + 1`, suppose a formation errs at every step from `T`, so it withholds whatever comes. Then every formation waiting on it withholds at every step from `T + (w + 1)` (`withholder_answered_clocked`, a corollary of `errs_answered`).
  - *The bound is reached* in the pair at `T = 0` under a window of two. With the first erring at every step, the second gives at step 1 and withholds from step 2 (`Pair.withholder_answered_tight`).
  - *The unclocked form.* The same bound holds where the formation withholds at lag `0` at every step from `T` of the homogeneous run itself (`withholder_answered`).
    - That premise holds in total withholding, where `window_withheld_kept` meets it and gives the conclusion (`Pair.withholder_answered_holds`, a witness lemma that states the conclusion).
    - Away from total withholding, it holds in a line of three: a source withheld at every lag, a relay and a last. There the bound is reached too, at `T = 1` under a window of two, from step 3 (`Line.withholder_answered_reached`).
- (e) *A window never answers a formation giving at least once in every `w` steps.* **Standing:** proved, on the clocked carrier.
  - *The law.* Suppose a formation gives at lag `0` at least once in every `w` consecutive steps. Then at every step it gives at some lag below `w`, so whatever waits on it finds it in the window (`window_holds_of_gaps`). Where no formation errs at `w` consecutive steps, this holds of every formation (`spaced_window_holds`), and a formation that waits on another withholds only at its own errors (`gives_unless_errs`).
  - *The witness: the alternator under every window of at least two.* In the pair, the second errs at every even step (`Pair.secondErrsEven`). Under every window of at least two, the first gives at every step (`Pair.alternator_received_within`), and the second gives exactly at the odd steps (`Pair.alternator_gives_odd_within`). The spacing is carried to wider windows by `spaced_mono`. At the window of two this is the course of the Bool alternator (`Pair.alternator_received`, `Pair.alternator_gives_odd`, the `_within` forms at two, joined by `Pair.alternator_bridge`).
  - *Represented as errors.* One homogeneous `answersWithin` law cannot represent the alternator, which follows another law. It is represented as a window holder whose withholdings are an error pattern.
- (f) *Echo under `answers`, in a pair.* **Standing:** proved. From one withholding after mutual giving, at every even step the first withholds and the second gives, at every odd step the reverse (`Pair.echo`). So at every step exactly one gives (`Pair.exactly_one`), and the pair never gives together again without another error (`Pair.never_together`). This is `withholding_returns` at a loop of two (`Pair.echo_returns`).
- (g) *The one-step split.* **Standing:** proved by cases on decided giving (`Bool`), and joined to the Prop laws of the pair. It covers the eight one-step laws of a pair that keep mutual giving (`f true true = true`), each run between two holders of the law.
  - *The five keeping inclusion.* A table keeping mutual giving keeps inclusion exactly where it is one of five; the count is a statement (`pairKeepsInclusion_table_iff`). Each of the five either never restores after one withholding or never answers a constant withholder (`keeps_split`). Three never restore: giving after mutual giving only, answering, and repeating one's own step. Three never answer: withholding only after mutual withholding, giving always, and repeating one's own step.
  - *Agreement.* Among the laws keeping mutual giving, exactly one restores and answers a constant withholder: agreement, `f a b = (a == b)` (`restores_and_answers_iff`). It restores at step 2 (`agreement_restores_at_two`), withholds against a constant withholder at step 1 and gives there at every even step (`agreement_answers_at_one`, `agreement_against`), and does not keep inclusion (`agreement_not_keeps`). The premise of keeping mutual giving is needed for uniqueness. Without it, nor (`!a && !b`) goes from `(false, true)` to `(false, false)` to `(true, true)`, so it restores at step 2 and answers at step 1; that is a reviewer's hand check, not in the Lean.
  - *The window of two* keeps inclusion and does both (`windowTwo_keeps`, `windowTwo_restores`, `windowTwo_answers`).
  - *The bridges.* `partnerGave` runs the course of `answers` (`Pair.partnerGave_course`). The window of two runs the course of `answersWithin 2` (`Pair.windowStep_course`). Against a constant withholder it runs the clocked course with the withholder erring at every step (`Pair.windowAgainst_course`).
  - *The existential bridge.* A two-input law keeps inclusion exactly where some Prop law agreeing with it on decided giving induces a law on `Pair → Prop` that keeps inclusion (`Pair.pairKeepsInclusion_iff_induced`). The bridge is existential because it must be.
    - The disjunctive normal form of answering agrees with `partnerGave` (`Pair.agrees_dnf`). The law it induces keeps inclusion exactly under excluded middle (`Pair.dnf_keeps_iff_em`).
    - So if every agreeing law induced one keeping inclusion, excluded middle would hold (`Pair.all_agreeing_keeps_em`, one direction only).
    - These are lemmas of the bridge, calibrations of the logic and not results.
    - *What the need says.* This normal form's giving splits on the holder's own giving (given, or withheld by negation). Carrying the inclusion from `(False, True)` to `(P, True)` at the first decides `P`, so the normal form keeps inclusion only where that own giving is decided. That holds of this form, not of every law reading its own withholding by negation: by a verifier's probe, `(¬ A ∧ B) ∨ B` agrees with `partnerGave` and keeps inclusion with no excluded middle.

  Near-definitional (the monotone Boolean functions of two inputs). Its use is the split by keeping inclusion, which joins the landed restoring laws to the known strategies. The scratch check ([one_step_pair_laws.py](scratch/one_step_pair_laws.py), [output](scratch/one_step_pair_laws.out)) remains design evidence.
- (h) *No window both absorbs one error and answers a formation erring at no two consecutive steps.* **Standing:** proved, for every window `w` and every error pattern of the pair spaced at two (`Pair.not_absorbs_and_answers_spaced`).
  - *The law.* Suppose that in the pair, with the first erring at step `0` only (`Pair.firstErrsOnce`), the second gives at step 1. Then the window is at least two (`Pair.absorbs_needs_two`). So under every pattern in which no formation errs at two consecutive steps (`Spaced e 2`), every formation gives at every step at which it does not err (`gives_unless_errs`, through `spaced_mono`).
  - *The alternator* is its instance: beside the second erring at every even step, the first gives at every step (`Pair.not_absorbs_and_answers`, at `Pair.secondErrsEven`, through `Pair.alternator_received_within`).
  - *Each half is met apart.* One error is absorbed under every window of at least two (`Pair.window_absorbs_within`; at two, `Pair.window_absorbs`), and a window of one answers the alternator at every odd step (`Pair.alternator_answered_one`).

**Witnesses.**
- `Pair` in four runs:
  - under `answers`, the echo (`Pair.echo`);
  - under the clocked window of two with one error, absorbed (`Pair.window_absorbs`);
  - under agreement on decided giving, which restores at step 2 and does not keep inclusion;
  - against the alternator, on decided giving and on the clocked carrier, joined by `Pair.alternator_bridge`.
- The ring of three of `Becoming.Withholding`, under the clocked window of two with two consecutive errors (`ringTwoErrors_answered`).
- The line of three for the unclocked (d) (`Line.withholder_answered_reached`).

## 4. EL4b and EL4c: offspring from a run, and three sources

**What the factors stand for** [AI reading, as in the module]. Before any count: a giving moves something from the giver's condition to the receiver's. `β` and `γ` are readings of that relation, not a fixed benefit and cost owned by two parties.
- `β` is what a received step brings the receiver's support and descent.
- `γ` is what a withheld step keeps for the withholder's support and descent, so what a giving takes from the giver.
- `β ≤ γ` reads as giving moving what it draws.

EL4c's witnesses show where a gift brings support or a flux beyond what it draws. Joining them to `β` and `γ` is open, so here both factors are supplied. The bounds under a supplied reading in EL4c do not join them.

**Counts.** Over steps `0 … n − 1` of a pair's run (`course`, from a history of mutual giving, with a supplied error pattern), a formation has two counts:
- its received count `R`, the number of steps at which its partner gave it (`received`);
- its withheld count `K`, the number of steps at which it withheld (`withheld`).

A `Place` is a formation's place in a pair, and `Place.other` the other place.
- While it is supported, its offspring are `Place.offspring a β γ n = a + β·R + γ·K`, in natural numbers, with `a` positive where complete assortment is read. Once it is unsupported it has none (`unsupported_childless`).
- So the count model puts a lineage in going on only while its support lasts. That a formation is supported over the run is a premise of the reading, not checked in `PairSelection`; only EL4c's webs check support.
- No law here is of a course of generations.

From all giving before step 0, at `n = 20`, each `(R, K)` of the row's formation against the column's (`table_twenty`, by evaluation: a check of the closed forms, not a further law; first computed in [pair_counts.py](scratch/pair_counts.py), [output](scratch/pair_counts.out)):

| row \ against | sparer | answers | window 2 | agreement | grim | withholder | alternator |
|---|---|---|---|---|---|---|---|
| sparer | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 0) | (10, 0) |
| answers | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 19) | (10, 10) |
| window 2 | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 18) | (10, 0) |
| agreement | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 10) | (10, 10) |
| grim | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 19) | (10, 19) |
| withholder | (20, 20) | (1, 20) | (2, 20) | (10, 20) | (1, 20) | (0, 20) | (10, 20) |
| alternator | (20, 10) | (10, 10) | (20, 10) | (10, 10) | (1, 10) | (0, 10) | (10, 10) |

With one error at step 5 of 20, between two holders of one law (`error_table_twenty`):

| law | (R, K) of the erring formation | (R, K) of its partner |
|---|---|---|
| sparer | (20, 1) | (19, 0) |
| answers | (13, 8) | (12, 7) |
| window 2 | (20, 1) | (19, 0) |
| agreement | (19, 2) | (18, 1) |
| grim | (6, 15) | (5, 14) |
| withholder | (0, 20) | (0, 20) |
| alternator | (10, 11) | (9, 10) |

**EL4b, target laws.**
- (a) *The counts are theorems of the runs*, for every `n`. **Standing:** proved for the laws above (`counts_giving`, `counts_*_withholding`, `counts_*_alternating`).
  - With one error at any step `t`: `counts_windowed_error`, `counts_answering_error`, `counts_waitingBoth_error` and `counts_agreeing_error`, through `meets_after`.
  - Under the window with any errors, the run of two window holders is the clocked course of EL4a (`windowed_course`). Where no formation errs at two consecutive steps, each withholds exactly at its errors (`counts_windowed_spaced`).
  - Shown only at `n = 20`: agreement against the alternator (`table_twenty`), and one error for the sparer, the withholder and the alternator (`error_table_twenty`).
- (b) *Pairs as groups of two.* **Standing:** proved.
  - *The exact condition.* In counts, a kind rises exactly where its members' mean offspring exceeds the others' (`kind_rises_iff`). For a cohort of `x` answerer pairs, `y` mixed pairs and `z` withholder pairs, the exact condition over `n ≥ 1` steps is `answering_rises_iff`, read through that mean law.
  - *The four-term law.* `SelectionLevels.rises_iff_sized` is restated for families listed by pairs (`pairs_rises_iff`, a wrapper). None of its four terms is evaluated on the cohort.
  - *Two pair laws.* Among-pair discordance can be positive, at one point (`among_discord_witness`, a check by evaluation). Over `n ≥ 1` steps, a mixed pair's sum exceeds an answerer pair's exactly where `β < γ` (`mixed_exceeds_iff`).
  - *Complete assortment.* The pairs' offspring are the rule after shaping, with `s = βn`, `c = γn`, `p = 0` (`assorted_counts`). For `n > 0`, these follow as corollaries of `RuleShaping`'s laws with `n` cancelled:
    - answering is weakly favoured exactly where `γ ≤ β` (`assorted_favours_iff`, by `RuleShaping.favours_iff`);
    - it is raised strictly exactly where `γ < β` (`assorted_raises_iff`);
    - it is weakly disfavoured exactly where `β ≤ γ` (`assorted_disfavours_iff`);
    - it is lowered strictly exactly where `β < γ` (`assorted_lowers_iff`);
    - at `γ = β` the share is left as it is (`assorted_neutral`).
- (c) *With `β ≤ γ`, no kind rises against withholders.* **Standing:** proved; with errors, in the form of a law on pairs. Reading `β ≤ γ` as giving moving what it draws is an AI reading.
  - *Without errors of its own.* With `β ≤ γ`, an answerer without errors of its own leaves at most `a + γ·n`, a withholder at least that (`Place.answerer_le`, `Place.withholder_ge`). So where every answerer has no errors of its own (its partner may hold any law and err) and every other place withholds, answering does not rise (`answering_never_rises`).
  - *With errors.* The member-by-member law fails: over `n ≥ 1` steps, an answerer erring at every step beside an answerer leaves `β` more than a withholder beside a withholder (`erring_answerer_exceeds`). The law on pairs holds. With `β ≤ γ`, in every cohort listed as pairs whose places not of the kind withhold, the kind does not rise, whatever laws it holds and whatever the errors (`never_rises_in_pairs`; a pair leaves at most `2·(a + γ·n)`, `pair_le`). Answering is one case.
  - The hypotheses hold together, without and with errors (`cohort_never_rises`, `erring_cohort_never_rises`).
- (d) *A window against answering.* **Standing:** proved under complete assortment, on the pairs' own offspring and in mixed pairs with alternators; the exact iff for a mixed cohort under a supplied error pattern is open.
  - *Beside withholders.* Over `n ≥ 2` steps, a withholder beside a window holder leaves `β` more than beside an answerer (`withholder_beside_window`).
  - *The echo.* With one error by the first at step `t`, over `t + (m + 1)` steps, the echo moves `m` steps from receiving to withholding: `(β − γ)·m` in offspring (`echo_and_window_sums`).
    - On the pairs' own offspring, for `m > 0` and any `a`, a window pair leaves strictly more than an answerer pair exactly where `γ < β`, and strictly less exactly where `β < γ` (`window_echo_lt_iff`, a corollary).
    - Under complete assortment, with one error a pair and `m > 0`, windowed waiting is weakly favoured against answering exactly where `γ ≤ β` (`window_echo_favours_iff`, a wrapper).
    - Selection raises the window pairs' share strictly exactly where `γ < β`, and lowers it strictly, the echo selected for, exactly where `β < γ` (`window_echo_select_iff`, a wrapper of `assorted_raises_iff` and `assorted_lowers_iff`, through `window_echo_shaped`).
  - *The alternator.* Against a window holder an alternator leaves `γ·⌈n/2⌉` (`γ · half (n + 1)`) more than a window holder beside another window holder (`alternator_beside_window`). The window holder beside it leaves `β·⌈n/2⌉` less than beside a window holder (`window_beside_alternator`), and `(β + γ)·⌈n/2⌉` less than the alternator (`window_below_alternator`).
  - *Mixed pairs.* In mixed pairs of window holders and alternators, the window never rises, whatever `β` and `γ` (`window_never_rises_beside_alternators`). Under complete assortment, window pairs against alternator pairs are weakly favoured exactly where `γ ≤ β` (`window_alternator_favours_iff`).
  - That this is the known reason a window of two is not stable is a reading; no stability law is stated.
- (e) *Neutrality without withholding.* **Standing:** proved (`neutral`). Where every place's laws give after mutual giving and none errs, every place leaves `a + β·n`. So concordance and discordance are both zero for any amount, and their shares move only by drift (04 §6). Each arc of the known cycle is a law here; the cycle as a course is not, since it needs Wright–Fisher with selection.

**EL4c, three sources of what a gift brings beyond what it draws.** **Standing:** one witness each for (i) and (iii); the bounds of (ii) and (i) are landed laws; bounds of a factor read on a web under a supplied reading are proved; joining the witnesses to `β` and `γ`, and the general laws below, are open.
- (i) *Renewal from outside.* A condition given to by a renewer whose giving does not require it. Selection then is bounded not by a stock but by the flux carried in per step (`SelectionPace.selection_within_carried`, landed; not yet applied to these runs).
  - *The witness* (`Renewed`). A renewer whose giving does not require its own level (`renewer_free`) gives the giver one unit a step, and the giver gives the receiver one unit a step. The giver gives at every step, both stay supported, the giver's level never falls, and over any `N` steps the gifts total `N`, which is the inflow into the pair (`renewal_carried`, `inflow_one`). The gift carries renewal the giver does not need.
  - *Open.* That a gift brings more than it draws on the giver only by carrying a flux in.
- (ii) *Drawing from beyond the pair.* On a balanced flow, what the pair's family gains is bounded by what the beyond loses plus the inflow (`rise_bounded_by_beyond_inflow`); the part the inflow covers need not be drawn from beyond.
  - Past the slack and the inflow, a dependence beyond breaks (`breaks_beyond_inflow`), and a selection rewarding the rise favours the break (`favours_breaking_beyond_inflow`).
  - Where the beyond is renewal gated on what it renews, pairs drawing past it end with it, whatever their counts (05 §1, and EL3's degeneration law on lineages).
  - These laws are landed; their reading on these runs is not built.
- (iii) *Need asymmetry within the pair.* Support is a threshold.
  - *The witness* (`Needs`). It is a balanced pair into which nothing flows (`Needs.balances`; `Needs.closed`, inflow zero at every step). The giver takes part at every step, and across step 1, where it is active, gives a child one unit drawn from a pool beyond the pair. With needs one and two, one unit moved from the giver at level two to the receiver at level one makes the receiver supported and leaves the giver supported: the supported formations go from one to two (`asymmetry_gains`). With needs two and two the same move only moves support (`symmetry_moves`).
  - *A contrast in descent too.* The giver is present at every step after its gift. Under needs two and two it is unsupported there and so leaves no descendant across any of them (`Flow.unsupported_childless`); under needs one and two the child descends from it across step 1 (`Needs.childless`). The child's unit comes from the pool. So this shows that the giver's support decides whether it can give, not that the pair supplies the unit.
  - *The third source as the second's bound.* Read with the receiver as the family and the giver as the beyond, the symmetric gift breaks the giver's dependence (`symmetric_breaks`). With needs one and two, the rise is exactly the giver's slack above its need, with nothing flowing in and the giver's dependence kept (`asymmetric_within_slack`). So the third source is the slack bound of the second, with the pair split into family and beyond. Whether the record counts three sources or two bounds is its decision.
  - Food sharing among vampire bats (Wilkinson 1984) is the classical case of this asymmetry; it is to be read before any record cites it.
- *A factor read on a web.* Read a factor as the per-step rise of a line on a balanced web, with no dependence beyond broken.
  - *The bounds.* `β·R` is at most the slack beyond and the inflow, summed over the received steps (`Place.received_factor_le`); `γ·K` likewise over the withheld steps (`Place.withheld_factor_le`). Where at those steps the beyond stands at its needs and nothing flows in, a place that received has `β = 0` (`Place.received_factor_zero`, a corollary). All come from `rise_le_slack_inflow`, the contrapositive of the landed `breaks_beyond_inflow`, summed over the counted steps.
  - *What they rest on.* The reading is a hypothesis of these laws, so they are bounds under a supplied reading, not laws of the runs. By a verifier's probe the reading is met on `Needs` with `β = 1`, so the bound is not vacuous.
  - *What they do not reach.* No statement makes the pair's run a flow on a web or derives `Place.offspring` from one. Both bounds have the same form, and no web statement compares `β` with `γ`. So the sign of `β − γ`, which decides every EL4b verdict, is not reached from the webs.

*Over a horizon* (EL1's form). **Standing:** open; no law of `PairSelection` is of a course of generations. The target is a pair of courses for every horizon `H`. They agree on `R`, `K`, `β`, `γ` and the selection verdict for `H` generations, while one lies in going on and the other ends on every branch. Source (ii) with gated renewal, against source (i) or (iii), is the intended pair. If it holds, within any horizon a giving selected within pairs neither goes on nor ends by its selection.

## 5. What it would forbid (candidates for review)

1. Restoring and retaliating in a pair by any one-step law keeping mutual giving and inclusion (EL4a (g)). **Proved:** `keeps_split`, `restores_and_answers_iff`, `agreement_not_keeps`.
2. Restoring mutual giving from total withholding by any law keeping inclusion where nothing gives at the next step (landed, `withheld_kept`). Read with windows: where every formation waits on some formation, no window restores from total withholding. **Proved:** `window_withheld_kept`.
3. A window that both passes out an isolated withholding and answers a formation erring at no two consecutive steps (EL4a (h)). **Proved:** `Pair.not_absorbs_and_answers_spaced`, through `Pair.absorbs_needs_two` and `gives_unless_errs`.
   - Under every window, where in the pair one error at step 0 leaves the other giving at step 1, every formation gives at every step at which it does not err, under every pattern spaced at two.
   - The alternator, withholding at every other step, is the instance `Pair.not_absorbs_and_answers`.
   - Each half is met apart: a window of two absorbs (`Pair.window_absorbs`), and a window of one answers the alternator at every odd step (`Pair.alternator_answered_one`).
   - "Resists" in the draft was ambiguous: a window resists the alternator only in the sense of never answering it, and it cannot avoid that. The forbidden conjunction is absorbing and answering.
4. A fate of the pairs read off their selection, within any horizon (EL4c, over a horizon). **Open.**

The draft's first item, "a fixed benefit beyond cost with no account of its source", is withdrawn. Source (iii) gives one inside the pair, and it is bounded as the slack bound of (ii) read there. A factor read on a web is bounded by the slack beyond and the inflow, under a supplied reading. The account does not derive the formula's factors, and does not compare them from a web.

## 6. Modelling choices on which the laws depend

- Discrete steps.
- Giving all-or-nothing per formation per step: decided (`Bool`) in the one-step laws and in `PairSelection`'s runs, which are bridged to `Prop` for `windowed_course`; Prop-valued on configurations.
- A supplied pairing or waiting relation, fixed over the run.
- The window's carrier is the whole history at every lag (`α × Nat`), of which the law reads the lags below `w`.
- Errors are supplied patterns, counted, not given a chance, and read by a clock carried in the state. An error turns an intended giving into withholding at that step, and nothing else.
- The start's history is all giving.
- Offspring are `a + β·R + γ·K` while supported, a supplied formula with natural factors, and none once unsupported. Support over the run is a premise of the reading.
- Generations are read one at a time.
- EL4c's webs are single small witnesses with constant or few-valued levels, not general laws of renewal or need. In `Needs` the child's unit comes from a pool beyond the pair.
- A factor read on a web is a supplied reading: the per-step rise of a line, with no dependence beyond broken.

## 7. What it does not show

- That giving, a window or any law of giving is better (the ethics' two premises: the continuation condition for scope, C for order).
- How waiting forms, or how a pairing comes about.
- Probabilities, and so not generous tit-for-tat's probabilistic forgiveness.
- That any actual organism, institution or trained system meets the counts.
- Amounts of giving, mutual best responses, stability, or the cycle as a course.
- Any law over a horizon of generations.
- Agreement against the alternator for general `n`. One error for the sparer, the withholder and the alternator for general `n` and `t`.
- The exact iff for a mixed cohort of windows, answerers, withholders and alternators under a supplied error pattern, beyond `kind_rises_iff`. The four terms of `pairs_rises_iff` in closed form on the cohort.
- Joining EL4c's witnesses to `β` and `γ`. That needs three things: a model of the pair's run as a flow on a web, offspring derived from it with support over the run, and a constant rise per step. Nor is any comparison of `β` with `γ` from a web shown.

## 8. Placement

**Modules.**
- *The windowed law* (`answersWithin`, the carrier and `window_one`) is in `Becoming.WindowedWaiting`, above `Tolerance` (its only import besides `Init`). It goes below `Withholding` only on that module's owner's yes (named in its history row), and there it would lose `Tolerance`'s laws; otherwise it stays above `Tolerance`.
- *Errors, the pair witnesses, the alternator and the one-step split* go in `Becoming.WindowedWaiting`, which uses `Pair`, `answers` and `withholding_returns`.
- *EL4b and EL4c* go in the leaf `Becoming.PairSelection`, importing `WindowedWaiting`, `SelectionLevels`, `RuleShaping` and `DrawnBeyond`. `SelectionPace` is not imported, since its law is not applied to these runs. It is a leaf because nothing below reads offspring from giving. It lands against EL4a's final `WindowedWaiting` bytes.

**Records** (working titles, structural):
- a-pair-tolerates-only-within-a-window (EL4a), home 05 §5;
- offspring-read-from-giving-that-waits (EL4b), home 05 §5;
- what-giving-that-waits-draws-on (EL4c), home 05 §6.

The records count these as lemmas, wrappers, corollaries, bounds under a supplied reading, or checks, not results:
- *lemmas:* `answersWithholder_at_one`, `window_worst_start`, `window_restored_stays`, `windowAgainst_withholds_of_clocked`; `dnf_keeps_iff_em`, `dnf_keeps_em` and `all_agreeing_keeps_em`, the lemmas of the bridge;
- *instances:* `not_absorbs_and_answers` and the window-two forms;
- *wrappers:* `pairs_rises_iff`, `window_echo_favours_iff`, `window_echo_select_iff`;
- *corollaries:* `window_echo_lt_iff`, the `assorted_*` corollaries, `kind_rises_iff`, `window_alternator_favours_iff`, `rise_le_slack_inflow`, `Place.received_factor_zero`;
- *bounds under a supplied reading:* `Place.received_factor_le`, `Place.withheld_factor_le`;
- *checks:* the tables and `among_discord_witness`.

**Order and checks:** as in [EL §9](NOTE.md#9-coordination-order-and-the-release-gate).

## 9. Sources to check before any record cites them

Cited from memory for orientation; each is read before it is cited. Checked at the landing (1 November 2026) against the published records, titles, venues and abstracts: Trivers 1971, Axelrod and Hamilton 1981, Axelrod 1984, Kraines and Kraines 1989, Molander 1985, Nowak and Sigmund 1992 and 1993, Imhof, Fudenberg and Nowak 2005, Wilkinson 1984 and Wu and Axelrod 1995 are as cited (Nowak and Sigmund 1993's title is "A strategy of win-stay, lose-shift that outperforms tit-for-tat in the Prisoner's Dilemma game"); Boyd 1989 is on contrite tit-for-tat and strong perfect equilibrium, not on the window's instability (the invasion of tit-for-tat through tit-for-two-tats is Boyd and Lorberbaum 1987), so no record cites it:
- Trivers 1971 (reciprocal altruism);
- Axelrod and Hamilton 1981; Axelrod 1984 (tit-for-two-tats);
- Wilkinson 1984 (food sharing in vampire bats);
- Molander 1985 and Nowak and Sigmund 1992 (generous tit-for-tat, probabilistic, a relative of the window);
- Boyd 1989 (mistakes and stability);
- Kraines and Kraines 1989 (Pavlov) and Nowak and Sigmund 1993 (win-stay lose-shift);
- Wu and Axelrod 1995 (noise);
- Imhof, Fudenberg and Nowak 2005 (cycles).

## 10. Result block

```text
Result(s): giving-that-waits-on-giving, restoring-giving-from-the-worst-start, thresholds-of-waiting,
  tolerance-monotone-across-laws; selection-within-and-among-groups-of-any-sizes; what-a-rise-draws-
  from-beyond, a-rise-past-the-inflow-is-drawn-from-beyond; pace-of-selection-within-what-flows-in;
  what-bounds-offspring-numbers. Reused, none restated.
Delta: windows on the whole-history carrier, errors as a clock; absorption as an iff with its exact
  bound; the clocked constant withholder, bound reached; the alternator under every window of at
  least two; no window both absorbs one error and answers a formation erring at no two consecutive
  steps, the alternator its instance; the one-step split of the laws keeping mutual giving by
  keeping inclusion, with agreement the one law restoring and answering, bridged to the Prop laws,
  the bridge existential exactly as excluded middle requires; counts of the runs for every n;
  pairs on the multilevel law through the mean law, with weak favouring exactly where γ ≤ β and
  strict raising and lowering under complete assortment, and no rise of a kind against withholders
  where β ≤ γ in cohorts of pairs under any laws and errors; the window against answering, strict
  on the pairs' own offspring, and beside alternators; witnesses of need asymmetry (the slack
  bound inside the pair, with a contrast in descent) and of renewal from outside; bounds of a
  factor read on a web under a supplied reading.
Supplied premises / correspondence: §6; β and γ supplied (EL4c's witnesses are not joined to them).
Evidence: core Lean, Becoming.WindowedWaiting and Becoming.PairSelection, landed at receipt
  20261101T024359.312453Z (EL's State of the Lean); the records a-pair-tolerates-only-within-a-window,
  offspring-read-from-giving-that-waits and what-giving-that-waits-draws-on; the scratch enumeration and counts in scratch/, for the design only.
Boundary: §7.
Integration: 04 Open "offspring numbers tied to what a formation gives" (advanced: pairs, supplied
  factors); 05 Open "thresholds with memory" (windows).
```

## 11. EL7: what the investigations found, and what stops

AI-written, 5 November 2026, board item EL7 ([Ren, 3 November 2026](../../../../../../sources/15-codex-theory-conversations/2026-11-03-evolution-frontier-worth-doing.md)). Four investigations of §7's open lines, each read by an independent skeptic who compiled its Lean and checked its sources (their reports, scratch Lean and checks were kept on branch `el7-kit`). None found a theorem a specialist would not foresee or a test that could fail; what survives is five corrections to what readers are told, landed as they are ready.

- **Mixed cohorts, chance and stability: stop.** Offspring read from a pair's run are the repeated donation game's payoffs plus `a + γ·n` (`b = β`, `c = γ`), so the cohort condition is the covariance form of Hamilton's rule and the four pair terms are the two-level Price partition, `β + γ` within pairs and `|β − γ|` among them. The one-step law doing both is close to win-stay lose-shift's uniqueness among memory-one strategies (Hilbe, Martinez-Vaquero, Chatterjee and Nowak 2017). With one-way errors drawn by chance, every pair whose laws keep mutual withholding, the window among them, ends in total withholding, as any chain with a reachable absorbing state does: a delay, not forgiveness. Stability and best responses are the field's frames and it computes them already.
- **The offspring factors from a flow: done, near-definitional.** On a pair's run read as a balanced flow, `β` and `γ` follow from what of a gift reaches the receiver's line and what of a kept gift reaches the keeper's; renewal reaching both alike leaves `β = γ`. The list of sources of a gift's surplus is exhaustive only at the level of balance, where it is near-definitional, so the hunt for further sources stops.
- **A lineage's fate: stop beyond the correction.** Selection on a draw past a renewal can end a lineage that the same start without selection carries on; that is evolutionary suicide, known (Gyllenberg, Parvinen and Dieckmann 2002; Ferrière and Legendre 2013), with offspring numbers still supplied. The gated lineage law never uses its gate, which corrects what 04 §4 and 05 §1 say of renewal from outside. Two fates for every course on the World, and multiplying takers in general, are foreseeable construction that would change no reader's belief.
- **A test that could fail: none on this line.** Each case the evolution line forbids is a counting identity, a balance or existence claim over flows, or a constraint on a rule or factor read from the same outcome it constrains; where it meets the world with content it borrows T1's gate and need measured in advance, tested by T1N and T1R. The field's own models predict the same in every candidate read, so a result would show nothing about this account.

These stop as research until a premise derived from something weaker, or a measurement taken independently of the outcome, changes them; a limit stated here holds so far, dated, for these reasons.
