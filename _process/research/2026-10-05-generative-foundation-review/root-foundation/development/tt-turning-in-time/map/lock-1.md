Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Map of Pace.lean, RuleCapture.lean, ClosedCapture.lean, RuleShaping.lean

Read only: nothing was built, run or edited except this file. PKG =
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Line numbers are those of the files at main `372705add`. Statements are copied from the source; the
sentence after each is mine. "Def" = definition, "Thm" = theorem; a named argument of a theorem is a
hypothesis of that theorem, never a proved fact.

Pattern letters (a)-(d) are those of the task: (a) relation and class; (b) going alike without
constancy, the core; (c) the same in a respect up to the end while a condition runs down; (d) turning
only if what the respect does not tell comes to make a difference, while what would bring it is
running out.

---------------------------------------------------------------------------------------------------

## 1. Pace.lean (628 lines)

Imports `Identification`, `IdentificationRuns`, `Capture`, `SeekingRuns`.

### Definitions

- **`Pace.turn`** (Def, 101)
  ```
  def turn (f : S → R → S) (h : S → R → R) : Bool → S × R → S × R
    | true, p => (f p.1 p.2, h p.1 p.2)
    | false, p => (f p.1 p.2, p.2)
  ```
  One step of two levels: the fast part steps by the rule in force; at a reading step the new rule is
  `h` of the OLD fast configuration and old rule, elsewhere the rule is kept.

- **`Pace.step`** (Def, 107)
  ```
  def step (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (p : S × R × Nat) : S × R × Nat :=
    ((turn f h (reads p.2.2) (p.1, p.2.1)).1, (turn f h (reads p.2.2) (p.1, p.2.1)).2, p.2.2 + 1)
  ```
  The two levels with the step count carried in the state, so the schedule makes one autonomous law
  `S × R × Nat → S × R × Nat` (a total function: every configuration has exactly one next).

- **`Pace.paced`** (Def, 112)
  ```
  def paced (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (c : S × R) (t : Nat) : S × R :=
    (((Law.run (step f h reads) (c.1, c.2, 0)).state t).1,
      ((Law.run (step f h reads) (c.1, c.2, 0)).state t).2.1)
  ```
  The two-level course from `c`: the fast part and rule at step `t` of the run of `step` from count 0.
  Defined for every `t : Nat`; the course has no end.

- **`Pace.heldCourse`** (Def, 118)
  ```
  def heldCourse (f : S → R → S) (g : R) (o : S → O) (x : S) (t : Nat) : O :=
    o ((Law.run (fun y => f y g) x).state t)
  ```
  The course a fixed rule `g` generates from `x`, read through `o`.

- **`Pace.lassoStep`** (Def, 393) `def lassoStep (p : Nat) (g : Nat × Nat) : Nat := Learning.lassoNext g.1 g.2 p`
  The lasso fast level: rule `(i, q)` walks positions `0..i+q`, the last back to `i`.

- **`Pace.StretchFixes`** (Def, 528)
  ```
  def StretchFixes (O : Type w) (N L : Nat) : Prop :=
    ∀ (S S' R R' : Type) (f : S → R → S) (f' : S' → R' → S') (g : R) (g' : R') (o : S → O)
      (o' : S' → O) (x : S) (x' : S'),
      StatesBelow (heldCourse f g o x) N → StatesBelow (heldCourse f' g' o' x') N →
        (∀ n, n < L → heldCourse f g o x n = heldCourse f' g' o' x' n) →
          ∀ n, heldCourse f g o x n = heldCourse f' g' o' x' n
  ```
  A stretch of `L` steps fixes every pair of held courses (fast levels in `Type`) with at most `N`
  states each.

- `Pace.Copying.fast`, `Pace.Copying.slow` (Defs, 293, 296: `def fast (x _ : Bool) : Bool := x`,
  `def slow (x _ : Bool) : Bool := x`); `Switching.fast` (318, `def fast (_ g : Bool) : Bool := g`),
  `Switching.slow` (321, `def slow (x _ : Bool) : Bool := !x`). Witness laws.

### Theorems

- **`Law.Reachable.back`** (Thm, 88)
  `theorem Law.Reachable.back {S : Type u} {next : S → S} {n : Nat} {s : S} : ∀ k, Law.Reachable next (n + k) s → Law.Reachable next n s`
  Reachable after `n + k` steps implies reachable after `n` steps (positive form of `lost_stays`).

- `paced_count` (124) `theorem paced_count (c : S × R) : ∀ t, ((Law.run (step f h reads) (c.1, c.2, 0)).state t).2.2 = t`
  The clock coordinate equals the step.
- **`paced_run`** (131)
  ```
  theorem paced_run (c : S × R) (t : Nat) :
      (Law.run (step f h reads) (c.1, c.2, 0)).state t =
        ((paced f h reads c t).1, (paced f h reads c t).2, t)
  ```
  The run of `step` is the course with its clock. (Bridge from `paced` to `Law.run`/`Law.orbit`.)
- `paced_zero` (138) `theorem paced_zero (c : S × R) : paced f h reads c 0 = c`
- **`paced_succ`** (141) `theorem paced_succ (c : S × R) (t : Nat) : paced f h reads c (t + 1) = turn f h (reads t) (paced f h reads c t)`
  The course steps by one turn, reading where `reads t`.

- **`stays`** (153)
  ```
  theorem stays {I : S × R × Nat → Prop} (closed : ∀ p, I p → I (step f h reads p)) (c : S × R)
      {t : Nat} (holds : I ((Law.run (step f h reads) (c.1, c.2, 0)).state t)) (k : Nat) :
      I ((Law.run (step f h reads) (c.1, c.2, 0)).state (t + k))
  ```
  Hypothesis: `I` closed under `step`. Then `I` holding at `t` holds at every `t + k` (via
  `Invariant.reach`).
- **`stays_turned`** (162)
  ```
  theorem stays_turned {Q : S × R → Prop} (closed : ∀ b p, Q p → Q (turn f h b p)) (c : S × R)
      {t : Nat} (holds : Q (paced f h reads c t)) (k : Nat) : Q (paced f h reads c (t + k))
  ```
  Hypothesis: `Q` kept by every turn, reading or not. Then `Q` at `t` gives `Q` at every later step.
  This is the closure law every lock in RuleCapture/ClosedCapture uses.

- `rule_kept` (170) `theorem rule_kept (never : ∀ t, reads t = false) (c : S × R) : ∀ t, (paced f h reads c t).2 = c.2`
- `never_reads_course` (179) `theorem never_reads_course (never : ∀ t, reads t = false) (c : S × R) : ∀ t, paced f h reads c t = (Law.orbit (fun y => f y c.2) c.1 t, c.2)`
- **`rule_unreached`** (188) `theorem rule_unreached (never : ∀ t, reads t = false) (x x' : S) (g : R) (t : Nat) : (paced f h reads (x, g) t).2 = (paced f h reads (x', g) t).2`
  Never reading: two courses from one rule have one rule at every step, whatever the fast parts.
- `never_reads_lost` (195)
  ```
  theorem never_reads_lost (never : ∀ t, reads t = false) {g : R} {n : Nat} {s : S}
      (lost : ¬ Law.Reachable (fun y => f y g) n s) (k : Nat) (x : S) :
      (paced f h reads (x, g) (n + k)).1 ≠ s
  ```
  Never reading, a fast configuration unreachable in `n` steps is never the fast part from `n` on.
