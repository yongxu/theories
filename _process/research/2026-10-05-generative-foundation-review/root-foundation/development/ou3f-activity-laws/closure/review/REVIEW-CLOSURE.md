# Review: OU3f closure (`Becoming.Clock` and the six derivations)

AI-written independent review, 29 October 2026, of `closure/tree/` against main `f02807c33` (the package is unchanged on main since). Checks are in [checks/](checks/).

**Verdict: ready after the listed fixes.** The Lean is right: the six statements are unchanged, each induction is replaced by `kept_onward`, and every build and axiom report is clean. Conditions 1 and 3 are not met as written: `Law.clock` is a second run beside `Law.run Nat.succ 0`, and `Frame` cannot hold it.

## Findings

1. **A second clock (condition 1).** `Law.run` (Recurrence.lean:357, in the module Clock imports) gives `Law.run Nat.succ 0 : Run (Law.process Nat.succ)`. Its moves equal `Law.clock`'s by `rfl`, and its state equals `Law.clock`'s at every step by `Law.succ_orbit` (Recurrence.lean:724; `ClockChecks.lean` §3). EC6b's precedent `Pace.stays` uses `Law.run` and defines no run (Pace.lean:153–158). So "No run of `Law.process Nat.succ` exists" (DESIGN.md:18) is wrong. The `id` state saves only `succ_orbit`, an existing lemma; both runs take their steps by `rfl`.

   **Fix:** drop `Law.clock` and prove `kept_onward` on the existing run, in EC6b's form:
   ```lean
   | ⟨k, at_⟩ => Eq.subst (motive := I)
       ((congrArg (Law.orbit Nat.succ a) (Nat.zero_add k)).trans ((Law.succ_orbit a k).trans at_.symm))
       (Invariant.reach (P := Law.process Nat.succ)
         (fun n _ _ stepped held => Eq.subst (motive := I) stepped.symm (keeps n held))
         ((Law.run Nat.succ a).reach 0 k) holds)
   ```
   Or take the reach as `Branching.law_reach_iff.mpr ⟨k, Law.succ_orbit a k⟩`. Both have empty reports (`kept_onward_byRun`, `kept_onward_byLaw`, §4). The six never name `Law.clock`, so they are untouched.

2. **The stated home is unreachable (condition 3).** Clock.lean:16–19 and the design say the module moves into `Frame` beside `Run.reach`. But `Law.clock` and `kept_onward` need `Law.process`, defined in Recurrence (line 143, put there by R28), and Recurrence imports `Frame` (line 1). The move would need `Law.process` moved down, or one more copy of the successor's process.

   **Fix:** name Recurrence as the home, beside `Law.run` and `Law.succ_orbit`. Or state the law on the grammar: `«闭含所闭»` with `«线则所闭»` at the successor relation (GrammarLaws.lean:188 and 985; `kept_onward_onGrammar`, §4, empty report), at home beside `«线则所闭»`. That version needs no process. It also leaves Reserve's closure as it is; the current import adds Recurrence to it, and Reserve is the only module affected.

