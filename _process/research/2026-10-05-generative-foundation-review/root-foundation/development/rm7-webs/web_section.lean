/-! ### A web of coupled conditions

Any number of conditions, indexed by any type `ι`: condition `i` stands under its draw `H i`, taken
first, as much as there is, and gives `G i` of what the draws leave of every condition. The laws of
order, ending and dependence are stated here once; the pair is the web indexed by `Bool`
(`Coupled.pair_run`), and its laws below are read off these. -/

namespace Indexed

variable {ι : Type}
variable (D)

/-- What the draws `H` leave of each level. -/
def left (H : ι → V) (x : ι → V) : ι → V := fun i => D.sub (x i) (H i)

/-- **One step of a web of coupled conditions.** Each draw takes first, as much as there is; each
condition's next level is what is left of it with what it gives, `G i` of what is left of all. -/
def step (G : ι → (ι → V) → V) (H : ι → V) (x : ι → V) : ι → V :=
  fun i => D.add (D.sub (x i) (H i)) (G i (left D H x))

/-- One state at or below another, condition by condition. -/
def Below (x y : ι → V) : Prop := ∀ i, D.le (x i) (y i)

/-- A condition's giving rises with what is left of each condition. -/
def Rises (g : (ι → V) → V) : Prop := ∀ e e', Below D e e' → D.le (g e) (g e')

/-- **A level ends**: from some step on, the level `part` reads off the state is nothing. -/
def Ends (G : ι → (ι → V) → V) (H : ι → V) (part : (ι → V) → V) (s : ι → V) : Prop :=
  ∃ N, ∀ k, part ((Law.run (step D G H) s).state (N + k)) = D.zero

/-- **Dependence**: condition `i` gives nothing wherever nothing is left of condition `j`. -/
def DependsOn (G : ι → (ι → V) → V) (i j : ι) : Prop := ∀ e : ι → V, e j = D.zero → G i e = D.zero

/-- **A chain of dependence**: `i` is `k`, or depends on a condition that is downstream of `k`. -/
inductive Downstream (G : ι → (ι → V) → V) : ι → ι → Prop
  | refl (i : ι) : Downstream G i i
  | dep {i j k : ι} : DependsOn D G i j → Downstream G j k → Downstream G i k

variable {D}

/-- **Under mutual support the step of a web keeps the order of states.** Where every condition's
giving rises with what is left of each, a state at or below another, condition by condition, stays so
after a step. -/
theorem step_mono {G : ι → (ι → V) → V} (rises : ∀ i, Rises D (G i)) (H : ι → V) {x y : ι → V}
    (below : Below D x y) : Below D (step D G H x) (step D G H y) := fun i =>
  have lefts : Below D (left D H x) (left D H y) := fun j => Drawn.sub_mono (H j) (below j)
  D.le_trans (D.add_le_add_right _ (lefts i)) (Amounts.add_le_add_left _ (rises i _ _ lefts))

/-- Under mutual support, runs of a web from ordered states stay ordered at every step. -/
theorem run_below {G : ι → (ι → V) → V} (rises : ∀ i, Rises D (G i)) (H : ι → V) {x y : ι → V}
    (below : Below D x y) :
    ∀ n, Below D ((Law.run (step D G H) x).state n) ((Law.run (step D G H) y).state n) :=
  Lasting.orbit_mono (rel := Below D) (fun _ _ b => step_mono rises H b) below

/-- **Raising any level never ends what held.** Under mutual support, where a level read off the
state by a part that keeps the order ends from a state, it ends from every state at or below it,
condition by condition. -/
theorem ends_of_below {G : ι → (ι → V) → V} {H : ι → V} {part : (ι → V) → V}
    (rises : ∀ i, Rises D (G i)) (reads : ∀ x y, Below D x y → D.le (part x) (part y)) {x y : ι → V}
    (below : Below D x y) (ends : Ends D G H part y) : Ends D G H part x :=
  have ⟨N, gone⟩ := ends
  ⟨N, fun k => D.antisymm (D.le_trans (reads _ _ (run_below rises H below (N + k)))
    (Amounts.le_of_eq (gone k))) (D.zero_le _)⟩

/-- **A dependent condition drains once its partner has nothing left.** Where `i` gives nothing
wherever nothing is left of `j`, from a state whose level of `j` is within its draw, `i`'s next level
is what its draw leaves of it. -/
theorem drains {G : ι → (ι → V) → V} {H : ι → V} {i j : ι} (depends : DependsOn D G i j) {x : ι → V}
    (within : D.le (x j) (H j)) : step D G H x i = D.sub (x i) (H i) := by
  show D.add (D.sub (x i) (H i)) (G i (left D H x)) = D.sub (x i) (H i)
  rw [depends (left D H x) (D.sub_zero within : D.sub (x j) (H j) = D.zero)]
  exact Amounts.add_zero _

/-- **A dependent condition ends after its partner.** In whole numbers, where `i` gives nothing
wherever nothing is left of `j` and `j` stays within its draw from step `N` on, `i` falls by its draw
at every step from `N`; where that draw is positive it is nothing from step `N + y` on, `y` its level
at `N`. -/
theorem ends_after {G : ι → (ι → Nat) → Nat} {H : ι → Nat} {i j : ι} (depends : DependsOn Drawn.whole G i j)
    {s : ι → Nat} {N : Nat} (within : ∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) j ≤ H j) :
    (∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i - H i * k) ∧
    (0 < H i → ∀ k, (Law.run (step Drawn.whole G H) s).state
      (N + (Law.run (step Drawn.whole G H) s).state N i + k) i = 0) :=
  have falls : ∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i - H i * k := fun k => by
    induction k with
    | zero => exact (congrArg ((Law.run (step Drawn.whole G H) s).state N i - ·) (Nat.mul_zero (H i))).symm
    | succ k ih =>
      exact (drains (D := Drawn.whole) (H := H) depends (within k)).trans
        ((congrArg (· - H i) ih).trans (Naturals.sub_sub _ _ _))
  ⟨falls, fun pos k =>
    (congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i) (Nat.add_assoc N _ k)).trans
    ((falls _).trans (Becoming.sub_eq_zero_of_le (Nat.le_trans (Nat.le_add_right _ k)
      (Nat.le_mul_of_pos_left _ pos))))⟩

