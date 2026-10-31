# EL4: giving that waits on giving, under selection

Design, 31 October 2026. Nothing here is proved. AI-written. Part 4 of [EL](NOTE.md), whose board row claims it. First drafted as board item WS, held on branch `ws-claim` (`c72dee114`), never claimed on main and superseded by this text; that branch's board line is not to be merged. Revised after [EL's review](REVIEW-1.md), every finding on this part taken:
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

It came from a question asked the same day: whether the account explains tit-for-tat with forgiveness.

## In brief

05 §5 proves how giving that waits on giving runs: with memory in 05's sense (`waitsAll`) a withholding is absorbed and stays; answering the last step (`answers`) returns it around a loop; tolerance across what a formation waits on passes a thin withholding out; restoring needs a formation that spares what it waits on. 04 proves the selection laws. Nothing joins them, and no law says which law of giving leaves more offspring.

- **EL4a, answering within a window** (core). In a pair, 05's tolerance of one is giving whatever comes, so a pair passes a withholding out only through time. Among the one-step laws of a pair that keep inclusion, restoring mutual giving after one withholding and answering a constant withholder exclude each other. The one one-step law doing both, agreement of one's own last step with the partner's, does not keep inclusion. Answering within a window of two keeps inclusion and does both, and it never answers a formation that withholds at every other step.
- **EL4b, offspring from what a run brings** (core). A pair's run gives each formation what its partner gave it and what it withheld. Read as offspring while it is supported, these feed the multilevel law with pairs as groups.
- **EL4c, where what a gift brings beyond what it draws comes from** (core). There are three sources, which part on the map, not in the counts: renewal from outside, bounded by its flux per step; drawing from beyond the pair, bounded by the slack and the inflow; and need asymmetry within the pair, since support is a threshold.

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
- **05 §5's runs → 04 §5's offspring numbers.** This *advances* 04's open item "offspring numbers tied to what a formation gives, so the share laws' premise follows from the flow" for pairs on a supplied pairing with supplied factors. The derivation of the factors from the flow stays open, except for the bound EL4c gives.
- **05's open "thresholds with memory".** Met for windows; amounts of giving stay open.

## 3. EL4a: answering within a window

**Carrier.** The state of a windowed law is the last `w` configurations, a configuration on `α × Fin w`, with a shift law: the new configuration is the law's, the rest shift by one. Inclusion of windows is inclusion on that carrier (a lemma), so `KeepsInclusion`, `worst_start` and `restored_stays` apply through the lift. Errors, a supplied pattern `e : Nat → α → Prop` turning an intended giving into withholding, are folded into the state as a time counter, or stated by a time-indexed form of `KeepsInclusion`. Which of the two is decided in the Lean, and named in (a) and (b). Configurations are Prop-valued, with no decision of giving. Patterns are counted, not given a chance.

**Definitions.**
- `answersWithin w up`: a formation gives at the next step where each formation it waits on gave at some step of the window. `answersWithin 1` is `answers`.
- The pair: two formations each waiting on the other (`Pair.Waits`), a loop of two.

**Target laws.**
- (a) Window one is `answers` along every course, through the lift.
- (b) Windowed laws keep inclusion on the lifted carrier.
- (c) *A thin withholding in time is absorbed.* From all giving, where no formation errs at `w` consecutive steps, every formation gives at every step at which it does not err. This is exact: `w` consecutive errors at one formation make those waiting on it withhold at the next step.
- (d) *A constant withholder is answered within the window.* Where a formation withholds at every step from `T`, every formation waiting on it withholds at every step from `T + w`.
- (e) *A window never answers a formation giving at least once in every `w` steps.* In a pair under `answersWithin 2`, a formation withholding at every other step receives at every step and gives at half of them.
- (f) *Echo under `answers`, in a pair.* One error from mutual giving leaves exactly one formation giving at each later step, so the pair never gives together again without another error. This is a case of `withholding_returns` at `p = 2`, with the exact alternation.
- (g) *The one-step split.* Of the eight one-step laws of a pair that keep mutual giving, each run between two holders of the law:
  - the five keeping inclusion either never restore after one withholding (giving after mutual giving only, answering, repeating one's own step) or never withhold against a constant withholder (withholding only after mutual withholding, giving always);
  - exactly one restores and answers a constant withholder: agreement, which restores in two steps, gives at every other step against a constant withholder, and does not keep inclusion;
  - answering within a window of two keeps inclusion and does both.

  This is checked in scratch for the design only ([one_step_pair_laws.py](scratch/one_step_pair_laws.py), [output](scratch/one_step_pair_laws.out)), and is to be proved in Lean by cases on the finite carrier. Standing: near-definitional (the monotone Boolean functions of two inputs). Its use is the split by keeping inclusion, which joins the landed restoring laws to the known strategies.

**Witnesses.**
- `Pair` under `answers` (echo), under `answersWithin 2` (absorbed), under agreement (restores, does not keep inclusion), and against the alternator.
- A ring of three under `answersWithin 2` with two consecutive errors.

## 4. EL4b and EL4c: offspring from a run, and the three sources

**What the factors stand for.** Before any count: a giving moves something from the giver's condition to the receiver's. `β` and `γ` are readings of that relation, not a fixed benefit and cost owned by two parties. `β` is what a received giving does to the receiver's support and descent; `γ` is what giving does to the giver's. EL4c derives them, or bounds them, from the flow wherever the join reaches.

**Counts.** Over steps `0 … n − 1` of a pair's run, a formation's received count `R` is the number of steps at which its partner gave it; its withheld count `K` is the number of steps at which it withheld. While a formation is supported its offspring are `a + β·R + γ·K` (natural numbers, `a` positive); once it is unsupported it has none (`unsupported_childless`). So the count model puts a lineage in going on only while its support lasts. EL4b's laws are stated for a horizon of generations within which every formation counted is supported.

From all giving before step 0, at `n = 20` ([pair_counts.py](scratch/pair_counts.py), [output](scratch/pair_counts.out)), each `(R, K)` of the row's formation against the column's:

| row \ against | sparer | answers | window 2 | agreement | grim | withholder | alternator |
|---|---|---|---|---|---|---|---|
| sparer | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 0) | (10, 0) |
| answers | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 19) | (10, 10) |
| window 2 | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 18) | (10, 0) |
| agreement | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 10) | (10, 10) |
| grim | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (20, 0) | (0, 19) | (10, 19) |
| withholder | (20, 20) | (1, 20) | (2, 20) | (10, 20) | (1, 20) | (0, 20) | (10, 20) |
| alternator | (20, 10) | (10, 10) | (20, 10) | (10, 10) | (1, 10) | (0, 10) | (10, 10) |

