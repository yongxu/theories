# 一小时独立外部人工审计指南（生灭变化与对齐包）

[English](HUMAN-AUDIT-GUIDE.md) · [首页](../../README.zh.md) · **人工审计指南** · [对齐基础](ALIGNMENT-FOUNDATION.zh.md) · [规范地图](CANONICAL-MAP.zh.md)（[英文](CANONICAL-MAP.md)） · [一页](ONE-PAGE.zh.md) · [成果登记（英文）](../../RESULTS.md) · [检验](../../TESTS.zh.md) · [审查包](review/README.zh.md)

*AI 所写的核验清单（2026 年 11 月 24 日自 `_process/` 提升至此处，并与现行回执同步）。本指南尚未经人工审查。义以[英文版](HUMAN-AUDIT-GUIDE.md)为准。专为外部 Lean 或 AI 对齐研究者设计，使审计者不必信任任何摘要叙述，即可直接核查 [ALIGNMENT-FOUNDATION.zh.md](ALIGNMENT-FOUNDATION.zh.md)（及其[英文版](ALIGNMENT-FOUNDATION.md)）中的各项主张。*

预计总耗时：在具备 Python 3.11+ 的干净检出中约 **60 分钟**（若要在第一步可选重编核心则需 Lean `v4.29.1`；若要在第二步可选重编 Mathlib 外围模块则需 Lean `v4.30.0-rc2` 及锁定的 Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`）。建议在运行 Python 命令时加上 `-B` 或设置 `PYTHONDONTWRITEBYTECODE=1`，以保持工作树不生成字节码缓存。

---

## 第一步（约 10 分钟）—— 核心 `0` 公理回执审计（主线）

1. 直接检查保留的核心回执 [`becoming-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json)，而非仅凭说明文字判断，并用 Python 核验全部 `31,228` 条声明的 `axiom_dependencies`：

```bash
python3 -B -c "
import json
from pathlib import Path
v = json.loads(Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json').read_text())
bad = [(m['module'], k, d) for m in v['modules'] for k, d in m['axiom_dependencies'].items() if d]
print('status=', v['status'], 'toolchain=', v['toolchain'], 'retained_run=', v['retained_run'])
print('closure=', len(v['core_closure']), 'core=', len(v['core_modules']),
      'decls=', sum(len(m['declarations']) for m in v['modules']),
      'thms=', sum(m['theorems'] for m in v['modules']),
      'nonempty_axiom_deps=', len(bad))
assert v['status'] == 'passed' and not bad
"
```

   - 核实 `"status": "passed"`、`"toolchain": "leanprover/lean4:v4.29.1"`、`"retained_run": "becoming-checks/20261124T233040.232087Z"`、`core_closure` 规模（`439` 个模块，其中 `418` 个核心模块）、声明总数（`31,228`）、定理总数（`22,087`），且 `nonempty_axiom_deps= 0`。
   - 对照 [`RESULTS.md`](../../RESULTS.md)（英文）核对登记册计数：**`600` 项已登记结果**（`569` 项 `recorded-checked`、`20` 项 `reviewed-scoped`、`3` 项 `open`、`7` 项 `superseded`、`1` 项 `withdrawn`）。

