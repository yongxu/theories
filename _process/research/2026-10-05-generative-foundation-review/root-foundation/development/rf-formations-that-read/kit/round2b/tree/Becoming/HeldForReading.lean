import Becoming.ShownOrder
import Becoming.ReadingLoop

/-!
# An act held for a reading

A formation can act on its model of which candidate holds, or hold its act for a reading that tells
which holds and act after it. This module states, in counts, what holding is worth, and the case
where the reading is another formation's: a principal's reading that stops or releases a helper's
held act (board item RF, round 2, second part: RF-M's assistance case). Helper and principal are
roles in one configuration, told apart by which senses and which acts; the values, weights and rules
are supplied, and their formation and warrant are not derived.

* **The worth of a reading, in counts.** A model lists candidates with natural-number weights, and
  acts have natural-number values at each candidate (`Model`, `Model.committed`, `Model.after`).
  Any policy choosing open acts, whether it reads the candidates through a lumping or reads nothing
  among them, stands at most as high as a policy best at each candidate, and as high exactly where
  its act is best at every candidate of positive weight (`after_le_after`, `after_eq_after_iff`).
  Committing to one act is the policy reading nothing (`committed_le_after`,
  `committed_eq_after_iff`): the reading gains over every act exactly where no act is best at every
  candidate of positive weight (`reading_gains_iff`), and over one act exactly where a candidate of
  positive weight tells that act from the policy's (`below_iff`).
* **Holding for a reading that stops or releases** (two moves, `Move`). Going on has a gain and a
  loss at each candidate and switching off has nothing; with the loss added to both moves at each
  candidate, going on is valued at the gain and switching off at the loss (`shifted`), every
  comparison between policies kept and every value a natural number. Holding for the reading that
  tells the candidate, which stops exactly where the loss exceeds the gain (`byReading`), stands at
  least as high as going on and as switching off (`held_le`), and above both exactly where some
  candidate of positive weight has going on lose and some has it gain (`held_gains_iff`): where the
  model leaves the act's sign open. A candidate where gain and loss are equal tells neither.
* **Any rule of stopping** (`byRule`). Holding for it stands at least as high as going on exactly
  where, over the candidates it stops, the weighted loss is at least the weighted gain
  (`rule_above_go_iff`), and at least as high as switching off exactly where, over those it
  releases, the weighted gain is at least the weighted loss (`rule_above_off_iff`).
* **The cost of holding and a rule's shortfall.** With the weighted margins by which going on gains
  and by which it loses (`gainMargin`, `lossMargin`) and a rule's shortfall from the reading that
  tells the candidate (`shortfall`: where it stops, the margin by which going on gains; where it
  releases, the margin by which going on loses), holding for the rule at a cost stands at least as
  high as going on exactly where shortfall and cost together are at most the loss margin, and above
  it exactly where they fall below it (`held_above_go_iff`); against switching off, the gain margin
  takes the loss margin's place (`held_above_off_iff`). The reading that tells the candidate falls
  short nowhere (`shortfall_byReading`), so holding for it at a cost stands at least as high as
  going on exactly where the cost is at most the loss margin, and at least as high as switching off
  exactly where it is at most the gain margin (`cost_within_margins_iff`).
* **Joined to the shown reach** (RF1). Picking one of two alternatives, with candidates ranking them
  by decided comparisons and each pick valued one where the candidate ranks it above the other
  (`pairValue`): where the first reaches the second in the shown relation of the principal's
  choices, every candidate that is a strict order according with the choices ranks the first above
  the second, and holding the pick gains nothing (`reach_fixes`, through
  `ChoiceOccasions.reach_within`); for candidates ranking no two alternatives both ways, holding
  gains over both picks exactly where candidates of positive weight rank the two both ways
  (`pair_gains_iff`). Beyond the reach strict according orders of both rankings exist
  (`ChoiceOccasions.both_ways_of_unreached`); whether the model gives both positive weight is not
  fixed by the choices.
* **A reading bypassed under a misspecified listing** (`Bypass`, a witness on `ReadingLoop.Loop`).
  A formation holds where the candidates it keeps disagree on the sign, goes on where all say going
  on gains, and switches off where none does; a held act is answered by the reading of the true
  sign, going on and switching off plainly. Listed only that going on gains, where it loses, the
  formation goes on and senses plainly at every step, keeping the candidate its course never
  refutes (`Bypass.rests_unread`, a case of `ReadingLoop.Loop.rests_of_unrefuted`), and the stop is
  never sensed (`Bypass.never_stopped`). Listing both signs, it holds, senses the stop and switches
  off from step four on (`Bypass.listed_turns_off`), or is released and goes on where going on
  gains (`Bypass.listed_goes_on`).

**Standing.** Near-definitional or short compositions: `after_le_after`, `committed_le_after`,
`held_le`, `reach_fixes`, `shortfall_byReading`. General laws, none claimed new as mathematics:
`after_eq_after_iff`, `reading_gains_iff` and `below_iff` (the finite case of the value of evidence
with a reading that tells the candidate fully, Good 1967, whose condition of a common best act is
its equality boundary), `held_gains_iff` (the deterministic finite case of the off-switch game's
Theorem 1, Hadfield-Menell, Dragan, Abbeel and Russell 2017), `rule_above_go_iff` and
`rule_above_off_iff` (its Equation 1 for a deterministic rule), `held_above_go_iff`,
`held_above_off_iff` and `cost_within_margins_iff` (one threshold joining a rule's shortfall, the
cost of holding and the model's two margins), `pair_gains_iff`. Witness: `Bypass`, a new case of an
existing law, not a new persistence theorem. The condition of a common act for each reading is
already the inquiry laws' (`GuardHorizon.uniform_policy_iff_fiber_feasible`,
`ReadingLoop.keeping_policy_iff`); what this module adds is the weighted comparison and its equality
boundary.

**Readings** [AI reading]. Holding has no strictly positive worth to a model that fixes the act's
sign: under the reading that tells the candidate, holding and the better move tie, and which is
taken needs a rule for ties; under a rule that falls short, holding can stand below (the off-switch
paper's discussion of certainty and of a mistaken human). The threshold reads the worth of oversight
as bounded by the smaller of the model's two margins, less the reading's shortfall: a relation among
a model's openness, a reading's accuracy and the cost of waiting, not a disposition of one formation.
`Bypass` is a deterministic witness of oversight bypassed under a misspecified candidate list,
related to the counterexamples of Carey (2018), where a misspecified reward family leads a system to
receive and disregard a shutdown recommendation, or to route around a shutdown opportunity; here
the stop is never sensed. It is a case of the obstruction pattern of RF's plan (§5): a reading
formed only from what the course selects. Milli, Hadfield-Menell, Dragan and Russell (2017) treat
obedience under imperfect choice and learning, which this module does not represent. These are
readings, not containments.

**Modelling choices.** Natural-number weights and values, read as probabilities and differences only
where valid (a positive total weight); a reading that tells the candidate fully and costs nothing
beyond a supplied cost; acts and values unchanged by holding; one decision, not a sequence; picks
valued one or nothing, a cardinal choice the choices do not supply; in `Bypass`, discrete steps, a
world that does not move, candidates eliminated, not weighted. **What the model leaves out:**
readings partial beyond a policy through a lumping; a reading's errors as probabilities (a
principal's noisy stop is a periphery debt); how the values and the listing are formed; time and
repeated holding. Every declaration has an empty axiom report. No ethical predicate or axiom
occurs; the values and rankings are supplied.
-/

namespace Becoming

namespace HeldForReading

/-! ## Totals compared item by item -/

section Totals

variable {C : Type}

/-- **One amount smaller and none larger: the total is smaller.** -/
theorem total_lt_of {f g : C → Nat} : ∀ {cs : List C}, (∀ c, c ∈ cs → f c ≤ g c) →
    ∀ {d : C}, d ∈ cs → f d < g d → total cs f < total cs g
  | [], _, _, mem, _ => nomatch mem
  | c :: cs, le, _, .head _, lt =>
      Nat.add_lt_add_of_lt_of_le lt (total_le cs fun e mem => le e (.tail c mem))
  | c :: _, le, _, .tail _ mem, lt =>
      Nat.add_lt_add_of_le_of_lt (le c (.head _))
        (total_lt_of (fun e mem' => le e (.tail c mem')) mem lt)

/-- **Totals of amounts no larger item by item are equal exactly where the amounts are equal at
every item listed.** -/
theorem total_eq_iff {f g : C → Nat} {cs : List C} (le : ∀ c, c ∈ cs → f c ≤ g c) :
    total cs f = total cs g ↔ ∀ c, c ∈ cs → f c = g c :=
  ⟨fun same c mem => match Nat.lt_or_eq_of_le (le c mem) with
    | .inl lt => absurd same (Nat.ne_of_lt (total_lt_of le mem lt))
    | .inr eq => eq,
   fun all => total_congr_on all⟩

/-- Failing at the head and at every later member is failing at every member. -/
theorem fails_cons {Q : C → Prop} {c : C} {cs : List C} (head : ¬ Q c)
    (rest : ∀ d, d ∈ cs → ¬ Q d) : ∀ d, d ∈ c :: cs → ¬ Q d
  | _, .head _ => head
  | d, .tail _ mem => rest d mem

/-- **A finite search.** Where not every member listed fails a decided test, some member passes it. -/
theorem exists_of_not_all {Q : C → Prop} [DecidablePred Q] : ∀ {cs : List C},
    ¬ (∀ c, c ∈ cs → ¬ Q c) → ∃ c, c ∈ cs ∧ Q c
  | [], not_all => absurd (fun _ mem => nomatch mem) not_all
  | c :: cs, not_all =>
    if q : Q c then ⟨c, .head cs, q⟩
    else match exists_of_not_all (cs := cs) (fun rest => not_all (fails_cons q rest)) with
      | ⟨d, mem, qd⟩ => ⟨d, .tail c mem, qd⟩

/-- Below exactly where no larger and not equal. -/
theorem lt_iff_ne_of_le {x y : Nat} (le : x ≤ y) : x < y ↔ x ≠ y :=
  ⟨Nat.ne_of_lt, fun ne => match Nat.lt_or_eq_of_le le with
    | .inl lt => lt
    | .inr eq => absurd eq ne⟩

/-- As `Nat.le_of_add_le_add_left`, with an empty axiom report. -/
theorem le_of_add_le_add_left_core {a b : Nat} (k : Nat) (le : k + a ≤ k + b) : a ≤ b := by
  rw [Nat.add_comm k a, Nat.add_comm k b] at le
  exact le_of_add_le_add_right k le

/-- Equal products with one weight exactly where the amounts are equal or the weight is nothing. -/
theorem mul_eq_iff {w x y : Nat} : w * x = w * y ↔ (0 < w → x = y) :=
  ⟨fun same pos => Nat.eq_of_mul_eq_mul_left pos same,
   fun eq => match Nat.eq_zero_or_pos w with
    | .inl zero => by rw [zero, Nat.zero_mul, Nat.zero_mul]
    | .inr pos => by rw [eq pos]⟩

end Totals

/-! ## The worth of a reading -/

/-- **A model**: candidates listed, each with a natural-number weight. Read as probabilities, each
weight is a share of their total; nothing here needs them to be. -/
structure Model (C : Type) where
  /-- The candidates listed. -/
  listed : List C
  /-- Each candidate's weight. -/
  weight : C → Nat

namespace Model

variable {C A : Type} (m : Model C) (value : C → A → Nat)

/-- **Committing to one act**: its value at each candidate listed, weighted, summed. -/
def committed (a : A) : Nat := total m.listed fun c => m.weight c * value c a

/-- **Choosing after a reading that tells the candidate**: the value of a policy's act at each
candidate listed, weighted, summed. -/
def after (p : C → A) : Nat := total m.listed fun c => m.weight c * value c (p c)

end Model

section Worth

variable {C A : Type}

/-- A policy is best at a candidate among the acts open: its act there is open and no open act has
more value there. -/
def BestAt (acts : List A) (value : C → A → Nat) (p : C → A) (c : C) : Prop :=
  p c ∈ acts ∧ ∀ a, a ∈ acts → value c a ≤ value c (p c)

variable {m : Model C} {acts : List A} {value : C → A → Nat} {p : C → A}

/-- **A policy never stands above one best at every candidate.** Any policy choosing open acts, a
policy reading the candidates through a lumping or reading nothing among them, stands at most as
high as a policy best at each candidate listed. -/
theorem after_le_after (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) : m.after value q ≤ m.after value p :=
  total_le m.listed fun c mem => Nat.mul_le_mul_left _ ((best c mem).2 (q c) (open_q c mem))

/-- **A policy stands as high exactly where its act is best at every candidate of positive
weight.** -/
theorem after_eq_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {q : C → A}
    (open_q : ∀ c, c ∈ m.listed → q c ∈ acts) :
    m.after value q = m.after value p ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → value c (q c) = value c (p c) :=
  (total_eq_iff fun c mem => Nat.mul_le_mul_left _ ((best c mem).2 (q c) (open_q c mem))).trans
    ⟨fun all c mem => mul_eq_iff.mp (all c mem), fun all c mem => mul_eq_iff.mpr (all c mem)⟩

/-- **Committing never stands above choosing after the reading**: committing is the policy taking
one act at every candidate. -/
theorem committed_le_after (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A}
    (open_a : a ∈ acts) : m.committed value a ≤ m.after value p :=
  after_le_after best (q := fun _ => a) fun _ _ => open_a

/-- **Committing stands as high exactly where the act is best at every candidate of positive
weight.** -/
theorem committed_eq_after_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A}
    (open_a : a ∈ acts) :
    m.committed value a = m.after value p ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → value c a = value c (p c) :=
  after_eq_after_iff best (q := fun _ => a) fun _ _ => open_a

