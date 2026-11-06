import Becoming.Keeping
import Becoming.Labelled

/-!
# JointKeeping: conditions kept together, and a part kept under every course

`Becoming.Viability` states where no course leaves a guard (`Kernel`), and `Becoming.Keeping`
states when a class is kept for `n` steps through moves taken. This module states, with no premise
beyond what each statement names, how keeping several conditions together relates to keeping
each, and what keeping one formation's activity under every course says about the run it is in.

* **Under every course, conditions decompose exactly.** No course leaves two guards together
  exactly where no course leaves either (`kernel_and_iff`), and for a list of guards, exactly
  where no course leaves any of them (`kernel_allOf_iff`).
* **Along some course, they do not.** A guard is keepable from `s` where some run from `s` stays
  within it (`Keepable`); within finitely many configurations a family that keeps moving is
  keepable from each member (`Onward.KeepsMoving.run`, from `Onward.KeepsMoving.run`).
  Keepable together gives keepable each (`Keepable.left`, `Keepable.right`, `Keepable.each`);
  the converse fails: in `ChoicePoint`, where a move chooses between two continuations, each of
  two guards is keepable from the start and the two together are not
  (`ChoicePoint.each_not_joint`). Where either guard lies in the kernel, keeping both is keeping
  the other alone (`keepable_and_iff_of_kernel_left`, `keepable_and_iff_of_kernel_right`): the
  gap opens only where both conditions go through choices of the course.
* **No rule on the separate answers decides the joint one.** On `ChoicePoint`, two
  configurations have both guards keepable and only one of them has both together
  (`ChoicePoint.joint_differs`). Decisions of the three keepabilities exist there
  (`ChoicePoint.decisions_exist`), and for every rule `F : Bool → Bool → Bool` and every such
  decision, the joint decision is not `F` of the separate ones
  (`ChoicePoint.no_rule_decides_joint`); no rule on the separate propositions that respects
  their equivalence decides it either (`ChoicePoint.no_respecting_rule_decides_joint`). Of the
  two directions between the joint answer and the separate ones, the one that holds in general
  is that where one guard is not keepable, the two together are not (`Keepable.each`).
* **Kept for `n` steps.** A wider guard is kept wherever a narrower one is
  (`KeptFor.guard_mono`), so a class kept for both guards together is kept for each
  (`KeptFor.each`). On `ChoicePoint` the start is kept for each guard for every horizon and for the two
  together not even for one step (`ChoicePoint.keptFor_each_not_joint`).
* **Keeping a part decides neither renewal nor what the run does to others.** Whether no course
  leaves a guard is a fact of the configuration, shared by every run from it (`Kernel.run`),
  while renewing is a fact of the run. In `Renewable` (`Becoming.Renewal`, read along runs in
  `Becoming.Labelled`), the guard "the focal formation is active" holds at every configuration,
  so no course leaves it (`kept_part_not_renewal` states this at the starting configuration; the
  same one-line proof serves every other); from that configuration one run is renewing and
  another consumes the condition of the sustaining formation, which ends
  (`Renewable.kept_part_not_renewal`, from `Renewable.class_belongs_to_the_run`); the sustaining
  formation's activity is keepable there and not in the kernel.

Which guards mark what each activity needs is supplied with each application. No premise is added;
every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w

namespace Viability

variable {S : Type u} {A : Type v}

/-! ## Under every course, conditions decompose exactly -/

/-- **No course leaves two guards together exactly where no course leaves either.** -/
theorem kernel_and_iff {P : Process S A} {g₁ g₂ : S → Prop} {s : S} :
    Kernel P (fun x => g₁ x ∧ g₂ x) s ↔ Kernel P g₁ s ∧ Kernel P g₂ s :=
  ⟨fun kept => ⟨Kernel.mono (fun _ both => both.1) kept, Kernel.mono (fun _ both => both.2) kept⟩,
   fun ⟨kept₁, kept₂⟩ t reach => ⟨kept₁ t reach, kept₂ t reach⟩⟩

