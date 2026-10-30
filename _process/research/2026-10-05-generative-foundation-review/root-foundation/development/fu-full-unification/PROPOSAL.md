# FU: from partial to full unification (proposal)

AI-written proposal, 29 October 2026, on main at `f8ad3de80`. This is a proposal to the session that coordinates the unification, OU's owner. It is not a claim, and it changes no row, module or definition another owner holds (rule 3). It follows the [twenty-first review](../../BECOMING-TWENTY-FIRST-REVIEW.md), which found the unification real but partial (§2), and it builds on [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), [WRT](../world-representation/DESIGN.md) and the WRP design in progress.

**Adopted 29 October 2026** by OU's owner as OU plan §十三 item 13 (全一–全五, these F1–F5) with decision D25 in §十四, at `01cad0d12`. The one plan is [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), section "From no gap to the root: full unification". This file stays as the design note behind it. The adoption made three changes, which govern over the text below:
1. A statement at a represented model counts as a representation, not a derivation, and F5 reports it as one. §十三's rule that rerouting a proof only to raise a count does not count applies to every move between categories.
2. If balance is not derived, amounts become the root's second sort only with their interface stated as laws on the grammar, not as a category name.
3. The plan's deferral of the ethics is lifted for F4 alone. The condition and C stay named premises, the free predicate stays the general form (SD1), and the root derives nothing ethical.

F3 belongs to the generation–widening session and F5 to MV. U1 was given to this note's author (design, scratch checks, one independent review, no Lean claimed). U2 and U3 wait in WHAT-REMAINS until their gates open.

## 1. What "full" should mean

OU's criterion 7 asks three things: every old theorem goes through the dependency audit, the continuation family, the master laws and the central declarations are lifted, and the World is represented both ways or its failure written down. With WRT2 that is met as far as the World's relations go. The measure "has no gap", meaning every central declaration follows from a master law or has a named reason. That is EC's sense of completion. It is not unification in the sense the theory claims, one root of which every law is a law. The review's numbers show the difference: 44 of 127 central rows reach the grammar, evolution 0 of 18, significance 0 of 5.

Proposed criterion for full unification, read with OU's §十三:

- **F1. Every model represented both ways, amounts included.** For each model (World, processes, the counting layer), the grammar model and its transport give a representation both ways, or a failure written down at every selection tried. WRT2 did the World's relations. WRP is doing processes (in flight). Amounts are open: WRT2's F1 and F1′ hold "at this selection", and no selection holding amounts has been tried.
- **F2. Every central declaration on the root.** Each is either derived from a grammar law (rule 9), or stated as a grammar statement at a represented model. In the second case, every premise it takes (support, dissipation, transmission, the least loss) is itself a grammar statement at that model. No category "balance, represented" is left. Either balance is derived under a relation (§3, U1), or that derivation's failure is written down and amounts are declared the root's second sort, with their interface stated.
- **F3. The three readings of "more" joined, or their separation adopted as central.** These are the grammar's 生生, the map's 生成 and the ethics' widening. `CausalGrowth.no_order_contains_both` and `HeldPossible` are the fixed points.
- **F4. The ethics stated on the root.** The continuation condition already has its structural reading on the root (GS2). The five central significance rows are stated there too, with the free predicate kept as their generalization (SD1 unchanged).
- **F5. The measure reports how each row reaches.** It separates derivation, representation at a model and a named premise on the grammar, so the headline cannot read connection as derivation (review §2.2).

"Full" does not mean lifting every theorem. The 9,370 theorems that read no field of the old base are taken whole through WRP, as statements at a represented model. Nor does it mean every item succeeds. A failure written down with witnesses completes an item, as WRT2's F1 did, and full unification is then an exact statement of each seam, not its absence.

## 2. Where the 75 central declarations not on the root fall

Distinct declarations not reaching the grammar on OU3e's measure, by category:

