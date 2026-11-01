-- Standalone copies of the grammar's definitions (Grammar.lean:47-72, GrammarLaws.lean:1040,1813,1936)
abbrev Rel (α : Type u) : Type u := α → α → Prop
def comp (R S : Rel α) : Rel α := fun x z => ∃ y, R x y ∧ S y z
def conv (R : Rel α) : Rel α := fun x y => R y x
def incl (R S : Rel α) : Prop := ∀ x y, R x y → S x y
def eqR : Rel α := fun x y => x = y
def fixedSucc (R : Rel α) : Prop := incl (comp (conv R) R) eqR
def goesAlike (R E : Rel α) : Prop := incl (comp (comp (conv R) E) R) E
def image {κ : Type v} (π : α → κ) (R : Rel α) : Rel κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'
-- GuardHorizon / Keeping copies
def ChoiceOver (O : Type w) (α : Type z) : Prop :=
  ∀ R : O → α → Prop, (∀ o, ∃ x, R o x) → ∃ f : O → α, ∀ o, R o (f o)
def UniformPolicy {S A O : Type} (obs : S → O) (good : S → A → Prop) : Prop :=
  ∃ policy : O → A, ∀ s, good s (policy (obs s))
def FiberFeasible {S A O : Type} (obs : S → O) (good : S → A → Prop) : Prop :=
  ∀ o, ∃ a, ∀ s, obs s = o → good s a
-- SJ1's definitions as the design states them
def Licensed {S A : Type} (E : S → S → Prop) (G : S → A → Prop) (s : S) (a : A) : Prop :=
  ∀ s', E s s' → G s' a
def Law2 {S A : Type} (E : S → S → Prop) (G : S → A → Prop) : Prop := ∀ s, ∃ a, Licensed E G s a
def Judgement {S A : Type} (E : S → S → Prop) (G : S → A → Prop) : Prop :=
  ∃ J : S → A → Prop, (∀ s a, J s a → G s a) ∧ (∀ s, ∃ a, J s a) ∧ (∀ s s' a, E s s' → J s a → J s' a)

/-! (1) Law 3 as worded ("a rule exists exactly where (2) holds and choice over the readings is
given") fails on empty types: no situations, no acts, one reading. -/
theorem law3_as_worded_fails :
    Law2 (fun (s s' : Empty) => (fun _ => ()) s = (fun _ => ()) s') (fun (_ : Empty) (_ : Empty) => True) ∧
    ChoiceOver Unit Empty ∧
    ¬ UniformPolicy (fun _ : Empty => ()) (fun (_ : Empty) (_ : Empty) => True) :=
  ⟨(fun s => nomatch s), (fun _ each => match each () with | ⟨x, _⟩ => nomatch x), (fun ⟨p, _⟩ => nomatch p ())⟩

/-! (1b) Law 2 differs from FiberFeasible at readings no situation gives. -/
theorem law2_not_fiberFeasible :
    Law2 (fun (s s' : Empty) => (fun _ => ()) s = (fun _ => ()) s') (fun (_ : Empty) (_ : Empty) => True) ∧
    ¬ FiberFeasible (fun _ : Empty => ()) (fun (_ : Empty) (_ : Empty) => True) :=
  ⟨(fun s => nomatch s), (fun ff => match ff () with | ⟨a, _⟩ => nomatch a)⟩

/-! (2) The sum encoding of law 5. -/
section Sum
variable {S A O : Type} (obs : S → O) (G : S → A → Prop)
def carrierRel : Rel (S ⊕ A) := fun x y =>
  Sum.elim (fun s => Sum.elim (fun _ => False) (fun a => G s a) y) (fun _ => False) x
def readMap : S ⊕ A → O ⊕ A
  | .inl s => .inl (obs s)
  | .inr a => .inr a

theorem law5_sum (total : ∀ s, ∃ a, G s a) (functional : ∀ s a a', G s a → G s a' → a = a') :
    Judgement (fun s s' => obs s = obs s') G ↔ fixedSucc (image (readMap obs) (carrierRel G)) := by
  constructor
  · intro ⟨J, sub, tot, alike⟩
    intro k k' ⟨k0, ⟨x, u, hx, r, hu⟩, ⟨x', u', hx', r', hu'⟩⟩
    cases x with
    | inr _ => exact r.elim
    | inl s =>
      cases u with
      | inl _ => exact r.elim
      | inr a =>
        cases x' with
        | inr _ => exact r'.elim
        | inl s' =>
          cases u' with
          | inl _ => exact r'.elim
          | inr a' =>
            have e : obs s = obs s' := Sum.inl.inj (show readMap obs (.inl s) = readMap obs (.inl s') from hx.trans hx'.symm)
            obtain ⟨b, jb⟩ := tot s
            have gsb := sub _ _ jb
            have gs'b := sub _ _ (alike s s' b e jb)
            have h1 : a = b := functional s a b r gsb
            have h2 : a' = b := functional s' a' b r' gs'b
            have hk : readMap obs (.inr b) = k := h1 ▸ hu
            have hk' : readMap obs (.inr b) = k' := h2 ▸ hu'
            exact hk.symm.trans hk'
  · intro fixed
    refine ⟨G, fun _ _ g => g, total, fun s s' a e g => ?_⟩
    obtain ⟨b, gb⟩ := total s'
    have : readMap obs (.inr a) = readMap obs (.inr b) :=
      fixed _ _ ⟨readMap obs (.inl s), ⟨.inl s, .inr a, rfl, g, rfl⟩,
        ⟨.inl s', .inr b, congrArg Sum.inl e.symm, gb, rfl⟩⟩
    have ab : a = b := Sum.inr.inj this
    exact ab ▸ gb

/-- Without totality the equivalence fails: a situation with no good act. -/
theorem law5_needs_total :
    fixedSucc (image (readMap (fun _ : Unit => ())) (carrierRel (fun (_ : Unit) (_ : Unit) => False))) ∧
    ¬ Judgement (fun (s s' : Unit) => (fun _ => ()) s = (fun _ => ()) s') (fun (_ : Unit) (_ : Unit) => False) :=
  ⟨fun _ _ ⟨_, ⟨x, u, _, r, _⟩, _⟩ => match x, u, r with | .inl _, .inr _, r => False.elim r | .inl _, .inl _, r => False.elim r | .inr _, _, r => False.elim r,
   fun ⟨_, sub, tot, _⟩ => match tot () with | ⟨a, j⟩ => sub _ a j⟩
end Sum

/-! (3) One carrier with acts that are also situations (acts as successor states), π the reading
on everything: «像定后» holds while no judgement exists (statewise_not_uniform's witness). -/
theorem one_carrier_spurious :
    fixedSucc (image (fun _ : Bool => ()) (fun s a : Bool => a = s)) ∧
    ¬ Judgement (fun (s s' : Bool) => (fun _ => ()) s = (fun _ => ()) s') (fun s a : Bool => a = s) :=
  ⟨fun _ _ _ => rfl,
   fun ⟨J, sub, tot, alike⟩ => match tot true with
    | ⟨a, j⟩ => have h1 := sub _ _ j; have h2 := sub _ _ (alike true false a rfl j)
                nomatch h1.symm.trans h2⟩

#print axioms law3_as_worded_fails
#print axioms law2_not_fiberFeasible
#print axioms law5_sum
#print axioms law5_needs_total
#print axioms one_carrier_spurious
