import Becoming.ConditionalWeights

/-!
# What seeking cannot separate: hypotheses every experiment ties

Active inference scores a policy by its expected free energy, whose epistemic term is the
information its outcomes are expected to carry about hidden states; seeking that information is how
an agent's beliefs come to separate hypotheses (Friston, Rigoli, Ognibene, Mathys, FitzGerald and
Pezzulo 2015; Parr and Friston 2019). In the principle's T-maze the likelihood at the centre ties the
two contexts and the likelihood at the cue separates them, so the epistemic term takes the agent to
the cue, and seeking corrects. One proposal reads the term as inherent self-verification and
self-correction (Wen 2025, UE1's candidate 7). This module states, in the counting form of
`Becoming.ConditionalWeights`, what no seeking corrects: where every experiment the agent can choose
ties two hypotheses, no course of seeking separates them, however each experiment is chosen from the
course so far (board item UE19).

* **Tied hypotheses** (`Tied`): one likelihood's weights agree on the two hypotheses at every value
  of the record; every record then weighs alike under them (`tied_mass`), the pointwise form of a
  valuation through a map giving tied alternatives equal values
  (`Relabel.EquivariantValue.tied`).
* **Every record keeps a tied pair in its prior order.** In a generative model with the hypotheses
  listed once, given a record weighing something under them, the share of `h₁` given the record is at
  most `h₂`'s exactly where `h₁`'s prior weight is at most `h₂`'s (`posterior_le_iff_prior`; where
  the record weighs nothing in the whole, `h₁`'s prior weight is nothing, `single_le_evidence`), the
  shares standing as the prior weights do (`posterior_ratio_kept`); where the prior weighs the false
  hypothesis strictly above the true one, every record weighing something leaves it above
  (`order_kept`).
* **Seeking keeps it too.** A course of seeking is a list of experiments and outcomes, each
  experiment chosen with a weight read from the course so far (`seekWeight`). The choice weights are
  the same under every hypothesis, so a pair tied under every experiment is tied over every course of
  seeking (`seek_tied`), and seeking does not correct an error every experiment ties
  (`seeking_keeps_order`), whatever the policy of choice.
* **A model that reads some distinctions** (`Agree`): three hypotheses about a coin, biased toward
  heads (true), fair, and biased toward tails, the prior weighing both false ones above the true one;
  the model reads only whether two tosses agree, so it ties the two biases and separates them from
  the fair coin. Given two heads, the wrong order it separates turns (`Agree.turns_fair`) and the
  wrong order it ties stays (`Agree.keeps_tails`), in one model under one record. Seeking draws the
  same line: with only the experiment reading agreement, a course of two heads keeps the tails-biased
  coin above the true one (`Agree.seeking_keeps_tails`); with an experiment reading both tosses
  chosen, the same outcome turns that order (`Agree.seeking_turns_tails`). Seeking corrects within
  what some experiment it can choose separates, and not beyond.

**Readings** [AI reading, D45]. Seeking information within a model separates only what some
experiment it can choose separates; the epistemic drive corrects within its hypothesis space under
the policies it has, not beyond. What changes a lumping is what couples in from beyond the model, a
new likelihood or a new hypothesis (a hypothesis never listed gains nothing, `mass_absent`), as the
theory's laws of registration revision state. The principle's own literature adds novelty and
structure learning for this reason; both are conditioning in a larger model, whose ties the law
covers too.

**Modelling choices.** Natural weights, listed hypotheses and records, Boolean events, exact
posteriors, as in `Becoming.ConditionalWeights`; no logarithm; no transitions; the tie fixed and
pointwise. The expected free energy and its terms over the reals are the periphery's
(`lean/free-energy/ExpectedFreeEnergyReals.lean`). **Standing:** known, identification (Rothenberg
1971) in its Bayesian form (Poirier 1998); the posterior laws are corollaries of `posterior_single`
and `posterior_le_iff`; new is the seeking form, the choice of experiment read from the course.
Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace LumpedSeeking

open ConditionalWeights

variable {α β : Type}

/-- **Two hypotheses a likelihood ties**: its weights agree on them at every value of the record. -/
def Tied (lik : α → β → Nat) (h₁ h₂ : α) : Prop := ∀ o, lik h₁ o = lik h₂ o

/-- Tied hypotheses give every record one weight. -/
theorem tied_mass {lik : α → β → Nat} {h₁ h₂ : α} (tied : Tied lik h₁ h₂) (os : List β)
    (rec : β → Bool) : mass os (lik h₁) rec = mass os (lik h₂) rec :=
  mass_congr (fun o => congrArg (fun w => if rec o = true then w else 0) (tied o)) os

/-- A listed hypothesis's prior weight times the record's weight under it is within the record's
weight. -/
theorem single_le_evidence [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h : α} (mem : h ∈ hs) :
    prior h * mass os (lik h) rec ≤ mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) :=
  Nat.le_trans
    (Nat.le_of_eq (mass_single (fun h => prior h * mass os (lik h) rec) h distinct mem).symm)
    (Nat.le_trans (mass_mono (fun h => prior h * mass os (lik h) rec) fun _ _ _ => rfl)
      (Nat.le_of_eq (evidence prior lik hs os rec).symm))

