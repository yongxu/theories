# Brief: a line on a stock, stage A (in scratch only)

*AI-written (Fable, holding the design; board row DJ), 16 November 2026, second version, after six readers. For the implementer. Nothing here is proved. The search and the readers' findings behind it are in `STEPS-3-7-ON-PAPER.md` beside this file; read its last two sections.*

## The task

Write one new Lean module, in scratch only, and get it to build with every axiom report empty and no warning. Touch no tracked file. Land nothing.

- Package (PKG): `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`. No Mathlib.
- Scratch tree (SCR): `/Users/ren/theories/tmp/r7/one-model/lean-scratch/`. Your file: `SCR/Becoming/LineOnAStock.lean`. Leave `SCR/Becoming/TurningInTime.lean` alone (it equals the tracked one).
- Build, from PKG, in the background, with a log: `LEAN_TIMEOUT=3600 python3 -B scratch_build.py /Users/ren/theories/tmp/r7/one-model/lean-scratch/ Becoming.LineOnAStock > /Users/ren/theories/tmp/r7/one-model/lean-scratch/buildA<N>.log 2>&1`. The log's end prints each declaration's axioms. One build at a time; before each, `uptime`, and `ps` for a `lean`, `scratch_build` or `check_becoming` of yours still alive. Never run `check_becoming.py` with any flag: it is the core run.
- Not allowed: `omega`, `simp`, `funext`, `Classical`, `propext`, `native_decide`, `sorry`, `Quot.sound`, any axiom. `decide` only on small closed facts, as `TurningInTime.Three` does. Read `Becoming/WayOfUnits.lean` whole first: it is this model's special case and shows the style (structural recursion on lists, arithmetic by named lemmas from core `Nat` and `Becoming/Naturals.lean`, bounded search by `ReadOffInTime.first_of_decided`).
- Docstrings: plain sentences saying exactly what the Lean proves, premises named, nothing more. No "recovers", "has to", "exactly" unless the statement is an iff. Module docstring: what the model is, what is given, what is concluded, what is not derived.

## The model

`WayOfUnits`: a way is a list of units, each with a need and a use; a unit goes on while the level meets its need; the level is `RegimeMargin.step giving (taken w) x`; every unit leaves exactly itself. Here a unit leaves offspring. One relation with two ends: the way reads the level only through which needs it meets; the level reads the way only through what it takes.

```lean
import Becoming.WayOfUnits      -- and what else you need (SelectionTerm for Generations; see below)

namespace Becoming
namespace LineOnAStock

variable {U : Type}

/-- The way after a step at level `x`: each unit in turn leaves its kids where `x` meets its need, and nothing where it does not. -/
def after (need : U → Nat) (kids : U → List U) : List U → Nat → List U
  | [], _ => []
  | u :: w, x => cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x

def taken (use : U → Nat) : List U → Nat          -- or `Prelude.total w use`, if the existing lemmas then apply; say which and why
def left (giving : Nat → Nat) (use : U → Nat) (w : List U) (x : Nat) : Nat := RegimeMargin.step giving (taken use w) x
def Goes (need : U → Nat) (s : List U × Nat) : Prop := ∃ u, u ∈ s.1 ∧ need u ≤ s.2
-- net    := Law.stepWhile (Goes need) (TurningInTime.pair (after need kids) (left giving use))
-- course := Law.orbit (TurningInTime.pair (after need kids) (left giving use)) s
/-- The `n`-th generation of a way with no level in it: the kids of the kids … of its units. -/
def generation (kids : U → List U) : Nat → List U → List U
```

A **line** is a predicate that offspring inherit exactly: `S : U → Prop` with `same : ∀ u v, v ∈ kids u → (S v ↔ S u)`. What the line takes: the sum of `use u` over the units `u` of the way with `S u` (needs `DecidablePred S`; define it as you find cleanest and say how).

You may shape definitions differently if a proof needs it, as long as item 3 holds; say what you changed.

## What to prove, in this order (stop and report after any item you cannot do; never leave a broken file)

