
/-- The pair from a level, its partner at `y`, ends exactly where the web's state with the first level
set does. -/
theorem ends_set {x y : Nat} :
    Ends Drawn.whole first second 1 1 Prod.fst (x, y) ↔
      Indexed.Ends Drawn.whole (pairGiving first second) (pairDraw 1 1) (fun w => w true)
        (Indexed.setAt (ofPair (0, y)) true x) :=
  (ends_pair (D := Drawn.whole)).trans ((Indexed.ends_alike
    (Indexed.pointwise_of_rises (pair_rises first_rises second_rises)) (setAt_pair x y) true).symm)

/-- **Beyond every band, the point of no return is still exact.** `Relay` keeps no band from three
up: from every level `hi` at least three at both, the first rises above `hi`. Yet the run from two
with the partner at three stays within three, so for the first condition's levels up to two its point
of no return is decided within the bound: three with its partner at two, from every level of which it
ends, and two with its partner at three, from nothing and one it ends and from two it holds. The
threshold falls as the partner rises, beyond any band. -/
theorem threshold_beyond_band :
    (∀ hi, 3 ≤ hi → ¬ Indexed.Band (pairGiving first second) (pairDraw 1 1) hi) ∧
    Indexed.StaysWithin (pairGiving first second) (pairDraw 1 1) 3 (Indexed.setAt (ofPair (0, 3)) true 2) ∧
    Indexed.thresholdWithin (pairGiving first second) (pairDraw 1 1) [true, false] 3 2 (ofPair (0, 2)) true = 3 ∧
    Indexed.thresholdWithin (pairGiving first second) (pairDraw 1 1) [true, false] 3 2 (ofPair (0, 3)) true = 2 :=
  have rises := pair_rises (D := Drawn.whole) first_rises second_rises
  have within : Indexed.StaysWithin (pairGiving first second) (pairDraw 1 1) 3
      (Indexed.setAt (ofPair (0, 3)) true 2) := fun n j =>
    have pairs := pair_run (D := Drawn.whole) first second 1 1 (2, 3) n
    have small : ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).1 ≤ 3 ∧
        ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).2 ≤ 3 :=
      (between n).elim
        (fun ⟨at_, _⟩ => Eq.subst (motive := fun p : Nat × Nat => p.1 ≤ 3 ∧ p.2 ≤ 3) at_.symm
          ⟨Nat.le_succ 2, Nat.le_refl 3⟩)
        (fun ⟨at_, _⟩ => Eq.subst (motive := fun p : Nat × Nat => p.1 ≤ 3 ∧ p.2 ≤ 3) at_.symm
          ⟨Nat.le_refl 3, Nat.le_succ 2⟩)
    Nat.le_trans (Nat.le_of_eq (Indexed.run_alike (Indexed.pointwise_of_rises rises) (setAt_pair 2 3) n j))
      (match j with
        | true => Nat.le_trans (Nat.le_of_eq pairs.1) small.1
        | false => Nat.le_trans (Nat.le_of_eq pairs.2) small.2)
  have within₂ : Indexed.StaysWithin (pairGiving first second) (pairDraw 1 1) 3
      (Indexed.setAt (ofPair (0, 2)) true 2) :=
    Indexed.within_below rises (Indexed.setAt_below (Nat.le_refl 2) fun j =>
      match j with
      | true => Nat.le_refl 0
      | false => Nat.le_succ 2) within
  have endsTwo : Ends Drawn.whole first second 1 1 Prod.fst (2, 2) :=
    ⟨2, fun k => (congrArg Prod.fst ((Law.orbit_add (step Drawn.whole first second 1 1) (2, 2) 2 k).trans
      (first_alone 0 k))).trans (Nat.zero_sub k)⟩
  have endsOne : Ends Drawn.whole first second 1 1 Prod.fst (1, 3) :=
    ⟨1, fun k => congrArg Prod.fst ((Law.orbit_add (step Drawn.whole first second 1 1) (1, 3) 1 k).trans
      (second_alone 2 k))⟩
  have holds : ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 3) := fun ⟨N, gone⟩ =>
    (between (N + 0)).elim
      (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.fst at_).symm.trans (gone 0)))
      (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.fst at_).symm.trans (gone 0)))
  ⟨fun hi three band =>
    have one : 1 ≤ hi := Nat.le_trans (Nat.le_add_left 1 2) three
    have gives : first (hi - 1) (hi - 1) = 2 :=
      if_pos ⟨Naturals.le_sub_of_add_le (Nat.le_trans (Nat.le_succ 2) three),
        Naturals.le_sub_of_add_le three⟩
    have up : hi - 1 + first (hi - 1) (hi - 1) ≤ hi :=
      band (fun _ => hi) (fun _ => Nat.le_refl hi) true
    Nat.not_succ_le_self hi (Nat.le_trans (Nat.le_of_eq
      (((congrArg (· + 1) (Naturals.sub_add_cancel one)).symm.trans
        (Nat.add_assoc (hi - 1) 1 1)).trans (congrArg (hi - 1 + ·) gives.symm))) up),
   within,
   Nat.le_antisymm (leading_le _ _)
    ((Indexed.ends_iff_below_within rises covers_pair within₂ (Nat.le_refl 2)).1 (ends_set.1 endsTwo)),
   Nat.le_antisymm
    ((Nat.lt_or_ge 2 (Indexed.thresholdWithin (pairGiving first second) (pairDraw 1 1) [true, false] 3 2
        (ofPair (0, 3)) true)).elim
      (fun lt => absurd (ends_set.2 ((Indexed.ends_iff_below_within rises covers_pair within
        (Nat.le_refl 2)).2 lt)) holds) id)
    ((Indexed.ends_iff_below_within rises covers_pair within (Nat.le_succ 1)).1 (ends_set.1 endsOne))⟩
