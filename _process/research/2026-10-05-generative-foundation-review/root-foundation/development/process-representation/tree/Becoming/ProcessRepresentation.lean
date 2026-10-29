import Becoming.EdgeClosure
import Becoming.GrammarTransport
import Becoming.Labelled
import Becoming.Onward
import Becoming.GrammarRegularity
import Becoming.GrammarCandidates

/-!
# Processes represented in the grammar both ways

A process `P : Process S A` is read in the grammar as its relations, one per move: `moveRel P a`
relates `s` to `t` where the move `a` takes `s` to `t` (`Becoming.GrammarRegularity`). This module
shows that the reading goes both ways, and where it stops.

* **Both ways, by definition.** A process is exactly its family of relations (`moveRel_mk`,
  `mk_moveRel`), and its steps are their union (`steps_iff_moveRel`). Every relation is the steps of
  the one-move process of its edges (`steps_edgeProcess`); a process with its moves forgotten has the
  same steps (`steps_unlabelled`); a deterministic law's steps are its step relation
  (`steps_lawProcess`); enabledness is the correlative «能» at a move's relation (`enabled_iff_neng`).
* **A law's truth, carried.** A property of relations that relations alike pointwise share holds of
  every process's steps exactly where it holds of every relation (`forall_steps_iff`); a property of
  families holds of every process's moves' relations exactly where it holds of every family
  (`forall_moveRel_iff`). This carries a law's truth, not its statement: a statement naming a process
  notion is in the grammar's terms only through a bridge for that notion.
* **The converse.** Every class is the class of a frame's claims, likeness to depth zero
  (`class_is_claims`). The model with the move inside (`withMove`, `Becoming.Labelled`) recovers the
  process on its fixed carrier (`step_iff_withMove`), and its image is exactly the relations leaving
  the next move open (`withMove_image_iff`), so a relation reading the next move is no process's model
  (`reading_next_move_not_withMove`).
* **Faithful up to correspondence with both classes.** A renaming of configurations and moves is a
  correspondence of the models carrying the steps, the class of the same move (`sameMove`) and that of
  the same configuration (`sameConfiguration`) (`renamed_withMove`). Conversely, from a configuration
  and a move, a correspondence carrying the three is such a renaming (`withMove_renamed`); with no move
  it need not be (`NoMoves.needs_a_point`). Neither class alone suffices: the twist keeps the class of
  the same move and the flip that of the same configuration, and each relates the models of two
  processes no renaming relates (`Twist.models_correspond`, `Twist.not_renamed`,
  `Flip.models_correspond`, `Flip.not_renamed`).
* **Forward.** A trace is passing through the moves' relations along its word (`trace_iff_li`,
  `feasible_iff_li`, on `«历»` of `Becoming.GrammarLaws`); a process factors through a map exactly
  where, at each move, the image of its relation lies within the other's (`factorsThrough_iff_image`,
  by `«保之像»`); a run's configurations carry the line of steps into the steps (`run_image`), and
  with the move inside a run is exactly such a sequence (`run_iff_image`); going on along some branch
  of the steps (`«延»`) is lying in a family that keeps moving (`yan_iff_keepsMoving`), and a run goes
  on from where it starts (`run_yan`).
* **Where it stops.** The steps forget the moves (`Forgotten.moves_forgotten`). On relations on a type
  of the first universe, going on along some branch gives a line exactly under dependent choice
  (`yan_line_iff_dependentChoice`, read from `Onward.runs_iff_dependentChoice`); within finitely many
  configurations it gives one with nothing chosen (`yan_line_of_list`).

Not shown here: that every functional total relation is a deterministic law's step (unique choice on
one carrier); a relation of three carriers, the factors and their product, as one construction, which
needs a pairing the grammar does not form; the statements of the binding theorems whose notions have
no bridge, notion by notion. Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v u' v'

/-! ## A process is its relations, one per move -/

section Model

variable {S : Type u} {A : Type v}

/-- **A process is exactly its relations, one per move**: the family read back is the process,
by definition. -/
theorem moveRel_mk (F : A → «际» S) : moveRel (⟨fun s a t => F a s t⟩ : Process S A) = F := rfl

