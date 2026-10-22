/-- **Where what it keeps returns less than one for one, a best response leaves its floor.** The strict
reading of `kept_returns`: where every amount above the floor would bring back later less than it
keeps, the best response keeps nothing above the floor. -/
theorem floor_of_less {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) (less : low < r → C r < C low + (r - low)) : r = low :=
  match Nat.lt_or_ge low r with
  | .inl lt => absurd (kept_returns floor le best) (Nat.not_le_of_gt (less lt))
  | .inr ge => Nat.le_antisymm ge floor

/-- **A best response leaves its floor wherever nothing it keeps above the floor returns to it**: the
case of `floor_of_less` in which what it keeps brings back nothing. -/
theorem leaves_floor {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) (same : C r = C low) : r = low :=
  floor_of_less floor le best fun lt =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq same) (Nat.lt_add_of_pos_right (SupportGated.sub_pos_of_lt lt))
