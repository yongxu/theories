# Track B3: Schur-Complement / BBP Endpoint Angle Derivation and Finite-`n` LDL Reduction

AI-written (Wave 4 Track B3, 25 November 2026). Formal mathematical companion to `run_ldl_check.py` and `MovingFeatureCone.lean` in `Wave 4`; checked numerically at `n ∈ {64, 128}` (`32` independent endpoints per `(n, γ)` cell) and cross-checked against dense symmetric Jacobi (`n = 32`). No human has reviewed yet.

---

## 1. Setup and Regime A Model

Consider the moving-feature spiked Wishart window at endpoint $t = B_n(b) = \lfloor n/2 + b\sqrt{n}\rfloor$ ($b = 0$ centered split) with signal spike $\lambda = 3$, isotropic noise variance $s = \kappa = 1$, dimension-to-sample ratio $\gamma = d/n$, and $n = n_{\mathrm{pre}} + n_{\mathrm{pos}}$ independent observations with diagonal population covariance:
- $m_{\mathrm{pre}} = \lfloor n/2\rfloor$ pre-change rows $X_t \sim \mathcal{N}(0, \operatorname{diag}(\lambda+s, s, \dots, s))$,
- $m_{\mathrm{pos}} = n - \lfloor n/2\rfloor$ post-change rows $X_t \sim \mathcal{N}(0, \operatorname{diag}(s, \lambda+s, s, \dots, s))$.

Partition the scaled observation matrix $\frac{1}{\sqrt{n}}X = [\,Y^\top,\; Z^\top\,]$ ($n \times d$), where $Y$ ($2 \times n$) spans the moving signal plane $\operatorname{span}(e_0, e_1)$ and $Z$ ($(d-2) \times n$) holds the orthogonal isotropic noise rows ($Z_{j,t} \stackrel{\text{i.i.d.}}{\sim} \mathcal{N}(0, s/n)$). At $b = 0$, the two-row signal Gram $G = Y Y^\top$ satisfies $\mathbb{E}[G] = \tau I_2$ **exactly for even $n$** ($m_{\mathrm{pre}} = m_{\mathrm{pos}} = n/2$; for odd $n$, $\lfloor n/2\rfloor \ne \lceil n/2\rceil$ shifts the two diagonal entries by $\pm \lambda/(2n)$ of difference $\lambda/n$), where
$$
\tau = s + \frac{\lambda}{2} = \frac{5}{2} = 2.5,
$$
and effective signal-to-noise ratio $\beta = \lambda/(2s) = \frac{3}{2}$, so the supercritical BBP threshold in aspect ratio is $\beta^2 = \frac{9}{4} = 2.25$.

The sample covariance $S = \frac{1}{n} X^\top X = \begin{pmatrix} G & Y Z^\top \\ Z Y^\top & Z Z^\top \end{pmatrix}$ ($d \times d$) shares its positive eigenvalues $z > 0$ with the dual Gram matrix $M = Y^\top Y + Z^\top Z$ ($n \times n$). For positive eigenvalues $z > 0$ ($M v = z v$, $\|v\| = 1$), exact primal–dual eigenvector bijection is $u = z^{-1/2} \begin{pmatrix} Y v \\ Z v \end{pmatrix}$ ($\|u\| = 1$). Writing $\tilde{y} = Y v \in \mathbb{R}^2$, the signal-plane projection of the unit top eigenvector $u$ satisfies:
1. **Top signal angle:** $w = \tilde{y}/\|\tilde{y}\|$ triggers the latch $u_1^2 \ge 3 u_0^2 \iff 3 w_0^2 \le w_1^2$.
2. **Signal-plane mass:** $\|u_{\mathrm{sig}}\|^2 = \|\tilde{y}\|^2 / z$.

---

## 2. Schur-Complement Reduction and Supercritical Angle Law