- `never_reads_merged` (203) `theorem never_reads_merged (never : ∀ t, reads t = false) {g : R} {x x' : S} (merged : f x g = f x' g) (t : Nat) : paced f h reads (x, g) (t + 1) = paced f h reads (x', g) (t + 1)`
- `never_reads_loses` (213)
  ```
  theorem never_reads_loses (never : ∀ t, reads t = false) {g : R}
      (merges : Law.Merges (fun y => f y g)) {all : List S} (every : ∀ s, s ∈ all) (k : Nat) :
      ¬ ∀ s, ∃ x, (paced f h reads (x, g) (all.length + k)).1 = s
  ```
  Never reading, fast level finite (listed by `all`) and merging: from step `all.length` on some fast
  configuration is no course's fast part.
- `turn_byRule` (222) `theorem turn_byRule (fast : ∀ x x' g, f x g = f x' g) (slow : ∀ x x' g, h x g = h x' g) : ∀ (b : Bool) (x x' : S) (g : R), turn f h b (x, g) = turn f h b (x', g)`
- **`byRule_reabsorbed`** (235)
  ```
  theorem byRule_reabsorbed (fast : ∀ x x' g, f x g = f x' g) (slow : ∀ x x' g, h x g = h x' g)
      (x x' : S) (g : R) (n : Nat) :
      (Law.run (step f h reads) (x, g, 0)).state (n + 1) =
        (Law.run (step f h reads) (x', g, 0)).state (n + 1)
  ```
  Where neither level reads the fast part, two runs from one rule coincide from step 1. Instance of
  `Law.perturbation_reabsorbed`. Docstring error: says that law is "of `Becoming.Capture`"; it is in
  `SeekingRuns.lean:49` (Capture.lean:50 says so itself).
- `rule_until_reading` (247) `theorem rule_until_reading {r : Nat} (before : ∀ u, u < r → reads u = false) (c : S × R) : ∀ t, t ≤ r → (paced f h reads c t).2 = c.2`
- **`rule_alike_until_reading`** (260) `theorem rule_alike_until_reading {r : Nat} (before : ∀ u, u < r → reads u = false) (x x' : S) (g : R) {t : Nat} (le : t ≤ r) : (paced f h reads (x, g) t).2 = (paced f h reads (x', g) t).2`
  Up to and including the first reading step, no fast difference reaches the rule.
- **`rule_at_reading`** (266) `theorem rule_at_reading {r : Nat} (at_r : reads r = true) (c : S × R) : (paced f h reads c (r + 1)).2 = h (paced f h reads c r).1 (paced f h reads c r).2`
- **`rule_through_pool`** (276)
  ```
  theorem rule_through_pool {read : S → O} {H : O → R → R} (through : ∀ x g, h x g = H (read x) g)
      {r : Nat} (at_r : reads r = true) {c c' : S × R}
      (rule : (paced f h reads c r).2 = (paced f h reads c' r).2)
      (heard : read (paced f h reads c r).1 = read (paced f h reads c' r).1) :
      (paced f h reads c (r + 1)).2 = (paced f h reads c' (r + 1)).2
  ```
  Hypothesis: `h` reads the fast part only through `read`. Then at a reading step, alike rules and
  alike `read` give alike next rules. (A one-step "going alike" of the class `read`×rule under the
  slow coordinate, stated pointwise, not as `GoAlike`.)
- `Pace.Copying.rule_parts` (301): rules alike at 0 and apart at 1 (statement: `(Pace.paced fast slow (fun _ => true) (true, false) 0).2 = (Pace.paced fast slow (fun _ => true) (false, false) 0).2 ∧ (Pace.paced fast slow (fun _ => true) (true, false) 1).2 ≠ (Pace.paced fast slow (fun _ => true) (false, false) 1).2`).
- `Switching.fixed_loses` (326) `theorem fixed_loses (k : Nat) (x : Bool) : (Law.run (fun x => fast x true) x).state (1 + k) ≠ false ∧ (Law.run (fun x => fast x false) x).state (1 + k) ≠ true`
- `Switching.back_at_four` (337), `Switching.changing_regains` (348) `theorem changing_regains (k : Nat) : (Pace.paced fast slow (fun _ => true) (true, true) (4 * k)).1 = true ∧ (Pace.paced fast slow (fun _ => true) (true, true) (4 * k + 2)).1 = false`
- `paced_stretch` (367)
  ```
  theorem paced_stretch {c : S × R} {a k : Nat} (held : ∀ j, j < k → reads (a + j) = false) :
      ∀ j, j ≤ k → paced f h reads c (a + j) =
        (Law.orbit (fun y => f y (paced f h reads c a).2) (paced f h reads c a).1 j,
          (paced f h reads c a).2)
  ```
- `paced_held` (379), `held_statesBelow` (386), `lasso_statesBelow` (398), `held_realizes` (407),
  `dissolving` (420), `held_fixed` (493), `stretch_fixed` (505), **`pace_law`** (539)
  `theorem pace_law {x y : O} (two : x ≠ y) (N L : Nat) : StretchFixes O N L ↔ N + N - 1 ≤ L`,
  `whole_fixed` (570), `whole_fixed_exact` (607). These are the identification-by-prefix laws read on
  held rules; they bear on how long a stretch must be to fix a course, not on (a)-(d) directly.

---------------------------------------------------------------------------------------------------

## 2. RuleCapture.lean (897 lines)

### Additions to `Pace`

- **`Pace.paced_shift`** (114) `theorem paced_shift (c : S × R) (a : Nat) : ∀ k, paced f h reads c (a + k) = paced f h (fun u => reads (a + u)) (paced f h reads c a) k`
  A course read from step `a` is the course from its configuration there with the schedule shifted.
- **`Pace.paced_fast_succ`** (122) `theorem paced_fast_succ (c : S × R) (t : Nat) : (paced f h reads c (t + 1)).1 = f (paced f h reads c t).1 (paced f h reads c t).2`

### Definitions

- `RuleCapture.reverse` (Def, 138) `def reverse {α : Type u} (P : Ideals.Preorder α) : Ideals.Preorder α` with `le a b := P.le b a`.
- **`Raises`** (Def, 145)
  ```
  def Raises (P : Ideals.Preorder S) (favours : R → Prop) (f : S → R → S) : Prop :=
    ∀ x g, favours g → P.le x (f x g)
  ```
  Under every rule that `favours`, one fast step does not lower `x` in the preorder `P`.
- **`ReadsShare`** (Def, 150)
  ```
  def ReadsShare (P : Ideals.Preorder S) (M : Ideals.Preorder R) (h : S → R → R) : Prop :=
    ∀ x y g g', P.le x y → M.le (h x g) (h y g')
  ```
  The rule read is monotone in the fast part and, taking `x = y`, independent of the rule argument up
  to `M`-equivalence (`M.le (h x g) (h x g')` for all `g g'`). The docstring says "a monotone function
  of the share alone"; the "alone" is up to M-equivalence only.
- **`Locked`** (Def, 160)
  ```
  def Locked (M : Ideals.Preorder R) (favours : R → Prop) (h : S → R → R) (p : S × R) : Prop :=
    favours p.2 ∧ M.le p.2 (h p.1 p.2)
  ```
  A region of `S × R`: the rule in force favours and is not above the rule the reading gives there.
