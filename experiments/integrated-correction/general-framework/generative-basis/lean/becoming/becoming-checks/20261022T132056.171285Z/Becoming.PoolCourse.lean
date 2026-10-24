import Becoming.SelectionPool

/-!
# Pool course: how a pool's membership forms along a run, and what it can come to couple into

`Becoming.SelectionPool` states what a pool's selections reach for a fixed group: they are blind
beyond the union of the members' coupling closures and separate exactly what the members do not
all couple alike (`Web.separates_all_iff`). Pools of intelligences are not fixed: who takes part
changes along the run, and often the pool itself decides who joins it (co-optation, hiring by the
current staff, a committee naming its successors, a model family trained on the ratings of the
models before it). This module reads a pool along a run, its members at each step allowed to
depend on the history (`pool : Nat → (Nat → C → Nat) → F → Prop`), and states what such a pool
can come to couple into.

* **A pool's reach lasts with its members.** A member that has coupled two histories apart keeps
  the pool apart at every later step at which it stays (`Web.apart_while_member`); where every
  member at a step couples the two alike up to that step, every selection through the pool there
  selects them alike (`Web.selects_alike_of_members`). What a pool separates at a step is what
  its members at that step separate, so a difference coupled only by members who have left is
  selected alike from their leaving on unless a member who stays, or one who joins, couples it
  apart.
* **A pool that recruits through itself.** A pool admits its next members through its own pooled
  coupling (`Web.RecruitsThrough`) where, under two histories with the same members at a step and
  alike through every member's couplings up to it, the members at the next step are the same.
  Then, from the same members at the start, the members are the same under both histories at
  every step up to and including the first step at which the pool couples them apart
  (`Web.RecruitsThrough.members_alike`), and at that step the pool along either history separates
  them (`Web.RecruitsThrough.first_apart`). So the pool along a history with a loss comes to
  couple into the loss at exactly the step, and through exactly the members, at which the pool
  along the history without it does: a pool recruiting through itself never admits a member
  because of a difference it does not yet couple into.
* **Blind exactly as the course without the difference.** Under the same premises, the pool along
  `l` never couples `l` and `l'` apart exactly when the pool along `l'` never does
  (`Web.RecruitsThrough.alike_iff`); then the members are the same at every step
  (`Web.RecruitsThrough.members_alike_always`), and every selection through the pool at every
  step selects the two alike (`Web.RecruitsThrough.selects_alike`), whatever the selection is: a
  reward, a rule read through the pool (`reading-through-a-pool`), or the pool's next recruitment.
  Read with `l'` the course without a loss: a loss that the course without it never brings a
  member to couple into stays beyond the pool at every step, however large it grows, and nothing
  the pool selects responds to it. This is the membership form of `ClosedCapture.lock_outlives_loss`:
  there the rule and how it is read are formed from the share and nothing in the loop reads beyond
  it; here who reads is formed through what the readers already couple into.
* **The exits, each binding** (`PoolCourse`). A pool of one keeper, recruiting through itself, never
  couples apart a habitat lost from step 1 (`PoolCourse.alone_never_apart`). A pool that admits a
  reader exactly where the habitat reads empty, a rule reading what no member couples into, does
  not recruit through itself (`PoolCourse.called_not_through`) and couples the loss apart at step 1
  (`PoolCourse.called_apart`). A pool that recruits through itself and admits the reader at step 2
  in every history couples the loss apart at step 2, through a member the course without the loss
  holds too (`PoolCourse.scheduled_through`, `PoolCourse.scheduled_apart`). So a pool comes to
  couple into what it does not yet couple into only through an admission not made through it, or
  through members its course would hold anyway.

