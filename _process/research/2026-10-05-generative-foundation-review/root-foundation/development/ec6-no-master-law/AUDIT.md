# EC6: the central declarations on no master law, audited

AI-written study, 28 October 2026, on main at `b4c509836`. It is the first part of board item EC6, claimed by the session Unification and coherence progress (fork 2), with no Lean. The brief is [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) item 2. The master laws are those of [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#7-master-laws-and-connectivity), stated on the grammar in `Becoming.GrammarLaws`, and EC's aim is in its [plan](../ec-elegant-completion/PLAN.md): few laws, each stated once at the lowest layer that holds it, every central result following from them.

## Method

- **The 50.** These are the rows of OU3b's measure ([after.json](../ou3b-master-laws-on-the-grammar/after.json)) whose declaration neither reaches the grammar nor reaches a master law's anchor. They are 50 distinct declarations. Rerun on main today (`measure_grammar.py --save`), the measure gives the same 50.
- **What was read.** For each declaration: its statement and proof, its direct spine dependencies, and the constants its type and proof reach. These come from the checker cache through EC's measure, and nothing was compiled. The helper is [`inspect_decl.py`](inspect_decl.py).
- **The outcomes.** Each declaration gets one of three:
  - **(a)** It is a case of a master law, and the audit names the theorem that would derive it below that law (rule 9).
  - **(b)** It shares a mechanism with others that no master law states: a candidate sixth law, written out.
  - **(c)** It is a law of its model, or definitional or representational, with the reason.
- **The test for (a).** The law must be the declaration's reason, not a dependence added to raise the count (OU plan §十三). A row is (a) only where its proof re-proves by its own induction, chain or count what the master law states; the derivation then replaces that part by the law.

## Summary

| Outcome | Count | What it is |
|---|---:|---|
| (a) closure | 14 | Four kinds: invariance along a run (5); propagation along chains of a relation (4); reaching within *n* steps (3); one step under a sameness (2). |
| (a) balance | 3 | Census balance proved apart from the prelude's stretch balance; balance written inline. |
| (b) support gating | 8 | Only the active give, and the active are supported. Named nowhere as a law. |
| (b) Price's identity | 3 | The covariance form of the selection term and its partition among groups. Three of the support rows use it too. |
| (c) laws of their models | 8 | Determined dichotomy, retargeting, copying, a propagation bound, a sampling bound, dissipation, a zero-sum count, the drive to the least level. |
| (c) definitional, representational or witness | 14 | `Iff.rfl` or a one-line unpacking; the one-kind reading kept; a free slot shown free. |
| **Total** | **50** | |

On this audit's reading, 17 of the 50 are cases of the five master laws, with no new law needed. 11 share two mechanisms that no master law states. 22 are laws of their models, definitional or representational, and no derivation would add content to them. The evolution cluster that WHAT-REMAINS expected to share one mechanism shares two: support gating and Price's identity.

## (a) Cases of a master law

Each line names the derivation that would put the row on its law. The derivations are proposals to the owners below; none is claimed.

### Closure: invariance along a run

The general law is in the spine already. An invariant is a region closed under the steps (`invariant_iff_closedUnder`), and it holds wherever the process reaches (`Invariant.reach`, through `reach_iff_withinClosure`, which is the closure law). A run reaches every later state from every earlier one (`Run.reach`). But `Invariant.run`, like every lemma below, is proved by its own induction on the step count, so none of these rows reaches the closure anchor.

| Row | Declaration | Record | Its invariant | Derivation |
|---|---|---|---|---|
| degeneration | `RuleCapture.favouring_locks` | capture-through-the-rule | The rule favours along the course (`favours_throughout`); every step raises. | `Invariant.run` from `Invariant.reach` and `Run.reach` (Frame). Then `favours_throughout` as `Invariant.run` of the region where the rule favours, under the paced law. |
| collective | `RuleCapture.uniform_locks` | capture-through-the-rule | As above, after a reading step. | As above. |
| collective | `ClosedCapture.lock_outlives_loss` | closed-capture | Locked, and not below the start (`locked_stays`, `locked_not_below`). | `locked_stays` as `Invariant.run` of `Locked` under the paced law (`turn_locked` is its closedness). `locked_not_below` as `Invariant.run` of the region at or above the start that is locked (`locked_rises` with transitivity). |
| transformation | `Pace.rule_until_reading` | how-fast-a-rule-may-change | Up to the first reading step, the rule is the start's. | `Invariant.run` of the joint state's region "if the counter is at most `r`, the rule is the start's", closed under the paced step since `reads t = false` for `t < r`. |
| degeneration | `RegimeMargin.Drawn.run_shape` (last two conjuncts) | regime-in-any-amounts | A step that raises (lowers) both is followed by such steps for ever (`rising_on`, `falling_on`, by `Lasting.orbit_mono`). | `Lasting.orbit_mono` from the closure law at the law of pairs `(x, f x) ↦ (f x, f (f x))`: the order region is closed under it because the step is monotone (`step_mono`). The first three conjuncts are the regime's one-step law, under (c). |

### Closure: propagation along chains of a relation

| Row | Declaration | Record | The chain | Derivation |
|---|---|---|---|---|
| degeneration | `RegimeMargin.Coupled.Indexed.ends_downstream` | coupled-webs | `Downstream` is an inductive chain, reflexive or one more dependence: the closure itself. | `Downstream i k ↔ WithinClosure R k i` with `R j i := DependsOn i j` ("downstream is the closure of depending"). The ended conditions are then closed under `R` (`ends_of_partner`), and the closure law gives the cascade. |
| generation | `onLoop_of_closing` | how-loops-form | `Upstream` and `OnLoop` are chains written as index vectors (`Coupled`, `Closing.join`). | `Upstream ↔ «及»` of the coupling, and `OnLoop e ↔ «及» e e`, the grammar's reaching back. Joining chains is then the transitivity of reaching (`«所闭之传递»`). |
| life | `Web.living_on_reaches` | living-on-and-descent | One application of N_rel (`Valuation.transmits`) along living-on. | N_rel's closure form, stated once: under N_rel, significance from a standpoint holds of every living event within the event's closure under formed relations into living content, by the closure law, the rule being the closedness. This and `lived_on_reaches` are its one-step instances (`WithinClosure.of_rel`). |
| life | `Flow.descent_reaches` | living-on-and-descent | The same, along descent. | The same; `ancestry_reaches` is the other instance. |

### Closure: reaching within *n* steps

These three read the *n*-fold composition of a relation. The grammar has `«迭»` and its composition `«迭之接»`, but not reaching *within* `n` steps with its laws. So the derivation starts on the grammar.

- **Grammar first.** Define reaching within `n` steps from `«迭»`, with two laws:
  - composition: within `m` and then within `n` steps is within `m + n` steps, from `«迭之接»`;
  - the iterate law: the `n`-th iterate of "holds where every `R`-predecessor held" holds at `a` exactly where everything reaching `a` in `n` steps, or within `n` steps where the step keeps its own value, held at the start.

| Row | Declaration | Record | The chain | Derivation |
|---|---|---|---|---|
| collective | `Withholding.withholding_spreads` | giving-that-waits-on-giving | `Chain up k b a`, with `k ≤ n` (`waitsAll_closed`). | `Chain up k ↔ «迭» up k`, and `waitsAll_closed` from the iterate law, in its within-`n` form. |
| maintenance | `Tolerance.answers_restores_iff` | restoring-giving-from-the-worst-start | Chains of exactly `n` waits, with no memory (`answers_closed`). | `answers_closed` from the iterate law, in its exactly-`n` form. |
| capacity | `WithinMoves.after_course` | effective-capacity-and-eventual-reachability | A trace of length `k`, then within `n` moves (`WithinMoves.before`). | `WithinMoves` as reaching within `n` steps of the process; `after_course` is the composition law. |

### Closure at one step, under a sameness

| Row | Declaration | Record | Reason | Derivation |
|---|---|---|---|---|
| learning | `Learning.Training.unselected_beyond_data` | generalization-through-lumping | A selection "through" the data (`Through (AgreeOn D)`) is a region closed under agreement on the data, so what the data leave free stays free. | `Through E p ↔ ClosedUnder E p` for a symmetric `E` (`AgreeOn D` is one). The row is then a single step of a closed region, which is closure's definition. Recommended only together with the measure counting `ClosedUnder` (`«闭»`) as closure's term (Measure notes 1). Otherwise no change: it adds no content. |
| capacity | `Renewable.no_exact_finite_reading` | becoming-finite-horizon | A reading decided by the first `h` steps is closed under agreement up to `h`. Where the continuation is open (`finite_reading_withholds_renewal`), two runs alike up to `h` differ in renewing, so no such reading is exact. | As above for the closure part: `decided` is `ClosedUnder (AgreeUpTo h) reading`. The open continuation is the model's own law and stays. |

### Balance

| Row | Declaration | Record | Reason | Derivation |
|---|---|---|---|---|
| dissolution | `CensusWebs.keep_pace` | coming-and-ceasing-keep-pace | `Counts.over_stretch` (`h' + D = h + A`) is the census form of the stretch balance: the count holding is the level, ceasings are taken and comings are given. It is proved by its own induction (`Counts.over_stretch_decided`). | `Counts.over_stretch_decided` from `balance_over_stretch_on` (the prelude's stretch balance, EC2), with the per-step census as the step balance. The double-negation wrapper that removes decidedness stays. |
| alignment | `Optimum.optimum_beyond` | room-read-off-the-exchange | `Flow.Outcome` writes the one-step balance inline: `∀ c, o c + L'.taken t c = l c + L'.given t c`. | Name that clause once, as the balance of a flow from levels `l` to `o` across a step, beside `Flow.Balances` in `Flow`, with `Flow.Balances` its case at the web's levels. `Outcome` and `Outcome.of_balances` then use it. |
| alignment | `Optimum.mutual_beyond` | several-optimizers-drain-by-their-joint-capacity | Its hypothesis `balances : ∀ x, o x + L.taken t x = l x + L.given t x` is the same clause. | The same name for the hypothesis. |

## (b) Mechanisms that no master law states

### Support gating

**Statement.** What takes part in a step is supported there. A formation gives across a step only while active (`Flow.Acting`), and is active only while every condition it requires stands at or above its need (`Web.Dependent`, `Web.Supported`). So every source of descent was supported at the step of descent (`DescendsAt.supported`).

Across all 127 central rows, 17 reach `Web.Supported` and 15 reach `Flow.Acting` or `Web.Dependent`. Of the 50, these eight rest on it:

| Row | Declaration | Record | How it uses the gate |
|---|---|---|---|
| evolution | `Flow.selected_le` | evolution-on-descent | Parents' needs, weighted by their offspring, are at most the level counted once for each (`selected_le_at`, the gate with sums). |
| evolution | `Flow.selection_within` | evolution-on-descent | The same, with the price identity of offspring totals. |
| evolution | `Flow.transmitted_supported` | evolution-on-descent | The gate with inheritance within `δ` (`transmitted_supported_at`). |
| evolution | `SelectionTerm.Flow.support_not_lower` | selection-term-over-generations | The gate gives no discordance (`support_not_against`), so the mean does not fall (Price's identity). |
| evolution | `SelectionTerm.Flow.support_moved_rises` | selection-term-over-generations | The same, with exact transmission. |
| evolution | `GroupEnding.Flow.rises_iff_inactive` | selection-among-groups-by-ending | `Flow.Acting`: inactive groups leave no offspring (`ended_of_inactive`), with the partition among groups. |
| evolution | `GroupEnding.Flow.all_end` | selection-among-groups-by-ending | `Flow.Acting` alone: no active member, no next generation. |
| knowing | `carried_iff_rising` | what-dependence-alone-carries-of-a-level | Exchanging only where supported (`NeedsSupportAt`): support is upward closed in the level, so a response carried through dependence alone rises with the level (`carried_rises`). The converse is a layered construction (`Layers`). |

**On the grammar.**
- **The gate** is relational and needs no amounts. The giving relation's sources lie within the active region, and the active region within the supported one: an inclusion of partial identities, a composite of inclusions with no further content.
- **The comparison** (need at most level) needs amounts. Like balance, it could be represented, not derived: the need's units paired into the level's units, a pairing of one list into a sublist of the other, `«对»` on one side.

**Assessment.** The mechanism is shared and stated once, in `Web.Dependent`, `Flow.Acting` and `DescendsAt.supported` at the World's layer, the lowest that has needs and levels. But its content is two premises of the World, not a theorem. Naming it a master law would name a premise as a law, so the decision is EC's owner's and the World's. There are two options:
1. Add `Web.Supported` (with `Web.Dependent` and `Flow.Acting`) to the measure as the anchors of a sixth law, "support", reported as balance is ("represented on the grammar").
2. Keep support as a premise. The measure then reports these rows as "on the World's dependence premise", which is a reason, not a gap.

Either way the rows stand. Rerouting them changes nothing, since they already use the gate directly.

### Price's identity

**Statement.** For any list and any two weightings, the list's length times the weighted total, with the discordant pairs, is the total weight times the total amount, with the concordant pairs (`SelectionTerm.covariation`). Divided through, concordance less discordance is the covariance of weight and amount. With a common multiple of the groups' sizes, the whole's covariance is the size-weighted mean of the groups' covariances with the covariance of their means (`SelectionLevels.levels_sized`, Price's partition). Neither has a premise beyond the common multiple.

| Row | Declaration | Record | Use |
|---|---|---|---|
| evolution | `SelectionTerm.covariation` | selection-term-over-generations | The identity. |
| evolution | `SelectionLevels.levels_sized` | selection-within-and-among-groups-of-any-sizes | The partition, from the identity three times. |
| evolution | `SelectionLevels.rises_exact_iff_levels` | selection-within-and-among-groups | The mean rises exactly where concordance exceeds discordance, read within and among groups. |

`support_not_lower`, `support_moved_rises` and `rises_iff_inactive` use it too. Seven central rows reach `covariation`.

**On the grammar.** It is an identity of counting with no premise. Like balance it would be represented, not derived: pairs of members counted by concordance under two orders.

**Assessment.** It is exact accounting with the standing of balance: near-definitional, stated once, generic in the carrier. Its lowest layer is counting, below every model; `SelectionTerm` holds it now, but nothing in its statement belongs to selection. So the decision is for EC's owner. Either selection's identity is a master law of counting beside balance, moved to the prelude or a counting module below the models, with its consumers reported on it. Or it stays a lemma family, and the measure reports these rows as "on a counting identity".

## (c) Laws of their models, definitional or representational

### Laws of their models

| Row | Declaration | Record | Reason |
|---|---|---|---|
| actor | `Dependence.differenceOnlyTogether_iff` | joint-difference-making | Joint difference-making rests on the dichotomy of a determined process (`determined_dichotomy`): with the step available and the dependence held and met, the move makes or breaks it. This is counterfactual logic over withholding. The fixed successor it uses is the grammar's `«定后»`, as a premise, not as a master law. |
| knowing | `Run.not_fixes_of_untaken` | experiment-needs-return | An untaken move is fixed by no record: retargeting it gives determined processes that admit every step of the run and send it anywhere. This is underdetermination of a law by an unexplored move. |
| collective | `SharedCodes.run_agrees_every_start_iff` | a-code-formed-between-formations | Copying: each formation's form at step `k` is the start's at its origin (`state_hearings`), so agreement from every start is one origin. One could read it as reading the start through the origin map, but the module states no law of that reading. |
| patient | `responses_le_missBound` | what-a-cut-loses | A bound of the propagation model: what is carried is at most what is carried within plus a bound set by the inflow (`carried_le_carriedWithin_add`). |
| evolution | `Drift.falls_back` | drift-offspring-sampled | A bound on samplings, weighted by their binomial weights, that fall back by the gap (a second-moment bound, `spread`). Counting, with no premise of the unfolding. |
| evolution | `Reproduction.Flow.number_within_take` | what-bounds-offspring-numbers | Dissipation (`Flow.DissipatesOn`: a present formation that gives takes more than it gives), with each birth needing a unit given. It is gated, like support gating, by another premise; 6 central rows reach `DissipatesOn`. |
| collective | `RelativePosition.rise_needs_fall` | relative-position-is-zero-sum | A counting identity. Each part's position compares its amount, counted once for each part, with the family's total (`riseCount`, `fallCount`), so the rise and fall counts total alike by commutativity (`change_balances`), and a rise needs a fall. It is the zero-sum of shares; balance would state it only with the shares as levels and flows between them. |
| alignment | `Web.optimum_broken_iff` | what-an-optimum-does-beyond-what-couples-in | The drive to the least level (`least_of_room`). An outcome unbeaten under any order containing "exceeds on the family" (`Rising`), with room beyond, is least beyond. "Exceeds" is widening in amounts, so the order law would reach it only through a representation of amounts, as for balance. |

### Definitional, representational or witnesses

These add no mechanism; deriving them through a master law would add a dependence and no content.

| Row | Declaration | Record | Reason |
|---|---|---|---|
| learning | `Limit.identifies_iff_tracks` | learning-through-a-map-is-tracking-in-the-limit | `Iff.rfl`. |
| knowing | `Ideals.verifiableBy_iff_interior` | what-a-finite-stretch-verifies | `Iff.rfl`. |
| evaluation | `Web.renewingAt_iff_over_all` | represented-boundary-against-dependence | Renewing over the region of all conditions is renewing; a one-line unpacking. |
| significance | `unrestricted_iff_livingSignificance` | continuation-condition-yields-living-significance | The two definitions unpacked against each other, with every claim realized somewhere. |
| evaluation | `Valuation.significant_iff_held` | living-significance-on-held-lives | An unpacking of S0 and N_std, with every living claim held. |
| evolution | `Web.transmits_at_iff` | transmission-is-inheritance-and-need | Transmission at a descent unpacked as inheritance with the need within `δ`. |
| responsibility | `Dependence.Overdetermined.only_together` | joint-difference-making | One line from the definitions (`DifferenceOnlyTogether.of_breaks`). |
| maintenance | `Viability.kernel_and_iff` | conditions-kept-together | "For all reached" distributes over "and": logic. `Kernel` reads `Reach`, which is the closure of the steps (`reach_iff_withinClosure`), but the row uses nothing of it. |
| actor | `partForms_iff` | where-a-move-is-formed | The factorization through a section of a lumped map (`PartForms` is `Learning.Lumped Prod.fst`, lumping's static condition). The law proper is `PartForms.goAlike`: the part carries a law of its own. |
| actor | `Web.roles_supported` | life-as-condition-of-life | The one-kind reading of a web keeps support: a representation theorem. |
| patient | `Web.roles_dependent` | life-as-condition-of-life | The same for dependence. |
| life | `Web.roles_alive` | life-as-condition-of-life | The same for living events. |
| evaluation | `Web.significance_undetermined` | continuation-condition-yields-living-significance | Two constant valuations: the represented dynamics do not fix significance, a free slot shown free. |
| alignment | `ExchangeLaw.response_not_fixed_by_coupling` | what-a-pools-acts-respond-to | Two laws through one coupling that differ: the coupling bounds response and does not fix it. A witness, the "through" being the definition. |

## Proposals, by module and its records' owner

Each is a proposal, to be claimed one module at a time with the owner of the module (board rule 3). None is made before this audit's review.

1. **`Frame`** (the spine's frame; its records include experiment and comparison-within-reach). Re-prove `Invariant.run` from `Invariant.reach` and `Run.reach`. It is two lines, and every invariant along a run then rests on the closure law.
2. **`RuleCapture`, `ClosedCapture`** (capture-through-the-rule, closed-capture, two-rules-lock-together, a-reading-against-the-share-does-not-ratchet). State `locked_stays`, `favours_throughout` and `locked_not_below` as `Invariant.run` of their regions under the paced law. No statement changes.
3. **`Pace`** (how-fast-a-rule-may-change). `rule_until_reading` as `Invariant.run` of its region on the joint state.
4. **`RegimeMargin`, `Lasting`** (regime-in-any-amounts, coupled-webs, and `Lasting`'s owner):
   - `Lasting.orbit_mono` from the closure law at the law of pairs;
   - `Downstream` shown to be the closure of depending, and `ends_downstream` from it.
5. **The grammar** (`Becoming.GrammarLaws`, OU3b's owner, before items 6 and 7). Reaching within `n` steps, with its composition and iterate laws, stated from `«迭»` and `«迭之接»` and reviewed before any refactor.
6. **`Withholding`, `Tolerance`** (giving-that-waits-on-giving, restoring-giving-from-the-worst-start, thresholds-of-waiting). `waitsAll_closed` and `answers_closed` from the iterate law.
7. **`Labelled`** (effective-capacity-and-eventual-reachability). `WithinMoves` as reaching within `n` steps; `after_course` from its composition.
8. **`Closing`, `Loops`** (how-loops-form). `Upstream` and `OnLoop` through `«及»`; `onLoop_of_closing` from the transitivity of reaching.
9. **`Metaethics`, `Descent`** (living-on-and-descent). N_rel's closure form, with the four `*_reaches` theorems its one-step instances.
10. **`Decidedness`** (coming-and-ceasing-keep-pace, census-balance, counts-exist-where-decided). `Counts.over_stretch_decided` from `balance_over_stretch_on`.
11. **`Flow`, `Optimum`** (the anchors' module; room-read-off-the-exchange, several-optimizers-drain-by-their-joint-capacity). One name for the balance of a flow between given levels across a step, used by `Outcome` and by `mutual_beyond`'s hypothesis; `Flow.Balances` is its case at the web's levels. The anchor's definition changes, so `Flow`'s owner decides.
12. **EC's owner, the World's owner and the evolution modules' owners** (`Evolution`, `SelectionTerm`, `SelectionLevels`, `GroupEnding`, `LevelCoupling`; evolution-on-descent, selection-term-over-generations and the selection records). The two candidates in (b): whether support is a sixth law or a premise reported as such, and whether Price's identity is a master law of counting, moved below the models.
13. **COVERAGE's owner and the measure's** (EC and OU3b): the Measure notes below. Whether the 14 definitional, representational or witness rows stay central, or give way to the substantive declarations they unpack. Examples:
    - `PartForms.goAlike` for `partForms_iff`;
    - the closure form of N_rel for the two `*_reaches`;
    - `Invariant.reach` with `Run.reach` for the locks, once item 1 lands.

## Measure notes

1. **The closure anchor names one term of the closure law, not both.** `ClosedUnder` (`«闭»`) is the law's closed region, and `WithinClosure` (`«所闭»`) its closure. Counting both as closure's anchors would credit the rows whose reason is a closed region. 28 central rows reach `ClosedUnder`; none of the 50 does, because their proofs never name it. `Reach` is a seventh anchor defined beside the grammar, the closure of a process's steps by `reach_iff_withinClosure`, like the six that OU3c routes.
2. **Definitional rows.** As WHAT-REMAINS item 3 asks for balance, the measure could report the 14 definitional, representational or witness rows as such, so that its headline counts only what is a gap.

## What this audit does not do

- It compiles no Lean, and claims of no derivation that it goes through. Each is a theorem to be written and checked, with exact hypotheses, when its module is claimed.
- It adopts neither candidate in (b), and it decides no definition another owner holds (rule 3).
- It does not re-audit the 77 rows already on a master law. The counts there (17 central rows on `Web.Supported`, 7 on `covariation`, 28 on `ClosedUnder`, 6 on `DissipatesOn`) come from the same dependency dump, read for those anchors alone.
