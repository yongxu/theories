AI-written (Opus reader), 13 November 2026

# v2 premises: `Becoming.WayOfUnits` by simulation

Read only. Nothing was built or run in Lean. The python translation is in `/private/tmp/claude-501/-Users-ren-theories/3c343411-bb06-4ddc-aa7a-5f9cd79133ad/scratchpad/v2/`. `wu.py` holds the definitions; `w1*.py`, `w2*.py`, `w345.py`, `w34b.py`, `d3fast.py`, `reduced.py` and `hand*.py` hold the tests.

The translation follows the Lean exactly:
- `need`, `use`, `goes` and `after` (keep in order, repeats kept) and `taken` (a sum, repeats counted).
- `left` = `RegimeMargin.step g H x = (x - H) + g (x - H)`, with truncated subtraction.
- `Goes`; the net = `stepWhile Goes (pair after left)`. "Never ends" = `∀ n, Goes (orbit n)`, decided exactly by cycle detection, since the state space is finite: `g` is a table on `0..40` and `0` beyond.
- `Holds`, `Regime` = `Short ∧ Meets ∧ Keeps` at `taken S` with `y (taken S)`, and `FromNothing`, all as in `RegimeMargin.lean:249–265`.
- W2 to W5 use the as-it-was course `X = orbit (step g (h+H₂)) x`. In W2's right side, `T` is forced to be the first index with `X T < m`.

Givings used: tents `min z (c−z)` for c = 4..24, `min(2z, z+2)`, `min(az, b)`, random tables (half of them rising), random humps with perturbations, and tables with `g 0 > 0` for the `FromNothing` drops. Ways have 0 to 4 units, with repeated units and needs of 0. Starts reach above `hi` and include starts that already hold.

## 1. Is any statement false as written?

**No.** There were 0 failures in every test:

| theorem | cases with all premises | failures |
|---|---|---|
| `unending_iff_holds` (W1) | 11 006 (mixed), ~42 000 (structured runs) | 0 |
| `two_units_iff` (W2) | 15 155 + 70 330 + 102 465 | 0 |
| `greater_need` (W3) | 890 (line never ends at `m`) | 0 |
| `more_use_on_first` (W4) | 339 (134 with `h' > h`) | 0 |
| `takes_nothing_ends` (W5) | 24 682 | 0 |
| `ends_while_net_goes` | 100 000 random `(w, x)` with such `p`, `q` | 0 |

**Witnesses, recomputed.**
- `With` `[(9,4),(1,1)]` from 9: `(way,9) (way,8) ([(1,1)],6) ([(1,1)],10) ([(1,1)],12) ([(1,1)],12) …`, and the line never ends.
- `Against` `[(9,1),(1,4)]`: `(way,9) (way,8) ([(1,4)],6) ([(1,4)],4) ([(1,4)],0)`, and `Goes` fails there, so the line ends.
- The course as it was under 5 is 9, 8, 6, 2, 0 in both.
- All of W2's premises hold at `y₁=5`, `y₂=1` (With) and `y₂=4` (Against), `hi=12`. The right side is true for With and false for Against.
- W1's `along` (with `y` = least root) also holds for both, and W1 agrees with both.
- `levels`, `turns_and_ends` and the header's numbers ("9, 8, 6, 10, 12, 12" and "9, 8, 6, 4, 0"; first unit ended at 8; `H₂ + y₂ = 2`) are all correct.

## 2. Each premise dropped

In each row only the named premise fails; the others hold (y values enumerated).

### W1 `unending_iff_holds`. Every premise is needed.

| dropped | counterexample | left / right |
|---|---|---|
| `needs` | `g=[0,0,1,1,1,1,1,2,2,2,3,3,4]`, `hi=11`, `w=[(1,1),(0,3),(2,0)]`, `x=2`: `(0,3)` lives at level 0 forever | T / F |
| `nothing` | `g=[3,8,6,2,7,4,4,0]`, `hi=6`, `w=[(5,4),(2,5),(8,2),(2,5)]`, `x=2` | T / F |
| `high` | `g=[0,6,0,5,7,4,3,3,7,3,6,7,5,8]`, `hi=12`, `w=[(2,0),(4,6),(7,4),(4,0)]`, `x=15` | F / T |
| `Short` clause | tent 16, `hi=22`, `[(3,3),(5,2)]`, `x=18`, `y` above the root | T / F |
| `Meets` clause | `g=[0,3,7,2,8,0,3,2,1,0,2,5,1,8]`, `hi=12`, `[(5,0),(2,4),(10,3)]`, `x=12`, root `y` | F / T |
| `Keeps` clause | `g=[0,8,2,7,0,7,7,5,8]`, `hi=7`, `[(2,3),(2,3)]`, `x=7`: 7, 9, 10, 4, 0 | F / T |

