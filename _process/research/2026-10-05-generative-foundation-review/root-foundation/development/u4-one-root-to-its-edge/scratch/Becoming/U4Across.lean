import Becoming.U4Bridge

/-!
# Scratch for U4, lever 1: across a run, and the review's witnesses (not a module of the package)

* **A run of unit lists.** A flow balances exactly where one run of unit lists, one list for each
  condition and time, under one continuation that fixes successors and predecessors, counts it at
  every step (`balances_iff_census_run`). Each time has one list, so the units after a step are the
  units before the next, and continuation composes along the run. The model is built from the
  numbers: each list is an interval of labels, the oldest ceasing first (`census_run`). This is a
  representation of balance across a run, as `Flow.balances_iff_units` is at a step. It derives
  nothing from the unfolding.
* **A pairing without one to one.** One unit splits into two and another merges into one of them,
  nothing arises or ceases, and the census pairing still holds (`pairs_without_one_to_one`). One-to-one
  continuation is sufficient for the pairing, not necessary.
* **Listed once is needed.** A unit listed twice before a step, continuing as one unit after it: no
  split and no merge among the listed units, nothing arises or ceases, and the census balance fails
  (`repeated_unit`).
* **The place reading is the units reading.** `place_iff_units` joins `balancesOn_iff_place` to
  `Flow.balancesOn_iff_units`.
-/

namespace Becoming
namespace U4Scratch

/-! ## Intervals of labels -/

theorem add_one_add (a : Nat) : ∀ b, a + 1 + b = a + b + 1
  | 0 => rfl
  | b + 1 => congrArg (· + 1) (add_one_add a b)

theorem upto_add (s : Nat) : ∀ a b, upto s (a + b) = upto s a ++ upto (s + a) b
  | 0, b => by
    show upto s (0 + b) = upto s b
    rw [Nat.zero_add]
  | a + 1, b => by
    rw [add_one_add a b]
    show s :: upto (s + 1) (a + b) = s :: (upto (s + 1) a ++ upto (s + a + 1) b)
    rw [upto_add (s + 1) a b, add_one_add s a]

theorem beq_false_of_lt {g f : Nat} (lt : g < f) : Nat.beq g f = false := by
  cases h : Nat.beq g f with
  | false => rfl
  | true =>
    cases Nat.eq_of_beq_eq_true h
    exact absurd lt (Nat.lt_irrefl _)

theorem below_split {lo out d g : Nat} (m : g ∈ upto lo out ++ upto (lo + out) d) :
    g < lo + out + d :=
  match ListTests.mem_append_iff.mp m with
  | .inl m' => Nat.lt_of_lt_of_le (mem_upto m').2 (Nat.le_add_right _ d)
  | .inr m' => (mem_upto m').2

theorem above_split {s d into f : Nat} (m : f ∈ upto s d ++ upto (s + d) into) : s ≤ f :=
  match ListTests.mem_append_iff.mp m with
  | .inl m' => (mem_upto m').1
  | .inr m' => Nat.le_trans (Nat.le_add_right s d) (mem_upto m').1

