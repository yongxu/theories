# Review of OC5 before landing

*Kept by the lander.* One independent, read-only review of OC5 (board item OC5, the crux's structure as laws), by a separate AI agent given the worktree at `1bfaf23b5` and the drafts of the record and the study section, before the core checker's run. It could not write in the repository, so it returned its report as text. The report follows verbatim from its heading (a note on how it was delivered, before the heading, is left out), with two changes: its `>` characters, escaped in transit, are restored, and its scratch paths name `review-oc5/` beside this report, where its files are kept. "R" in the report is the reviewer's scratch folder for the drafts. The lander's verification of each finding, and what was done, follow the report.

---

This is one independent, read-only review of worktree `wt-oc5` (branch `oc5` at 1bfaf23b5, based on 7937f5f7c).
- **GP** means `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarPath.lean`.
- Line numbers are the worktree's.
- **Scratch** means a check in the scratch Lean file. Every one has an empty axiom report.

**Result.** No proof is wrong.
- The six new laws, `OtherLeaves`, `FinerWake.finer_class` and the two re-derived proofs compile from verbatim copies, importing only `Init`, with empty axiom reports.
- The statements of `«本类常闭则后皆续»` and `«闭则外分无关»` are unchanged from 7937f5f7c.
- Against the prose and the record there are **19 findings: 3 errors, 4 imprecise, 5 unclear and 7 suggestions.**

## Findings

### 1. Error: the record's statement turns the division law around

**Place.** `R/record-draft.json`, `statement`.
- en: "Where the member acts, it and alike occurrences must follow each other, so only its own leaving effects bear on the division outside."
- zh: "员有所缘时，员与同类者须相随，故唯其己出类之效系于类外之分。"

**What is wrong.** `«外分唯系己出之同»` (GP l.479) says the reverse. How what lies outside is divided bears on the condition at the member's class, and only through what is alike to the member's own leaving effects. The statement instead makes the effects bear on the division, and it leaves out the condition. The record's own law 3 (first sentence) and its history line both have the right direction.

**Replacement.** In English, only the last clause changes, and the statement is 299 characters:
```text
Constancy up to the net's end at a member's class carries the path's laws; the reach needs only that the class hold the effects of the member and all after it. Where the member acts, it and alike occurrences must follow each other, so the division outside bears only through its own leaving effects.
```
The zh uses the history line's own wording:
```text
于员之类之至网之终有常足承此路诸律；此及唯须类持员及其后一切之所缘。员有所缘时，员与同类者须相随，故类外之分唯经其己出类之效而入。
```

### 2. Error: the record's eighth law leaves out "where the member conditions something"

**Place.** `R/record-draft.json`, `laws[7]`.
- en: "With them the condition at the member's class gives the reach, and holds the effects of every alike occurrence, but the reach does not need it:"
- zh: "持之，则员之类之至终有常足致此及，并持每一同类者之所缘，而此及不须之："

**What is wrong.** `«本类常闭则所缘同类»` (GP l.251) needs `goes : ∃ w, R m w`, and without it the claim is false. Scratch `Idle.counter` is a counterexample:
- The occurrences are `m`, `u` and `x`. Only `u` conditions anything, namely `x`.
- The class is {m, u} against {x}.
- The condition holds at the member's class, and the member's effects are held (vacuously).
- `u` is alike to the member, but its effects are not held.

The chapter, the module doc, the study and the record's correspondence all keep the acting clause.

**Replacement.** en:
```text
With them the condition at the member's class gives the reach and, where the member conditions something, holds the effects of every alike occurrence; but the reach does not need it:
```
zh:
```text
持之，则员之类之至终有常足致此及，员有所缘时并持每一同类者之所缘；而此及不须之：
```

### 3. Error: P-20's sixth question compares the path's need with P2 alone

**Place.** `theories/becoming/review/PHILOSOPHY.md` l.408:
> "6. The path needs less than P2: that the class of one's line hold the effects of oneself and of everything downstream of one's acts (`«后皆同类当且仅当自与后皆闭»`)." … "If what one presupposes is a regularity of one's own, must it reach beyond one's own line?"

**What is wrong.**
- **(a) P2 does not imply the need.** The two are incomparable (scratch `p2_and_need_incomparable`).
  - In `FiniteWake` the member acts and P2 holds at it (`FiniteWake.constant_to_end` with `«至终有常则本类至终有常»`). There is still no reach, because the member's effects are not held (`FiniteWake.not_held` with `«后皆续则所缘同于»`).
  - `OtherLeaves` is the converse.
  - The question's next sentence ("Given P4 and acting, P2 gives that and more") has the right comparison.
- **(b) A citation is missing.** The left side of the cited law is "everything downstream is alike", not the reach. The bridge `«后皆续当且仅当后皆同类»` belongs here too, as the conclusion paragraph has it.
- **(c) "Must it reach beyond one's own line?" misuses "reach".** "Reach" is the path's word for the scope of concern, and that scope already goes across lines. What P2 adds is a demand on occurrences alike to oneself that lie off one's line.

**Replacement.**
```text
6. The path needs less than P2 and P4 together: that the class of one's line hold the effects of oneself and of everything downstream of one's acts (`«后皆续当且仅当后皆同类»`, `«后皆同类当且仅当自与后皆闭»`). P2 alone does not give that, even where one acts: a class can meet P2 without holding one's effects (`FiniteWake`). Given P4 and acting, P2 gives that and more: the class then holds the effects of every occurrence alike to oneself, off one's line included (`«本类常闭则所缘同类»`); and a class can meet the path's need without P2 (`OtherLeaves.reach_without_condition`). If what one presupposes is a regularity of one's own, must it hold of the occurrences alike to oneself that lie off one's own line, or only along that line?
```
If finding 4's law lands, add this before the last sentence:
```text
Like P2 (`«亡而网续则本类不至终有常»`), the path's need lets one's line, once it takes a step, end only where the net does (`«亡而网续则后不皆续»`), so the first question's alternative does not by itself separate them.
```
If finding 13's line form lands, "only along that line" becomes exactly the path's need.

### 4. Unclear, and substantive for P-20: the denial the chapter calls coherent does take the reach away

**Place.**
- 07 l.391. It follows "Denying P2 is coherent, since one can presuppose the significance of a line that ends while its last stage still conditions something.":
  > "Denying it does not by itself take the reach away: without P2, the reach holds exactly where the class of one's line holds the effects of everything downstream of one's acts as well as one's own (`«后皆同类当且仅当自与后皆闭»`, `OtherLeaves`)."
- PHILOSOPHY.md l.391:
  > "if P2 fails, it is reached exactly where the class of one's line still holds the effects of everything downstream of one's acts (`«后皆同类当且仅当自与后皆闭»`, as in `OtherLeaves`), and otherwise rests on the step."

**What is wrong.** Both sentences are true, but the denial the chapter has just named does take the reach away.
- **The reach rules out an ending line.** No point of one's line may end while it still conditions something (scratch `reach_ends_where_net_ends`).
- **As one declaration**, `«亡而网续则后不皆续»`: where a line from the member ends at `y` while `y` still conditions something, not everything downstream of the member lies on its line.
- **The organism has no reach.** Its class in `FiniteFamilies` has none (scratch `FiniteFamilies.member_no_reach`).
- **The only survivor is the `OtherLeaves` case.** There P2 fails through an occurrence alike to oneself that is off one's line, not through one's own line ending.
- **This matters for the first question.** The path's need already has the feature that the question gives to "a regularity of one's own", so that feature does not tell P2 apart from what the path needs.

**Replacement.** In 07 l.391, for the quoted sentence:
```text
Denying it does not by itself take the reach away: without P2, the reach holds exactly where the class of one's line holds the effects of everything downstream of one's acts as well as one's own (`«后皆续当且仅当后皆同类»`, `«后皆同类当且仅当自与后皆闭»`), as in `OtherLeaves`, where P2 fails through an occurrence alike to oneself off one's line. The denial just named takes it away: where one's line ends while its last stage still conditions something, not everything downstream of one's acts lies on one's line (`«亡而网续则后不皆续»`).
```
In P-20 l.391, for the quoted clause:
```text
if P2 fails, it is reached exactly where the class of one's line still holds the effects of everything downstream of one's acts (`«后皆续当且仅当后皆同类»`, `«后皆同类当且仅当自与后皆闭»`, as in `OtherLeaves`), never where one's line ends while its last stage still conditions something (`«亡而网续则后不皆续»`), and otherwise rests on the step.
```
Optionally, in 07 l.357, after "So the reach asks that the class hold the member's effects (`«后皆续则所缘同于»`).":
```text
Like the condition at the member's class (`«亡而网续则本类不至终有常»`), the reach excludes a line from the member that ends while its last stage still conditions something (`«亡而网续则后不皆续»`).
```
**The law to land.** It goes in GP after `«后皆同类当且仅当自与后皆闭»` (l.187–195) and is cited in record law 7 (scratch C10):
```lean
/-- **Where a line from a member ends while it still conditions something, not everything downstream of the member
lies on its line (亡而网续则后不皆续).** Like the condition at the member's class (`«亡而网续则本类不至终有常»`), the
reach excludes such a line; no regularity is assumed. -/
theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => ends ⟨w, hw, hE.trans (hE.symm («线内同类» hE line))
      ((«后皆续当且仅当后皆同类» hE).mp reach w
        («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one hw)))⟩
```
**Optional witness.** It goes in `namespace FiniteFamilies` after `member_not_constant_at` (scratch C13):
```lean
/-- **The organism's class does not take in everything downstream of the first member**: its line ends at the
member's old age, which still conditions the second member's birth. -/
theorem member_no_reach : ¬ ∀ t, «及» step (false, 0) t → «所及» step member (false, 0) t :=
  «亡而网续则后不皆续» (m := (false, 0)) (y := (false, 1)) member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩
```
Without the law, the new text would rest on a hand argument from the definition of `«亡»`, and AGENTS.md asks for Lean behind every new proof claim.

### 5. Imprecise: "only [the member's own leaving effects] bear on it"

**Place.**
- (a) 07 l.358: "So only the member's own effects that leave the class bear on it: two classes that give the member the same class, and agree on what is alike to each of those effects, give the same verdict (`«外分唯系己出之同»`)."
- (b) GP l.79–80: "So only what is alike to the member's own effects that leave the class bears on it (`«外分唯系己出之同»`)"
- (c) `Becoming.lean` l.3634: "so only what is alike to its own effects that leave the class bears on it"
- (d) record `laws[3]`, en: "so only what is alike to the member's own effects that leave the class bears on it"; zh: "故唯与员己出类之效同类者系于此条件"
- (e) package `README.md` l.308: "so only its own effects that leave the class carry the division of what lies outside"

**What is wrong.**
- "It" is the condition, and much more than the member's own leaving effects bears on it. In `OtherLeaves` the member has no leaving effect, yet the condition fails through another occurrence's leaving effect (`OtherLeaves.not_constant_at`, GP l.782).
- The law limits how *the division* bears on the condition. The colon gloss in (a) says so; the main clause does not.
- In (e), "carry the division" is vague.
- `check_becoming.py` l.216–217 already gets it right.

**Replacement.**
- (a):
  ```text
  So how what lies outside is divided bears on it only through what is alike to the member's own effects that leave the class: two classes that give the member the same class, and agree on what is alike to each of those effects, give the same verdict (`«外分唯系己出之同»`).
  ```
- (b): see finding 6.
- (c): "so how what lies outside is divided bears on it only through what is alike to its own effects that leave the class"
- (d), replacing to the end of the law:
  - en: "so how what lies outside is divided bears on it only through what is alike to the member's own effects that leave the class, and is idle where the class holds the member's effects."
  - zh: "故类外之分唯经与员己出类之效同类者系于此条件，类持员之所缘时，类外如何分无关。"
- (e): "so the division of what lies outside bears on it only through what is alike to its own effects that leave the class"

### 6. Unclear: the module doc's "those effects"

**Place.** GP l.80–81: "and where the class holds those effects, none leaves and the division is idle (`«闭则外分无关»`)."

**What is wrong.** "Those effects" points back to the member's effects that leave the class, which no class holds. `«闭则外分无关»` is about holding all of the member's effects.

**Replacement.** This also fixes 5(b):
```text
So how what lies outside is
  divided bears on it only through what is alike to the member's own effects that leave the class
  (`«外分唯系己出之同»`), and where the class holds the member's effects, none of them leaves and the division
  is idle (`«闭则外分无关»`).
```

### 7. Unclear: P-20's new gloss of P2

**Place.** PHILOSOPHY.md l.381: "Where one acts, that is, oneself and each occurrence alike to oneself follow each other in what they condition (`«本类常当且仅当与己相随»`, a root theorem)."

**What is wrong.** "That is" reads as if it glossed "where one acts". The dossier is meant to be read without the chapter, and it never says what "follow each other" means.

**Replacement.**
```text
Where one acts, the condition is that oneself and each occurrence alike to oneself follow each other in what they condition: whatever an occurrence alike to oneself conditions is alike to something one conditions, and whatever one conditions, each alike occurrence that conditions anything conditions something alike to it (`«本类常当且仅当与己相随»`, a root theorem).
```

### 8. Unclear: "Neither premise can be dropped" next to "the regularity is not needed"

**Place.**
- GP l.91: "* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's". The same bullet now says "Holding the member's effects is needed for the reach itself (`«后皆续则所缘同于»`); the regularity is not:".
- GP l.586: "/-! ## Neither premise can be dropped -/". The section now holds `OtherLeaves`.
- 07 l.331: "- **Witnesses.** Neither premise can be dropped:"
- `Becoming.lean` l.3610: "Witnesses that neither premise can be dropped (`Unclosed`, `Inconstant`),"
- `check_becoming.py` l.207: "witnesses that neither premise can be dropped, a finite net with two families"

**What is wrong.** The plain words now clash.
- Each premise is needed *for these laws* (`Unclosed`, `Inconstant`).
- Only holding the member's effects is needed *for the reach* (`OtherLeaves`).
- `OtherLeaves`' own comment says it well: "The regularity cannot be dropped (`Inconstant`) but is not needed for the reach."

**Replacement.**
- GP l.91: "* **Neither premise can be dropped from these laws; only one is needed for the reach.** Where a member's line runs through a condition but the member's"
- GP l.586: "/-! ## Witnesses -/"
- 07 l.331: "- **Witnesses.** Neither premise can be dropped from these laws, though only holding the member's effects is needed for the reach itself ([below](#r-constancy-read-at-a-members-class)):"
- `Becoming.lean` l.3610:
  ```text
  Witnesses that neither premise can be dropped from these laws (`Unclosed`, `Inconstant`),
  ```
- `check_becoming.py` l.207: "witnesses that neither premise can be dropped from these laws, a finite net with two families"

### 9. Imprecise: the record's history line says the condition gives what the reach needs

**Place.** Record `history`, last entry.
- en: "which the condition gives but the reach does not need (OtherLeaves)"
- zh: "此条件致之而此及不须之（OtherLeaves）"

**What is wrong.** The condition alone does not give it (`FiniteWake`, as in finding 3). It gives it only with the member's effects held (`«本类常闭则后皆续»`).

The same line's "Study section 0" is a draft placeholder, which `make_record_oc5.py` fills in at landing.

**Replacement.**
- en: "which the condition gives with the member's effects held, but the reach does not need the condition (OtherLeaves)"
- zh: "此条件偕持员之所缘致之，而此及不须此条件（OtherLeaves）"

### 10. Imprecise: the description of `OtherLeaves`, and "off its line"

**Place.** 07 l.357: "In a net where a member conditions one thing, that thing conditions another, and an occurrence alike to the member conditions only something outside the class, the class holds the member's effects and everything downstream of the member lies on its line, while the class fails the condition at the member and does not hold the other occurrence's effects (`OtherLeaves.reach_without_condition`, `OtherLeaves.other_not_held`)."

**What is wrong.**
- The class is never given.
- "Nothing else is conditioned" is missing, though the reach depends on it. The chapter's other witness descriptions include it.
- Several texts say the other occurrence is "off its line": GP l.97, the docstring at l.788, record law 7, P-20's question 6 and the study. No Lean states it: `other_not_held` proves only `E m c ∧ ¬ «所缘同于» … c`.

**Replacement.**
```text
In a net where a member conditions one thing, that thing conditions another, an occurrence alike to the member conditions a further thing, and nothing else is conditioned, the class that holds all of them but that further thing holds the member's effects and everything downstream of the member lies on its line, while the class fails the condition at the member and does not hold the effects of the other occurrence, which lies off the member's line (`OtherLeaves.reach_without_condition`, `OtherLeaves.other_not_held`, `OtherLeaves.other_off_line`).
```
The Lean goes in `namespace OtherLeaves` after `other_not_held` (scratch C9):
```lean
/-- **The occurrence alike to the member is off its line**: nothing downstream of `m` is `c`. -/
theorem other_off_line : ¬ «及» step .m .c := fun down => Bool.noConfusion (reached_after down rfl)
```

### 11. Imprecise: "lies on no line under one's class"

**Place.** 07 l.383: "P4 is its first step and cannot be dropped at all (`«后皆续则所缘同于»`): an effect not alike to oneself lies on no line under one's class (`«线内同类»`), as `Unclosed` shows for a line that runs through a condition."

**What is wrong.** `«线内同类»` (Grammar.lean l.690) says that the two ends of a line are alike. An effect not alike to oneself can lie on a line under one's class that starts elsewhere; it lies on none from oneself. The wording predates OC5, which carried it into the rewritten paragraph.

**Replacement.**
```text
an effect not alike to oneself lies on no line from oneself under one's class (`«线内同类»`)
```

### 12. Unclear: the record's next step asks "which of these" one presupposes

**Place.** Record `next_delta`.
- en: "Which of these one presupposes is put to philosophers (P-20)."
- zh: "所预设者为何，交哲学家（P-20）。"

**What is wrong.** "These" most naturally refers to the two correspondences, which are empirical, not presuppositions. The old sentence "The crux, P4, is put to philosophers." was dropped, though P4 is still the crux.

**Replacement.**
- en: "Whether one presupposes P2, or only what the path needs, is put to philosophers (P-20, question 6); so is the crux, P4 (question 2)."
- zh: "所预设者为 P2 抑或仅此路所须，交哲学家（P-20 第 6 问）；关键 P4 亦交之（第 2 问）。"

### 13. Suggestion: state exactly what P2 with P4 gives, and what the path needs

Two laws, both checked in scratch (C12 and C14), would let the texts say "exactly" where they now say "more":
- **What P2 with P4 gives.** Where the member acts, P2 with P4 holds exactly where the class holds the effects of every alike occurrence and each of them settles whether it conditions anything.
  - P2 supplies the settling.
  - The pure core needs it for the converse.
  - The proposed name leaves that conjunct out.
- **What the path needs.** It is exactly that the class hold the effects of the member and of each stage of its line.

Question 6's contrast then becomes exact. P2 with P4 asks the holding at every occurrence alike to oneself; the path asks it only along one's own line.
```lean
/-- **Where the member conditions something, the condition at its class with the holding of its effects is exactly
that the class holds the effects of every occurrence alike to it, each of which settles whether it conditions
anything (本类常闭当且仅当同类皆闭).** -/
theorem «本类常闭当且仅当同类皆闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    («本类至终有常» R E m ∧ «所缘同于» R E m) ↔
      (∀ u, E m u → «所缘同于» R E u) ∧ (∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :=
  ⟨fun ⟨atClass, held⟩ =>
     ⟨fun _ mu _ step =>
        hE.trans (hE.symm mu) (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step)),
      fun u mu => match goes with
        | ⟨w, hw⟩ => match atClass m u (hE.refl m) mu w hw with
          | .inl ⟨v, hv, _⟩ => .inl ⟨v, hv⟩
          | .inr stops => .inr stops⟩,
   fun ⟨all, decided⟩ =>
     ⟨fun u u' mu mu' v step => match decided u' mu' with
        | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (all u mu v step))
            (hE.trans (hE.symm mu) (hE.trans mu' (all u' mu' w hw)))⟩
        | .inr stops => .inr stops,
      all m (hE.refl m)⟩⟩

/-- **Everything downstream of a member lies on its line exactly where the class holds the effects of the member
and of each stage of its line (后皆续当且仅当自与线皆闭).** No regularity is assumed. -/
theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔
      «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y :=
  ⟨fun reach =>
     ⟨«后皆续则所缘同于» hE reach,
      fun y line v step => hE.trans (hE.symm («线内同类» hE line))
        ((«后皆续当且仅当后皆同类» hE).mp reach v
          («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one step)))⟩,
   fun ⟨held, along⟩ =>
     have next : ∀ {a b : α}, «所及» R E m a → R a b → «相续» R E m b := fun onLine step =>
       match onLine with
       | .inl e => by cases e; exact .one ⟨step, held _ step⟩
       | .inr line => «及之传递» line (.one ⟨step, along _ line _ step⟩)
     have go : ∀ {a t : α}, «及» R a t → «所及» R E m a → «相续» R E m t := fun d => by
       induction d with
       | one step => exact fun onLine => next onLine step
       | more step _ ih => exact fun onLine => ih (.inr (next onLine step))
     fun _ down => .inr (go down (.inl rfl))⟩
```

### 14. Suggestion: "every stage downstream of its acts"

**Place.**
- Record `correspondence`, `does_not_show` (the new item) and `next_delta`.
- The study draft's "Supplied premises".
- zh: "其行之下游每一阶之所缘".

**What is wrong.** Both readings of "stage" are correct, but neither matches a law's wording.
- Read as any occurrence downstream, the phrase is `«后皆同类当且仅当自与后皆闭»`.
- Read as a point of one's line (as in the chapter's "last stage"), it is C14 in finding 13.