- `pairOrder` (Def, 346), `pairReading` (Def, 352) `def pairReading (h₁ : S → R₁ → R₁) (h₂ : S → R₂ → R₂) : S → R₁ × R₂ → R₁ × R₂ := fun x g => (h₁ x g.1, h₂ x g.2)`.
- **`CarrierCounts`** (structure, 469) `structure CarrierCounts where carrier : Nat; other : Nat; other_pos : 0 < other`
- `CarrierCounts.order` (Def, 478) `le x y := x.carrier * y.other ≤ y.carrier * x.other` (a preorder; reflexive and transitive, proofs in the def).
- `CarrierCounts.favours` (Def, 491) `def favours (g : CarrierCounts) : Prop := g.other ≤ g.carrier`
- `CarrierCounts.disfavours` (Def, 494) `def disfavours (g : CarrierCounts) : Prop := g.carrier ≤ g.other`
- `CarrierCounts.select` (Def, 497) `def select (x g : CarrierCounts) : CarrierCounts := ⟨x.carrier * g.carrier, x.other * g.other, Nat.mul_pos x.other_pos g.other_pos⟩`
- `CarrierCounts.proportional` (579) `def proportional (x _ : CarrierCounts) : CarrierCounts := x`
- `CarrierCounts.threshold` (585) `def threshold (hi lo : CarrierCounts) (x _ : CarrierCounts) : CarrierCounts := if x.other ≤ x.carrier then hi else lo`
- `CarrierCounts.margin` (611) `def margin (a m : Nat) (pos : 0 < a) : CarrierCounts := ⟨a + m, a, pos⟩`; `byMargin` (621) `def byMargin (a : Nat) (pos : 0 < a) (φ : CarrierCounts → Nat) (x _ : CarrierCounts) : CarrierCounts := margin a (φ x) pos`
- Witness constants `hi` (681, ⟨4,1⟩), `lo` (684, ⟨1,4⟩), `twoToOne` (688, ⟨2,1⟩), `Alternating.course` (724), `Reversed.late` (842, `Witnesses.profile [false] true`), `Reversed.course` (845), `Second.oneToOne` (878), `Second.course` (882).

### Theorems (lock)

- `ReadsShare.reverse` (154) `theorem ReadsShare.reverse {P : Ideals.Preorder S} {M : Ideals.Preorder R} {h : S → R → R} (monotone : ReadsShare P M h) : ReadsShare (reverse P) (reverse M) h`
- **`turn_locked`** (169)
  ```
  theorem turn_locked (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
      ∀ (b : Bool) (p : S × R), Locked M favours h p →
        Locked M favours h (turn f h b p) ∧ P.le p.1 (turn f h b p).1 ∧ M.le p.2 (turn f h b p).2
  ```
  Hypotheses `raises`, `monotone`, `upper` (favouring kept upward). Then one turn, reading or not,
  keeps `Locked` and lowers neither share nor rule.
- **`locked_stays`** (182)
  ```
  theorem locked_stays (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
      (locked : Locked M favours h (paced f h reads c t)) :
      ∀ k, Locked M favours h (paced f h reads c (t + k))
  ```
  Same hypotheses; locked at `t`, locked at every later step (`stays_turned` on `turn_locked`).
- `locked_rises` (190): same hypotheses; across every later step neither share nor rule falls:
  `P.le (paced f h reads c (t + k)).1 (paced f h reads c (t + k + 1)).1 ∧ M.le (paced f h reads c (t + k)).2 (paced f h reads c (t + k + 1)).2`.
- **`locked_not_below`** (205): same hypotheses; `∀ k, P.le (paced f h reads c t).1 (paced f h reads c (t + k)).1 ∧ M.le (paced f h reads c t).2 (paced f h reads c (t + k)).2`.
- `perturbation_invariant` (227), **`perturbation_absorbed`** (258)
  ```
  theorem perturbation_absorbed (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x : S} {g g' : R}
      (before : Locked M favours h (x, g)) (keeps : favours g') {r : Nat} (at_r : reads r = true) :
      M.le g (paced f h reads (x, g') (r + 1)).2 ∧ Locked M favours h (paced f h reads (x, g') (r + 1))
  ```
  From locked `(x, g)`, the rule replaced by any favouring `g'`: after every reading step the rule is
  at least `g` and the course is locked.
- `turn_favours` (278), `favours_after_reading` (285),
  **`uniform_locks`** (294)
  ```
  theorem uniform_locks (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (uniform : ∀ x g, favours (h x g)) {c : S × R} {r r' : Nat} (first : reads r = true)
      (second : reads r' = true) (lt : r < r') : Locked M favours h (paced f h reads c (r' + 1))
  ```
  Hypotheses `raises`, `monotone`, `uniform` (the reading favours at every share). Then every course,
  any start, is locked after its second reading step. (No `upper` needed.)
- `favours_throughout` (311), **`favouring_locks`** (320)
  ```
  theorem favouring_locks (raises : Raises P favours f) (monotone : ReadsShare P M h)
      (uniform : ∀ x g, favours (h x g)) {c : S × R} (start : favours c.2) :
      (∀ t, P.le (paced f h reads c t).1 (paced f h reads c (t + 1)).1) ∧
        ∀ r, reads r = true → Locked M favours h (paced f h reads c (r + 1))
  ```
- `ReadsShare.pair` (356), `pair_locks` (366).
- `share_kept_along` (388), **`against_not_rising`** (402)
  ```
  theorem against_not_rising (raises : Raises P favours f) (against : ReadsShare P (reverse M) h)
      {c : S × R} (favouring : ∀ t, favours (paced f h reads c t).2) {r r' : Nat}
      (first : reads r = true) (second : reads r' = true) (le : r ≤ r') :
      M.le (paced f h reads c (r' + 1)).2 (paced f h reads c (r + 1)).2
  ```
- **`order_kept`** (426)
  ```
  theorem order_kept (selects : ∀ x y g g', P.le x y → M.le g g' → P.le (f x g) (f y g'))
      (monotone : ReadsShare P M h) {c c' : S × R} (le : P.le c.1 c'.1) (le' : M.le c.2 c'.2) :
      ∀ t, P.le (paced f h reads c t).1 (paced f h reads c' t).1 ∧
        M.le (paced f h reads c t).2 (paced f h reads c' t).2
  ```
  A monotone two-level law keeps the order of two courses at every step. (As a relation: the product
  preorder `P × M` is kept by the step, i.e. constant under it; not stated in grammar terms.)
- `perturbation_keeps_below` (448).

### Theorems (counts)

`CarrierCounts.raises` (501) `theorem raises : Raises order favours select`;
`rises_strictly` (508); `lowers` (516) `theorem lowers : Raises (reverse order) disfavours select`;
`upper` (523) `theorem upper {g g' : CarrierCounts} (le : order.le g g') (fav : favours g) : favours g'`;
`lower` (531); `select_mono` (539); `share_not_lower_counts` (549); `rises_strictly_along` (557);
`perturbation_keeps_below_counts` (568); `proportional_reads` (581) `theorem proportional_reads : ReadsShare order order proportional`;
`threshold_above` (587), `threshold_below` (590), `threshold_reads` (594), `threshold_favours` (605);
`margin_favours` (613), `margin_le` (616), `byMargin_reads` (624), `margin_course` (632),
`proportional_locks` (646), `proportional_locks_down` (661); `lo_le_hi` (690), `hi_not_le_lo` (692),
`hi_not_le_twoToOne` (694), `twoToOne_le_hi` (696), `always_step` (700). These derive the abstract
hypotheses `Raises`, `upper`, `ReadsShare` on counts.

Witnesses: `Alternating.before_locked` (733), `from_even` (742), `even` (762), `odd` (780),
**`Alternating.alternates`** (789) `theorem alternates (k : Nat) : ¬ order.le (course (2 * k)).1 (course (2 * k + 1)).1 ∧ ¬ order.le (course (2 * k + 1)).2 (course (2 * k + 2)).2`,
`Alternating.never_locked` (807); `Reversed.locked_down` (849), **`Reversed.not_absorbed`** (855)
```
theorem not_absorbed :
    Locked order favours (threshold hi lo) (twoToOne, hi) ∧
      (∀ k, order.le (course (1 + k + 1)).1 (course (1 + k)).1 ∧
        order.le (course (1 + k + 1)).2 (course (1 + k)).2) ∧
      ¬ order.le hi (course 2).2
```
`Second.second_exact` (886).

