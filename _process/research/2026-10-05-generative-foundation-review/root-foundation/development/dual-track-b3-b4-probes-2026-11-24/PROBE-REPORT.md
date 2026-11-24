# Dual-Track B3 & B4 First-Strike Local CPU Probe Report

*AI-written empirical & combinatorial probe report (24 November 2026); deterministic fixed-seed local CPU runs only (`seed = 20261124`), zero external/network calls. Not yet reviewed by Ren.*

---

## Track B3 — Moving Rank-1 Covariance Eigenspace Conjecture (`probe_b3_moving_feature.py`)

### Exact Command & Setup
```bash
PYTHONDONTWRITEBYTECODE=1 python3 \
  _process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-b3-b4-probes-2026-11-24/probe_b3_moving_feature.py \
  --json-out /tmp/b3_results.json
```
- **Model:** Pre-change samples ($s < n$) drawn from $\mathcal{N}(0, \lambda u u^\top + \sigma^2 I_d)$; post-change samples ($s \ge n$) drawn from $\mathcal{N}(0, \lambda v v^\top + \sigma^2 I_d)$ with $u \perp v$, $\lambda = 3$, $\kappa = 1$, latch condition $v^\top P_t v \ge 3 u^\top P_t u$, and horizon $B_n = \lfloor n/2 + b\sqrt{n} \rfloor$ over $b \in \{-1.0, -0.5, 0.0, 0.5, 1.0\}$ across the finite grid $n \in \{128, 256, 512\}$.
- **Two parameterizations evaluated** (`seed = 20261124`, `elapsed_sec = 102.06`):
  - **Regime A** (`d/n = \gamma = 1/16`, $\sigma^2 = \kappa = 1$, so $d \in \{8, 16, 32\}$; 300 rolling trials, 150 independent-window Wishart trials; spike-aligned local 2D Rayleigh-Ritz solver seeded on $\operatorname{span}(e_0, e_1)$ with $O(d)$ $\lambda_1 \ge \max_i S_{ii}$ lower-bound guard and residual fallback to full symmetric Jacobi `jacobi_top_eigvec` — not a universal global guarantee on arbitrary non-spiked symmetric matrices — cross-verified by `1,350` full Jacobi checks (`450` per $n$): **`0` mismatches**, `1` fallback at $n=128$, `0` fallbacks at $n=256, 512$).
  - **Regime B** (`\sigma^2 = \gamma = 1/16`, $d = 2$ exact $2 \times 2$ eigenspace; 2000 rolling trials, 500 independent-window Wishart trials).

### Observed Results

