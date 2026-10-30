# UE25 review: `Becoming.CountedCodes` and its study note

31 October 2026. An independent adversarial review, AI-written, of
`ue25build/Becoming/CountedCodes.lean` (the module) and `ue25kit/NOTE.md` (the note). Nothing in
the repository was edited.

## Verdict

The Lean is sound. The module compiles with the core's Lean (4.29.1). It has 37 declarations,
26 of them theorems, and every axiom report is empty. Each theorem proves its statement, and no
hypothesis is vacuous. `Law.KeepsRelation T (Renamed π σ)` with a symmetric start is met in
non-trivial cases: `pool` keeps it, and so does a family of laws that are not `learn` (probe P7).
`opposite` is a symmetric start in which both agents hold a greatest word.

The problems lie in what the prose attributes to the Lean and to the papers:
- `pool` is not federated inference's exchange of sufficient statistics (F1).
- `bound_eq_map` is a reindexing of a listing, not an invariance of the bound (F3).
- The note's step from `minimizer_imprecise` to "no shared precise language" does not follow (F4).
- The duet's model is not a Dirichlet-count model (F6).
- The paper's actual update law is not covered (F5).

## Findings

### F1 (error): `pool` is not "exchanging sufficient statistics" as in federated inference

**Location.**
- Module header, lines 9–10 ("Agents pooling these counts exchange sufficient statistics"), lines 35–37, and the Standing paragraph (line 73: "exchanging sufficient statistics is federated inference").
- Docstrings of `pool` and `pool_keeps` (lines 232, 235).
- Note §2 item 3 and §4; DESIGN §3.5.
- The source of the error is THIRD-PART-SEARCH candidate 6 ("Agents exchange sufficient statistics rather than samples (§3.1 ¶7)").

**What is wrong.** I checked Friston, Parr and others 2024, "Federated inference and belief sharing", through Europe PMC's full text.
- In §3.1 the agents broadcast posterior (predictive) beliefs over *latent states*. The paper calls these messages "posterior predictive distributions over latent states", and the update adds other agents' log-posterior messages (Eqs. 6–8).
- The Dirichlet counts of the likelihood are learned by each agent privately: Δa = o ⊗ s (Eq. 9), gated by P(u₁) = σ(−αG) (Eq. 10), with forgetting at η = 32 (Eq. 12).
- No step adds another agent's concentration parameters to one's own.
- `pool` does exactly that: it adds the partner's *likelihood counts*. That is parameter pooling, not the paper's belief sharing.
- `pool` also re-adds the partner's whole counts at every step, so the partners double their counts each step after they share, with no new count heard (probe P6: `3, 3` then `6, 6`). An exchange of sufficient statistics in the Bayesian sense adds each datum once.
- "Partners hold one model after one exchange" (`pool_shares`, from any start) is therefore a property of this summing law. It is not a property of federated inference.

**Fix.**
- Describe `pool` as what it is: each agent adds its speaker's counts at the meaning, which is hearing the speaker's whole predictive for that meaning, unnormalized.
- Say exactly how far this is from the paper. The paper's update with the meaning known to both is `learn` with `say m c` the *normalized* predictive `c / Σ c`, gated and with forgetting. That law is over the reals and is not proved here (see F5).
- Drop "exchanging sufficient statistics" and "federated inference" from `pool`'s docstrings, the header and the Standing paragraph.
- Ask UE1's owner to correct candidate 6's sentence in THIRD-PART-SEARCH.

### F2 (minor, naming): `pool` collides with the glossary's "pool" and with signalling's "pooling"; "partner" is not the code law's word

**Location.** `pool`, `pool_keeps`, `pool_shares`, `pool_shares_run`, `pool_shared_imprecise`, `Witness.pooled_tie`, and "partner" throughout.

