*AI-written (Fable), 13 November 2026. A small design: the two comparison theorems of `Becoming.WayOfUnits` with only the premises they need. Nothing here is proved until the Lean builds.*

# Trimming `greater_need` and `more_use_on_first`

## Why

Both are proved through `two_units_iff` and so carry all of its premises. The readers' simulations (`wu-a-way-of-units/readers/v2-premises.md`, `v3-cold.md`) found each true with several dropped. Fewer premises is a shorter statement and a stronger theorem, and the line "a simulation found … which is not proved here" can go.

## The statements wanted

Write `L m h H` for `«不穷» (net giving) «一» ([(m, h), (n, H)], x)`.

**T1 `greater_need`.** `n ≤ m`, `m ≤ m'`, `FromNothing giving`, `Short giving H₂ y₂`, `Meets giving H₂ y₂ hi`, `Keeps giving H₂ hi`, `x ≤ hi`: `L m h H₂ → L m' h H₂`. No `0 < n`, no `n ≤ H₂ + y₂`, no `Short` at `h + H₂`, no bound on the start below `h + H₂ + y₁`.

**T2 `more_use_on_first`.** `n ≤ m`, `FromNothing giving`, `Short giving H₂' y₂'`, `Meets giving H₂' y₂' hi`, `Keeps giving H₂' hi`, `h + H₂ = h' + H₂'`, `h ≤ h'`, `x ≤ hi`: `L m h H₂ → L m h' H₂'`. No regime at `H₂`, no `0 < n`, no `within`, no `Short` at the sum, no bound on the start.

**T0, the lemma both rest on (state it as a theorem; it says something by itself).** `n ≤ m`, `FromNothing giving`, `Short giving H y`, and `0 < n`: if the line from `([(m, h), (n, H)], x)` never ends, every level of its course is at or above `H + y`. (A line of two units that never ends stays at or above the level from which the second holds alone.) If `0 < n` cannot be dropped, keep it in T0 and treat `n = 0` apart in T1 and T2, where `Goes` holds at every step and both lines never end.

## Why they should hold (a sketch, to be checked by simulation before any proof)

- T0. Suppose a level `z` of the course is below `H + y`. Whatever units are present there, what the way takes is at least `H` while the second unit is present (it is present while the net goes on, since `n ≤ m`). What is left after the take is below `y`, so giving is short of `H`, and the next level is lower than `z` and still below `H + y`. So the level falls at every later step, comes below `n`, and the net ends there. (With the first unit present the take is `h + H`, what is left is smaller still, and `Short` at `H` still applies.)
- T1. The two lines have the same course until the first level below `m'` (at step `T'`, if any; before it every level is at or above `m' ≥ m`, so the first unit is present in both). If there is none, they are the same line. Otherwise they agree through step `T' + 1`, since the step at `T'` still takes `h + H₂` in both. By T0 that level is at or above `H₂ + y₂`; it is at most `hi` (`Keeps` at `H₂` with `FromNothing` gives `Keeps` at `h + H₂`: `step giving (h + H₂) x = step giving H₂ (x - h)` where `h ≤ x`, and nothing otherwise); and `n` is met there, since the first line's net goes on at that step and `n ≤ m`. From there the second unit alone holds for ever (`RegimeMargin.holds`), its need met at every later level.
- T2. Same needs and same sum, so the two lines have the same levels while the first unit is present, and it ends at the same step `T` or never. If never, they are the same in levels and in which units go on. Otherwise the level at `T + 1` is the same in both. If it were below `H₂' + y₂'`, then under `H₂ ≥ H₂'` what is left is below `y₂'`, giving is short of `H₂' ≤ H₂`, and the first line's level falls from there at every step and its net ends: so the level at `T + 1` is at or above `H₂' + y₂'`, and the second unit taking `H₂'` holds from it.

## What to keep

Statement names stay (`greater_need`, `more_use_on_first`); the old proofs through `two_units_iff` go. T0 gets a plain name in the module's words (for instance `unending_above`). The header's sentence about simulations finding the statements true with premises dropped is replaced by what is now proved; the record and 02 §11 follow at the landing, by the coordinator.
