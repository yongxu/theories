import Becoming.Interdependence
import Becoming.Witnesses

/-!
# Feeding: what is given, carried across steps, and feeders that stand in for one another

`Becoming.Interdependence` reads what a continuation depends on as its feeding closure, with
feeding read as giving, at a common step, to a condition required (`Flow.FedBy`). Its records
leave two questions open: whether delayed conveyance through conditions counts as feeding, and
return under redundant feeders and reserves. This module answers both on flows and webs,
under the local conditions each statement names.

* **Carrying what is given.** What is given to a condition across one step is *carried to* a
  later step when the flow balances on the condition across every step between, and the
  condition stands at every step after the giving through the later one (`Flow.CarriedTo`). At
  the same step, or an earlier one, nothing is asked (`Flow.carriedTo_of_le`). Amounts carry no
  mark of where they came from, so what of an amount given still stands later is a reading. A
  *following* of an amount given is at most that amount after its step, never rises, and is at most what
  stands at each step (`Flow.FollowsGiven`). Some following keeps part of an amount given standing
  at a later step exactly where the amount is positive and the condition stands at every step
  after the step of giving through the later one (`Flow.can_stand_iff`). So, with balance across the
  stretch, a positive amount given is carried exactly where part of it can still stand
  (`Flow.carriedTo_iff_stands`). Balance alone does not carry: where the condition is depleted
  at a step between, no following keeps any of the amount given (`Flow.depleted_keeps_nothing`). An amount
  given exceeding everything taken from the condition across the stretch is carried however the
  taking falls (`Flow.carried_of_given_exceeds`).
* **Feeding across steps.** The continuation of a formation is *fed across steps* by another
  when the other takes part at a step no later and gives to a condition the first then
  requires, carried from the one step to the other (`Flow.FedAcross`). Same-step feeding is
  exactly feeding across steps at delay zero (`Flow.fedBy_iff_fedAcross`). The closure across
  steps (`Flow.ClosedAcross`, `Flow.WithinFeedingAcross`) is by definition the frame's one
  closure under being fed across steps (`Flow.FedFromAcross`), so by that closure's laws it
  holds its formation, is transitive, holds every feeder across steps and is itself closed
  (`Flow.WithinFeedingAcross.refl`, `Flow.WithinFeedingAcross.trans`,
  `Flow.WithinFeedingAcross.of_fedAcross`, `Flow.closedAcross_within`): the least region closed
  under feeding across steps that holds the formation. It contains the feeding closure, the
  closure of a smaller relation (`Flow.WithinFeeding.across`). What lies beyond it gives
  nothing, at any step, to a condition carried to a step at which a member requires it
  (`Flow.beyond_gives_nothing_across`, through `WithinClosure.not_rel`). Where nothing given stands after the step
  it is given across, feeding across steps is feeding at a common step
  (`Flow.fedBy_of_fedAcross_unheld`) and the two closures agree
  (`Flow.withinFeedingAcross_iff_of_unheld`): they part only through what is held.
* **Fed through a store.** In `Provision` a parent gives one unit to a store across the first
  step and is not active after it. Its young is active at the third step, requires the store
  from then on and takes the unit. The parent lies within the young's closure across steps and
  beyond its feeding closure, and the young's support at the step it is active is what the
  parent gave (`Provision.through_store`). So the closure across steps is strictly larger.
* **What consumption needs.** With balance at a condition across a step, the condition meets a
  need after the step exactly where what stands, with what is given across the step, covers
  what is taken across it and the need (`Flow.meets_after_iff_at`). A requirement therefore
  stays met at every later step exactly where every step covers in this way
  (`Flow.stays_met_iff_at`). Over a stretch, it is met at the end exactly where what stood at
  the start, with everything given across the stretch, covers everything taken across it and
  the need (`Flow.meets_over_iff_at`), so a formation active at the end of a stretch, and active
  only where supported, has its need covered so (`Flow.active_covered_at`). Where givers are
  supported (`Flow.GiversSupported`), everything given is given by supported formations, and
  a need is met after a step exactly where what stands plus that supported giving covers the
  need plus what is taken. These equivalences do not infer activity from support. Read the
  other way, `Flow.consumption_ends_with_feeders_at` holds
  constructively: where a formation requires and takes from a condition at each of more steps
  than the condition's level at the start, some supported formation feeds its continuation at
  one of them (`Flow.fed_beyond_level_at`).
* **Feeders that stand in for one another.** Take a part that only gives to a condition. With
  the part withheld, the levels meet a need at a step exactly where the actual level exceeds the
  need by everything the part has given the condition so far (`Flow.meets_without_iff_at`). A
  loss of feeders therefore returns to a dependence exactly where that margin fails. In
  `Redundant` two feeders each give a store one unit at every step, and a consumer takes one.
  With both feeders, or with either alone, the consumer is active and supported at every step
  (`Redundant.either_suffices`). With neither, it is active at the first step only, the end
  arriving within the store's level by `Flow.Balances.consumption_ends_with_feeders`
  (`Redundant.neither_ends`). Holding the rest of the exchange fixed, withholding either feeder
  leaves the consumer admitted at every step, with the levels of the other feeder alone
  (`Redundant.withheld_either`). Withholding both leaves no level path balancing the rest
  (`Redundant.withheld_both`).
