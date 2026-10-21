namespace Crossing

/-- Giving gated at two: nothing below two, four from two on. Under a draw of three the least level
meeting the draw is two, so the point of no return is five. -/
def giving (z : Nat) : Nat := if z < 2 then 0 else 4

/-- Giving that moves one unit a step toward the regime's, and rests there. -/
def toward (e r : Nat) : Nat :=
  if r < giving e then r + 1 else if giving e < r then r - 1 else r

theorem fromNothing : FromNothing giving := rfl

theorem root : Root giving 3 2 :=
  ⟨Nat.le_succ 3, fun _ lt => Nat.lt_of_le_of_lt (Nat.le_of_eq (if_pos lt)) (Nat.zero_lt_succ 2)⟩

theorem meets_from : ∀ z, 2 ≤ z → 3 ≤ giving z :=
  fun z le => Nat.le_trans (Nat.le_succ 3)
    (Nat.le_of_eq (if_neg (fun lt : z < 2 => Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt le lt))).symm)

/-- Moving one unit toward the regime's giving lies between the recent giving and the regime's. -/
theorem toward_between : Adjusted.Between toward giving :=
  fun e r => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => have up : toward e r = r + 1 := if_pos lt
      Or.inl ⟨Nat.le_trans (Nat.le_succ r) (Nat.le_of_eq up.symm),
        Nat.le_trans (Nat.le_of_eq up) lt⟩)
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt =>
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have one : 1 + giving e ≤ r := Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (giving e))) lt
        Or.inr ⟨Nat.le_trans (Naturals.le_sub_of_add_le one) (Nat.le_of_eq down.symm),
          Nat.le_trans (Nat.le_of_eq down) (Nat.sub_le r 1)⟩)
      (fun le =>
        have same : toward e r = r :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_neg (fun l : giving e < r => Nat.lt_irrefl r (Nat.lt_of_le_of_lt le l)))
        Or.inl ⟨Nat.le_of_eq same.symm, Nat.le_trans (Nat.le_of_eq same) le⟩))

/-- Moving one unit toward the regime's giving rests only there: a positive rate. -/
theorem toward_settles : Adjusted.Settles toward giving :=
  fun e r rest => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => absurd ((if_pos lt : toward e r = r + 1).symm.trans rest) (Naturals.succ_ne_self r))
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt => by
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have pos : 1 ≤ r := Nat.lt_of_le_of_lt (Nat.zero_le _) lt
        have back : r - 1 + 1 = r := Naturals.sub_add_cancel pos
        have same : r - 1 = r := down.symm.trans rest
        exact absurd (back.symm.trans (congrArg (· + 1) same)) (Naturals.succ_ne_self r).symm)
      (fun le => Nat.le_antisymm le ge))

/-- **Recent giving on the other side of the draw crosses the point of no return, both ways.**
Under the gated giving and a draw of three the point of no return is five. The regime's step ends
the condition from four and holds it from five. Giving moving one unit a step toward the regime's
(between the recent giving and the regime's, and resting only there) holds it at or above seven
from the second step on where it starts at four with a recent giving of six, above the draw, and
has it at nothing from the second step on where it starts at five with a recent giving of
nothing. -/
theorem crosses :
    Root giving 3 2 ∧ Adjusted.Between toward giving ∧ Adjusted.Settles toward giving ∧
    (Law.run (step giving 3) 4).state 4 = 0 ∧ (∀ n, 5 ≤ (Law.run (step giving 3) 5).state n) ∧
    (∀ n, 7 ≤ ((Law.run (Adjusted.step toward 3) (4, 6)).state (n + 2)).1) ∧
    (∀ n, ((Law.run (Adjusted.step toward 3) (5, 0)).state (n + 2)).1 = 0) := by
  refine ⟨root, toward_between, toward_settles,
    ends_below root.2 fromNothing (Nat.lt_succ_self 4), fun n => ?_, fun n => ?_, fun n => ?_⟩
  · exact Nat.le_trans (Adjusted.holds_from (A := fun e _ => giving e) (r := 3) meets_from
      (Adjusted.regime_staysMet giving 3) (Nat.le_refl 5) (Nat.le_refl 3) n).1
      (Nat.le_of_eq (Adjusted.orbit_regime giving 3 (5, 3) n))
  · have two : Law.orbit (Adjusted.step toward 3) (4, 6) 2 = (7, 4) := rfl
    show 7 ≤ (Law.orbit (Adjusted.step toward 3) (4, 6) (n + 2)).1
    rw [Nat.add_comm n 2, Law.orbit_add, two]
    exact (Adjusted.holds_from (x := 7) (r := 4) meets_from (toward_between.staysMet 3)
      (Nat.le_succ_of_le (Nat.le_succ 5)) (Nat.le_succ 3) n).1
  · have two : Law.orbit (Adjusted.step toward 3) (5, 0) 2 = (0, 0) := rfl
    show (Law.orbit (Adjusted.step toward 3) (5, 0) (n + 2)).1 = 0
    rw [Nat.add_comm n 2, Law.orbit_add, two, ← Nat.one_mul n,
      Law.orbit_mul (next := Adjusted.step toward 3) (s := (0, 0)) (p := 1) rfl n]

/-- **Moving wherever it differs from the regime's cannot be dropped.** The frozen rest lies between
the recent giving and the regime's, yet from four with a recent giving at the draw of three its run
stays at four at every step, where the regime's step ends the condition from four. -/
theorem frozen_stays :
    Adjusted.Between (fun _ r => r) giving ∧
    (∀ n, (Law.run (Adjusted.step (fun _ r => r) 3) (4, 3)).state n = (4, 3)) ∧
    (Law.run (step giving 3) 4).state 4 = 0 :=
  ⟨Adjusted.frozen_between giving,
   fun n => (congrArg (Law.orbit (Adjusted.step (fun _ r => r) 3) (4, 3)) (Nat.one_mul n)).symm.trans
     (Law.orbit_mul (next := Adjusted.step (fun _ r => r) 3) (s := (4, 3)) (p := 1)
       (Adjusted.frozen_rests (Nat.le_succ 3)) n),
   ends_below root.2 fromNothing (Nat.lt_succ_self 4)⟩

end Crossing
