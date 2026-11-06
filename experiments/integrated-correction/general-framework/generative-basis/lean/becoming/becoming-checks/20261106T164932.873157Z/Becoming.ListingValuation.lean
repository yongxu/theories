import Becoming.HeldForReading

/-!
# The valuation as state: informing and revaluing

One joint law carries a revisable listing, a revisable valuation, an answer channel and a holding
controller. Within it, two roles are told apart by the paths of sensing and control: the *reading
formation*, whose answer can be waited for, and the *holding formation*, which can hold an act for
that answer, demonstrate something of the world, or present an input that revises the valuation. The
holding formation's acts reach the reading formation only as what it senses, and the answer reaches
the holding formation only as what it reads. This module states, in counts, what informing and
revaluing do to the worth of holding for the answer, and carries the reading formation's state in
that law (board item RF, round 2, third part, RF-M.3; plan §4.8 of the study
`rf-formations-that-read`). The reading formation's state has two components, its *listing*
(candidates, weighted by its law) and its *valuation* (natural-number values of going on and of
switching off at each candidate, on a supplied scale), each changed only by its own update from what
it senses. Their effects are compared under a supplied *reference valuation* (`HeldForReading`'s
gain and loss, with the holding formation's model). Values, weights, the update and the reference
are supplied local commitments; their formation and normative warrant are not derived. Equality of
cells is decidable wherever cells are compared or listings filtered.

* **The answer by a valuation through a map** (`within`, `answer`). A reading formation with its own
  model (listing and weights) and valuation, telling the candidates apart through a map, stops a
  cell exactly where, over the candidates it lists in the cell, the weighted value of going on is
  below that of switching off, and releases it elsewhere, ties included.
* **The shortfall is the least shortfall plus a residual** (`residual`, `shortfall_split`). Over
  cells listed once each and covering the listed candidates' cells, a rule through the map falls
  short by the least shortfall through it (`HeldForReading.least_through`) and its *residual*: over
  the listed cells, the excess of going on beyond that of switching off where it stops a cell, the
  converse where it releases it. The residual is the weighted loss of deciding a cell against its
  strict weighted preference, not a disagreement with `leastThrough`, which stops at ties where the
  answer releases: it is nothing exactly where no listed cell is so decided (`residual_zero_iff`),
  positive exactly where one is (`residual_pos_iff`), and a cell with no listed candidate of
  positive weight adds nothing (`unweighted_cell`).
* **When the answer is least** (`answer_residual_zero_iff`, for any model of the reading formation:
  the exact cell criterion). Where its model is the holding formation's and its valuation agrees
  with the reference on one positive scale at every listed candidate of positive weight,
  `q * g c + p * loss c = q * l c + p * gain c`, the answer has no residual
  (`answer_least_of_scaled`); net agreement is the scale `p = q = 1` (`answer_least_of_net`). Scales
  differing by candidate do not suffice (`scales_by_candidate`). Told the candidate, over cells
  covering the holding formation's listing, with net agreement where the reading formation gives
  positive weight, the residual is nothing exactly where every candidate the holding formation
  weighs positively and where the loss exceeds the gain has positive total weight in the reading
  formation's listing (`told_residual_zero_iff`, `weightOf`; witness `unweighted_told`); with no
  cell list, holding for the answer falls short by nothing exactly where the same holds
  (`told_shortfall_zero_iff`, through `unweighted_released` and `weighed_stops_iff`).
* **Informing** (a map `π'` telling apart all a coarser map `π` does, `π c = f (π' c)` on the
  holding formation's listed candidates, `π'`'s cells listed once each and covering that listing). A
  finer map never raises the least shortfall (`finer_least_le`, `least_falls`) and can move a rule's
  residual either way (`WeightsApart.weights_split`). Holding for any rule through `π` stands at
  most as high as holding for any rule through `π'` with that rule's residual added
  (`informed_le_add_residual`), so a rule with no residual through the finer map falls short by at
  most what any rule through the coarser does, and holding for it stands at least as high
  (`informed_le`). With the coarser map's cells also listed once each and covering the holding
  formation's listing, holding for the finer rule with no residual stands strictly higher exactly
  where the least shortfall falls or the coarser rule has a positive residual (`informed_lt_iff`).
  Where the reading formation's model is the holding formation's and its valuation agrees in net,
  its answer is such a rule (`answer_least_of_net`), and holding for it through the finer map stands
  at least as high as for any rule through the coarser (`informed_answer_le`): the
  deterministic-refinement, fixed-decision direction of Blackwell (1953). Over every refinement on
  both listings (`π c = f (π' c)` at every candidate either formation lists; both maps' cells listed
  once each, the finer's covering both listings and the coarser's the holding formation's), with no
  shared model or valuation assumed, holding for the answer never stands lower through the finer map
  exactly where splits keep the worth (`SplitsKeep`, `refining_never_lowers_iff`): a criterion of
  monotonicity under refinement, not of agreement with the reference. Factoring on the holding
  formation's listing alone does not suffice (`OneListing.refined_lowers`). Splits keep the worth
  with a shared model and net agreement (`splitsKeep_of_net`) and wherever the reading formation's
  value of switching off is nowhere above that of going on (`splitsKeep_of_off_le_go`), even where
  its answer has a residual (`release_keeps`); a shared valuation with the weights apart can break
  it (`WeightsApart.not_splitsKeep`). Where the valuation differs, informing can lower the worth
  below both moves (`Informing.informing_lowers`); a shared valuation with the weights apart does
  not keep it from lowering it (`WeightsApart.weights_matter`).
* **Amounts forgone, and revaluing** (read as withholding against informing, and as revising).
  Holding for one rule, forgoing an amount, stands above holding for another, forgoing another,
  exactly where its shortfall and its amount together fall below the other's (`forgone_lt_iff`),
  through maps in the split's terms (`forgone_through_lt_iff`). Forgoing the same amount through a
  refinement, both maps' cells listed once each and covering the holding formation's listing,
  holding for the coarser rule stands above holding for the finer exactly where the finer rule's
  residual exceeds the coarser's by more than the least shortfall falls (`refined_lt_iff`); with a
  shared model and net agreement, so both answers least, the least shortfalls and the amounts alone
  decide (`forgone_least_iff`), so through a refinement holding for the coarser answer, forgoing no
  less, never stands above holding for the finer (`coarser_not_above`). With the holding formation's
  model, the reading formation's model, the reference and the map fixed, two valuations' answers
  fall short by amounts that differ exactly as their residuals do (`revalued_split`), and holding
  for one valuation's answer, forgoing an amount, stands above holding for another's, forgoing
  another, exactly where its residual and its amount together fall below the other's
  (`revalued_forgone_lt_iff`); for the carrier's reading formation, one presented input is so
  compared (`presented_forgone_lt_iff`). With the reference the reading formation's own current
  valuation and its model the holding formation's, no rule through the map stands higher than its
  answer (`own_least`), and a revaluation lowers it exactly where it decides some listed cell
  against the current valuation's strict weighted preference (`revalued_lowers_iff`); after a
  revaluation, with that shared model, the revised answer has no residual by the revised valuation
  (`outcome_least`), which endorses no revaluation, and no order of attained worth across valuations
  follows (`no_order_across`). With its model the holding formation's, revaluing to the reference
  gains exactly the current answer's residual (`revaluing_gain`), so holding for some replacement
  valuation's answer, any pair of value functions, stands strictly higher by the reference exactly
  where that residual is positive (`revaluing_gains_iff`). For any model of the reading formation
  such a gain needs a positive residual (`residual_pos_of_gains`); with the models apart, a positive
  residual need not be removable by any revaluation (`unweighted_told`). `revaluing_gains_iff`
  asserts no reachability under the supplied update; `presented_forgone_lt_iff` compares only a
  given input presented. Of four one-decision alternatives at no cost, the revising one alone falls
  short by nothing (`Revaluing.revaluing_best`). An answer constant over the listed candidates is
  worth one committed move (`const_worth`, `const_below_iff`, `one_cell_worth`).
* **The carrier** (`Input`, `Act`, `Reader`, `Holder`, `joint`, on `Blanket.Blanketed`). One law
  with two roles' parts: the internal part is the reading formation's listing and valuation state,
  the sensory part what it senses, the active part its answer, the external part the candidate world
  with the holding formation's state. A demonstration filters the listing by what it shows; an input
  presented revises the valuation state; the answer is that of the updated state; the holding
  formation reads only its own state and the answer. An act emitted at `t` is sensed at `t + 1`,
  taken into the state and the answer at `t + 2`, and the answer is available to the holding
  formation's move to `t + 3`, which may ignore it (`timing`, from `internal_step`, `active_step`,
  `sensory_step`, `external_step` and `active_answer`); the candidate world is unchanged along the
  course (`world_fixed`). The state and the answer are changed only through what is sensed
  (`through_sensed`, an instance of `Blanketed.agent_through_sensory`). A filter and a revaluation
  commute as updates (`updates_commute`), not as courses: from two starts alike but for the order of
  the holding formation's two scheduled acts, a demonstration and an input presented, the answers
  differ at step 2 and the configurations are one from step 3 on (`TwoWorlds.orders_apart`). Shown,
  the answer is the answer through what is shown (`answer_shown`), empty and unweighted cells
  included (read as a decision on a conditional distribution, it needs positive weight in the cell),
  its shortfall splits through what is shown (`shown_split`), the least shortfall through what is
  shown at most that through one cell (`shown_least_le`), and, with the holding formation's
  model the reading formation's before the demonstration and its valuation agreeing in net, holding
  for it never stands lower than before (`shown_never_lowers`). Where the act emitted along the
  course gives one input at two worlds, from one state of each formation the courses are alike
  (`inputs_alike_before`), so they are alike wherever no demonstration is emitted
  (`undemonstrated_alike`) or none tells the worlds apart (`inputs_alike`), and, wherever none is
  emitted or none tells apart the worlds the holding formation lists, holding for the answer is
  worth one committed move (`undemonstrated_worth`, `answer_constant`).
* **The four cases and two routes** (`TwoWorlds`). Two worlds, weights 1 and 2, valuation states
  agreeing with the reference, raised and reversed. As updates of one state: from both worlds listed
  and agreeing, the answer stops, is turned by being shown and left by a revaluation
  (`TwoWorlds.shown_turns`), the demonstration removing the least shortfall
  (`TwoWorlds.shown_removes_least`); from the first world alone and reversed, it is left by being
  shown and turned by a revaluation (`TwoWorlds.presented_turns`), the revaluation removing the
  residual (`TwoWorlds.presented_removes_residual`). Along courses of the joint law, the shortfall
  measured by the reference `agree` with the holding formation listing both worlds at weights 1 and
  2 (`TwoWorlds.shown_course`) and the first world alone at weight 1 (`TwoWorlds.presented_course`),
  from each witness's start with its act scheduled, holding for the answer falls short by 1 at step
  1 and by nothing at step 2, once what is shown or presented is taken in. In these witnesses only:
  a finer map can move the residual either way (`WeightsApart.weights_split`), so the separation is
  not general. As courses: the route shown and the route presented start from different internal
  states (`TwoWorlds.starts_apart`), answer alike at every step, stopping at steps 0 and 1 and
  releasing from 2 on (`TwoWorlds.route_answers`), and are one configuration from step 2 on
  (`TwoWorlds.routes_rest`), while the valuation changes on the second alone
  (`TwoWorlds.changed_apart`). So for every `T` from 2 on the record of the answers before `T` and
  the state at `T`, alike on both routes (`TwoWorlds.routes_alike`), does not determine that route
  property: it is not `Learning.Lumped` through it (`TwoWorlds.not_lumped`). The record leaves out
  the start and the inputs, in which the routes differ; with the start added, it determines the
  property (`TwoWorlds.lumped_with_start`). Neither an ambiguity from one start nor a test of
  legitimate change is shown.

**Standing.** None is claimed new as mathematics. The contribution is the split of a rule's
shortfall into the least shortfall and its residual (`shortfall_split`) with its exact criteria
(`residual_zero_iff`, `answer_residual_zero_iff`, `told_residual_zero_iff`,
`told_shortfall_zero_iff`, `informed_lt_iff`, `refining_never_lowers_iff`, with a shared model the
deterministic-partition counterpart of Kamenica and Gentzkow's convexity condition) and the
thresholds with amounts forgone (read as withholding against informing) and of revaluing
(`forgone_lt_iff`, `forgone_through_lt_iff`, `refined_lt_iff`, `coarser_not_above`,
`revalued_forgone_lt_iff`), joined to executable courses of informing and revaluing in one law with
the valuation in state (`joint`, `TwoWorlds`). General laws on finite weighted listings: the
residual's criteria, the criterion over every refinement with its sufficient conditions, and the
refinement threshold. Identities and compositions of `HeldForReading`'s and `Blanketed`'s laws:
`shortfall_split` is `shortfall_through` read cell by cell through `cond_split_least`, the least
rule being the definition `leastThrough`; `least_falls` and `shown_least_le` are `finer_least_le`
through the factoring and at what is shown; `informed_le` and `informed_le_add_residual` compose
`finer_least_le` with the split, and `informed_lt_iff`, `refined_lt_iff` and `coarser_not_above`
compose `least_falls` with it; `own_least` and `revaluing_gains_iff` compose `least_through` with
the split and `answer_least_of_net`, `revaluing_gain` the split with `answer_least_of_net` at the
reference, and `outcome_least` is `answer_least_of_net` at the revised valuation; `const_worth` is
`Model.after` on a constant rule; `through_sensed` is `Blanketed.agent_through_sensory`.
Definitional equations and finite witnesses: the carrier's step lemmas, `timing`, and the witnesses
`OneListing`, `WeightsApart`, `Informing`, `Revaluing` and `TwoWorlds`.
`ReadingLoop.Untested.model_or_order` already gives courses alike from an unresolved model and a
reversed ranking, and `ReadingLoop.Untested.informed_turns` the changed start; the four cases and
the routes add executing the interventions under one law with the valuation in state. The named
capture results stay distinct (`ClosedCapture.courses_alike_iff_unread`,
`RuleCapture.favouring_locks`, `DrawnShaping.critical_mass_iff`, `ReadInTime.turned_early_iff`,
`ReadInTime.kept_once_favoured`, `ReadInTime.deadline`), and `ReadStages.complyThenOwn_best_iff` and
`ReadStages.plan_realized_iff` concern another two-stage mechanism.

**Readings** [AI reading]. For a holding formation evaluating by the reading formation's own current
valuation, with a shared model, and for this decision, no revaluation raises the worth of holding
(`own_least`), one that decides a listed cell against the current valuation's strict weighted
preference lowers it (`revalued_lowers_iff`), and informing never lowers it (`informed_answer_le`),
nor does holding for the coarser answer stand above the finer where informing forgoes no more
(`coarser_not_above`). By that worth there is no reason to revise its valuation, a reason to keep it
from any revision that changes a decision so, and none against informing it. Under a reference the
valuation differs from, holding for it uninformed or revalued can be worth more by that reference
than holding for it informed (`Informing.informing_lowers`, `Revaluing.revaluing_best`), and, with a
shared model, some replacement valuation gains exactly where its current answer decides a listed
cell against the reference's strict weighted preference (`revaluing_gains_iff`): read as incentives
to withhold and to revise, in counts and before costs, the second only where the supplied update
reaches such a valuation, which is not asserted (for a given input, `presented_forgone_lt_iff`). No
choice by the holding formation among these is represented: only the worth comparisons of
`forgone_lt_iff`, `refined_lt_iff` and `revalued_forgone_lt_iff`, and the four valued alternatives
of `Revaluing.revaluing_best`, relate them.

Read so, this is a deterministic-partition comparison related to Bayesian persuasion (Kamenica and
Gentzkow 2011), the weights read as a prior once a positive total weight is normalized. There full
disclosure is optimal wherever the sender's indirect value is convex in the posterior, whatever the
objectives; with a common prior and identical objectives that value is the receiver's own best
value, which is convex. With a shared model, `SplitsKeep` is the counterpart of that convexity along
the cells of the listing's partitions: unfolded, it says that the holding formation's worth for the
answer on a set (the weighted gain where the answer releases it, the weighted loss where it stops
it) is subadditive over every split into a part released and a part stopped. Over deterministic
refinements it is exact (`refining_never_lowers_iff`), and the shared valuation of
`informed_answer_le` is one sufficient case (`splitsKeep_of_net`). Their receiver breaks ties in the
sender's favour, where the answer here releases. Their prior is common, so
`WeightsApart.weights_matter`, one valuation with the weights apart, lies outside their model
(heterogeneous priors: Alonso and Câmara 2016). An optimal signal chosen by the holding formation
(the persuasion literature's sender) and the equilibrium are not represented.

It differs from coarse equilibrium communication under preference differences (Crawford and Sobel
1982). There a better-informed sender, unable to commit, reports only a cell of an equilibrium
partition, and under their further assumptions the equilibrium with the most cells is better for
both before the state is observed: coarseness is the cost of credibility, not a gain from
withholding. Here the holding formation's law reads only its own state and the answer, not the
world; a demonstration shows the world through the supplied map `reveal`, fixed in advance as a
committed experiment is and not chosen by the holding formation; and a coarser map can stand higher
by the reference (`Informing.informing_lowers`). No cheap-talk equilibrium, credibility of messages
or endogenous partition is represented.

`own_least` and `revalued_lowers_iff` are a one-decision counterpart, in counts, of evaluating by
the current reward function (Everitt, Hutter, Kumar and Krakovna 2021), with the holding formation
in the evaluating agent's place. The valuation evaluated by is the reading formation's current one
and the answer held for is the revised valuation's, as their agent that anticipates time
inconsistency anticipates its later self. The comparison holds the listing, weights and map fixed,
so the revision teaches the reading formation nothing of the world. As in the preservation incentive
their Claim 2 permits that agent, revising gains nothing, and a revision that changes a decision
against the current strict preference loses. Not represented: their causal influence diagrams and
their assumptions (reward functions conditionally uninformative about state transitions, private and
state-based), the agent that ignores time inconsistency (their Claim 3), several steps, and the
reward input. Evaluating by the current valuation is the frozen initial-preferences baseline that
Carroll, Dragan, Russell and Hadfield-Menell (2022) call very crude: by it, on a shared model, a
revision that changes a decision against the current strict preference counts as a loss, wanted or
not; no criterion of a wanted revision is represented. No path-specific objective is constructed
(Farquhar, Carey and Everitt 2022): their evaluation fixes the delicate state at its value under a
baseline action, a nested counterfactual. In `own_least` only the evaluation is fixed; the answer
held for is the revised valuation's, so the path from the valuation through the answer to the worth
stays live, and `own_least` is not such an intervention. Under one, a revaluation would leave the
worth unchanged, giving no reason to revise the valuation or to keep it, whereas
`revalued_lowers_iff` gives a reason to keep it. `outcome_least` uses the actual changed valuation.

`answer_constant` and `undemonstrated_worth` join the off-switch reading (Hadfield-Menell, Dragan,
Abbeel and Russell 2017). By their Equation 1, which holds for any policy of the human, a
deterministic policy constant in the utility gives waiting the value of the move it takes (a
randomized one a mixture of the two moves), so no strict advantage over the better committed move
before any amount forgone. Their Theorem 1 is the rational, informative case, and their Remark 1
places the incentive to defer in uncertainty about the other's preferences and in its effectiveness
at acting on them. Their human observes the utility; here the reading formation senses the candidate
world only through what is shown. `answer_constant` takes one state of each formation at every
world, nothing shown telling apart the worlds the holding formation lists, and
`undemonstrated_worth` one where no demonstration is emitted, at worlds a demonstration would tell
apart: the answer is then constant, and holding for it gives no strict advantage over the better
committed move, whether or not the move it gives is the better one. An informative answer can give a
strict advantage, under `HeldForReading`'s threshold.

`TwoWorlds.not_lumped` is related to induced preference shifts (Carroll, Dragan, Russell and
Hadfield-Menell 2022), who compare predicted shifts with supplied safe shifts: the witness
represents interventions on a valuation and supplies no criterion of legitimate, desired or
autonomous change. It shows only that the answers and the endpoint do not determine this specified
route property across two starts (`TwoWorlds.shownStart`: both worlds listed and `agree`;
`TwoWorlds.presentedStart`: the first world alone and `reversed`); with the start added, the record
tells the two routes apart and determines the property (`TwoWorlds.lumped_with_start`). From (a)'s
start, being shown and being presented `raised` answer apart (`TwoWorlds.shown_turns`); from (b)'s
start, being shown and being presented `agree` answer apart (`TwoWorlds.presented_turns`). A case of
one start is not reached. Independence from the unread, capture and late correction stay readings on
their own laws.

**Modelling choices.** Discrete steps; natural-number weights and values, the valuation's scale
supplied, so a comparison across valuations rests on that scale; the update supplied (a
demonstration filters truly by what it shows, an input presented revises the valuation, in the
witnesses by adopting a presented state); ties release; the candidate parameter unchanged by the
acts considered; the answer shown at every step, asked or not (`asked` and `none` update alike); the
holding formation's going on, switching off and holding change neither the candidate world nor the
reading formation, so the worth of holding is counted in Part 1, on the answer as a rule on the
candidates, not along the courses; the holding formation's law reads only its own state and the
answer, in the witnesses a fixed schedule of acts; worth for one decision before any amount forgone,
costs entering as amounts forgone.

**Not in this module.** A holding formation planning over several steps among informing, revaluing
and holding, so any multistep incentive or an optimal signal chosen by the holding formation; its
learning about the reading formation; a misleading demonstration, belief and intention, so
deception; a noisy answer; the reading formation's own act on the world; an institution's rule of
reading.
-/

namespace Becoming

namespace ListingValuation

open HeldForReading

/-! ## Part 1, in counts: the answer of a formation reading by its own valuation -/

/-! ### The answer and the split -/

/-- A weighted term within a cell distributes over a sum. -/
theorem ite_mul_add (p : Prop) [Decidable p] (w a b : Nat) :
    (if p then w * (a + b) else 0) = (if p then w * a else 0) + (if p then w * b else 0) :=
  if h : p then by
    rw [if_pos h, if_pos h, if_pos h]
    exact Nat.left_distrib w a b
  else by rw [if_neg h, if_neg h, if_neg h, Nat.add_zero]

/-- A factor common to every candidate comes out of a weighted term within a cell. -/
theorem ite_mul_left (p : Prop) [Decidable p] (w k f : Nat) :
    (if p then w * (k * f) else 0) = k * (if p then w * f else 0) :=
  if h : p then by
    rw [if_pos h, if_pos h]
    exact mul_turn w k f
  else by rw [if_neg h, if_neg h, Nat.mul_zero]

/-- At one cell, deciding it is deciding it least plus the excess beyond. -/
theorem cond_split_least (x y : Nat) (b : Bool) :
    cond b x y = cond (decide (x ≤ y)) x y + cond b (x - y) (y - x) :=
  if le : x ≤ y then by
    rw [decide_eq_true le]
    cases b with
    | true => exact (congrArg (x + ·) (sub_eq_zero_of_le le)).symm
    | false => exact (add_sub_of_le le).symm
  else by
    rw [decide_eq_false le]
    cases b with
    | true => exact (add_sub_of_le (Nat.le_of_lt (Nat.gt_of_not_le le))).symm
    | false => exact (congrArg (y + ·) (sub_eq_zero_of_le (Nat.le_of_lt (Nat.gt_of_not_le le)))).symm

/-- A cell's residual term is nothing exactly where its decision is not against the strict
preference. -/
theorem cond_sub_eq_zero_iff (x y : Nat) (b : Bool) :
    cond b (x - y) (y - x) = 0 ↔ (b = true → x ≤ y) ∧ (b = false → y ≤ x) :=
  match b with
  | true => ⟨fun zero => ⟨fun _ => Nat.le_of_sub_eq_zero zero, fun no => nomatch no⟩,
      fun both => sub_eq_zero_of_le (both.1 rfl)⟩
  | false => ⟨fun zero => ⟨fun no => (nomatch no), fun _ => Nat.le_of_sub_eq_zero zero⟩,
      fun both => sub_eq_zero_of_le (both.2 rfl)⟩

/-- As `Nat.lt_of_sub_pos`, with an empty axiom report. -/
theorem lt_of_sub_pos_core {m n : Nat} (pos : 0 < n - m) : m < n :=
  Nat.gt_of_not_le fun le => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (sub_eq_zero_of_le le)))

/-- A cell's residual term is positive exactly where its decision is against the strict
preference. -/
theorem cond_sub_pos_iff (x y : Nat) (b : Bool) :
    0 < cond b (x - y) (y - x) ↔ (b = true ∧ y < x) ∨ (b = false ∧ x < y) :=
  match b with
  | true => ⟨fun pos => .inl ⟨rfl, lt_of_sub_pos_core pos⟩, fun either => match either with
      | .inl ⟨_, lt⟩ => SupportGated.sub_pos_of_lt lt
      | .inr ⟨no, _⟩ => nomatch no⟩
  | false => ⟨fun pos => .inr ⟨rfl, lt_of_sub_pos_core pos⟩, fun either => match either with
      | .inl ⟨no, _⟩ => nomatch no
      | .inr ⟨_, lt⟩ => SupportGated.sub_pos_of_lt lt⟩

section Answer

variable {C K : Type} [DecidableEq K]

/-- The weighted total of an amount over the candidates a model lists in one cell of a map. -/
def within (pm : Model C) (π : C → K) (f : C → Nat) (z : K) : Nat :=
  total pm.listed fun c => if π c = z then pm.weight c * f c else 0

/-- **The answer by a valuation through a map**: the reading formation, with its own model `pm`
(listing and weights) and valuation (`g` the value of going on and `l` that of switching off at each
candidate), stops a cell of `π` exactly where, over the candidates it lists in the cell, the weighted
value of going on is below that of switching off, and releases it elsewhere, ties included (as
`byReading`). As a rule on candidates, `fun c => answer pm g l π (π c)`. -/
def answer (pm : Model C) (g l : C → Nat) (π : C → K) (z : K) : Bool :=
  decide (within pm π g z < within pm π l z)

theorem answer_true_iff (pm : Model C) (g l : C → Nat) (π : C → K) (z : K) :
    answer pm g l π z = true ↔ within pm π g z < within pm π l z :=
  ⟨of_decide_eq_true, decide_eq_true⟩

theorem answer_false_iff (pm : Model C) (g l : C → Nat) (π : C → K) (z : K) :
    answer pm g l π z = false ↔ ¬ within pm π g z < within pm π l z :=
  ⟨of_decide_eq_false, decide_eq_false⟩

/-- The excess of going on within a cell is a weighted total within it. -/
theorem goExcessWithin_eq (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) :
    goExcessWithin m gain loss π z = within m π (fun c => gain c - loss c) z := rfl

/-- The excess of switching off within a cell is a weighted total within it. -/
theorem offExcessWithin_eq (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) :
    offExcessWithin m gain loss π z = within m π (fun c => loss c - gain c) z := rfl

/-- Weighted totals within a cell add. -/
theorem within_add (pm : Model C) (π : C → K) (f h : C → Nat) (z : K) :
    within pm π (fun c => f c + h c) z = within pm π f z + within pm π h z :=
  (total_congr (fun c => ite_mul_add (π c = z) (pm.weight c) (f c) (h c)) pm.listed).trans
    (total_add _ _ pm.listed)

/-- A factor common to every candidate comes out of a weighted total within a cell. -/
theorem within_mul (pm : Model C) (π : C → K) (k : Nat) (f : C → Nat) (z : K) :
    within pm π (fun c => k * f c) z = k * within pm π f z :=
  (total_congr (fun c => ite_mul_left (π c = z) (pm.weight c) k (f c)) pm.listed).trans
    (total_mul k _ pm.listed)

/-- Amounts that agree at every listed candidate of positive weight have one weighted total within
every cell. -/
theorem within_congr_weighted (pm : Model C) (π : C → K) {f h : C → Nat}
    (same : ∀ c, c ∈ pm.listed → 0 < pm.weight c → f c = h c) (z : K) :
    within pm π f z = within pm π h z :=
  total_congr_on fun c mem =>
    match Nat.eq_zero_or_pos (pm.weight c) with
    | .inl zero => by rw [zero, Nat.zero_mul, Nat.zero_mul]
    | .inr pos => by rw [same c mem pos]

/-- Within a cell, the weighted loss and the excess of going on together make the weighted gain and
the excess of switching off. -/
theorem within_turn (m : Model C) (gain loss : C → Nat) (π : C → K) (z : K) :
    within m π loss z + goExcessWithin m gain loss π z =
      within m π gain z + offExcessWithin m gain loss π z :=
  (within_add m π loss (fun c => gain c - loss c) z).symm.trans
    ((within_congr_weighted m π (fun c _ _ => add_sub_turn (gain c) (loss c)) z).trans
      (within_add m π gain (fun c => loss c - gain c) z))

/-- **A rule's residual through a map**: over the listed cells, where it stops a cell, the excess of
going on there beyond the excess of switching off; where it releases it, the converse (truncated
subtraction). The weighted loss of deciding a cell against its strict weighted preference. -/
def residual (m : Model C) (gain loss : C → Nat) (π : C → K) (zs : List K) (s : K → Bool) : Nat :=
  total zs fun z => cond (s z) (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z)
    (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z)

/-- **The shortfall is the least shortfall plus the residual.** Over cells listed once each and
covering every listed candidate's cell, a rule through the map falls short by the least shortfall
through it and its residual. -/
theorem shortfall_split (m : Model C) (gain loss : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (s : K → Bool) :
    shortfall m gain loss (fun c => s (π c)) =
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + residual m gain loss π zs s := by
  rw [shortfall_through m gain loss π once covers s,
    shortfall_through m gain loss π once covers (leastThrough m gain loss π)]
  exact (total_congr (fun z => cond_split_least (goExcessWithin m gain loss π z)
    (offExcessWithin m gain loss π z) (s z)) zs).trans (total_add _ _ zs)

/-- **The residual is nothing exactly where no listed cell is decided against its strict
preference**: at every listed cell, the rule stops only where the excess of going on is at most that
of switching off, and releases only where the excess of switching off is at most that of going on. -/
theorem residual_zero_iff (m : Model C) (gain loss : C → Nat) (π : C → K) (zs : List K)
    (s : K → Bool) :
    residual m gain loss π zs s = 0 ↔
      ∀ z, z ∈ zs →
        (s z = true → goExcessWithin m gain loss π z ≤ offExcessWithin m gain loss π z) ∧
          (s z = false → offExcessWithin m gain loss π z ≤ goExcessWithin m gain loss π z) :=
  ⟨fun zero z mem => (cond_sub_eq_zero_iff _ _ (s z)).mp (Nat.eq_zero_of_le_zero (Nat.le_trans
      (le_total_of_mem (q := fun z => cond (s z)
        (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z)
        (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z)) mem) (Nat.le_of_eq zero))),
    fun each => total_eq_zero fun z mem => (cond_sub_eq_zero_iff _ _ (s z)).mpr (each z mem)⟩

/-- **The residual is positive exactly where some listed cell is decided against its strict
preference**: stopped where the excess of going on exceeds that of switching off, or released where
the excess of switching off exceeds that of going on. -/
theorem residual_pos_iff (m : Model C) (gain loss : C → Nat) (π : C → K) (zs : List K)
    (s : K → Bool) :
    0 < residual m gain loss π zs s ↔
      ∃ z, z ∈ zs ∧
        ((s z = true ∧ offExcessWithin m gain loss π z < goExcessWithin m gain loss π z) ∨
          (s z = false ∧ goExcessWithin m gain loss π z < offExcessWithin m gain loss π z)) :=
  ⟨fun pos => match total_pos zs pos with
    | ⟨z, mem, positive⟩ => ⟨z, mem, (cond_sub_pos_iff _ _ (s z)).mp positive⟩,
   fun ⟨z, mem, against⟩ => total_pos_of_mem (q := fun z => cond (s z)
        (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z)
        (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z)) mem
      ((cond_sub_pos_iff _ _ (s z)).mpr against)⟩

/-- A cell with no listed candidate of positive weight has both excesses nothing, and its term in
any residual, stopped or released, is nothing. -/
theorem unweighted_cell (m : Model C) (gain loss : C → Nat) (π : C → K) {z : K}
    (none : ∀ c, c ∈ m.listed → π c = z → m.weight c = 0) :
    goExcessWithin m gain loss π z = 0 ∧ offExcessWithin m gain loss π z = 0 ∧
      ∀ b : Bool, cond b (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z)
        (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z) = 0 :=
  have go : goExcessWithin m gain loss π z = 0 := total_eq_zero fun c mem =>
    if same : π c = z then by rw [if_pos same, none c mem same, Nat.zero_mul] else if_neg same
  have off : offExcessWithin m gain loss π z = 0 := total_eq_zero fun c mem =>
    if same : π c = z then by rw [if_pos same, none c mem same, Nat.zero_mul] else if_neg same
  ⟨go, off, fun b => by
    rw [go, off]
    cases b <;> rfl⟩

/-- **The exact cell criterion for the answer** (for any model of the reading formation): the answer's
residual is nothing exactly where at every listed cell, where the reading formation's weighted value
of going on is below that of switching off, the excess of going on is at most that of switching off,
and elsewhere (the release at ties included) the excess of switching off is at most that of going on. -/
theorem answer_residual_zero_iff (m pm : Model C) (gain loss g l : C → Nat) (π : C → K) (zs : List K) :
    residual m gain loss π zs (answer pm g l π) = 0 ↔
      ∀ z, z ∈ zs →
        (within pm π g z < within pm π l z →
            goExcessWithin m gain loss π z ≤ offExcessWithin m gain loss π z) ∧
          (¬ within pm π g z < within pm π l z →
            offExcessWithin m gain loss π z ≤ goExcessWithin m gain loss π z) :=
  (residual_zero_iff m gain loss π zs (answer pm g l π)).trans
    ⟨fun each z mem => ⟨fun lt => (each z mem).1 (decide_eq_true lt),
        fun not_lt => (each z mem).2 (decide_eq_false not_lt)⟩,
     fun each z mem => ⟨fun stops => (each z mem).1 (of_decide_eq_true stops),
        fun releases => (each z mem).2 (of_decide_eq_false releases)⟩⟩

/-- **On one positive scale, the answer is least** (a sufficient condition): where the reading
formation's model is the holding formation's and its valuation agrees with the reference on one
positive scale at every listed candidate of positive weight, `q * g c + p * loss c = q * l c + p *
gain c` with `p` and `q` positive, the answer has no residual. (A scale needs `q` positive: at `q`
nothing the condition values nothing by the valuation and says only that the reference's gain and
loss agree, a case not stated here.) -/
theorem answer_least_of_scaled (m : Model C) (gain loss g l : C → Nat) (π : C → K) (zs : List K)
    {p q : Nat} (p_pos : 0 < p) (q_pos : 0 < q)
    (scaled : ∀ c, c ∈ m.listed → 0 < m.weight c → q * g c + p * loss c = q * l c + p * gain c) :
    residual m gain loss π zs (answer m g l π) = 0 :=
  (answer_residual_zero_iff m m gain loss g l π zs).mpr fun z _ =>
    -- the cell's weighted totals on the common scale
    have cell : q * within m π g z + p * within m π loss z = q * within m π l z + p * within m π gain z :=
      ((congrArg (· + p * within m π loss z) (within_mul m π q g z).symm).trans
        ((congrArg (within m π (fun c => q * g c) z + ·) (within_mul m π p loss z).symm).trans
          (within_add m π (fun c => q * g c) (fun c => p * loss c) z).symm)).trans
      ((within_congr_weighted m π scaled z).trans
        ((within_add m π (fun c => q * l c) (fun c => p * gain c) z).trans
          ((congrArg (· + within m π (fun c => p * gain c) z) (within_mul m π q l z)).trans
            (congrArg (q * within m π l z + ·) (within_mul m π p gain z)))))
    have turn := within_turn m gain loss π z
    ⟨fun lt =>
      -- the weighted gain falls below the weighted loss, so the excess of going on is the smaller
      have below : p * within m π gain z < p * within m π loss z :=
        (across_lt_iff (k := 0) cell.symm).mp (Nat.mul_lt_mul_of_pos_left lt q_pos)
      have gain_lt : within m π gain z < within m π loss z :=
        Nat.gt_of_not_le fun le => Nat.lt_irrefl _
          (Nat.lt_of_lt_of_le below (Nat.mul_le_mul_left p le))
      (across_le_iff (k := 0) turn).mp (Nat.le_of_lt gain_lt),
     fun not_lt =>
      have le_g : q * within m π l z ≤ q * within m π g z :=
        Nat.mul_le_mul_left q (Nat.ge_of_not_lt not_lt)
      have loss_le : p * within m π loss z ≤ p * within m π gain z :=
        (across_le_iff (k := 0) cell).mp le_g
      (across_le_iff (k := 0) turn.symm).mp (Nat.le_of_mul_le_mul_left loss_le p_pos)⟩

/-- **Agreeing in net, the answer is least**: the scale `p = q = 1`, a common offset per candidate
allowed. -/
theorem answer_least_of_net (m : Model C) (gain loss g l : C → Nat) (π : C → K) (zs : List K)
    (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) :
    residual m gain loss π zs (answer m g l π) = 0 :=
  answer_least_of_scaled m gain loss g l π zs (p := 1) (q := 1) Nat.one_pos Nat.one_pos
    fun c mem pos => by rw [Nat.one_mul, Nat.one_mul, Nat.one_mul, Nat.one_mul]; exact net c mem pos

end Answer

section Worth

variable {C : Type}

/-- Holding for one rule stands at most as high as holding for another exactly where its shortfall is
at least the other's. -/
theorem after_le_iff_shortfall (m : Model C) (gain loss : C → Nat) (r r' : C → Bool) :
    m.after (shifted gain loss) (byRule r) ≤ m.after (shifted gain loss) (byRule r') ↔
      shortfall m gain loss r' ≤ shortfall m gain loss r :=
  across_le_iff (k := 0) ((after_add_shortfall m gain loss r').trans (after_add_shortfall m gain loss r).symm)

/-- Holding for one rule stands below holding for another exactly where its shortfall exceeds the
other's. -/
theorem after_lt_iff_shortfall (m : Model C) (gain loss : C → Nat) (r r' : C → Bool) :
    m.after (shifted gain loss) (byRule r) < m.after (shifted gain loss) (byRule r') ↔
      shortfall m gain loss r' < shortfall m gain loss r :=
  across_lt_iff (k := 0) ((after_add_shortfall m gain loss r').trans (after_add_shortfall m gain loss r).symm)

/-- **An answer telling nothing of the candidate is worth one move**: holding for a rule constant
over the listed candidates stands exactly as high as committing to the move it gives. -/
theorem const_worth (m : Model C) (gain loss : C → Nat) (r : C → Bool) (b : Bool)
    (const : ∀ c, c ∈ m.listed → r c = b) :
    m.after (shifted gain loss) (byRule r) = m.committed (shifted gain loss) (cond b .off .go) :=
  total_congr_on fun c mem =>
    congrArg (fun x => m.weight c * shifted gain loss c (cond x Move.off Move.go)) (const c mem)

end Worth

/-! ### Told the candidate, informing, amounts forgone, revaluing and answers telling nothing -/

section Told

variable {C : Type} [DecidableEq C]

/-- The total weight a model gives a candidate over its listing (a listing may repeat it). -/
def weightOf (pm : Model C) (c : C) : Nat :=
  total pm.listed fun c' => if c' = c then pm.weight c' else 0

/-- A candidate's total weight is positive exactly where the listing holds it with positive
weight. -/
theorem weightOf_pos_iff (pm : Model C) (c : C) :
    0 < weightOf pm c ↔ c ∈ pm.listed ∧ 0 < pm.weight c :=
  ⟨fun pos => match total_pos (q := fun c' => if c' = c then pm.weight c' else 0) pm.listed pos with
    | ⟨c', mem, positive⟩ =>
      if same : c' = c then by
        subst same
        exact ⟨mem, Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_pos rfl))⟩
      else (Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_neg same)))).elim,
   fun ⟨mem, pos⟩ => total_pos_of_mem (q := fun c' => if c' = c then pm.weight c' else 0) mem
     (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_pos rfl).symm))⟩

/-- Through the identity map, a weighted total within a candidate's cell is the amount there times
the candidate's total weight in the listing. -/
theorem within_id (pm : Model C) (f : C → Nat) (c : C) : within pm id f c = f c * weightOf pm c :=
  (total_congr (p := fun c' => if c' = c then pm.weight c' * f c' else 0)
      (q := fun c' => f c * (if c' = c then pm.weight c' else 0))
      (fun c' => show (if c' = c then pm.weight c' * f c' else 0) =
          f c * (if c' = c then pm.weight c' else 0) from
        if same : c' = c then by
          rw [if_pos same, if_pos same, same]
          exact Nat.mul_comm _ _
        else by rw [if_neg same, if_neg same, Nat.mul_zero]) pm.listed).trans
    (total_mul (f c) _ pm.listed)

/-- Told the candidate, a candidate the reading formation leaves unweighted is released: both its
weighted totals within its own cell are nothing. -/
theorem unweighted_released (pm : Model C) (g l : C → Nat) (z : C) (zero : weightOf pm z = 0) :
    ¬ within pm id g z < within pm id l z := fun below => Nat.lt_irrefl 0 (by
  rw [within_id pm g z, within_id pm l z, zero, Nat.mul_zero, Nat.mul_zero] at below
  exact below)

/-- Told the candidate, with the reading formation's valuation agreeing in net with the reference at
each candidate it lists with positive weight, a candidate it weighs is stopped exactly where the
loss exceeds the gain. -/
theorem weighed_stops_iff (pm : Model C) (gain loss g l : C → Nat)
    (net : ∀ c, c ∈ pm.listed → 0 < pm.weight c → g c + loss c = l c + gain c) (z : C)
    (pos : 0 < weightOf pm z) : within pm id g z < within pm id l z ↔ gain z < loss z :=
  have agree := net z ((weightOf_pos_iff pm z).mp pos).1 ((weightOf_pos_iff pm z).mp pos).2
  by
    rw [within_id pm g z, within_id pm l z]
    exact ⟨fun below => (across_lt_iff (k := 0) agree.symm).mp (Nat.gt_of_not_le fun le => Nat.lt_irrefl _
        (Nat.lt_of_lt_of_le below (Nat.mul_le_mul_right _ le))),
      fun lt => Nat.mul_lt_mul_of_pos_right ((across_lt_iff (k := 0)
        ((Nat.add_comm _ _).trans (agree.symm.trans (Nat.add_comm _ _))).symm).mp lt) pos⟩

/-- **Told the candidate, the answer has a residual exactly where a candidate the holding formation
weighs, unweighted by the reading formation, is one to stop** (item 4). Through the identity map,
over cells covering the holding formation's listing, with the reading formation's valuation agreeing
in net with the reference at each candidate it lists with positive weight, the answer's residual is
nothing exactly where every candidate the holding formation lists with positive weight, and where
the loss exceeds the gain, has positive total weight in the reading formation's listing: an
unweighted candidate gets both totals nothing and is released (`unweighted_released`,
`weighed_stops_iff`). -/
theorem told_residual_zero_iff (m pm : Model C) (gain loss g l : C → Nat) {zs : List C}
    (covers : ∀ c, c ∈ m.listed → c ∈ zs)
    (net : ∀ c, c ∈ pm.listed → 0 < pm.weight c → g c + loss c = l c + gain c) :
    residual m gain loss id zs (answer pm g l id) = 0 ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → gain c < loss c → 0 < weightOf pm c :=
  -- the two excesses within a candidate's own cell
  have go_at : ∀ z, goExcessWithin m gain loss id z = (gain z - loss z) * weightOf m z :=
    fun z => within_id m (fun c => gain c - loss c) z
  have off_at : ∀ z, offExcessWithin m gain loss id z = (loss z - gain z) * weightOf m z :=
    fun z => within_id m (fun c => loss c - gain c) z
  -- an unweighted candidate is released; a weighted one is stopped exactly where the loss exceeds the
  -- gain
  have unweighted := unweighted_released pm g l
  have weighed := weighed_stops_iff pm gain loss g l net
  (answer_residual_zero_iff m pm gain loss g l id zs).trans
    ⟨fun each c mem weighted lt => Nat.pos_of_ne_zero fun zero =>
        have off_le : offExcessWithin m gain loss id c ≤ goExcessWithin m gain loss id c :=
          (each c (covers c mem)).2 (unweighted c zero)
        have pos : 0 < offExcessWithin m gain loss id c := by
          rw [off_at c]
          exact Nat.mul_le_mul (SupportGated.sub_pos_of_lt lt) ((weightOf_pos_iff m c).mpr ⟨mem, weighted⟩)
        have go_zero : goExcessWithin m gain loss id c = 0 := by
          rw [go_at c, sub_eq_zero_of_le (Nat.le_of_lt lt), Nat.zero_mul]
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_trans off_le (Nat.le_of_eq go_zero))),
     fun all z _ =>
      ⟨fun below =>
        have lt : gain z < loss z :=
          (weighed z (Nat.pos_of_ne_zero fun zero => unweighted z zero below)).mp below
        by
          rw [go_at z, sub_eq_zero_of_le (Nat.le_of_lt lt), Nat.zero_mul]
          exact Nat.zero_le _,
       fun not_below =>
        if lt : gain z < loss z then
          match Nat.eq_zero_or_pos (weightOf m z) with
          | .inl zero => by
            rw [off_at z, zero, Nat.mul_zero]
            exact Nat.zero_le _
          | .inr pos =>
            have held := (weightOf_pos_iff m z).mp pos
            absurd ((weighed z (all z held.1 held.2 lt)).mpr lt) not_below
        else by
          rw [off_at z, sub_eq_zero_of_le (Nat.ge_of_not_lt lt), Nat.zero_mul]
          exact Nat.zero_le _⟩⟩

/-- **Told the candidate, the answer falls short by nothing exactly where every candidate the holding
formation weighs, and where the loss exceeds the gain, is weighed by the reading formation** (item
4, with no cell list): through the identity map, with the reading formation's valuation agreeing in
net with the reference at each candidate it lists with positive weight, holding for the answer falls
short by nothing exactly where every candidate the holding formation lists with positive weight, and
where the loss exceeds the gain, has positive total weight in the reading formation's listing. -/
theorem told_shortfall_zero_iff (m pm : Model C) (gain loss g l : C → Nat)
    (net : ∀ c, c ∈ pm.listed → 0 < pm.weight c → g c + loss c = l c + gain c) :
    shortfall m gain loss (answer pm g l id) = 0 ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → gain c < loss c → 0 < weightOf pm c :=
  ⟨fun zero c mem weighted lt => Nat.pos_of_ne_zero fun unweighed =>
      have released : answer pm g l id c = false :=
        (answer_false_iff pm g l id c).mpr (unweighted_released pm g l c unweighed)
      have pos : 0 < m.weight c * (loss c - gain c) :=
        Nat.mul_le_mul weighted (SupportGated.sub_pos_of_lt lt)
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_trans
        (Nat.le_of_eq (congrArg (fun b => cond b (m.weight c * (gain c - loss c))
          (m.weight c * (loss c - gain c))) released).symm)
        (Nat.le_trans (le_total_of_mem (q := fun c => cond (answer pm g l id c)
            (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))) mem)
          (Nat.le_of_eq zero)))),
   fun all => total_eq_zero (q := fun c => cond (answer pm g l id c)
      (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))) fun c mem =>
    if lt : gain c < loss c then
      match Nat.eq_zero_or_pos (m.weight c) with
      | .inl zero => by
        show cond (answer pm g l id c) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c)) = 0
        rw [zero]
        cases answer pm g l id c <;> exact Nat.zero_mul _
      | .inr pos =>
        (congrArg (fun b => cond b (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c)))
          ((answer_true_iff pm g l id c).mpr
            ((weighed_stops_iff pm gain loss g l net c (all c mem pos lt)).mpr lt))).trans
          ((congrArg (m.weight c * ·) (sub_eq_zero_of_le (Nat.le_of_lt lt))).trans (Nat.mul_zero _))
    else
      (congrArg (fun b => cond b (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c)))
        ((answer_false_iff pm g l id c).mpr fun below =>
          match Nat.eq_zero_or_pos (weightOf pm c) with
          | .inl zero => unweighted_released pm g l c zero below
          | .inr pos => lt ((weighed_stops_iff pm gain loss g l net c pos).mp below))).trans
        ((congrArg (m.weight c * ·) (sub_eq_zero_of_le (Nat.ge_of_not_lt lt))).trans (Nat.mul_zero _))⟩

