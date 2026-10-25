# Independent review of OC1's texts against the Lean (OC2)

One reviewer, an Opus subagent working read-only, checked every text claim OC1 added or changed against `Becoming.GrammarPath` as it landed in `47b780e1c`. The primary texts were 07 §4.6, the record constancy-read-at-a-members-class and study §408. The secondary texts were the module doc and docstrings, the root module's bullet, the package README rows, the checker's scope, P-20 and the next step of what-leaves-a-class-follows-its-line. The review ran on 25 October 2026. A session restart interrupted it after the reading, and it was resumed with its context to write this report. The reviewer tested each doubt in scratch Lean (Lean 4.29.1, Init only), and those files are kept beside this note in `review-oc1/`. The report follows as the reviewer gave it, its section references unchanged.

The OC line verified each finding against the Lean before fixing it. The reviewer's scratch files compiled again with the same axiom reports. Every finding holds. What was done for each is in the study section of OC2.

## The report

I reviewed all of OC1's text against the Lean, and every proof check passed. There are 4 errors, 9 imprecisions and 4 clarity points. No proof is wrong; the problems are claims stated wider or narrower than the Lean, one Lean docstring, and parts of the labelled reading. I tested each doubt in scratch Lean (Lean 4.29.1, Init only), and those files compiled with no errors:
- `Doubts.lean` holds counterexamples T1–T11 and the lemmas suggested below.
- `InconstantAt.lean` has an empty axiom report.
- `HeldCharacterization.lean` is classical.

Nothing in the repository was touched.

### Errors

**1. The record's `correspondence.en` is false for a self that holds its effects.**
- Where: "Under the split of oneself from the rest it asks of a self that holds its effects only that its line go on at every alike step that goes on".
- Lean: from the condition at the class (`atClass`), `goes` and `held`, `«本类常闭则所缘同类»` gives that every occurrence alike to the member conditions only what is alike to it. So the condition also forbids any alike occurrence from conditioning anything outside the class.
- Counterexample T2: m→i, i→j, i→b, with the class {m,i,j} against {b}. The class holds m's effects, and every alike occurrence that conditions anything continues the line. Yet `¬«本类至终有常» step («二分» inClass) .m`.
- Under `goes` and `held` the condition is exactly "every alike occurrence conditions only alike things" (scratch `heldChar`; the backward direction is classical).
- Replace with: "Of a self that acts and holds its effects it asks, however what one leaves out is divided, that every occurrence alike to it condition only what is alike to it (`«本类常闭则所缘同类»`), so its line goes on at every alike occurrence that conditions anything; of a self drawn by intention it asks, under the split, that every alike occurrence that conditions anything leave something outside, and condition something inside wherever any alike occurrence does; the reading is the AI's." Change the zh to match.

**2. The hypothesis "a member that conditions something" is dropped in several places.**
- Where:
  - record `statement.en`: "where the class holds the member's effects how what lies outside is divided is idle, and otherwise the split asks least";
  - record law 2: "what is alike to a member whose effects the class holds conditions only what is alike to it, everything downstream is on its line";
  - Becoming.lean bullet: "where the class holds the member's effects, how what lies outside is divided is idle … and otherwise the split … asks least";
  - README.md: "idle if the class holds the member's effects and the split asks least otherwise", and README.zh.md: "类持员之所缘时类外之分无关，否则二分所问最少";
  - SCOPE: "idle where the class holds the member's effects";
  - §408 "What it says": "The division of what one leaves out matters only to a self that does not hold its effects."
- Lean: `«闭则外分无关»` and `«本类常闭则所缘同类»` both take `goes : ∃ w, R m w`.
- Counterexample T1 (`goes_needed`): m conditions nothing, so it holds its effects vacuously, while c→v and c2→v2 lie outside. The split meets the condition at m; a finer division with the same class at m does not.
- Two further defects in the record statement:
  - "fails where a line ends while the net goes on": the Lean needs the end occurrence itself to condition something;
  - "otherwise the split asks least": `«本类之常至二分»` needs a predicate that decides the member's class, and it holds whether or not the effects are held.
