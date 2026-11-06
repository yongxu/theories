import Becoming.Dependence

/-!
# Return: renewal graded by the time to return

`Becoming.Dependence` reads renewal and consumption over a whole run: a condition is
renewed when every dependence on it is kept at every step, and consumed when some
dependence holding at a step is not met at any later step. The two are exclusive, and
between them lie conditions that fall and recover. Here that middle is graded by how
soon a dependence is met.

A dependence holding at a step *returns within* `p` steps when the condition meets it
at one of the next `p` steps. A condition is *renewed within* `p` when every dependence
on it returns within `p`, and it *returns* when every dependence on it is met at some
later step. The readings of a formation then have forms over cycles of `p`. It renews
over cycles of `p` when every condition it participates in is renewed within `p`. Its
event *undermines for* `p` steps when it draws on a condition at a step after which, at
each of the next `p` steps, the condition is below both the present need of a dependence
on it and a need of that dependence met while it held; undermining for one step is
undermining at the step. Cycles have length at least one: within zero steps only a
condition nothing depends on is renewed, and any draw on a condition something depends
on undermines.

Results:
* The grades are ordered: renewal implies renewal within one step, renewal within `p`
  implies renewal within any longer cycle and implies return, and a condition that
  returns is not consumed. Consumption is exactly a dependence that never returns.
  Renewal within one step does not imply renewal (`LateMet`): it asks whether each
  dependence is met at the next step, not at its own.
* The seasonal condition of `RelationalRenewal`, neither renewed nor consumed, is renewed
  within two steps and not within one.
* A recovery can slow without bound. A condition that is met again after ever longer
  gaps always returns and is never consumed, yet no cycle length bounds its return.
* The readings over cycles extend the readings over steps: renewal implies renewal
  over cycles of one, and undermining at a step is undermining for one step. A longer cycle
  includes more, a formation renewing over any cycle is not consuming, and none of its
  events undermines for that cycle. Over cycles of two, a dip that breaks a dependence
  for one step is included, and a dependent whose condition a drawer broke while it was
  inactive renews. An escalation after which the condition never returns undermines for
  every cycle.

No ethical predicate, ranking or axiom occurs. Which grade an actual condition has,
which cycle suits a reading, and whether a lengthening recovery signals an approaching
loss are application and empirical questions.

The witness runs `Renewable.dip_within_two` and
`Renewable.escalation_undermines_for_every_cycle` are in `Becoming.Labelled`.
-/

namespace Becoming

open RelationalRenewal

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- `g`'s dependence on `c`, as it stands at `t`, is met within the next `p` steps. -/
def RestoredWithin (p t : Nat) (g : F) (c : C) : Prop :=
  ∃ k, 0 < k ∧ k ≤ p ∧ W.need t g c ≤ W.level (t + k) c

/-- Renewal over cycles of length `p`: every dependence on the condition is met within
the next `p` steps. -/
def RenewedWithin (p : Nat) (c : C) : Prop :=
  ∀ t g, W.requires t g c → W.RestoredWithin p t g c

/-- Every dependence on the condition is met at some later step. What returns is the condition's
level to a dependence's need; this is not a configuration coming back (`Law.Returns` of
`Becoming.Recurrence`, `Branching.Returns`), nor a loop of couplings (`Becoming.Returns` of
`Becoming.Frequency`). -/
def Restored (c : C) : Prop :=
  ∀ t g, W.requires t g c → ∃ k, 0 < k ∧ W.need t g c ≤ W.level (t + k) c

/-- A formation renews over cycles of `p` in the run: every condition it participates in
is renewed within `p`. -/
def RenewingInWithin (p : Nat) (f : F) : Prop :=
  ∀ t c, W.Participates t f c → W.RenewedWithin p c

/-- A formation's event at `t` undermines for `p` steps: it draws on a condition at a
step after which, at each of the next `p` steps, the condition is below a dependence's
present need and below a need of that dependence it met while the dependence held. -/
def UnderminingFor (p t : Nat) (f : F) : Prop :=
  ∃ c, W.draws t f c ∧ ∃ g, W.requires t g c ∧
    ∀ k, 0 < k → k ≤ p →
      W.MetAbove t g c (W.level (t + k) c) ∧ W.level (t + k) c < W.need t g c

variable {W}

theorem renewed_within_one {c : C} (renewed : W.Renewed c) : W.RenewedWithin 1 c :=
  fun t g depends => ⟨1, Nat.zero_lt_one, Nat.le_refl 1, (renewed t g depends).2⟩

