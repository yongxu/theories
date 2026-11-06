import Becoming.IdentificationRuns
import Becoming.ClosedCapture
import Becoming.RuleShaping

/-!
# Capture by counted choices: a chooser reading what couples in, its rule read from the count of its choices

Three laws of the spine (selection through couplings, capture through the rule, closed capture) read
on a chooser of the kind that active inference, the process theory of the free-energy principle,
describes. No probability is used: what the chooser keeps is any fold of the prefix of what couples
in, and a standing score enters as two whole-number weights.

* **A chooser reading what couples in selects through its couplings.** The choice made from a fold
  of the prefix of what couples into a formation, whatever the fold and whatever the choice, is a
  selection through the formation's couplings up to each step (`selectsThrough`, by
  `Web.selectsThrough_iff_prefix`). Histories alike through the couplings are chosen alike
  (`chosen_alike`); a part acting only beyond the coupling closure does not change the choice, under
  the hypotheses of `Flow.unselected_beyond_coupling` (`unchosen_beyond_coupling`). Choosers sharing
  their folds select through their pooled couplings, and a part beyond the pool's coupling closure
  does not change their choice (`pooled_selectsThrough`, `pooled_unchosen_beyond`, by
  `Flow.unselected_beyond_pool`). This part is near-definitional: the free-energy principle's sparse
  coupling (internal states read external states only through blanket states) already says as much.
  The blanket condition, a conditional independence in a steady-state density, is a further property
  not stated here. Active states are not among what couples in, and a sampled action must be listed
  among what couples in for these laws to apply.
* **A rule read from the count of its choices locks.** The chooser takes the first of two policies
  where its rule weighs it at least as much as the second, and that policy's count rises by one
  (`choose`); the rule is read from the counts weighted by a standing score, `κc` for the first
  policy and `κo` for the second (`weighted`, which does not read the rule in force). Choosing by a
  favouring rule raises the share it reads, strictly (`choose_raises`, `choose_rises_strictly`), and
  the reading is monotone in the share (`weighted_reads`). With the rule in force read from the counts
  at the start, along every schedule of reading and under a standing score, the threshold
  `κo · other ≤ κc · carrier` divides the counts into two regions the course never leaves:
  - at or above it the chooser takes the first policy at every step and neither the share nor the
    rule falls (`counted_locks`, `counted_chooses`), also where the score favours the second policy
    (`κc < κo`);
  - below it the rule favours the second policy strictly, the chooser takes the second policy at
    every step, and neither the share nor the rule rises (`counted_locks_down`,
    `counted_chooses_down`).
  Ties go to the first policy by `choose`; with `κc = 0` or no count of the first policy, the second
  is taken for good. What carries the course across the threshold is a change of the counts (forced
  or sampled choices of the other policy, `Witness.moved_locks_down`), of the score, of how the rule
  reads or of the choice rule. A rule in force not read from the counts, such as one left from an
  older score, acts until the first reading step and can carry the counts across
  (`Witness.Stale`): the in-sync start is a hypothesis of every law above.
