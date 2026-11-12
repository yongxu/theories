Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Follow-up map: Change's core on the time line, the root's constancy and core, and the «迭» laws

Read only. Nothing was built or run. PKG = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Files read: PKG/Change.lean 640-915; PKG/Grammar.lean 330-500, 500-612 (headers), 740-931; PKG/GrammarLaws.lean 1100-1240, 1274, 1462, 2560-2690; PKG/Arising.lean 625-645 (for `Steps.next`, `Steps.alike`, `hasSucc_iff`); the held `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` 99-132 and its reader report.

Import fact (computed from `import` lines, read-only): `Becoming.Change` imports `Becoming.GrammarLaws` transitively (Change → Flow → Arising → … → GrammarLaws). So a general law placed in GrammarLaws can be used by Change.

## 1. Inventory

### Supporting definitions (Arising.lean, namespace `Steps`)

- Arising.lean 628, def. `def next : «际» Nat := fun s t => t = s + 1` — the step relation: `t` is the step after `s`. It has a fixed successor and every step has one (neither fact is stated as a named lemma about `Steps.next` that I found; grep for `«定后» Steps.next` / `«迭» Steps.next` found nothing).
- Arising.lean 632, def. `def alike (p : Nat → Prop) : «际» Nat := fun s t => p s ↔ p t` — the two-valued class of a determination.
- Arising.lean 638, theorem. `theorem hasSucc_iff {E : «际» Nat} {t : Nat} : «有后» next E t ↔ E t (t + 1)` — a step has a successor under `E` exactly when it is `E`-alike to the next step.
- Arising.lean 643, theorem. `theorem hasPred_iff {E : «际» Nat} {t : Nat} : «有前» next E (t + 1) ↔ E t (t + 1)`.

### Change.lean (the time line)

