# EL: evolution read on the root's map

Design, 31 October 2026, revised the same day after an independent review in three lenses (Lean correctness, coordination, substance; 65 findings, 21 major, every one taken: §10). Nothing here is proved; board item EL claims it. AI-written. Provenance: [Ren, 31 October 2026](../../../../../../sources/15-codex-theory-conversations/2026-10-31-evolution-and-becoming-one.md). Part 4 is the draft first written as WS, now [WS.md](WS.md).

## In brief

*The thesis the design tests* [AI reading]. Evolution is becoming read where patterns go on through the turnover of their parts: one root, not a second theory. The root's map already has the shape. Its carrying renewal (`«传»`) is a pattern continuing under a coarse class while a line of parts begins under a fine one; where the pattern has a predecessor, a beginning of a part ends a carrying renewal (`«粗有前则生为传»`); and a pattern can renew and still end on every branch (`Map.Short.renews_and_ends_everywhere`). Read on lineages, with descent as the relation, organisms the fine class and a kind the coarse class, the map's regions say whether a lineage goes on by reproduction within its kind (`«生成»`), goes on without reproducing from some point (`«后守»`), or ends on every branch (`«退化»`). Those are demographic fates. Evolution proper, the change of heritable composition, is read by selection terms over shares. EL's head result is the exact boundary between the two: when selection decides a lineage's fate, and when an amount does.

Four parts, by standing:

1. **EL1, the selection–region boundary** (head result). On generations of descent read on the map: the selection term proper is unchanged by a uniform shift of offspring numbers while the lineage's fate is not, so no course of selection terms decides the region; the one exception, exact transmission of offspring number with a positive term, forces going on; and under dissipation within the lineage's family exact transmission fails and the lineage ends on every branch within stock + 1 generations, at every stock. Its witness of evolutionary suicide: selection positive at every generation while every branch ends.
2. **EL2, regime, not level.** Every landed decider of a lineage's region is a regime (renewal gated on what it renews, run past it; dissipation within the family; a draw that keeps exceeding everything drawn before, on a condition given nothing), never a level; under each, the stock sets only the horizon. This is the exact form of "abundance can also be destroyed".
3. **EL3, the constructive degeneration law.** A line from an active occurrence, every point of which reached at one step `N` is inactive, ends on every branch (`«尽»`), with no excluded middle and no premise of a single line. It turns 02's "does not go on" into degeneration wherever a uniform horizon is known, at `MapInstances`' grain (its owner's) and on lineages.
4. **EL4, giving that waits on giving, under selection** ([WS.md](WS.md)), with the three sources of what a gift brings beyond what it draws.

Readings and instances, counted as evidence for existing records, not as results (§6): the lineage continuation itself, its carrying renewals, the regions read on lineages, and widening read with lineages.

## 1. The sense of "one theory", and its limits

*Argument* [AI reading]. Evolution's ingredients are relations the account already states. Heredity is transmission: inheritance of a dependence with a need within δ of the giver's (`Web.transmits_at_iff`, `Flow.TransmitsWithin`, 04 §3); variation is transmission with δ > 0; a pattern outlasting its carriers lasts only through passing (`Web.ByPassing`, 04 §2); selection is differential continuation through couplings (03). The fates of what passes on are the map's regions. So nothing in evolution needs a premise the root lacks; what it needs is the reading on lineages and the laws joining that reading to selection.

Five limits, kept in every summary of EL:

- *Selection reads shares; the map reads regions.* A selection term is an identity of counts over a listed cohort; a region is a property of a whole course along lines. Shares sum to zero in position and see nothing beyond their couplings (05 §3, §6). The two meet only through laws such as EL1.
- *The regions on lineages are demographic.* At (kind, organism) they see whether births within a kind keep coming, not what is inherited. Evolution proper is the change of heritable composition, which the shares read. A lineage whose descendants all change kind ends on every branch at the kind grain while descent goes on: pseudo-extinction, a reading; EL reads regions also at (activity, organism) along descent so that a change of kind is not counted as an end.
- *Not all becoming is Darwinian.* Selection among kinds needs formations that recur as kinds and pass on; the whole is not a member of a population of wholes. One theory in the broad sense, as one root, not one definition.
- *Going on is not flourishing, and generation is not 生生.* `«生成»` holds for any lineage going on with turnover: two formations reborn from each other at stock one are in it, with no growth and no novelty (`ClosedCycle.generates`, `Reproduction.Relay`). "Flourishing" is kept for widening what can form, and 生生 read as widening is generation of the possible that loses none of it (07 §2); generation of lineages and widening meet only where §6 says. On branching lineages `«生成»` and `«后守»` overlap (`Map.«生守相杂»`), and placing every point in a region is exactly excluded middle (`«三域之定当且仅当排中»`).
- *No fate is thereby better.* No law of EL ranks lineages or courses. Ranking is the ethics' question under its two premises, the continuation condition for scope and C for order (07); 04 already says no amount, lineage, group or level of selection is shown better.

Purposes (board, "Purpose first"): a unified explanation of reality (UE): evolutionary theory read on the root, and forbidden where it leaves open what decides a lineage's fate; alignment of the joint selection (AJ): humans, institutions and trained systems evolve together, and a selection favouring a share at every step can end every branch (EL1's witness, EL4).

