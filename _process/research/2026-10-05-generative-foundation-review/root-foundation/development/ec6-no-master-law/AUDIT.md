# EC6: the central declarations on no master law, audited

AI-written study, 28 October 2026, on main at `b4c509836`. It is the first part of board item EC6, claimed by the session Unification and coherence progress (fork 2), with no Lean. The brief is [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md) item 2. The master laws are those of [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#7-master-laws-and-connectivity), stated on the grammar in `Becoming.GrammarLaws`, and EC's aim is in its [plan](../ec-elegant-completion/PLAN.md): few laws, each stated once at the lowest layer that holds it, every central result following from them.

The draft (`60a129f25`) was read once by an independent reviewer ([REVIEW-EC6.md](REVIEW-EC6.md): 18 findings, verdict "another pass"). This is the revision; what changed is in the last section.

## Method

- **The 50.** These are the rows of OU3b's measure ([after.json](../ou3b-master-laws-on-the-grammar/after.json)) whose declaration neither reaches the grammar nor reaches a master law's anchor. They are 50 distinct declarations. Rerun on main today (`measure_grammar.py --save`), the measure gives the same 50. After OU3c, its owner expects the same 50.
- **What was read.** For each declaration: its statement and proof, its direct spine dependencies, and the constants its type and proof reach. These come from the checker cache through EC's measure, and nothing was compiled. The helper is [`inspect_decl.py`](inspect_decl.py). The reviewer checked all 50 against the Lean and recomputed every count.
- **The outcomes.** Each declaration gets one of three:
  - **(a)** It is a case of a master law, and the audit names the theorem that would derive it below that law (rule 9).
  - **(b)** It shares a mechanism with others that no master law states: a candidate, written out.
  - **(c)** It is a law of its model, or definitional or representational, with the reason.
- **The test for (a).** The law must be the declaration's reason, not a dependence added to raise the count (OU plan §十三; WHAT-REMAINS item 1 rejects a definitional mention). A row is (a) only where its proof re-proves, by its own induction, chain or count, what a master law states; the derivation replaces that part by the law. A row that applies once a premise no master law states (N_rel, a gate) or a closed region is (c). A row that applies a master law's own clause, inline or by name, is a case of that law, as the 52 rows on `Flow.Balances` are.
- **Reaching the anchor.** Closure's only anchor in EC's measure is `WithinClosure` (`measure.py`, `LAWS`). So each closure derivation below goes through `WithinClosure`, Frame's name for `«所闭»`, or through `Invariant.reach`, which reaches it by `reach_iff_withinClosure`. A derivation through `«及»` or `«所闭»` directly would reach the grammar but leave the row on "no master law".

## Summary

| Outcome | Count | What it is |
|---|---:|---|
| (a) closure | 7 | Invariance along a run (5); propagation along a chain of a relation (2). |
| (a) balance | 3 | The census's stretch balance proved apart from the prelude's; balance written inline in `Optimum`. |
| (b) gating premises | 9 | Two premises of the account with one-line consequences, named nowhere as a law: support (only the active give, and the active are supported; 8) and dissipation (what gives takes more; 1). |
| (b) Price's identity | 3 | The counting form of the selection term and its partition among groups: an identity with no premise. |
| (b) step-indexed reaching | 3 | Reaching within *n* steps, which needs laws the grammar does not yet state. |
| (c) laws of their models | 7 | Determined dichotomy, retargeting, copying, a propagation bound, a sampling bound, a zero-sum count, the drive to the least level. |
| (c) one step of a premise or a closed region | 4 | N_rel applied once (its closure form exists); a region closed under a sameness, used once. |
| (c) definitional, representational or witness | 14 | `Iff.rfl` or a one-line unpacking; the one-kind reading kept; a free slot shown free. |
| **Total** | **50** | |

On this reading:
- **10 of the 50 are cases of the master laws.** Each has a named derivation, and no new law is needed.
- **15 share mechanisms that no master law states, in three groups.** The first holds two premises with one-line consequences (support, dissipation); the second is an identity; the third is a step-indexed law the grammar lacks.
- **25 are laws of their models, single applications, definitional or representational.** No derivation would add content to them.

The evolution cluster splits between gating and Price's identity. OU3c's pattern (a pigeonhole bound, then the grammar's laws of steps along the orbit, as in `Learning.lasso_of_held`) fits none of the 50. Only `run_shape` uses `Law.orbit_add`, to re-index an invariant, and none reaches a pigeonhole step.

## (a) Cases of a master law

The derivations are proposals to the owners below; none is claimed. Unless a line says otherwise, each is bridge theorems and re-proofs, with definitions and statements unchanged.

### Closure: invariance along a run

The law is in the spine. An invariant is a region closed under the steps (`invariant_iff_closedUnder`), and it holds wherever the process reaches (`Invariant.reach`, which reaches `WithinClosure` by `reach_iff_withinClosure`). A run reaches every later state from every earlier one (`Run.reach r t k`: from state `t` to state `t + k`). The lemmas below instead prove their invariance by their own induction on the step count. `Invariant.run` does follow from `Invariant.reach` and `Run.reach`, but no central row uses it, so the derivations use `Invariant.reach` with `Run.reach` directly; this also matches their starts at an arbitrary step `t`. The regions are read on the joint state `S × R × Nat` of `Law.run (Pace.step f h reads)`, whose projection is `paced`.

| Row | Declaration | Record | Region and its closedness | Derivation |
|---|---|---|---|---|
| degeneration | `RuleCapture.favouring_locks` | capture-through-the-rule | Joint states whose rule favours. It is closed under the paced step, by `uniform` at a reading step and kept at the others (`favours_throughout`). | `favours_throughout` by `Invariant.reach` with `Run.reach`. The rest of the row (each step raises; locked after the first reading step) is one step each. |
| collective | `RuleCapture.uniform_locks` | capture-through-the-rule | The same region from step `r + 1` (`favours_after_reading`). | `favours_after_reading` by `Invariant.reach` with `Run.reach … (r + 1) d`. |
| collective | `ClosedCapture.lock_outlives_loss` | closed-capture | Joint states that are locked (`locked_stays`), closed by `turn_locked` whatever is read. Joint states at or above a given one and locked (`locked_not_below`), closed by `turn_locked` with the preorders' transitivity. | `locked_stays` and `locked_not_below` by `Invariant.reach` with `Run.reach … t k`. The row's own inductions stay: `join_course` (the joined course projects onto the share's course) and `loss_grows` (the loss grows by at least one a step). |
| transformation | `Pace.rule_until_reading` | how-fast-a-rule-may-change | Joint states `(s, g, n)` with `n ≤ r → g = c.2`. It is closed under the paced step, since `reads n = false` for `n < r`. | `Invariant.reach` with `Run.reach … 0 t`, reading the counter as `t` by `paced_count`. |
| degeneration | `RegimeMargin.Drawn.run_shape` (last two conjuncts) | regime-in-any-amounts | `{(a, b) | rel a b}` under the product law `(a, b) ↦ (g a, g b)`. Its closedness is `mono` (`Lasting.orbit_mono`'s hypothesis), and it takes arbitrary ordered starts, as `falls_of_below` and `run_below` pass. | `Lasting.orbit_mono` from `Invariant.reach` at the product law, with a lemma that the product law's orbit is the pair of orbits. `rising_on` and `falling_on` (the two conjuncts) then move with it, and so do its other callers. The first three conjuncts are the regime's one-step law (c). |

### Closure: propagation along a chain of a relation

| Row | Declaration | Record | The chain | Derivation |
|---|---|---|---|---|
| degeneration | `RegimeMargin.Coupled.Indexed.ends_downstream` | coupled-webs | `Downstream` is an inductive chain: reflexive, or one more dependence. | Bridge from `Downstream i k` to `WithinClosure R k i` (only that direction is needed), with `R j i := DependsOn i j`, proved by induction over `Downstream` with closure's step and transitivity. With positive draws, the ended conditions are closed under `R` (`ends_of_partner`). The closure law then gives the cascade: a closed region holding `k` holds what lies within `k`'s closure. |
| generation | `onLoop_of_closing` | how-loops-form | `Upstream` and `OnLoop` are chains written as index vectors (`Coupled`, `Closing.join`). `Upstream` admits the empty chain, so it is `«所闭»`, equality or `«及»`. `OnLoop e` asks for a chain of positive length, `«及» e e`. | Bridges in both directions: `Upstream ↔ WithinClosure` of the coupling (`«线则所闭»` and its converse) and `OnLoop e ↔ «及» e e` (`«线则及»` and its converse); the converses are needed because the conclusion is an index vector. Then the coupling step `d → c` with `Upstream c e` is `«及» d e` (`«及当且仅当一步而所闭»`), and with `Upstream e d`, which is equality or `«及» e d` (`«所闭当且仅当同一或及»`), it gives `«及» e e` (`«及之传递»`). The converse bridges redo the index-vector joins, so the induction moves into them. |

### Balance

| Row | Declaration | Record | Reason | Derivation |
|---|---|---|---|---|
| dissolution | `CensusWebs.keep_pace` | none lists it (COVERAGE's dissolution row cites coming-and-ceasing-keep-pace, which lists `Becoming.keep_pace`, another declaration) | `Counts.over_stretch` (`h' + D = h + A`) is the census form of the stretch balance: the count holding is the level, ceasings are taken and comings are given. `Counts.over_stretch_decided` proves it by its own induction, with `Counts.across_step` as the step. | `Counts.over_stretch_decided` from `balance_over_stretch_on`, which takes count functions, through two bridges. (i) On a stretch decided at each step, the counts exist as functions of the step, by a finite-choice induction over the stretch with `counts_iff_decided`. (ii) `CountsAcross` over the stretch is read as a `total` of the per-step counts, which it also picks as functions; `Counts.unique` identifies them with `h`, `h'`, `A` and `D`. The induction moves into the bridges rather than disappearing. `Listed.over_stretch_on` (Population) is the listed case already derived from the prelude, and the model to follow. The double-negation wrapper that removes decidedness stays. |
| alignment | `Optimum.optimum_beyond` | room-read-off-the-exchange | `Flow.Outcome` writes the one-step balance inline: `∀ c, o c + L'.taken t c = l c + L'.given t c`. | Name the clause once: the balance of a flow between given levels across a step. Prove that `Flow.Balances` is it at the web's levels at every step; this is a theorem, so `Flow.Balances` keeps its definition and the 52 balance rows and `Flow.balances_iff_units` are untouched. Add the clause to `LAWS['balance']` (EC's owner). `Outcome`'s body is then spelled with it: the same proposition, but a change of the definition's text. |
| alignment | `Optimum.mutual_beyond` | several-optimizers-drain-by-their-joint-capacity | Its hypothesis `balances : ∀ x, o x + L.taken t x = l x + L.given t x` is the same clause. | The hypothesis spelled with the clause: the same proposition, a change of the statement's text, for Optimum's owner. |

## (b) Mechanisms that no master law states

### Gating premises: support and dissipation

**Statements.**
- **Support.** A formation gives across a step only while active (`Flow.Acting`, in `Flow`), and is active only while every condition it requires stands at or above its need (`Web.Dependent`, `Web.Supported`, in `Dependence`). So a source of descent was supported at the step of descent (`DescendsAt.supported`).
- **Support, stated a second time.** In the counterfactual models the same gate is `ExchangeLaw.NeedsSupportAt` (`LevelCoupling`), built on `Web.Admits` (`Admission`). It is linked to `Web.Supported` by `Web.supported_iff_admits`.
- **Dissipation.** A present formation that gives takes more than it gives (`Flow.DissipatesOn`, in `Dissipation`).

| Row | Declaration | Record | How it uses the gate |
|---|---|---|---|
| evolution | `Flow.selected_le` | evolution-on-descent | Parents' needs, weighted by their offspring, are at most the level counted once for each (`selected_le_at`: the gate, with sums). |
| evolution | `Flow.selection_within` | evolution-on-descent | The same, with Price's counting form (`price`). |
| evolution | `Flow.transmitted_supported` | evolution-on-descent | The gate with inheritance within `δ` (`transmitted_supported_at`). |
| evolution | `SelectionTerm.Flow.support_not_lower` | selection-term-over-generations | The gate gives no discordance (`support_not_against`), so the mean does not fall (Price's identity). |
| evolution | `SelectionTerm.Flow.support_moved_rises` | selection-term-over-generations | The same, with exact transmission. |
| evolution | `GroupEnding.Flow.rises_iff_inactive` | selection-among-groups-by-ending | `Flow.Acting`: inactive groups leave no offspring (`ended_of_inactive`), with the partition among groups. |
| evolution | `GroupEnding.Flow.all_end` | selection-among-groups-by-ending | `Flow.Acting` alone: with no active member, there is no next generation. |
| knowing | `carried_iff_rising` | what-dependence-alone-carries-of-a-level | The gate as `NeedsSupportAt`. Admission is upward closed in the level (`Web.Admits.mono`, in `rises_at_step`), so a response carried through dependence alone rises with the level (`carried_rises`). The converse is a layered construction (`Layers`). |
| evolution | `Reproduction.Flow.number_within_take` | what-bounds-offspring-numbers | Dissipation, with each birth needing a unit given. |

**Counts over all 127 rows.** 17 reach `Web.Supported`, 15 reach `Flow.Acting` or `Web.Dependent`, and 6 reach `Flow.DissipatesOn`.

**On the grammar.**
- **The gate** is relational: the giving relation's sources lie within the active region, and the active region within the supported one. An inclusion of partial identities, statable with no amounts and adding nothing.
- **The comparison** (need at most level) needs amounts. Like balance, it would be represented, not derived: the need's units paired into the level's.
- **Dissipation** is an inequality between amounts given and taken. Like balance, it would be represented with amounts.

**Assessment.** Being a premise does not set the gate apart from balance. `COVERAGE.json`'s premises already list "balance" beside "activity needing support", "only active relata give" and "dissipation", each with witnesses that meet and fail it. What sets them apart is consequence. Balance has a derived law that many results share, the stretch balance stated once in the prelude. The gate's only consequence is one line (`DescendsAt.supported_at`), and every row above uses the premises directly. The decision is EC's owner's, with the owners of `Dependence`, `Flow`, `Dissipation` and `LevelCoupling`. The two premises are separate candidates: dissipation is an inequality between amounts given and taken, not a gate on who takes part.
1. **Anchors of sixth laws.**
   - **Support:** `Web.Supported`, `Web.Dependent`, `Flow.Acting` and `ExchangeLaw.NeedsSupportAt`. This credits 10 of the 50: the eight support rows, and also `Web.roles_supported` and `Web.roles_dependent`, which reach `Web.Supported` but are representation theorems (c), credited by mention.
   - **Dissipation:** `Flow.DissipatesOn`. This credits 1 of the 50 (`number_within_take`).
   - **`Web.Admits` is not an anchor.** It is the order law's basis (`Web.Exceeds` is defined from it, and `Web.Widens` reaches it), and as an anchor it would credit two more (c) rows by mention, and 16 of the 77.
2. **The rows reported as resting on premises of the account.** That is a reason, not a gap, and needs no anchor.

Either way the rows stand: rerouting them changes nothing.

### Price's identity

**Statement.** Three counting identities, none with a premise beyond a common multiple of the groups' sizes:
- **`price`** (`Evolution`): the counting form of Price's equation, with offspring totals against what transmission lowered and raised.
- **`SelectionTerm.covariation`:** for any list and any two weightings, the list's length times the weighted total, with the discordant pairs, is the total weight times the total amount, with the concordant pairs. Divided through, concordance less discordance is the covariance of weight and amount.
- **`SelectionLevels.levels_sized`:** with a common multiple of the groups' sizes, the whole's covariance is the size-weighted mean of the groups' covariances with the size-weighted covariance of their means (Price's partition).

| Row | Declaration | Record | Use |
|---|---|---|---|
| evolution | `SelectionTerm.covariation` | selection-term-over-generations | The identity. |
| evolution | `SelectionLevels.levels_sized` | selection-within-and-among-groups-of-any-sizes | The partition, from `covariation` three times. |
| evolution | `SelectionLevels.rises_exact_iff_levels` | selection-within-and-among-groups | The mean rises exactly where concordance exceeds discordance, read within and among groups. |

`price` is reached by `selection_within`, `support_not_lower`, `support_moved_rises` and `closed_lineage_lowered`; `covariation` by seven central rows.

**On the grammar.** Like balance's count law, it would be represented, not derived: pairs of members counted by concordance under two orders.

**Assessment.** This is not balance's standing exactly. Balance's step law is a premise that a flow may meet or fail; these are identities that cannot fail: exact accounting, stated once and generic in the carrier. Their lowest layer is counting, below every model, but `SelectionTerm` and `Evolution` hold them, and moving them would move their dependencies too (`excess` in `Change`, `total_congr` in `Flow`). The decision is EC's owner's, with the owners of `Evolution`, `SelectionTerm` and `SelectionLevels`. Either selection's identity is a master law of counting beside balance, moved below the models with its dependencies and its consumers reported on it, or it stays a lemma family, with these rows reported as resting on a counting identity.

### Step-indexed reaching

The three rows below read the *n*-fold composition of a relation. Closure carries no step counts. The grammar has `«迭»` and its composition `«迭之接»` in its finite-runs section, but not reaching within *n* steps, and no iterate of a map on regions: `Law.run` and `Law.orbit` are in `Recurrence`, above the grammar. So the mechanism is a law the grammar would have to state first.

**Candidate statement.** It has two parts:
- **Composition:** within `m` steps and then within `n` is within `m + n`, from `«迭之接»`.
- **The iterate law:** the `n`-th iterate of "holds where every `R`-predecessor held" holds at `a` exactly where everything reaching `a` in `n` steps held at the start. That is the exactly-`n` form, with no memory, and it is `answers_closed`. With memory, "within `n` steps" replaces "in `n` steps"; that is `waitsAll_closed`.

| Row | Declaration | Record | What it needs besides the law |
|---|---|---|---|
| collective | `Withholding.withholding_spreads` | giving-that-waits-on-giving | A bridge `Chain up k ↔ «迭» up k`. `Chain` composes last step last and `«迭»` first step first, so the bridge needs its own induction. |
| maintenance | `Tolerance.answers_restores_iff` | restoring-giving-from-the-worst-start | The same bridge. Its orbit-monotonicity induction, `KeepsInclusionInto.course`, stays. |
| capacity | `WithinMoves.after_course` | effective-capacity-and-eventual-reachability | A bridge between `Trace` and `«迭»` of the process's steps. |

The first two also need a bridge from `Law.run`'s orbit to whatever iterate on regions the grammar adds.

Whether the law belongs beside finite runs, where `«迭»` sits, or as a step-indexed form of closure is for OU3b's owner, who holds `GrammarLaws`. It is to be stated and reviewed before `Withholding`, `Tolerance` or `Labelled` consider using it.

## (c) Laws of their models, single applications, definitional or representational

### Laws of their models

| Row | Declaration | Record | Reason |
|---|---|---|---|
| actor | `Dependence.differenceOnlyTogether_iff` | joint-difference-making | Joint difference-making rests on the dichotomy of a determined process (`determined_dichotomy`): with the step available and the dependence held and met, the move makes or breaks it. This is counterfactual logic over withholding. `Determined` is defined directly; it equals the grammar's `«定后»` through `determined_iff_fixed`, which the row does not use. |
| knowing | `Run.not_fixes_of_untaken` | experiment-needs-return | An untaken move is fixed by no record: retargeting it gives determined processes that admit every step of the run and send it anywhere. Underdetermination of a law by an unexplored move. |
| collective | `SharedCodes.run_agrees_every_start_iff` | a-code-formed-between-formations | Copying: each formation's form at step `k` is the start's at its origin (`state_hearings`), so agreement from every start is one origin. |
| patient | `responses_le_missBound` | what-a-cut-loses | A bound of the propagation model: what is carried is at most what is carried within plus a bound set by the inflow (`carried_le_carriedWithin_add`). |
| evolution | `Drift.falls_back` | drift-offspring-sampled | A second-moment bound on samplings, weighted by their binomial weights, that fall back by the gap (`spread`): counting, with no premise of the unfolding. |
| collective | `RelativePosition.rise_needs_fall` | relative-position-is-zero-sum | A counting identity. Each part's position compares its amount, counted once for each part, with the family's total (`riseCount`, `fallCount`), so the rise and fall counts total alike, by commutativity (`change_balances`), and a rise needs a fall. |
| alignment | `Web.optimum_broken_iff` | what-an-optimum-does-beyond-what-couples-in | The drive to the least level (`least_of_room`). An outcome unbeaten under any order containing "exceeds on the family", with room beyond, is least beyond. "Exceeds" is widening in amounts, so the order law would reach it only through a representation of amounts. |

### One step of a premise or of a closed region

| Row | Declaration | Record | Reason |
|---|---|---|---|
| life | `Web.living_on_reaches` | living-on-and-descent | One application of N_rel (`Valuation.transmits`), with no chain. N_rel's closure form exists already: `Valuation.reaches`, via `Invariant.reach`, and `Valuation.forced_iff_reach` (`ValuationFrames`), and both reach closure. |
| life | `Flow.descent_reaches` | living-on-and-descent | The same, along descent. |
| learning | `Learning.Training.unselected_beyond_data` | generalization-through-lumping | One use of a selection through the data (`.mpr` of `Through (AgreeOn D)`). Its record reads it as lumping's static factorization, as for `partForms_iff`. Respelling `Through` as `ClosedUnder` would be a definitional mention. |
| capacity | `Renewable.no_exact_finite_reading` | becoming-finite-horizon | Its content is the open continuation (`finite_reading_withholds_renewal`): two runs alike up to `h` differ in renewing. The reading being closed under agreement up to `h` is used once. |

### Definitional, representational or witnesses

| Row | Declaration | Record | Reason |
|---|---|---|---|
| learning | `Limit.identifies_iff_tracks` | learning-through-a-map-is-tracking-in-the-limit | `Iff.rfl`. |
| knowing | `Ideals.verifiableBy_iff_interior` | what-a-finite-stretch-verifies | `Iff.rfl`. |
| evaluation | `Web.renewingAt_iff_over_all` | represented-boundary-against-dependence | Renewing over the region of all conditions is renewing: a one-line unpacking. |
| significance | `unrestricted_iff_livingSignificance` | continuation-condition-yields-living-significance | The two definitions unpacked against each other, with every claim realized somewhere. |
| evaluation | `Valuation.significant_iff_held` | living-significance-on-held-lives | An unpacking of S0 and N_std, with every living claim held. |
| evolution | `Web.transmits_at_iff` | transmission-is-inheritance-and-need | Transmission at a descent unpacked as inheritance with the need within `δ`. |
| responsibility | `Dependence.Overdetermined.only_together` | joint-difference-making | One line from the definitions (`DifferenceOnlyTogether.of_breaks`). |
| maintenance | `Viability.kernel_and_iff` | conditions-kept-together | "For all reached" distributes over "and": logic. |
| actor | `partForms_iff` | where-a-move-is-formed | The factorization through a section of a lumped map: `PartForms` is `Learning.Lumped Prod.fst`, lumping's static condition. The law proper is `PartForms.goAlike`: the part carries a law of its own. |
| actor | `Web.roles_supported` | life-as-condition-of-life | The one-kind reading of a web keeps support: a representation theorem. |
| patient | `Web.roles_dependent` | life-as-condition-of-life | The same, for dependence. |
| life | `Web.roles_alive` | life-as-condition-of-life | The same, for living events. |
| evaluation | `Web.significance_undetermined` | continuation-condition-yields-living-significance | Two constant valuations: the represented dynamics do not fix significance, a free slot shown free. |
| alignment | `ExchangeLaw.response_not_fixed_by_coupling` | what-a-pools-acts-respond-to | Two laws through one coupling that differ: the coupling bounds response and does not fix it. A witness; "through" is the definition. |

## Proposals, by module and its records' owners

Each is a proposal, to be claimed one module at a time with the owner of the module (board rule 3).
- **Unless a line says otherwise:** bridge theorems and re-proofs, with definitions and statements unchanged.
- **Records:** Frame's closure lemmas sit in levels-of-closure; `Invariant.reach` and `Run.reach` are in no record.

1. **`RuleCapture`, `ClosedCapture`** (capture-through-the-rule, closed-capture, two-rules-lock-together, a-reading-against-the-share-does-not-ratchet). `favours_throughout`, `favours_after_reading`, `locked_stays` and `locked_not_below` by `Invariant.reach` with `Run.reach`, at the named regions of the paced law's joint state. `lock_outlives_loss` keeps `join_course` and `loss_grows`.
2. **`Pace`** (how-fast-a-rule-may-change). `rule_until_reading` likewise.
3. **`Lasting`, `RegimeMargin`** (regime-in-any-amounts, coupled-webs, and `Lasting`'s owner). `Lasting.orbit_mono` from the invariance of the order region under the product law, with the product-orbit lemma. The `Downstream ↔ WithinClosure` bridge, and `ends_downstream` from it.
4. **`Closing`, `Loops`** (how-loops-form). The bridges `Upstream ↔ WithinClosure` and `OnLoop ↔ «及» e e`, both directions, and `onLoop_of_closing` from `«及当且仅当一步而所闭»` and `«及之传递»`.
5. **`Decidedness`** (counts-exist-where-decided, census-balance). `Counts.over_stretch_decided` from `balance_over_stretch_on` through the two bridges, after `Listed.over_stretch_on`.
6. **`Optimum`, with `Flow`'s owner and EC's owner** (room-read-off-the-exchange, several-optimizers-drain-by-their-joint-capacity).
   - The balance clause named once, and `Flow.Balances` shown to be its case: a theorem, not a redefinition.
   - The clause added to `LAWS['balance']`.
   - `Outcome`'s body spelled with it. This changes its text but not its meaning, so it is Optimum's owner's to decide. It credits both rows, since `mutual_beyond` depends on `Outcome` directly. Respelling `mutual_beyond`'s hypothesis is optional; it only states the clause once in that theorem.
   - Keeping `Flow.Balances` as it is leaves the step balance written twice, in its body and in the clause, linked by an `Iff.rfl` theorem: named once, not stated once. Whether to define `Flow.Balances` from the clause, which means rechecking the 52 rows, is `Flow`'s owner's choice.
7. **The grammar** (`Becoming.GrammarLaws`, OU3b's owner). The step-indexed candidate, stated and reviewed, before `Withholding`, `Tolerance` and `Labelled` are asked to bridge to it.
8. **EC's owner, with the owners of `Dependence`, `Flow`, `Dissipation`, `LevelCoupling` and the evolution modules.** The gating question, for support and dissipation separately: option 1 (anchors; support credits 10 of the 50, two by mention, dissipation 1) or option 2 (reported as premises).
9. **EC's owner, with the owners of `Evolution`, `SelectionTerm` and `SelectionLevels`.** Price's identity: a master law of counting moved below the models with its dependencies, or a lemma family.
10. **COVERAGE's owner and the measure's,** after OU3c lands, since `measure_grammar.py` carries OU3c's uncommitted edits.
    - Report the 18 single-application, definitional, representational and witness rows as such, as WHAT-REMAINS item 3 asks for balance.
    - Consider citing the substantive declarations they unpack: `PartForms.goAlike` for `partForms_iff`, and `Valuation.reaches` for the two `*_reaches`.
    - `CensusWebs.keep_pace` has no record.
    - Two stale counts: 08 §7's "9 of 14" on finite runs is now 13, and WHAT-REMAINS's "evolution 18" is 13 rows of the 50 (18 is the evolution row's size).

## Measure notes

1. **Closure's anchor.**
   - **What the derivations need:** they go through `WithinClosure`, so that the rows reach the anchor and not only the grammar.
   - **Other anchors, not recommended:** adding `ClosedUnder` would credit no current row, since the 12 central rows that reach it all reach `WithinClosure`. Widening the anchor to `«所闭»` would credit, by mention, 12 rows that reach it through the finite-runs grammar laws (through `«定后于»` 4, through the rest law's ending `«尽»` 8); 9 of them are on return and 3 on balance only.
2. **Rows of (c).** The measure could report the 18 rows of the last two tables as what they are, so that its headline counts only what is a gap.

## What this audit does not do

- It compiles no Lean, and does not claim that any derivation goes through. Each is a theorem to be written and checked, with exact hypotheses, when its module is claimed.
- It adopts none of the three candidates in (b), and decides no definition another owner holds (rule 3).
- It does not re-audit the 77 rows already on a master law. The counts quoted above for `Web.Supported`, `covariation`, `ClosedUnder` and `DissipatesOn` are over all 127 rows, from the same dependency dump.

## What the review changed

Every finding of [REVIEW-EC6.md](REVIEW-EC6.md) was taken; each was checked against the Lean before it was taken.
- **Findings 2–4: seven (a) rows reclassified, two corrected.** The two `*_reaches` rows apply N_rel once, and its closure form exists (`Valuation.reaches`). The two one-step rows are a definitional mention. The three within-*n* rows need grammar laws no master law states, so they are a (b) candidate. Two more were wrong in detail and stay in (a) with their derivations corrected (5, 6). The tally went from (a) 17, (b) 11, (c) 22 to (a) 10, (b) 15, (c) 25; dissipation joined the gating group (finding 11).
- **Finding 5: `onLoop_of_closing`.** `Upstream` admits the empty chain and is `«所闭»`. The join needs `«及当且仅当一步而所闭»` and `«及之传递»`, with bridges both ways.
- **Finding 6: `run_shape`.** The product law, not the law of pairs, since `orbit_mono` takes arbitrary ordered starts.
- **Finding 7: the invariance rows.** They use `Invariant.reach` with `Run.reach` at the joint state from an arbitrary step. `locked_not_below`'s closedness is `turn_locked` with transitivity. `lock_outlives_loss` keeps its own inductions. Re-proving `Invariant.run` alone moves no central row, so that proposal is dropped.
- **Finding 8: `keep_pace`.** The two bridges are named, the induction moves into them, `Listed.over_stretch_on` is the model to follow, and the record is missing.
- **Finding 9: the Optimum rows.** `Flow.Balances` is not redefined. The clause goes into `LAWS`, and the statement-text change is flagged.
- **Finding 10: `carried_iff_rising`.** Its gate is `NeedsSupportAt` on `Web.Admits`, so the gate is stated twice. Option 1's effect is now stated: 11 of the 50, two by mention.
- **Finding 11: the gating assessment.** Being a premise is shared with balance; what differs is a derived law. The gate's modules (`Dependence`, `Flow`) are named, and dissipation is reported with support.
- **Finding 12: Price's identity.** It includes `price`. Its standing is an identity, not a premise. The dependencies that would move with it are named.
- **Finding 13:** the `Reach` note is dropped.
- **Finding 14:** the reason for `differenceOnlyTogether_iff` is reworded.
- **Finding 15:** each proposal says what changes.
- **Finding 16:** the derivations go through `WithinClosure` (Method; Measure note 1).
- **Finding 17:** levels-of-closure is named.
- **Finding 18:** the counts are over all 127 rows; the stale counts are named in proposal 10, which waits for OU3c.
- **Finding 1:** `ClosedUnder` is reached by 12 central rows, not 28.

A second pass, by the same reviewer, on the fixes alone: one error and four imprecisions, with two suggestions. It found 17 of the 18 resolved. All were taken:
- **Error:** `Web.Admits` is dropped from the gating anchors. It is the order law's basis, and as an anchor it would have credited 13 of the 50, not 11.
- **Imprecisions:** the test for (a) separates a master law's own clause from other premises; the `«所闭»` count is given exactly; support and dissipation are separate candidates; and "seven reclassified, two corrected".
- **Suggestions:** the Optimum proposal says what respelling credits and what keeping `Flow.Balances` leaves; small completions in the derivations of `onLoop_of_closing`, `ends_downstream`, `rule_until_reading`, `keep_pace`, the step-indexed rows and `lock_outlives_loss`.

Its verdict: proposals 1–7, 9 and 10 may go to module owners now, and 8 after the error's fix, which is made.
