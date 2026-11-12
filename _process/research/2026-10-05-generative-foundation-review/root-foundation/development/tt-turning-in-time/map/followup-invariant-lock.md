Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

Follow-up map: is the capture lock (`RuleCapture.Locked`) proved as an `Invariant` / `ClosedUnder` of the paced law?

PKG = /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/
Read-only; nothing built or run. Line numbers are of the working tree on 12 November 2026 (RuleCapture.lean last touched in 565601488).

## 1. Inventory

### Frame.lean

- Frame.lean:86, definition `ClosedUnder`
  ```lean
  def ClosedUnder {X : Type u} (rel : X → X → Prop) (region : X → Prop) : Prop :=
    «闭» rel region
  ```
  A region is closed under a relation: whatever a member bears the relation to is a member. By definition this is the grammar's `«闭»`.

- Frame.lean:91, definition `WithinClosure`
  ```lean
  def WithinClosure {X : Type u} (rel : X → X → Prop) (f g : X) : Prop :=
    «所闭» rel f g
  ```
  `g` lies within `f`'s closure: every region closed under `rel` that holds `f` holds `g`. This is the grammar's `«所闭»`.

- Frame.lean:241, definition `Steps`
  ```lean
  def Steps (P : Process S A) (s t : S) : Prop := ∃ a, P.step s a t
  ```
  One step of a process, whatever its action.

- Frame.lean:251, theorem `reach_iff_withinClosure`
  ```lean
  theorem reach_iff_withinClosure {P : Process S A} {s t : S} :
      Reach P s t ↔ WithinClosure (Steps P) s t
  ```
  Reach is exactly the grammar's closure of one step.

- Frame.lean:258, theorem `Run.reach`
  ```lean
  theorem Run.reach {P : Process S A} (r : Run P) (n k : Nat) :
      Reach P (r.state n) (r.state (n + k))
  ```
  A run reaches every later state from every earlier one.

- Frame.lean:265, definition `Invariant`
  ```lean
  def Invariant (P : Process S A) (I : S → Prop) : Prop :=
    ∀ s a t, P.step s a t → I s → I t
  ```
  A property kept by every admissible step.

- Frame.lean:268, theorem `Invariant.trace`
  ```lean
  theorem Invariant.trace {P : Process S A} {I : S → Prop} (inv : Invariant P I)
      {s t : S} {as : List A} (h : Trace P s as t) : I s → I t
  ```
  An invariant is carried along every core trace.

- Frame.lean:275, theorem `invariant_iff_closedUnder`
  ```lean
  theorem invariant_iff_closedUnder {P : Process S A} {I : S → Prop} :
      Invariant P I ↔ ClosedUnder (Steps P) I
  ```
  An invariant is exactly a region closed (grammar `«闭»`) under the steps.

- Frame.lean:282, theorem `Invariant.reach`
  ```lean
  theorem Invariant.reach {P : Process S A} {I : S → Prop} (inv : Invariant P I)
      {s t : S} (reached : Reach P s t) : I s → I t
  ```
  An invariant holding at `s` holds wherever `s` reaches. Proved through `reach_iff_withinClosure` and `invariant_iff_closedUnder`, i.e. as the grammar's closure law.

- Frame.lean:286, theorem `Invariant.run`
  ```lean
  theorem Invariant.run {P : Process S A} {I : S → Prop} (inv : Invariant P I)
      (r : Run P) (start : I (r.state 0)) : ∀ n, I (r.state n)
  ```
  An invariant holding at a run's start holds at every step of it.

### Attraction.lean (section `Processes`, 416-459, and the start of `Ratchet`)

- Attraction.lean:110, definition `Law.Absorbing` (outside the assigned range; read only for the statement below)
  ```lean
  def Absorbing (next : S → S) (R : S → Prop) : Prop := ∀ s, R s → R (next s)
  ```
  A region a determined law never leaves.

