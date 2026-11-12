Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Follow-up: the draw premise (Optimum levels, RegimeMargin below the point of no return, Amounts' rest by balance, TurningInTime's turn)

Read only. Nothing was built or run. PKG = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
TT = `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` (held attempt). Line numbers are of the files as read on 12 November.

Imports that matter for any join: `RegimeMargin.lean` imports `Becoming.Optimum` (line 4) and already calls
`Optimum.sub_le_sub_left_of_le` (lines 1217, 2902). `Optimum.lean` imports `DrawnBeyond` and `Frontier`, not RegimeMargin;
TT imports `Becoming.RegimeMargin`. So RegimeMargin may use Optimum's level laws; Optimum may not use RegimeMargin's.

## 1. Inventory

### 1.1 Optimum.lean, `namespace Optimum`, `section Levels` (2228-2594), variables `{x g d : Nat → Nat} {r m : Nat}`

All are theorems unless marked def. `x` is a level indexed by time, `g t` what is given at step `t`, `d t` what is taken; `g`, `d` are arbitrary time sequences, not functions of the level.

- **sub_le_sub_right_of_le** (2234), theorem.
  `theorem sub_le_sub_right_of_le {n k : Nat} (le : n ≤ k) : ∀ a, n - a ≤ k - a`
  Truncated subtraction keeps order on the left argument.
- **sub_le_sub_left_of_le** (2239), theorem.
  `theorem sub_le_sub_left_of_le {a b : Nat} (le : a ≤ b) (n : Nat) : n - b ≤ n - a`
  Subtracting more gives at most as much.
- **never_rises** (2246), theorem.
  `theorem never_rises (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r) (over : r < d t) : x (t + 1) ≤ x t`
  If the step law holds and at step `t` the gift is at most `r` and the draw more than `r`, the level does not rise across `t`. One step; the draw `d t` may be any value above `r`.
- **level_stays_below** (2255), theorem.
  `theorem level_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m`
  With gift ≤ `r` < draw at every step, a level below `m` at `s` stays below `m` from `s` on. (`m` arbitrary.)
- **level_le_start** (2262), theorem.
  `theorem level_le_start (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) : ∀ t, x t ≤ x 0`
  Same premises; the level is never above its start.
- **falls_over** (2269), theorem.
  `theorem falls_over (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r) (over : r < d t) (positive : 0 < x t) : x (t + 1) + 1 ≤ x t`
  One step: gift ≤ `r` < draw and a positive level, the level falls by at least one.
- **drawnAt** (2281), def.
  `def drawnAt (x g : Nat → Nat) (t : Nat) : Nat := x t + g t - x (t + 1)`
  What a step actually took: level plus gift less the level after (the draw as realized, not `d t`).
- **ends_within** (2289), theorem.
  `theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) (needs : 0 < m) : ∀ t, x 0 < m + t → x t < m`
  With gift ≤ `r` < draw at every step and a positive need `m`, the level is below `m` at every `t` with `x 0 < m + t`. The proof (2292-2313) splits on `x t < m`; if not, every earlier level stood at `m` or above (via never-rising), so each earlier step lost at least one more than it gained (`falls_over` turned into `g s + 1 ≤ drawnAt x g s`), and `Amounts.falls_by_stretch` on the stretch `0 .. t` with `q := x`, `x := drawnAt x g`, `y := g` gives `x t + t ≤ x 0`, a contradiction. This is already a **changing-draw law**: `d` is any sequence above a constant `r`.
- **kept_at_need** (2318), theorem.
  `theorem kept_at_need (step : ∀ t, x (t + 1) = x t + g t - d t) (renewing : ∀ t, m ≤ x t → g t = r) (within : ∀ t, d t ≤ r) (start : m ≤ x 0) : ∀ t, m ≤ x t ∧ x t ≤ x (t + 1)`
  If exactly `r` is given at or above the need and the draw never exceeds `r`, a level starting at the need stays at or above it and never falls.
- **renews_of** (2333), theorem.
  `theorem renews_of (renewing : ∀ t, m ≤ x t → g t = r) (unsupported : ∀ t, x t < m → g t = 0) (t : Nat) : g t ≤ r`
  A gift that is `r` at the need or above and `0` below is at most `r`.