**Replacement.** "every occurrence downstream of its acts" (zh "其行之下游每一者之所缘"). If C14 lands, "every stage of its line" (zh "其线之每一阶之所缘") with C14 cited.

### 15. Suggestion: "it gives more" after "a class"

**Place.**
- 07 l.383: "…without it (`OtherLeaves.reach_without_condition`), and, given P4 and acting, it gives more than the reach asks…"
- P-20 l.391: "a class can meet the path's need without it, and, given P4 and acting, it gives more"

**What is wrong.** The nearest antecedent of "it" is "a class".

**Replacement.** "the regularity gives more" in both places.

### 16. Suggestion: "the member's" in a sentence about an occurrence

**Place.** GP l.26–27: "so that reach asks that the class hold the member's effects (`«后皆续则所缘同于»`)". The sentence is about "an occurrence".

**Replacement.** "the occurrence's effects".

### 17. Suggestion: "with no regularity" in mid-sentence

**Place.**
- 07 l.383: "is alike to oneself, with no regularity (`«后皆续当且仅当后皆同类»`)"
- P-20 l.391: "is alike to oneself, with no regularity:"
- README l.308 and `check_becoming.py` l.214: "with no regularity, which needs the member's effects …"
- Record `laws[7]`: "and of everything downstream of it, with no regularity;"

