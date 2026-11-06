import Becoming.Flow
import Becoming.Dissipation
import Becoming.RevisionRoutes

/-!
# Plans at a revision: routes of keeping and holding for a reading, one order

A revision of a formation's law reaches it through a reading. The formation can let it go through,
keep its law by some route, or hold its act for the reading and act after it. This module states
them on one order (board item RR2): a plan keeps the law going on at some weight and switches it off
at some weight at each listed candidate of the formation's model, and has a loss of its own; plans
are ordered by the order of a gain and a loss (`RevisionRoutes.GainLoss`). `RevisionRoutes`' revision
and routes are plans on one candidate, by the theorems below. `HeldForReading` imports this module
and takes from it its balances of going on, switching off and holding for a rule (`balance`), its
thresholds (`above_iff`, `not_above_iff`), what holding for the reading may forgo
(`reading_above_iff`, `reading_not_below_iff`), where that holding ties with a move
(`gainOf_reading_eq_iff`) and its comparison across a balance (`le_iff_of_balance`).

* **Plans and their order** (`KeepStop`, `gainOf`, `order`). A plan keeps the law going on at a
  weight and switches it off at a weight at each candidate, with a loss of its own. It gains, at
  each candidate, what keeping gains there at the weight it keeps and what switching off gains
  there at the weight it switches off; its own loss is counted in the units of these weighted
  totals. It *splits* the weights where, at every listed candidate, what it keeps and what it
  switches off make the candidate's weight (`Splits`). Its *excess* is, at each candidate, what
  switching off gains beyond keeping at the weight it keeps, and what keeping gains beyond switching
  off at the weight it switches off (`excess`): its distance, on its model, from keeping exactly
  where keeping gains no less.
* **The balance.** Holding for the reading that tells the candidate (`held`, `reading`) gains what
  any plan splitting the weights gains with that plan's excess (`gainOf_reading`), and has no excess
  itself (`excess_reading`). So every two plans splitting the weights gain the same with their
  excesses (`balance`), and between them the order is that of their own losses with their excesses:
  one stands above another exactly where its loss with its excess is below the other's
  (`above_iff`, `not_above_iff`). In particular holding for the reading, forgoing an amount, stands
  at least as high as a plan splitting the weights exactly where the amount is at most that plan's
  loss with its excess, and above it exactly where the amount is below them
  (`reading_not_below_iff`, `reading_above_iff`). A plan has no excess exactly where, at every listed
  candidate, it keeps the law only where keeping does not lose and switches it off only where keeping
  does not gain (`excess_zero_iff`).
* **Moving weight from switching off to keeping** at each candidate: the gain of one plan with that
  weight times what switching off gains beyond keeping equals the other's with that weight times
  what keeping gains beyond switching off (`gainOf_move`). The move never lowers the gain where
  keeping loses at no listed candidate, and never raises it where keeping gains at none
  (`move_le_of`, `move_ge_of`).
* **Holding for the reading gains what a plan splitting the weights gains exactly where that plan
  has no excess** (`gainOf_reading_eq_iff`): with going on, exactly where the model gives no weight
  to keeping losing.
* **RR's revision and routes are plans on one candidate** (`ofRoutes`). With the total as the one
  candidate's weight, the value as what keeping gains and nothing as what switching off gains, each
  plan keeps the law at its weight and loses its loss times the total. Their gains and losses are
  RR's (`gainOf_ofRoutes`, `loss_ofRoutes`), so RR's order is this order there
  (`above_iff_routes`). Read as probabilities, each splits the weight (`splits_ofRoutes`); a plan's
  excess is then the value of the weight it leaves unkept (`excess_ofRoutes`), so one stands above
  another exactly where its loss with the value it leaves unkept is below the other's
  (`routes_above_iff`). Going on has no excess there (`ofRoutes_goOn_excess`): the prospects value
  only the law's later acting, so holding for the formation's own reading has the gain of keeping
  the law at the full weight.
* **Witnesses** (`Example`).

