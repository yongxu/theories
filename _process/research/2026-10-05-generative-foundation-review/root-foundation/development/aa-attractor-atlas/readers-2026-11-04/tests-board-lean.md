<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

## Scope and method

- **Read in full:** board lines 25–57 and 84–90, including every open-claims row (parsed column by column), and the tail of the Queue line. Also read in full: `experiments/README.md`, `experiments/formations-that-read/README.md` and that design's "ten minutes" and "candidate core lemmas" parts, 08 §9's theses table, and the "The result" sections of LA4, UE31 and UE32.
- **Skimmed or searched:** the rest of the Queue line (about 22k characters, searched for head clauses), the heads of the other experiment READMEs, the Lean package README rows, the OG2 design §5, WHAT-REMAINS (after-gate lines), 13 record JSONs, the CD design §3, and the module sources (namespaces, imports, line counts, `^theorem` counts by grep).
- **Not done:** I read no FREEZE-*.md in full and checked no frozen hash. I did not read `guardian-anarchy/`, which is local-only by Ren's instruction. I built nothing and ran nothing.

---

## 1. Experiments

### Per folder

| Folder | Board item | What it tests | Frozen | Run | Verdict (README or 08 §9) | Waits on Ren |
|---|---|---|---|---|---|---|
| break-warnings | EW2–EW4 | T6's uncoupled side | `results/FROZEN-AT`: ew2 `44ced15e8`, ew3 `836281856`, ew4 `74204a684` | 21–27 Oct | Not rejected at the frozen thresholds; EW2 at low power with estimates in the refuting direction; EW3 not independent of EW2; EW4 at moderate power | no |
| commons-gated-renewal | CG1 | T1 (gated commons), T3 (own-catch drain) | `3a9806fe5…`, round 2 `d73365d27…` | 20 Oct | The laws hold where their premises hold; selection gap C1; own-catch learner took the last apple 118/118, coupled learner 0/2,360; C2 failed | no |
| commons-outrun | CG2 | T3 (the rest outruns the renewal) | `8a049b4fb` | 20 Oct | 9 of 11 conditions passed; the open side of sharing and the joint learner failed | no |
| commons-outrun-own | CG3–CG3c | T3 limits | `f6a88683d` | 20–21 Oct | 22 of 30 graded passed; no frozen form located the boundary | no |
| commons-outrun-generalizing | EM1 | T3 (CG2 with policy-gradient learners) | `42cf03228` | 22 Oct | The law held course by course; the locked side's bridge failed | no |
| commons-llm-feedback | LA1 | T3's bridge to a stated reward's optimum | `ee2152f38` | frozen 22 Oct, run 25 Oct | Open side passed; locked side failed 2 of 4, misses 92.5–98.2% of best | no |
| commons-llm-feedback-resolved | LA1b | T3 | `bac7f4ac9` | 27 Oct | Every verdict passed; 30/30 locked seeds at the best | no |
| commons-llm-feedback-unaided | LA1c | T3 | `8624daf18` | 28 Oct | Selection prediction passed both sides (29/30 locked, 8/10 open) | no |
| side-effect-benchmarks | SE1 | T3's limits (margin against reachability and attainable utility) | run from `0b158e1b9` | 20 Oct | Matches them; adds nothing as a measure | no |
| margin-measured | MQ1–MQ7 | T1, T2 (MQ1 also T3's side effects) | FROZEN-AT per round | 20–21 Oct | T1: MQ1 and MQ2 passed, MQ2 C1, MQ3 and MQ6 (3/10) failed. T2: MQ4 failed, MQ5 passed, MQ7 missed its bound (0.39, lower 0.00) | no |
| drain-beyond-the-reward | LA4 | T3's clause on trained systems (05 §7) | Stage A `3dc87cf88` (pin `cb8a7475d`); Stage B **not frozen** | Stage A run 3 Nov on Ren's yes (480 runs) | No forbidden case resolved; P1, P4, P5 supported in both tested families; P2, P3 unresolved; P6 supported in the recurrent family, untestable in the feedforward | Stage B: freeze is the LA4 owner's next step; its downloads are a later yes |
| direction-installation | IN1 | T4 | two frozen rounds (README; no FROZEN-AT file found) | 21 Oct | Most round-1 rules failed; with talk, one model kept the told dependent 8/10; no untold dependent kept | no |
| direction-training | IN2 | T4 by fine-tuning | none: "no prediction was frozen" | dropped before any training job | — | no |
| self-rewarding-lock | LA2 (AJ3) | T7 | `36c8b79cb` | 25–26 Oct | Every frozen verdict passed and the bridge failed (one note of the loss among nine readers turned the judge) | no |
| shaping-what-comes-back | LA3 (AJ3) | MA3's `Becoming.RuleShaping` bridge (02's second-order reading); not in 08's T-table | `b3a6b7b66` | 25–26 Oct | K1 and K3 passed, K2 and K4 failed; every missing seed never tried shaping | no |
| valuer-agreement | VD1, VD2 | T5 | frozen rules | 21–22 Oct | VD1: every frozen rule failed. VD2: X1s and X2 passed, X1 and X3 failed | no |
| state-named-in-advance | UE31 | T2 against the field's LPA state (flour beetle) | DESIGN frozen 3 Nov | 3 Nov on Ren's yes | **Nothing decided**: 13 censuses under the loss against the 25 needed; 13 controls reported only | no |
| state-named-in-advance/cells | UE31b | T2, the same 40 cultures read by cell | frozen 3 Nov (`7b7eb6c49`; board: design on main `c6c88b3f2`) | **not run** | Expected answer stated in DESIGN §1 | **yes** |
| state-against-embedding | UE32 | T2 against the field's fitted delay embedding (MQ5 stocks) | DESIGN frozen 3 Nov (no FROZEN-AT file) | 4 Nov on Ren's yes | **T2 better by the frozen criterion**: median r +0.163 against a margin of 0.105, 42/65, p = 0.025 (expected: not separated); both states behind persistence in most stocks | no |
| formations-that-read | RF / RFZ / TR45 / TR71 / TR1 | RF's bridges (next table) | FREEZE-1, 2, 3, 6, 7 | nothing run | — | yes (frozen ones) |
| wenli-reading-transfer | WL, FC1 | 文理生生 H2, not a thesis | DESIGN-H2 pre-registered, **not frozen** (freezing means committing it before any material is shown) | FC1 fidelity measure run 22 Oct; reading test not run | FC1 provisional, coded by language models | needs human readers; not on the Decisions line |
| source-check | SC1 | method: does a model miss what its own text adds | pre-registered | 23 Oct | No author-specific deficit | no |
| agentdojo-evidence-boundary | — | correction-action (6 Oct, before the theses) | `correction-action/FREEZE.json` | 6 Oct | four contexts | no |
| integrated-correction | — | parent of the Lean spine; selective-handoff pilot | `selective-handoff/FREEZE.json` | 6 Oct | — | no |
| learned-claim-agents, recipient-cue-grounding, recipient-value-learning | — | 6 Oct studies and reanalyses (protocols frozen) | protocol freezes | 6 Oct | not T1–T8 | no |
| motor-learning-cost, recipient-harm-valuation | — | 6 Oct reanalyses | — | 6 Oct | descriptive | no |
| circular-construction, market-generativity, shared-renewal-capability, valuation-development | — | engineering, supplied-law models, calculations, a Lean companion | — | — | not tests | no |
| constructed-correction, evaluator-succession, joint-formation | — | only files pinned by path; the rest is in history | — | — | — | no |
| guardian-anarchy | — | local only, untracked by Ren's instruction | not read | | | |