**What is wrong.** In mid-sentence it can be read as "the class has no regularity".

**Replacement.** "with no regularity assumed", as the docstrings have it.

### 18. Suggestion: "alike step" in two docstrings of the rebuilt module

**Place.**
- GP l.336: "/-- **What leaves the class follows each alike step (出类随行), at the member's class.**"
- GP l.348: "/-- **What leaves the class follows each alike step (出类随行).**"

**Replacement.** "follows each alike occurrence", matching the root bullet OC5 corrected. This wording is PF2's, so its owner should agree first.

### 19. Suggestion: the record's title

**What is wrong.** The title does not name the new eighth law.

**Replacement.**
- en: "Constancy read at a member's class, what the reach asks of the class, and how what lies outside it is divided"
- zh: "于员之类之至终有常，此及所须，与类外之分"

The record ID and the `r-` anchors stay as they are.

## For the lander

Findings 4, 10 and 13 would add these declarations:
- `«亡而网续则后不皆续»`
- `FiniteFamilies.member_no_reach` (optional)
- `OtherLeaves.other_off_line`
- `«本类常闭当且仅当同类皆闭»` and `«后皆续当且仅当自与线皆闭»` (optional)

Each one changes:
- `make_record_oc5.py`'s `assert len(new) == 17`
- the record's declaration lists
- "99 theorems in 149 declarations" in the study draft and LANDING-OC5.md
- the connectivity roots (`register_oc5.py`)

