# RECHECK-UE24: recheck of CellsUnderNoise round 2 against REVIEW-UE24

A read-only recheck by an AI agent, 30 October 2026, of the revised module (round 2, the file `CellsUnderNoise.round2.lean` in the drafting folder) against [REVIEW-UE24](REVIEW-UE24.md). This recheck is AI-written. Line numbers refer to round 2. Every point was taken in round 3 (NOTE §7).

The Lean looks right: no statement is false and no proof is wrong (I took the compile on trust). Every finding is answered in the module, most of them fully. What remains is wording. The most serious problems are:
- **The two-cell witness is misdescribed.** `commonCoin` is called "a common coin both cells read", and the Standing paragraph credits the randomized answer to Angluin (new point 1).
- **"The field must be exchangeable" claims a necessity nothing proves.** The `firstCell_fixes` docstring generalizes the same way (new point 2).
- **The axiom sentence is inexact,** and the axiom summary I was given is not exact either (new point 3).

## 1. Findings F1–F17

| F | Round 2 | Where it shows |
|---|---|---|
| F1 | Fully in the module; the claim row is outside the module and still says "the deterministic law is the case with no noise" | `exact_keeps_fixed` is dropped. The header (38–39, 44–47) now cites `lawAt_noiseless`, `noiseless_run` (C4, line 437) and `cellwise_alike` (C5, line 427). The `ofFn_iterate_cellwise` docstring (416) no longer says "no noise". |
| F2 | Fully, but the new wording is itself inexact (new point 1) | Renames to `commonCoin` (650) and `partedUniform` (622). Adds `partedUniform_not_product`, `commonCoin_not_noisy` and `commonCoin_not_noisyDescent` (631–670) and `alike_keeps_weight` (568). Line 12 says "can part". The witness is now stated from either alike start (673–689). The contrast with `unique_minimum_alike` is explained (70–71). Claim row: outside the module. |
| F3 | Taken | `noisyDescent_exchangeable` (520) is the headline and needs only an exchangeable field and an exchangeable start. The bound is split out with the law hypotheses (529). Two corollaries have no declaration of their own: the marginals (only cited as `marginal_eq` at 519, 54) and "the law at step n is a law" (`lawAt_law` with `noisyDescent_nonneg` and `noisyDescent_rows`). That is acceptable. |
| F4 | Fully | `independent_law` (228), `noisyDescent_from_independent` (555) |
| F5 | Taken, but overstated (new point 2) | Header 14–17; `firstCell`, `flipBy`, `firstCell_not_exchangeable`, `firstCell_fixes` (710–734). Putting it in the record is outside the module. |
| F6 | Fully, with one leftover (new point 6) | 33–35, 301–302: "steady-state" and "density" are gone; "for any real κ" and "no kernel is shown here to keep them" are added. |
| F7 | Partly | Curie and Chalmers are split from Ismael; Castellani and Ismael 2016 and Earman 2004 are added (83–88). Norton and Turing are not cited (optional). A new misattribution was added (new point 1). |
| F8 | Outside the module (claim row) | The module itself stays within finite Markov chains (13–14, 79). The `unique_stationary_exchangeable` docstring now has both qualifiers (289–291). Header bullet 3 (32–33) still leaves out "under a kernel commuting with every rearrangement". |
| F9 | Fully | `run_rearranged` (453), `cellwise_alike` (427) |
| F10 | Fully | `noisyDescent` and `noisy_eq_noisyDescent` (483–491). `lawAt` now takes a kernel per step (132). The modelling choices are updated (76–78). See new point 9 on sensory noise. |
| F11 | Fully | The docstring is corrected (184) and `pointMass_exchangeable_alike` is added (207). |
| F12 | Fully | `Witness.partedUniform_exchangeable` (704). See new point 12. |
| F13 | Partly | The names are fixed (`noisyDescent_*`), and so are the title and the prose about which cell takes which place. Prose "drawn" in the sense of sampling remains (new point 4). |
| F14 | Fully | `noiseless`, `commonCoin`, `partedUniform`; `cue` is dropped; the `Exchangeable` docstring relates the two senses (115–117). |
| F15 | Outside the module (record) | My classification is in section 4. |
| F16 | Partly | (a) `distinct_le` still has `[DecidableEq S]`. The finding was wrong: `Finset.sum_image` needs `DecidableEq (ι → S)`, so the proof uses it. (b) The sentence about `Classical.choice` was added, but it is inexact (new point 3). (c) The hypotheses that noise and start be laws are now in the docstring (527). |
| F17 | Outside the module (record) | "What is not derived" (79–83) matches the `does_not_show` the review proposed. The counterexamples exist as declarations. The module says nothing on how the 2015 simulation corresponds. |