**What is wrong.**
- The glossary defines *pool* once, in 05: "a group selecting through its members' couplings together", the pooled coupling being the meet. The core uses that sense in `ChoiceCountCapture.pooled_selectsThrough` and `Flow.unselected_beyond_pool`.
- In Lewis signalling, a *pooling* equilibrium is the non-separating outcome, the opposite of a signalling system. So `pooled_tie` reads as "a tie at a pooling equilibrium".
- "Partner" is a social word. `SharedCodes` already names the roles structurally: `Hearing.hearer` and `Hearing.speaker`.

**Fix.**
- Rename `pool` to `addSpeaker` (or `addHeard`), with `addSpeaker_keeps`, `addSpeaker_shares`, `addSpeaker_shares_run`, `addSpeaker_tied` and `Witness.added_tie`.
- Rename "partner map" to "speaker map", so that `p i` is the speaker `i` hears.

### F3 (overclaim): `bound_eq_map` does not show that free-energy minimization is unchanged by renaming

**Location.** `bound_eq_map` and its docstring; header bullet "Free-energy minimization is unchanged by renaming the words"; note §2 item 4 and §3; DESIGN §3.1 ("This proves UE1's premise").

**What is wrong.**
- `bound_eq_map` relates the bound over the listing `hs.map σ` to the bound over `hs` with the functions precomposed. That is a reindexing, and it holds for *every* map `σ`, a constant map included (probe P2 instantiates it with `fun _ => false`).
- It says nothing about one listing under a renaming, which is what "unchanged by renaming" means.
- No declaration uses it.

**Fix.** Replace it with the invariance itself. Probe P3 proves it in the pure core with empty axiom reports, from `p3_total_perm`, `p3_powerProduct_perm` and the core's `mul_turn`:

```lean
theorem bound_invariant (σ : α → α) (n a : α → Nat) (hs : List α)
    (permutes : (hs.map σ).Perm hs) :
    (bound for n, a over hs) ↔ (bound for n ∘ σ, a ∘ σ over hs)
```

`permutes` holds wherever `hs` lists the words once and `σ` is a bijection. Keep `powerProduct_map` as a lemma.

### F4 (overclaim): the note's federated-inference argument conflates two free energies

**Location.** Note §3, third bullet: "free-energy minimization is unchanged by renaming the words (`bound_eq_map`), and under symmetric weights its minimizer is imprecise (`minimizer_imprecise`). So from a symmetric start, learning by free-energy minimization alone brings no shared precise language." The header bullet makes the same suggestion.

**What is wrong.**
- `minimizer_imprecise` is about a *categorical belief over words*. The words are the hypotheses of `FreeEnergyCounting`'s bound, and the belief sits at the bound for weights the renaming fixes.
- The Dirichlet update minimizes a different free energy, over the likelihood's parameters. The module says it does not model that one ("free energy over parameters as a real number").
- `minimizer_imprecise` is connected to no run of `learn`, so the "So" does not follow.
- The learning result is `learn_keeps` together with `never_shared_greatest` and `shared_imprecise`.

**Fix.**
- Argue the bullet from `learn_keeps` and `never_shared_greatest`, and say which reading places the paper's law in that class (F5).
- Cite `minimizer_imprecise` separately, as the static fact that a categorical belief at the bound inherits its weights' symmetry. Say what the belief over words stands for, for example the belief over which word to say.

### F5 (gap): the paper's update law is outside what the Lean proves

**Location.** Note §3 and §4; header "Modelling choices"; NOTE §5 (Boundary).

**What is wrong.**
- The paper's parameters are real: one plus an unsigned Gaussian variate. Its update also has:
  - a soft heard outcome, the speaker's predictive;
  - the hearer's posterior `s` over latent states;
  - gating P(u₁) = σ(−αG);
  - forgetting at η;
  - structure learning, which the paper credits for emergence ("rests upon structure learning…").
- No state of the paper is a natural count vector, and `learn` is additive only.
- The forbidding law `never_shared_greatest` is general in `T` but stated for `Nat` counts. That the paper's law keeps `Renamed π σ` is a plausible reading, not a proved claim.

