/-! Certificates that must fail (BOUNDARY-FIELD.md §3.2): each line below is an error.
Run with `lean +leanprover/lean4:v4.29.1 certificate-idiom-wrong.lean`. -/

def step (n m : Nat) : Prop := m = n + 1
def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem row (n : Nat) : Clo step n (n + 1) := Or.inr rfl
theorem other (n : Nat) : Clo step n n := Or.inl rfl
-- A different statement.
theorem bad : @row = @other := rfl

universe u
theorem rowU {S : Type u} (s : S) : s = s := rfl
theorem bAtType {S : Type} (s : S) : s = s := rfl
-- The row at full generality against a statement at `Type` only.
theorem badU.{v} : @rowU.{v} = @bAtType := rfl