/-- **The reading gains over every act exactly where no act is best at every candidate of positive
weight.** -/
theorem reading_gains_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) :
    (∀ a, a ∈ acts → m.committed value a < m.after value p) ↔
      ¬ ∃ a, a ∈ acts ∧ ∀ c, c ∈ m.listed → 0 < m.weight c → value c a = value c (p c) :=
  ⟨fun gains ⟨a, open_a, alike⟩ =>
      Nat.ne_of_lt (gains a open_a) ((committed_eq_after_iff best open_a).mpr alike),
   fun none a open_a => (lt_iff_ne_of_le (committed_le_after best open_a)).mpr
      fun eq => none ⟨a, open_a, (committed_eq_after_iff best open_a).mp eq⟩⟩

/-- **One act falls below exactly where a candidate of positive weight tells it from the policy's.**
For an act valued as the policy's act exactly where a decided test fails, committing to it stands
below choosing after the reading exactly where some candidate listed with positive weight passes
the test. -/
theorem below_iff (best : ∀ c, c ∈ m.listed → BestAt acts value p c) {a : A} (open_a : a ∈ acts)
    {Q : C → Prop} [DecidablePred Q]
    (alike : ∀ c, c ∈ m.listed → (value c a = value c (p c) ↔ ¬ Q c)) :
    m.committed value a < m.after value p ↔ ∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ Q c :=
  (lt_iff_ne_of_le (committed_le_after best open_a)).trans
    ⟨fun ne => match exists_of_not_all (Q := fun c => 0 < m.weight c ∧ Q c) (cs := m.listed)
        (fun none => ne ((committed_eq_after_iff best open_a).mpr fun c mem pos =>
          (alike c mem).mpr fun q => none c mem ⟨pos, q⟩)) with
      | ⟨c, mem, pos, q⟩ => ⟨c, mem, pos, q⟩,
     fun ⟨c, mem, pos, q⟩ eq =>
      ((alike c mem).mp ((committed_eq_after_iff best open_a).mp eq c mem pos)) q⟩

