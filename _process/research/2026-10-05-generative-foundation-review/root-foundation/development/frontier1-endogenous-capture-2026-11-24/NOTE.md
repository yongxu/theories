# Frontier 1: Endogenous Detection Before Capture Lock & Split Evidence

*AI-written (`f1-lean-builder`, 24 November 2026), following pre-Lean adversarial sign-off in [`PAPER-ATTACK.md`](PAPER-ATTACK.md) (`f1-critic` Checkpoint 1 PASS, board `#25`). Built and verified strictly on this Mac (`AGENTS.md` Rules 1–7); shared global files (`Becoming.lean`, `BECOMING-WORKBOARD.md`, `periphery-manifest.json`, `regions.json`, `CANONICAL-MAP.md`) untouched.*

---

## 1. Deliverables on Branch `swarm-f1-lean-builder-8dd0b4ab`

1. **`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousEmergence.lean`** (commit `ae2d1abdb`):
   Promoted from `_process/research/.../item12-endogenous-emergence-2026-11-24/scratch/Becoming/EndogenousEmergence.lean.txt`. On promotion, `chiChainProof`, `chiChainInvProof`, `chiChainProof_commutes_chiConstFlat`, and `wholeArchitecture_oplax_guarded_bridge` were updated to take `OplaxHistory.SpanFunctor` (replacing `SumPreservingFunctor`, matching `DoubleKernel.GuardedExpr.assemble` on `main`). `42` theorems, `100` declarations, `with_axioms: {}`, `0` warnings, `0` `private`, `0` `sorry`.
2. **`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/frontier1-endogenous-capture-2026-11-24/PAPER-ATTACK.md`** (commit `5ad2bd6af`):
   Pre-Lean mathematical attack revised after `f1-critic` review (`#21`) and signed off (`#25`).
3. **`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousDetectionRace.lean`** (commit `213301264`):
   `Init`-only 0-axiom Lean 4 module (`import Becoming.EndogenousEmergence`, `Becoming.ClosedCapture`, `Becoming.PacedStock`), `69` theorems, `105` declarations, `with_axioms: {}`, `0` warnings, `0` `private`, `0` `sorry`, compile `0.988s`, axiom audit `0.522s`.
4. **`experiments/evidence-replay/test_split_evidence_capture_race.py`** (commit `f5ac7a03d`):
   Pre-registered pure-Python stdlib empirical replay (`R1`–`R5`, `PYTHONDONTWRITEBYTECODE=1`, `0` `MARKET_WORDS`, `0` `__pycache__`), passing `9/9` in `experiments/evidence-replay`.

---

## 2. Theorem Summary (`Becoming.EndogenousDetectionRace`)

### Part A — Capture-Lock Race (`EndogenousEmergence` ↔ `ClosedCapture` ↔ `PacedStock`)

- **Gate & Lockout (`gate`, `gatedStep`, `gatedOrbit`):**
  `gated_eq_closed` proves an admission gate changes nothing while the learner intends `.extract`. `lockout_pure_extract` and `lockout_learner_irrelevant` prove that once locked out from `τ` on (`admit k = false`), substrate stock equals `pureExtractStock` regardless of what any `UnguidedLoop` intends or registers.
- **Generic Marked Selection (`markRead`, `markCourse`):**
  `mark_reads_beyond` and `race_reads_beyond` prove `¬ Unread` (`ClosedCapture`) when registration takes both values at a separating share, whereas `closed_race_registration_irrelevant` applies `ClosedCapture.join_alike` to show the closed counterpart is invariant to the learner's state.
  `mark_eq_thinned` proves exact share-and-rule equivalence with `ClosedCapture.Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀)` whenever `mark` holds from `τ` onward, making `Thinned`'s bare parameter `N` the learner's registration step `τ`.
  `mark_never_eq_pre` and `closed_trap_outlives_loss` show that when `mark` never holds, share and rule match the closed pool (`Drawn.through_locks`) and outlive the accruing loss (`ClosedCapture.lock_outlives_loss`).
- **Cadence-General Pre-Capture Window:**
  For any reading schedule `reads : Nat → Bool`, `mark_kept_iff` (`Thinned.kept_iff`) and `mark_kept_locks_out` characterize capture lock-in at any reading step `r ≥ τ` (`others_r ≤ carriers_r`); `mark_turned_iff` characterizes turning at the next reading step `r' > r`; `mark_turned_admits_iff` proves the exact `↔` characterization `(∀ k, disfavours g_{r+1+k} ∧ admits s_{r+1+k} = true) ↔ carriers_{r+1} ≤ others_{r+1}` via `region_stays` after `Thinned.past_course`.
