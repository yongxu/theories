/-! Cheap sanity checks for the architecture review (Init only). -/

-- A frame reduced to what C reads: configurations S, claims C', realized, living.
structure Fr (S C' : Type) where
  realized : S → C' → Prop

def Ext {S C'} (F : Fr S C') (living : C' → Prop) (s t : S) : Prop :=
  (∀ c, F.realized s c → F.realized t c) ∧ ∃ c, living c ∧ F.realized t c ∧ ¬ F.realized s c

def Cmp {S C'} (F : Fr S C') (living : C' → Prop) (Better : S → S → Prop) : Prop :=
  ∀ s t, Ext F living s t → Better s t

/-- C is independent of every frame with an extension: one `Better` meets it, one fails it. -/
theorem cmp_independent {S C'} (F : Fr S C') (living : C' → Prop)
    (ext : ∃ s t, Ext F living s t) :
    Cmp F living (Ext F living) ∧ ¬ Cmp F living (fun _ _ => False) :=
  ⟨fun _ _ h => h, fun c => match ext with | ⟨s, t, h⟩ => c s t h⟩

/-- Pareto form: given standpoint orders each increasing in admission, the unanimity order
meets C; and C for `Better` is exactly `Better` containing the unanimity of any class of
orders that contains `Ext` itself (so C = Pareto over that class, no more). -/
theorem cmp_of_unanimity {S C' I} (F : Fr S C') (living : C' → Prop)
    (O : I → S → S → Prop) (incr : ∀ i, Cmp F living (O i)) :
    Cmp F living (fun s t => ∀ i, O i s t) :=
  fun s t h i => incr i s t h

theorem cmp_iff_contains_unanimity {S C' I} (F : Fr S C') (living : C' → Prop)
    (O : I → S → S → Prop) (incr : ∀ i, Cmp F living (O i)) (i₀ : I)
    (isExt : ∀ s t, O i₀ s t ↔ Ext F living s t) (Better : S → S → Prop) :
    Cmp F living Better ↔ ∀ s t, (∀ i, O i s t) → Better s t :=
  ⟨fun c s t all => c s t ((isExt s t).mp (all i₀)),
   fun h s t e => h s t (fun i => incr i s t e)⟩

/-- A root statement valid for every relation excludes no relation: it forbids nothing. -/
theorem valid_forbids_nothing (Φ : ∀ {α : Type}, (α → α → Prop) → Prop)
    (valid : ∀ {α : Type} (R : α → α → Prop), Φ R) :
    ¬ ∃ (α : Type) (R : α → α → Prop), ¬ Φ R :=
  fun ⟨_, R, h⟩ => h (valid R)

#print axioms cmp_independent
#print axioms cmp_iff_contains_unanimity
#print axioms valid_forbids_nothing
