import Becoming.SelectionReach
import Becoming.SelectionTerm

/-!
# Drawn beyond: whose dependence a rise breaks, and the share that reaches beyond

`Becoming.SelectionReach` showed that where a family containing what couples in gains nothing,
a rise of what couples in is drawn from beyond it, and that every selection rewarding the rise
favours that reaching. It left open whether what is drawn is depended on, how much more than the
rise is drawn under dissipation, and the course of the share of formations that reach beyond.
This module states them. The conditions beyond are listed apart from the family (`rest` beside
`ds`), so that the whole is `ds ++ rest`. No premise enters beyond what each theorem names.

* **The beyond falls by the rise and the loss, exactly.** In a balanced flow, where the whole
  gains nothing across a step, the family's stock and the beyond's after the step, with what the
  whole loses across it, are the two before (`Flow.Balances.beyond_falls_exactly`): the beyond
  falls by at least the rise (`Flow.Balances.rise_lowers_beyond`), and under dissipation by at
  least one unit more for each formation taking from the whole
  (`Flow.Balances.rise_lowers_beyond_dissipating`).
* **Above the slack, a dependence beyond breaks.** Name on each condition beyond a formation
  depending on it at a need it meets (`Web.MetOn`); the slack is what the conditions stand above
  those needs (`Web.slack`). Where the rise with the loss exceeds the slack, some such dependence
  is broken across the step (`Flow.Balances.breaks_beyond`, and for the rise alone
  `Flow.Balances.rise_breaks_beyond`). The bound is exact: in `WithinSlack` the rise equals the
  slack and nothing breaks (`WithinSlack.within_slack`).
* **The formation does not go on as it was.** Where activity needs support, the formation whose
  dependence breaks is not, after the step, active with that dependence at a need as strong: it
  ends, or its dependence weakens or dissolves (`Flow.Balances.breaks_beyond_unsettles`); with
  the dependence as it was, it ends (`Flow.Balances.breaks_beyond_ends`).
* **Selection favours breaking beyond.** Where every condition a group couples into is in the
  family, every selection holding only where the family rises above the slack beyond holds only
  where a formation outside the group loses a dependence on a condition no member couples into
  (`Flow.favours_breaking_beyond`). `Dweller` is the instance: the store's rise, a selection
  through the taker's coupling, breaks the dweller's dependence on the source, and the dweller
  ends (`Dweller.rise_ends_dweller`, `Dweller.selected_breaks`).
* **Raising from nothing new is reaching beyond.** Where the whole gains nothing, a formation
  giving the family more than it takes from it takes from the beyond (`Flow.RaisesOn.reaches`).
* **The share reaching beyond.** Read generations whose members take part in the flow, with the
  amount whether each reaches beyond (`Flow.reach`). Where the whole gains nothing and more
  offspring go only to raisers of the family, no pair is discordant: the share is never selected
  against (`Flow.share_not_against`). Where also each offspring of a reaching member reaches,
  the share does not fall over any stretch (`Flow.share_not_lower`); with exact transmission it
  moves only upward, and where it moved, at some step more offspring went with reaching
  (`Flow.share_moved_rises`). `Spreading` is a world where it rises from a half to the whole
  (`Spreading.share_rises`). Transmission binds: in `Lapsing`, with the same selection, the draw
  is not carried on and the share falls to nothing (`Lapsing.share_falls`).
* **Without openness, the beyond bounds the rise.** Over a stretch at every step of which the
  whole gains nothing, the family rose by at most what the beyond lost
  (`Flow.Balances.rise_bounded_by_beyond`); a rise above all the whole held needs a step at which
  it is open, gaining from outside it (`Flow.Balances.open_of_rise_above`). In `Spreading` the
  store never stands above two (`Spreading.store_bounded`).
* **Graded by the inflow.** Without the premise that the whole gains nothing, each law holds past
  the whole's inflow (`Flow.inflow`), the gainless law being its case of no inflow: the two stocks
  after the step with the loss are at most the two before with the inflow
  (`Flow.Balances.beyond_falls_inflow`), so the beyond falls by at least the rise less the inflow
  (`Flow.Balances.rise_lowers_beyond_inflow`); a rise above the slack and the inflow breaks a
  dependence beyond (`Flow.Balances.breaks_beyond_inflow`, `Flow.Balances.rise_breaks_beyond_inflow`)
  and a selection rewarding it favours the break (`Flow.favours_breaking_beyond_inflow`); a
  formation giving the family more than it takes from it by more than it gives the whole beyond
  what it takes from it takes from the beyond (`Flow.reaches_inflow`); over a stretch the family
  rises by at most what the beyond lost and the stretch's inflow
  (`Flow.Balances.rise_bounded_by_beyond_inflow`). An open whole, fed from outside, is not exempt:
  only the part of a rise the inflow covers need not be drawn from beyond.