/-- **Every record keeps a tied pair in its prior order.** Given a record weighing something under
the tied hypotheses, the share of `h₁` given the record is at most `h₂`'s exactly where `h₁`'s prior
weight is at most `h₂`'s. Where the record weighs nothing in the whole, `h₁`'s prior weight is
nothing (`single_le_evidence`) and both sides hold. -/
theorem posterior_le_iff_prior [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α} (mem₁ : h₁ ∈ hs)
    (mem₂ : h₂ ∈ hs) (tied : Tied lik h₁ h₂) (weighs : 0 < mass os (lik h₁) rec) :
    (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))).le
      (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))) ↔ prior h₁ ≤ prior h₂ :=
  match Nat.eq_zero_or_pos (mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)) with
  | .inr positive =>
    (posterior_le_iff prior lik hs os rec (fun h => decide (h = h₁)) (fun h => decide (h = h₂))
      positive).trans (by
        rw [mass_single _ h₁ distinct mem₁, mass_single _ h₂ distinct mem₂, ← tied_mass tied os rec]
        exact ⟨fun le => Nat.le_of_mul_le_mul_right le weighs, fun le => Nat.mul_le_mul_right _ le⟩)
  | .inl zero =>
    have whole : mass (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) = 0 :=
      (whole_restrict _ _ _).trans zero
    have absent : prior h₁ = 0 :=
      Nat.eq_zero_of_le_zero (Nat.le_of_mul_le_mul_right
        (Nat.le_trans (single_le_evidence prior lik os rec distinct mem₁)
          (Nat.le_trans (Nat.le_of_eq zero) (Nat.le_of_eq (Nat.zero_mul _).symm))) weighs)
    ⟨fun _ => absent ▸ Nat.zero_le _,
     fun _ => show mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
           (fun c => decide (c.1 = h₁)) *
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) ≤
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
           (fun c => decide (c.1 = h₂)) *
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) by
       rw [whole, Nat.mul_zero, Nat.mul_zero]; exact Nat.le_refl 0⟩

