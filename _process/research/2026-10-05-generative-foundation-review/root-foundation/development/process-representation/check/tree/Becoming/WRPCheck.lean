import Becoming.EdgeClosure
import Becoming.GrammarTransport
import Becoming.Labelled
import Becoming.Onward
import Becoming.GrammarRegularity
import Becoming.GrammarCandidates

/-!
# Scratch check of the WRP design's statements (not a landed module)

Processes in the grammar both ways, on the landed definitions: a process's relations, one per move
(`moveRel`, `Becoming.GrammarRegularity`), whose union is the steps (`Steps`, `Becoming.Frame`);
every relation the steps of a one-move process (`edgeProcess`, `Becoming.EdgeClosure`); enabledness
as the correlative «能» at a move's relation (`Becoming.GrammarCandidates`); a deterministic law's
steps as its step relation (`Law.step`, `Becoming.GrammarCourse`); the class of a frame's claims as
likeness to depth zero (`AlikeTo F F 0`, `Becoming.Likeness`). It checks: the truth of a law over
every process's steps carried to every relation; every class a frame's class of claims; the image
of the model with the move inside (`withMove`, `Becoming.Labelled`), the converse of
`withMove_open`, and that up to correspondence this model needs both the class of the same move
and that of the same configuration (the twist and the flip); a trace as the composite of the
moves' relations along its word, with `«迭»` the composite's case for a constant family; runs as
images of the line of steps; factoring through a map, move by move, as an image lying within;
going on along some branch as lying in a family that keeps moving (`Onward.KeepsMoving`), a line
from it under dependent choice and, within finitely many configurations, with nothing chosen;
going on pulled back along lifting; and the witnesses.
-/

namespace Becoming

open Generative

namespace WRPCheck

universe u v w

/-! ## The relations of a process, one per move -/

/-- **A process is exactly its relations, one per move, both ways, by definition.** -/
theorem moveRel_mk {S : Type u} {A : Type v} (F : A → «际» S) :
    moveRel (⟨fun s a t => F a s t⟩ : Process S A) = F := rfl

theorem mk_moveRel {S : Type u} {A : Type v} (P : Process S A) :
    (⟨fun s a t => moveRel P a s t⟩ : Process S A) = P := rfl

/-- The steps are the union of the moves' relations. -/
theorem steps_iff_moveRel {S : Type u} {A : Type v} (P : Process S A) (s t : S) :
    Steps P s t ↔ ∃ a, moveRel P a s t := Iff.rfl

/-- Every relation is the steps of the one-move process of its edges. -/
theorem steps_edgeProcess {α : Type u} (R : «际» α) (s t : α) : Steps (edgeProcess R) s t ↔ R s t :=
  ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- The process with its moves forgotten (`unlabelled`) has the same steps. -/
theorem steps_unlabelled {S : Type u} {A : Type v} (P : Process S A) (s t : S) :
    Steps (unlabelled P) s t ↔ Steps P s t :=
  ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- A deterministic law's steps are its step relation (`Law.step`). -/
theorem steps_lawProcess {S : Type u} (next : S → S) : «谓» (Steps (Law.process next)) (Law.step next) :=
  fun _ _ => ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- Enabledness is the correlative «能» at the move's relation, by definition. -/
theorem enabled_iff_neng {S : Type u} {A : Type v} (P : Process S A) (s : S) (a : A) :
    Enabled P s a ↔ «能» (moveRel P a) s := Iff.rfl

/-! ## A law's truth, carried from every process to every relation -/