* **Counted from the posterior at the time of choosing, the share falls.** Selection by the fixed
  rule `byScore κc κo s pos`, `⟨s + κc, s + κo⟩`, is one step of adding the posterior at the time of
  choosing to scaled counts. With learning rate `η`, adding the posterior is this step with
  `s = Z/η`, `Z = κc · carrier + κo · other`, where that is a whole number, so `s` changes from step
  to step. A score favouring the second policy lowers the first policy's share strictly at that
  step, carriers present (`posterior_count_falls`, by `RuleShaping.falls_strictly`), and along a
  course with a positive fixed scale at every step (`posterior_course_falls`, a geometric course,
  not additive counting's timescale). A falling share need not cross the threshold soon: in the
  witness the weighted rule still favours the first policy after the first step, by a tie, and the
  second from the second step (`Witness.after_one_still_first`, `Witness.after_two_turns`).
* **The lock outlives a loss it does not read.** Joined to a coordinate that rises by at least one
  at every step and that neither the counts nor the score reads, from counts at or above the
  threshold with the rule read from them the coordinate passes every bound while the course stays
  locked (`counted_outlives_loss`, by `ClosedCapture.lock_outlives_loss`).

**Correspondence (an AI reading).** In discrete active inference the prior over policies, the
habit, is learned by adding the posterior over policies at the end of each trial (Friston and others
2016, §2.4; in SPM12's `spm_MDP_VB`, `MDP.e = MDP.e + u(:,T)`). Where a trial's outcomes reveal the
policy pursued, that posterior is concentrated on it, so the count is close to the count of the
executed policy, which is `choose`'s count; policies that explain the trial equally share the
count, which is not modelled here. The choice at a step is read as the posterior's argmax, the limit
of high action precision; at finite precision a sampled choice of the other policy is a change of
the counts. The weights `κc` and `κo` stand for the posterior's terms other than the prior. SPM's
prior is the counts' expected log (`ψ(e) − ψ(Σe)`), not the counts, so the threshold here is the
model's and not SPM's. `byScore`, counting the posterior at the time of choosing, is a contrast case
that no implementation cited here uses. The lock is the known lock-in of increasing returns (Arthur
1989), counting the action taken is the value-free habit of Miller, Shenhav and Ludvig (2019), and
active inference's own simulation of devaluation shows the persistence (Friston and others 2016,
§5.2). What the laws add for this model is the exact two-region threshold under a standing score
with the rule in sync, its edges (a stale rule, a moved count), and the lock outliving an unread
loss. Capture by counted choices is capture through the rule, closed in the sense of
`ClosedCapture.lock_outlives_loss`; its score stands, so it is not the meta-attractor of 02, whose
reading too is formed from the share (`ClosedCapture.both_reads`). The reading is stated with its
sources in `development/ue1-fep-bridge/NOTE.md`.

**What is not derived.** That an actual agent, brain or trained system counts its choices so, or
chooses at the argmax; any probability, surprisal, free energy or expected free energy; SPM's prior,
its free-energy term, its sampling, its inferred precision or its split among equally good policies;
more than two policies; additive counting's timescale; that a crossing under posterior counting
comes within any horizon. `weighted`, `weighted_reads` and `lower_strict` stay in this leaf:
`weighted` at `κc = κo = 1` is `CarrierCounts.proportional` only up to `1 * n = n`, so it is not the
reason for `proportional_reads` by definition, and `lower_strict`, the strict counterpart of
`CarrierCounts.lower`, is used only here. The representation commits to discrete steps and natural
counts, and in `CarrierCounts` to the second count positive. No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

namespace ChoiceCountCapture

universe u

/-! ## A chooser reading what couples in -/

section Fold

variable {F C : Type} {O : Type} {B : Type u}

/-- **A fold of a prefix**: the update folded over the prefix, its earliest value first (a prefix
lists its values latest first). Any function of the prefix is such a fold: with `update` consing
and `start` empty, the fold is the prefix itself. -/
def foldAfter (update : B → O → B) (start : B) (p : List O) : B :=
  p.foldr (fun o b => update b o) start

variable {W : Web F C} {obs : F → C → Prop} {g : F} {value : Nat → (C → Nat) → O}

/-- **A chooser reading a fold of what couples in selects through its couplings.** Where `value`
reads at each step exactly `g`'s admission and the conditions coupled into `g`
(`ValuesThrough`), the choice made from the fold of `g`'s own course before `t + 1`, whatever the
update and whatever the choice, is a selection through `g`'s couplings up to `t`. -/
theorem selectsThrough (values : W.ValuesThrough obs g value) (update : B → O → B) (start : B)
    (choice : B → Prop) (t : Nat) :
    W.SelectsThrough obs g t (fun l =>
      choice (foldAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1)))) :=
  (Web.selectsThrough_iff_prefix values).mpr
    ⟨fun p => choice (foldAfter update start p), fun _ => Iff.rfl⟩

