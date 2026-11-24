# Lean Unification Wave U4 — `Becoming.ActiveInquiryLoop`, `Becoming.EndogenousOrder`, and `Becoming.EvolutionaryDrawdown` (2026-11-24)

*AI-written (Session 1 `18d6300c`), 24 November 2026. Records what was built, proved, audited, and machine-checked in Wave U4 on branch `lean-unite-u4` (base `main` at `2a29cf1ff`, Commit A `e85b85e18`).*

---

## 1. Core & Periphery Verification Receipts

| Target | Receipt UTC | Outcome | Key Audited Metrics |
|---|---|---|---|
| **Unified Core (`becoming`)** | `20261124T040228.916780Z` | **passed** | `Lean 4.29.1`, `432` modules in `core_closure` (`411` `core_modules` incl. `Becoming`), `core_compiles_from_prelude: true`, `non_empty axiom_dependencies: {}`, `21,644` theorems, `30,296` declaration audits (`Becoming.ActiveInquiryLoop`: `62` thms / `143` decls / `3200` L; `Becoming.EndogenousOrder`: `122` thms / `231` decls / `3652` L; `Becoming.EvolutionaryDrawdown`: `64` thms / `123` decls / `2649` L), `0` warnings, `0` `sorry`, `0` private decls, `0` new `market_names` |
| **All 10 Periphery Modules (`check_periphery.py --stale-only` + `make lean-check-stale`)** | `20261123T234535Z` – `20261123T235037Z` | **passed** | `total: 10`, `stale_count: 0`, `failed: []` |
| **Independent Diff Audit (`72501bec`)** | Read-only review | **PASS** | `0` remaining blocking defects across Commit A after fixing `modeSwitch_enables_assorted_persistence` / `LagSplit` substrate coupling and `EvolutionaryDrawdown` docstring; `layers.check` passed (`ActiveInquiryLoop = L1`, `EvolutionaryDrawdown = L2` through `Becoming.UnifiedDrawdown`, `EndogenousOrder = L2` direct naming `Unrestricted`); `Becoming.lean` `428` imports == `428` bullets == `428` `README.md` rows |

---

## 2. Three New Core Pillars (`2a29cf1ff -> e85b85e18`)

1. **`Becoming.ActiveInquiryLoop` (`L1`, `62` thms, `143` decls, `0` axioms) — Closes Priority P4 (Active Experiment Design, Cascade Capture, Delays & Thresholds, and Blankets):**
   - **Variable-draw exploration–margin sandwich (`Part 1`):** Models probe vs. operate schedules via `ActiveInquirySpec`, `inquiryPolyComponent`, `inquiryContract`, and causal `probeTranscript` (`ExploreMarginInv`, `exploration_margin_sandwich_viable`) vs. epistemic-silence collapse (`exploration_untaken_silence_collapse`), passive learnability underdetermination (`learnable_passive_underdetermined`), limit-verification delay obstruction (`limit_passive_delay_obstruction`), and coupling-deadline impossibility (`exploration_deadline_impossibility`), instantiated in `ActiveProbeWitness`.
   - **Cascade pool alarm capture (`Part 2`):** Contrasts indexed list-pool viability (`composeList_viable_indexed`) against information-cascade and reached-cascade alarm capture (`cascade_list_emitAlarm_alike`, `reachedCascade_list_emitAlarm_alike`, `cascade_list_capture_collapse`, `cascade_pool_capture_collapse`, `CascadePoolWitness`).
   - **Coupling distance & threshold blindness (`Part 3`):** Proves `coupling_distance_obs_alike` and `coupling_distance_turning_obstruction` on `clockedPolyComponent`/`clockedPolyContract` (`DelayObstructionWitness`), and bridges `ExchangeLaw.ReadsBelow` to open-loop collapse (`network_threshold_blindness`, `threshold_blind_open_collapse`, `network_readsBelow_feeds_open_collapse`, `ThresholdBlindnessWitness`).
   - **Blanket-to-`OpenComponent` interface screening (`Part 4`):** Packages sensory alarm ports (`BlanketContractSpec`, `componentOfBlanket`, `contractOfBlanket`), proving `blanket_compose_closed_viable`, `blanket_compose_screening`, `blanket_isolation_necessary_for_determined_parts`, and `blanket_parts_not_openComponent_realizable` (`SparseRelayBreachWitness`).

