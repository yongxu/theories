/-! ## Coupled conditions: a margin that is not its own

The laws above give one condition its own giving law under its own draw. Two conditions can give
from what is left of both: each stands under its draw, taken first, as much as there is, and what each
gives back is a law of what the draws leave of the one and of the other (`Coupled.step`, in any
amounts with a draw). Where each one's giving rises with what is left of each, mutual support, the
coupled step keeps the order of states, so a condition ending from a state ends from every state
below it, and in whole numbers within a band its point of no return is a least level that falls as
its partner's level rises. A condition that gives nothing where its partner leaves nothing drains by
its draw once its partner has nothing left. -/

namespace Coupled

variable {V : Type} (D : Drawn V)

/-- What the draws `H₁` and `H₂` leave of each level. -/
def left (H₁ H₂ : V) (p : V × V) : V × V := (D.sub p.1 H₁, D.sub p.2 H₂)

/-- **One step of two coupled conditions.** The draws `H₁` and `H₂` take first, as much as there is;
each condition's next level is what is left of it with what it gives, `g₁` and `g₂` of what is left of
the first and of the second. -/
def step (g₁ g₂ : V → V → V) (H₁ H₂ : V) (p : V × V) : V × V :=
  (D.add (D.sub p.1 H₁) (g₁ (D.sub p.1 H₁) (D.sub p.2 H₂)),
   D.add (D.sub p.2 H₂) (g₂ (D.sub p.1 H₁) (D.sub p.2 H₂)))

/-- **A condition ends**: from some step on, the level `part` reads off the state is nothing. -/
def Ends (g₁ g₂ : V → V → V) (H₁ H₂ : V) (part : V × V → V) (s : V × V) : Prop :=
  ∃ N, ∀ k, part ((Law.run (step D g₁ g₂ H₁ H₂) s).state (N + k)) = D.zero

/-- The coupled step keeps every state with both levels within `hi` within `hi`. -/
def Band (g₁ g₂ : V → V → V) (H₁ H₂ hi : V) : Prop :=
  ∀ x y, D.le x hi → D.le y hi →
    D.le (step D g₁ g₂ H₁ H₂ (x, y)).1 hi ∧ D.le (step D g₁ g₂ H₁ H₂ (x, y)).2 hi

variable {D}

/-- The coupled step reads a state only through what the draws leave of it. -/
theorem step_of_left {g₁ g₂ : V → V → V} {H₁ H₂ : V} {p q : V × V}
    (same : left D H₁ H₂ p = left D H₁ H₂ q) : step D g₁ g₂ H₁ H₂ p = step D g₁ g₂ H₁ H₂ q := by
  have same₁ : D.sub p.1 H₁ = D.sub q.1 H₁ := congrArg Prod.fst same
  have same₂ : D.sub p.2 H₂ = D.sub q.2 H₂ := congrArg Prod.snd same
  show (D.add (D.sub p.1 H₁) (g₁ (D.sub p.1 H₁) (D.sub p.2 H₂)),
      D.add (D.sub p.2 H₂) (g₂ (D.sub p.1 H₁) (D.sub p.2 H₂))) =
    (D.add (D.sub q.1 H₁) (g₁ (D.sub q.1 H₁) (D.sub q.2 H₂)),
      D.add (D.sub q.2 H₂) (g₂ (D.sub q.1 H₁) (D.sub q.2 H₂)))
  rw [same₁, same₂]