The claim row still carries every outside-the-module item: "drawn", "the deterministic law is the case with no noise", "steady-state form", "which cell is which a fair draw", "a cue reading a cell's number", "the theory's first statement on the principle's stochastic ground", and the missing qualifiers.

## 2–3. New points

**1. The two-cell witness and the Standing paragraph (lines 62, 87–88, 601, 648–656).**
- **The description is wrong.** `commonCoin` is called "a common coin both cells read". Two identical cells reading one coin by one rule from one state stay alike: each next state is g(own state, field, coin), and those are the same for both. From an alike start, the kernel parts the cells only if each reads the coin by its number. In fact it is exactly the fair mixture of the two rules that read cell numbers: ½(rule giving cell 0 on and cell 1 off) + ½(its exchange). That is round 1's `cue` and its swap. This inexact wording comes from the review's own F2 fix ("one fair coin seen by both cells").
- **The Standing sentence is wrong twice.** Line 87 says "that a common coin breaks a symmetry no deterministic rule breaks is the randomized answer to symmetric choice in anonymous networks (Angluin 1980)":
  - Angluin 1980 proves the deterministic impossibility. The randomized answer is Itai and Rodeh (FOCS 1981; *Information and Computation* 88, 1990). It uses each processor's own independent coin, and succeeds with probability one but never with certainty in bounded time. That is what `alike_keeps_weight` shows here.
  - A common coin is the device for agreement (Rabin 1983), not for symmetry breaking.
- **Fix:**
  - Rename `commonCoin` to something structural such as `toPartedUniform`. Describe it as "a kernel commuting with every rearrangement that parts alike cells with certainty: the fair mixture of the two assignments, each reading the cells' numbers; no rule commuting with the exchange, with or without independent noise, parts them with certainty".
  - Optionally add the mixture identity as a theorem.
  - Rewrite the Standing sentence: deterministic impossibility, Angluin 1980; independent coins, probability one but not certainty, Itai and Rodeh 1981/1990, with `alike_keeps_weight` as its finite-step form.
  - Retitle the section at 601.

**2. Necessity is claimed but not shown (15–16, 722).**
- **The header claim.** "The field must be exchangeable" says exchangeability is necessary. The Lean proves only that it is sufficient, plus one counterexample field. Some fields that are not exchangeable still give a commuting descent, for example any field when `update` ignores it.
- **The docstring claim.** The `firstCell_fixes` docstring says "**Without an exchangeable field the places are fixed**", which generalizes from one witness. The witness also has no noise. That is a valid case of the law, since it covers every `r`, but the docstring should say so.
- **Fix:**
  - Header: "a field reading no cell's own number is not enough: the law is proved for an exchangeable field, and a field reading the state of the first cell fixes the places from an exchangeable start, with no noise (`Witness.firstCell_fixes`)".
  - Docstring: "A field that is not exchangeable can fix the places".

