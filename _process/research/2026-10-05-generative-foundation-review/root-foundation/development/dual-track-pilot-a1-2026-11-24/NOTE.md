# Dual-Track Pilot Cleanup & Track A1 Core Compression Note

> AI-written (24 November 2026). Prepared inside `landing1-cleanup-a1`; no human has read this note yet.

## 1. Pilot Cleanup (Honest Scope & Zero-Axiom Fixes)

1. **`Becoming.DoubleKernel` & `Becoming.OplaxHistory` — Resolved `SumPreservingFunctor` Finite-Rigidity Vacuity:**
   - **Proved (`0` core axioms, `PreludeOnly`):** `Becoming.OplaxHistory.sumPreserving_finPres_chi_bijective` shows constructively that any `SumPreservingFunctor` maps finite types (`FinPres`) canonically to `(- × F Unit)` (`prodUnitToF_isBijective`) and therefore always makes the oplax comparison map `chi` bijective on finite spans (`H.W`, `K.W`, `D`, `PullbackElem H.right K.left`).
   - **Fix in `DoubleKernel.lean`:** `GuardedExpr.assemble`, `GuardedProof.assembleCong`, `GuardedProof.chiStep`, `GuardedProof.chiInv`, `evalGuardedExpr`, `evalGuardedProof`, and `guarded_oplax_sound` now quantify over general `OplaxHistory.SpanFunctor` (aligning with `guarded_alignment/oplax_history.py`).
   - **Constructive non-invertible finite witness (`0` axioms):** `Becoming.OplaxHistory.inhabitedOptionFunctor` (`X ↦ Option (PLift (Nonempty X))`) yields `inhabitedOptionFunctor_chi_not_surjective` and `Becoming.DoubleKernel.finite_non_invertible_chiStep_witness`, strictly separating one-way `chiStep` from BC-guarded `chiInv` on finite spans.

2. **`Becoming.OplaxHistory.exactCausal_lifts_implies_chain_lift`:**
   - Strengthened `exactCausal_lifts_implies_chi_surjective` to lift full macro step chains via `exactCausal_lifts_implies_chain_lift` (using `ProcessStepWitness.ext`), keeping `exactCausal_lifts_implies_chi_surjective` as a 2-line corollary.

3. **Prose & Record Precision (`CANONICAL-MAP.md` & `master-alignment-spine-and-sharpness.json`):**
   - Tightened L5 sharpness descriptions from claiming premise-by-premise necessity ("isolate each dropped safeguard") to concrete failure-mode witnesses ("exhibit concrete failures of individual safeguards"), and recorded explicitly that `MasterSpine`'s `WholeBecomingWitness` uses constant `Nat.zero_lt_one` for `reproduces_when_viable`.

---

## 2. Track A1 Compression ("Generalize Below, Not Beside")

Token counts measured on comment-stripped Lean source via Python lexer tokenization (`re.findall(r'\w+|[^\s\w]', ...)`):

### A1-a — Clamped-Subtraction Overdraw Arithmetic
- **Extracted shared foundation in `Becoming.StockFlowBridge`:**
  - `clampedStep_balance_discrepancy`: `x' = (x - d) + u → x' + d = (x + u) + (d - x)` (using `Becoming.add_sub_turn_add`, with `Prelude.lean` untouched).
  - `clampedStep_balance_iff_le`: `x' + d = x + u ↔ d ≤ x`.
- **Refactored downstream callers:**
  - `Becoming.UnifiedDrawdown`: `unit_balancesOn_iff_le`, `unit_overdraw_separation`.
  - `Becoming.EvolutionaryDrawdown`: `multiSite_balance_site_iff`, `multiSite_overdraw_separation`.
- **Measured compression (old 4 declarations vs. new 4 declarations + 2 shared `StockFlowBridge` helpers):**
  - Proof bodies (split at true proof-body delimiters after statement `let` binders): **`1,742 → 1,007` tokens (`-42.2%`)**
  - Total tokens (signatures + bodies): **`2,748 → 2,097` tokens (`-23.7%`)**
  - Line count: `165 → 140` lines (`-15.2%`)