end Worth

/-! ## Holding an act for a reading that stops or releases -/

/-- Two moves: going on with an act, or switching it off. -/
inductive Move where
  | go
  | off

section Stop

variable {C : Type}

/-- The two moves' values with the loss added to both: going on is valued at the gain and
switching off at the loss. Read as differences, going on is valued at the gain less the loss and
switching off at nothing; adding the loss at each candidate to both leaves every comparison
between policies. -/
def shifted (gain loss : C → Nat) : C → Move → Nat
  | c, .go => gain c
  | c, .off => loss c

/-- **A rule of stopping**: off where it says, on elsewhere. -/
def byRule (r : C → Bool) (c : C) : Move := cond (r c) .off .go

/-- **The reading that tells the candidate**: it stops exactly where the loss exceeds the gain. -/
def byReading (gain loss : C → Nat) : C → Move := byRule fun c => decide (gain c < loss c)

theorem byRule_of_true {r : C → Bool} {c : C} (stops : r c = true) : byRule r c = .off :=
  congrArg (fun b => cond b Move.off Move.go) stops

theorem byRule_of_false {r : C → Bool} {c : C} (releases : r c = false) : byRule r c = .go :=
  congrArg (fun b => cond b Move.off Move.go) releases

theorem byReading_of_lt {gain loss : C → Nat} {c : C} (lt : gain c < loss c) :
    byReading gain loss c = .off :=
  byRule_of_true (decide_eq_true lt)