---------------------------------------------------------------------------------------------------

## 3. ClosedCapture.lean (995 lines)

### Definitions

- **`Unread`** (Def, 131)
  ```
  def Unread (f : A × B → R → A × B) (h : A × B → R → R) : Prop :=
    (∀ a b b' g, (f (a, b) g).1 = (f (a, b') g).1) ∧ ∀ a b b' g, h (a, b) g = h (a, b') g
  ```
  Fast part a pair (share `a`, beyond `b`): neither the next share nor the rule read depends on `b`.
  Note: about `h` everywhere, not only at reading steps.
- **`loopPart`** (Def, 143) `def loopPart (p : (A × B) × R × Nat) : A × R × Nat := (p.1.1, p.2.1, p.2.2)`
  The projection of a two-level configuration onto share, rule and clock.
- **`join`** (Def, 220) `def join (fA : A → R → A) (fB : A × B → R → B) (p : A × B) (g : R) : A × B := (fA p.1 g, fB p g)`
  The share steps by its own law; the beyond-part steps by `fB`, which may read everything.
- **`joinRead`** (Def, 223) `def joinRead (hA : A → R → R) (p : A × B) (g : R) : R := hA p.1 g`
- **`Accrues`** (Def, 273) `def Accrues (fB : A × Nat → R → Nat) : Prop := ∀ p g, p.2 + 1 ≤ fB p g`
  Every step adds at least one to the beyond-part (a Nat), at every configuration and rule; no bound.
- `both` (Def, 405), **`readers`** (Def, 412) `def readers (read : Q → S → G → G) (mind : S → Q → Q) (x : S) (p : G × Q) : G × Q := (read (mind x p.2) x p.1, mind x p.2)`, `byRule` (Def, 416) `def byRule (f : S → G → S) (x : S) (p : G × Q) : S := f x p.1`.
- `Beyond.lossStep` (344) `def lossStep (p : CarrierCounts × Nat) (_ : CarrierCounts) : Nat := p.2 + 1`; `Beyond.closedRead` (347) `def closedRead (_ _ : CarrierCounts) : CarrierCounts := hi`; `Beyond.lossRead` (350) (`hi` while `Nat.blt p.2 1`, else `lo`); `Beyond.closed` (356), `Beyond.opened` (360).
- `Proportional.mind` (491) `def mind (x _ : CarrierCounts) : CarrierCounts := x`, `Proportional.read` (494) `def read (q _ _ : CarrierCounts) : CarrierCounts := q`.
- **`Drawn.pool`** (558)
  ```
  def pool (u v x : CarrierCounts) : CarrierCounts :=
    ⟨x.carrier * u.carrier + x.other * v.carrier, x.carrier * u.other + x.other * v.other,
      Nat.lt_of_lt_of_le (Nat.mul_pos x.other_pos v.other_pos) (Nat.le_add_left _ _)⟩
  ```
  The rule read as the count-weighted sum of the carriers' reading `u` and the others' reading `v`.
- `Drawn.poolRead` (601) `def poolRead (u v x _ : CarrierCounts) : CarrierCounts := pool u v x`
- **`Thinned.lossPool`** (785)
  ```
  def lossPool (u v w : CarrierCounts) (N : Nat) (p : CarrierCounts × Nat) (_ : CarrierCounts) :
      CarrierCounts :=
    match Nat.blt p.2 N with
    | true => pool u v p.1
    | false => pool u w p.1
  ```
  The others read the loss: their reading is `v` while the loss is below `N`, `w` from then on.
- **`Thinned.course`** (803) `def course (fB : CarrierCounts × Nat → CarrierCounts → Nat) (u v w : CarrierCounts) (N : Nat) (reads : Nat → Bool) (c : (CarrierCounts × Nat) × CarrierCounts) (t : Nat) : (CarrierCounts × Nat) × CarrierCounts := paced (join select fB) (lossPool u v w N) reads c t`
- Witness data `Thinned.fewCarriers` (938, ⟨1,8⟩), `Thinned.inTime` (941, N = 0), `Thinned.late` (945, N = 3).

### Theorems: what lies beyond

- `turn_unread` (135).
- **`goAlike_of_unread`** (147) `theorem goAlike_of_unread {f : A × B → R → A × B} {h : A × B → R → R} (unread : Unread f h) (reads : Nat → Bool) : GoAlike (Law.process (Pace.step f h reads)) (loopPart (A := A) (B := B) (R := R))`
  `Unread` gives: the two-level step goes alike under `loopPart`, for every schedule.
- **`identifiesAlike_iff_unread`** (166)
  ```
  theorem identifiesAlike_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} :
      (∀ reads : Nat → Bool,
        IdentifiesAlike (Law.frameBy (Pace.step f h reads) (loopPart (A := A) (B := B) (R := R))) loopPart) ↔
        Unread f h
  ```
  `loopPart` makes sense by itself along every schedule exactly where `Unread`. The `→` direction uses
  only the schedule `fun _ => true`.
- **`unread_course`** (186)
  ```
  theorem unread_course {f : A × B → R → A × B} {h : A × B → R → R} (unread : Unread f h)
      (reads : Nat → Bool) {c c' : (A × B) × R} (same : c.1.1 = c'.1.1) (same' : c.2 = c'.2) (t : Nat) :
      (paced f h reads c t).1.1 = (paced f h reads c' t).1.1 ∧
        (paced f h reads c t).2 = (paced f h reads c' t).2
  ```
  Proved through `Law.sameFuture_of_goAlike`, i.e. the root's `«同行之迭»`.
- `courses_alike_iff_unread` (202) (the same, quantified over schedules and starts, ↔ `Unread f h`).
- **`reads_beyond_of_apart`** (212)
  ```
  theorem reads_beyond_of_apart {f : A × B → R → A × B} {h : A × B → R → R} {reads : Nat → Bool}
      {c c' : (A × B) × R} (same : c.1.1 = c'.1.1) (same' : c.2 = c'.2) {t : Nat}
      (apart : ¬ ((paced f h reads c t).1.1 = (paced f h reads c' t).1.1 ∧
        (paced f h reads c t).2 = (paced f h reads c' t).2)) : ¬ Unread f h
  ```
  Contrapositive of `unread_course`: courses from starts alike in share and rule that come apart
  read beyond the share. This is the "only if" of (d) in the schedule-free sense.
- `join_unread` (225) `theorem join_unread (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) : Unread (join fA fB) (joinRead hA)` (by `rfl`).
- `join_alike` (231), `turn_join` (240), **`join_course`** (248)
  ```
  theorem join_course (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) (reads : Nat → Bool)
      (c : (A × B) × R) :
      ∀ t, (paced (join fA fB) (joinRead hA) reads c t).1.1 = (paced fA hA reads (c.1.1, c.2) t).1 ∧
        (paced (join fA fB) (joinRead hA) reads c t).2 = (paced fA hA reads (c.1.1, c.2) t).2
  ```
  The joined loop runs share and rule exactly as the share's own law. Proved by its own induction,
  not through `goAlike_of_unread`.

### Theorems: outliving the loss

- **`loss_grows`** (277) `theorem loss_grows {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R} {reads : Nat → Bool} (accrues : Accrues fB) (c : (A × Nat) × R) : ∀ t, c.1.2 + t ≤ (paced (join fA fB) h reads c t).1.2`
  Note: `h` here is arbitrary (may read the loss).
