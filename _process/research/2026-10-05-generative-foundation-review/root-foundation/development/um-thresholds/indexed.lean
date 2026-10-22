/-- Within a band under mutual support, the check at step `cs.length * hi + 1` is exact for condition
`i` ending from a level up to `hi`, the others as in `y` within the band. -/
theorem ends_iff_ending [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat}
    (high : a ≤ hi) (highs : ∀ j, y j ≤ hi) :
    Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔ ending G H (cs.length * hi + 1) y i a = true :=
  (ends_iff rises band covers (setAt_within high highs) i).trans ⟨decide_eq_true, of_decide_eq_true⟩

/-- **The point of no return is exact.** Within a band under mutual support, condition `i` ends from
a level up to `hi`, the others as in `y` within the band, exactly where its level is below its
threshold: the law of exact thresholds (`leading_exact`) for ending. -/
theorem ends_iff_below [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat}
    (high : a ≤ hi) (highs : ∀ j, y j ≤ hi) :
    Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔ a < threshold G H cs hi y i :=
  leading_exact (P := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y i a))
    (d := ending G H (cs.length * hi + 1) y i)
    (fun _ _ _ ends le =>
      ends_of_below rises (fun _ _ b => b i) (setAt_below le fun j => Nat.le_refl (y j)) ends)
    (fun _ high' => ends_iff_ending rises band covers high' highs) a high

/-- **The point of no return does not rise as any other level rises.** Within a band under mutual
support, others' levels at or above `y`'s, within the band, give condition `i` a threshold no
higher: the law of exact thresholds (`leading_falls`), ending with the others higher ending with them
lower. -/
theorem threshold_falls [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y y' : ι → Nat} {i : ι}
    (le : ∀ j, y j ≤ y' j) (highs' : ∀ j, y' j ≤ hi) :
    threshold G H cs hi y' i ≤ threshold G H cs hi y i :=
  have highs : ∀ j, y j ≤ hi := fun j => Nat.le_trans (le j) (highs' j)
  leading_falls (P := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y i a))
    (Q := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y' i a))
    (fun _ high => ends_iff_ending rises band covers high highs)
    (fun _ high => ends_iff_ending rises band covers high highs')
    (fun a _ ends => ends_of_below rises (fun _ _ b => b i) (setAt_below (Nat.le_refl a) le) ends)