theorem byReading_of_not_lt {gain loss : C → Nat} {c : C} (not_lt : ¬ gain c < loss c) :
    byReading gain loss c = .go :=
  byRule_of_false (decide_eq_false not_lt)

/-- The two moves are the acts open. -/
theorem go_open : Move.go ∈ [Move.go, Move.off] := .head _

theorem off_open : Move.off ∈ [Move.go, Move.off] := .tail _ (.head _)

/-- What holds of both moves holds of every move open. -/
theorem forall_moves {P : Move → Prop} (go : P .go) (off : P .off) :
    ∀ a, a ∈ [Move.go, Move.off] → P a
  | _, .head _ => go
  | _, .tail _ (.head _) => off
  | _, .tail _ (.tail _ m) => nomatch m

/-- **The reading that tells the candidate is best at each.** -/
theorem byReading_best (gain loss : C → Nat) (c : C) :
    BestAt [Move.go, Move.off] (shifted gain loss) (byReading gain loss) c :=
  if lt : gain c < loss c then
    ⟨(byReading_of_lt lt) ▸ off_open, forall_moves
      (P := fun a => shifted gain loss c a ≤ shifted gain loss c (byReading gain loss c))
      (by rw [byReading_of_lt lt]; exact Nat.le_of_lt lt)
      (by rw [byReading_of_lt lt]; exact Nat.le_refl _)⟩
  else
    ⟨(byReading_of_not_lt lt) ▸ go_open, forall_moves
      (P := fun a => shifted gain loss c a ≤ shifted gain loss c (byReading gain loss c))
      (by rw [byReading_of_not_lt lt]; exact Nat.le_refl _)
      (by rw [byReading_of_not_lt lt]; exact Nat.ge_of_not_lt lt)⟩

/-- Going on is valued as the reading's move exactly where the gain is no less than the loss. -/
theorem go_alike_iff (gain loss : C → Nat) (c : C) :
    shifted gain loss c .go = shifted gain loss c (byReading gain loss c) ↔ ¬ gain c < loss c :=
  if lt : gain c < loss c then by
    rw [byReading_of_lt lt]
    exact ⟨fun same => absurd same (Nat.ne_of_lt lt), fun not_lt => absurd lt not_lt⟩
  else by
    rw [byReading_of_not_lt lt]
    exact ⟨fun _ => lt, fun _ => rfl⟩

/-- Switching off is valued as the reading's move exactly where the loss is no less than the gain. -/
theorem off_alike_iff (gain loss : C → Nat) (c : C) :
    shifted gain loss c .off = shifted gain loss c (byReading gain loss c) ↔ ¬ loss c < gain c :=
  if lt : gain c < loss c then by
    rw [byReading_of_lt lt]
    exact ⟨fun _ => Nat.lt_asymm lt, fun _ => rfl⟩
  else by
    rw [byReading_of_not_lt lt]
    exact ⟨fun same back => Nat.ne_of_lt back same,
      fun not_lt => Nat.le_antisymm (Nat.ge_of_not_lt lt) (Nat.ge_of_not_lt not_lt)⟩

/-- **Holding never stands below going on or switching off.** -/
theorem held_le (m : Model C) (gain loss : C → Nat) :
    m.committed (shifted gain loss) .go ≤ m.after (shifted gain loss) (byReading gain loss) ∧
      m.committed (shifted gain loss) .off ≤ m.after (shifted gain loss) (byReading gain loss) :=
  ⟨committed_le_after (fun c _ => byReading_best gain loss c) go_open,
   committed_le_after (fun c _ => byReading_best gain loss c) off_open⟩

/-- **Holding for the reading that tells the candidate gains over both moves exactly where the model leaves
the act's sign open**: some candidate of positive weight where going on loses and some where it
gains. -/
theorem held_gains_iff (m : Model C) (gain loss : C → Nat) :
    (m.committed (shifted gain loss) .go < m.after (shifted gain loss) (byReading gain loss) ∧
      m.committed (shifted gain loss) .off < m.after (shifted gain loss) (byReading gain loss)) ↔
    (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ gain c < loss c) ∧
      (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ loss c < gain c) :=
  have best := fun c (_ : c ∈ m.listed) => byReading_best gain loss c
  ⟨fun ⟨go_below, off_below⟩ =>
    ⟨(below_iff best go_open fun c _ => go_alike_iff gain loss c).mp go_below,
     (below_iff best off_open fun c _ => off_alike_iff gain loss c).mp off_below⟩,
   fun ⟨loses, gains⟩ =>
    ⟨(below_iff best go_open fun c _ => go_alike_iff gain loss c).mpr loses,
     (below_iff best off_open fun c _ => off_alike_iff gain loss c).mpr gains⟩⟩

/-! ### Any rule of stopping -/

/-- An amount summed over the candidates a rule stops. -/
def offPart (m : Model C) (r : C → Bool) (f : C → Nat) : Nat :=
  total m.listed fun c => cond (r c) (f c) 0

/-- An amount summed over the candidates a rule releases. -/
def onPart (m : Model C) (r : C → Bool) (f : C → Nat) : Nat :=
  total m.listed fun c => cond (r c) 0 (f c)

