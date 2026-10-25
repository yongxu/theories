# UE1 review: the free-energy principle as a case (25 October 2026)

This is an AI-authored independent review of board item UE1 as committed at `bfa80c29b`. It covers two files:

- [NOTE.md](NOTE.md), sha256 `c6a9941a…e1213`;
- `tree/Becoming/HabitCapture.lean` (renamed `ChoiceCountCapture.lean` in the revision; the reviewed bytes are at commit `bfa80c29b`), sha256 `9d87d5ab…cdc22`.

They were read with [the UE plan](../ue-unified-explanation/PLAN.md); chapters 01, 02, 03, 05, 07 and 08; and the package modules `RuleCapture`, `ClosedCapture`, `RuleShaping`, `Selection`, `IdentificationRuns`, `Pace`, `Weighted` and `Typicality`.

**How it was checked.**

- **Rebuild.** The kit tree was rebuilt with `scratch_build.py`. It gives 22 theorems in 29 declarations, with every axiom report empty, as the NOTE says. Every step was reused from the shared cache.
- **Probe.** Variants were built in a separate scratch tree: a probe module importing the kit and `RuleShaping`, 16 theorems in 20 declarations, every axiom report empty. Its text is in the [appendix](#appendix-the-probe-module), since the scratch folder is volatile. "Probe" below refers to it.
- **Sources read this round, through a fetching tool.**
  - The 2016 paper's full-text XML at Europe PMC (PMC5167251). Its equations are images and were not read.
  - The arXiv abstracts of Friston and others 2023 ([2201.06387](https://arxiv.org/abs/2201.06387)), the path-integral paper ([2210.12761](https://arxiv.org/abs/2210.12761)), Biehl and others ([2001.06408](https://arxiv.org/abs/2001.06408)) and Aguilera and others ([2105.11203](https://arxiv.org/abs/2105.11203)).
  - SPM12's [`spm_MDP_VB.m`](https://raw.githubusercontent.com/spm/spm12/master/toolbox/DEM/spm_MDP_VB.m) (`$Id: spm_MDP_VB.m 7120 2017-06-20`) and [`spm_MDP_VB_X.m`](https://raw.githubusercontent.com/spm/spm12/master/toolbox/DEM/spm_MDP_VB_X.m), from the GitHub mirror `spm/spm12`.
  - Arthur (1989) and Miller, Shenhav and Ludvig (2019), checked for bibliographic details and their abstract-level content only.
  - NCBI's and City's servers did not resolve.
- **Not Lean.** Numbers about counting over many trials come from a short direct computation, not from Lean, and are labelled where used.

## Verdict

**The Lean.** The Lean is sound, and its proofs are clean instances of `RuleCapture`, `ClosedCapture` and the selection laws. Part 1 is honestly labelled near-definitional. Theorem statements match their docstrings, with two exceptions: `habit_locks_down` drops the rule clause its docstring states, and the witness `soft_gives_way` proves less than its name.

**The correspondence with active inference** is fairer than the NOTE's own §6 admits, but not for the reason the NOTE gives:

- The 2016 scheme counts the posterior over policies at the end of each trial. In its task the outcomes have by then revealed which policy was pursued, so the count is close to the kit's `choose`, apart from a split among equally good policies that the kit does not model.
- It is not the kit's `soft`, which counts the posterior at the time of choosing.
- So the NOTE's identification of implementations with `soft` is wrong. The frozen test it proposes would fail on the reference implementation, and "gives way" says more than the Lean proves.

**Dropped hypotheses.** Several statements drop hypotheses the Lean needs:

- The rule in force at the start must be the one read from the counts. Without it, a stale rule can carry the counts across the threshold (probe witnesses).
- The reading must favour at every share. It does not, so a change of the counts across the threshold also leaves the lock.

**Duplication.** The soft part re-proves `RuleShaping` lemmas beside them.

**The third part.** The containment's third part, as the plan and the landing drafts state it, does not survive:

- its first forbidden statement is a known lock-in, which active inference's own simulation already shows;
- its second concerns a rule active inference does not use;
- its third is the pool law read onto belief sharing.

**Overall.** Not ready to land as written. The Lean needs small changes (findings 9 and 11, and the names in 22 if adopted). The NOTE's §2, §4, §5, §6 and §7(c), the module's correspondence paragraph, and the third part need the rewrites below.

**Counts:** 3 errors, 8 overclaims, 9 imprecisions, 3 suggestions.

## Findings

Each finding gives its severity, location, what is wrong, and the fix proposed. Suggested wording may be taken as written or in words that say the same.

### The correspondence with active inference

**1. What active inference counts, and which kit case it is.** *Error.*
- **Location.**
  - NOTE §6, third bullet: "implementations often count the posterior, which is the case `soft` states".
  - The module docstring's **Correspondence**: "read with `soft`, the counts accumulate the posterior itself".
  - NOTE §4: "In their scheme the vectors encoding the selected policy accumulate evidence by counting how often they occur (§2.4)".
  - NOTE §8: "§2.4 and §5.2 sentences cited here were checked verbatim".
- **What is wrong.** The sentence in §2.4 reads: "In addition to the learning of contingencies through the parameters of the transition matrices, the vectors encoding beliefs about the initial state and selected policy accumulate evidence by simply counting the number of times they occur." The paper adds: "In practice, the learning updates are performed at the end of each trial or sequence of observations."
  - **What is counted is a belief.** It is the posterior over policies at the end of the trial. In `spm_MDP_VB.m`:
    - `u(p,t)  = qu;`, with `qu = spm_softmax(qE(p) + gu(t)*Q(p) + F(p));`;
    - policies more than 3 nats below the best evidence are dropped: `p     = p((F(p) - max(F(p))) > -3);`;
    - at the end of the trial, `MDP.e = MDP.e + u(:,T);`. In `spm_MDP_VB_X.m` the same update reads `MDP(m).e = MDP(m).e + eta*u{m}(:,T);`.
  - **It is close to `choose`.** That posterior conditions on the whole trial's outcomes. Where they reveal which policy was pursued (in the T-maze the location is observed), it concentrates on the policies consistent with what was done. So active inference's count is close to the kit's `choose`, the count of the executed policy.
  - **One difference the kit does not model.** The count is split, by prior and evidence, among policies that explain the trial equally. In the 2016 paper these are the habit (policy 0) and a sequential policy with the same transitions. The authors place the habit's advantage there: "The habit is selected because it provides a better explanation for observed outcomes."
  - **It is not `soft`.** The kit's `soft` counts the posterior at the time of choosing, before the outcomes. Neither the paper nor SPM does that.
  - **So:** the NOTE's §4 paraphrase is close in effect but drops "beliefs about" and is not verbatim. Its §6 identification of implementations with `soft` is wrong.
- **Fix.**
  - Quote §2.4 in full.
  - §4: "In their scheme the policy prior's counts add the posterior over policies at the end of each trial (§2.4; SPM12's `spm_MDP_VB`). Where the trial's outcomes reveal the policy pursued, that posterior is concentrated on it, so the count is close to the count of the chosen policy (`choose`). Policies that explain the trial equally, here the habit and a sequential policy with the same transitions, share it by prior and evidence, which the kit does not model."
  - §6, third bullet: "The habit model counts the executed policy, between two policies of distinct behaviour. The 2016 scheme counts the end-of-trial posterior: close to the executed policy where the outcomes reveal it, and split among policies that explain the trial equally. Its habit is a state-action policy whose transitions are learned. `soft`, the posterior at the time of choosing, is a contrast case that no implementation cited here uses."
  - Module docstring: "…the habit, is learned by adding the posterior over policies at the end of each trial, which is close to the policy selected where the trial's outcomes reveal it. … Read with `soft`, the counts take the posterior at the time of choosing, before the outcomes: a contrast that no implementation cited here uses."
  - Correct §8's verbatim claim.

**2. What the simulation shows, and what the law adds to it.** *Overclaim.*
- **Location.**
  - NOTE §4: "`habit_locks` and `habit_locks_down` state that shape as a law with an exact, two-sided threshold".
  - NOTE §4, "What the law adds to the simulation", item 1.
  - PLAN §3.
- **What is wrong.**
  - **The decision rule, not the lock.** At a change of score the decision is the posterior's argmax, whatever is counted. So "the outcome turns on whether the counts stand above `κo/κc` when the score changes" is a property of the decision rule (with finding 7's qualifier), not of the lock.
  - **"Never" is not shown.** What counting the choice adds is that the decision never reverses under a standing score. The simulation shows persistence over the 16 trials after devaluation at trial 48. That is consistent with a lock and with slow decay alike (finding 3's numbers).
  - **The exact threshold is the model's.** The paper's threshold differs in several ways:
    - SPM uses the expected log of the prior, `qE    = psi(e) - ones(Nh,1)*psi(sum(e));`;
    - it adds the free-energy term;
    - it infers the precision and samples actions;
    - it splits the count (finding 1).

    Example: counts 3:1 under a score of one to four lie below the kit's threshold (`4 · 1 > 1 · 3`), yet SPM's prior weights favour the first policy, `e^ψ(3) ≈ 2.52 > 4 · e^ψ(1) ≈ 2.25` (direct computation).
  - **Minor.** The paper's devaluation after 16 trials came "before the habit was fully acquired", not before it formed.
- **Fix.** Replace the sentence after the two bullets, and item 1, with: "`habit_locks` and `habit_locks_down` state the counted model of that shape. Under any counting the decision at a change of score is the posterior's argmax, so the outcome turns on the counts against `κo/κc` at the change (the rule read again at once). What counting the choice adds is that, under a standing score, the decision never reverses. The simulation shows persistence over the trials it runs, not that. The threshold is exact in this model: ties go to the first policy, and the prior is the counts themselves (SPM uses ψ(e) − ψ(Σe)). The model has no free-energy term, no sampling and no split among equally good policies." In the NOTE's account of the devaluation after 16 trials, write "before the habit was fully acquired".

**3. The frozen test would fail.** *Error.*
- **Location.** NOTE §7(c): "with posterior counting, predict that none persists". PLAN §6 cites the test.
- **What is wrong.**
  - **On SPM, the habit persists.** Run on SPM's agent, whose "posterior counting" is the end-of-trial count of finding 1, the habit persists. That is the 2016 result itself.
  - **On the kit's `soft` rule, it persists too.** Run with counting of the posterior at the time of choosing, the kit proves only that the share falls strictly at each step (`soft_falls`, `soft_course_falls`), not that the decision changes within any horizon. With additive counting `e ← e + π` (η = 1, two policies, a score of one to two against the habit), the decision first favours the other policy at trial 208 from counts 17:1, and at trial 1710 from 48:1. With a score of one to 1.2 it has not done so within 10^7 trials (direct computation).
  - **Either way.** The test as stated refutes a prediction the Lean does not make.
- **Fix.** "(c) **A frozen test.** In a discrete active-inference agent, compare two updates of the policy prior: counting the executed policy, which SPM approximates where outcomes reveal it, and counting the posterior at the time of choosing. Vary the devaluation trial and the score. Read the score from the agent as the posterior's terms other than the prior, logged per trial. Predict before running:
  - under choice counting, no run whose counts stand above the threshold at the change, with the prior read again at once, ever reverses (for a sampling agent, state the claim for the argmax);
  - under counting at the time of choosing, the habit's share of the counts falls at every trial where the score is against it, and the decision reverses at a trial predicted in advance, which first needs a law with a bound (see 4)."

**4. "Gives way."** *Overclaim.*
- **Location.**
  - NOTE §4: "Counted from the posterior, it gives way"; the witness line "gives way at the first step"; item 4, "removes the lock".
  - `Witness.soft_gives_way` and its docstring.
  - The `soft_course_falls` docstring: "no lock forms".
  - PLAN §3.
  - The board's UE1 row: "it gives way at every step".
- **What is wrong.**
  - **A falling share need not cross.** The Lean proves that the share falls, and a strictly falling share need not cross the threshold.
  - **In the witness it does not cross at the first step.** After one step the counts are six to three. Under the score one to two that is a tie (`2 · 3 ≤ 1 · 6`), which `choose` gives to the first policy. The rule favours the second only from step 2, at twelve to nine (probe `soft_step_one_still_favours`, `soft_step_two_turns`).
  - **"No lock" holds only for the share.** `soft` has no rule and no reading, so `Locked` does not apply to it.
  - **"Counted from the posterior" invites the wrong reading.** Readers will take it to mean active inference's posterior counting, which is not `soft` (finding 1).
- **Fix.**
  - Rename `soft_gives_way` to `soft_share_falls`, with the docstring: "From the same three to one, counting the posterior at the time of choosing at scale one, the first policy's share falls at the first step; the weighted rule still favours the first policy after it (six to three under one to two, a tie) and favours the second from the second step."
  - In the NOTE, plan and board, write "counted from the posterior at the time of choosing, its share falls at every step".
  - If a crossing claim is wanted for the multiplicative model, add and prove `soft_crosses (scale : 0 < s) (score : κc < κo) : ∃ n, κc * (softCourse κc κo s pos x n).carrier < κo * (softCourse κc κo s pos x n).other`. The witness is `n = κc · x.carrier · (s + κc)`, by Bernoulli's inequality `(a + 1)^n ≥ a^n + n · a^(n−1)` with `a = s + κc`. The crossing time it gives is geometric, not that of additive counting (finding 10).

**5. "The limit of high precision."** *Imprecision.*
- **Location.** Module docstring, **Correspondence**: "the limit of high precision in selecting actions". NOTE §6, fourth bullet.
- **What is wrong.**
  - **The selection is a precision limit.** The posterior's argmax is the limit of high action precision. SPM samples actions: `spm_softmax(alpha*P(:,t))` with `alpha` 16 by default in `spm_MDP_VB`, and 512 in `spm_MDP_VB_X`.
  - **The count is not.** That the count is of the executed policy comes from conditioning on the trial's outcomes (finding 1), not from precision.
  - **At finite precision.** The executed policy can differ from the argmax, and SPM then counts the executed one.
- **Fix.** "Read with `choose`, the policy selected is the one the posterior weighs most, the limit of high action precision. The count is of the policy executed, as active inference's end-of-trial count is where the outcomes reveal it. At finite precision a sampled choice can differ from the argmax (a change of the counts in the sense of finding 6)."

### The habit laws, statements against the Lean

**6. `uniform_locks` does not apply, and a change of the counts across the threshold leaves the lock.** *Error.*
- **Location.** NOTE §4, "What the law adds", item 2: "only a change of the law, of the reading or of the selection leaves the lock (`RuleCapture.uniform_locks`, `perturbation_absorbed`)".
- **What is wrong.**
  - `uniform_locks` needs a reading that favours at every share (`uniform : ∀ x g, favours (h x g)`). `weighted` favours only at or above the threshold (`weighted_favours_iff`).
  - RuleCapture's own docstring states the other case: "Where the reading favours only above a threshold, a change of configuration across the threshold also leaves (`Reversed.not_absorbed`)."
  - For the habit, one count moved to the second policy is enough. Three to one becomes three to two under the score one to two, and the course locks the other way (probe `moved_locks_down`, by `habit_locks_down`). In an agent that is a forced or a sampled choice of the other policy.
- **Fix.** "2. that, the score standing and the rule read from the counts, the course never crosses the threshold. What carries it across is a change of the counts (forced or sampled choices of the other policy), of the score, of how the rule reads or of the choice rule. A perturbation of the rule keeping its direction is absorbed at the next reading step (`RuleCapture.perturbation_absorbed`, of which the kit states no instance)."

**7. The start's rule is a hypothesis, and the devaluation claim depends on the schedule.** *Overclaim.*
- **Location.**
  - NOTE §4, first sub-bullet of the habit laws: "From counts with `κo · other ≤ κc · carrier`, the chooser takes the first policy at every step along every schedule".
  - NOTE §4: "the outcome turns on whether the counts stand above `κo/κc` when the score changes".
  - The board's UE1 row.
  - The study draft, line 61.
- **What is wrong.**
  - **Every habit law starts in sync.** `habit_locks`, `habit_chooses`, `habit_locks_down` and `habit_outlives_loss` all start from `(x, weighted κc κo pos x g)`, the rule in force read from the counts.
  - **A stale rule acts.** In `paced` the choice at a step uses the rule in force (`paced_fast_succ`), and the reading lags one choice behind the counts. A rule not read from the counts, such as one left from an older score, acts until the first reading step and can carry the counts across the threshold.
  - **Probe witnesses:**
    - `above_but_stale_locks_down`. The counts are three to one, above the threshold of the score one to two. The rule in force favours the second policy four to one and is read at every step. The course is locked the other way from step 5, and the rule favours the second policy at every later step (`above_but_stale_never_first`).
    - `devalued_read_late_locks_up`, with `devalued_read_late_keeps_first`. The counts are three to one under a new score of one to four, which puts them below its threshold. Read at once, the course locks the other way (`devalued_read_at_once_locks_down`). With the old rule still in force (one to one, read from the counts) and the first reading at step 1, the course is locked for the first policy from step 2, for good.
  - **So.** The counts at the change decide only where the change resets the rule in force to the new reading before the next choice. Read late, the counts at the first reading after the change decide.
- **Fix.**
  - Add "and the rule in force read from them" to the NOTE's sub-bullet.
  - After "when the score changes", add: "where the rule in force is read again under the new score before the next choice. A rule left from the old score acts until the first reading step and can carry the counts across the threshold (the review's witnesses, which could land as `Stale`)."
  - Put the same qualifier in the module docstring's **What is not derived** and in the third part.

**8. The threshold: ties, and what "point of no return" means.** *Imprecision.*
- **Location.** Module docstring: "so the threshold is a point of no return either way". NOTE §4: "an exact, two-sided threshold", item 1.
- **What is wrong.**
  - **Ties are a convention.** `choose` gives ties to the first policy (`g.other ≤ g.carrier`), so the boundary case `κo · other = κc · carrier` locks up by that convention. Only the strict sides are independent of it.
  - **Nothing crosses.** Under a standing score with the rule in sync, nothing crosses the threshold. So it is not a point that is passed and not returned from: it divides the counts into two regions the course never leaves.
  - **Edge cases.** These come out as expected and deserve a line:
    - with `κc = 0` or `carrier = 0` the counts are always below the threshold, and the second policy is taken for good;
    - `κo > 0` is required (`pos`, for `CarrierCounts`).
- **Fix.** "Under a standing score, with the rule in force read from the counts, the threshold `κo · other ≤ κc · carrier` divides the counts into two regions the course never leaves. At or above it, the first policy is taken at every step; below it, the second. Ties go to the first policy by `choose`; with `κc = 0` or no carriers, the second policy is taken for good."

**9. `habit_locks_down` states less than its docstring.** *Overclaim.*
- **Location.**
  - The `habit_locks_down` docstring: "neither the share nor the rule rises".
  - The module docstring and NOTE §4: "the chooser takes the second policy at every step".
- **What is wrong.**
  - The conclusion keeps only the share part of `locked_rises` (`.1`) and drops the rule part.
  - It states that the rule in force strictly favours the second policy, not that the chooser takes it. The counterpart of `habit_chooses` is missing.
- **Fix.**
  - Add the rule clause, `(reverse order).le (…t).2 (…(t + 1)).2`, which is `(locked_rises …).2`.
  - Add a theorem `habit_chooses_down`.
  - Both are proved in the probe (`habit_locks_down_rule`, `habit_chooses_down`), each a few lines from the kit's own lemmas.

**10. `soft` is selection by a fixed rule, and its course is geometric.** *Imprecision.*
- **Location.** The `soft` and `softCourse` docstrings. NOTE §4: "whatever the counts and the scale".
- **What is wrong.**
  - **A fixed rule.** `soft κc κo s pos x` is definitionally `CarrierCounts.select x ⟨s + κc, s + κo, _⟩` (probe `soft_is_select`, by `rfl`). It is a fixed rule that reads nothing of the share.
  - **When it matches additive counting.** Adding the posterior at the time of choosing with learning rate η, `e ← e + η π`, is this step only with `s = Z/η` at each step, where `Z = κc · carrier + κo · other`. That value changes from step to step and is a whole number only for suitable η.
  - **The course is geometric.** `soft_falls` covers each step of additive counting. `softCourse` keeps `s` fixed, so its course is geometric: the share is multiplied by `(s + κc)/(s + κo)` at each step. That is not the timescale of additive counting, whose steps shrink as the counts grow (finding 3's numbers).
  - **Hypotheses.** "Whatever the scale" holds for one step only. The course law needs `0 < s` (or `0 < κc`) to keep carriers present. The NOTE omits that carriers must be present.
- **Fix.**
  - Docstring of `soft`: "Selection by the fixed rule `⟨s + κc, s + κo⟩`. One step of adding the posterior at the time of choosing with learning rate `η` is this step with `s = Z/η`, `Z = κc · carrier + κo · other`, where that is a whole number, so `s` changes from step to step. `softCourse`, with `s` fixed, is a geometric course and does not give additive counting's timescale."
  - NOTE: "carriers present, whatever the counts; along a course, a positive scale".

**11. The soft part re-proves `RuleShaping` beside it (board rule 9).** *Suggestion.*
- **Location.** `soft`, `soft_falls`, `softCourse`, `softCourse_some` and `soft_course_falls`; also `weighted`/`weighted_reads` and `lower_strict`.
- **What is wrong.**
  - **Four soft lemmas are `RuleShaping`'s.** `soft_falls` is [`RuleShaping.falls_strictly`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleShaping.lean) at the rule above. `softCourse` is `Law.orbit (fun y => CarrierCounts.select y ⟨s + κc, s + κo, _⟩) x`. `softCourse_some` is `RuleShaping.present_along`. `soft_course_falls` is `falls_strictly` with `present_along`, the shape of `nothing_back_falls`. The probe derives each in a few lines.
  - **`weighted_reads` generalizes beside.** `weighted` with `κc = κo = 1` is `CarrierCounts.proportional`, up to `1 * n = n`, so `weighted_reads` generalizes `proportional_reads` beside it.
  - **`lower_strict` is general.** It is a general fact about `CarrierCounts`, the strict counterpart of `CarrierCounts.lower`.
- **Fix.**
  - Import `Becoming.RuleShaping`. Define the rule `byScore κc κo s pos := ⟨s + κc, s + κo, _⟩`, or drop `soft` and use `CarrierCounts.select x (byScore …)`.
  - State `soft_falls := RuleShaping.falls_strictly (g := byScore κc κo s pos) some (Nat.add_lt_add_left score s)`, and the course law through `Law.orbit` and `present_along`, as the probe does.
  - Either move `weighted`, `weighted_reads` and `lower_strict` into `RuleCapture.CarrierCounts`, with `proportional_reads` derived as the case `κ = 1`, or say in the row why they stay in the leaf.

### Part 1, capture, the principle's description and the readings

**12. Part 1 matches sparse coupling, not the blanket condition.** *Imprecision.*
- **Location.**
  - NOTE §4, first bullet: "the blanket condition already says as much"; "every law about selections through couplings now applies to the principle's agents".
  - The module docstring: "The free-energy principle's Markov blanket is read here as the couplings".
- **What is wrong.**
  - **Sparse coupling, not the blanket.** `selectsThrough` says the choice is a function of the prefix of what couples in. That is the principle's *sparse-coupling* condition: internal states read external states only through blanket states. The *blanket* condition, conditional independence in the steady-state density, is a different property. Sparse coupling does not give it in general (Aguilera and others 2022, read this round), which is what the critics in §2 found.
  - **Outputs and sampled actions.** The chooser's own outputs (active states) are not among what couples in. Where actions are sampled, as SPM samples them, the draws must be listed among what couples in for the law to apply.
  - **Scope.** The laws apply to agents represented this way, which §6 rightly calls a reading.
  - **`beliefAfter`.** It adds no generality: any function of the prefix works.
- **Fix.**
  - NOTE: "This part is near-definitional: the principle's sparse coupling, internal states reading external states only through blanket states, already says as much. The blanket condition, conditional independence in the steady-state density, is a further property that sparse coupling does not in general give (Aguilera and others 2022). Active states are not among what couples in, and a sampled action must be listed among what couples in. Its use is that every law about selections through couplings applies to an agent so represented (§6)."
  - Module docstring: "The free-energy principle's sparse coupling is read here as the couplings".

**13. The habit is capture through the rule, not the meta-attractor.** *Overclaim.*
- **Location.**
  - The module docstring's **Correspondence**: "is then the meta-attractor of `Becoming.RuleCapture`: a loop whose rule and reading are formed from the share it selects".
  - NOTE §5, reading 2.
- **What is wrong.**
  - **The score stands.** In the kit the rule is read from the share. The reading, `weighted κc κo`, carries a standing score that is not formed from the share.
  - **Chapter 02's definition is wider.** It defines 元吸引子 as a loop "whose rule and whose reading of the rule are both formed from the share it selects". That half belongs to `ClosedCapture` (`both_reads`, `readers_uniform_locks`), not to `RuleCapture`.
  - **What the kit instantiates.** It is capture through the rule with an unread coordinate: the part of T7 that is proved.
- **Fix.**
  - Module docstring: "A habit counted from its own choices, with nothing in its loop reading beyond its counts and its score, is capture through the rule (`RuleCapture.locked_stays`), closed in the sense of `ClosedCapture.lock_outlives_loss`. Its score stands: the meta-attractor of 02, whose reading too is formed from the share, would need the score formed from the counts (`ClosedCapture.both_reads`), which is not stated here."
  - Reading 2: "Closed self-evidencing is capture through the rule. Gathering evidence for one's own model, with the model read from what it selects and nothing read beyond it, locks and outlives what it does not read. It is the meta-attractor only where the score too is formed from what it selects."

**14. The process theory as described.** *Imprecision.*
- **Location.** NOTE §2, "Its process theory".
- **What is wrong.**
  - **The posterior has a free-energy term.** The posterior over policies includes the free energy of past outcomes under each policy. The paper's text says the prior beliefs about policies are "supplemented or informed by the (posterior) free energy" (its Eq. 7, an image, was not read). In SPM the posterior is `qu = spm_softmax(qE(p) + gu(t)*Q(p) + F(p))`. What the NOTE calls the posterior is the paper's prior, π₀ = σ(Ê − γ·G), the one policy formula the XML gives as text.
  - **The prior counts a belief.** Its counts add the end-of-trial posterior (finding 1).
  - **The habit is also a policy.** In the 2016 paper a habit is "one special policy that, if selected, will generate the same state transitions and subsequent actions, irrespective of time or context", and its transitions are learned. The NOTE's "the habit" names the prior instead.
- **Fix.** "…policies scored by expected free energy. The posterior over policies is a softmax of the log prior over policies, less the free energy of past outcomes under each policy and the precision-weighted expected free energy (SPM uses the prior's expected log, ψ(e) − ψ(Σe)). The prior's Dirichlet counts add the posterior over policies at the end of each trial. In the 2016 paper a habit is also a special state-action policy whose transitions are learned (§4)."

**15. The principle's start and its critics, wording.** *Imprecision.*
- **Location.** NOTE §2, "Its start" and the first critic bullet.
- **What is wrong.**
  - **The path-integral sentence.** "The path-integral formulation drops stationarity and keeps the partition" rests on a source listed as not re-read, and that source's abstract does not say it.
  - **Sparse coupling and the partition.** "by conditional independencies that sparse coupling gives" states as fact what the principle claims and Aguilera and others dispute.
  - **The Biehl summary.** Biehl and others say that the lemma, where it holds, "implies equality of variational density and ergodic conditional density". The Bayesian interpretation "hinges on this point", and they conclude it "is not sufficiently justified". The NOTE's sentence can be read as calling the equality itself unjustified.
- **Fix.**
  - "…partitioned … by conditional independencies the principle derives from sparse coupling (a derivation its critics dispute, below). … The path-integral formulation is offered as describing paths without a steady-state density." Cite the section, or drop the sentence until the source is read.
  - "Where the lemma holds, it implies that the variational density equals the ergodic conditional density; the Bayesian reading hinges on this, and they conclude that it is not sufficiently justified."

**16. Premise table: rows that claim too much.** *Overclaim.*
- **Location.** NOTE §3, rows 6 (conservation) and 8 (self-evidencing).
- **What is wrong.**
  - **Row 6.** "The principle has no shared stock that several things draw on": the principle's multi-agent work couples several particles to common external states. What it lacks is a conservation of what passes and a renewal law, so a commons law is not stated in its terms.
  - **Row 8.** Its "Standing", "proved under named hypotheses", reads as if the correspondence were proved. What is proved is the lock for capture through the rule, and here for a habit counting its choices. That self-evidencing is such capture is a reading.
- **Fix.**
  - Row 6, last column: "…the principle carries no conservation of what passes and no renewal law, so several particles sharing external states have, in its terms, no bound on their joint draw".
  - Row 8, "Standing": "the lock proved under named hypotheses; that self-evidencing is such capture is a reading [AI reading]".

**17. Premise table: rows to sharpen.** *Imprecision.*
- **Location.** NOTE §3, rows 1, 3, 7 and 9.
- **What is wrong.**
  - **Row 1.**
    - `Becoming.Weighted` takes any weights with laws for adding alternatives and composing steps. Counting, possibility and signed counts are among them, so it is not only "counting form".
    - `Becoming.Typicality` counts two-valued courses with natural weights.
    - The core does update possibilistically: it eliminates the extrapolations a prefix misses (`Learning`). What it lacks is weighted conditioning.
    - So the board's sentence "the theory's probability is counting over courses" is right only within these limits: there is no normalized measure.
  - **Row 3.** "A single blanket identifies the two": the principle has one dependence structure, the sparsity of the flow, so it has no separate feeding relation. Its steady state presupposes that what feeds the thing goes on feeding it.
  - **Row 7.** "None for requirements": its characteristic states are a soft form of requirement. What it lacks is the threshold.
  - **Row 9.**
    - "Never beyond it" is true for a fixed generative model. Structure learning in active inference changes the lumping, though only through what couples in.
    - "Selection through a model of the options" is the title retired by [the 18 October vocabulary decisions](../../REGISTRATION-VOCABULARY-STUDY.md#7-decisions-18-october-2026) (row 15: "selection factors through a map of the alternatives").
- **Fix.**
  - Row 1: "weights over courses, every weighting a premise (`Becoming.Weighted`; counting, possibility and signed counts are instances); counting over two-valued courses with natural weights, with Chebyshev's and Chernoff's bounds and the counting law of large numbers (`Becoming.Typicality`); possibilistic elimination (`Learning`), but no weighted conditioning, surprisal or density".
  - Row 3: "…the principle has one dependence structure, the flow's sparsity, and no separate relation of feeding; its steady state presupposes that what feeds the thing goes on feeding it".
  - Row 7: "requirements only as characteristic states, with no threshold".
  - Row 9: "selection through a map of the alternatives … curiosity explores within a fixed model's lumping; structure learning changes the lumping, but only through what couples in".

**18. Reading 3 infers escape from a failed hypothesis.** *Overclaim.*
- **Location.** NOTE §5, reading 3. The board's UE1 row: "escaping the optimizer's drain but not the commons".
- **What is wrong.**
  - **A failed hypothesis is not a conclusion.** The optimum law needs an order rising with what couples in, with room. That this fails for a set-point order shows the law does not reach such a chooser. It does not show that the chooser does not drain.
  - **Set-point orders can still rise.** Over courses, an order of set-point preferences can still rise with what couples in: for example in the steps spent at the set point, or in a resource drawn while below it.
  - **Not all preferences are set points.** Many active-inference preference vectors are monotone (reward outcomes).
  - **Two phrases go beyond the Lean.** "Not through maximization" goes beyond it. So does "none sees this through its own couplings": the joint-excess law (`Pair.own_not_joint`, `Flow.joint_excess_ends`) says nothing about couplings, and a chooser into which the stock couples sees the level fall.
- **Fix.** "**A chooser with set points is not reached by the optimum law.** Where preferences are characteristic states there is a point of enough. The optimum's drain needs an order rising with what couples in, and room (05), which a set-point order is not, so the law does not apply to such a chooser as such. That it does not drain is not shown: over courses its order can still rise with what couples in, and many preference vectors are monotone. Joint excess applies to any takers: several, each within renewal, can end it together. A law for set-point orders is open item (b)."

**19. Reading 4: sharing a model is not pooling.** *Imprecision.*
- **Location.** NOTE §5, reading 4: "Shared generative models pool couplings. Sharing beliefs extends what a group tells apart to what some member tells apart".
- **What is wrong.**
  - **A shared model pools nothing.** A shared generative model, a common structure, pools nothing by itself. Exchanging beliefs (messages) does, at most up to the pooled coupling.
  - **The pool law gives a bound.** It bounds what any selection through the pool tells apart, and shows that *some* such selection separates. It does not show that belief sharing reaches the bound.
  - **Hypotheses.** The blindness conclusion (`Flow.act_unselected_pool`) holds under its hypotheses: the rest following one law of exchange reading through coupling, balanced flows, and one start.
- **Fix.** "**Belief sharing pools couplings, at most.** Choosers that exchange beliefs tell apart at most what some member tells apart (05); sharing a generative model alone pools nothing. Where the rest follows one law of exchange reading through coupling, a collective of self-evidencers is blind beyond the union of its members' closures, its own acts included…"

**20. Reading 1: "no place for that gap".** *Imprecision.*
- **Location.** NOTE §5, reading 1.
- **What is wrong.**
  - The principle's active states can reach external states whose consequences never return through sensory states, so the gap exists in its terms.
  - What it lacks is a separate feeding relation. Its steady state assumes the gap away.
- **Fix.** "With one dependence structure, the principle has no separate place for that gap, and its steady state presupposes that what feeds the thing goes on feeding it. 05's commons and the optimum's drain live in the gap."

**21. The third part, as stated, does not survive.** *Overclaim.*
- **Location.**
  - PLAN §3: "Three things it forbids that the principle leaves open".
  - The study draft `study_ue1.txt`, lines 59–63.
  - NOTE §4, "What the law adds".
- **What is wrong.**
  - **The first is known, and shown by the process theory.** A count of one's own choices that, past a lead, makes every later choice follow the leader, whatever the standing preference, is the lock-in of increasing returns. Arthur (1989), as summarized: a point after which every newcomer chooses the same technology regardless of its natural preference.
    - Active inference's own simulation already exhibits it: the habit "reinforces itself with repeated executions".
    - So the process theory does not leave the persistence open. What the kit adds is "never", for a simplified model, under finding 7's hypothesis. For a sampling agent even that becomes a claim about the argmax.
  - **The second concerns a rule active inference does not use.** "No lock under posterior counting against a standing score" concerns the posterior at the time of choosing (finding 1).
    - Without that qualifier it will be read as a claim about active inference's own posterior counting, which locks in effect.
    - As a statement about the `soft` rule it is the mediant inequality, true of that rule in any framework, and not something the principle leaves open.
  - **The third is a reading.** It is the pool law read onto belief sharing, under hypotheses the plan omits (finding 19).
  - **By the plan's own §6.** A containment whose third part stays empty after an honest search is a restatement. Here the honest search is still to be made.
- **Fix.**
  - In the plan and the study, record the lock as a known result. A row for 08 §8: "Habit capture is the lock-in of increasing returns (Arthur 1989); counting the action taken is the value-free habit of Miller, Shenhav and Ludvig (2019)".
  - Restate the first forbidden statement with its hypotheses ("…the rule in force read from the counts, the score standing, the choice the argmax…").
  - Drop the second from the third part, or restate it as a contrast between two update rules.
  - Keep the third as a reading with its hypotheses.
  - Record UE1 as "restatement; third part open". A candidate for a real third part is a statement the principle's literature makes that the theory forbids. For example, take any claim in "Designing ecosystems of intelligence" that belief sharing lets a collective respond to what no member couples to.

### Names and hygiene

**22. Names.** *Suggestion.*
- **Location.** The module name `Becoming.HabitCapture`; `beliefAfter` and its parameter `record`; `soft`; "belief" and "chooser" in the declarations' docstrings.
- **What is wrong.**
  - **The module name.** [Board rule 8](../../../../../BECOMING-WORKBOARD.md) names a correspondence module after the core law it instantiates, in the core's vocabulary. "Habit" is a limited-scope word.
  - **`beliefAfter` and `record`.** The 18 October decisions replaced "belief" (row 5) and "record" (row 8: "prefix"). `beliefAfter` names an arbitrary fold of the prefix.
  - **`soft`.** It names nothing structural.
  - **Words that can stay.** "Choice" and "score" are core vocabulary (`Relabel.EquivariantChoice`, `ScoresThrough`).
- **Fix.**
  - Choose a name stating the structure, for example `Becoming.ChoiceCountCapture`: capture through the rule, whose share counts the choices made.
  - Rename `beliefAfter (update) (start) (prefix)` to `foldAfter`.
  - Replace `soft` with finding 11's rule `byScore`.
  - Keep "habit", "belief" and "posterior" in the correspondence paragraphs.
  - Name it before landing, as AGENTS.md asks.

**23. Small text fixes.** *Suggestion.*
- **The rule's second argument is idle.** `weighted κc κo pos x _` ignores the rule in force, so every habit theorem carries a dummy `g` (the witnesses pass `counts counts`). The in-sync start, a real hypothesis (finding 7), hides behind it. State the start as `(x, weighted κc κo pos x x)`, or define `weightedRule κc κo pos x` and use it. Say "the rule in force read from the counts" in each docstring.
- **`Witness.counts` docstring.** "at the threshold `2 · 1 ≤ 1 · 3`, so above it" should read "above the threshold: `2 · 1 ≤ 1 · 3`".
- **NOTE §4, "an instance module of two spine laws".** It instantiates three: selection through couplings, capture through the rule, and closed capture.
- **NOTE §4, the soft bullet.** Add "carriers present".

## Where the findings recur

Untracked drafts appeared in this folder during the review: `texts_ue1.py`, `study_ue1.txt`, `make_records_ue1.py`, `integrate_ue1.py`, `board_ue1.py`, `register_ue1.py` and `POOL-ADDITION.patch`. They were not reviewed, but they repeat these findings:

| Finding | Where it recurs |
|---|---|
| 1, 14 | `texts_ue1.py` line 40; `study_ue1.txt` line 50 ("checked verbatim"); `make_records_ue1.py` line 173 |
| 2, 4 | `make_records_ue1.py` lines 91, 151, 176 and 182; `study_ue1.txt` lines 31–38 and 55 |
| 12 | `study_ue1.txt` line 20 |
| 19 | `make_records_ue1.py` line 181 |
| 7, 21 | `study_ue1.txt` lines 59–63 |

The board's UE1 row repeats findings 4 and 18, and the board's item 6 under "Now" repeats the probability sentence of finding 17. The plan's §3 and §6 repeat findings 2, 3, 4 and 21.

## Not reviewed

- The landing drafts above, beyond the lines cited.
- The source record of 25 October.
- UE2 and UE1b.
- The 2016 paper's Eq. 7 and figures, which are images.
- The full texts of Friston and others (2019, 2023) and of Bruineberg and others.
- Whether the 2016 simulations ran on the revision of `spm_MDP_VB.m` read here (r7120, June 2017, a year after the paper). The paper's own wording, "beliefs about … selected policy" counted "at the end of each trial", agrees with it.

## Appendix: the probe module

The probe was built with `python3 -B scratch_build.py <tree> Becoming.HabitCaptureProbe`, beside an unchanged copy of the kit: 16 theorems in 20 declarations, every axiom report empty. It is scratch only, not for landing as it stands.

```lean
import Becoming.HabitCapture
import Becoming.RuleShaping

/-! Review probes for `Becoming.HabitCapture` (scratch only, not for landing). -/

namespace Becoming

namespace HabitCaptureProbe

open Pace RuleCapture CarrierCounts HabitCapture

/-! ## 1. `soft` is selection by a fixed rule, and its laws are `RuleShaping`'s -/

/-- The fixed rule `soft` selects by. -/
def postRule (κc κo s : Nat) (pos : 0 < κo) : CarrierCounts :=
  ⟨s + κc, s + κo, Nat.lt_of_lt_of_le pos (Nat.le_add_left κo s)⟩

theorem soft_is_select {κc κo s : Nat} {pos : 0 < κo} (x : CarrierCounts) :
    soft κc κo s pos x = CarrierCounts.select x (postRule κc κo s pos) := rfl

theorem soft_falls_by_shaping {κc κo s : Nat} {pos : 0 < κo} (x : CarrierCounts)
    (some : 0 < x.carrier) (score : κc < κo) :
    (soft κc κo s pos x).carrier * x.other < x.carrier * (soft κc κo s pos x).other :=
  RuleShaping.falls_strictly (g := postRule κc κo s pos) some (Nat.add_lt_add_left score s)

theorem softCourse_orbit {κc κo s : Nat} {pos : 0 < κo} (x : CarrierCounts) :
    ∀ n, softCourse κc κo s pos x n =
      Law.orbit (fun y => CarrierCounts.select y (postRule κc κo s pos)) x n
  | 0 => rfl
  | n + 1 => congrArg (fun y => CarrierCounts.select y (postRule κc κo s pos)) (softCourse_orbit x n)

theorem soft_course_falls_by_shaping {κc κo s : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (scale : 0 < s) (some : 0 < x.carrier) (score : κc < κo) (n : Nat) :
    (Law.orbit (fun y => CarrierCounts.select y (postRule κc κo s pos)) x (n + 1)).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (postRule κc κo s pos)) x n).other <
      (Law.orbit (fun y => CarrierCounts.select y (postRule κc κo s pos)) x n).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (postRule κc κo s pos)) x (n + 1)).other :=
  RuleShaping.falls_strictly
    (RuleShaping.present_along (Nat.lt_of_lt_of_le scale (Nat.le_add_right s κc)) some n)
    (Nat.add_lt_add_left score s)

/-! ## 2. `soft_gives_way`: after the first step the weighted reading still favours the first
policy (a tie, which `choose` gives to the first); from step 2 it favours the second -/

theorem two_pos : 0 < 2 := Nat.zero_lt_succ 1

theorem soft_step_one_still_favours :
    favours (weighted 1 2 two_pos (softCourse 1 2 1 two_pos Witness.counts 1) Witness.counts) :=
  show 2 * 3 ≤ 1 * 6 by decide

theorem soft_step_two_turns :
    ¬ favours (weighted 1 2 two_pos (softCourse 1 2 1 two_pos Witness.counts 2) Witness.counts) :=
  show ¬ 2 * 9 ≤ 1 * 12 by decide

/-! ## 3. `habit_locks_down` can carry the rule part its docstring states, and the choice -/

theorem habit_locks_down_rule {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (below : κc * x.carrier < κo * x.other) (reads : Nat → Bool) (t : Nat) :
    (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).2
      (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).2 :=
  have locked : Locked (reverse order) (fun g => g.carrier < g.other) (weighted κc κo pos)
      (x, weighted κc κo pos x g) := ⟨below, (reverse order).refl _⟩
  Eq.subst (motive := fun n =>
      (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n).2
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (n + 1)).2)
    (Nat.zero_add t)
    (locked_rises (reads := reads) (c := (x, weighted κc κo pos x g)) (t := 0) choose_lowers
      weighted_reads.reverse lower_strict locked t).2

theorem habit_chooses_down {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (below : κc * x.carrier < κo * x.other) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).1 =
      ⟨(paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1.carrier,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1.other + 1,
        Nat.succ_pos _⟩ :=
  (paced_fast_succ (f := choose) (h := weighted κc κo pos) (reads := reads)
      (x, weighted κc κo pos x g) t).trans
    (choose_unfavoured (Nat.not_le_of_gt (habit_locks_down (pos := pos) (g := g) below reads t).1))

/-! ## 4. A change of configuration across the threshold leaves the lock: one count moved from
three to one to three to two, under the score one to two, and the course locks the other way -/

def moved : CarrierCounts := ⟨3, 2, two_pos⟩

theorem moved_locks_down (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 two_pos) reads (moved, weighted 1 2 two_pos moved moved) t).2.carrier <
      (paced choose (weighted 1 2 two_pos) reads (moved, weighted 1 2 two_pos moved moved) t).2.other :=
  (habit_locks_down (κc := 1) (κo := 2) (pos := two_pos) (x := moved) (g := moved)
    (show 1 * 3 < 2 * 2 by decide) reads t).1

/-! ## 5. The start's rule matters: a rule in force not read from the counts (stale) -/

/-- The rule a reading under an older score left in force: favouring the second policy four to
one. -/
def stale : CarrierCounts := ⟨1, 4, Nat.zero_lt_succ 3⟩

/-- Counts three to one (above the threshold of the score one to two), the stale rule in force,
read at every step: locked the other way at step 5. -/
theorem above_but_stale_locks_down :
    Locked (reverse order) (fun g => g.carrier < g.other) (weighted 1 2 two_pos)
      (paced choose (weighted 1 2 two_pos) (fun _ => true) (Witness.counts, stale) 5) :=
  ⟨show 5 < 6 by decide, show 5 * 6 ≤ 5 * 8 by decide⟩

theorem above_but_stale_never_first (k : Nat) :
    (paced choose (weighted 1 2 two_pos) (fun _ => true) (Witness.counts, stale) (5 + k)).2.carrier <
      (paced choose (weighted 1 2 two_pos) (fun _ => true) (Witness.counts, stale) (5 + k)).2.other :=
  (locked_stays (reads := fun _ => true) (c := (Witness.counts, stale)) (t := 5) choose_lowers
    weighted_reads.reverse lower_strict above_but_stale_locks_down k).1

/-- A devaluation read one step late. Counts three to one; the new score one to four puts them
below its threshold (`4 · 1 > 1 · 3`), so read at once the course would lock the other way
(`habit_locks_down`). With the rule of the old score (one to one) still in force and the first
reading at step 1, the course is locked for the first policy from step 2. -/
def late : Nat → Bool := Witnesses.profile [false] true

theorem four_pos : 0 < 4 := Nat.zero_lt_succ 3

theorem devalued_read_late_locks_up :
    Locked order favours (weighted 1 4 four_pos)
      (paced choose (weighted 1 4 four_pos) late (Witness.counts, Witness.counts) 2) :=
  ⟨show 4 ≤ 4 by decide, show 4 * 4 ≤ 5 * 4 by decide⟩

theorem devalued_read_late_keeps_first (k : Nat) :
    favours (paced choose (weighted 1 4 four_pos) late (Witness.counts, Witness.counts) (2 + k)).2 :=
  (locked_stays (reads := late) (c := (Witness.counts, Witness.counts)) (t := 2) choose_raises
    weighted_reads upper devalued_read_late_locks_up k).1

theorem devalued_read_at_once_locks_down (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 4 four_pos) reads
        (Witness.counts, weighted 1 4 four_pos Witness.counts Witness.counts) t).2.carrier <
      (paced choose (weighted 1 4 four_pos) reads
        (Witness.counts, weighted 1 4 four_pos Witness.counts Witness.counts) t).2.other :=
  (habit_locks_down (κc := 1) (κo := 4) (pos := four_pos) (x := Witness.counts)
    (g := Witness.counts) (show 1 * 3 < 4 * 1 by decide) reads t).1

end HabitCaptureProbe

end Becoming
```

## Re-check of the revision (565185307)

Read: [NOTE.md](NOTE.md) and [tree/Becoming/ChoiceCountCapture.lean](tree/Becoming/ChoiceCountCapture.lean) at `565185307`, with the plan and the board's UE1 row as revised in `41cde6b83`. The kit tree was rebuilt with `scratch_build.py`: 35 theorems in 45 declarations, every axiom report empty, as stated. The landing drafts were not read, as asked.

**Verdict.** The revision takes the findings faithfully. Every count law now starts in sync, `counted_locks_down` carries its rule clause, and `counted_chooses_down` is added. The posterior-counting laws are now instances of `RuleShaping`. The witnesses from the probe, the stale-rule and moved-count edges, are in the module with correct docstrings, and the NOTE no longer claims a third part. Three small new issues remain, none in a proof. The module is ready to land as a leaf instance module once N1 below is fixed.

**(1) The findings.**
- **Addressed (22):** 1–17, 19–23.
  - 3 and 4: the plan and board follow in `41cde6b83`.
  - 11: `weighted`, `weighted_reads` and `lower_strict` stay in the leaf, with the reason stated, as rule 9 allows.
  - 17: the board's probability sentence is gone.
- **Partly addressed (1):** 18. The escape claim is withdrawn, but its replacement rests on an unreviewed draft (N2).

**(2) New issues.**
- **N1. Overclaim, Lean docstring.** `pooled_unchosen_beyond` is titled "Sharing folds moves the boundary outward and no further". It proves only "no further": the choice is blind beyond the pool's coupling closure. The outward half is 05's law (`Web.separates_all_iff_member`).
  - Fix: retitle it "Choosers sharing their folds are blind beyond the pool's coupling closure". To state the outward half, cite `Web.separates_all_iff_member`.
- **N2. Imprecision, NOTE §5 reading 3.** "UE1b … proved it wrong" states the results of a drafted kit as proved. UE1b (`e1427437c`) has a scratch build but no review.
  - Fix: write "UE1b's draft kit, not yet reviewed, states …". The reading then stands on that kit pending its review. Keep it out of the record until UE1b lands.
- **N3. Imprecision, NOTE §7(c), from this review's own wording.** "For a sampling agent, the claim is about the argmax" is ambiguous. In a sampling agent a sampled choice of the other policy is a change of the counts, and the law does not exclude a crossing by one.
  - Fix: "the prediction is for an agent choosing the argmax; with sampled choices it holds only while no sampled choice of the other policy carries the counts across the threshold".
- **Trivial.**
  - NOTE §4, "adds the end-of-trial posterior … to the habit's counts": the counts are the prior's over all policies (`e`).
  - `start_locked`: its docstring says "the course is locked"; the theorem is about the start.

**(3) Landing.** Ready as a leaf instance module of selection through couplings, capture through the rule and closed capture, after N1. The record should carry:
- its scope: two policies of distinct behaviour, an argmax chooser, ties to the first policy, the in-sync start and a standing score;
- part 1 and the pooled part as near-definitional instances of 03 §1 and 05's pool law;
- the restatement verdict.

Its home section belongs beside capture through the rule (02 §9). The 08 §8 row should name the lock-in of increasing returns (Arthur 1989) and the value-free habit (Miller, Shenhav and Ludvig 2019). The record should not cite UE1b's draft results or the sampling clause of N3.
