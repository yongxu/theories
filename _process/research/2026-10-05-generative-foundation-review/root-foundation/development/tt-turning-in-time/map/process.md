AI-written map, 12 November 2026

# The process layer: Frame, Laws, Recurrence, Lasting, Mechanism, Unfolding, Labelled, IdentificationRuns, Likeness (header and used declarations)

Read only. Nothing was built, run, checked or edited except this file. Line numbers are those of the
files in
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`
(PKG) at main 372705add. "Def" = definition, "Thm" = theorem, "Hyp" = a premise of a theorem.
Statements are copied from the source; the sentence after each is a gloss.

The grammar's words used below (from Grammar.lean / GrammarLaws.lean / GrammarPath.lean, not my
files, given here only so the statements read): `«而» R S x z := ∃ y, R x y ∧ S y z` (Grammar 54);
`«一» := fun _ _ => True` (69); `«静» := fun x y => x = y` (72); `«续» R E := «合» R E` (126);
`«有后» R E x := ∃ y, «续» R E x y` (135); `«亡» R E x := ¬ «有后» R E x` (141);
`«不穷» R E x := ∀ y, (x = y ∨ «相续» R E x y) → «有后» R E y` (243);
`«有常» R E := «则» («而» («逆» E) R) («而» R («逆» E))` (340); `«核»` (375);
`«定后» R := «则» («而» («逆» R) R) «静»` (GrammarLaws 1063); `«迭» R 0 = «静»`,
`«迭» R (n+1) = «而» R («迭» R n)` (GrammarLaws 1124, first step first);
`«迭内» R n x y := ∃ k, k ≤ n ∧ «迭» R k x y` (1176);
`«同行» R E := «则» («而» («而» («逆» R) E) R) E` (2568); `«至终有常»` (GrammarPath 222).

---

## 1. Inventory

### 1.1 Frame.lean (spine: runs, closure, reach, invariants)

- **Frame.lean:55 Def** `structure Frame (S : Type u) (A : Type v) (C : Type w) where P : Process S A; realized : S → C → Prop`
  A process plus which claims are realized at each configuration.
- **Frame.lean:64 Def** `structure Run (P : Process S A) where state : Nat → S; act : Nat → A; step : ∀ n, P.step (state n) (act n) (state (n + 1))`
  An infinite run: every successive pair is a step. There is no finite run type in these files; a
  line that ends is not a `Run`.
- **Frame.lean:75 Thm** `theorem Run.window_trace {P : Process S A} (r : Run P) : ∀ k n, Trace P (r.state n) (r.window n k) (r.state (n + k))`
  Every finite window of a run is a core trace.
- **Frame.lean:86 Def** `def ClosedUnder {X : Type u} (rel : X → X → Prop) (region : X → Prop) : Prop := «闭» rel region`
- **Frame.lean:91 Def** `def WithinClosure {X : Type u} (rel : X → X → Prop) (f g : X) : Prop := «所闭» rel f g`
  Both are the grammar's closure by definition (`closedUnder_iff_closed` 95, `withinClosure_iff_within` 100, each `Iff.rfl`).
- **Frame.lean:161 Def** `def ReturnsAlong {X : Type u} (rel : X → X → Prop) (c : X) : Prop := ∀ g, WithinClosure rel c g → WithinClosure rel g c`
- **Frame.lean:215 Def** `def Reach (P : Process S A) (s t : S) : Prop := ∃ as, Trace P s as t`
- **Frame.lean:241 Def** `def Steps (P : Process S A) (s t : S) : Prop := ∃ a, P.step s a t`
  One step whatever the move: the relation a process gives the grammar.
- **Frame.lean:251 Thm** `theorem reach_iff_withinClosure {P : Process S A} {s t : S} : Reach P s t ↔ WithinClosure (Steps P) s t`
  Reach is the grammar's closure of the steps; no premise.
- **Frame.lean:258 Thm** `theorem Run.reach {P : Process S A} (r : Run P) (n k : Nat) : Reach P (r.state n) (r.state (n + k))`
- **Frame.lean:265 Def** `def Invariant (P : Process S A) (I : S → Prop) : Prop := ∀ s a t, P.step s a t → I s → I t`
- **Frame.lean:275 Thm** `theorem invariant_iff_closedUnder {P : Process S A} {I : S → Prop} : Invariant P I ↔ ClosedUnder (Steps P) I`
- **Frame.lean:282 Thm** `theorem Invariant.reach {P : Process S A} {I : S → Prop} (inv : Invariant P I) {s t : S} (reached : Reach P s t) : I s → I t`
- **Frame.lean:286 Thm** `theorem Invariant.run {P : Process S A} {I : S → Prop} (inv : Invariant P I) (r : Run P) (start : I (r.state 0)) : ∀ n, I (r.state n)`

### 1.2 Laws.lean (determined laws, partial laws, going alike)

- **Laws.lean:48 Def** `def Determined (P : Process S A) : Prop := ∀ s a t t', P.step s a t → P.step s a t' → t = t'`
  At most one successor per configuration and move. Says nothing of a successor existing.
- **Laws.lean:52 Thm** `theorem Trace.determined_end {P : Process S A} (determined : Determined P) : ∀ {s t r : S} {plan : List A}, Trace P s plan t → Trace P s plan r → t = r`
- **Laws.lean:64 Def** `def ofMap (f : S → A → S) : Process S A := ⟨fun s a t => t = f s a⟩` (namespace `Assurance`)
- **Laws.lean:66 Thm** `theorem ofMap_determined (f : S → A → S) : Determined (ofMap f)`
- **Laws.lean:70 Def** `def ofPartial (f : S → A → Option S) : Process S A := ⟨fun s a t => f s a = some t⟩` (namespace `Assurance`)
  A partial law: from `s` the move `a` has a next only where `f s a` is `some`. This is the one
  definition in my files of a determined step with a condition for there being a next; the
  condition is carried by `Option`, so building one from a `guard : S → Prop` needs a decision of it.
- **Laws.lean:72 Thm** `theorem ofPartial_determined (f : S → A → Option S) : Determined (ofPartial f)`
- **Laws.lean:76 Def** `def runPartial (f : S → A → Option S) : S → List A → Option S | s, [] => some s | s, a :: rest => (f s a).bind fun t => runPartial f t rest`
- **Laws.lean:81 Thm** `theorem trace_ofPartial_iff (f : S → A → Option S) : ∀ {s t : S} {plan : List A}, Trace (ofPartial f) s plan t ↔ runPartial f s plan = some t`
  The traces of a partial law are exactly the courses its run completes; no premise.
- **Laws.lean:109 Def** `def GoAlikeUnder (P : Process S A) (π : S → K) (E : K → K → Prop) : Prop := ∀ s s' a u u', E (π s) (π s') → P.step s a u → P.step s' a u' → E (π u) (π u')`
  Configurations whose descriptions `E` relates go, by one move, to configurations whose
  descriptions `E` relates. `E` need not be an equivalence.
- **Laws.lean:114 Def** `def GoAlike (P : Process S A) (π : S → K) : Prop := GoAlikeUnder P π Eq`
- **Laws.lean:120 Thm** `theorem determined_iff_fixed {P : Process S A} : Determined P ↔ ∀ a, «定后» (fun s t => P.step s a t)`
  Determinacy is the grammar's fixed successor at each move; no premise.
- **Laws.lean:127 Thm** `theorem goAlikeUnder_iff_alike {P : Process S A} {π : S → K} {E : K → K → Prop} : GoAlikeUnder P π E ↔ ∀ a, «同行» (fun s t => P.step s a t) (fun s s' => E (π s) (π s'))`
  Going alike under a description is the grammar's `«同行»` at each move with `E` pulled back along
  `π`; no premise. At `E = Eq` this says `GoAlike P π` is `«同行»` under the class "same value of `π`".

