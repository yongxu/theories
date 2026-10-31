-- Scratch check for SJ §4 laws 1-4, 6 and law 3's calibration. Imports only Init.
universe u v w

abbrev «际» (α : Type u) : Type u := α → α → Prop
def «逆» {α : Type u} (R : «际» α) : «际» α := fun x y => R y x
def «承» {α : Type u} (R : «际» α) (P : α → Prop) : α → Prop := fun a => ∀ b, R b a → P b
def «闭» {α : Type u} (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y
def «所闭» {α : Type u} (R : «际» α) : «际» α := fun x y => ∀ P : α → Prop, «闭» R P → P x → P y

def ChoiceOver (O : Type w) (α : Type v) : Prop :=
  ∀ R : O → α → Prop, (∀ o, ∃ x, R o x) → ∃ f : O → α, ∀ o, R o (f o)

section
variable {S : Type u} {A : Type v}

def Licensed (E : S → S → Prop) (G : S → A → Prop) (s : S) (a : A) : Prop := ∀ s', E s s' → G s' a

/-- Licensed is the grammar's «承» along the converse, act by act. -/
theorem licensed_eq_cheng (E : «际» S) (G : S → A → Prop) (s : S) (a : A) :
    Licensed E G s a = «承» («逆» E) (fun s' => G s' a) s := rfl

def GoesAlike (E : S → S → Prop) (J : S → A → Prop) : Prop := ∀ s s' a, E s s' → J s a → J s' a

theorem goesAlike_iff_closed (E : «际» S) (J : S → A → Prop) :
    GoesAlike E J ↔ ∀ a, «闭» E (fun s => J s a) :=
  ⟨fun h a x y hx e => h x y a e hx, fun h s s' a e hs => h a s s' hs e⟩

def Judgement (E : S → S → Prop) (G : S → A → Prop) (J : S → A → Prop) : Prop :=
  (∀ s a, J s a → G s a) ∧ (∀ s, ∃ a, J s a) ∧ GoesAlike E J

-- Law 1, pieces with the hypothesis each needs.
theorem licensed_sub (E : S → S → Prop) (refl : ∀ s, E s s) (G : S → A → Prop) :
    ∀ s a, Licensed E G s a → G s a := fun s _ l => l s (refl s)

theorem licensed_alike (E : S → S → Prop) (trans : ∀ {x y z}, E x y → E y z → E x z)
    (G : S → A → Prop) : GoesAlike E (Licensed E G) :=
  fun _ _ _ e l t' e' => l t' (trans e e')

