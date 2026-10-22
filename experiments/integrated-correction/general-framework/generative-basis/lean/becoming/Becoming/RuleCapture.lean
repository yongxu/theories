import Becoming.Pace
import Becoming.Ideals
import Becoming.Witnesses

/-!
# Rule capture: a selection whose rule reads the share it selects

`Becoming.Capture` states a target's share among descendants under a selection (`share_not_lower`,
`share_rises`) and, apart from it, that where the next configuration depends on the rule alone a
perturbed state is re-absorbed (`Law.perturbation_reabsorbed`); that the selected shape the rule it
supposes. `Becoming.Pace` states a two-level course whose rule changes only at reading steps, with no
share and no selection. This module joins the two: the fast step of `Pace.paced` is a selection, the
rule read at a reading step reads the share the selection gave, and it states what that loop does,
with no premise beyond the hypotheses each statement names. The orders are `Ideals.Preorder`s: `P` on
fast configurations (`P.le x y`: the share at `y` is not lower than at `x`) and `M` on rules (`M.le g
g'`: `g'` favours the carriers at least as much as `g`); `favours` holds of the rules under which
selection does not lower the share (`Raises`), and the rule read is a monotone function of the share
alone (`ReadsShare`).

* **Where no rule turns against the reading, the loop locks at its first reading step.** Where the
  start's rule and every rule read favour, the share falls at no step and the course is locked from
  the step after its first reading step (`favouring_locks`, through `favours_throughout`). On counts
  this is the statement with a margin: each carrier leaving `a + m` offspring and each other `a`, the
  margin read at a reading step a monotone function of the share, from every start under a margin the
  share falls at no step and from the step after the first reading step the margin falls at no step
  (`CarrierCounts.margin_course`); the share rises strictly at every step whose margin is positive, carriers
  present, along every course (`CarrierCounts.rises_strictly`, `CarrierCounts.rises_strictly_along`).
* **Locked, the loop does not turn back.** Favouring kept by every rule not lower, a configuration
  whose rule favours and is not above what the reading of its share gives (`Locked`) stays locked at
  every later step (`locked_stays`), and neither the share nor the rule falls across any step, reading
  steps included (`locked_rises`, `locked_not_below`). Where rules can favour the others, the lock is a
  condition on the start: in `Alternating` a rule in force against the reading, read one step late,
  makes share and rule fall without end, the share at every even step and the rule at every odd step
  (`Alternating.alternates`), and the course is locked neither way at any step
  (`Alternating.never_locked`).
* **A perturbation that keeps the direction is absorbed.** From a locked configuration, the rule
  replaced by any favouring one, above it or below: at the step after every reading step the rule is
  at least the rule before the perturbation and the course is locked again (`perturbation_absorbed`,
  through `perturbation_invariant`). Under margins every perturbation of the margin keeps the
  direction. A perturbation that reverses the direction is not absorbed in general: held for one step
  before the reading, it carries the share across the threshold of the reading and locks the course
  the other way, neither share nor rule rising again (`Reversed.not_absorbed`); at a reading step
  itself it gives `Alternating`, whose start is the locked configuration `Alternating.before_locked`
  with its rule reversed.
* **Leaving.** Where the reading favours at every share, every course, whatever its start, is locked
  from the step after its second reading step (`uniform_locks`; the second is exact,
  `Second.second_exact`): no change of configuration, of the share or of the rule's value, leaves the
  lock for longer, and what leaves it is a change of the law, of how the rule reads or of the
  selection. Where the reading favours only above a threshold, a change of configuration across the
  threshold also leaves (`Reversed.not_absorbed`).
* **Order kept.** Where selection is monotone in the share and in the rule, and the reading monotone in
  the share, two courses keep their order at every step (`order_kept`); a perturbation lowering the
  rule keeps its course below the course without it (`perturbation_keeps_below`, through
  `Pace.paced_shift`: a two-level course read from a later step is the course from its configuration
  there). With absorption: a perturbation that keeps the direction delays the course and does not turn
  it.
* **Counts.** Two counts, the second positive (`CarrierCounts`): a population of carriers and others with
  others present, or a rule giving each carrier and each other so many offspring. The share order is
  cross-multiplication (`CarrierCounts.order`), the comparison of `share_not_lower`
  (`CarrierCounts.share_not_lower_counts`). Selection (`CarrierCounts.select`) multiplies each kind by what the rule
  gives it; it does not lower the share under a favouring rule nor raise it under a disfavouring one
  (`CarrierCounts.raises`, `CarrierCounts.lowers`), favouring and disfavouring are kept upward and downward
  (`CarrierCounts.upper`, `CarrierCounts.lower`), and selection is monotone (`CarrierCounts.select_mono`), so a
  perturbation lowering the rule keeps its course below on counts
  (`CarrierCounts.perturbation_keeps_below_counts`). Under the proportional reading, which leaves each kind offspring in proportion to how many of its kind there
  are, from a rule that favours and is not above the population's own proportion, the carriers'
  share and the rule fall at no step; from one that disfavours and is not below it, they rise at
  none (`CarrierCounts.proportional_locks`, `CarrierCounts.proportional_locks_down`). A threshold reading is
  monotone where its lower rule is not above its upper one (`CarrierCounts.threshold_reads`) and favours at
  every share where both favour (`CarrierCounts.threshold_favours`).

So in a loop whose rule reads the share it selects, the outcome is held by how the rule reads, not by
the rule's value: every reading step sets the value again from the share. This is the mirror of
`Law.perturbation_reabsorbed`: there the state is re-absorbed because the step does not read it; here
the rule's value is re-set because the reading does not read it, and the share, which the reading
does read, carries the loop.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- 二柄 (韩非子): "今君人者释其刑德而使臣用之，则君反制于臣矣". The rule of selection read from the share
  of those it selects (`ReadsShare`) holds the outcome: locked, the loop does not turn back. The
  theory states the loop as a relation between a selection and its rule; 韩非 reads it as control
  between opposed interests, and that divergence is kept.
- 据有余而制不足 (管子·国蓄): the proportional reading; the kind holding more is favoured and holds more
  (`CarrierCounts.proportional_locks`).
- 壹赏、壹刑、壹教 (商君书): one reading favouring one way at every share; every course is locked from
  its second reading step (`uniform_locks`), and only a change of how the rule reads leaves.
- The premise `ReadsShare` is where "the winner shapes the rule" of `Becoming.Capture` enters, now
  stated as a hypothesis on the reading; what is derived is that such a rule holds the outcome.

What is not derived: that any actual rule reads the share it selects, or reads it monotonically;
which readings formations live under; that offspring carry their parents' target (a premise as in
`Becoming.Capture`); that the share or the rule rises strictly, except on counts under a positive
margin. A reading against the share is not this lock: in `Switching` (of `Becoming.Pace`) the rule takes
the value the fast level lacks, and both values recur. The representation commits to discrete steps, natural
counts and, in `CarrierCounts`, others present. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

universe u v

namespace Pace

