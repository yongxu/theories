# EL: evolution read on the root's map

Design, 31 October 2026. Revised the same day after an independent review in three lenses (Lean correctness, coordination, substance; 65 findings, 21 major, every one taken). Then four rounds of scratch Lean followed, each module recompiled by an independent verifier, and two independent text reviews of the design after round 3 (§10). Every target states its standing: proved, proved in a stronger or weaker form (and how), refuted (with its witness), or open. Proved means proved in the core Lean: the six modules landed as core leaves at receipt EL_RECEIPT (study section EL_SECTION; [State of the Lean](#state-of-the-lean)). Board item EL claims it. AI-written. Provenance: [Ren, 31 October 2026](../../../../../../sources/15-codex-theory-conversations/2026-10-31-evolution-and-becoming-one.md). Part 4 is the draft first written as WS, now [WS.md](WS.md).

## In brief

*The thesis the design tests* [AI reading]. Evolution is becoming read where patterns go on through the turnover of their parts: one root, not a second theory. The root's map already has the shape. Its carrying renewal (`«传»`) is a pattern continuing under a coarse class while a line of parts begins under a fine one. Where the pattern has a predecessor, a beginning of a part is the end of a carrying renewal (`«粗有前则生为传»`). A pattern can renew and still end on every branch (`Map.Short.renews_and_ends_everywhere`). Read on lineages, descent is the relation, a kind is the coarse class (`Web.kindClass`), and the fine class is the carrier (`Web.carrierClass`), read as the organism. Grains are written (coarse, fine) as in the Lean, so (kind, carrier) is read as (kind, organism). The map's regions then say whether a lineage goes on by reproduction within its kind (`«生成»`), goes on without reproducing from some point (`«后守»`), or ends on every branch (`«退化»`). Those are demographic fates. Evolution proper, the change of heritable composition, is read by selection terms over shares.

EL's head result is the boundary between the two: the boundary of the region of courses of selection terms that decide whether a family goes on, in the glossary's sense of a region where a law's verdict holds. It is exact at the counting layer, on generations listed as families:
- A selection term positive at unboundedly many steps forces the family to go on (`SelectionShift.Generations.never_empties_of_unbounded`).
- From a nonempty first generation, a course whose terms are zero from some step on is shared by a course that goes on and one that ends (`Horizon.eventually_zero_two_fates`). `Horizon.terms_boundary` joins these two cases, as a restatement.
- Within a horizon `H`, every course nonempty at `H` has its terms through `H` shared by a course that goes on and one that ends (`Horizon.two_fates_of_nonempty`).

Which case a course is in, these laws do not decide. On `Descended` courses read on the map's regions, the horizon form is shown for one course of terms per horizon; the every-course form is open. On the map the boundary is narrower. Where listed offspring continue their parents, a term positive at every nonempty generation from a nonempty generation on forbids that every member of that generation degenerates (`LineageRegions.not_all_degenerate_while`). It decides no point's region.

Four parts, by standing:

1. **EL1, the selection–region boundary** (head result).
   - *Shift and horizon.* The selection term proper is unchanged by a common shift of offspring numbers, while the next generation's size is not (`Generations.shift_step`). So within a horizon the terms need not decide a fate. From a nonempty first generation, terms zero from some step on decide nothing, and terms positive at unboundedly many steps force going on. At the counting layer the within-horizon claim holds for every course nonempty at the horizon; on `Descended` generations read on the map it is shown for one course per horizon.
   - *The exception.* Read by offspring number with exact transmission at every step from `t` on, a positive term at `t` (its concordance; under `ByNumber` discordance is zero) forces going on. Exactness at `t` alone does not (`ExactOnce.exact_once_ends`). On the map, in `Descended` generations under `Acting`, births within the kind and embodied offspring, it puts some member of generation `t` in `«生成»` at (kind, carrier).
   - *Where the exception fails.* Under balance and dissipation within the lineage's family exact transmission fails. Where the census holds every continuation, the line from every member of a generation up to stock + 1 then ends on every branch, at every stock.
   - *Whole generations.* Where listed offspring continue their parents, a whole generation degenerates only if a later generation is empty, and exactly then where the census also holds every continuation.
   - *Evolutionary suicide.* So its witness is selection positive at every generation but the last nonempty one, where the term is necessarily zero, while every member degenerates. A term positive at every nonempty generation while every member of a generation degenerates is impossible where listed offspring continue their parents. At a kind grain that separates offspring from parents it holds (`Courses.positive_and_degenerate_at_own_kind`), so the impossibility is a law of the kind grain.
2. **EL2, regime, not level.** Each of the three landed ending laws, read as a decider of a lineage's region under EL2's premise on the line's reach, is a regime:
   - renewal gated on what it renews, run past it;
   - dissipation within the family;
   - a draw on a condition given nothing.

   Under each, the stock sets only the horizon, not the fate, and at every stock `s ≥ 1` the stock alone decides neither fate (`LineageRegimes.stock_forces_neither`). That every decider of a lineage's region is one of the three is not shown.
3. **EL3, the constructive degeneration law.** Take a line from an active occurrence, every point of which reached at one step `N`, not before the start, is inactive. It ends on every branch (`«尽»`).
   - This holds at every class within activity (`Web.every_branch_ends_of_gone`), with no excluded middle and no premise of a single line.
   - It turns 02's "does not go on" into degeneration wherever a uniform horizon is known: at `MapInstances`' activity grain (its owner's) and at the kind grain of `KeepingWidening`, the lineage continuation included.
   - Reaching an end (有终) still needs continuation to be decided. That is exactly as strong as excluded middle, on the grammar and on the base.
4. **EL4, giving that waits on giving, under selection** ([WS.md](WS.md)), with three sources of what a gift brings beyond what it draws.

Readings and instances, counted as evidence for existing records, not as results (§6): the lineage continuation itself, its carrying renewals, the regions read on lineages, and widening read with lineages.

## State of the Lean

Landed: the six modules below joined the core as leaves at receipt EL_RECEIPT (study section EL_SECTION), every axiom report empty, no existing module changed. They are the modules of round 4 with the verifiers' docstring fixes listed at the end of this section, and with `LineageRegions`' copies of EL3's laws and of `SelectionShift`'s counting dropped for imports.
- *Recompiled.* In round 4 each module was recompiled from source with Lean 4.29.1 by an independent verifier, not restored from a cache.
- *Axiom reports.* Every source declaration has an empty axiom report. An environment scan of every constant each module adds finds one that depends on an axiom: `PairSelection`'s `Place.mk.injEq`, on `propext`, which Lean generates and nothing uses. `check_becoming.py`'s environment audit admits such generated `injEq` lemmas and lists them.
- *Imports.* Each module imports only core modules and the EL modules below it.
- *Dependents.* `LineageRegimes` and `PairSelection` were recompiled against the final `LineageRegions` and `WindowedWaiting`: by round 4's verifiers, and again for the kit's commit `4fd5b45d7`.
- *The kit* is on branch `el-kit`, in this study's `kit/` folder; it is not on this branch. It holds the six modules, byte for byte as below, together with the builders' and verifiers' reports of rounds 1–4 (`kit/reviews/round1.json` to `round4.json`, the two text reviews in `round3.json`) and the verifiers' probes (`kit/probes/`).
- *Checked.* `check_becoming.py` ran with all six registered in its core list, at receipt EL_RECEIPT.

| Module | Lines | Imports | Carries |
|---|---|---|---|
| `Becoming.LineDegeneration` | 562 | `KeepingWidening` | EL3 (§5) |
| `Becoming.SelectionShift` | 1,178 | `Reproduction` | EL1, the counting layer (§3) |
| `Becoming.LineageRegions` | 1,715 | `Reproduction`, `KeepingWidening`, `Roles`, `SelectionShift`, `LineDegeneration` | EL1 on the map (§3), the lineage continuation (§6) |
| `Becoming.LineageRegimes` | 1,174 | `LineageRegions`, `Continuation`, `MutualDependence`, `Population` | EL2 (§4) |
| `Becoming.WindowedWaiting` | 1,537 | `Tolerance` | EL4a ([WS §3](WS.md#3-el4a-answering-within-a-window)) |
| `Becoming.PairSelection` | 2,255 | `WindowedWaiting`, `SelectionLevels`, `RuleShaping`, `DrawnBeyond` | EL4b, EL4c ([WS §4](WS.md#4-el4b-and-el4c-offspring-from-a-run-and-three-sources)) |

Round 4 made the fixes the round-3 verifiers named. Two of them change a statement:
- `Chain.kinds_apart` now uses the reflexive kind `fun a b => a = b`, with `Chain.stands_once`.
- `kids_continue_supported` takes `SupportedAfter`, the half of `UnsupportedBefore` it uses; `supportedAfter_of_unsupportedBefore` gives it.

Round 4 also made these changes:
- *LineageRegions.* The docstrings' scope of (d) and "the terms decide at every step" are narrowed. It adds `not_all_degenerate_while` and `Courses.positive_and_degenerate_at_own_kind`.
- *SelectionShift.* Its unproved calibration sentence is shortened, and its copy of `eq_zero_of_not_pos` is replaced by `Becoming.eq_zero_of_not_pos` (module `Becoming.Flow`). `Horizon.before` is renamed `Horizon.markedPair`, and `ExactOnce` is added.
- *LineDegeneration* adds `Map.StepWhere`, so the grammar calibration needs no World witness, and `Map.Undecided.first_has_next_iff`.
- *LineageRegimes.* `Course` is renamed `GatedPairCourse`, and `Handover.relay_one_flow`, `Handover.not_draw_regime` and `multiplying_takers_stop_of_need` are added. All four takers of generation two are stated unsupported.
- *WindowedWaiting* adds `Pair.not_absorbs_and_answers_spaced`.
- *PairSelection.* `Seat` and `mate` are renamed `Place` and `other`. `Needs` is rebuilt so that `childless` is not vacuous, and the strict echo and assortment laws and the factor bounds under a supplied reading are added.

The round-4 verifiers named these fixes before landing; none changes a statement. All were made at landing, except the moves and renames at placement, which `LineDegeneration`'s docstring proposes to their owners, each on its owner's yes:
- `LineDegeneration`:
  - At placement in `GrammarMap`, state `Map.StepWhere` as that module's `Map.short` gated by `P`. Its owner decides whether the three grammar laws take its Chinese law names.
  - The round-4 proposal to rename `Map.Undecided` is dropped: the name states no wrong meaning (the witness is a web whose start is continued exactly where an undecided proposition holds), and sharing a word with the top-level namespace `Becoming.Undecided` is an ambiguity, not a wrong meaning (08 §10).
  - Reflow one docstring.
- `SelectionShift`: word the exception bullet's extension of `rises_exact_iff` as the nonemptiness of generation `t + 2`, as §3 (b) does.
- `LineageRegions`:
  - `Courses.same_terms_two_fates`: "need not decide", as the (a) bullet says.
  - The own-kind witnesses: at `Q := (· = ·)` the kind class is the carrier class, and the line takes no step (§3 (d)).
  - `Courses.positive_but_last`: the zero last term comes from counting alone (`last_term_zero`).
  - `generation_of_exact` assumes exactness from `t`; it does not derive it.
  - The copies' counterparts named exactly: `SelectionShift.pos_weight_of_concord` and `pos_weight_of_discord`.
  - `line_ends` counted as the lemma it is labelled, not among "four new laws".
  - "(kind, organism)" written as (kind, carrier).
  - At landing: drop the copies of EL3's laws and of `SelectionShift`'s counting, and import both.
- `WindowedWaiting`:
  - Narrow the gloss on `Pair.dnf_keeps_iff_em` to the normal form proved (WS §3 (g)).
  - Write "erring", not "withholding", in `not_absorbs_and_answers_spaced`'s heading.
  - Drop one duplicate mention of `dnf_keeps_em`.
- `LineageRegimes`:
  - The draw regime's premise fails "over two or more steps", not without scope.
  - `multiplying_takers_stop_of_need` carries `requires` without using it.
  - `MultiplyingTakers.multiplying`'s conclusion also follows from step two's inactivity.
  - `draw_not_doubling`'s prose should match its statement.
- `PairSelection`:
  - `Place.received_factor_le` and `Place.withheld_factor_le` are bounds under a supplied reading, not results, and `window_echo_lt_iff` is a corollary.
  - Write "at least one step after it" in `window_echo_favours_iff`'s docstring.
  - Land against EL4a's final `WindowedWaiting` bytes.

## 1. The sense of "one theory", and its limits

*Argument* [AI reading]. Evolution's ingredients are relations the account already states.
- Heredity is transmission: inheritance of a dependence with a need within δ of the giver's (`Web.transmits_at_iff`, `Flow.TransmitsWithin`, 04 §2). Variation is transmission with δ > 0.
- A pattern outlasting its carriers lasts only through passing (`Web.ByPassing`, 04 §2).
- Selection is differential continuation through couplings (03).
- The fates of what passes on are the map's regions.

So evolution, as read here, needs no premise beyond the root and its World model, which supplies the amounts (§7, §8). What it needs is the reading on lineages and the laws joining that reading to selection.

Five limits, kept in every summary of EL:

- *Selection reads shares; the map reads regions.* A selection term is an identity of counts over a listed cohort; a region is a property of a whole course along lines. Shares sum to zero in position and see nothing beyond their couplings (05 §3, §6). The two meet only through laws such as EL1.
- *The regions on lineages are demographic.* At (kind, carrier) they see whether births within a kind keep coming, not what is inherited. Evolution proper is the change of heritable composition, which the shares read. A lineage whose descendants all change kind ends on every branch at the kind grain while descent goes on: this is pseudo-extinction, a reading. EL reads regions also at (activity, carrier) along descent, so that a change of kind is not counted as an end.
- *Not all becoming is Darwinian.* Selection among kinds needs formations that recur as kinds and pass on; the whole is not a member of a population of wholes. One theory in the broad sense, as one root, not one definition.
- *Going on is not widening, and generation is not 生生.* `«生成»` holds for any lineage going on with turnover where turnover is read as beginnings.
  - Two formations reborn from each other at stock one are in it, with no growth and no novelty: at the grain of activity when each is embodied (`LineageRegions.StandingRelay.grain_decides_region`), and along passing of support (`ClosedCycle.generates`). The same cycle keeps (`«守»`) at a grain of support where nothing is required.
  - In `Reproduction.Relay` as landed, both formations are supported at every step (`LineageRegions.RelayRead.supported`; the relay's web counts both active by definition). No descent is a carrying renewal at either grain (`RelayRead.descent_not_birth`).
  - Widening what can form is a further claim. 生生 read as widening is generation of the possible that loses none of it (07 §2). Generation of lineages and widening meet only where §6 says.
  - On branching lineages `«生成»` and `«后守»` overlap (`Map.«生守相杂»`), and placing every point in a region is exactly excluded middle (`«三域之定当且仅当排中»`).
- *No fate is thereby better.* No law of EL ranks lineages or courses. Ranking is the ethics' question under its two premises, the continuation condition for scope and C for order (07). 04 already says no amount, lineage, group or level of selection is shown better.

Purposes (board, "Purpose first"):
- a unified explanation of reality (UE): evolutionary theory read on the root, and its forbidding stated exactly where it leaves open what decides a lineage's fate;
- alignment of the joint selection (AJ): humans, institutions and trained systems evolve together.
  - A selection favouring a share at every step but the last nonempty one can end the family (EL1's witness).
  - At the counting layer, a selection favouring a share at every step while the family lasts cannot.
  - On the map, where listed offspring continue their parents, it leaves not every member of a generation degenerating (`not_all_degenerate_while`).

## 2. What is landed, and what EL uses

| Area | Landed | Carrier |
|---|---|---|
| The map | `«传»`, `«生成»`, `«守»`, `«后守»`, `«退化»` (= `«尽»`), the strong forms, exclusions and coverage; `«粗有前则生为传»`, `«生则或粗生或传»`, `«传则粗不生»`; `«阶生成则上不退化»`; `Map.Short.renews_and_ends_everywhere`, `Map.Once`, `Map.«生守相杂»` (`Becoming.GrammarMap`, `Becoming.MapRegions`; record generation-and-degeneration-at-two-grains) | root, every relation and pair of classes |
| The map on the World | `Web.carries_iff` (any continuation), `Web.passing_carries_iff` (any `passes`), `Web.not_endless_of_gone`, `Web.degenerates_of_gone` (有终, with deciding), `Web.family_excess_not_endless`, `Web.consumed_held_not_endless`, `stopped_not_endless`, `Map.renewal_undecided`, `Map.shifted_generates` (`Becoming.MapInstances`); `Web.passingContinuation` (`Becoming.PatternPassing`), which carries dormant formations on; `Web.Lineage`, `Web.lineage_iff_line` (`Becoming.Identity`) | World; strong forms and ¬`«不穷»` only |
| Kinds | `Web.kindClass`, `Web.kindGrains` (0 formation, 1 kind, 2 activity), `Web.withinKind` (at the grain of activity from an active start it links no dormant formation, `LineageRegions.active_along_kind`; at a grain of support where nothing is required it carries one on, `LineageRegions.OneBirth.dormant_goes_on_at_support`), `Flow.BeginsAlong.carries_kind_iff` at (activity, kind), `KindRelay` (`KindRelay.Runs.renews_even`: a new kind line begins while the lineage goes on; `keeps_widening` within kinds), `ClosedCycle.generation_without_widening` (`Becoming.KeepingWidening`; record what-keeping-widening-needs) | World, along passing of support |
| Descent and selection | `Flow.DescendsAt` (giving to what comes to stand), `DescendsAt.supported`, `unsupported_childless` (`Becoming.Evolution`); `Web.Embodied.descends`, `Embodied.comesToStand`; `SelectionTerm.Flow.Descended` (each listed offspring descends from its parent), consumed by `Reproduction.Flow.lineage_ends`, `GroupEnding.Flow.coupled_end_together`, `SelectionTerm.Flow.support_not_lower`; `SelectionTerm.concord_uniform`, the pair counts built from `excess`; `Reproduction.Generations.ByNumber`, `ByNumber.rises_exact_iff`; `Reproduction.Flow.lineage_ends` (closed, balanced, dissipated family: empty within stock + 1 generations), `closed_lineage_lowered` (exact transmission fails within the stock), `Reproduction.Relay` (a lineage kept at stock one; dissipation is needed) (records selection-term-over-generations, what-bounds-offspring-numbers, selection-among-groups-by-ending) | World, list cohorts |
| Evolution's rows | U4's lever 2 places 04's 18 central rows; by its boundary design only row 17 has a strict root form (`RootForms.outside_leaves_no_offspring`, leaf `Becoming.RootForms`, landed with U4, cdeb6b1e8); row 5's relational part is `RootForms.descent_forms_no_dependence`; rows 6, 12, 18 are counting laws | U4's |
| Amounts | `Flow.joint_excess_ends`, `Flow.family_excess_ends` (gated, no dissipation premise), `Flow.excess_bounded` (n steps of excess need a level of at least n), `Flow.Balances.doubling_needs` (on a condition given nothing, n steps of a draw exceeding everything drawn before need a level of at least 2ⁿ − 1), `RegimeMargin.ends_beyond_giving` (records own-count-misses-joint-excess, whole-drawing-beyond-renewal-ends, mutual-dependence-and-its-pace) | World; regime carrier |
| What selection does not see | `Flow.share_not_against` (the share reaching beyond is never selected against), `Flow.Balances.rise_breaks_beyond`, `Flow.favours_breaking_beyond`, `breaks_beyond_unsettles`, and the inflow-graded laws `rise_le_inflow_beyond`, `rise_bounded_by_beyond_inflow`, `breaks_beyond_inflow`, `favours_breaking_beyond_inflow` (records what-a-rise-draws-from-beyond, a-rise-past-the-inflow-is-drawn-from-beyond); `SelectionPace.selection_within_carried` (record pace-of-selection-within-what-flows-in) | World |
| Widening | `Steps.keepsWidening_iff_generation_losing_nothing` (on moments, by name, under two deciding premises; record keeping-widening-is-generation-losing-nothing), `Web.keepsWidening_byName_iff_generation`, `Flow.begins_late_of_keepsOpening` (up to double negation, World premises), `Flow.whole_not_keepsWidening` (by name), `Flow.not_keepsWidening_along_passings`, `Flow.new_beyond_every`, `Run.adaptive_rule_changes_of_keepsWidening` (any adaptive run) | chains, World |

## 3. EL1: the selection–region boundary

**Carrier.** Two layers.
- *The counting layer* is the `Generations` of `SelectionTerm` alone (`Becoming.SelectionShift`). There "goes on" is every later family nonempty and "ends" is every family empty from some step on.
- *The map layer* is generations of descent, `SelectionTerm.Flow.Descended L W G` (landed), on `Flow X X`, read on the lineage continuation of §6 (`Becoming.LineageRegions`). Its grains are (kind, carrier) and (activity, carrier), the carrier read as the organism.

The only new join is that a `Descended` generation lies on that continuation (`LineageRegions.descended_carries`, `kids_continue`). Its premises depend on the grain:
- *At the grain of activity* it needs `Acting`, births within the kind and embodied offspring (`descended_carries`, `kids_continue`), and no newness. A revival (a formation fallen to zero and raised by a gift) is a birth there, since `«生»` reads only the step before.
- *At the grain of support* a birth needs `Acting`, births within the kind, `Dependent`, and each listed offspring supported after its step and not at the step before (`UnsupportedBefore`, `descended_carries_supported`); `supported_carries_iff` is an exact iff. That listed offspring continue their parents there needs only the first half, supported after the step (`SupportedAfter`, `kids_continue_supported`). First support from any earlier step says no more than unsupported at the step before (`firstSupported_iff_step`), and never supported before (`FirstSupportedOffspring`) is more than the join needs.

In the landed stock-one relay no descent is a birth at either grain (`RelayRead.descent_not_birth`).

**Target laws.**

- (a) *Shift invariance.* **Standing:** proved at the counting layer in a qualified form; the draft's unqualified form is refuted; on the map, proved for one course per horizon, the general form open.
  - *The invariance.* The selection term proper (concordance and discordance of offspring number with an amount) is unchanged when a common number is added to every offspring number. The pair counts are built from `excess`, and `excess (x + k) (y + k) = excess x y` (`SelectionShift.excess_shift`, a restatement of the landed `Becoming.excess_add_right`, module `Becoming.Stuttering`, so not a new law). Meanwhile the next generation is larger by `k` for each member (`Generations.shift_step`).
  - *Within a horizon.* Take any horizon `H` and any course of generations nonempty at `H`. There are two courses with its families and its terms through `H`, with the same terms as each other at every step: one nonempty at every generation, one empty from `H + 2` on (`Horizon.two_fates_of_nonempty`). Where its terms are zero after `H`, both have its terms at every step (`zero_after_two_fates_shifted`).
  - *Terms zero from some step on.* For a course nonempty at its first generation whose terms are zero from some step on, a course that goes on and one that ends have its terms (`eventually_zero_two_fates`).
  - *Refuted: "no course of selection terms decides".* Terms positive at unboundedly many steps force every generation to be nonempty (`Generations.never_empties_of_unbounded`). The premise is strictly weaker than positivity at every step (`Alternating.unbounded_not_every`).
  - *The boundary at the counting layer.* `Horizon.terms_boundary` joins `Generations.never_empties_of_unbounded` and `eventually_zero_two_fates`, for a course nonempty at its first generation. It is a restatement, not a further result. Every course of terms falls in one of the two cases only classically. Deciding which, and finding the `H` of the second case, is not proved here, and no calibration of it is claimed.
  - *On the map.* For every horizon `H` there are two `Descended` courses on `Flow X X`, in which only active formations give and every formation is embodied. They have the same families through `H + 1` and the same selection terms proper through `H` (concordance two, discordance zero). In one the marked line is in `«生成»` at (kind, carrier); in the other the lineage is in `«退化»` (`LineageRegions.Courses.same_terms_two_fates`). That is one course of terms per horizon. That every course of terms over a horizon has two such fates on `Descended` courses read on regions is open, as `LineageRegions` work.
  - Relative standing within a horizon need not decide persistence.
- (b) *The exception.* **Standing:** proved. It needs exactness at every step from `t`, more than the draft stated. On the map the conclusion is at a member, not at the whole lineage.
  - *At the counting layer.* Read by offspring number (`ByNumber`) with exact transmission (`Exact`) at every step from `t` on, a positive selection term at `t` (its concordance; under `ByNumber` discordance is zero) means offspring numbers vary (`varies_of_selection`). So some parent has an offspring, and with exact transmission its line has as many in every later generation (`line_kept`): every later generation is nonempty (`goes_on`).
  - *What it extends.* The landed one-step law `Reproduction.Generations.ByNumber.rises_exact_iff` gives, with exactness at `t` and a positive term at `t`, that the mean rises at `t`, so generation `t + 2` is nonempty. `line_kept` and `goes_on` extend that nonemptiness to every later generation under exactness from `t`; the mean-rise law itself is not extended.
  - *Exactness at `t` alone is not enough.* Take a course read by offspring number, exact at step 0 and not at step 1, and concordant at step 0. It has one member at generations 1 and 2 and is empty from generation 3 on (`ExactOnce.exact_once_ends`, a witness).
  - *What forces going on.* The positive term is sufficient, not necessary: under these premises every later generation is nonempty exactly where generation `t + 1` is (`goes_on_iff`). What forces going on is exact transmission of a positive offspring number. The premises hold together (`OneLine.goes_on_premises`).
  - *On the map.* Assume `Descended` generations read by offspring number (`ByNumber`), `Acting`, births within the kind and embodied offspring, with exactness from `t` on; no newness is needed. Then a member of generation `t` with an offspring is in `«生成»` at (kind, carrier) (`LineageRegions.generation_of_exact`). So a positive term at `t` puts some member of generation `t` there (`generation_of_positive_term`).
  - *Nonempty generations do not suffice at a point.* In `Chain` every generation is nonempty, transmission is exact and the term at step 0 is positive (concordance one). Yet beside a generating member, a childless member of the same generation degenerates (`Chain.chain`).
  - A zero term decides nothing: one offspring each against none each (`ZeroTerm.decides_nothing`).
- (c) *Where the exception cannot hold.* **Standing:** proved, with a census premise the draft lacked, shown to be needed.
  - Under dissipation within the family the lineage lives in, exact transmission fails within the stock (`closed_lineage_lowered`, landed).
  - *Under the census.* Where the family is balanced and dissipated on at every step before stock + 1, and the census holds every continuation (`ContinuationsListed`), the line from every member of a generation up to stock + 1 ends on every branch, at every stock, at the kind grain or at the grain of activity. This is `LineageRegions.degeneration_of_dissipation`, from `lineage_ends` through EL3's law. At the grain of activity the census holds where every descent within the kind from a member is listed and no member carries on as itself (`listed_of_census`). `LineageRegimes.dissipation_degenerates_every_member` extends this to every generation.
  - Without the census premise it need not hold: in `Lasting`, `Descended`, balance and dissipation hold, and `lineage_ends`'s conclusion (generation stock + 1 empty) with them, and the offspring carries on as itself outside the census (`Lasting.lasting`).
  - `OneBirth.one_birth` meets every premise but the family membership, which holds by construction and is not in its statement: the line renews and still ends on every branch.
- (d) *Evolutionary suicide.* **Standing:** as the draft worded it, refuted where listed offspring continue their parents; the witness that can hold is proved; the join to 05's drain is open.
  - *The law.* Suppose listed offspring continue their parents on the coarse line (`KidsContinue`). At the grain of activity this holds under `Acting`, births within the kind and embodied offspring (`kids_continue`); at the grain of support, under `Acting`, `Dependent`, births within the kind and offspring supported after their step (`kids_continue_supported`).
    - Then every member of a generation degenerates only if some later generation is empty (`empty_of_degenerates`). Its lemma `line_ends`: a member whose occurrence degenerates has, from some depth on, no listed descendant. The proof is by induction on `«尽»` over finite families, constructive, and needs no census.
    - Where the census also holds every continuation, the converse holds, and a whole generation degenerates exactly where a later one is empty (`generation_degenerates_iff`).
    - Member by member: where every continuation of a member is one of its listed offspring (`ContinuationsAreKids`), a member degenerates exactly where at some depth it has no listed descendant (`degenerates_iff_line_ends`).
    - The census cannot be dropped from the converse (`Lasting.lasting`). Births within the kind cannot be dropped from the first law. At the kind grain with each formation its own kind (`Q := (· = ·)`, a reflexive kind), in `Chain` every generation is nonempty while every occurrence degenerates (`Chain.kinds_apart`). At that grain the kind class is the carrier class, and the line takes no step, so every occurrence degenerates. The witness fixes the law's scope; it is not a suicide at a finer grain. That the classes coincide and that the line takes no step are verifier's probes, the first by `rfl` and the second with classical logic, so neither is a core lemma.
  - *The refutation.* A selection term positive at every nonempty generation from a nonempty generation on leaves not every member of that generation degenerating (`not_all_degenerate_while`). Positivity at every step is its special case (`not_all_degenerate_of_positive`).
    - Both are corollaries of `empty_of_degenerates` with the counting fact that such terms keep every generation nonempty. They do not choose which member escapes, and they decide no point's region.
    - The counting layer gives the same. From a nonempty first generation, a term positive at every generation while the family is nonempty keeps the family nonempty (`SelectionShift.Generations.never_empties_while`), and at a last nonempty generation the term is zero (`last_term_zero`).
  - *The witness that holds.* Selection is positive at every generation but the last nonempty one, where the term is zero, and then the family is empty.
    - At the counting layer, on `Generations`: `SelectionShift.Shrinking.positive_then_empty`.
    - On `Descended` courses: `LineageRegions.Courses.positive_but_last`.
      - Concordance with a mark is positive at every step through `H` (two, by `Courses.same_terms_two_fates`).
      - Generation `H + 1` is nonempty with both terms zero, as at any last nonempty generation by counting alone (`last_term_zero`), and the family is empty from `H + 2` on.
      - Every member of every generation degenerates at the kind grain, with one kind, and the lineage renews and still ends (`«新而尽»`).
      - Every premise of the laws above is met.

    Selection decides what rises among the members, not whether any go on.
  - *Where the kind separates offspring from parents* (each formation its own kind), listed offspring do not continue their parents. There (d) as the draft worded it does hold: in `Courses` with reproduction always on, concordance is two at every step while every member of every generation degenerates (`Courses.positive_and_degenerate_at_own_kind`). As with `Chain.kinds_apart`, the kind class there is the carrier class and the line takes no step, so the witness fixes the scope of the law. It is the pseudo-extinction reading of §1 [AI reading].
  - *Open.* The amount in these witnesses is a mark, not a draw. Joining it to an amount that draws past the family's gated renewal (05 §1), and so 05's drain to 04's selection, is not done.

**What it restates and what it adds.** The distinction between relative and absolute fitness is classical: evolutionary rescue and evolutionary suicide, or Darwinian extinction (Matsuda and Abrams 1994; Gomulkiewicz and Holt 1995; Gyllenberg and Parvinen 2001; Webb 2003; Rankin and López-Sepulcre 2005; to be read before any record cites them). The shift itself is landed: it is the identity `Becoming.excess_add_right`. The record the-breeding-value already states the counted covariance linear in the amount under a common shift; a common shift of offspring numbers rests on the same identity. EL1 adds the exact form on one model with conservation and dependence:
- the two-fate laws at the counting layer, built on that identity: within a horizon (`two_fates_of_nonempty`) and for terms zero from some step on (`eventually_zero_two_fates`), with going on for terms positive at unboundedly many steps (`never_empties_of_unbounded`);
- the exception, extended from the one step of `rises_exact_iff` to every later generation under exactness from `t` (`line_kept`, `goes_on`), and its reading at a member on the map (`generation_of_exact`), with the regime that defeats it;
- the law that a whole generation degenerating is an empty later generation.

Each is read on the map's regions rather than on a growth rate, at the grains and under the premises stated above.

**Home and record.** 04 §3–§4 (life), one record, working title the-selection-term-and-a-lineages-fate.
- *New laws.* `empty_of_degenerates`, `generation_degenerates_iff` and `degenerates_iff_line_ends`. With them, SelectionShift's `never_empties_of_unbounded`, `eventually_zero_two_fates`, `two_fates_of_nonempty`, `line_kept` and `goes_on`.
- *Not counted as results:*
  - `line_ends`, a lemma of `empty_of_degenerates`;
  - `Horizon.terms_boundary` and `excess_shift`, restatements;
  - `not_all_degenerate_while` and `not_all_degenerate_of_positive`, corollaries with SelectionShift's counting;
  - the `Courses` and `Chain` witnesses, witnesses (map readings of SelectionShift's).

## 4. EL2: regime, not level

**Targets** (`Becoming.LineageRegimes`).

- (a) *Each of the three landed ending laws, read as a decider of a lineage's region, is a regime with a horizon computed from the stock.* **Standing:** proved, as readings of the landed laws, with one new premise on the line's reach. The classification is of these three laws. That every decider of a lineage's region is one of them is not shown, and not claimed.
  - *Renewal gated on what it renews, run past what it gives.* `n` steps of joint excess need a level of at least `n` (`excess_within_level`). In the family form they need a stock of at least `n` (`family_excess_within_stock`), so no course has stock + 1 such steps (`family_excess_not_past_stock`). These restate `Flow.excess_bounded` and `Flow.family_excess_bounded` and are not results. `Flow.joint_excess_ends` gets no lineage reading here.
  - *The gated regime on a lineage* needs a premise on the line's reach. Suppose:
    - the flow balances;
    - whatever gives to a member of the family `ds` requires a member of `ds` at a need of at least `m` (the gate);
    - everything the line reaches at `T + n` requires a member of `ds` at such a need;
    - only active formations give, and activity needs support.

    Then `n` steps of excess from a stock below `n + m` make the line from an active occurrence, at a step not after `T + n`, degenerate at the kind grain (`degeneration_of_family_excess`). This is the kind-grain reading of EL3's `Web.family_excess_degenerates` with `Flow.family_excess_ends`, not a further result.
    - Where the census holds every continuation, it is enough that every member of generation `T + n` so depends (`degeneration_of_family_excess_listed`).
    - At need one the horizon is the stock itself (`degeneration_at_stock_horizon`).
    - At need zero the premises cannot hold together, by a verifier's probe through `family_excess_within_stock`. That probe is not in the module, and no record cites it.

    The gated laws end formations, not lines: the premise on the line's reach is what the lineage reading adds.
  - *Dissipation within the family.* `dissipation_degenerates_every_member`: every member of every generation degenerates (§3 (c)).
  - *A draw on a condition given nothing.* Where the draw at the `j`-th step is at least `2 ^ j`, the level at the start satisfies `2 ^ n ≤ level + 1` (`draw_doubling_needs`). `doubling_needs` is its case (`exceeds_doubles`, `doubling_needs_of_draw`).
- (b) *Without such a regime both fates occur, at every stock.* **Standing:** proved.
  - *The handover.* In a handover on two relata (`Handover.flow`), the relatum whose turn it is holds the step's amount, takes all of it and hands the next step's amount to the other. Every handover balances (`Handover.balances`), its stock at each step is that step's amount (`stock_eq`), and the giver is gated at need one (`gated`).
  - *Both fates from one stock.* Both courses below start from the same stock `s` (`Handover.both_fates`). So no verdict on the region follows from the stock alone (`stock_forces_neither`, a restatement of `both_fates`' pair with `«生成退化不并»`). It is stated under `GatedPairCourse`, which lists the premises both courses meet and encodes no verdict.
  - *The relay*, with amount `s` at every step, is a `Descended` course with no excess and no dissipation, generating (`«生成»`) at (kind, carrier) (`relay_generates`). At stock one its take, give and level agree pointwise with `Reproduction.Relay`'s; its web differs in activity and requirement (`Handover.relay_one_flow`).
  - *The run-down*, with amount `s − t`, has `s` steps of excess and dissipation at every step. It degenerates through the gated regime at its horizon (`runDown_degenerates`).
    - The census reading of the gated regime and the dissipation corollary both apply to it, and the draw regime's premise fails over two steps (`runDown_every_regime`).
    - No handover meets the draw regime's premise over two or more steps (`Handover.not_draw_regime`). At one step the premise holds and its bound is trivial, by a verifier's probe.
    - These witnesses show that the premises hold together, not that a regime is needed. The census reading's premise on generation `s` holds vacuously, that generation being empty, and the run-down's degeneration also follows from nothing being active at step `s`.
- (c) *The draw's witness on takers that need it.* **Standing:** proved, with which member stops left undecided.
  - *The laws.* Consider generations of takers from at least one, each at least doubling the one before, each drawing at least a unit per member, on a condition given nothing.
    - They last at most `log₂ (level + 1)` generations (`multiplying_takers_need`).
    - Where every member takes part (present, taking a positive amount) and no generation lists a member twice, a generation draws at least its size (`size_le_taken`); `multiplying_takers_stop` applies this to the members that stay active. So where `level + 1 < 2 ^ n`, not every member of the first `n` generations stays active (`multiplying_takers_stop`).
    - The premise that the condition is given nothing is kept in both statements.
  - *What "needing" means.* In `multiplying_takers_stop` it means being active only while taking (the premise `needs`); `Web.need` does not enter. The variant `multiplying_takers_stop_of_need` states the premise through the web: each active member requires the condition, has a need of at least one and takes at least its need, the link from need to take supplied. There `requires` is carried but not used, and the need enters only as a lower bound on the take.
  - *The witness.* `MultiplyingTakers.multiplying` meets every premise of both at level three. Every taker of generation two is unsupported (`MultiplyingTakers.unsupported`) and inactive, the next generation is empty, and the line from the first degenerates. `MultiplyingTakers.stops_of_need` reaches the stop through the variant. The witness shows the premises hold together; its conclusion also follows from step two's inactivity alone, by a verifier's probe.
  - *The contrast.* In `DoublingDraw` the formation needs nothing and ends nothing; here the takers require the pool and end.
  - *Not shown:* which member stops, and at which step (naming one asks to decide activity), and that multiplying takers degenerate on the map in general.

**Boundary** of the region where the three regimes' verdicts hold. Neither regime binds renewal from outside. **Standing:** proved as a witness.
- *The witness.* In `FromOutside` a renewer gives two units at every step and does not require the condition. Two takers each take one, within what is given each and together. Nothing is in excess, the condition is not dissipated on, and every formation is active and supported at every step (`FromOutside.from_outside`). The gated premise fails at every need (`not_gated`).
- *"From outside".* In the model a formation's giving is not drawn from its own level unless it takes, so "from outside" means from no listed condition.
- *What it answers.* The witness answers the scope limit stated in 05 §1's record, that the gated conclusions do not reach such renewal. Among the three laws read as deciders, what ends a lineage is a regime; the stock sets when, not whether.

**Home and record.** Home 04 §4, with 05 §1 pointing to it. The record is either an amendment of what-bounds-offspring-numbers and whole-drawing-beyond-renewal-ends, or a record of its own for the lineage reading of the gated regime, the pair of fates at every stock and the takers' law. This is decided with the owners at landing.

## 5. EL3: the constructive degeneration law

**Target.** **Standing:** proved in a stronger form (at every class within activity, not only at activity; the corollaries run the other way); the draft's claim about 有终 is refuted (`Becoming.LineDegeneration`).
- *The law.* Take `continuationStep R` at any class `E` included in activity (`«则» E W.activityClass`); activity itself and the kind class `kindClass W Q` are both instances. From an active occurrence `x`, suppose every occurrence the line under `E` reaches at step `N` is inactive (at activity, `not_endless_of_gone`'s premise). Then the line ends on every branch: `«尽»` at `x`, hence `«退化»` (`Web.every_branch_ends_of_gone`).
  - The induction is on the steps left, `N − y.1`, along every branch (`Web.ends_of_ends_at`).
  - It uses no excluded middle and no premise that each occurrence has one continuation.
  - `«尽»` reads only the coarse class, so no fine class enters.
- *What it rests on.* Under any `E` within activity the premise says that nothing the line reaches lies at step `N`. In that form the law holds at every class, by `ends_of_ends_at` applied vacuously. The content is that a uniform horizon gives `«尽»` constructively on branching lines; the activity form states the horizon through activity.
- *The instances.* At activity, `Web.activity_every_branch_ends_of_gone` has exactly `not_endless_of_gone`'s premises. The lineage continuation `withinKind W Q passes` at the kind class, with any continuation `R`, is an instance of `Web.kind_every_branch_ends_of_gone`.
- *The corollaries, the other way round.* Under exactly the hypotheses of `family_excess_not_endless`, `consumed_held_not_endless` and `stopped_not_endless`, the line degenerates (`Web.family_excess_degenerates`, `Web.consumed_held_degenerates`, `Web.stopped_degenerates`), each through one pointwise gone lemma. Those three landed laws follow from degeneration through `«尽则非不穷»`, so the new laws are the stronger ones.
- *有终 still needs its decision.* Without the decision, the base gives degeneration (`«尽»`), and 有终 only up to double negation (`Map.not_not_end_of_ends`). With the decision, it gives 有终 (`Map.end_of_ends_decided`).
  - *On the grammar.* That every line ending on every branch reaches an end is exactly excluded middle (`Map.end_of_ends_iff_excluded_middle`). Its forward direction uses the module's own two-point witness `Map.StepWhere`: one step from `false` to `true`, taken exactly where `P` holds. The line from `false` ends on every branch (`Map.StepWhere.ends`), takes its step exactly where `P` holds (`Map.StepWhere.has_next_iff`), and any end decides `P` (`Map.StepWhere.end_decides`).
  - *On the base.* That every line meeting the law's premise at the grain of activity reaches an end is exactly excluded middle (`Map.end_of_gone_iff_excluded_middle`). The witness is `Map.Undecided`. The premise holds and the pattern degenerates, the start is continued exactly where `P` holds (`Map.Undecided.first_has_next_iff`), and any end it reaches decides `P` (`Map.Undecided.end_decides`).
  - *What this says about the unfolding.* A line known to end on every branch within a known horizon does not thereby show a point at which it ends. Showing one is deciding, at the points of the line, whether a step continues it.
- *Witnesses.* The premises of each law hold together from an active start: `Map.Depleted`, `Map.coupled_degenerates`, `Map.stopped_relay_degenerates` and `Map.Undecided`, with `Map.StepWhere` on the grammar.
  - For each regime a «续» lemma states the step the line takes before it degenerates (`Map.Depleted.continues`, `Map.coupled_continues`, `Map.stopped_relay_continues`).
  - In the witnesses of consumption and of a whole drawing, `held` is shown at every occurrence; the stopped relay has no `held` premise.
  - In all three, activity is given, not derived from the regime.

**Placement** (each part on its owner's yes; EL proposes it on the board).
- *Into `GrammarMap`, on OU's owner's yes:* the part stated on the grammar alone. That is `Map.not_not_end_of_ends`, `Map.end_of_ends_decided`, the witness `Map.StepWhere` and the calibration `Map.end_of_ends_iff_excluded_middle`. It needs nothing of the World and would sit beside `«尽则非不穷»` and `«延尽之定当且仅当排中»`. There `Map.StepWhere` would be stated as GrammarMap's `Map.short` gated by `P`, and that owner decides whether the three laws take its Chinese law names. If the owner declines, this part goes into `MapInstances` with the rest.
- *Into `Becoming.MapInstances`:* everything else except the kind instance.
  - What goes there: the general law, its activity instance, the three gone lemmas and degeneration laws, the witnesses (`Map.Undecided` without its kind witness) and the base calibration `Map.end_of_gone_iff_excluded_middle`.
  - There the landed `not_endless_of_gone`, `degenerates_of_gone` and the three regime ¬`«不穷»` laws are re-derived in place from degeneration (rule 9), so no restatement is kept.
  - `Map.Undecided` keeps its name: it states no wrong meaning (08 §10).
- *The kind instance* (`Web.kind_every_branch_ends_of_gone`, `Map.Undecided.kind_degenerates`) cannot go there: `Web.kindClass` is defined in `KeepingWidening`, which imports `MapInstances`. It goes into `KeepingWidening` after `Web.kindClass_within`, on its owner's yes, or stays in a small leaf.
- *If the owners decline,* `Becoming.LineDegeneration` lands as a leaf, with its `Web.Restated` block labelled as restatements and no result.
- *A rename is proposed.* The landed name `Web.degenerates_of_gone` states a wrong meaning, since it concludes 有终, not `«退化»`. Its name says the pattern degenerates (`«退化»`, ending on every branch), while its conclusion is that the line reaches an end; the two differ, the gap being exactly excluded middle (§5 above). A rename to `Web.end_of_gone`, which states its conclusion, is proposed to `MapInstances`' owner. The moves above and this rename touch the root's map modules, which OU7's rebuild also changes, so they come after it, decided by the modules' owners. Until then `LineDegeneration` names its own law `every_branch_ends_of_gone`, to keep the two apart.
- *Home and record.* Home 02 §1 (map), as an amendment of generation-and-degeneration-at-two-grains or as its own record, the owner's call.

## 6. Readings and instances (evidence, not results)

- **The lineage continuation.** Carry on while supported, or descend.
  - It has the `Web.withinKind` shape with `passes t g x := L.DescendsAt W t x g` on `Flow X X` (so `F = C = X`; `LineageRegions.continuation`, `lineStep`).
  - It is not `Web.passingContinuation`, which carries dormant formations on and would put a dead formation in `«守»` for good.
  - `withinKind` avoids this at the grain of activity from an active start (`LineageRegions.active_along_kind`). Where support needs standing, that it avoids it is not shown.
  - At a grain of support where nothing is required, `withinKind` too carries a dormant formation on (`OneBirth.dormant_goes_on_at_support`).
- **Its carrying renewals.** From an active parent, a carrying renewal is a descent within the kind into a formation that is active after the step and that did not, at the step before, both stand active and carry on as itself (`LineageRegions.carries_iff`, `carrying_descends`). Where activity needs support, that formation arises. These are instances of `Web.carries_iff`, through `carries_iff_via_base` for a reflexive kind: a wrapper, an alias of generation-and-degeneration-at-two-grains.
- **The converse.** Every descent within the kind is a carrying renewal.
  - At the grain of activity this needs `Acting` and `Embodied`, and no newness (`LineageRegions.descent_carries`). It uses the direction from coming to stand to arising, the converse of `Embodied.comesToStand`.
  - At the grain of support it needs `Acting`, `Dependent`, and the offspring supported after the step and not before it (`descent_carries_supported`).
  - It is kept with EL1 in `Becoming.LineageRegions`.
  - Where every formation is supported at every step, nothing carries a renewal at the grain of support (`nothing_carries_of_always_supported`).
- **Regions on lineages**, written (coarse, fine) as in the Lean.
  - At (kind, carrier) there are three: going on by reproduction within the kind (`«生成»`), going on without reproducing from some point (`«后守»`), and ending on every branch (`«退化»`).
  - At (activity, carrier) along descent they are the same, without counting a change of kind as an end.
  - A new kind line while the lineage goes on is `carries_kind_iff` at (activity, kind), along passing of support, with `KindRelay.Runs.renews_even` as its witness. The converse lemma above is proved; reading a new kind line along descent through it is not built.
- **Widening, read with lineages.** None of these is new; each is cited where a chapter reads evolution.
  - By name, on a course's moments, keeping widening is generation of the possible that loses nothing, under two deciding premises (landed).
  - Along `withinKind`, keeping opening gives, up to double negation and under the World's premises, a new kind line after every step (`begins_late_of_keepsOpening`). Nothing keeps opening along a continuation containing passing of support (`not_keepsOpening_along_passings`), so the opening comes from passings across kinds.
  - By name, a finite closed whole cannot keep widening (`whole_not_keepsWidening`), but within kinds it can: `KindRelay` keeps widening within kinds in a finite, balanced, conserving world.
  - Generation without widening, along passing: `ClosedCycle.generation_without_widening`.
  - With the rule held fixed, what is possible under it does not keep widening (`Run.adaptive_rule_changes_of_keepsWidening`, any adaptive run).
- **Candidate witness, if wanted later:** a lineage going on within kinds while what can form for others narrows, read within kinds (not by name, where `KindRelay` already differs).

## 7. Not planned, and not shown

Not planned (04's programme, left as it lists them):
- Wright–Fisher with selection, two-way mutation with drift, inexact transmission across groups, rational amounts;
- how parts first come to live as one, wholes founded by several parts, changed units;
- a comparison against an equally informed rival;
- evolved evaluation joined to recognition, calibration and implementation;
- lifting 04's rows onto the grammar, which is U4's lever 2.

Not shown:
- that a fate or course is better (the ethics' two premises, the continuation condition for scope and C for order);
- that an actual population meets the hypotheses;
- probabilities;
- amounts on the root (the grammar has none; EL's laws are World laws read on the map's regions, through `MapInstances`).

Also not shown in the scratch Lean:
- that every generation nonempty puts some member in `«生成»`. That asks for a König-type choice of a branch; exact transmission is one premise that makes the choice constructive, and `LineageRegions.not_all_degenerate_of_nonempty` is the constructive half.
- a witness of going on that also meets balance and dissipation;
- EL1 (a) for every course of terms on `Descended` courses read on regions;
- EL1 (d) joined to 05's drain;
- that `withinKind` links no dormant formation where support needs standing;
- `Flow.joint_excess_ends` read on a lineage;
- that every decider of a lineage's region is one of EL2's three regimes;
- which case of the counting boundary a course is in.

## 8. Modelling choices

- Discrete steps.
- Natural-number levels, needs, gifts, takes and offspring numbers; Prop-valued activity, read as the web's activity or as support.
- Descent as giving to what comes to stand on `Flow X X`.
- Where descents are joined to births: `Acting` throughout; then `Embodied` at the grain of activity, or `Dependent` with offspring supported after their step and not at the step before at the grain of support. Supported after the step alone suffices for offspring to continue their parents there.
- Where an empty generation is read as degeneration: the census holding every continuation (`ContinuationsListed`), or every continuation a listed offspring (`ContinuationsAreKids`).
- Finite families as lists, which make the step from a whole generation's degeneration to an empty generation constructive.
- At the counting layer, "goes on" as nonempty families at every later step and "ends" as empty families from some step on. Newness is not represented there, and "same terms" compares concordance and discordance only.
- In the exception, exact transmission at every step from `t` on.
- A uniform horizon in EL3.
- Kinds supplied (`Web.kindClass` with a supplied `Q`; one kind in the witnesses, each formation its own kind in the scope witnesses).
- EL4's choices in [WS.md §6](WS.md#6-modelling-choices-on-which-the-laws-depend).

An empty axiom report says nothing of these; each law names those it uses.

## 9. Coordination, order and the release gate

- **Owners, asked on the board, each deciding for their module.** Chapter text goes through 04's, 02's and 05's home sections.
  - OU's owner (`GrammarMap`, `MapRegions`): EL3's grammar part, if wanted.
  - `MapInstances`' and `PatternPassing`'s owners, named in their history rows (OU6, UE7, GW): EL3's laws in `MapInstances` and the proposed rename of `degenerates_of_gone`, after OU7's rebuild.
  - UE's owner and GW's session (`KeepingWidening`, `WideningOnTheMap`): EL3's kind instance after `kindClass_within`.
  - The evolution modules' owners (`Evolution`, `Reproduction`, `SelectionTerm`, `GroupEnding`): `SelectionShift` above `Reproduction`, and any law of EL1 they want below.
  - U4's owner (`RootForms`, lever 2): nothing of U4 is restated.
- **Placement.**
  - EL3 as in §5.
  - EL1's counting layer in `Becoming.SelectionShift`, which imports only `Becoming.Reproduction`.
  - EL1's join to `Descended` courses and the map in the new module `Becoming.LineageRegions`. It imports `Reproduction`, `KeepingWidening`, `Roles`, `SelectionShift` and `LineDegeneration`, and only `LineageRegimes` imports it. It is new because it joins modules none of which can import it.
  - EL2 in the leaf `Becoming.LineageRegimes` above it.
  - EL4 as in [WS.md §8](WS.md#8-placement).
- **Order.**
  - The scratch Lean stays in a worktree off main; a `.lean` file in a study folder on main is picked up by the catalogue.
  - EL3 lands first, so that `LineageRegions` drops its copies of EL3's laws. Then `SelectionShift`, so that `LineageRegions` imports its counting lemmas instead of repeating them.
  - Then `LineageRegions`, with the verifiers' fixes; then `LineageRegimes`; then `WindowedWaiting` and `PairSelection`.
  - Core landing came after RV21c's fresh run, by readiness with UE26, BD2 and OU7 (the conditional-laws item; this note first named it OU5, an id taken on 23 October), on a slot from the coordinator, after a rehearsal; it landed at receipt EL_RECEIPT (study section EL_SECTION). RR2, HE2, U4's leaf and AJ4's documents, named here before, are landed (1721c70ef, 467f075ec, cdeb6b1e8, 3ada8819f).
  - The branch `el-design` was brought up to main and its texts landed (e4f578584).
- **The release gate.** EL adds central declarations, which the gate's item 3 and U4's boundary record must place, and a core landing after RV21c makes the latest receipt incremental (item 5). So EL lands after the freeze, or before it with each new central declaration placed on the boundary record and a fresh receipt rerun. The coordinator and OU's owner decide, on the board.
- **Checks.** Each module is registered in `check_becoming.py`'s core list and the full check is run, every axiom report empty, the generated `injEq` lemmas listed. Done at the landing, for all six (receipt EL_RECEIPT).

## 10. The review, the Lean rounds, and what changed

**The review.** Three independent reviews read the first draft against the Lean, the board and the chapters. Every finding was taken. The main changes:
- EL3's join already exists (`SelectionTerm.Flow.Descended`).
- The rule-9 question was the wrong way round: descent is an instance of `MapInstances`' laws, not a generalization.
- The `«尽»` premise of a single line was wrong, and not needed: the uniform horizon gives `«尽»` constructively.
- `KindRelay` keeps widening within kinds, so the widening claims hold by name only.
- EL2 corrections:
  - no course has s + 1 steps of excess from stock s;
  - `doubling_needs` bounds the draw, not the dependents;
  - closure with dissipation is not the only decider;
  - the renewal-from-outside witness as written contradicted `excess_bounded`;
  - `Saturated` shows no reproduction, not abundance.
- "Stasis" and "flourishing" were wrong readings of `«后守»` and `«生成»`; the regions are demographic.
- Fisher's exact case does decide the region, which made EL1 a boundary law rather than "no selection term decides".
- Revivals count as descents, so births need newness. The Lean rounds revised this; see below.
- `passingContinuation` keeps the dead in `«守»`.
- Heredity is transmission, not passing.
- The release-gate interaction, the queue order, the module owners and the record ids are now stated as found.
- RP is dropped as a purpose.

The strongest result the reviews named, the selection–region boundary, is now the head. EL4's own changes are listed in WS.md's header. The reviews' findings, as returned, are in [REVIEW-1.md](REVIEW-1.md); each that changed a statement is reflected in the section that carries it.

**The Lean rounds.** Four rounds of scratch Lean, each built and then recompiled and read by an independent verifier, changed these statements of the design:
- *EL1 (d), the suicide witness.*
  - "Positive at every generation while every branch ends" cannot hold where listed offspring continue their parents (`not_all_degenerate_while`, `not_all_degenerate_of_positive`), nor at the counting layer (`never_empties_while`, `last_term_zero`). The witness is now positive at every generation but the last nonempty one.
  - A new law carries it: a whole generation degenerates exactly where a later generation is empty, under the premises named.
  - The draft's wording holds at a kind grain that separates offspring from parents (`Courses.positive_and_degenerate_at_own_kind`), where the line takes no step.
- *EL1 (a), the horizon form.*
  - "No course of selection terms decides" is refuted by terms positive at unboundedly many steps (`never_empties_of_unbounded`).
  - The law is now within a horizon (`two_fates_of_nonempty`), with terms zero from some step on deciding nothing from a nonempty first generation (`eventually_zero_two_fates`). `terms_boundary` joins the last two cases.
  - On the map it is shown for one course per horizon.
  - A calibration of which case holds, proposed in a round, was found imprecise and unproved and is not claimed.
- *EL1 (b).* Exactness at every step from `t`, not at `t` alone (`ExactOnce.exact_once_ends`). The positive term is sufficient, not necessary (`goes_on_iff`). On the map a member, not the lineage, generates (`Chain.chain`).
- *The join's premises by grain.*
  - No newness at the grain of activity: a revival is a birth there.
  - At the grain of support, supported after the step and not at the step before is exactly what a birth needs; supported after alone is what the continuation needs.
  - "Never active before" is more than either grain needs.
  - The landed relay at stock one has no descent that is a birth.
- *The census premise.* EL1 (c) and the converse of the generation law need the census to hold every continuation (`Lasting.lasting` shows this).
- *`withinKind`.* It links no dormant formation at the grain of activity from an active start. Where support needs standing, this is not shown.
- *§6's carrying renewals.* They are instances of `Web.carries_iff` through `carries_iff_via_base`, and "arises" needs `Dependent`. The converse lemma uses the direction of `Embodied` opposite to `Embodied.comesToStand`.
- *§5's decision sentence.* It is reversed: 有终 still needs deciding continuation, exactly as strong as excluded middle, on the grammar (`Map.StepWhere`) and on the base (`Map.Undecided`). The law holds at every class within activity, and the landed ¬`«不穷»` laws are its corollaries, not the other way round.
- *§5 and §9's placement.* It is split, because `kindClass` lives in `KeepingWidening`, above `MapInstances`, and the grammar part can go into `GrammarMap`.
- *EL2.*
  - The gated regime on a lineage needs a premise on the line's reach.
  - Both fates at every stock are proved (`stock_forces_neither`).
  - The classification is stated as one of the three landed ending laws read as deciders.
  - The draw regime's premise fails on every handover over two or more steps (`Handover.not_draw_regime`).
  - The takers' need is read through the web in a variant (`multiplying_takers_stop_of_need`).
- *WS.* The carrier, the window laws, the forbidden conjunction (now for every pattern spaced at two), the tables, the alternator's count, the third source, the strict echo laws, `childless`, and the factor bounds under a supplied reading; see WS.md's header.

**The text reviews after round 3.** Two independent reviews read this text and WS.md against the six modules and AGENTS.md: 23 findings on the Lean claims (1 major), and 16 on substance and rules (5 major). They are in the kit's `round3.json`. Every finding was taken, with the Lean of round 4 where it changed what can be said. The main changes:
- `terms_boundary` is cited only for what it joins, and the within-horizon case is cited to `two_fates_of_nonempty`.
- Shift invariance is no longer counted as a law. It is the landed identity `Becoming.excess_add_right`.
- The join's premises are stated in full at both grains: `Acting` everywhere, and supported after the step at the grain of support.
- The gated regime's premises are stated in full: balance and the gate on members of `ds`.
- The three landed ending laws are read as deciders under a premise on the line's reach, not called deciders.
- §1's argument is that evolution needs no premise beyond the root and its World model, which supplies the amounts. The earlier wording said no premise the root lacks.
- A phrase of the provenance record no longer frames EL2's law.
- `line_ends` is a lemma of `empty_of_degenerates`.
- The extension of `rises_exact_iff` is stated as the nonemptiness of generation `t + 2`.
- 04 §2 is cited for transmission.
- "Flourishing", which has no glossary row, is out of the limits.
- The grain is written (kind, carrier).
- EL4's factors, strict laws and sources are narrowed to what the Lean shows (WS.md).

## 11. Result block

```text
Result(s): generation-and-degeneration-at-two-grains; selection-term-over-generations;
  what-bounds-offspring-numbers; selection-among-groups-by-ending; own-count-misses-joint-excess;
  whole-drawing-beyond-renewal-ends; what-a-rise-draws-from-beyond;
  a-rise-past-the-inflow-is-drawn-from-beyond; pace-of-selection-within-what-flows-in;
  what-keeping-widening-needs; keeping-widening-is-generation-losing-nothing; giving-that-waits-on-giving;
  thresholds-of-waiting; the-breeding-value (a common shift of the amount). Reused, none restated.
Delta: EL1, the selection-region boundary: at the counting layer, on the landed shift identity,
  two fates within a horizon for every course nonempty at it (Horizon.two_fates_of_nonempty), two
  fates for terms zero from some step on from a nonempty first generation
  (Horizon.eventually_zero_two_fates), and going on for terms positive at unboundedly many steps
  (Generations.never_empties_of_unbounded), the last two joined in Horizon.terms_boundary, a
  restatement; on Descended courses, two fates for one course of terms per horizon; the
  exact-transmission exception (exact from t on, not at t alone; a member in «生成»), extending
  rises_exact_iff's nonemptiness from one step to every later generation; the dissipation regime
  that defeats it, under the census premise; a whole generation degenerating exactly where a later
  one is empty, where listed offspring continue their parents and the census holds every
  continuation, a law of the kind grain; the suicide witness positive at every generation but the
  last nonempty one; the join of descent to births by grain, with no newness at the grain of
  activity. EL2, the three landed ending laws read as deciders of a lineage's region under a
  premise on the line's reach, as regimes with a stock horizon; the lineage reading of the gated
  regime; both fates at every stock; the takers' law for the draw; the renewal-from-outside
  witness. EL3, «尽» from a uniform horizon at every class within activity, constructively; the
  three regimes degenerate; 有终 from the premise is exactly excluded middle, on the grammar and on
  the base. EL4 as in WS.md.
Supplied premises / correspondence: §8.
Evidence: core Lean, six leaves landed at receipt EL_RECEIPT after four rounds (State of the Lean): each
  recompiled by an independent verifier, every source declaration's axiom report empty (one
  generated injEq on propext in PairSelection); check_becoming.py run with them; the records degeneration-from-a-horizon,
  the-selection-term-and-a-lineages-fate and ending-laws-as-regimes-on-a-lineage; the kit
  on branch el-kit. EL4's scratch enumeration and counts in scratch/, for its design only.
Boundary: §7; regions decided only where excluded middle is assumed; reaching an end only where
  continuation is decided; amounts stay off the root (World laws read on the map's regions).
Integration: 02 Open and GW's "the some-branch regions read on the World" (degeneration, by EL3;
  lineages, by §6); 05 §1's record's scope limit, renewal from outside (EL2); 04 Open "offspring
  numbers tied to what a formation gives" advanced for pairs with supplied factors (EL4), its
  derivation from the flow still open; 05 Open "thresholds with memory" (EL4, windows).
```