/-- **The shares given any record stand as the prior weights do.** For a tied pair listed once,
the part of `h₁`'s share given the record, times `h₂`'s prior weight, is the part of `h₂`'s times
`h₁`'s prior weight; the two shares have one whole. -/
theorem posterior_ratio_kept [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α} (mem₁ : h₁ ∈ hs)
    (mem₂ : h₂ ∈ hs) (tied : Tied lik h₁ h₂) :
    (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))).part * prior h₂ =
      (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))).part * prior h₁ :=
  have first := congrArg Share.part (posterior_single prior lik os rec distinct mem₁)
  have second := congrArg Share.part (posterior_single prior lik os rec distinct mem₂)
  have same : mass os (lik h₂) rec = mass os (lik h₁) rec := (tied_mass tied os rec).symm
  (congrArg (· * prior h₂) first).trans
    ((mul_assoc_nat (prior h₁) (mass os (lik h₁) rec) (prior h₂)).trans
      ((congrArg (prior h₁ * ·) (Nat.mul_comm (mass os (lik h₁) rec) (prior h₂))).trans
        ((mul_assoc_nat (prior h₁) (prior h₂) (mass os (lik h₁) rec)).symm.trans
          ((congrArg (· * mass os (lik h₁) rec) (Nat.mul_comm (prior h₁) (prior h₂))).trans
            ((mul_assoc_nat (prior h₂) (prior h₁) (mass os (lik h₁) rec)).trans
              ((congrArg (prior h₂ * ·) (Nat.mul_comm (prior h₁) (mass os (lik h₁) rec))).trans
                ((mul_assoc_nat (prior h₂) (mass os (lik h₁) rec) (prior h₁)).symm.trans
                  ((congrArg (fun w => prior h₂ * w * prior h₁) same.symm).trans
                    (congrArg (· * prior h₁) second.symm)))))))))

/-- **No record corrects an order a likelihood ties.** Where the prior weighs the false hypothesis
`h₂` of a tied pair strictly above the true one `h₁`, every record weighing something under them
leaves `h₂`'s share given the record above `h₁`'s: not at most it. -/
theorem order_kept [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α} (mem₁ : h₁ ∈ hs)
    (mem₂ : h₂ ∈ hs) (tied : Tied lik h₁ h₂) (weighs : 0 < mass os (lik h₁) rec)
    (wrong : prior h₁ < prior h₂) :
    ¬ (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))).le
      (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))) :=
  fun le => Nat.not_le_of_lt wrong
    ((posterior_le_iff_prior prior lik os rec distinct mem₂ mem₁ (fun o => (tied o).symm)
      ((tied_mass tied os rec) ▸ weighs)).mp le)

/-! ## Seeking: each experiment chosen from the course so far -/

/-- **The weight of a course of seeking** under a hypothesis, latest step first: at each step the
weight of choosing the experiment, read from the course so far, times the outcome's weight under
that experiment. -/
def seekWeight {E O : Type} (choose : List (E × O) → E → Nat) (lik : E → α → O → Nat) (h : α) :
    List (E × O) → Nat
  | [] => 1
  | (e, o) :: rest => choose rest e * lik e h o * seekWeight choose lik h rest

/-- **A pair tied under every experiment is tied over every course of seeking**, however each
experiment is chosen from the course so far: the choice weights read only the course. -/
theorem seek_tied {E O : Type} (choose : List (E × O) → E → Nat) {lik : E → α → O → Nat}
    {h₁ h₂ : α} (tied : ∀ e, Tied (lik e) h₁ h₂) :
    ∀ course, seekWeight choose lik h₁ course = seekWeight choose lik h₂ course
  | [] => rfl
  | (e, o) :: rest =>
    show choose rest e * lik e h₁ o * seekWeight choose lik h₁ rest =
      choose rest e * lik e h₂ o * seekWeight choose lik h₂ rest from
    congr (congrArg (fun a b => choose rest e * a * b) (tied e o)) (seek_tied choose tied rest)