**Reading (the AI's).** What a rise draws from beyond is depended on as soon as the rise, with
what the exchange loses, exceeds the slack of the dependences there; the selection that rewards
the rise then rewards ending or changing a formation that no member of the selecting group
couples into, and so cannot see (`Becoming.SelectionGap`). Over generations, where what raises
is what multiplies, reaching beyond is never selected against, and it spreads as far as it is
transmitted; it is bounded by what the beyond holds unless the whole is open. None of this says
that the draw is wrong or that the ending is a harm: it says where what the rise draws lands and why
the selection does not register it.

What is not derived: that the whole gains nothing (a hypothesis wherever it enters); which
formation depends on which condition beyond, and at what need (named by `dep`); that more
offspring go to raisers, and how reaching is transmitted (hypotheses of the generational laws);
the offspring relation, which need not be descent in the flow. The representation commits to
discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- The slack of the dependences beyond at a step: over a family of conditions, what each
stands above the need of the dependence of the formation named on it. -/
def slack (dep : C → F) (rest : List C) (t : Nat) : Nat :=
  total rest fun c => W.level t c - W.need t (dep c) c

/-- Each condition of a family is depended on at a step, by the formation named on it, at a
need it meets. -/
def MetOn (dep : C → F) (rest : List C) (t : Nat) : Prop :=
  ∀ c, c ∈ rest → W.requires t (dep c) c ∧ W.need t (dep c) c ≤ W.level t c

variable {W}

/-- Where each need is met, the family's stock is the needs with the slack. -/
theorem MetOn.stock_eq {dep : C → F} {rest : List C} {t : Nat} (met : W.MetOn dep rest t) :
    W.stock rest t = total rest (fun c => W.need t (dep c) c) + W.slack dep rest t :=
  show total rest (W.level t) = _ from
  (total_congr_on fun c mem => (add_sub_of_le (met c mem).2).symm).trans
    (total_add (fun c => W.need t (dep c) c) (fun c => W.level t c - W.need t (dep c) c) rest)

/-- **Above the slack, a dependence breaks.** Where each condition of a family is depended on at a
need it meets, and the family with another falls across a step by at least what the other rises by
beyond the family's slack, one of those dependences is broken across the step. The condition is
found by deciding each. -/
theorem MetOn.breaks_of_falls {dep : C → F} {ds rest : List C} {t : Nat} (met : W.MetOn dep rest t)
    {k m : Nat}
    (falls : W.stock ds (t + 1) + W.stock rest (t + 1) + k ≤ W.stock ds t + W.stock rest t + m)
    (exceeds : W.stock ds t + W.slack dep rest t + m < W.stock ds (t + 1) + k) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  match @search _ (fun c => W.need t (dep c) c ≤ W.level (t + 1) c) (fun _ => Nat.decLe _ _)
      rest with
  | .inl ⟨c, mem, fell⟩ => ⟨c, mem, (met c mem).1, (met c mem).2, Nat.lt_of_not_le fell⟩
  | .inr held =>
    have needs : total rest (fun c => W.need t (dep c) c) ≤ W.stock rest (t + 1) :=
      total_le rest held
    have within : W.stock ds (t + 1) + k ≤ W.stock ds t + W.slack dep rest t + m :=
      le_of_add_le_add_right (total rest fun c => W.need t (dep c) c)
        (Nat.le_trans (Nat.add_le_add_left needs _)
          (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
            (Nat.le_trans falls (Nat.le_of_eq
              ((congrArg (W.stock ds t + · + m) (met.stock_eq.trans (Nat.add_comm _ _))).trans
                ((congrArg (· + m) (Nat.add_assoc _ _ _).symm).trans
                  (Nat.add_right_comm _ _ _)))))))
    absurd exceeds (Nat.not_lt_of_le within)

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C} {ds rest : List C} {t : Nat}

/-- **The beyond falls by the rise and the loss, exactly.** In a balanced flow, where the family
with the conditions beyond it gains nothing across a step, the family's stock and the beyond's
after the step, with what the whole loses across it, are the two before. -/
theorem Balances.beyond_falls_exactly (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) :
    W.stock ds (t + 1) + W.stock rest (t + 1) + L.lost (ds ++ rest) t =
      W.stock ds t + W.stock rest t :=
  (congrArg (· + L.lost (ds ++ rest) t) (total_append (W.level (t + 1)) rest ds).symm).trans
    ((balances.stock_lost gainless).trans (total_append (W.level t) rest ds))

/-- **Within the inflow, the beyond falls by the rise and the loss.** In a balanced flow, across
every step, the family's stock and the beyond's after the step, with what the whole loses across it,
are at most the two before with the whole's inflow. -/
theorem Balances.beyond_falls_inflow (balances : L.Balances W) :
    W.stock ds (t + 1) + W.stock rest (t + 1) + L.lost (ds ++ rest) t ≤
      W.stock ds t + W.stock rest t + L.inflow (ds ++ rest) t :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + L.lost (ds ++ rest) t)
      (total_append (W.level (t + 1)) rest ds).symm))
    (Nat.le_trans (balances.stock_inflow (ds ++ rest) t)
      (Nat.le_of_eq (congrArg (· + L.inflow (ds ++ rest) t) (total_append (W.level t) rest ds))))

/-- **The beyond falls by at least the rise less the inflow.** -/
theorem Balances.rise_lowers_beyond_inflow (balances : L.Balances W) :
    W.stock ds (t + 1) + W.stock rest (t + 1) ≤
      W.stock ds t + W.stock rest t + L.inflow (ds ++ rest) t :=
  Nat.le_trans (Nat.le_add_right _ _) balances.beyond_falls_inflow

/-- **The beyond falls by at least the rise**, where the whole gains nothing. -/
theorem Balances.rise_lowers_beyond (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) :
    W.stock ds (t + 1) + W.stock rest (t + 1) ≤ W.stock ds t + W.stock rest t :=
  Nat.le_trans balances.rise_lowers_beyond_inflow
    (Nat.le_of_eq ((congrArg (W.stock ds t + W.stock rest t + ·)
      (gainlessOn_iff_inflow.mp gainless)).trans (Nat.add_zero _)))

