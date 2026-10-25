import Becoming.IdentificationRuns
import Becoming.ClosedCapture

/-!
# Habit capture: a chooser reading what couples in, its prior counted from its own choices

Two laws of the spine read on a chooser of the kind that the process theory of the free-energy
principle, active inference, describes: a formation that keeps a belief folded from what couples
into it, chooses from that belief, and weighs its choices by a prior over them counted from the
choices it has made (a *habit*). No probability is used: the belief is any value folded from what
couples in, and the prior is a pair of counts.

* **Choosing from a belief folded from what couples in is a selection through the couplings.**
  Whatever the update (an exact posterior, a variational one, a predictive code) and whatever the
  choice (by expected free energy or any other score), the choice up to a step is a selection
  through the chooser's couplings up to that step (`selectsThrough`). So histories alike through
  the couplings are chosen alike (`chosen_alike`), and with a part acting only beyond the
  coupling closure withheld, the rest of the exchange fixed and balance on what couples in, the
  choice is the same with and without the part (`unchosen_beyond_coupling`, an instance of
  `Flow.unselected_beyond_coupling`). The free-energy principle's Markov blanket is read here as
  the couplings: what the chooser's update and choice read of the rest is what couples into it.
* **A prior counted from its own choices locks above a threshold.** Let the chooser take the first
  of two policies where its rule weighs it at least as much as the second, and let that policy's
  count rise by one (`choose`); the rule is read from the counts weighted by a standing score,
  `κc` for the first policy and `κo` for the second (`weighted`), as a posterior over policies
  weighs a habit by the score. Choosing by a favouring rule raises the share it reads
  (`choose_raises`, strictly: `choose_rises_strictly`), and the reading is monotone in the share
  (`weighted_reads`). So from counts with `κo · other ≤ κc · carrier` and the rule read from them,
  along every schedule of reading, the rule favours the first policy at every step, the chooser
  takes it at every step and neither the share nor the rule falls (`habit_locks`,
  `habit_chooses`), also where the standing score favours the second policy (`κc < κo`). Below
  the threshold the chooser takes the second policy at every step (`habit_locks_down`), so the
  threshold is a point of no return either way. This is `RuleCapture.locked_stays` with the
  selection a choice and the share the count of past choices.
* **Counted from the posterior, it does not lock against a standing score.** Where instead the
  counts take the posterior in proportion (scaled counts with the posterior's weights added,
  `soft`), a score favouring the second policy lowers the first policy's share strictly at every
  step, carriers present, whatever the counts and the scale (`soft_falls`, along a course
  `soft_course_falls`). The lock belongs to counting the choice, which raises the share it reads
  (`Raises`), and not to counting as such.
* **The lock outlives a loss it does not read.** Joined to a coordinate that rises by at least one
  at every step and that neither the counts nor the score reads, from counts above the threshold
  the coordinate passes every bound while the course stays locked (`habit_outlives_loss`, an
  instance of `ClosedCapture.lock_outlives_loss`).

**Correspondence (an AI reading).** In discrete active inference a prior over policies, the habit,
is learned by accumulating the policies selected, and the posterior over policies weighs it by
the exponentiated negative expected free energy. Read with `weighted`, the score's weights are
`κc` and `κo`; read with `choose`, the policy selected is the one the posterior weighs most, the
limit of high precision in selecting actions; read with `soft`, the counts accumulate the
posterior itself. A habit counted from its own choices, with nothing in its loop reading what
lies beyond its counts and its score, is then the meta-attractor of `Becoming.RuleCapture`: a
loop whose rule and reading are formed from the share it selects. Self-evidencing in this closed
form is capture. The reading of the free-energy principle and of active inference is the AI's,
stated in `development/ue1-fep-bridge/NOTE.md` with the literature it rests on.

**What is not derived.** That an actual agent, brain or trained system counts its choices so, or
selects at the precision `choose` takes; any probability, surprisal, free energy or expected free
energy (the score enters as two whole-number weights, the belief as any value); that the
threshold is reached; which update or choice an agent uses. The representation commits to
discrete steps and natural counts, and in `CarrierCounts` to the second count positive. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace HabitCapture

universe u

/-! ## A chooser reading what couples in -/

section Belief

variable {F C : Type} {O : Type} {B : Type u}

