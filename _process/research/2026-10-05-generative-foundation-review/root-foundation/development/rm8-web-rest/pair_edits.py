# Executed by build_tree.py on `rm`: the pair's rest and points of no return derived from the web's (rule 9), the
# pair-only helpers they superseded removed.
def cut(text, start, end):
    i = text.index(start)
    assert text.count(start) == 1, start[:60]
    j = text.index(end, i)
    return text[:i] + text[j:]


# within_draw (pair): from its docstring to left_le's docstring.
rm = cut(rm, '''/-- **In a band, mutual support gives within each draw.** Where each condition's giving rises with what
is left of each and the coupled step keeps a band up to `hi`, at every state in the band each
condition gives at most its draw. -/
theorem within_draw {g₁ g₂ : V → V → V}''', '''/-- Where a condition gives within its draw, what the draw leaves of it does not rise over a step. -/''')
# run_within, left_falls, still_of_left (pair): to the web section.
rm = cut(rm, '''/-- A run from a state within a band stays within it. -/
theorem run_within {g₁ g₂ : V → V → V}''', '''
/-! ### Coupled webs in whole numbers: rest and points of no return''')
# step_of_left (pair).
rm = cut(rm, '''/-- The coupled step reads a state only through what the draws leave of it. -/''',
         '''/-- **Under mutual support the coupled step keeps the order of states.** Where each condition's''')