/-- All the guards of a list hold at a configuration. -/
def AllOf : List (S → Prop) → S → Prop
  | [], _ => True
  | g :: gs, s => g s ∧ AllOf gs s

/-- **No course leaves a list of guards together exactly where no course leaves any of them.** -/
theorem kernel_allOf_iff {P : Process S A} :
    ∀ {gs : List (S → Prop)} {s : S}, Kernel P (AllOf gs) s ↔ ∀ g, g ∈ gs → Kernel P g s
  | [], _ => ⟨fun _ _ mem => (nomatch mem), fun _ _ _ => trivial⟩
  | g :: gs, s =>
    ⟨fun kept =>
      match (kernel_and_iff (g₁ := g) (g₂ := AllOf gs)).mp kept with
      | ⟨keptHead, keptRest⟩ => fun h mem => match mem with
        | .head _ => keptHead
        | .tail _ inner => (kernel_allOf_iff (gs := gs) (s := s)).mp keptRest h inner,
     fun each => (kernel_and_iff (g₁ := g) (g₂ := AllOf gs)).mpr
      ⟨each g (.head _), (kernel_allOf_iff (gs := gs) (s := s)).mpr
        (fun h inner => each h (.tail _ inner))⟩⟩

/-! ## Along some course -/

/-- A guard is **keepable** from `s` where some run from `s` stays within it. -/
def Keepable (P : Process S A) (g : S → Prop) (s : S) : Prop :=
  ∃ r : Run P, r.state 0 = s ∧ ∀ n, g (r.state n)

/-- A keepable guard holds where it is keepable from. -/
theorem Keepable.start {P : Process S A} {g : S → Prop} {s : S} : Keepable P g s → g s
  | ⟨_, start, held⟩ => start ▸ held 0

/-- A wider guard is keepable wherever a narrower one is. -/
theorem Keepable.mono {P : Process S A} {g g' : S → Prop} (wider : ∀ x, g x → g' x) {s : S} :
    Keepable P g s → Keepable P g' s
  | ⟨r, start, held⟩ => ⟨r, start, fun n => wider _ (held n)⟩

/-- **Keepable together, the first guard is keepable.** -/
theorem Keepable.left {P : Process S A} {g₁ g₂ : S → Prop} {s : S}
    (both : Keepable P (fun x => g₁ x ∧ g₂ x) s) : Keepable P g₁ s :=
  Keepable.mono (fun _ held => held.1) both

/-- **Keepable together, the second guard is keepable.** -/
theorem Keepable.right {P : Process S A} {g₁ g₂ : S → Prop} {s : S}
    (both : Keepable P (fun x => g₁ x ∧ g₂ x) s) : Keepable P g₂ s :=
  Keepable.mono (fun _ held => held.2) both

/-- **Keepable together gives keepable each**: where either guard is not keepable, the two
together are not. The converse fails (`ChoicePoint.each_not_joint`). -/
theorem Keepable.each {P : Process S A} {g₁ g₂ : S → Prop} {s : S}
    (both : Keepable P (fun x => g₁ x ∧ g₂ x) s) : Keepable P g₁ s ∧ Keepable P g₂ s :=
  ⟨both.left, both.right⟩

/-- **Where the first guard lies in the kernel, keeping both is keeping the second alone**:
every run from the start stays within the first guard (`Kernel.run`). -/
theorem keepable_and_iff_of_kernel_left {P : Process S A} {g₁ g₂ : S → Prop} {s : S}
    (kept : Kernel P g₁ s) : Keepable P (fun x => g₁ x ∧ g₂ x) s ↔ Keepable P g₂ s :=
  ⟨Keepable.right, fun ⟨r, start, held⟩ =>
    ⟨r, start, fun n => ⟨Kernel.run r (start.symm ▸ kept) n, held n⟩⟩⟩

