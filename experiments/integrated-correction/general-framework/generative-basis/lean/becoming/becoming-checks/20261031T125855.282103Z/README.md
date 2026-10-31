# Core receipt 20261031T125855.282103Z: every Lean step run

This receipt is the one a verifier can repeat ([the twenty-first review](../../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-TWENTY-FIRST-REVIEW.md#6-errors-overstatements-and-stale-text-found), §6 item 9; RV21c). It was made with `BECOMING_FRESH=1` on an empty step cache kept for this slot alone, so every one of its 1455 keyed Lean steps ran here, none was reused, and each step's log (with each audit step's driver) is in this folder. It ran on main `7396ceddb`, which held every source byte for byte, so nothing was copied (`source_commit` names the commit, `source_sha256` each file).

**To repeat it.** On that commit, with Lean 4.29.1 (`elan`, the package's `lean-toolchain`; the binary's sha256 is `lean_binary_sha256`):

    cd experiments/integrated-correction/general-framework/generative-basis/lean/becoming
    BECOMING_FRESH=1 BECOMING_LEAN_CACHE=$(mktemp -d) python3 -B check_becoming.py

and compare the new run with this one. On any machine the declarations and axiom reports in `verification.json`, the printed types in the `*Signatures.log` files of this folder, and `source_sha256` must agree. The step keys (`lean_steps.keys`) agree only with the same Lean binary, since they hash its sha256 (`lean_binary_sha256`); `lean_version`, `lean_binary_sha256`, the stamps and the paths may differ.

**The core-bound records.** Each record's proof binding keeps, as its provenance, a core run that checked the bound bytes; none was re-pointed. This run rebuilt every core file present on main at `7396ceddb` from nothing, so for every core binding whose source is a package file on main at that commit it is the run a verifier repeats. The exceptions bind copies kept inside old run folders and keep those runs as their only receipt: wisdom-root (`20261013T125626.097616Z/Becoming.RegroupingSelection.lean`); wisdom-root (`20261013T132140.261612Z/Becoming.RegroupingSelection.lean`). Modules added after that commit are checked by later receipts, not by this one.

**The periphery receipts of the same slot.** The periphery receipts whose closures had changed since their last run were rerun one at a time after this receipt, on the same slot cache. A checker reused a step only where an earlier run of this slot under the same toolchain (this receipt's run, or an earlier periphery checker's) had run it and kept its log; the keys hash the toolchain and the Lean binary, so the checkers on v4.30.0-rc2 share none with this receipt. Each reused step names the run it came from (`lean_steps.reused`, `utc`), and that run's folder holds its log; the table counts them by run. The `retained` paths there name the landing worktree, which became this repository; read them by stamp.

| receipt | toolchain | steps run | steps reused, by the run they came from |
|---|---|---|---|
| [fallible-inquiry](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/fallible-inquiry-checks/20261031T130828.999853Z/verification.json) | v4.29.1 | 5 | core 40 |
| [correction-inquiry](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/correction-inquiry-checks/20261031T131415.384434Z/verification.json) | v4.30.0-rc2 | 371 | none |
| [machine-instances](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/machine-instances-checks/20261031T131812.213702Z/verification.json) | v4.29.1 | 29 | core 48 |
| [learning-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/evolution-connectionism/learning-correspondence-checks/20261031T131847.549129Z/verification.json) | v4.30.0-rc2 | 9 | correction-inquiry 41 |
| [copying-instances](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/copying-instances-checks/20261031T131950.855717Z/verification.json) | v4.29.1 | 14 | core 13 |
| [retrodiction-instances](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/retrodiction-instances-checks/20261031T132046.721958Z/verification.json) | v4.29.1 | 5 | core 2, machine-instances 12 |
| [market-instances](../../../../../../../../experiments/market-generativity/formal/market-instances-checks/20261031T132103.724349Z/verification.json) | v4.29.1 | 10 | core 40 |
| [protocol-instances](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/protocol-instances-checks/20261031T132145.271099Z/verification.json) | v4.29.1 | 15 | core 11 |
| [versioned-task-instances](../../../../../../../../experiments/market-generativity/meta-attractor/versioned-task-instances-checks/20261031T132223.713396Z/verification.json) | v4.30.0-rc2 | 11 | correction-inquiry 22, learning-correspondence 1 |
| [shared-stock-instances](../../../../../../../../experiments/market-generativity/meta-attractor/shared-stock-instances-checks/20261031T132907.790736Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 30 |
| [continuation-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/systems-complexity/analysis/continuation-correspondence-checks/20261031T132923.838546Z/verification.json) | v4.30.0-rc2 | 6 | correction-inquiry 11 |
| [transmission-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/evolution-connectionism/transmission-correspondence-checks/20261031T133044.516133Z/verification.json) | v4.30.0-rc2 | 7 | correction-inquiry 32, learning-correspondence 3 |
| [preparation-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/preparation-correspondence-checks/20261031T133608.754102Z/verification.json) | v4.30.0-rc2 | 10 | correction-inquiry 48 |
| [judging-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/judging-correspondence-checks/20261031T133748.088094Z/verification.json) | v4.30.0-rc2 | 9 | correction-inquiry 45 |
| [renewing-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/renewing-correspondence-checks/20261031T133811.050699Z/verification.json) | v4.30.0-rc2 | 6 | correction-inquiry 16 |
| [substitution-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/substitution-correspondence-checks/20261031T133836.069337Z/verification.json) | v4.30.0-rc2 | 6 | correction-inquiry 45 |
| [organization-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/generative-capacity/organization-correspondence-checks/20261031T133859.385075Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 26, versioned-task-instances 1 |
| [living-organization-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/universal-ethics/living-organization-correspondence-checks/20261031T133915.555151Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 7 |
| [prefix-safety-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/prefix-safety-correspondence-checks/20261031T133925.659050Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 18 |
| [finite-branching-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/finite-branching-correspondence-checks/20261031T133936.018674Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 40 |
| [selection-relabel-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/acquisition/feedback/remaining-dependency/formal/selection-relabel-correspondence-checks/20261031T133952.181485Z/verification.json) | v4.30.0-rc2 | 6 | correction-inquiry 35 |
| [ideals-correspondence](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/ideals-correspondence-checks/20261031T134003.600817Z/verification.json) | v4.30.0-rc2 | 7 | correction-inquiry 36, prefix-safety-correspondence 1 |
| [entropy-production](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/physics/entropy-production-checks/20261031T134022.206464Z/verification.json) | v4.30.0-rc2 | 4 | correction-inquiry 29 |
| [cells-under-noise](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/cells-under-noise-checks/20261031T134056.109386Z/verification.json) | v4.30.0-rc2 | 4 | correction-inquiry 90 |
| [expected-free-energy-reals](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/expected-free-energy-reals-checks/20261031T134130.030892Z/verification.json) | v4.30.0-rc2 | 5 | correction-inquiry 58 |
| [free-energy-reals](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/free-energy-reals-checks/20261031T134204.303683Z/verification.json) | v4.30.0-rc2 | 3 | correction-inquiry 57, expected-free-energy-reals 1 |
| [regime-reals](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/regime/regime-reals-checks/20261031T134231.224593Z/verification.json) | v4.30.0-rc2 | 4 | correction-inquiry 65 |
| [representation](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/representation/representation-checks/20261031T134302.467521Z/verification.json) | v4.30.0-rc2 | 4 | correction-inquiry 41 |

**Mathlib** is used by the checkers on v4.30.0-rc2 only: the pinned build, never rebuilt here, revision `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa` (https://github.com/leanprover-community/mathlib4.git), with leanprover/lean4:v4.30.0-rc2, as those 22 receipts record (`mathlib_revision`). A verifier fetches it by that pin. The checkers on Lean 4.29.1 use no Mathlib.

**Older-layout receipts.** 2 records bind receipts written before run folders under a pointer, whose closures held `FormedSelection.lean` at bytes from before 8 October (one `set_option` line added to drop a propext dependency). After the periphery, their chain was rerun by its own checkers on Lean 4.29.1 with Std, the formal receipt they inherit from first, a failure stopping the chain; a checker that passed rewrote its `verification.json` in place, the earlier bytes in git history and their hashes in `_process/architecture/rebinds.jsonl`, and kept its run's files in a new folder under `checks/` beside it where its checker writes one. Axiom reports are compared module by module with the earlier receipt's.

| receipt | passed before | now | audits | axiom reports changed in | records |
|---|---|---|---|---|---|
| [formal](../../../../../../../../experiments/shared-renewal-capability/regulation/retention/formation/formal/verification.json) | 2026-10-31 | 2026-10-31 | 135 → 135 | none | 0 |
| [evolution](../../../../../../../../experiments/shared-renewal-capability/regulation/retention/formation/evolution/verification.json) | 2026-10-07 | 2026-10-31 | 90 → 90 | ConsequenceTransmission, FormationRoot, FormedSelection | 1 |
| [evolution/development](../../../../../../../../experiments/shared-renewal-capability/regulation/retention/formation/evolution/development/verification.json) | 2026-10-07 | 2026-10-31 | 107 → 107 | ConsequenceTransmission, DevelopedResponse, FormationRoot, FormedSelection | 1 |

Not renewed, because no record binds them: 39 live receipts outside this chain that record `FormedSelection`, `ResourceContinuation` or `FormationSupport` at bytes other than main's. A later rerun of any of them would meet the new hashes.

- `experiments/integrated-correction/general-framework/generative-basis/lean/acquired-perspective/verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/inquiry-root/core-tree-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/inquiry-root/inquiry-repair-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/construction/prediction/acquired-record-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/construction/prediction/receipt-identification-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/construction/prediction/verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/construction/updater/verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/construction/verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/stochastic-prediction/verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/lean/learning/verification.json` (FormationSupport, FormedSelection, ResourceContinuation)
- `experiments/integrated-correction/general-framework/generative-basis/lean/systems-complexity/analysis/adaptive-verification.json` (ResourceContinuation)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/coformation-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/criterion-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/initiation-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/nondual-verification.json` (ResourceContinuation)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/purpose-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/root-verification.json` (ResourceContinuation)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/scope-verification.json` (FormedSelection)
- `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/verification.json` (ResourceContinuation)
- `experiments/shared-renewal-capability/regulation/retention/formation/learning-interface/recording/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/learning-interface/recording/reason-replay/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/learning-interface/recording/reason-replay/protection/claims/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/learning-interface/recording/reason-replay/protection/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/plasticity/formal/inquiry-revision/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/plasticity/formal/pretraining-evidence/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/plasticity/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/application/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/formal/history-interface/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/review-history/independent-final-formal-audit/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/publication-safety/formal/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/transport/calibration/pre-import/formal/verification.json` (FormedSelection)

Also stale in the same files, and kept as evidence of earlier attempts rather than live receipts (no checker beside them, or a folder named as an earlier attempt): 3.

- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/plasticity/development/formal-correspondence-before-binding-fix/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/application/formal/review/first-attempt-name-resolution/verification.json` (FormedSelection)
- `experiments/shared-renewal-capability/regulation/retention/formation/selectors/updaters/prediction/recipient-correction/identification/recording/reason-consumer/action/revision/evaluation/succession/application/formal/review/verification.json` (FormedSelection)

**Left out.** No cache, `.lake` or `.build` is kept, and no compiled `.olean`: the logs and drivers are what a verifier needs to repeat and compare the runs, and the outputs are rebuilt from the sources. Nothing else was left out.
