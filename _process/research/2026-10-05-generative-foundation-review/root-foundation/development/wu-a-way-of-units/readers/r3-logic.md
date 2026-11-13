AI-written (Opus reader), 13 November 2026

# R3 logic reading of DESIGN-R3 (G1 to G7)

Read only. Simulations: python, scratch script `/private/tmp/claude-501/-Users-ren-theories/3c343411-bb06-4ddc-aa7a-5f9cd79133ad/scratchpad/sim.py` (201 givings, random ways of 0 to 4 parts with repeated needs, need 0, empty way, starts that already hold). Nothing built or run in Lean.

## 1. Each claim

**G1** True (0 failures). It is `Narrowing.mem_filter` (Narrowing.lean:92) iterated along `Law.orbit (pair after left)`, and it holds with repeated parts, a need of 0 and the empty way. Bookkeeping.

**G2** True (0 failures). The `→` direction needs a length lemma: `filter q l = l` with some `q a = false` makes the left side shorter. The trailing "so" sentence says more than the equation does; see 6.

**G3** True, and (i) and (iii) are definitional (`Law.stepWhile_none_iff`, GuardedStep.lean:112). (ii) is `kind_ends_while_net_goes` (TurningInTime.lean:610) at `κ w := p ∈ w` with `K := Prop`. It is nothing new.

**G4** False as written. Counterexample: the empty way at any `x`. The line ends at once, but the right side holds at `k = 0` with `S = []`: `use [] = 0`, and `Short g 0 y` forces `y [] = 0`, so `0 + 0 ≤ x`. With **`S ≠ []`** added, the claim held in all 723 cases where the premises hold (premises asked only for uses of sub-ways). Each premise below is necessary; in every row the left side is "never ends" and the right side is "reaches a good `(S, z)`".

| dropped premise | counterexample, g = `min z (12-z)` unless stated, hi = 12 | left | right |
|---|---|---|---|
| `S ≠ []` | `w = []`, `x = 3` | F | T |
| every need > 0 | `[(0,100)]`, `x = 9` (Short, Meets, Keeps hold) | T | F |
| FromNothing | `g ≡ 5`, `[(1,10)]`, `x = 3`, `y = 20` | T | F |
| `x ≤ hi` | `[(1,10)]`, `x = 13`, `y = 3`: 13, 6, 0 | F | T (13 ≥ 13) |
| Short | `[(1,2)]`, `x = 4`, `y = 5`: fixed at 4 | T | F |
| Meets | `[(1,5)]`, `x = 6`, `y = 0`: 6, 2, 0 | F | T |
| Keeps for every way met | `g = [0,2,1,4,1,7,7,…]`, `hi = 6`, `[(2,3),(4,0),(7,0)]`, `x = 6`: level 7 > hi, then 5, 3, 0 | F | T at `z = 7` |

"For every way `S`" is stronger than needed. Over `List Part` it means every use in `Nat`. State it as `y : Nat → Nat` with Short, Meets and Keeps at every use of a sub-way of `w`.

**G5** False as written. On `W := List Part`:
- `AloneOutside (· < m) id after` quantifies over every way. `[(m+1, 0)]` at level `m` is filtered to `[]`.
- `uses : ∀ w, Kept w → use w = H₂` fails at `[]` (use 0), which "first part absent" includes. `Kept := (= [P₂])` instead breaks `kept` and `turns` at levels below `n`.
- The design's net (`∃ p ∈ w, p.need ≤ x`) is not `net n` on `List Part`. They differ at `([], x ≥ n)` and at `([P₁], n ≤ x < m)`.

The relation (`↔`) holds in all 7447 regime cases simulated, so the content is fine. Only the instancing is wrong; see 3.

**G6** Recomputed: 9, 8, 6, 2, 0. With `m = 9`: (2 parts, 9), (2, 8), (1, 6), (1, 6), … and the line never ends. With `m = 8`: … (2, 6), (1, 2), (1, 0), ends. Correct. It is `Three.goes_on` / `Three.turned_and_ends` (TurningInTime.lean:941, 958) on a parts carrier.