- **Held-out generalization test (no new helper needed; reuses `Becoming.total_congr`, `Becoming.total_add`, and `Becoming.le_total_of_mem`):**
  - `list_clampedStep_imbalance_eq_sum_overdraw` and `list_clampedStep_exact_balance_iff_all_covered` (`29` lines, `382` total / `203` body tokens) establish aggregate multi-site overdraw conservation over arbitrary finite `ks : List Site` even when replenishment `u k` depends on all residual stocks.

### A1-b — Heterogeneous `OpenComponent` Contract Replacement
- **Extracted shared theorem in `Becoming.OpenComposition`:**
  - `replace_contract_viable` (general two-component contract-preserving replacement lemma, placed alongside `contractRefines_compose_left` / `contractRefines_compose_right`).
- **Refactored callers (all exact public signatures preserved for all 7 core callers):**
  - `replace_left_viable`, `replace_right_viable`, and the `nil` branch of `composeList_replace_head_viable`.
- **Measured compression:**
  - `replace_left_viable` + `replace_right_viable` (+ `replace_contract_viable`): proof bodies **`806 → 326` tokens (`-59.6%`)**, total **`1,824 → 1,730` tokens (`-5.2%`)**.
  - All 3 target callers (+ `replace_contract_viable`): proof bodies **`1,328 → 710` tokens (`-46.5%`)**, total **`2,818 → 2,586` tokens (`-8.2%`)**, lines `227 → 205` (`-9.7%`).
  - Both `replace_left_viable` and `replace_right_viable` retain their standalone `InterfaceContract.preCapExt` / `eta` public signatures unchanged so downstream proofs (`AlignmentSpine`, `MasterSpine`, `UnifiedDrawdown`, `PolyComposition`, etc.) stay unbroken.

---

## 3. Cold-Read Summary (For Ren, ≤ 1 Page)

- **Why this landing exists:** Before adding new mathematics (mathlib TV contraction & Krylov distinguishability in Landing 2), we removed two fragile spots in the U6/core codebase and tested whether unifying duplicate proof logic *below* callers ("generalize below, not beside") genuinely shrinks the trusted core without loosening public guarantees.
- **Headline Check 1 (`DoubleKernel` & `OplaxHistory`):** `GuardedExpr.assemble` previously restricted macro functors to `SumPreservingFunctor`, which we proved (`0` axioms) forces finite-span `chi` to be a bijection (`sumPreserving_finPres_chi_bijective`), making the guarded oplax obstruction vacuous on finite types. Relaxing `GuardedExpr`/`GuardedProof` to general `SpanFunctor` and adding `inhabitedOptionFunctor` restores a genuine `0`-axiom finite obstruction between one-way `chiStep` and guarded `chiInv`.
- **Headline Check 2 (`StockFlowBridge` A1-a):** Pulling `Nat`-clamped subtraction discrepancy into `clampedStep_balance_discrepancy` / `clampedStep_balance_iff_le` cut proof-body tokens across `UnifiedDrawdown` and `EvolutionaryDrawdown` by **`42.2%`** (`-23.7%` total) and immediately proved arbitrary coupled-list aggregate balance conservation (`list_clampedStep_exact_balance_iff_all_covered`) as a held-out corollary.
- **Headline Check 3 (`OpenComposition` A1-b):** Factoring `replace_contract_viable` cut proof-body tokens across `replace_{left,right}_viable` and `composeList_replace_head_viable` by **`46.5%`** while leaving every downstream caller signature untouched.
- **Receipt & periphery status:** All six modified core modules and dependent downstream modules are verified under core receipt `20261124T112343.843972Z` (`435` closure / `414` core modules, `0` axioms, `PreludeOnly` PASS, `0` new `market_names`), dependent periphery modules (`AlignmentReals`, `BecomingReals`, `ObservationalFidelity`) refreshed with `stale_count: 0`, and `proof_uses` / `shared_laws` / `repoint.py` bound cleanly prior to Commit B. Human reading by Ren remains open.