/-- **Under dissipation, by more than the rise:** at least one unit more for each formation
taking from the whole. -/
theorem Balances.rise_lowers_beyond_dissipating (balances : L.Balances W)
    (dissipates : L.DissipatesOn (ds ++ rest) t) :
    W.stock ds (t + 1) + W.stock rest (t + 1) + L.takers (ds ++ rest) t ≤
      W.stock ds t + W.stock rest t :=
  Nat.le_trans (Nat.add_le_add_left dissipates.takers_le_lost _)
    (Nat.le_of_eq (balances.beyond_falls_exactly dissipates.gainlessOn))

/-- **Above the slack and the inflow, a dependence beyond breaks.** In a balanced flow, where each
condition beyond is depended on at a need it meets, if the family's rise with what the whole loses
exceeds the slack of those dependences and the whole's inflow, one of them is broken across the
step. -/
theorem Balances.breaks_beyond_inflow {dep : C → F} (balances : L.Balances W)
    (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t <
      W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  met.breaks_of_falls balances.beyond_falls_inflow exceeds

/-- **A rise above the slack and the inflow breaks a dependence beyond.** -/
theorem Balances.rise_breaks_beyond_inflow {dep : C → F} (balances : L.Balances W)
    (met : W.MetOn dep rest t)
    (rises : W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t < W.stock ds (t + 1)) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.breaks_beyond_inflow met (Nat.lt_of_lt_of_le rises (Nat.le_add_right _ _))

/-- **Above the slack, a dependence beyond breaks.** In a balanced flow, where the whole gains
nothing across a step and each condition beyond is depended on at a need it meets, if the
family's rise with what the whole loses exceeds the slack of those dependences, one of them is
broken across the step: the case of `Flow.Balances.breaks_beyond_inflow` with no inflow. -/
theorem Balances.breaks_beyond {dep : C → F} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.breaks_beyond_inflow met (Nat.lt_of_le_of_lt (Nat.le_of_eq
    ((congrArg (W.stock ds t + W.slack dep rest t + ·) (gainlessOn_iff_inflow.mp gainless)).trans
      (Nat.add_zero _))) exceeds)

/-- **What nothing depends on counts in full.** Where the whole also holds conditions on which no
dependence is named, their stock counts beside the slack: in a balanced flow where the whole gains
nothing, a rise with the loss above the slack and that stock breaks a dependence beyond. -/
theorem Balances.breaks_beyond_past_free {dep : C → F} {free : List C} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest ++ free) t) (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t + W.stock free t <
      W.stock ds (t + 1) + L.lost (ds ++ rest ++ free) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  have exact : W.stock ds (t + 1) + W.stock rest (t + 1) + W.stock free (t + 1) +
      L.lost (ds ++ rest ++ free) t = W.stock ds t + W.stock rest t + W.stock free t :=
    (congrArg (· + L.lost (ds ++ rest ++ free) t)
      ((congrArg (· + W.stock free (t + 1)) (total_append (W.level (t + 1)) rest ds).symm).trans
        (total_append (W.level (t + 1)) free (ds ++ rest)).symm)).trans
    ((balances.stock_lost gainless).trans ((total_append (W.level t) free (ds ++ rest)).trans
      (congrArg (· + W.stock free t) (total_append (W.level t) rest ds))))
  met.breaks_of_falls
    (Nat.le_trans (Nat.le_add_right _ (W.stock free (t + 1)))
      (Nat.le_of_eq ((Nat.add_right_comm _ _ _).trans exact)))
    exceeds

/-- **A rise above the slack breaks a dependence beyond.** -/
theorem Balances.rise_breaks_beyond {dep : C → F} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (rises : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1)) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.breaks_beyond gainless met (Nat.lt_of_lt_of_le rises (Nat.le_add_right _ _))

