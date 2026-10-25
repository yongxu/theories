# UE1: the free-energy principle as a case (note)

25 October 2026. AI-authored note for board item UE1, the first containment of [UE, a unified explanation of reality](../ue-unified-explanation/PLAN.md) ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-25-unified-explanation-of-reality.md)). It covers four things:

- the principle in its own terms, from the sources listed in §8;
- its premises set on the theory's premise card;
- what the Lean kit proves, and one published simulation it matches;
- where the bridge does not reach.

Results go to their records and home sections when they land, not here.

## 1. Why first

The free-energy principle is the most developed attempt to give one principle for every self-organizing system, from a cell to a brain. Its proponents now also offer it as the basis of collective intelligence of humans and AI. Containing it as a case is the sharpest available test of whether this theory reaches farther. The test can fail: the theory could turn out to restate the principle in other words, and a containment that forbids nothing would show exactly that.

## 2. The principle in its own terms

- **Its start.** Random dynamical systems with Langevin dynamics. States are partitioned into internal, external, sensory and active, by conditional independencies that sparse coupling gives; the sensory and active states form the Markov blanket. The classical formulations assume a nonequilibrium steady state. The path-integral formulation drops stationarity and keeps the partition.
- **Its step.** Under the partition, internal states are read as parameterizing beliefs about external states. Their flow is read as descent on variational free energy, an upper bound on surprisal. To persist is then to gather evidence for one's own model: *self-evidencing*.
- **Its process theory.** Discrete-state active inference:
  - a generative model;
  - perception and learning as belief updating;
  - policies scored by expected free energy, with the posterior over policies a softmax of the log prior over policies less the precision-weighted expected free energy;
  - a prior over policies counted from the policies selected, the habit (§4).
- **Its status.** Its proponents present the principle as a method of description rather than a claim that could be refuted, and its process theories as the part that makes predictions.
- **What its critics found.**
  - Biehl, Pollock and Kanai: definitions of the blanket differ between works and are not equivalent; rewriting the equations of motion under a blanket needs assumptions that are not stated; and the original free-energy lemma fails as stated, by counterexample. Where the lemma holds, the Bayesian reading rests on the variational density equalling the ergodic conditional density, which is not justified.
  - Aguilera, Millidge, Tschantz and Buckley: in weakly coupled linear stochastic systems the blanket condition and the bound on solenoidal flow hold only in a narrow range of parameters. Taking the dynamics of average states for the average of the dynamics fails in general.
  - Bruineberg, Dołęga, Dewhurst and Baltieri: the blanket as a statistical tool is conflated with the blanket as the boundary of a thing.

## 3. Its premises on the premise card

What each premise lets its framework state is the point of the table: a containment has to show what the contained framework can state and the theory cannot yet, and what the theory forbids that the framework leaves open.

