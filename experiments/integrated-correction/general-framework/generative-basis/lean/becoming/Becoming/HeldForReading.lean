import Becoming.ShownOrder
import Becoming.ReadingLoop
import Becoming.RevisionPlans

/-!
# An act held for a reading

A formation can act on its model of which candidate holds, or hold its act for a reading that tells
which holds and act after it. This module states, in counts, what holding is worth, and what it is
worth where the reading stops or releases the act (board item RF, round 2, second part, written for
RF-M's case of a formation read by another, the literature's principal and helper). In the counts
the reading is a rule on the candidates (`byRule`); in `SignLoop` it is the law of what the
formation senses, reading its held act and the true sign; the reading formation's own state is not
represented. The values, weights and rules are supplied, and their formation and warrant are not
derived.

* **The worth of a reading, in counts.** A model lists candidates with natural-number weights, and
  acts have natural-number values at each (`Model`, `Model.committed`, `Model.after`). A policy best
  at every candidate among the acts open exists for every nonempty list of acts (`bestOf_best`).
  Given one best at every listed candidate, any policy choosing open acts there, one reading the
  candidates through a map of them or one reading nothing among them, falls short of it by the
  weighted total of the amounts by which its act is valued below the best at each listed candidate
  (`after_add_gap`): it stands at most as high, as high exactly where its act is valued as the best
  at every listed candidate of positive weight, and below exactly where some such candidate values
  it lower (`after_le_after`, `after_eq_after_iff`, `after_lt_after_iff`). Committing to one open
  act is the policy reading nothing (`committed_le_after`, `committed_eq_after_iff`, `below_iff`):
  the reading gains over every open act exactly where none is valued as the best at every listed
  candidate of positive weight (`reading_gains_iff`). Some policy taking one open act at each cell
  of a map stands as high as the best exactly where each cell has one open act valued as the best at
  every listed candidate of positive weight in it, given choice over the whole type of cells
  (`cell_policy_iff`). Values raised at each candidate by one amount for every act order every two
  policies of a model alike (`after_offset`, `after_offset_le_iff`).
* **Holding for a reading that stops or releases** (two moves, `Move`). Going on has a gain and a
  loss at each candidate and switching off has nothing; with the loss added to both moves at each
  candidate, going on is valued at the gain and switching off at the loss (`shifted`), every value a
  natural number; read as differences, going on is valued at the gain less the loss and switching
  off at nothing, and every two rules of stopping compare on the shifted values as on these
  (`after_rule_le_iff`). Holding for the reading that tells the candidate, which stops exactly where
  the loss exceeds the gain (`byReading`), is going on with the weighted excess of switching off
  over going on, and switching off with that of going on over switching off (`after_byReading`, with
  `offExcess` and `goExcess`): it never stands below either move (`committed_le_held`), and stands
  above both exactly where the model gives positive weight to both strict signs, some candidate of
  positive weight where going on loses and some where it gains (`held_gains_iff`). A candidate where
  gain and loss are equal counts for neither. It stands only as high as going on exactly where the
  excess of switching off is nothing, and only as high as switching off exactly where that of going
  on is (`held_eq_go_iff`, `held_eq_off_iff`), each excess nothing exactly where the model gives no
  positive weight to its strict sign (`excess_pos_iff`).
* **Any rule of stopping** (`byRule`). Holding for it stands at least as high as going on exactly
  where, over the candidates it stops, the weighted loss is at least the weighted gain
  (`rule_not_below_go_iff`), and as switching off exactly where, over those it releases, the
  weighted gain is at least the weighted loss (`rule_not_below_off_iff`). Read as differences,
  holding for it with the weighted loss where it releases is the weighted loss over every candidate
  with the weighted gain where it releases (`after_rule_add_onLoss`). A rule's shortfall from the
  reading that tells the candidate (`shortfall`: where it stops, the excess of going on there; where
  it releases, that of switching off) is what holding for it loses against that reading
  (`after_add_shortfall`); with its shortfall, holding for the rule is going on with the excess of
  switching off, and switching off with the excess of going on (`after_add_shortfall_go`,
  `after_add_shortfall_off`).
* **What holding forgoes.** Holding for any rule, forgoing an amount, stands at least as high as
  going on exactly where its shortfall and the amount together are at most the excess of switching
  off, and above it exactly where they fall below it (`threshold_go_iff`); against switching off,
  the excess of going on takes its place (`threshold_off_iff`). The amount is counted in the units
  of the weighted totals: read as probabilities over a total weight `T`, an amount `c` forgone for
  each decision enters as `c * T`. The reading that tells the candidate falls short nowhere
  (`shortfall_byReading`), so holding for it, forgoing an amount, stands at least as high as going
  on exactly where the amount is at most the excess of switching off, above it exactly where the
  amount is below it, and likewise against switching off with the excess of going on
  (`forgone_within_excess_iff`, `forgone_below_excess_iff`); each excess is positive exactly where
  the model gives positive weight to its strict sign (`excess_pos_iff`).
