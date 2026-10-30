# U3: the review of the landing texts

30 October 2026, before the landing queue. Three independent readers (Claude Opus subagents, read-only, one pass, no per-finding refuters), each through one lens: accuracy against the Lean and F5's counting; scope, order and standing; placement and coherence. Each was given the same brief: the first draft of `kit/texts_u3.py` (eight edits) and `kit/study_u3.txt`, with the leaf, the Weightings theorem, F5's specification, `master_laws.py` and the current report as context; the Lean itself had been reviewed in [REVIEW-U3-LEAN](REVIEW-U3-LEAN.md). Their findings are given as returned (§1–§3), then how each was taken (§4). The owner verified each finding against the files before taking it.

## 1. Accuracy

I read the eight edits in texts_u3.py and the study template study_u3.txt against the leaf, Weightings.grammar_widens_iff_every_positive, F5's spec, master_laws.py:334-337 and master-laws.json. I wrote nothing.

Checked and correct:
- The projected counts hold. Of the 118, 44 reach the grammar, 31 rest on balance, 36 on no master law, and 7 on an anchor without reaching it. Those 7 are Direction.extension_iff_widens (row 6), Web.paths_extension_iff_widens (5), Web.paths_comparison_widens (7), Web.widens_iff_retains_adds (8), Web.paths_one_object (9), PartForms.goAlike (lumping) and Weighting.widens_iff_every_positive (10). All are on order's anchor except goAlike.
- Rows 5, 7 and 10 have no at-model entries now, so model-own items move them from "the rest" (54 to 51) to the own-carrier count (4 to 7), giving 44+16+7+51=118. "The 7 resting on an anchor" is the right group, and three plus two make 5 of those 7; row 6 and goAlike are untouched.
- Every current passage occurs exactly once, every link target resolves, and the two Chinese edits match their English. The row-to-declaration mapping in the Delta lines matches the Lean, and each root form is proved through its row (row 1 via Web.unrestricted_iff_paths_livingSignificance, which uses unrestricted_iff_livingSignificance).

Problems:
- **High (2):** the summary of 全四 ("met only as F5 counts it", in FU's outcome and in the study's Boundary line) is ambiguous. Read literally it says 全四 is not met for rows 1, 8 and 9. That contradicts OU's note queued on branch ou-he2: 全四 is met as F4 asks it once items 1 and 2 land, F5 is a stricter count, and both must always be stated.
- **Medium (5):**
  - "Row 1" is never defined and collides with OU3c's row 1, `Learning.goAlike_iff_lumped`. FU's PROPOSAL otherwise uses no row numbers, and F5's spec numbers rows by U2's table.
  - The study calls the structural reading a "choice of carrier", using the word outside its sense.
  - The one page and overview call all five forms "restatements", though three are specializations, and they name neither premise.
  - Three places in 07 are missed and still count "one instance": the Thesis, the Open item's title and §4.5.
  - The overview's "root and the ethics" bullet (English and Chinese) is missed and will contradict the edited Lifting bullet above it.
- **Low (7):**
  - FU's first bullet restates OU3b's Web.widens_iff instead of row 5, and drops row 7's every reading of `living`.
  - FU's second bullet drops two-valued admission.
  - FU's third bullet says the rows are "stated", not specialized.
  - The study's opening says "Each row is stated", and its Delta drops row 7's every-`living` scope.
  - The 08 §7 edit needs polish: three different 7s, the other two of the 7 unmentioned, "none" ambiguous, and row 1 also specialized to a web's level paths.
  - Two review-packet dossiers go stale (BUDDHIST-THOUGHT.md:338 "只有一例", PHILOSOPHY.md:327 "One instance is proved").
  - The study's Output → input line is incomplete.

### accuracy 0 (high)

