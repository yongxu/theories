Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Lock side, part 2: PoolFromCourse, ReadInTime, ReadingsPersist, ChoiceCountCapture, ReadingsSpread

Read only: nothing was built, run or edited except this file. Paths are relative to
`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/` (PKG).
Line numbers are those files' lines on main at 372705add. Statements are copied. "Thm" is a theorem,
"Def" a definition, "Hyp" a hypothesis (an argument of a theorem).

Upstream terms the statements use (not my files, copied for reading):

- `Pace.turn` (Pace.lean 101): `def turn (f : S → R → S) (h : S → R → R) : Bool → S × R → S × R | true, p => (f p.1 p.2, h p.1 p.2) | false, p => (f p.1 p.2, p.2)`. Both the fast step and the rule read the configuration **before** the step: a rule read at step t is in force from t + 1.
- `Pace.paced` (Pace.lean 112): the run of `turn` with the reading schedule `reads : Nat → Bool`.
- `RuleCapture.Locked` (RuleCapture.lean 160): `def Locked (M : Ideals.Preorder R) (favours : R → Prop) (h : S → R → R) (p : S × R) : Prop := favours p.2 ∧ M.le p.2 (h p.1 p.2)`.
- `RuleCapture.Raises` (145): `∀ x g, favours g → P.le x (f x g)`. `ReadsShare` (150): `∀ x y g g', P.le x y → M.le (h x g) (h y g')`.
- `ClosedCapture.join` (220): `(fA p.1 g, fB p g)`; `joinRead hA p g := hA p.1 g` (223); `Accrues fB : ∀ p g, p.2 + 1 ≤ fB p g` (273); `loss_grows` (277): `c.1.2 + t ≤ (paced (join fA fB) h reads c t).1.2`; `course_past` (735); `lock_outlives_loss` (307).
- `CarrierCounts` (RuleCapture.lean 469): `carrier other : Nat`, `other_pos : 0 < other`; `order.le x y := x.carrier * y.other ≤ y.carrier * x.other`; `favours g := g.other ≤ g.carrier`; `disfavours g := g.carrier ≤ g.other` (both weak); `select x g := ⟨x.carrier * g.carrier, x.other * g.other, _⟩`; `threshold hi lo x _ := if x.other ≤ x.carrier then hi else lo`; `hi := ⟨4,1⟩`, `lo := ⟨1,4⟩`, `twoToOne := ⟨2,1⟩`.
- `ClosedCapture.Thinned.lossPool u v w N p _ := match Nat.blt p.2 N with | true => pool u v p.1 | false => pool u w p.1` (785): **one** mark `N`, the late reading `w` kept for ever after it (no upper bound K).
- `RegimeMargin.step g H x := (x - H) + g (x - H)` (RegimeMargin.lean 249).

## 1. Inventory

### PoolFromCourse.lean (module header 4-101; no other module in PKG imports it)

| Name | Line | Kind |
|---|---|---|
| `ReadsThroughPresent` | 119 | Def |
| `NotReadmitted` | 123 | Def |
| `liftShare` | 127 | Def |
| `twoShares` | 134 | Def |
| `read_absent` | 141 | Thm |
| `turn_locked_at` | 153 | Thm |
| `rule_after` | 173 | Thm |
| `locked_step` | 185 | Thm |
| `locked_along` | 201 | Thm |
| `closed_stays_closed` | 222 | Thm |
| `windowRead` | 252 | Def |
| `Stands` | 256 | Def |
| `window_through` | 259 | Thm |
| `window_unread` | 265 | Thm |
| `stands_not_readmitted` | 271 | Thm |
| `joint_raises` | 278 | Thm |
| `window_past` | 284 | Thm |
| `window_never_read` | 295 | Thm |
| `window_past_course` | 314 | Thm |
| `window_removed_unregistered` | 332 | Thm |
| `window_locked_after_removal` | 342 | Thm |
| `window_standing_thinned` | 366 | Thm |
| `withBound`, `boundRead`, `boundOrder` | 397, 403, 407 | Def |
| `bound_course` | 416 | Thm |
| `boundRead_reads` | 431 | Thm |
| `window_order_kept` | 465 | Thm |
| `bear`, `borneStep` | 498, 504 | Def |
| `bear_shaped_shapers`, `bear_shaped_others` | 509, 516 | Thm |
| `borne_by_shapers_favours_iff`, `borne_by_others_favours_iff` | 524, 530 | Thm |
| `borne_by_others_raises`, `borne_falls` | 536, 543 | Thm |
| `Drained.*` | 554-715 | witnesses |
| `Borne.*` | 719-793 | witnesses |

Exact statements.

- **`ReadsThroughPresent`** (119) Def.
  `def ReadsThroughPresent (present : A × B → Prop) (hA : A → R → R) (h : A × B → R → R) : Prop := ∀ p g, ¬ present p → h p g = hA p.1 g`
  Wherever `present` fails, the rule read on the whole configuration is the share-readers' rule read off the share alone.

- **`NotReadmitted`** (123) Def.
  `def NotReadmitted (present : A × B → Prop) (f : A × B → R → A × B) : Prop := ∀ p g, ¬ present p → ¬ present (f p g)`
  The complement of `present` is closed under one step of the fast law, whatever the rule.

- **`liftShare`** (127) Def: `le p q := P.le p.1 q.1` on `A × B`. **`twoShares P x y`** (134) Def: a preorder on `Bool` reading `false` as `x`, `true` as `y`.