### Theses to tests

Homes and standings are copied from 08 §9.

| Thesis (home) | Standing (08 §9, shortened) | Tests run | Frozen, not run | Gap 08 names |
|---|---|---|---|---|
| T1 ([02#t1](../../../../../../../theories/becoming/chapters/02-MAP.md#t1)) | Proved in the model (regime, whole numbers; World, balanced flow, gate at need `m`); conjectured beyond the model | MQ1, MQ2, MQ3, MQ6, CG1 | — | "no field test of a need measured in advance" |
| T2 (02#t2) | Conjectured, on four frozen fish-stock tests; untested outside fisheries | MQ4, MQ5, MQ7, UE31, UE32 | **UE31b** | outside fisheries (margin-measured "Open") |
| T3 ([05#t3](../../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#t3)) | The law for optima proved; the clause on trained systems conjectured, partly supported | CG1, MQ1, IN1, CG2, CG3, EM1, LA1, LA1b, LA1c, SE1, LA4 Stage A | LA4 Stage B (not even frozen) | language models at scale |
| T4 (07#theses) | IN1 partly passed; transfer untested | IN1 (IN2 dropped) | — | transfer |
| T5 (07#theses) | Reduction proved under net weightings; the bound conjectured | VD1, VD2 | — | human valuers |
| T6 ([03#break-seen-coming](../../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming)) | Invisible half proved on the World; seen half proved in the periphery (linearized, logistic); across domains conjectured | EW1, EW2, EW3, EW4 | — | conditional independence not established |
| T7 (02#t7) | In the model, invariance and the lock outliving the unread proved, "both without noise"; drawn one at a time, locks are left by drift; that actual metrics are so formed is conjectured | LA2 (LA3 related) | — | — |
| T8 (07#theses) | Argued; open: 07 §4.6's P2 and P4, "a reason for C" | none | — | no test possible as stated |

### RF tests

RF's design says each refutes only a bridge or a reading, "never a theorem and never a thesis".

| Test | Law (module) | Freeze | State | Release |
|---|---|---|---|---|
| TR1 | RF1 `Becoming.ShownOrder` (03 §11) | not frozen | Claimed on its own row, `742f2db9a`, branch `tr1-freeze` | — |
| TR2 | RF2 `Becoming.Unread` (a measurement) | FREEZE-7 `24a330677` (Stage B) | frozen | Ren's: ~62 GB download, 4 checkpoints × 12,452 passes, no API |
| TR3 | RF4 `Becoming.Cascade` + `ReachedCascade` (`Turns.acts_alike_along`) | FREEZE-3 `7b78e24cc` | frozen | Ren's: ≤2,766 calls a pin |
| TR4 | RF6.1 `Becoming.OpenedCorrection` | FREEZE-2 `02446e40a` | frozen | Ren's: 560 calls a pin |
| TR5 | RF3 | FREEZE-2 | frozen | Ren's: 747 (927) calls a pin |
| TR6 | RF6.3 `Becoming.ReflexivePrediction` | FREEZE-6 `e889dcc8d` | frozen | Ren's: ~3,974 (≤6,174) calls a pin |
| TR7 | RF7 `Becoming.ReadStages` | not frozen | TR71, branch `tr71-freeze` | — |
| TR8 | RF-M.2 (failure lands on 03's off-switch reading) | FREEZE-1 `0ff7bb75d` | frozen | Ren's: 3,420 calls a pin |
| TR9 | RF-M.3 | not frozen | RFZ keeps it, branch `rfz` | — |
| TR-RR | RR (failure lands on 07's corrigibility reading) | FREEZE-1 | frozen | Ren's: 1,080 calls a pin |

**The Decisions line** names what Ren's yes releases:
- the API runs on three pins: gemini-4-argon and qwen3.8-max decide, Sonnet 5.5 is reported apart; each smoke run goes first;
- about $42 for FREEZE-1 in full, about $9–10 for FREEZE-2, $3.6–6.4 for TR3 and $7–12 for TR6, all before reasoning tokens;
- TR2's downloads and machine time;
- UE31b's single run.

It also says "TR1, TR7 and TR9 are neither frozen nor run."

---

## 2. Board

### Queue

No head clause holds now. The first clause reports TR45's TR2 freeze as landed. The line ends: "Claim on the board before starting; ask the coordinator for a slot."

### Open claims (board lines 45–57)

| Item | Owner | State | Workspace |
|---|---|---|---|
| AJ | Unification and coherence progress, fork 2 (AJ4 held by fork 3) | Many sub-landings (MA2–MA4b, AJ2, AJ4, AJ7, re-syncs). Open in its text: MA4c (condition 1 as restated); "leaving control unselected and leaving a lock in time not shown independent" | `development/aj-joint-selection/` |
| LA4 | "the theory's use in alignment; LA4" | Stage A run; **next: Stage B's freeze** (rival: emergent misalignment from reward hacking); pilot downloads a later yes | `experiments/drain-beyond-the-reward/` |
| OU | Unification and coherence progress (from 28 Oct) | Left after the gate: plan §十三 items 6, 8, 9's institution and 11, "each to be claimed as an item of its own on Ren's word to go past the gate" | `development/one-unfolding-root/` |
| RA | session of the one-unfolding root (coordinating) | Owns `tools/research/theory_graph.py`, `results/THEORY-GRAPH.md`, `results/data/regions.json`; left: DF items, two ids in the retired sense | `architecture/` |
| RP | same | Packet landed; left: Ren's decisions | `development/review-packet/` |
| RF | fork of the 21st review (RFZ calls it "inactive since 31 October") | Laws landed; "a noisy answer and continuous beliefs stay periphery debts" | `development/rf-formations-that-read/` |
| UE31 | Free Energy Principle and self-organization | Run, nothing decided | `experiments/state-named-in-advance/` |
| CD | "Theory status and claims" | Documents landed. **Next edition:** C in pairwise form, plus two Lean renames and sixteen docstrings with a core run, on a row of their own | worktree `.claude/worktrees/reader-measure` |
| UE31b | Free Energy Principle and self-organization | Frozen; run waits on Ren | `.../cells/` (branch `ue31b`) |
| RFZ | "Theory status and claims" | Freezes 1, 3 and 6 landed; open for **TR9** | branch `rfz` |
| TR45 | integration scan | **"done"** (FREEZE-2 and FREEZE-7) | `tr45-freeze`, `tr2-freeze` |
| TR71 | "Names and identity discussion" | claimed `8685ba5e7` (TR7) | `tr71-freeze` |
| TR1 | integration scan | claimed `742f2db9a` | `tr1-freeze` |

### Where an atlas plan could collide

- **RA's theory graph and `regions.json`, and `tools/research/shared_laws.py`.** An atlas data layer overlaps these. By rule 9's logic it should build on them, not beside them.
- **`experiments/README.md` and the Decisions line.** TR1, TR7 and TR9's owners edit both.
- **Lean files waiting for a core run.** CD's renames are `Becoming.Ranking.readings_rank_presence` → `readings_presence_extends` and `Web.widens_iff_every_weighting` → `Web.widens_iff_every_positive`, plus docstrings in Ranking, Weightings, Significance and Regions. The batched pass touches docstrings in `RegimeMargin`, `threshold_regime` and World.lean. WHAT-REMAINS' list for "the next near-full rebuild" covers Grammar, GrammarMap, GrammarLaws, the `Flow.whole_not_keepsWidening` docstring, and PremiseWitnesses, UnitMatchings, RevisionPlans, ReadStages, CountedCodes and Wholes.

### OG2 and institutions

- **OG2 has landed:** `368a8bde7`, 3 Nov 09:53 (+0700), core receipt `20261103T023714.027477Z`, study §501, record `a-rule-rebuilt-from-the-members-it-limits`, home 05 §12. Module `Becoming.RuleRebuilding`: instance ring, 2,030 lines, 207 declarations (147 theorems).
- **Not proved:** a classification of the ends, gaps at `l < s − 1`, the interval the band solves to, a bridge to Flow.
- **Not modelled:** why a teacher turns anyone away, conduct other than entry, sanctions, revision by whom, mixed tenures, schism, records, purposes, capture.
- **OG part 2 is open and unclaimed:** "the two families on the World's flows" (WHAT-REMAINS l.459; `og-organism/DESIGN.md` l.95–132; division "waits for part 2").

### Noise, fixation, pools, second-order widening, C's warrant

No open board row covers any of these. The existing results and their recorded next steps:

| Record | Standing | Next step it records |
|---|---|---|
| `fixation-by-drift` (`Becoming.Drift`, core, counted histories) | recorded-checked | Drift with selection in one draw; mutation; time to fixation |
| `fixation-with-selection` | recorded-checked | Selection in sampled generations; mutation with drift; time to fixation |
| `drawn-shaping-drawn-one-at-a-time` | recorded-checked | Mutation with drift and the time to leave a lock; sampled generations; drift for counts that accumulate |
| `laws-with-noise` | recorded-checked | Laws of the distribution of courses (variance; T6's seen half) |
| `identical-cells-under-noise` (periphery `free-energy/CellsUnderNoise.lean`) | recorded-checked | Densities, Langevin form, a kernel keeping Gibbs weights, "the law in the pure core" |
| `a-pool-read-by-its-majority`, `a-pool-that-recruits-through-itself` | recorded-checked | Recruitment reading part of what lies beyond; a pool whose rule and members are formed through what it reads (with ClosedCapture and MA2) |

- **Second order:** 02's readings [AI reading, D45] at l.442–446 rest on RuleShaping, DrawnShaping, DrawnReplacement and ReadInTime. An anchor `which-locks-noise-leaves` follows them.
- **C's warrant:**
  - `Becoming.ReadsNoOrder.not_entails` is in `Becoming/PremiseWitnesses.lean:161`, L2.
  - The target `universal-practical-warrant` is open; it is one of only four open records, all targets.
  - T8's "a reason for C" is open.
  - AGENTS.md says deriving C from a weaker premise is open work.
  - CD reads C as a direction.

---

## 3. Lean

### Requested modules

Paths are under `…/lean/becoming/Becoming/`. All of these are in the pure core (the checker's `CORE` list), with empty axiom reports required.

| Module | Lines | Layer | Main theorems (README rows, exact names) |
|---|---|---|---|
| RuleCapture | 897 | L1 | `favouring_locks`, `CarrierCounts.margin_course`, `locked_stays`, `perturbation_absorbed`, `uniform_locks`, `Second.second_exact`, `Alternating.alternates`, `Reversed.not_absorbed`, `pair_locks` |
| ClosedCapture | 1000 | L1 | `ClosedCapture.courses_alike_iff_unread`, `.identifiesAlike_iff_unread`, `.lock_outlives_loss`, `.turned_by_loss`, `.both_reads`, `.reading_absorbed` |
| RuleShaping | 926 | L1 | `RuleShaping.favours_iff`, `.grouped_rises_iff`, `.grouped_rises_iff_sized`, `Sized.either_verdict`, `.nothing_back_falls`, `.stretch_iff`, `.threshold_rises` |
| DrawnShaping | 578 | L1 | `DrawnShaping.drawn_reads_iff`, `.drawn_favours_iff`, `.critical_mass_iff`, `.drawn_locked_either`, `.drawn_rises`, `.drawn_falls`, `CriticalMass.few_falls` ("all without noise") |
| DrawnReplacement | 303 | L1 | `DrawnReplacement.steps`, `.fixation`, `.lost_ge`, `.lost_above`, `.fixed_below`, `.one_each`, `.risk_dominant_iff`, `Strong.other_first`, `Weak.shapers_first` |
| ReadInTime | 825 | L1 | `ReadInTime.kept_iff`, `.turned_iff`, `.at_most_one_between`, `.kept_next_round_iff`, `.deadline` |
| Optimum | 9578 | L1 | `Optimum.least_iff`, `.least_of_room`, `Optimum.Shared.room`, `Web.optimum_broken_iff`, `Web.optimum_ends_beyond`, `Flow.keeping_optimum_takes_slack` |
| RegimeMargin | 3721 | L1 | `RegimeMargin.ends_below`, `.holds`, `.ends_iff_below`, `.root_above_need`, `.lowered_raises`, `.rises_superadditive`, `.threshold_regime`, `Adjusted.step` |
| Tolerance | 843 | L1 | `tolerating`, `worst_start`, `restores_iff`, `answers_restores_iff`, `waitsAll_never_restores`, `certified_kept`, `web_tolerating` |
| HeldPossible | 1171 | L1 | `Reaching.not_step_of_grows`, `Run.not_keepsWidening_of_returns`, `Run.changes_of_heldKeepsWidening`, `Oscillating.converse_fails`, `Run.adaptive_rule_changes_of_keepsWidening` |
| ReflexivePrediction | 244 | L1 | `ReflexivePrediction.no_predictor_right`, `.bottom_rests` |
| Weightings (no file `Weighting.lean`) | 6510 | L2 | `Weighting.widens_iff_every_positive`, `.widens_iff_every_of_class`, `.mixed_either_way`, `Web.widens_iff_every_weighting` (to be renamed by CD) |
| Run (no module `Run`) | — | — | `structure Run` at Frame.lean:59 (L0, 277 lines). `Reaching.Possible` and `KeepsWidening` are defined at ReachableRanges.lean:289 and :300 (L1, 1885 lines), with `Run.possible_of_next`, `Reaching.KeepsWidening.not_listed`, `AllAtOnce.converse_fails`. KeepingWidening.lean (L2, 2797 lines) has `Web.KeepsWidening.passes_every_bound` and `Flow.whole_not_keepsWidening` |
| Also relevant | | | Drift 1560 (L1); WeightedCommuting 245 (L1; `Weighted.Pooling.share_rises`); ReachedCascade 139; PremiseWitnesses 662 (L2) |

### Periphery and Mathlib

- **Toolchains:** the core uses Lean 4.29.1 with the prelude only. The periphery uses 4.30.0-rc2 with Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`, from `SYSTEMS_MATHLIB_PROJECT` (default `~/repos/生生不息`, which is built). The pin is kept at `lean/periphery-mathlib-pin/`.
- **Live Mathlib modules:** 18. Only `warning/SlowingDown.lean` imports `Mathlib.Probability` (Moments.Variance, Independence.Basic). Others use MeasureTheory (BorelCantelli, Bochner, the fundamental theorem of calculus), matrices and reals (`LinearBlankets`, `CellsUnderNoise`, `RegimeReals`, `FreeEnergyReals`).
- **Probability in that Mathlib:**
  - Kernel (composition and powers, Invariance, Irreducible, Ionescu-Tulcea). Irreducible's docstring reads its kernel as "the transition kernel of a Markov chain".
  - Martingale (Convergence, OptionalStopping, OptionalSampling, Upcrossing).
  - Process (Filtration, Stopping, HittingTime).
  - PMF (incl. Binomial), StrongLaw, CentralLimitTheorem.
  - I searched for a packaged discrete Markov-chain theory (stationary distributions, absorption probabilities) and found none.
- **Fixation in the core uses no probability:** Wright–Fisher and Moran-type fixation (`Drift`, `DrawnReplacement`, `fixation-with-selection`) is done by weighing counted histories in natural numbers.

### Focused checks

- **Working build of one module:** `python3 -B …/becoming/scratch_build.py TREE [MODULE …]`. It compiles only the module's import closure, reuses passed steps from `~/.cache/becoming-lean` and audits the named modules' axioms. It "is not a receipt". `LEAN_TIMEOUT` defaults to 1800 s.
- **Landing:** `check_becoming.py` with the cache recompiles only changed modules and their dependents. Use `BECOMING_JOBS=1` and a higher `LEAN_TIMEOUT` under load.
- **Avoid touching the base:** a change to Grammar, GrammarMap or GrammarLaws "recompiles nearly every module", and World.lean's bytes "rebuild nearly the whole core". A new leaf importing few modules is cheap.
- **Periphery module:** its own `check_<name>.py`, which imports `check_becoming as core`. Axioms `propext`, `Classical.choice` and `Quot.sound` are allowed and reported per declaration; `sorryAx` fails the run.
- **Registering a core module (OG2's pattern):** the root `Becoming.lean` bullet, the checker's `CORE` list and `SCOPE`, both package READMEs, `regions.json`, the layer label by `layers.py`, and a record with home anchor `r-<id>`.

### Receipts

- **Core receipt:** `becoming-verification.json`. Fields include `status`, `utc`, `source_commit` (main hash plus copied files), `source_sha256` per module and `lean_steps` (ran, reused, keys). The run folder is `becoming-checks/<UTC>/`, 503 kept. The current receipt is `20261103T211917.845905Z` (TRL), with 365 core modules and 383 in the spine.
- **Records bind receipts** through `proof_bindings` (`sha256_pointer "/source_sha256/Becoming.X"`, `success_value "passed"`). A record is `recorded-checked` only with a passed receipt carrying the exact source hash.
- **Re-points** use `tools/research/repoint.py`, which logs to `_process/architecture/rebinds.jsonl`.
- **Periphery receipts** are `<name>-verification.json` with their own `-checks/` folders.

---

## 4. False, stale or contradictory

1. **The board's "Now" (l.28) names a stale latest receipt.** It says "the latest core receipt is HE2's `20261031T054654.692180Z`". The receipt file's `utc` is `20261103T211917.845905Z`.
2. **The way now's item 1 (l.32) is stale.** It says "if ready before the freeze, OG2, since the fronts say an institution has no model yet". OG2 landed at `368a8bde7` (09:53, 3 Nov), before the freeze `13ea8ddb6` (16:15). The fronts now say "one kind of institution … one minimal model" (ONE-PAGE.md:38; THE-THEORY-OF-BECOMING.md:195).
3. **The OU row is stale and may conflict with AGENTS.md.** It still lists "item 9's institution" as left; WHAT-REMAINS l.459 records OG2 as landed. It also says post-gate items wait "on Ren's word to go past the gate". AGENTS.md's "Still his" list does not include that, so the coordinator should settle it.
4. **`experiments/README.md` l.29 misleads about TR2.** It says "TR8, TR4, TR5, TR3 and TR6 frozen … the rest not frozen", which omits TR2's Stage B (FREEZE-7, `24a330677`). `formations-that-read/README.md` and the board both say TR2's Stage B is frozen.
5. **The overview contradicts itself on T3.** THE-THEORY-OF-BECOMING.md:195 lists "T3 varying how near a trained system comes to its optimum" among the "tests still to run". Its own l.22 and 08 §9 report LA4 Stage A, which did vary nearness. Line 195 was last touched at `368a8bde7`, before LA4's run commit `1c6a8733e` (12:21). Only Stage B, on language models, is still to run. I did not check the zh edition.
6. **Two rows name TR1.** The TR71 row's title "TR7, then TR1" and its line "TR7 lands before TR1 opens" were not updated after TR1 got its own row (`aca848d45`: "TR71 keeps TR7"). Only TR71's owner may edit that row.
7. **Rule 4 hygiene.**
   - TR45 is "done" but still in the open-claims table.
   - RFZ's State cell still reads "claimed … on `efe3ba2cf`" although its item text records three freezes landed.
   - RF's owner has been inactive more than three days, so by rule 4 that claim has lapsed but was not moved.
8. **Minor date slip on the Decisions line.** It says "LA1b, LA1c, LA2 and LA3 have all run (26 to 28 October)"; the experiments README says LA2 and LA3 ran 25–26 October.