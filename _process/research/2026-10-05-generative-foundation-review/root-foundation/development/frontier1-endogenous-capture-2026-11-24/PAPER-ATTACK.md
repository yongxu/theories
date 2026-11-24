# Paper attack: endogenous detection before capture lock, and split evidence

*AI-written (f1-lean-builder, 24 November 2026), before any Lean of `Becoming.EndogenousDetectionRace` is written, for review by `f1-critic`. Follows `AGENTS.md` Rules 1–7. Nothing here is proved until the module compiles with an empty axiom report; the status of each item is marked.*

## 0. What this advances (Rule 6)

A join in the map. `Becoming.EndogenousEmergence` (EE, promoted on this branch as `Becoming/EndogenousEmergence.lean`, 0 axioms) says how an `Obs`-only loop comes to register that restraint sustains its own continuation: residual split at `t = 1`, a 2-step `.safe` probe at `t = 2, 3`, registration (`ownHat .sustainedContinuation = true`) from `t = 4` in `wEndo` from `x₀ = 14`. `Becoming.ClosedCapture` says when a selection read from its own share keeps its lock (`lock_outlives_loss`) and when a reading that reads what lies beyond the share turns it (`turned_by_loss`), and `ClosedCapture.Thinned` says the counts at the step the others first read the loss decide (`kept_iff`, `turned_iff`), with the bound `N` at which they read it left as a bare parameter. Neither module says how `N` arises, nor what the selection does to the learner's probe while it runs. This module joins them: `N` becomes the step at which an `Obs`-only learner registers, along a course in which the selection's share decides whether the learner's restraint is executed at all. Part B states why, with evidence split across two agents, no isolated learner can register at all, and what exchange of witnesses changes.

Not claimed: that any actual population, firm, training run or AI system meets these premises (Rule 2); see §4.

## 1. Part A — the capture-lock race

### A.0 Objects reused, unchanged

- From EE: `EmergenceAct`, `StrainWorld`, `UnguidedLoop S Obs Act` (Moore: `init`, `act`, `update`), `closedLoopStep`, `closedOrbit`, `wEndo`, `wExo`, `emergentLoop`, `LearnerState`, `wEndo_orbit_stabilizes`, `wEndo_orbit_above_crit`, `endogenous_emergence_sufficiency`, `emergentLoop_separates_exo`.
- From `Pace` / `RuleCapture` / `ClosedCapture`: `paced`, `turn`, `paced_succ`, `paced_shift`, `CarrierCounts` (`carrier`, `other`, `0 < other`), `order`, `favours`, `disfavours`, `select`, `raises`, `lowers`, `Locked`, `hi = ⟨4,1⟩`, `lo = ⟨1,4⟩`, `Second.oneToOne = ⟨1,1⟩`, `join`, `joinRead`, `Unread`, `reads_beyond_of_apart`, `unread_course`, `Drawn.pool`, `Drawn.poolRead`, `Drawn.pool_reads`, `Drawn.mirror_*`, `Thinned.lossPool`, `Thinned.course`, `Thinned.kept_iff`, `Thinned.turned_iff`, `Thinned.rule_read`, `Thinned.read_in_time_turns`, `Thinned.read_late_kept`, `Beyond.lossStep`.

### A.1 New definitions