The study's "What changed in the texts" should follow whichever wording lands.

## Checked and found correct

- **The new laws and witnesses.** Each statement matches its docstring and name, in the core's vocabulary. This covers the six new laws, `OtherLeaves` (all ten declarations) and `FinerWake.finer_class`.
  - `«本类常当且仅当与己相随»` uses `goes` only in the forward direction.
  - In `«外分唯系己出之同»`, the `own` hypothesis puts `∀ x` outside the disjunction. Constructively that is weaker than the docstring's reading, so the theorem is at least as strong as stated.
- **The re-derived proofs.** Their statements are unchanged up to whitespace (compared by program with 7937f5f7c), and the new proofs compile. There is no circularity: each general law comes before the special one, as board rule 9 requires.
- **Counts.** Receipt 20261025T160649.851818Z has 86 theorems in 132 declarations. Adding 13 and 17 gives 99 and 149, which matches the scratch build and `make_record_oc5.py`.
- **The deferred fixes.** All four from `deferred_grammarpath.py` are applied.
- **The claims the brief named.**
  - "P4 is its first step and cannot be dropped at all" is correct (`«后皆续则所缘同于»`), apart from the wording in finding 11.
  - "P2 carries P4 on" is correct.
  - "given P4 and acting, it gives more than the reach asks" is correct, and the "more" is strict by `OtherLeaves`.
  - The kinds sentence is correct. Scratch `leaves_each_kind_one_leaves` proves both halves, and `FinerOutside` fails both under its finer division.
  - The denial sentence is true as a law; finding 4 is about its context.
  - The statement is 293 characters, and the replacement 299. Both are within the cap of 300.
