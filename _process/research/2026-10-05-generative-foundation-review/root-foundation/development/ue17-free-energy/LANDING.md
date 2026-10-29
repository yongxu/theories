# UE17: landing procedure

29 October 2026. AI-written procedure for landing board item UE17 after UE16, with the kit in [kit/](kit/). UE17 changes no core file, so no core checker run; its periphery checker reruns fresh on the merged head (REVIEW-UE17 F5).

1. **The head.** With UE16 landed and no earlier claim ready: put UE17's head clause on the board (`board_ue17.py head UE17 …`) in a worktree from main; commit the board alone; fast-forward main.
2. **Landing worktree** from main; copy into it the study folder and `lean/free-energy/` (the module, `check_free_energy_reals.py`), leaving out the drafting run folder `free-energy-reals-checks/20261029T134610.999747Z/` and `free-energy-reals-verification.json`, which the fresh run replaces.
3. **Checker, fresh.** `BECOMING_FRESH=1 python3 -B check_free_energy_reals.py` in `lean/free-energy/`; every core module of the closure must match a passed core receipt (UE16's run is the latest). Note the receipt id `R`; `make_records_ue17.py --caps R` passes.
4. **UE2's draft to history.** `python3 -B tools/research/research.py move --plan` for `development/ue2-conditional-weights/periphery/`, read the plan, then the move; verify links and preservation hashes.
5. **Texts.** `python3 -B <kit>/texts_ue17.py R N`, `N` the next study section.
6. **Records.** `python3 -B <kit>/make_records_ue17.py R N`.
7. **Re-point** what drifts by these edits only (03 §6 and the thesis, 08 §8, FEP-INTEGRATION, the plan, regions), reading each changed section first.
8. **Board.** `python3 -B <kit>/board_ue17.py land UE17 R N "<queue text naming §N and R>" "landed <date> …"`.
9. **Render and check** in the landing worktree: `make research-render`, `research-check --strict-fresh`, `research-links`, `research-test`.
10. **Commit** owned paths only, no trailer naming a person or AI; merge main if it moved; fast-forward main; verify; remove the worktree.