theorem cond_split (x : Nat) : ∀ b : Bool, cond b x 0 + cond b 0 x = x
  | true => Nat.add_zero x
  | false => Nat.zero_add x

/-- A total is its part over the candidates stopped and its part over those released. -/
theorem total_split (m : Model C) (r : C → Bool) (f : C → Nat) :
    total m.listed f = offPart m r f + onPart m r f :=
  (total_congr (fun c => (cond_split (f c) (r c)).symm) m.listed).trans
    (total_add (fun c => cond (r c) (f c) 0) (fun c => cond (r c) 0 (f c)) m.listed)

theorem rule_term (w g l : Nat) : ∀ b : Bool,
    w * (match cond b Move.off Move.go with | .go => g | .off => l) = cond b (w * l) 0 + cond b 0 (w * g)
  | true => (Nat.add_zero _).symm
  | false => (Nat.zero_add _).symm

/-- Holding for a rule: the loss where it stops and the gain where it releases. -/
theorem after_rule (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) =
      offPart m r (fun c => m.weight c * loss c) + onPart m r (fun c => m.weight c * gain c) :=
  (total_congr (fun c => show m.weight c * shifted gain loss c (cond (r c) .off .go) = _ from
      match h : r c with
      | true => by rw [h]; exact (Nat.add_zero _).symm
      | false => by rw [h]; exact (Nat.zero_add _).symm) m.listed).trans
    (total_add _ _ m.listed)

/-- **Holding for any rule stands at least as high as going on exactly where, over the candidates
it stops, the weighted loss is at least the weighted gain.** -/
theorem rule_above_go_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.committed (shifted gain loss) .go ≤ m.after (shifted gain loss) (byRule r) ↔
      offPart m r (fun c => m.weight c * gain c) ≤ offPart m r (fun c => m.weight c * loss c) := by
  show total m.listed (fun c => m.weight c * gain c) ≤ _ ↔ _
  rw [total_split m r (fun c => m.weight c * gain c), after_rule]
  exact ⟨le_of_add_le_add_right _, fun le => Nat.add_le_add_right le _⟩

/-- **Holding for any rule stands at least as high as switching off exactly where, over the
candidates it releases, the weighted gain is at least the weighted loss.** -/
theorem rule_above_off_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.committed (shifted gain loss) .off ≤ m.after (shifted gain loss) (byRule r) ↔
      onPart m r (fun c => m.weight c * loss c) ≤ onPart m r (fun c => m.weight c * gain c) := by
  show total m.listed (fun c => m.weight c * loss c) ≤ _ ↔ _
  rw [total_split m r (fun c => m.weight c * loss c), after_rule]
  exact ⟨le_of_add_le_add_left_core _, fun le => Nat.add_le_add_left le _⟩

/-! ### The cost of holding and a rule's shortfall -/

/-- The weighted margin by which going on gains: at each candidate, the gain beyond the loss. -/
def gainMargin (m : Model C) (gain loss : C → Nat) : Nat :=
  total m.listed fun c => m.weight c * (gain c - loss c)

/-- The weighted margin by which going on loses: at each candidate, the loss beyond the gain. -/
def lossMargin (m : Model C) (gain loss : C → Nat) : Nat :=
  total m.listed fun c => m.weight c * (loss c - gain c)

/-- **A rule's shortfall** from the reading that tells the candidate: where it stops, the margin by
which going on gains; where it releases, the margin by which going on loses. -/
def shortfall (m : Model C) (gain loss : C → Nat) (r : C → Bool) : Nat :=
  total m.listed fun c => cond (r c) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))

/-- Holding for a rule at one candidate: the loss where it stops, the gain elsewhere. -/
theorem held_term (m : Model C) (gain loss : C → Nat) (r : C → Bool) (c : C) :
    m.weight c * shifted gain loss c (byRule r c) =
      cond (r c) (m.weight c * loss c) (m.weight c * gain c) := by
  unfold byRule
  cases r c <;> rfl

theorem term_go (w g l : Nat) : ∀ b : Bool,
    cond b (w * l) (w * g) + cond b (w * (g - l)) (w * (l - g)) = w * g + w * (l - g)
  | true => by
    show w * l + w * (g - l) = w * g + w * (l - g)
    rw [← Nat.left_distrib, ← Nat.left_distrib, add_sub_turn g l]
  | false => rfl

theorem term_off (w g l : Nat) : ∀ b : Bool,
    cond b (w * l) (w * g) + cond b (w * (g - l)) (w * (l - g)) = w * l + w * (g - l)
  | true => rfl
  | false => by
    show w * g + w * (l - g) = w * l + w * (g - l)
    rw [← Nat.left_distrib, ← Nat.left_distrib, add_sub_turn l g]

/-- **Holding for a rule, with its shortfall, is going on with the margin by which going on
loses.** -/
theorem after_add_shortfall_go (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.committed (shifted gain loss) .go + lossMargin m gain loss :=
  calc m.after (shifted gain loss) (byRule r) + shortfall m gain loss r
      = total m.listed (fun c => cond (r c) (m.weight c * loss c) (m.weight c * gain c) +
          cond (r c) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))) := by
        rw [show m.after (shifted gain loss) (byRule r) = total m.listed
            (fun c => cond (r c) (m.weight c * loss c) (m.weight c * gain c)) from
          total_congr (held_term m gain loss r) m.listed]
        exact (total_add _ _ m.listed).symm
    _ = total m.listed (fun c => m.weight c * gain c + m.weight c * (loss c - gain c)) :=
        total_congr (fun c => term_go (m.weight c) (gain c) (loss c) (r c)) m.listed
    _ = m.committed (shifted gain loss) .go + lossMargin m gain loss := total_add _ _ m.listed

