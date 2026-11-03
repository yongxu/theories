# OG2: independent reading of the Lean (AI-written, 2 November 2026)

A fresh Opus agent, given the module, the design and the house rules, at commit `b20d78eeb`. Its model is in review4-scripts/, copied from the path it names. Kept as it came back; line numbers are of that commit. Every finding was taken: §9 of the design says how.

# Independent read of `RuleRebuilding.lean`

I checked the claims below with a hand derivation or a small Python model of the rule, `/private/tmp/claude-501/og2read/m.py`. I didn't compile any suggested fix. Nothing in the repository was edited.

## Severe

1. **`«稳存而隙不存»`, and `«隙之律»` behind it (lines 88–89).**
   - The top docstring says "end the level while held". The Lean says only `¬ ∀ n, Held …`, which would also be true if the rule were lost with the level intact.
   - **Fix:** add to `«隙之律»`: over the bound, `∃ k, Gone (run (k+1)) ∧ ∀ i ≤ k, Held (run i)`. Its `hc` and `hheld` already give this.

2. **`«改于带外则尽»` (lines 76–78, 1477).**
   - The name states a law (outside the band, it ends). The docstring says no law holds. The statement is two runs at one rule and `L = 1`, and two endings support the name's law rather than refute it.
   - The name's law is false. At `rF`, quota 1→0 goes on, with level 1205 at step 200. At `rA`, `L = 50`, 2→3→2 stays alive.
   - The contrast with the band also misleads. At `rB`, quota 1→5, both in the band, is gone within four steps at `L` = 1, 3, 4 and 5 (`L = 50` survives).
   - **Fix:** rename it, add a witness that does not end and the in-band witness, and say the law is the region, not the band.

3. **`«隙存而稳不存»` (line 88): witness at `c = 0`, and a missing consequence.**
   - `rD` has no door, so the witness shows nothing about limiting.
   - Worse, with `k + z = s`, `k(q+e) + zf ≤ g < s(q+e)` forces `f < q+e` and `f·s < g` (by hand; a search found no contrary case). So a gap holds where the steady state cannot only where the rule draws more than open entry, and open entry would itself go on.
   - That undercuts the section's title, "where passing and limiting meet", on this side. Only `«稳存而隙不存»` (which forces `C ≥ 2`) has the door doing anything.
   - **Fix:** prove this consequence as a law and use a witness with a door. `⟨2,1,4,1,1⟩`, `q = 3`, `[true,false]` holds in the model and is outside the band.

4. **"`k` sets both how many pass the rule and how many keep the door" (lines 87, 1728).**
   - By `hT` in `onward_strands`, at every step `T` is `q` or `0`, whatever `k` is. So `k` sets on how many of `s` steps the door is kept and the rule passed.
   - Passing needs only `k ≥ 1`. `k` enters the threshold through draw and leak, not through passing.
   - **Fix:** reword the sentence.

## Moderate

5. **`«同规随类»`.** Design §3 says a revision "inside the region". The witness revises to 3 at `rA`, outside its band, and by `«改于带外则尽»` that same revision reaches level 0 by step 3. The top docstring dropped the qualifier without saying so. Neither relation is shown to be a `«类»`, though "read at a class" says so.
   - **Fix:** use `steady rB 3 L` revised to 5 (`Fits rB 3 5`) and add the `«类»` conjuncts.

6. **`«改而成隙则尽»`.** The title says a state with gaps is reached, but the statement mentions no gaps. It also gives `Held` at step 17 only.
   - **Fix:** the model gives `run rE outAndBack 8 (steady rE 2 30) = strands rE 2 [true,false,false] 36`, and `Held` at all of steps 0–17. State both.

7. **`«毁储者所入过来者»`.** "Or turns no one away" is not in the Lean, and the proved part is just monotonicity of multiplication.
   - **Fix:** with `1 ≤ q`, `f < q + e q ↔ f < q ∨ C = 0` (by hand; 0 failures on a grid). State that instead.

