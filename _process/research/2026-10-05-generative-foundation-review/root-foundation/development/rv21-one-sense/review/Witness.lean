abbrev Rel (α : Type) := α → α → Prop
def comp (R S : Rel α) : Rel α := fun x z => ∃ y, R x y ∧ S y z
def conv (R : Rel α) : Rel α := fun x y => R y x
def incl (R S : Rel α) : Prop := ∀ x y, R x y → S x y
def ident : Rel α := fun x y => x = y
def constant (R E : Rel α) : Prop := incl (comp (conv E) R) (comp R (conv E))
def core (R E : Rel α) : Rel α := fun u u' => ∃ S : Rel α, incl S E ∧ incl S (conv S) ∧ constant R S ∧ S u u'
def goAlike (R E : Rel α) : Prop := incl (comp (comp (conv R) E) R) E

-- 1. Branching: 0 → 1, 0 → 2. The core of identity is identity, constant, yet does not go alike.
def br : Rel Nat := fun x y => x = 0 ∧ (y = 1 ∨ y = 2)
theorem core_ident_not_goAlike : ¬ goAlike br (core br ident) := by
  intro h
  have hid : core br ident 0 0 := ⟨ident, fun _ _ h => h, fun _ _ h => h.symm,
    fun x z ⟨y, hyx, hr⟩ => ⟨z, by cases hyx; exact hr, rfl⟩, rfl⟩
  have := h 1 2 ⟨0, ⟨0, ⟨rfl, Or.inl rfl⟩, hid⟩, ⟨rfl, Or.inr rfl⟩⟩
  match this with
  | ⟨S, hS, _, _, h12⟩ => exact absurd (hS 1 2 h12) (show ¬ (1:Nat) = 2 by decide)

-- 2. An ending: 0 → 2 only; the class lumping 0 and 1 goes alike but 0, 1 are apart in its core.
def en : Rel Nat := fun x y => x = 0 ∧ y = 2
def cls : Rel Nat := fun x y => (x ≤ 1 ∧ y ≤ 1) ∨ x = y
theorem cls_goAlike : goAlike en cls := by
  intro y y' ⟨x', ⟨x, ⟨hx, hy⟩, _⟩, ⟨hx', hy'⟩⟩
  exact Or.inr (hy.trans hy'.symm)
theorem cls_not_in_core : cls 0 1 ∧ ¬ core en cls 0 1 := by
  refine ⟨Or.inl ⟨by decide, by decide⟩, ?_⟩
  intro ⟨S, _, hsym, hc, h01⟩
  match hc 1 2 ⟨0, h01, ⟨rfl, rfl⟩⟩ with
  | ⟨_, ⟨h1, _⟩, _⟩ => exact absurd h1 (show ¬ (1:Nat) = 0 by decide)

-- 3. A lossless return renewing without end: 0→1→2→3→0, classes {1,2} and {3,0}.
def cyc : Rel Nat := fun x y => (x = 0 ∧ y = 1) ∨ (x = 1 ∧ y = 2) ∨ (x = 2 ∧ y = 3) ∨ (x = 3 ∧ y = 0)
def blk (n : Nat) : Nat := if n = 1 ∨ n = 2 then 0 else 1
def E4 : Rel Nat := fun x y => blk x = blk y
instance (x y : Nat) : Decidable (E4 x y) := inferInstanceAs (Decidable (blk x = blk y))
def cont (R E : Rel α) : Rel α := fun x y => R x y ∧ E x y
inductive reach (R : Rel α) : Rel α
  | one {x y} : R x y → reach R x y
  | more {x y z} : R x y → reach R y z → reach R x z
def begins (R E : Rel α) (y : α) : Prop := ¬ ∃ x, cont R E x y
def renewsWithoutEnd (R E : Rel α) (x : α) : Prop :=
  ∃ S : α → Prop, (∀ z, S z → ∃ y w, R z y ∧ begins R E y ∧ reach (cont R E) y w ∧ S w) ∧ S x
theorem cycle_renews : renewsWithoutEnd cyc E4 0 := by
  refine ⟨fun z => z = 0 ∨ z = 2, ?_, Or.inl rfl⟩
  intro z hz
  rcases hz with rfl | rfl
  · refine ⟨1, 2, Or.inl ⟨rfl, rfl⟩, ?_, .one ⟨Or.inr (Or.inl ⟨rfl, rfl⟩), by decide⟩, Or.inr rfl⟩
    intro ⟨x, hr, he⟩
    rcases hr with ⟨rfl, _⟩ | ⟨_, h⟩ | ⟨_, h⟩ | ⟨_, h⟩
    · exact absurd he (by decide)
    all_goals exact absurd h (by decide)
  · refine ⟨3, 0, Or.inr (Or.inr (Or.inl ⟨rfl, rfl⟩)), ?_, .one ⟨Or.inr (Or.inr (Or.inr ⟨rfl, rfl⟩)), by decide⟩, Or.inl rfl⟩
    intro ⟨x, hr, he⟩
    rcases hr with ⟨_, h⟩ | ⟨_, h⟩ | ⟨rfl, _⟩ | ⟨_, h⟩
    · exact absurd h (by decide)
    · exact absurd h (by decide)
    · exact absurd he (by decide)
    · exact absurd h (by decide)