**G7** True under G5's premises (44436 pairs, 0 failures). The course as it was never rises (`Optimum.never_rises`, Optimum.lean:2246), so `T(m′) ≤ T(m)`, the level at `T(m′)` is at least the level at `T(m)`, and the same holds one step later. The proof needs `below` (`x < H₁ + y₁`). Without it, G7 fails (556 cases). Example: `g = [0,3,6,3,7,1,6,4,7,0,5,6,4,0]`, parts `(m,1)` and `(4,5)`, from 8:
- with `m = 4` the line holds at 8 forever;
- with `m = 9` it runs 8, 8, 6, 4, 0 and ends.

## 2. A constructive proof of G4 (with `S ≠ []`)

Write `can s := ∃ p ∈ s.1, p.need ≤ s.2`, `X` for the levels of `orbit (pair after left) s₀`, and `Good (S, z) := S ≠ [] ∧ (∀ p ∈ S, p.need ≤ z) ∧ use S + y(use S) ≤ z`. Through `Law.stepWhile_unending_iff` (GuardedStep.lean:143), which fits as stated, the claim is: `(∀ k, can (orbit k)) ↔ ∃ k, (∀ j < k, can (orbit j)) ∧ Good (orbit k)`.

- **Bound.** Every level is at most `hi`, by induction with `Keeps` at the way's use.
- **Holding.** From `Good (S, z)`, for every `i`, `orbit (k + i) = (S, run (step g (use S)) z i)` and the level stays at or above `z`. Induction on `i`, using `RegimeMargin.holds` (RegimeMargin.lean:730, fits) and filter-is-self (G2). This gives `←` together with `Law.orbit_add`.
- **Falling.** From `(S, z)` with every need met, `S ≠ []`, positive needs and `z < use S + y`: `RegimeMargin.ends_below` (:705, fits; its `Law.run … .state` is defeq to `Law.orbit`, as `unending_iff_above` uses) gives level 0 at step `z` of the fixed-`S` run. Then `first_of_decided` (ReadOffInTime.lean:196, fits), bounded by `z`, with `P j := ∀ p ∈ S, need ≤ X_fixed j`, gives a first `t ≤ z` where some part of `S` is not met. Up to `t` the orbit is `(S, X_fixed)`, so the way at `k + t + 1` is strictly shorter.
- **Main (`→`).** Induction on a bound `ℓ` on the way's length at index `k`. At each step it decides `Good (orbit k)`: list "all met" by list induction, plus `Nat.lt_or_ge`.
  - If good, stop.
  - If some part is unmet, the next way is shorter: recurse at `k + 1`.
  - Otherwise use Falling: recurse at `k + t + 1`.
  - At `ℓ = 0` the way is empty, so `can` fails, which contradicts the line never ending.

Excluded middle is used only over finite lists and bounded ranges.

**Lemmas that do not fit:**
- `RegimeMargin.ends_iff_below` (:741) would do Falling's job but needs `Meets`, `Keeps`, `0 < H + y`; `ends_below` is enough.
- `Optimum.ends_within` (:2289) needs the Optimum form, which comes only through `regime_levels` (TurningInTime.lean:383), and that is **private**, so another module cannot use it. It is not needed.
- `agrees_until_marked` and `unending_iff_first_marked` cannot be used: their `AloneOutside` quantifies over every way.

**List lemmas:**
- Present: `Narrowing.mem_filter`, `filter_cons_true` and `filter_cons_false` (Narrowing.lean:92–124).
- Missing: filter-is-self iff all pass, length of filter ≤ length, strictly shorter when one fails, and deciding `∀ p ∈ l` by list induction.
- Use `of_decide_eq_true` and `decide_eq_true`, not `decide_eq_true_eq` (propext).
- No sum lemma is needed. Define `use` by recursion; `RuleRebuilding.sumL` (:157) would pull in a large import.