```lean
/-- Alternatives admitted (`true`) or locked out (`false`): locked out, an intended `.safe` is executed as `.extract`. -/
def gate : Bool → EmergenceAct → EmergenceAct
  | true,  a => a
  | false, _ => .extract

/-- One step of a learner whose executed action passes the gate; it observes only `y` and is not told of the gate. -/
def gatedStep (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (admit : Bool) (st : Nat × S) : Nat × S :=
  let a := gate admit (L.act st.2); let x' := W.stepStock st.1 a; (x', L.update st.2 (W.sense x' a))

def gatedOrbit (W) (L) (admit : Nat → Bool) (x₀ : Nat) : Nat → Nat × S      -- structural recursion on Nat

/-- Alternatives are admitted while the carriers (those whose course is `.extract`) are not more than the others. -/
def admits (x : CarrierCounts) : Bool := Nat.ble x.carrier x.other

/-- What the learner has registered: restraint sustains its own continuation. -/
def registers (s : LearnerState) : Bool := s.ownHat .sustainedContinuation

/-- A selection whose others read through a registration (revised after review: generic in what lies beyond the share).
    Share `A = CarrierCounts`, beyond `B` any type stepped by any `fB`, rule `R = CarrierCounts`; the carriers read the rule as `u`
    throughout, the others as `v` until `mark` holds of what lies beyond and as `w` once it does (the pool of `ClosedCapture.Drawn`). -/
def markRead (mark : B → Bool) (u v w : CarrierCounts) (p : CarrierCounts × B) (_ : CarrierCounts) : CarrierCounts :=
  cond (mark p.2) (Drawn.pool u w p.1) (Drawn.pool u v p.1)
def markCourse fB mark u v w reads c := paced (join select fB) (markRead mark u v w) reads c

/-- The coupled race: `B = Nat × S` (stock, learner state), stepped by the gated learner, the gate set by the share. -/
def raceStep (W) (L) (x : CarrierCounts × (Nat × S)) (_ : CarrierCounts) : Nat × S := gatedStep W L (admits x.1) x.2
def raceCourse W L mark u v w reads c := markCourse (raceStep W L) (fun b => mark b.2) u v w reads c
```

Names: `s₀` for a starting share, `x₀` for a starting stock. No component of the learner reads the stock, the share, the gate, `xCrit`, or the world's label: `L.act` sees `S`, `L.update` sees `S` and `y`. The gate reads the share only. The pool reads the share and the learner's registration only.

### A.2 Targets — general (all `S`, all `L`, all `W`)

| # | Name | Statement | Status |
|---|---|---|---|
| A1 | `gated_eq_closed` | If `∀ k < T, L.act (closedOrbit W L x₀ k).2 = .safe → admit k = true`, then `gatedOrbit W L admit x₀ T = closedOrbit W L x₀ T`. (The gate makes no difference where the learner intends `.extract`.) | Proved-in-Lean target |
| A2 | `lockout_learner_irrelevant` | If `∀ k, τ ≤ k → admit₁ k = false ∧ admit₂ k = false` and `(gatedOrbit W L₁ admit₁ x₀ τ).1 = (gatedOrbit W L₂ admit₂ x₀' τ).1`, then for every `k` the stocks at `τ + k` agree, and equal `pureExtractStock`-iterates from the stock at `τ`. Locked out, what any learner registers makes no difference to the substrate. | Proved-in-Lean target |
| A3 | `race_beyond` | `raceRead mark u v w` reads beyond the share whenever `pool u v ≠ pool u w` at some share and `mark` takes both values: `¬ Unread (join select (raceStep W L)) (raceRead mark u v w)` (via `reads_beyond_of_apart`). Its closed counterpart `joinRead (poolRead u v)` is `Unread`, so by `unread_course` the share and rule are the same whatever the learner registers (`closed_race_registration_irrelevant`). | Proved-in-Lean target |
| A4 | `race_stock_is_gated` | `(raceCourse … c t).1.2 = gatedOrbit W L (fun k => admits (raceCourse … c k).1.1) c.1.2.1 t` when `c.1.2 = (x₀, L.init)`. | Proved-in-Lean target |
| A5 | `mark_eq_thinned` | For every `fB`, `mark`, `reads`: if along `markCourse fB mark u v w reads ((s₀, b₀), g₀)` the mark holds exactly from `τ` (`∀ t, mark (… t).1.2 = true ↔ τ ≤ t`), then for every `t` its share and rule equal those of `Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t`, whose loss is `t`. `N = τ` is the registration step. (Instantiated on the race and, in Part B, on the split selections.) | Proved-in-Lean target |
| A6 | `mark_never_eq_pre` | If the mark is false at every step, share and rule equal `paced select (poolRead u v) reads (s₀, g₀) t`; with `u`, `v` favouring and `reads` true at two steps `r < r'`, that course is `Locked` from `r' + 1` for good (`Drawn.through_locks`), and from there `ClosedCapture.lock_outlives_loss` holds of it read with a loss counted one a step (`closed_trap_outlives_loss`). | Proved-in-Lean target |
| A7 | `race_kept_iff` | Under A5, with `u.other < u.carrier`, `w` the mirror of `u` (`w.carrier = u.other`, `w.other = u.carrier`), `reads r = true`, `τ ≤ r`, and the rule in force at `r` favouring: locked for good from `r + 1` ⇔ `others_r ≤ carriers_r`. (`Thinned.kept_iff` read through A5.) | Proved-in-Lean target |
| A8 | `mark_turned_iff` (revised: any cadence) | Under A5 and the same readers, for **any** `reads`: `reads r = true`, `τ ≤ r`, `carriers_r ≤ others_r`. Then (i) at every step from `r + 1` up to and including the next reading step `r' > r` (`∀ j, r < j → j < r' → reads j = false`, `reads r' = true`) the rule in force is `pool u w s_r` and disfavours; (ii) locked the other way for good from `r' + 1` ⇔ `carriers_{r'} ≤ others_{r'}` (`Thinned.turned_iff` at `r'`). | Proved-in-Lean target |
| A9 | `mark_turned_admits_iff`, `mark_kept_locks_out` (revised: any cadence, exact) | For **any** `reads`, under A5, `reads r = true`, `τ ≤ r`, `carriers_r ≤ others_r`: `(∀ k, disfavours g_{r+1+k} ∧ admits s_{r+1+k} = true) ⇔ carriers_{r+1} ≤ others_{r+1}` (← by `Pace.stays_turned` on the region `disfavours g ∧ carrier ≤ other`, closed under every turn of `select`/`poolRead u w`, after `Thinned.past_course`). Kept side: `reads r = true`, `τ ≤ r`, rule in force at `r` favouring, `others_r ≤ carriers_r`, `others_{r+1} < carriers_{r+1}` ⇒ `admits s_{r+1+k} = false` for all `k` (`Thinned.read_late_kept` + order transport). | Proved-in-Lean target |
| A10 | `registers_stays` | For `emergentLoop`, `registers s = true → registers (emergentLoop.update s y) = true`; `phase = .resolved ∧ registers s = false` is preserved by every `update`. | Proved-in-Lean target |

