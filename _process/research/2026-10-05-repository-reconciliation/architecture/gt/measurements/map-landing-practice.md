<!-- AI-written: one of four read-only readers, 4 November 2026, for GT's design (GATE.md). Read against main 1e9bc6b85; not checked line by line. -->
# How a landing is done, and every area check

# How a landing is done today, and every area's own check

All files were read at main `1e9bc6b85` (worktree `gc-reading-correction`). Nothing was run. While I read, this worktree moved to `3bf962941` (GT's claim) and gained uncommitted edits by another session to `AGENTS.md`, `Makefile`, `RESULT-WORKFLOW.md`, `registry.py`, `completion.py`, `test_scoped_drift.py` and `gate.py`. Every line cited for those files is from the committed `1e9bc6b85`.

## 1. The steps of a landing, in order

1. **Claim in a gap.** Add the item's row with a board-only commit while no head clause stands (board:15). FV did this at 14b0276fb (`board_fv.py:2-3`).
2. **Prepare in your own worktree.** Scratch Lean goes through `scratch_build.py` (board:19). Often the whole landing is rehearsed in a scratch worktree first (`rehearse_u4e.sh:1-4`; 18 rehearse scripts in kits). That is a second full gate run.
3. **Ask the coordinator for a slot** and wait for its word and verbatim order sentence (`feedback_landing_queue_order.md:43-45`).
4. **Claim the head.**
   - In a worktree detached at main, refuse if `'(landing now'` is on main's Queue line.
   - Prepend `X at the head of the queue (landing now, …); `.
   - Commit the board only.
   - Re-check that main has not moved and no head clause stands, then `git -C /Users/ren/theories merge --ff-only` (`land_fv.sh:22-33`; `board_fv.py:35-43`).
5. **Merge main** (branch landings). Read the whole merge output, restore and re-render generated files that conflict, and commit the merge before checking (`land_u4e.sh:21-22`; `feedback_landing_merge_conflicts.md:15-25`; `RESULT-WORKFLOW.md:61`).
6. **Core landings only.**
   - `check_becoming.py` writes a run folder and receipt into the repository (`land_u4e.sh:23-26`).
   - Then a signature audit; `THEOREM-CONNECTIVITY.py --check`, `--write`, `--check`; `shared_laws.py` (`steps_u4e.sh:7-16`).
   - Then records, 08's receipt sentence and the study section are written by script (`land_us.py`).
7. **Apply the kit's edits** by script (`land_fv.sh:39-41`).
8. **Re-point drifted records.** `research.py check` lists drift; assert it is exactly the records read; then `repoint.py --reason --drift-json --apply`, which appends to `rebinds.jsonl` (`land_fv.sh:42-53`).
9. **Reading times**, where a front changed: `measure_layers.py`, grep for the stated figure (`land_fv.sh:54-55`).
10. **Board edits.** The landed clause replaces the head clause; the claim row goes; a history row goes before `## Lapsed claims`; a batched-pass entry is added (`board_fv.py:46-74`).
11. **The gate.**
    - `make research-render`, then `research-check-strict`, `research-links`, `research-test` (`land_fv.sh:57-59`).
    - `check_dossiers.py` plain and on `SCIENCES.md` (`land_fv.sh:60-61`).
12. **Freezes only.** `FROZEN.sha256` is committed alone, last, after the checks. Then a re-render, because the new hashed file changes `source-index.json` (`18ed73b7e`, `c7ae7f356`; `project_rfz_freeze.md:61`).
13. **Commit** every changed path, untracked included, refusing build output (`land_fv.sh:62-66`).
14. **Fast-forward.** The shared checkout must be on main, main must equal the commit's parent, and the head clause must be this landing's; then `--ff-only` (`land_fv.sh:67-72`; board:19).
15. **Report the hash** to the coordinator.

**Measured costs, docs landing** (from the log mtimes in `/Users/ren/tmp/coordinator/{t2-land,ue31-land}`):

| Step | t2-land | ue31-land |
|---|---|---|
| render | ≈2:00 | ≤4:03 |
| strict check | 1:56 | 3:21 |
| links | 6 s | 9 s |
| research-test | 281.6 s (308 tests) | 454.3 s (307 tests) |
| **total** | **≈8:45** | **≈15:10** |

Two other figures: `check` takes 179 s, of which 131 s is drift comparisons (GT row, board `3bf962941`:58). For a core run, `lean.yml:30-33` gives 3–11 min for 500–730 steps. Receipts record no wall time.

## 2. Area checks: what each reads, and what already runs it

The `area_checks` field has the full list. These points matter for soundness:

- **The strict check and render are global.**
  - They read every record and every file a record references (`registry.py:992-1033`).
  - Indexes count tracked **and untracked** files (`research.py:68-72`; `RESULT-WORKFLOW.md:155`).
  - The Lean catalogue reads every `.lean` that `rg --no-ignore` finds, **ignored files included**, outside `.git/.lake/.build/node_modules/.venv/__pycache__/.claude/worktrees` (`lean_catalogue.py:27,95-100`).
  - Drift looks up reviewed versions in **HEAD's history** (`registry.py:46-60`).
  - So a cache keyed only by `git write-tree` misses inputs. As history grows, reviewed versions can only be found, never lost. A pass can therefore be reused only on the same full tree (untracked and ignored inputs included) and only if the cached HEAD is an ancestor of the new one.
- **research-test is a content check.**
  - It runs `check_dossiers` over the live packet (`test_review_packet.py:37-51`).
  - It reads all records, `COVERAGE.json`, `shared-laws.json`, receipts and `check_becoming.py`.
  - It compiles stubs with the installed Lean against `THEOREM-CONNECTIVITY-DUMP.lean` (`test_boundary.py:1296-1340`).
- **check_dossiers' inputs.** The 9 dossier files; the corpus TSVs; `Becoming/`, `physics/`, `warning/`, `deeper/` and `review-checks/`; and the 100 files the dossiers quote (713 quotations). The quoted set has to be computed from the dossiers on the new tree.
- **check_becoming's inputs.** Everything under the Lean root:
  - a new `.lean` anywhere there can break the uniqueness assert (`check_becoming.py:3830`);
  - every passed `*.json` receipt (3993-4010);
  - the helper `check.py`;
  - the toolchain and the binary;
  - `~/.cache/becoming-lean`.

  `lean.yml`'s path filter matches this set.
- **Checks no gate runs.**
  - THEOREM-CONNECTIVITY and `shared_laws` run only in kits. `check` reports `shared_laws` stale, never as an error (`registry.py:861-864`).
  - The ZH/RO/Y verifiers take the **newest** core receipt by glob (`verify_zh.py:81`; `verify_ro.py:264`; `verify_mapping.py:456`), so any core landing is one of their inputs. No kit has run them since 23 Oct. `verify_zh` also writes a tracked file (`verify_zh.py:220`).
  - Periphery checkers (about 300 `check*.py` under the Lean root) import the core but never run on core landings. `formal/check.py` failed unnoticed from 6 Oct until 31 Oct (`project_coordinator_role.md:206`).
  - Freeze hash chains are checked only by each run script.
  - The growth ratchet (`--changed-since`), `check_rename.py`, `move --check` and `generative_chain.py --check`.
- **measure_layers never fails** (exit 0). Kits grep its figures.
- **No machine-wide lock exists.** `render_lock` is per worktree (`research.py:22-34`). `check_becoming` uses half the cores by default (`check_becoming.py:3912`).

## 3. How often a landing reruns its checks because main moved

- Rule 5 (board:19): each commit to main during a hold "sends the lander round another merge and render".
- Before landers claimed the head first, "main moves every few minutes … a landing merges main two or three times" (`feedback_landing_merge_conflicts.md:13`). On 30 Oct a docs-only branch's ~5-min check was overtaken by another landing three times in a row (`feedback_landing_queue_order.md:31`).
- The memories record holds being broken on 29 Oct (three times), 30 Oct (twice), 31 Oct (twice) and 1 Nov (`feedback_landing_queue_order.md:20-45`).
- A heuristic count over git, since 30 Oct (merges of main into a branch after its head claim):

  | Merges after the claim | Head claims |
  |---|---|
  | 0 | 4 |
  | 1 | 29 |
  | 2 | 5 (T1F, IGF, IGF2, AJ8b, ZH's note) |
  | 3 | 2 (TR45, US) |

  Each extra merge reruns the whole gate, about 9–15 min. Rehearsals and freezes add one more render or check pass each.

## 4. Where the documents disagree

Listed in the `disagreements` field. The main ones:

- AGENTS.md runs `research-test` on every landing; RESULT-WORKFLOW runs it only after infrastructure changes.
- The dossier check runs three times, and its second run is redundant.
- Links are required at landing but not run in CI.
- The `shared_laws` and growth-ratchet conditions are documented but nothing enforces them.
- Board-only commits are exempt from render by practice, not by the rule.
- The coordinator's scripts edit the shared checkout's board directly.
- Several memories are stale (`master_laws`, the old `SCIENCES.md` path, "the dossier check is not in research-test").

## 5. Not found

- A shared tool for editing the Queue line (there are 194 per-kit `board*.py` scripts).
- Any machine-wide lock.
- Any shared check of freeze hashes.
- Wall times in core receipts, and per-test timings.
- A record of whether RFZ's checks reran on the final tree after `18ed73b7e` and `c7ae7f356`.
- Whether the ZH/RO/Y verifiers and the periphery checkers pass today (not run, as instructed).
