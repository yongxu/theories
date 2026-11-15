# Brief: stage C, on the lock (in scratch only)

*AI-written (Fable, holding the design; board row DJ), 16 November 2026. For the implementer. Nothing here is proved. It adds to `Becoming/TurningInTime.lean`; every existing statement in that module stays byte for byte.*

## The task

Add two things to the scratch copy of `TurningInTime.lean` and get it to build with every axiom report empty and no warning. Touch no tracked file. Land nothing.

- Package (PKG): `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`. No Mathlib.
- Scratch tree (SCR): `/Users/ren/theories/tmp/r7/one-model/lean-scratch/`. `SCR/Becoming/TurningInTime.lean` is there and equals the tracked one: edit it (additions only). `SCR/Becoming/LineOnAStock.lean` is another stage's file: do not edit it, but it must still build after your change (build it last).
- Build, from PKG, in the background, with a log: `LEAN_TIMEOUT=3600 python3 -B scratch_build.py /Users/ren/theories/tmp/r7/one-model/lean-scratch/ Becoming.TurningInTime Becoming.LineOnAStock > /Users/ren/theories/tmp/r7/one-model/lean-scratch/buildC<N>.log 2>&1`. One build at a time; before each, `uptime`, and `ps` for a `lean`, `scratch_build` or `check_becoming` still alive. Never run `check_becoming.py` with any flag.
- Not allowed: `omega`, `simp`, `funext`, `Classical`, `propext`, `native_decide`, `sorry`, any axiom. `decide` only on small closed facts.
- Docstrings: plain sentences saying exactly what the Lean proves, premises named, what is given said as given. On 15 November this module's telling was wrong three times with a green build; a reader who did not write the proof will check each docstring against its statement.

## 1. A way whose draw rises as it goes on as it was ends, with no overdraw given

Today `ends_with_net_regime` (line 550) takes the overdraw as given: `uses : ∀ j, H ≤ use (Law.orbit alone w j)` and `below : x < H + y`, with `short : RegimeMargin.Short giving H y`. Prove, resting on it:

```lean
theorem ends_with_net_rising {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    {w : W} {x : Nat} (high : x ≤ hi)
    (rises : ∀ j, use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
    ∃ n t, «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit alone w n
```

Route: `Keeps giving 0 hi` gives `giving z ≤ hi` for `z ≤ hi`, so `RegimeMargin.Short giving (hi + 1) (hi + 1)`, and the level never passes `hi`. After `hi + 1` steps as it was the use is at least `hi + 1`. Either the net ended before then, or its configuration there is the as-it-was one and `ends_with_net_regime` applies from it with `H := hi + 1`, `y := hi + 1`. Add a bound on `n` if it comes cheaply (`2 * hi + 2` or what you find), and say what it is.

Then on the lock, in the form of `locked_ends_with_net_regime` (line 1222) with `draws` and `below` gone:

```lean
theorem locked_ends_rising … (raises) (monotone) (upper) (outside : AloneOutside marked (windowAlone fA hA reads) after)
    (needs) (un) (nothing) (keeps : RegimeMargin.Keeps giving 0 hi) (high : x ≤ hi)
    (locked : Locked M favours hA (w.1, w.2.1))
    (more : ∀ v : A × R × Nat, P.le w.1 v.1 → M.le w.2.1 v.2.1 → use v < use (windowAlone fA hA reads v)) :
    ∃ n t, «迭» … n (w, x) t ∧ (∀ v, ¬ net … t v) ∧ t.1 = Law.orbit (windowAlone fA hA reads) w n ∧
      Locked M favours hA (t.1.1, t.1.2.1)
```

and the case that derives `more`: the share is a number of drawers (`A = Nat` with `Three.shareOrder`'s order, or state it for `Nat.le` directly), every favouring rule raises it (`∀ a g, favours g → a < fA a g`), and the use is that number times a positive amount (`use v = v.1 * u`, `0 < u`). In `Three`: with `riseShare`, `lockRead`, and a use that reads the share (one per drawer), from `((3, true, 0), 12)` the shares are 3, 4, 5, 6, 7, 8, 9, 10 and the levels 12, 12, 12, 12, 12, 10, 4, 0 (computed by the brief's author on 16 November) and the line ends still `Locked`; at the start the draw of three is held at twelve, so no overdraw is there at the start. Check the numbers by your own computation first. Say in the docstring that `Three.rise_lock_ends` took the overdraw as given and this does not.

