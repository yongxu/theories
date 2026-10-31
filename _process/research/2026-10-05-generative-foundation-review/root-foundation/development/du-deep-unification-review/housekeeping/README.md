# Unmerged branches and worktrees, 1 November 2026

On a request to take care of unmerged work (outdated work removed, partly useful work revised, work that needs merging merged), the 106 branches not on main and the 23 worktrees were read. Nothing was deleted. Every commit stays reachable.

## Branches

- **95 moved to `refs/salvage/branches/<name>`**, listed with their tips in [salvaged-branches-2026-11-01.tsv](salvaged-branches-2026-11-01.tsv). To restore one: `git update-ref refs/heads/<name> refs/salvage/branches/<name>`.
  - 88 date from 25 October or earlier. The coordinator's audit of 25 October found every one an attempt, rehearsal or kit of an item since landed by relanding. The check repeated here is in [old-branches-declarations.txt](old-branches-declarations.txt), with columns branch, declarations added and declarations missing from main. 82 add no declaration missing from main. The other six miss one to six helper names each, renamed or dropped in review (for example TI1's `free_where_apart`, landed as `free_where_unlumped` in `15321dbe1`).
  - 7 are newer:
    - `df1`: DF1's draft (landed with DF1 and DF1b);
    - `fm-landing`, `fm-update`: FM landed in `dcffa6080`, its update in `e8e0ea248`, both since rewritten by the ten-minute cut;
    - `u4-reh1` to `u4-reh3`: U4's rehearsals, labelled "not for landing" (U4 landed in `7396ceddb`);
    - `ue25-kit`: every file it changes equal to main's (UE25 landed in `806a92331`).
- **Kept as they are:**
  - `evidence/zero-axiom-enc-scratch`, kept apart on purpose since 25 October;
  - the ten branches of items in hand: `aj4-human`, `bd2-crossing`, `du-claim`, `el-kit`, `ou5-check`, `ou5-design`, `tr-rr`, `ue26-kit`, `ue27-kit`, `ws-claim`. These land, or are revised, through their owners and the coordinator's queue.

## Worktrees

- **Removed, branch already on main, clean, no process inside:** `wt-fm` (fm-ten), `front-pages-land`, `mv-land`, `rf-landing` (rf-round2) and `u1b`.
- **Removed after its leftovers were committed** to `refs/salvage/wt-u1b-reh1-leftovers`: `u1b-reh1`, U1b's rehearsal. Its script was byte-identical to main's; the rest was rehearsal output and core receipt `20261031T143141.041218Z`, superseded by U1b's landing `9651f5829`.
- **Kept for their owners:** the BD2 rehearsals (`bd2-reh2`, `bd2-reh3`), AJ4's rehearsal, the check worktrees `wt-check` and `wt-check2`, and the worktrees of the items in hand.

## Checked again, 1 November 2026, on main `3d1528b36`

None of the 95 is the branch of a live worktree: no branch in `git worktree list` is under `refs/salvage/branches/`, and each of the 15 worktree branches is still a head. The work board does not name any of the 95. No further heads are moved until the coordinator has audited the remaining leftovers.
