import Becoming.Viability
import InquirySufficiency

/-!
# Keeping: a guard kept through what the steps keep

`Becoming.Viability` states where no course leaves a guard: every course is counted, whatever
moves it takes. Here the moves are not all alike. A move is usable from a class of
configurations where it is allowed and enabled at each of them, and after it the value the step
keeps (`sense`, a map of steps) narrows the class. This module states, for every process, every
map of its steps to the values they keep, every guard and every condition on moves, when a class
is kept for `n` steps, and how that keeping is carried by plans whose later moves follow the
values kept.

* **Kept for `n` steps.** A class is kept for no steps where the guard holds throughout it, and
  for `n + 1` steps where, besides, some move usable from it leaves, whatever value the step
  keeps, a class kept for `n` steps (`KeptFor`). The class after a move and a value kept is what
  can stand after the move from the class where the step keeps that value (`Seen`); where the
  values kept are listed (`Fin k`), it is `InquirySufficiency.After` (`seen_eq_after`).
* **Plans.** A plan of `n` moves gives a first move and, for each value its step keeps, a
  plan of `n - 1` moves (`Plan`); it keeps the guard from a class where the guard holds there,
  its first move is usable and each continuation keeps the guard from the class seen
  (`Plan.Keeps`). A plan that keeps the guard keeps the class for its length, with no premise
  (`Plan.Keeps.keptFor`). Conversely, a kept class has a plan that keeps it wherever the
  values kept have choice into plans (`KeptFor.plan_of_choice`,
  `keptFor_iff_plan_of_choice`). Listed values have it with no premise
  (`choiceOver_fin`), so there a class is kept exactly where some plan keeps it
  (`keptFor_iff_plan`).
* **The boundary.** For arbitrary values kept the converse is exactly choice: kept classes
  have plans in every process exactly where every relation total on the values has a
  choice function (`plans_iff_choice`). A relation is answered by a two-step keeping problem
  whose second move must be related to the value the first step kept (`Answering`). Choice
  is a hypothesis of the law where it is needed, never assumed.
* **Order.** A narrower class is kept wherever a wider one is (`KeptFor.mono`), a longer
  horizon keeps every shorter one (`KeptFor.shorter`), and a finer map of the steps keeps what a
  coarser one keeps, the moves unchanged (`KeptFor.finer`). The empty class is kept for every
  horizon once there is a move (`keptFor_empty`).
* **Classes kept for every horizon.** A family of classes within the guard, each with a usable
  move leading, whatever value is kept, into the family, keeps each of its classes for every
  horizon (`keptFor_of_closed`). A certificate of `Viability` with a move allowed and enabled
  throughout it is such a family: every class within it is kept for every horizon
  (`Certificate.keptFor`), the invariance kernel among them (`Kernel.keptFor`).
* **What a step keeps matters.** In `Matching`, a hidden bit must be matched by the second
  move. Where the step keeps the bit, the starts are kept for two steps; where it keeps nothing,
  they are not (`Matching.keeping_matters`).
* **Joint plans.** Two plans for two parts run together as one plan of pairs (`Plan.zip`). Where
  every joint step projects onto a step of each part, the joint class lies over classes the
  parts' plans keep, and the joint moves are usable throughout (`Plan.Compatible`), the joint
  plan keeps both guards, each part keeping the value of its own step (`Plan.zip_keeps`); and every
  joint plan that keeps a guard has its moves usable throughout
  (`Plan.compatible_of_zip_keeps`). Projection and joint usability are separate conditions:
  neither follows from the parts' plans.

Which guard marks what an activity needs, which moves are allowed and what a step keeps are
supplied with each application. No premise is added; every declaration has an empty axiom
report.
-/

namespace Becoming

open Generative

universe u v w z

namespace Viability

variable {S : Type u} {A : Type v} {O : Type w}

/-! ## Kept for `n` steps -/

/-- What can stand after the move `a` from a configuration of `B`, where the step keeps the
value `o`. -/
def Seen (P : Process S A) (sense : S → A → S → O) (B : S → Prop) (a : A) (o : O) (t : S) :
    Prop :=
  ∃ s, B s ∧ P.step s a t ∧ sense s a t = o