/-- **The formation does not go on as it was.** Where activity needs support, under the
conditions of `Flow.Balances.breaks_beyond`, a formation beyond whose dependence breaks is not,
after the step, active with that dependence at a need at least as strong: it ends, or its
dependence weakens or dissolves. -/
theorem Balances.breaks_beyond_unsettles {dep : C → F} (balances : L.Balances W)
    (dependent : W.Dependent) (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c ∧
      ¬ (W.active (t + 1) (dep c) ∧ W.requires (t + 1) (dep c) c ∧
        W.need t (dep c) c ≤ W.need (t + 1) (dep c) c) :=
  match balances.breaks_beyond gainless met exceeds with
  | ⟨c, mem, broken⟩ => ⟨c, mem, broken, fun ⟨active, depends, unchanged⟩ =>
      Nat.not_le_of_gt broken.2.2
        (Nat.le_trans unchanged (dependent (t + 1) (dep c) active c depends))⟩

/-- **With the dependence as it was, the formation ends.** -/
theorem Balances.breaks_beyond_ends {dep : C → F} (balances : L.Balances W)
    (dependent : W.Dependent) (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (fixed : ∀ c, c ∈ rest →
      W.requires (t + 1) (dep c) c ∧ W.need t (dep c) c ≤ W.need (t + 1) (dep c) c)
    (exceeds : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c ∧ ¬ W.active (t + 1) (dep c) :=
  match balances.breaks_beyond_unsettles dependent gainless met exceeds with
  | ⟨c, mem, broken, unsettled⟩ =>
    ⟨c, mem, broken, fun active => unsettled ⟨active, (fixed c mem).1, (fixed c mem).2⟩⟩

/-- **Selection favours breaking beyond, past the inflow.** In a balanced flow, let every condition a
member of a group couples into be in the family, the conditions beyond lie outside it, and each
condition beyond be depended on at a need it meets. Then every selection that holds of the flow's
levels only where the family rises above the slack beyond and the whole's inflow, and holds of them,
holds only where a formation outside the group has its dependence broken, on a condition no member
of the group couples into. -/
theorem favours_breaking_beyond_inflow {dep : C → F} {obs : F → C → Prop} {members : F → Prop}
    {select : (Nat → C → Nat) → Prop} (balances : L.Balances W) (met : W.MetOn dep rest t)
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds)
    (rewards : select W.level →
      W.stock ds t + W.slack dep rest t + L.inflow (ds ++ rest) t < W.stock ds (t + 1))
    (holds : select W.level) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c ∧ ¬ members (dep c) ∧
      ∀ h, members h → ¬ W.CoupledInto obs h c :=
  match balances.rise_breaks_beyond_inflow met (rewards holds) with
  | ⟨c, mem, broken⟩ =>
    have unseen : ∀ h, members h → ¬ W.CoupledInto obs h c :=
      fun h member couples => apart c mem (listed h c member couples)
    ⟨c, mem, broken, fun member => unseen (dep c) member (.inl ⟨t, broken.1⟩), unseen⟩

/-- **Selection favours breaking beyond.** In a balanced flow, let every condition a member of a
group couples into be in the family, the conditions beyond lie outside it, the whole gain
nothing across a step, and each condition beyond be depended on at a need it meets. Then every
selection that holds of the flow's levels only where the family rises above the slack beyond,
and holds of them, holds only where a formation outside the group has its dependence broken, on
a condition no member of the group couples into: the case of `Flow.favours_breaking_beyond_inflow` with no inflow. -/
theorem favours_breaking_beyond {dep : C → F} {obs : F → C → Prop} {members : F → Prop}
    {select : (Nat → C → Nat) → Prop} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds)
    (rewards : select W.level → W.stock ds t + W.slack dep rest t < W.stock ds (t + 1))
    (holds : select W.level) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c ∧ ¬ members (dep c) ∧
      ∀ h, members h → ¬ W.CoupledInto obs h c :=
  favours_breaking_beyond_inflow balances met apart listed (fun held => Nat.lt_of_le_of_lt
    (Nat.le_of_eq ((congrArg (W.stock ds t + W.slack dep rest t + ·)
      (gainlessOn_iff_inflow.mp gainless)).trans (Nat.add_zero _))) (rewards held)) holds

/-! ## Without openness -/

/-- Over a stretch at every step of which a family gains nothing, its stock does not rise: the
case of `Flow.Balances.stock_over_inflow` with no inflow. -/
theorem Balances.stock_not_rises_over (balances : L.Balances W) {cs : List C} {S : Nat} (N : Nat)
    (gainless : ∀ t, S ≤ t → t < S + N → L.GainlessOn cs t) : W.stock cs (S + N) ≤ W.stock cs S :=
  Nat.le_trans (balances.stock_over_inflow cs S N)
    (Nat.le_of_eq ((congrArg (W.stock cs S + ·) (total_eq_zero fun t mem =>
      gainlessOn_iff_inflow.mp (gainless t (between_of_mem_steps mem).1
        (between_of_mem_steps mem).2))).trans (Nat.add_zero _)))

/-- **Over a stretch, the beyond bounds the rise past the inflow.** In a balanced flow, the family's
stock at the end of a stretch, with the beyond's, is at most the two at its start with the whole's
inflow across every step of the stretch. -/
theorem Balances.rise_bounded_by_beyond_inflow (balances : L.Balances W) (S N : Nat) :
    W.stock ds (S + N) + W.stock rest (S + N) ≤
      W.stock ds S + W.stock rest S + total (steps S N) (L.inflow (ds ++ rest)) :=
  Nat.le_trans (Nat.le_of_eq (total_append (W.level (S + N)) rest ds).symm)
    (Nat.le_trans (balances.stock_over_inflow (ds ++ rest) S N)
      (Nat.le_of_eq (congrArg (· + total (steps S N) (L.inflow (ds ++ rest)))
        (total_append (W.level S) rest ds))))

/-- **Without openness, the beyond bounds the rise.** Over a stretch at every step of which the
family with the conditions beyond it gains nothing, the family's stock at the end, with the
beyond's, is at most the two at the start: the family rose by at most what the beyond lost. -/
theorem Balances.rise_bounded_by_beyond (balances : L.Balances W) {S N : Nat}
    (gainless : ∀ t, S ≤ t → t < S + N → L.GainlessOn (ds ++ rest) t) :
    W.stock ds (S + N) + W.stock rest (S + N) ≤ W.stock ds S + W.stock rest S :=
  Nat.le_trans (Nat.le_of_eq (total_append (W.level (S + N)) rest ds).symm)
    (Nat.le_trans (balances.stock_not_rises_over N gainless)
      (Nat.le_of_eq (total_append (W.level S) rest ds)))

/-- **A rise above all that was held needs openness.** Where the family's stock rises over a
stretch above what it and the beyond together held at its start, not every step of the stretch
leaves the whole gaining nothing. -/
theorem Balances.open_of_rise_above (balances : L.Balances W) {S N : Nat}
    (above : W.stock ds S + W.stock rest S < W.stock ds (S + N)) :
    ¬ ∀ t, S ≤ t → t < S + N → L.GainlessOn (ds ++ rest) t :=
  fun gainless => Nat.not_le_of_gt above
    (Nat.le_trans (Nat.le_add_right _ _) (balances.rise_bounded_by_beyond gainless))

/-! ## The share that reaches beyond -/

/-- A formation raises a family across a step: it gives the family more than it takes from it. -/
def RaisesOn (L : Flow F C) (ds : List C) (t : Nat) (f : F) : Prop :=
  total ds (L.take t f) < total ds (L.give t f)

/-- Whether a formation reaches beyond across a step: one where it takes from the conditions
beyond, nothing where it does not. -/
def reach (L : Flow F C) (rest : List C) (t : Nat) (f : F) : Nat :=
  sign (total rest (L.take t f))

/-- A positive reading has sign one. -/
theorem sign_of_pos : ∀ {x : Nat}, 0 < x → sign x = 1
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, _ => rfl

/-- A formation taking from the conditions beyond reaches beyond. -/
theorem reach_of_pos {f : F} (pos : 0 < total rest (L.take t f)) : L.reach rest t f = 1 :=
  sign_of_pos pos

/-- **Raising past what it adds is reaching beyond.** A formation that gives the family more than
it takes from it by more than it gives the whole beyond what it takes from the whole takes from the
conditions beyond. -/
theorem reaches_inflow {f : F}
    (raises : total ds (L.take t f) + excess (total (ds ++ rest) (L.give t f))
      (total (ds ++ rest) (L.take t f)) < total ds (L.give t f)) : 0 < total rest (L.take t f) :=
  have chain : total ds (L.take t f) + excess (total (ds ++ rest) (L.give t f))
      (total (ds ++ rest) (L.take t f)) < total ds (L.take t f) + total rest (L.take t f) +
      excess (total (ds ++ rest) (L.give t f)) (total (ds ++ rest) (L.take t f)) :=
    Nat.lt_of_lt_of_le raises (Nat.le_trans (Nat.le_add_right _ (total rest (L.give t f)))
      (Nat.le_trans (Nat.le_of_eq (total_append (L.give t f) rest ds).symm)
        (Nat.le_trans (le_add_excess _ _) (Nat.le_of_eq (congrArg (· + excess
          (total (ds ++ rest) (L.give t f)) (total (ds ++ rest) (L.take t f)))
          (total_append (L.take t f) rest ds))))))
  Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.add_zero _))
    (Nat.lt_of_lt_of_le chain (Nat.le_of_eq (Nat.add_right_comm _ _ _))))

