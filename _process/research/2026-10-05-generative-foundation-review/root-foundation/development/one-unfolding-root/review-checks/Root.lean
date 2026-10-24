namespace Check

structure Unfolding where
  Way : Type
  becomes : Way → Way → Prop

variable (U : Unfolding)

def Carries (E : U.Way → U.Way → Prop) : Prop :=
  ∀ u u', E u u' → ∀ v, U.becomes u v → ∃ v', U.becomes u' v' ∧ E v v'

def Within (E : U.Way → U.Way → Prop) (u u' : U.Way) : Prop :=
  ∃ R : U.Way → U.Way → Prop, (∀ x y, R x y → E x y) ∧ (∀ x y, R x y → R y x) ∧ Carries U R ∧ R u u'

variable {U}

theorem one (E : U.Way → U.Way → Prop) :
    (∀ x y, Within U E x y → E x y) ∧ Carries U (Within U E) ∧
    ∀ R : U.Way → U.Way → Prop, (∀ x y, R x y → E x y) → (∀ x y, R x y → R y x) → Carries U R →
      ∀ x y, R x y → Within U E x y :=
  ⟨fun _ _ ⟨_, sub, _, _, r⟩ => sub _ _ r,
   fun _ _ ⟨R, sub, sym, car, r⟩ v step =>
     match car _ _ r v step with
     | ⟨v', step', r'⟩ => ⟨v', step', R, sub, sym, car, r'⟩,
   fun R sub sym car x y r => ⟨R, sub, sym, car, r⟩⟩

theorem Within.symm {E : U.Way → U.Way → Prop} {x y : U.Way} : Within U E x y → Within U E y x
  | ⟨R, sub, sym, car, r⟩ => ⟨R, sub, sym, car, sym _ _ r⟩

theorem Within.refl {E : U.Way → U.Way → Prop} (refl : ∀ x, E x x) (x : U.Way) : Within U E x x :=
  ⟨fun a b => a = b, fun a b h => h ▸ refl a, fun _ _ h => h.symm,
   fun _ _ h v step => ⟨v, h ▸ step, rfl⟩, rfl⟩

theorem Within.trans {E : U.Way → U.Way → Prop} (tr : ∀ x y z, E x y → E y z → E x z)
    {x y z : U.Way} : Within U E x y → Within U E y z → Within U E x z
  | ⟨R, sub, sym, car, r⟩, ⟨R', sub', sym', car', r'⟩ =>
    let C : U.Way → U.Way → Prop := fun a c => (∃ b, R a b ∧ R' b c) ∨ (∃ b, R' a b ∧ R b c)
    ⟨C,
     fun a c h => match h with
       | .inl ⟨b, h1, h2⟩ => tr _ _ _ (sub _ _ h1) (sub' _ _ h2)
       | .inr ⟨b, h1, h2⟩ => tr _ _ _ (sub' _ _ h1) (sub _ _ h2),
     fun a c h => match h with
       | .inl ⟨b, h1, h2⟩ => .inr ⟨b, sym' _ _ h2, sym _ _ h1⟩
       | .inr ⟨b, h1, h2⟩ => .inl ⟨b, sym _ _ h2, sym' _ _ h1⟩,
     fun a c h v step => match h with
       | .inl ⟨b, h1, h2⟩ => match car _ _ h1 v step with
         | ⟨w, sw, rw⟩ => match car' _ _ h2 w sw with
           | ⟨v', sv', rv'⟩ => ⟨v', sv', .inl ⟨w, rw, rv'⟩⟩
       | .inr ⟨b, h1, h2⟩ => match car' _ _ h1 v step with
         | ⟨w, sw, rw⟩ => match car _ _ h2 w sw with
           | ⟨v', sv', rv'⟩ => ⟨v', sv', .inr ⟨w, rw, rv'⟩⟩,
     .inl ⟨y, r, r'⟩⟩

/-- Carries plus symmetry gives the back clause: a bisimulation. -/
theorem back_of_symm {R : U.Way → U.Way → Prop} (sym : ∀ x y, R x y → R y x) (car : Carries U R)
    {u u' : U.Way} (r : R u u') : ∀ v', U.becomes u' v' → ∃ v, U.becomes u v ∧ R v v' :=
  fun v' step => match car _ _ (sym _ _ r) v' step with
    | ⟨v, sv, rv⟩ => ⟨v, sv, sym _ _ rv⟩

def Step (E R : U.Way → U.Way → Prop) (u u' : U.Way) : Prop :=
  E u u' ∧ (∀ v, U.becomes u v → ∃ v', U.becomes u' v' ∧ R v v')
         ∧ (∀ v', U.becomes u' v' → ∃ v, U.becomes u v ∧ R v v')

def Stage (E : U.Way → U.Way → Prop) : Nat → U.Way → U.Way → Prop
  | 0     => E
  | k + 1 => Step E (Stage E k)

/-- The closure lies within every stage, with no hypothesis. -/
theorem within_stage (E : U.Way → U.Way → Prop) : ∀ k x y, Within U E x y → Stage E k x y
  | 0, _, _, w => (one E).1 _ _ w
  | k + 1, x, y, w =>
    ⟨(one E).1 _ _ w,
     fun v step => match (one E).2.1 _ _ w v step with
       | ⟨v', s', w'⟩ => ⟨v', s', within_stage E k _ _ w'⟩,
     fun v' step => match (one E).2.1 _ _ w.symm v' step with
       | ⟨v, s, w'⟩ => ⟨v, s, within_stage E k _ _ w'.symm⟩⟩

theorem stage_symm {E : U.Way → U.Way → Prop} (sym : ∀ x y, E x y → E y x) :
    ∀ k x y, Stage E k x y → Stage E k y x
  | 0, _, _, h => sym _ _ h
  | k + 1, _, _, ⟨e, f, b⟩ =>
    ⟨sym _ _ e,
     fun v' s => match b v' s with | ⟨v, sv, r⟩ => ⟨v, sv, stage_symm sym k _ _ r⟩,
     fun v s => match f v s with | ⟨v', sv', r⟩ => ⟨v', sv', stage_symm sym k _ _ r⟩⟩

/-- A stage that stabilizes is the closure, given E symmetric; stated pointwise. -/
theorem stable_closure {E : U.Way → U.Way → Prop} (sym : ∀ x y, E x y → E y x) (k : Nat)
    (stable : ∀ x y, Stage E (k + 1) x y ↔ Stage E k x y) :
    ∀ x y, Stage E k x y ↔ Within U E x y :=
  fun x y =>
    ⟨fun h => ⟨Stage E k,
       fun a b r => ((stable a b).mpr r).1,
       stage_symm sym k,
       fun a b r v step => ((stable a b).mpr r).2.1 v step,
       h⟩,
     within_stage E k x y⟩

/-- Without symmetry the stabilization claim fails: two ways, no steps, E one-directional. -/
def Two : Unfolding := ⟨Bool, fun _ _ => False⟩
def oneWay : Two.Way → Two.Way → Prop := fun a b => a = false ∧ b = true

theorem stable_not_closure :
    (∀ x y, Stage (U := Two) oneWay 1 x y ↔ Stage (U := Two) oneWay 0 x y) ∧
    Stage (U := Two) oneWay 0 false true ∧ ¬ Within Two oneWay false true :=
  ⟨fun _ _ => ⟨fun h => h.1, fun h => ⟨h, fun _ s => s.elim, fun _ s => s.elim⟩⟩,
   ⟨rfl, rfl⟩,
   fun ⟨_, sub, sym, _, r⟩ => Bool.noConfusion ((sub _ _ (sym _ _ r)).1)⟩

/-- Reach never widens along a step. -/
inductive Reach (U : Unfolding) : U.Way → U.Way → Prop
  | refl (u) : Reach U u u
  | step {u v w} : U.becomes u v → Reach U v w → Reach U u w

theorem reach_narrows {u v : U.Way} (s : U.becomes u v) : ∀ w, Reach U v w → Reach U u w :=
  fun _ r => .step s r

/-- Literal reading of 相因 ("each in the other's closure" as Within E₂ ⊆ E₁ and Within E₁ ⊆ E₂)
is reflexive: every reading stands in it with itself. -/
def InClosureOf (E₁ E₂ : U.Way → U.Way → Prop) : Prop := ∀ x y, Within U E₂ x y → E₁ x y

theorem literal_xiangyin_refl (E : U.Way → U.Way → Prop) :
    InClosureOf (U := U) E E ∧ InClosureOf (U := U) E E :=
  ⟨fun x y w => (one E).1 x y w, fun x y w => (one E).1 x y w⟩

end Check

#print axioms Check.one
#print axioms Check.Within.trans
#print axioms Check.within_stage
#print axioms Check.stable_closure
#print axioms Check.stable_not_closure
#print axioms Check.back_of_symm