**`along` is stronger than the proof uses.** It is asked at every `k` with `∀ j < k, Goes`. That includes the first configuration where the net stops: a way none of whose units goes on, or `[]` when `w = []`. The proof never uses it there:
- `reaches_holds` has `Goes k` at every k.
- In the reverse direction, `Holds k` implies `Goes k`.
- `course_within` is only called below such a `k`.

With `along` weakened to `∀ k, (∀ j ≤ k, Goes) → Regime …`, the iff held in all 57 037 cases where the weaker premise holds (0 failures). It held in about 75% of random tent cases, against 52% for the Lean's form. For `w = []` the Lean's form requires `Keeps g 0 hi`, which is `x + g x ≤ hi` for all `x ≤ hi`, so W1 is almost never applicable to the empty start. That is harmless, because the line ends there anyway. The docstring's "at every way the course passes through while the net goes on" describes the weaker form. The Lean asks one way more.

**How often `along` holds.** These are 20 000 random cases per family: ways of 1 to 4 units, positive needs, `x ≤ hi`, `y` = least root.

| family | along (course) | over every sub-way | never ends | never ends and along |
|---|---|---|---|---|
| tents | 52% | 14% | 3 896 | 577 |
| `min(az,b)` | 52% | 0% | 4 511 | 544 |
| `min(2z,z+2)` | 29% | 0% | 5 522 | 49 |
| random | 45% | 0.2% | 3 523 | 67 |

