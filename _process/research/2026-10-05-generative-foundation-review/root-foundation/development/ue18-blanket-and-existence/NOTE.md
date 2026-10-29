# UE18: the Markov blanket as a coupling structure, and what the existence claim forbids

29 October 2026. AI-written note for board item UE18, item 3 of the plan for the free-energy principle as an integral part of the theory ([FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md); [design](DESIGN.md)), with the module `Becoming.Blanket` in [tree/Becoming/](tree/Becoming/Blanket.lean). It states what the Lean proves, what it shows and does not, and the standing of each law. Revised after an independent review (§7), which read the first draft's bytes (sha256 `555ee68e…6078a63`, [scratch-2.log](scratch-2.log)).

## 1. Summary

The free-energy principle partitions a system's states into internal, sensory, active and external states, sensory states not moved by internal ones and active states not by external ones (Friston 2013; Kirchhoff, Parr, Palacios, Friston and Kiverstein 2018). Its existence claim is that whatever persists, with such a partition, will appear to minimize free energy (Friston 2013, 2019). UE1's search graded the persistence statements (d): necessity or as-if claims, none saying that self-evidencing suffices for persistence ([search](../ue1-fep-bridge/THIRD-PART-SEARCH.md), candidate 15). So this item forbids no sentence of the literature. It states the partition on a determined law, four parts of one law told apart only by which part reads which, and shows:
- **The agent is driven by its sensory course.** The internal and active parts, from one start, are fixed by the sensory course alone; the sensory and external parts by the active course. So a determined policy is a selection through the sensory course, with no action listed among what couples in, and each side's course is fixed by its start and the blanket's course: the deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022), independence given the blanket's history, not its present state.
- **What the sensory part reads of the world bounds what the agent tells apart.** Where the sensory part reads the external part only through a map, two courses alike through it are alike for the agent: 03 §6's lumping on every blanketed law.
- **Self-evidencing does not see its break coming.** With any model, updated by any rule, and any policy, an agent reading its supply only by threshold, no action changing the supply, has every reading of its internal course alike up to step four from a supply of three and from every supply of four or more, a free energy of its belief at any step before four among them, the sensory parts being alike there; at step five the first has ended. The break is registered when it comes, at step four, when the sensory parts first differ, not before. The witness's blanket is exactly the World's coupling by threshold: its sensory part is the World's admission, and its courses are blanket-alike exactly where the supply histories are alike through the formation's couplings. On the World the law is T6's invisible half.
- **What the existence claim forbids.** Read off a course of a determined law, the claim's model is conditioning on the course itself: the point weighting is the counting weighting restricted to the record of being that course. Under it the course is of least surprisal and every event not holding at it weighs nothing; the occupation weighting read off a run admits every visited state, ending included, and the ended witness rests at a fixed point of its law; read as a steady state with a trivial blanket, the claim's antecedent holds of it too [AI reading, D45]. A listed outcome is forbidden exactly where its weight is nothing: forbidding needs a weighting fixed apart from the course, such as the density of another law.

**[AI reading, D45]** The principle's blanket names the theory's couplings, and its existence claim, with the model read off the persisting thing, holds of every course, as its proponents concede for principles of its kind (Ramstead and others 2023). What forbids are laws of the courses themselves, holding whatever weighting is put on them: the commuting law, the outrun law and the held pair of a set point (UE16). What persistence needs beyond self-evidencing is what the theory's renewal and coupling laws state: the supply coupled in by level, a model answerable to what couples in, or another formation into which it couples (Runaway's readings), and renewal of what feeds. Where the principle has an agent act "ahead of actuality" through a deep generative model, partly on priors shaped by selection (Kirchhoff and others 2018, §3.2–3.3), the theory places it: for a supply coupled in by threshold only, that anticipation can come from such priors, a coupling by level or another formation, never from the blanket's course (`through_reading`; T6).

## 2. The laws

The module has 33 theorems in 49 declarations, every axiom report empty ([scratch-5.log](scratch-5.log)). Names are in `Becoming.Blanket`.

### Law 1. The agent through its sensory course (`Blanketed`)