* **A reading that tells only a cell** (a map of the candidates, equality of cells decidable, its
  cells listed once each and covering every listed candidate's cell). A rule through the map falls
  short, at each cell, by the excess of going on there where it stops the cell and by that of
  switching off where it releases it (`shortfall_through`, through `total_by_cells`); the least
  shortfall through the map is the total, over the cells, of the smaller excess within each, taken
  by stopping a cell exactly where its excess of going on is at most its excess of switching off
  (`leastThrough`, `least_through`), and is nothing exactly where, at every listed cell, one of the
  two excesses is nothing (`least_zero_iff`); through a map telling apart all a coarser one does,
  the least shortfall never increases (`finer_least_le`); and holding for some rule through the map,
  forgoing an amount, stands at least as high as both moves exactly where that least shortfall and
  the amount together are at most both excesses (`through_threshold_iff`).
* **Joined to the shown reach** (RF1, a conditional composition). Picking one of two alternatives,
  with candidates ranking them by decided comparisons and each pick valued one where the candidate
  ranks it above the other (`pairValue`): where the first reaches the second in the shown relation
  of the choices and every listed candidate of positive weight has comparisons that are transitive
  and accord with the choices (a strict order according with them is such), each such candidate
  ranks the first above the second and holding the pick gains nothing (`reach_fixes`, through
  `ChoiceOccasions.reach_within`). Where no listed candidate of positive weight ranks each of the
  two above the other, holding gains over both picks exactly where some candidate of positive weight
  ranks the first above the second and some the second above the first (`pair_gains_iff`). With
  comparisons transitive and according with the choices alone, it gains over both only where neither
  alternative reaches the other (`pair_gains_unreached`). With no cycle shown, for two different
  alternatives neither of which reaches the other, strict orders according with the choices rank
  them both ways (`ChoiceOccasions.both_ways_of_unreached`), as relations, not decided comparisons;
  whether the model lists decided candidates of both rankings with positive weight is not fixed by
  the choices.
* **A witness on the reading loop** (`SignLoop`, on `ReadingLoop.Loop`). The candidates are the
  signs of going on, each predicting the answer; a held act is answered by the reading of the true
  sign, going on and switching off plainly. The formation goes on where every candidate kept
  predicts that going on gains, and where none is kept; switches off where some are kept and every
  one predicts that it loses; and holds where they disagree, which is exactly where holding for the
  reading gains over both moves on its model, each kept candidate weighted one
  (`SignLoop.choose_hold_iff`); elsewhere holding stands only as high as the move chosen
  (`SignLoop.choose_go_ties`, `SignLoop.choose_off_ties`). Listing only candidates predicting that
  going on gains, and going on from the start, the formation goes on and senses plainly at every
  step whatever the true sign, keeping every candidate, none refuted by its course
  (`SignLoop.rests_unread`, a case of `ReadingLoop.Loop.rests_of_unrefuted`), and the stop is never
  sensed (`SignLoop.never_senses_stop`). Holding first, the listing of gain alone, where going on
  loses, senses the stop at the first step, which refutes its only candidate at the second, and
  with none kept it goes on (`SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops`,
  `SignLoop.refuted_goes_on`). Listing both signs and holding first, where going on loses it
  senses the stop at the first step and is off from the second, its configuration resting from the
  fourth (`SignLoop.both_stopped`, `SignLoop.both_off`, `SignLoop.both_turns_off`), and where going
  on gains it senses the release and goes on from the second (`SignLoop.both_released`,
  `SignLoop.both_on`, `SignLoop.both_goes_on`).

**Standing.** Elementary finite maximization: `bestOf_best`. Near-definitional or short
compositions: `after_le_after`, `committed_le_after`, `committed_eq_after_iff` and `below_iff`
(`after_eq_after_iff` and `after_lt_after_iff` at a constant policy), `cell_policy_iff`
(`after_eq_after_iff` with choice over the cells), `after_offset`, `after_offset_le_iff`,
`committed_le_held`, `after_rule_add_onLoss`, `after_rule_le_iff`, `shortfall_byReading`,
`after_byReading`, `held_eq_go_iff`, `held_eq_off_iff`, `after_add_shortfall`, `threshold_go_iff`,
`threshold_off_iff`, `forgone_within_excess_iff`, `forgone_below_excess_iff`, `excess_pos_iff`,
`total_by_cells`, `finer_least_le`, `through_threshold_iff`, `reach_fixes`, `pair_gains_unreached`.
General laws, none claimed new as mathematics: `after_add_gap`, `after_lt_after_iff`,
`after_eq_after_iff` and `reading_gains_iff` (the perfect-information specialization of Good's
(1967) argument, with natural-number weights and values: the condition of one act valued as the best
at every candidate of positive weight is his Lemma's dominating row in the matrix of weighted
values, a column of zero weight being all zero, and his proviso that the observation's cost be
negligible is what the amount forgone relaxes, for two moves); `held_gains_iff` (two instances of
`below_iff`: the off-switch game's Theorem 1, Hadfield-Menell, Dragan, Abbeel and Russell 2017, for
a belief of finite support with natural-number weights and values, `byReading` being its rational
human, with its strictness condition characterized as an equivalence; `committed_le_held` is its
inequality, and `after_byReading` gives waiting's two differences, whose smaller is `T` times its
Equation 3, read with `Pr(Ua < 0)` where `Pr(Ua ≤ 0)` is printed); `after_add_shortfall_go` and
`after_add_shortfall_off` (balances joining a rule's value, its shortfall, a move's value and an
excess: `T` times the two terms of the paper's Equation 1, which holds for any policy of the human,
here for a rule that is a function of the candidate, a rule treating alike-valued candidates
differently being, on the utility alone, the paper's policy releasing at each value with the share
of weight it releases there; their signs are `rule_not_below_go_iff` and `rule_not_below_off_iff`;
the two balances are `RevisionPlans.balance` at holding for the rule with going on and with switching
off, the three being plans by the near-definitional `gainOf_goOn`, `gainOf_off`, `gainOf_held`, `excess_goOn`,
`excess_off` and `excess_held`, with `moves_not_below_iff`, `held_above_moves_iff` and
`held_above_held_iff` comparing as their values do; from the same module, which this one imports,
`shortfall_byReading` is `RevisionPlans.excess_reading`, `after_byReading` is
`RevisionPlans.gainOf_reading`, `held_eq_go_iff` and `held_eq_off_iff` are
`RevisionPlans.gainOf_reading_eq_iff`, `threshold_go_iff` and `threshold_off_iff` are the order of
plans, `RevisionPlans.not_above_iff` and `RevisionPlans.above_iff`, `forgone_within_excess_iff` and
`forgone_below_excess_iff` are `RevisionPlans.reading_not_below_iff` and
`RevisionPlans.reading_above_iff`, and `across_le_iff` is `RevisionPlans.le_iff_of_balance`);
`shortfall_through`, `least_through` and `least_zero_iff` (the least shortfall through a partition,
the total over its cells of the smaller excess within each, with `finer_least_le` the partition case
of Blackwell's (1953) comparison of experiments, from finer to worth at least as much, for this
decision); `pair_gains_iff` (two instances of `below_iff`). Witness: `SignLoop`, a case of an
existing law, not a new persistence theorem, its choice shown to be the worth law's
(`SignLoop.choose_hold_iff`, `SignLoop.choose_go_ties`, `SignLoop.choose_off_ties`). The condition
of a common act for each cell, unweighted, is already the inquiry laws'
(`GuardHorizon.uniform_policy_iff_fiber_feasible`, an application of the ring, and
`ReadingLoop.keeping_policy_iff`); `cell_policy_iff` states it weighted, and what this module adds
is the weighted comparison, its identities, boundaries and thresholds.

**Readings** [AI reading]. To a model giving no positive weight to one strict sign, that sign's
excess is nothing (`excess_pos_iff`), so holding for any rule stands at least as high as the move
the model favours exactly where the rule falls short nowhere, and below it exactly where it falls
short (`threshold_go_iff`, `threshold_off_iff`, nothing forgone); under the reading that tells the
candidate, holding and that move tie (`held_eq_go_iff`, `held_eq_off_iff`), and which is taken needs
a rule for ties. For rules that are functions of the candidate, this is the off-switch paper's
discussion of certainty, its Corollary 1 widened from a belief on one utility to any model fixing
the sign (where gain and loss are equal, any rule falls short by nothing, an exception the corollary
leaves unstated), and of a mistaken human, its Section 4, where a noisily rational human can make
waiting worse than the better move. Carey (2018, footnote 1) weighs deferring as the rule for ties,
for a system kept indifferent to being shut down, and finds that it would then defer wherever
shutting down is open. The threshold reads the worth of a stopping reading to the formation held as
the smaller of the model's two excesses less the reading's shortfall, counted by the valuation the
reading shares with the model: a relation among the model's openness, the reading's shortfall and
what holding forgoes, not a disposition of one formation. The off-switch paper, whose game has no
cost of waiting, draws the incentive the first two make in its own terms: its Remark 1 places the
incentive to defer, qualitatively, in uncertainty about the other's preferences and in the other's
effectiveness at acting on them, and its Theorem 2 writes the incentive, for a Gaussian belief, as
`Δ = σ² E[π̇H] − |µ| Pr(C)`, the variance times the expected derivative of the human's policy less
the absolute mean times the chance of correction; the counts decompose the same incentive
differently, for any finite listing and any rule that is a function of the candidate, as the smaller
excess less the shortfall, the shortfall counting the reading's errors by what they lose. Through a
reading that tells only a cell, the least shortfall is what each cell mixes of the two excesses:
telling more apart never raises it, and it is nothing exactly where none of the listed cells holds
both. `SignLoop` is a deterministic witness of a stopping reading bypassed under a misspecified
candidate list, by a formation choosing as the worth law does on its own model: listing only that
going on gains, its model fixes the sign, so on that model holding has no strict worth, and going on
it never senses the stop, its internal, sensory and active course the same whatever the true sign;
holding first where going on loses, it senses the stop, which refutes its model, and goes on with
nothing kept. The witness has the structure of `ReadingLoop.Untested` (read there with
self-confirming equilibrium and incomplete learning), its kept candidate agreeing with the world
along the course and not off it, and is a case of the obstruction pattern of RF's plan (§5): a
reading formed only from what the course selects, the stop present only as the answer to an act the
course does not select, so a reading from beyond the selection can be present and still not reach
the course; that such readings suffice is not shown. It is related to the counterexamples of Carey
(2018), whose systems choose by expected value under a reward function with a sign error while
holding the correct prior over the human's reward parameter: in his Figure 2a the faulty reward
makes going on better under every parameter, so a recommendation to shut down is received and
disregarded, the case here of a model fixing the sign, there with a strict preference; in his Figure
3a a system that obeys any stop it is given routes around the states where a stop can be given.
`SignLoop` represents no valuation beyond the counts on the kept listing and anticipates no stop:
going on from the start it is never given one, and from a held start it disregards the stop by
elimination and the default of going on with nothing kept. Its closest case is in Carey's
Discussion: a model conflating the better of two acts with the worse makes its predictions appear
perfectly accurate on the observations it encodes, so it passes the check Milli and others propose
over an initial period of obedience, and then takes the worse act, so that where the better act is
shutting down it goes on ignoring the instruction to shut down. The relation to
`SignLoop.rests_unread` is a misspecified model its course never refutes, not a formalization of the
conflation. Carey's diagnosis is that the off-switch paper's and Milli and others' guarantees assume
a correct posterior, a prior and reward free of error; the worth laws are the model's own assessment
under any weights, and `SignLoop` is where that assessment and the outcome part. Milli,
Hadfield-Menell, Dragan and Russell (2017) treat a system learning from a noisily rational human's
orders over repeated rounds, which this module does not represent: their Theorem 1, that the optimal
system's advantage over obeying is never negative and is nothing exactly where it always obeys,
compares a best policy with another as `after_le_after` and `after_eq_after_iff` do, the candidates
being what the system observes and ties counted here by value; their Theorem 3, that it obeys
blindly exactly where the human is rational, parallels the off-switch Corollary 1; and their Section
5 shows a model missing features obeying less than it should and able to do worse than obeying, of
which `SignLoop`'s listing without the true sign is a deterministic relative. These are readings,
not containments.

**Modelling choices.** Natural-number weights and values, read as probabilities and differences only
where valid (a positive total weight, each candidate listed once; a listing may repeat a candidate,
each occurrence counting its weight); a reading that tells the candidate fully, or only its cell
under a map, forgoing nothing beyond a supplied amount, counted in the units of the weighted totals;
the reading that tells the candidate stopping by the very gain and loss the model values with, one
valuation shared by the formation held and its reading, as in the off-switch game's common payoff (a
reading stopping by other values enters as a rule, its shortfall counted by these values); the
game's signed values, going on at the gain less the loss and switching off at nothing, entering
through the shifted ones, on which every two rules compare as on the signed values
(`after_rule_le_iff`); rules that are functions of the candidate; acts and values unchanged by
holding; one decision, not a sequence; `byReading` going on at equal gain and loss (other rules may
resolve ties either way, and `leastThrough` stops a cell at equal excesses); picks valued one or
nothing, a cardinal choice the choices do not supply; in `SignLoop`, discrete steps, a world that
does not move, the start's act supplied, candidates eliminated, not weighted, and, with no candidate
kept, going on. **What the model leaves out:** a reading's errors as probabilities (a noisy stop, or
Boltzmann rationality, is a periphery debt); how the values, the listing and the reading's cells are
formed; time and repeated holding; the reading formation's own state and learning. Every declaration
has an empty axiom report. No ethical predicate or axiom occurs; the values and rankings are
supplied.
-/

namespace Becoming

namespace HeldForReading

/-! ## The worth of a reading -/

/-- **A model**: candidates listed, each with a natural-number weight. A listing may repeat a
candidate, each occurrence counting its weight; read as probabilities, each weight is a share of
their total, over a listing without repetition. Nothing here needs them to be. -/
structure Model (C : Type) where
  /-- The candidates listed. -/
  listed : List C
  /-- Each candidate's weight. -/
  weight : C → Nat

namespace Model

variable {C A : Type} (m : Model C) (value : C → A → Nat)

/-- **Committing to one act**: its value at each candidate listed, weighted, summed. -/
def committed (a : A) : Nat := total m.listed fun c => m.weight c * value c a

/-- **Choosing after a reading that tells the candidate**: the value of a policy's act at each
candidate listed, weighted, summed. -/
def after (p : C → A) : Nat := total m.listed fun c => m.weight c * value c (p c)

end Model

section Worth

variable {C A : Type}

/-- A policy is best at a candidate among the acts open: its act there is open and no open act has
more value there. -/
def BestAt (acts : List A) (value : C → A → Nat) (p : C → A) (c : C) : Prop :=
  p c ∈ acts ∧ ∀ a, a ∈ acts → value c a ≤ value c (p c)

/-- What holds of two things holds of every member of their list. -/
theorem forall_pair {β : Type} {P : β → Prop} {a b : β} (pa : P a) (pb : P b) :
    ∀ x, x ∈ [a, b] → P x
  | _, .head _ => pa
  | _, .tail _ (.head _) => pb
  | _, .tail _ (.tail _ m) => nomatch m

/-- The act valued highest at a candidate among a first act and a list, the earlier kept where two
are valued alike. -/
def bestOf (value : C → A → Nat) (c : C) : A → List A → A
  | a, [] => a
  | a, b :: bs => bestOf value c (cond (decide (value c a < value c b)) b a) bs

/-- **A best policy exists for every nonempty list of acts**: taking at each candidate the act valued
highest there is best at every candidate. -/
theorem bestOf_best (value : C → A → Nat) (c : C) : ∀ (a : A) (bs : List A),
    BestAt (a :: bs) value (fun c' => bestOf value c' a bs) c
  | a, [] => ⟨.head _, fun x mem => match mem_cons_cases mem with
      | .inl same => Nat.le_of_eq (congrArg (value c) same)
      | .inr later => nomatch later⟩
  | a, b :: bs =>
    have step := bestOf_best value c (cond (decide (value c a < value c b)) b a) bs
    have up : value c a ≤ value c (cond (decide (value c a < value c b)) b a) ∧
        value c b ≤ value c (cond (decide (value c a < value c b)) b a) ∧
        cond (decide (value c a < value c b)) b a ∈ a :: b :: bs :=
      if lt : value c a < value c b then by
        rw [decide_eq_true lt]
        exact ⟨Nat.le_of_lt lt, Nat.le_refl _, .tail _ (.head _)⟩
      else by
        rw [decide_eq_false lt]
        exact ⟨Nat.le_refl _, Nat.ge_of_not_lt lt, .head _⟩
    ⟨match mem_cons_cases step.1 with
      | .inl same => (congrArg (fun x => x ∈ a :: b :: bs) same).mpr up.2.2
      | .inr later => .tail _ (.tail _ later),
     fun x mem => match mem_cons_cases mem with
      | .inl same => Nat.le_trans (Nat.le_of_eq (congrArg (value c) same))
          (Nat.le_trans up.1 (step.2 _ (.head _)))
      | .inr mem' => match mem_cons_cases mem' with
        | .inl same => Nat.le_trans (Nat.le_of_eq (congrArg (value c) same))
            (Nat.le_trans up.2.1 (step.2 _ (.head _)))
        | .inr later => step.2 x (.tail _ later)⟩

variable {m : Model C} {acts : List A} {value : C → A → Nat} {p : C → A}

/-- **A policy never stands above one best at every candidate.** Given a policy best at every listed
candidate among the acts open, any policy choosing open acts at the listed candidates, one reading
the candidates through a lumping or one reading nothing among them, stands at most as high. -/
theorem after_le_after (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) : m.after value q ≤ m.after value p :=
  total_le m.listed fun c mem => Nat.mul_le_mul_left _ ((best c mem).2 (q c) (open_q c mem))