/-- And the process read as its family and back is the process, by definition. -/
theorem mk_moveRel (P : Process S A) : (⟨fun s a t => moveRel P a s t⟩ : Process S A) = P := rfl

/-- The steps are the union of the moves' relations. -/
theorem steps_iff_moveRel (P : Process S A) (s t : S) : Steps P s t ↔ ∃ a, moveRel P a s t := Iff.rfl

/-- Every relation is the steps of the one-move process of its edges. -/
theorem steps_edgeProcess (R : «际» S) (s t : S) : Steps (edgeProcess R) s t ↔ R s t :=
  ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- The process with its moves forgotten has the same steps. -/
theorem steps_unlabelled (P : Process S A) (s t : S) : Steps (unlabelled P) s t ↔ Steps P s t :=
  ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- A deterministic law's steps are its step relation. -/
theorem steps_lawProcess (next : S → S) : «谓» (Steps (Law.process next)) (Law.step next) :=
  fun _ _ => ⟨fun ⟨_, h⟩ => h, fun h => ⟨(), h⟩⟩

/-- Enabledness is the correlative «能» at the move's relation, by definition. -/
theorem enabled_iff_neng (P : Process S A) (s : S) (a : A) : Enabled P s a ↔ «能» (moveRel P a) s :=
  Iff.rfl

end Model

/-! ## A law's truth, carried from every process to every relation -/

/-- **A property of a carrier and a relation that relations alike pointwise share holds of every
process's steps exactly where it holds of every relation.** It carries a law's truth; stating the
law in the grammar's terms is another matter. -/
theorem forall_steps_iff (T : (α : Type u) → «际» α → Prop)
    (keeps : ∀ α (R R' : «际» α), «谓» R R' → (T α R ↔ T α R')) :
    (∀ (S : Type u) (A : Type v) (P : Process S A), T S (Steps P)) ↔ ∀ (α : Type u) (R : «际» α), T α R :=
  ⟨fun all α R => (keeps α (Steps (⟨fun s _ t => R s t⟩ : Process α PUnit.{v + 1})) R
      fun _ _ => ⟨fun ⟨_, h⟩ => h, fun h => ⟨PUnit.unit, h⟩⟩).mp (all α PUnit (⟨fun s _ t => R s t⟩)),
   fun all _ _ _ => all _ _⟩

/-- **A property of a family of relations holds of every process's moves' relations exactly where
it holds of every family**, with no hypothesis: by definition (`moveRel_mk`). -/
theorem forall_moveRel_iff (T : (S : Type u) → (A : Type v) → (A → «际» S) → Prop) :
    (∀ S A (P : Process S A), T S A (moveRel P)) ↔ ∀ S A (F : A → «际» S), T S A F :=
  ⟨fun all S A F => all S A ⟨fun s a t => F a s t⟩, fun all _ _ _ => all _ _ _⟩

/-! ## Frames' claims -/

/-- **Every class is the class of a frame's claims**, likeness to depth zero: the claims are the
carrier, each realized where `E` relates. -/
theorem class_is_claims {α : Type u} {E : «际» α} (cls : «类» E) (R : «际» α) :
    «谓» (AlikeTo (⟨edgeProcess R, fun s c => E s c⟩ : Frame α Unit α) ⟨edgeProcess R, fun s c => E s c⟩ 0) E :=
  fun _ t => ⟨fun alike => (alike t).mpr (cls.refl t), fun e _ => ⟨fun ec => cls.trans (cls.symm e) ec,
    fun ec => cls.trans e ec⟩⟩

/-! ## The model with the move inside -/

section WithMove

variable {S : Type u} {A : Type v}

/-- The class of the same move, on configurations read with their moves. -/
def sameMove : «际» (S × A) := fun x y => x.2 = y.2

/-- The class of the same configuration, on configurations read with their moves. -/
def sameConfiguration : «际» (S × A) := fun x y => x.1 = y.1

/-- On the fixed carrier `S × A`, the model with the move inside recovers the process. -/
theorem step_iff_withMove (P : Process S A) (s : S) (a : A) (t : S) :
    P.step s a t ↔ Steps (withMove P) (s, a) (t, a) :=
  ⟨fun h => ⟨(), h⟩, fun ⟨_, h⟩ => h⟩

/-- **Its image is exactly the relations leaving the next move open**: the converse of
`withMove_open`. -/
theorem withMove_image_iff (R : «际» (S × A)) :
    (∃ P : Process S A, «谓» (Steps (withMove P)) R) ↔ ∀ x t b b', R x (t, b) ↔ R x (t, b') :=
  ⟨fun ⟨_, same⟩ x t b b' => (same x (t, b)).symm.trans (same x (t, b')),
   fun leaves => ⟨⟨fun s a t => R (s, a) (t, a)⟩, fun x y =>
     ⟨fun ⟨_, h⟩ => (leaves x y.1 x.2 y.2).mp h, fun h => ⟨(), (leaves x y.1 x.2 y.2).mpr h⟩⟩⟩⟩

