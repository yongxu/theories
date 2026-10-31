-- Skeptic checks, Init only.
abbrev Rel (α : Type) := α → α → Prop
inductive Reach (R : Rel α) : Rel α
  | one {x y} : R x y → Reach R x y
  | more {x y z} : R x y → Reach R y z → Reach R x z
def Cont (R E : Rel α) : Rel α := fun x y => R x y ∧ E x y
def Within (R L : Rel α) (x y : α) : Prop := x = y ∨ Reach (Cont R L) x y
def NoOutside (R E : Rel α) (center : Pos → α) : Prop := ∀ p x, Within R E (center p) x
-- root form of the condition is contingent: holds on one point, fails on two unjoined points
theorem noOutside_holds : NoOutside (fun (_ _ : Unit) => False) (fun _ _ => True) (fun (_ : Unit) => ()) :=
  fun _ _ => .inl rfl
theorem noOutside_fails : ¬ NoOutside (fun (_ _ : Bool) => False) (fun _ _ => True) (fun (_ : Unit) => false) :=
  fun h => match h () true with
    | .inl e => Bool.noConfusion e
    | .inr r => match r with
      | .one ⟨f, _⟩ => f
      | .more ⟨f, _⟩ _ => f
-- the reviewer's comparison_iff_pareto collapses: the unanimity of a class containing Ext is Ext
theorem unanimity_is_ext {S I : Type} (Ext : S → S → Prop) (O : I → S → S → Prop)
    (incr : ∀ i s t, Ext s t → O i s t) (i₀ : I) (isExt : ∀ s t, O i₀ s t ↔ Ext s t) :
    ∀ s t, (∀ i, O i s t) ↔ Ext s t :=
  fun s t => ⟨fun a => (isExt s t).mp (a i₀), fun e i => incr i s t e⟩
#print axioms noOutside_holds
#print axioms noOutside_fails
#print axioms unanimity_is_ext