* **Reserves.** A reserve defers the end by at most its level and does not escape it. For a
  consumed condition this is `Flow.consumption_ends_with_feeders_at`, attained in
  `Redundant.neither_ends`. For activity beyond support it is `Web.Carries.lasts`, with a held
  condition as the reserve (`Flow.carries_of_held`). Neither is reproved here. The exact form
  for a consumed condition is new: with nothing supported giving to it across a stretch, it
  meets a need at the end exactly where its level at the start covers everything taken across
  the stretch and the need (`Flow.unfed_meets_iff_at`). A store also feeds across steps what it
  was given, as in `Provision`.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D17).**
- Delayed conveyance through a condition counts as feeding where what was given can still
  stand where it is required. The closure across steps reaches formations that filled a store
  and have since ended, which the same-step closure misses.
- The carrying reading is the widest the representation allows: amounts are not marked by
  origin, so the closure across steps over-approximates what a continuation depends on. That
  makes "what lies beyond gives nothing" the stronger claim. A stricter reading, under which
  the amount given stands however the taking falls, is sufficient for carrying
  (`Flow.carried_of_given_exceeds`).
- With redundant feeders, the loss of one need not return. With the rest of the exchange held
  fixed, it returns exactly where the margin above the need is smaller than what the lost
  feeders gave. Stock defers a return, exactly while it covers, and bounds the deferral.

What is not derived:
- which following of an amount given is the actual one, since the representation does not mark amounts
  by origin;
- the exact condition for the stricter reading of carrying;
- that a center represents its closure across steps.

The representation commits to discrete steps and natural quantities. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

namespace Flow

/-! ## Carrying what is given -/

section Carrying

variable (L : Flow F C) (W : Web F C)

/-- What is given to `c` across the step from `s` is *carried to* step `t`: across every step
from `s` before `t` the flow balances on `c`, and `c` stands at every step after `s` through
`t`. Where `t` is not after `s`, nothing is asked. -/
def CarriedTo (c : C) (s t : Nat) : Prop :=
  (∀ k, s ≤ k → k < t → L.BalancesOn W [c] k) ∧ ∀ k, s < k → k ≤ t → 0 < W.level k c

/-- `a` *follows* what `h` gives to `c` across the step from `s`, through step `t`: after the
step it is at most what is given, it does not rise, and at each step through `t` it is at most what
stands. Amounts carry no mark of where they came from; a following is one way of reading
what is given within what stands. -/
def FollowsGiven (h : F) (c : C) (s t : Nat) (a : Nat → Nat) : Prop :=
  a (s + 1) ≤ L.give s h c ∧ (∀ k, s < k → k < t → a (k + 1) ≤ a k) ∧
    ∀ k, s < k → k ≤ t → a k ≤ W.level k c

variable {L W}

/-- At the same step, or an earlier one, nothing is asked: what is given is carried. -/
theorem carriedTo_of_le {c : C} {s t : Nat} (le : t ≤ s) : L.CarriedTo W c s t :=
  ⟨fun _ early below => (Nat.not_le_of_gt (Nat.lt_of_lt_of_le below le) early).elim,
   fun _ after upto => (Nat.not_le_of_gt (Nat.lt_of_lt_of_le after upto) le).elim⟩

/-- A following does not rise: at a later step through `t` it is at most what it was. -/
theorem FollowsGiven.antitone {h : F} {c : C} {s t : Nat} {a : Nat → Nat}
    (follows : L.FollowsGiven W h c s t a) {k : Nat} (after : s < k) :
    ∀ d, k + d ≤ t → a (k + d) ≤ a k
  | 0, _ => Nat.le_refl _
  | d + 1, upto =>
    Nat.le_trans
      (follows.2.1 (k + d) (Nat.lt_of_lt_of_le after (Nat.le_add_right k d))
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self (k + d)) upto))
      (FollowsGiven.antitone follows after d (Nat.le_of_succ_le upto))

/-- Part of what is given can still stand at a later step exactly where it is positive and the
condition stands at every step after the step of giving through the later one: some following
of it is positive there. -/
theorem can_stand_iff {h : F} {c : C} {s t : Nat} (later : s < t) :
    (∃ a, L.FollowsGiven W h c s t a ∧ 0 < a t) ↔
      0 < L.give s h c ∧ ∀ k, s < k → k ≤ t → 0 < W.level k c :=
  ⟨fun ⟨a, follows, stands⟩ =>
    have bound : ∀ k, s < k → k ≤ t → a t ≤ a k := fun k after upto =>
      match le_dest upto with
      | ⟨d, sum⟩ => Eq.subst (motive := fun x => a x ≤ a k) sum.symm
          (follows.antitone after d (Nat.le_of_eq sum.symm))
    ⟨Nat.lt_of_lt_of_le stands (Nat.le_trans (bound (s + 1) (Nat.lt_succ_self s) later)
        follows.1),
     fun k after upto => Nat.lt_of_lt_of_le stands
        (Nat.le_trans (bound k after upto) (follows.2.2 k after upto))⟩,
   fun ⟨gives, stands⟩ =>
    ⟨fun _ => 1, ⟨gives, fun _ _ _ => Nat.le_refl 1, stands⟩, Nat.zero_lt_one⟩⟩