/-- Where the values kept are listed, what is seen is `InquirySufficiency.After`. -/
theorem seen_eq_after {k : Nat} (P : Process S A) (sense : S → A → S → Fin k) (B : S → Prop)
    (a : A) (o : Fin k) : Seen P sense B a o = InquirySufficiency.After P sense B a o :=
  rfl

/-- A move is usable from a class where it is allowed and enabled at each of its
configurations. -/
def Usable (P : Process S A) (allowed : S → A → Prop) (B : S → Prop) (a : A) : Prop :=
  ∀ s, B s → allowed s a ∧ Enabled P s a

/-- **Kept for `n` steps through what the steps keep.** The guard holds throughout the class,
and, with steps to go, some move usable from the class leaves, whatever value the step keeps, a
class kept for one step fewer. -/
def KeptFor (P : Process S A) (sense : S → A → S → O) (guard : S → Prop)
    (allowed : S → A → Prop) : Nat → (S → Prop) → Prop
  | 0, B => ∀ s, B s → guard s
  | n + 1, B => (∀ s, B s → guard s) ∧
      ∃ a, Usable P allowed B a ∧ ∀ o, KeptFor P sense guard allowed n (Seen P sense B a o)

/-! ## Plans -/

/-- A plan of `n` moves: a first move and, for each value its step keeps, a plan of the
moves after it. -/
inductive Plan (A : Type v) (O : Type w) : Nat → Type (max v w) where
  | stop : Plan A O 0
  | act {n : Nat} (a : A) (next : O → Plan A O n) : Plan A O (n + 1)

/-- What a plan of a given length starts with: nothing for no moves, and otherwise a first move
and the plans after it. -/
def Plan.Split (A : Type v) (O : Type w) (n : Nat) : Type (max v w) :=
  Nat.casesOn (motive := fun _ => Type (max v w)) n PUnit (fun m => A × (O → Plan A O m))

/-- A plan's start: its first move and the plans after it, read off without matching on the
length. -/
def Plan.split {n : Nat} (p : Plan A O n) : Plan.Split A O n :=
  Plan.casesOn (motive := fun m _ => Plan.Split A O m) p PUnit.unit (fun a next => (a, next))

/-- The first move of a plan. -/
def Plan.first {n : Nat} (p : Plan A O (n + 1)) : A := (Plan.split p).1

/-- The plan after the first move, for each value its step keeps. -/
def Plan.rest {n : Nat} (p : Plan A O (n + 1)) : O → Plan A O n := (Plan.split p).2

/-- A plan keeps the guard from a class: the guard holds throughout the class, and, with moves to
go, the first move is usable from it and each continuation keeps the guard from the class
seen. -/
def Plan.Keeps (P : Process S A) (sense : S → A → S → O) (guard : S → Prop)
    (allowed : S → A → Prop) : {n : Nat} → Plan A O n → (S → Prop) → Prop
  | 0, _, B => ∀ s, B s → guard s
  | _ + 1, p, B => (∀ s, B s → guard s) ∧ Usable P allowed B p.first ∧
      ∀ o, Plan.Keeps P sense guard allowed (p.rest o) (Seen P sense B p.first o)

variable {P : Process S A} {sense : S → A → S → O} {guard : S → Prop} {allowed : S → A → Prop}

/-- Where a plan keeps the guard, the guard holds throughout the class. -/
theorem Plan.Keeps.within : {n : Nat} → {p : Plan A O n} → {B : S → Prop} →
    p.Keeps P sense guard allowed B → ∀ s, B s → guard s
  | 0, _, _, keeps => keeps
  | _ + 1, _, _, keeps => keeps.1

/-- Where a plan keeps the guard, its first move is usable. -/
theorem Plan.Keeps.usable_first {n : Nat} {p : Plan A O (n + 1)} {B : S → Prop}
    (keeps : p.Keeps P sense guard allowed B) : Usable P allowed B p.first :=
  keeps.2.1