/-- Cycles of length zero are degenerate: within zero steps only a condition nothing
depends on is renewed. -/
theorem renewedWithin_zero {c : C} : W.RenewedWithin 0 c ↔ ∀ t g, ¬ W.requires t g c :=
  ⟨fun renewed t g depends =>
    match renewed t g depends with
    | ⟨_, positive, within, _⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive within),
   fun none t g depends => absurd depends (none t g)⟩

theorem RenewedWithin.mono {p q : Nat} {c : C} (le : p ≤ q) (renewed : W.RenewedWithin p c) :
    W.RenewedWithin q c :=
  fun t g depends =>
    match renewed t g depends with
    | ⟨k, positive, within, met⟩ => ⟨k, positive, Nat.le_trans within le, met⟩

theorem RenewedWithin.restored {p : Nat} {c : C} (renewed : W.RenewedWithin p c) :
    W.Restored c :=
  fun t g depends =>
    match renewed t g depends with
    | ⟨k, positive, _, met⟩ => ⟨k, positive, met⟩

/-- A condition whose dependences all return is not consumed. -/
theorem Restored.not_consumed {c : C} (returns : W.Restored c) : ¬ W.Consumed c
  | ⟨g, T, depends, below⟩ =>
    match returns T g depends with
    | ⟨k, positive, met⟩ =>
      Nat.not_le_of_gt (below (T + k) (Nat.lt_add_of_pos_right positive)) met

/-- Consumption is exactly a dependence that never returns. -/
theorem consumed_iff {c : C} : W.Consumed c ↔
    ∃ g T, W.requires T g c ∧ ¬ ∃ k, 0 < k ∧ W.need T g c ≤ W.level (T + k) c :=
  ⟨fun ⟨g, T, depends, below⟩ =>
    ⟨g, T, depends, fun ⟨k, positive, met⟩ =>
      Nat.not_le_of_gt (below (T + k) (Nat.lt_add_of_pos_right positive)) met⟩,
   fun ⟨g, T, depends, never⟩ =>
    ⟨g, T, depends, fun t later => Nat.gt_of_not_le fun met =>
      match Nat.le.dest later with
      | ⟨m, sum⟩ =>
        have reached : T + (m + 1) = t := (Nat.succ_add T m).symm.trans sum
        never ⟨m + 1, Nat.succ_pos m,
          Nat.le_trans met (Nat.le_of_eq (congrArg (W.level · c) reached.symm))⟩⟩⟩

/-! ## Readings over cycles -/

theorem RenewingIn.within_one {f : F} (renewing : W.RenewingIn f) : W.RenewingInWithin 1 f :=
  fun t c joins => renewed_within_one (renewing t c joins)

/-- Undermining for one step is undermining at the step. -/
theorem undermining_for_one {t : Nat} {f : F} :
    W.UnderminingFor 1 t f ↔ W.UnderminingAt t f :=
  ⟨fun ⟨c, drawn, g, depends, unmet⟩ =>
    ⟨c, drawn, g, depends, unmet 1 Nat.zero_lt_one (Nat.le_refl 1)⟩,
   fun ⟨c, drawn, g, depends, met, fell⟩ =>
    ⟨c, drawn, g, depends, fun
      | 0, positive, _ => absurd positive (Nat.lt_irrefl 0)
      | 1, _, _ => ⟨met, fell⟩
      | k + 2, _, within => absurd (Nat.le_of_succ_le_succ within) (Nat.not_succ_le_zero k)⟩⟩

/-- Undermining for zero steps holds of any draw on a condition something depends on. -/
theorem undermining_for_zero {t : Nat} {f : F} :
    W.UnderminingFor 0 t f ↔ ∃ c, W.draws t f c ∧ ∃ g, W.requires t g c :=
  ⟨fun ⟨c, drawn, g, depends, _⟩ => ⟨c, drawn, g, depends⟩,
   fun ⟨c, drawn, g, depends⟩ => ⟨c, drawn, g, depends, fun _ positive within =>
     absurd (Nat.lt_of_lt_of_le positive within) (Nat.lt_irrefl 0)⟩⟩

theorem RenewingInWithin.mono {p q : Nat} {f : F} (le : p ≤ q)
    (renewing : W.RenewingInWithin p f) : W.RenewingInWithin q f :=
  fun t c joins => (renewing t c joins).mono le