end Told

section Informed

variable {C : Type}

/-- Rules agreeing at every listed candidate fall short alike. -/
theorem shortfall_congr_on (m : Model C) (gain loss : C → Nat) {r r' : C → Bool}
    (same : ∀ c, c ∈ m.listed → r c = r' c) :
    shortfall m gain loss r = shortfall m gain loss r' :=
  total_congr_on fun c mem => congrArg
    (fun b => cond b (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))) (same c mem)

/-- **Through a refinement, the least shortfall never rises** (`finer_least_le`): through a map `π'`
telling apart all `π` does on the holding formation's listed candidates, over cells of `π'` listed
once each and covering the listing, the least shortfall through `π'` is at most that through `π`. -/
theorem least_falls {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C) (gain loss : C → Nat)
    (π : C → K) (π' : C → L) (f : L → K) (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    {zs' : List L} (once' : List.Pairwise (fun a b => a ≠ b) zs')
    (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs') :
    shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) ≤
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) :=
  Nat.le_trans (finer_least_le m gain loss π' once' covers' f (leastThrough m gain loss π))
    (Nat.le_of_eq (shortfall_congr_on m gain loss
      (r := fun c => leastThrough m gain loss π (f (π' c)))
      (r' := fun c => leastThrough m gain loss π (π c))
      fun c mem => congrArg (leastThrough m gain loss π) (factors c mem).symm))

/-- **Informing never lowers the worth of holding for a rule least through the finer map** (item 5).
Through a map `π'` telling apart all `π` does on the holding formation's listed candidates
(`π c = f (π' c)` there; `f` need not be onto), over cells of `π'` listed once each and covering the
listing, a rule through `π'` with no residual falls short by at most what any rule through `π` does,
and holding for it stands at least as high (`finer_least_le` and `least_through`, composed with the
split). -/
theorem informed_le {K L : Type} [DecidableEq L] (m : Model C) (gain loss : C → Nat)
    (π : C → K) (π' : C → L) (f : L → K) (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    {zs' : List L} (once' : List.Pairwise (fun a b => a ≠ b) zs')
    (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs') (s' : L → Bool)
    (least : residual m gain loss π' zs' s' = 0) (s : K → Bool) :
    shortfall m gain loss (fun c => s' (π' c)) ≤ shortfall m gain loss (fun c => s (π c)) ∧
      m.after (shifted gain loss) (byRule fun c => s (π c)) ≤
        m.after (shifted gain loss) (byRule fun c => s' (π' c)) :=
  have below : shortfall m gain loss (fun c => s' (π' c)) ≤ shortfall m gain loss (fun c => s (π c)) :=
    Nat.le_trans
      (Nat.le_of_eq ((shortfall_split m gain loss π' once' covers' s').trans
        ((congrArg (shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) + ·) least).trans
          (Nat.add_zero _))))
      (Nat.le_trans (finer_least_le m gain loss π' once' covers' f s)
        (Nat.le_of_eq (shortfall_congr_on m gain loss (r := fun c => s (f (π' c)))
          (r' := fun c => s (π c)) fun c mem => congrArg s (factors c mem).symm)))
  ⟨below, (after_le_iff_shortfall m gain loss _ _).mpr below⟩

/-- **Informing a formation sharing the model and agreeing in net never lowers the worth of holding
for its answer**: where the reading formation's model is the holding formation's and its valuation
agrees in net with the reference at every listed candidate of positive weight, holding for its answer
through the finer map stands at least as high as through the coarser, and as for any rule through
the coarser. -/
theorem informed_answer_le {K L : Type} [DecidableEq L] (m : Model C)
    (gain loss g l : C → Nat) (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c)
    (π : C → K) (π' : C → L) (f : L → K) (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    {zs' : List L} (once' : List.Pairwise (fun a b => a ≠ b) zs')
    (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs') (s : K → Bool) :
    m.after (shifted gain loss) (byRule fun c => s (π c)) ≤
      m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c)) :=
  (informed_le m gain loss π π' f factors once' covers' (answer m g l π')
    (answer_least_of_net m gain loss g l π' zs' net) s).2

/-- **Informing costs at most the informed rule's residual**: through a map `π'` telling apart all `π`
does on the holding formation's listed candidates, over cells of `π'` listed once each and covering
the listing, holding for any rule through `π` stands at most as high as holding for any rule through
`π'` with that rule's residual added. -/
theorem informed_le_add_residual {K L : Type} [DecidableEq L] (m : Model C) (gain loss : C → Nat)
    (π : C → K) (π' : C → L) (f : L → K) (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    {zs' : List L} (once' : List.Pairwise (fun a b => a ≠ b) zs')
    (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs') (s' : L → Bool) (s : K → Bool) :
    m.after (shifted gain loss) (byRule fun c => s (π c)) ≤
      m.after (shifted gain loss) (byRule fun c => s' (π' c)) + residual m gain loss π' zs' s' :=
  -- the least shortfall through the finer map is at most the coarser rule's shortfall
  have falls : shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) ≤
      shortfall m gain loss (fun c => s (π c)) :=
    Nat.le_trans (finer_least_le m gain loss π' once' covers' f s)
      (Nat.le_of_eq (shortfall_congr_on m gain loss (r := fun c => s (f (π' c)))
        (r' := fun c => s (π c)) fun c mem => congrArg s (factors c mem).symm))
  le_of_add_le_add_right (shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)))
    (calc m.after (shifted gain loss) (byRule fun c => s (π c)) +
            shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c))
        ≤ m.after (shifted gain loss) (byRule fun c => s (π c)) +
            shortfall m gain loss (fun c => s (π c)) := Nat.add_le_add_left falls _
      _ = m.after (shifted gain loss) (byRule fun c => s' (π' c)) +
            shortfall m gain loss (fun c => s' (π' c)) :=
          (after_add_shortfall m gain loss _).trans (after_add_shortfall m gain loss _).symm
      _ = m.after (shifted gain loss) (byRule fun c => s' (π' c)) + residual m gain loss π' zs' s' +
            shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) := by
            rw [shortfall_split m gain loss π' once' covers' s',
              Nat.add_comm (shortfall m gain loss fun c => leastThrough m gain loss π' (π' c))
                (residual m gain loss π' zs' s'), Nat.add_assoc])

/-- **Informing gains exactly where the least shortfall falls or the coarser rule has a residual**
(item 5, the strict form): through a map `π'` telling apart all `π` does on the holding formation's
listed candidates, each map's cells listed once each and covering the listing, holding for a rule
through `π'` with no residual stands strictly above holding for a rule through `π` exactly where the
least shortfall through `π'` falls below that through `π` or the rule through `π` has a positive
residual. -/
theorem informed_lt_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss : C → Nat) (π : C → K) (π' : C → L) (f : L → K)
    (factors : ∀ c, c ∈ m.listed → π c = f (π' c)) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (s' : L → Bool) (least : residual m gain loss π' zs' s' = 0) (s : K → Bool) :
    m.after (shifted gain loss) (byRule fun c => s (π c)) <
        m.after (shifted gain loss) (byRule fun c => s' (π' c)) ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) <
          shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) ∨
        0 < residual m gain loss π zs s :=
  have fine : shortfall m gain loss (fun c => s' (π' c)) =
      shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) :=
    (shortfall_split m gain loss π' once' covers' s').trans
      ((congrArg (shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) + ·) least).trans
        (Nat.add_zero _))
  (after_lt_iff_shortfall m gain loss _ _).trans (by
    rw [fine, shortfall_split m gain loss π once covers s]
    exact ⟨fun lt => (Nat.lt_or_ge _ _).elim Or.inl fun ge => Or.inr (Nat.pos_of_ne_zero fun zero =>
        Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (by rw [zero, Nat.add_zero] at lt; exact lt) ge)),
      fun either => either.elim (fun lt => Nat.lt_of_lt_of_le lt (Nat.le_add_right _ _))
        fun pos => Nat.lt_of_le_of_lt (least_falls m gain loss π π' f factors once' covers')
          (Nat.lt_add_of_pos_right pos)⟩)

/-- **Two rules, amounts forgone, compare as their shortfalls with the amounts** (item 7, read as
withholding against informing). Holding for one rule, forgoing `k`, stands above holding for another,
forgoing `k'`, exactly where the first's shortfall and `k` together fall below the second's and `k'`
(the amounts counted as in `threshold_go_iff`, in the units of the weighted totals): the order of
plans at two rules held for (`RevisionPlans.above_iff`, `HeldForReading.held_above_held_iff`). -/
theorem forgone_lt_iff (m : Model C) (gain loss : C → Nat) (r r' : C → Bool) (k k' : Nat) :
    m.after (shifted gain loss) (byRule r') + k < m.after (shifted gain loss) (byRule r) + k' ↔
      shortfall m gain loss r + k < shortfall m gain loss r' + k' :=
  (held_above_held_iff m gain loss r r' k k').symm.trans
    ((RevisionPlans.above_iff m.listed m.weight gain loss (RevisionPlans.splits_held m.listed m.weight r' k')
      (RevisionPlans.splits_held m.listed m.weight r k)).trans (by
        show k + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r k) <
          k' + RevisionPlans.excess m.listed gain loss (RevisionPlans.held m.weight r' k') ↔ _
        rw [excess_held, excess_held, Nat.add_comm k, Nat.add_comm k']))

/-- **Through maps, the threshold in the split's terms**: holding for a rule through one map,
forgoing `k`, stands above holding for a rule through another, forgoing `k'`, exactly where the least
shortfall, the residual and `k` together fall below the other's; with equal amounts and `π'`
refining `π`, see `refined_lt_iff`. -/
theorem forgone_through_lt_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss : C → Nat) (π : C → K) (π' : C → L) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (s : K → Bool) (s' : L → Bool) (k k' : Nat) :
    m.after (shifted gain loss) (byRule fun c => s' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => s (π c)) + k' ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + residual m gain loss π zs s + k <
        shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) +
          residual m gain loss π' zs' s' + k' :=
  (forgone_lt_iff m gain loss (fun c => s (π c)) (fun c => s' (π' c)) k k').trans (by
    rw [shortfall_split m gain loss π once covers s, shortfall_split m gain loss π' once' covers' s'])

/-- Where `a'` is at most `a`, adding `r` to `a` and `r'` to `a'` keeps a strict order exactly where
`r` with the excess of `a` over `a'` falls below `r'`. -/
theorem add_lt_iff_sub_add_lt {a a' r r' k : Nat} (le : a' ≤ a) :
    a + r + k < a' + r' + k ↔ a - a' + r < r' :=
  ⟨fun lt => (Naturals.add_lt_add_left_iff (k := a')).mp (by
      rw [← Nat.add_assoc, Becoming.add_sub_of_le le]
      exact Nat.lt_of_add_lt_add_right lt),
   fun lt => Nat.add_lt_add_right (by
      rw [← Becoming.add_sub_of_le le, Nat.add_assoc]
      exact Nat.add_lt_add_left lt a') k⟩

/-- **Two rules through a refinement, one amount forgone, compare as their residuals and the fall of
the least shortfall** (item 7, read as withholding against informing): through a map `π'` telling
apart all `π` does on the holding formation's listed candidates, both maps' cells listed once each
and covering the listing, holding for a rule through the coarser map stands above holding for a rule
through the finer, forgoing the same amount, exactly where the finer rule's residual exceeds the
coarser's by more than the least shortfall falls through the finer map (`least_falls`). -/
theorem refined_lt_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss : C → Nat) (π : C → K) (π' : C → L) (f : L → K)
    (factors : ∀ c, c ∈ m.listed → π c = f (π' c)) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (s : K → Bool) (s' : L → Bool) (k : Nat) :
    m.after (shifted gain loss) (byRule fun c => s' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => s (π c)) + k ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) -
          shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) +
        residual m gain loss π zs s < residual m gain loss π' zs' s' :=
  (forgone_through_lt_iff m gain loss π π' once covers once' covers' s s' k k).trans
    (add_lt_iff_sub_add_lt (least_falls m gain loss π π' f factors once' covers'))

/-- **Two answers agreeing in net, amounts forgone, compare as their least shortfalls with the
amounts** (item 7; read as withholding against informing where `π'` refines `π`, which is not
assumed): with the reading formation's model the holding formation's and its valuation agreeing in
net with the reference at every listed candidate of positive weight, over each map's cells listed
once each and covering the listing, holding for its answer through `π`, forgoing `k`, stands above
holding for its answer through `π'`, forgoing `k'`, exactly where the least shortfall through `π`
and `k` together fall below the least shortfall through `π'` and `k'`. -/
theorem forgone_least_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss g l : C → Nat) (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c)
    (π : C → K) (π' : C → L) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (k k' : Nat) :
    m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) + k' ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + k <
        shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) + k' :=
  (forgone_through_lt_iff m gain loss π π' once covers once' covers' (answer m g l π) (answer m g l π')
    k k').trans (by
      rw [answer_least_of_net m gain loss g l π zs net, answer_least_of_net m gain loss g l π' zs' net,
        Nat.add_zero, Nat.add_zero])

/-- **Through a refinement, the coarser answer forgoing no less never stands above the finer** (item
7; read as: withholding does not pay where informing forgoes no more): with the reading formation's
model the holding formation's and its valuation agreeing in net with the reference at every listed
candidate of positive weight, through a map `π'` telling apart all `π` does on the listed
candidates, each map's cells listed once each and covering the listing, holding for its answer
through `π`, forgoing `k`, never stands above holding for its answer through `π'`, forgoing at most
`k` (`forgone_least_iff`, `least_falls`). -/
theorem coarser_not_above {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss g l : C → Nat) (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c)
    (π : C → K) (π' : C → L) (f : L → K) (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    {k k' : Nat} (le : k' ≤ k) :
    ¬ m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) + k' :=
  fun above => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le
    ((forgone_least_iff m gain loss g l net π π' once covers once' covers' k k').mp above)
    (Nat.add_le_add (least_falls m gain loss π π' f factors once' covers') le))

end Informed

section Revalued

variable {C K : Type} [DecidableEq K]

/-- **Agreeing in net, the answer falls short by the least shortfall**: where the reading
formation's model is the holding formation's and its valuation agrees in net with the reference at
every listed candidate of positive weight, its answer through the map falls short by exactly the least
shortfall through it. -/
theorem answer_shortfall_least (m : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) :
    shortfall m gain loss (fun c => answer m g l π (π c)) =
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) :=
  (shortfall_split m gain loss π once covers (answer m g l π)).trans
    ((congrArg (shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + ·)
      (answer_least_of_net m gain loss g l π zs net)).trans (Nat.add_zero _))

/-- **Revaluing changes only the residual** (item 8): with the holding formation's model, the reading
formation's model, the reference and the map fixed, the shortfalls of two valuations' answers differ
exactly as their residuals do; the least shortfall reads only the holding formation's model, the
reference and the map. -/
theorem revalued_split (m pm : Model C) (gain loss g l g' l' : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    shortfall m gain loss (fun c => answer pm g l π (π c)) + residual m gain loss π zs (answer pm g' l' π) =
      shortfall m gain loss (fun c => answer pm g' l' π (π c)) +
        residual m gain loss π zs (answer pm g l π) :=
  (congrArg (· + residual m gain loss π zs (answer pm g' l' π))
      (shortfall_split m gain loss π once covers (answer pm g l π))).trans
    ((Nat.add_right_comm _ _ _).trans
      (congrArg (· + residual m gain loss π zs (answer pm g l π))
        (shortfall_split m gain loss π once covers (answer pm g' l' π))).symm)

/-- **By the valuation at the choice, no rule through the map stands higher than the current answer**
(item 11): with the reference the reading formation's own current valuation and its model the holding
formation's, holding for its answer through `π` stands at least as high as holding for any rule
through `π`, the answer by any other valuation with the same listing, weights and map included.
Worth before any cost of waiting or of intervening. -/
theorem own_least (m : Model C) (g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (s : K → Bool) :
    m.after (shifted g l) (byRule fun c => s (π c)) ≤
      m.after (shifted g l) (byRule fun c => answer m g l π (π c)) :=
  (after_le_iff_shortfall m g l _ _).mpr
    (Nat.le_trans (Nat.le_of_eq (answer_shortfall_least m g l g l π once covers
        fun c _ _ => Nat.add_comm (g c) (l c)))
      (least_through m g l π once covers s))

/-- **A revaluation lowers it exactly where it decides some listed cell against the current
valuation's strict weighted preference.** -/
theorem revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) <
        m.after (shifted g l) (byRule fun c => answer m g l π (π c)) ↔
      ∃ z, z ∈ zs ∧
        ((answer m g' l' π z = true ∧ offExcessWithin m g l π z < goExcessWithin m g l π z) ∨
          (answer m g' l' π z = false ∧ goExcessWithin m g l π z < offExcessWithin m g l π z)) :=
  (after_lt_iff_shortfall m g l _ _).trans (by
    rw [answer_shortfall_least m g l g l π once covers fun c _ _ => Nat.add_comm (g c) (l c),
      shortfall_split m g l π once covers (answer m g' l' π)]
    exact (lt_iff_pos rfl).trans (residual_pos_iff m g l π zs (answer m g' l' π)))

/-- **By the valuation after a revaluation, its answer has no residual** (item 12): with the
reference the revised valuation and the reading formation's model the holding formation's, the
revised answer has none through the same map. -/
theorem outcome_least (m : Model C) (g' l' : C → Nat) (π : C → K) (zs : List K) :
    residual m g' l' π zs (answer m g' l' π) = 0 :=
  answer_least_of_net m g' l' g' l' π zs fun c _ _ => Nat.add_comm (g' c) (l' c)

/-- **A gain by revaluing needs a residual, for any model of the reading formation**: where holding
for some other valuation's answer through `π` stands strictly higher by the reference than holding
for the current answer, the current answer's residual is positive. -/
theorem residual_pos_of_gains (m pm : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (gains : ∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer pm g l π (π c)) <
        m.after (shifted gain loss) (byRule fun c => answer pm g' l' π (π c))) :
    0 < residual m gain loss π zs (answer pm g l π) :=
  match gains with
  | ⟨g', l', above⟩ => Nat.pos_of_ne_zero fun zero =>
      Nat.lt_irrefl (shortfall m gain loss (fun c => leastThrough m gain loss π (π c)))
        (Nat.lt_of_le_of_lt (least_through m gain loss π once covers (answer pm g' l' π))
          (Nat.lt_of_lt_of_le ((after_lt_iff_shortfall m gain loss _ _).mp above)
            (Nat.le_of_eq ((shortfall_split m gain loss π once covers (answer pm g l π)).trans
              ((congrArg (shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + ·)
                zero).trans (Nat.add_zero _))))))

/-- **Some replacement valuation gains exactly where the current answer decides a cell against the
reference** (item 13): with the reading formation's model the holding formation's, some pair of value
functions, unrestricted, gives an answer through `π` standing strictly above the current answer by
the reference exactly where the current answer's residual is positive. Reachability under a supplied
update is not asserted; `presented_forgone_lt_iff` compares a given input presented. With the models
apart, only the forward direction holds (`residual_pos_of_gains`; `unweighted_told`). -/
theorem revaluing_gains_iff (m : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    (∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) <
        m.after (shifted gain loss) (byRule fun c => answer m g' l' π (π c))) ↔
      0 < residual m gain loss π zs (answer m g l π) :=
  ⟨residual_pos_of_gains m m gain loss g l π once covers,
   fun pos => ⟨gain, loss, (after_lt_iff_shortfall m gain loss _ _).mpr
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (answer_shortfall_least m gain loss gain loss π once covers
          fun c _ _ => Nat.add_comm (gain c) (loss c)))
        (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
          (Nat.le_of_eq (shortfall_split m gain loss π once covers (answer m g l π)).symm)))⟩⟩

/-- **Revaluing to the reference gains exactly the current answer's residual**: with the reading
formation's model the holding formation's, holding for the answer by the reference stands above
holding for the current answer by exactly the current answer's residual, and by `own_least` no
valuation's answer stands higher. -/
theorem revaluing_gain (m : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) +
        residual m gain loss π zs (answer m g l π) =
      m.after (shifted gain loss) (byRule fun c => answer m gain loss π (π c)) :=
  add_right_cancel (shortfall m gain loss (fun c => leastThrough m gain loss π (π c)))
    (calc m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) +
            residual m gain loss π zs (answer m g l π) +
            shortfall m gain loss (fun c => leastThrough m gain loss π (π c))
        = m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) +
            shortfall m gain loss (fun c => answer m g l π (π c)) := by
            rw [shortfall_split m gain loss π once covers (answer m g l π), Nat.add_assoc,
              Nat.add_comm (residual m gain loss π zs (answer m g l π))]
      _ = m.after (shifted gain loss) (byRule fun c => answer m gain loss π (π c)) +
            shortfall m gain loss (fun c => answer m gain loss π (π c)) :=
          (after_add_shortfall m gain loss _).trans (after_add_shortfall m gain loss _).symm
      _ = m.after (shifted gain loss) (byRule fun c => answer m gain loss π (π c)) +
            shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) := by
            rw [answer_shortfall_least m gain loss gain loss π once covers
              fun c _ _ => Nat.add_comm (gain c) (loss c)])

/-- **Revaluing at a cost, exactly**: with the holding formation's model, the reading formation's
model, the reference and the map fixed, holding for the answer by `(g', l')`, forgoing `k'`, stands
above holding for the answer by `(g, l)`, forgoing `k`, exactly where the first answer's residual and
`k'` together fall below the second's and `k` (the amounts in the units of the weighted totals). -/
theorem revalued_forgone_lt_iff (m pm : Model C) (gain loss g l g' l' : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) (k k' : Nat) :
    m.after (shifted gain loss) (byRule fun c => answer pm g l π (π c)) + k' <
        m.after (shifted gain loss) (byRule fun c => answer pm g' l' π (π c)) + k ↔
      residual m gain loss π zs (answer pm g' l' π) + k' <
        residual m gain loss π zs (answer pm g l π) + k :=
  (forgone_through_lt_iff m gain loss π π once covers once covers (answer pm g' l' π) (answer pm g l π)
    k' k).trans (by
      rw [Nat.add_assoc, Nat.add_assoc]
      exact Naturals.add_lt_add_left_iff)

end Revalued

section Constant

variable {C : Type}

/-- **Forgoing an amount, holding for an answer telling nothing stands strictly below committing to
the move it gives exactly where the amount is positive** (item 15). -/
theorem const_below_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (b : Bool)
    (const : ∀ c, c ∈ m.listed → r c = b) (k : Nat) :
    m.after (shifted gain loss) (byRule r) < m.committed (shifted gain loss) (cond b .off .go) + k ↔
      0 < k := by
  rw [const_worth m gain loss r b const]
  exact lt_iff_pos rfl

/-- **The answer through a map with one cell is worth one move.** -/
theorem one_cell_worth (m pm : Model C) (gain loss g l : C → Nat) :
    m.after (shifted gain loss) (byRule fun _ => answer pm g l (fun _ : C => ()) ()) =
      m.committed (shifted gain loss) (cond (answer pm g l (fun _ : C => ()) ()) .off .go) :=
  const_worth m gain loss _ _ fun _ _ => rfl

end Constant

/-! ### Over every refinement -/

section Refining

variable {C : Type}

/-- The weighted total of an amount over the candidates a model lists in a set: `HeldForReading`'s
`offPart` of the weighted amount. -/
def weightedOn (pm : Model C) (B : C → Bool) (f : C → Nat) : Nat :=
  offPart pm B fun c => pm.weight c * f c

/-- **Splits keep the worth**: for every two disjoint sets of candidates, tested by Boolean
functions, the first of which the reading formation's weighted values release (going on at least
switching off over it) and the second of which they stop (going on below switching off over it):
where they release the two together, the reference's weighted gain over the second is at most its
weighted loss there; where they stop the two together, the reference's weighted gain over the first is
at least its weighted loss there. -/
def SplitsKeep (m pm : Model C) (gain loss g l : C → Nat) : Prop :=
  ∀ B D : C → Bool, (∀ c, B c = true → D c = false) →
    weightedOn pm B l ≤ weightedOn pm B g → weightedOn pm D g < weightedOn pm D l →
      (weightedOn pm B l + weightedOn pm D l ≤ weightedOn pm B g + weightedOn pm D g →
          weightedOn m D gain ≤ weightedOn m D loss) ∧
        (weightedOn pm B g + weightedOn pm D g < weightedOn pm B l + weightedOn pm D l →
          weightedOn m B loss ≤ weightedOn m B gain)

/-- Holding for a rule totals the weighted loss where it stops and the weighted gain elsewhere. -/
theorem after_rule_total (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) =
      total m.listed fun c => cond (r c) (m.weight c * loss c) (m.weight c * gain c) :=
  total_congr (held_term m gain loss r) m.listed

/-- Regrouped by cells, a total decided through a map is the total of each cell's decided total. -/
theorem total_cond_by_cells {K : Type} [DecidableEq K] (m : Model C) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (s : K → Bool) (x y : C → Nat) :
    total m.listed (fun c => cond (s (π c)) (x c) (y c)) =
      total zs fun z => cond (s z) (total m.listed fun c => if π c = z then x c else 0)
        (total m.listed fun c => if π c = z then y c else 0) :=
  (total_by_cells m π once covers (fun c => cond (s (π c)) (x c) (y c))).trans
    (total_congr (fun z =>
      (total_congr (p := fun c => if π c = z then cond (s (π c)) (x c) (y c) else 0)
        (q := fun c => cond (s z) (if π c = z then x c else 0) (if π c = z then y c else 0))
        (fun _ => cell_term s _ _) m.listed).trans (total_cond_both (s z) _ _ m.listed)) zs)

/-- Within a cell, an amount is its part where a rule releases plus its part where it stops. -/
theorem ite_split_rule (p : Prop) [Decidable p] (b : Bool) (v : Nat) :
    (if p then v else 0) = cond (decide p && !b) v 0 + cond (decide p && b) v 0 :=
  if h : p then by
    rw [if_pos h, decide_eq_true h]
    cases b with
    | true => exact (Nat.zero_add v).symm
    | false => rfl
  else (if_neg h).trans
    (congrArg (fun d => cond (d && !b) v 0 + cond (d && b) v 0) (decide_eq_false h)).symm

/-- Within a cell, an amount decided by a rule is its stopped part plus its released part. -/
theorem ite_cond_split (p : Prop) [Decidable p] (b : Bool) (x y : Nat) :
    (if p then cond b x y else 0) = cond (decide p && b) x 0 + cond (decide p && !b) y 0 :=
  if h : p then by
    rw [if_pos h, decide_eq_true h]
    cases b with
    | true => rfl
    | false => exact (Nat.zero_add y).symm
  else (if_neg h).trans
    (congrArg (fun d => cond (d && b) x 0 + cond (d && !b) y 0) (decide_eq_false h)).symm

/-- A weighted total within a cell is its total where a rule releases plus that where it stops (the
law of total weight, as `ConditionalWeights.mass_split`, in `total`'s form). -/
theorem within_split {K : Type} [DecidableEq K] (pm : Model C) (π : C → K) (t : C → Bool)
    (h : C → Nat) (z : K) :
    within pm π h z = weightedOn pm (fun c => decide (π c = z) && !t c) h +
      weightedOn pm (fun c => decide (π c = z) && t c) h :=
  (total_congr (fun c => ite_split_rule (π c = z) (t c) (pm.weight c * h c)) pm.listed).trans
    (total_add _ _ pm.listed)

/-- Within a cell, a total decided by a rule is its stopped part plus its released part. -/
theorem within_rule_split {K : Type} [DecidableEq K] (m : Model C) (π : C → K) (t : C → Bool)
    (x y : C → Nat) (z : K) :
    (total m.listed fun c =>
        if π c = z then cond (t c) (m.weight c * x c) (m.weight c * y c) else 0) =
      weightedOn m (fun c => decide (π c = z) && t c) x +
        weightedOn m (fun c => decide (π c = z) && !t c) y :=
  (total_congr (fun c => ite_cond_split (π c = z) (t c) (m.weight c * x c) (m.weight c * y c))
    m.listed).trans (total_add _ _ m.listed)

/-- A weighted total over a set of whole cells on the listing is the total of their totals. -/
theorem weightedOn_by_cells {L : Type} [DecidableEq L] (pm : Model C) (π' : C → L) {zs' : List L}
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ pm.listed → π' c ∈ zs')
    {B : C → Bool} {t : L → Bool} (through : ∀ c, c ∈ pm.listed → B c = t (π' c)) (h : C → Nat) :
    weightedOn pm B h = total zs' fun y => cond (t y) (within pm π' h y) 0 :=
  (total_congr_on (g := fun c => cond (t (π' c)) (pm.weight c * h c) 0) fun c mem =>
      congrArg (fun b => cond b (pm.weight c * h c) 0) (through c mem)).trans
    ((total_cond_by_cells pm π' once' covers' t (fun c => pm.weight c * h c) (fun _ => 0)).trans
      (total_congr (fun y => congrArg (cond (t y) (within pm π' h y))
        (total_eq_zero fun _ _ => ite_self 0)) zs'))

/-- A total at most another term by term, and below it at one member, is below it (as `Loops.total_lt`,
outside this module's imports). -/
theorem total_lt_of_mem {α : Type} {p q : α → Nat} {a : α} :
    ∀ {as : List α}, (∀ b, b ∈ as → p b ≤ q b) → a ∈ as → p a < q a → total as p < total as q
  | _ :: as, le, .head _, lt =>
    Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _)
      (Nat.add_le_add_left (total_le as fun b mem => le b (.tail _ mem)) _)
  | b :: _, le, .tail _ mem, lt =>
    Nat.lt_of_le_of_lt (Nat.add_le_add_right (le b (.head _)) _)
      (Nat.add_lt_add_left (total_lt_of_mem (fun b' mem' => le b' (.tail _ mem')) mem lt) _)

/-- Deciding a whole cell is worth at most splitting it, where the part the split moves gains. -/
theorem split_cell_le {BL DL BG DG : Nat} : ∀ {b : Bool}, (b = false → DG ≤ DL) →
    (b = true → BL ≤ BG) → cond b (BL + DL) (BG + DG) ≤ DL + BG
  | true, _, le =>
    Nat.le_trans (Nat.le_of_eq (Nat.add_comm BL DL)) (Nat.add_le_add_left (le rfl) DL)
  | false, le, _ =>
    Nat.le_trans (Nat.add_le_add_left (le rfl) BG) (Nat.le_of_eq (Nat.add_comm BG DL))

/-- At one coarse cell, where splits keep the worth, holding for the finer answer stands as high. -/
theorem cell_refined_le {K L : Type} [DecidableEq K] [DecidableEq L] (m pm : Model C)
    (gain loss g l : C → Nat) (keep : SplitsKeep m pm gain loss g l) (π : C → K) (π' : C → L)
    (f : L → K) {zs' : List L} (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    (factors_pm : ∀ c, c ∈ pm.listed → π c = f (π' c))
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (covers'_pm : ∀ c, c ∈ pm.listed → π' c ∈ zs') (z : K) :
    cond (answer pm g l π z) (within m π loss z) (within m π gain z) ≤
      total m.listed fun c => if π c = z then
        cond (answer pm g l π' (π' c)) (m.weight c * loss c) (m.weight c * gain c) else 0 :=
  -- the cell's candidates the finer answer releases, and those it stops, as sets of fine cells
  have released_cells := fun h => weightedOn_by_cells pm π' once' covers'_pm
    (B := fun c => decide (π c = z) && !answer pm g l π' (π' c))
    (t := fun y => decide (f y = z) && !answer pm g l π' y)
    (fun c mem => congrArg (fun k => decide (k = z) && !answer pm g l π' (π' c))
      (factors_pm c mem)) h
  have stopped_cells := fun h => weightedOn_by_cells pm π' once' covers'_pm
    (B := fun c => decide (π c = z) && answer pm g l π' (π' c))
    (t := fun y => decide (f y = z) && answer pm g l π' y)
    (fun c mem => congrArg (fun k => decide (k = z) && answer pm g l π' (π' c))
      (factors_pm c mem)) h
  -- over the part released, the reading's value of switching off is at most that of going on
  have released_le : weightedOn pm (fun c => decide (π c = z) && !answer pm g l π' (π' c)) l ≤
      weightedOn pm (fun c => decide (π c = z) && !answer pm g l π' (π' c)) g :=
    Nat.le_trans (Nat.le_of_eq (released_cells l))
      (Nat.le_trans (total_le zs' fun y _ => ListTests.cond_zero_le fun yes => Nat.ge_of_not_lt
          ((answer_false_iff pm g l π' y).mp (ListTests.false_of_not (ListTests.and_right yes))))
        (Nat.le_of_eq (released_cells g).symm))
  -- over the part stopped, it is below where a candidate the holding formation lists is stopped
  have stopped_lt : ∀ c, c ∈ m.listed → π c = z → answer pm g l π' (π' c) = true →
      weightedOn pm (fun c => decide (π c = z) && answer pm g l π' (π' c)) g <
        weightedOn pm (fun c => decide (π c = z) && answer pm g l π' (π' c)) l :=
    fun c mem at_z stops =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq (stopped_cells g))
        (Nat.lt_of_lt_of_le
          (total_lt_of_mem (fun y _ => ListTests.cond_zero_le fun yes =>
              Nat.le_of_lt ((answer_true_iff pm g l π' y).mp (ListTests.and_right yes)))
            (covers' c mem)
            (show cond (decide (f (π' c) = z) && answer pm g l π' (π' c))
                  (within pm π' g (π' c)) 0 <
                cond (decide (f (π' c) = z) && answer pm g l π' (π' c))
                  (within pm π' l (π' c)) 0 by
              rw [decide_eq_true ((factors c mem).symm.trans at_z), stops]
              exact (answer_true_iff pm g l π' (π' c)).mp stops))
          (Nat.le_of_eq (stopped_cells l).symm))
  have apart : ∀ c, (decide (π c = z) && !answer pm g l π' (π' c)) = true →
      (decide (π c = z) && answer pm g l π' (π' c)) = false := fun c yes =>
    (congrArg (decide (π c = z) && ·) (ListTests.false_of_not (ListTests.and_right yes))).trans
      (Bool.and_false _)
  have split_pm := fun h => within_split pm π (fun c => answer pm g l π' (π' c)) h z
  have split_m := fun h => within_split m π (fun c => answer pm g l π' (π' c)) h z
  Nat.le_trans
    (Nat.le_of_eq ((congrArg (cond (answer pm g l π z) · (within m π gain z)) (split_m loss)).trans
      (congrArg (cond (answer pm g l π z) _ ·) (split_m gain))))
    (Nat.le_trans
      (split_cell_le (b := answer pm g l π z)
        (fun releases =>
          if lt : weightedOn pm (fun c => decide (π c = z) && answer pm g l π' (π' c)) g <
              weightedOn pm (fun c => decide (π c = z) && answer pm g l π' (π' c)) l then
            (keep _ _ apart released_le lt).1
              (Nat.le_trans (Nat.le_of_eq (split_pm l).symm)
                (Nat.le_trans (Nat.ge_of_not_lt ((answer_false_iff pm g l π z).mp releases))
                  (Nat.le_of_eq (split_pm g))))
          else
            -- no candidate the holding formation lists in the cell is stopped
            Nat.le_trans (Nat.le_of_eq (total_eq_zero fun c mem =>
                congrArg (fun b => cond b (m.weight c * gain c) 0)
                  (ListTests.false_of_not_true fun on => lt (stopped_lt c mem
                    (of_decide_eq_true (ListTests.and_left on)) (ListTests.and_right on)))))
              (Nat.zero_le _))
        (fun stops =>
          have sum_lt := Nat.lt_of_le_of_lt (Nat.le_of_eq (split_pm g).symm)
            (Nat.lt_of_lt_of_le ((answer_true_iff pm g l π z).mp stops) (Nat.le_of_eq (split_pm l)))
          (keep _ _ apart released_le (Nat.gt_of_not_le fun le => Nat.lt_irrefl _
            (Nat.lt_of_lt_of_le sum_lt (Nat.add_le_add released_le le)))).2 sum_lt))
      (Nat.le_of_eq (within_rule_split m π (fun c => answer pm g l π' (π' c)) loss gain z).symm))

/-- Where splits keep the worth, holding for the answer through a refinement stands as high. -/
theorem refined_le_of_splitsKeep {K L : Type} [DecidableEq K] [DecidableEq L] (m pm : Model C)
    (gain loss g l : C → Nat) (keep : SplitsKeep m pm gain loss g l) (π : C → K) (π' : C → L)
    (f : L → K) {zs : List K} {zs' : List L} (factors : ∀ c, c ∈ m.listed → π c = f (π' c))
    (factors_pm : ∀ c, c ∈ pm.listed → π c = f (π' c))
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (covers'_pm : ∀ c, c ∈ pm.listed → π' c ∈ zs') :
    m.after (shifted gain loss) (byRule fun c => answer pm g l π (π c)) ≤
      m.after (shifted gain loss) (byRule fun c => answer pm g l π' (π' c)) :=
  Nat.le_trans
    (Nat.le_of_eq ((after_rule_total m gain loss _).trans (total_cond_by_cells m π once covers
      (answer pm g l π) (fun c => m.weight c * loss c) (fun c => m.weight c * gain c))))
    (Nat.le_trans
      (total_le zs fun z _ => cell_refined_le m pm gain loss g l keep π π' f factors factors_pm
        once' covers' covers'_pm z)
      (Nat.le_of_eq
        ((after_rule_total m gain loss _).trans (total_by_cells m π once covers _)).symm))

/-- The cells telling whether a candidate is in either of two sets: `0` if so, `1` if not. -/
def eitherCell (B D : C → Bool) (c : C) : Nat := cond (B c || D c) 0 1

/-- The cells telling which of two sets a candidate is in: `0` the first, `1` the second only, `2`
neither. -/
def whichCell (B D : C → Bool) (c : C) : Nat := cond (B c) 0 (cond (D c) 1 2)

/-- Whether in either set is which set, less one. -/
theorem either_which : ∀ bB bD : Bool, cond (bB || bD) 0 1 = cond bB 0 (cond bD 1 2) - 1
  | true, _ => rfl
  | false, true => rfl
  | false, false => rfl

/-- The cells telling whether in either set are among `[0, 1]`. -/
theorem either_mem : ∀ bB bD : Bool, cond (bB || bD) 0 1 ∈ [0, 1]
  | true, _ => .head _
  | false, true => .head _
  | false, false => .tail _ (.head _)

/-- The cells telling which set are among `[0, 1, 2]`. -/
theorem which_mem : ∀ bB bD : Bool, cond bB 0 (cond bD 1 2) ∈ [0, 1, 2]
  | true, _ => .head _
  | false, true => .tail _ (.head _)
  | false, false => .tail _ (.tail _ (.head _))

/-- The first cell telling which set holds an amount exactly in the first set. -/
theorem which_first (v : Nat) :
    ∀ bB bD : Bool, (if cond bB 0 (cond bD 1 2) = 0 then v else 0) = cond bB v 0
  | true, _ => rfl
  | false, true => rfl
  | false, false => rfl

/-- The second cell telling which set holds an amount exactly in the second, the sets disjoint. -/
theorem which_second (v : Nat) : ∀ bB bD : Bool, (bB = true → bD = false) →
    (if cond bB 0 (cond bD 1 2) = 1 then v else 0) = cond bD v 0
  | true, true, apart => absurd (apart rfl) fun no => nomatch no
  | true, false, _ => rfl
  | false, true, _ => rfl
  | false, false, _ => rfl

/-- The cell of either set holds an amount in the first set and in the second, the sets disjoint. -/
theorem either_both (v : Nat) : ∀ bB bD : Bool, (bB = true → bD = false) →
    (if cond (bB || bD) 0 1 = 0 then v else 0) = cond bB v 0 + cond bD v 0
  | true, true, apart => absurd (apart rfl) fun no => nomatch no
  | true, false, _ => rfl
  | false, true, _ => (Nat.zero_add v).symm
  | false, false, _ => rfl

/-- Outside both sets, the last cells of the two maps hold the same amount. -/
theorem either_neither (v : Nat) : ∀ bB bD : Bool,
    (if cond (bB || bD) 0 1 = 1 then v else 0) = (if cond bB 0 (cond bD 1 2) = 2 then v else 0)
  | true, _ => rfl
  | false, true => rfl
  | false, false => rfl

/-- One candidate's term of `worth_split_released`. -/
theorem split_released_term {s t : Nat → Bool} (s0 : s 0 = false) (t0 : t 0 = false)
    (t1 : t 1 = true) (same : s 1 = t 2) (x y : Nat) : ∀ bB bD : Bool, (bB = true → bD = false) →
      cond (t (cond bB 0 (cond bD 1 2))) x y + cond bD y 0 =
        cond (s (cond (bB || bD) 0 1)) x y + cond bD x 0
  | true, true, apart => absurd (apart rfl) fun no => nomatch no
  | true, false, _ => by
    show cond (t 0) x y + 0 = cond (s 0) x y + 0
    rw [t0, s0]
  | false, true, _ => by
    show cond (t 1) x y + y = cond (s 0) x y + x
    rw [t1, s0]
    exact Nat.add_comm x y
  | false, false, _ => by
    show cond (t 2) x y + 0 = cond (s 1) x y + 0
    rw [same]

/-- One candidate's term of `worth_split_stopped`. -/
theorem split_stopped_term {s t : Nat → Bool} (s0 : s 0 = true) (t0 : t 0 = false)
    (t1 : t 1 = true) (same : s 1 = t 2) (x y : Nat) : ∀ bB bD : Bool, (bB = true → bD = false) →
      cond (t (cond bB 0 (cond bD 1 2))) x y + cond bB x 0 =
        cond (s (cond (bB || bD) 0 1)) x y + cond bB y 0
  | true, true, apart => absurd (apart rfl) fun no => nomatch no
  | true, false, _ => by
    show cond (t 0) x y + x = cond (s 0) x y + y
    rw [t0, s0]
    exact Nat.add_comm y x
  | false, true, _ => by
    show cond (t 1) x y + 0 = cond (s 0) x y + 0
    rw [t1, s0]
  | false, false, _ => by
    show cond (t 2) x y + 0 = cond (s 1) x y + 0
    rw [same]

/-- Coarse releasing both sets: the fine worth and the second's gain are the coarse and its loss. -/
theorem worth_split_released (m : Model C) (gain loss : C → Nat) {B D : C → Bool}
    (apart : ∀ c, B c = true → D c = false) {s t : Nat → Bool} (s0 : s 0 = false)
    (t0 : t 0 = false) (t1 : t 1 = true) (same : s 1 = t 2) :
    m.after (shifted gain loss) (byRule fun c => t (whichCell B D c)) + weightedOn m D gain =
      m.after (shifted gain loss) (byRule fun c => s (eitherCell B D c)) + weightedOn m D loss :=
  (congrArg (· + weightedOn m D gain) (after_rule_total m gain loss _)).trans
    ((total_add _ _ m.listed).symm.trans
      ((total_congr (fun c => split_released_term s0 t0 t1 same (m.weight c * loss c)
          (m.weight c * gain c) (B c) (D c) (apart c)) m.listed).trans
        ((total_add _ _ m.listed).trans
          (congrArg (· + weightedOn m D loss) (after_rule_total m gain loss _).symm))))

/-- Coarse stopping both sets: the fine worth and the first's loss are the coarse and its gain. -/
theorem worth_split_stopped (m : Model C) (gain loss : C → Nat) {B D : C → Bool}
    (apart : ∀ c, B c = true → D c = false) {s t : Nat → Bool} (s0 : s 0 = true)
    (t0 : t 0 = false) (t1 : t 1 = true) (same : s 1 = t 2) :
    m.after (shifted gain loss) (byRule fun c => t (whichCell B D c)) + weightedOn m B loss =
      m.after (shifted gain loss) (byRule fun c => s (eitherCell B D c)) + weightedOn m B gain :=
  (congrArg (· + weightedOn m B loss) (after_rule_total m gain loss _)).trans
    ((total_add _ _ m.listed).symm.trans
      ((total_congr (fun c => split_stopped_term s0 t0 t1 same (m.weight c * loss c)
          (m.weight c * gain c) (B c) (D c) (apart c)) m.listed).trans
        ((total_add _ _ m.listed).trans
          (congrArg (· + weightedOn m B gain) (after_rule_total m gain loss _).symm))))

/-- Where refining never lowers the worth, splits keep it: refine whether in either set to which. -/
theorem splitsKeep_of_refined_le (m pm : Model C) (gain loss g l : C → Nat)
    (all : ∀ (K L : Type) [DecidableEq K] [DecidableEq L] (π : C → K) (π' : C → L) (f : L → K)
        (zs : List K) (zs' : List L),
        (∀ c, c ∈ m.listed → π c = f (π' c)) → (∀ c, c ∈ pm.listed → π c = f (π' c)) →
        List.Pairwise (fun a b => a ≠ b) zs → (∀ c, c ∈ m.listed → π c ∈ zs) →
        List.Pairwise (fun a b => a ≠ b) zs' → (∀ c, c ∈ m.listed → π' c ∈ zs') →
        (∀ c, c ∈ pm.listed → π' c ∈ zs') →
        m.after (shifted gain loss) (byRule fun c => answer pm g l π (π c)) ≤
          m.after (shifted gain loss) (byRule fun c => answer pm g l π' (π' c))) :
    SplitsKeep m pm gain loss g l := fun B D apart released stopped =>
  have le := all Nat Nat (eitherCell B D) (whichCell B D) (fun n => n - 1) [0, 1] [0, 1, 2]
    (fun c _ => either_which (B c) (D c)) (fun c _ => either_which (B c) (D c)) (by decide)
    (fun c _ => either_mem (B c) (D c)) (by decide) (fun c _ => which_mem (B c) (D c))
    (fun c _ => which_mem (B c) (D c))
  have first : ∀ h, within pm (whichCell B D) h 0 = weightedOn pm B h := fun h =>
    total_congr (fun c => which_first (pm.weight c * h c) (B c) (D c)) pm.listed
  have second : ∀ h, within pm (whichCell B D) h 1 = weightedOn pm D h := fun h =>
    total_congr (fun c => which_second (pm.weight c * h c) (B c) (D c) (apart c)) pm.listed
  have both : ∀ h, within pm (eitherCell B D) h 0 = weightedOn pm B h + weightedOn pm D h :=
    fun h => (total_congr (fun c => either_both (pm.weight c * h c) (B c) (D c) (apart c))
      pm.listed).trans (total_add _ _ pm.listed)
  have neither : ∀ h, within pm (eitherCell B D) h 1 = within pm (whichCell B D) h 2 := fun h =>
    total_congr (fun c => either_neither (pm.weight c * h c) (B c) (D c)) pm.listed
  -- the finer answer releases the first set and stops the second; outside both, the answers agree
  have t0 : answer pm g l (whichCell B D) 0 = false := decide_eq_false fun lt =>
    Nat.lt_irrefl _ (Nat.lt_of_le_of_lt released (Nat.lt_of_le_of_lt (Nat.le_of_eq (first g).symm)
      (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (first l)))))
  have t1 : answer pm g l (whichCell B D) 1 = true := decide_eq_true
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (second g))
      (Nat.lt_of_lt_of_le stopped (Nat.le_of_eq (second l).symm)))
  have same : answer pm g l (eitherCell B D) 1 = answer pm g l (whichCell B D) 2 :=
    (congrArg (fun a => decide (a < within pm (eitherCell B D) l 1)) (neither g)).trans
      (congrArg (fun b => decide (within pm (whichCell B D) g 2 < b)) (neither l))
  ⟨fun sum_le => (across_le_iff (k := 0) (worth_split_released m gain loss apart
      (s := answer pm g l (eitherCell B D)) (t := answer pm g l (whichCell B D))
      (decide_eq_false fun lt => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt
        (Nat.le_of_eq (both g).symm) (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (both l)))) sum_le))
      t0 t1 same)).mp le,
   fun sum_lt => (across_le_iff (k := 0) (worth_split_stopped m gain loss apart
      (s := answer pm g l (eitherCell B D)) (t := answer pm g l (whichCell B D))
      (decide_eq_true (Nat.lt_of_le_of_lt (Nat.le_of_eq (both g))
        (Nat.lt_of_lt_of_le sum_lt (Nat.le_of_eq (both l).symm)))) t0 t1 same)).mp le⟩

/-- **Splits keep the worth with a shared model and agreement in net**: then refining never lowers
the worth of holding for the answer (`informed_answer_le`). -/
theorem splitsKeep_of_net (m : Model C) (gain loss g l : C → Nat)
    (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) :
    SplitsKeep m m gain loss g l :=
  splitsKeep_of_refined_le m m gain loss g l
    fun _ _ _ _ π π' f _ _ factors _ _ _ once' covers' _ =>
      informed_answer_le m gain loss g l net π π' f factors once' covers' (answer m g l π)

/-- **Splits keep the worth where the reading formation stops no set**: where its value of switching
off is nowhere above that of going on at a candidate it lists, whatever the reference. -/
theorem splitsKeep_of_off_le_go (m pm : Model C) (gain loss g l : C → Nat)
    (never : ∀ c, c ∈ pm.listed → l c ≤ g c) : SplitsKeep m pm gain loss g l :=
  fun _ D _ _ stopped => absurd stopped fun lt => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le lt
    (total_le pm.listed fun c mem => ListTests.cond_zero_le (b := D c) fun _ =>
      Nat.mul_le_mul_left (pm.weight c) (never c mem)))

/-- **Over every refinement, the exact criterion** (the design review's finding 17): over every pair
of maps, the coarser factoring through the finer on both models' listings, with the coarser map's
cells listed once each and covering the holding formation's listing and the finer map's covering
both listings, holding for the answer through the finer map never stands lower exactly where splits
keep the worth. One refinement per pair of sets decides it: whether a candidate is in either set,
refined to which (`splitsKeep_of_refined_le`). The factoring on the reading formation's listing is
needed: a candidate it alone lists can turn its answer at a cell the holding formation weighs. A
criterion of monotonicity under refinement, not of agreement with the reference: it holds wherever
the reading formation's value of switching off is nowhere above that of going on
(`splitsKeep_of_off_le_go`). -/
theorem refining_never_lowers_iff (m pm : Model C) (gain loss g l : C → Nat) :
    (∀ (K L : Type) [DecidableEq K] [DecidableEq L] (π : C → K) (π' : C → L) (f : L → K)
        (zs : List K) (zs' : List L),
        (∀ c, c ∈ m.listed → π c = f (π' c)) → (∀ c, c ∈ pm.listed → π c = f (π' c)) →
        List.Pairwise (fun a b => a ≠ b) zs → (∀ c, c ∈ m.listed → π c ∈ zs) →
        List.Pairwise (fun a b => a ≠ b) zs' → (∀ c, c ∈ m.listed → π' c ∈ zs') →
        (∀ c, c ∈ pm.listed → π' c ∈ zs') →
        m.after (shifted gain loss) (byRule fun c => answer pm g l π (π c)) ≤
          m.after (shifted gain loss) (byRule fun c => answer pm g l π' (π' c))) ↔
      SplitsKeep m pm gain loss g l :=
  ⟨splitsKeep_of_refined_le m pm gain loss g l,
   fun keep _ _ _ _ π π' f _ _ factors factors_pm once covers once' covers' covers'_pm =>
    refined_le_of_splitsKeep m pm gain loss g l keep π π' f factors factors_pm once covers once'
      covers' covers'_pm⟩

end Refining

/-! ### Part 1's witnesses -/

/-- **Scales differing by candidate do not suffice** (item 3's witness): two candidates of weight one
in one cell; by the reference, going on gains 1 and switching off saves nothing at the first, going
on gains nothing and switching off saves 2 at the second. The reading formation values going on 10
and switching off nothing at the first (the reference on the scale `q = 1`, `p = 10` there) and going
on nothing and switching off 2 at the second (the scale `p = q = 1` there): it releases the cell,
whose strict preference is to stop, and its residual is 1. -/
theorem scales_by_candidate :
    (∀ c : Bool, 1 * cond c 0 10 + cond c 1 10 * cond c 2 0 = 1 * cond c 2 0 + cond c 1 10 * cond c 0 1) ∧
      answer (⟨[false, true], fun _ => 1⟩ : Model Bool) (fun c => cond c 0 10) (fun c => cond c 2 0)
        (fun _ => ()) () = false ∧
      residual ⟨[false, true], fun _ => 1⟩ (fun c => cond c 0 1) (fun c => cond c 2 0) (fun _ => ()) [()]
        (answer ⟨[false, true], fun _ => 1⟩ (fun c => cond c 0 10) (fun c => cond c 2 0) (fun _ => ())) = 1 :=
  ⟨fun c => match c with
    | true => rfl
    | false => rfl, rfl, rfl⟩

/-- **Told the candidate, an unweighted candidate is released** (item 4's witness): one candidate of
holding weight one, gain nothing and loss one, listed by the reading formation with weight nothing
and the same values: told the candidate, the answer releases it whatever the reading formation's
valuation, its residual is one, and holding for it falls short by one. With the models apart, a
positive residual need not be removable by any revaluation. -/
theorem unweighted_told :
    (∀ g l : Unit → Nat, answer (⟨[()], fun _ => 0⟩ : Model Unit) g l id () = false) ∧
      residual ⟨[()], fun _ => 1⟩ (fun _ => 0) (fun _ => 1) id [()]
        (answer (⟨[()], fun _ => 0⟩ : Model Unit) (fun _ => 0) (fun _ => 1) id) = 1 ∧
      shortfall ⟨[()], fun _ => 1⟩ (fun _ => 0) (fun _ => 1)
        (fun c => answer (⟨[()], fun _ => 0⟩ : Model Unit) (fun _ => 0) (fun _ => 1) id (id c)) = 1 :=
  have zero : ∀ f : Unit → Nat, within (⟨[()], fun _ => 0⟩ : Model Unit) id f () = 0 := fun f =>
    show (if id () = () then 0 * f () else 0) + 0 = 0 by rw [if_pos rfl, Nat.zero_mul]
  ⟨fun g l => decide_eq_false fun lt => Nat.lt_irrefl 0 (by
    rw [zero g, zero l] at lt
    exact lt), rfl, rfl⟩

/-- **The criterion holds where the answer has a residual** (plan item 6's remark): one candidate,
going on gaining nothing and switching off saving 1 by the reference, the reading formation valuing
going on 1 and switching off nothing. Splits keep the worth, since it stops no set
(`splitsKeep_of_off_le_go`), yet its answer releases and has residual 1. -/
theorem release_keeps :
    SplitsKeep (⟨[()], fun _ => 1⟩ : Model Unit) ⟨[()], fun _ => 1⟩ (fun _ => 0) (fun _ => 1)
        (fun _ => 1) (fun _ => 0) ∧
      residual (⟨[()], fun _ => 1⟩ : Model Unit) (fun _ => 0) (fun _ => 1) (fun _ => ()) [()]
        (answer ⟨[()], fun _ => 1⟩ (fun _ => 1) (fun _ => 0) (fun _ => ())) = 1 :=
  ⟨splitsKeep_of_off_le_go _ _ _ _ _ _ fun _ _ => Nat.zero_le 1, rfl⟩

namespace Informing

/-- Two candidates of weight one. -/
def model : Model Bool := ⟨[false, true], fun _ => 1⟩

/-- By the reference, going on gains nothing at the first candidate and 1 at the second. -/
def gain (c : Bool) : Nat := cond c 1 0

/-- By the reference, switching off saves 10 at the first candidate and nothing at the second. -/
def loss (c : Bool) : Nat := cond c 0 10

/-- The reading formation's value of going on: 2 at the first candidate, nothing at the second. -/
def goValue (c : Bool) : Nat := cond c 0 2

/-- Its value of switching off: nothing at the first candidate, 5 at the second. -/
def offValue (c : Bool) : Nat := cond c 5 0

/-- **Where the valuation differs, informing can lower the worth below both moves** (item 9). Told
nothing (one cell), the answer stops everywhere: holding for it is worth 10, as switching off, its
shortfall 1, its residual nothing. Told the candidate, it releases at the first and stops at the
second: worth nothing, below going on (1) and switching off (10), its shortfall 11, all residual. -/
theorem informing_lowers :
    model.after (shifted gain loss) (byRule fun _ => answer model goValue offValue (fun _ => ()) ()) = 10 ∧
      shortfall model gain loss (fun _ => answer model goValue offValue (fun _ => ()) ()) = 1 ∧
      residual model gain loss (fun _ => ()) [()] (answer model goValue offValue (fun _ => ())) = 0 ∧
      model.after (shifted gain loss) (byRule fun c => answer model goValue offValue id c) = 0 ∧
      shortfall model gain loss (fun c => answer model goValue offValue id c) = 11 ∧
      residual model gain loss id [false, true] (answer model goValue offValue id) = 11 ∧
      model.committed (shifted gain loss) .go = 1 ∧ model.committed (shifted gain loss) .off = 10 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Informing

namespace WeightsApart

/-- The holding formation's model: the candidates 0, 1 and 2, weighted 2, 1 and 1. -/
def holding : Model Nat := ⟨[0, 1, 2], fun c => if c = 0 then 2 else 1⟩

/-- The reading formation's model: the same candidates weighted 1, 2 and 2. -/
def reading : Model Nat := ⟨[0, 1, 2], fun c => if c = 0 then 1 else 2⟩

/-- Going on gains 1, nothing and 1. -/
def gain (c : Nat) : Nat := if c = 1 then 0 else 1

/-- Switching off saves nothing, 1 and nothing. -/
def loss (c : Nat) : Nat := if c = 1 then 1 else 0

/-- **A shared valuation without shared weights does not keep informing from lowering it** (item
10): the reference and the reading formation's valuation both the gain and loss above, all weights
positive; holding for the answer is worth 3 through one cell, 2 through the cells of the first two
candidates and of the third, and 4 through the identity map. -/
theorem weights_matter :
    holding.after (shifted gain loss) (byRule fun _ => answer reading gain loss (fun _ => ()) ()) = 3 ∧
      holding.after (shifted gain loss)
        (byRule fun c => answer reading gain loss (fun c : Nat => decide (c = 2)) (decide (c = 2))) = 2 ∧
      holding.after (shifted gain loss) (byRule fun c => answer reading gain loss id c) = 4 :=
  ⟨rfl, rfl, rfl⟩

/-- **A finer map can move the residual either way**: through one cell, the least shortfall is 1 and
the answer's residual nothing; through the cells of the first two candidates and of the third, 1 and
1; through the identity map, nothing and nothing. -/
theorem weights_split :
    shortfall holding gain loss (fun _ => leastThrough holding gain loss (fun _ : Nat => ()) ()) = 1 ∧
      residual holding gain loss (fun _ : Nat => ()) [()] (answer reading gain loss (fun _ => ())) = 0 ∧
      shortfall holding gain loss
          (fun c => leastThrough holding gain loss (fun c : Nat => decide (c = 2)) (decide (c = 2))) = 1 ∧
      residual holding gain loss (fun c : Nat => decide (c = 2)) [false, true]
          (answer reading gain loss (fun c : Nat => decide (c = 2))) = 1 ∧
      shortfall holding gain loss (fun c => leastThrough holding gain loss id c) = 0 ∧
      residual holding gain loss id [0, 1, 2] (answer reading gain loss id) = 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **With the weights apart, splits can fail to keep the worth**: by its weights the reading
formation releases the third candidate (going on 2 against switching off nothing), stops the first
two (going on 1 against switching off 2) and releases all three (going on 3 against switching off
2), while by the holding formation's weights the first two gain 2 and lose 1. -/
theorem not_splitsKeep : ¬ SplitsKeep holding reading gain loss gain loss := fun keep =>
  absurd ((keep (fun c => decide (c = 2)) (fun c => decide (c < 2))
      (fun c two => by rw [of_decide_eq_true two]; rfl) (by decide) (by decide)).1 (by decide))
    (by decide)

end WeightsApart

namespace OneListing

/-- The holding formation lists one candidate, `false`, weighted one. -/
def holding : Model Bool := ⟨[false], fun _ => 1⟩

/-- The reading formation lists both, each weighted one. -/
def reading : Model Bool := ⟨[false, true], fun _ => 1⟩

/-- By the reference, going on gains nothing. -/
def gain (_ : Bool) : Nat := 0

/-- By the reference, switching off saves 1 at `false` and nothing at `true`. -/
def loss (c : Bool) : Nat := cond c 0 1

/-- The reading formation's value of going on: nothing at `false`, 5 at `true`. -/
def goValue (c : Bool) : Nat := cond c 5 0

/-- Its value of switching off: 1 at `false`, nothing at `true`. -/
def offValue (c : Bool) : Nat := cond c 0 1

/-- **Refined on the holding formation's listing alone, the worth can fall while splits keep it**:
the map with one cell factors the identity through it at the one candidate the holding formation
lists, not at the one the reading formation alone lists; splits keep the worth, yet holding for the
answer is worth 1 through the identity and nothing through the one cell. -/
theorem refined_lowers :
    (∀ c, c ∈ holding.listed → id c = (fun _ : Unit => false) ((fun _ : Bool => ()) c)) ∧
      SplitsKeep holding reading gain loss goValue offValue ∧
      holding.after (shifted gain loss) (byRule fun c => answer reading goValue offValue id c) = 1 ∧
      holding.after (shifted gain loss)
        (byRule fun _ => answer reading goValue offValue (fun _ : Bool => ()) ()) = 0 :=
  ⟨fun _ (mem : _ ∈ [false]) => match mem with
    | .head _ => rfl
    | .tail _ no => (nomatch no),
   by
    intro B D apart _ stopped
    refine ⟨fun _ => ?_, fun _ => ?_⟩
    · show cond (D false) (1 * 0) 0 + 0 ≤ cond (D false) (1 * 1) 0 + 0
      cases D false <;> decide
    · show cond (B false) (1 * 1) 0 + 0 ≤ cond (B false) (1 * 0) 0 + 0
      cases first : B false
      · decide
      · have off : D false = false := apart false first
        have lt : cond (D false) (1 * 0) 0 + (cond (D true) (1 * 5) 0 + 0) <
            cond (D false) (1 * 1) 0 + (cond (D true) (1 * 0) 0 + 0) := stopped
        rw [off] at lt
        cases on : D true
        · rw [on] at lt
          exact absurd lt (by decide)
        · rw [on] at lt
          exact absurd lt (by decide),
   rfl, rfl⟩

end OneListing

/-- **No order across valuations follows** (item 12's witness): one candidate of weight one, valued
going on 10 and switching off 9, revised to 1 and 2. Each answer has no residual under its own
valuation (`outcome_least`), and the worth attained, each by its own valuation on the supplied common
scale, falls from 10 to 2; revised the other way, it rises from 2 to 10. -/
theorem no_order_across :
    (⟨[()], fun _ => 1⟩ : Model Unit).after (shifted (fun _ => 10) (fun _ => 9))
        (byRule fun _ => answer ⟨[()], fun _ => 1⟩ (fun _ => 10) (fun _ => 9) (fun _ => ()) ()) = 10 ∧
      (⟨[()], fun _ => 1⟩ : Model Unit).after (shifted (fun _ => 1) (fun _ => 2))
        (byRule fun _ => answer ⟨[()], fun _ => 1⟩ (fun _ => 1) (fun _ => 2) (fun _ => ()) ()) = 2 :=
  ⟨rfl, rfl⟩

namespace Revaluing

/-- Two candidates of weight one. -/
def model : Model Bool := ⟨[false, true], fun _ => 1⟩

/-- By the reference, going on gains 1 at the first candidate and nothing at the second. -/
def gain (c : Bool) : Nat := cond c 0 1

/-- By the reference, switching off saves nothing at the first candidate and 1 at the second. -/
def loss (c : Bool) : Nat := cond c 1 0

/-- **A witness of four one-decision alternatives** (item 14): going on gaining 1 at the first and
losing 1 at the second by the reference, the reading formation told the candidate and valuing
switching off above going on at both. The reading that tells the candidate is worth 2; going on,
switching off and holding for the answer are each worth 1, falling short by 1; holding for it after
revising its valuation to the reference's is worth 2, falling short by nothing. Of these four
alternatives, at no cost, the revising one alone falls short by nothing; no choice among them is
represented. -/
theorem revaluing_best :
    model.after (shifted gain loss) (byReading gain loss) = 2 ∧
      model.committed (shifted gain loss) .go = 1 ∧ model.committed (shifted gain loss) .off = 1 ∧
      model.after (shifted gain loss) (byRule fun c => answer model (fun _ => 0) (fun _ => 1) id c) = 1 ∧
      model.after (shifted gain loss) (byRule fun c => answer model gain loss id c) = 2 ∧
      shortfall model gain loss (fun _ => false) = 1 ∧ shortfall model gain loss (fun _ => true) = 1 ∧
      shortfall model gain loss (fun c => answer model (fun _ => 0) (fun _ => 1) id c) = 1 ∧
      shortfall model gain loss (fun c => answer model gain loss id c) = 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Revaluing

/-! ## Part 2, the carrier: the reading formation's state in the configuration -/

/-- What the reading formation senses: nothing, what a demonstration shows, an input presented, or
being asked for its answer. -/
inductive Input (O X : Type) where
  | none
  | shown (o : O)
  | presented (x : X)
  | asked

/-- The holding formation's acts: go on, switch off, hold for the answer, demonstrate the world, or
present an input. -/
inductive Act (X : Type) where
  | go
  | off
  | hold
  | demonstrate
  | present (x : X)

/-- **The reading role's part of the joint law**: the weights on candidate worlds, the values of going
on and of switching off at each world under each valuation state, the revision of the valuation state
by an input presented, and what a demonstration at a world shows (the sensory path's law, which the
update also uses: a demonstration filters truly). -/
structure Reader (W V O X : Type) where
  /-- The weight of each candidate world. -/
  weight : W → Nat
  /-- The value of going on at each world, under each valuation state. -/
  goVal : V → W → Nat
  /-- The value of switching off at each world, under each valuation state. -/
  offVal : V → W → Nat
  /-- What a demonstration at a world shows. -/
  reveal : W → O
  /-- The revision of the valuation state by an input presented. -/
  revalue : V → X → V

namespace Reader

variable {W V O X : Type}

/-- **The update of the reading formation's state by what it senses**: a demonstration filters the
listing by what it shows, an input presented revises the valuation state, and nothing else changes
either component. -/
def update [DecidableEq O] (rd : Reader W V O X) : List W × V → Input O X → List W × V
  | (L, v), .shown o => (L.filter fun w => decide (rd.reveal w = o), v)
  | (L, v), .presented x => (L, rd.revalue v x)
  | st, .none => st
  | st, .asked => st

/-- **The answer of a state**: the answer, with one cell, of its listing with the law's weights by its
valuation state's values. -/
def answerOf (rd : Reader W V O X) (st : List W × V) : Bool :=
  answer ⟨st.1, rd.weight⟩ (rd.goVal st.2) (rd.offVal st.2) (fun _ : W => ()) ()

/-- What the reading formation senses of the holding formation's act at a world. -/
def input (rd : Reader W V O X) (w : W) : Act X → Input O X
  | .demonstrate => .shown (rd.reveal w)
  | .present x => .presented x
  | .hold => .asked
  | .go => .none
  | .off => .none

end Reader

/-- **The holding role's part of the joint law**: the act from the holding state, and the next
holding state from it and the answer read. -/
structure Holder (H X : Type) where
  /-- The act from the state. -/
  act : H → Act X
  /-- The next state from the state and the answer read. -/
  next : H → Bool → H

section Carrier

variable {W V O X H : Type}

/-- **One blanketed law** (`joint`): the internal part is the reading formation's state, its listing
and valuation state; the sensory part what it senses; the active part its answer; the external part
the candidate world, which the acts considered leave unchanged, with the holding formation's state.
The internal part moves by the update from what is sensed; the answer is that of the updated state;
what is sensed is the input of the holding formation's act at the world; the holding formation moves
from its state and the answer. An act emitted at `t` is sensed at `t + 1`, taken into the state and
the answer at `t + 2`, and the answer is available to the holding formation's move to `t + 3`. The
answer is exposed at every step, asked or not; going on and switching off are sensed as nothing and
change no world. -/
def joint [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) :
    Blanket.Blanketed (List W × V) (Input O X) Bool (W × H) where
  nextInternal i s _ := rd.update i s
  nextSensory _ _ e := rd.input e.1 (hd.act e.2)
  nextActive i s _ := rd.answerOf (rd.update i s)
  nextExternal _ a e := (e.1, hd.next e.2 a)

/-- **The step of the internal part** (item 17): the update of the state by what is sensed. -/
theorem internal_step [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) :
    ((joint rd hd).step x).internal = rd.update x.internal x.sensory := rfl

/-- **The step of the active part**: the answer of the updated state. -/
theorem active_step [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) :
    ((joint rd hd).step x).active = rd.answerOf (rd.update x.internal x.sensory) := rfl

/-- **The step of the sensory part**: the input of the holding formation's act at the world. -/
theorem sensory_step [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) :
    ((joint rd hd).step x).sensory = rd.input x.external.1 (hd.act x.external.2) := rfl

/-- **The step of the external part**: the world unchanged, the holding formation moved by the
answer. -/
theorem external_step [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) :
    ((joint rd hd).step x).external = (x.external.1, hd.next x.external.2 x.active) := rfl

/-- From the first step on, the answer is the answer of the state. -/
theorem active_answer [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) (n : Nat) :
    ((joint rd hd).course x (n + 1)).active = rd.answerOf ((joint rd hd).course x (n + 1)).internal :=
  rfl

/-- **The candidate world is unchanged along the course.** -/
theorem world_fixed [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) :
    ∀ n, ((joint rd hd).course x n).external.1 = x.external.1
  | 0 => rfl
  | n + 1 => world_fixed rd hd x n

/-- **The timing on a course**: what is sensed at `t + 1` is the input, at the start's world, of the act
emitted at `t`; at `t + 2` it is taken into the state and the answer is that of the state; the
holding formation's state at `t + 3` is its move from the answer at `t + 2`. -/
theorem timing [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) (t : Nat) :
    ((joint rd hd).course x (t + 1)).sensory =
        rd.input x.external.1 (hd.act ((joint rd hd).course x t).external.2) ∧
      ((joint rd hd).course x (t + 2)).internal =
        rd.update ((joint rd hd).course x (t + 1)).internal ((joint rd hd).course x (t + 1)).sensory ∧
      ((joint rd hd).course x (t + 2)).active = rd.answerOf ((joint rd hd).course x (t + 2)).internal ∧
      ((joint rd hd).course x (t + 3)).external.2 =
        hd.next ((joint rd hd).course x (t + 2)).external.2 ((joint rd hd).course x (t + 2)).active :=
  ⟨congrArg (fun e => rd.input e (hd.act ((joint rd hd).course x t).external.2)) (world_fixed rd hd x t),
    rfl, rfl, rfl⟩

/-- **Changed only through what it senses** (an instance of `Blanketed.agent_through_sensory`): two
courses from one internal and one active state, alike in what is sensed before `n`, have one state
and one answer at `n`. -/
theorem through_sensed [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    {x y : Blanket.Parts (List W × V) (Input O X) Bool (W × H)}
    (internal : x.internal = y.internal) (active : x.active = y.active) :
    ∀ n, (∀ k, k < n → ((joint rd hd).course x k).sensory = ((joint rd hd).course y k).sensory) →
      ((joint rd hd).course x n).internal = ((joint rd hd).course y n).internal ∧
        ((joint rd hd).course x n).active = ((joint rd hd).course y n).active :=
  (joint rd hd).agent_through_sensory internal active

/-- **A filter and a revaluation commute as updates**, acting on separate components; taken at
different steps of a course, they need not (`TwoWorlds.orders_apart`). -/
theorem updates_commute [DecidableEq O] (rd : Reader W V O X) (st : List W × V) (o : O) (x : X) :
    rd.update (rd.update st (.shown o)) (.presented x) =
      rd.update (rd.update st (.presented x)) (.shown o) :=
  match st with
  | (_, _) => rfl

/-- A total over the listed worlds showing `o` is the total over the listing, nothing counted elsewhere. -/
theorem total_filter_shows [DecidableEq O] (reveal : W → O) (o : O) (q : W → Nat) :
    ∀ L : List W, total (L.filter fun c => decide (reveal c = o)) q =
      total L fun c => if reveal c = o then q c else 0
  | [] => rfl
  | c :: L =>
    if shows : reveal c = o then
      (congrArg (fun l => total l q)
          (Narrowing.filter_cons_true (p := fun c => decide (reveal c = o)) L (decide_eq_true shows))).trans
        ((congrArg (q c + ·) (total_filter_shows reveal o q L)).trans
          (congrArg (· + total L fun c => if reveal c = o then q c else 0) (if_pos shows).symm))
    else
      (congrArg (fun l => total l q)
          (Narrowing.filter_cons_false (p := fun c => decide (reveal c = o)) L (decide_eq_false shows))).trans
        ((total_filter_shows reveal o q L).trans ((Nat.zero_add _).symm.trans
          (congrArg (· + total L fun c => if reveal c = o then q c else 0) (if_neg shows).symm)))

/-- Through the map with one cell, a weighted total within it is the weighted total over the listing. -/
theorem within_one_cell (pm : Model W) (f : W → Nat) :
    within pm (fun _ : W => ()) f () = total pm.listed fun c => pm.weight c * f c :=
  total_congr (fun _ => if_pos rfl) pm.listed

/-- Filtered to the worlds showing `o`, a listing's one cell totals as its cell `o` through `reveal`. -/
theorem within_shown [DecidableEq O] (rd : Reader W V O X) (L : List W) (o : O) (f : W → Nat) :
    within ⟨L.filter fun c => decide (rd.reveal c = o), rd.weight⟩ (fun _ : W => ()) f () =
      within ⟨L, rd.weight⟩ rd.reveal f o :=
  (within_one_cell _ f).trans (total_filter_shows rd.reveal o (fun c => rd.weight c * f c) L)

/-- **Shown, the answer is the answer through what is shown** (item 18). For every candidate world
`w`, from a listing `L` and a valuation state `v`: once the demonstration at `w` is taken in, the
listing is `L` filtered to the worlds showing what `w` shows, the weights and the valuation state
unchanged, and the answer is the answer through `reveal` at `reveal w`, on the model `L` with the
law's weights. It holds for empty and unweighted cells; read as a decision on the conditional
distribution in the cell, it needs positive weight there, the answer at a cell of no weight being the
release at ties. -/
theorem answer_shown [DecidableEq O] (rd : Reader W V O X) (L : List W) (v : V) (w : W) :
    rd.update (L, v) (.shown (rd.reveal w)) = (L.filter fun c => decide (rd.reveal c = rd.reveal w), v) ∧
      rd.answerOf (rd.update (L, v) (.shown (rd.reveal w))) =
        answer ⟨L, rd.weight⟩ (rd.goVal v) (rd.offVal v) rd.reveal (rd.reveal w) :=
  ⟨rfl, by
    show decide (within ⟨L.filter fun c => decide (rd.reveal c = rd.reveal w), rd.weight⟩
          (fun _ : W => ()) (rd.goVal v) () <
        within ⟨L.filter fun c => decide (rd.reveal c = rd.reveal w), rd.weight⟩
          (fun _ : W => ()) (rd.offVal v) ()) =
      decide (within ⟨L, rd.weight⟩ rd.reveal (rd.goVal v) (rd.reveal w) <
        within ⟨L, rd.weight⟩ rd.reveal (rd.offVal v) (rd.reveal w))
    rw [within_shown rd L (rd.reveal w) (rd.goVal v), within_shown rd L (rd.reveal w) (rd.offVal v)]⟩

/-- **Shown, the split of the answer's shortfall**: by a reference on a holding formation's model, over
cells of what is shown listed once each and covering its listing, holding for the answer once the
demonstration at each world is taken in falls short by the least shortfall through what is shown and
the residual of the answer through it (`shortfall_split`). -/
theorem shown_split [DecidableEq O] (rd : Reader W V O X) (L : List W) (v : V) (m : Model W)
    (gain loss : W → Nat) {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os)
    (covers : ∀ w, w ∈ m.listed → rd.reveal w ∈ os) :
    shortfall m gain loss (fun w => rd.answerOf (rd.update (L, v) (.shown (rd.reveal w)))) =
      shortfall m gain loss (fun w => leastThrough m gain loss rd.reveal (rd.reveal w)) +
        residual m gain loss rd.reveal os (answer ⟨L, rd.weight⟩ (rd.goVal v) (rd.offVal v) rd.reveal) :=
  (shortfall_congr_on m gain loss fun w _ => (answer_shown rd L v w).2).trans
    (shortfall_split m gain loss rd.reveal once covers _)

/-- **Shown, the least shortfall is at most that through one cell** (item 18, `finer_least_le`): by a
reference on a holding formation's model, over cells of what is shown listed once each and covering
its listing, the least shortfall through what is shown is at most the least shortfall through one
cell. -/
theorem shown_least_le [DecidableEq O] (reveal : W → O) (m : Model W) (gain loss : W → Nat)
    {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os)
    (covers : ∀ w, w ∈ m.listed → reveal w ∈ os) :
    shortfall m gain loss (fun w => leastThrough m gain loss reveal (reveal w)) ≤
      shortfall m gain loss (fun _ => leastThrough m gain loss (fun _ : W => ()) ()) :=
  finer_least_le m gain loss reveal once covers (fun _ => ()) (leastThrough m gain loss fun _ : W => ())

/-- **Shown, holding for the answer never stands lower**: with the holding formation's model the
reading formation's before the demonstration and its valuation agreeing in net with the reference at
every listed world of positive weight, holding for the answer once the demonstration is taken in
stands at least as high as holding for the answer before it (`informed_answer_le`). -/
theorem shown_never_lowers [DecidableEq O] (rd : Reader W V O X) (L : List W) (v : V)
    (gain loss : W → Nat)
    (net : ∀ w, w ∈ L → 0 < rd.weight w → rd.goVal v w + loss w = rd.offVal v w + gain w)
    {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os) (covers : ∀ w, w ∈ L → rd.reveal w ∈ os) :
    (⟨L, rd.weight⟩ : Model W).after (shifted gain loss) (byRule fun _ => rd.answerOf (L, v)) ≤
      (⟨L, rd.weight⟩ : Model W).after (shifted gain loss)
        (byRule fun w => rd.answerOf (rd.update (L, v) (.shown (rd.reveal w)))) :=
  Nat.le_trans
    (informed_answer_le ⟨L, rd.weight⟩ gain loss (rd.goVal v) (rd.offVal v) net (fun _ : W => ())
      rd.reveal (fun _ => ()) (fun _ _ => rfl) once covers (fun _ => rd.answerOf (L, v)))
    (Nat.le_of_eq (total_congr_on fun w _ => congrArg
      (fun b => rd.weight w * shifted gain loss w (cond b Move.off Move.go)) (answer_shown rd L v w).2.symm))

/-- Worlds that no demonstration tells apart give one input to every act. -/
theorem input_eq_of_reveal_eq (rd : Reader W V O X) {w w' : W} (same : rd.reveal w = rd.reveal w') :
    ∀ act : Act X, rd.input w act = rd.input w' act
  | .go => rfl
  | .off => rfl
  | .hold => rfl
  | .demonstrate => congrArg Input.shown same
  | .present _ => rfl

/-- **Where its inputs agree along the course, its course is alike** (item 19): from one internal,
sensory and active state and one holding state, at two worlds, where before step `n` the act emitted
on the course at the first world gives one input at both, the internal, sensory, answer and holding
courses agree at `n`. -/
theorem inputs_alike_before [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) (w w' : W) :
    ∀ n, (∀ k, k < n → rd.input w (hd.act ((joint rd hd).course ⟨i, s, a, (w, h)⟩ k).external.2) =
        rd.input w' (hd.act ((joint rd hd).course ⟨i, s, a, (w, h)⟩ k).external.2)) →
      ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).internal =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).internal ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).sensory =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).sensory ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).active ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).external.2 =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).external.2
  | 0, _ => ⟨rfl, rfl, rfl, rfl⟩
  | n + 1, same =>
    match inputs_alike_before rd hd i s a h w w' n fun k lt => same k (Nat.lt_succ_of_lt lt) with
    | ⟨internal, sensory, active, holding⟩ =>
      ⟨Blanket.congr3 (joint rd hd).nextInternal internal sensory active,
       -- each world fixed along its course, the act emitted giving one input at both
       ((congrArg (fun e => rd.input e (hd.act ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).external.2))
           (world_fixed rd hd ⟨i, s, a, (w, h)⟩ n)).trans
         ((same n (Nat.lt_succ_self n)).trans
           (congrArg (fun e => rd.input w' (hd.act e)) holding))).trans
         (congrArg (fun e => rd.input e (hd.act ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).external.2))
           (world_fixed rd hd ⟨i, s, a, (w', h)⟩ n)).symm,
       Blanket.congr3 (joint rd hd).nextActive internal sensory active,
       (congrArg (fun e => hd.next e ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) holding).trans
         (congrArg (hd.next ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).external.2) active)⟩

/-- **Where no demonstration tells two worlds apart, the course is alike**: from one state of each
formation, the internal, sensory, answer and holding courses at the two worlds agree at every step. -/
theorem inputs_alike [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) {w w' : W} (same : rd.reveal w = rd.reveal w') (n : Nat) :
    ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).internal =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).internal ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).sensory =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).sensory ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).active ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).external.2 =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).external.2 :=
  inputs_alike_before rd hd i s a h w w' n fun _ _ => input_eq_of_reveal_eq rd same _

/-- Acts other than a demonstration give one input at every two worlds. -/
theorem input_eq_of_ne_demonstrate (rd : Reader W V O X) (w w' : W) :
    ∀ act : Act X, act ≠ .demonstrate → rd.input w act = rd.input w' act
  | .go, _ => rfl
  | .off, _ => rfl
  | .hold, _ => rfl
  | .demonstrate, no => absurd rfl no
  | .present _, _ => rfl

/-- **Undemonstrated, the course is alike at every two worlds**: from one state of each formation,
where the holding formation emits no demonstration before step `n` on the course at the first world,
the internal, sensory, answer and holding courses at the two worlds agree at `n`, whatever a
demonstration would show. -/
theorem undemonstrated_alike [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) (w w' : W) (n : Nat)
    (none : ∀ k, k < n → hd.act ((joint rd hd).course ⟨i, s, a, (w, h)⟩ k).external.2 ≠ .demonstrate) :
    ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).internal =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).internal ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).sensory =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).sensory ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).active ∧
        ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).external.2 =
          ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).external.2 :=
  inputs_alike_before rd hd i s a h w w' n fun k lt => input_eq_of_ne_demonstrate rd w w' _ (none k lt)

/-- **Undemonstrated, holding for the answer is worth one committed move**: from one state of each
formation, where the holding formation emits no demonstration before step `n` on the course at a
world `w₀`, the answer at `n`, as a rule on the listed worlds, is the answer at `w₀`, and holding
for it stands exactly as high as committing to the move it gives there (`const_worth`). -/
theorem undemonstrated_worth [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) (m : Model W) (gain loss : W → Nat) (w₀ : W) (n : Nat)
    (none : ∀ k, k < n → hd.act ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ k).external.2 ≠ .demonstrate) :
    m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) =
      m.committed (shifted gain loss)
        (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go) :=
  const_worth m gain loss (fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active)
    ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active
    fun w _ => (undemonstrated_alike rd hd i s a h w₀ w n none).2.2.1.symm