- **Quotes and names.**
  - All 19 chapter quotes in P-20, and all 133 in the dossier, are verbatim.
  - The packet's `check_dossiers.py` reports 0 problems.
  - All 115 cited Lean names exist.
  - All 56 passages this report quotes occur in their files (`check_report_quotes.py`; five are line-wrapped there).
- **The rest of §4.6 and P-20.** Everything else is consistent with the change, apart from findings 4 and 8: the P2, P4 and denial bullets, step 4, the two unchanged questions, P-18, P-19 and "In plain terms".
- **Study references.** These are correct: the OC4Doubts sections B, D, D2 and E, what §423 left for this rebuild, and REVIEW-OC1's `T1.goes_needed`.
- **Labels and vocabulary.** The AI-reading labels are present. There is no new "goes on" or "alike step", `check_becoming.py` parses, and README.zh is accurate.

## Scratch Lean and axiom reports

`gen.py` copies the grammar's definitions, the new laws, the re-derived proofs and the witnesses verbatim from the worktree. The file imports only `Init`, and `checks.lean` is appended to it. Lean 4.29.1 compiles it with exit 0. All 24 `#print axioms` lines say "does not depend on any axioms":
- **The ten copied declarations:** the eight laws listed above, `OtherLeaves.reach_without_condition` and `OtherLeaves.other_not_held`.
- **The review's fourteen checks:**
  - C1 `reach_ends_where_net_ends`
  - C2 `ending_line_no_reach`
  - C3 `organism_no_reach`
  - C4 `p2_and_need_incomparable`
  - C5 `Idle.counter`
  - C6 `all_alike_held`
  - C7 `held_all_alike_gives_condition`
  - C8 `leaves_each_kind_one_leaves`
  - C9 `other_off_line`
  - C10 `«亡而网续则后不皆续»`
  - C11 `p2p4_iff_all_held`
  - C12 `«本类常闭当且仅当同类皆闭»`
  - C13 `FiniteFamilies.member_no_reach`
  - C14 `«后皆续当且仅当自与线皆闭»`

