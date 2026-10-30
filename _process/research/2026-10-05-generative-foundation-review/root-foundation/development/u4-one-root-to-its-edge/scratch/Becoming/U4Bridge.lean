import Becoming.U4Repairing

/-!
# Scratch for U4, lever 1: the census on continuation (not a module of the package)

The census of `U4Scratch` is stated on a continuation decided by a test `k` over listed units. Here
it is stated on the grammar's continuation `«续» R E` itself:

* the census pairing under `«续» R E` or sameness, where the continuation fixes successors and
  predecessors (`census_on_continuation`);
* the units the census lists as arising are exactly the units after the step that begin (`«生»`), and
  those it lists as ceasing are exactly the units before that end (`«亡»`), where the step is closed:
  every predecessor of a unit after stands before, and every successor of a unit before stands after
  (`arising_iff_begins`, `ceasing_iff_ends`);
* closure is needed: a unit whose predecessor is not listed is counted as arising and does not begin
  (`unlisted_predecessor`).
-/

namespace Becoming
namespace U4Scratch

variable {U : Type}

theorem mem_keep {p : U → Bool} {x : U} : ∀ {l : List U}, x ∈ keep p l ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun h => (nomatch h), fun h => (nomatch h.1)⟩
  | y :: l => by
    show x ∈ cond (p y) (y :: keep p l) (keep p l) ↔ _
    cases hy : p y with
    | true =>
      show x ∈ y :: keep p l ↔ _
      constructor
      · intro m
        cases m with
        | head => exact ⟨.head _, hy⟩
        | tail _ m' => exact ⟨.tail _ (mem_keep.mp m').1, (mem_keep.mp m').2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact .head _
        | tail _ m' => exact .tail _ (mem_keep.mpr ⟨m', px⟩)
    | false =>
      show x ∈ keep p l ↔ _
      constructor
      · intro m
        exact ⟨.tail _ (mem_keep.mp m).1, (mem_keep.mp m).2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact nomatch hy.symm.trans px
        | tail _ m' => exact mem_keep.mpr ⟨m', px⟩

theorem not_eq_true {b : Bool} : (!b) = true ↔ b = false := by
  cases b
  · exact ⟨fun _ => rfl, fun _ => rfl⟩
  · exact ⟨fun h => (nomatch h), fun h => (nomatch h)⟩

variable {R E : «际» U} {k : U → U → Bool}

/-- **The census on continuation.** Units listed once before and after a step, under a continuation
that fixes successors and predecessors: the units before with those arising are paired one to one
with the units after with those ceasing, each pair a continuation or the same unit. -/
theorem census_on_continuation (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List U) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    «对» (fun x y => «续» R E x y ∨ x = y) (before ++ arising k before after)
      (after ++ ceasing k before after) :=
  «对之单调» (fun x y r => match r with
      | .inl c => .inl ((dec x y).mpr c)
      | .inr e => .inr e)
    (census_pairs k before after dB dA
      (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' ((dec g f).mpr r) ((dec g f').mpr r'))
      (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f ((dec g f).mpr r) ((dec g' f).mpr r')))

/-- **Arising is beginning, on a closed step.** Where every predecessor of a unit after the step
stands before it, the units the census lists as arising are exactly the units after that begin. -/
theorem arising_iff_begins (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List U}
    (closedBefore : ∀ x f, f ∈ after → «续» R E x f → x ∈ before) {f : U} :
    f ∈ arising k before after ↔ f ∈ after ∧ «生» R E f := by
  constructor
  · intro m
    have h := mem_keep.mp m
    refine ⟨h.1, fun ⟨x, c⟩ => ?_⟩
    have off := not_eq_true.mp h.2
    have on : before.any (fun g => k g f) = true :=
      any_true_of_mem (p := fun g => k g f) (closedBefore x f h.1 c) ((dec x f).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mf, begins⟩
    refine mem_keep.mpr ⟨mf, not_eq_true.mpr (any_false_of (p := fun g => k g f) before fun g _ => ?_)⟩
    cases h : k g f with
    | false => exact h
    | true => exact absurd ⟨g, (dec g f).mpr h⟩ begins

/-- **Ceasing is ending, on a closed step.** Where every successor of a unit before the step stands
after it, the units the census lists as ceasing are exactly the units before that end. -/
theorem ceasing_iff_ends (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List U}
    (closedAfter : ∀ g y, g ∈ before → «续» R E g y → y ∈ after) {g : U} :
    g ∈ ceasing k before after ↔ g ∈ before ∧ «亡» R E g := by
  constructor
  · intro m
    have h := mem_keep.mp m
    refine ⟨h.1, fun ⟨y, c⟩ => ?_⟩
    have off := not_eq_true.mp h.2
    have on : after.any (k g) = true :=
      any_true_of_mem (p := k g) (closedAfter g y h.1 c) ((dec g y).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mg, ends⟩
    refine mem_keep.mpr ⟨mg, not_eq_true.mpr (any_false_of (p := k g) after fun f _ => ?_)⟩
    cases h : k g f with
    | false => rfl
    | true => exact absurd ⟨f, (dec g f).mpr h⟩ ends

/-- One continuation, from `0` to `1`. -/
def fromZero : «际» Nat := fun x y => x = 0 ∧ y = 1

/-- **Closure is needed.** With `1` continuing `0` and only `1` listed, the census counts `1` as
arising, and `1` does not begin. -/
theorem unlisted_predecessor :
    arising (fun g f => Nat.beq g 0 && Nat.beq f 1) [] [1] = [1] ∧ ¬ «生» fromZero «一» 1 :=
  ⟨rfl, fun begins => begins ⟨0, ⟨rfl, rfl⟩, trivial⟩⟩

end U4Scratch
end Becoming
