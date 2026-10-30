# Re-check of UE22 after the review

30 October 2026. AI-written, read-only re-check of the revised UE22 draft against [REVIEW-UE22](REVIEW-UE22.md), by the agent that wrote the review. Not reviewed by a person.

**Read.**
- The revised `FreeEnergyReals.lean`, whole, and its diff against main.
- The revised SCOPE in `check_free_energy_reals.py`.
- This folder's NOTE.md, DependencyAudit.lean, dependency-audit.log, scratch-3.log, scratch-4.log and LANDING.md.
- The kit: `make_records_ue22.py`, `texts_ue22.py`, `study_ue22.txt` and the `STATEMENTS` in `board_ue22.py`.
- The core's `FreeEnergyCounting.lean`, for its sentences on the real form off the support.

**Built and ran.** Lean 4.30.0-rc2 with the pinned Mathlib, against the revised module as compiled in the drafting build. Its sha256 is `43cc055f…`, the same as the worktree file. Probes are in `/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue22review/recheck/`.
- **A copy of the revised module** compiles with no error or warning. `#print axioms` on two of the new declarations shows Lean's three standard axioms.
- **The study's DependencyAudit.lean**, rerun from a copy, prints a log identical to `dependency-audit.log`.
- **An extra audit pass** covers the two join theorems the study's list leaves out:
  - `proportional_iff_posterior` reaches none of the targets in either pass;
  - `counts_eq_mul_exp` reaches the two exponential bounds only through the logarithm's definition.
- **The five added theorems** I compared (`surprisal_le_freeEnergy_iff_bound`, the three `record_…_of_counts` and `…_toReal_of_counts`, and `Witness.one_count_off_support`) match the review's compiled text exactly, up to whitespace. `Witness.gap_counts_duplicate` is the review's statement and proof with the probe's unused `have` dropped. `Witness.gap_counts_off_support` carries the four conjuncts with qualified names.
- **A new probe**, `ProbeOneCountTwo.lean`, shows that at one count on the hypothesis of weight nothing, against weights nothing and two, the identity holds while the real bound is strict (N1).
- The two drafting receipts passed: 70 theorems in 76 declarations, and `ExpectedFreeEnergyReals` with 12 in 21.

## The findings, one by one

| Finding | Status | What remains |
|---|---|---|
| F1, the dependency claim | **taken** | Two small precision points (N3, N5). |
| F2, "off the support the identity fails" | **taken** | Its one-count clause overreaches (N1). The fault is in my own suggested wording. |
| F3, the witness's statement and citation | **taken** | Nothing. |
| F4, the real-number equality | **taken** | One docstring still cites the lemma, not the new theorem (N4). |
| F5, the generative model's bound and strictness, and the two bounds as one | **taken** | Nothing. |
| F6, what each hypothesis does | **taken** | The optional weaker hypothesis for `proportional_iff_posterior` was not taken; that is acceptable. |
| F7, what the join does not reach | **taken** | Nothing. |
| F8, records and texts at landing | **taken** | `c_dns0` carries N1, and its one-count clause cites no witness. |
| F9, the reading's conditions | **taken** | Optional: two short summary phrases on the principle's page drop the conditions (N6). |
| F10, docstring and SCOPE smaller points | **taken** | Cosmetic reflow only (N6). |
| F11, citations | **taken** | The board row's base text still reads "F7"; `STATEMENTS` corrects it at landing. |
| F12, UE17's "fails" sentences | **taken** | The module, the SCOPE, the record's third law, its first counterexample and 03 all say "can fail". |
| F13, placement and naming | nothing was asked | Nothing. |

**Notes on F1–F12.**
- **F1.**
  - The module's sentence now states only what the audit checks. "None of these four reaches `surprisal_le_freeEnergy`, `term_le` or Mathlib's `Real.log_le_sub_one_of_pos`" is true. So is "with that definition left unexpanded these reach neither it nor its strict form", where "it" names `Real.add_one_le_exp`.
  - NOTE §1 gives the full account and attributes the nonnegative-argument observation to the review.
  - The SCOPE, the kit's second law, the 03 §6 edit and Delta (2) no longer say "without Gibbs' inequality".
  - The audit now has:
    - the unknown-target stop and the positive control;
    - all the Gibbs targets and both exponential bounds;
    - the stop-node pass over eleven join theorems.

  Its log reproduces exactly.
