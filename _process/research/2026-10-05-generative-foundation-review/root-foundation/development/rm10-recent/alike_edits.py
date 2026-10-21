# RM10, rule 9: runs alike under any law reading states condition by condition; the web's run_alike its case
# (run inside build_tree.py with `rm` and `once` in scope).
rm = once(rm, """/-- Where each giving reads what is left condition by condition, runs from states alike at every
condition stay alike at every condition. -/
theorem run_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i
  | 0 => same
  | n + 1 => step_alike pointwise fun j => congrArg (· - H j) (run_alike pointwise same n j)
""", """/-- **A law of states reads them condition by condition**: states alike at every condition go to states
alike at every condition. -/
def ReadsPointwise (f : (ι → Nat) → (ι → Nat)) : Prop :=
  ∀ x y, (∀ j, x j = y j) → ∀ i, f x i = f y i

/-- Under a law reading states condition by condition, runs from states alike at every condition stay
alike at every condition. -/
theorem run_alike_of {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {x y : ι → Nat}
    (same : ∀ j, x j = y j) : ∀ n i, (Law.run f x).state n i = (Law.run f y).state n i
  | 0 => same
  | n + 1 => reads _ _ (run_alike_of reads same n)

/-- Where each giving reads what is left condition by condition, the web's step reads states so. -/
theorem pointwise_step (pointwise : Pointwise G) : ReadsPointwise (step Drawn.whole G H) :=
  fun _ _ same => step_alike pointwise fun j => congrArg (· - H j) (same j)

/-- Where each giving reads what is left condition by condition, runs from states alike at every
condition stay alike at every condition. -/
theorem run_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i :=
  run_alike_of (pointwise_step pointwise) same
""")
for old, new in (("Indexed.StaysWithin (pairGiving first second) (pairDraw 1 1) 3",
                  "Indexed.StaysWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) 3"),
                 ("Indexed.thresholdWithin (pairGiving first second) (pairDraw 1 1) [true, false] 3 2",
                  "Indexed.thresholdWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) [true, false] 3 2"),
                 ("Indexed.within_below rises", "Indexed.within_below (Indexed.step_keepsBelow rises)"),
                 ("Indexed.ends_iff_below_within rises covers_pair",
                  "Indexed.ends_iff_below_within (Indexed.step_keepsBelow rises) covers_pair")):
    assert rm.count(old) >= 1, old
    rm = rm.replace(old, new)
