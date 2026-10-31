# UE25 recheck: round 2 of `Becoming.CountedCodes`, its note and its landing texts

31 October 2026. AI-written. This is the independent reviewer's recheck of round 2. [REVIEW-UE25](REVIEW-UE25.md) is unchanged, and nothing in the repository was edited.

**What was read.**
- The module, `kit/tree/Becoming/CountedCodes.lean`, byte-identical to `ue25build/Becoming/CountedCodes.lean`.
- `NOTE.md`.
- `texts-for-recheck.diff`.
- `kit/make_records_ue25.py`: LAWS, statement, hypotheses, does_not_show and correspondence.
- `kit/study_ue25.txt`.
- The summary sentences in `kit/land_ue25.sh` and `kit/board_ue25.py`.

Sentences were checked against the Lean signatures, not the docstrings. The papers' claims were checked against the full texts, fetched from Europe PMC and arXiv.

**Kinds.**
- **Must fix:** false as written. The module's own witnesses contradict it.
- **Overclaim:** says more than the theorems prove; a hypothesis is dropped.
- **Minor:** wording, a citation or a name.
- **Verified:** no action.

## The Lean (question 2)

### R1 (verified): the round-2 Lean is sound, and every new declaration is exact

My scratch build (`scratch_build.py`, tree `ue25recheck/`) gives 45 declarations and 33 theorems, every axiom report empty. Against their signatures:
- **`hear`, `ReadsCountByCount`, `CommutesWithRenaming`, `hear_keeps`.** The proof uses `related i m`, `related (p i) m`, then `alike`, then `commutes`. All three conditions are hypotheses. `hear` and `hear_keeps` are general in the count type `V` and need no order, as the note says.
- **`tied_hears_tied`.** Proves `rule m c d (σ m w) = rule m c d w` for own and heard counts the renaming fixes. The gloss "a speaker it covers never names one word from a tie" is about `rule`, which is the own and heard counts together, not about `say`. That is acceptable as a gloss.
- **`addHeard`, `addHeard_keeps`, `addSpeaker`, `addSpeaker_*`.** Exact. `addSpeaker_tied` needs the exchange as speaker map, an involution, and a start related to itself.
- **`never_shared_of_involution`.** Concludes `False` from both agents holding one word `v` as uniquely greatest. That is `never_shared`'s conclusion, with no `onto`. The proof is my probe P4's.
- **`bound_invariant` with `total_perm` and `powerProduct_perm`.** Probe P3, verbatim. `total_map` now resolves to `Becoming.total_map`.
- **`shared_minimizer_no_unique_greatest`.** The hypotheses are a law keeping the relation, a related start, a renaming moving every word at `m`, the same counts, a listing of every word, a positive total, and a belief `b` at the bound for those counts as weights. Exact against its docstring.
- **The order-general laws.** `unique_greatest_not_two` and `unique_greatest_eq` take irreflexivity and transitivity. `fixed_no_unique_greatest` and `shared_no_unique_greatest` take irreflexivity only. `unique_greatest_rename` takes neither. All are as stated.
- **The witnesses.** `added_tie`, `zero_symmetric`, `first_shared`, `first_not_alike`, `lead_not_symmetric` and `asymmetric_shared` are each checked by `rfl`, `decide` or case split, and each says what its docstring says.

## Each finding of REVIEW-UE25 (question 1)

### R2 (verified): fourteen findings are answered fully, two in substance with a point left over

**Answered fully:**
- **F1.** `pool` became `addSpeaker`, described as what it is. No attribution to federated inference is left in the module. A correction section is added to THIRD-PART-SEARCH. One wording point remains: Eq. 10 (R8).
- **F2.** The renames are `addSpeaker`, `hear` and "speaker map". No "pool", "partner" or "precise" is left in the Lean.
- **F3.** `bound_invariant`.
- **F4.** The learning argument now rests on `hear_keeps` and `never_shared`. The minimizer is stated apart and joined to a run by `shared_minimizer_no_unique_greatest`.
- **F6.** The duet is not counted. The page and THIRD-PART-SEARCH say why, and accurately (R15).
- **F8.** "The hearer given the meaning" is a modelling choice and a hypothesis. The note takes the renaming the same for every meaning, though 05's reading and the page do not yet (R6).
- **F9.** `lead_not_symmetric` and `zero_symmetric` are added, and the docstrings are reworded.
- **F10.** `swap_involution`, `swap_moves`.
- **F11.** `UniqueGreatest`. "Precise" is kept out of the Lean, and the boundary says how it differs.
- **F12.** `total_map` is dropped.
- **F13.** `never_shared_of_involution`.
- **F14.** The header now states `onto`, and `tied_hears_tied` is added.
- **F15.** O'Doherty is added.
- **F16.** Zero counts are read over a common positive prior.