## 2. What is landed, and what EL uses

| Area | Landed | Carrier |
|---|---|---|
| The map | `«传»`, `«生成»`, `«守»`, `«后守»`, `«退化»` (= `«尽»`), the strong forms, exclusions and coverage; `«粗有前则生为传»`, `«生则或粗生或传»`, `«传则粗不生»`; `«阶生成则上不退化»`; `Map.Short.renews_and_ends_everywhere`, `Map.Once`, `Map.«生守相杂»` (`Becoming.GrammarMap`, `Becoming.MapRegions`; record generation-and-degeneration-at-two-grains) | root, every relation and pair of classes |
| The map on the World | `Web.carries_iff` (any continuation), `Web.passing_carries_iff` (any `passes`), `Web.not_endless_of_gone`, `Web.degenerates_of_gone` (有终, with deciding), `Web.family_excess_not_endless`, `Web.consumed_held_not_endless`, `stopped_not_endless`, `Map.renewal_undecided`, `Map.shifted_generates` (`Becoming.MapInstances`); `Web.passingContinuation` (`Becoming.PatternPassing`), which carries dormant formations on; `Web.Lineage`, `Web.lineage_iff_line` (`Becoming.Identity`) | World; strong forms and ¬`«不穷»` only |
| Kinds | `Web.kindClass`, `Web.kindGrains` (0 formation, 1 kind, 2 activity), `Web.withinKind` (links no dormant formation), `Flow.BeginsAlong.carries_kind_iff` at (activity, kind), `KindRelay` (`renews_even`: a new kind line begins while the lineage goes on; `keeps_widening` within kinds), `ClosedCycle.generation_without_widening` (`Becoming.KeepingWidening`; record what-keeping-widening-needs) | World, along passing of support |
| Descent and selection | `Flow.DescendsAt` (giving to what comes to stand), `DescendsAt.supported`, `unsupported_childless` (`Becoming.Evolution`); `Web.Embodied.descends`, `Embodied.comesToStand`; `SelectionTerm.Flow.Descended` (each listed offspring descends from its parent), consumed by `Reproduction.Flow.lineage_ends`, `GroupEnding.Flow.coupled_end_together`, `SelectionTerm.Flow.support_not_lower`; `SelectionTerm.concord_uniform`, the pair counts built from `excess`; `Reproduction.Generations.ByNumber`, `ByNumber.rises_exact_iff`; `Reproduction.Flow.lineage_ends` (closed, balanced, dissipated family: empty within stock + 1 generations), `closed_lineage_lowered` (exact transmission fails within the stock), `Reproduction.Relay` (a lineage kept at stock one; dissipation is needed) (records selection-term-over-generations, what-bounds-offspring-numbers, selection-among-groups-by-ending) | World, list cohorts |
| Evolution's rows | U4's lever 2 places 04's 18 central rows; by its boundary design only row 17 has a strict root form (`RootForms.outside_leaves_no_offspring`, leaf `Becoming.RootForms` on branch `u4-edge`, not landed); row 5's relational part is `RootForms.descent_forms_no_dependence`; rows 6, 12, 18 are counting laws | U4's |
| Amounts | `Flow.joint_excess_ends`, `Flow.family_excess_ends` (gated, no dissipation premise), `Flow.excess_bounded` (n steps of excess need a level of at least n), `Flow.Balances.doubling_needs` (on a condition given nothing, n steps of a draw exceeding everything drawn before need a level of at least 2ⁿ − 1), `RegimeMargin.ends_beyond_giving` (records own-count-misses-joint-excess, whole-drawing-beyond-renewal-ends, mutual-dependence-and-its-pace) | World; regime carrier |
| What selection does not see | `Flow.share_not_against` (the share reaching beyond is never selected against), `Flow.Balances.rise_breaks_beyond`, `Flow.favours_breaking_beyond`, `breaks_beyond_unsettles`, and the inflow-graded laws `rise_le_inflow_beyond`, `rise_bounded_by_beyond_inflow`, `breaks_beyond_inflow`, `favours_breaking_beyond_inflow` (records what-a-rise-draws-from-beyond, a-rise-past-the-inflow-is-drawn-from-beyond); `SelectionPace.selection_within_carried` (record pace-of-selection-within-what-flows-in) | World |
| Widening | `Steps.keepsWidening_iff_generation_losing_nothing` (on moments, by name, under two deciding premises; record keeping-widening-is-generation-losing-nothing), `Web.keepsWidening_byName_iff_generation`, `Flow.begins_late_of_keepsOpening` (up to double negation, World premises), `Flow.whole_not_keepsWidening` (by name), `Flow.not_keepsWidening_along_passings`, `Flow.new_beyond_every`, `Run.adaptive_rule_changes_of_keepsWidening` (any adaptive run) | chains, World |