/-- **The end of one ends what depends on it.** In whole numbers, where `i` gives nothing wherever
nothing is left of `j` and `i`'s draw is positive, wherever `j` ends `i` ends. -/
theorem ends_of_partner {G : ι → (ι → Nat) → Nat} {H : ι → Nat} {i j : ι}
    (depends : DependsOn Drawn.whole G i j) (pos : 0 < H i) {s : ι → Nat}
    (ends : Ends Drawn.whole G H (fun w => w j) s) : Ends Drawn.whole G H (fun w => w i) s :=
  have ⟨N, gone⟩ := ends
  ⟨_, (ends_after depends (N := N) fun k => Nat.le_trans (Nat.le_of_eq (gone k)) (Nat.zero_le (H j))).2 pos⟩

/-- **The cascade of ends.** In whole numbers, where every condition that depends on another has a
positive draw, wherever a condition ends every condition downstream of it, through any chain of
dependence, ends. -/
theorem ends_downstream {G : ι → (ι → Nat) → Nat} {H : ι → Nat}
    (pos : ∀ i j, DependsOn Drawn.whole G i j → 0 < H i) {s : ι → Nat} :
    ∀ {i k : ι}, Downstream Drawn.whole G i k → Ends Drawn.whole G H (fun w => w k) s →
      Ends Drawn.whole G H (fun w => w i) s
  | _, _, .refl _, ends => ends
  | _, _, .dep d chain, ends => ends_of_partner d (pos _ _ d) (ends_downstream pos chain ends)

/-- **A dependence cycle ends together.** In whole numbers, where every condition that depends on
another has a positive draw, two conditions each downstream of the other end together or not at all. -/
theorem ends_together {G : ι → (ι → Nat) → Nat} {H : ι → Nat}
    (pos : ∀ i j, DependsOn Drawn.whole G i j → 0 < H i) {s : ι → Nat} {i k : ι}
    (there : Downstream Drawn.whole G i k) (back : Downstream Drawn.whole G k i) :
    Ends Drawn.whole G H (fun w => w i) s ↔ Ends Drawn.whole G H (fun w => w k) s :=
  ⟨ends_downstream pos back, ends_downstream pos there⟩

namespace Chain

/-- Three conditions in a chain: the first gives nothing; the second gives one where at least one is
left of the first; the third gives one where at least one is left of the second; every other index
gives nothing. -/
def giving : Nat → (Nat → Nat) → Nat
  | 1, e => if 1 ≤ e 0 then 1 else 0
  | 2, e => if 1 ≤ e 1 then 1 else 0
  | _, _ => 0

/-- Each of the three starts at two, every other index at nothing. -/
def start (i : Nat) : Nat := if i ≤ 2 then 2 else 0

/-- Under any draws taking one from the first, the first falls by one at every step. -/
theorem first_falls (H : Nat → Nat) (one : H 0 = 1) :
    ∀ n, (Law.run (step Drawn.whole giving H) start).state n 0 = 2 - n
  | 0 => rfl
  | n + 1 => by
    show (Law.run (step Drawn.whole giving H) start).state n 0 - H 0 + 0 = 2 - (n + 1)
    rw [first_falls H one n, one]
    rfl