theorem licensed_largest (E : S → S → Prop) (G : S → A → Prop) (J : S → A → Prop)
    (sub : ∀ s a, J s a → G s a) (alike : GoesAlike E J) : ∀ s a, J s a → Licensed E G s a :=
  fun s a j s' e => sub s' a (alike s s' a e j)

-- Each hypothesis is exact.
theorem refl_of_sub (E : S → S → Prop) (a : A)
    (h : ∀ G : S → A → Prop, ∀ s a, Licensed E G s a → G s a) : ∀ s, E s s :=
  fun s => h (fun x _ => E s x) s a (fun _ e => e)

theorem trans_of_alike (E : S → S → Prop) (a : A)
    (h : ∀ G : S → A → Prop, GoesAlike E (Licensed E G)) : ∀ {x y z}, E x y → E y z → E x z :=
  fun {x y z} exy eyz => h (fun t _ => E x t) x y a exy (fun _ e => e) z eyz

-- Law 2: forward needs nothing.
theorem licensed_of_judgement (E : S → S → Prop) (G : S → A → Prop) (J : S → A → Prop)
    (j : Judgement E G J) : ∀ s, ∃ a, Licensed E G s a :=
  fun s => match j.2.1 s with
  | ⟨a, h⟩ => ⟨a, licensed_largest E G J j.1 j.2.2 s a h⟩

theorem judgement_iff (E : S → S → Prop) (refl : ∀ s, E s s)
    (trans : ∀ {x y z}, E x y → E y z → E x z) (G : S → A → Prop) :
    (∃ J, Judgement E G J) ↔ ∀ s, ∃ a, Licensed E G s a :=
  ⟨fun ⟨J, j⟩ => licensed_of_judgement E G J j,
   fun each => ⟨Licensed E G, licensed_sub E refl G, each, licensed_alike E trans G⟩⟩

-- Law 2 with no hypothesis on E: license through the closure.
theorem judgement_iff_closure (E : «际» S) (G : S → A → Prop) :
    (∃ J, Judgement E G J) ↔ ∀ s, ∃ a, Licensed («所闭» E) G s a :=
  ⟨fun ⟨J, sub, total, alike⟩ s => match total s with
    | ⟨a, h⟩ => ⟨a, fun s' within => sub s' a (within (fun t => J t a)
        (fun x y hx e => alike x y a e hx) h)⟩,
   fun each => ⟨Licensed («所闭» E) G,
     fun s _ l => l s (fun _ _ h => h),
     each,
     fun _ _ _ e l t' within => l t' (fun P closed hs => within P closed (closed _ _ hs e))⟩⟩
end

-- Countermodels for law 2.
namespace NoRefl
def E : Unit → Unit → Prop := fun _ _ => False
def G : Unit → Unit → Prop := fun _ _ => False
theorem licensed_each : ∀ s, ∃ a, Licensed E G s a := fun _ => ⟨(), fun _ f => f.elim⟩
theorem no_judgement : ¬ ∃ J, Judgement E G J :=
  fun ⟨_, sub, total, _⟩ => match total () with | ⟨a, h⟩ => sub () a h
end NoRefl

namespace NoTrans
-- a path 0 - 1 - 2 - 3, reflexive and symmetric, not transitive
abbrev E (x y : Fin 4) : Prop := x = y ∨ x.val + 1 = y.val ∨ y.val + 1 = x.val
abbrev G (x : Fin 4) (a : Bool) : Prop := (x = 0 → a = true) ∧ (x = 3 → a = false)
def w (s : Fin 4) : Bool := decide (s.val < 2)
theorem wGood : ∀ s s' : Fin 4, E s s' → G s' (w s) := by decide
theorem licensed_each : ∀ s, ∃ a, Licensed E G s a := fun s => ⟨w s, fun s' e => wGood s s' e⟩
theorem no_judgement : ¬ ∃ J, Judgement E G J := by
  intro ⟨J, sub, total, alike⟩
  match total 0 with
  | ⟨a, h⟩ =>
    have h1 := alike 0 1 a (Or.inr (Or.inl rfl)) h
    have h2 := alike 1 2 a (Or.inr (Or.inl rfl)) h1
    have h3 := alike 2 3 a (Or.inr (Or.inl rfl)) h2
    have g0 := (sub 0 a h).1 rfl
    have g3 := (sub 3 a h3).2 rfl
    exact Bool.noConfusion (g0.symm.trans g3)
end NoTrans

-- Law 3.
section Rule
variable {S : Type u} {O : Type w} {A : Type v}

def Rule (obs : S → O) (G : S → A → Prop) : Prop := ∃ f : O → A, ∀ s, G s (f (obs s))
def Ker (obs : S → O) : S → S → Prop := fun s s' => obs s = obs s'

/-- With every reading given by some situation, (2) and choice give a rule. -/
theorem rule_of_surjective (choice : ChoiceOver O A) (obs : S → O) (onto : ∀ o, ∃ s, obs s = o)
    (G : S → A → Prop) (each : ∀ s, ∃ a, Licensed (Ker obs) G s a) : Rule obs G :=
  match choice (fun o a => ∀ s, obs s = o → G s a)
      (fun o => match onto o with
        | ⟨s, hs⟩ => match each s with
          | ⟨a, l⟩ => ⟨a, fun s' hs' => l s' (hs.trans hs'.symm)⟩) with
  | ⟨f, chosen⟩ => ⟨f, fun s => chosen (obs s) s rfl⟩
end Rule

/-- The design's law 3 as written fails without surjectivity: no situation, one reading, no act. -/
theorem law3_as_written_fails :
    (∀ s : Empty, ∃ a : Empty, Licensed (Ker (fun _ : Empty => ())) (fun _ _ => True) s a) ∧
    ChoiceOver Unit Empty ∧
    ¬ Rule (fun _ : Empty => ()) (fun (_ : Empty) (_ : Empty) => True) :=
  ⟨(fun s => nomatch s), (fun _ each => match each () with | ⟨x, _⟩ => nomatch x),
   fun ⟨f, _⟩ => nomatch f ()⟩

