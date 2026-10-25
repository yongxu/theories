**I found no candidate that presently establishes reach beyond the sciences together.** Candidate 4 remains the strongest unresolved possibility; several others have closer predecessors than the audit identifies. “Not found” below means a bounded literature search, not established novelty. I read the requested sections and inspected the supporting Lean statements. No files were changed or proofs run.

The eight verdicts, retaining the audit’s numbering:

1. **Adaptation paid for by flow — exact combined bound not found; novelty doubtful.** I searched selection-response bounds, reproductive excess, resource constraints and Cauchy–Schwarz. The closest mathematical statement is Arnold and Wade (1984), *Evolution* 38:709–719, “On the Measurement of Natural and Sexual Selection: Theory”: the standardized selection differential cannot exceed the standard deviation of relative fitness. This is closer than Haldane’s substitution cost to `Reproduction.covariance_sq_le`. Connecting it to an offspring budget appears straightforward. Moreover, an **inflow-only** ceiling needs an assumption excluding expenditure of initial stock; `Flow.born_within_stock` explicitly counts that stock. Selection response also needs its inheritance assumptions distinguished from the selection differential. [Paper](https://stevanjarnold.com/wp-content/uploads/2021/05/Arnold-Wade-1984a.pdf).

2. **Survival under expected joint excess — already covered by a stronger general statement.** Bertsimas and Popescu (2005), *SIAM Journal on Optimization* 15:780–804, Proposition 6.3, give sharp one-sided moment bounds. If cumulative net draw \(D\) has mean exceeding available margin \(b\), survival implies \(D\le b\), hence
   \(P(\mathrm{survival})\le \sigma^2/[\sigma^2+(\mathbb ED-b)^2]\).
   This improves the proposed two-sided Chebyshev bound. Dependence between steps is allowed when the variance is that of the **whole cumulative draw**. The gate supplies the event inclusion, not new probability mathematics. [Proposition 6.3](https://www.mit.edu/~dbertsim/papers/MomentProblems/Optimal-inequalities-in-probability-theory-A-convex-optimization-approach-SIAM15.pdf).

3. **Drain along improvement — exact formulation not found; elementary identity.** I searched proxy optimization, resource-constrained misalignment and monotonic overoptimization. Zhuang and Hadfield-Menell (2020), *NeurIPS 33*, Theorem 1, concerns convergent optimization driving omitted attributes to their lower bounds; it does **not** assert monotone damage during training. Your restricted statement follows immediately from \(A+B+L=S\): increasing \(A\) decreases \(B+L\). That is precisely the content of `Flow.Balances.family_le_iff`. It cannot establish that \(B\) alone decreases when losses vary. [Theorem 1](https://proceedings.neurips.cc/paper/2020/file/b607ba543ad05417b8507ee86c54fcb7-Paper.pdf).

4. **Coupling rate for several optimizers — exact theorem not found.** Searches covered dynamic commons, preservation payments, renewable-resource differential games and Markov-perfect taxation. Closest: Michele Bisceglia (2020), *Journal of Economics* 129:1–31, “Optimal taxation in a common resource oligopoly game”: a stock-dependent linear tax implements socially optimal extraction in the specified feedback equilibrium, with a duopoly exception. That is **not** your universal preservation threshold. Your theorem remains substantially underspecified: unilateral pivotality, terminal rewards, equilibrium selection and feasible deviations matter. `Optimum.frontier_keeps_stepwise` contains terminal and attainability hypotheses that cannot simply disappear when joined to `mutual_beyond`. [Paper](https://link.springer.com/article/10.1007/s00712-019-00662-y).

5. **Joint option-keeping within margins — already covered in substance.** Juhás, Lehocki and Lorenz (2007), *Winter Simulation Conference*, “Semantics of Petri Nets: A Comparison,” Definition 6: a concurrent transition multiset is enabled exactly when its **summed** input requirements fit the marking; individual enabledness does not suffice. Their resulting-marking equation gives the residual-threshold version by substitution. `Flow.Balances.kept_iff` makes the same arithmetic explicit. Calling preserved threshold-admissible formations “options” adds interpretation; strict widening additionally requires an added option. [Definition 6](https://www.informs-sim.org/wsc07papers/074.pdf).

6. **Set-point choosers and joint excess — already stated qualitatively within active inference itself.** Albarracin, Ramstead, Pitliya, Hipolito, Da Costa, Raffa, Constant and Manski (2024), *Systems* 12:163, “Sustainability under Active Inference,” explicitly state that component-level resilience can deplete resources; §4.4 states that individually optimal policies need not benefit the collective. Your gated, integer-valued extinction witness would sharpen this familiar possibility, not overturn an FEP guarantee of collective sustainability. The unseen-stock clause adds the familiar observation restriction. [Article](https://doi.org/10.3390/systems12050163).

7. **Feeder beyond the blanket — already covered by observational indistinguishability.** Sampath, Sengupta, Lafortune, Sinnamohideen and Teneketzis (1995), *IEEE Transactions on Automatic Control* 40:1555–1575, “Diagnosability of Discrete-Event Systems,” characterize fault diagnosis through observable traces: a fault cannot be certified while a fault-free execution remains observationally compatible. Attaching resource exhaustion supplies a failure mechanism, not a new informational obstruction. Also, a Markov blanket does not promise perfect identification of external states; your coupling closure must be proved to correspond to the claimed blanket. [Paper](https://doi.org/10.1109/9.412626).

8. **Maintenance bounded by free energy — corrected version is known; proposed bridge needs repair.** Reeb and Wolf (2014), *New Journal of Physics* 16:103011, Theorem 3, prove
   \(\beta Q=\Delta S+I+D\ge\Delta S\).
   A finite expenditure budget yields the proposed count only with appropriate entropy, temperature and resource-accounting assumptions. Counting merged states does not establish erased entropy. Crucially, heat export is not automatically **exergy destruction**: Sagawa (2014), *Journal of Statistical Mechanics*, P03025, shows logically irreversible computation can be thermodynamically reversible. Thus Landauer alone does not supply `EntropyProduction.DestroysAtLeast`. [Reeb–Wolf](https://arxiv.org/html/1306.4352), [Sagawa](https://arxiv.org/abs/1311.1886).

For **new candidates, I propose none that I can honestly defend under your criterion**. I investigated two further combinations:

- Observation-limited preservation with finite reserves, joining `Flow.unselected_beyond_coupling_responsive` and `joint_excess_ends`. Searches reached partial-observation energy games, already combining observational equivalence with cumulative resource safety; Pérez (2017), *Information Processing Letters* 118, treats exactly that general setting. [Paper](https://arxiv.org/abs/1512.04255).
- Minimal information needed to preserve resource-dependent continuation. Searches reached Kolchinsky and Wolpert (2018), *Interface Focus* 8:20180041, §5: remove information by interventions and find the maximal removal preserving viability. A resource-threshold instance would not supply the required surprise. [Paper](https://doi.org/10.1098/rsfs.2018.0041).

Neither passes “a specialist would not foresee it.” Producing a more elaborate conjunction would conceal that failure.

My novelty ranking, highest first—all low:

1. **4:** Exact multiplayer threshold remains unlocated, but truth and hypotheses are unresolved.
2. **1:** Exact resource–selection inequality unlocated; likely a familiar covariance bound plus accounting.
3. **7:** Precise support/observation separation might sharpen scope; informational conclusion is established.
4. **6:** Exact witness may be useful; active-inference literature already states the mechanism.
5. **8:** A rigorous physical implementation could contribute; the claimed bound is established physics.
6. **5:** Concurrent feasibility and residual margins are standard.
7. **2:** A direct instance of stronger, sharp moment inequalities.
8. **3:** Conservation algebra under an explicitly restrictive ranking assumption.

── cx · ok · session 01a173af-82ea-7253-afe1-f3ea7a03df90 · gpt-6-astra/high · read-only+net · 386s · 1422.0k tokens · 11 cmds
continue: cx -r 01a173af-82ea-7253-afe1-f3ea7a03df90 "…"
log: /Users/ren/.cache/cx/runs/20261025-233043-46293