/-- Balance alone does not carry: where the condition is depleted at a step after the step of
giving through a later one, no following keeps any of what is given standing there. -/
theorem depleted_keeps_nothing {h : F} {c : C} {s t k : Nat} (after : s < k) (upto : k ≤ t)
    (depleted : W.level k c = 0) : ¬ ∃ a, L.FollowsGiven W h c s t a ∧ 0 < a t :=
  fun stands => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
    (((can_stand_iff (Nat.lt_of_lt_of_le after upto)).mp stands).2 k after upto)
    (Nat.le_of_eq depleted))

/-- With balance across the stretch, a positive amount given is carried to a later step exactly where
part of it can still stand there. -/
theorem carriedTo_iff_stands {h : F} {c : C} {s t : Nat} (later : s < t)
    (gives : 0 < L.give s h c) (balances : ∀ k, s ≤ k → k < t → L.BalancesOn W [c] k) :
    L.CarriedTo W c s t ↔ ∃ a, L.FollowsGiven W h c s t a ∧ 0 < a t :=
  ⟨fun carried => (can_stand_iff later).mpr ⟨gives, carried.2⟩,
   fun stands => ⟨balances, ((can_stand_iff later).mp stands).2⟩⟩

/-- An amount given exceeding everything taken across the stretch is carried, however the taking falls:
with balance at `c` across each of the `n` steps from `s`, where `h` takes part at `s` and
gives `c` more than is taken from `c` across the stretch, `c` stands at every step after `s`
through `s + n`. -/
theorem carried_of_given_exceeds {h : F} {c : C} {s n : Nat} (present : h ∈ L.present s)
    (balances : ∀ k, s ≤ k → k < s + n → L.BalancesOn W [c] k)
    (exceeds : total (steps s n) (fun k => L.taken k c) < L.give s h c) :
    L.CarriedTo W c s (s + n) :=
  ⟨balances, fun k after upto => match le_dest after with
    | ⟨d, same⟩ =>
      have at_k : s + (d + 1) = k := (Nat.add_right_comm s 1 d).symm.trans same.symm
      have reach : s + (d + 1) ≤ s + n := Nat.le_trans (Nat.le_of_eq at_k) upto
      have over := balance_over_stretch_on (q := fun k => W.level k c)
        (x := fun k => L.taken k c) (y := fun k => L.given k c) s (d + 1)
        fun k from_ below => balances k from_ (Nat.lt_of_lt_of_le below reach) c (.head [])
      have short : d + 1 ≤ n := le_of_add_le_add_right s
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm (d + 1) s))
          (Nat.le_trans reach (Nat.le_of_eq (Nat.add_comm s n))))
      have within : total (steps s (d + 1)) (fun k => L.taken k c) ≤
          total (steps s n) (fun k => L.taken k c) := match le_dest short with
        | ⟨m, whole⟩ => Eq.subst
            (motive := fun r => total (steps s (d + 1)) (fun k => L.taken k c) ≤
              total (steps s r) (fun k => L.taken k c))
            whole.symm (steps_mono _ s (d + 1) m)
      have giving : L.give s h c ≤ total (steps s (d + 1)) (fun k => L.given k c) :=
        Nat.le_trans (le_total_of_mem (q := fun f => L.give s f c) present)
          (Nat.le_add_right (L.given s c) _)
      have chain : total (steps s (d + 1)) (fun k => L.taken k c) <
          W.level (s + (d + 1)) c + total (steps s (d + 1)) (fun k => L.taken k c) :=
        Nat.lt_of_le_of_lt within (Nat.lt_of_lt_of_le exceeds
          (Nat.le_trans giving (Nat.le_trans (Nat.le_add_left _ (W.level s c))
            (Nat.le_of_eq over.symm))))
      Eq.subst (motive := fun r => 0 < W.level r c) at_k
        (Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le chain
          (Nat.le_of_eq ((congrArg (· + _) zero).trans (Nat.zero_add _)))))⟩

end Carrying

/-! ## Feeding across steps -/

section Across

variable (L : Flow F C) (W : Web F C)