| Regime | $n$ | $d$ | $b$ | $B_n$ | Rolling `FP` | Rolling `EP` | `IndFP` | `IndEP` | `G1D` (exact $B_n$) | `G2D` cone (exact $B_n$) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| A | 128 | 8 | -1.0 | 52 | 0.080 | 0.077 | 0.327 | 0.080 | 0.138 | 0.085 |
| A | 128 | 8 | -0.5 | 58 | 0.197 | 0.197 | 0.767 | 0.180 | 0.293 | 0.201 |
| A | 128 | 8 | +0.0 | 64 | 0.377 | 0.377 | 0.960 | 0.367 | 0.500 | 0.380 |
| A | 128 | 8 | +0.5 | 69 | 0.570 | 0.563 | 1.000 | 0.600 | 0.675 | 0.554 |
| A | 128 | 8 | +1.0 | 75 | 0.737 | 0.730 | 1.000 | 0.720 | 0.841 | 0.748 |
| A | 256 | 16 | -1.0 | 112 | 0.103 | 0.100 | 0.487 | 0.093 | 0.152 | 0.095 |
| A | 256 | 16 | -0.5 | 120 | 0.207 | 0.203 | 0.867 | 0.267 | 0.303 | 0.210 |
| A | 256 | 16 | +0.0 | 128 | 0.390 | 0.387 | 1.000 | 0.413 | 0.500 | 0.380 |
| A | 256 | 16 | +0.5 | 136 | 0.580 | 0.580 | 1.000 | 0.600 | 0.697 | 0.577 |
| A | 256 | 16 | +1.0 | 144 | 0.763 | 0.760 | 1.000 | 0.780 | 0.848 | 0.756 |
| A | 512 | 32 | -1.0 | 233 | 0.103 | 0.100 | 0.673 | 0.107 | 0.148 | 0.092 |
| A | 512 | 32 | -0.5 | 244 | 0.207 | 0.207 | 0.933 | 0.207 | 0.293 | 0.201 |
| A | 512 | 32 | +0.0 | 256 | 0.373 | 0.373 | 1.000 | 0.360 | 0.500 | 0.380 |
| A | 512 | 32 | +0.5 | 267 | 0.560 | 0.560 | 1.000 | 0.587 | 0.692 | 0.572 |
| A | 512 | 32 | +1.0 | 278 | 0.740 | 0.733 | 1.000 | 0.687 | 0.841 | 0.748 |
| B | 128 | 2 | -1.0 | 52 | 0.061 | 0.061 | 0.206 | 0.070 | 0.071 | 0.060 |
| B | 128 | 2 | -0.5 | 58 | 0.201 | 0.201 | 0.636 | 0.200 | 0.231 | 0.205 |
| B | 128 | 2 | +0.0 | 64 | 0.473 | 0.473 | 0.978 | 0.494 | 0.500 | 0.463 |
| B | 128 | 2 | +0.5 | 69 | 0.716 | 0.716 | 1.000 | 0.712 | 0.730 | 0.698 |
| B | 128 | 2 | +1.0 | 75 | 0.905 | 0.905 | 1.000 | 0.920 | 0.911 | 0.894 |
| B | 256 | 2 | -1.0 | 112 | 0.060 | 0.060 | 0.338 | 0.076 | 0.083 | 0.070 |
| B | 256 | 2 | -0.5 | 120 | 0.204 | 0.204 | 0.820 | 0.246 | 0.244 | 0.217 |
| B | 256 | 2 | +0.0 | 128 | 0.441 | 0.441 | 0.994 | 0.436 | 0.500 | 0.463 |
| B | 256 | 2 | +0.5 | 136 | 0.720 | 0.720 | 1.000 | 0.702 | 0.756 | 0.725 |
| B | 256 | 2 | +1.0 | 144 | 0.901 | 0.901 | 1.000 | 0.898 | 0.917 | 0.901 |
| B | 512 | 2 | -1.0 | 233 | 0.072 | 0.072 | 0.402 | 0.062 | 0.080 | 0.067 |
| B | 512 | 2 | -0.5 | 244 | 0.208 | 0.208 | 0.912 | 0.228 | 0.231 | 0.205 |
| B | 512 | 2 | +0.0 | 256 | 0.481 | 0.481 | 0.998 | 0.448 | 0.500 | 0.463 |
| B | 512 | 2 | +0.5 | 267 | 0.725 | 0.725 | 1.000 | 0.724 | 0.750 | 0.719 |
| B | 512 | 2 | +1.0 | 278 | 0.897 | 0.897 | 1.000 | 0.902 | 0.911 | 0.894 |

*(Regime A raw `FP`/`EP` at `n=512, b=0.0` are `112/300 = 0.3733`; Regime B raw `FP`/`EP` at `n=512, b=0.0` are `0.4815` and `0.4810`; at `n=128, b=-0.5`: `0.2005`, `b=0.5`: `0.7155`, `b=1.0`: `0.9055`; at `n=256, b=-1.0`: `0.0605`; at `n=512, b=-1.0`: `0.0725`, `b=-0.5`: `0.2085`, `b=1.0`: `0.8975`.)*

