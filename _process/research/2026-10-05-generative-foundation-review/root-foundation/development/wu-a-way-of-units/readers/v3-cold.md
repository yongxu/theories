AI-written (Opus reader), 13 November 2026

# v3 cold read: `Becoming.WayOfUnits` as it now stands

Read only: `lean/Becoming/WayOfUnits.lean` (902 lines) against DESIGN.md, r3-logic.md, TurningInTime.lean, RegimeMargin.lean, Continuation.lean, ReadingsSpread.lean and ReadOffInTime.lean. I built nothing and ran no Lean, checker, gate or test. `build.log` reports 66 declarations, 47 theorems, `with_axioms: {}`. The python is in the session scratchpad, `v3/sim.py` and `v3/sim2.py`. I wrote my own findings first, then read v1 and v2.

## 1. Header sentences against theorems

**"What the package already has."** Every name exists with the namespace given (`Flow.family_ends_below_at`, Continuation.lean:480; `ReadingsSpread.Commons.overdrawn_spreads_then_ends`, :1222; `RegimeMargin.ends_below`, `holds`). Each summary carries its premises and matches the cited docstring. The `turns_in_time_iff` summary includes "the need met there and at every step before".

**"What this module adds."**
- *A way of units*: the definitions say what is written. The `ends_while_net_goes` sentence is exactly the theorem (`«亡»` under `sameValue Prod.fst`, plus a next).
- *Any number of units*: this is `unending_iff_holds`. The premises in the header match the Lean: `along` is asked at `k` with `Goes` at every `j ≤ k`, so the start is included and the stopping configuration is not. `With.goes_on_holds` is a real witness that the premises can be met together (`y := id`, `hi := 12`).
- *Two units*: this is `two_units_iff`, and the right side reads as said. `first_outside` … `first_uses₁` prove the five TurningInTime premises at the stated choices. The header now says `unending_iff_carrier` "never ends exactly where".
- *Comparisons*: these are `greater_need` (through `level_le_of_le`) and `more_use_on_first`. They are proved as stated, under every premise of `two_units_iff`.
- *Takes nothing*: `takes_nothing_iff_alone` takes only `order`, under any giving and from any start, as stated. `takes_nothing_ends` takes `order`, `nothing`, `needs`, `short₁` and `below`. With `h = 0`, `y₁` is the margin at `H₁ = H₂`, so "the second unit's own point of no return" is right.
- *Two ways*: recomputed in §2.

**"What is given and what is not shown."** Every sentence has a theorem, or is marked as a reading or a non-claim. The exceptions are the minor points in §3. The simulation sentence (greater_need without the bound below `h + H₂ + y₁`; more_use_on_first without the regime at `H₂`) is confirmed below.

## 2. Simulations (all premises as in the Lean; `step g H x = (x-H) + g(x-H)`, truncated)

| statement | cases with every premise | of which never end | failures |
|---|---|---|---|
| `unending_iff_holds` (needs ≥ 1, ways of 1 to 3 units, every valid `y` per use enumerated, `along` checked only along the prefix with `Goes`) | 74 866 | 1 892 | 0 |
| `two_units_iff` (targeted: `y₂`, `y₁` roots) | 97 806 | 3 914 | 0 |
| `greater_need` (on the never-ending cases, random `m' ≥ m`) | 3 914 | | 0 |
| `greater_need` with `below` dropped | 26 406 | | 0 |
| `more_use_on_first` | 1 935 | | 0 |
| `more_use_on_first` with Short, Meets, Keeps and `within` at `H₂` dropped | 662 | | 0 |
| `takes_nothing_iff_alone` (any giving, `g 0` free, any start) | 50 000 | | 0 |
| `takes_nothing_ends` | 10 086 | | 0 |

r3-logic's G7 counterexample to "greater_need without `below`" (`g=[0,3,6,3,7,1,6,4,7,0,5,6,4,0]`, `(m,1),(4,5)`, from 8) breaks `Meets` at `H₂ = 5` for every `hi ≥ 8`, since `g 3 = 3 < 5`. So it is not a counterexample under the module's other premises, and the header's sentence stands. DESIGN.md's W3 line ("False without `below`") is now stale, but it is not in the module.

**The witnesses, by hand and in python.**
- `With [(9,4),(1,1)]` from 9 runs (way,9), (way,8), ([(1,1)],6), 10, 12, 12.
- `Against [(9,1),(1,4)]` runs (way,9), (way,8), ([(1,4)],6), 4, 0, and `Goes` fails at 0.
- The course as it was under 5 runs 9, 8, 6, 2, 0.
- `goes_on`'s numbers hold:
  - `Short g 1 1`, `Meets g 1 1 12` (`g 11 = 1`), `Short g 5 5`;
  - `9 < 10`;
  - `T = 1`, `X 1 = 8 < 9`, `X 2 = 6 ≥ 2`.