- **`turned_by_loss`** (291)
  ```
  theorem turned_by_loss {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R}
      {reads : Nat → Bool} {favours : R → Prop} (accrues : Accrues fB)
      {N : Nat} (turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)) {a : A} {b : Nat} {g : R} {r : Nat}
      (at_r : reads r = true) (past : N ≤ b + r) :
      ¬ favours (paced (join fA fB) h reads ((a, b), g) (r + 1)).2
  ```
  Hypotheses: loss accrues; the reading favours at no configuration with loss ≥ `N`; a reading step
  `r` with `N ≤ b + r`. Then after it the rule does not favour. The docstring adds "so the course is
  not locked there"; that follows from `Locked`'s first conjunct but is not stated.
- **`lock_outlives_loss`** (307)
  ```
  theorem lock_outlives_loss {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
      {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool}
      (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
      (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB)
      {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) (t : Nat) :
      b + t ≤ (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.2 ∧
        Locked M favours hA ((paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1,
          (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2) ∧
        P.le a (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1 ∧
        M.le g (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2
  ```
  Joined loop locked at start, loss accruing: at every `t` the loss is ≥ `b + t`, locked, share and
  rule not below start. Header's "a measure the loss refutes is kept, because nothing in the loop
  reads the refutation" is a reading; nothing in the statement is a refutation.
- Witnesses: `Beyond.closed_locked` (365), **`Beyond.open_falls`** (375) `theorem open_falls : (opened 1).2 = hi ∧ (opened 2).2 = lo ∧ ¬ order.le (opened 2).1.1 (opened 3).1.1`, `Beyond.lossRead_turns` (379), `Beyond.open_turned` (385) `theorem open_turned {r : Nat} (pos : 1 ≤ r) : ¬ favours (opened (r + 1)).2`, `Beyond.open_reads` (391) `theorem open_reads : ¬ Unread (join select lossStep) lossRead`.

### Theorems: readers

- `both_reads` (425), `byRule_raises` (429), `both_upper` (433), `readers_not_below` (438),
  `reading_absorbed` (455), `readers_uniform_locks` (470); `Proportional.readMono` (496),
  `Proportional.formed` (500), `Proportional.start_locked` (503), `Proportional.reform_absorbed`
  (510). These lift `RuleCapture` to a (rule, reading) pair; the reading `Q` is a second slow
  coordinate formed from the share.
- `Drawn.rearrange_eq` (532), `rearrange` (539), `rearrange_lt` (547), `cross` (564), `pool_mono`
  (578), `pool_mono_against` (589), `pool_against` (605), **`Drawn.pool_reads_iff`** (612)
  `theorem pool_reads_iff {u v : CarrierCounts} : ReadsShare order order (poolRead u v) ↔ order.le v u`,
  `pool_reads` (627), `pool_through` (633), `pool_favours` (639), `through_locks` (646),
  `pool_not_rising` (657), `le_of_disfavours` (664), **`mirror_favours_iff`** (674)
  `theorem mirror_favours_iff {u w x : CarrierCounts} (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier) : favours (pool u w x) ↔ x.other ≤ x.carrier`,
  `mirror_disfavours_iff` (694), `mirror_le` (714).

### Theorems: the loss read by part of the pool

- `turn_agree` (726).
- **`course_past`** (735)
  ```
  theorem course_past {fA : A → R → A} {fB : A × Nat → R → Nat} {h h' : A × Nat → R → R}
      {reads : Nat → Bool} (accrues : Accrues fB) {N : Nat} (agree : ∀ p g, N ≤ p.2 → h p g = h' p g)
      {c : (A × Nat) × R} (past : N ≤ c.1.2) :
      ∀ t, paced (join fA fB) h reads c t = paced (join fA fB) h' reads c t
  ```
  Two readings agreeing wherever the loss is ≥ `N`, loss accruing, start past `N`: one course.
  (Uses accrual only to keep the region `N ≤ loss`; monotone non-decrease would do.)
- **`agreeing_locks`** (755) `theorem agreeing_locks (raises : Raises P favours f) (monotone : ReadsShare P M h) {c : S × R} {r : Nat} (at_r : reads r = true) (fav : favours (paced f h reads c r).2) (fav' : favours (h (paced f h reads c r).1 (paced f h reads c r).2)) : Locked M favours h (paced f h reads c (r + 1))`
- `agreeing_stays` (765).
- `Thinned.lossPool_past` (793) `theorem lossPool_past {u v w : CarrierCounts} {N : Nat} : ∀ (p : CarrierCounts × Nat) (g : CarrierCounts), N ≤ p.2 → lossPool u v w N p g = joinRead (poolRead u w) p g`
- **`Thinned.past_course`** (811)
  ```
  theorem past_course (accrues : Accrues fB) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
      (past : N ≤ (course fB u v w N reads c r).1.2) (k : Nat) :
      ((course fB u v w N reads c (r + k)).1.1, (course fB u v w N reads c (r + k)).2) =
        paced select (poolRead u w) (fun j => reads (r + j))
          ((course fB u v w N reads c r).1.1, (course fB u v w N reads c r).2) k
  ```
  Once the loss has reached `N`, the course is the share's own closed loop under the late pool.
- **`Thinned.read_late_kept`** (830)
  ```
  theorem read_late_kept (accrues : Accrues fB) (readers : order.le w u)
      {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
      (fav : favours (course fB u v w N reads c r).2)
      (pfav : favours (pool u w (course fB u v w N reads c r).1.1)) (k : Nat) :
      c.1.2 + (r + (1 + k)) ≤ (course fB u v w N reads c (r + (1 + k))).1.2 ∧
        Locked order favours (poolRead u w)
          ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2) ∧
        order.le (course fB u v w N reads c (r + 1)).1.1 (course fB u v w N reads c (r + (1 + k))).1.1 ∧
        order.le (course fB u v w N reads c (r + 1)).2 (course fB u v w N reads c (r + (1 + k))).2
  ```
- **`Thinned.read_in_time_turns`** (861): same shape with `dis : disfavours …`, `pdis : disfavours (pool u w …)`, conclusion `Locked (reverse order) disfavours (poolRead u w) (…) ∧ order.le (…(r + (1 + k))).1.1 (…(r + 1)).1.1 ∧ order.le (…(r + (1 + k))).2 (…(r + 1)).2`.
- `Thinned.rule_read` (886) `theorem rule_read (accrues : Accrues fB) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2) : (course fB u v w N reads c (r + 1)).2 = pool u w (course fB u v w N reads c r).1.1`
- **`Thinned.kept_iff`** (900)
  ```
  theorem kept_iff (accrues : Accrues fB) (hc : w.carrier = u.other) (ho : w.other = u.carrier)
      (strict : u.other < u.carrier) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
      (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
      (fav : favours (course fB u v w N reads c r).2) :
      (∀ k, Locked order favours (poolRead u w)
          ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2)) ↔
        (course fB u v w N reads c r).1.1.other ≤ (course fB u v w N reads c r).1.1.carrier
  ```
  Others' late reading the mirror of the carriers' strict reading; at a reading step past the bound
  with the rule favouring: locked for good exactly where carriers ≥ others at that step. Docstring's
  "where they are fewer, it is not locked at the next step" is stronger than the statement (which
  gives only `¬ ∀ k, Locked …`); the proof does use `k = 0`, so the stronger form is one line away
  but is not stated.
- `Thinned.turned_iff` (918): the mirror (`dis`, `Locked (reverse order) disfavours`, ↔ `carrier ≤ other`).
- Witnesses `Thinned.lossStep_accrues` (948) `theorem lossStep_accrues : Accrues Beyond.lossStep`,
  `inTime_majority` (952), **`inTime_turned`** (960), `late_majority` (970), **`late_kept`** (977),
  `late_reads_loss` (987) `theorem late_reads_loss : ¬ Unread (join select Beyond.lossStep) (lossPool hi Second.oneToOne lo 3)`.

