# UE16: landing procedure

29 October 2026. AI-written procedure for landing board item UE16, as UE15's ([LANDING](../ue15-reorderings-as-growth/LANDING.md)), with the kit in [kit/](kit/). UE16 lands behind every earlier claim on the board (board rule 5), after the claims of UE16 to UE19 reach main (branch `ue16`), and before UE17, whose texts link the plan UE16's claims bring.

1. **Claims on main.** With no item at the head: merge main into `ue16`, check that every board hunk is a UE16–UE19 row, then fast-forward main (`git merge --ff-only ue16` in the shared checkout).
2. **The head.** With no earlier claim ready: `python3 -B <kit>/board_ue16.py head UE16 "landing now: Becoming.FreeEnergyGuarantees as a leaf with two records, …"` in a worktree from main; commit the board alone; fast-forward main.
3. **Landing worktree** from main (`git worktree add <wt> main`), detached; copy the study folder into it.
4. **Integrate.** `python3 -B <kit>/integrate_ue16.py` (asserts every edit applies once and every cited name is a declaration).
5. **Checker.** `python3 -B check_becoming.py` in the package (closure with the new leaf; every axiom report empty). Note the receipt id `R`.
6. **Connectivity.** `THEOREM-CONNECTIVITY.py --check`; register apart roots if any, then `--write`.
7. **Texts.** `python3 -B <kit>/texts_ue16.py R N`, `N` the next study section.
8. **Records.** `python3 -B <kit>/make_records_ue16.py R N`.
9. **Re-point.** `python3 -B <kit>/repoint_ue16.py R` (dry), read each changed section, then `--apply`.
10. **Board.** `python3 -B <kit>/board_ue16.py land UE16 R N "<queue text naming §N and R>" "landed <date> …"`.
11. **Render and check.** `make research-render`, `research-check` (`--strict-fresh`), `research-links`, `research-test`, in the landing worktree.
12. **Commit** owned paths only (`git commit -m … -- <paths>`, no trailer naming a person or AI); merge main if it moved (generated manifest three-way, re-render), reading the whole merge output.
13. **Fast-forward** main from the shared checkout (`git merge --ff-only`), after moving aside any untracked copies there; verify; remove the landing worktree; a `refs/salvage/…` ref for any commit not reachable.
14. **Tell** the coordinator, and the owners of what-a-set-point-optimum-does-beyond's laws if they ask; UE17 lands next.