**Answered in substance, with a point left:**
- **F5.** The order-general laws and the general `hear` are done, and the paper's law is labelled a reading. The reading places that law in `hear_keeps`'s class, but its gating reads the whole model (R6).
- **F7.** "Deterministic" is named, and Argiento and others 2009 is cited. Two summary sentences drop "keeping the symmetry", which turns them false (R3).

## The landing texts against the signatures

### R3 (must fix): three sentences are false as written

Each is contradicted by a witness in the module.

**(a) The page, §1 "Where the theory forbids", and the page's item 5 heading.**
- The texts read: "agents learning a code from what they hear, from a symmetric start under a deterministic law, never come to share a uniquely greatest word", and "Agents learning a code from what they hear never come to share a uniquely greatest word from a symmetric start".
- `Witness.first` makes these false. Probe Q2 (`q2_deterministic_shares`) bundles the module's own facts:
  - `first` is a deterministic rule of learning from what is heard, of the principle's form `addHeard`;
  - its speaker map is the exchange;
  - it reads count by count (`q2_first_reads`);
  - it starts from a related start (`Witness.zero_symmetric`);
  - it brings a shared uniquely greatest word (`Witness.first_shared`).
- Only commuting with the renaming fails.
- **Fix.** Write "under a deterministic law keeping the exchange of agents with a renaming of the words" (for learning: "by a rule commuting with the renaming") in both places. Add "at a meaning where the renaming moves every word".

**(b) The study section, Delta (4).**
- It reads: "adding the speaker's own counts … gives an involutive pair one model from the first step …, with no uniquely greatest word where the renaming moves every word (addSpeaker_tied)".
- `Witness.asymmetric_shared` makes this false. It is an involutive pair adding the speaker's counts, the renaming `not` moving every word, from the asymmetric start `lead`, and it does hold a shared uniquely greatest word.
- **Fix.** Write "…; with the exchange as speaker map, from a start related to itself, that one model has no uniquely greatest word where the renaming moves every word (addSpeaker_tied)".

**(c) Not false, but should be made plain.**
- The page's table row says "forbidden as a guarantee for a deterministic scheme of the principle's update", and 08 §8 says "for a deterministic scheme from a symmetric start".
- Read as forbidding the guarantee, each is true: one scheme of the class from one related start refutes it.
- Read as "every deterministic scheme of the principle's update fails", each is false, by `first_shared` again.
- **Fix.** Write "a deterministic scheme keeping the symmetry (a rule commuting with the renaming)".

### R4 (overclaim): summaries drop hypotheses the theorems need

Each dropped hypothesis is necessary. A probe or a module witness shows the conclusion failing without it.

**(i) `onto`, or the exchange an involution, for `never_shared`.** Without either, probe P9 of REVIEW-UE25 is a counterexample. The hypothesis is missing in:
- README row (en and zh);
- the checker's scope sentence;
- the root module's L1 bullet (where `unique_greatest_exchanged_run` also needs `onto`);
- FEP-INTEGRATION item 10;
- the page's item 5 body;
- the record's `statement` (en and zh);
- the landing commit message (`land_ue25.sh`, line 42);
- the board's landed clause (`board_ue25.py`, lines 37–41).

05 §9's theorem, the record's LAWS and its hypotheses state it correctly.