- `Blanketed I S A E` has four maps, `nextInternal` and `nextActive` from the internal, sensory and active parts, `nextSensory` and `nextExternal` from the sensory, active and external parts; `Parts` is a configuration (`internal`, `sensory`, `active`, `external`); `step` moves all four at once; `course` is the law's orbit; `congr3` a helper.
- `agent_through_sensory`: two courses from one internal and one active state, alike on the sensory part before `n`, have one internal and one active state at `n`; `world_through_active`: two from one sensory and one external state, alike on the active part, have one sensory and one external state.
- Corollaries: `internal_through_blanket` and `external_through_blanket` (each side fixed by its start and the blanket's course, `BlanketAlike`), `reads_through_blanket` (a reading of the internal course up to `n`).
- `Deaf.law`, `Deaf.lumps`: an internal part reading nothing, blankets apart and internal courses alike: a reading through the blanket separates at most what the blanket tells apart.

### Law 2. Through what the sensory part reads (`through_reading`)

On every blanketed law whose sensory part reads the external part only through `π` (`Learning.Lumped π (nextSensory s a)`), two courses from one internal, sensory and active state whose external parts are alike through `π` before `n` have one internal, sensory and active state at `n`.

### Law 3. Self-evidencing does not see its break coming (`ThresholdDrain`)

- `law`, `short`, `long`: the internal part whether the system goes on, the sensory part the threshold reading `Nat.blt 0` of the supply (`reads_threshold`), the supply draining by one.
- `alike_before_four`, `sensed_at_break`: the blankets agree before step four; at step four the sensory parts differ, the internal parts agree; at step five the short course has ended and the long one goes on. `ended`, `ended_rests`, `short_rests`: from step five the short course rests at the ended configuration, a fixed point.
- `web`, `sensory_is_admission`, `external_course`, `sensory_succ`, `bool_eq_of_iff`, `blanket_iff_through`: the sensory part is the World's admission at need one, and from one start the courses are blanket-alike before step `n + 2` exactly where the two supply histories are alike through the formation's couplings, by threshold only, up to `n` (`Web.AlikeThroughUpTo`).
- `modelLaw`, `start`, `sensed_alike`, `blanket_alike`, `any_model`, `sensory_apart_at_four`: with any model `M` updated by any rule and any policy, from a supply of three and from every supply of four or more, every reading of the internal course up to step four is alike, the sensory parts differing first at step four, while at step five the first has ended and the second goes on.

### Law 4. What the existence claim forbids

- `point`, `isAt`, `point_is_restrict`: the point weighting on `x` is the counting weighting restricted to the record of being `x`.
- `point_whole`, `least_surprisal`: under it a listed `x` weighs something, its share is the whole, and no event has a greater share; `point_forbids_rest`: every event not holding at `x` weighs nothing.
- `visits`, `visits_le_succ`, `visits_pos`, `visits_zero`, `read_off_admits`: the occupation weighting read off a run gives every visited, listed state a positive share and every unvisited state no weight.
- `le_mass_of_mem`, `unweighted_share`, `forbids_iff`: a listed outcome's share is nothing exactly where its weight is.

## 3. What it shows, and what it does not

Shows:
- the principle's blanket, in dynamical form, as a coupling structure: the agent a selection through its sensory course, its discriminations bounded by what the sensory part reads (03 §6);
- that self-evidencing, with any model and policy, cannot tell a world in which its break comes from one in which it does not, before the break registers; and, for the witness, that its blanket is the World's coupling by threshold;
- that the existence claim, with the model read off the persisting thing, admits every course, the ended one included, and that forbidding needs a weighting fixed apart from the course or a law holding under every weighting.

Does not show:
- densities, the Helmholtz decomposition of a steady-state flow, or nonequilibrium steady states: the principle's own construction stays outside the core;
- that statistical blankets (conditional independence at a steady state) and dynamical ones (sparse coupling) coincide, which they need not (Biehl, Pollock and Kanai 2021; Aguilera, Millidge, Tschantz and Buckley 2022), or that a thing has a unique blanket;
- a World formation in general as the agent of a blanketed law, its sensory course its own course (`Web.selectsThrough_iff_prefix`) and its environment the levels under the others' fixed exchange: the join is proved for the witness only, and the general one is an item of its own;
- any free energy (UE17's is in the periphery), or that any actual system persists or ends;
- the foraging law the review proposed, a threshold-reading policy unable to spend a larger supply (the blanket form of `Flow.policy_keeps_difference`), not stated;
- that the principle is wrong: its persistence statements are necessity or as-if claims, and nothing here forbids a sentence of its literature.

## 4. Readings

**[AI reading, D45] The blanket is the couplings.** A formation's couplings in the World (its support, read by threshold, and the levels it observes) are its sensory states, and what it keeps of what couples in its internal states; the blanket condition is then what 03 §1 states of its couplings. The selections through a formation's couplings together separate exactly what they tell apart (03 §1); any one of them, the internal course among them, at most that (`Deaf.lumps`). In the witness the blanket is the World's coupling (`blanket_iff_through`); in general it is the reading, until the join lands. So the principle's blanket adds no law to the theory's couplings; it names them. What the theory adds is which couplings carry what: a supply coupled in by threshold only carries no distance to the break.

**[AI reading, D45] Persisting is not read off self-evidencing.** The existence claim reads the model off the thing that persists, so it holds of every course and forbids none; its necessity direction is then true by construction, and its sufficiency direction, which the literature does not assert, fails in the witness because no action of the system changes its supply: it ends whatever couples in. That the failure lies in the uncoupled distance to the break would need the foraging law, not stated; what the witness shows is that persisting rests on renewal, which self-evidencing does not supply. The theory's laws of renewal state what persistence needs, which the principle presupposes.

## 5. Standing and refutation

- **The blanket.** The deterministic case of the time-unrolled Markov blanket (Virgo, Rosas and Biehl 2022): the sensory and active courses are Pearl's blanket (1988) of the internal course in the law's unrolled graph, while the partition itself is what Bruineberg and others (2022) call a Friston blanket; near-definitional. UE1 already called sparse coupling near-definitional (`ChoiceCountCapture`); what is added is the agent form, which removes, for a determined policy, UE1's caveat that an action must be listed among what couples in, and the lumping form. Refuted by an internal course reading the external part other than through the sensory one.
- **The break unseen.** T6's invisible half (`Web.break_not_bounded`), here for every model and policy on a blanketed law, and joined to the World for the witness; the witness is elementary. Refuted by a self-evidencing system reading its supply only by threshold that nonetheless bounds its distance to the break.
- **The existence claim.** Known and conceded: the principle's proponents class it with principles of stationary action, not falsifiable strictly speaking (Ramstead and others 2023, §2); Andrews (2021) defends it as a formal structure whose content lies in the models it is construed with; the critics' worry is breadth (Raja, Valluri, Baggs, Chemero and Anderson 2021; Bruineberg, Dołęga, Dewhurst and Baltieri 2022), and a blanket in the steady-state density holds only in a narrow region of weakly coupled linear systems (Aguilera and others 2022). Near-definitional. The claim's average form, the weighting read off a course maximizing its likelihood, is Gibbs' inequality (UE17's periphery; its counting form unproved).

## 6. Counts, placement and modelling

- **Counts.** 33 theorems in 49 declarations, every axiom report empty ([scratch-5.log](scratch-5.log)); scratch-1 and scratch-2 were the first draft's builds, scratch-3 had one linter warning, scratch-4 was the review's fold.
- **Records.** Two: *the Markov blanket as a coupling structure* (Laws 1 to 3), homed in 03 §1 after the reading on the principle's agent, linking 02's runaway record and 03 §10; *what the existence claim forbids* (Law 4), homed in 03 §6 after free-energy-bounds-surprisal (UE17). 08 §8 gains one bullet. The design's witness of internal and external courses that differ together through the blanket is `ThresholdDrain` (`external_course` with `sensed_at_break`); `Deaf` shows a reading through the blanket separating less than it.
- **Placement.** A leaf importing `Becoming.ConditionalWeights` (L1), through which the World's `Web.Admits` and `Web.AlikeThroughUpTo` come.
- **Modelling.** Discrete synchronous steps; the four parts of any types; the blanket as sparse coupling of a determined law; natural weights on listed outcomes; surprisal read as the reciprocal share, with no logarithm.

## 7. Review

An independent read-only review by another AI agent ([REVIEW-UE18](REVIEW-UE18.md)) rebuilt the first draft with a probe of 25 theorems in 30 declarations, every axiom report empty, and checked the literature, Kirchhoff and others (2018) §3 and Ramstead and others (2023) §2 at the source. It found the Lean sound and pure core and `Blanketed` a fair form of the partition, but the module proving less than its text said, and as drafted explaining nothing beyond landed laws. Its eight findings, every one taken:
- **F1** the join to selection through couplings is proved for the witness (`sensory_is_admission`, `blanket_iff_through`), the general join named as an item of its own;
- **F2** a free energy reads the sensory record as well as the belief: the law is now that the break is not seen *coming*, the break registered when it comes (`sensed_at_break`), and the end is at the next step, five;
- **F3** the witness quantifies over every model and policy and every larger supply (`any_model`), and the law it instances is stated on every blanketed law through 03 §6's lumping (`through_reading`);
- **F4** Law 1 is graded as the deterministic case of the time-unrolled blanket, independence given the blanket's history, with the agent form adopted (`agent_through_sensory`, `world_through_active`, `internal_through_blanket` a corollary);
- **F5** the existence laws carry their content: `least_surprisal` for a listed course, `point_forbids_rest`, and the necessity proved (`forbids_iff`, `read_off_admits`);
- **F6** the calibration says the model read off a course is conditioning on it (`point_is_restrict`), a steady state an occupation weighting, the ended witness a fixed point (`short_rests`), and that the claim's emptiness is conceded, Andrews (2021) and Ramstead and others (2023) cited for what they say;
- **F7** the principle's anticipation is placed (§1 reading), the foraging law named as not stated, the average form named;
- **F8** the parts are named once (`internal`, `sensory`, `active`, `external`, with `next…` maps), the partition's relational basis is stated, `Drain` is `ThresholdDrain`, `least_surprise` is `least_surprisal`, and corollaries are counted as such.

The module went from 13 theorems in 24 declarations to 31 in 47.

The reviewer then re-checked the fold ([RECHECK-UE18](RECHECK-UE18.md)), with a probe of two theorems, every axiom report empty: the Lean sound, with eight findings, every one taken. A free energy at step four reads the record there, where the sensory parts differ, so the readings alike are those before step four (R1, `sensory_apart_at_four`). The selections through the couplings together separate exactly what they tell apart, any one at most (R2). The witness ends whatever couples in, so sufficiency's failure is pinned on renewal (R3). The 03 §1 text states the supplies as the Lean does (R4). The `Runaway` import was unused and is dropped (R5). The design's witness is `ThresholdDrain`, not `Deaf` (R6). The blankets' agreement before step four has its own law (R7, `alike_before_four`). The wording is mended: what is conceded is that the claim alone forbids nothing, the agent form helps a determined policy, the record's statement says what `forbids_iff` proves, and the antecedent at a fixed point is labelled a reading (R8). The module went to 33 theorems in 49 declarations.

## References

- Aguilera, M., Millidge, B., Tschantz, A., and Buckley, C. L. (2022). How particular is the physics of the free energy principle? Physics of Life Reviews 40, 24–50.
- Andrews, M. (2021). The math is not the territory: navigating the free energy principle. Biology & Philosophy 36, 30.
- Biehl, M., Pollock, F. A., and Kanai, R. (2021). A technical critique of some parts of the free energy principle. Entropy 23, 293.
- Bruineberg, J., Dołęga, K., Dewhurst, J., and Baltieri, M. (2022). The emperor's new Markov blankets. Behavioral and Brain Sciences 45, e183.
- Friston, K. (2013). Life as we know it. Journal of the Royal Society Interface 10, 20130475.
- Friston, K. (2019). A free energy principle for a particular physics. arXiv:1906.10184.
- Kirchhoff, M., Parr, T., Palacios, E., Friston, K., and Kiverstein, J. (2018). The Markov blankets of life: autonomy, active inference and the free energy principle. Journal of the Royal Society Interface 15, 20170792.
- Pearl, J. (1988). Probabilistic Reasoning in Intelligent Systems. Morgan Kaufmann.
- Raja, V., Valluri, D., Baggs, E., Chemero, A., and Anderson, M. L. (2021). The Markov blanket trick: on the scope of the free energy principle and active inference. Physics of Life Reviews 39, 49–72.
- Ramstead, M. J. D., and others (2023). On Bayesian mechanics: a physics of and by beliefs. Interface Focus 13, 20220029.
- Virgo, N., Rosas, F. E., and Biehl, M. (2022). Embracing sensorimotor history: time-synchronous and time-unrolled Markov blankets in the free-energy principle. Behavioral and Brain Sciences 45, e215.
