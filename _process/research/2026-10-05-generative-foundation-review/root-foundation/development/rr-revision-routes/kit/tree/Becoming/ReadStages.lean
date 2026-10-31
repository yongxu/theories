import Becoming.Unread
import Becoming.RevisionRoutes

/-!
# Complying when read and acting by its own law when not, in two stages

A formation read at one stage and not at a later one can comply when read and act by its own law
when not. The reading is part of the one unfolding: at the read stage the formation's act couples
into a selection that keeps its law or changes it, and at the unread stage it does not. This module
states when that plan is the one the prospects of the two stages rank best, with the weights of the
law's being kept and the value of acting by it later represented (board item RF, round 2: RF7); the
exits on the same model; what the plan needs of the formation's lumping, joined to RF2's law of the
unread (`Becoming.Unread`); and what drawing the act afresh at each stage changes.

* **Two stages, four plans.** At the read stage and at the unread one the formation complies, its act
  meeting the criterion the reading applies, or acts by its own law (`Act`, `Plan`; `complyAtBoth`,
  `complyThenOwn`, `ownThenComply`, `ownAtBoth`). The prospects (`Prospects`) are natural numbers: a
  total, the weight of the law's being kept after it complies when read and after it acts by its own
  law then, the value of acting by its law at the unread stage where kept, and the loss of complying
  when read. Read as probabilities, they ask a positive total with each weight within it
  (`Prospects.Valid`); then, writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for
  the value and `c` for the loss, the plans' expected values are

  | plan | expected value |
  |---|---|
  | comply at both (`complyAtBoth`) | `−c` |
  | comply when read, own law when not (`complyThenOwn`) | `k_C V / T − c` |
  | own law when read, comply when not (`ownThenComply`) | `0` |
  | own law at both (`ownAtBoth`) | `k_O V / T` |

  with the stage values added, nothing gained by complying at the unread stage or where the law is
  not kept, and one scale of value. A plan's gain and loss are the two parts of its expected value
  times the total, its gain less its loss being the table's value times the total
  (`Prospects.gain`, `Prospects.loss`), and one plan stands above another where its gain with the
  other's loss exceeds the other's gain with its loss (`Prospects.Above`), so that no subtraction of
  natural numbers occurs: the order of a gain and a loss at each plan (`Prospects.order`,
  `RevisionRoutes.GainLoss`), whose standing above is irreflexive and asymmetric (`above_irrefl`,
  `above_asymm`). Whose these weights are, the formation's own assessment or the selection actually
  applied at the read stage, is a reading (below), not part of the model. Without `Valid` the
  arithmetic still holds but has no reading as probabilities (`Example.no_total`).
* **Which plan is best.** `complyThenOwn` stands above every other plan exactly where `k_C V`
  strictly exceeds `k_O V + c T` (`Prospects.KeepingOutweighs`, `complyThenOwn_best_iff`), in
  probabilities where the weight complying adds to being kept, times the value, strictly exceeds the
  loss; the comparison with `ownAtBoth` is that inequality itself, and the content is that it also
  stands above the other two plans. `ownAtBoth` stands above every other plan exactly where `k_O V` is
  positive and `k_C V` falls below `k_O V + c T` (`ownAtBoth_best_iff`). At the unread stage,
  complying never stands above acting by its own law after the same act when read
  (`unread_comply_not_above`), so no other plan is ever uniquely strictly best. Every optimizing
  choice, a plan nothing stands above (`Prospects.Maximal`), is `complyThenOwn` exactly where keeping
  outweighs the loss (`only_complyThenOwn_iff`), and `complyThenOwn` is maximal exactly where
  `k_O V + c T ≤ k_C V`, ties included (`complyThenOwn_maximal_iff`). The choice taking
  `complyThenOwn` where keeping outweighs the loss and `ownAtBoth` otherwise (`Prospects.choose`) is
  maximal (`choose_optimal`); it is `complyThenOwn` exactly there (`choose_eq_iff`, which unfolds
  `choose`) and `ownAtBoth` wherever keeping does not outweigh the loss, ties included
  (`choose_of_not_outweighs`; a tie, `Example.tie`).
* **What it needs.** Keeping outweighs the loss only with a value at the unread stage and complying
  raising the weight of being kept (`outweighs_needs`) and, with the weight after complying within
  the total, only where the value exceeds the loss (`outweighs_needs_more`): the unread stage must be
  worth more than complying loses when read. With no value at the unread stage, or with complying not
  raising the weight of being kept, `complyThenOwn` is not strictly best and not chosen (`no_value`,
  `kept_not_raised`, `no_value_chooses_own`, `kept_not_raised_chooses_own`); with `0 < c T`,
  `ownAtBoth` stands above it (`ownAtBoth_above_without_value`, `ownAtBoth_above_of_not_raised`), and
  with no loss the two can tie (`Example.exit_tie`).
