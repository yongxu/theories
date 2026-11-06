import Becoming.Counterfactual
import Becoming.TimedResponse

/-!
# Propagation: how much difference arrives

`Becoming.Counterfactual` (P80) gives the course an act generates where the rest follows a law of
what has stood, and decides the comparison within the part's responsive reach; among what it does
not derive is "any measure of how much difference arrives". `Becoming.Sensitivity` (P113) gives the
least coupling such a law reads through, its sensitivity, which says whether a level can change
an exchange, not by how much; `Becoming.TimedResponse` orders the reach in time. This module
measures, within the theory without axiom and with no premise beyond what each law names, how strongly an exchange is
coupled to a level, how much difference an act carries through such couplings, and that this is the
most that can arrive.

* **Difference arrives as exchanged difference.** In two balanced flows, the first's level of a
  condition after a step and the second's before, with what the first takes and the second gives,
  add up to the second's level after and the first's before, with what the second takes and the
  first gives (`levels_step_exact`): the difference of the levels changes across a step by exactly
  the difference given less the difference taken. So a condition's gap (`gap`, what either level
  has beyond the other) across a step is at most its gap before with the gaps of every exchange
  with it (`gap_step`, `Flow.exchangeGap`), and does not grow where every exchange is alike
  (`gap_step_of_alike`).
* **Coupling strength, the measure of sensitivity.** Across the step from `t`, `h`'s exchange with
  `c` is coupled to the level of `d` at step `s` with strength at most `k` where, under any two
  histories differing in that one level only, what it takes and gives differ in all by at most `k`
  times that level's gap (`ExchangeLaw.RespondsWithin`). For a law of what has stood, strength zero
  at every level of a condition up to the step is insensitivity to it
  (`ExchangeLaw.insensitiveAt_iff_strength_zero`), and sensitivity is that at some step not every
  such strength is zero (`ExchangeLaw.sensitive_iff_strength`). Strengths add up over levels
  changed one at a time (`ExchangeLaw.exchangeGap_le_mixCells`): under two histories that differ up
  to the step only on listed conditions, the exchange's gap is at most the sum of each strength
  times its level's gap (`ExchangeLaw.exchangeGap_le_strengths`, and with every condition listed
  under any two histories, `ExchangeLaw.exchangeGap_le_strengths_listed`). So the change of a move
  is at most the part's share, its strengths times the part's change, with the rest's share
  (`ExchangeLaw.exchangeGap_le_shares`). A finite strength is a condition on a law, not given with
  every law: a law giving the square of a level has none (`Propagation.Square.not_respondsWithin`).
* **The carried amount.** The carrying law (`ExchangeLaw.carrying`) has the part give its gaps and
  each formation outside it give what its strengths make of the levels so far, and takes nothing.
  The carried amount (`carried`) is the course it generates from the starting gaps by
  `Becoming.Counterfactual`'s generation: across each step it grows by the part's gaps and by the
  strengths on the amounts carried so far (`carried_succ`). In two balanced flows of one law of what
  has stood with the coupling strengths `k`, the part differing by at most its gaps and the starting
  levels by at most theirs, every gap at every step is at most the carried amount
  (`gap_le_carried`).
* **It is attained.** With each condition listed once the carrying law has the coupling strengths
  `k` (`ExchangeLaw.carrying_respondsWithin`) and its course balances (`carrying_balances`); against
  the quiet course, which carries nothing (`carried_quiet`), its gap at every step is the carried
  amount (`carried_attained`). So the carried amount is the most difference that can arrive: a gap
  is at most `a` for every law with those strengths and every two flows of it exactly where the
  carried amount is at most `a` (`most_difference_arrives`).
* **Where it goes.** The carried amount is positive exactly where a gap is conveyed (`Conveyed`), by
  a starting gap, by holding, by a gap of the part, or by a positive strength from a level to which
  a gap was conveyed: a route in time (`carried_pos_iff`). Where none is, the levels agree
  (`levels_alike_of_not_conveyed`). Where the positive strengths are of formations into which the
  level couples and which exchange with the condition, every conveyed gap lies on a route of
  `TimedResponse.Spread` (`Conveyed.spread`): the potential propagation of
  `Becoming.TimedResponse`, now with its amount.
* **Carried differences add.** What the strengths carry from two sets of gaps together is the sum
  of what they carry from each (`carried_add`); more gaps and larger strengths carry more
  (`carried_mono`).
* **Witnesses.** One unit given once to a condition, which the rest relays to a second at twice its
  level, arrives there as `2t` by step `t + 1`, without bound though nothing returns it
  (`Propagation.Chain.keeps_arriving`), and the carrying course has exactly that gap
  (`Propagation.Chain.gap_arrives`). Returned to its condition by a loop of strength one, it arrives
  as `2 ^ t` (`Propagation.Loop.runaway`).

**Readings (the AI's, D39).**
- The coupling strength is the measure that sensitivity lacked: sensitivity says that a level can
  change an exchange, the strength how much. Read as 识, what couples into a formation is
  what its exchange is sensitive to, and the strength is how strongly.
- How much difference arrives is itself a course: the carried amount is what one law generates, so
  an act's reach is read off the unfolding, not added to it. In systems theory the strengths are
  incremental gains (Lipschitz bounds) and the carried amount is the comparison system they define;
  here it is attained, so no smaller bound follows from the strengths alone.
- A held difference keeps arriving. Levels hold what they are given, so without any loop one act's
  difference arrives without bound wherever a positive strength reads the level that holds it
  (`Propagation.Chain`); a loop multiplies it (`Propagation.Loop`).
- The chapter's §6.10 reads Ren's "the whole earth has become a highly entangled system", and notes
  that a common condition makes the reach the whole but does not measure coupling. The coupling
  strengths do: how entangled a whole is reads as how strongly its exchanges are coupled to each
  other's levels, and the carried amount as how far and how fast an act's difference can grow in it.
- How much of a move a part forms reads as the part's share: at most its strengths times its own
  change, with the rest's share added for the whole move.

What is not derived: the coupling strengths themselves, supplied as bounds wherever they enter (a
least strength is not stated); a general theory of loops, with the strength around every loop and
its runaway, beyond the witnesses; laws reading infinitely many conditions (every condition is
listed); continuous time and real amounts; how a center represents what it reaches. The
representation commits to discrete steps and natural amounts. No ethical predicate, ranking or axiom
occurs.

Declarations moved here unchanged, with their names, from `Becoming.Runs` (board item W): see the
sections so headed.
-/

namespace Becoming

variable {F C : Type}

/-! ## The gap between two amounts -/

/-- The gap between two amounts: what either has beyond the other. -/
def gap (a b : Nat) : Nat := (a - b) + (b - a)

namespace Propagation

/-- A rearrangement of five amounts, with an empty axiom report. -/
theorem rearrange (b x u v w : Nat) : b + (x + u) + (v + w) = b + (v + (u + w)) + x :=
  (Nat.add_assoc b (x + u) (v + w)).trans
    ((congrArg (b + ·) ((Nat.add_assoc x u (v + w)).trans
      ((congrArg (x + ·) (Nat.add_left_comm u v w)).trans (Nat.add_comm x _)))).trans
      (Nat.add_assoc b _ x).symm)

end Propagation

open Propagation

/-- The gap is the same either way. -/
theorem gap_comm (a b : Nat) : gap a b = gap b a := Nat.add_comm _ _

/-- An amount has no gap from itself. -/
theorem gap_self (a : Nat) : gap a a = 0 :=
  (congrArg (· + (a - a)) (Nat.sub_self a)).trans ((Nat.zero_add _).trans (Nat.sub_self a))

/-- The gap of an amount from nothing is the amount. -/
theorem gap_zero (a : Nat) : gap a 0 = a :=
  (congrArg (a - 0 + ·) (Nat.zero_sub a)).trans ((Nat.add_zero _).trans (Nat.sub_zero a))

/-- An amount with `m` added is `m` from the amount. -/
theorem gap_add_self (a m : Nat) : gap (a + m) a = m :=
  (congrArg (a + m - a + ·) (sub_eq_zero_of_le (Nat.le_add_right a m))).trans
    ((Nat.add_zero _).trans (Naturals.add_sub_cancel_left a m))

/-- Each amount is at most the other with the gap added. -/
theorem le_add_gap (a b : Nat) : a ≤ b + gap a b :=
  Nat.le_trans (Nat.le_add_right a (b - a))
    (Nat.le_trans (Nat.le_of_eq (add_sub_turn a b).symm)
      (Nat.add_le_add_left (Nat.le_add_right (a - b) (b - a)) b))

/-- The gap is at most `m` where each amount is at most the other with `m` added. -/
theorem gap_le_of {a b m : Nat} (ab : a ≤ b + m) (ba : b ≤ a + m) : gap a b ≤ m :=
  match Nat.le_total a b with
  | .inl le =>
    Nat.le_trans
      (Nat.le_of_eq ((congrArg (· + (b - a)) (sub_eq_zero_of_le le)).trans (Nat.zero_add _)))
      (Naturals.sub_le_of_le_add ba)
  | .inr le =>
    Nat.le_trans
      (Nat.le_of_eq ((congrArg ((a - b) + ·) (sub_eq_zero_of_le le)).trans (Nat.add_zero _)))
      (Naturals.sub_le_of_le_add ab)

/-- **The gap, by bounds.** The gap of two amounts is at most `m` exactly where each is at most
the other with `m` added. -/
theorem gap_le_iff {a b m : Nat} : gap a b ≤ m ↔ a ≤ b + m ∧ b ≤ a + m :=
  ⟨fun le => ⟨Nat.le_trans (le_add_gap a b) (Nat.add_le_add_left le b),
     Nat.le_trans (le_add_gap b a)
       (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (gap_comm b a)) le) a)⟩,
   fun both => gap_le_of both.1 both.2⟩

