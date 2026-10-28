# UE14 re-check

28 October 2026. An independent, read-only re-check, AI-written, of board item UE14 after the fold.

What was read:
- the module [tree/Becoming/Presence.lean](tree/Becoming/Presence.lean). Its audit (`tree/.build/BecomingPresenceAxiomAudit.lean`) lists 189 names: 163 theorems and 26 definitions, 17 with `_course` in their names.
- the [note](NOTE.md) and the [first review](REVIEW-UE14.md);
- the kit (`make_records`, `texts`, `integrate`, `study`, `board`, and `apart_ue14.py`, which appeared during the re-check), and its dry run on the mirror.

Line numbers are those of the files at 12:17. Wüthrich and Callender (2017) were re-read in their arXiv text, and Stein's conditions in the Stanford Encyclopedia as well; the other sources were not re-read.

**Probe.** One module was built against an unchanged copy of the module with `scratch_build.py`: 4 theorems in 5 declarations, every axiom report empty, and the copy's compile restored from the cache. The probe stayed in the session's scratch directory; its results are given in full under R2 and R3.

## Verdict

The fold is sound, and the texts are nearly exact.
- **The Lean** is pure core as reported, and F1–F18 are all taken in the module and the prose (table at the end).
- **The course forms** say exactly what their docstrings say:
  - `every_course_iff` and `some_course_iff` are equivalences;
  - each of the other fourteen is its law composed with `natural_iff_course`, with that law's decision (an instance, weak decidedness, or none) and its bounds unchanged.
- **The literature** is cited at the right strength:
  - Wüthrich and Callender's relation is `PastOrPair`, pair for pair (their eleven pairs);
  - their non-Hegelian subsets are distinct elements with one relational profile;
  - they grant a local, observer-dependent becoming, and argue for a global one in which only the number born is determinate;
  - Stein is read as a maximum.
- **The readings** carry their label, and keep the continuation condition to scope and calling widening better (C) to order.

Six places should change before landing:
- a Chinese law reverses precedence (R1);
- "off the diamond the join is not their relation" is false as a general claim, on the module's own vee (R2);
- `past_every_iff`'s calibration is called exact where the Lean proves one direction (R3);
- the record's statement calls the bound on some course what every course keeps (R4);
- summaries drop "given by a test" (R5) or the decisions (R6).

R7–R10 go with the landing; R11–R14 are small.

## Findings

Severity: **E** error, **O** over- or understatement, **I** improvement, **S** style.

**R1 (E). A Chinese law reverses the order.**
- *Where:* `make_records_ue14.py`:83, law 1, zh: "每元置于其所先者之后".
- *What it says:* each element is placed after what it precedes. In the kit's own usage, "i 所先者" is what `i` precedes (:206).
- *What the Lean says:* the English, and `KeepsOrder` (`c.prec i j → π i < π j`), place each element after what precedes it.
- *Fix:* "每元置于先于之者之后".

**R2 (O). "Off the diamond the join is not their relation" is false as a general claim.**

Where:
- the module, Presence.lean:88–89 and :1922;
- the note, NOTE.md:14, :78 (the heading), :90 and :103;
- the record: the law (:261, and zh :264 "此并非其关系") and the correspondence ("not elsewhere" :375, "他处不然" :380);
- 08 §8, "elsewhere not" (`texts_ue14.py`:79);
- the study, "the join on their four elements only" (`study_ue14.txt`:97);
- `apart_ue14.py`:72.

What the Lean shows: `SameFuture` gives one causal set where the join is not their relation and is not transitive. Nothing shows that the join differs everywhere off the diamond.

The texts read their relation in general as the past with its non-Hegelian pairs (NOTE:78). On that reading the universal claim fails on the module's own vee. There `1` and `2` share their past (`0`) and their future (none), and the join is exactly the past with that pair (probe):

