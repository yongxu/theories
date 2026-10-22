/-- **The point of no return is exact beyond a band.** Under a law keeping the order of states, for
finitely many conditions, where the run from condition `i` at `hi`, the others as in `y`, stays within
`B`, condition `i` ends from a level up to `hi` exactly where its level is below `thresholdWithin`:
the law of exact thresholds (`leading_exact`) for the finite check. -/
theorem ends_iff_below_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y : ι → Nat} {i : ι} {a : Nat}
    (within : StaysWithin f B (setAt y i hi)) (high : a ≤ hi) :
    EndsUnder f i (setAt y i a) ↔ a < thresholdWithin f cs B hi y i :=
  leading_exact (P := fun a => EndsUnder f i (setAt y i a)) (d := endingWithin f ((B + 1) ^ cs.length) y i)
    (fun _ _ _ ends le => endsUnder_of_below keeps (setAt_below le fun j => Nat.le_refl (y j)) ends)
    (fun _ high' => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high' fun j => Nat.le_refl (y j)) within)) a high

/-- **Beyond a band, the point of no return does not rise as any other level rises.** Under a law
keeping the order of states, where the run from condition `i` at `hi`, the others as in `y'`, stays
within `B`, others' levels at or below `y'` give condition `i` a threshold no lower than `y'` gives:
the law of exact thresholds (`leading_falls`) for the finite check. -/
theorem threshold_falls_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y y' : ι → Nat} {i : ι} (le : ∀ j, y j ≤ y' j)
    (within' : StaysWithin f B (setAt y' i hi)) :
    thresholdWithin f cs B hi y' i ≤ thresholdWithin f cs B hi y i :=
  leading_falls (P := fun a => EndsUnder f i (setAt y i a)) (Q := fun a => EndsUnder f i (setAt y' i a))
    (fun _ high => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high le) within'))
    (fun _ high => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high fun j => Nat.le_refl (y' j)) within'))
    (fun a _ ends => endsUnder_of_below keeps (setAt_below (Nat.le_refl a) le) ends)

