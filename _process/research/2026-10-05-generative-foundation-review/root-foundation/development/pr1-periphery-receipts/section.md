## {n}. {title}

```text
Result(s): no new Lean claim and no new result. The 23 periphery receipts that chapter section 9 names (the
       bridge FallibleInquiry, CorrectionInquiry, MachineInstances, LearningCorrespondence, the eighteen
       instance modules and EntropyProduction), checked 13 to 19 October against an earlier core, pass again
       against the core of main {main}. Seven periphery modules were repaired to compile; no core file changed.
Delta: the receipts now bind the current core's bytes. Seven modules had stopped compiling after the core's
       renames and moves of 19 and 20 October (R30 to R37); each now names the core's current declaration for
       what it used. Every theorem and declaration keeps its name and axiom report. Twelve theorems print a
       different statement, each differing only by the core's new name for the same definition. PE2's reading
       of every periphery use of propext (section 268), rerun at the new receipts, gives the same
       classification for all 489 periphery declarations on propext.
Premises: none.
Evidence: development/pr1-periphery-receipts/: run_checkers.py (each checker in turn; out/status.json and
       out/*.log; the first run's failures in out/first-run/), compare.py (old and new receipt: declarations, axiom reports, printed signatures;
       out/compare.json), bindings.py and repoint_all.py (the records whose proof bindings name a periphery
       run, rebound with tools/research/repoint.py), stale.py (which receipts bind bytes other than a
       revision's), pe2_rerun.py (PE2's uses.py and summary.py into pe2/, PE2's own out/ kept), apply_text.py.
       Receipts: {receipts}.
Boundary: CorrectionInquiry imports the core's root module, so any later core landing leaves its receipt on
       earlier bytes; the other receipts go stale only when their own closure changes. The printed statements
       compared are the target modules'; SelectionRelabelCorrespondence's two companion modules are compared by
       declaration names and axiom reports. Periphery theorem names
       that echo a renamed core name (IdealsCorrespondence's scottClosed_iff_closed, closed_of_finiteRefutable,
       settles_of_bounded; ProtocolInstances' counts) are kept: each still states what it names.
Output → input: chapter section 9 names the renewed CorrectionInquiry ({ci}) and FallibleInquiry ({fi})
       runs; the records whose proof bindings named a periphery run are rebound to the renewed runs (a
       record citing an earlier run as the receipt of an earlier statement keeps it); proposition-identity's
       next_delta item "rechecked once its receipts are renewed" is done.
```

- **What no longer compiled, and the repair.** Each repair points a periphery module at the core's current name for what it used; no statement's meaning changes.
  - MachineInstances: `CrossSituational.Distinct` is gone; R37 (B6) stated it once as `Becoming.Distinct` in the prelude, with the same body, in every universe. Seven theorems' statements now print `Becoming.Distinct` (`resolve_iff`, `interprets_every_iff_separated`, `scene_interprets_every_iff`, `start_distinct`, `acquired_distinct`, `retrospective_resolves_iff`, `retrospective_distinct`).
  - LearningCorrespondence: `adaptive`, `adaptive_determined` and `adaptive_state_law_iff` are in `Becoming.Mechanism`, which the core's `Becoming.Learning` no longer reaches since the W2 re-rooting (19 October); the module imports it.
  - TransmissionCorrespondence: R31 split `Becoming.Order` into `Stuttering`, `Reordering` and `IdleRemoval`; what the module uses is in `Becoming.Reordering` and below, which it now imports.
  - ProtocolInstances: `Countdown.Counts` is `Countdown.CountedWork` (R30); the theorem `counts` prints the new name.
  - VersionedTaskInstances: `Countdown.Advances.counts` is `Advances.countedWork` (R30).
  - IdealsCorrespondence: `Ideals.Closed` is `Ideals.ScottClosed` and `HistoryIdeals.Settles` is `HistoryIdeals.HasLongest` (R30); the forwarder `Ideals.hull_contains` was removed (R32) and the law it applied, `Ideals.AdheresBy.of`, is used directly. The module's docs name `ScottClosed`. Four theorems print the new names (`scottClosed_iff_closed`, `closed_of_finiteRefutable`, `settles_of_bounded`, `decided_classical`).
  - EntropyProduction: `Passing.lossless` is `Passing.conserving` (R30); `Flow.sign` is now `Witnesses.profile [0] 1` (R37, B14), so the `simp` of `Fluctuation.balances` also unfolds `Witnesses.profile`.
- **What was compared.** For every receipt the old and new runs audit the same declarations with the same axiom reports, and the same number of theorems (MachineInstances 103; chapter section 9 had said 96, which the 19 October receipt already exceeded). Every theorem's printed statement was compared, old and new, for all 23 receipts (each Signatures log read from its run folder or, where the step was reused, from the checkers' cache entry); the twelve above are the only differences, and each is a renamed core name.
- **PE2's classification at the new receipts.** `uses.py` restored every closure from the checkers' cache with nothing compiled, and the analysis finds `propext` in exactly the declarations whose recorded report has it, 24 receipts of 24. The 489 periphery declarations on `propext` receive the same class as at the earlier receipts, and the library values left to reduction checks are the same eight. The core's generated `injEq` lemmas are 197, one more than PE2 read (`World.InAmounts.mk.injEq`, from LC2). So the classification holds: no periphery definition computes a value through an identification of propositions.
- **How the runs were landed.** The checkers ran one at a time; every Lean step of the core was restored from the shared cache except CorrectionInquiry's Lean 4.30.0-rc2 compile of the core, and each repaired module recompiled. Main moved twice during the work (R51 and its board and connectivity commits); the receipts were rerun on the final head. Main moved once more during that run, by a connectivity commit with no Lean change, so the receipts name main as a34b8412f or 6b07c9edf; `stale.py main` confirms that every receipt binds main's current bytes, the seven repaired modules aside.

**Self-review.** This renews checks; it adds no claim. The repairs were chosen by the rename and removal tables of R30, R32 and R37 and by the R31 module split, and the printed-signature comparison confirms them where the earlier log exists. The comparison reads printed statements, which name definitions but do not unfold them; that a renamed definition kept its body rests on R30's, R32's and R37's own signature checks of the core.