/-- **The census of two intervals.** Units labelled `lo` onward before a step, `out` of them ceasing
first and `d` staying, and `into` more arising after them: the census counts `into` arising and
`out` ceasing. -/
theorem interval_census (lo out d into : Nat) :
    (arising Nat.beq (upto lo (out + d)) (upto (lo + out) (d + into))).length = into ∧
      (ceasing Nat.beq (upto lo (out + d)) (upto (lo + out) (d + into))).length = out := by
  rw [upto_add lo out d, upto_add (lo + out) d into]
  constructor
  · show (keep _ (upto (lo + out) d ++ upto (lo + out + d) into)).length = into
    rw [keep_append, keep_none (upto (lo + out) d) (fun f m => by
        show (!((upto lo out ++ upto (lo + out) d).any fun g => Nat.beq g f)) = false
        rw [any_true_of_mem (p := fun g => Nat.beq g f) (mem_right m) (beq_self f)]; rfl),
      keep_all (upto (lo + out + d) into) (fun f m => by
        show (!((upto lo out ++ upto (lo + out) d).any fun g => Nat.beq g f)) = true
        rw [any_false_of (p := fun g => Nat.beq g f) _
          (fun g mg => beq_false_of_lt (Nat.lt_of_lt_of_le (below_split mg) (mem_upto m).1))]
        rfl)]
    exact length_upto (lo + out + d) into
  · show (keep _ (upto lo out ++ upto (lo + out) d)).length = out
    rw [keep_append, keep_all (upto lo out) (fun g m => by
        show (!((upto (lo + out) d ++ upto (lo + out + d) into).any (Nat.beq g))) = true
        rw [any_false_of (p := Nat.beq g) _
          (fun f mf => beq_false_of_lt (Nat.lt_of_lt_of_le (mem_upto m).2 (above_split mf)))]
        rfl),
      keep_none (upto (lo + out) d) (fun g m => by
        show (!((upto (lo + out) d ++ upto (lo + out + d) into).any (Nat.beq g))) = false
        rw [any_true_of_mem (p := Nat.beq g) (mem_left m) (beq_self g)]; rfl),
      ListTests.append_nil]
    exact length_upto lo out

/-! ## A run of unit lists -/

/-- Staying, ceasing, arising and passing at a step, read off the counts: `n` before, `m` after,
`G` given, `T` taken. -/
def splitOf (n m G T : Nat) : Nat × Nat × Nat × Nat :=
  cond (Nat.ble T n) (n - T, T, G, 0) (0, n, m, T - n)

theorem splitOf_spec (n m G T : Nat) (bal : m + T = n + G) :
    (splitOf n m G T).2.1 + (splitOf n m G T).1 = n ∧
      (splitOf n m G T).1 + (splitOf n m G T).2.2.1 = m ∧
      (splitOf n m G T).2.2.1 + (splitOf n m G T).2.2.2 = G ∧
      (splitOf n m G T).2.1 + (splitOf n m G T).2.2.2 = T := by
  unfold splitOf
  cases h : Nat.ble T n with
  | true =>
    have le := Nat.le_of_ble_eq_true h
    show T + (n - T) = n ∧ n - T + G = m ∧ G + 0 = G ∧ T + 0 = T
    refine ⟨Naturals.add_sub_of_le le, ?_, rfl, rfl⟩
    apply Naturals.add_right_cancel (k := T)
    calc n - T + G + T = n - T + T + G := by
          rw [Nat.add_assoc, Nat.add_comm G T, ← Nat.add_assoc]
      _ = n + G := by rw [Naturals.sub_add_cancel le]
      _ = m + T := bal.symm
  | false =>
    have lt : n < T := match Nat.lt_or_ge n T with
      | .inl lt => lt
      | .inr le => nomatch (Nat.ble_eq_true_of_le le).symm.trans h
    have le : n ≤ T := Nat.le_of_lt lt
    show n + 0 = n ∧ 0 + m = m ∧ m + (T - n) = G ∧ n + (T - n) = T
    refine ⟨rfl, Nat.zero_add m, ?_, add_sub_of_le le⟩
    apply Naturals.add_right_cancel (k := n)
    calc m + (T - n) + n = m + T := by rw [Nat.add_assoc, Naturals.sub_add_cancel le]
      _ = n + G := bal
      _ = G + n := Nat.add_comm n G

theorem step_census {lo n m G T out d into passing : Nat} (h1 : out + d = n) (h2 : d + into = m)
    (h3 : into + passing = G) (h4 : out + passing = T) :
    G = (arising Nat.beq (upto lo n) (upto (lo + out) m)).length + passing ∧
      T = (ceasing Nat.beq (upto lo n) (upto (lo + out) m)).length + passing := by
  cases h1
  cases h2
  have ic := interval_census lo out d into
  rw [ic.1, ic.2]
  exact ⟨h3.symm, h4.symm⟩