```lean
theorem vee_future_one_two (k : Nat) : Vee.vee.prec 1 k ↔ Vee.vee.prec 2 k :=
  ⟨fun pair => absurd pair.1 (by decide), fun pair => absurd pair.1 (by decide)⟩

def VeePastOrPair (a b : Nat) : Prop :=
  a = b ∨ Vee.vee.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)

instance (a b : Nat) : Decidable (VeePastOrPair a b) :=
  inferInstanceAs (Decidable (a = b ∨ Vee.vee.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)))

theorem vee_pastOrTogether_iff {a b : Nat} (ha : a < 3) (hb : b < 3) :
    PastOrTogether Vee.vee a b ↔ VeePastOrPair a b := by
  constructor
  · intro h
    rcases h with p | every
    · exact .inr (.inl p)
    · have same := (together_every_iff Vee.ordered ha hb).mp every
      have f0 := same 0
      have f1 := same 1
      have f2 := same 2
      revert f0 f1 f2
      rcases below_three ha with rfl | rfl | rfl <;>
      rcases below_three hb with rfl | rfl | rfl <;> decide
  · intro pair
    rcases pair with e | p | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr fun k =>
        Eq.subst (motive := fun z => Vee.vee.prec a k ↔ Vee.vee.prec z k) e Iff.rfl)
    · exact .inl p
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr vee_future_one_two)
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr fun k => (vee_future_one_two k).symm)
```

Fix: write "need not be" for "is not" throughout.
- Presence.lean:88–89: "Off the diamond that join need not be their relation: …". Presence.lean:1922: "Off the diamond that join need not be their relation (…)".
- The record's law: "Off the diamond the join need not be their relation: …"; zh "此四元之外，此未必为其关系：…".
- The correspondence: "…, not in general." / "…，他处未必然。".
- 08 §8: "…, elsewhere not in general."
- The study: "Wüthrich and Callender's relation is the join on their four elements, and a witness off them shows that the join need not be their relation and need not be transitive."
- `apart_ue14.py`: "…showing that off Wüthrich and Callender's four elements the join need not be their relation".
- The note: likewise.

Already right: the 01 paragraph, the root bullet, the checker's scope and the board row ("need not be transitive").

**R3 (O). `past_every_iff`'s calibration is called exact; the Lean proves one direction.**

Where:
- Presence.lean:69–73: `past_every_needs_decision` is listed among calibrations that "are each exactly excluded middle".
- The record: "and so does past_every_iff from left to right" (:162–166; zh "亦然"), and the counterexample at :388 ("the decided forms of the laws on every course are each exactly excluded middle").
- The 01 paragraph: "excluded middle for the laws on every course in their decided forms" (`texts_ue14.py`:48).
- The study, `study_ue14.txt`:48–51.
- The note, NOTE.md:69, :89 and :116.

What the Lean says: `past_every_needs_decision` proves only that the law gives `∀ p, Decided p`, which is what the record's own hypothesis says ("gives it too", :333). The converse holds in the pure core (probe):

```lean
theorem past_every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → π y ≤ π x) → y = x ∨ c.prec y x) ↔ ∀ p : Prop, Decided p :=
  ⟨past_every_needs_decision,
   fun em c ordered x y hx hy every => match Nat.decEq y x with
   | .isTrue same => .inl same
   | .isFalse ne => .inr (every_iff_em.mpr em c ordered y x hy hx fun π σ natural =>
       match Nat.eq_or_lt_of_le (every π σ natural) with
       | .inl same =>
         absurd (((natural.at hy).2.symm.trans (congrArg σ same)).trans (natural.at hx).2) ne
       | .inr lt => lt)⟩
```

Fix, one of:
- (a) Add the theorem to the module (164 theorems in 190 declarations), and cite it beside `past_every_needs_decision`.
- (b) Reword.
  - Presence.lean:70: "for being born before (`every_iff_em`)". After "are each exactly excluded middle", add ", and `past_every_iff` from left to right gives it (`past_every_needs_decision`)".
  - The record: "…, and past_every_iff from left to right gives it, …"; zh "…，past_every_iff 自左至右亦给出之；…".
  - 01: "excluded middle for the decided forms of born before, present together and the least element above on every course".
  - The study and the note likewise.