### Rule 2 Verdict on Track B3
1. **Finite-grid separation from independent windows:** Across the 30 tested finite-grid points (`n ∈ {128, 256, 512}`, `b ∈ {-1..1}`), rolling-window first-passage `FP` remains within `<= 0.007` of rolling-window endpoint `EP` (e.g., `0.4815` vs `0.4810` in exact-2D Regime B at `n=512, b=0`, and `0.3733` vs `0.3733` in full `32 × 32` Regime A at `n=512, b=0`), whereas independent-window `IndFP` rises sharply toward `1.000` (`0.960 -> 1.000 -> 1.000` in Regime A and `0.978 -> 0.994 -> 0.998` in Regime B at `b = 0.0`).
2. **Naive 1D formula rejected on finite grid; 2D cone algebra vs open asymptotic limit:** The 1D diagonal Gaussian prediction `G1D` systematically overpredicts Regime A across all tested `(n, b)` (at `b = 0.0`: `0.500` vs `0.373–0.390`) and slightly overpredicts Regime B (`0.500` vs `0.441–0.481`). In **Regime B (`d = 2`)**, $w_v^2 \ge 3 w_u^2$ on the $2 \times 2$ eigensystem is algebraically equivalent to the exact cone inequality $S_{vv} - S_{uu} \ge \frac{2}{\sqrt{3}}|S_{uv}|$, giving the 2D Gaussian approximation `G2D`. In **Regime A (`d = n/16 ∈ {8, 16, 32}`)**, `G2D` (`0.380` at `b = 0.0`) is a low-dimensional heuristic evaluated against the full `d × d` eigenvector; this finite-grid numerical comparison supports `G2D` over `G1D` on $n \in \{128, 256, 512\}$ and **does not prove** an asymptotic high-dimensional ($d/n \to \gamma$) cone limit or frozen-fluctuation theorem, which remains open.

---

## Track B4 — Exact Combinatorial Interface Bits on $C_7^{\boxtimes n}$ (`probe_b4_c7_interface_bits.py`)

### Exact Command & Setup
```bash
PYTHONDONTWRITEBYTECODE=1 python3 \
  _process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-b3-b4-probes-2026-11-24/probe_b4_c7_interface_bits.py \
  --json-out /tmp/b4_results.json
```
- **Exact solver (`seed = 20261124`, `elapsed_sec = 49.35`):** Computes exact independence number `alpha(C_7^{\boxtimes n})` via clique-cover branch-and-bound (`n = 1, 2`), exact `M_n(1) = chi(C_7^{\boxtimes n})` (`n = 1, 2`), exact `M_n(2)` (`n = 1, 2`), and certified upper/lower bounds for `n = 3`. Every partition is checked by an independent verifier (`verify_partition`).
- Evaluates **both** survival $\ge 1/2$ graph invariants:
  - **`cc<=2` (component-size $\le 2$, induced $\max \deg \le 1$):** every connected cluster in a symbol class has size $\le 2$.
  - **`K_3`-free (confusion-clique size $\omega \le 2$):** every mutually confusable clique in a symbol class has size $\le 2$ (zero-error $L=2$ list decoding).

### Observed Results & Verified Certificates

| $n$ | $|V|$ | $\alpha(C_7^{\boxtimes n})$ | $M_n(1)$ (`indep`) | $\frac{1}{n}\log_2 M_n(1)$ | $M_n^{cc\le 2}(2)$ | $\frac{1}{n}\log_2 M_n^{cc\le 2}(2)$ | $M_n^{K_3\text{-free}}(2)$ | $\frac{1}{n}\log_2 M_n^{K_3\text{-free}}(2)$ |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 7 | **3** (exact) | **3** (exact; `[3, 3, 1]`) | `1.5850` | **2** (exact; `[4, 3]`) | `1.0000` | **1** (exact; `[7]`) | `0.0000` |
| 2 | 49 | **10** (exact) | **5** (exact; `[10, 10, 10, 10, 9]`) | `1.1610` | **4** (exact; `[16, 14, 15, 4]`, $k=3$ UNSAT in 1125 nodes) | `1.0000` | **3** (exact; `[21, 21, 7]`) | `0.7925` |
| 3 | 343 | $[29, 35]$ | $[10, 12]$ (12-col verified) | `[1.1073, 1.1950]` | $[5, 8]$ (8-part verified) | $\le 1.0000$ | **5** (exact; `[70, 70, 70, 70, 63]`) | `0.7740` |