- `goes_on_holds` holds:
  - `Regime` at use 5 with `y 5 = 5`: `Meets` for z = 5, 6, 7, and `Keeps`;
  - at use 1 with `y 1 = 1`;
  - `Holds` at step 2, since 1 + 1 ≤ 6.

## 3. Findings open now (none is wrong; all are minor or word)

1. **Header, the "start that already holds" sentence, says Keeps where only Meets is extra.**
   - The sentence: `unending_iff_holds` "ask[s] `Meets` and `Keeps` at `h + H₂` with `y (h + H₂)` too, where `two_units_iff` asks only `Short` there".
   - `Keeps` at `h + H₂` follows from `two_units_iff`'s `keeps` (at `H₂`) and `nothing`. For `x ≥ h`, `step g (h+H₂) x = step g H₂ (x - h)`, and otherwise it is `g 0 = 0`. v2 made the same observation.
   - Only `Meets` at `h + H₂` is really extra.
   - Fix: "which ask `Meets` at `h + H₂` with `y (h + H₂)` too (`Keeps` there follows from `Keeps` at `H₂` and nothing from nothing)".
2. **Header, the same passage: the starts outside `two_units_iff` are more than those that hold.**
   - Every start at or above `h + H₂ + y₁` is outside, for example one below `m` that does not hold, and so is every start above `hi`.
   - The sentence is true, but a reader may take "a start that already holds" as the whole gap.
   - Fix: "A start at or above `h + H₂ + y₁`, a start that already holds with both units among them, is outside `two_units_iff`".
3. **Header, the simulation sentence names one dropped premise per theorem.** v2 also found `short₁`, `within` and `needs` not needed for `greater_need`, and `within'`, `needs`, and one of `Keeps`/`below` for `more_use_on_first`. "Some of them" keeps it true, but it gives no place where the evidence can be rechecked. Fix (optional): "(among others: …)", with a pointer to where the simulation is kept once it lands.
4. **Word: a unit as a doer.**
   - `takes_nothing_iff_alone`'s bold line says "A unit that takes nothing, there or ended, leaves the line as the other unit's alone". "Leaves" makes the unit act. Fix: "With a unit that takes nothing, there or ended, the line is the other unit's alone (exact)."
   - The header's last bullet says "which unit carries the use differs". "Carries" is milder but of the same kind. Fix: "which unit takes the larger use differs".

## 4. v1 and v2 findings, against the file as it now stands

**v1 (statements)**
1. `takes_nothing_ends` restated `ends_below`. **Closed**: `takes_nothing_iff_alone` is added (only `order`), `takes_nothing_ends` has only its five premises, and the header points at the new theorem.
2. "never end together". **Closed** ("never ends exactly where").
3. "covers it" without premises. **Closed** ("under its own premises …"). The Keeps precision in §3.1 remains.
4. `course_within` docstring. **Closed** ("only its third clause, `Keeps`, is used").
5. Restatements. **Closed**:
   - the local `length_pos_of_mem` and `ge_of_not_lt` are gone, and the module uses `Becoming.length_pos_of_mem` and `Nat.ge_of_not_lt`;
   - `level_le_start`, `level_le_of_le` and `orbit_id_true` each name what they re-prove and why.
6. "While the net goes on". **Closed**: `along` is now `∀ j, j ≤ k → Goes`, and the docstrings say so ("not at the way where the net stops").
7. No witness for `unending_iff_holds`. **Closed** (`With.goes_on_holds`). `Against` through it is not given; that was optional.
8. Package summary drops premises. **Closed**.
9. "List lemmas" heading. **Closed** ("On lists and on steps").

**v2 (premises)**
1. Nothing false. Still so (§2).
2. `along` asked one configuration too far. **Closed** (`j ≤ k`).
3. W2's premises do not give W1's `along` at `h + H₂`. **Closed** in substance: the header says W1 asks more there. §3.1 is its remaining precision: only `Meets` is extra.
4. "`greater_need` false without the bound". **Closed**: the header and the docstring now say the opposite, and both are confirmed. The other droppable premises: see §3.3.
5. `more_use_on_first`'s extra premises. **Closed** as far as the header names "the regime at `H₂`", which is confirmed. The rest: §3.3.
6. W5 is `ends_below`. **Closed** by `takes_nothing_iff_alone` and the reduced premise list.

## 5. Sound and worth keeping

- `unending_iff_holds` is the module's content. It is exact, its `along` is asked along the course only, and it has a witness from two units.
- The `Bool` carrier and transfer prove TurningInTime's five premises instead of assuming them. They tie the new net to `turns_in_time_iff`, and `two_units_iff` reads cleanly.
- `takes_nothing_iff_alone` is a sharper statement than the design asked for.
- The header separates theorems, premises, readings and simulation evidence carefully.