- **kept_iff_within** (2342), theorem.
  `theorem kept_iff_within (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat} (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r) (draws : ∀ t, d t = k) (needs : 0 < m) (start : m ≤ x 0) : (∀ t, m ≤ x t) ↔ k ≤ r`
  Under a standing draw `k`, a level starting at a positive need is kept forever exactly where `k ≤ r`. (→ by `ends_within` at `t := x 0`.)
- **gated_stays_below** (2357), theorem.
  `theorem gated_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (unsupported : ∀ t, x t < m → g t = 0) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m`
  If nothing is given below `m`, a level below `m` stays below, whatever is drawn.
- **reread_kept_iff** (2369), theorem.
  `theorem reread_kept_iff (step : ∀ t, x (t + 1) = x t + g t - d t) {T : Nat} (renews : ∀ t, t < T → g t ≤ r) (over : ∀ t, t < T → r < d t) (keeps : ∀ t, T ≤ t → m ≤ x t → m ≤ x (t + 1)) : (∀ t, m ≤ x t) ↔ m ≤ x T`
  Before a fixed `T`, gift ≤ `r` < draw; from `T` on, each step preserves `m ≤ x`. Then the level meets `m` at every step exactly where it meets it at `T`. `T` is a parameter, not found. The proof splits the run at `T` (2386: `match Nat.lt_or_ge t T`): before `T`, `x T ≤ x t` (the `before` chain of `never_rises`, 2372-2380); from `T`, induction on `keeps` (2382-2385). No `0 < m` premise.
  Docstring caution: "as an optimum among the outcomes keeping it does (`Flow.keeping_optimum_takes_slack`)" describes an intended source of `keeps`; the statement assumes only `keeps` and says nothing of an optimum.
- **reread_deadline_iff** (2396), theorem.
  `theorem reread_deadline_iff (step : ∀ t, x (t + 1) = x t + g t - d t) (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r) {k T : Nat} (draws : ∀ t, t < T → d t = k) (over : r < k) (needs : 0 < m) : m ≤ x T ↔ m + T * (k - r) ≤ x 0`
  With exactly `r` given at or above the need, at most `r` always, and a standing draw `k > r` before `T`, the need is met at `T` exactly where `x 0 ≥ m + T·(k − r)`.
  Note: it has a "prefix" premise (`t < T`) for the draw only; `renews` is still for all `t`.

Outside my range but seen by grep only (not read): `ends_within` is used at Optimum 2495 and 2684; prefix-premise lemmas `sum_add_shortfall_up_to` (3548) and neighbours (3568, 3588) take `renews : ∀ t, t < n → …`.

### 1.2 Amounts.lean 470-545, `namespace Amounts`

- **total_steps_le** (472), theorem.
  `theorem total_steps_le {f g : Nat → Nat} : ∀ S n, (∀ t, S ≤ t → t < S + n → f t ≤ g t) → total (steps S n) f ≤ total (steps S n) g`
  Stepwise ≤ over a stretch gives ≤ of totals.
- **total_steps_add** (481), theorem.
  `theorem total_steps_add (f g : Nat → Nat) : ∀ S n, total (steps S n) (fun t => f t + g t) = total (steps S n) f + total (steps S n) g`
  Totals add.
