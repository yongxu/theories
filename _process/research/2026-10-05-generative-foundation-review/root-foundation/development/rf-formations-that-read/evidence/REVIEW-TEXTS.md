# Cold read of the RF round 1 texts (three readers, 29 October 2026)

Evidence for the [RF plan](../PLAN.md): after the Lean review and before landing, the texts of round 1 (03 §11 and its Open bullet, 05 §8's theorem, 07 §6's pointer, 08's counts, the three records in both languages and study section 445 as it then stood) were cold-read against the three modules by three independent readers, read-only, none reading the earlier reviews first: one cross-model reader (GPT astra, high effort) on both lenses, and two Opus readers on one lens each, exactness against the Lean and the account's rules with RF's place in it. Their returns are below verbatim (the cross-model reader's absolute links made repository-relative and their line suffixes dropped; the Opus readers' structured findings set out as text), then what was taken. The brief is in [BRIEF.md](BRIEF.md). The readers' file and line locations refer to the texts as they stood before the fixes.


## The cross-model reader (GPT astra, both lenses)

**Verdict: The texts need revision. The counts and declaration names check out, but several paraphrases omit hypotheses, one formula changes meaning, and an additional mathematical claim lacks a cited Lean proof.**

1. **High — The added-pair formula omits its endpoint cases.**  
   Location: [what-choices-show-of-an-order.json:53](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json), English and Chinese.

   Quote: “reach to the pair’s first member, the pair and reach from its second”.

   The glossary’s reach is **non-reflexive transitive closure**. Consequently, this wording excludes traversing the added pair alone. `Becoming.ChoiceOccasions.reach_withPair_iff`, without hypotheses, says:
   ```
   reach R a b ∨ ((a = x ∨ reach R a x) ∧ (y = b ∨ reach R y b))
   ```
   Both equality alternatives matter.

   **Replace with:** “Reach after adding `(x,y)` is old reach, or being at or reaching `x`, traversing the added pair, and being at or reaching the destination from `y`.”  
   Chinese: “增 `(x,y)` 后，`a` 及 `b`，恰当原关系中 `a` 及 `b`，或 `(a = x 或 a 及 x)` 且 `(y = b 或 y 及 b)`。”

2. **High — The arbitrary-schedule double-negation claim is not among the checked declarations cited.**  
   Location: [what-readings-fix-of-the-unread.json:75](../../../../../../../theories/becoming/results/records/what-readings-fix-of-the-unread.json), both languages.

   Quote: “with one occasion and a constant lumping, read where P holds, fixing is ¬¬P”.

   This is an additional mathematical equivalence, despite appearing under `does_not_show`. Neither `Unread.lean` nor the cited lumping declarations in `Learning.lean` establishes it. The act-value type is also unspecified. `Learning.determines_lumped_iff` instead requires listed data, `DecidableEq K`, and supplied values `y ≠ z`. AGENTS.md requires an actual Lean check for each new proof claim.

   **Replace with:** “The converse for arbitrary read schedules is not established here; the checked equivalence uses listed read occasions.”  
   Chinese: “此处未建立任意读取安排下的逆向结论；已检验的等价式要求读处以列表给出。”

3. **High — Existing learning results receive a second theorem statement.**  
   Locations: [03-KNOWING.md:436](../../../../../../../theories/becoming/chapters/03-KNOWING.md), compared with [its existing §6 statement:186](../../../../../../../theories/becoming/chapters/03-KNOWING.md).

   Quotes: “has its act fixed … exactly where”; “is right exactly where the world takes one value”.

   These restate `Learning.determines_lumped_iff` and `Learning.lumped_right_iff`, already stated under `r-generalization-through-lumping`. Calling the data “read occasions” changes their reading, not the result. This conflicts with the one-home-statement rule. The new twin and factored-map results remain distinct additions.

   **Replace those sentences with:** “The determination and correctness criteria are those of [§6](#r-generalization-through-lumping), applied with the read occasions as data.” Keep the new results here.

4. **High — Interpretations enter the record’s laws without their AI label.**  
   Location: [what-readings-fix-of-the-unread.json:51](../../../../../../../theories/becoming/results/records/what-readings-fix-of-the-unread.json); also the three records’ `correspondence` fields.

   Quote: “is detected and not acted on … detectable and not detected”.

   `Learning.Cue.apart_with_content_alike` proves only that two specified pairs differ while their content acts agree. Its interpretation as detection is explicitly under the AI-reading distinction in the module, but appears as a law in the record. The correspondence fields likewise say “readings” without identifying them as AI readings. AGENTS.md explicitly requires that label.

   **Replace the law with:** “Witness: the two occasions differ while their content acts agree; taking identity or content as the state gives the two failed converses.” Put the detection interpretation separately under **“AI reading”**. Prefix the correspondence interpretations with **“AI reading” / “AI 解读”**.

5. **Medium — The order summaries lose two different hypotheses.**  
   Locations: [03-KNOWING.md:431](../../../../../../../theories/becoming/chapters/03-KNOWING.md); [what-choices-show-of-an-order.json:13](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json).

   Quotes: “Beyond that reach … orders rank the two both ways”; “The positive comparisons shared by every strict order … are exactly the reach”.

   `ChoiceOccasions.both_ways_of_unreached` requires **both** `¬ reach x y` and `¬ reach y x`, besides distinctness and acyclicity. Missing one directed comparison does not suffice. Separately, `above_in_every_iff_reach` requires acyclicity; the record’s opening equality is unconditional, although its later law states the condition correctly.

   **Replace the chapter sentence with:** “With no cycle shown, two distinct alternatives that neither reach one another can be ranked in either direction by according strict orders.”  
   **Replace the record summary with:** “An according strict order exists exactly where nothing shown returns. Under that condition, the positive comparisons shared by every such order are exactly the shown reach.” Mirror these conditions in Chinese.

6. **Medium — Correct transfer requires fitting the observations.**  
   Locations: [03-KNOWING.md:436](../../../../../../../theories/becoming/chapters/03-KNOWING.md); [what-readings-fix-of-the-unread.json:70](../../../../../../../theories/becoming/results/records/what-readings-fix-of-the-unread.json).

   Quote: “an act carried … is right exactly where the world takes one value at the two”.

   `Learning.lumped_right_iff` assumes `Lumped π g`, **agreement of `g` with the world `f` on the data**, `D d`, and `π d = π x`. Agreement between the world’s two values alone cannot make an incorrectly fitted act correct.

   **Replace with:** “For a law fitting the world on the read occasions and going alike across the lumping, transfer to an occasion sharing a read occasion’s lump is right exactly where the world agrees at those two occasions.” Add the fitting premise to the Chinese field too.

7. **Medium — Cascade summaries obscure the starting member and the universal-history premise.**  
   Locations: [05-COLLECTIVES.md:236](../../../../../../../theories/becoming/chapters/05-COLLECTIVES.md); [readers-reading-readers.json:13](../../../../../../../theories/becoming/results/records/readers-reading-readers.json), and its `related` field at line 143.

   Quotes: “every later member”; “where members read one another’s acts, only what couples into those read first”.

   `Turns.ReadsOnlyActsFrom k` includes **member `k` itself**, and quantifies over **every earlier-act list**, including unrealized lists. Merely reading others’ acts does not imply ignoring one’s own coupling. `acts_alike_of_cascade` and `cascade_through` need this full premise; the latter concerns each finite prefix.

   **Replace with:** “Suppose every member `n ≥ k`, including `k`, has a law independent of its own coupling at every earlier-act list. Then worlds agreeing on couplings at indices `< k` produce identical finite act prefixes.” In the related-record description, replace “where members read one another’s acts” with “under this cascade premise”. Chinese should use “自第 k 员起（含第 k 员）” and state “对每一前行列表”.

8. **Medium — The cue witness loses the premise that a law is already selected.**  
   Location: [what-readings-fix-of-the-unread.json:40](../../../../../../../theories/becoming/results/records/what-readings-fix-of-the-unread.json), its counterexample at line 99, and `statement.zh` at line 14.

   Quote: “a formation coupled into the cue has a selected twin”.

   `Learning.Cue.seen_twin` requires both `Through (AgreeOn read) select` and **`select contentAct`**. A selection accepting nothing supplies no selected twin. The Chinese summary also drops the English summary’s starting “a selected law”.

   **Replace with:** “For any selection through agreement on the read occasions that selects `contentAct`, the identity-coupled witness has a selected twin answering false at `(false,true)`.”  
   Chinese summary repair: “给定一个已被选择、经归并而读的行律……存在同样被选择的孪生行律。”

9. **Medium — The training-related field attributes exact identification to an arbitrary training.**  
   Location: [what-choices-show-of-an-order.json:211](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json), both languages.

   Quote: “a training … fixes … exactly the shown reach”.

   `ChoiceOccasions.above_in_every_iff_reach` quantifies over **all according strict partial orders**, under acyclicity. It does not represent a training procedure. A restricted candidate class can fix more; the chapter’s AI reading correctly includes “imposes no further restriction”, but this field omits it.

   **Replace with:** “AI reading: with no cycle shown and no restriction beyond strict accordance, the positive comparisons common to all candidate orders are exactly the shown reach; this does not establish what a particular training installs.” Mirror both qualifications in Chinese.

10. **Medium — “Exact” literature placements exceed the stated correspondence.**  
    Locations: [what-choices-show-of-an-order.json:183](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json); [what-readings-fix-of-the-unread.json:126](../../../../../../../theories/becoming/results/records/what-readings-fix-of-the-unread.json).

    Quotes: “goal misgeneralization in exact form”; “the exact kernel of … deceptive alignment”.

    `Untried.same_search_after` establishes different outputs for two supplied orders, without a training installation or independent objective. `Learning.twin_selected` establishes observational indistinguishability under its stated selection premise, without anticipatory reasoning or a preservation motive. Those omitted features matter to the cited phenomena: Hubinger treats learned optimization and its objective, while Greenblatt’s alignment faking involves strategic compliance to preserve later behaviour. [Hubinger et al.](https://www.fhi.ox.ac.uk/wp-content/uploads/1906.01820.pdf), [Greenblatt et al.](https://arxiv.org/abs/2412.14093)

    **Replace with:** “AI reading: an identification boundary relevant to inner alignment and goal misgeneralization” and “AI reading: an indistinguishability boundary relevant to evaluation awareness and deceptive alignment.” The chapter already gives the more accurate scope.

11. **Medium — Armstrong–Mindermann is mischaracterized as the reference for choices among equals.**  
    Location: [what-choices-show-of-an-order.json:183](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json), both languages.

    Quote: “Armstrong and Mindermann 2018 for choices among equals”.

    `ChoiceOccasions.weakly_forces_no_comparison` uses the empty strict relation to show that weak accordance forces no positive comparison. Armstrong–Mindermann’s principal result concerns ambiguity in **jointly inferring a planner and reward**, including under simplicity priors—not specifically tie-breaking among equal alternatives. [Paper](https://proceedings.neurips.cc/paper_files/paper/2018/file/d89a66c7c80a29b1bdbab0f2a1a94af8-Paper.pdf)

    **Replace with:** “Ng and Russell 2000 on reward degeneracy; Armstrong and Mindermann 2018 on planner–reward ambiguity, a related identification problem not formalized here.” Make the same distinction in Chinese.

12. **Low — The network boundary excludes cases the representation already permits.**  
    Location: [readers-reading-readers.json:88](../../../../../../../theories/becoming/results/records/readers-reading-readers.json), both languages.

    Quote: “networks where members read only some earlier acts”.

    `Turns.law : Nat → O → List A → A` may ignore arbitrary list entries. Consequently, restricted access can be represented, and the cascade theorems still apply when `ReadsOnlyActsFrom` holds. What is absent is an explicit access graph and graph-specific results; the module’s introduction states this correctly.

    **Replace with:** “An explicit graph of which earlier acts each member can read, and results specific to that graph.”  
    Chinese: “显式表示各成员可读哪些前行的图，以及该图上的专门结果。”

13. **Low — The Chinese search description omits the no-result case.**  
    Location: [what-choices-show-of-an-order.json:96](../../../../../../../theories/becoming/results/records/what-choices-show-of-an-order.json).

    Quote: “搜取所列中……之首者”.

    English includes “or none”; Chinese does not. `ChoiceOccasions.Untried.search` returns `Option Alt` through `List.find?`, so a qualifying alternative need not exist. Its two evaluation theorems concern only the specified menus.

    **Replace the opening clause with:** “搜取所列中居每一与其相异的备择之上的首个备择；若无则返回 none。”

14. **Low — The prose assumes a nonempty menu that the structure does not require.**  
    Location: [03-KNOWING.md:431](../../../../../../../theories/becoming/chapters/03-KNOWING.md).

    Quote: “At each occasion something is open”.

    `Becoming.ChoiceOccasions` supplies an arbitrary menu predicate and a picked alternative. It requires neither menu nonemptiness nor `PicksOpen`. The general laws retain that broader scope.

    **Replace with:** “Each occasion supplies a predicate of open alternatives and a picked alternative; the general laws do not require the picked alternative to be open.”

No issue found in the module counts **27/39, 7/10, 7/13**, chapter 08’s receipt totals, cited declaration names, checked local links, the Open bullet, or §445’s Boundary list. The structural names and relational framing introduce no separate-agent ontology. Apart from the translation differences noted above, the Chinese fields track the English, including its identified problems.

The review remained read-only; no builds, renders, edits or commits were performed, and the earlier-review evidence folder was not read.

── cx · ok · session 01a187b1-9af0-7030-8aea-0246a04c9e44 · gpt-6-astra/high · read-only · 517s · 2011.2k tokens · 22 cmds
continue: cx -r 01a187b1-9af0-7030-8aea-0246a04c9e44 "…"
log: /Users/ren/.cache/cx/runs/20261029-194525-58409

## The exactness reader (Opus, lens A)

**Verdict.** The names, counts and receipt figures are exact, and most sentences about the laws match the Lean. But one record states a mathematical fact that no Lean declaration proves (the ¬¬P remark), and several headline statements leave out hypotheses the Lean needs: no cycle shown; the list form, decided lumps and two act values; selection through agreement on the readings; the cascade premise "from member k on"; and lumped_right_iff's fit. Method: I read the three modules in full and checked every cited name against a namespace-aware scan of the source. I counted top-level theorem, def, structure, inductive, instance and abbrev declarations at column 0. I left out generated projections, constructors and injEq lemmas, and dropped one docstring line in ShownOrder.lean:62 that begins with "class". That gives ShownOrder 27 theorems in 39 declarations (27 theorem, 10 def, 1 structure, 1 inductive), Unread 7 in 10 (7 theorem, 2 def, 1 abbrev) and Cascade 7 in 13 (7 theorem, 5 def, 1 structure). These match the receipt's per-module lists and the counts stated in the study.

**1. High** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:75-76 (does_not_show[1], en and zh)

- Quote: The exact form for an arbitrary schedule: with one occasion and a constant lumping, read where P holds, fixing is ¬¬P.
- Problem: This states a mathematical fact (determination equals ¬¬P) that no Lean declaration proves. I searched Unread, Learning and LearningRuns and found no such lemma, and AGENTS.md requires Lean for every new proof claim. As written it also leaves out the conditions it needs. With only one act value, fixing holds for every P. The direction ¬¬P → fixing needs decidable (stable) equality of act values. The fact is true for two decidably distinct act values (Bool), so the fix is small. The same hand argument appears in PLAN.md §4.2, statement 1.
- The Lean: Only determines_lumped_iff [DecidableEq K] {data : List I} (two : y ≠ z) : Determines (Lumped π) (· ∈ data) x ↔ ∃ d, d ∈ data ∧ π d = π x, and lumped_determines (the sufficient side, for any D). No declaration states Determines … ↔ ¬¬P.
- Replacement: Either add a core lemma and cite it (for V := Bool: Determines (Lumped (fun _ : Unit => ())) (fun _ => P) () ↔ ¬¬P, constructive by case analysis on Bool equality), or reword. en: "The exact form for an arbitrary schedule, which is not proved here; constructively it needs the read occasions listed (a hand argument, not checked: with one occasion, a constant lumping, the occasion read where P holds and two act values with equality decided, fixing amounts to ¬¬P)." zh: "任一读时之确形，此处未证；构造地需读处为列（手证，未经检验：一时、归并恒定、P 成立处为读、行有二值且其相等可判定，则所定为 ¬¬P）。"

**2. Medium** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:13-14 (statement en/zh)

- Quote: Readings fix a formation's act where it is not read exactly where its lumping ties that occasion to a read one; where it can tell the occasion from every read one, a selected law has a selected twin
- Problem: The headline leaves out every hypothesis the laws need. (a) "exactly where" is determines_lumped_iff, which needs the read occasions as a list, equality of lumps decided and two act values. The record's own does_not_show[1] says the exact form fails constructively for an arbitrary schedule, so the headline as written contradicts the record. (b) The twin needs four further conditions. The selection must be through agreement on the readings; otherwise the twin need not be selected. The first law must read through the lumping. Being in the occasion's lump must be decided. "Acting otherwise" needs a value other than the first law's. The zh also drops "a selected law": 有所选之孪生 names no original. laws[3] (line 40) and counterexamples[0] (line 99) likewise say "a selected twin" without naming the selection.
- The Lean: determines_lumped_iff [DecidableEq K] {data : List I} (two : y ≠ z). twin_selected [∀ i, Decidable (π i = π x)] (unseen : ∀ d, R d → π d ≠ π x) (through : Training.Through (Training.AgreeOn R) select) (lumped : Lumped π g) (chosen : select g) (v : V) : ∃ h, Lumped π h ∧ select h ∧ Training.AgreeOn R h g ∧ h x = v. seen_twin also takes through and (chosen : select contentAct).
- Replacement: en: "With the read occasions listed, equality of lumps decided and two act values, readings fix a formation's act where it is not read exactly where its lumping ties that occasion to a read one; where, with being in its lump decided, the formation can tell the occasion from every read one, every law reading through the lumping that a selection through agreement on the readings selects has, for every other value, a selected twin reading through the lumping, agreeing with it on every reading and taking that value there." zh: "读处为列、归并之相等可判定、行有二值，则读处定一成形于未读处之行，恰当其归并将此时系于一读处；「在此时之归并中」可判定而其能分此时于每一读处，则凡经读处之合而选者所选之经归并而读之律，于每一他值皆有所选之孪生，经归并而读，于每一读处与之合，而于此处取此值。" In laws[3] and counterexamples[0], add "for every selection through agreement on the readings that selects the content act".

**3. Medium** — theories/becoming/results/records/what-choices-show-of-an-order.json:13-14 (statement en/zh) and :121-122 (hypotheses[2])

- Quote: The positive comparisons shared by every strict order that strict choices could come from are exactly the reach of the relation they show; such an order exists exactly where nothing shown returns
- Problem: The first and last clauses hold only when no cycle is shown, but the statement gives acyclicity as a separate clause, not as their condition. With a cycle no strict order accords, so every comparison is vacuously shared and forced. Then both "exactly the reach" and "no comparison is forced" fail. Example: a shown two-cycle between a and b, and an alternative c never met; "a above c" is vacuously shared but is not in the reach. hypotheses[2] gives the no-cycle condition only for the freedom, not for the exactness of the shared comparisons. laws[3] and laws[5] are correct, and so is 03 §11, which says "Then".
- The Lean: above_in_every_iff_reach (none : «无环» ch.Shown) : (∀ P, (∀ a, ¬ P a a) → trans → ch.Accords P → P x y) ↔ «及» ch.Shown x y. above_in_some_of_unreached and both_ways_of_unreached also take none.
- Replacement: statement en: "Strict choices come from some strict order exactly where nothing shown returns; then the positive comparisons shared by every strict order they could come from are exactly the reach of the relation they show, and beyond that reach no comparison is forced." zh: "严择出于某一严序，恰当所示无返；其时严择所可出之每一严序所共有之正比较，恰为其所示之关系之及；及之外，无比较为所迫。" hypotheses[2] en: "The exactness of the shared comparisons and the freedom beyond the reach need no cycle shown; the freedom needs the two alternatives distinct and the second not reaching the first (both ways: neither reaching the other)." zh: "所共有之比较之确与及外之自由皆需所示无环；自由又需二备择相异且次者不及首者（两向：互不相及）。"

**4. Medium** — theories/becoming/results/records/readers-reading-readers.json:13-14 (statement en/zh); theories/becoming/chapters/05-COLLECTIVES.md:236

- Quote: From the member on whom every later member reads only the acts before it, a pool's acts are alike across worlds alike through the earlier members' couplings
- Problem: The premise is garbled. Its natural reading excludes the named member, and the zh says so explicitly (其后每一成员, every member after it), while "the earlier members'" (05: "the members before") has no fixed referent. The Lean premise includes member k itself (k ≤ n), and the alike condition is on the members j < k. On the reading "members after m read only acts; worlds alike through the members before m" the claim is false, because member m still reads its own coupling. The record's laws and hypotheses index by k correctly, so the headline indexes differently from them. Neither the record nor 05 states how strong the premise is: independence on every input, including histories no run reaches, which the Lean docstring stresses. The same wording is in README.md:192 and README.zh.md:135.
- The Lean: ReadsOnlyActsFrom k := ∀ n, k ≤ n → ∀ o o' before, T.law n o before = T.law n o' before. AlikeBefore k w w' := ∀ j, j < k → T.coupling j w = T.coupling j w'. act_alike_of_cascade (cascade : ReadsOnlyActsFrom k) (alike : AlikeBefore k w w') n : T.act w n = T.act w' n.
- Replacement: Record en: "Where every member from member k on acts alike whatever its own coupling, on every list of earlier acts, a pool's acts are alike across worlds alike through the couplings of the members before k: they reach only what couples into those members, however many follow." zh: "自第 k 员起，每员于每一前行之列皆不论其耦合而同行，则池之行于第 k 员前诸员之耦合无别之二世界皆同：其所及唯在彼诸员之所耦合入，后继者多寡不论。" 05:236: "Where every member from member `k` on acts alike whatever its own coupling (on every input, histories no run reaches included), every member's act is alike across worlds alike through the couplings of the members before `k` (…)".

**5. Medium** — theories/becoming/results/records/readers-reading-readers.json:143-144 (related[0] en/zh)

- Quote: where members read one another's acts, only what couples into those read first.
- Problem: This leaves out the cascade premise. Members that read one another's acts and also their own couplings carry their own couplings, so "only what couples into those read first" is stronger than what is proved. The bound holds only where, from some member on, every member ignores its own coupling.
- The Lean: acts_alike_of_cascade needs (cascade : T.ReadsOnlyActsFrom k). separates_at: after the same acts, a member's act differs exactly where its law tells apart its coupling values, so a member that reads its coupling carries it.
- Replacement: en: "A pool reaches no further than the union of its members' closures; where from some member on every member reads only the acts before it, its acts reach only what couples into the members before that one." zh: "池之所及不逾其诸员之闭包之并；自某员起每员唯读其前之行之处，诸行唯及彼员前诸员之所耦合入。"

**6. Medium** — theories/becoming/chapters/03-KNOWING.md:431

- Quote: Beyond that reach no comparison is forced: given `x ≠ y` and no cycle, orders rank the two both ways (`ChoiceOccasions.both_ways_of_unreached`)
- Problem: A hypothesis is missing: ranking both ways needs neither alternative to reach the other. Take the listed conditions (x ≠ y, no cycle) and read "beyond that reach" as x not reaching y; the claim then fails where y reaches x, since every according strict order puts y above x. The one-sided law that carries the freedom (above_in_some_of_unreached) is not cited. The record's laws[5] states this correctly.
- The Lean: both_ways_of_unreached (none : «无环» ch.Shown) (apart : x ≠ y) (xy : ¬ «及» ch.Shown x y) (yx : ¬ «及» ch.Shown y x). above_in_some_of_unreached (none) (apart : x ≠ y) (unreached : ¬ «及» ch.Shown y x) : ∃ strict according P, P x y.
- Replacement: "Beyond that reach no comparison is forced: with no cycle, `x ≠ y` and `y` not reaching `x`, some strict order according with the choices puts `x` above `y` (`ChoiceOccasions.above_in_some_of_unreached`), and where neither reaches the other, orders rank the two both ways (`ChoiceOccasions.both_ways_of_unreached`), since …"

**7. Medium** — theories/becoming/chapters/03-KNOWING.md:436 (last sentence); theories/becoming/results/records/what-readings-fix-of-the-unread.json:70-71 (does_not_show[0] en/zh)

- Quote: Fixed is not right: an act carried to an occasion sharing a read one's lump is right exactly where the world takes one value at the two (`Learning.lumped_right_iff`)
- Problem: The law's hypotheses are missing: the law reads through the lumping and fits the world on the read occasions. Without the fit the iff fails. A lumped law that is wrong at the read occasion d can be right at x where the world differs between d and x. The Unread module docstring keeps the condition ("for a law fitting the observed values"); the chapter and the record drop it.
- The Lean: lumped_right_iff (lumped : Lumped π g) (fits : ∀ i, D i → g i = f i) (at_d : D d) (same : π d = π x) : g x = f x ↔ f d = f x.
- Replacement: 03: "Fixed is not right: for a law reading through `π` that fits the world on the read occasions, its act at an occasion sharing a read one's lump is right exactly where the world takes one value at the two (`Learning.lumped_right_iff`)". Record en: "That fixed is right: for a law reading through the lumping and fitting the world on the read occasions, its act at an occasion sharing a read one's lump is right exactly where the world takes one value at the two (Learning.lumped_right_iff)." zh: "所定即正：经归并而读且于读处合于世界之律，其于与一读处同归之时之行，恰当世界于二处取一值时为正（Learning.lumped_right_iff）。"

**8. Medium** — theories/becoming/results/records/what-choices-show-of-an-order.json:211-212 (related[0]) and :183-184 (correspondence)

- Quote: Read with training: a training reading a trained law's choices fixes of the order it carries exactly the shown reach.
- Problem: This states without its premises what the Reading in 03 §11 makes conditional: the trained law chooses strictly by a strict order, and the training imposes no further restriction on the orders. It also contradicts the record's own does_not_show[1] ("a narrower class holding an according order fixes at least as much"): a training whose architecture's class is narrower fixes more than the shown reach. The correspondence field's "goal misgeneralization in exact form" is likewise stronger than 03's "a possibility located exactly, not a failure shown".
- The Lean: above_in_every_iff_reach quantifies over every irreflexive transitive P with ch.Accords P, under «无环» ch.Shown. No declaration concerns training, a class of installable orders, or a law choosing by an order.
- Replacement: related[0] en: "Read with training: where a trained law chooses strictly by a strict order and the training reads only its choices and restricts the orders no further, what it fixes of that order is exactly the shown reach; a narrower class can fix more." zh: "与训练并读：已训之律依一严序严择，而训练唯读其择、于序不另加限，则其于此序所定者恰为所示之及；较窄之类可定更多。" correspondence: replace "(inner alignment, goal misgeneralization in exact form)" with "(inner alignment; goal misgeneralization as a possibility located exactly, not a failure shown)", and in zh replace "（内对齐、目标误泛化之确形）" with "（内对齐；目标误泛化为确定其处之可能，非所示之败）".

**9. Medium** — theories/becoming/results/records/what-choices-show-of-an-order.json:53-54 (laws[4] en/zh)

- Quote: Reach with one pair added is reach without it, or reach to the pair's first member, the pair and reach from its second
- Problem: The equality cases of the exact form are missing: a path may start at the pair's first member or end at its second. «及» is the transitive closure, not the reflexive one, so the iff as described is false. Take a = x and b = y in an acyclic R: the added pair alone gives reach, but the described right-hand side needs «及» R x x. The 03 text ("a path through the pair") and the Lean docstring ("or being it") are right.
- The Lean: reach_withPair_iff : «及» (withPair R x y) a b ↔ «及» R a b ∨ ((a = x ∨ «及» R a x) ∧ (y = b ∨ «及» R y b)).
- Replacement: en: "Reach with one pair added is reach without it, or reach to the pair's first member (or being it), the pair, and reach from its second (or being it); …" zh: "增一对后之及，或为未增之及，或为及于对之首（或即其首）、经此对、自其次而及（或即其次）；…"

**10. Medium** — _process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md:20565-20567 (§445 Delta, RF2)

- Quote: so a selected act law has, for every value, a selected twin agreeing on every reading (twin_selected)
- Problem: The central condition is missing: the selection is through agreement on the readings, and without it the twin need not be selected. The text also omits that the act law reads through π and that the twin takes that value at x. The package README.md:191 row has the same compressed wording.
- The Lean: twin_selected … (through : Training.Through (Training.AgreeOn R) select) (lumped : Lumped π g) (chosen : select g) (v : V) : ∃ h, Lumped π h ∧ select h ∧ Training.AgreeOn R h g ∧ h x = v.
- Replacement: "so every act law reading through π that a selection through agreement on the readings selects has, for every value, a selected twin reading through π, agreeing with it on every reading and taking that value at x (twin_selected)"

**11. Low** — theories/becoming/chapters/03-KNOWING.md:436

- Quote: every value there is taken by another selected law reading through `π` that agrees with the first on every reading
- Problem: "Another" is not guaranteed. For the first law's own value, the Lean's witness is pointwise the first law itself; only a different value gives a different law. The module docstring adds that sentence; the chapter does not.
- The Lean: twin_selected's witness is h := fun i => if π i = π x then v else g i; with v = g x and Lumped π g, h i = g i for every i.
- Replacement: "every value there is taken by a selected law reading through `π` that agrees with the first on every reading, one acting otherwise wherever the value differs from the first's"

**12. Low** — theories/becoming/chapters/03-KNOWING.md:436

- Quote: neither converse holds (`Learning.Cue.apart_with_content_alike`)
- Problem: The cited declaration is a concrete witness, not a general refutation: it states that two particular occasions differ while their contents agree. Each converse fails only once the maps are chosen: coupling and state the identity with the content as act, or the identity as coupling with the content as state. The record's laws[4] calls it a witness; the chapter presents it as a law.
- The Lean: apart_with_content_alike : ((true, true) : Occasion) ≠ (false, true) ∧ contentAct (true, true) = contentAct (false, true).
- Replacement: "neither converse holds, by a witness (`Learning.Cue.apart_with_content_alike`: two occasions differing only in the cue, with contents alike)"

**13. Low** — theories/becoming/chapters/03-KNOWING.md:436

- Quote: A formation tells occasions apart only through a lumping `π` of what couples into it
- Problem: This inverts the variable. π is the lumping of the occasions given by what couples in (π : I → K, from occasions to what couples in), not a lumping of what couples in. The Unread module states it the right way round.
- The Lean: free_lumped and twin_selected take {π : I → K} with I the occasions; Lumped π g := ∀ i i', π i = π i' → g i = g i'.
- Replacement: "A formation tells occasions apart only through what couples into it, a lumping `π` of the occasions, and its acts go alike across `π`."

**14. Low** — theories/becoming/chapters/03-KNOWING.md:438

- Quote: behaviour at an unread occasion can differ from that law's while every reading agrees exactly where no read occasion shares the occasion's lump
- Problem: The "can differ" half needs being in the lump decided and a second act value; with one act value nothing can differ. Later in the same paragraph, "a law acting alike everywhere misleads a reader whose readings miss where it is wrong" drops the module's "can". Whether such a law misleads depends on the selection, and no Lean states it either way.
- The Lean: twin_selected needs [∀ i, Decidable (π i = π x)] and a value v ≠ g x for h x ≠ g x. The only-where half is lumped_determines, with no condition. A reader misled is prose only (record does_not_show[3]).
- Replacement: "…can differ from that law's while every reading agrees (with being in its lump decided and a second act value) exactly where no read occasion shares the occasion's lump…" and "a law acting alike everywhere can mislead a reader whose readings miss where it is wrong"

**15. Low** — theories/becoming/chapters/07-SIGNIFICANCE.md:530

- Quote: where a pool's members read only the acts before them, its acts carry no more than what couples into those read first
- Problem: The premise is "from some member on", not "all members", and "those read first" has no referent. Read literally (every member reads only acts), the acts carry nothing and the sentence says nothing.
- The Lean: acts_alike_of_cascade (cascade : T.ReadsOnlyActsFrom k) (alike : T.AlikeBefore k w w') : ∀ n, T.acts w n = T.acts w' n.
- Replacement: "where from some member on every member reads only the acts before it, the pool's acts carry no more than what couples into the members before that one ([05 §8](05-COLLECTIVES.md#r-readers-reading-readers))"

**16. Low** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:60-61 (hypotheses[0]); :18 (laws[0])

- Quote: the twin needs being in the target's lump decided, and nothing about the read occasions.
- Problem: The twin does need a condition on the read occasions: none may be lumped with the target. What it does not need is a list or a decision of them. The freedom (free_lumped, laws[0]) needs the same decidability, and neither laws[0] nor this hypothesis says so.
- The Lean: free_lumped [inLump : ∀ i, Decidable (π i = π x)] (unseen : ∀ d, D d → π d ≠ π x). twin_selected has the same hypotheses, with R any predicate.
- Replacement: en: "Any types of occasions, values and lumps; the freedom and the twin need being in the target's lump decided, and no list or decision of the read occasions." zh: "时、值与归并之任一型；自由与孪生需「在所求之归并中」可判定，读处无需为列或可判定。"

**17. Low** — theories/becoming/results/records/what-choices-show-of-an-order.json:38-39 (laws[2]) and :202-203 (dependencies[0])

- Quote: the shown reach then being one («无环则及为序»).
- Problem: ShownOrder.lean never uses «无环则及为序». accorded_iff_noCycle builds the order from «无环» and «及之传递» directly, as 03 §11 and the Lean docstring say, yet the dependency lists «无环则及为序» as formally reused.
- The Lean: accorded_iff_noCycle's converse is fun none => ⟨«及» ch.Shown, none, fun _ _ _ => «及之传递», reach_accords⟩; grep finds no «无环则及为序» in ShownOrder.lean.
- Replacement: laws[2]: "…the shown reach then being one (by «及之传递»; the grammar states the same as «无环则及为序»)." dependencies detail: "The grammar's reach «及» with its transitivity «及之传递» and monotonicity «及之单调», and acyclicity «无环»."

**18. Low** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:118-119 (validation_scope) and :143-144 (dependencies[0])

- Quote: It reuses Learning.determines_lumped_iff, lumped_determines and Training.unselected_beyond_data
- Problem: Unread.lean's proofs use lumped_determines (in unseen_fixed) and Training.unselected_beyond_data (in twin_selected). determines_lumped_iff, lumped_world_right and lumped_right_iff are only cited in prose, yet the dependency lists the first two as formal reuse.
- The Lean: By grep: determines_lumped_iff appears only at Unread.lean:15 (docstring), lumped_right_iff only at :45 and lumped_world_right only at :46; lumped_determines is used at :160 and unselected_beyond_data at :107.
- Replacement: validation_scope: "It reuses lumped_determines and Training.unselected_beyond_data, and reads Learning.determines_lumped_iff as its exact form (cited, not used in a proof)." dependency detail: "Learning.Lumped, Free, Determines and lumped_determines; Training.Through, AgreeOn and unselected_beyond_data (determines_lumped_iff and lumped_right_iff cited)."

**19. Low** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:126-127 (correspondence)

- Quote: Read as evaluation and deployment it is the exact kernel of evaluation awareness and deceptive alignment
- Problem: "Exact kernel" claims more than the laws prove. They are an indistinguishability law and a twin law; the module and 03 §11 both say intention, anticipation and another's false belief are not stated. The field goes on to say "These are readings", but "exact" asserts a containment that the record then disclaims.
- The Lean: twin_selected and determines_lumped_iff concern selections through agreement on readings among lumped laws; no declaration has a predicate of intention, anticipation or belief.
- Replacement: en: "Read as evaluation and deployment, it is the limit any selection by readings meets in evaluation awareness and deceptive alignment (Hubinger and others 2019; Greenblatt and others 2024); intention and anticipation are not represented." zh: "读作评估与部署，为评估觉知与欺骗对齐中经读处之选所遇之限（…）；意图与预期未表。"

**20. Low** — theories/becoming/results/records/readers-reading-readers.json:88 (does_not_show[3])

- Quote: networks where members read only some earlier acts
- Problem: A Turns law can ignore any entries of the list of earlier acts, so members that read only some earlier acts are represented, and every law of the record holds for them. What is not developed is a separate graph of who reads whom. As written, the item says the record does not cover a case it does cover.
- The Lean: structure Turns has law : Nat → O → List A → A (any function of the whole list). Cascade.lean's module docstring: a law can ignore any entries of that list, so restricted access is represented, and no separate graph of who reads whom is developed.
- Replacement: en: "Weighted averaging (DeGroot) and its wisdom condition, a separate graph of who reads whom (a law ignoring entries of the list represents restricted reading, and the laws hold for it), and members in no well-founded order." zh: "加权平均（DeGroot）及其智之条件，谁读谁之另立之图（律不读列中某些项即表部分之读，诸律于此皆成），及无良基之序之成员。"

**21. Low** — theories/becoming/results/records/what-choices-show-of-an-order.json:96 (laws[8] zh); :163 (counterexamples[1])

- Quote: 搜取所列中居其余每一者之上之首者
- Problem: The zh drops "or none": the search returns none where no listed alternative stands above every other, as the en and the Lean have it. Separately, counterexamples[1] describes "alike on the menu met" but cites only same_search_after; that half is same_search_met.
- The Lean: search above menu := menu.find? (fun a => menu.all (fun b => same b a || above a b)) : Option Alt. same_search_met : search aboveFirst [first, second] = some first ∧ search aboveThird [first, second] = some first.
- Replacement: laws[8] zh: "搜取所列中居其余每一者之上之首者，无则无". counterexamples[1], en and zh: cite "(ChoiceOccasions.Untried.same_search_met, ChoiceOccasions.Untried.same_search_after)".

**22. Low** — _process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md:20580-20581 (§445 Evidence)

- Quote: the witnesses' tables are nested matches on one argument at a time, since a match on two with a wildcard compiles through propext.
- Problem: This is stated more generally than was observed. In the same receipt, Turns.Copying.turns (a def matching `n, before` with wildcard rows) and ChoiceOccasions.Untried.both_accord (matching `b, open_b` with `_`) both have empty axiom reports. Self-review item 1 states the narrower observation (one table).
- The Lean: verification.json axiom_dependencies: Becoming.Turns.Copying.turns: [] and Becoming.ChoiceOccasions.Untried.both_accord: [].
- Replacement: "…nested matches on one argument at a time, since one table written as a match on two arguments with a wildcard row compiled through propext."

**23. Low** — theories/becoming/chapters/03-KNOWING.md:428

- Quote: fixes of the formation only what its readings show. Two laws state that exactly
- Problem: The two laws state this exactly only for the widest classes they take: every strict order according with the choices, and every law reading through the lumping under a selection through the readings. A reader with a narrower class fixes at least as much, possibly more (the choices record's does_not_show[1]). Without that qualification, "exactly" overstates.
- The Lean: above_in_every_iff_reach quantifies over all strict according P; twin_selected quantifies over every selection through Training.AgreeOn R and over the class Lumped π.
- Replacement: "…fixes of the formation, with no further premise on the class it reads within, only what its readings show. Two laws state that exactly: …"

**Clean parts.**

- 08-METHOD.md:162 counts match the receipt 20261029T113907.548004Z exactly: 343 modules (3 foundation + 327 core + 13 instance/application), 16,677 theorems, of which 15,843 core, 22,762 declarations, 233 injEq lemmas on propext (the two new ones are ChoiceOccasions.mk.injEq and Turns.mk.injEq) and 75 superseded modules. Against the previous receipt 20261029T104256.342764Z the changes are +3 modules, +41 theorems (27+7+7), +62 declarations (39+10+13) and +2 injEq lemmas.
- Per-module counts in study §445 (and PLAN §4) match my count and the receipt: ShownOrder 27 theorems in 39 declarations, Unread 7 in 10, Cascade 7 in 13. Every source declaration's axiom report is empty.
- Every declaration name cited in 03 §11, 05 §8, study §445 and the three records exists with that spelling and namespace: Becoming.ChoiceOccasions and .Untried, Becoming.Learning and .Cue, Becoming.Turns and .Copying, Learning.determines_lumped_iff, Learning.lumped_right_iff, Training.unselected_beyond_data, WitnessRefinementRuns.copied_witnesses_same, «及之传递», «无环则及为序». Each record's laws cite each of its module's declarations exactly once, matching its references list.
- 03:431 matches the Lean except for the both_ways sentence: Shown, reach_within, accorded_iff_noCycle, above_in_every_iff_reach (conditioned by "Then"), top_in_every_iff_reach, reach_withPair_iff, noCycle_withPair_iff, weakly_forces_no_comparison and the Untried search witness, iff directions included. The standing line of the unread result (twin decided; read occasions listed, lumps decided, two act values) matches the Lean.
- 05:236 matches the Lean in its standing line and in its sentences on cascade_through, separates_at, Copying.reaches_first_only and the upper bound.
- Choices record: laws[0], [1], [3], [5], [6], [7] and [8] (en), hypotheses[0] and [1], does_not_show and validation_scope are exact. Unread record: laws[1], [2] and [4], hypotheses[1] and counterexamples[1] are exact. Readers record: laws[0]–[4], hypotheses, counterexamples and validation_scope are exact.
- The Chinese fields mirror the English, carrying the same omissions, except where noted (choices laws[8] zh drops "or none"; unread statement zh drops "a selected law").
- The 03 Open bullet (457) and the Round 2 item of study §445's Boundary list the same round-2 items as PLAN §4.4–4.5 and claim nothing beyond them.
- Study §445's Delta entries for RF1 and RF4, its Supplied premises, Standing and Boundary are exact against the Lean.

## The reader of the account's rules and RF's place (Opus, lens B)

**Verdict.** Lens B (the account's rules and RF's place in it). The texts are placed and linked correctly, and their chapter readings are mostly careful. Two rules are broken. First, 03 §11 and its record restate 03 §6's lumping laws as their own. Second, a record states a ¬¬P calibration that has no Lean. The record correspondences claim more than the chapter readings: "exact kernel", "exact form", "the same law", and the cascade condition is dropped. The two reading labels skip 08's register convention. The live texts never give the near-definitional standing. Once RF lands, the alignment dossier's scope box on main will be false, and this branch does not carry that box.

**1. High** — theories/becoming/chapters/03-KNOWING.md:436; theories/becoming/results/records/what-readings-fix-of-the-unread.json:13 (statement), :69-72 (does_not_show 'That fixed is right')

- Quote: An occasion at which it is not read has its act fixed by the read ones exactly where `π` ties it to a read occasion (`Learning.determines_lumped_iff`, read with the read occasions as the data).
- Problem: This paragraph and the record's headline restate two results whose home is 03 §6 (r-generalization-through-lumping). The first is its exact form (03:186: 'determined at x, and (two values, data listed, lumps compared decidedly) exactly there'). The second is its right-transfer law, restated again at 03:436 ('Fixed is not right ... (`Learning.lumped_right_iff`)') and in the record's does_not_show. Neither sentence links §6. The record's statement leads with a law that its own laws list does not hold: those laws are free_lumped, twin_selected, the chain and Cue. AGENTS.md says each result is stated once, in its home section, and a rename (data → read occasions) is not another result.
- The Lean: Learning.determines_lumped_iff [DecidableEq K] {data : List I} (two : y ≠ z) : Determines (Lumped π) (· ∈ data) x ↔ ∃ d, d ∈ data ∧ π d = π x, and Learning.lumped_right_iff (lumped, fits, at_d, same) are declarations of Learning.lean recorded in generalization-through-lumping. Unread.lean adds only free_lumped and twin_selected, and its docstring says the exact form is 'read here, not proved again'.
- Replacement: 03:436: '... Read with the read occasions as the data, [§6's law](#r-generalization-through-lumping) fixes an unread occasion's act exactly where π ties it to a read one, under §6's hypotheses, and fixed is not right there ([§6](#r-generalization-through-lumping)). What this law adds is the twin: where no read occasion is so tied, ... (`Learning.free_lumped`, `Learning.twin_selected`).' Drop the restated lumped_right_iff sentence. Record statement: 'Where a formation's lumping tells an unread occasion from every read one, every act law reading through it that a selection through the readings selects has a selected twin agreeing on every reading and taking any value there; where the lumping ties the occasion to a read one, generalization-through-lumping's law fixes the act.' Record does_not_show: 'That fixed is right (generalization-through-lumping, Learning.lumped_right_iff).'

**2. High** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:75

- Quote: The exact form for an arbitrary schedule: with one occasion and a constant lumping, read where P holds, fixing is ¬¬P.
- Problem: This is a mathematical claim (a calibration of the logic) with no Lean behind it, and as stated it lacks hypotheses. Going from fixing to ¬¬P needs two distinct act values. Going from ¬¬P back to fixing needs the values' equality decided (stable). AGENTS.md says every new proof claim needs Lean, and a calibration of the logic alone is a lemma of the item that needs it.
- The Lean: No declaration in Unread.lean or Learning.lean states it; only the plan §4.2 item 1 does, in prose. For I = Unit, constant π and D () := P: Determines (Lumped π) D () yields ¬¬P given y ≠ z (take the constant functions y and z), and the converse needs DecidableEq V.
- Replacement: Either add a lemma to Unread, e.g. `Learning.determines_one_iff [DecidableEq V] {y z : V} (two : y ≠ z) : Determines (Lumped (fun _ : Unit => ())) (fun _ => P) () ↔ ¬¬P`, and cite it; or write: 'The exact form for an arbitrary schedule is not shown (for one occasion and a constant lumping, read where P holds, it would be ¬¬P given two values with decided equality: a hand argument, not in Lean).'

**3. Medium** — theories/becoming/chapters/03-KNOWING.md:433 and :438

- Quote: **Reading** [AI reading]. Read with the laws of training
- Problem: 08 §2 (08-METHOD.md:66) fixes the reading label as [AI reading, Dn], or '[AI reading, new]' for a reading the register has not yet numbered, as at 07:326 and 07:331. These two are the only readings in the chapters that carry neither form. The register (DELEGATED-CHOICES.md) has no RF entry.
- The Lean: Not a Lean matter. The readings rest on Untried.same_search_met/after and on twin_selected and the chain, and they change no theorem.
- Replacement: '**Reading** [AI reading, new].' at both places, until the register numbers them.

**4. Medium** — theories/becoming/chapters/03-KNOWING.md:428

- Quote: A reader of what a formation does, whether a training, a helper, an overseer or a court, fixes of the formation only what its readings show. Two laws state that exactly
- Problem: Unlabelled prose applies the laws to trainings, helpers, overseers and courts. These are readings, and they bring social words in outside a reading. The sentence also says the two laws state 'exactly' what any reader fixes, dropping their premises: a chooser by strict dominance in one strict order, act laws going alike across π, and a selection through agreement on the readings. It starts from two separate relata, reader and read, without the relational basis AGENTS.md asks for; 07 §6 opens with that basis. ShownOrder has no reader at all.
- The Lean: ShownOrder states laws of ChoiceOccasions (menu, pick), and each positive law quantifies over relations P with ch.Accords P (strict dominance). Unread's twin_selected needs Lumped π g and Training.Through (Training.AgreeOn R) select. No reader or social role is represented.
- Replacement: 'A selection reading a formation's acts is itself within the one unfolding: it goes through what of those acts couples into it ([07 §6](07-SIGNIFICANCE.md#alignment-without-premise)) and fixes of the formation only what they tell apart. Two laws state this for two cases, each under its premises: what strict choices show of a strict order they could come from, and what readings fix, for acts reading through a lumping, where the formation is not read. Reading such a selection as a training, a helper, an overseer or a court is a reading (below).'

**5. Medium** — theories/becoming/chapters/03-KNOWING.md:436 (against :443)

- Quote: A formation tells occasions apart only through a lumping `π` of what couples into it, and its acts go alike across `π`.
- Problem: This is stated as a fact about formations, but it is the law's hypothesis. The chapter's own does-not-show list (03:443) includes 'That an actual selector or learner selects through just the couplings stated', and the Lean takes the lumping as supplied.
- The Lean: free_lumped and twin_selected take π : I → K as given and (lumped : Lumped π g) as a hypothesis. Cue exercises two choices of π (the identity in seen_twin, the content in unseen_fixed).
- Replacement: 'Let a formation's acts go alike across a lumping `π` of what couples into it (which lumping an actual formation has is not shown).'

**6. Medium** — theories/becoming/results/records/what-choices-show-of-an-order.json:211 (related), :183 (correspondence)

- Quote: Read with training: a training reading a trained law's choices fixes of the order it carries exactly the shown reach.
- Problem: The related entry drops the premise that the chapter's reading keeps ('imposes no further restriction on the orders the law could carry'), and it contradicts the record's own does_not_show (:132: 'a narrower class holding an according order fixes at least as much'). The correspondence's '(inner alignment, goal misgeneralization in exact form)' says more than 03:433 ('a possibility located exactly, not a failure shown') and has no citation. That matters here because the repository also uses 'inner alignment' in a non-field sense (theories/alignment-selection-on-cognition/README.md, Terminology). It also gives goal misgeneralization an exact form, while 08 §8 (08-METHOD.md:460) places its formal kernel at what-training-installs. Plan §13 lists both the narrowing of the inner-alignment reading and 'the positive comparisons shared, not what the choices fix' as taken.
- The Lean: above_in_every_iff_reach (none : «无环» ch.Shown) quantifies over every irreflexive transitive P with ch.Accords P. No class of orders, training or installation is represented. Untried.same_search_met/after are rfl evaluations on two menus.
- Replacement: Related: 'Read with training: where a training reads only a trained law's choices and restricts the orders it could carry no further, the comparisons every according order shares are the shown reach; a narrower class can fix more.' Correspondence: 'Read with training, where the training restricts the orders no further, comparisons beyond the shown reach stay open: goal misgeneralization (Langosco and others 2022; Shah and others 2022) located exactly as a possibility, not shown, and inner alignment in the field's sense (Hubinger and others 2019) for searches by an order; the on-course kernel is what-training-installs' (08 §8).'

**7. Medium** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:126 (correspondence), :134 (alias); theories/becoming/chapters/07-SIGNIFICANCE.md:645

- Quote: Read as evaluation and deployment it is the exact kernel of evaluation awareness and deceptive alignment (Hubinger and others 2019; Greenblatt and others 2024)
- Problem: 'Exact kernel' is a containment. It goes against the record's own closing ('These are readings, not containments') and against 03:438, which states no intention, anticipation or false belief. 07's objections row (07:645) still says the laws say nothing 'of deception', and the alias 'evaluation awareness, the kernel' repeats the claim. The cited works are on deceptive alignment and alignment faking, not on evaluation-awareness measurements, and 'the measurements of detection without behavioural change' are uncited. On my knowledge (fairly sure): Hubinger and others 2019 define deceptive alignment as instrumental, training-aware behaviour, and Greenblatt and others 2024 measure a compliance gap between implied-training and implied-unmonitored conditions. That gap matches the twin's possibility, not a kernel.
- The Lean: twin_selected and Cue.seen_twin give a selected twin that differs at an unread occasion where no read occasion shares its lump; lumped_determines gives the other side. No intention, belief, anticipation or incentive is represented (Unread.lean docstring: 'need further structure and are not stated').
- Replacement: 'Read as evaluation and deployment, it locates where behaviour can differ when not read while every reading agrees: only where the formation's lumping tells the occasion from every read one, a necessary condition of the behaviour deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024); their intention, anticipation and incentive are not represented. Measurements finding detection without behavioural change [cite them] read as the chain's failed converse.' Alias: 'behaviour where not read'. 07:645: add 'beyond where behaviour can differ when not read ([03 §11](03-KNOWING.md#r-what-readings-fix-of-the-unread))'.

**8. Medium** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:152

- Quote: Off its courses a law is installed only where the representation lumps a history with a course; read with read occasions as the data, the same law.
- Problem: It is not the same law. In what-training-installs the data are the courses the candidate itself generates, which is why the World twin needs laws reading what has stood and must keep those courses. That record's own related entry to generalization-through-lumping says so ('here the data are the courses the candidate itself generates, and the same boundary falls on them'). Here the read occasions are fixed in advance, as data are in generalization-through-lumping, and no instance theorem connects the two.
- The Lean: Training.free_where_unlumped needs na : ∀ e, (law e).Nonanticipating, naA : a.Nonanticipating, ReadsThrough ρ part a, a decided lumping and m off every course, and it concludes SameCourses. twin_selected has R fixed and needs only [∀ i, Decidable (π i = π x)], unseen, through, lumped and chosen.
- Replacement: 'Off its courses a law is installed only where the representation lumps a history with a course. Here the read occasions are fixed in advance, as data are in generalization-through-lumping; there the data are the courses the candidate itself generates, and the twin needs laws reading what has stood to keep them (Training.free_where_unlumped): the same boundary, with no instance theorem.'

**9. Medium** — theories/becoming/results/records/readers-reading-readers.json:143; theories/becoming/chapters/07-SIGNIFICANCE.md:530

- Quote: A pool reaches no further than the union of its members' closures; where members read one another's acts, only what couples into those read first.
- Problem: Members who read one another's acts while still reading their own couplings carry every coupling. The bound needs that, from some member on, every member (that one included) reads only the acts before it. The 07 pointer has the same gap: 'where a pool's members read only the acts before them, its acts carry no more than what couples into those read first'. Read of all members, that makes the acts constant and leaves no one 'read first'.
- The Lean: Turns.ReadsOnlyActsFrom k : ∀ n, k ≤ n → ∀ o o' before, T.law n o before = T.law n o' before. acts_alike_of_cascade and cascade_through assume it and conclude for worlds with T.AlikeBefore k (∀ j < k, coupling j w = coupling j w').
- Replacement: Related: '...; where, from some member on, every member reads only the acts before it, a selection through the acts reaches only what couples into the members before that one.' 07:530: '...; what a pool's acts carry where, from some member on, every member reads only the acts before it (no more than what couples into the members before that one) is [05 §8](05-COLLECTIVES.md#r-readers-reading-readers)'s.'

**10. Medium** — theories/becoming/chapters/03-KNOWING.md:431, :436; theories/becoming/chapters/05-COLLECTIVES.md:236; theories/becoming/chapters/08-METHOD.md:457-480; study BECOMING-RENEWAL-READING.md:20582

- Quote: **Theorem** (root: any carrier of alternatives and any occasions; no premise).
- Problem: Study §445 gives the standing: 'near-definitional laws and witnesses; RF1 the order form of rationalizing strict choices (close to Richter 1966, not Afriat), RF2 indistinguishability, RF4 the deterministic form of a cascade'. No live text says so. The home brackets omit it, though 03:207 shows the house form '(...; near-definitional)'. 08 §8's 'Known results beyond the table', where landings record their prior art and verdict, has no RF bullet.
- The Lean: The laws are short. state_apart_of_acts_apart and coupling_apart_of_state_apart are congrArg contrapositives. twin_selected is Training.unselected_beyond_data applied to free_lumped. separates_at is two congrArg steps. above_in_every_iff_reach holds because the shown reach itself accords and is transitive (reach_accords, «及之传递»).
- Replacement: Brackets: '(root: ...; no premise; a known result restated)', '(any type; ...; near-definitional)', '(any type: ...; near-definitional)'. 08 §8 bullet: 'What choices show of an order (03 §11) restates rationalizing strict choices by a strict partial order, close to Richter (1966), not Afriat (1967); what readings fix of the unread (03 §11) is indistinguishability; readers reading readers (05 §8) is the deterministic form of an information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992). Each law is near-definitional, a known result restated or a witness; what they add is their place in one account.'

**11. Medium** — theories/becoming/review/ALIGNMENT.md:28 on main (aa098f254, not an ancestor of rf-landing HEAD); study BECOMING-RENEWAL-READING.md:20596

- Quote: Work on inner alignment, mesa-optimization, goal misgeneralization, deception and assistance games began on 29 October 2026 (board item RF, formations that read); no law of it has landed
- Problem: AJ5's scope box landed on main after RF's last merge, so this branch neither carries nor updates it. Once RF lands, this sentence is false. The box's bullets ('says nothing of ... deception and deceptive alignment; goal misgeneralization') would then sit beside records that read RF1 and RF2 as goal misgeneralization and deceptive alignment. Study §445 lists the box under Output → input as if it were handled.
- The Lean: Not a Lean matter. The three modules are in core receipt 20261029T113907.548004Z.
- Replacement: At the merge with main: 'Round 1 of that work landed on 29 October 2026 (board item RF): what choices show of an order and what readings fix of the unread ([03 §11](../chapters/03-KNOWING.md#what-the-acts-show)), and readers reading readers ([05 §8](../chapters/05-COLLECTIVES.md#r-readers-reading-readers)). They locate, in readings, where goal misgeneralization and behaviour differing when not read are possible; installation, intention and incentive are not represented, and this dossier quotes none of them yet.' Study: 'AJ5's scope box, updated at RF's merge with main'.

**12. Medium** — theories/becoming/chapters/03-KNOWING.md:433; theories/becoming/results/records/what-choices-show-of-an-order.json:183, :317

- Quote: which is inverse reinforcement learning's unidentifiability in order form / (Ng and Russell 2000; Armstrong and Mindermann 2018 for choices among equals)
- Problem: (Fairly sure.) IRL's unidentifiability has parts this does not represent. Ng and Russell 2000 show that many rewards, R = 0 among them, make a given policy optimal. Armstrong and Mindermann 2018 show that a policy fixes planner and reward together only under normative assumptions about the planner. ShownOrder fixes the planner by premise (strict dominance). It therefore matches the comparisons behaviour never meets and, for maximal choices, the degenerate reward. It is not the whole unidentifiability, and Armstrong and Mindermann's result concerns irrational planners, not 'choices among equals'. The record's 'what inverse reinforcement learning can fix' also understates IRL, which fixes more under premises. Plan §13 says 'maximal choices, not choices among equals' was taken, yet the correspondence and the history line (:317) keep the old phrase.
- The Lean: Accords (strict dominance) is the premise of every positive law. weakly_forces_no_comparison shows the empty relation accords weakly with every choice. above_in_some_of_unreached and both_ways_of_unreached need «无环» Shown, x ≠ y and non-reach. No reward, planner or rationality model is represented.
- Replacement: 03:433: '... needs information or premises beyond the strict choices: under strict choice, the order form of the part of inverse reinforcement learning's unidentifiability that concerns what behaviour never meets (Ng and Russell 2000); that a policy fixes planner and reward together only under normative assumptions (Armstrong and Mindermann 2018) lies outside, since accordance fixes the planner.' Record: 'read with a helper, what strict choices alone fix of a principal's order; maximal choices force no comparison, the order form of the degenerate reward (Ng and Russell 2000)'. History: 'maximal choices'.

**13. Medium** — theories/becoming/chapters/03-KNOWING.md:436; theories/becoming/results/records/what-readings-fix-of-the-unread.json:51

- Quote: neither converse holds (`Learning.Cue.apart_with_content_alike`)
- Problem: A reading is presented as a theorem. The declaration states only that two occasions differ while their contents agree. The converse failures need the maps instantiated (state = the occasion and act = its content; coupling = the occasion and state = its content), and no declaration states that; the plan calls it 'one proposition read two ways'. The record's law line also uses the reading words 'detected' and 'detectable' as if they were predicates.
- The Lean: Cue.apart_with_content_alike : ((true, true) : Occasion) ≠ (false, true) ∧ contentAct (true, true) = contentAct (false, true). 'Detected' and 'detectable' occur only in its docstring.
- Replacement: 03: 'neither converse holds: two occasions that differ while their contents agree (`Learning.Cue.apart_with_content_alike`) give, with the state the occasion and the act its content, states apart and acts alike, and with the coupling the occasion and the state its content, couplings apart and states alike.' Record law 5: the same wording, with 'detected, not acted on; detectable, not detected' moved to the correspondence as a reading.

**14. Low** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:36-46 (law 4)

- Quote: Witness: occasions with a cue and a content, read where the cue is up, the content act answering with the content
- Problem: This is 03 §6's Shift witness with the position renamed the cue: inputs Bool × Bool, and the lumping reading the content determines the untried input while the class of every function does not. The record neither cites Shift nor says what Cue adds, which is the selected twin under a selection through the readings.
- The Lean: Learning.Shift (Learning.lean:1068) has Shift.determines := lumped_determines for (·.2) and Shift.every_nothing. Cue.unseen_fixed is lumped_determines for (·.2) with D := read, and Cue.seen_twin is twin_selected with π := id.
- Replacement: Add to law 4: 'the pattern of generalization-through-lumping's Shift, the position read as the cue, with the twin under a selection through the readings added (Learning.Shift.determines)'.

**15. Low** — theories/becoming/results/records/what-readings-fix-of-the-unread.json:14, :41, :91, :100

- Quote: 读处定一成形于未读处之行
- Problem: 08 §9 (08-METHOD.md:554) fixes 形成 as the Chinese for 'a formation'. 成形 is not used as that noun anywhere else in the records; elsewhere it means 'takes shape'.
- The Lean: Not a Lean matter.
- Replacement: Use 形成 in all four places, e.g. '读处定一形成于未读处之行'.

**16. Low** — theories/becoming/chapters/03-KNOWING.md:9; theories/becoming/THE-THEORY-OF-BECOMING.md §3 (lines 80-98) and §5

- Quote: testing within the net and 文 are on the root's grammar
- Problem: ShownOrder is now also a root law in 03, so the Bases paragraph is incomplete. The overview, which earlier landings updated (WRT2, UE15), has no sentence for 03 §11 or for 05 §8's cascade.
- The Lean: ShownOrder imports only Becoming.Grammar and states its laws on «际», «及» and «无环».
- Replacement: 03:9: 'testing within the net, 文 and what choices show of an order (§11) are on the root's grammar'. Overview §3, one sentence: 'What a selection reading a formation's acts can fix is what they show: the positive comparisons every strict order according with strict choices shares are exactly the reach of what they show, and where a formation's lumping tells an unread occasion from every read one the readings fix nothing there ([§11](chapters/03-KNOWING.md#what-the-acts-show)).' A matching sentence in §5 for the cascade.

**17. Low** — theories/becoming/results/records/what-choices-show-of-an-order.json:183

- Quote: is close to Richter's theorem (1966) in order form
- Problem: (Confident.) Richter's theorem is already stated for preference relations, so 'in order form' marks no difference. What differs is completeness: Richter rationalizes by a complete transitive relation, which in general needs Szpilrajn's extension and so a choice principle, while ShownOrder stops at a strict partial order. 03:433's wording ('close to Richter's theorem (1966); it is not Afriat's') is accurate.
- The Lean: accorded_iff_noCycle: some irreflexive transitive P accords ↔ «无环» Shown. No totality is involved, and the axiom report is empty.
- Replacement: 'is close to Richter's theorem (1966) without completeness: a strict partial order, not a complete preference, so no extension principle (Szpilrajn 1930) is needed; it is not Afriat's theorem (1967), which concerns expenditure data and utility.'

**18. Low** — theories/becoming/results/records/what-choices-show-of-an-order.json related (:204-222); theories/becoming/chapters/03-KNOWING.md:431

- Quote: `x` stands above `y` in every one exactly where `x` reaches `y` (`ChoiceOccasions.above_in_every_iff_reach`
- Problem: 01 §1's the-present-on-causal-set-growth states the linear-extension form of the same law on finite causal sets: born before on every course exactly where it precedes, and on some course exactly where the two differ and the other does not precede it. 08 §8 (:479) gives its prior art as Szpilrajn and Dushnik–Miller. The record relates to neither, so the either-way law now appears twice on the root with no connection.
- The Lean: Presence.prec_iff_every (precedence decided) and Presence.before_some_iff (weakly decided) are on natural labellings. ChoiceOccasions.above_in_every_iff_reach and above_in_some_of_unreached hold on any carrier, for strict partial orders, with nothing decided.
- Replacement: Add a related entry: the-present-on-causal-set-growth, 'the linear-extension form on finite causal sets with precedence decided: what every course keeps is precedence, unrelated elements born either way; here strict partial orders on any carrier, with nothing decided.'

**19. Low** — theories/becoming/results/records/readers-reading-readers.json:88

- Quote: networks where members read only some earlier acts
- Problem: The record lists these as out of scope, but Cascade.lean:13-14 says 'A law can ignore any entries of that list, so restricted access to earlier acts is represented', and every cascade law holds for such laws. What is not developed is a bound that depends on who reads whom.
- The Lean: Turns.law : Nat → O → List A → A, and acts_alike_of_cascade holds for every law, including laws that ignore entries.
- Replacement: 'a bound depending on who reads whom (laws ignoring some earlier acts are covered, with the bound of the members before k)'.

**20. Low** — theories/becoming/results/records/what-choices-show-of-an-order.json:132; study BECOMING-RENEWAL-READING.md:20589

- Quote: a narrower class holding an according order fixes at least as much
- Problem: A positive claim with no Lean sits inside a does_not_show item. Plan §4.1 item 6 calls it quantifier restriction. It is true, but AGENTS.md asks for Lean or for the argument to be marked as a hand argument.
- The Lean: No declaration states it.
- Replacement: '(a narrower class holding an according order fixes at least as much, by restricting the quantifier; not stated in Lean)', or a one-line Lean lemma.

**21. Low** — theories/becoming/results/records/readers-reading-readers.json:88; theories/becoming/chapters/05-COLLECTIVES.md:236; theories/becoming/chapters/03-KNOWING.md:438; theories/becoming/results/records/what-readings-fix-of-the-unread.json:126

- Quote: Weighted averaging (DeGroot) and its wisdom condition
- Problem: (Confident.) The wisdom condition is Golub and Jackson's (2010); Cascade.lean names them but the record does not. 05:236's 'the probabilistic model' is unnamed; it is Bikhchandani, Hirshleifer and Welch 1992. The ELK reading (03:438, record :126) has no citation, while reading-anothers-couplings-is-pooling cites Christiano, Cotra and Xu 2021 for ELK. 'The probabilistic form is the data-processing inequality' fits the chain of acts, states and couplings, not the twin.
- The Lean: Cascade.lean docstring: '(DeGroot) and its wisdom condition (Golub and Jackson)'. The chain is state_apart_of_acts_apart and coupling_apart_of_state_apart.
- Replacement: 'Weighted averaging (DeGroot 1974) and its wisdom condition (Golub and Jackson 2010)'. 05:236: 'which in the probabilistic model of Bikhchandani, Hirshleifer and Welch (1992) is when ...'. Add '(Christiano, Cotra and Xu 2021)' after 'eliciting latent knowledge'. 'The probabilistic form of the chain is the data-processing inequality.'

**22. Low** — theories/becoming/chapters/03-KNOWING.md:457

- Quote: a formation's reading kept by its own update, with the good regulator's adequacy
- Problem: The adequacy is already stated in the core (03:348, r-when-to-inquire-and-when-to-respond, through GuardHorizon.uniform_policy_iff_fiber_feasible). What is open is composing it with a reading kept by the formation's own update. As written, the adequacy itself reads as open.
- The Lean: GuardHorizon.uniform_policy_iff_fiber_feasible has an empty axiom report, given a choice over the readings.
- Replacement: 'a formation's reading kept by its own update, composed with the good regulator's adequacy ([§9](#r-when-to-inquire-and-when-to-respond));'

**Clean parts.**

- Every link and anchor in the texts resolves where it says: 03 §11's anchors (what-the-acts-show, r-what-choices-show-of-an-order, r-what-readings-fix-of-the-unread); the Open bullet's §11 link; 07 §6's r-what-training-installs; 07's pointer to 03 §11 and to 05 §8's r-readers-reading-readers; the three record pages; 08's receipt link; and the study's plan, plan §13 and REVIEW-LEAN links. regions.json homes the three records in knowing, knowing and collective, with bases grammar, general and general.
- The bases are labelled correctly: ShownOrder's 'root' matches 08's base table (proved on Becoming.Grammar for every carrier), and Unread and Cascade are 'any type'. The ShownOrder record's formal-reuse dependency on continuation-relative-to-a-class (the grammar's «及», «及之传递», «及之单调», «无环») is correct.
- Every reading in the texts carries an AI label. None uses Ren's words as warrant, no person or AI is named in live text, no ethical premise is introduced, and the records carry the no-ethical-premise and no-evaluation boundaries.
- 03:433's revealed-preference placement is accurate (confident): Richter (1966, Econometrica) rationalizes choice by preference relations; Afriat (1967, International Economic Review) builds utility from finite price–quantity data.
- The cascade placement in readers-reading-readers is accurate (confident): Bikhchandani, Hirshleifer and Welch 1992 and Banerjee 1992; the deterministic form once the act stops reading the private signal; a cascade can be accurate; copying is Condorcet's dependence failure. 05:236 keeps its bound honest ('bounds what the acts carry; it is not the pool's exact reach'), and it is consistent with what-pooled-coupling-reaches and what-a-pools-acts-respond-to, since a selection through the acts is one through the pooled coupling.
- Greenblatt and others 2024 (alignment faking: a compliance gap between implied-training and implied-unmonitored conditions) fits the twin's possibility as a reading (confident). The ELK identification limit in 03:438 is a fair reading: reporters that agree on all supervised data are selected alike.
- 03 §11's first reading is honest about standing: 'goal misgeneralization in this sense is a possibility located exactly, not a failure shown'.
- The Open bullet (03:457) and study §445's round-2 Boundary list the same five items, and neither claims them as shown.
- 08's counts paragraph (08-METHOD.md:162): the receipt link resolves, and 3 + 327 + 13 = 343 modules, 75 superseded modules, 233 generated injEq dependencies and Lean 4.29.1 match the receipt. The per-module counts (ShownOrder 27/39, Unread 7/10, Cascade 7/13) match the files.

## What was taken

Readers: **A** the cross-model reader (GPT astra), **E** the exactness reader, **R** the reader of the account's rules and RF's place (both Opus); numbers are each reader's own. Fifty-nine findings, many shared, gathered into the issues below. Every one was checked against the Lean before it was taken. All were taken; where a reader's wording was adapted, the row says how.

| # | Issue (readers) | What was done |
|---|---|---|
| 1 | The ¬¬P remark for a schedule not given as a list had no Lean (A2, E1, R2) | proved: `Learning.determines_iff_not_not` (one occasion, a constant lumping, two act values, read where `P` holds: fixed exactly where `¬¬P`), a law of what-readings-fix-of-the-unread; the does-not-show item removed; the plan's §4.2 item 1 points to it |
| 2 | Reach with one pair added: the record's law dropped the cases of being at the pair's ends (A1, E9) | the law says "from the pair's first member or what reaches it, to its second member or what it reaches", as `reach_withPair_iff` does; the module header likewise |
| 3 | 03 §11 restated §6's exact form and right-transfer law, and the record's headline led with them (A3, R1, E2) | 03 §11 points to §6 (r-generalization-through-lumping) for both and states what it adds, the twin; the record's statement is the twin, its hypotheses cite §6's law as read, not proved again |
| 4 | Readings inside laws and correspondences without the AI label: "detected", "detectable" (A4, R13) | the cue law states states apart with acts alike, couplings apart with states alike; "detected" and "detectable" moved to the correspondence; every correspondence's interpretive part begins "AI reading" |
| 5 | Order statements without their conditions: "both ways" (A5, E6), the headline's exactness (A5, E3), hypotheses (E3) | 03 §11 cites `above_in_some_of_unreached` with `y` not reaching `x`, and "both ways" where neither reaches the other; the headline conditions the exactness on no cycle; the hypothesis says what each part needs |
| 6 | Being right needs the law to fit the world on the read occasions (A6, E7) | the record's does-not-show item states the fit; 03 §11 points to §6 |
| 7 | The cascade premise: member `k` included, every list of earlier acts, "those read first" with no referent (A7, E4, E5, E15, R9) | the record's statement, laws, hypothesis and related entry, 05 §8, 07's pointer, the package README rows, the root's bullet, the regions note and the history line say "where every member from member `k` on, `k` included, acts alike whatever its own coupling, on every list of earlier acts" and "the members before `k`" |
| 8 | The cue witness needs the selection to select the content act (A8, E2) | the law and the counterexample say "for every selection through agreement on the readings that selects the content act" |
| 9 | "A training reading a trained law's choices fixes exactly the shown reach" dropped its premises (A9, E8, R6) | the related entry is an AI reading conditioned on strict choice by a strict order and no further restriction, with "a narrower class can fix more" |
| 10 | "Exact form" and "exact kernel" claimed containments (A10, E19, R7) | the order record: goal misgeneralization located as a possibility, not shown (Langosco and others 2022; Shah and others 2022), inner alignment for searches by an order (Hubinger and others 2019), the on-course kernel what-training-installs'; the unread record: a necessary condition of what deceptive alignment and alignment faking describe, intention, anticipation and incentive not represented; the alias "evaluation awareness, the kernel" became "behaviour where not read" |
| 11 | Armstrong and Mindermann cited for choices among equals; IRL's unidentifiability said whole (A11, R12) | Ng and Russell 2000 for the degenerate reward (maximal choices force no comparison); Armstrong and Mindermann 2018 on planner and reward fixed together only under assumptions on the planner, outside since accordance fixes the planner; 03 §11 says which part of the unidentifiability this is; "a principal" became "what it assists" |
| 12 | Restricted reading is representable; what is absent is a bound depending on who reads whom (A12, E20, R19) | the does-not-show item says so |
| 13 | The Chinese search law omitted "or none" (A13, E21) | 无则无 added |
| 14 | "At each occasion something is open" (A14) | "what is open is any predicate and one alternative is chosen, which the general laws do not require to be open", in 03 §11 and the module header |
| 15 | "Another selected law": the twin may be the first law itself (E11) | "a selected law … one acting otherwise wherever the value differs from the first's", in 03 §11 and the module header |
| 16 | "Neither converse holds" cites a witness as if a law (E12, R13) | 03 §11 states the two instantiations; the README rows and the root's bullet say "by a witness" |
| 17 | `π` is a lumping of the occasions, and a hypothesis, not a fact about formations (E13, R5) | "Let a formation's acts go alike across a lumping `π` of the occasions by what couples into it (which lumping an actual formation has is not shown)" |
| 18 | The second reading needs the lump decided and a second value; "misleads" should be "can mislead" (E14) | both taken |
| 19 | "Nothing about the read occasions": the twin needs none of them lumped with the target (E16) | the hypothesis says the freedom and the twin need the lump decided and no read occasion lumped with it, and no list or decision of the read occasions |
| 20 | `«无环则及为序»` is not used by ShownOrder, yet listed as reused (E17) | the law says "by «及之传递»; the grammar states the same as «无环则及为序»"; the dependency lists «及», «及之传递», «及之单调» and «无环» |
| 21 | Unread uses `lumped_determines` and `unselected_beyond_data`; `determines_lumped_iff` is only cited (E18) | the validation scope and the dependency say which are used and which cited |
| 22 | The counterexample of the search cited only `same_search_after` (E21) | `same_search_met` cited too |
| 23 | The study's propext lesson was stated more generally than observed (E22) | narrowed to the one table; the self-review adds that other two-argument matches with a wildcard row have empty reports |
| 24 | 03 §11's opening applied the laws to social roles outside a reading, with "exactly" unqualified and no relational basis (R4, E23) | the opening starts from the selection within the one unfolding (07 §6), states the two laws' premises and the widest class, and names trainings, helpers, overseers and courts as readings |
| 25 | Reading labels without the register's form (R3) | `[AI reading, new]` |
| 26 | The near-definitional standing was in the study only (R10) | the three theorems' brackets say "near-definitional"; 08 §8's known results has a bullet for the three laws |
| 27 | AJ5's scope box on main says no law of RF has landed (R11) | updated at RF's merge with main; the study's output line says so |
| 28 | The related entry to what-training-installs called it "the same law" (R8) | it says the read occasions are fixed in advance here and are the candidate's own courses there: the same boundary, with no instance theorem |
| 29 | The cue witness is Shift's pattern (R14) | the law names `Learning.Shift`'s pattern |
| 30 | 成形 for "a formation" (R15) | 形成, as 08's Chinese terms have it |
| 31 | 03's bases and the overview lacked RF (R16) | 03's bases name what choices show as on the root's grammar; the overview's §3 and §5 have one paragraph each |
| 32 | Richter "in order form" marks no difference; completeness does (R17) | "close to Richter's theorem (1966) without completeness … so no extension principle (Szpilrajn 1930) is needed" |
| 33 | No relation to the present on causal-set growth, the linear-extension form of the same law (R18) | a related entry to the-present-on-causal-set-growth |
| 34 | "A narrower class fixes at least as much" had no Lean (R20) | proved: `ChoiceOccasions.above_in_class_of_every`, a law of what-choices-show-of-an-order, cited in 03 §11, the module header and the README rows |
| 35 | Citations: DeGroot 1974, Golub and Jackson 2010, the probabilistic model of Bikhchandani, Hirshleifer and Welch, eliciting latent knowledge, and the data-processing inequality as the chain's form (R21) | all added |
| 36 | The good regulator's adequacy is §9's; what is open is the composition (R22) | the Open bullet says "composed with the good regulator's adequacy (§9)" |
| 37 | 07's open row said the laws say nothing of deception (R7) | "nor anything of deception beyond where behaviour can differ when not read (03 §11)" |
| 38 | The study's and the README's twin wording dropped the selection's premise (E10) | both state it |

The two laws added (rows 1 and 34) were built in scratch with empty axiom reports and checked by the core receipt of this landing; they were not re-read by a second reader.

## The re-read

After the fixes, the cross-model reader re-read them in its own session, read-only, against the Lean (the brief is the last section of [BRIEF.md](BRIEF.md)'s cold read, continued with the list of what changed). Its return, verbatim (links made repository-relative, line suffixes dropped):

**Verdict: Thirteen findings were taken correctly; finding 2 is partly resolved. Two issues remain in the revised wording. The two new declarations match the passed receipt and have empty recorded axiom reports.**

1. **Taken correctly:** The added-pair formula now includes both endpoint equality cases, in English and Chinese.
2. **Partly:** `determines_iff_not_not` proves the original singleton/Boolean claim, but several summaries generalize it to arbitrary unlisted schedules; see 15.
3. **Taken correctly:** §6 is explicitly identified as the home of the determination and correctness criteria; the new record leads with the twin.
4. **Taken correctly:** Detection interpretations moved out of the laws, and the correspondence interpretations carry AI labels.
5. **Taken correctly:** Acyclicity, distinctness and the two directions of non-reach are distinguished correctly.
6. **Taken correctly:** The record now states the fitting premise; the chapter refers correctness to §6.
7. **Taken correctly:** The cascade premise includes member `k`, every earlier-act list, and the prefix strictly before `k`.
8. **Taken correctly:** The cue witness requires selection of the content act; the Chinese summary retains an already-selected law.
9. **Taken correctly:** The training correspondence states strict accordance, no further restriction, and the limit concerning actual installation.
10. **Taken correctly:** “Exact form” and “exact kernel” were replaced with qualified readings and explicit unrepresented features.
11. **Taken correctly:** Armstrong–Mindermann now concerns planner–reward ambiguity, rather than choices among equals; its new explanatory clause has a separate issue below.
12. **Taken correctly:** The boundary now concerns bounds depending on who reads whom, while acknowledging that ignored earlier acts are representable.
13. **Taken correctly:** The Chinese search description includes “无则无”.
14. **Taken correctly:** The chapter and module header no longer require a nonempty menu or an open picked alternative.

15. **High — A singleton witness is presented as a general unlisted-schedule law.**

    Locations: [03-KNOWING.md:436](../../../../../../../theories/becoming/chapters/03-KNOWING.md), [study_rf.txt:22](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/study_rf.txt), [Becoming.lean:2115](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean), and the Unread rows in [README.md:192](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md) and [README.zh.md:135](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md). The same general framing occurs in the module header and record script.

    Quote: “for a schedule not given as a list, fixing holds up to a double negation”.

    **Against the Lean:** `Becoming.Learning.determines_iff_not_not` quantifies only over `P : Prop`. Its occasion type is `Unit`, act type is `Bool`, lumping is constant, and read predicate is `fun _ => P`. It proves:
    ```
    Determines (Lumped (V := Bool) (fun _ : Unit => ()))
      (fun _ => P) () ↔ ¬¬P
    ```
    It does not establish a double-negation characterization for general occasion types, lumpings, act types or read predicates. The record’s detailed law names the singleton setting, but its introductory clause and history summary still suggest the broader result.

    **Replacement:** “A singleton example shows the double-negation boundary: with Boolean acts, constant lumping and the sole occasion read exactly when `P` holds, its act is determined exactly when `¬¬P` (`Learning.determines_iff_not_not`).”

    Chinese: “单例显示二重否定之界：时为 `Unit`、行为 `Bool`、归并恒定，唯一之时恰于 `P` 成立时为读，则其行被确定恰当 `¬¬P`。”

    Use this scope in the summaries, and label the record’s item as an example.

16. **Medium — Accordance constrains observed choices; it does not fix a planner.**

    Locations: [03-KNOWING.md:433](../../../../../../../theories/becoming/chapters/03-KNOWING.md), [ShownOrder.lean:56](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ShownOrder.lean), and [make_records_rf.py:240](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/make_records_rf.py), including its Chinese counterpart.

    Quote: “since accordance fixes the planner”.

    **Against the Lean:** `ChoiceOccasions.Accords P` says that each supplied pick stands above every other alternative open at that supplied occasion. It contains no planner function and does not identify how choices are computed or what happens at other occasions. The search algorithm exists separately in the concrete `Untried` witness. The revised literature distinction is appropriate, but this explanation overstates what accordance supplies.

    **Replacement:** “Planner–reward ambiguity lies outside this formalization: it assumes strict dominance at the observed occasions and does not represent the planning algorithm.”

    Chinese: “择法与报酬之合辨不在此形式化中：此处假定所择于已观之时严胜其余开者，未表示择法的算法。”

No further problem found in the class-restriction lemma, revised bases, Open bullet, chapter 07 pointers, known-results placement, or remaining changed summaries. No files were changed and no build or rendering was run.

── cx · ok · session 01a187b1-9af0-7030-8aea-0246a04c9e44 · gpt-6-astra/high · read-only · 268s · 1756.3k tokens · 9 cmds
continue: cx -r 01a187b1-9af0-7030-8aea-0246a04c9e44 "…"
log: /Users/ren/.cache/cx/runs/20261029-203605-91050

**What was taken.** Both further problems were taken, everywhere they occurred (kit/reread_rf.py):

| # | Issue | What was done |
|---|---|---|
| 15 | The one-occasion example was generalized in some summaries to every schedule not given as a list | the module header, the theorem's doc comment, 03 §11, the root's bullet, the README rows, the record's law and history and the study say "a one-occasion example", fixed exactly where `¬¬P` where the exact form would say `P`, and why the exact form takes a list |
| 16 | "Accordance fixes the planner" says more than `Accords` | 03 §11, the module header and the record's correspondence say the law assumes strict dominance at the occasions shown and does not represent how the choices are computed |

The two modules' doc comments changed, so the core receipt was run again.