/-- **Under mutual support the coupled step keeps the order of states.** Where each condition's
giving rises with what is left of each, a state at or below another in both levels stays so after a
step. -/
theorem step_mono {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (H₁ H₂ : V)
    {p q : V × V} (below : D.Below p q) : D.Below (step D g₁ g₂ H₁ H₂ p) (step D g₁ g₂ H₁ H₂ q) :=
  have left₁ := Drawn.sub_mono H₁ below.1
  have left₂ := Drawn.sub_mono H₂ below.2
  ⟨D.le_trans (D.add_le_add_right _ left₁) (Amounts.add_le_add_left _ (rises₁ _ _ _ _ left₁ left₂)),
   D.le_trans (D.add_le_add_right _ left₂) (Amounts.add_le_add_left _ (rises₂ _ _ _ _ left₁ left₂))⟩

/-- Under mutual support, runs from ordered states stay ordered at every step. -/
theorem run_below {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (H₁ H₂ : V)
    {p q : V × V} (below : D.Below p q) :
    ∀ n, D.Below ((Law.run (step D g₁ g₂ H₁ H₂) p).state n) ((Law.run (step D g₁ g₂ H₁ H₂) q).state n) :=
  Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises₁ rises₂ H₁ H₂ b) below

/-- **Below a state from which a condition ends, it ends.** Under mutual support, where a condition
read off the state by a part that keeps the order of states ends from a state, it ends from every
state at or below it in both levels. -/
theorem ends_of_below {g₁ g₂ : V → V → V} {H₁ H₂ : V} {part : V × V → V}
    (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (reads : ∀ p q, D.Below p q → D.le (part p) (part q))
    {p q : V × V} (below : D.Below p q) (ends : Ends D g₁ g₂ H₁ H₂ part q) :
    Ends D g₁ g₂ H₁ H₂ part p :=
  have ⟨N, gone⟩ := ends
  ⟨N, fun k => D.antisymm (D.le_trans (reads _ _ (run_below rises₁ rises₂ H₁ H₂ below (N + k)))
    (Amounts.le_of_eq (gone k))) (D.zero_le _)⟩

/-- **The roles exchanged.** Exchanging the two conditions, their draws and the arguments of their
giving exchanges the levels at every step of the run. -/
theorem run_swap (g₁ g₂ : V → V → V) (H₁ H₂ : V) (s : V × V) :
    ∀ n, (Law.run (step D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁) s.swap).state n =
      ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).swap
  | 0 => rfl
  | n + 1 => congrArg (step D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁) (run_swap g₁ g₂ H₁ H₂ s n)

/-- The second condition ends exactly where, the roles exchanged, the first does. -/
theorem ends_swap {g₁ g₂ : V → V → V} {H₁ H₂ : V} {s : V × V} :
    Ends D g₁ g₂ H₁ H₂ Prod.snd s ↔
      Ends D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁ Prod.fst s.swap :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (congrArg Prod.fst (run_swap g₁ g₂ H₁ H₂ s (N + k))).trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (congrArg Prod.fst (run_swap g₁ g₂ H₁ H₂ s (N + k))).symm.trans (gone k)⟩⟩

/-- **A dependent condition drains once its partner has nothing left.** Where the second condition
gives nothing wherever nothing is left of the first, from a state whose first level is within its
draw the second's next level is what its draw leaves of it. -/
theorem drains {g₁ g₂ : V → V → V} {H₁ H₂ : V} (depends : ∀ b, g₂ D.zero b = D.zero) {p : V × V}
    (within : D.le p.1 H₁) : (step D g₁ g₂ H₁ H₂ p).2 = D.sub p.2 H₂ := by
  show D.add (D.sub p.2 H₂) (g₂ (D.sub p.1 H₁) (D.sub p.2 H₂)) = D.sub p.2 H₂
  rw [D.sub_zero within, depends]
  exact Amounts.add_zero _

/-- Giving that keeps the top of a band within it is within the draw. -/
theorem given_within {H hi a : V} (top : D.le (D.add (D.sub hi H) a) hi) : D.le a H :=
  (D.total H hi).elim
    (fun high => Drawn.add_cancel (a := D.sub hi H) (D.le_trans top
      (Amounts.le_of_eq ((D.add_comm (D.sub hi H) H).trans (D.add_sub high)).symm)))
    (fun low => D.le_trans (by rw [D.sub_zero low, D.zero_add] at top; exact top) low)

/-- **In a band, mutual support gives within each draw.** Where each condition's giving rises with what
is left of each and the coupled step keeps a band up to `hi`, at every state in the band each
condition gives at most its draw. -/
theorem within_draw {g₁ g₂ : V → V → V} {H₁ H₂ hi : V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂)
    (band : Band D g₁ g₂ H₁ H₂ hi) {x y : V} (high : D.le x hi) (high' : D.le y hi) :
    D.le (g₁ (D.sub x H₁) (D.sub y H₂)) H₁ ∧ D.le (g₂ (D.sub x H₁) (D.sub y H₂)) H₂ :=
  have top := band hi hi (D.le_refl hi) (D.le_refl hi)
  have left₁ := Drawn.sub_mono H₁ high
  have left₂ := Drawn.sub_mono H₂ high'
  ⟨D.le_trans (rises₁ _ _ _ _ left₁ left₂) (given_within top.1),
   D.le_trans (rises₂ _ _ _ _ left₁ left₂) (given_within top.2)⟩

/-- Where a condition gives within its draw, what the draw leaves of it does not rise over a step. -/
theorem left_le {H e a : V} (within : D.le a H) : D.le (D.sub (D.add e a) H) e :=
  (D.total H (D.add e a)).elim
    (fun high => Drawn.add_cancel (a := H) (D.le_trans (Amounts.le_of_eq (D.add_sub high))
      (D.le_trans (Amounts.add_le_add_left e within) (Amounts.le_of_eq (D.add_comm e H)))))
    (fun low => by rw [D.sub_zero low]; exact D.zero_le e)

/-- A run from a state within a band stays within it. -/
theorem run_within {g₁ g₂ : V → V → V} {H₁ H₂ hi : V} (band : Band D g₁ g₂ H₁ H₂ hi) {s : V × V}
    (high : D.le s.1 hi) (high' : D.le s.2 hi) :
    ∀ n, D.le ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).1 hi ∧
      D.le ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).2 hi
  | 0 => ⟨high, high'⟩
  | n + 1 => band _ _ (run_within band high high' n).1 (run_within band high high' n).2

/-- **In a band under mutual support, what is left of each condition never rises along a run.** -/
theorem left_falls {g₁ g₂ : V → V → V} {H₁ H₂ hi : V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂)
    (band : Band D g₁ g₂ H₁ H₂ hi) {s : V × V} (high : D.le s.1 hi) (high' : D.le s.2 hi) (n : Nat) :
    D.Below (left D H₁ H₂ ((Law.run (step D g₁ g₂ H₁ H₂) s).state (n + 1)))
      (left D H₁ H₂ ((Law.run (step D g₁ g₂ H₁ H₂) s).state n)) :=
  have within := within_draw rises₁ rises₂ band (run_within band high high' n).1
    (run_within band high high' n).2
  ⟨left_le within.1, left_le within.2⟩

/-- **A run is still once what is left of both repeats.** Where a step of the run leaves what the draws
leave of each level as it was, the run is still from the next step on. -/
theorem still_of_left {g₁ g₂ : V → V → V} {H₁ H₂ : V} {s : V × V} {n : Nat}
    (same : left D H₁ H₂ ((Law.run (step D g₁ g₂ H₁ H₂) s).state (n + 1)) =
      left D H₁ H₂ ((Law.run (step D g₁ g₂ H₁ H₂) s).state n)) :
    LastChange.StillFrom (Law.run (step D g₁ g₂ H₁ H₂) s) (n + 1) := fun k => by
  have fixed : step D g₁ g₂ H₁ H₂ (Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1)) =
      Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1) := step_of_left same
  have stays : Law.orbit (step D g₁ g₂ H₁ H₂) (Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1)) k =
      Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1) :=
    (congrArg (Law.orbit (step D g₁ g₂ H₁ H₂) (Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1)))
      (Nat.one_mul k)).symm.trans
      (Law.orbit_mul (next := step D g₁ g₂ H₁ H₂) (s := Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1))
        (p := 1) fixed k)
  show step D g₁ g₂ H₁ H₂ (Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1 + k)) =
    Law.orbit (step D g₁ g₂ H₁ H₂) s (n + 1 + k)
  rw [Law.orbit_add _ s (n + 1) k, stays]
  exact fixed