Files:
- review-oc5/checks.lean
- review-oc5/OC5Review.lean
- review-oc5/lean-run.log
- review-oc5/gen.py
- review-oc5/check_quotes.py
- review-oc5/check_report_quotes.py

## Summary

There are 19 findings: **3 errors, 4 imprecise, 5 unclear, 7 suggestions**. No proof is wrong, and all 24 axiom reports in scratch are empty.

The three that matter most:
1. **P-20's sixth question says "The path needs less than P2" (error).** P2 and the path's need are incomparable. `FiniteWake` has P2 and acting without the reach; `OtherLeaves` has the reach without P2. The need is less than P2 *and P4 together*.
2. **The denial of P2 that the chapter calls coherent does take the reach away (unclear, substantive).** That denial is a line that ends while its last stage still conditions something, and the reach itself rules out such a line. The proposed law `«亡而网续则后不皆续»` proves this in scratch. So "Denying it does not by itself take the reach away" (07 §4.6 and P-20) misleads a philosopher on exactly the alternative the first question poses.
3. **The record misstates two laws (errors).** Its statement reverses which way the division law runs. Its eighth law leaves out "where the member conditions something", without which it is false (scratch `Idle.counter`).

## The lander's verification

The lander checked each finding against the Lean and the texts before acting on it. All nineteen hold. Cross-session messaging was not available in the lander's session, so the PF line's owner could not be asked during OC5; the two findings on the PF line's wording wait for it on the board's OC5 row.

