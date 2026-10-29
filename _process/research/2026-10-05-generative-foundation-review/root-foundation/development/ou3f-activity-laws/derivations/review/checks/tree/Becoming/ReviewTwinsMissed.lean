import Becoming.ContinuedClasses
import Becoming.PatternPassing

/-! Review check (OU3f twins, item 5), not part of the package: three statements of the two
modules whose direct inductions a grammar law replaces the way the change replaces the twins'.
Each check states the original's statement exactly (the `example`s compare the types). -/

namespace Becoming

namespace Web

variable {F C : Type}

/-- The statement of `ByPassing.ends_within`, through `ByPassing.line_back` and
`«两端分则中有标»` (with `«线内同类»`), as `passes_within` now is: no `trace`. -/
theorem ByPassing.ends_within_by_line_check {V : Web F C} {passes : Nat → F → F → Prop}
    (by_passing : V.ByPassing passes) {d T : Nat}
    (brief : ∀ a, V.Brief d a) (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {t : Nat}
    (later : T + d ≤ t) : ¬ V.Present t :=
  fun ⟨a, active⟩ => match le_dest later with
  | ⟨m, same⟩ =>
    have carried : V.active (T + m + d) a :=
      Eq.subst (motive := fun s => V.active s a) (same.trans (Nat.add_right_comm T d m)) active
    match d, brief, carried with
    | 0, brief, carried => brief a (T + m) carried carried
    | k + 1, brief, carried =>
      match by_passing.line_back carried with
      | ⟨b, start, line⟩ =>
        have apart : ¬ V.carrierClass (T + m, b) (T + m + (k + 1), a) := fun ⟨_, one⟩ =>
          brief a (T + m) (Eq.subst (motive := fun f => V.active (T + m) f) one start) carried
        have split : ∀ x y, «续» (continuationStep (passingContinuation passes)) V.activityClass
            x y → V.carrierClass x y ∨ passes x.1 x.2 y.2 := fun _ _ ⟨⟨_, kind⟩, alike⟩ =>
          match kind with
          | .inl one => .inl ⟨alike, one⟩
          | .inr given => .inr given
        match «两端分则中有标» (carrierClass_class V) split line apart with
        | ⟨u, v, ⟨⟨next, _⟩, alike⟩, given, from_, _⟩ =>
          have reached : V.activityClass (T + m, b) u := match from_ with
            | .inl one => Eq.subst (motive := fun w => V.activityClass (T + m, b) w) one Iff.rfl
            | .inr line' => «线内同类» (activityClass_class V) line'
          have carrying : V.active u.1 u.2 := reached.mp start
          have onward : T + m ≤ u.1 := match from_ with
            | .inl one => Nat.le_of_eq (congrArg Prod.fst one)
            | .inr line' => Nat.le_of_lt (line_advances line')
          stopped u.1 (Nat.le_trans (Nat.le_add_right T m) onward)
            ⟨u.2, v.2, carrying, given,
             Eq.subst (motive := fun s => V.active s v.2) next (alike.mp carrying)⟩

example : type_of% @Becoming.Web.ByPassing.ends_within :=
  @ByPassing.ends_within_by_line_check

/-- The statement of `Linked.mono`, through `linked_iff_line` and `«及之单调»` (no activity
read: out of OU3f's scope). -/
theorem Linked.mono_by_reach_check {R S : Nat → F → F → Prop}
    (within : ∀ t g f, R t g f → S t g f) :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F}, Linked R t g u h → Linked S t g u h :=
  fun linked => match linked_iff_line.mp linked with
  | .inl same => linked_iff_line.mpr (.inl same)
  | .inr line => linked_iff_line.mpr (.inr
      («及之单调» (R := «续» (continuationStep R) «一») (S := «续» (continuationStep S) «一»)
        (fun _ _ k => ⟨⟨k.1.1, within _ _ _ k.1.2⟩, k.2⟩) _ _ line))

example : type_of% @Becoming.Web.Linked.mono := @Linked.mono_by_reach_check

/-- The statement of `Continuing.itself_same`, through `continuing_iff_line`, `«及之单调»` and
`«线内同类»` under the class of one formation. -/
theorem Continuing.itself_same_by_line_check {W : Web F C} :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F}, W.Continuing itself t g u h → h = g :=
  fun continuing => match continuing_iff_line.mp continuing with
  | .inl same => (congrArg Prod.snd same).symm
  | .inr ⟨_, line⟩ =>
    have one : «类» (fun x y : Nat × F => x.2 = y.2) :=
      ⟨fun _ => rfl, fun e => e.symm, fun e e' => e.trans e'⟩
    («线内同类» one
      («及之单调» (R := «续» (continuationStep (itself (F := F))) W.activityClass)
        (S := «续» (continuationStep (itself (F := F))) (fun x y : Nat × F => x.2 = y.2))
        (fun _ _ k => ⟨k.1, k.1.2⟩) _ _ line)).symm

example : type_of% @Becoming.Web.Continuing.itself_same :=
  @Continuing.itself_same_by_line_check

end Web

end Becoming