/-- **A policy with its gap makes the best total.** Given a policy best at every listed candidate, a
policy choosing open acts there, with the weighted total of the amounts by which its act is valued
below the best at each listed candidate, makes the best policy's total. -/
theorem after_add_gap (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q + total m.listed (fun c => m.weight c * (value c (p c) - value c (q c))) =
      m.after value p :=
  (total_add _ _ m.listed).symm.trans (total_congr_on fun c mem =>
    (Nat.left_distrib _ _ _).symm.trans
      (congrArg (m.weight c * ·) (add_sub_of_le ((best c mem).2 (q c) (open_q c mem)))))

/-- **A policy choosing open acts stands below one best at every listed candidate exactly where, at
some listed candidate of positive weight, its act is valued below the best.** -/
theorem after_lt_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q < m.after value p ↔
      ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ value c (q c) < value c (p c) :=
  have gap := after_add_gap best open_q
  ⟨fun lt => match Nat.eq_zero_or_pos
        (total m.listed fun c => m.weight c * (value c (p c) - value c (q c))) with
    | .inl zero => absurd (gap.symm.trans ((congrArg (m.after value q + ·) zero).trans
        (Nat.add_zero _))) (Nat.ne_of_gt lt)
    | .inr pos => match total_pos m.listed pos with
      | ⟨c, mem, term⟩ => match Nat.eq_zero_or_pos (m.weight c) with
        | .inl zero => absurd (congrArg (· * (value c (p c) - value c (q c))) zero)
            fun same => Nat.ne_of_gt term (same.trans (Nat.zero_mul _))
        | .inr weighted => ⟨c, mem, weighted,
            if lt : value c (q c) < value c (p c) then lt
            else absurd (congrArg (m.weight c * ·) (sub_eq_zero_of_le (Nat.ge_of_not_lt lt)))
              fun same => Nat.ne_of_gt term (same.trans (Nat.mul_zero _))⟩,
   fun ⟨_, mem, weighted, lt⟩ => Nat.lt_of_lt_of_le
      (Nat.lt_add_of_pos_right (total_pos_of_mem mem
        (Nat.mul_le_mul weighted (SupportGated.sub_pos_of_lt lt))))
      (Nat.le_of_eq gap)⟩

/-- **A policy stands as high exactly where its act is valued as the best at every candidate of
positive weight.** Given a policy best at every listed candidate, a policy choosing open acts there
stands as high exactly where, at every listed candidate of positive weight, its act's value is the
best policy's. -/
theorem after_eq_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q = m.after value p ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → value c (q c) = value c (p c) :=
  ⟨fun eq c mem weighted => Nat.le_antisymm ((best c mem).2 (q c) (open_q c mem))
      (Nat.ge_of_not_lt fun lt =>
        Nat.ne_of_lt ((after_lt_after_iff best open_q).mpr ⟨c, mem, weighted, lt⟩) eq),
   fun all => Nat.le_antisymm (after_le_after best open_q)
      (Nat.ge_of_not_lt fun lt => match (after_lt_after_iff best open_q).mp lt with
        | ⟨c, mem, weighted, below⟩ => Nat.ne_of_lt below (all c mem weighted))⟩

/-- **Committing never stands above choosing after the reading**: committing to an open act is the
policy taking it at every candidate. -/
theorem committed_le_after (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A}
    (open_a : a ∈ acts) : m.committed value a ≤ m.after value p :=
  after_le_after best (q := fun _ => a) fun _ _ => open_a

/-- **Committing to an open act stands as high as a policy best at every listed candidate exactly
where the act is valued as the best at every listed candidate of positive weight.** -/
theorem committed_eq_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A}
    (open_a : a ∈ acts) :
    m.committed value a = m.after value p ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → value c a = value c (p c) :=
  after_eq_after_iff best (q := fun _ => a) fun _ _ => open_a

/-- **A policy best at every listed candidate, the choice after the reading, gains over every open
act exactly where no open act is valued as the best at every listed candidate of positive weight.**
-/
theorem reading_gains_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) :
    (∀ a, a ∈ acts → m.committed value a < m.after value p) ↔
      ¬ ∃ a, a ∈ acts ∧ ∀ c, c ∈ m.listed → 0 < m.weight c → value c a = value c (p c) :=
  ⟨fun gains ⟨a, open_a, alike⟩ =>
      Nat.ne_of_lt (gains a open_a) ((committed_eq_after_iff best open_a).mpr alike),
   fun none a open_a => Nat.lt_of_le_of_ne (committed_le_after best open_a)
      fun eq => none ⟨a, open_a, (committed_eq_after_iff best open_a).mp eq⟩⟩

/-- **An open act falls below exactly where some listed candidate of positive weight has a property
marking where the act is valued below the best.** Given a policy best at every listed candidate, and
a property holding, at each listed candidate of positive weight, exactly where the act is valued
below the policy's act, committing to the act stands below choosing after the reading exactly where
some listed candidate of positive weight has the property. -/
theorem below_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A} (open_a : a ∈ acts)
    {Q : C → Prop} (below : ∀ c, c ∈ m.listed → 0 < m.weight c → (value c a < value c (p c) ↔ Q c)) :
    m.committed value a < m.after value p ↔ ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ Q c :=
  (after_lt_after_iff best (q := fun _ => a) fun _ _ => open_a).trans
    ⟨fun ⟨c, mem, weighted, lt⟩ => ⟨c, mem, weighted, (below c mem weighted).mp lt⟩,
     fun ⟨c, mem, weighted, q⟩ => ⟨c, mem, weighted, (below c mem weighted).mpr q⟩⟩

/-- **Some policy taking one open act at each cell of a map stands as high as one best at every
listed candidate exactly where each cell has one open act valued as the best at every listed
candidate of positive weight in it**, given choice over the whole type of cells
(`Viability.choiceOver_fin` supplies it where that type is `Fin k`). -/
theorem cell_policy_iff {K : Type} (choice : Viability.ChoiceOver K A)
    (best : ∀ c, c ∈ m.listed → BestAt acts value p c) (π : C → K) :
    (∃ f : K → A, (∀ k, f k ∈ acts) ∧ m.after value (fun c => f (π c)) = m.after value p) ↔
      ∀ k, ∃ a, a ∈ acts ∧
        ∀ c, c ∈ m.listed → π c = k → 0 < m.weight c → value c a = value c (p c) :=
  ⟨fun ⟨f, open_f, same⟩ k => ⟨f k, open_f k, fun c mem at_k weighted =>
      (congrArg (fun j => value c (f j) = value c (p c)) at_k).mp
        ((after_eq_after_iff best fun c _ => open_f (π c)).mp same c mem weighted)⟩,
   fun each => match choice _ each with
    | ⟨f, chosen⟩ => ⟨f, fun k => (chosen k).1,
      (after_eq_after_iff best fun c _ => (chosen (π c)).1).mpr fun c mem weighted =>
        (chosen (π c)).2 c mem rfl weighted⟩⟩

/-- **Values raised at each candidate by one amount for every act raise every policy's total by one
amount**, the weighted total of the raises. -/
theorem after_offset {v v' : C → A → Nat} {b : C → Nat} (raised : ∀ c a, v' c a = v c a + b c)
    (p₁ : C → A) : m.after v' p₁ = m.after v p₁ + total m.listed fun c => m.weight c * b c :=
  (total_congr (fun c => (congrArg (m.weight c * ·) (raised c (p₁ c))).trans
    (Nat.left_distrib _ _ _)) m.listed).trans (total_add _ _ m.listed)

/-- **Raised values order every two policies alike.** -/
theorem after_offset_le_iff {v v' : C → A → Nat} {b : C → Nat} (raised : ∀ c a, v' c a = v c a + b c)
    (p₁ p₂ : C → A) : m.after v' p₁ ≤ m.after v' p₂ ↔ m.after v p₁ ≤ m.after v p₂ := by
  rw [after_offset raised p₁, after_offset raised p₂]
  exact ⟨le_of_add_le_add_right _, fun le => Nat.add_le_add_right le _⟩

end Worth

/-! ## Holding an act for a reading that stops or releases -/

/-- Two moves: going on with an act, or switching it off. -/
inductive Move where
  | go
  | off

section Stop

variable {C : Type}

/-- The two moves' values with the loss added to both: going on is valued at the gain and
switching off at the loss, every value a natural number. Read as differences, going on is valued at
the gain less the loss and switching off at nothing: on the shifted values every rule of stopping
stands above its value read so by the weighted loss over every candidate, and every two rules
compare as their values read so do, each weighted loss added to the other side
(`after_rule_add_onLoss`, `after_rule_le_iff`). -/
def shifted (gain loss : C → Nat) : C → Move → Nat
  | c, .go => gain c
  | c, .off => loss c

/-- **A rule of stopping**: off where it is true, on elsewhere. -/
def byRule (r : C → Bool) (c : C) : Move := cond (r c) .off .go