---------------------------------------------------------------------------------------------------

## 4. RuleShaping.lean (917 lines)

Imports `RuleCapture`, `Recurrence`, `SelectionTerm`, `SelectionLevels`.

### Definitions

- **`shaped`** (Def, 150)
  ```
  def shaped (a s p c : Nat) (pos : 0 < a) : CarrierCounts :=
    ⟨a + s + p, a + c + p,
      Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a c) (Nat.le_add_right (a + c) p))⟩
  ```
  The rule after shaping: each shaper leaves `a + s + p`, each other `a + c + p`.
- `thenBy` (313) `def thenBy (g g' : CarrierCounts) : CarrierCounts := ⟨g.carrier * g'.carrier, g.other * g'.other, Nat.mul_pos g.other_pos g'.other_pos⟩`
- `held` (327) `def held (g : CarrierCounts) (n : Nat) : CarrierCounts := ⟨g.carrier ^ n, g.other ^ n, pow_pos_of_pos g.other_pos n⟩`
- **`byBack`** (426) `def byBack (a p c : Nat) (pos : 0 < a) (σ : CarrierCounts → Nat) (x _ : CarrierCounts) : CarrierCounts := shaped a (σ x) p c pos`
- `thresholdBack` (458) `def thresholdBack (hi lo : Nat) (x : CarrierCounts) : Nat := if x.other ≤ x.carrier then hi else lo`
- **`Grouped`** (636)
  ```
  def Grouped (gs : List (List α)) (w shapes : α → Nat) (a s q c : Nat) (pos : 0 < a) : Prop :=
    ∀ g, g ∈ gs → ∀ x, x ∈ g →
      (shapes x = 1 ∧ w x = (shaped a s (q * total g shapes) c pos).carrier) ∨
        (shapes x = 0 ∧ w x = (shaped a s (q * total g shapes) c pos).other)
  ```
- Witness defs: `Split.even` (731), `Assorting.assortedOffspring` (817), `Assorting.mixedOffspring` (824).

### Theorems

- `eq_of_counts` (155).
- **`favours_iff`** (160) `theorem favours_iff {a s p c : Nat} {pos : 0 < a} : CarrierCounts.favours (shaped a s p c pos) ↔ c ≤ s`
- `disfavours_iff` (167) `… CarrierCounts.disfavours (shaped a s p c pos) ↔ s ≤ c`; `favours_alike` (175);
  `shared_lowers` (182), `shared_lowers_strictly` (200), `shared_raises` (222), `lower_c_raises` (240),
  `lower_c_raises_strictly` (246), `shaped_shift` (254).
- `falls_strictly` (262), `present_along` (271), `present_of_le` (277),
  **`nothing_back_falls`** (287)
  ```
  theorem nothing_back_falls {a p c : Nat} {pos : 0 < a} (cost : 0 < c) {x : CarrierCounts}
      (some : 0 < x.carrier) (n : Nat) :
      (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x (n + 1)).carrier *
          (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x n).other <
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x n).carrier *
          (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x (n + 1)).other
  ```
  The shapers' share falls strictly at every step, but never reaches zero carriers (`present_along`):
  a strictly falling share with no end.
- `c_zero_favours` (298), `neutral_steady` (303).
- `select_thenBy` (317), `pow_pos_of_pos` (322), `orbit_held` (331), `le_select_iff` (338),
  `lt_select_iff` (350), `stretch_eq` (362),
  **`stretch_iff`** (373)
  ```
  theorem stretch_iff {a s p c : Nat} {pos : 0 < a} {x : CarrierCounts} (some : 0 < x.carrier)
      (m n : Nat) :
      CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
          (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n) ↔
        (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n
  ```
  `stretch_lt_iff` (383), `wait_not_more` (396), `back_longer_not_less` (411).
- **`byBack_reads_iff`** (431) `theorem byBack_reads_iff {a p c : Nat} {pos : 0 < a} {σ : CarrierCounts → Nat} : ReadsShare CarrierCounts.order CarrierCounts.order (byBack a p c pos σ) ↔ ∀ x y, CarrierCounts.order.le x y → σ x ≤ σ y`
- `covering_locks` (443), `thresholdBack_above` (460), `thresholdBack_below` (464), `thresholdBack_mono`
  (469), `threshold_from_above` (482), `threshold_from_below` (501), `threshold_rule_above` (520),
  `threshold_rule_below` (544), `threshold_rises` (570), `threshold_present_below` (588),
  `threshold_falls` (603).
- `grouped_returns` (644),
  **`grouped_rises_iff`** (663)
  ```
  theorem grouped_rises_iff {gs : List (List α)} {w shapes : α → Nat} {a s q c m : Nat} {pos : 0 < a}
      (equal : ∀ g, g ∈ gs → g.length = m) (grouped : Grouped gs w shapes a s q c pos) :
      discord (whole gs) w shapes < concord (whole gs) w shapes ↔
        c * concord (whole gs) shapes shapes <
          s * concord (whole gs) shapes shapes + m * q * concordAmong gs shapes shapes
  ```
  A case of `SelectionLevels.rises_iff_kept`; "Hamilton's rule … over the rationals" is a docstring
  reading; the statement is over Nat concord/discord.
  `grouped_rises_iff_sized` (679), `grouped_alike_iff` (692), `grouped_kept_rises` (704),
  `grouped_uniform_iff` (714).
- Witnesses: `Split.favours` (735) (a THEOREM named `favours`), `Split.shared_disfavours` (739),
  `Split.rises` (743), `Split.falls` (747), `SharedFlips.without_falls` (756), `SharedFlips.with_rises`
  (762), `Timing.soon_rises` (775), `late_falls` (783), `shorter_falls` (789), `seven_falls` (795),
  `eight_rises` (801), `Assorting.assorted_grouped` (830), `mixed_grouped` (839), `either_verdict`
  (853), `Sized.together_grouped` (873), `apart_grouped` (886), `either_verdict` (902).

RuleShaping is one-level selection arithmetic plus a use of `RuleCapture.favouring_locks` and
`locked_not_below`; it does not touch "what lies beyond", ending, or the grammar.

---------------------------------------------------------------------------------------------------

## 5. Ties to the root found outside these four files (read for this map)

These matter because a design stating the pattern "from the root's laws" would duplicate them.

- `GrammarRegularity.lean:263` **`ClosedCapture.constant_iff_unread`**
  ```
  theorem constant_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} :
      (∀ reads : Nat → Bool, «有常» (Law.step (Pace.step f h reads))
          (sameValue (loopPart (A := A) (B := B) (R := R)))) ↔ Unread f h
  ```
  `Unread` is exactly: the class `sameValue loopPart` is constant (有常) under the two-level step
  along every schedule. Already in the grammar.