### Proof Sketches & Certificates
1. **$n = 2$ exactness:** `exact_alpha` certifies $\alpha(C_7^{\boxtimes 2}) = 10$ (witness `[(0,0), (0,2), (1,4), (2,0), (2,2), (3,4), (4,1), (4,6), (5,3), (6,5)]`), forcing $M_2(1) \ge \lceil 49/10 \rceil = 5$, and `exact_k_coloring` finds a 5-coloring (`899,651` nodes). Under `cc <= 2`, `exact_cc2_partition` proves $k = 3$ impossible in `1,125` nodes and certifies $k = 4$ (`[16, 14, 15, 4]`). Under `K_3`-free, every $2 \times 2$ torus $K_4$ holds $\le 2$ vertices, forcing $|S_i| \le \lfloor 49 \cdot 2 / 4 \rfloor = 24$ and $M_2^{K_3\text{-free}}(2) \ge 3$, achieved by $\{0,2,4\} \times C_7$, $\{1,3,5\} \times C_7$, $\{6\} \times C_7$.
2. **$n = 3$ rigorous bounds:** Every consecutive pair of $C_7^{\boxtimes 2}$ layers induces $C_7^{\boxtimes 2} \boxtimes K_2$, which has exact independence number $\alpha(C_7^{\boxtimes 2}) = 10$ and maximum `deg <= 1` induced set size $2 \cdot \alpha(C_7^{\boxtimes 2}) = 20$. Cyclic summing over 7 layer pairs yields $\alpha(C_7^{\boxtimes 3}) \le 35 \implies M_3(1) \ge \lceil 343/35 \rceil = 10$ (`>= 1.1073` bits/dim), and $M_3^{cc\le 2}(2) \ge \lceil 343/70 \rceil = 5$. Every $2 \times 2 \times 2$ $K_8$ forces $|S_i| \le \lfloor 343 \cdot 2 / 8 \rfloor = 85 \implies M_3^{K_3\text{-free}}(2) \ge 5$, achieved exactly by lifting the 5-coloring of $C_7^{\boxtimes 2}$ across $\times C_7$. Verified certificates give $M_3(1) \le 12$ and $M_3^{cc\le 2}(2) \le 8$.

### Rule 2 Verdict on Track B4
1. **Verified finite-dimensional bit reductions across $n \in \{1, 2, 3\}$ under both definitions:** Allowing survival probability $\ge 1/2$ strictly lowers per-dimension interface bits on every verified finite product:
   - Under `cc <= 2`: `1.0000 < 1.5850` ($n=1$), `1.0000 < 1.1610` ($n=2$), and `<= 1.0000 < 1.1073` ($n=3$), with $(1/n)\log_2 M_n^{cc\le 2}(2) = 1.0000$ bit/dim at $n = 1, 2$.
   - Under `K_3`-free ($\omega \le 2$): `0.0000 < 1.5850` ($n=1$), `0.7925 < 1.1610` ($n=2$), and `0.7740 < 1.1073` ($n=3$).
2. **Certified asymptotic bounds & genuine open questions:** Repeating the verified 5-coloring of $C_7^{\boxtimes 2}$ on coordinate pairs (using the 3-coloring on a leftover odd coordinate) yields independent color classes (trivially satisfying `cc <= 2` and `K_3`-free), directly certifying $\limsup_{n\to\infty} \frac{1}{n}\log_2 M_n^{cc\le 2}(2) \le \limsup_{n\to\infty} \frac{1}{n}\log_2 M_n(1) \le \frac{1}{2}\log_2 5 \approx 1.1610$ bits/dim (whereas $\alpha(C_7) = 3$ and $\alpha(C_7^{\boxtimes 2}) = 10$ already imply $\log_2 \Theta(C_7) \ge \frac{1}{2}\log_2 10 \approx 1.6610 > \log_2 3 \approx 1.5850$). Moreover, every `cc <= 2` class is a disjoint union of isolated vertices and edges (hence 2-colorable into two independent sets), forcing $M_n^{cc\le 2}(2) \le M_n(1) \le 2 M_n^{cc\le 2}(2)$ for every $n \ge 1$; the per-dimension log-rate gap for `cc <= 2` therefore lies in $[0, 1/n] \to 0$, ruling out any strict limiting log-rate separation under `cc <= 2` (savings are finite-dimensional / at most factor `2`). What remains genuinely open is: (i) under `K_3`-free ($\omega \le 2$), whether $\limsup_{n\to\infty} \frac{1}{n}\log_2 M_n^{K_3\text{-free}}(2)$ separates strictly below $\lim_{n\to\infty} \frac{1}{n}\log_2 M_n(1)$; and (ii) exact finite-$n$ values at $n = 3$ for $\alpha(C_7^{\boxtimes 3}) \in [29, 35]$, $M_3(1) \in [10, 12]$, and $M_3^{cc\le 2}(2) \in [5, 8]$ (plus finite-$n$ factor-$\le 2$ savings at $n \ge 4$).