- Attraction.lean:421, theorem `Law.absorbing_iff_invariant`
  ```lean
  theorem Law.absorbing_iff_invariant {next : S → S} {R : S → Prop} :
      Law.Absorbing next R ↔ Invariant (Law.process next) R
  ```
  For a determined law, absorbing regions are exactly the invariants of its process.

- Attraction.lean:427, definition `AbsorbingUnder`
  ```lean
  def AbsorbingUnder (P : Process S A) (R : S → Prop) (a : A) : Prop :=
    ∀ s t, R s → P.step s a t → R t
  ```
  Every step by the move `a` from inside `R` stays inside.

- Attraction.lean:432, theorem `invariant_iff_every_move`
  ```lean
  theorem invariant_iff_every_move {R : S → Prop} : Invariant P R ↔ ∀ a, AbsorbingUnder P R a
  ```
  A region is invariant exactly where it is absorbing under every move.

- Attraction.lean:437, theorem `Invariant.locks_out`
  ```lean
  theorem Invariant.locks_out {R : S → Prop} (invariant : Invariant P R) {t s : S}
      (inside : R t) (outside : ¬ R s) : ¬ Reach P t s
  ```
  From inside an invariant region, no configuration outside it is reachable. Premise: the region is an `Invariant` of `P`.

- Attraction.lean:443, theorem `Run.locked_in`
  ```lean
  theorem Run.locked_in (r : Run P) {R : S → Prop} (invariant : Invariant P R) {n m : Nat}
      (inside : R (r.state n)) (outside : ¬ R (r.state m)) : ∀ k, r.state (n + k) ≠ r.state m
  ```
  Along a run, from a step inside an invariant region, no later state equals a state at which the run was outside. Premise: an `Invariant`. Note the conclusion is an inequality of states, not "stays inside" (that is `Invariant.reach` / `Invariant.run`).

- Attraction.lean:448, theorem `Run.stays`
  ```lean
  theorem Run.stays (r : Run P) {R : S → Prop} {n : Nat}
      (keeps : ∀ k, AbsorbingUnder P R (r.act (n + k))) (inside : R (r.state n)) :
      ∀ k, R (r.state (n + k))
  ```
  If every move the run actually takes from step `n` on keeps `R`, the run stays in `R`. Weaker premise than `Invariant` (only the moves taken).

- Attraction.lean:455, theorem `Run.leaving_needs`
  ```lean
  theorem Run.leaving_needs (r : Run P) {R : S → Prop} {n : Nat} (inside : R (r.state n))
      (leaves : ¬ R (r.state (n + 1))) : ¬ AbsorbingUnder P R (r.act n)
  ```
  A run that leaves `R` at step `n + 1` took a move at `n` that does not keep `R`. This is the process-level form of "turning needs a move outside what the region keeps" (pattern (d), weakest form).

- Attraction.lean:465-473, namespace `Ratchet`: `def next (_ : Bool) : Bool := true`, `def atTrue (s : Bool) : Prop := s = true`, `theorem merges : Law.Merges next`. A witness that every configuration goes to `true` (a merging law). Lines 519-553 (outside the range; seen only by grep): `Ratchet.keeps : AbsorbingUnder process atTrue false`, `Ratchet.leaves : ¬ AbsorbingUnder process atTrue true`, `Ratchet.locked_in`, and a run with `¬ AbsorbingUnder process atTrue (leaving.act 0)` — a witness of `invariant_iff_every_move` failing for one move.

- Attraction.lean 375-415 (in range, not about locks): `basin_one_cycle`, `succ_drawn_lossless`, `pred_orbit_zero`, `pred_drawn_keeps` — finite basins hold one cycle; `Nat.succ` draws without merging; `Nat.pred` draws while keeping every possibility. They bear on "draw" in (c) only as witnesses that drawing and merging/losing come apart; listed, not copied.

### Pace.lean