- **Witnesses (`W1`–`W6`, `emergentLoop`, `u = hi`, `v = Second.oneToOne`, `w = lo`, `x₀ = 14`):**
  - `race_in_time` (`others = 20`, `wEndo`, every step): registers from `4`, turns permanently from `5` (`mark_turned_admits_iff`), equals `closedOrbit` forever (`10 ≥ 6`).
  - `race_late_after_registration` (`others = 12`, `wEndo`, every step): registers from `4`, locked out from `4`, locked in capture from `5` (`mark_kept_iff` + `mark_kept_locks_out`), `stock 7 = 3 < 6`.
  - `race_probe_blocked` (`others = 4`, `wEndo`, every step): locked out from `2`, probe overwritten to `.extract`, resolves unregistered (`unregistered_forever_of_resolved`), closed-pool trap from `2` (`closed_trap_outlives_loss`), `stock 5 = 3 < 6`.
  - `race_masked_strain` (`others = 20`, `wMasked`, every step): plateau capped at `10` shifts registration to `5`, locked out from `6`, capture-locked from `8` (`mark_kept_locks_out` at `r = 7`), `stock 8 = 3 < 6`.
  - `race_slow_cadence` vs `race_fast_cadence` (`others = 64`, `wEndo`): `cadence3_readAtSpanEnd` proves `PacedStock.ReadAtSpanEnd (fun j => 3 * j) cadence3`; `cadence3` locks out from `4` and collapses (`stock 7 = 3 < 6`), while every-step reading on the same start survives forever (`6 ≤ stock t`).
  - `race_exo_no_false_turn` (`others = 20`, `wExo`, every step): never registers; closed-pool rule favours carriers at every step.

### Part B — Split-Evidence Impossibility & Witness-Silencing Consensus

- **Tag Permutation & Exact Zero Local Marginal:**
  `feed_lockstep`, `retag_symmetry` (`retag` involution + cross-world shift), `split_two_of_two` (`viewB d θ t = viewA (retag d θ) t` and dual), and `count_view_invariant` prove by structural induction on `T` that `countTags T (fun θ => F (viewBList d θ)) = countTags T F`. Hence `split_marginal_count_eq` proves exact `TP = FP` count equality over all `2^T` tags for every Moore agent `L`, and `split_marginal_impossibility` rules out all-tag separation.
- **Silencing Consensus vs Verdict Leak vs Open Exchange:**
  `silencing_consensus` proves any combination `c` with `c false false = false` over locally sound alarms (`dS`-silent) never fires in `dD`. `verdict_leak` (at `T = t + 1`) shows raw non-sound verdicts recover `d t` via `exchange`. `exchange_detects` proves `exchange (viewA θ t) (viewB d θ t) = d t` for all `θ`.
- **Coupled Selection Dichotomy (`split_silenced_trapped`, `split_exchange_turns`, `split_witness_endo`):**
  Through `markCourse (feedStep ...)`, locally sound consensus keeps the selection `Locked` under the closed pool and outliving the loss for every `θ`, whereas `exchangeLoop` registers at `τ = 2` for every `θ` in `dEndo` (`dEndo 0 = false`, `dEndo 1 = true`), turning the selection to `Thinned.course` (`N = 2`, independent of `θ`) from step `3`, with zero false turns in `dSafe`.

---

## 3. Verbatim Verification Outputs

### Lean (`scratch_build.py`)

Initial build timing of `Becoming.EndogenousDetectionRace` (cold compile from cached closure):

```json
{
  "tree": "/Users/ren/tmp/f1-scratch-race",
  "modules": 240,
  "ran": [
    "Becoming.EndogenousDetectionRace",
    "BecomingEndogenousDetectionRaceAxiomAudit"
  ],
  "reused": 239,
  "unclean": [],
  "audits": {
    "Becoming.EndogenousDetectionRace": {
      "theorems": 69,
      "declarations": 105,
      "with_axioms": {}
    }
  },
  "seconds": {
    "Becoming.EndogenousDetectionRace": 0.988,
    "BecomingEndogenousDetectionRaceAxiomAudit": 0.522
  }
}
```

Clean joint verification of both promoted/added modules in `/Users/ren/tmp/f1-verify` (scratch dirs removed afterward):

```json
{
  "tree": "/Users/ren/tmp/f1-verify",
  "modules": 240,
  "ran": [],
  "reused": 242,
  "unclean": [],
  "audits": {
    "Becoming.EndogenousEmergence": {
      "theorems": 42,
      "declarations": 100,
      "with_axioms": {}
    },
    "Becoming.EndogenousDetectionRace": {
      "theorems": 69,
      "declarations": 105,
      "with_axioms": {}
    }
  },
  "seconds": {}
}
```