/-- Where a plan keeps the guard, each continuation keeps it from the class seen. -/
theorem Plan.Keeps.rest {n : Nat} {p : Plan A O (n + 1)} {B : S → Prop}
    (keeps : p.Keeps P sense guard allowed B) :
    ∀ o, (p.rest o).Keeps P sense guard allowed (Seen P sense B p.first o) :=
  keeps.2.2

/-- **A plan that keeps the guard keeps the class for its length.** No premise. -/
theorem Plan.Keeps.keptFor : {n : Nat} → {p : Plan A O n} → {B : S → Prop} →
    p.Keeps P sense guard allowed B → KeptFor P sense guard allowed n B
  | 0, _, _, keeps => keeps
  | _ + 1, p, _, keeps => ⟨keeps.1, p.first, keeps.2.1, fun o => Plan.Keeps.keptFor (keeps.2.2 o)⟩

/-- **Choice over the values kept into `α`**: every relation giving each value something
in `α` is met by one function. A hypothesis where a law needs it, never assumed. -/
def ChoiceOver (O : Type w) (α : Type z) : Prop :=
  ∀ R : O → α → Prop, (∀ o, ∃ x, R o x) → ∃ f : O → α, ∀ o, R o (f o)

/-- **Listed values have choice.** No premise. -/
theorem choiceOver_fin {k : Nat} {α : Type z} : ChoiceOver (Fin k) α :=
  fun R each => InquirySufficiency.finite_choice R each

/-- **Where the values kept have choice into plans, every kept class has a plan keeping it.** -/
theorem KeptFor.plan_of_choice (choice : ∀ n, ChoiceOver O (Plan A O n)) :
    ∀ (n : Nat) {B : S → Prop}, KeptFor P sense guard allowed n B →
      ∃ p : Plan A O n, p.Keeps P sense guard allowed B
  | 0, _, kept => ⟨.stop, kept⟩
  | n + 1, B, kept => match kept.2 with
    | ⟨a, usable, next⟩ =>
      match choice n (fun o p => p.Keeps P sense guard allowed (Seen P sense B a o))
          (fun o => KeptFor.plan_of_choice choice n (next o)) with
      | ⟨f, keeps⟩ => ⟨.act a f, kept.1, usable, keeps⟩

/-- **Where the values kept have choice into plans, a class is kept exactly where some plan
keeps it.** -/
theorem keptFor_iff_plan_of_choice (choice : ∀ n, ChoiceOver O (Plan A O n)) {n : Nat}
    {B : S → Prop} :
    KeptFor P sense guard allowed n B ↔ ∃ p : Plan A O n, p.Keeps P sense guard allowed B :=
  ⟨KeptFor.plan_of_choice choice n, fun ⟨_, keeps⟩ => keeps.keptFor⟩

/-- **Listed values: a class is kept exactly where some plan keeps it.** No premise. -/
theorem keptFor_iff_plan {k : Nat} {listed : S → A → S → Fin k} {n : Nat} {B : S → Prop} :
    KeptFor P listed guard allowed n B ↔ ∃ p : Plan A (Fin k) n, p.Keeps P listed guard allowed B :=
  keptFor_iff_plan_of_choice (fun _ => choiceOver_fin)

/-! ## The boundary: plans for every map of the steps are choice -/

/-- The value of an option known to hold one. -/
theorem get_of_eq_some {β : Type z} : ∀ {a : Option β} (h : a.isSome = true) {x : β}, a = some x →
    a.get h = x
  | some _, _, _, same => Option.some.inj same
  | none, h, _, _ => nomatch h

namespace Answering

variable {O : Type u} {α : Type u} (R : O → α → Prop)

/-- Each configuration carries a value and whether the first step was taken; every step
takes it to its value with the first step taken. -/
def process : Process (O × Bool) (Option α) := ⟨fun s _ t => t = (s.1, true)⟩

/-- A step keeps the value it reaches. -/
def keeps : O × Bool → Option α → O × Bool → O := fun _ _ t => t.1

/-- Before the first step every move is allowed; after it, only a value related to the
value kept. -/
def admits : O × Bool → Option α → Prop :=
  fun s a => s.2 = false ∨ ∃ x, a = some x ∧ R s.1 x

/-- The configurations before the first step. -/
def start : O × Bool → Prop := fun s => s.2 = false