**3. The axiom sentence (89–92).**
- **"Only because" is false as proved.** The sentence says these declarations "use no `Classical.choice` and stand here only because the module imports Mathlib". The pure core needs an empty report, and `ofFn_cellwise`, `ofFn_iterate_cellwise` and `cellwise_alike` use `propext` and `Quot.sound`.
- **The list is incomplete.** I ran `#print axioms` through `lean --stdin`, writing no files:
  - `rearrange` and `alike_fixed`: `[Quot.sound]`.
  - `Witness.Two`, `Witness.firstCell`, `Witness.flipBy`: no axioms.
  - `Witness.firstCell_not_exchangeable`: `[propext]`.
  
  So the summary I was given ("everything else [propext, Classical.choice, Quot.sound]") is not exact. The record should take the checker's report for each declaration.
- **Fix:** "… use no `Classical.choice`; their proofs use `propext` and `Quot.sound`, so a core version would need proofs with an empty report (not attempted)". Either list all the declarations that use no `Classical.choice`, or say "of the joins".

**4. "Drawn" in the sense of sampling (25, 56, 221–222, 227, 553).** "Each cell drawn independently by one law" and "independent draws" use "draw" in a sense the glossary does not give. Fix: "each cell independent, by one law" or "the cells independent and of one law".