## 2. A correction that reaches what the rule is set from

Step 2 found: a reading that sets the rule alone is undone wherever the level is not read, because the rule is read off the share again (`Three.read_at_eight_ends`: 9, 8, 6, 6, 2, 0). Now let the reading also set the share.

- Define the window's step with the share set too, for a window that reads at every step (keep `windowAfter` as it is; a new definition beside it):
  `windowAfterShare fA hA sA hL N K w x` = `(sA (w.1, x) w.2.1, hL (w.1, x) w.2.1, w.2.2 + 1)` where `N ≤ x ∧ x < K`, and `windowAlone fA hA (fun _ => true) w` elsewhere. Prove it is `AloneOutside` for the marks `N ≤ x ∧ x < K`.
- The law, resting on `turns_in_time_iff` (line 905) with the kept kind `Low v.1 ∧ kept v.2.1`. Premises beyond that theorem's regime premises:
  `sets : ∀ p g, N ≤ p.2 → p.2 < K → Low (sA p g) ∧ kept (hL p g)` (a reading sets the share low and the rule to the corrected kind);
  `lowRule : ∀ a g, Low a → kept (hA a g)` (off a low share the rule read is of the corrected kind);
  `lowStays : ∀ a g, Low a → kept g → Low (fA a g)` (under a corrected rule a low share stays low);
  `uses : ∀ v, Low v.1 → kept v.2.1 → use v = H₂`;
  and for the way as it was, as in `locked_turns_in_time_on_window_iff` (read how it gets `uses₁` from `Locked` and `draws`): `Locked … (w.1, w.2.1)`, `draws`, `below : x < H₁ + y₁`, `high : x ≤ hi`.
  Conclusion: the same iff as `turns_in_time_iff` for `net need (windowAfterShare …) …`, with the marks `N ≤ · ∧ · < K`.
- A second statement: on that net's course, from the step after the first reading on, every configuration has a low share and a rule of the corrected kind (what goes on is the corrected rule). State it for the course of `TurningInTime.pair (windowAfterShare …) …` in the plainest true form you can prove (for example: if the level at step `T` is in the band then for every `k` the configuration at step `T + 1 + k` has `Low` share and `kept` rule).
- In `Three`: `Low a := a < 3`, `kept g := g = false`, `sA _ _ := 0`, `hL := noRule`, share step `lockShare` (and, if cheap, `riseShare`), the band `[8, 9)`, from `((3, true, 0), 9)`: levels 9, 8, 6, 6, 6, …, never ends, by the iff at `T = 1`; and from step 2 on the rule is `false`. This is the band on which `Three.read_at_eight_ends` ends. Check the numbers first.

## 3. Not in this pass

`WayOfUnits.lean` is restructured by the next pass; do not copy or edit it. `SCR/Becoming/LineOnAStock.lean` (another stage's file, which imports `WayOfUnits`) must still build after your change: build it last and leave it untouched.

## What I need back

- For each of 1 and 2: the new declarations' names and statements verbatim; which existing theorems each rests on; the worked courses' numbers as the Lean states them.
- The last build log's path and closing lines; that every axiom report is empty; that every statement that existed before is unchanged (diff the scratch files against the tracked ones and report the diff's shape: additions only for `TurningInTime.lean`).
- Anything changed from this brief and why; anything false as written, with its countermodel; every premise not needed.

## Hard rules

No edit outside SCR and your notes folder `/Users/ren/theories/tmp/r7/one-model/check/round9/implementer-C/`. No git command that writes; never `git prune`, `git gc`, `git clean`. No test suite, no gate, no core run. This Mac is shared and always busy: one Lean build at a time, in the background with a log; a timeout under load is rerun once alone before it is called a failure.