/-- **The cascade reaches past direct dependence.** Under draws of one, the third condition depends on
the second and the second on the first, but the third does not depend on the first; the first ends,
and so does the third. -/
theorem cascades :
    DependsOn Drawn.whole giving 2 1 ∧ DependsOn Drawn.whole giving 1 0 ∧
    ¬ DependsOn Drawn.whole giving 2 0 ∧
    Ends Drawn.whole giving (fun _ => 1) (fun w => w 0) start ∧
    Ends Drawn.whole giving (fun _ => 1) (fun w => w 2) start :=
  have d21 : DependsOn Drawn.whole giving 2 1 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have d10 : DependsOn Drawn.whole giving 1 0 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have first : Ends Drawn.whole giving (fun _ => 1) (fun w => w 0) start :=
    ⟨2, fun k => (first_falls _ rfl (2 + k)).trans (Becoming.sub_eq_zero_of_le (Nat.le_add_right 2 k))⟩
  ⟨d21, d10, fun d => absurd (d (fun i => if i = 1 then 1 else 0) rfl) (by decide), first,
   ends_downstream (fun _ _ _ => Nat.zero_lt_one) (.dep d21 (.dep d10 (.refl 0))) first⟩

/-- **A draw of nothing on the chain stops the cascade.** With no draw on the second condition, the
first still ends, and the third depends on the second and the second on the first, yet the third holds
at two at every step: the second never drains. -/
theorem stopped :
    Ends Drawn.whole giving (fun i => if i = 1 then 0 else 1) (fun w => w 0) start ∧
    Downstream Drawn.whole giving 2 0 ∧
    ∀ n, (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 = 2 := by
  have d21 : DependsOn Drawn.whole giving 2 1 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have d10 : DependsOn Drawn.whole giving 1 0 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have holds : ∀ n, 2 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 ∧
      (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 = 2 := by
    intro n
    induction n with
    | zero => exact ⟨Nat.le_refl 2, rfl⟩
    | succ n ih =>
      have up : 1 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 - 0 :=
        Nat.le_trans (Nat.le_succ 1) ih.1
      refine ⟨Nat.le_trans ih.1 (Nat.le_add_right _ _), ?_⟩
      show (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 - 1 +
          (if 1 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 - 0
            then 1 else 0) = 2
      rw [ih.2, if_pos up]
  exact ⟨⟨2, fun k => (first_falls _ rfl (2 + k)).trans (Becoming.sub_eq_zero_of_le (Nat.le_add_right 2 k))⟩,
    .dep d21 (.dep d10 (.refl 0)), fun n => (holds n).2⟩

end Chain

end Indexed

/-- The pair as a web indexed by `Bool`: `true` the first condition, `false` the second. -/
def pairGiving (g₁ g₂ : V → V → V) : Bool → (Bool → V) → V :=
  fun b e => cond b (g₁ (e true) (e false)) (g₂ (e true) (e false))

/-- The pair's draws as a web's. -/
def pairDraw (H₁ H₂ : V) : Bool → V := fun b => cond b H₁ H₂

/-- A pair of levels as a web's state. -/
def ofPair (p : V × V) : Bool → V := fun b => cond b p.1 p.2

/-- **The pair is the web indexed by `Bool`.** At every step the web's run from a pair of levels has
the pair's run's levels. -/
theorem pair_run (g₁ g₂ : V → V → V) (H₁ H₂ : V) (s : V × V) :
    ∀ n, (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true =
        ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).1 ∧
      (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false =
        ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).2
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    have ih := pair_run g₁ g₂ H₁ H₂ s n
    ⟨by
      show D.add (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
          (g₁ (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
            (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)) = _
      rw [ih.1, ih.2]; rfl,
     by
      show D.add (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)
          (g₂ (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
            (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)) = _
      rw [ih.1, ih.2]; rfl⟩

/-- A pair's level ends exactly where, the pair read as a web, it does. -/
theorem ends_pair {g₁ g₂ : V → V → V} {H₁ H₂ : V} {part : V × V → V} {s : V × V} :
    Ends D g₁ g₂ H₁ H₂ part s ↔
      Indexed.Ends D (pairGiving g₁ g₂) (pairDraw H₁ H₂) (fun w => part (w true, w false)) (ofPair s) :=
  have same : ∀ n, part ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true,
      (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) =
      part ((Law.run (step D g₁ g₂ H₁ H₂) s).state n) := fun n =>
    congrArg part (congr (congrArg Prod.mk (pair_run g₁ g₂ H₁ H₂ s n).1) (pair_run g₁ g₂ H₁ H₂ s n).2)
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (same (N + k)).trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (same (N + k)).symm.trans (gone k)⟩⟩

/-- Under mutual support of the pair, the giving of the pair read as a web rises. -/
theorem pair_rises {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) :
    ∀ b, Indexed.Rises D (pairGiving g₁ g₂ b)
  | true => fun _ _ le => rises₁ _ _ _ _ (le true) (le false)
  | false => fun _ _ le => rises₂ _ _ _ _ (le true) (le false)