/-- Two amounts have no gap exactly where they are the same. -/
theorem gap_eq_zero_iff {a b : Nat} : gap a b = 0 ↔ a = b :=
  ⟨fun zero => Nat.le_antisymm
      (Nat.le_trans (le_add_gap a b)
        (Nat.le_of_eq ((congrArg (b + ·) zero).trans (Nat.add_zero b))))
      (Nat.le_trans (le_add_gap b a)
        (Nat.le_of_eq ((congrArg (a + ·) ((gap_comm b a).trans zero)).trans (Nat.add_zero a)))),
   fun same => same ▸ gap_self a⟩

/-- The gap of two amounts is at most their gaps from a third. -/
theorem gap_triangle (a b c : Nat) : gap a c ≤ gap a b + gap b c :=
  gap_le_of
    (Nat.le_trans (le_add_gap a b)
      (Nat.le_trans (Nat.add_le_add_right (le_add_gap b c) (gap a b))
        (Nat.le_of_eq ((Nat.add_assoc c (gap b c) (gap a b)).trans
          (congrArg (c + ·) (Nat.add_comm (gap b c) (gap a b)))))))
    (Nat.le_trans (le_add_gap c b)
      (Nat.le_trans (Nat.add_le_add_right (le_add_gap b a) (gap c b))
        (Nat.le_of_eq ((Nat.add_assoc a (gap b a) (gap c b)).trans
          (congrArg (a + ·) ((congrArg (· + gap c b) (gap_comm b a)).trans
            (congrArg (gap a b + ·) (gap_comm c b))))))))

/-- The gap of two sums is at most the sum of the gaps. -/
theorem gap_add (a b c d : Nat) : gap (a + b) (c + d) ≤ gap a c + gap b d :=
  gap_le_of
    (Nat.le_trans (Nat.add_le_add (le_add_gap a c) (le_add_gap b d))
      (Nat.le_of_eq (Nat.add_add_add_comm c (gap a c) d (gap b d))))
    (Nat.le_trans (Nat.add_le_add (le_add_gap c a) (le_add_gap d b))
      (Nat.le_of_eq ((Nat.add_add_add_comm a (gap c a) b (gap d b)).trans
        (congrArg (a + b + ·) ((congrArg (· + gap d b) (gap_comm c a)).trans
          (congrArg (gap a c + ·) (gap_comm d b)))))))

/-- Multiplying both amounts multiplies the gap. -/
theorem gap_mul_le (k a b : Nat) : gap (k * a) (k * b) ≤ k * gap a b :=
  gap_le_of
    (Nat.le_trans (Nat.mul_le_mul_left k (le_add_gap a b))
      (Nat.le_of_eq (Nat.left_distrib k b (gap a b))))
    (Nat.le_trans (Nat.mul_le_mul_left k (le_add_gap b a))
      (Nat.le_of_eq ((Nat.left_distrib k a (gap b a)).trans
        (congrArg (k * a + k * ·) (gap_comm b a)))))

/-- The gap of two totals is at most the total of the gaps. -/
theorem gap_total {α : Type} (p q : α → Nat) :
    ∀ as : List α, gap (total as p) (total as q) ≤ total as fun a => gap (p a) (q a)
  | [] => Nat.le_of_eq (gap_self 0)
  | a :: as => Nat.le_trans (gap_add (p a) (total as p) (q a) (total as q))
      (Nat.add_le_add_left (gap_total p q as) _)