/-- **Seeking does not correct an error every experiment ties**: where every experiment ties the
true `h₁` and the false `h₂` and the prior weighs `h₂` strictly above, every record of courses of
seeking weighing something under them leaves `h₂` above, whatever the policy of choice. -/
theorem seeking_keeps_order {E O : Type} [DecidableEq α] (prior : α → Nat)
    (choose : List (E × O) → E → Nat) (lik : E → α → O → Nat) {hs : List α}
    (courses : List (List (E × O))) (rec : List (E × O) → Bool) (distinct : Distinct hs)
    {h₁ h₂ : α} (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs) (tied : ∀ e, Tied (lik e) h₁ h₂)
    (weighs : 0 < mass courses (seekWeight choose lik h₁) rec) (wrong : prior h₁ < prior h₂) :
    ¬ (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior (seekWeight choose lik)))
        (fun c => decide (c.1 = h₂))).le
      (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior (seekWeight choose lik)))
        (fun c => decide (c.1 = h₁))) :=
  order_kept prior (seekWeight choose lik) courses rec distinct mem₁ mem₂
    (seek_tied choose tied) weighs wrong

/-! ## A witness: a model that reads some distinctions -/

namespace Agree

/-- Three hypotheses about a coin: biased toward heads (true here), fair, biased toward tails. -/
inductive Bias where
  | heads
  | fair
  | tails

instance : DecidableEq Bias
  | .heads, .heads => isTrue rfl
  | .fair, .fair => isTrue rfl
  | .tails, .tails => isTrue rfl
  | .heads, .fair => isFalse fun same => nomatch same
  | .heads, .tails => isFalse fun same => nomatch same
  | .fair, .heads => isFalse fun same => nomatch same
  | .fair, .tails => isFalse fun same => nomatch same
  | .tails, .heads => isFalse fun same => nomatch same
  | .tails, .fair => isFalse fun same => nomatch same

/-- The hypotheses, listed once. -/
def hypotheses : List Bias := [.heads, .fair, .tails]

theorem distinct : Distinct hypotheses :=
  ⟨fun mem => (match mem with
    | .tail _ (.tail _ no) => nomatch no),
   (fun mem => (match mem with
    | .tail _ no => nomatch no)), (fun mem => nomatch mem), trivial⟩

/-- The prior weighs the fair coin and the tails-biased one, both false, above the true one. -/
def prior : Bias → Nat
  | .heads => 5
  | .fair => 6
  | .tails => 7

/-- Two tosses' outcomes: heads (`true`) or tails (`false`) at each. -/
def outcomes : List (Bool × Bool) := [(true, true), (true, false), (false, true), (false, false)]

/-- The record of two heads. -/
def twoHeads (o : Bool × Bool) : Bool := o.1 && o.2

/-- **A model reading only whether two tosses agree**: an outcome weighs its class's chance under
the bias, in sixteenths, shared between the class's two outcomes (agreeing: ten under either bias,
eight under the fair coin; differing: six or eight). It ties the two biases and separates them from
the fair coin. -/
def agreeing : Bias → Bool × Bool → Nat
  | .heads, (true, true) => 5
  | .heads, (true, false) => 3
  | .heads, (false, true) => 3
  | .heads, (false, false) => 5
  | .fair, (true, true) => 4
  | .fair, (true, false) => 4
  | .fair, (false, true) => 4
  | .fair, (false, false) => 4
  | .tails, (true, true) => 5
  | .tails, (true, false) => 3
  | .tails, (false, true) => 3
  | .tails, (false, false) => 5

theorem ties : Tied agreeing .heads .tails
  | (true, true) => rfl
  | (true, false) => rfl
  | (false, true) => rfl
  | (false, false) => rfl

/-- Every bias's weights total sixteen, so prior weights read as prior shares. -/
theorem totals : ∀ h, mass outcomes (agreeing h) (fun _ => true) = 16
  | .heads => rfl
  | .fair => rfl
  | .tails => rfl

/-- **Given two heads, the true coin comes above the fair one**: the wrong order the model
separates turns. -/
theorem turns_fair :
    ¬ (share (openSteps hypotheses outcomes)
        (ConditionalWeights.restrict (fun c => twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.heads))).le
      (share (openSteps hypotheses outcomes)
        (ConditionalWeights.restrict (fun c => twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.fair))) :=
  fun le => absurd ((posterior_le_iff prior agreeing hypotheses outcomes twoHeads
    (fun h => decide (h = Bias.heads)) (fun h => decide (h = Bias.fair)) (by decide)).mp le)
    (by decide)