/-! ### Coupled conditions in whole numbers -/

/-- Within a band under mutual support, the run from a state is still from some step at most one more
than what the draws leave of both, added. -/
theorem rests_by {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) :
    ∀ (d : Nat) (s : Nat × Nat), s.1 ≤ hi → s.2 ≤ hi → (s.1 - H₁) + (s.2 - H₂) ≤ d →
      ∃ N, N ≤ d + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s) N
  | 0, s, high, high', fuel =>
    have falls := left_falls rises₁ rises₂ band (s := s) high high' 0
    ⟨1, Nat.le_refl 1, still_of_left (n := 0) (Decidable.byContradiction fun moved =>
      absurd (Nat.lt_of_lt_of_le (Adjusted.sum_lt_of_below
        (p := left Drawn.whole H₁ H₂ (step Drawn.whole g₁ g₂ H₁ H₂ s)) (q := left Drawn.whole H₁ H₂ s)
        falls fun e => moved e.symm) fuel) (Nat.not_lt_zero _))⟩
  | d + 1, s, high, high', fuel =>
    have falls := left_falls rises₁ rises₂ band (s := s) high high' 0
    if same : left Drawn.whole H₁ H₂ (step Drawn.whole g₁ g₂ H₁ H₂ s) = left Drawn.whole H₁ H₂ s then
      ⟨1, Nat.succ_le_succ (Nat.zero_le _), still_of_left (n := 0) same⟩
    else
      have inner := band s.1 s.2 high high'
      have ⟨N, le, still⟩ := rests_by rises₁ rises₂ band d (step Drawn.whole g₁ g₂ H₁ H₂ s) inner.1 inner.2
        (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le
          (Adjusted.sum_lt_of_below (p := left Drawn.whole H₁ H₂ (step Drawn.whole g₁ g₂ H₁ H₂ s))
            (q := left Drawn.whole H₁ H₂ s) falls fun e => same e.symm) fuel))
      ⟨N + 1, Nat.succ_le_succ le, LastChange.still_succ still⟩