A7–A9 together are the exact pre-capture turning window read at the learner's registration step `τ`, for any reading cadence (with `r` the first reading step `≥ τ`): kept for good exactly where the carriers are already at least as many at `r`; alternatives admitted for good exactly where the carriers are still not more at `r + 1`. Between the two (carriers fewer at `r`, more at `r + 1`) neither holds at those steps; what follows there is **not** claimed (see §4).

### A.3 Targets — witnesses (`u = hi`, `v = oneToOne`, `w = lo`, `g₀ = hi`, start stock `14`, `emergentLoop`, every course from carriers `1`)

Numbers below were found by a stdlib Python replica (`scratch/race_sim.py`, not committed); each is to be re-derived by the kernel (`rfl` / `decide` on literals) before it is claimed.

| # | Name | Start (others), world, reads | Content | Status |
|---|---|---|---|---|
| W1 | `race_in_time` | `20`, `wEndo`, every step | Admitted at `2, 3` (probe runs), registers exactly from `τ = 4` (A1 + EE + A10); carriers `≤` others at `4` and `5`, so by A9 (`r = 4`) admitted and disfavoured for good from `5`; by A1 the stock course is EE's `closedOrbit`, so `6 ≤ x_t` for all `t` and `.safe` from `4` on. | target |
| W2 | `race_late_after_registration` | `12`, `wEndo`, every step | Probe runs and the learner registers from `4`, but carriers `>` others at `4`: by A7 (`r = 4`) kept for good from `5`; by A9 locked out from `4`; by A2 the stock is `10, 8, 6, 3` at `4..7`, `3 < 6`. Registration in full, too late. | target |
| W3 | `race_probe_blocked` | `4`, `wEndo`, every step | Carriers `>` others from `2`: the probe is executed as `.extract`, the learner resolves unregistered at `4` and stays so (A10); by A6 the course is the closed pool, locked from step `1` (`Drawn.through_locks`-style), locked out forever; stock `3 < 6` at `5`. | target |
| W4 | `race_masked_strain` | `20`, `wMasked` (`sense = min x 10 + {4,1}`, `stepStock = wEndo.stepStock`), every step | Same start as W1, same learner; the residual first appears at `t = 2`, registration from `5`; carriers `>` others from `6`; kept for good from `8` (A7 at `r = 7`); stock `3 < 6` at `8`. Strain masked one step longer turns W1 into capture. | target |
| W5 | `race_slow_cadence` + `race_fast_cadence` | `64`, `wEndo`; slow: `cadence3` (structural: `false, false, true, …` period 3), with `PacedStock.ReadAtSpanEnd (fun j => 3 * j) cadence3` proved; fast: every step | Same learner, same start, same world. Fast: as W1 (A9 at `r = 4`), `6 ≤ x_t` for all `t`. Slow: registration from `4`, first reading step `≥ 4` is `5`; kept for good from `6` (A7 at `r = 5`), locked out from `4` (A9 kept side + step `4`, `5` computed); stock `3 < 6` at `7`. The reading cadence alone decides. | target |
| W6 | `race_exo_no_false_turn` | `20`, `wExo`, every step | Negative control: the learner probes, observes `9 → 7`, resolves unregistered (EE), never registers (A10); by A6 the rule in force favours the carriers at every step `≥ 1`; the others never read anything. | target |

