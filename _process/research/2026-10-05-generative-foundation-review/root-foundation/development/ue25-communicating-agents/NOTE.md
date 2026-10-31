# UE25: communicating agents in the principle's terms

31 October 2026. This note is AI-written. It is board item UE25's study note for the core leaf `Becoming.CountedCodes`. [DESIGN.md](DESIGN.md) is the design it started from. §2–§5 state round 2 as the recheck left it ([REVIEW-UE25](REVIEW-UE25.md), [RECHECK-UE25](RECHECK-UE25.md)); §6 lists what the review changed, §8 what the recheck changed.

## 1. The gap

Under "What the theory forbids that the literature claims", [the principle's page](../../../../../../theories/becoming/FREE-ENERGY-PRINCIPLE.md) counts four statements. It names three more, which UE1's [search](../ue1-fep-bridge/THIRD-PART-SEARCH.md) grades as forbidden on their natural reading (candidates 4–6), but says that none is stated in the principle's terms:

- both agents "come to share the same model" (Friston and Frith 2015, the duet, §4 ¶2);
- any dyad or ensemble "will come to share" a generative model (Friston, Ramstead and others 2024, §4.1 ¶3);
- language is "an emergent property of free energy minimisation" (Friston, Parr and others 2024, abstract).

The forbidding law, [a code formed between formations](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations), is stated for codes, where each formation holds one form for each sense. The principle's agents hold beliefs instead: a likelihood mapping meanings to words, learned as Dirichlet counts.

## 2. What the Lean shows

The module is `Becoming.CountedCodes`, a core leaf importing `Becoming.SharedCodes` and `Becoming.FreeEnergyCounting`. It has 47 declarations, 34 of them theorems, and every axiom report is empty.

A belief state gives each agent, for each meaning, a count of each word. The counts lie in any type with an order `<`; learning and free energy use natural counts. `UniqueGreatest c w` says `w` alone has the greatest count: the word a posterior mean names as most likely, with no tie.

1. **A unique greatest word.** With `<` irreflexive and transitive:
   - two different words are never both uniquely greatest (`unique_greatest_not_two`, `unique_greatest_eq`);
   - where the renaming is onto, a uniquely greatest word of renamed counts is carried to one of the counts (`unique_greatest_rename`);
   - counts that a renaming moving every word leaves unchanged have none (`fixed_no_unique_greatest`).
2. **Never a shared uniquely greatest word.** `Renamed π σ X Y` holds where, count by count, `Y` is `X` with the agents exchanged by `π` and the words renamed by `σ`.
   - A law keeping the exchange alone and the renaming alone keeps both together (`keeps_both`).
   - Under a law keeping `Renamed π σ`, from a start related to itself, where the renaming at `m` is onto: at every step an agent's uniquely greatest word, renamed, is that of the agent the exchange gives it (`unique_greatest_exchanged`, `unique_greatest_exchanged_run`).
   - Where the renaming also moves every word, the two words differ (`never_shared`). With the exchange an involution, the renaming need not be onto (`never_shared_of_involution`). Without either, the conclusion can fail: the review's probe P9 has a counterexample.
   - Where the two agents hold the same counts for `m`, those counts have no uniquely greatest word (`shared_no_unique_greatest`).
   - With the exchange an involution and the renaming onto, the code of uniquely greatest words read off a related state is a code related to itself in the code law's sense (`read_relabels`, into `SharedCodes.Relabels`).
3. **Learning by what is heard keeps both symmetries.** `hear p rule` gives each agent's new counts for `m` by `rule m` from its own counts for `m` and those of the agent `p i` it hears; the hearer is given the meaning.
   - It keeps `Renamed π σ` where three things hold (`hear_keeps`): the speaker map commutes with the exchange, the rule reads count by count, and the rule commutes with renaming.
   - Such a rule gives counts a renaming fixes from counts it fixes (`tied_hears_tied`). A deterministic speaker it covers never names one word from a tie.
   - In natural counts, adding what is heard, `addHeard`, is the form of the principle's update of Dirichlet counts. It keeps the relation where what is heard reads count by count and commutes with renaming (`addHeard_keeps`).
   - Adding the speaker's own counts, `addSpeaker`, is the case where what is heard is the speaker's counts, unnormalized and re-added at every step (`addSpeaker_keeps`). With an involutive speaker map, the two hold one model after one step and at every later step (`addSpeaker_shares`, `addSpeaker_shares_run`). With the exchange, an involution, as speaker map, from a symmetric start, at a meaning whose every word the renaming moves, that model has no uniquely greatest word (`addSpeaker_tied`).
   - Learning gated by the whole model, `gatedHear`, lets the counts heard enter with a weight the hearer's whole model gives, as an update weighted by the policy to update. It is not of `hear`'s form, since the weight reads every meaning. It keeps the relation where, besides the conditions of `addHeard_keeps`, the renaming leaves the weight unchanged (`gatedHear_keeps`).
4. **Free-energy minimization is unchanged by a renaming that permutes the words** (the join to UE21's counting form).
   - The product of powers over a renamed listing is that of the renamed quantities (`powerProduct_map`; totals by `Becoming.total_map`).
   - Totals and products of powers are unchanged by a permutation of the listing (`total_perm`, `powerProduct_perm`).
   - So, over a listing the renaming permutes, a count belief reaches the bound for some weights exactly where its renaming reaches it for the renamed weights (`bound_invariant`).
   - Under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a listing of every word has no uniquely greatest word (`minimizer_no_unique_greatest`).
   - Joined to a run: under a law keeping the relation, where two exchanged agents hold the same counts for `m`, a belief over which word to say, at the bound for those counts as weights, has no uniquely greatest word (`shared_minimizer_no_unique_greatest`).
5. **Witnesses.** Each has two agents, two words and one meaning; the exchange swaps the agents and the renaming swaps the words.
   - Opposite counts, `2, 1` and `1, 2`, each have a uniquely greatest word, and the two differ. One step of adding the speaker's counts gives both `3, 3`: one model with none (`Witness.added_tie`).
   - From no counts, hearing the first word of greatest count, ties to the first word, brings both to hold it as uniquely greatest (`Witness.sayFirst_shared`). That rule does not commute with renaming (`Witness.sayFirst_not_alike`): the order is a preferred word. It is deterministic, reads count by count and starts from a symmetric start, so only commuting with the renaming fails (RECHECK R3).
   - A start the exchange with the renaming does not relate to itself, `1, 0` and `0, 0` (`Witness.lead_not_symmetric`), gives both `1, 0` after one step (`Witness.asymmetric_shared`).

## 3. Against the statements

**Federated inference** (Friston, Parr and others 2024): language "an emergent property of free energy minimisation", read universally.

- **The scheme, read from the paper.** Agents share posterior predictive beliefs over latent states (§3.1, Eqs. 6–8), and each learns its likelihood's Dirichlet counts privately by adding the outer product of the outcome and the posterior over states (Eq. 9). That learning is weighted by the probability of the policy to update (Eqs. 10–11), with forgetting (Eq. 12). The paper chooses to exchange distributions rather than sampled tokens (§3.1).
- **Its place in the class.** [AI reading, D45] With the hearer given the meaning, so that the posterior over states is at the meaning, the learning step adds the speaker's predictive, normalized, at the meaning. Over the reals, a normalized predictive commutes with a renaming that permutes the words, and it reads count by count, so the step is of the kind `hear_keeps` covers. The weighting by the probability of the policy to update reads the agent's whole model, every meaning, through expected free energy, so the whole law is not of `hear`'s form; it is of the kind `gatedHear_keeps` covers in natural weights, which keeps the relation where the renaming leaves the weight unchanged. Expected free energy reads the marginal over words, so that holds for a renaming the same for every meaning. Forgetting acts alike on every word. So the paper's law is read as keeping the relation `never_shared` needs, for a renaming the same for every meaning (RECHECK R6). This is a reading, not a theorem: the core states the class in natural counts and an order, and the paper's own law over the reals is not proved here.
- **What the law forbids.** Under a deterministic law keeping the exchange of agents together with a renaming of the words, from a start related to itself, no two exchanged agents ever hold one word as each one's uniquely greatest at a meaning where the renaming moves every word and is onto, or the exchange is an involution. A renaming moving only some words does not suffice (RECHECK R7, probe Q1). Free-energy minimization does not break the symmetry: it is unchanged by a renaming that permutes the words (`bound_invariant`), and under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a listing of every word names no word (`minimizer_no_unique_greatest`, and joined to a run, `shared_minimizer_no_unique_greatest`). Something else must break it: a preferred word, an order or centre telling the agents apart, an asymmetric start, or chance.
- **The paper is not refuted.** Its simulation starts each Dirichlet parameter at one plus an unsigned random Gaussian variate (§5), an asymmetric start.
- **The renaming.** It is taken the same for every meaning. Where the hearer infers the meaning from the words, only such a renaming is a symmetry of the scheme (REVIEW F8).

**Ecosystems** (Friston, Ramstead and others 2024, §4.1): any dyad or ensemble "will come to share" a generative model. On its natural reading, a common code, it is the general statement that federated inference instances, and it is forbidden in the same way. With its hedge, "or at least some factors", it is not forbidden: the shared tied model is such a factor. The paper describes no system of its own.

**The duet** (Friston and Frith 2015) is not stated in these terms. Its birds have continuous states (Lorenz attractors in generalized predictive coding), no word counts and no simulated learning, and both start with the same expectations. It stays under 05 §9's code law, whose forms may be of any type, and is not counted with this statement.

**Under sampling the law does not apply.** In the two-state Lewis game, reinforcement with sampled signals reaches a signalling system: Argiento, Pemantle, Skyrms and Volkov 2009, *Stochastic Processes and their Applications* 119(2), 373–390, which shows asymptotically optimal coordination with reinforcement after success; Hu, Skyrms and Tarrès 2011 analyse more states and signals, where limits other than signalling systems occur with positive probability. So the statement forbidden is the deterministic one, as with the page's first statement, where under noise the law gives way to an exchangeable law (UE24).

The page counts one statement, its fifth: against federated inference's sentence read universally, with the ecosystems paper's §4.1 as the general statement on its natural reading.

## 4. Standing

The symmetry argument is Curie's principle (Curie 1894), as for the code law. Conventions are equilibria that symmetry does not select (Lewis 1969), and signalling dynamics reach a signalling system by chance or by an asymmetry (Skyrms 2010; for sampled reinforcement, Argiento and others 2009). The Dirichlet update is the principle's learning of the likelihood (Friston, FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo 2016, *Neurosci. Biobehav. Rev.* 68, 862–879).

Every law is near-definitional or an instance of the core's law of a kept relation. New are two things:
- the statement of the code law for beliefs held as counts and learned by rules of the principle's form, joined to the counting form of the free-energy bound;
- the reading against the statement that language emerges from free-energy minimization, which lets the page count it.

## 5. Boundary

- **Speaking by sampling.** It is a known positive case (above). A law for sampled speech, invariant rather than deterministic, is not stated for counted codes.
- **The paper's law over the reals,** with its normalized predictive, gating by expected free energy and forgetting. It is placed in the class only as a reading.
- **The hearer inferring the meaning.** Not modelled; the renaming is then the same for every meaning.
- **How long agreement takes.**
- **Free energy over parameters.** The counting form covers beliefs in counts, and the real form joins it on the support (UE22).
- **A unique greatest count as the reading of a named word.** This is weaker than the paper's "precise" mappings, which are sparse and unambiguous. The conclusion that no word is uniquely greatest holds in either sense. Dirichlet concentration, which `addSpeaker` raises at every step by re-adding the speaker's counts with no new datum, is not precision in this sense.
- **Counts of nothing.** They are read as counts added to a common positive prior every renaming fixes, so a belief of no counts is a proper Dirichlet belief.
- **Whether actual conventions form this way.**

## 6. The review and the fix round

An independent adversarial review by an AI agent ([REVIEW-UE25](REVIEW-UE25.md)) compiled round 1 with ten probes, kept in [review-probes/](review-probes/). It found the Lean sound, all 37 declarations with empty axiom reports. It found one error, three overclaims, three gaps and nine minor points. Every point was taken in round 2:

| Finding | Round 2 |
|---|---|
| F1: `pool` is not federated inference's exchange (which shares beliefs over latent states, its counts learned privately) | `pool` became `addSpeaker`, described as adding the speaker's counts unnormalized and re-added at every step; the paper's update placed in the class as a reading (§3); a correction added to UE1's search, candidate 6 |
| F2: "pool" and "partner" | `addSpeaker`, `hear`, "speaker map" |
| F3: `bound_eq_map` is a reindexing, true for any map | replaced by `bound_invariant`, over a listing the renaming permutes, with `total_perm` and `powerProduct_perm` (probe P3) |
| F4: the step from the minimizer to learning does not follow | the learning argument rests on `hear_keeps` and `never_shared`; the minimizer stated apart, and joined to a run by `shared_minimizer_no_unique_greatest` |
| F5: the paper's law is outside the Lean | precision and symmetry laws for any strict order (probe P8); learning generalized to `hear` with any rule reading count by count and commuting with renaming (probe P7); the paper's law a reading (§3) |
| F6: the duet is not in these terms | the duet not counted; the statement is federated inference's, with ecosystems §4.1 as the general statement |
| F7: sampling reaches a signalling system | "deterministic" named; Argiento and others 2009 cited |
| F8: the hearer is given the meaning | a modelling choice; the reading takes the renaming the same for every meaning |
| F9: `lead`'s docstring | reworded; `lead_not_symmetric`, `zero_symmetric` added |
| F10: `not_involution`, `not_moves` | `swap_involution`, `swap_moves` |
| F11: `Greatest` clashes with `RelativePosition.Greatest`; "precise" stretched | `UniqueGreatest`; "precise" kept out of the Lean, and the boundary says how it differs |
| F12: `total_map` duplicated | dropped; `Becoming.total_map` used |
| F13: `onto` | `never_shared_of_involution` added (probe P4) |
| F14: header wording; tied speakers | wording fixed; `tied_hears_tied` added (probe P10) |
| F15: the 2016 authors | O'Doherty added |
| F16: zero counts | read as counts over a common positive prior (modelling choice) |

## 7. Names

- **Module.** `Becoming.CountedCodes`.
- **Record.** `a-code-held-as-counts`, homed in 05 §9 after imposing a code. The title says what the law is about, a code held as counts and learned from what is heard; the headline, that no two exchanged agents share a uniquely greatest word, is its statement.
- **Words.** "Count", "renaming", "speaker" and "hear" are structural. "Unique greatest" is exact. "Pool", "partner", "precise", "draw" and "language" do not occur in Lean names.

## 8. The recheck and the text pass

The reviewer's recheck ([RECHECK-UE25](RECHECK-UE25.md)) read round 2, this note and the landing texts against the Lean signatures, with five more probes ([review-probes/Recheck25.lean](review-probes/Recheck25.lean), every axiom report empty). It found the Lean exact (R1) and fourteen findings of the review answered fully, two in substance (R2). Every point was taken:

| Point | Taken |
|---|---|
| R3: two sentences on the principle's page, and one in the study section, forbade more than the law does (`Witness.sayFirst_shared` is a deterministic rule learning from what is heard, from a symmetric start) | each states the law keeping the exchange with the renaming, or a rule commuting with the renaming, and every word moved; the study's Delta names the exchange as speaker map and the related start |
| R4: summaries dropped hypotheses (onto or an involutive exchange; a listing of every word; a positive total; the speaker map commuting with the exchange) | each summary carries its theorem's hypotheses: README rows, the checker's scope sentence, the root module's bullet, FEP-INTEGRATION, the page, UE1's search, the record, the commit message and the board |
| R6: the paper's update named in the wrong class | the readings say the learning step is of `hear`'s kind and the weighting by the policy to update of `gatedHear`'s, for a renaming the same for every meaning; `gatedHear_keeps` added (the reviewer's probe Q5, generalized to a natural weight and any heard counts) |
| R7: "a meaning the renaming moves" | every word, onto or with the exchange an involution (§3) |
| R8: Eq. 10 is the policy to update, not attention | §3 and UE1's search |
| R9: the initialization's paragraph | §5 cited |
| R10: Hu, Skyrms and Tarrès; Argiento and others | §3 and the study's standing use the abstracts' wording |
| R12: the study misstated the review's kinds | restated |
| R13: "doubles at each step" | reworded (§5, the record's limits) |
| R14: `Witness.first` collided with `FreeEnergyCounting.Witness.first` | renamed `Witness.sayFirst`, `sayFirst_shared`, `sayFirst_not_alike` |
| R15: the page's §3 lede | "treat words or agents unalike" |
| R5, R11, R16 | verified; counting one fifth statement rests on theorems, not on the reading |

The module after the pass has 47 declarations, 34 of them theorems, every axiom report empty.