# The pair's laws in whole numbers, derived from the web's.
start = '''/-- Within a band under mutual support, the run from a state is still from some step at most one more
than what the draws leave of both, added. -/'''
end = '''/-- **A dependent condition ends after its partner.** In whole numbers, where the second condition'''
i = rm.index(start); j = rm.index(end, i)
PAIR = '''/-- Each of the two conditions is listed. -/
theorem covers_pair : ∀ b : Bool, b ∈ [true, false]
  | true => .head _
  | false => .tail _ (.head _)

/-- The two conditions counted, times `hi`, are `hi` twice. -/
theorem pair_count (hi : Nat) : [true, false].length * hi = hi + hi :=
  (Nat.succ_mul 1 hi).trans (congrArg (· + hi) (Nat.one_mul hi))

/-- The pair's band is the band of the pair read as a web. -/
theorem band_web {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) :
    Indexed.Band (pairGiving g₁ g₂) (pairDraw H₁ H₂) hi := fun w high b =>
  match b with
  | true => (band (w true) (w false) (high true) (high false)).1
  | false => (band (w true) (w false) (high true) (high false)).2

/-- Both levels of a pair within a band, read as a web's. -/
theorem pair_within {s : Nat × Nat} {hi : Nat} (high : s.1 ≤ hi) (high' : s.2 ≤ hi) :
    ∀ b, ofPair s b ≤ hi
  | true => high
  | false => high'

/-- **A pair is still where its web is.** Where the run of the pair read as a web is still at both
conditions from step `N`, the pair's run is still from `N`. -/
theorem pair_still {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s : Nat × Nat} {N : Nat}
    (still : ∀ k b, (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
        (ofPair s)).state (N + k) b =
      (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state N b) :
    LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s) N := fun k =>
  Prod.ext
    ((pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k + 1)).1.symm.trans ((still (k + 1) true).trans
      ((still k true).symm.trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k)).1)))
    ((pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k + 1)).2.symm.trans ((still (k + 1) false).trans
      ((still k false).symm.trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k)).2)))

/-- Within a band under mutual support, the run from a state is still from some step at most one more
than what the draws leave of both, added: the web's law for the pair. -/
theorem rests_by {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) :
    ∀ (d : Nat) (s : Nat × Nat), s.1 ≤ hi → s.2 ≤ hi → (s.1 - H₁) + (s.2 - H₂) ≤ d →
      ∃ N, N ≤ d + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s) N :=
  fun d s high high' fuel =>
    match Indexed.rests_by (pair_rises rises₁ rises₂) (band_web band) covers_pair d (ofPair s)
        (pair_within high high') fuel with
    | ⟨N, le, still⟩ => ⟨N, le, pair_still still⟩

/-- **Under mutual support within a band, a run comes to rest.** In whole numbers, where each
condition's giving rises with what is left of each and the coupled step keeps a band up to `hi`, the run
from a state in the band is still from some step at most `2 hi + 1`. -/
theorem comes_to_rest {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) {x y : Nat}
    (high : x ≤ hi) (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N :=
  rests_by rises₁ rises₂ band (hi + hi) (x, y) high high'
    (Nat.add_le_add (Nat.le_trans (Nat.sub_le x H₁) high) (Nat.le_trans (Nat.sub_le y H₂) high'))

/-- The first condition of the web read off a pair at step `2 hi + 1` is the pair's. -/
theorem pair_at {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (s : Nat × Nat) :
    (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state
        ([true, false].length * hi + 1) true =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (hi + hi + 1)).1 :=
  (congrArg (fun n => (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
      (ofPair s)).state (n + 1) true) (pair_count hi)).trans
    (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (hi + hi + 1)).1

/-- Within a band under mutual support, whether the first condition ends is decided at step
`2 hi + 1`: the web's law for the pair. -/
theorem ends_iff {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0 :=
  (ends_pair (D := Drawn.whole)).trans ((Indexed.ends_iff (pair_rises rises₁ rises₂) (band_web band)
    covers_pair (pair_within (s := (x, y)) high high') true).trans
    ⟨fun zero => (pair_at (x, y)).symm.trans zero, fun zero => (pair_at (x, y)).trans zero⟩)

/-- Whether the first condition, from level `x` with its partner at `y`, is nothing at step `2 hi + 1`. -/
def ending (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y x : Nat) : Bool :=
  decide (((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0)

/-- **The first condition's point of no return, with its partner at `y`.** The least level up to
`hi + 1` from which the first condition is not nothing at step `2 hi + 1`. -/
def threshold (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y : Nat) : Nat :=
  leading (ending g₁ g₂ H₁ H₂ hi y) (hi + 1)

/-- Leading runs of `true` agree for readings that agree. -/
theorem leading_congr {b b' : Nat → Bool} (same : ∀ x, b x = b' x) : ∀ k, leading b k = leading b' k
  | 0 => rfl
  | k + 1 => by
    show (if leading b k = k ∧ b k = true then k + 1 else leading b k) =
      (if leading b' k = k ∧ b' k = true then k + 1 else leading b' k)
    rw [leading_congr same k, same k]

/-- The pair from `x` with its partner at `y` is the web's state with the first level set to `x`. -/
theorem setAt_pair (x y : Nat) : ∀ j, Indexed.setAt (ofPair (0, y)) true x j = ofPair (x, y) j
  | true => if_pos rfl
  | false => if_neg Bool.noConfusion

/-- **The pair's point of no return is the web's**, the second condition at `y`. -/
theorem threshold_pair {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) :
    threshold g₁ g₂ H₁ H₂ hi y =
      Indexed.threshold (pairGiving g₁ g₂) (pairDraw H₁ H₂) [true, false] hi (ofPair (0, y)) true :=
  leading_congr (fun x => congrArg (fun z => decide (z = 0))
    ((pair_at (x, y)).symm.trans (Indexed.run_alike (pair_rises rises₁ rises₂) (setAt_pair x y)
      ([true, false].length * hi + 1) true).symm)) (hi + 1)

/-- **The point of no return is exact.** Within a band under mutual support, the first condition ends
from a level and a partner's level up to `hi` exactly where its level is below the threshold for its
partner's level: the web's law for the pair. -/
theorem ends_iff_below {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔ x < threshold g₁ g₂ H₁ H₂ hi y := by
  rw [threshold_pair rises₁ rises₂]
  exact (ends_pair (D := Drawn.whole)).trans
    ((Indexed.ends_alike (pair_rises rises₁ rises₂) (setAt_pair x y) true).symm.trans
      (Indexed.ends_iff_below (pair_rises rises₁ rises₂) (band_web band) covers_pair high
        (pair_within (s := (0, y)) (Nat.zero_le hi) high')))

/-- **The point of no return falls as the partner rises.** Within a band under mutual support, a
larger partner's level up to `hi` gives the first condition a threshold no higher: the web's law for
the pair. -/
theorem threshold_falls {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi y y' : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (le : y ≤ y')
    (high' : y' ≤ hi) : threshold g₁ g₂ H₁ H₂ hi y' ≤ threshold g₁ g₂ H₁ H₂ hi y := by
  rw [threshold_pair rises₁ rises₂, threshold_pair rises₁ rises₂]
  exact Indexed.threshold_falls (pair_rises rises₁ rises₂) (band_web band) covers_pair
    (fun b => match b with
      | true => Nat.le_refl 0
      | false => le)
    (pair_within (s := (0, y')) (Nat.zero_le hi) high')

/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support, the
run from a level and a partner's level up to `hi` is still from some step at most `2 hi + 1`, where
the first condition is nothing if its level is below the threshold and something if not: the web's
law for the pair. -/
theorem fates {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N ∧
      (x < threshold g₁ g₂ H₁ H₂ hi y →
        ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 = 0) ∧
      (threshold g₁ g₂ H₁ H₂ hi y ≤ x →
        0 < ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1) :=
  have rises := pair_rises (D := Drawn.whole) rises₁ rises₂
  have alike := Indexed.run_alike (H := pairDraw H₁ H₂) rises (setAt_pair x y)
  match Indexed.fates rises (band_web band) covers_pair high
      (pair_within (s := (0, y)) (Nat.zero_le hi) high') with
  | ⟨N, le, still, below, above⟩ =>
    have toPair : (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
        (Indexed.setAt (ofPair (0, y)) true x)).state N true =
        ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 :=
      (alike N true).trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ (x, y) N).1
    ⟨N, Nat.le_trans le (Nat.le_of_eq (congrArg (· + 1) (pair_count hi))),
     pair_still fun k b => (alike (N + k) b).symm.trans ((still k b).trans (alike N b)),
     fun lt => toPair.symm.trans (below (Eq.subst (motive := fun z => x < z) (threshold_pair rises₁ rises₂) lt)),
     fun ge => Nat.lt_of_lt_of_le (above (Eq.subst (motive := fun z => z ≤ x) (threshold_pair rises₁ rises₂) ge))
       (Nat.le_of_eq toPair)⟩

'''
rm = rm[:i] + PAIR + rm[j:]