**(ii) A listing of every word, for `minimizer_no_unique_greatest`.**
- Probe Q3 (`q3_listing_needed`): over the listing `[false]`, weights `1, 1`, fixed by the swap and with a positive total, are reached by the belief `0, 5`, whose word `true` is uniquely greatest.
- Missing in:
  - 05 §9's theorem ("…with a positive total, a belief at the bound has no uniquely greatest word");
  - README row;
  - checker scope;
  - L1 bullet;
  - FEP-INTEGRATION;
  - the page's item 5;
  - THIRD-PART-SEARCH's correction (premise bullet);
  - commit message and board.

**(iii) A positive total.**
- Probe Q4 (`q4_positive_needed`): over every word, weights `0, 0` are reached by `1, 0`, which has a uniquely greatest word.
- Missing wherever "a belief at the bound under symmetric weights names no word" appears unqualified: README (en and zh), checker scope, L1 bullet, FEP-INTEGRATION, the page's item 5, commit message and board.
- "Symmetric weights" should read "weights a renaming moving every word fixes, with a positive total, over a listing of every word".

**(iv) The speaker map commuting with the exchange, for `hear_keeps` and `addHeard_keeps`.**
- An unconditional "learning from what is heard keeps the symmetry" (README row) is too strong.
- So is a list of only two of the three conditions: FEP-INTEGRATION item 10, the page's item 5, commit message and board.
- The record's law 6 also omits it for `addHeard_keeps`.

**(v) The record's law 8, second sentence (`shared_minimizer_no_unique_greatest`).** It omits:
- the related start;
- the renaming moving every word at the meaning;
- the listing of every word with a positive total, which may be read as inherited from the first sentence.

**(vi) The record's law 6 and the module header line 54 (`addSpeaker_tied`).** "With the exchange as speaker map" should say "the exchange, an involution, as speaker map".

**Fix.** Put each theorem's hypotheses into its summary. The short form "where the renaming is onto (or the exchange an involution) and moves every word" fits everywhere `never_shared` is summarized.

## The reading against federated inference (question 3)

### R5 (verified): the readings carry their labels

Each reading carries "[AI reading, D45]": 05's Reading, the page's item 5, the study's Readings, the THIRD-PART-SEARCH correction and the note §3. The record's correspondence says "AI reading:", which matches the records' usage. The page's other readings of the papers ("read universally", "on its natural reading") follow the page's convention for entries 1–4, which leaves them unlabelled.

### R6 (overclaim, inside a labelled reading): the paper's update is not of `hear_keeps`'s class

**Location.** 05 §9 Reading ("so its update is of this class over the reals"); the page's item 5; the study's Readings; THIRD-PART-SEARCH's correction ("placed in the class `CountedCodes.hear_keeps` covers"); note §3.

**What is wrong.**
- `hear`'s rule at meaning `m` reads only the hearer's and the speaker's counts at `m`.
- The paper's update has two policies, "to update or not to update". It averages them by P(u₁) = σ(−αG) (Eqs. 10–11), where G is expected free energy, and it adds forgetting (Eq. 12).
- G reads the agent's whole model, every meaning, which the note itself says. So the update is not a rule of `hear`'s form.
- The paper's update can still keep the relation, the hypothesis of `never_shared`. Probe Q5 (`q5_gated_keeps`, empty axiom report) proves that a gated law, whose gate reads an agent's whole model, keeps `Renamed π σ` wherever the gate is unchanged by the renaming.
- For expected free energy that needs the renaming to be the same for every meaning. A per-meaning permutation changes the marginal over words, and with it the mutual information G contains.
- 05's Reading and the page's item 5 do not say "the same for every meaning". The note §3 does.

**Fix.** Rephrase the readings, keeping the label:
> its learning step, the hearer given the meaning, adds the speaker's normalized predictive at the meaning, a rule of `hear`'s kind; with its gating by expected free energy and its forgetting, which read the whole model and treat every word and both agents alike, its law is read as keeping the relation that `never_shared` needs, for a renaming the same for every meaning.

Optionally add Q5 to the module as `gated_keeps`, which turns half the reading into a theorem.

**Answer to question 3.** The overclaim is mild, labelled, and not load-bearing for the count (R14). It should still be corrected, since the class named is the wrong one.

### R7 (overclaim, minor): the note says "a meaning the renaming moves"