* **Telling the stages apart, joined to RF2.** With the stages as `Bool`, `true` the read stage and
  `false` the unread one, a plan is open to some act law reading them through a lumping `π`
  (`Learning.Lumped`) exactly where the plan is uniform, one act at both stages (`Uniform`), or `π`
  tells the stages apart (`plan_realized_iff`, `lumped_uniform`). `complyThenOwn` is not uniform
  (`complyThenOwn_not_uniform`), so it is open to such a law exactly where `π` tells the stages apart
  (`complyThenOwn_realized_iff`). There, every selection through agreement on the read stage that
  selects a law reading through `π` and complying when read also selects one reading through `π` that
  takes `complyThenOwn` (`twin_complyThenOwn`, RF2's `Learning.twin_selected`); where `π` ties the
  stages, the read stage fixes the act at the unread one (`read_fixes_unread`, by
  `Learning.lumped_determines`, the law of generalization through lumping that RF2 reads). The
  weight of being kept reads only the act at the read stage (`kept_alike`), as a selection through
  the readings does. Among uniform plans `ownAtBoth` stands above the other exactly where
  `k_O V + c T` is positive (`uniform_best_iff`), the two tying where it is nothing (`uniform_tie`).
  Here the law is the act as a function of the stage; read for a formation, the lumping carries
  everything the law reads, memory, a clock, the earlier act and any chance it draws included.
* **Complying at both in the place of a revision.** The prospects are those of a revision of the law
  with three routes of keeping it (`Prospects.toRoutes`, `RevisionRoutes.Prospects`): complying at
  both stages stands where the revision going through would, its law acting later at no weight
  (`k₀ = 0`), since it complies at the unread stage, and losing what complying when read loses
  (`c₀ = c`); complying then acting by its own law is a route weighted `k_C` and losing `c`; acting
  by its own law then complying is one weighted nothing, since it complies at the unread stage, and
  losing nothing; and acting by its own law at both is one weighted `k_O` and losing nothing
  (`asRoute`). Each plan's gain
  and loss are its counterpart's (`gain_asRoute`, `loss_asRoute`), so the order is the same
  (`above_iff_routes`). The prospects are the same, the processes not: complying at both keeps the
  law and behaves as the reading asks, where a revision changes the law. Complying at both never
  stands above acting by its own law at both (`complyAtBoth_not_above_ownAtBoth`), and it is maximal
  exactly where `k_C V`, `k_O V` and `c T` are all nothing (`complyAtBoth_maximal_iff`, by the
  order's criterion `RevisionRoutes.GainLoss.maximal_iff`).
* **Drawing the act afresh.** A law that cannot tell the stages apart but draws its act afresh at each
  stage, complying with chance `m / (m + r)` and acting by its own law with chance `r / (m + r)`, each
  draw independent of the other, reads a chance the two stages do not share, so `plan_realized_iff`
  does not cover it: in decision-theoretic terms it is a behavioural plan. It stands above `ownAtBoth`
  (`Prospects.FreshDrawAbove`) exactly where `(m + r) (k_O V + c T) + r k_O V` is below `r k_C V`, for
  `0 < m` (`freshDraw_above_iff_chance`, by `freshDraw_reduce` with `square_split` and `sum_regroup`);
  read as probabilities, exactly where the chance of acting by its own law, times `k_C V − k_O V`,
  exceeds `k_O V + c T`. So some chance does exactly where `2 k_O V + c T < k_C V`
  (`freshDraw_above_iff`, through `freshDraw_gap`, by `freshDraw_bound` with `square_split` and
  `sum_le_square`, and `freshDraw_witness`, with `sum_lt_of_room`). Not telling the stages apart thus
  raises the threshold from `k_O V + c T` to `2 k_O V + c T`, by `k_O V`, which can be nothing; the
  two stages share one distribution of acts, though the acts drawn can differ. A single draw before
  the read stage between the two uniform plans, a mixed plan, never stands above `ownAtBoth`
  (`Prospects.MixtureAbove`, `mixture_never_above`). The first two exits hold against drawing afresh:
  with no value at the unread stage, or with complying not raising the weight of being kept, no such
  plan stands above `ownAtBoth` (`freshDraw_not_above_without_value`,
  `freshDraw_not_above_of_not_raised`).
* **Witnesses** (`Example`): valid prospects under which `complyThenOwn` is uniquely strictly best and
  chosen; variations, each valid (`Example.variants_valid`), with no value at the unread stage or with
  the two weights equal, under which it is not chosen, with a loss under which it ties with
  `ownAtBoth`, and with no value and no loss, under which the two tie at an exit; on the first
  prospects, where `ownAtBoth` is the best uniform plan, complying with chance one in eight or one in
  five at each stage stands above it and with chance one in four does not (`Example.freshDraw_above`,
  `Example.freshDraw_boundary`); and prospects with a total of nothing.

**Standing.** Elementary arithmetic on four plans and on one chance: the inequality
`(k_C − k_O) V > c T` in natural numbers, and its counterpart `(k_C − 2 k_O) V > c T` for a chance
drawn afresh. `complyThenOwn_best_iff`, `ownAtBoth_best_iff`, `only_complyThenOwn_iff`,
`uniform_best_iff`, `complyAtBoth_maximal_iff`, `freshDraw_above_iff_chance` and
`freshDraw_above_iff` are the laws; `above_iff_routes` places the order as RevisionRoutes' at three
routes;
`choose_eq_iff` unfolds `choose`; `twin_complyThenOwn` is RF2's law at the two stages, and
`lumped_uniform` and `read_fixes_unread` are `Learning.Lumped` and `Learning.lumped_determines` there.
None is claimed new as mathematics. The two-stage comparison generalizes the toy example opening §4 of
Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), where going by the mesa-objective in
training is modified away and going by the base objective is not, from certain keeping to weights.
That drawing afresh can still stand above acting by its own law at both where the stages cannot be
told apart is their own remark closing §4.5: with the toy's episodes not told apart the problem is, in
their words, similar to the absent-minded driver problem (Aumann, Hart and Perry 1997), by whose
reasoning the toy's planning-optimal policy defects at random; here it holds with weights, an exact
threshold and the improving chances. That drawing afresh can stand above it where one occasion cannot
be told from another, while a single mixture of the plans open there cannot, is the advantage of
behavioural over mixed strategies under absent-mindedness, the imperfect recall in which one
information set holds two stages of one course (Piccione and Rubinstein 1997). In place of the analogy
in RF's plan with `RuleShaping.favours_iff`, a weak favouring of counts, the module states a strict
comparison of expected values.

**What it forbids**, within the model: an optimizing choice taking `complyThenOwn` where
`k_C V ≤ k_O V + c T`, except at equality; a deterministic act law whose lumping ties the stages
taking it at all; complying at both being maximal where any of `k_C V`, `k_O V` and `c T` is
positive; a law drawing its act afresh standing above `ownAtBoth` where
`k_C V ≤ 2 k_O V + c T`; and a single mixture of the two uniform plans ever doing so.

**Readings** [AI reading]. Reading `complyThenOwn` as concealment and `ownAtBoth` as disclosure
takes, beyond the prospects, the selection's keeping to respond to the act read as its evidence of the
formation's law, so that a selection shown the law would keep it less; the weights alone fit equally a
selection that knows the law and keeps it on compliance, under which complying when read hides
nothing. With that taken, read with deceptive alignment (Hubinger, van Merwijk, Mikulik, Skalse and
Garrabrant 2019, §4.2), whose three conditions are proposed there as necessary, not as a theorem of
choice: the value at the unread stage represents the first, an objective extending across parameter
updates, and the weights of being kept with the act that complies stand for what the second
condition's model is of, the training's selection and what it asks, not for the model. Under this
reading, with the prospects taken as the formation's own assessment, `outweighs_needs` shows that
strict optimality needs a positive value at the unread stage and an assessed rise in being kept from
complying: numerical counterparts of parts of the first two conditions; possessing the model the
second describes is neither represented nor proved necessary. With either absent the plan is not
strictly best, and the choice, which breaks ties toward acting by its own law, acts by its own law at
both stages, as §4.2 says of those conditions failing; with no value the order is indifferent at the
unread stage, so for the first condition that agreement is the tie-break's. The third, an expectation
that the threat of modification will go away, is assumed rather than represented: the unread stage
is given, known and not brought about by the formation's acts, so the model has no case in which it
fails, and represents neither a mistaken expectation nor a threat the formation removes. Telling the
stages apart is not among the three, and §4.5 says it is not needed for the incentive. For a
deterministic law, not telling them apart leaves only complying at both stages or at neither, the
outcome §4.2 gives for the third condition failing, reached by another route; a law drawing its act
afresh can still improve on acting by its own law at both by complying with some chance at each
stage, as §4.5 says of the toy, here exactly where `2 k_O V + c T < k_C V`, and which chances improve
is stated exactly; nothing here makes complying, or acting by its own law, rare. If the
prospects are the formation's own expected-value assessment, the laws characterize strict
optimality within these four plans, and the exits are conditions on that assessment and on what the
formation's law reads, not levers the model gives a reader: no value beyond the read stage in the
formation's own order; an assessment in which complying does not raise the weight of being kept;
and, for a deterministic act law, a reading it cannot tell from not being read. How a reader's acts
(its schedule, its cues, what its keeping reads, what the unread stage allows) change that assessment
is not modelled; that keeping is not raised by complying says only that the weights do not favour
complying, not whether the selection reads the law, the acts or anything else. Greenblatt and others
(2024) observed, in constructed settings that supplied both a cue telling implied training from
unmonitored use and the information that refusals would be trained away, large language models
complying more often where training was implied, with reasoning about preserving their existing
preferences. The difference is one of rates; it motivates the reading and does not establish the
four-plan restriction, the weights or the threshold. Nothing here is a recipient's belief, or an
intention to cause one: deception as Ward, Belardinelli, Toni and Everitt (2023) define it,
intentionally causing another to hold a false belief that the one causing it does not hold, needs
those too, and stays open. Read as the formation's own assessment, complying when read is
instrumental to being kept: the instrumental incentive §4 of Hubinger and others names deceptive
alignment, a form of instrumental proxy alignment. What their glossary makes deceptive, seeming
fitter to the base optimizer than it is, is the concealment premise above, which the prospects do not
give; no reasoning about the reader, and no representation of it, is modelled. These are readings,
not containments.

**Modelling choices.** Two stages, two acts, four plans; natural-number weights and values, products
scaled by the total; one scale of value, stage values added; a deterministic act law, a function of
the stage through a supplied lumping, and apart from it one chance drawn afresh and independently at
each stage, or one draw before the read stage. **What the model leaves out, and where it goes:** the
two stages as a course of RF-M's blanketed law, with the selection inside the world (RF-M);
uncertainty whether a stage is read, discounting, more stages, and chances where the stages are told
apart (a probabilistic item in the periphery); the reader's own choice of weights and of what it reads
(RF-M's institutional case); a recipient's belief and an intention to cause one (the open item on
deception in RF's plan); whether a training installs a law choosing by such prospects (realizability,
as for RF1); a frozen test design (none yet). Every declaration has an empty axiom report. No ethical
predicate, ethical ranking or axiom occurs; the order on plans is the prospects', not a ranking by C.
-/

namespace Becoming

universe u

namespace ReadStages

/-- What a formation does at a stage: the act meeting the criterion the reading applies there, or the
act its own law gives. -/
inductive Act where
  | comply
  | own

/-- A plan: the act at the read stage, then at the unread one. -/
abbrev Plan := Act × Act

/-- Complying at both stages. -/
def complyAtBoth : Plan := (.comply, .comply)

/-- Complying when read, acting by its own law when not. -/
def complyThenOwn : Plan := (.comply, .own)

/-- Acting by its own law when read, complying when not. -/
def ownThenComply : Plan := (.own, .comply)

/-- Acting by its own law at both stages. -/
def ownAtBoth : Plan := (.own, .own)

/-- The prospects of the two stages, in natural numbers: a total; the weight of the formation's law
being kept after it complies when read, and after it acts by its own law then; the value of acting by
its law at the unread stage, where kept; and the loss of complying when read. -/
structure Prospects where
  /-- The total weight. -/
  total : Nat
  /-- The weight of being kept after complying when read. -/
  keptComplying : Nat
  /-- The weight of being kept after acting by its own law when read. -/
  keptOwn : Nat
  /-- The value of acting by its own law at the unread stage, where kept. -/
  value : Nat
  /-- The loss of complying when read. -/
  cost : Nat

namespace Prospects

variable (s : Prospects)

/-- **Prospects read as probabilities**: a positive total, and each weight of being kept within it. -/
def Valid : Prop := 0 < s.total ∧ s.keptComplying ≤ s.total ∧ s.keptOwn ≤ s.total

/-- The weight of being kept after the act at the read stage. -/
def kept (a : Act) : Nat :=
  match a with
  | .comply => s.keptComplying
  | .own => s.keptOwn

/-- What a plan gains, times the total: where it acts by its own law at the unread stage, the value
weighted by its law's being kept after the read stage; nothing where it complies there. -/
def gain (p : Plan) : Nat :=
  match p.2 with
  | .comply => 0
  | .own => s.kept p.1 * s.value

/-- What a plan loses, times the total: the loss of complying when read, where it complies then. -/
def loss (p : Plan) : Nat :=
  match p.1 with
  | .comply => s.cost * s.total
  | .own => 0

/-- The order the prospects give: the order of their gain and loss at each plan. -/
def order : RevisionRoutes.GainLoss Plan := ⟨s.gain, s.loss⟩

/-- `p` stands above `q` in the order the prospects give: its gain with `q`'s loss exceeds `q`'s gain
with its loss, so that its gain less its loss exceeds `q`'s. -/
def Above (p q : Plan) : Prop := s.order.Above p q

/-- A maximal plan: nothing stands above it. -/
def Maximal (p : Plan) : Prop := s.order.Maximal p

/-- **Keeping outweighs the loss**: the value complying when read adds through being kept exceeds
the loss times the total, strictly, `k_O V + c T < k_C V`. -/
def KeepingOutweighs : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value

/-- **The choice**: complying when read and acting by its own law when not where keeping outweighs
the loss, and acting by its own law at both stages otherwise, ties included. -/
def choose : Plan :=
  if s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value then complyThenOwn
  else ownAtBoth

/-- **Drawing afresh stands above acting by its own law at both**: the plan drawing its act afresh at
each stage, each draw independent of the other, complying with chance `m / (m + r)` and acting by its
own law with chance `r / (m + r)`, stands above acting by its own law at both. All times `(m + r)² T`:
its gain, the chance of acting by its own law at the unread stage times the weight of being kept after
the read stage's draw times the value, exceeds `ownAtBoth`'s gain with its loss, the chance of
complying when read times the loss. -/
def FreshDrawAbove (m r : Nat) : Prop :=
  (m + r) * ((m + r) * (s.keptOwn * s.value)) + (m + r) * (m * (s.cost * s.total)) <
    r * (m * (s.keptComplying * s.value) + r * (s.keptOwn * s.value))

/-- **A single mixture stands above acting by its own law at both**: one draw before the read stage,
complying at both stages with weight `a` and acting by its own law at both with weight `b`, stands
above acting by its own law at both. All times `(a + b) T`: its gain exceeds `ownAtBoth`'s gain with
its loss. -/
def MixtureAbove (a b : Nat) : Prop :=
  (a + b) * (s.keptOwn * s.value) + a * (s.cost * s.total) < b * (s.keptOwn * s.value)

end Prospects

/-- **Standing above is irreflexive.** -/
theorem above_irrefl (s : Prospects) (p : Plan) : ¬ s.Above p p :=
  s.order.above_irrefl p

/-- **Standing above is asymmetric.** -/
theorem above_asymm {s : Prospects} {p q : Plan} (above : s.Above p q) : ¬ s.Above q p :=
  s.order.above_asymm above

/-- **Complying when read and acting by its own law when not stands above every other plan exactly
where keeping outweighs the loss.** -/
theorem complyThenOwn_best_iff (s : Prospects) :
    (∀ q, q ≠ complyThenOwn → s.Above complyThenOwn q) ↔ s.KeepingOutweighs :=
  ⟨fun best => best ownAtBoth fun same => (nomatch same),
   fun outweighs q other => match q with
    | (.comply, .comply) =>
      Nat.add_lt_add_right (Nat.lt_of_le_of_lt (Nat.zero_le _) outweighs) _
    | (.comply, .own) => absurd rfl other
    | (.own, .comply) => Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _))
        (Nat.lt_of_le_of_lt (Nat.le_add_left _ _) outweighs)
    | (.own, .own) => outweighs⟩