/-- **Histories alike through the couplings are chosen alike**, whatever the update and the
choice. -/
theorem chosen_alike (values : W.ValuesThrough obs g value) (update : B → O → B) (start : B)
    (choice : B → Prop) {t : Nat} {l l' : Nat → C → Nat}
    (alike : W.AlikeThroughUpTo obs g l l' t) :
    choice (foldAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1))) ↔
      choice (foldAfter update start (Learning.prefixOf (Web.courseThrough value l') (t + 1))) :=
  selectsThrough values update start choice t l l' alike

/-- **What acts only beyond the coupling closure does not change the choice.** With a part
withheld and the rest of the exchange fixed (`WithheldLevels`), balance at each step on the
conditions coupled into members of `f`'s coupling closure, every member of the part beyond that
closure and `g` within it, the chooser at `g` chooses alike with and without the part, whatever
its update and its choice. -/
theorem unchosen_beyond_coupling {L : Flow F C} {part : F → Bool} {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {f : F}
    (balanced : ∀ t g c, L.WithinCoupling W obs f g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinCoupling W obs f h)
    (within : L.WithinCoupling W obs f g) (values : W.ValuesThrough obs g value)
    (update : B → O → B) (start : B) (choice : B → Prop) (t : Nat) :
    choice (foldAfter update start
        (Learning.prefixOf (Web.courseThrough value W.level) (t + 1))) ↔
      choice (foldAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1))) :=
  Flow.unselected_beyond_coupling without balanced beyond within
    (selectsThrough values update start choice t)

end Fold

/-! ## Choosers sharing their folds -/

section Pool

variable {F C : Type} {O : Type} {B : Type u} {W : Web F C} {obs : F → C → Prop}

/-- **The folds of listed members**, each of that member's own course before `t + 1`. With
`update` consing and `start` empty, each fold is the member's prefix itself, so a choice reading
the list can compute any model shared among the members. -/
def memberFolds (value : F → Nat → (C → Nat) → O) (update : B → O → B) (start : B)
    (members : List F) (t : Nat) (l : Nat → C → Nat) : List B :=
  members.map fun g => foldAfter update start (Learning.prefixOf (Web.courseThrough (value g) l) (t + 1))

/-- Histories alike through every member's couplings give every listed member the same fold. -/
theorem memberFolds_alike {group : F → Prop} {value : F → Nat → (C → Nat) → O}
    (values : ∀ g, group g → W.ValuesThrough obs g (value g)) (update : B → O → B) (start : B)
    {t : Nat} {l l' : Nat → C → Nat} (alike : W.AlikeThroughAll obs group l l' t) :
    ∀ members : List F, (∀ g, g ∈ members → group g) →
      memberFolds value update start members t l = memberFolds value update start members t l'
  | [], _ => rfl
  | g :: rest, listed =>
      show foldAfter update start (Learning.prefixOf (Web.courseThrough (value g) l) (t + 1)) ::
          memberFolds value update start rest t l =
        foldAfter update start (Learning.prefixOf (Web.courseThrough (value g) l') (t + 1)) ::
          memberFolds value update start rest t l' from
      congr
        (congrArg List.cons (congrArg (foldAfter update start)
          ((Web.alikeThroughUpTo_iff_prefix (values g (listed g (List.Mem.head rest)))).mp
            (alike g (listed g (List.Mem.head rest))))))
        (memberFolds_alike values update start alike rest fun h m => listed h (List.Mem.tail g m))

/-- **Choosers sharing their folds select through their pooled couplings.** Whatever the update
and whatever the choice read off the listed members' folds, a shared model built from all their
prefixes among them, the choice up to `t` is a selection through the pooled couplings of the group
up to `t`. -/
theorem pooled_selectsThrough {group : F → Prop} {members : List F}
    (listed : ∀ g, g ∈ members → group g) {value : F → Nat → (C → Nat) → O}
    (values : ∀ g, group g → W.ValuesThrough obs g (value g)) (update : B → O → B) (start : B)
    (choice : List B → Prop) (t : Nat) :
    W.SelectsThroughAll obs group t (fun l => choice (memberFolds value update start members t l)) :=
  fun l _ alike =>
    Eq.subst (motive := fun bs => choice (memberFolds value update start members t l) ↔ choice bs)
      (memberFolds_alike values update start alike members listed) Iff.rfl

/-- **Choosers sharing their folds are blind beyond the pool's coupling closure.** (That sharing
separates what some member separates is 05's pool law, `Web.separates_all_iff_member`.) With a
part withheld and the rest of the exchange fixed, balance on what couples into the pool's coupling closure, every member of
the part beyond that closure and the choosers within it, the choosers sharing their folds choose
alike with and without the part, whatever their update and their choice. -/
theorem pooled_unchosen_beyond {L : Flow F C} {part : F → Bool} {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {group : F → Prop}
    (balanced : ∀ t g c, L.WithinPoolCoupling W obs group g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinPoolCoupling W obs group h) {pool : F → Prop}
    (inside : ∀ g, pool g → L.WithinPoolCoupling W obs group g) {members : List F}
    (listed : ∀ g, g ∈ members → pool g) {value : F → Nat → (C → Nat) → O}
    (values : ∀ g, pool g → W.ValuesThrough obs g (value g)) (update : B → O → B) (start : B)
    (choice : List B → Prop) (t : Nat) :
    choice (memberFolds value update start members t W.level) ↔
      choice (memberFolds value update start members t l) :=
  Flow.unselected_beyond_pool without balanced beyond inside
    (pooled_selectsThrough listed values update start choice t)

end Pool

/-! ## A rule read from the count of its choices -/

section Count

open Pace RuleCapture CarrierCounts

/-- **A choice by the rule.** The chooser takes the first policy where its rule weighs it at
least as much as the second, and the first policy's count rises by one; elsewhere the second
policy's does. -/
def choose (x g : CarrierCounts) : CarrierCounts :=
  if g.other ≤ g.carrier then ⟨x.carrier + 1, x.other, x.other_pos⟩
  else ⟨x.carrier, x.other + 1, Nat.succ_pos x.other⟩

theorem choose_favoured {x g : CarrierCounts} (fav : favours g) :
    choose x g = ⟨x.carrier + 1, x.other, x.other_pos⟩ :=
  if_pos fav

theorem choose_unfavoured {x g : CarrierCounts} (dis : ¬ favours g) :
    choose x g = ⟨x.carrier, x.other + 1, Nat.succ_pos x.other⟩ :=
  if_neg dis

/-- **Choosing by a favouring rule does not lower the share**: the first policy's count rises and
the second's stays. -/
theorem choose_raises : Raises order favours choose := fun x _ fav =>
  Eq.mpr (congrArg (order.le x) (choose_favoured fav))
    (Nat.mul_le_mul_right x.other (Nat.le_succ x.carrier))

/-- **And raises it strictly**, the second count being positive. -/
theorem choose_rises_strictly {x g : CarrierCounts} (fav : favours g) :
    x.carrier * (choose x g).other < (choose x g).carrier * x.other :=
  Eq.mpr (congrArg (fun y : CarrierCounts => x.carrier * y.other < y.carrier * x.other)
      (choose_favoured fav))
    (Nat.mul_lt_mul_of_pos_right (Nat.lt_succ_self x.carrier) x.other_pos)

/-- **Choosing by a rule favouring the second policy strictly does not raise the share.** -/
theorem choose_lowers : Raises (reverse order) (fun g => g.carrier < g.other) choose :=
  fun x _ dis =>
    Eq.mpr (congrArg ((reverse order).le x) (choose_unfavoured (Nat.not_le_of_gt dis)))
      (Nat.mul_le_mul_left x.carrier (Nat.le_succ x.other))

/-- **The rule read from the counts under a standing score**: each count weighted by what the
score gives its policy, `κc` the first and `κo` the second. The rule in force, the second argument,
is not read. -/
def weighted (κc κo : Nat) (pos : 0 < κo) (x _ : CarrierCounts) : CarrierCounts :=
  ⟨κc * x.carrier, κo * x.other, Nat.mul_pos pos x.other_pos⟩

/-- **The weighted reading is monotone in the share.** -/
theorem weighted_reads {κc κo : Nat} {pos : 0 < κo} : ReadsShare order order (weighted κc κo pos) :=
  fun x y _ _ le =>
    calc κc * x.carrier * (κo * y.other)
        = κc * κo * (x.carrier * y.other) := Naturals.mul_mul_mul_comm κc x.carrier κo y.other
      _ ≤ κc * κo * (y.carrier * x.other) := Nat.mul_le_mul_left _ le
      _ = κc * y.carrier * (κo * x.other) :=
          (Naturals.mul_mul_mul_comm κc y.carrier κo x.other).symm

/-- **The threshold**: the weighted reading favours the first policy exactly where
`κo · other ≤ κc · carrier`. -/
theorem weighted_favours_iff {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts} :
    favours (weighted κc κo pos x g) ↔ κo * x.other ≤ κc * x.carrier :=
  Iff.rfl

/-- **At or above the threshold, with the rule in force read from the counts, the start is
locked.** -/
theorem start_locked {κc κo : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) :
    Locked order favours (weighted κc κo pos) (x, weighted κc κo pos x x) :=
  ⟨above, order.refl _⟩

/-- **At or above the threshold, the count keeps its policy.** Along every schedule of reading,
from counts with `κo · other ≤ κc · carrier` and the rule in force read from them, the course is
locked at every step (the rule favours the first policy and is not above what the reading of the
counts gives), and neither the share nor the rule falls across any step. Nothing here asks
`κo ≤ κc`: where the standing score favours the second policy, the count still keeps the first. -/
theorem counted_locks {κc κo : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool) (t : Nat) :
    Locked order favours (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t) ∧
      order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).1 ∧
      order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).2
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).2 :=
  have locked := start_locked (pos := pos) above
  ⟨Eq.subst (motive := fun n => Locked order favours (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n)) (Nat.zero_add t)
      (locked_stays (reads := reads) (c := (x, weighted κc κo pos x x)) (t := 0) choose_raises
        weighted_reads upper locked t),
   Eq.subst (motive := fun n =>
        order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n).1
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (n + 1)).1 ∧
        order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n).2
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (n + 1)).2)
      (Nat.zero_add t)
      (locked_rises (reads := reads) (c := (x, weighted κc κo pos x x)) (t := 0) choose_raises
        weighted_reads upper locked t)⟩