- **F2.** "Can fail" is in place everywhere: the module, NOTE, SCOPE, records, texts, study and board `STATEMENTS`. `Witness.one_count_off_support` and the exact condition for the identity off the support are in. See N1.
- **F3.** The restated witness's statement carries the gap `−2 log 2`, the two sides of the counting bound (nothing and one) and the log ratio `0`. Neither NOTE nor the kit cites UE21's witness for it any longer.
- **F4.** `freeEnergy_eq_record_surprisal_iff_toReal_of_counts` is in the module, and the counting bullet cites it.
- **F5.** `record_surprisal_le_freeEnergy_of_counts`, `record_surprisal_lt_freeEnergy_of_counts` and `surprisal_le_freeEnergy_iff_bound` are in, and the bullet, NOTE, SCOPE and kit name them.
- **F6.** NOTE §1, §3 and §4 state each hypothesis's role, citing `Witness.gap_counts_duplicate`, the probe for total nothing, and the off-support witnesses.
- **F7.** The module's "what is not derived" names irrational weight ratios and the record of weight nothing; so do NOTE §3 and the kit's new does-not-show item. NOTE §3 also notes the minimization over every total.
- **F8.** The kit now brings:
  - "Share.toReal and its three lemmas";
  - a formal-reuse dependency on free-energy-bound-in-counts, naming the reused declarations (with `powerProduct_self_pos`, which the new theorem uses);
  - "over hypotheses listed once" in both `related` details;
  - counterexamples as in F3;
  - counts of 29 new declarations over 76.
- **F9.** NOTE §1's first paragraph and its reading, the study's readings, and the 03, 08 and page edits carry the conditions.
- **F10.** Done: the introduction's conditions, "these four", the commitments (natural counts, `0 ^ 0 = 1`), the hypotheses of `surprisal_lt_freeEnergy_of_counts`, "the exponential of the total times that divergence", and `freeEnergy_congr_weights` named.
- **F11.** "F6, with F7(a)" is in NOTE, the study and the board `STATEMENTS`. Cover and Thomas (Theorem 11.1.2), Csiszár and Körner, Cauchy, Gibbs and Kullback–Leibler are cited where named. The classical equivalence is stated exactly.

## New problems

### N1 (error, from the review's own wording). "At one count the real form is at equality" needs the weights to total one

**Where.**
- The module's counting bullet: "at one count, on a hypothesis of weight nothing, it holds, the real form at equality and the core's bound strict (`Witness.one_count_off_support`)".
- The witness heading: "Off the support with one count the identity holds and the two equalities part".
- SCOPE: "at one count off the support it holds while the real form is at equality and the core's bound strict".
- NOTE §1, "What each hypothesis does": "at one count the real form is at equality while the core's bound is strict". NOTE §3 and §6 F2 echo it.
- The kit:
  - `make_records_ue22.py`: the fourth law, the first new counterexample and `c_dns0`;
  - `texts_ue22.py`: the 03 §6 edit of UE21's sentence;
  - `study_ue22.txt`: Delta (5) and the review paragraph.
- The source is REVIEW-UE22 F2, whose suggested texts dropped the condition.

