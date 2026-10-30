# UE1: a search for the third part in the free-energy literature

25 October 2026. AI-authored study for board item UE1, answering [NOTE](NOTE.md) §7(b) and [REVIEW-UE1](REVIEW-UE1.md) finding 21. The [plan](../ue-unified-explanation/PLAN.md) §1 defines a containment's third part as something the theory forbids that the framework leaves open. Here that means a statement made in the free-energy (FEP) or active-inference literature that a proved law of the theory forbids, under named hypotheses. This is a candidate list, not a result; nothing here goes to a record.

Grades:

- (a) forbidden as stated;
- (b) forbidden under a natural reading;
- (c) not forbidden, because the claim is already qualified;
- (d) not comparable.

Quotations are kept to a few words. Every paper quoted is open access, and the licence is given in the source list.

## Summary

- **16 candidate claims from 15 papers.** Grades: (a) none as the main reading, though one literal clause of candidate 1 is (a); (b) 7 (candidates 1–7); (c) 6 (candidates 9–14); (d) 3 (candidates 8, 15 and 16).
- **UE1's own laws forbid nothing found.** These are selection through couplings, its pooled form, capture through the rule and closed capture. No paper claims that belief sharing, federated inference or a collective Markov blanket lets a group respond to what no member couples to. Every collective claim stays within the union of the members' couplings, which is the pool law's positive half, and is graded (c).
  - Synergy claims are no exception. "What the flock knows that the birds do not" (candidate 11) is information about a function the pool determines jointly. The pool law allows that, because it is pairwise: the pool separates two histories exactly where some member does.
  - The literature itself reports the locks UE1 restates (echo chambers, self-confirming beliefs). It also reports that individual and collective free-energy minima can come apart ([below](#what-the-literature-already-states)).
- **The (b) statements fall under other laws of the theory, in three families.**
  - *Symmetry* (candidates 1, 4, 5, 6). Identical or mirror-symmetric agents are said to be guaranteed to differentiate, or to come to share a model or a language. [01's commuting law](../../../../../../theories/becoming/chapters/01-ROOT.md#r-what-a-commuting-law-keeps-apart) and [05 §9's shared codes](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations) forbid this for a deterministic law that keeps the symmetry, from a symmetric start.
  - *Joint excess and the outrun law* (candidates 2 and 3). The claims are that risk minimization ensures an agent's needs are met, and that shared models and preferences make each agent's goal the group's ([05 §1](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess), [§7](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-several-optimizers-drain-by-their-joint-capacity)).
  - *Lumping* (candidate 7, weak). The claim is that seeking information gives inherent self-correction ([03](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-generalization-through-lumping)).
- **The strongest candidate is 1, graded (b).** Friston, Levin, Sengupta and Pezzulo (2015) say that identical cells, minimizing free energy from one location, are "guaranteed" to reach unique places, because the minimum lies there, at "a unique free-energy minimum".
  - The commuting law forbids the guarantee for the paper's deterministic descent from an exchange-fixed start: the cells never part. Minima also come in exchanged pairs, so the literal uniqueness clause is (a), though it reads as a slip for "unique up to which cell is where".
  - The paper's own simulation broke the symmetry with small random initial expectations. Independent fluctuations, as in the FEP's random dynamical systems, would break it too.
- **Every (b) forbids a verbal generalization, not a paper's simulation.** The simulations break the symmetry by random starts and have no shared draw. Every forbidding law is also a known result: symmetry breaking (Curie, Turing, Angluin) and the commons (Lloyd, Hardin).
- **What UE1 can claim.** On its own laws, UE1 stays a restatement with its third part open. It can claim a third part only by widening the containment to cite these other laws, with their hypotheses stated and labelled as known results (see [For UE1](#for-ue1)).

## Candidates

### 1. Identical cells guaranteed to find unique places (b; one clause a)

- **Source.** Friston, Levin, Sengupta and Pezzulo, "Knowing one's place: a free-energy approach to pattern regulation", *J. R. Soc. Interface* 12 (2015) 20141383. Read in full: §1 ¶6, §4 ¶1, ¶3, ¶8.
- **Claim.** At the start of morphogenesis all cells are identical: same model, no knowledge of place or fate. Each cell minimizing variational free energy should come to infer a unique place, and "This is guaranteed" because the minimum lies where each cell is in a unique location (§1 ¶6). Because a cell can be in only one place, "there is a unique free-energy minimum" where every cell knows its place (§4 ¶3). In the simulation, "All the cells started at the same location", with "small random expectations" about their fate (§4 ¶1, ¶8).
- **Definite or aspiration.** Definite: a guarantee, with an argument from where the minimum lies.
- **Forbidding law.** [What a commuting law keeps apart](../../../../../../theories/becoming/chapters/01-ROOT.md#r-what-a-commuting-law-keeps-apart) (pure core, recorded).
  - `Law.Commutes.keeps_fixed`: a run from a configuration that σ fixes stays where σ fixes.
  - `Law.Commutes.iterate`: the run from σx is the image of the run from x.
  - The roles form is 05 §9's `symmetric_assignment_not_unique` (periphery, empty axiom report, no record): a predicate invariant under swapping two roles cannot hold of exactly one.
- **Hypotheses.**
  - The step on the joint state of the cells is determined, with no fluctuation.
  - The step commutes with the exchange σ of two cells. It does here: every cell has the same generative model and the same receptors, and responds to the same fields, so exchanging two cells' positions, expressions and internal states commutes with the step.
  - The start is fixed by σ: the two cells share one position and one internal state.
- **What follows.**
  - The two cells are identical at every step. They never hold two places or two identities.
  - Every minimum in which the cells hold distinct places has its exchanged image as another minimum, and another rest of the flow. So no minimum with distinct places is unique.
  - A unique minimum would be fixed by every exchange. That means coincident cells, which contradicts "every cell knows its respective place".
- **Are the paper's systems within the hypotheses?** The equations of motion for internal and active states (eqs. 3.2, 4.4) are a deterministic descent. The stated start (identical cells at one location) meets the hypothesis wherever the internal states are equal too.
  - The simulation gave the cells small random initial expectations, and the generative process carries receptor noise set very low (§4 ¶5). So its success is consistent with the law, which says the symmetry must be broken.
  - The argument for the guarantee, from where the minimum lies, supplies no asymmetry.
  - Under the FEP's random dynamical systems, with fluctuations independent across cells, the symmetry breaks almost surely and the law does not apply.
- **Grade: (b).** The guarantee is forbidden under its natural reading: identical cells are identical in state, and the descent is the deterministic flow the paper writes.
  - The literal clause "unique free-energy minimum" is (a) under the paper's own hypothesis that every cell has the same model. It reads as a slip for "unique up to which cell is where".
  - Known: Curie's principle (1894) and Turing (1952), who notes that morphogenesis from a symmetric state needs random disturbances.

### 2. Risk minimization ensures that needs are met (b)

- **Source.** Albarracin, Ramstead, Pitliya, Hipólito, Da Costa, Raffa, Constant and Manski, "Sustainability under Active Inference", *Systems* 12 (2024) 163. Read in full: §4.3 pp. 14–15, §4.4 pp. 16–17.
- **Claim.**
  - Expected free energy gives two complementary ways of "ensuring sustainability" (p. 14).
  - Risk minimization ensures that preferences, or needs, are continuously met over the planning horizon. This is said of an agent (p. 14) and repeated for an individual in a forest, who may store extra food in times of abundance (p. 15).
  - The next sentence glosses this: EFE-minimizing trajectories are "expected to be sustainable" over the planning horizon, given the agent's generative model (p. 15).
- **Definite or aspiration.** Worded as a guarantee. The authors' own gloss reduces it to an expectation under the model. §4.4 (p. 16) concedes that an individual's EFE-optimal policy need not benefit the collective.
- **Forbidding laws.**
  - [The rest outruns the renewal](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-the-rest-outruns-the-renewal) (`Flow.outrun_below`, `Flow.outrun_ends`, `Flow.outrun_reading_alike`). Suppose the other takers alone draw more than a step gives, at each of n steps, from a level below n + m. Then every formation depending on the condition at a need of at least m ends, whatever the member takes, and no score reading the condition from then on selects the member's restraint.
  - [Joint excess](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess) (`Pair.own_not_joint`, `Flow.joint_excess_ends`). The paper's own example, every individual storing extra food in abundance, is the case where each draw is within what a step gives and the joint draw is not.
  - For a need that couples in by threshold only: [T6's invisible half](../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming) (`Web.break_not_bounded`, `Flow.policy_uses_after_failure`).
- **Hypotheses.** The World premises: balance, activity needing support and only active giving. The gate, so that the renewal depends on what it renews. The rest listed without repetition. The individual's need lies on a condition that others draw too.
- **Are the paper's systems within the hypotheses?** The paper is conceptual. Its forest with other foragers is within them, and it addresses sustainability "both as an agent and as a part of a collective" (abstract).
- **Grade: (b).** Read as a guarantee, the claim is forbidden. Read as the authors' gloss, an expectation under the agent's model, it is not. Known: Lloyd (1833) and Hardin (1968), as [the record](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess) says.

### 3. Shared models and preferences make each agent's goal the group's (b)

- **Sources.**
  - Friston, Ramstead, Kiefer, Tschantz and others, "Designing ecosystems of intelligence from first principles", arXiv:2212.01354v2 (2024), *Collective Intelligence* 3(1), §3.4 ¶2 (PDF p. 13).
  - Da Costa, Gavenčiak, Hyland, Samiei, Dragos-Manta, Pattisapu, Razi and Friston, "Possible principles for aligned structure learning agents", arXiv:2410.00258v3 (2025), §5.4 ¶3.
- **Claim.**
  - The ecosystems paper says that on the active-inference account "shared goals emerge from shared narratives", which shared generative models provide.
  - Da Costa and others say that numerical studies suggest populations may converge to free-energy equilibria where all agents share one generative model and one set of preferences. "In this case, each agent's goal is the group's (shared) goal."
- **Definite or aspiration.** The convergence is hedged ("suggest", "may"). The identity of goals is stated outright, given the case.
- **Forbidding laws.**
  - Joint excess (`Pair.own_not_joint`, `Flow.joint_excess_ends`).
  - [Several optimizers](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-several-optimizers-drain-by-their-joint-capacity) (`Optimum.MutualBest.full`, `Optimum.mutual_beyond`): restraint is no mutual best response.
  - [Re-optimizing above a renewal](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-re-optimizing-above-a-renewal-ends-it) (`Web.mutual_course_lost`).
  - The NOTE's reading 4: sharing a model pools nothing.
- **Hypotheses.**
  - Preferences are indexical, over each agent's own outcomes. Active-inference priors over an agent's own observations are.
  - The preferences rise with the agent's own draw on a shared condition whose renewal is gated.
  - The joint draw exceeds the renewal while each draw is within what a step gives.
  - Then each agent pursues or attains the goal it shares in form, while the condition every member depends on ends. The goals are alike, not one.
- **Are the paper's systems within the hypotheses?** The studies Da Costa and others cite (Isomura, Parr and Friston 2019; federated inference, candidate 6) have no shared draw, so they are outside. The general statement is within.
- **Grade: (b).** Forbidden under the natural reading, in which identical indexical preferences make individual and group goals coincide. Not forbidden if shared preferences means preferences over joint outcomes. Known: the tragedy of the commons is exactly the case of identical self-regarding preferences.

### 4. Communication ensures that two agents come to share one model (b; synchrony c)

- **Sources.** Read in full:
  - Friston and Frith, "A duet for one", *Consciousness and Cognition* 36 (2015) 390–405, §3, §4.
  - Its companion, Friston and Frith, "Active inference, communication and hermeneutics", *Cortex* 68 (2015) 129–143, §1, §5.
- **Claim.**
  - Communication induces perceptual learning, "ensuring that both agents come to share the same model". This is said to be almost self-evident, because predictability is assured if both converge on one model (duet §4 ¶2).
  - Generalized synchrony is an inevitable, emergent property of coupling two systems that try to predict each other (§4 ¶5–7).
- **Definite or aspiration.** Definite.
- **Forbidding law.** [A code formed between formations](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations) (`SharedCodes.agrees_only_fixed`, `SharedCodes.never_agrees_of_both`). Take a start symmetric under exchanging the agents together with a renaming. A law keeping both brings the exchanged agents to agree only on what the renaming fixes, and never where it moves every form.
- **Hypotheses.**
  - The joint learning law is deterministic.
  - It commutes with exchanging the two agents together with a renaming of forms, for instance the labels of the song's outputs.
  - At the start, one agent's model is the renamed other's.
- **Are the papers' systems within the hypotheses?** No.
  - The duet gives both birds the same model; the paper says that was the only reason its simulations worked (§4 ¶1).
  - The hermeneutics simulation starts from a difference in one scalar parameter, which no renaming exchanges, and converges.
  - Random initial conditions also break symmetry.
- **Grade.**
  - (b) for "ensuring that both agents come to share the same model", read as general: symmetric dyads come to share only a model the renaming fixes.
  - (c) for generalized synchrony. A mirror relation kept by the symmetry, one agent's state the reflection of the other's, is itself a generalized synchrony. Identical synchrony from a mirror-symmetric start is what the law forbids.

### 5. Any dyad or ensemble comes to share a generative model (b)

- **Source.** "Designing ecosystems of intelligence", §4.1 ¶3 (PDF p. 16).
- **Claim.** "Any dyad or ensemble of self-evidencing agents will come to share" a generative model through their interactions, "or at least some factors of" one. It cites Sakthivadivel 2022 (weak Markov blankets) and, as illustration, the duet (candidate 4) and Isomura and others 2019.
- **Definite or aspiration.** Definite, but softened by the parenthesis.
- **Forbidding law.** As in candidate 4. 05 §9 adds a witness: on a path a – c – b, each following the least-indexed of itself and its neighbours, a and b never agree, so being joined through couplings is not enough.
- **Are the paper's systems within the hypotheses?** The paper describes no system of its own. The study it cites presupposes a shared model. The paper's footnote 7 cites echo chambers (Albarracin and others 2022), ensembles that do not converge.
- **Grade: (b) on the natural reading; (c) on the literal one.** On the natural reading, a common code or ground, symmetric dyads under a deterministic law that keeps the symmetry never come to share it. Taken literally with its hedge, the claim is (c): such dyads can still share a renaming-fixed factor, an imprecise mapping.

### 6. Language as an emergent property of free-energy minimization (b)

- **Source.** Friston, Parr, Heins, Constant, Friedman, Isomura, Fields, Verbelen, Ramstead, Clippinger and Frith, "Federated inference and belief sharing", *Neurosci. Biobehav. Rev.* 156 (2024) 105500. Read in full: abstract; §1 ¶8; §3.1 ¶7; §5 ¶1; §5.1 ¶6.
- **Claim.** The abstract: "language is an emergent property of free energy minimisation" when agents share an econiche. §1 ¶8 asks whether free-energy-minimizing processes suffice for de novo emergence.
- **Forbidding law.** As in candidate 4. Free-energy minimization is unchanged by permuting word labels. So from a symmetric start, under a deterministic law that treats agents and words alike, exchanged agents agree only on renaming-fixed, imprecise mappings, never on a shared precise language.
- **Are the paper's systems within the hypotheses?** No. The simulation starts each Dirichlet parameter at one plus an unsigned random Gaussian variate (§5 ¶1), an asymmetric start, so its success agrees with the law. Agents exchange sufficient statistics rather than samples (§3.1 ¶7), so without the random start the scheme could be deterministic.
- **Grade.** (b) for the universal reading of the abstract's sentence. (c) for the simulation, and for §5.1's guarantee of precise mappings, which concerns each agent separately.

### 7. Information-seeking gives inherent self-correction (b, weak)

- **Source.** Wen, "A framework for inherently safer AGI through language-mediated active inference", arXiv:2508.05766 (2025). Read in full: §2, §4–§6.
- **Claim.** Exploration driven by expected information gain gives "inherent self-verification and self-correction" (§2 ¶3). Active inference gives stronger theoretical guarantees than constitutional AI (§5 ¶2).
- **Forbidding law.** [Generalization through lumping](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-generalization-through-lumping) (`Learning.determines_lumped_iff`, `Learning.every_determines_nothing`). Data fix a value only where an observed input is lumped with it, so information gain within a model's lumping cannot correct an error that the lumping does not separate. Chapter 03 also states, among what it does not show, that a system's correcting itself certifies its calibration.
- **Are the paper's systems within the hypotheses?** The paper is a proposal with no implementation. Its structure learning (spawning specialist agents) changes the lumping only through what couples in.
- **Grade: (b), weak.** The claim is vague, in a single-author proposal whose §4 ¶16 concedes that its predictions are hypothetical.

### 8. Alignment of local and global optima emerges endogenously (d)

- **Source.** Kaufmann, Gupta and Taylor, "An active inference model of collective intelligence", *Entropy* 23 (2021) 830. Read in full.
- **Claim.**
  - The abstract: "Alignment emerges endogenously" among interacting agents, without exogenous incentives or top-down priors. §4 ¶1 repeats it, as bottom-up with no exogenous constraints.
  - Yet §2.10 ¶5 assigns the shared goals exogenously, and §2.13 sets the Goal Alignment parameter to 1 for the modelled condition. That is an internal tension in the paper.
- **Forbidding law.** None reaches the model.
  - The model has no shared draw: two agents in independent copies of an environment, and a system-level free energy defined by the modellers.
  - Under a general reading, that interacting active-inference agents' optima align endogenously, joint excess would forbid it for indexical preferences on a shared gated condition. The paper does not make that reading.
- **Grade: (d)** as stated.

### 9. Ecosystems: vicarious access, a broader evidence base, fish that sense gradients (c)

- **Source.** "Designing ecosystems of intelligence": §4.2 ¶2 (p. 17), §3.3.1 ¶5 (p. 11), §2 ¶3 (p. 5).
- **Claim.**
  - In a factor graph split into agents, any agent can in principle see every observable vicariously, "as seen through the eyes of another agent".
  - Belief sharing broadens each agent's evidence base.
  - A school of fish senses light gradients that no individual, sensing only local intensity, detects (Berdahl and others 2013).
- **Law.** [Pooled coupling](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-pooled-coupling-reaches) (`Web.separates_all_iff_member`, `Flow.act_unselected_pool`; `ChoiceCountCapture.pooled_selectsThrough`, `pooled_unchosen_beyond`). A selection through the pool separates two histories exactly where some member does. Differences beyond the union of the members' closures stay unselected.
- **Grade: (c).**
  - The qualifier bounds the vicarious-access claim by the union, the bound the pool law proves, and the law also shows that some selection reaches it.
  - The gradient is pairwise within the union. Two light fields that differ differ at some fish, even though only the pool determines the gradient.

### 10. Federated inference: a consensus more precise than any member's (c)

- **Source.** "Federated inference and belief sharing": §1 ¶1, §3.1 ¶2, §3.2, §6.7 ¶2.
- **Claim.**
  - A shared belief more precise than any individual's could emerge.
  - The scheme ensures that agents come to share posteriors minimizing the joint free energy.
  - The third agent infers the subject's place from what the first says.
  - Shared models are richer and more accurate than any individual model.
- **Grade: (c).** Each claim stays within the union; in §3.2, the first agent couples to the subject.

### 11. What the flock knows that the birds do not (c)

- **Source.** Maisto, Nuzzi and Pezzulo, "What the flock knows that the birds do not: exploring the emergence of joint agency in multi-agent active inference", arXiv:2511.10835v2 (2026). Main text read in full.
- **Claim.**
  - Pairs of birds carry synergistic information about the predator's quadrant, "not accessible to every individual bird" (abstract, §4).
  - Collectives extend the reach of perception beyond any single agent (§5 ¶6).
- **Law.** The pool law is pairwise.
  - Synergy is information about a function that only a pair determines (XOR-like). It is compatible with every pair of histories the pool separates being separated by some member.
  - The predator couples into the birds that sense it.
- **Grade: (c).** The title comes nearest, in the literature, to the statement the pool law forbids, but the content stays within the union.

### 12. A multi-target horizon "finesses" unforeseeable events (c)

- **Source.** Da Costa and others (2025), §5.3, under "The First Law of Robotics".
- **Claim.**
  - An empathetic agent's horizon for another's well-being is its estimate of that other's own horizon. Protecting the other from events it cannot foresee would need more.
  - "This problem is finessed in multi-agent systems", because the planning horizon becomes the supremum of the targets' horizons.
- **Law.** The pool law in time.
  - The supremum is the union of the targets' reaches.
  - Events beyond every target's horizon or coupling stay unselected (`Flow.act_unselected_pool`; [07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-alignment-approaches-under-the-selection-laws), `Flow.unselected_beyond_pool`).
- **Grade: (c).** The mechanism the paper gives, the supremum, is the bound the law proves. The paper leaves the residual unstated, and the law supplies it. In this literature "finesse" often means "solve"; read as solved, the claim would be (b).

### 13. Collective information transfer in surprise-minimizing groups (c)

- **Source.** Heins, Millidge, da Costa, Mann, Friston and Couzin, "Collective behavior from surprise minimization", *PNAS* 121 (2024) e2320239121. Read in full: "Collective Information Transfer", "Online Plasticity", Discussion; the rest scanned.
- **Claim.** Informed agents lead uninformed ones to a target. With plasticity, groups respond more strongly to a perturbation of single agents.
- **Grade: (c).** What the group responds to couples into some member.

### 14. A single agent learns sustainable consumption (c)

- **Source.** Albarracin, Hipólito, Raffa and Kinghorn, "Modeling sustainable resource management using active inference", arXiv:2406.07593 (2024). Read in full.
- **Claim.** An agent whose eating depletes a stock learns to alternate and survives, which the paper says shows that active inference can give rise to sustainable behaviour.
- **Law.**
  - The outrun law and joint excess concern several takers.
  - A single taker that reads the stock can restrain. In 05 §1's witness, one taker alone does not end its renewer.
- **Grade: (c).** The Discussion confines the claim to one agent and one resource, and leaves shared resources and permanent depletion to future work.

### 15. Self-evidencing and persistence (d)

- **Sources.**
  - "Designing ecosystems of intelligence": §3.1 ¶2–3 (p. 7) and §3.3.2 ¶2 (p. 12).
  - Friston, "Life as we know it", *J. R. Soc. Interface* 10 (2013) 20130475, scanned.
  - Kirchhoff, Parr, Palacios, Friston and Kiverstein, "The Markov blankets of life", *J. R. Soc. Interface* 15 (2018) 20170792, scanned.
- **Claim.**
  - A boundary can persist only to the extent that its conditions are predicted and controlled.
  - From this perspective, model evidence is the only thing that needs optimizing.
  - An agent ought to generate observations consistent with its characteristic exchanges, and thus with its continued existence.
  - Any system that exists will appear to minimize free energy, and self-organization is (almost) inevitable given a blanket (2013).
  - Minimizing free energy over time bounds entropy (2018).
- **Laws considered.** Selection through couplings ([03](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-through-couplings)); T6's invisible half; closed capture (a lock outlives a loss it does not read); the premise card's row on requirements.
- **Grade: (d).**
  - The FEP's preferences are read off a thing that persists, its characteristic states.
  - "Consistent with continued existence" asserts compatibility, not sufficiency.
  - "Only to the extent ... predicted" is a necessity claim in the FEP's as-if sense; footnote 4 has a rock "know" its environment.
  - The entropy bounds concern sensory states.
  - None states, in terms the theory's laws contradict, that self-evidencing suffices for persistence.

### 16. Shared protentions (d; §5.4 c)

- **Source.** Albarracin, Pitliya, St Clere Smithe, Friedman, Friston and Ramstead, "Shared protentions in multi-agent active inference", *Entropy* 26 (2024) 303. Read in full.
- **Claim.**
  - Shared protentions are an emergent, and possibly necessary, property of any collective scale of self-organization (§1 ¶2).
  - Shared protentions might give a comprehension that surpasses individual viewpoints (§2.2 ¶7).
  - Nothing in the formalism makes agents' beliefs compatible (§5.4 ¶1).
  - Sheaf tools overcome disagreement, and it is usually possible to get as close to a sheaf as possible (§5.4 ¶9).
  - The paper has no testable model yet (§6).
- **Grade.**
  - (d) for §1: its terms are not fixed enough to compare.
  - (c) for §2.2 and §5.4: they are hedged. Under the shared-code law, consensus dynamics that keep a symmetric disagreement on discrete forms reach only renaming-fixed states (in a continuous space, the midpoint). That is consistent with "as close as possible".

## What the literature already states

These are not candidates. They close the pool and capture routes from inside the literature.

- **Individual and group minima.**
  - Federated inference §6.6 ¶2–3: individuals' fixed points may not coincide with the group's, and how to minimize collective free energy is open.
  - "Sustainability under Active Inference" §4.4: an individual's EFE-optimal policy need not benefit the collective.
  - Ruiz-Serra, Sweeney and Harré (AAMAS 2025), seen only in a search summary: the ensemble-level expected free energy is not necessarily minimized at the aggregate.
- **Fragility.** Heins, Klein, Demekas, Aguilera and Buckley 2022 (abstract): the equivalence between individual and collective inference is very fragile.
- **Belief sharing that fails.**
  - Catal and others 2024 (abstract): naive sharing of posteriors gives echo chambers and self-doubt.
  - Albarracin, Demekas, Ramstead and Heins 2022 (abstract and outline): self-confirming beliefs and echo chambers, the lock UE1 restates.
- **Limits stated outright.**
  - Palacios and others 2020: not every free-energy-minimizing ensemble self-organizes hierarchically.
  - Da Costa and others §5.2 ¶7: empathy alone does not guarantee benevolence.
  - "Designing ecosystems" §5 ¶3, ¶5: pathologies of alignment, and bias that the approach does not obviate.
  - Shared protentions §5.4 ¶1, as above.

## Searched and not found

- **A collective that separates what no member couples to.** No statement says that belief sharing, federated inference, a shared generative model or a collective Markov blanket lets a group respond to, or separate, what no member couples to. Every collective-knowledge statement stays within the union, including the synergy claims.
- **A collective guarantee.** No statement says that free-energy minimization or self-evidencing by several agents guarantees a shared resource or avoids collapse. Texts at the collective level say the opposite (above). The guarantees found are at the individual level (candidate 2) or an identity of goals (candidate 3).
- **Alignment by construction.** No paper claims that active-inference agents are aligned by construction. The texts on alignment are a roadmap (Da Costa and others), an aspiration ("Designing ecosystems" §5 ¶6) or a proposal (Wen).
- **Breaks foreseen.** No statement says that a self-evidencing agent foresees any break of what it depends on (T6). The statements about persistence are necessity or as-if claims (candidate 15).
- **A simulated commons.** No multi-agent commons simulated with active-inference agents was found; there is only single-agent depletion (candidate 14). The game-theoretic studies were seen only as abstracts or search summaries:
  - Demekas, Heins and Klein (IWAI 2023), the iterated prisoner's dilemma;
  - Hyland and others (ICML workshop 2024), free-energy equilibria;
  - Ruiz-Serra and others (AAMAS 2025).

  They report, rather than deny, that individual and collective optima come apart.
- **Could not be read.**
  - Rubin, Parr, Da Costa and Friston, "Future climates: Markov blankets and active inference in the biosphere", *J. R. Soc. Interface* 17 (2020) 20200503. The publisher's page answers with a browser challenge, which was not bypassed, and Europe PMC has no full text. Read at abstract level only: it formalizes the Gaia hypothesis as planetary free-energy minimization with the steady state presupposed, and states nothing comparable.
  - Veissière and others 2020 ("Thinking through other minds") and Isomura, Parr and Friston 2019: abstracts only.
  - MDPI refused access to "Sustainability under Active Inference". The authors' repository copy was read instead.
- **Queries.** Web searches covered:
  - the papers named above;
  - active inference with "tragedy of the commons", "common-pool resource" or "resource depletion";
  - "free energy principle" with "alignment problem", "AI safety" or "sustainability", "planetary" or "Anthropocene";
  - collective intelligence with phrases on what no single agent can perceive;
  - multi-agent active inference with shared resources and foraging.

## Sources read

**Full text.** All sections of each paper were read unless listed as scanned; a scanned text was searched by keyword and the hits read in context.

- Friston, Ramstead, Kiefer, Tschantz and others, "Designing ecosystems of intelligence from first principles", [arXiv:2212.01354v2](https://arxiv.org/abs/2212.01354) (HTML and PDF), CC BY 4.0.
- Friston, Levin, Sengupta and Pezzulo 2015, [Europe PMC PMC4387527](https://europepmc.org/article/PMC/PMC4387527), CC BY 4.0.
- Friston and Frith, "A duet for one" 2015, PMC4553904, CC BY 3.0.
- Friston and Frith, "Active inference, communication and hermeneutics" 2015, PMC4502445: §1 and §5 read, the rest scanned.
- Friston and others, "Federated inference and belief sharing" 2024, PMC11139662, CC BY 4.0.
- Kaufmann, Gupta and Taylor 2021, PMC8306784, CC BY 4.0.
- Albarracin and others, "Shared protentions" 2024, PMC11049075, CC BY 4.0.
- Heins and others, "Collective behavior from surprise minimization" 2024, PMC11046639.
- Albarracin, Ramstead and others, "Sustainability under Active Inference" 2024, from the [Sussex repository deposit](https://sussex.figshare.com/articles/journal_contribution/Sustainability_under_Active_Inference/28749254) (systems-12-00163-v3.pdf), CC BY 4.0.
- Albarracin, Hipólito, Raffa and Kinghorn 2024, [arXiv:2406.07593](https://arxiv.org/abs/2406.07593), CC BY-SA 4.0.
- Da Costa and others 2025, [arXiv:2410.00258v3](https://arxiv.org/abs/2410.00258): §1, §5 and §6 read.
- Maisto, Nuzzi and Pezzulo 2026, [arXiv:2511.10835v2](https://arxiv.org/abs/2511.10835), CC BY-NC-SA 4.0.
- Wen 2025, [arXiv:2508.05766](https://arxiv.org/abs/2508.05766), CC BY-NC-SA 4.0: §2 and §4–§6 read.
- Scanned:
  - Friston, "Life as we know it" 2013 (PMC3730701);
  - Kirchhoff and others 2018 (PMC5805980);
  - Palacios and others 2020 (PMC7284313; Discussion read);
  - Vasil and others, "A world unto itself" 2020 (PMC7109408);
  - Constant and others, "Regimes of expectations" 2019 (PMC6452780; no hits);
  - Bruineberg and others, niche construction 2018 (PMC6117456).

**Abstract only, or abstract and outline.**

- Albarracin, Demekas, Ramstead and Heins, "Epistemic communities under active inference" 2022 (PMC9027706).
- Heins, Klein, Demekas, Aguilera and Buckley 2022, [arXiv:2207.06970](https://arxiv.org/abs/2207.06970).
- Catal and others 2024, [arXiv:2407.02465](https://arxiv.org/abs/2407.02465).
- Rubin and others 2020, "Future climates" (Europe PMC abstract).
- Veissière and others 2020.
- Isomura, Parr and Friston 2019.
- Friston, Parr, Yufik, Sajid, Price and Holmes, "Generative models, linguistic communication and active inference" 2020.

**Search summaries only, not read.** Demekas, Heins and Klein 2023; Hyland and others 2024; Ruiz-Serra, Sweeney and Harré 2025; "Resurrecting Gaia" (*Frontiers in Psychology* 2023).

**From prior knowledge, not re-read.** Curie 1894; Turing, "The chemical basis of morphogenesis" (1952); Angluin, "Local and global properties in networks of processors" (1980); Lloyd 1833; Hardin 1968; Berdahl and others, *Science* 2013 (cited by "Designing ecosystems").

## For UE1

- **Its own laws.** Selection through couplings, its pooled form, capture through the rule and closed capture forbid nothing found.
  - The statement the pool law forbids does not occur in this literature, which bounds its collective claims by the members' perspectives.
  - The capture results restate locks the literature reports itself.
- **Other laws.** Statements graded (b) exist under three families of other laws, and each fails only in cases that the papers' own simulations avoid.
  - The symmetry laws: 01's commuting law and 05 §9 (candidates 1, 4, 5 and 6).
  - Joint excess and the outrun law, 05 §1 and §7 (candidates 2 and 3).
  - Lumping, 03 (candidate 7).
- **Fit with the audit.** The joint-excess candidates fit the pattern the [UE0 audit](../ue0-third-parts/AUDIT.md) accepted: a framework without a renewal law (the premise card's row 6, [NOTE](NOTE.md) §3) joined to a law of the theory. Like the audit's third parts, they are known in a neighbouring field.
- **Recommendation.** Keep UE1 recorded as "restatement; third part open" on its own laws. If a third part is claimed, widen the containment to cite the law used, state its hypotheses, and label it known.
  - The cleanest choices are candidate 1 (an explicit guarantee under the paper's own hypotheses) and candidate 3 (alike preferences are not one goal; closest to AJ).
  - A frozen check of candidate 1 is cheap: run the paper's scheme from exactly identical initial expectations, with no noise. The predicted outcome is no differentiation. It would confirm the law in the paper's own code, not refute the FEP.

## Correction after UE25 (31 October 2026)

AI-written. UE25 states the forbidding law of candidates 4–6 for beliefs held as counts, in the pure core ([a code held as counts](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-code-held-as-counts), `Becoming.CountedCodes`), after an independent review and its recheck ([REVIEW-UE25](../ue25-communicating-agents/REVIEW-UE25.md), [RECHECK-UE25](../ue25-communicating-agents/RECHECK-UE25.md)). Three points above change; the candidates stand as written on 25 October.

- **Candidate 6, the scheme.** "Agents exchange sufficient statistics rather than samples (§3.1 ¶7)" is imprecise. In federated inference agents share posterior predictive beliefs over latent states (§3.1, Eqs. 6–8), and each learns its likelihood's Dirichlet counts privately, adding the outer product of the outcome and its posterior over states (Eq. 9), weighted by the probability of the policy to update (Eqs. 10–11), with forgetting (Eq. 12). [AI reading, D45] With the hearer given the meaning, the learning step adds the speaker's normalized predictive at the meaning, a rule of the kind `CountedCodes.hear_keeps` covers; the weighting reads the whole model, of the kind `CountedCodes.gatedHear_keeps` covers in natural weights; so the law is read as keeping the relation `CountedCodes.never_shared` needs, for a renaming the same for every meaning. That is a reading, not a theorem.
- **Candidate 6, the premise.** "Free-energy minimization is unchanged by permuting word labels" is now proved in counting form: over a listing a renaming permutes, a count belief reaches the free-energy bound exactly where its renaming does for the renamed weights (`CountedCodes.bound_invariant`), and under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a listing of every word has no uniquely greatest word (`CountedCodes.minimizer_no_unique_greatest`). The learning argument does not rest on it: it rests on the update keeping the symmetry (`CountedCodes.hear_keeps`, `CountedCodes.never_shared`).
- **Candidates 4 and 6, the scope.** The duet's birds have continuous states, no word counts and no simulated learning; the law for counts does not state them, and the principle's page does not count candidate 4. A rule of learning from what is heard that does not commute with the renaming, such as saying the first word of greatest count, can bring a shared word from a symmetric start (`CountedCodes.Witness.sayFirst_shared`), so grade (b) is for a deterministic scheme keeping the symmetry. Under sampled signals the law does not apply: reinforcement reaches a signalling system (Argiento, Pemantle, Skyrms and Volkov 2009).