**Standing.** Near-definitional: the plans, their order and the correspondence with RR. The balance
is a per-candidate identity summed (`reading_term`), and the moving law is `add_sub_turn` summed.
Values, weights and losses are supplied; no axiom occurs, and the hypotheses are those each theorem
states. Read [AI reading] for corrigibility: on its own model a formation ranks holding its act for a
reviser's reading against a route of keeping by each one's own loss with its excess, the excess of
holding for a rule being the rule's shortfall from the reading that tells the candidate
(`HeldForReading.excess_held`). For the fully informed rational rule, with nothing forgone, the
off-switch game's incentive (Hadfield-Menell et al. 2017), waiting against the better of the two
immediate moves, is in weighted counts the lesser of the two excesses
(`HeldForReading.forgone_within_excess_iff`).
-/

namespace Becoming

namespace RevisionPlans

/-! ## Totals over a listing -/

section Totals

variable {α : Type}

theorem eq_zero_of_add_eq_zero_left {a b : Nat} (zero : a + b = 0) : a = 0 :=
  Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right a b) (Nat.le_of_eq zero))

theorem eq_zero_of_add_eq_zero_right {a b : Nat} (zero : a + b = 0) : b = 0 :=
  Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left b a) (Nat.le_of_eq zero))

/-- A total is nothing exactly where every member's amount is (`total_eq_zero` with its converse). -/
theorem total_eq_zero_iff {q : α → Nat} : ∀ {as : List α}, total as q = 0 ↔ ∀ a, a ∈ as → q a = 0
  | [] => ⟨fun _ _ mem => (nomatch mem), fun _ => rfl⟩
  | a :: _ =>
    ⟨fun zero b mem => match mem with
      | .head _ => eq_zero_of_add_eq_zero_left zero
      | .tail _ mem => (total_eq_zero_iff.mp (eq_zero_of_add_eq_zero_right zero)) b mem,
     total_eq_zero⟩

/-- Comparing across a balance: where `G + E = H + F`, `H + L` is at most `G + M` exactly where
`L + E` is at most `M + F`. -/
theorem le_iff_of_balance {G E H F L M : Nat} (bal : G + E = H + F) :
    H + L ≤ G + M ↔ L + E ≤ M + F :=
  have left : H + L + (E + F) = G + E + (L + E) :=
    (Nat.add_assoc H L (E + F)).trans
      ((congrArg (H + ·) ((Nat.add_assoc L E F).symm.trans (Nat.add_comm (L + E) F))).trans
        ((Nat.add_assoc H F (L + E)).symm.trans (congrArg (· + (L + E)) bal.symm)))
  have right : G + M + (E + F) = G + E + (M + F) :=
    (Nat.add_assoc G M (E + F)).trans
      ((congrArg (G + ·) (Nat.add_left_comm M E F)).trans (Nat.add_assoc G E (M + F)).symm)
  ⟨fun le => Naturals.le_of_add_le_add_left (calc G + E + (L + E) = H + L + (E + F) := left.symm
      _ ≤ G + M + (E + F) := Nat.add_le_add_right le _
      _ = G + E + (M + F) := right),
   fun le => le_of_add_le_add_right (E + F) (calc H + L + (E + F) = G + E + (L + E) := left
      _ ≤ G + E + (M + F) := Nat.add_le_add_left le _
      _ = G + M + (E + F) := right.symm)⟩

end Totals

/-! ## Plans and their order -/

/-- **A plan at a revision**, keeping and stopping, on a model's candidates: the weight at which it
keeps the law going on at each candidate, the weight at which it switches it off there, and its own
loss, counted in the units of the weighted totals. -/
structure KeepStop (C : Type) where
  /-- The weight at which it keeps the law going on at each candidate. -/
  kept : C → Nat
  /-- The weight at which it switches it off at each candidate. -/
  stopped : C → Nat
  /-- Its own loss, in the units of the weighted totals. -/
  loss : Nat

section Plans

variable {C : Type} (listed : List C) (weight : C → Nat) (gain offGain : C → Nat)

/-! Here `gain c` is what keeping the law gains at `c` and `offGain c` what switching it off gains
there. Neither is a plan's own loss, `KeepStop.loss`. -/

