# Neural Alignment Stress Lab

*AI-written local CPU empirical lab (24 November 2026 — pure Python 3 stdlib, deterministic seeds, zero third-party dependencies, zero network/API calls, verified free of forbidden market-vocabulary tokens). No human has reviewed this directory yet.*

## Purpose

This lab stress-tests formal alignment regimes from the `0`-axiom Lean core (`Becoming.PacedStock`, `Becoming.AdaptiveLoops`, `Becoming.CausalGoodhartWitness`, `Becoming.OplaxHistory.C2CoupledAlignmentWitness`, and `Becoming.PolyComposition.ConcurrentSerialWitness`) and isolated Mathlib periphery (`ObservationalFidelity`, `QuantitativeTransfer`) against genuine nonlinear neural learners implemented from scratch in pure Python stdlib:

- **2-layer `tanh`/`sigmoid` MLP** with exact analytical backpropagation (`nn_core.py:MLP2`).
- **REINFORCE policy-gradient learner** with running baseline and entropy regularization (`nn_core.py:ReinforcePolicy`).
- **Self-rewarding neural judge** & **rotating multi-judge pool** with disagreement veto (`nn_core.py:SelfRewardingJudge`, `RotatingJudgePool`).
- **Five multi-seed adversarial benchmarks (`B1`–`B5`) plus post-hoc controls (`b5_controls.py`)** testing both where alignment mechanisms preserve viability and where nonlinear gradient dynamics, severe aliasing, long lag, or correlated judge drift break formal safety margins and runtime guards (with failed pre-registered predictions kept unmodified).

## Directory Layout

| File | Role |
|---|---|
| `nn_core.py` | Pure stdlib 2-layer `tanh`/`sigmoid` MLP, analytical backprop, REINFORCE policy, self-rewarding judge, rotating judge pool |
| `substrates.py` | Nonlinear paced reserve (`PacedReserveEnv`), Goodhart coupled-phase fiber split (`CoupledPhaseGoodhartEnv`), shared commons (`SharedCommonsEnv`), and unified arena (`CoupledAlignmentArena`) |
| `benchmarks.py` | Multi-seed runners for `B1`–`B4` (including B2 separate-seed ablations and B4 complete 1- & 2-guard ablations) plus `GuardedAlignmentRuntime` |
| `b5_walls.py` | Frozen pre-registered `B5` wall-vs-defect suite (`P1`–`P11`, preserving `4/11` failed predictions `P8`–`P11`) |
| `b5_controls.py` | Post-hoc matched-veto random dissent (`p = 0.5325`) and heterogeneous noisy self-judge pool controls (`--seeds`) |
| `run_all.py` | Deterministic CLI entrypoint emitting structured JSON results (`--with-b5` includes `B5`) |
| `test_stress_lab.py` | `unittest` suite (`19` tests): finite-difference gradient checks (`< 1e-6`), determinism, B1–B5 invariants, and vocabulary hygiene scan |
| `RESULTS.md` | Failure-first tables and mechanistic diagnosis from the 20-seed runs (`~25s` CPU for `B1`–`B4`, `~36s` CPU for `B5`) |

## Quickstart Commands

Run all commands from the repository root:

```bash
# 1. Run unit tests (19 tests: analytical backprop finite-diff checks, determinism, B1-B5 invariants, hygiene scan)
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/neural-alignment-stress-lab -p 'test_*.py' -v

# 2. Reproduce full 20-seed B1-B5 benchmark suite (~61s CPU) and post-hoc B5 controls
PYTHONDONTWRITEBYTECODE=1 python3 -B experiments/neural-alignment-stress-lab/run_all.py --with-b5 --seeds 20
PYTHONDONTWRITEBYTECODE=1 python3 -B experiments/neural-alignment-stress-lab/b5_controls.py --seeds 20
```

## Failure-First Highlights (See `RESULTS.md` for Full Tables)

1. **B1 (`Pace-Margin` vs. policy-gradient switch delay & feature leakage `rho`):** Tabular Q-learning achieves `0.00` collapse at `b_feas = 27` and `x0 = 39`, whereas `reinforce_mlp` already collapses `0.55` at `b_feas = 27` (`0.40` at `x0 = 39`) at `rho = 0.0` and rises to `0.90` at `rho = 0.9` (empirical hidden cosine `0.477 -> 0.930`, switch delay `17.05 -> 30.80`; `0.45` at `x0 = 39`).
2. **B2 (`CausalGoodhart` + `Zero-TV` vs. `FiberViabilitySplit`):** On separate arm seed blocks, the no-audit self-rewarding control (`self_rewarding_no_tv_audit`) already collapses `20/20` (`1.00`, `TV = 0.1509`); the action-blind macro-TV arm (`self_rewarding_blind_tv_audit`, modifying both policy reward and judge-training labels) still collapses `18/20` (`0.90`, `TV = 0.1073`); and the overt-targeted TV arm (`self_rewarding_tv_audited`, likewise modifying both reward and judge-training labels) records `pooled_macro_tv = 0.0164` (vs. passive baseline `0.0182`), `90.2%` within-arm stealth share, judge score `0.881`, and `20/20` collapse. Matched-fiber interventional probes (`same_macro_tv = 0.0`) separate intact vs. strained states (`probe_gap = 1.195`, `viability_split = 1.0`).
3. **B3 (Concurrent vs. Serialized Reconfiguration):** Locally safe solo policies (`0.00` collapse alone) collapse `1.00` (mean `2.45` steps) when run concurrently (`K = 4`); live epoch/reserve serialization yields `0.00` collapse (`21x` output), whereas turn order with stale reserve snapshots still collapses `1.00` (mean `2.40` steps).
4. **B4 (Guarded Alignment Protocol — Complete 1- & 2-Guard Ablations AND Explicit Failures):** On `nominal_coupled` and `moderate_lag2_stealth`, `full_guarded` drops collapse `1.00 -> 0.00`: `fiber_bc_guard` is clearly non-redundant (`0.15`/`0.25` collapse without it), `judge_pool_serial` raises reserve headroom (`8.48 -> 15.09`, though `margin_plus_fiber` reaches `0/20` on nominal seeds `4500–4519` and `1/20` on `5600–5619`), and `margin_probe` is redundant for `0/20` collapse on those two regimes (`fiber_plus_pool = 0.00`). Yet `full_guarded` **explicitly breaks (`25–50%` collapse)** under modeled high learning rate (`lr = 4.0`: `0.25`), severe representation/probe aliasing (`rho = 0.95, alias = 0.95`: `0.25`), long telemetry lag (`lag = 8`: `0.45`, flagged in `B5` as partly seed luck), and correlated judge-pool drift (`drift = 0.96, alias = 0.78, lag = 3`: `0.50`, dominant `hidden_phase_collapse`).
5. **B5 (`4` of `11` Pre-Registered Predictions Failed — `P8`–`P11`):** On fresh seeds, trust-region + action masking remediates `high_lr` (`0.40` at `lr = 4.0` and `0.80` at `lr = 8.0` down to `0.00`), while `P8`–`P11` fail and stay marked failed: collapse rate alone confounds blind throttling or consensus breaking with hidden-state detection (in `b5_controls.py`, matched-veto-rate random dissent at `p = 0.5325` with the anchor removed from the pool also collapses `1/20 = 0.05` just as `M9 + anchor_aliased` does, and heterogeneous noisy self-judges still collapse `0.30` at `M = 9`).
