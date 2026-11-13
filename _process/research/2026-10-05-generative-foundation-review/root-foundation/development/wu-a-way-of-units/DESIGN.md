*AI-written (Fable), 13 November 2026, 07:33 WIB. The design after three AI readers attacked its first form (`DESIGN-R3-attacked.md`; their reports: `readers/r3-knowing.md`, `r3-readers.md`, `r3-logic.md`). Nothing here is proved until the Lean passes the core run.*

# A way of units: ending that corrects with no mark given

## What the readers changed

- **Narrower claim.** The first form said the marks of `turns_in_time_iff` "all follow". They do not. What is derived is one source of a turn: a unit of the way that uses ends, and its use ends with it. The other source stays given: a way whose step conditions on something that reads (TurningInTime's `marked`; the lock's window `[N, K)`, where readers read; `ReadOffInTime.FourReaders`' gauges, which need more, use nothing, and are read by a selection).
- **Not a reader.** In the package a reader feeds or informs (`ReaderRebuilding`, `PoolFromCourse`, `ClosedCapture`, `FourReaders`). What ends here uses. It is `ReadingsSpread`'s overdrawn focal line, on the centre's own model and in general. The word is **unit** (the root's census word, `ReaderRebuilding`'s "units"), never reader, never part (`Blanket.Parts` is a whole configuration).
- **The loop sentence is dropped.** `ReadingLoop.Loop.law` is total and stores more than its candidates; "a candidate's ending is the same turn" was false of it.
- **G4 needed `S ≠ []`**, and each premise has a counterexample when dropped (`r3-logic.md` §1).
- **G5 cannot be typed on lists.** `AloneOutside` and `uses` quantify over every way. It goes through a two-valued carrier and a transfer.
- **G1, G2, G3 are lemmas**, G6 recounts `Three`. They are kept only as far as the exact condition needs them.

## The model

Module `Becoming.WayOfUnits`, importing `Becoming.TurningInTime`. A unit is a pair of numbers: the level it needs to go on, and what it takes from the level at each step. A way is the list of units present.

```
need u := u.1        use u := u.2                       -- u : Nat × Nat
goes x u := decide (need u ≤ x)
after w x := keep (goes x) w                             -- the root's `keep` (GrammarLaws) or List.filter
taken w   := the sum of `use u` over w                   -- by recursion; no import for a sum
left giving w x := RegimeMargin.step giving (taken w) x  -- every unit present at the step takes
Goes s    := ∃ u, u ∈ s.1 ∧ need u ≤ s.2                 -- some unit goes on
net giving := Law.stepWhile Goes (TurningInTime.pair after (left giving))
Holds giving y s := s.1 ≠ [] ∧ (∀ u, u ∈ s.1 → need u ≤ s.2) ∧ taken s.1 + y (taken s.1) ≤ s.2
```

## Theorems

**W1 `unending_iff_holds` (the content).** Every unit of `w` needs something (`0 < need u`), nothing given from nothing, `x ≤ hi`, and at every way `S` the course passes through while the net goes on, `Short giving (taken S) (y (taken S))`, `Meets giving (taken S) (y (taken S)) hi`, `Keeps giving (taken S) hi`. Then

`«不穷» (net giving) «一» (w, x) ↔ ∃ k, (∀ j, j < k → Goes (orbit j)) ∧ Holds giving y (orbit k)`

where `orbit` is `Law.orbit (TurningInTime.pair after (left giving)) (w, x)`. In words: the line never ends exactly where, the net going on until then, it comes to units all of whose needs are met at a level from which what they take together holds. The premise may instead be stated over the sub-ways of `w`, if that reads better and is not weaker to use; say which in the docstring. Proof route: `r3-logic.md` §2 (bound, holding, falling, induction on a bound on the way's length; excluded middle only over finite lists and bounded ranges).

**W2 `two_units_iff` (the tie to the centre).** For `w = [(m, h), (n, H₂)]` with `n ≤ m`, under `turns_in_time_iff`'s regime premises with `H₁ := h + H₂` and `need := n`:

`«不穷» (net giving) «一» ([(m, h), (n, H₂)], x) ↔ ∃ T, (∀ j, j < T → m ≤ X j) ∧ n ≤ X T ∧ X T < m ∧ H₂ + y₂ ≤ X (T + 1)`

with `X j := Law.orbit (RegimeMargin.step giving (h + H₂)) x j`, the level as it was. By `turns_in_time_iff` on the carrier `Bool` (the first unit present) with `marked := (· < m)`, `alone := id`, `Kept b := b = false`, and a transfer: from this start, the units' line and the carrier's line never end together. `AloneOutside`, `turns`, `kept`, `uses`, `uses₁` are proved for that carrier, not assumed. The start that already holds with both units is outside W2 (`below`); W1 covers it.

**W3 `greater_need`.** Under W2's premises, for `m ≤ m'`: if the line with the first unit needing `m` never ends, neither does the line with it needing `m'`. By the course as it was never rising. False without `below` (`r3-logic.md` §1, G7).

**W4 `more_use_on_first`.** Under W2's premises for both, the same needs and the same sum `h + H₂ = h' + H₂'` with `h ≤ h'`: if the line with the first unit taking `h` never ends, neither does the line with it taking `h'`. The course as it was is the same; the level from which the rest holds is not higher (`H₂' + y₂' ≤ H₂ + y₂`, from `Short` at `H₂'` and `Meets` at `H₂`).

**W5 `takes_nothing_ends`.** Under W2's premises with `h = 0`: the line ends. A unit that takes nothing, by ending, changes nothing in the level's course.

**W6 Witnesses** (giving `min z (12 − z)`, from nine, both ways taking five as they start, needs nine and one). `With`: units `(9, 4)` and `(1, 1)`: levels 9, 8, 6, 10, 12, 12, …; the line never ends. `Against`: units `(9, 1)` and `(1, 4)`: levels 9, 8, 6, 4, 0; the line ends. Same needs, same level up to the ending; what differs is which unit carries the use.

**Lemmas as needed**, not advertised: a unit is present after `n` steps exactly where it was present and its need was met at every step before; `after w x = w` exactly where every unit's need is met; the level stays within `hi`.

**One statement on the turn**, only if short: where `x` is below the need of one unit of `w` and meets the need of another, `(w, x)` conditions something in the net and ends under the way's class (the line under the way's class ends while the net goes on). `kind_ends_while_net_goes` is for TurningInTime's net; this is the same fact for the units' net.

## What it lets someone see

- A turn needs no mark where what ends was taking: units end until what remains holds, or until none goes on.
- Whether ending corrects is settled by which units carry the use: the same needs and the same sum taken go on for ever or end (W6), and more of the use on the unit that ends first never ends the line (W4).
- An ending that takes nothing with it corrects nothing by itself (W5). It can only be read. That is where TurningInTime's given marks, the lock's window and FourReaders' gauges still stand as given.

## What it does not show (say so in the header)

- Units only end. Nothing builds a unit, and nothing derives that a unit which needs more is there.
- `m`, `n`, the uses and `y` are parameters; `Short`, `Meets`, `Keeps`, `FromNothing` are premises on the giving, as in TurningInTime.
- The marks of a way that conditions on a reading are not derived: TurningInTime's `marked` is a property of levels, and here the level at which the way changes depends on the way.
- W3, W4, W5 are for two units below `H₁ + y₁`. The comparison for any number of units is not stated.
- Readings, not theorems: that `ReadingsSpread`'s overdrawn focal line is such a unit; that `FourReaders`' gauges are the case W5 says must be read; anything about shielding. Nothing about a trained system.

## Rules for the Lean

No axioms (no `omega`, `simp`, `Classical`, `propext`, `decide_eq_true_eq`; `of_decide_eq_true` and `decide_eq_true` are fine), no warnings, every declaration with a docstring that names its premises. "Theorem" for a proved statement, "law" only for `Law`. No reader, part, candidate, shed, shield, canary in names or docstrings. A unit is not a doer: it "goes on", "ends", "takes"; the way "takes" what its units take. One permitted edit outside the new file: `TurningInTime.regime_levels` may lose `private` if W3 needs it; nothing else in a landed module changes.