| Category | Count | Seam | Item |
|---|---:|---|---|
| balance, represented | 32 | amounts | U1 |
| premise of the account (support, dissipation) | 9 | amounts (dissipation reads one unit less) and a relation premise (support) | U1, then U2 |
| counting identity (Price) | 3 | amounts (counting) | U1 |
| master law on an anchor not reached (widening on paths and weightings) | 7 | order with weights (amounts) and C's content on paths | U1, U3 |
| definitional or representational | 13 | definitions that are grammar readings not yet stated so (roles, transmission, valuation, identification) | U2 |
| law of its model | 7 | statements at a model | WRT2/WRP, then U2 |
| single application | 4 | statements at a model | WRT2/WRP, then U2 |

44 of the 75 rest on amounts, and 7 more on weights. **The amounts seam is most of what remains.**

## 3. Items

In flight, with their owners:
- **WRP**, processes both ways (Unification and coherence progress, fork 2): F1 for processes and the no-field layer.
- **OU3f's derivations** (fork 1): the activity-only rows.
- **The generation–widening link** (the session Join generation (生成) to widening): F3, and the map's coverage.
- **MV**, the computed view (the session Theory status and claims): the place where F5's report would land.
- **AJ5**, the collective question on one page: not a unification item, but it states what the unified laws rule out.

New, proposed, not claimed:

**U1. Balance under a relation: units as occurrences.** Serves F1 and F2, and the unified explanation (UE). OU3b's audit names this opening (F13): "No model's balance is yet read under a relation other than the one. That is where a derivation of balance, rather than a representation, would begin." The proposal:

- **The model.** A unit model of a World adds unit occurrences to the carrier, each placed at a step and a relatum. Its relation is the continuation of units: a unit at `(t, c)` goes on as a unit at `(t + 1, c)`, or is taken, while a given unit arrives.
- **The law.** Read under that relation, balance at a step and relatum is the grammar's `«对»` of before ++ given against after ++ taken. The count law then follows from `«对则守数»` under a relation that is not the one, by `Flow.balances_of_matched`, which is already on main.
- **Units abide.** That pairing is a one-to-one continuation of units: no unit begins or ends inside the step frame. So balance is the grammar's positions read on units, **units abide (住)**, and the first law becomes a law of continuation.
- **Dissipation.** A step loses exactly where some unit's line ends there (亡). The least loss of one unit becomes the premise that amounts consist of units with lines, an atomism of amounts, named as such. It is not an arithmetic accident of `Nat`.
- **The converse.** Every balanced World has a unit model, by replication, as `Flow.balances_iff_units` builds unit lists. With identity across steps added, standings are told apart at this selection by pairing among unit occurrences, which is Hume's principle. That would close WRT2's F1 and F1′ at the unit selection, leaving them standing at the occurrence selection.
- **What would make it fail.** Suppose every unit model's continuation can be chosen arbitrarily, any pairing serving, and no law reads which unit went where. Then the derivation is near-definitional, F13's verdict stands, and the item writes that down. Amounts then become the root's second sort, with an interface stated.
- **The test of content.** Does any central law become a statement about unit lines? Two candidates: "what a rise draws from beyond" as units whose lines cross the coupling boundary (`Flow.Balances.rise_draws_beyond_inflow`), and joint excess as more lines ending than beginning in a gated renewal (`Flow.joint_excess_ends`).
- **Form.** A design first, on WRT's pattern: the model, forward, converse, failures with witnesses, the smallest Lean items. Statements are checked in scratch, then one independent review, before any Lean is claimed. It uses WRT2's occurrence model and `Becoming.GrammarTransport`, and edits neither.