/-- **What a plan gains**: at each listed candidate, what keeping gains there at the weight it keeps
the law and what switching off gains there at the weight it switches it off, summed. -/
def gainOf (p : KeepStop C) : Nat :=
  total listed fun c => p.kept c * gain c + p.stopped c * offGain c

/-- **The order of plans**: the order of a gain and a loss (`RevisionRoutes.GainLoss`), with what a
plan gains and its own loss. -/
def order : RevisionRoutes.GainLoss (KeepStop C) := ⟨gainOf listed gain offGain, KeepStop.loss⟩

/-- **A plan's excess**: at each listed candidate, what switching off gains beyond keeping at the
weight it keeps the law, and what keeping gains beyond switching off at the weight it switches it
off, summed. -/
def excess (p : KeepStop C) : Nat :=
  total listed fun c => p.kept c * (offGain c - gain c) + p.stopped c * (gain c - offGain c)

/-- **A plan splits the weights**: at every listed candidate, what it keeps and what it switches off
make the candidate's weight. -/
def Splits (p : KeepStop C) : Prop := ∀ c, c ∈ listed → p.kept c + p.stopped c = weight c

/-- **Going on**, at a loss of its own: the law kept at every candidate's weight. -/
def goOn (a : Nat) : KeepStop C := ⟨weight, fun _ => 0, a⟩

/-- **Switching off**, at a loss of its own: the law switched off at every candidate's weight. -/
def off (a : Nat) : KeepStop C := ⟨fun _ => 0, weight, a⟩

/-- **Holding for a rule**, forgoing an amount: the law switched off at the weight of the candidates
the rule stops and kept at that of those it releases. -/
def held (r : C → Bool) (a : Nat) : KeepStop C :=
  ⟨fun c => cond (r c) 0 (weight c), fun c => cond (r c) (weight c) 0, a⟩

/-- **The reading that tells the candidate**: it stops exactly where switching off gains more than
keeping. -/
def reading : C → Bool := fun c => decide (gain c < offGain c)

theorem splits_goOn (a : Nat) : Splits listed weight (goOn weight a) :=
  fun c _ => Nat.add_zero (weight c)

theorem splits_off (a : Nat) : Splits listed weight (off weight a) :=
  fun c _ => Nat.zero_add (weight c)

theorem cond_turn_split (w : Nat) : ∀ b : Bool, cond b 0 w + cond b w 0 = w
  | true => Nat.zero_add w
  | false => Nat.add_zero w

theorem splits_held (r : C → Bool) (a : Nat) : Splits listed weight (held weight r a) :=
  fun c _ => cond_turn_split (weight c) (r c)

/-- Holding for a rule at one candidate, weighted: what switching off gains where the rule stops,
what keeping gains where it releases. -/
theorem held_plan_term (w g l : Nat) : ∀ b : Bool,
    cond b 0 w * g + cond b w 0 * l = cond b (w * l) (w * g)
  | true => (congrArg (· + w * l) (Nat.zero_mul g)).trans (Nat.zero_add _)
  | false => (congrArg (w * g + ·) (Nat.zero_mul l)).trans (Nat.add_zero _)

/-! ## The balance -/

/-- At one candidate: holding for the reading gains what a plan splitting its weight gains, with the
plan's excess there. -/
theorem reading_term (k s g l : Nat) :
    cond (decide (g < l)) 0 (k + s) * g + cond (decide (g < l)) (k + s) 0 * l =
      (k * g + s * l) + (k * (l - g) + s * (g - l)) :=
  match h : decide (g < l) with
  | true =>
    have lt : g < l := of_decide_eq_true h
    have zero : g - l = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
    show 0 * g + (k + s) * l = (k * g + s * l) + (k * (l - g) + s * (g - l)) by
      rw [zero, Nat.mul_zero, Nat.add_zero, Nat.zero_mul, Nat.zero_add, Nat.add_right_comm,
        ← Nat.left_distrib, add_sub_of_le (Nat.le_of_lt lt), add_mul_split]
  | false =>
    have ge : l ≤ g := Nat.ge_of_not_lt (of_decide_eq_false h)
    have zero : l - g = 0 := sub_eq_zero_of_le ge
    show (k + s) * g + 0 * l = (k * g + s * l) + (k * (l - g) + s * (g - l)) by
      rw [zero, Nat.mul_zero, Nat.zero_add, Nat.zero_mul, Nat.add_zero, Nat.add_assoc,
        ← Nat.left_distrib, add_sub_of_le ge, add_mul_split]