Either way, the generic "each decision is exactly excluded middle or its weak form" also covers decisions never calibrated: membership in `stem_born_first`, and `past_largest`. It occurs in `integrate_ue14.py`:56 and :84, `board_ue14.py`:42, the README rows ("each decision exact", "每一判定皆确切") and the record's history (:492). Write "each calibrated decision" there.

**R4 (O). The record's statement calls the bound on some course what every course keeps.**
- *Where:* `make_records_ue14.py`:310–314: "what every course keeps of it is defined from precedence: a condition is present at a birth on some course exactly where it is a link, …".
- *What the Lean says:* the link holds on some course, not on every one (the first review's F3(e)). It needs precedence weakly decided (`present_some_iff_link`), which the statement omits.
- *Fix*, 297 and 89 characters, within the caps:
  - en: "On causal-set growth the present, read as the maximal elements of what a course has born, is a choice of course between bounds defined from precedence: a condition is present at a birth on some course exactly where it is a link (precedence weakly decided), on every course exactly at the one link."
  - zh: "于因果集之生长上，现在读作一历程所已生者之极大元，则随历程而择，介于由先后定义之二界之间：缘于一生时在现在，于某一历程恰当其为覆盖（先后弱可判定），于每一历程恰当其为唯一之覆盖。"

**R5 (O). "Every antichain", and "presents are the antichains".**

What the Lean says:
- `antichain_present` takes the antichain as a Boolean test (`q : Nat → Bool`). With precedence only weakly decided, an antichain given as a proposition is not covered.
- A present is an antichain (`maximalBorn_unrelated`). It is given by a test where precedence is decided.

Fix:
- The checker's scope and the root bullet, "every antichain is one" (`integrate_ue14.py`:51–52 and :78–79) → "every antichain given by a test is one".
- The README rows:
  - en, "presents are the antichains" (:111) → "presents are antichains, and with precedence weakly decided every antichain given by a test is one";
  - zh, "诸现在即诸反链" (:124) → "现在皆为反链，先后弱可判定时以检验给出之每一反链皆为一现在".
- NOTE.md:88, "The presents of the courses are exactly the antichains given by a test" → "Every present is an antichain, and with precedence weakly decided every antichain given by a test is a present".
- The regions note, "presents the antichains" (`texts_ue14.py`:157) → "presents antichains, every antichain given by a test a present".

**R6 (O). Decisions dropped where the text promises them.**
- *The board row* (`board_ue14.py`:29–35) opens with "Laws, each with the decision it needs:", then drops the decision of three laws:
  - "every antichain given by a test is one";
  - "present together on some course exactly where unrelated";
  - "on every course exactly where they have the same future", which with no decision is the doubly negated form.

  End the second STATEMENTS string with: "…; the present at a stage, the maximal elements of what is born, is an antichain, and with precedence weakly decided every antichain given by a test is one; two elements are present together on some course exactly where unrelated (precedence weakly decided), and on every course exactly where they have the same future (precedence decided);".
- *The README rows* (`integrate_ue14.py`:113–115 and :125–126) say "a condition present at a birth on some course where it is a link, on every course where it is the one link, with no decision". That reads as needing no decision for either. Write "…on some course where it is a link (precedence weakly decided), on every course where it is the one link (no decision)"; zh "…于某一历程即其为覆盖（先后弱可判定），于每一历程即其为唯一之覆盖（无需判定）".

**R7 (O). The law on presence at a birth drops a conjunct.**
- *Where:* `make_records_ue14.py`:203: "on a natural labelling exactly where i is in the present at j's stage".
- *What the Lean says:* `present_iff_maximalBorn` is `PresentAt c π i j ↔ c.prec i j ∧ MaximalBorn c π (π j) i`. An element unrelated to `j` can be in that present.
- *Fix:* "exactly where i precedes j and is in the present at j's stage"; zh "于自然编号上恰当 i 先于 j 且于 j 之阶段在现在".

**R8 (I). A reused definition with no dependency.**
- *`WeaklyDecided`.* The laws on some course and five calibrations use the core's `WeaklyDecided`, but no dependency names it. Its citing records (organizational-formation-from-generative-comparison, practical-judgment-under-living-significance) are chapter 7's, so an edge would run from the root into chapter 7.
- *`firstWhere`.* The normal-forms detail lists `firstWhere`, which no record cites.

Fix:
- Add to counts-exist-where-decided's detail: "WeaklyDecided, the core's weak form in the same module, is cited only by chapter 7's records, so no edge is drawn to them".
- Write normal-forms' detail as "KeepsOrder, Orients, Rearranges and rearranges_iff (firstWhere, the core's bounded search, is cited by no record)".

