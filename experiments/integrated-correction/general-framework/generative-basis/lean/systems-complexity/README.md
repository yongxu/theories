# Systems, complexity and chaos in Lean

6 October 2026. This completes the mathematical formalization selected by the [systems integration](../../../../../../theories/becoming/history/SYSTEMS-COMPLEXITY-CHAOS.md) and its requested recurrent-revision continuation. **162 distinct new theorem audits pass:** the initial 80 Std and 24 real-analysis results, plus 58 varying-gain and supported-revision results below. The original generative-core source is unchanged; inherited core and resource-continuation audits are replayed and counted separately. [Initial independent review](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/SYSTEMS-COMPLEXITY-LEAN-REVIEW.md) · [Continuation review](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/VARYING-DYNAMICS-REVIEW.md).

The named connection is **formed relations → collective dynamics → limits and conditions of continued response**. The mathematical descriptions differentiate state, coupling, stored history and observation within one trajectory. The actual trajectory-to-core correspondence is proved; it does not add an actor, evaluator or physical interpretation to the equations.

## What is proved

| Module | New audits | Main mathematical content |
| --- | ---: | --- |
| [SystemsOrganization.lean](SystemsOrganization.lean) | 24 | Commuting transition maps are equivalent to exact evolution under every action word. An autonomous reduced law exists precisely when same-summary states have the same next summary, given an explicit representative section. Coupled components preserve their common history. Identical copy cells with different routing have different recurrence. Actual paid link assembly changes subsequent enabled events; a parts-only summary cannot preserve those futures. |
| [FeedbackDynamics.lean](FeedbackDynamics.lean) | 20 | Exact rational delayed-energy transport. At gain 6/5, immediate response converges in the ordinary epsilon sense, while every nonzero delayed full state eventually exceeds every squared-norm bound. Gain 1 returns each full state after six steps. |
| [SymbolicDynamics.lean](SymbolicDynamics.lean) | 32 | A proved finite pigeonhole result gives eventual periodicity of any total deterministic system with an injective complete-state encoding into `Fin n`, with transient plus period at most n. The infinite binary shift is continuous, topologically transitive, has dense periodic points and is uniformly sensitive in an explicit prefix topology. That topology is proved equivalent to finite-coordinate product neighborhoods. |
| [SystemsComplexity.lean](SystemsComplexity.lean) | 4 | Every finite iterate has the corresponding actual `Generative.Trace`. The same shift and rational delayed recurrence used in the dynamical theorems instantiate this result. |
| [RealFeedback.lean](analysis/RealFeedback.lean) | 24 | For every real gain and real initial state, immediate convergence holds exactly for 0<k<2 and delayed convergence exactly for 0<k<1. Coercive Lyapunov bounds prove delayed stability as well as convergence. For k>1 every nonzero delayed state’s squared norm tends to infinity; gain 1 has six-step recurrence. The real recurrence also has exact generative-core traces. |

These are proofs over arbitrary times, states and declared parameters, rather than finite numerical samples. The symbolic-chaos theorem is a positive infinite-state witness; eventual recurrence of a finite autonomous model is a separate result. A finite observation history does not turn the symbolic state space into a finite state space.

## The real feedback result

The supplied dynamics are

\[
x_{t+1}=(1-k)x_t,
\qquad
(x_{t+1},x_t)=(x_t-kx_{t-1},x_t).
\]

For the delayed system, the proof uses

\[
V_k(x,y)=2x^2+2k(x-y)^2+k^2(k+1)y^2,
\]

and checks the exact identity

\[
V_k(A_ks)=V_k(s)-k(1-k)(k+2)\lVert s\rVert^2.
\]

For 0<k<1, the verified bounds are

\[
k^2\lVert s\rVert^2\le V_k(s)\le8\lVert s\rVert^2.
\]

They yield a geometric decay bound with rate `1 - k(1-k)(k+2)/8`, ordinary convergence of the full squared Euclidean norm, and an explicit small-initial-state stability condition. Separate trajectories rule out universal convergence for k≤0 and k≥1. For k>1, the transported quadratic form `x² - xy + k y²` proves divergence of every nonzero full state. These quadratic functions are mathematical devices, not physical fuel or measures of patient welfare.

## Recurrent revision and support

The [requested continuation](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/VARYING-DYNAMICS-INTEGRATION.md) preserves the same real delayed plant. [AdaptiveCore](analysis/AdaptiveCore.lean) defines its time-dependent trajectory and common envelope `max |x| (max |y| |x-y|)`.