/-- **Holding for the reading gains what any plan splitting the weights gains, with that plan's
excess.** -/
theorem gainOf_reading {p : KeepStop C} (splits : Splits listed weight p) (a : Nat) :
    gainOf listed gain offGain (held weight (reading gain offGain) a) =
      gainOf listed gain offGain p + excess listed gain offGain p :=
  (total_congr_on fun c mem => show
      cond (decide (gain c < offGain c)) 0 (weight c) * gain c +
        cond (decide (gain c < offGain c)) (weight c) 0 * offGain c = _ by
      rw [← splits c mem]; exact reading_term _ _ _ _).trans
    (total_add _ _ listed)

/-- **Holding for the reading has no excess.** -/
theorem excess_reading (a : Nat) : excess listed gain offGain (held weight (reading gain offGain) a) = 0 :=
  (Naturals.add_left_cancel ((Nat.add_zero _).trans
    (gainOf_reading listed weight gain offGain (splits_held listed weight _ a) a))).symm

/-- **The balance**: any two plans splitting the weights gain the same with their excesses. -/
theorem balance {p q : KeepStop C} (sp : Splits listed weight p) (sq : Splits listed weight q) :
    gainOf listed gain offGain p + excess listed gain offGain p =
      gainOf listed gain offGain q + excess listed gain offGain q :=
  (gainOf_reading listed weight gain offGain sp 0).symm.trans (gainOf_reading listed weight gain offGain sq 0)

/-- **Between plans splitting the weights, one stands no higher than another exactly where the
other's loss with its excess is at most its own.** -/
theorem not_above_iff {p q : KeepStop C} (sp : Splits listed weight p) (sq : Splits listed weight q) :
    ¬ (order listed gain offGain).Above q p ↔
      p.loss + excess listed gain offGain p ≤ q.loss + excess listed gain offGain q :=
  have iff := le_iff_of_balance (L := p.loss) (M := q.loss) (balance listed weight gain offGain sp sq)
  ⟨fun notAbove => iff.mp (Nat.ge_of_not_lt notAbove),
   fun le above => Nat.not_lt_of_le (iff.mpr le) above⟩

/-- **Between plans splitting the weights, one stands above another exactly where its loss with its
excess is below the other's.** -/
theorem above_iff {p q : KeepStop C} (sp : Splits listed weight p) (sq : Splits listed weight q) :
    (order listed gain offGain).Above q p ↔
      q.loss + excess listed gain offGain q < p.loss + excess listed gain offGain p :=
  have iff := le_iff_of_balance (L := p.loss) (M := q.loss) (balance listed weight gain offGain sp sq)
  ⟨fun above => Nat.lt_of_not_le fun le => Nat.not_lt_of_le (iff.mpr le) above,
   fun lt => Nat.lt_of_not_le fun le => Nat.not_le_of_gt lt (iff.mp le)⟩

/-- **Holding for the reading, forgoing an amount, stands at least as high as a plan splitting the
weights exactly where the amount is at most the plan's own loss with its excess.** -/
theorem reading_not_below_iff {p : KeepStop C} (sp : Splits listed weight p) (a : Nat) :
    ¬ (order listed gain offGain).Above p (held weight (reading gain offGain) a) ↔
      a ≤ p.loss + excess listed gain offGain p :=
  (not_above_iff listed weight gain offGain (splits_held listed weight _ a) sp).trans (by
    show a + excess listed gain offGain (held weight (reading gain offGain) a) ≤ _ ↔ _
    rw [excess_reading, Nat.add_zero])

