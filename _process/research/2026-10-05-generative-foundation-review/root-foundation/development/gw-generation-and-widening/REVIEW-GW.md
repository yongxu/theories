# GW: independent review of the study note

AI review, 29 October 2026, Claude Opus 5.5 (`claude-opus-5-5`). Read-only, except for this file. Read: [NOTE.md](NOTE.md), [founding_check.py](founding_check.py) and [founding_check.out](founding_check.out); the Lean sources Grammar, GrammarMap, MapInstances, KeepingWidening, EventualWidening, EventualWideningInstances, ContinuedClasses, Admission, Flow, Dependence, Entropy, Dissipation, Gain, PatternPassing, Arising, Change, HeldPossible, ReachableRanges, CausalGrowth and Founding, at HEAD `01cad0d12` (no Lean file changed since the note's base `f8ad3de80`); the `CORE` list in `check_becoming.py`; chapters 01 §6 and §8.2, 02 §1 and Open, 07 §2; D1, D5 and D65; the records what-keeping-widening-needs, generation-and-degeneration-at-two-grains and where-the-possible-grows; the twenty-first review §2.3, §2.5 and §7; UE7's note §2.5; the board's rules. No Lean was built and no repository checker was run. The note's script was re-run on two variants in the session scratchpad (described in F3). Lean paths below are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## Verdict

The formal skeleton is sound. These hold as stated with the Lean definitions, and their sketched proofs are correct:
- the split laws (§3.1);
- the founding law and its corollaries (§3.2), with the re-proof of `descends_along_passings` a genuine specialization (rule 9);
- the held-possible law (§5);
- the coverage counterexample and the «后守» laws (§9).

Every statement about landed Lean in §2 matches the source. The witness meets the four premises of the descent law, the first law (it is conserving) and the hypotheses of both negative laws. Claims 1–7 hold against the Lean definitions, and the script models `Linked`, beginnings at step 0, activity and «生生» correctly.

The verdict built on these overreaches in four places:
1. The World law gives order-1 carrying renewals recurring somewhere, not generation (F1).
2. The witness is not dissipative, so "meets every World premise" is false. Under 01's dissipation premise, a finite world has neither 全生成 nor keeping opening along any reading that contains carrying on (argued in F2). The two holding together is a property of conserving closed cycles.
3. Along `withinKind` the witness keeps widening only because the founded formations alternate names (c/c′, e/e′). `Linked` links dormant occurrences of one name, and the period-2 variant, with the same lineage structure, does not keep widening. Reading carrying on only while supported removes this, and it is the better reading (F3).
4. The redraw of 生生 conflicts with D65 item 4, 01 §6 and the two-grains record without engaging them. Its line between the structural and the content sense is drawn where the witness passes (F4).

GW1, GW2 and GW5, and the founding law of GW3, can go ahead after the low fixes. GW4 and §§1, 4 and 7 need rework before any change to a document.

## Findings

**F1 (high). "Generation one grain up" overstates the World law.**
- *Where:* §1 item 1 ("A founding is … generation one grain up"; "keeping widening at a grain needs generation one grain up … along every reading of the World that contains carrying on"); §3.2 corollary 5 ("carried by the map's generation along lineage"); §3.3, last paragraph; §4 ("a carrying renewal along the reading (generation)"); §7 ("structural generation one grain up carries it").
- *What is wrong:* `descends_or_founded` and `founds_late_of_keepsOpening` give, up to double negation, a founding after every step: single carrying renewals (`«传»`) at arbitrarily late steps somewhere in the world. Generation is the map's 生成 or 全生成: a branch, or a line, with a renewal ahead of every member (`GrammarMap.lean:240`, `:72`; glossary, the row on 生成). Nothing in the plan puts the foundings ahead of every point of one line.
- *Counterexample:* add to `Founding` a ninth formation `s` that holds its own condition at 1 for ever, with no flow. Every premise still holds, and the world still keeps widening along `withinKind Q`: `s` is linked to itself, and the openings are unchanged. Yet `(0, s)` is neither `«阶全生成» P Es 1` nor `P Es 0`, nor `«阶生成»`: its line is `s` carried on, with no renewal ahead.
- *For a general `R`:* `FoundsAlong.carries` gives `«传»` along all passings at (activity, carrier), which is order 0. So "one grain up" names no class unless `R = withinKind Q`.
- *Fix:*
  - State the World law as: keeping opening along `R` needs, up to double negation, foundings after every step, which are order-1 carrying renewals where `R = withinKind Q`.
  - Keep "generation" for 生成 and 全生成.
  - Keep "keeping widening gives 全生成" only for §5, where it holds: one line, `Steps.next`.

**F2 (high). The witness is not dissipative, and dissipation decides the question.**
- *Where:* §1 item 3 and §6 ("meets every World premise", twice); §1 item 1 ("Under the World premises").
- *What is wrong:*
  - `Founding` is conserving: every present formation gives the closed family exactly what it takes. So it fails 01's dissipation premise (`01-ROOT.md:202`; `Flow.Dissipative`, `Dissipation.lean:246`: a formation that takes gives back at least one unit less).
  - The premises it does meet are the four of the descent law and the first law. Only active relata taking, embodiment, a census and bounded transmission are not checked.
  - Requirements never loosening is not a World premise (the record what-keeping-widening-needs, Conditions; 07 §2).
- *Why it matters (argued by this review, not checked in Lean):* take a finite balanced world, every condition in one list, under dissipation, with requirements never loosening and `R` containing carrying on of the supported.
  - Giving needs uptake (`Dissipative.giving_needs_uptake`, `:314`), and taking does not recur (`Dissipative.finite_taking_not_recurring`, `:459`).
  - Every opening along `R` needs a gain of support at some later step, and so does every carrying renewal along `R`. A gain needs a rise, a rise needs a giving, and a giving needs a taking.
  - So in such a world nothing keeps opening along any such reading, and no supported line is 全生成 along one.
  - A constructive proof needs the rest law in a form with the double negation inside; iterating `¬¬` finitely many times gives it.
- *Consequence:* the reading on which 全生成 and keeping widening hold together exists only in non-dissipative closed cycles, which the account's dissipation premise excludes.
- *Fix:*
  - Replace "every World premise" by the exact list, and say that `Founding` is not dissipative.
  - Add the dissipation corollary, in GW3 or beside it, or at least record it as argued and open.
  - Carry it into §1 items 3–4 and §7.

**F3 (high). Along the kind reading the witness widens through names, not lineages.**
- *Where:* §1 item 4 ("the reading on which the two hold together counts foundings, new lineages"); §6 items 1 and 6; §7 ("it is what keeping widening along a lineage reading counts"); §3.2 corollary 3.
- *What is wrong:*
  - `Web.Linked` asks nothing of activity (`ContinuedClasses.lean:329-331`), and `withinKind` contains carrying on by name. So a dormant formation is linked to its own later occurrences.
  - The witness opens along `withinKind` only because the founded formations alternate between c and c′, and between e and e′.
- *The period-2 variant:* `founding_check.py` with c2→c and e2→e, so the same moves and the same foundings, two at every even step.
  - It keeps every map-level fact: 全生成 at orders 0 and 1, 生生 at the kind class, and the script's equality of the two continuations.
  - It fails to keep opening along `withinKind Q`: the script gives `R_Q (within kind): (True, False)`. The c founded across step `S` (S even) is linked by dormant carrying on to c supported at `S − 1`.
- *So:* keeping widening along `withinKind` is not a function of the lineage structure the map reads, since lines under activity never pass through dormant occurrences. It counts foundings into formations whose name was not supported at the reference step.
- *Better reading, missed:* ask only for carrying on of the supported, `∀ t f, W.Supported t f → R t f f`.
  - The founding law's proof uses carrying on only at a supported `g` ("If not … g is not supported at S + k"), and the landed descent chain is active throughout. So the law, corollaries 1, 2, 4 and 5, and the exclusion along passings all hold under it [argued].
  - The script re-run with `R t g f := (g = f ∧ sup t g) ∨ (passes t g f ∧ same kind)` gives `(True, True)` on both the period-4 and period-2 worlds. With all passings and carrying on only while supported it gives `(True, False)` on both.
- *Fix:*
  - State §3.2 for carrying on of the supported, and define the kind reading with it.
  - Either keep `Founding` and add the period-2 witness, or move the witness to the supported reading and say what the reading by name adds. The period-2 world is also the witness that §1 item 1's "the converse fails" needs and `Founding` does not supply: order-1 全生成 without keeping widening along the same reading, with carrying on by name.
  - Revise §4's interval: its bottom, `itself`, contains dormant carrying on.

**F4 (high). The redraw of 生生 contradicts adopted readings and draws its own line.**
- *Where:* §1 item 5 and §7, "Proposed redraw" ("Structural: generation generating generation. On the map this is generation at two consecutive orders").
- *(a) Readings it does not cite:*
  - D65 item 4, "[生成] is not 生生" (`DELEGATED-CHOICES.md:890`; `02-MAP.md:47`);
  - 01 §6, Reading: "That asks more than renewal of lines" (`01-ROOT.md:149`);
  - the two-grains record's first does-not-show item, "That generation here is the 生生 of life in the whole" (`records/generation-and-degeneration-at-two-grains.md:30`).

  §10 lists none of them for revision.
- *(b) D1 misread:* the redraw gives D1's phrase "generation generating generation" to the structural half only. D1's revision defines the phrase to include changing what can form: "so a course changes what can form, and the capacity to form" (`DELEGATED-CHOICES.md:121`), and the treatise it quotes: "生生还改变接下来能够形成哪些状态". The content sense is inside D1's definition. It is not a second sense the account ran together with it.
- *(c) The line between the senses:* it falls exactly where `Founding` passes. Keeping widening along `withinKind` is called structural, and keeping widening along `itself` or by kind name is called content, though both are `Web.KeepsWidening R` at different `R`. So §7's "none of these structural notions excludes return" holds by the classification. `MergedWitness` (`EventualWideningInstances.lean:392`) already showed keeping widening along a chosen reading in a world that never changes.
- *Fix:*
  - Give an independent criterion for "structural". One candidate is invariance under re-identification (`keepsWidening_reidentify`); by F3, the kind reading with carrying on by name would fail it.
  - Engage D65 item 4, 01 §6 and the record.
  - Describe D1 accurately: the map supplies a carrier of 生生's renewal, and D1's 生生 includes changing what can form.
  - Keep the redraw a proposal, not a "What this changes in the account" list.

**F5 (medium). The necessary condition is stated as an identity.**
- *Where:* §3.3, last paragraph: "Keeping widening along the kind reading is nothing lost at Es 1 together with order-1 renewals recurring."
- *What is wrong:* §3.2 corollary 3 says the converse fails without freshness. The period-2 variant (F3) has nothing lost at `Es 1` and order-1 renewals at every even step, without keeping widening along `withinKind Q`.
- *Fix:* "needs", not "is".

**F6 (medium). Arrivals, passings and openings are run together.**
- *Where:* §1 item 1 ("An arrival that opens is widening's opening"; "every newly admitted occurrence is either carried … or it opens"); §4 ("a passing either continues … or founds, an opening of the reading").
- *What is wrong:*
  - A one-step opening is not `ExceedsAcross`, which links through `Linked` from `S`; corollary 3 itself says so.
  - The dichotomy of passings is false. Take a passing outside `R` into an `h` that another supported `f` `R`-continues into, as when `h` receives from a giver of its own kind and from one of another kind. That passing neither continues nor founds.
  - A founding opens only when it is fresh.
- *Fix:* name three cases: in `R`; a founding; outside `R` but carried by another. Use "founding" for the one-step notion and "opening" only for `ExceedsAcross`.

**F7 (medium). A witness fact is cited as a law.**
- *Where:* §7, first list ("nothing keeps widening by name … or by kind name (§6, item 7)"); §1 item 5 ("The ethics reads it as widening by name or kind").
- *What is wrong:*
  - §6 item 7 is a fact about one witness, not a law of finite wholes.
  - C's order is `Web.Widens`, by name over `F` (D1, `DELEGATED-CHOICES.md:121` and its R25 paragraph). The account has no reading by kind.
  - A general law by kind name is easy where kinds are finitely many. It would be the analogue of `Web.KeepsWidening.not_listed` (`EventualWidening.lean:338`), which by name already refutes keeping widening on `Founding`'s finite `F`, without the first law. That law is neither planned nor proved.
- *Fix:* plan the lemma, or cite item 7 as a witness only. Drop "or kind" from what the ethics reads.

**F8 (medium). `KeepingWidening` is core, not periphery.**
- *Where:* §10, GW3 row: "`Becoming.KeepingWidening` (periphery, a leaf)".
- *What is wrong:* the module is in the pure core (`check_becoming.py:82`, the `CORE` list). It is a leaf, since only `Becoming.lean` imports it. So GW3, and GW4 if it lands there, need empty axiom reports.
- *Fix:* the row should say core. The sketched proofs are constructive (excluded middle only inside `¬¬`), so nothing breaks.

**F9 (medium). The witness's name is already taken.**
- *Where:* §6 and §10, GW4: `Founding`, with `Founding.web`, `Founding.flow` and the rest.
- *What is wrong:* the declarations land in the namespace `Becoming.Founding`. That is already the namespace of the core module `Becoming.Founding` (`Founding.lean:79`: wholes founded by parts of earlier wholes, with Price's transmission term), and SelectionLevels reopens a `Founding` namespace (`SelectionLevels.lean:1088`). Even if no declaration clashes under the root import, one name would carry two senses (AGENTS.md, Proof and naming). `Flow.FoundsAlong` needs to be checked against that sense too.
- *Fix:* give the witness a structural name, for example `KindRelay`. Add a sentence relating `FoundsAlong` to the founding of `Founding.lean`, or choose a different word.

**F10 (medium). The calibration tests only going on against ending.**
- *Where:* §9, `«三域之定当且仅当排中»`, and GW1's "a calibration".
- *What is wrong:*
  - The `Unit` model with `fun _ _ => P` decides only going on against ending. It is `«延尽之定当且仅当排中»` again, and it never tests the boundary between 生成 and 后守.
  - By AGENTS.md (Proof and naming, the bullet on omniscience principles), a calibration of the logic alone is a lemma of the item that needs it.
  - The informative calibration is missed. On a single line (`Steps.next`, a two-valued class), "every point that goes on is 生成 or 后守" says that every sequence changes at arbitrarily late steps or is constant from some step on. That decides whether a line renews again, and it implies LPO: code a sequence that changes at every step until its first 1.
- *Fix:* state that calibration with what it says about the unfolding, or record the `Unit`-model theorem as a lemma.

**F11 (low). `Source` is inside the law, not outside it.**
- *Where:* §11, first bullet: "A web violating them, with support from nothing … is outside the law (`Source.from_nothing`, …)".
- *What is wrong:* `Source` (`KeepingWidening.lean:1425`) meets the four premises of the descent law. It is balanced, its one giver is active, activity is support, and its needs are fixed. It fails only the first law, which §3.2's law does not use. So it is inside the law, and it keeps widening by name only.
- *Fix:* cite a witness that breaks one of the four premises, a gain given by no supported formation, with `Loosening` for the fourth. Or drop `Source`.

**F12 (low). The records are misnumbered.**
- *Where:* §10, Records.
- *What is wrong:*
  - "Its law 5 becomes a corollary of the founding law": law 5 of what-keeping-widening-needs is opened by the opened within a recency bound. The exclusion is law 9 (`records/what-keeping-widening-needs.md:15`, `:19`). "Law 5" is the numbering of UE7's note.
  - "Revise does-not-show items 2 and 3" of the two-grains record: both stay true with «后守». The regions are still undecided without excluded middle, and 生成 and 后守 still overlap where lines branch.
- *Fix:* law 9. The item a redraw would touch is the first (F4).

**F13 (low). §8 is an unlabelled reading.**
- *Where:* §8, "The split law says why the two orders must disagree".
- *What is wrong:* it claims an explanation that no law gives. Stems widen by reversal of the inclusion of precedence (`stems_included_iff`, `CausalGrowth.lean:557`), not by counting births with an empty past. No lemma connects §3's arrivals to CausalGrowth.
- *Fix:* mark it [AI reading] and say "is read as", or drop it.

**F14 (low). Two citations need care.**
- *Where:* §1 item 4, last bullet, and §7 ("a part can keep widening fed from beyond (`Flow.new_beyond_every`)"; "what can do it is a part fed from beyond"); §1 item 3, which calls `RaisedEveryOther` "a second such reading".
- *What is wrong:*
  - `new_beyond_every` (`Gain.lean:341`) is a necessity: novelty needs exchange beyond every finite family. The possibility is `Ladder.frontier_witness`.
  - The keeping widening of `RaisedEveryOther` is `Reaching.KeepsWidening` of the held possible, not `Web.KeepsWidening` of admitted formations.
- *Fix:* cite the ladder for the possibility, and name the held possible's notion. Also say why the returning `Founding` does not contradict `Run.not_keepsWidening_of_returns`: that law reads off configurations, while along a reading other than names `ExceedsAcross` reads links.

**F15 (low). Some planned statements are imprecise.**
- *GW2:* the hypothesis `«则» E L` is used by neither law in §3.1. The second law holds for any `E` and `L`, from `¬¬(P ∨ ¬P)` on `«有前» R L y`.
- *§3.3, `withinKind_cont_iff`:* it holds at every occurrence for reflexive `Q`, not only at active ones.
- *§3.3, missing lemma:* identifying 全生成 along `withinKind` at (A, carrier) with `«阶全生成» P Es 0` also needs a lemma that beginnings under the carrier class agree on the two readings (both reduce to carrying on).
- *§3.3, an iff:* from a supported giver, `FoundsAlong (withinKind Q)` is equivalent to `«传» P A K`. State the iff.
- *§3.2, Definition:* "Since carrying on is in R, h arises across the step" is misattributed. Arising is a clause of `PassesSupport` (`KeepingWidening.lean:520`); it uses nothing about `R`.
- *Corollary 3:* "(j, h)" should be "(j + 1, h)".

**F16 (low). GW5 is a restatement.**
- *The «所及» lemma exists already:* `Steps.reached_of_buqiong` (`Change.lean:782`, imported by HeldPossible), taken at «一», whose 不穷 is immediate.
- *The law:* `«全生成» Steps.next «一» E N` is equivalent to "for every `y ≥ N` some `n ≥ y` begins at `n + 1` under `E`". So `generation_of_heldKeepsWidening` is `begins_of_heldKeepsWidening` (`HeldPossible.lean:383`) restated on the map.
- *Fix:* the record should call it a restatement. The equivalence is the near-definitional law.

## Checked and found correct

- **§2.** Every row matches the source in name, module, hypotheses and statement. This includes:
  - the clauses of `PassesSupport`;
  - `carries_iff` (`¬(active x.1 y.2 ∧ R x.1 y.2 y.2)`);
  - `ExceedsAcross` and `KeepsOpening` (`U ≥ S`, and `U = S` never exceeds);
  - the hypotheses of `whole_not_keepsWidening`: listed `C`, `Distinct`, `Gainless`, `BalancesOn` from `T₀`, `RequiresWithin`;
  - `RaisedEveryOther.both` and `Oscillating.converse_fails`.
- **§3.1.** Both laws are true; the first follows from `«续» R L x y` giving `«有前»`.
- **§3.2.**
  - `FoundsAlong.not_along`, and `FoundsAlong.carries` through `passesSupport_carries_iff`.
  - The founding law, by induction with `Linked.snoc`: excluded middle inside `¬¬`, and `gain_given_by_supported_at` with `Balances.on` and `Acting.giversSupported`.
  - Corollaries 1, 2 and 5.
  - Corollary 4 is a genuine specialization, since `FoundsAlong` is empty along passings. So re-proving `descends_along_passings` from the law meets rule 9.
  - Corollary 3's point about freshness is right.
- **§3.3.**
  - For reflexive `Q`, `«续»` along `withinKind Q` under activity equals `«续»` along passings under `kindClass`.
  - `FoundsAlong (withinKind Q)` gives `«传» P A K`, with no reflexivity needed.
  - Nothing lost along `withinKind` is `«不穷» P K`, by `includesAcrossFrom_iff_endless`.
- **§5.**
  - The law and its proof.
  - The instances: `RaisedRule` and `RaisedEveryOther` (equality of numbers decides holding), and `Oscillating` (the rule changes at every step).
  - HeldPossible imports GrammarMap and Change transitively.
- **§6, the premises.** The flow balances at every condition and step, and only supported formations give. Activity is support, needs are fixed, and the flow is conserving, hence `Gainless`. The eight conditions are listed without repetition, and `RequiresWithin` holds.
- **§6, the passings.** Every claimed passing meets `PassesSupport`: the giver is present and supported, the receiver gains support, its own condition rises, and the give is positive.
- **§6, claims 1–7**, checked by hand against the Lean definitions:
  - openings c, c′, e or e′ within two steps;
  - order-0 renewals at every step;
  - order-1 foundings by a0 or b0 within two steps;
  - 生生 at `(0, a0)`, with the family `{(4k, a0), (4k + 2, b0)}`;
  - by name, something lost at every step;
  - along passings, no opening;
  - by kind name, no opening;
  - period 4.
- **The script.**
  - `linked_from` is `Linked`, and `begins` at step 0 matches `continuationStep`.
  - `act` is support, which is admission on the actual levels.
  - `step(R_P)` is the 缘 of «生生».
  - Its zero-length line in `line_reaches` is harmless here: the targets lie at even steps and the beginnings at odd ones.
- **§9.**
  - The counterexample, against «生成», «守», «退化», «全守» and «传» (here `«传» x y ⟺ R x y ∧ ¬R y y`).
  - «后守» as defined, with the reach condition needed as the note says.
  - «守则后守», «全守则后守», «后守则延», «后守退化不并», and «单行则生成后守不并» through `«单行则族含所及»`.
  - «三域之周»: the restriction of the 延 family stays closed. The `Unit`-model direction of the calibration also holds.
  - Leaving «守» to the owner of `Becoming.GrammarMap` (rule 3).