2. **`Becoming.EndogenousOrder` (`L2`, `122` thms, `231` decls, `0` axioms) — Closes Priority P3 (Endogenous Order Formation, Scope Co-Evolution, Course Nash Obstruction, and Metaethical Firewall):**
   - **Constructive online `OrderUpdater` & three structural limits (`Target 1`):** Proves convergence to `Weighting.IncreasingInOwn` (`ranksNet_increasingInOwn_of_bounds`, `adaptive_order_converges_increasingInOwn`, `adaptive_ranks_converges`, `adaptive_order_joins_coupledEnding`), paired with Limit 1 off-support reversal (`online_off_support_reversal`, `online_weight_learner_reverses_off_support`), Limit 2 uncoupled zero-weight blindness (`uncoupled_zero_weight_forever`, `uncoupled_blindness_firewall`), and Limit 3 finite-horizon and `MacroAdmits` comparability bypassing `Flow.persists_not_listsAdmitted` (`adaptive_order_ranks_horizon`, `macroAdmits_restores_comparability`, `OnlineWeightWitness` + `OWPersist`).
   - **Endogenous scope co-evolution & substrate-coupled emergence thresholds (`Target 2`):** Joins `PolyComposition` dynamic `ScopeMode` switching (`timely_modeSwitch_viability_kernel`, `wide_modeRefines_narrow`, `timely_modeRefines_viability_kernel`) to `SelectionLevels` and `GroupEnding` (`falls_iff_kept`, `assorted_wide_scope_emerges`, `unassorted_myopic_trap`) and bridges both via substrate tracking in `modeSwitch_enables_assorted_persistence`, witnessed in `ScopeCoEvolutionWitness` (`AssortmentSplit`, `AssortmentLineage`, and `LagSplit` `gatedWeb`/`gatedFlow`/`gatedGen`).
   - **`Web`/`Flow`-grounded course-menu Nash obstruction & reciprocal gate restoration (`Target 3`):** Defines `CourseRealization` over `downFrom horizon`, relates `PureNash` to `RoutesToC.MutualBest` (`sym_pureNash_iff_mutualBest`), derives `course_menu_widening_nash_obstruction` and `reciprocal_gate_restores_viable_nash`, and matches `OpenComposition` trajectories step-by-step in `CourseNashObstructionWitness` (`ocRun_matches_gated_or`).
   - **Metaethical firewall (`Target 4`):** Packages `EndogenousOrderSystem` (`Type 0`) and proves `endogenousOrder_admits_rival` and `endogenousOrder_cannot_entail_unrestricted` (`EndogenousFirewallWitness` joined with `Clearing.center_not_derived`).

3. **`Becoming.EvolutionaryDrawdown` (`L2`, through `Becoming.UnifiedDrawdown`, `64` thms, `123` decls, `0` axioms) — Closes Priority P5 (Derived Selection-to-Drawdown, Multi-Site Exchange Bridges, and Compositional Transitions):**
   - **Derived selection-to-drawdown (`EmbodiedConversion`, Target 1):** Derives cohort uptake floors (`derived_cohort_uptake_ge`), selection surpluses (`derived_surplus_of_selection_within`, `derived_surplus_of_selection`), rising uptake floors (`derived_uptake_floor_rises`), exhaustion (`derived_regime_exhausts_within`, `derived_line_grows_and_ends`), bounded impossibility (`embodied_selection_surplus_impossible_past`), and finite-horizon collapse (`derived_surplus_drawdown_collapse`), witnessed in `DerivedEmbodiedDrawWitness`.
   - **`[DecidableEq Ext]`-free multi-site `OpenComponent` ↔ `Flow.BalancesOn` / `World.ReadOffExchange` bridge (`Target 2`):** Constructively embeds multi-site `MultiSiteRelatum` dynamics into `Flow.BalancesOn`/`Balances` (`multiSite_balancesOn_of_preOverdraw`, `multiSite_balances_of_global_preOverdraw`), proves substantive `requires` on `World.ReadOffExchange` (`multiSite_run_readOffExchange`, `closedProcess_guard_readOffExchange`, `closedProcess_kernel_readOffExchange`), and separates post-overdraw divergence (`multiSite_overdraw_separation`, `MultiSiteBridgeWitness`).
   - **Compositional major evolutionary transitions & multi-level selection (`Target 3`):** Joins `Founding.Flow.ConfinedRise` (`unintegrated_confined_takeover_ends`), `OpenComposition.hide`/`hideContract` (`openComponent_hide_seals_internal_viability`), within-vs.-among selection shift (`compositional_transition_shifts_selection`), and `Founding.Nested` sequestered whole-level selection (`nested_transition_raises_among`), witnessed in `MajorTransitionWitness`.

---

## 3. Source & Receipt Checksums (`e85b85e18`)

- `Becoming/ActiveInquiryLoop.lean`: `7a5103b1c5069896182bf846d27bfd27b732902380f1d2f711df5cd3f48cb6f1`
- `Becoming/EndogenousOrder.lean`: `8e03226f29101afce5ca456ee2786aa31d1fb558399d2ef3d69c2e003b94cb34`
- `Becoming/EvolutionaryDrawdown.lean`: `6e8cd6d9f93938acd0880b2fb2c20a0382f683983f2facd0e1b13397299a059b`
- `becoming-checks/20261124T040228.916780Z/verification.json`: `1153220f72736cd77aea46dfa060b27b36450042b3dc0db9f632e2ccaf3d0ad0`

---

## 4. Next: Wave U5

- **`Wave U5` (Upcoming):** `Becoming.MasterSpine` (uniting the core Becoming pillars beyond the alignment slice + K6 + `GrammarMap` lifts), unified `BecomingReals` Mathlib periphery (absorbing `ScratchRenewalBridge`), and full `COVERAGE.json` / `CANONICAL-MAP.md` sync.