/-- **And the chooser takes the first policy at every step**: its count rises by one and the
second's stays. -/
theorem counted_chooses {κc κo : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).1 =
      ⟨(paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1.carrier + 1,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1.other,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1.other_pos⟩ :=
  (paced_fast_succ (f := choose) (h := weighted κc κo pos) (reads := reads)
      (x, weighted κc κo pos x x) t).trans
    (choose_favoured (counted_locks (pos := pos) above reads t).1.1)

/-- **Strictly favouring the second policy is kept by every rule not higher.** The strict
counterpart of `CarrierCounts.lower`. -/
theorem lower_strict {g g' : CarrierCounts} (le : (reverse order).le g g')
    (dis : g.carrier < g.other) : g'.carrier < g'.other :=
  match Nat.lt_or_ge g'.carrier g'.other with
  | .inl less => less
  | .inr ge => absurd
      (calc g'.other * g.other
          ≤ g'.carrier * g.other := Nat.mul_le_mul_right g.other ge
        _ ≤ g.carrier * g'.other := le
        _ < g.other * g'.other := Nat.mul_lt_mul_of_pos_right dis g'.other_pos
        _ = g'.other * g.other := Nat.mul_comm _ _)
      (Nat.lt_irrefl _)

/-- **Below the threshold, the count keeps the second policy.** From counts with
`κc · carrier < κo · other` and the rule in force read from them, along every schedule of reading,
the rule favours the second policy strictly at every step, and neither the share nor the rule rises
across any step. -/
theorem counted_locks_down {κc κo : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (below : κc * x.carrier < κo * x.other) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).2.carrier <
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).2.other ∧
      (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).1 ∧
      (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).2
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).2 :=
  have locked : Locked (reverse order) (fun g => g.carrier < g.other) (weighted κc κo pos)
      (x, weighted κc κo pos x x) := ⟨below, (reverse order).refl _⟩
  ⟨(Eq.subst (motive := fun n => Locked (reverse order) (fun g => g.carrier < g.other)
        (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n)) (Nat.zero_add t)
      (locked_stays (reads := reads) (c := (x, weighted κc κo pos x x)) (t := 0) choose_lowers
        weighted_reads.reverse lower_strict locked t)).1,
   Eq.subst (motive := fun n =>
        (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n).1
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (n + 1)).1 ∧
        (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) n).2
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (n + 1)).2)
      (Nat.zero_add t)
      (locked_rises (reads := reads) (c := (x, weighted κc κo pos x x)) (t := 0) choose_lowers
        weighted_reads.reverse lower_strict locked t)⟩