/-- **The belief after a record**: the update folded over the record, its earliest value first (a
prefix lists its values latest first). -/
def beliefAfter (update : B → O → B) (start : B) (record : List O) : B :=
  record.foldr (fun o b => update b o) start

variable {W : Web F C} {obs : F → C → Prop} {g : F} {value : Nat → (C → Nat) → O}

/-- **A chooser reading a belief folded from what couples in selects through its couplings.**
Where `value` reads at each step exactly `g`'s admission and the conditions coupled into `g`
(`ValuesThrough`), the choice made from the belief folded over `g`'s own course before `t + 1`,
whatever the update and whatever the choice, is a selection through `g`'s couplings up to `t`. -/
theorem selectsThrough (values : W.ValuesThrough obs g value) (update : B → O → B) (start : B)
    (choice : B → Prop) (t : Nat) :
    W.SelectsThrough obs g t (fun l =>
      choice (beliefAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1)))) :=
  (Web.selectsThrough_iff_prefix values).mpr
    ⟨fun p => choice (beliefAfter update start p), fun _ => Iff.rfl⟩

/-- **Histories alike through the couplings are chosen alike**, whatever the update and the
choice. -/
theorem chosen_alike (values : W.ValuesThrough obs g value) (update : B → O → B) (start : B)
    (choice : B → Prop) {t : Nat} {l l' : Nat → C → Nat}
    (alike : W.AlikeThroughUpTo obs g l l' t) :
    choice (beliefAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1))) ↔
      choice (beliefAfter update start (Learning.prefixOf (Web.courseThrough value l') (t + 1))) :=
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
    choice (beliefAfter update start
        (Learning.prefixOf (Web.courseThrough value W.level) (t + 1))) ↔
      choice (beliefAfter update start (Learning.prefixOf (Web.courseThrough value l) (t + 1))) :=
  Flow.unselected_beyond_coupling without balanced beyond within
    (selectsThrough values update start choice t)

end Belief

/-! ## A prior counted from its own choices -/

section Habit

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
score gives its policy, `κc` the first and `κo` the second. -/
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

/-- **At or above the threshold, a rule read from its counts is locked.** -/
theorem start_locked {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) :
    Locked order favours (weighted κc κo pos) (x, weighted κc κo pos x g) :=
  ⟨above, order.refl _⟩

/-- **A habit at or above its threshold keeps its policy.** Along every schedule of reading, from
counts with `κo · other ≤ κc · carrier` and the rule read from them, the course is locked at every
step (the rule favours the first policy and is not above what the reading of the counts gives),
and neither the share nor the rule falls across any step. Nothing here asks `κo ≤ κc`: where the
standing score favours the second policy, the habit still keeps the first. -/
theorem habit_locks {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool) (t : Nat) :
    Locked order favours (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t) ∧
      order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).1 ∧
      order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).2
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).2 :=
  have locked := start_locked (pos := pos) (g := g) above
  ⟨Eq.subst (motive := fun n => Locked order favours (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n)) (Nat.zero_add t)
      (locked_stays (reads := reads) (c := (x, weighted κc κo pos x g)) (t := 0) choose_raises
        weighted_reads upper locked t),
   Eq.subst (motive := fun n =>
        order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n).1
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (n + 1)).1 ∧
        order.le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n).2
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (n + 1)).2)
      (Nat.zero_add t)
      (locked_rises (reads := reads) (c := (x, weighted κc κo pos x g)) (t := 0) choose_raises
        weighted_reads upper locked t)⟩