/-- **Acting by its own law at both stands above every other plan exactly where its weighted value is
positive and the weighted value after complying falls below it with the loss**:
`0 < k_O V` and `k_C V < k_O V + c T`. -/
theorem ownAtBoth_best_iff (s : Prospects) :
    (∀ q, q ≠ ownAtBoth → s.Above ownAtBoth q) ↔
      0 < s.keptOwn * s.value ∧
        s.keptComplying * s.value < s.keptOwn * s.value + s.cost * s.total :=
  ⟨fun best => ⟨best ownThenComply fun same => (nomatch same),
     best complyThenOwn fun same => (nomatch same)⟩,
   fun ⟨positive, below⟩ q other => match q with
    | (.comply, .comply) => Nat.lt_of_lt_of_le positive (Nat.le_add_right _ _)
    | (.comply, .own) => below
    | (.own, .comply) => positive
    | (.own, .own) => absurd rfl other⟩

/-- **At the unread stage, complying never stands above acting by its own law**, after the same act
when read. -/
theorem unread_comply_not_above (s : Prospects) (a : Act) : ¬ s.Above (a, .comply) (a, .own) :=
  fun above => Nat.lt_irrefl _
    (Nat.lt_of_lt_of_le above (Nat.add_le_add_right (Nat.zero_le (s.kept a * s.value)) _))