/-- Where each value kept has a related value, the starts are kept for two steps. -/
theorem kept (each : ∀ o, ∃ x, R o x) :
    KeptFor process keeps (fun _ => True) (admits R) 2 start :=
  ⟨fun _ _ => trivial, none, fun s held => ⟨Or.inl held, (s.1, true), rfl⟩,
   fun o => ⟨fun _ _ => trivial,
     match each o with
     | ⟨x, related⟩ => ⟨some x, fun t seen => match seen with
         | ⟨_, _, _, keepsBit⟩ =>
           ⟨Or.inr ⟨x, rfl, Eq.subst (motive := fun z => R z x) keepsBit.symm related⟩,
            (t.1, true), rfl⟩,
         fun _ _ _ => trivial⟩⟩⟩

variable {R}

/-- A plan keeping the starts for two steps answers each value kept with a related value. -/
theorem related {p : Plan (Option α) O 2}
    (keeps : p.Keeps process keeps (fun _ => True) (admits R) start) (o : O) :
    ∃ x, (p.rest o).first = some x ∧ R o x :=
  match ((keeps.rest o).usable_first (o, true) ⟨(o, false), rfl, rfl, rfl⟩).1 with
  | .inl wrong => Bool.noConfusion wrong
  | .inr answered => answered

/-- The answer such a plan gives is a value. -/
theorem answered {p : Plan (Option α) O 2}
    (keeps : p.Keeps process keeps (fun _ => True) (admits R) start) (o : O) :
    ((p.rest o).first).isSome = true :=
  match related keeps o with
  | ⟨_, same, _⟩ => Eq.subst (motive := fun z => z.isSome = true) same.symm rfl

end Answering

/-- **Kept classes have plans in every process exactly where the values kept have choice.**
The direction from right to left is `KeptFor.plan_of_choice`; from left to right, a plan for
`Answering` gives the choice function. -/
theorem plans_iff_choice {O : Type u} :
    (∀ (S A : Type u) (P : Process S A) (sense : S → A → S → O) (guard : S → Prop)
        (allowed : S → A → Prop) (n : Nat) (B : S → Prop),
        KeptFor P sense guard allowed n B → ∃ p : Plan A O n, p.Keeps P sense guard allowed B) ↔
      ∀ α : Type u, ChoiceOver O α :=
  ⟨fun plans α R each =>
    match plans (O × Bool) (Option α) Answering.process Answering.keeps (fun _ => True)
        (Answering.admits R) 2 Answering.start (Answering.kept R each) with
    | ⟨p, keeps⟩ =>
      ⟨fun o => ((p.rest o).first).get (Answering.answered keeps o),
       fun o => match Answering.related keeps o with
         | ⟨_, same, related⟩ =>
           Eq.subst (motive := fun z => R o z) (get_of_eq_some (Answering.answered keeps o) same).symm
             related⟩,
   fun choice _ A _ _ _ _ n _ kept => KeptFor.plan_of_choice (fun m => choice (Plan A O m)) n kept⟩

/-! ## Order -/

/-- What is seen from a narrower class is seen from a wider one. -/
theorem Seen.mono {B C : S → Prop} (narrower : ∀ s, B s → C s) {a : A} {o : O} {t : S} :
    Seen P sense B a o t → Seen P sense C a o t
  | ⟨s, held, step, keepsBit⟩ => ⟨s, narrower s held, step, keepsBit⟩

/-- **A narrower class is kept wherever a wider one is.** -/
theorem KeptFor.mono : ∀ {n : Nat} {B C : S → Prop}, (∀ s, B s → C s) →
    KeptFor P sense guard allowed n C → KeptFor P sense guard allowed n B
  | 0, _, _, narrower, kept => fun s held => kept s (narrower s held)
  | _ + 1, _, _, narrower, kept => match kept.2 with
    | ⟨a, usable, next⟩ => ⟨fun s held => kept.1 s (narrower s held), a,
        fun s held => usable s (narrower s held),
        fun o => KeptFor.mono (fun _ => Seen.mono narrower) (next o)⟩

