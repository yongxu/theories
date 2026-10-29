/-! Does Lean's prelude already state `kept_onward` under a name? (independent review, 29 October
2026). `Nat.le_induction` is not in Init at this toolchain (v4.29.1): `#check` gives "Unknown
constant". Only the recursor of `≤` is, which is the induction the old `Exclusion.active_before`
used (`induction le`). Output in `init-induction.out`. -/
#check @Nat.le.rec
