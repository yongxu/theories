/-- **Under mutual support the coupled step keeps the order of states.** Where each condition's
giving rises with what is left of each, a state at or below another in both levels stays so after a
step: the web's law for the pair. -/
theorem step_mono {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (H₁ H₂ : V)
    {p q : V × V} (below : D.Below p q) : D.Below (step D g₁ g₂ H₁ H₂ p) (step D g₁ g₂ H₁ H₂ q) :=
  have web := Indexed.step_mono (pair_rises rises₁ rises₂) (pairDraw H₁ H₂) (x := ofPair p) (y := ofPair q)
    fun b => match b with
      | true => below.1
      | false => below.2
  ⟨web true, web false⟩
@@ENDS_OF_BELOW@@
/-- **Below a state from which a condition ends, it ends.** Under mutual support, where a condition
read off the state by a part that keeps the order of states ends from a state, it ends from every
state at or below it in both levels: the web's law for the pair. -/
theorem ends_of_below {g₁ g₂ : V → V → V} {H₁ H₂ : V} {part : V × V → V}
    (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (reads : ∀ p q, D.Below p q → D.le (part p) (part q))
    {p q : V × V} (below : D.Below p q) (ends : Ends D g₁ g₂ H₁ H₂ part q) :
    Ends D g₁ g₂ H₁ H₂ part p :=
  ends_pair.2 (Indexed.ends_of_below (pair_rises rises₁ rises₂)
    (fun _ _ b => reads _ _ ⟨b true, b false⟩) (x := ofPair p) (y := ofPair q)
    (fun b => match b with
      | true => below.1
      | false => below.2)
    (ends_pair.1 ends))
@@DRAINS@@
/-- **A dependent condition drains once its partner has nothing left.** Where the second condition
gives nothing wherever nothing is left of the first, from a state whose first level is within its
draw the second's next level is what its draw leaves of it: the web's law for the pair. -/
theorem drains {g₁ g₂ : V → V → V} {H₁ H₂ : V} (depends : ∀ b, g₂ D.zero b = D.zero) {p : V × V}
    (within : D.le p.1 H₁) : (step D g₁ g₂ H₁ H₂ p).2 = D.sub p.2 H₂ :=
  Indexed.drains (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false) (j := true)
    (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) (x := ofPair p) within
@@ENDS_AFTER@@
/-- **A dependent condition ends after its partner.** In whole numbers, where the second condition
gives nothing wherever nothing is left of the first and the first stays within its draw from step `N`
on, the second falls by its draw at every step from `N`; where that draw is positive it is nothing from
step `N + y` on, `y` its level at `N`: the web's law for the pair. -/
theorem ends_after {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    {s : Nat × Nat} {N : Nat}
    (within : ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).1 ≤ H₁) :
    (∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).2 =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 - H₂ * k) ∧
    (0 < H₂ → ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state
      (N + ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 + k)).2 = 0) :=
  have run := pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s
  have web := Indexed.ends_after (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false) (j := true)
    (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) (s := ofPair s) (N := N)
    fun k => Nat.le_trans (Nat.le_of_eq (run (N + k)).1) (within k)
  ⟨fun k => (run (N + k)).2.symm.trans ((web.1 k).trans (congrArg (· - H₂ * k) (run N).2)),
   fun pos k => (run _).2.symm.trans ((congrArg
      (fun m => (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state m false)
      (congrArg (fun y => N + y + k) (run N).2).symm).trans (web.2 pos k))⟩
@@ENDS_OF_PARTNER@@
/-- **The end of one ends what depends on it.** In whole numbers, where the second condition gives
nothing wherever nothing is left of the first and its draw is positive, wherever the first ends the
second ends: the web's law for the pair. -/
theorem ends_of_partner {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    (pos : 0 < H₂) {s : Nat × Nat} (ends : Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  ends_pair.2 (Indexed.ends_of_partner (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false)
    (j := true) (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) pos
    (ends_pair.1 ends))
@@ENDS_TOGETHER@@
/-- **Under dependence both ways the two end together or not at all.** In whole numbers, where each
condition gives nothing wherever nothing is left of the other and both draws are positive, the first
ends exactly where the second does: the web's dependence cycle for the pair. -/
theorem ends_together {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends₁ : ∀ a, g₁ a 0 = 0)
    (depends₂ : ∀ b, g₂ 0 b = 0) (pos₁ : 0 < H₁) (pos₂ : 0 < H₂) {s : Nat × Nat} :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s ↔ Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  have d₁ : Indexed.DependsOn Drawn.whole (pairGiving g₁ g₂) true false := fun e zero =>
    (congrArg (g₁ (e true)) zero).trans (depends₁ _)
  have d₂ : Indexed.DependsOn Drawn.whole (pairGiving g₁ g₂) false true := fun e zero =>
    (congrArg (fun z => g₂ z (e false)) zero).trans (depends₂ _)
  have web := Indexed.ends_together (H := pairDraw H₁ H₂) (s := ofPair s)
    (fun i _ _ => match i with
      | true => pos₁
      | false => pos₂)
    (.dep d₁ (.refl false)) (.dep d₂ (.refl true))
  ⟨fun e => ends_pair.2 (web.1 (ends_pair.1 e)), fun e => ends_pair.2 (web.2 (ends_pair.1 e))⟩
