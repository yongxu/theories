import Becoming.Identity

/-! Reviewer's check, not for landing: variants of OU3f's lineage bridge, compiled against the
tree's `Becoming.Identity`, each with an `example` confirming the statement it is meant to have. -/

namespace Becoming
namespace Web
namespace LineageReview

variable {F C : Type} {W : Web F C} {R : Nat → F → F → Prop}

/-! ### 1. The bridge's index conjunct from `steps_advance` (rule 9) -/

/-- The bridge, its forward index taken from `steps_advance`, and the step index of the middle
occurrence too; the induction carries the lineage only. -/
theorem steps_iff_lineage_v1 {N M : Nat} (from_ : N ≤ M) {g : F} : ∀ (k : Nat) {y : Nat × F},
    «迭» («续» (continuationStep R) (W.activityFrom N)) k (M, g) y ↔
      y.1 = M + k ∧ W.Lineage R M g k y.2
  | 0, _ => ⟨fun same => ⟨(congrArg Prod.fst same).symm, (congrArg Prod.snd same).symm⟩,
      fun ⟨at_, same⟩ => occurrence_eq at_.symm same.symm⟩
  | k + 1, y => ⟨fun steps => ⟨steps_advance (k + 1) steps, match («迭之末步» k).mp steps with
      | ⟨x, first, ⟨next, cont⟩, alike, _, active₀⟩ =>
        have at_ : x.1 = M + k := steps_advance k first
        ⟨x.2, ((steps_iff_lineage_v1 from_ k).mp first).2,
          Eq.subst (motive := fun s => W.active s x.2) at_ active₀,
          Eq.subst (motive := fun s => R s x.2 y.2) at_ cont,
          Eq.subst (motive := fun s => W.active s y.2) (next.trans (congrArg (· + 1) at_))
            (alike.mp active₀)⟩⟩,
    fun ⟨at_, h₀, lineage, active₀, cont, active⟩ =>
      («迭之末步» k).mpr ⟨(M + k, h₀), (steps_iff_lineage_v1 from_ k).mpr ⟨rfl, lineage⟩, ⟨at_, cont⟩,
        ⟨fun _ => Eq.subst (motive := fun s => W.active s y.2) at_.symm active, fun _ => active₀⟩,
        Nat.le_trans from_ (Nat.le_add_right M k), active₀⟩⟩

/-! ### 2. The forward reading needs no bound -/

/-- Steps within activity from any `N` read as a lineage: no `N ≤ M` is used. -/
theorem lineage_of_steps {N M : Nat} {g : F} : ∀ (k : Nat) {y : Nat × F},
    «迭» («续» (continuationStep R) (W.activityFrom N)) k (M, g) y → W.Lineage R M g k y.2
  | 0, _, same => (congrArg Prod.snd same).symm
  | k + 1, y, steps => match («迭之末步» k).mp steps with
    | ⟨x, first, ⟨next, cont⟩, alike, _, active₀⟩ =>
      have at_ : x.1 = M + k := steps_advance k first
      ⟨x.2, lineage_of_steps k first,
        Eq.subst (motive := fun s => W.active s x.2) at_ active₀,
        Eq.subst (motive := fun s => R s x.2 y.2) at_ cont,
        Eq.subst (motive := fun s => W.active s y.2) (next.trans (congrArg (· + 1) at_))
          (alike.mp active₀)⟩

/-- `split` with the forward reading free of the bound: the second part needs no inequality. -/
theorem split_v2 {M : Nat} {g : F} {j : Nat} :
    ∀ i {h}, W.Lineage R M g (j + i) h → ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h
  | i, h, lineage =>
    match «迭之分» j ((steps_iff_lineage (Nat.le_refl M) (i + j) (y := (M + (i + j), h))).mpr
        ⟨rfl, Eq.subst (motive := fun n => W.Lineage R M g n h) (Nat.add_comm j i) lineage⟩) with
    | ⟨y, first, second⟩ => match (steps_iff_lineage (Nat.le_refl M) j).mp first with
      | ⟨at_, before⟩ => ⟨y.2, before, Eq.subst (motive := fun s => W.Lineage R s y.2 i h) at_
          (lineage_of_steps (N := M) i second)⟩

example {M : Nat} {g : F} {j : Nat} (i : Nat) {h : F} (l : W.Lineage R M g (j + i) h) :
    ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h := split_v2 i l

/-! ### 3. Without the endpoint's step in the bridge: `steps_advance` reads the middle point -/