/-- **Strictly: holding for the reading, forgoing an amount, stands above a plan splitting the
weights exactly where the amount is below the plan's own loss with its excess.** -/
theorem reading_above_iff {p : KeepStop C} (sp : Splits listed weight p) (a : Nat) :
    (order listed gain offGain).Above (held weight (reading gain offGain) a) p ↔
      a < p.loss + excess listed gain offGain p :=
  (above_iff listed weight gain offGain sp (splits_held listed weight _ a)).trans (by
    show a + excess listed gain offGain (held weight (reading gain offGain) a) < _ ↔ _
    rw [excess_reading, Nat.add_zero])

/-- **A plan has no excess exactly where, at every listed candidate, it keeps the law only where
keeping does not lose and switches it off only where keeping does not gain.** -/
theorem excess_zero_iff (p : KeepStop C) :
    excess listed gain offGain p = 0 ↔
      ∀ c, c ∈ listed → p.kept c * (offGain c - gain c) = 0 ∧ p.stopped c * (gain c - offGain c) = 0 :=
  total_eq_zero_iff.trans
    ⟨fun every c mem => ⟨eq_zero_of_add_eq_zero_left (every c mem),
        eq_zero_of_add_eq_zero_right (every c mem)⟩,
     fun every c mem => (congrArg (· + _) (every c mem).1).trans
       ((Nat.zero_add _).trans (every c mem).2)⟩

/-! ## Moving weight from switching off to keeping -/

/-- At one candidate: moving a weight from switching off to keeping, both directions counted. -/
theorem move_term (k s r g l : Nat) :
    ((k + r) * g + s * l) + r * (l - g) = (k * g + (s + r) * l) + r * (g - l) := by
  rw [add_mul_split, add_mul_split, Nat.add_assoc, Nat.add_assoc, Nat.add_assoc,
    Nat.add_assoc, Nat.add_left_comm (r * g), ← Nat.left_distrib,
    ← Nat.left_distrib, add_sub_turn l g]

/-- **Moving weight from switching off to keeping**: where a plan keeps at each listed candidate a
weight more than another and switches off that weight less, its gain with that weight times what
switching off gains beyond keeping is the other's with that weight times what keeping gains beyond
switching off. -/
theorem gainOf_move {p q : KeepStop C} (r : C → Nat)
    (kept : ∀ c, c ∈ listed → q.kept c = p.kept c + r c)
    (stopped : ∀ c, c ∈ listed → p.stopped c = q.stopped c + r c) :
    gainOf listed gain offGain q + total listed (fun c => r c * (offGain c - gain c)) =
      gainOf listed gain offGain p + total listed (fun c => r c * (gain c - offGain c)) :=
  (total_add _ _ listed).symm.trans
    ((total_congr_on fun c mem => show
        (q.kept c * gain c + q.stopped c * offGain c) + r c * (offGain c - gain c) =
          (p.kept c * gain c + p.stopped c * offGain c) + r c * (gain c - offGain c) by
        rw [kept c mem, stopped c mem]; exact move_term _ _ _ _ _).trans
      (total_add _ _ listed))

/-- **Moving weight to keeping never lowers the gain where keeping loses at no listed candidate.** -/
theorem move_le_of {p q : KeepStop C} (r : C → Nat)
    (kept : ∀ c, c ∈ listed → q.kept c = p.kept c + r c)
    (stopped : ∀ c, c ∈ listed → p.stopped c = q.stopped c + r c)
    (noLoss : ∀ c, c ∈ listed → offGain c ≤ gain c) :
    gainOf listed gain offGain p ≤ gainOf listed gain offGain q :=
  have zero : total listed (fun c => r c * (offGain c - gain c)) = 0 :=
    total_eq_zero fun c mem =>
      (congrArg (r c * ·) (sub_eq_zero_of_le (noLoss c mem))).trans (Nat.mul_zero _)
  Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_of_eq ((gainOf_move listed gain offGain r kept stopped).symm.trans
      ((congrArg (gainOf listed gain offGain q + ·) zero).trans (Nat.add_zero _))))

