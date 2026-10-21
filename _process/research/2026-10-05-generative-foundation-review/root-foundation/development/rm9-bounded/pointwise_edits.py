# RM9, rule 9: the web's alike laws stated for giving that reads what is left condition by condition, mutual support
# its case (run inside build_tree.py with `rm` and `once` in scope).
rm = once(rm, """    (same : ∀ j, e j = e' j) : g e = g e' :=
  Nat.le_antisymm (rises e e' fun j => Nat.le_of_eq (same j))
    (rises e' e fun j => Nat.le_of_eq (same j).symm)

/-- Under mutual support, states whose draws leave alike at every condition step alike. -/
theorem step_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat}
    (same : ∀ j, x j - H j = y j - H j) (i : ι) :
    step Drawn.whole G H x i = step Drawn.whole G H y i :=
  show x i - H i + G i (left Drawn.whole H x) = y i - H i + G i (left Drawn.whole H y) from
    congr (congrArg (· + ·) (same i)) (respects (rises i) same)

/-- Under mutual support, runs from states alike at every condition stay alike at every condition. -/
theorem run_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i
  | 0 => same
  | n + 1 => step_alike rises fun j => congrArg (· - H j) (run_alike rises same n j)

/-- Under mutual support, a condition ends from one of two states alike at every condition exactly
where it ends from the other. -/
theorem ends_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat} (same : ∀ j, x j = y j)
    (i : ι) : Ends Drawn.whole G H (fun w => w i) x ↔ Ends Drawn.whole G H (fun w => w i) y :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike rises same (N + k) i).symm.trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike rises same (N + k) i).trans (gone k)⟩⟩
""", """    (same : ∀ j, e j = e' j) : g e = g e' :=
  Nat.le_antisymm (rises e e' fun j => Nat.le_of_eq (same j))
    (rises e' e fun j => Nat.le_of_eq (same j).symm)

/-- **Each giving reads what is left condition by condition**: what is left alike at every condition
gives alike. -/
def Pointwise (G : ι → (ι → Nat) → Nat) : Prop := ∀ i e e', (∀ j, e j = e' j) → G i e = G i e'

/-- Mutual support reads what is left condition by condition. -/
theorem pointwise_of_rises (rises : ∀ i, Rises Drawn.whole (G i)) : Pointwise G :=
  fun i _ _ same => respects (rises i) same

/-- Where each giving reads what is left condition by condition, states whose draws leave alike at
every condition step alike. -/
theorem step_alike (pointwise : Pointwise G) {x y : ι → Nat}
    (same : ∀ j, x j - H j = y j - H j) (i : ι) :
    step Drawn.whole G H x i = step Drawn.whole G H y i :=
  show x i - H i + G i (left Drawn.whole H x) = y i - H i + G i (left Drawn.whole H y) from
    congr (congrArg (· + ·) (same i)) (pointwise i _ _ same)

/-- Where each giving reads what is left condition by condition, runs from states alike at every
condition stay alike at every condition. -/
theorem run_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i
  | 0 => same
  | n + 1 => step_alike pointwise fun j => congrArg (· - H j) (run_alike pointwise same n j)

/-- Where each giving reads what is left condition by condition, a condition ends from one of two
states alike at every condition exactly where it ends from the other. -/
theorem ends_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j)
    (i : ι) : Ends Drawn.whole G H (fun w => w i) x ↔ Ends Drawn.whole G H (fun w => w i) y :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike pointwise same (N + k) i).symm.trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike pointwise same (N + k) i).trans (gone k)⟩⟩
""")
rm = once(rm, """  | k + 1, i => step_alike rises
""", """  | k + 1, i => step_alike (pointwise_of_rises rises)
""")
rm = once(rm, """Indexed.run_alike (pair_rises rises₁ rises₂) (setAt_pair x y)""",
          """Indexed.run_alike (Indexed.pointwise_of_rises (pair_rises rises₁ rises₂)) (setAt_pair x y)""")
rm = once(rm, """Indexed.ends_alike (pair_rises rises₁ rises₂) (setAt_pair x y)""",
          """Indexed.ends_alike (Indexed.pointwise_of_rises (pair_rises rises₁ rises₂)) (setAt_pair x y)""")
rm = once(rm, """Indexed.run_alike (H := pairDraw H₁ H₂) rises (setAt_pair x y)""",
          """Indexed.run_alike (H := pairDraw H₁ H₂) (Indexed.pointwise_of_rises rises) (setAt_pair x y)""")