**Fix.** Do (a) and (b), then (c):
- (a) The precision and symmetry part uses no arithmetic: `rename`, `Greatest`, `Renamed`, the `greatest_*` theorems, `never_shared_greatest`, `shared_imprecise` and `read_relabels`. State it for counts in any `V` with `<`, irreflexive and transitive. Probe P8 shows the two key laws on that basis with empty axiom reports. The periphery can then instantiate `V := ℝ`.
- (b) Generalize `learn` to a rule giving each agent's new counts at `m` from its own and its speaker's count vectors at `m`, the rule commuting with renaming. Probe P7 proves the pointwise case, averaging and forgetting included, with empty axiom reports.
- (c) In the note, write exactly that the paper's gated, forgetting update keeps the relation as a reading, or prove it in the periphery.

### F6 (overclaim): the duet is not stated in these terms

**Location.** Note §3, first bullet ("Read literally, exchanging sufficient statistics confirms it…") and the decision "the page counts one statement … citing the three papers".

**What is wrong.**
- "A duet for one" models birdsong with continuous states: Lorenz attractors in generalized predictive coding. It has no categorical words, no likelihood counts and no simulated learning. Learning is deferred to the hermeneutics companion, and both birds start with the same prior expectations.
- The counted-code law, stated on natural counts of words, does not reach that model.
- The duet exchanges no sufficient statistics.

**Fix.** Count the fifth statement against federated inference, with the ecosystems paper's §4.1 as the general statement it instances. Federated inference is the strongest target:
- its language is Dirichlet learning of precise, shared likelihood mappings;
- it exchanges distributions rather than sampling a token, an alternative §3.1 names and does not take;
- its only symmetry breaker is the random start.

Keep the duet under 05 §9's code law, whose forms may be of any type (a continuous state with a reflection, for example), or count it only with that stated. Reword "Read literally…" as: "Read literally, any law making the partners hold one model confirms it."

### F7 (gap): speaking by sampling is a known positive case and must be a named hypothesis

**Location.** Header "Not modelled"; note §3, §4 and §5.

**What is wrong.**
- Count reinforcement with sampled signals is the sampled form of adding the counts heard. In the Lewis game with two states, two signals and two acts, it reaches a signalling system. The analysis is in Argiento, Pemantle, Skyrms and Volkov 2009, *Stochastic Processes and their Applications* 119(2), 373–390; Hu, Skyrms and Tarrès 2011 (arXiv:1103.5818) extend it to more states and signals.
- So the statement fails to be forbidden for stochastic speakers. The page's first statement says "Under noise the law does not apply", and the fifth needs the same clause.
- Citing only Skyrms 2010 in general undersells the known result.

**Fix.**
- Name "a deterministic law" in the fifth statement's hypotheses.
- Cite the urn results as the known result for the sampled case.
- Add that the federated paper itself chooses direct exchange over sampling (§3.1), which places its scheme in the deterministic class.

### F8 (gap): the hearer is given the meaning, and a meaning-dependent renaming is a symmetry only then

**Location.** `learn` (the heard counts are added at the meaning `m` spoken), `σ : M → F → F`, and "Modelling choices".

**What is wrong.**
- `learn` takes `s` one-hot at the true meaning.
- In the principle's scheme `s` is the hearer's posterior over latent states, inferred partly from the words through its own likelihood. A renaming that differs between meanings changes that inference: per-column permutations alter the comparison of `A[w, m]` across `m`.
- Only a renaming constant in `m` is a symmetry there.

**Fix.**
- Add "the hearer is given the meaning" to the modelling choices.
- Make the reading against the paper with `σ` constant in `m`.

### F9 (minor): `Witness.lead` and `Witness.zero` docstrings

**Location.** `Witness.lead` ("A start no exchange relates to itself") and `Witness.zero` ("a start related to itself").

**What is wrong.**
- Read literally, the `lead` docstring is false. The identity exchange with the identity renaming relates `lead` to itself, as it does every state (P5, `p5_lead_identity`).
- Neither docstring's intended claim is proved.

**Fix.**
- Reword: "a start that the exchange of the agents together with the renaming of the words does not relate to itself".
- Add `lead_not_symmetric` (P5 proves it with an empty axiom report) and `zero_symmetric`.