variable {S : Type u} {R : Type v} {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- **A two-level course read from a later step is the course from its configuration there**,
with the schedule read from that step. -/
theorem paced_shift (c : S × R) (a : Nat) :
    ∀ k, paced f h reads c (a + k) = paced f h (fun u => reads (a + u)) (paced f h reads c a) k
  | 0 => rfl
  | k + 1 => (paced_succ c (a + k)).trans
      ((congrArg (turn f h (reads (a + k))) (paced_shift c a k)).trans
        (paced_succ (reads := fun u => reads (a + u)) (paced f h reads c a) k).symm)

/-- **The fast configuration after a step is the selection by the rule in force**, reading or not. -/
theorem paced_fast_succ (c : S × R) (t : Nat) :
    (paced f h reads c (t + 1)).1 = f (paced f h reads c t).1 (paced f h reads c t).2 :=
  (congrArg Prod.fst (paced_succ c t)).trans
    (match reads t with
     | true => rfl
     | false => rfl)

end Pace

namespace RuleCapture

open Pace

variable {S : Type u} {R : Type v}

/-- An order read the other way round. -/
def reverse {α : Type u} (P : Ideals.Preorder α) : Ideals.Preorder α where
  le a b := P.le b a
  refl a := P.refl a
  trans ab bc := P.trans bc ab

/-- **Selection under a favouring rule does not lower the share.** `P.le x y` reads: the share at
`y` is not lower than at `x`. -/
def Raises (P : Ideals.Preorder S) (favours : R → Prop) (f : S → R → S) : Prop :=
  ∀ x g, favours g → P.le x (f x g)

/-- **The rule read is a monotone function of the share alone.** The rule read at a share not lower
is not lower, whatever rules the two readings meet. -/
def ReadsShare (P : Ideals.Preorder S) (M : Ideals.Preorder R) (h : S → R → R) : Prop :=
  ∀ x y g g', P.le x y → M.le (h x g) (h y g')

/-- Read with both orders the other way round, a reading monotone in the share stays so. -/
theorem ReadsShare.reverse {P : Ideals.Preorder S} {M : Ideals.Preorder R} {h : S → R → R}
    (monotone : ReadsShare P M h) : ReadsShare (reverse P) (reverse M) h :=
  fun x y g g' le => monotone y x g' g le

/-- **Locked**: the rule in force favours, and it is not above what the reading of the share
gives. -/
def Locked (M : Ideals.Preorder R) (favours : R → Prop) (h : S → R → R) (p : S × R) : Prop :=
  favours p.2 ∧ M.le p.2 (h p.1 p.2)

section Lock

