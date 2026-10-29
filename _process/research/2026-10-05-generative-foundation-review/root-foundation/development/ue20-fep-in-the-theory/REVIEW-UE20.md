# Review of UE20: the free-energy principle in the theory

29 October 2026. AI-written, independent, read-only review of `FREE-ENERGY-PRINCIPLE.draft.txt` (sha256 `c27c2639…b53067b`), which lands as `theories/becoming/FREE-ENERGY-PRINCIPLE.md`.

**What I read:**
- AGENTS.md;
- FEP-INTEGRATION and UE1's THIRD-PART-SEARCH;
- the eight records' JSON and their home sections;
- `ConditionalWeights`, `FreeEnergyGuarantees` and `FreeEnergyReals`;
- the NOTEs of UE16 and UE17;
- UE18's and UE19's NOTEs, modules and kit scripts.

**Checked on the web:** Friston, Levin, Sengupta and Pezzulo 2015 ("This is guaranteed"; small random initial expectations); Da Costa and others 2025, §5.4; Friston, Ramstead and others 2024, §3.4; Wen 2025, §2. Albarracin and others 2024 and Ramstead and others 2023 returned HTTP 403, so for them I rely on UE1's search and REVIEW-UE18 F6.

## Verdict

Revise the text before landing.

**What is fine as it stands:**
- All eleven backticked names exist in the modules named.
- Every link resolves, and UE18's and UE19's texts scripts write the four new anchors in 03 §1 and §6.
- Section numbers, attributions and years match the records.
- Every item of FEP-INTEGRATION §1 has a row.
- §3's laws keep their hypotheses, and the Readings of §3 and §4 are labelled.
- The page uses one language and no market words.

**What needs revision** lies in the summaries: readings stated as laws, a witness stated as a law, a free energy placed where the Lean says it can differ, two wrong sentences in §3's lead, and claims left unplaced.

## Findings

**F1 (S). In brief, first bullet: "Every quantity of the principle is stated."** §5 lists quantities of the principle that are not stated (precision, generalized coordinates, free energy over parameters). *Fix:* "**Each quantity and claim the plan lists is stated.**"