/-- **Two balances.** Where `a₁ + x = a₀ + y` and `b₁ + x' = b₀ + y'`, the gap after is at most
the gap before with the gaps of what is taken and of what is given. -/
theorem gap_of_balances {a₀ a₁ x y b₀ b₁ x' y' : Nat} (bal : a₁ + x = a₀ + y)
    (bal' : b₁ + x' = b₀ + y') : gap a₁ b₁ ≤ gap a₀ b₀ + (gap x x' + gap y y') :=
  have one : ∀ {a₀ a₁ x y b₀ b₁ x' y' : Nat}, a₁ + x = a₀ + y → b₁ + x' = b₀ + y' →
      a₁ ≤ b₁ + (gap a₀ b₀ + (gap x x' + gap y y')) :=
    fun {a₀ a₁ x y b₀ b₁ x' y'} bal bal' =>
      le_of_add_le_add_right x
        (calc a₁ + x = a₀ + y := bal
          _ ≤ (b₀ + gap a₀ b₀) + (y' + gap y y') :=
            Nat.add_le_add (le_add_gap a₀ b₀) (le_add_gap y y')
          _ = (b₀ + y') + (gap a₀ b₀ + gap y y') := Nat.add_add_add_comm _ _ _ _
          _ = (b₁ + x') + (gap a₀ b₀ + gap y y') := congrArg (· + _) bal'.symm
          _ ≤ (b₁ + (x + gap x x')) + (gap a₀ b₀ + gap y y') :=
            Nat.add_le_add_right (Nat.add_le_add_left
              (Nat.le_trans (le_add_gap x' x)
                (Nat.le_of_eq (congrArg (x + ·) (gap_comm x' x)))) b₁) _
          _ = b₁ + (gap a₀ b₀ + (gap x x' + gap y y')) + x := rearrange _ _ _ _ _)
  gap_le_of (one bal bal')
    (Nat.le_trans (one bal' bal)
      (Nat.le_of_eq (congrArg (a₁ + ·) ((congrArg (· + _) (gap_comm b₀ a₀)).trans
        (congrArg (gap a₀ b₀ + ·) ((congrArg (· + _) (gap_comm x' x)).trans
          (congrArg (gap x x' + ·) (gap_comm y' y))))))))

/-! ## Difference arrives as exchanged difference -/

section Arrival

variable {L L' : Flow F C} {W W' : Web F C}

/-- The gap between what a formation exchanges with a condition across the step from `t` in two
flows: the gap of what it takes with the gap of what it gives. -/
def Flow.exchangeGap (L L' : Flow F C) (t : Nat) (h : F) (c : C) : Nat :=
  gap (L.take t h c) (L'.take t h c) + gap (L.give t h c) (L'.give t h c)

/-- **The difference of levels changes by the difference exchanged, exactly.** In two balanced
flows, the first's level of a condition after a step and the second's before, with what the first
takes from it and the second gives it, add up to the second's level after and the first's before,
with what the second takes and the first gives. -/
theorem levels_step_exact (balances : L.Balances W) (balances' : L'.Balances W') (t : Nat)
    (c : C) :
    W.level (t + 1) c + W'.level t c + (L.taken t c + L'.given t c) =
      W'.level (t + 1) c + W.level t c + (L'.taken t c + L.given t c) :=
  (Nat.add_add_add_comm _ _ _ _).trans
    ((congrArg (· + (W'.level t c + L'.given t c)) (balances t c)).trans
      ((congrArg (W.level t c + L.given t c + ·) (balances' t c).symm).trans
        ((Nat.add_comm _ _).trans (Nat.add_add_add_comm _ _ _ _).symm)))

/-- **Difference arrives as exchanged difference.** In two balanced flows with the same formations
present across the step from `t`, a condition's gap across the step is at most its gap before
with the gaps of what each formation present exchanges with it. -/
theorem gap_step (balances : L.Balances W) (balances' : L'.Balances W') {t : Nat}
    (present : L.present t = L'.present t) (c : C) :
    gap (W.level (t + 1) c) (W'.level (t + 1) c) ≤
      gap (W.level t c) (W'.level t c) + total (L.present t) fun h => L.exchangeGap L' t h c :=
  have taken : L'.taken t c = total (L.present t) fun h => L'.take t h c :=
    congrArg (fun as => total as fun h => L'.take t h c) present.symm
  have given : L'.given t c = total (L.present t) fun h => L'.give t h c :=
    congrArg (fun as => total as fun h => L'.give t h c) present.symm
  Nat.le_trans (gap_of_balances (balances t c) (balances' t c))
    (Nat.add_le_add_left
      (Nat.le_trans
        (Nat.add_le_add
          (Nat.le_trans (Nat.le_of_eq (congrArg (gap (L.taken t c)) taken))
            (gap_total _ _ (L.present t)))
          (Nat.le_trans (Nat.le_of_eq (congrArg (gap (L.given t c)) given))
            (gap_total _ _ (L.present t))))
        (Nat.le_of_eq (total_add _ _ (L.present t)).symm)) _)

/-- Where a formation takes and gives alike in two flows, its exchange has no gap. -/
theorem Flow.exchangeGap_of_alike {t : Nat} {h : F} {c : C}
    (take : L.take t h c = L'.take t h c) (give : L.give t h c = L'.give t h c) :
    L.exchangeGap L' t h c = 0 :=
  (congrArg (fun x => x + gap (L.give t h c) (L'.give t h c)) (gap_eq_zero_iff.mpr take)).trans
    ((Nat.zero_add _).trans (gap_eq_zero_iff.mpr give))

/-- Where every formation present exchanges alike, no difference arrives across the step. -/
theorem gap_step_of_alike (balances : L.Balances W) (balances' : L'.Balances W') {t : Nat}
    (present : L.present t = L'.present t) {c : C}
    (alike : ∀ h, h ∈ L.present t → L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c) :
    gap (W.level (t + 1) c) (W'.level (t + 1) c) ≤ gap (W.level t c) (W'.level t c) :=
  Nat.le_trans (gap_step balances balances' present c)
    (Nat.le_of_eq ((congrArg (gap (W.level t c) (W'.level t c) + ·)
      (total_eq_zero fun h mem => Flow.exchangeGap_of_alike (alike h mem).1 (alike h mem).2)).trans
      (Nat.add_zero _)))

end Arrival

/-! ## Coupling strength: how much an exchange responds to a level -/

namespace ExchangeLaw

variable (law : ExchangeLaw F C)

/-- The gap between what the law has `h` exchange with `c` across the step from `t` under two
histories. -/
def exchangeGap (t : Nat) (h : F) (c : C) (l l' : Nat → C → Nat) : Nat :=
  gap (law.take t h l c) (law.take t h l' c) + gap (law.give t h l c) (law.give t h l' c)

/-- **Coupling strength.** Across the step from `t`, `h`'s exchange with `c` is coupled to the level
of `d` at step `s` with strength at most `k`: under any two histories differing at most in that one
level, what it takes and what it gives differ in all by at most `k` times that level's gap. -/
def RespondsWithin (t : Nat) (h : F) (c : C) (s : Nat) (d : C) (k : Nat) : Prop :=
  ∀ l l' : Nat → C → Nat, (∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) →
    law.exchangeGap t h c l l' ≤ k * gap (l s d) (l' s d)

end ExchangeLaw

section Strength

variable {law : ExchangeLaw F C}

/-- Under one history the exchange has no gap. -/
theorem ExchangeLaw.exchangeGap_self (t : Nat) (h : F) (c : C) (l : Nat → C → Nat) :
    law.exchangeGap t h c l l = 0 :=
  (congrArg (fun x => x + gap (law.give t h l c) (law.give t h l c)) (gap_self _)).trans
    ((Nat.zero_add _).trans (gap_self _))

/-- The exchange's gap between two histories is at most its gaps from a third. -/
theorem ExchangeLaw.exchangeGap_triangle (t : Nat) (h : F) (c : C) (l l' l'' : Nat → C → Nat) :
    law.exchangeGap t h c l l'' ≤ law.exchangeGap t h c l l' + law.exchangeGap t h c l' l'' :=
  Nat.le_trans (Nat.add_le_add (gap_triangle _ _ _) (gap_triangle _ _ _))
    (Nat.le_of_eq (Nat.add_add_add_comm _ _ _ _))

/-- Where the law gives alike, its exchange has no gap. -/
theorem ExchangeLaw.exchangeGap_of_alike {t : Nat} {h : F} {l l' : Nat → C → Nat}
    (alike : law.GivesAlike t h l l') (c : C) : law.exchangeGap t h c l l' = 0 :=
  (congrArg (fun x => x + gap (law.give t h l c) (law.give t h l' c))
    (gap_eq_zero_iff.mpr (alike c).1)).trans
    ((Nat.zero_add _).trans (gap_eq_zero_iff.mpr (alike c).2))

/-- Where the exchange has no gap with any condition, the law gives alike. -/
theorem ExchangeLaw.alike_of_exchangeGap {t : Nat} {h : F} {l l' : Nat → C → Nat}
    (none : ∀ c, law.exchangeGap t h c l l' = 0) : law.GivesAlike t h l l' :=
  fun c =>
    ⟨gap_eq_zero_iff.mp (Nat.eq_zero_of_add_eq_zero_right (none c)),
     gap_eq_zero_iff.mp (Nat.eq_zero_of_add_eq_zero_left (none c))⟩

/-- A larger strength bounds as well. -/
theorem ExchangeLaw.RespondsWithin.mono {t : Nat} {h : F} {c : C} {s : Nat} {d : C} {k k' : Nat}
    (within : law.RespondsWithin t h c s d k) (le : k ≤ k') : law.RespondsWithin t h c s d k' :=
  fun l l' off => Nat.le_trans (within l l' off) (Nat.mul_le_mul_right _ le)

/-- A law of what has stood is coupled to no level after the step: any strength bounds it. -/
theorem ExchangeLaw.Nonanticipating.respondsWithin_later (na : law.Nonanticipating) {t s : Nat}
    (later : t < s) (h : F) (c : C) (d : C) (k : Nat) : law.RespondsWithin t h c s d k :=
  fun l l' off =>
    Nat.le_trans
      (Nat.le_of_eq (ExchangeLaw.exchangeGap_of_alike
        (na t h l l' fun s' le e => off s' e fun same =>
          Nat.lt_irrefl t (Nat.lt_of_lt_of_le later (same.1 ▸ le))) c))
      (Nat.zero_le _)

end Strength

/-! ## Strengths add up over levels changed one at a time -/

namespace Propagation

/-- A step up to `t` is among the first `t + 1` steps. -/
theorem mem_steps_upto {s t : Nat} (le : s ≤ t) : s ∈ steps 0 (t + 1) :=
  steps_of_within (Nat.zero_le s)
    (Nat.lt_of_le_of_lt le (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
      (Nat.le_of_eq (Nat.zero_add (t + 1)).symm)))

/-- A step among the first `t + 1` steps is up to `t`. -/
theorem le_of_mem_steps_upto {s t : Nat} (mem : s ∈ steps 0 (t + 1)) : s ≤ t :=
  Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (between_of_mem_steps mem).2
    (Nat.le_of_eq (Nat.zero_add (t + 1))))

/-- A level at `s` of listed conditions is at `s`, of a listed condition. -/
theorem of_mem_map_pair {s : Nat} {x : Nat × C} :
    ∀ {ds : List C}, x ∈ (ds.map fun e => (s, e)) → x.1 = s ∧ x.2 ∈ ds
  | d :: ds, mem => by
    have unfolded : x ∈ (s, d) :: ds.map fun e => (s, e) := mem
    cases unfolded with
    | head => exact ⟨rfl, .head _⟩
    | tail _ later =>
      have inner := of_mem_map_pair later
      exact ⟨inner.1, .tail _ inner.2⟩

end Propagation

/-- The levels `(s, d)` with `s` among `ss` and `d` among `ds`. -/
def cellsOf (ds : List C) : List Nat → List (Nat × C)
  | [] => []
  | s :: ss => (ds.map fun d => (s, d)) ++ cellsOf ds ss

/-- A listed step with a listed condition is a listed level. -/
theorem mem_cellsOf {ds : List C} {s : Nat} {d : C} (inDs : d ∈ ds) :
    ∀ {ss : List Nat}, s ∈ ss → (s, d) ∈ cellsOf ds ss
  | _ :: _, .head _ => List.mem_append_left _ (prodMk_mem_map inDs)
  | _ :: _, .tail _ mem => List.mem_append_right _ (mem_cellsOf inDs mem)

/-- A listed level is at a listed step, of a listed condition. -/
theorem of_mem_cellsOf {ds : List C} {x : Nat × C} :
    ∀ {ss : List Nat}, x ∈ cellsOf ds ss → x.1 ∈ ss ∧ x.2 ∈ ds
  | s :: ss, mem =>
    match mem_append_cases mem with
    | .inl here =>
      have pair := Propagation.of_mem_map_pair here
      ⟨pair.1 ▸ .head ss, pair.2⟩
    | .inr later =>
      have inner := of_mem_cellsOf later
      ⟨.tail s inner.1, inner.2⟩

/-- A total over the listed levels is a total over the steps of a total over the conditions. -/
theorem total_cellsOf (q : Nat × C → Nat) (ds : List C) :
    ∀ ss : List Nat, total (cellsOf ds ss) q = total ss fun s => total ds fun d => q (s, d)
  | [] => rfl
  | s :: ss =>
    (total_append q (cellsOf ds ss) (ds.map fun d => (s, d))).trans
      ((congrArg (· + total (cellsOf ds ss) q) (total_map (fun d => (s, d)) q ds)).trans
        (congrArg (total ds (fun d => q (s, d)) + ·) (total_cellsOf q ds ss)))

section Combine

variable {law : ExchangeLaw F C} [DecidableEq C]

/-- `l` with `l'` mixed in at the listed levels, each a step with a condition. -/
def mixCells (l l' : Nat → C → Nat) : List (Nat × C) → Nat → C → Nat
  | [] => l
  | (s, d) :: rest => fun s' e => if s' = s ∧ e = d then l' s' e else mixCells l l' rest s' e

/-- A mixed level is one of the two. -/
theorem mixCells_either (l l' : Nat → C → Nat) :
    ∀ (cells : List (Nat × C)) (s : Nat) (e : C),
      mixCells l l' cells s e = l s e ∨ mixCells l l' cells s e = l' s e
  | [], _, _ => .inl rfl
  | (s, d) :: rest, s', e =>
    match (inferInstance : Decidable (s' = s ∧ e = d)) with
    | isTrue here => .inr (if_pos here)
    | isFalse off =>
      match mixCells_either l l' rest s' e with
      | .inl one => .inl ((if_neg off).trans one)
      | .inr other => .inr ((if_neg off).trans other)

/-- At a listed level the mixture is the other history. -/
theorem mixCells_listed (l l' : Nat → C → Nat) :
    ∀ {cells : List (Nat × C)} {s : Nat} {e : C}, (s, e) ∈ cells →
      mixCells l l' cells s e = l' s e
  | (s₀, d₀) :: _, s, e, mem =>
    match (inferInstance : Decidable (s = s₀ ∧ e = d₀)) with
    | isTrue here => if_pos here
    | isFalse off =>
      (if_neg off).trans (mixCells_listed l l'
        (match mem_cons_cases mem with
          | .inl same => absurd ⟨congrArg Prod.fst same, congrArg Prod.snd same⟩ off
          | .inr later => later))

/-- **Strengths add up along levels changed one at a time.** Mixing the other history in level by
level, the exchange's gap is at most the sum, over the levels mixed in, of each strength times that
level's gap. -/
theorem ExchangeLaw.exchangeGap_le_mixCells {t : Nat} {h : F} {c : C} (k : Nat → C → Nat)
    (l l' : Nat → C → Nat) :
    ∀ cells : List (Nat × C), (∀ x, x ∈ cells → law.RespondsWithin t h c x.1 x.2 (k x.1 x.2)) →
      law.exchangeGap t h c l (mixCells l l' cells) ≤
        total cells fun x => k x.1 x.2 * gap (l x.1 x.2) (l' x.1 x.2)
  | [], _ => Nat.le_of_eq (ExchangeLaw.exchangeGap_self t h c l)
  | (s, d) :: rest, strengths =>
    have before := ExchangeLaw.exchangeGap_le_mixCells k l l' rest
      fun x mem => strengths x (.tail _ mem)
    have mixed : mixCells l l' ((s, d) :: rest) s d = l' s d := if_pos ⟨rfl, rfl⟩
    have level : gap (mixCells l l' rest s d) (mixCells l l' ((s, d) :: rest) s d) ≤
        gap (l s d) (l' s d) :=
      match mixCells_either l l' rest s d with
      | .inl one => Nat.le_of_eq
          ((congrArg (fun x => gap x (mixCells l l' ((s, d) :: rest) s d)) one).trans
            (congrArg (gap (l s d)) mixed))
      | .inr other => Nat.le_trans
          (Nat.le_of_eq
            ((congrArg (fun x => gap x (mixCells l l' ((s, d) :: rest) s d)) other).trans
            ((congrArg (gap (l' s d)) mixed).trans (gap_self _))))
          (Nat.zero_le _)
    have one : law.exchangeGap t h c (mixCells l l' rest) (mixCells l l' ((s, d) :: rest)) ≤
        k s d * gap (l s d) (l' s d) :=
      Nat.le_trans (strengths (s, d) (.head rest) _ _ fun _ _ off => (if_neg off).symm)
        (Nat.mul_le_mul_left _ level)
    Nat.le_trans (ExchangeLaw.exchangeGap_triangle t h c l _ _)
      (Nat.le_trans (Nat.add_le_add before one) (Nat.le_of_eq (Nat.add_comm _ _)))

/-- **Strengths add up over the levels that differ.** For a law of what has stood, let `h`'s
exchange with `c` across the step from `t` be coupled to the level of each `d` of a list at each
step `s` up to `t` with strength at most `k s d`. Under two histories that up to `t` differ only on
conditions of the list, the exchange's gap is at most the sum, over those steps and conditions, of
each strength times that level's gap. -/
theorem ExchangeLaw.exchangeGap_le_strengths (na : law.Nonanticipating) {t : Nat} {h : F} {c : C}
    {ds : List C} (k : Nat → C → Nat)
    (strengths : ∀ s d, s ≤ t → d ∈ ds → law.RespondsWithin t h c s d (k s d))
    {l l' : Nat → C → Nat} (covers : ∀ s, s ≤ t → ∀ e, l s e ≠ l' s e → e ∈ ds) :
    law.exchangeGap t h c l l' ≤
      total (steps 0 (t + 1)) fun s => total ds fun d => k s d * gap (l s d) (l' s d) :=
  have toMix := ExchangeLaw.exchangeGap_le_mixCells k l l' (cellsOf ds (steps 0 (t + 1)))
    fun x mem =>
      have both := of_mem_cellsOf mem
      strengths x.1 x.2 (Propagation.le_of_mem_steps_upto both.1) both.2
  have agree : AgreeUpTo (mixCells l l' (cellsOf ds (steps 0 (t + 1)))) l' t :=
    fun s le e =>
      match Nat.decEq (l s e) (l' s e) with
      | isTrue same =>
        match mixCells_either l l' (cellsOf ds (steps 0 (t + 1))) s e with
        | .inl one => one.trans same
        | .inr other => other
      | isFalse differ =>
        mixCells_listed l l' (mem_cellsOf (covers s le e differ) (Propagation.mem_steps_upto le))
  have last : law.exchangeGap t h c (mixCells l l' (cellsOf ds (steps 0 (t + 1)))) l' = 0 :=
    ExchangeLaw.exchangeGap_of_alike (na t h _ _ agree) c
  Nat.le_trans (ExchangeLaw.exchangeGap_triangle t h c l _ l')
    (Nat.le_trans (Nat.add_le_add toMix (Nat.le_of_eq last))
      (Nat.le_of_eq ((Nat.add_zero _).trans
        (total_cellsOf (fun x => k x.1 x.2 * gap (l x.1 x.2) (l' x.1 x.2)) ds _))))

/-- With every condition listed, the strengths bound the exchange's gap under any two histories. -/
theorem ExchangeLaw.exchangeGap_le_strengths_listed (na : law.Nonanticipating) {t : Nat} {h : F}
    {c : C} {cs : List C} (every : ∀ e, e ∈ cs) (k : Nat → C → Nat)
    (strengths : ∀ s d, s ≤ t → law.RespondsWithin t h c s d (k s d)) (l l' : Nat → C → Nat) :
    law.exchangeGap t h c l l' ≤
      total (steps 0 (t + 1)) fun s => total cs fun d => k s d * gap (l s d) (l' s d) :=
  ExchangeLaw.exchangeGap_le_strengths na k (fun s d le _ => strengths s d le)
    fun _ _ e _ => every e

/-- **A part's share of a move.** For a law of what has stood, with every condition among the part's
`ps` or the rest's `rs`, the gap of `h`'s exchange is at most the part's share, its strengths times
the part's change, with the rest's share. -/
theorem ExchangeLaw.exchangeGap_le_shares (na : law.Nonanticipating) {t : Nat} {h : F} {c : C}
    {ps rs : List C} (every : ∀ e, e ∈ ps ∨ e ∈ rs) (k : Nat → C → Nat)
    (strengths : ∀ s d, s ≤ t → law.RespondsWithin t h c s d (k s d)) (l l' : Nat → C → Nat) :
    law.exchangeGap t h c l l' ≤
      (total (steps 0 (t + 1)) fun s => total ps fun d => k s d * gap (l s d) (l' s d)) +
        total (steps 0 (t + 1)) fun s => total rs fun d => k s d * gap (l s d) (l' s d) :=
  Nat.le_trans
    (ExchangeLaw.exchangeGap_le_strengths na (ds := ps ++ rs) k (fun s d le _ => strengths s d le)
      fun _ _ e _ =>
        match every e with
        | .inl inPart => List.mem_append_left rs inPart
        | .inr inRest => List.mem_append_right ps inRest)
    (Nat.le_of_eq ((total_congr_on fun s _ =>
        total_append (fun d => k s d * gap (l s d) (l' s d)) rs ps).trans
      (total_add _ _ _)))

/-- **Strength zero is insensitivity.** For a law of what has stood, `h`'s exchange across the step
from `t` is insensitive to `d` exactly where it is coupled to the level of `d` at every step up to
`t` with strength zero, with every condition. -/
theorem ExchangeLaw.insensitiveAt_iff_strength_zero (na : law.Nonanticipating) {t : Nat} {h : F}
    {d : C} : law.InsensitiveAt t h d ↔ ∀ c s, s ≤ t → law.RespondsWithin t h c s d 0 :=
  ⟨fun insensitive c _ _ l l' off =>
    Nat.le_trans
      (Nat.le_of_eq (ExchangeLaw.exchangeGap_of_alike
        (insensitive l l' fun s' _ e differ => off s' e fun both => differ both.2) c))
      (Nat.zero_le _),
   fun zero _ _ off =>
    ExchangeLaw.alike_of_exchangeGap fun c =>
      Nat.eq_zero_of_le_zero
        (Nat.le_trans
          (ExchangeLaw.exchangeGap_le_strengths na (ds := [d]) (fun _ _ => 0)
            (fun s _ le mem =>
              match mem_cons_cases mem with
              | .inl same => same ▸ zero c s le
              | .inr nothing => nomatch nothing)
            fun s le e differ =>
              match (inferInstance : Decidable (e = d)) with
              | isTrue same => same ▸ .head []
              | isFalse other => absurd (off s le e other) differ)
          (Nat.le_of_eq (total_eq_zero fun _ _ =>
            total_eq_zero fun _ _ => Nat.zero_mul _)))⟩

end Combine

/-! ## The carried amount -/

/-- **The carrying law.** With coupling strengths `k` and the part's gaps `σ`: the part gives `σ`,
each formation outside it gives each condition what its strengths make of the levels so far, and
nothing is taken. It takes nothing, so it is not gainless; the bound is attained over all laws,
not shown over gainless ones. -/
def ExchangeLaw.carrying (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) : ExchangeLaw F C :=
  ⟨fun _ _ _ _ => 0,
   fun t h l c => bif part h then σ t h c else
     total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d * l s d⟩

/-- **The carried amount.** The levels the carrying law generates from the starting gaps `δ`, with
the formations present: how much difference the strengths carry from `δ` and the part's gaps `σ`.
-/
def carried (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) : Nat → C → Nat :=
  (ExchangeLaw.carrying cs part σ k).levels present δ

section Carried

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- What the carrying law has a formation give, read from the levels up to the step. -/
def carriedGive (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (t : Nat) (h : F) (c : C) (l : Nat → C → Nat) : Nat :=
  bif part h then σ t h c else
    total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d * l s d

/-- The carrying law reads what has stood. -/
theorem ExchangeLaw.carrying_nonanticipating :
    (ExchangeLaw.carrying cs part σ k).Nonanticipating :=
  fun t h _ _ agree c =>
    ⟨rfl, congrArg (cond (part h) (σ t h c))
      (total_congr_on fun s mem => total_congr_on fun d _ =>
        congrArg (k t h c s d * ·) (agree s (Propagation.le_of_mem_steps_upto mem) d))⟩

/-- The carried amount starts at the starting gaps. -/
theorem carried_zero (c : C) : carried cs part σ k present δ 0 c = δ c := rfl

/-- **The carried amount, step by step.** Across each step the carried amount at a condition grows
by what the part's gaps and the strengths make of the amounts carried so far. -/
theorem carried_succ (t : Nat) (c : C) :
    carried cs part σ k present δ (t + 1) c =
      carried cs part σ k present δ t c +
        total (present t) fun h => carriedGive cs part σ k t h c (carried cs part σ k present δ) :=
  have totals := ExchangeLaw.totals_under (start := δ)
    (ExchangeLaw.carrying_nonanticipating (cs := cs) (part := part) (σ := σ) (k := k)) t c
  ((ExchangeLaw.carrying cs part σ k).levels_succ (present := present) (start := δ) t c).trans
    ((congrArg (fun x => _ + _ - x) (totals.1.trans (total_zero (present t)))).trans
      ((Nat.sub_zero _).trans (congrArg (carried cs part σ k present δ t c + ·) totals.2)))

/-- The carried amount never falls. -/
theorem carried_le_succ (t : Nat) (c : C) :
    carried cs part σ k present δ t c ≤ carried cs part σ k present δ (t + 1) c :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (carried_succ t c).symm)

end Carried

namespace Propagation

/-- A web whose levels are `l`, every formation active, nothing required, needed or drawn. -/
def webOf (l : Nat → C → Nat) : Web F C :=
  ⟨l, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

end Propagation

section Bound

variable {law : ExchangeLaw F C} [DecidableEq C] {L L' : Flow F C} {W W' : Web F C}
  {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **How much difference arrives is at most what the strengths carry.** Let two balanced flows,
with the formations `present`, start within gaps `δ`; let the part's exchange differ by at most `σ`,
and the rest follow, in both, one law of what has stood whose exchanges are coupled to every level
up to their step with strengths at most `k`. With every condition listed, each condition's gap at
every step is at most the carried amount. -/
theorem gap_le_carried (na : law.Nonanticipating) (every : ∀ c, c ∈ cs)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (onL : ∀ t, L.present t = present t) (onL' : ∀ t, L'.present t = present t)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (acts : ∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c)
    (start : ∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) :
    ∀ t c, gap (W.level t c) (W'.level t c) ≤ carried cs part σ k present δ t c :=
  have upto : ∀ t s, s ≤ t → ∀ c,
      gap (W.level s c) (W'.level s c) ≤ carried cs part σ k present δ s c := by
    intro t
    induction t with
    | zero =>
      intro s le c
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      exact start c
    | succ t ih =>
      intro s le c
      cases le_succ_cases le with
      | inl before => exact ih s before c
      | inr now =>
        subst now
        have each : ∀ h, h ∈ L.present t →
            L.exchangeGap L' t h c ≤
              carriedGive cs part σ k t h c (carried cs part σ k present δ) := by
          intro h _
          match hp : part h with
          | true =>
            exact Nat.le_trans (acts t h c hp)
              (Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp).symm)
          | false =>
            have rest : L.exchangeGap L' t h c = law.exchangeGap t h c W.level W'.level :=
              (congrArg (fun x => gap x (L'.take t h c) + gap (L.give t h c) (L'.give t h c))
                  (follows h hp t c).1).trans
                ((congrArg (fun x =>
                    gap (law.take t h W.level c) x + gap (L.give t h c) (L'.give t h c))
                  (follows' h hp t c).1).trans
                ((congrArg (fun x => gap (law.take t h W.level c) (law.take t h W'.level c) +
                    gap x (L'.give t h c)) (follows h hp t c).2).trans
                  (congrArg (fun x => gap (law.take t h W.level c) (law.take t h W'.level c) +
                    gap (law.give t h W.level c) x) (follows' h hp t c).2)))
            refine Nat.le_trans (Nat.le_of_eq rest)
              (Nat.le_trans (ExchangeLaw.exchangeGap_le_strengths_listed na every (k t h c)
                (fun s d le => strengths t h c s d hp le) W.level W'.level) ?_)
            refine Nat.le_trans (total_le _ fun s mem => total_le _ fun d _ =>
              Nat.mul_le_mul_left _ (ih s (Propagation.le_of_mem_steps_upto mem) d)) ?_
            exact Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp).symm
        calc gap (W.level (t + 1) c) (W'.level (t + 1) c)
            ≤ gap (W.level t c) (W'.level t c) +
                total (L.present t) fun h => L.exchangeGap L' t h c :=
              gap_step balances balances' ((onL t).trans (onL' t).symm) c
          _ ≤ carried cs part σ k present δ t c +
                total (L.present t) fun h =>
                  carriedGive cs part σ k t h c (carried cs part σ k present δ) :=
              Nat.add_le_add (ih t (Nat.le_refl t) c) (total_le _ each)
          _ = carried cs part σ k present δ (t + 1) c :=
              (congrArg (fun as => carried cs part σ k present δ t c +
                total as fun h => carriedGive cs part σ k t h c (carried cs part σ k present δ))
                (onL t)).trans (carried_succ t c).symm
  fun t c => upto t t (Nat.le_refl t) c

end Bound

/-! ## The carried amount is attained -/

namespace Propagation

/-- A choice between the same two is that one. -/
theorem cond_same (b : Bool) (x : Nat) : cond b x x = x :=
  match b with
  | true => rfl
  | false => rfl

end Propagation

section Attained

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Nothing is carried from nothing.** With no starting gaps and no gaps in the part, the
carried amount is nothing at every step. -/
theorem carried_quiet (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) :
    ∀ t c, carried cs part (fun _ _ _ => 0) k present (fun _ => 0) t c = 0 :=
  have upto : ∀ t s, s ≤ t → ∀ c,
      carried cs part (fun _ _ _ => 0) k present (fun _ => 0) s c = 0 := by
    intro t
    induction t with
    | zero =>
      intro s le c
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      rfl
    | succ t ih =>
      intro s le c
      cases le_succ_cases le with
      | inl before => exact ih s before c
      | inr now =>
        subst now
        refine (carried_succ t c).trans ?_
        refine (congrArg (· + _) (ih t (Nat.le_refl t) c)).trans ((Nat.zero_add _).trans ?_)
        exact total_eq_zero fun h _ =>
          (congrArg (cond (part h) 0)
            (total_eq_zero fun s mem => total_eq_zero fun d _ =>
              (congrArg (k t h c s d * ·)
                (ih s (Propagation.le_of_mem_steps_upto mem) d)).trans (Nat.mul_zero _))).trans
            (Propagation.cond_same (part h) 0)
  fun t c => upto t t (Nat.le_refl t) c

/-- The course the carrying law generates from `δ` balances, its levels being the carried amount. -/
theorem carrying_balances :
    ((ExchangeLaw.carrying cs part σ k).course present δ).Balances
      (Propagation.webOf (carried cs part σ k present δ)) :=
  (ExchangeLaw.course_balances_iff (ExchangeLaw.carrying_nonanticipating (cs := cs) (part := part)
      (σ := σ) (k := k)) (Propagation.webOf (fun _ _ => 0))).mpr
    fun t _ => Nat.le_trans (Nat.le_of_eq (total_zero (present t))) (Nat.zero_le _)

/-- **The carried amount is attained.** Against the quiet course, generated from nothing with no
gaps in the part, the course the carrying law generates from `δ` with the part's gaps `σ` has, at
every step and condition, exactly the carried amount as its gap. -/
theorem carried_attained (t : Nat) (c : C) :
    gap (carried cs part σ k present δ t c)
        (carried cs part (fun _ _ _ => 0) k present (fun _ => 0) t c) =
      carried cs part σ k present δ t c :=
  (congrArg (gap _) (carried_quiet cs part k present t c)).trans (gap_zero _)

variable [DecidableEq C]

/-- **The carrying law has the coupling strengths `k`.** With each condition listed once, each
formation outside the part is coupled to the level of each condition at each step up to its own with
strength at most its `k`. -/
theorem ExchangeLaw.carrying_respondsWithin (distinct : Distinct cs) {t : Nat} {h : F}
    (out : part h = false) (c : C) (s : Nat) (d : C) :
    (ExchangeLaw.carrying cs part σ k).RespondsWithin t h c s d (k t h c s d) :=
  fun l l' off =>
    have apart : ∀ s' e, 0 < k t h c s' e * gap (l s' e) (l' s' e) → s' = s ∧ e = d :=
      fun s' e pos =>
        match (inferInstance : Decidable (s' = s ∧ e = d)) with
        | isTrue here => here
        | isFalse there => absurd pos (Nat.lt_irrefl 0 |> fun irr => fun lt => irr
            (Nat.lt_of_lt_of_le lt (Nat.le_of_eq ((congrArg (k t h c s' e * ·)
              (gap_eq_zero_iff.mpr (off s' e there))).trans (Nat.mul_zero _)))))
    have give : gap ((ExchangeLaw.carrying cs part σ k).give t h l c)
        ((ExchangeLaw.carrying cs part σ k).give t h l' c) ≤ k t h c s d * gap (l s d) (l' s d) :=
      calc gap ((ExchangeLaw.carrying cs part σ k).give t h l c)
            ((ExchangeLaw.carrying cs part σ k).give t h l' c)
          = gap (total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d * l s d)
              (total (steps 0 (t + 1)) fun s => total cs fun d => k t h c s d * l' s d) :=
            (congrArg (fun b => gap (cond b (σ t h c) _) (cond b (σ t h c) _)) out)
        _ ≤ total (steps 0 (t + 1)) fun s' => total cs fun e =>
              k t h c s' e * gap (l s' e) (l' s' e) :=
            Nat.le_trans (gap_total _ _ _) (total_le _ fun _ _ =>
              Nat.le_trans (gap_total _ _ _) (total_le _ fun _ _ => gap_mul_le _ _ _))
        _ ≤ total cs fun e => k t h c s e * gap (l s e) (l' s e) :=
            total_le_at (fun s' pos =>
              match total_pos cs pos with
              | ⟨e, _, positive⟩ => (apart s' e positive).1) (steps_distinct 0 (t + 1))
        _ ≤ k t h c s d * gap (l s d) (l' s d) :=
            total_le_at (fun e pos => (apart s e pos).2) distinct
    Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (gap_self 0)).trans (Nat.zero_add _))) give

/-- **The most difference that can arrive is the carried amount.** With each condition listed once:
for every law of what has stood whose exchanges outside the part are coupled with strengths at most
`k`, and every two balanced flows of it with the formations `present`, the part's exchange differing
by at most `σ` and the starting levels by at most `δ`, a condition's gap at `T` is at most `a`,
exactly where the carried amount there is at most `a`. -/
theorem most_difference_arrives (every : ∀ c, c ∈ cs) (distinct : Distinct cs) (T : Nat) (c : C)
    (a : Nat) :
    (∀ (law : ExchangeLaw F C) (L L' : Flow F C) (W W' : Web F C), law.Nonanticipating →
      L.Balances W → L'.Balances W' → (∀ t, L.present t = present t) →
      (∀ t, L'.present t = present t) → L.Follows law part W.level → L'.Follows law part W'.level →
      (∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d)) →
      (∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c) →
      (∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) →
      gap (W.level T c) (W'.level T c) ≤ a) ↔
      carried cs part σ k present δ T c ≤ a :=
  ⟨fun bound =>
    Nat.le_trans (Nat.le_of_eq (carried_attained T c).symm)
      (bound (ExchangeLaw.carrying cs part σ k)
        ((ExchangeLaw.carrying cs part σ k).course present δ)
        ((ExchangeLaw.carrying cs part (fun _ _ _ => 0) k).course present (fun _ => 0))
        (Propagation.webOf (carried cs part σ k present δ))
        (Propagation.webOf (carried cs part (fun _ _ _ => 0) k present (fun _ => 0)))
        ExchangeLaw.carrying_nonanticipating carrying_balances carrying_balances
        (fun _ => rfl) (fun _ => rfl)
        (ExchangeLaw.course_follows part)
        (fun h out t c => ⟨rfl,
          (congrArg (fun b => cond b 0 _) out).trans
            (congrArg (fun b => cond b (σ t h c) _) out).symm⟩)
        (fun _ _ c s d out _ => ExchangeLaw.carrying_respondsWithin distinct out c s d)
        (fun t h c inPart => Nat.le_of_eq
          ((congrArg (· + _) (gap_self 0)).trans ((Nat.zero_add _).trans
            ((congrArg (fun b => gap (cond b (σ t h c) _) (cond b 0 _)) inPart).trans
              (gap_zero _)))))
        (fun c => Nat.le_of_eq (gap_zero (δ c)))),
   fun le _ _ _ _ _ na balances balances' onL onL' follows follows' strengths acts start =>
    Nat.le_trans
      (gap_le_carried na every balances balances' onL onL' follows follows' strengths acts start
        T c) le⟩

end Attained

/-! ## Where the carried amount goes -/

/-- **Conveyed.** A gap is conveyed to a condition at a step: by a starting gap, by holding from the
step before, by a gap of the part present across the step before, or by a positive strength of a
formation present there from a level up to that step to which a gap was conveyed. -/
inductive Conveyed (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) : Nat → C → Prop
  | start {c : C} : 0 < δ c → Conveyed cs part σ k present δ 0 c
  | hold {t : Nat} {c : C} : Conveyed cs part σ k present δ t c →
      Conveyed cs part σ k present δ (t + 1) c
  | input {t : Nat} {h : F} {c : C} : h ∈ present t → part h = true → 0 < σ t h c →
      Conveyed cs part σ k present δ (t + 1) c
  | response {t : Nat} {h : F} {c : C} {s : Nat} {d : C} : h ∈ present t → part h = false →
      s ≤ t → d ∈ cs → 0 < k t h c s d → Conveyed cs part σ k present δ s d →
      Conveyed cs part σ k present δ (t + 1) c

namespace Propagation

/-- A positive product has positive factors. -/
theorem pos_of_mul_pos : ∀ {a b : Nat}, 0 < a * b → 0 < a ∧ 0 < b
  | 0, b, pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (Nat.zero_mul b))) (Nat.lt_irrefl 0)
  | a + 1, 0, pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (Nat.mul_zero (a + 1))))
      (Nat.lt_irrefl 0)
  | _ + 1, _ + 1, _ => ⟨Nat.succ_pos _, Nat.succ_pos _⟩

end Propagation

section Support

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- What a formation present gives is at most what the carried amount adds across the step. -/
theorem carriedGive_le {t : Nat} {h : F} (mem : h ∈ present t) (c : C) :
    carriedGive cs part σ k t h c (carried cs part σ k present δ) ≤
      carried cs part σ k present δ (t + 1) c :=
  Nat.le_trans (le_total_of_mem (q := fun h => carriedGive cs part σ k t h c
      (carried cs part σ k present δ)) mem)
    (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (carried_succ t c).symm))

/-- **The carried amount is positive exactly where a gap is conveyed.** The carried amount at a
condition and step is positive exactly along a route in time of starting gaps, the part's gaps and
positive strengths. -/
theorem carried_pos_iff (t : Nat) (c : C) :
    0 < carried cs part σ k present δ t c ↔ Conveyed cs part σ k present δ t c :=
  have toConveyed : ∀ t s, s ≤ t → ∀ c, 0 < carried cs part σ k present δ s c →
      Conveyed cs part σ k present δ s c := by
    intro t
    induction t with
    | zero =>
      intro s le c pos
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      exact .start pos
    | succ t ih =>
      intro s le c pos
      cases le_succ_cases le with
      | inl before => exact ih s before c pos
      | inr now =>
        subst now
        have sum := carried_succ (cs := cs) (part := part) (σ := σ) (k := k) (present := present)
          (δ := δ) t c
        match Nat.decLt 0 (carried cs part σ k present δ t c) with
        | isTrue held => exact .hold (ih t (Nat.le_refl t) c held)
        | isFalse notHeld =>
          have gained : 0 < total (present t) fun h =>
              carriedGive cs part σ k t h c (carried cs part σ k present δ) :=
            Nat.lt_of_lt_of_le pos (Nat.le_of_eq (sum.trans
              ((congrArg (· + _) (eq_zero_of_not_pos notHeld)).trans (Nat.zero_add _))))
          match total_pos _ gained with
          | ⟨h, mem, positive⟩ =>
            match hp : part h with
            | true =>
              exact .input mem hp (Nat.lt_of_lt_of_le positive
                (Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp)))
            | false =>
              have inRest : 0 < total (steps 0 (t + 1)) fun s => total cs fun d =>
                  k t h c s d * carried cs part σ k present δ s d :=
                Nat.lt_of_lt_of_le positive
                  (Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp))
              match total_pos _ inRest with
              | ⟨s, sMem, sPos⟩ =>
                match total_pos _ sPos with
                | ⟨d, dMem, dPos⟩ =>
                  have both := Propagation.pos_of_mul_pos dPos
                  have le := Propagation.le_of_mem_steps_upto sMem
                  exact .response mem hp le dMem both.1 (ih s le d both.2)
  ⟨toConveyed t t (Nat.le_refl t) c,
   fun conveyed => by
    induction conveyed with
    | start pos => exact pos
    | hold _ ih => exact Nat.lt_of_lt_of_le ih (carried_le_succ _ _)
    | @input t h c mem hp pos =>
      exact Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp).symm))
        (carriedGive_le mem c)
    | @response t h c s d mem hp le dMem kPos _ ih =>
      refine Nat.lt_of_lt_of_le ?_ (carriedGive_le mem c)
      refine Nat.lt_of_lt_of_le ?_ (Nat.le_of_eq (congrArg (fun b => cond b (σ t h c) _) hp).symm)
      exact Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le (Nat.mul_pos kPos ih)
          (le_total_of_mem (q := fun d => k t h c s d * carried cs part σ k present δ s d) dMem))
        (le_total_of_mem (q := fun s => total cs fun d =>
          k t h c s d * carried cs part σ k present δ s d) (Propagation.mem_steps_upto le))⟩

/-- **A conveyed gap spreads.** With no starting gap, where every positive gap of the part is a
source exchanging with the condition, and every positive strength is of a formation into which that
level couples and which exchanges with the condition, every conveyed gap lies on a route of
`TimedResponse.Spread`. -/
theorem Conveyed.spread {L L' : Flow F C} {W : Web F C} {obs : F → C → Prop}
    {source : Nat → F → Prop} (noStart : ∀ c, δ c = 0)
    (inputs : ∀ t h c, h ∈ present t → part h = true → 0 < σ t h c →
      source t h ∧ TimedResponse.TouchesAt L L' t h c)
    (responds : ∀ t h c s d, h ∈ present t → part h = false → s ≤ t → d ∈ cs → 0 < k t h c s d →
      TimedResponse.CoupledIntoAt W obs h s d ∧ TimedResponse.TouchesAt L L' t h c)
    {t : Nat} {c : C} (conveyed : Conveyed cs part σ k present δ t c) :
    TimedResponse.Spread L L' W obs source t c := by
  induction conveyed with
  | @start c pos =>
    exact absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (noStart c))) (Nat.lt_irrefl 0)
  | hold _ ih => exact .hold ih
  | @input t h c mem hp pos =>
    have both := inputs t h c mem hp pos
    exact .input both.1 both.2
  | @response t h c s d mem hp le dMem kPos _ ih =>
    have both := responds t h c s d mem hp le dMem kPos
    exact .response ih le both.1 both.2

/-- **Where no gap is conveyed, the levels agree.** Under the hypotheses of `gap_le_carried`, a
condition to which no gap is conveyed at a step has the same level in both flows there. -/
theorem levels_alike_of_not_conveyed [DecidableEq C] {law : ExchangeLaw F C} {L L' : Flow F C}
    {W W' : Web F C} (na : law.Nonanticipating) (every : ∀ c, c ∈ cs)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (onL : ∀ t, L.present t = present t) (onL' : ∀ t, L'.present t = present t)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (acts : ∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c)
    (start : ∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) {t : Nat} {c : C}
    (notConveyed : ¬ Conveyed cs part σ k present δ t c) : W.level t c = W'.level t c :=
  gap_eq_zero_iff.mp (Nat.eq_zero_of_le_zero (Nat.le_trans
    (gap_le_carried na every balances balances' onL onL' follows follows' strengths acts start t c)
    (Nat.le_of_eq (eq_zero_of_not_pos fun pos => notConveyed ((carried_pos_iff t c).mp pos)))))

end Support

/-! ## Differences carried add -/

namespace Propagation

/-- A choice between sums is the sum of the choices. -/
theorem cond_add (b : Bool) (x y u v : Nat) : cond b (x + y) (u + v) = cond b x u + cond b y v :=
  match b with
  | true => rfl
  | false => rfl

/-- A choice between larger amounts is larger. -/
theorem cond_le_cond (b : Bool) {x y u v : Nat} (xy : x ≤ y) (uv : u ≤ v) :
    cond b x u ≤ cond b y v :=
  match b with
  | true => xy
  | false => uv

end Propagation

section Superposition

variable {cs : List C} {part : F → Bool} {k : Nat → F → C → Nat → C → Nat}
  {present : Nat → List F}

/-- **Differences carried add.** What the strengths carry from two sets of gaps of the part and two
sets of starting gaps together is what they carry from each. -/
theorem carried_add (σ₁ σ₂ : Nat → F → C → Nat) (δ₁ δ₂ : C → Nat) (t : Nat) (c : C) :
    carried cs part (fun t h c => σ₁ t h c + σ₂ t h c) k present (fun c => δ₁ c + δ₂ c) t c =
      carried cs part σ₁ k present δ₁ t c + carried cs part σ₂ k present δ₂ t c :=
  have upto : ∀ t s, s ≤ t → ∀ c,
      carried cs part (fun t h c => σ₁ t h c + σ₂ t h c) k present (fun c => δ₁ c + δ₂ c) s c =
        carried cs part σ₁ k present δ₁ s c + carried cs part σ₂ k present δ₂ s c := by
    intro t
    induction t with
    | zero =>
      intro s le c
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      rfl
    | succ t ih =>
      intro s le c
      cases le_succ_cases le with
      | inl before => exact ih s before c
      | inr now =>
        subst now
        have each : ∀ h, h ∈ present t →
            carriedGive cs part (fun t h c => σ₁ t h c + σ₂ t h c) k t h c
                (carried cs part (fun t h c => σ₁ t h c + σ₂ t h c) k present
                  (fun c => δ₁ c + δ₂ c)) =
              carriedGive cs part σ₁ k t h c (carried cs part σ₁ k present δ₁) +
                carriedGive cs part σ₂ k t h c (carried cs part σ₂ k present δ₂) := by
          intro h _
          refine Eq.trans ?_ (Propagation.cond_add (part h) _ _ _ _)
          refine congrArg (cond (part h) (σ₁ t h c + σ₂ t h c)) ?_
          refine Eq.trans ?_ (total_add _ _ _)
          refine total_congr_on fun s mem => Eq.trans ?_ (total_add _ _ _)
          refine total_congr_on fun d _ => ?_
          exact (congrArg (k t h c s d * ·) (ih s (Propagation.le_of_mem_steps_upto mem) d)).trans
            (Nat.left_distrib _ _ _)
        refine (carried_succ t c).trans ?_
        refine Eq.trans ?_ (Naturals.add_congr (carried_succ t c).symm (carried_succ t c).symm)
        refine (Naturals.add_congr (ih t (Nat.le_refl t) c) ((total_congr_on each).trans
          (total_add _ _ _))).trans ?_
        exact Nat.add_add_add_comm _ _ _ _
  upto t t (Nat.le_refl t) c

/-- **More gaps and larger strengths carry more.** -/
theorem carried_mono {σ σ' : Nat → F → C → Nat} {δ δ' : C → Nat}
    {k' : Nat → F → C → Nat → C → Nat} (moreActs : ∀ t h c, σ t h c ≤ σ' t h c)
    (moreStart : ∀ c, δ c ≤ δ' c) (moreStrength : ∀ t h c s d, k t h c s d ≤ k' t h c s d) (t : Nat)
    (c : C) : carried cs part σ k present δ t c ≤ carried cs part σ' k' present δ' t c :=
  have upto : ∀ t s, s ≤ t → ∀ c,
      carried cs part σ k present δ s c ≤ carried cs part σ' k' present δ' s c := by
    intro t
    induction t with
    | zero =>
      intro s le c
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      exact moreStart c
    | succ t ih =>
      intro s le c
      cases le_succ_cases le with
      | inl before => exact ih s before c
      | inr now =>
        subst now
        refine Nat.le_trans (Nat.le_of_eq (carried_succ t c))
          (Nat.le_trans ?_ (Nat.le_of_eq (carried_succ t c).symm))
        refine Nat.add_le_add (ih t (Nat.le_refl t) c) (total_le _ fun h _ => ?_)
        exact Propagation.cond_le_cond (part h) (moreActs t h c)
          (total_le _ fun s mem => total_le _ fun d _ =>
            Nat.mul_le_mul (moreStrength t h c s d) (ih s (Propagation.le_of_mem_steps_upto mem) d))
  upto t t (Nat.le_refl t) c

end Superposition

/-- **Sensitivity is a strength that is not zero.** For a law of what has stood, `h`'s exchange is
sensitive to `d` exactly where at some step not every level of `d` up to that step, with every
condition, has strength zero. -/
theorem ExchangeLaw.sensitive_iff_strength [DecidableEq C] {law : ExchangeLaw F C}
    (na : law.Nonanticipating) {h : F} {d : C} :
    law.Sensitive h d ↔ ∃ t, ¬ ∀ c s, s ≤ t → law.RespondsWithin t h c s d 0 :=
  ⟨fun ⟨t, notInsensitive⟩ =>
    ⟨t, fun zero => notInsensitive ((ExchangeLaw.insensitiveAt_iff_strength_zero na).mpr zero)⟩,
   fun ⟨t, notZero⟩ =>
    ⟨t, fun insensitive =>
      notZero ((ExchangeLaw.insensitiveAt_iff_strength_zero na).mp insensitive)⟩⟩

/-! ## Witnesses -/

namespace Propagation

/-- A total over the first `t + 1` steps of what is nothing except at `t` is its value at `t`. -/
theorem total_steps_at {q : Nat → Nat} {t : Nat} (only : ∀ s, s ≠ t → q s = 0) :
    total (steps 0 (t + 1)) q = q t :=
  Nat.le_antisymm
    (total_le_at (fun s pos =>
        match Nat.decEq s t with
        | isTrue same => same
        | isFalse other =>
          absurd pos fun lt =>
            Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (only s other))))
      (steps_distinct 0 (t + 1)))
    (le_total_of_mem (mem_steps_upto (Nat.le_refl t)))

/-- Two conditions, `true` and `false`, each listed once. -/
def two : List Bool := [true, false]

/-- Both conditions are listed. -/
theorem every_two (c : Bool) : c ∈ two :=
  match c with
  | true => .head _
  | false => .tail _ (.head _)

/-- Each is listed once. -/
theorem distinct_two : Distinct two :=
  ⟨(fun mem => match mem with | .tail _ inner => nomatch inner), (fun inner => nomatch inner),
    trivial⟩

/-- The actor `true`, the part, and the rest `false`, both present at every step. -/
def both : Nat → List Bool := fun _ => [true, false]

/-- The act: across the first step the actor gives one unit to the condition `true`. -/
def unitAct : Nat → Bool → Bool → Nat
  | 0, true, true => 1
  | 0, true, false => 0
  | 0, false, _ => 0
  | _ + 1, _, _ => 0

/-- Across each step, the carried amount at a condition grows by the act and by what the rest's
strengths make of the amounts so far. -/
theorem carried_two_succ (k : Nat → Bool → Bool → Nat → Bool → Nat) (t : Nat) (c : Bool) :
    carried two (fun h => h) unitAct k both (fun _ => 0) (t + 1) c =
      carried two (fun h => h) unitAct k both (fun _ => 0) t c + (unitAct t true c +
        total (steps 0 (t + 1)) fun s => total two fun d =>
          k t false c s d * carried two (fun h => h) unitAct k both (fun _ => 0) s d) :=
  (carried_succ t c).trans
    (congrArg (carried two (fun h => h) unitAct k both (fun _ => 0) t c + ·)
      ((rfl : (total (both t) fun h => carriedGive two (fun h => h) unitAct k t h c
          (carried two (fun h => h) unitAct k both (fun _ => 0))) =
          unitAct t true c + ((total (steps 0 (t + 1)) fun s => total two fun d =>
            k t false c s d * carried two (fun h => h) unitAct k both (fun _ => 0) s d) + 0)).trans
        (congrArg (unitAct t true c + ·) (Nat.add_zero _))))

end Propagation

namespace Propagation.Chain

open Propagation

/-- The rest gives the condition `false`, across each step, twice the level of `true` at that
step. -/
def relay (t : Nat) (h c : Bool) (s : Nat) (d : Bool) : Nat :=
  if s = t ∧ h = false ∧ c = false ∧ d = true then 2 else 0

/-- The amount carried in the chain. -/
def amount : Nat → Bool → Nat := carried two (fun h => h) unitAct relay both (fun _ => 0)

/-- The first condition holds the one unit from the first step on. -/
theorem first : ∀ t, amount (t + 1) true = 1
  | 0 => (carried_two_succ relay 0 true).trans
      (congrArg (0 + ·) (congrArg (1 + ·) (total_eq_zero fun _ _ => total_eq_zero fun _ _ =>
        (congrArg (· * _) (if_neg fun both => Bool.noConfusion both.2.2.1)).trans
          (Nat.zero_mul _))))
  | t + 1 => (carried_two_succ relay (t + 1) true).trans
      ((congrArg (· + _) (first t)).trans
        (congrArg (1 + ·) (congrArg (0 + ·) (total_eq_zero fun _ _ => total_eq_zero fun _ _ =>
          (congrArg (· * _) (if_neg fun both => Bool.noConfusion both.2.2.1)).trans
            (Nat.zero_mul _)))))

/-- What the rest relays to `false` across the step from `t` is twice the amount at `true`. -/
theorem relayed (t : Nat) :
    (total (steps 0 (t + 1)) fun s => total two fun d => relay t false false s d * amount s d) =
      2 * amount t true :=
  (total_steps_at (q := fun s => total two fun d => relay t false false s d * amount s d)
    fun _ other => total_eq_zero fun _ _ =>
      (congrArg (· * _) (if_neg fun both => other both.1)).trans (Nat.zero_mul _)).trans
    ((congrArg (· + _) (congrArg (· * amount t true) (if_pos ⟨rfl, rfl, rfl, rfl⟩))).trans
      ((congrArg (2 * amount t true + ·) ((congrArg (· + 0) ((congrArg (· * amount t false)
        (if_neg fun both => Bool.noConfusion both.2.2.2)).trans (Nat.zero_mul _))).trans
          (Nat.add_zero 0))).trans (Nat.add_zero _)))

/-- **A held difference keeps arriving.** One unit given once to `true` arrives at `false` as `2t`
by step `t + 1`: without bound, though no loop returns it. -/
theorem keeps_arriving : ∀ t, amount (t + 1) false = 2 * t
  | 0 => (carried_two_succ relay 0 false).trans
      ((congrArg (0 + ·) ((congrArg (0 + ·) (relayed 0)).trans (Nat.zero_add _))).trans
        ((Nat.zero_add _).trans (congrArg (2 * ·) (rfl : amount 0 true = 0))))
  | t + 1 => (carried_two_succ relay (t + 1) false).trans
      ((congrArg (· + _) (keeps_arriving t)).trans
        ((congrArg (2 * t + ·) ((congrArg (0 + ·) (relayed (t + 1))).trans
          ((Nat.zero_add _).trans (congrArg (2 * ·) (first t))))).trans
          (Nat.left_distrib 2 t 1).symm))

/-- So, against the quiet course, the course the carrying law generates has exactly this gap at
`false`: the carried amount is what arrives. -/
theorem gap_arrives (t : Nat) :
    gap (amount (t + 1) false)
      (carried two (fun h => h) (fun _ _ _ => 0) relay both (fun _ => 0) (t + 1) false) = 2 * t :=
  (carried_attained (t + 1) false).trans (keeps_arriving t)

end Propagation.Chain

namespace Propagation.Loop

open Propagation

/-- The rest gives `true`, across each step, the level of `true` at that step: a loop of strength
one. -/
def loop (t : Nat) (h c : Bool) (s : Nat) (d : Bool) : Nat :=
  if s = t ∧ h = false ∧ c = true ∧ d = true then 1 else 0

/-- The amount carried around the loop. -/
def amount : Nat → Bool → Nat := carried two (fun h => h) unitAct loop both (fun _ => 0)

/-- What the loop returns to `true` across the step from `t` is the amount at `true`. -/
theorem returned (t : Nat) :
    (total (steps 0 (t + 1)) fun s => total two fun d => loop t false true s d * amount s d) =
      amount t true :=
  (total_steps_at (q := fun s => total two fun d => loop t false true s d * amount s d)
    fun _ other => total_eq_zero fun _ _ =>
      (congrArg (· * _) (if_neg fun both => other both.1)).trans (Nat.zero_mul _)).trans
    ((congrArg (· + _) ((congrArg (· * amount t true) (if_pos ⟨rfl, rfl, rfl, rfl⟩)).trans
      (Nat.one_mul _))).trans
      ((congrArg (amount t true + ·) ((congrArg (· + 0) ((congrArg (· * amount t false)
        (if_neg fun both => Bool.noConfusion both.2.2.2)).trans (Nat.zero_mul _))).trans
          (Nat.add_zero 0))).trans (Nat.add_zero _)))

/-- **Runaway around a loop.** One unit given once to `true`, returned by a loop of strength one,
arrives as `2 ^ t` by step `t + 1`. -/
theorem runaway : ∀ t, amount (t + 1) true = 2 ^ t
  | 0 => (carried_two_succ loop 0 true).trans
      ((congrArg (0 + ·) (congrArg (1 + ·) (returned 0))).trans (Nat.zero_add _))
  | t + 1 => (carried_two_succ loop (t + 1) true).trans
      ((congrArg (· + _) (runaway t)).trans
        ((congrArg (2 ^ t + ·) ((congrArg (0 + ·) ((returned (t + 1)).trans (runaway t))).trans
          (Nat.zero_add _))).trans
          (((Nat.two_mul (2 ^ t)).symm.trans (Nat.mul_comm 2 (2 ^ t))).trans
            (Nat.pow_succ 2 t).symm)))

end Propagation.Loop

namespace Propagation.Square

/-- A law under which the one formation gives the one condition the square of its level. -/
def law : ExchangeLaw Unit Unit :=
  ⟨fun _ _ _ _ => 0, fun t _ l _ => l t () * l t ()⟩

/-- The square of `k + 1` is the square of `k` with `k + (k + 1)`. -/
theorem succ_square (k : Nat) : (k + 1) * (k + 1) = k * k + (k + (k + 1)) :=
  (Nat.mul_succ (k + 1) k).trans ((congrArg (· + (k + 1)) (Nat.succ_mul k k)).trans
    (Nat.add_assoc (k * k) k (k + 1)))

/-- **No finite strength.** The square law is coupled to its condition's level with no finite
strength: a finite strength is a condition on a law, not given with every law. -/
theorem not_respondsWithin (k : Nat) : ¬ law.RespondsWithin 0 () () 0 () k :=
  fun within =>
    have bound := within (fun _ _ => k) (fun s _ => if s = 0 then k + 1 else k)
      fun s' _ off =>
        (if_neg fun zero => off ⟨zero, rfl⟩ : (if s' = 0 then k + 1 else k) = k).symm
    have exact : law.exchangeGap 0 () () (fun _ _ => k) (fun s _ => if s = 0 then k + 1 else k) =
        k + (k + 1) :=
      (congrArg (· + gap (k * k) ((k + 1) * (k + 1))) (gap_self 0)).trans
        ((Nat.zero_add _).trans ((congrArg (gap (k * k)) (succ_square k)).trans
          ((gap_comm _ _).trans (gap_add_self _ _))))
    have one : gap k (if (0 : Nat) = 0 then k + 1 else k) = 1 :=
      (congrArg (gap k) (if_pos rfl : (if (0 : Nat) = 0 then k + 1 else k) = k + 1)).trans
        ((gap_comm _ _).trans (gap_add_self k 1))
    absurd (Nat.le_trans (Nat.le_of_eq exact.symm)
        (Nat.le_trans bound (Nat.le_of_eq ((congrArg (k * ·) one).trans (Nat.mul_one k)))))
      (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self k)
        (Nat.le_add_left (k + 1) k)))

end Propagation.Square

end Becoming

/-! ## The worlds of a course and of carried amounts (moved from `Becoming.Runs`) -/

namespace Becoming

section Course

variable {F C : Type}

/-- **The course a law of exchange generates, as a world.** Formations and conditions are roles of
one relatum (`World.ofRoles` of the course's flow and web, `ExchangeLaw.courseWeb`): the formations
present exchange as the law gives under the levels it generates, and the conditions stand at those
levels. -/
def ExchangeLaw.courseWorld (law : ExchangeLaw F C) (present : Nat → List F) (start : C → Nat)
    (W : Web F C) : World :=
  World.ofRoles (law.course present start) (law.courseWeb present start W)

variable {law : ExchangeLaw F C} {present : Nat → List F} {start : C → Nat} {W : Web F C}

/-- **A course is a balanced world exactly where it is feasible**, under a law of what has
stood. -/
theorem ExchangeLaw.courseWorld_balanced_iff (na : law.Nonanticipating) :
    (law.courseWorld present start W).Balanced ↔ law.Feasible present start :=
  (law.course present start).roles_balances.trans (ExchangeLaw.course_balances_iff na W)

end Course

section Carried

variable {F C : Type} {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **The world the carrying law generates**: its conditions stand at the carried amount, every
formation active, nothing required. -/
def carriedWorld (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) : World :=
  (ExchangeLaw.carrying cs part σ k).courseWorld present δ (Propagation.webOf fun _ _ => 0)

/-- The carried amount is the standing of the carried world. -/
theorem carriedWorld_level (t : Nat) (c : C) :
    (carriedWorld cs part σ k present δ).web.level t (.inr c) = carried cs part σ k present δ t c :=
  rfl

/-- **The carried world balances**, with no premise. -/
theorem carriedWorld_balanced : (carriedWorld cs part σ k present δ).Balanced :=
  ((ExchangeLaw.carrying cs part σ k).course present δ).roles_balances.mpr carrying_balances

end Carried

end Becoming