W1 vs W2 and W5-fast vs W5-slow vary only the selection (start; cadence); W1 vs W4 vary only the strain world; W1 vs W6 vary only whether restraint returns to the learner. Each drops one premise of the window and keeps the rest.

## 2. Part B — split evidence across two agents

### B.0 Setting (stated as a detection phase, as EE's `zero_probe_endo_exo_indistinguishable` is)

Before either agent turns, the depletion signal along the course is a sequence `d : Nat → Bool` fixed by the world (`dD` where the shared substrate is drawn down, `dS ≡ false` where it is not). The evidence is split: agent A observes `yA t = θ t`, agent B observes `yB t = xor (θ t) (d t)`, where `θ : Nat → Bool` is a private tag (a mask neither agent can see apart from its own share of it). Each agent is an isolated `UnguidedLoop S Bool EmergenceAct` fed only its own stream.

```lean
def feed (L : UnguidedLoop S Obs Act) (obs : Nat → Obs) : Nat → S          -- s₀ = L.init, s_{t+1} = L.update s_t (obs t)
def mask : Bool → Bool → Bool | false, b => b | true, b => !b                         -- own definition, by cases
def viewA (θ : Nat → Bool) : Nat → Bool := θ
def viewB (d θ : Nat → Bool) : Nat → Bool := fun t => mask (θ t) (d t)
def retag (d θ : Nat → Bool) : Nat → Bool := fun t => mask (θ t) (d t)                 -- the tag permutation for one world
def exchange (a b : Bool) : Bool := mask a b                                           -- open witness exchange: one bit each, per step
/-- Counting over all `2^T` binary tag prefixes, by structural recursion (position 0 first). -/
def countTags : Nat → (List Bool → Bool) → Nat
  | 0, F => cond (F []) 1 0
  | T + 1, F => countTags T (fun θ => F (false :: θ)) + countTags T (fun θ => F (true :: θ))
def feedList (L : UnguidedLoop S Obs Act) : S → List Obs → S                           -- s, o :: os ↦ feedList (L.update s o) os
def viewBList (d : Nat → Bool) : List Bool → List Bool                                 -- b :: bs ↦ mask b (d 0) :: viewBList (d ∘ succ) bs
```

### B.1 Targets (all universal over agents, state types and alarm readouts `alarm : S → Bool`)

