# Re-check of UE21's fold

30 October 2026. AI-written, independent, read-only re-check of how [REVIEW-UE21](REVIEW-UE21.md)'s findings were folded.

**Read:** the module (sha256 `8eb26998…`), `NOTE.md`, `scratch-2.log` and the kit's five files.

**Built.** All builds ran with `scratch_build.py` against main `cf5202bd7`.
- **The module.** 56 theorems in 66 declarations, every axiom report empty, no warnings. The audited names are identical to those of the scratch-2 build.
- **A probe of 10 theorems**, two of which restate prelude lemmas to read their axioms.
  - A client in namespace `Becoming` that opens the module uses `bound`, `powerProduct`, `joint`, `record_total`, `bound_lt_of_not_proportional` and `given_record_eq_iff_share` unqualified.
  - It also holds R1's law, with an empty report.
- **Names.** Every `FreeEnergyCounting.*` name in `texts_ue21.py` and `integrate_ue21.py` is a declaration of the build, and so is every module name in the study text and NOTE (NOTE §6's `two_parts_eq` is the old name, named as such). `make_records_ue21.py --caps` (writes nothing) covers all 66 declarations in 15 laws with no lint error.

## Verdict

The fold is sound, and no sentence contradicts the Lean.
- **Taken:** F1, F2, F3, F6 and F7.
- **Taken in part:** F4, F5 and F8.

Two small statements still say more than the Lean (R1, R2), and one phrase from F6 survives (R3). Land after R1–R3. R4–R6 can go with them.

## Findings

### R1 (S). A general claim with one witness

"Where the record weighs nothing, every count belief is at the bound" is stated generally but proved only by `Witness.nothing_record_reach`, a single belief. It appears in the module docstring (lines 43–45), `given_record_eq_iff`'s docstring, NOTE §1, the study's Delta (4), the record's last law, and, uncited, the 03 §6 theorem paragraph.

**Fix.** Add this theorem beside `given_record_eq_iff` and cite it in each of those places. It compiled in the probe under `open ConditionalWeights FreeEnergyCounting`, with an empty report.

```lean
theorem nothing_record_reach_all {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α)
    (os : List β) (rec : β → Bool) (n : α → Nat)
    (nothing : mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) = 0) :
    total hs n ^ total hs n * powerProduct (joint prior lik os rec) n hs =
      mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total hs n *
        powerProduct n n hs :=
  (given_record_eq_iff prior lik hs os rec n).2 fun h mem => by
    rw [nothing, Nat.mul_zero,
      zero_of_total_zero (joint prior lik os rec) hs
        ((record_total prior lik hs os rec).symm.trans nothing) h mem, Nat.zero_mul]
```

### R2 (S). The readings drop "listed once"

NOTE §1's reading, the kit's 03 §6 reading and the study's Readings say the bound is reached exactly at, or in proportion to, the shares given the record, without the hypothesis that `given_record_eq_iff_share` needs.

**Fix.** In each, after "where the record weighs something", insert ", with the hypotheses listed once".

### R3 (S). "The same law" survives F6 in three places

- **The study's Readings:** "The periphery's real form is the same law, read through the logarithm, for real shares".
- **The new record's `related` entry for free-energy-bounds-surprisal:** "the same bound over the reals".
- **The root bullet:** "the bound exponentiated … Its real form is the periphery's `FreeEnergyReals`", with no conditions.

**Fix.** Use the wording below.
- **Study:** "For count beliefs with a positive total on the support, the periphery's real form is this bound read through the logarithm (by hand). The real form also covers real shares, and off the support the two differ."
- **`related` entry:** "Its bound over the reals: for count beliefs with a positive total on the support, this one through the logarithm."
- **Root bullet:** "the bound exponentiated, for a positive total", and "Its real form, agreeing with it on the support, is the periphery's `FreeEnergyReals`".

The module's Modelling choices and the record's second hypothesis make the support a condition of the reading, though the module says (lines 26–29) that off it the bound holds as usually defined. In both, write "as UE17's real form, on the support".

### R4 (I). Two duplicates remain, and one stale name

NOTE §6 says the duplicates are gone and no core name is shadowed, but two remain. `total_zero` is the core's `Becoming.total_zero` (Flow, in the closure), with the same statement and proof; a client in namespace `Becoming` gets the core's. `zero_of_mul_eq_zero` is `Nat.mul_eq_zero.mp`, whose report is empty in the probe. Separately, the arithmetic section's docstring and NOTE §2 list `Nat.succ_ne_zero` among the laws "proved here", but no declaration replaces it.

**Fix.** Drop both theorems (56 → 54) in favour of `Becoming.total_zero` and `Nat.mul_eq_zero.mp`, remove `Nat.succ_ne_zero` from the sentence, and correct NOTE §6.

### R5 (I). 08 §8 keeps the old standing

`texts_ue21.py` writes "the weighted arithmetic–geometric mean inequality (Cauchy 1821; Hardy, Littlewood and Pólya 1934)". The module, NOTE §4, the record and 03 §6 now say that in counts Cauchy's unweighted inequality suffices.

**Fix.** "…has a counting form, Cauchy's arithmetic–geometric mean inequality in counts (1821), a count being a repetition, stated in the pure core with its case of equality `([03 §6](…))`."

### R6 (I). Wording

- **The record's degenerate-cases law.** "every weight nothing, or every count nothing, puts every belief at the bound" becomes "every weight nothing puts every count belief at the bound; with every count nothing both sides are one".
- **`Witness.unitPrior`'s docstring** also names a likelihood; it is the prior only.
- **`Witness.total_two_unreached`'s docstring** says "the share given the record" where there are only weights: say "the shares in proportion to the weights".
- **The alias "method of types"** names a technique, not this law: use "multinomial likelihood at the observed frequencies".
