# Review of UE21: the free-energy bound in counting form

30 October 2026. AI-written, independent, read-only review.

**Read.** AGENTS.md; this folder's `NOTE.md`, `scratch-1.log`, the module and the draft `kit/texts_ue21.py`; `Becoming.ConditionalWeights` and `Becoming.Prelude`; UE17's `FreeEnergyReals.lean`, record, review and recheck; 03 §6, 08 §8, `FREE-ENERGY-PRINCIPLE.md`, `FEP-INTEGRATION.md` and the board row; every live text matching "counting form" or "core form".

**Built.** With `scratch_build.py` against main at `cf5202bd7`, in my own scratch tree, I built:
- a copy of the module (sha256 `6d032378…`, identical to this folder's): no error or warning, 58 theorems in 65 declarations, every axiom report empty;
- a probe module importing it: 32 theorems in 40 declarations, every report empty except ten that restate Init lemmas in order to read their axioms (F4).

My closure has 57 modules and `scratch-1.log`'s has 58, because the log's closure still held `Becoming.KeptOnward`, which HE retired. The branch now merges main, and the module builds the same on it. A Python check of 4,368 small cases compared the counting law with UE17's real form.

## Verdict

The Lean is sound. Its statements say what the docstrings say, except where F3 notes otherwise, and I found no error. `bound` holds for every listing, counts and weights, `0 ^ 0 = 1` included. I could not break `bound_eq_iff`: it is exact, and its degenerate cases are consistent with the core's `⟨0, 0⟩`.

What overreaches is the free-energy reading in NOTE §1, §3 and §4 and in the kit's texts. It drops conditions that UE17's own record carries (F1, F2).

**Land after F1–F3**, which need prose and two short theorems. F4–F8 can go with them or follow. A periphery join theorem is not needed for landing (F6).

## Findings

### F1 (S). The reading drops three conditions

**Where.** NOTE §1 (the reading), §3 ("minimizing free energy over count beliefs is conditioning, in the core") and §4 ("Refutation"); the module docstring's fourth bullet; in the kit, 03's thesis ("reaches it, for beliefs in counts with no axiom"), the new reading and the page's "In brief".

**What holds:**
- **A record weighing nothing.** Where `A = 0`, both sides are 0 for every belief with a count, and `n h * 0 = 0 * N` puts every count belief "in proportion". This agrees with the core, where `⟨0, 0⟩` is the same ratio as any share, but leaves no conditioning to reach. UE17's `next_delta` and RECHECK-UE17 R3 say "equal, where the record weighs something, exactly at the share given the record"; UE21's texts lose the clause.
- **No counts.** `N = 0` is no belief; both sides are 1.
- **One total.** Equality needs `n h = a h · N / A`, so at total `N` the bound is reached only where `A` divides `N · a h` at every hypothesis. Against weights 1 and 2, every belief of total 2 is strict (16 < 36, 8 < 9, 4 < 36); the counts 1, 2 reach it (108 = 108). Over count beliefs of every total the least free energy is the surprisal, reached exactly in proportion (`posterior_counts_reach` gives one). The Lean states which beliefs reach the bound, not a minimization.
- **§4** says the reading "would fail only if exponentiation did not preserve order". It also fails off the support, where UE17's bound fails and this one holds (F6), and in the two cases above.

Probe witnesses, each decided or proved with an empty report and checkable by hand: `zero_weights_reach`, `nothing_record_reach`, `no_counts_reach`, `total_two_unreached`.

**Fix:**
- NOTE §3: "the count beliefs at the bound are exactly those in proportion to the joint weights; for a positive total, a record that weighs something and hypotheses listed once, exactly those at the share given the record (F2). Read through the logarithm, the least free energy over count beliefs of every total is the surprisal, reached only there; at one total it may not be reached."
- NOTE §1 and the kit's reading: "…for every belief in counts with a positive total, where the record weighs something…".
- NOTE §4: "what could fail is the reading, which needs a positive total, the support and a record that weighs something".
- 03's thesis: "…reaches it; in counts the bound and its equality hold with no axiom;".
- Module docstring: "Where the record weighs nothing, both sides are nothing for every belief with a count, and every belief is in proportion, `⟨0, 0⟩` being the same ratio as any share (`ConditionalWeights.Share.zero_whole`)."

### F2 (S). `given_record_eq_iff` does not state "in proportion to the shares given the record"

**Where.** NOTE §3 ("exactly those in proportion to the shares given the record"); in the kit, the 03 §6 theorem, the page's §1 edit and the regions note. NOTE §1 says it exactly ("the parts of the shares").

**What the Lean says.** It states proportion to `joint h`, the part of `posterior_single`'s share. Going on to the share needs `posterior_single`, and so `Distinct hs`, which no UE21 theorem assumes.

With a duplicate, the step fails (probe `duplicate_share`, decided). List `[h₁, h₁, h₂]` with every weight 1:
- the counts 1 everywhere are at the bound;
- `⟨n h₁, N⟩` is `⟨1, 3⟩`;
- `h₁`'s share given the record is `⟨2, 3⟩`.

UE17's record names "hypotheses listed without repetition" for this reason.

**Fix.** Add the theorem below, which has an empty report. Wherever the texts say "shares given the record", cite it and say "hypotheses listed once".

```lean
theorem given_record_eq_iff_share {α β : Type} [DecidableEq α] (prior : α → Nat)
    (lik : α → β → Nat) {hs : List α} (os : List β) (rec : β → Bool) (n : α → Nat)
    (distinct : Distinct hs) :
    total n hs ^ total n hs * powers (joint prior lik os rec) n hs =
        mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total n hs *
          powers n n hs ↔
      ∀ h, h ∈ hs → ConditionalWeights.Share.Same ⟨n h, total n hs⟩
        (ConditionalWeights.share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))) :=
  (given_record_eq_iff prior lik hs os rec n).trans
    ⟨fun prop h mem => by
      rw [ConditionalWeights.posterior_single prior lik os rec distinct mem]
      show n h * _ = _ * total n hs
      rw [← ConditionalWeights.evidence prior lik hs os rec]
      exact prop h mem,
     fun same h mem => by
      have s := same h mem
      rw [ConditionalWeights.posterior_single prior lik os rec distinct mem] at s
      rw [ConditionalWeights.evidence prior lik hs os rec]
      exact s⟩
```

### F3 (S). A general claim cited to a witness, and an "exactly" that is one direction

- **Strictness.** The module docstring (line 32) and NOTE §1 say "away from proportion it is strict (`Witness.strict_off_proportion`)". That is a general claim resting on one witness. Add this theorem (empty report):

```lean
theorem bound_lt_of_not_proportional {α : Type} (n a : α → Nat) (hs : List α)
    (apart : ¬ ∀ h, h ∈ hs → n h * total a hs = a h * total n hs) :
    total n hs ^ total n hs * powers a n hs < total a hs ^ total n hs * powers n n hs :=
  Nat.lt_of_le_of_ne (bound n a hs) (fun eq => apart ((bound_eq_iff n a hs).1 eq))
```

- **`two_parts_eq`.** Its docstring says "reach the bound exactly in proportion" and NOTE §2 says "reached exactly where". The theorem proves only that equality forces `n * b = a * m`. Write "only in proportion", or rename it `proportional_of_two_parts_eq` to match `proportional_of_bound_eq`.

### F4 (I). Nine helpers re-prove axiom-free laws already in the closure

NOTE §2 says each helper is proved because the prelude's version uses `propext` or is not stated there. That is wrong for nine of them. The probe's audit shows:
- **In Lean's prelude, with empty reports:** `Nat.eq_of_mul_eq_mul_left`, `Nat.mul_lt_mul_of_pos_left`, `Nat.mul_lt_mul_of_pos_right` and `Nat.lt_of_add_lt_add_left`.
- **In `Becoming.Naturals`, with empty reports:** `pow_add`, `mul_right_comm`, `add_left_cancel`, `add_right_cancel` and `le_of_add_le_add_left`.

These duplicate:
- `eq_of_mul_eq_mul_left_eq`, `mul_lt_mul_left_of_pos`, `mul_lt_mul_right_of_pos` and `lt_of_add_lt_add_left_eq`;
- `pow_add_eq`, `mul_right_comm_nat`, `add_left_cancel_eq`, `add_right_cancel_eq` and `le_of_add_le_add_left_eq`.

`pow_add_eq` and `mul_right_comm_nat` even repeat the core's proofs.

The suffix `_eq` is inexact on lemmas concluding `≤` or `<`, and `Nat.lt_of_mul_lt_mul_left` also uses `Quot.sound`, which the docstring omits.

**Fix.** Use the existing laws and drop the nine (58 → 49 theorems), or correct the sentence.

### F5 (I). `total` and `powers` shadow core names

The core already has two declarations with these names:
- `Becoming.total` (Prelude): a total over a list, with the arguments the other way round, joined to `mass` by `ConditionalWeights.mass_eq_total`;
- `Becoming.powers` (Resolution).

A module in namespace `Becoming` that opens `FreeEnergyCounting` gets those two instead. The probe's first build failed on `total n hs` for this reason.

**Fix.** State the law over `Becoming.total` with a bridge to `mass`, or rename both (for example `productOfPowers`), or tell clients in the docstring to qualify them.

### F6 (I). The correspondence, the support claim and the join

- **Exact on the support.** Take `N > 0`, `q = n/N`, `p = a`, and `q` zero where `p` is.
  - UE17's `surprisal_le_freeEnergy` reads `−log A ≤ Σ (n/N)(log(n/N) − log a)`. Multiplying by `N` and exponentiating gives `bound`, and `freeEnergy_eq_surprisal_iff` gives `bound_eq_iff`.
  - A zero count contributes `0^0 = 1` to both products and `0` to the sum.
  - On all 2,295 supported small cases, `N·(F − S) = log(RHS/LHS)`, and equality held exactly in proportion.
- **"No support condition, unlike the real form": right as stated.**
  - Off the support, the counting law agrees with the free energy as usually defined (`log 0 = −∞`), not with UE17's `freeEnergy`.
  - The real form failed in 1,010 of the 1,908 off-support cases; the counting law held in all of them.
  - Say beside the claim that off the support the two modules' laws are not one law. This is also why "the same law read through the logarithm" (NOTE §1) needs F1's conditions.
- **Normalization.**
  - UE17's join reads the joint weights as shares of the whole weight `W` and bounds by the record's share. Here the total is the record's weight `E`.
  - Both sides shift by `log W`, so the two bounds coincide.
  - One sentence in the record would stop "the record's surprisal" being read as `−log E`.
- **A join theorem: not required.** NOTE §3 names it as not shown, and with F1's wording the reading stays a correspondence by hand. Add it at `FreeEnergyReals`' next change, with F7(a).

### F7 (I). Stale texts that NOTE §5 does not list

- (a) `FreeEnergyReals.lean`'s docstring says the bound has a counting form "checked on small cases in REVIEW-UE17, not proved here". Point it to this module, pending that module's next change.
- (b) `ConditionalWeights.lean`'s docstring is already pending (UE17 NOTE §6). It says "no reciprocal-share form" and "with no receipt yet", and lists "free energy or its bound" as not derived. Add UE21 to that pending item.
- (c) conditioning-by-restriction's `correspondence` says that "free energy and its bound are stated in the periphery". Add "and the bound in counts in the core (free-energy-bound-in-counts)". A "related" history line alone leaves it stale.
- (d) UE17's record: besides `next_delta` and the fourth item of what it does not show, add the new record to `related`.
- (e) The board row's purpose, "the free-energy principle's core quantity lives in the pure core", says more than the module does: the core states the bound in counts, not free energy.

The placement itself is right: a leaf on `ConditionalWeights`, with the record after free-energy-bounds-surprisal in 03 §6.

### F8 (I). Standing

Nothing is claimed as new beyond the axiom-free proof. Two additions would help a reader:
- **The counting form is Cauchy's unweighted inequality (1821).** Apply it to `N` terms, with `a_h/n_h` taken `n_h` times; a count is a repetition, so the weighted form is not needed.
- **The free-energy reading is one of two classical readings of one inequality.** With `a/A` read as a model and `n` as observed counts, `bound` says `∏ (a/A)^n ≤ ∏ (n/N)^n`. That is, the observed frequencies maximize the multinomial likelihood (maximum likelihood; the method of types, Cover and Thomas 2006, §11.1). Name both readings in the record's standing.

**Names otherwise.** `bernoulli` has a precedent in `Evolution.price`, and `joint` and the `Witness` names are exact. The readings carry their labels.