## 3. G5 as an instance of `turns_in_time_iff` (TurningInTime.lean:549)

Take `W := Bool` (the first part present), `after b x := b && decide (m ≤ x)`, `use b := bif b then h + H₂ else H₂`, `need := n`, `marked := (· < m)`, `alone := id`, `Kept b := b = false`, `H₁ := h + H₂`.
- `AloneOutside`: if `m ≤ x`, then `b && true = b`.
- `turns`: if `x < m`, then `b && false = false`.
- `kept`: `false && _ = false`.
- `uses`: `rfl`.
- `uses₁`: `orbit id true j = true`. `Three.orbit_id` is private, so it has to be re-proved.

This is Three's carrier with a down-set mark in place of an interval. G5 then needs a **transfer**: from `(w₀, x)` with `n ≤ m`, the parts orbit is `(enc b, z)` (`enc true = w₀`, `enc false = [P₂]`) at every index up to the first level below `n`, and both cans fail first there.

- `n ≤ m` is needed, or `[P₁]` is reachable.
- `0 < n` and `n ≤ H₂ + y₂` are TT's own `needs` and `within`; they stay as premises, as do Short (twice), Meets, Keeps, `below` and `high`.
- **A start that already holds with both parts is not covered**: `below` excludes it. G4 covers it, if Meets and Keeps also hold at `h + H₂`.
- TT's net: a next while the level meets the fixed `n`. The design's net: a next while some part goes on. With `n ≤ m`, the two agree on the reachable ways `w₀` and `[P₂]`, and on nothing else.

## 4. Vacuity, and relabelling

- G1 and G2 are list facts. G3 is a definition plus an existing theorem. None is vacuous, but none says anything about turning.
- G5 is `turns_in_time_iff` with the mark chosen as one part's need. What moves from premise to derivation is `AloneOutside`, `turns`, `kept`, `uses` and `uses₁`, and only in the two-part model and after the encoding.
- `m` itself stays a free parameter. The regime premises stay. G3 shows the mark depends on the way; TT's mark is a property of levels alone, so the general case (G4) cannot go through TT at all.
- G5 also follows from G4 together with never-rising, without TT, but G4 asks more (Meets and Keeps at `h + H₂`).
- Only G4 and G7 derive something not already in the package.

## 5. Three to keep

**G4** (with `S ≠ []`): the content. **G7**: the one comparative fact. **G5** (Bool carrier plus transfer): the tie to TT.

G1 and G2 are lemmas for G4. G3 restates `kind_ends_while_net_goes`. G6 recounts Three.

## 6. Sentences that say more than G1 to G7 prove

- "One structure, from which all six follow": the regime premises, `within` and `below` do not follow. On `List Part`, even the five marks-premises fail.
- "No `marked`, `alone`, `Kept` or outer `need` is given": G5 chooses all of them.
- G2's "So the level makes a difference…": the derived mark depends on the way, so it is not TT's `marked : Nat → Prop`. And TT's "difference" (`toEnd_iff`) is between two levels, not between a level and the way.
- G3's "(the root's `«亡而网续»`)" and "is the whole's turn": no `«亡而网续则不至终有常»` conclusion is stated, since there is no `«续»` into `(w, x)`. A `¬«本类至终有常»` is derivable through `«出类不随则本类不至终有常»` with `(w, x₀)` where `x₀ ≥ p.need`; G3 does not claim it.
- G4's "one after another… or nothing remains": several parts can end at one step, and "nothing remains" is the ending case, which the iff does not state.
- G5's "are theorems": false as typed (see 1).
- G7's "the part that uses most" and "makes the turn later": G7 has no premise on use and says nothing about timing. It holds only below `H₁ + y₁` (counterexample in 1).
- "plain form of 'do not shield what would end first'", and "The mark is not something a reader adds": `m` and the part are still put in by the modeller.