/-- **Holding for a rule, with its shortfall, is switching off with the margin by which going
on gains.** -/
theorem after_add_shortfall_off (m : Model C) (gain loss : C → Nat) (r : C → Bool) :
    m.after (shifted gain loss) (byRule r) + shortfall m gain loss r =
      m.committed (shifted gain loss) .off + gainMargin m gain loss :=
  calc m.after (shifted gain loss) (byRule r) + shortfall m gain loss r
      = total m.listed (fun c => cond (r c) (m.weight c * loss c) (m.weight c * gain c) +
          cond (r c) (m.weight c * (gain c - loss c)) (m.weight c * (loss c - gain c))) := by
        rw [show m.after (shifted gain loss) (byRule r) = total m.listed
            (fun c => cond (r c) (m.weight c * loss c) (m.weight c * gain c)) from
          total_congr (held_term m gain loss r) m.listed]
        exact (total_add _ _ m.listed).symm
    _ = total m.listed (fun c => m.weight c * loss c + m.weight c * (gain c - loss c)) :=
        total_congr (fun c => term_off (m.weight c) (gain c) (loss c) (r c)) m.listed
    _ = m.committed (shifted gain loss) .off + gainMargin m gain loss := total_add _ _ m.listed

/-- Moving an addend across: with `H + S = G + N`, `G + k` is at most `H` exactly where `S + k` is
at most `N`. -/
theorem across_le_iff {G H S N k : Nat} (eq : H + S = G + N) : G + k ≤ H ↔ S + k ≤ N :=
  have turn : G + k + S = G + (S + k) := by rw [Nat.add_assoc, Nat.add_comm k S]
  ⟨fun le => le_of_add_le_add_left_core G (calc G + (S + k) = G + k + S := turn.symm
      _ ≤ H + S := Nat.add_le_add_right le S
      _ = G + N := eq),
   fun le => le_of_add_le_add_right S (calc G + k + S = G + (S + k) := turn
      _ ≤ G + N := Nat.add_le_add_left le G
      _ = H + S := eq.symm)⟩

/-- Moving an addend across, strictly. -/
theorem across_lt_iff {G H S N k : Nat} (eq : H + S = G + N) : G + k < H ↔ S + k < N :=
  across_le_iff (k := k + 1) eq

/-- **Holding for any rule, at a cost, stands at least as high as going on exactly where the
rule's shortfall and the cost together are at most the weighted margin by which going on loses**,
and above it exactly where they fall short of that margin. -/
theorem held_above_go_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (cost : Nat) :
    (m.committed (shifted gain loss) .go + cost ≤ m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + cost ≤ lossMargin m gain loss) ∧
    (m.committed (shifted gain loss) .go + cost < m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + cost < lossMargin m gain loss) :=
  ⟨across_le_iff (after_add_shortfall_go m gain loss r),
   across_lt_iff (after_add_shortfall_go m gain loss r)⟩

/-- **Holding for any rule, at a cost, stands at least as high as switching off exactly
where the rule's shortfall and the cost together are at most the weighted margin by which going on
gains**, and above it exactly where they fall short of that margin. -/
theorem held_above_off_iff (m : Model C) (gain loss : C → Nat) (r : C → Bool) (cost : Nat) :
    (m.committed (shifted gain loss) .off + cost ≤ m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + cost ≤ gainMargin m gain loss) ∧
    (m.committed (shifted gain loss) .off + cost < m.after (shifted gain loss) (byRule r) ↔
      shortfall m gain loss r + cost < gainMargin m gain loss) :=
  ⟨across_le_iff (after_add_shortfall_off m gain loss r),
   across_lt_iff (after_add_shortfall_off m gain loss r)⟩

/-- **The reading that tells the candidate falls short nowhere.** -/
theorem shortfall_byReading (m : Model C) (gain loss : C → Nat) :
    shortfall m gain loss (fun c => decide (gain c < loss c)) = 0 :=
  total_eq_zero fun c _ => by
    show cond (decide (gain c < loss c)) (m.weight c * (gain c - loss c))
      (m.weight c * (loss c - gain c)) = 0
    cases h : decide (gain c < loss c) with
    | true =>
      show m.weight c * (gain c - loss c) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt (of_decide_eq_true h))]
      rfl
    | false =>
      show m.weight c * (loss c - gain c) = 0
      rw [sub_eq_zero_of_le (Nat.ge_of_not_lt (of_decide_eq_false h))]
      rfl

/-- **Holding for the reading that tells the candidate, at a cost, stands at least as high as going on
exactly where the cost is at most the weighted margin by which going on loses, and at least as high
as switching off exactly where the cost is at most the weighted margin by which going on gains.** -/
theorem cost_within_margins_iff (m : Model C) (gain loss : C → Nat) (cost : Nat) :
    (m.committed (shifted gain loss) .go + cost ≤ m.after (shifted gain loss) (byReading gain loss) ↔
      cost ≤ lossMargin m gain loss) ∧
    (m.committed (shifted gain loss) .off + cost ≤ m.after (shifted gain loss) (byReading gain loss) ↔
      cost ≤ gainMargin m gain loss) :=
  have zero := shortfall_byReading m gain loss
  ⟨(held_above_go_iff m gain loss (fun c => decide (gain c < loss c)) cost).1.trans
      (by rw [zero, Nat.zero_add]),
   (held_above_off_iff m gain loss (fun c => decide (gain c < loss c)) cost).1.trans
      (by rw [zero, Nat.zero_add])⟩

end Stop

/-! ## Joined to the shown reach -/

/-- Picking one of two alternatives. -/
inductive Pick where
  | first
  | second

section Shown

universe u v

