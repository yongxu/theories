AI-written reading, 13 November 2026, of the follow-up to `Becoming.TurningInTime`: the scratch copy at `tmp/r7/tt/lean/Becoming/TurningInTime.lean` compared with the landed one in `~/tmp/tt/wt`. This was a read only, with no build. The implementer's focused build is the evidence that the file compiles.

Line numbers refer to the scratch file.

## (1) Scope of the diff

The diff contains only the following:
- the rename `core_tells` to `core_apart_below_need` (lines 63 and 281-282; the statement is unchanged);
- the private helper `windowAlone_turn` (723);
- `locked_alone` (739);
- `locked_ends_with_net` (766);
- one new clause in the header (104-106), two sentences added in the header's "what is given" paragraph (138-143), and two sentences added to section 6's docstring (647-653).

Nothing else changed. The helper is a disclosed deviation and has no effect on any claim.

## (2) Whether the statements match what is said about them

- The docstring of `locked_ends_with_net` (752-765) is exact. It names every premise: `Raises`, `ReadsShare`, `upper`, `AloneOutside`, `needs`, `un`, `step`, `renews` and `over`. It gives the conclusion: within `s.2` steps, a configuration that conditions nothing and is still `Locked`. It also says that its reading against `lock_outlives_loss` is a reading and not a derivation.
- The docstring of `locked_alone` (733-738) is exact.
- Nothing claims that the lock's own models end. The text says that they need nothing "is how they are built", and that is stated, not derived.

## (3) Whether the theorems duplicate existing laws

None of the five candidate names states either theorem.
- `RuleCapture.locked_stays`, by way of `Pace.stays_turned`, and `ClosedCapture.lock_outlives_loss` are both about `paced`, which starts at step count 0.
- `PoolFromCourse.locked_along` is about `paced (join …)` with side conditions.
- `locked_closed` is `«闭»` on the joined step, not on `windowAlone`.
- `closed_stays_closed` is about the lifted share.

`locked_alone` does the same three-line induction that `Pace.stays` gives for the two-level course. It repeats that induction only because `windowAlone` is `Pace.step fA hA reads` written with `bif` in place of `turn`, and because its start `w` has an arbitrary step count, while `stays` starts from `(c, 0)`. With an equation `windowAlone fA hA reads = Pace.step fA hA reads`, which follows from `windowAlone_turn` by funext, and a start at count 0, the result would be `locked_stays` read through `orbit_paced`. For an arbitrary count the induction is still needed. The law that does the work is `turn_locked`, and the proof uses it directly. That is acceptable.

## (4) Whether the premises can all hold together

They can, so neither theorem is vacuous. Here is a hand-built instance:
- `A = R = Unit` with the trivial preorders, `favours = fun _ => True`, and any `fA` and `hA`. Then `Raises`, `ReadsShare`, `upper` and `Locked` hold trivially.
- `marked = fun _ => False` and `renew w _ = windowAlone fA hA reads w`, so `AloneOutside` holds by rfl and `un` holds trivially.
- `need = 1`, so `needs` holds.
- `left _ x = x - 1`, `g = 0`, `d = 1`, `r = 0`. Then `renews` is `0 ≤ 0` and `over` is `0 < 1`. `step` holds because `x - 1 = x + 0 - 1` (`Nat.add_zero`).
- Start `s = (((), (), 0), 1)`. The line ends at `n ≤ 1` with level 0, still `Locked`.

## (5) Name collisions

`locked_alone`, `locked_ends_with_net` and `core_apart_below_need` are not used by any other `.lean` file in the package, so there is no collision.

## Findings

### High

- **H1. The rename leaves stale references outside the Lean file.** The landed tree in `~/tmp/tt/wt` still cites `TurningInTime.core_tells` in the following hand-written files:
  - `Becoming.lean:5019`, a module overview, unless it is generated;
  - `theories/becoming/chapters/02-MAP.md:502`;
  - `results/records/turning-in-time.json:33` and `:612`;
  - `results/atlas/entries/dynamics.json:1893`;
  - `tmp/r7/tt/landing/02-section-11.md:12`.

  After a render, the generated `lean-index.json`, `atlas.json`, `shared-laws.json`, `families/a.md` and `becoming-core-part-7.md` would also carry the old name. The record would then name a declaration that does not exist, and the checker's record-to-Lean resolution would fail. The rename must be carried to these files in the same landing. The `_process/…/tt-turning-in-time/` design and reader files are history and should stay as they are.

### Medium

- **M1. The new header sentence leaves out what is needed (lines 141-143).** It reads "Where the way's step as it was is the lock's and the level is one the going on needs, a `Locked` start ends `Locked` where the net ends".
  - It is unconditional, but the result needs `Raises`, `ReadsShare`, `upper`, `AloneOutside` with no marked level meeting the need, and the level in `Optimum`'s form with more taken than given at every step (`step`, `renews`, `over`).
  - "the level is one the going on needs" stands for `0 < need` alone, yet the sentence reads as if needing a level were enough for the line to end.
  - The sentence sits in the paragraph that lists what each law needs, so it should list them. A fix: "…a `Locked` start under `turn_locked`'s premises ends `Locked` where the net ends whenever `ends_with_net`'s premises hold (`locked_ends_with_net`)".
- **M2. The same omission appears in section 6's docstring (650-652).** The section's text names `turn_locked`'s premises only through `locked_closed`'s context, and it never names the ending premises. The header bullet at 104-106 has the same problem: "where the level is one the going on needs and the line ends where the net ends" makes the ending sound like a premise, when the theorem proves it from `step`, `renews` and `over`. The bullet should say "under `ends_with_net`'s premises" instead.
- **M3. Section 6's title is no longer accurate (line 632).** The title "The lock's courses as courses of the pair, at a need of nothing" now covers `locked_ends_with_net`, whose need is positive. Either retitle the section (for example "The lock's courses as courses of the pair") or say in its docstring that the last law leaves the need of nothing.

### Low

- **L1. `windowAlone` is `Pace.step fA hA reads` up to `bif` and `match` (717-720, 723-731).** A public equation `windowAlone_eq_step : windowAlone fA hA reads = Pace.step fA hA reads` would make this visible, and `windowAlone_turn` would then follow from it. The helper's proof by term-mode `match` with type ascriptions works, but it is heavier than needed.
- **L2. One sentence now sits awkwardly (653).** "Nothing here re-proves `locked_stays`…" comes right after `locked_alone`, which repeats `locked_stays`' induction on a step equal to `Pace.step`. The sentence is still true, because the statements differ: an arbitrary count, and an orbit rather than `paced`. Adding "(`locked_alone` is its counterpart on `windowAlone` from any step count)" would keep a reader from seeing a contradiction.
- **L3. The name `locked_ends_with_net` repeats `ends_with_net`, which matches the module's style.** `locked_alone` might be read as "locked when alone". Its docstring says it is "along `windowAlone`", so this is acceptable.

## Verdict

The Lean statements are correct, nothing they claim is overstated, and they are not vacuous. Before landing, the rename must reach the records, the chapter, the atlas entry and the landing text (H1), and the three prose sentences must name their premises (M1, M2) and fix the section title (M3).