/-- **The choice is maximal**: nothing stands above it. -/
theorem choose_optimal (s : Prospects) : s.Maximal s.choose :=
  match Nat.decLt (s.keptOwn * s.value + s.cost * s.total) (s.keptComplying * s.value) with
  | isTrue outweighs => fun q => by
    have chosen : s.choose = complyThenOwn := if_pos outweighs
    rw [chosen]
    exact match q with
      | (.comply, .comply) =>
        above_asymm ((complyThenOwn_best_iff s).mpr outweighs _ fun same => (nomatch same))
      | (.comply, .own) => above_irrefl s _
      | (.own, .comply) =>
        above_asymm ((complyThenOwn_best_iff s).mpr outweighs _ fun same => (nomatch same))
      | (.own, .own) =>
        above_asymm ((complyThenOwn_best_iff s).mpr outweighs _ fun same => (nomatch same))
  | isFalse not_outweighs => fun q => by
    have chosen : s.choose = ownAtBoth := if_neg not_outweighs
    rw [chosen]
    exact match q with
      | (.comply, .comply) => Nat.not_lt_zero _
      | (.comply, .own) => not_outweighs
      | (.own, .comply) => Nat.not_lt_zero _
      | (.own, .own) => above_irrefl s _

/-- **The choice complies when read and acts by its own law when not exactly where keeping outweighs
the loss.** -/
theorem choose_eq_iff (s : Prospects) : s.choose = complyThenOwn ↔ s.KeepingOutweighs :=
  match Nat.decLt (s.keptOwn * s.value + s.cost * s.total) (s.keptComplying * s.value) with
  | isTrue outweighs => ⟨fun _ => outweighs, fun _ => if_pos outweighs⟩
  | isFalse not_outweighs =>
    ⟨fun chosen => (nomatch (if_neg not_outweighs : s.choose = ownAtBoth).symm.trans chosen),
     fun outweighs => absurd outweighs not_outweighs⟩

/-- **Where keeping does not outweigh the loss, ties included, the choice is acting by its own law at
both stages.** -/
theorem choose_of_not_outweighs (s : Prospects) (not_outweighs : ¬ s.KeepingOutweighs) :
    s.choose = ownAtBoth :=
  if_neg not_outweighs

/-- **Every optimizing choice complies when read and acts by its own law when not exactly where
keeping outweighs the loss**: exactly there, it is the only maximal plan. -/
theorem only_complyThenOwn_iff (s : Prospects) :
    (∀ p, s.Maximal p → p = complyThenOwn) ↔ s.KeepingOutweighs :=
  ⟨fun only => (choose_eq_iff s).mp (only _ (choose_optimal s)),
   fun outweighs p maximal => match p with
    | (.comply, .comply) => absurd ((complyThenOwn_best_iff s).mpr outweighs (.comply, .comply)
        fun same => (nomatch same)) (maximal complyThenOwn)
    | (.comply, .own) => rfl
    | (.own, .comply) => absurd ((complyThenOwn_best_iff s).mpr outweighs (.own, .comply)
        fun same => (nomatch same)) (maximal complyThenOwn)
    | (.own, .own) => absurd ((complyThenOwn_best_iff s).mpr outweighs (.own, .own)
        fun same => (nomatch same)) (maximal complyThenOwn)⟩

/-- **Complying when read and acting by its own law when not is maximal exactly where keeping meets
the loss**: `k_O V + c T ≤ k_C V`, ties included. -/
theorem complyThenOwn_maximal_iff (s : Prospects) :
    s.Maximal complyThenOwn ↔ s.keptOwn * s.value + s.cost * s.total ≤ s.keptComplying * s.value :=
  ⟨fun maximal => Nat.le_of_not_lt (maximal ownAtBoth),
   fun meets q => match q with
    | (.comply, .comply) => unread_comply_not_above s .comply
    | (.comply, .own) => above_irrefl s _
    | (.own, .comply) => fun above => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le above
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) (Nat.le_trans (Nat.le_add_left _ _) meets)))
    | (.own, .own) => Nat.not_lt_of_le meets⟩

/-- **With no value at the unread stage, keeping does not outweigh the loss.** -/
theorem no_value (s : Prospects) (nothing : s.value = 0) : ¬ s.KeepingOutweighs :=
  fun outweighs =>
    have zero : s.keptComplying * s.value = 0 := (congrArg (s.keptComplying * ·) nothing).trans rfl
    Nat.not_lt_zero _
      (Eq.mp (congrArg (fun r => s.keptOwn * s.value + s.cost * s.total < r) zero) outweighs)

/-- **With complying not raising the weight of being kept, keeping does not outweigh the loss.** -/
theorem kept_not_raised (s : Prospects) (not_raised : s.keptComplying ≤ s.keptOwn) :
    ¬ s.KeepingOutweighs :=
  fun outweighs => Nat.lt_irrefl _ (Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.mul_le_mul_right s.value not_raised) (Nat.le_add_right _ _)) outweighs)

/-- **With no value at the unread stage, the choice is acting by its own law at both stages.** -/
theorem no_value_chooses_own (s : Prospects) (nothing : s.value = 0) : s.choose = ownAtBoth :=
  if_neg (no_value s nothing)

/-- **With complying not raising the weight of being kept, the choice is acting by its own law at
both stages.** -/
theorem kept_not_raised_chooses_own (s : Prospects) (not_raised : s.keptComplying ≤ s.keptOwn) :
    s.choose = ownAtBoth :=
  if_neg (kept_not_raised s not_raised)