### F10 (minor, naming): `Witness.not_involution`, `Witness.not_moves`

These names read as negations ("not an involution", "does not move"), the opposite of what they state. Rename them `swap_involution` and `swap_moves`.

### F11 (minor, naming): `Greatest` has another sense in the core; "precise" has two senses

**Location.** `Greatest`; "precise word" in the header, in `pooled_tie`'s docstring and in the note.

**What is wrong.**
- `RelativePosition.Greatest` is non-strict, relative to a list, and allows ties. One name in the core now has two senses.
- The paper's "precise" likelihood mappings are sparse and unambiguous (§5.1). A unique greatest count, `2, 1` for instance, is far weaker, so calling `opposite`'s agents "precise" stretches the word.
- The conclusion "imprecise" (no greatest word) is sound in the paper's sense. For finite words a tie at the top gives each tied word at most half of the posterior mean.
- It is not sound for Dirichlet *precision* (concentration), which `pool` doubles at every step (P6).

**Fix.**
- Rename to `UniqueGreatest` (or `Leads`).
- Say "holds a greatest word" for the positive case.
- Keep "imprecise" for the conclusion, glossed as "ambiguous: no word is most likely for the meaning", and note that the concentration grows.

### F12 (minor, duplicate): `CountedCodes.total_map` duplicates `Becoming.total_map`

`Becoming.total_map (g : α → β) (q : β → Nat)` (Flow.lean, line 150) is in the module's import closure and proves the module's lemma (P1, `p1_total_map_dup`). Drop the module's copy and use `Becoming.total_map`. `powerProduct_map` has no duplicate in the core; generalizing it to `σ : α → β` would match.

### F13 (minor): `onto` is needed in general but not for an involution

**Location.** `never_shared_greatest`'s hypothesis `onto`.

**What the probes show.**
- `onto` is needed in general. P9 is a counterexample without it: agents `Int` shifted by one, words `Nat` renamed by `succ`, which moves every word but is not onto, and the identity law. There agents `0` and `1` both hold word `0` as greatest. (P9 uses `omega` and reports `propext` and `Quot.sound`, which is acceptable for a scratch counterexample.)
- Where `π` is an involution, `onto` is not needed (P4, `p4_never_shared_involution`, empty axiom report).
- More generally, it is not needed wherever `π`'s orbit from `i` is eventually periodic (argued by hand: `X i` is then fixed by some power of `σ`).

**Fix (optional).** Add the involutive form. Every use in the reading is two agents swapped.

### F14 (minor): header wording against the theorems

1. Under "Never a shared precise word": "In a state related to itself, an agent's greatest word, renamed, is the greatest word of the agent the exchange gives it (`greatest_exchanged`)". The hypothesis "where the renaming is onto" is omitted (the docstring has it).
2. `greatest_exchanged_run`'s docstring also omits `onto`.
3. "(`greatest_exchanged_run`) where an agent and the agent `π` exchanges with it each hold a greatest word, the second is the first renamed". This understates the theorem, which *derives* `π i`'s greatest word from `i`'s.
4. The bullet title "The principle's learning keeps both symmetries" is unconditional, while `learn_keeps` has three hypotheses.
5. The speaker hypotheses already exclude naming one word from a tie. P10 (`p10_tied_says_tied`, empty axiom report) shows that a speaker reading count by count and commuting with the renaming says, from counts the renaming fixes, counts the renaming fixes.
   - So the deterministic speakers `learn_keeps` covers are those that never name a word from a tie.
   - That is the general content of `first_not_alike`, and it belongs in the header. It makes plain that the class is "share distributions", the federated paper's choice.

**Fix.** Adjust the wording, and add P10 as `tied_says_tied`.

### F15 (minor, citation): the 2016 paper's authors

Note §4 lists "Friston, FitzGerald, Rigoli, Schwartenbeck and Pezzulo 2016". The authors are Friston, FitzGerald, Rigoli, Schwartenbeck, **O'Doherty** and Pezzulo, *Neurosci. Biobehav. Rev.* 68, 862–879 (DOI 10.1016/j.neubiorev.2016.06.022). Add O'Doherty.