**Location.** Note §3, "What the law forbids": "…for a meaning the renaming moves".

**What is wrong.** The renaming must move *every* word at the meaning. Probe Q1 (`q1_shared`) is the counterexample:
- three words, the renaming swapping `a` and `b` and fixing `c`;
- a start related to itself (`q1_symmetric`);
- one step of `addSpeaker` gives both agents `3, 3, 10`, so `c` is a shared uniquely greatest word.

**Fix.** Write "a meaning where the renaming moves every word (onto, or the exchange an involution)".

## The papers' claims

### R8 (minor, accuracy): Eq. 10 is not "attention"

**Location.** Note §3 ("gated by the probability of attending (Eq. 10)"); THIRD-PART-SEARCH correction ("gated by attention (Eq. 10)").

**What is wrong.** The paper frames Eq. 10 as two policies, "to update or not to update". Eq. 11 is the model average over them, and Eq. 12 is forgetting, with total counts saturating at η = 32. The text does not use "attention" or "attending" there.

**Fix.** Write "weighted by the probability of the policy to update (Eqs. 10–11), with forgetting (Eq. 12)".

### R9 (minor, citation): the initialization is not in §5 ¶1

The note §3 cites "§5 ¶1". The full text I fetched places "setting all the Dirichlet parameters to one, plus an unsigned random Gaussian variate" in §5's second paragraph; the first paragraph introduces the emergence of language. Cite "§5", or "§5 ¶2" after a check. The page cites no paragraph and is fine.

### R10 (minor, citation): the sampled-reinforcement results

**(a) Hu, Skyrms and Tarrès.** The note §3 says they "extend it to more states". Their abstract (arXiv:1103.5818) shows two things for more states and signals:
- the expected payoff converges almost surely;
- limit configurations that are not signalling systems arise with positive probability.

So chance alone does not guarantee a signalling system beyond two states. Write "Hu, Skyrms and Tarrès 2011 analyse more states and signals, where limits other than signalling systems occur with positive probability".

**(b) Argiento and others 2009.** The study's standing says "the system is reached with probability one". The abstract says the urn scheme "achieves asymptotically optimal coordination", reinforcing only after a win. Use the abstract's wording, or check "with probability one" against the theorem statement before landing it. The page, 05 and the record say "reaches a signalling system", which agrees with the abstract.

### R11 (verified): the other claims about the papers are accurate

**Federated inference (Friston, Parr and others 2024):**
- §3.1 shares posterior predictive beliefs over latent states, with the update in Eqs. 6–8.
- Eq. 9 is Δa = o ⊗ s, an outer product.
- The paper chooses the direct exchange of distributions over sampling a token "for simplicity" (§3.1).
- The abstract's sentence is quoted correctly.
- The parameters start at one plus an unsigned Gaussian variate.

**Ecosystems (Friston, Ramstead and others 2024):** "any dyad or ensemble of self-evidencing agents will come to share a generative model" sits in the third paragraph of §4.1, with the hedge "(or at least some factors of a generative model)". The paper reports no system or simulation of its own.

**The duet (Friston and Frith 2015):**
- Its birds have continuous states (Lorenz attractors in predictive coding).
- Both share the same prior expectations.
- Learning is deferred to the companion paper.
- It has no categorical words or Dirichlet counts.

**The 2016 paper:** the authors with O'Doherty are now right.

## Smaller points

### R12 (minor): the study misstates the review's kinds

The study's "The review" paragraph calls "the paper's law lay outside the Lean" an overclaim. In REVIEW-UE25 the overclaims were F3, F4 and F6 (the duet), and the gaps F5, F7 and F8. Restate it that way.

### R13 (minor): "doubles at each step" is not proved, and not true at the first step

**Location.** Note §5; the record's does_not_show ("adding the speaker's counts doubles the counts at each step").

**What is wrong.** No theorem states it. From an unshared start the first step sums two different count vectors. It doubles only from the second step on, with an involutive speaker map.

**Fix.** Add `addSpeaker_doubles` (from step one, `state (n + 2) i m w = 2 * state (n + 1) i m w`, by `addSpeaker_shares_run`), or reword: "re-adds the speaker's counts at every step, so the concentration grows with no new datum".