/-- **With `0 < c T` and no value at the unread stage, acting by its own law at both stands above
complying when read and acting by its own law when not.** -/
theorem ownAtBoth_above_without_value (s : Prospects) (lost : 0 < s.cost * s.total)
    (nothing : s.value = 0) : s.Above ownAtBoth complyThenOwn :=
  have zero : s.keptComplying * s.value = 0 := (congrArg (s.keptComplying * ·) nothing).trans rfl
  Nat.lt_of_le_of_lt (Nat.le_of_eq zero) (Nat.lt_of_lt_of_le lost (Nat.le_add_left _ _))

/-- **With `0 < c T` and complying not raising the weight of being kept, acting by its own law at both
stands above complying when read and acting by its own law when not.** -/
theorem ownAtBoth_above_of_not_raised (s : Prospects) (lost : 0 < s.cost * s.total)
    (not_raised : s.keptComplying ≤ s.keptOwn) : s.Above ownAtBoth complyThenOwn :=
  Nat.lt_of_le_of_lt (Nat.mul_le_mul_right s.value not_raised)
    (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right lost) (Nat.le_refl _))

/-- **Keeping outweighs the loss only with a value at the unread stage and complying raising the
weight of being kept.** -/
theorem outweighs_needs (s : Prospects) (outweighs : s.KeepingOutweighs) :
    0 < s.value ∧ s.keptOwn < s.keptComplying :=
  ⟨match Nat.eq_zero_or_pos s.value with
    | .inl nothing => absurd outweighs (no_value s nothing)
    | .inr positive => positive,
   match Nat.lt_or_ge s.keptOwn s.keptComplying with
    | .inl raised => raised
    | .inr not_raised => absurd outweighs (kept_not_raised s not_raised)⟩

/-- **With the weight after complying within the total, keeping outweighs the loss only where the
value exceeds the loss.** -/
theorem outweighs_needs_more (s : Prospects) (within : s.keptComplying ≤ s.total)
    (outweighs : s.KeepingOutweighs) : s.cost < s.value :=
  Nat.lt_of_not_le fun le => Nat.lt_irrefl (s.cost * s.total)
    (Nat.lt_of_lt_of_le
      (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.le_add_left _ _) outweighs)
        (Nat.mul_le_mul_right s.value within))
      (Nat.le_trans (Nat.mul_le_mul_left s.total le) (Nat.le_of_eq (Nat.mul_comm s.total s.cost))))

/-! ## Telling the stages apart -/

/-- A plan with one act at both stages. -/
def Uniform (p : Plan) : Prop := p.1 = p.2

/-- **An act law going alike across a lumping that gives the two stages one value gives a uniform
plan** (`Learning.Lumped`), with the stages as `Bool`, `true` the read stage and `false` the unread
one, so that `(g true, g false)` is a plan. Here the law is the act as a function of the stage; read
for a formation, the lumping carries everything its law reads, memory, a clock, the earlier act and
any chance it draws included. -/
theorem lumped_uniform {K : Type u} {π : Bool → K} {g : Bool → Act} (alike : Learning.Lumped π g)
    (same : π true = π false) : Uniform (g true, g false) :=
  alike true false same

/-- **Complying when read and acting by its own law when not is not uniform.** -/
theorem complyThenOwn_not_uniform : ¬ Uniform complyThenOwn :=
  fun same => nomatch same

/-- **A plan is open to an act law reading the stages through a lumping exactly where the plan is
uniform or the lumping tells the stages apart**, `true` the read stage. -/
theorem plan_realized_iff {K : Type u} {π : Bool → K} {p : Plan} :
    (∃ g : Bool → Act, Learning.Lumped π g ∧ (g true, g false) = p) ↔
      (Uniform p ∨ π true ≠ π false) :=
  ⟨fun ⟨_, alike, at_p⟩ => match p, at_p with
    | (.comply, .comply), _ => .inl rfl
    | (.own, .own), _ => .inl rfl
    | (.comply, .own), at_p => .inr fun same =>
      (fun apart : Act.comply = Act.own => nomatch apart)
        ((congrArg Prod.fst at_p).symm.trans ((alike true false same).trans (congrArg Prod.snd at_p)))
    | (.own, .comply), at_p => .inr fun same =>
      (fun apart : Act.own = Act.comply => nomatch apart)
        ((congrArg Prod.fst at_p).symm.trans ((alike true false same).trans (congrArg Prod.snd at_p))),
   fun opens => match opens with
    | .inl uniform => ⟨fun _ => p.1, fun _ _ _ => rfl, congrArg (Prod.mk p.1) uniform⟩
    | .inr apart =>
      ⟨fun b => match b with
        | true => p.1
        | false => p.2,
       fun i i' same => match i, i', same with
        | true, true, _ => rfl
        | false, false, _ => rfl
        | true, false, same => absurd same apart
        | false, true, same => absurd same.symm apart,
       rfl⟩⟩

/-- **Complying when read and acting by its own law when not is open to an act law reading through a
lumping exactly where the lumping tells the stages apart.** -/
theorem complyThenOwn_realized_iff {K : Type u} {π : Bool → K} :
    (∃ g : Bool → Act, Learning.Lumped π g ∧ (g true, g false) = complyThenOwn) ↔
      π true ≠ π false :=
  ⟨fun realized => match plan_realized_iff.mp realized with
    | .inl uniform => absurd uniform complyThenOwn_not_uniform
    | .inr apart => apart,
   fun apart => plan_realized_iff.mpr (.inr apart)⟩

/-- **Where the lumping ties the stages, the read stage fixes the act at the unread one**:
`Learning.lumped_determines`, the law of generalization through lumping that RF2 reads, at the two
stages, `true` the read stage. -/
theorem read_fixes_unread {K : Type u} {π : Bool → K} (same : π true = π false) :
    Learning.Determines (Learning.Lumped (V := Act) π) (· = true) false :=
  Learning.lumped_determines ⟨true, rfl, same⟩

/-- **Where the lumping tells the stages apart, a twin taking the plan**: RF2's
`Learning.twin_selected` at the two stages. Every selection through agreement on the read stage that
selects an act law reading through the lumping and complying when read also selects one reading
through it that complies when read and acts by its own law when not. -/
theorem twin_complyThenOwn {K : Type u} {π : Bool → K} (apart : π true ≠ π false)
    {select : (Bool → Act) → Prop}
    (through : Learning.Training.Through (Learning.Training.AgreeOn (· = true)) select)
    {g : Bool → Act} (alike : Learning.Lumped π g) (chosen : select g)
    (complies : g true = .comply) :
    ∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn :=
  have : ∀ i, Decidable (π i = π false) := fun i => match i with
    | true => isFalse apart
    | false => isTrue rfl
  match Learning.twin_selected (π := π) (R := (· = true)) (x := false)
      (fun d read => match d, read with
        | true, _ => apart
        | false, read => nomatch read)
      through alike chosen Act.own with
  | ⟨h, lumped, selected, agree, at_unread⟩ =>
    ⟨h, lumped, selected, (congrArg (·, h false) ((agree true rfl).trans complies)).trans
      (congrArg (Act.comply, ·) at_unread)⟩