/-- **Raising from nothing new is reaching beyond.** Where the whole gains nothing across a
step, a formation taking part that gives the family more than it takes from it takes from the
conditions beyond: the case of `Flow.reaches_inflow` with nothing added. -/
theorem RaisesOn.reaches (gainless : L.GainlessOn (ds ++ rest) t) {f : F}
    (present : f ∈ L.present t) (raises : L.RaisesOn ds t f) : 0 < total rest (L.take t f) :=
  reaches_inflow (Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (total ds (L.take t f) + ·)
    (excess_zero_of_le (gainless f present))).trans (Nat.add_zero _))) raises)

/-- A reading at least where another is positive, as signs. -/
theorem sign_le_of_pos : ∀ {x y : Nat}, (0 < x → 0 < y) → sign x ≤ sign y
  | 0, _, _ => Nat.zero_le _
  | n + 1, 0, keeps => absurd (keeps (Nat.succ_pos n)) (Nat.lt_irrefl 0)
  | _ + 1, _ + 1, _ => Nat.le_refl 1

variable {G : SelectionTerm.Generations F}

/-- **The share reaching beyond is never selected against.** Read a generation's members as
formations taking part in the step, and its amount as whether each reaches beyond. Where the
whole gains nothing across the step and more offspring go only to raisers of the family (a
member with more offspring than another raises it), no pair is discordant: the
offspring-weighted share reaching beyond is at least its uniform share. -/
theorem share_not_against (gainless : L.GainlessOn (ds ++ rest) t)
    (present : ∀ p, p ∈ G.family t → p ∈ L.present t)
    (reading : ∀ p, G.amount t p = L.reach rest t p)
    (rewarded : ∀ p q, p ∈ G.family t → q ∈ G.family t →
      G.offspringNumber t p < G.offspringNumber t q → L.RaisesOn ds t q) :
    G.discordAt t = 0 :=
  SelectionTerm.discord_zero_of_below fun p q mp mq below =>
    match Nat.lt_or_ge (G.offspringNumber t q) (G.offspringNumber t p) with
    | .inl more =>
      have one : G.amount t p = 1 := (reading p).trans
        (reach_of_pos ((rewarded q p mq mp more).reaches gainless (present p mp)))
      absurd (Nat.lt_of_lt_of_le below
          (Nat.le_trans (Nat.le_of_eq (reading q)) (sign_le_one _)))
        (Nat.not_lt_of_le (Nat.le_of_eq one.symm))
    | .inr le => le