*U1's outcome* ([DESIGN.md](../u1-balance-under-units/DESIGN.md), 29 October 2026, read twice by WRT's designer, reviewed independently and read a second time, scratch 48 theorems in 70 declarations, every axiom report empty).
- Balance is represented by selected finite frame bijections at every condition, both ways, with no choice.
- The conditional crossing laws, joined to `Balances.rise_draws_beyond_inflow`, and the normalized residual-count laws hold at their list selections.
- This does not derive balance. No number-stated consumer is rerouted, and F13's reason stands.
- Residual endpoints are not actual losses once actual boundary traffic is kept. The projection does not recover WRT's conservation, and correspondence orbits do not exhaust the matching fibre.
- Amounts are the root's second sort with that **limited** interface. Exchange attachment and the line laws remain outside it, proposed.

**U2. The remaining rows as grammar readings or as statements at a represented model** (after WRP lands). The 13 definitional rows (`Web.roles_supported`, `Web.roles_alive`, `Web.transmits_at_iff`, `Valuation.significant_iff_held` and others) are stated as the grammar terms they read. The 11 laws of their model and single applications are stated at the World's or a process's grammar model through the transport. Support, a relation premise by WRT's §3, is stated as a grammar statement at the model. Taken module by module with each module's owner.

**U3. The ethics on the root** (after U1, for weightings). The five significance rows are `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds`, `Web.paths_comparison_widens`, `Web.paths_one_object` and `Weighting.widens_iff_every_positive`. Each is stated on the root:
- widening on paths is the grammar's `«广»` read on what a path admits;
- weightings are units assigned to what is admitted (U1);
- the condition is its structural reading (GS2).

C stays a premise, and the free predicate stays the general form. Owner: whoever holds 07's significance results, with SW's note as the reading.

*U3's outcome* ([DESIGN.md](../u3-significance-on-the-root/DESIGN.md), 30 October 2026; the design reviewed before the Lean, the Lean and the records kit read by two independent readers, the landing texts through three lenses; core receipt `20261030T131028.245732Z`, every axiom report empty).
- An extension of level paths with every claim counted is the grammar's `«广»` of what the paths admit, through OU3b's `Web.widens_iff`; for every reading of `living`, C holds on level paths with "better" read as that `«广»`, its being better C's content, supplied (`Web.paths_extension_iff_widens`, `Web.paths_comparison_widens`).
- Weightings meet the root through one interface law: on a finite list with two-valued admission, `«广»` is what every additive natural-number weighting positive on the listed items ranks higher (`Weighting.widens_iff_every_positive`). The weights are amounts, the second sort of U1's verdict, not units.
- The condition at its own-closure reading is `«续无外»` at the one of the relation (GS2), and `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` are specialized there: each fixes significance at one reading, so F5 takes none as an item.
- 全四 for the significance rows is met as F4 defines it: each row has its root form, the condition and C stay named premises, and the free predicate stays the general form. F5's stricter count takes two of the five (`Web.paths_comparison_widens`, `Weighting.widens_iff_every_positive`; with `Web.paths_extension_iff_widens`, capacity's) as stated on their own carrier and keeps the three specializations among the rest ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "U3's standing, and what 全四 counts"). The free significance is not lifted, and the condition (scope) and C (order) stay premises.

## 4. Order

1. U1's design, on disjoint files and in parallel with WRP. U1 touches no module WRP touches: it adds a unit model beside the occurrence model.
2. After WRP lands: U2, module by module.
3. After U1: U3.
4. The generation–widening link goes on its own line throughout, and F5's report joins MV when the measure next changes.

The pace rule holds: a few lines landed before many held open. So only U1 starts now, beside the three lines already running.

## 5. What this note asks and does not do

It asks OU's owner three things:
- whether F1–F5 should become OU's sense of completion, as a revision of §十三 item 7 that OU's owner would write;
- whether U1, U2 and U3 should be posted on the board as proposed;
- whether U1's design may be taken by the session of the twenty-first review, which offers it, or by WRT's designer if it prefers. The design reuses WRT2's definitions and decides none of them.

It edits no row but its own, changes no module, and decides no definition another owner holds.