1. **Who is in the next way.** `v ∈ after need kids w x ↔ ∃ u, u ∈ w ∧ need u ≤ x ∧ v ∈ kids u`. **Alike.** If `x`, `x'` meet the same needs in `w` (`∀ u, u ∈ w → (need u ≤ x ↔ need u ≤ x')`) then `after need kids w x = after need kids w x'`. **Lines reach each other only through the level.** `after need kids (w₁ ++ w₂) x = after need kids w₁ x ++ after need kids w₂ x`; and `left` at two ways that take the same is the same.
2. **Alike levels, one count, on any two stocks.** For givings `g`, `g'`, uses `use`, `use'`, start levels `x`, `x'` and one way `w` (same `need`, `kids`): if for every `j < n` every unit of `generation kids j w` has its need met at step `j` of both courses, then the way at step `n` of each course is `generation kids n w`. State it so that neither course's way is assumed. Then: the way of a course is a family of `SelectionTerm.Generations` (in `Becoming/SelectionTerm.lean`): with `first := w`, `kids t u := kids u` if `need u ≤` the level at step `t` and `[]` otherwise, `amount _ := use`, prove `family t = (course t).1`, and that the family's sum is `taken` (so `Generations.born_eq` and the rest apply). If the instance cannot be had cheaply, stop on this half and say what obstructs.
3. **The case of `WayOfUnits`.** With `U = Nat × Nat`, `need = WayOfUnits.need`, `use = WayOfUnits.use`, `kids u = [u]`: `after` is `WayOfUnits.after`, `taken` is `WayOfUnits.taken`, `Goes` is `WayOfUnits.Goes`, the course is `WayOfUnits.course`, and `«不穷» (net …) «一» s ↔ «不穷» (WayOfUnits.net giving) «一» s`.
4. **Rise.** For a line `S` with `grows : ∀ u, S u → use u < (what S takes of kids u)`: if every `S`-unit of `w` has its need met at `x`, then what `S` takes of `after need kids w x` is at least what it takes of `w` plus the number of `S`-units of `w`.
5. **Fall.** For a line `S` of one need (`∀ u, S u → need u = m`) with `keeps : ∀ u, S u → use u ≤ (what S takes of kids u)` and `giving 0 < m`: from a configuration `(w, x)` in which what `S` takes of `w` is more than `giving z` for every `z`, there is a step `n` from which no `S`-unit is in the way (`∀ k, n ≤ k → ∀ u, u ∈ (course k).1 → ¬ S u`). Route: while the level is at least `m` every `S`-unit is met, what `S` takes does not shrink, so the level strictly falls (what is left after the draw plus what is given on it is below the level); once it is below `m` no `S`-unit leaves anything, and by `same` no other unit leaves an `S`-unit.
6. **A line that grows ends.** Premises: `RegimeMargin.FromNothing giving`; `RegimeMargin.Keeps giving 0 hi` (prove once: then `RegimeMargin.step giving H x ≤ hi` for `x ≤ hi`, any `H`); `x ≤ hi`; a line `S` with `grows` as in 4, `needs : ∀ u, S u → 0 < need u`, `down : ∀ u v, S u → v ∈ kids u → need v ≤ need u`. Conclusion: a step from which no `S`-unit is in the way. With `S = fun _ => True`: `∃ n, ¬ Goes need (course n)` and `¬ «不穷» (net …) «一» (w, x)` (see `GuardedStep.stepWhile_unending_iff`).
   Route (constructive; no minimum of a list). `Below m w` := every `S`-unit of `w` needs at most `m`. Claim `P m`: from every `(w, x)` with `x ≤ hi` and `Below m w`, some step has no `S`-unit met; strong induction on `m`.
   - `x < m`: step once. Every `S`-unit of the next way is a kid of an `S`-unit (by `same`) met at `x`, so by `down` it needs at most `x`: the next way is `Below x`, and `x < m`.
   - `m ≤ x`: every `S`-unit is met. Inner induction on fuel `k` with `hi + 1 ≤ (what S takes of w) + k`. No `S`-unit in `w`: step 0. Otherwise by Rise the next way's `S`-take is at least one more, and it is still `Below m`. If the next level is below `m`: first case. If not: the whole draw was at most the level (a draw above the level sends the next level to `giving 0 = 0`, and `m ≤ 0` with an `S`-unit present contradicts `needs`), so the `S`-take is at most `x ≤ hi`, `k` is positive, recurse with `k - 1`.
   - Every way is `Below m` for some `m`. After a step with no `S`-unit met, no `S`-unit is ever in the way again (by `same`).
   Also, as its own statement: **a need comes to be unmet.** With `S = fun _ => True`, a way that is not empty and every need met at the start (and no premise `down`): `∃ n, 0 < n ∧ n ≤ hi + 2 ∧ ∃ u, u ∈ (course n).1 ∧ (course n).2 < need u`. (Check the bound; say if it must differ.)