/-- **And the chooser takes the second policy at every step**: its count rises by one and the
first's stays. -/
theorem counted_chooses_down {κc κo : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (below : κc * x.carrier < κo * x.other) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) (t + 1)).1 =
      ⟨(paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1.carrier,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x x) t).1.other + 1,
        Nat.succ_pos _⟩ :=
  (paced_fast_succ (f := choose) (h := weighted κc κo pos) (reads := reads)
      (x, weighted κc κo pos x x) t).trans
    (choose_unfavoured (Nat.not_le_of_gt (counted_locks_down (pos := pos) below reads t).1))

/-- **The rule of counting the posterior at the time of choosing**, at scale `s`: selection by
`⟨s + κc, s + κo⟩` takes counts `(c, o)` to `(c · (s + κc), o · (s + κo))`, the counts scaled by `s`
with the posterior's weights added, the posterior weighing each policy by its count and the score.
With learning rate `η`, adding the posterior is this step with `s = Z/η`,
`Z = κc · carrier + κo · other`, where that is a whole number, so `s` changes from step to step. -/
def byScore (κc κo s : Nat) (pos : 0 < κo) : CarrierCounts :=
  ⟨s + κc, s + κo, Nat.lt_of_lt_of_le pos (Nat.le_add_left κo s)⟩