With one error at step 5 of 20, between two holders of one law:

| law | (R, K) of the erring formation | (R, K) of its partner |
|---|---|---|
| answers | (13, 8) | (12, 7) |
| window 2 | (20, 1) | (19, 0) |
| agreement | (19, 2) | (18, 1) |
| grim | (6, 15) | (5, 14) |

**EL4b, target laws.**
- (a) *The counts are theorems of the runs*, for every `n`, the windows and the pair laws above.
- (b) *Pairs as groups of two.* `SelectionLevels.rises_iff_sized`, with all four terms (discordance and concordance within pairs and among them), read on these counts, gives the exact condition for answering to rise in a cohort of answerer and withholder pairs. Among-pair discordance can be positive: a mixed pair's mean can exceed an answerer pair's where `γ` is large. Under complete assortment the case is `RuleShaping.favours_iff` with `s = βn`, `c = γn`, `p = 0`: for `n > 0`, answering is weakly favoured exactly where `γ ≤ β`, and rises strictly exactly where `γ < β` (MA3a's strict law). At `γ = β` nothing is selected.
- (c) *Where giving moves what it draws, answering never rises without errors.* With `β ≤ γ` and no errors, in every cohort of answerer and withholder pairs, every answerer leaves at most every withholder. With errors this fails as stated: an answerer withholding by error at every step, beside an answerer, leaves `β` more than a withholder beside a withholder. The law with errors is to be found.
- (d) *A window against answering.* In a cohort with a supplied error pattern, a window of two rises against answering exactly where what echoes take from answerer pairs outweighs what constant withholders and alternators take from window holders. Window holders give withholders one step more than answerers do, and give alternators every step. The exact iff, in counts, is the target. With alternators in the cohort a window is exploited wherever `γ > 0`: against a window holder an alternator leaves `γ·⌊n/2⌋` more than a window holder beside another window holder. This is the known reason a window of two is not stable.
- (e) *Neutrality without withholding.* Where no formation withholds and none errs, every law keeping mutual giving leaves alike (`none_iff_uniform`), and their shares move only by drift (04 §6). Each arc of the known cycle is a law here; the cycle as a course is not, since it needs Wright–Fisher with selection.

**EL4c, the three sources of `β > γ`.**
- (i) *Renewal from outside.* A condition given to by a renewer whose giving does not require it. Selection then is bounded not by a stock but by the flux carried in per step (`SelectionPace.selection_within_carried`). A gift brings its receiver more than it draws on the giver only by carrying that flux into the receiver's condition. The mechanism is the witness to build: a giver whose condition is renewed from outside, so that giving moves renewal the giver does not need.
- (ii) *Drawing from beyond the pair.* On a balanced flow what the pair's family gains is bounded by what the beyond loses plus the inflow (`rise_bounded_by_beyond_inflow`); the part the inflow covers need not be drawn from beyond. Past the slack and the inflow a dependence beyond breaks (`breaks_beyond_inflow`), and a selection rewarding the rise favours the break (`favours_breaking_beyond_inflow`). Where the beyond is renewal gated on what it renews, pairs drawing past it end with it, whatever their counts (05 §1, and EL3's degeneration law on the lineages).
- (iii) *Need asymmetry within the pair.* Support is a threshold. One unit moved from a giver standing above its need to a receiver just below its own makes the receiver supported and leaves the giver supported. In offspring that is `β > γ` with nothing drawn from beyond the pair. The witness to build: two formations with needs one and two sharing levels within a balanced closed pair. Food sharing among vampire bats (Wilkinson 1984) is the classical case of this asymmetry; it is to be read before any record cites it.

