Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# The stock under a draw: RegimeMargin, DrawHistory, RunTurns, BandRest (ReadingSchedule skimmed)

Read-only map for the TT design. Nothing was built or run. PKG =
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Line numbers are those of the files as read on 12 November 2026 (main at 372705add). "def" is a
definition; a `Prop`-valued def is used only as a hypothesis; "theorem" is proved. Statements are
copied; the proof term after `:=` is left out.

The held attempt is `/Users/ren/theories/tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` (734
lines; its line numbers below are the current file's, which differ from those the reader quotes).

## 1. Inventory

### 1.1 RegimeMargin.lean: the step and its premises (namespace `Becoming.RegimeMargin`)

Imports (lines 1-5): `Becoming.Recurrence`, `Becoming.Lasting`, `Becoming.LastChange`,
`Becoming.Optimum`, `Becoming.BandRest`.

| line | kind | exact statement | what it says |
|---|---|---|---|
| 249 | def | `def step (g : Nat → Nat) (H x : Nat) : Nat := (x - H) + g (x - H)` | One step at level `x` under a standing draw `H`: the draw takes first, in natural subtraction, and `g` gives from what is left. |
| 252 | def | `def FromNothing (g : Nat → Nat) : Prop := g 0 = 0` | Nothing is given from nothing. |
| 255 | def | `def Short (g : Nat → Nat) (H y : Nat) : Prop := ∀ z, z < y → g z < H` | Giving falls short of `H` at every amount left below `y`. Vacuous at `y = 0`. |
| 258 | def | `def Root (g : Nat → Nat) (H y : Nat) : Prop := H ≤ g y ∧ Short g H y` | `y` is the least amount left at which giving meets `H`. |
| 262 | def | `def Meets (g : Nat → Nat) (H y hi : Nat) : Prop := ∀ z, y ≤ z → z + H ≤ hi → H ≤ g z` | Giving meets `H` at every amount left `z` from `y` with `z + H ≤ hi`. |
| 265 | def | `def Keeps (g : Nat → Nat) (H hi : Nat) : Prop := ∀ x, x ≤ hi → step g H x ≤ hi` | The step keeps every level up to `hi` within `hi`. |
| 268 | def | `def Gated (g : Nat → Nat) (m : Nat) : Prop := ∀ z, z < m → g z = 0` | Giving is nothing below a need `m`. |
| 271 | def | `def SubadditiveAbove (g : Nat → Nat) (m : Nat) : Prop :=` `∀ p q, g (m + (p + q)) ≤ g (m + p) + g (m + q)` | Subadditive above `m`. |
| 275 | def | `def AtMost (g : Nat → Nat) (Y : Nat) : Prop := ∀ z, g z ≤ Y` | Giving bounded by `Y`. |
| 278 | theorem | `theorem step_ge (g : Nat → Nat) (H x : Nat) : x ≤ step g H x + H` | A step lowers a level by at most the draw. |
| 780 | def | `def Lowered (g' g : Nat → Nat) : Prop := ∀ z, g' z ≤ g z` | One giving nowhere above another. |

There is no lemma that `Short` is monotone in the draw (`Short g H y → H ≤ H' → Short g H' y`);
it is used inline nowhere either (grep for `Short.`/`short_mono`: nothing).

### 1.2 RegimeMargin.lean: `Adjusted` (state = level and recent giving), lines 294-700

| line | kind | exact statement | what it says |
|---|---|---|---|
| 299 | def | `def step (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Nat × Nat :=` `(p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2)` | Adjusted step: giving `A` of what is left and of the recent giving; the new giving is the next recent giving. Standing draw `H`. |
| 304 | def | `def StaysShort (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=` `∀ e r, r < H → g e < H → A e r < H` | Where recent and regime giving both fall short of `H`, so does `A`. |
| 309 | def | `def StaysMet (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=` `∀ e r, H ≤ r → H ≤ g e → H ≤ A e r` | Dual, for meeting. |
| 313 | def | `def RestsAtDraw (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=` `∀ e, A e H = H ↔ g e = H` | `A` rests at the draw exactly where `g` gives the draw. |
| 317 | def | `def FromNothing (A : Nat → Nat → Nat) : Prop := ∀ r, A 0 r = 0` | Adjusted nothing-from-nothing. Same short name as 1.1's `FromNothing`, different type. |
| 321 | def | `def Keeps (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=` `∀ x r, x ≤ hi → H ≤ r → (step A H (x, r)).1 ≤ hi` | Band kept where the recent giving meets the draw. |
| 325 | def | `def Between (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=` `∀ e r, (r ≤ A e r ∧ A e r ≤ g e) ∨ (g e ≤ A e r ∧ A e r ≤ r)` | `A` lies between recent and regime giving. |
| 329 | def | `def Settles (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=` `∀ e r, A e r = r → r = g e` | `A` rests only at the regime's giving. |
| 336 | theorem | `theorem orbit_regime (g : Nat → Nat) (H : Nat) (p : Nat × Nat) :` `∀ n, (Law.orbit (step (fun e _ => g e) H) p n).1 = Law.orbit (RegimeMargin.step g H) p.1 n` | The regime is the adjusted case reading what is left alone: the level of the adjusted run is the regime run, whatever the start's recent giving. (A lumping: states alike in level stay alike in level under this `A`.) |
| 341 | theorem | `theorem regime_staysShort (g : Nat → Nat) (H : Nat) : StaysShort (fun e _ => g e) g H` | Bridge. |
| 344 | theorem | `theorem regime_staysMet (g : Nat → Nat) (H : Nat) : StaysMet (fun e _ => g e) g H` | Bridge. |
| 347 | theorem | `theorem regime_fromNothing {g : Nat → Nat} (nothing : RegimeMargin.FromNothing g) :` `FromNothing (fun e _ => g e)` | Bridge. |
| 351 | theorem | `theorem regime_keeps {g : Nat → Nat} {H hi : Nat} (keeps : RegimeMargin.Keeps g H hi) :` `Keeps (fun e _ => g e) H hi` | Bridge. |
| 356 / 363 / 371 | theorem | `Between.staysShort … (between : Between A g) (H : Nat) : StaysShort A g H`; `Between.staysMet … : StaysMet A g H`; `Between.restsAtDraw … (between : Between A g) (settles : Settles A g) (H : Nat) : RestsAtDraw A g H` | Between gives the side conditions. |
| 398 | theorem | `theorem rest_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat} (rests : RestsAtDraw A g H)` `(atLeast : H ≤ x) : step A H (x, r) = (x, r) ↔ r = H ∧ RegimeMargin.step g H x = x` | At or above the draw a fixed state is the regime's fixed level with recent giving `H`. |
| 449 | theorem | `theorem draw_pos {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (below : x < H + y) :` `0 < H` | Short plus a level below `H + y` forces a positive draw. |
| 461 | theorem | `theorem left_falls {d a H : Nat} (gives : a < H) : d + a - H ≤ d - 1` | What a draw leaves falls by one where giving is short (arithmetic). |
| 474 | theorem | `theorem left_below {H y x : Nat} (ypos : 0 < y) (below : x < H + y) : x - H < y` | Below the point, what is left is below `y`. |
| 485 | theorem | `theorem step_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)` `(stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :` `(step A H (x, r)).1 < H + y ∧ (step A H (x, r)).2 < H ∧ (0 < x → (step A H (x, r)).1 < x)` | One step below the point, recent giving short: stays below the point, recent giving stays short, and a positive level strictly falls. One step only, one standing `H`. |
| 507 | theorem | `theorem from_zero {A : Nat → Nat → Nat} (H : Nat) (nothing : FromNothing A) {p : Nat × Nat}` `(zero : p.1 = 0) : ∀ k, (Law.orbit (step A H) p k).1 = 0` | Nothing stays nothing (standing draw). |
| 517 | theorem | `theorem step_balances (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :` `(step A H p).1 + (p.1 - (p.1 - H)) = p.1 + A (p.1 - H) p.2` | Balance of one step; holds for any `H`, so for a per-step draw too. |
| 524 | theorem | `theorem orbit_inside … (short : Short g H y) (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :` `∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H` | The run stays below the point with recent giving short. |
| 539 | theorem | `theorem orbit_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)` `(stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :` `∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧` `(Law.orbit (step A H) (x, r) n).1 ≤ x - n` | After `n` steps the level is at most `x - n`. Proved by `Amounts.falls_by_stretch` and `Amounts.unmarked_or_marked` (rest by balance), not by its own induction. |
| 572 | theorem | `theorem ends_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)` `(stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :` `((Law.run (step A H) (x, r)).state x).1 = 0` | Below the point with recent giving short: nothing after `x` steps. |
| 580 | theorem | `theorem stays_ended … (rshort : r < H)` `(k : Nat) : ((Law.run (step A H) (x, r)).state (x + k)).1 = 0` | And stays nothing. |
| 590 | theorem | `theorem left_bound … (short : Short g H y) (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) :` `∀ n, … ∧ … ∧ (Law.orbit (step A H) (x, r) n).1 - H ≤ x - H - n` | Without `FromNothing`: what the draw leaves falls by `n`. |
| 614 | theorem | `theorem taken_whole … (ypos : 0 < y) (below : x < H + y) (rshort : r < H) (n : Nat)` `(late : x - H ≤ n) : ((Law.run (step A H) (x, r)).state n).1 ≤ H` | Without `FromNothing`: the draw takes all from step `x - H` on. |
| 630 | theorem | `theorem step_holds … (meets : Meets g H y hi) (stays : StaysMet A g H) (low : H + y ≤ x) (high : x ≤ hi)` `(met : H ≤ r) : x ≤ (step A H (x, r)).1 ∧ H ≤ (step A H (x, r)).2` | One step at or above the point does not lower the level. |
| 645 | theorem | `theorem holds {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (meets : Meets g H y hi)` `(stays : StaysMet A g H) (keeps : Keeps A H hi) (low : H + y ≤ x) (high : x ≤ hi)` `(met : H ≤ r) :` `∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ ((Law.run (step A H) (x, r)).state n).1 ≤ hi ∧` `H ≤ ((Law.run (step A H) (x, r)).state n).2` | At or above the point, recent giving meeting the draw, within the band: never below the start. |
| 661 | theorem | `theorem holds_from … (meets : ∀ z, y ≤ z → H ≤ g z) (stays : StaysMet A g H) (low : H + y ≤ x) (met : H ≤ r) :` `∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ H ≤ ((Law.run (step A H) (x, r)).state n).2` | Same with no top. |
| 676 | theorem | `theorem ends_iff_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (pos : 0 < H + y)` `(short : Short g H y) (staysShort : StaysShort A g H) (nothing : FromNothing A)` `(meets : Meets g H y hi) (staysMet : StaysMet A g H) (keeps : Keeps A H hi) (high : x ≤ hi)` `(side : r < H ↔ x < H + y) :` `(∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y` | The point is exact on the state, under the strong premise `side` tying the recent giving's side to the level's. |
| 694 | theorem | `Between.ends_iff_below … (between : Between A g) (pos : 0 < H + y) (short : Short g H y) (nothing : FromNothing A) (meets : Meets g H y hi) (keeps : Keeps A H hi) (high : x ≤ hi) (side : r < H ↔ x < H + y) :` `(∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y` | Same for Between. |

### 1.3 RegimeMargin.lean: the regime's laws (lines 705-943)

| line | kind | exact statement | what it says |
|---|---|---|---|
| 705 | theorem | `theorem ends_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y)` `(nothing : FromNothing g) (below : x < H + y) : (Law.run (step g H) x).state x = 0` | Below the point of no return, nothing after as many steps as the level stood. Proof: `Adjusted.orbit_regime` + `Adjusted.ends_below` at `r := 0`, with `draw_pos` for `0 < H`. |
| 712 | theorem | `theorem stays_ended {g : Nat → Nat} {H y x : Nat} (short : Short g H y)` `(nothing : FromNothing g) (below : x < H + y) (k : Nat) :` `(Law.run (step g H) x).state (x + k) = 0` | Stays nothing. |
| 721 | theorem | `theorem ends_beyond_giving {g : Nat → Nat} {H : Nat} (beyond : ∀ z, g z < H)` `(nothing : FromNothing g) (x : Nat) : (Law.run (step g H) x).state x = 0` | A draw beyond all giving ends every level (case `y := x + 1`). |
| 730 | theorem | `theorem holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (keeps : Keeps g H hi)` `(low : H + y ≤ x) (high : x ≤ hi) :` `∀ n, x ≤ (Law.run (step g H) x).state n ∧ (Law.run (step g H) x).state n ≤ hi` | At or above the point, within a kept band: never below the start, never above `hi`. |
| 741 | theorem | `theorem ends_iff_below {g : Nat → Nat} {H y hi x : Nat} (pos : 0 < H + y) (short : Short g H y)` `(nothing : FromNothing g) (meets : Meets g H y hi) (keeps : Keeps g H hi) (high : x ≤ hi) :` `(∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y` | The point is exact on levels up to `hi`. |
| 764 | theorem | `theorem root_above_need {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)` `(meets : H ≤ g y) : m ≤ y` | |
| 773 | theorem | `theorem beyond_draw_iff {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)` `(root : Root g H y) : m < y ↔ g m < H` | |
| 783 | theorem | `theorem root_mono {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y) (root' : Root g' H' y')` `(le : H ≤ H') (lowered : Lowered g' g) : y ≤ y'` | A larger draw with no more giving has no lower root. |
| 793 | theorem | `theorem rises_by_draw {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y)` `(root' : Root g' H' y') (le : H ≤ H') (lowered : Lowered g' g) : H + y + (H' - H) ≤ H' + y'` | The point rises at least by the difference of the draws. The only theorem relating the points of no return of two draws. |
| 802 / 808 | theorem | `lowered_raises … (root : Root g H y) (root' : Root g' H y') (lowered : Lowered g' g) : y ≤ y'`; `lowered_raises_strictly … : y < y' ↔ g' y < H` | Same draw, lowered giving. |
| 822 | theorem | `rises_superadditive … (r : Root g (H₁ + H₂) (m + c)) : a + b ≤ c + 1` | Joint draw, superadditive up to one. |
| 863 | theorem | `theorem orbit_ge (g : Nat → Nat) (H x : Nat) : ∀ n, x ≤ (Law.run (step g H) x).state n + H * n` | Falls at most `H` a step. |
| 875 | theorem | `theorem not_before (g : Nat → Nat) {H x b n : Nat} (early : b + H * n ≤ x) :` `b ≤ (Law.run (step g H) x).state n` | |
| 880 / 890 / 910 | theorem | `step_falls_by … (most : AtMost g Y) (yle : Y ≤ H) (ge : H ≤ x) : step g H x + (H - Y) ≤ x`; `falls_or_bound`; `falls_within {g : Nat → Nat} {H Y b x n : Nat} (most : AtMost g Y) (yle : Y ≤ H)` `(hb : H ≤ b) (late : x < b + (H - Y) * n) :` `∃ k, k ≤ n ∧ (Law.run (step g H) x).state k < b` | Time to break. |
| 920 | def | `def below (f : Nat → Bool) : Nat → Bool` (`| 0 => true | n + 1 => f n && below f n`) | Finite check. |
| 930 | theorem | `theorem short_of_below {g : Nat → Nat} {H y : Nat}` `(check : below (fun z => decide (g z < H)) y = true) : Short g H y` | Decides `Short` on witnesses. |
| 934 | theorem | `theorem meets_of_below {g : Nat → Nat} {H y hi : Nat}` `(check : below (fun z => !(decide (y ≤ z) && decide (z + H ≤ hi)) || decide (H ≤ g z))` `(hi + 1) = true) : Meets g H y hi` | Decides `Meets`. |
| 941 | theorem | `theorem keeps_of_below {g : Nat → Nat} {H hi : Nat}` `(check : below (fun x => decide (step g H x ≤ hi)) (hi + 1) = true) : Keeps g H hi` | Decides `Keeps`. |

### 1.4 RegimeMargin.lean: witnesses

| line | kind | exact statement | what it says |
|---|---|---|---|
| 948 | def | `def giving (z : Nat) : Nat := min (2 * z) (z + 2)` (`Concave`) | |
| 953 | theorem | `theorem roots : Root giving 4 2 ∧ Root giving 8 6` | Joint draw raises the point more than the sum. |
| 961 | def | `def giving (z : Nat) : Nat := min z (8 - z)` (`Peaked`) | Peak 4 at 4, nothing at 8. |
| 963 | theorem | `theorem fromNothing : FromNothing giving` | |
| 980 | theorem | `theorem atMost : AtMost giving 4` | |
| 990 | theorem | `theorem each_holds {x : Nat} (low : 6 ≤ x) (high : x ≤ 8) (n : Nat) :` `x ≤ (Law.run (step giving 3) x).state n` | Under a draw of 3 levels 6-8 hold. |
| 996 | theorem | `theorem together_ends (x : Nat) : (Law.run (step giving (3 + 3)) x).state x = 0` | Under 6 every level ends. |
| 1005 | def | `def giving (z : Nat) : Nat := if z < 2 then 0 else 4` (`Crossing`) | Gated at two. |
| 1008 | def | `def toward (e r : Nat) : Nat :=` `if r < giving e then r + 1 else if giving e < r then r - 1 else r` | Adjustment one unit a step toward the regime. |
| 1011 / 1013 / 1016 | theorem | `fromNothing : FromNothing giving`; `root : Root giving 3 2`; `meets_from : ∀ z, 2 ≤ z → 3 ≤ giving z` | |
| 1021 / 1041 | theorem | `toward_between : Adjusted.Between toward giving`; `toward_settles : Adjusted.Settles toward giving` | |
| 1062 | theorem | `theorem crosses :` `Root giving 3 2 ∧ Adjusted.Between toward giving ∧ Adjusted.Settles toward giving ∧` `(Law.run (step giving 3) 4).state 4 = 0 ∧ (∀ n, 5 ≤ (Law.run (step giving 3) 5).state n) ∧` `(∀ n, 7 ≤ ((Law.run (Adjusted.step toward 3) (4, 6)).state (n + 2)).1) ∧` `(∀ n, ((Law.run (Adjusted.step toward 3) (5, 0)).state (n + 2)).1 = 0)` | Same level, different fates by the recent giving: the level (one class) does not tell the end; the recent giving (another coordinate) does. A witness of (b) in the model. |
| 1085 | theorem | `theorem frozen_stays :` `Adjusted.Between (fun _ r => r) giving ∧` `(∀ n, (Law.run (Adjusted.step (fun _ r => r) 3) (4, 3)).state n = (4, 3)) ∧` `(Law.run (step giving 3) 4).state 4 = 0` | `Settles` cannot be dropped. |
| 1403 / 1414 / 1428 | theorem | `giving_rises : ∀ a b, a ≤ b → giving a ≤ giving b`; `climbs : ∀ n, Law.orbit (step giving 3) 5 n = n + 5`; `rises_without_rest : …` | No band, no rest. |

### 1.5 RegimeMargin.lean: rest, order, thresholds in the plane (lines 1112-1780, summary)

| line | kind | exact statement | what it says |
|---|---|---|---|
| 1112 | theorem | `theorem step_mono {g : Nat → Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b) (H : Nat) {a b : Nat}` `(le : a ≤ b) : step g H a ≤ step g H b` | Rising giving: the step keeps order. |
| 1121 | theorem | `theorem rests_within {g : Nat → Nat} {H hi x : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)` `(keeps : Keeps g H hi) (high : x ≤ hi) :` `∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run (step g H) x) N` | The run comes to rest within `hi` steps. Its docstring's "within `hi - x` … within `x`" is not in the statement. |
| 1129 | def | `def Rises (A : Nat → Nat → Nat) : Prop := ∀ e e' r r', e ≤ e' → r ≤ r' → A e r ≤ A e' r'` | |
| 1136 | def | `def Band (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=` `∀ x r, x ≤ hi → r ≤ hi → (step A H (x, r)).1 ≤ hi` | |
| 1142 | def | `def AtRest (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=` `(p.2 = H ∧ H ≤ p.1 ∧ RegimeMargin.step g H p.1 = p.1) ∨ (p.1 < H ∧ p.1 = p.2 ∧ A 0 p.2 = p.2)` | |
| 1182 / 1188 | theorem | `run_rises … (rises : Rises A) {H : Nat} {p : Nat × Nat} (first : Below p (step A H p)) : ∀ n, Below (Law.orbit (step A H) p n) (Law.orbit (step A H) p (n + 1))`; `run_falls` dually | One-way runs. |
| 1303 | theorem | `theorem fixed_iff … (restsAt : RestsAtDraw A g H) : step A H p = p ↔ AtRest A g H p` | |
| 1367 | theorem | `theorem comes_to_rest … (rises : Rises A) (restsAt : RestsAtDraw A g H) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :` `∃ N, N ≤ hi + hi + hi + 3 ∧ LastChange.StillFrom (Law.run (step A H) (x, r)) N ∧` `AtRest A g H ((Law.run (step A H) (x, r)).state N)` | |
| 1497 | def | `def leading (b : Nat → Bool) : Nat → Nat` | Leading run of `true`. |
| 1550 | theorem | `theorem leading_exact {P : Nat → Prop} {d : Nat → Bool} {hi : Nat}` `(down : ∀ a b, b ≤ hi → P b → a ≤ b → P a) (exact : ∀ a, a ≤ hi → (P a ↔ d a = true)) :` `∀ a, a ≤ hi → (P a ↔ a < leading d (hi + 1))` | The one law of exact thresholds. |
| 1575 | theorem | `theorem leading_eq {d : Nat → Bool} {hi t : Nat} (exact : ∀ a, a ≤ hi → (a < t ↔ d a = true))` `(reach : t ≤ hi + 1) : leading d (hi + 1) = t` | |
| 1590 | def | `def RestsBelow (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=` `∃ N, LastChange.StillFrom (Law.run (step A H) p) N ∧ ((Law.run (step A H) p).state N).1 < H` | |
| 1599 | def | `def threshold (A : Nat → Nat → Nat) (H hi r : Nat) : Nat := leading (falling A H hi r) (hi + 1)` | |
| 1643 | theorem | `theorem falls_iff_below … (rises : Rises A) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :` `RestsBelow A H (x, r) ↔ x < threshold A H hi r` | |
| 1655 | theorem | `theorem threshold_falls … (le : r ≤ r') (given : r' ≤ hi) :` `threshold A H hi r' ≤ threshold A H hi r` | More recent giving, lower threshold. |
| 1670 | theorem | `fates …` (see file) | Fate by threshold. |
| 1698 | theorem | `theorem threshold_regime {g : Nat → Nat} {H y hi r : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)` `(short : Short g H y) (nothing : FromNothing g) (meets : Meets g H y hi)` `(keeps : Keeps g H hi) (given : r ≤ hi) (reach : H + y ≤ hi + 1) :` `Adjusted.threshold (fun e _ => g e) H hi r = H + y` | The regime's threshold is `H + y`. |
| 1762 | theorem | `Notch.no_threshold` | Rising giving cannot be dropped. |
| 1797-2058 | `Drawn` | `structure Drawn (V : Type) extends Amounts V`; `Drawn.step`, `climbs_or_sinks` (1886), `run_shape` (1998), `rest_iff` (1938), `still_iff` (2024), `whole_run` (2053) | Adjusted step in any ordered amounts; runs turn at most once (level and recent giving). Standing draw. |
| 2071-3683 | `Coupled`, `Coupled.Indexed`, `Recent` | `Coupled.step`, `Indexed.step`, `DependsOn` (2127), `drains` (2163), `ends_after` (2173), `ends_downstream` (2210), `Pointwise` (2437), `step_alike` (2445), `run_alike` (2469), `ends_alike` (2475), `Indexed.threshold` (2672), `Indexed.ends_iff_below` (2687), `Indexed.threshold_falls` (2701), `Recent.adjusted` (3072), `Momentum.threshold_falls_with_recent` (3147), `Coupled.ends_iff_below` (3306), `Coupled.threshold_falls` (3319), `first_regime` (3406), `MutualActivation.saves` (3465) | A condition's point of no return as a falling function of what stands with it (another class tells). All draws standing in time (`H : ι → V` indexed by condition, not by step). |

Exact statements of two Coupled laws a designer may want:

- 2173: `theorem ends_after {G : ι → (ι → Nat) → Nat} {H : ι → Nat} {i j : ι} (depends : DependsOn Drawn.whole G i j)`
  `{s : ι → Nat} {N : Nat} (within : ∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) j ≤ H j) :`
  `(∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) i =`
  `(Law.run (step Drawn.whole G H) s).state N i - H i * k) ∧`
  `(0 < H i → ∀ k, (Law.run (step Drawn.whole G H) s).state`
  `(N + (Law.run (step Drawn.whole G H) s).state N i + k) i = 0)`
  — once the partner stays within its draw, the dependent falls by exactly its draw a step and is
  nothing within its level's count: "what would bring the difference is itself running out" in the
  pair form (d), at a standing draw.
- 3465: `theorem saves :`
  `Drawn.whole.Rises giving ∧ Band Drawn.whole giving giving 1 1 2 ∧`
  `Ends Drawn.whole giving giving 1 1 Prod.fst (2, 0) ∧`
  `¬ Ends Drawn.whole giving giving 1 1 Prod.fst (2, 2) ∧`
  `threshold giving giving 1 1 2 0 = 3 ∧ threshold giving giving 1 1 2 2 = 2`
  — the same own level (2) ends or holds by the partner's level.

### 1.6 DrawHistory.lean (namespace `Becoming.DrawHistory`, imports only `Becoming.RegimeMargin`)

| line | kind | exact statement | what it says |
|---|---|---|---|
| 50 | def | `def underDraws (g : Nat → Nat) (Hs : Nat → Nat) (x : Nat) : Nat → Nat` `| 0 => x` `| t + 1 => RegimeMargin.step g (Hs t) (underDraws g Hs x t)` | The regime's level under a draw schedule `Hs`. Plain recursion, not a `Law.run`. Scalar giving only (no adjusted version). |
| 55 | theorem | `theorem to_inflow {g : Nat → Nat} {H x : Nat} (whole : x ≤ H) : RegimeMargin.step g H x = g 0` | A level the draw takes whole becomes the inflow. |
| 61 | theorem | `theorem inflow_rests {g : Nat → Nat} {H : Nat} (atLeast : g 0 ≤ H) :` `RegimeMargin.step g H (g 0) = g 0` | |
| 66 | theorem | `theorem inflow_stays {g : Nat → Nat} {H : Nat} (atLeast : g 0 ≤ H) :` `∀ n, Law.orbit (RegimeMargin.step g H) (g 0) n = g 0` | |
| 74 | theorem | `theorem inflow_kept {g : Nat → Nat} {Hs : Nat → Nat} {x T : Nat}` `(atLeast : ∀ t, T ≤ t → g 0 ≤ Hs t) (atInflow : underDraws g Hs x T = g 0) :` `∀ k, underDraws g Hs x (T + k) = g 0` | Under any schedule, draws at least the inflow keep a level at the inflow. A changing-draw law. |
| 85 | theorem | `theorem leaving_needs_a_lower_draw {g : Nat → Nat} {Hs : Nat → Nat} {x T : Nat}` `(atInflow : underDraws g Hs x T = g 0) :` `∀ k, underDraws g Hs x (T + k) ≠ g 0 → ∃ j, j < k ∧ Hs (T + j) < g 0` | Leaving the inflow needs some draw below the inflow. A necessary condition only; not recovery (its header says so). |
| 101 | theorem | `theorem inflow_from {g : Nat → Nat} {H x m : Nat} (inflowBelow : g 0 ≤ H)` `(low : Law.orbit (RegimeMargin.step g H) x m ≤ H) :` `∀ k, Law.orbit (RegimeMargin.step g H) x (m + 1 + k) = g 0` | |
| 112 | theorem | `theorem collapses {g : Nat → Nat} {H hi x : Nat} (above : ∀ z, z ≤ hi → g z < H) (high : x ≤ hi) :` `∀ n, x - H + 1 ≤ n → Law.orbit (RegimeMargin.step g H) x n = g 0` | Standing draw above all giving up to `hi`: the inflow from step `x - H + 1`. Proof uses `Adjusted.taken_whole` via `orbit_regime`. |
| 129 | theorem | `theorem two_levels {g : Nat → Nat} {H y hi x : Nat} (meets : RegimeMargin.Meets g H y hi)` `(keeps : RegimeMargin.Keeps g H hi) (atLeast : g 0 ≤ H) (low : H + y ≤ x) (high : x ≤ hi) :` `(∀ n, x ≤ Law.orbit (RegimeMargin.step g H) x n) ∧` `∀ n, Law.orbit (RegimeMargin.step g H) (g 0) n = g 0` | Held level and inflow rest under one draw. |
| 136 | theorem | `theorem underDraws_constant {g : Nat → Nat} {Hs : Nat → Nat} {H x T : Nat}` `(same : ∀ t, t < T → Hs t = H) :` `∀ n, n ≤ T → underDraws g Hs x n = Law.orbit (RegimeMargin.step g H) x n` | The bridge from a schedule's constant prefix to the standing run. At `Hs := fun _ => H`, `T := n` it identifies `underDraws g (fun _ => H) x n` with the standing run: the bridge that would make `ends_below` a case of a schedule law. |
| 149 | theorem | `theorem history_decides {g : Nat → Nat} {Hs : Nat → Nat} {H H' y hi x T : Nat}` `(above : ∀ z, z ≤ hi → g z < H') (atLeast : g 0 ≤ H) (long : x - H' + 1 ≤ T) (high : x ≤ hi)` `(raised : ∀ t, t < T → Hs t = H') (back : ∀ t, T ≤ t → Hs t = H)` `(meets : RegimeMargin.Meets g H y hi) (keeps : RegimeMargin.Keeps g H hi) (low : H + y ≤ x) :` `(∀ k, underDraws g Hs x (T + k) = g 0) ∧ ∀ n, x ≤ Law.orbit (RegimeMargin.step g H) x n` | Raise above all giving long enough, return: the inflow for ever; under `H` all along the level holds. Lowering the draw too late does not bring the level back. |
| 162 | theorem | `theorem histories_differ … (separate : g 0 < x) :` `∀ k, underDraws g Hs x (T + k) < Law.orbit (RegimeMargin.step g H) x (T + k)` | Hysteresis. |
| 177-266 | `Loop` | `giving`, `below_four`, `meets_two`, `meets_three`, `keeps_two`, `keeps_three`, `draws`, `two_paths` (247), `bounds` (259) | Witness. |

What DrawHistory proves about a draw that changes from step to step, exactly: `underDraws` (50);
`inflow_kept` (74, draws at least the inflow keep the inflow); `leaving_needs_a_lower_draw` (85);
`underDraws_constant` (136, constant prefix equals the standing run); `history_decides` (149) and
`histories_differ` (162), for the two-phase schedule high-then-`H`. Every falling or holding fact in
the module is read off a standing run (`collapses`, `RegimeMargin.holds`); no law falls a level
under a schedule step by step.

### 1.7 RunTurns.lean (namespace `Becoming.RunTurns`; imports RegimeMargin, BandRest, ReadingSchedule)

| line | kind | exact statement | what it says |
|---|---|---|---|
| 55 | theorem | `theorem turns_where_order_breaks (dec : ∀ a b, Decidable (rel a b)) {x : V} (start : rel x (g x))` `{n : Nat} (turns : ¬ rel (Law.orbit g x n) (Law.orbit g x (n + 1))) :` `∃ k, k < n ∧ rel (Law.orbit g x k) (Law.orbit g x (k + 1)) ∧` `¬ rel (g (Law.orbit g x k)) (g (Law.orbit g x (k + 1)))` (variables `{V : Type u} {rel : V → V → Prop} {g : V → V}`) | Any carrier, any decidable relation, one fixed step `g`: if `rel` holds of the first step and fails at step `n`, then at some `k < n` the step fails to carry `rel` from the pair `(orbit k, orbit (k+1))` to their images. From `Optimum.last_before`. |
| 67 | theorem | `theorem turns_names_levels {g : Nat → Nat} {x n : Nat} (start : x ≤ g x)` `(falls : Law.orbit g x (n + 1) < Law.orbit g x n) :` `∃ k, k < n ∧ Law.orbit g x k < Law.orbit g x (k + 1) ∧` `g (Law.orbit g x (k + 1)) < g (Law.orbit g x k)` | Whole numbers: a run that first rises (weakly) and later falls names two levels the step reverses. |
| 82 | theorem | `theorem regime_turn_overcompensates {g : Nat → Nat} {H x n : Nat}` `(start : x ≤ RegimeMargin.step g H x)` `(falls : Law.orbit (RegimeMargin.step g H) x (n + 1) < Law.orbit (RegimeMargin.step g H) x n) :` `∃ k, k < n ∧` `Law.orbit (RegimeMargin.step g H) x k < Law.orbit (RegimeMargin.step g H) x (k + 1) ∧` `Law.orbit (RegimeMargin.step g H) x k - H < Law.orbit (RegimeMargin.step g H) x (k + 1) - H ∧` `g (Law.orbit (RegimeMargin.step g H) x (k + 1) - H) < g (Law.orbit (RegimeMargin.step g H) x k - H)` | On the regime, such a turn shows giving falling as what is left rises (overcompensation). |
| 107 / 117 | theorem | `orbit_twice (g : Nat → Nat) (x : Nat) : ∀ m, Law.orbit g x (m + m) = Law.orbit (fun y => g (g y)) x m`; `step_after_twice` | |
| 127 | theorem | `theorem reversing_period_two (anti : ∀ a b, a ≤ b → b ≤ hi → g b ≤ g a)` `(keeps : ∀ y, y ≤ hi → g y ≤ hi) {x : Nat} (high : x ≤ hi) :` `∀ n, hi + hi ≤ n → Law.orbit g x (n + 1 + 1) = Law.orbit g x n` | Order-reversing step on a band: period at most two from `2 hi`. Uses `ReadingSchedule.halves` (ReadingSchedule.lean 327: `theorem halves : ∀ T : Nat, ∃ v, T = 2 * v ∨ T = 2 * v + 1`) and `BandRest.rests_on_band`. That is all RunTurns takes from ReadingSchedule. |
| 176-205 | `ThreeCycle` | `giving`, `keeps`, `cycle`, `returns` (193), `neither` (201) | Period three; neither keeps nor reverses order. |

### 1.8 BandRest.lean (namespace `Becoming.BandRest`; imports Lasting, LastChange, Optimum)

| line | kind | exact statement | what it says |
|---|---|---|---|
| 36 | theorem | `theorem keeps_one_way {V : Type u} {rel : V → V → Prop} {g : V → V}` `(mono : ∀ a b, rel a b → rel (g a) (g b)) {x : V} (first : rel x (g x)) :` `∀ n, rel (Law.orbit g x n) (Law.orbit g x (n + 1))` | A step keeping a relation never turns a run starting in it: the contrapositive partner of `turns_where_order_breaks`. Restates the closure law via `Lasting.orbit_mono`. |
| 48 | theorem | `theorem rests_on_band (mono : ∀ a b, a ≤ b → b ≤ hi → g a ≤ g b) (keeps : ∀ y, y ≤ hi → g y ≤ hi)` `{x : Nat} (high : x ≤ hi) : ∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run g x) N` | Order-keeping step on a band: rest within `hi`. Docstring's finer bounds (`hi - x`, `x`) are not in the statement. |

### 1.9 Neighbours outside my files that a changing-draw law would meet

- `Amounts.falls_by_stretch` (Amounts.lean 493): `theorem falls_by_stretch {q x y : Nat → Nat} (S n : Nat)`
  `(across : ∀ t, S ≤ t → t < S + n → q (t + 1) + x t = q t + y t)`
  `(loses : ∀ t, S ≤ t → t < S + n → y t + 1 ≤ x t) :` `q (S + n) + n ≤ q S`. Stated on any
  sequence, so it applies to `underDraws` directly with `x t := q t - (q t - Hs t)` and
  `y t := g (q t - Hs t)`; `Adjusted.step_balances` (517) gives `across` at each `Hs t`.
- `Amounts.unmarked_or_marked` (Amounts.lean 506), used by `orbit_bound` to split "reached nothing
  first" from "positive throughout".
- `Optimum.ends_within` (Optimum.lean 2289, section variables `{x g d : Nat → Nat} {r m : Nat}`):
  `theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)`
  `(over : ∀ t, r < d t) (needs : 0 < m) :` `∀ t, x 0 < m + t → x t < m`. Already a changing-draw
  ending law, but giving comes before the draw and is bounded at all levels by `r`; not the
  draw-first step with `Short g H y`. Amounts' header (lines 60-71, 440-447) names it a case of
  `falls_by_stretch`.

## 2. Answers

### (1) RegimeMargin's statements

All exact statements are in 1.1-1.5: `step` 249, `FromNothing` 252, `Short` 255, `Root` 258,
`Meets` 262, `Keeps` 265; `Adjusted.step` 299, `Adjusted.step_below` 485, `Adjusted.draw_pos` 449,
`Adjusted.orbit_bound` 539, `Adjusted.ends_below` 572, `Adjusted.stays_ended` 580,
`Adjusted.holds` 645, `Adjusted.ends_iff_below` 676; `ends_below` 705, `holds` 730,
`ends_iff_below` 741, `step_mono` 1112, `short_of_below` 930, `meets_of_below` 934,
`keeps_of_below` 941; `Peaked` 958-999, `Crossing` 1001-1095 and 1400-1440, `Concave` 945-956.
The regime laws (705-741) are all derived from the `Adjusted` laws through `orbit_regime` (336) and
the four `regime_*` bridges (341-351); only the adjusted forms are proved by their own argument.

### (2) A law under a draw that changes from step to step

Nothing in RegimeMargin, DrawHistory, RunTurns or BandRest states it. No theorem in these files says:
under draws `Hs t` with `H ≤ Hs t` at every step, `Short g H y` and `FromNothing g`, a level below
`H + y` falls at every step while positive and is nothing after as many steps as it stood. Every
falling law here is at a standing draw (`Adjusted.step_below`, `orbit_inside`, `orbit_bound`,
`ends_below`, `stays_ended`, `left_bound`, `taken_whole`, `step_falls_by`, `falls_within`;
`Coupled.Indexed.ends_after` with draws per condition, standing in time). DrawHistory's schedule
laws are about the inflow (`inflow_kept`, `leaving_needs_a_lower_draw`) or a constant prefix
(`underDraws_constant`). Even at a standing draw, "falls at every step while positive" along the
run is not one stated theorem: it is `orbit_inside` (524) composed with `step_below`'s third
conjunct (485); `orbit_bound`'s `≤ x - n` alone does not give a strict fall at each step.

The held attempt's `Course.falls` (TurningInTime.lean 425) and `Course.gone` (453) state it, on
`Course` with draws `c.use (c.way s j)`.

Where it would sit so that `ends_below` is its case:

- For `RegimeMargin.ends_below` (705), and `Adjusted.ends_below` (572), to be derived from it, it
  must be in RegimeMargin or in a module RegimeMargin imports (DrawHistory imports RegimeMargin, so
  a law placed in DrawHistory could only be shown to agree with `ends_below` by a bridge theorem
  there; `ends_below` would not be its case by proof). Inside RegimeMargin the natural home is
  namespace `RegimeMargin.Adjusted`, before `orbit_bound` (539), on a schedule run of
  `Adjusted.step` (state level and recent giving, draw `Hs t` at step `t`). That would need the
  schedule run itself in RegimeMargin: `DrawHistory.underDraws` (50) moved down, or an adjusted
  schedule run defined there with `underDraws` its regime case. A scalar-only law (regime giving)
  would cover `ends_below` (705) and `Course.gone`, but not `Adjusted.ends_below`.
- Premises that make the adjusted standing law its case: `Short g H y`, `StaysShort A g H` and
  `r < H` at the lower bound `H` (not at `Hs t`), `FromNothing A`, `H ≤ Hs t` for every `t`. The
  invariant "recent giving below `H`" is kept because `StaysShort A g H` gives `A e r < H` from
  `r < H` and `g e < H`. `StaysShort A g (Hs t)` would not do: the recent giving can exceed a later,
  lower draw. This is what would have to be proved, not a proposal.
- Lemmas it would reuse: `step_balances` (517, any `H`); `left_below` (474), applied through
  `x - Hs t ≤ x - H`; `left_falls` (461); `draw_pos` (449); `from_zero` (507), whose proof uses
  only `0 - H = 0` and goes through unchanged for a per-step draw but is stated for a standing one;
  `Amounts.falls_by_stretch` and `Amounts.unmarked_or_marked` (as in `orbit_bound`);
  `DrawHistory.underDraws_constant` (136) for the constant-schedule bridge, if `underDraws` stays
  in DrawHistory; otherwise a one-line `rfl`-by-induction bridge to `Law.orbit` at `Hs := fun _ => H`.
  A one-line `Short` monotonicity lemma is missing and would be needed (or inlined).
- Modules that import RegimeMargin directly and would recompile: `Becoming/DrawHistory.lean`,
  `Becoming/RunTurns.lean`, `Becoming/ReadOffInTime.lean`, `Becoming/RoomRuns.lean`, the root
  `Becoming.lean` (line 274), and the periphery `lean/regime/RegimeReals.lean` (Mathlib). No module
  under `Becoming/` imports DrawHistory, RunTurns, ReadOffInTime or RoomRuns (grep), so the
  transitive set is those plus `Becoming.lean` (which imports RunTurns 275, DrawHistory 276,
  RoomRuns 278, ReadOffInTime 398). The held TurningInTime imports RegimeMargin too.
  RegimeMargin is 3687 lines; any edit rebuilds it whole.

### (3) The held attempt against existing laws

- `Course.left_lt` (TurningInTime 406): `c.left k x < x` under `Short c.giving H y`,
  `FromNothing c.giving`, `H ≤ c.use k`, `0 < x`, `x < H + y`. Not new. It is the third conjunct of
  `Adjusted.step_below` (485) at `A := fun e _ => c.giving e`, draw `c.use k`, `r := 0`, after
  weakening `Short g H y` to `Short g (c.use k) y` and `x < H + y` to `x < c.use k + y`, with
  `0 < c.use k` from `draw_pos`. Its docstring ("At a standing use this is
  `RegimeMargin.Adjusted.step_below`") has the relation the wrong way round, as the reader says.
  It is proved by its own case split rather than derived.
- `Course.falls` (425): `c.level s n + n ≤ s.2 ∨ c.level s n = 0`, along a line whose ways all use
  at least `H`. New in content: the changing-draw form of `Adjusted.orbit_bound`'s third conjunct
  (539) for the regime's giving. It is proved by its own induction, while the package's rule (Amounts
  header 60-71, 440-447) is that these falls are cases of `Amounts.falls_by_stretch`.
- `Course.falls_le` (445): `c.level s n ≤ s.2`. A corollary of `falls`; no separate existing law
  (at a standing draw it follows from `orbit_bound`).
- `Course.gone` (453): `c.level s s.2 = 0`. New in content: the changing-draw form of
  `ends_below` (705); `ends_below` is not derived as its case.
- Also: `Course.below_stays` (501) and `Course.above_of_never_ends` (509) are corollaries of
  `falls_le`/`gone`; `Turning.holds` (576) is `RegimeMargin.holds` (730) after identifying the
  course's level with the standing run under `H₂`, the same identification as
  `DrawHistory.underDraws_constant`, re-proved inline. `Course.level s n` is by definition
  `DrawHistory.underDraws c.giving (fun j => c.use (c.way s j)) s.2 n` (not stated; provable by
  induction, since `Course.left k x := RegimeMargin.step c.giving (c.use k) x`, 183).

### (4) RunTurns: "where a run turns"

`turns_where_order_breaks` (55) is stated for any carrier, any decidable relation and one fixed step
`g` (a `Law.orbit`): if `rel x (g x)` and `¬ rel (orbit n) (orbit (n+1))`, then some `k < n` has
`rel (orbit k) (orbit (k+1))` and `¬ rel (g (orbit k)) (g (orbit (k+1)))`. Since
`g (orbit k) = orbit (k+1)`, this says only that the relation between consecutive states fails to
carry over at some step before `n`: the step does not keep `rel` on that pair, the converse of
`BandRest.keeps_one_way` (36). On whole numbers (`turns_names_levels`, 67) and on the regime
(`regime_turn_overcompensates`, 82) a "turn" is a change in the direction of the level's run (rise
then fall), and on the regime it needs giving to fall as what is left rises. "Turn" here is not
the held attempt's turning (a way that comes to use less). Nothing in RunTurns has a changing draw
or a second coordinate.

### (5) Recovery after the draw is lowered

Not stated anywhere in these files. What exists:

- The two separate laws a recovery statement would compose: `ends_below` (705) under the higher
  draw and `holds` (730) under the lower, each on a standing run.
- `rises_by_draw` (793) and `root_mono` (783): with `Root g H y`, `Root g' H' y'`, `H ≤ H'`,
  `Lowered g' g`, the points satisfy `H + y + (H' - H) ≤ H' + y'`. So with one giving
  (`Lowered g g` by `Nat.le_refl`) the interval `[H + y, H' + y')` between the two points is
  well-ordered; no theorem says anything about a level inside it.
- DrawHistory's two-phase results go the other way: raise the draw, then lower it, and the level
  is at the inflow for ever (`history_decides` 149, `histories_differ` 162). The module header says
  explicitly that leaving the inflow "is not shown to be recovery" (line 18) and that the bounds
  are "not … a draw that brings recovery" (line 30). `leaving_needs_a_lower_draw` (85) is only a
  necessary condition.
- No lemma splits a schedule run at a step `T`
  (`underDraws g Hs x (T + k) = underDraws g (fun t => Hs (T + t)) (underDraws g Hs x T) k`, or the
  standing-run form after `T`). `underDraws_constant` covers only a constant prefix from step 0, and
  `inflow_kept` handles the tail only at the inflow. A recovery law under a schedule needs this split.
- Related, by another coordinate rather than a lowered draw: `Crossing.crosses` (1062, recent
  giving decides fate at one draw), `Adjusted.threshold_falls` (1655), `Coupled.threshold_falls`
  (3319), `MutualActivation.saves` (3465, the partner's level lowers the threshold),
  `Momentum.threshold_falls_with_recent` (3147). `Peaked.each_holds` / `together_ends` compare a
  draw of 3 with 6, not a lowering along a run.
- The held attempt's `Turning.goes_on_iff` (TurningInTime 609) is the only statement found of
  a level that turns from the higher draw to the lower in time; it is new.

## 3. Candidates for joins, and cautions

### Joins (an existing definition that looks like a case of a root law; what would have to be proved)

- `Adjusted.orbit_regime` (336) as going alike: under `A := fun e _ => g e` the class "same level"
  (`p.1 = q.1`) goes alike under the relation `t = Adjusted.step A H s`. Needed: the step-level
  statement (states equal in level step to states equal in level), in the root's terms for that
  relation and class. For general `A` the class does not go alike, and `Crossing.crosses` (1062) is
  the witness that it is then not constant either: the same level ends or holds by the recent
  giving, the other coordinate telling what the level does not.
- `Coupled.first_regime` (3406) and `Coupled.Indexed.step_alike` / `run_alike` (2445, 2469): the
  same kind of lumping for coupled conditions (own level alike where giving reads only the own
  level; pointwise-equal states). `MutualActivation.saves` (3465) is the coupled witness that the
  own level is not constant, the partner's level telling.
- `ends_below` (705) / `Adjusted.ends_below` (572) as the standing-draw case of a schedule law (see
  2): the schedule law and a bridge at a constant schedule (`DrawHistory.underDraws_constant` 136
  supplies the scalar one).
- `Course.level` as `DrawHistory.underDraws` (3): one induction.
- `RunTurns.turns_where_order_breaks` (55) and `BandRest.keeps_one_way` (36) are the two directions
  of one law on a fixed step: keep a relation and no run turns; turn, and the step did not keep it.
  Whether the root's "goes alike" for a relation-as-class reads these as cases would have to be
  checked against the root's own laws (not read here).
- `Coupled.Indexed.ends_after` (2173) is a "what would bring the difference is running out" form:
  once one condition stays within its draw, its dependent falls by exactly its draw. It is at a
  standing draw and with giving zero, not under `Short`.

### Cautions

- Restating at a standing draw anything in 1.2-1.3 duplicates: one-step fall (`step_below` 485),
  run bound (`orbit_bound` 539), ending (`ends_below` 572/705), staying ended (`stays_ended`
  580/712), holding (`holds` 645/730), exactness (`ends_iff_below` 676/741), draw positivity
  (`draw_pos` 449). `Course.left_lt` is already such a duplicate.
- A new falling law proved by its own induction would go against the package's recorded rule that
  these falls are cases of `Amounts.falls_by_stretch` (Amounts.lean 60-71, 440-447; board item EC6).
- Name collisions: `RegimeMargin.FromNothing` (252) and `RegimeMargin.Adjusted.FromNothing` (317)
  share a short name with different types; `open RegimeMargin (… FromNothing …)` inside
  `Adjusted` resolves differently. `Keeps` too (265 and 321, different shapes: the adjusted one
  carries `H ≤ r`). `step_mono` exists three times (`RegimeMargin` 1112, `Adjusted` 1152, `Drawn`
  1848, plus `Coupled`/`Indexed`). `holds`, `ends_below`, `stays_ended`, `ends_iff_below`,
  `threshold`, `threshold_falls`, `fates`, `comes_to_rest`, `rests_by` each exist in more than one
  namespace. `Course` is a structure in `LineageDrawdown` (261) and an inductive in `Ranking` (336),
  and `Becoming.Courses` is a module; namespaced, so no clash, but a reader collision. `falls` is a
  theorem name in LeastLoss (232), Reserve (897), Resolution (1529), RuleShaping (747). "Turn" in
  RunTurns means a reversal of the level's direction; `Drawn.run_shape` (1998) "turns at most once"
  means the same; neither is the held attempt's `Turning`.
- A schedule law with `StaysShort A g (Hs t)` per step would be false-in-use: the recent giving
  below `Hs t` need not be below `Hs (t+1)`. Stating it at the lower bound `H` avoids this.
- `Short g H 0` is vacuous; at `y = 0` the "point of no return" is `H`, and `draw_pos` still gives
  `0 < H` from `x < H`. `ends_iff_below` needs `pos : 0 < H + y`.
- `Adjusted.ends_iff_below`'s `side : r < H ↔ x < H + y` is a strong premise (the recent giving is
  on the level's side); a reader taking it as "the point is exact for the adjusted step" in general
  reads more than is there. `Crossing.crosses` shows exactness fails without it.
- Docstrings that claim more than the statement: `rests_within` (1121) and
  `BandRest.rests_on_band` (48) state finer bounds (`hi - x`, `x`) only in prose; RegimeMargin's
  header (lines 21-23) attributes "falls at every step" to `Adjusted.step_below`, a one-step law,
  while the run-wide strict fall is only the composition with `orbit_inside`; `Course.left_lt`'s
  docstring (TurningInTime) inverts its relation to `step_below`.
- `holds` (730) needs `Keeps g H hi` and `x ≤ hi`; a recovery composition must show the level at
  the lowering is within `hi` (the held attempt does it through `falls_le`).
- Recompiling RegimeMargin rebuilds DrawHistory, RunTurns, ReadOffInTime, RoomRuns, the root and
  RegimeReals (Mathlib, slow); a law placed in DrawHistory rebuilds only DrawHistory and the root,
  at the price that `ends_below` is then not its case by proof.

## 4. Not read or not settled

- RegimeMargin 1126-3683 read by declaration list and selected statements (1.5), not proof by
  proof; `Coupled`, `Indexed`, `Recent` statements other than those quoted were not copied.
- ReadingSchedule.lean: only its header and `halves` (327), which is all RunTurns uses.
- The root's own laws (`«同行»`, `«有常»`, `«核»`, `GrammarPath`, `GrammarLaws`) were not read; the
  joins in 3 say what would have to be proved, not that the root's statements fit.
- `Becoming.lean`'s full import list beyond the lines found, and whether other packages
  (`lean/regime/`, tests, checker inputs) import RegimeMargin through paths other than
  `import Becoming.RegimeMargin`. The `becoming-checks/` snapshot directories also contain copies
  importing it; they are past check inputs, not live modules (not verified).
- Nothing was compiled; the "would have to be proved" items are argued from the statements, not
  checked in Lean.