/-- The bridge with the endpoint fixed (the first review's form, restriction in class position). -/
theorem lineage_iff_steps_at {M : Nat} {g : F} (k : Nat) {h : F} :
    W.Lineage R M g k h ↔ «迭» («续» (continuationStep R) (W.activityFrom M)) k (M, g) (M + k, h) :=
  ⟨fun l => (steps_iff_lineage (Nat.le_refl M) k).mpr ⟨rfl, l⟩,
   fun s => ((steps_iff_lineage (Nat.le_refl M) k).mp s).2⟩

/-- `split` from the endpoint-fixed bridge: `steps_advance` gives the middle point's step, and a
rewrite reads it back. So fixing the endpoint's step saves rewrites; it is not needed. -/
theorem split_v3 {M : Nat} {g : F} {j : Nat} :
    ∀ i {h}, W.Lineage R M g (j + i) h → ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h
  | i, h, lineage =>
    match «迭之分» j ((lineage_iff_steps_at (i + j)).mp
        (Eq.subst (motive := fun n => W.Lineage R M g n h) (Nat.add_comm j i) lineage)) with
    | ⟨y, first, second⟩ =>
      have at_ : y.1 = M + j := steps_advance j first
      have same : y = (M + j, y.2) := occurrence_eq at_ rfl
      ⟨y.2, (lineage_iff_steps_at j).mpr (Eq.subst (motive := fun z => «迭» _ j (M, g) z) same first),
        lineage_of_steps (N := M) i (Eq.subst (motive := fun z => «迭» _ i z (M + (i + j), h)) same second)⟩

/-! ### 4. `Lineage.cons` from the bridge, with no induction -/

theorem cons_v4 {M : Nat} {g f : F} (before : W.active M g) (r : R M g f)
    (after : W.active (M + 1) f) (k : Nat) {h : F} (lineage : W.Lineage R (M + 1) f k h) :
    W.Lineage R M g (k + 1) h :=
  lineage_of_steps (N := M) (k + 1) (y := (M + 1 + k, h))
    ⟨(M + 1, f), ⟨⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩, Nat.le_refl M, before⟩,
      (steps_iff_lineage (Nat.le_succ M) k).mpr ⟨rfl, lineage⟩⟩

example {M : Nat} {g f : F} (before : W.active M g) (r : R M g f) (after : W.active (M + 1) f)
    (k : Nat) {h : F} (l : W.Lineage R (M + 1) f k h) : W.Lineage R M g (k + 1) h :=
  Lineage.cons before r after k l

/-! ### 5. `Lineage.line` from the bridge and `«迭则及»`, with no induction -/

theorem line_v5 {M : Nat} {g : F} (k : Nat) {h : F} (lineage : W.Lineage R M g (k + 1) h) :
    W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h) :=
  have steps := (steps_iff_lineage (Nat.le_refl M) (k + 1) (y := (M + (k + 1), h))).mpr ⟨rfl, lineage⟩
  ⟨match steps with | ⟨_, ⟨_, _, _, active⟩, _⟩ => active,
   «及之单调» (fun _ _ ⟨step, alike, _⟩ => ⟨step, alike⟩) _ _ («迭则及» k steps)⟩

example {M : Nat} {g : F} (k : Nat) {h : F} (l : W.Lineage R M g (k + 1) h) :
    W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h) :=
  Lineage.line k l

/-! ### 6. `line_lineage` from the bridge, `«及即迭»` and closure, with no induction of its own -/

/-- A line under activity from an active occurrence stays within activity from its start (a
closed region, `«闭之及»`), so it is some positive number of steps there (`«及即迭»`), which the
bridge reads as a lineage. -/
theorem line_lineage_v6 {x y : Nat × F}
    (line : «及» («续» (continuationStep R) W.activityClass) x y) (start : W.active x.1 x.2) :
    ∃ k, y.1 = x.1 + (k + 1) ∧ W.Lineage R x.1 x.2 (k + 1) y.2 :=
  have kept : W.active y.1 y.2 ∧ x.1 ≤ y.1 ∧ «所闭» («续» (continuationStep R) (W.activityFrom x.1)) x y :=
    «闭之及» (P := fun z => W.active z.1 z.2 ∧ x.1 ≤ z.1 ∧
        «所闭» («续» (continuationStep R) (W.activityFrom x.1)) x z)
      (fun a _ ⟨active, from_, within⟩ ⟨step, alike⟩ =>
        ⟨alike.mp active,
         Nat.le_trans from_ (Eq.subst (motive := (a.1 ≤ ·)) step.1.symm (Nat.le_succ a.1)),
         «所闭之传递» within («缘在所闭» ⟨step, alike, from_, active⟩)⟩)
      ⟨start, Nat.le_refl x.1, «所闭之自反» _ x⟩ line
  match «所闭当且仅当同一或及».mp kept.2.2 with
  | .inl same => absurd (line_advances (E := W.activityClass) (Eq.subst (motive := fun z => «相续» _ _ z y) same line))
      (Nat.lt_irrefl y.1)
  | .inr reach => match «及即迭».mp reach with
    | ⟨k, steps⟩ => ⟨k, (steps_iff_lineage (Nat.le_refl x.1) (k + 1)).mp steps⟩

example {x y : Nat × F} (line : «及» («续» (continuationStep R) W.activityClass) x y)
    (start : W.active x.1 x.2) : ∃ k, y.1 = x.1 + (k + 1) ∧ W.Lineage R x.1 x.2 (k + 1) y.2 :=
  line_lineage line start

end LineageReview
end Web
end Becoming

#print axioms Becoming.Web.LineageReview.steps_iff_lineage_v1
#print axioms Becoming.Web.LineageReview.lineage_of_steps
#print axioms Becoming.Web.LineageReview.split_v2
#print axioms Becoming.Web.LineageReview.lineage_iff_steps_at
#print axioms Becoming.Web.LineageReview.split_v3
#print axioms Becoming.Web.LineageReview.cons_v4
#print axioms Becoming.Web.LineageReview.line_v5
#print axioms Becoming.Web.LineageReview.line_lineage_v6
