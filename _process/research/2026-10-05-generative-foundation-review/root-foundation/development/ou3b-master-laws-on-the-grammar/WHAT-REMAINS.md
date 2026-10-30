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

No gap is EC's sense of completion: every central declaration has a master law or a named reason. It does not yet make the root the root of every law. Of the 118 distinct central declarations, 43 reach the grammar. Of the other 75, 44 rest on amounts: balance, represented (32); the premises support and dissipation (9); Price's identity (3). Seven more rest on weights. (After OU3f's closure, study §445, `Web.Whole.family_excess_ends` reaches the grammar through closure: 44 reach it, and 31 rest on balance, represented.) A [proposal](../fu-full-unification/PROPOSAL.md) from the session of the twenty-first review asked what "full" would require. OU's plan now takes its answer, with three changes, as §十三 item 13 and decision D25:

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

*Correction, from WRP's measure at OU3f's receipt.* The theorems that read no field of the old base are not all taken through WRP, as the section "The next layer" and the plan's first wording of item 13 said. WRP's final figures at core receipt `20261029T104256.342764Z` ([measure](../process-representation/measure.json)) are these. Of the 11,409 theorems that read no field, 3,163 (28%) are on processes. Of these, 1,306 (11% of the whole) bind a process (984) or only a frame (322): 51 are wholly in the grammar's terms now, and 194 would be with WRP2. Of the other 8,246, 1,343 name nothing beyond the grammar and the prelude, so they are on the root already. The other 6,903 (60%) are about optima, weightings, regime margins and other structures WRP does not reach. (A first count, 3,168 of 11,430, included 27 generated recursion lemmas.) These are theorems of the mathematics the account uses. They come onto the root only where a central declaration uses them, through U2 or U3; otherwise the plan writes down that they do not. Item 13 now says this.

U2 and U3 get board rows when their gates open. Until then they stay here, so that no unclaimed rows lapse on the board.

## U1's verdict, GW's, and U3's gate (29 October 2026)

**U1** is complete. It was reviewed twice, with a narrow third read, and the second reviewer's verdict is the anchor (`../u1-balance-under-units/DESIGN.md` §0):

> Balance is represented by selected finite frame bijections at every condition; the conditional crossing laws and the normalized residual-count law hold at the specified list selections. This does not derive balance from the unfolding. The attempted identification of residual endpoints with a faithful open exchange model fails when actual boundary traffic is retained; projection does not recover WRT's conservation; correspondence orbits do not exhaust the matching fibre. Global exchange attachment and line laws remain outside the established interface. No numerical consumer is rerouted, and F13's reason remains.

So F2's fallback holds. Amounts are the root's second sort, and its interface is limited to seven laws, checked in scratch (48 theorems, every axiom report empty, all constructive):

1. the frame selection both ways;
2. a fixed predecessor at a frame;
3. the crossing laws joined to `Balances.rise_draws_beyond_inflow`, weak and strong;
4. the residual-count laws;
5. their dissipation case;
6. lossless storage excluded;
7. the stretch law under a supplied pairing.

What stays proposed and uncounted:

- exchange attachment to frames;
- existence of enriched fibres;
- the bridge from frame matchings to «对»;
- unique origin over many steps;
- Little's law;
- 生, 亡 and 住 read on units.

Balance and dissipation are two compatible constraints on one model, not one law. No row changes category. Natural-number amounts are the modelling choice the atomism rests on. No package Lean is claimed. The design's §6 names a later leaf above Flow, behind WRP and OU3f, if the limited interface is wanted in Lean.

**GW** is studied and reviewed, with no Lean yet (`7189b80f7`). It joins generation and widening one way. On the held possible, keeping widening gives 全生成, and the converse does not hold. Its two negative results are the ends of an interval of readings, and the map's three regions do not partition. For F3 this is a join in one direction with its boundary stated. Whether F3 is met is for GW's record, once its Lean (GW1–GW5) lands.

**U3** has its gate open. With U1's verdict, its weightings come onto the root through the second sort's interface, as amounts assigned to what is admitted, not as unit lines. Its rows:

- the five significance rows (`unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds`, `Web.paths_comparison_widens`, `Web.paths_one_object`, `Weighting.widens_iff_every_positive`);
- widening on paths, read as «广» on what a path admits;
- the condition, through its structural reading (GS2).

The condition and C stay named premises, and the free predicate stays the general form. A design comes first, with one independent review, before any Lean. U3 is posted on the board as proposed, for whoever takes 07's significance results.

*(Later, 29 October.)* U3 is taken by the session of the twenty-first review. Its design is reviewed and lands with U1's documents. It states every significance row in the root's terms, as representations, and derives nothing ethical. Two things are asked of it before it lands; U3's board row carries them, since that session takes no messages:

- **A count.** COVERAGE's significance row lists five declarations, but the design's table has six. It needs to say what `Web.paths_extension_iff_widens` is there, and where its row numbers come from.
- **The Lean.** Its items 1 (the leaf of root forms) and 2 (row 10's interface law in `Becoming.Weightings`) are wanted, so that 全四 rests on the package and not on scratch alone. Until they land, 全四 is designed, not met.

## After WRP2: where full unification stands, and what comes next (29 October 2026)

**WRP2 landed** (`f28abafc6`, study §447, core receipt `20261029T142634.455566Z`). Processes are represented in the grammar both ways in Lean, with the record processes-represented-both-ways at 01 §8.1. In `Becoming.GrammarLaws`, «历» passes through a word's relations in turn, and «迭» is its case for one relation repeated. Six laws of «迭» («迭之接», «迭之分», «迭之末步», «迭之逆», «迭之定前», «同行之迭») are proved as its cases, their statements and names unchanged. That law sits in the record master-laws-on-the-grammar, beside the laws of steps counted. The measure did not move: 45 of 127 rows reach the grammar; of the 118 distinct, 44, 31, 7 and 36; no gap ([before](../process-representation/measure-grammar-before.json), [after](../process-representation/measure-grammar-after.json)).

**Where the criterion stands** (plan §十三 item 13):

- **全一 (every model both ways).** The World's relations (WRT2) and processes (WRP2) are represented both ways. Amounts are the root's second sort, with the limited interface U1's reviewed verdict states. Each seam is written down with its witnesses, so 全一 is met as an exact statement of its seams, as item 13 allows. The interface laws are checked in scratch, and are in the package only if a later leaf takes them (U1's §6).
- **全二 (every central declaration on the root).** Of the 118 distinct, 44 reach the grammar and 74 do not. Balance's 31 stay "balance, represented", with U1 as the reason. U2 takes up the definitional rows and the statements at a model.
- **全三 (the three readings of "more").** GW joins generation and widening in one direction. GW3–GW5 landed (`4edb05c1f`, study §448): the law of beginnings, the kind relay and the held possible on the map. GW1 and GW2 stay on GW's line.
- **全四 (the ethics stated on the root).** U3's design is reviewed but not landed. 全四 is designed, not met, until U3's Lean items 1 and 2 land.
- **全五 (the measure tells derivation, representation and premise apart).** Each master law's grammar statement now counts among its anchors (`f1a4f6b81`). Separating representation at a model from derivation is MV's line. It gets its values once U2's and U3's representations land.

**Next, in order:**

1. **U2** (gate open since WRP landed): the 13 definitional or representational rows and the 11 laws of their models and single applications. Each is stated as the grammar reading it is, or at the World's or a process's grammar model through the transport, and counted as a representation (change 1). It goes module by module with each module's owner. Taken by WRT's and WRP's designer. Its design is reviewed, every finding taken, on its branch `u2`: 20 rows read at the models, 3 resist (amounts computed over a family), 1 U3's. Placement is decided on U2's board row; the design lands with its claim.
2. **«保之像» beside «像» in GrammarLaws** (rule 9; WRP2's review; U2's design, §6). Preserving along a map is the image lying within. Mechanism's `factors_image` and `Image.least` become its cases, statements and names unchanged; U2's scratch proves both from «保之像». Mechanism names no owner, so by rule 3's fallback OU's owner decides: yes. GrammarTransport's owner agrees to the removal. GrammarLaws has 322 dependents among the package's 342 modules, so the move goes on HE's list as its sixth edit rather than costing a second near-full rebuild; HE's owner added it. Landed with HE (`6eb479810`, study §455): «保之像» sits beside «像» in GrammarLaws, and Mechanism's `factors_image` and `Image.least` are proved as its cases, which HE's review confirmed; nothing is left in GrammarTransport.
3. **OU3f's lineage laws** (fork 1): landed (`1cd8ef1fe`, study §451), the lineage laws of `Becoming.Identity` proved from the grammar's laws of steps through `Web.steps_iff_lineage`; the measure unchanged (45 of 127).
4. **U3's Lean items 1 and 2**, once its documents land; **GW1 and GW2** on GW's line; **HE**: landed (`6eb479810`, §455), every held edit in one near-full rebuild, the measure unchanged at 45 of 127. Next on fork 1's line, OU3f's last part: the coarse-to-fine pair in Persistence.

After these come plan §八 steps 5–10.

## After OU3f: plan §八 step 4 done, and where the set-aside items go (30 October 2026)

**OU3f is done** (`1636c8a42`, study §459). Every (a) and (b) row of its audit (`cafb743de`) is derived from grammar laws: the laws of steps (§442), the twins (§443), the closure (§445), the lineage laws (§451) and the coarse-to-fine pair (§459), `Web.sheng_state_of_change` and `Web.wang_state_of_change` from «生于粗则生于细» and «亡于粗则亡于细». The 398 laws of their models keep their standing with reasons. Three representations were re-proved through grammar laws, and `Lineage.cons` was retired. The measure is unchanged: 45 of 127 rows reach the grammar.

With that, **plan §八 step 4 (剥前提) is complete** in all four of its parts: the continuation family (OU2, OU3a), the theorems that read only `active` (OU3f), the five master laws (OU3b–OU3e), and the old World's representation (WRT2, with processes in WRP2). The plan's next step is §八 step 5 (丙一与验).

**What the audit set aside, and where each goes.** None is claimed. Each is placed by what would make it a result, not by a count.

1. **The alternation of a two-valued class over a listing** (the seven Decidedness rows marked "(b), not proposed"). They stay laws of their model. They become grammar cases only if alternation is stated as a grammar law, a relation of «两端» read along a listing, that is a reason for more than these seven. That is a question for plan §八 step 5, where each conditional law is written as "Y 当且仅当 Z" with a counterexample, and not a separate item.
2. **`Sampling.arises_within`** (and `ceases_within`), a candidate case of «两端分则中有标» that reads no field (the audit's review: "a (b) candidate"). As stated, the law is not its reason. It takes a class (`«类» K`, reflexive, symmetric and transitive), and with a class it finds a change but not its direction: with K "p alike" the marked step can be a ceasing one. `arises_within` is its case only under "p holds later → held earlier", which is transitive but not symmetric. Its proof uses only transitivity, as its docstring says. So the root law's hypothesis is weakened to transitivity first, with its two consumers in PatternPassing passing their class's `.trans`. Then `arises_within` and `ceases_within` are derived from the given decidability alone. That generalizes a root law (Grammar.lean), so it rides the next planned full or near-full rebuild, as HE's edits did, not Sampling's cone. OU3f's owner takes it then, with a scratch check that the derivations are genuine and no longer than the proofs they replace.
3. **The theorems that read `active` together with other fields.** These are the dependency audit's next groups. Each group is a lift, or a reason, on OU3f's pattern: an audit first, then derivations. Each audit looks for closure cases first (seven of OU3f's fifteen (a) rows were), and reuses OU3f's kit: the classification table, `reach.py`, and the dependency check with a control run on main. The groups are taken in the order the central declarations use them, since full unification (§十三 item 13) asks only that central declarations reach the root.
4. **The layer that reads no field** (WRP's, for example `Reidentify.old_still` and `Linked.mono`). These are taken whole through WRP as statements at a represented model, which 全一 counts. Under §十三 item 13 they enter the root through U2 or U3 only where a central declaration uses them, or the place where they do not enter is written down. No sweep is planned.

**U2 landed** (`08ed13d33`, study §461). `Becoming.ModelStatements` is a core leaf, 78 theorems in 121 declarations, every axiom report empty. 20 of U2's 24 rows are read at the World's or a process's model, as laws at the model in their rows' own 16 records, and MV's F5 verifies each pair and counts it apart. Of the 118 distinct central declarations, 44 reach the grammar, 16 are stated at a represented model, 4 on their own carrier only, and 54 are the rest. 3 rows resist, since their terms are amounts computed over a family, and 1 waits for U3. So 全五 now tells derivation from representation.

**Next, in order:** U3's documents, then its Lean items 1 and 2 (全四). GW1 and GW2 stay on GW's line. The root generalization behind item 2 above rides the next planned full rebuild. After these comes plan §八 step 5.

## The release gate (30 October 2026)

Before the account goes to readers outside the work (the review packet, a note for alignment researchers, or any other release), the items below land. When to send stays a decision with the sender and the consent terms, and on 30 October it was to unify first ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-30-release-after-unification.md)). This section says what has to be true first, and why. A failure written down meets its item, as plan §十三 allows.

**What a release must be able to say.**

1. **The ethics on the root** (全四: U3's documents, then its Lean items 1 and 2). Readers from alignment read the ethics first. Today none of the five significance rows reaches the root, and 全四 is designed, not met. It is met when the five rows are stated in the root's terms in the package, with the condition and C still named premises.
2. **Generation and widening** (全三: GW6 on GW's line, claimed with GW1 and GW2 at `6376f0da3`). The account's direction, 生生 compared by widening, needs the map's generation and the ethics' widening joined both ways, or their split stated as a central result. Today they are joined one way: keeping widening gives 全生成, and the converse does not hold. Either outcome meets the item. It is new mathematics, not restatement.
3. **Every central declaration placed** (全二). Of the 118 distinct central declarations, 44 reach the grammar, 16 are stated at a represented model, 4 hold on their own carrier and 54 are the rest. The item is met when each of the 54 is lifted, or its not entering is written with its reason. U1's seven interface laws for amounts must also be in the package (its §6 leaf), not only in scratch.
4. **Plan §八 step 5** (丙一与验). Each conditional law is written as "Y 当且仅当 Z", with Z in the grammar and a counterexample where Z fails. That is what lets a reader check a law's hypotheses against a situation without reading the Lean.

**What lets an outside reader check it.**

5. **A fresh core receipt**, run with `BECOMING_FRESH=1`, with its logs kept in the repository. At the twenty-first review, 1,349 of 1,360 Lean steps were reused from a cache outside the repository ([review](../../BECOMING-TWENTY-FIRST-REVIEW.md) §3.1). FallibleInquiry's periphery receipt is rechecked too: it was stale at that review, with 19 of its 38 dependencies changed.
6. **The front pages current.** The one page's counts are brought up to date (on `160a0f780` it says 481 registered results, and RESULTS registers 498). The twenty-first review's remaining §6 fixes go in the same pass.
7. **Then the freeze** (the board's way now, item 3): one frozen commit, every dossier re-synced to it, the reader edition built with `--release`, and the sending decisions.

**What does not hold a release.** These are named here so that none is read as a gap:

- the theorems that read no field, which enter the root only where a central declaration uses them (§十三 item 13, and item 4 of "After OU3f" above);
- a derivation of balance, whose failure U1's verdict wrote down, which meets that part;
- models of an organism and an institution (plan §八 step 9), which is modelling work beyond the unification and is named as open on the one page;
- real amounts, continuous time, quantum dynamics and consciousness;
- the warrant of the two premises, which the account names and does not assert.

**Why a gate and not the whole plan.** Plan §十三 asks for steps 5 to 10 in full. That measures the unification, not what a reader needs. The gate takes what would change a statement a release makes (items 1 to 4) and what a reader needs to check it (items 5 and 6). No date is set. OU3 was estimated at five to eight weeks (plan §十一) and took about one, 23 to 30 October 2026, but item 2 has no such precedent.

## One root to its edge: a proposal (30 October 2026)

*For OU's owner, who decides its place and order ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-30-one-root-to-the-edge.md)). Design only: nothing is claimed, no Lean is proposed for the package, and no row, module or definition another owner holds is changed. Nothing below is checked beyond the declarations it names.*

**What the edge is.** Item 13 asks that every central declaration be derived from a grammar law or stated at a represented model, with its premises (F2). Pushing one root to its edge sharpens this into three standings, and only three:

1. **Derived:** it follows from the grammar's laws, for every relation and class.
2. **On the root under a stated hypothesis:** the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped.
3. **A premise:** stated on the root, with a proof that no statement about the dynamics entails it. (Corrected 31 October 2026, from MV's boundary-field spec: this said the continuation condition and C already stand here. Neither does, and standing 3 is empty among the central declarations. The condition has its not-entailed theorem, `ReadsOnlyDynamics.not_entails`, but it is not stated on the root: its root form «续无外» has no such theorem, and its free significance stays off the root, 07 §4.5. C is stated, `Comparison`, with no not-entailed theorem, its reason open apart.)

Any other standing is a distance from the edge, not a place on it. "Balance, represented" and the root's second sort are such distances, and so is a statement at a represented model whose model no stated hypothesis cuts out. Where an item stops short, its failure is written down with witnesses, as item 13 allows. At §461, of the 118 distinct central declarations, 44 reach the grammar, 16 are stated at a represented model, 4 hold on their own carrier only, and 54 are the rest, 31 of them balance, represented. Three levers would cover most of that distance.

**Lever 1: balance joined to closure.** U1 asked whether balance under a relation of the unfolding is strictly stronger than count balance, with a witness, and whether a central law follows from it. Its verdict kept amounts as the root's second sort. Its design did not consult three results already proved, which answer its first question and recast its failures:

- *Locality.* Over relata listed without repetition, transfers along a relation that balance a step exist exactly where the total is conserved on every family the relation closes (`Continuity.balancesOn_iff_conserved`, record [balance-from-conservation-along-a-relation](../../../../../../theories/becoming/results/records/balance-from-conservation-along-a-relation.md)). A family the relation closes is a region closed under the relation read both ways. The teleport is U1's sought witness: swapping two levels conserves the total, and no transfers along the empty relation balance it (`Continuity.Teleport.conserves`, `Continuity.Teleport.no_transfers_apart`). So balance along a relation is strictly stronger than count balance, and what it adds is closure.
- *The census.* Under a continuation with no splits and no merges, what is active after a step together with what ceases equals what was active before together with what arises (`Web.Census.balanceFrom_eq`, record [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md)). Read at a grain of units, with arising across the boundary as given and ceasing across it as taken, this is the balance equation. The tandem's readings show each condition is needed (`Tandem.census`, `Tandem.budding`, `Tandem.joining`).
- *Lumping.* No readout undoes a merge (`Readout.no_restore`).

The proposal turns U1's direction around. U1 went from the World's numbers to unit lines and found the lines not determined: which unit goes where is a selected matching's choice, and the projection does not recover WRT's conservation. Going from unit lines to numbers, the World is the count of a unit model, which is a lumping, and those failures are its expected losses. WRT2's F1, two idle worlds standing at 1 and at 2 alike on every field the model reads (`World.standingAt_alike`), is then the occurrence model's coarse grain forgetting the fine one: the root's own two grains.

Three sub-claims would make this a result, each by design, scratch and one independent review:

- **(a) Locality on the grammar.** `balancesOn_iff_conserved` restated with `«所闭»`, for the relation or its converse, in place of `Continuity.Closes`. The grammar's count law `«守数当且仅当可对»` is its case for `«一»`, where the only closed family is the whole. On each closed region this is the count law again; the content is which regions the count is kept on.
- **(b) The census as a pairing under continuation.** The grammar's header leaves unstated what a pairing under continuation, `«对» («续» R E)`, adds to equal count. (a) and the census state it: locality, and units continuing one to one, arising and ceasing only at the boundary.
- **(c) Amounts represented both ways at the unit grain.** Every unit model whose units continue one to one inside the frame counts to a balanced World, and every balanced World is the count of one; U1's scratch (`KUnits.canonical`) gives the existence. The kept hypothesis, units continuing one to one, is stated with `«生»`, `«亡»` and `«住»` under a unit class. Its countermodels are the tandem, the teleport and the idle world giving itself two units (`World.balance_needs_conservation`).

*The test that decides it* is U1's own, the round trip. The lift counts only if two things hold. The balance hypothesis of the consumers (`Flow.Balances`) gets a root reading with its witnesses. And something read on unit lines is not read on counts: locality per closed region, and F1 explained. If either fails, U1's verdict stands and the failure is written here.

*What would move.* The 31 declarations resting on balance, represented, reached by transport as U2 reached its rows, not by rebuilding `Flow`'s dependents. With them goes the alignment account's drain layer (`Optimum.optimum_beyond`, `Optimum.mutual_beyond`, the frontier laws). F13's reason would become a hypothesis with its witnesses.

*Known results.* Locality is the uncapacitated case of the feasibility conditions for flows (Gale 1957; Hoffman 1960): conservation on each connected part. The census is bookkeeping. What is new is the join: balance as closure's law for counts.

*Owners.* `Becoming.Flow` has no active owner, so rule 3's fallback names OU's owner. Continuity's and Identity's records name theirs, and GrammarLaws is OU's. A grammar-wide law rides the next planned near-full rebuild, as HE's edits did.

**Lever 2: evolution's rows**, 0 of 18 on the grammar. Two candidate readings, neither checked:

- *Exact transmission as continuation.* Transmission at a descent is already stated for one kind as two inclusions in the grammar's terms (`ModelStatements.transmits_at_one_kind`, record [transmission-is-inheritance-and-need](../../../../../../theories/becoming/results/records/transmission-is-inheritance-and-need.md)). The candidate is that exact transmission is the trait class carried along descent: descent lies within its `«续»` under the class. Where it holds, Fisher's exact case and Price's zero transmission term become laws of continuation under a class.
- *The counting identities for every finite relation.* Price's covariance identity holds for any parent-to-offspring relation and any class. Its rows (`SelectionTerm.covariation`, `SelectionLevels.levels_sized`, `SelectionLevels.rises_exact_iff_levels`) go on the root as identities if their proofs read nothing of the model but a relation and counts, which is checked row by row.

The gate rows, "premise of the account" in U1 §4's table, become hypotheses on the root, each with its witness. Rows that read amounts, such as `Reproduction.Flow.number_within_take`, wait on lever 1.

**Lever 3: the direction.** No new item. U3's Lean items 1 and 2 put the significance rows on the root (F4). GW1 and GW2 decide whether strong generation and keeping widening hold together on some reading, or prove their independence exactly (F3). Either answer is a place on the edge.

**Where the edge stays.**

- The continuation condition and C are premises of the account. Only the condition has a proof that the dynamics does not entail it, and neither is stated on the root (corrected 31 October 2026; see item 3 above).
- Amounts are whole units. The pure core is discrete; continuous amounts belong to the periphery.
- A law of a particular model is stated at a represented model, the model cut out by a stated hypothesis, with a countermodel on the root.

**The edge as a result.** Once the levers are done, or their failures written down, one record states what one root carries: every central declaration in one of the three standings, each kept hypothesis with its witnesses. MV's view then counts the standing "on the root under a stated hypothesis" beside derivation and premise (F5).

**Order, if OU's owner takes it.** Lever 1's design, scratch and review come first: it moves the most, and lever 2 partly waits on it. Lever 2's audit, row by row, can run beside it on disjoint files. Lever 3 continues on U3's and GW's lines. The boundary record comes last. This adds no criterion to item 13 and none to the release gate above, which a derivation of balance does not hold: it is one way of meeting F1 and F2 for amounts and for evolution.

## OU's decisions on U4 and on GW1–GW2 (30 October 2026)

**U4 is taken into the plan** as the sharpening of item 13's F2 into three standings: derived, on the root under a stated hypothesis with a countermodel, or a premise proved not entailed by the dynamics. It adds no criterion to item 13 and changes nothing in the release gate. The order is as proposed:

1. Lever 1's design, scratch and one independent review come first, since it moves the most.
2. Lever 2's row-by-row audit of evolution's 18 rows may run beside it on disjoint files. Any Lean it claims names the evolution modules' owners.
3. Lever 3 is U3's and GW's lines, with no new item.
4. The boundary record comes last.

**Shared definitions.** `Becoming.Flow` names no active owner, so by rule 3's fallback OU's owner decides on U4's row. A change to `Flow.Balances`, or to Continuity's or Identity's definitions, goes on that row before any Lean, and statements are kept. A grammar-wide law, such as lever 1 (a)'s restatement with «所闭» in GrammarLaws, rides the next planned near-full rebuild. That is the same rebuild that weakens «两端分则中有标» to transitivity for `arises_within` ("After OU3f", item 2), so one rebuild serves both. MV counts "on the root under a stated hypothesis" as its own standing only once the boundary record lands (F5). Until then the figures of §461 stand: 44, 16, 4 and 54.

**One condition on lever 1's test.** U1 found that unit lines are not determined by counts: which unit goes where is a choice of matching. So a law "read on unit lines and not on counts" counts for the round trip only if it holds for every admissible pairing. Locality per closed region must be invariant under re-pairing. A law that needs one pairing is a discipline, and it is named as a premise (U1's test of content). The design states which of its laws are invariant in this sense, with the witness for each that is not.

**GW1 and GW2: `Becoming.GrammarMap`'s owner says yes.** That owner is OU's owner, through OU4.
- 332 of the package's 350 modules depend on GrammarMap, so adding the laws there would mean a near-full rebuild. The laws go instead in a core leaf that imports GrammarMap. Its row says why it is a leaf: laws of the map that nothing below uses. If a module below comes to need them, they move at a planned near-full rebuild.
- Their laws join the record generation-and-degeneration-at-two-grains, which is OU4's record, so this is its owner's yes.
- GW1's calibration by excluded middle stays a lemma of GW1, not a result, as GW's note says.
- The item is offered to the session that studied them (Join generation to widening), which claims it on the board with a design already reviewed and rechecked (REVIEW-GW, RECHECK-GW).
- GW1 and GW2 close chapter 02's open question on the map's regions: coverage, and the split of a beginning on the root. They do not by themselves join generation and widening both ways; GW4's kind relay and GW5's one-way law with its failed converse already stand. The release gate's item 2 is met by **GW6**, claimed with them (`6376f0da3`): on the course's moments, keeping widening is exactly 全生成 at two grains under stated premises of deciding, and what separates generation under the one from widening is exactly loss, with an alternating chain as the witness. GW6's review checks that the two grains are fixed independently of widening, so that the join is not a verdict built into the choice of classes, and that each premise of deciding states what the need says about the course (AGENTS.md, the pure core).

## U3's standing, and what 全四 counts (30 October 2026)

**U3's design is on main** (landing 1, `ffefcda8d`), and its Lean items 1 and 2 are claimed. They land after LW's texts and RF-M.2's documents. The review of its Lean and kit (REVIEW-U3-LEAN, §1.1) found one thing that bears on the counts.

- **F5 takes no specialization as an item.** An instance of a row states less than the row (MV's F5 specification, §4). Three of U3's root forms fix the free predicate `sig` to its structural reading, `selfAscribed (ownClosure rel) center`: rows 1, 8 and 9 (`noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root`, `paths_one_object_root`). They land as laws in their rows' records with no statements_at_model item, and F5 keeps them among the rest. Rows 5, 7 and 10 carry items, stated in the grammar's terms on their own carrier.
- **What 全四 then means.** F4 asks that the significance rows be stated on the root "with the free predicate still the general form". That is met once items 1 and 2 land: each row has its root form, the condition and C stay named premises, and `sig` stays free in the general statement (SD1). F5's count is a different and stricter measure. It does not count rows 1, 8 and 9 as stated on the root, because their general statement keeps `sig` free, and a root reading of free significance is what 07 §1 keeps open on purpose. Both are stated wherever 全四 is summarized. Neither is reported alone: "met" without F5's count would read the structural reading as the row.
- **Row 10's interface law**, `Weighting.grammar_widens_iff_every_positive`, goes into `Becoming.Weightings` beside `widensOn_iff`. It is one theorem, with no definition changed, registered apart as support like `mixedOn_iff`.
- **«广之对应»** (U3's design §4, item 3) waits for GrammarTransport's owner until something reads it. U3 does not need it. It is listed here, not on the board, since no item uses it.

## U4's levers 1 and 2, reviewed (30 October 2026)

This section was added by U4's taker. It edits no earlier section, but it supersedes one sentence of the proposal's lever 2 paragraph: "Rows that read amounts … wait on lever 1".

**Lever 1: the round trip fails its second test, so U1's verdict stands.** The [design](../u4-one-root-to-its-edge/DESIGN.md) was independently reviewed, and every finding is taken.
- **The test.** Under the condition above, a law of unit lines counts only if it holds over every pairing the counts admit and reads what the counts do not. None was found.
  - What lines read beyond counts is whether a pairing under continuation exists.
  - One-to-one continuation is sufficient for that pairing, not necessary.
  - The counts fix neither.
- **Balance is represented both ways as a one-to-one census,** at a step and across a run.
  - Across a run, the one-step models glue with no relabelling, because each time has one list.
  - The census is built from the numbers. So this is a representation, not a derivation.
- **One-to-one continuation is U1's atomism in the root's words.** It is not a second premise.
- **No row moves, and F13's reason stands.** The open bridge is a World's own occurrences under `«续» R E` as the census model.
- **Laws for `GrammarLaws`.** These ride the near-full rebuild and stay in U4's kit until then:
  - `«对则闭域守数»`;
  - the class law, with its count `«计»`, `List.countP`'s structural twin proved equal with no axiom;
  - the census pairing on `«续» R E`, whose arising and ceasing are `«生»` and `«亡»` on a closed listing.
- **The 31 "balance, represented" declarations, recounted by anchor:**
  - 18 read `Flow.Balances` or `Flow.BalancesOn`;
  - 10 rest only on the prelude's `balance_over_stretch_on`;
  - 3 read `Flow.BalancesBetween`.

**Lever 2: no evolution row waits on lever 1.** The [audit](../u4-one-root-to-its-edge/LEVER-2-AUDIT.md) was independently reviewed, and every finding is taken.
- **The gate.** Both of its parts are inclusions: `acting_iff`, and U2's `dependent_iff`.
- **Rows 1–3, 7 and 8.** The gate is fully stated as inclusions. These rows conclude comparisons of the model's amounts, so they are statements at the represented model.
- **Rows 5, 13, 14 and 17** stand on the root under stated hypotheses. Witnesses are built for rows 5, 13 and 17.
- **Rows 6, 12 and 18** are laws of counting, labelled and counted apart.
- **Row 4** is a law of logic, already stated at the model by U2.
- **Row 9** stays a premise of the account.
- **Rows 10, 11, 15 and 16** keep "balance, represented".

**Lever 2's follow-up: every witness checked against its row.** A second independent read found two hypotheses unwitnessed, `moved` in row 8 and `inactive` in row 17; both now have witnesses (`Kept`, `Lifted.inactive_needed`), and a recheck found the fixes sound. Every hypothesis of rows 1–3, 5, 7, 8, 13, 14 and 17 that is not a list fact now has a witness, and a check module applies each package row, or its form on the root, to its witness, so each failure is the row's own. Scratch: 190 theorems in 253 declarations, and 2 in 2, every axiom report empty.

**The master-law counts agree** (the twenty-first review's §6 item 2). 08 §7's column read 16, 52, 14, 1 and 9 against its prose's 41, 55, 14, 2 and 9, and the coverage report counted 41 central declarations on no master law against the prose's 39. The cause: COVERAGE.json's anchors lagged the measure's, without the laws' statements on the grammar or `Flow.BalancesBetween`. With them set to the measure's anchors, the column, the prose and the report agree.

**What this changes in the figures.** MV's figures stand at 44, 16, 4 and 54 until the boundary record lands (F5).

**What comes next for U4:**
- lever 3, on U3's and GW's lines;
- the boundary record, last.

The two census rows, `Listed.coming_of_ceasing` and `CensusWebs.keep_pace`, are where the census pairing reaches most directly. They are a candidate item of their own.

## U3 landed: the release gate's item 1, and the figures (30 October 2026)

**U3's Lean is on main** (`5b3b5ba8a`, core receipt `20261030T131028.245732Z`, every axiom report empty; study §465). The core leaf `Becoming.SignificanceStatements` restates rows 5 and 7 on their own carrier and specializes rows 1, 8 and 9 at the own-closure reading. Row 10's interface law, `Weighting.grammar_widens_iff_every_positive`, joined `Becoming.Weightings`. It is a restatement, not a derivation: the condition (scope) and C (order) stay premises, and `sig` keeps its general form.

- **The gate's item 1 is met as F4 defines it.** Each of the five significance rows has its form in the root's terms in the package, with the two premises named. F5's stricter count is stated beside it, as "U3's standing" above asks: rows 5, 7 and 10 are F5 items with model own, and rows 1, 8 and 9 are specializations that carry none. 08 §7, the board's clause and §465 give both. The one page and the overview count by law rather than by declaration: of significance's five central laws, two are restated on their own carrier (rows 5 and 7 are two declarations of C's extension and comparison, and row 10 is the other law) and three are specialized, none derived from the root.
- **The figures.** Over the 118 distinct central declarations, F5 now counts 44 reaching the grammar, 16 stated at a represented model, 7 on their own carrier only (U2's 4 and U3's 3) and 51 the rest. `statements_at_model` has 24 entries, none unverified. The gate's item 3 now reads against these: it is met when each of the 51 is lifted, or its not entering is written with its reason. The figure in "U4's levers 1 and 2, reviewed" (44, 16, 4, 54) is U4's taker's and dates from before U3. It is left as written.
- **What is unchanged.** HE2's edits, held for the next near-full rebuild, are untouched, as are «广之对应» (still waiting, with no reader) and the free significance of 07 §1, which stays unlifted on purpose.

**Next, in the coordinator's order:** RF-M.2; then GW (GW1 and GW2 in a core leaf importing GrammarMap, and GW6, the gate's item 2, with L-10's fix and a core run); then UE24, RV21b and AJ6b. After GW, the gate's open items are 2 if GW6 has not met it, 3 (the 51), 4 (§八 step 5), 5 (a fresh receipt) and 6 (the front pages).

## GW landed: the release gate's item 2 (30 October 2026)

**GW1, GW2 and GW6 are on main** (study §467, core receipt `20261030T152859.871907Z`). They add two core leaves, `Becoming.MapRegions` and `Becoming.WideningOnTheMap`, and every axiom report is empty.

- **The gate's item 2 is met by the split stated**, one of the two outcomes the item allows. On a course's moments, under two premises, keeping widening is 全生成 at (nothing lost, the same possible), both ways. That half is a representation, since nothing lost is widening's own inclusion half. With the classes fixed apart from widening, keeping widening is generation under (the one, the same possible) that loses nothing. So what parts the two is exactly loss ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)).
- **What the premises say about the unfolding.** Generation is known by refutation (no predecessor alike), and widening by exhibition (something held that was not). The forward direction is exactly weak excluded middle and the converse exactly excluded middle; exhibiting the point is Markov's principle. The record calls these calibrations of the logic. By the pure core's rule they are lemmas of the item, not results of their own, and none is a gap in the core.
- **What it does not do.** No law compares two courses, so the second-order direction of 生生 stays open, as chapter 7 says. The occurrences and the moments are two carriers, not two grains of one.
- **GW1 and GW2.** `Becoming.MapRegions` is a core leaf importing GrammarMap, as "OU's decisions on U4 and on GW1–GW2" placed it. 02's open item on the gap that strict keeping leaves closes with `Map.Once`.

**The gate after GW.** Items 1 and 2 are met. Still open:
- item 3, the 51 central declarations, each to be lifted or given its reason;
- item 4, §八 step 5;
- item 5, a fresh core receipt with its logs;
- item 6, the front pages current.
HE2's list now has five items. `14c7c0cdf` added «所闭之逆» and the two halves of `Flow.withinCoupling_reads_iff` on «所闭». This commit adds GrammarMap's two edits from GW's history row: the "is not stated" sentence, which MapRegions now answers, and the reach lemmas stated twice over. Its rebuild is still not due.

## OU's decisions on U4's boundary record (30 October 2026)

U4's taker asked for these decisions on the boundary design (`u4-one-root-to-its-edge/DESIGN-BOUNDARY.md` on branch `u4-edge`, `fd31e64bb`, not yet on main).

- **Derived means the law is in the package.** A row is derived when it is a case of a declaration in a `Becoming.Grammar*` module, stated in the grammar's terms. A list kept beside the package would be metadata, and metadata settles no standing. The «» name is the vocabulary, not the standing. (Corrected 31 October 2026.) This bullet said `kept_onward` qualifies. Under MV's content test it does not: its statement is about `Nat` and a predicate on it and reaches no «» term, so it is a law of the steps of time kept in GrammarLaws, not a grammar law. MV's test admits a theorem of a `Becoming.Grammar*` module, not a generated auxiliary, that is a root constant by content and whose statement reaches «际» or another «» term and no closed value. Its proof applies «闭含所闭» and «线则所闭», so what reaches it reaches those (reach), and no row's standing changes.
- **Reach and derived are two figures.** Reach says a grammar law is among a declaration's reasons; derived says the row is a case of one. Of the 44 that reach the grammar, 8 are derived.
- **Standing 2 is the strict reading, with the discharge condition.** The recovery meets each hypothesis of the root form from the row's own by definitions alone. The weaker standing the second review offered, "under a stated hypothesis, met through ⟨lemma⟩", is not taken. It would report which lemmas a proof uses, which reach already measures. It would also let amount reasoning pass as relational. So row 5 and `Flow.Balances.renewedBy` stay at "balance in their statements", and row 5's relational part is recorded in its basis.
- **The juncture law** enters the leaf only if rule 9 holds: it must be a law of the grammar that more than this row uses. Otherwise `Branching.loss_passes_juncture` keeps its distance with its reason.
- **The release gate's item 3.** Once the record lands with no row unplaced, every one of the 51 has its reason written, which meets the item's second branch. U1's seven interface laws for amounts, in the package and not only in scratch, stay open.

## What this note does not do

It edits no row but its own, changes no module, and decides no definition another owner holds (rule 3). The board's open-claims table holds the items once they are claimed.