/-- **Where the second guard lies in the kernel, keeping both is keeping the first alone.** -/
theorem keepable_and_iff_of_kernel_right {P : Process S A} {g₁ g₂ : S → Prop} {s : S}
    (kept : Kernel P g₂ s) : Keepable P (fun x => g₁ x ∧ g₂ x) s ↔ Keepable P g₁ s :=
  ⟨Keepable.left, fun ⟨r, start, held⟩ =>
    ⟨r, start, fun n => ⟨held n, Kernel.run r (start.symm ▸ kept) n⟩⟩⟩

/-! ## Kept for `n` steps -/

/-- **A wider guard is kept wherever a narrower one is**, for every horizon, the class, the
moves and what the steps keep unchanged. -/
theorem KeptFor.guard_mono {O : Type w} {P : Process S A} {sense : S → A → S → O}
    {allowed : S → A → Prop} {g g' : S → Prop} (wider : ∀ x, g x → g' x) :
    ∀ {n : Nat} {B : S → Prop}, KeptFor P sense g allowed n B → KeptFor P sense g' allowed n B
  | 0, _, kept => fun x held => wider x (kept x held)
  | _ + 1, _, kept => match kept.2 with
    | ⟨a, usable, next⟩ =>
      ⟨fun x held => wider x (kept.1 x held), a, usable,
        fun o => KeptFor.guard_mono wider (next o)⟩

/-- **A class kept for two guards together for `n` steps is kept for each.** -/
theorem KeptFor.each {O : Type w} {P : Process S A} {sense : S → A → S → O}
    {allowed : S → A → Prop} {g₁ g₂ : S → Prop} {n : Nat} {B : S → Prop}
    (both : KeptFor P sense (fun x => g₁ x ∧ g₂ x) allowed n B) :
    KeptFor P sense g₁ allowed n B ∧ KeptFor P sense g₂ allowed n B :=
  ⟨KeptFor.guard_mono (fun _ held => held.1) both, KeptFor.guard_mono (fun _ held => held.2) both⟩

/-! ## The witness: a move chooses between two continuations -/

namespace ChoicePoint

/-- Configurations: a choice point, its two continuations, and a configuration where both
conditions hold together. -/
inductive Config where
  | split
  | left
  | right
  | joint

/-- From `split` the move `true` leads to `left` and `false` to `right`; `left`, `right` and
`joint` each return to themselves under every move. -/
def next : Config → Bool → Config
  | .split, true => .left
  | .split, false => .right
  | .left, _ => .left
  | .right, _ => .right
  | .joint, _ => .joint

/-- The process of the witness: each move takes a configuration where `next` takes it. -/
def process : Process Config Bool := ⟨fun s a t => t = next s a⟩

/-- The first condition holds everywhere but at `right`. -/
def first : Config → Prop
  | .split => True
  | .left => True
  | .right => False
  | .joint => True

/-- The second condition holds everywhere but at `left`. -/
def second : Config → Prop
  | .split => True
  | .left => False
  | .right => True
  | .joint => True

/-- Both conditions. -/
def both (s : Config) : Prop := first s ∧ second s

/-- The course through `left`. -/
def leftState : Nat → Config
  | 0 => .split
  | _ + 1 => .left

/-- The course through `right`. -/
def rightState : Nat → Config
  | 0 => .split
  | _ + 1 => .right

/-- The run choosing `left`. -/
def leftRun : Run process := ⟨leftState, fun _ => true, fun | 0 => rfl | _ + 1 => rfl⟩

/-- The run choosing `right`. -/
def rightRun : Run process := ⟨rightState, fun _ => false, fun | 0 => rfl | _ + 1 => rfl⟩

/-- The run resting at `joint`. -/
def jointRun : Run process := ⟨fun _ => .joint, fun _ => true, fun _ => rfl⟩

