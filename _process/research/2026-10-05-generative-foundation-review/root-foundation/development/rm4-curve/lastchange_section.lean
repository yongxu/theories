/-- A run still from step `T` stays at its configuration at `T`. -/
theorem still_stays {r : Run P} {T : Nat} (still : StillFrom r T) : ∀ k, r.state (T + k) = r.state T
  | 0 => rfl
  | k + 1 => (still k).trans (still_stays still k)

/-- A run still from two steps is at one configuration at both: a run has at most one rest. -/
theorem still_same {r : Run P} {T T' : Nat} (still : StillFrom r T) (still' : StillFrom r T') :
    r.state T = r.state T' :=
  (still_stays still T').symm.trans
    ((congrArg r.state (Nat.add_comm T T')).trans (still_stays still' T))