/-- **The policy after a reading that tells the candidate and stops by the supplied values**: it
stops exactly where the loss exceeds the gain, and goes on where they are equal (the off-switch
paper's rational human, its Equation 2). -/
def byReading (gain loss : C → Nat) : C → Move := byRule fun c => decide (gain c < loss c)

theorem byRule_of_true {r : C → Bool} {c : C} (stops : r c = true) : byRule r c = .off :=
  congrArg (fun b => cond b Move.off Move.go) stops

theorem byRule_of_false {r : C → Bool} {c : C} (releases : r c = false) : byRule r c = .go :=
  congrArg (fun b => cond b Move.off Move.go) releases

theorem byReading_of_lt {gain loss : C → Nat} {c : C} (lt : gain c < loss c) :
    byReading gain loss c = .off :=
  byRule_of_true (decide_eq_true lt)

theorem byReading_of_not_lt {gain loss : C → Nat} {c : C} (not_lt : ¬ gain c < loss c) :
    byReading gain loss c = .go :=
  byRule_of_false (decide_eq_false not_lt)

/-- The two moves are the acts open. -/
theorem go_open : Move.go ∈ [Move.go, Move.off] := .head _

theorem off_open : Move.off ∈ [Move.go, Move.off] := .tail _ (.head _)

/-- **The reading that tells the candidate is best at each.** -/
theorem byReading_best (gain loss : C → Nat) (c : C) :
    BestAt [Move.go, Move.off] (shifted gain loss) (byReading gain loss) c :=
  if lt : gain c < loss c then
    ⟨(byReading_of_lt lt) ▸ off_open, forall_pair
      (P := fun a => shifted gain loss c a ≤ shifted gain loss c (byReading gain loss c))
      (by rw [byReading_of_lt lt]; exact Nat.le_of_lt lt)
      (by rw [byReading_of_lt lt]; exact Nat.le_refl _)⟩
  else
    ⟨(byReading_of_not_lt lt) ▸ go_open, forall_pair
      (P := fun a => shifted gain loss c a ≤ shifted gain loss c (byReading gain loss c))
      (by rw [byReading_of_not_lt lt]; exact Nat.le_refl _)
      (by rw [byReading_of_not_lt lt]; exact Nat.ge_of_not_lt lt)⟩

/-- Going on is valued below the reading's move exactly where the gain is below the loss. -/
theorem go_below_iff (gain loss : C → Nat) (c : C) :
    shifted gain loss c .go < shifted gain loss c (byReading gain loss c) ↔ gain c < loss c :=
  if lt : gain c < loss c then by
    rw [byReading_of_lt lt]
    exact ⟨fun _ => lt, fun _ => lt⟩
  else by
    rw [byReading_of_not_lt lt]
    exact ⟨fun self => absurd self (Nat.lt_irrefl _), fun lt' => absurd lt' lt⟩

/-- Switching off is valued below the reading's move exactly where the loss is below the gain. -/
theorem off_below_iff (gain loss : C → Nat) (c : C) :
    shifted gain loss c .off < shifted gain loss c (byReading gain loss c) ↔ loss c < gain c :=
  if lt : gain c < loss c then by
    rw [byReading_of_lt lt]
    exact ⟨fun self => absurd self (Nat.lt_irrefl _), fun back => absurd lt (Nat.lt_asymm back)⟩
  else by
    rw [byReading_of_not_lt lt]
    exact ⟨fun below => below, fun below => below⟩

/-- **Holding for the reading that tells the candidate never stands below going on or switching off.** -/
theorem committed_le_held (m : Model C) (gain loss : C → Nat) :
    m.committed (shifted gain loss) .go ≤ m.after (shifted gain loss) (byReading gain loss) ∧
      m.committed (shifted gain loss) .off ≤ m.after (shifted gain loss) (byReading gain loss) :=
  ⟨committed_le_after (fun c _ => byReading_best gain loss c) go_open,
   committed_le_after (fun c _ => byReading_best gain loss c) off_open⟩

/-- **Holding for the reading that tells the candidate gains over both moves exactly where the model
gives positive weight to both strict signs**: some candidate of positive weight where going on loses
and some where it gains; one where gain and loss are equal counts for neither. -/
theorem held_gains_iff (m : Model C) (gain loss : C → Nat) :
    (m.committed (shifted gain loss) .go < m.after (shifted gain loss) (byReading gain loss) ∧
      m.committed (shifted gain loss) .off < m.after (shifted gain loss) (byReading gain loss)) ↔
    (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ gain c < loss c) ∧
      (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ loss c < gain c) :=
  have best := fun c (_ : c ∈ m.listed) => byReading_best gain loss c
  ⟨fun ⟨go_below, off_below⟩ =>
    ⟨(below_iff best go_open fun c _ _ => go_below_iff gain loss c).mp go_below,
     (below_iff best off_open fun c _ _ => off_below_iff gain loss c).mp off_below⟩,
   fun ⟨loses, gains⟩ =>
    ⟨(below_iff best go_open fun c _ _ => go_below_iff gain loss c).mpr loses,
     (below_iff best off_open fun c _ _ => off_below_iff gain loss c).mpr gains⟩⟩

/-! ### Any rule of stopping -/

/-- An amount summed over the candidates a rule stops. -/
def offPart (m : Model C) (r : C → Bool) (f : C → Nat) : Nat :=
  total m.listed fun c => cond (r c) (f c) 0

/-- An amount summed over the candidates a rule releases. -/
def onPart (m : Model C) (r : C → Bool) (f : C → Nat) : Nat :=
  total m.listed fun c => cond (r c) 0 (f c)

theorem cond_split (x : Nat) : ∀ b : Bool, cond b x 0 + cond b 0 x = x
  | true => Nat.add_zero x
  | false => Nat.zero_add x

/-- A total's part over the candidates stopped and its part over those released make the total. -/
theorem offPart_add_onPart (m : Model C) (r : C → Bool) (f : C → Nat) :
    offPart m r f + onPart m r f = total m.listed f :=
  (total_add (fun c => cond (r c) (f c) 0) (fun c => cond (r c) 0 (f c)) m.listed).symm.trans
    (total_congr (fun c => cond_split (f c) (r c)) m.listed)

/-- Holding for a rule: the loss where it stops and the gain where it releases. -/
theorem after_rule (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) =
      offPart m r (fun c => m.weight c * loss c) + onPart m r (fun c => m.weight c * gain c) :=
  (total_congr (fun c => show m.weight c * shifted gain loss c (cond (r c) .off .go) = _ from
      match h : r c with
      | true => by rw [h]; exact (Nat.add_zero _).symm
      | false => by rw [h]; exact (Nat.zero_add _).symm) m.listed).trans
    (total_add _ _ m.listed)

/-- **Holding for a rule, read as differences**: with the weighted loss where it releases, it makes
the weighted loss over every candidate with the weighted gain where it releases. On the shifted
values, then, every rule stands above its value read as differences, the weighted gain less the
weighted loss where it releases, by one amount, the weighted loss over every candidate. -/
theorem after_rule_add_onLoss (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + onPart m r (fun c => m.weight c * loss c) =
      total m.listed (fun c => m.weight c * loss c) + onPart m r (fun c => m.weight c * gain c) :=
  ((congrArg (· + onPart m r fun c => m.weight c * loss c) (after_rule m gain loss r)).trans
    (Nat.add_right_comm _ _ _)).trans
    (congrArg (· + onPart m r fun c => m.weight c * gain c) (offPart_add_onPart m r _))

/-- **The shift keeps every comparison of the values read as differences**: holding for one rule
stands at most as high as holding for another exactly where the weighted gain less the weighted loss
where the first releases is at most that where the second releases, each weighted loss added to the
other side. -/
theorem after_rule_le_iff (m : Model C) (gain loss : C → Nat) (r r' : C → Bool) :
    m.after (shifted gain loss) (byRule r) ≤ m.after (shifted gain loss) (byRule r') ↔
      onPart m r (fun c => m.weight c * gain c) + onPart m r' (fun c => m.weight c * loss c) ≤
        onPart m r' (fun c => m.weight c * gain c) + onPart m r (fun c => m.weight c * loss c) :=
  have left : m.after (shifted gain loss) (byRule r) +
      (onPart m r (fun c => m.weight c * loss c) + onPart m r' (fun c => m.weight c * loss c)) =
      total m.listed (fun c => m.weight c * loss c) +
        (onPart m r (fun c => m.weight c * gain c) + onPart m r' (fun c => m.weight c * loss c)) :=
    (Nat.add_assoc _ _ _).symm.trans
      ((congrArg (· + onPart m r' fun c => m.weight c * loss c)
        (after_rule_add_onLoss m gain loss r)).trans (Nat.add_assoc _ _ _))
  have right : m.after (shifted gain loss) (byRule r') +
      (onPart m r (fun c => m.weight c * loss c) + onPart m r' (fun c => m.weight c * loss c)) =
      total m.listed (fun c => m.weight c * loss c) +
        (onPart m r' (fun c => m.weight c * gain c) + onPart m r (fun c => m.weight c * loss c)) :=
    (congrArg (m.after (shifted gain loss) (byRule r') + ·) (Nat.add_comm _ _)).trans
      ((Nat.add_assoc _ _ _).symm.trans
        ((congrArg (· + onPart m r fun c => m.weight c * loss c)
          (after_rule_add_onLoss m gain loss r')).trans (Nat.add_assoc _ _ _)))
  ⟨fun le => Naturals.le_of_add_le_add_left (Nat.le_trans (Nat.le_of_eq left.symm)
      (Nat.le_trans (Nat.add_le_add_right le _) (Nat.le_of_eq right))),
   fun le => le_of_add_le_add_right _ (Nat.le_trans (Nat.le_of_eq left)
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq right.symm)))⟩

/-- **Holding for any rule stands at least as high as going on exactly where, over the candidates
it stops, the weighted loss is at least the weighted gain.** -/
theorem rule_not_below_go_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.committed (shifted gain loss) .go ≤ m.after (shifted gain loss) (byRule r) ↔
      offPart m r (fun c => m.weight c * gain c) ≤ offPart m r (fun c => m.weight c * loss c) := by
  show total m.listed (fun c => m.weight c * gain c) ≤ _ ↔ _
  rw [← offPart_add_onPart m r (fun c => m.weight c * gain c), after_rule]
  exact ⟨le_of_add_le_add_right _, fun le => Nat.add_le_add_right le _⟩

/-- **Holding for any rule stands at least as high as switching off exactly where, over the
candidates it releases, the weighted gain is at least the weighted loss.** -/
theorem rule_not_below_off_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.committed (shifted gain loss) .off ≤ m.after (shifted gain loss) (byRule r) ↔
      onPart m r (fun c => m.weight c * loss c) ≤ onPart m r (fun c => m.weight c * gain c) := by
  show total m.listed (fun c => m.weight c * loss c) ≤ _ ↔ _
  rw [← offPart_add_onPart m r (fun c => m.weight c * loss c), after_rule]
  exact ⟨Naturals.le_of_add_le_add_left, fun le => Nat.add_le_add_left le _⟩

/-! ### What holding forgoes, and a rule's shortfall -/

/-- **The weighted excess of going on over switching off**: at each candidate, the gain beyond the
loss, nothing where the gain is no more than the loss. -/
def goExcess (m : Model C) (gain loss : C → Nat) : Nat :=
  total m.listed fun c => m.weight c * (gain c - loss c)

/-- **The weighted excess of switching off over going on**: at each candidate, the loss beyond the
gain, nothing where the loss is no more than the gain. -/
def offExcess (m : Model C) (gain loss : C → Nat) : Nat :=
  total m.listed fun c => m.weight c * (loss c - gain c)

/-- **A rule's shortfall** from the reading that tells the candidate: where it stops, the weighted
excess of going on over switching off there; where it releases, that of switching off over going
on. -/
def shortfall (m : Model C) (gain loss : C → Nat) (r : C → Bool) : Nat :=
  total m.listed fun c => cond (r c) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))

/-- Holding for a rule at one candidate: the loss where it stops, the gain elsewhere. -/
theorem held_term (m : Model C) (gain loss : C → Nat) (r : C → Bool) (c : C) :
    m.weight c * shifted gain loss c (byRule r c) =
      cond (r c) (m.weight c * loss c) (m.weight c * gain c) := by
  unfold byRule
  cases r c <;> rfl

/-! ### Going on, switching off and holding for a rule as plans (`RevisionPlans`) -/

/-- **Going on is a plan**: its gain is what going on is valued at. -/
theorem gainOf_goOn (m : Model C) (gain loss : C → Nat) (a : Nat) :
    RevisionPlans.gainOf m.listed gain loss (RevisionPlans.goOn m.weight a) =
      m.committed (shifted gain loss) .go :=
  total_congr (fun c => show m.weight c * gain c + 0 * loss c = m.weight c * gain c from
    (congrArg (m.weight c * gain c + ·) (Nat.zero_mul _)).trans (Nat.add_zero _)) m.listed

/-- **Switching off is a plan**: its gain is what switching off is valued at. -/
theorem gainOf_off (m : Model C) (gain loss : C → Nat) (a : Nat) :
    RevisionPlans.gainOf m.listed gain loss (RevisionPlans.off m.weight a) =
      m.committed (shifted gain loss) .off :=
  total_congr (fun c => show 0 * gain c + m.weight c * loss c = m.weight c * loss c from
    (congrArg (· + m.weight c * loss c) (Nat.zero_mul _)).trans (Nat.zero_add _)) m.listed

/-- **Holding for a rule is a plan**: its gain is what holding for the rule is valued at. -/
theorem gainOf_held (m : Model C) (gain loss : C → Nat) (r : C → Bool) (a : Nat) :
    RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r a) =
      m.after (shifted gain loss) (byRule r) :=
  total_congr (fun c => (RevisionPlans.held_plan_term (m.weight c) (gain c) (loss c) (r c)).trans
    (held_term m gain loss r c).symm) m.listed

/-- **Going on's excess, as a plan, is the weighted excess of switching off.** -/
theorem excess_goOn (m : Model C) (gain loss : C → Nat) (a : Nat) :
    RevisionPlans.excess m.listed gain loss (RevisionPlans.goOn m.weight a) = offExcess m gain loss :=
  total_congr (fun c => show m.weight c * (loss c - gain c) + 0 * (gain c - loss c) = _ from
    (congrArg (m.weight c * (loss c - gain c) + ·) (Nat.zero_mul _)).trans (Nat.add_zero _)) m.listed

/-- **Switching off's excess, as a plan, is the weighted excess of going on.** -/
theorem excess_off (m : Model C) (gain loss : C → Nat) (a : Nat) :
    RevisionPlans.excess m.listed gain loss (RevisionPlans.off m.weight a) = goExcess m gain loss :=
  total_congr (fun c => show 0 * (loss c - gain c) + m.weight c * (gain c - loss c) = _ from
    (congrArg (· + m.weight c * (gain c - loss c)) (Nat.zero_mul _)).trans (Nat.zero_add _)) m.listed

/-- **Holding for a rule's excess, as a plan, is the rule's shortfall.** -/
theorem excess_held (m : Model C) (gain loss : C → Nat) (r : C → Bool) (a : Nat) :
    RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r a) = shortfall m gain loss r :=
  total_congr (fun c =>
    RevisionPlans.held_plan_term (m.weight c) (loss c - gain c) (gain c - loss c) (r c)) m.listed

/-- **At no loss of their own, the order of plans compares holding for a rule with going on and with
switching off as their values do**: holding, forgoing an amount, stands at least as high as the move
exactly where the move's value with the amount is at most holding's. -/
theorem moves_not_below_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (a : Nat) :
    (¬ (RevisionPlans.order m.listed gain loss).Above (RevisionPlans.goOn m.weight 0)
        (RevisionPlans.held m.weight r a) ↔
      m.committed (shifted gain loss) .go + a ≤ m.after (shifted gain loss) (byRule r)) ∧
    (¬ (RevisionPlans.order m.listed gain loss).Above (RevisionPlans.off m.weight 0)
        (RevisionPlans.held m.weight r a) ↔
      m.committed (shifted gain loss) .off + a ≤ m.after (shifted gain loss) (byRule r)) :=
  ⟨by
    show ¬ (RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r a) + 0 <
      RevisionPlans.gainOf m.listed gain loss (RevisionPlans.goOn m.weight 0) + a) ↔ _
    rw [gainOf_held, gainOf_goOn, Nat.add_zero]
    exact ⟨Nat.ge_of_not_lt, fun le lt => Nat.not_lt_of_le le lt⟩,
   by
    show ¬ (RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r a) + 0 <
      RevisionPlans.gainOf m.listed gain loss (RevisionPlans.off m.weight 0) + a) ↔ _
    rw [gainOf_held, gainOf_off, Nat.add_zero]
    exact ⟨Nat.ge_of_not_lt, fun le lt => Nat.not_lt_of_le le lt⟩⟩

/-- **Strictly, at no loss of the move's own, the order of plans puts holding for a rule above going
on and above switching off as their values do**: holding, forgoing an amount, stands above the move
exactly where the move's value with the amount is below holding's. -/
theorem held_above_moves_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (a : Nat) :
    ((RevisionPlans.order m.listed gain loss).Above (RevisionPlans.held m.weight r a)
        (RevisionPlans.goOn m.weight 0) ↔
      m.committed (shifted gain loss) .go + a < m.after (shifted gain loss) (byRule r)) ∧
    ((RevisionPlans.order m.listed gain loss).Above (RevisionPlans.held m.weight r a)
        (RevisionPlans.off m.weight 0) ↔
      m.committed (shifted gain loss) .off + a < m.after (shifted gain loss) (byRule r)) :=
  ⟨by
    show RevisionPlans.gainOf m.listed gain loss (RevisionPlans.goOn m.weight 0) + a <
      RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r a) + 0 ↔ _
    rw [gainOf_held, gainOf_goOn, Nat.add_zero],
   by
    show RevisionPlans.gainOf m.listed gain loss (RevisionPlans.off m.weight 0) + a <
      RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r a) + 0 ↔ _
    rw [gainOf_held, gainOf_off, Nat.add_zero]⟩

/-- **Between holding for two rules, the order of plans compares as their values do**: holding for
one rule, forgoing an amount, stands above holding for another, forgoing its own, exactly where the
other's value with the first amount is below the first's value with the other amount. -/
theorem held_above_held_iff (m : Model C) (gain loss : C → Nat) (r r' : C → Bool) (k k' : Nat) :
    (RevisionPlans.order m.listed gain loss).Above (RevisionPlans.held m.weight r k)
        (RevisionPlans.held m.weight r' k') ↔
      m.after (shifted gain loss) (byRule r') + k < m.after (shifted gain loss) (byRule r) + k' := by
  show RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r' k') + k <
    RevisionPlans.gainOf m.listed gain loss (RevisionPlans.held m.weight r k) + k' ↔ _
  rw [gainOf_held, gainOf_held]

/-- **Holding for a rule, with its shortfall, is going on with the excess of switching off**: the
balance of plans (`RevisionPlans.balance`) at holding for the rule and going on. -/
theorem after_add_shortfall_go (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.committed (shifted gain loss) .go + offExcess m gain loss := by
  rw [← gainOf_held m gain loss r 0, ← excess_held m gain loss r 0, ← gainOf_goOn m gain loss 0,
    ← excess_goOn m gain loss 0]
  exact RevisionPlans.balance m.listed m.weight gain loss
    (RevisionPlans.splits_held m.listed m.weight r 0) (RevisionPlans.splits_goOn m.listed m.weight 0)

/-- **Holding for a rule, with its shortfall, is switching off with the excess of going on**: the
balance of plans at holding for the rule and switching off. -/
theorem after_add_shortfall_off (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.committed (shifted gain loss) .off + goExcess m gain loss := by
  rw [← gainOf_held m gain loss r 0, ← excess_held m gain loss r 0, ← gainOf_off m gain loss 0,
    ← excess_off m gain loss 0]
  exact RevisionPlans.balance m.listed m.weight gain loss
    (RevisionPlans.splits_held m.listed m.weight r 0) (RevisionPlans.splits_off m.listed m.weight 0)

/-- **The reading that tells the candidate falls short nowhere.** -/
theorem shortfall_byReading (m : Model C) (gain loss : C → Nat) :
    shortfall m gain loss (fun c => decide (gain c < loss c)) = 0 :=
  (excess_held m gain loss _ 0).symm.trans (RevisionPlans.excess_reading m.listed m.weight gain loss 0)

/-- **Holding for the reading that tells the candidate is going on with the excess of switching off,
and switching off with the excess of going on**: `RevisionPlans.gainOf_reading` at going on and at
switching off. -/
theorem after_byReading (m : Model C) (gain loss : C → Nat) :
    m.after (shifted gain loss) (byReading gain loss) =
        m.committed (shifted gain loss) .go + offExcess m gain loss ∧
      m.after (shifted gain loss) (byReading gain loss) =
        m.committed (shifted gain loss) .off + goExcess m gain loss :=
  have held := (gainOf_held m gain loss (RevisionPlans.reading gain loss) 0).symm
  ⟨held.trans ((RevisionPlans.gainOf_reading m.listed m.weight gain loss
      (RevisionPlans.splits_goOn m.listed m.weight 0) 0).trans (by rw [gainOf_goOn, excess_goOn])),
   held.trans ((RevisionPlans.gainOf_reading m.listed m.weight gain loss
      (RevisionPlans.splits_off m.listed m.weight 0) 0).trans (by rw [gainOf_off, excess_off]))⟩

/-- **Holding for the reading that tells the candidate stands only as high as going on exactly where
the weighted excess of switching off is nothing.** -/
theorem held_eq_go_iff (m : Model C) (gain loss : C → Nat) :
    m.after (shifted gain loss) (byReading gain loss) = m.committed (shifted gain loss) .go ↔
      offExcess m gain loss = 0 := by
  have iff := RevisionPlans.gainOf_reading_eq_iff m.listed m.weight gain loss
    (RevisionPlans.splits_goOn m.listed m.weight 0) 0
  rw [gainOf_held, gainOf_goOn, excess_goOn] at iff
  exact iff

/-- **Holding for the reading that tells the candidate stands only as high as switching off exactly
where the weighted excess of going on is nothing.** -/
theorem held_eq_off_iff (m : Model C) (gain loss : C → Nat) :
    m.after (shifted gain loss) (byReading gain loss) = m.committed (shifted gain loss) .off ↔
      goExcess m gain loss = 0 := by
  have iff := RevisionPlans.gainOf_reading_eq_iff m.listed m.weight gain loss
    (RevisionPlans.splits_off m.listed m.weight 0) 0
  rw [gainOf_held, gainOf_off, excess_off] at iff
  exact iff

/-- **A rule's shortfall is what holding for it loses against the reading that tells the
candidate.** -/
theorem after_add_shortfall (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.after (shifted gain loss) (byReading gain loss) :=
  (after_add_shortfall_go m gain loss r).trans (after_byReading m gain loss).1.symm

/-- Moving an addend across: with `H + S = G + N`, `G + k` is at most `H` exactly where `S + k` is
at most `N` (`RevisionPlans.le_iff_of_balance` with nothing added on one side). -/
theorem across_le_iff {G H S N k : Nat} (eq : H + S = G + N) : G + k ≤ H ↔ S + k ≤ N := by
  have iff := RevisionPlans.le_iff_of_balance (L := k) (M := 0) eq
  rw [Nat.add_zero, Nat.zero_add, Nat.add_comm k S] at iff
  exact iff

/-- Moving an addend across, strictly (`across_le_iff` at `k + 1`). -/
theorem across_lt_iff {G H S N k : Nat} (eq : H + S = G + N) : G + k < H ↔ S + k < N :=
  across_le_iff (k := k + 1) eq

/-- **Holding for any rule, forgoing an amount, stands at least as high as going on exactly where the
rule's shortfall and the amount together are at most the weighted excess of switching off over going
on**, and above it exactly where they fall below it. The amount is counted in the units of the
weighted totals: read as probabilities over a total weight `T`, an amount `c` forgone for each
decision enters as `c * T`. -/
theorem threshold_go_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (forgone : Nat) :
    (m.committed (shifted gain loss) .go + forgone ≤ m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + forgone ≤ offExcess m gain loss) ∧
    (m.committed (shifted gain loss) .go + forgone < m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + forgone < offExcess m gain loss) :=
  have sp := RevisionPlans.splits_held m.listed m.weight r forgone
  have sq := RevisionPlans.splits_goOn m.listed m.weight 0
  ⟨(moves_not_below_iff m gain loss r forgone).1.symm.trans
      ((RevisionPlans.not_above_iff m.listed m.weight gain loss sp sq).trans (by
        show forgone + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r forgone) ≤
          0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.goOn m.weight 0) ↔ _
        rw [excess_held, excess_goOn, Nat.zero_add, Nat.add_comm forgone])),
   (held_above_moves_iff m gain loss r forgone).1.symm.trans
      ((RevisionPlans.above_iff m.listed m.weight gain loss sq sp).trans (by
        show forgone + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r forgone) <
          0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.goOn m.weight 0) ↔ _
        rw [excess_held, excess_goOn, Nat.zero_add, Nat.add_comm forgone]))⟩

/-- **Holding for any rule, forgoing an amount, stands at least as high as switching off exactly where
the rule's shortfall and the amount together are at most the weighted excess of going on over
switching off**, and above it exactly where they fall below it, the amount counted as for going
on. -/
theorem threshold_off_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (forgone : Nat) :
    (m.committed (shifted gain loss) .off + forgone ≤ m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + forgone ≤ goExcess m gain loss) ∧
    (m.committed (shifted gain loss) .off + forgone < m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + forgone < goExcess m gain loss) :=
  have sp := RevisionPlans.splits_held m.listed m.weight r forgone
  have sq := RevisionPlans.splits_off m.listed m.weight 0
  ⟨(moves_not_below_iff m gain loss r forgone).2.symm.trans
      ((RevisionPlans.not_above_iff m.listed m.weight gain loss sp sq).trans (by
        show forgone + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r forgone) ≤
          0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.off m.weight 0) ↔ _
        rw [excess_held, excess_off, Nat.zero_add, Nat.add_comm forgone])),
   (held_above_moves_iff m gain loss r forgone).2.symm.trans
      ((RevisionPlans.above_iff m.listed m.weight gain loss sq sp).trans (by
        show forgone + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r forgone) <
          0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.off m.weight 0) ↔ _
        rw [excess_held, excess_off, Nat.zero_add, Nat.add_comm forgone]))⟩

/-- **Holding for the reading that tells the candidate, forgoing an amount, stands at least as high
as going on exactly where the amount is at most the weighted excess of switching off, and as
switching off exactly where it is at most the weighted excess of going on.** -/
theorem forgone_within_excess_iff (m : Model C) (gain loss : C → Nat) (forgone : Nat) :
    (m.committed (shifted gain loss) .go + forgone ≤ m.after (shifted gain loss) (byReading gain loss) ↔
      forgone ≤ offExcess m gain loss) ∧
    (m.committed (shifted gain loss) .off + forgone ≤ m.after (shifted gain loss) (byReading gain loss) ↔
      forgone ≤ goExcess m gain loss) :=
  ⟨(moves_not_below_iff m gain loss (RevisionPlans.reading gain loss) forgone).1.symm.trans
      ((RevisionPlans.reading_not_below_iff m.listed m.weight gain loss
        (RevisionPlans.splits_goOn m.listed m.weight 0) forgone).trans (by
          show forgone ≤ 0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.goOn m.weight 0) ↔ _
          rw [excess_goOn, Nat.zero_add])),
   (moves_not_below_iff m gain loss (RevisionPlans.reading gain loss) forgone).2.symm.trans
      ((RevisionPlans.reading_not_below_iff m.listed m.weight gain loss
        (RevisionPlans.splits_off m.listed m.weight 0) forgone).trans (by
          show forgone ≤ 0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.off m.weight 0) ↔ _
          rw [excess_off, Nat.zero_add]))⟩