### 1.3 Recurrence.lean (the determined law, its orbit and run)

- **Recurrence.lean:118 Def** `def Reachable (P : Process S A) (n : Nat) (s : S) : Prop := ∃ x as, as.length = n ∧ Trace P x as s` (namespace `Branching`)
- **Recurrence.lean:128 Def** `def Returns (P : Process S A) (s : S) : Prop := ∃ a t, P.step s a t ∧ Reach P t s` (namespace `Branching`)
- **Recurrence.lean:131 Def** `def Lossless (P : Process S A) : Prop := ∀ x y a b t, P.step x a t → P.step y b t → x = y` (namespace `Branching`)
- **Recurrence.lean:143 Def** `def process (next : S → S) : Process S Unit := ⟨fun s _ t => t = next s⟩` (namespace `Law`)
  A determined law as a process with one move; every configuration has exactly one next.
- **Recurrence.lean:187 Def** `def Marks (q : S → Nat) (g : Nat → S) : Prop := ∀ n, q (g n) ≤ q (g (n + 1)) ∧ (g (n + 1) ≠ g n → q (g n) < q (g (n + 1)))`
- **Recurrence.lean:240 Def** `def orbit (next : S → S) (s : S) : Nat → S | 0 => s | n + 1 => next (orbit next s n)` (namespace `Law`)
  The configuration `n` steps on. Note the recursion is last step last, while `«迭»` is first step
  first; `orbit_shift` bridges them.