/-- Where each offspring of a member reaching beyond reaches beyond at the next step,
transmission lowers nothing. -/
theorem lowered_none (reading : ∀ t p, G.amount t p = L.reach rest t p)
    (keeps : ∀ p, p ∈ G.family t → 0 < total rest (L.take t p) →
      ∀ k, k ∈ G.kids t p → 0 < total rest (L.take (t + 1) k)) :
    G.loweredAt t = 0 :=
  SelectionTerm.total_zero_of fun p mp => SelectionTerm.total_zero_of fun k mk =>
    SelectionTerm.excess_of_le (Nat.le_trans (Nat.le_of_eq (reading t p))
      (Nat.le_trans (sign_le_of_pos fun pos => keeps p mp pos k mk)
        (Nat.le_of_eq (reading (t + 1) k).symm)))

/-- **Over generations, the share does not fall.** Where at each step of a stretch the whole
gains nothing, more offspring go only to raisers and each offspring of a reaching member
reaches, the share reaching beyond at the end is at least the share at the start (shares
compared by cross-multiplying). -/
theorem share_not_lower {T : Nat} (reading : ∀ t p, G.amount t p = L.reach rest t p)
    (gainless : ∀ t, t < T → L.GainlessOn (ds ++ rest) t)
    (present : ∀ t, t < T → ∀ p, p ∈ G.family t → p ∈ L.present t)
    (rewarded : ∀ t, t < T → ∀ p q, p ∈ G.family t → q ∈ G.family t →
      G.offspringNumber t p < G.offspringNumber t q → L.RaisesOn ds t q)
    (keeps : ∀ t, t < T → ∀ p, p ∈ G.family t → 0 < total rest (L.take t p) →
      ∀ k, k ∈ G.kids t p → 0 < total rest (L.take (t + 1) k)) :
    G.size T * G.sum 0 ≤ G.size 0 * G.sum T :=
  G.not_lower T fun t lt => G.not_lower_step
    (share_not_against (gainless t lt) (present t lt) (reading t) (rewarded t lt))
    (lowered_none reading (keeps t lt))

/-- **With exact transmission, the share moves only upward.** Under the conditions of
`Flow.share_not_lower` with each offspring reaching exactly where its parent does, where the
share moved over a stretch it rose, and at some step of the stretch more offspring went with
reaching beyond. -/
theorem share_moved_rises {T : Nat} (reading : ∀ t p, G.amount t p = L.reach rest t p)
    (gainless : ∀ t, t < T → L.GainlessOn (ds ++ rest) t)
    (present : ∀ t, t < T → ∀ p, p ∈ G.family t → p ∈ L.present t)
    (rewarded : ∀ t, t < T → ∀ p q, p ∈ G.family t → q ∈ G.family t →
      G.offspringNumber t p < G.offspringNumber t q → L.RaisesOn ds t q)
    (exact : ∀ t, t < T →
      SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    G.size T * G.sum 0 < G.size 0 * G.sum T ∧ ∃ t, t < T ∧ G.discordAt t < G.concordAt t :=
  have unopposed : ∀ t, t < T → G.discordAt t = 0 := fun t lt =>
    share_not_against (gainless t lt) (present t lt) (reading t) (rewarded t lt)
  ⟨Nat.lt_of_le_of_ne (G.not_lower T fun t lt => G.not_lower_step (unopposed t lt)
      (SelectionTerm.lowered_exact (exact t lt))) fun same => moved same.symm,
    match G.moved_by_selection exact moved with
    | ⟨t, lt, differ⟩ => ⟨t, lt, Nat.lt_of_le_of_lt (Nat.le_of_eq (unopposed t lt))
        (Nat.pos_of_ne_zero fun zero => differ ((unopposed t lt).trans zero.symm))⟩⟩

end Flow

namespace DrawnBeyond

open Diversion

/-! ## Witnesses -/

/-- The source, without the store. -/
theorem source_apart : ∀ c, c ∈ [Place.source] → ¬ c ∈ [Place.store] :=
  fun _ mem inside => match mem_cons_cases inside with
    | .inr nothing => nomatch nothing
    | .inl there => match mem_cons_cases mem with
      | .inl here => nomatch here.symm.trans there
      | .inr nothing => nomatch nothing

/-- The taker gives the store what it takes from the source: the whole gains nothing. -/
theorem whole_gainless (L : Flow Formation Place) (t : Nat)
    (taker : total [Place.store, Place.source] (L.give t .taker) ≤
      total [Place.store, Place.source] (L.take t .taker))
    (dweller : total [Place.store, Place.source] (L.give t .dweller) ≤
      total [Place.store, Place.source] (L.take t .dweller)) :
    L.GainlessOn ([Place.store] ++ [Place.source]) t :=
  fun f _ => match f with
    | .taker => taker
    | .dweller => dweller

/-- The dweller, named on every condition. -/
def dwellerOn : Place → Formation := fun _ => .dweller

/-- Where the source stands at the dweller's need or above, the source is depended on at a need
it meets. -/
theorem met_source (level : Nat → Place → Nat) (t : Nat) (stands : 2 ≤ level t .source) :
    (web level).MetOn dwellerOn [Place.source] t :=
  fun _ mem => match mem_cons_cases mem with
    | .inl same => Eq.subst
        (motive := fun x => (web level).requires t .dweller x ∧
          (web level).need t .dweller x ≤ (web level).level t x)
        same.symm ⟨trivial, stands⟩
    | .inr nothing => nomatch nothing

/-- The dweller's dependence on the source is as it was across every step. -/
theorem fixed_source (level : Nat → Place → Nat) (t : Nat) :
    ∀ c, c ∈ [Place.source] → (web level).requires (t + 1) (dwellerOn c) c ∧
      (web level).need t (dwellerOn c) c ≤ (web level).need (t + 1) (dwellerOn c) c :=
  fun _ mem => match mem_cons_cases mem with
    | .inl same => Eq.subst
        (motive := fun x => (web level).requires (t + 1) .dweller x ∧
          (web level).need t .dweller x ≤ (web level).need (t + 1) .dweller x)
        same.symm ⟨trivial, Nat.le_refl 2⟩
    | .inr nothing => nomatch nothing

namespace Dweller

/-- **The rise breaks the dweller's dependence, and the dweller ends.** In `Diversion` the
source stands at the dweller's need, so the slack is nothing; the store's rise breaks the
dweller's dependence on the source, and the dweller, its dependence as it was, is not active
after the step: derived from `Flow.Balances.breaks_beyond_ends`. -/
theorem rise_ends_dweller :
    ∃ c, c ∈ [Place.source] ∧ (web divertedLevel).Broken 0 .dweller c ∧
      ¬ (web divertedLevel).active 1 .dweller :=
  Flow.Balances.breaks_beyond_ends (dep := dwellerOn) diverting_balances
    (dependent divertedLevel)
    (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
    (met_source divertedLevel 0 (Nat.le_refl 2))
    (fixed_source divertedLevel 0)
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self 0) (Nat.le_add_right 1 _))

