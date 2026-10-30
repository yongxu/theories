# UE24: landing procedure

30 October 2026. This procedure is AI-written. It lands board item UE24 with the kit in [kit/](kit/).

UE24 changes no core file, so there is no core checker run. Only the new periphery checker, `check_cells_under_noise.py`, runs, on the landing tree; every core module of the closure of `CellsUnderNoise`, `Becoming.FreeEnergyGuarantees` among them, must match a passed core receipt. UE23's LANDING.md is the pattern.

The procedure was rehearsed in a detached worktree from main: the checker, the texts, the records, the board, the render, the master-laws view, the strict check, the links and the tests.

1. **The slot and the head.** Ask the coordinator for a slot. On it, put UE24's head clause on the board (`board_ue24.py head UE24 …`) in a worktree from main. Commit the board alone, then fast-forward main.
2. **Landing worktree.** Make it from main. Copy into it:
   - the study folder `development/ue24-cells-under-noise/`;
   - into `lean/free-energy/`, `CellsUnderNoise.lean` and `check_cells_under_noise.py`.
3. **Checker.** In `lean/free-energy/`, run `python3 -B check_cells_under_noise.py`. Note the receipt id `E`. Then check that `make_records_ue24.py --caps E` passes.
4. **Texts.** Run `python3 -B <kit>/texts_ue24.py E N`, where `N` is the next study section.
5. **Records.** Run `python3 -B <kit>/make_records_ue24.py E N`.
6. **Board.** Run `python3 -B <kit>/board_ue24.py land UE24 E N "<queue text naming §N and E>" "landed <date> …"`.
7. **Render and check** in the landing worktree, in this order:
   - `make research-render`;
   - `python3 -B tools/research/master_laws.py`;
   - `make research-render` again;
   - `research-check --strict-fresh`, `research-links` and `research-test`.
8. **Commit and land.**
   - Commit owned paths only, with no trailer naming a person or AI.
   - Re-read the Queue line. If main moved, merge it.
   - Fast-forward main and verify it.
   - Tell the coordinator.
   - Remove the worktrees once nothing in them is unique.