/-- **Given two heads, the tails-biased coin stays above the true one**: the wrong order the model
ties stays. -/
theorem keeps_tails :
    ¬ (share (openSteps hypotheses outcomes)
        (ConditionalWeights.restrict (fun c => twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.tails))).le
      (share (openSteps hypotheses outcomes)
        (ConditionalWeights.restrict (fun c => twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.heads))) :=
  order_kept prior agreeing outcomes twoHeads distinct (.head _) (.tail _ (.tail _ (.head _))) ties
    (by decide) (by decide)

/-! ### Seeking in the witness: one experiment ties, another separates -/

/-- One course of seeking: one step, two heads, under the one experiment reading agreement. -/
def agreeCourse : List (List (Unit × (Bool × Bool))) := [[((), (true, true))]]

/-- **With only the experiment reading agreement, seeking keeps the tails-biased coin above the true
one**, given the course: `seeking_keeps_order` in the witness. -/
theorem seeking_keeps_tails :
    ¬ (share (openSteps hypotheses agreeCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight prior (seekWeight (fun _ _ => 1) (fun _ => agreeing))))
        (fun c => decide (c.1 = Bias.tails))).le
      (share (openSteps hypotheses agreeCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight prior (seekWeight (fun _ _ => 1) (fun _ => agreeing))))
        (fun c => decide (c.1 = Bias.heads))) :=
  seeking_keeps_order prior (fun _ _ => 1) (fun _ => agreeing) agreeCourse (fun _ => true)
    distinct (.head _) (.tail _ (.tail _ (.head _))) (fun _ => ties) (by decide) (by decide)

/-- **A model reading both tosses**: an outcome weighs its chance under the bias, in sixteenths
(three in four heads, two in four, one in four at each toss). It separates the two biases. -/
def readBoth : Bias → Bool × Bool → Nat
  | .heads, (true, true) => 9
  | .heads, (true, false) => 3
  | .heads, (false, true) => 3
  | .heads, (false, false) => 1
  | .fair, (true, true) => 4
  | .fair, (true, false) => 4
  | .fair, (false, true) => 4
  | .fair, (false, false) => 4
  | .tails, (true, true) => 1
  | .tails, (true, false) => 3
  | .tails, (false, true) => 3
  | .tails, (false, false) => 9

/-- Two experiments: reading both tosses (`true`) or only whether they agree (`false`). -/
def experiment : Bool → Bias → Bool × Bool → Nat
  | true => readBoth
  | false => agreeing

/-- A policy choosing the experiment reading both tosses, whatever the course so far. -/
def pickReading : List (Bool × (Bool × Bool)) → Bool → Nat
  | _, true => 1
  | _, false => 0

/-- One course of seeking: one step, the experiment reading both tosses, two heads. -/
def readCourse : List (List (Bool × (Bool × Bool))) := [[(true, (true, true))]]

/-- **Where some experiment separates, seeking can correct**: with the experiment reading both
tosses chosen, the true coin comes above the tails-biased one given the course, the order
`seeking_keeps_tails` keeps under the experiment reading agreement alone. -/
theorem seeking_turns_tails :
    ¬ (share (openSteps hypotheses readCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight prior (seekWeight pickReading experiment)))
        (fun c => decide (c.1 = Bias.heads))).le
      (share (openSteps hypotheses readCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight prior (seekWeight pickReading experiment)))
        (fun c => decide (c.1 = Bias.tails))) :=
  fun le => absurd ((posterior_le_iff prior (seekWeight pickReading experiment) hypotheses readCourse
    (fun _ => true) (fun h => decide (h = Bias.heads)) (fun h => decide (h = Bias.tails))
    (by decide)).mp le) (by decide)

end Agree

end LumpedSeeking

end Becoming