## 3. EL1: the selection–region boundary

**Carrier.** Generations of descent, `SelectionTerm.Flow.Descended L W G` (landed), on `Flow X X`. The only new join is that a `Descended` generation lies on the lineage continuation of §6, under `Embodied` and a premise that each listed offspring is *new* (never active before, as `FirstSupported`): without it, descent as giving to what comes to stand counts revivals (a formation fallen to zero and raised by a gift) as births, and the stock-one cycles are revivals.

**Target laws.**

- (a) *Shift invariance.* The selection term proper (concordance and discordance of offspring number with an amount) is unchanged when a common number is added to every offspring number (the pair counts are built from `excess`, and `excess (x + k) (y + k) = excess x y`), while the next generation's size is not. So for every horizon `H` and every course of selection terms over `H` generations there are two `Descended` courses with those terms, one whose lineages go on past `H` and one whose lineages end on every branch after `H`. Relative standing does not decide persistence.
- (b) *The exception.* Read by offspring number with exact transmission (`ByNumber`), a positive selection term means offspring numbers vary, so some parent has at least one offspring, and with exact transmission its line has at least one in every generation: the lineage goes on (`«生成»` at (kind, organism) under births within the kind, `Embodied` and newness). A zero term decides nothing (uniform one against uniform zero).
- (c) *Where the exception cannot hold.* Under dissipation within the family the lineage lives in, exact transmission fails within the stock (`closed_lineage_lowered`), and the lineage ends on every branch within stock + 1 generations (`lineage_ends`, read through EL3's law). At every stock.
- (d) *Evolutionary suicide as a witness.* A course of `Descended` generations with a positive selection term for an amount at every generation while every branch ends: selection decides what rises among the members, not whether any go on. The amount can be one that draws past the family's gated renewal (05 §1), so the witness joins 05's drain to 04's selection.

**What it restates and what it adds.** The distinction between relative and absolute fitness is classical: evolutionary rescue and evolutionary suicide, or Darwinian extinction (Matsuda and Abrams 1994; Gomulkiewicz and Holt 1995; Gyllenberg and Parvinen 2001; Webb 2003; Rankin and López-Sepulcre 2005; to be read before any record cites them). EL1 adds the exact form on one model with conservation and dependence: the invariance as a law of the counts, its one exception and the regime that defeats the exception, each read on the map's regions rather than on a growth rate.

**Home and record.** 04 §3–§4 (life), one record, working title the-selection-term-and-a-lineages-fate.

## 4. EL2: regime, not level

**Target.** (a) Each landed decider of a lineage's region is a regime with a horizon computed from the stock: renewal gated on what it renews, run past what it gives (the number of steps of joint excess is at most the stock, `Flow.excess_bounded`; from a stock below `n + m`, `n` such steps end every formation needing at least `m`, `Flow.joint_excess_ends`); dissipation within the lineage's family (empty within stock + 1 generations, `lineage_ends`); on a condition given nothing, a draw exceeding everything drawn before (at most log₂(stock + 1) such steps, `doubling_needs`). (b) Without such a regime, both fates occur at every stock: for every stock `s ≥ 1`, a `Descended` course on `Flow X X` whose lineages go on (a relay, as `Reproduction.Relay` does at stock one, scaled), and one whose lineages end on every branch (joint excess for `n = s` steps at need one). (c) The new witness for the draw: formations that need the draw to keep exceeding, takers multiplying with each needing its take, stop within the log₂ bound; `DoublingDraw` has need zero and ends nothing, so this is new, with the premise that the condition is given nothing kept in the statement.

**Boundary.** Neither regime binds renewal from outside: a renewer whose giving does not require the condition, giving at least the joint uptake, with takers each and together within what is given, continuing at every step (a witness the account lacks; 05 §1's record states the scope limit that the gated conclusions do not reach such renewal). Abundance is a level; what destroys it is a regime; the stock sets when, not whether.

**Standing.** The ending side is landed laws read on lineages with a horizon; the content is the classification (every landed decider is a regime, with its horizon) and the two witnesses (c) and renewal from outside. Home 04 §4 with 05 §1 pointing to it; record: an amendment of what-bounds-offspring-numbers and whole-drawing-beyond-renewal-ends unless (b)'s parametric pair and (c) together make a law of their own, decided at review of the Lean.

## 5. EL3: the constructive degeneration law

**Target.** Along `continuationStep R` at (activity, carrier), from an active occurrence `x`, where every occurrence the line reaches at step `N` is inactive (`not_endless_of_gone`'s premise), the line ends on every branch: `«尽»` at `x`, hence `«退化»`. Proof plan: induction on `N − y.1` over reached occurrences, successors lying one step later (`continuationStep`) and alike in activity, so a reached occurrence at `N` would be active and inactive. No excluded middle, no premise that each occurrence has one continuation (descent branches). Corollaries: `family_excess_not_endless`, `consumed_held_not_endless` and `stopped_not_endless` each give `«退化»`; `degenerates_of_gone`'s 有终 no longer needs its decision for this reading. Then the same at the lineage continuation of §6.

**Placement.** The law is at `MapInstances`' grain, so it belongs in `Becoming.MapInstances` (below its corollaries, rule 9), on its owner's yes; EL proposes it on the board. Home 02 §1 (map), as an amendment of generation-and-degeneration-at-two-grains or its own record, the owner's call.

## 6. Readings and instances (evidence, not results)

- **The lineage continuation.** Carry on while supported, or descend: the `Web.withinKind` shape with `passes t g x := L.DescendsAt W t x g` on `Flow X X` (so `F = C = X`), not `Web.passingContinuation`, which carries dormant formations on and would put a dead formation in `«守»` for good. Its carrying renewals from an active parent are descents to a formation that arises, within the kind: `Web.carries_iff` and `passing_carries_iff` instantiated, no premise (a wrapper; an alias of generation-and-degeneration-at-two-grains). The converse, every new descent within the kind is a carrying renewal, needs `Embodied` (`Embodied.comesToStand`) and newness: the one lemma of this item with content, kept with EL1.
- **Regions on lineages**, written (coarse, fine) as in the Lean: at (kind, organism), going on by reproduction within the kind (`«生成»`), going on without reproducing from some point (`«后守»`), ending on every branch (`«退化»`); at (activity, organism) along descent, the same without counting a change of kind as an end. A new kind line while the lineage goes on is `carries_kind_iff` at (activity, kind), along passing of support, with `KindRelay.renews_even` its witness; the descent reading of it waits on the converse lemma above.
- **Widening, read with lineages.** By name, on a course's moments, keeping widening is generation of the possible that loses nothing, under two deciding premises (landed). Along `withinKind`, keeping opening gives, up to double negation and under the World's premises, a new kind line after every step (`begins_late_of_keepsOpening`); since nothing keeps opening along a continuation containing passing of support (`not_keepsOpening_along_passings`), the opening comes from passings across kinds. By name a finite closed whole cannot keep widening (`whole_not_keepsWidening`), but within kinds it can: `KindRelay` keeps widening within kinds in a finite, balanced, conserving world. Generation without widening, along passing: `ClosedCycle.generation_without_widening`. With the rule held fixed, what is possible under it does not keep widening (`Run.adaptive_rule_changes_of_keepsWidening`, any adaptive run). None of these is new; each is cited where a chapter reads evolution.
- **Candidate witness, if wanted later:** a lineage going on within kinds while what can form for others narrows, read within kinds (not by name, where `KindRelay` already differs).

## 7. Not planned, and not shown

Not planned (04's programme, left as it lists them): Wright–Fisher with selection, two-way mutation with drift, inexact transmission across groups, rational amounts, how parts first come to live as one, wholes founded by several parts, changed units, a comparison against an equally informed rival, evolved evaluation joined to recognition, calibration and implementation; lifting 04's rows onto the grammar, which is U4's lever 2.

Not shown: that a fate or course is better (the ethics' two premises); that an actual population meets the hypotheses; probabilities; amounts on the root (the grammar has none; EL's laws are World laws read on the map's regions, through `MapInstances`).

## 8. Modelling choices

Discrete steps; natural-number levels, needs and offspring numbers; Prop-valued activity read as support; descent as giving to what comes to stand on `Flow X X`; `Embodied` and newness wherever descents are joined to births; kinds supplied (`Web.kindClass` with a supplied `Q`); EL4's choices in [WS.md §6](WS.md#6-modelling-choices-on-which-the-laws-depend). An empty axiom report says nothing of these; each law names those it uses.

## 9. Coordination, order and the release gate

- **Owners, asked on the board, each deciding for their module:** OU's owner (`GrammarMap`, `MapRegions`); `MapInstances`' and `PatternPassing`'s owners (named in their history rows: OU6, UE7, GW), for EL3's law in `MapInstances` and for any kind-grain `carries_iff` below it (with activity the case `Q := fun _ _ => True`, up to an equivalence lemma); UE's owner and GW's session (`KeepingWidening`, `WideningOnTheMap`); the evolution modules' owners (`Evolution`, `Reproduction`, `SelectionTerm`, `GroupEnding`) for EL1's laws placed in or above them; U4's owner (`RootForms`, lever 2): nothing of U4 is restated. Chapter text goes through 04's, 02's and 05's home sections.
- **Placement.** EL1 and EL2: a leaf above `Reproduction`, `SelectionTerm` and `KeepingWidening` (working name `Becoming.LineageRegions`), a leaf because its laws join modules none of which can import it; any law the owners want below goes there instead. EL3: in `MapInstances`. EL4: as in WS.md, with its windowed law below `Withholding` only on that owner's yes.
- **Order.** Scratch in a worktree off main (a `.lean` file in a study folder on main is picked up by the catalogue): EL3 first (EL1 and EL2 use it), then EL1, EL2, EL4. Core landing by readiness after RR2 and HE2 (in the order rehearsed), AJ4's documents, U4's leaf and RV21c's fresh run, and after UE26 by claim order; a slot from the coordinator.
- **The release gate.** EL adds central declarations, which the gate's item 3 and U4's boundary record must place, and a core landing after RV21c makes the latest receipt incremental (item 5). So EL lands after the freeze, or before it with each new central declaration placed on the boundary record and a fresh receipt rerun: the coordinator and OU's owner decide, on the board.
- **Checks.** `check_becoming.py`, every axiom report empty.

## 10. The review, and what changed

Three independent reviews read the first draft against the Lean, the board and the chapters. Every finding was taken. The main changes:
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
- Revivals count as descents, so births need newness.
- `passingContinuation` keeps the dead in `«守»`.
- Heredity is transmission, not passing.
- The release-gate interaction, the queue order, the module owners and the record ids are now stated as found.
- RP is dropped as a purpose.

The strongest result the reviews named, the selection–region boundary, is now the head. EL4's own changes are listed in WS.md's header. The reviews' findings, as returned, are in [REVIEW-1.md](REVIEW-1.md); each that changed a statement is reflected in the section that carries it.

## 11. Result block

```text
Result(s): generation-and-degeneration-at-two-grains; selection-term-over-generations;
  what-bounds-offspring-numbers; selection-among-groups-by-ending; own-count-misses-joint-excess;
  whole-drawing-beyond-renewal-ends; what-a-rise-draws-from-beyond;
  a-rise-past-the-inflow-is-drawn-from-beyond; pace-of-selection-within-what-flows-in;
  what-keeping-widening-needs; keeping-widening-is-generation-losing-nothing; giving-that-waits-on-giving;
  thresholds-of-waiting. Reused, none restated.
Delta: EL1, the selection–region boundary (shift invariance, the exact-transmission exception,
  the dissipation regime that defeats it, an evolutionary-suicide witness) with the converse lineage
  lemma under Embodied and newness; EL2, every landed decider a regime with a stock horizon, both
  fates at every stock without one, the needs witness for the draw, the renewal-from-outside witness;
  EL3, «尽» from a uniform horizon, constructively; EL4 as in WS.md.
Supplied premises / correspondence: §8.
Evidence: none yet; EL4's scratch enumeration and counts in scratch/, for its design only.
Boundary: §7; regions decided only where excluded middle is assumed; amounts stay off the root.
Integration: 02 Open and GW's "the some-branch regions read on the World" (degeneration, by EL3;
  lineages, by §6); 05 §1's record's scope limit, renewal from outside (EL2); 04 Open "offspring
  numbers tied to what a formation gives" advanced for pairs with supplied factors (EL4), its
  derivation from the flow still open; 05 Open "thresholds with memory" (EL4, windows).
```
