# MA4b: landing runbook

These are the steps to land `Becoming.ReadInTime` (board item MA4b), on MA4's pattern (`../ma4-drawn-shaping/`). Every script asserts that each of its edits applies exactly once. On 26 October 2026 a dry run on a scratch copy of main at `d9443722f` applied every anchor of `integrate_ma4b.py`, and every anchor of `texts_ma4b.py` up to 08's counts.

## Before the landing
1. Take the independent review's findings (`REVIEW-MA4b.md`). NOTE.md gains a section on what was taken.
2. Rebuild in scratch, and write the theorem and declaration counts into `study_ma4b.txt`. Also fill the study's standing and review paragraphs (`{THEOREMS}`, `{DECLARATIONS}`, `{STANDING}`, `{REVIEW}`); `texts_ma4b.py` refuses an unfilled placeholder.
3. Set `STANDING` in `board_ma4b.py` from the review.
4. Re-run the dry run if main has moved.

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

## After the landing
- Update AJ's PLAN (§3 landed, the Missing list, step 7), AJ's board row, and the memory files.
- Tell fork 3 (07 §6's readings and AJ4's dossier are theirs) and the coordinator.
- Remove the worktree and its branch once the fast-forward is done.