- 677, theorem. `theorem Steps.iff_of_eqs (p : Nat → Prop) {a b c d : Nat} (h₁ : a = b) (h₂ : c = d) (h : p b ↔ p d) : p a ↔ p c` — rewriting helper.
- 686, theorem. `theorem ceasesToBe_iff_wang : CeasesToBe p t ↔ p t ∧ «亡» Steps.next (Steps.alike p) t` — ceasing to be is p holding at t and t ending (亡) under the class.
- 692, theorem. `theorem comesToBe_iff_sheng : ComesToBe p t ↔ p (t + 1) ∧ «生» Steps.next (Steps.alike p) (t + 1)`.
- 732, theorem. `theorem sheng_iff_change [dp : ∀ s, Decidable (p s)] : «生» Steps.next (Steps.alike p) (t + 1) ↔ ComesToBe p t ∨ CeasesToBe p t` — with p decidable, beginning at t+1 is a change across t.
- 746, theorem. `theorem Steps.reach_later {E : «际» Nat} {s y : Nat} (h : «相续» Steps.next E s y) : ∃ n, y = s + n + 1`.
- 757, theorem. `theorem Steps.reached_of_buqiong {E : «际» Nat} {S : Nat} (h : «不穷» Steps.next E S) : ∀ n, «相续» Steps.next E S (S + n + 1)`.
- 765, theorem. `theorem Steps.buqiong_iff {E : «际» Nat} {S : Nat} : «不穷» Steps.next E S ↔ ∀ n, E (S + n) (S + n + 1)` — for any relation E on Nat (not assumed a class), the line from S never ends iff every later step is E-alike to its next.
- 776, theorem. `theorem Steps.keeps_of_alike {p : Nat → Prop} {S : Nat} (h : ∀ n, (p (S + n) ↔ p (S + n + 1))) : ∀ n, (p (S + n) ↔ p S)`.
- 783, theorem. `theorem buqiong_alike_iff {S : Nat} : «不穷» Steps.next (Steps.alike p) S ↔ ∀ n, (p (S + n) ↔ p S)` — under the class of p, the line from S never ends iff p keeps its value at S forever after. ("Stays the same in a respect up to its end", here with no end.)
- 789, theorem. `theorem still_of_buqiong {S : Nat} (h : «不穷» Steps.next (Steps.alike p) S) : ∀ t, S ≤ t → ¬ ComesToBe p t ∧ ¬ CeasesToBe p t`.
- 799, theorem. `theorem buqiong_of_stays_failing {S : Nat} (fails : ¬ p S) (still : ∀ t, S ≤ t → ¬ ComesToBe p t) : «不穷» Steps.next (Steps.alike p) S`.
- 807, theorem. `theorem persists_of_positions {S : Nat} (positions : ∀ n, «生» Steps.next (Steps.alike p) (S + n + 1) ∨ «有前» Steps.next (Steps.alike p) (S + n + 1)) (holds : p S) (unceasing : ∀ t, S ≤ t → ¬ CeasesToBe p t) : ∀ n, p (S + n)`.
- 846, theorem. `theorem positions_iff_change : («生» Steps.next (Steps.alike p) (t + 1) ∨ «有前» Steps.next (Steps.alike p) (t + 1)) ↔ (¬ (p t ↔ p (t + 1)) ∨ (p t ↔ p (t + 1)))`.
- 865, theorem. `theorem positions_iff_em : (∀ (p : Nat → Prop) (t : Nat), «生» Steps.next (Steps.alike p) t ∨ «有前» Steps.next (Steps.alike p) t) ↔ ∀ Q : Prop, Q ∨ ¬ Q`.
- **874, theorem.** `theorem Steps.course_of_constant {S : «际» Nat} (constant : «有常» Steps.next S) {s s' : Nat} (h : S s s') : ∀ n, S (s + n) (s' + n)` — any relation S on Nat constant under `Steps.next` (S need not be symmetric, a class, or inside any E) that relates s to s' relates s+n to s'+n for every n. This is "constancy carries n steps", on Nat, stated with `s + n` in place of `«迭» Steps.next n s`.
- **884, theorem.** `theorem core_iff_same_course {p : Nat → Prop} {s s' : Nat} : «核» Steps.next (Steps.alike p) s s' ↔ ∀ n, (p (s + n) ↔ p (s' + n))` — two steps are in one class of the core of `alike p` exactly when p agrees at every pair of steps equally far after them. No premise. (→ uses `course_of_constant` on the witness S plus S ⊆ E; ← builds the witness S = "same course" directly from the core's definition; it does not call `«根»`.)
- **899, theorem.** `theorem continues_in_core_iff_buqiong {p : Nat → Prop} {s : Nat} : «续» Steps.next («核» Steps.next (Steps.alike p)) s (s + 1) ↔ «不穷» Steps.next (Steps.alike p) s` — s continues to s+1 under the core exactly when the line under the class never ends from s. No premise.
- 909, theorem. `theorem still_stays_of_constant {p : Nat → Prop} {t : Nat} (constant : «有常» Steps.next (Steps.alike p)) (still : p t ↔ p (t + 1)) : p (t + 1) ↔ p (t + 1 + 1)` — if the class of p is constant on the whole time line (a global premise), unchanged across one step implies unchanged across the next; its proof is one call of `«有常则续不尽»`.
- Module header 659-665 (docstring, not a theorem): "taking the core as the criterion, only a determination that never changes again continues, as the grammar's flame shows (`«以核为判据则火无续»`)". This matches 899 with 783; the flame is a separate four-element model, not a case of 899.

### Grammar.lean (the root)

- 340, def. `def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))` — E is constant under R: E˘;R ⊆ R;E˘.
- 343, theorem. `theorem «有常之逐点» (R E : «际» α) : «有常» R E ↔ ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v'` — pointwise form.
- 356, theorem. `theorem «有常则续不尽» {R E : «际» α} (h : «有常» R E) {y : α} (hy : «有前» R E y) : «有后» R E y` — under a constant class, whatever continues something is continued.
- 363, theorem. `theorem «有常则相续不尽» {R E : «际» α} (h : «有常» R E) {x y : α} (hxy : «相续» R E x y) : «有后» R E y`.
- 370, theorem. `theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) : ¬ «有常» R E` — a class under which some continued occurrence ends is not constant. (Part (b) of the pattern, in its "continued then ends" form.)
- 375, def. `def «核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'`.
- 380, theorem. `theorem «根» (R E : «际» α) : «则» («核» R E) E ∧ «有常» R («核» R E) ∧ «则» («核» R E) («逆» («核» R E)) ∧ ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «则» S («核» R E)` — the core lies in E, is constant, symmetric, and is the greatest such. No premise.
- 391, theorem. `theorem «有常可复合» {R S₁ S₂ : «际» α} (h₁ : «有常» R S₁) (h₂ : «有常» R S₂) : «有常» R («而» S₁ S₂)` — constant relations compose (relations composed, not the step R).
- 401, theorem. `theorem «静有常» (R : «际» α) : «有常» R «静»`.
- 406, theorem. `theorem «核为类» (R : «际» α) {E : «际» α} (hE : «类» E) : «类» («核» R E)`.
- 436, theorem. `theorem «闭合当且仅当有常» (R : «际» α) {E : «际» α} (hE : «类» E) : «有常» R E ↔ «则» («而» («而» E R) E) («而» R E)`.
- 523, theorem. `theorem «亡于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y') (hy : «亡» R E y) : «亡» R E y'` — for a class E, ending under E is the same across a core class.
- 598, theorem. `theorem «核之单调» (R : «际» α) {E E' : «际» α} (h : «则» E E') : «则» («核» R E) («核» R E')`.
- 602, theorem. `theorem «类有常当且仅当含于核» (R : «际» α) {E : «际» α} (hE : «类» E) : «有常» R E ↔ «则» E («核» R E)`.
- 612, def. `def «足以定核» (R E₁ E₂ : «际» α) : Prop := «则» («合» E₁ E₂) («核» R E₁)` — "what the class E₁ does not tell is told by another class E₂": the second clause of (b).
- 618, def. `def «相须核» (R E₁ E₂ : «际» α) : Prop := «足以定核» R E₁ E₂ ∧ «足以定核» R E₂ E₁ ∧ ¬ «有常» R E₁ ∧ ¬ «有常» R E₂`.
- 623, theorem `«合有常则足以定核»` (statement not copied; header read only).
- 740-786: the flame model `Flame` (f₀ f₁ f₂ ash), `Flame.step`, `Flame.alike` ("flame or not"); `Flame.not_core_f₁` (764), `Flame.not_core_f₀` (775): no symmetric constant S inside `alike` relates f₁ to f₂, nor f₀ to f₁.
- **791, theorem.** `theorem «以核为判据则火无续» : «续» Flame.step Flame.alike Flame.f₀ Flame.f₁ ∧ «续» Flame.step Flame.alike Flame.f₁ Flame.f₂ ∧ ∀ x y, ¬ «续» Flame.step («核» Flame.step Flame.alike) x y` — in the four-moment flame the moments continue under "flame or not", yet nothing continues under its core. This is the finite witness of (b)-(c): alike up to the end, the core tells "how long is left". Docstring: "the core's futures differ by how long is left" — a reading; the statement says only that no core-continuation exists.
- 806-815 `Flame.fuel`, `Flame.sameFuel`; 832 `«火薪相须» : «相须核» Flame.step Flame.alike Flame.sameFuel`; 849 `«火之见证不择类»`; 870-918 two-flame variants `«两火以薪定理»`, `«两火同火不足以定理»` (892), `«两火火薪相须»`. These are the finite witnesses that "another class" (fuel left) tells what the class does not.

### GrammarLaws.lean (steps, lumping)

- 1063, def. `def «定后» (R : «际» α) : Prop := «则» («而» («逆» R) R) «静»` — fixed successor.
- **1124, def.** `def «迭» (R : «际» α) : Nat → «际» α | 0 => «静» | n + 1 => «而» R («迭» R n)` — n steps, first step first.
- 1130, theorem. `theorem «迭即历» (R : «际» α) : ∀ n, «谓» («历» (fun (_ : Unit) => R) (List.replicate n ())) («迭» R n)`.
- 1136, theorem. `theorem «迭则及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R (n + 1) x y → «及» R x y`.
- 1141, theorem. `theorem «及即迭» {R : «际» α} {x y : α} : «及» R x y ↔ ∃ n, «迭» R (n + 1) x y`.
- 1151, theorem. `theorem «迭之接» {R : «际» α} : ∀ (a b : Nat) {x y z : α}, «迭» R a x y → «迭» R b y z → «迭» R (b + a) x z`.
- 1160, theorem. `theorem «迭之周» {R : «际» α} {p : Nat} {x : α} (loop : «迭» R p x x) : ∀ k, «迭» R (p * k) x x`.
- 1167, theorem. `theorem «迭之末步» {R : «际» α} : ∀ (n : Nat) {x z : α}, «迭» R (n + 1) x z ↔ ∃ y, «迭» R n x y ∧ R y z`.
- 1176, def. `def «迭内» (R : «际» α) (n : Nat) : «际» α := fun x y => ∃ k, k ≤ n ∧ «迭» R k x y`.
- 1179, theorem. `theorem «迭内之接» {R : «际» α} {m n : Nat} {x y z : α} : «迭内» R m x y → «迭内» R n y z → «迭内» R (m + n) x z`.
- 1187, def `«静或缘»`; 1190 theorem `«迭内即静或缘之迭»` (end of my range).
- Outside range, used for the answer: 1238 `«迭之分»` (`«迭» R (b + a) x z → ∃ y, «迭» R a x y ∧ «迭» R b y z`); 1274 `«不穷则迭» {R E : «际» α} {x : α} (endless : «不穷» R E x) : ∀ n, ∃ y, «迭» («续» R E) n x y`; 1462 `«迭之定» {R : «际» α} (fixed : «定后» R) : ∀ (n : Nat) {x y z : α}, «迭» R n x y → «迭» R n x z → y = z`.
- 2568, def. `def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E` — going alike: R˘;E;R ⊆ E.
- 2571, theorem. `theorem «同行之逐点» {R E : «际» α} : «同行» R E ↔ ∀ x x', E x x' → ∀ y y', R x y → R x' y' → E y y'`.
- 2588, theorem. `theorem «有常定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : «定后» R) : «同行» R E`.
- 2592, theorem. `theorem «有常则可续» {R E : «际» α} (constant : «有常» R E) : ∀ u u' v, E u u' → R u v → ∃ v', R u' v'` — under a constant E, what is E-alike to something with a next has a next. (The premise-free core of (b): alike, one with a next and one without, means not constant.)
- 2607, theorem. `theorem «同行遍后则有常» {R E : «际» α} (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «有常» R E`.
- 2619, theorem. `theorem «同行当且仅当有常» {R E : «际» α} (fixed : «定后» R) (total : ∀ x, ∃ y, R x y) : «同行» R E ↔ «有常» R E`.
- 2631, theorem. `theorem «定后则类之核同行» {R E : «际» α} (hE : «类» E) (fixed : «定后» R) : «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)`.
- 2669, theorem. `theorem «同行之历» {A : Type v} {F : A → «际» α} {E : «际» α} (alike : ∀ a, «同行» (F a) E) : ∀ (as : List A) {x x' y y' : α}, E x x' → «历» F as x y → «历» F as x' y' → E y y'`.
- **2677, theorem.** `theorem «同行之迭» {R E : «际» α} (alike : «同行» R E) : ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'` — going alike carries over n steps (both lines must exist; nothing says the second line exists).
- **2684, theorem.** `theorem «同行于迭» {R E : «际» α} (alike : «同行» R E) (n : Nat) : «同行» («迭» R n) E`.

### The held file (for comparison)

- TurningInTime.lean 101, `core_step {u u' v : α} (core : «核» R E u u') (r : R u v) : ∃ v', R u' v' ∧ «核» R E v v'` — is `(«有常之逐点» R («核» R E)).mp («根» R E).2.1 u u' core v r`, as its proof says: no new content.
- TurningInTime.lean 114, `core_steps : ∀ (n : Nat) {u u' v : α}, «核» R E u u' → «迭» R n u v → ∃ v', «迭» R n u' v' ∧ «核» R E v v'` — not in the root (I also found no theorem whose statement has both `«有常»` and `«迭»`, in any PKG file).
- TurningInTime.lean 126, `core_apart {u u' v : α} (goes : R u v) (ends : ∀ v', ¬ R u' v') : ¬ «核» R E u u'` — is `«有常则可续» («根» R E).2.1 u u' v core goes` (GrammarLaws 2592 with Grammar 380) followed by `ends`; no class premise needed. The reader's alternative through `«亡于核下不变»` (523) needs `«类» E` and so is weaker in premises.

## 2. Answers

**Q1. Do `core_iff_same_course`, `Steps.course_of_constant` and `continues_in_core_iff_buqiong` already state, on the time line, that the core tells what the class does not and that constancy carries n steps?**

- Constancy carries n steps: yes, on Nat. `Steps.course_of_constant` (874) states it for any relation S constant under `Steps.next`, with no symmetry or class premise, in the form `S (s + n) (s' + n)`. It is stated with arithmetic (`s + n`), not through `«迭»`; no lemma in PKG says `«迭» Steps.next n s v ↔ v = s + n`, so it is not literally phrased as a case of a «迭» law today.
- The core tells what the class does not: on Nat, `core_iff_same_course` (884) characterizes the core completely (same course at every offset) against the class (agreement at offset 0 only). So, for any p and s, s' with `p s ↔ p s'` and some n with `¬ (p (s+n) ↔ p (s'+n))`, the class relates them and the core does not; but that consequence is not itself stated as a theorem in Change. `continues_in_core_iff_buqiong` (899) states the "continues" side: under the core, a step continues iff the class-line never ends from it. Together with `buqiong_alike_iff` (783) this says: under the core, only a p that never changes again continues; any p that will change (any end of the class-line) has no core-continuation at that step. It does not mention a "next / no next" pair, a level, a draw, or a point of no return; parts (c) and (d) of the pattern (something depended on running down; turning before the end) are not in these three.
- "Another class tells it" (second clause of (b)) is in Grammar as `«足以定核»` (612) and the flame witnesses (`«火薪相须»` 832, `«两火以薪定理»`), not on the Nat time line.

**Q2. Would the held `core_steps` and `core_apart` be the general form of which these are the Nat cases?**

- `core_steps` is not itself the general form; it is the core's instance of a more general law: for any S with `«有常» R S`, `S u u' → «迭» R n u v → ∃ v', «迭» R n u' v' ∧ S v v'`, i.e. `«有常» («迭» R n) S` (pointwise, through `«有常之逐点»`). That general law does not exist in PKG. `core_steps` = that law at S = `«核» R E` with `(«根» R E).2.1`. `Steps.course_of_constant` = that law at R = `Steps.next`, any S, once one proves the Nat fact `«迭» Steps.next n s v ↔ v = s + n` (absent). So course_of_constant is a Nat case of the general constancy law, and a sibling (not a case) of `core_steps`: course_of_constant has no core in it. Note that `core_iff_same_course`'s → direction uses course_of_constant on the witness S, not on the core, so it would use the general law at an arbitrary S.
- Alternative already available without any new general law: on `Steps.next` (fixed successor, every step has one), `«有常定后则同行»` (2588) turns constancy into going alike, and `«同行之迭»` (2677) then carries S over n steps given both n-step lines; `Steps.course_of_constant` would follow from these plus the same missing Nat lemma (`«迭» Steps.next n s (s + n)`). So course_of_constant can already be re-derived from the root's lumping law, without a new constancy-over-«迭» law. The general constancy law is still stronger in general (it produces the second line; «同行之迭» assumes it), which is exactly what `core_steps` needs when R is not total.
- `core_apart` is not a general form of anything in Change; it is the premise-free "what goes on and what has no next are apart in the core", already `«有常则可续»` (2592) applied to `(«根» R E).2.1`. On Nat every step has a next under `Steps.next`, so `core_apart` has no direct Nat case with `Steps.next`; its Nat relative is the class-relative statement `continues_in_core_iff_buqiong` (whose "next" is a next under the core, `«续»`, not under the bare step). The finite witness of the same phenomenon is `«以核为判据则火无续»` (791) and `«有亡之续则不有常»` (370).

**Q3. On which GrammarLaws «迭» law would that general form sit?**

- Its exact twin is `«同行于迭»` (2684, `«同行» R E → «同行» («迭» R n) E`) with its pointwise `«同行之迭»` (2677), which in turn is the one-relation case of `«同行之历»` (2669). The constancy analogue would be "`«有常» R S → «有常» («迭» R n) S`", most naturally proved as a «历» law (each letter's relation constant ⇒ passing through the word constant) with the «迭» case through `«迭即历»` (1130), as GrammarLaws does for six «迭» laws (header lines 134-136 list them). Its induction step is the definition of `«迭»` at `n + 1` (`«而» R («迭» R n)`), i.e. constancy composed along relations; note `«有常可复合»` (391) composes the class relations S₁;S₂, not the step relations, so it is not the step law.

## 3. Cautions

- Name/statement duplicates: the held `core_step` is `«有常之逐点»` + `«根»`.2.1; `core_apart` is `«有常则可续»` + `«根»`.2.1; `not_constant` (TurningInTime 122) is `«有常则可续»` contraposed; `alike_steps` is `«同行之迭»` (per the reader report; I confirmed `«同行之迭»`'s statement). Restating any of them duplicates.
- A general `«有常» («迭» R n) S` law must take R general and S any relation (no symmetry, no class), or it will not specialise to `Steps.course_of_constant`, whose S is unconstrained.
- Putting `course_of_constant` under a «迭» law needs a new Nat lemma about `«迭» Steps.next`; none exists. Mind `«迭»`'s order (first step first) against `s + n + 1` vs `s + (n + 1)`; Change already carries `Steps.iff_of_eqs` and `Nat.add_right_comm` rewrites for this.
- `still_stays_of_constant` (909) has a global premise (`«有常» Steps.next (Steps.alike p)` on all of Nat); it is not a "constant up to its end" statement.
- `«亡于核下不变»` (523) needs `«类» E`; `«有常则可续»` does not. A design using the former adds a premise.
- Docstrings: `«以核为判据则火无续»`'s "the core's futures differ by how long is left" and Change header's "as the grammar's flame shows" are readings beyond the statements (the statement is non-existence of core-continuation in one model). Others in my range match their statements.
- Name collision risk: Change already uses `Steps.*` names in namespace `Becoming`; a new `core_steps` in `Becoming` would not collide with anything I found, but `Steps.course_of_constant` is the existing name for the Nat case.

## 4. Not read or not settled

- Change.lean outside 640-915 (Web section 915-966, `CeasesToBe`/`ComesToBe` definitions, `stays_failing`).
- GrammarLaws.lean outside 1100-1240, 2560-2690 except the three statements copied; I did not check GrammarConditionals, GrammarTransport, GrammarCrossing for a constancy-over-«历»/«迭» law beyond the grep (`有常` and `迭` on one line in any PKG file: no hits). A law phrased over several lines or through `«历»` with a different word could have escaped the grep.
- `«合有常则足以定核»` (623) statement not copied.
- Nothing compiled; I did not verify that the proposed derivations typecheck.
