namespace HM

structure Unfolding where
  Way : Type
  becomes : Way → Way → Prop

def Carries (U : Unfolding) (E : U.Way → U.Way → Prop) : Prop :=
  ∀ u u', E u u' → ∀ v, U.becomes u v → ∃ v', U.becomes u' v' ∧ E v v'

def Within (U : Unfolding) (E : U.Way → U.Way → Prop) (u u' : U.Way) : Prop :=
  ∃ R : U.Way → U.Way → Prop, (∀ x y, R x y → E x y) ∧ (∀ x y, R x y → R y x) ∧ Carries U R ∧ R u u'

def Step (U : Unfolding) (E R : U.Way → U.Way → Prop) (u u' : U.Way) : Prop :=
  E u u' ∧ (∀ v, U.becomes u v → ∃ v', U.becomes u' v' ∧ R v v')
         ∧ (∀ v', U.becomes u' v' → ∃ v, U.becomes u v ∧ R v v')

def Stage (U : Unfolding) (E : U.Way → U.Way → Prop) : Nat → U.Way → U.Way → Prop
  | 0     => E
  | k + 1 => Step U E (Stage U E k)

def LLPO : Prop :=
  ∀ α : Nat → Bool, (∀ i j, α i = true → α j = true → i = j) →
    (∀ n, α (2 * n) = false) ∨ (∀ n, α (2 * n + 1) = false)

inductive W where
  | u | u' | v (n : Nat) | a (n : Nat) | b (n : Nat)

def oddClear (α : Nat → Bool) (n : Nat) : Prop := ∀ j, j ≤ n → α (2 * j + 1) = false
def evenClear (α : Nat → Bool) (n : Nat) : Prop := ∀ j, j ≤ n → α (2 * j) = false

/-- Finitely branching (at most three successors), each step decidable by a bounded search. -/
def step (α : Nat → Bool) : W → W → Prop
  | .u, y => y = .v 0 ∨ y = .a 0 ∨ y = .b 0
  | .u', y => y = .a 0 ∨ y = .b 0
  | .v n, y => y = .v (n + 1)
  | .a n, y => y = .a (n + 1) ∧ oddClear α n
  | .b n, y => y = .b (n + 1) ∧ evenClear α n

def U (α : Nat → Bool) : Unfolding := ⟨W, step α⟩

def top : W → W → Prop := fun _ _ => True

theorem stage_refl (α : Nat → Bool) : ∀ k (x : W), Stage (U α) top k x x
  | 0, _ => trivial
  | k + 1, x => ⟨trivial, fun v s => ⟨v, s, stage_refl α k v⟩, fun v s => ⟨v, s, stage_refl α k v⟩⟩

theorem stage_va (α : Nat → Bool) : ∀ k n, oddClear α (n + k) → Stage (U α) top k (.v n) (.a n)
  | 0, _, _ => trivial
  | k + 1, n, clear =>
    have next : oddClear α (n + 1 + k) := fun j le => clear j (by omega)
    have here : oddClear α n := fun j le => clear j (by omega)
    ⟨trivial,
     fun y s => by
       cases s
       exact ⟨.a (n + 1), ⟨rfl, here⟩, stage_va α k (n + 1) next⟩,
     fun y s => by
       cases s with
       | intro e _ => cases e; exact ⟨.v (n + 1), rfl, stage_va α k (n + 1) next⟩⟩

theorem stage_vb (α : Nat → Bool) (clear : ∀ m, α (2 * m) = false) :
    ∀ k n, Stage (U α) top k (.v n) (.b n)
  | 0, _ => trivial
  | k + 1, n =>
    ⟨trivial,
     fun y s => by
       cases s
       exact ⟨.b (n + 1), ⟨rfl, fun j _ => clear j⟩, stage_vb α clear k (n + 1)⟩,
     fun y s => by
       cases s with
       | intro e _ => cases e; exact ⟨.v (n + 1), rfl, stage_vb α clear k (n + 1)⟩⟩

def anyOdd (α : Nat → Bool) : Nat → Bool
  | 0 => α 1
  | k + 1 => anyOdd α k || α (2 * (k + 1) + 1)

theorem anyOdd_false (α : Nat → Bool) : ∀ k, anyOdd α k = false → oddClear α k
  | 0, h, j, le => by
      have : j = 0 := by omega
      subst this; exact h
  | k + 1, h, j, le => by
      simp only [anyOdd, Bool.or_eq_false_iff] at h
      by_cases hj : j ≤ k
      · exact anyOdd_false α k h.1 j hj
      · have : j = k + 1 := by omega
        subst this; exact h.2

theorem anyOdd_true (α : Nat → Bool) : ∀ k, anyOdd α k = true → ∃ j, α (2 * j + 1) = true
  | 0, h => ⟨0, h⟩
  | k + 1, h => by
      simp only [anyOdd, Bool.or_eq_true] at h
      cases h with
      | inl h => exact anyOdd_true α k h
      | inr h => exact ⟨k + 1, h⟩

/-- The two ways stand in every stage, for every α with at most one `true`. -/
theorem every_stage (α : Nat → Bool) (once : ∀ i j, α i = true → α j = true → i = j) :
    ∀ k, Stage (U α) top k .u .u'
  | 0 => trivial
  | k + 1 =>
    ⟨trivial,
     fun y s => by
       rcases s with e | e | e
       · subst e
         cases h : anyOdd α k with
         | false => exact ⟨.a 0, .inl rfl, stage_va α k 0 (by
             have := anyOdd_false α k h; simpa using this)⟩
         | true =>
           obtain ⟨j, hj⟩ := anyOdd_true α k h
           have clear : ∀ m, α (2 * m) = false := fun m => by
             cases hm : α (2 * m) with
             | false => rfl
             | true => have := once _ _ hm hj; omega
           exact ⟨.b 0, .inr rfl, stage_vb α clear k 0⟩
       · subst e; exact ⟨.a 0, .inl rfl, stage_refl α k _⟩
       · subst e; exact ⟨.b 0, .inr rfl, stage_refl α k _⟩,
     fun y s => by
       rcases s with e | e
       · subst e; exact ⟨.a 0, .inr (.inl rfl), stage_refl α k _⟩
       · subst e; exact ⟨.b 0, .inr (.inr rfl), stage_refl α k _⟩⟩

theorem next_a (α : Nat → Bool) (R : W → W → Prop) (car : Carries (U α) R) (n : Nat)
    (r : R (.v n) (.a n)) : R (.v (n + 1)) (.a (n + 1)) ∧ oddClear α n :=
  match car _ _ r (.v (n + 1)) rfl with
  | ⟨_, ⟨e, clear⟩, r'⟩ => ⟨e ▸ r', clear⟩

theorem next_b (α : Nat → Bool) (R : W → W → Prop) (car : Carries (U α) R) (n : Nat)
    (r : R (.v n) (.b n)) : R (.v (n + 1)) (.b (n + 1)) ∧ evenClear α n :=
  match car _ _ r (.v (n + 1)) rfl with
  | ⟨_, ⟨e, clear⟩, r'⟩ => ⟨e ▸ r', clear⟩

theorem along_a (α : Nat → Bool) (R : W → W → Prop) (car : Carries (U α) R)
    (r : R (.v 0) (.a 0)) : ∀ n, R (.v n) (.a n)
  | 0 => r
  | n + 1 => (next_a α R car n (along_a α R car r n)).1

theorem along_b (α : Nat → Bool) (R : W → W → Prop) (car : Carries (U α) R)
    (r : R (.v 0) (.b 0)) : ∀ n, R (.v n) (.b n)
  | 0 => r
  | n + 1 => (next_b α R car n (along_b α R car r n)).1

/-- **The Hennessy–Milner limit, for these finitely branching decidable unfoldings, gives LLPO.** -/
theorem limit_gives_llpo
    (limit : ∀ α, (∀ k, Stage (U α) top k .u .u') → Within (U α) top .u .u') : LLPO :=
  fun α once =>
    match limit α (every_stage α once) with
    | ⟨R, _, _, car, r⟩ =>
      match car _ _ r (.v 0) (.inl rfl) with
      | ⟨y, s, r'⟩ => by
          rcases s with e | e
          · subst e
            exact .inr fun n => (next_a α R car n (along_a α R car r' n)).2 n (Nat.le_refl n)
          · subst e
            exact .inl fun n => (next_b α R car n (along_b α R car r' n)).2 n (Nat.le_refl n)

end HM

#print axioms HM.limit_gives_llpo
#print axioms HM.every_stage
