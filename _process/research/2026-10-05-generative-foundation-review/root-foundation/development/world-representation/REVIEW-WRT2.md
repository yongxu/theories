# WRT2: the independent review of the Lean

One independent reviewer read the two modules in [tree/Becoming/](tree/Becoming/) against [DESIGN.md](DESIGN.md) §4. The reviewer was an Opus subagent working read-only, and it built nothing. Its report follows, lightly formatted. HTML entities are restored to `=>`, `<` and `>`. Its line numbers are those of the first build ([build-wr-2.log](build-wr-2.log)).

Every finding was taken, in the second build ([build-wr-4.log](build-wr-4.log)). Both modules compile with the whole package and no name clashes ([clash.log](clash.log)).

**Paths.** GT is `tree/Becoming/GrammarTransport.lean`. WR is `tree/Becoming/WorldRepresentation.lean`. D is `DESIGN.md`. P is `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

**What checks out.**
- **Faithfulness (Q1).** Every declaration in D §4 exists, with the design's statement. Some are under new names:
  - `carries_iff_image` → `«对应之像»`;
  - `jin_pullback` → `«尽之拉回»`;
  - `withinStep_carried` → `withinStep_reidentify`;
  - `present_carried` → `identityOn_reidentify` with `Reidentify.mem_map`;
  - `everywhere_endless` → `Steps.along_endless`, which is stated more generally.

  Nothing is missing. One statement is weaker than D says (finding 3). The counts match the log (38/41 and 32/45).
- **Transport (Q3).** Each lemma takes exactly the relations its term reads. Each is a full iff, at `x` and `e.to x` or for the global property, and none is weaker.
  - `«有常之对应»` is right.
  - `«核之对应»` is right both ways: forward with `«像» e.to S`, backward with the pullback and `«回之像»`.
  - `«尽之拉回»` is right, and general enough for its one consumer.
- **Recurrence (Q4).** `arisingRecurs_iff` and `ceasingRecurs_iff` match `World.ArisingRecurs` and `World.CeasingRecurs` (P/Space.lean:191–196) exactly. On an empty type of relata both sides are false, so the existence conjunct is needed and correct.
- **Re-identification.** `reidentify_carries` carries exactly the ten relations the header lists.
- **`falls_exhaust` is a genuine use under rule 9.** Its proof has no induction of its own: `Amounts.falls_end` does the induction, and `«尽之拉回»` carries it. It uses `falls_end` at its simplest instance (the no-rise closure only reflexively, ε = 1), so its content is that whole amounts are well-founded.

## Findings

1. **Significant. The header claims every grammar term is transported** (GT:6–11, GT:29–31). Only 23 listed terms are proved. *Fix:* "for the terms listed below"; the others are not stated here and are added when a consumer needs them.
2. **Significant. `World.lt_split` and `World.le_split` duplicate existing lemmas.**
   - `le_split` is `Becoming.le_dest` (P/Prelude.lean:38).
   - `lt_split` is `gap_of_lt` (P/GrammarLaws.lean:258), whose `i + (d + 1)` is definitionally `i + d + 1`.
   - The prelude's header records that R31 states each such lemma once.
   - *Fix:* delete both, and use `gap_of_lt` and `le_dest`.
3. **Significant. F1′ is weaker than its text.** `StepRelations` has no field for the sign of standing (`0 < level`), which is part of the name-free part. The two witness worlds share their web, so a stronger statement has the same proof. *Fix:* let Φ read the whole web, presence and the signs of exchange.
4. **Significant. "No world's falls hold everywhere" is false as written.** In a world with no relata, falling holds at every occurrence, since there are none. *Fix:* "no world with a relatum falls at every occurrence", and add the two-line corollary.
5. **Significant. The names are financial (`credit`, `debit`), against AGENTS.md's rule on names.** "Debit" also means two things in adjacent docstrings, `ofExchange` takes no `Exchange`, and the theorem proves one half of "exactly". The other half is the definition of `World.Conserves`. *Fix:*
   - use neutral words, and rename `ofExchange`, for example to `ofConservationForm`;
   - state the definitional half, for example `conserves_form := Iff.rfl`;
   - change the design and the board line too.
6. **Significant. Eleven declarations sit in the `World` namespace but read no world.**
   - The eleven: `sameStep`, `withinStep`, `identityOn`, `along_iff_itself`, `later_iff`, `sameOrLater_iff`, `reidentifyAt`, `reidentifyOcc`, and the three carrying lemmas.
   - OU3f will read activity as a partial identity at the occurrence model, and a later rename needs a name that states a wrong meaning.
   - *Fix:* `Web.sameStep`, `Steps.later_iff`, `Steps.sameOrLater_iff`, `Steps.along_iff_itself`, `Reidentify.atStep` and `Reidentify.onOccurrences`, with the carrying lemmas under `Reidentify`. `withinStep` can stay in `World`.
7. **Significant. The grammar lacks the transport lemmas partial identities need.** GT says a predicate is carried as a partial identity, but GT has no lemma for «静», «一» or a partial identity, and the re-identification case is proved by hand. *Fix:* add `«静之像»`, `«一之像»` and the partial-identity lemma (through `«合之像»`), and derive the re-identification case from them.
8. **Significant. The decidedness claims go beyond the Lean.**
   - "Activity, requiring and drawing need not be decided" has no Lean. What the Lean shows is that they range over every proposition.
   - `conservation_iff_decided`'s first half is `Nat.decEq`. The theorem is a calibration of the logic of whole-number equations, so it is a lemma, and it restates `indicates_iff_decided` (P/Decidedness.lean:170).
   - *Fix:* say "range over every proposition, so that every world decides them is excluded middle", optionally with that equivalence. State decidedness with `Decided`, and cite `indicates_iff_decided`.
9. **Significant. The converse is shown only at the level of the world's fields.** `ofRelations_relations` is `Iff.rfl` on fields, while the header claims every model of the occurrence shape is some world's model. *Fix:* add the model-level lemma (coreflexive activity, relations lying within a step, presence by lists), or narrow the claim.
10. **Significant. The header's "What is not shown" is incomplete.** It omits:
    - the amount part's image beyond conservation, and the joint image;
    - that F2, F3 and decidedness rest on whole-number amounts;
    - that the names' step is carried only by renamings, which has no Lean;
    - the claims of question 55;
    - two of the design's boundaries.
11. **Minor.** `«像之谓»` is reflexivity of «谓», needs no correspondence, and its name doesn't say what it proves. Inline it or add `«谓之自反»`.
12. **Minor. Names in GT.**
    - `«对应之逆向»` sits beside `«逆之像»`, where «逆» is the grammar's converse.
    - `«传之所及之对应»` reads as "what 传 reaches", but states "a 传 within reach".
    - The table should say that «对应» abbreviates «一一对应».
    - The header cites `.symm` and `.trans` where the lemmas are named otherwise, and omits `«则之对应»` and `«及之像»` from the table.
13. **Minor.** `«尽之对应»` does two inductions that `«尽之拉回»` already does. Use the pullback both ways, and optionally write its region with `«闭»`.
14. **Minor.** `advances` inside `later_iff` re-proves `Web.reach_advances` (P/Identity.lean:2224).
15. **Minor.** `withinStep`'s orientation is not documented. Requiring, drawing, a need met and taking are 缘 under «逆»; giving runs from giver to receiver.
16. **Minor.** `identityOn` uses "identity" in a second sense, beside identity across a step; prefer `partialIdentity`.
17. **Minor.** `reidentifyAt` is unused. `conserves_reidentify` should be stated as `σ.carry w.Conserves` pointwise, so `Web.line_reidentify` applies directly.
18. **Minor.** "Recurrence is a term at the model" hides that it reads the names, so re-identification does not fix it. Say "a statement at the model through the names' step and the same-step class".
19. **Minor. Wording of F1, re-identification and balance.**
    - F1 compares eleven fields, and its witness covers standings only.
    - "Every relation within a step" should be "the five the model selects".
    - Balance is conservation read along the names, so "alone" overstates.
    - "Represented both ways" is sense (i).
20. **Minor.** `StepRelations` misleads, since steps here are relations across a step, and `.Alike` reuses a word already in use. Use, for example, `WithinStepRelations` and `Agree`.
21. **Minor. The four known deviations, judged.**
    - Importing ContinuedClasses: accept.
    - The partial-identity definition: accept; findings 6, 7 and 16 cover its placement, transport and name.
    - `Steps.along_endless`: accept; fix its docstring (finding 4).
    - `Diagonal.no_injection_of_predicates`: accept the namespace, and name it in the README row and the Lean index.

## What the record may claim, and what it must say does not hold (Q6)

**May claim:**
- the 23 listed terms kept by correspondence;
- «尽» reflected along homomorphisms;
- the ten name-free relations carried by every re-identification, one term shown fixed as the schema's pattern;
- the step order a grammar statement through the names, and the two recurrences exact, including the empty world;
- every activity, requiring, drawing and presence some world's, by construction;
- conservation alone exactly conservation's form on an inhabited type of relata, half of it definitional;
- conservation labelled and difunctional;
- conservation and every amount-induced relation the model selects decided;
- F1 through F3, with exact scopes.

**Does not show:**
1. That amounts are represented: the model does not determine a world's standings (F1).
2. That balance is derived: it is represented only through conservation's step read along the names, and conservation is defined from the balance equation.
3. The amount part's image beyond conservation alone; the joint conditions are examples.
4. Anything about the unfolding beyond the commitment to whole amounts: decidedness comes from `Nat.decEq`, F2 needs relata with no injection into `Nat`, and F3 rests on the least loss one.
5. The converse at the model, unless finding 9's lemma is added.
6. A forward theorem: the forward direction is a schema.
7. Re-identification beyond the ten relations and the activity class, and the claims of question 55.
8. The design's boundaries.

## Verdict

Land after fixes; another full pass is not needed. Findings 1–10 must be fixed before landing, and all are local. Findings 2, 3, 5, 6 and 7 change Lean and need a rebuild with the axiom audit. After that, a read of the diff, the new build log and the record's "does not show" list is enough. Not verified: the definitional equality in finding 2, and that the moves in finding 6 build cleanly; the rebuild confirms both.

## The narrow re-read

The same reviewer read the rewritten modules ([build-wr-4.log](build-wr-4.log)), the clash build and the record's draft list, read-only. Its report follows, lightly formatted. Everything it raised was taken in [build-wr-5.log](build-wr-5.log), the record script and DESIGN.md §7.

All 21 fixes hold in the Lean, and none adds an error. Each changed statement and proof was checked by hand against the package's definitions, and the counts match (41 theorems in 44 declarations, and 34 in 48).
- Finding 3 holds: Φ reads the whole web plus the signs of exchange, and the two worlds share their web definitionally.
- Finding 6 holds: the clash build imports `Becoming` (334 modules) plus the new pair.
- Finding 7 holds: `Reidentify.partialIdentity_carried` is a genuine reuse of «部分恒等之像».
- Finding 9 holds: `ofModel_model` is right in both conjunct directions, through pair eta.
- Findings 11–17 hold: «尽之对应» is two cases of «尽之拉回».

Still wrong, all in text:
- **A.** GT's "each is kept the same way" asserts what the record's last item says is not shown. *Fix:* "each would be kept the same way".
- **B.** "Keeping to correspondences does not give a term" claims a negative result. *Fix:* "that keeping to correspondences gives a term is not stated, since the embedding has no syntax of terms".
- **C.** "Represented only through conservation's step" is false beyond the occurrence model. Unit pairings (`Flow.balances_iff_units`) and an added idle relatum (`World.withRest_closed_iff`, `Flow.balances_iff_idle`) are near-definitional representations too. *Fix:* scope it "at the occurrence model".
- **D.** `conservation_iff_decided`'s docstring cites `indicates_iff_decided`, which the proof does not use. *Fix:* "compare".
- **E.** "Re-identification does not fix recurrence" should cite its witness, `Lineage.world_readings` (Persistence): there a balanced re-identification takes a world whose arising recurs to one where nothing arises.
- **F.** The landing texts and the board's WRT2 claim still use design names (debit–credit, `ofExchange`, `StepRelations`, `everywhere_endless`). *Fix:* add a section mapping them to the implemented names.

The record's list, corrected:
- Item 2 is scoped "at the occurrence model" and names the two other near-definitional representations.
- Item 4 is replaced. That a world leaves its activity undecided cannot be shown (`not_not_decided`); what holds is that every world deciding it is exactly excluded middle. The item adds that F3 runs along one relatum's line and does not settle the open question of rest as the absence of an endless fall, and that F2 gives "not identity", not two relata standing alike.
- Item 5 uses B's wording.
- Item 8 is correct once A is fixed.

**Verdict.** No further review is needed. A–E are wording, and the landing build covers them; F is landing text.
