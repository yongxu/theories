# Lean Unification Wave U1: Unified Periphery Manifest, Gate/Catalogue Wiring, `SlowingDown` Bridge, and Core Tidyings

AI-written (Session 1 `18d6300c`, 24 November 2026). First wave of Lean whole-picture unification (`U1`–`U5`), consolidating periphery builds/receipts, bridging `SlowingDown` onto `Becoming.RegimeMargin`, and applying verified core hygiene and FM tidyings without altering any existing public theorem signature.

## Core & Periphery Receipts

- **Core receipt:** `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json` (`utc: 20261123T212116.218407Z`, `status: passed`, Lean `4.29.1`, `core_compiles_from_prelude: true`, `425` modules, `21,150` theorems, `29,269` declarations, `nonempty_core_axioms: []`).
- **Active periphery manifest (`periphery-manifest.json`, `10` modules, `0` stale via `make lean-check-stale`):**
  1. `AlignmentReals` (`alignment-reals`, `20261123T212649.960965Z`, `leanprover/lean4:v4.30.0-rc2` + Mathlib)
  2. `FreeEnergyReals` (`free-energy`, `20261123T212814.991308Z`, `v4.30.0-rc2`)
  3. `ExpectedFreeEnergyReals` (`free-energy`, `20261123T212837.635520Z`, `v4.30.0-rc2`)
  4. `CellsUnderNoise` (`free-energy`, `20261123T212852.082687Z`, `v4.30.0-rc2`)
  5. `LinearBlankets` (`free-energy`, `20261123T212921.315107Z`, `v4.30.0-rc2`)
  6. `EntropyProduction` (`physics`, `20261123T212956.066878Z`, `v4.30.0-rc2`)
  7. `RegimeReals` (`regime`, `20261123T213015.518810Z`, `v4.30.0-rc2`)
  8. `Representation` (`representation`, `20261123T213039.620138Z`, `v4.30.0-rc2`)
  9. `SlowingDown` (`warning`, `20261123T213101.896904Z`, `v4.30.0-rc2`, bridged to `Becoming.RegimeMargin` via `drawn_safe_with_regime_holds` & `regime_below_threshold_vs_need_not_read`, `24` thms / `32` decl audits / `68` inherited core deps)
  10. `Becoming.FallibleInquiry` (`becoming`, `20261123T213115.489029Z`, `leanprover/lean4:v4.29.1`)

## Changes Made in Wave U1

1. **Core doc hygiene & FM tidyings (`Becoming.lean`, `Keeping`, `PredicateIteration`, `Tolerance`, `LevelAlone`, `HistoryIdeals`, `CausalGrowth`, `Undecided`, `WideningOnTheMap`, `Refinement`, `Contacts`):**
   - Deduplicated all `23` duplicate module bullets in `Becoming.lean` losslessly and added the missing `Becoming.FromTheDynamics` (`L2`) bullet (`421` imports == `421` unique bullets).
   - Added `Viability.keptFor_one_iff` & `keptFor_one_iff_change_reading` (`Keeping`), `Iteration.prefixed_above_iter` + `iter_within` simplification (`PredicateIteration`), `withheld_kept` call via `prefixed_above_iter` (`Tolerance`), `silent_at_start_iff_use_of_stays_below` (`LevelAlone`), and `6` cheap search/refutation calls (`least_true_or_below`, `searchBelow_or`, `each_or_some`, `new_in_list_or_none`, `not_not_within`, `mem_or_not`).
2. **Periphery toolchain/manifest/gate unification:**
   - Added explicit `lean-toolchain` (`v4.30.0-rc2`) files in all `6` active Mathlib periphery directories.
   - Created `periphery-manifest.json` and `check_periphery.py` (`--all`, `--module`, `--stale-only`, `--check-stale`).
   - Wired `lean-check`, `lean-check-periphery`, `lean-check-all`, and `lean-check-stale` into `Makefile` and `MAP.md`.
   - Extended `tools/research/gate.py:receipt_check` to audit every active manifest receipt (with unit tests in `test_gate.py`).
   - Excluded scratch `tmp/` from `tools/research/lean_catalogue.py` (`EXCLUDED`), added `"becoming-periphery"` group (`periphery_paths()`), registered all `9` active Mathlib periphery modules in `theories/becoming/results/data/regions.json`, and updated `test_indexes.py`.