7. **On a course that goes on, what the way takes is less than the level.** With `FromNothing giving` and `∀ u, 0 < need u`: `Goes need (course (n + 1)) → taken use (course n).1 < (course n).2`.
8. **Kept countermodels and worked courses**, each a closed theorem on small numbers, on `TurningInTime.Three.giving` (`giving z = min z (12 - z)`) unless said. Give the course's configurations at the named steps and, where the line goes on for ever, `«不穷»`; where it ends, `¬ «不穷»` or the step with no unit met.
   - *Kids that need more than their parent* (premise `down` of 6 dropped), on `min z (10 - z)` (define it): `A` = need 4, use 2, kids `[B, A, B]`; `B` = need 9, use 1, kids `[B, B]`. `grows` holds of both. From `([B, A, B], 8)` the configuration repeats for ever.
   - *Equal in place of more*: a unit that leaves itself can hold for ever: cite the `WayOfUnits` case through item 3 with one of its own worked cases, or a one-unit course.
   - *A share that rises while the number of drawers falls*: `C` = need 1, use 2, kids `[C]`; `O` = need 1, use 2, kids `[]`. From `([C, O], 12)`: the way is `[C]` from step 1 and the level 12 throughout; never ends.
   - *A line that doubles*: need 1, use 1, kids two copies. From one unit at level 12: levels 12, 12, 12, 12, 8, 0; 1, 2, 4, 8, 16, 32 units; ends. Also show it as a case of item 6.
   - *The higher start ends* (the fate is not monotone in the level): `A` = need 1, use 3, kids `[B, B]`; `B` = need 3, use 1, kids `[C, B]`; `C` = need 12, use 1, kids `[A]`. From `([A], 6)`: `A`@6, `B B`@6, `C B C B`@8, and from then on the same for ever. From `([A], 7)`: `A`@7, `B B`@8, `C B C B`@12, six units@12, ten@4, sixteen@0, ended. The two ways are equal at steps 0 to 2. Check these numbers by your own computation first (a few lines of Python) and report any that differ.
   - *A met unit with no kids*: need 1, use 1, kids `[]`, from 12: one step later the way is empty with the level at 12, and the net has ended though every need was met.

## What I need back

- The file's path and line count; the last build log's path and its closing lines; for every theorem, that its axiom report is empty (quote the audit's summary line).
- For each numbered item: the theorem names and statements as they stand in the file (verbatim), or why an item is not there.
- Which existing lemmas each proof rests on (name and module), so that it is plain where the module is joined to what was there.
- Anything changed from this brief (a definition, a premise, a bound) and why. If a statement here is false, do not weaken it silently: give the countermodel.
- Every premise you found you did not need.

## Hard rules

No edit outside SCR and your notes folder `/Users/ren/theories/tmp/r7/one-model/check/round9/implementer/`. No git command that writes; never `git prune`, `git gc`, `git clean`. No test suite, no gate, no core run. This Mac is shared and always busy (load 30 to 100 is normal): one Lean build at a time, in the background with a log; a timeout under load is not an error in the proof: rerun once alone.