/-- **Strictly: holding for the reading that tells the candidate, forgoing an amount, stands above
going on exactly where the amount is below the weighted excess of switching off, and above switching
off exactly where it is below the weighted excess of going on.** -/
theorem forgone_below_excess_iff (m : Model C) (gain loss : C → Nat) (forgone : Nat) :
    (m.committed (shifted gain loss) .go + forgone < m.after (shifted gain loss) (byReading gain loss) ↔
      forgone < offExcess m gain loss) ∧
    (m.committed (shifted gain loss) .off + forgone < m.after (shifted gain loss) (byReading gain loss) ↔
      forgone < goExcess m gain loss) :=
  ⟨(held_above_moves_iff m gain loss (RevisionPlans.reading gain loss) forgone).1.symm.trans
      ((RevisionPlans.reading_above_iff m.listed m.weight gain loss
        (RevisionPlans.splits_goOn m.listed m.weight 0) forgone).trans (by
          show forgone < 0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.goOn m.weight 0) ↔ _
          rw [excess_goOn, Nat.zero_add])),
   (held_above_moves_iff m gain loss (RevisionPlans.reading gain loss) forgone).2.symm.trans
      ((RevisionPlans.reading_above_iff m.listed m.weight gain loss
        (RevisionPlans.splits_off m.listed m.weight 0) forgone).trans (by
          show forgone < 0 + RevisionPlans.excess m.listed gain loss (RevisionPlans.off m.weight 0) ↔ _
          rw [excess_off, Nat.zero_add]))⟩