8. **`«外授者即入»`.** It says the rule "enters", but the conclusion is `Held` after the step. At `s ≥ 2` an old cohort makes that true with no entry at all.
   - **Fix:** conclude `entrant r true x = x.quota`, or state the new head cohort.

9. **Band, third conjunct (L2): near-definitional.** `Held` reads the level only through step 1's clause that all members leave. L2's take condition, L1's end, L8's ruin, L9's bottom row and L13's forward direction all exist because of that clause. Design §5 says so. The docstring names it only under L7 and in the assumptions list.
   - **Fix:** state the dependence at L2. AGENTS asks for it where a law depends on it.

10. **"What ends a shared stock is `Flow`'s" (line 12).** Here the end is this rule's own clause, and no law uses `Flow`. 05 §1 says the gated endings hold only where renewal depends on what it renews, and that condition is the very clause in question.
    - **Fix:** "Step 1 is a modelling choice with the form of `Flow`'s gated ending."

11. **Design L3's interval has no theorem.** The solved form (`C ≥ 2`, `C = 1`, `C = 0`) is unproved and missing from "Not proved here". `«带之闭式»` still has `q` on both sides, so it is not a closed form of the band.
    - **Fix:** prove it, or say it is dropped and rename.

12. **The quota is a fill, not a limit.** `taught .members q (T+1) = q` even at `f = 0`, and `door` reads `T`, never the quota. So "the members it limits" and "admits" read as a gate, when what limits is only the teachers' count.
    - **Fix:** say this in the split paragraph.

## Vacuity

I found no vacuous law. `Closed`, `Fits`, `Within`, `strands`, `Goes` and `EndsUp` are all met by states. `«四境皆有»` proves only the arithmetic tests, which its docstring admits. Its fourth case is `c = 0`.

## Rule against design §2

Nothing is wrong: the order, the end with quota kept, the teachers read before ageing, `keep`, and the revision read before the step and applied last all match.

The Lean is stronger than the design without harm in L6 and L8 (`.none`), L13 (no `2 ≤ s`) and L12 (no `1 ≤ s`).

The only §3 gaps are items 5 and 11.

## Smuggling and one-parameter claims

- **The split sentence (line 33):** "passed … through another who held it" is false for `.outside`, and no teacher–pupil relation exists in the Lean, only a threshold.
- **"A keeper's cost" (line 34):** every member draws alike, so nothing is a cost of keeping. Say "a keeper draws too".
- **`«救储者…»` and `«毁储者…»`, "saves" and "ends":** these are value and causal words for two separately started states, and `nobody` is not reached from `steady` under `always`. The names should state the structure.
- **"A stricter rule" (line 1479):** at `rA`, quota 1 admits 3 a step and quota 2 admits 2, so the lower quota admits more in total. Say "a smaller quota".
- **`«改额为零则尽»`:** `尽` means `Gone` elsewhere, but here only the holders empty. Use `持尽`. Its docstring also lists a hypothesis ("at most `s` cohorts") that the statement doesn't have.
- **`«及任之前皆亡»`:** "however large" rests on 5 and 50. The general claim is `«不及任则持尽»`.
- **`«弃而储增»`:** the docstring reads as general, but the statement is one rule.
- **`steady`'s docstring:** "next step is itself" fails at `s ≤ l` with `q ≥ 1`, and when the step ends.

## Stronger statements

- **`«门之四境»`:** it is two independent facts in four conjuncts. State `Goes (steady) ↔ (q+e)s ≤ g`, `Goes (nobody) ↔ f·s ≤ g`, and that `Goes` excludes `EndsUp`. That says plainly there is no joint content. The level part also doesn't need `1 ≤ f`.
- **L13:** state that the gap's take lies between `s(q+e)` and `s·f`. This gives item 3 in one line.