**F2 (S). Readings and correspondences without labels.** None of these carries a label:
- In brief: "the principle names the theory's laws" and "the blanket is the couplings" (UE18's labelled reading).
- In brief: the third bullet's last sentence, which is §4's Reading.
- §2, first bullet, third sentence: this is 03 §6's Reading, nearly word for word.
- §1's Surprisal bullet and the table's "stated, core": the reciprocal share only corresponds to surprisal. The conditioning record lists surprisal as a number among what it does not show.
- The existence row: "true by construction" is UE18's reading; the record says "near-definitional and conceded".
- Standing, last sentence: 08 §8 says "not yet farther".

*Fix:* label each "[AI reading, D45]" or move it into a Reading. Use "near-definitional" and "not yet farther".

**F3 (S). The blanket** (§2, second bullet; the table's "the same law"). "The principle's partition is the theory's selection through couplings" says more than UE18. The blanket is stated on a determined law, and the join to the World's couplings is proved for the witness only. Capture-by-counted-choices still says, in its does-not-show, that no representation theorem joins the partition to a web. *Replace:* "On a blanketed law, the deterministic case, a determined policy is a selection through the sensory course, and a reading through the blanket separates at most what the blanket tells apart; for the threshold witness the blanket is the World's coupling (03 §1). **Reading** [AI reading, D45]: the partition names the couplings."

**F4 (S). The habit** (§2, third bullet; In brief). The record says active inference's own scheme differs from the theory's rule:
- it counts the end-of-trial posterior;
- its prior is the counts' expected log;
- it has precision and sampling;
- "the threshold is the model's, not SPM's".

The bullet also drops two hypotheses: the rule in force must be read from the counts at the start (`Witness.Stale`), and there are two policies. *Replace:* "**The habit, read as a count** [AI reading, D45]. A rule over two policies read from the count of its choices, in force from the start under a standing score, never leaves the region its threshold sets and outlives an unread loss (02 §9); active inference's own habit (Friston and others 2016) is not stated."

**F5 (S). Risk** (In brief, "risk is an order by distance from a preferred level"; §2, fourth bullet). 05 §1 marks this "a correspondence, not a Lean law". It holds only for a point prediction under a preference falling alike on both sides of its mode.

"The set-point optimum's laws apply to it" is not proved. What is proved is that the held pair's takes are the chooser's least-risk choices (`heldPair_choices`).

*Replace:* "**Risk, for a point prediction.** The chooser's risk is the set point's distance on one condition, and in the held pair its choices are the holders' takes (05 §1, §7); that this is active inference's risk is a correspondence."

**F6 (S). The held pair is a witness** (§3 item 2; In brief). `held_not_one` is one constructed model. The labels line defines *witness* (and **Theorem**), but the body uses neither. *Fix:*
- Write "can end the renewal its holders share".
- Label the item *World; witness*, and §4's timing a witness as well.
- After "three … end it at once", add "while two continue: a goal over the shared level is no guarantee either" (05 §1).

**F7 (S). §4: "every reading of its internal course, a free energy of its belief among them, is alike up to the step the break registers."** This contradicts UE18's R1 and `sensory_apart_at_four`: at that step a free energy reads the record, which differs. The sentence also drops "no action changing the supply". *Replace:* "…reading its supply only by threshold, no action changing the supply, every reading of its internal course up to the step the break registers is alike, a free energy of its belief at any step before it among them, whatever its model and policy."

**F8 (E). §3 lead: "the papers' simulations … or choose experiments that separate, are not refuted."** Albarracin and others (2024) is conceptual and Wen (2025) has no implementation (UE1's search). The T-maze is not Wen's. *Replace:* "the 2015 paper's simulation, which broke the symmetry by random initial expectations, and the studies Da Costa and others cite, which have no shared draw, are not refuted; Albarracin and others and Wen report no simulation."

**F9 (E). §3 lead: "Each would be refuted by a model meeting its hypotheses on which the forbidden outcome fails."** The case it describes agrees with the law, and a proved law has no counter-model. What can fail is the reading. *Replace*, from UE16 §5 and UE19 §4: "Each reading fails where the papers' systems leave its hypotheses. If the 2015 scheme differentiated from identical expectations with no noise, its descent would read a cell's number. Agents without a shared gated renewal, or with preferences over the joint outcome, escape the second and third. If seeking separated a pair every experiment ties, a likelihood would differ somewhere."

**F10 (S). Standing.** "The third parts, which place each claim of the principle where it holds and where it fails" overclaims: they place four statements of its literature, two of them weak. "Identification in a seeking form" is not a join. The blanket's new part is "the agent form" (UE18's 08 bullet).

The In brief's "Beyond them" items are near-definitional and forbid no sentence of the literature, and the page should say so. *Fix:* "…and in the third parts, which place four statements of its literature, read as guarantees, where they fail; new also are the seeking form and expected free energy read through the lumping."

**F11 (I). Claims left unplaced.** FEP-INTEGRATION §2 names seven (b) statements. The page is silent on candidates 4 to 6 (Friston and Frith 2015; "Designing ecosystems" §4.1; "Federated inference" 2024), which fall under the landed shared-code law (05 §9). *Add* to §3: "UE1's search grades three more statements (b) under the shared-code law (05 §9), that communicating agents come to share one model or language; none is stated in the principle's terms, so they are not counted here." *Add* to §2 that the literature's collective-knowledge claims stay within the pooled couplings (05 §8; graded (c)).

**F12 (I). §5 is fair but incomplete.** Add to its last bullet:
- the threshold-reading policy unable to draw on a larger supply (UE18);
- the habit as SPM states it;
- when a reading of the joint outcome keeps a collective going;
- complexity and accuracy from the core's own shares (UE17).

Add noise and random dynamical systems to the first bullet. Under them the identical-cells law does not apply.

**F13 (I). §1 drops hypotheses.**
- Expected free energy: write "the product of the states' weights and the predicted outcomes (the joint's marginals where each likelihood totals one)". The divergence and gain forms need nonnegative weights, and the definition takes one step and one policy.
- Free energy: complexity less accuracy needs the joint weight to be a prior times a likelihood.

**F14 (I). Citations.** Give the agreements their records' sources (free energy: Friston 2005, 2010; expected free energy: Parr and Friston 2019; blanket: Friston 2013, Virgo, Rosas and Biehl 2022; habit: Friston and others 2016), and Angluin 1980 for §3 item 1's uniqueness clause. In the third-part row, cite each paper for its own sentence. Da Costa and others (§5.4) say each agent's goal is the group's. Friston, Ramstead and others (§3.4) say shared goals emerge from shared narratives, which shared generative models provide.
