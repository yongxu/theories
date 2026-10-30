def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem law {α : Type} (R : α → α → Prop) {x y : α} (h : R x y) : Clo R x y := Or.inr h
def step (n m : Nat) : Prop := m = n + 1
def reached (n m : Nat) : Prop := Clo step n m
theorem row {n : Nat} : reached n (n + 1) := Or.inr rfl
theorem other (y : ∀ {α : Type} (R : α → α → Prop) {x y : α}, R x y → Clo R x y) :
    ∀ {n : Nat}, reached n n := fun {_} => Or.inl rfl
theorem bad : @row = @other @law := rfl