For $d \ge 3$, let $T' = Z^\top Z = Q D Q^\top$ ($n \times n$) be an eigendecomposition of the dual noise Gram matrix, with diagonal eigenvalues $D = \operatorname{diag}(d_1,\dots,d_n)$ and orthogonally invariant (Haar) eigenbasis $Q \in O(n)$ independent of $(Y, D)$ conditional on $D$ and the rank of $Z$ (choosing $Q$ Haar-uniform within any degenerate eigenspace, in particular within $\ker T'$ when $d - 2 < n$). At the degenerate boundary $d = 2$ ($T' = 0$), either draw an independent Haar $Q \in O(n)$ in the $0$-eigenspace—giving $K(z) = L U (z I_n)^{-1} U^\top L^\top = G/z$ directly since $U U^\top = I_2$—or evaluate $K(z) = G/z$ directly without needing a frame. Let $G = L L^\top$ be the lower Cholesky factorization of $G$ (in general $L \ne G^{1/2}$). Define the rotated orthonormal two-frame $U = L^{-1} Y Q \in \mathbb{R}^{2 \times n}$ ($U U^\top = I_2$), which conditional on $(G, D)$ is Haar-uniform on $V_2(\mathbb{R}^n)$ for all $d \ge 2$. For any trial value $z > 0$ outside $\operatorname{spec}(T')$, eliminating the $(d-2)$ noise coordinates reduces $S u = z u$ ($u_{\mathrm{sig}} = z^{-1/2}\tilde{y}$) to the $2 \times 2$ Schur-complement system
$$
\bigl(I_2 - K(z)\bigr)\tilde{y} = 0, \qquad K(z) = Y (z I_n - T')^{-1} Y^\top = L U R(z) U^\top L^\top, \qquad R(z) = (z I_n - D)^{-1}.
$$
For the **largest** eigenvalue $\lambda_{\max}(S)$, variational monotonicity gives the exact bracket test at any positive trial value $z > 0$:
$$
z > \lambda_{\max}(S) \iff z I_n - T' \succ 0 \quad\text{and}\quad I_2 - K(z) \succ 0.
$$
Moreover, from $M v = (Y^\top Y + T') v = z v$, we have $v = (z I_n - T')^{-1} Y^\top \tilde{y}$, so $\|v\|^2 = 1 = \tilde{y}^\top (-K'(z)) \tilde{y}$, yielding the exact normalization identity $\|u_{\mathrm{sig}}\|^2 = \|\tilde{y}\|^2 / \bigl[z\,\tilde{y}^\top (-K'(z)) \tilde{y}\bigr]$.

For fixed $0 < \gamma < \beta^2 = 9/4$ as $n \to \infty$, distinguish the finite-$n$ empirical resolvent trace $r_n(z) = \frac{1}{n}\operatorname{tr} R(z)$ from its deterministic Marchenko–Pastur companion Stieltjes limit $r(z) = (1-\gamma)/z + \gamma\,m(z)$, which solves $z = \frac{1}{r(z)} + \frac{s \gamma}{1 - s r(z)}$ ($s = 1$):
- At the limiting outlier $z_*$: $\tau\,r(z_*) = 1$, i.e., $r_* := r(z_*) = \frac{1}{\tau} = \frac{1}{s(1+\beta)}$ (for $s = 1, \beta = 3/2$, $r_* = 2/5$), giving
  $$
  z_*(\gamma) = s(1+\beta)\Bigl(1 + \frac{\gamma}{\beta}\Bigr) = \frac{5}{2} + \frac{5}{3}\gamma \qquad (\gamma < 9/4),
  $$
  and $z_*(\gamma) = s(1 + \sqrt{\gamma})^2 = (1 + \sqrt{\gamma})^2$ at and above the BBP threshold $\gamma \ge 9/4$.
