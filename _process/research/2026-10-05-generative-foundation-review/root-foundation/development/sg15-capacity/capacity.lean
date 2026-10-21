
/-! ### Capacities that limit a draw

A capacity limits what a drawer can take at a step: the drawer leaves at least a floor, `z - c` of `z`
for a capacity `c`. Perfect within capacities, each draws to capacity at the last step, and a drawer
draws to capacity wherever what the other draws after does not depend on what it leaves. With no
limit, perfect within capacities is SG14's perfect, and both draw everything; a limit on the other's
draw can make restraint the best response (`Holding.doubling_capacity`). -/

/-- **A mutual best response within capacities, at a step.** With `j` steps after step `t`: the second
leaves at least `low₂ t a` of `a`, and of whatever the first leaves it leaves what draws it the most over
the rest among what it may leave; the first leaves at least `low₁ t z` of `z`, and from every level it
leaves what draws it the most among what it may leave, the second responding by its rule. -/
def BestWithin (G : Nat → Nat → Nat) (low₁ low₂ : Nat → Nat → Nat) (first second : Nat → Nat → Nat)
    (j t : Nat) : Prop :=
  (∀ a b, low₂ t a ≤ b → b ≤ a → a - b + secondDrawn G first second j (t + 1) (G t b) ≤
      a - second t a + secondDrawn G first second j (t + 1) (G t (second t a))) ∧
  ∀ z a, low₁ t z ≤ a → a ≤ z → z - a + firstDrawn G first second j (t + 1) (G t (second t a)) ≤
      firstDrawn G first second (j + 1) t z

/-- **Perfect within capacities over a horizon.** Each leaves at least its floor and at most what it is
given, and over `N` steps the two are at a mutual best response within the capacities at every step,
from every level. -/
def PerfectWithin (G : Nat → Nat → Nat) (low₁ low₂ : Nat → Nat → Nat) (first second : Nat → Nat → Nat)
    (N : Nat) : Prop :=
  (∀ t z, low₁ t z ≤ first t z ∧ first t z ≤ z) ∧ (∀ t a, low₂ t a ≤ second t a ∧ second t a ≤ a) ∧
    ∀ t j, t + j + 1 = N → BestWithin G low₁ low₂ first second j t

/-- **With no limit, perfect within capacities is perfect.** Where both floors are nothing, a profile is
perfect within the capacities exactly where it is perfect, so every such profile draws everything
(`perfect_ends`). -/
theorem within_zero_iff {N : Nat} :
    PerfectWithin G (fun _ _ => 0) (fun _ _ => 0) first second N ↔ Perfect G first second N :=
  ⟨fun ⟨l₁, l₂, best⟩ => ⟨fun t z => (l₁ t z).2, fun t a => (l₂ t a).2, fun t j at_ =>
      ⟨fun a b le => (best t j at_).1 a b (Nat.zero_le b) le,
       fun z a le => (best t j at_).2 z a (Nat.zero_le a) le⟩⟩,
   fun ⟨l₁, l₂, best⟩ => ⟨fun t z => ⟨Nat.zero_le _, l₁ t z⟩, fun t a => ⟨Nat.zero_le _, l₂ t a⟩,
     fun t j at_ => ⟨fun a b _ le => (best t j at_).1 a b le, fun z a _ le => (best t j at_).2 z a le⟩⟩⟩

/-- **The second draws to capacity where it draws nothing after.** At a mutual best response within
capacities, where the second draws nothing over the steps after `t` from any level, it leaves exactly
its floor at `t`, from every level. -/
theorem second_at_floor {low₁ low₂ : Nat → Nat → Nat}
    (leaves₂ : ∀ t a, low₂ t a ≤ second t a ∧ second t a ≤ a) {j t : Nat}
    (none : ∀ w, secondDrawn G first second j (t + 1) w = 0)
    (best : BestWithin G low₁ low₂ first second j t) : ∀ a, second t a = low₂ t a := fun a =>
  have pick := best.1 a (low₂ t a) (Nat.le_refl _) (Nat.le_trans (leaves₂ t a).1 (leaves₂ t a).2)
  have ge : a - low₂ t a ≤ a - second t a := by
    rw [none, none, Nat.add_zero, Nat.add_zero] at pick
    exact pick
  eq_of_sub_le_sub (leaves₂ t a).1 (leaves₂ t a).2 ge

/-- **The first draws to capacity where what it draws after does not depend on what it leaves.** At a
mutual best response within capacities, where the first draws the same over the steps after `t`
whatever it leaves at `t`, the second responding by its rule, it leaves exactly its floor at `t`, from
every level. -/
theorem first_at_floor {low₁ low₂ : Nat → Nat → Nat}
    (leaves₁ : ∀ t z, low₁ t z ≤ first t z ∧ first t z ≤ z) {j t c : Nat}
    (same : ∀ a, firstDrawn G first second j (t + 1) (G t (second t a)) = c)
    (best : BestWithin G low₁ low₂ first second j t) : ∀ z, first t z = low₁ t z := fun z =>
  have pick := best.2 z (low₁ t z) (Nat.le_refl _) (Nat.le_trans (leaves₁ t z).1 (leaves₁ t z).2)
  have whole : firstDrawn G first second (j + 1) t z = z - first t z + c :=
    congrArg (z - first t z + ·) (same (first t z))
  eq_of_sub_le_sub (leaves₁ t z).1 (leaves₁ t z).2 (Naturals.le_of_add_le_add_right
    (Nat.le_trans (Nat.le_of_eq (congrArg (z - low₁ t z + ·) (same (low₁ t z))).symm)
      (Nat.le_trans pick (Nat.le_of_eq whole))))

/-- **At the last step both draw to capacity.** Along every profile perfect within capacities over `N`
steps, at the step before the horizon each leaves exactly its floor, from every level. -/
theorem last_at_floor {low₁ low₂ : Nat → Nat → Nat} {N t : Nat}
    (perfect : PerfectWithin G low₁ low₂ first second N) (at_ : t + 1 = N) :
    (∀ z, first t z = low₁ t z) ∧ ∀ a, second t a = low₂ t a :=
  ⟨first_at_floor perfect.1 (c := 0) (fun _ => rfl) (perfect.2.2 t 0 at_),
   second_at_floor perfect.2.1 (fun _ => rfl) (perfect.2.2 t 0 at_)⟩