### R14 (minor, naming): `CountedCodes.Witness.first` collides with `FreeEnergyCounting.Witness.first`

Under `open FreeEnergyCounting`, which the module itself opens, `Witness.first` is ambiguous. My probe failed to compile until I qualified it. Rename it to, for example, `Witness.sayFirst`.

### R15 (minor): the page's §3 lede on the 2024 scheme

The lede says "if agents of the 2024 scheme came to one word from a symmetric start with no noise, their update would prefer a word". The law is equally broken by an update that tells the agents apart: an order of hearing, a centre, or a gate reading an agent's index. Write "their update would treat words or agents unalike".

## Counting the fifth statement (question 4)

### R16 (verified, with conditions): counting one fifth statement is justified

**The count rests on theorems, not on the reading.** "Language is an emergent property of free-energy minimisation", read universally, is refuted by one model in the principle's terms:
- natural Dirichlet counts, the hearer given the meaning, learning by adding what is heard with a rule commuting with renaming;
- from a start related to itself, no two exchanged agents ever share a uniquely greatest word (`hear_keeps`, `addHeard_keeps`, `never_shared`);
- a concrete instance is `Witness.added_tie` with `addSpeaker_tied`.

The reading that federated inference's own scheme lies in the class (R6) only explains why the paper's simulation needs its random start. The count does not depend on it.

**The ecosystems paper fits as the general statement.** Its §4.1 ¶3 sentence is a guarantee, "will come to share". On its natural reading, a common code, the same law forbids it. With its hedge, "some factors", it is not forbidden, and the texts say so. It describes no system, so nothing of it is refuted.

**Leaving the duet out is right** (R11).

**The papers' simulations stand.** The texts say so, and the federated-inference simulation's start is asymmetric.

**Conditions.**
- R3 before landing: the page's §1 bullet and item 5 heading currently forbid more than the law does.
- R4 and R6 in the same text pass.

With those, the page's fifth entry is as well founded as entries 1–4: a law of the couplings and courses on a model in the principle's terms, against a sentence read as unqualified.

## Probes

The probes are in `ue25recheck/Becoming/Recheck25.lean`, next to a copy of the round-2 module, built with `python3 -B scratch_build.py` against the core's cache. The module gives 45 declarations and 33 theorems with empty axiom reports. The probe file gives 12 declarations and 8 theorems with empty axiom reports.

| Probe | Shows | Used in |
|---|---|---|
| `q1_symmetric`, `q1_moves_some`, `q1_shared` | a renaming moving only some words lets exchanged agents share a uniquely greatest word | R7 |
| `q2_first_reads`, `q2_deterministic_shares` | a deterministic rule of learning from what is heard, reading count by count, from a related start, brings a shared word: only commuting with the renaming fails | R3 |
| `q3_listing_needed` | the minimizer law needs a listing of every word | R4 |
| `q4_positive_needed` | the minimizer law needs a positive total | R4 |
| `gated`, `q5_gated_keeps` | a gated law reading the whole model is not of `hear`'s form but keeps the relation where the gate is unchanged by the renaming | R6 |

REVIEW-UE25's probe P9 (`ue25review/Becoming/Probe25b.lean`) still stands for the necessity of `onto`, or the exchange an involution (R4 (i)).

## Count, and what blocks landing

| Kind | Count | Points |
|---|---|---|
| must fix (false as written) | 1 | R3 |
| overclaim | 3 | R4, R6, R7 |
| minor | 7 | R8, R9, R10, R12, R13, R14, R15 |
| verified | 5 | R1, R2, R5, R11, R16 |

**Nothing in the Lean blocks landing.** It is sound and exact, every axiom report is empty, and it answers every Lean finding of REVIEW-UE25.

**The texts block landing until one text pass is made.** It is a text-only pass, with no Lean change and no new core run:
- R3, the false sentences on the principle's page and in the study section;
- R4, the dropped hypotheses in the README rows, the checker's scope sentence, the L1 bullet, FEP-INTEGRATION, the page's item 5, THIRD-PART-SEARCH, the record, the commit message and the board;
- R6, the class named in the readings.

The minor points can go in the same pass.