/-- **The selection through the taker breaks a dependence it does not see.** The store's rise
across the first step is a selection through the taker's coupling, and it holds only where a
formation other than the taker has its dependence broken, on a condition the taker does not
couple into: derived from `Flow.favours_breaking_beyond`. -/
theorem selected_breaks :
    (web divertedLevel).SelectsThrough gauge .taker 1
        (fun l => total [Place.store] (l 0) < total [Place.store] (l 1)) ∧
      ∃ c, c ∈ [Place.source] ∧ (web divertedLevel).Broken 0 .dweller c ∧
        ¬ dwellerOn c = Formation.taker ∧ ¬ (web divertedLevel).CoupledInto gauge .taker c :=
  ⟨Web.raises_selectsThrough fun _ mem => (match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun x => gauge .taker x) same.symm trivial
      | .inr mem => nomatch mem),
   match Flow.favours_breaking_beyond (L := diverting) (W := web divertedLevel)
      (ds := [Place.store]) (rest := [Place.source]) (t := 0) (dep := dwellerOn) (obs := gauge)
      (members := fun h => h = Formation.taker)
      (select := fun l => total [Place.store] (l 0) < total [Place.store] (l 1))
      diverting_balances (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
      (met_source divertedLevel 0 (Nat.le_refl 2))
      source_apart taker_listed (fun lt => lt) (Nat.lt_succ_self 0) with
   | ⟨c, mem, broken, other, unseen⟩ => ⟨c, mem, broken, other, unseen .taker rfl⟩⟩

end Dweller

namespace WithinSlack

/-- The source one above the need: three at the start, two after. -/
def standing : Nat → Nat := Witnesses.profile [3] 2

/-- The levels with the source one above the need, the store raised. -/
def level (t : Nat) : Place → Nat
  | .source => standing t
  | .store => Diversion.raised t

theorem balances : diverting.Balances (web level)
  | 0, .source => rfl
  | _ + 1, .source => rfl
  | 0, .store => rfl
  | _ + 1, .store => rfl

/-- **The slack bound is exact.** With the source one above the dweller's need, the store rises
by exactly the slack, the whole gains nothing, and the dweller's dependence on the source is
kept across the step. -/
theorem within_slack :
    (web level).MetOn dwellerOn [Place.source] 0 ∧
      diverting.GainlessOn ([Place.store] ++ [Place.source]) 0 ∧
      (web level).stock [Place.store] 0 + (web level).slack dwellerOn [Place.source] 0 =
        (web level).stock [Place.store] 1 ∧
      (web level).Kept 0 .dweller .source :=
  ⟨met_source level 0 (Nat.le_succ 2),
   whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0), rfl,
   ⟨Nat.le_succ 2, Nat.le_refl 2⟩⟩

end WithinSlack

namespace Spreading

/-- One unit across each of the first two steps, nothing after. -/
def twice : Nat → Nat := Witnesses.profile [1, 1] 0

/-- Across the first two steps the taker takes one unit of the source and gives one to the
store. -/
def spreading : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => twice t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => twice t
    | .taker, .source => 0
    | .dweller, _ => 0

/-- The source drawn down, two then one then nothing; the store raised, nothing then one then
two. -/
def level (t : Nat) : Place → Nat
  | .source => Witnesses.profile [2, 1] 0 t
  | .store => Witnesses.profile [0, 1] 2 t

theorem balances : spreading.Balances (web level)
  | 0, .source => rfl
  | 1, .source => rfl
  | _ + 2, .source => rfl
  | 0, .store => rfl
  | 1, .store => rfl
  | _ + 2, .store => rfl

/-- At every step the whole gains nothing. -/
theorem gainless (t : Nat) : spreading.GainlessOn ([Place.store] ++ [Place.source]) t :=
  whole_gainless spreading t (Nat.le_of_eq (Nat.add_comm (twice t) 0)) (Nat.le_refl 0)

