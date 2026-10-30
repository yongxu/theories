# UE23: landing procedure

30 October 2026. This procedure is AI-written. It lands board item UE23 with the kit in [kit/](kit/).

UE23 changes no core file, so there is no core checker run. Only the periphery checker of `ExpectedFreeEnergyReals` reruns on the landing tree. `FreeEnergyReals` is unchanged, and its UE22 receipt stands. UE22's LANDING.md is the pattern.

The procedure was rehearsed in a detached worktree from main: the texts, the records, the re-point, the board, the render, the master-laws view, the strict check, the links and the tests.

1. **The head.** If no earlier claim is ready, put UE23's head clause on the board (`board_ue23.py head UE23 …`) in a worktree from main. Commit the board alone, then fast-forward main.
2. **Landing worktree.** Make it from main. Copy into it:
   - the study folder;
   - from `lean/free-energy/`, `ExpectedFreeEnergyReals.lean` and `check_expected_free_energy_reals.py`.

   Leave out the drafting runs (`expected-free-energy-reals-checks/20261030T083430.201599Z/`, `20261030T090748.312916Z/`, `20261030T093339.472195Z/` (interrupted) and `20261030T094242.922407Z/`) and the verification file, which the landing run replaces.
3. **Checker.** In `lean/free-energy/`, run `python3 -B check_expected_free_energy_reals.py`. Every core module of the closure, `Becoming.LumpedSeeking` among them, must match a passed core receipt, and `FreeEnergyReals` its UE22 receipt. Note the receipt id `E`. Then check that `make_records_ue23.py --caps E` passes.
4. **Texts.** Run `python3 -B <kit>/texts_ue23.py E N`, where `N` is the next study section.
5. **Records.** Run `python3 -B <kit>/make_records_ue23.py E N`.
6. **Re-point.** Re-point what drifts because of these edits, and only that: run `python3 -B <kit>/repoint_ue23.py`, read the dry run, then run it with `--apply`.
7. **Board.** Run `python3 -B <kit>/board_ue23.py land UE23 E N "<queue text naming §N and E>" "landed <date> …"`.
8. **Render and check** in the landing worktree, in this order:
   - `make research-render`;
   - `python3 -B tools/research/master_laws.py`;
   - `make research-render` again;
   - `research-check --strict-fresh`, `research-links` and `research-test`.
9. **Commit and land.**
   - Commit owned paths only, with no trailer naming a person or AI.
   - Re-read the Queue line. If main moved, merge it.
   - Fast-forward main and verify it.
   - Tell the coordinator.
   - Remove the worktrees and the branch once nothing in them is unique.