**R9 (I). "Under any class" needs the class given on the elements.**
- *Where:* `texts_ue14.py`:50, `study_ue14.txt`:101, NOTE.md:105.
- *What holds:* continuation under `E`, `«续» c.prec E`, is the same on every course where `E` is given on the elements. A class given on the order of births (the first born alone, say) is a choice of course.
- *Fix (01):* "…is the same on every course where a thing's future is read as what it conditions, under any class given on the elements, and a choice of course where it is read as what comes after a present stage, or under a class given on the order of births; …".

**R10 (I). The clash check predates the course forms.** `clash.log` (05:53) predates the sixteen course forms (12:12), yet it is cited for the current module (NOTE.md:115, `study_ue14.txt`:81). A clash is unlikely in `Becoming.Presence`, but re-run the check, or cite the landing receipt's whole-package build.

**R11 (S). Covariance reads as a result in the 01 paragraph.**
- *Where:* `texts_ue14.py`:48: "Its labels, the order of births, carry no physical meaning (discrete general covariance, Rideout and Sorkin 2000): the renumberings…".
- *What is wrong:* the colon presents `natural_iff_course` as unpacking a premise of the model (the first review's F3(d)).
- *Fix:* "Its labels, the order of births, are taken to carry no physical meaning (discrete general covariance, Rideout and Sorkin 2000), a premise of the model. The renumberings…".

**R12 (S). Small inexactnesses.**
- *"Its past"* stands for `y = x ∨ c.prec y x` (`texts_ue14.py`:48; `integrate_ue14.py`:49 and :74). Write "its past with itself".
- *"Unrelated elements are born in either order"* (`integrate_ue14.py`:77; `study_ue14.txt`:30–31; the record, :279). Write "two different unrelated elements": `either_order` needs `x ≠ y`.
- *"Born before on some course is not being preceded"* (the record, :278, zh "即不为所先"; the README rows, :110, zh :123). Write "is differing and not being preceded": `before_some_iff` gives `i ≠ j ∧ ¬ c.prec j i`.
- *Stem sets.* 08 §8 (`texts_ue14.py`:79) and the record's law 8 (:129) speak of Brightwell and others' characterization of their stem sets. Write "…of their stem sets, here on finite causal sets": their stem sets are sets of completed causets.
- *The record's first hypothesis* (:316–318) says "the laws on … the present at a stage … with no decision", though `antichain_present`, `together_some_iff` and `together_every_iff` need one. Write "the laws defining the present at a stage (maximalBorn_iff_ends, maximalBorn_unrelated, maximalBorn_front)".
- *The kinematic present.* NOTE.md:95 lists "a maximal antichain of the whole configuration" and "Wüthrich and Callender's kinematic present" as two readings; in their §3 they are one. Write "a maximal antichain of the whole configuration (Wüthrich and Callender's kinematic present)".

**R13 (S). Names and citations.**
- *`present_every_course`* is the course form of `present_every_iff_only_link`, not of `present_every_iff`, while its siblings keep the part that tells them apart (`together_every_course_not_not`). Consider `present_every_course_only_link`, or say which law it is in the docstring.
- *The alias* "Stein on causal-set growth" (`make_records_ue14.py`:455) suggests the counterpart of Stein's theorem that the record disclaims. Write "the past as the largest relation every course respects".
- *The board row* keeps "`OrderNormal.rearranges_iff`", which is not a Lean name. Write "`rearranges_iff` (in `Becoming.OrderNormal`)".
- *`apart_ue14.py`:113–114* calls `reach_links_courses_iff_em` a course form. It is a calibration on courses.

**R14 (S). A redundant bound.** `present_some_iff_link` takes `j < c.size`, and so do `present_some_course` and `present_some_iff_weakly`'s law. But `links c.prec i j` already gives it through `within`. Dropping it is optional.

## The first review's findings

| Finding | Taken | Residue |
|---|---|---|
| F1 (E), the decision | yes | R3 |
| F2 (E), Dowker | yes | |
| F3 (O), the main reading | yes | R4, R11 |
| F4 (O), the diamond's scope | yes | its wording overgeneralizes (R2) |
| F5 (O), Stein | yes | |
| F6 (O), the stems | yes | R12 (stem sets) |
| F7–F11 (I) | yes | |
| F12 (I), placement | yes | R10 |
| F13 (I), the continuation reading | yes | R9 |
| F14–F17 (S) | yes | |
| F18 (S), the calibrations | yes | R3 |

## Verification of the fold

28 October 2026. A read-only check that the fold took R1–R14, not a fresh review.

What was read:
- the module at 12:40. `scratch-14.log` reports 164 theorems in 190 declarations, every axiom report empty, and the audit lists `past_every_iff_em` and `present_every_course_only_link`.
- the kit and the note at 12:49;
- the fresh mirror.

What was confirmed:
- **The clash check.** `clash.log` (12:41) built the whole package with this module; the clash tree's copy has the same hash.
- **The record's caps.** `make_records_ue14.py --caps` passes: 190 declarations, each cited once, in 31 laws, with every cap and the lint met.
- **The module's changes.** It changed only in its header, `Diamond.pastOrPair_iff_together`'s docstring, the new theorem and the rename.
- **The probe.** `probes2/` is byte-identical to the re-check's probe tree.

| Finding | Status |
|---|---|
| R1 | taken exactly |
| R2 | taken exactly, everywhere listed; NOTE §4 adds that on the vee the join is their relation, which is right |
| R3 | taken by option (a); `past_every_iff_em` is the probe's theorem verbatim. "Each calibrated decision" is used throughout, and NOTE §3 names what is not calibrated, which is right |
| R4 | taken exactly |
| R5 | taken exactly |
| R6 | taken exactly |
| R7 | taken exactly, and in the study too |
| R8 | taken exactly |
| R9 | taken exactly |
| R10 | taken |
| R11 | taken, and in the module's header too, which is right |
| R12 | taken where listed; the record's law 30 changed in English only (V1); three instances the re-check did not list remain (V2) |
| R13 | taken exactly |
| R14 | not taken; the decision is fine, its stated reason is not (V3) |

New or remaining (all small; none blocks landing):

**V1 (S). Record law 30 changed in English only.**
- *Where:* `make_records_ue14.py`:279–283. The English now says "the past with the element", but the Chinese still says "过去为于每一历程皆不后生者".
- *Fix:* in the Chinese, "过去连同该元为于每一历程皆不后生者". The English reads better as "the past with the element is what is born no later on every course".

**V2 (S). Instances of R12 that the re-check did not list.**
- NOTE.md:82 (law 10): "its past (`past_every_course`)" → "its past with itself".
- NOTE.md:82 (law 10): "born before on some course is not being preceded" → "is differing and not being preceded".
- `study_ue14.txt`:96: "characterization of their stem sets (2003) on finite causal sets" → "…(2003), here on finite causal sets".

**V3 (S). The reason given for not taking R14 is inexact.**
- *Where:* NOTE.md:156 and `study_ue14.txt`:98 give the reason as "so that the laws on presence at a birth take their bounds alike".
- *What the Lean says:* `present_iff_maximalBorn`, `link_of_present`, `present_every_iff` and `present_every_iff_only_link` take no bound; only `present_some_iff_link` does.
- *Fix:* "It is kept: it costs a caller one argument and states nothing false."