/-- The continuation of `e`'s formation is *fed across steps* by `e'`: `e'`'s formation takes
part at its step, no later than `e`'s, and gives to a condition that `e`'s formation requires
at its step, carried from the one step to the other. -/
def FedAcross (e e' : F × Nat) : Prop :=
  e'.2 ≤ e.2 ∧ ∃ c, W.requires e.2 e.1 c ∧ e'.1 ∈ L.present e'.2 ∧ 0 < L.give e'.2 e'.1 c ∧
    L.CarriedTo W c e'.2 e.2

/-- `g`'s continuation is fed across steps from `h`: at some step `h` feeds it across steps
from a step no later. -/
def FedFromAcross (g h : F) : Prop :=
  ∃ s t, L.FedAcross W (g, t) (h, s)

/-- A region of formations is closed under feeding across steps: whatever feeds the
continuation of a member across steps is a member. The frame's closedness under being fed
across steps. -/
def ClosedAcross (region : F → Prop) : Prop :=
  ClosedUnder (L.FedFromAcross W) region

/-- `g` lies within the closure across steps of `f`: the frame's closure under being fed across
steps, every region closed under feeding across steps that holds `f` holding `g`. -/
def WithinFeedingAcross (f g : F) : Prop :=
  WithinClosure (L.FedFromAcross W) f g

variable {L W}

/-- Same-step feeding is feeding across steps at delay zero. -/
theorem fedBy_iff_fedAcross {e e' : F × Nat} :
    L.FedBy W e e' ↔ e.2 = e'.2 ∧ L.FedAcross W e e' :=
  ⟨fun ⟨same, c, requires, present, gives⟩ =>
    ⟨same, Nat.le_of_eq same.symm, c, requires, present, gives,
      carriedTo_of_le (Nat.le_of_eq same)⟩,
   fun ⟨same, _, c, requires, present, gives, _⟩ => ⟨same, c, requires, present, gives⟩⟩

/-- Feeding at a common step is feeding across steps. -/
theorem FedAcross.of_fedBy {e e' : F × Nat} (fed : L.FedBy W e e') : L.FedAcross W e e' :=
  (fedBy_iff_fedAcross.mp fed).2

/-- A region closed under feeding across steps is closed under feeding. -/
theorem ClosedAcross.fedClosed {region : F → Prop} (closed : L.ClosedAcross W region) :
    L.FedClosed W region :=
  fun g h holds ⟨t, fed⟩ => closed g h holds ⟨t, t, FedAcross.of_fedBy fed⟩

/-- The closure across steps contains the feeding closure. -/
theorem WithinFeeding.across {f g : F} (within : L.WithinFeeding W f g) :
    L.WithinFeedingAcross W f g :=
  WithinClosure.mono (fun _ _ ⟨t, fed⟩ => ⟨t, t, FedAcross.of_fedBy fed⟩) within

/-- A formation lies within its own closure across steps. -/
theorem WithinFeedingAcross.refl (f : F) : L.WithinFeedingAcross W f f :=
  WithinClosure.refl f

/-- The closure across steps is transitive. -/
theorem WithinFeedingAcross.trans {f g h : F} (first : L.WithinFeedingAcross W f g)
    (second : L.WithinFeedingAcross W g h) : L.WithinFeedingAcross W f h :=
  WithinClosure.trans first second

/-- What feeds a formation's continuation across steps lies within its closure across
steps. -/
theorem WithinFeedingAcross.of_fedAcross {e e' : F × Nat} (fed : L.FedAcross W e e') :
    L.WithinFeedingAcross W e.1 e'.1 :=
  WithinClosure.of_rel ⟨e'.2, e.2, fed⟩

/-- The closure across steps of a formation is closed under feeding across steps. -/
theorem closedAcross_within (f : F) : L.ClosedAcross W (L.WithinFeedingAcross W f) :=
  closedUnder_withinClosure f

/-- What lies beyond a formation's closure across steps gives nothing, at any step, to a
condition carried from that step to a later or equal one at which a member requires it. -/
theorem beyond_gives_nothing_across {f g h : F} (within : L.WithinFeedingAcross W f g)
    (beyond : ¬ L.WithinFeedingAcross W f h) {s t : Nat} {c : C} (early : s ≤ t)
    (requires : W.requires t g c) (carried : L.CarriedTo W c s t)
    (present : h ∈ L.present s) : L.give s h c = 0 :=
  eq_zero_of_not_pos fun gives =>
    WithinClosure.not_rel within beyond ⟨s, t, early, c, requires, present, gives, carried⟩

/-- Where nothing given stands after the step it is given across, feeding across steps is
feeding at a common step. -/
theorem fedBy_of_fedAcross_unheld
    (unheld : ∀ s h c, h ∈ L.present s → 0 < L.give s h c → W.level (s + 1) c = 0)
    {e e' : F × Nat} (fed : L.FedAcross W e e') : L.FedBy W e e' :=
  match fed with
  | ⟨early, c, requires, present, gives, carried⟩ => match Nat.lt_or_ge e'.2 e.2 with
    | .inl before => (Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
        (carried.2 (e'.2 + 1) (Nat.lt_succ_self _) before)
        (Nat.le_of_eq (unheld e'.2 e'.1 c present gives)))).elim
    | .inr after => ⟨Nat.le_antisymm after early, c, requires, present, gives⟩

/-- So, where nothing given stands after the step it is given across, the closure across
steps is the feeding closure: the two part only through what is held. -/
theorem withinFeedingAcross_iff_of_unheld
    (unheld : ∀ s h c, h ∈ L.present s → 0 < L.give s h c → W.level (s + 1) c = 0)
    {f g : F} : L.WithinFeedingAcross W f g ↔ L.WithinFeeding W f g :=
  ⟨WithinClosure.mono fun _ _ ⟨s, _, fed⟩ => match fedBy_of_fedAcross_unheld unheld fed with
     | ⟨same, c, requires, present, gives⟩ => ⟨s, rfl, c, same ▸ requires, present, gives⟩,
   WithinFeeding.across⟩

end Across

/-! ## What consumption needs -/

section Consumption

variable {L : Flow F C} {W : Web F C}

/-- One step, exactly: with balance at `c` across the step from `t`, `c` meets `m` after the
step exactly where what stands at `t`, with what is given across the step, covers what is
taken across it and `m`. -/
theorem meets_after_iff_at {c : C} {t m : Nat} (balances : L.BalancesOn W [c] t) :
    m ≤ W.level (t + 1) c ↔ m + L.taken t c ≤ W.level t c + L.given t c :=
  ⟨fun meets => Nat.le_trans (Nat.add_le_add_right meets (L.taken t c))
      (Nat.le_of_eq (balances c (.head []))),
   fun covers => le_of_add_le_add_right (L.taken t c)
      (Nat.le_trans covers (Nat.le_of_eq (balances c (.head [])).symm))⟩

/-- A requirement stays met: with balance at `c` across every step from `T`, `c` meets `m`
after every step from `T` exactly where, at every such step, what stands with what is given
covers what is taken and `m`. -/
theorem stays_met_iff_at {c : C} {T m : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W [c] t) :
    (∀ t, T ≤ t → m ≤ W.level (t + 1) c) ↔
      ∀ t, T ≤ t → m + L.taken t c ≤ W.level t c + L.given t c :=
  ⟨fun met t later => (meets_after_iff_at (balances t later)).mp (met t later),
   fun covers t later => (meets_after_iff_at (balances t later)).mpr (covers t later)⟩

/-- Over a stretch, exactly: with balance at `c` across each of the `n` steps from `T`, `c`
meets `m` at `T + n` exactly where what stood at `T`, with everything given across the
stretch, covers everything taken across it and `m`. -/
theorem meets_over_iff_at {c : C} {T n m : Nat}
    (balances : ∀ t, T ≤ t → t < T + n → L.BalancesOn W [c] t) :
    m ≤ W.level (T + n) c ↔
      m + total (steps T n) (fun t => L.taken t c) ≤
        W.level T c + total (steps T n) (fun t => L.given t c) :=
  have over := balance_over_stretch_on (q := fun t => W.level t c) (x := fun t => L.taken t c)
    (y := fun t => L.given t c) T n fun t from_ below => balances t from_ below c (.head [])
  ⟨fun meets => Nat.le_trans (Nat.add_le_add_right meets _) (Nat.le_of_eq over),
   fun covers => le_of_add_le_add_right _ (Nat.le_trans covers (Nat.le_of_eq over.symm))⟩

/-- A formation active at `T + n`, active there only where supported and requiring `c` there,
has what stood at `T`, with everything given across the `n` steps from `T`, covering
everything taken across them and its need. -/
theorem active_covered_at {c : C} {g : F} {T n : Nat}
    (balances : ∀ t, T ≤ t → t < T + n → L.BalancesOn W [c] t)
    (dependent : W.active (T + n) g → W.Supported (T + n) g)
    (active : W.active (T + n) g) (requires : W.requires (T + n) g c) :
    W.need (T + n) g c + total (steps T n) (fun t => L.taken t c) ≤
      W.level T c + total (steps T n) (fun t => L.given t c) :=
  (meets_over_iff_at balances).mp (dependent active c requires)

/-- Without a supported feeder, a reserve defers the end exactly while it covers. With balance
at `c` across each of the `n` steps from `T`, whatever gives to `c` there supported, and nothing
supported giving to `c` there, `c` meets `m` at `T + n` exactly where its level at `T` covers
everything taken across the stretch and `m`. -/
theorem unfed_meets_iff_at {c : C} {T n m : Nat}
    (balances : ∀ t, T ≤ t → t < T + n → L.BalancesOn W [c] t)
    (givers : ∀ t, T ≤ t → t < T + n → L.GiversSupported W t c)
    (unfed : ∀ t f, T ≤ t → t < T + n → f ∈ L.present t → W.Supported t f →
      L.give t f c = 0) :
    m ≤ W.level (T + n) c ↔ m + total (steps T n) (fun t => L.taken t c) ≤ W.level T c :=
  have none : total (steps T n) (fun t => L.given t c) = 0 :=
    total_eq_zero fun t mem => total_eq_zero fun f present => eq_zero_of_not_pos fun gives =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq
        (unfed t f (steps_mem mem) (steps_within mem) present
          (givers t (steps_mem mem) (steps_within mem) f present gives))))
  (meets_over_iff_at balances).trans
    ⟨fun covers => Nat.le_trans covers (Nat.le_of_eq (congrArg (W.level T c + ·) none)),
     fun covers => Nat.le_trans covers (Nat.le_of_eq (congrArg (W.level T c + ·) none).symm)⟩

/-- Consumption beyond what stands has a supported feeder: `consumption_ends_with_feeders_at`
read the other way, with the feeder exhibited. With balance at `c` across each of the `n` steps
from `T`, whatever gives to `c` there supported, let `g` require `c` and take part and take from
it at each of those steps. If the level of `c` at `T` is below `n`, some supported formation feeds
`g`'s continuation at one of those steps. -/
theorem fed_beyond_level_at {c : C} {g : F} {T n : Nat}
    (balances : ∀ t, T ≤ t → t < T + n → L.BalancesOn W [c] t)
    (givers : ∀ t, T ≤ t → t < T + n → L.GiversSupported W t c)
    (requires : ∀ t, T ≤ t → t < T + n → W.requires t g c)
    (consumes : ∀ t, T ≤ t → t < T + n → g ∈ L.present t ∧ 0 < L.take t g c)
    (beyond : W.level T c < n) :
    ∃ t f, T ≤ t ∧ t < T + n ∧ L.FedBy W (g, t) (f, t) ∧ W.Supported t f :=
  have over := balance_over_stretch_on (q := fun t => W.level t c) (x := fun t => L.taken t c)
    (y := fun t => L.given t c) T n fun t from_ below => balances t from_ below c (.head [])
  have drawn : n ≤ total (steps T n) (fun t => L.taken t c) :=
    Nat.le_trans (Nat.le_of_eq ((steps_length T n).symm.trans (total_ones (steps T n)).symm))
      (total_le (steps T n) fun t mem =>
        have consuming := consumes t (steps_mem mem) (steps_within mem)
        Nat.le_trans consuming.2 (le_total_of_mem (q := fun f => L.take t f c) consuming.1))
  have fed : 0 < total (steps T n) (fun t => L.given t c) :=
    Nat.pos_of_ne_zero fun none => Nat.not_le_of_gt beyond
      (Nat.le_trans drawn (Nat.le_trans (Nat.le_add_left _ (W.level (T + n) c))
        (Nat.le_of_eq (over.trans (congrArg (W.level T c + ·) none)))))
  match total_pos (steps T n) fed with
  | ⟨t, mem, given⟩ => match total_pos (q := fun f => L.give t f c) (L.present t) given with
    | ⟨f, present, gives⟩ =>
      ⟨t, f, steps_mem mem, steps_within mem,
       ⟨rfl, c, requires t (steps_mem mem) (steps_within mem), present, gives⟩,
       givers t (steps_mem mem) (steps_within mem) f present gives⟩

/-- Feeders that stand in for one another. Let `l` be the levels without a part that takes
nothing from `c` before `t`, with balance at `c` across every step before `t`. They meet `m`
at `t` exactly where the actual level of `c` at `t` exceeds `m` by everything the part has
given `c` so far. -/
theorem meets_without_iff_at {part : F → Bool} {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {c : C} {t m : Nat}
    (balances : ∀ s, s < t → L.BalancesOn W [c] s)
    (only : ∀ s, s < t → L.partTaken part s c = 0) :
    m ≤ l t c ↔ m + total (steps 0 t) (fun s => L.partGiven part s c) ≤ W.level t c :=
  have untaken : total (steps 0 t) (fun s => L.partTaken part s c) = 0 :=
    total_eq_zero fun s mem =>
      only s (Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add t)))
  have difference : W.level t c = l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
    (congrArg (W.level t c + ·) untaken).symm.trans (withheld_at without t balances)
  ⟨fun meets => Nat.le_trans (Nat.add_le_add_right meets _) (Nat.le_of_eq difference.symm),
   fun covers => le_of_add_le_add_right _ (Nat.le_trans covers (Nat.le_of_eq difference))⟩