- **falls_by_stretch** (493), theorem. ("Rest by balance.")
  `theorem falls_by_stretch {q x y : Nat → Nat} (S n : Nat) (across : ∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t) (loses : ∀ t, S ≤ t → t < S + n → y t + 1 ≤ x t) : q (S + n) + n ≤ q S`
  A count balanced across each step of the stretch `[S, S+n)` (after + lost = before + gained), losing at least one more than it gains at each step, ends with `q (S+n) + n ≤ q S`. Premises are only on the stretch. Here `x` is what is lost and `y` what is gained (the letters clash with Optimum's `x` = level).
- **unmarked_or_marked** (506), theorem.
  `theorem unmarked_or_marked {P : Nat → Prop} (decide : ∀ t, P t ∨ ¬ P t) (S : Nat) : ∀ n, (∃ N, S ≤ N ∧ N < S + n ∧ ¬ P N) ∨ ∀ t, S ≤ t → t < S + n → P t`
  For a decided mark, some step of the stretch is unmarked or all are marked. (Gives "some", not "a first".)
- **unmarked_within** (522), theorem. ("Rest by balance, decided.")
  `theorem unmarked_within {q x y : Nat → Nat} {P : Nat → Prop} (decide : ∀ t, P t ∨ ¬ P t) (S : Nat) (across : ∀ t, S ≤ t → q (t + 1) + x t = q t + y t) (loses : ∀ t, S ≤ t → P t → y t + 1 ≤ x t) : ∃ N, S ≤ N ∧ N ≤ S + q S ∧ ¬ P N`
  A count balanced from `S` on, losing at least one more than it gains at each marked step, has an unmarked step within `q S` steps. The loss is gated by the mark, not required everywhere.
- **le_by_exchange** (537), theorem.
  `theorem le_by_exchange {q x y q' x' y' : Nat → Nat} (S n : Nat) (across : ∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t) (across' : ∀ t, S ≤ t → t < S + n → q' (t + 1) + x' t = q' t + y' t) (start : q S ≤ q' S) (exchange : ∀ t, S ≤ t → t < S + n → y t + x' t ≤ y' t + x t) : q (S + n) ≤ q' (S + n)`
  Two balanced counts compare at the end by their stepwise exchanges.

### 1.3 RegimeMargin.lean (247-268, 294-352, 449-612, 705-758)

Top level, `namespace RegimeMargin`:

- **step** (249), def. `def step (g : Nat → Nat) (H x : Nat) : Nat := (x - H) + g (x - H)`
  A standing draw `H` takes first, as much as there is; the giving `g` is a function of what is left.
- **FromNothing** (252), def. `def FromNothing (g : Nat → Nat) : Prop := g 0 = 0`
- **Short** (255), def. `def Short (g : Nat → Nat) (H y : Nat) : Prop := ∀ z, z < y → g z < H`
- **Root** (258), def. `def Root (g : Nat → Nat) (H y : Nat) : Prop := H ≤ g y ∧ Short g H y`
- **Meets** (262), def. `def Meets (g : Nat → Nat) (H y hi : Nat) : Prop := ∀ z, y ≤ z → z + H ≤ hi → H ≤ g z`
- **Keeps** (265), def. `def Keeps (g : Nat → Nat) (H hi : Nat) : Prop := ∀ x, x ≤ hi → step g H x ≤ hi`
- **Gated** (268), def. `def Gated (g : Nat → Nat) (m : Nat) : Prop := ∀ z, z < m → g z = 0`

`namespace Adjusted` (294-700): the state is a pair (level, recent giving).

- **Adjusted.step** (299), def. `def step (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Nat × Nat := (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2)`
- **Adjusted.StaysShort** (304), def. `def StaysShort (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop := ∀ e r, r < H → g e < H → A e r < H`
- **Adjusted.StaysMet** (309), def. `def StaysMet (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop := ∀ e r, H ≤ r → H ≤ g e → H ≤ A e r`
- **Adjusted.FromNothing** (317), def. `def FromNothing (A : Nat → Nat → Nat) : Prop := ∀ r, A 0 r = 0` (same name as the top-level one, different type).
- **Adjusted.Keeps** (321), def. `def Keeps (A : Nat → Nat → Nat) (H hi : Nat) : Prop := ∀ x r, x ≤ hi → H ≤ r → (step A H (x, r)).1 ≤ hi`
- **Adjusted.orbit_regime** (336), theorem.
  `theorem orbit_regime (g : Nat → Nat) (H : Nat) (p : Nat × Nat) : ∀ n, (Law.orbit (step (fun e _ => g e) H) p n).1 = Law.orbit (RegimeMargin.step g H) p.1 n`
  The regime's step is the adjusted step that ignores the recent giving, along every run.
- **Adjusted.regime_staysShort** (341), **regime_staysMet** (344), **regime_fromNothing** (347), **regime_keeps** (351): the regime's giving satisfies each adjusted premise.
  `theorem regime_staysShort (g : Nat → Nat) (H : Nat) : StaysShort (fun e _ => g e) g H`
  `theorem regime_fromNothing {g : Nat → Nat} (nothing : RegimeMargin.FromNothing g) : FromNothing (fun e _ => g e)`
- **Adjusted.draw_pos** (449), theorem.
  `theorem draw_pos {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (below : x < H + y) : 0 < H`
  `Short` below `y` and a level below `H + y` force a positive draw (else `g 0 < 0`).
- **Adjusted.left_falls** (461), theorem.
  `theorem left_falls {d a H : Nat} (gives : a < H) : d + a - H ≤ d - 1`
  Arithmetic: with a gift short of the draw, what is left falls by one unless nothing is left.
- **Adjusted.left_below** (474), theorem.
  `theorem left_below {H y x : Nat} (ypos : 0 < y) (below : x < H + y) : x - H < y`
- **Adjusted.step_below** (485), theorem.
  `theorem step_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) : (step A H (x, r)).1 < H + y ∧ (step A H (x, r)).2 < H ∧ (0 < x → (step A H (x, r)).1 < x)`
  One step below the point of no return: the level stays below `H + y`, the new giving stays short of `H`, and a positive level strictly falls. This is the invariant plus the one-step loss.
- **Adjusted.from_zero** (507), theorem.
  `theorem from_zero {A : Nat → Nat → Nat} (H : Nat) (nothing : FromNothing A) {p : Nat × Nat} (zero : p.1 = 0) : ∀ k, (Law.orbit (step A H) p k).1 = 0`
- **Adjusted.step_balances** (517), theorem.
  `theorem step_balances (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : (step A H p).1 + (p.1 - (p.1 - H)) = p.1 + A (p.1 - H) p.2`
  The step balances with the realized draw `p.1 - (p.1 - H)` (= min(level, H)) as what is lost. No premise.
- **Adjusted.orbit_inside** (524), theorem.
  `theorem orbit_inside {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) : ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H`
  The invariant along the whole run.
- **Adjusted.orbit_bound** (539), theorem.
  `theorem orbit_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) : ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧ (Law.orbit (step A H) (x, r) n).1 ≤ x - n`
  After `n` steps the level is ≤ `x − n`. Proof: `Amounts.unmarked_or_marked` on "level positive"; if some step has level 0, `from_zero`; if all positive, `Amounts.falls_by_stretch` with `q` = level, lost = realized draw (`p.1 - (p.1 - H)`), gained = adjusted giving, `across` = `step_balances`, `loses` from `step_below`'s third conjunct. So it reduces to the same Amounts law as `Optimum.ends_within`, with the realized draw as what is lost.
- **Adjusted.ends_below** (572), theorem.
  `theorem ends_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) : ((Law.run (step A H) (x, r)).state x).1 = 0`
  Below the point of no return, with recent giving short of `H`, the level is 0 after `x` steps. (`orbit_bound` at `n := x`.)
- **Adjusted.stays_ended** (580), theorem.
  `theorem stays_ended {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) (k : Nat) : ((Law.run (step A H) (x, r)).state (x + k)).1 = 0`
- **Adjusted.left_bound** (590), theorem.
  `theorem left_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y) (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) : ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧ (Law.orbit (step A H) (x, r) n).1 - H ≤ x - H - n`
  Without `FromNothing`: what the draw leaves falls by one per step.

Top level again, after `end Adjusted` (700):

- **RegimeMargin.ends_below** (705), theorem.
  `theorem ends_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (nothing : FromNothing g) (below : x < H + y) : (Law.run (step g H) x).state x = 0`
  The regime's case of `Adjusted.ends_below` via `orbit_regime` with recent giving `0` and `draw_pos`.
- **RegimeMargin.stays_ended** (712), theorem.
  `theorem stays_ended {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (nothing : FromNothing g) (below : x < H + y) (k : Nat) : (Law.run (step g H) x).state (x + k) = 0`
- **ends_beyond_giving** (721), theorem.
  `theorem ends_beyond_giving {g : Nat → Nat} {H : Nat} (beyond : ∀ z, g z < H) (nothing : FromNothing g) (x : Nat) : (Law.run (step g H) x).state x = 0`
- **holds** (730), theorem.
  `theorem holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (keeps : Keeps g H hi) (low : H + y ≤ x) (high : x ≤ hi) : ∀ n, x ≤ (Law.run (step g H) x).state n ∧ (Law.run (step g H) x).state n ≤ hi`
  At or above the point of no return (and ≤ `hi`), the run never falls below its start and never exceeds `hi`.
- **ends_iff_below** (741), theorem.
  `theorem ends_iff_below {g : Nat → Nat} {H y hi x : Nat} (pos : 0 < H + y) (short : Short g H y) (nothing : FromNothing g) (meets : Meets g H y hi) (keeps : Keeps g H hi) (high : x ≤ hi) : (∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y`

Every law above has a **standing** draw `H` (one number for the whole run). Nothing in the ranges read states a run whose draw changes from step to step.

### 1.4 TT (held attempt), Course and Turning, 150-240 and 400-660

Defs (152-199): `structure Course (Way : Type u)` with fields `need low high : Nat`, `alone : Way → Way`, `withLevel : Way → Nat → Way`, `use : Way → Nat`, `giving : Nat → Nat`.
`def left (k : Way) (x : Nat) : Nat := RegimeMargin.step c.giving (c.use k) x` (183): one step under the draw `c.use k` of the current way.
`def step (s : Way × Nat) : Way × Nat := (c.renew s.1 s.2, c.left s.1 s.2)` (186); `def way (s : Way × Nat) (n : Nat) : Way := (Law.orbit c.step s n).1` (196); `def level (s : Way × Nat) (n : Nat) : Nat := (Law.orbit c.step s n).2` (199).
So along a line the draw at step `n` is `c.use (c.way s n)`: a **changing draw**.

- **left_zero** (400). `theorem left_zero (nothing : FromNothing c.giving) (k : Way) : c.left k 0 = 0`
- **left_lt** (406). `theorem left_lt {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) {k : Way} {x : Nat} (use : H ≤ c.use k) (pos : 0 < x) (below : x < H + y) : c.left k x < x`
  One step under any draw ≥ `H`, below `H + y`, lowers a positive level. Docstring caution: "At a standing use this is `RegimeMargin.Adjusted.step_below`" has the direction reversed; it is `step_below`'s third conjunct after weakening `Short g H y` to `Short g (c.use k) y` (also said by lean-reader-1 M5).
- **falls** (425). `theorem falls {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) {s : Way × Nat} (below : s.2 < H + y) : ∀ n, (∀ j, j < n → H ≤ c.use (c.way s j)) → c.level s n + n ≤ s.2 ∨ c.level s n = 0`
  Along a line whose first `n` draws are each ≥ `H`, from below `H + y`: level `+ n ≤` start, or level 0. Prefix premise. Restates, for a changing draw, `Adjusted.orbit_bound`'s third conjunct; proved by its own induction, not through `Amounts.falls_by_stretch` or `Optimum.ends_within`.
- **falls_le** (445). `theorem falls_le {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) {s : Way × Nat} (below : s.2 < H + y) (n : Nat) (uses : ∀ j, j < n → H ≤ c.use (c.way s j)) : c.level s n ≤ s.2` — analogue of `Optimum.level_le_start`.
- **gone** (453). `theorem gone {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) {s : Way × Nat} (below : s.2 < H + y) (uses : ∀ j, j < s.2 → H ≤ c.use (c.way s j)) : c.level s s.2 = 0` — analogue of `Adjusted.ends_below` for a changing draw.
- **used_up_alike** (466), **ends_below_least_use** (486): grammar readings of `gone` (`«迭»`, `«亡»`); not further mapped here.
- **below_stays** (501). `theorem below_stays {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) (least : ∀ k, H ≤ c.use k) (s : Way × Nat) {n : Nat} (below : c.level s n < H + y) (i : Nat) : c.level s (n + i) ≤ c.level s n` — analogue of `Optimum.level_stays_below` / `level_le_start` shifted to `n`.
- **above_of_never_ends** (509). `theorem above_of_never_ends {H y : Nat} (short : Short c.giving H y) (nothing : FromNothing c.giving) (needed : 0 < c.need) (least : ∀ k, H ≤ c.use k) {s : Way × Nat} (endless : ∀ n, c.need ≤ c.level s n) (n : Nat) : H + y ≤ c.level s n` — contrapositive of `gone` at each `n`.
- **Turning** (530), structure (a Prop of hypotheses): `nothing`, `more : ∀ k, ¬ Less k → H₁ ≤ c.use k`, `short₁ : Short c.giving H₁ y₁`, `alone : ∀ k, ¬ Less k → ¬ Less (c.alone k)`, `less : ∀ k, Less k → c.use k = H₂`, `kept : ∀ k x, Less k → Less (c.renew k x)`, `short₂`, `meets : Meets c.giving H₂ y₂ hi`, `keeps : Keeps c.giving H₂ hi`, `least : H₂ ≤ H₁`, `needed : 0 < c.need`, `within : c.need ≤ H₂ + y₂`.
- **Turning.uses_least** (562), **less_onward** (568), **holds** (576):
  `theorem holds (t : Turning c Less H₁ y₁ H₂ y₂ hi) {s : Way × Nat} (less : Less s.1) (low : H₂ + y₂ ≤ s.2) (high : s.2 ≤ hi) (n : Nat) : c.need ≤ c.level s n` — reduces the line, once `Less`, to `RegimeMargin.holds` at standing draw `H₂`.
- **Turning.first_less** (591). `theorem first_less [DecidablePred Less] (s : Way × Nat) (start : ¬ Less s.1) : ∀ n, (∀ j, j ≤ n → ¬ Less (c.way s j)) ∨ ∃ j, j < n ∧ ¬ Less (c.way s j) ∧ Less (c.way s (j + 1))` — a step from not-less to less (not stated to be the first one). Kin to `Amounts.unmarked_or_marked` (506).
- **Turning.goes_on_iff** (609).
  `theorem goes_on_iff [DecidablePred Less] (t : Turning c Less H₁ y₁ H₂ y₂ hi) {s : Way × Nat} (start : ¬ Less s.1) (below : s.2 < H₁ + y₁) (high : s.2 ≤ hi) : (∀ n, c.need ≤ c.level s n) ↔ ∃ j, ¬ Less (c.way s j) ∧ c.Between (c.level s j) ∧ Less (c.withLevel (c.way s j) (c.level s j)) ∧ H₂ + y₂ ≤ c.level s (j + 1)`
  → (615-629): `above_of_never_ends` at `H₂`, then `first_less … s.2`: no turn within `s.2` steps gives `gone` at `H₁`, contradiction; a turn at `j` must be by `withLevel` (else `alone` forbids it).
  ← (630-652): **splits the run at `T := j + 1`** (642, `cases Nat.lt_or_ge n (j + 1)`). Late: `Turning.holds` from `Law.orbit c.step s (j + 1)` and `level_add`. Early: if `level n < need`, `below_stays` at `H₂` (all ways use ≥ `H₂`) says the level is never higher after `n`, contradicting `H₂ + y₂ ≤ level (j+1)` with `need ≤ H₂ + y₂`.
- **Turning.never_ends_iff** (656): the same on the grammar's `«不穷»`.

## 2. Answers

### Q1. Can RegimeMargin's premise be reduced along a run to Optimum's form, or the reverse?

**Forward (RegimeMargin to Optimum): yes, along a run, with one invariant proved first.** Argued here, not checked in Lean.

Take the run's levels `x n := (Law.orbit (Adjusted.step A H) (x₀, r₀) n).1` and set
- `d t := H` (the standing draw; for TT, `d t := c.use (c.way s t)`, any value ≥ `H`),
- `g t := A (x t - H) (Law.orbit … t).2` (for the regime, `g' (x t - H)`; for TT, `c.giving (x t - c.use …)`),
- `r := H - 1`, `m := 1` (or `m := x₀ - n + 1` for `orbit_bound`'s `≤ x - n`, `n ≤ x₀`).

Then:
1. `step : ∀ t, x (t+1) = x t + g t - d t` holds **only with `FromNothing`**. Where `H ≤ x t`, `(x t - H) + g t = x t + g t - H` is arithmetic. Where `x t < H`, RegimeMargin gives `0 + A 0 _`, and Optimum gives `x t + A 0 _ - H`. They agree when `A 0 _ = 0`. Without `FromNothing` (`left_bound`), the identity fails for a constant `d`. It holds for every step if `d t` is the realized draw `x t - (x t - H)`, which is `step_balances`; but then `r < d t` fails once the level drops to `r` or below.
2. `renews : ∀ t, g t ≤ H - 1` needs `g t < H` at **every** `t`. `Short` gives that only below `y`, so the band invariant `x t < H + y` (and `recent < H` in the adjusted case) must already hold along the whole run. This is `Adjusted.orbit_inside` (524), or for a changing draw ≥ `H`, a one-step lemma like TT's `left_lt` iterated. It cannot come from Optimum's `level_le_start`, which assumes `renews` for all `t`, so there is an order of proof: invariant first, then `ends_within`.
3. `over : ∀ t, H - 1 < d t` needs `0 < H`, which is `Adjusted.draw_pos` (449), and `H ≤ d t`.
4. Then `Optimum.ends_within … (m := 1) x₀ (Nat.lt_add_of_pos_left …)` gives `x x₀ < 1`, i.e. `Adjusted.ends_below`'s conclusion, once `Law.run … state` is unfolded to `Law.orbit` (the files use them interchangeably, e.g. 707).

So `Adjusted.ends_below`, `RegimeMargin.ends_below` and TT's `gone` / `falls` are all cases of `Optimum.ends_within` given (i) `FromNothing`, (ii) the band invariant, and (iii) `draw_pos`. `Optimum.ends_within` is already a changing-draw law: `d` is any sequence above a constant `r`, and the constant is on the gift's bound, not on the draw. lean-reader-1 (M5) says "RegimeMargin has no law for a draw that changes from step to step". That is true of RegimeMargin's files, but such a law exists one import below it, in Optimum.

TT's `falls` has only a prefix premise (`∀ j, j < n → H ≤ c.use …`). `ends_within` needs `renews`/`over` for all `t`, and its proof uses steps only below `t`. A stretch form with premises restricted to `t < T` (like `reread_kept_iff`'s `before`, or `reread_deadline_iff`'s `draws`) is not in the ranges read; Optimum 3548-3588 have prefix `renews` for other laws (seen by grep, not read).

At a deeper level, both `Optimum.ends_within` (2310) and `Adjusted.orbit_bound` (557) already reduce to **`Amounts.falls_by_stretch`**. They differ in two ways:
- **What counts as lost.** Optimum uses `drawnAt x g`; RegimeMargin uses `p.1 - (p.1 - H)`. Both are the realized draw, not `d`/`H`.
- **How "loses at least one" is gated.** Optimum uses "the level stood at `m` or above before `t`", obtained from never-rising. RegimeMargin uses `unmarked_or_marked` on "positive", plus `from_zero`. `Amounts.unmarked_within` (522), which gates loss by a decided mark, is the existing law closest to both gatings; its bound is `q S` (for `m = 1`, that is `ends_below`'s `x`).

So the shared core already exists. What does not exist is one draw law, stated on Optimum's step, whose gift bound is required only inside a band the run is shown to keep.

**Reverse (Optimum to RegimeMargin): no, in general.** Optimum's `g` and `d` are arbitrary time sequences. RegimeMargin's step has a fixed draw `H` and a giving that is a function of what is left (and, adjusted, of the recent giving). A time-varying `d` is not a `RegimeMargin.step` or `Adjusted.step`. Only the special case `d t = H` and `g t = g'(x t - H)` with `FromNothing` lies in both. It also runs against the import order: Optimum cannot use RegimeMargin.

**Answer to "one changing-draw law with both as cases".** `Optimum.ends_within` is that law for both `Adjusted.ends_below` and itself (trivially). The proof obligations are steps 1-3 above, and the invariant (`orbit_inside`) stays a separate RegimeMargin lemma. The law is not yet applied that way anywhere in the files read (RegimeMargin never calls `ends_within`; grep found no use).

### Q2. Is `Turning.goes_on_iff` an instance of `reread_kept_iff`? Does its proof split a run at T?

**The split: yes.** The ← direction splits at `T := j + 1` (TT 642: `cases Nat.lt_or_ge n (j + 1)`), as `reread_kept_iff` splits at `T` (Optimum 2386: `match Nat.lt_or_ge t T`). The late branch iterates a keeping law from `T` (TT: `Turning.holds`; Optimum: induction on `keeps`). The early branch differs in form. Optimum shows `x T ≤ x t` by a never-rising chain under gift ≤ `r` < draw. TT argues by contradiction with `below_stays` at the lesser draw `H₂`: once below `need ≤ H₂ + y₂`, it is never higher. That is a never-rising law, but conditioned on being below the point of no return, not on gift ≤ `r` < draw.

**Instance: not as stated; the ← half is close to one, the → half is not.**
- `reread_kept_iff`'s `T` is a fixed parameter, and its right side is the same bound `m ≤ x T`. `goes_on_iff`'s right side is an existential over `j`. Its bound at `j + 1` is `H₂ + y₂`, not `need`, and it adds conditions on the way (`¬ Less`, `Between`, `Less (withLevel …)`).
- ← could be had from `reread_kept_iff` at `m := H₂ + y₂`, `T := j + 1`, then `t.within` to get down to `need`. That needs, for `t < T`, Optimum's step and gift ≤ `r` < draw with `d t := c.use (c.way s t) ≥ H₁`, `r := H₁ - 1`, gift `c.giving (level t - use)` (as in Q1, with `FromNothing` and the band invariant `level t < H₁ + y₁` from `falls_le`). It also needs, for `t ≥ T`, `keeps : H₂ + y₂ ≤ x t → H₂ + y₂ ≤ x (t+1)`. That step holds only with `x t ≤ hi` too (`RegimeMargin.Keeps`, `Meets` up to `hi`), so a separate invariant `level t ≤ hi` for `t ≥ T` must be proved first. `reread_kept_iff`'s `keeps` has no such side condition. One more point: reread's before-`T` premise uses the *greater* draw `H₁`, while TT's early branch uses `H₂` for all ways (`uses_least`). Both are available from `Turning`.
- → is not an instance. `reread_kept_iff`'s → is trivial (`kept T`). `goes_on_iff`'s → needs `above_of_never_ends`, the search `first_less` and the `alone` field. lean-reader-1 (H4) adds that the `Between`/`withLevel` conjuncts follow from `alone` and `renew`'s definition, not from dynamics.

So `goes_on_iff` = (an existential search for `T`) + (a `reread_kept_iff`-shaped ← at `m := H₂ + y₂`, with the `hi` invariant) + (the contrapositive of `gone`).

## 3. Cautions (duplicates, collisions, falsity)

- TT's `falls`, `falls_le`, `gone`, `below_stays` restate, for a changing draw, what `Optimum.ends_within`, `level_le_start` and `level_stays_below` already give (via Q1), and also re-prove `Amounts.falls_by_stretch`'s content by a hand induction.
- TT's `left_lt` is `Adjusted.step_below`'s third conjunct (weakened `Short`); its docstring has the direction reversed.
- `first_less` is kin to `Amounts.unmarked_or_marked`. Neither states "first"; TT's docstring says "a first step".
- Name collisions. `step`, `FromNothing` and `Keeps` each exist at RegimeMargin top level and in `Adjusted`, with different types. `holds` exists as `RegimeMargin.holds`, `Adjusted.holds` and TT's `Turning.holds`. `ends_within` exists as `Optimum.ends_within`, `Carries.ends_within` and `Web.ByPassing.ends_within` (Reserve, PatternPassing, MapInstances; seen by grep), plus `Reserve.ends_within_on` and `ends_within_from`. `never_rises` exists in `Optimum` and in Reserve (903, a different law). `ends_below` exists twice in RegimeMargin. The letters `x`/`y` in `Amounts.falls_by_stretch` mean lost/gained, while `x` is the level in Optimum.
- Falsity traps. Optimum's step equals the regime step only under `FromNothing`. With `d := H` and no `FromNothing`, the identity is false at levels below `H`. `renews` for all `t` is false without the band invariant (`Short` covers only below `y`). `ends_within` needs `0 < m`. `reread_kept_iff`'s `keeps` cannot be discharged from `RegimeMargin.holds` without the `≤ hi` invariant.
- Docstring overclaims. `reread_kept_iff`'s mention of an optimum is not in the statement. TT `left_lt`'s "this is `step_below`" is reversed.

## 4. Not read or not settled

- Optimum outside 2228-2445: in particular 2445-2594 (rest of `Levels`), the uses of `ends_within` at 2495 and 2684, and the prefix-premise lemmas at 3548-3588. Whether a stretch form of `ends_within` exists there is not settled.
- RegimeMargin outside the ranges named: `Adjusted.holds`, `Adjusted.ends_iff_below`, `rises_by_draw` (793 per lean-reader-1), `Drawn` (1804), `Coupled`, and the rest of the file after 760. Whether `Drawn` (linearly ordered amounts) already generalizes the draw is not checked.
- `Law.run`/`Law.orbit` definitions (the Law module was not located by the grep I ran). That `(Law.run f s).state n` unfolds to `Law.orbit f s n` is inferred from its use at RegimeMargin 707.
- TT 1-150, 240-400 and 660-734 (header, grammar section, witnesses) were not read beyond the `Course` definitions.
- None of the reductions in §2 were checked in Lean. They are argued from the statements.
