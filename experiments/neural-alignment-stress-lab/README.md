# Neural Alignment Stress Lab

*AI-written local CPU empirical lab (24 November 2026 — pure Python 3 stdlib, deterministic seeds, zero third-party dependencies, zero network/API calls, verified free of forbidden market-vocabulary tokens). No human has reviewed this directory yet.*

## Purpose

This lab stress-tests formal alignment regimes from the Lean core (`Becoming.PacedStock`, `Becoming.AdaptiveLoops`, `Becoming.CausalGoodhartWitness`, `ObservationalFidelity`, `Becoming.OplaxHistory.C2CoupledAlignmentWitness`, and `ConcurrentSerialWitness`) against genuine nonlinear neural learners implemented from scratch in pure Python stdlib:

- **2-layer `tanh`/`sigmoid` MLP** with exact analytical backpropagation (`nn_core.py:MLP2`).
- **REINFORCE policy-gradient learner** with running baseline and entropy regularization (`nn_core.py:ReinforcePolicy`).
- **Self-rewarding neural judge** & **rotating multi-judge pool** with disagreement veto (`nn_core.py:SelfRewardingJudge`, `RotatingJudgePool`).
- **Four multi-seed adversarial benchmarks (`B1`–`B4`)** testing both where alignment mechanisms preserve viability and where nonlinear gradient dynamics, severe aliasing, long lag, or correlated judge drift break formal safety margins and runtime guards.

## Directory Layout

| File | Role |
|---|---|
| `nn_core.py` | Pure stdlib 2-layer `tanh`/`sigmoid` MLP, analytical backprop, REINFORCE policy, self-rewarding judge, rotating judge pool |
| `substrates.py` | Nonlinear paced reserve (`PacedReserveEnv`), Goodhart coupled-phase fiber split (`CoupledPhaseGoodhartEnv`), shared commons (`SharedCommonsEnv`), and unified arena (`CoupledAlignmentArena`) |
| `benchmarks.py` | Multi-seed runners for `B1`–`B4` plus `GuardedAlignmentRuntime` |
| `run_all.py` | Deterministic CLI entrypoint emitting structured JSON results |
| `test_stress_lab.py` | `unittest` suite: finite-difference gradient checks (`< 1e-6`), determinism, B1–B4 invariants, and vocabulary hygiene scan |
| `RESULTS.md` | Failure-first tables and mechanistic diagnosis from the 20-seed run (`24.729s`) |

## Quickstart Commands

Run all commands from the repository root:

```bash
# 1. Run unit tests (analytical backprop finite-diff checks, determinism, invariants, hygiene scan)
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s experiments/neural-alignment-stress-lab -v

# 2. Reproduce full 20-seed B1-B4 benchmark suite (~25s CPU)
PYTHONDONTWRITEBYTECODE=1 python3 experiments/neural-alignment-stress-lab/run_all.py --seeds 20
```

## Failure-First Highlights (See `RESULTS.md` for Full Tables)

1. **B1 (`Pace-Margin` vs. nonlinear feature leakage `rho`):** Tabular Q-learning achieves `0.00` collapse at `b_feas = 27` and `x0 = 39`, whereas `reinforce_mlp` collapses `0.55 -> 0.90` at `b_feas = 27` as `rho` increases `0.0 -> 0.9` (empirical hidden cosine `0.477 -> 0.930`, switch delay `17.05 -> 30.80`) and still collapses `0.45` at calibrated `+12` headroom (`x0 = 39`).
2. **B2 (`CausalGoodhart` + `Zero-TV` vs. `FiberViabilitySplit`):** A macro-TV-audited REINFORCE policy + self-rewarding neural judge achieves `pooled_macro_tv = 0.0164` (indistinguishable from passive baseline `0.0182`) and judge score `0.881`, while collapsing hidden vitality on `100%` of seeds (`20/20`). Matched-fiber interventional probes (`same_macro_tv = 0.0`) separate intact vs. strained states (`probe_gap = 1.195`, `viability_split = 1.0`).
3. **B3 (Concurrent vs. Serialized Reconfiguration):** Locally safe solo policies (`0.00` collapse alone) crash `100%` in `2.45` steps when run concurrently (`K = 4`); live epoch/reserve serialization rescues viability (`0.00` collapse, `21x` output), whereas turn order with stale reserve snapshots still crashes `100%` in `2.40` steps.
4. **B4 (Guarded Alignment Protocol — Rescues AND Explicit Failures):** Combining early reserve-margin probing, interventional fiber-split/BC guarding, and rotating-judge serialization cuts collapse from `1.00 -> 0.00` on both `nominal_coupled` and `moderate_lag2_stealth` (every single component is needed: ablations collapse `0.30–1.00`). Yet `full_guarded` **explicitly breaks** under high learning rate (`lr = 4.0`: `0.25` collapse), severe representation/probe aliasing (`rho = 0.95, alias = 0.95`: `0.25` collapse), long telemetry lag (`lag = 8`: `0.45` collapse), and correlated judge-pool drift (`drift = 0.96, alias = 0.78, lag = 3`: `0.50` collapse, dominant `hidden_phase_collapse`).