/-- Every step from `split` leaves one of the two conditions. -/
theorem split_leaves : ∀ (a : Bool) (t : Config), process.step .split a t → ¬ both t
  | true, _, rfl, ⟨_, second⟩ => second
  | false, _, rfl, ⟨first, _⟩ => first

/-- **Each condition is keepable from `split`, the two together are not.** -/
theorem each_not_joint :
    Keepable process first .split ∧ Keepable process second .split ∧
      ¬ Keepable process both .split :=
  ⟨⟨leftRun, rfl, fun | 0 => trivial | _ + 1 => trivial⟩,
   ⟨rightRun, rfl, fun | 0 => trivial | _ + 1 => trivial⟩,
   fun ⟨r, start, held⟩ => split_leaves (r.act 0) (r.state 1) (start ▸ r.step 0) (held 1)⟩

/-- At `joint` both conditions are keepable together, so each is. -/
theorem joint_keepable : Keepable process both .joint :=
  ⟨jointRun, rfl, fun _ => ⟨trivial, trivial⟩⟩

/-- **Two configurations agree on the separate answers and differ on the joint one**: at `split`
and at `joint` each condition is keepable, and the two together are keepable only at `joint`. -/
theorem joint_differs :
    Keepable process first .split ∧ Keepable process second .split ∧
      Keepable process first .joint ∧ Keepable process second .joint ∧
      ¬ Keepable process both .split ∧ Keepable process both .joint :=
  ⟨each_not_joint.1, each_not_joint.2.1, joint_keepable.left, joint_keepable.right,
   each_not_joint.2.2, joint_keepable⟩

/-- The run resting at a configuration that every move returns to itself. -/
def restRun (c : Config) (rests : next c true = c) : Run process :=
  ⟨fun _ => c, fun _ => true, fun _ => rests.symm⟩

/-- Deciding the first condition's keepability. -/
def decideFirst : Config → Bool
  | .split => true
  | .left => true
  | .right => false
  | .joint => true

/-- Deciding the second condition's keepability. -/
def decideSecond : Config → Bool
  | .split => true
  | .left => false
  | .right => true
  | .joint => true

/-- Deciding the keepability of both together. -/
def decideBoth : Config → Bool
  | .split => false
  | .left => false
  | .right => false
  | .joint => true

/-- **Decisions of the three keepabilities exist**, so the next law is not vacuous. -/
theorem decisions_exist :
    ∃ k₁ k₂ kj : Config → Bool,
      (∀ s, k₁ s = true ↔ Keepable process first s) ∧
      (∀ s, k₂ s = true ↔ Keepable process second s) ∧
      (∀ s, kj s = true ↔ Keepable process both s) :=
  ⟨decideFirst, decideSecond, decideBoth,
   fun
    | .split => ⟨fun _ => each_not_joint.1, fun _ => rfl⟩
    | .left => ⟨fun _ => ⟨restRun .left rfl, rfl, fun _ => trivial⟩, fun _ => rfl⟩
    | .right => ⟨fun no => Bool.noConfusion no, fun yes => False.elim yes.start⟩
    | .joint => ⟨fun _ => joint_keepable.left, fun _ => rfl⟩,
   fun
    | .split => ⟨fun _ => each_not_joint.2.1, fun _ => rfl⟩
    | .left => ⟨fun no => Bool.noConfusion no, fun yes => False.elim yes.start⟩
    | .right => ⟨fun _ => ⟨restRun .right rfl, rfl, fun _ => trivial⟩, fun _ => rfl⟩
    | .joint => ⟨fun _ => joint_keepable.right, fun _ => rfl⟩,
   fun
    | .split => ⟨fun no => Bool.noConfusion no, fun yes => absurd yes each_not_joint.2.2⟩
    | .left => ⟨fun no => Bool.noConfusion no,
        fun yes => False.elim yes.start.2⟩
    | .right => ⟨fun no => Bool.noConfusion no,
        fun yes => False.elim yes.start.1⟩
    | .joint => ⟨fun _ => joint_keepable, fun _ => rfl⟩⟩