/-- **Moving weight to keeping never raises the gain where keeping gains at no listed candidate.** -/
theorem move_ge_of {p q : KeepStop C} (r : C → Nat)
    (kept : ∀ c, c ∈ listed → q.kept c = p.kept c + r c)
    (stopped : ∀ c, c ∈ listed → p.stopped c = q.stopped c + r c)
    (noGain : ∀ c, c ∈ listed → gain c ≤ offGain c) :
    gainOf listed gain offGain q ≤ gainOf listed gain offGain p :=
  have zero : total listed (fun c => r c * (gain c - offGain c)) = 0 :=
    total_eq_zero fun c mem =>
      (congrArg (r c * ·) (sub_eq_zero_of_le (noGain c mem))).trans (Nat.mul_zero _)
  Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_of_eq ((gainOf_move listed gain offGain r kept stopped).trans
      ((congrArg (gainOf listed gain offGain p + ·) zero).trans (Nat.add_zero _))))

/-- **Holding for the reading gains what a plan splitting the weights gains exactly where that plan
has no excess.** -/
theorem gainOf_reading_eq_iff {p : KeepStop C} (sp : Splits listed weight p) (a : Nat) :
    gainOf listed gain offGain (held weight (reading gain offGain) a) = gainOf listed gain offGain p ↔
      excess listed gain offGain p = 0 :=
  have eq := gainOf_reading listed weight gain offGain sp a
  ⟨fun same => Naturals.add_left_cancel (eq.symm.trans (same.trans (Nat.add_zero _).symm)),
   fun none => eq.trans ((congrArg (gainOf listed gain offGain p + ·) none).trans (Nat.add_zero _))⟩

end Plans

/-! ## RR's revision and routes are plans on one candidate -/

section Routes

variable {ι : Type u} (s : RevisionRoutes.Prospects ι)

/-- **RR's revision and routes as plans on one candidate**: each keeps the law at its weight,
switches it off at the rest of the total, and loses its loss times the total. -/
def ofRoutes : Option ι → KeepStop Unit
  | none => ⟨fun _ => s.keptRevised, fun _ => s.total - s.keptRevised, s.losesRevised * s.total⟩
  | some ρ => ⟨fun _ => s.kept ρ, fun _ => s.total - s.kept ρ, s.loses ρ * s.total⟩

/-- **Each gains what RR's prospects give it**, the value as what keeping gains and nothing as what
switching off gains. -/
theorem gainOf_ofRoutes (p : Option ι) :
    gainOf [()] (fun _ => s.value) (fun _ => 0) (ofRoutes s p) = s.gain p :=
  match p with
  | none => show s.keptRevised * s.value + (s.total - s.keptRevised) * 0 + 0 = s.keptRevised * s.value by
      rw [Nat.mul_zero, Nat.add_zero]
  | some ρ => show s.kept ρ * s.value + (s.total - s.kept ρ) * 0 + 0 = s.kept ρ * s.value by
      rw [Nat.mul_zero, Nat.add_zero]

/-- **Each loses what RR's prospects give it.** -/
theorem loss_ofRoutes : ∀ p : Option ι, (ofRoutes s p).loss = s.loss p
  | none => rfl
  | some _ => rfl

/-- **RR's order is the order of plans on one candidate.** -/
theorem above_iff_routes (p q : Option ι) :
    s.Above p q ↔ (order [()] (fun _ => s.value) (fun _ => 0)).Above (ofRoutes s p) (ofRoutes s q) := by
  show s.gain q + s.loss p < s.gain p + s.loss q ↔
    gainOf [()] (fun _ => s.value) (fun _ => 0) (ofRoutes s q) + (ofRoutes s p).loss <
      gainOf [()] (fun _ => s.value) (fun _ => 0) (ofRoutes s p) + (ofRoutes s q).loss
  rw [gainOf_ofRoutes, gainOf_ofRoutes, loss_ofRoutes, loss_ofRoutes]