/-- **Counted from the posterior at the time of choosing, a standing score favouring the second
policy lowers the first policy's share strictly**, carriers present, whatever the counts and the
scale of the step. -/
theorem posterior_count_falls {κc κo s : Nat} {pos : 0 < κo} (x : CarrierCounts)
    (some : 0 < x.carrier) (score : κc < κo) :
    (CarrierCounts.select x (byScore κc κo s pos)).carrier * x.other <
      x.carrier * (CarrierCounts.select x (byScore κc κo s pos)).other :=
  RuleShaping.falls_strictly some (Nat.add_lt_add_left score s)

/-- **Along a course at a positive fixed scale, the share falls strictly at every step.** A
geometric course: the share is multiplied by `(s + κc)/(s + κo)` at each step, which is not the
timescale of additive counting. -/
theorem posterior_course_falls {κc κo s : Nat} {pos : 0 < κo} {x : CarrierCounts}
    (scale : 0 < s) (some : 0 < x.carrier) (score : κc < κo) (n : Nat) :
    (Law.orbit (fun y => CarrierCounts.select y (byScore κc κo s pos)) x (n + 1)).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (byScore κc κo s pos)) x n).other <
      (Law.orbit (fun y => CarrierCounts.select y (byScore κc κo s pos)) x n).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (byScore κc κo s pos)) x (n + 1)).other :=
  RuleShaping.falls_strictly
    (RuleShaping.present_along (Nat.lt_of_lt_of_le scale (Nat.le_add_right s κc)) some n)
    (Nat.add_lt_add_left score s)