2. **可选（全量重编较慢，无缓存时超出 60 分钟时间窗）：** 通过工作树锁包装命令重新运行核心检查器。注意 [`check_becoming.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py) 会重新编译全部 `439` 个模块、**不接受任何 CLI 参数**，并会在 `becoming-checks/` 下写入新的带时间戳保留目录；若需保持工作树干净，请仅检查或清理你自己新建的运行目录：

```bash
make lean-check
```

3. 若要对单个改动后的 `.lean` 文件做快速隔离检查而不写入完整回执，请使用 [`scratch_build.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py)：

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py <scratch_dir> Becoming.PacedStock
```

---

## 第二步（约 10 分钟）—— 外围隔离（`16` Mathlib + `2` 非 Mathlib）与独立轨道

1. 通过 [`check_periphery.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py) 与 [`periphery-manifest.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/periphery-manifest.json) 核实全部 **`18`** 个外围检查器（含 **`16` 个 Mathlib `v4.30.0-rc2` 模块**——包括第 1 波共享基础叶 `FiniteProbKrylov`、B1–B2 `FiberLumpable` 汇合、`QuantitativeTransfer` 第 1–9 部分，以及第 4 波 `InterfaceBits` 与 `MovingFeatureCone`——以及 **`2` 个非 Mathlib 外围模块** `Becoming.FallibleInquiry` 与 `RenewalBridge`，运行于 `v4.29.1`）均与 `0` 公理核心隔离，且 SHA-256 新鲜度检查为 `0` 过期：

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py --check-stale
```

2. 也可选择直接重跑 6 个主要对齐外围检查器（需 Lean `v4.30.0-rc2` 与锁定的 Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`；`--module` 必须使用 `periphery-manifest.json` 中的精确 PascalCase `module` 名称）：

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py \
  --module FiniteProbKrylov --module ObservationalFidelity --module SurvivalDistinguishability \
  --module QuantitativeTransfer --module AlignmentReals --module BecomingReals
```

3. 同时核查独立轨道——明确区分 **`0` 公理独立轨道（`BecomingSpec` `26` 项目标、`EncounterEntry` `35` 条定理、留出负向适配器 `RelSpanEncounterAdapter` `7` 条定理 / `13` 条声明 [`0` 源/传递公理，未用结构生成引理 `ExitOcc.mk.injEq` 用 `[propext]`]）** 与 **基于 Mathlib 的独立核验轨道（`ConsequenceDuality` + `DualityBridges` + `DualityLifting` + `TrackBKrylovBridge`，使用标准 Mathlib 公理 `Classical.choice`、`Quot.sound`、`propext`）**——以及 [`experiments/evidence-replay/`](../../experiments/evidence-replay/README.md)（`16/16` 测试通过，含 `R5` 中段三分/单调性、`R6` 闭环分裂/加权标签与 8 槽内生静默漂移自检基准）：
   - [`becoming-spec-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/becoming-spec-verification.json)（双工具链 `0` 公理 `26` 项目标，覆盖 `v4.29.1` 与 `v4.30.0-rc2`，`4/4` 篡改自检均拒绝通过）
   - [`encounter-entry-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/encounter-entry-verification.json)（仅依赖 `Init` 的 `0` 公理开放入口，`35` 条定理，`4/4` 负向自检均拒绝通过）与 [`relspan-encounter-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/relspan-encounter-verification.json)（`0` 源/传递公理、`7` 条定理、`RelSpan.mapTrace` + `EncounterEntry` 留出负向适配器）
   - [`consequence-duality-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/consequence-duality-verification.json)、[`duality-bridges-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-bridges-verification.json)、[`duality-lifting-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-lifting-verification.json) 与 [`trackb-krylov-bridge-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/trackb-krylov-bridge-verification.json)（基于 Mathlib 的独立核验）

---

## 第三步（约 15 分钟）—— 逐行审读核心入口 Lean 声明的非空性与锐度

绕过一切摘要，直接在 Lean 源码中检验定理前提：

1. **未读基底盲区与最优耗竭：** [`Selection.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Selection.lean)（`Becoming.Flow.unselected_beyond_coupling`、`Becoming.Flow.unselected_beyond_coupling_all`）与 [`Optimum.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean)（`Optimum.least_of_room`、`Optimum.Room`、`Web.optimum_broken_iff`）。核查耦合是由外部固定还是内生形成，并核查 `Optimum.Room` 要求在耦合族上严格胜过前者的前提。
2. **闭合自我重配锁定与内生捕获竞赛：** [`ClosedCapture.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean)（`Becoming.ClosedCapture.lock_outlives_loss` —— 核对 `Locked`、`Raises`、`ReadsShare`、偏好上闭性、`Accrues` 与无噪声前提）、[`EndogenousEmergence.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousEmergence.lean)（`endogenous_emergence_sufficiency`、`emergent_order_firewall`）与 [`EndogenousDetectionRace.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousDetectionRace.lean)（`mark_eq_thinned`、`mark_turned_admits_iff`、`mark_middle_band_trichotomy`、`mark_middle_band_monotone_partition`、`cadence2_readAtSpanEnd`、`split_marginal_count_eq`、`split_silenced_trapped`、`split_exchange_turns`）。核查确定性与仅依赖 `Obs` 的边界。
3. **节奏与余裕的不可挽回界：** [`PacedStock.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PacedStock.lean)（`blocks_kernel_iff_fine_kernel` 配 `CoveredByBlocks`/`SpanGuard`、`slack_certifies_fine_kernel` 配 `stepDrop * (L - 1)`、`pace_margin_feasibility_window`、`unrecoverable_cadence_impossibility`）。核查整数前提（`nGe2 : 2 ≤ N`、`yLtH1 : Y < H₁`、`h1Le : H₁ ≤ H₂ + y₂`）。
4. **并发竞争、假设—保证组合与开放纪元：** [`AdaptiveLoops.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AdaptiveLoops.lean)（`coupled_race_theorem`、`assume_guarantee_joint_viable`）、[`PolyComposition.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PolyComposition.lean)（`ConcurrentSerialWitness.concurrent_serial_dichotomy`）与 [`OpenEndedComposition.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenEndedComposition.lean)（`constantEpoch_iff_transformsViably`、`epochChain_viability_kernel_on_K`、`epochChain_nonDeadlock`、`reciprocal_evolve_rejects_8_and_certifies_11`、`jointEpochFamily_gate_iff_reciprocalGate`、`jointBool_simultaneous_refused_at_8`、`jointBool_simultaneous_certified_at_11`）。
5. **B1–B2 共享概率/Krylov 叶与可观察归并汇合：** [`FiniteProbKrylov.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/finite-prob-krylov/FiniteProbKrylov.lean)（`FiniteProb.optimal_query_tv_floor`、`FiniteKrylov.krylovSub_stabilizes_before_rank`、`FiniteKrylov.FiberLumpable`、`FiniteKrylov.survival_indistinguishable_iff_le_obs_pred`、`FiniteKrylov.lumpable_obs_horizon_one_witness`）、[`ObservationalFidelity.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/observational-fidelity/ObservationalFidelity.lean)（`fiberLumpable_iff_exists_zero_rowDefect`、`fixed_macro_nonzero_rowDefect_witness`）与 [`SurvivalDistinguishability.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/survival-distinguishability/SurvivalDistinguishability.lean)（覆盖全部模态词的 `survival_indistinguishable_iff_le_card_pred`、`survival_indistinguishable_iff_le_obs_pred`、`countdown_attains_card_pred`、`three_state_mode_switch_counterexample`）。核实可观察视界压缩仅在次随机生存矩阵上具有区分效力（行归一马尔可夫核恒给出 `survVec = 1`）。
6. **端到端脊柱、锐度反模型与 `not_entails` 防火墙：** [`AlignmentSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean)（`SharpnessSuite`、`master_sharpness_suite_complete`、`alignment_spine_end_to_end`、`alignmentSpine_not_entails`）、[`MasterSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean)（`whole_becoming_master_theorem`、`masterSpine_cannot_entail_unrestricted`）与 [`ScopeDynamics.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean)（`scopeLaw_cannot_entail_unrestricted`）。重点核查非空性（`Inhabited` / 证明全部前提既可同时满足、又可逐一舍弃的具体见证）。

---

## 第四步（约 10 分钟）—— 复现运行时文法、证据重放与压力实验室失败案例

1. 在仓库根目录下使用子 shell 运行[`守卫对齐运行时`](../../experiments/guarded-alignment-runtime/README.md)的 6 项对齐方案单元测试（`28` 项单元测试、`14` 个内置示例，含 `7` 个风格化、由 AI 编写的 `alignment_proposal` 提案规格）并检查 `OBSTRUCTED` 与 `GUARDED` JSON 报告：

```bash
(cd experiments/guarded-alignment-runtime && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s tests -v && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run all && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run proposal_guarded_open_alignment --json)
```

2. 直接从仓库根目录运行本地[`神经对齐压力实验室`](../../experiments/neural-alignment-stress-lab/RESULTS.md)（`B1`–`B5` 及事后对照 `b5_controls.py`，`19` 项单元测试，`B5` 将失败的 `4/11` 项预注册预测 `P8`–`P11` 置前）与 [`experiments/evidence-replay/`](../../experiments/evidence-replay/README.md)（`16` 项证据重放测试，含 `R5` 中段三分/单调性、`R6` 闭环分裂/加权标签与 8 槽内生静默漂移自检基准），并结合第 2 波[`真实学习者 B1/B2 与配对 B3 研究`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-waves-2026-11-24/real-learner-b1-b2-b3/RESULTS.md)（`chosen_m = null`，Arm C `online_passed = false`）：

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/neural-alignment-stress-lab -p 'test_*.py' -v
PYTHONDONTWRITEBYTECODE=1 python3 -B experiments/neural-alignment-stress-lab/run_all.py --with-b5 --seeds 20
PYTHONDONTWRITEBYTECODE=1 python3 -B experiments/neural-alignment-stress-lab/b5_controls.py --seeds 20
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v
```

---

## 第五步（约 15 分钟）—— 怀疑审稿人评分卡

在对任何对外综述签字认可之前，严格依据第 1–4 步核验以下六项问题：

| # | 审计问题 | 可证伪核查处 |
|---|---|---|
| 1 | **是否存在空类型或空洞前提陷阱？** 所有不可能性定理与守卫定理是否均实例化了具体的非空见证（`SharpnessSuite`、`OplaxHistory` 非空族）？ | [`AlignmentSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean), [`OplaxHistory.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OplaxHistory.lean) |
| 2 | **对先前文献是否坦诚？** 对 Zhuang & Hadfield-Menell、Hubinger et al.、Arthur、Stigler、Hardin、Hadfield-Menell et al. 的重述是否如实注明，而非冒充全新定理？ | [`08-METHOD.md#known-results`](chapters/08-METHOD.md#known-results), [`DEBTS.md`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/kd-known-results-debts/DEBTS.md) |
| 3 | **实证、压力实验室与第 2 波失败是否保持诚实？** `MQ3`、`EM1`、`IN1`、`UE31b`、`LA2`、`B4` 的 `25–50%` 守卫下崩溃率、`B5` 的 `P8`–`P11` 失败，以及第 2 波[`真实学习者 B1/B2`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-waves-2026-11-24/real-learner-b1-b2-b3/RESULTS.md)（`chosen_m = null`、B2 Arm C `online_passed = false`）是否置于有利案例之前？ | [`TESTS.zh.md#by-thesis`](../../TESTS.zh.md#by-thesis), [`神经对齐压力实验室`](../../experiments/neural-alignment-stress-lab/RESULTS.md), [`real-learner-b1-b2-b3/RESULTS.md`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-waves-2026-11-24/real-learner-b1-b2-b3/RESULTS.md) |
| 4 | **是否守住规则 2 的模型—世界区分？** 每份运行时裁断与文档是否均明确拒绝从有限 `Nat`/`Fraction` 模型（及风格化 AI 自编规约）自动外推至真实神经网络策略？ | [`proposal_audit.py`](../../experiments/guarded-alignment-runtime/guarded_alignment/proposal_audit.py), [`ALIGNMENT-FOUNDATION.zh.md`](ALIGNMENT-FOUNDATION.zh.md) |
| 5 | **是否守住动力学—伦理防火墙（`not_entails`）？** 每份文档是否都严格陈述 `not_entails`：在至少有一个立场与一个形成（`p : Pos`, `f : F`）的前提下，任何只读取动力学且可满足的律都不蕴涵对一切意义赋值成立的 `Unrestricted`（由构造成立）？ | [`ScopeDynamics.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean), [`MasterSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) |
| 6 | **门户页面与底层来源是否对齐？** `ALIGNMENT-FOUNDATION.zh.md`、`CANONICAL-MAP.zh.md` 与 `ONE-PAGE.zh.md` 中的全部主张是否与 [`RESULTS.md`](../../RESULTS.md)、[`TESTS.zh.md`](../../TESTS.zh.md) 及 [`08-METHOD.md`](chapters/08-METHOD.md) 相符，且未给出强于底层记录与回执所支撑的表述？ | [`RESULTS.md`](../../RESULTS.md), [`TESTS.zh.md`](../../TESTS.zh.md), [`08-METHOD.md`](chapters/08-METHOD.md) |
