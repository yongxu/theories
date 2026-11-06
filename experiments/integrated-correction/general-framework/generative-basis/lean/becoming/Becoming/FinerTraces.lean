import Becoming.Situations
import Becoming.WeightedTraces
import GenerativeCore

/-!
# Finer traces: the situations counted are the courses of one determined process

`Becoming.Situations` counts natural weights as situations: the law whose moves are situations
(`Situations.finerLaw`) is a process of the spine and is determined, and its finer courses of `n`
steps (`Situations.finer`) are listed by joining, from every configuration, each situation of each
open step. This module states what those lists are on the base: the traces of the finer law, and,
with the situation forgotten, the traces of the law of steps of positive weight.

* **The finer courses are the finer law's traces.** A list of situations is a finer course of `n`
  steps from `s` exactly where it has `n` steps, is a trace of the finer law from `s`, and takes
  only listed moves to listed configurations (`mem_finer_iff`). On two values with `p` and `q`
  situations, every list of situations is listed, so the finer courses of `n` steps are exactly
  the finer law's traces of `n` steps (`two_values_mem_iff`); `Becoming.Situations`'s counts of
  them (`Situations.situations_count`, `Situations.situations_typical`) are counts over this
  enumeration of the traces.
* **Forgetting the situation.** The law of the steps of positive weight (`supportLaw`) is the
  finer law with the situation forgotten: every trace of the finer law forgets to a trace of it
  (`trace_forget`), and every trace of it is a trace of the finer law forgotten (`trace_lift`).