/-- **And the chooser takes the first policy at every step**: its count rises by one and the
second's stays. -/
theorem habit_chooses {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).1 =
      ⟨(paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1.carrier + 1,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1.other,
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1.other_pos⟩ :=
  (paced_fast_succ (f := choose) (h := weighted κc κo pos) (reads := reads)
      (x, weighted κc κo pos x g) t).trans
    (choose_favoured (habit_locks (pos := pos) (g := g) above reads t).1.1)

/-- **Strictly favouring the second policy is kept by every rule not higher.** -/
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

/-- **Below the threshold, the chooser takes the second policy at every step.** From counts with
`κc · carrier < κo · other` and the rule read from them, along every schedule of reading, the
rule favours the second policy strictly at every step and neither the share nor the rule rises. -/
theorem habit_locks_down {κc κo : Nat} {pos : 0 < κo} {x g : CarrierCounts}
    (below : κc * x.carrier < κo * x.other) (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).2.carrier <
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).2.other ∧
      (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) t).1
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (t + 1)).1 :=
  have locked : Locked (reverse order) (fun g => g.carrier < g.other) (weighted κc κo pos)
      (x, weighted κc κo pos x g) := ⟨below, (reverse order).refl _⟩
  ⟨(Eq.subst (motive := fun n => Locked (reverse order) (fun g => g.carrier < g.other)
        (weighted κc κo pos)
        (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n)) (Nat.zero_add t)
      (locked_stays (reads := reads) (c := (x, weighted κc κo pos x g)) (t := 0) choose_lowers
        weighted_reads.reverse lower_strict locked t)).1,
   (Eq.subst (motive := fun n =>
        (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n).1
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (n + 1)).1 ∧
        (reverse order).le (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) n).2
          (paced choose (weighted κc κo pos) reads (x, weighted κc κo pos x g) (n + 1)).2)
      (Nat.zero_add t)
      (locked_rises (reads := reads) (c := (x, weighted κc κo pos x g)) (t := 0) choose_lowers
        weighted_reads.reverse lower_strict locked t)).1⟩

/-- **The counts after taking the posterior in proportion.** The counts scaled by `s` with the
posterior's weights added: the posterior weighs each policy by its count and the standing score,
so in whole numbers the first count becomes `carrier · (s + κc)` and the second
`other · (s + κo)`. -/
def soft (κc κo s : Nat) (pos : 0 < κo) (x : CarrierCounts) : CarrierCounts :=
  ⟨x.carrier * (s + κc), x.other * (s + κo),
    Nat.mul_pos x.other_pos (Nat.lt_of_lt_of_le pos (Nat.le_add_left κo s))⟩

/-- **Counted from the posterior, a standing score favouring the second policy lowers the first
policy's share strictly**, carriers present, whatever the counts and the scale. -/
theorem soft_falls {κc κo s : Nat} {pos : 0 < κo} (x : CarrierCounts) (some : 0 < x.carrier)
    (score : κc < κo) :
    (soft κc κo s pos x).carrier * x.other < x.carrier * (soft κc κo s pos x).other :=
  calc x.carrier * (s + κc) * x.other
      = x.carrier * x.other * (s + κc) := Naturals.mul_right_comm _ _ _
    _ < x.carrier * x.other * (s + κo) :=
        Nat.mul_lt_mul_of_pos_left (Nat.add_lt_add_left score s) (Nat.mul_pos some x.other_pos)
    _ = x.carrier * (x.other * (s + κo)) := mul_assoc_nat _ _ _

/-- The counts after `n` steps of taking the posterior in proportion. -/
def softCourse (κc κo s : Nat) (pos : 0 < κo) (x : CarrierCounts) : Nat → CarrierCounts
  | 0 => x
  | n + 1 => soft κc κo s pos (softCourse κc κo s pos x n)

/-- With a positive scale, carriers present stay present. -/
theorem softCourse_some {κc κo s : Nat} {pos : 0 < κo} {x : CarrierCounts} (scale : 0 < s)
    (some : 0 < x.carrier) : ∀ n, 0 < (softCourse κc κo s pos x n).carrier
  | 0 => some
  | n + 1 => Nat.mul_pos (softCourse_some scale some n)
      (Nat.lt_of_lt_of_le scale (Nat.le_add_right s κc))

/-- **Along the course of taking the posterior, the share falls strictly at every step.** With a
positive scale, carriers present at the start and a standing score favouring the second policy,
the first policy's share after each step is strictly below its share before it: no lock forms. -/
theorem soft_course_falls {κc κo s : Nat} {pos : 0 < κo} {x : CarrierCounts} (scale : 0 < s)
    (some : 0 < x.carrier) (score : κc < κo) (n : Nat) :
    (softCourse κc κo s pos x (n + 1)).carrier * (softCourse κc κo s pos x n).other <
      (softCourse κc κo s pos x n).carrier * (softCourse κc κo s pos x (n + 1)).other :=
  soft_falls (pos := pos) _ (softCourse_some scale some n) score

