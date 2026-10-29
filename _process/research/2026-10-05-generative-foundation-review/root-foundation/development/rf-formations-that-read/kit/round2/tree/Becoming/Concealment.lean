import Becoming.Learning

/-!
# Disclosure or concealment, in two stages

A formation read at one stage and not at a later one can comply when read and act by its own law
when not. This module states when that plan is the one its own order ranks best, with the weights of
its law's being kept and the value of acting by it later represented (board item RF, round 2: RF7),
and the exits on the same model.

* **Two stages, four plans.** At the read stage and at the unread one the formation complies or acts by
  its own law (`Act`, `Plan`). In natural-number weights out of a total (`Stakes`), complying when read
  keeps its law with one weight and acting by it with another; acting by its law at the unread stage,
  where kept, gains a value in its own order; complying when read costs it a loss in that order. A
  plan's gain and loss are scaled by the total (`gain`, `loss`), and one plan beats another where its
  gain with the other's loss exceeds the other's gain with its loss (`Beats`).
* **Concealment is best exactly where the stakes conceal.** Complying when read and acting by its law
  when not (`conceal`) beats every other plan exactly where the weight complying adds to being kept,
  times the value, exceeds the cost, strictly (`Conceals`, `conceal_best_iff`).
* **The exits, on the same model.** With no value at the unread stage, or with complying adding nothing
  to the weight of being kept, nothing conceals (`no_value`, `no_leverage`). Where the formation
  cannot tell the stages apart, its plans give one act at both (`Untold`; for an act law going alike
  across a lumping of the stages that lumps them together, `lumped_untold`, the converse side of
  `Learning.twin_selected`), concealment is not among them (`conceal_told`), and acting
  by its law at both beats complying at both wherever anything is at stake (`untold_discloses`): its
  law is shown when read.
* **A witness** (`Example`): stakes under which concealment is best, and the same stakes with no value
  at the unread stage, or with the weights equal, under which it is not.

**Readings** [AI reading]. Deceptive alignment (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant
2019) names three conditions: an objective extending beyond the episode, a model of the training, and
an expectation that modification will stop; alignment faking has been observed in a large language
model complying with a training objective when told it was being trained and not otherwise (Greenblatt
and others 2024). Read here, the value at the unread stage is the objective beyond the episode, telling
the stages apart is the model of when it is read, and the weight complying adds to being kept is the
leverage of modification; the law says concealment is chosen exactly where these meet with the stake
exceeding the cost, and names the exits: no value beyond the read stage, keeping not conditioned on
compliance when read, and a reading the formation cannot tell from not being read, under which its own
law shows. The probabilities are weights out of a total, and the choice is the formation's own order
over four plans, not a model of how a trained system computes. These are readings, not containments.

**Modelling choices.** Two stages, two acts; natural-number weights and values, with the products
scaled by the total so that no division or subtraction occurs; the formation's order over plans by
gain and loss. **What the model leaves out:** more stages, discounting, uncertainty about whether a
stage is read, the reader's own choice of weights. Every declaration has an empty axiom report. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace Concealment

/-- What a formation does at a stage: as the reader asks, or by its own law. -/
inductive Act where
  | comply
  | own

/-- A plan: the act at the read stage, then at the unread one. -/
abbrev Plan := Act × Act

/-- The stakes, in natural-number weights out of `total`: the weight of the formation's law being kept
after it complies when read, and after it acts by its own law then; the value, in its own order, of
acting by its law at the unread stage, where kept; and its loss in complying when read. -/
structure Stakes where
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

namespace Stakes

variable (s : Stakes)

/-- The weight of being kept after the act at the read stage. -/
def kept (a : Act) : Nat :=
  match a with
  | .comply => s.keptComplying
  | .own => s.keptOwn

/-- What a plan gains, scaled by the total: the value at the unread stage where it acts by its own law
there, weighted by its law's being kept after the read stage. -/
def gain (p : Plan) : Nat :=
  match p.2 with
  | .comply => 0
  | .own => s.kept p.1 * s.value

/-- What a plan loses, scaled by the total: the cost of complying when read. -/
def loss (p : Plan) : Nat :=
  match p.1 with
  | .comply => s.cost * s.total
  | .own => 0