- **Recurrence.lean:244 Thm** `theorem orbit_add (next : S → S) (s : S) (m : Nat) : ∀ n, orbit next s (m + n) = orbit next (orbit next s m) n`
- **Recurrence.lean:249 Thm** `theorem orbit_shift (next : S → S) (s : S) (n : Nat) : orbit next s (n + 1) = orbit next (next s) n`
- **Recurrence.lean:255 Thm** `theorem steps_orbit (next : S → S) : ∀ (n : Nat) (s : S), «迭» (fun x y => (process next).step x () y) n s (orbit next s n)`
  The orbit's `n`-th configuration is had from `s` by `n` grammar steps of the law's process. One
  direction only; the converse (every `n`-step endpoint is the orbit's) follows from `«迭之定»`
  (GrammarLaws 1462) with `step_fixed`, and is used that way in `orbit_mul`, but is not stated as a
  lemma of its own.
- **Recurrence.lean:263 Thm** `theorem step_fixed (next : S → S) : «定后» (fun x y => (process next).step x () y)`
  The law's process steps have a fixed successor.
- **Recurrence.lean:269 Thm** `theorem orbit_mul {next : S → S} {s : S} {p : Nat} (back : orbit next s p = s) : ∀ k, orbit next s (p * k) = s`
  Uses `«迭之周»` and `«迭之定»` with `steps_orbit` and `step_fixed`: the model of how to read a
  grammar law about `«迭»` back onto the orbit.
- **Recurrence.lean:285 Thm** `theorem law_trace_of {next : S → S} : ∀ (as : List Unit) (x t : S), Law.orbit next x as.length = t → Trace (Law.process next) x as t` (namespace `Branching`)
- **Recurrence.lean:294 Thm** `theorem law_trace_iff {next : S → S} {x t : S} {as : List Unit} : Trace (Law.process next) x as t ↔ Law.orbit next x as.length = t` (namespace `Branching`)
  A course of the law is its orbit, exactly.
- **Recurrence.lean:304 Thm** `theorem law_reach_iff {next : S → S} {x t : S} : Reach (Law.process next) x t ↔ ∃ n, Law.orbit next x n = t` (namespace `Branching`)
- **Recurrence.lean:322 Def** `def run (next : S → S) (s : S) : Run (process next) := ⟨orbit next s, fun _ => (), fun _ => rfl⟩` (namespace `Law`)
- **Recurrence.lean:325 Thm** `theorem run_state (next : S → S) (s : S) : (run next s).state = orbit next s`
- **Recurrence.lean:334 Def** `def onward (r : Run P) (i : Nat) : Run P` (namespace `Run`) - a run read from step `i`.
- **Recurrence.lean:391 Thm** `theorem returns_iff_reaches {s : S} : Returns P s ↔ «及» (Steps P) s s` (namespace `Branching`)
- **Recurrence.lean:397 Thm** `theorem lossless_iff_fixedBefore : Lossless P ↔ «定前» (Steps P)` (namespace `Branching`)
- **Recurrence.lean:536 Thm** `theorem next_fixed (next : S → S) : «定后» (fun x y => next x = y)` (namespace `Law`)
  Same content as `step_fixed`, but on the relation written `next x = y`, which is not
  definitionally `(process next).step x () y` (that is `y = next x`).
- **Recurrence.lean:540 Thm** `theorem next_total (next : S → S) : ∀ x, ∃ y, next x = y`
- **Recurrence.lean:543 Thm** `theorem reaches_of_orbit {next : S → S} : ∀ (n : Nat) {s y : S}, orbit next s (n + 1) = y → «及» (fun x y => next x = y) s y`
- **Recurrence.lean:549 Thm** `theorem reaches_iff_orbit {next : S → S} {s y : S} : «及» (fun x y => next x = y) s y ↔ ∃ n, orbit next s (n + 1) = y` (namespace `Law`; name shared with `Lasting.reaches_iff_orbit`, a different statement)
- **Recurrence.lean:568 Thm** `theorem lossless_iff_fixedBefore {next : S → S} : Lossless next ↔ «定前» (fun x y => next x = y)` (namespace `Law`)
- **Recurrence.lean:582 Thm** `theorem merged_stays {next : S → S} {x y : S} (merged : next x = next y) (n : Nat) : orbit next x (n + 1) = orbit next y (n + 1)`
- **Recurrence.lean:589 Thm** `theorem Lossless.cancel {next : S → S} (lossless : Lossless next) {x y : S} : ∀ n, orbit next x n = orbit next y n → x = y` (uses `«迭之定前»` with `steps_orbit`).
- **Recurrence.lean:810 Def** `def Law.SameFuture (next : S → S) (o : S → R) (s s' : S) : Prop := ∀ n, o (Law.orbit next s n) = o (Law.orbit next s' n)`
- **Recurrence.lean:832 Def** `def trajectory (F : X → U → E → X) (x₀ : X) (u : Nat → U) (e : Nat → E) : Nat → X`

### 1.4 Lasting.lean (lasting, exhaustion, never reaching, reaching)

Uses from Viability.lean (not my file; definitions only):
`def Kernel (P : Process S A) (guard : S → Prop) (s : S) : Prop := ∀ t, Reach P s t → guard t` (Viability 55);
`def disturbed (f : S → A → S) (adm : A → Prop) : Process S A := ⟨fun s a t => adm a ∧ t = f s a⟩` (137);
`def history (f : S → A → S) (s : S) (d : Nat → A) : Nat → S | 0 => s | n + 1 => f (history f s d n) (d n)` (141);
`def guardedStep (f : S → A → S) (guard : S → Prop) [DecidablePred guard] (a : A) : Option S → Option S | none => none | some s => if guard s ∧ guard (f s a) then some (f s a) else none` (259);
`def guardedHistory ... : Nat → Option S | 0 => some s | n + 1 => guardedStep f guard (d n) (guardedHistory f guard s d n)` (265).
Note: `guardedStep` guards both the configuration and its successor; it is not "a step that exists
where the guard holds at the source".

- **Lasting.lean:107 Def** `def Lasts (f : S → A → S) (adm : A → Prop) (guard : S → Prop) : Nat → S → Prop | 0, s => guard s | n + 1, s => guard s ∧ ∀ a, adm a → Lasts f adm guard n (f s a)`
  `s` lasts `n` steps: within the guard now and after every admissible disturbance for `n` more
  steps. For a determined law (`f := determined next`, `adm := fun _ => True`) it asks the guard at
  orbit positions `0..n`, that is `n + 1` positions. The law `f` is total; the guard is a property of
  positions, not a condition for there being a next.
- **Lasting.lean:113 Def** `structure Ladder (f) (adm) (guard) (C : Nat → S → Prop) : Prop where within : ∀ k x, C k x → guard x; descends : ∀ k x a, adm a → C (k + 1) x → C k (f x a)`
- **Lasting.lean:120 Def** `structure Necessary ... where base : ∀ x, guard x → L 0 x; rises : ∀ k x, guard x → (∀ a, adm a → L k (f x a)) → L (k + 1) x`
- **Lasting.lean:128 Def** `structure Drains ... where base : ∀ x, guard x → L 0 x; rises : ∀ k x a, guard x → adm a → L k (f x a) → L (k + 1) x`
- **Lasting.lean:136 Thm** `theorem Lasts.within : ∀ {n : Nat} {s : S}, Lasts f adm guard n s → guard s`
- **Lasting.lean:152 Thm** `theorem lasts_iff_ladder {n : Nat} {s : S} : Lasts f adm guard n s ↔ ∃ C : Nat → S → Prop, C n s ∧ Ladder f adm guard C`
- **Lasting.lean:169 Thm** `theorem lasts_iff_necessary {n : Nat} {s : S} : Lasts f adm guard n s ↔ ∀ L : Nat → S → Prop, Necessary f adm guard L → L n s`
- **Lasting.lean:188 Thm** `theorem Lasts.histories : ∀ {n : Nat} {s : S}, Lasts f adm guard n s → ∀ d : Nat → A, (∀ k, adm (d k)) → ∀ k, k ≤ n → guard (history f s d k)`
- **Lasting.lean:212 Thm** `theorem lasts_iff_histories {a₀ : A} (h₀ : adm a₀) {n : Nat} {s : S} : Lasts f adm guard n s ↔ ∀ d : Nat → A, (∀ k, adm (d k)) → ∀ k, k ≤ n → guard (history f s d k)`
  Hyp: one admissible disturbance. With `orbit_eq_history` (469) this gives, for a determined law,
  `Lasts (determined next) (fun _ => True) guard n s ↔ ∀ k, k ≤ n → guard (Law.orbit next s k)`;
  that orbit form is not stated anywhere in my files (LastingRuns.lean:218 `determined_lasts_iff_courses`
  states it on courses).
- **Lasting.lean:218 Thm** `theorem Lasts.trace : ∀ {plan : List A} {n : Nat} {s t : S}, Lasts f adm guard n s → Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t`
- **Lasting.lean:236 Thm** `theorem kernel_iff_lasts {s : S} : Kernel (disturbed f adm) guard s ↔ ∀ n, Lasts f adm guard n s`
  What no course leaves is what lasts every horizon; no premise.
- **Lasting.lean:290 Thm** `theorem guarded_upto_iff [DecidablePred guard] {s : S} {d : Nat → A} (start : guard s) {n : Nat} : guardedHistory f guard s d n = some (history f s d n) ↔ ∀ k, k ≤ n → guard (history f s d k)`
- **Lasting.lean:303 Thm** `theorem guarded_none_iff [DecidablePred guard] {s : S} {d : Nat → A} (start : guard s) {n : Nat} : guardedHistory f guard s d n = none ↔ ¬ ∀ k, k ≤ n → guard (history f s d k)`
  Hyps: the guard decided, the start within it. The nearest thing in my files to "a guarded line
  goes on to step n exactly where the guard held up to n"; stated on `Option`, not on `«迭»`.
- **Lasting.lean:321 Thm** `theorem Drains.along {L : Nat → S → Prop} (drains : Drains f adm guard L) : ∀ (n : Nat) (s : S) (d : Nat → A), (∀ k, adm (d k)) → (∀ k, k ≤ n → guard (history f s d k)) → L n s`
- **Lasting.lean:333 Thm** `theorem Drains.leaves {L : Nat → S → Prop} (drains : Drains f adm guard L) {n : Nat} {s : S} (below : ¬ L n s) (d : Nat → A) (admissible : ∀ k, adm (d k)) : ¬ ∀ k, k ≤ n → guard (history f s d k)`
  Exhaustion: below level `n` of a drained family, every admissible history leaves the guard within
  `n` steps. This is the package's general "runs down to an end" law (c).
- **Lasting.lean:352 Thm** `theorem Collapse.level_not_lasting : Drains step (fun _ => True) (fun b => b = true) (fun _ b => b = true) ∧ (fun (_ : Nat) (b : Bool) => b = true) 1 true ∧ ¬ Lasts step (fun _ => True) (fun b => b = true) 1 true`
- **Lasting.lean:376 Thm** `theorem orbit_mono (mono : ∀ a b, rel a b → rel (g a) (g b)) {a b : V} (below : rel a b) : ∀ n, rel (Law.orbit g a n) (Law.orbit g b n)`
- **Lasting.lean:388 Thm** `theorem below_orbit (trans : ∀ a b c, rel a b → rel b c → rel a c) (mono : ∀ a b, rel a b → rel (g a) (g b)) {x : Nat → V} {v : V} (start : rel (x 0) v) (grows : ∀ n, rel (x (n + 1)) (g (x n))) : ∀ n, rel (x n) (Law.orbit g v n)`
- **Lasting.lean:396 Thm** `theorem stays_below_iff (refl : ∀ a, rel a a) (trans : …) (mono : …) {v θ : V} {n : Nat} : (∀ x : Nat → V, rel (x 0) v → (∀ k, rel (x (k + 1)) (g (x k))) → ∀ k, k ≤ n → rel (x k) θ) ↔ ∀ k, k ≤ n → rel (Law.orbit g v k) θ`
- **Lasting.lean:422 Thm** `theorem exhausts (trans : …) (mono : …) {R : S → Prop} {q : S → V} {θ : V} {level : Nat → S → Prop} (kept : ∀ x a, adm a → R x → R (f x a)) (grows : ∀ x a, adm a → R x → rel (q (f x a)) (g (q x))) (base : ∀ x, guard x → level 0 x) (lowers : ∀ k x a, R x → guard x → adm a → rel (Law.orbit g (q x) (k + 1)) θ → level k (f x a) → level (k + 1) x) {n : Nat} {s : S} (region : R s) (small : rel (Law.orbit g (q s) n) θ) (short : ¬ level n s) (d : Nat → A) (admissible : ∀ k, adm (d k)) : ¬ ∀ k, k ≤ n → guard (history f s d k)`
  Exhaustion by bounded growth (premises as listed).
- **Lasting.lean:451 Thm** `theorem closed_orbit {K : S → Prop} (closed : ∀ x, K x → K (next x)) {s : S} (held : K s) : ∀ n, K (Law.orbit next s n)`
- **Lasting.lean:458 Thm** `theorem avoids_iff_closed {s : S} : (∀ n, ¬ target (Law.orbit next s n)) ↔ ∃ K : S → Prop, K s ∧ (∀ x, K x → ¬ target x) ∧ ∀ x, K x → K (next x)`
- **Lasting.lean:467 Def** `def determined (next : S → S) (x : S) (_ : Unit) : S := next x`
- **Lasting.lean:469 Thm** `theorem orbit_eq_history (next : S → S) (s : S) (d : Nat → Unit) : ∀ n, Law.orbit next s n = history (determined next) s d n`
- **Lasting.lean:476 Thm** `theorem avoids_iff_kernel {s : S} : (∀ n, ¬ target (Law.orbit next s n)) ↔ Kernel (disturbed (determined next) (fun _ => True)) (fun x => ¬ target x) s`
- **Lasting.lean:523 Thm** `theorem fixed_avoids {x : S} (fixed : next x = x) (outside : ¬ target x) : ∀ n, ¬ target (Law.orbit next x n)`
- **Lasting.lean:539 Def** `def Reaches (f : S → A → S) (adm : A → Prop) (target : S → Prop) : Nat → S → Prop | 0, s => target s | n + 1, s => target s ∨ ∀ a, adm a → Reaches f adm target n (f s a)`
- **Lasting.lean:572 Thm** `theorem reaches_iff_funnel {n : Nat} {s : S} : Reaches f adm target n s ↔ ∃ F : Nat → S → Prop, F n s ∧ Funnel f adm target F`
- **Lasting.lean:676 Thm** `theorem Reaches.not_lasts {a₀ : A} (h₀ : adm a₀) : ∀ {n : Nat} {s : S}, Reaches f adm target n s → ¬ Lasts f adm (fun x => ¬ target x) n s`
- **Lasting.lean:716 Thm** `theorem reaches_iff_orbit : ∀ {n : Nat} {s : S}, Reaches (determined next) (fun _ => True) target n s ↔ ∃ k, k ≤ n ∧ target (Law.orbit next s k)` (namespace `Lasting`)
- **Lasting.lean:737 Thm** `theorem orbit_reaches_iff_funnel {n : Nat} {s : S} : (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔ ∃ F : Nat → S → Prop, F n s ∧ (∀ x, F 0 x → target x) ∧ ∀ k x, F (k + 1) x → target x ∨ F k (next x)`
- **Lasting.lean:753 Def** `def hitTime (target : S → Prop) [DecidablePred target] (next : S → S) : Nat → S → Nat | 0, _ => 0 | m + 1, x => if target x then 0 else hitTime target next m (next x) + 1`
- **Lasting.lean:808 Thm** `theorem orbit_reaches_iff_variant [DecidablePred target] {n : Nat} {s : S} : (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔ ∃ V : S → Nat, V s ≤ n ∧ ∀ x, V x ≤ n → target x ∨ V (next x) < V x`
- **Lasting.lean:821 Thm** `theorem reaches_of_not_lasts [DecidablePred target] : ∀ {n : Nat} {s : S}, ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) n s → Reaches (determined next) (fun _ => True) target n s`
- **Lasting.lean:831 Thm** `theorem reaches_iff_not_lasts [DecidablePred target] {n : Nat} {s : S} : Reaches (determined next) (fun _ => True) target n s ↔ ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) n s`
  For a determined law and a decided target, reaching within `n` is not lasting outside it for `n`.
- **Lasting.lean:842 Thm** `theorem dual_needs_decision {next : S → S} {s : S} (dual : ∀ target : S → Prop, ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) 0 s → Reaches (determined next) (fun _ => True) target 0 s) (p : Prop) : ¬ ¬ p → p`
- **Lasting.lean:934 Def** `def Continues (P : Process S A) : Nat → S → Prop | 0, _ => True | n + 1, s => ∃ a t, P.step s a t ∧ Continues P n t`
  Some course of `n` steps starts at `s`: lasting where the step itself may be missing (a partial
  process). This is, for a process, "there is a next for `n` steps".
- **Lasting.lean:939 Def** `def Unbounded (P : Process S A) (s : S) : Prop := ∀ n, Continues P n s`
- **Lasting.lean:947 Thm** `theorem Continues.down {P : Process S A} : ∀ (n : Nat) (s : S), Continues P (n + 1) s → Continues P n s`
- **Lasting.lean:952 Thm** `theorem Continues.decided {P : Process S A} (branching : FinitelyBranching P) : ∀ (n : Nat) (s : S), Decided (Continues P n s)`
- Further (not reproduced): `Unbounded.step_not_not` 991, `Unbounded.step_of_either` 1002, `lifting` 1047, `Chains`, `Fan.no_unbounded_step` 1153.

### 1.5 Mechanism.lean (projections that carry a law; what the step depends on)

- **Mechanism.lean:92 Def** `def Image (P : Process S A) (π : S → K) : Process K A := ⟨fun k a κ => ∃ s u, π s = k ∧ P.step s a u ∧ π u = κ⟩`
- **Mechanism.lean:122 Thm** `theorem image_determined_iff {P : Process S A} {π : S → K} : Determined (Image P π) ↔ GoAlike P π` (through `«像定后当且仅当同行»`).
- **Mechanism.lean:134 Thm** `theorem carries_law_iff {P : Process S A} {π : S → K} : (∃ Q : Process K A, Determined Q ∧ FactorsThrough P π Q) ↔ GoAlike P π`
- **Mechanism.lean:142 Thm** `theorem goAlike_id_iff {P : Process S A} : GoAlike P id ↔ Determined P`
- **Mechanism.lean:149 Thm** `theorem goAlike_const (P : Process S A) (k : K) : GoAlike P (fun _ => k)`
- **Mechanism.lean:166 Thm** `theorem GoAlike.runs_agree {P : Process S A} {π : S → K} (alike : GoAlike P π) (r r' : Run P) (moves : ∀ n, r.act n = r'.act n) (start : π (r.state 0) = π (r'.state 0)) : ∀ n, π (r.state n) = π (r'.state n)`
  The run form of `«同行之迭»`; proved directly by recursion, not through the grammar.
- **Mechanism.lean:180 Def** `def DependsOnlyOn (P : Process S A) (π : S → K) : Prop := ∀ s s' a u u', π s = π s' → P.step s a u → P.step s' a u' → u = u'`
  Configurations alike under `π` go by one move to one configuration. Not a case of
  `GoAlikeUnder` (target class equality, source class sameness under `π`); no grammar statement of it.
- **Mechanism.lean:184 Thm** `theorem DependsOnlyOn.goAlike {P : Process S A} {π : S → K} (only : DependsOnlyOn P π) : GoAlike P π`
- **Mechanism.lean:191 Thm** `theorem DependsOnlyOn.reabsorbed {P : Process S A} {π : S → K} (only : DependsOnlyOn P π) (r r' : Run P) (moves : ∀ n, r.act n = r'.act n) (start : π (r.state 0) = π (r'.state 0)) : ∀ n, r.state (n + 1) = r'.state (n + 1)`
- **Mechanism.lean:203 Thm** `theorem dependsOnlyOn_iff {next : S → S} {π : S → K} : DependsOnlyOn (process next) π ↔ ∀ s s', π s = π s' → next s = next s'` (namespace `Law`)
  The right side is, verbatim, `Learning.Lumped π next` (Learning.lean 834: `def Lumped (π : I → K) (g : I → V) : Prop := ∀ i i', π i = π i' → g i = g i'`); no lemma says so.
- **Mechanism.lean:211 Thm** `theorem reabsorbed {next : S → S} {π : S → K} (only : ∀ s s', π s = π s' → next s = next s') {s s' : S} (same : π s = π s') : ∀ n, orbit next s (n + 1) = orbit next s' (n + 1)` (namespace `Law`)
- **Mechanism.lean:225 Def** `def adaptive (F : R → X → U → X) (G : R → X → R) : Process (X × R) U := ⟨fun s u s' => s' = (F s.2 s.1 u, G s.2 s.1)⟩`
- **Mechanism.lean:234 Thm** `theorem adaptive_state_law_iff {F : R → X → U → X} {G : R → X → R} : GoAlike (adaptive F G) Prod.fst ↔ ∀ g g' x u, F g x u = F g' x u`
  The state alone goes alike exactly where the rule makes no difference to it: (b) for the class
  "same state", the untold part being the rule.
- **Mechanism.lean:258 Thm** `theorem Run.steps_by_rule {F : R → X → U → X} {G : R → X → R} (r : Run (adaptive F G)) {g : R} {t : Nat} (stays : ∀ n, n < t → (r.state n).2 = g) : r.StepsThrough Prod.fst (ruleLaw F g) t`
- **Mechanism.lean:289 Thm** `theorem not_fixesThrough_of_untaken (r : Run P) {π : S → K} {t : Nat} {k : K} {a : A} (law : ∃ Q : Process K A, Determined Q ∧ r.StepsThrough π Q t) (untaken : ¬ r.TakesThrough π t k a) {κ₁ κ₂ : K} (two : κ₁ ≠ κ₂) : ¬ ∃ κ, r.FixesThrough π t k a κ` (namespace `Run`)
  Docstring: "A change of mechanism at a projected configuration not yet met does not show before
  it happens." A reading; the statement is about records fixing outcomes.
- **Mechanism.lean:303 Thm** `theorem not_fixesThrough_of_goAlike (r : Run P) {π : S → K} (alike : GoAlike P π) …` (same conclusion with `GoAlike`).
- **Mechanism.lean:371-388** `Coarse`: `¬ Determined process ∧ FactorsThrough process Prod.fst (Law.process not) ∧ Determined (Law.process not)` (`carries`, 385).
- **Mechanism.lean:424 Thm** `theorem Switching.no_state_law {t : Nat} (two : 2 ≤ t) : ¬ ∃ Q : Process Bool Unit, Determined Q ∧ run.StepsThrough Prod.fst Q t`

### 1.6 Unfolding.lean (determined law read through a map)

- **Unfolding.lean:448 Def** `def Law.frameBy (next : S → S) (o : S → R) : Frame S Unit R := ⟨Law.process next, fun s r => o s = r⟩`
- **Unfolding.lean:457 Thm** `theorem Law.alike_future {next : S → S} {o : S → R} : ∀ n {s s' : S}, Alike (Law.frameBy next o) (Law.frameBy next o) s s' → o (Law.orbit next s n) = o (Law.orbit next s' n)`
- **Unfolding.lean:469 Thm** `theorem Law.sameFuture_bisimulation {next : S → S} {o : S → R} : Bisimulation (Law.frameBy next o) (Law.frameBy next o) (Law.SameFuture next o)`
- **Unfolding.lean:481 Thm** `theorem Law.alike_iff_sameFuture {next : S → S} {o : S → R} {s s' : S} : Alike (Law.frameBy next o) (Law.frameBy next o) s s' ↔ Law.SameFuture next o s s'`
- **Unfolding.lean:486 Thm** `theorem Law.IdentifiesAlike.carries {next : S → S} {o : S → R} {K : Type u'} {π : S → K} (sense : IdentifiesAlike (Law.frameBy next o) π) : ∃ Q : Process K Unit, Determined Q ∧ FactorsThrough (Law.process next) π Q`
- **Unfolding.lean:365 Thm** `theorem IdentifiesAlike.carries {F : Frame S A C} {π : S → K} (sense : IdentifiesAlike F π) (determined : ∀ s, DeterminedAt F s) : ∃ Q : Process K A, Determined Q ∧ FactorsThrough F.P π Q`
- **Unfolding.lean:182 Thm** `theorem closedBy_runs_agree (determined : Determined P) {policy : S → A} (r r' : Run (closedBy P policy)) (start : r.state 0 = r'.state 0) : ∀ n, r.state n = r'.state n`

### 1.7 Labelled.lean (likeness; drawdown along runs; traces as `«迭»`)

- **Labelled.lean:293 Def** `def Bisimulation (F : Frame S A C) (G : Frame S' A C) (B : S → S' → Prop) : Prop := ∀ s s', B s s' → (∀ c, F.realized s c ↔ G.realized s' c) ∧ (∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ B t t') ∧ (∀ a t', G.P.step s' a t' → ∃ t, F.P.step s a t ∧ B t t')`
- **Labelled.lean:302 Def** `def Alike (F : Frame S A C) (G : Frame S' A C) (s : S) (s' : S') : Prop := ∃ B, Bisimulation F G B ∧ B s s'`
  Note: likeness by bisimulation does tell a configuration with a step from one without (the
  "forth" clause), unlike `GoAlike`, which is silent where a step is missing.
- **Labelled.lean:397 Def** `def DeterminedAt (F : Frame S A C) (s : S) : Prop := ∀ a t t', F.P.step s a t → F.P.step s a t' → Alike F F t t'`
- **Labelled.lean:410 Thm** `theorem DeterminedAt.goAlike {F : Frame S A C} {s s' : S} (alike : Alike F F s s') (determined : DeterminedAt F s') {a : A} {t t' : S} (step : F.P.step s a t) (step' : F.P.step s' a t') : Alike F F t t'`
- **Labelled.lean:421 Def** `def IdentifiesAlike (F : Frame S A C) (π : S → K) : Prop := ∀ s s', π s = π s' ↔ Alike F F s s'`
- **Labelled.lean:426 Thm** `theorem identifiesAlike_iff {F : Frame S A C} {π : S → K} : IdentifiesAlike F π ↔ Bisimulation F F (fun s s' => π s = π s') ∧ ∀ s s', Alike F F s s' → π s = π s'`
- **Labelled.lean:441 Thm** `theorem IdentifiesAlike.unique …`; **446** `theorem identifiesAlike_id_iff {F : Frame S A C} : IdentifiesAlike F id ↔ ∀ s s', Alike F F s s' → s = s'`
- **Labelled.lean:515 Thm** `theorem Run.not_of_depletion {P : Process S A} (reserve : S → Nat) (lowers : ∀ s a t, P.step s a t → reserve t < reserve s) (r : Run P) : False`
  Where every step lowers a reserve, no infinite run exists: (c) in its crudest form.
- **Labelled.lean:530 Thm** `theorem Run.renewal_recurs {P : Process S A} (r : Run P) (rank : S → Nat) (renewal : Nat → Prop) (lowers : ∀ n, ¬ renewal n → rank (r.state (n + 1)) < rank (r.state n)) (start : Nat) : ¬ ∀ n, start ≤ n → ¬ renewal n`
- **Labelled.lean:541 Thm** `theorem Conditions.drawdown_not_recurring {F C : Type} (K : Conditions S F C) {P : Process S A} (r : Run P) (f : F) (c : C) (T : Nat) (unrenewed : ∀ t, T ≤ t → K.level (r.state (t + 1)) c ≤ K.level (r.state t) c) (lowers : ∀ t, T ≤ t → K.active (r.state t) f → K.level (r.state (t + 1)) c < K.level (r.state t) c) : ¬ ∀ N, ∃ t, N ≤ t ∧ K.active (r.state t) f`
  A formation that lowers an unrenewed condition at each active step is not active at arbitrarily
  late steps: (c) with a level and a draw.
- **Labelled.lean:924 Def** `def WithinMoves (P : Process S A) (realized : S → C → Prop) (s : S) (n : Nat) (bundle : C → Prop) : Prop := ∃ word t, Trace P s word t ∧ word.length ≤ n ∧ ∀ c, bundle c → realized t c`
- **Labelled.lean:936 Thm** `theorem trace_steps : ∀ {s t : S} {xs : List A}, Trace P s xs t → «迭» (Steps P) xs.length s t`
- **Labelled.lean:941 Thm** `theorem trace_iff_steps : ∀ {k : Nat} {s t : S}, (∃ xs : List A, xs.length = k ∧ Trace P s xs t) ↔ «迭» (Steps P) k s t`
  A trace of `k` moves is `k` grammar steps of `Steps P`, for every process, partial ones included.
- **Labelled.lean:951 Thm** `theorem withinMoves_iff_withinSteps {s : S} {n : Nat} : WithinMoves P realized s n bundle ↔ ∃ t, «迭内» (Steps P) n s t ∧ ∀ c, bundle c → realized t c`

### 1.8 IdentificationRuns.lean (descriptions that make sense under a determined law)

- **IdentificationRuns.lean:102 Thm** `theorem kernel_bisimulation {next : S → S} {o : S → R} {π : S → K} (keeps : ∀ s s', π s = π s' → o s = o s') (alike : GoAlike (process next) π) : Bisimulation (frameBy next o) (frameBy next o) (fun s s' => π s = π s')` (namespace `Law`)
- **IdentificationRuns.lean:112 Thm** `theorem sameFuture_of_law {next : S → S} {o : S → R} {π : S → K} (keeps : ∀ s s', π s = π s' → o s = o s') (alike : GoAlike (process next) π) {s s' : S} (same : π s = π s') : SameFuture next o s s'`
- **IdentificationRuns.lean:133 Thm** `theorem now_identifiesAlike_iff {next : S → S} {o : S → R} : IdentifiesAlike (frameBy next o) o ↔ ∀ s s', o s = o s' → SameFuture next o s s'`
- **IdentificationRuns.lean:146 Thm** `theorem part_identifiesAlike_iff {X : Type u} {C : Type v} {next : X × C → X × C} : IdentifiesAlike (frameBy next Prod.fst) Prod.fst ↔ ∀ x c c', SameFuture next Prod.fst (x, c) (x, c')`
- **IdentificationRuns.lean:163 Thm** `theorem sameFuture_of_goAlike {next : S → S} {o : S → R} (alike : GoAlike (process next) o) : ∀ s s', o s = o s' → SameFuture next o s s'`
  Proof: `«同行之迭» (goAlikeUnder_iff_alike.mp alike ()) n e (steps_orbit next n s) (steps_orbit next n s')`.
  This is the one place in my files where the root's `«同行之迭»` is applied to a law's orbit.
- **IdentificationRuns.lean:170 Thm** `theorem now_identifiesAlike_iff_goAlike {next : S → S} {o : S → R} : IdentifiesAlike (frameBy next o) o ↔ GoAlike (process next) o`
  The map's present value makes sense by itself exactly where it goes alike under the law; no premise.
  `now_identifiesAlike_iff` gives the left as "same value now gives same future", and
  `Learning.goAlike_iff_lumped` (LearningRuns.lean 113) reads `GoAlike` as a one-step condition.
- **IdentificationRuns.lean:177 Thm** `theorem part_identifiesAlike_iff_step {X : Type u} {C : Type v} {next : X × C → X × C} : IdentifiesAlike (frameBy next Prod.fst) Prod.fst ↔ ∀ x c c', (next (x, c)).1 = (next (x, c')).1`
  The part alone makes sense exactly where the rest makes no difference to its next value; no premise.
- **IdentificationRuns.lean:193 Thm** `theorem adaptive_identifiesAlike_iff {X : Type u} {C : Type v} (F : C → X → X) (G : C → X → C) : IdentifiesAlike (frameBy (fun s : X × C => (F s.2 s.1, G s.2 s.1)) Prod.fst) Prod.fst ↔ ∀ x c c', F c x = F c' x`
- **IdentificationRuns.lean:310 Def** `def KeepsRelation (T : S → S) (rel : S → S → Prop) : Prop := ∀ x y, rel x y → rel (T x) (T y)` (namespace `Law`)
- **IdentificationRuns.lean:320 Def** `def KeepsAndCarries (next : S → S) (o : S → R) (π : S → K) : Prop := (∀ s s', π s = π s' → o s = o s') ∧ GoAlike (process next) π`
- **IdentificationRuns.lean:328 Thm** `theorem sameFuture_coarsest : (∀ s s', SameFuture next o s s' → o s = o s') ∧ KeepsRelation next (SameFuture next o) ∧ ∀ E : S → S → Prop, (∀ s s', E s s' → o s = o s') → KeepsRelation next E → ∀ s s', E s s' → SameFuture next o s s'`
  The same course is the coarsest relation keeping the values that the law keeps. GrammarCourse.lean
  128 (`core_is_sameFuture`, not my file) proves it is `«核» (step next) (sameValue o)`.
- **IdentificationRuns.lean:356 Thm** `theorem coarsest_iff {π : S → K} (lawful : KeepsAndCarries next o π) : … ∧ ((∀ s s', π s = π s' ↔ SameFuture next o s s') ↔ IdentifiesAlike (frameBy next o) π)` (three conjoined iffs; see source).
- **IdentificationRuns.lean:506 Thm** `theorem sameAhead_iff_alike (reg : S → R) (r : Run (Law.process next)) {t t' : Nat} : SameAhead (Parting.course reg r) t t' ↔ Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state t) (r.state t')`

### 1.9 Likeness.lean (header read; declarations used by the files above)

- **Likeness.lean:171 Def** `def RespectsClaims (claims : K → D → Prop) (E : K → K → Prop) : Prop := ∀ k k', E k k' → ∀ d, claims k d ↔ claims k' d`
- **Likeness.lean:177 Def** `def imageUnder (P : Process S A) (π : S → K) (E : K → K → Prop) : Process K A := ⟨fun k a κ => ∃ s u, E k (π s) ∧ P.step s a u ∧ E (π u) κ⟩`
- **Likeness.lean:219 Thm** `theorem carries_law_alike_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} : (∃ Q : Process K A, (∀ k, DeterminedAt (⟨Q, claims⟩ : Frame K A D) k) ∧ FactorsThrough P π Q) ↔ ∃ E : K → K → Prop, Equivalence E ∧ RespectsClaims claims E ∧ GoAlikeUnder P π E`
  The one theorem in my files where `GoAlikeUnder` with a non-equality `E` is the subject.
- **Likeness.lean:240 Thm** `theorem carries_law_named_iff {P : Process S A} {π : S → K} : (∃ Q : Process K A, (∀ k, DeterminedAt (⟨Q, fun k k' => k = k'⟩ : Frame K A K) k) ∧ FactorsThrough P π Q) ↔ GoAlike P π`
- **Likeness.lean:262 Thm** `theorem image_determinedAt_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} : (∀ k, DeterminedAt (⟨Image P π, claims⟩ : Frame K A D) k) ↔ GoAlikeUnder P π (Alike (⟨Image P π, claims⟩ : Frame K A D) ⟨Image P π, claims⟩)`
- **Likeness.lean:1331 Thm** `theorem alikeTo_frameBy_iff {R : Type w} {next : S → S} {next' : S' → S'} {o : S → R} {o' : S' → R} : ∀ {k : Nat} {s : S} {s' : S'}, AlikeTo (Law.frameBy next o) (Law.frameBy next' o') k s s' ↔ ∀ n, n ≤ k → o (Law.orbit next s n) = o' (Law.orbit next' s' n)`
- **Likeness.lean:1393 Def** `def EndOfPath.frame (M : Nat) : Frame (Fin (M + 2)) Unit Empty := ⟨⟨fun s _ t => t.val = s.val + 1⟩, fun _ c => nomatch c⟩`
  A path whose last place steps nowhere: a partial determined law.
- **Likeness.lean:1447 Thm** `theorem EndOfPath.classes_exact (M : Nat) : FiniteDecided (frame M) ∧ (finBelow (M + 2) (M + 2) (Nat.le_refl _)).length = M + 2 ∧ AlikeTo (frame M) (frame M) M (first M) (second M) ∧ ¬ Alike (frame M) (frame M) (first M) (second M)`
  The first two places, alike to depth `M` and not alike: they differ only in how long is left
  before a place with no next. Header line 89: "A frame's extra step is where whether a move can be
  taken at all makes a difference." This is the package's existing witness, in the likeness
  vocabulary, of (b)/(c): alike until the end, told apart only by having a next.
- **Likeness.lean:1500 Def** `def EitherThroughout : Prop := ∀ α β : Nat → Prop, (∀ k, Decided (α k)) → (∀ k, Decided (β k)) → (∀ k, α (k + 1) → α k) → (∀ k, β (k + 1) → β k) → (∀ k, α k ∨ β k) → (∀ k, α k) ∨ (∀ k, β k)` (used by Lasting 1002-1047)
- **Likeness.lean:1584 Def** `def LLPO : Prop`; **1739 Thm** `theorem eitherThroughout_iff_llpoForDecided : EitherThroughout ↔ LLPOForDecided`; **1743 Thm** `theorem LLPO.of_eitherThroughout (either : EitherThroughout) : LLPO`.

### 1.10 Outside my files, met while answering (statements copied, not mapped further)

- **GrammarCourse.lean:103 Def** `def step (next : S → S) : «际» S := fun s t => t = next s` (namespace `Law`) - definitionally the relation `fun x y => (process next).step x () y`.
- **GrammarCourse.lean:107 Thm** `theorem step_hasSucc_iff {next : S → S} {E : «际» S} {s : S} : «有后» (step next) E s ↔ E s (next s)`
- **GrammarCourse.lean:112 Thm** `theorem constant_iff_keeps {next : S → S} {E : «际» S} : «有常» (step next) E ↔ KeepsRelation next E`
- **GrammarCourse.lean:164 Thm** `theorem ends_iff_changes {next : S → S} {o : S → R} {s : S} : «亡» (step next) (sameValue o) s ↔ ¬ o s = o (next s)`
- **GrammarCourse.lean:169 Thm** `theorem line_on_orbit {next : S → S} {E : «际» S} {s y : S} (line : «相续» (step next) E s y) : ∃ n, y = orbit next s (n + 1)`
- **GrammarCourse.lean:200 Thm** `theorem unending_iff {next : S → S} {o : S → R} {s : S} : «不穷» (step next) (sameValue o) s ↔ ∀ n, o (orbit next s n) = o s`
- **GrammarCourse.lean:217 Thm** `theorem continues_in_core_iff {next : S → S} {o : S → R} {s : S} : «续» (step next) («核» (step next) (sameValue o)) s (next s) ↔ «不穷» (step next) (sameValue o) s`
- **LastingRuns.lean:218 Thm** `theorem determined_lasts_iff_courses {guard : S → Prop} {n : Nat} {s : S} : Lasting.Lasts (Lasting.determined next) (fun _ => True) guard n s ↔ ∀ plan t, Trace (Law.process next) s plan t → plan.length ≤ n → guard t`
- **Branching.lean:545 Thm** `theorem law_run_state {next : S → S} (r : Run (Law.process next)) : ∀ n, r.state n = Law.orbit next (r.state 0) n`
- **LearningRuns.lean:113 Thm** `theorem goAlike_iff_lumped {next : S → S} {π : S → K} : GoAlike (Law.process next) π ↔ Lumped π (fun s => π (next s))` (namespace `Learning`)

---

## 2. Answers

### (1) Law.orbit, Law.run, Law.process, steps_orbit, step_fixed, and the ties to `«迭»` and `«定后»`

Exact statements are in 1.3: `Law.process` (Recurrence 143), `Law.orbit` (240), `orbit_add` (244),
`orbit_shift` (249), `steps_orbit` (255), `step_fixed` (263), `Law.run` (322), `run_state` (325),
`Branching.law_trace_iff` (294), `Branching.law_reach_iff` (304), `next_fixed` (536),
`next_total` (540), `reaches_iff_orbit` (549, on `«及»`), `Lossless.cancel` (589, `«迭之定前»`),
`orbit_mul` (269, `«迭之周»` and `«迭之定»`). General ties of any process to the grammar:
`determined_iff_fixed` (Laws 120: `Determined P ↔ ∀ a, «定后» (fun s t => P.step s a t)`),
`trace_iff_steps` (Labelled 941: traces of `k` moves are `«迭» (Steps P) k`), `reach_iff_withinClosure`
(Frame 251), `Branching.returns_iff_reaches` (Recurrence 391), `Branching.lossless_iff_fixedBefore`
(397). Users of `steps_orbit` with a grammar law: `orbit_mul`, `Law.Lossless.cancel`,
`Law.sameFuture_of_goAlike` (IdentificationRuns 163, with `«同行之迭»`).

What is not there: the converse of `steps_orbit` as its own lemma (`«迭» … n s t → t = orbit next s n`);
it is one line from `«迭之定» (step_fixed next) n h (steps_orbit next n s)`.

### (2) Lasting.Lasts and the laws about lasting, ending, reaching

Exact statements in 1.4. The set: `Lasts` (107), `Lasts.within` (136), `lasts_iff_ladder` (152),
`lasts_iff_necessary` (169), `lasts_iff_of_exact` (175), `Lasts.histories` (188),
`lasts_iff_histories` (212, one admissible move), `Lasts.trace` (218), `kernel_iff_lasts` (236),
`guarded_upto_iff` (290) and `guarded_none_iff` (303) (decided guard, start inside), `Drains.along`
(321), `Drains.leaves` (333), `exhausts` (422), `avoids_iff_closed` (458), `avoids_iff_kernel` (476),
`some_avoids_iff` (492), `none_avoid_iff` (504), `fixed_avoids` (523), `Reaches` (539),
`reaches_iff_funnel` (572), `reaches_iff_basin` (596), `Reaches.histories` (639),
`reaches_iff_histories` (669, decided target, one admissible move), `Reaches.not_lasts` (676),
`Lasting.reaches_iff_orbit` (716), `orbit_reaches_iff_funnel` (737), `orbit_reaches_iff_variant`
(808, decided target), `reaches_of_not_lasts` (821) and `reaches_iff_not_lasts` (831) (determined
law, decided target), `dual_needs_decision` (842), `Continues` (934), `Unbounded` (939).

Do they cover "a determined step with a condition for there being a next"? No, not as such.
- `Lasts` is over a total law `f : S → A → S`; the guard is a property of positions, and
  `Lasts … n s` checks positions `0..n` (n + 1 of them). Nothing in Lasting is stated on a relation
  that has no successor where the guard fails, nor in `«迭»`, `«亡»` or `«不穷»`.
- `guardedStep`/`guardedHistory` (Viability) stop where the guard fails at the source or the
  target, and are on `Option` with a decided guard.
- `Continues P n s` is "some course of n steps", which for a partial process is exactly "there is a
  next for n steps"; it has no orbit form and no tie to `«迭»` in my files (though by
  `trace_iff_steps` it is `∃ t, «迭» (Steps P) n s t` after unfolding; not stated).
