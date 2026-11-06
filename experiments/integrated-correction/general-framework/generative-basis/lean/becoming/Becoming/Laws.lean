import Becoming.Frame

/-!
# Laws: the law-level notions of processes

The notions of a law that the layers share, stated once just after the frame, so that the
modules reading them need not import one another for them.

* **Determined laws.** A process is determined when a move has at most one successor from each
  configuration (`Determined`).
* **Laws of change and partial laws.** A law of change read as a process (`Assurance.ofMap`) and
  a partial law read as a process (`Assurance.ofPartial`) are determined
  (`Assurance.ofMap_determined`, `Assurance.ofPartial_determined`); a partial law is run along a
  course (`Assurance.runPartial`), and its traces are exactly the courses the run completes
  (`Assurance.trace_ofPartial_iff`).
* **Going alike.** Configurations whose descriptions a relation `E` relates go, by one move, to
  configurations whose descriptions it relates (`GoAlikeUnder`, the kernel schema); going alike
  under a projection is its case at equality (`GoAlike`, defined as `GoAlikeUnder P π Eq`).
* **On the grammar.** A process is determined exactly where each move has a fixed successor
  (`determined_iff_fixed`), and going alike under a description is the grammar's going alike
  (`«同行»` of `Becoming.GrammarLaws`) at each move, with the description pulled back along the map,
  with no hypothesis (`goAlikeUnder_iff_alike`); so the laws of going alike in the later modules
  are the grammar's lumping laws at the moves.

Every declaration moved here unchanged, with its name, in R31 (20 October 2026): `Determined` from
`Becoming.Joint`, the laws of change from `Becoming.Assurance`, `GoAlikeUnder` from
`Becoming.Likeness` and `GoAlike` from `Becoming.Mechanism`, whose body `GoAlikeUnder P π Eq`
unfolds to its former statement. `Reachable` (`Becoming.Recurrence`), `Invariant`
(`Becoming.Frame`) and `Feasible` (`GenerativeCore`) already lie at or just after the frame.
`DependsOnlyOn` is not a case of `GoAlikeUnder` (it asks for equal successors from configurations
alike under a projection, not successors alike) and stays in `Becoming.Mechanism`, where
`DependsOnlyOn.goAlike` connects the two. No premise,
ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w

variable {S : Type u} {A : Type v} {K : Type w}

/-! ## Determined laws -/

/-- The move determines the step: from a configuration, a move has at most one
successor. -/
def Determined (P : Process S A) : Prop :=
  ∀ s a t t', P.step s a t → P.step s a t' → t = t'

/-- **Under a determined process, two traces of one plan from one configuration end alike.** -/
theorem Trace.determined_end {P : Process S A} (determined : Determined P) :
    ∀ {s t r : S} {plan : List A}, Trace P s plan t → Trace P s plan r → t = r
  | _, _, _, [], .nil _, .nil _ => rfl
  | _, _, _, _ :: _, .cons step rest, .cons step' rest' =>
    match determined _ _ _ _ step step' with
    | rfl => Trace.determined_end determined rest rest'

/-! ## Laws of change and partial laws -/

namespace Assurance

/-- A law of change read as a process: the move `a` takes `s` to `f s a`. -/
def ofMap (f : S → A → S) : Process S A := ⟨fun s a t => t = f s a⟩

theorem ofMap_determined (f : S → A → S) : Determined (ofMap f) :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- A partial law read as a process: the move `a` takes `s` to `t` where `f s a = some t`. -/
def ofPartial (f : S → A → Option S) : Process S A := ⟨fun s a t => f s a = some t⟩

theorem ofPartial_determined (f : S → A → Option S) : Determined (ofPartial f) :=
  fun _ _ _ _ step step' => Option.some.inj (step.symm.trans step')

/-- Running a partial law along a course; `none` where a move is impossible. -/
def runPartial (f : S → A → Option S) : S → List A → Option S
  | s, [] => some s
  | s, a :: rest => (f s a).bind fun t => runPartial f t rest

/-- **The traces of a partial law are exactly the courses its run completes.** -/
theorem trace_ofPartial_iff (f : S → A → Option S) :
    ∀ {s t : S} {plan : List A}, Trace (ofPartial f) s plan t ↔ runPartial f s plan = some t
  | s, t, [] =>
    ⟨fun path => match path with | .nil _ => rfl,
     fun ran => match (Option.some.inj ran : s = t) with | rfl => .nil s⟩
  | s, t, a :: rest =>
    ⟨fun path => match path with
      | .cons (m := m) step tail =>
        show (f s a).bind (fun u => runPartial f u rest) = some t from
          (congrArg (fun o => o.bind fun u => runPartial f u rest) step).trans
            ((trace_ofPartial_iff f).mp tail),
     fun ran =>
      match moved : f s a with
      | none => by
          have impossible : (f s a).bind (fun u => runPartial f u rest) = some t := ran
          rw [moved] at impossible
          exact absurd (show (none : Option S) = some t from impossible) ListTests.none_ne_some
      | some m => by
          have onward : (f s a).bind (fun u => runPartial f u rest) = some t := ran
          rw [moved] at onward
          exact .cons moved ((trace_ofPartial_iff f).mpr onward)⟩

end Assurance

/-! ## Going alike under a description -/

/-- Configurations whose descriptions `E` relates go, by one move, to configurations whose
descriptions `E` relates: `GoAlike` with equality read as `E`. -/
def GoAlikeUnder (P : Process S A) (π : S → K) (E : K → K → Prop) : Prop :=
  ∀ s s' a u u', E (π s) (π s') → P.step s a u → P.step s' a u' → E (π u) (π u')

/-- Configurations alike under `π` go alike under `π`: wherever two configurations project
alike, the same move takes them to configurations that project alike. -/
def GoAlike (P : Process S A) (π : S → K) : Prop :=
  GoAlikeUnder P π Eq

/-! ## On the grammar -/

/-- **A process is determined exactly where each move has a fixed successor.** -/
theorem determined_iff_fixed {P : Process S A} :
    Determined P ↔ ∀ a, «定后» (fun s t => P.step s a t) :=
  ⟨fun determined a t t' ⟨s, step, step'⟩ => determined s a t t' step step',
   fun fixed s a t t' step step' => fixed a t t' ⟨s, step, step'⟩⟩

/-- **Going alike under a description is the grammar's going alike**, at each move, with the
description pulled back along the map, with no hypothesis. -/
theorem goAlikeUnder_iff_alike {P : Process S A} {π : S → K} {E : K → K → Prop} :
    GoAlikeUnder P π E ↔ ∀ a, «同行» (fun s t => P.step s a t) (fun s s' => E (π s) (π s')) :=
  ⟨fun alike a => «同行之逐点».mpr fun s s' e u u' step step' => alike s s' a u u' e step step',
   fun alike s s' a u u' e step step' => «同行之逐点».mp (alike a) s s' e u u' step step'⟩

end Becoming