- Pace.lean:101, definition `Pace.turn`
  ```lean
  def turn (f : S → R → S) (h : S → R → R) : Bool → S × R → S × R
    | true, p => (f p.1 p.2, h p.1 p.2)
    | false, p => (f p.1 p.2, p.2)
  ```
  One step of the two levels: the fast state steps by the rule; the rule changes by `h` where the step reads, and is kept elsewhere.

- Pace.lean:107, definition `Pace.step`
  ```lean
  def step (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (p : S × R × Nat) : S × R × Nat :=
    ((turn f h (reads p.2.2) (p.1, p.2.1)).1, (turn f h (reads p.2.2) (p.1, p.2.1)).2, p.2.2 + 1)
  ```
  The two-level law on fast state, rule and step count: one `turn`, reading where `reads` is true at the count. This is the determined law whose `Law.process` the lock would be an invariant of.

- Pace.lean:112, definition `Pace.paced`
  ```lean
  def paced (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (c : S × R) (t : Nat) : S × R :=
    (((Law.run (step f h reads) (c.1, c.2, 0)).state t).1,
      ((Law.run (step f h reads) (c.1, c.2, 0)).state t).2.1)
  ```
  The two-level course: the first two coordinates of the run of `step` from `(c, 0)`.

- Pace.lean:118, definition `Pace.heldCourse`
  ```lean
  def heldCourse (f : S → R → S) (g : R) (o : S → O) (x : S) (t : Nat) : O :=
    o ((Law.run (fun y => f y g) x).state t)
  ```
  The course a held rule generates, read through `o`.

- Pace.lean:124 `paced_count`, 131 `paced_run`, 138 `paced_zero`, 141 `paced_succ`:
  ```lean
  theorem paced_count (c : S × R) :
      ∀ t, ((Law.run (step f h reads) (c.1, c.2, 0)).state t).2.2 = t
  theorem paced_run (c : S × R) (t : Nat) :
      (Law.run (step f h reads) (c.1, c.2, 0)).state t =
        ((paced f h reads c t).1, (paced f h reads c t).2, t)
  theorem paced_zero (c : S × R) : paced f h reads c 0 = c
  theorem paced_succ (c : S × R) (t : Nat) :
      paced f h reads c (t + 1) = turn f h (reads t) (paced f h reads c t)
  ```
  The count coordinate is the step; the run of `step` is `(paced, t)`; the course starts at `c` and steps by one `turn`. `paced_run` is the bridge needed to move a statement about `Law.run (step …)` states to one about `paced`.

- Pace.lean:153, theorem `Pace.stays`
  ```lean
  theorem stays {I : S × R × Nat → Prop} (closed : ∀ p, I p → I (step f h reads p)) (c : S × R)
      {t : Nat} (holds : I ((Law.run (step f h reads) (c.1, c.2, 0)).state t)) (k : Nat) :
      I ((Law.run (step f h reads) (c.1, c.2, 0)).state (t + k))
  ```
  Premise: `I` is kept by every step of the two-level law (i.e. `Law.Absorbing (step f h reads) I`, though not stated with that name). Conclusion: the run, in `I` at `t`, is in `I` at every later step. The proof (156-158) builds `Invariant (Law.process (step f h reads)) I` inline as an anonymous term and applies `Invariant.reach` with `Run.reach`. The invariant is not exported.

- Pace.lean:162, theorem `Pace.stays_turned`
  ```lean
  theorem stays_turned {Q : S × R → Prop} (closed : ∀ b p, Q p → Q (turn f h b p)) (c : S × R)
      {t : Nat} (holds : Q (paced f h reads c t)) (k : Nat) : Q (paced f h reads c (t + k))
  ```
  Premise: every `turn`, reading or not, keeps `Q`. Conclusion: the course, in `Q` at `t`, is in `Q` at every later step. It is `stays` at `I := fun p => Q (p.1, p.2.1)`.

