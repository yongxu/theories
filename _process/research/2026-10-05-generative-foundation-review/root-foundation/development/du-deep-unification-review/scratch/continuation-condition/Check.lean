-- Self-contained sanity check, imports only Init. Mirrors the package's grammar definitions.
universe u
variable {α : Type u}

inductive Reach (R : α → α → Prop) : α → α → Prop
  | one {x y} : R x y → Reach R x y
  | more {x y z} : R x y → Reach R y z → Reach R x z

def Cont (R E : α → α → Prop) : α → α → Prop := fun x y => R x y ∧ E x y

inductive Fam (R E : α → α → Prop) : α → α → Prop
  | refl (x : α) : Fam R E x x
  | step {x y} : Cont R E x y → Fam R E x y
  | symm {x y} : Fam R E x y → Fam R E y x
  | trans {x y z} : Fam R E x y → Fam R E y z → Fam R E x z

def Whole : α → α → Prop := fun _ _ => True
def Joined (R : α → α → Prop) : α → α → Prop := Fam R Whole

-- package: «至终有常»
def ConstToEnd (R E : α → α → Prop) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w
-- package: «所缘同于»
def HoldsEffects (R E : α → α → Prop) (m : α) : Prop := ∀ v, R m v → E m v

theorem joined_step (R : α → α → Prop) {x y} (h : R x y) : Joined R x y := .step ⟨h, trivial⟩

/-- P2 at the class of being joined, with no totality hypothesis. -/
theorem joined_constToEnd (R : α → α → Prop) : ConstToEnd R (Joined R) := by
  intro u u' e v r
  -- decide-free: if u' conditions some w, take it
  exact Classical.byCases (p := ∃ w, R u' w)
    (fun ⟨w, hw⟩ => .inl ⟨w, hw, .trans (.symm (joined_step R r)) (.trans e (joined_step R hw))⟩)
    (fun none => .inr fun w hw => none ⟨w, hw⟩)

/-- Constructive form: the disjunction is not needed; constancy-to-end in the weak (¬¬-free) sense
  holds pointwise wherever u' conditions anything. -/
theorem joined_const_at (R : α → α → Prop) {u u' v w} (e : Joined R u u') (r : R u v) (hw : R u' w) :
    Joined R v w :=
  .trans (.symm (joined_step R r)) (.trans e (joined_step R hw))

/-- P4 at the class of being joined, for every occurrence. -/
theorem joined_holdsEffects (R : α → α → Prop) (m : α) : HoldsEffects R (Joined R) m :=
  fun _ r => joined_step R r

/-- The condition in families at the one is that the net is joined. -/
theorem famNoOutside_iff_joined {Pos : Type} (R : α → α → Prop) (center : Pos → α) (p0 : Pos) :
    (∀ p x, Fam R Whole (center p) x) ↔ ∀ x y, Fam R Whole x y :=
  ⟨fun h x y => .trans (.symm (h p0 x)) (h p0 y), fun h p x => h (center p) x⟩

/-- The free condition is idle as a premise: for any statement respecting pointwise equivalence,
  holding under every significance meeting the condition is holding at the constant-true one. -/
theorem idle {Pos F : Type} (Φ : (Pos → Nat → F → Prop) → Prop)
    (resp : ∀ s s', (∀ p t f, s p t f ↔ s' p t f) → Φ s → Φ s') :
    (∀ sig, (∀ p t f, sig p t f) → Φ sig) ↔ Φ (fun _ _ _ => True) :=
  ⟨fun h => h _ (fun _ _ _ => trivial),
   fun h sig u => resp _ sig (fun p t f => ⟨fun _ => u p t f, fun _ => trivial⟩) h⟩

/-- Scope agreement: courses agreeing outside a region D compare by inclusion over the whole exactly
  as they compare within D (any scope containing D gives the same verdict). -/
theorem scope_agree (A A' D : α → Prop) (agree : ∀ x, ¬ D x → (A x ↔ A' x)) :
    (∀ x, A x → A' x) ↔ (∀ x, D x → A x → A' x) :=
  ⟨fun h x _ a => h x a, fun h x a =>
    Classical.byCases (p := D x) (fun d => h x d a) (fun nd => (agree x nd).mp a)⟩

theorem reach_snoc {R : α → α → Prop} {x z y : α} (h : Reach R x z) (r : R z y) : Reach R x y := by
  induction h with
  | one h => exact .more h (.one r)
  | more h _ ih => exact .more h (ih r)

/-- Locality on the root: two runs obeying the same mechanism everywhere except at x (each value
  fixed by the values of its conditions) agree at every occurrence that is neither x nor reached
  from x, on a net where every occurrence is accessible along conditions. -/
theorem locality {β : Type} (R : α → α → Prop) (x : α) (v w : α → β)
    (mech : ∀ y, y ≠ x → (∀ z, R z y → v z = w z) → v y = w y) :
    ∀ y, Acc R y → y ≠ x → ¬ Reach R x y → v y = w y := by
  intro y acc
  induction acc with
  | intro y _ ih =>
    intro ne nreach
    apply mech y ne
    intro z rz
    apply ih z rz
    · intro e; subst e; exact nreach (.one rz)
    · intro rxz
      exact nreach (reach_snoc rxz rz)

#print axioms joined_const_at
#print axioms joined_holdsEffects
#print axioms famNoOutside_iff_joined
#print axioms idle
#print axioms locality
#print axioms scope_agree
#print axioms joined_constToEnd