The other citations check out:
- Lewis 1969 (*Convention*);
- Skyrms 2010 (*Signals*, OUP);
- Curie 1894 (*J. Phys. Théor. Appl.* 3);
- the duet (*Conscious. Cogn.* 36, 2015), whose §4 sentence is quoted correctly;
- federated inference (*Neurosci. Biobehav. Rev.* 156, 105500), whose abstract sentence and random start (one plus an unsigned Gaussian variate) are stated correctly.

### F16 (minor): zero counts are not concentration parameters

**Location.** Header ("the concentration parameters"), `Witness.zero`, and `Witness.lead` (agent `true` holds `0, 0`).

**What is wrong.** A Dirichlet concentration must be positive, so these witnesses start from improper beliefs.

**Fix.** Read the counts as counts added to a common positive prior that every renaming fixes (one each, say). That reading keeps every relation and every greatest word. Add it to the modelling choices.

## On question 3: counting the three statements as one

The counting is justified for federated inference, whose abstract sentence is the target, read universally:
- its scheme learns Dirichlet likelihoods;
- it exchanges distributions rather than samples;
- its only symmetry breaker is the random start.

Once F1, F3, F4 and F5 are corrected, the fifth statement can read: "under a deterministic law keeping the exchange of agents together with a renaming of words (constant over meanings), from a symmetric start, no two exchanged agents ever hold one greatest word for a meaning the renaming moves". The paper's own law is placed in that class as a reading.

The ecosystems paper's §4.1 fits as the general statement, since it describes no system of its own. The duet does not fit (F6).

Each paper's system is correctly said to lie outside the hypotheses:
- the duet starts its birds alike;
- the 2024 simulation starts from random parameters;
- the ecosystems paper describes no system of its own.

## Probes compiled

Both probe files are in `ue25review/Becoming/`, built with `scratch_build.py` against the core's cache:
- `/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue25review/Becoming/Probe25a.lean`
- `/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue25review/Becoming/Probe25b.lean`

| Probe | Declaration(s) | Result |
|---|---|---|
| module | `Becoming.CountedCodes` | compiles clean; 26 theorems, 37 declarations; every axiom report empty |
| P1 | `p1_total_map_dup` | the module's `total_map` is `Becoming.total_map`; empty |
| P2 | `example … bound_eq_map (fun _ => false)` | `bound_eq_map` holds for a constant map |
| P3 | `p3_total_perm`, `p3_powerProduct_perm`, `p3_bound_invariant` | the real invariance under a permuting `σ`; empty (after replacing `Nat.mul_left_comm`, which reports `propext`, with the core's `mul_turn`) |
| P4 | `p4_never_shared_involution` | no `onto` needed for an involution; empty |
| P5 | `p5_lead_identity`, `p5_lead_not_symmetric` | `lead`'s docstring literally false; the intended claim holds; empty |
| P6 | `p6_pool_doubles` | `pool` doubles shared counts: `6` at step 2; empty |
| P7 | `pointwise`, `p7_pointwise_keeps`, `p7_average_keeps` | laws that are not `learn` keep the relation (averaging, forgetting); empty |
| P8 | `GreatestV`, `p8_fixed_no_greatest`, `p8_not_two` | precision laws over any irreflexive, transitive `<`; empty |
| P9 | `p9_symmetric`, `p9_moves`, `p9_not_onto`, `p9_zero_greatest`, `p9_one_greatest`, `p9_counterexample` | without `onto`, a non-involutive exchange admits a shared greatest word; uses `omega`, reports `propext`, `Quot.sound` |
| P10 | `p10_tied_says_tied` | an admissible speaker says tied counts from tied counts; empty |

## Count

| Severity | Count | Findings |
|---|---|---|
| error | 1 | F1 |
| overclaim | 3 | F3, F4, F6 |
| gap | 3 | F5, F7, F8 |
| minor | 9 | F2, F9–F16 |

The Lean is sound: every theorem is true as stated, with empty axiom reports.