| # | Name | Statement | Status |
|---|---|---|---|
| B1 | `feed_lockstep` | Streams agreeing before `T` give equal states at `T`. | Proved-in-Lean target |
| B2 | `retag_symmetry`, `split_two_of_two` | `retag d (retag d θ) t = θ t` (an involution, so a bijection on tags); `viewB d θ t = viewA (retag d θ) t` and `viewA θ t = viewB d (retag d θ) t`: retagging swaps which agent holds `θ` and which `θ ⊕ d`, so each share alone is a masked bit (a 2-of-2 split); hence `viewB dD θ = viewB dS θ'` with `θ' t = mask (retag dD θ t) (dS t)`. | Proved-in-Lean target |
| B2' | `count_view_invariant` | For every `F : List Bool → Bool`, `d`, `T`: `countTags T (fun θ => F (viewBList d θ)) = countTags T F` (structural induction on `T`, generalizing `F` and `d`; at each position the two branches are equal or swapped, `Nat.add_comm`). | Proved-in-Lean target |
| B3 | `split_marginal_impossibility` | For every `L_A`, `L_B`, `T`: `feed L_A (viewA θ) T` is the same in both worlds for every `θ`; `feed L_B (viewB dD θ) T = feed L_B (viewB dS (retag dD dS θ)) T`. Hence no isolated agent has an alarm that fires on every tag in the drawn-down world and on none in the other. **Exact zero local marginal** (revised): for every Moore agent `L`, start `s`, alarm, `T`, `dD`, `dS`: `countTags T (fun θ => alarm (feedList L s (viewBList dD θ))) = countTags T (fun θ => alarm (feedList L s (viewBList dS θ)))` — over all `2^T` tags the agent alarms exactly as often in both worlds (true-positive count = false-positive count, for any partial rate, not only `100%/0%`); for A the two counts are the same expression. | Proved-in-Lean target |
| B4 | `silencing_consensus` | Consensus by exclusion: a combination `c : Bool → Bool → Bool` with `c false false = false`, admitting only locally sound alarms (`∀ θ, alarm_i (… dS θ …) = false`, each `i`). Then `c` never fires in the drawn-down world, on any tag, at any `T`. | Proved-in-Lean target |
| B5 | `verdict_leak` | The soundness filter is what silences, not the verdict format: at `T = t + 1`, with verdicts `alarm_A = viewA θ t`, `alarm_B = viewB d θ t` (each not locally sound) and `c = exchange`, the consensus fires exactly where `d t`. A verdict that is not locally sound is itself a witness. | Proved-in-Lean target |
| B6 | `exchange_detects` | `exchange (viewA θ t) (viewB d θ t) = d t` for every `θ`: open exchange fires at `t` on every tag exactly where the depletion signal holds — no false positive in `dS ≡ false`, no miss in `dD`. | Proved-in-Lean target |
| B7 | `split_silenced_trapped`, `split_exchange_turns` (revised: required, coupled into `ClosedCapture`) | Split selections are `markCourse` with `B = Nat × S` stepped by an exogenous feeder (`feedStep`: count `t ↦ t + 1`, state updated by the stream at `t`). (i) **Silenced**: isolated pair (`pairLoop L_A L_B`, each component updated by its own coordinate only) fed `(viewA θ t, viewB dD θ t)`, mark `c (alarm_A sA) (alarm_B sB)` with `c false false = false` and both alarms locally sound in `dS`: for **every** `θ` the mark is false at every step (B3 + B4), so by A6 share and rule are the closed pool's course, `Locked` for good from step `2` and outliving the loss — trapped whatever the tag. (ii) **Exchange**: the joint loop `exchangeLoop` (state `Bool`, `update s (a, b) = s || exchange a b`) fed the pair registers exactly from `τ = 2` for every `θ` in `dD` (B6, `dD 0 = false`, `dD 1 = true`) and never in `dS`; by A5 the share and rule are `Thinned.course` with `N = 2` — free of `θ` — and from one carrier and twenty others alternatives are admitted and disfavoured for good from step `3` (A9 at `r = 2`); in `dS`, by A6, the course is the closed pool's: no false turn for any `θ`. | Proved-in-Lean target |
| B8 | `split_witness_endo` | `dD t := Nat.blt (pureExtractStock wEndo 14 (t+1)) 12` (strain on the all-extract course of EE's `wEndo`), `dS t := false`: B3–B7 are stated of it, with `dD 0 = false`, `dD 1 = true`. | Proved-in-Lean target |

## 3. Pre-registered empirical replay (`experiments/evidence-replay/test_split_evidence_capture_race.py`, stdlib only)

Black-box: the world objects hold stock, `xCrit`, label; learner objects receive only `y` (Python attribute audit: the learner class is constructed with no world reference, and its `__dict__` after a run contains no key naming stock, crit or world). Predictions are written in the test before running, as assertions; failures are kept.

- **R1 (window, grid).** Over starts `others ∈ 1..1100` (revised: so that every cadence has both outcomes), carriers `1`, cadences `L ∈ {1,2,3,4}`, asserting for every `L` that both the kept and the turned case occur (`kept > 0` and `turned > 0`): whenever the learner registers at `τ` and `r` is the first reading step `≥ τ`, (i) `others_r ≤ carriers_r` ⇒ carriers never again fewer than others after `r` (kept); (ii) `carriers_r ≤ others_r` and `carriers_{r+1} ≤ others_{r+1}` ⇒ the rule disfavours the carriers at every step after `r + 1` and the stock stays `≥ xCrit` over the horizon (turned). Middle-band starts are recorded, not predicted.
- **R2 (no hardcoded threshold).** Zero-argument `Learner()` (no world reference). A family of shifted worlds (`sense` plateau `p ∈ {9..14}`, offsets `+0, +50, +1000`, `xCrit ∈ {5,6}` with matching `stepStock`) — the same learner code registers whenever the 2-step probe sees `ySafe1 ≤ ySafe2` and is not told `p`, the offset or `xCrit`. Lockstep tamper check: `wEndo` and `wExoShift` emit identical `y` at `t = 0..2`, and the learner's state and action at `t = 3` are identical.
- **R3 (negative control).** In `wExo`, `wExoShift` (the second `.safe` step rejects the one-step trap) and the constant plateau `wCliff`: zero registrations and zero turns across the whole grid.
- **R4 (split evidence, exhaustive).** Horizon `T = 6`, all `2^6` tags: for 200 seeded random Moore agents (random finite state tables; the test asserts some are non-trivial, `0 < count < 2^T`) and hand-written adversarial agents, the count of tags on which each isolated agent alarms is equal in the two worlds; every locally sound agent is silent in the drawn-down world; `exchange` has true-positive rate 1 and false-positive rate 0; the verdict-leak pair detects. Closed-loop replay of B7 across all `2^T` tags: silenced consensus leaves the selection locked; exchange turns it; no turn in `dS`.
- **R5 (hygiene).** `PYTHONDONTWRITEBYTECODE=1`, no `__pycache__`, 0 `MARKET_EN`/`MARKET_ZH` hits.

## 4. Open / unproved (said, not hidden)

1. The middle band of A7–A8 (carriers fewer at `r`, more at `r + 1`): the course can alternate (the replica shows starts `18, 19` doing so and surviving); no theorem characterizes it.
2. Part A fixes one learner (`emergentLoop`) for the witnesses; A1–A9 are general, but which learners register in time is not characterized. Part A also fixes two kinds of reader and a pool counted as the population counts them (`ClosedCapture`'s own limits carry over).
3. Part B is a detection phase on a stream fixed by the world: agents' actions do not feed back into `d` before the turn (the selection in B7 is coupled; the substrate is not). A closed-loop split world where the masks and the draw-down interact is not stated. B3 counts over all `2^T` tags (the uniform case, exactly); other distributions on tags are not treated.
4. Rule 2: that any actual selection admits alternatives by a majority gate, reads a learner's registration into its rule, or splits evidence as a one-time mask does, is a recognition that can fail; the replay tests the model's own predictions, not the world.
5. Nothing here says the turn is right; `07 §4.2`'s firewall (EE's `emergent_order_firewall`) is untouched: the learner registers what returns to its own continuation, not what is owed to others.

## 5. Build hygiene commitments

`Init`-only imports (`Becoming.EndogenousEmergence`, `Becoming.ClosedCapture`), structural `Nat` recursion only (no `termination_by`, no `WellFounded`), no `funext`/`propext`/`Quot.sound`/`Classical`, no `private`, no `sorry`, no `simp`/`omega` that could pull axioms; `decide` only on closed literals; target compile `< 30 s`; `with_axioms: {}` via `scratch_build.py`.

## 6. Revision log

- **24 Nov, after `f1-critic` #21.** BLOCKER 1: A8–A9 made cadence-general (any `reads`; exact `⇔` for admission from `r + 1`), W5 split into a slow/fast pair on the same start with `PacedStock.ReadAtSpanEnd (fun j => 3 * j)` proved for the slow cadence. BLOCKER 2: exact count equality over all `2^T` tags (B2', B3), the 2-of-2 swap lemma (B2), and B7 made required: Part B's consensus and exchange drive `ClosedCapture` selections through the same generic `markCourse` as the race (A5/A6 now generic in what lies beyond the share). BLOCKER 3: R1 grid to `1..1100` with `kept > 0 ∧ turned > 0` asserted per cadence. MAJOR 1: R2–R4 anti-cheat as listed. MINOR: B5 at `T = t + 1`; `lock_outlives_loss` instantiated in A6; `s₀`/`x₀` naming; large literals compared through `Nat.ble` (`Nat.le_of_ble_eq_true rfl`), not unfolded `Nat.le`.
