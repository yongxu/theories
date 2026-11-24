# Track B3: Exact Dumitriu–Edelman + Haar + Tridiagonal LDL Endpoint Results

AI-written (Wave 4 Track B3, 25 November 2026). All numbers below come directly from running [`run_ldl_check.py`](run_ldl_check.py) under `PYTHONDONTWRITEBYTECODE=1 python3 -B -O run_ldl_check.py` (deterministic seed `20261125`), persisted verbatim in [`results.json`](results.json). See [`DERIVATION.md`](DERIVATION.md) for the Schur-complement / BBP endpoint derivation and scope boundaries. No human has reviewed yet.

## Summary & Verification Checks

- **Runtime:** `0.414607` CPU seconds under the sampled `<= 12.0` s cutoff (checked per endpoint, per cell, and at completion across `320` sampled endpoints + `10` dense Jacobi cross-checks).
- **Numerical reliability:** `0` numerical failures; global maximum secular residual $|\lambda_{\max}(K(z_{\mathrm{hi}})) - 1| = 2.821243 \times 10^{-11}$; global maximum final bisection bracket width $= 1.172396 \times 10^{-13}$ after `52` bisection steps.
- **Dense Jacobi cross-check (`n = 32`, 2 replicates per $\gamma$ = 10 matrices, exact dimensions `[2, 2, 8, 8, 32, 32, 72, 72, 128, 128]`):** maximum eigenvalue discrepancy $|z_{\mathrm{ldl}} - z_{\mathrm{jacobi}}| = 8.881784 \times 10^{-15}$ (`< 8.9e-15`), maximum signal-plane mass discrepancy $= 4.912737 \times 10^{-15}$, and `0` cone-angle classification mismatches.

## Regime A Finite-`n` Sweep (`b = 0`, 32 independent endpoints per cell)

| $n$ | $d$ | $\gamma$ | Regime | Theory $z_*$ | Emp. $\bar{z}_{\mathrm{top}}$ | Theory mass | Emp. mass | Cone hits / 32 | Cone rate (Wilson 95% CI) | Max residual | Max bracket | Fails |
|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 64 | 4 | `1/16` | supercritical (`p(0)=0.3787`) | `2.6042` | `3.0534` | `0.9333` | `0.9777` | `11/32` | `0.3438` [`0.2041`, `0.5169`] | `5.55e-16` | `1.78e-15` | `0` |
| 64 | 16 | `1/4` | supercritical (`p(0)=0.3750`) | `2.9167` | `3.1880` | `0.7619` | `0.8150` | `9/32` | `0.2812` [`0.1556`, `0.4537`] | `2.00e-15` | `4.44e-15` | `0` |
| 64 | 64 | `1` | supercritical (`p(0)=0.3598`) | `4.1667` | `4.4705` | `0.3333` | `0.4234` | `17/32` | `0.5312` [`0.3645`, `0.6913`] | `1.13e-14` | `1.60e-14` | `0` |
| 64 | 144 | `9/4` | critical edge (`singular`) | `6.2500` | `6.4361` | `0.0000` | `0.1904` | `15/32` | `0.4688` [`0.3087`, `0.6355`] | `1.57e-13` | `3.38e-14` | `0` |
| 64 | 256 | `4` | subcritical bulk edge | `9.0000` | `8.9955` | `0.0000` | `0.0712` | `13/32` | `0.4062` [`0.2552`, `0.5774`] | `1.61e-11` | `5.86e-14` | `0` |
| 128 | 8 | `1/16` | supercritical (`p(0)=0.3787`) | `2.6042` | `2.8753` | `0.9333` | `0.9584` | `15/32` | `0.4688` [`0.3087`, `0.6355`] | `1.11e-15` | `2.66e-15` | `0` |
| 128 | 32 | `1/4` | supercritical (`p(0)=0.3750`) | `2.9167` | `3.1267` | `0.7619` | `0.7987` | `13/32` | `0.4062` [`0.2552`, `0.5774`] | `3.44e-15` | `8.44e-15` | `0` |
| 128 | 128 | `1` | supercritical (`p(0)=0.3598`) | `4.1667` | `4.4413` | `0.3333` | `0.4419` | `14/32` | `0.4375` [`0.2817`, `0.6067`] | `2.55e-14` | `3.02e-14` | `0` |
| 128 | 288 | `9/4` | critical edge (`singular`) | `6.2500` | `6.3715` | `0.0000` | `0.1723` | `8/32` | `0.2500` [`0.1325`, `0.4211`] | `2.70e-12` | `6.57e-14` | `0` |
| 128 | 512 | `4` | subcritical bulk edge | `9.0000` | `9.0000` | `0.0000` | `0.0609` | `9/32` | `0.2812` [`0.1556`, `0.4537`] | `2.82e-11` | `1.17e-13` | `0` |

## Honest Interpretation & Limits

- **Observed mean mass decline & BBP spike tracking:** Sample mean signal-plane mass declines monotonically across $\gamma \in \{1/16, 1/4, 1, 9/4, 4\}$ at both sample sizes (`0.9777 → 0.8150 → 0.4234 → 0.1904 → 0.0712` at $n=64$, and `0.9584 → 0.7987 → 0.4419 → 0.1723 → 0.0609` at $n=128$; no confidence interval is computed for mean mass), while empirical $\bar{z}_{\mathrm{top}}$ tracks the BBP shift ($2.8753 \to 9.0000$ at $n=128$) with finite-$n$ upward level-repulsion bias shrinking from $n=64$ to $n=128$ below threshold and decaying toward $0$ near $\gamma = 9/4, 4$.
- **Cone-rate statistical power:** With only `32` trials per cell, binomial Wilson 95% intervals apply to **cone-hit probability** only (`0.2500–0.5312`, interval widths `0.2885–0.3268`); under small-$n$ finite-sample fluctuation and unadjusted multiple-cell sampling, the nominal $n=64,\gamma=1$ interval `[0.3645, 0.6913]` excludes the $n\to\infty$ limiting prediction `0.3598`. Consequently this coarse sweep has no statistical power to resolve the `0.0038` (`0.003759`) asymptotic cone-rate gap between $\gamma = 1/16$ (`0.3787`) and $\gamma = 1/4$ (`0.3750`).
- **Endpoint vs. rolling scope:** These runs test single-endpoint draws at $b = 0$ only; high-dimensional rolling first-passage asymptotics are not inferred from fixed-$d$ deterministic inclusions.