variable {P : Ideals.Preorder S} {M : Ideals.Preorder R} {favours : R → Prop}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- **One turn keeps the lock**, and lowers neither the share nor the rule. -/
theorem turn_locked (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    ∀ (b : Bool) (p : S × R), Locked M favours h p →
      Locked M favours h (turn f h b p) ∧ P.le p.1 (turn f h b p).1 ∧ M.le p.2 (turn f h b p).2
  | true, (x, g), lock =>
    ⟨⟨upper lock.2 lock.1, monotone x (f x g) g (h x g) (raises x g lock.1)⟩, raises x g lock.1,
      lock.2⟩
  | false, (x, g), lock =>
    ⟨⟨lock.1, M.trans lock.2 (monotone x (f x g) g g (raises x g lock.1))⟩, raises x g lock.1,
      M.refl g⟩

/-- **A locked configuration stays locked** at every later step of the two-level course. -/
theorem locked_stays (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
    (locked : Locked M favours h (paced f h reads c t)) :
    ∀ k, Locked M favours h (paced f h reads c (t + k))
  | 0 => locked
  | k + 1 => Eq.subst (motive := Locked M favours h) (paced_succ c (t + k)).symm
      (turn_locked raises monotone upper (reads (t + k)) _
        (locked_stays raises monotone upper locked k)).1

/-- **Locked, neither the share nor the rule falls**: across every step from a locked one on,
reading steps included, neither is lower after the step than before it. -/
theorem locked_rises (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
    (locked : Locked M favours h (paced f h reads c t)) (k : Nat) :
    P.le (paced f h reads c (t + k)).1 (paced f h reads c (t + k + 1)).1 ∧
      M.le (paced f h reads c (t + k)).2 (paced f h reads c (t + k + 1)).2 :=
  have turned := turn_locked raises monotone upper (reads (t + k)) _
    (locked_stays raises monotone upper locked k)
  ⟨Eq.subst (motive := fun q : S × R => P.le (paced f h reads c (t + k)).1 q.1)
      (paced_succ c (t + k)).symm turned.2.1,
   Eq.subst (motive := fun q : S × R => M.le (paced f h reads c (t + k)).2 q.2)
      (paced_succ c (t + k)).symm turned.2.2⟩

/-- **Locked, the share and the rule are never again below where they were.** -/
theorem locked_not_below (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat}
    (locked : Locked M favours h (paced f h reads c t)) :
    ∀ k, P.le (paced f h reads c t).1 (paced f h reads c (t + k)).1 ∧
      M.le (paced f h reads c t).2 (paced f h reads c (t + k)).2
  | 0 => ⟨P.refl _, M.refl _⟩
  | k + 1 =>
    have before := locked_not_below raises monotone upper locked k
    have step := locked_rises raises monotone upper locked k
    ⟨P.trans before.1 step.1, M.trans before.2 step.2⟩

end Lock

section Perturbation

variable {P : Ideals.Preorder S} {M : Ideals.Preorder R} {favours : R → Prop}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- Along the course from a perturbed rule that favours, every rule favours, the share is never
below where it was perturbed, and the rule before the perturbation is never above what the reading
gives. -/
theorem perturbation_invariant (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x : S} {g g' : R}
    (before : Locked M favours h (x, g)) (keeps : favours g') :
    ∀ t, favours (paced f h reads (x, g') t).2 ∧ P.le x (paced f h reads (x, g') t).1 ∧
      M.le g (h (paced f h reads (x, g') t).1 (paced f h reads (x, g') t).2)
  | 0 => ⟨keeps, P.refl x, M.trans before.2 (monotone x x g g' (P.refl x))⟩
  | t + 1 =>
    have now := perturbation_invariant raises monotone upper before keeps t
    have rise := raises _ _ now.1
    have below := M.trans now.2.2 (monotone _ _ _ _ rise)
    match q : reads t with
    | true =>
      have at_next : paced f h reads (x, g') (t + 1) =
          (f (paced f h reads (x, g') t).1 (paced f h reads (x, g') t).2,
            h (paced f h reads (x, g') t).1 (paced f h reads (x, g') t).2) :=
        (paced_succ (x, g') t).trans (congrArg (fun b => turn f h b _) q)
      Eq.subst (motive := fun p : S × R => favours p.2 ∧ P.le x p.1 ∧ M.le g (h p.1 p.2))
        at_next.symm ⟨upper now.2.2 before.1, P.trans now.2.1 rise, below⟩
    | false =>
      have at_next : paced f h reads (x, g') (t + 1) =
          (f (paced f h reads (x, g') t).1 (paced f h reads (x, g') t).2,
            (paced f h reads (x, g') t).2) :=
        (paced_succ (x, g') t).trans (congrArg (fun b => turn f h b _) q)
      Eq.subst (motive := fun p : S × R => favours p.2 ∧ P.le x p.1 ∧ M.le g (h p.1 p.2))
        at_next.symm ⟨now.1, P.trans now.2.1 rise, M.trans now.2.2 (monotone _ _ _ _ rise)⟩

/-- **A perturbation of the rule that keeps its direction is absorbed at the next reading step.**
Before the perturbation the configuration `(x, g)` is locked; the perturbation replaces the rule by
any `g'` that favours, above `g` or below it. At the step after every reading step of the course
from `(x, g')`, the rule is at least `g`, the rule before the perturbation, and the configuration
is locked again, so from there on neither the share nor the rule falls (`locked_rises`). -/
theorem perturbation_absorbed (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x : S} {g g' : R}
    (before : Locked M favours h (x, g)) (keeps : favours g') {r : Nat} (at_r : reads r = true) :
    M.le g (paced f h reads (x, g') (r + 1)).2 ∧ Locked M favours h (paced f h reads (x, g') (r + 1)) :=
  have now := perturbation_invariant (reads := reads) raises monotone upper before keeps r
  have at_next : paced f h reads (x, g') (r + 1) =
      (f (paced f h reads (x, g') r).1 (paced f h reads (x, g') r).2,
        h (paced f h reads (x, g') r).1 (paced f h reads (x, g') r).2) :=
    (paced_succ (x, g') r).trans (congrArg (fun b => turn f h b _) at_r)
  Eq.subst (motive := fun p : S × R => M.le g p.2 ∧ Locked M favours h p) at_next.symm
    ⟨now.2.2, upper now.2.2 before.1, monotone _ _ _ _ (raises _ _ now.1)⟩

end Perturbation

section Uniform

variable {P : Ideals.Preorder S} {M : Ideals.Preorder R} {favours : R → Prop}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- Where the reading favours at every share, every rule after a reading step favours. -/
theorem favours_after_reading (uniform : ∀ x g, favours (h x g)) {c : S × R} {r : Nat}
    (at_r : reads r = true) : ∀ k, favours (paced f h reads c (r + 1 + k)).2
  | 0 => Eq.subst (motive := fun p : S × R => favours p.2)
      ((paced_succ c r).trans (congrArg (fun b => turn f h b _) at_r)).symm (uniform _ _)
  | k + 1 =>
    have now := favours_after_reading uniform at_r k
    match q : reads (r + 1 + k) with
    | true => Eq.subst (motive := fun p : S × R => favours p.2)
        ((paced_succ c (r + 1 + k)).trans (congrArg (fun b => turn f h b _) q)).symm (uniform _ _)
    | false => Eq.subst (motive := fun p : S × R => favours p.2)
        ((paced_succ c (r + 1 + k)).trans (congrArg (fun b => turn f h b _) q)).symm now

/-- **Where the reading favours at every share, every course is locked from the step after its
second reading step**, whatever its start: share and rule perturbed, the rule against the reading,
included. -/
theorem uniform_locks (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (uniform : ∀ x g, favours (h x g)) {c : S × R} {r r' : Nat} (first : reads r = true)
    (second : reads r' = true) (lt : r < r') : Locked M favours h (paced f h reads c (r' + 1)) :=
  match le_dest (Nat.succ_le_of_lt lt) with
  | ⟨d, at_r'⟩ =>
    have fav : favours (paced f h reads c r').2 :=
      Eq.subst (motive := fun n => favours (paced f h reads c n).2) at_r'.symm
        (favours_after_reading uniform first d)
    have at_next : paced f h reads c (r' + 1) =
        (f (paced f h reads c r').1 (paced f h reads c r').2,
          h (paced f h reads c r').1 (paced f h reads c r').2) :=
      (paced_succ c r').trans (congrArg (fun b => turn f h b _) second)
    Eq.subst (motive := Locked M favours h) at_next.symm
      ⟨uniform _ _, monotone _ _ _ _ (raises _ _ fav)⟩

/-- Where the start's rule and every rule read favour, every rule of the course favours. -/
theorem favours_throughout (uniform : ∀ x g, favours (h x g)) {c : S × R} (start : favours c.2) :
    ∀ t, favours (paced f h reads c t).2
  | 0 => start
  | t + 1 =>
    have now := favours_throughout uniform start t
    match q : reads t with
    | true => Eq.subst (motive := fun p : S × R => favours p.2)
        ((paced_succ c t).trans (congrArg (fun b => turn f h b _) q)).symm (uniform _ _)
    | false => Eq.subst (motive := fun p : S × R => favours p.2)
        ((paced_succ c t).trans (congrArg (fun b => turn f h b _) q)).symm now

/-- **Where no rule turns against the reading, the lock comes at the first reading step.** The
start's rule and every rule read favouring, the share falls at no step from the start, and the
course is locked from the step after its first reading step, so from there the rule falls at no
step either (`locked_rises`). -/
theorem favouring_locks (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (uniform : ∀ x g, favours (h x g)) {c : S × R} (start : favours c.2) :
    (∀ t, P.le (paced f h reads c t).1 (paced f h reads c (t + 1)).1) ∧
      ∀ r, reads r = true → Locked M favours h (paced f h reads c (r + 1)) :=
  have rise : ∀ t, P.le (paced f h reads c t).1 (paced f h reads c (t + 1)).1 := fun t =>
    Eq.subst (motive := fun p : S × R => P.le (paced f h reads c t).1 p.1) (paced_succ c t).symm
      (match reads t with
       | true => raises _ _ (favours_throughout uniform start t)
       | false => raises _ _ (favours_throughout uniform start t))
  ⟨rise, fun r at_r =>
    have at_next : paced f h reads c (r + 1) =
        (f (paced f h reads c r).1 (paced f h reads c r).2,
          h (paced f h reads c r).1 (paced f h reads c r).2) :=
      (paced_succ c r).trans (congrArg (fun b => turn f h b _) at_r)
    Eq.subst (motive := Locked M favours h) at_next.symm
      ⟨uniform _ _, monotone _ _ _ _ (raises _ _ (favours_throughout uniform start r))⟩⟩

end Uniform

/-! ## Two rules read from one share -/

section Pair

variable {R₁ R₂ : Type v}

/-- Two orders on rules, compared together: a pair is not lower where neither rule is. -/
def pairOrder (M₁ : Ideals.Preorder R₁) (M₂ : Ideals.Preorder R₂) : Ideals.Preorder (R₁ × R₂) where
  le g g' := M₁.le g.1 g'.1 ∧ M₂.le g.2 g'.2
  refl g := ⟨M₁.refl g.1, M₂.refl g.2⟩
  trans ab bc := ⟨M₁.trans ab.1 bc.1, M₂.trans ab.2 bc.2⟩

/-- Two rules, each read from the share. -/
def pairReading (h₁ : S → R₁ → R₁) (h₂ : S → R₂ → R₂) : S → R₁ × R₂ → R₁ × R₂ :=
  fun x g => (h₁ x g.1, h₂ x g.2)

/-- Two rules each read monotonically from the share are read so together. -/
theorem ReadsShare.pair {P : Ideals.Preorder S} {M₁ : Ideals.Preorder R₁} {M₂ : Ideals.Preorder R₂}
    {h₁ : S → R₁ → R₁} {h₂ : S → R₂ → R₂} (first : ReadsShare P M₁ h₁) (second : ReadsShare P M₂ h₂) :
    ReadsShare P (pairOrder M₁ M₂) (pairReading h₁ h₂) :=
  fun x y g g' le => ⟨first x y g.1 g'.1 le, second x y g.2 g'.2 le⟩

/-- **Two rules read from one share lock together at the first reading step.** Where selection
under two rules that both favour does not lower the share, and each rule is read as a monotone
function of the share and favours at every share, from a start whose two rules favour the share
falls at no step and the pair is locked from the step after the first reading step:
`favouring_locks` with the pair of rules as its rule. -/
theorem pair_locks {P : Ideals.Preorder S} {M₁ : Ideals.Preorder R₁} {M₂ : Ideals.Preorder R₂}
    {fav₁ : R₁ → Prop} {fav₂ : R₂ → Prop} {f : S → R₁ × R₂ → S} {h₁ : S → R₁ → R₁}
    {h₂ : S → R₂ → R₂} {reads : Nat → Bool}
    (raises : Raises P (fun g => fav₁ g.1 ∧ fav₂ g.2) f) (first : ReadsShare P M₁ h₁)
    (second : ReadsShare P M₂ h₂) (uniform₁ : ∀ x g, fav₁ (h₁ x g)) (uniform₂ : ∀ x g, fav₂ (h₂ x g))
    {c : S × (R₁ × R₂)} (start : fav₁ c.2.1 ∧ fav₂ c.2.2) :
    (∀ t, P.le (paced f (pairReading h₁ h₂) reads c t).1
        (paced f (pairReading h₁ h₂) reads c (t + 1)).1) ∧
      ∀ r, reads r = true → Locked (pairOrder M₁ M₂) (fun g => fav₁ g.1 ∧ fav₂ g.2)
        (pairReading h₁ h₂) (paced f (pairReading h₁ h₂) reads c (r + 1)) :=
  favouring_locks raises (first.pair second) (fun x g => ⟨uniform₁ x g.1, uniform₂ x g.2⟩) start

end Pair

/-! ## A reading against the share -/

section Against

variable {P : Ideals.Preorder S} {M : Ideals.Preorder R} {favours : R → Prop}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- Along a course whose rules favour, the share falls at no step and so at no stretch. -/
theorem share_kept_along (raises : Raises P favours f) {c : S × R}
    (favouring : ∀ t, favours (paced f h reads c t).2) (t : Nat) :
    ∀ k, P.le (paced f h reads c t).1 (paced f h reads c (t + k)).1
  | 0 => P.refl _
  | k + 1 => P.trans (share_kept_along raises favouring t k)
      (Eq.subst (motive := fun y => P.le (paced f h reads c (t + k)).1 y)
        (paced_fast_succ c (t + k)).symm (raises _ _ (favouring (t + k))))

/-- **A reading against the share does not ratchet.** Where selection under a favouring rule does
not lower the share and the rule is read against the share (`ReadsShare P (reverse M) h`: read at a
share not lower, the rule is not higher), along a course whose rules favour, the rule read at a
later reading step is not above the rule read at an earlier one. The lock rests on the rule not
falling as the share rises (`locked_not_below`); read against the share, as by those the selection
presses down, the rule cannot rise with it. -/
theorem against_not_rising (raises : Raises P favours f) (against : ReadsShare P (reverse M) h)
    {c : S × R} (favouring : ∀ t, favours (paced f h reads c t).2) {r r' : Nat}
    (first : reads r = true) (second : reads r' = true) (le : r ≤ r') :
    M.le (paced f h reads c (r' + 1)).2 (paced f h reads c (r + 1)).2 :=
  have read_at : ∀ q, reads q = true → (paced f h reads c (q + 1)).2 =
      h (paced f h reads c q).1 (paced f h reads c q).2 := fun q at_q =>
    congrArg Prod.snd ((paced_succ c q).trans (congrArg (fun b => turn f h b _) at_q))
  match le_dest le with
  | ⟨d, at_r'⟩ =>
    have rose : P.le (paced f h reads c r).1 (paced f h reads c r').1 :=
      Eq.subst (motive := fun n => P.le (paced f h reads c r).1 (paced f h reads c n).1) at_r'.symm
        (share_kept_along raises favouring r d)
    Eq.subst (motive := fun g => M.le (paced f h reads c (r' + 1)).2 g) (read_at r first).symm
      (Eq.subst (motive := fun g => M.le g (h (paced f h reads c r).1 (paced f h reads c r).2))
        (read_at r' second).symm (against _ _ _ _ rose))

end Against

section Order

variable {P : Ideals.Preorder S} {M : Ideals.Preorder R}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- **Two courses of a monotone two-level law keep their order** at every step. -/
theorem order_kept (selects : ∀ x y g g', P.le x y → M.le g g' → P.le (f x g) (f y g'))
    (monotone : ReadsShare P M h) {c c' : S × R} (le : P.le c.1 c'.1) (le' : M.le c.2 c'.2) :
    ∀ t, P.le (paced f h reads c t).1 (paced f h reads c' t).1 ∧
      M.le (paced f h reads c t).2 (paced f h reads c' t).2
  | 0 => ⟨le, le'⟩
  | t + 1 =>
    have now := order_kept selects monotone le le' t
    have step : ∀ b : Bool, P.le (turn f h b (paced f h reads c t)).1
        (turn f h b (paced f h reads c' t)).1 ∧
        M.le (turn f h b (paced f h reads c t)).2 (turn f h b (paced f h reads c' t)).2
      | true => ⟨selects _ _ _ _ now.1 now.2, monotone _ _ _ _ now.1⟩
      | false => ⟨selects _ _ _ _ now.1 now.2, now.2⟩
    Eq.subst (motive := fun p : S × R => P.le p.1 (paced f h reads c' (t + 1)).1 ∧
        M.le p.2 (paced f h reads c' (t + 1)).2) (paced_succ c t).symm
      (Eq.subst (motive := fun p : S × R => P.le (turn f h (reads t) (paced f h reads c t)).1 p.1 ∧
          M.le (turn f h (reads t) (paced f h reads c t)).2 p.2) (paced_succ c' t).symm
        (step (reads t)))

/-- **A perturbation lowering the rule keeps its course below the course without it.** Perturbing
the rule at step `a` to one not above it, the perturbed course (the course from the perturbed
configuration, the schedule read from `a`) is at no later step above the course without the
perturbation, in share or in rule. -/
theorem perturbation_keeps_below (selects : ∀ x y g g', P.le x y → M.le g g' → P.le (f x g) (f y g'))
    (monotone : ReadsShare P M h) {c : S × R} {a : Nat} {g' : R}
    (lower : M.le g' (paced f h reads c a).2) (k : Nat) :
    P.le (paced f h (fun u => reads (a + u)) ((paced f h reads c a).1, g') k).1
        (paced f h reads c (a + k)).1 ∧
      M.le (paced f h (fun u => reads (a + u)) ((paced f h reads c a).1, g') k).2
        (paced f h reads c (a + k)).2 :=
  Eq.subst (motive := fun p : S × R =>
      P.le (paced f h (fun u => reads (a + u)) ((paced f h reads c a).1, g') k).1 p.1 ∧
        M.le (paced f h (fun u => reads (a + u)) ((paced f h reads c a).1, g') k).2 p.2)
    (paced_shift c a k).symm
    (order_kept (reads := fun u => reads (a + u)) (c := ((paced f h reads c a).1, g'))
      (c' := paced f h reads c a) selects monotone (P.refl _) lower k)

end Order

/-! ## Counts: the share of a target and the rule of selection -/

/-- Two counts, the second positive. Read as a population: the carriers of a target and the others,
the others present. Read as a rule of selection: the offspring each carrier leaves and the offspring
each other leaves, each other leaving at least one. -/
structure CarrierCounts where
  carrier : Nat
  other : Nat
  other_pos : 0 < other

namespace CarrierCounts

/-- **The share order**: the carriers stand to the others in `y` at least as in `x`, by
cross-multiplication, as in `share_not_lower`. -/
def order : Ideals.Preorder CarrierCounts where
  le x y := x.carrier * y.other ≤ y.carrier * x.other
  refl _ := Nat.le_refl _
  trans {x y z} xy yz := Nat.le_of_mul_le_mul_right
    (calc x.carrier * z.other * y.other
        = x.carrier * y.other * z.other := Naturals.mul_right_comm _ _ _
      _ ≤ y.carrier * x.other * z.other := Nat.mul_le_mul_right _ xy
      _ = y.carrier * z.other * x.other := Naturals.mul_right_comm _ _ _
      _ ≤ z.carrier * y.other * x.other := Nat.mul_le_mul_right _ yz
      _ = z.carrier * x.other * y.other := Naturals.mul_right_comm _ _ _) y.other_pos

/-- The rule favours the carriers: each carrier leaves at least as many offspring as each other.
Read of a population: the carriers are at least as many as the others. -/
def favours (g : CarrierCounts) : Prop := g.other ≤ g.carrier

/-- The rule favours the others. -/
def disfavours (g : CarrierCounts) : Prop := g.carrier ≤ g.other

/-- **Selection by a rule**: each carrier leaves `g.carrier` offspring, each other `g.other`. -/
def select (x g : CarrierCounts) : CarrierCounts :=
  ⟨x.carrier * g.carrier, x.other * g.other, Nat.mul_pos x.other_pos g.other_pos⟩

/-- **Selection by a favouring rule does not lower the share.** -/
theorem raises : Raises order favours select := fun x g fav =>
  calc x.carrier * (x.other * g.other)
      = x.carrier * x.other * g.other := (mul_assoc_nat _ _ _).symm
    _ ≤ x.carrier * x.other * g.carrier := Nat.mul_le_mul_left _ fav
    _ = x.carrier * g.carrier * x.other := Naturals.mul_right_comm _ _ _

/-- **Selection by a rule favouring strictly raises the share strictly**, carriers present. -/
theorem rises_strictly {x g : CarrierCounts} (some : 0 < x.carrier) (lt : g.other < g.carrier) :
    x.carrier * (select x g).other < (select x g).carrier * x.other :=
  calc x.carrier * (x.other * g.other)
      = x.carrier * x.other * g.other := (mul_assoc_nat _ _ _).symm
    _ < x.carrier * x.other * g.carrier := Nat.mul_lt_mul_of_pos_left lt (Nat.mul_pos some x.other_pos)
    _ = x.carrier * g.carrier * x.other := Naturals.mul_right_comm _ _ _

/-- **Selection by a disfavouring rule does not raise the share.** -/
theorem lowers : Raises (reverse order) disfavours select := fun x g dis =>
  calc x.carrier * g.carrier * x.other
      = x.carrier * x.other * g.carrier := Naturals.mul_right_comm _ _ _
    _ ≤ x.carrier * x.other * g.other := Nat.mul_le_mul_left _ dis
    _ = x.carrier * (x.other * g.other) := mul_assoc_nat _ _ _

/-- **Favouring is kept by every rule not lower.** -/
theorem upper {g g' : CarrierCounts} (le : order.le g g') (fav : favours g) : favours g' :=
  Nat.le_of_mul_le_mul_right
    (calc g'.other * g.other
        ≤ g'.other * g.carrier := Nat.mul_le_mul_left _ fav
      _ = g.carrier * g'.other := Nat.mul_comm _ _
      _ ≤ g'.carrier * g.other := le) g.other_pos

/-- **Disfavouring is kept by every rule not higher.** -/
theorem lower {g g' : CarrierCounts} (le : (reverse order).le g g') (dis : disfavours g) : disfavours g' :=
  Nat.le_of_mul_le_mul_right
    (calc g'.carrier * g.other
        ≤ g.carrier * g'.other := le
      _ ≤ g.other * g'.other := Nat.mul_le_mul_right _ dis
      _ = g'.other * g.other := Nat.mul_comm _ _) g.other_pos

/-- **Selection is monotone in the population and in the rule.** -/
theorem select_mono {x y g g' : CarrierCounts} (le : order.le x y) (le' : order.le g g') :
    order.le (select x g) (select y g') :=
  calc x.carrier * g.carrier * (y.other * g'.other)
      = x.carrier * y.other * (g.carrier * g'.other) := Naturals.mul_mul_mul_comm _ _ _ _
    _ ≤ y.carrier * x.other * (g'.carrier * g.other) := Nat.mul_le_mul le le'
    _ = y.carrier * g'.carrier * (x.other * g.other) := Naturals.mul_mul_mul_comm _ _ _ _

/-- **The share order is the comparison of `share_not_lower`.** Carriers `ms` each leaving at least
`a` offspring and others `es` each at most `b ≤ a`, others present before and after: the counts
after are not lower in share than the counts before. -/
theorem share_not_lower_counts {α : Type} {kids : α → List α} {ms es : List α} {a b : Nat}
    (carriers : ∀ p, p ∈ ms → a ≤ (kids p).length) (others : ∀ p, p ∈ es → (kids p).length ≤ b)
    (le : b ≤ a) (present : 0 < es.length) (present' : 0 < offspringCount es kids) :
    order.le ⟨ms.length, es.length, present⟩ ⟨offspringCount ms kids, offspringCount es kids, present'⟩ :=
  share_not_lower carriers others le

/-- **Along every course, selection by a rule favouring strictly raises the share strictly**, the
carriers present, whatever the reading and the schedule. -/
theorem rises_strictly_along {hR : CarrierCounts → CarrierCounts → CarrierCounts} {reads : Nat → Bool} (c : CarrierCounts × CarrierCounts)
    (t : Nat) (some : 0 < (paced select hR reads c t).1.carrier)
    (lt : (paced select hR reads c t).2.other < (paced select hR reads c t).2.carrier) :
    (paced select hR reads c t).1.carrier * (paced select hR reads c (t + 1)).1.other <
      (paced select hR reads c (t + 1)).1.carrier * (paced select hR reads c t).1.other :=
  Eq.subst (motive := fun y : CarrierCounts => (paced select hR reads c t).1.carrier * y.other <
      y.carrier * (paced select hR reads c t).1.other) (paced_fast_succ c t).symm (rises_strictly some lt)

/-- **On counts, a perturbation lowering the rule keeps its course below.** Under every reading
monotone in the share, the rule perturbed at step `a` to one not above it, the perturbed course is at
no later step above the course without the perturbation, in share or in rule. -/
theorem perturbation_keeps_below_counts {hR : CarrierCounts → CarrierCounts → CarrierCounts} (monotone : ReadsShare order order hR)
    {reads : Nat → Bool} {c : CarrierCounts × CarrierCounts} {a : Nat} {g' : CarrierCounts}
    (lower : order.le g' (paced select hR reads c a).2) (k : Nat) :
    order.le (paced select hR (fun u => reads (a + u)) ((paced select hR reads c a).1, g') k).1
        (paced select hR reads c (a + k)).1 ∧
      order.le (paced select hR (fun u => reads (a + u)) ((paced select hR reads c a).1, g') k).2
        (paced select hR reads c (a + k)).2 :=
  perturbation_keeps_below (fun _ _ _ _ => select_mono) monotone lower k

/-- **The proportional reading**: the rule read leaves each kind offspring in proportion to how many
of its kind there are. -/
def proportional (x _ : CarrierCounts) : CarrierCounts := x

theorem proportional_reads : ReadsShare order order proportional := fun _ _ _ _ le => le

/-- **A threshold reading**: the rule read is `hi` where the carriers are at least as many as the
others, `lo` elsewhere. -/
def threshold (hi lo : CarrierCounts) (x _ : CarrierCounts) : CarrierCounts := if x.other ≤ x.carrier then hi else lo

theorem threshold_above {hi lo x g : CarrierCounts} (fav : favours x) : threshold hi lo x g = hi :=
  if_pos fav

theorem threshold_below {hi lo x g : CarrierCounts} (dis : ¬ favours x) : threshold hi lo x g = lo :=
  if_neg dis

/-- **A threshold reading with `lo` not above `hi` is monotone in the share.** -/
theorem threshold_reads {hi lo : CarrierCounts} (step : order.le lo hi) :
    ReadsShare order order (threshold hi lo) := fun x y _ _ le =>
  if hx : x.other ≤ x.carrier then
    Eq.mpr (congr (congrArg order.le (threshold_above hx)) (threshold_above (upper le hx)))
      (order.refl hi)
  else if hy : y.other ≤ y.carrier then
    Eq.mpr (congr (congrArg order.le (threshold_below hx)) (threshold_above hy)) step
  else
    Eq.mpr (congr (congrArg order.le (threshold_below hx)) (threshold_below hy)) (order.refl lo)

/-- **A threshold reading between two favouring rules favours at every share.** -/
theorem threshold_favours {hi lo : CarrierCounts} (fhi : favours hi) (flo : favours lo) :
    ∀ x g, favours (threshold hi lo x g) := fun x _ =>
  if hx : x.other ≤ x.carrier then Eq.mpr (congrArg favours (threshold_above hx)) fhi
  else Eq.mpr (congrArg favours (threshold_below hx)) flo

/-- **A margin**: each carrier leaves `a + m` offspring and each other `a`. -/
def margin (a m : Nat) (pos : 0 < a) : CarrierCounts := ⟨a + m, a, pos⟩

theorem margin_favours {a m : Nat} {pos : 0 < a} : favours (margin a m pos) := Nat.le_add_right a m

/-- A margin not lower is a rule not lower. -/
theorem margin_le {a m m' : Nat} {pos : 0 < a} (le : m ≤ m') :
    order.le (margin a m pos) (margin a m' pos) :=
  Nat.mul_le_mul_right a (Nat.add_le_add_left le a)

/-- **The rule read as a margin**: the margin `φ x` read from the share at `x`. -/
def byMargin (a : Nat) (pos : 0 < a) (φ : CarrierCounts → Nat) (x _ : CarrierCounts) : CarrierCounts := margin a (φ x) pos

/-- A margin read monotonically in the share is a reading monotone in the share. -/
theorem byMargin_reads {a : Nat} {pos : 0 < a} {φ : CarrierCounts → Nat}
    (mono : ∀ x y, order.le x y → φ x ≤ φ y) : ReadsShare order order (byMargin a pos φ) :=
  fun x y _ _ le => margin_le (mono x y le)

/-- **Selection by a margin read from the share.** Every rule a margin, each carrier leaving
`a + m` offspring and each other `a`, and the margin at a reading step a monotone function of the
share: from every start under a margin, the share falls at no step, and from the step after the
first reading step on the margin falls at no step either. -/
theorem margin_course {a : Nat} {pos : 0 < a} {φ : CarrierCounts → Nat}
    (mono : ∀ x y, order.le x y → φ x ≤ φ y) (x : CarrierCounts) (m : Nat) (reads : Nat → Bool) :
    (∀ t, order.le (paced select (byMargin a pos φ) reads (x, margin a m pos) t).1
        (paced select (byMargin a pos φ) reads (x, margin a m pos) (t + 1)).1) ∧
      ∀ r, reads r = true → ∀ k,
        order.le (paced select (byMargin a pos φ) reads (x, margin a m pos) (r + 1 + k)).2
          (paced select (byMargin a pos φ) reads (x, margin a m pos) (r + 1 + k + 1)).2 :=
  have both := favouring_locks (reads := reads) (c := (x, margin a m pos)) raises (byMargin_reads mono)
    (fun _ _ => margin_favours) margin_favours
  ⟨both.1, fun r at_r k => (locked_rises raises (byMargin_reads mono) upper (both.2 r at_r) k).2⟩

/-- **Under the proportional reading, the kind holding more holds more.** From a rule that favours
and is not above the population's own proportion, under every schedule of reading, neither the
carriers' share nor the rule falls at any step. -/
theorem proportional_locks {x g : CarrierCounts} (fav : favours g) (below : order.le g x)
    (reads : Nat → Bool) (t : Nat) :
    order.le (paced select proportional reads (x, g) t).1
        (paced select proportional reads (x, g) (t + 1)).1 ∧
      order.le (paced select proportional reads (x, g) t).2
        (paced select proportional reads (x, g) (t + 1)).2 :=
  Eq.subst (motive := fun n => order.le (paced select proportional reads (x, g) n).1
        (paced select proportional reads (x, g) (n + 1)).1 ∧
      order.le (paced select proportional reads (x, g) n).2
        (paced select proportional reads (x, g) (n + 1)).2) (Nat.zero_add t)
    (locked_rises (reads := reads) (c := (x, g)) (t := 0) raises proportional_reads upper
      ⟨fav, below⟩ t)

/-- **And the kind holding less holds less.** From a rule that disfavours and is not below the
population's own proportion, neither the carriers' share nor the rule rises at any step. -/
theorem proportional_locks_down {x g : CarrierCounts} (dis : disfavours g) (above : order.le x g)
    (reads : Nat → Bool) (t : Nat) :
    order.le (paced select proportional reads (x, g) (t + 1)).1
        (paced select proportional reads (x, g) t).1 ∧
      order.le (paced select proportional reads (x, g) (t + 1)).2
        (paced select proportional reads (x, g) t).2 :=
  Eq.subst (motive := fun n => order.le (paced select proportional reads (x, g) (n + 1)).1
        (paced select proportional reads (x, g) n).1 ∧
      order.le (paced select proportional reads (x, g) (n + 1)).2
        (paced select proportional reads (x, g) n).2) (Nat.zero_add t)
    (locked_rises (P := reverse order) (M := reverse order) (reads := reads) (c := (x, g)) (t := 0) lowers
      proportional_reads.reverse lower ⟨dis, above⟩ t)

end CarrierCounts

/-! ## Witnesses -/

namespace CarrierCounts

/-- The rule that favours the carriers four to one. -/
def hi : CarrierCounts := ⟨4, 1, Nat.zero_lt_succ 0⟩

/-- The rule that favours the others four to one. -/
def lo : CarrierCounts := ⟨1, 4, Nat.zero_lt_succ 3⟩

/-- Two to one: as a population, two carriers to each other; as a rule, each carrier leaving two
offspring to each other's one. -/
def twoToOne : CarrierCounts := ⟨2, 1, Nat.zero_lt_succ 0⟩

theorem lo_le_hi : order.le lo hi := show 1 * 1 ≤ 4 * 4 by decide

theorem hi_not_le_lo : ¬ order.le hi lo := show ¬ 4 * 4 ≤ 1 * 1 by decide

theorem hi_not_le_twoToOne : ¬ order.le hi twoToOne := show ¬ 4 * 1 ≤ 2 * 1 by decide

theorem twoToOne_le_hi : order.le twoToOne hi := show 2 * 1 ≤ 4 * 1 by decide

/-- One step of a course read at every step: the carriers and the others multiply by what the
rule in force gives each, and the rule becomes what the reading gives. -/
theorem always_step {hR : CarrierCounts → CarrierCounts → CarrierCounts} (c : CarrierCounts × CarrierCounts) (t : Nat) :
    (paced select hR (fun _ => true) c (t + 1)).1.carrier =
        (paced select hR (fun _ => true) c t).1.carrier * (paced select hR (fun _ => true) c t).2.carrier ∧
      (paced select hR (fun _ => true) c (t + 1)).1.other =
        (paced select hR (fun _ => true) c t).1.other * (paced select hR (fun _ => true) c t).2.other ∧
      (paced select hR (fun _ => true) c (t + 1)).2 =
        hR (paced select hR (fun _ => true) c t).1 (paced select hR (fun _ => true) c t).2 :=
  ⟨congrArg (fun p : CarrierCounts × CarrierCounts => p.1.carrier) (paced_succ c t),
   congrArg (fun p : CarrierCounts × CarrierCounts => p.1.other) (paced_succ c t),
   congrArg Prod.snd (paced_succ c t)⟩

end CarrierCounts

/-! ### Witness: without the lock, a reading one step late alternates

Carriers two to one, the rule in force favouring the others four to one, the threshold reading
`hi`/`lo` read at every step. The configuration with the rule `hi` is locked; the course is the one
from it with its rule reversed. -/

namespace Alternating

open CarrierCounts

/-- The course of the threshold reading read at every step, from carriers two to one under `lo`. -/
def course (t : Nat) : CarrierCounts × CarrierCounts := paced select (threshold hi lo) (fun _ => true) (twoToOne, lo) t

theorem course_step (t : Nat) :
    (course (t + 1)).1.carrier = (course t).1.carrier * (course t).2.carrier ∧
      (course (t + 1)).1.other = (course t).1.other * (course t).2.other ∧
      (course (t + 1)).2 = threshold hi lo (course t).1 (course t).2 :=
  always_step _ t

/-- **Before its rule is reversed, the configuration is locked.** -/
theorem before_locked : Locked order favours (threshold hi lo) (twoToOne, hi) :=
  ⟨show 1 ≤ 4 by decide, show 4 * 1 ≤ 4 * 1 by decide⟩

/-- A count is below four times itself where it is positive. -/
theorem lt_four {o : Nat} (pos : 0 < o) : o < o * 4 :=
  Eq.subst (motive := fun n => n < o * 4) (Nat.mul_one o)
    (Nat.mul_lt_mul_of_pos_left (show 1 < 4 by decide) pos)

/-- From an even step whose carriers are twice the others under `lo`, the next step. -/
theorem from_even {k : Nat} (ih : (course (2 * k)).1.carrier = (course (2 * k)).1.other * 2 ∧
      (course (2 * k)).2 = lo) :
    favours (course (2 * k)).1 ∧
      (course (2 * k + 1)).1.carrier = (course (2 * k)).1.other * 2 ∧
      (course (2 * k + 1)).1.other = (course (2 * k)).1.other * 4 ∧
      (course (2 * k + 1)).2 = hi ∧ ¬ favours (course (2 * k + 1)).1 := by
  have pos := (course (2 * k)).1.other_pos
  have up : favours (course (2 * k)).1 :=
    show (course (2 * k)).1.other ≤ (course (2 * k)).1.carrier by
      rw [ih.1, Nat.mul_two]; exact Nat.le_add_right _ _
  have c1 : (course (2 * k + 1)).1.carrier = (course (2 * k)).1.other * 2 := by
    rw [(course_step (2 * k)).1, ih.2, ih.1]; exact Nat.mul_one _
  have o1 : (course (2 * k + 1)).1.other = (course (2 * k)).1.other * 4 := by
    rw [(course_step (2 * k)).2.1, ih.2]; rfl
  refine ⟨up, c1, o1, (course_step (2 * k)).2.2.trans (threshold_above up), fun fav => ?_⟩
  have fav' : (course (2 * k + 1)).1.other ≤ (course (2 * k + 1)).1.carrier := fav
  rw [o1, c1] at fav'
  exact Nat.not_le_of_gt (Nat.mul_lt_mul_of_pos_left (show 2 < 4 by decide) pos) fav'

/-- At every even step the carriers are twice the others and the rule in force favours the others. -/
theorem even : ∀ k, (course (2 * k)).1.carrier = (course (2 * k)).1.other * 2 ∧ (course (2 * k)).2 = lo
  | 0 => ⟨rfl, rfl⟩
  | k + 1 => by
    have ih := even k
    have step := from_even ih
    have c2 : (course (2 * k + 1 + 1)).1.carrier = (course (2 * k)).1.other * 2 * 4 := by
      rw [(course_step (2 * k + 1)).1, step.2.2.2.1, step.2.1]; rfl
    have o2 : (course (2 * k + 1 + 1)).1.other = (course (2 * k)).1.other * 4 := by
      rw [(course_step (2 * k + 1)).2.1, step.2.2.2.1, step.2.2.1]; exact Nat.mul_one _
    have r2 : (course (2 * k + 1 + 1)).2 = lo :=
      (course_step (2 * k + 1)).2.2.trans (threshold_below step.2.2.2.2)
    show (course (2 * k + 1 + 1)).1.carrier = (course (2 * k + 1 + 1)).1.other * 2 ∧
      (course (2 * k + 1 + 1)).2 = lo
    rw [c2, o2]
    exact ⟨Naturals.mul_right_comm _ _ _, r2⟩

/-- At every odd step the others are twice the carriers and the rule in force favours the
carriers. -/
theorem odd (k : Nat) :
    (course (2 * k + 1)).1.other = (course (2 * k + 1)).1.carrier * 2 ∧ (course (2 * k + 1)).2 = hi := by
  have step := from_even (even k)
  rw [step.2.2.1, step.2.1]
  exact ⟨(mul_assoc_nat _ 2 2).symm, step.2.2.2.1⟩

/-- **Share and rule fall forever.** At every even step the share falls, and at every odd step, a
reading step, the rule falls: the claim that share and rule do not fall at reading steps fails for
a course started against its reading. -/
theorem alternates (k : Nat) :
    ¬ order.le (course (2 * k)).1 (course (2 * k + 1)).1 ∧
      ¬ order.le (course (2 * k + 1)).2 (course (2 * k + 2)).2 := by
  have e := even k
  have step := from_even e
  have pos := (course (2 * k)).1.other_pos
  refine ⟨fun le => ?_, fun le => ?_⟩
  · have le' : (course (2 * k)).1.carrier * (course (2 * k + 1)).1.other ≤
        (course (2 * k + 1)).1.carrier * (course (2 * k)).1.other := le
    rw [step.2.2.1, step.2.1, e.1] at le'
    have twice : 0 < (course (2 * k)).1.other * 2 := Nat.mul_pos pos (by decide)
    exact Nat.not_le_of_gt (lt_four pos) (Nat.le_of_mul_le_mul_left le' twice)
  · have r2 : (course (2 * k + 1 + 1)).2 = lo := (even (k + 1)).2
    have le' : order.le (course (2 * k + 1)).2 (course (2 * k + 1 + 1)).2 := le
    rw [step.2.2.2.1, r2] at le'
    exact hi_not_le_lo le'

/-- **The course is never locked, either way.** -/
theorem never_locked (k : Nat) :
    (¬ Locked order favours (threshold hi lo) (course (2 * k)) ∧
        ¬ Locked (reverse order) disfavours (threshold hi lo) (course (2 * k))) ∧
      (¬ Locked order favours (threshold hi lo) (course (2 * k + 1)) ∧
        ¬ Locked (reverse order) disfavours (threshold hi lo) (course (2 * k + 1))) := by
  have e := even k
  have step := from_even e
  refine ⟨⟨fun lock => ?_, fun lock => ?_⟩, ⟨fun lock => ?_, fun lock => ?_⟩⟩
  · have fav : favours (course (2 * k)).2 := lock.1
    rw [e.2] at fav
    exact (show ¬ (4 ≤ 1) by decide) fav
  · have below : order.le (threshold hi lo (course (2 * k)).1 (course (2 * k)).2) (course (2 * k)).2 :=
      lock.2
    rw [threshold_above step.1, e.2] at below
    exact hi_not_le_lo below
  · have below : order.le (course (2 * k + 1)).2
        (threshold hi lo (course (2 * k + 1)).1 (course (2 * k + 1)).2) := lock.2
    rw [threshold_below step.2.2.2.2, step.2.2.2.1] at below
    exact hi_not_le_lo below
  · have dis : disfavours (course (2 * k + 1)).2 := lock.1
    rw [step.2.2.2.1] at dis
    exact (show ¬ (4 ≤ 1) by decide) dis

end Alternating

/-! ### Witness: a reversing perturbation held until the share crosses is not absorbed

From the same locked configuration (carriers two to one under `hi`), the rule is reversed to `lo`
and held for one step before the threshold reading reads at every later step. -/

namespace Reversed

open CarrierCounts

/-- No reading at the first step, reading at every step after it. -/
def late : Nat → Bool := Witnesses.profile [false] true

/-- The course of the threshold reading on that schedule, from carriers two to one under `lo`. -/
def course (t : Nat) : CarrierCounts × CarrierCounts := paced select (threshold hi lo) late (twoToOne, lo) t

/-- **After one step under the reversed rule, the course is locked the other way.** The carriers
are now one to two, the rule in force favours the others and is not below what the reading gives. -/
theorem locked_down : Locked (reverse order) disfavours (threshold hi lo) (course 1) :=
  ⟨show 1 ≤ 4 by decide, show 1 * 4 ≤ 1 * 4 by decide⟩

/-- **The reversing perturbation is not absorbed.** Before it the configuration is locked; after
it, from step 1 on, neither the share nor the rule rises at any step, and the rule after the first
reading step is below the rule before the perturbation. -/
theorem not_absorbed :
    Locked order favours (threshold hi lo) (twoToOne, hi) ∧
      (∀ k, order.le (course (1 + k + 1)).1 (course (1 + k)).1 ∧
        order.le (course (1 + k + 1)).2 (course (1 + k)).2) ∧
      ¬ order.le hi (course 2).2 :=
  ⟨Alternating.before_locked,
   fun k => locked_rises (P := reverse order) (M := reverse order) (reads := late)
     (c := (twoToOne, lo)) (t := 1) lowers (threshold_reads lo_le_hi).reverse lower locked_down k,
   hi_not_le_lo⟩

end Reversed

/-! ### Witness: under a reading that favours at every share, the second reading step is exact

The threshold reading `hi`/`twoToOne` favours at every share. From carriers one to one under `lo`,
read at every step, the course is not locked at the step after its first reading step, and its
rule falls at its second. -/

namespace Second

open CarrierCounts

/-- One carrier to one other. -/
def oneToOne : CarrierCounts := ⟨1, 1, Nat.zero_lt_succ 0⟩

/-- The course of the threshold reading `hi`/`twoToOne` read at every step, from one to one under
`lo`. -/
def course (t : Nat) : CarrierCounts × CarrierCounts := paced select (threshold hi twoToOne) (fun _ => true) (oneToOne, lo) t

/-- **The bound of `uniform_locks` is exact.** The course is not locked at step 1, the step after
its first reading step; its rule falls across its second reading step; it is locked at step 2. -/
theorem second_exact :
    ¬ Locked order favours (threshold hi twoToOne) (course 1) ∧ ¬ order.le (course 1).2 (course 2).2 ∧
      Locked order favours (threshold hi twoToOne) (course 2) :=
  ⟨fun lock => hi_not_le_twoToOne lock.2, hi_not_le_twoToOne,
   uniform_locks (r := 0) (r' := 1) raises (threshold_reads twoToOne_le_hi)
     (threshold_favours (show 1 ≤ 4 by decide) (show 1 ≤ 2 by decide)) rfl rfl (by decide)⟩

end Second

end RuleCapture

end Becoming