### RuleCapture.lean

- RuleCapture.lean:150, definition `ReadsShare`
  ```lean
  def ReadsShare (P : Ideals.Preorder S) (M : Ideals.Preorder R) (h : S → R → R) : Prop :=
    ∀ x y g g', P.le x y → M.le (h x g) (h y g')
  ```
  The rule read is monotone in the share alone, whatever rules the readings meet.

- RuleCapture.lean:154, theorem `ReadsShare.reverse`
  ```lean
  theorem ReadsShare.reverse {P : Ideals.Preorder S} {M : Ideals.Preorder R} {h : S → R → R}
      (monotone : ReadsShare P M h) : ReadsShare (reverse P) (reverse M) h
  ```
  Monotone reading stays so with both orders reversed.

- RuleCapture.lean:160, definition `Locked`
  ```lean
  def Locked (M : Ideals.Preorder R) (favours : R → Prop) (h : S → R → R) (p : S × R) : Prop :=
    favours p.2 ∧ M.le p.2 (h p.1 p.2)
  ```
  The rule in force favours, and is not above what reading the share gives. A region of `S × R`, not of `S × R × Nat`.

- RuleCapture.lean:169, theorem `turn_locked`
  ```lean
  theorem turn_locked (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
      ∀ (b : Bool) (p : S × R), Locked M favours h p →
        Locked M favours h (turn f h b p) ∧ P.le p.1 (turn f h b p).1 ∧ M.le p.2 (turn f h b p).2
  ```
  Premises: selection under a favouring rule does not lower the share (`Raises`), the reading is monotone in the share (`ReadsShare`), favouring is upward closed (`upper`). Conclusion: every turn, reading or not, keeps `Locked` and lowers neither share nor rule. This is the one-step closure of the lock: its first conjunct is exactly the premise `closed` of `stays_turned` at `Q := Locked M favours h`.

- RuleCapture.lean:182, theorem `locked_stays`
  ```lean
  theorem locked_stays (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
      (locked : Locked M favours h (paced f h reads c t)) :
      ∀ k, Locked M favours h (paced f h reads c (t + k))
  ```
  Under the same three premises, a course locked at `t` is locked at every later step, for every `reads`. Proved by `stays_turned` on `turn_locked`.

- RuleCapture.lean:190, theorem `locked_rises`
  ```lean
  theorem locked_rises (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
      (locked : Locked M favours h (paced f h reads c t)) (k : Nat) :
      P.le (paced f h reads c (t + k)).1 (paced f h reads c (t + k + 1)).1 ∧
        M.le (paced f h reads c (t + k)).2 (paced f h reads c (t + k + 1)).2
  ```
  From a locked step on, neither share nor rule falls across any step.

- RuleCapture.lean:205, theorem `locked_not_below`
  ```lean
  theorem locked_not_below (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
      (locked : Locked M favours h (paced f h reads c t)) :
      ∀ k, P.le (paced f h reads c t).1 (paced f h reads c (t + k)).1 ∧
        M.le (paced f h reads c t).2 (paced f h reads c (t + k)).2
  ```
  From a locked step, share and rule never again fall below where they were. Proved by `stays_turned` on the region "locked and at or above the values at `t`".

- RuleCapture.lean:227, theorem `perturbation_invariant`
  ```lean
  theorem perturbation_invariant (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x : S} {g g' : R}
      (before : Locked M favours h (x, g)) (keeps : favours g') :
      ∀ t, favours (paced f h reads (x, g') t).2 ∧ P.le x (paced f h reads (x, g') t).1 ∧
        M.le g (h (paced f h reads (x, g') t).1 (paced f h reads (x, g') t).2)
  ```
  From `(x, g)` locked and its rule replaced by any favouring `g'`, along the course every rule favours, the share never falls below `x`, and `g` is never above the reading. Despite its name it is proved by direct induction with a case split on `reads t`, not through `Invariant` or `stays_turned` (the region depends on `x`, `g`; it could be).