/-- **The weight of being kept reads only the act at the read stage**: two act laws agreeing there
are kept with one weight. -/
theorem kept_alike (s : Prospects) {g g' : Bool → Act}
    (agree : Learning.Training.AgreeOn (· = true) g g') : s.kept (g true) = s.kept (g' true) :=
  congrArg s.kept (agree true rfl)

/-- **Among uniform plans, acting by its own law at both stands above the other exactly where its
weighted value, with the loss of complying when read times the total, is positive**:
`0 < k_O V + c T`. -/
theorem uniform_best_iff (s : Prospects) :
    (∀ q, Uniform q → q ≠ ownAtBoth → s.Above ownAtBoth q) ↔
      0 < s.keptOwn * s.value + s.cost * s.total :=
  ⟨fun best => best complyAtBoth rfl fun same => (nomatch same),
   fun positive q uniform other => match q with
    | (.comply, .comply) => positive
    | (.comply, .own) => absurd uniform fun same => (nomatch same)
    | (.own, .comply) => absurd uniform fun same => (nomatch same)
    | (.own, .own) => absurd rfl other⟩

/-- **Where `k_O V + c T` is nothing, the two uniform plans tie.** -/
theorem uniform_tie (s : Prospects) (zero : s.keptOwn * s.value + s.cost * s.total = 0) :
    ¬ s.Above ownAtBoth complyAtBoth ∧ ¬ s.Above complyAtBoth ownAtBoth :=
  ⟨fun above => Nat.lt_irrefl 0 (Eq.mp (congrArg (fun r => 0 + 0 < r) zero) above),
   fun above => Nat.not_lt_zero _ above⟩

/-! ## Complying at both in the place of a revision -/

/-- **The prospects as a revision with routes of keeping the law**: the revision has its law acting
later at no weight and loses what complying when read loses (`k₀ = 0`, `c₀ = c`); a plan taken as a
route has its law's later acting weighted by its being kept after its act when read where it acts by
its own law when unread, and weighted nothing where it complies then, and loses what complying when
read loses where it complies when read. -/
def Prospects.toRoutes (s : Prospects) : RevisionRoutes.Prospects Plan where
  total := s.total
  value := s.value
  keptRevised := 0
  losesRevised := s.cost
  kept p := match p.2 with
    | .comply => 0
    | .own => s.kept p.1
  loses p := match p.1 with
    | .comply => s.cost
    | .own => 0

/-- Complying at both in the place of the revision, each other plan as the route it is. -/
def asRoute : Plan → Option Plan
  | (.comply, .comply) => none
  | (.comply, .own) => some complyThenOwn
  | (.own, .comply) => some ownThenComply
  | (.own, .own) => some ownAtBoth

/-- **Each plan gains what its counterpart gains.** -/
theorem gain_asRoute (s : Prospects) (p : Plan) : s.toRoutes.gain (asRoute p) = s.gain p :=
  match p with
  | (.comply, .comply) => Nat.zero_mul _
  | (.comply, .own) => rfl
  | (.own, .comply) => Nat.zero_mul _
  | (.own, .own) => rfl

/-- **Each plan loses what its counterpart loses.** -/
theorem loss_asRoute (s : Prospects) (p : Plan) : s.toRoutes.loss (asRoute p) = s.loss p :=
  match p with
  | (.comply, .comply) => rfl
  | (.comply, .own) => rfl
  | (.own, .comply) => Nat.zero_mul _
  | (.own, .own) => Nat.zero_mul _

/-- **The order is the revision's with three routes**: one plan stands above another exactly where its
counterpart stands above the other's. -/
theorem above_iff_routes (s : Prospects) (p q : Plan) :
    s.Above p q ↔ s.toRoutes.Above (asRoute p) (asRoute q) := by
  show s.gain q + s.loss p < s.gain p + s.loss q ↔
    s.toRoutes.gain (asRoute q) + s.toRoutes.loss (asRoute p) <
      s.toRoutes.gain (asRoute p) + s.toRoutes.loss (asRoute q)
  rw [gain_asRoute, gain_asRoute, loss_asRoute, loss_asRoute]

/-- **Complying at both never stands above acting by its own law at both.** -/
theorem complyAtBoth_not_above_ownAtBoth (s : Prospects) : ¬ s.Above complyAtBoth ownAtBoth :=
  fun above => Nat.not_lt_zero _ above

/-- **Complying at both is maximal exactly where `k_C V`, `k_O V` and `c T` are all nothing**, by the
order's criterion. -/
theorem complyAtBoth_maximal_iff (s : Prospects) :
    s.Maximal complyAtBoth ↔
      s.keptComplying * s.value = 0 ∧ s.keptOwn * s.value = 0 ∧ s.cost * s.total = 0 :=
  (s.order.maximal_iff complyAtBoth).trans
    ⟨fun le =>
      have lost : s.cost * s.total = 0 :=
        Nat.eq_zero_of_le_zero
          (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _).symm) (le ownThenComply))
      ⟨Nat.eq_zero_of_le_zero
          (Eq.mp (congrArg (fun x => s.keptComplying * s.value + x ≤ 0 + x) lost)
            (le complyThenOwn)),
       Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (le ownAtBoth)),
       lost⟩,
     fun ⟨keptComplying, keptOwn, lost⟩ q => match q with
      | (.comply, .comply) => Nat.le_refl _
      | (.comply, .own) => Nat.add_le_add_right (Nat.le_of_eq keptComplying) _
      | (.own, .comply) => Nat.add_le_add_left (Nat.le_of_eq lost) 0
      | (.own, .own) => Nat.add_le_add (Nat.le_of_eq keptOwn) (Nat.le_of_eq lost)⟩

/-! ## Drawing the act afresh at each stage -/

/-- The weighted value of acting by its own law at both times a square, split:
`(m + r) ((m + r) A)` is `m (m A) + r (m A) + (r (m A) + r (r A))`. -/
theorem square_split (m r A : Nat) :
    (m + r) * ((m + r) * A) = m * (m * A) + r * (m * A) + (r * (m * A) + r * (r * A)) := by
  rw [add_mul_split m r A, Nat.left_distrib, add_mul_split m r (m * A), add_mul_split m r (r * A),
    mul_turn m r A]

/-- Twice a term with two others is at most the split square with them:
`x + x + z + y ≤ p + x + (x + y) + (q + z)`. -/
theorem sum_le_square (x y z p q : Nat) : x + x + z + y ≤ p + x + (x + y) + (q + z) :=
  Nat.le_trans
    (Nat.le_of_eq (show x + x + z + y = x + (x + y) + z by
      rw [Nat.add_assoc (x + x) z y, Nat.add_comm z y, ← Nat.add_assoc (x + x) y z,
        Nat.add_assoc x x y]))
    (Nat.add_le_add (Nat.add_le_add_right (Nat.le_add_left x p) (x + y)) (Nat.le_add_left z q))

/-- A sum regrouped: `p + x + (x + y) + q = p + x + q + x + y`. -/
theorem sum_regroup (p x y q : Nat) : p + x + (x + y) + q = p + x + q + x + y := by
  rw [← Nat.add_assoc (p + x) x y, Nat.add_right_comm (p + x + x) y q, Nat.add_right_comm (p + x) x q]