end Consumption

end Flow

/-! ## Witnesses -/

/-! A parent fills a store and ends; its young, arising later, draws on it. -/

namespace Provision

/-- A parent and its young. -/
inductive Formation where
  | parent
  | young

/-- What the parent gives the store: one unit across the first step. -/
def gift : Nat → Nat := Witnesses.profile [1] 0

/-- What the young takes from the store: one unit across the third step. -/
def use : Nat → Nat := Witnesses.profile [0, 0, 1] 0

/-- The store: nothing at the start, one unit at the second and third steps, then nothing. -/
def stored : Nat → Nat := Witnesses.profile [0, 1, 1] 0

/-- The first step. -/
def atFirst : Nat → Prop := Witnesses.profile [True] False

/-- The third step. -/
def atThird : Nat → Prop := Witnesses.profile [False, False, True] False

/-- From the third step on. -/
def fromThird : Nat → Prop := Witnesses.profile [False, False] True

/-- Both take part at every step; the parent gives the store a unit across the first step,
and the young takes it across the third. -/
def flow : Flow Formation Unit where
  present _ := [.parent, .young]
  take t f _ := match f with
    | .parent => 0
    | .young => use t
  give t f _ := match f with
    | .parent => gift t
    | .young => 0

/-- The parent is active at the first step and requires nothing. The young is active at the
third step, requires the store from then on at need one, and draws on it there. -/
def web : Web Formation Unit where
  level t _ := stored t
  active t f := match f with
    | .parent => atFirst t
    | .young => atThird t
  requires t f _ := match f with
    | .parent => False
    | .young => fromThird t
  need _ _ _ := 1
  draws t f _ := match f with
    | .parent => False
    | .young => atThird t

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | 2, () => rfl
  | _ + 3, () => rfl

