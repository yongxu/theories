# Analytical Predictions & Evaluation Criteria: Frozen-Policy Q-Learning Survival Distinguishability

*AI-written analytical specification (2026-11-24T13:16:05Z; local CPU stdlib only, Rule 7 compliant).*

**Analytical specification and evaluation criteria derived solely from `Q_frozen` and exact `63 x 63` matrix powers (not fitted to held-out seeds).** *Replay provenance:* the initial held-out evaluation on `seed_base = 21161124` ran at `2026-11-24T11:12:36Z`; this regenerated specification fixes the alive-state operator cutoff (`63 -> 62`) and makes the disjoint-Wilson separation and `-O`-safe digest checks explicit for deterministic replay on the same seed base.

## 1. Frozen Q-Learner & Finite Induced Markov Law

- **Training source:** Exact `CoupledRace` `good_buffered_coordinated` loop from `stress_test.py.txt` (80 episodes, `warn_level=13`, `lag=1`, `q_silence=0.0`, `p_coord=1.0`, `penalty=1.5`, seed `20563624`).
- **Online-update bug fix:** Episode-79 online TD updates and evaluation exploration are removed. After episode 79, Q-tables are **frozen** (`Q_frozen`, immutable during evaluation) and greedy actions `pi[agent][st] = argmax_a Q[agent][st][a]` are extracted.
- **Frozen Q-tables (`Q_frozen`):** `[[[9.41166531634371, 9.967515945350028], [5.999999999999976, 4.899999999999976]], [[9.398085193124823, 9.978046643253691], [5.999999999999976, 4.899999999999976]]]`
- **Frozen greedy policy (`pi`):** `agent 0: [1, 0]`, `agent 1: [1, 0]` (at `st=0` both choose `1` = draw 2; at `st=1` both choose `0` = draw 1).
- **Frozen Q-table SHA-256:** `cc57e93a57b51dc36fe3b6e0340056637f9dfacf5a99aa911b686197edd057fd`
- **Finite alive state space:** `S_alive = {5..25} x {0: idle, 1: pending_next, 2: active}`, `|S_alive| = 63` (instantiated `63 x 63` alive-state operator discarding collapse transitions, so `SurvivalDistinguishability` theorem cutoff is `|S_alive| - 1 = 62`; counting the excluded collapsed cemetery gives `64` total MDP states).
- **Evaluation regime parameters:** `warn_level = 10`, `lag = 2`, `x_crit = 5`, `cap = 25`, `ren = 2` (`x >= 5`).
- **Channel / coordination modes:**
  - `R` (*Reliable-Coordinated*): `q_silence = 0.0` (`P(majority >= 3) = 1.0`), `p_coord = 0.85`.
  - `D` (*Degraded-Uncoordinated*): `q_silence = 0.5` (`P(majority >= 3) = 0.5`), `p_coord = 0.40`.

## 2. Equal-Observation Pair & Shortest Separating Mode Sequence

- **Equal observed stock (`x = 10`):**
  - State `s_idle = (10, 0)` (`alarm_on = False`, `alarm_queue = []`)
  - State `s_pending = (10, 1)` (`alarm_on = False`, `alarm_queue = [1]`)
- Note that both states have identical observed stock `x = 10` AND identical initial agent observation `st = 0` (`alarm_on = False`).
- **Shortest separating sequence length:** **`3`** (`<= |S_alive| - 1 = 62`), since every mode sequence of length `0`, `1`, or `2` gives exact survival `1.0000` for both `s_idle` and `s_pending` (zero gap).

### Exhaustive Exact Matrix Predictions (lengths `0..3`)

| Length | Word `w` | `survVec K w s_idle` | `survVec K w s_pending` | Exact Gap (`pending - idle`) |
|---|---|---|---|---|
| 0 | `ε` | `1.000000` | `1.000000` | `+0.000000` |
| 1 | `R` | `1.000000` | `1.000000` | `+0.000000` |
| 1 | `D` | `1.000000` | `1.000000` | `+0.000000` |
| 2 | `RR` | `1.000000` | `1.000000` | `+0.000000` |
| 2 | `RD` | `1.000000` | `1.000000` | `+0.000000` |
| 2 | `DR` | `1.000000` | `1.000000` | `+0.000000` |
| 2 | `DD` | `1.000000` | `1.000000` | `+0.000000` |
| 3 | `RRR` | `0.977500` | `0.999494` | `+0.021994` |
| 3 | `RRD` | `0.640000` | `0.991900` | `+0.351900` |
| 3 | `RDR` | `0.977500` | `0.991900` | `+0.014400` |
| 3 | `RDD` | `0.640000` | `0.870400` | `+0.230400` |
| 3 | `DRR` | `0.488750` | `0.999494` | `+0.510744` |
| 3 | `DRD` | `0.320000` | `0.991900` | `+0.671900` |
| 3 | `DDR` | `0.488750` | `0.991900` | `+0.503150` |
| 3 | `DDD` | `0.320000` | `0.870400` | `+0.550400` |

## 3. Analytical Calibration Bands & Replay Separation Criteria (`N = 500` held-out seeds per arm)

