# Non-Destructive Branch, Worktree, Stash, and Scratch Lean Disposition Plan

*AI-written (`p5-review-hygiene`, 25 November 2026) under [AGENTS.md](../../../../../../AGENTS.md) Rules 5 and 7. **Inventory and recommendations only — zero branches, worktrees, stashes, or files have been deleted or modified.** Every retirement recommendation awaits Ren's explicit approval and requires prior `refs/salvage/...` archival where commits or stashes are not already preserved on `main`.*

*Path convention: `<repo-root>` denotes the primary local checkout on `main`; `<antigravity-worktrees>` denotes the Antigravity managed worktree directory; `<scratch-wt-root>` denotes the local temporary worktree directory. No machine-specific absolute home paths are recorded here.*

---

## 1. Active / Parked Frontier Branches & Worktrees — ACTIVE / PARKED FRONTIER — DO NOT TOUCH

Snapshot initially inventoried against local `main` at **`c65f2b991`**, updated at integration time to **`2e3a1aeac`** and **`98e0ce989`** (Wave 3 Track A3 `Becoming.RelSpan` commits `f9836f3a6`, `71a342aaf`, `98e0ce989`). **Do NOT prune, reset, merge without coordination, or delete any entry in this section.**

- **Merged frontier notes at `f3cfec345` / `c65f2b991` / `2e3a1aeac` / `98e0ce989`:**
  - `wave3-relspan-core` (`Becoming.RelSpan` extraction & `RelSpanEncounterAdapter`, core receipt `20261124T195858.526167Z`) **has landed on `main` (`98e0ce989`)**; `wave4-b4-interface-b3-cone` (`98e0ce989`, at `<repo-root>/.claude/worktrees/wave4-b4-interface-b3-cone`) is newly active on `main` and remains **ACTIVE / PARKED FRONTIER — DO NOT TOUCH**.
  - `swarm-d1-middle-band-e2889178` (`MiddleMinus`/`MiddlePlus` middle band + `R5`), `swarm-d2-joint-epoch-gate-bdc933c4` (`EpochHandoffGate` `jointEpochFamily`/`Bool × Bool`), `swarm-d3-youden-gaussian-f15950d9` (`QuantitativeTransfer` `Youden J` + `gaussianReal`), and `open-deltas-integration` (`0a3fba4cc` / `2e3a1aeac`) **have landed on `main` (`2e3a1aeac`)**; their branch refs and any remaining worktrees remain **DO NOT TOUCH** unless retired by their own owners.
  - `wave2-real-learner-b1-b2-b3` (`2fa1fd531`) **is now merged on `main` (`f3cfec345` / `c65f2b991`)**; any remaining local `.claude/worktrees/wave2-real-learner-b1-b2-b3` worktree if present remains **DO NOT TOUCH** unless its owner retires it.
  - `codex/in1-grain-handoff` payloads (`1fb34f22f` -> `edd6d3b7a` on `main`, and `9233c0e10` -> `d51834fff` `ZETA-AND-THE-FULL-MAP.zh.md` on `main`) **are now merged on `main` (`f3cfec345`)**, leaving only the queue-handoff marker commit `38d844a59` on `codex/in1-grain-handoff` in `<scratch-wt-root>/in1-grain-handoff-wt` (**DO NOT TOUCH** until retired by its owner).