theorem acting : flow.Acting web
  | 0, .parent, _, _, _ => trivial
  | _ + 1, .parent, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, .young, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem taking : flow.Taking web
  | _, .parent, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 0, .young, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 1, .young, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | 2, .young, _, _, _ => ⟨trivial, trivial⟩
  | _ + 3, .young, _, _, takes => absurd takes (Nat.lt_irrefl 0)

theorem dependent : web.Dependent
  | _, .parent, _ => fun _ no => nomatch no
  | 0, .young, idle => nomatch idle
  | 1, .young, idle => nomatch idle
  | 2, .young, _ => fun _ _ => Nat.le_refl 1
  | _ + 3, .young, idle => nomatch idle

/-- The parent's unit is carried from the first step to the third. -/
theorem carried : flow.CarriedTo web () 0 2 :=
  ⟨fun k _ _ => balances.on [()] k,
   fun k after upto => match k, after, upto with
    | 0, after, _ => absurd after (Nat.lt_irrefl 0)
    | 1, _, _ => Nat.zero_lt_one
    | 2, _, _ => Nat.zero_lt_one
    | k + 3, _, upto => absurd upto
        (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_add_left 3 k)))⟩

/-- The parent feeds the young's continuation at the third step across steps. -/
theorem fed_across : flow.FedAcross web (.young, 2) (.parent, 0) :=
  ⟨Nat.zero_le 2, (), trivial, .head _, Nat.zero_lt_one, carried⟩