- The course form is about four times as applicable as the sub-way form. The choice in the Lean is the right one.
- Among the lines that never end, `along` often fails. The failing clause is `Meets` (hi above the hump's return point) or `Keeps` (givings that grow without bound).
- With `hi` chosen freely (x ≤ hi ≤ 40), 71% of the never-ending tent lines admit a `hi` that makes `along` hold. For the unbounded families the figure is 8 to 16%.
- Most of the cases where `along` holds are lines that end; the "holds" side is the rare one. This is RegimeMargin's regime, not a defect of this module, but it is how rarely W1's content (left side true) can be applied.

**W2's premises do not imply W1's `along`.**
- They give `Short` at `h + H₂` (`short₁`).
- They give `Keeps` at `h + H₂`: from `Keeps` at `H₂` and `FromNothing`, `step g (h+H₂) x = step g H₂ (x−h)` for `x ≥ h`, and it is `g 0 = 0` otherwise.
- They do not give `Meets` at `h + H₂` for any `y`. Over 102 465 W2-premise cases, 230 have no `y` with `Short ∧ Meets` at `h + H₂`. Example: `g=[0,3,1,1,3,5]`, `hi=4`, `m=4`, `h=1`, `n=1`, `H₂=1`, `y₁=y₂=1`, `x=2`.
- So the header's line that W1 "covers" the start outside W2 holds only when `Meets` and `Keeps` also hold at `h + H₂`. r3-logic §3 says this; the header does not.

### W2 `two_units_iff`. Every premise is needed.

| dropped | counterexample | left / right |
|---|---|---|
| `order` | tent-like `[0,1,2,2,2,2,2,2,2,0,1,0,0]`, `hi=10`, `m=0`, `h=0`, `n=4`, `H₂=3`, `y₁=0`, `y₂=8`, `x=0` | T / F |
| `nothing` | `[3,8,8,2,4,6,7,0]`, `hi=5`, `m=8`, `h=6`, `n=1`, `H₂=5`, `y₁=0`, `y₂=1`, `x=3` | T / F |
| `short` | `hi=23`, `m=12`, `h=5`, `n=6`, `H₂=0`, `y₁=16`, `y₂=9`, `x=20` | T / F |
| `meets` | `[0,4,5,3,1,4,4,2,2,1,2,1,2,0]`, `hi=11`, `m=12`, `h=1`, `n=7`, `H₂=5`, `y₁=6`, `y₂=2`, `x=11` | F / T |
| `keeps` | `[0,6,7,7,7,0,0,7,2,7,7,6,1]`, `hi=10`, `m=11`, `h=2`, `n=6`, `H₂=6`, `y₁=3`, `y₂=1`, `x=10`: levels 10, 9, 10, 11, 5, end | F / T |
| `needs` | `[0,3,3,3,4,4,8,5,0]`, `hi=6`, `m=8`, `h=0`, `n=0`, `H₂=3`, `x=3` | T / F |
| `within` | `hi=13`, `m=9`, `h=5`, `n=7`, `H₂=0`, `y₂=0`, `x=13` | F / T |
| `short₁` | tent-hump `[0,3,6,9,12,12,12,12,11,…,1,0]`, `hi=19`, `m=5`, `h=1`, `n=4`, `H₂=6`, `y₁=7`, `y₂=2`, `x=13` | T / F |
| `below` | same giving, `y₁=0` | T / F |
| `high` | `[0,5,5,5,2,0,6,7,8]`, `hi=6`, `m=9`, `h=0`, `n=6`, `H₂=6`, `x=8` | F / T |

The `keeps` counterexample needed a targeted search: 86 604 random cases found none, and a hump search found it.

### W3 `greater_need`. Four premises are not needed.

Needed:
- `order` (`m=0`).
- `more` (m' < m).
- `nothing`.
- `Short` at `H₂`: built by hand, `g=[0,1,2,0,2,0,…]`, `hi=12`, `h=1`, `n=1`, `H₂=2`, `y₁=10`, `y₂=11`, `x=12`, `m=10`, `m'=13`. With `m` the line is 12, 9, 6, 6, … and never ends. With `m'` it is 12, 9, 7, 5, 3, 2, 0 and ends.
- `Meets` at `H₂`: the same giving with `y₂=2`.
- `Keeps`: `g=[0,6,7,7,7,0,0,7,2,…]`, `hi=10`, `m=10`, `m'=11`, `h=2`, `n=6`, `H₂=6`, `y₁=3`, `y₂=1`, `x=10`. With `m'` the levels are 10, 9, 10, 11, 5, end.
- `high`: `g=[0,5,4,0,…]`, `hi=6`, `m=9`, `m'=15`, `h=1`, `n=4`, `H₂=5`, `y₁=9`, `y₂=1`, `x=14`. With `m'` the levels are 14, 8, 3, 0.

**Not needed, each dropped alone:** `needs`, `within`, `short₁`, `below`.
- No counterexample turned up in 319 341 conclusion-violating pairs scanned (`d3fast.py`) or in the reduced runs (1 548 without `below` and `short₁`, 464 without `within`).
- Argument for dropping `below` and `short₁`:
  - `Keeps` at `H₂` with `FromNothing` keeps `X ≤ hi`.
  - Under `Short` at `H₂` and `h ≥ 0`, a level `L < H₂ + y₂` of `X` falls strictly at the next step. `z = L − h − H₂ < y₂`, so `g z < H₂` and the next level is below `L`.
  - So `X(T'+1) < H₂ + y₂` would force `X(T+1) < H₂ + y₂`, and the line with `m` would end.
  - If `X` never goes below `m`, it never enters `[m, H₂+y₂)`, for the same reason.
  - `Meets`, `Keeps` and `within` then give that the second unit alone holds from `X(T'+1)`.
- `needs`: with `n = 0` both lines never end.
- `within`: with `below` kept, `X` does not rise, so `X(T'+1) ≥ X(T+1) ≥ n`.
- Dropping `below` and `within` together: no counterexample in 4 253 cases. I have not argued this case.

**The header's sentence "`greater_need` is false without that bound (a counterexample was found by simulation, not in Lean)" is not supported for the Lean's premise set.**
- The counterexample it rests on is r3-logic G7: `g=[0,3,6,3,7,1,6,4,7,0,5,6,4,0]`, `(m,1),(4,5)`, from 8. Over every `hi ≥ 8`, `y₂` and `y₁`, it also fails `Meets` or `Short` at `H₂`. Its smallest failing sets are `{meets, below}`, `{meets, short₁}`, `{short, below}` and `{short, short₁}`.
- With every other premise of `greater_need` kept, the bound is not needed (argument above).
- The bound is used by the proof, not needed by the statement.

### W4 `more_use_on_first`. About half the premises are not needed.

Needed:
- `order`: `[0,3,3,3,3,2,3,4,3,…]`, `m=4`, `n=12`.
- `sum`: `h'=4`, `H₂'=3` with `h+H₂=6`.
- `more`: `h'=0`, `H₂'=7`.
- `high`, built by hand: `g=[0,5,6,0,4,0,…]`, `hi=6`, `m=12`, `n=4`, `(h,H₂)=(1,6)`, `(h',H₂')=(2,5)`, `y₁=5`, `y₂=2`, `y₂'=1`, `x=11`. The first line runs 11, 8, 8, … and never ends. The second runs 11, 8, 3, and ends.

**Not needed:** `Short`, `Meets` and `within` at `H₂`; `within'`; `needs`. Also any one of `Keeps` at `H₂` or `below`/`short₁`, dropped alone.
- No counterexample turned up: 236 violating pairs scanned with all `y` enumerated; reduced runs of 422 cases with only `{order, nothing, Short', Meets', Keeps', sum, more, high, below, short₁}`, and 4 339 cases with `Keeps` in place of `below`; 0 failures.
- 61 of those cases had W4's own regime at `H₂` failing and the conclusion still true.
- Argument:
  - The two lines share `X` and `T`.
  - If the line with `h` never ends and `X(T+1) < H₂' + y₂'`, then the second unit taking `H₂ ≥ H₂'` falls strictly from `X(T+1)`. The reason is `Short'`: `g z < H₂' ≤ H₂` for `z < y₂'`. It reaches 0, so the line with `h` ends, a contradiction.
  - So `X(T+1) ≥ H₂' + y₂'`. Also `X(T+1) ≥ n`, `X(T+1) ≤ hi` (by `below`+`high`, or by `Keeps`+`high`), and `Meets'`, `Keeps'` hold.
  - These give that the line with `h'` never ends.
- The docstring's route (`y₂' ≤ y₂` from `Meets` at `H₂`) is valid, but it is the reason the premise list is longer than the statement needs.
- `Short'`, `Meets'` and `Keeps'` are used by this argument. I did not build counterexamples for dropping them.

### W5 `takes_nothing_ends`. Five premises are not needed.

Needed: `nothing`, `short₁`, `below` and `needs`, plus `order`, which is only used to get `0 < m`. Counterexamples:
- `below`: `x=15`, `H₂=2`.
- `short₁`: `[0,3,3,…]`, `H₂=1`, `y₁=2`, `x=2`.
- `needs`: `n=0`.
- `nothing`.
- `order` with `m=0`.

**Not needed:** `short`, `meets`, `keeps` and `within` at `H₂`, and `high`.
- No counterexample turned up among 268 207 never-ending cases scanned. A reduced run with only `{nothing, short₁, below, 0<n, n≤m}` had 0 failures in 66 311 cases.
- Reason: with `h = 0` the way takes `H₂` whether the first unit is there or not. So the level is exactly `orbit (step g H₂) x`, which comes to 0 by `RegimeMargin.ends_below` (from `short₁`, `nothing` and `below`). Every need is positive, so the line ends.
- The theorem is `ends_below` with positive needs. The docstring's route through `two_units_iff` and `y₁ ≤ y₂` is correct but roundabout. "Under `two_units_iff`'s premises" asks five premises the statement does not use.

## 3. Findings, in short

1. Every statement is true as written on every case tried, and both witnesses recompute exactly.
2. W1 and W2: every premise is needed. W1's `along` is asked one configuration further than the proof uses: the configuration where the net stops.
3. W2's premises do not imply W1's `along`, because `Meets` at `h + H₂` is missing (230 / 102 465 cases).
4. W3: `below`, `short₁`, `within` and `needs` are each not needed. The header's "false without that bound" rests on a counterexample that also breaks `Meets` or `Short` at `H₂`.
5. W4: `Short`, `Meets` and `within` at `H₂`, `within'` and `needs` are not needed. So is one of `Keeps`/`below`.
6. W5: `short`, `meets`, `keeps`, `within` and `high` are not needed. It is `ends_below` with positive needs.