/-- Undermining for a longer cycle is undermining for a shorter one. -/
theorem UnderminingFor.anti {p q t : Nat} {f : F} (le : p ≤ q) :
    W.UnderminingFor q t f → W.UnderminingFor p t f
  | ⟨c, drawn, g, depends, unmet⟩ =>
    ⟨c, drawn, g, depends, fun k positive within => unmet k positive (Nat.le_trans within le)⟩

/-- No event of a formation renewing over cycles of `p` undermines for `p` steps. -/
theorem RenewingInWithin.not_undermining_for {p t : Nat} {f : F}
    (renewing : W.RenewingInWithin p f) : ¬ W.UnderminingFor p t f
  | ⟨c, drawn, g, depends, unmet⟩ =>
    match renewing t c (Or.inr drawn) t g depends with
    | ⟨k, positive, within, back⟩ => Nat.not_le_of_gt (unmet k positive within).2 back

/-- A formation renewing over any cycle is not consuming. -/
theorem RenewingInWithin.not_consuming {p : Nat} {f : F} (renewing : W.RenewingInWithin p f) :
    ¬ W.ConsumingIn f
  | ⟨t, c, drawn, consumed⟩ => (renewing t c (Or.inr drawn)).restored.not_consumed consumed

end Web

/-! ## Renewal within one step is weaker than renewal -/

namespace LateMet

/-- The level is 0 at step 0 and 1 afterwards. One formation depends on the condition at
level one throughout and is active from step 1, where it is supported. -/
def web : Web Unit Unit :=
  ⟨fun t _ => match t with
    | 0 => 0
    | _ + 1 => 1,
   fun t _ => match t with
    | 0 => False
    | _ + 1 => True,
   fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- The dependence is not met at its own step 0, so it is not kept there, yet it is met
at every next step: the formation renews within one step and does not renew. -/
theorem within_one_not_renewing :
    web.Dependent ∧ web.RenewingInWithin 1 () ∧ ¬ web.RenewingIn () :=
  ⟨fun | 0, _, active, _, _ => False.elim active
       | _ + 1, _, _, _, _ => Nat.le_refl 1,
   fun _ _ _ _ _ _ => ⟨1, Nat.zero_lt_one, Nat.le_refl 1, Nat.le_refl 1⟩,
   fun renewing => Nat.not_succ_le_zero 0 (renewing 0 () (Or.inl trivial) 0 () trivial).1⟩

end LateMet

/-! ## A seasonal condition is renewed over cycles of two -/

/-- The level of `RelationalRenewal.fluctuating` is one and zero in turn. -/
theorem alternating_turns : ∀ n,
    (alternating n = 1 ∧ alternating (n + 1) = 0) ∨ (alternating n = 0 ∧ alternating (n + 1) = 1)
  | 0 => .inl ⟨rfl, rfl⟩
  | n + 1 =>
    match alternating_turns n with
    | .inl ⟨high, low⟩ => .inr ⟨low, high⟩
    | .inr ⟨low, high⟩ => .inl ⟨high, low⟩

/-- The seasonal condition of `RelationalRenewal`, neither renewed nor consumed, is
renewed over cycles of two steps and not of one. -/
theorem seasonal_renewed_within_two :
    (Web.static fluctuating).RenewedWithin 2 () ∧
    ¬ (Web.static fluctuating).RenewedWithin 1 () ∧ ¬ (Web.static fluctuating).Renewed () :=
  ⟨fun t _ _ =>
    match alternating_turns t with
    | .inl ⟨high, _⟩ => ⟨2, Nat.zero_lt_two, Nat.le_refl 2, Nat.le_of_eq high.symm⟩
    | .inr ⟨_, high⟩ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_of_eq high.symm⟩,
   fun renewed =>
    match renewed 0 () trivial with
    | ⟨0, positive, _, _⟩ => Nat.lt_irrefl 0 positive
    | ⟨1, _, _, met⟩ => Nat.not_succ_le_zero 0 met
    | ⟨_ + 2, _, within, _⟩ => Nat.not_succ_le_zero _ (Nat.le_of_succ_le_succ within),
   fun renewed => Nat.not_succ_le_zero 0 (renewed 0 () trivial).2⟩

/-! ## Recovery that slows without bound -/

namespace Slowing