/-- **A count outlives a loss it does not read.** Join to the chooser a coordinate that neither
its counts nor its score reads, rising by at least one at every step (`Accrues`): a draw the
counted policy makes on what its loop does not read. From counts at or above the threshold with the
rule in force read from them, along every schedule, at step `t` the coordinate stands at least
`b + t` while the course is locked and neither the share nor the rule is below its start. -/
theorem counted_outlives_loss {κc κo : Nat} {pos : 0 < κo}
    {fB : CarrierCounts × Nat → CarrierCounts → Nat} (accrues : ClosedCapture.Accrues fB)
    {x : CarrierCounts} {b : Nat} (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool)
    (t : Nat) :
    b + t ≤ (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
        reads ((x, b), weighted κc κo pos x x) t).1.2 ∧
      Locked order favours (weighted κc κo pos)
        ((paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x x) t).1.1,
         (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x x) t).2) ∧
      order.le x (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
        reads ((x, b), weighted κc κo pos x x) t).1.1 ∧
      order.le (weighted κc κo pos x x)
        (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x x) t).2 :=
  ClosedCapture.lock_outlives_loss choose_raises weighted_reads upper accrues
    (start_locked (pos := pos) above) t

end Count

/-! ## Witnesses -/

namespace Witness

open Pace RuleCapture CarrierCounts

theorem four_pos : 0 < 4 := Nat.zero_lt_succ 3

/-- Counts three to one for the first policy: above the threshold of the score one to two,
`2 · 1 ≤ 1 · 3`. -/
def counts : CarrierCounts := ⟨3, 1, Nat.zero_lt_one⟩

/-- **A count beats a score that favours the other policy two to one.** From three choices of the
first policy against one of the second, the rule in force read from them, the chooser takes the
first policy at every step, along every schedule, although the score weighs the second twice as
much. -/
theorem counted_beats_score (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 Nat.two_pos) reads (counts, weighted 1 2 Nat.two_pos counts counts)
        (t + 1)).1.carrier =
      (paced choose (weighted 1 2 Nat.two_pos) reads (counts, weighted 1 2 Nat.two_pos counts counts)
        t).1.carrier + 1 :=
  congrArg CarrierCounts.carrier
    (counted_chooses (κc := 1) (κo := 2) (pos := Nat.two_pos) (x := counts)
      (show 2 * 1 ≤ 1 * 3 by decide) reads t)

/-- Counts one to one: below the threshold, `1 · 1 < 2 · 1`. -/
def even : CarrierCounts := ⟨1, 1, Nat.zero_lt_one⟩

/-- **Without the count's lead, the score decides for good.** From one choice of each, the rule
favours the second policy strictly at every step. -/
theorem score_decides (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 Nat.two_pos) reads (even, weighted 1 2 Nat.two_pos even even) t).2.carrier <
      (paced choose (weighted 1 2 Nat.two_pos) reads (even, weighted 1 2 Nat.two_pos even even) t).2.other :=
  (counted_locks_down (κc := 1) (κo := 2) (pos := Nat.two_pos) (x := even)
    (show 1 * 1 < 2 * 1 by decide) reads t).1

/-- Counts three to two: one count of the three to one moved to the second policy. -/
def moved : CarrierCounts := ⟨3, 2, Nat.two_pos⟩

/-- **A change of the counts across the threshold leaves the lock.** Three to two under the score
one to two lies below the threshold, `1 · 3 < 2 · 2`: the course is locked the other way. -/
theorem moved_locks_down (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 Nat.two_pos) reads (moved, weighted 1 2 Nat.two_pos moved moved) t).2.carrier <
      (paced choose (weighted 1 2 Nat.two_pos) reads (moved, weighted 1 2 Nat.two_pos moved moved) t).2.other :=
  (counted_locks_down (κc := 1) (κo := 2) (pos := Nat.two_pos) (x := moved)
    (show 1 * 3 < 2 * 2 by decide) reads t).1

/-- **Counted from the posterior at the time of choosing, the share falls at the first step.**
From the same three to one at scale one, the first policy's share falls at the first step. -/
theorem posterior_share_falls :
    (CarrierCounts.select counts (byScore 1 2 1 Nat.two_pos)).carrier * counts.other <
      counts.carrier * (CarrierCounts.select counts (byScore 1 2 1 Nat.two_pos)).other :=
  posterior_count_falls (κc := 1) (κo := 2) (s := 1) (pos := Nat.two_pos) counts (Nat.zero_lt_succ 2)
    (Nat.lt_succ_self 1)