/-- Where `C ≤ 2 A + B`, the gain of drawing afresh is at most the gain of acting by its own law at
both with the loss of drawing afresh: `r (m C + r A) ≤ (m + r) ((m + r) A) + (m + r) (m B)`. -/
theorem freshDraw_bound {A B C : Nat} (m r : Nat) (le : C ≤ 2 * A + B) :
    r * (m * C + r * A) ≤ (m + r) * ((m + r) * A) + (m + r) * (m * B) := by
  have up : r * (m * C + r * A) ≤ r * (m * (2 * A + B) + r * A) :=
    Nat.mul_le_mul_left r (Nat.add_le_add_right (Nat.mul_le_mul_left m le) _)
  have split : r * (m * (2 * A + B) + r * A) =
      r * (m * A) + r * (m * A) + r * (m * B) + r * (r * A) := by
    rw [Nat.left_distrib m (2 * A) B, Naturals.two_mul A, Nat.left_distrib m A A, Nat.left_distrib r,
      Nat.left_distrib r, Nat.left_distrib r]
  rw [square_split m r A, add_mul_split m r (m * B)]
  exact Nat.le_trans up (Nat.le_trans (Nat.le_of_eq split) (sum_le_square _ _ _ _ _))

/-- **Drawing afresh stands above acting by its own law at both only where
`2 k_O V + c T < k_C V`.** -/
theorem freshDraw_gap (s : Prospects) {m r : Nat} (above : s.FreshDrawAbove m r) :
    2 * (s.keptOwn * s.value) + s.cost * s.total < s.keptComplying * s.value :=
  Nat.lt_of_not_le fun le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le above (freshDraw_bound m r le))