/-- Without surjectivity, even with an act in hand, the rule from (2) would give independence of
premise: Lean cannot prove that constructively (IP is not intuitionistically valid). -/
theorem rule_gives_ip
    (h : ∀ (S : Type) (obs : S → Unit) (G : S → Bool → Prop),
      (∀ s, ∃ a, Licensed (Ker obs) G s a) → Rule obs G)
    (P : Prop) (Q : Bool → Prop) (h1 : P → ∃ a, Q a) : ∃ a, P → Q a :=
  match h {_p : Unit // P} (fun _ => ()) (fun _ a => Q a)
      (fun s => match h1 s.2 with | ⟨a, q⟩ => ⟨a, fun _ _ => q⟩) with
  | ⟨f, ok⟩ => ⟨f (), fun p => ok ⟨(), p⟩⟩

/-- The calibration, fiber form: over a fixed type of readings and of acts, each reading having a
good act giving a rule, asked of every situation type, map and requirement, is ChoiceOver. The
left-to-right direction is the identity reading: definitional. -/
theorem calibration_fiber {O : Type} {A : Type} :
    (∀ (S : Type) (obs : S → O) (G : S → A → Prop),
        (∀ o, ∃ a, ∀ s, obs s = o → G s a) → Rule obs G) ↔ ChoiceOver O A :=
  ⟨fun h R total => match h O id R (fun o => match total o with
      | ⟨a, r⟩ => ⟨a, fun s e => by subst e; exact r⟩) with
    | ⟨f, ok⟩ => ⟨f, ok⟩,
   fun choice _ obs G feas => match choice (fun o a => ∀ s, obs s = o → G s a) feas with
    | ⟨f, chosen⟩ => ⟨f, fun s => chosen (obs s) s rfl⟩⟩

/-- The calibration, relational form with the readings all given. -/
theorem calibration_surjective {O : Type} {A : Type} :
    (∀ (S : Type) (obs : S → O), (∀ o, ∃ s, obs s = o) → ∀ G : S → A → Prop,
        (∀ s, ∃ a, Licensed (Ker obs) G s a) → Rule obs G) ↔ ChoiceOver O A :=
  ⟨fun h R total => match h O id (fun o => ⟨o, rfl⟩) R (fun s => match total s with
      | ⟨a, r⟩ => ⟨a, fun s' e => by cases e; exact r⟩) with
    | ⟨f, ok⟩ => ⟨f, ok⟩,
   fun choice _ obs onto G each => rule_of_surjective choice obs onto G each⟩

-- Law 4.
theorem finer_licenses {S : Type u} {A : Type v} (E E' : S → S → Prop) (finer : ∀ x y, E' x y → E x y)
    (G : S → A → Prop) : ∀ s a, Licensed E G s a → Licensed E' G s a :=
  fun _ _ l s' e => l s' (finer _ _ e)

theorem identity_licenses {S : Type u} {A : Type v} (G : S → A → Prop) (s : S) (a : A) :
    Licensed (fun x y : S => x = y) G s a ↔ G s a :=
  ⟨fun l => l s rfl, fun g _ e => e ▸ g⟩

-- Law 6: pairs do not suffice.
namespace Pairwise
inductive Point | p | q | r deriving DecidableEq
abbrev good (w x : Point) : Prop := x ≠ w
abbrev E : Point → Point → Prop := fun _ _ => True
theorem pairs : ∀ w₁ w₂, E w₁ w₂ → ∃ x, good w₁ x ∧ good w₂ x := by
  intro w₁ w₂ _; cases w₁ <;> cases w₂ <;> first
    | exact ⟨.p, by decide, by decide⟩ | exact ⟨.q, by decide, by decide⟩ | exact ⟨.r, by decide, by decide⟩
theorem no_judgement : ¬ ∃ J, Judgement E good J := by
  intro ⟨J, sub, total, alike⟩
  match total .p with
  | ⟨x, h⟩ =>
    have hq := alike .p .q x trivial h
    have hr := alike .p .r x trivial h
    cases x
    · exact sub _ _ h rfl
    · exact sub _ _ hq rfl
    · exact sub _ _ hr rfl
end Pairwise

#print axioms judgement_iff
#print axioms judgement_iff_closure
#print axioms calibration_fiber
#print axioms calibration_surjective
#print axioms NoTrans.no_judgement
#print axioms NoTrans.licensed_each
#print axioms Pairwise.pairs
#print axioms Pairwise.no_judgement
#print axioms rule_gives_ip
#print axioms law3_as_written_fails
#print axioms refl_of_sub
#print axioms trans_of_alike