- **`read_absent`** (141) Thm.
  `theorem read_absent {present : A × B → Prop} {hA : A → R → R} {h : A × B → R → R} (through : ReadsThroughPresent present hA h) {p q : A × B} (np : ¬ present p) (nq : ¬ present q) (same : p.1 = q.1) (g : R) : h p g = h q g`
  Two configurations with no reader present and equal share give one rule read, whatever lies beyond. (This is a class going alike under the share in the window's complement: see section 2.)

- **`turn_locked_at`** (153) Thm.
  `theorem turn_locked_at {hA : A → R → R} (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x y : A} {g : R} (rises : P.le x y) (lock : Locked M favours hA (x, g)) (b : Bool) : Locked M favours hA (y, cond b (hA x g) g) ∧ M.le g (cond b (hA x g) g)`
  Premises: `hA` monotone, favouring kept upward, share not falling `x ≤ y`, locked at `(x, g)`. Then the next configuration, read or not, is locked and its rule not lower. By `RuleCapture.turn_locked` on `twoShares`.

- **`rule_after`** (173) Thm.
  `theorem rule_after {c : (A × B) × R} {t : Nat} (agree : reads t = true → h (paced f h reads c t).1 (paced f h reads c t).2 = hA (paced f h reads c t).1.1 (paced f h reads c t).2) : (paced f h reads c (t + 1)).2 = cond (reads t) (hA (paced f h reads c t).1.1 (paced f h reads c t).2) (paced f h reads c t).2`
  Where a reading step reads as the share-readers, the rule after it is theirs; at a non-reading step the rule is kept.

- **`locked_step`** (185) Thm.
  `theorem locked_step (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : (A × B) × R} {t : Nat} (agree : reads t = true → h (paced f h reads c t).1 (paced f h reads c t).2 = hA (paced f h reads c t).1.1 (paced f h reads c t).2) (rises : P.le (paced f h reads c t).1.1 (paced f h reads c (t + 1)).1.1) (lock : Locked M favours hA ((paced f h reads c t).1.1, (paced f h reads c t).2)) : Locked M favours hA ((paced f h reads c (t + 1)).1.1, (paced f h reads c (t + 1)).2) ∧ M.le (paced f h reads c t).2 (paced f h reads c (t + 1)).2`
  One step keeps a lock read off the share where the step's reading agrees with `hA` and the share does not fall across it.

- **`locked_along`** (201) Thm.
  `theorem locked_along (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : (A × B) × R} {r : Nat} (lock : Locked M favours hA ((paced f h reads c r).1.1, (paced f h reads c r).2)) : ∀ k, (∀ j, j < k → (reads (r + j) = true → h (paced f h reads c (r + j)).1 (paced f h reads c (r + j)).2 = hA (paced f h reads c (r + j)).1.1 (paced f h reads c (r + j)).2) ∧ P.le (paced f h reads c (r + j)).1.1 (paced f h reads c (r + j + 1)).1.1) → Locked M favours hA ((paced f h reads c (r + k)).1.1, (paced f h reads c (r + k)).2) ∧ P.le (paced f h reads c r).1.1 (paced f h reads c (r + k)).1.1 ∧ M.le (paced f h reads c r).2 (paced f h reads c (r + k)).2`
  Along any k steps from a lock at r whose readings agree with `hA` and whose share falls at no step, the lock holds at r + k and share and rule are not below where they were. Its contrapositive is the module's "a lock is left only where ... the rule read is not the share-readers', or the share falls" (header 29-33, docstring 199-200). **Docstring caution**: the contrapositive is stated in prose only; there is no Lean statement of "left ⇒ some step disagreed or fell".

- **`closed_stays_closed`** (222) Thm.
  `theorem closed_stays_closed {present : A × B → Prop} (raises : Raises (liftShare P) favours f) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (through : ReadsThroughPresent present hA h) (kept : NotReadmitted present f) {c : (A × B) × R} {r : Nat} (absent : ¬ present (paced f h reads c r).1) (lock : Locked M favours hA ((paced f h reads c r).1.1, (paced f h reads c r).2)) : ∀ k, ¬ present (paced f h reads c (r + k)).1 ∧ Locked M favours hA ((paced f h reads c (r + k)).1.1, (paced f h reads c (r + k)).2) ∧ P.le (paced f h reads c r).1.1 (paced f h reads c (r + k)).1.1 ∧ M.le (paced f h reads c r).2 (paced f h reads c (r + k)).2`
  Premises: selection raises the share under every favouring rule on the whole configuration; `hA` monotone; favouring kept upward; the rule reads through presence; no readmission; at r none present and locked. Then for all k: none present, locked, share and rule not below r's. This is the lock side's "region closed under the step stays closed".

- **`windowRead`** (252) Def.
  `def windowRead (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat) (p : A × Nat) (g : R) : R := if N ≤ p.2 ∧ p.2 < K then hL p g else hA p.1 g`
  Half-open window `[N, K)` on the loss coordinate `p.2`; inside it the readers' rule `hL` (which may read share, loss and rule in force), outside it `hA` off the share.

- **`Stands`** (256) Def. `def Stands (K : Nat) (p : A × Nat) : Prop := p.2 < K`. Only the upper bound K enters; before N the readers "stand" but do not read.

- **`window_through`** (259) Thm. `theorem window_through {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} : ReadsThroughPresent (Stands K) hA (windowRead hA hL N K)`. Where loss ≥ K, the window reads off the share.

- **`window_unread`** (265) Thm. `theorem window_unread {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} (before : K ≤ N) : ReadsThroughPresent (fun _ : A × Nat => False) hA (windowRead hA hL N K)`. With an empty window, the window is `hA` everywhere.

- **`stands_not_readmitted`** (271) Thm. `theorem stands_not_readmitted {fA : A → R → A} {fB : A × Nat → R → Nat} {K : Nat} (accrues : Accrues fB) : NotReadmitted (Stands K) (join fA fB)`. With the loss rising by at least one a step, once loss ≥ K it stays ≥ K.

- **`joint_raises`** (278) Thm. `theorem joint_raises {P : Ideals.Preorder A} {favours : R → Prop} {fA : A → R → A} {fB : A × Nat → R → Nat} (raises : Raises P favours fA) : Raises (liftShare (B := Nat) P) favours (join fA fB)`.

- **`window_past`** (284) Thm. `theorem window_past {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} : ∀ (p : A × Nat) (g : R), K ≤ p.2 → windowRead hA hL N K p g = joinRead hA p g`.

- **`window_never_read`** (295) Thm.
  `theorem window_never_read (raises : Raises P favours fA) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) (before : K ≤ N) {c : (A × Nat) × R} {r : Nat} (lock : Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1, (paced (join fA fB) (windowRead hA hL N K) reads c r).2)) (k : Nat) : c.1.2 + (r + k) ≤ (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.2 ∧ Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1, (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2) ∧ P.le (paced (join fA fB) (windowRead hA hL N K) reads c r).1.1 (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1 ∧ M.le (paced (join fA fB) (windowRead hA hL N K) reads c r).2 (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2`
  Premises: `fA` raises under a favouring rule, `hA` monotone, favouring kept upward, `fB` accrues, `K ≤ N` (readers removed before they read), locked at r. Then at every r + k the loss is at least start + r + k, the course is locked, share and rule not below r's. This is pattern (c) on the lock side: the same in the respect (locked, rule not falling) while the unread coordinate passes every bound. **It does not state any ending**: the course is total; the loss is unbounded and nothing depends on it.

- **`window_past_course`** (314) Thm.
  `theorem window_past_course (accrues : Accrues fB) {c : (A × Nat) × R} {r : Nat} (past : K ≤ (paced (join fA fB) (windowRead hA hL N K) reads c r).1.2) (k : Nat) : ((paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1, (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2) = paced fA hA (fun j => reads (r + j)) ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1, (paced (join fA fB) (windowRead hA hL N K) reads c r).2) k`
  From a step at which loss ≥ K, share and rule are the share's own two-level course from there (shifted schedule).

- **`window_removed_unregistered`** (332) Thm.
  `theorem window_removed_unregistered (accrues : Accrues fB) {hL' : A × Nat → R → R} {c : (A × Nat) × R} (gone : K ≤ c.1.2) : ∀ t, paced (join fA fB) (windowRead hA hL N K) reads c t = paced (join fA fB) (windowRead hA hL' N K) reads c t`
  From a start past K, two readers' rules give one course.

- **`window_locked_after_removal`** (342) Thm.
  `theorem window_locked_after_removal (raises : Raises P favours fA) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) {c : (A × Nat) × R} {r : Nat} (gone : K ≤ (paced (join fA fB) (windowRead hA hL N K) reads c r).1.2) (lock : Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1, (paced (join fA fB) (windowRead hA hL N K) reads c r).2)) (k : Nat) : c.1.2 + (r + k) ≤ (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.2 ∧ ¬ Stands K (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1 ∧ Locked M favours hA (...) ∧ P.le (...) (...) ∧ M.le (...) (...)` (the elided parts are exactly those of `window_never_read`).
  Premises as `window_never_read` with `K ≤ loss at r` in place of `K ≤ N`. Conclusion adds: the readers never stand again. This is the point of no return on the lock side: past K with a lock, the lock is for good.

- **`window_standing_thinned`** (366) Thm.
  `theorem window_standing_thinned {u v w : CarrierCounts} {N K : Nat} {p : CarrierCounts × Nat} (stands : Stands K p) (g : CarrierCounts) : windowRead (Drawn.poolRead u v) (joinRead (Drawn.poolRead u w)) N K p g = Thinned.lossPool u v w N p g`
  While loss < K, the window with the pool of readers `(u, v)` outside and `(u, w)` inside equals MA2's one-mark `lossPool`. Past K they differ (window returns to `v`, lossPool stays at `w`).

- **`withBound`** (397), **`boundRead`** (403) `def boundRead (hA : A → R → R) (hL : A × Nat → R → R) (p : A × Nat × Nat) (g : R) : R := windowRead hA hL 0 p.2.2 (p.1, p.2.1) g`, **`boundOrder`** (407) `le p q := P.le p.1 q.1 ∧ p.2.1 ≤ q.2.1 ∧ q.2.2 ≤ p.2.2`. The bound K carried as a third coordinate; **N fixed at 0**.

- **`bound_course`** (416) Thm. `theorem bound_course (K : Nat) (c : (A × Nat) × R) : ∀ t, paced (withBound fA fB) (boundRead hA hL) reads ((c.1.1, c.1.2, K), c.2) t = (((paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.1, (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.2, K), (paced (join fA fB) (windowRead hA hL 0 K) reads c t).2)`.

- **`boundRead_reads`** (431) Thm.
  `theorem boundRead_reads (monotone : ReadsShare P M hA) (monoL : ∀ x y b b' g g', P.le x y → b ≤ b' → M.le (hL (x, b) g) (hL (y, b') g')) (against : ∀ x y b g g', P.le x y → M.le (hL (x, b) g) (hA y g')) : ReadsShare (boundOrder P) M (boundRead hA hL)`
  With `hA` monotone, `hL` monotone in share and loss, and `hL` never above `hA` at a share not lower, the window is monotone in share, in loss and reversed in the bound.

- **`window_order_kept`** (465) Thm.
  `theorem window_order_kept (selects : ∀ x y g g', P.le x y → M.le g g' → P.le (fA x g) (fA y g')) (drains : ∀ x y b b' g g', P.le x y → b ≤ b' → M.le g g' → fB (x, b) g ≤ fB (y, b') g') (monotone : ReadsShare P M hA) (monoL : …) (against : …) {c c' : (A × Nat) × R} {K K' : Nat} (le : P.le c.1.1 c'.1.1) (leb : c.1.2 ≤ c'.1.2) (leK : K' ≤ K) (leg : M.le c.2 c'.2) (t : Nat) : P.le (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.1 (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).1.1 ∧ (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.2 ≤ (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).1.2 ∧ M.le (paced (join fA fB) (windowRead hA hL 0 K) reads c t).2 (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).2` (`monoL`, `against` as in `boundRead_reads`).
  Two window courses with N = 0, the second starting not lower in share, loss and rule and with a bound not higher, stay ordered in share, loss and rule at every step. **Docstring caution** (457-464): "its readers are gone no later" is a reading, not a statement: no Lean statement compares the steps at which loss passes K in the two courses (it follows from the loss order with `K' ≤ K`, but it is not stated). It covers only N = 0.

- **`bear`** (498) Def. `def bear (onShapers onOthers : Nat) (g : CarrierCounts) : CarrierCounts := ⟨g.carrier + onOthers, g.other + onShapers, _⟩`. A loss borne by the shapers is added to the others' count of the rule, and vice versa.
- **`borneStep`** (504) Def. `def borneStep (onShapers onOthers : Nat → Nat) (p : CarrierCounts × Nat) (g : CarrierCounts) : CarrierCounts × Nat := (select p.1 (bear (onShapers p.2) (onOthers p.2) g), p.2 + 1)`. The loss coordinate is a clock (+1); what is borne is `onShapers` / `onOthers` of it.
- **`bear_shaped_shapers`** (509) Thm. `theorem bear_shaped_shapers {a s p c l : Nat} {pos : 0 < a} : bear l 0 (RuleShaping.shaped a s p c pos) = RuleShaping.shaped a s p (c + l) pos`.
- **`bear_shaped_others`** (516) Thm. `theorem bear_shaped_others {a s p c l : Nat} {pos : 0 < a} : bear 0 l (RuleShaping.shaped a s p c pos) = RuleShaping.shaped a (s + l) p c pos`.
- **`borne_by_shapers_favours_iff`** (524) Thm. `theorem borne_by_shapers_favours_iff {a s p c l : Nat} {pos : 0 < a} : favours (bear l 0 (RuleShaping.shaped a s p c pos)) ↔ c + l ≤ s`.
- **`borne_by_others_favours_iff`** (530) Thm. `theorem borne_by_others_favours_iff {a s p c l : Nat} {pos : 0 < a} : favours (bear 0 l (RuleShaping.shaped a s p c pos)) ↔ c ≤ s + l`. Borne by the others, the shaped rule favours the shapers exactly where cost ≤ return + loss. No premise beyond `0 < a`.
- **`borne_by_others_raises`** (536) Thm. `theorem borne_by_others_raises {onOthers : Nat → Nat} : Raises (liftShare (B := Nat) order) favours (borneStep (fun _ => 0) onOthers)`.
- **`borne_falls`** (543) Thm. `theorem borne_falls {onShapers onOthers : Nat → Nat} {p : CarrierCounts × Nat} {g : CarrierCounts} (some : 0 < p.1.carrier) (lt : (bear (onShapers p.2) (onOthers p.2) g).carrier < (bear (onShapers p.2) (onOthers p.2) g).other) : (borneStep onShapers onOthers p g).1.carrier * p.1.other < p.1.carrier * (borneStep onShapers onOthers p g).1.other`.

Witnesses `Drained` (namespace 554):
- `eightToOne := ⟨8, 1, _⟩` (559). `drain (p) _ := p.2 + 1 + (if 16 * p.1.other ≤ p.1.carrier then 40 else 0)` (563). `readLoss _ _ := lo` (567). `window := windowRead (threshold hi lo) readLoss 0 4` (571). `clock x t := paced (join select Beyond.lossStep) window (fun _ => true) ((x, 0), hi) t` (575). `drained x t := paced (join select drain) window (fun _ => true) ((x, 0), hi) t` (579). `drain_accrues`, `clock_accrues`, `outnumber_mono`, `drawn_mono`, `drain_mono`, `lo_below` (582-619), `premises` (622, all five premises of `window_order_kept` for `drain`).
- **`clock_turned`** (636) Thm. `theorem clock_turned (k : Nat) : (clock eightToOne 4).1.1.carrier = 32 ∧ (clock eightToOne 4).1.1.other = 64 ∧ (clock eightToOne 4).2 = lo ∧ Locked (reverse order) disfavours (threshold hi lo) ((clock eightToOne (4 + k)).1.1, (clock eightToOne (4 + k)).2)`.
- **`strong_undone`** (660) Thm. `theorem strong_undone (k : Nat) : (drained eightToOne 1).2 = lo ∧ (drained eightToOne 2).2 = lo ∧ (drained eightToOne 2).1.2 = 42 ∧ (drained eightToOne 3).1.1.carrier = 32 ∧ (drained eightToOne 3).1.1.other = 16 ∧ (drained eightToOne 3).2 = hi ∧ Locked order favours (threshold hi lo) ((drained eightToOne (3 + k)).1.1, (drained eightToOne (3 + k)).2)`.
- **`weak_turned`** (685) Thm. `theorem weak_turned (k : Nat) : (drained twoToOne 4).1.1.carrier = 8 ∧ (drained twoToOne 4).1.1.other = 64 ∧ (drained twoToOne 4).2 = lo ∧ Locked (reverse order) disfavours (threshold hi lo) ((drained twoToOne (4 + k)).1.1, (drained twoToOne (4 + k)).2)`.
- **`strong_not_below`** (707) Thm. `theorem strong_not_below (t : Nat) : order.le (drained twoToOne t).1.1 (drained eightToOne t).1.1 ∧ (drained twoToOne t).1.2 ≤ (drained eightToOne t).1.2 ∧ order.le (drained twoToOne t).2 (drained eightToOne t).2`.

Witnesses `Borne` (719): `toll b := 4 * b`; `onShapers t := paced (borneStep toll (fun _ => 0)) (joinRead (threshold hi lo)) (fun _ => true) ((twoToOne, 0), hi) t`; `onOthers` with `borneStep (fun _ => 0) toll`.
- **`shapers_turned`** (736) Thm. `(onShapers 1).2 = hi ∧ ¬ order.le (onShapers 1).1.1 (onShapers 2).1.1 ∧ (onShapers 4).2 = hi ∧ (onShapers 5).2 = lo`.
- **`locked_hi`** (742) Thm. `theorem locked_hi {x : CarrierCounts} (fav : favours x) : Locked order favours (threshold hi lo) (x, hi)`.
- **`shapers_left`** (753) Thm. `(onShapers 2).2 = hi ∧ (onShapers 3).2 = hi ∧ ¬ order.le (onShapers 2).1.1 (onShapers 3).1.1 ∧ ¬ order.le (onShapers 3).1.1 (onShapers 4).1.1 ∧ Locked … (onShapers 1) ∧ Locked … (onShapers 2) ∧ Locked … (onShapers 3) ∧ ¬ Locked order favours (threshold hi lo) ((onShapers 4).1.1, (onShapers 4).2)`. A lock left with no reader of the loss at all: the share falls while locked (the loss enters the share, not the reading). Computed: shares (8,1), (32,5), (128,45), (512,585) at steps 1-4.
- **`others_locked`** (782) Thm. `theorem others_locked (t : Nat) : Locked order favours (threshold hi lo) ((onOthers t).1.1, (onOthers t).2) ∧ order.le twoToOne (onOthers t).1.1 ∧ order.le hi (onOthers t).2`.

### ReadInTime.lean (board item MA4b; module header 3-118)

- **`shapedLossPool`** (132) abbrev. `abbrev shapedLossPool (a p c hi lo lo' N : Nat) (pos : 0 < a) : CarrierCounts × Nat → CarrierCounts → CarrierCounts := Thinned.lossPool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos) (RuleShaping.shaped a lo' p c pos) N`. One mark N, the others' late reading `lo'` for ever after.
- **`course`** (139) abbrev: `Thinned.course fB (shaped a hi p c pos) (shaped a lo p c pos) (shaped a lo' p c pos) N reads s t`.
- **`kept_iff`** (155) Thm.
  `theorem kept_iff (accrues : Accrues fB) (readers : lo' ≤ hi) {s : (CarrierCounts × Nat) × CarrierCounts} {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB a p c hi lo lo' N pos reads s r).1.2) (fav : CarrierCounts.favours (course fB a p c hi lo lo' N pos reads s r).2) : (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos) ((course fB a p c hi lo lo' N pos reads s (r + (1 + k))).1.1, (course fB a p c hi lo lo' N pos reads s (r + (1 + k))).2)) ↔ (course fB a p c hi lo lo' N pos reads s r).1.1.carrier * c + (course fB a p c hi lo lo' N pos reads s r).1.1.other * c ≤ (course fB a p c hi lo lo' N pos reads s r).1.1.carrier * hi + (course fB a p c hi lo lo' N pos reads s r).1.1.other * lo'`
  Premises: loss accrues, `lo' ≤ hi`, r a reading step, loss at r past N, the rule in force at r favours the shapers. Then: locked under the late reading at every step from r + 1 iff, at the share of r, `carrier·c + other·c ≤ carrier·hi + other·lo'`. Exact.
- **`loss_next`** (171) Thm: `(course …).1.2 + 1 ≤ (course … (r + 1)).1.2`.
- **`turned_iff`** (185) Thm. Premises: accrues, `lo' ≤ hi`, r and r + 1 reading steps, past N at r, `dis : CarrierCounts.disfavours (DrawnShaping.drawn a p c hi lo' pos (course … r).1.1)`. `(∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (DrawnShaping.drawnRead a p c hi lo' pos) ((course … (r + 1 + (1 + k))).1.1, (course … (r + 1 + (1 + k))).2)) ↔ CarrierCounts.disfavours (DrawnShaping.drawn a p c hi lo' pos (course fB a p c hi lo lo' N pos reads s (r + 1)).1.1)`. Locked the other way from r + 2 iff the late reading disfavours at the share of r + 1 (the share selected under the rule in force at r: one step late).
- **`lossCourse`** (209) abbrev: `course Beyond.lossStep a p c hi lo lo' N pos reads ((x, 0), DrawnShaping.drawn a p c hi lo pos x) t` (loss = step count).
- `shapedLossPool_before` (214), `turn_before` (223), **`early`** (236) Thm `∀ t, t ≤ N → ((lossCourse … x t).1.1, (lossCourse … x t).2) = DrawnShaping.drawnCourse a p c hi lo pos reads x t ∧ (lossCourse … x t).1.2 = t`, **`next_share`** (260).
- **`late_never_falls`** (277) Thm. `(step : lo ≤ hi) (readers : lo' ≤ hi) {x} (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) (t d : Nat) : CarrierCounts.order.le (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1) (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (t + d)).1)`.
- **`kept_early_iff`** (292), **`turned_early_iff`** (319) Thm: `kept_iff`/`turned_iff` placed in MA4's course with the reading from N.
- **`in_time_earlier`** (354) Thm: disfavouring at step t of MA4's course gives it at every s ≤ t.
- `at_most_one_between_up` (369), `none_between_down` (384), **`at_most_one_between`** (397) Thm: with `lo ≤ hi`, at most one step N has the late reading strictly favouring the others at N and strictly the shapers at N + 1.
- **`kept_next_round_iff`** (447).
- **`kept_once_favoured`** (483) Thm. `(step : lo ≤ hi) (readers : lo' ≤ hi) {x} (fav : …) {s} (favoured : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1)) (d : Nat) (at_N : reads (s + d) = true) (k : Nat) : Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos) ((lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).1.1, (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).2)`. Once the late reading would favour at s, every later reading keeps the lock: the lock-side point of no return for a reading, stated as a theorem (the docstring's "Collingridge's second horn").
- `least` (510), `least_iff` (517), **`kept_past_least`** (527), `covers_of_strict` (548), `powers_eq_pow` (562), `held_counts` (568), `powers_base_le` (577), `held_le` (584), `held_past` (600), **`deadline`** (631) Thm: from a start with a shaper and strictly favouring rule `g`, `lo ≤ hi`, `lo' ≤ hi`, a reading from any reading step N ≥ `g.other * c * x.other` keeps the lock from N + 1. A bound, not the closing step (the docstring says so).
- Witnesses `Window.in_time` (669), `Window.between` (681), `Window.too_late` (699), `Window.late_kept` (723), `Window.by_deadline` (733), `Window.scaled` (747), `Between.turned` (773), `Tie.both` (802).

ReadInTime has only one mark (N). Its "too late" is a lock that forms under the late reading, not an ending.

### ReadingsPersist.lean (route (b) J2; header 4-139)

- `ExchangeLaw.byReading` (151), `ReadsThroughOwn` (155), `byReading_withAct` (163), `byReading_nonanticipating` (177), `byReading_through` (183), `ReadsThroughOwn.through_act` (188).
- `Flow.totals_of_follows` (203), **`ExchangeLaw.levels_of_follows`** (216) `theorem ExchangeLaw.levels_of_follows (na : law.Nonanticipating) (balances : L.Balances W) (onPresent : ∀ t, L.present t = present t) (follows : L.Follows law (fun _ => false) W.level) (begins : ∀ c, W.level 0 c = start c) : ∀ t, AgreeUpTo W.level (law.levels present start) t`; **`ExchangeLaw.feasible_of_follows`** (243).
- `SelectionTerm.Generations.descentFrom` (262), `reached_from` (266), **`kept_iff`** (280) `theorem kept_iff {G : Generations α} {Q : α → Prop} {T : Nat} (fixed : ∀ x, x ∈ G.family T → Q x) : (∀ n x, x ∈ G.family (T + n) → Q x) ↔ «闭» (G.descentFrom T) (fun y => Q y.2)`: what holds of every member at T holds at every later step iff it is closed under dated descent from T (the root's `«闭之及»` on dated descent). `kept_of_descent` (293).
- `Flow.descendsB` (309), `descendsB_iff` (315), **`Flow.lineOf`** (332), `mem_lineOf_kids` (338), `lineOf_descended` (344), `lineOf_stands` (348), `InheritsReading` (356), `lineOf_carries` (361).
- `Flow.LineAlive` (377), `LineReachesBefore` (384), `LinesReachBefore` (390), `.reachesBefore` (395), `.affects` (404), `.alive` (411).
- **`StandsLate`** (421) `def StandsLate (group : X → Prop) (l : Nat → X → Nat) : Prop := ∀ N, ∃ t x, N ≤ t ∧ group x ∧ 0 < l t x`. `Web.standsLate_readOffCouplings` (426), `Flow.lineOf_standsLate` (436).
- **`line_standing_unselected`** (459), `line_standing_unselected_of_reads` (480), **`reader_kept_alike`** (505) Thm: under `act_courses_unselected_throughout`'s premises a reader within the closure stands at every step in one course iff in the other. "Near-definitional" by the header's own word.
- **`AliveIn`** (535) `def AliveIn (slotsOf : I → X → Prop) (l : Nat → X → Nat) (t : Nat) (i : I) : Prop := ∃ x, slotsOf i x ∧ 0 < l t x`.
- **`SurvivorsPersist`** (540) `∃ T, ∀ i, (∃ t, T ≤ t ∧ AliveIn slotsOf l t i) → StandsLate (slotsOf i) l`. **`AllPersist`** (544) `∀ i, StandsLate (slotsOf i) l`.
- **`RemovesLine`** (549) `def RemovesLine (slotsOf : I → X → Prop) (l : Nat → X → Nat) (i : I) : Prop := AliveIn slotsOf l 0 i ∧ ∃ T, ∀ t, T ≤ t → ¬ AliveIn slotsOf l t i`.
- **`RemovesItsReaders`** (555) `def RemovesItsReaders (select : (Nat → X → Nat) → Prop) (slotsOf : I → X → Prop) (readers : I → Prop) (l : Nat → X → Nat) : Prop := select l ∧ ∃ i, readers i ∧ RemovesLine slotsOf l i`. A Def, a conjunction: the selection holds at a level history `l` and `l` removes some line marked as a reader. **Nothing ties `readers` to what the selection reads**; the docstring (552-554) and header (64-73) say so ("Which lines read is supplied").
- `RemovesLine.not_standsLate` (560), **`survivorsPersist_of_settled`** (569), **`not_allPersist_of_removes`** (578), `AllPersist.survivors` (583).
- **`Flow.Overdraws`** (592) `def Flow.Overdraws (L : Flow X X) (W : Web X X) (ds : List X) (m : Nat) : Prop := ∃ T n, (∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) ∧ W.stock ds T < n + m`. **`Flow.lineOf_persists_never_overdraws`** (597): a persisting line read off a balanced, acting, dependent flow, gated renewal, cohorts coupled to `ds` at need ≥ m, never sees `Overdraws` (G3's law). **`Flow.carried_keeping_above_ending`** (616).
- `Generations.family_nil_from` (647), `not_persists_of_nil` (652), `persists_of_alive` (659).
- Witness `ReadingsPersist.Habitat` (667-1413): `beyond_standing_unselected` (1222), `beyond_which_persist` (1264), `back_which_persist` (1273), `cleared_removes_its_readers` (1318) `RemovesItsReaders (SurvivorsPersist slotsOf) slotsOf (fun i => i = .d) cleared ∧ ¬ AllPersist slotsOf cleared ∧ AllPersist slotsOf keep`, `clearedBack_removes_both` (1348), `clearedBack_survivors_pass` (1357), reach witnesses (1368-1405). Also `Habitat.ble_congr` (845), reused by ReadingsSpread.

### ChoiceCountCapture.lean (header 5-91)

- `foldAfter` (108); **`selectsThrough`** (117), `chosen_alike` (126), **`unchosen_beyond_coupling`** (138) (by `Flow.unselected_beyond_coupling`), `memberFolds` (162), `memberFolds_alike` (167), `pooled_selectsThrough` (188), `pooled_unchosen_beyond` (202).
- **`choose`** (227) `def choose (x g : CarrierCounts) : CarrierCounts := if g.other ≤ g.carrier then ⟨x.carrier + 1, x.other, x.other_pos⟩ else ⟨x.carrier, x.other + 1, Nat.succ_pos x.other⟩`; `choose_favoured` (231), `choose_unfavoured` (235), `choose_raises` (241), `choose_rises_strictly` (246), `choose_lowers` (253).
- **`weighted`** (261) `def weighted (κc κo : Nat) (pos : 0 < κo) (x _ : CarrierCounts) : CarrierCounts := ⟨κc * x.carrier, κo * x.other, _⟩`; `weighted_reads` (265), `weighted_favours_iff` (275) `favours (weighted κc κo pos x g) ↔ κo * x.other ≤ κc * x.carrier` (by `Iff.rfl`), `start_locked` (281).
- **`counted_locks`** (291), `counted_chooses` (315), `lower_strict` (327), **`counted_locks_down`** (343), `counted_chooses_down` (369): two regions of the threshold, each closed under the course, for every schedule, **given the rule in force read from the counts at the start**.
- `byScore` (384), `posterior_count_falls` (390), `posterior_course_falls` (399).
- **`counted_outlives_loss`** (414) `… (accrues : ClosedCapture.Accrues fB) {x : CarrierCounts} {b : Nat} (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool) (t : Nat) : b + t ≤ (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos)) reads ((x, b), weighted κc κo pos x x) t).1.2 ∧ Locked order favours (weighted κc κo pos) (…) ∧ order.le x (…).1.1 ∧ order.le (weighted κc κo pos x x) (…).2`. `ClosedCapture.lock_outlives_loss` instanced: pattern (c), lock side, with the loss unread.
- Witnesses (437-552): `counted_beats_score`, `score_decides`, `moved_locks_down`, `posterior_share_falls`, `after_one_still_first`, `after_two_turns`, `Stale.above_but_stale_locks_down`, `Stale.above_but_stale_never_first`, `Stale.devalued_read_late_locks_up`, `Stale.devalued_read_late_keeps_first`, `Stale.devalued_read_at_once_locks_down`.

### ReadingsSpread.lean (route (b) K1; header 4-120)

- **`Generations.RevisesBy`** (135) `def RevisesBy (G : Generations α) (read : α → Sig) (sense : Nat → α → O) (upd : Sig → O → Sig) : Prop := ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → read k = upd (read p) (sense t p)`.
- **`Generations.ClosedFrom`** (141) `def ClosedFrom (G : Generations α) (read : α → Sig) (sense : Nat → α → O) (upd : Sig → O → Sig) (P : Sig → Prop) (T : Nat) : Prop := ∀ t, T ≤ t → ∀ p, p ∈ G.family t → P (read p) → P (upd (read p) (sense t p))`.
- **`fixed_of_closedFrom`** (150) `theorem fixed_of_closedFrom (revises : G.RevisesBy read sense upd) (fixed : ∀ x, x ∈ G.family T → P (read x)) (closed : G.ClosedFrom read sense upd P T) : ∀ n x, x ∈ G.family (T + n) → P (read x)`. This is ReadingsSpread's "lock" (header 52-64): a region of readings fixed at T and closed under revision stays fixed. **Not** `RuleCapture.Locked` (header 63-64 says so).
- `revised_out` (158), **`fixed_of_present`** (169), `Flow.RevisesBy` (191), `Flow.inheritsReading_iff` (195), `Flow.RevisesBy.lineOf` (201), **`Flow.closedFrom_of_standing`** (210) `(stands : ∀ t g, T ≤ t → g ∈ G.family t → 0 < W.level t (src t g)) (keeps : ∀ σ τ, P σ → P τ → P (upd σ τ)) (carried : ∀ t y, T ≤ t → 0 < W.level t y → P (read y)) : G.ClosedFrom read (fun t g => read (src t g)) upd P T`: a course that removes the other readings' carriers (every standing relatum carries P from T) closes P under copying.
- `withAmount` (227), `carrying` (237), `revisedIn` (242), `revisedOut` (247), `carrying_raisedAt` (263), `carrying_loweredAt` (269), **`share_step`** (278, Price for the count), `fixed_step` (297), `absent_step` (330), `revised_none_of_inherits` (348).
- `Flow.supported_carriers_not_against` (378), `Flow.carriers_inactive_step` (399), **`Flow.carriers_drawn_down`** (421) `(balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent) (descended : SelectionTerm.Flow.Descended L W G) {ds : List X} {m T n : Nat} (draws : W.stock ds T + total (steps T n) (L.replenishment ds) < m + total (steps T n) (L.uptake ds)) (carriers : ∀ q, q ∈ G.family (T + n) → inR (read q) = true → ∃ e, e ∈ ds ∧ W.requires (T + n) q e ∧ m ≤ W.need (T + n) q e) : (G.carrying read inR).sum (T + n + 1) = G.revisedIn read inR (T + n)`: drawn below the carriers' need, the region's next count is only revisions in (stock side, `LineageDrawdown` ledger).
- `standingCount` (438), **`standingCount_unselected`** (455).
- Witnesses `Revised.rises_then_revised` (505), `Contact.removed_locked` (575), `Contact.met_replaced` (631), `Commons` (639-1276): `generated` (970), `keep_unmoved` (1052), `cleared_spreads` (1133), `keep_persists` (1167), `clearedBack_ends` (1180), `overdrawn_spreads_then_ends` (1222), `overdrawnBack_ends` (1252). `Commons.need x _ := bif isFocal x then 5 else 1` (764): a need on the source's level; the focal line ends when the source falls below 5 ("by the course", docstrings 1173-1179, 1214-1218: those numbers are computed by `rfl`, not stated as separate theorems).

## 2. Answers

### (1) Definitions and main theorems, with premises

Given exactly in section 1. Summary of what is a Def and what is proved:

- Defs: `windowRead`, `Stands`, `ReadsThroughPresent`, `NotReadmitted`, `bear`, `borneStep`, `boundRead`, `boundOrder`, `withBound`; ReadingsPersist's `RemovesItsReaders`, `RemovesLine`, `AliveIn`, `SurvivorsPersist`, `AllPersist`, `StandsLate`, `Overdraws`; ReadingsSpread's `RevisesBy`, `ClosedFrom`.
- `window_never_read`, `window_past_course`, `window_locked_after_removal`, `window_standing_thinned`, `window_order_kept`, `borne_by_others_favours_iff`, `ReadInTime.kept_iff`, `fixed_of_closedFrom`: theorems, premises as copied.
- ReadingsSpread's lock is `fixed_of_closedFrom` (Thm, 150) with the Def `ClosedFrom` (141); its two sufficient cases are `fixed_of_present` (169) and `Flow.closedFrom_of_standing` (210). The module explicitly does not name it `Locked`.
- `RemovesItsReaders` is a Def: `select l ∧ ∃ i, readers i ∧ RemovesLine slotsOf l i`. Its one positive instance is `Habitat.cleared_removes_its_readers` (1318). The only laws about it are `survivorsPersist_of_settled` (a pool read off the course registers no settled removal) and `not_allPersist_of_removes` (a fixed pool registers every removal).

### (2) PoolFromCourse's window course as a case of a one-level, two-mark model

Target: a model with one level `ℓ : Nat` counting down, a lower mark `lowM` (below it nothing reads: the readers are gone), an upper mark `highM` (above it nothing reads yet), and the rule rebuilt from the level while `lowM ≤ ℓ ≤ highM` (the held attempt's `Course.Between`/`renew`, TurningInTime.lean 173, 179, uses exactly this inclusive form).

Correspondence of coordinates. PoolFromCourse's loss `b` counts up from `c.1.2` by `Accrues` (`p.2 + 1 ≤ fB p g`), unbounded. Fix a ceiling `M` and read `ℓ := M - b` (natural subtraction).

| PoolFromCourse | Level model |
|---|---|
| `b = p.2`, rises by `fB p g - p.2 ≥ 1` | `ℓ = M - b`, falls by the draw `d := fB p g - p.2 ≥ 1`, floored at 0 |
| `N ≤ b` (readers have begun) | `ℓ ≤ M - N` =: `highM` |
| `b < K` (`Stands K`) | `M - K < ℓ`, i.e. `M - K + 1 ≤ ℓ` =: `lowM` |
| `windowRead hA hL N K` | rule rebuilt from `ℓ` between the marks (by `hL (x, M - ℓ) g`), else `hA x g` |
| `stands_not_readmitted` | `ℓ` never rises, so once below `lowM` it stays below |
| `loss_grows`: `c.1.2 + t ≤ b_t` | `ℓ_t ≤ ℓ_0 - t` (truncated) |
| `boundOrder`: loss not lower, bound not higher | level not higher, lower mark not lower |
| `window_locked_after_removal`'s `K ≤ b_r` | `ℓ_r < lowM`: the point of no return for the readers |

What would have to be proved: an equality of courses, `∀ t, φ (paced (join fA fB) (windowRead hA hL N K) reads c t) = levelCourse (φ c) t`, with `φ ((x, b), g) := ((x, g), M - b)`, the level model's way `Way := A × R`, its "alone" step `(x, g) ↦ (fA x g, cond (reads t) (hA x g) g)`, its "with level" step `(x, g) ℓ ↦ (fA x g, cond (reads t) (hL (x, M - ℓ) g) g)`, its use `d`. Then every PoolFromCourse law above becomes a statement about the level.

Where it fails, or needs extra premises:

1. **Truncation.** The window identification needs `K ≤ M` (else for `b ∈ [M, K)` the window reads but `ℓ = 0 < lowM`; with `K ≤ M`, `lowM = M - K + 1 ≥ 1 > 0` and the floor is harmless). `loss_grows` ("passes every bound") becomes "reaches 0 and stays": one-way only, and the number of steps past `M` is lost.
2. **The draw reads more than the way.** In TurningInTime `use : Way → Nat` and `left = RegimeMargin.step giving (use k) x = (x - H) + giving (x - H)`. PoolFromCourse's `fB : A × Nat → R → Nat` reads the share, the rule **and the loss**. The increment `fB p g - p.2` is a function of the way only when `fB` is of the form `p.2 + d(p.1, g)`. `Drained.drain` is (increment `1 + (40 or 0)` reads the share only); a general `Accrues` `fB` is not.
3. **No giving back; no need.** PoolFromCourse's loss never falls (`Accrues`), so the level model must have `giving = 0` (or net draw ≥ 1); a RegimeMargin level with `giving > 0` is not a PoolFromCourse course. PoolFromCourse has **no ending**: `paced` is total and no `need` cuts the course. The level model's `cond`'s need must be 0 for the correspondence, and then (c)'s "something it depends on runs down, with a point of no return" is only the readers' removal at `lowM`, not the line's ending. Nothing in PoolFromCourse depends on the loss except who reads.
4. **Reading schedule.** `paced` rebuilds the rule only where `reads t`; a level model whose rule is rebuilt each step needs `reads = fun _ => true` or the step count carried in the state (PoolFromCourse's `withBound` shows the pattern for the bound, not for the clock).
5. **Outside the window the rule is not frozen.** Outside `[N, K)` the rule is `hA x g`, read off the share, which changes; the level model's "nothing reads" must mean "nothing of the level reads", not "the rule is kept". (TurningInTime's `alone k` can encode this with `Way = A × R`.)
6. **Half-open vs closed.** `windowRead` uses `N ≤ b ∧ b < K`; `Between` uses `low ≤ x ∧ x ≤ high`. The translation above handles it; a design must fix one.
7. **Order results only at N = 0.** `boundRead`, `boundRead_reads`, `window_order_kept` fix `N = 0`; the upper mark is then `highM = M`, the start. An order law for general `N` (two upper marks) is not proved.
8. **`window_standing_thinned` is not a case of the two-mark model past K**: MA2's `lossPool` (ReadInTime's `shapedLossPool`) has one mark N and keeps the late reading for ever; the window returns to `hA` at K. ReadInTime is a case of the two-mark model only with `K = ∞` (no lower mark).

### (3) Which modules name terms of both the lock side and the stock side

Counted outside comments (grep): PoolFromCourse `Locked` 29, `paced` 74, `Web`/`Flow`/`World`/`ExchangeLaw` 0. ReadInTime `Locked` 17, `Web`/`Flow` 0. ReadingsPersist `Locked`/`paced` 0, `Flow` 34, `Web` 16, `ExchangeLaw` 39, `level` 53. ChoiceCountCapture `Locked` 8, `paced` 48, `Web` 14, `Flow` 6. ReadingsSpread `Locked` 1 (only in the header, to say it is not used), `Flow` 21, `Web` 4, `level` 25, "World" once (header 73).

- **ChoiceCountCapture is the only one of the five naming both** (`Web.SelectsThrough`, `Flow.WithheldLevels`, `W.level` in `selectsThrough`/`unchosen_beyond_coupling`; `Locked`, `paced`, `Accrues` in the Count section). The two sections share no hypothesis and no term: the chooser's fold over a `Web` and the counted rule's `paced` course are never stated of one system.
- PoolFromCourse and ReadInTime are lock side only. Their "loss" and "drain" are a `Nat` coordinate in `paced (join fA fB) …`; there are no levels, stock, `Flow` or `Web`. PoolFromCourse's `level` hits are the prose of the two-level course.
- ReadingsPersist and ReadingsSpread are stock side (`Flow`, `Web`, `ExchangeLaw`, levels, `Overdraws`, `LineageDrawdown`). They carry the selection/pool vocabulary (`RemovesItsReaders`, `SurvivorsPersist`, Price's share), and ReadingsSpread a "lock" as a closed region of readings (`fixed_of_closedFrom`), but never `RuleCapture.Locked` or `paced`.
- The header of PoolFromCourse (13-16) names `ReadingsPersist.RemovesItsReaders` and the meta-attractor, but PoolFromCourse proves nothing about `RemovesItsReaders`; no Lean statement joins them.

### (4) What the witnesses compute

Common: `reads = fun _ => true`; at every step `turn` gives `((select x g, drain (x, b) g), window (x, b) g)` from the configuration `((x, b), g)` before the step; `window (x, b) g = if 0 ≤ b ∧ b < 4 then lo else threshold hi lo x g`; `select (c, o) (gc, go) = (c·gc, o·go)`; `hi = (4,1)`, `lo = (1,4)`; `drain (x, b) _ = b + 1 + (if 16·x.other ≤ x.carrier then 40 else 0)`.

**`Drained.strong_undone`**, start `((8,1), 0), hi`:

| step | share | loss | rule in force | how the next is computed |
|---|---|---|---|---|
| 0 | (8,1) | 0 | hi | select (8,1) hi = (32,1); drain 0+1+(16 ≤ 8? no)=1; window: 0 < 4 → lo |
| 1 | (32,1) | 1 | **lo** | select (32,1) lo = (32,4); drain 1+1+(16 ≤ 32 → 40) = 42; window: 1 < 4 → lo |
| 2 | (32,4) | **42** | **lo** | select (32,4) lo = (32,16); drain 42+1+(64 ≤ 32? no) = 43; window: 42 ≥ 4 → threshold (32,4): 4 ≤ 32 → hi |
| 3 | **(32,16)** | 43 | **hi** | locked: `favours hi` (1 ≤ 4) and `order.le hi (threshold hi lo (32,16) hi) = hi` (16 ≤ 32) |

Then `window_locked_after_removal` with `P = M = order`, `favours`, `raises`, `threshold_reads lo_le_hi`, `upper`, `drain_accrues`, `gone : 4 ≤ 43`, r = 3 gives the lock at every `3 + k` (component `.2.2.1`). The readers read at steps 0 and 1 only (rules lo at 1 and 2); the 40 drawn at step 1, because the share then outnumbers sixteen to one, removes them (loss 42 ≥ 4) before their reading `lo` can lower the share below the threshold, and the threshold reads `hi` again.

**`Drained.weak_turned`**, start `((2,1), 0), hi`:

| step | share | loss | rule | next |
|---|---|---|---|---|
| 0 | (2,1) | 0 | hi | (8,1); drain 1 (16 ≤ 2 no); window 0 < 4 → lo |
| 1 | (8,1) | 1 | lo | (8,4); drain 2 (16 ≤ 8 no); 1 < 4 → lo |
| 2 | (8,4) | 2 | lo | (8,16); drain 3 (64 ≤ 8 no); 2 < 4 → lo |
| 3 | (8,16) | 3 | lo | (8,64); drain 4 (256 ≤ 8 no); 3 < 4 → lo |
| 4 | **(8,64)** | 4 | **lo** | locked the other way: `disfavours lo` (1 ≤ 4) and `(reverse order).le lo (threshold hi lo (8,64) lo) = lo` |

Then `window_locked_after_removal` with `P = M = reverse order`, `favours := disfavours`, `lowers`, `(threshold_reads lo_le_hi).reverse`, `lower`, `drain_accrues`, `gone : 4 ≤ 4`, r = 4. The extra 40 is never drawn (16·other ≤ carrier fails at every step: carrier stays 8, other grows); the readers read four times (rules lo at steps 1-4) and the share is turned before they are gone. Same as `clock_turned` (loss one a step) from (8,1): shares (32,1), (32,4), (32,16), (32,64) at steps 1-4, rule lo at 4.

`strong_not_below` (707) compares the two `drained` courses by `window_order_kept` (K = K' = 4): at every step the strong course is not below the weak one in share, loss or rule. So the start not lower draws more and loses its readers sooner, and ends up locked the shapers' way; the lower start is turned. This is (d) in one witness: what would bring the difference (the readers) is drawn out by the course they would turn.

## 3. What the held attempt already has in these files (TurningInTime.lean, tmp/r7/the-loop)

- `Course.renew`/`Between` (TurningInTime 173, 179): the same two-mark switch as `PoolFromCourse.windowRead` (252), on a level instead of a loss, closed instead of half-open.
- `Turning.kept` (premise, "once it uses less it keeps doing so at every renewal") and `Turning.alone`: the lock-side counterparts are proved theorems here: `closed_stays_closed` (222) with `NotReadmitted`, `stands_not_readmitted` (271), `RuleCapture.locked_stays`; and `locked_along` (201) for "left only where the reading disagrees or the share falls". The attempt takes as premises what these prove for the lock.
- `used_up_alike` ("used up while nothing in it differs"): lock-side form is `window_never_read` (295), `window_locked_after_removal` (342), `ChoiceCountCapture.counted_outlives_loss` (414), `ClosedCapture.lock_outlives_loss`; none of them has an ending, which the attempt's has.
- `Witness.in_time` / `Witness.too_late` (TurningInTime 713, 720): same names and same shape as `ReadInTime.Window.in_time` (669) and `ReadInTime.Window.too_late` (699), and the one-step lag of `ReadInTime.turned_iff` (185) ("a rule read at a step is in force from the next") is the lag that makes the attempt's `too_late` late (reader report M2).
- `Turning.goes_on_iff` (exact condition, an event on the line): ReadInTime's `kept_iff` (155) / `turned_iff` (185) / `at_most_one_between` (397) are exact conditions of the same kind on the lock side; `kept_once_favoured` (483) is the lock-side "after this step a reading cannot turn it".
- The attempt's grammar section (core, 同行, 有常): none of my five files states it; `read_absent` (141) is the nearest (a class, equal share, going alike in the window's complement), not in the grammar's terms.

## 4. Not read or not settled

- Read in full: PoolFromCourse, ReadInTime, ReadingsPersist, ChoiceCountCapture; ReadingsSpread fully to 650 and the Commons statements (994-1276); its Commons `conduct` cases and balance proofs (650-990) only skimmed.
- Upstream statements were copied only where needed (Pace, RuleCapture, ClosedCapture, RegimeMargin.step). `ClosedCapture.Thinned.read_late_kept`, `read_in_time_turns`, `rule_read`, `kept_iff` (lines 830-900) and `DrawnShaping.drawn` (146) were located, not read; ReadInTime's mirror-premise claim about `Thinned.kept_iff` is unchecked.
- Not settled: whether `paced` with `Accrues` and `fB = p.2 + d(p.1, g)` is literally a `TurningInTime.Course` run (the attempt's `step` renews every step and has no schedule); the bookkeeping in (2) is argued, not proved.
- The Drained/Borne numbers in (4) are hand computations; the theorems prove them by `rfl`, and I checked my tables against the stated values only.