- Implicit differentiation of the companion equation at $r_* = 1/[s(1+\beta)]$ gives $-r'(z_*) = r_*^2 / (1 - \gamma/\beta^2)$ and resolvent variance weight $v_R = -r'(z_*) - r_*^2 = r_*^2\,\frac{\gamma/\beta^2}{1 - \gamma/\beta^2}$. Substituting $-K'(z_*) \xrightarrow{\mathbb{P}} -r'(z_*) G \approx -r'(z_*)\tau I_2$ alongside $\tau r_* = 1$ and $z_* r_* = 1 + \gamma/\beta$ yields the limiting supercritical signal-plane mass:
  $$
  c_*^2 := \lim \|u_{\mathrm{sig}}\|^2 = \frac{1}{z_*\,\tau\,\bigl(-r'(z_*)\bigr)} = \frac{1 - \gamma/\beta^2}{1 + \gamma/\beta} \qquad (\gamma < 9/4).
  $$

Conditional on $(G, D)$ at scale $\sqrt{n}$, the centered fluctuation $W_{\mathrm{full}, n} := \sqrt{n}\bigl(U R(z_*) U^\top - r_n(z_*) I_2\bigr)$ converges in law (by CLT against a bounded resolvent off the bulk edge) to a $2 \times 2$ symmetric Gaussian matrix $W_{\mathrm{full}}$ with off-diagonal variance $v_R$ and diagonal variance $2 v_R$. Applying the traceless projection $P(A) := A - \frac{1}{2}\operatorname{tr}(A) I_2$ yields $W_R := P(W_{\mathrm{full}})$, a *traceless* GOE limit whose two diagonal entries are exact negatives with variance $v_R$ each, so their diagonal **difference** $(W_R)_{11} - (W_R)_{00}$ has variance $4 v_R$. Applying $P$ to the finite-$n$ fluctuation $S_{\mathrm{eff}} := r_*^{-1} K(z_*)$ annihilates any scalar trace term and gives weak convergence via Slutsky (using $L \xrightarrow{\mathbb{P}} \sqrt{\tau} I_2$ and $r_n(z_*) \xrightarrow{\mathbb{P}} r_*$, with no coupling claim):
$$
\sqrt{n}\,P(S_{\mathrm{eff}} - G) = \sqrt{n}\,P\bigl(r_*^{-1} L U R(z_*) U^\top L^\top - G\bigr) \xrightarrow{d} \frac{\tau}{r_*}\,W_R.
$$
Because $P$ preserves $((S_{\mathrm{eff}})_{11} - (S_{\mathrm{eff}})_{00}, (S_{\mathrm{eff}})_{01})$ that drive `top_cone_iff` in `MovingFeatureCone.lean`, adding the independent signal-Gram fluctuation ($V_\Delta = 2(\lambda+s)^2 + 2s^2 = 34$, $V_c = s(\lambda+s) = 4$) gives the supercritical replacement
$$
V_\Delta \mapsto V_\Delta + 4 H, \qquad V_c \mapsto V_c + H, \qquad
H = \frac{\tau^2 v_R}{r_*^2} = \tau^2\,\frac{\gamma/\beta^2}{1 - \gamma/\beta^2},
$$
and centered ($b = 0$) supercritical endpoint cone probability $p(0) = \frac{1}{\pi}\arctan\!\sqrt{\frac{3(V_\Delta + 4H)}{4(V_c + H)}}$.

---

## 3. Regime A Reference Table ($\lambda = 3, s = 1, b = 0, \tau = 2.5, \beta = 1.5$)

| $\gamma = d/n$ | $\gamma/\beta^2$ | Limiting $z_*$ | Signal-plane mass | Extra noise $H$ | Supercritical $p(0)$ |
|---:|---:|---:|---:|---:|---:|
| $1/16$ (`0.0625`) | `1/36` | `2.6042` | `0.9333` | `0.1786` | `0.3787` |
| $1/4$ (`0.2500`) | `1/9` | `2.9167` | `0.7619` | `0.7812` | `0.3750` |
| $1$ (`1.0000`) | `4/9` | `4.1667` | `0.3333` | `5.0000` | `0.3598` |
| $9/4$ (`2.2500`) | `1` (critical edge) | `6.2500` | `0` | singular | supercritical expansion singular |
| $4$ (`4.0000`) | `16/9` (subcritical) | `9.0000` (bulk edge) | `0` | — | bulk edge regime (Tracy–Widom scale) |

---

## 4. Dumitriu–Edelman + Haar Exact Endpoint Sampler (`run_ldl_check.py`)

For each endpoint draw without forming an $n \times n$ matrix:
1. Sample exact $2 \times 2$ signal Gram $G = W_1 + W_2$ via Bartlett decomposition (`n//2` pre-change and `n - n//2` post-change samples scaled by $1/n$), and take its lower Cholesky factor $L$.
2. Set $k_0 = \min(d - 2, n)$, $l = \max(d - 2, n)$. By Dumitriu and Edelman (*Matrix Models for Beta Ensembles*, *J. Math. Phys.* 43 (2002), arXiv:math-ph/0206043), draw a $k_0 \times k_0$ lower bidiagonal matrix $B$ with independent $B_{i,i} \sim \chi_{l - i}$ and $B_{i+1,i} \sim \chi_{k_0 - 1 - i}$ ($0$-based indices). Then $T'_{\mathrm{top}} = (s/n) B B^\top$ (symmetric tridiagonal) padded with $n - k_0$ zeros has the exact eigenvalue law of $Z^\top Z$.
3. Draw an independent Haar two-frame $U \in \mathbb{R}^{2 \times n}$ by Gaussian Gram–Schmidt and set $Y' = L U$, splitting $Y' = [\,Y'_{\mathrm{top}} \in \mathbb{R}^{2 \times k_0},\; Y'_{\mathrm{null}} \in \mathbb{R}^{2 \times (n - k_0)}\,]$ with precomputed $G_{\mathrm{null}} = Y'_{\mathrm{null}} Y'^\top_{\mathrm{null}}$.
4. Bisect the top eigenvalue over $[0,\, \operatorname{tr} T'_{\mathrm{top}} + \operatorname{tr} G]$ for $52$ steps using one $\mathcal{O}(k_0)$ tridiagonal $\mathrm{LDL}^\top$ pass on $z I_{k_0} - T'_{\mathrm{top}}$ that accumulates $Y'_{\mathrm{top}}(z I_{k_0} - T'_{\mathrm{top}})^{-1} Y'^\top_{\mathrm{top}} = F^\top D^{-1} F$ alongside $G_{\mathrm{null}}/z$. Total cost is $\mathcal{O}(n + 52 k_0)$ time and $\mathcal{O}(n)$ storage per endpoint.

---

## 5. Scope Boundary

This derivation characterizes **single-endpoint supercritical fluctuations** at fixed aspect ratio $\gamma < \beta^2$ as $n \to \infty$. By contrast, `MovingFeatureCone.lean` (`top_cone_iff`, `fp_sandwich`, `intra_boundary_or_osc`, `feature_delay_headroom`, `feature_delay_linear_fa_collapse`) establishes fixed-$d$ deterministic event inclusions (not a probabilistic rolling maximal inequality or high-dimensional rolling first-passage limit) and delay bridges that retain all fixed-feature `AlignmentReals` margin premises (`linear_fa_leakage_hysteresis`).