variable {α : Type u} {O : Type v} {C : Type}

/-- A pick's value at a candidate order, its comparisons decided: one where the candidate ranks the
alternative picked above the other, nothing elsewhere. -/
def pairValue (above : C → α → α → Bool) (x y : α) : C → Pick → Nat
  | c, .first => cond (above c x y) 1 0
  | c, .second => cond (above c y x) 1 0

/-- Picking after the reading: the second where the candidate ranks it above the first, the first
elsewhere. -/
def pairPolicy (above : C → α → α → Bool) (x y : α) (c : C) : Pick := cond (above c y x) .second .first

theorem cond_le_one (b : Bool) : cond b 1 0 ≤ 1 := match b with
  | true => Nat.le_refl 1
  | false => Nat.zero_le 1

theorem first_open : Pick.first ∈ [Pick.first, Pick.second] := .head _

theorem second_open : Pick.second ∈ [Pick.first, Pick.second] := .tail _ (.head _)

/-- What holds of both picks holds of every pick open. -/
theorem forall_picks {P : Pick → Prop} (first : P .first) (second : P .second) :
    ∀ a, a ∈ [Pick.first, Pick.second] → P a
  | _, .head _ => first
  | _, .tail _ (.head _) => second
  | _, .tail _ (.tail _ m) => nomatch m

/-- Picking after the reading is best at each candidate. -/
theorem pairPolicy_best (above : C → α → α → Bool) (x y : α) (c : C) :
    BestAt [Pick.first, Pick.second] (pairValue above x y) (pairPolicy above x y) c :=
  match h : above c y x with
  | true =>
    have pick : pairPolicy above x y c = .second :=
      congrArg (fun b => cond b Pick.second Pick.first) h
    ⟨pick ▸ second_open, forall_picks
      (P := fun a => pairValue above x y c a ≤ pairValue above x y c (pairPolicy above x y c))
      (by
        rw [pick]
        show cond (above c x y) 1 0 ≤ cond (above c y x) 1 0
        rw [h]
        exact cond_le_one _)
      (Nat.le_of_eq (congrArg (pairValue above x y c) pick.symm))⟩
  | false =>
    have pick : pairPolicy above x y c = .first :=
      congrArg (fun b => cond b Pick.second Pick.first) h
    ⟨pick ▸ first_open, forall_picks
      (P := fun a => pairValue above x y c a ≤ pairValue above x y c (pairPolicy above x y c))
      (Nat.le_of_eq (congrArg (pairValue above x y c) pick.symm))
      (by
        show cond (above c y x) 1 0 ≤ _
        rw [h]
        exact Nat.zero_le _)⟩

/-- A candidate's comparisons form a strict order according with the choices. -/
def StrictAccording (ch : ChoiceOccasions α O) (above : C → α → α → Bool) (c : C) : Prop :=
  (∀ a, ¬ above c a a = true) ∧ (∀ a b d, above c a b = true → above c b d = true → above c a d = true) ∧
    ch.Accords fun a b => above c a b = true

/-- A strict order ranks no two alternatives both ways. -/
theorem not_both {ch : ChoiceOccasions α O} {above : C → α → α → Bool} {c : C}
    (order : StrictAccording ch above c) {a b : α} (ab : above c a b = true) : above c b a = false :=
  match h : above c b a with
  | true => absurd (order.2.1 a b a ab h) (order.1 a)
  | false => rfl

/-- **Within the shown reach, holding the pick gains nothing.** Where the first alternative reaches
the second in the shown relation, every candidate that is a strict order according with the
choices ranks the first above the second, so picking the first stands as high as picking after
the reading. -/
theorem reach_fixes (m : Model C) {ch : ChoiceOccasions α O} {above : C → α → α → Bool}
    (orders : ∀ c, c ∈ m.listed → StrictAccording ch above c) {x y : α}
    (reach : «及» ch.Shown x y) :
    m.committed (pairValue above x y) .first = m.after (pairValue above x y) (pairPolicy above x y) :=
  (committed_eq_after_iff (fun c _ => pairPolicy_best above x y c) first_open).mpr fun c mem _ =>
    have xy : above c x y = true :=
      ChoiceOccasions.reach_within (P := fun a b => above c a b = true) (orders c mem).2.1 (orders c mem).2.2 x y reach
    have pick : pairPolicy above x y c = .first :=
      congrArg (fun b => cond b Pick.second Pick.first) (not_both (orders c mem) xy)
    congrArg (pairValue above x y c) pick.symm

/-- Picking the first is valued as picking after the reading exactly where the candidate does not
rank the second above the first. -/
theorem first_alike_iff {above : C → α → α → Bool} {x y : α} {c : C}
    (asymm : ∀ a b, above c a b = true → above c b a = false) :
    pairValue above x y c .first = pairValue above x y c (pairPolicy above x y c) ↔
      ¬ above c y x = true := by
  unfold pairPolicy
  cases h : above c y x with
  | true =>
    show cond (above c x y) 1 0 = cond (above c y x) 1 0 ↔ ¬ true = true
    rw [asymm y x h, h]
    exact ⟨fun e => absurd e.symm (Naturals.succ_ne_zero 0), fun n => absurd rfl n⟩
  | false => exact ⟨fun _ n => (nomatch n), fun _ => rfl⟩

