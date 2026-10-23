# Context-dependent establishment and selection through retention

8 October 2026. AI-authored continuation of [The Theory of Evolution](../../../../theories/becoming/history/THE-THEORY-OF-EVOLUTION.md), with substantive author self-review. The previous turn made progress by preserving temporal evidence. This study advances requirements 2, 3 and 5: it connects measured establishment conditions to a conventional selection mechanism and checks the exact local correspondence, preserving the full six requirements.

**Result.** A newer primary study supplies a measured early-formation constraint and a more adequate conventional rival. Low-density WS populations can fail to establish a mat despite repeated microcolony growth. Ancestral cells can participate in the structure in which WS mutants subsequently arise. Later surface representation can increase through reduced dispersal despite slower growth. Seven new Lean theorems check rational local balances and the precise condition for that gain; a counterexample preserves its limit. The empirical rescue comparison is small, and the physical and later evolutionary models remain separately parameterized. No calibrated full-cycle forecast or superiority of our framework follows.

**中文结论。** 新原始研究接通“早期形成受密度与空间结构限制”和“较慢生长者可因较低离散而增加界面占比”。祖先细胞参与后续突变体得以形成的条件；其作用不能先固定为帮助或破坏。七项 Lean 定理／十一项声明审计核验常规模型的局部守恒及选择条件，保留低离散仍失败的反例。实证对照有限，模型参数及数值边界须明示；整周期校准与广泛优越性仍未完成。

## New primary evidence: formation is an actual constraint

[Karita et al. (2026)](../../../../sources/evolutionary-selection/karita-2026/README.md) study SBW25 at 28°C, using 12-well plates for early formation. Dark-field observations were acquired every ten minutes over 24 hours. WS microcolonies can grow and repeatedly fall before joining into a coherent mat. The source's capillary-force account distinguishes accumulating mass from peripheral support; its spatial simulation connects growth, migration, motility and collapse. This already constitutes a conventional relational mechanism, not a scalar mutation advantage without development.

The original workbook reconstructs the following 24-hour outcomes. A separate raw-XLSX XML reader checks the literal count cells, dilution values and dates.

| log10 dilution factor | Successful cultures / total |
|---:|---:|
| 2.0 | 3/3 |
| 2.5 | 6/6 |
| 3.0 | 12/12 |
| 3.5 | 10/15 |
| 4.0 | 0/9 |

These 45 cultures are distributed over 11 dated cohorts. At dilution 10^3.5, individual batches give 1/3, 0/3 and 9/9; pooling retains the published figure but conceals this variation. The count sheet does not identify its cause or establish unchanged material preparation across dates. No transferable, precisely estimated threshold is fitted from the pooled curve.

The collapsed-colony workbook contains 784 positive areas, while the paper's Figure 1d names 769 colonies. Circular-equivalent diameters average 44.5667 in the figure-reported scale; exactly 769 values are at or below 65. This is a sensitivity observation, not proof that 65 was the authors' exclusion rule. All original rows remain. The sheet lacks culture/image nesting and an explicit unit header; a fitted collapse law requires verification against the actual microscopy and calibration. The paper's approximate 40 μm scale should not become an exact universal threshold.

The co-culture rescue experiment reports 2/9 successes compared with 0/15 WS monocultures. It also adds approximately the same number of ancestral SM cells, increasing total inoculum. Twelve controls preceded the plate with the remaining three controls and nine mixtures. The source reports separation only at a 76% interval convention. These counts support a candidate interaction; they do not isolate a mechanical effect independently of density or support a precise general rescue probability. Microscopy of joint colonization and reporter tracking supply additional mechanistic evidence, with reporter sensitivity and genetically labelled backgrounds retained.

## The connection within one history

Formation, retention, movement and reproduction describe differentiated relations within the same cellular and material unfolding. Ancestral activity changes the spatial configuration in which new variants arise and remain. Early attachment and later dispersal have different consequences because the organization and constraints have changed. This gives content to the generative proposal without making genotype and ecological conditions fundamentally independent primitives.

The primary work's sequence is: SM transiently occupies the interface; elevated-c-di-GMP variants arise within that population; WS persists locally as SM disperses. Its inference of mechanical facilitation is supported by images and a conceptual model, but does not independently identify every causal contribution. The same SM type can facilitate early formation yet undermine later mat structure at other abundances or stages. Neither “always helpful” nor “always destructive” is an adequate fixed type assignment.

The [earlier time-lapse study](MAT-HISTORY-INTEGRATION.md) made growth, structural persistence and reformation distinct. The new work adds an actual inoculum-dependent endpoint and explicit physical candidate. It does **not** join those 24-hour plate observations to the [later six-day lineage experiment](../history/root-foundation/DEVELOPMENTAL-TRANSFER-INTEGRATION.md). Different geometry, genotypes, times and scoring rules remain. We cannot use the new 0/9 outcome as the later lineage's first-stage probability.

## Exact recovery of the conventional retention mechanism

The source's four-state model tracks SM and WS at the surface and in the bulk. Growth, dispersal, migration and mutation jointly change these populations. Locations are a bounded representation of measured spatial differentiation. The [new Lean module](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/SurfaceSelection.lean) first checks that paired movement and mutation fluxes cancel in the total cell-number balance. They redistribute cells; the model's total production comes from its growth terms. Death or destructive loss would need its own term.