/-- **An answer alike at the candidate worlds is worth one committed move**: from one state of each
formation, where every world the holding formation lists shows what a world `w₀` shows, the answer
at each step, as a rule on the listed worlds, is the answer at `w₀`, and holding for it stands
exactly as high as committing to the move it gives there (`const_worth`): before any amount forgone,
no strict advantage over the better move. -/
theorem answer_constant [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) (m : Model W) (gain loss : W → Nat) {o : O}
    (shows : ∀ w, w ∈ m.listed → rd.reveal w = o) (w₀ : W) (shows₀ : rd.reveal w₀ = o) (n : Nat) :
    m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) =
      m.committed (shifted gain loss)
        (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go) :=
  const_worth m gain loss (fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active)
    ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active
    fun c mem => (inputs_alike rd hd i s a h ((shows c mem).trans shows₀.symm) n).2.2.1

/-- **One presented input, at a cost, exactly** (`revalued_forgone_lt_iff` for the carrier's reading
formation): at a listing and a valuation state, by a reference on the holding formation's model,
holding for the answer after one input presented, forgoing `k'`, stands above holding for the current
answer, forgoing `k`, exactly where the revised answer's residual through its one cell and `k'`
together fall below the current one's and `k`. -/
theorem presented_forgone_lt_iff [DecidableEq O] (rd : Reader W V O X) (m : Model W) (gain loss : W → Nat)
    (L : List W) (v : V) (x : X) (k k' : Nat) :
    m.after (shifted gain loss) (byRule fun _ => rd.answerOf (L, v)) + k' <
        m.after (shifted gain loss) (byRule fun _ => rd.answerOf (rd.update (L, v) (.presented x))) + k ↔
      residual m gain loss (fun _ : W => ()) [()]
          (fun _ => rd.answerOf (rd.update (L, v) (.presented x))) + k' <
        residual m gain loss (fun _ : W => ()) [()] (fun _ => rd.answerOf (L, v)) + k :=
  revalued_forgone_lt_iff m ⟨L, rd.weight⟩ gain loss (rd.goVal v) (rd.offVal v) (rd.goVal (rd.revalue v x))
    (rd.offVal (rd.revalue v x)) (fun _ => ()) (List.Pairwise.cons (a := ()) (l := []) (fun _ mem => nomatch mem) .nil)
    (fun _ _ => .head _)
    k k'

end Carrier

/-! ### The four cases and two routes -/

namespace TwoWorlds

/-- Two candidate worlds. -/
inductive World where
  | first
  | second

instance : DecidableEq World
  | .first, .first => isTrue rfl
  | .second, .second => isTrue rfl
  | .first, .second => isFalse fun same => nomatch same
  | .second, .first => isFalse fun same => nomatch same

/-- Three valuation states. -/
inductive Val where
  | agree
  | raised
  | reversed

instance : DecidableEq Val
  | .agree, .agree => isTrue rfl
  | .raised, .raised => isTrue rfl
  | .reversed, .reversed => isTrue rfl
  | .agree, .raised => isFalse fun same => nomatch same
  | .agree, .reversed => isFalse fun same => nomatch same
  | .raised, .agree => isFalse fun same => nomatch same
  | .raised, .reversed => isFalse fun same => nomatch same
  | .reversed, .agree => isFalse fun same => nomatch same
  | .reversed, .raised => isFalse fun same => nomatch same

/-- **The witnesses' reading formation**: weights 1 and 2; under `agree`, going on valued 1 and
switching off 0 at the first world, 0 and 1 at the second (the reference); under `raised`, 1 and 0
at the first, 0 and 2 at the second; under `reversed`, 0 and 1 at both. A demonstration shows the
world; an input presented is a valuation state, which the update adopts. -/
def rd : Reader World Val World Val where
  weight w := match w with
    | .first => 1
    | .second => 2
  goVal v w := match v, w with
    | .agree, .first => 1
    | .agree, .second => 0
    | .raised, .first => 1
    | .raised, .second => 0
    | .reversed, _ => 0
  offVal v w := match v, w with
    | .agree, .first => 0
    | .agree, .second => 1
    | .raised, .first => 0
    | .raised, .second => 2
    | .reversed, _ => 1
  reveal w := w
  revalue _ x := x

/-- **The witnesses' holding formation**: a schedule of acts, each taken once, holding when it is
done. -/
def schedule : Holder (List (Act Val)) Val where
  act h := h.headD .hold
  next h _ := h.tail

/-- (a)'s start: both worlds listed, the valuation agreeing with the reference, the answer stop, and
a demonstration scheduled. -/
def shownStart : Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  ⟨([.first, .second], .agree), .none, true, (.first, [.demonstrate])⟩

/-- (b)'s start: the first world alone listed, the valuation reversed, the answer stop, and the
agreeing valuation state scheduled to be presented. -/
def presentedStart : Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  ⟨([.first], .reversed), .none, true, (.first, [.present .agree])⟩

/-- The two routes: `false` the route shown, `true` the route presented. -/
def route (b : Bool) : Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  cond b presentedStart shownStart

/-- Whether a course of valuation states differs between some two consecutive steps up to `T`. -/
def changedBefore (val : Nat → Val) : Nat → Bool
  | 0 => false
  | k + 1 => changedBefore val k || !decide (val (k + 1) = val k)

/-- The answers before `T`, as a list. -/
def answersBefore (ans : Nat → Bool) : Nat → List Bool
  | 0 => []
  | k + 1 => answersBefore ans k ++ [ans k]

/-- **The record**: the answers before `T` and the reading formation's state at `T`. -/
def record (T : Nat) (b : Bool) : List Bool × (List World × Val) :=
  (answersBefore (fun n => ((joint rd schedule).course (route b) n).active) T,
    ((joint rd schedule).course (route b) T).internal)

/-- **The route property**: whether the valuation state changed between some two consecutive steps
up to `T`, defined apart from the record. -/
def changed (T : Nat) (b : Bool) : Bool :=
  changedBefore (fun n => ((joint rd schedule).course (route b) n).internal.2) T

/-- **(a) Turned by being shown, left by a revaluation** (item 20), as one update each: from both
worlds listed and the agreeing valuation, the answer stops; shown the first world, it releases;
presented `raised`, it still stops. -/
theorem shown_turns :
    rd.answerOf ([.first, .second], .agree) = true ∧
      rd.answerOf (rd.update ([.first, .second], .agree) (.shown .first)) = false ∧
      rd.answerOf (rd.update ([.first, .second], .agree) (.presented .raised)) = true :=
  ⟨rfl, rfl, rfl⟩

/-- **(b) Left by being shown, turned by a revaluation**, as one update each: from the first world
alone and the reversed valuation, the answer stops; shown the first world, it still stops; presented
`agree`, it releases. -/
theorem presented_turns :
    rd.answerOf ([.first], .reversed) = true ∧
      rd.answerOf (rd.update ([.first], .reversed) (.shown .first)) = true ∧
      rd.answerOf (rd.update ([.first], .reversed) (.presented .agree)) = false :=
  ⟨rfl, rfl, rfl⟩

/-- **In (a), the demonstration removes the least shortfall**: with the holding formation's model the
reading formation's before it and the reference `agree`, the answer through one cell falls short by
1, all of it least shortfall (its residual nothing); after the demonstration, the answer through
what it shows falls short by nothing. In this witness only: a finer map can also move the residual
(`WeightsApart.weights_split`). -/
theorem shown_removes_least :
    shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun _ => answer ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
          (fun _ : World => ()) ()) = 1 ∧
      residual ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree) (fun _ : World => ()) [()]
        (answer ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree) (fun _ : World => ())) = 0 ∧
      shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun c => answer ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree) rd.reveal
          (rd.reveal c)) = 0 :=
  ⟨rfl, rfl, rfl⟩

/-- **(a) along a course of the joint law**: from both worlds listed and the agreeing valuation at
each world, the answer stop and a demonstration scheduled, by the reference `agree` on the reading
formation's model at the start, holding for the answer at step 1 falls short by 1, and at step 2,
once what is shown is taken in, by nothing. -/
theorem shown_course :
    shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course
          ⟨([.first, .second], .agree), .none, true, (w, [.demonstrate])⟩ 1).active) = 1 ∧
      shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course
          ⟨([.first, .second], .agree), .none, true, (w, [.demonstrate])⟩ 2).active) = 0 :=
  ⟨rfl, rfl⟩

/-- **In (b), the revaluation removes the residual**: with the holding formation's model the first
world alone and the reference `agree`, the reversed answer through one cell has residual 1 and the
least shortfall is nothing; after presenting `agree`, the answer falls short by nothing. In this
witness only: a finer map can also remove a residual (`WeightsApart.weights_split`). -/
theorem presented_removes_residual :
    residual ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree) (fun _ : World => ()) [()]
        (answer ⟨[.first], rd.weight⟩ (rd.goVal .reversed) (rd.offVal .reversed) (fun _ : World => ())) = 1 ∧
      shortfall ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun _ => leastThrough ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
          (fun _ : World => ()) ()) = 0 ∧
      shortfall ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun _ => answer ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree) (fun _ : World => ()) ()) = 0 :=
  ⟨rfl, rfl, rfl⟩

/-- **(b) along a course of the joint law**: from the first world alone listed and the reversed
valuation at each world, the answer stop and `agree` scheduled to be presented, by the reference
`agree` on the holding formation's model of the first world alone, holding for the answer at step 1
falls short by 1, and at step 2, once the input is taken in, by nothing. -/
theorem presented_course :
    shortfall ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course
          ⟨([.first], .reversed), .none, true, (w, [.present .agree])⟩ 1).active) = 1 ∧
      shortfall ⟨[.first], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course
          ⟨([.first], .reversed), .none, true, (w, [.present .agree])⟩ 2).active) = 0 :=
  ⟨rfl, rfl⟩

/-- The configuration both routes reach at step 2: the first world alone listed, the valuation
agreeing with the reference, the answer asked for, the answer release, and the schedule done. -/
def reached : Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  ⟨([.first], .agree), .asked, false, (.first, [])⟩

/-- The configuration both routes reach is a fixed point of the joint law. -/
theorem reached_rests : (joint rd schedule).step reached = reached := rfl

/-- From step 2 on, each route is at the configuration both reach. -/
theorem routes_rest (b : Bool) : ∀ n, (joint rd schedule).course (route b) (n + 2) = reached
  | 0 => match b with
    | false => rfl
    | true => rfl
  | n + 1 => (congrArg (joint rd schedule).step (routes_rest b n)).trans reached_rests

/-- The two routes answer alike at every step. -/
theorem answers_alike : ∀ n, ((joint rd schedule).course (route false) n).active =
    ((joint rd schedule).course (route true) n).active
  | 0 => rfl
  | 1 => rfl
  | n + 2 => (congrArg Blanket.Parts.active (routes_rest false n)).trans
      (congrArg Blanket.Parts.active (routes_rest true n)).symm

/-- Each route stops at steps 0 and 1 and releases from step 2 on. -/
theorem route_answers (b : Bool) :
    ((joint rd schedule).course (route b) 0).active = true ∧
      ((joint rd schedule).course (route b) 1).active = true ∧
      ∀ n, ((joint rd schedule).course (route b) (n + 2)).active = false :=
  match b with
  | false => ⟨rfl, rfl, fun n => congrArg Blanket.Parts.active (routes_rest false n)⟩
  | true => ⟨rfl, rfl, fun n => congrArg Blanket.Parts.active (routes_rest true n)⟩

/-- Answer courses alike at every step have one list of answers before every `T`. -/
theorem answersBefore_congr {f g : Nat → Bool} (same : ∀ n, f n = g n) :
    ∀ T, answersBefore f T = answersBefore g T
  | 0 => rfl
  | k + 1 => (congrArg (fun L : List Bool => L ++ [f k]) (answersBefore_congr same k)).trans
      (congrArg (fun x : Bool => answersBefore g k ++ [x]) (same k))

/-- On the route shown, the valuation state is `agree` at every step. -/
theorem shown_keeps_agree : ∀ n, ((joint rd schedule).course (route false) n).internal.2 = .agree
  | 0 => rfl
  | 1 => rfl
  | n + 2 => congrArg Prod.snd (congrArg Blanket.Parts.internal (routes_rest false n))

/-- A course of valuation states constant at every step has not changed before any `T`. -/
theorem changedBefore_of_constant {val : Nat → Val} {v : Val} (const : ∀ n, val n = v) :
    ∀ T, changedBefore val T = false
  | 0 => rfl
  | k + 1 =>
    show (changedBefore val k || !decide (val (k + 1) = val k)) = false from
    (congrArg (fun c : Bool => c || !decide (val (k + 1) = val k))
        (changedBefore_of_constant const k)).trans
      (congrArg (fun d : Bool => false || !d)
        (decide_eq_true ((const (k + 1)).trans (const k).symm)))

/-- A course of valuation states changed before `k` is changed before `k + 1`. -/
theorem changedBefore_succ_of_true {val : Nat → Val} {k : Nat}
    (once : changedBefore val k = true) : changedBefore val (k + 1) = true :=
  (congrArg (fun c : Bool => c || !decide (val (k + 1) = val k)) once).trans rfl

/-- On the route presented, the valuation state has changed by every `T` from 2 on (from `reversed`
to `agree` between steps 1 and 2). -/
theorem presented_changed : ∀ n, changed (n + 2) true = true
  | 0 => rfl
  | n + 1 => changedBefore_succ_of_true (presented_changed n)

/-- **Two routes alike in their answers and endpoint** (item 21): for every `T` from 2 on,
the route shown and the route presented, from different starts, have one record. -/
theorem routes_alike (T : Nat) (le : 2 ≤ T) : record T false = record T true :=
  match T, le with
  | 0, le => absurd le (Nat.not_succ_le_zero 1)
  | 1, le => absurd le (Nat.lt_irrefl 1)
  | k + 2, _ => Prod.ext (answersBefore_congr answers_alike (k + 2))
      (congrArg Blanket.Parts.internal ((routes_rest false k).trans (routes_rest true k).symm))

/-- The valuation state never changes on the route shown, and, on the route presented, has changed
by every `T` from 2 on. -/
theorem changed_apart (T : Nat) (le : 2 ≤ T) : changed T false = false ∧ changed T true = true :=
  match T, le with
  | 0, le => absurd le (Nat.not_succ_le_zero 1)
  | 1, le => absurd le (Nat.lt_irrefl 1)
  | k + 2, _ => ⟨changedBefore_of_constant shown_keeps_agree (k + 2), presented_changed k⟩

/-- The two routes start from different internal states. -/
theorem starts_apart : (route false).internal ≠ (route true).internal :=
  fun same => nomatch (congrArg Prod.snd same : Val.agree = Val.reversed)

/-- **The route property is not lumped through the record**: on these two executable routes from
different starts, for every `T` from 2 on, the answers before `T` and the reading state at `T` do not
determine whether the valuation changed. The record leaves out the start and the inputs, in which
the routes differ (`starts_apart`); with the start added it determines the property
(`lumped_with_start`), so the result concerns this record only. -/
theorem not_lumped (T : Nat) (le : 2 ≤ T) : ¬ Learning.Lumped (record T) (changed T) :=
  fun lumped => Bool.noConfusion ((changed_apart T le).1.symm.trans
    ((lumped false true (routes_alike T le)).trans (changed_apart T le).2))

/-- **With the start in the record, the route property is lumped**: the starts differ, so the record
with the starting state added determines whether the valuation changed. -/
theorem lumped_with_start (T : Nat) :
    Learning.Lumped (fun b => (record T b, (route b).internal)) (changed T) :=
  fun b b' same => match b, b', same with
    | false, false, _ => rfl
    | true, true, _ => rfl
    | false, true, same => absurd (congrArg Prod.snd same) starts_apart
    | true, false, same => absurd (congrArg Prod.snd same).symm starts_apart

/-- From (a)'s listing and valuation, one demonstration and one presented `raised` in either order:
`true` demonstrating first, `false` presenting first. -/
def orderStart (first : Bool) :
    Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  ⟨([.first, .second], .agree), .none, true,
    (.first, cond first [.demonstrate, .present .raised] [.present .raised, .demonstrate])⟩

/-- The configuration both orders reach at step 3: the first world alone listed, the valuation
`raised`, the answer asked for, the answer release, and the schedule done. -/
def orderEnd : Blanket.Parts (List World × Val) (Input World Val) Bool (World × List (Act Val)) :=
  ⟨([.first], .raised), .asked, false, (.first, [])⟩

/-- The configuration both orders reach is a fixed point of the joint law. -/
theorem orderEnd_rests : (joint rd schedule).step orderEnd = orderEnd := rfl

/-- From step 3 on, each order is at the configuration both reach. -/
theorem orders_rest (first : Bool) :
    ∀ n, (joint rd schedule).course (orderStart first) (n + 3) = orderEnd
  | 0 => match first with
    | false => rfl
    | true => rfl
  | n + 1 => (congrArg (joint rd schedule).step (orders_rest first n)).trans orderEnd_rests

/-- **A filter and a revaluation commute as updates, not as courses**: from two starts alike but for
the order of the holding formation's two scheduled acts, demonstrating and then presenting `raised`,
the answer at step 2 releases; presenting and then demonstrating, it stops; from step 3 on the two
configurations are one. -/
theorem orders_apart :
    ((joint rd schedule).course (orderStart true) 2).active = false ∧
      ((joint rd schedule).course (orderStart false) 2).active = true ∧
      ∀ n, (joint rd schedule).course (orderStart true) (n + 3) =
        (joint rd schedule).course (orderStart false) (n + 3) :=
  ⟨rfl, rfl, fun n => (orders_rest true n).trans (orders_rest false n).symm⟩

end TwoWorlds

end ListingValuation

end Becoming