/-- **Under mutual support within a band, a run comes to rest.** In whole numbers, where each
condition's giving rises with what is left of each and the coupled step keeps a band up to `hi`, the run
from a state in the band is still from some step at most `2 hi + 1`. -/
theorem comes_to_rest {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) {x y : Nat}
    (high : x ≤ hi) (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N :=
  rests_by rises₁ rises₂ band (hi + hi) (x, y) high high'
    (Nat.add_le_add (Nat.le_trans (Nat.sub_le x H₁) high) (Nat.le_trans (Nat.sub_le y H₂) high'))

/-- Within a band under mutual support, whether the first condition ends is decided at step
`2 hi + 1`. -/
theorem ends_iff {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0 :=
  have ⟨N, le, still⟩ := comes_to_rest rises₁ rises₂ band high high'
  have atK : (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1) =
      (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N :=
    (congrArg (fun n => (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state n)
      (Becoming.add_sub_of_le le).symm).trans (LastChange.still_stays still _)
  ⟨fun ⟨M, gone⟩ => (congrArg Prod.fst (atK.trans ((LastChange.still_stays still M).symm.trans
      (congrArg (fun n => (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state n)
        (Nat.add_comm N M))))).trans (gone N),
   fun zero => ⟨hi + hi + 1, fun k =>
    (congrArg Prod.fst ((congrArg (fun n => (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state n)
      ((congrArg (· + k) (Becoming.add_sub_of_le le).symm).trans
        (Nat.add_assoc N (hi + hi + 1 - N) k))).trans
      ((LastChange.still_stays still _).trans atK.symm))).trans zero⟩⟩

/-- Whether the first condition, from level `x` with its partner at `y`, is nothing at step `2 hi + 1`. -/
def ending (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y x : Nat) : Bool :=
  decide (((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0)

/-- **The first condition's point of no return, with its partner at `y`.** The least level up to
`hi + 1` from which the first condition is not nothing at step `2 hi + 1`. -/
def threshold (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y : Nat) : Nat :=
  leading (ending g₁ g₂ H₁ H₂ hi y) (hi + 1)

/-- **The point of no return is exact.** Within a band under mutual support, the first condition ends
from a level and a partner's level up to `hi` exactly where its level is below the threshold for its
partner's level. -/
theorem ends_iff_below {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔ x < threshold g₁ g₂ H₁ H₂ hi y :=
  ⟨fun ends => (Nat.lt_or_ge x (threshold g₁ g₂ H₁ H₂ hi y)).elim id fun ge =>
      have short : threshold g₁ g₂ H₁ H₂ hi y < hi + 1 := Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
      have notEnds : ¬ Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (threshold g₁ g₂ H₁ H₂ hi y, y) := fun e =>
        absurd ((ends_iff rises₁ rises₂ band (Nat.le_of_lt_succ short) high').1 e)
          (of_decide_eq_false (leading_false (ending g₁ g₂ H₁ H₂ hi y) (hi + 1) short))
      absurd (ends_of_below (part := Prod.fst) (p := (threshold g₁ g₂ H₁ H₂ hi y, y)) (q := (x, y))
        rises₁ rises₂ (fun _ _ b => b.1) ⟨ge, Nat.le_refl y⟩ ends) notEnds,
   fun lt => (ends_iff rises₁ rises₂ band high high').2
      (of_decide_eq_true (leading_true (ending g₁ g₂ H₁ H₂ hi y) (hi + 1) x lt))⟩

/-- **The point of no return falls as the partner rises.** Within a band under mutual support, a
larger partner's level up to `hi` gives the first condition a threshold no higher. -/
theorem threshold_falls {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi y y' : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (le : y ≤ y')
    (high' : y' ≤ hi) : threshold g₁ g₂ H₁ H₂ hi y' ≤ threshold g₁ g₂ H₁ H₂ hi y :=
  (Nat.lt_or_ge (threshold g₁ g₂ H₁ H₂ hi y) (threshold g₁ g₂ H₁ H₂ hi y')).elim
    (fun lt =>
      have high : threshold g₁ g₂ H₁ H₂ hi y ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le _ _))
      have ends := ends_of_below (part := Prod.fst) (p := (threshold g₁ g₂ H₁ H₂ hi y, y))
        (q := (threshold g₁ g₂ H₁ H₂ hi y, y')) rises₁ rises₂ (fun _ _ b => b.1) ⟨Nat.le_refl _, le⟩
        ((ends_iff_below rises₁ rises₂ band high high').2 lt)
      absurd ((ends_iff_below rises₁ rises₂ band high (Nat.le_trans le high')).1 ends) (Nat.lt_irrefl _))
    id

/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support, the
run from a level and a partner's level up to `hi` is still from some step at most `2 hi + 1`, where
the first condition is nothing if its level is below the threshold and something if not. -/
theorem fates {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N ∧
      (x < threshold g₁ g₂ H₁ H₂ hi y →
        ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 = 0) ∧
      (threshold g₁ g₂ H₁ H₂ hi y ≤ x →
        0 < ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1) :=
  have ⟨N, le, still⟩ := comes_to_rest rises₁ rises₂ band high high'
  have gone_iff : Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 = 0 :=
    ⟨fun ⟨M, gone⟩ => (congrArg Prod.fst ((LastChange.still_stays still M).symm.trans
        (congrArg (fun n => (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state n)
          (Nat.add_comm N M)))).trans (gone N),
     fun zero => ⟨N, fun k => (congrArg Prod.fst (LastChange.still_stays still k)).trans zero⟩⟩
  ⟨N, le, still, fun lt => gone_iff.1 ((ends_iff_below rises₁ rises₂ band high high').2 lt),
   fun ge => Nat.pos_of_ne_zero fun zero =>
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le ((ends_iff_below rises₁ rises₂ band high high').1
      (gone_iff.2 zero)) ge)⟩

/-- **A dependent condition ends after its partner.** In whole numbers, where the second condition
gives nothing wherever nothing is left of the first and the first stays within its draw from step `N`
on, the second falls by its draw at every step from `N`; where that draw is positive it is nothing from
step `N + y` on, `y` its level at `N`. -/
theorem ends_after {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    {s : Nat × Nat} {N : Nat}
    (within : ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).1 ≤ H₁) :
    (∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).2 =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 - H₂ * k) ∧
    (0 < H₂ → ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state
      (N + ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 + k)).2 = 0) :=
  have falls : ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).2 =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 - H₂ * k := fun k => by
    induction k with
    | zero => exact (congrArg (((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 - ·)
        (Nat.mul_zero H₂)).symm
    | succ k ih =>
      exact (drains (D := Drawn.whole) (g₁ := g₁) (H₂ := H₂) depends (within k)).trans
        ((congrArg (· - H₂) ih).trans (Naturals.sub_sub _ _ _))
  ⟨falls, fun pos k =>
    (congrArg (fun n => ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state n).2)
      (Nat.add_assoc N _ k)).trans
    ((falls _).trans (Becoming.sub_eq_zero_of_le (Nat.le_trans (Nat.le_add_right _ k)
      (Nat.le_mul_of_pos_left _ pos))))⟩

/-- **The end of one ends what depends on it.** In whole numbers, where the second condition gives
nothing wherever nothing is left of the first and its draw is positive, wherever the first ends the
second ends. -/
theorem ends_of_partner {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    (pos : 0 < H₂) {s : Nat × Nat} (ends : Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  have ⟨N, gone⟩ := ends
  ⟨_, (ends_after depends (N := N) fun k => Nat.le_trans (Nat.le_of_eq (gone k)) (Nat.zero_le H₁)).2 pos⟩

/-- **Under dependence both ways the two end together or not at all.** In whole numbers, where each
condition gives nothing wherever nothing is left of the other and both draws are positive, the first
ends exactly where the second does. -/
theorem ends_together {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends₁ : ∀ a, g₁ a 0 = 0)
    (depends₂ : ∀ b, g₂ 0 b = 0) (pos₁ : 0 < H₁) (pos₂ : 0 < H₂) {s : Nat × Nat} :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s ↔ Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  ⟨ends_of_partner depends₂ pos₂, fun ends =>
    have swapped := ends_of_partner (g₁ := fun a b => g₂ b a) (g₂ := fun a b => g₁ b a) depends₁ pos₁
      (ends_swap.1 ends)
    have ⟨N, gone⟩ := swapped
    ⟨N, fun k => (congrArg Prod.snd (run_swap g₁ g₂ H₁ H₂ s (N + k))).symm.trans (gone k)⟩⟩

/-- **A condition whose giving reads only what is left of itself runs as the regime.** In whole numbers,
where the first condition's giving is `g` of what is left of it alone, its level along the coupled run
is the regime's run under its draw, whatever its partner does. -/
theorem first_regime (g : Nat → Nat) (g₂ : Nat → Nat → Nat) (H₁ H₂ : Nat) (s : Nat × Nat) :
    ∀ n, ((Law.run (step Drawn.whole (fun a _ => g a) g₂ H₁ H₂) s).state n).1 =
      (Law.run (RegimeMargin.step g H₁) s.1).state n
  | 0 => rfl
  | n + 1 => congrArg (RegimeMargin.step g H₁) (first_regime g g₂ H₁ H₂ s n)

/-- A state the coupled step leaves as it is stays at every step of its run. -/
theorem stays {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s : Nat × Nat}
    (fixed : step Drawn.whole g₁ g₂ H₁ H₂ s = s) :
    ∀ n, (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state n = s := fun n =>
  (congrArg (Law.orbit (step Drawn.whole g₁ g₂ H₁ H₂) s) (Nat.one_mul n)).symm.trans
    (Law.orbit_mul (next := step Drawn.whole g₁ g₂ H₁ H₂) (s := s) (p := 1) fixed n)

/-- A run that reaches a state the coupled step leaves as it is stays there. -/
theorem stays_from {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s t : Nat × Nat} {T : Nat}
    (at_ : (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state T = t)
    (fixed : step Drawn.whole g₁ g₂ H₁ H₂ t = t) :
    ∀ k, (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (T + k) = t := fun k =>
  (Law.orbit_add _ s T k).trans ((congrArg (fun p => Law.orbit (step Drawn.whole g₁ g₂ H₁ H₂) p k) at_).trans
    (stays fixed k))

/-- **Without mutual support a run within a band need not rest.** Giving that is two from nothing and
nothing from more, read as the first condition's, with the second giving nothing, does not rise with
what is left, and under draws of one the coupled step keeps a band up to two; yet the coupled run from
one and nothing is never still, the first's level being the regime's, which moves between one and two. -/
theorem alternation_never_rests :
    ¬ Drawn.whole.Rises (fun a (_ : Nat) => Alternation.giving a) ∧
    Band Drawn.whole (fun a _ => Alternation.giving a) (fun _ _ => 0) 1 1 2 ∧
    ∀ N, ¬ LastChange.StillFrom
      (Law.run (step Drawn.whole (fun a _ => Alternation.giving a) (fun _ _ => 0) 1 1) (1, 0)) N :=
  ⟨fun rises => absurd (rises 0 1 0 0 (Nat.zero_le 1) (Nat.le_refl 0))
      (by decide : ¬ Alternation.giving 0 ≤ Alternation.giving 1),
   fun x y hx hy => ⟨Alternation.keeps x hx, Nat.le_trans (Nat.sub_le y 1) hy⟩,
   fun N still => Alternation.alternates.2.2.2.2.2.1 N fun k =>
    (first_regime Alternation.giving (fun _ _ => 0) 1 1 (1, 0) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (first_regime Alternation.giving (fun _ _ => 0) 1 1 (1, 0) (N + k)))⟩

namespace MutualActivation

/-- Each gives one where at least one is left of each. -/
def giving (a b : Nat) : Nat := if 1 ≤ a ∧ 1 ≤ b then 1 else 0

theorem giving_rises : Drawn.whole.Rises giving := fun e _ r _ le le' =>
  if h : 1 ≤ e ∧ 1 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem giving_le (a b : Nat) : giving a b ≤ 1 :=
  if h : 1 ≤ a ∧ 1 ≤ b then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

/-- Under draws of one the coupled step keeps every state up to two within two. -/
theorem band : Band Drawn.whole giving giving 1 1 2 := fun _ _ hx hy =>
  ⟨Nat.le_trans (Nat.add_le_add_left (giving_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hx)),
   Nat.le_trans (Nat.add_le_add_left (giving_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hy))⟩

/-- **Support can save a condition.** Under giving of one where at least one is left of each, draws of
one and a band up to two, the giving rises with what is left of each; from two, the first condition
ends with its partner at nothing and holds with its partner at two. Its point of no return falls from
beyond the band, every level up to two ending, to two. -/
theorem saves :
    Drawn.whole.Rises giving ∧ Band Drawn.whole giving giving 1 1 2 ∧
    Ends Drawn.whole giving giving 1 1 Prod.fst (2, 0) ∧
    ¬ Ends Drawn.whole giving giving 1 1 Prod.fst (2, 2) ∧
    threshold giving giving 1 1 2 0 = 3 ∧ threshold giving giving 1 1 2 2 = 2 :=
  ⟨giving_rises, band,
   ⟨2, fun k => congrArg Prod.fst (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.fst (stays (s := (2, 2)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   rfl, rfl⟩

end MutualActivation

namespace MutualInhibition

/-- The first gives one where at least one is left of it and nothing of the second. -/
def first (a b : Nat) : Nat := if 1 ≤ a ∧ b = 0 then 1 else 0

/-- The second gives one where nothing is left of the first and at least one of it. -/
def second (a b : Nat) : Nat := if a = 0 ∧ 1 ≤ b then 1 else 0

theorem first_le (a b : Nat) : first a b ≤ 1 :=
  if h : 1 ≤ a ∧ b = 0 then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

theorem second_le (a b : Nat) : second a b ≤ 1 :=
  if h : a = 0 ∧ 1 ≤ b then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

/-- Under draws of one the coupled step keeps every state up to two within two. -/
theorem band : Band Drawn.whole first second 1 1 2 := fun _ _ hx hy =>
  ⟨Nat.le_trans (Nat.add_le_add_left (first_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hx)),
   Nat.le_trans (Nat.add_le_add_left (second_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hy))⟩

/-- **Without mutual support the order of fates breaks.** Where each gives one only where nothing is
left of the other, the giving falls as what is left of the other rises, and under draws of one the
coupled step keeps a band up to two. Each holds at two alone, and from two and two both end; so the
first ends from a state above one from which it holds, and its point of no return rises from two to
beyond the band as its partner rises from nothing to two. -/
theorem breaks_order :
    ¬ Drawn.whole.Rises first ∧ Band Drawn.whole first second 1 1 2 ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 0) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.snd (0, 2) ∧
    Ends Drawn.whole first second 1 1 Prod.fst (2, 2) ∧ Ends Drawn.whole first second 1 1 Prod.snd (2, 2) ∧
    Drawn.whole.Below (2, 0) (2, 2) ∧
    threshold first second 1 1 2 0 = 2 ∧ threshold first second 1 1 2 2 = 3 :=
  ⟨fun rises => absurd (rises 1 1 0 1 (Nat.le_refl 1) (Nat.zero_le 1)) (by decide : ¬ first 1 0 ≤ first 1 1),
   band,
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.fst (stays (s := (2, 0)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.snd (stays (s := (0, 2)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   ⟨2, fun k => congrArg Prod.fst (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   ⟨2, fun k => congrArg Prod.snd (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   ⟨Nat.le_refl 2, Nat.zero_le 2⟩, rfl, rfl⟩

end MutualInhibition

namespace Relay

/-- The first gives two where at least one is left of it and at least two of the second. -/
def first (a b : Nat) : Nat := if 1 ≤ a ∧ 2 ≤ b then 2 else 0

/-- The second gives two where at least two are left of the first and at least one of it. -/
def second (a b : Nat) : Nat := if 2 ≤ a ∧ 1 ≤ b then 2 else 0

theorem first_rises : Drawn.whole.Rises first := fun e _ r _ le le' =>
  if h : 1 ≤ e ∧ 2 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem second_rises : Drawn.whole.Rises second := fun e _ r _ le le' =>
  if h : 2 ≤ e ∧ 1 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem first_zero (a : Nat) : first a 0 = 0 := if_neg fun h => absurd h.2 (by decide)

theorem first_of_zero (b : Nat) : first 0 b = 0 := if_neg fun h => absurd h.1 (by decide)

theorem second_zero (a : Nat) : second a 0 = 0 := if_neg fun h => absurd h.2 (by decide)

theorem second_of_zero (b : Nat) : second 0 b = 0 := if_neg fun h => absurd h.1 (by decide)

/-- With the second at nothing, the first falls by one at every step and the second stays nothing. -/
theorem first_alone (x : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (x, 0)).state n = (x - n, 0)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (first_alone x n)).trans
    (congr (congrArg Prod.mk (congrArg (x - n - 1 + ·) (first_zero (x - n - 1))))
      (congrArg (0 + ·) (second_zero (x - n - 1))))

/-- With the first at nothing, the second falls by one at every step and the first stays nothing. -/
theorem second_alone (y : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (0, y)).state n = (0, y - n)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (second_alone y n)).trans
    (congr (congrArg Prod.mk (congrArg (0 + ·) (first_of_zero (y - n - 1))))
      (congrArg (y - n - 1 + ·) (second_of_zero (y - n - 1))))

/-- From two and three, the run is at two and three or at three and two at every step, and the next is
the other. -/
theorem between :
    ∀ n, ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n = (2, 3) ∧
        (Law.run (step Drawn.whole first second 1 1) (2, 3)).state (n + 1) = (3, 2)) ∨
      ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n = (3, 2) ∧
        (Law.run (step Drawn.whole first second 1 1) (2, 3)).state (n + 1) = (2, 3))
  | 0 => Or.inl ⟨rfl, rfl⟩
  | n + 1 => (between n).elim
    (fun ⟨_, next⟩ => Or.inr ⟨next, (congrArg (step Drawn.whole first second 1 1) next).trans rfl⟩)
    (fun ⟨_, next⟩ => Or.inl ⟨next, (congrArg (step Drawn.whole first second 1 1) next).trans rfl⟩)

/-- **Mutual support can hold a pair neither of which holds alone, and need not rest.** Where each gives
two only where enough is left of the other, the giving rises with what is left of each and each gives
nothing wherever nothing is left of the other. Under draws of one each condition alone ends, from
every level. Yet from two and three the run moves between two and three and three and two at every
step: it stays within three, neither condition ever ends, and the run is never still. -/
theorem cycles :
    Drawn.whole.Rises first ∧ Drawn.whole.Rises second ∧ (∀ a, first a 0 = 0) ∧ (∀ b, second 0 b = 0) ∧
    (∀ x, Ends Drawn.whole first second 1 1 Prod.fst (x, 0)) ∧
    (∀ y, Ends Drawn.whole first second 1 1 Prod.snd (0, y)) ∧
    (∀ n, ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).1 ≤ 3 ∧
      ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).2 ≤ 3) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 3) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.snd (2, 3) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (step Drawn.whole first second 1 1) (2, 3)) N :=
  ⟨first_rises, second_rises,
   first_zero, second_of_zero,
   fun x => ⟨x, fun k => (congrArg Prod.fst (first_alone x (x + k))).trans
     (Becoming.sub_eq_zero_of_le (Nat.le_add_right x k))⟩,
   fun y => ⟨y, fun k => (congrArg Prod.snd (second_alone y (y + k))).trans
     (Becoming.sub_eq_zero_of_le (Nat.le_add_right y k))⟩,
   fun n => (between n).elim
     (fun ⟨at_, _⟩ => by rw [at_]; exact ⟨Nat.le_succ 2, Nat.le_refl 3⟩)
     (fun ⟨at_, _⟩ => by rw [at_]; exact ⟨Nat.le_refl 3, Nat.le_succ 2⟩),
   fun ⟨N, gone⟩ => (between (N + 0)).elim
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.fst at_).symm.trans (gone 0)))
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.fst at_).symm.trans (gone 0))),
   fun ⟨N, gone⟩ => (between (N + 0)).elim
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.snd at_).symm.trans (gone 0)))
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.snd at_).symm.trans (gone 0))),
   fun N still => (between (N + 0)).elim
     (fun ⟨at_, next⟩ => absurd ((next.symm.trans (still 0)).trans at_) (by decide))
     (fun ⟨at_, next⟩ => absurd ((next.symm.trans (still 0)).trans at_) (by decide))⟩

end Relay

end Coupled