| The principle's premise | The theory's counterpart | Standing in the theory | What each can state |
|---|---|---|---|
| a probability density over states, or a measure on paths | weights over courses in counting form, every weighting a premise (`Becoming.Weighted`), with Chebyshev's and Chernoff's bounds and the counting law of large numbers (`Becoming.Typicality`); no conditional updating, surprisal or density | the theory's debt (UE2) | the principle states belief, surprisal and free energy; the theory does not yet |
| a steady state, classically | none; recurrence and attraction over finitely many configurations, and the map of generation, keeping and degeneration ([02](../../../../../../theories/becoming/chapters/02-MAP.md)) | not assumed | the theory states beginnings and endings, which the principle's start leaves outside it |
| a given partition into thing and world, with its blanket | closures derived from the exchange, one per relation: feeding within influence, reach, coupling ([01](../../../../../../theories/becoming/chapters/01-ROOT.md#r-levels-of-closure)); selection through couplings, given that a selector reads just its couplings ([03](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-through-couplings)) | derived, several | the theory states that what feeds a pattern can lie beyond what informs it; a single blanket identifies the two |
| continuous state and time | discrete steps and whole amounts, their cost measured over the reals ([08](../../../../../../theories/becoming/chapters/08-METHOD.md#r-what-discrete-steps-and-whole-amounts-represent)) | commitment of the representation | the principle is quantitative in continuous time; the theory's dense forms are partial |
| preferences are the characteristic states (the steady-state density read as prior preference) | significance a free parameter no statement of the dynamics fixes; scope (the continuation condition) and order (C) two named premises, neither asserted ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)) | not assumed | a self-maintaining pattern that harms what feeds it, a tumour, is a successful self-evidencer; the theory names the premise it takes to count the harm, and what self-concern gives without one |
| no conservation of what passes between thing and world | balance, dissipation and activity needing support among the World premises | premises, named where used | the theory states renewal, margins and the commons: takers each within what is renewed ending it together ([05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)); the principle has no shared stock that several things draw on |
| none for requirements | requirement as threshold (`Web.requires`) | commitment | margins and points of no return ([02](../../../../../../theories/becoming/chapters/02-MAP.md#r-margin-of-a-regime)) |
| self-evidencing as what persisting is | capture through the rule: a rule read from the share it selects locks, and read from the share alone it outlives a loss it does not read ([02 §9](../../../../../../theories/becoming/chapters/02-MAP.md#r-closed-capture)) | proved under named hypotheses | the theory tells closed self-evidencing, a lock, from open, which a reading of the loss turns |
| the epistemic term of expected free energy | selection through a model of the options: what a lumping misses, no data supply ([03](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-generalization-through-lumping)) | proved | curiosity explores within the generative model's lumping, never beyond it |

## 4. What the kit proves

`Becoming.HabitCapture` ([kit tree](tree/Becoming/HabitCapture.lean)): the scratch build compiled 22 theorems in 29 declarations, every axiom report empty, against the pure core ([log](scratch.log)). It is a leaf, an instance module of two spine laws (board rule 9).

- **A chooser reading what couples in is a selection through its couplings.** Whatever the update and whatever the choice, the choice up to a step is a selection through the chooser's couplings (`selectsThrough`, by `Web.selectsThrough_iff_prefix`). So histories alike through them are chosen alike (`chosen_alike`), and a part acting only beyond the coupling closure does not change the choice (`unchosen_beyond_coupling`, by `Flow.unselected_beyond_coupling`). This part is near-definitional: the blanket condition already says as much. Its use is that every law about selections through couplings now applies to the principle's agents.
- **A prior counted from its own choices locks above a threshold.** The chooser takes the policy its rule weighs more and that policy's count rises (`choose`). The rule is the counts weighted by a standing score, `κc` and `κo` (`weighted`).
  - Choosing raises the share it reads, strictly (`choose_raises`, `choose_rises_strictly`), and the reading is monotone (`weighted_reads`).
  - From counts with `κo · other ≤ κc · carrier`, the chooser takes the first policy at every step along every schedule, and neither share nor rule falls (`habit_locks`, `habit_chooses`). This holds also where the score favours the second policy.
  - Below the threshold the chooser takes the second policy for good (`habit_locks_down`, with `choose_lowers` and `lower_strict`).
- **Counted from the posterior, it gives way.** Where the counts take the posterior in proportion (`soft`), a score favouring the second policy lowers the first policy's share strictly at every step, whatever the counts and the scale (`soft_falls`, `soft_course_falls`). The lock belongs to counting the choice, not to counting.
- **The lock outlives a loss it does not read** (`habit_outlives_loss`, by `ClosedCapture.lock_outlives_loss`).
- **Witnesses.** Three to one beats a score of one to two (`habit_beats_score`). From one to one, the score decides for good (`score_decides`). Counted from the posterior, the same three to one gives way at the first step (`soft_gives_way`).

**A published simulation with the same shape.** Friston, FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo (2016) simulate habit formation and devaluation in active inference (§5.2). In their scheme the vectors encoding the selected policy accumulate evidence by counting how often they occur (§2.4).

- Devalued at trial 48, after the habit has formed, "the habit persists and, indeed, reinforces itself with repeated executions".
- Devalued after 16 trials, before it has formed, the agent switches at once and later forms a habit matching its new preference.

`habit_locks` and `habit_locks_down` state that shape as a law with an exact, two-sided threshold: the outcome turns on whether the counts stand above `κo/κc` when the score changes.

The kit's model is simpler than the paper's. There the habit is a state-action policy whose transitions are learned; here the prior counts the chosen policies. So the correspondence is one of structure: reinforcement by execution is `Raises` together with `ReadsShare`.

What the law adds to the simulation:

1. the threshold, exactly and on both sides;
2. that only a change of the law, of the reading or of the selection leaves the lock (`RuleCapture.uniform_locks`, `perturbation_absorbed`), and that reading a loss is one sufficient way out (`ClosedCapture.turned_by_loss`);
3. that the lock outlives any loss its loop does not read;
4. that counting the posterior instead of the choice removes the lock against a standing score.

## 5. Readings [AI reading]

1. **The blanket is the boundary of one closure among several.** What feeds a pattern can lie beyond what couples into it. With one blanket the principle has no place for that gap, and 05's commons and the optimum's drain live in it.
2. **Closed self-evidencing is capture.** Gathering evidence for one's own model, with the model read from what it selects and nothing read beyond it, is the meta-attractor. Curiosity opens the loop only within the model's lumping.
3. **A chooser with set points escapes the optimizer's drain, not the commons.** Where preferences are characteristic states, there is a point of enough. The optimum's drain beyond its couplings needs an order rising with what couples in ([05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)), so it does not apply to such a chooser as such. Joint excess does: several such choosers, each within renewal, can end it together, and none sees this through its own couplings. On this reading the principle's agents drain through joint excess and through capture, not through maximization. A law for set-point orders is open item (b) below.
4. **Shared generative models pool couplings.** Sharing beliefs extends what a group tells apart to what some member tells apart, and no further ([05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-pooled-coupling-reaches)). So a collective of self-evidencers is blind beyond the union of its members' closures, its own acts included. And where the rest's draw outruns the renewal, no later reading selects restraint ([05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-the-rest-outruns-the-renewal)): coupling is necessary and not sufficient. This bears directly on the programme of designing ecosystems of intelligence from first principles.

## 6. Where the bridge does not reach

- No surprisal, free energy or expected free energy is stated. The score enters as two whole-number weights, the belief as any value.
- `selectsThrough` and its corollaries are near-definitional.
- The habit model counts choices. The 2016 model learns a state-action policy, and implementations often count the posterior, which is the case `soft` states.
- `choose` is the limit of high precision in selecting actions. Intermediate precision is not treated.
- That actual agents, brains or trained systems count their choices so is not shown.
- That the principle's partition is a coupling structure of the World model is a reading. No representation theorem joins a Langevin system with a blanket to a web.

## 7. Next

- (a) **Review and landing.** An independent review of the kit. Then records for habit capture and for a chooser reading what couples in, with home sections beside capture through the rule (02 §9) and selection through couplings (03 §1), and a row in 08 §8 for the correspondence with the 2016 simulation.
- (b) **Set-point orders and the optimum.** Where an order is greatest at a set point of what couples in, what an optimum does beyond its couplings, and where joint excess still ends the condition.
- (c) **A frozen test.** In a discrete active-inference agent with a counted policy prior, vary the devaluation trial and the score. Predict from the counts and the score, before running, which runs switch and which persist; with posterior counting, predict that none persists.
- (d) **UE2.** Conditional weights and surprisal on the counting layer the core has. A bound of leaving the region a continuation needs by its margin over its spread, from Typicality's Chebyshev form: a counting form of the surprisal of leaving the viable set.
- (e) **Pooling against shared generative models,** in Lean: belief sharing as an instance of `Becoming.SelectionPool`.

## 8. Sources

**Read this round, 25 October 2026.** Abstracts were read through a fetching tool. The 2016 paper's full text was fetched from Europe PMC's XML (PMC5167251), and its §2.4 and §5.2 sentences cited here were checked verbatim; its Eq. 7 is an image and was not read.

- Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr, "The free energy principle made simpler but not too simple", *Physics Reports* (2023), [arXiv:2201.06387](https://arxiv.org/abs/2201.06387).
- Biehl, Pollock and Kanai, "A technical critique of some parts of the free energy principle", *Entropy* 23 (2021), [arXiv:2001.06408](https://arxiv.org/abs/2001.06408).
- Aguilera, Millidge, Tschantz and Buckley, "How particular is the physics of the free energy principle?", *Physics of Life Reviews* 40 (2022), [arXiv:2105.11203](https://arxiv.org/abs/2105.11203).
- Friston, Ramstead, Kiefer, Tschantz and others, "Designing ecosystems of intelligence from first principles", *Collective Intelligence* 3(1) (2024), [arXiv:2212.01354](https://arxiv.org/abs/2212.01354).
- Friston, FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo, "Active inference and learning", *Neuroscience & Biobehavioral Reviews* 68 (2016) 862–879, [open access](https://openaccess.city.ac.uk/id/eprint/16681/).

**From prior knowledge, not re-read.**

- Bruineberg, Dołęga, Dewhurst and Baltieri, "The emperor's new Markov blankets", *Behavioral and Brain Sciences* 45 (2022).
- Friston, "A free energy principle for a particular physics" (2019).
- Friston and others, "Path integrals, particular kinds, and strange things", *Physics of Life Reviews* (2023).
- Da Costa and others, "Active inference on discrete state-spaces: a synthesis" (2020), read for an [earlier note](../../../history/root-foundation/COGNITION-MODEL-COMPARATORS.md).