/-- **A falling share need not cross at once**: after one step the counts are six to three, and
the weighted rule still favours the first policy, by a tie, `2 · 3 ≤ 1 · 6`. -/
theorem after_one_still_first :
    favours (weighted 1 2 Nat.two_pos (CarrierCounts.select counts (byScore 1 2 1 Nat.two_pos)) counts) :=
  show 2 * 3 ≤ 1 * 6 by decide

/-- **It favours the second policy from the second step**: twelve to nine, `2 · 9 > 1 · 12`. -/
theorem after_two_turns :
    ¬ favours (weighted 1 2 Nat.two_pos
      (CarrierCounts.select (CarrierCounts.select counts (byScore 1 2 1 Nat.two_pos))
        (byScore 1 2 1 Nat.two_pos)) counts) :=
  show ¬ 2 * 9 ≤ 1 * 12 by decide

/-! ### A rule in force not read from the counts -/

namespace Stale

/-- A rule an older score left in force: favouring the second policy four to one. -/
def stale : CarrierCounts := ⟨1, 4, four_pos⟩

/-- **Counts above the threshold under a stale rule lock the other way.** Counts three to one,
above the threshold of the score one to two, with the stale rule in force and read at every step:
the course is locked for the second policy from step 5. -/
theorem above_but_stale_locks_down :
    Locked (reverse order) (fun g => g.carrier < g.other) (weighted 1 2 Nat.two_pos)
      (paced choose (weighted 1 2 Nat.two_pos) (fun _ => true) (counts, stale) 5) :=
  ⟨show 5 < 6 by decide, show 5 * 6 ≤ 5 * 8 by decide⟩

/-- And the rule favours the second policy at every later step. -/
theorem above_but_stale_never_first (k : Nat) :
    (paced choose (weighted 1 2 Nat.two_pos) (fun _ => true) (counts, stale) (5 + k)).2.carrier <
      (paced choose (weighted 1 2 Nat.two_pos) (fun _ => true) (counts, stale) (5 + k)).2.other :=
  (locked_stays (reads := fun _ => true) (c := (counts, stale)) (t := 5) choose_lowers
    weighted_reads.reverse lower_strict above_but_stale_locks_down k).1

/-- A schedule whose first reading is at step 1. -/
def late : Nat → Bool := Witnesses.profile [false] true

/-- **A change of score read late.** Counts three to one, a new score one to four, which puts them
below its threshold, `4 · 1 > 1 · 3`. With the rule of the old score (one to one, read from the
counts) still in force and the first reading at step 1, the course is locked for the first policy
from step 2. -/
theorem devalued_read_late_locks_up :
    Locked order favours (weighted 1 4 four_pos)
      (paced choose (weighted 1 4 four_pos) late (counts, counts) 2) :=
  ⟨show 4 ≤ 4 by decide, show 4 * 4 ≤ 5 * 4 by decide⟩

/-- And the rule favours the first policy at every later step. -/
theorem devalued_read_late_keeps_first (k : Nat) :
    favours (paced choose (weighted 1 4 four_pos) late (counts, counts) (2 + k)).2 :=
  (locked_stays (reads := late) (c := (counts, counts)) (t := 2) choose_raises
    weighted_reads upper devalued_read_late_locks_up k).1

/-- **Read at once, the same change of score locks the other way.** -/
theorem devalued_read_at_once_locks_down (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 4 four_pos) reads (counts, weighted 1 4 four_pos counts counts) t).2.carrier <
      (paced choose (weighted 1 4 four_pos) reads (counts, weighted 1 4 four_pos counts counts) t).2.other :=
  (counted_locks_down (κc := 1) (κo := 4) (pos := four_pos) (x := counts)
    (show 1 * 3 < 4 * 1 by decide) reads t).1

end Stale

end Witness

end ChoiceCountCapture

end Becoming