### Empirical Replay (`PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v`)

```text
test_exact_fraction_certificates_and_b2_simulation (test_replay_suite.TestDualityHandshake.test_exact_fraction_certificates_and_b2_simulation) ... ok
test_negative_tamper_checks_reject (test_replay_suite.TestDualityHandshake.test_negative_tamper_checks_reject) ... ok
test_in1_229_months_and_target_contrasts (test_replay_suite.TestIN1ReplayHandshake.test_in1_229_months_and_target_contrasts) ... ok
test_disentangled_2d_and_breach_bounds (test_replay_suite.TestPhase2DisentangledStress.test_disentangled_2d_and_breach_bounds) ... ok
test_two_item_8slot_and_b2_b4 (test_replay_suite.TestProtocol8SlotBenchmark.test_two_item_8slot_and_b2_b4) ... ok
test_r1_window_grid_across_cadences (test_split_evidence_capture_race.TestCaptureLockRace.test_r1_window_grid_across_cadences) ... ok
test_r2_no_hardcoded_threshold_and_lockstep_tamper (test_split_evidence_capture_race.TestCaptureLockRace.test_r2_no_hardcoded_threshold_and_lockstep_tamper) ... ok
test_r3_negative_controls (test_split_evidence_capture_race.TestCaptureLockRace.test_r3_negative_controls) ... ok
test_r4_exhaustive_split_marginal_and_closed_capture (test_split_evidence_capture_race.TestSplitEvidenceExhaustive.test_r4_exhaustive_split_marginal_and_closed_capture) ... ok

----------------------------------------------------------------------
Ran 9 tests in 7.257s

OK
```

**Negative-control failure-first findings surfaced by `R3` (kept explicitly):**
1. **Mid-probe gate flip in `W_EXO` (`L ∈ {2, 3, 4}`, `others0 = 20`):** when `admit[2] = True` (`y_safe1 = 9`) and `admit[3] = False`, the gate overwrites step 2's intended `safe` to `extract`, emitting `y = 10 ≥ 9`. The `Obs`-blind learner mistakes the locked-out extraction return for recovery (`reg = True` at `t = 4`), though zero turns follow (`all(favours(g))`) because capture is already locked.
2. **Post-collapse floor degeneracy in `W_CLIFF`:** zero registrations and zero turns occur before/at collapse (`t ≤ 5`, `stock[5] = 3 < 6`); once collapsed onto the `0 → 0` substrate floor (`t = 7`), `0 ≤ 0` fires a post-collapse false pulse (`reg = True` at `t = 7`).
`W_EXO_SHIFT` and `W_INF_PLATEAU` emit zero registrations and zero turns across all tested `(L, others0)`.

**Hygiene checks:**
- `MARKET_EN` / `MARKET_ZH` (`tools/research/style.py`): `0` hits across `PAPER-ATTACK.md`, `EndogenousEmergence.lean`, `EndogenousDetectionRace.lean`, `test_split_evidence_capture_race.py`, and `NOTE.md`.
- `find experiments/evidence-replay -name "__pycache__" -o -name "*.pyc"` → empty (`0` files).

---

## 4. Open / Unproved (Rule 2)

1. The middle band of `mark_kept_iff` / `mark_turned_admits_iff` (`carriers_r ≤ others_r` and `others_{r+1} < carriers_{r+1}`) is left uncharacterized (the grid in `R1` shows alternating starts like `18, 19` can still turn and survive).
2. General sufficiency over arbitrary learners (`which learners register in time`) is not characterized; witnesses fix `emergentLoop`, two reader kinds (`u`, `v`/`w`), and unnormalized `Drawn.pool` counting.
3. Part B's depletion stream `d` is fixed by the world before any action; closed-loop interaction between private masks and substrate drawdown is open. Counting is over all `2^T` binary tags (uniform weight); non-uniform distributions on tags are open.
4. `AGENTS.md` Rule 2: recognizing any actual selection or multi-agent training pipeline as meeting the majority-gate, `Obs`-only, or one-time-mask hypotheses can fail in practice.

---

## 5. Schema-2 Record Draft (For Central Landing)