- RuleCapture.lean:258, theorem `perturbation_absorbed`
  ```lean
  theorem perturbation_absorbed (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x : S} {g g' : R}
      (before : Locked M favours h (x, g)) (keeps : favours g') {r : Nat} (at_r : reads r = true) :
      M.le g (paced f h reads (x, g') (r + 1)).2 ∧ Locked M favours h (paced f h reads (x, g') (r + 1))
  ```
  At the step after any reading step `r`, the rule is at least the pre-perturbation `g` and the course is locked again.

- RuleCapture.lean:278, theorem `turn_favours`
  ```lean
  theorem turn_favours (uniform : ∀ x g, favours (h x g)) :
      ∀ (b : Bool) (p : S × R), favours p.2 → favours (turn f h b p).2
  ```
  Where the reading favours at every share, every turn keeps a favouring rule.

- RuleCapture.lean:285, theorem `favours_after_reading`
  ```lean
  theorem favours_after_reading (uniform : ∀ x g, favours (h x g)) {c : S × R} {r : Nat}
      (at_r : reads r = true) : ∀ k, favours (paced f h reads c (r + 1 + k)).2
  ```
  Where the reading favours at every share, after any reading step every rule favours. By `stays_turned` on `turn_favours`.

### Outside the assigned files (read to answer the question)

- ReadingsSpread.lean:141, definition `ClosedFrom`
  ```lean
  def ClosedFrom (G : Generations α) (read : α → Sig) (sense : Nat → α → O) (upd : Sig → O → Sig)
      (P : Sig → Prop) (T : Nat) : Prop :=
    ∀ t, T ≤ t → ∀ p, p ∈ G.family t → P (read p) → P (upd (read p) (sense t p))
  ```
  A region of readings closed under each present member's revision at every step from `T` on. Its own definition over `Generations`; not `Frame.ClosedUnder`, not an `Invariant` of any `Process`, and not about `Pace` or `Locked`.
- ReadingsSpread.lean:150, theorem `fixed_of_closedFrom` — "A lock: a region fixed at `T` and closed under revision ... stays fixed", by `kept_iff`. Its module docstring (63-64) says explicitly it is "Not named `Locked`, which is RuleCapture's lock".
- BandRest.lean:34-35 (docstring of `keeps_one_way`): "The capture lock's not falling (`RuleCapture.locked_rises`) is the same law by its own route, `Pace.stays_turned`, and does not cite this one."
- ClosedCapture.lean:307 `lock_outlives_loss` and GrammarRegularity.lean:324 `lock_line`, :287 `lockedAlike`: use `Locked` on the joined step (via `paced`), conclusion through `Locked` at every `t`; neither states `Invariant` or `ClosedUnder` of the lock (grep of the live package).
- 02-MAP.md:439 (the paragraph "Rules that change themselves, read in the grammar"): says the lock's laws "are used or left as they are, not restated in the grammar"; it does not claim the lock is an `Invariant`/`ClosedUnder`.

## 2. Answer to the question

No. In the live package (grep over PKG, excluding the `becoming-checks/` snapshots) no declaration states `Invariant (Law.process (Pace.step f h reads)) (…Locked…)`, `Law.Absorbing (Pace.step …) (…Locked…)`, or `ClosedUnder (Steps …) (…Locked…)`. No file applies `Invariant.locks_out` or `Run.locked_in` to the capture lock; their only users are Branching.lean (410, 695) on other regions.