/-- The oldest label standing at each time, the oldest units ceasing first. -/
def oldest (n G T : Nat → Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => oldest n G T t + (splitOf (n t) (n (t + 1)) (G t) (T t)).2.1

/-- **A run of unit lists for balanced counts.** Where the counts balance at every step, the
intervals of labels from the oldest standing count them: each time's list is listed once and has the
level's length, and at each step what is given and taken counts the units arising and ceasing, with
as many more passing. -/
theorem census_run (n G T : Nat → Nat) (bal : ∀ t, n (t + 1) + T t = n t + G t) (t : Nat) :
    Distinct (upto (oldest n G T t) (n t)) ∧ (upto (oldest n G T t) (n t)).length = n t ∧
      G t = (arising Nat.beq (upto (oldest n G T t) (n t))
          (upto (oldest n G T (t + 1)) (n (t + 1)))).length
        + (splitOf (n t) (n (t + 1)) (G t) (T t)).2.2.2 ∧
      T t = (ceasing Nat.beq (upto (oldest n G T t) (n t))
          (upto (oldest n G T (t + 1)) (n (t + 1)))).length
        + (splitOf (n t) (n (t + 1)) (G t) (T t)).2.2.2 := by
  refine ⟨distinct_upto _ _, length_upto _ _, ?_⟩
  have s := splitOf_spec (n t) (n (t + 1)) (G t) (T t) (bal t)
  exact step_census (lo := oldest n G T t) s.1 s.2.1 s.2.2.1 s.2.2.2

/-- **Balance across a run is a run of unit lists, both ways.** A flow balances on a web exactly
where, for each condition, one list of units at each time, under one continuation that fixes
successors and predecessors, has the levels as its lengths and what is given and taken as its
arising and ceasing at each step, with as many more passing. The units after a step are the units
before the next. The lists are built from the numbers: a representation, not a derivation. -/
theorem balances_iff_census_run {F C : Type} {L : Flow F C} {W : Web F C} :
    L.Balances W ↔ ∃ (units : C → Nat → List Nat) (k : Nat → Nat → Bool) (passing : C → Nat → Nat),
      «定后» (fun x y => k x y = true) ∧ «定前» (fun x y => k x y = true) ∧
        ∀ t c, Distinct (units c t) ∧ W.level t c = (units c t).length ∧
          L.given t c = (arising k (units c t) (units c (t + 1))).length + passing c t ∧
          L.taken t c = (ceasing k (units c t) (units c (t + 1))).length + passing c t := by
  constructor
  · intro bal
    refine ⟨fun c t => upto (oldest (fun t => W.level t c) (fun t => L.given t c)
        (fun t => L.taken t c) t) (W.level t c), Nat.beq,
      fun c t => (splitOf (W.level t c) (W.level (t + 1) c) (L.given t c) (L.taken t c)).2.2.2,
      «定后之逐点».mpr fun _ _ _ r r' => (Nat.eq_of_beq_eq_true r).symm.trans (Nat.eq_of_beq_eq_true r'),
      «定前之逐点».mpr fun _ _ _ r r' => (Nat.eq_of_beq_eq_true r).trans (Nat.eq_of_beq_eq_true r').symm,
      fun t c => ?_⟩
    have run := census_run (fun t => W.level t c) (fun t => L.given t c) (fun t => L.taken t c)
      (fun t => bal t c) t
    exact ⟨run.1, run.2.1.symm, run.2.2.1, run.2.2.2⟩
  · intro ⟨units, k, passing, fixedAfter, fixedBefore, all⟩
    show ∀ t c, _
    intro t c
    have now := all t c
    have next := all (t + 1) c
    exact balances_at_of_census k (units c t) (units c (t + 1)) now.1 next.1
      (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' r r')
      (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f r r')
      (passing c t) now.2.1 next.2.1 now.2.2.1 now.2.2.2

/-! ## The review's witnesses -/

/-- `0` continues as `2` and as `3`, and `1` continues as `2`. -/
def splitThenMerge (g f : Nat) : Bool :=
  (Nat.beq g 0 && (Nat.beq f 2 || Nat.beq f 3)) || (Nat.beq g 1 && Nat.beq f 2)

/-- **A pairing without one to one.** A unit splits and another merges into one of its
continuations; nothing arises or ceases, and the units before are paired with those after under
continuation, though the continuation fixes neither successors nor predecessors. -/
theorem pairs_without_one_to_one :
    arising splitThenMerge [0, 1] [2, 3] = [] ∧ ceasing splitThenMerge [0, 1] [2, 3] = [] ∧
      «对» (fun x y => splitThenMerge x y = true ∨ x = y) [0, 1] [2, 3] ∧
      ¬ «定后» (fun x y => splitThenMerge x y = true) ∧
      ¬ «定前» (fun x y => splitThenMerge x y = true) :=
  ⟨rfl, rfl, .cons (b₁ := [2]) (b₂ := []) (Or.inl rfl) (.cons (b₁ := []) (b₂ := []) (Or.inl rfl) .nil),
    fun h => absurd («定后之逐点».mp h 0 2 3 rfl rfl) (by decide),
    fun h => absurd («定前之逐点».mp h 0 1 2 rfl rfl) (by decide)⟩

theorem mem_one {x a : Nat} (m : x ∈ [a]) : x = a := by
  cases m with
  | head => rfl
  | tail _ m' => exact nomatch m'

theorem mem_twice {x a : Nat} (m : x ∈ [a, a]) : x = a := by
  cases m with
  | head => rfl
  | tail _ m' => exact mem_one m'

/-- `0` continues as `1`. -/
def zeroToOne (g f : Nat) : Bool := Nat.beq g 0 && Nat.beq f 1

/-- **Listed once is needed.** A unit listed twice before a step and continuing as one unit after
it: among the listed units none continues as two and no two continue as one, nothing arises or
ceases, and the units after with those ceasing are not as many as the units before with those
arising. -/
theorem repeated_unit :
    arising zeroToOne [0, 0] [1] = [] ∧ ceasing zeroToOne [0, 0] [1] = [] ∧
      (∀ g f f', g ∈ [0, 0] → f ∈ [1] → f' ∈ [1] → zeroToOne g f = true → zeroToOne g f' = true →
        f = f') ∧
      (∀ g g' f, g ∈ [0, 0] → g' ∈ [0, 0] → f ∈ [1] → zeroToOne g f = true → zeroToOne g' f = true →
        g = g') ∧
      [1].length + (ceasing zeroToOne [0, 0] [1]).length ≠
        [0, 0].length + (arising zeroToOne [0, 0] [1]).length :=
  ⟨rfl, rfl, fun _ _ _ _ m m' _ _ => (mem_one m).trans (mem_one m').symm,
    fun _ _ _ m m' _ _ _ => (mem_twice m).trans (mem_twice m').symm, by decide⟩

/-! ## The place reading and the units reading -/

/-- **The place reading is the package's units reading.** One pairing under sameness of the place
lists holds exactly where each listed condition's units are matched one to one under the one. -/
theorem place_iff_units {F C : Type} {eq : C → C → Bool} (dec : ∀ x y, x = y ↔ eq x y = true)
    {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} (distinct : Distinct cs) :
    «对» («静» : «际» C) (place (W.level t) cs ++ place (L.given t) cs)
        (place (W.level (t + 1)) cs ++ place (L.taken t) cs) ↔
      ∀ c, c ∈ cs → ∃ before given after taken : List Unit,
        before.length = W.level t c ∧ given.length = L.given t c ∧
          after.length = W.level (t + 1) c ∧ taken.length = L.taken t c ∧
            «对» «一» (before ++ given) (after ++ taken) :=
  (balancesOn_iff_place dec distinct).symm.trans Flow.balancesOn_iff_units

end U4Scratch
end Becoming