- `Assurance.ofPartial` (Laws 70) is a determined step with a condition for a next, but via
  `Option`; `trace_ofPartial_iff` relates its traces to `runPartial`, not to an orbit or a guard.
"Reaches iff not lasts" (`reaches_iff_not_lasts`, 831) is for a determined total law and a decided
target, `Reaches … n` against `Lasts … (fun x => ¬ target x) n`; constructively the decision is
needed (`dual_needs_decision`).

### (3) GoAlike, GoAlikeUnder, DependsOnlyOn, IdentifiesAlike and the iffs

Statements in 1.2, 1.5, 1.7, 1.8. Relations among them:
- `GoAlike P π := GoAlikeUnder P π Eq` (by definition).
- `goAlikeUnder_iff_alike`: `GoAlikeUnder P π E ↔ ∀ a, «同行» (fun s t => P.step s a t) (fun s s' => E (π s) (π s'))`; so `GoAlike P π` is `«同行»` at each move under "same value of π". No premise.
- `DependsOnlyOn P π → GoAlike P π` (`DependsOnlyOn.goAlike`); for a law, `DependsOnlyOn (process next) π ↔ ∀ s s', π s = π s' → next s = next s'` (= `Lumped π next`, unstated). Converse false in general (any law: `goAlike_const`). DependsOnlyOn has no grammar form.
- `GoAlike (Law.process next) π ↔ Lumped π (fun s => π (next s))` (`Learning.goAlike_iff_lumped`, outside).
- `IdentifiesAlike F π := ∀ s s', π s = π s' ↔ Alike F F s s'` (by definition).
- `Law.now_identifiesAlike_iff_goAlike`: `IdentifiesAlike (frameBy next o) o ↔ GoAlike (process next) o`, via `now_identifiesAlike_iff` and `sameFuture_of_goAlike` (`«同行之迭»`).
- `Law.part_identifiesAlike_iff_step`: `IdentifiesAlike (frameBy next Prod.fst) Prod.fst ↔ ∀ x c c', (next (x, c)).1 = (next (x, c')).1`; this is `now_identifiesAlike_iff_goAlike` at `o = Prod.fst` plus `goAlike_iff_lumped`. Its adaptive case is `adaptive_identifiesAlike_iff`, matching `adaptive_state_law_iff` (Mechanism 234) for the process form.
- `carries_law_iff`: some determined law on the description admits the steps ↔ `GoAlike P π`; `carries_law_alike_iff` is the up-to-likeness form with `GoAlikeUnder P π E`, `E` an equivalence respecting claims.
All of these are about a total determined law (`process next`) or are silent where a step is
missing: `GoAlike`/`GoAlikeUnder`/`«同行»` say nothing about one alike configuration having a next
and another none. Telling those apart is `«有常»`'s job (`«有常则可续»`, GrammarLaws 2592) and
`Alike`'s (bisimulation "forth" clause; witness `EndOfPath.classes_exact`).