| Module | New audits | Checked connection |
| --- | ---: | --- |
| [VaryingFeedback](analysis/VaryingFeedback.lean) | 17 | Every gain sequence in [0,1] preserves the envelope. A uniform interior margin δ gives three-step contraction by 1−δ, all-time and finite-prefix geometric bounds, and convergence of the envelope and squared norm. |
| [ShrinkingGain](analysis/ShrinkingGain.lean) | 15 | Every frozen gain in the sequence 2^(−t−2) converges, while the actual varying trajectory from (1,1) has both coordinates above 1/2 at every time. The lower bound is proved from the reached states and exact gain sum. |
| [SupportedRevision](analysis/SupportedRevision.lean) | 26 | Paid operation, acquisition and update change the next gain using acquired overshoot. Every funded N-cycle generative trace projects to the same delayed trajectory and satisfies the (3/4)^floor(N/3) envelope bound. Exact original support accounting, reader intervention and exhaustion are proved. |

The declared support law transfers three units from an original packet per operation and spends one unit on each of operation, reading and update. Total support decreases by three per cycle. Arbitrarily many separately funded prefixes do not establish a single infinite finite-reserve execution; a general theorem excludes that execution. The truthful/clamped comparison proves causal use of the acquired report, while both gain schedules remain safely bounded. Exact sensing, installed gain menu and update law, event schedule and support conversion remain supplied. No empirical identification, selection optimality or ethical warrant is inferred.

## Reproduction and dependencies

Run from this directory:

```sh
python3 check.py
python3 analysis/check.py
python3 analysis/check_adaptive.py
```

The [Std checker](check.py) uses installed Lean **4.29.1**, imports `Std` and the existing `GenerativeCore`, and builds all five local modules in a fresh temporary directory. [Its receipt](verification.json) records **80 new + 18 inherited** audits, source snapshots, compiler and checker hashes, complete per-theorem axiom lists and [logs](verification/SystemsComplexity.txt). The prior pre-correspondence receipt remains under [verification history](verification-history/before-core-correspondence/verification.json).

The [analysis checker](analysis/check.py) uses installed Lean **4.30.0-rc2** and Mathlib commit `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`. It rebuilds the local core and Std sources with that compiler before building `RealFeedback`; existing pinned upstream Mathlib artifacts are used, not rebuilt. [Its receipt](analysis/verification.json) records **24 new + 98 replayed** audits. Those 98 are the already counted Std package and core, not additional discoveries. Set `SYSTEMS_MATHLIB_PROJECT` to a checkout whose manifest and Mathlib HEAD match the recorded commit; `SYSTEMS_REAL_LEAN` can select the matching installed compiler. Neither checker installs or modifies dependencies.

Both fresh builds pass without warnings, proof placeholders, custom axiom declarations or native evaluation proof shortcuts. **31 of the 104 new declarations have empty axiom lists**; the remaining proofs depend only on some or all of Lean’s standard `propext`, `Classical.choice` and `Quot.sound`. This is not a claim of assumption-free mathematics or physics. An empty axiom list also does not discharge a theorem’s stated hypotheses or justify its application.

The separate [adaptive checker](analysis/check_adaptive.py) uses the same pinned analytic compiler and Mathlib cache. Its [receipt](analysis/adaptive-verification.json) records **58 new + 143 inherited** audits: the 104 earlier systems results, 18 selected core audits and 21 resource-continuation audits. It freshly compiles all eleven local modules, checks exact ordered theorem audit names and freezes source/compiler/checker/manifest/toolchain inputs. All 58 new results use only the same standard logical axioms; none has an empty dependency list. This brings the distinct package total to 162, with 31 empty lists. Existing checkers, receipts and sources remain unchanged. Upstream cached Mathlib is used, not rebuilt.

## Scope of completion

Completed here are the specified mathematical connections: exact abstraction and coupling, a costed formation witness, fixed and varying feedback convergence with failures, finite-state recurrence, an explicit chaotic shift, and their generative-history representation. The continuation additionally joins recurrent acquired gain revision to actual funded traces, regulation bounds and exhaustion. The strengthened formalization preserves the chapter’s adverse cases and distinguishes stable, periodic, divergent and chaotic behavior.

The supplied local inputs remain identifiable: the transition laws and projection roles; the formation recipe, spare and fuel; exact linear observations and timing; an injective finite encoding for the finite theorem; the full infinite stream space and prefix observations for the chaos theorem. Exchange in the small organization witness is cost-free, so its recurrence is not a proof of physical sustainability. The existing concern learner’s paid inquiry revision retains its separate [accepted formalization](../../../../../../theories/becoming/history/INQUIRY-REVISION.md).

