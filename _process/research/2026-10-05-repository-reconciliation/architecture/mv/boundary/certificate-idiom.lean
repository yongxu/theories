-- A grammar-like law: for every relation, reflexive closure contains the relation.
def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem law {α : Type} (R : α → α → Prop) {x y : α} (h : R x y) : Clo R x y := Or.inr h
-- A model term and a row stated on it.
def step (n m : Nat) : Prop := m = n + 1
def reached (n m : Nat) : Prop := Clo step n m
theorem row {n : Nat} : reached n (n + 1) := Or.inr rfl
-- The bridge: from the law's statement to the row's, using no theorem of the "model".
theorem bridge (y : ∀ {α : Type} (R : α → α → Prop) {x y : α}, R x y → Clo R x y) :
    ∀ {n : Nat}, reached n (n + 1) := fun {n} => y step (rfl : step n (n + 1))
-- The certificate: Lean accepts it only if bridge @law has the row's type.
theorem cert : @row = @bridge @law := rfl
-- A premise-shaped certificate: the row's statement is P.
def P : Prop := ∀ n : Nat, reached n (n + 1)
theorem rowP : ∀ n : Nat, reached n (n + 1) := fun _ => row
theorem certP : P := @rowP
-- A wrong certificate must fail: bridge @law at a different statement.
-- theorem bad : @rowP = @bridge @law := rfl
#print axioms cert
#print axioms certP