*Over a horizon* (EL1's form). For every horizon `H`, two courses can agree on `R`, `K`, `β`, `γ` and the selection verdict for `H` generations while one lies in going on and the other ends on every branch. Source (ii) with gated renewal against source (i) or (iii) gives the pair. So within any horizon, a giving selected within pairs neither goes on nor ends by its selection.

## 5. What it would forbid (candidates for review)

1. Restoring and retaliating in a pair by any one-step law keeping inclusion (EL4a (g)).
2. Restoring mutual giving from total withholding by any law keeping inclusion where nothing gives at the next step (landed, `withheld_kept`), now read with windows: no window restores from total withholding.
3. A window that both passes out isolated withholdings and resists withholding at every other step (EL4a (e)).
4. A fate of the pairs read off their selection, within any horizon (EL4c, over a horizon).

The draft's first item, "a fixed benefit beyond cost with no account of its source", is withdrawn. Source (iii) gives one inside the pair, so the account only bounds the sources (i) and (ii).

## 6. Modelling choices on which the laws depend

Discrete steps; giving all-or-nothing per formation per step; a supplied pairing or waiting relation, fixed over the run; errors as supplied patterns, counted; the start's history all giving; offspring `a + β·R + γ·K` while supported, none once unsupported, natural factors; generations read one at a time.

## 7. What it does not show

- That giving, a window or any law of giving is better (the ethics' two premises: the continuation condition for scope, C for order).
- How waiting forms, or how a pairing comes about.
- Probabilities, and so not generous tit-for-tat's probabilistic forgiveness.
- That any actual organism, institution or trained system meets the counts.
- Amounts of giving, mutual best responses, or the cycle as a course.

## 8. Placement

**Modules.**
- *The windowed law* (`answersWithin`, the lift and `answers` as window one) goes below `Withholding` only on that module's owner's yes (named in its history row); otherwise it goes above `Tolerance`.
- *Errors, the pair witnesses, the alternator and the one-step split* go in a module above `Tolerance` (working name `Becoming.WindowedWaiting`), since they use `Pair`, `answers` and `withholding_returns`.
- *EL4b and EL4c* go in a leaf importing `WindowedWaiting`, `SelectionLevels`, `RuleShaping`, `DrawnBeyond` and `SelectionPace` (working name `Becoming.PairSelection`). It is a leaf because nothing below reads offspring from giving.

**Records** (working titles, structural):
- a-pair-tolerates-only-within-a-window (EL4a), home 05 §5;
- offspring-read-from-giving-that-waits (EL4b), home 05 §5;
- what-giving-that-waits-draws-on (EL4c), home 05 §6.

**Order and checks:** as in [EL §9](NOTE.md#9-coordination-order-and-the-release-gate).

## 9. Sources to check before any record cites them

Trivers 1971 (reciprocal altruism); Axelrod and Hamilton 1981; Axelrod 1984 (tit-for-two-tats); Wilkinson 1984 (food sharing in vampire bats); Molander 1985 and Nowak and Sigmund 1992 (generous tit-for-tat, probabilistic, a relative of the window); Boyd 1989 (mistakes and stability); Kraines and Kraines 1989 (Pavlov) and Nowak and Sigmund 1993 (win-stay lose-shift); Wu and Axelrod 1995 (noise); Imhof, Fudenberg and Nowak 2005 (cycles). Cited from memory for orientation; each is read before it is cited.

## 10. Result block

```text
Result(s): giving-that-waits-on-giving, restoring-giving-from-the-worst-start, thresholds-of-waiting,
  tolerance-monotone-across-laws; selection-within-and-among-groups-of-any-sizes; what-a-rise-draws-
  from-beyond, a-rise-past-the-inflow-is-drawn-from-beyond; pace-of-selection-within-what-flows-in;
  what-bounds-offspring-numbers. Reused, none restated.
Delta: windows on a lifted carrier with errors; the one-step split by keeping inclusion; the alternator
  law; offspring read from a run while supported, on the four-term multilevel law; the three sources
  of what a gift brings beyond what it draws, with the need-asymmetry and outside-renewal witnesses.
Supplied premises / correspondence: §6; β and γ supplied except where EL4c bounds them.
Evidence: none yet; scratch enumeration and counts in scratch/, for the design only.
Boundary: §7.
Integration: 04 Open "offspring numbers tied to what a formation gives" (advanced: pairs, supplied
  factors); 05 Open "thresholds with memory" (windows).
```