/-- **No rule on the separate decisions decides the joint one**: for every `F : Bool → Bool →
Bool` and decisions `k₁`, `k₂`, `kj` of the keepability of the first condition, the second and
both, the joint decision is not `F` of the separate ones at every configuration. -/
theorem no_rule_decides_joint (F : Bool → Bool → Bool) (k₁ k₂ kj : Config → Bool)
    (decides₁ : ∀ s, k₁ s = true ↔ Keepable process first s)
    (decides₂ : ∀ s, k₂ s = true ↔ Keepable process second s)
    (decidesJ : ∀ s, kj s = true ↔ Keepable process both s) :
    ¬ ∀ s, kj s = F (k₁ s) (k₂ s) :=
  fun rule =>
    match joint_differs with
    | ⟨first_split, second_split, first_joint, second_joint, not_split, joint⟩ =>
      have atSplit : kj .split = F true true :=
        (rule .split).trans ((congrArg (fun x => F x (k₂ .split))
          ((decides₁ .split).mpr first_split)).trans
          (congrArg (F true) ((decides₂ .split).mpr second_split)))
      have atJoint : kj .joint = F true true :=
        (rule .joint).trans ((congrArg (fun x => F x (k₂ .joint))
          ((decides₁ .joint).mpr first_joint)).trans
          (congrArg (F true) ((decides₂ .joint).mpr second_joint)))
      have splitFalse : kj .split = false :=
        eq_false_of_ne_true (fun yes => not_split ((decidesJ .split).mp yes))
      have jointTrue : kj .joint = true := (decidesJ .joint).mpr joint
      Bool.noConfusion (splitFalse.symm.trans (atSplit.trans (atJoint.symm.trans jointTrue)))

/-- **No rule on the separate propositions that respects their equivalence decides the joint
one.** -/
theorem no_respecting_rule_decides_joint (F : Prop → Prop → Prop)
    (respects : ∀ {p p' q q' : Prop}, (p ↔ p') → (q ↔ q') → (F p q ↔ F p' q')) :
    ¬ ∀ s, Keepable process both s ↔
      F (Keepable process first s) (Keepable process second s) :=
  fun rule =>
    match joint_differs with
    | ⟨first_split, second_split, first_joint, second_joint, not_split, joint⟩ =>
      not_split ((rule .split).mpr
        ((respects (iff_of_true first_joint first_split)
          (iff_of_true second_joint second_split)).mp ((rule .joint).mp joint)))

/-- Every class within `split` and `left` is kept within the first condition by the move
`true`. -/
theorem first_closed {O : Type w} (sense : Config → Bool → Config → O) :
    ∀ n {B : Config → Prop}, (∀ s, B s → s = .split ∨ s = .left) →
      KeptFor process sense first (fun _ _ => True) n B :=
  keptFor_of_closed (P := process) (sense := sense) (guard := first)
    (allowed := fun _ _ => True) (fun B => ∀ s, B s → s = Config.split ∨ s = Config.left)
    (fun _ inside s held => match s, inside s held with
      | _, .inl rfl => trivial
      | _, .inr rfl => trivial)
    (fun _ inside => ⟨true,
      fun s held => match s, inside s held with
        | _, .inl rfl => ⟨trivial, .left, rfl⟩
        | _, .inr rfl => ⟨trivial, .left, rfl⟩,
      fun _ t seen => match seen with
        | ⟨s, held, moved, _⟩ => match s, inside s held, t, moved with
          | _, .inl rfl, _, rfl => .inr rfl
          | _, .inr rfl, _, rfl => .inr rfl⟩)

