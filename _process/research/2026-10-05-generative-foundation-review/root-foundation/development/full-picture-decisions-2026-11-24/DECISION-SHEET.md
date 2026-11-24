# Full-Picture Decision Sheet for Ren / 全景决策单（待 Ren 拍板）

> **Status (24 November 2026, 18:32 WIB):** **Approved (`1A 2B 3A 4A 5A`)** by Ren (`"Ren 都认可，请继续。"`, [verbatim record](../../../../../../sources/15-codex-theory-conversations/2026-11-24-approve-five-full-picture-decisions.md)); Rule 7 local-only hold remains in force.

*AI-written 1-page decision menu (24 November 2026; held loosely under [AGENTS.md](../../../../../../AGENTS.md)). Distills the 5 open junctions in [CANONICAL-MAP.md §4.4](../../../../../../theories/becoming/CANONICAL-MAP.md#44-open-decisions-waiting-on-ren) (through Wave U6: `593` results, `435` closure / `414` core modules, `21,789` theorems, `13` periphery modules) so you can settle all five with a single short line (e.g., `1A 2B 3A 4A 5A`).*

---

## 1. Aim Wording in `AGENTS.md` / `AGENTS.md` 方向措辞更新
**Context:** [AGENTS.md](../../../../../../AGENTS.md) stays untouched per Rule 3 until you read the change. Row DJ drafted a replacement retiring *"two ways"* (matching [DIRECTION.md](../../../../../../_process/DIRECTION.md)'s 23 Nov 3-layer framing), and Row GR filed one sentence (`SENTENCE-FOR-AGENTS.md.txt`).
- **Option A (Approve targeted wording update):** Apply DJ's retirement of *"two ways"* + GR's sentence to `AGENTS.md` in one small diff for your final sign-off, aligning `AGENTS.md` with [DIRECTION.md](../../../../../../_process/DIRECTION.md). *Trade-off:* Removes front-door drift immediately; requires one quick diff read.
- **Option B (Hold `AGENTS.md` as-is):** Keep `AGENTS.md` frozen until after your cold read of [CANONICAL-MAP.md](../../../../../../theories/becoming/CANONICAL-MAP.md) and chapter sync. *Trade-off:* Zero edits to `AGENTS.md` now; new sessions keep seeing the older *"two ways"* phrasing beside `DIRECTION.md`.
- **AI Recommendation / 建议:** **Option A** — one small diff aligns every new session with your 23 Nov 3-layer direction.

## 2. Reading `WayUnderARule` at Need = 27 / `WayUnderARule`（需求 = 27）之读法：`Tested` 还是 `Turned`？
**Context:** In [a-way-of-units-under-a-rule-set-again](../../../../../../theories/becoming/results/records/a-way-of-units-under-a-rule-set-again.md), units reproducing under a re-set rule hit a first step where no need is met when the counted unit itself goes without (`NeedTwentySeven`).
- **Option A (Count as *turning in time* / 计作「及时转向」):** Treat halting when the dominant unit's own need fails as a limiting case of *turning in time* (`Turned`), because the rule ceases to reproduce the drain. *Trade-off:* Unifies ecological self-halting with feedback turning, but blurs the line between *changing course before exhaustion* and *stopping only upon exhaustion*.
- **Option B (Count purely as ecological exhaustion / 仅计作生态耗竭，记为 `Tested`):** Keep `NeedTwentySeven` classified as ecological die-off of the dominant unit, reserving *turning in time* for pre-exhaustion course change (`TurningInTime`, `PacedStock`, `AdaptiveLoops`). *Trade-off:* Keeps alignment vocabulary sharp and honest under Rule 2; leaves `WayUnderARule` as an exhaustion boundary rather than a turning witness.
- **AI Recommendation / 建议:** **Option B** — matches how [CANONICAL-MAP.md](../../../../../../theories/becoming/CANONICAL-MAP.md) and `PacedStock` / `AdaptiveLoops` separate pre-exhaustion turning from crash-induced halting.

## 3. Formal Cleanup Queue: `WayUnderARule` Stage 2 & October `conditional/renewal/` / 形式化清理队列
**Context:** Two legacy formal items remain open on [BECOMING-WORKBOARD.md](../../../../../../_process/BECOMING-WORKBOARD.md): (i) `WayUnderARule` Stage 2 (calling two older `LineOnAStock` inductions / whether `StockFlowBridge` absorbs or leaves `ends_all`), and (ii) the October `conditional/renewal/` folder, now bridged verbatim to `Becoming.KeepableStep` by [RenewalBridge](../../../../../../theories/becoming/results/records/renewal-bridge-to-keepable-step.md) (periphery #12).
- **Option A (Execute Stage 2 join & keep `conditional/renewal/` read-only archived):** Run Stage 2 so `WayUnderARule` / [StockFlowBridge](../../../../../../theories/becoming/results/records/unclamped-stock-flow-bridge.md) cleanly subsume the two `LineOnAStock` inductions (Rule 4: one proof over two), and leave October's `conditional/renewal/` intact as a read-only bridged archive. *Trade-off:* Removes duplicate core lemmas while preserving October's receipts untouched (Rule 5).
- **Option B (Freeze both as-is):** Leave `WayUnderARule` Stage 2 undone and `conditional/renewal/` untouched; put zero Lean cycles into legacy refactoring. *Trade-off:* Saves verification time now, but keeps two older `LineOnAStock` proofs beside `WayUnderARule` and `StockFlowBridge`.
- **AI Recommendation / 建议:** **Option A** — small, bounded cleanup that enforces Rule 4 without risking October history.

## 4. Phase 0 Compaction & Frozen `results/map/` Disposition / 第 0 阶段精简与冻结视图 `results/map/` 处置
**Context:** Phase 0 split [DIRECTION.md](../../../../../../_process/DIRECTION.md) and [BECOMING-WORKBOARD.md](../../../../../../_process/BECOMING-WORKBOARD.md) into compact fronts plus archives on `main`. Meanwhile [theories/becoming/results/map/README.md](../../../../../../theories/becoming/results/map/README.md) remains frozen at `186` dynamics / `66` tests (live atlas is `204` dynamics / `593` results).
- **Option A (Keep compact fronts; retire `results/map/` to archive):** Confirm the compact `DIRECTION.md` / `BECOMING-WORKBOARD.md` layout as permanent, and retire the stale `results/map/` snapshot (pointing readers to [CANONICAL-MAP.md](../../../../../../theories/becoming/CANONICAL-MAP.md) + live [ATLAS.md](../../../../../../theories/becoming/results/atlas/ATLAS.md)). *Trade-off:* Eliminates a stale duplicate surface (Rule 4); loses a separate static export until a future release needs one.
- **Option B (Keep compact fronts; unfreeze & regenerate `results/map/`):** Keep the compact fronts, and unfreeze `results/map/` to regenerate it at `204` dynamics / `593` results. *Trade-off:* Restores a fresh snapshot, but creates another generated surface to maintain alongside `CANONICAL-MAP.md` and `ATLAS.md`.
- **AI Recommendation / 建议:** **Option A** — one live map (`CANONICAL-MAP.md` + `ATLAS.md`) avoids maintaining stale mirrors.

## 5. Chapter `01–06` Sync & External API Hold Timing (Rule 7) / 第 1–6 章同步与外部 API 暂停时机
**Context:** Chapters `01`–`06` lag Milestones 1A–1C and Waves U1–U6 (exact surgical touchpoints mapped in [CHAPTER-SYNC-BLUEPRINT.md](CHAPTER-SYNC-BLUEPRINT.md); `07`–`08` need only light U6 rows). Under Rule 7, all external API runs (`LA4 Stage B`, `T2O`, `T1B`, real-learner stress calibration) stay local Mac only.
- **Option A (Approve surgical chapter sync now; keep Rule 7 local hold):** Execute the minimal link-and-record sync in [CHAPTER-SYNC-BLUEPRINT.md](CHAPTER-SYNC-BLUEPRINT.md) (no full prose rewrites) while keeping all external API runs paused on this Mac. *Trade-off:* Brings `01`–`08` into alignment with `CANONICAL-MAP.md` immediately with zero external API runs or remote pushes.
- **Option B (Hold chapter sync until after cold read; keep Rule 7 local hold):** Wait for your full cold read of `CANONICAL-MAP.md` before touching `01`–`06`, and keep Rule 7 local hold in place. *Trade-off:* Zero chapter churn before your feedback; `01`–`06` remain pre-1A–U6 in the meantime.
- **AI Recommendation / 建议:** **Option A** (surgical pointer sync only, keeping Rule 7 local hold strict) — or **Option B** if you prefer to read `CANONICAL-MAP.md` first.

---

**Quick Reply / 快速回复模板：** Reply with five codes (e.g. `1A 2B 3A 4A 5A`, or add any short note per number). Nothing in `AGENTS.md`, `01`–`06`, `results/map/`, or external runs changes until you say the word.