Premises: `RecruitsThrough` and the same members at the start are supplied; which actual pools
admit through their own coupling is a question of correspondence. Coupling is read as in
`Becoming.Testing` (`Web.AlikeThroughUpTo`: admission and the levels coupled in by level, at every
step up to the one read). Membership is a claim about histories; no count, weight or rule of
aggregation is assumed. No Lean axiom is used.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable {W : Web F C} {obs : F → C → Prop} {pool : Nat → (Nat → C → Nat) → F → Prop}
  {l l' : Nat → C → Nat} {g : F} {s t : Nat}

/-- The pool has the same members at `t` under two histories. -/
def SameMembers (pool : Nat → (Nat → C → Nat) → F → Prop) (l l' : Nat → C → Nat) (t : Nat) :
    Prop :=
  ∀ g, pool t l g ↔ pool t l' g

/-- **A pool admits its next members through its own pooled coupling**: under two histories with
the same members at `t`, alike through every member's couplings up to `t`, the members at `t + 1`
are the same. -/
def RecruitsThrough (W : Web F C) (obs : F → C → Prop)
    (pool : Nat → (Nat → C → Nat) → F → Prop) : Prop :=
  ∀ t l l', SameMembers pool l l' t → W.AlikeThroughAll obs (pool t l) l l' t →
    SameMembers pool l l' (t + 1)

/-- Alike through every member's couplings carries over between groups with the same members. -/
theorem AlikeThroughAll.of_same {group group' : F → Prop} (same : ∀ g, group g ↔ group' g)
    (alike : W.AlikeThroughAll obs group l l' t) : W.AlikeThroughAll obs group' l l' t :=
  fun g member => alike g ((same g).mpr member)

/-- **A pool's reach lasts with its members.** A member that has coupled two histories apart up to
`s` keeps the pool apart at every later step at which it stays. -/
theorem apart_while_member (member : pool t l g) (le : s ≤ t)
    (differ : ¬ W.AlikeThroughUpTo obs g l l' s) :
    ¬ W.AlikeThroughAll obs (pool t l) l l' t :=
  fun alike => differ fun r before => alike g member r (Nat.le_trans before le)

/-- Where every member at `t` couples two histories alike up to `t`, every selection through the
pool at `t` selects them alike. -/
theorem selects_alike_of_members (alike : ∀ g, pool t l g → W.AlikeThroughUpTo obs g l l' t)
    {select : (Nat → C → Nat) → Prop} (through : W.SelectsThroughAll obs (pool t l) t select) :
    select l ↔ select l' :=
  through l l' alike

namespace RecruitsThrough

variable (recruits : W.RecruitsThrough obs pool) (start : SameMembers pool l l' 0)
include recruits start

/-- **Membership is the same up to the first step the pool couples the histories apart.** -/
theorem members_alike :
    ∀ T, (∀ s, s < T → W.AlikeThroughAll obs (pool s l) l l' s) → SameMembers pool l l' T := by
  intro T
  induction T with
  | zero => intro _; exact start
  | succ T ih =>
      intro before
      exact recruits T l l' (ih fun s lt => before s (Nat.lt_succ_of_lt lt))
        (before T (Nat.lt_succ_self T))

/-- **The first step apart is the same along either history.** At the first step at which the pool
along `l` couples `l` and `l'` apart, it has the members of the pool along `l'`, and the pool
along `l'` couples them apart there too. -/
theorem first_apart {T : Nat} (before : ∀ s, s < T → W.AlikeThroughAll obs (pool s l) l l' s)
    (apart : ¬ W.AlikeThroughAll obs (pool T l) l l' T) :
    SameMembers pool l l' T ∧ ¬ W.AlikeThroughAll obs (pool T l') l l' T :=
  have same := members_alike recruits start T before
  ⟨same, fun alike => apart (AlikeThroughAll.of_same (fun g => (same g).symm) alike)⟩

/-- Where the pool along `l'` never couples the histories apart, the members are the same at
every step. -/
theorem members_alike_always (never : ∀ t, W.AlikeThroughAll obs (pool t l') l l' t) :
    ∀ t, SameMembers pool l l' t := by
  intro t
  induction t with
  | zero => exact start
  | succ t ih => exact recruits t l l' ih (AlikeThroughAll.of_same (fun g => (ih g).symm) (never t))

/-- **Blind exactly as the course without the difference.** The pool along `l` never couples `l`
and `l'` apart exactly when the pool along `l'` never does. -/
theorem alike_iff :
    (∀ t, W.AlikeThroughAll obs (pool t l) l l' t) ↔
      ∀ t, W.AlikeThroughAll obs (pool t l') l l' t :=
  ⟨fun never t => AlikeThroughAll.of_same
      (members_alike recruits start t fun s _ => never s) (never t),
   fun never t => AlikeThroughAll.of_same (fun g => (members_alike_always recruits start never t g).symm)
      (never t)⟩

/-- **Nothing the pool selects responds to what its course without the difference never couples
into.** Where no member of the pool along `l'` ever couples `l` and `l'` apart, every selection
through the pool along `l`, at every step, selects them alike. -/
theorem selects_alike (never : ∀ t, ∀ g, pool t l' g → W.AlikeThroughUpTo obs g l l' t)
    {t : Nat} {select : (Nat → C → Nat) → Prop}
    (through : W.SelectsThroughAll obs (pool t l) t select) : select l ↔ select l' :=
  through l l' ((alike_iff recruits start).mpr (fun t => never t) t)

end RecruitsThrough

end Web

/-! ## The exits, each binding -/

namespace PoolCourse

/-- A keeper of what it tends, and a reader of the habitat. -/
inductive Member
  | keeper
  | reader

/-- What the keeper tends, and the habitat. -/
inductive Place
  | kept
  | habitat

/-- The keeper is coupled by level into what it tends, the reader into the habitat. -/
def obs : Member → Place → Prop
  | .keeper, .kept => True
  | .keeper, .habitat => False
  | .reader, .kept => False
  | .reader, .habitat => True

/-- A web requiring nothing, so every formation is admitted at every step. -/
def web : Web Member Place where
  level := fun _ _ => 1
  active := fun _ _ => True
  requires := fun _ _ _ => False
  need := fun _ _ _ => 0
  draws := fun _ _ _ => False

/-- The habitat is lost from step 1; what the keeper tends stands. -/
def lost : Nat → Place → Nat
  | _, .kept => 1
  | t, .habitat => 1 - t

/-- Nothing is lost. -/
def spared : Nat → Place → Nat := fun _ _ => 1

theorem admits_alike (l l' : Nat → Place → Nat) (t : Nat) (g : Member) :
    web.Admits (l t) t g ↔ web.Admits (l' t) t g :=
  ⟨fun _ _ r => (r : False).elim, fun _ _ r => (r : False).elim⟩

/-- The keeper couples the lost and the spared histories alike at every step. -/
theorem keeper_alike (t : Nat) : web.AlikeThroughUpTo obs .keeper lost spared t :=
  fun s _ => ⟨admits_alike lost spared s .keeper, fun c observed =>
    match c, observed with
    | .kept, _ => rfl
    | .habitat, never => nomatch never⟩

/-- The reader couples them apart at every step from 1 on. -/
theorem reader_apart {t : Nat} (one : 1 ≤ t) : ¬ web.AlikeThroughUpTo obs .reader lost spared t :=
  fun alike => absurd ((alike 1 one).2 .habitat trivial) (by decide)

/-- The pool of the keeper alone. -/
def alone : Nat → (Nat → Place → Nat) → Member → Prop := fun _ _ g => g = .keeper

theorem alone_through : web.RecruitsThrough obs alone :=
  fun _ _ _ _ _ _ => Iff.rfl

/-- **Recruiting through itself, the keeper's pool never couples the loss apart.** -/
theorem alone_never_apart (t : Nat) : web.AlikeThroughAll obs (alone t lost) lost spared t :=
  fun g member => by
    cases member
    exact keeper_alike t

/-- The reader is admitted exactly where the habitat reads empty: a rule reading what no member
couples into. -/
def called : Nat → (Nat → Place → Nat) → Member → Prop :=
  fun t l g => g = .keeper ∨ (g = .reader ∧ l t .habitat = 0)

/-- **Admitting by what no member couples into is not recruiting through the pool.** -/
theorem called_not_through : ¬ web.RecruitsThrough obs called := fun recruits =>
  have same : Web.SameMembers called lost spared 0 := fun _ => Iff.rfl
  have alike : web.AlikeThroughAll obs (called 0 lost) lost spared 0 := fun g member =>
    match g, member with
    | .keeper, _ => keeper_alike 0
    | .reader, .inl named => nomatch named
    | .reader, .inr ⟨_, empty⟩ => absurd empty (by decide)
  match (recruits 0 lost spared same alike .reader).mp (Or.inr ⟨rfl, rfl⟩) with
  | .inl named => nomatch named
  | .inr ⟨_, empty⟩ => absurd empty (by decide)

/-- **The pool that calls the reader couples the loss apart at step 1.** -/
theorem called_apart : ¬ web.AlikeThroughAll obs (called 1 lost) lost spared 1 :=
  Web.apart_while_member (Or.inr ⟨rfl, rfl⟩) (Nat.le_refl 1) (reader_apart (Nat.le_refl 1))

/-- The reader is admitted at step 2 in every history. -/
def scheduled : Nat → (Nat → Place → Nat) → Member → Prop :=
  fun t _ g => g = .keeper ∨ (g = .reader ∧ 2 ≤ t)

theorem scheduled_through : web.RecruitsThrough obs scheduled :=
  fun _ _ _ _ _ _ => Iff.rfl

/-- **Recruiting through itself, the scheduled pool couples the loss apart at step 2, through a
member the course without the loss holds too**, and not before. -/
theorem scheduled_apart :
    (∀ s, s < 2 → web.AlikeThroughAll obs (scheduled s lost) lost spared s) ∧
      ¬ web.AlikeThroughAll obs (scheduled 2 lost) lost spared 2 ∧ scheduled 2 spared .reader :=
  ⟨fun s lt g member =>
    match g, member with
    | .keeper, _ => keeper_alike s
    | .reader, .inl named => nomatch named
    | .reader, .inr ⟨_, two⟩ => absurd (Nat.lt_of_lt_of_le lt two) (Nat.lt_irrefl s),
   Web.apart_while_member (Or.inr ⟨rfl, Nat.le_refl 2⟩) (Nat.le_refl 2)
     (reader_apart (by decide)),
   Or.inr ⟨rfl, Nat.le_refl 2⟩⟩

end PoolCourse

end Becoming