/-- **A habit outlives a loss it does not read.** Join to the chooser a coordinate that neither
its counts nor its score reads, rising by at least one at every step (`Accrues`): a draw the
habitual policy makes on what its loop does not read. From counts at or above the threshold with
the rule read from them, along every schedule, at step `t` the coordinate stands at least `b + t`
while the course is locked and neither the share nor the rule is below its start. -/
theorem habit_outlives_loss {κc κo : Nat} {pos : 0 < κo}
    {fB : CarrierCounts × Nat → CarrierCounts → Nat} (accrues : ClosedCapture.Accrues fB)
    {x g : CarrierCounts} {b : Nat} (above : κo * x.other ≤ κc * x.carrier) (reads : Nat → Bool)
    (t : Nat) :
    b + t ≤ (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
        reads ((x, b), weighted κc κo pos x g) t).1.2 ∧
      Locked order favours (weighted κc κo pos)
        ((paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x g) t).1.1,
         (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x g) t).2) ∧
      order.le x (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
        reads ((x, b), weighted κc κo pos x g) t).1.1 ∧
      order.le (weighted κc κo pos x g)
        (paced (ClosedCapture.join choose fB) (ClosedCapture.joinRead (weighted κc κo pos))
          reads ((x, b), weighted κc κo pos x g) t).2 :=
  ClosedCapture.lock_outlives_loss choose_raises weighted_reads upper accrues
    (start_locked (pos := pos) (g := g) above) t

end Habit

/-! ## Witnesses -/

namespace Witness

open Pace RuleCapture CarrierCounts

/-- Counts three to one for the first policy: at the threshold `2 · 1 ≤ 1 · 3`, so above it. -/
def counts : CarrierCounts := ⟨3, 1, Nat.zero_lt_one⟩

/-- **A habit beats a score that favours the other policy two to one.** From three choices of the
first policy against one of the second, the chooser takes the first policy at every step, along
every schedule, although the score weighs the second twice as much. -/
theorem habit_beats_score (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 (Nat.zero_lt_succ 1)) reads
        (counts, weighted 1 2 (Nat.zero_lt_succ 1) counts counts) (t + 1)).1.carrier =
      (paced choose (weighted 1 2 (Nat.zero_lt_succ 1)) reads
        (counts, weighted 1 2 (Nat.zero_lt_succ 1) counts counts) t).1.carrier + 1 :=
  congrArg CarrierCounts.carrier
    (habit_chooses (κc := 1) (κo := 2) (pos := Nat.zero_lt_succ 1) (x := counts) (g := counts)
      (show 2 * 1 ≤ 1 * 3 by decide) reads t)

/-- Counts one to one: below the threshold, `1 · 1 < 2 · 1`. -/
def even : CarrierCounts := ⟨1, 1, Nat.zero_lt_one⟩

/-- **Without the habit's lead, the score decides for good.** From one choice of each, the rule
favours the second policy strictly at every step. -/
theorem score_decides (reads : Nat → Bool) (t : Nat) :
    (paced choose (weighted 1 2 (Nat.zero_lt_succ 1)) reads
        (even, weighted 1 2 (Nat.zero_lt_succ 1) even even) t).2.carrier <
      (paced choose (weighted 1 2 (Nat.zero_lt_succ 1)) reads
        (even, weighted 1 2 (Nat.zero_lt_succ 1) even even) t).2.other :=
  (habit_locks_down (κc := 1) (κo := 2) (pos := Nat.zero_lt_succ 1) (x := even) (g := even)
    (show 1 * 1 < 2 * 1 by decide) reads t).1

/-- **Counted from the posterior, the same habit gives way.** From the same three to one, taking
the posterior in proportion at scale one, the first policy's share falls at the first step. -/
theorem soft_gives_way :
    (soft 1 2 1 (Nat.zero_lt_succ 1) counts).carrier * counts.other <
      counts.carrier * (soft 1 2 1 (Nat.zero_lt_succ 1) counts).other :=
  soft_falls (κc := 1) (κo := 2) (s := 1) (pos := Nat.zero_lt_succ 1) counts (Nat.zero_lt_succ 2)
    (Nat.lt_succ_self 1)

end Witness

end HabitCapture

end Becoming