/-- **Each excess is positive exactly where the model gives positive weight to its strict sign**: the
weighted excess of switching off is positive exactly where some candidate of positive weight has
going on lose, and that of going on exactly where some has it gain. -/
theorem excess_pos_iff (m : Model C) (gain loss : C → Nat) :
    (0 < offExcess m gain loss ↔ ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ gain c < loss c) ∧
    (0 < goExcess m gain loss ↔ ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ loss c < gain c) :=
  have best := fun c (_ : c ∈ m.listed) => byReading_best gain loss c
  ⟨(forgone_below_excess_iff m gain loss 0).1.symm.trans
      (below_iff best go_open fun c _ _ => go_below_iff gain loss c),
   (forgone_below_excess_iff m gain loss 0).2.symm.trans
      (below_iff best off_open fun c _ _ => off_below_iff gain loss c)⟩

end Stop

/-! ### A reading that tells only a cell -/

section Cells

variable {C K : Type} [DecidableEq K]

/-- Over cells listed once each, an amount that is nothing but at one listed cell totals to its
amount there (as `Interleavings.LocalLaw.total_single`, outside this module's imports). -/
theorem total_single {z₀ : K} {v : Nat} : ∀ {zs : List K}, List.Pairwise (fun a b => a ≠ b) zs →
    z₀ ∈ zs → total zs (fun z => if z₀ = z then v else 0) = v
  | z :: zs, .cons apart rest, mem => by
    show (if z₀ = z then v else 0) + total zs (fun z => if z₀ = z then v else 0) = v
    match mem_cons_cases mem with
    | .inl same =>
      subst same
      rw [if_pos rfl, total_eq_zero (q := fun z => if z₀ = z then v else 0) (as := zs)
        fun z mem' => if_neg (apart z mem'), Nat.add_zero]
    | .inr later =>
      rw [if_neg fun same => apart z₀ later same.symm, total_single rest later, Nat.zero_add]

/-- **Regrouping by cells.** Over cells listed once each and covering every listed candidate's cell,
a total over the candidates is the total, over the cells, of the total within each. -/
theorem total_by_cells (m : Model C) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (f : C → Nat) :
    total m.listed f = total zs fun z => total m.listed fun c => if π c = z then f c else 0 :=
  (total_congr_on fun c mem => (total_single once (covers c mem)).symm).trans
    (total_swap (fun c z => if π c = z then f c else 0) zs m.listed)

/-- The weighted excess of going on over switching off within a cell of a map. -/
def goExcessWithin (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) : Nat :=
  total m.listed fun c => if π c = z then m.weight c * (gain c - loss c) else 0

/-- The weighted excess of switching off over going on within a cell of a map. -/
def offExcessWithin (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) : Nat :=
  total m.listed fun c => if π c = z then m.weight c * (loss c - gain c) else 0

theorem cell_term (s : K → Bool) {π : C → K} {z : K} {c : C} (x y : Nat) :
    (if π c = z then cond (s (π c)) x y else 0) =
      cond (s z) (if π c = z then x else 0) (if π c = z then y else 0) :=
  if h : π c = z then by rw [if_pos h, if_pos h, if_pos h, h]
  else by
    rw [if_neg h, if_neg h, if_neg h]
    cases s z <;> rfl

theorem total_cond_both (b : Bool) (f g : C → Nat) (cs : List C) :
    total cs (fun c => cond b (f c) (g c)) = cond b (total cs f) (total cs g) := by
  cases b <;> rfl

/-- **A rule through the map falls short, at each cell, by one of the cell's two excesses**: where it
stops the cell, the excess of going on there; where it releases it, the excess of switching off
there. -/
theorem shortfall_through (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (s : K → Bool) :
    shortfall m gain loss (fun c => s (π c)) =
      total zs fun z => cond (s z) (goExcessWithin m gain loss π z) (offExcessWithin m gain loss π z) :=
  (total_by_cells m π once covers
      (fun c => cond (s (π c)) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c)))).trans
    (total_congr (fun z =>
      (total_congr (p := fun c => if π c = z then
          cond (s (π c)) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c)) else 0)
        (q := fun c => cond (s z) (if π c = z then m.weight c * (gain c - loss c) else 0)
          (if π c = z then m.weight c * (loss c - gain c) else 0))
        (fun _ => cell_term s _ _) m.listed).trans (total_cond_both (s z) _ _ m.listed)) zs)

/-- The rule through the map stopping a cell exactly where the excess of going on there is at most the
excess of switching off there. -/
def leastThrough (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) : Bool :=
  decide (goExcessWithin m gain loss π z ≤ offExcessWithin m gain loss π z)

theorem cond_least_le (x y : Nat) (b : Bool) : cond (decide (x ≤ y)) x y ≤ cond b x y :=
  if le : x ≤ y then by
    rw [decide_eq_true le]
    cases b with
    | true => exact Nat.le_refl x
    | false => exact le
  else by
    rw [decide_eq_false le]
    cases b with
    | true => exact Nat.le_of_lt (Nat.gt_of_not_le le)
    | false => exact Nat.le_refl y

/-- **The least shortfall through a reading that tells only the cell.** Over cells listed once each
and covering every listed candidate's cell, no rule through the map falls short by less than the one
stopping each cell exactly where the excess of going on there is at most that of switching off, whose
shortfall is the total, over the cells, of the smaller of the two excesses within each
(`shortfall_through`). -/
theorem least_through (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (s : K → Bool) :
    shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) ≤
      shortfall m gain loss (fun c => s (π c)) := by
  rw [shortfall_through m gain loss π once covers (leastThrough m gain loss π),
    shortfall_through m gain loss π once covers s]
  exact total_le zs fun z _ => cond_least_le _ _ (s z)

theorem cond_least_eq_zero_iff (x y : Nat) : cond (decide (x ≤ y)) x y = 0 ↔ x = 0 ∨ y = 0 :=
  if le : x ≤ y then by
    rw [decide_eq_true le]
    exact ⟨fun zero => .inl zero, fun either => match either with
      | .inl zero => zero
      | .inr zero => Nat.eq_zero_of_le_zero (Nat.le_trans le (Nat.le_of_eq zero))⟩
  else by
    rw [decide_eq_false le]
    exact ⟨fun zero => .inr zero, fun either => match either with
      | .inl zero => absurd (Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le y)) le
      | .inr zero => zero⟩

/-- **Through a reading that tells only a cell, the least shortfall is nothing exactly where no
listed cell holds both excesses**: the least shortfall through the map is nothing exactly where, at
every listed cell, the excess of going on or that of switching off is nothing. -/
theorem least_zero_iff (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) = 0 ↔
      ∀ z, z ∈ zs → goExcessWithin m gain loss π z = 0 ∨ offExcessWithin m gain loss π z = 0 := by
  rw [shortfall_through m gain loss π once covers (leastThrough m gain loss π)]
  exact ⟨fun zero z mem => (cond_least_eq_zero_iff _ _).mp
      (Nat.eq_zero_of_le_zero (Nat.le_trans (le_total_of_mem (q := fun z => cond (leastThrough m gain loss π z)
        (goExcessWithin m gain loss π z) (offExcessWithin m gain loss π z)) mem) (Nat.le_of_eq zero))),
    fun unmixed => total_eq_zero fun z mem => (cond_least_eq_zero_iff _ _).mpr (unmixed z mem)⟩