end WithMove

/-- **A relation reading the next move is no process's model with the move inside.** -/
theorem reading_next_move_not_withMove :
    ¬ ∃ P : Process Unit Bool, «谓» (Steps (withMove P)) (fun _ y => y.2 = true) :=
  fun has => match (withMove_image_iff _).mp has ((), true) () true false with
    | same => Bool.noConfusion (same.mp rfl)

/-! ### Faithful up to correspondence carrying both classes -/

section Renaming

variable {S : Type u} {A : Type v} {S' : Type u'} {A' : Type v'}

/-- **A renaming of configurations and moves is a correspondence of the models with the move
inside carrying the steps and both classes**: their product. -/
theorem renamed_withMove {P : Process S A} {P' : Process S' A'} (φ : «一一对应» S S')
    (ψ : «一一对应» A A') (same : ∀ s a t, P.step s a t ↔ P'.step (φ.to s) (ψ.to a) (φ.to t)) :
    «谓» («像» (φ.prod ψ).to (Steps (withMove P))) (Steps (withMove P')) ∧
      «谓» («像» (φ.prod ψ).to sameMove) sameMove ∧
      «谓» («像» (φ.prod ψ).to sameConfiguration) sameConfiguration :=
  ⟨(«对应之像» _ _ _).mpr fun x y =>
      ⟨fun ⟨_, h⟩ => ⟨(), (same x.1 x.2 y.1).mp h⟩, fun ⟨_, h⟩ => ⟨(), (same x.1 x.2 y.1).mpr h⟩⟩,
   («对应之像» _ _ _).mpr fun _ _ => (ψ.to_eq_iff).symm,
   («对应之像» _ _ _).mpr fun _ _ => (φ.to_eq_iff).symm⟩

/-- The configurations renamed by a correspondence carrying the class of the same configuration:
each read with the move `a₀`, and back with the move the correspondence gives `(s₀, a₀)`. -/
def configurationRenaming (s₀ : S) (a₀ : A) (e : «一一对应» (S × A) (S' × A'))
    (configurations : «谓» («像» e.to sameConfiguration) sameConfiguration) : «一一对应» S S' :=
  ⟨fun s => (e.to (s, a₀)).1, fun s' => (e.back (s', (e.to (s₀, a₀)).2)).1,
   fun s => ((«对应之回» configurations ((e.to (s, a₀)).1, (e.to (s₀, a₀)).2) (e.to (s, a₀))).mp rfl).trans
     (congrArg Prod.fst (e.back_to (s, a₀))),
   fun s' => ((«对应之逐点» configurations ((e.back (s', (e.to (s₀, a₀)).2)).1, a₀)
       (e.back (s', (e.to (s₀, a₀)).2))).mp rfl).trans
     (congrArg Prod.fst (e.to_back (s', (e.to (s₀, a₀)).2)))⟩

/-- The moves renamed by a correspondence carrying the class of the same move: each read at the
configuration `s₀`, and back at the configuration the correspondence gives `(s₀, a₀)`. -/
def moveRenaming (s₀ : S) (a₀ : A) (e : «一一对应» (S × A) (S' × A'))
    (moves : «谓» («像» e.to sameMove) sameMove) : «一一对应» A A' :=
  ⟨fun a => (e.to (s₀, a)).2, fun a' => (e.back ((e.to (s₀, a₀)).1, a')).2,
   fun a => ((«对应之回» moves ((e.to (s₀, a₀)).1, (e.to (s₀, a)).2) (e.to (s₀, a))).mp rfl).trans
     (congrArg Prod.snd (e.back_to (s₀, a))),
   fun a' => ((«对应之逐点» moves (s₀, (e.back ((e.to (s₀, a₀)).1, a')).2)
       (e.back ((e.to (s₀, a₀)).1, a'))).mp rfl).trans
     (congrArg Prod.snd (e.to_back ((e.to (s₀, a₀)).1, a')))⟩

/-- **From a configuration and a move, a correspondence of the models with the move inside carrying
the steps and both classes is a renaming.** The class of the same configuration makes the image of a
configuration independent of the move it is read with, and the class of the same move the image of a
move independent of the configuration; so the correspondence is the product of the two renamings, and
it carries the steps exactly where they relate the processes. -/
theorem withMove_renamed {P : Process S A} {P' : Process S' A'} (s₀ : S) (a₀ : A)
    (e : «一一对应» (S × A) (S' × A')) (steps : «谓» («像» e.to (Steps (withMove P))) (Steps (withMove P')))
    (moves : «谓» («像» e.to sameMove) sameMove)
    (configurations : «谓» («像» e.to sameConfiguration) sameConfiguration) :
    ∃ (φ : «一一对应» S S') (ψ : «一一对应» A A'),
      (∀ x, e.to x = (φ.to x.1, ψ.to x.2)) ∧ ∀ s a t, P.step s a t ↔ P'.step (φ.to s) (ψ.to a) (φ.to t) :=
  have first : ∀ x : S × A, (e.to x).1 = (e.to (x.1, a₀)).1 := fun x =>
    («对应之逐点» configurations x (x.1, a₀)).mp rfl
  have second : ∀ x : S × A, (e.to x).2 = (e.to (s₀, x.2)).2 := fun x =>
    («对应之逐点» moves x (s₀, x.2)).mp rfl
  ⟨configurationRenaming s₀ a₀ e configurations, moveRenaming s₀ a₀ e moves,
   fun x => (congrArg (fun p => (p, (e.to x).2)) (first x)).trans
     (congrArg (fun q => ((e.to (x.1, a₀)).1, q)) (second x)),
   fun s a t =>
    have hs : (e.to (s, a)).1 = (e.to (s, a₀)).1 := first (s, a)
    have ha : (e.to (s, a)).2 = (e.to (s₀, a)).2 := second (s, a)
    have ht : (e.to (t, a)).1 = (e.to (t, a₀)).1 := first (t, a)
    (step_iff_withMove P s a t).trans ((«对应之逐点» steps (s, a) (t, a)).trans
      ⟨fun ⟨_, h⟩ =>
        have h' : P'.step (e.to (s, a)).1 (e.to (s, a)).2 (e.to (t, a)).1 := h
        Eq.subst (motive := fun z : S' => P'.step (e.to (s, a₀)).1 (e.to (s₀, a)).2 z) ht
          (Eq.subst (motive := fun b : A' => P'.step (e.to (s, a₀)).1 b (e.to (t, a)).1) ha
            (Eq.subst (motive := fun y : S' => P'.step y (e.to (s, a)).2 (e.to (t, a)).1) hs h')),
       fun h =>
        have h' : P'.step (e.to (s, a)).1 (e.to (s, a)).2 (e.to (t, a)).1 :=
          Eq.subst (motive := fun y : S' => P'.step y (e.to (s, a)).2 (e.to (t, a)).1) hs.symm
            (Eq.subst (motive := fun b : A' => P'.step (e.to (s, a₀)).1 b (e.to (t, a)).1) ha.symm
              (Eq.subst (motive := fun z : S' => P'.step (e.to (s, a₀)).1 (e.to (s₀, a)).2 z) ht.symm h))
        ⟨(), h'⟩⟩)⟩

end Renaming

/-! ### With no move, the point is needed -/

namespace NoMoves

def P : Process Unit Empty := ⟨fun _ a _ => nomatch a⟩
def P' : Process Bool Empty := ⟨fun _ a _ => nomatch a⟩

def e : «一一对应» (Unit × Empty) (Bool × Empty) :=
  ⟨fun x => (nomatch x.2), fun y => (nomatch y.2), fun x => (nomatch x.2), fun y => (nomatch y.2)⟩

/-- **With no move, the point is needed.** The models with the move inside are empty, so a
correspondence of them carries the steps and both classes, and yet one configuration is not two:
no correspondence of the configurations exists. -/
theorem needs_a_point :
    («谓» («像» e.to (Steps (withMove P))) (Steps (withMove P')) ∧
      «谓» («像» e.to sameMove) sameMove ∧ «谓» («像» e.to sameConfiguration) sameConfiguration) ∧
    («一一对应» Unit Bool → False) :=
  ⟨⟨fun k _ => (nomatch k.2), fun k _ => (nomatch k.2), fun k _ => (nomatch k.2)⟩,
   fun φ => Bool.noConfusion ((φ.to_back true).symm.trans (φ.to_back false))⟩

end NoMoves

/-! ### Neither class alone: the twist keeps the class of the same move -/

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

/-- **No renaming of configurations and moves relates the two processes**: in `P₁` one
configuration steps to itself by both moves, in `P₂` none does. -/
theorem not_renamed :
    ¬ ∃ (φ : «一一对应» Bool Bool) (ψ : «一一对应» Bool Bool),
      ∀ s a t, P₁.step s a t ↔ P₂.step (φ.to s) (ψ.to a) (φ.to t) :=
  fun ⟨φ, ψ, same⟩ =>
    have h1 : P₂.step (φ.to true) (ψ.to true) (φ.to true) := (same true true true).mp rfl
    have h2 : P₂.step (φ.to true) (ψ.to false) (φ.to true) := (same true false true).mp rfl
    have apart : ψ.to true ≠ ψ.to false := fun eq => Bool.noConfusion ((ψ.to_eq_iff).mp eq)
    P₂_key (φ.to true) (ψ.to true) (ψ.to false) h1 h2 apart

end Twist

/-! ### Neither class alone: the flip keeps the class of the same configuration -/

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

/-! ## Forward: traces, factoring and runs -/

section Forward

variable {S : Type u} {A : Type v}

/-- **A trace is passing through the moves' relations along its word.** -/
theorem trace_iff_li {P : Process S A} : ∀ {as : List A} {s t : S}, Trace P s as t ↔ «历» (moveRel P) as s t
  | [], _, _ => trace_nil_iff
  | _ :: _, _, _ => trace_cons_iff.trans
      ⟨fun ⟨m, h, rest⟩ => ⟨m, h, trace_iff_li.mp rest⟩, fun ⟨m, h, rest⟩ => ⟨m, h, trace_iff_li.mpr rest⟩⟩

/-- A word is feasible from `s` exactly where passing through its relations leads somewhere. -/
theorem feasible_iff_li {P : Process S A} {s : S} {as : List A} :
    Feasible P s as ↔ ∃ t, «历» (moveRel P) as s t :=
  ⟨fun ⟨t, h⟩ => ⟨t, trace_iff_li.mp h⟩, fun ⟨t, h⟩ => ⟨t, trace_iff_li.mpr h⟩⟩

/-- **A process factors through a map exactly where, at each move, the image of its relation lies
within the other's.** -/
theorem factorsThrough_iff_image {K : Type u'} {P : Process S A} {π : S → K} {Q : Process K A} :
    FactorsThrough P π Q ↔ ∀ a, «则» («像» π (moveRel P a)) (moveRel Q a) :=
  ⟨fun f a => («保之像» π (moveRel P a) (moveRel Q a)).mpr fun s t r => f s a t r,
   fun within s a u r => («保之像» π (moveRel P a) (moveRel Q a)).mp (within a) s u r⟩

/-- **A run's configurations carry the line of steps into the steps**: the image of `Steps.next`
along them lies within the steps. -/
theorem run_image {P : Process S A} (r : Run P) : «则» («像» r.state Steps.next) (Steps P) :=
  («保之像» r.state Steps.next (Steps P)).mpr fun m _ later =>
    Eq.subst (motive := fun k => Steps P (r.state m) (r.state k)) later.symm ⟨r.act m, r.step m⟩

/-- **With the move inside, a run is exactly a sequence along which the image of the line of steps
lies within the steps.** -/
theorem run_iff_image (P : Process S A) (g : Nat → S × A) :
    (∃ r : Run P, ∀ n, (r.state n, r.act n) = g n) ↔ «则» («像» g Steps.next) (Steps (withMove P)) :=
  ⟨fun ⟨r, same⟩ => («保之像» g Steps.next _).mpr fun m _ later =>
      Eq.subst (motive := fun k => Steps (withMove P) (g m) (g k)) later.symm
        (Eq.subst (motive := fun x => Steps (withMove P) x (g (m + 1))) (same m)
          (Eq.subst (motive := fun y => Steps (withMove P) (r.state m, r.act m) y) (same (m + 1))
            ⟨(), r.step m⟩)),
   fun within => ⟨⟨fun n => (g n).1, fun n => (g n).2, fun n =>
      match within (g n) (g (n + 1)) ⟨n, n + 1, rfl, rfl, rfl⟩ with | ⟨_, h⟩ => h⟩, fun _ => rfl⟩⟩

end Forward

/-! ## Going on along some branch -/

section GoingOn

variable {S : Type u} {A : Type v}

/-- **Going on along some branch of the steps is lying in a family that keeps moving.** -/
theorem yan_iff_keepsMoving {P : Process S A} {x : S} :
    «延» (Steps P) «一» x ↔ ∃ K : S → Prop, K x ∧ Onward.KeepsMoving P K :=
  ⟨fun ⟨K, kx, goes⟩ => ⟨K, kx, fun s ks => match goes s ks with
      | ⟨t, kt, ⟨a, step⟩, _⟩ => ⟨a, t, step, kt⟩⟩,
   fun ⟨K, kx, moving⟩ => ⟨K, kx, fun s ks => match moving s ks with
      | ⟨a, t, step, kt⟩ => ⟨t, kt, ⟨a, step⟩, trivial⟩⟩⟩

/-- **A run goes on along some branch** of the process's steps, from where it starts. -/
theorem run_yan {P : Process S A} (r : Run P) : «延» (Steps P) «一» (r.state 0) :=
  ⟨fun y => ∃ n, r.state n = y, ⟨0, rfl⟩,
   fun _ ⟨n, at_n⟩ => ⟨r.state (n + 1), ⟨n + 1, rfl⟩,
     Eq.subst (motive := fun z => Steps P z (r.state (n + 1))) at_n ⟨r.act n, r.step n⟩, trivial⟩⟩

end GoingOn

/-- **On relations on a type of the first universe, going on along some branch gives a line exactly
under dependent choice.** From dependent choice to lines it is `Onward.runs_iff_dependentChoice`,
read through the steps of the one-move process of the edges; the other direction is direct. -/
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

/-- One configuration and two moves: the process stepping only by `true`, and the one stepping
only by `false`. -/
def byTrue : Process Unit Bool := ⟨fun _ a _ => a = true⟩
def byFalse : Process Unit Bool := ⟨fun _ a _ => a = false⟩

/-- **The two have the same steps, and only the first is enabled by `true`.** -/
theorem moves_forgotten :
    (∀ s t, Steps byTrue s t ↔ Steps byFalse s t) ∧ Enabled byTrue () true ∧ ¬ Enabled byFalse () true :=
  ⟨fun _ _ => ⟨fun _ => ⟨false, rfl⟩, fun _ => ⟨true, rfl⟩⟩, ⟨(), rfl⟩, fun ⟨_, h⟩ => Bool.noConfusion h⟩

end Forgotten

end Becoming