/-- Every class within `split` and `right` is kept within the second condition by the move
`false`. -/
theorem second_closed {O : Type w} (sense : Config → Bool → Config → O) :
    ∀ n {B : Config → Prop}, (∀ s, B s → s = .split ∨ s = .right) →
      KeptFor process sense second (fun _ _ => True) n B :=
  keptFor_of_closed (P := process) (sense := sense) (guard := second)
    (allowed := fun _ _ => True) (fun B => ∀ s, B s → s = Config.split ∨ s = Config.right)
    (fun _ inside s held => match s, inside s held with
      | _, .inl rfl => trivial
      | _, .inr rfl => trivial)
    (fun _ inside => ⟨false,
      fun s held => match s, inside s held with
        | _, .inl rfl => ⟨trivial, .right, rfl⟩
        | _, .inr rfl => ⟨trivial, .right, rfl⟩,
      fun _ t seen => match seen with
        | ⟨s, held, moved, _⟩ => match s, inside s held, t, moved with
          | _, .inl rfl, _, rfl => .inr rfl
          | _, .inr rfl, _, rfl => .inr rfl⟩)

/-- **Kept for each, not for both**: whatever the steps keep, the start is kept for the first
condition and for the second for every horizon, and for the two together not for one step,
whatever moves are allowed. -/
theorem keptFor_each_not_joint {O : Type w} (sense : Config → Bool → Config → O) :
    (∀ n, KeptFor process sense first (fun _ _ => True) n (· = .split)) ∧
      (∀ n, KeptFor process sense second (fun _ _ => True) n (· = .split)) ∧
      ∀ allowed : Config → Bool → Prop,
        ¬ KeptFor process sense both allowed 1 (· = .split) :=
  ⟨fun n => first_closed sense n (fun _ held => .inl held),
   fun n => second_closed sense n (fun _ held => .inl held),
   fun _ ⟨_, a, _, after⟩ => match a with
    | true => (after (sense .split true .left) .left ⟨.split, rfl, rfl, rfl⟩).2
    | false => (after (sense .split false .right) .right ⟨.split, rfl, rfl, rfl⟩).1⟩

end ChoicePoint

end Viability

/-! ## Keeping a part is not renewal -/

namespace Renewable

open Viability RelationalRenewal

/-- **A formation's activity kept under every course decides neither renewal nor what the run
does to others.** In `Renewable` the focal formation is active at every configuration, so no
course leaves that guard; the kernel conjunct is stated at this configuration (the same one-line
proof serves every other), and it is a fact of the configuration, shared by every run from it
(`Kernel.run`). From this one
configuration, one run renews and another consumes the condition of the sustaining formation,
which ends from step 1 (`class_belongs_to_the_run`): renewing is a fact of the run. The
sustaining formation's activity, unlike the focal one, is a guard that can fail: it is keepable
from there (the run within renewal) and not in the kernel (the run beyond it). -/
theorem kept_part_not_renewal :
    Kernel process (fun s => conditions.active s .focal) (withinRenewal.state 0) ∧
      withinRenewal.state 0 = beyondRenewal.state 0 ∧
      RenewingIn (conditions.along withinRenewal) .focal ∧
      ConsumingIn (conditions.along beyondRenewal) .focal ∧
      (∀ t, 1 ≤ t → ¬ conditions.active (beyondRenewal.state t) .sustaining) ∧
      Keepable process (fun s => conditions.active s .sustaining) (withinRenewal.state 0) ∧
      ¬ Kernel process (fun s => conditions.active s .sustaining) (withinRenewal.state 0) :=
  match class_belongs_to_the_run with
  | ⟨same, _, renewing, consuming, ends⟩ =>
    ⟨fun _ _ => trivial, same, renewing, consuming, ends,
     ⟨withinRenewal, rfl, fun _ => Nat.le_refl 1⟩,
     fun kept => ends 1 (Nat.le_refl 1) (Kernel.run beyondRenewal kept 1)⟩

end Renewable

end Becoming
