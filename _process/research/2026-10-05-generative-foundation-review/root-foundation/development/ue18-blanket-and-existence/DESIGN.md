# UE18: the Markov blanket as a coupling structure, and what the existence claim forbids

29 October 2026. AI-written design for board item UE18, item 3 of the plan for the free-energy principle as an integral part of the theory ([FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md)). It says what the Lean will state, which landed laws it instances, what is new, and what it will not show. Drafting starts after the claim reaches the board.

## 1. What the principle states

- **The blanket.** A system's states are partitioned into internal, sensory, active and external states; sensory states are not influenced by internal ones and active states not by external ones, so internal and external states are conditionally independent given the blanket (sensory and active) (Pearl 1988, for the blanket of a node; Friston 2013, *Life as we know it*; Kirchhoff, Parr, Palacios, Friston and Kiverstein 2018).
- **The existence claim.** Whatever exists, with a blanket and a nonequilibrium steady state, will appear to minimize free energy: its internal states can be read as parameterizing a belief about external states, and its flow as a descent on a free energy of that belief (Friston 2013; Friston 2019, *A free energy principle for a particular physics*). The principle is offered as a principle, not as a falsifiable hypothesis (Andrews 2021 discusses this).
- **Critiques it meets.** Dynamical sparse coupling and statistical conditional independence at steady state come apart outside special cases (Biehl, Pollock and Kanai 2021; Aguilera, Millidge, Tschantz and Buckley 2022); blankets as statistical tools are read as boundaries of things (Bruineberg, Dołęga, Dewhurst and Baltieri 2022; Raja, Valluri, Baggs, Chemero and Anderson 2021).

UE1's search graded the persistence statements (d): they are necessity or as-if claims, and none says that self-evidencing suffices for persistence ([search](../ue1-fep-bridge/THIRD-PART-SEARCH.md), candidate 15). So UE18 does not forbid a sentence of the literature. It states the blanket in the theory, shows what the existence claim forbids alone (nothing), and states, as laws the principle does not have, what persistence needs beyond self-evidencing.

## 2. The module `Becoming.Blanket` (pure core)

Imports `Becoming.ConditionalWeights` and `Becoming.Runaway` (both landed); a leaf at L1 if its imports are. Names to settle at claim time in the core's vocabulary (board rule 8).

**Law 1. The blanket is a coupling structure** (any types; a determined law on four parts).
- `Blanket I S A E`: four maps, the internal part's next state from (internal, sensory, active), the sensory part's from (sensory, active, external), the active part's from (internal, sensory, active), the external part's from (sensory, active, external); its step on `I × S × A × E`.
- `internal_through_blanket`: two runs from starts with one internal state whose sensory and active parts agree at every step before `n` have one internal state at every step up to `n`; `external_through_blanket`, the same for the external part. This is the dynamical form of conditional independence given the blanket: each side's course is a function of its start and the blanket's course.
- `selects_through_blanket`: so every reading of the internal course up to `n`, a free energy of any belief the internal states parameterize among them, is a selection through the blanket's course in 03 §1's sense: two histories alike through the blanket are read alike.
- A witness that the blanket condition is sparse coupling, not independence of the courses: internal and external courses that differ together because the blanket's course differs.

**Law 2. Self-evidencing does not see its own break** (World; the premises of `Web.break_not_bounded` and `Flow.policy_uses_after_failure`). Read a formation's couplings as its sensory states and its exchange as its active states: a policy through its couplings (`Flow.PolicyThrough`) is any active-state map of what couples in, active inference's among them, whatever its model. Then, for a supply coupled into the formation by threshold only, before the break some world with as much more supply as one likes is alike through the formation's couplings at every supported step (`Web.break_not_bounded`), and such a policy uses a difference in the supply only after a failure (`Flow.policy_uses_after_failure`). So no free energy of the sensory records, under any generative model, tells the world in which the formation's break comes from one in which it does not, before it comes. Applications in the principle's terms, with the blanket reading stated; what does tell them apart is the supply coupled in by level, a model of it, or another formation into which it couples (Runaway's readings), which is what persistence needs beyond self-evidencing.

**Law 3. The existence claim forbids nothing alone** (any type; natural weightings of listed courses).
- `every_course_least_surprise`: for every listed domain and every course in it, the weighting placing all weight on that course gives it the whole share, no less than any event's: the course is of least surprisal under it. So "appears to minimize surprisal under some model" holds of every course.
- `read_off_admits`: the weighting read off a run's own visits up to `n` gives every state the run visits a positive weight: a run "stays in states of positive density" under the density read off it, whatever the run does, ending included.
- `fixed_weighting_forbids`: under a weighting fixed before the course, some course of a domain with an unweighted member has share nothing. So the claim forbids a course only with a model fixed independently of the course.
- The laws that forbid hold under every weighting: UE16's (the commuting law on a symmetric descent, the outrun law, joint excess) forbid courses outright, with no model; stated in the text, not as a new theorem.

## 3. Placement and records

Two records, the claims being distinct:
- *The Markov blanket as a coupling structure* (Laws 1 and 2), homed in 03 §1 after selection through couplings' reading on the free-energy principle's agent.
- *What the existence claim forbids* (Law 3), homed in 03 §6 after free-energy-bounds-surprisal (UE17).
08 §8 gains one bullet; FEP-INTEGRATION, the UE plan and UE1's record are brought to the landing.

## 4. What UE18 will not show

- Continuous states, densities, the Helmholtz decomposition of a steady-state flow, or a nonequilibrium steady state: the principle's own construction stays outside the core.
- That statistical and dynamical blankets coincide, or that a thing has a unique blanket.
- That any actual system persists or ends; which supply couples in by level.
- That the principle is wrong: its persistence statements are necessity or as-if claims, and Law 2 forbids no sentence of its literature; it states what the principle leaves out.

## 5. Standing (expected)

Law 1 is near-definitional (Pearl's blanket in dynamical form). Law 2 applies landed laws (T6's invisible half) in the principle's terms. Law 3 is near-definitional, the counting form of the as-if reading's known emptiness (Andrews 2021; Bruineberg and others 2022, on the instrumentalist reading). New is placing them in one theory: the blanket as the coupling structure whose laws the theory already has, and the conditions of persistence the principle presupposes.