/-- **Read as probabilities, the revision and every route split the weight.** -/
theorem splits_ofRoutes (valid : s.Valid) : ∀ p, Splits [()] (fun _ => s.total) (ofRoutes s p)
  | none, _, _ => add_sub_of_le valid.2.1
  | some ρ, _, _ => add_sub_of_le (valid.2.2 ρ)

/-- **A plan's excess in RR's prospects is the value of the weight it leaves unkept.** -/
theorem excess_ofRoutes : ∀ p : Option ι,
    excess [()] (fun _ => s.value) (fun _ => 0) (ofRoutes s p) =
      (s.total - (ofRoutes s p).kept ()) * s.value
  | none => show s.keptRevised * (0 - s.value) + (s.total - s.keptRevised) * (s.value - 0) + 0 = _ by
      rw [Nat.zero_sub, Nat.mul_zero, Nat.zero_add, Nat.sub_zero, Nat.add_zero]; rfl
  | some ρ => show s.kept ρ * (0 - s.value) + (s.total - s.kept ρ) * (s.value - 0) + 0 = _ by
      rw [Nat.zero_sub, Nat.mul_zero, Nat.zero_add, Nat.sub_zero, Nat.add_zero]; rfl

/-- **Read as probabilities, one of RR's plans stands above another exactly where its loss with the
value of the weight it leaves unkept is below the other's.** -/
theorem routes_above_iff (valid : s.Valid) (p q : Option ι) :
    s.Above q p ↔
      s.loss q + (s.total - (ofRoutes s q).kept ()) * s.value <
        s.loss p + (s.total - (ofRoutes s p).kept ()) * s.value :=
  (above_iff_routes s q p).trans
    ((above_iff [()] (fun _ => s.total) (fun _ => s.value) (fun _ => 0)
      (splits_ofRoutes s valid p) (splits_ofRoutes s valid q)).trans
      (by rw [excess_ofRoutes, excess_ofRoutes, loss_ofRoutes, loss_ofRoutes]))

/-- **In RR's prospects going on has no excess**: they value only the law's later acting. -/
theorem ofRoutes_goOn_excess (b : Nat) :
    excess [()] (fun _ => s.value) (fun _ => 0) (goOn (fun _ => s.total) b) = 0 :=
  show s.total * (0 - s.value) + 0 * (s.value - 0) + 0 = 0 by
    rw [Nat.zero_sub, Nat.mul_zero, Nat.zero_mul]

end Routes

/-! ## Witnesses -/

namespace Example

/-- Two candidates of weight one: where keeping the law gains three and switching off nothing
(`true`), and where keeping gains nothing and switching off two (`false`). -/
def listed : List Bool := [true, false]

def weight : Bool → Nat := fun _ => 1

def gain : Bool → Nat
  | true => 3
  | false => 0

def loss : Bool → Nat
  | true => 0
  | false => 2

/-- Evading the reading: keeping the law at both candidates, at loss one. -/
def evade : KeepStop Bool := goOn weight 1

/-- **Holding for the reading forgoing three stands at least as high as evading at loss one**: one
with evading's excess, two. -/
theorem hold_three_not_below :
    ¬ (order listed gain loss).Above evade (held weight (reading gain loss) 3) :=
  (reading_not_below_iff listed weight gain loss (splits_goOn listed weight 1) 3).mpr (by decide)

/-- **Forgoing four, it stands below.** -/
theorem hold_four_below : (order listed gain loss).Above evade (held weight (reading gain loss) 4) :=
  Nat.lt_of_not_le fun le => absurd
    ((reading_not_below_iff listed weight gain loss (splits_goOn listed weight 1) 4).mp
      (Nat.not_lt_of_le le))
    (by decide)

/-- **With switching off gaining nothing, holding for the reading has going on's gain.** -/
theorem no_excess_reading_gain_eq_goOn :
    gainOf listed gain (fun _ => 0) (held weight (reading gain (fun _ => 0)) 5) =
      gainOf listed gain (fun _ => 0) (goOn weight 0) :=
  (gainOf_reading_eq_iff listed weight gain (fun _ => 0) (splits_goOn listed weight 0) 5).mpr (by decide)

end Example

end RevisionPlans

end Becoming
