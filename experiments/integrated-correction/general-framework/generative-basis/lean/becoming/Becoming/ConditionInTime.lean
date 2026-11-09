import Becoming.FlowCenters
import Becoming.GroupEnding
import Becoming.SelectionTerm
import Becoming.Identity
import Becoming.PersistingChoices

/-!
# ConditionInTime: the continuation condition in time (续无外之时)

Route (b)'s first join (`Flow.returning_unrestricted_iff_mutuallyDependent` of `Becoming.FlowCenters`)
says that, held de se along affecting at the formations whose acts return, the presupposition is the
continuation condition exactly where the flow is mutually dependent. Its relation is read across all
steps: a formation affects another where it exchanges, at some step, with a condition the other
requires at some step, the two steps unrelated (`Flow.Affects`), and own closure ignores its step
(`ownClosure`). So the law says nothing about order in time. This module asks what holds once time is
in, on occurrences `(t, f)`: a formation at a step.

* **Returning on a relation without cycles: the sinks.** An element related to nothing returns, with
  no premise (`returnsAlong_of_sink`); on a relation without cycles the returning elements are exactly
  those (`returnsAlong_iff_sink`), and held de se at them the condition holds exactly where, if there
  is a sink, there is only one element (`ownClosure_unrestricted_atReturning_acyclic_iff`). On the net
  read off a continuation, an occurrence returns exactly where nothing continues it
  (`Web.continuationStep_returns_iff`). Near-definitional.
* **The condition over what comes after (续无外于后).** From each center, everything at a later step
  is reached on a line under the class (`«续无外于后»`). On a net whose conditions go forward in time,
  the root's condition `«续无外»` is exactly this and that nothing other than the center lies at or
  before the center's step (`«续无外当且仅当后与独»`). So the one-center bound
  (`«续无外则同一中心»` of `Becoming.GrammarScope`) counts what lies before and beside a center, which
  no act can affect: over what comes after, two distinct centers can meet the condition
  (`TwoSources.apart`, `a₀ → z ← b₀`), and on a flow below every occurrence can
  (`Recurring.oneCenter_counts`); the second part alone admits one center, with no net
  (`«独则同一中心»`). Near-definitional, with the witnesses.
* **A dated relation read off a flow.** An occurrence affects a later one where, taking part at its
  step, it exchanges with a condition the later one requires at its step (`Flow.AffectsBefore`): the
  link of `Flow.ReachesBefore` (`Flow.reachesBefore_iff`), without which a part's acts show nowhere at a
  later step (`Flow.Balances.admits_unreached_before` of `Becoming.Feedback`). Adding
  a formation's going on to its next step gives a step in time (`Flow.StepInTime`). Each step goes
  forward, so the relation has no cycle (`Flow.stepInTime_acyclic`), and every occurrence goes on, so
  none returns along it: read with the returning occurrences as standpoints the condition holds only
  vacuously
  (`Flow.not_returnsAlong_stepInTime`, `Flow.returningInTime_unrestricted`); along affecting before
  alone, the returning occurrences are those that affect nothing later
  (`Flow.returnsAlong_affectsBefore_iff`). What lies within an occurrence's closure in time lies
  within its formation's reach closure (`Flow.WithinTime.withinReach`).
* **Mutual dependence in time, and the condition it is.** A flow is mutually dependent in time from a
  step where, from every formation at that step, every formation's continuation lies within its closure
  in time at some step (`Flow.MutuallyDependentFrom`); from every step, `Flow.MutuallyDependentInTime`.
  Held de se at every occurrence, the condition that from some step on every formation's continuation
  has significance (`UnrestrictedEventually`) holds exactly where the flow is mutually dependent in time
  (`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`). This is the dated counterpart of the join
  with every formation a standpoint (`Flow.mutuallyDependent_iff_unrestricted` of
  `Becoming.PersistingChoices`), which along affecting gives the first join's condition; at the returning
  occurrences, the first join's own standpoints, the condition in time is vacuous (above). Both are
  restrictions of the condition to what comes after a standpoint's step: over every step, held de se in
  time at every occurrence, it fails wherever there is a formation, nothing reaching an earlier step
  (`Flow.not_unrestricted_inTime`).
  The condition over every step after the standpoint's own (`UnrestrictedAfter`) holds exactly where,
  at every step, every formation affects every other at the next step
  (`Flow.unrestrictedAfter_iff_coupledEachStep`). Mutual dependence in time from any step gives mutual
  dependence (`Flow.MutuallyDependentFrom.mutuallyDependent`), and so the first join's condition
  (`Flow.MutuallyDependentFrom.returning_unrestricted`); the converse fails.
* **Witnesses.** In `Recurring`, two formations each taking from and giving to the other's condition at
  every step, both restricted forms hold, with two formations, not only vacuously (`Recurring.inTime`);
  the condition over every step does not. In `RingOfThree`, three formations each drawing on the next, the flow is
  mutually dependent in time and the condition over every later step fails: what lies two links away is
  reached two steps later, not at the next (`RingOfThree.apart`; the failed candidate, kept). In main's
  `Drawing`, mutually dependent, each taking at the first step only from what the other requires, the
  pair is mutually dependent in time from the first step and not from the second (`Drawing.lapses`). In `LatePair` each takes from what the
  other required, after the only step it required it: the flow is mutually dependent and the first join's
  condition holds, while nothing affects anything in time (`LatePair.apart`).
