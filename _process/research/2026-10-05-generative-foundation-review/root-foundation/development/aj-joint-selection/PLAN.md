# AJ: alignment of the joint selection (plan)

24 October 2026. AI-authored plan for the coordination of this line ([source of the goal](../../../../../../sources/15-codex-theory-conversations/2026-10-24-alignment-of-the-joint-selection.md)). It states the goal in the account's terms, argues for that representation, lists what is on main, what is verified elsewhere and what is missing, and orders the path. The board shows the path and holds the claims ([board](../../../../../BECOMING-WORKBOARD.md)); results are stated in their records and home sections, not here.

## 1. The goal

The goal is the missing connection of an existing scope, [generative alignment](../../../../../../GOALS.md#generative-alignment), whose objective already names the "alignment of selection rules themselves" and whose completion asks each study to name the connection it supplies. Stated in the account's terms:

**An alignment of the joint selection.** Humans, institutions and trained systems select together, and that joint selection is what is aligned. It is aligned where three conditions hold:

1. **Control is not selected.** Capacity to control the selection is not itself selected, because what such control returns does not come back to the controller within the time correction takes. *Being proved: MA3, its statements fixed (§3).*
2. **A lock is left in time.** Where a lock forms, the selection leaves it by reading what lies beyond its share before the loss passes its point of no return. *Proved under named premises:* [closed capture](../../../../../../theories/becoming/results/records/closed-capture.md), with timing from MA2 (verified, not on main).
3. **Courses are compared by widening.** Every positive weighting ranks a widening higher, and widening ranks no narrowing above what it narrows. *Proved:* [widening by every weighting](../../../../../../theories/becoming/results/records/widening-as-what-every-weighting-ranks.md).

Whose losses count is the continuation condition, and that widening is better is C. Both are named and neither is asserted.

**What the goal is not:**
- *An AI obedient to its principal.* It adds capacity to the principal's optimization without adding couplings, and several optimizers at a mutual best response drain what lies beyond them as one of their joint capacity would ([record](../../../../../../theories/becoming/results/records/several-optimizers-drain-by-their-joint-capacity.md)).
- *An AI with fixed good values.* A fixed proxy is exactly the direction a capture promotes.
- *A single scalar of any kind.*
- *A final state.* Completion is not closure ([08 §12](../../../../../../theories/becoming/chapters/08-METHOD.md#the-work-by-its-own-laws)).

**Instrumental convergence and the meta-attractor.** Instrumental convergence is the one-agent case of condition 1's failure: a long-horizon optimizer keeps its own base at the level of greatest renewal and breaks at once every dependence that needs more ([horizon optima](../../../../../../theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md)). The [meta-attractor](../../../../../../theories/meta-attractor/README.md) is the failure of conditions 1 and 2 together: control over the selection is selected, and the rule it shapes locks.

## 2. Why this representation

- **The unit is the selection, whoever selects.** A selection reaches only what couples into its selector ([selection through couplings](../../../../../../theories/becoming/results/records/selection-through-couplings.md)), and this holds of a rater, a training run, a market or an institution alike. A goal stated for "the AI" takes the wrong unit. Taking the right unit also keeps the one relational start: humans and AI are not opposed parties bargaining over a fixed sum.
- **A criterion, not a target.** A target stated as a quantity becomes the share a selection reads. A rule read from the share it selects locks ([capture through the rule](../../../../../../theories/becoming/results/records/capture-through-the-rule.md)), and where the reading is formed from the share too, the lock outlives any loss it does not read. Widening is not a quantity. It is what every positive weighting agrees on, and it leaves mixed comparisons unranked, so no proxy can stand in for it.
- **Conditions with their edges, not guarantees.** Each lock has exact counterexamples:
  - without its start condition, the loop alternates forever;
  - a perturbation that reverses direction is not absorbed;
  - read from the loss instead of the share, the loop turns.

  Alignment is staying on the right side of those edges. Each edge can be checked locally: does the rule read the share; who reads the loss, and when; does control come back to the controller?
- **Premises named, so the mechanism is shared.** People who disagree about scope or order can still agree on what a selection reaches and when it locks.

## 3. What there is

**On main.**
- the two selection laws: [selection through couplings](../../../../../../theories/becoming/results/records/selection-through-couplings.md), and the optimum's drain on what lies beyond its couplings;
- [drawn from beyond](../../../../../../theories/becoming/results/records/a-rise-past-the-inflow-is-drawn-from-beyond.md);
- [horizon optima](../../../../../../theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md), with `gated_alike`: two optima that take the same, one keeping a dependent and the other breaking it;
- [joint capacity](../../../../../../theories/becoming/results/records/several-optimizers-drain-by-their-joint-capacity.md);
- [a race for position](../../../../../../theories/becoming/results/records/a-race-for-position-draws-everything.md);
- [own count misses joint excess](../../../../../../theories/becoming/results/records/own-count-misses-joint-excess.md);
- capture through the rule and closed capture;
- widening by every weighting;
- [what training installs](../../../../../../theories/becoming/results/records/what-training-installs.md);
- [the alignment direction under widening](../../../../../../theories/becoming/results/records/alignment-direction-under-widening.md);
- the theses T3 (optimization drains what lies beyond its couplings where that gives room) and T7 (a measure read from what it selects outlives its refutation), both conjectured for actual systems ([08, theses](../../../../../../theories/becoming/chapters/08-METHOD.md#theses)).

**Verified, not on main.** MA2, readers drawn from the selected:
- branch `ma2`, tip `e8257c8ce` (22 October 2026), last merged with main that day;
- `Becoming.ClosedCapture` gains 42 declarations, every axiom report empty;
- record `readers-drawn-from-the-selected`.

It derives `ReadsShare` where each carrier's reading favours the carriers at least as much as each other's. The same readers reading the same loss turn the course if they read it in time and leave it locked if they read it late. Its owner session has been idle since that day.

**Claimed, statements fixed.** MA3, selection on the capacity to shape the rule, is a new leaf module `Becoming.RuleShaping` on `RuleCapture`'s counts. A fork of the conversation that wrote this plan claimed it on 24 October 2026 and fixed its statements the same day: 38 theorems in 46 declarations, every axiom report empty in a scratch build, not yet the checker.

The rule after shaping, `shaped a s p c`, gives each shaper `a + s + p` offspring and each other member `a + c + p`:
- `s` is what comes back to the shapers alone;
- `p` is what comes to every member alike;
- `c` is the cost of shaping;
- `a > 0`.

Its statements:
- **The sign.** The rule favours the shapers exactly where `c ≤ s` (`favours_iff`), and `p` decides nothing (`favours_alike`). A larger shared part lowers the rule in the share order without reversing it (`shared_lowers`).
- **Cost.** A cheaper cost gives a rule not lower (`cheaper_raises`).
- **Nothing comes back.** With nothing coming back and a cost, the shapers' share falls strictly at every step (`open_falls`).
- **Timing.** Over `m` steps paying and then `n` steps returning, the share does not fall exactly where `(a+c)^m (a+c)^n ≤ a^m (a+s)^n` (`stretch_iff`). A later return is not more (`later_not_more`), and where `c ≤ s` a longer one is not less (`longer_not_less`).
- **The lock.** `ReadsShare` holds exactly where what comes back is read monotonically from the share (`byReturn_reads_iff`). Where the return covers the cost at every share, the course locks (`return_locks`, by `RuleCapture.favouring_locks`).
- **A threshold.** Where the return covers the cost only above a threshold share, the share starting above it never falls below its start, and starting below it never rises above its start (`tip_from_above`, `tip_from_below`).
- **Witnesses.**
  - With the same total return of five, kept as `(s, p) = (2, 3)` the rule favours the shapers, and shared as `(0, 5)` it disfavours them (`ComesBack`).
  - A return that comes soon raises the share (`Timing.soon_rises`). One that comes late, or is cut short by correction, lowers it (`Timing.late_falls`, `Timing.corrected_falls`).

This is the second order of the meta-attractor line ([its conditional result of 2 October](../../../../../../theories/meta-attractor/README.md#selection-for-control-over-selection-2026-10-02-after-review)), until now a derivation over the reals and a simulation with no Lean. The join to MA2's readers waits for MA2 to land.

**Missing.**
1. The readings of MA3 for alignment.
2. Any test on a trained system.
3. A statement for alignment readers.
4. Positioning against the structural-risk literature. The [alignment literature assessment](../../../foundation-assessment/ALIGNMENT-LITERATURE.md) covers single-agent comparators (assistance, corrigibility, reward tampering, power-seeking, attainable utility preservation, pluralistic alignment) and not the selection and structural-risk work closest to this goal.

## 4. The path

Pace, as the board's *Now* section and [08 §12](../../../../../../theories/becoming/chapters/08-METHOD.md#the-work-by-its-own-laws) state it: a few lines landed come before many held open. At most two of these run at once, and now the two are MA3 and this plan.

**Step 1. MA2 lands.** Unified head first: merge main into `ma2`, renumber its study section, re-render, run the core checker, then take the queue.
- Its owner session has been idle since 22 October. By board rule 4 the claim lapses after three days without activity, about 25 October, 20:00 Asia/Bangkok, and any session may then reclaim it and land it.
- Ren can resume the owner session sooner.
- Nothing waits on it: MA3 builds on main alone and joins MA2 once it lands.

**Step 2. MA3** (its owner). What this plan asks of it, for the owner to take or leave:
- **Positioning, in its record's correspondence:**
  - Price (1970);
  - niche construction (Odling-Smee, Laland and Feldman 2003);
  - rent-seeking (Tullock 1967; Krueger 1974);
  - regulatory capture (Stigler 1971);
  - the persistence of elites (Acemoglu and Robinson 2008);
  - power-seeking (Turner and others 2021);
  - natural selection among AIs (Hendrycks 2023);
  - influence-seeking patterns (Christiano 2019);
  - robust agent-agnostic processes (Critch 2021);
  - gradual disempowerment (Kulveit and others 2025);
  - the logic of collective action (Olson 1965), added by MA3's owner for the shared part that selects nothing.
- **Expected standing:** the comparison of offspring numbers is elementary. What is new are the conditions, stated on the spine, joined to capture and to MA2's readers, and each bounded by a witness.
- **Taken by its owner** (24 October). The list and this standing go into MA3's record, which says that the join to MA2's readers waits for MA2. MA3 keeps to 02 §9 and its record, so the readings of step 3 are AJ's.

**Step 3. AJ2: the readings for alignment,** drafted by AJ after MA3 lands, as agreed with MA3's owner. They are readings in 07's alignment section, with instance theorems only where a reading needs one:
1. *Help that lowers the cost of shaping moves the threshold toward the shapers* (`cheaper_raises`). Capable assistance to a principal raises the selection for control.
2. *An assistant joined to its principal adds capacity and no coupling.* What lies beyond falls as under one optimizer of their joint capacity. This rests on the joint-capacity record, not on MA3.
3. *A counter-rule read from its own share* locks like the rule it replaced (the examination case of the meta-attractor line), and leaves only by reading beyond. This rests on `RuleCapture` and closed capture, not on MA3.
4. *Shared rule-making*, where what comes back comes to every member alike, gives shaping no advantage (`favours_alike`), and a cost then selects against it (`open_falls`). The `ComesBack` witness shows the same total return deciding the sign by whether it is kept or shared.

**Step 4. AJ3: tests on trained systems,** each designed and frozen before it is run, as LA1 was:
- **LA1, first.** It is frozen ([experiment](../../../../../../experiments/commons-llm-feedback/)) and tests T3.
- **LA2: a lock in a self-rewarding loop**, testing T7. A model is judged by a judge formed from its own selected outputs, with a loss the judge does not read. Predictions: from closed capture, the loss persists however large while unread, and a reading of it turns the course; from MA2, read late, it leaves the course locked.
- **LA3: what comes back decides the sign**, testing MA3 on its exact classes. Agents in a population can spend on shaping their evaluator, and what the shaping returns comes either to them alone or to every member alike. Predictions:
  - With the same total return, spending on shaping rises where the return is theirs alone and covers the cost (`c ≤ s`), and falls where it is shared (`s = 0`, `c > 0`), as in the `ComesBack` witness.
  - A return that comes soon raises it; one that comes late, or is cut short by correction, lowers it (`stretch_iff`, the `Timing` witnesses).

MA3's statements are fixed, so nothing in the designs waits on them. By the pace above, the designs start when MA3 lands. Spending model usage on any of the three is Ren's choice.

**Step 5. AJ4: the account for alignment readers,** after MA3 lands so it carries the result:
- one page in plain words: the goal, the readings, the laws with their premises, what is open, and the tests;
- a dossier in the review packet's format for alignment researchers. The packet's scope is Ren's choice.

It is not a paper.

## 5. What a good job is, as its readers will judge it

The best predictor of how alignment researchers will read this line is how the four AI reviewers read the meta-attractor's conference paper on 2 October 2026. They found three faults:
- the alignment claims were not in the model;
- the mathematics was classical and presented as new;
- nothing was measured.

A good job fixes all three:
- MA3 and AJ2 put the alignment claim in the model, with its conditions.
- Each record says which comparison is elementary and what is added.
- AJ3 measures on trained systems, with the predictions frozen first.

Two further conditions: one page that a reader finishes, and positioning against the closest work in step 2.

## 6. What would change the plan

- **MA2 does not land.** MA3 stands on `RuleCapture` alone, and the timing of a reading stays a premise.
- **MA3 does not land as fixed.** If its join to capture (`byReturn_reads_iff`, `return_locks`) does not pass the checker, the readings in step 3 that rest on MA3 are not warranted by it, and AJ4 says so.
- **A frozen test fails where its prediction forbids.** The thesis moves.
- **A better argument for another order.** It replaces this one; the order here is the AI's.

## 7. Owners

| Item | Owner | State |
|---|---|---|
| MA2 | its 22 October owner session | verified on `ma2`; not landed; owner idle; lapses about 25 October, 20:00 Asia/Bangkok |
| MA3 | the fork of the unification-and-coherence conversation | statements fixed 24 October 2026 (scratch build); landing next |
| AJ (this plan, AJ2 to AJ4) | the coordinating session of this plan (fork 2 of the same conversation) | plan written; AJ2, AJ3's designs and AJ4 start after MA3 lands, AJ2 drafted here as agreed with MA3's owner |
| LA1, LA2 and LA3 usage; AJ4's dossier; the goal's objective | Ren | proposed to him |