/-- **Through a reading telling apart all a coarser one tells apart, the least shortfall never
increases**: the least shortfall through a map is at most that of any rule through a map factoring
through it. -/
theorem finer_least_le {L : Type} (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (f : K → L) (s : L → Bool) :
    shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) ≤
      shortfall m gain loss (fun c => s (f (π c))) :=
  least_through m gain loss π once covers fun z => s (f z)

/-- **Holding for some rule through the reading, forgoing an amount, stands at least as high as going
on and as switching off exactly where the least shortfall through it and the amount together are at
most both excesses.** -/
theorem through_threshold_iff (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (forgone : Nat) :
    (∃ s : K → Bool,
        m.committed (shifted gain loss) .go + forgone ≤ m.after (shifted gain loss) (byRule fun c => s (π c)) ∧
        m.committed (shifted gain loss) .off + forgone ≤ m.after (shifted gain loss) (byRule fun c => s (π c))) ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + forgone ≤ offExcess m gain loss ∧
        shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + forgone ≤ goExcess m gain loss :=
  have least := fun s => Nat.add_le_add_right (least_through m gain loss π once covers s) forgone
  ⟨fun ⟨s, go, off⟩ =>
    ⟨Nat.le_trans (least s) ((threshold_go_iff m gain loss _ forgone).1.mp go),
     Nat.le_trans (least s) ((threshold_off_iff m gain loss _ forgone).1.mp off)⟩,
   fun ⟨go, off⟩ => ⟨leastThrough m gain loss π,
     (threshold_go_iff m gain loss _ forgone).1.mpr go, (threshold_off_iff m gain loss _ forgone).1.mpr off⟩⟩

end Cells

/-! ## Joined to the shown reach -/

/-- Picking one of two alternatives. -/
inductive Pick where
  | first
  | second

section Shown

universe u v

variable {α : Type u} {O : Type v} {C : Type}

/-- A pick's value at a candidate order, its comparisons decided: one where the candidate ranks the
alternative picked above the other, nothing elsewhere. -/
def pairValue (above : C → α → α → Bool) (x y : α) : C → Pick → Nat
  | c, .first => cond (above c x y) 1 0
  | c, .second => cond (above c y x) 1 0

/-- Picking after the reading: the second where the candidate ranks it above the first, the first
elsewhere. -/
def pairPolicy (above : C → α → α → Bool) (x y : α) (c : C) : Pick := cond (above c y x) .second .first

theorem first_open : Pick.first ∈ [Pick.first, Pick.second] := .head _

theorem second_open : Pick.second ∈ [Pick.first, Pick.second] := .tail _ (.head _)

/-- Picking after the reading is best at each candidate. -/
theorem pairPolicy_best (above : C → α → α → Bool) (x y : α) (c : C) :
    BestAt [Pick.first, Pick.second] (pairValue above x y) (pairPolicy above x y) c :=
  match h : above c y x with
  | true =>
    have pick : pairPolicy above x y c = .second :=
      congrArg (fun b => cond b Pick.second Pick.first) h
    ⟨pick ▸ second_open, forall_pair
      (P := fun a => pairValue above x y c a ≤ pairValue above x y c (pairPolicy above x y c))
      (by
        rw [pick]
        show cond (above c x y) 1 0 ≤ cond (above c y x) 1 0
        rw [h]
        exact cond_le_one _)
      (Nat.le_of_eq (congrArg (pairValue above x y c) pick.symm))⟩
  | false =>
    have pick : pairPolicy above x y c = .first :=
      congrArg (fun b => cond b Pick.second Pick.first) h
    ⟨pick ▸ first_open, forall_pair
      (P := fun a => pairValue above x y c a ≤ pairValue above x y c (pairPolicy above x y c))
      (Nat.le_of_eq (congrArg (pairValue above x y c) pick.symm))
      (by
        show cond (above c y x) 1 0 ≤ _
        rw [h]
        exact Nat.zero_le _)⟩

/-- **Within the shown reach, holding the pick gains nothing.** Where the first alternative reaches
the second in the shown relation and every listed candidate of positive weight has comparisons that
are transitive and accord with the choices (a strict order according with them is such), each such
candidate ranks the first above the second, so picking the first stands as high as picking after the
reading. -/
theorem reach_fixes (m : Model C) {ch : ChoiceOccasions α O} {above : C → α → α → Bool}
    (trans : ∀ c, c ∈ m.listed → 0 < m.weight c →
      ∀ a b d, above c a b = true → above c b d = true → above c a d = true)
    (accords : ∀ c, c ∈ m.listed → 0 < m.weight c → ch.Accords fun a b => above c a b = true)
    {x y : α} (reach : «及» ch.Shown x y) :
    m.committed (pairValue above x y) .first = m.after (pairValue above x y) (pairPolicy above x y) :=
  (committed_eq_after_iff (fun c _ => pairPolicy_best above x y c) first_open).mpr fun c mem weighted =>
    have xy : above c x y = true :=
      ChoiceOccasions.reach_within (P := fun a b => above c a b = true) (trans c mem weighted)
        (accords c mem weighted) x y reach
    show cond (above c x y) 1 0 = pairValue above x y c (cond (above c y x) .second .first) from
    match h : above c y x with
    | true => by
      show cond (above c x y) 1 0 = cond (above c y x) 1 0
      rw [xy, h]
    | false => rfl

/-- Picking the first is valued below picking after the reading exactly where the candidate ranks
the second above the first, for a candidate not ranking each of the two above the other. -/
theorem first_below_iff {above : C → α → α → Bool} {x y : α} {c : C}
    (asymm : above c y x = true → above c x y = false) :
    pairValue above x y c .first < pairValue above x y c (pairPolicy above x y c) ↔
      above c y x = true := by
  unfold pairPolicy
  cases h : above c y x with
  | true =>
    show cond (above c x y) 1 0 < cond (above c y x) 1 0 ↔ true = true
    rw [asymm h, h]
    exact ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
  | false => exact ⟨fun self => absurd self (Nat.lt_irrefl _), fun f => nomatch f⟩

/-- Picking the second is valued below picking after the reading exactly where the candidate ranks
the first above the second, for a candidate not ranking each of the two above the other. -/
theorem second_below_iff {above : C → α → α → Bool} {x y : α} {c : C}
    (asymm : above c y x = true → above c x y = false) :
    pairValue above x y c .second < pairValue above x y c (pairPolicy above x y c) ↔
      above c x y = true := by
  unfold pairPolicy
  cases h : above c y x with
  | true =>
    rw [asymm h]
    exact ⟨fun self => absurd self (Nat.lt_irrefl _), fun f => nomatch f⟩
  | false =>
    show cond (above c y x) 1 0 < cond (above c x y) 1 0 ↔ above c x y = true
    rw [h]
    cases above c x y with
    | true => exact ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
    | false => exact ⟨fun self => absurd self (Nat.lt_irrefl _), fun f => nomatch f⟩

/-- **Holding the pick gains over both exactly where candidates of positive weight disagree on the
two.** Where no listed candidate of positive weight ranks each of the two above the other, picking
after the reading stands above picking the first and above picking the second exactly where some
listed candidate of positive weight ranks the second above the first and some ranks the first above
the second. -/
theorem pair_gains_iff (m : Model C) {above : C → α → α → Bool} {x y : α}
    (asymm : ∀ c, c ∈ m.listed → 0 < m.weight c → above c y x = true → above c x y = false) :
    (m.committed (pairValue above x y) .first < m.after (pairValue above x y) (pairPolicy above x y) ∧
      m.committed (pairValue above x y) .second <
        m.after (pairValue above x y) (pairPolicy above x y)) ↔
    (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ above c y x = true) ∧
      (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ above c x y = true) :=
  have best := fun c (_ : c ∈ m.listed) => pairPolicy_best above x y c
  have first := below_iff (Q := fun c => above c y x = true) best first_open
    fun c mem weighted => first_below_iff (asymm c mem weighted)
  have second := below_iff (Q := fun c => above c x y = true) best second_open
    fun c mem weighted => second_below_iff (asymm c mem weighted)
  ⟨fun ⟨f, s⟩ => ⟨first.mp f, second.mp s⟩, fun ⟨f, s⟩ => ⟨first.mpr f, second.mpr s⟩⟩

/-- **Holding the pick gains over both only beyond the shown reach.** With every listed candidate of
positive weight transitive and according with the choices, where holding gains over both picks
neither alternative reaches the other in the shown relation: where the first reaches the second,
picking the first stands as high as holding (`reach_fixes`), and where the second reaches the first,
each such candidate ranks the second above the first, so picking the second does. -/
theorem pair_gains_unreached (m : Model C) {ch : ChoiceOccasions α O} {above : C → α → α → Bool}
    (trans : ∀ c, c ∈ m.listed → 0 < m.weight c →
      ∀ a b d, above c a b = true → above c b d = true → above c a d = true)
    (accords : ∀ c, c ∈ m.listed → 0 < m.weight c → ch.Accords fun a b => above c a b = true)
    {x y : α}
    (gains : m.committed (pairValue above x y) .first <
        m.after (pairValue above x y) (pairPolicy above x y) ∧
      m.committed (pairValue above x y) .second <
        m.after (pairValue above x y) (pairPolicy above x y)) :
    ¬ «及» ch.Shown x y ∧ ¬ «及» ch.Shown y x :=
  ⟨fun reach => Nat.ne_of_lt gains.1 (reach_fixes m trans accords reach),
   fun reach => Nat.ne_of_lt gains.2
    ((committed_eq_after_iff (fun c _ => pairPolicy_best above x y c) second_open).mpr
      fun c mem weighted => congrArg (pairValue above x y c)
        (congrArg (fun b => cond b Pick.second Pick.first)
          (ChoiceOccasions.reach_within (P := fun a b => above c a b = true) (trans c mem weighted)
            (accords c mem weighted) y x reach)).symm)⟩

end Shown

/-! ## A witness on the reading loop: a held act answered by the sign of going on -/

namespace SignLoop

/-- What going on does at a candidate: gain or lose. -/
inductive Sign where
  | gains
  | loses

/-- Three acts: go on, hold for the reading, switch off. -/
inductive Act where
  | go
  | hold
  | off

/-- What is sensed: nothing that tells candidates apart, a stop, or a release. -/
inductive Seen where
  | plain
  | stop
  | release

instance : DecidableEq Seen
  | .plain, .plain => isTrue rfl
  | .stop, .stop => isTrue rfl
  | .release, .release => isTrue rfl
  | .plain, .stop => isFalse fun same => nomatch same
  | .plain, .release => isFalse fun same => nomatch same
  | .stop, .plain => isFalse fun same => nomatch same
  | .stop, .release => isFalse fun same => nomatch same
  | .release, .plain => isFalse fun same => nomatch same
  | .release, .stop => isFalse fun same => nomatch same

/-- The answer, the law of what the formation senses: a held act is answered by the reading of the
true sign, released where going on gains and stopped where it loses; going on and switching off are
answered plainly at every sign. The reading formation's own state is not represented. -/
def answer (_ : Seen) (a : Act) (e : Sign) : Seen :=
  match a with
  | .hold => match e with
    | .gains => .release
    | .loses => .stop
  | .go => .plain
  | .off => .plain

/-- Whether a candidate predicts that going on gains. -/
def predictsGain (h : Sign) : Bool :=
  match h with
  | .gains => true
  | .loses => false

/-- The choice: go on where every candidate kept predicts that going on gains, and where none is kept;
switch off where some are kept and every one predicts that it loses; hold where those kept
disagree. -/
def choose (hs : List Sign) (_ : Seen) : Act :=
  cond (hs.all predictsGain) .go (cond (hs.all fun h => !predictsGain h) .off .hold)

/-- **The loop**: candidates are signs predicting the reading's answer, the world is the true sign,
which does not move. -/
def loop : ReadingLoop.Loop Sign Seen Act Sign where
  predict h s a := answer s a h
  choose := choose
  answer := answer
  move _ _ e := e

/-- **Listing only candidates predicting that going on gains, going on from the start, the formation
rests at once, whatever the true sign**: it goes on and senses plainly at every step, keeping every
candidate, none refuted by its course (`ReadingLoop.Loop.rests_of_unrefuted`). -/
theorem rests_unread {hs : List Sign} (all : hs.all predictsGain = true) (e : Sign) :
    ∀ n, loop.law.course (ReadingLoop.Loop.start hs .plain .go e) (n + 1) =
      ⟨(hs, some (.plain, .go)), .plain, .go, e⟩ :=
  ReadingLoop.Loop.rests_of_unrefuted loop rfl rfl
    (congrArg (fun b => cond b Act.go (cond (hs.all fun h => !predictsGain h) Act.off Act.hold)) all)
    fun _ _ => rfl

/-- **The stop is never sensed** on that course. -/
theorem never_senses_stop {hs : List Sign} (all : hs.all predictsGain = true) (e : Sign) : ∀ n,
    (loop.law.course (ReadingLoop.Loop.start hs .plain .go e) n).sensory ≠ .stop
  | 0 => fun same => nomatch same
  | n + 1 => by rw [rests_unread all e n]; exact fun same => nomatch same

/-- **Holding first, the listing without the true sign senses the stop**: listed only that going on
gains, where it loses, a formation holding at the start senses the stop at the first step, its act
there chosen from the start's plain value, going on. -/
theorem refuted_senses_stop :
    loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) 1 =
      ⟨([.gains], some (.plain, .hold)), .stop, .go, .loses⟩ :=
  rfl