/-- **A longer horizon keeps every shorter one.** -/
theorem KeptFor.shorter : ∀ {n : Nat} {B : S → Prop},
    KeptFor P sense guard allowed (n + 1) B → KeptFor P sense guard allowed n B
  | 0, _, kept => kept.1
  | _ + 1, _, kept => match kept.2 with
    | ⟨a, usable, next⟩ => ⟨kept.1, a, usable, fun o => KeptFor.shorter (next o)⟩

/-- **A finer map of the steps keeps what a coarser one keeps**, the moves unchanged: the coarser
read off the finer one by `forget`. -/
theorem KeptFor.finer {F : Type z} {fine : S → A → S → F} (forget : F → O)
    (consistent : ∀ s a t, forget (fine s a t) = sense s a t) :
    ∀ {n : Nat} {B : S → Prop}, KeptFor P sense guard allowed n B →
      KeptFor P fine guard allowed n B
  | 0, _, kept => kept
  | _ + 1, _, kept => match kept.2 with
    | ⟨a, usable, next⟩ => ⟨kept.1, a, usable, fun f => KeptFor.mono
        (fun t seen => match seen with
          | ⟨s, held, step, keepsBit⟩ =>
            ⟨s, held, step, (consistent s a t).symm.trans (congrArg forget keepsBit)⟩)
        (KeptFor.finer forget consistent (next (forget f)))⟩

/-- **Once there is a move, the empty class is kept for every horizon.** -/
theorem keptFor_empty (a : A) : ∀ n, KeptFor P sense guard allowed n (fun _ => False)
  | 0 => fun _ empty => False.elim empty
  | n + 1 => ⟨fun _ empty => False.elim empty, a, fun _ empty => False.elim empty,
      fun _ => KeptFor.mono (fun _ seen => match seen with | ⟨_, empty, _, _⟩ => empty)
        (keptFor_empty a n)⟩

/-! ## Classes kept for every horizon -/

/-- **A family of classes within the guard, each with a usable move leading, whatever value is
kept, into the family, keeps each of its classes for every horizon.** -/
theorem keptFor_of_closed (family : (S → Prop) → Prop)
    (within : ∀ B, family B → ∀ s, B s → guard s)
    (closed : ∀ B, family B → ∃ a, Usable P allowed B a ∧ ∀ o, family (Seen P sense B a o)) :
    ∀ n {B : S → Prop}, family B → KeptFor P sense guard allowed n B
  | 0, B, held => within B held
  | n + 1, B, held => match closed B held with
    | ⟨a, usable, next⟩ =>
      ⟨within B held, a, usable, fun o => keptFor_of_closed family within closed n (next o)⟩

/-- **A certificate with a move allowed and enabled throughout keeps every class within it for
every horizon**, whatever the steps keep. -/
theorem Certificate.keptFor {K : S → Prop} (cert : Certificate P guard K) {a : A}
    (usable : Usable P allowed K a) :
    ∀ n {B : S → Prop}, (∀ s, B s → K s) → KeptFor P sense guard allowed n B :=
  keptFor_of_closed (fun B => ∀ s, B s → K s)
    (fun _ inside s held => cert.within s (inside s held))
    (fun _ inside => ⟨a, fun s held => usable s (inside s held),
      fun _ t seen => match seen with
        | ⟨s, held, step, _⟩ => cert.closed s a t step (inside s held)⟩)

/-- **Where one move is allowed and enabled throughout the kernel, every class within the kernel is
kept for every horizon**, whatever the steps keep. -/
theorem Kernel.keptFor {a : A} (usable : Usable P allowed (Kernel P guard) a) :
    ∀ n {B : S → Prop}, (∀ s, B s → Kernel P guard s) → KeptFor P sense guard allowed n B :=
  Certificate.keptFor (kernel_certificate P guard) usable

/-! ## What a step keeps matters -/

namespace Matching

/-- A start or a need, each carrying a hidden bit, or an outcome. -/
inductive Stage where
  | start (b : Bool)
  | need (b : Bool)
  | done
  | lost

