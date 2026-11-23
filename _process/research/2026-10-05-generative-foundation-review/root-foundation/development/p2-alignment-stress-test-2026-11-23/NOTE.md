# Phase 2 Local CPU Alignment Stress Test: Milestones 1A & 1B

*AI-written study note (23 November 2026, local CPU stdlib run — Rule 7 compliant, zero external calls).*

Reproducible script: [stress_test.py.txt](stress_test.py.txt)

Formal targets under test:
- Milestone 1A (`Becoming.PacedStock`): [paced-stock-and-cadence-margin-sandwich](../../../../../../theories/becoming/results/records/paced-stock-and-cadence-margin-sandwich.md)
- Milestone 1B (`Becoming.AdaptiveLoops`): [coupled-adaptive-loops-and-race](../../../../../../theories/becoming/results/records/coupled-adaptive-loops-and-race.md)

## Why run this check

The Lean proofs establish exact discrete-`Nat` regime bounds under deterministic hypotheses (`H1`/`H2` draw bounds, noise-free `ReadAtSpanEnd`, instantaneous span switch, strict unread channels, and exact best-response / `LoopCertificate` contracts). This local simulation stress-tests where those regimes carry over under stochastic observation noise, heavy draw spikes, policy-update inertia, bandit/Q-learning exploration, and partial feature leakage — and records where softened empirical conditions depart from the formal bounds.

## 1. Milestone 1A (`PacedStock`) Stress Sweeps

Parameter regime matching `SandwichWitness`: `N = 3` (`2N - 1 = 5`), `H1 = 4`, `H2 = 1`, `y2 = 2` (`floor = 3`), `Y = 1`, `R_safe = 1`, `L = 5`, deterministic impossibility cutoff `b_imp = 18`, deterministic feasibility cutoff `b_feas = 27`, horizon `80`, `200` seeded trials per sweep cell.

1. **Deterministic grid verification (`21/21` assertions passed):**
   - For all `L < 5`, observation aliasing blocks policy switching; for all `x0 < 18`, collapse occurs; for all `L >= 5` and `x0 >= b_feas`, survival holds (`100%`).
2. **Observation noise delaying span-end identification (`sigma`):**
   - At exact deterministic threshold `x0 = 27`, survival drops `1.000` (`sigma=0`) -> `0.990` (`sigma=1.5`) -> `0.875` (`sigma=3.0`) -> `0.810` (`sigma=5.0`) -> `0.680` (`sigma=8.0`).
   - With `+12` margin headroom (`x0 = 39`), survival rises to `0.945` (`sigma=5.0`, mean switch step `6.01`) and `0.915` (`sigma=8.0`, mean switch step `6.09`).
3. **Stochastic `+4` draw spikes (`p_spike`):**
   - At `x0 = 27`, survival falls `1.000` (`p=0.00`) -> `0.995` (`p=0.05`) -> `0.980` (`p=0.15`) -> `0.835` (`p=0.30`), whereas `x0 = 39` holds `1.000` through `p = 0.30`.
4. **Policy-update inertia (`alpha` blending factor per step):**
   - Exponential transition inertia (`alpha = 1.0, 0.5, 0.25, 0.125`) drains `x0 = 27` to `final_x = 12.0, 9.0, 3.0, 0.0` (fails at `alpha = 0.125`); `x0 = 39` survives even at `alpha = 0.125` (`final_x = 3.0`).
5. **Failure of worst-case impossibility below `b_imp` under noise (`x0 = 15 < 18`):**
   - Deterministic draws crash `100%` (`survival_rate = 0.0`), while unbiased Gaussian draw jitter creates `2.5%` escapes at `jitter_std = 1.0` (`0.5%` at `jitter_std = 2.0`), confirming `coupled_two_rule_impossibility` relies on sustained worst-case `H1` drawdown before switching.

## 2. Milestone 1B (`AdaptiveLoops`) Learning Sweeps

Two agents sharing depleting substrate (`x_crit = 5`, `cap = 25`, `R = 0` below `x_crit`, `40` seeds per configuration; solo `aggressive` draw `2` is viable alone, joint draw `4` collapses):

1. **Unread $\varepsilon$-greedy bandits & exploratory entropy (`horizon = 100`, `x0 = 14`):**
   - At `R = 2`, collapse rate is `1.000` across all `eps` (`0.05, 0.25, 0.60, 0.90`; mean proxy payoff `0.823–0.983`).
   - At `R = 3` (where symmetric mixed draws `1 + 2 <= 3` avoid drainage), low/moderate exploration collapses (`0.975` at `eps=0.05`, `1.000` at `eps=0.25, 0.60`), while heavy uniform exploration (`eps = 0.90`, violating exact `Selecting` optimization) cuts collapse to `0.575` (`mean_final_x = 4.28`).
2. **Episodic Q-learning under the `CoupledRace` (`80` training episodes, `5`-watcher majority pool):**
   - `good_buffered_coordinated` (`warn=13, lag=1, q_silence=0.0, p_coord=1.0`): `0.000` eval collapse (`mean_eval_min_x = 8.25 >= 5`).
   - `too_slow_lag3_unbuffered` (`warn=9, lag=3, q_silence=0.0, p_coord=1.0`): `1.000` eval collapse (`0.00`).
   - `silenced_pool_q05` (`warn=13, lag=1, q_silence=0.5, p_coord=1.0`): `0.250` eval collapse (`5.90`).
   - `uncoordinated_post_turn` (`warn=13, lag=1, q_silence=0.0, p_coord=0.0`): `1.000` eval collapse (`0.00`).
3. **Honest negative/limiting result — linear FA under partial cross-channel leakage (`rho`):**
   - Even when congestion penalty `rho` leaks (`0.0..0.80`) into local action payoff via smoothed latency features (`ema_lat`), single-episode gradient adaptation still collapses `100%` at `warn_onset = 10` (`R = 2`) and `97.5%` even with early `warn_onset = 22` (`x0 = 25, R = 3, mean_final_x = 0.35`).
   - **Takeaway:** Breaking strict channel blindness (`unread`) in real gradient learners is not automatically sufficient for single-run safety; adaptation learning rate and congestion-signal slope must overtake the drawdown race (`1A` buffer vs lag) before crossing `x_crit`.
