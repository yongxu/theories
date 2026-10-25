# MA4b: landing runbook

These are the steps to land `Becoming.ReadInTime` (board item MA4b), on MA4's pattern (`../ma4-drawn-shaping/`). Every script asserts that each of its edits applies exactly once. On 26 October 2026 a dry run on a scratch copy of main at `d9443722f` applied every anchor of `integrate_ma4b.py`, and every anchor of `texts_ma4b.py` up to 08's counts. After the review was taken, a second dry run on a scratch copy of main at `98d205302` (after DF1 and UE7) ran `integrate_ma4b.py`, `texts_ma4b.py` and `make_records_ma4b.py` to the end, against a mock receipt that adds `Becoming.ReadInTime` to UE7's; the study section came out as §420, and the new record lints clean.

## Before the landing (done 26 October 2026)
1. The independent review's findings (`REVIEW-MA4b.md`) are taken; NOTE.md §8 says how.
2. Rebuilt in scratch (34 theorems in 39 declarations, every axiom report empty); the counts, standing and review paragraph are in `study_ma4b.txt`, whose only placeholders left are `{N}` and `{RECEIPT}`.
3. `STANDING` in `board_ma4b.py` is set from the review.
4. Re-run the dry run if main has moved.
5. Mark the head of the queue: `python3 -B <kit>/board_ma4b.py head MA4b "<text>"`, committing the board alone.

## The landing (in a worktree from main: `.claude/worktrees/ma4b-landing`, branch `ma4b-landing`)
1. `python3 -B <kit>/integrate_ma4b.py`
2. Run the core checker from the package directory: `python3 -B check_becoming.py`, in the background, its log in the kit. Read the receipt id from `becoming-checks/`, and check that `Becoming.ReadInTime` has an empty axiom report.
3. Take the study section number `N`: one past the last `## N.` in `BECOMING-RENEWAL-READING.md` at the time of landing.
4. `python3 -B <kit>/texts_ma4b.py RECEIPT N`
5. `python3 -B <kit>/make_records_ma4b.py RECEIPT N`
6. Run `make research-render`. Check that the record statement is at most 300 characters in English and 150 in Chinese.
7. Run connectivity, which needs the checker's cache: `python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py --check > <kit>/conn0.log 2>&1`. It stops with the apart roots that have no reason. Then run `python3 -B <kit>/register_ma4b.py <kit>/conn0.log`, and connectivity again with `--write --check > <kit>/connectivity.log 2>&1`.
8. `sh <kit>/repoint_ma4b.sh`, then render again.
9. Run `make research-check`, `research-links` and `research-test`, with each log in the kit.
10. `python3 -B <kit>/board_ma4b.py land MA4b RECEIPT N "<queue text with §N and the receipt>" "<state text>"`
11. Commit with an explicit path list and no trailer.
12. Merge main into the branch, redirecting the output to a file and reading all of it:
    - for generated files, take main's manifest, restore from main every generated file whose bytes it does not match, and render again;
    - for appended live files, keep main's part first;
    - renumber the study section if it was taken.

    Then scan for conflict markers.
13. Gate with `git merge-base --is-ancestor main ma4b-landing`. In the shared checkout, check that it is not mid-merge and that no incoming path is locally modified, then `git merge --ff-only ma4b-landing`.

## What the landing met (26 October 2026)
- The 02 §9 reading and the overview (EN and ZH) said the deadline is "set by the start's rule, the cost and the share". It depends on the start's counts, not the share (`Window.scaled`, the review's finding 8), so the three sentences now say it is quadratic in the start's counts, and `texts_ma4b.py` with them.
- Connectivity: `Becoming.ReadInTime` adds no apart root. `RuleShaping.pow_pos_of_pos` is no longer one, since `RuleShaping.held` uses it and ReadInTime reaches `held` through `RuleShaping.orbit_held`, so its register entry was removed; the study's output list says so.
- A second run of `repoint_ma4b.sh`, with nothing left to re-point, re-pointed every changed reference of 373 records across 15 sources, most of them never touched by this landing: `repoint.py` read an empty drift list as no filter at all. That rebind was reverted before the commit (371 records restored from the branch's base, the same entries of MA4's and MA2's records reset to it, the check then showing no drift) and its log line removed. `repoint.py` now re-points nothing from an empty list (`tools/research/tests/test_repoint.py`), and `repoint_ma4b.sh` stops when it keeps no pair.

## After the landing
- Update AJ's PLAN (§3 landed, the Missing list, step 7), AJ's board row, and the memory files.
- Tell fork 3 (07 §6's readings and AJ4's dossier are theirs) and the coordinator.
- Remove the worktree and its branch once the fast-forward is done.