* **Situations exist exactly where the law has a course.** With every move and configuration
  listed, the finer courses of `n` steps from `s` are not none exactly where the law of positive
  weight has a trace of `n` moves from `s` (`finer_exists_iff`, through `Situations.finer_count`
  and `Becoming.Weighted`'s `counting_transfer_iff`).

What is not derived: that each trace is listed once by `Situations.finer` (no theorem here excludes
repetition, so the counts are of the enumeration); which situation is actual. No ethical
predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

namespace FinerTraces

open Situations

universe u v u' v'

/-! ## Lists -/

section Lists

variable {α : Type u'} {β : Type v'}

theorem of_mem_joinMap {g : α → List β} {b : β} :
    ∀ {l : List α}, b ∈ joinMap g l → ∃ a, a ∈ l ∧ b ∈ g a
  | [], mem => nomatch mem
  | a :: _, mem => match ListTests.mem_append_iff.mp mem with
    | .inl inside => ⟨a, .head _, inside⟩
    | .inr rest => match of_mem_joinMap rest with
      | ⟨a', found, inner⟩ => ⟨a', .tail a found, inner⟩

end Lists

theorem lt_of_mem_upto : ∀ {n k : Nat}, k ∈ Undecided.upto n → k < n
  | 0, _, mem => nomatch mem
  | n + 1, _, mem => match ListTests.mem_cons_iff.mp mem with
    | .inl same => Eq.subst (motive := fun x => x < n + 1) same.symm (Nat.lt_succ_self n)
    | .inr rest => Nat.lt_trans (lt_of_mem_upto rest) (Nat.lt_succ_self n)

section Finer

variable {S : Type u} {A : Type v}

theorem of_mem_openSteps {moves : List A} {all : List S} {p : A × S}
    (mem : p ∈ openSteps moves all) : p.1 ∈ moves ∧ p.2 ∈ all :=
  match of_mem_joinMap mem with
  | ⟨_, move, inner⟩ => match ListTests.mem_map_iff.mp inner with
    | ⟨_, reached, image⟩ =>
      Eq.subst (motive := fun x : A × S => x.1 ∈ moves ∧ x.2 ∈ all) image ⟨move, reached⟩

/-- A situation of the open steps from `s` takes a listed move to a listed configuration, and is
one of the situations of its step. -/
theorem of_mem_finerSteps {weight : S → A → S → Nat} {moves : List A} {all : List S} {s : S}
    {x : A × S × Nat} (mem : x ∈ finerSteps weight moves all s) :
    (x.1 ∈ moves ∧ x.2.1 ∈ all) ∧ x.2.2 < weight s x.1 x.2.1 :=
  match of_mem_joinMap mem with
  | ⟨_, step, inner⟩ => match ListTests.mem_map_iff.mp inner with
    | ⟨_, below, image⟩ =>
      Eq.subst (motive := fun y : A × S × Nat =>
          (y.1 ∈ moves ∧ y.2.1 ∈ all) ∧ y.2.2 < weight s y.1 y.2.1) image
        ⟨of_mem_openSteps step, lt_of_mem_upto below⟩

theorem mem_finerSteps {weight : S → A → S → Nat} {moves : List A} {all : List S} {s : S}
    {x : A × S × Nat} (move : x.1 ∈ moves) (reached : x.2.1 ∈ all)
    (within : x.2.2 < weight s x.1 x.2.1) : x ∈ finerSteps weight moves all s :=
  mem_joinMap (fun p => (Undecided.upto (weight s p.1 p.2)).map fun k => (p.1, p.2, k))
    (ListTests.mem_map_of (f := fun k => (x.1, x.2.1, k)) (Undecided.mem_upto within)) (mem_openSteps move reached)

/-- **The finer courses are the finer law's traces.** A list of situations is a finer course of
`n` steps from `s` exactly where it has `n` steps, is a trace of the finer law from `s`, and takes
only listed moves to listed configurations. -/
theorem mem_finer_iff (weight : S → A → S → Nat) (moves : List A) (all : List S) :
    ∀ (n : Nat) (s : S) (h : List (A × S × Nat)), h ∈ finer weight moves all n s ↔
      h.length = n ∧ (∃ t, Trace (finerLaw weight) s h t) ∧
        ∀ x, x ∈ h → x.1 ∈ moves ∧ x.2.1 ∈ all
  | 0, s, [] => ⟨fun _ => ⟨rfl, ⟨s, .nil s⟩, fun _ mem => nomatch mem⟩, fun _ => .head _⟩
  | 0, _, _ :: _ =>
    ⟨fun mem => (match ListTests.mem_cons_iff.mp mem with
      | .inl same => nomatch same
      | .inr inside => nomatch inside),
     fun ⟨len, _, _⟩ => nomatch len⟩
  | _ + 1, _, [] =>
    ⟨fun mem => (match of_mem_joinMap mem with
      | ⟨_, _, inner⟩ => match ListTests.mem_map_iff.mp inner with
        | ⟨_, _, same⟩ => nomatch same),
     fun ⟨len, _, _⟩ => nomatch len⟩
  | n + 1, s, x :: h =>
    ⟨fun mem => (match of_mem_joinMap mem with
      | ⟨y, here, inner⟩ => match ListTests.mem_map_iff.mp inner with
        | ⟨h', rest, same⟩ =>
          match of_mem_finerSteps here, (mem_finer_iff weight moves all n y.2.1 h').mp rest with
          | ⟨listed, within⟩, ⟨len, ⟨t, path⟩, listed'⟩ =>
            Eq.subst (motive := fun l : List (A × S × Nat) => l.length = n + 1 ∧
                (∃ t, Trace (finerLaw weight) s l t) ∧ ∀ z, z ∈ l → z.1 ∈ moves ∧ z.2.1 ∈ all)
              same
              ⟨congrArg (· + 1) len, ⟨t, .cons ⟨rfl, within⟩ path⟩, fun z mem =>
                match ListTests.mem_cons_iff.mp mem with
                | .inl at_y =>
                  Eq.subst (motive := fun w : A × S × Nat => w.1 ∈ moves ∧ w.2.1 ∈ all)
                    at_y.symm listed
                | .inr later => listed' z later⟩),
     fun ⟨len, ⟨t, path⟩, listed⟩ =>
      match trace_cons_iff.mp path with
      | ⟨_, step, rest⟩ =>
        have inside : h ∈ finer weight moves all n x.2.1 :=
          (mem_finer_iff weight moves all n x.2.1 h).mpr
            ⟨Nat.succ.inj len,
             ⟨t, Eq.subst (motive := fun w => Trace (finerLaw weight) w h t) step.1 rest⟩,
             fun z mem => listed z (.tail x mem)⟩
        mem_joinMap (fun y => (finer weight moves all n y.2.1).map fun h => y :: h)
          (ListTests.mem_map_of (f := fun h => x :: h) inside)
          (mem_finerSteps (listed x (.head h)).1 (listed x (.head h)).2 step.2)⟩

/-- The law of the steps of positive weight. -/
def supportLaw (weight : S → A → S → Nat) : Process S A := ⟨fun s a t => 0 < weight s a t⟩

/-- **Every trace of the finer law forgets to a trace of the law of positive weight.** -/
theorem trace_forget (weight : S → A → S → Nat) :
    ∀ {s t : S} {h : List (A × S × Nat)}, Trace (finerLaw weight) s h t →
      Trace (supportLaw weight) s (h.map Prod.fst) t
  | _, _, [], path => match trace_nil_iff.mp path with
    | same => Eq.subst (motive := fun w => Trace (supportLaw weight) _ [] w) same (.nil _)
  | s, _, x :: _, path => match trace_cons_iff.mp path with
    | ⟨_, step, rest⟩ =>
      .cons (Eq.subst (motive := fun m => 0 < weight s x.1 m) step.1.symm
          (Nat.lt_of_le_of_lt (Nat.zero_le _) step.2))
        (trace_forget weight rest)

/-- **Every trace of the law of positive weight is a trace of the finer law with the situation
forgotten.** -/
theorem trace_lift (weight : S → A → S → Nat) :
    ∀ {s t : S} {as : List A}, Trace (supportLaw weight) s as t →
      ∃ h : List (A × S × Nat), h.map Prod.fst = as ∧ Trace (finerLaw weight) s h t
  | s, _, [], path => match trace_nil_iff.mp path with
    | same => ⟨[], rfl, Eq.subst (motive := fun w => Trace (finerLaw weight) s [] w) same (.nil s)⟩
  | _, _, a :: _, path => match trace_cons_iff.mp path with
    | ⟨m, step, rest⟩ => match trace_lift weight rest with
      | ⟨h, forgets, path'⟩ => ⟨(a, m, 0) :: h, congrArg (a :: ·) forgets, .cons ⟨rfl, step⟩ path'⟩

theorem nonzero_iff : ∀ k : Nat, nonzero k = true ↔ 0 < k
  | 0 => ⟨fun same => (nomatch same), fun lt => absurd lt (Nat.lt_irrefl 0)⟩
  | k + 1 => ⟨fun _ => Nat.succ_pos k, fun _ => rfl⟩

/-- **Situations exist exactly where the law has a course.** With every move and configuration
listed, the finer courses of `n` steps from `s` are not none exactly where the law of positive
weight has a trace of `n` moves from `s`. -/
theorem finer_exists_iff (weight : S → A → S → Nat) {moves : List A} {all : List S}
    (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all) (n : Nat) (s : S) :
    nonzero (finer weight moves all n s).length = true ↔
      ∃ as t, as.length = n ∧ Trace (supportLaw weight) s as t :=
  (Eq.to_iff (congrArg (fun k => nonzero k = true) (finer_count weight moves all n s))).trans
    ((counting_transfer_iff (supportLaw weight) weight (fun s a t => nonzero_iff (weight s a t))
        moves all every_move every (fun _ => 1) n s).trans
      ⟨fun ⟨as, t, len, path, _⟩ => ⟨as, t, len, path⟩,
       fun ⟨as, t, len, path⟩ => ⟨as, t, len, path, rfl⟩⟩)

end Finer

/-- **On two values, the finer courses of `n` steps are exactly the finer law's traces of `n`
steps.** -/
theorem two_values_mem_iff (p q n : Nat) (s : Bool) (h : List (Unit × Bool × Nat)) :
    h ∈ finer (Typicality.stepWeight p q) [()] [true, false] n s ↔
      h.length = n ∧ ∃ t, Trace (finerLaw (Typicality.stepWeight p q)) s h t :=
  (mem_finer_iff _ _ _ n s h).trans
    ⟨fun ⟨len, path, _⟩ => ⟨len, path⟩,
     fun ⟨len, path⟩ => ⟨len, path, fun x _ => ⟨.head _, ListTests.mem_bools x.2.1⟩⟩⟩

end FinerTraces

end Becoming