/-- The taker leaves two offspring across the first step and the dweller none; nothing after. -/
def generations : SelectionTerm.Generations Formation where
  first := [.taker, .dweller]
  kids t f := match t, f with
    | 0, .taker => [.taker, .taker]
    | 0, .dweller => []
    | _ + 1, _ => []
  amount := spreading.reach [Place.source]

/-- More offspring go only to the taker, which raises the store. -/
theorem rewarded : ∀ p q, p ∈ generations.family 0 → q ∈ generations.family 0 →
    generations.offspringNumber 0 p < generations.offspringNumber 0 q →
      spreading.RaisesOn [Place.store] 0 q
  | .taker, .taker, _, _, more => absurd more (Nat.lt_irrefl 2)
  | .taker, .dweller, _, _, more => absurd more (Nat.not_lt_zero 2)
  | .dweller, .taker, _, _, _ => Nat.lt_succ_self 0
  | .dweller, .dweller, _, _, more => absurd more (Nat.lt_irrefl 0)

/-- Each offspring reaches exactly as its parent does. -/
theorem exact : SelectionTerm.Exact (generations.family 0) (generations.kids 0)
    (generations.amount 0) (generations.amount 1)
  | .taker, _, _, mk => match mem_cons_cases mk with
    | .inl same => Eq.subst
        (motive := fun x => generations.amount 1 x = generations.amount 0 .taker) same.symm rfl
    | .inr mk => match mem_cons_cases mk with
      | .inl same => Eq.subst
          (motive := fun x => generations.amount 1 x = generations.amount 0 .taker) same.symm rfl
      | .inr mk => nomatch mk
  | .dweller, _, _, mk => nomatch mk

/-- **The share reaching beyond rises.** From a half (the taker of the taker and the dweller)
to the whole (two takers) across the first step, and the step has more offspring going with
reaching: derived from `Flow.share_moved_rises`. -/
theorem share_rises :
    generations.size 1 * generations.sum 0 < generations.size 0 * generations.sum 1 ∧
      ∃ t, t < 1 ∧ generations.discordAt t < generations.concordAt t :=
  Flow.share_moved_rises (L := spreading) (ds := [Place.store]) (rest := [Place.source])
    (fun _ _ => rfl) (fun t _ => gainless t)
    (fun t lt p mp => match t, lt with
      | 0, _ => match mem_cons_cases mp with
        | .inl same => Eq.subst (motive := fun x => x ∈ spreading.present 0) same.symm (.head _)
        | .inr mp => match mem_cons_cases mp with
          | .inl same => Eq.subst (motive := fun x => x ∈ spreading.present 0) same.symm
              (.tail _ (.head _))
          | .inr mp => nomatch mp
      | n + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero n))
    (fun t lt => match t, lt with
      | 0, _ => rewarded
      | n + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero n))
    (fun t lt => match t, lt with
      | 0, _ => exact
      | n + 1, lt => absurd (Nat.le_of_succ_le_succ lt) (Nat.not_succ_le_zero n))
    (by decide)

/-- **Closed, the store never stands above two**, all the store and the source held at the
start: derived from `Flow.Balances.rise_bounded_by_beyond`. -/
theorem store_bounded (N : Nat) : (web level).stock [Place.store] N ≤ 2 :=
  Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_trans (Nat.le_of_eq (congrArg (fun k => (web level).stock [Place.store] k +
        (web level).stock [Place.source] k) (Nat.zero_add N).symm))
      (Flow.Balances.rise_bounded_by_beyond (S := 0) (N := N) balances
        fun t _ _ => gainless t))

end Spreading

namespace Lapsing

/-- The same selection on the diverting flow, whose draw is not carried past the first step. -/
def generations : SelectionTerm.Generations Formation where
  first := [.taker, .dweller]
  kids := Spreading.generations.kids
  amount := diverting.reach [Place.source]

/-- **Transmission binds.** With the same offspring, more of them going to the taker which
raises the store, nothing is discordant, yet the taker's offspring do not reach beyond and the
share falls from a half to nothing. -/
theorem share_falls :
    generations.discordAt 0 = 0 ∧
      generations.size 0 * generations.sum 1 < generations.size 1 * generations.sum 0 :=
  ⟨Flow.share_not_against (L := diverting) (ds := [Place.store]) (rest := [Place.source])
      (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
      (fun _ mp => match mem_cons_cases mp with
        | .inl same => Eq.subst (motive := fun x => x ∈ diverting.present 0) same.symm (.head _)
        | .inr mp => match mem_cons_cases mp with
          | .inl same => Eq.subst (motive := fun x => x ∈ diverting.present 0) same.symm
              (.tail _ (.head _))
          | .inr mp => nomatch mp)
      (fun _ => rfl)
      (fun p q mp mq more => match p, q, mp, mq, more with
        | .taker, .taker, _, _, more => absurd more (Nat.lt_irrefl 2)
        | .taker, .dweller, _, _, more => absurd more (Nat.not_lt_zero 2)
        | .dweller, .taker, _, _, _ => Nat.lt_succ_self 0
        | .dweller, .dweller, _, _, more => absurd more (Nat.lt_irrefl 0)),
   Nat.lt_succ_of_lt (Nat.lt_succ_self 0)⟩

end Lapsing

end DrawnBeyond

end Becoming