| Finding | Verified | Done |
|---|---|---|
| 1 | The statement made the effects bear on the division; `«外分唯系己出之同»` makes the division bear on the condition, only through what is alike to the member's own leaving effects. | Statement replaced as proposed, with "the member and its line" for "the member and all after it" after finding 13's line form (295 characters). |
| 2 | `«本类常闭则所缘同类»` takes `goes`; `Idle.counter` in [`review-oc5/checks.lean`](review-oc5/checks.lean) makes the claim false without it. | Law 8 says "where the member conditions something" for both what the condition gives and what it holds, as `«本类常闭则后皆续»` and `«本类常闭则所缘同类»` state them. |
| 3 | P2 and the path's need are incomparable: `FiniteWake.constant_to_end` (with `«至终有常则本类至终有常»`) and `FiniteWake.not_held` one way, `OtherLeaves.reach_without_condition` the other. | P-20's question 6 rewritten as proposed, with the line form. |
| 4 | The reach excludes a line that ends while its last stage still conditions something; the proposed law compiles. | `«亡而网续则后不皆续»` landed, proved from the line form `«后皆续当且仅当自与线皆闭»` (rule 9) rather than as proposed; `FiniteFamilies.member_no_reach` landed. 07's denial of P2, its home section, P-20's standing and question 6 say it. |
| 5 | "Only the member's own leaving effects bear on it" overstated the law: in `OtherLeaves` the condition fails through another occurrence's leaving effect. | (a) to (e) say "how what lies outside is divided bears on it only through what is alike to the member's own effects that leave the class". |
| 6 | "Those effects" pointed back to the leaving effects. | The module doc says "where the class holds the member's effects, none of them leaves". |
| 7 | P-20's gloss read as glossing "where one acts" and never said what following each other is. | Replaced as proposed. |
| 8 | The plain words clash: each premise is needed for the laws (`Unclosed`, `Inconstant`), and only holding the member's effects for the reach (`OtherLeaves`). | The four places are the PF line's wording, not changed by OC5. OC5's own text draws the distinction ("the laws above cannot drop the condition, but the reach does not need it") in 07's home section and in a module-doc bullet of its own; `OtherLeaves` moved out of the section headed "Neither premise can be dropped" to the end of the module, under "What the reach does not need". The qualifier waits for the PF line's owner. |
| 9 | The condition alone does not give the reach (`FiniteWake`, as in finding 3). | History line reworded as proposed. |
| 10 | The class was not given, "nothing else is conditioned" was missing, and "off its line" was stated by no Lean. | 07's description rewritten as proposed; `OtherLeaves.other_off_line` landed; the namespace comment says "and nothing else". |
| 11 | `«线内同类»` says the two ends of a line are alike. | "lies on no line from oneself under one's class". |
| 12 | "These" read as the two correspondences, and the crux was dropped. | next_delta replaced as proposed. |
| 13 | Both proposed laws compile (C12, C14). | C14, `«后皆续当且仅当自与线皆闭»`, landed in place of the draft's `«后皆同类当且仅当自与后皆闭»`, which follows from it with `«后皆续当且仅当后皆同类»`; the texts say "each stage of one's line". C12 was not landed: its settling conjunct is what the pure core needs for the converse, not something the account asks of a self, and the texts use only the direction `«本类常闭则所缘同类»` gives. |
| 14 | "Every stage downstream of its acts" matched no law's wording. | "Each stage of its line", with C14 cited. |
| 15 | "It" read as "a class". | "The regularity gives more", in both places. |
| 16 | The sentence is about an occurrence. | "The occurrence's effects", in OC5's own module-doc bullet. |
| 17 | "With no regularity" could be read as a property of the class. | "With no regularity assumed" in every place. |
| 18 | The two docstrings say "alike step". | The PF2 line's wording; it waits for the PF line's owner with finding 8. |
| 19 | The title did not name the eighth law. | The record's title and 07's home-section title extended as proposed; the old title stays an alias. |

After the fixes the scratch build of `Becoming.GrammarPath` has 102 theorems in 152 declarations, every axiom report empty, and `Becoming.GrammarCases` is unchanged (40 theorems in 68 declarations).