**What.** Take one count on a hypothesis of weight nothing, against a total weight `A`.
- The identity holds; both sides are `log A`.
- The free energy is `0` and the surprisal `−log A`. So the real form is at equality exactly where `A` is `0` or `1`, and strict where `A ≥ 2`.
- The core's bound is strict where `A ≥ 1`. At `A = 0` it is at equality too, both sides nothing.
- So the two cases of equality part exactly at `A = 1`, as at UE21's witness (weights nothing and one).
- Against weights nothing and two, the identity holds and the real bound is strict (`ProbeOneCountTwo.lean`, compiled).
- On the small cases (the review's ranges), the 57 one-count off-support cases split as follows:
  - 6 with `A = 0`: both at equality;
  - 8 with `A = 1`: the real form at equality, the core strict;
  - 43 with `A ≥ 2`: both strict.

So the clause is true at the witness and overgeneral as written. The conclusion, that off the support the two cases of equality can part even where the identity holds, stands as an existential claim.

**Fix.** Prose only; no statement changes.
- **Module bullet:** "at one count, on a hypothesis of weight nothing, it holds, and where the weights total one, as in `Witness.one_count_off_support`, the real form is at equality while the core's bound is strict, so off the support the two cases of equality can part even where the identity holds."
- **Witness heading:** "**Off the support the identity can hold while the two equalities part**". Its body already names UE21's counts.
- **SCOPE:** "and at one count off the support it holds, the real form at equality and the core's bound strict where the weights total one."
- **NOTE §1:** "at one count against weights totalling one the real form is at equality while the core's bound is strict (`Witness.one_count_off_support`)". In NOTE §3 and §6, write "can part".
- **The kit:**
  - fourth law: "at one count off the support it holds, and against weights totalling one the real form is at equality while the core's bound is strict";
  - counterexample: "at one count it holds, and against weights totalling one the real form is at equality (Witness.one_count_off_support)";
  - `c_dns0`: "and at one count, where it holds, the real form can be at equality while this bound is strict (FreeEnergy.Witness.one_count_off_support)";
  - 03 §6: "…holds off the support, at one count, the real form can be at equality while this bound is strict…";
  - Delta (5) and the review paragraph: as the fourth law.
- **The Chinese texts:** the same condition, for example 权重总和为一时.

### N2 (precision of a pending item). The core's off-support witness docstring is false at its own counts

**Where.** `FreeEnergyCounting.lean`:
- line 668, the docstring of `Witness.off_support`: "the real form of `FreeEnergyReals`, under Mathlib's `log 0 = 0`, fails there instead";
- line 29: "fails there", cited to that witness.

NOTE §5 and the study's "Decisions" call this "`FreeEnergyCounting`'s sentence that the real form 'fails' off the support".

**What.** `Witness.off_support` is the counts `first` against `secondOnly`. There the real form holds, at equality: `Witness.one_count_off_support` now proves it. So the core's sentences are not merely general; at the cited witness they are wrong. UE22 rightly changes no core file.

**Fix.** In NOTE §5 and the study, name the item exactly: "`FreeEnergyCounting`'s docstring and `Witness.off_support`'s say the real form fails at that witness, where it holds at equality (`FreeEnergy.Witness.one_count_off_support`); correct both at that module's next change". Put the item on the board's pending list so the core's next change picks it up.

### N3 (minor). The audit's list leaves out one of "these four"

**Where.** The module bullet's audit sentence covers four theorems, including `proportional_iff_posterior`. DependencyAudit.lean's `joins` list does not include it.

**What.** The claim is true: my extra pass shows `proportional_iff_posterior` reaches none of the targets in either pass, since it has no logarithm. But its evidence is not in the study's log.

**Fix.** Add `(`Becoming.FreeEnergy.proportional_iff_posterior, [])` to `joins`, regenerate the log, and say "twelve" in NOTE §1.

### N4 (minor). One docstring still cites the lemma for the real-number form

**Where.** The docstring of `freeEnergy_eq_record_surprisal_iff_of_counts`: "as real numbers, that is where the belief in counts is the share given the record, as `freeEnergy_eq_record_surprisal_iff` states (`Share.same_iff_toReal_eq`)".

**Fix.** Replace "(`Share.same_iff_toReal_eq`)" with "(`freeEnergy_eq_record_surprisal_iff_toReal_of_counts`)".

### N5 (minor, from the review's own wording). NOTE §3 says the proofs reach `x + 1 ≤ exp x` only through the logarithm's definition

**Where.**
- NOTE §3, Shows: "reaching `x + 1 ≤ exp x` only through the definition of the logarithm". This is REVIEW-UE22's suggested text.
- NOTE §6, F1: "neither form of `x + 1 ≤ exp x`".

**What.** Outside the definition, the proofs do reach that inequality for `x ≥ 0` (Mathlib's private `Real.add_one_le_exp_of_nonneg`, through `Real.exp_strictMono`), as NOTE §1 itself says. What they do not reach outside the definition are the lemmas for every `x`.

**Fix.**
- NOTE §3: "reaching `Real.add_one_le_exp` (`x + 1 ≤ exp x` for every `x`) only through the definition of the logarithm".
- NOTE §6: "neither `Real.add_one_le_exp` nor `Real.add_one_lt_exp`".

### N6 (optional, cosmetic)

- **Docstring reflow.** The reflow of the quantities bullet left a 156-character line (line 27), and the counting bullet has a short line before "The log ratio is `N` times". Lines over 100 characters already occur in UE17's code, so no checker objects.
- **Two summary phrases on the principle's page** drop the conditions: the table cell "the real form its logarithm" and the Standing line "the real form read from it through the logarithm". "On the support" would make them exact.
- **SCOPE's "(two-hypothesis witnesses)"** fits the duplicate witness loosely, since it lists one hypothesis twice. "(witnesses)" suffices.
- **The board row's "the counting ratio its exponential"** is loose. It means the exponential of `N` times the gap; a `STATEMENTS` entry could say so.

## Verdict on landing

**The Lean is sound, and the module is ready.**
- The revised module compiles cleanly.
- The six theorems are the reviewed ones.
- The witnesses state what their docstrings say, except N1's heading.
- The audit reproduces.
- Every finding of REVIEW-UE22 is taken.

**Land after N1.** It is prose in the module docstring, the witness heading, SCOPE, NOTE and the kit, with no Lean statement changed. The module's bytes change, so the landing checker run, which LANDING.md already plans, covers it. Take N2–N5 with it; they are a pending-item wording, one audit row, one docstring citation and two NOTE phrases. N6 is optional. No further re-check is needed if N1's replacement texts are used as given.