What is proved, and how close it is:
- `turn_locked` (RuleCapture:169) is the lock's one-step closure under every `turn` (both reading values). Its first conjunct is, up to rearranging arguments, exactly what is needed.
- `Pace.stays` (Pace:153) builds the invariant `Invariant (Law.process (step f h reads)) I` as an anonymous term inside its proof (lines 156-157) from `∀ p, I p → I (step f h reads p)`, and uses `Invariant.reach`. So the closure of the lock is proved as the grammar's closure law (through `invariant_iff_closedUnder` and `reach_iff_withinClosure`) — but only inside a proof, not as a named statement.
- Its docstring (Pace:148-152) says "the region is closed under the law (`Invariant`)": accurate about the proof, but no theorem with that conclusion exists.

To make `Run.locked_in` and `Invariant.locks_out` apply to the lock directly, the missing statement is a few lines: for `I := fun p : S × R × Nat => Locked M favours h (p.1, p.2.1)`, from `fun p held => (turn_locked raises monotone upper (reads p.2.2) (p.1, p.2.1) held).1` obtain `Law.Absorbing (Pace.step f h reads) I`, then `Law.absorbing_iff_invariant.mp` gives `Invariant (Law.process (Pace.step f h reads)) I` (equivalently `ClosedUnder (Steps …) I` by `invariant_iff_closedUnder`). Then `Invariant.locks_out` gives non-reachability of unlocked states of the two-level law from locked ones, and `Run.locked_in` applies to `Law.run (Pace.step f h reads) (c.1, c.2, 0)`; moving to `paced` needs `paced_run`. Whether such a lemma is wanted is the designer's call; it is not there now.

Note on what "applying directly" would buy: `locked_stays` already gives "stays locked" for every `reads`; `Invariant.locks_out` would add only the reachability form (no unlocked `(x, g, n)` reachable from a locked one under the law), and `Run.locked_in` the state-inequality form. Both are corollaries, not new content.

The phrases "lock = region closed under revision" (ReadingsSpread) and BandRest's "the same law by its own route" are about different or parallel objects: ReadingsSpread's `ClosedFrom` is its own time-indexed definition over `Generations` and states nothing about `Locked`; BandRest says outright that the capture lock does not cite its law.

## 3. Bearing on (a)-(d), for the designer

- (c) "stays the same in a respect up to its end": for the capture loop, the respect "locked" is kept by every turn (`turn_locked`), so the course stays in it whatever the reading schedule (`locked_stays`), and ClosedCapture's `lock_outlives_loss` / GrammarRegularity's `lock_line` add the unread coordinate running on. The closure step is the grammar's (`Invariant.reach`), reached through `Pace.stays`.
- (d) "turns only if what the respect does not tell makes a difference": the general process form already in the root's laws is `Run.leaving_needs` (Attraction:455): leaving a region needs a move not absorbing for it; with `invariant_iff_every_move`, an invariant region is never left. In the capture loop the three premises of `turn_locked` (`raises`, `monotone`, `upper`) are what make every move keep the lock; RuleCapture's docstring "Leaving" (45-50) names change of law, reading or selection as what leaves, but this is a docstring; the stated theorems there (`uniform_locks`, `Reversed.not_absorbed`) were outside my range.
- The attempt at /Users/ren/theories/tmp/r7/the-loop/lean/Becoming/TurningInTime.lean does not mention `Invariant`, `ClosedUnder`, `Locked`, `stays_turned` or `locks_out` (grep); it does not restate anything in my files on this question.

## 4. Not read or not settled

- RuleCapture.lean outside 150-290 (`Raises`, `uniform_locks`, `Second`, `Alternating`, `Reversed`, counts) — only docstrings at 1-60 seen.
- Attraction.lean outside 375-470 except the one-line `Law.Absorbing` at 110 and grep hits 519-553.
- Whether `Law.run`'s type is literally `Run (Law.process next)`: inferred from `Pace.stays`' proof, which applies `Invariant.reach (P := Law.process (step f h reads))` to `(Law.run …).reach t k`; the definition itself was not opened.
- Whether any `becoming-checks/` snapshot (not the live package) once held such a lemma: not checked beyond grep, which showed none.
- Nothing was compiled; no statement above was checked by Lean in this pass.