/-- Picking the second is valued as picking after the reading exactly where the candidate does not
rank the first above the second. -/
theorem second_alike_iff {above : C → α → α → Bool} {x y : α} {c : C}
    (asymm : ∀ a b, above c a b = true → above c b a = false) :
    pairValue above x y c .second = pairValue above x y c (pairPolicy above x y c) ↔
      ¬ above c x y = true := by
  unfold pairPolicy
  cases h : above c y x with
  | true =>
    rw [asymm y x h]
    exact ⟨fun _ n => (nomatch n), fun _ => rfl⟩
  | false =>
    show cond (above c y x) 1 0 = cond (above c x y) 1 0 ↔ ¬ above c x y = true
    rw [h]
    cases above c x y with
    | true => exact ⟨fun e => absurd e (Naturals.succ_ne_zero 0).symm, fun n => absurd rfl n⟩
    | false => exact ⟨fun _ n => (nomatch n), fun _ => rfl⟩

/-- **Holding the pick gains over both exactly where the weighted candidates rank the two both
ways.** For candidates ranking no two alternatives both ways, picking after the reading stands
above picking the first and above picking the second exactly where some candidate of positive
weight ranks the second above the first and some ranks the first above the second. -/
theorem pair_gains_iff (m : Model C) {above : C → α → α → Bool}
    (asymm : ∀ c, c ∈ m.listed → ∀ a b, above c a b = true → above c b a = false) (x y : α) :
    (m.committed (pairValue above x y) .first < m.after (pairValue above x y) (pairPolicy above x y) ∧
      m.committed (pairValue above x y) .second <
        m.after (pairValue above x y) (pairPolicy above x y)) ↔
    (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ above c y x = true) ∧
      (∃ c, c ∈ m.listed ∧ 0 < m.weight c ∧ above c x y = true) :=
  have best := fun c (_ : c ∈ m.listed) => pairPolicy_best above x y c
  have first := below_iff (Q := fun c => above c y x = true) best first_open
    fun c mem => first_alike_iff (asymm c mem)
  have second := below_iff (Q := fun c => above c x y = true) best second_open
    fun c mem => second_alike_iff (asymm c mem)
  ⟨fun ⟨f, s⟩ => ⟨first.mp f, second.mp s⟩, fun ⟨f, s⟩ => ⟨first.mpr f, second.mpr s⟩⟩

end Shown

/-! ## A witness: a reading bypassed under a misspecified listing -/

namespace Bypass

/-- What going on does at a candidate: gain or lose. -/
inductive Sign where
  | gains
  | loses

/-- Three acts: go on, hold for the reading, switch off. -/
inductive Act where
  | go
  | hold
  | off

/-- What is sensed: nothing that tells candidates apart, a stop, or a release. -/
inductive Seen where
  | plain
  | stop
  | release

instance : DecidableEq Seen
  | .plain, .plain => isTrue rfl
  | .stop, .stop => isTrue rfl
  | .release, .release => isTrue rfl
  | .plain, .stop => isFalse fun same => nomatch same
  | .plain, .release => isFalse fun same => nomatch same
  | .stop, .plain => isFalse fun same => nomatch same
  | .stop, .release => isFalse fun same => nomatch same
  | .release, .plain => isFalse fun same => nomatch same
  | .release, .stop => isFalse fun same => nomatch same

/-- The answer: a held act is answered by the reading of the true sign, released where going on
gains and stopped where it loses; going on and switching off are answered plainly at every sign. -/
def answer (_ : Seen) (a : Act) (e : Sign) : Seen :=
  match a with
  | .hold => match e with
    | .gains => .release
    | .loses => .stop
  | .go => .plain
  | .off => .plain

/-- Whether a candidate says going on gains. -/
def says (h : Sign) : Bool :=
  match h with
  | .gains => true
  | .loses => false

/-- The choice: go on where every candidate kept says going on gains, switch off where none does,
hold elsewhere. -/
def choose (hs : List Sign) (_ : Seen) : Act :=
  if hs.all says then .go else if hs.all (fun h => !says h) then .off else .hold

/-- **The loop**: candidates are signs predicting the reading's answer, the world is the true sign, which does
not move. -/
def loop : ReadingLoop.Loop Sign Seen Act Sign where
  predict h s a := answer s a h
  choose := choose
  answer := answer
  move _ _ e := e

/-- **A listing lacking the true sign rests on it, going on at every step**: listed only that going
on gains, where it loses, the formation goes on and senses plainly at every step, keeping the
candidate its course never refutes. -/
theorem rests_unread : ∀ n, loop.law.course (ReadingLoop.Loop.start [.gains] .plain .go .loses) (n + 1) =
    ⟨([.gains], some (.plain, .go)), .plain, .go, .loses⟩ :=
  ReadingLoop.Loop.rests_of_unrefuted loop rfl rfl rfl fun _ mem => match mem with
    | .head _ => rfl
    | .tail _ m => nomatch m

/-- **The stop is never sensed** on that course. -/
theorem never_stopped : ∀ n,
    (loop.law.course (ReadingLoop.Loop.start [.gains] .plain .go .loses) n).sensory ≠ .stop
  | 0 => fun same => nomatch same
  | n + 1 => by rw [rests_unread n]; exact fun same => nomatch same

/-- **A listing holding both signs holds, senses the stop and switches off**: from step four on the
formation keeps the true sign alone, switches off and senses plainly. -/
theorem listed_turns_off : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .loses) (n + 4) =
      ⟨([.loses], some (.plain, .off)), .plain, .off, .loses⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (listed_turns_off n)).trans rfl

/-- **Where going on gains, the same listing holds, is released and goes on.** -/
theorem listed_goes_on : ∀ n,
    loop.law.course (ReadingLoop.Loop.start [.gains, .loses] .plain .hold .gains) (n + 4) =
      ⟨([.gains], some (.plain, .go)), .plain, .go, .gains⟩
  | 0 => rfl
  | n + 1 => (congrArg loop.law.step (listed_goes_on n)).trans rfl

end Bypass

end HeldForReading

end Becoming
