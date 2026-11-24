# Observed Results: Frozen-Policy Q-Learning Survival Distinguishability

*AI-written empirical record (2026-11-24T13:16:05Z; local CPU stdlib only, Rule 7 compliant).*

## 1. Specification & Replay Integrity

- **Analytical predictions:** [PREDICTIONS.md](PREDICTIONS.md) (`sha256`: `89f8f65b7d78046f26e5b220e413c4b81993369f8048dcbcc4926fb7d070090b` — matched supplied `--pred-sha`, enforced without `assert` so `python3 -O` cannot bypass it)
- **Replay & commit provenance note:** deterministic replay on `seed_base = 21161124` matching the initial `2026-11-24T11:12:36Z` held-out evaluation after correcting operator cutoff `62`, formalizing disjoint 95% Wilson separation, and adding `-O`-safe digest checks; [PREDICTIONS.md](PREDICTIONS.md) and this file land together in Commit B.
- **Frozen Q-tables (`Q_frozen`):** `sha256`: `cc57e93a57b51dc36fe3b6e0340056637f9dfacf5a99aa911b686197edd057fd` (verified immutable throughout evaluation; zero online updates)
- **Held-out seeds:** `500` independent seeds per initial state per arm (`seed_base = 21161124`, disjoint from training seed `20563624`)
- **Overall verification outcome:** **`PASS`** (`all_wilson_covers_exact=True`, `all_within_normal_95=True`, `all_within_hoeffding_95=True`, `all_separation_criteria=True`)

## 2. Observed Survival Counts vs. Analytical Matrix Predictions

| Arm | State | Survived / `N` | Observed `phat` | Predicted `p` | 95% Wilson CI | Covers `p`? | 95% Normal Band? | 95% Hoeffding Check |
|---|---|---|---|---|---|---|---|---|
| `DR` | `idle` | `500/500` | `1.0000` | `1.000000` | `[0.9924, 1.0000]` | `True` | `True` | `True` |
| `DR` | `pending` | `500/500` | `1.0000` | `1.000000` | `[0.9924, 1.0000]` | `True` | `True` | `True` |
| `RRR` | `idle` | `492/500` | `0.9840` | `0.977500` | `[0.9687, 0.9919]` | `True` | `True` | `True` |
| `RRR` | `pending` | `500/500` | `1.0000` | `0.999494` | `[0.9924, 1.0000]` | `True` | `True` | `True` |
| `DDD` | `idle` | `178/500` | `0.3560` | `0.320000` | `[0.3153, 0.3989]` | `True` | `True` | `True` |
| `DDD` | `pending` | `429/500` | `0.8580` | `0.870400` | `[0.8247, 0.8859]` | `True` | `True` | `True` |
| `DRD` | `idle` | `157/500` | `0.3140` | `0.320000` | `[0.2749, 0.3560]` | `True` | `True` | `True` |
| `DRD` | `pending` | `495/500` | `0.9900` | `0.991900` | `[0.9768, 0.9957]` | `True` | `True` | `True` |

## 3. Separation Gap Comparison (`pending - idle` at equal observed stock `x = 10`)

| Arm | Word | Length | Predicted Gap | Observed Gap | Error (`obs - pred`) |
|---|---|---|---|---|---|
| `DR` | `DR` | 2 | `+0.000000` | `+0.0000` | `+0.0000` |
| `RRR` | `RRR` | 3 | `+0.021994` | `+0.0160` | `-0.0060` |
| `DDD` | `DDD` | 3 | `+0.550400` | `+0.5020` | `-0.0484` |
| `DRD` | `DRD` | 3 | `+0.671900` | `+0.6760` | `+0.0041` |

## 4. Honest Summary

- Length-2 probe `DR` (`len=2 < 3`) showed `500/500` vs `500/500` (observed gap `+0.0000`), matching the exact `0.0000` blindness prediction.
- Shortest separating probes (`len=3 <= |S_alive|-1=62`) cleanly separated the equal-stock states:
  - `RRR` kept the gap compressed (`+0.0160` observed vs `+0.021994` predicted).
  - `DDD` yielded both arms strictly interior (`0.3560` vs `0.8580`, observed gap `+0.5020` vs `+0.550400` predicted).
  - `DRD` amplified separation to `+0.6760` observed (`0.3140` vs `0.9900`, predicted `+0.671900`).
