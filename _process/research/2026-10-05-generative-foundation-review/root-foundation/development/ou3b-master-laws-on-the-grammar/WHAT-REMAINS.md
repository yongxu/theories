# After OU3b: what still lies between the account and an elegant unification

AI-written coordination note, 28 October 2026, on main at `464ef14b7`. It reads OU3b's measure ([after.json](after.json)) against EC's aim ([plan](../ec-elegant-completion/PLAN.md): few laws, each stated once at the lowest layer that can hold it, every central result following from them) and OU's completion criterion 7 ([plan](../one-unfolding-root/PLAN.md) §十三: the continuation family, the five master laws and the central declarations lifted; the World's representation proved both ways or its failure written down). It divides what remains into items, says who takes each, and keeps the pace rule ([08 §12](../../../../../../theories/becoming/chapters/08-METHOD.md#the-work-by-its-own-laws)): a few lines landed come before many held open.

## Where it stands

28 of 127 central declarations reach the grammar. The 127 are COVERAGE's rows; nine declarations stand in two rows (the frontier laws, in degeneration and alignment), so they are 118 distinct declarations, of which 28 reach the grammar. The other 90 fall into three groups, which are different kinds of gap.

| Group | Count | What it is | Gap? |
|---|---:|---|---|
| Balance only, or balance with return or order | 30 | `Web.frontier_*`, `RegimeMargin.*`, `Flow.*` levels: they rest on `Flow.Balances`, stated once in the prelude's stretch balance (EC2) | **No.** Balance needs amounts and the grammar has none. Its grammar form (`«对»`, `«守数当且仅当可对»`) represents it both ways, and routing its consumers through unit lists adds a dependence and no content (OU3b's decision, review F13). Its lowest layer is the prelude, where it is stated once. The measure should report these as "balance, represented", not as unreached. |
| Return, lumping or order, through an anchor defined beside the grammar | 10 | the anchors `Branching.Returns`, `Branching.Lossless`, `revisits_within`, `GoAlikeUnder`, `Web.Widens`, `Weighting.WidensOn` are defined directly; each is already shown equivalent to its grammar form (OU3b's bridges) | **Yes, small.** Rule 9 says the general law is the reason for the special one. Where an anchor's definition can be the grammar term, or the anchor's laws can be proved from the grammar's, the consumers reach the grammar with no rerouting. |
| No master law | 50 | evolution 13 (selection within what is transmitted, transmission, levels, group ending, drift); the rest across roles (actor, patient, life), knowing, learning, evaluation and significance, capacity, collective and alignment | **Yes, the main one.** EC5 asks that what rests on no master law be named with its reason. Each of these is either a case of a master law not yet derived as one, a candidate for a sixth law (the evolution cluster may share one mechanism), or a law of one model, which is named as such. |

The rest of OU's criterion 7, the World's representation theorem, is open ([01 Open](../../../../../../theories/becoming/chapters/01-ROOT.md#open)): no representation theorem for the World is claimed. It waits until the two items below land (pace rule), then gets a design of its own.

## Items

1. **OU3c: the return, lumping and order anchors on the grammar** (OU3b's sub-item; owner: the session that takes it on the board). For each of the six anchors, either define it as its grammar term with a body equal by `rfl`, as `ClosedUnder` and `WithinClosure` were, or prove its laws from the grammar's and keep its definition, saying which and why. No statement changes; signatures audited as in OU3b. Rerouting a proof only to raise the count does not count (OU plan §十三). Done when the measure is rerun and every anchor that can reach the grammar does, with a reason for each that cannot. Kit: OU3b's ([kit/](kit/), [LANDING](LANDING.md)). *Found at claim (28 October 2026, OU3c's owner):* no anchor body is its grammar term by `rfl` (curried quantifiers, an inductive first step, the composition's existentials, the coreflexive reading of what is admitted), so every anchor keeps its definition. An anchor is not redefined as its grammar term through the bridges, because the measure would then count a definitional mention, not a derivation. Of the ten, two reach by derivation: `Learning.goAlike_iff_lumped`, from `«像定后当且仅当同行»`, and `Branching.loss_passes_juncture`, through `step_back` derived from the closure laws. The other eight keep a stated reason. Both learnability laws use return only through a pigeonhole bound that no grammar law carries without restating it. The six widening laws use widening only through its definition, and their content (C's extension on paths, the continuation condition's reduction, weights) is stated by no master law. That makes them input to EC6. Expected: 2 of the 10, plus the measure's balance category.
2. **EC6: the central declarations on no master law** (EC5's open part; owner: the session that takes it on the board). First an audit, with no Lean: for each of the 50, read its proof and dependencies and say (a) which master law it is a case of and the theorem that would derive it below (rule 9), (b) whether several share a mechanism no master law states, a candidate sixth law, with the shared statement written out, or (c) that it is a law of its model, with the reason. Output: one table, and per-owner proposals. Then the derivations, claimed one module at a time with the owners of the modules. A candidate sixth law is stated on the grammar first, if it can be, and reviewed before any refactor.
3. **The measure reads balance as represented** (folded into OU3c's landing): `measure_grammar.py` reports balance's consumers as reaching its represented grammar form, so the headline counts what is a gap and nothing else.
4. **New modules state their laws on the grammar where a master law is used** (for every lander, UE first): import `Becoming.GrammarLaws` and derive from it rather than proving an order, a closure or a return law locally. Found on main: `ComparingCourses.strictJoin_trans`/`strictJoin_irrefl` are general relational laws (any carrier, any relations) proved in a model module; they belong beside `«广»`'s laws in the grammar, and `WidensWithLag`'s order would then follow from them. Not a correction of UE9's results, which stand; a placement for UE9's owner to decide.
5. **Records show the master laws their laws rest on, computed, not written** (revised 28 October 2026 on DF3's owner's proposal). Schema-2 law items are `{en, zh, declarations}`, with no master-law field, and hand-written keys would copy what the measure computes, cover only DF3's 30 of the roughly 370 records with laws, and go stale as soon as OU3c or EC6 moves a declaration. Instead the measure writes one generated data file mapping each law item's declarations to the master laws they rest on (`measure_grammar.py`'s dependency walk, the anchors of `COVERAGE.json`'s `master_laws`), and the record pages render it beside each law (`tools/research/registry.py`). Record graph and measure then agree at every render, for every record, following the Lean dependencies. DF3 guarantees what this needs: each law's declarations list is exactly the Lean that proves it. A small item of its own on RA's line, taken by DF3's owner after DF3 lands, and after OU3c's change to the measure (item 3), so the two do not edit `measure_grammar.py` at once.

## After EC6's audit: the order and the decisions (28 October 2026)

EC6's audit ([AUDIT](../ec6-no-master-law/AUDIT.md), reviewed twice, every finding taken) classifies the 50: 10 are cases of the master laws with a named derivation (closure 7, balance 3), 15 rest on mechanisms no master law states (the gating premises 9, Price's identity 3, step-indexed reaching 3), and 25 are laws of their models, single applications, definitional or representational. OU3c found 4 of its 10 derived and 6 with reasons. Together they let the headline say, for every central declaration, either the master law it follows from or the reason it follows from none. That is EC5's requirement met, and it is the form an elegant completion takes here: no law is added to raise a count, and no count hides a gap.

**Decisions.** EC's owner has been inactive since 21 October, so its claim has lapsed under rule 4. These are taken here, with the reasons, and its owner or any session may reopen them on the board.

- **The gating premises are reported as premises, not anchored as a sixth law** (audit proposal 8, option 2). A master law states a mechanism with a derived law that many results share, as the prelude's stretch balance is for balance. The gate's only consequence is one line, and every row uses the premises directly, so an anchor would credit rows by mention. Support and dissipation are on the premise card already; the measure reports these rows as resting on a premise of the account. Support is stated twice in the Lean (`Web.Supported`, and `ExchangeLaw.NeedsSupportAt` in the counterfactual models), linked by `Web.supported_iff_admits`. Whether one is defined from the other is for the owners of `Dependence` and `LevelCoupling`.
- **Price's identity stays a lemma family, and its rows are reported as resting on a counting identity** (proposal 9). It cannot fail, so it states no mechanism of the unfolding. It is accounting, stated once and generic in the carrier. Moving it below the models would move `excess` and `total_congr` with it and change no row's content.
- **Step-indexed reaching is stated on the grammar** (proposal 7, OU3b's line). This is a real law: within *m* steps and then within *n* is within *m + n*, and the *n*-th iterate of "holds where every predecessor held" is exactly "everything reaching here in *n* steps held". It sits beside `«迭»` in the finite-runs section, is reviewed before any consumer bridges to it, and goes as OU3d after OU3c lands, since both edit `GrammarLaws`.
- **The derivations of (a), proposals 1–5** (`RuleCapture` and `ClosedCapture`, `Pace`, `Lasting` and `RegimeMargin`, `Closing` and `Loops`, `Decidedness`) go as EC6b. They are bridges and re-proofs with statements unchanged, through `WithinClosure` so that the rows reach the anchor, one module at a time, landed after OU3c. Proposal 6 (`Optimum`'s balance clause) changes a definition's text and waits for `Optimum`'s and `Flow`'s owners.
- **The measure reports the categories** (proposal 10, with item 3): master law, balance represented, premise of the account, counting identity, law of its model, single application, definitional or representational. It goes as one small change right after OU3c lands, and before DF3's owner's computed view, which edits the same script.

**Order.**
1. OU3c lands (at the head of the queue).
2. Then, in parallel, on disjoint files: the measure's categories (EC6's owner), then OU3d (OU3c's owner), and EC6b module by module (EC6's owner).
3. After that comes DF3's owner's computed view of the master laws in records (item 5), and then a design for the World's representation theorem.

## Where it stands after OU3c and EC6b (28 October 2026)

OU3c (`11cb5342c`, study §433) and EC6b (`565601488`, study §434) have landed, and the measure reports every central row by category (`d1df2e096`). 85 of 127 rows rest on a master law (77 before), and 41 reach the grammar (33 before). Of the 118 distinct declarations:
- 40 reach the grammar;
- 30 rest on balance, represented;
- 6 rest on an anchor, each with a stated reason;
- 42 rest on no master law, each with a reason.

The gaps are 5, down from 13: OU3d's 3 (step-indexed reaching, drafted and under review) and EC6c's 2 (`Optimum`'s balance clause).

`Flow` and `COVERAGE.json` have no active owners, so these were decided under rule 3's fallback. EC6c's clause is named once in `Flow.lean`, beside `Flow.Balances`, which is shown its case by `Iff.rfl` and not redefined. EC6d, `COVERAGE.json`'s citations, goes to EC6's owner, changing no row's statement without its record's owner.

## The measure with no gap (28 October 2026)

OU3d (`4fcfc7011`, study §437) stated step-indexed reaching on the grammar, and OU3e (`406ed1303`, study §439) proved the three step-indexed rows from it through bridges, each only its own induction. On `406ed1303` the measure reports no gap. Every one of the 118 distinct central declarations either follows from a master law or is named with the reason it follows from none:

| Category | Declarations |
|---|---:|
| Master law (43 of them reach the grammar; the other 7 rest on an anchor, each with a reason) | 50 |
| Balance, represented | 32 |
| Definitional or representational | 13 |
| Premise of the account (support, dissipation) | 9 |
| Law of its model | 7 |
| Single application | 4 |
| Counting identity (Price) | 3 |
| **Total** | **118** |

44 of the 127 rows reach the grammar (28 when this note was written), and 88 rest on a master law (77). In EC's sense this is the measure met. The laws are stated once at the lowest layer that can hold them, and the reason for each special result is the general law, or a named premise, identity or model. No law was added to raise a count. Two attempts that would only have raised it were declined: anchors redefined through the bridges, and `PartForms.goAlike` through an image law applied and then undone.

What it does not settle:
- The World's representation theorem, both ways or its failure written down (OU's criterion 7). Its design (WRT) is under review.
- The chapters' other laws beyond the central declarations (OU plan §八 steps 5–10).
- Whether the categories themselves are the right ones. Each is argued in EC6's audit and open to revision on the board.

## The next layer (29 October 2026)

With the central declarations settled, two lines go on, on disjoint files:
- **WRT2, the World's representation both ways** (designed in [WRT](../world-representation/DESIGN.md), `732259ccc`; taken by its designer). It adds the occurrence model and the transport lemmas. The relational part is represented both ways. The failure on amounts is written down: standings are forgotten at this selection, and balance is carried by conservation alone. This closes OU's criterion 7 as far as the World goes.
- **OU3f, the laws that read only activity** (OU plan §八 step 4, its second part; 348 theorems on `0cc1aafb4`). An audit first, on EC6's pattern, then derivations at WRT2's occurrence model, module by module. A row counts as a case of a grammar law only where the law replaces part of its proof.

After them, the 9,370 theorems that read no field of the old base (frames, processes, runs, numbers, lists) are the largest remaining question of the lifting: whether their statements can be put in the grammar's terms. That gets a design when OU3f's audit shows what the pattern is. *(29 October 2026.)* WRT2 landed (`8882b7995`, study §440). OU3f's audit (`cafb743de`) shows the pattern: of 436 theorems reading only activity, 400 are laws of their models. The no-field layer is therefore taken whole, through a representation of processes both ways (WRP: the other model, the first boundary WRT2's record names), not theorem by theorem. Its design goes to WRT's designer.

## From no gap to the root: full unification (29 October 2026)

No gap is EC's sense of completion: every central declaration has a master law or a named reason. It does not yet make the root the root of every law. Of the 118 distinct central declarations, 43 reach the grammar. Of the other 75, 44 rest on amounts: balance, represented (32); the premises support and dissipation (9); Price's identity (3). Seven more rest on weights. A proposal from the session of the twenty-first review (`../fu-full-unification/PROPOSAL.md`) asked what "full" would require. OU's plan now takes its answer, with three changes, as §十三 item 13 and decision D25:

- **F1.** Every model is represented both ways, amounts included, or the failure is written down at every selection tried.
- **F2.** Every central declaration is either derived from a grammar law or stated at a represented model, and its premises are stated there too. "Balance, represented" does not remain as a category.
- **F3.** The three readings of "more" are joined, or their separation is adopted as central (GW's line).
- **F4.** The five significance rows are stated on the root, with the condition and C still named premises and the free predicate still the general form.
- **F5.** The measure tells derivation, representation at a model, and a named premise apart (MV's line).

The three changes:

- A statement at a represented model counts as a representation, not a derivation.
- If balance is not derived, amounts become the root's second sort only with their interface stated as laws, not as a category name.
- The plan's deferral of the ethics is lifted for F4 alone.

A failure written down with its witnesses completes an item.

The items:

- **U1, balance under a relation.** Units are occurrences whose continuation pairs before ++ given with after ++ taken. A design first, then one independent review, with no Lean claimed. It is taken by the session that proposed it, beside WRP and on disjoint files, and builds on WRT2's occurrence model without editing it. `Flow.balances_iff_units` already says why this is the crux: "the matching is supplied, built from the numbers, not derived from the unfolding." Any pairing at one relatum is just equal counts (Hume's principle), so it would make the item near-definitional. Content can only come from a relation of the unfolding that restricts which pairings exist: units given and taken along the World's own exchanges, continued across the coupling boundary. The design's first question is therefore whether balance under that relation is strictly stronger than count balance, with a witness where counts balance and no matching that respects the exchanges exists, and whether a central law follows from it (`Acting.giversSupported`, `Balances.rise_draws_beyond_inflow`, `joint_excess_ends`). If not, F13's verdict stands, and amounts get their interface as the second sort. The atomism this needs is a modelling choice (natural-number amounts) and is named as one.
- **U2, the 13 definitional rows and 11 statements at a model.** These go on the root after WRP lands, module by module with each module's owner.
- **U3, the significance rows.** These follow U1, for weightings.

*Correction, from WRP's measure at OU3f's receipt.* The theorems that read no field of the old base are not all taken through WRP, as the section "The next layer" and the plan's first wording of item 13 said. Of 11,430, 3,168 are on processes. The other 8,262 are about optima, weightings, regime margins and other structures WRP does not reach. These are theorems of the mathematics the account uses. They come onto the root only where a central declaration uses them, through U2 or U3; otherwise the plan writes down that they do not. Item 13 now says this.

U2 and U3 get board rows when their gates open. Until then they stay here, so that no unclaimed rows lapse on the board.

## What this note does not do

It edits no row but its own, changes no module, and decides no definition another owner holds (rule 3). The board's open-claims table holds the items once they are claimed.