/-- The young alone is closed under feeding: nothing gives to the store at a step at which
the young requires it. -/
theorem young_alone : flow.FedClosed web fun f => f = .young
  | .parent, _, holds, _ => Formation.noConfusion holds
  | .young, _, _, ⟨0, _, _, requires, _, _⟩ => nomatch requires
  | .young, _, _, ⟨1, _, _, requires, _, _⟩ => nomatch requires
  | .young, .young, _, _ => rfl
  | .young, .parent, _, ⟨_ + 2, _, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)

/-- The parent lies beyond the young's feeding closure. -/
theorem parent_beyond : ¬ flow.WithinFeeding web .young .parent :=
  fun within => Formation.noConfusion (within (fun f => f = .young) young_alone rfl)

/-- Fed through a store. The flow balances, only active formations give, and only active
formations take, and only from what they draw on; activity needs support. The parent feeds
the young's continuation across steps, so it lies within the young's closure across steps,
and beyond its feeding closure. The parent is not active after the first step. The young is
active and supported at the third step, where the store holds what the parent gave. -/
theorem through_store :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
      flow.FedAcross web (.young, 2) (.parent, 0) ∧
      flow.WithinFeedingAcross web .young .parent ∧ ¬ flow.WithinFeeding web .young .parent ∧
      (∀ t, 1 ≤ t → ¬ web.active t .parent) ∧ web.active 2 .young ∧
      web.Supported 2 .young ∧ web.level 2 () = flow.give 0 .parent () :=
  ⟨balances, acting, taking, dependent, fed_across,
   Flow.WithinFeedingAcross.of_fedAcross fed_across, parent_beyond,
   fun t later active => match t, later, active with
    | 0, below, _ => Nat.not_succ_le_zero 0 below
    | _ + 1, _, idle => (nomatch idle),
   trivial, dependent 2 .young trivial, rfl⟩

end Provision

/-! Two feeders give a store; a consumer draws on it. -/

namespace Redundant

/-- Two feeders and a consumer. -/
inductive Formation where
  | first
  | second
  | consumer

/-- One unit where a feeder gives, none where it does not. -/
def unit : Bool → Nat
  | true => 1
  | false => 0

/-- The consumer draws one unit at every step while some feeder gives, and with neither at the
first step only. -/
def draw : Bool → Bool → Nat → Nat
  | true, _, _ => 1
  | false, true, _ => 1
  | false, false, 0 => 1
  | false, false, _ + 1 => 0

/-- The store: rising by one at every step with both feeders, kept at one with either alone,
and spent across the first step with neither. -/
def stands : Bool → Bool → Nat → Nat
  | true, true, t => t + 1
  | true, false, _ => 1
  | false, true, _ => 1
  | false, false, 0 => 1
  | false, false, _ + 1 => 0

/-- All take part at every step. The first feeder gives the store one unit at every step where
`a`, the second where `b`, and the consumer takes its draw. -/
def flow (a b : Bool) : Flow Formation Unit where
  present _ := [.first, .second, .consumer]
  take t f _ := match f with
    | .first => 0
    | .second => 0
    | .consumer => draw a b t
  give _ f _ := match f with
    | .first => unit a
    | .second => unit b
    | .consumer => 0

/-- The feeders require nothing and are active where they give; the consumer requires the
store at need one, draws on it, and is active where it draws. -/
def web (a b : Bool) : Web Formation Unit where
  level t _ := stands a b t
  active t f := match f with
    | .first => a = true
    | .second => b = true
    | .consumer => 0 < draw a b t
  requires _ f _ := match f with
    | .first => False
    | .second => False
    | .consumer => True
  need _ _ _ := 1
  draws _ f _ := match f with
    | .first => False
    | .second => False
    | .consumer => True

theorem balances : ∀ a b, (flow a b).Balances (web a b)
  | true, true, _, () => rfl
  | true, false, _, () => rfl
  | false, true, _, () => rfl
  | false, false, 0, () => rfl
  | false, false, _ + 1, () => rfl