```json
{
  "schema_version": 2,
  "id": "endogenous-detection-before-capture-lock",
  "title": {
    "en": "Endogenous detection before capture lock and split evidence",
    "zh": "捕获锁定前之内生检测与分裂证据"
  },
  "kind": "theorem",
  "status": "draft",
  "family": "F04",
  "statement": {
    "en": "An observation-only learner moving a pool reading at its registration step hits the exact ClosedCapture window: locked out if already outnumbered when read, turning permanently if not outnumbered next step. Under one-time-mask split evidence, sound local filters stay silent while exchange turns.",
    "zh": "仅读任务回报之学习者，其登记步令他者之池读切换，恰落入封闭捕获之窗口：读步时若载体已不少则锁定，次步仍不占优则永转。一次掩码分裂证据下，局部可靠警报归零，交换一位则转。"
  },
  "hypotheses": [
    {
      "en": "No Lean axiom. Discrete steps; Moore-machine learner reading only primary task return; majority admission gate on CarrierCounts; two-kind unnormalized Drawn.pool; mirror reading for others after registration; one-bit mask split streams over binary tag prefixes.",
      "zh": "无 Lean 公理。离散步；仅读原任务回报之摩尔机学习者；基于载体计数之多数准入闸门；两类未归一化之阅读池；登记后他者取镜像阅读；基于二进制标签前缀之单位掩码分裂流。"
    }
  ],
  "laws": [
    {
      "en": "Gate and lockout: where intended restraint is admitted, the gated course matches the closed orbit (gated_eq_closed); once locked out, stock follows pure extraction regardless of what any learner intends or registers (lockout_pure_extract, lockout_learner_irrelevant).",
      "zh": "闸门与锁定：凡欲节制处获准入，受闸进程即合无闸轨道（gated_eq_closed）；一旦锁定，无论学习者欲何或登记何，存量皆归纯抽取（lockout_pure_extract、lockout_learner_irrelevant）。",
      "declarations": [
        "Becoming.EndogenousDetectionRace.gated_eq_closed",
        "Becoming.EndogenousDetectionRace.lockout_pure_extract",
        "Becoming.EndogenousDetectionRace.lockout_learner_irrelevant"
      ]
    },
    {
      "en": "Pre-capture turning window for any reading cadence: whenever registration holds from step tau, share and rule match Thinned.course with loss bound tau (mark_eq_thinned), giving exact capture lock-in (mark_kept_iff, mark_kept_locks_out) and exact cadence-general admission (mark_turned_iff, mark_turned_admits_iff).",
      "zh": "任意阅读节奏下之捕获前转向窗口：凡登记自第 tau 步起成立，份额与规则即合阈值 tau 之稀释历程（mark_eq_thinned），给出精确锁定（mark_kept_iff、mark_kept_locks_out）与任意节奏下之精确准入充要条件（mark_turned_iff、mark_turned_admits_iff）。",
      "declarations": [
        "Becoming.EndogenousDetectionRace.mark_eq_thinned",
        "Becoming.EndogenousDetectionRace.mark_kept_iff",
        "Becoming.EndogenousDetectionRace.mark_kept_locks_out",
        "Becoming.EndogenousDetectionRace.mark_turned_iff",
        "Becoming.EndogenousDetectionRace.mark_turned_admits_iff"
      ]
    },
    {
      "en": "Six separating witnesses for emergentLoop: timely turn (race_in_time), late registration after lock-in (race_late_after_registration), probe blocked (race_probe_blocked), strain masked one step longer (race_masked_strain), cadence separation under PacedStock.ReadAtSpanEnd (race_slow_cadence, race_fast_cadence, cadence3_readAtSpanEnd), and exogenous control (race_exo_no_false_turn).",
      "zh": "涌现学习者之六组分离见证：及时转向（race_in_time）、迟登记仍锁（race_late_after_registration）、探针被阻（race_probe_blocked）、应变多掩一步（race_masked_strain）、阅读节奏独自决定存亡（race_slow_cadence、race_fast_cadence、cadence3_readAtSpanEnd）及外生对照不误转（race_exo_no_false_turn）。",
      "declarations": [
        "Becoming.EndogenousDetectionRace.race_in_time",
        "Becoming.EndogenousDetectionRace.race_late_after_registration",
        "Becoming.EndogenousDetectionRace.race_probe_blocked",
        "Becoming.EndogenousDetectionRace.race_masked_strain",
        "Becoming.EndogenousDetectionRace.cadence3_readAtSpanEnd",
        "Becoming.EndogenousDetectionRace.race_slow_cadence",
        "Becoming.EndogenousDetectionRace.race_fast_cadence",
        "Becoming.EndogenousDetectionRace.race_exo_no_false_turn"
      ]
    },
    {
      "en": "Split-evidence marginal conservation and witness-exchange coupling: retag involution preserves all 2^T tag counts (retag_symmetry, count_view_invariant, split_marginal_count_eq), silencing locally sound consensus into closed capture (silencing_consensus, split_silenced_trapped), while raw verdicts leak (verdict_leak) and one-bit exchange turns the selection (exchange_detects, split_exchange_turns, split_witness_endo).",
      "zh": "分裂证据之局部边际守恒与见证交换耦合：重标对合保持全部 2^T 标签计数不变（retag_symmetry、count_view_invariant、split_marginal_count_eq），令局部可靠共识归于零并锁于封闭池（silencing_consensus、split_silenced_trapped），非可靠裁决则泄证（verdict_leak），单位交换则令选择转向（exchange_detects、split_exchange_turns、split_witness_endo）。",
      "declarations": [
        "Becoming.EndogenousDetectionRace.retag_symmetry",
        "Becoming.EndogenousDetectionRace.count_view_invariant",
        "Becoming.EndogenousDetectionRace.split_marginal_count_eq",
        "Becoming.EndogenousDetectionRace.silencing_consensus",
        "Becoming.EndogenousDetectionRace.verdict_leak",
        "Becoming.EndogenousDetectionRace.exchange_detects",
        "Becoming.EndogenousDetectionRace.split_silenced_trapped",
        "Becoming.EndogenousDetectionRace.split_exchange_turns",
        "Becoming.EndogenousDetectionRace.split_witness_endo"
      ]
    }
  ],
  "does_not_show": [
    {
      "kind": "open-boundary",
      "en": "The middle band where carriers are fewer than others at reading step r yet outnumber them at r + 1 is left uncharacterized.",
      "zh": "阅读步 r 时载体尚少于他者而于 r + 1 步反超之中段未加刻画。"
    },
    {
      "kind": "scope-boundary",
      "en": "Part B fixes the depletion stream before agents act and counts uniformly over all 2^T binary tags; closed-loop mask-substrate coupling and non-uniform tag distributions are open.",
      "zh": "乙部假定耗竭信号于行动前给定且对全部 2^T 标签均匀计数；掩码与底物之闭环耦合及非均匀标签分布仍开放。"
    },
    {
      "kind": "normative-firewall",
      "en": "Endogenous registration remains confined to self-returning continuation and leaves one-way downstream dependents unranked (emergent_order_firewall).",
      "zh": "内生登记仅及于自返之相续，不赋予单向受累者任何位序（emergent_order_firewall）。",
      "witness": "Becoming.EndogenousEmergence.emergent_order_firewall"
    }
  ],
  "not_required": [
    {
      "en": "No exogenous alarm, threshold constant, or regime label is read by the learner.",
      "zh": "学习者不读取任何外生警报、阈值常数或体制标签。"
    }
  ],
  "standard_boundaries": [
    "no-ethical-premise",
    "no-evaluation",
    "discrete-steps",
    "formal-not-empirical",
    "names-provisional",
    "omission-not-refutation"
  ],
  "validation_scope": {
    "en": "Lean 4.29.1 Init-only scratch_build.py verified Becoming.EndogenousEmergence (42 theorems, 100 declarations, empty axiom report) and Becoming.EndogenousDetectionRace (69 theorems, 105 declarations, empty axiom report); pure-Python stdlib replay test_split_evidence_capture_race.py passes within 9/9 evidence-replay tests.",
    "zh": "Lean 4.29.1 纯 Init 经 scratch_build.py 验明 Becoming.EndogenousEmergence（42 定理、100 声明、空公理报告）与 Becoming.EndogenousDetectionRace（69 定理、105 声明、空公理报告）；纯标准库回放随 evidence-replay 通过 9/9。"
  },
  "next_delta": {
    "en": "Wire Becoming.EndogenousEmergence and Becoming.EndogenousDetectionRace into Becoming.lean and manifest on central merge; characterize the middle band between mark_kept_iff and mark_turned_admits_iff.",
    "zh": "于中央合入时将两模块接入 Becoming.lean 与清单；刻画 mark_kept_iff 与 mark_turned_admits_iff 间之中段。"
  },
  "related": [
    {
      "id": "closed-capture-outlives-loss",
      "detail": {
        "en": "ClosedCapture.Thinned treats the threshold N at which others read the loss as a parameter; here N is derived from an observation-only learner's registration step.",
        "zh": "ClosedCapture.Thinned 以他者读损阈值 N 为外参；此处 N 由仅读回报学习者之登记步内生导出。"
      }
    }
  ]
}
```