/-- From a start the need with its bit follows; a need is met by the move matching its bit and
lost by the other; the outcomes stay. -/
def step : Stage → Bool → Stage
  | .start b, _ => .need b
  | .need b, a => match b, a with
    | true, true => .done
    | true, false => .lost
    | false, true => .lost
    | false, false => .done
  | .done, _ => .done
  | .lost, _ => .lost

/-- Each move from a stage leads to its step. -/
def process : Process Stage Bool := ⟨fun s a t => t = step s a⟩

/-- Every stage but the loss is safe. -/
def safe : Stage → Prop
  | .start _ => True
  | .need _ => True
  | .done => True
  | .lost => False

/-- The starts. -/
def starts : Stage → Prop
  | .start _ => True
  | .need _ => False
  | .done => False
  | .lost => False

/-- The hidden bit a stage carries. -/
def bit : Stage → Bool
  | .start b => b
  | .need b => b
  | .done => false
  | .lost => false

/-- The step keeps the bit of the stage reached. -/
def keepsBit : Stage → Bool → Stage → Bool := fun _ _ t => bit t

/-- The step keeps nothing. -/
def keepsNothing : Stage → Bool → Stage → Unit := fun _ _ _ => ()

theorem step_matched : ∀ b, step (.need b) b = .done
  | true => rfl
  | false => rfl

theorem step_unmatched : ∀ a, step (.need (!a)) a = .lost
  | true => rfl
  | false => rfl

/-- After the first move, the step keeping the bit, the class seen is the need with that bit. -/
theorem seen_start {a o : Bool} {t : Stage} :
    Seen process keepsBit starts a o t → t = .need o
  | ⟨.start _, _, reached, same⟩ =>
    Eq.trans reached (congrArg Stage.need (Eq.trans (congrArg bit reached).symm same))
  | ⟨.need _, held, _, _⟩ => False.elim held
  | ⟨.done, held, _, _⟩ => False.elim held
  | ⟨.lost, held, _, _⟩ => False.elim held

/-- **Where the step keeps the bit, the starts are kept for two steps.** -/
theorem keepsBit_kept : KeptFor process keepsBit safe (fun _ _ => True) 2 starts :=
  ⟨fun s held => match s, held with
    | .start _, _ => trivial
    | .need _, held => False.elim held
    | .done, held => False.elim held
    | .lost, held => False.elim held,
   true, fun s _ => ⟨trivial, step s true, rfl⟩,
   fun o => ⟨fun _ seen => Eq.subst (motive := safe) (seen_start seen).symm trivial,
     o, fun t _ => ⟨trivial, step t o, rfl⟩,
     fun _ _ seen => match seen with
       | ⟨_, earlier, reached, _⟩ =>
         Eq.subst (motive := safe)
           (Eq.trans (Eq.trans reached (congrArg (fun z => step z o) (seen_start earlier)))
             (step_matched o)).symm trivial⟩⟩

/-- **Where the step keeps nothing, the starts are not kept for two steps**: whatever the second
move, one of the needs is lost. -/
theorem keepsNothing_not_kept : ¬ KeptFor process keepsNothing safe (fun _ _ => True) 2 starts :=
  fun kept => match kept.2 with
    | ⟨_, _, next⟩ => match (next ()).2 with
      | ⟨second, _, last⟩ =>
        Eq.subst (motive := safe) (step_unmatched second)
          (last () (step (.need (!second)) second)
            ⟨.need (!second), ⟨.start (!second), trivial, rfl, rfl⟩, rfl, rfl⟩)

/-- **What a step keeps matters**: the same process, guard and moves keep the starts for two
steps where the step keeps the hidden bit, and not where it keeps nothing. -/
theorem keeping_matters :
    KeptFor process keepsBit safe (fun _ _ => True) 2 starts ∧
      ¬ KeptFor process keepsNothing safe (fun _ _ => True) 2 starts :=
  ⟨keepsBit_kept, keepsNothing_not_kept⟩

end Matching

/-! ## Joint plans -/

section Joint

variable {X Y : Type u} {M N : Type v} {Q R : Type w}

/-- Two plans of one length run together as one plan of pairs, each part continuing by the value
its own step keeps. -/
def Plan.zip : {n : Nat} → Plan M Q n → Plan N R n → Plan (M × N) (Q × R) n
  | 0, _, _ => .stop
  | _ + 1, p, q => .act (p.first, q.first) fun o => Plan.zip (p.rest o.1) (q.rest o.2)