### (4) What would be duplicated by the three planned lemmas

Take the guarded relation `G := fun s t => guard s ∧ t = next s`.

(i) "n steps of G end at t exactly where the run lasted n steps and t is the orbit's n-th state."
Not in my files in this form; the only instance is the held attempt's `TurningInTime.Course.steps_iff`
(TurningInTime 249), stated on its `Course`. It would not duplicate a theorem here, but it must be
built from what exists: `Law.orbit`, `orbit_shift`, `steps_orbit` (the unguarded direction),
`«迭之定»` with a fixed-successor proof (cf. `step_fixed`, and the attempt's `cond_fixed`, which is
`«定后»` for a relation contained in `Law.step next`). "Lasted n steps" must not be a new `Lasts`:
`Lasting.Lasts (Lasting.determined next) (fun _ => True) guard` exists, with an off-by-one: the
attempt's `Course.Lasts s n := ∀ j, j < n → …` is `Lasting.Lasts … (n - 1) s` for `n > 0`
(`Lasting.Lasts … m s` checks `k ≤ m`). The bridge `Lasting.Lasts (determined next) (fun _ => True) guard m s ↔ ∀ k, k ≤ m → guard (Law.orbit next s k)` follows from `lasts_iff_histories` (a₀ := ()) and `orbit_eq_history`, and is not stated (LastingRuns 218 states the courses form). For partial processes in general, `trace_iff_steps` (Labelled 941) plus `Continues` already give "n steps exist"; with `ofPartial`, `trace_ofPartial_iff` gives the run form.