theorem acting : ∀ a b, (flow a b).Acting (web a b)
  | true, _, _, .first, _, _, _ => rfl
  | false, _, _, .first, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, true, _, .second, _, _, _ => rfl
  | _, false, _, .second, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _, _, _, .consumer, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem taking : ∀ a b, (flow a b).Taking (web a b)
  | _, _, _, .first, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, _, _, .second, _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | _, _, _, .consumer, _, _, takes => ⟨takes, trivial⟩

theorem dependent : ∀ a b, (web a b).Dependent
  | _, _, _, .first, _ => fun _ no => nomatch no
  | _, _, _, .second, _ => fun _ no => nomatch no
  | true, true, t, .consumer, _ => fun _ _ => Nat.succ_le_succ (Nat.zero_le t)
  | true, false, _, .consumer, _ => fun _ _ => Nat.le_refl 1
  | false, true, _, .consumer, _ => fun _ _ => Nat.le_refl 1
  | false, false, 0, .consumer, _ => fun _ _ => Nat.le_refl 1
  | false, false, _ + 1, .consumer, idle => absurd idle (Nat.lt_irrefl 0)

/-- Either suffices. With both feeders, or with either alone, the consumer is active and
supported at every step. -/
theorem either_suffices : ∀ a b, (a = true ∨ b = true) → ∀ t,
    (web a b).active t .consumer ∧ (web a b).Supported t .consumer
  | true, true, _, t => ⟨Nat.zero_lt_one, dependent true true t .consumer Nat.zero_lt_one⟩
  | true, false, _, t => ⟨Nat.zero_lt_one, dependent true false t .consumer Nat.zero_lt_one⟩
  | false, true, _, t => ⟨Nat.zero_lt_one, dependent false true t .consumer Nat.zero_lt_one⟩
  | false, false, .inl no, _ => Bool.noConfusion no
  | false, false, .inr no, _ => Bool.noConfusion no

/-- Neither: the end within the store's level. With neither feeder, the consumer is active at
the first step and at no later step. By `Flow.Balances.consumption_ends_with_feeders`, with
nothing feeding its continuation, it is active for at most as many consecutive steps as the
store's level at the start, one, which it attains. -/
theorem neither_ends :
    (web false false).active 0 .consumer ∧
      (∀ t, 1 ≤ t → ¬ (web false false).active t .consumer) ∧
      ∀ n, (∀ k, k < n → (web false false).active (0 + k) .consumer) →
        n ≤ (web false false).level 0 () :=
  ⟨Nat.zero_lt_one,
   fun t later active => match t, later, active with
    | 0, below, _ => Nat.not_succ_le_zero 0 below
    | _ + 1, _, idle => absurd idle (Nat.lt_irrefl 0),
   (balances false false).consumption_ends_with_feeders (acting false false)
    (dependent false false) (c := ()) (g := .consumer) (T := 0)
    (fun _ _ _ => trivial)
    (fun _ f _ fed _ => match f, fed with
      | .first, ⟨_, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
      | .second, ⟨_, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
      | .consumer, ⟨_, _, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0))
    (fun _ _ active => ⟨.tail _ (.tail _ (.head _)), active⟩)⟩

/-- The first feeder, as a part. -/
def firstPart : Formation → Bool
  | .first => true
  | .second => false
  | .consumer => false

/-- The second feeder, as a part. -/
def secondPart : Formation → Bool
  | .first => false
  | .second => true
  | .consumer => false

/-- Both feeders, as a part. -/
def bothParts : Formation → Bool
  | .first => true
  | .second => true
  | .consumer => false

/-- Withholding either feeder, the rest of the exchange held fixed. With both feeders, the
levels without the first, and those without the second, stand at one at every step: the
levels with the other feeder alone. They admit the consumer at every step. -/
theorem withheld_either :
    (flow true true).WithheldLevels firstPart (web true true) (fun _ _ => 1) ∧
      (flow true true).WithheldLevels secondPart (web true true) (fun _ _ => 1) ∧
      (∀ t, (web false true).level t () = 1 ∧ (web true false).level t () = 1) ∧
      ∀ t, (web true true).Admits (fun _ => 1) t .consumer :=
  ⟨⟨fun _ () => rfl, fun () => rfl⟩, ⟨fun _ () => rfl, fun () => rfl⟩,
   fun _ => ⟨rfl, rfl⟩, fun _ _ _ => Nat.le_refl 1⟩

/-- Withholding both feeders, the rest of the exchange held fixed, no level path balances: the
consumer's draw has nothing to come from after the first step. -/
theorem withheld_both : ¬ ∃ l, (flow true true).WithheldLevels bothParts (web true true) l
  | ⟨l, without⟩ =>
    have first : l 1 () + 1 = l 0 () + 0 := without.1 0 ()
    have second : l 2 () + 1 = l 1 () + 0 := without.1 1 ()
    have spent : l 1 () = 0 := add_right_cancel 1 (first.trans (without.2 ()))
    Nat.noConfusion (second.trans spent)

end Redundant

end Becoming