/-- **A property of a carrier and a relation, kept by relations alike pointwise, holds of every
process's steps exactly where it holds of every relation.** It carries a law's truth; restating
its statement in the grammar's terms is another matter. -/
theorem forall_steps_iff (T : (α : Type u) → «际» α → Prop)
    (keeps : ∀ α (R R' : «际» α), «谓» R R' → (T α R ↔ T α R')) :
    (∀ (S : Type u) (A : Type v) (P : Process S A), T S (Steps P)) ↔ ∀ (α : Type u) (R : «际» α), T α R :=
  ⟨fun all α R => (keeps α (Steps (⟨fun s _ t => R s t⟩ : Process α PUnit.{v + 1})) R
      fun _ _ => ⟨fun ⟨_, h⟩ => h, fun h => ⟨PUnit.unit, h⟩⟩).mp (all α PUnit (⟨fun s _ t => R s t⟩)),
   fun all _ _ _ => all _ _⟩

/-- The same for the moves' relations, with no hypothesis: by definition (`moveRel_mk`). -/
theorem forall_moveRel_iff (T : (S : Type u) → (A : Type v) → (A → «际» S) → Prop) :
    (∀ S A (P : Process S A), T S A (moveRel P)) ↔ ∀ S A (F : A → «际» S), T S A F :=
  ⟨fun all S A F => all S A ⟨fun s a t => F a s t⟩, fun all _ _ _ => all _ _ _⟩

/-! ## Frames' claims -/

/-- **Every class is the class of a frame's claims** (likeness to depth zero): the claims are the
carrier, realized where `E` relates. -/
theorem class_is_claims {α : Type u} {E : «际» α} (cls : «类» E) (R : «际» α) :
    «谓» (AlikeTo (⟨edgeProcess R, fun s c => E s c⟩ : Frame α Unit α) ⟨edgeProcess R, fun s c => E s c⟩ 0) E :=
  fun _ t => ⟨fun alike => (alike t).mpr (cls.refl t), fun e _ => ⟨fun ec => cls.trans (cls.symm e) ec,
    fun ec => cls.trans e ec⟩⟩

/-! ## The model with the move inside -/

/-- On the fixed carrier `S × A`, the model with the move inside recovers the process. -/
theorem step_iff_withMove {S : Type u} {A : Type v} (P : Process S A) (s : S) (a : A) (t : S) :
    P.step s a t ↔ Steps (withMove P) (s, a) (t, a) :=
  ⟨fun h => ⟨(), h⟩, fun ⟨_, h⟩ => h⟩

/-- **Its image is exactly the relations leaving the next move open**: the converse of
`withMove_open`. -/
theorem withMove_image_iff {S : Type u} {A : Type v} (R : «际» (S × A)) :
    (∃ P : Process S A, «谓» (Steps (withMove P)) R) ↔ ∀ x t b b', R x (t, b) ↔ R x (t, b') :=
  ⟨fun ⟨_, same⟩ x t b b' => (same x (t, b)).symm.trans (same x (t, b')),
   fun leaves => ⟨⟨fun s a t => R (s, a) (t, a)⟩, fun x y =>
     ⟨fun ⟨_, h⟩ => (leaves x y.1 x.2 y.2).mp h, fun h => ⟨(), (leaves x y.1 x.2 y.2).mpr h⟩⟩⟩⟩

/-- **A relation reading the next move is no process's model with the move inside.** -/
theorem reading_next_move_not_withMove :
    ¬ ∃ P : Process Unit Bool, «谓» (Steps (withMove P)) (fun _ y => y.2 = true) :=
  fun has => match (withMove_image_iff _).mp has ((), true) () true false with
    | same => Bool.noConfusion (same.mp rfl)

/-! ### Faithful up to correspondence only with the class of the same configuration (the twist) -/

namespace Twist

def P₁ : Process Bool Bool := ⟨fun s _ _ => s = true⟩
def P₂ : Process Bool Bool := ⟨fun s a _ => (a = true ∧ s = false) ∨ (a = false ∧ s = true)⟩

/-- Flip the configuration where the move is `true`. -/
def twist (x : Bool × Bool) : Bool × Bool := (if x.2 then !x.1 else x.1, x.2)

theorem twist_twist : ∀ x, twist (twist x) = x
  | (false, false) => rfl
  | (false, true) => rfl
  | (true, false) => rfl
  | (true, true) => rfl

def e : «一一对应» (Bool × Bool) (Bool × Bool) := ⟨twist, twist, twist_twist, twist_twist⟩

/-- The class of the same move. -/
def sameMove : «际» (Bool × Bool) := fun x y => x.2 = y.2

theorem twist_steps : ∀ x y : Bool × Bool,
    Steps (withMove P₁) x y ↔ Steps (withMove P₂) (twist x) (twist y)
  | (false, false), _ => ⟨fun ⟨_, h⟩ => Bool.noConfusion h,
      fun ⟨_, h⟩ => match h with
        | .inl ⟨h1, _⟩ => Bool.noConfusion h1
        | .inr ⟨_, h2⟩ => Bool.noConfusion h2⟩
  | (true, false), _ => ⟨fun _ => ⟨(), .inr ⟨rfl, rfl⟩⟩, fun _ => ⟨(), rfl⟩⟩
  | (false, true), _ => ⟨fun ⟨_, h⟩ => Bool.noConfusion h,
      fun ⟨_, h⟩ => match h with
        | .inl ⟨_, h2⟩ => Bool.noConfusion h2
        | .inr ⟨h1, _⟩ => Bool.noConfusion h1⟩
  | (true, true), _ => ⟨fun _ => ⟨(), .inl ⟨rfl, rfl⟩⟩, fun _ => ⟨(), rfl⟩⟩