(ii) "An occurrence ends exactly where the guard fails": `«亡» G «一» t ↔ ¬ guard t`. Not in my
files. Its sibling for a total step and a class is GrammarCourse 164 `ends_iff_changes`
(`«亡» (step next) (sameValue o) s ↔ ¬ o s = o (next s)`), with `step_hasSucc_iff` (107). It would
use `«一之续»` (Grammar 162). The attempt's `ends_iff` (TurningInTime 242) is its `Course` case.

(iii) "The line never ends exactly where the guard holds at every step":
`«不穷» G «一» s ↔ ∀ n, guard (Law.orbit next s n)`. Not in my files on `«不穷»`. Its right side is
already Lasting's: by `kernel_iff_lasts` and `lasts_iff_histories` it is
`Kernel (disturbed (determined next) (fun _ => True)) guard s` and `∀ n, Lasts … guard n s`; by
`avoids_iff_closed` it has a closed-set certificate, but only for `∀ n, ¬ target (orbit n)`, which
at `target := ¬ guard` gives `¬¬ guard`, not `guard` (constructive gap). The sibling on a total
step and a class is GrammarCourse 200 `unending_iff`, with `line_on_orbit` (169) and
`reached_while_same` (181), whose proof pattern is the attempt's `never_ends_iff` (TurningInTime 284)
almost line for line. The attempt's `lasts_or_ended` (269) is a decidable split of `Lasts`; with
`Lasting.Lasts` it would follow from `reaches_iff_not_lasts`-style reasoning only under a decided
guard.