* **Persistence, dated.** Under the laws of `Flow.persists_never_overdraws`, descent among them, a line
  with a member at a step later than `T + n` never overdrew, from a short stock, across the `n` steps from
  `T` (`Flow.member_after_never_overdrew`): the one step at which
  `Flow.persists_never_overdraws` uses its line, as a finite law. It was proved here first and now stands
  in `Becoming.PersistingChoices`, from `GroupEnding.Flow.coupled_generation_childless`, with
  `Flow.persists_never_overdraws` its corollary (board rule 9, at route (b)'s join).

Premises: the relations are read off one flow and one web. The step in time keeps a formation's identity
from one step to the next, as `Flow.Affects` keeps it across all steps, now forward only; it does not ask
the formation to take part. Which occurrences are the standpoints (every one, or the returning ones) is a
reading. Exchanging counts taking as well as giving, so mutual dependence in time includes mutual drain.
Reading significance as own closure is itself a reading (07 §1). No ethical premise, and no Lean axiom is
used.
-/

namespace Becoming

universe u

/-! ## Returning on a relation without cycles: the sinks -/

section Sinks

variable {X : Type} {rel : X → X → Prop}

/-- **A sink returns**: an element related to nothing has only itself within its closure, so whatever
lies within its closure has it within its own. No premise. -/
theorem returnsAlong_of_sink {c : X} (sink : ∀ g, ¬ rel c g) : ReturnsAlong rel c :=
  fun _ within => match «所闭当且仅当同一或及».mp within with
    | .inl same => Eq.subst (motive := fun x => WithinClosure rel x c) same (WithinClosure.refl c)
    | .inr reach => match «及当且仅当一步而所闭».mp reach with
      | ⟨y, step, _⟩ => absurd step (sink y)

/-- **On a relation without cycles, the returning elements are exactly the sinks**: an element
related to something would, returning, lie on a cycle. -/
theorem returnsAlong_iff_sink (acyclic : «无环» rel) {c : X} :
    ReturnsAlong rel c ↔ ∀ g, ¬ rel c g :=
  ⟨fun returns g step => acyclic c
     («及当且仅当一步而所闭».mpr ⟨g, step, returns g (WithinClosure.of_rel step)⟩),
   returnsAlong_of_sink⟩

/-- **On a relation without cycles, held de se at the returning elements, the condition holds
exactly where, if anything is a sink, there is only one element.** With no sink it holds vacuously;
with one, every closure must be the whole, and without cycles two distinct elements cannot each lie
within the other's closure. -/
theorem ownClosure_unrestricted_atReturning_acyclic_iff (acyclic : «无环» rel) :
    Unrestricted (selfAscribed (ownClosure rel) (Subtype.val : Returning rel → X)) ↔
      ((∃ c, ∀ g, ¬ rel c g) → ∀ f g : X, f = g) :=
  ⟨fun unrestricted ⟨c, sink⟩ f g =>
     have whole := (ownClosure_unrestricted_atReturning_iff ⟨c, returnsAlong_of_sink sink⟩).mp
       unrestricted
     match «所闭当且仅当同一或及».mp (whole f g) with
     | .inl same => same
     | .inr there => match «所闭当且仅当同一或及».mp (whole g f) with
       | .inl back => back.symm
       | .inr back => absurd («及之传递» there back) (acyclic f),
   fun one => ownClosure_unrestricted_iff.mpr fun p g =>
     Eq.subst (motive := fun x => WithinClosure rel p.1 x)
       (one ⟨p.1, (returnsAlong_iff_sink acyclic).mp p.2⟩ p.1 g) (WithinClosure.refl p.1)⟩

/-- **On the net read off a continuation, an occurrence returns exactly where nothing continues it.**
-/
theorem Web.continuationStep_returns_iff {F : Type} {R : Nat → F → F → Prop} {x : Nat × F} :
    ReturnsAlong (Web.continuationStep R) x ↔ ∀ g, ¬ R x.1 x.2 g :=
  (returnsAlong_iff_sink Web.continuationStep_acyclic).trans
    ⟨fun sink g step => sink (x.1 + 1, g) ⟨rfl, step⟩, fun none y step => none y.2 step.2⟩

end Sinks

/-! ## The condition over what comes after (续无外于后) -/

section Forward

variable {Pos : Type} {α : Type u}

/-- **The condition over what comes after (续无外于后).** From each center, every occurrence at a later
step than the center's is reached on a line under `E`. -/
def «续无外于后» (R E : «际» α) (time : α → Nat) (center : Pos → α) : Prop :=
  ∀ p x, time (center p) < time x → «所及» R E (center p) x

/-- **Along a net going forward in time, what is reached comes later** (及则后). -/
theorem «及则后» {R : «际» α} {time : α → Nat} (forward : ∀ x y, R x y → time x < time y)
    {x y : α} (reach : «及» R x y) : time x < time y := by
  induction reach with
  | one h => exact forward _ _ h
  | more h _ ih => exact Nat.lt_trans (forward _ _ h) ih

/-- **A net going forward in time has no cycle.** -/
theorem «后则无环» {R : «际» α} {time : α → Nat} (forward : ∀ x y, R x y → time x < time y) :
    «无环» R :=
  fun x reach => Nat.lt_irrefl (time x) («及则后» forward reach)

/-- **What the condition counts on a net going forward in time** (续无外当且仅当后与独). Where every
condition comes at an earlier step than what it conditions, the root's condition `«续无外»` holds
exactly where, from each center, everything at a later step is reached (`«续无外于后»`), and nothing
other than the center lies at or before its step. The second part asks of what lies before and beside
the center, which nothing the center reaches can be. -/
theorem «续无外当且仅当后与独» {R E : «际» α} {time : α → Nat} {center : Pos → α}
    (forward : ∀ x y, R x y → time x < time y) :
    «续无外» R E center ↔
      «续无外于后» R E time center ∧ ∀ p x, time x ≤ time (center p) → center p = x :=
  ⟨fun none => ⟨fun p x _ => none p x, fun p x early => match none p x with
     | .inl same => same
     | .inr line => absurd (Nat.lt_of_lt_of_le («及则后» forward («相续含于及» R E _ _ line)) early)
         (Nat.lt_irrefl _)⟩,
   fun ⟨after, alone⟩ p x => match Nat.lt_or_ge (time (center p)) (time x) with
     | .inl later => after p x later
     | .inr early => .inl (alone p x early)⟩

/-- **The part at and before the center admits one center** (独则同一中心). Where nothing other than each
center lies at or before its step, any two centers are one: whichever comes no later lies at or before
the other's step. No net enters. -/
theorem «独则同一中心» {time : α → Nat} {center : Pos → α}
    (alone : ∀ p x, time x ≤ time (center p) → center p = x) (p q : Pos) : center p = center q :=
  match Nat.le_total (time (center p)) (time (center q)) with
  | .inl early => (alone q (center p) early).symm
  | .inr late => alone p (center q) late

/-- Over what comes after, the condition reads only what is reached forward: on any net, the root's
condition gives it. -/
theorem «续无外则续无外于后» {R E : «际» α} {time : α → Nat} {center : Pos → α}
    (none : «续无外» R E center) : «续无外于后» R E time center :=
  fun p x _ => none p x

end Forward

/-! ### Two sources, one later occurrence -/

namespace TwoSources

/-- Three occurrences: two at the first step, one at the next. -/
inductive Occ
  | a
  | b
  | z

/-- Each source conditions the later occurrence `z`; nothing else is a condition. -/
def net : «际» Occ := fun x y => y = .z ∧ x ≠ .z

/-- `a` and `b` come at the first step, `z` at the next. -/
def time : Occ → Nat
  | .a => 0
  | .b => 0
  | .z => 1

/-- The two centers: `a` and `b`. -/
def center : Bool → Occ
  | true => .a
  | false => .b

theorem center_ne_z : ∀ p, center p ≠ .z
  | true => fun same => Occ.noConfusion same
  | false => fun same => Occ.noConfusion same

/-- The net goes forward in time. -/
theorem forward : ∀ x y, net x y → time x < time y
  | .a, .z, _ => Nat.zero_lt_one
  | .b, .z, _ => Nat.zero_lt_one
  | .z, _, ⟨_, ne⟩ => absurd rfl ne
  | .a, .a, ⟨same, _⟩ => Occ.noConfusion same
  | .a, .b, ⟨same, _⟩ => Occ.noConfusion same
  | .b, .a, ⟨same, _⟩ => Occ.noConfusion same
  | .b, .b, ⟨same, _⟩ => Occ.noConfusion same

/-- **Two centers meet the condition over what comes after, and not the root's condition.** The net has
no cycle; from each of the two distinct centers the one later occurrence is reached on a line under the
one; and the root's condition fails, as the one-center bound says it must. -/
theorem apart :
    «无环» net ∧ center true ≠ center false ∧ «续无外于后» net «一» time center ∧
      ¬ «续无外» net «一» center :=
  ⟨«后则无环» forward, fun same => Occ.noConfusion same,
   fun p x later => match x, later with
     | .z, _ => .inr («及».one ⟨⟨rfl, center_ne_z p⟩, trivial⟩)
     | .a, later => absurd later (Nat.not_lt_zero _)
     | .b, later => absurd later (Nat.not_lt_zero _),
   fun none => Occ.noConfusion («续无外则同一中心» («后则无环» forward) none true false)⟩

end TwoSources

/-! ## A dated relation read off a flow -/

namespace Flow

variable {F C : Type} (L : Flow F C) (W : Web F C)

/-- **Affecting before, on occurrences.** The occurrence `(s, h)` affects `(t, g)` where `s` comes
before `t` and, taking part at `s`, `h` exchanges with a condition `g` requires at `t`: the link of
`Flow.ReachesBefore`. -/
def AffectsBefore (x y : Nat × F) : Prop :=
  x.1 < y.1 ∧ ∃ c, W.requires y.1 y.2 c ∧ x.2 ∈ L.present x.1 ∧
    (0 < L.take x.1 x.2 c ∨ 0 < L.give x.1 x.2 c)

/-- **A step in time.** A formation goes on to its next step, or an occurrence affects a later one. -/
def StepInTime (x y : Nat × F) : Prop :=
  (y.1 = x.1 + 1 ∧ y.2 = x.2) ∨ L.AffectsBefore W x y

/-- `y` lies within `x`'s closure in time. -/
def WithinTime (x y : Nat × F) : Prop :=
  WithinClosure (L.StepInTime W) x y

/-- **Mutual dependence in time from a step.** From every formation at step `t`, every formation's
continuation lies within its closure in time at some step. -/
def MutuallyDependentFrom (t : Nat) : Prop :=
  ∀ f g, ∃ u, L.WithinTime W (t, f) (u, g)

/-- **Mutual dependence in time**: from every step. -/
def MutuallyDependentInTime : Prop :=
  ∀ t, L.MutuallyDependentFrom W t

variable {L W}

/-- **A part reaches a formation before a step exactly where one of its members, at some step, affects
the formation's occurrence at that step.** -/
theorem reachesBefore_iff {part : F → Bool} {t : Nat} {g : F} :
    L.ReachesBefore W part t g ↔ ∃ h s, part h = true ∧ L.AffectsBefore W (s, h) (t, g) :=
  ⟨fun ⟨h, c, s, member, requires, before, present, exchanges⟩ =>
     ⟨h, s, member, before, c, requires, present, exchanges⟩,
   fun ⟨h, s, member, before, c, requires, present, exchanges⟩ =>
     ⟨h, c, s, member, requires, before, present, exchanges⟩⟩

/-- A step in time goes forward. -/
theorem stepInTime_advances {x y : Nat × F} (step : L.StepInTime W x y) : x.1 < y.1 :=
  match step with
  | .inl ⟨next, _⟩ => Eq.subst (motive := fun s => x.1 < s) next.symm (Nat.lt_succ_self x.1)
  | .inr affects => affects.1

/-- **The relation in time has no cycle.** -/
theorem stepInTime_acyclic : «无环» (L.StepInTime W) :=
  «后则无环» (time := Prod.fst) fun _ _ => stepInTime_advances

/-- Affecting before has no cycle. -/
theorem affectsBefore_acyclic : «无环» (L.AffectsBefore W) :=
  «后则无环» (time := Prod.fst) fun _ _ affects => affects.1

/-- **No occurrence returns in time**: each goes on to its next step, which cannot reach it back. -/
theorem not_returnsAlong_stepInTime (x : Nat × F) : ¬ ReturnsAlong (L.StepInTime W) x :=
  fun returns => (returnsAlong_iff_sink stepInTime_acyclic).mp returns (x.1 + 1, x.2) (.inl ⟨rfl, rfl⟩)

/-- **With the returning occurrences as the standpoints, the condition in time holds only
vacuously**: there is none. -/
theorem returningInTime_unrestricted :
    Unrestricted (selfAscribed (ownClosure (L.StepInTime W))
      (Subtype.val : Becoming.Returning (L.StepInTime W) → Nat × F)) :=
  ownClosure_unrestricted_of_none not_returnsAlong_stepInTime

/-- **Along affecting before alone, the returning occurrences are those that affect nothing
later.** -/
theorem returnsAlong_affectsBefore_iff {x : Nat × F} :
    ReturnsAlong (L.AffectsBefore W) x ↔ ∀ y, ¬ L.AffectsBefore W x y :=
  returnsAlong_iff_sink affectsBefore_acyclic

/-- **What lies within an occurrence's closure in time lies within its formation's reach closure**:
forgetting the steps, an exchange before a need is affecting, and going on is staying. -/
theorem WithinTime.withinReach {x y : Nat × F} (within : L.WithinTime W x y) :
    L.WithinReach W x.2 y.2 :=
  fun P closed holds => within (fun z => P z.2)
    (fun a b inside step => match step with
      | .inl ⟨_, same⟩ => Eq.subst (motive := P) same.symm inside
      | .inr ⟨_, c, requires, present, exchanges⟩ =>
        closed a.2 b.2 inside ⟨c, ⟨b.1, requires⟩, a.1, present, exchanges⟩)
    holds

/-- A formation's continuation from a step lies within its closure in time at every later step. -/
theorem withinTime_onward (u : Nat) (g : F) : ∀ k, L.WithinTime W (u, g) (u + k, g)
  | 0 => WithinClosure.refl _
  | k + 1 => WithinClosure.trans (withinTime_onward u g k) (WithinClosure.of_rel (.inl ⟨rfl, rfl⟩))

/-- **What is reached in time stays reached**: an occurrence of `g` within the closure in time gives
every later occurrence of `g`. -/
theorem WithinTime.later {x : Nat × F} {u u' : Nat} {g : F} (within : L.WithinTime W x (u, g))
    (le : u ≤ u') : L.WithinTime W x (u', g) :=
  match Nat.le.dest le with
  | ⟨k, at_⟩ => Eq.subst (motive := fun r => L.WithinTime W x (r, g)) at_
      (WithinClosure.trans within (withinTime_onward u g k))

/-- What lies within an occurrence's closure in time comes no earlier. -/
theorem WithinTime.le {x y : Nat × F} (within : L.WithinTime W x y) : x.1 ≤ y.1 :=
  match «所闭当且仅当同一或及».mp within with
  | .inl same => Nat.le_of_eq (congrArg Prod.fst same)
  | .inr reach => Nat.le_of_lt («及则后» (time := Prod.fst) (fun _ _ => stepInTime_advances) reach)

/-- **Mutual dependence in time from a step holds from every earlier step**: a formation goes on to
the later step. -/
theorem MutuallyDependentFrom.earlier {t t' : Nat} (dependent : L.MutuallyDependentFrom W t)
    (le : t' ≤ t) : L.MutuallyDependentFrom W t' :=
  fun f g => match dependent f g, Nat.le.dest le with
    | ⟨u, within⟩, ⟨k, at_⟩ => ⟨u, WithinClosure.trans
        (Eq.subst (motive := fun r => L.WithinTime W (t', f) (r, f)) at_ (withinTime_onward t' f k))
        within⟩

/-- **Mutual dependence in time from any step gives mutual dependence.** -/
theorem MutuallyDependentFrom.mutuallyDependent {t : Nat} (dependent : L.MutuallyDependentFrom W t) :
    L.MutuallyDependent W :=
  mutuallyDependent_iff_reach.mpr fun f g => match dependent f g with
    | ⟨_, within⟩ => within.withinReach

/-- **And so the first join's condition**: held de se along affecting at the returning formations,
the presupposition is the continuation condition. -/
theorem MutuallyDependentFrom.returning_unrestricted {t : Nat}
    (dependent : L.MutuallyDependentFrom W t) :
    Unrestricted (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F)) :=
  fun i => (returning_unrestricted_iff_mutuallyDependent ⟨i.1.1, i.1.2⟩).mpr
    dependent.mutuallyDependent i

end Flow

/-! ## The condition in time, held de se -/

section Dated

variable {Pos F : Type}

/-- **The self's presupposition in time, held de se**: from a standpoint, the continuation of `g` at
`t`, where `(t, g)` lies within the closure of the standpoint's own center, an occurrence, along a
relation on occurrences. It is `selfAscribed` with the center at a step and the formations unstepped. -/
def datedOwnClosure (rel : «际» (Nat × F)) (center : Pos → Nat × F) : Pos → Nat → F → Prop :=
  fun p t g => WithinClosure rel (center p) (t, g)

/-- **The condition over every step after the standpoint's own**: from every standpoint, the
continuation of everything at every later step than its own has significance. -/
def UnrestrictedAfter (sig : Pos → Nat → F → Prop) (step : Pos → Nat) : Prop :=
  ∀ p t g, step p < t → sig p t g

/-- **The condition from some step on**: from every standpoint, every formation's continuation has
significance at every step from some step on. -/
def UnrestrictedEventually (sig : Pos → Nat → F → Prop) : Prop :=
  ∀ p g, ∃ T, ∀ t, T ≤ t → sig p t g

/-- Over every later step gives from some step on. -/
theorem UnrestrictedAfter.eventually {sig : Pos → Nat → F → Prop} {step : Pos → Nat}
    (after : UnrestrictedAfter sig step) : UnrestrictedEventually sig :=
  fun p g => ⟨step p + 1, fun _ le => after p _ g (Nat.lt_of_succ_le le)⟩

/-- **Held de se in time, the condition over what comes after is the root's (续无外于后)** at the one
of the relation, the step of an occurrence its time. -/
theorem unrestrictedAfter_iff_forward {rel : «际» (Nat × F)} {center : Pos → Nat × F} :
    UnrestrictedAfter (datedOwnClosure rel center) (fun p => (center p).1) ↔
      «续无外于后» rel «一» Prod.fst center :=
  ⟨fun after p x later => withinClosure_iff_reached.mp (after p x.1 x.2 later),
   fun none p t g later => withinClosure_iff_reached.mpr (none p (t, g) later)⟩

end Dated

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **Over every step, the condition in time fails wherever there is a formation**: held de se at every
occurrence, the occurrence of a formation at the second step does not reach its occurrence at the first,
nothing reaching an earlier step. -/
theorem not_unrestricted_inTime (f : F) :
    ¬ Unrestricted (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F)) :=
  fun unrestricted => Nat.not_succ_le_zero 0
    (WithinTime.le (L := L) (W := W) (unrestricted ((1, f), 0, f)))

/-- **Held de se at every occurrence, the condition from some step on holds exactly where the flow is
mutually dependent in time**: the dated counterpart of the join with every formation a standpoint
(`Flow.mutuallyDependent_iff_unrestricted`, route (b)'s G3 piece, not imported here), which along affecting
gives the first join's condition (`Flow.returning_unrestricted_iff_mutuallyDependent`). -/
theorem unrestrictedEventually_iff_mutuallyDependentInTime :
    UnrestrictedEventually (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F)) ↔
      L.MutuallyDependentInTime W :=
  ⟨fun eventually t f g => match eventually (t, f) g with
     | ⟨T, all⟩ => ⟨T, all T (Nat.le_refl T)⟩,
   fun dependent p g => match dependent p.1 p.2 g with
     | ⟨u, within⟩ => ⟨u, fun _ le => within.later le⟩⟩

/-- **Held de se at every occurrence, the condition over every later step holds exactly where, at every
step, every formation affects every other at the next step.** What comes at the next step is reached
only by one step in time. -/
theorem unrestrictedAfter_iff_coupledEachStep :
    UnrestrictedAfter (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F))
        Prod.fst ↔
      ∀ t f g, f = g ∨ L.AffectsBefore W (t, f) (t + 1, g) :=
  ⟨fun after t f g =>
     match «所闭当且仅当同一或及».mp (after (t, f) (t + 1) g (Nat.lt_succ_self t)) with
     | .inl same => .inl (congrArg Prod.snd same)
     | .inr reach => match «及当且仅当一步而所闭».mp reach with
       | ⟨_, step, rest⟩ => match «所闭当且仅当同一或及».mp rest with
         | .inl same => match Eq.subst (motive := fun z => L.StepInTime W (t, f) z) same step with
           | .inl ⟨_, same'⟩ => .inl same'.symm
           | .inr affects => .inr affects
         | .inr more => absurd (Nat.lt_of_lt_of_le
             («及则后» (time := Prod.fst) (fun _ _ => stepInTime_advances) more)
             (Nat.succ_le_of_lt (stepInTime_advances step))) (Nat.lt_irrefl _),
   fun coupled p _ g later =>
     have next : L.WithinTime W p (p.1 + 1, g) := match coupled p.1 p.2 g with
       | .inl same => WithinClosure.of_rel (.inl ⟨rfl, same.symm⟩)
       | .inr affects => WithinClosure.of_rel (.inr affects)
     next.later (Nat.succ_le_of_lt later)⟩

end Flow

/-! ## Witnesses -/

/-! ### Exchanges that recur -/

namespace Recurring

/-- Each of two formations, at every step, takes one unit from the other's condition and gives one
back. -/
def flow : Flow Bool Bool where
  present _ := [true, false]
  take _ f c := match f, c with
    | true, true => 0
    | true, false => 1
    | false, true => 1
    | false, false => 0
  give _ f c := match f, c with
    | true, true => 0
    | true, false => 1
    | false, true => 1
    | false, false => 0

/-- Each requires its own condition at every step; both stand at one. -/
def web : Web Bool Bool where
  level _ _ := 1
  active _ _ := True
  requires _ f c := f = c
  need _ _ _ := 1
  draws _ f c := f ≠ c

/-- The flow balances. -/
theorem balances : flow.Balances web
  | _, true => rfl
  | _, false => rfl

/-- At every step each affects the other at the next. -/
theorem coupled : ∀ t f g, f = g ∨ flow.AffectsBefore web (t, f) (t + 1, g)
  | _, true, true => .inl rfl
  | _, false, false => .inl rfl
  | t, true, false => .inr ⟨Nat.lt_succ_self t, false, rfl, .head _, .inl Nat.zero_lt_one⟩
  | t, false, true => .inr ⟨Nat.lt_succ_self t, true, rfl, .tail _ (.head _), .inl Nat.zero_lt_one⟩

/-- **The positive half survives in time, with two formations.** The flow balances; held de se at
every occurrence, the condition over every later step holds, and so the condition from some step on;
the flow is mutually dependent in time. -/
theorem inTime :
    flow.Balances web ∧ (true ≠ false) ∧
      UnrestrictedAfter (datedOwnClosure (flow.StepInTime web)
        (id : Nat × Bool → Nat × Bool)) Prod.fst ∧
      flow.MutuallyDependentInTime web :=
  have after := Flow.unrestrictedAfter_iff_coupledEachStep.mpr coupled
  ⟨balances, fun same => Bool.noConfusion same, after,
   Flow.unrestrictedEventually_iff_mutuallyDependentInTime.mp after.eventually⟩

/-- **What the one-center bound counts, on this flow.** With every occurrence a center, the root's
condition over what comes after holds along the relation in time, and the root's condition `«续无外»`
fails: it would ask each occurrence to reach the other formation's occurrence at its own step. -/
theorem oneCenter_counts :
    «续无外于后» (flow.StepInTime web) «一» Prod.fst (id : Nat × Bool → Nat × Bool) ∧
      ¬ «续无外» (flow.StepInTime web) «一» (id : Nat × Bool → Nat × Bool) :=
  ⟨unrestrictedAfter_iff_forward.mp inTime.2.2.1,
   fun none => Bool.noConfusion (congrArg Prod.snd
     («续无外则同一中心» Flow.stepInTime_acyclic none (0, true) (0, false)))⟩

end Recurring

/-! ### A ring of three -/

namespace RingOfThree

/-- Three formations, each the condition of its own kind. -/
inductive Three
  | a
  | b
  | c

/-- Each draws on the next one's condition: `a` on `b`'s, `b` on `c`'s, `c` on `a`'s. -/
def next : Three → Three
  | .a => .b
  | .b => .c
  | .c => .a

/-- One unit where the second is the next after the first, else none. -/
def draw : Three → Three → Nat
  | .a, .a => 0
  | .a, .b => 1
  | .a, .c => 0
  | .b, .a => 0
  | .b, .b => 0
  | .b, .c => 1
  | .c, .a => 1
  | .c, .b => 0
  | .c, .c => 0

/-- At every step each takes one unit from the next one's condition and gives one back. -/
def flow : Flow Three Three where
  present _ := [.a, .b, .c]
  take _ f d := draw f d
  give _ f d := draw f d

/-- Each requires its own condition at every step; all stand at one. -/
def web : Web Three Three where
  level _ _ := 1
  active _ _ := True
  requires _ f d := f = d
  need _ _ _ := 1
  draws _ f d := d = next f

/-- The flow balances. -/
theorem balances : flow.Balances web
  | _, .a => rfl
  | _, .b => rfl
  | _, .c => rfl

theorem mem_a (t : Nat) : Three.a ∈ flow.present t := .head _
theorem mem_b (t : Nat) : Three.b ∈ flow.present t := .tail _ (.head _)
theorem mem_c (t : Nat) : Three.c ∈ flow.present t := .tail _ (.tail _ (.head _))

/-- Each affects the next one at every later step. -/
theorem affects_next (t : Nat) : ∀ f, flow.AffectsBefore web (t, f) (t + 1, next f)
  | .a => ⟨Nat.lt_succ_self t, .b, rfl, mem_a t, .inl Nat.zero_lt_one⟩
  | .b => ⟨Nat.lt_succ_self t, .c, rfl, mem_b t, .inl Nat.zero_lt_one⟩
  | .c => ⟨Nat.lt_succ_self t, .a, rfl, mem_c t, .inl Nat.zero_lt_one⟩

/-- From each formation at a step, the next one at the next step and the one after it two steps
later. -/
theorem reach (t : Nat) (f : Three) :
    flow.WithinTime web (t, f) (t + 1, next f) ∧
      flow.WithinTime web (t, f) (t + 2, next (next f)) :=
  ⟨WithinClosure.of_rel (.inr (affects_next t f)),
   WithinClosure.trans (WithinClosure.of_rel (.inr (affects_next t f)))
     (WithinClosure.of_rel (.inr (affects_next (t + 1) (next f))))⟩

/-- `a` does not affect `c` at the next step: it exchanges only with `b`'s condition. -/
theorem a_not_c : ¬ flow.AffectsBefore web (0, .a) (1, .c) :=
  fun ⟨_, d, requires, _, exchanges⟩ =>
    match d, (requires : Three.c = d), exchanges with
    | _, rfl, .inl pos => absurd pos (Nat.lt_irrefl 0)
    | _, rfl, .inr pos => absurd pos (Nat.lt_irrefl 0)

/-- **The condition over every later step is not mutual dependence in time** (the failed candidate,
kept). The ring balances and is mutually dependent in time; held de se at every occurrence, the
condition from some step on holds and the condition over every later step fails: what lies two links
away is reached two steps later, not at the next. -/
theorem apart :
    flow.Balances web ∧ flow.MutuallyDependentInTime web ∧
      UnrestrictedEventually (datedOwnClosure (flow.StepInTime web)
        (id : Nat × Three → Nat × Three)) ∧
      ¬ UnrestrictedAfter (datedOwnClosure (flow.StepInTime web)
        (id : Nat × Three → Nat × Three)) Prod.fst :=
  have dependent : flow.MutuallyDependentInTime web := fun t f g => match f, g with
    | .a, .a => ⟨t, WithinClosure.refl _⟩
    | .b, .b => ⟨t, WithinClosure.refl _⟩
    | .c, .c => ⟨t, WithinClosure.refl _⟩
    | .a, .b => ⟨t + 1, (reach t .a).1⟩
    | .b, .c => ⟨t + 1, (reach t .b).1⟩
    | .c, .a => ⟨t + 1, (reach t .c).1⟩
    | .a, .c => ⟨t + 2, (reach t .a).2⟩
    | .b, .a => ⟨t + 2, (reach t .b).2⟩
    | .c, .b => ⟨t + 2, (reach t .c).2⟩
  ⟨balances, dependent, Flow.unrestrictedEventually_iff_mutuallyDependentInTime.mpr dependent,
   fun after => match Flow.unrestrictedAfter_iff_coupledEachStep.mp after 0 .a .c with
     | .inl same => Three.noConfusion same
     | .inr affects => a_not_c affects⟩

end RingOfThree

/-! ### Mutual dependence that lapses in time -/

namespace Drawing

/-- **Drawing lapses in time.** The pair, mutually dependent, is mutually dependent in time from the
first step and not from the second: nothing is exchanged after the first step, so from the second on
neither formation's continuation reaches the other's. -/
theorem lapses :
    flow.MutuallyDependent web ∧ flow.MutuallyDependentFrom web 0 ∧
      ¬ flow.MutuallyDependentFrom web 1 :=
  ⟨mutuallyDependent,
   fun f g => match f, g with
    | true, true => ⟨0, WithinClosure.refl _⟩
    | false, false => ⟨0, WithinClosure.refl _⟩
    | true, false => ⟨1, WithinClosure.of_rel (.inr ⟨Nat.zero_lt_one, false, rfl, .head _,
        .inl Nat.zero_lt_one⟩)⟩
    | false, true => ⟨1, WithinClosure.of_rel (.inr ⟨Nat.zero_lt_one, true, rfl, .tail _ (.head _),
        .inl Nat.zero_lt_one⟩)⟩,
   fun dependent => match dependent true false with
    | ⟨u, within⟩ =>
      have stays : ∀ y : Nat × Bool, flow.WithinTime web (1, true) y → y.2 = true ∧ 1 ≤ y.1 :=
        fun _ inside => inside (fun z => z.2 = true ∧ 1 ≤ z.1)
          (fun x _ ⟨same, late⟩ step => match step with
            | .inl ⟨next, kept⟩ => ⟨kept.trans same,
                Eq.subst (motive := fun s => 1 ≤ s) next.symm (Nat.le_succ_of_le late)⟩
            | .inr ⟨_, _, _, _, exchanges⟩ => match x, late, exchanges with
              | (0, _), late, _ => absurd late (Nat.not_succ_le_zero 0)
              | (_ + 1, _), _, .inl pos => absurd pos (Nat.lt_irrefl 0)
              | (_ + 1, _), _, .inr pos => absurd pos (Nat.lt_irrefl 0))
          ⟨rfl, Nat.le_refl 1⟩
      Bool.noConfusion (stays (u, false) within).1⟩

end Drawing

/-! ### Exchanges after the need -/

namespace LatePair

/-- Each of two formations takes one unit from the other's condition across the second step only. -/
def flow : Flow Bool Bool where
  present _ := [true, false]
  take t f c := match t, f, c with
    | 0, _, _ => 0
    | 1, true, true => 0
    | 1, true, false => 1
    | 1, false, true => 1
    | 1, false, false => 0
    | _ + 2, _, _ => 0
  give _ _ _ := 0

/-- Each requires its own condition at the first step only; both stand at one, then fall to nothing
after the second step. -/
def web : Web Bool Bool where
  level t _ := match t with
    | 0 => 1
    | 1 => 1
    | _ + 2 => 0
  active _ _ := True
  requires t f c := f = c ∧ t = 0
  need _ _ _ := 1
  draws _ f c := f ≠ c

/-- The flow balances. -/
theorem balances : flow.Balances web
  | 0, true => rfl
  | 0, false => rfl
  | 1, true => rfl
  | 1, false => rfl
  | _ + 2, true => rfl
  | _ + 2, false => rfl

/-- Each is affected by the other, at no step in time. -/
theorem affected : flow.AffectedBy web true false ∧ flow.AffectedBy web false true :=
  ⟨⟨true, ⟨0, rfl, rfl⟩, 1, .tail _ (.head _), .inl Nat.zero_lt_one⟩,
   ⟨false, ⟨0, rfl, rfl⟩, 1, .head _, .inl Nat.zero_lt_one⟩⟩

/-- The pair is mutually dependent. -/
theorem mutuallyDependent : flow.MutuallyDependent web
  | true, true => WithinClosure.refl _
  | false, false => WithinClosure.refl _
  | true, false => WithinClosure.of_rel affected.1
  | false, true => WithinClosure.of_rel affected.2

/-- Nothing affects anything in time: every need comes at the first step, before any exchange. -/
theorem not_affectsBefore (x y : Nat × Bool) : ¬ flow.AffectsBefore web x y :=
  fun ⟨before, _, ⟨_, first⟩, _⟩ =>
    Nat.not_lt_zero x.1 (Eq.subst (motive := fun s => x.1 < s) first before)

/-- **Mutual dependence carried by exchanges after the need.** The pair balances and is mutually
dependent, so held de se along affecting at the returning formations the presupposition is the
continuation condition (the first join); yet nothing affects anything in time, the flow is mutually
dependent in time from no step, and held de se at every occurrence the condition from some step on
fails. -/
theorem apart :
    flow.Balances web ∧ flow.MutuallyDependent web ∧
      Unrestricted (selfAscribed (ownClosure (flow.Affects web))
        (Subtype.val : flow.Returning web → Bool)) ∧
      (∀ x y, ¬ flow.AffectsBefore web x y) ∧ (∀ t, ¬ flow.MutuallyDependentFrom web t) ∧
      ¬ UnrestrictedEventually (datedOwnClosure (flow.StepInTime web)
        (id : Nat × Bool → Nat × Bool)) :=
  have stays : ∀ x y : Nat × Bool, flow.WithinTime web x y → y.2 = x.2 := fun x _ within =>
    within (fun z => z.2 = x.2)
      (fun _ _ same step => match step with
        | .inl ⟨_, kept⟩ => kept.trans same
        | .inr affects => absurd affects (not_affectsBefore _ _))
      rfl
  have never : ∀ t, ¬ flow.MutuallyDependentFrom web t := fun t dependent =>
    match dependent true false with
    | ⟨u, within⟩ => Bool.noConfusion (stays (t, true) (u, false) within)
  ⟨balances, mutuallyDependent,
   (Flow.returning_unrestricted_iff_mutuallyDependent
     ⟨true, Flow.MutuallyDependent.reachReturns mutuallyDependent true⟩).mpr mutuallyDependent,
   not_affectsBefore, never,
   fun eventually => never 0
     (Flow.unrestrictedEventually_iff_mutuallyDependentInTime.mp eventually 0)⟩

end LatePair

end Becoming