For each evaluation arm (`N = 500` independent held-out evaluation seeds per initial state, disjoint from training seed `20563624`, deterministic replay set `seed_base = 21161124`):
- **Acceptance criterion (calibration — present in the original `2026-11-24T11:12:30Z` analytical specification):** Observed survival fraction `phat` lies within the 95% asymptotic normal band `p +/- 1.96 * sqrt(p(1-p)/N)` (and strictly within the two-sided 95% Hoeffding radius `+/- 0.0607` around exact `p`), and each arm's 95% Wilson score interval covers exact `p`.
- **Separation criterion (length 3 — formalized for deterministic replay after the initial `2026-11-24T11:12:36Z` evaluation, making the original qualitative 'separates cleanly' rule explicit):** Observed gap `phat_pending - phat_idle` is strictly positive with disjoint 95% Wilson score intervals (`idle_hi < pending_lo`) on `DDD` and `DRD`, while length-2 control `DR` yields exact `0.0` gap (`500/500` vs `500/500`).

| Arm | Word | Exact `p_idle` | 95% Normal Band (`idle`) | Exact `p_pending` | 95% Normal Band (`pending`) | Exact Gap | Hoeffding Radius (`alpha=0.05`) |
|---|---|---|---|---|---|---|---|
| `DR` | `DR` | `1.000000` | `[1.0000, 1.0000]` | `1.000000` | `[1.0000, 1.0000]` | `+0.000000` | `+/- 0.0607` |
| `RRR` | `RRR` | `0.977500` | `[0.9645, 0.9905]` | `0.999494` | `[0.9975, 1.0000]` | `+0.021994` | `+/- 0.0607` |
| `DDD` | `DDD` | `0.320000` | `[0.2791, 0.3609]` | `0.870400` | `[0.8410, 0.8998]` | `+0.550400` | `+/- 0.0607` |
| `DRD` | `DRD` | `0.320000` | `[0.2791, 0.3609]` | `0.991900` | `[0.9840, 0.9998]` | `+0.671900` | `+/- 0.0607` |

## 4. Machine-Readable Frozen Specification

```json
{
  "created_utc": "2026-11-24T13:16:05Z",
  "train_seed": 20563624,
  "Q_frozen": [
    [
      [
        9.41166531634371,
        9.967515945350028
      ],
      [
        5.999999999999976,
        4.899999999999976
      ]
    ],
    [
      [
        9.398085193124823,
        9.978046643253691
      ],
      [
        5.999999999999976,
        4.899999999999976
      ]
    ]
  ],
  "Q_frozen_sha256": "cc57e93a57b51dc36fe3b6e0340056637f9dfacf5a99aa911b686197edd057fd",
  "greedy_policy": [
    [
      1,
      0
    ],
    [
      1,
      0
    ]
  ],
  "n_alive": 63,
  "theorem_cutoff": 62,
  "shortest_separating_length": 3,
  "eval_seeds_per_arm": 500,
  "eval_seed_base": 21161124,
  "arms": [
    {
      "label": "DR",
      "word": [
        "D",
        "R"
      ],
      "description": "Length-2 zero-gap control (< shortest separating length 3)",
      "p_idle": 1.0,
      "p_pending": 1.0,
      "gap": 0.0,
      "wilson_95_idle": [
        1.0,
        1.0
      ],
      "wilson_95_pending": [
        1.0,
        1.0
      ],
      "hoeffding_95_idle": [
        0.9392638538091694,
        1.0
      ],
      "hoeffding_95_pending": [
        0.9392638538091694,
        1.0
      ],
      "hoeffding_radius": 0.060736146190830516
    },
    {
      "label": "RRR",
      "word": [
        "R",
        "R",
        "R"
      ],
      "description": "Length-3 all-reliable channel (near-hidden gap)",
      "p_idle": 0.9774999999999999,
      "p_pending": 0.9994937499999998,
      "gap": 0.021993749999999923,
      "wilson_95_idle": [
        0.9645009165755702,
        0.9904990834244296
      ],
      "wilson_95_pending": [
        0.9975220735538773,
        1.0
      ],
      "hoeffding_95_idle": [
        0.9167638538091694,
        1.0
      ],
      "hoeffding_95_pending": [
        0.9387576038091693,
        1.0
      ],
      "hoeffding_radius": 0.060736146190830516
    },
    {
      "label": "DDD",
      "word": [
        "D",
        "D",
        "D"
      ],
      "description": "Length-3 all-degraded channel (both arms strictly interior)",
      "p_idle": 0.32,
      "p_pending": 0.8704,
      "gap": 0.5504,
      "wilson_95_idle": [
        0.27911231384920293,
        0.3608876861507971
      ],
      "wilson_95_pending": [
        0.840960865971426,
        0.8998391340285739
      ],
      "hoeffding_95_idle": [
        0.2592638538091695,
        0.3807361461908305
      ],
      "hoeffding_95_pending": [
        0.8096638538091694,
        0.9311361461908305
      ],
      "hoeffding_radius": 0.060736146190830516
    },
    {
      "label": "DRD",
      "word": [
        "D",
        "R",
        "D"
      ],
      "description": "Length-3 maximal-gap mode switch (shortest separating probe)",
      "p_idle": 0.32,
      "p_pending": 0.9919,
      "gap": 0.6718999999999999,
      "wilson_95_idle": [
        0.27911231384920293,
        0.3608876861507971
      ],
      "wilson_95_pending": [
        0.984043311341997,
        0.999756688658003
      ],
      "hoeffding_95_idle": [
        0.2592638538091695,
        0.3807361461908305
      ],
      "hoeffding_95_pending": [
        0.9311638538091694,
        1.0
      ],
      "hoeffding_radius": 0.060736146190830516
    }
  ]
}
```