3. **The survey is incomplete (design, module doc).** It misses `Law.run Nat.succ`, `AdjacentHeld.process` (HeldPossible.lean:1040, another copy of the successor's process) and `Stock.accumulating` (Stock.lean:524, a run whose state is the step). The package already has `Climb.process = Law.process (fun n => n + 1)` by `rfl` (ReachableRanges.lean:1060). So `Climb.course` and `Changing.run` are `Law.clock` by definition (§3). **Fix:** list them all.

4. **Names (condition 2).** `clock Unit = Law.process Nat.succ` by `rfl`, so `Law.clock` is a run of MoveFormation's process. Inside `namespace Becoming.Law`, where `Law.run` lives, `clock` now resolves to the run (`Names.lean`). The `Law.` prefix was chosen because `Becoming.clock` was taken, not because it states more. Fix 1 removes the name. The module would then hold no clock, so name it for its law (for example `Becoming.KeptOnward`). `kept_onward` itself is exact and collides with nothing. Lean's prelude (v4.29.1) has no `Nat.le_induction`, only `Nat.le.rec`.

5. **The family is larger than six, in these modules.** `ByPassing.trace` and `ByPassing.line_back` (tree PatternPassing:128, 430) and `Reidentify.old_still` (Persistence:806) each keep a region along the steps by their own induction. Each compiles by `kept_onward`, and `rfl` checks the result against the original statement (`Family.lean`, empty reports).

   The audit filed `trace` as "(c) inductions with no grammar law of their shape" (AUDIT.md:167). Closure is such a law. The audit's reason, deciding sameness of formations, concerns the line route only, and PatternPassing's edited *Not connected* paragraph still gives it.

   **Fix:** derive the three here (both modules are rebuilt anyway) and update that paragraph. Otherwise, record why each stays out (`old_still` reads no activity; `line_back` is the twins' lemma).

6. **Nit:** Clock.lean:7 says each step "is `n + 1 = n + 1`". The step is `n + 1 = Nat.succ n`, true by definition.

## Confirmed

- **Statements:** all 507 declarations of the six print identically on main and the tree, both by `#check @` and by `#check` (which shows hypothesis names). `diff` finds no difference between `signatures-*.out` or between `binders-*.out`. The name lists match in content and order, and Clock's two statements are as designed.
- **Derivations:** no recursion survives. Each step is the old successor case, with the hypothesis passed as `held`.
  - Starts: 0 in four (named `(a := 0)`, or inferred from `start` in Retaining), `j` in Exclusion via `id`, and `u` in Persistence.
  - Bounds: an `n ≤ k →` guard in `active_back`. In `steady_held`, a `u ≤ t →` guard, plus the old `.inr` branch for the step into the start; that branch is needed because `kept_onward`'s step covers every `n`.
  - Exclusion's `induction le` is gone.
- **Docstrings:** each names its region accurately. The PatternPassing sentence is right: `present_of_le` uses `present_earlier`, and `empty_stays` uses `present_of_le`.
- **Build:**
  - Scratch build: 43 modules, all reused, none unclean. Every report is empty (Clock 1 theorem in 2 declarations; the six keep their counts).
  - A fresh compile of the 7 sources exits 0 with no messages.
  - `#print axioms` is empty for `Law.clock`, `kept_onward` and the six.
  - Downstream: Clearing, OwnWidening, Exhaustion, Descent, MapInstances and ContinuedClasses (one importer per module) compile clean with empty reports, along with the four modules between them and the six. So does MoveFormation, with the 8 modules between it and the six.
- **No other clock:** `Changing.run` and `Climb.course` sit above Retaining and Reserve, as the design says. Nothing of `kept_onward`'s form exists in Prelude, the grammar, Frame or Recurrence. `Invariant.run` (Frame:259, its own induction) gives the same content, but only through `Law.run` and `succ_orbit` (§5).

`checks/tree-*` are the copies built; their `.build/` is ignored build output.

## Second pass (branch `ou3f-laws` at `30e866f03`)

**Verdict: ready after two record fixes.** The Lean is ready as it stands.

1. **The audit still derives the six through the dropped clock.**
   - AUDIT.md:53 says each of the six "runs on a clock (the successor law's run, `⟨id, fun _ => (), fun _ => rfl⟩`)".
   - The six closure rows of `data/classification.tsv` (lines 50, 193, 217, 413, 428, 437) give the same route: "Invariant.reach with Run.reach on a clock". TABLE.md renders those notes.
   - The new `trace` row says `kept_onward`, so the audit disagrees with itself and with the Lean.

   **Fix:** in that paragraph and in the six notes, say `kept_onward`, the grammar's closure at the successor (`«线则所闭»` with `«闭含所闭»`). Then re-render TABLE.md.
2. **DESIGN.md:16 says `Pace.stays` uses `Law.run Nat.succ`.** It does not: `Pace.stays` uses `Law.run` at its own law, `step f h reads`.

   **Fix:** write "`Law.run` (Recurrence), which `Pace.stays` uses at its own law; at `Nat.succ` its state is the step by `Law.succ_orbit`".

   Nit, line 5: the first review found three more inductions, not two. Line 49 names the third (`old_still`); two of the three are derived here.

**Confirmed.**
- **(a) Statements.** All 507 declarations of the six print exactly as on main, `trace` and `line_back` included.
  - The `#check @` and `#check` outputs are identical to round 1's main outputs.
  - Main's package is unchanged at `c2dc1773d`, and `BASE.sha256` matches.
  - The declaration lists match in content and order.
  - `kept_onward` keeps round 1's statement.
  - No recursion survives in `trace` or `line_back`. Each step is the old successor case, with `held` in place of the recursive call, and `line_back`'s base is its old case `0`.
- **(b) KeptOnward.** Its doc is accurate. The move into GrammarLaws is a cut and paste: the declaration and its docstring, pasted verbatim after `«线则所闭»` in a copy of GrammarLaws, compile with the same full name, the same statement and an empty report (`checks/paste/`, `paste.out`).
  - The six already reach GrammarLaws through Frame. The move therefore only drops their import line and the leaf's registrations.
  - The leaf adds no import edge; Reserve no longer gains Recurrence.
- **(c) Builds.**
  - `scratch-4.log` is clean.
  - My rebuild of the revised tree reused all 43 modules from the cache. Nothing is unclean and every report is empty: KeptOnward has 1 theorem in 1 declaration, and the six keep their counts.
  - A fresh compile of the 7 sources exits 0 with no messages.
  - Downstream, the same six importers compile clean with empty reports (10 modules compiled).
- **(d) Audit and design.** The `trace` correction is right.
  - The totals add up: 15 + 4 + 10 = 29, B1 and B2 add nine, and 398 remain. The model subtotals give 60 + 38 + 20 + 16 + 38 = 172.
  - TABLE.md equals a fresh render of the tsv (rendered in memory, nothing written).
  - `line_back` stays (c) representation.
  - Apart from fix 2, DESIGN.md is accurate: its table, the eight consumers, the counts, and the `old_still` paragraph. The board's WRP row does take the theorems that read no field whole.

**Second-pass files in `checks/`:**
- `tree-second`: the revised copies built.
- `SignaturesSecond.lean`, `BindersSecond.lean`, `signatures-second.out`, `binders-second.out`: the statement checks.
- `fresh-second.out`: the fresh compile. Its per-module `fresh-second-*.tmp` logs are empty.
- `scratch-second*.log`: the scratch builds.
- `paste/` and `paste.out`: the GrammarLaws cut-and-paste check.