- Replace the record statement with: "Constancy up to the net's end asked only at a member's class carries the path's laws and fails where a line ends at an occurrence that still conditions something; where the class holds the effects of a member that conditions something, how what lies outside is divided is idle, and where a predicate decides the member's class the split of that class from the rest asks least."
- Elsewhere, insert "of a member that conditions something", and for the split "where a predicate decides the member's class". In zh: "类持一有所缘之员之所缘时…；一谓词判员之类时…".
- For §408: "matters only to a self that conditions nothing or does not hold its effects."

**3. The `«本类至终有常»` docstring is contradicted by `FinerOutside`.**
- Where: "and says nothing of how what lies outside is divided or what it conditions."
- Lean: `FinerOutside.same_class`, `split_constant_at` and `finer_not_constant_at` show the verdict at the member's class changes with how the outside is divided.
- Replace with: "It asks nothing of what occurrences outside the member's class condition, but how what lies outside is divided enters through "alike to it", for an effect that leaves the class (`FinerOutside`)."

**4. An inference in the labelled reading "Which class P2 reads" is contradicted by the Lean.**
- Where: "that sorting bears on which effects are one's own, P4's question".
- Lean: P4's predicate `«所缘同于» R E m` depends only on the member's class. `«闭则外分无关»`'s second conjunct transfers it, and scratch `heldInvariant` (no axioms) shows it is invariant under any division of the outside.
- Replace with: "that sorting changes neither which effects are alike to oneself (P4's predicate reads only one's own class) nor whether one's line ends before the net does; it asks more regularity of one's side effects."

### Imprecise

**5. "goes on" is used in a sense the glossary does not give.**
- Where:
  - the "Which class P2 reads" bullet: "every alike occurrence that goes on does", "every one that goes on does", "that goes on both conditions";
  - the organism bullet: "while what it conditions goes on";
  - record laws 2 and 5, the record correspondence, PF2's next_delta, §408 (Delta and "What it says"), the Becoming.lean bullet, and the module doc.
- Lean: the escape clause is `∀ w, ¬ R u' w`, and the hypotheses are `goes : ∃ w, R _ w` (it conditions something). The glossary's "goes on" (延, 02 §1) means continued without end along some branch. In that sense the paraphrase is vacuous on finite nets such as FinerOutside, UnevenOutside and FiniteWake.
- The zh is exact (有所缘). "alike step" also uses "step" for an occurrence.
- Replace with "every alike occurrence that conditions anything" throughout, and in the organism bullet "its line ends while its last stage still conditions something".

**6. The last sentence of the reading is valid only read with the split.**
- Where: "So it passes a self drawn by what one intends wherever every occurrence alike to that self that goes on both conditions something in its class and leaves something outside."
- It follows from `«二分本类常当且仅当内外皆随»` (scratch `splitSufficientDec`, no axioms). But P2 in the Argument reads "that class", the class of one's line. Counterexample T9 meets the sufficient condition, yet a finer division with the same class at m fails.
- "which asks least" also needs the decided predicate.
- Replace with: "So, read with the split (where a predicate decides one's class), it passes a self drawn by what one intends wherever every occurrence alike to that self that conditions anything both conditions something in its class and leaves something outside; at a class that divides what one leaves out more finely it can fail (as in `FinerOutside`)."

