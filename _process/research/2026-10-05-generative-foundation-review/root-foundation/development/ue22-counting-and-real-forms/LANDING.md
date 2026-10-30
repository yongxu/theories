# UE22: landing procedure

30 October 2026. AI-written procedure for landing board item UE22, with the kit in [kit/](kit/). UE22 changes no core file, so no core checker run; both periphery checkers rerun on the landing tree (UE17's LANDING.md is the pattern). Rehearsed once in a detached worktree from main (texts, records, the re-point, render, the strict check and links).

1. **The head.** With no earlier claim ready: put UE22's head clause on the board (`board_ue22.py head UE22 …`) in a worktree from main; commit the board alone; fast-forward main.
2. **Landing worktree** from main; copy into it the study folder (without `.build`) and, from `lean/free-energy/`, `FreeEnergyReals.lean` and `check_free_energy_reals.py`, leaving out the drafting runs (`free-energy-reals-checks/20261030T024112.835556Z/` and `20261030T032727.644362Z/`, `expected-free-energy-reals-checks/20261030T024306.590658Z/` and `20261030T032801.372614Z/`) and the two verification files, which the landing runs replace.
3. **Checkers.** In `lean/free-energy/`: `python3 -B check_free_energy_reals.py`, then `python3 -B check_expected_free_energy_reals.py`; every core module of each closure must match a passed core receipt, and `FreeEnergyReals` the first run's receipt. Note the receipt ids `R` and `E`; `make_records_ue22.py --caps R` passes.
4. **Texts.** `python3 -B <kit>/texts_ue22.py R N`, `N` the next study section, after the review paragraph of `study_ue22.txt` is written.
5. **Records.** `python3 -B <kit>/make_records_ue22.py R N`.
6. **Re-point** what drifts by these edits only, and rebind expected free energy's record: `python3 -B <kit>/repoint_ue22.py R E`, read the dry run, then `--apply`.
7. **Board.** `python3 -B <kit>/board_ue22.py land UE22 R N "<queue text naming §N and R>" "landed <date> …"`.
8. **Render and check** in the landing worktree: `make research-render`; `python3 -B tools/research/master_laws.py` (the four new laws are not yet in MV's view: the rehearsal's strict check named them), then `make research-render` again; `research-check --strict-fresh`, `research-links`, `research-test`.
9. **Commit** owned paths only, no trailer naming a person or AI; re-read the Queue line; merge main if it moved; fast-forward main; verify; tell the coordinator; remove the worktrees once nothing in them is unique.