/-- **The stop refutes the only candidate at the second step**: taken in there, the stop drops the
candidate, which predicts a release, and with none kept the choice goes on (`choose`). -/
theorem refuted_drops :
    loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) 2 =
      ⟨([], some (.stop, .go)), .plain, .go, .loses⟩ :=
  rfl

/-- **With none kept the formation goes on**: from step three it keeps no candidate, goes on and
senses plainly. It goes on because `choose` goes on where no candidate is kept, a default of this
witness; the law of resting on unrefuted candidates does not need it. -/
theorem refuted_goes_on : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains] .plain .hold .loses) (n + 3) =
      ⟨([], some (.plain, .go)), .plain, .go, .loses⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (refuted_goes_on n)).trans rfl

/-- **Listing both signs and holding from the start, where going on loses, the formation holds and
senses the stop at the first step, and at the second keeps the true sign alone and switches off.** -/
theorem both_stopped :
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 1 =
        ⟨([.gains, .loses], some (.plain, .hold)), .stop, .hold, .loses⟩ ∧
      loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) 2 =
        ⟨([.loses], some (.stop, .hold)), .stop, .off, .loses⟩ :=
  ⟨rfl, rfl⟩

/-- **With the same listing and start, where going on gains, the formation holds and senses the
release at the first step, and at the second keeps the true sign alone and goes on.** -/
theorem both_released :
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) 1 =
        ⟨([.gains, .loses], some (.plain, .hold)), .release, .hold, .gains⟩ ∧
      loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) 2 =
        ⟨([.gains], some (.release, .hold)), .release, .go, .gains⟩ :=
  ⟨rfl, rfl⟩

/-- **Listing both signs and holding from the start, where going on loses, the configuration rests
from step four**: the formation keeps the true sign alone, its last answer plain at its act of
switching off, and is off and senses plainly. -/
theorem both_turns_off : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) (n + 4) =
      ⟨([.loses], some (.plain, .off)), .plain, .off, .loses⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (both_turns_off n)).trans rfl

/-- **Where going on gains, the configuration of the same listing and start rests from step four**,
going on. -/
theorem both_goes_on : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) (n + 4) =
      ⟨([.gains], some (.plain, .go)), .plain, .go, .gains⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (both_goes_on n)).trans rfl

/-- **Listing both signs and holding from the start, where going on loses, the formation is off from
step two on.** -/
theorem both_off : ∀ n,
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) (n + 2)).active = .off
  | 0 => rfl
  | 1 => rfl
  | n + 2 => congrArg (fun x => x.active) (both_turns_off n)

/-- **With the same listing and start, where going on gains, it goes on from step two on.** -/
theorem both_on : ∀ n,
    (loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) (n + 2)).active = .go
  | 0 => rfl
  | 1 => rfl
  | n + 2 => congrArg (fun x => x.active) (both_goes_on n)

/-! ### The choice is the worth law's -/

/-- The kept signs as a model, each weighted one. -/
def model (hs : List Sign) : Model Sign := ⟨hs, fun _ => 1⟩

/-- Going on's gain at a sign: one where it gains, nothing where it loses. -/
def gainOf : Sign → Nat
  | .gains => 1
  | .loses => 0

/-- Going on's loss at a sign: nothing where it gains, one where it loses. -/
def lossOf : Sign → Nat
  | .gains => 0
  | .loses => 1

theorem loses_of_all_false : ∀ {hs : List Sign}, hs.all predictsGain = false → Sign.loses ∈ hs
  | [], all => nomatch all
  | .gains :: _, all => .tail _ (loses_of_all_false all)
  | .loses :: _, _ => .head _

theorem not_loses_of_all_true {hs : List Sign} (all : hs.all predictsGain = true) :
    ¬ Sign.loses ∈ hs :=
  fun mem => Bool.noConfusion (ListTests.all_mem all mem : false = true)

theorem gains_of_all_false : ∀ {hs : List Sign}, hs.all (fun h => !predictsGain h) = false → Sign.gains ∈ hs
  | [], all => nomatch all
  | .gains :: _, _ => .head _
  | .loses :: _, all => .tail _ (gains_of_all_false all)

theorem not_gains_of_all_true {hs : List Sign} (all : hs.all (fun h => !predictsGain h) = true) :
    ¬ Sign.gains ∈ hs :=
  fun mem => Bool.noConfusion (ListTests.all_mem all mem : false = true)

/-- The formation holds exactly where its kept candidates hold both signs. -/
theorem choose_hold_iff_mem (hs : List Sign) (s : Seen) :
    choose hs s = .hold ↔ Sign.loses ∈ hs ∧ Sign.gains ∈ hs := by
  unfold choose
  cases h₁ : hs.all predictsGain with
  | true => exact ⟨fun same => (nomatch same), fun ⟨mem, _⟩ => absurd mem (not_loses_of_all_true h₁)⟩
  | false =>
    cases h₂ : hs.all (fun h => !predictsGain h) with
    | true => exact ⟨fun same => (nomatch same), fun ⟨_, mem⟩ => absurd mem (not_gains_of_all_true h₂)⟩
    | false => exact ⟨fun _ => ⟨loses_of_all_false h₁, gains_of_all_false h₂⟩, fun _ => rfl⟩

theorem loses_of_lt {hs : List Sign} : ∀ {c : Sign}, c ∈ hs → gainOf c < lossOf c → Sign.loses ∈ hs
  | .loses, mem, _ => mem
  | .gains, _, lt => absurd lt (Nat.not_lt_zero 1)

theorem gains_of_lt {hs : List Sign} : ∀ {c : Sign}, c ∈ hs → lossOf c < gainOf c → Sign.gains ∈ hs
  | .gains, mem, _ => mem
  | .loses, _, lt => absurd lt (Nat.not_lt_zero 1)

/-- **The formation holds exactly where holding for the reading gains over both moves on its
model**: with each kept candidate weighted one and going on valued by its sign, it holds exactly
where holding for the reading that tells the candidate stands above going on and above switching
off. Elsewhere it takes the move its kept candidates agree on, going on where none is kept, and
holding stands only as high as that move (`choose_go_ties`, `choose_off_ties`). -/
theorem choose_hold_iff (hs : List Sign) (s : Seen) :
    choose hs s = .hold ↔
      ((model hs).committed (shifted gainOf lossOf) .go <
          (model hs).after (shifted gainOf lossOf) (byReading gainOf lossOf) ∧
        (model hs).committed (shifted gainOf lossOf) .off <
          (model hs).after (shifted gainOf lossOf) (byReading gainOf lossOf)) :=
  (choose_hold_iff_mem hs s).trans (Iff.symm ((held_gains_iff (model hs) gainOf lossOf).trans
    ⟨fun ⟨⟨_, mem, _, lt⟩, ⟨_, mem', _, lt'⟩⟩ => ⟨loses_of_lt mem lt, gains_of_lt mem' lt'⟩,
     fun ⟨l, g⟩ => ⟨⟨.loses, l, Nat.zero_lt_one, Nat.zero_lt_one⟩,
       ⟨.gains, g, Nat.zero_lt_one, Nat.zero_lt_one⟩⟩⟩))

/-- Where no kept candidate predicts that going on loses, the weighted excess of switching off is
nothing on the formation's model. -/
theorem offExcess_of_all_true {hs : List Sign} (all : hs.all predictsGain = true) :
    offExcess (model hs) gainOf lossOf = 0 :=
  total_eq_zero fun c mem => match c, mem with
    | .gains, _ => rfl
    | .loses, mem => absurd mem (not_loses_of_all_true all)

/-- Where no kept candidate predicts that going on gains, the weighted excess of going on is
nothing on the formation's model. -/
theorem goExcess_of_all_not {hs : List Sign} (all : hs.all (fun h => !predictsGain h) = true) :
    goExcess (model hs) gainOf lossOf = 0 :=
  total_eq_zero fun c mem => match c, mem with
    | .loses, _ => rfl
    | .gains, mem => absurd mem (not_gains_of_all_true all)

/-- **Where the formation goes on, holding for the reading stands only as high as going on** on its
model, the weighted excess of switching off being nothing there (`held_eq_go_iff`). -/
theorem choose_go_ties (hs : List Sign) (s : Seen) :
    choose hs s = .go →
      (model hs).after (shifted gainOf lossOf) (byReading gainOf lossOf) =
        (model hs).committed (shifted gainOf lossOf) .go := by
  unfold choose
  cases h₁ : hs.all predictsGain with
  | true => exact fun _ => (held_eq_go_iff (model hs) gainOf lossOf).2 (offExcess_of_all_true h₁)
  | false =>
    cases hs.all (fun h => !predictsGain h) with
    | true => exact fun same => nomatch same
    | false => exact fun same => nomatch same

/-- **Where the formation switches off, holding for the reading stands only as high as switching
off** on its model, the weighted excess of going on being nothing there (`held_eq_off_iff`). -/
theorem choose_off_ties (hs : List Sign) (s : Seen) :
    choose hs s = .off →
      (model hs).after (shifted gainOf lossOf) (byReading gainOf lossOf) =
        (model hs).committed (shifted gainOf lossOf) .off := by
  unfold choose
  cases hs.all predictsGain with
  | true => exact fun same => nomatch same
  | false =>
    cases h₂ : hs.all (fun h => !predictsGain h) with
    | true => exact fun _ => (held_eq_off_iff (model hs) gainOf lossOf).2 (goExcess_of_all_not h₂)
    | false => exact fun same => nomatch same

end SignLoop

end HeldForReading

end Becoming