**7. The reading's criterion would also set aside the split's own "leaves" clause.**
- Finer divisions are set aside as "not on whether one's line ends before the net does". But the split's leaves clause is not about line-ending either.
- Counterexample T5 (CleanStep read at the member's class): under the split every line from m ends only where the net ends, yet `¬«本类至终有常» … .m`. The at-class law is `«出类不随则本类不至终有常»`.
- Add: "Even the split asks more than that one's line end only where the net does: where one leaves something outside, every alike occurrence that conditions anything must too (`«出类不随则本类不至终有常»`)."

**8. P2's gloss is a consequence of the condition, not its content.**
- Where: "asked only of what is alike to oneself …: a regularity of its own, whose line ends only where the net itself ends."
- The condition gives the gloss via `«亡而网续则本类不至终有常»`, but not conversely (T5). "Asked only of what is alike to oneself" also invites the misreading in finding 3.
- Replace with: "…asked only of the occurrences alike to oneself: whatever one of them conditions, every one that conditions anything conditions something alike to it (how what one leaves out is divided enters there); so one's line ends only where the net itself ends (`«亡而网续则本类不至终有常»`)."

**9. The Conclusion asserts under P2 alone what the cited theorem proves only with P4.**
- Where: "Given the regularity of P2, … and what is alike to oneself downstream lies on one's line from there (`«本类常闭则后皆续»`)."
- The cited theorem needs `held` (P4) and `goes`. Counterexample T4: m→b→t with the class {m,t}; the condition holds at m, t is alike and downstream, and it is not reached.
- Replace with: "and, given P4 as well, everything downstream of one's acts lies on one's line (`«本类常闭则后皆续»`)."

**10. `Inconstant` proves only the global failure, but P2 is now read at one's own class.**
- Where: the Conclusion, "without it, holding one's effects gives nothing beyond the first step (`Inconstant`)"; P-20, "neither premise can be dropped (`…`, `Inconstant.not_all_follow`)".
- `not_all_follow` proves `¬«至终有常»` (global), which does not entail failure at the member's class. Failure at the member's class is true but not in the Lean. A proof in the module's style, with an empty axiom report:
  ```lean
  theorem not_constant_at : ¬ «本类至终有常» step same .m := fun atClass =>
    match atClass .v .m rfl rfl .w trivial with
    | .inl ⟨.v, _, e⟩ => Bool.noConfusion e
    | .inl ⟨.m, h, _⟩ => h
    | .inl ⟨.w, h, _⟩ => h
    | .inr stops => stops .v trivial
  ```
- Add it and cite it in both places.

**11. Step 2 (chapter) and P-20 step 2 still cite the global form for the organism.**
- Where: "and the organism's is not (`FiniteFamilies`, above)" and "(`…`, `FiniteFamilies.member_not_constant_to_end`)".
- Under P2 at one's own class, the organism is excluded by `member_not_constant_at`; global failure does not show it.
- Replace with: "the organism's is not, even at its own class (`FiniteFamilies.member_not_constant_at`)."

**12. The correspondence named in three places covers only half the sufficient condition, and omits the split.**
- Where:
  - record next_delta: "whether the steps of actual agents each leave something outside the class of their line, so that P2 read at one's own class passes";
  - record does_not_show 3;
  - §408 Boundary.
- Replace with: "whether every occurrence alike to an actual agent that conditions anything both conditions something in the class of its line and leaves something outside it, so that P2, read with the split of that class from the rest, passes a self drawn by intention in actual nets."

**13. PF2's next_delta understates what remains open.**
- Where: "What remains is P4's question".
- The new record's own does_not_show leaves the split reading argued, not proved, and its next_delta leaves a correspondence.
- Replace with: "Reading P2 so is argued, not proved; whether actual agents meet it is a correspondence; P4's question is put to philosophers." Also fix "goes on" (finding 5).

**14. §408 overclaims with "it now holds as a law".**
- Where: "PF2 argued this from one witness; it now holds as a law."
- Only the formal part follows, as a corollary of `«二分本类常当且仅当内外皆随»` that is not itself stated in the Lean. "P2 passes a self drawn by intention" rests on two readings.
- Replace with: "PF2 showed one witness (`FiniteWake`); the sufficient condition now follows from `«二分本类常当且仅当内外皆随»`, with P2 read with the split and the class read as drawn by intention [AI reading]."

### Clarity

**15. One sentence in the Theorem block cites no declaration.** "It bears on the condition only through "alike to that effect", for an effect that leaves the member's class." It is true, but no Lean states it. Either mark it "(by the definition)" or add the lemma: two classes that agree on the member's class, and on alikeness to every effect that leaves it, give the same verdict. Scratch `onlyThroughOutsideDec` proves it with a decided predicate and no axioms.

**16. The witness bullets read as general laws.**
- "Where a member and an occurrence alike to it each condition something outside, in two different places, the split meets the condition" is false as a law (T11).
- Replace with: "In a net where a member conditions one thing outside its class, an occurrence alike to it conditions another, and nothing else is conditioned, …"
- For UnevenOutside, likewise: "In a net where a member conditions something alike to it and, of two occurrences alike outside, one conditions the member and the other only something outside, …"

**17. Little of what the removed Open item asked is still recorded in the chapter.**
- Removing the Open item is defensible: the formal part is answered, and the choice of class is answered by the labelled reading.
- But that the split reading is argued, not proved, and the remaining correspondence appear only in the record.
- Add one clause to the reading, e.g. "(not shown; see the [record])", or an Open entry. The record's history should say "answering (the formal part by laws, the choice of class by a labelled reading)".

**18. `«闭则外分无关»` states only one direction.** It goes from E to F. The text's "same verdict" follows by applying it twice (scratch `sameVerdict`, no axioms), so the claim is exact; adding the two-way form as a corollary is optional.

### Checked and found exact

- **Theorem block:**
  - bullet 1, both sentences (`«本类至终有常»`; `«至终有常之逐类»`, which needs `«类» E`).
  - Bullet 2: the 7 at-class forms carry the same hypotheses as the global ones with the condition weakened, and each global form is a one-line corollary via `«至终有常则本类至终有常»`.
  - "A line that ends while it still conditions something fails…": `«亡而网续则本类不至终有常»`, for lines of one or more steps and any relation.
  - The organism fails at the first member in both witnesses (`member_not_constant_at` ×2). The family's class and the held class meet the condition at every member.
  - Idleness with `goes`; `«外合不失本类之常»` (the text is narrower, fine); `«本类之常至二分»`; the exact split characterization; every conjunct of the FinerOutside and UnevenOutside witnesses, and their nets as described.
- **Argument:**
  - Step 4 citations: `goes` is supplied by acting, `held` by P4, `atClass` by P2, and x = m.
  - Conclusion: `«本类常闭则所及皆及»`, and `«本类常则闭当且仅当后皆同类»` (no `goes` needed).
  - `Unclosed`: constancy gives the condition at every member.
  - `ThirdFed` is stated with «有常», which matches its Lean.
  - `FiniteSharedCondition` reaches through the global form.
- **"Which class P2 reads":** "The path uses no more"; the `UnevenOutside` sentence; "idle … wherever one acts and holds one's effects"; "enters P2 only through what is alike to an effect one leaves out" (true by the definition); and the paraphrase of the split characterization, apart from finding 5.
- **Record:** laws 1, 3, 4, 6, 7; hypotheses; does_not_show 1, 2, 4; validation_scope; dependencies and related.
- **Counts and receipt:**
  - The 43 cited declarations are exactly OC1's additions (75 → 118 declarations; 77 theorems, of which 31 are new).
  - All 58 pre-existing signatures are textually unchanged.
  - 08's counts move by +31 theorems and +43 audited declarations, consistent with OC1.
  - The receipt has 118 declarations, every axiom report empty, and source sha `5ffee63e…`, which matches main and both records.
- **Study §408:** Delta (apart from finding 5), Evidence, and Self-review (2).
- **Module doc and new docstrings:** all exact except finding 3, including `member_class`, `member_not_constant_at` and the `«闭则外分无关»` body.
- **P-20:** P2 matches the chapter; the step 4 and conclusion citations are exact apart from findings 10 and 11.
- **PF2 record:** its last history entry.