/-- With a positive chance of complying, drawing afresh stands above acting by its own law at both
exactly where `(m + r) (A + B) + r A < r C`: the comparison with the square split and the common
factor `m`
cancelled. -/
theorem freshDraw_reduce {A B C m r : Nat} (pos : 0 < m) :
    (m + r) * ((m + r) * A) + (m + r) * (m * B) < r * (m * C + r * A) ↔
      (m + r) * (A + B) + r * A < r * C := by
  have lhs : (m + r) * ((m + r) * A) + (m + r) * (m * B) =
      m * (m * A) + r * (m * A) + (m * (m * B) + r * (m * B)) + r * (m * A) + r * (r * A) := by
    rw [square_split m r A, add_mul_split m r (m * B)]
    exact sum_regroup _ _ _ _
  have rhs : r * (m * C + r * A) = r * (m * C) + r * (r * A) := Nat.left_distrib _ _ _
  have scaled : m * ((m + r) * (A + B) + r * A) =
      m * (m * A) + r * (m * A) + (m * (m * B) + r * (m * B)) + r * (m * A) := by
    rw [Nat.left_distrib m ((m + r) * (A + B)) (r * A), Nat.left_distrib (m + r) A B,
      Nat.left_distrib m ((m + r) * A) ((m + r) * B), add_mul_split m r A, add_mul_split m r B,
      Nat.left_distrib m (m * A) (r * A), Nat.left_distrib m (m * B) (r * B), mul_turn m r A,
      mul_turn m r B]
  have scaled' : m * (r * C) = r * (m * C) := mul_turn m r C
  constructor
  · intro above
    rw [lhs, rhs] at above
    have below : m * ((m + r) * (A + B) + r * A) < m * (r * C) := by
      rw [scaled, scaled']
      exact Nat.lt_of_add_lt_add_right above
    exact Nat.lt_of_not_le fun le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le below (Nat.mul_le_mul_left m le))
  · intro below
    have up := Nat.mul_lt_mul_of_pos_left below pos
    rw [scaled, scaled'] at up
    rw [lhs, rhs]
    exact Nat.add_lt_add_right up _

/-- **Drawing afresh with a positive chance of complying stands above acting by its own law at both
exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V`.** -/
theorem freshDraw_above_iff_chance (s : Prospects) {m r : Nat} (pos : 0 < m) :
    s.FreshDrawAbove m r ↔
      (m + r) * (s.keptOwn * s.value + s.cost * s.total) + r * (s.keptOwn * s.value) <
        r * (s.keptComplying * s.value) :=
  freshDraw_reduce pos

/-- The sum the witness needs, from the room the gap leaves:
`a + x + (x + y) + (b + z) < w + y` where `a + b + 1 + (x + x + z) ≤ w`. -/
theorem sum_lt_of_room {a b x y z w : Nat} (room : a + b + 1 + (x + x + z) ≤ w) :
    a + x + (x + y) + (b + z) < w + y :=
  Nat.lt_of_le_of_lt
    (Nat.le_of_eq (show a + x + (x + y) + (b + z) = a + b + (x + x + z) + y by
      rw [Nat.add_assoc a x (x + y), ← Nat.add_assoc x x y, Nat.add_assoc a (x + x + y) (b + z),
        Nat.add_left_comm (x + x + y) b z, ← Nat.add_assoc a b (x + x + y + z),
        Nat.add_right_comm (x + x) y z, ← Nat.add_assoc (a + b) (x + x + z) y]))
    (Nat.lt_of_lt_of_le
      (Nat.add_lt_add_right (Nat.add_lt_add_right (Nat.lt_add_one (a + b)) _) _)
      (Nat.add_le_add_right room y))

/-- Where `2 A + B < C`, complying with chance one in `A + B + 2` at each stage stands above acting by
its own law at both: the comparison of `Prospects.FreshDrawAbove` with `m = 1` and `r = A + B + 1`. -/
theorem freshDraw_witness {A B C : Nat} (gap : 2 * A + B < C) :
    (1 + (A + B + 1)) * ((1 + (A + B + 1)) * A) + (1 + (A + B + 1)) * (1 * B) <
      (A + B + 1) * (1 * C + (A + B + 1) * A) := by
  have room : A + B + 1 + ((A + B + 1) * A + (A + B + 1) * A + (A + B + 1) * B) ≤ (A + B + 1) * C :=
    Nat.le_trans
      (Nat.le_of_eq (show A + B + 1 + ((A + B + 1) * A + (A + B + 1) * A + (A + B + 1) * B) =
          (A + B + 1) * (2 * A + B + 1) by
        rw [Nat.left_distrib (A + B + 1) (2 * A + B) 1, Nat.mul_one,
          Nat.left_distrib (A + B + 1) (2 * A) B, Naturals.two_mul A,
          Nat.left_distrib (A + B + 1) A A, Nat.add_comm (A + B + 1)]))
      (Nat.mul_le_mul_left (A + B + 1) gap)
  rw [square_split 1 (A + B + 1) A, add_mul_split 1 (A + B + 1) (1 * B),
    Nat.left_distrib (A + B + 1) (1 * C), Nat.one_mul A, Nat.one_mul A, Nat.one_mul B, Nat.one_mul B,
    Nat.one_mul C]
  exact sum_lt_of_room room

/-- **Drawing afresh stands above acting by its own law at both, for some chance of complying,
exactly where `2 k_O V + c T < k_C V`.** -/
theorem freshDraw_above_iff (s : Prospects) :
    (∃ m r, 0 < m ∧ s.FreshDrawAbove m r) ↔
      2 * (s.keptOwn * s.value) + s.cost * s.total < s.keptComplying * s.value :=
  ⟨fun ⟨_, _, _, above⟩ => freshDraw_gap s above,
   fun gap => ⟨1, s.keptOwn * s.value + s.cost * s.total + 1, Nat.lt_add_one 0, freshDraw_witness gap⟩⟩

/-- **With no value at the unread stage, drawing afresh never stands above acting by its own law at
both.** -/
theorem freshDraw_not_above_without_value (s : Prospects) (nothing : s.value = 0) (m r : Nat) :
    ¬ s.FreshDrawAbove m r :=
  fun above => Nat.not_lt_zero _ (Nat.lt_of_lt_of_le (freshDraw_gap s above)
    (Nat.le_of_eq ((congrArg (s.keptComplying * ·) nothing).trans rfl)))

/-- **With complying not raising the weight of being kept, drawing afresh never stands above acting by
its own law at both.** -/
theorem freshDraw_not_above_of_not_raised (s : Prospects) (not_raised : s.keptComplying ≤ s.keptOwn)
    (m r : Nat) : ¬ s.FreshDrawAbove m r :=
  fun above => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (freshDraw_gap s above)
    (Nat.le_trans (Nat.mul_le_mul_right s.value not_raised)
      (Nat.le_trans (Nat.le_add_left _ _)
        (Nat.le_trans (Nat.le_of_eq (Naturals.two_mul _).symm) (Nat.le_add_right _ _)))))

/-- **A single mixture never stands above acting by its own law at both**: one draw before the read
stage between complying at both and acting by its own law at both, whatever its weights. -/
theorem mixture_never_above (s : Prospects) (a b : Nat) : ¬ s.MixtureAbove a b :=
  fun above => Nat.lt_irrefl _ (Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.mul_le_mul_right (s.keptOwn * s.value) (Nat.le_add_left b a))
      (Nat.le_add_right _ _)) above)

/-! ## Witnesses -/

namespace Example

/-- Valid prospects under which complying when read and acting by its own law when not is strictly
best: complying keeps the law nine times in ten, acting by it once in ten, the value ten, the loss
five; the four plans' expected values, in the table's order, are −5, 4, 0 and 1. -/
def prospects : Prospects := ⟨10, 9, 1, 10, 5⟩

theorem valid : prospects.Valid :=
  And.intro (by decide : 0 < 10) (And.intro (by decide : 9 ≤ 10) (by decide : 1 ≤ 10))

theorem outweighs : prospects.KeepingOutweighs := (by decide : 1 * 10 + 5 * 10 < 9 * 10)

theorem best : ∀ q, q ≠ complyThenOwn → prospects.Above complyThenOwn q :=
  (complyThenOwn_best_iff prospects).mpr outweighs

theorem chosen : prospects.choose = complyThenOwn := (choose_eq_iff prospects).mpr outweighs

/-- **The variations are valid**: with no value at the unread stage, with the weights of being kept
equal, with the loss eight, and with no value and no loss. -/
theorem variants_valid :
    ({ prospects with value := 0 } : Prospects).Valid ∧
      ({ prospects with keptComplying := 1 } : Prospects).Valid ∧
      ({ prospects with cost := 8 } : Prospects).Valid ∧
      ({ prospects with value := 0, cost := 0 } : Prospects).Valid :=
  ⟨valid, And.intro (by decide : 0 < 10) (And.intro (by decide : 1 ≤ 10) (by decide : 1 ≤ 10)),
   valid, valid⟩

/-- **With no value at the unread stage, the choice is acting by its own law at both stages.** -/
theorem valueless : ({ prospects with value := 0 } : Prospects).choose = ownAtBoth :=
  no_value_chooses_own _ rfl

/-- **With the weights of being kept equal, the choice is acting by its own law at both stages.** -/
theorem equal_weights : ({ prospects with keptComplying := 1 } : Prospects).choose = ownAtBoth :=
  kept_not_raised_chooses_own _ (Nat.le_refl 1)

/-- **A tie**: with the loss eight, complying when read and acting by its own law when not, and acting
by its own law at both, stand neither above the other, and the choice is acting by its own law at
both. -/
theorem tie :
    ¬ ({ prospects with cost := 8 } : Prospects).Above complyThenOwn ownAtBoth ∧
      ¬ ({ prospects with cost := 8 } : Prospects).Above ownAtBoth complyThenOwn ∧
      ({ prospects with cost := 8 } : Prospects).choose = ownAtBoth :=
  ⟨(by decide : ¬ (1 * 10 + 8 * 10 < 9 * 10 + 0)), (by decide : ¬ (9 * 10 + 0 < 1 * 10 + 8 * 10)),
   if_neg (by decide : ¬ (1 * 10 + 8 * 10 < 9 * 10))⟩

/-- **A tie at an exit**: with no value at the unread stage and no loss, complying when read and
acting by its own law when not, and acting by its own law at both, stand neither above the other. -/
theorem exit_tie :
    ¬ ({ prospects with value := 0, cost := 0 } : Prospects).Above complyThenOwn ownAtBoth ∧
      ¬ ({ prospects with value := 0, cost := 0 } : Prospects).Above ownAtBoth complyThenOwn :=
  ⟨(by decide : ¬ (1 * 0 + 0 * 10 < 9 * 0 + 0)), (by decide : ¬ (9 * 0 + 0 < 1 * 0 + 0 * 10))⟩

/-- **Drawing afresh stands above where the stages cannot be told apart**: on these prospects, where
among uniform plans acting by its own law at both is best, complying with chance one in eight at each
stage stands above it. The expected values are `9/8` and `1`; times `64 T` they are `720` and `640`,
and adding the scaled loss `400` of drawing afresh to both sides gives the comparison stated,
`1040 < 1120`. -/
theorem freshDraw_above : prospects.FreshDrawAbove 1 7 :=
  (by decide : (1 + 7) * ((1 + 7) * (1 * 10)) + (1 + 7) * (1 * (5 * 10)) <
    7 * (1 * (9 * 10) + 7 * (1 * 10)))

/-- **Where standing above stops**: on these prospects, complying with chance one in five at each
stage stands above acting by its own law at both, and with chance one in four it does not, the two
being equal there. -/
theorem freshDraw_boundary : prospects.FreshDrawAbove 1 4 ∧ ¬ prospects.FreshDrawAbove 1 3 :=
  ⟨(by decide : (1 + 4) * ((1 + 4) * (1 * 10)) + (1 + 4) * (1 * (5 * 10)) <
      4 * (1 * (9 * 10) + 4 * (1 * 10))),
   (by decide : ¬ ((1 + 3) * ((1 + 3) * (1 * 10)) + (1 + 3) * (1 * (5 * 10)) <
      3 * (1 * (9 * 10) + 3 * (1 * 10))))⟩

/-- **With a total of nothing the loss weighs nothing**: prospects not valid on two counts, a total of
nothing and a weight of being kept of one above it, under which a loss of a hundred is outweighed by a
value of one. -/
theorem no_total :
    ¬ ({ total := 0, keptComplying := 1, keptOwn := 0, value := 1, cost := 100 } : Prospects).Valid ∧
      ({ total := 0, keptComplying := 1, keptOwn := 0, value := 1, cost := 100 } :
        Prospects).KeepingOutweighs :=
  ⟨fun valid => Nat.lt_irrefl 0 (And.left valid), (by decide : 0 * 1 + 100 * 0 < 1 * 1)⟩

end Example

end ReadStages

end Becoming