For the exact saturated-surface slice, let s and w be positive abundances, r_s and r_w their supplied growth rates, and d_s and d_w their supplied dispersal weights. Set D = d_s s + d_w w > 0. With zero immigration and mutation, the source assigns total births to outgoing dispersal in proportion to those weights. The checked identity is

\[
\dot w = r_w w - \frac{d_w w}{D}(r_s s+r_w w)
       = \frac{s w(r_w d_s-r_s d_w)}{D},
\qquad \dot s+\dot w=0.
\]

Thus, at this slice, the checked positive-gain condition is **r_w d_s > r_s d_w**. The dot denotes the model's declared instantaneous balance; the formalization proves rational algebra and its sign, not differential-equation existence or trajectory convergence. At fixed total surface abundance, this balance also identifies the direction of change in representation. Mutation adds its explicit net flux and can change that conclusion; the corresponding cleared-denominator identity is checked separately.

With the source's r_s=1, r_w=0.85, d_s=0.002 and d_w=0.001, equal positive abundances give a positive WS balance of 7/30 in normalized count units despite slower growth. With r_w changed to 0.25 and the same dispersal advantage, the balance is −1/6. These are checked source-rate and constructed contrast witnesses, not measured experimental effects. The reduced dispersal advantage has a quantitative condition; it is not an inevitable favorable direction.

**Seven new theorems and eleven declaration audits pass** in a fresh Lean 4.29.1 build. The [checker and receipt](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/surface-selection-verification/verification.json) audit every definition and theorem and permit only the reported standard Lean logical dependencies. No custom axiom, unchecked proof or native-decide shortcut is used. Real-valued ODE analysis, stochastic drift, actual biological correspondence and universal selection are outside this proof.

## Numerical reproduction and a boundary correction

The [reanalysis package](../../../../experiments/integrated-correction/general-framework/generative-basis/ecological-selection/contextual-establishment/README.md) compares an independent flux decomposition against all four source functions at five states. Twenty numerical components agree exactly in the executed cases. A replay of the source's fixed-step Euler method exposes overshoot of the surface capacity, negative SM populations and a WS fraction slightly greater than one. Halving the time step reduces but does not remove the problem. The code and failed physical bounds are preserved; negative values are not silently clipped.

An explicitly separate event-based adaptation locates the capacity boundary and then integrates with a fixed-total surface coordinate. Its evaluated states remain nonnegative. Two tolerances change daily WS fractions by no more than 1.65 × 10^-9 in the source-rate scenario. The adapted trajectories retain the qualitative source result, while equalizing dispersal prevents the large WS increase. This validates a numerical correspondence and robustness check, not a biological forecast or rigorous global integration error bound.

The source's conversion from model time to nominal days, oxygen-limited growth rates, carrying capacity and equal forward/reverse mutation rates remain supplied choices. The latter equality is explicitly acknowledged in its supplement despite an unmeasured combined reverse rate. The spatial model chooses its 85% coverage endpoint and adjusts a stability coefficient to the observed collapse scale; it omits wall attachment and additional matrix interactions needed for robust mats. A local model's constants are not thereby outside generative reality, but their formation and empirical calibration have not been derived here.

## Substantive counterreview and next test

**What the affirmative account gains:** the evolutionary explanation must include early establishment, contextual support and retained representation. “Slower growth” is not a sufficient loss prediction, and a genotype's advantage cannot be carried unchanged across formation, mature occupancy and reproductive stages. We now recover an explicit conventional mechanism and its boundary conditions, rather than treating an arbitrary favorable fitness coefficient as explanation.

**What survives the strongest rival:** the published spatial and four-state models already encode these interactions. Our rational correspondence, data re-extraction and numerical correction provide integration and verification. They do not establish a new biological mechanism, predictively outperform the informed conventional model, or complete the general recovery of mutation, drift, inheritance and movement. The growth-retention counterexample applies to the specified local law, not to every possible fuller account.

**What would change the account:** an equal-total-density comparison that preserves attachment opportunities but removes the proposed ancestral mechanical contribution could distinguish facilitation from a density effect. Calibrated per-colony mass, geometry and capture time could test the proposed stability threshold without selecting it to reproduce the same collapse distribution. Those measurements must then predict held-out establishment before being linked to later viable descendants. Failure would require revising the mechanism or correspondence, not merely retuning endpoint survival.

The BioImage deposit now provides a concrete next source: its file list identifies 158 microscopy files, including timed formation and rescue acquisitions, totalling about 103 GB. At this study's initial completion, only archive metadata had been preserved. The subsequent [microscopy correspondence](MICROSCOPY-CORRESPONDENCE-INTEGRATION.md) now checks original capture records and scales for five files and two complete image fields, retaining the missing treatment/endpoint join. Targeted access to relevant acquisitions is preferable to treating the original-image evidence as absent or importing the whole archive blindly. Even successful early-stage calibration will not establish the six-day life cycle unless the actual culture and scoring correspondence is supplied.

This study establishes verified local mathematical recovery, checked empirical summaries and a tested numerical limitation. It supplies constraints on actual capacities for further life; it adds no ethical warrant beyond the separately stated G0 route. Counterreview here is author self-review, not independent agent acceptance. The full evolutionary goal remains active and all six completion requirements remain unchanged.