**5. The `noisyDescent_distinct_le` docstring (526–528).**
- It leaves out two hypotheses: the field is exchangeable and the start is exchangeable.
- Its bold "left to the fluctuations" overstates. The bound also holds with no noise (the start's randomness decides the assignment), and it holds trivially from an alike start with no noise (weight 0).
- Fix: "**No assignment of distinct states has more than its share**: with an exchangeable field, from an exchangeable start, where the noise and the start are laws, each … has weight at most `1 / m!`". Keep "left to the fluctuations" as a labelled reading in the header.

**6. "The core's free energy" (473).** `F` is any `F : List S → ℕ` that satisfies `IdenticalCells.Symmetric`. It is not the core's `freeEnergy`. Fix: "`F` symmetric in the core's sense, as the core's `freeEnergy` is at an exchangeable field (`freeEnergy_symmetric`)".

**7. The section title at 601 contradicts line 12.** "Independent noise does not [part them]" should say "does not part them with certainty".

**8. Two misleading names.**
- `alike_keeps_weight` (568), and "keeps weight" in the header at 58: the alike configuration `b` changes with `n`. Better: "some configuration of all cells alike has positive weight at every step", and a name like `alike_positive`.
- `firstCell_fixes`: in this module "fixed" means unchanged by `σ` (`alike_fixed`, and the core's `keeps_exchange_fixed`). Better: `firstCell_assigns`.

**9. "Noise in what the cell senses included" (50–51, 482).** This holds only for sensing noise that is independent across cells. A fluctuation of the field shared by all cells is not of the `noisyDescent` form, and read alike by alike cells it cannot part them (see point 1). Say "independent across cells".

**10. "Law" in two senses (throughout).** The module uses "law" both for a weighting and for a theorem. Line 69 has both in six words: "exchangeable by the law on unique stationary laws". It also slides between "law" as any real weighting (`Invariant`, `Exchangeable`) and "law" as nonnegative of total one (`lawAt_law`, line 54). The `distinct_le` docstring leans on the second without stating it. This was already in round 1. Fix: say "weights" for an arbitrary `p`, and "a law: nonnegative, of total one" only where it is assumed; or use "distribution".

**11. Smaller points.**
- `noisy_eq_noisyDescent` (487) takes `[Fintype S]` and never uses it: neither side needs it.
- `cellwise_alike` is introduced at 46–47 as "the core's never-parting law holds of any two cells", but it is stated on `cellwise`, not on `Law.run (descent …)`, and no theorem combines it with `ofFn_iterate_cellwise`. Say "read cell by cell".
- Line 12's "independent fluctuations can part alike cells" is proved nowhere. An optional two-cell `noisyDescent` example would pair it with `alike_keeps_weight`.
- Header bullet 3 leaves out the commuting hypothesis (point F8 above).
- "Ismael's (1997; Castellani and Ismael 2016)" credits a co-authored paper to Ismael. Write "(Ismael 1997; Castellani and Ismael 2016)".

**12. Nothing needed was weakened or lost.**
- `lawAt` and `lawAt_invariant` are generalized to a kernel per step.
- `exact_keeps_fixed` is dropped for the reason F1 gives. `cue_fixes` is replaced by the more pertinent `firstCell_fixes`.
- `noisy_nonneg` and `noisy_rows` are gone. Nothing needs them now, so a general `noisy f q` is never shown to be a kernel, and the module claims nothing that needs it.
- `noisy_commutes` is now used by nothing. It is still a valid stand-alone law.
- `partedUniform_exchangeable` only states `Exchangeable partedUniform`, which `parted_rearranged` gives directly. The application of the uniqueness law is in the proof term only. That is fine if the record says it is a model by its proof.

## 4. Classification (72 declarations: 54 theorems, 18 definitions)

- **Results (9 declarations, 8 laws; all known in substance):**
  - `step_invariant` with `lawAt_invariant`, counted as one law.
  - `marginal_eq`, `distinct_le`, `stationary_rearranged`, `unique_stationary_exchangeable`, `noisy_commutes`.
  - `lawAt_noiseless`.
  - `alike_keeps_weight`: this one is new as stated, and holds for any field and noise changing in time.
- **Joins (10):**
  - `ofFn_swap`, `ofFn_rearranged`, `ofFn_cellwise`, `ofFn_iterate_cellwise`, `noiseless_run`, `cellwise_commutes`, `run_rearranged`.
  - `noisyDescent_commutes` together with `noisyDescent_exchangeable`, the headline: one join law, the second being the first through `lawAt_exchangeable`.
  - `cellwise_alike`: the core's never-parting law restated cell by cell and extended to any two cells. It is proved directly, not from `two_alike_stay_alike`.
- **Instances (8):**
  - `lawAt_exchangeable`, of `lawAt_invariant`.
  - `alike_exchangeable` and `pointMass_exchangeable_alike`, of `pointMass_invariant_iff`.
  - `symmetric_rearranged`, of `ofFn_rearranged`.
  - `gibbs_symmetric_exchangeable`.
  - `noisyDescent_distinct_le`, of `distinct_le`.
  - `noisyDescent_from_alike` and `noisyDescent_from_independent`.
- **Facts about a definition (7):** `gibbs_exchangeable`, `independent_exchangeable`, `independent_law`, `alike_fixed` (rfl), `pointMass_invariant_iff`, `pointMass_law`, `noisy_eq_noisyDescent` (rfl).
- **Helpers (9):** `step_nonneg`, `step_total`, `lawAt_law`, `noisyDescent_nonneg`, `noisyDescent_rows`, `step_noiseless`, `Witness.sum_two`, `Witness.parted_rearranged`, `Witness.partedUniform_law`.
- **Witnesses (11):**
  - `partedUniform_not_product`, `commonCoin_commutes`, `commonCoin_not_noisy`, `commonCoin_not_noisyDescent`, `commonCoin_once`, `alike_none`, `each_half`, `commonCoin_stationary_iff`.
  - `partedUniform_exchangeable`: the model of `unique_stationary_exchangeable`.
  - `firstCell_not_exchangeable` and `firstCell_fixes`: the counterexample to the law without an exchangeable field. It also shows that the core's wording "never a cell's number" is loose.
- **Definitions (18):** `rearrange`, `Invariant`, `Exchangeable`, `KernelCommutes`, `step`, `lawAt`, `pointMass`, `marginal`, `Stationary`, `noisy`, `noiseless`, `cellwise`, `noisyDescent`, `Witness.Two`, `Witness.partedUniform`, `Witness.commonCoin`, `Witness.firstCell`, `Witness.flipBy`.

Files: the review, [REVIEW-UE24](REVIEW-UE24.md); the round 2 module, drafted in the session's scratch folder and superseded by round 3, which landed.
