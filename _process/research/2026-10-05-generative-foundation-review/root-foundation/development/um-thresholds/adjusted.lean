/-- Within a band, the check at step `3 hi + 3` is exact for a run of a rising adjustment coming to
rest below the draw. -/
theorem rests_iff_falling {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ falling A H hi r x = true :=
  (falls_iff rises band high given).trans ⟨decide_eq_true, of_decide_eq_true⟩

/-- **The threshold is exact.** Where the adjustment rises with what is left and with the recent
giving and keeps a band up to `hi`, the run from a level and a recent giving up to `hi` comes to rest
below the draw exactly where the level is below the threshold for that recent giving: the law of exact
thresholds (`leading_exact`) for coming to rest below the draw. -/
theorem falls_iff_below {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ x < threshold A H hi r :=
  leading_exact (P := fun x => RestsBelow A H (x, r)) (d := falling A H hi r)
    (fun a b high' falls le =>
      falls_of_below (p := (a, r)) (q := (b, r)) rises band ⟨le, Nat.le_refl r⟩ high' given falls)
    (fun _ high' => rests_iff_falling rises band high' given) x high

/-- **The threshold falls as the recent giving rises.** Where the adjustment rises with what is left
and with the recent giving and keeps a band up to `hi`, a larger recent giving up to `hi` has a
threshold no higher: the law of exact thresholds (`leading_falls`), a run resting below the draw with
the larger recent giving resting below it with the smaller. -/
theorem threshold_falls {A : Nat → Nat → Nat} {H hi r r' : Nat} (rises : Rises A)
    (band : Band A H hi) (le : r ≤ r') (given : r' ≤ hi) :
    threshold A H hi r' ≤ threshold A H hi r :=
  leading_falls (P := fun x => RestsBelow A H (x, r)) (Q := fun x => RestsBelow A H (x, r'))
    (fun _ high => rests_iff_falling rises band high (Nat.le_trans le given))
    (fun _ high => rests_iff_falling rises band high given)
    (fun a high falls =>
      falls_of_below (p := (a, r)) (q := (a, r')) rises band ⟨Nat.le_refl a, le⟩ high given falls)