- **Words:** F5 counts rows 5, 7 and 10 as stated in the grammar's terms on their own carrier; 全四 for the significance rows is met only as F5 counts it.
- **Problem:** This is ambiguous, and on its natural reading it contradicts OU's decision. Read literally it says 全四 is met only where F5 counts a row: rows 7 and 10, plus row 5, which is capacity's row, not significance's. That means 全四 is not met for rows 1, 8 and 9. OU's note, at the head of the queue, decides the opposite: 全四 as F4 asks it is met once items 1 and 2 land, F5 is a separate and stricter count, and the two must always be stated together. The bullet reports only F5's count, and garbles even that.
- **Evidence:** Branch ou-he2, WHAT-REMAINS, new section "U3's standing, and what 全四 counts" (queued by 64f5fa338): "What 全四 then means ... That is met once items 1 and 2 land: each row has its root form, the condition and C stay named premises, and `sig` stays free in the general statement (SD1). F5's count is a different and stricter measure ... Both are stated wherever 全四 is summarized. Neither is reported alone". On main, WHAT-REMAINS:198: "It is met when the five rows are stated in the root's terms in the package". master-laws.json and master_laws.py:334-337: F5 puts rows 1, 8 and 9 in "the rest".
- **Proposed:** - F5 counts `Web.paths_extension_iff_widens`, `Web.paths_comparison_widens` and `Weighting.widens_iff_every_positive` as stated in the grammar's terms on their own carrier. It keeps the three specialized rows among the rest, since a specialization states less than its row. 全四 is met as F4 asks it: each significance row has its root form, the condition and C stay named premises, and `sig` stays free in the general statement. F5's stricter count does not take the three specializations. The free significance is not lifted, and the condition (scope) and C (order) stay premises. (Match OU's note as it lands.)

### accuracy 1 (high)

- **Words:** Item 3, «广之对应», stays with GrammarTransport's owner; 全四 is met for the significance rows only as F5 counts them.
- **Problem:** This is the same ambiguous summary of 全四 as in FU's outcome (lines 40-41). F5 counts rows 1, 8 and 9 in its fourth count, so "only as F5 counts them" reads as "not met for rows 1, 8 and 9". OU's queued decision says 全四 (F4) is met once items 1 and 2 land, F5 being stricter, and that both must be stated.
- **Evidence:** study_u3.txt:35-37 (Standing) puts rows 1, 8 and 9 in F5's fourth count. Branch ou-he2, WHAT-REMAINS: "Both are stated wherever 全四 is summarized. Neither is reported alone: \"met\" without F5's count would read the structural reading as the row."
- **Proposed:**   - Item 3, «广之对应», stays with GrammarTransport's owner. 全四 is met as F4 asks it: each significance row has its root form, the condition and C stay named premises, and `sig` stays free in the general statement. F5's stricter count takes only rows 5, 7 and 10, and keeps rows 1, 8 and 9 among the rest (WHAT-REMAINS, "U3's standing, and what 全四 counts").

### accuracy 2 (medium)

- **Words:** FU outcome: "rows 1, 8 and 9 are stated there" and "F5 counts rows 5, 7 and 10"; study_u3.txt:7, 11 and 36: "rows 1, 8 and 9", "Row 1, a specialization"
- **Problem:** The row numbers are not defined where they are used, and "row 1" collides with an existing numbering. The numbers 5 to 10 are OU3c's. In OU3c's table, row 1 is `Learning.goAlike_iff_lumped`, and `unrestricted_iff_livingSignificance` has no number at all. FU's PROPOSAL uses no row numbers anywhere else, and F5's spec, which FU's outcome cites, numbers rows by U2's table: its rows 7 and 10 are different declarations. A reader of FU's outcome or the study section cannot map "row 1" or "row 7" to a declaration.
- **Evidence:** ou3c-anchors-on-the-grammar/AUDIT.md:24: "| 1 | `Learning.goAlike_iff_lumped` |". DESIGN.md:21-22: "The numbers 5 to 10 ... are those of OU3c's audit table"; "`unrestricted_iff_livingSignificance` has no number there." F5-MODEL-STATEMENTS.md:28 and 80: "such as rows 10, 16, 20 and 24"; "Rows 7, 9, 12 and 23 are wholly on their own carriers" (U2's numbering). FU PROPOSAL: no "row N" anywhere.
- **Proposed:** In FU's outcome, name the declarations instead of numbers: "... and `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` are specialized there ..."; "F5 counts `Web.paths_extension_iff_widens`, `Web.paths_comparison_widens` and `Weighting.widens_iff_every_positive` ...". In the study's opening paragraph, define the labels once: "rows 5, 7 and 10 of OU3c's audit (`Web.paths_extension_iff_widens`, `Web.paths_comparison_widens`, `Weighting.widens_iff_every_positive`) restated on their own carrier, and `unrestricted_iff_livingSignificance` (unnumbered there, called row 1 here) with rows 8 and 9 (`Web.widens_iff_retains_adds`, `Web.paths_one_object`) specialized at the structural reading of significance".

### accuracy 3 (medium)

- **Words:** The structural reading of significance is the design's choice of carrier (DESIGN §2)
- **Problem:** "Carrier" is used outside its sense. A carrier is what a relation is on (glossary, "model"), and in this very section F5's "own carrier" means a web's level paths or a finite list. The structural reading is not a carrier. It is a choice of the predicate `sig` (`selfAscribed (ownClosure rel) center`), and the design supplies it without showing it is the right one. A reader could take the three specializations as "on their own carrier", which is F5's third count, exactly what this item says they are not.
- **Evidence:** GLOSSARY.md:20: "model ... a carrier, a relation read as condition and the classes used". study_u3.txt:35-37: "stated in the grammar's terms on their own carrier ... rows 1, 8 and 9 stay in its fourth count". DESIGN §2: "That the structural reading is the right one ... is the step of invariance (07 §4), and stays open."
- **Proposed:** Supplied premises / correspondence: none added. The structural reading of significance is a reading the design supplies, not shown to be the right one (DESIGN §2: whether a center's own line runs along that relation, held de se, is the step of invariance, open). On an acyclic relation ...

### accuracy 4 (medium)

- **Words:** significance's 5 are stated in the grammar's terms, two on their own carrier and three with significance read as lying within a center's line, restatements and not derivations. / 意义的 5 条已以文法之语陈述，两条在其自身之载体上，三条以意义读作位于一中心之相续之内，为重述，非推导。 (one page and overview, English and Chinese)
- **Problem:** "Restatements" overclaims for three of the five. The forms of `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` are specializations, which state less than their rows. 08 §7's own edit says so, and so do the study section and DESIGN §3. "Significance's 5 are stated" likewise reads as if the rows themselves are stated. This is the ethics summarized on both front pages, yet neither premise is named; AGENTS.md asks that both be named wherever the ethics is summarized. Minor point: one of the "two on their own carrier" (`grammar_widens_iff_every_positive`) still has natural-number weights on its right side, and the overview's same bullet says the grammar "has no amounts yet". The Chinese matches the English and carries the same defects.
- **Evidence:** texts_u3.py:28-29 (08 §7 edit): "a specialization states less than its row". study_u3.txt:4: "These are restatements, or specializations, not derivations." F5 spec §4: "An instance or a specialization of a row states less than the row". AGENTS.md: "name both wherever the ethics is summarized". THE-THEORY-OF-BECOMING.md:231: "the grammar, which has no amounts yet".
- **Proposed:** EN: "; significance's 5 have statements in the grammar's terms, each proved through its row: two restate their rows on their own carrier, and three specialize theirs, with significance read as lying within a center's line. None is a derivation, and the condition (scope) and C (order) stay premises." ZH: "；意义的 5 条已有以文法之语所作之陈述，各经其本行证明：两条在其自身之载体上重述本行，三条以意义读作位于一中心之相续之内而特化本行；无一为推导，延续条件（定范围）与 C（定次序）仍为前提。"

### accuracy 5 (medium)

- **Words:** Thesis (line 3): "and the condition on the root beyond one instance."; Open title (line 672): "The condition on the root's grammar, beyond one instance"; §4.5 (line 325): "Each theorem of this chapter taking the condition as a hypothesis instantiates at that significance; one instance is proved"
- **Problem:** Missed live passages. "One instance" is `premises_of_noOutside`. After U3, three more of the chapter's laws are proved at that same significance (`noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root`, `paths_one_object_root`). So the Thesis's open item, the Open item's title (which U3's edit keeps while rewriting its body) and §4.5's count all understate. The Open item's own new body then lists the specializations under a title that still says "one instance".
- **Evidence:** texts_u3.py:38-44 changes only the body of the 07 Open item. laws_u3.py:16-47: three laws at `selfAscribed (ownClosure rel) center`, the reading of §4.5 (07:325: "Unrestricted (selfAscribed (ownClosure rel) center) ... one instance is proved ... (`premises_of_noOutside`)").
- **Proposed:** Thesis: "... and the condition on the root beyond the central laws, whose forms there are specializations at the structural reading." Open title: "**The condition on the root's grammar, beyond the central laws**". §4.5, through its record (the-continuation-condition-on-the-root): "... one instance is proved in this record: ... (`premises_of_noOutside`); three central laws are specialized at it in their own records ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity))."

### accuracy 6 (medium)

- **Words:** line 232: "The free significance of 07 §1 is not lifted onto the root, the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open"; THE-THEORY-OF-BECOMING.zh.md:228: "07 §1 的自由意义尚未提升到根上，该章的其他律是尚未在根上陈述的实例"
- **Problem:** A missed live passage that will contradict the Lifting bullet directly above it. U3 edits the matching clause in 01 and 07 by inserting what is now stated before "the ... other laws are instances not yet stated on the root", so there "other" means "the rest". The overview's "The root and the ethics as one account" bullet gets no such edit. It still says every law of chapter 7 beyond the condition is not stated on the root, while the edited Lifting bullet just above says "significance's 5 are stated in the grammar's terms".
- **Evidence:** texts_u3.py:32-44: the 01 and 07 edits insert the U3 sentence before "the ethics' (chapter's) other laws are instances not yet stated on the root". texts_u3.py:56-68 edit only the overview's Lifting bullet (line 231 and zh 227).
- **Proposed:** EN: "The free significance of 07 §1 is not lifted onto the root. Significance's central laws are stated in the grammar's terms, two on their own carrier and three specialized at this reading ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)); the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open))." ZH: "07 §1 的自由意义尚未提升到根上；意义的中心之律已以文法之语陈述，两条在其自身之载体上，三条在此读法下为特化（[08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)）；该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决（[07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)）。"

### accuracy 7 (low)

- **Words:** - Widening on paths is the grammar's `«广»` of what a path admits, and C holds with "better" read as that `«广»`, its being better C's content, supplied.
- **Problem:** The first clause is `Web.widens_iff`, which OU3b landed, not U3's outcome. What U3 adds for row 5 is missing: an extension counting every claim is `«广»` (`paths_extension_iff_grammar`). `«广»` relates two admitted sets, so "of what a path admits" is loose. Row 7's own scope, every reading of `living` (the design review's finding 1), is also dropped.
- **Evidence:** SignificanceStatements.lean:22-23: "widening what can form is the grammar's `«广»` of what the paths admit (`Web.widens_iff`)"; :65-66 `Extension W.paths (fun _ => True) l' l ↔ «广» (W.admitted l) (W.admitted l')`; :72 `(living : F × Nat → Prop)`; DESIGN §6 finding 1.
- **Proposed:** - An extension of one level path by another, every claim counted, is the grammar's `«广»` of what the second admits over what the first admits (through `Web.widens_iff`, OU3b's). For every reading of `living`, C holds with "better" read as that `«广»`, its being better C's content, supplied.

### accuracy 8 (low)

- **Words:** - Weightings meet the root through one interface law: `«广»` over a listing is what every additive natural-number weighting positive on the listed items ranks higher.
- **Problem:** It drops Boolean (two-valued) admission, a modelling choice the law depends on (`a b : X → Bool`). AGENTS.md asks that such choices be stated wherever a law depends on them. The first Lean review's finding 3 was exactly this omission, taken in the law texts but not here.
- **Evidence:** Weightings.lean:1186-1188: `{items : List X} {a b : X → Bool} : «广» (admittedOn items a) (admittedOn items b) ↔ ∀ w, Positive items w → ...`; REVIEW-U3-LEAN.md §1 finding 3.
- **Proposed:** - Weightings meet the root through one interface law: over a finite listing with two-valued admission, `«广»` is what every additive natural-number weighting positive on the listed items ranks higher.

### accuracy 9 (low)

- **Words:** - The condition at its structural reading is `«续无外»` (GS2), and rows 1, 8 and 9 are stated there:
- **Problem:** "Are stated there" says the rows themselves are stated. The same sentence then calls each a specialization, and the 08 §7 edit says a specialization states less than its row. The condition is `«续无外»` at the one of the relation, not bare `«续无外»`.
- **Evidence:** SignificanceStatements.lean:57 `«续无外» rel «一» center`; texts_u3.py:28-29.
- **Proposed:** - The condition at its structural reading is `«续无外»` at the one of the relation (GS2), and the three rows that take the condition are specialized there: each fixes significance at one reading, so F5 takes none as an item.

### accuracy 10 (low)

- **Words:** line 3: "Each row is stated in the grammar's terms and proved through its row"; lines 16-18: "C holds on level paths with \"better\" read as that «广» (paths_comparison_grammar)"
- **Problem:** "Each row is stated" contradicts the Standing line ("a specialization stating less than its row") for three rows, and "each row ... proved through its row" is circular. The Delta for row 7 drops its own scope, every reading of `living`, which the design review required and the law text keeps.
- **Evidence:** study_u3.txt:36-37; laws_u3.py:30 "for every reading of living"; SignificanceStatements.lean:72.
- **Proposed:** Line 3: "Each root form is stated in the grammar's terms and proved through its row: ...". Lines 17-18: "for every reading of living, C holds on level paths with \"better\" read as that «广» (paths_comparison_grammar), its being better C's content, supplied."

### accuracy 11 (low)

- **Words:** 08 §7 edit: "is specialized on the root at the structural reading of significance ... Of the 7 resting on an anchor without reaching it, U3 states three ... and specializes two at that reading; a specialization states less than its row, so F5 takes none as an item. So F5's report ... 7 stated on their own carrier only, and 51 the rest."
- **Problem:** The counts are right. I checked them against master-laws.json: the 7 "anchor, not reached" are Direction.extension_iff_widens, Web.paths_extension_iff_widens, Web.paths_comparison_widens, Web.widens_iff_retains_adds, Web.paths_one_object, PartForms.goAlike and Weighting.widens_iff_every_positive; the current 4 own-carrier rows plus these 3 make 7; 54-3=51; and 44+16+7+51=118. Only polish remains. The paragraph now has three different 7s (7 on another anchor, 7 laws of their models, 7 own-carrier), and the new own-carrier 7 is easily read as the anchor 7 having all moved. The other two of the 7 (row 6, goAlike) go unmentioned. "None" has a loose antecedent. Row 1's form is also specialized from any frame to a web's level paths.
- **Evidence:** master-laws.json central_reach counts {44,16,4,54}; own-carrier rows now: ExchangeLaw.response_not_fixed_by_coupling, Ideals.verifiableBy_iff_interior, Learning.Training.unselected_beyond_data, Valuation.significant_iff_held. Relevance.lean:136 (any Frame) vs SignificanceStatements.lean:55-58 (W.paths).
- **Proposed:** "... is specialized on the root, on a web's level paths, at the structural reading of significance ([U3]). Of the 7 resting on another master law's anchor without reaching it, U3 states three in the grammar's terms on their own carrier (...) and specializes two at that reading; the other two, row 6 on the moves' frame and `PartForms.goAlike`, keep their reasons. A specialization states less than its row, so F5 takes no specialization as an item. So F5's report, over the 118, counts 44 reaching the grammar, 16 stated at a represented model, 7 stated on their own carrier only (U2's 4 and U3's 3), and 51 the rest."

### accuracy 12 (low)

- **Words:** line 338: "伦理诸律中只有一例在此读下证出（生命意义之诸前提，`premises_of_noOutside`），其余尚未在根上陈述"; PHILOSOPHY.md:327: "One instance is proved: ... (`premises_of_noOutside`)"
- **Problem:** These live dossiers of the review packet become wrong or understated once U3 lands: three more of the ethics' laws are proved at this reading. They are not among the eight edits. Whether to update them or leave them frozen with the packet is the packet owner's call, but it should be decided.
- **Evidence:** laws_u3.py:16-47 (three specializations at `selfAscribed (ownClosure rel) center`).
- **Proposed:** BUDDHIST-THOUGHT.md: "伦理诸律中在此读下证出者：生命意义之诸前提（`premises_of_noOutside`），及三条中心之律之特化（U3）；其余尚未在根上陈述". PHILOSOPHY.md: "One instance is proved in GrammarScope (`premises_of_noOutside`), and three central laws are specialized at this reading (U3): ...". Or note that the packet stays frozen at its date.

### accuracy 13 (low)

- **Words:** Output → input: the four records' laws and their home-section bullets in 07; F5's report (MV); 08 §7's counts and the one page's line on significance's central declarations; the leaf's region.
- **Problem:** It omits outputs U3 actually writes: the open items of 01 and 07, the overview's Lifting bullet (English and Chinese), the one page's Chinese line, FU's PROPOSAL outcome, and the connectivity register entry for row 10's law.
- **Evidence:** texts_u3.py:21-88 (eight edits); register_u3.py (THEOREM-CONNECTIVITY-APART.json).
- **Proposed:** Output → input: the four records' laws and their home-section bullets in 07; F5's report (MV); 08 §7's counts; the open items of 01 and 07; the one page's and the overview's line on significance's central declarations (English and Chinese); FU's PROPOSAL (U3's outcome); the connectivity register (row 10's law, support); the leaf's region.

## 2. Scope

I reviewed the U3 texts read-only, through the lens of scope, order and standing. I changed and wrote nothing.

**What checks out:**
- **The F5 counts and the reason for them.** I checked them against master-laws.json and master_laws.py. Rows 5, 7 and 10 rest on order's anchor without reaching the grammar. Their only items will have model `own`, so they move from "the rest" into the third count: 4+3=7 and 54−3=51, still 118 in all. Rows 1, 8 and 9 rightly get no item.
- **Each current passage occurs exactly once,** and every link target and anchor resolves.
- **No edit says or implies that the root entails significance, the condition or C.** "Representation" is not used for U3's own-carrier statements. The Chinese edits say what their English says.

**High (one):** "全四 ... is met only as F5 counts it" (FU's outcome and the study's Boundary). By F5's own count, only two of the five significance rows are stated (rows 7 and 10). Rows 1, 8 and 9 stay in the fourth count. So as F5 counts it, 全四 is not met for those three, and the sentence reads as a completion claim that will be carried into WHAT-REMAINS.

**Medium:**
1. The one page and overview call all five rows "stated" and "restatements", though three are specializations that 08 §7 says state less than their rows. "A center's line" also drops the class, which the next bullet says is open.
2. Row 10 is summarized as "stated in the grammar's terms" with no word that it is an interface law whose weights are amounts the grammar lacks. That clashes with OU3c's reason for row 10 and with "three resist, their terms amounts" in the same 08 paragraph.
3. Missed live passages: the overview's "root and the ethics" bullet in English and Chinese ("the chapter's other laws are instances not yet stated on it"), and 07 §4.5's "one instance is proved" with the Open heading "beyond one instance".
4. The 01 and 07 wording is loose: "are stated" covers the specializations, "the condition's laws" is imprecise, "none derived" lacks "from the root", and "structural reading" stands where the live chapters say "own-closure reading".
5. The study calls the structural reading a "choice of carrier". It is a supplied reading of significance, not a carrier.
6. FU's first outcome bullet credits OU3b's `Web.widens_iff` to U3 and leaves out what row 5 actually states.

**Low:** small wording points in the study and in FU's outcome; a "representation" label in 08 §7 that predates U3 but now sits next to its edit; Chinese wording that differs from the pages' existing terms; and stale counts and 全四 status in WHAT-REMAINS, which belongs to OU's owner and should be told at landing.

Files: `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u3-significance-on-the-root/kit/texts_u3.py` and `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u3-significance-on-the-root/kit/study_u3.txt`; the missed passages are in `/Users/ren/theories/theories/becoming/THE-THEORY-OF-BECOMING.md` (and `.zh.md`) and `/Users/ren/theories/theories/becoming/chapters/07-SIGNIFICANCE.md`.

### scope 0 (high)

- **Words:** "全四 for the significance rows is met only as F5 counts it" (FU's PROPOSAL, U3's outcome, lines 85-86); the same claim in study_u3.txt line 40: "全四 is met for the significance rows only as F5 counts them"
- **Problem:** Overclaim, and it contradicts itself. F5 counts only two of the five significance rows as stated: row 7 and row 10, each on its own carrier. Rows 1, 8 and 9 stay in F5's fourth count, because F5 takes no specialization as an item, and these texts say so themselves. So as F5 counts it, 全四 is not met for three of the five rows. The sentence can also be read as "全四 is met, in F5's sense". OU's owner will copy that reading into WHAT-REMAINS and the release gate.
- **Evidence:** OU PLAN line 457 defines it: 全四：五条中心之意义结果在根上写出. WHAT-REMAINS line 198 says it "is met when the five rows are stated in the root's terms in the package". F5-MODEL-STATEMENTS.md lines 85-89 say "An instance or a specialization of a row states less than the row, so it is not an item", and that U3's rows otherwise stay "in the fourth count". texts_u3.py line 84 says of rows 1, 8 and 9: "so F5 takes none as an item". study_u3.txt lines 36-37 say they "stay in its fourth count". DESIGN §3 line 59 says counting them "would need the field to gain a declared relation ... This design does not propose that now."
- **Proposed:** FU: "- F5 counts rows 5, 7 and 10 as stated in the grammar's terms on their own carrier. It counts rows 1, 8 and 9 in the rest, since it takes no specialization as an item. So, as F5 counts it, 全四 is met for two of the five significance rows (7 and 10) and not for rows 1, 8 and 9. Meeting it for those three needs the field's declared relation (statement, instance, specialization), which F5 §4 leaves to OU's owner. The free significance is not lifted, and the condition (scope) and C (order) stay premises." Study Boundary: "As F5 counts it, 全四 is met for rows 7 and 10 only (row 5 besides). Rows 1, 8 and 9 are specialized and not counted, and whether a specialization meets 全四 is OU's owner's decision (F5 §4)."

### scope 1 (medium)

- **Words:** One page and overview, lines 49-51 and 61-62: "significance's 5 are stated in the grammar's terms, two on their own carrier and three with significance read as lying within a center's line, restatements and not derivations." Chinese, lines 55 and 67-68: "意义的 5 条已以文法之语陈述，两条在其自身之载体上，三条以意义读作位于一中心之相续之内，为重述，非推导。"
- **Problem:** The front pages say more than 08 §7 and the records. (1) They call all five "stated" and "restatements". 08 §7, as edited, says three are specialized, and that a specialization "states less than its row". (2) The reading is not marked as supplied. It also drops the class: under the structural reading, significance lies within a center's closure along a relation, that is, on its line under the full class (the one) of that relation. The very next bullet of the one page says "which class a center's own line runs under is open", so "a center's line" with no class blurs the open question. The Chinese says exactly what the English says, so it carries the same overclaim.
- **Evidence:** texts_u3.py line 29: "a specialization states less than its row, so F5 takes none as an item". study_u3.txt line 35: "restatements or specializations, not derivations". ONE-PAGE.md line 28: "nothing lies outside every center's line under the full class of that relation ... which class a center's own line runs under is open". GLOSSARY.md line 13 defines line as "the reach of continuation", always under a class. DESIGN §2 line 46 says it is not established "That the structural reading is the right one".
- **Proposed:** English: "; significance's 5 now have statements in the grammar's terms, none derived from the root: two are restated on their own carrier, and three are specialized at one supplied reading (significance as lying within a center's line under the full class of a relation), each stating less than its row." Chinese: "；意义的 5 条现已有以文法的词语写出的陈述，无一条由根推出：两条在其自身的载体上重新陈述，三条在一种所给的读法下特化（意义读作位于一个中心在某关系的全类之下的相续之内），所述少于各条本身。"

### scope 2 (medium)

- **Words:** 08 §7, lines 27-29: "U3 states three in the grammar's terms on their own carrier (C's extension and comparison on a web's paths, and what every positive weighting ranks)". 01 and 07, lines 34-35 and 40-41: "stated in the grammar's terms, comparison by widening and what every positive weighting ranks on their own carrier". The front pages count row 10 among the "two on their own carrier".
- **Problem:** Row 10's root form is an interface law. Only its left side, «广», is a grammar term. The right side quantifies over additive natural-number weightings, which are amounts the grammar has none of. "Stated in the grammar's terms" is F5's label for its third count; F5's test only needs one grammar term among the constants. Read plainly, the label contradicts other sentences in the same paragraph: OU3c's reason for row 10 not reaching the grammar, cited there, is that the grammar has no weights, and three U2 rows "resist, their terms amounts computed over a family". `weighed items w` is an amount computed over a list. The records state the limit; the live summaries drop it.
- **Evidence:** DESIGN §1 line 32 gives row 10's reason, "a law of weights, which the grammar has none of", and its kind, "an interface law of the second sort ... not a derivation of weights". laws_u3.py lines 52-53: "The weights are amounts assigned to what is admitted, a second sort the grammar has none of." Weightings.lean line 1183: "the weights are a second sort the grammar has none of". 08-METHOD.md line 434: "three resist, their terms amounts computed over a family". F5 spec §2 line 57: what an item "keeps in other terms" is shown apart.
- **Proposed:** 08 §7: "Of the 7 resting on another master law's anchor without reaching it, U3 restates three in the grammar's terms on their own carrier (C's extension and comparison on a web's level paths, and what every positive weighting ranks, an interface law whose weights are amounts the grammar has none of) and specializes two at that reading; ...". In 01 and 07: "comparison by widening on its own carrier, and what every positive weighting ranks as an interface law whose weights are amounts the grammar has none of".

### scope 3 (medium)

- **Words:** Line 232 ("The root and the ethics as one account"): "The free significance of 07 §1 is not lifted onto the root, the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open". Chinese, THE-THEORY-OF-BECOMING.zh.md line 228: "07 §1 的自由意义尚未提升到根上，该章的其他律是尚未在根上陈述的实例"
- **Problem:** A live passage that U3 should change but texts_u3.py does not touch. The kit edits the Lifting bullet just above it (line 231) to say significance's 5 are stated. This bullet still says that every law of the chapter other than the condition is "not yet stated on it", so the two adjacent bullets contradict each other. The kit amends the parallel sentences in 01 (line 609) and 07 (line 672), but not these two.
- **Evidence:** texts_u3.py edits 6 and 7 change only line 231 of the overview and line 227 of its Chinese edition. The 01 and 07 edits (lines 32-44) rewrite the same "other laws are instances not yet stated on the root" sentence there.
- **Proposed:** Add an edit for each. English: "The free significance of 07 §1 is not lifted onto the root. Its central laws are restated on their own carrier or specialized at the own-closure reading ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)), the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open))." Chinese: "07 §1 的自由意义尚未提升到根上；其核心之律或在自身的载体上重新陈述，或在自闭包读法下特化（[08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)），该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决（[07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)）。"

### scope 4 (medium)

- **Words:** §4.5, line 325: "Each theorem of this chapter taking the condition as a hypothesis instantiates at that significance; one instance is proved: ... (`premises_of_noOutside`)". Open, line 672, heading: "The condition on the root's grammar, beyond one instance"
- **Problem:** Live passages that become false or stale once U3 lands. `widens_iff_retains_adds_root` takes «续无外» at sig = selfAscribed (ownClosure rel) center, which makes it an instance in exactly §4.5's sense. `noOutside_iff_paths_livingSignificance` and `paths_one_object_root` are instances at that significance too. After U3, "one instance is proved" is false, and the Open heading names a gap that U3 partly fills. The GS2 record's next_delta also lists the same work as still to do.
- **Evidence:** SignificanceStatements.lean lines 82-88 and 95-109. the-continuation-condition-on-the-root.json next_delta: "The chapter's other theorems that take the condition stated as instances through the root's". texts_u3.py edit 3 keeps the heading and leaves §4.5 unchanged.
- **Proposed:** §4.5: "...; instances are proved: on every reading where ... a seed (`premises_of_noOutside`); and, on a web's level paths, the condition as living significance, widening as retaining and adding, and the one evaluative object ([row 1](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-continuation-condition-yields-living-significance), [row 8](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-significance-retained-within-margin), [row 9](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-comparison-by-widening))." This is the home section of GS2's record, so its owner or the record's next_delta takes the change. Open heading: "The condition on the root's grammar, beyond the central laws".

### scope 5 (medium)

- **Words:** 01, lines 34-37: "Significance's central laws are stated in the grammar's terms, ..., and the condition's laws at its structural reading, a specialization". 07, lines 40-44: "... and the condition's laws at its structural reading, a specialization, each proved through its row and none derived"
- **Problem:** (1) The main verb "are stated" covers rows 1, 8 and 9, which 08 §7 and F5 say are specialized and state less than their rows. (2) "The condition's laws" is imprecise. Row 8 takes the condition as a hypothesis, and row 9 contains it as one conjunct, so it can be misread as laws the condition yields. Also, the singular "a specialization" sits as an appositive to "reading". (3) "None derived" leaves open derived from what. In 08's vocabulary it means not derived from the grammar; as written it can read as "not proved". (4) "Structural reading" is used nowhere in the live chapters. 07 §4.5 names this reading "the own-closure reading", and laws_u3.py's own labels use that name.
- **Evidence:** 07-SIGNIFICANCE.md line 325: "**Conditional** (the root's condition at the one, the own-closure reading)". laws_u3.py line 66: ROOT_CONDITION = "the root's condition at the one, the own-closure reading". In live text "structural reading" occurs only in review/PHILOSOPHY.md and in a record's correspondence field ("SW §3's structural reading").
- **Proposed:** 01: "The free significance of 07 §1 is not lifted. Of significance's central laws, comparison by widening is restated in the grammar's terms on its own carrier, and what every positive weighting ranks as an interface law; the laws that take the condition are specialized at its own-closure reading ([07 §4.5](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)), each stating less than its row ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)); the ethics' other laws ...". 07: the same wording, ending "... each proved through its row and none derived from the root ([08 §7])".

### scope 6 (medium)

- **Words:** Lines 28-29: "The structural reading of significance is the design's choice of carrier (DESIGN §2)"
- **Problem:** The structural reading is a choice of significance (sig := selfAscribed (ownClosure rel) center), not a carrier. In the glossary a carrier is what a model's relation is on. Each law also keeps its row's carrier: level paths, or a finite list. DESIGN §2 does not call it a choice of carrier. It says the right reading is open, which is exactly the standing a supplied-premises line should record.
- **Evidence:** GLOSSARY.md line 20: "model ... a carrier, a relation read as condition and the classes used". DESIGN.md line 46: "That the structural reading is the right one ... is the step of invariance (07 §4), and stays open."
- **Proposed:** "The structural reading of significance (`selfAscribed (ownClosure rel) center`) is a supplied reading, which the three specializations fix. That it is the right one is the step of invariance's question, and stays open (DESIGN §2)."

### scope 7 (medium)

- **Words:** FU's outcome, lines 78-79: "Widening on paths is the grammar's `«广»` of what a path admits, and C holds with \"better\" read as that `«广»`"
- **Problem:** The first clause is `Web.widens_iff`, OU3b's existing representation of order's anchor, not something U3 proved. Row 5's actual content never appears in the outcome: with every claim counted, an extension of level paths is «广». Yet the fourth bullet says F5 counts row 5. Row 7's scope is also dropped: it holds for every reading of living, on level paths.
- **Evidence:** SignificanceStatements.lean line 67: `W.paths_extension_iff_widens.trans Web.widens_iff`. Line 74: `Web.widens_iff.mp (W.paths_comparison_widens living l' l ext)`. 08-METHOD.md table, Order row: "`Web.Widens` ... are `«广»` of what is admitted", which predates U3.
- **Proposed:** "- With every claim counted, an extension of one level path by another is the grammar's `«广»` of what the paths admit (row 5, through OU3b's `Web.widens_iff`). For every reading of living, C holds on level paths with \"better\" read as that `«广»` (row 7), its being better C's content, supplied."

### scope 8 (low)

- **Words:** FU's outcome, line 83: "rows 1, 8 and 9 are stated there". Line 80-81: "«广» over a listing is what every additive natural-number weighting positive on the listed items ranks higher"
- **Problem:** "Stated" should be "specialized", matching the rest of the bullet and F5. Row 10's bullet also drops two-valued (Boolean) admission, which REVIEW-U3-LEAN finding 3 asked to be kept wherever the law is stated.
- **Evidence:** Weightings.lean lines 1179-1182: "with Boolean admission and additive natural-number weights positive on every listed item". REVIEW-U3-LEAN.md §1, finding 3.
- **Proposed:** "... and rows 1, 8 and 9 are specialized there ...". "«广» of what one two-valued admission admits over another on a finite list is what every additive natural-number weighting positive on the listed items ranks higher."

### scope 9 (low)

- **Words:** Line 3: "Each row is stated in the grammar's terms and proved through its row". Lines 30-31: "so the laws that take it hold beyond one center there only with the condition side false". Line 11-15, the row 1 delta, omits "on a web's level paths". Lines 16-18, the row 7 delta, omits "for every reading of living". Lines 43-44, Output → input, lists only 08 §7 and the one page.
- **Problem:** (1) Line 3 conflicts with the study's own Standing: a specialization states less than its row. (2) "Hold ... only with the condition side false" can be read as saying the laws fail otherwise. DESIGN says they remain valid, with the condition side false. (3) The two deltas drop scope that the laws state. (4) Output → input omits the overview (English and Chinese), 01's and 07's open items, and FU's PROPOSAL, all of which texts_u3.py edits.
- **Evidence:** study_u3.txt lines 35-37. DESIGN.md line 51: "The root forms of rows 1, 8 and 9 remain valid with distinct centers; their condition side then fails." laws_u3.py line 18: "on a web's level paths". Line 30: "for every reading of living".
- **Proposed:** Line 3: "Each row has a statement in the grammar's terms, proved through its row: ...". Lines 30-31: "so with distinct centers there the laws that take it remain valid, their condition side false." Add "on a web's level paths" to row 1 and "for every reading of living" to row 7. Output → input: "... 08 §7's counts; the one page's and the overview's lines (English and Chinese); 01's and 07's open items; FU's PROPOSAL; the leaf's region."

### scope 10 (low)

- **Words:** Line 434, kept by the edit: "Of those 24, 20 are stated where their terms are the grammar's, each ... declared on its row's record as a statement at a model, a representation and not a derivation"
- **Problem:** The sentence predates U3, but U3's edit now sits right after it. Four of those 20 are own-carrier statements, and F5 says change 1 does not count those as representations. The new sentence describes U3's own-carrier statements correctly, without "representation", so the paragraph uses two standards for the same kind of statement. The paragraph also now has three different 7s: rows resting on another anchor, laws of their models, and own-carrier statements.
- **Evidence:** F5-MODEL-STATEMENTS.md line 77: "stated in the grammar's terms on their own carrier. These are not at a represented model, and change 1 does not count them as representations." The current counts are 16 at a represented model and 4 on their own carrier only (master-laws.json central_reach).
- **Proposed:** "... 20 are stated where their terms are the grammar's, each proved through its row and declared on its row's record: 16 at a represented model, representations and not derivations, and 4 on their own carrier ([U2]); ...". In U3's sentence, write "Of the 7 resting on another master law's anchor without reaching it".

### scope 11 (low)

- **Words:** Chinese edits, lines 55 and 67-68: "已以文法之语陈述", "为重述，非推导"
- **Problem:** The Chinese pages already have terms for these. They say "文法的词语" for the grammar's terms (overview zh line 48) and "推出" for derive. The same paragraph says "平衡只表示、不推出" (one page zh line 27) and "平衡以单位之配对表示，不推出" (overview zh line 227). "推导" introduces a second word for the same concept.
- **Evidence:** THE-THEORY-OF-BECOMING.zh.md line 48: "一条用文法的词语写出的律". Line 192: "可表达不等于已推出".
- **Proposed:** Use "以文法的词语陈述" and "非推出", as in the replacement Chinese given in the front-page finding.

### scope 12 (low)

- **Words:** Release gate, line 198: "Today none of the five significance rows reaches the root, and 全四 is designed, not met." Item 3: "44 reach the grammar, 16 are stated at a represented model, 4 hold on their own carrier and 54 are the rest."
- **Problem:** Live status lines in OU's owner's document. U3's landing leaves them stale: the counts become 7 and 51, and 全四's status changes. The kit does not edit them, which is right, since another owner holds the document. The landing should hand OU's owner the corrected counts and the exact 全四 verdict from the high finding.
- **Evidence:** texts_u3.py line 18: PROJECTED = {..., 'stated on its own carrier only': 7, 'the rest': 51}.
- **Proposed:** In the landing's message or board line to OU's owner: "F5 now 44 / 16 / 7 / 51. 全四, as F5 counts it, is met for rows 7 and 10; rows 1, 8 and 9 are specialized and not counted unless the field gains a declared relation."

## 3. Placement

I found 2 high, 7 medium and 3 low findings. The F5 counts the kit writes (44, 16, 7, 51) are right, and so is the reason given for them. The seven declarations resting on an anchor without reaching it are Direction.extension_iff_widens, PartForms.goAlike, Web.paths_extension_iff_widens, Web.paths_comparison_widens, Web.paths_one_object, Web.widens_iff_retains_adds and Weighting.widens_iff_every_positive. U3 restates three of them (rows 5, 7, 10) and specializes two (rows 8, 9). The three restated rows move from 'the rest' to 'stated on its own carrier only', which then holds U2's 4 and U3's 3 (master_laws.py lines 320-340; master-laws.json). The 08 §7 sentence reads correctly in its paragraph, and every link resolves from its page. The study's links match the style of §461.

High:
1. A live passage was missed. In the overview's 'The root and the ethics as one account' bullet (THE-THEORY-OF-BECOMING.md:232, .zh.md:228), \"the chapter's other laws are instances not yet stated on it\" survives the landing. It would contradict both the edited 'Lifting' bullet just above and 07's Open item. That bullet is also the right place for U3's sentence.
2. In FU's outcome and the study, \"全四 … is met only as F5 counts it\" leaves a release-gate item ambiguous. F5 counts only rows 5, 7 and 10, and row 5 is not one of 全四's five significance rows. Three of those five stay in F5's 'the rest'.

Medium:
- The one-page and overview edits (English and Chinese) call all five rows 'restatements', but three are specializations, which 08 §7 says state less than their rows. The line also names neither premise.
- In 07, three places still say \"one instance\" (the §4.5 sentence, the thesis and the Open heading), but U3 proves more instances at the structural reading.
- WHAT-REMAINS still gives the old figures (44, 16, 4, 54) and the old 全四 status (lines 198, 200, 260, 281). It is not in the kit.
- The FU outcome and the study use 'row 1' for unrestricted_iff_livingSignificance. That collides with OU3c's row 1 (Learning.goAlike_iff_lumped), and FU's PROPOSAL numbers no rows at all.
- The study calls the structural reading 'the design's choice of carrier'. 'Carrier' is used outside its glossary sense, and DESIGN §2 says the reading is not shown right; it does not choose it.
- The 01 edit says the laws are 'stated in the grammar's terms' with no 'not derived' qualifier, which 07's version has.
- FU's first outcome bullet describes OU3b's Web.widens_iff instead of row 5's content, and the weighting bullet drops two-valued admission.

Low: the two different 7s close together in 08 §7, phrasing in the 07 edit, and the study's incomplete Output → input list.

Nothing else is stale outside generated pages: the goal JSONs, COVERAGE, GLOSSARY, COLLECTIVE-DIRECTION and the alignment dossier say nothing that U3 changes. The other review-packet pages are frozen evidence.

### placement 0 (high)

- **Words:** EN: "The free significance of 07 §1 is not lifted onto the root, the chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open"; ZH: "07 §1 的自由意义尚未提升到根上，该章的其他律是尚未在根上陈述的实例，"
- **Problem:** This live passage was missed. Once U3 lands it still says that 07's laws other than the condition are not yet stated on the root. Rows 1, 8 and 9 (the condition as living significance, retaining and adding, the one object) are then specialized at the structural reading, and rows 7 and 10 are restated. The kit edits the matching clauses in 01's open list and 07's Open item, and adds U3's sentence to the overview's 'Lifting' bullet just above (line 231). So the next bullet down would contradict both the bullet above it and chapter 7. This bullet, 'The root and the ethics as one account', is also where a reader looks for whether the ethics is on the root, so U3's sentence belongs here, not in 'Lifting'.
- **Evidence:** THE-THEORY-OF-BECOMING.md:232 and .zh.md:228 as quoted. kit/texts_u3.py edits only line 231 ('the overview, lifting') of these pages. The kit's 01 and 07 edits keep 'other laws are instances not yet stated' only after first saying which laws are now stated.
- **Proposed:** EN: "The free significance of 07 §1 is not lifted onto the root. Significance's central laws are stated in the grammar's terms, comparison by widening and what every positive weighting ranks in full on their own carrier, and the laws taking the condition only at its structural reading, specializations; each is proved through its row and none is derived, and the condition (scope) and C (order) stay premises ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)). The chapter's other laws are instances not yet stated on it, and which class a center's own line runs under is open ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open))." ZH: "07 §1 的自由意义尚未提升到根上。意义的核心之律已以文法之语陈述：以广相比较与每一正加权所排者，在其自身之载体上完整陈述；取延续条件之律，只在其结构读法下陈述，为特化；各经其本行证明，无一推导；延续条件（定范围）与 C（定次序）仍为前提（[08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)）。该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决（[07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)）。" Then trim the 'Lifting' edit (EN and ZH) to a short pointer, or drop it.

### placement 1 (high)

- **Words:** FU: "全四 for the significance rows is met only as F5 counts it." Study: "全四 is met for the significance rows only as F5 counts them."
- **Problem:** This leaves the status of a release-gate item ambiguous, and read one way it overclaims. F5 counts only rows 5, 7 and 10 as stated, and row 5 is not one of 全四's five significance rows (it is in COVERAGE's capacity row). The other three of the five (unrestricted_iff_livingSignificance, Web.widens_iff_retains_adds, Web.paths_one_object) stay in F5's 'the rest'. So by F5's own count, 全四 is not met for three of its five rows. A reader cannot tell whether the sentence means 'met' or 'partly met'. WHAT-REMAINS's gate says 全四 "is met when the five rows are stated in the root's terms in the package". F4 itself says the rows are stated "with the free predicate kept as their generalization", which may admit specializations. Whether it does is OU's owner's decision, and the text should not settle it implicitly.
- **Evidence:** COVERAGE.json, row significance: [unrestricted_iff_livingSignificance, Web.widens_iff_retains_adds, Web.paths_comparison_widens, Web.paths_one_object, Weighting.widens_iff_every_positive]; Web.paths_extension_iff_widens is in row capacity. WHAT-REMAINS.md:198 states the gate condition. FU PROPOSAL F4 (line 21): "with the free predicate kept as their generalization". texts_u3.py PROJECTED moves only the three items into 'stated on its own carrier only'.
- **Proposed:** FU: "- F5 counts `Web.paths_extension_iff_widens`, `Web.paths_comparison_widens` and `Weighting.widens_iff_every_positive` as stated in the grammar's terms on their own carrier. It leaves `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` in the rest, each stated only at the structural reading. Of 全四's five significance rows, then, two are stated in full in the package and three at one reading, with the free predicate kept as their generalization as F4 words it. Whether that meets 全四 is for OU's owner to record (WHAT-REMAINS, release gate item 1). The free significance is not lifted, and the condition (scope) and C (order) stay premises." Study Boundary: "Item 3, «广之对应», stays with GrammarTransport's owner. Of 全四's five significance rows, two are stated in full and three only at the structural reading; whether that meets 全四 is OU's owner's to record."

### placement 2 (medium)

- **Words:** "significance's 5 are stated in the grammar's terms, two on their own carrier and three with significance read as lying within a center's line, restatements and not derivations." / "意义的 5 条已以文法之语陈述，两条在其自身之载体上，三条以意义读作位于一中心之相续之内，为重述，非推导。"
- **Problem:** It calls all five 'restatements' (重述). Three of the five are specializations, and the same landing's 08 §7 sentence says "a specialization states less than its row". So the front pages say more than the Lean and contradict the method chapter. 'significance's 5 are stated' overclaims for the same three. The line summarizes the ethics on the root without naming the two premises; the study, FU and Lean docstring all add "the condition (scope) and C (order) stay premises". 'Two on their own carrier' differs from 08 §7's 'three' (row 5 is counted under capacity), and the page does not say so. The Chinese adds 已, which the English lacks.
- **Evidence:** texts_u3.py edit 1: "a specialization states less than its row, so F5 takes none as an item". study_u3.txt: "These are restatements, or specializations, not derivations." AGENTS.md: name both premises wherever the ethics is summarized; claims say exactly what the Lean proves.
- **Proposed:** EN (both pages): "…; of significance's 5, two are stated in full in the grammar's terms on their own carrier, and three only at one reading of significance, as lying within what a center continues with along a relation (specializations, which state less than their rows); none is derived, and the condition (scope) and C (order) stay premises." ZH: "……；意义的 5 条中，两条在其自身之载体上以文法之语完整陈述，三条只在意义之一读法下陈述，即读作位于一中心沿一关系所续者之内，为特化，所述少于本行；无一推导，延续条件（定范围）与 C（定次序）仍为前提。" On the one page, consider moving the sentence into the next bullet, 'The root and the ethics are one account only in part' (line 28), where a reader looks for it.

### placement 3 (medium)

- **Words:** §4.5: "Each theorem of this chapter taking the condition as a hypothesis instantiates at that significance; one instance is proved: …(`premises_of_noOutside`)". Thesis: "and the condition on the root beyond one instance." Open: "**The condition on the root's grammar, beyond one instance**"
- **Problem:** After U3 these counts are stale. widens_iff_retains_adds_root instantiates Web.widens_iff_retains_adds, a theorem of this chapter that takes the condition as a hypothesis, at selfAscribed (ownClosure rel) center. paths_one_object_root's third conjunct does the same, and noOutside_iff_paths_livingSignificance specializes row 1 there. So more than one instance is proved at that significance. The kit's own replacement inside this Open item lists 'the condition's laws at its structural reading', so the item's heading and its body would disagree.
- **Evidence:** tree/Becoming/SignificanceStatements.lean: widens_iff_retains_adds_root takes (noOutside : «续无外» rel «一» center) and applies Web.widens_iff_retains_adds (ownClosure_unrestricted_iff_noOutside.mpr noOutside). The kit adds these laws' bullets under 07's home sections (make_records_u3.py).
- **Proposed:** §4.5: "one instance is proved here: …(`premises_of_noOutside`). Three more of the chapter's laws are specialized at this reading on a web's level paths, each proved through its row: the condition as living significance, widening as retaining and adding within one's own line, and the three readings of one predicate ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity))." Thesis: "and the condition on the root beyond the instances stated there." Open heading: "**The condition on the root's grammar, beyond its instances**".

### placement 4 (medium)

- **Words:** 198: "Today none of the five significance rows reaches the root, and 全四 is designed, not met." 200: "44 reach the grammar, 16 are stated at a represented model, 4 hold on their own carrier and 54 are the rest. The item is met when each of the 54 is lifted". 260: "U3's Lean items 1 and 2 put the significance rows on the root (F4)." 281: "Until then the figures of §461 stand: 44, 16, 4 and 54."
- **Problem:** The one plan keeps the old F5 figures and the old 全四 status after U3 lands. Line 281 says the §461 figures stand until the boundary record lands, but U3 changes them to 44, 16, 7 and 51 without it. Line 260 reads as though all five rows are put on the root, which F5's count does not support (see the 全四 finding). The texts kit covers FU's PROPOSAL but not WHAT-REMAINS, which is the plan FU says governs.
- **Evidence:** texts_u3.py PROJECTED = {44, 16, 7, 51}; FU PROPOSAL line 5: "The one plan is WHAT-REMAINS".
- **Proposed:** At landing, append a dated note under the release gate, for OU's owner or through U3's board row: "*(U3 landed, `<commit>`, study §N.)* `Web.paths_extension_iff_widens`, `Web.paths_comparison_widens` and `Weighting.widens_iff_every_positive` are stated in the grammar's terms on their own carrier. The other three significance rows are stated at the structural reading, specializations F5 does not count. F5: 44, 16, 7 and 51. Gate item 1: <OU's owner's verdict>." Line 281 becomes "Until then the figures of U3's landing stand: 44, 16, 7 and 51."

### placement 5 (medium)

- **Words:** FU: "rows 1, 8 and 9 are stated there", "F5 counts rows 5, 7 and 10". Study: "rows 5, 7 and 10 restated …, and rows 1, 8 and 9 specialized", "Row 1, a specialization"
- **Problem:** 'Row 1' collides with the numbering these texts borrow. DESIGN §1 says the numbers 5 to 10 are OU3c's audit rows and that unrestricted_iff_livingSignificance 'has no number there'. OU3c's row 1 is Learning.goAlike_iff_lumped, so 'row 1' names a different declaration in the table the numbers come from. FU's PROPOSAL never numbers rows at all: it lists the five significance rows by name, and row 5 is not among them. A reader of FU's outcome cannot map 'rows 5, 7 and 10' or 'rows 1, 8 and 9' to declarations. FU's 'are stated there' should also say 'specialized'.
- **Evidence:** ou3c-anchors-on-the-grammar/AUDIT.md:24: "| 1 | `Learning.goAlike_iff_lumped` |"; DESIGN.md:21-22; FU PROPOSAL line 73 lists the five rows by name.
- **Proposed:** In FU's outcome, name the declarations instead of numbering them, for example "`unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` are specialized there". In the study, give the key once, in the opening paragraph: "(rows 5 to 10 are OU3c's audit rows; 'row 1' is U3's label for `unrestricted_iff_livingSignificance`, which that table does not number, and not OU3c's row 1)".

