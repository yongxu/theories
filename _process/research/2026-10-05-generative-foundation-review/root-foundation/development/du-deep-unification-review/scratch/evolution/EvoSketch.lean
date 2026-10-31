/- Standalone sanity check (imports only Init). Minimal copies of the grammar's definitions
   (Becoming.Grammar / GrammarMap) to check the proposed evolution laws' shapes. -/
namespace Sketch
universe u
abbrev «际» (α : Type u) : Type u := α → α → Prop
def «而» {α : Type u} (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z
def «则» {α : Type u} (R S : «际» α) : Prop := ∀ x y, R x y → S x y
def «合» {α : Type u} (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y
def «一» {α : Type u} : «际» α := fun _ _ => True
def «续» {α : Type u} (R E : «际» α) : «际» α := «合» R E
def «有后» {α : Type u} (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y
def «亡» {α : Type u} (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x
def «闭» {α : Type u} (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y
inductive «尽» {α : Type u} (R L : «际» α) : α → Prop
  | mk {x : α} : (∀ y, «续» R L x y → «尽» R L y) → «尽» R L x
def «延» {α : Type u} (R L : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ ∀ z, S z → ∃ w, S w ∧ «续» R L z w

variable {α : Type u}

/-- The gate: every step of `R` starts in the region `S`. -/
def Gate (R : «际» α) (S : α → Prop) : Prop := «则» R («而» (fun x y => x = y ∧ S x) R)

/-- L1: outside the gate, nothing continues it, under every class. -/
theorem «门则亡» {R E : «际» α} {S : α → Prop} (gate : Gate R S) {x : α} (out : ¬ S x) :
    «亡» R E x :=
  fun ⟨y, r, _⟩ => match gate x y r with
    | ⟨_, ⟨same, s⟩, _⟩ => out (same ▸ s)

/-- And so it ends on every branch. -/
theorem «门则尽» {R E : «际» α} {S : α → Prop} (gate : Gate R S) {x : α} (out : ¬ S x) :
    «尽» R E x :=
  .mk fun y c => absurd ⟨y, c⟩ («门则亡» gate out)

/-- L3: a measure falling along every continuation from a closed region gives ending on every
branch; strong induction on the measure, constructive. -/
theorem «降则尽» {R L : «际» α} (μ : α → Nat) (P : α → Prop) (closed : «闭» («续» R L) P)
    (falls : ∀ x y, P x → «续» R L x y → μ y < μ x) : ∀ x, P x → «尽» R L x := by
  have key : ∀ n, ∀ x, μ x < n → P x → «尽» R L x := by
    intro n
    induction n with
    | zero => intro x h; exact absurd h (Nat.not_lt_zero _)
    | succ n ih =>
      intro x lt hx
      exact .mk fun y c => ih y (Nat.lt_of_lt_of_le (falls x y hx c) (Nat.le_of_lt_succ lt))
        (closed x y hx c)
  exact fun x hx => key (μ x + 1) x (Nat.lt_succ_self _) hx

theorem «延尽不并» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «延» R L x := by
  induction h with
  | mk _ ih =>
    intro ⟨S, hx, hS⟩
    match hS _ hx with
    | ⟨w, hw, c⟩ => exact ih w c ⟨S, hw, hS⟩

/-! L4: selection proper does not decide the region. -/

def excess (a b : Nat) : Nat := a - b

/-- Shift invariance of the pair terms the selection term proper is built from. -/
theorem excess_shift (a b : Nat) : ∀ k, excess (a + k) (b + k) = excess a b
  | 0 => rfl
  | k + 1 => (Nat.succ_sub_succ (a + k) (b + k)).trans (excess_shift a b k)

/-- One unit per generation (carrier `Nat`). In `goes` each has one successor; in `stops`, none.
With one member per generation every pair term is zero in both, at every generation, so the
course of selection terms is the same; the regions differ. -/
def goes : «际» Nat := fun a b => b = a + 1
def stops : «际» Nat := fun _ _ => False

theorem goes_on : «延» goes «一» 0 :=
  ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩⟩
theorem stops_ends : «尽» stops «一» 0 := .mk fun _ c => c.1.elim

theorem shares_do_not_decide :
    (∀ a b : Nat, excess (a + 1) (b + 1) = excess a b) ∧ «延» goes «一» 0 ∧ «尽» stops «一» 0 ∧
      ¬ «尽» goes «一» 0 :=
  ⟨fun a b => excess_shift a b 1, goes_on, stops_ends, fun h => «延尽不并» h goes_on⟩

end Sketch

#print axioms Sketch.«门则尽»
#print axioms Sketch.«降则尽»
#print axioms Sketch.shares_do_not_decide