| Branch / Ref | Tip SHA | Ahead / Behind `main` (`c65f2b991`) | Last Commit | Worktree Location | Classification |
|---|---|---:|---|---|---|
| `main` | `c65f2b991` | `0 / 0` | 2026-11-25 | `<repo-root>` | **CANONICAL MAIN — DO NOT DELETE** |
| `wave2-real-learner-b1-b2-b3` | `2fa1fd531` | `0 / -6` | 2026-11-25 | *(merged into `main` `f3cfec345`; if `.claude/worktrees/wave2-real-learner-b1-b2-b3` exists, leave untouched)* | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** |
| `swarm-d1-middle-band-e2889178` | `e7378a632` | `+1 / -7` | 2026-11-25 | `<antigravity-worktrees>/18d6300c-ff18-480a-960a-819bf8054d11/swarm-d1-middle-band-e2889178` | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** |
| `swarm-d2-joint-epoch-gate-bdc933c4` | `50b2293af` | `+1 / -7` | 2026-11-25 | `<antigravity-worktrees>/18d6300c-ff18-480a-960a-819bf8054d11/swarm-d2-joint-epoch-gate-bdc933c4` | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** |
| `swarm-d3-youden-gaussian-f15950d9` | `c955516ca` | `+1 / -7` | 2026-11-25 | `<antigravity-worktrees>/18d6300c-ff18-480a-960a-819bf8054d11/swarm-d3-youden-gaussian-f15950d9` | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** |
| `wave4-interface-bits-moving-cone` | `19dbc0920` | `+1 / -4` | 2026-11-25 | *(branch ref only)* | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** |
| `codex/in1-grain-handoff` | `38d844a59` | `+3 / -30` | 2026-11-24 | `<scratch-wt-root>/in1-grain-handoff-wt` | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** (payloads `edd6d3b7a` / `d51834fff` landed on `main` `f3cfec345`) |
| `inquiry-before-commitment` | `d749af845` | `+5 / -70` | 2026-11-24 | `<repo-root>/.claude/worktrees/inquiry-before-commitment` | **ACTIVE / PARKED FRONTIER — DO NOT TOUCH** (parked by Ren's boundary) |

### Sibling Integration & Convergence Swarm Worktrees (Keep Until Integrated)

| Branch / Ref | Tip SHA | Ahead / Behind `main` (`c65f2b991`) | Worktree Location | Role & Status |
|---|---|---:|---|---|
| `rep-v1-stage` | `26295aec8` | `+6 / -1` | `<repo-root>/.claude/worktrees/rep-v1-stage` | Active `v1` integration staging worktree — **DO NOT TOUCH** |
| `wave3-relspan-core` | `45d41ae87` | `+3 / -0` | `<repo-root>/.claude/worktrees/wave3-relspan-core` | Active Wave 3 worktree (existing `refs/salvage/wave3-pre-rebase-20261125` at `5df7053bc`) — **DO NOT TOUCH** |
| `open-deltas-integration` | `0a3fba4cc` | `+4 / -0` | `<scratch-wt-root>/open-deltas-merge-wt` | Active open-deltas integration — **DO NOT TOUCH** |
| `hard-unknowns-pillar-a` | `2ec6b1120` | `+1 / -35` | `<repo-root>/.claude/worktrees/integrator-main` | Active integrator worktree — **DO NOT TOUCH** |
| `swarm-p1-public-pack-7ef5b463` | `1c3623dc5` | `+1 / -4` | `<antigravity-worktrees>/b09eab62-8557-4287-b9f0-aa91d6fab074/swarm-p1-public-pack-7ef5b463` | `v1` Representable swarm worker `p1` |
| `swarm-p2-fronts-bilingual-e06e0e0c` | `889d5c60b` | `+1 / -4` | `<antigravity-worktrees>/b09eab62-8557-4287-b9f0-aa91d6fab074/swarm-p2-fronts-bilingual-e06e0e0c` | `v1` Representable swarm worker `p2` |
| `swarm-p3-canonical-map-svg-844e35d2` | `031f6a442` | `+1 / -4` | `<antigravity-worktrees>/b09eab62-8557-4287-b9f0-aa91d6fab074/swarm-p3-canonical-map-svg-844e35d2` | `v1` Representable swarm worker `p3` |
| `swarm-p4-atlas-joins-4c345033` | `6015c17df` | `+1 / -4` | `<antigravity-worktrees>/b09eab62-8557-4287-b9f0-aa91d6fab074/swarm-p4-atlas-joins-4c345033` | `v1` Representable swarm worker `p4` |
| `swarm-p5-review-hygiene-c6cd5172` | `d5fc8fe63` | `+1 / -4` *(prior tip)* | `<antigravity-worktrees>/b09eab62-8557-4287-b9f0-aa91d6fab074/swarm-p5-review-hygiene-c6cd5172` | `v1` Representable swarm worker `p5` (this branch) |
| `wave1-finite-prob-krylov` | `fe748cd10` | `0 / -6` | *(branch ref only)* | Landed Wave 1 ancestor of `main`; keep until Ren approves cleanup |
| `frontiers-integration` | `b40b47a2e` | `0 / -12` | *(branch ref only)* | Landed integration ancestor of `main`; keep until Ren approves cleanup |
| `landing1-cleanup-a1` | `53f9cf598` | `0 / -60` | `<repo-root>/.claude/worktrees/landing1-cleanup-a1` | Landed earlier worktree; safe to remove worktree only after confirming clean working tree & Ren's approval |
| `landing2-track-b` | `3469a61e5` | `0 / -34` | `<repo-root>/.claude/worktrees/landing2-track-b` | Landed earlier worktree; safe to remove worktree only after confirming clean working tree & Ren's approval |

---

## 2. Inactive Unmerged Branches Requiring `refs/salvage/` Archival Before Any Retirement

Repository local branches total **300** relative to `main` `c65f2b991` (**268** already merged into `main`, **32** unmerged). Excluding the **15** active/parked/integration/swarm unmerged branches in Section 1 leaves **17** older or superseded unmerged branches split into two groups:

### Group 2A — 24 November Superseded / Cherry-Applied Branches (`git cherry -v main`)

All commits on the first five branches carry `-` in `git cherry -v main` (already applied on `main`); the remaining two carry mixed `+`/`-` commits from 24 November integration rounds. Recommend verifying diffs and creating salvage refs **before** deleting any branch ref:

| Branch | Tip SHA | Ahead / Behind (`c65f2b991`) | Last Commit | `git cherry -v main` Signature | Recommended Salvage Ref (`git update-ref ... <sha>`) |
|---|---|---:|---|---|---|
| `track-s1-becoming-spec` | `75a04ed88` | `+1 / -60` | 2026-11-24 | `-` | `refs/salvage/branches/2026-11/track-s1-becoming-spec` |
| `track-s2-consequence-duality` | `321076d99` | `+1 / -60` | 2026-11-24 | `-` | `refs/salvage/branches/2026-11/track-s2-consequence-duality` |
| `track-s3-entry-and-replay` | `7c4cabf43` | `+1 / -60` | 2026-11-24 | `-` | `refs/salvage/branches/2026-11/track-s3-entry-and-replay` |
| `sprint-mapfront` | `6c54b1b98` | `+2 / -69` | 2026-11-24 | `- -` | `refs/salvage/branches/2026-11/sprint-mapfront` |
| `sprint-stresslab` | `7c879bee0` | `+2 / -69` | 2026-11-24 | `- -` | `refs/salvage/branches/2026-11/sprint-stresslab` |
| `sprint-5decisions-landing` | `e629a7b56` | `+3 / -58` | 2026-11-24 | `+ - +` | `refs/salvage/branches/2026-11/sprint-5decisions-landing` |
| `wave3-spec-duality-finish` | `961e3e998` | `+4 / -30` | 2026-11-24 | `- - + +` | `refs/salvage/branches/2026-11/wave3-spec-duality-finish` |

*(Inspect the `+` commits on `sprint-5decisions-landing` and `wave3-spec-duality-finish` with `git diff main...<branch>` to confirm their contents are superseded by later `main` landings before retiring the branch pointers.)*

### Group 2B — Inactive Early/Mid-November Unmerged Branches (`2026-11-03` to `2026-11-13`)

These **10** historical unmerged branches are `760` to `2,858` commits behind `main` (`c65f2b991`) and **must** be salvaged under `refs/salvage/branches/...` per Rule 5 before any `git branch -D` is executed upon Ren's approval:

| Branch | Tip SHA | Ahead / Behind (`c65f2b991`) | Last Commit | `git cherry -v main` | Recommended Salvage Command (Run Before Any Retirement) |
|---|---|---:|---|---|---|
| `ue31-design` | `a8bb44f7d` | `+10 / -2858` | 2026-11-03 | `+` x8 (non-merge) | `git update-ref refs/salvage/branches/2026-11/ue31-design a8bb44f7d` |
| `t2-life-cycle` | `221131d73` | `+2 / -2802` | 2026-11-03 | `+ +` | `git update-ref refs/salvage/branches/2026-11/t2-life-cycle 221131d73` |
| `t1-premises-follow` | `59c3dff9c` | `+1 / -2558` | 2026-11-04 | `+` | `git update-ref refs/salvage/branches/2026-11/t1-premises-follow 59c3dff9c` |
| `t2-statement` | `4e5c6ee0c` | `+2 / -2528` | 2026-11-04 | `+ +` | `git update-ref refs/salvage/branches/2026-11/t2-statement 4e5c6ee0c` |
| `fv` | `a2ee1043e` | `+2 / -2514` | 2026-11-04 | `+ +` | `git update-ref refs/salvage/branches/2026-11/fv a2ee1043e` |
| `rae-salvage-claim` | `29ab2731b` | `+1 / -2328` | 2026-11-04 | `+` | `git update-ref refs/salvage/branches/2026-11/rae-salvage-claim 29ab2731b` |
| `aa-atlas-v1` | `41bece768` | `+2 / -2281` | 2026-11-04 | `+ +` | `git update-ref refs/salvage/branches/2026-11/aa-atlas-v1 41bece768` |
| `claude/epic-mirzakhani-e296ee` | `21462d3f1` | `+1 / -1431` | 2026-11-09 | `-` | `git update-ref refs/salvage/branches/2026-11/claude-epic-mirzakhani-e296ee 21462d3f1` |
| `tt-records-theorem` | `5335e1f76` | `+1 / -760` | 2026-11-13 | `-` | `git update-ref refs/salvage/branches/2026-11/tt-records-theorem 5335e1f76` |
| `wu-kit` | `a7bcc64f8` | `+5 / -760` | 2026-11-13 | `- + - - +` | `git update-ref refs/salvage/branches/2026-11/wu-kit a7bcc64f8` |

*(Wait to run any `git branch -D <branch>` until Ren approves; never run `git prune` or `git gc --prune`.)*

---

## 3. Merged Local Branches, Remote Refs, and Stashes

1. **Merged local branches (`268` branches with `+0` ahead of `main` `c65f2b991`):** Every commit on these branches is already reachable from `main`. Exclude active/worktree refs (`main`, `wave2-real-learner-b1-b2-b3`, `wave1-finite-prob-krylov`, `frontiers-integration`, `landing1-cleanup-a1`, `landing2-track-b`), optionally mirror older branch pointers under `refs/salvage/merged-2026-11/<name>`, and tidy the remaining merged refs with safe `git branch -d` only when Ren confirms.
2. **Remote branches (`11` refs: `local/main` `d6ea89e72`, `origin/main` `963ff4caf`, `origin/HEAD`, and `9` October `origin/claude/*` branches from `2026-10-06`–`2026-10-07`):** **DO NOT TOUCH / DO NOT PUSH** (Rule 7 prohibits remote pushes or remote branch deletions until Ren decides the work is ready).
3. **Stashes (`2` entries):** Archive both under `refs/salvage/stashes/...` before inspecting diffs against `main` or dropping:
   - `stash@{0}` (`b2cbacf72`, 2026-11-13, `WIP on dw-centre: 07f348b6d ...`) -> `git update-ref refs/salvage/stashes/dw-centre-20261113 b2cbacf72`
   - `stash@{1}` (`79056c104`, 2026-10-31, `WIP on el-claim: eb3045799 ...`) -> `git update-ref refs/salvage/stashes/el-claim-20261031 79056c104`

---

## 4. Lean Modules and `_process/.../development/` Scratch Inventory

Counts below exclude `.lake/` and `*-checks/` build/verification output trees unless explicitly noted.

### Group 4A — Canonical & Active Lean Trees (KEEP IN PLACE)

- **`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/` (`437` non-cache `.lean` files):** `Becoming.lean` + `436` files under `Becoming/` (**439** modules in `becoming-verification.json` core closure: `418` core modules + `11` instance + `7` application + `3` external foundation modules; plus `Becoming/FallibleInquiry.lean` in periphery). Zero cleanups needed.
- **`experiments/integrated-correction/general-framework/generative-basis/lean/deeper/` (`95` non-cache `.lean` files):** **KEEP** — `check_dossiers.py` (`BLOCK_DIRS`) scans `deeper/` for verbatim Lean blocks in `theories/becoming/review/*.md`, and `deeper/RelationalRenewal.lean` is part of the foundation manifest.
- **`experiments/integrated-correction/general-framework/generative-basis/lean/conditional/` (`13` non-cache `.lean` files under `renewal/`):** **KEEP READ-ONLY** per Ren's `3A` decision alongside `RenewalBridge`.
- **Verified periphery & active standalone modules (KEEP):** `periphery-mathlib-pin/` (`1`), `finite-prob-krylov/` (`2`), `observational-fidelity/` (`18`), `survival-distinguishability/` (`4`), `quantitative-transfer/` (`9`), `alignment-reals/` (`34`), `becoming-reals/` (`9`), `consequence-duality/` (`4`), `encounter-entry/` (`2`), `becoming-spec/` (`6`), `becoming-spec-check/` (`2`), `new-possibilities-checks/` (`3`), plus `physics/` (`1`), `warning/` (`1`), `regime/` (`1`), `representation/` (`1`), and `free-energy/` (`4`).

### Group 4B — Legacy October/Early-November Lean & Development Scratch (Audit Before Moving)

- **`32` top-level `*.lean` files in `experiments/integrated-correction/general-framework/generative-basis/lean/*.lean`:** `GenerativeCore.lean` is part of the foundation manifest (**KEEP**). The remaining `31` standalone October files (`AcquiredPerspective.lean`, `BoundaryModels.lean`, `RootRealization.lean`, etc.) should be cross-checked against `RESULTS.md`, `TESTS.md`, `theories/becoming/results/records/*.json`, and `review/*.md`; any unreferenced files can be moved via `git mv` into `lean/history/` only upon Ren's approval.
- **Historical & thematic Lean directories:** `history/` (`270` non-cache `.lean`), `inquiry-root/` (`369` — **KEEP** `inquiry-root/sufficiency/InquirySufficiency.lean`, which is part of the foundation manifest), `systems-complexity/` (`89`), `universal-ethics/` (`346`), `verification-history/` (`80`), `verification-runs/` (`17`), `learning/` (`23`), `naturalism/` (`16`). Leave untouched as git-tracked history unless Ren specifically requests consolidating historical trees.
- **`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/` (`463` non-check `.lean` files, `86` `.lean.txt` files):**
  - **KEEP** provenance directories referenced by `review/*.md`, `TESTS.md`, `RESULTS.md`, and recent milestones: `review-packet/`, `aj4-alignment-readers/`, `rp2-philosophy/`, `frontier3-quantitative-transfer-2026-11-24/`, `alignment-foundation-pack-2026-11-24/`, `parallel-wave-2026-11-24/`, `full-picture-decisions-2026-11-24/`, `dual-track-waves-2026-11-24/`, `v1-representable-hygiene/`, and `item12-endogenous-emergence-2026-11-24/` (latest Nov 24 artifact).
  - *Note on `ZETA-AND-THE-FULL-MAP.zh.md`:* Already landed on `main` (`d51834fff` / `f3cfec345`); older share-branch copies branched at `2fa1fd531` leave it untracked in their working trees and should leave it untouched rather than deleting it.
  - Inactive October/early-November scratch probes in superseded task folders may be archived under `_process/history/` via `git mv` in a dedicated post-`v1` hygiene pass once Ren approves; never run `git clean` on untracked artifacts.