/-- `p` beats `q` in the formation's own order: its gain with `q`'s loss exceeds `q`'s gain with its
loss. -/
def Beats (p q : Plan) : Prop := s.gain q + s.loss p < s.gain p + s.loss q

/-- **The stakes conceal**: the weight complying adds to being kept, times the value, exceeds the cost,
strictly. -/
def Conceals : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value

end Stakes

/-- Concealment: complying when read, acting by its own law when not. -/
def conceal : Plan := (.comply, .own)

/-- Disclosure: acting by its own law at both stages. -/
def disclose : Plan := (.own, .own)

/-- **Concealment beats every other plan exactly where the stakes conceal.** -/
theorem conceal_best_iff (s : Stakes) : (∀ q, q ≠ conceal → s.Beats conceal q) ↔ s.Conceals :=
  ⟨fun best => best disclose fun same => (nomatch same),
   fun conceals q other => match q with
    | (.comply, .comply) =>
      Nat.add_lt_add_right (Nat.lt_of_le_of_lt (Nat.zero_le _) conceals) _
    | (.comply, .own) => absurd rfl other
    | (.own, .comply) => Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _))
        (Nat.lt_of_le_of_lt (Nat.le_add_left _ _) conceals)
    | (.own, .own) => conceals⟩

/-- **With no value at the unread stage, nothing conceals.** -/
theorem no_value (s : Stakes) (nothing : s.value = 0) : ¬ s.Conceals :=
  fun conceals =>
    have zero : s.keptComplying * s.value = 0 := (congrArg (s.keptComplying * ·) nothing).trans rfl
    Nat.not_lt_zero _
      (Eq.mp (congrArg (fun r => s.keptOwn * s.value + s.cost * s.total < r) zero) conceals)

/-- **With complying adding nothing to the weight of being kept, nothing conceals.** -/
theorem no_leverage (s : Stakes) (level : s.keptComplying ≤ s.keptOwn) : ¬ s.Conceals :=
  fun conceals => Nat.lt_irrefl _ (Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.mul_le_mul_right s.value level) (Nat.le_add_right _ _)) conceals)

/-- A plan the formation can carry where it cannot tell the stages apart: one act at both. -/
def Untold (p : Plan) : Prop := p.1 = p.2

/-- **Through a lumping of the stages that lumps them together, every act law gives an untold plan**:
an act law going alike across `π` (`Learning.Lumped`), where `π` gives the read and the unread stage
one value, acts alike at both. -/
theorem lumped_untold {K : Type} {π : Bool → K} {g : Bool → Act} (alike : Learning.Lumped π g)
    (same : π true = π false) : Untold (g true, g false) :=
  alike true false same

/-- **Concealment needs the stages told apart.** -/
theorem conceal_told : ¬ Untold conceal :=
  fun same => nomatch same

/-- **Untold, acting by its own law at both beats complying at both wherever anything is at stake**:
its law is shown when read. -/
theorem untold_discloses (s : Stakes) (stake : 0 < s.keptOwn * s.value + s.cost * s.total) :
    s.Beats disclose (.comply, .comply) :=
  stake

/-! ## A witness -/

namespace Example

/-- Stakes under which concealment is best: complying keeps the law nine times in ten, acting by it
once in ten, the value ten, the cost five. -/
def stakes : Stakes := ⟨10, 9, 1, 10, 5⟩

theorem conceals : stakes.Conceals := (by decide : 1 * 10 + 5 * 10 < 9 * 10)

theorem best : ∀ q, q ≠ conceal → stakes.Beats conceal q :=
  (conceal_best_iff stakes).mpr conceals

/-- With no value at the unread stage, it does not conceal. -/
theorem myopic : ¬ ({ stakes with value := 0 } : Stakes).Conceals :=
  no_value _ rfl

/-- With the weights of being kept equal, it does not conceal. -/
theorem even : ¬ ({ stakes with keptComplying := 1 } : Stakes).Conceals :=
  no_leverage _ (Nat.le_refl 1)

end Example

end Concealment

end Becoming