/-- Steps left until the condition is next met, and the gap that follows that return.
Each return lengthens the next gap by one. -/
def phase : Nat → Nat × Nat
  | 0 => (0, 1)
  | t + 1 =>
    match phase t with
    | (0, g) => (g, g + 1)
    | (c + 1, g) => (c, g)

/-- The condition is met exactly at the returns. -/
def level (t : Nat) : Nat :=
  match (phase t).1 with
  | 0 => 1
  | _ + 1 => 0

/-- One formation depends on the condition at level one throughout. -/
def web : Web Unit Unit :=
  ⟨fun t _ => level t, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => False⟩

theorem phase_after_return {t g : Nat} (h : phase t = (0, g)) : phase (t + 1) = (g, g + 1) := by
  rw [phase, h]

theorem phase_counts_down {t c g : Nat} (h : phase t = (c + 1, g)) : phase (t + 1) = (c, g) := by
  rw [phase, h]

theorem phase_count : ∀ k {t c g : Nat}, phase t = (c + k, g) → phase (t + k) = (c, g)
  | 0, _, _, _, h => h
  | k + 1, t, _, _, h =>
    have shift : t + 1 + k = t + (k + 1) := Nat.succ_add t k
    shift ▸ phase_count k (t := t + 1) (phase_counts_down h)

theorem phase_next_return {t g : Nat} (h : phase t = (0, g)) :
    phase (t + 1 + g) = (0, g + 1) :=
  phase_count g (c := 0) ((Nat.zero_add g).symm ▸ phase_after_return h)

theorem phase_reaches : ∀ n, ∃ t, phase t = (0, n + 1)
  | 0 => ⟨0, rfl⟩
  | n + 1 =>
    match phase_reaches n with
    | ⟨t, h⟩ => ⟨t + 1 + (n + 1), phase_next_return h⟩

theorem met_at_return {t g : Nat} (h : phase t = (0, g)) : level t = 1 := by
  rw [level, h]

theorem unmet_before_return {t c g : Nat} (h : phase t = (c + 1, g)) : level t = 0 := by
  rw [level, h]

/-- The condition always returns. -/
theorem restored : web.Restored () := fun t _ _ =>
  have h : phase (t + 1) = (0 + (phase (t + 1)).1, (phase (t + 1)).2) :=
    (Nat.zero_add _).symm ▸ rfl
  ⟨1 + (phase (t + 1)).1, Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right 1 _),
    Nat.le_of_eq (Nat.add_assoc t 1 _ ▸ met_at_return (phase_count _ h)).symm⟩

/-- No bound on the return holds: after the `p + 1`-th gap opens, the condition is not
met for `p` steps. -/
theorem unbounded (p : Nat) : ¬ web.RenewedWithin p () := fun renewed =>
  match phase_reaches p with
  | ⟨T, hit⟩ =>
    match renewed (T + 1) () trivial with
    | ⟨k, _, within, met⟩ =>
      match Nat.le.dest within with
      | ⟨c, sum⟩ =>
        have shape : p + 1 = c + 1 + k := by
          rw [← sum, Nat.add_comm k c, Nat.add_right_comm]
        have gap : phase (T + 1) = (c + 1 + k, p + 1 + 1) :=
          shape ▸ phase_after_return hit
        Nat.not_succ_le_zero 0
          (Nat.le_trans met (Nat.le_of_eq (unmet_before_return (phase_count k gap))))

/-- A recovery that slows without bound: the condition always returns, it is not
consumed, and it is renewed over no bounded cycle. -/
theorem slowing_recovery :
    web.Restored () ∧ ¬ web.Consumed () ∧ ∀ p, ¬ web.RenewedWithin p () :=
  ⟨restored, restored.not_consumed, unbounded⟩

end Slowing

/-! ## Readings over cycles include a dip and withhold an escalation -/

namespace Dip

/-- Over cycles of two the dependent renews in the run, though it does not renew step by
step: the condition it depends on returns within two steps. -/
theorem renewing_within_two :
    web.RenewingInWithin 2 .dependent ∧ ¬ web.RenewingIn .dependent :=
  ⟨fun _ _ _ t g depends =>
    match t, g, depends with
    | 0, .dependent, _ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_refl 1⟩
    | 1, .dependent, _ => ⟨2, Nat.zero_lt_two, Nat.le_refl 2, Nat.le_refl 1⟩
    | 2, .dependent, _ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_refl 1⟩
    | _ + 3, .dependent, _ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_refl 1⟩,
   renewing_at_each_step_not_in_run.2.2⟩

end Dip

end Becoming