- `GrammarRegularity.lean:279` `def favouredAlike (favours : R → Prop) {S : Type u} : «际» (S × R × Nat) := fun p q => favours p.2.1 ↔ favours q.2.1`; `:287` `def lockedAlike (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) : «际» ((A × Nat) × R × Nat) := fun p q => Locked M favours hA (p.1.1, p.2.1) ↔ Locked M favours hA (q.1.1, q.2.1)`; `_class` lemmas (282, 291) prove both are `«类»`.
- `GrammarRegularity.lean:296` `def loss (p : (A × Nat) × R × Nat) : Nat := p.1.2`; `:312` `loss_alters`: under `Accrues`, `¬ loss p = loss (Pace.step (join fA fB) h reads p)` (every step alters the loss).
- `GrammarRegularity.lean:324` **`ClosedCapture.lock_line`**: under `lock_outlives_loss`'s premises, from a locked start `«不穷» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) ((a, b), g, 0)` and every step is `«异» … (lockedAlike M favours hA) (sameValue loss)`. This is (c) stated in the grammar: the line under the respect "locked" never ends while every step alters under the loss. But nothing runs down to an end.
- `GrammarRegularity.lean:352` **`ClosedCapture.loss_ends_line`**: under `turned_by_loss`'s premises plus `start : favours g`, `¬ «不穷» (Law.step (Pace.step (join fA fB) h reads)) (favouredAlike favours) ((a, b), g, 0)`. The line under the respect "favours" ends (class-relatively).
- `GrammarRegularity.lean:371, 386` `Beyond.closed_line`, `Beyond.open_line_ends` (the latter: `«续» … ∧ «亡» …` at step 1 under `favouredAlike favours`).
- `GrammarRegularity.lean:194-207` `constant_of_goAlike`, `goAlike_of_constant`, `goAlike_iff_constant` (for total, determined processes, going alike under a map ↔ the map's class constant under every move); `:221-239` `adaptive_constant_iff`, `adaptive_core_iff`, `adaptive_core_apart` (a state under a rule that changes: class constant / its own core exactly where the rule makes no difference; the core tells apart configurations whose rules differ in effect).
- Root laws used by these files: `Learning.goAlike_iff_lumped` (LearningRuns.lean:113), `Law.sameFuture_of_goAlike` (IdentificationRuns.lean:163, from `«同行之迭»`), `Law.now_identifiesAlike_iff_goAlike` (:170), `Law.part_identifiesAlike_iff_step` (:177), `goAlikeUnder_iff_alike` (Laws.lean:127: `GoAlikeUnder P π E ↔ ∀ a, «同行» (fun s t => P.step s a t) (fun s s' => E (π s) (π s'))`), `Law.constant_iff_keeps` (GrammarCourse.lean:112), `Law.step` (GrammarCourse.lean:103, `def step (next : S → S) : «际» S := fun s t => t = next s`), `Law.perturbation_reabsorbed` (SeekingRuns.lean:49), `«同行»` (GrammarLaws.lean:2568), `«有常»` (Grammar.lean:340), `«核»` (Grammar.lean:375), `«亡»` (Grammar.lean:141), `«续»` (Grammar.lean:126, `«合» R E`, i.e. `R x y ∧ E x y`), `«不穷»` (Grammar.lean:243), `«至终有常»` (GrammarPath.lean:222).

---------------------------------------------------------------------------------------------------

## 6. Answers

### (1) Definitions and main theorems exactly

Given above with lines. Summary of what is a hypothesis vs a theorem in the main laws:

| law | theorem? | hypotheses |
|---|---|---|
| `locked_stays` (RC 182) | Thm | `Raises P favours f`, `ReadsShare P M h`, `upper`, `Locked … (paced … t)` |
| `uniform_locks` (RC 294) | Thm | `Raises`, `ReadsShare`, `uniform : ∀ x g, favours (h x g)`, two reading steps `r < r'` |
| `turn_locked` (RC 169) | Thm | `Raises`, `ReadsShare`, `upper` |
| `order_kept` (RC 426) | Thm | `selects` (f monotone in both), `ReadsShare`, starts ordered |
| `stays_turned` (Pace 162) | Thm | `closed : ∀ b p, Q p → Q (turn f h b p)` |
| `identifiesAlike_iff_unread` (CC 166) | Thm (iff) | none |
| `course_past` (CC 735) | Thm | `Accrues fB`, `agree` past `N`, start past `N` |
| `join_course` (CC 248) | Thm | none |
| `lock_outlives_loss` (CC 307) | Thm | `Raises`, `ReadsShare`, `upper`, `Accrues`, locked start |
| `turned_by_loss` (CC 291) | Thm | `Accrues`, `turns` (reading favours at no loss ≥ N), reading step past N |
| `Thinned.kept_iff` (CC 900) | Thm (iff) | `Accrues`, mirror `hc ho`, `strict`, reading step, past N, rule favours |
| `favours_iff` (RS 160) | Thm (iff) | none |
| `stretch_iff` (RS 373) | Thm (iff) | carriers present |
| `grouped_rises_iff` (RS 663) | Thm (iff) | groups of equal size `m`, `Grouped` |

`Raises`, `ReadsShare`, `Locked`, `Unread`, `Accrues`, `Grouped`, `StretchFixes` are Props
(definitions), never asserted; they enter only as hypotheses, and are proved for particular models
(`CarrierCounts.raises`, `proportional_reads`, `threshold_reads`, `byMargin_reads`,
`Drawn.pool_reads_iff`, `byBack_reads_iff`, `join_unread`, `Thinned.lossStep_accrues`).

### (2) Each definition as a statement about a relation and classes; tie proved?

Underlying relation throughout: `Law.step (Pace.step f h reads)`, the graph of a total function on
`S × R × Nat`.

- `Pace.turn` / `Pace.step` / `paced`: the relation itself (a). Tie to `Law.run`/`Law.orbit`:
  `paced_run` (Pace 131), `orbit_paced` (GrammarRegularity 305). Proved.
- `Unread f h`: going alike (同行) of the class `sameValue loopPart` under the step, along every
  schedule. Proved: one direction `goAlike_of_unread` (CC 147, as `GoAlike`, which is `«同行»` by
  `goAlikeUnder_iff_alike`); iff as `IdentifiesAlike` (`identifiesAlike_iff_unread`, CC 166); iff as
  `«有常»` (`constant_iff_unread`, GrammarRegularity 263). Since the step is total and determined,
  constancy and going alike coincide here (`goAlike_iff_constant`, GR 207), so in this model (b)'s gap
  between 同行 and 有常 does not open for `loopPart`.
- `loopPart`: the map whose `sameValue` is the class. Used as above.
- `join fA fB` / `joinRead hA`: a law for which `loopPart` goes alike by construction
  (`join_unread`, by `rfl`); `join_course` says the quotient of the joined law by `loopPart` (without
  the clock) is the share's own two-level law. As a relation statement it is "the class goes alike and
  the induced law on classes is `Pace.step fA hA reads`". Proved directly by induction; NOT derived
  from `goAlike_of_unread`/`Lumped` (candidate join, below).
- `Locked M favours h`: a predicate on `S × R` closed under every turn (`turn_locked`); so its class
  `lockedAlike` (GR 287) is a class whose line from a locked start never ends (`lock_line`). That
  `Locked` is closed is proved by `stays_turned`; as `«有常»` of `lockedAlike` it is NOT stated
  (`lock_line` gives `«不穷»` from a locked start, not constancy of the class everywhere; a configuration
  that is not locked may become locked, as `Second.second_exact` shows, so `lockedAlike` is not kept in
  general).
- `Raises P favours f`: on the region where the rule favours, the step is inflationary for `P`
  (`P.le x (f x g)`). As a relation: the step lies inside `P.le` on that region. No grammar tie.
- `ReadsShare P M h`: `h` sends the preorder `P` to `M` whatever the rule arguments; in particular
  `h x g` and `h x g'` are `M`-equivalent, so `h` goes alike from the class "same share" into
  "M-equivalent rule". No grammar tie in these files.
- `order_kept`'s premise `selects` plus `ReadsShare`: the product preorder `P × M` is kept by the
  step (a relation constant under the step, in the sense of `Law.constant_iff_keeps`). Not stated in
  grammar terms.
- `Accrues fB`: the class `sameValue loss` is broken at every step (`loss_alters`, GR 312): every
  step is an alteration (异) under the loss. Proved in GR.
- `Pace.rule_unreached` / `rule_alike_until_reading` / `rule_through_pool`: the class "same rule"
  (resp. "same `read` and same rule") goes alike under the step while not reading (resp. through
  `read` at a reading step). Stated pointwise along courses, not as `GoAlike`/`«同行»`. Close to
  `GrammarRegularity.adaptive_constant_iff` (GR 221) but not proved as its case.
- `Thinned.lossPool`: a reading that reads the beyond-part only through the threshold `N ≤ p.2`;
  `lossPool_past` says on the region `N ≤ loss` it equals `joinRead (poolRead u w)`, so there it is
  `Unread`. `course_past` / `past_course`: once in the region (kept by `Accrues`), the course is the
  closed loop's. As a relation: the restriction of the step to an invariant region on which the
  class goes alike. Proved directly by induction, not via `goAlike`.
- `shaped`, `byBack`, `thresholdBack`, `thenBy`, `held`, `Grouped`: count arithmetic; `byBack`
  enters the pattern only through `byBack_reads_iff` (its `ReadsShare` ↔ σ monotone). No class tie.
- `CarrierCounts.order`: a preorder; its equivalence (`le` both ways) is "same share" (a class) but
  is never named or used as a class.

### (3) Hypotheses that in a model with a level under a draw would be derived

- `Accrues fB` (`∀ p g, p.2 + 1 ≤ fB p g`): the beyond-part grows by at least one at EVERY
  configuration, without bound. In a level-under-draw model the loss is the draw accumulated and the
  level is a stock minus it; `Accrues` would be derived from "the draw at each step is ≥ 1", but only
  while the level can supply it. With a bounded stock (or Nat truncation), the draw cannot continue
  for ever, so `Accrues` as stated (unconditional) is FALSE in such a model past exhaustion: it
  encodes an inexhaustible condition. A level model needs it restricted to the region where the level
  meets the draw, and that restriction is exactly where ending would enter.
- `turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)` (`turned_by_loss`) and the threshold in
  `Thinned.lossPool` / `Beyond.lossRead`: the reading of the loss is given by fiat (a threshold `N`).
  In a level model it would be derived from how the reader depends on the level (e.g. a reader that
  itself needs the level).
- `past : N ≤ (course … r).1.2` in the `Thinned` laws: derivable from `loss_grows` given `N ≤ c.1.2 + r`
  (it is a hypothesis on the course, not on the start).
- `Raises`, `ReadsShare`, `upper` are abstract hypotheses derived on counts (§2); a level model
  would have to derive analogous ones for its share.
- In `Thinned` the thing that "runs out" for (d) is the others' share among the readers, thinned by
  selection (`read_in_time_turns` vs `read_late_kept`, `kept_iff`/`turned_iff`): whether the late
  reading turns the course depends on the counts at the reading step. That is derived (from counts),
  not a hypothesis; but it is a share running down, not a level with a point of no return.

### (4) Does anything end, stop or run out?

No course ends. `paced` is defined at every `t : Nat`; `Pace.step` is a total function, so
`Law.step (Pace.step …)` gives every configuration a next. There is no "need", no level that runs to
zero, no point of no return. What the files have instead:
- something grows without bound (`loss_grows`, `lock_outlives_loss`'s `b + t ≤ loss`);
- a share falls strictly at every step without reaching zero carriers (`nothing_back_falls`,
  `present_along`, `threshold_falls`; `Alternating.alternates` falls and alternates forever);
- configurations are lost (unreachable) (`never_reads_lost`, `never_reads_loses`,
  `Switching.fixed_loses`), which is not an end of a course;
- the rule turns (`turned_by_loss`, `Beyond.open_turned`, `Thinned.read_in_time_turns`).
Ending in the grammar's sense (`«亡»`) appears only class-relatively, and only in
`GrammarRegularity.lean`, not in these four files: `loss_ends_line`, `Beyond.open_line_ends` (the
line under "favours or not" ends because the class changes). `lock_line` gives `«不穷»` for the line
under "locked or not". So (c) "up to its end" has no end to reach in these models: the lock lasts for
all `t` while the loss grows for all `t`.

---------------------------------------------------------------------------------------------------

## 7. Against the held attempt (`tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`)

- `TurningInTime.Course.step` (attempt line 186: `def step (s : Way × Nat) : Way × Nat := (c.renew s.1 s.2, c.left s.1 s.2)`)
  is, up to swapping the pair and dropping the clock, `Pace.turn true` with `S = Nat` (level),
  `R = Way`, `f x k = c.left k x`, `h x k = c.renew k x`, `reads ≡ true`: both compute the new rule
  from the OLD fast part. Not proved anywhere; a candidate join. Difference: the attempt's relation
  `cond` (190) is partial (`c.need ≤ s.2 ∧ t = c.step s`), which is where its ending comes from; Pace's
  is total.
- Attempt `Unmarked` (208) / `way_alone` (384) / `alike_along` (393) ("the way is `alone` iterated,
  the same from every level") parallel `Pace.rule_unreached`/`never_reads_course` and
  `ClosedCapture.unread_course`/`join_course` (the respect's course is the same whatever lies beyond).
- Attempt `differs_between` (330) / `goesAlike_iff` (318) parallel `identifiesAlike_iff_unread`,
  `courses_alike_iff_unread`, `reads_beyond_of_apart`, and GR `constant_iff_unread`, with `Between`
  playing the role of "reads beyond". Not the same statement (attempt's class is `s.1 = t.1` on the
  way, Pace's is `sameValue loopPart` on share×rule×clock).
- Attempt `renew` with marks `low ≤ x ≤ high` parallels `Thinned.lossPool`'s threshold `N` and
  `Beyond.lossRead` (a reading that consults the beyond-part only past a bound).
- Attempt `alike_class` (210) parallels GR `lockedAlike_class` / `favouredAlike_class`.
- Attempt `Turning.goes_on_iff` (609) has the same shape as `Thinned.kept_iff`/`turned_iff` (an iff
  on an event at the reading step on the same course), but on a level with a point of no return
  instead of counts; nothing in my files proves it.
- Nothing in my four files proves the attempt's grammar section (`core_step`, `core_steps`,
  `core_apart`, `not_constant`, `alike_steps`); the root has them (reader report H1).

---------------------------------------------------------------------------------------------------

## 8. Not read or not settled

- Not read: `PoolFromCourse.lean`, `ReadOffInTime.lean`, `ReadInTime.lean`, `ChoiceCountCapture.lean`,
  `DrawnShaping.lean`, `PoolCourse.lean`, `PairSelection.lean`, `BandRest.lean`, `RegimeMargin.lean`
  (all import or use these files or `Accrues`; `Accrues` appears also in `ChoiceCountCapture`,
  `PoolFromCourse`, `ReadInTime`). Whether they already derive `Accrues` or a level from a draw is not
  settled here.
- Not read: `SelectionLevels.rises_iff_kept` and `rises_iff_kept_sized` (RuleShaping's group laws
  are their cases), `Identification.bounded_agree*`, `Learning.lasso_*`, `Law.Merges.loses`,
  `Invariant.reach`. I took their names from the files and did not check their statements.
- Not checked by building: every statement above is as written in source; I did not check that the
  files compile or their axiom reports.
- Not settled: whether `Locked` is a case of a root notion of an invariant region (`Invariant`,
  `KeepsRelation`) through `stays`; `stays` uses `Invariant.reach` but no theorem restates `Locked`'s
  closure as `KeepsRelation` or `«有常»`.