Historical comparisons with Bertalanffy, Simon, Turing, Holland, Lorenz and OGY remain source-based prose. We do not claim a formalization of those complete works, a Lorenz-flow chaos theorem, empirical identification of these local laws, or ethical necessity from complexity. Those are different claims, not hidden premises of the completed results above.

Further details: [organization scope](SYSTEMS-LEAN-NOTES.md), [rational feedback scope](FEEDBACK-LEAN-NOTES.md), [symbolic topology and chaos scope](CHAOS-LEAN-NOTES.md).

## Relations across scales, 8 October 2026

[The new account](../../../../../../theories/becoming/history/RELATIONS-ACROSS-SCALES.md) extends exact projections to time-dependent descriptions, finite-horizon errors, composition and calibrated indexed conditions. [RelationsAcrossScales.lean](analysis/RelationsAcrossScales.lean) has **21 new checked theorems**, with **42 inherited audits** replayed separately. These are not included in the historical 162 above. [Proof and premises](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RELATIONS-ACROSS-SCALES-PROOF.md) · [Counterreview and prior work](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RELATIONS-ACROSS-SCALES-INTEGRATION.md).

Run `python3 analysis/check_scales.py` for a fresh build against the same pinned installed analytic environment; [receipt](analysis/scales-verification.json). Exact totals can conceal particular support losses; changed coupling can defeat a previously exact total-only law. Laws, maps, error calibration and normative thresholds remain supplied. No empirical validation or all-policy equivalence is claimed.


### Acquired description revision and response

[ScaleRevision.lean](analysis/ScaleRevision.lean) adds **27 checked theorems**, with **106 inherited audits** freshly replayed. It imports the actual remaining-dependency charger and context decoder into a new quantitative history. Paid acquisition and delayed revision alter the response; calibration, work and support failures remain, and a fixed-response rival succeeds. This is not a replay of the ancestral learner or a measured biological loop. [Hypotheses, theorem map and counterreview](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/SCALE-REVISION-INTEGRATION.md).

Run `python3 analysis/check_scale_revision.py` in this directory for a fresh build; [receipt](analysis/scale-revision-verification.json). Earlier 21 scale results and the separate 14 embodied-choice results retain their own receipts and are not counted again as new here.


## Organized activity across scales, 8 October 2026

[OrganizedScaleLoop.lean](analysis/OrganizedScaleLoop.lean) adds 26 checked theorems and replays 77 inherited audits. Local signal composition, actual view commutation, supported acquisition/withdrawal, history and regional counterexamples, and competing-context recontact share one event law. [Receipt](analysis/organized-scale-verification.json) · [Premises, evidence and completion limits](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/ORGANIZED-SCALES-INTEGRATION.md). This conditional construction is not a fitted biological model.


### Inquiry or immediate response

[InquiryChoice.lean](analysis/InquiryChoice.lean) adds **28 checked theorems / 133 inherited audits**. Robust interval and observation-class criteria connect current evidence to common response feasibility. Actual routes share the horizon and starting work/support; sensing changes the selected dose, while wider tolerance admits a cheaper immediate response. The failed headroom/work-only selector and its support-aware repair are both retained. [Hypotheses, counterreview and source comparison](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/INQUIRY-CHOICE-INTEGRATION.md).

Run `python3 analysis/check_inquiry_choice.py` in this directory for a fresh pinned build; [receipt](analysis/inquiry-choice-verification.json). General planner certificates and concrete charged executions retain separate scopes. No empirical calibration or global policy optimality is asserted.


### Changing dependencies after acquisition

[ChangingDependency.lean](analysis/ChangingDependency.lean) adds **25 checked theorems / 161 inherited audits** on temporal error, response tolerance, changing losses and refreshed response. An acquired loss can become misleading while its timestamp remains current; a later within-bound change defeats exact continuation after refresh. The bounded refresh repair covers every pair of losses in [1,3], with a separately checked charged execution. [Hypotheses and self-counterreview](../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/CHANGING-DEPENDENCY-INTEGRATION.md).

Run `python3 analysis/check_changing_dependency.py`; [receipt](analysis/changing-dependency-verification.json). New exact readout channels, event law, change envelopes and tariffs are explicit. General error certificates are not a claim of biological calibration or all-policy optimality.