### placement 6 (medium)

- **Words:** "The structural reading of significance is the design's choice of carrier (DESIGN §2)"
- **Problem:** 'Carrier' is used outside its sense. A carrier is the type a relation is on (glossary: relation, model), and in U3 it means a web's level paths or a finite list, as in 'their own carrier'. The structural reading fixes sig = selfAscribed (ownClosure rel) center, a reading of significance, not a carrier. DESIGN §2 also does not choose the reading. It says the reading is not shown to be the right one: the step of invariance, which stays open.
- **Evidence:** GLOSSARY.md: "relation … a two-place predicate on a carrier"; "model … a carrier, a relation read as condition and the classes used". DESIGN.md §2: "That the structural reading is the right one … stays open."
- **Proposed:** "The structural reading of significance (`sig = selfAscribed (ownClosure rel) center`) is a reading the design supplies, not shown to be the right one: which relation a center's own line runs along is the step of invariance's question (07 §4), open (DESIGN §0, §2)."

### placement 7 (medium)

- **Words:** "Significance's central laws are stated in the grammar's terms, comparison by widening and what every positive weighting ranks on their own carrier, and the condition's laws at its structural reading, a specialization ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity));"
- **Problem:** In the root chapter's item on the root and the ethics, 'stated in the grammar's terms' appears with no 'not derived' qualifier. 07's version of the same sentence has "each proved through its row and none derived", and 08 §7 relies on the difference between a statement and a derivation. 'A specialization' is singular for several laws. The subject differs from 07's ('The laws of significance's central declarations') for the same set of laws.
- **Evidence:** 07 edit: "each proved through its row and none derived". 08 §7: "a representation and not a derivation".
- **Proposed:** "The free significance of 07 §1 is not lifted. Significance's central laws are stated in the grammar's terms, each proved through its row and none derived: comparison by widening and what every positive weighting ranks in full on their own carrier, and the laws taking the condition only at its structural reading, specializations ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)); the ethics' other laws are instances not yet stated on the root;"

### placement 8 (medium)

- **Words:** "- Widening on paths is the grammar's `«广»` of what a path admits, and C holds with "better" read as that `«广»`…" and "`«广»` over a listing is what every additive natural-number weighting positive on the listed items ranks higher."
- **Problem:** The first clause is OU3b's bridge Web.widens_iff, landed before U3, not U3's result. Row 5's actual content, that an extension with every claim counted is «广» of what the paths admit (paths_extension_iff_grammar), is missing, and so is row 7's scope ('for every reading of living'). The weighting bullet drops two-valued admission, a limit the Lean review had restored in the law texts.
- **Evidence:** SignificanceStatements.lean: paths_extension_iff_grammar is `W.paths_extension_iff_widens.trans Web.widens_iff`; paths_comparison_grammar takes `(living : F × Nat → Prop)`. REVIEW-U3-LEAN astra 3: state 'Boolean admission'.
- **Proposed:** "- An extension of level paths with every claim counted is the grammar's `«广»` of what the paths admit (`paths_extension_iff_grammar`), and for every reading of `living` C holds with "better" read as that `«广»` (`paths_comparison_grammar`), its being better C's content, supplied." and "- Weightings meet the root through one interface law: on a finite list with two-valued admission, `«广»` is what every additive natural-number weighting positive on the listed items ranks higher. …"

### placement 9 (low)

- **Words:** "Of the 7 resting on an anchor without reaching it, … so F5 takes none as an item. So F5's report, over the 118, counts 44 reaching the grammar, 16 stated at a represented model, 7 stated on their own carrier only, and 51 the rest."
- **Problem:** The sentence reads correctly in its paragraph and the counts and their reason are right. Two different 7s sit a sentence apart, though, and the 7 on their own carrier does not follow ('So') from the text: the paragraph never says that 4 of U2's 20 are on their own carrier. A reader can take the second 7 to be the first. 'Takes none' after 'a specialization' is also loose.
- **Evidence:** master-laws.json central_reach before U3: 44/16/4/54. The 4 on their own carrier are U2's items (F5 spec, rows 7, 9, 12, 23). The anchor-not-reached 7 are Direction.extension_iff_widens, PartForms.goAlike and U3's five.
- **Proposed:** "…and specializes two at that reading; a specialization states less than its row, so F5 takes none of the three as an item. So F5's report, over the 118, counts 44 reaching the grammar, 16 stated at a represented model, 7 stated on their own carrier only (U2's 4 and U3's 3), and 51 the rest."

### placement 10 (low)

- **Words:** "The laws of significance's central declarations are stated … and the condition's laws at its structural reading, a specialization, each proved through its row and none derived"
- **Problem:** 'Laws of … declarations' is redundant, since the declarations are the laws. 'A specialization' is singular for three laws. 'None derived' leaves open 'derived from what'.
- **Evidence:** As quoted.
- **Proposed:** "Significance's central laws are stated in the grammar's terms, comparison by widening and what every positive weighting ranks in full on their own carrier, and the laws taking the condition only at its structural reading, specializations; each is proved through its row and none is derived from the root ([08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity)); the chapter's other laws are instances not yet stated on the root."

### placement 11 (low)

- **Words:** "08 §7's counts and the one page's line on significance's central declarations; the leaf's region."
- **Problem:** The list leaves out other passages the landing changes: 01's open item, 07's Open item, the overview's line in English and Chinese, the one page's Chinese, and FU's PROPOSAL outcome.
- **Evidence:** texts_u3.py EDITS: eight edits across six files.
- **Proposed:** "…; 08 §7's counts; the lines on significance's central laws in 01's and 07's open lists, the one page and the overview (English and Chinese); FU's PROPOSAL, U3's outcome; the leaf's region."
## 4. How each finding was taken

Every finding stands on the files and every one is taken; the three readers agree on all the high and most of the medium findings, so they are grouped by what they found. OU's owner's decision on 全四 arrived in the same hour and is taken with them.

- **全四 (accuracy 0, 1; scope 0, 12; placement 1).** "Met only as F5 counts it" is gone. Both FU's outcome and the study's standing give 全四 as F4 defines it (each row has its root form, the condition and C named premises, the free predicate the general form) and F5's stricter figure beside it (two of the five, with capacity's row 5, on their own carrier; the three specializations among the rest), linking OU's note in WHAT-REMAINS, "U3's standing, and what 全四 counts". The readers' alternative, leaving the verdict to OU's owner, is settled by that note.
- **"Restatements" for the specializations, and the premises unnamed (accuracy 4; scope 1; placement 2).** The front-page sentence now says two are restated on their own carrier and three specialized, each stating less than its row, none derived from the root, and names the condition (scope) and C (order). The Chinese follows the pages' terms (以文法的词语, 推出, 定范围, 定次序).
- **The wrong bullet on the front pages (accuracy 6; scope 3; placement 0).** The sentence moves from the "Lifting" bullets, which are left unchanged (none of significance's five reaches the grammar, still true), into the bullets on the root and the ethics: the one page's "one account only in part" and the overview's "as one account", both editions, where the clause "the chapter's other laws are instances not yet stated" would otherwise contradict it.
- **"One instance" in 07 (accuracy 5; scope 4; placement 3).** 07 §4.5 says one instance is proved here and names the three more proved on a web's level paths, each in its own record; the thesis and the open item's title say "beyond the laws stated there". The record whose home section that is, the-continuation-condition-on-the-root, has its next step narrowed to the theorems beyond those three.
- **Row 10 as an interface law (scope 2).** 08 §7, 01 and 07 call it an interface law whose weights are amounts the grammar has none of; the front pages say one of the two is "through weights, amounts the grammar has none of".
- **The reading's name (scope 5).** The live chapters name it the own-closure reading (07 §4.5's label); U3's law texts, home-section labels, package rows and the leaf's docstrings now use that name, and 自闭包读法 in Chinese, as the GS2 record does. The design keeps "structural reading", SW §3's name, as a process document.
- **"None derived" (scope 5; placement 7, 10).** Now "none is derived from the root", in 01 and 07 alike; the singular "a specialization" and the redundant "laws of … declarations" are gone.
- **Row numbers (accuracy 2; placement 5).** FU's outcome names the declarations; the study defines its labels once (rows 5 to 10 are OU3c's; "row 1" is U3's label for `unrestricted_iff_livingSignificance`, not OU3c's row 1).
- **"Choice of carrier" (accuracy 3; scope 6; placement 6).** The study now calls the own-closure reading a reading the design supplies, not shown to be the right one, the step of invariance's question.
- **FU's outcome bullets (accuracy 7, 8, 9; scope 7, 8; placement 8).** Row 5's content (an extension with every claim counted is `«广»`, through OU3b's `Web.widens_iff`) and row 7's scope (every reading of `living`) are stated; two-valued admission is kept; the three are "specialized", not "stated"; the condition is `«续无外»` at the one of the relation.
- **08 §7's polish (accuracy 11; scope 10; placement 9).** "Another master law's anchor"; the other two of the 7 named with their reasons kept; "(U2's 4 and U3's 3)"; "none of the three specializations"; and U2's sentence now says its 20 are 16 at a represented model, representations, and 4 on their own carrier, as F5 counts them.
- **The study (accuracy 10, 13; scope 9; placement 11).** "Each row has a statement … proved through the row"; row 1 on a web's level paths; row 7 for every reading of `living`; "remain valid, their condition side false"; the Output → input line lists every text the landing changes.
- **The review packet (accuracy 12).** PHILOSOPHY's P-entry for GrammarScope and BUDDHIST-THOUGHT's known weakness say one instance is proved here and three central laws are specialized at this reading (U3); the packet is live, as LW's edits to P-26 are.
- **WHAT-REMAINS (scope 12; placement 4).** OU's owner's document: U3 edits none of it, and gives its owner the new figures (44, 16, 7, 51) at landing.
