/-! PE2: which matches bring `propext` (no imports; run with Lean 4.29.1 and 4.30.0-rc2). A wildcard over an inductive's constructors compiles to `_sparseCasesOn`, whose else branch receives a proof of `Nat.hasNotBit`, a statement naming `Nat.land`, which is on `propext`; spelling every constructor out does not. -/
inductive Two where | a | b
inductive Three where | a | b | c
inductive Four where | a | b | c | d
inductive Six where | a | b | c | d | e | f
def two : Two → Bool | .a => true | _ => false
def three : Three → Bool | .a => true | _ => false
def four : Four → Bool | .a => true | _ => false
def six : Six → Bool | .a => true | _ => false
def sixFull : Six → Bool | .a => true | .b => false | .c => false | .d => false | .e => false | .f => false
def sixIf (x : Six) : Bool := if x matches .a then true else false
def natOffset : Nat → Bool | 0 => true | _ + 1 => false
def natLit : Nat → Bool | 3 => true | _ => false
#print axioms two
#print axioms three
#print axioms four
#print axioms six
#print axioms sixFull
#print axioms sixIf
#print axioms natOffset
#print axioms natLit