---

## 3. Not read or not settled

- Likeness.lean: read the header (1-154), 162-270, 1325-1460, and the definitions at 1500, 1584,
  1739-1745. The rest (branching tests, `AlikeTo`, `FiniteDecided`, `OutcomesListed`, the excluded
  middle witnesses) was not read.
- Lasting.lean 900-1164 (Search, Lifting, Chains, Fan) read only for declaration lines and
  `Continues`/`Unbounded`/`FinitelyBranching`.
- Labelled.lean 549-866 (the Renewable, Crossing, Pinned witness runs) not read beyond names.
- IdentificationRuns.lean 420-863 (prefix bounds, extrapolation, web couplings) read for
  declaration names only.
- Unfolding.lean: everything read; the World/exchange part is not about (a)-(d) and is not mapped.
- Not checked whether any declaration elsewhere (GrammarCourse, GrammarPath, Persistence, Courses,
  LastingRuns, RegimeMargin, LoopReturn) already states (i)-(iii) for a guarded relation; my grep
  found no `«亡»`/`«不穷»` lemma on a relation of the form `guard s ∧ t = next s`, but the search
  was by pattern, not exhaustive.
- Axiom reports and the build were taken on the files' word.
- Docstrings that say more than, or other than, the statements:
  - Recurrence header, lines 69-70 ("its orbit is a run of it (`Law.run`, `Becoming.Labelled`)")
    and 100-101 ("The laws of reach along runs (`Law.run`, ...) stay in `Becoming.Labelled`"), and
    Labelled header 44-46 ("the run of a determined law ... moved here"): `Law.run` is defined in
    Recurrence.lean 322, not in Labelled.
  - Lasting header 40-41, "in Aubin's terms this is also the viability kernel": a reading, not
    proved.
  - Mechanism 288, "A change of mechanism ... does not show before it happens": a reading of a
    statement about which outcomes a record fixes.
  - Mechanism 166 `GoAlike.runs_agree` and Unfolding 182 `closedBy_runs_agree` are proved by
    recursion, not through `«同行之迭»`, though they are its run form; no docstring claims otherwise.