/-- **The correspondence carries the model of `P₁` to that of `P₂`, the steps and the class of the
same move both.** -/
theorem models_correspond :
    «谓» («像» e.to (Steps (withMove P₁))) (Steps (withMove P₂)) ∧ «谓» («像» e.to sameMove) sameMove :=
  ⟨(«对应之像» e _ _).mpr twist_steps, («对应之像» e _ _).mpr fun _ _ => Iff.rfl⟩

theorem P₂_not_both : ∀ u : Bool, P₂.step u true u → P₂.step u false u → False
  | false, _, h => match h with
    | .inl ⟨h1, _⟩ => Bool.noConfusion h1
    | .inr ⟨_, h2⟩ => Bool.noConfusion h2
  | true, h, _ => match h with
    | .inl ⟨_, h2⟩ => Bool.noConfusion h2
    | .inr ⟨h1, _⟩ => Bool.noConfusion h1

theorem P₂_key : ∀ (u b b' : Bool), P₂.step u b u → P₂.step u b' u → b ≠ b' → False
  | u, true, false, h1, h2, _ => P₂_not_both u h1 h2
  | u, false, true, h1, h2, _ => P₂_not_both u h2 h1
  | _, true, true, _, _, apart => apart rfl
  | _, false, false, _, _, apart => apart rfl

/-- **No renaming of configurations and moves relates the two processes.** -/
theorem not_renamed :
    ¬ ∃ (φ : «一一对应» Bool Bool) (ψ : «一一对应» Bool Bool),
      ∀ s a t, P₁.step s a t ↔ P₂.step (φ.to s) (ψ.to a) (φ.to t) :=
  fun ⟨φ, ψ, same⟩ =>
    have h1 : P₂.step (φ.to true) (ψ.to true) (φ.to true) := (same true true true).mp rfl
    have h2 : P₂.step (φ.to true) (ψ.to false) (φ.to true) := (same true false true).mp rfl
    have apart : ψ.to true ≠ ψ.to false := fun eq => Bool.noConfusion ((ψ.to_eq_iff).mp eq)
    P₂_key (φ.to true) (ψ.to true) (ψ.to false) h1 h2 apart

end Twist

/-! ### Nor is the class of the same configuration alone enough (the flip) -/

namespace Flip

def P₃ : Process Bool Bool := ⟨fun _ a _ => a = true⟩
def P₄ : Process Bool Bool := ⟨fun s a _ => (s = true ∧ a = false) ∨ (s = false ∧ a = true)⟩

/-- Flip the move where the configuration is `true`. -/
def flip (x : Bool × Bool) : Bool × Bool := (x.1, if x.1 then !x.2 else x.2)

theorem flip_flip : ∀ x, flip (flip x) = x
  | (false, false) => rfl
  | (false, true) => rfl
  | (true, false) => rfl
  | (true, true) => rfl

def e : «一一对应» (Bool × Bool) (Bool × Bool) := ⟨flip, flip, flip_flip, flip_flip⟩

/-- The class of the same configuration. -/
def sameConfiguration : «际» (Bool × Bool) := fun x y => x.1 = y.1

theorem flip_steps : ∀ x y : Bool × Bool,
    Steps (withMove P₃) x y ↔ Steps (withMove P₄) (flip x) (flip y)
  | (false, false), _ => ⟨fun ⟨_, h⟩ => Bool.noConfusion h,
      fun ⟨_, h⟩ => match h with
        | .inl ⟨h1, _⟩ => Bool.noConfusion h1
        | .inr ⟨_, h2⟩ => Bool.noConfusion h2⟩
  | (false, true), _ => ⟨fun _ => ⟨(), .inr ⟨rfl, rfl⟩⟩, fun _ => ⟨(), rfl⟩⟩
  | (true, false), _ => ⟨fun ⟨_, h⟩ => Bool.noConfusion h,
      fun ⟨_, h⟩ => match h with
        | .inl ⟨_, h2⟩ => Bool.noConfusion h2
        | .inr ⟨h1, _⟩ => Bool.noConfusion h1⟩
  | (true, true), _ => ⟨fun _ => ⟨(), .inl ⟨rfl, rfl⟩⟩, fun _ => ⟨(), rfl⟩⟩

/-- **The correspondence carries the model of `P₃` to that of `P₄`, the steps and the class of the
same configuration both.** -/
theorem models_correspond :
    «谓» («像» e.to (Steps (withMove P₃))) (Steps (withMove P₄)) ∧
      «谓» («像» e.to sameConfiguration) sameConfiguration :=
  ⟨(«对应之像» e _ _).mpr flip_steps, («对应之像» e _ _).mpr fun _ _ => Iff.rfl⟩

theorem P₄_apart : ∀ b b' : Bool, P₄.step true b true → P₄.step false b' false → b = b' → False
  | true, _, h, _, _ => match h with
    | .inl ⟨_, h2⟩ => Bool.noConfusion h2
    | .inr ⟨h1, _⟩ => Bool.noConfusion h1
  | false, _, _, h, same => match h with
    | .inl ⟨h1, _⟩ => Bool.noConfusion h1
    | .inr ⟨_, h2⟩ => Bool.noConfusion (same.trans h2)

/-- **No renaming of configurations and moves relates the two processes**: in `P₃` both
configurations take the same move, in `P₄` different ones. -/
theorem not_renamed :
    ¬ ∃ (φ : «一一对应» Bool Bool) (ψ : «一一对应» Bool Bool),
      ∀ s a t, P₃.step s a t ↔ P₄.step (φ.to s) (ψ.to a) (φ.to t) :=
  fun ⟨φ, ψ, same⟩ =>
    have h1 : P₄.step (φ.to true) (ψ.to true) (φ.to true) := (same true true true).mp rfl
    have h2 : P₄.step (φ.to false) (ψ.to true) (φ.to false) := (same false true false).mp rfl
    have apart : φ.to true ≠ φ.to false := fun eq => Bool.noConfusion ((φ.to_eq_iff).mp eq)
    match φ.to true, φ.to false, apart, h1, h2 with
    | true, false, _, h1, h2 => P₄_apart _ _ h1 h2 rfl
    | false, true, _, h1, h2 => P₄_apart _ _ h2 h1 rfl
    | true, true, apart, _, _ => apart rfl
    | false, false, apart, _, _ => apart rfl

end Flip

/-! ## Traces: the composite of a family of relations along a word (grammar layer) -/

/-- The composite of a family of relations along a word: no step on the empty word, then each
letter's relation in turn (`«静»`, `«而»`). -/
def wordRel {α : Type u} {A : Type v} (F : A → «际» α) : List A → «际» α
  | [] => «静»
  | a :: as => «而» (F a) (wordRel F as)

/-- **A trace is the composite of the moves' relations along its word.** -/
theorem trace_iff_wordRel {S : Type u} {A : Type v} {P : Process S A} :
    ∀ {as : List A} {s t : S}, Trace P s as t ↔ wordRel (moveRel P) as s t
  | [], _, _ => trace_nil_iff
  | _ :: _, _, _ => trace_cons_iff.trans
      ⟨fun ⟨m, h, rest⟩ => ⟨m, h, trace_iff_wordRel.mp rest⟩, fun ⟨m, h, rest⟩ => ⟨m, h, trace_iff_wordRel.mpr rest⟩⟩

theorem feasible_iff_wordRel {S : Type u} {A : Type v} {P : Process S A} {s : S} {as : List A} :
    Feasible P s as ↔ ∃ t, wordRel (moveRel P) as s t :=
  ⟨fun ⟨t, h⟩ => ⟨t, trace_iff_wordRel.mp h⟩, fun ⟨t, h⟩ => ⟨t, trace_iff_wordRel.mpr h⟩⟩

/-- **`«迭»` is the composite's case for a constant family**: `n` steps of a relation are its composite
along the word of `n` letters. -/
theorem wordRel_replicate {α : Type u} (R : «际» α) :
    ∀ n, wordRel (fun (_ : Unit) => R) (List.replicate n ()) = «迭» R n
  | 0 => rfl
  | n + 1 => congrArg («而» R) (wordRel_replicate R n)

/-! ## The composite's laws, and laws of `«迭»` as its cases (grammar layer, GrammarLaws' owner's
decision (a): `«迭»` keeps its definition, statements and names; its laws are derived where the
composite's law replaces part of the proof) -/

section Composite

variable {α : Type u} {A : Type v}

theorem replicate_add_right (c : A) : ∀ (a b : Nat), List.replicate (b + a) c = List.replicate a c ++ List.replicate b c
  | 0, _ => rfl
  | a + 1, b => congrArg (c :: ·) (replicate_add_right c a b)

theorem replicate_succ_right (c : A) : ∀ n, List.replicate (n + 1) c = List.replicate n c ++ [c]
  | 0 => rfl
  | n + 1 => congrArg (c :: ·) (replicate_succ_right c n)

theorem reverseAux_append_right : ∀ (as r s : List A), List.reverseAux as (r ++ s) = List.reverseAux as r ++ s
  | [], _, _ => rfl
  | b :: as, r, s => reverseAux_append_right as (b :: r) s

/-- The reversed word of `a :: as` is the reversed `as` followed by `a` (proved here: the core lemma's
proof uses `propext`). -/
theorem reverse_cons_right (a : A) (as : List A) : (a :: as).reverse = as.reverse ++ [a] :=
  reverseAux_append_right as [] [a]

theorem reverse_replicate (c : A) : ∀ n, (List.replicate n c).reverse = List.replicate n c
  | 0 => rfl
  | n + 1 => (reverse_cons_right c (List.replicate n c)).trans
      ((congrArg (· ++ [c]) (reverse_replicate c n)).trans (replicate_succ_right c n).symm)

/-- **The composite along a word of two words is the composite of the two.** -/
theorem wordRel_append (F : A → «际» α) : ∀ (as bs : List A) {x z : α},
    wordRel F (as ++ bs) x z ↔ «而» (wordRel F as) (wordRel F bs) x z
  | [], bs, x, z => ⟨fun h => ⟨x, rfl, h⟩,
      fun ⟨_, e, h⟩ => Eq.subst (motive := fun w => wordRel F bs w z) e.symm h⟩
  | _ :: as, bs, _, _ => ⟨fun ⟨m, r, rest⟩ => match (wordRel_append F as bs).mp rest with
      | ⟨y, first, second⟩ => ⟨y, ⟨m, r, first⟩, second⟩,
    fun ⟨y, ⟨m, r, first⟩, second⟩ => ⟨m, r, (wordRel_append F as bs).mpr ⟨y, first, second⟩⟩⟩

/-- **The last letter read last.** -/
theorem wordRel_snoc (F : A → «际» α) (as : List A) (a : A) {x z : α} :
    wordRel F (as ++ [a]) x z ↔ ∃ y, wordRel F as x y ∧ F a y z :=
  (wordRel_append F as [a]).trans
    ⟨fun ⟨y, first, ⟨_, r, e⟩⟩ => ⟨y, first, Eq.subst (motive := fun v => F a y v) e r⟩,
     fun ⟨y, first, r⟩ => ⟨y, first, ⟨z, r, rfl⟩⟩⟩

/-- **The reversed word with the converse family is the converse of the composite.** -/
theorem wordRel_reverse (F : A → «际» α) : ∀ (as : List A) {x y : α},
    wordRel (fun a => «逆» (F a)) as.reverse x y ↔ wordRel F as y x
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | a :: as, x, y =>
    (Iff.of_eq (congrArg (fun l => wordRel (fun a => «逆» (F a)) l x y) (reverse_cons_right a as))).trans
      ((wordRel_snoc _ as.reverse a).trans
        ⟨fun ⟨m, first, r⟩ => ⟨m, r, (wordRel_reverse F as).mp first⟩,
         fun ⟨m, r, rest⟩ => ⟨m, (wordRel_reverse F as).mpr rest, r⟩⟩)

/-- **Where no letter's relation merges, the composite merges nothing.** -/
theorem wordRel_fixedBefore {F : A → «际» α} (merges : ∀ a, «定前» (F a)) : ∀ (as : List A) {x y z : α},
    wordRel F as x z → wordRel F as y z → x = y
  | [], _, _, _, e₁, e₂ => e₁.trans e₂.symm
  | a :: as, x, y, _, ⟨w, r, first⟩, ⟨w', r', second⟩ => by
    have e : w = w' := wordRel_fixedBefore merges as first second
    subst e
    exact merges a x y ⟨w, r, r'⟩

/-- **Where every letter's relation goes alike under `E`, the composite keeps `E`-alike occurrences
alike.** -/
theorem wordRel_alike {F : A → «际» α} {E : «际» α} (alike : ∀ a, «同行» (F a) E) :
    ∀ (as : List A) {x x' y y' : α}, E x x' → wordRel F as x y → wordRel F as x' y' → E y y'
  | [], _, _, _, _, e, e₁, e₂ => by cases e₁; cases e₂; exact e
  | a :: as, x, x', _, _, e, ⟨w, r, first⟩, ⟨w', r', second⟩ =>
    wordRel_alike alike as («同行之逐点».mp (alike a) x x' e w w' r r') first second

end Composite

section Cases

variable {α : Type u}

/-- `«迭之接»`, as the composite's case. -/
theorem steps_compose_case {R : «际» α} (a b : Nat) {x y z : α} (first : «迭» R a x y)
    (second : «迭» R b y z) : «迭» R (b + a) x z :=
  Eq.subst (motive := fun r => r x z) (wordRel_replicate R (b + a))
    (Eq.subst (motive := fun l => wordRel (fun (_ : Unit) => R) l x z) (replicate_add_right () a b).symm
      ((wordRel_append (fun (_ : Unit) => R) (List.replicate a ()) (List.replicate b ())).mpr
        ⟨y, Eq.subst (motive := fun r => r x y) (wordRel_replicate R a).symm first,
          Eq.subst (motive := fun r => r y z) (wordRel_replicate R b).symm second⟩))

/-- `«迭之分»`, as the composite's case. -/
theorem steps_split_case {R : «际» α} (a : Nat) {b : Nat} {x z : α} (steps : «迭» R (b + a) x z) :
    ∃ y, «迭» R a x y ∧ «迭» R b y z :=
  match (wordRel_append (fun (_ : Unit) => R) (List.replicate a ()) (List.replicate b ())).mp
      (Eq.subst (motive := fun l => wordRel (fun (_ : Unit) => R) l x z) (replicate_add_right () a b)
        (Eq.subst (motive := fun r => r x z) (wordRel_replicate R (b + a)).symm steps)) with
  | ⟨y, first, second⟩ => ⟨y, Eq.subst (motive := fun r => r x y) (wordRel_replicate R a) first,
      Eq.subst (motive := fun r => r y z) (wordRel_replicate R b) second⟩

/-- `«迭之末步»`, as the composite's case. -/
theorem steps_last_case {R : «际» α} (n : Nat) {x z : α} : «迭» R (n + 1) x z ↔ ∃ y, «迭» R n x y ∧ R y z :=
  (Iff.of_eq (congrArg (fun r => r x z) (wordRel_replicate R (n + 1)))).symm.trans
    ((Iff.of_eq (congrArg (fun l => wordRel (fun (_ : Unit) => R) l x z) (replicate_succ_right () n))).trans
      ((wordRel_snoc (fun (_ : Unit) => R) (List.replicate n ()) ()).trans
        ⟨fun ⟨y, s, r⟩ => ⟨y, Eq.subst (motive := fun q => q x y) (wordRel_replicate R n) s, r⟩,
         fun ⟨y, s, r⟩ => ⟨y, Eq.subst (motive := fun q => q x y) (wordRel_replicate R n).symm s, r⟩⟩))

/-- `«迭之逆»`, as the composite's case. -/
theorem steps_converse_case {R : «际» α} (n : Nat) {x y : α} : «迭» («逆» R) n x y ↔ «迭» R n y x :=
  (Iff.of_eq (congrArg (fun r => r x y) (wordRel_replicate («逆» R) n))).symm.trans
    ((Iff.of_eq (congrArg (fun l => wordRel (fun (_ : Unit) => «逆» R) l x y) (reverse_replicate () n))).symm.trans
      ((wordRel_reverse (fun (_ : Unit) => R) (List.replicate n ())).trans
        (Iff.of_eq (congrArg (fun r => r y x) (wordRel_replicate R n)))))

/-- `«迭之定前»`, as the composite's case. -/
theorem steps_fixedBefore_case {R : «际» α} (merges : «定前» R) (n : Nat) {x y z : α}
    (first : «迭» R n x z) (second : «迭» R n y z) : x = y :=
  wordRel_fixedBefore (F := fun (_ : Unit) => R) (fun _ => merges) (List.replicate n ())
    (Eq.subst (motive := fun r => r x z) (wordRel_replicate R n).symm first)
    (Eq.subst (motive := fun r => r y z) (wordRel_replicate R n).symm second)

/-- `«同行之迭»`, as the composite's case. -/
theorem steps_alike_case {R E : «际» α} (alike : «同行» R E) (n : Nat) {x x' y y' : α}
    (e : E x x') (first : «迭» R n x y) (second : «迭» R n x' y') : E y y' :=
  wordRel_alike (F := fun (_ : Unit) => R) (fun _ => alike) (List.replicate n ()) e
    (Eq.subst (motive := fun r => r x y) (wordRel_replicate R n).symm first)
    (Eq.subst (motive := fun r => r x' y') (wordRel_replicate R n).symm second)

end Cases

/-! ## Transport along maps (grammar layer) -/

/-- Preserving steps along a map is the image lying within the other relation. -/
theorem preserves_iff_image {α : Type u} {κ : Type v} (q : α → κ) (R : «际» α) (R' : «际» κ) :
    (∀ s t, R s t → R' (q s) (q t)) ↔ «则» («像» q R) R' :=
  ⟨fun pres _ _ ⟨s, t, hs, r, ht⟩ => Eq.subst (motive := fun b => R' _ b) ht
      (Eq.subst (motive := fun a => R' a (q t)) hs (pres s t r)),
   fun incl s t r => incl _ _ ⟨s, t, rfl, r, rfl⟩⟩

/-- **Going on along some branch, pulled back along lifting**: where every step from an image lifts
to a step from the source, going on at the image gives it at the source. -/
theorem yan_pullback {α : Type u} {κ : Type v} {R : «际» α} {R' : «际» κ} (q : α → κ)
    (lifts : ∀ s r, R' (q s) r → ∃ t, R s t ∧ q t = r) (x : α) :
    «延» R' «一» (q x) → «延» R «一» x :=
  fun ⟨S', sx, goes⟩ => ⟨fun y => S' (q y), sx, fun z sz =>
    match goes (q z) sz with
    | ⟨w', sw, r', _⟩ => match lifts z w' r' with
      | ⟨t, r, same⟩ => ⟨t, Eq.subst (motive := S') same.symm sw, r, trivial⟩⟩

/-- **A process factors through a map exactly where, at each move, the image of its relation lies
within the other's.** -/
theorem factorsThrough_iff_image {S : Type u} {A : Type v} {K : Type w} {P : Process S A}
    {π : S → K} {Q : Process K A} :
    FactorsThrough P π Q ↔ ∀ a, «则» («像» π (moveRel P a)) (moveRel Q a) :=
  ⟨fun f a => (preserves_iff_image π (moveRel P a) (moveRel Q a)).mp fun s t r => f s a t r,
   fun incl s a u r => (preserves_iff_image π (moveRel P a) (moveRel Q a)).mpr (incl a) s u r⟩

/-! ## Runs -/

/-- **A run's configurations carry the line of steps into the steps**: the image of `Steps.next`
along them lies within the steps. -/
theorem run_image {S : Type u} {A : Type v} {P : Process S A} (r : Run P) :
    «则» («像» r.state Steps.next) (Steps P) :=
  (preserves_iff_image r.state Steps.next (Steps P)).mp fun m _ later =>
    Eq.subst (motive := fun k => Steps P (r.state m) (r.state k)) later.symm ⟨r.act m, r.step m⟩

/-- **With the move inside, a run is exactly a sequence along which the image of the line of steps
lies within the steps.** -/
theorem run_iff_image {S : Type u} {A : Type v} (P : Process S A) (g : Nat → S × A) :
    (∃ r : Run P, ∀ n, (r.state n, r.act n) = g n) ↔ «则» («像» g Steps.next) (Steps (withMove P)) :=
  ⟨fun ⟨r, same⟩ => (preserves_iff_image g Steps.next _).mp fun m _ later =>
      Eq.subst (motive := fun k => Steps (withMove P) (g m) (g k)) later.symm
        (Eq.subst (motive := fun x => Steps (withMove P) x (g (m + 1))) (same m)
          (Eq.subst (motive := fun y => Steps (withMove P) (r.state m, r.act m) y) (same (m + 1))
            ⟨(), r.step m⟩)),
   fun incl => ⟨⟨fun n => (g n).1, fun n => (g n).2, fun n =>
      match incl (g n) (g (n + 1)) ⟨n, n + 1, rfl, rfl, rfl⟩ with | ⟨_, h⟩ => h⟩, fun _ => rfl⟩⟩

/-! ## Going on along some branch -/

/-- **Going on along some branch of the steps is lying in a family that keeps moving.** -/
theorem yan_iff_keepsMoving {S : Type u} {A : Type v} {P : Process S A} {x : S} :
    «延» (Steps P) «一» x ↔ ∃ K : S → Prop, K x ∧ Onward.KeepsMoving P K :=
  ⟨fun ⟨K, kx, goes⟩ => ⟨K, kx, fun s ks => match goes s ks with
      | ⟨t, kt, ⟨a, step⟩, _⟩ => ⟨a, t, step, kt⟩⟩,
   fun ⟨K, kx, moving⟩ => ⟨K, kx, fun s ks => match moving s ks with
      | ⟨a, t, step, kt⟩ => ⟨t, kt, ⟨a, step⟩, trivial⟩⟩⟩

/-- **A run goes on along some branch** of the process's steps, from where it starts. -/
theorem run_yan {S : Type u} {A : Type v} {P : Process S A} (r : Run P) :
    «延» (Steps P) «一» (r.state 0) :=
  ⟨fun y => ∃ n, r.state n = y, ⟨0, rfl⟩,
   fun _ ⟨n, at_n⟩ => ⟨r.state (n + 1), ⟨n + 1, rfl⟩,
     Eq.subst (motive := fun z => Steps P z (r.state (n + 1))) at_n ⟨r.act n, r.step n⟩, trivial⟩⟩

/-- **On the grammar, for relations on a type of the first universe, going on along some branch
gives a line exactly under dependent choice.** From dependent choice to lines it is
`Onward.runs_iff_dependentChoice`, read through the steps of the one-move process of the edges;
the other direction is direct. -/
theorem yan_line_iff_dependentChoice :
    (∀ (α : Type) (R : «际» α) (x : α), «延» R «一» x → ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1))) ↔
      Onward.DependentChoice :=
  ⟨fun lines α R total x => lines α R x ⟨fun _ => True, trivial, fun z _ =>
      match total z with | ⟨w, r⟩ => ⟨w, trivial, r, trivial⟩⟩,
   fun dc α R x ⟨K, kx, goes⟩ =>
    match Onward.runs_iff_dependentChoice.mpr dc α Unit (edgeProcess R) K
        (fun s ks => match goes s ks with | ⟨t, kt, r, _⟩ => ⟨(), t, r, kt⟩) x kx with
    | ⟨r, start, _⟩ => ⟨r.state, start, r.step⟩⟩

/-- **Within finitely many configurations, going on along some branch gives a line, with nothing
chosen** (`Onward.KeepsMoving.run`, read through the steps of the one-move process of the edges). -/
theorem yan_line_of_list {α : Type u} {R : «际» α} {all : List α} (every : ∀ x, x ∈ all) {x : α}
    (goes : «延» R «一» x) : ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1)) :=
  match goes with
  | ⟨_, kx, on⟩ =>
    match Onward.KeepsMoving.run (P := edgeProcess R) every
        (fun s ks => match on s ks with | ⟨t, kt, r, _⟩ => ⟨(), t, r, kt⟩) kx with
    | ⟨r, start, _⟩ => ⟨r.state, start, r.step⟩

/-! ## The steps forget the moves -/

namespace Forgotten

/-- One configuration, two moves: the process stepping only by `true`, and the one stepping only
by `false`. -/
def byTrue : Process Unit Bool := ⟨fun _ a _ => a = true⟩
def byFalse : Process Unit Bool := ⟨fun _ a _ => a = false⟩

/-- **The two have the same steps, and only the first is enabled by `true`.** -/
theorem moves_forgotten :
    (∀ s t, Steps byTrue s t ↔ Steps byFalse s t) ∧ Enabled byTrue () true ∧ ¬ Enabled byFalse () true :=
  ⟨fun _ _ => ⟨fun _ => ⟨false, rfl⟩, fun _ => ⟨true, rfl⟩⟩, ⟨(), rfl⟩, fun ⟨_, h⟩ => Bool.noConfusion h⟩

end Forgotten

end WRPCheck

end Becoming