/-- The joint map of steps: each part keeps the value of its own step. -/
def jointSense (left : X → M → X → Q) (right : Y → N → Y → R) (πX : S → X) (πY : S → Y) :
    S → M × N → S → Q × R :=
  fun s m t => (left (πX s) m.1 (πX t), right (πY s) m.2 (πY t))

/-- Two plans are compatible from a joint class where each pair of moves they make together is
usable from the joint class it is made from. -/
def Plan.Compatible (P : Process S (M × N)) (sense : S → M × N → S → Q × R)
    (allowed : S → M × N → Prop) : {n : Nat} → Plan M Q n → Plan N R n → (S → Prop) → Prop
  | 0, _, _, _ => True
  | _ + 1, p, q, C => Usable P allowed C (p.first, q.first) ∧
      ∀ o, Plan.Compatible P sense allowed (p.rest o.1) (q.rest o.2)
        (Seen P sense C (p.first, q.first) o)

/-- **Joint plans.** Where every joint step projects onto a step of each part, the joint class
lies over classes the parts' plans keep, and the plans are compatible, the joint plan keeps both
guards. -/
theorem Plan.zip_keeps {P : Process S (M × N)} {PX : Process X M} {PY : Process Y N}
    {πX : S → X} {πY : S → Y} {left : X → M → X → Q} {right : Y → N → Y → R}
    {guardX : X → Prop} {guardY : Y → Prop} {allowedX : X → M → Prop} {allowedY : Y → N → Prop}
    {allowed : S → M × N → Prop}
    (project : ∀ s m t, P.step s m t → PX.step (πX s) m.1 (πX t) ∧ PY.step (πY s) m.2 (πY t)) :
    ∀ {n : Nat} {p : Plan M Q n} {q : Plan N R n} {C : S → Prop} {CX : X → Prop}
      {CY : Y → Prop}, (∀ s, C s → CX (πX s) ∧ CY (πY s)) →
      p.Keeps PX left guardX allowedX CX → q.Keeps PY right guardY allowedY CY →
      Plan.Compatible P (jointSense left right πX πY) allowed p q C →
      (Plan.zip p q).Keeps P (jointSense left right πX πY)
        (fun s => guardX (πX s) ∧ guardY (πY s)) allowed C
  | 0, _, _, _, _, _, cover, keepsX, keepsY, _ =>
    fun s held => ⟨keepsX _ (cover s held).1, keepsY _ (cover s held).2⟩
  | _ + 1, p, q, _, _, _, cover, keepsX, keepsY, compatible =>
    ⟨fun s held => ⟨keepsX.1 _ (cover s held).1, keepsY.1 _ (cover s held).2⟩, compatible.1,
     fun o => Plan.zip_keeps project
       (fun t seen => match seen with
         | ⟨s, held, step, keepsBit⟩ =>
           ⟨⟨πX s, (cover s held).1, (project s (p.first, q.first) t step).1,
              congrArg Prod.fst keepsBit⟩,
            ⟨πY s, (cover s held).2, (project s (p.first, q.first) t step).2,
              congrArg Prod.snd keepsBit⟩⟩)
       (keepsX.2.2 o.1) (keepsY.2.2 o.2) (compatible.2 o)⟩

/-- **Every joint plan that keeps a guard is compatible**: its pairs of moves are usable
throughout. -/
theorem Plan.compatible_of_zip_keeps {P : Process S (M × N)} {sense : S → M × N → S → Q × R}
    {guard : S → Prop} {allowed : S → M × N → Prop} :
    ∀ {n : Nat} {p : Plan M Q n} {q : Plan N R n} {C : S → Prop},
      (Plan.zip p q).Keeps P sense guard allowed C → Plan.Compatible P sense allowed p q C
  | 0, _, _, _, _ => trivial
  | _ + 1, _, _, _, keeps =>
    ⟨keeps.2.1, fun o => Plan.compatible_of_zip_keeps (keeps.2.2 o)⟩

end Joint

end Viability

end Becoming
