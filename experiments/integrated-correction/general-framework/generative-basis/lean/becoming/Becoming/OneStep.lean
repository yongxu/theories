import Becoming.Sampling

/-!
# One step: the laws of one step are all the laws of one step

`Becoming.Locality` states laws of one step, each with its condition inside it. This module
asks whether they are all the laws: whether every pattern they allow is shown by some world.
It answers as `tally_iff_counted` answers for counting, by an exact characterization and a
witness world for each pattern the law allows.

* **The pattern of a step.** What the step from `t` shows of a condition is its passage
  (`Passage`, `Flow.passage`): its level before and after, and what the relata taking part
  take from it and give to it. A step shows a pattern on a family (`Flow.Realizes`): the
  passages of its members in order, how many relata take from it (`Flow.takers`), and whether
  something taking part exchanges at all (`Flow.ExchangesAt`). Coming and ceasing to stand,
  the fall of the total and the totals taken and given are read off the passages.
* **The law of every step.** Every step satisfies it (`Flow.Realizes.every`): the relata taking
  from a family are at least one where anything is taken from it and at most what is taken,
  and something exchanges where anything is taken or given. Its lower bound is a law the
  spine had not stated: something taken from a family has a relatum taking it
  (`Flow.sign_uptake_le_takers`).
* **Each condition adds exactly its law.** A pattern is shown by some world across some step
  on some family, listing each relatum taking part once, exactly when it satisfies the law of
  every step (`OneStep.every_iff`); on a family balanced on, exactly when each passage also
  balances (`OneStep.balance_iff`); on a family running down, exactly when moreover the total
  falls by at least the relata taking (`OneStep.runsDown_iff`); on a family closed across the
  step, exactly when moreover nothing exchanges unless something is taken from or given to
  the family (`OneStep.closed_iff`); and with both conditions, with both laws
  (`OneStep.runsDownClosed_iff`). Whatever the count, a family's passages can run down
  exactly when they balance and the total falls by one wherever anything is taken
  (`OneStep.runsDown_passages_iff`). So a property of patterns holds of every step where a
  condition holds exactly when it holds of every pattern satisfying that condition's law
  (`OneStep.laws`).
* **Runs.** Across every step of one family the same holds with one more law: the passages
  follow one another, what stands after each step being what stands before the next
  (`OneStep.Chained`). A run of patterns is shown by some world on one family across every
  step, the condition holding at each, exactly when its passages follow one another and each
  step satisfies the condition's law (`OneStep.run_every_iff`, `OneStep.run_balance_iff`,
  `OneStep.run_runsDown_iff`, `OneStep.run_closed_iff`, `OneStep.run_runsDownClosed_iff`;
  `OneStep.run_laws`).
* **What the stated laws miss.** For a family running down closed, the laws as stated in
  `Becoming.Locality` (balance at each member, the fall by the takers, some standing changing
  and something exchanging exactly when the total falls) with the law that something taken
  has a taker are the whole law (`OneStep.runsDownClosed_iff_stated`); without it they allow
  a condition taken from and given to alike, passed through with nothing taking from it,
  which no world shows (`OneStep.stated_not_realized`). Condition by condition: across a step
  at which a family runs down, something is taken from it exactly when its total falls
  (`Flow.RunsDownOn.taken_iff`). At one condition balanced across a step, its level before,
  what is taken and given, and whether it comes or ceases to stand are shown together exactly
  where nothing is taken beyond what stood with what was given (`Flow.BalancesOn.taken_le`)
  and coming and ceasing are as `Flow.BalancesOn.comesToStand_iff` and
  `Flow.BalancesOn.ceasesToStand_iff` fix them (`OneStep.standing_iff`); the readings alone
  allow more taken than there was (`OneStep.standing_bound_needed`).
* **The witness.** One world serves every pattern (`OneStep.Witness`): a whole relatum takes
  what the units leave and gives all that is given, as many unit relata as the count needs
  take one each, and an outer relatum exchanges beyond the family at the steps where the
  pattern says something exchanges; for a closed family there is nothing beyond. Its flow and
  web are read with one kind of relatum (`World.ofRoles`), so the witness is a world of the
  spine.
* **The givers.** The pattern now also counts the relata giving to the family
  (`Flow.renewers`, `Flow.RealizesGivers`). Every step satisfies the law of the givers
  (`OneStep.Givers`): they are at least one where anything is given and at most what is given
  (`Flow.renewers_le_replenishment`). Its lower bound is again a law the spine had not stated:
  something given to a family has a relatum giving it (`Flow.sign_replenishment_le_renewers`).
  Under no condition, balance and closure the givers add exactly that law
  (`OneStep.every_givers_iff`, `OneStep.balance_givers_iff`, `OneStep.closed_givers_iff`).
  Running down adds one more: dissipated on, every relatum giving to the family takes from it
  (`Flow.DissipatesOn.renewers_le_takers`), so the givers are at most the takers, and that is
  all it adds (`OneStep.runsDown_givers_iff`, `OneStep.runsDownClosed_givers_iff`;
  `OneStep.laws_givers`).
* **Capacity.** With each relatum giving the family at most `cap` across the step
  (`Flow.CapacityAt`, `Flow.Capacity` at one step), what is given is at most `cap` for each
  giver (`Flow.CapacityAt.replenishment_le`), and that is the one law capacity adds under
  each condition (`OneStep.every_capacity_iff`, `OneStep.balance_capacity_iff`,
  `OneStep.runsDown_capacity_iff`, `OneStep.closed_capacity_iff`,
  `OneStep.runsDownClosed_capacity_iff`).
* **Activity.** With only active relata giving, and only active relata taking and only from
  what they draw on (`Flow.ActingAt`, `Flow.TakingAt`: `Flow.Acting` and `Flow.Taking` at one
  step), a pattern is shown under each condition exactly when it is shown under the condition
  alone (`OneStep.every_active_iff` and its four companions): activity adds no law to what one
  step shows of a family.
* **Runs with their givers.** On one family the run with its givers adds to the following of
  passages exactly each step's law with its givers (`OneStep.run_every_givers_iff`,
  `OneStep.run_balance_givers_iff`, `OneStep.run_runsDown_givers_iff`,
  `OneStep.run_closed_givers_iff`, `OneStep.run_runsDownClosed_givers_iff`).
* **Families chosen step by step.** Where the family may change at each step
  (`OneStep.StepRealized`; without the givers `OneStep.StepRunRealized`), no condition, balance
  and closure join one step to the next: the run is shown exactly when each step satisfies its law
  (`OneStep.step_every_iff`, `OneStep.step_balance_iff`, `OneStep.step_closed_iff`,
  `OneStep.stepRun_balance_iff`); what stands after a step need not be listed before the next
  (`OneStep.vanishing_steps`). Running down holds in its family all that stands before and
  after its step, and there continuity up to order replaces following position by position
  (`OneStep.Continues`): at every positive level, as many members stand at it after each step
  as before the next (`OneStep.StepRealized.continues`). With it each step's law is the whole
  law (`OneStep.step_runsDown_iff`, `OneStep.step_runsDownClosed_iff`,
  `OneStep.stepRun_runsDown_iff`, `OneStep.stepRun_runsDownClosed_iff`). Following implies
  continuity (`OneStep.Chained.continues`) and not conversely: two idle conditions listed in
  one order and then the other run down on families chosen step by step and on no single
  family (`OneStep.steps_not_run`).
* **The chain witness.** One construction serves the givers and the runs (`OneStep.Chain`):
  each condition is a chain of positions, born at a step where nothing at the step before
  leads to it and followed by links between consecutive steps (`OneStep.Chain.Links`). Without
  links every step has its conditions of its own (`Chain.unlinked`); with each position leading
  to itself one family serves every step (`Chain.identical`); and links matching what stands
  by level and rank (`Chain.rankNext`, `Chain.rankPrev`) need exactly continuity. What is taken
  and given is laid out unit by unit over the members in order (`Chain.cell`), with as many
  takers and givers as the pattern counts, each giver also taking where running down needs it.
  Its flow and web are again read with one kind of relatum (`World.ofRoles`).

What is not covered: how many relata are active, or take part without taking or giving, is
not part of the pattern; counting them needs a decision of which relata are active, which a
world of the spine does not supply in general. Continuity is derived only for conditions whose
family holds what stands both before and after its step, as running down does; a condition
holding one side only is not treated.
-/

namespace Becoming

variable {α β γ : Type} {F C : Type}

/-! ## Lists and numbers -/

theorem steps_succ_map (g : Nat → α) :
    ∀ T n, (steps (T + 1) n).map g = (steps T n).map fun i => g (i + 1)
  | _, 0 => rfl
  | T, n + 1 => congrArg (g (T + 1) :: ·) (steps_succ_map g (T + 1) n)

/-- A total is positive at most where its members are, counted. -/
theorem sign_total_le (q : α → Nat) :
    ∀ as : List α, sign (total as q) ≤ total as fun a => sign (q a)
  | [] => Nat.le_refl 0
  | a :: as => Nat.le_trans (Flow.sign_add_le (q a) (total as q))
      (Nat.add_le_add_left (sign_total_le q as) _)

theorem pos_of_sign_le {n k : Nat} (le : sign n ≤ k) (pos : 0 < n) : 0 < k :=
  Nat.lt_of_lt_of_le (sign_pos pos) le

/-! ## The passage of a condition and the pattern of a family -/

/-- What one step shows of one condition: its level before and after the step, and what the
relata taking part take from it and give to it across the step. -/
structure Passage where
  before : Nat
  after : Nat
  taken : Nat
  given : Nat

namespace Passage

/-- The passage of a condition at which nothing stands, is taken or is given. -/
def idle : Passage := ⟨0, 0, 0, 0⟩

/-- The passage holding what stands after `p` across a step with nothing taken or given. -/
def held (p : Passage) : Passage := ⟨p.after, p.after, 0, 0⟩

/-- The passage balances: the level after with what was taken is the level before with what
was given. -/
def Balanced (p : Passage) : Prop :=
  p.after + p.taken = p.before + p.given

theorem ext_of {p q : Passage} (before : p.before = q.before) (after : p.after = q.after)
    (taken : p.taken = q.taken) (given : p.given = q.given) : p = q := by
  cases p; cases q
  cases before; cases after; cases taken; cases given; rfl

/-- A balanced passage that rises is given to. -/
theorem Balanced.given_pos {p : Passage} (balanced : p.Balanced) (rises : p.before < p.after) :
    0 < p.given :=
  Nat.pos_of_ne_zero fun nothing => Nat.not_le_of_gt rises
    (Nat.le_trans (Nat.le_add_right _ p.taken)
      (Nat.le_of_eq (balanced.trans (congrArg (p.before + ·) nothing))))

/-- A balanced passage that falls is taken from. -/
theorem Balanced.taken_pos {p : Passage} (balanced : p.Balanced) (falls : p.after < p.before) :
    0 < p.taken :=
  Nat.pos_of_ne_zero fun nothing => Nat.not_le_of_gt falls
    (Nat.le_trans (Nat.le_add_right _ p.given)
      (Nat.le_of_eq (balanced.symm.trans (congrArg (p.after + ·) nothing))))

/-- Balanced passages balance in total. -/
theorem balanced_total {P : List Passage} (balanced : ∀ p, p ∈ P → p.Balanced) :
    total P Passage.after + total P Passage.taken = total P Passage.before + total P Passage.given :=
  (total_add Passage.after Passage.taken P).symm.trans
    ((total_congr_on balanced).trans (total_add Passage.before Passage.given P))

end Passage

namespace Flow

variable (L : Flow F C) (W : Web F C)

/-- What the step from `t` shows of condition `c`. -/
def passage (t : Nat) (c : C) : Passage :=
  ⟨W.level t c, W.level (t + 1) c, L.taken t c, L.given t c⟩

/-- Something taking part in the step from `t` takes from or gives to some condition. -/
def ExchangesAt (t : Nat) : Prop :=
  ∃ f c, f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)

/-- The step from `t` shows the pattern `P`, `k`, `e` on the family `es`: the passages of its
members, in order, are `P`; `k` relata taking part take from it; and something taking part
exchanges exactly where `e`. -/
def Realizes (t : Nat) (es : List C) (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  es.map (L.passage W t) = P ∧ L.takers es t = k ∧ (L.ExchangesAt t ↔ e)

variable {L W}

/-! ## The law of every step -/

/-- Something taken from a family has a relatum taking it: the relata taking from the family
are at least one wherever anything is taken from it. -/
theorem sign_uptake_le_takers (cs : List C) (t : Nat) :
    sign (L.uptake cs t) ≤ L.takers cs t :=
  Nat.le_trans (Nat.le_of_eq (congrArg sign (total_swap (fun c f => L.take t f c) (L.present t) cs)))
    (sign_total_le (fun f => total cs (L.take t f)) (L.present t))

/-- Taking is exchange: something taken from a family is something taking part exchanging. -/
theorem exchangesAt_of_uptake {cs : List C} {t : Nat} (pos : 0 < L.uptake cs t) :
    L.ExchangesAt t :=
  match total_pos cs pos with
  | ⟨c, _, taken⟩ => match total_pos (L.present t) taken with
    | ⟨f, present, takes⟩ => ⟨f, c, present, .inl takes⟩

/-- Giving is exchange. -/
theorem exchangesAt_of_replenishment {cs : List C} {t : Nat} (pos : 0 < L.replenishment cs t) :
    L.ExchangesAt t :=
  match total_pos cs pos with
  | ⟨c, _, given⟩ => match total_pos (L.present t) given with
    | ⟨f, present, gives⟩ => ⟨f, c, present, .inr gives⟩

/-- With balance at a condition, nothing is taken from it across the step beyond what it
stood at with what it was given. -/
theorem BalancesOn.taken_le {cs : List C} {t : Nat} {c : C} (balances : L.BalancesOn W cs t)
    (mem : c ∈ cs) : L.taken t c ≤ W.level t c + L.given t c :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (balances c mem))

/-- Across a step at which a family is closed, something taking part exchanges only where
something is taken from or given to the family. -/
theorem ExchangesAt.closed {es : List C} {t : Nat} (closed : L.ClosedAt es t) :
    L.ExchangesAt t → 0 < L.uptake es t ∨ 0 < L.replenishment es t
  | ⟨f, c, present, exchanges⟩ =>
    match Nat.decLt 0 (L.uptake es t), Nat.decLt 0 (L.replenishment es t) with
    | isTrue up, _ => .inl up
    | _, isTrue given => .inr given
    | isFalse noUp, isFalse noGiven =>
      have outside : ¬ c ∈ es := fun inside => match exchanges with
        | .inl takes => noUp (Nat.lt_of_lt_of_le takes (Nat.le_trans
            (le_total_of_mem (q := fun g => L.take t g c) present)
            (le_total_of_mem (q := L.taken t) inside)))
        | .inr gives => noGiven (Nat.lt_of_lt_of_le gives (Nat.le_trans
            (le_total_of_mem (q := fun g => L.give t g c) present)
            (le_total_of_mem (q := L.given t) inside)))
      match closed f present c outside, exchanges with
      | ⟨noTake, _⟩, .inl takes => absurd (Nat.lt_of_lt_of_le takes (Nat.le_of_eq noTake))
          (Nat.lt_irrefl 0)
      | ⟨_, noGive⟩, .inr gives => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq noGive))
          (Nat.lt_irrefl 0)

/-- Across a step at which a family runs down, something is taken from it exactly when its
total falls: a condition taken from and given to alike, passed through with no change, is
excluded. -/
theorem RunsDownOn.taken_iff {es : List C} {t : Nat} (runs : L.RunsDownOn W es t) :
    (∃ c, c ∈ es ∧ 0 < L.taken t c) ↔ W.stock es (t + 1) < W.stock es t :=
  match runs with
  | ⟨_, _, _, balances, dissipates⟩ =>
    ⟨fun ⟨_, mem, taken⟩ => match total_pos (L.present t) taken with
      | ⟨_, present, takes⟩ =>
        balances.taking_lowers dissipates present (total_pos_of_mem mem takes),
     fun lower => match exists_lt_of_total_lt lower with
      | ⟨c, mem, falls⟩ => ⟨c, mem, balances.fall_taken mem falls⟩⟩

/-! ## What a shown pattern satisfies -/

variable {t : Nat} {es : List C} {P : List Passage} {k : Nat} {e : Prop}

/-- A total over the pattern is the total over the family of what the step shows. -/
theorem Realizes.total_eq (realizes : L.Realizes W t es P k e) (q : Passage → Nat) :
    total P q = total es fun c => q (L.passage W t c) :=
  (congrArg (fun l => total l q) realizes.1).symm.trans (total_map _ q es)

theorem Realizes.uptake (realizes : L.Realizes W t es P k e) :
    total P Passage.taken = L.uptake es t :=
  realizes.total_eq Passage.taken

theorem Realizes.replenishment (realizes : L.Realizes W t es P k e) :
    total P Passage.given = L.replenishment es t :=
  realizes.total_eq Passage.given

theorem Realizes.stock_before (realizes : L.Realizes W t es P k e) :
    total P Passage.before = W.stock es t :=
  realizes.total_eq Passage.before

theorem Realizes.stock_after (realizes : L.Realizes W t es P k e) :
    total P Passage.after = W.stock es (t + 1) :=
  realizes.total_eq Passage.after

/-- Each passage of a shown pattern is the passage of a member. -/
theorem Realizes.member (realizes : L.Realizes W t es P k e) {p : Passage} (mem : p ∈ P) :
    ∃ c, c ∈ es ∧ L.passage W t c = p :=
  preimage_of_mem_map (Eq.subst (motive := fun l => p ∈ l) realizes.1.symm mem)

end Flow

/-! ## The law of each condition, read on a pattern -/

namespace OneStep

/-- The law of every step, read on a pattern: the relata taking from the family are at least
one where anything is taken from it and at most what is taken; something exchanges where
anything is taken from or given to it. -/
def Every (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  sign (total P Passage.taken) ≤ k ∧ k ≤ total P Passage.taken ∧
    (0 < total P Passage.taken ∨ 0 < total P Passage.given → e)

/-- The law of balance on the family: the law of every step, each passage balanced. -/
def Balance (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  Every P k e ∧ ∀ p, p ∈ P → p.Balanced

/-- The law of running down: the law of balance, the family's total falling by at least the
number of relata taking from it. This is read on a pattern of passages; `Flow.RunsDown` of
`Becoming.Locality` says it of a world's flow across a step, and a pattern is shown on a family
running down exactly where it satisfies this law (`Flow.Realizes.runsDown`, `runsDown_iff`). -/
def RunsDown (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  Balance P k e ∧ total P Passage.after + k ≤ total P Passage.before

/-- The law of closure: the law of every step, nothing exchanging unless something is taken
from or given to the family. -/
def Closed (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  Every P k e ∧ (e → 0 < total P Passage.taken ∨ 0 < total P Passage.given)

/-- The law of running down closed. -/
def RunsDownClosed (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  RunsDown P k e ∧ (e → 0 < total P Passage.taken ∨ 0 < total P Passage.given)

/-- With each passage balanced, the family's total falls by at least `k` exactly where what is
given to it, with `k`, is at most what is taken from it. -/
theorem fall_iff_given {P : List Passage} {k : Nat} (balanced : ∀ p, p ∈ P → p.Balanced) :
    total P Passage.after + k ≤ total P Passage.before ↔
      total P Passage.given + k ≤ total P Passage.taken :=
  have sum := Passage.balanced_total balanced
  ⟨fun fall => le_of_add_le_add_right (total P Passage.after) (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_comm _ _).trans ((congrArg (_ + ·) (Nat.add_comm _ _)).trans
        (Nat.add_assoc _ _ _).symm)))
      (Nat.le_trans (Nat.add_le_add_right fall _)
        (Nat.le_of_eq (sum.symm.trans (Nat.add_comm _ _))))),
   fun given => le_of_add_le_add_right (total P Passage.given) (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans (congrArg (_ + ·) (Nat.add_comm _ _))))
      (Nat.le_trans (Nat.add_le_add_left given _) (Nat.le_of_eq sum)))⟩

end OneStep

/-! ## What a shown pattern satisfies, under each condition -/

namespace Flow

variable {L : Flow F C} {W : Web F C} {t : Nat} {es : List C} {P : List Passage} {k : Nat}
  {e : Prop}

/-- Every shown pattern satisfies the law of every step. -/
theorem Realizes.every (realizes : L.Realizes W t es P k e) : OneStep.Every P k e :=
  ⟨Nat.le_trans (Nat.le_of_eq (congrArg sign realizes.uptake))
      (Nat.le_trans (sign_uptake_le_takers es t) (Nat.le_of_eq realizes.2.1)),
   Nat.le_trans (Nat.le_of_eq realizes.2.1.symm)
      (Nat.le_trans (takers_le_uptake (L := L) es t) (Nat.le_of_eq realizes.uptake.symm)),
   fun moved => realizes.2.2.mp (match moved with
     | .inl taken => exchangesAt_of_uptake
         (Nat.lt_of_lt_of_le taken (Nat.le_of_eq realizes.uptake))
     | .inr given => exchangesAt_of_replenishment
         (Nat.lt_of_lt_of_le given (Nat.le_of_eq realizes.replenishment)))⟩

/-- A pattern shown with balance on the family satisfies the law of balance. -/
theorem Realizes.balance (realizes : L.Realizes W t es P k e) (balances : L.BalancesOn W es t) :
    OneStep.Balance P k e :=
  ⟨realizes.every, fun _ mem => match realizes.member mem with
    | ⟨c, inside, same⟩ => Eq.subst (motive := Passage.Balanced) same (balances c inside)⟩

/-- A pattern shown on a family running down satisfies the law of running down. -/
theorem Realizes.runsDown (realizes : L.Realizes W t es P k e) (runs : L.RunsDownOn W es t) :
    OneStep.RunsDown P k e :=
  match runs with
  | ⟨_, _, _, balances, dissipates⟩ =>
    ⟨realizes.balance balances, Nat.le_trans
      (Nat.le_of_eq (congr (congrArg (· + ·) realizes.stock_after) realizes.2.1.symm))
      (Nat.le_trans (balances.runs_down dissipates) (Nat.le_of_eq realizes.stock_before.symm))⟩

/-- A pattern shown on a family closed across the step satisfies the law of closure. -/
theorem Realizes.closed (realizes : L.Realizes W t es P k e) (closed : L.ClosedAt es t) :
    OneStep.Closed P k e :=
  ⟨realizes.every, fun holds => match (realizes.2.2.mpr holds).closed closed with
    | .inl up => .inl (Nat.lt_of_lt_of_le up (Nat.le_of_eq realizes.uptake.symm))
    | .inr given => .inr (Nat.lt_of_lt_of_le given (Nat.le_of_eq realizes.replenishment.symm))⟩

/-- A pattern shown on a family running down closed satisfies the law of running down closed. -/
theorem Realizes.runsDownClosed (realizes : L.Realizes W t es P k e)
    (runs : L.RunsDownOn W es t) (closed : L.ClosedAt es t) : OneStep.RunsDownClosed P k e :=
  ⟨realizes.runsDown runs, (realizes.closed closed).2⟩

/-! ## Read with one kind of relatum -/

variable (L W) in
/-- Read with one kind of relatum, a condition passes across a step as it did. -/
theorem roles_passage (t : Nat) (c : C) : L.roles.passage W.roles t (.inr c) = L.passage W t c :=
  Passage.ext_of rfl rfl (L.roles_taken t c) (L.roles_given t c)

/-- Read with one kind of relatum, something exchanges exactly where it did. -/
theorem roles_exchangesAt : L.roles.ExchangesAt t ↔ L.ExchangesAt t :=
  ⟨fun ⟨x, y, mem, exchanges⟩ => match preimage_of_mem_map mem with
    | ⟨f, present, same⟩ => match x, y, same, exchanges with
      | _, .inr c, rfl, exchanges => ⟨f, c, present, exchanges⟩
      | _, .inl _, rfl, .inl takes => absurd takes (Nat.lt_irrefl 0)
      | _, .inl _, rfl, .inr gives => absurd gives (Nat.lt_irrefl 0),
   fun ⟨f, c, present, exchanges⟩ => ⟨.inl f, .inr c, mem_map_of present, exchanges⟩⟩

/-- Read with one kind of relatum, the step shows the same pattern. -/
theorem Realizes.roles (realizes : L.Realizes W t es P k e) :
    L.roles.Realizes W.roles t (es.map .inr) P k e :=
  ⟨(map_comp_eq Sum.inr _ es).trans ((map_eq_of (roles_passage L W t) es).trans realizes.1),
   (L.roles_takers es t).trans realizes.2.1,
   roles_exchangesAt.trans realizes.2.2⟩

theorem BalancesOn.roles (balances : L.BalancesOn W es t) :
    L.roles.BalancesOn W.roles (es.map .inr) t :=
  fun _ mem => match preimage_of_mem_map mem with
  | ⟨c, inside, same⟩ => Eq.subst (motive := fun x =>
        W.roles.level (t + 1) x + L.roles.taken t x = W.roles.level t x + L.roles.given t x) same
      ((congrArg (W.level (t + 1) c + ·) (L.roles_taken t c)).trans ((balances c inside).trans
        (congrArg (W.level t c + ·) (L.roles_given t c)).symm))

theorem DissipatesOn.roles (dissipates : L.DissipatesOn es t) :
    L.roles.DissipatesOn (es.map .inr) t :=
  fun _ mem => match preimage_of_mem_map mem with
  | ⟨f, present, same⟩ => Eq.subst (motive := fun x =>
        total (es.map .inr) (L.roles.give t x) + sign (total (es.map .inr) (L.roles.take t x)) ≤
          total (es.map .inr) (L.roles.take t x)) same
      (have gives := total_map Sum.inr (L.roles.give t (.inl f)) es
       have takes := total_map Sum.inr (L.roles.take t (.inl f)) es
       Nat.le_trans (Nat.le_of_eq (congr (congrArg (· + ·) gives) (congrArg sign takes)))
         (Nat.le_trans (dissipates f present) (Nat.le_of_eq takes.symm)))

theorem RunsDownOn.roles : L.RunsDownOn W es t → L.roles.RunsDownOn W.roles (es.map .inr) t
  | ⟨distinct, before, after, balances, dissipates⟩ =>
    ⟨distinct_map inr_injective distinct,
     fun
       | .inr c, pos => mem_map_of (before c pos)
       | .inl _, pos => absurd pos (Nat.lt_irrefl 0),
     fun
       | .inr c, pos => mem_map_of (after c pos)
       | .inl _, pos => absurd pos (Nat.lt_irrefl 0),
     balances.roles, dissipates.roles⟩

theorem ClosedAt.roles (closed : L.ClosedAt es t) : L.roles.ClosedAt (es.map .inr) t :=
  fun x mem y outside => match x, y, mem with
  | .inl g, .inr c, mem => closed g (mem_of_map inl_injective mem) c
      fun inside => outside (mem_map_of inside)
  | .inl _, .inl _, _ => ⟨rfl, rfl⟩
  | .inr _, _, _ => ⟨rfl, rfl⟩

end Flow

/-! ## Runs of steps -/

namespace OneStep

/-- The passages of a run follow one another: across each step, what stands after it at each
member is what stands before the next step there. -/
def Chained (P : Nat → List Passage) : Prop :=
  ∀ t, (P t).map Passage.after = (P (t + 1)).map Passage.before

/-- In a run whose passages follow one another, every step shows the same number of members. -/
theorem Chained.lengths {P : Nat → List Passage} (chain : Chained P) :
    ∀ t, (P t).length = (P 0).length
  | 0 => rfl
  | t + 1 => (length_map Passage.before (P (t + 1))).symm.trans
      ((congrArg List.length (chain t)).symm.trans
        ((length_map Passage.after (P t)).trans (Chained.lengths chain t)))

end OneStep

/-! ## The witness: a world showing a given run of patterns -/

namespace OneStep

namespace Witness

/-- The conditions of the witness: the members of the family at their positions, and one
beyond the family for each step `s` and each proof of `o s`. -/
inductive Place (o : Nat → Prop) where
  | member (i : Nat)
  | beyond (s : Nat) (h : o s)

/-- The relata taking part in the witness: the whole, which takes what the units leave and
gives all that is given; units, each taking one from a member; and the outer one, which
exchanges beyond the family only. -/
inductive Part where
  | whole
  | unit (i j : Nat)
  | outer

/-- A unit moved to the next member. -/
def Part.up : Part → Part
  | .whole => .whole
  | .unit i j => .unit (i + 1) j
  | .outer => .outer

/-- The passage at position `i`, idle beyond the list. -/
def pick : List Passage → Nat → Passage := Law.memberAt Passage.idle

/-- The lesser of two numbers. -/
def least : Nat → Nat → Nat
  | 0, _ => 0
  | _ + 1, 0 => 0
  | a + 1, b + 1 => least a b + 1

/-- How many of `u` units each member gives, shared out from the front. -/
def units : List Passage → Nat → Nat → Nat
  | [], _, _ => 0
  | p :: _, u, 0 => least p.taken u
  | p :: P, u, i + 1 => units P (excess u p.taken) i

/-- What the whole takes from each member: what the units leave. -/
def rest : List Passage → Nat → Nat → Nat
  | [], _, _ => 0
  | p :: _, u, 0 => excess p.taken u
  | p :: P, u, i + 1 => rest P (excess u p.taken) i

/-- The units taking part. -/
def unitList : List Passage → Nat → List Part
  | [], _ => []
  | p :: P, u => (steps 0 (least p.taken u)).map (Part.unit 0) ++
      (unitList P (excess u p.taken)).map Part.up

/-- One where two positions coincide, nothing elsewhere. -/
def hit : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ + 1 => 0
  | _ + 1, 0 => 0
  | i + 1, c + 1 => hit i c

/-- What a unit takes from the member at a position. -/
def unitTake : Part → Nat → Nat
  | .whole, _ => 0
  | .unit i _, c => hit i c
  | .outer, _ => 0

/-- The flow of the witness: across the step from `t`, the whole, `u t` units and the outer
one take part; the outer one exchanges with what lies beyond the family at that step. -/
def flow (P : Nat → List Passage) (u : Nat → Nat) (o : Nat → Prop) : Flow Part (Place o) where
  present t := .whole :: (unitList (P t) (u t) ++ [.outer])
  take t f c := match f, c with
    | .whole, .member i => rest (P t) (u t) i
    | .whole, .beyond _ _ => 0
    | .unit i _, .member c => hit i c
    | .unit _ _, .beyond _ _ => 0
    | .outer, .member _ => 0
    | .outer, .beyond s _ => hit s t
  give t f c := match f, c with
    | .whole, .member i => (pick (P t) i).given
    | .whole, .beyond _ _ => 0
    | .unit _ _, .member _ => 0
    | .unit _ _, .beyond _ _ => 0
    | .outer, .member _ => 0
    | .outer, .beyond s _ => hit s t

/-- The web of the witness: each member stands before each step as its passage there says;
nothing else stands. The relata taking part are active and draw on every condition; nothing
depends on anything. -/
def web (P : Nat → List Passage) (o : Nat → Prop) : Web Part (Place o) where
  level t c := match c with
    | .member i => (pick (P t) i).before
    | .beyond _ _ => 0
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The family of the witness: its first `m` members, in order. -/
def family (m : Nat) (o : Nat → Prop) : List (Place o) :=
  (steps 0 m).map .member

/-! ### Positions -/

theorem pick_steps : ∀ P : List Passage, (steps 0 P.length).map (pick P) = P
  | [] => rfl
  | p :: P => show p :: (steps (0 + 1) P.length).map (pick (p :: P)) = p :: P from
      congrArg (p :: ·) ((steps_succ_map (pick (p :: P)) 0 P.length).trans
        ((map_eq_of (g := fun i => pick (p :: P) (i + 1)) (h := pick P) (fun _ => rfl) _).trans
          (pick_steps P)))

theorem total_pick (P : List Passage) (q : Passage → Nat) :
    total (steps 0 P.length) (fun i => q (pick P i)) = total P q :=
  (total_map (pick P) q (steps 0 P.length)).symm.trans
    (congrArg (fun l => total l q) (pick_steps P))

theorem pick_lt {q : Passage → Nat} (idle : q Passage.idle = 0) :
    ∀ (P : List Passage) (i : Nat), 0 < q (pick P i) → i < P.length
  | [], _, pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq idle)) (Nat.lt_irrefl 0)
  | _ :: _, 0, _ => Nat.succ_pos _
  | _ :: P, i + 1, pos => Nat.succ_lt_succ (pick_lt idle P i pos)

theorem pick_mem : ∀ (P : List Passage) (i : Nat), i < P.length → pick P i ∈ P
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | _ :: P, 0, _ => .head P
  | p :: P, i + 1, lt => .tail p (pick_mem P i (Nat.lt_of_succ_lt_succ lt))

theorem pick_beyond : ∀ (P : List Passage) (i : Nat), P.length ≤ i → pick P i = Passage.idle
  | [], _, _ => rfl
  | _ :: _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: P, i + 1, le => pick_beyond P i (Nat.le_of_succ_le_succ le)

/-- The first of a list of numbers, nothing for none. -/
def first : List Nat → Nat
  | [] => 0
  | a :: _ => a

/-- Two lists read alike read alike at each position. -/
theorem pick_map {f g : Passage → Nat} (idle : f Passage.idle = g Passage.idle) :
    ∀ (P Q : List Passage), P.map f = Q.map g → ∀ i, f (pick P i) = g (pick Q i)
  | [], [], _, _ => idle
  | [], _ :: _, same, _ => Nat.noConfusion (congrArg List.length same)
  | _ :: _, [], same, _ => Nat.noConfusion (congrArg List.length same)
  | _ :: _, _ :: _, same, 0 => congrArg first same
  | _ :: P, _ :: Q, same, i + 1 => pick_map idle P Q (congrArg List.tail same) i

/-! ### Sharing out the units -/

theorem least_excess : ∀ a b, least a b + excess a b = a
  | 0, _ => rfl
  | a + 1, 0 => Nat.zero_add (a + 1)
  | a + 1, b + 1 => (Nat.add_right_comm (least a b) 1 (excess a b)).trans
      (congrArg (· + 1) (least_excess a b))

theorem excess_zero : ∀ a, excess a 0 = a
  | 0 => rfl
  | _ + 1 => rfl

theorem least_excess_other : ∀ a b, least a b + excess b a = b
  | 0, b => (Nat.zero_add _).trans (excess_zero b)
  | _ + 1, 0 => rfl
  | a + 1, b + 1 => (Nat.add_right_comm (least a b) 1 (excess b a)).trans
      (congrArg (· + 1) (least_excess_other a b))

theorem rest_units : ∀ (P : List Passage) (u i : Nat), rest P u i + units P u i = (pick P i).taken
  | [], _, _ => rfl
  | p :: _, u, 0 => (Nat.add_comm _ _).trans (least_excess p.taken u)
  | _ :: P, _, i + 1 => rest_units P _ i

theorem total_rest_units (P : List Passage) (u : Nat) :
    total (steps 0 P.length) (rest P u) + total (steps 0 P.length) (units P u) =
      total P Passage.taken :=
  (total_add (rest P u) (units P u) (steps 0 P.length)).symm.trans
    ((total_congr (rest_units P u) (steps 0 P.length)).trans (total_pick P Passage.taken))

theorem total_units : ∀ (P : List Passage) (u : Nat), u ≤ total P Passage.taken →
    total (steps 0 P.length) (units P u) = u
  | [], _, le => (Flow.eq_zero_of_le_zero le).symm
  | p :: P, u, le =>
    (congrArg (least p.taken u + ·) ((total_steps_succ (units (p :: P) u) 0 P.length).trans
      (total_units P (excess u p.taken)
        (excess_le_of_le_add (x := p.taken) (y := total P Passage.taken) le)))).trans
      (least_excess_other p.taken u)

theorem unitList_length : ∀ (P : List Passage) (u : Nat), u ≤ total P Passage.taken →
    (unitList P u).length = u
  | [], _, le => (Flow.eq_zero_of_le_zero le).symm
  | p :: P, u, le =>
    (ListTests.length_append _ _).trans ((congr (congrArg (· + ·)
      ((length_map _ _).trans (steps_length 0 _)))
      ((length_map _ _).trans (unitList_length P _
        (excess_le_of_le_add (x := p.taken) (y := total P Passage.taken) le)))).trans
      (least_excess_other p.taken u))

theorem unitList_units : ∀ (P : List Passage) (u : Nat) (f : Part), f ∈ unitList P u →
    ∃ i j, f = .unit i j ∧ i < P.length
  | [], _, _, mem => nomatch mem
  | _ :: P, _, _, mem => match mem_append_cases mem with
    | .inl first => match preimage_of_mem_map first with
      | ⟨j, _, same⟩ => ⟨0, j, same.symm, Nat.succ_pos _⟩
    | .inr second => match preimage_of_mem_map second with
      | ⟨g, inner, same⟩ => match unitList_units P _ g inner with
        | ⟨i, j, unit, lt⟩ => ⟨i + 1, j, same.symm.trans (congrArg Part.up unit),
            Nat.succ_lt_succ lt⟩

theorem unitTake_up_zero : ∀ g : Part, unitTake g.up 0 = 0
  | .whole => rfl
  | .unit _ _ => rfl
  | .outer => rfl

theorem unitTake_up_succ (c : Nat) : ∀ g : Part, unitTake g.up (c + 1) = unitTake g c
  | .whole => rfl
  | .unit _ _ => rfl
  | .outer => rfl

theorem total_unitTake : ∀ (P : List Passage) (u c : Nat),
    total (unitList P u) (fun f => unitTake f c) = units P u c
  | [], _, _ => rfl
  | p :: P, u, 0 =>
    (total_append (fun f => unitTake f 0) ((unitList P (excess u p.taken)).map Part.up)
      ((steps 0 (least p.taken u)).map (Part.unit 0))).trans
    ((congr (congrArg (· + ·)
      ((total_map (Part.unit 0) (fun f => unitTake f 0) _).trans
        ((total_ones _).trans (steps_length 0 _))))
      ((total_map Part.up (fun f => unitTake f 0) _).trans
        ((total_congr unitTake_up_zero _).trans (total_zero _)))).trans (Nat.add_zero _))
  | p :: P, u, c + 1 =>
    (total_append (fun f => unitTake f (c + 1)) ((unitList P (excess u p.taken)).map Part.up)
      ((steps 0 (least p.taken u)).map (Part.unit 0))).trans
    ((congr (congrArg (· + ·)
      ((total_map (Part.unit 0) (fun f => unitTake f (c + 1)) _).trans (total_zero _)))
      ((total_map Part.up (fun f => unitTake f (c + 1)) _).trans
        ((total_congr (unitTake_up_succ c) _).trans (total_unitTake P _ c)))).trans
      (Nat.zero_add _))

theorem hit_self : ∀ i, hit i i = 1
  | 0 => rfl
  | i + 1 => hit_self i

theorem hit_pos : ∀ s t, 0 < hit s t → s = t
  | 0, 0, _ => rfl
  | 0, _ + 1, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, 0, pos => absurd pos (Nat.lt_irrefl 0)
  | s + 1, t + 1, pos => congrArg Nat.succ (hit_pos s t pos)

/-! ### Each relatum taking part listed once -/

theorem unit_injective (i : Nat) : ∀ j j' : Nat, Part.unit i j = Part.unit i j' → j = j'
  | _, _, rfl => rfl

/-- The member a unit takes from. -/
def Part.index : Part → Nat
  | .whole => 0
  | .unit i _ => i
  | .outer => 0

/-- Which of a member's units it is. -/
def Part.place : Part → Nat
  | .whole => 0
  | .unit _ j => j
  | .outer => 0

theorem up_unit_injective {i j i' j' : Nat} (same : Part.unit (i + 1) j = Part.unit (i' + 1) j') :
    Part.unit i j = Part.unit i' j' :=
  congr (congrArg Part.unit (Nat.succ.inj (congrArg Part.index same))) (congrArg Part.place same)

theorem distinct_unitList : ∀ (P : List Passage) (u : Nat), Distinct (unitList P u)
  | [], _ => trivial
  | _ :: P, _ => distinct_append
      (distinct_map (unit_injective 0) (steps_distinct 0 _))
      (distinct_map_on (fun a b ma mb same =>
          match unitList_units P _ a ma, unitList_units P _ b mb with
          | ⟨_, _, ha, _⟩, ⟨_, _, hb, _⟩ => ha.trans ((up_unit_injective
              ((congrArg Part.up ha).symm.trans (same.trans (congrArg Part.up hb)))).trans hb.symm))
        (distinct_unitList P _))
      (fun _ first second => match preimage_of_mem_map first, preimage_of_mem_map second with
        | ⟨_, _, isFirst⟩, ⟨g, inner, isSecond⟩ => match unitList_units P _ g inner with
          | ⟨_, _, unit, _⟩ => Nat.noConfusion (congrArg Part.index
              ((congrArg Part.up unit).symm.trans (isSecond.trans isFirst.symm))))

theorem distinct_present (P : Nat → List Passage) (u : Nat → Nat) (o : Nat → Prop) (t : Nat) :
    Distinct ((flow P u o).present t) :=
  show ¬ Part.whole ∈ unitList (P t) (u t) ++ [Part.outer] ∧
      Distinct (unitList (P t) (u t) ++ [Part.outer]) from
  ⟨fun mem => match mem_append_cases mem with
    | .inl inside => match unitList_units (P t) (u t) _ inside with
      | ⟨_, _, same, _⟩ => nomatch same
    | .inr last => match mem_cons_cases last with
      | .inl same => nomatch same
      | .inr nothing => (nomatch nothing),
   distinct_append (distinct_unitList (P t) (u t))
     (show ¬ Part.outer ∈ ([] : List Part) ∧ Distinct ([] : List Part) from
       ⟨fun nothing => (nomatch nothing), trivial⟩)
     fun f inside last => match unitList_units (P t) (u t) f inside, mem_cons_cases last with
      | ⟨_, _, same, _⟩, .inl outer => nomatch same.symm.trans outer
      | _, .inr nothing => nomatch nothing⟩

theorem member_injective {o : Nat → Prop} :
    ∀ i j : Nat, (Place.member i : Place o) = .member j → i = j
  | _, _, rfl => rfl

theorem distinct_family (m : Nat) (o : Nat → Prop) : Distinct (family m o) :=
  distinct_map member_injective (steps_distinct 0 _)

theorem total_family (m : Nat) {o : Nat → Prop} (q : Place o → Nat) :
    total (family m o) q = total (steps 0 m) fun i => q (.member i) :=
  total_map Place.member q (steps 0 m)

theorem member_mem {m i : Nat} {o : Nat → Prop} (lt : i < m) :
    (Place.member i : Place o) ∈ family m o :=
  mem_map_of (steps_of_within (Nat.zero_le i)
    (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add _).symm)))

theorem of_mem_family {m : Nat} {o : Nat → Prop} {c : Place o} (mem : c ∈ family m o) :
    ∃ i, i < m ∧ c = .member i :=
  match preimage_of_mem_map mem with
  | ⟨i, inside, same⟩ =>
    ⟨i, Nat.lt_of_lt_of_le (steps_within inside) (Nat.le_of_eq (Nat.zero_add _)), same.symm⟩

/-- The whole takes part where `k` relata take: with the units it makes `k`. -/
theorem whole_count {M X : Nat} : ∀ {k : Nat}, sign X ≤ k → k ≤ X → M + k.pred = X →
    sign M + k.pred = k
  | 0, sgn, _, sum => Flow.eq_zero_of_le_zero (Nat.le_trans (Nat.le_of_eq (congrArg sign sum)) sgn)
  | k + 1, _, kX, sum =>
    have pos : 0 < M := Nat.pos_of_ne_zero fun zero => Nat.not_succ_le_self k
      (Nat.le_trans kX (Nat.le_of_eq (sum.symm.trans ((congrArg (· + k) zero).trans
        (Nat.zero_add k)))))
    (congrArg (· + k) (sign_eq_one pos)).trans (Nat.add_comm 1 k)

theorem whole_total (Q : List Passage) {k : Nat} (kX : k ≤ total Q Passage.taken) :
    total (steps 0 Q.length) (rest Q k.pred) + k.pred = total Q Passage.taken :=
  (congrArg (_ + ·) (total_units Q k.pred (Nat.le_trans (Nat.pred_le k) kX)).symm).trans
    (total_rest_units Q k.pred)

/-- Where what is given, with `k`, is at most what is taken, the whole gives less than it
takes, by one where it takes. -/
theorem whole_bound {X Y M : Nat} : ∀ {k : Nat}, sign X ≤ k → Y + k ≤ X → M + k.pred = X →
    Y + sign M ≤ M
  | 0, sgn, given, _ =>
    have untaken : X = 0 := eq_zero_of_not_pos fun pos =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (sign_pos pos) sgn)
    Nat.le_trans (Nat.add_le_add (Nat.le_trans given (Nat.le_of_eq untaken))
        (sign_le _)) (Nat.le_of_eq (Nat.zero_add _))
  | k + 1, _, given, whole =>
    Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _)
      (le_of_add_le_add_right k (Nat.le_trans
        (Nat.le_of_eq (Nat.add_right_comm _ 1 k)) (Nat.le_trans given
          (Nat.le_of_eq whole.symm))))

/-! ### What the witness shows across a step -/

variable (P : Nat → List Passage) (u : Nat → Nat) (o : Nat → Prop) (t : Nat)

theorem take_units (i : Nat) :
    total (unitList (P t) (u t)) (fun f => (flow P u o).take t f (.member i)) =
      units (P t) (u t) i :=
  (total_congr_on fun f mem => match unitList_units (P t) (u t) f mem with
    | ⟨_, _, unit, _⟩ => Eq.subst (motive := fun g =>
        (flow P u o).take t g (.member i) = unitTake g i) unit.symm rfl).trans
  (total_unitTake (P t) (u t) i)

theorem give_units (i : Nat) :
    total (unitList (P t) (u t)) (fun f => (flow P u o).give t f (.member i)) = 0 :=
  (total_congr_on (g := fun _ => 0) fun f mem => match unitList_units (P t) (u t) f mem with
    | ⟨_, _, unit, _⟩ => Eq.subst (motive := fun g =>
        (flow P u o).give t g (.member i) = 0) unit.symm rfl).trans (total_zero _)

theorem taken_member (i : Nat) : (flow P u o).taken t (.member i) = (pick (P t) i).taken :=
  (congrArg (rest (P t) (u t) i + ·) ((total_append _ [Part.outer] (unitList (P t) (u t))).trans
    ((congrArg (· + 0) (take_units P u o t i)).trans (Nat.add_zero _)))).trans
    (rest_units (P t) (u t) i)

theorem given_member (i : Nat) : (flow P u o).given t (.member i) = (pick (P t) i).given :=
  (congrArg ((pick (P t) i).given + ·) ((total_append _ [Part.outer] (unitList (P t) (u t))).trans
    (congrArg (· + 0) (give_units P u o t i)))).trans (Nat.add_zero _)

/-- What stands after the step at a member is what its passage says, where the passages follow
one another. -/
theorem level_after (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    (i : Nat) : (web P o).level (t + 1) (.member i) = (pick (P t) i).after :=
  (pick_map (f := Passage.after) (g := Passage.before) rfl (P t) (P (t + 1)) chain i).symm

theorem passage_member (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    (i : Nat) : (flow P u o).passage (web P o) t (.member i) = pick (P t) i :=
  Passage.ext_of rfl (level_after P o t chain i) (taken_member P u o t i) (given_member P u o t i)

/-- The witness shows the passages of the pattern, in order. -/
theorem passages (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before) :
    (family (P t).length o).map ((flow P u o).passage (web P o) t) = P t :=
  (map_comp_eq Place.member _ (steps 0 (P t).length)).trans
    ((map_eq_of (passage_member P u o t chain) (steps 0 (P t).length)).trans (pick_steps (P t)))

theorem uptake_family :
    (flow P u o).uptake (family (P t).length o) t = total (P t) Passage.taken :=
  (total_family _ _).trans ((total_congr (taken_member P u o t) _).trans
    (total_pick (P t) Passage.taken))

theorem replenishment_family :
    (flow P u o).replenishment (family (P t).length o) t = total (P t) Passage.given :=
  (total_family _ _).trans ((total_congr (given_member P u o t) _).trans
    (total_pick (P t) Passage.given))

/-- How many take from the family: the whole, where it takes, and the units. -/
theorem takers_eq (le : u t ≤ total (P t) Passage.taken) :
    (flow P u o).takers (family (P t).length o) t =
      sign (total (steps 0 (P t).length) (rest (P t) (u t))) + u t :=
  have whole : total (family (P t).length o) ((flow P u o).take t .whole) =
      total (steps 0 (P t).length) (rest (P t) (u t)) :=
    total_family _ _
  have unitOne : ∀ f, f ∈ unitList (P t) (u t) →
      sign (total (family (P t).length o) ((flow P u o).take t f)) = 1 :=
    fun f mem => match unitList_units (P t) (u t) f mem with
    | ⟨i, j, unit, lt⟩ => Eq.subst (motive := fun g =>
          sign (total (family (P t).length o) ((flow P u o).take t g)) = 1) unit.symm
        (sign_eq_one (Nat.lt_of_lt_of_le
          (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (hit_self i).symm))
          (le_total_of_mem (q := (flow P u o).take t (.unit i j)) (member_mem lt))))
  have unitsCount : total (unitList (P t) (u t))
      (fun f => sign (total (family (P t).length o) ((flow P u o).take t f))) = u t :=
    (total_congr_on (g := fun _ => 1) unitOne).trans
      ((total_ones _).trans (unitList_length (P t) (u t) le))
  have outer : total (family (P t).length o) ((flow P u o).take t .outer) = 0 :=
    (total_family _ _).trans (total_zero _)
  show sign (total (family (P t).length o) ((flow P u o).take t .whole)) +
      total (unitList (P t) (u t) ++ [Part.outer])
        (fun f => sign (total (family (P t).length o) ((flow P u o).take t f))) = _ from
    congr (congrArg (· + ·) (congrArg sign whole))
      ((total_append _ [Part.outer] (unitList (P t) (u t))).trans
        ((congr (congrArg (· + ·) unitsCount) (congrArg (fun n => sign n + 0) outer)).trans
          (Nat.add_zero (u t))))

theorem takers_count {k : Nat → Nat} (sgn : sign (total (P t) Passage.taken) ≤ k t)
    (kX : k t ≤ total (P t) Passage.taken) :
    (flow P (fun s => (k s).pred) o).takers (family (P t).length o) t = k t :=
  (takers_eq P (fun s => (k s).pred) o t (Nat.le_trans (Nat.pred_le (k t)) kX)).trans
    (whole_count sgn kX (whole_total (P t) kX))

theorem outer_mem : Part.outer ∈ (flow P u o).present t :=
  .tail _ (mem_append_of_right (unitList (P t) (u t)) (.head []))

/-- What exchanges beyond the family exchanges at the step it belongs to. -/
theorem beyond_moves : ∀ (f : Part) {s : Nat} {h : o s},
    0 < (flow P u o).take t f (.beyond s h) ∨ 0 < (flow P u o).give t f (.beyond s h) → s = t
  | .whole, _, _, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .whole, _, _, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .unit _ _, _, _, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .unit _ _, _, _, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .outer, s, _, .inl pos => hit_pos s t pos
  | .outer, s, _, .inr pos => hit_pos s t pos

/-- Something exchanges in the witness across the step exactly where something is taken from
or given to the family, or `o` holds at the step. -/
theorem exchangesAt_iff :
    (flow P u o).ExchangesAt t ↔
      0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t :=
  ⟨fun ⟨f, c, present, exchanges⟩ => match c, exchanges with
    | .beyond _ h, moves => .inr (.inr (Eq.subst (motive := o) (beyond_moves P u o t f moves) h))
    | .member i, .inl takes =>
      have taken : 0 < (pick (P t) i).taken := Nat.lt_of_lt_of_le takes
        (Nat.le_trans (le_total_of_mem (q := fun g => (flow P u o).take t g (.member i)) present)
          (Nat.le_of_eq (taken_member P u o t i)))
      .inl (Nat.lt_of_lt_of_le taken
        (le_total_of_mem (pick_mem (P t) i (pick_lt (q := Passage.taken) rfl (P t) i taken))))
    | .member i, .inr gives =>
      have given : 0 < (pick (P t) i).given := Nat.lt_of_lt_of_le gives
        (Nat.le_trans (le_total_of_mem (q := fun g => (flow P u o).give t g (.member i)) present)
          (Nat.le_of_eq (given_member P u o t i)))
      .inr (.inl (Nat.lt_of_lt_of_le given
        (le_total_of_mem (pick_mem (P t) i (pick_lt (q := Passage.given) rfl (P t) i given))))),
   fun moved => match moved with
    | .inl taken => Flow.exchangesAt_of_uptake (cs := family (P t).length o)
        (Nat.lt_of_lt_of_le taken (Nat.le_of_eq (uptake_family P u o t).symm))
    | .inr (.inl given) => Flow.exchangesAt_of_replenishment (cs := family (P t).length o)
        (Nat.lt_of_lt_of_le given (Nat.le_of_eq (replenishment_family P u o t).symm))
    | .inr (.inr h) => ⟨.outer, .beyond t h, outer_mem P u o t,
        .inl (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (hit_self t).symm))⟩⟩

/-! ### The conditions in the witness -/

/-- With each passage balanced, the witness balances on the family across the step. -/
theorem balancesOn (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    (balanced : ∀ p, p ∈ P t → p.Balanced) :
    (flow P u o).BalancesOn (web P o) (family (P t).length o) t :=
  fun _ mem => match of_mem_family mem with
  | ⟨i, lt, same⟩ => Eq.subst (motive := fun c =>
        (web P o).level (t + 1) c + (flow P u o).taken t c =
          (web P o).level t c + (flow P u o).given t c) same.symm
      ((congr (congrArg (· + ·) (level_after P o t chain i)) (taken_member P u o t i)).trans
        ((balanced (pick (P t) i) (pick_mem (P t) i lt)).trans
          (congrArg ((pick (P t) i).before + ·) (given_member P u o t i)).symm))

/-- The family holds whatever stands before the step. -/
theorem stands_before {c : Place o} (pos : 0 < (web P o).level t c) :
    c ∈ family (P t).length o :=
  match c, pos with
  | .member i, pos => member_mem (pick_lt (q := Passage.before) rfl (P t) i pos)
  | .beyond _ _, pos => absurd pos (Nat.lt_irrefl 0)

/-- And whatever stands after it. -/
theorem stands_after (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    {c : Place o} (pos : 0 < (web P o).level (t + 1) c) : c ∈ family (P t).length o :=
  match c, pos with
  | .member i, pos => member_mem (pick_lt (q := Passage.after) rfl (P t) i
      (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (level_after P o t chain i))))
  | .beyond _ _, pos => absurd pos (Nat.lt_irrefl 0)

/-- Where what is given to the family, with `k`, is at most what is taken from it, the witness
dissipates on the family across the step. -/
theorem dissipatesOn {k : Nat → Nat} (sgn : sign (total (P t) Passage.taken) ≤ k t)
    (given : total (P t) Passage.given + k t ≤ total (P t) Passage.taken) :
    (flow P (fun s => (k s).pred) o).DissipatesOn (family (P t).length o) t := fun f _ =>
  match f with
  | .whole =>
    have kX : k t ≤ total (P t) Passage.taken := Nat.le_trans (Nat.le_add_left _ _) given
    have gives : total (family (P t).length o) ((flow P (fun s => (k s).pred) o).give t .whole) =
        total (P t) Passage.given :=
      (total_family _ _).trans (total_pick (P t) Passage.given)
    have takes : total (family (P t).length o) ((flow P (fun s => (k s).pred) o).take t .whole) =
        total (steps 0 (P t).length) (rest (P t) (k t).pred) :=
      total_family _ _
    Nat.le_trans (Nat.le_of_eq (congr (congrArg (· + ·) gives) (congrArg sign takes)))
      (Nat.le_trans (whole_bound sgn given (whole_total (P t) kX)) (Nat.le_of_eq takes.symm))
  | .unit i j =>
    have gives : total (family (P t).length o)
        ((flow P (fun s => (k s).pred) o).give t (.unit i j)) = 0 :=
      (total_congr (q := fun _ => 0) (fun c => match c with
        | .member _ => rfl
        | .beyond _ _ => rfl) _).trans (total_zero _)
    Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) gives).trans (Nat.zero_add _))) (sign_le _)
  | .outer =>
    have takes : total (family (P t).length o)
        ((flow P (fun s => (k s).pred) o).take t .outer) = 0 :=
      (total_family _ _).trans (total_zero _)
    have gives : total (family (P t).length o)
        ((flow P (fun s => (k s).pred) o).give t .outer) = 0 :=
      (total_family _ _).trans (total_zero _)
    Nat.le_of_eq ((congr (congrArg (· + ·) gives) (congrArg sign takes)).trans takes.symm)

/-- With each passage balanced and what is given, with `k`, at most what is taken, the family
of the witness runs down across the step. -/
theorem runsDownOn {k : Nat → Nat}
    (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    (balanced : ∀ p, p ∈ P t → p.Balanced) (sgn : sign (total (P t) Passage.taken) ≤ k t)
    (given : total (P t) Passage.given + k t ≤ total (P t) Passage.taken) :
    (flow P (fun s => (k s).pred) o).RunsDownOn (web P o) (family (P t).length o) t :=
  ⟨distinct_family _ o, fun _ pos => stands_before P o t pos,
   fun _ pos => stands_after P o t chain pos,
   balancesOn P _ o t chain balanced, dissipatesOn P o t sgn given⟩

/-- Where `o` fails at the step, the witness is closed on the family across it. -/
theorem closedAt (alone : ¬ o t) : (flow P u o).ClosedAt (family (P t).length o) t :=
  fun f present c outside => match c, outside with
  | .beyond _ h, _ =>
    ⟨eq_zero_of_not_pos fun pos =>
        alone (Eq.subst (motive := o) (beyond_moves P u o t f (.inl pos)) h),
     eq_zero_of_not_pos fun pos =>
        alone (Eq.subst (motive := o) (beyond_moves P u o t f (.inr pos)) h)⟩
  | .member i, outside =>
    have idle : pick (P t) i = Passage.idle :=
      pick_beyond (P t) i (Nat.ge_of_not_lt fun lt => outside (member_mem lt))
    have nothingTaken : (flow P u o).taken t (.member i) = 0 :=
      (taken_member P u o t i).trans (congrArg Passage.taken idle)
    have nothingGiven : (flow P u o).given t (.member i) = 0 :=
      (given_member P u o t i).trans (congrArg Passage.given idle)
    ⟨Flow.eq_zero_of_le_zero (Nat.le_trans
        (le_total_of_mem (q := fun g => (flow P u o).take t g (.member i)) present)
        (Nat.le_of_eq nothingTaken)),
     Flow.eq_zero_of_le_zero (Nat.le_trans
        (le_total_of_mem (q := fun g => (flow P u o).give t g (.member i)) present)
        (Nat.le_of_eq nothingGiven))⟩

/-- The world of the witness: its flow and web read with one kind of relatum. -/
def world (P : Nat → List Passage) (k : Nat → Nat) (o : Nat → Prop) : World :=
  World.ofRoles (flow P (fun t => (k t).pred) o) (web P o)

/-- Across each step whose passages lead to the next, the witness shows the pattern, listing
each relatum taking part once, with something exchanging exactly where something is taken
from or given to the family, or `o` holds at the step. -/
theorem shows {P : Nat → List Passage} {k : Nat → Nat} (t : Nat)
    (chain : (P t).map Passage.after = (P (t + 1)).map Passage.before)
    (sgn : sign (total (P t) Passage.taken) ≤ k t) (kX : k t ≤ total (P t) Passage.taken)
    (o : Nat → Prop) :
    Distinct ((world P k o).flow.present t) ∧
      (world P k o).flow.Realizes (world P k o).web t ((family (P t).length o).map .inr) (P t)
        (k t) (0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t) :=
  ⟨(flow P (fun s => (k s).pred) o).roles_distinct (distinct_present P _ o t),
   Flow.Realizes.roles ⟨passages P _ o t chain, takers_count P o t sgn kX,
     exchangesAt_iff P _ o t⟩⟩

/-- A run whose first step shows `P` and whose later steps hold what stands after it, with
nothing exchanged. -/
def once (P : List Passage) : Nat → List Passage
  | 0 => P
  | _ + 1 => P.map Passage.held

theorem once_chain (P : List Passage) :
    (once P 0).map Passage.after = (once P (0 + 1)).map Passage.before :=
  (map_comp_eq Passage.held Passage.before P).symm

end Witness

/-! ## Each law is the whole law of one step under its condition -/

/-- Some world shows the pattern across some step on some family where the condition holds,
listing each relatum taking part once. -/
def Realized (cond : (w : World) → Nat → List w.Relatum → Prop) (P : List Passage) (k : Nat)
    (e : Prop) : Prop :=
  ∃ (w : World) (t : Nat) (es : List w.Relatum), cond w t es ∧ Distinct (w.flow.present t) ∧
    w.flow.Realizes w.web t es P k e

theorem exchange_open {X Y : Nat} {e : Prop} (law : 0 < X ∨ 0 < Y → e) :
    (0 < X ∨ 0 < Y ∨ e) ↔ e :=
  ⟨fun moved => match moved with
    | .inl taken => law (.inl taken)
    | .inr (.inl given) => law (.inr given)
    | .inr (.inr holds) => holds,
   fun holds => .inr (.inr holds)⟩

theorem exchange_closed {X Y : Nat} {e : Prop} (law : e ↔ 0 < X ∨ 0 < Y) :
    (0 < X ∨ 0 < Y ∨ False) ↔ e :=
  ⟨fun moved => match moved with
    | .inl taken => law.mpr (.inl taken)
    | .inr (.inl given) => law.mpr (.inr given)
    | .inr (.inr nothing) => nothing.elim,
   fun holds => match law.mp holds with
    | .inl taken => .inl taken
    | .inr given => .inr (.inl given)⟩

/-- The witness shows a pattern satisfying the law of every step across its first step, on a
family where the condition holds. -/
theorem Witness.realizedOnce {P : List Passage} {k : Nat} {e : Prop} (every : Every P k e)
    (o : Prop) (exchange : (0 < total P Passage.taken ∨ 0 < total P Passage.given ∨ o) ↔ e)
    {cond : (w : World) → Nat → List w.Relatum → Prop}
    (holds : cond (world (once P) (fun _ => k) (fun _ => o)) 0
      ((family P.length (fun _ => o)).map .inr)) :
    Realized cond P k e :=
  match shows (P := once P) (k := fun _ => k) 0 (once_chain P) every.1 every.2.1 (fun _ => o) with
  | ⟨distinct, realizes⟩ =>
    ⟨_, 0, _, holds, distinct, realizes.1, realizes.2.1, realizes.2.2.trans exchange⟩

/-- **The law of every step is all the law of one step.** A pattern is shown by some world
across some step on some family exactly when it satisfies the law of every step. -/
theorem every_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun _ _ _ => True) P k e ↔ Every P k e :=
  ⟨fun ⟨_, _, _, _, _, realizes⟩ => realizes.every,
   fun every => Witness.realizedOnce every e (exchange_open every.2.2)
     (cond := fun _ _ _ => True) trivial⟩

/-- **Balance adds exactly balance at each member.** A pattern is shown on a family balanced
on across the step exactly when it satisfies the law of balance. -/
theorem balance_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun w t es => w.flow.BalancesOn w.web es t) P k e ↔ Balance P k e :=
  ⟨fun ⟨_, _, _, balances, _, realizes⟩ => realizes.balance balances,
   fun ⟨every, balanced⟩ => Witness.realizedOnce every e (exchange_open every.2.2)
     (cond := fun w t es => w.flow.BalancesOn w.web es t)
     (Witness.balancesOn (Witness.once P) _ (fun _ => e) 0 (Witness.once_chain P)
       balanced).roles⟩

/-- **Running down adds exactly the fall by the takers.** A pattern is shown on a family running
down across the step exactly when it satisfies the law of running down. -/
theorem runsDown_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun w t es => w.flow.RunsDownOn w.web es t) P k e ↔ RunsDown P k e :=
  ⟨fun ⟨_, _, _, runs, _, realizes⟩ => realizes.runsDown runs,
   fun ⟨⟨every, balanced⟩, fall⟩ => Witness.realizedOnce every e (exchange_open every.2.2)
     (cond := fun w t es => w.flow.RunsDownOn w.web es t)
     (Witness.runsDownOn (Witness.once P) (fun _ => e) 0 (k := fun _ => k)
       (Witness.once_chain P) balanced every.1 ((fall_iff_given balanced).mp fall)).roles⟩

/-- **Closure adds exactly that exchange is with the family.** A pattern is shown on a family
closed across the step exactly when it satisfies the law of closure. -/
theorem closed_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun w t es => w.flow.ClosedAt es t) P k e ↔ Closed P k e :=
  ⟨fun ⟨_, _, _, closed, _, realizes⟩ => realizes.closed closed,
   fun ⟨every, inward⟩ => Witness.realizedOnce every False
     (exchange_closed ⟨inward, every.2.2⟩) (cond := fun w t es => w.flow.ClosedAt es t)
     (Witness.closedAt (Witness.once P) _ (fun _ => False) 0 id).roles⟩

/-- A pattern is shown on a family running down closed across the step exactly when it satisfies
the law of running down closed. -/
theorem runsDownClosed_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k e ↔
      RunsDownClosed P k e :=
  ⟨fun ⟨_, _, _, ⟨runs, closed⟩, _, realizes⟩ => realizes.runsDownClosed runs closed,
   fun ⟨⟨⟨every, balanced⟩, fall⟩, inward⟩ => Witness.realizedOnce every False
     (exchange_closed ⟨inward, every.2.2⟩)
     (cond := fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t)
     ⟨(Witness.runsDownOn (Witness.once P) (fun _ => False) 0 (k := fun _ => k)
        (Witness.once_chain P) balanced every.1 ((fall_iff_given balanced).mp fall)).roles,
      (Witness.closedAt (Witness.once P) _ (fun _ => False) 0 id).roles⟩⟩

/-- **What can run down, whatever the count.** Some number of relata taking from a family
running down across a step shows its passages and exchange exactly where each passage
balances, the total falls by one wherever anything is taken, and something exchanges
wherever anything is taken or given. -/
theorem runsDown_passages_iff (P : List Passage) (e : Prop) :
    (∃ k, Realized (fun w t es => w.flow.RunsDownOn w.web es t) P k e) ↔
      (∀ p, p ∈ P → p.Balanced) ∧
        total P Passage.after + sign (total P Passage.taken) ≤ total P Passage.before ∧
        (0 < total P Passage.taken ∨ 0 < total P Passage.given → e) :=
  ⟨fun ⟨_, realized⟩ => match (runsDown_iff _ _ _).mp realized with
    | ⟨⟨every, balanced⟩, fall⟩ =>
      ⟨balanced, Nat.le_trans (Nat.add_le_add_left every.1 _) fall, every.2.2⟩,
   fun ⟨balanced, fall, exchange⟩ => ⟨sign (total P Passage.taken), (runsDown_iff _ _ _).mpr
      ⟨⟨⟨Nat.le_refl _, sign_le _, exchange⟩, balanced⟩, fall⟩⟩⟩

/-- A property of patterns that does not tell apart equivalent readings of whether something
exchanges. Given propositional extensionality every property does; the pure core does not
assume it. -/
def Respects (Q : List Passage → Nat → Prop → Prop) : Prop :=
  ∀ {P k e e'}, (e ↔ e') → Q P k e → Q P k e'

/-- **No law of one step beyond the law.** Where a law is exact for a condition, a property of
patterns holds of what every step shows where the condition holds exactly when it holds of
every pattern satisfying the law. -/
theorem laws {cond : (w : World) → Nat → List w.Relatum → Prop}
    {Law : List Passage → Nat → Prop → Prop} (exact : ∀ P k e, Realized cond P k e ↔ Law P k e)
    {Q : List Passage → Nat → Prop → Prop} (respects : Respects Q) :
    (∀ (w : World) (t : Nat) (es : List w.Relatum), cond w t es → Distinct (w.flow.present t) →
      Q (es.map (w.flow.passage w.web t)) (w.flow.takers es t) (w.flow.ExchangesAt t)) ↔
      ∀ P k e, Law P k e → Q P k e :=
  ⟨fun shown P k e law => match (exact P k e).mpr law with
    | ⟨w, t, es, holds, distinct, passages, takers, exchanges⟩ =>
      respects exchanges (Eq.subst (motive := fun P => Q P k (w.flow.ExchangesAt t)) passages
        (Eq.subst (motive := fun k => Q (es.map (w.flow.passage w.web t)) k
          (w.flow.ExchangesAt t)) takers (shown w t es holds distinct))),
   fun law w t es holds distinct =>
    law _ _ _ ((exact _ _ _).mp ⟨w, t, es, holds, distinct, rfl, rfl, Iff.rfl⟩)⟩

/-! ## Each law is the whole law of a run under its condition -/

/-- Some world shows the run of patterns across every step on one family where the condition
holds at every step, listing each relatum taking part once. -/
def RunRealized (cond : (w : World) → Nat → List w.Relatum → Prop) (P : Nat → List Passage)
    (k : Nat → Nat) (e : Nat → Prop) : Prop :=
  ∃ (w : World) (es : List w.Relatum), ∀ t, cond w t es ∧ Distinct (w.flow.present t) ∧
    w.flow.Realizes w.web t es (P t) (k t) (e t)

/-- What a run shows follows on: what stands after each step is what stands before the next. -/
theorem RunRealized.chained {cond : (w : World) → Nat → List w.Relatum → Prop}
    {P : Nat → List Passage} {k : Nat → Nat} {e : Nat → Prop} :
    RunRealized cond P k e → Chained P
  | ⟨w, es, holds⟩, t =>
    (congrArg (List.map Passage.after) (holds t).2.2.1).symm.trans
      ((map_comp_eq (w.flow.passage w.web t) Passage.after es).trans
        ((map_comp_eq (w.flow.passage w.web (t + 1)) Passage.before es).symm.trans
          (congrArg (List.map Passage.before) (holds (t + 1)).2.2.1)))

/-- The same run, read with equivalent readings of whether something exchanges. -/
theorem RunRealized.exchange {cond : (w : World) → Nat → List w.Relatum → Prop}
    {P : Nat → List Passage} {k : Nat → Nat} {e e' : Nat → Prop} (same : ∀ t, e t ↔ e' t) :
    RunRealized cond P k e → RunRealized cond P k e'
  | ⟨w, es, holds⟩ => ⟨w, es, fun t => ⟨(holds t).1, (holds t).2.1, (holds t).2.2.1,
      (holds t).2.2.2.1, (holds t).2.2.2.2.trans (same t)⟩⟩

/-- The witness shows a run whose passages follow one another and satisfy the law of every step,
on one family, where the condition holds of it at every step. -/
theorem Witness.showsRun {P : Nat → List Passage} {k : Nat → Nat} (chain : Chained P)
    (every : ∀ t, sign (total (P t) Passage.taken) ≤ k t ∧ k t ≤ total (P t) Passage.taken)
    (o : Nat → Prop) {cond : (w : World) → Nat → List w.Relatum → Prop}
    (holds : ∀ t, cond (world P k o) t ((family (P t).length o).map .inr)) :
    RunRealized cond P k
      fun t => 0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t :=
  ⟨world P k o, (family (P 0).length o).map .inr, fun t =>
    Eq.subst (motive := fun m => cond (world P k o) t ((family m o).map .inr) ∧
        Distinct ((world P k o).flow.present t) ∧
        (world P k o).flow.Realizes (world P k o).web t ((family m o).map .inr) (P t) (k t)
          (0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t))
      (chain.lengths t)
      ⟨holds t, shows t (chain t) (every t).1 (every t).2 o⟩⟩

/-- **The law of every step is all the law of a run.** A run of patterns is shown by some world
across every step on one family exactly when its passages follow one another and each step
satisfies the law of every step. -/
theorem run_every_iff (P : Nat → List Passage) (k : Nat → Nat) (e : Nat → Prop) :
    RunRealized (fun _ _ _ => True) P k e ↔ Chained P ∧ ∀ t, Every (P t) (k t) (e t) :=
  ⟨fun realized => ⟨realized.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => (holds t).2.2.every⟩,
   fun ⟨chain, every⟩ => (Witness.showsRun chain (fun t => ⟨(every t).1, (every t).2.1⟩) e
      (cond := fun _ _ _ => True) fun _ => trivial).exchange
      fun t => exchange_open (every t).2.2⟩

/-- A run is shown on one family balanced on across every step exactly when its passages
follow one another and each step satisfies the law of balance. -/
theorem run_balance_iff (P : Nat → List Passage) (k : Nat → Nat) (e : Nat → Prop) :
    RunRealized (fun w t es => w.flow.BalancesOn w.web es t) P k e ↔
      Chained P ∧ ∀ t, Balance (P t) (k t) (e t) :=
  ⟨fun realized => ⟨realized.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => (holds t).2.2.balance (holds t).1⟩,
   fun ⟨chain, law⟩ => (Witness.showsRun chain (fun t => ⟨(law t).1.1, (law t).1.2.1⟩) e
      (cond := fun w t es => w.flow.BalancesOn w.web es t)
      fun t => (Witness.balancesOn P _ e t (chain t) (law t).2).roles).exchange
      fun t => exchange_open (law t).1.2.2⟩

/-- A run is shown on one family running down across every step exactly when its passages
follow one another and each step satisfies the law of running down. -/
theorem run_runsDown_iff (P : Nat → List Passage) (k : Nat → Nat) (e : Nat → Prop) :
    RunRealized (fun w t es => w.flow.RunsDownOn w.web es t) P k e ↔
      Chained P ∧ ∀ t, RunsDown (P t) (k t) (e t) :=
  ⟨fun realized => ⟨realized.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => (holds t).2.2.runsDown (holds t).1⟩,
   fun ⟨chain, law⟩ => (Witness.showsRun chain (fun t => ⟨(law t).1.1.1, (law t).1.1.2.1⟩) e
      (cond := fun w t es => w.flow.RunsDownOn w.web es t)
      fun t => (Witness.runsDownOn P e t (chain t) (law t).1.2 (law t).1.1.1
        ((fall_iff_given (law t).1.2).mp (law t).2)).roles).exchange
      fun t => exchange_open (law t).1.1.2.2⟩

/-- A run is shown on one family closed across every step exactly when its passages follow one
another and each step satisfies the law of closure. -/
theorem run_closed_iff (P : Nat → List Passage) (k : Nat → Nat) (e : Nat → Prop) :
    RunRealized (fun w t es => w.flow.ClosedAt es t) P k e ↔
      Chained P ∧ ∀ t, Closed (P t) (k t) (e t) :=
  ⟨fun realized => ⟨realized.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => (holds t).2.2.closed (holds t).1⟩,
   fun ⟨chain, law⟩ => (Witness.showsRun chain (fun t => ⟨(law t).1.1, (law t).1.2.1⟩)
      (fun _ => False) (cond := fun w t es => w.flow.ClosedAt es t)
      fun t => (Witness.closedAt P _ (fun _ => False) t id).roles).exchange
      fun t => exchange_closed ⟨(law t).2, (law t).1.2.2⟩⟩

/-- A run is shown on one family running down closed across every step exactly when its
passages follow one another and each step satisfies the law of running down closed. -/
theorem run_runsDownClosed_iff (P : Nat → List Passage) (k : Nat → Nat) (e : Nat → Prop) :
    RunRealized (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k e ↔
      Chained P ∧ ∀ t, RunsDownClosed (P t) (k t) (e t) :=
  ⟨fun realized => ⟨realized.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => (holds t).2.2.runsDownClosed (holds t).1.1 (holds t).1.2⟩,
   fun ⟨chain, law⟩ => (Witness.showsRun chain (fun t => ⟨(law t).1.1.1.1, (law t).1.1.1.2.1⟩)
      (fun _ => False)
      (cond := fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t)
      fun t => ⟨(Witness.runsDownOn P (fun _ => False) t (chain t) (law t).1.1.2
          (law t).1.1.1.1 ((fall_iff_given (law t).1.1.2).mp (law t).1.2)).roles,
        (Witness.closedAt P _ (fun _ => False) t id).roles⟩).exchange
      fun t => exchange_closed ⟨(law t).2, (law t).1.1.1.2.2⟩⟩

/-- A property of runs that does not tell apart runs alike at every step. Given function and
propositional extensionality every property does; the pure core assumes neither. -/
def RunRespects (Q : (Nat → List Passage) → (Nat → Nat) → (Nat → Prop) → Prop) : Prop :=
  ∀ {P P' : Nat → List Passage} {k k' : Nat → Nat} {e e' : Nat → Prop},
    (∀ t, P t = P' t ∧ k t = k' t ∧ (e t ↔ e' t)) → Q P k e → Q P' k' e'

/-- **No law of runs beyond the law.** Where a law of one step is exact for a condition held
across a run, a property of runs holds of what every world shows across its steps on a family
where the condition holds at every step exactly when it holds of every run whose passages
follow one another and whose steps satisfy the law. -/
theorem run_laws {cond : (w : World) → Nat → List w.Relatum → Prop}
    {Law : List Passage → Nat → Prop → Prop}
    (exact : ∀ P k e, RunRealized cond P k e ↔ Chained P ∧ ∀ t, Law (P t) (k t) (e t))
    {Q : (Nat → List Passage) → (Nat → Nat) → (Nat → Prop) → Prop} (respects : RunRespects Q) :
    (∀ (w : World) (es : List w.Relatum), (∀ t, cond w t es ∧ Distinct (w.flow.present t)) →
      Q (fun t => es.map (w.flow.passage w.web t)) (fun t => w.flow.takers es t)
        (fun t => w.flow.ExchangesAt t)) ↔
      ∀ P k e, Chained P → (∀ t, Law (P t) (k t) (e t)) → Q P k e :=
  ⟨fun shown P k e chain law => match (exact P k e).mpr ⟨chain, law⟩ with
    | ⟨w, es, holds⟩ => respects
        (fun t => ⟨(holds t).2.2.1, (holds t).2.2.2.1, (holds t).2.2.2.2⟩)
        (shown w es fun t => ⟨(holds t).1, (holds t).2.1⟩),
   fun law w es holds =>
    have shown := (exact _ _ _).mp ⟨w, es, fun t => ⟨(holds t).1, (holds t).2, rfl, rfl, Iff.rfl⟩⟩
    law _ _ _ shown.1 shown.2⟩

/-! ## What the stated laws miss -/

/-- The laws of one step as stated in `Becoming.Locality`, read on the pattern of a family
running down closed: balance at each member (`Flow.BalancesOn`); the total falling by at least
the relata taking (`Flow.RunsDownOn.takers_le_fall`, `Flow.BalancesOn.runs_down`); some standing
changing exactly when the total falls (`Flow.RunsDownOn.changes_iff`); and something exchanging
exactly when the total falls (`Flow.RunsDownOn.exchanges_iff`). -/
def Stated (P : List Passage) (k : Nat) (e : Prop) : Prop :=
  (∀ p, p ∈ P → p.Balanced) ∧ total P Passage.after + k ≤ total P Passage.before ∧
    ((∃ p, p ∈ P ∧ (p.before < p.after ∨ p.after < p.before)) ↔
      total P Passage.after < total P Passage.before) ∧
    (e ↔ total P Passage.after < total P Passage.before)

/-- **The stated laws with one more are the whole law.** For a family running down closed, the
law of one step is the stated laws together with the law of every step that something taken
from the family has a relatum taking it (`Flow.sign_uptake_le_takers`). -/
theorem runsDownClosed_iff_stated (P : List Passage) (k : Nat) (e : Prop) :
    RunsDownClosed P k e ↔ Stated P k e ∧ sign (total P Passage.taken) ≤ k :=
  have lowerOf {sgn : sign (total P Passage.taken) ≤ k}
      (fall : total P Passage.after + k ≤ total P Passage.before)
      (taken : 0 < total P Passage.taken) : total P Passage.after < total P Passage.before :=
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (pos_of_sign_le sgn taken)) fall
  have takenOfLower (balanced : ∀ p, p ∈ P → p.Balanced)
      (lower : total P Passage.after < total P Passage.before) : 0 < total P Passage.taken :=
    Nat.pos_of_ne_zero fun zero => Nat.not_le_of_gt lower (Nat.le_trans
      (Nat.le_add_right _ (total P Passage.given)) (Nat.le_of_eq
        ((Passage.balanced_total balanced).symm.trans (congrArg (_ + ·) zero))))
  have takenOfGiven (given : total P Passage.given + k ≤ total P Passage.taken)
      (pos : 0 < total P Passage.given) : 0 < total P Passage.taken :=
    Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right _ k) given)
  ⟨fun ⟨⟨⟨⟨sgn, _, exchange⟩, balanced⟩, fall⟩, inward⟩ =>
    have given := (fall_iff_given balanced).mp fall
    ⟨⟨balanced, fall,
      ⟨fun ⟨p, mem, change⟩ => lowerOf (sgn := sgn) fall (match change with
        | .inl rises => takenOfGiven given (Nat.lt_of_lt_of_le ((balanced p mem).given_pos rises)
            (le_total_of_mem mem))
        | .inr falls => Nat.lt_of_lt_of_le ((balanced p mem).taken_pos falls)
            (le_total_of_mem mem)),
       fun lower => match exists_lt_of_total_lt lower with
        | ⟨p, mem, falls⟩ => ⟨p, mem, .inr falls⟩⟩,
      ⟨fun holds => lowerOf (sgn := sgn) fall (match inward holds with
        | .inl taken => taken
        | .inr pos => takenOfGiven given pos),
       fun lower => exchange (.inl (takenOfLower balanced lower))⟩⟩, sgn⟩,
   fun ⟨⟨balanced, fall, _, exchange⟩, sgn⟩ =>
    have given := (fall_iff_given balanced).mp fall
    ⟨⟨⟨⟨sgn, Nat.le_trans (Nat.le_add_left k _) given, fun moved =>
        exchange.mpr (lowerOf (sgn := sgn) fall (match moved with
          | .inl taken => taken
          | .inr pos => takenOfGiven given pos))⟩, balanced⟩, fall⟩,
     fun holds => .inl (takenOfLower balanced (exchange.mp holds))⟩⟩

/-- **A pattern the stated laws allow and no world shows.** One condition standing at one,
taken from by one and given one across the step: passed through with no change, nothing
taking from it and nothing exchanging. It satisfies every stated law of one step for a family
running down closed, and no world shows it under any condition: something taken from a family
has a relatum taking it. -/
theorem stated_not_realized :
    Stated [⟨1, 1, 1, 1⟩] 0 False ∧ ¬ Realized (fun _ _ _ => True) [⟨1, 1, 1, 1⟩] 0 False :=
  have only : ∀ {p : Passage}, p ∈ [(⟨1, 1, 1, 1⟩ : Passage)] → p = ⟨1, 1, 1, 1⟩ :=
    fun mem => match mem_cons_cases mem with
    | .inl same => same
    | .inr nothing => nomatch nothing
  ⟨⟨fun _ mem => Eq.subst (motive := Passage.Balanced) (only mem).symm rfl,
    Nat.le_refl _,
    ⟨fun ⟨_, mem, change⟩ => absurd change (Eq.subst
        (motive := fun p : Passage => ¬ (p.before < p.after ∨ p.after < p.before)) (only mem).symm
        fun moved => match moved with
          | .inl less => Nat.lt_irrefl 1 less
          | .inr less => Nat.lt_irrefl 1 less),
     fun lower => absurd lower (Nat.lt_irrefl _)⟩,
    ⟨False.elim, fun lower => absurd lower (Nat.lt_irrefl _)⟩⟩,
   fun ⟨_, _, _, _, _, realizes⟩ => Nat.not_succ_le_zero 0 realizes.every.1⟩

/-! ## Standing at one condition -/

/-- **Balance at a condition, read of standing.** Some world, balanced at a condition across a
step, shows its level before, what was taken and given, and whether it came to stand or
ceased to stand, exactly when nothing is taken beyond what stood with what was given
(`Flow.BalancesOn.taken_le`) and coming and ceasing to stand are as
`Flow.BalancesOn.comesToStand_iff` and `Flow.BalancesOn.ceasesToStand_iff` fix them. -/
theorem standing_iff (a x y : Nat) (comes ceases : Prop) :
    (∃ (w : World) (t : Nat) (c : w.Relatum), w.flow.BalancesOn w.web [c] t ∧
      w.web.level t c = a ∧ w.flow.taken t c = x ∧ w.flow.given t c = y ∧
      (w.web.ComesToStand t c ↔ comes) ∧ (w.web.CeasesToStand t c ↔ ceases)) ↔
      x ≤ a + y ∧ (comes ↔ a = 0 ∧ x < y) ∧ (ceases ↔ 0 < a ∧ x = a + y) := by
  constructor
  · rintro ⟨w, t, c, balances, rfl, rfl, rfl, coming, ceasing⟩
    exact ⟨balances.taken_le (.head []),
      coming.symm.trans (balances.comesToStand_iff (.head [])),
      ceasing.symm.trans (balances.ceasesToStand_iff (.head []))⟩
  · rintro ⟨le, coming, ceasing⟩
    have nothing : excess x (a + y) = 0 := eq_zero_of_not_pos fun pos =>
      Nat.lt_irrefl x (Nat.lt_of_le_of_lt le (excess_pos.mp pos))
    have balanced : Passage.Balanced ⟨a, excess (a + y) x, x, y⟩ :=
      (Nat.add_comm _ x).trans ((excess_balance x (a + y)).trans
        ((congrArg ((a + y) + ·) nothing).trans (Nat.add_zero _)))
    have law : Balance [⟨a, excess (a + y) x, x, y⟩] (sign x) True :=
      ⟨⟨Nat.le_refl _, sign_le x, fun _ => trivial⟩, fun p mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Passage.Balanced) same.symm balanced
        | .inr nothing => nomatch nothing⟩
    obtain ⟨w, t, es, balances, _, passages, _, _⟩ := (balance_iff _ _ _).mpr law
    obtain ⟨c, rfl, same⟩ := map_eq_singleton passages
    have levelIs : w.web.level t c = a := congrArg Passage.before same
    have takenIs : w.flow.taken t c = x := congrArg Passage.taken same
    have givenIs : w.flow.given t c = y := congrArg Passage.given same
    subst levelIs takenIs givenIs
    exact ⟨w, t, c, balances, rfl, rfl, rfl,
      (balances.comesToStand_iff (.head [])).trans coming.symm,
      (balances.ceasesToStand_iff (.head [])).trans ceasing.symm⟩

/-- **The stated laws of standing miss the bound.** Standing at nothing, taken from by one and
given nothing, neither coming to stand nor ceasing to stand: the readings
`Flow.BalancesOn.comesToStand_iff` and `Flow.BalancesOn.ceasesToStand_iff` allow it, and no
world balanced at the condition shows it, since more is taken than stood with what was
given. -/
theorem standing_bound_needed :
    ((False ↔ 0 = 0 ∧ 1 < 0) ∧ (False ↔ 0 < 0 ∧ 1 = 0 + 0)) ∧
      ¬ ∃ (w : World) (t : Nat) (c : w.Relatum), w.flow.BalancesOn w.web [c] t ∧
        w.web.level t c = 0 ∧ w.flow.taken t c = 1 ∧ w.flow.given t c = 0 ∧
        (w.web.ComesToStand t c ↔ False) ∧ (w.web.CeasesToStand t c ↔ False) :=
  ⟨⟨⟨False.elim, fun ⟨_, less⟩ => Nat.not_lt_zero 1 less⟩,
    ⟨False.elim, fun ⟨less, _⟩ => Nat.lt_irrefl 0 less⟩⟩,
   fun shown => Nat.not_succ_le_zero 0 ((standing_iff 0 1 0 False False).mp shown).1⟩

end OneStep

end Becoming


namespace Becoming

variable {α β γ : Type} {F C : Type}

/-! ## Stretches of steps, split and shifted -/

/-- A total over a stretch starting later is the total over the stretch shifted back. -/
theorem total_steps_shift (q : Nat → Nat) (c : Nat) : ∀ T n,
    total (steps (T + c) n) q = total (steps T n) fun m => q (m + c)
  | _, 0 => rfl
  | T, n + 1 => congrArg (q (T + c) + ·)
      ((congrArg (fun x => total (steps x n) q) (Nat.add_right_comm T c 1)).trans
        (total_steps_shift q c (T + 1) n))

namespace OneStep

namespace Chain

open Witness (hit hit_self hit_pos pick pick_steps pick_lt pick_beyond least)

/-! ## Numbers -/

theorem none_ne_some {i : Nat} (same : (none : Option Nat) = some i) : False :=
  nomatch same

theorem hit_cases : ∀ a b, hit a b = 0 ∨ hit a b = 1
  | 0, 0 => .inr rfl
  | 0, _ + 1 => .inl rfl
  | _ + 1, 0 => .inl rfl
  | a + 1, b + 1 => hit_cases a b

theorem hit_lt {a b : Nat} (lt : a < b) : hit a b = 0 :=
  eq_zero_of_not_pos fun pos => Nat.lt_irrefl b (Eq.subst (motive := (· < b)) (hit_pos a b pos) lt)

theorem hit_of_eq {a b : Nat} (same : a = b) : hit a b = 1 :=
  Eq.subst (motive := fun x => hit a x = 1) same (hit_self a)

/-- Over the first `L` positions, a position below `L` is hit once. -/
theorem total_hit : ∀ (L j : Nat), j < L → total (steps 0 L) (fun i => hit j i) = 1
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | L + 1, 0, _ => congrArg (1 + ·) ((total_steps_shift (fun i => hit 0 i) 1 0 L).trans
      (total_zero (steps 0 L)))
  | L + 1, j + 1, lt => (congrArg (0 + ·) ((total_steps_shift (fun i => hit (j + 1) i) 1 0 L).trans
      (total_hit L j (Nat.lt_of_succ_lt_succ lt)))).trans (Nat.zero_add 1)

theorem least_le_left : ∀ a b, least a b ≤ a
  | 0, _ => Nat.le_refl 0
  | _ + 1, 0 => Nat.zero_le _
  | a + 1, b + 1 => Nat.succ_le_succ (least_le_left a b)

theorem least_le_right : ∀ a b, least a b ≤ b
  | 0, _ => Nat.zero_le _
  | _ + 1, 0 => Nat.le_refl 0
  | a + 1, b + 1 => Nat.succ_le_succ (least_le_right a b)

theorem least_pos : ∀ {a b : Nat}, 0 < a → 0 < b → 0 < least a b
  | 0, _, pos, _ => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, 0, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, _ + 1, _, _ => Nat.succ_pos _

theorem least_cases : ∀ a b, (least a b = a ∧ a ≤ b) ∨ (least a b = b ∧ b ≤ a)
  | 0, b => .inl ⟨rfl, Nat.zero_le b⟩
  | _ + 1, 0 => .inr ⟨rfl, Nat.zero_le _⟩
  | a + 1, b + 1 => match least_cases a b with
    | .inl ⟨same, le⟩ => .inl ⟨congrArg (· + 1) same, Nat.succ_le_succ le⟩
    | .inr ⟨same, le⟩ => .inr ⟨congrArg (· + 1) same, Nat.succ_le_succ le⟩

/-- What `a` exceeds `b` by, with `b`, is `a`, where `b ≤ a`. -/
theorem add_excess {a b : Nat} (le : b ≤ a) : b + excess a b = a :=
  (excess_balance b a).trans ((congrArg (a + ·) (Flow.excess_zero_of_le le)).trans (Nat.add_zero a))

/-! ## Lists of numbers -/

/-- The number at position `i`, nothing beyond the list. -/
def entry : List Nat → Nat → Nat
  | [], _ => 0
  | b :: _, 0 => b
  | _ :: bs, i + 1 => entry bs i

theorem entry_beyond : ∀ (l : List Nat) (i : Nat), l.length ≤ i → entry l i = 0
  | [], _, _ => rfl
  | _ :: _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: l, i + 1, le => entry_beyond l i (Nat.le_of_succ_le_succ le)

/-- A quantity vanishing at nothing, totalled over the positions of a list, is its total over
the list. -/
theorem entry_steps {q : Nat → Nat} (zero : q 0 = 0) :
    ∀ (l : List Nat) (N : Nat), l.length ≤ N → total (steps 0 N) (fun a => q (entry l a)) = total l q
  | [], N, _ => (total_congr (fun _ => zero) (steps 0 N)).trans (total_zero _)
  | _ :: _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | x :: l, N + 1, le => congrArg (q x + ·)
      ((total_steps_shift (fun a => q (entry (x :: l) a)) 1 0 N).trans
        (entry_steps zero l N (Nat.le_of_succ_le_succ le)))

theorem entry_map {q : Passage → Nat} (idle : q Passage.idle = 0) :
    ∀ (P : List Passage) (j : Nat), entry (P.map q) j = q (pick P j)
  | [], _ => idle.symm
  | _ :: _, 0 => rfl
  | _ :: P, j + 1 => entry_map idle P j

theorem entry_steps_map (f : Nat → Nat) : ∀ (k a : Nat), a < k → entry ((steps 0 k).map f) a = f a
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | k + 1, a + 1, lt =>
    (congrArg (fun l => entry (f 0 :: l) (a + 1)) (steps_succ_map f 0 k)).trans
      (entry_steps_map (fun m => f (m + 1)) k a (Nat.lt_of_succ_lt_succ lt))

/-! ## Laying units out in blocks -/

/-- Unit `m` among blocks, the first of size `b`: in the first block where `m < b`, else in
the block `rest` finds for `m - b`, one further on. -/
def within (rest : Nat → Nat) : Nat → Nat → Nat
  | 0, m => rest m + 1
  | _ + 1, 0 => 0
  | b + 1, m + 1 => within rest b m

/-- The block holding unit `m`, the units laid out in order in blocks of the listed sizes. -/
def slot : List Nat → Nat → Nat
  | [], _ => 0
  | b :: bs, m => within (slot bs) b m

theorem within_lt (rest : Nat → Nat) : ∀ {b m : Nat}, m < b → within rest b m = 0
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | b + 1, m + 1, lt => within_lt rest (b := b) (m := m) (Nat.lt_of_succ_lt_succ lt)

theorem within_add (rest : Nat → Nat) : ∀ b m, within rest b (m + b) = rest m + 1
  | 0, _ => rfl
  | b + 1, m => within_add rest b m

theorem within_bound {rest : Nat → Nat} {S L : Nat} (inside : ∀ m, m < S → rest m < L) :
    ∀ b m, m < b + S → within rest b m < L + 1
  | 0, m, lt => Nat.succ_lt_succ (inside m (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add S))))
  | _ + 1, 0, _ => Nat.succ_pos L
  | b + 1, m + 1, lt => within_bound inside b m (Nat.lt_of_succ_lt_succ
      (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.succ_add b S))))

/-- A unit within the total lies in some block of the list. -/
theorem slot_lt : ∀ (bs : List Nat) (m : Nat), m < total bs (fun x => x) → slot bs m < bs.length
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | b :: bs, m, lt => within_bound (fun m' lt' => slot_lt bs m' lt') b m lt

/-- **Blocks.** Of the units within the total, block `i` holds exactly its size. -/
theorem blocks : ∀ (bs : List Nat) (i : Nat),
    total (steps 0 (total bs fun x => x)) (fun m => hit (slot bs m) i) = entry bs i
  | [], _ => rfl
  | b :: bs, i =>
    have first : total (steps 0 b) (fun m => hit (slot (b :: bs) m) i) = b * hit 0 i :=
      (total_congr_on (g := fun _ => hit 0 i) fun _ mem => congrArg (hit · i)
        (within_lt (slot bs) (Nat.lt_of_lt_of_le (steps_within mem)
          (Nat.le_of_eq (Nat.zero_add b))))).trans
        ((total_const (hit 0 i) (steps 0 b)).trans
          (congrArg (· * hit 0 i) (steps_length 0 b)))
    have second : total (steps (0 + b) (total bs fun x => x)) (fun m => hit (slot (b :: bs) m) i) =
        total (steps 0 (total bs fun x => x)) (fun m => hit (slot bs m + 1) i) :=
      (total_steps_shift _ b 0 _).trans
        (total_congr (fun m => congrArg (hit · i) (within_add (slot bs) b m)) _)
    have tail : b * hit 0 i + total (steps 0 (total bs fun x => x)) (fun m => hit (slot bs m + 1) i) =
        entry (b :: bs) i :=
      match i with
      | 0 => (congrArg (b * 1 + ·) (total_zero _)).trans (Nat.mul_one b)
      | i + 1 => (congrArg (· + _) (Nat.mul_zero b)).trans ((Nat.zero_add _).trans (blocks bs i))
    (total_steps_add (fun m => hit (slot (b :: bs) m) i) 0 b (total bs fun x => x)).trans
      ((congr (congrArg (· + ·) first) second).trans tail)

/-- What relatum `a` moves at member `i`: of the units laid out at once in the blocks `d` (one
for each relatum) and in the blocks `s` (one for each member), those in block `a` of the first
and block `i` of the second. -/
def cell (d s : List Nat) (a i : Nat) : Nat :=
  total (steps 0 (total s fun x => x)) fun m => hit (slot d m) a * hit (slot s m) i

/-- **What a relatum moves in all.** Where the two layouts have the same total, relatum `a`
moves its block of `d` over the members. -/
theorem cell_rows {d s : List Nat} (same : total d (fun x => x) = total s fun x => x)
    {L : Nat} (le : s.length ≤ L) (a : Nat) :
    total (steps 0 L) (cell d s a) = entry d a :=
  (total_swap (fun i m => hit (slot d m) a * hit (slot s m) i) (steps 0 (total s fun x => x))
      (steps 0 L)).trans
    ((total_congr_on (g := fun m => hit (slot d m) a) fun m mem =>
        (total_mul (hit (slot d m) a) (fun i => hit (slot s m) i) (steps 0 L)).trans
          ((congrArg (hit (slot d m) a * ·) (total_hit L (slot s m) (Nat.lt_of_lt_of_le
            (slot_lt s m (Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add _))))
            le))).trans (Nat.mul_one _))).trans
      ((congrArg (fun n => total (steps 0 n) fun m => hit (slot d m) a) same.symm).trans
        (blocks d a)))

/-- **What a member is moved in all.** Where the two layouts have the same total, the relata
move member `i` by its block of `s`. -/
theorem cell_columns {d s : List Nat} (same : total d (fun x => x) = total s fun x => x)
    {N : Nat} (le : d.length ≤ N) (i : Nat) :
    total (steps 0 N) (fun a => cell d s a i) = entry s i :=
  (total_swap (fun a m => hit (slot d m) a * hit (slot s m) i) (steps 0 (total s fun x => x))
      (steps 0 N)).trans
    ((total_congr_on (g := fun m => hit (slot s m) i) fun m mem =>
        (total_congr (fun a => Nat.mul_comm (hit (slot d m) a) (hit (slot s m) i)) _).trans
          ((total_mul (hit (slot s m) i) (fun a => hit (slot d m) a) (steps 0 N)).trans
            ((congrArg (hit (slot s m) i * ·) (total_hit N (slot d m) (Nat.lt_of_lt_of_le
              (slot_lt d m (Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq
                ((Nat.zero_add _).trans same.symm)))) le))).trans (Nat.mul_one _)))).trans
      (blocks s i))

/-- Nothing is moved at a member beyond the layout. -/
theorem cell_beyond (d : List Nat) {s : List Nat} {i : Nat} (le : s.length ≤ i) (a : Nat) :
    cell d s a i = 0 :=
  total_eq_zero fun m mem => (congrArg (hit (slot d m) a * ·) (hit_lt (Nat.lt_of_lt_of_le
    (slot_lt s m (Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add _)))) le))).trans
    (Nat.mul_zero _)

/-! ## Shares of a total -/

/-- `k` shares of one each, the extra `x` added to the first, and each raised by what `g` has
at its position. -/
def lift (g : List Nat) (k x : Nat) : List Nat :=
  (steps 0 k).map fun a => entry g a + 1 + entry [x] a

theorem total_entry_one (x : Nat) : ∀ {k : Nat}, (0 < k ∨ x = 0) →
    total (steps 0 k) (entry [x]) = x
  | 0, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | 0, .inr zero => zero.symm
  | k + 1, _ => (entry_steps (q := fun y => y) rfl [x] (k + 1) (Nat.succ_le_succ (Nat.zero_le k))).trans
      (Nat.add_zero x)

theorem total_lift {g : List Nat} {k x : Nat} (le : g.length ≤ k) (some : 0 < k ∨ x = 0) :
    total (lift g k x) (fun y => y) = total g (fun y => y) + k + x :=
  (total_map _ (fun y => y) (steps 0 k)).trans
    ((total_add (fun a => entry g a + 1) (entry [x]) (steps 0 k)).trans
      (congr (congrArg (· + ·) ((total_add (entry g) (fun _ => 1) (steps 0 k)).trans
        (congr (congrArg (· + ·) (entry_steps (q := fun y => y) rfl g k le))
          ((total_ones _).trans (steps_length 0 k)))))
        (total_entry_one x some)))

theorem count_lift (g : List Nat) (k x : Nat) : count (lift g k x) (fun y => y) = k :=
  (total_map _ (fun y => sign y) (steps 0 k)).trans
    ((total_congr (q := fun _ => 1) (fun _ =>
        sign_eq_one (Nat.lt_of_lt_of_le (Nat.succ_pos _) (Nat.le_add_right _ _))) _).trans
      ((total_ones _).trans (steps_length 0 k)))

theorem lift_length (g : List Nat) (k x : Nat) : (lift g k x).length = k :=
  (length_map _ _).trans (steps_length 0 k)

/-- Each share gives at most what it takes less one: with `g` as what is given and `lift g k x`
as what is taken, wherever `g` lies within the `k` shares. -/
theorem lift_dissipates {g : List Nat} {k : Nat} (le : g.length ≤ k) (x a : Nat) :
    entry g a + sign (entry (lift g k x) a) ≤ entry (lift g k x) a :=
  match Nat.lt_or_ge a k with
  | .inl lt =>
    Eq.subst (motive := fun y => entry g a + sign y ≤ y)
      (entry_steps_map (fun a => entry g a + 1 + entry [x] a) k a lt).symm
      (Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _) (Nat.le_add_right _ _))
  | .inr ge =>
    have none : entry (lift g k x) a = 0 :=
      entry_beyond _ a (Nat.le_trans (Nat.le_of_eq (lift_length g k x)) ge)
    Nat.le_trans (Nat.le_of_eq ((congr (congrArg (· + ·) (entry_beyond g a (Nat.le_trans le ge)))
      (congrArg sign none)).trans none.symm)) (Nat.le_refl _)

/-- `Y` shared out over `r` shares of at least one and at most `cap` each, as much as possible to
the first. -/
def fill (cap : Nat) : Nat → Nat → List Nat
  | _, 0 => []
  | Y, r + 1 => least cap (excess Y r) :: fill cap (excess Y (least cap (excess Y r))) r

theorem fill_length (cap : Nat) : ∀ Y r, (fill cap Y r).length = r
  | _, 0 => rfl
  | _, r + 1 => congrArg Nat.succ (fill_length cap _ r)

/-- **Filling.** Where `r ≤ Y ≤ cap * r`, the `r` shares total `Y`, each of them at least one
and at most `cap`. -/
theorem fill_spec (cap : Nat) : ∀ (r Y : Nat), r ≤ Y → Y ≤ cap * r →
    total (fill cap Y r) (fun y => y) = Y ∧ count (fill cap Y r) (fun y => y) = r ∧
      ∀ a, entry (fill cap Y r) a ≤ cap
  | 0, _, _, le => ⟨(Flow.eq_zero_of_le_zero (Nat.le_trans le (Nat.le_of_eq (Nat.mul_zero cap)))).symm,
      rfl, fun _ => Nat.zero_le cap⟩
  | r + 1, Y, low, high =>
    have zpos : 0 < excess Y r := excess_pos.mpr low
    have rz : r + excess Y r = Y := add_excess (Nat.le_of_succ_le low)
    have cpos : 0 < cap := Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl 0
      (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.succ_pos r) low)
        (Nat.le_trans high (Nat.le_of_eq ((congrArg (· * (r + 1)) zero).trans (Nat.zero_mul _)))))
    have apos : 0 < least cap (excess Y r) := least_pos cpos zpos
    have az : least cap (excess Y r) ≤ excess Y r := least_le_right _ _
    have aY : least cap (excess Y r) ≤ Y :=
      Nat.le_trans az (Nat.le_trans (Nat.le_add_left _ r) (Nat.le_of_eq rz))
    have sum : least cap (excess Y r) + excess Y (least cap (excess Y r)) = Y := add_excess aY
    have low' : r ≤ excess Y (least cap (excess Y r)) :=
      le_of_add_le_add_right (least cap (excess Y r)) (Nat.le_trans
        (Nat.le_trans (Nat.add_le_add_left az r) (Nat.le_of_eq rz))
        (Nat.le_of_eq (sum.symm.trans (Nat.add_comm _ _))))
    have high' : excess Y (least cap (excess Y r)) ≤ cap * r :=
      match least_cases cap (excess Y r) with
      | .inl ⟨same, _⟩ => le_of_add_le_add_right cap (Nat.le_trans
          (Nat.le_of_eq ((Nat.add_comm _ _).trans
            ((congrArg (· + excess Y (least cap (excess Y r))) same.symm).trans sum)))
          (Nat.le_trans high (Nat.le_of_eq (Nat.mul_succ cap r))))
      | .inr ⟨same, _⟩ =>
        have rest : excess Y (least cap (excess Y r)) = r :=
          add_right_cancel (excess Y r) ((Nat.add_comm _ _).trans
            ((congrArg (· + excess Y (least cap (excess Y r))) same.symm).trans (sum.trans rz.symm)))
        Nat.le_trans (Nat.le_of_eq rest) (Nat.le_trans (Nat.le_of_eq (Nat.one_mul r).symm)
          (Nat.mul_le_mul_right r cpos))
    match fill_spec cap r _ low' high' with
    | ⟨total', count', within'⟩ =>
      ⟨(congrArg (least cap (excess Y r) + ·) total').trans sum,
       (congr (congrArg (· + ·) (sign_eq_one apos)) count').trans (Nat.add_comm 1 r),
       fun a => match a with
        | 0 => least_le_left _ _
        | a + 1 => within' a⟩

theorem fill_entry_le (cap : Nat) {r Y : Nat} (low : r ≤ Y) (high : Y ≤ cap * r) (a : Nat) :
    entry (fill cap Y r) a ≤ cap :=
  (fill_spec cap r Y low high).2.2 a

end Chain

end OneStep

/-! ## The givers: the laws of every step -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- Something given to a family has a relatum giving it: the relata giving to the family are at
least one wherever anything is given to it. -/
theorem sign_replenishment_le_renewers (cs : List C) (t : Nat) :
    sign (L.replenishment cs t) ≤ L.renewers cs t :=
  Nat.le_trans (Nat.le_of_eq (congrArg sign (total_swap (fun c f => L.give t f c) (L.present t) cs)))
    (sign_total_le (fun f => total cs (L.give t f)) (L.present t))

/-- Each relatum giving to a family gives it at least one. -/
theorem renewers_le_replenishment (cs : List C) (t : Nat) :
    L.renewers cs t ≤ L.replenishment cs t :=
  Nat.le_trans (count_le _ (L.present t))
    (Nat.le_of_eq (total_swap (fun f c => L.give t f c) cs (L.present t)))

/-- Dissipated on, every relatum giving to the family takes from it: the givers are at most the
takers. -/
theorem DissipatesOn.renewers_le_takers {cs : List C} {t : Nat}
    (dissipates : L.DissipatesOn cs t) : L.renewers cs t ≤ L.takers cs t :=
  total_le (L.present t) fun _ present =>
    sign_le_of_pos (dissipates.takes_of_gives present)

variable (L)

/-- Across the step from `t`, each relatum taking part gives the family at most `g`
(`Flow.Capacity` at one step). -/
def CapacityAt (cs : List C) (t g : Nat) : Prop :=
  ∀ f, f ∈ L.present t → total cs (L.give t f) ≤ g

/-- Across the step from `t`, only active relata give (`Flow.Acting` at one step). -/
def ActingAt (W : Web F C) (t : Nat) : Prop :=
  ∀ f c, f ∈ L.present t → 0 < L.give t f c → W.active t f

/-- Across the step from `t`, only active relata take, and only from what they draw on
(`Flow.Taking` at one step). -/
def TakingAt (W : Web F C) (t : Nat) : Prop :=
  ∀ f c, f ∈ L.present t → 0 < L.take t f c → W.active t f ∧ W.draws t f c

variable {L}

theorem capacity_iff_at {cs : List C} {g : Nat} : L.Capacity cs g ↔ ∀ t, L.CapacityAt cs t g :=
  ⟨fun capacity t => capacity t, fun capacity t => capacity t⟩

theorem acting_iff_at : L.Acting W ↔ ∀ t, L.ActingAt W t :=
  ⟨fun acting t => acting t, fun acting t => acting t⟩

theorem taking_iff_at : L.Taking W ↔ ∀ t, L.TakingAt W t :=
  ⟨fun taking t => taking t, fun taking t => taking t⟩

/-- The capacity law at one step: with each relatum giving at most `g`, what is given to the
family is at most `g` for each relatum giving to it. -/
theorem CapacityAt.replenishment_le {cs : List C} {t g : Nat} (capacity : L.CapacityAt cs t g) :
    L.replenishment cs t ≤ g * L.renewers cs t :=
  Nat.le_trans (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) cs))
    (total_le_count (L.present t) capacity)

variable (L W)

/-- The step from `t` shows the pattern `P`, `k`, `e` on `es` (`Flow.Realizes`), and `r` relata
taking part give to the family. -/
def RealizesGivers (t : Nat) (es : List C) (P : List Passage) (k r : Nat) (e : Prop) : Prop :=
  L.Realizes W t es P k e ∧ L.renewers es t = r

variable {L W}

end Flow

namespace OneStep

/-- The law of the givers: the relata giving to the family are at least one where anything is
given to it and at most what is given. -/
def Givers (P : List Passage) (r : Nat) : Prop :=
  sign (total P Passage.given) ≤ r ∧ r ≤ total P Passage.given

end OneStep

namespace Flow

variable {L : Flow F C} {W : Web F C} {t : Nat} {es : List C} {P : List Passage} {k r : Nat}
  {e : Prop}

/-- Every shown pattern satisfies the law of the givers. -/
theorem RealizesGivers.givers (realizes : L.RealizesGivers W t es P k r e) : OneStep.Givers P r :=
  ⟨Nat.le_trans (Nat.le_of_eq (congrArg sign realizes.1.replenishment))
      (Nat.le_trans (sign_replenishment_le_renewers es t) (Nat.le_of_eq realizes.2)),
   Nat.le_trans (Nat.le_of_eq realizes.2.symm)
      (Nat.le_trans (renewers_le_replenishment es t) (Nat.le_of_eq realizes.1.replenishment.symm))⟩

/-- Dissipated on, the givers shown are at most the takers. -/
theorem RealizesGivers.takers (realizes : L.RealizesGivers W t es P k r e)
    (dissipates : L.DissipatesOn es t) : r ≤ k :=
  Nat.le_trans (Nat.le_of_eq realizes.2.symm)
    (Nat.le_trans dissipates.renewers_le_takers (Nat.le_of_eq realizes.1.2.1))

/-- With each relatum giving at most `g`, what is shown given is at most `g` for each giver. -/
theorem RealizesGivers.capacity (realizes : L.RealizesGivers W t es P k r e) {g : Nat}
    (capacity : L.CapacityAt es t g) : total P Passage.given ≤ g * r :=
  Nat.le_trans (Nat.le_of_eq realizes.1.replenishment)
    (Nat.le_trans capacity.replenishment_le (Nat.le_of_eq (congrArg (g * ·) realizes.2)))

/-- The same pattern, read with an equivalent reading of whether something exchanges. -/
theorem RealizesGivers.exchange (realizes : L.RealizesGivers W t es P k r e) {e' : Prop}
    (same : e ↔ e') : L.RealizesGivers W t es P k r e' :=
  ⟨⟨realizes.1.1, realizes.1.2.1, realizes.1.2.2.trans same⟩, realizes.2⟩

theorem RealizesGivers.roles (realizes : L.RealizesGivers W t es P k r e) :
    L.roles.RealizesGivers W.roles t (es.map .inr) P k r e :=
  ⟨realizes.1.roles, (L.roles_renewers es t).trans realizes.2⟩

theorem CapacityAt.roles {g : Nat} (capacity : L.CapacityAt es t g) :
    L.roles.CapacityAt (es.map .inr) t g :=
  fun _ mem => match preimage_of_mem_map mem with
  | ⟨f, present, same⟩ => Eq.subst (motive := fun x => total (es.map .inr) (L.roles.give t x) ≤ g)
      same (Nat.le_trans (Nat.le_of_eq (total_map Sum.inr (L.roles.give t (.inl f)) es))
        (capacity f present))

theorem ActingAt.roles (acting : L.ActingAt W t) : L.roles.ActingAt W.roles t :=
  fun x y mem gives => match x, y, mem, gives with
  | .inl f, .inr c, mem, gives => acting f c (mem_of_map inl_injective mem) gives
  | .inl _, .inl _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | .inr _, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem TakingAt.roles (taking : L.TakingAt W t) : L.roles.TakingAt W.roles t :=
  fun x y mem takes => match x, y, mem, takes with
  | .inl f, .inr c, mem, takes => taking f c (mem_of_map inl_injective mem) takes
  | .inl _, .inl _, _, takes => absurd takes (Nat.lt_irrefl 0)
  | .inr _, _, _, takes => absurd takes (Nat.lt_irrefl 0)

end Flow

/-! ## The chain witness -/

namespace OneStep

namespace Chain

open Witness (hit hit_self hit_pos pick pick_steps pick_lt pick_mem pick_beyond)

/-! ### Following positions from step to step -/

variable (σ ρ : Nat → Nat → Option Nat)

/-- Where nothing at the step before leads to position `j`, a chain is born there. -/
def born (j : Nat) : Option Nat → Option Nat
  | none => some j
  | some _ => none

/-- Where the chain born at step `b` at position `j` stands at `b`: every position of the first
step begins a chain, and a later position does where nothing leads to it. -/
def start (b j : Nat) : Option Nat :=
  match b with
  | 0 => some j
  | b + 1 => born j (ρ b j)

/-- The position `n` steps after its birth of the chain born at `b` at `j`, following `σ`. -/
def run (b j : Nat) : Nat → Option Nat
  | 0 => start ρ b j
  | n + 1 => (run b j n).bind (σ (n + b))

/-- How many steps `s` lies after `b`, if it does not lie before. -/
def later : Nat → Nat → Option Nat
  | 0, s => some s
  | _ + 1, 0 => none
  | b + 1, s + 1 => later b s

/-- The position at step `s` of the chain born at `x.1` at position `x.2`. -/
def track (x : Nat × Nat) (s : Nat) : Option Nat :=
  (later x.1 s).bind (run σ ρ x.1 x.2)

def originStep (prev : Nat → Nat × Nat) (b j : Nat) : Option Nat → Nat × Nat
  | some i => prev i
  | none => (b, j)

/-- Where the chain through position `j` at step `t` was born. -/
def origin : Nat → Nat → Nat × Nat
  | 0, j => (0, j)
  | t + 1, j => originStep (origin t) (t + 1) j (ρ t j)

/-- Links between the positions of consecutive steps: `σ` and `ρ` are inverse, and what stands
after a step at a position is what stands before the next at the position it leads to. -/
structure Links (P : Nat → List Passage) : Prop where
  back : ∀ t i j, σ t i = some j → ρ t j = some i
  forth : ∀ t i j, ρ t j = some i → σ t i = some j
  keeps : ∀ t i j, σ t i = some j → (pick (P t) i).after = (pick (P (t + 1)) j).before

theorem later_self : ∀ b, later b b = some 0
  | 0 => rfl
  | b + 1 => later_self b

theorem later_add : ∀ b n, later b (n + b) = some n
  | 0, _ => rfl
  | b + 1, n => later_add b n

theorem later_lt : ∀ {b s : Nat}, s < b → later b s = none
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | b + 1, s + 1, lt => later_lt (b := b) (s := s) (Nat.lt_of_succ_lt_succ lt)

theorem track_add (b j n : Nat) : track σ ρ (b, j) (n + b) = run σ ρ b j n :=
  congrArg (fun o => Option.bind o (run σ ρ b j)) (later_add b n)

theorem track_self (b j : Nat) : track σ ρ (b, j) b = start ρ b j :=
  congrArg (fun o => Option.bind o (run σ ρ b j)) (later_self b)

theorem track_lt {b j s : Nat} (lt : s < b) : track σ ρ (b, j) s = none :=
  congrArg (fun o => Option.bind o (run σ ρ b j)) (later_lt lt)

theorem tracked_from {x : Nat × Nat} {s i : Nat} (tracked : track σ ρ x s = some i) : x.1 ≤ s :=
  match x, tracked with
  | (_, _), tracked => Nat.ge_of_not_lt fun lt =>
      none_ne_some ((track_lt σ ρ lt).symm.trans tracked)

theorem track_succ_add (b j n : Nat) :
    track σ ρ (b, j) (n + b + 1) = (track σ ρ (b, j) (n + b)).bind (σ (n + b)) :=
  (congrArg (track σ ρ (b, j)) (Nat.succ_add n b).symm).trans
    ((track_add σ ρ b j (n + 1)).trans
      (congrArg (fun o => Option.bind o (σ (n + b))) (track_add σ ρ b j n).symm))

/-- After its birth a chain follows `σ`. -/
theorem track_succ {x : Nat × Nat} {s : Nat} (le : x.1 ≤ s) :
    track σ ρ x (s + 1) = (track σ ρ x s).bind (σ s) :=
  match x, le_dest le with
  | (b, j), ⟨m, same⟩ =>
    Eq.subst (motive := fun s => track σ ρ (b, j) (s + 1) = (track σ ρ (b, j) s).bind (σ s))
      ((Nat.add_comm m b).trans same.symm) (track_succ_add σ ρ b j m)

theorem originStep_le {prev : Nat → Nat × Nat} {t : Nat} (le : ∀ i, (prev i).1 ≤ t) (j : Nat) :
    ∀ o, (originStep prev (t + 1) j o).1 ≤ t + 1
  | some i => Nat.le_succ_of_le (le i)
  | none => Nat.le_refl _

theorem origin_le : ∀ t j, (origin ρ t j).1 ≤ t
  | 0, _ => Nat.le_refl 0
  | t + 1, j => originStep_le (fun i => origin_le t i) j (ρ t j)

theorem track_originStep (forth : ∀ t i j, ρ t j = some i → σ t i = some j) {t j : Nat}
    (prev : ∀ i, track σ ρ (origin ρ t i) t = some i) :
    ∀ o, ρ t j = o → track σ ρ (originStep (origin ρ t) (t + 1) j o) (t + 1) = some j
  | some i, linked => (track_succ σ ρ (origin_le ρ t i)).trans
      ((congrArg (fun o => Option.bind o (σ t)) (prev i)).trans (forth t i j linked))
  | none, unlinked => (track_self σ ρ (t + 1) j).trans (congrArg (born j) unlinked)

/-- The chain through a position stands there. -/
theorem track_origin (forth : ∀ t i j, ρ t j = some i → σ t i = some j) :
    ∀ t j, track σ ρ (origin ρ t j) t = some j
  | 0, _ => rfl
  | t + 1, j => track_originStep σ ρ forth (track_origin forth t) (ρ t j) rfl

theorem origin_born {b i0 j : Nat} :
    ∀ o, ρ b i0 = o → born i0 o = some j → origin ρ (b + 1) j = (b + 1, i0)
  | none, unlinked, started =>
    Eq.subst (motive := fun j => origin ρ (b + 1) j = (b + 1, i0)) (ListTests.some_inj started)
      (congrArg (originStep (origin ρ b) (b + 1) i0) unlinked)
  | some _, _, started => (none_ne_some started).elim

theorem origin_start : ∀ (b : Nat) {i0 j : Nat}, start ρ b i0 = some j → origin ρ b j = (b, i0)
  | 0, _, _, started => congrArg (Prod.mk 0) (ListTests.some_inj started).symm
  | b + 1, i0, _, started => origin_born ρ (ρ b i0) rfl started

theorem origin_step (back : ∀ t i j, σ t i = some j → ρ t j = some i) {b i0 n j : Nat}
    (prev : ∀ i, run σ ρ b i0 n = some i → origin ρ (n + b) i = (b, i0)) :
    ∀ o, run σ ρ b i0 n = o → o.bind (σ (n + b)) = some j → origin ρ (n + 1 + b) j = (b, i0)
  | some i, ran, linked =>
    Eq.subst (motive := fun s => origin ρ s j = (b, i0)) (Nat.succ_add n b).symm
      ((congrArg (originStep (origin ρ (n + b)) (n + b + 1) j) (back (n + b) i j linked)).trans
        (prev i ran))
  | none, _, linked => (none_ne_some linked).elim

theorem origin_of_run (back : ∀ t i j, σ t i = some j → ρ t j = some i) (b i0 : Nat) :
    ∀ n j, run σ ρ b i0 n = some j → origin ρ (n + b) j = (b, i0)
  | 0, _, started => Eq.subst (motive := fun s => origin ρ s _ = (b, i0)) (Nat.zero_add b).symm
      (origin_start ρ b started)
  | n + 1, _, ran => origin_step σ ρ back (fun i h => origin_of_run back b i0 n i h)
      (run σ ρ b i0 n) rfl ran

/-- A chain standing at a position is the chain through it. -/
theorem origin_of_track (back : ∀ t i j, σ t i = some j → ρ t j = some i) {x : Nat × Nat}
    {t j : Nat} (tracked : track σ ρ x t = some j) : origin ρ t j = x :=
  match x, tracked with
  | (b, i0), tracked => match le_dest (tracked_from σ ρ tracked) with
    | ⟨m, same⟩ =>
      Eq.subst (motive := fun s => track σ ρ (b, i0) s = some j → origin ρ s j = (b, i0))
        ((Nat.add_comm m b).trans same.symm)
        (fun tr => origin_of_run σ ρ back b i0 m j ((track_add σ ρ b i0 m).symm.trans tr)) tracked

/-! ### The world of a linked run -/

/-- What stands before a step at a position, nothing at no position. -/
def beforeAt (Q : List Passage) : Option Nat → Nat
  | some j => (pick Q j).before
  | none => 0

/-- What stands after a step at a position; `rest` at no position. -/
def afterAt (Q : List Passage) (rest : Nat) : Option Nat → Nat
  | some i => (pick Q i).after
  | none => rest

/-- A reading of the passage at a position, nothing at no position. -/
def readAt (q : Passage → Nat) (Q : List Passage) : Option Nat → Nat
  | some j => q (pick Q j)
  | none => 0

/-- The level of the chain born at `x` at each step: what its passage says before a step, what
its last passage left after it, nothing before its birth or once it has ended. -/
def levelAt (P : Nat → List Passage) (x : Nat × Nat) : Nat → Nat
  | 0 => beforeAt (P 0) (track σ ρ x 0)
  | s + 1 => afterAt (P s) (beforeAt (P (s + 1)) (track σ ρ x (s + 1))) (track σ ρ x s)

/-- What relatum `a` moves at a position, nothing at no position. -/
def cellAt (d s : List Nat) (a : Nat) : Option Nat → Nat
  | some j => cell d s a j
  | none => 0

/-- The relata of the chain witness: numbered ones, and an outer one exchanging beyond the
family only. -/
inductive Relatum where
  | numbered (a : Nat)
  | outer

/-- The conditions of the chain witness: the chains, each named by where it was born, and one
beyond the family for each step `s` and each proof of `o s`. -/
inductive Site (o : Nat → Prop) where
  | node (x : Nat × Nat)
  | beyond (s : Nat) (h : o s)

variable (P : Nat → List Passage) (d g : Nat → List Nat) (o : Nat → Prop)

/-- The flow of the chain witness: across the step from `t`, numbered relatum `a` takes its
block of `d t` and gives its block of `g t`, laid out over the members in order; the outer one
exchanges with what lies beyond at the step. -/
def flow : Flow Relatum (Site o) where
  present t := (steps 0 ((d t).length + (g t).length)).map Relatum.numbered ++ [Relatum.outer]
  take t f c := match f, c with
    | .numbered a, .node x => cellAt (d t) ((P t).map Passage.taken) a (track σ ρ x t)
    | .numbered _, .beyond _ _ => 0
    | .outer, .node _ => 0
    | .outer, .beyond s _ => hit s t
  give t f c := match f, c with
    | .numbered a, .node x => cellAt (g t) ((P t).map Passage.given) a (track σ ρ x t)
    | .numbered _, .beyond _ _ => 0
    | .outer, .node _ => 0
    | .outer, .beyond s _ => hit s t

/-- The web of the chain witness: each chain stands as its passages say; nothing else stands.
Every relatum is active and draws on every condition; nothing depends on anything. -/
def web : Web Relatum (Site o) where
  level t c := match c with
    | .node x => levelAt σ ρ P x t
    | .beyond _ _ => 0
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The family at step `t`: the chains through its positions, in order. -/
def family (t : Nat) : List (Site o) :=
  (steps 0 (P t).length).map fun j => .node (origin ρ t j)

/-- The chain witness as a world, read with one kind of relatum. -/
def world : World :=
  World.ofRoles (flow σ ρ P d g o) (web σ ρ P o)

variable {σ ρ P d g o}

theorem numbered_injective : ∀ a b : Nat, Relatum.numbered a = .numbered b → a = b
  | _, _, rfl => rfl

def Site.point {o : Nat → Prop} : Site o → Nat × Nat
  | .node x => x
  | .beyond _ _ => (0, 0)

theorem total_present (t : Nat) (q : Relatum → Nat) :
    total ((flow σ ρ P d g o).present t) q =
      total (steps 0 ((d t).length + (g t).length)) (fun a => q (.numbered a)) + q .outer :=
  (total_append q [Relatum.outer] _).trans
    (congr (congrArg (· + ·) (total_map Relatum.numbered q _)) (Nat.add_zero (q .outer)))

theorem distinct_present (t : Nat) : Distinct ((flow σ ρ P d g o).present t) :=
  distinct_append (distinct_map numbered_injective (steps_distinct 0 _))
    (show ¬ Relatum.outer ∈ ([] : List Relatum) ∧ Distinct ([] : List Relatum) from
      ⟨fun nothing => (nomatch nothing), trivial⟩)
    fun _ inside last => match preimage_of_mem_map inside, mem_cons_cases last with
      | ⟨_, _, same⟩, .inl outer => nomatch same.trans outer
      | _, .inr nothing => nomatch nothing

theorem outer_mem (t : Nat) : Relatum.outer ∈ (flow σ ρ P d g o).present t :=
  mem_append_of_right _ (.head [])

theorem numbered_mem {t a : Nat} (lt : a < (d t).length + (g t).length) :
    Relatum.numbered a ∈ (flow σ ρ P d g o).present t :=
  mem_append_of_left _ (mem_map_of (steps_of_within (Nat.zero_le a)
    (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add _).symm))))

/-! ### At one step -/

theorem cellAt_total {dd s : List Nat} (same : total dd (fun y => y) = total s fun y => y)
    {N : Nat} (le : dd.length ≤ N) {q : Passage → Nat} (idle : q Passage.idle = 0)
    {Q : List Passage} (reads : s = Q.map q) :
    ∀ oo, total (steps 0 N) (fun a => cellAt dd s a oo) = readAt q Q oo
  | some j => (cell_columns same le j).trans
      ((congrArg (fun l => entry l j) reads).trans (entry_map idle Q j))
  | none => total_zero _

theorem taken_node (t : Nat) (x : Nat × Nat)
    (sumd : total (d t) (fun y => y) = total (P t) Passage.taken) :
    (flow σ ρ P d g o).taken t (.node x) = readAt Passage.taken (P t) (track σ ρ x t) :=
  (total_present t _).trans ((Nat.add_zero _).trans
    (cellAt_total (sumd.trans (total_map Passage.taken (fun y => y) (P t)).symm)
      (Nat.le_add_right _ _) rfl rfl (track σ ρ x t)))

theorem given_node (t : Nat) (x : Nat × Nat)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    (flow σ ρ P d g o).given t (.node x) = readAt Passage.given (P t) (track σ ρ x t) :=
  (total_present t _).trans ((Nat.add_zero _).trans
    (cellAt_total (sumg.trans (total_map Passage.given (fun y => y) (P t)).symm)
      (Nat.le_add_left _ _) rfl rfl (track σ ρ x t)))

variable (links : Links σ ρ P)
include links

omit links in
theorem total_family (t : Nat) (q : Site o → Nat) :
    total (family ρ P o t) q = total (steps 0 (P t).length) fun j => q (.node (origin ρ t j)) :=
  total_map _ q _

theorem take_family {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (a : Nat) : total (family ρ P o t) ((flow σ ρ P d g o).take t (.numbered a)) = entry (d t) a :=
  (total_family t _).trans
    ((total_congr (fun j => congrArg (cellAt (d t) ((P t).map Passage.taken) a)
      (track_origin σ ρ links.forth t j)) _).trans
      (cell_rows (sumd.trans (total_map Passage.taken (fun y => y) (P t)).symm)
        (Nat.le_of_eq (length_map _ _)) a))

theorem give_family {t : Nat} (sumg : total (g t) (fun y => y) = total (P t) Passage.given)
    (a : Nat) : total (family ρ P o t) ((flow σ ρ P d g o).give t (.numbered a)) = entry (g t) a :=
  (total_family t _).trans
    ((total_congr (fun j => congrArg (cellAt (g t) ((P t).map Passage.given) a)
      (track_origin σ ρ links.forth t j)) _).trans
      (cell_rows (sumg.trans (total_map Passage.given (fun y => y) (P t)).symm)
        (Nat.le_of_eq (length_map _ _)) a))

omit links in
theorem take_family_outer (t : Nat) :
    total (family ρ P o t) ((flow σ ρ P d g o).take t .outer) = 0 :=
  (total_family t _).trans (total_zero _)

omit links in
theorem give_family_outer (t : Nat) :
    total (family ρ P o t) ((flow σ ρ P d g o).give t .outer) = 0 :=
  (total_family t _).trans (total_zero _)

/-- How many take from the family: the relata with a positive block of `d t`. -/
theorem takers_family {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken) :
    (flow σ ρ P d g o).takers (family ρ P o t) t = count (d t) (fun y => y) :=
  (total_present t _).trans
    ((congr (congrArg (· + ·) ((total_congr (fun a => congrArg sign
        (take_family links sumd a)) _).trans
        (entry_steps (q := sign) rfl (d t) _ (Nat.le_add_right _ _))))
      (congrArg sign (take_family_outer t))).trans (Nat.add_zero _))

/-- How many give to the family: the relata with a positive block of `g t`. -/
theorem renewers_family {t : Nat} (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    (flow σ ρ P d g o).renewers (family ρ P o t) t = count (g t) (fun y => y) :=
  (total_present t _).trans
    ((congr (congrArg (· + ·) ((total_congr (fun a => congrArg sign
        (give_family links sumg a)) _).trans
        (entry_steps (q := sign) rfl (g t) _ (Nat.le_add_left _ _))))
      (congrArg sign (give_family_outer t))).trans (Nat.add_zero _))

theorem levelAt_originStep {s j : Nat} : ∀ oo, ρ s j = oo →
    afterAt (P s) (beforeAt (P (s + 1)) (track σ ρ (originStep (origin ρ s) (s + 1) j oo) (s + 1)))
      (track σ ρ (originStep (origin ρ s) (s + 1) j oo) s) = (pick (P (s + 1)) j).before
  | some i, linked =>
    (congrArg (afterAt (P s) (beforeAt (P (s + 1)) (track σ ρ (origin ρ s i) (s + 1))))
      (track_origin σ ρ links.forth s i)).trans (links.keeps s i j (links.forth s i j linked))
  | none, unlinked =>
    (congrArg (afterAt (P s) (beforeAt (P (s + 1)) (track σ ρ (s + 1, j) (s + 1))))
      (track_lt σ ρ (Nat.lt_succ_self s))).trans
      (congrArg (beforeAt (P (s + 1))) ((track_self σ ρ (s + 1) j).trans
        (congrArg (born j) unlinked)))

/-- What stands before a step at the chain through a position is what its passage says. -/
theorem levelAt_origin : ∀ t j, levelAt σ ρ P (origin ρ t j) t = (pick (P t) j).before
  | 0, j => congrArg (beforeAt (P 0)) (track_origin σ ρ links.forth 0 j)
  | s + 1, j => levelAt_originStep links (ρ s j) rfl

/-- And what stands after it. -/
theorem levelAt_origin_succ (t j : Nat) :
    levelAt σ ρ P (origin ρ t j) (t + 1) = (pick (P t) j).after :=
  congrArg (afterAt (P t) (beforeAt (P (t + 1)) (track σ ρ (origin ρ t j) (t + 1))))
    (track_origin σ ρ links.forth t j)

theorem passage_member {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) (j : Nat) :
    (flow σ ρ P d g o).passage (web σ ρ P o) t (.node (origin ρ t j)) = pick (P t) j :=
  Passage.ext_of (levelAt_origin links t j) (levelAt_origin_succ links t j)
    ((taken_node t _ sumd).trans (congrArg (readAt Passage.taken (P t))
      (track_origin σ ρ links.forth t j)))
    ((given_node t _ sumg).trans (congrArg (readAt Passage.given (P t))
      (track_origin σ ρ links.forth t j)))

/-- The chain witness shows the passages of the step, in order. -/
theorem passages {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    (family ρ P o t).map ((flow σ ρ P d g o).passage (web σ ρ P o) t) = P t :=
  (map_comp_eq _ _ (steps 0 (P t).length)).trans
    ((map_eq_of (passage_member links sumd sumg) _).trans (pick_steps (P t)))

theorem distinct_family (t : Nat) : Distinct (family ρ P o t) :=
  distinct_map_on (fun j j' _ _ same => ListTests.some_inj ((track_origin σ ρ links.forth t j).symm.trans
      ((congrArg (fun x => track σ ρ x t) (Site.node.inj same)).trans
        (track_origin σ ρ links.forth t j'))))
    (steps_distinct 0 _)

omit links in
theorem mem_family {t j : Nat} (lt : j < (P t).length) :
    (Site.node (origin ρ t j) : Site o) ∈ family ρ P o t :=
  mem_map_of (steps_of_within (Nat.zero_le j)
    (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add _).symm)))

omit links in
theorem of_mem_family {t : Nat} {c : Site o} (mem : c ∈ family ρ P o t) :
    ∃ j, j < (P t).length ∧ c = .node (origin ρ t j) :=
  match preimage_of_mem_map mem with
  | ⟨j, inside, same⟩ =>
    ⟨j, Nat.lt_of_lt_of_le (steps_within inside) (Nat.le_of_eq (Nat.zero_add _)), same.symm⟩

/-- A chain standing at a position of the step is a member of its family. -/
theorem node_mem {x : Nat × Nat} {t j : Nat} (tracked : track σ ρ x t = some j)
    (lt : j < (P t).length) : (Site.node x : Site o) ∈ family ρ P o t :=
  Eq.subst (motive := fun y => (Site.node y : Site o) ∈ family ρ P o t)
    (origin_of_track σ ρ links.back tracked) (mem_family lt)

theorem uptake_family {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken) :
    (flow σ ρ P d g o).uptake (family ρ P o t) t = total (P t) Passage.taken :=
  (total_family t _).trans ((total_congr (fun j => (taken_node t _ sumd).trans
    (congrArg (readAt Passage.taken (P t)) (track_origin σ ρ links.forth t j))) _).trans
    (Witness.total_pick (P t) Passage.taken))

theorem replenishment_family {t : Nat}
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    (flow σ ρ P d g o).replenishment (family ρ P o t) t = total (P t) Passage.given :=
  (total_family t _).trans ((total_congr (fun j => (given_node t _ sumg).trans
    (congrArg (readAt Passage.given (P t)) (track_origin σ ρ links.forth t j))) _).trans
    (Witness.total_pick (P t) Passage.given))

omit links in
theorem readAt_pos {q : Passage → Nat} {Q : List Passage} :
    ∀ {oo : Option Nat}, 0 < readAt q Q oo → ∃ j, oo = some j ∧ 0 < q (pick Q j)
  | some j, pos => ⟨j, rfl, pos⟩
  | none, pos => absurd pos (Nat.lt_irrefl 0)

omit links in
theorem total_pos_of_read {q : Passage → Nat} (idle : q Passage.idle = 0) {Q : List Passage}
    {j : Nat} (pos : 0 < q (pick Q j)) : 0 < total Q q :=
  Nat.lt_of_lt_of_le pos (le_total_of_mem (pick_mem Q j (pick_lt idle Q j pos)))

omit links in
/-- What exchanges beyond the family exchanges at the step it belongs to. -/
theorem beyond_moves (t : Nat) : ∀ (f : Relatum) {s : Nat} {h : o s},
    0 < (flow σ ρ P d g o).take t f (.beyond s h) ∨ 0 < (flow σ ρ P d g o).give t f (.beyond s h) →
      s = t
  | .numbered _, _, _, .inl pos => absurd pos (Nat.lt_irrefl 0)
  | .numbered _, _, _, .inr pos => absurd pos (Nat.lt_irrefl 0)
  | .outer, s, _, .inl pos => hit_pos s t pos
  | .outer, s, _, .inr pos => hit_pos s t pos

/-- Something exchanges across the step exactly where something is taken from or given to the
family, or `o` holds at the step. -/
theorem exchangesAt_iff {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    (flow σ ρ P d g o).ExchangesAt t ↔
      0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t :=
  ⟨fun ⟨f, c, present, exchanges⟩ => match c, exchanges with
    | .beyond _ h, moves => .inr (.inr (Eq.subst (motive := o) (beyond_moves t f moves) h))
    | .node x, .inl takes =>
      match readAt_pos (Nat.lt_of_lt_of_le takes (Nat.le_trans
          (le_total_of_mem (q := fun f => (flow σ ρ P d g o).take t f (.node x)) present)
          (Nat.le_of_eq (taken_node t x sumd)))) with
      | ⟨_, _, pos⟩ => .inl (total_pos_of_read rfl pos)
    | .node x, .inr gives =>
      match readAt_pos (Nat.lt_of_lt_of_le gives (Nat.le_trans
          (le_total_of_mem (q := fun f => (flow σ ρ P d g o).give t f (.node x)) present)
          (Nat.le_of_eq (given_node t x sumg)))) with
      | ⟨_, _, pos⟩ => .inr (.inl (total_pos_of_read rfl pos)),
   fun moved => match moved with
    | .inl taken => Flow.exchangesAt_of_uptake (cs := family ρ P o t)
        (Nat.lt_of_lt_of_le taken (Nat.le_of_eq (uptake_family links sumd).symm))
    | .inr (.inl given) => Flow.exchangesAt_of_replenishment (cs := family ρ P o t)
        (Nat.lt_of_lt_of_le given (Nat.le_of_eq (replenishment_family links sumg).symm))
    | .inr (.inr h) => ⟨.outer, .beyond t h, outer_mem t,
        .inl (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (hit_self t).symm))⟩⟩

/-- **What the chain witness shows across a step.** -/
theorem shows {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given) :
    Distinct ((world σ ρ P d g o).flow.present t) ∧
      (world σ ρ P d g o).flow.RealizesGivers (world σ ρ P d g o).web t
        ((family ρ P o t).map .inr) (P t) (count (d t) fun y => y) (count (g t) fun y => y)
        (0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t) :=
  ⟨(flow σ ρ P d g o).roles_distinct (distinct_present t),
   Flow.RealizesGivers.roles ⟨⟨passages links sumd sumg, takers_family links sumd,
     exchangesAt_iff links sumd sumg⟩, renewers_family links sumg⟩⟩

/-! ### The conditions at one step -/

theorem balancesOn {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given)
    (balanced : ∀ p, p ∈ P t → p.Balanced) :
    (flow σ ρ P d g o).BalancesOn (web σ ρ P o) (family ρ P o t) t :=
  fun _ mem => match of_mem_family mem with
  | ⟨j, lt, same⟩ => Eq.subst (motive := fun c => Passage.Balanced
        ((flow σ ρ P d g o).passage (web σ ρ P o) t c)) same.symm
      (Eq.subst (motive := Passage.Balanced) (passage_member links sumd sumg j).symm
        (balanced _ (pick_mem (P t) j lt)))

theorem dissipatesOn {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given)
    (shares : ∀ a, entry (g t) a + sign (entry (d t) a) ≤ entry (d t) a) :
    (flow σ ρ P d g o).DissipatesOn (family ρ P o t) t := fun f _ =>
  match f with
  | .numbered a => Eq.subst (motive := fun y => total (family ρ P o t)
          ((flow σ ρ P d g o).give t (.numbered a)) + sign y ≤ y) (take_family links sumd a).symm
      (Eq.subst (motive := fun y => y + sign (entry (d t) a) ≤ entry (d t) a)
        (give_family links sumg a).symm (shares a))
  | .outer => Nat.le_of_eq ((congr (congrArg (· + ·) (give_family_outer t))
      (congrArg sign (take_family_outer t))).trans (take_family_outer t).symm)

theorem capacityAt {t : Nat} (sumg : total (g t) (fun y => y) = total (P t) Passage.given)
    {cap : Nat} (bounded : ∀ a, entry (g t) a ≤ cap) :
    (flow σ ρ P d g o).CapacityAt (family ρ P o t) t cap := fun f _ =>
  match f with
  | .numbered a => Nat.le_trans (Nat.le_of_eq (give_family links sumg a)) (bounded a)
  | .outer => Nat.le_trans (Nat.le_of_eq (give_family_outer t)) (Nat.zero_le cap)

omit links in
theorem actingAt (t : Nat) : (flow σ ρ P d g o).ActingAt (web σ ρ P o) t :=
  fun _ _ _ _ => trivial

omit links in
theorem takingAt (t : Nat) : (flow σ ρ P d g o).TakingAt (web σ ρ P o) t :=
  fun _ _ _ _ => ⟨trivial, trivial⟩

theorem cellAt_outside {x : Nat × Nat} {t : Nat}
    (outside : ¬ (Site.node x : Site o) ∈ family ρ P o t) (dd : List Nat) (q : Passage → Nat)
    (a : Nat) : ∀ oo, track σ ρ x t = oo → cellAt dd ((P t).map q) a oo = 0
  | none, _ => rfl
  | some j, tracked => match Nat.lt_or_ge j (P t).length with
    | .inl lt => absurd (node_mem links tracked lt) outside
    | .inr ge => cell_beyond dd (Nat.le_trans (Nat.le_of_eq (length_map _ _)) ge) a

/-- Where `o` fails at the step, the family is closed across it. -/
theorem closedAt {t : Nat} (alone : ¬ o t) :
    (flow σ ρ P d g o).ClosedAt (family ρ P o t) t := fun f _ c outside =>
  match f, c, outside with
  | .numbered a, .node x, outside =>
    ⟨cellAt_outside links outside (d t) Passage.taken a (track σ ρ x t) rfl,
     cellAt_outside links outside (g t) Passage.given a (track σ ρ x t) rfl⟩
  | .numbered _, .beyond _ _, _ => ⟨rfl, rfl⟩
  | .outer, .node _, _ => ⟨rfl, rfl⟩
  | .outer, .beyond s h, _ =>
    ⟨eq_zero_of_not_pos fun pos => alone (Eq.subst (motive := o) (hit_pos s t pos) h),
     eq_zero_of_not_pos fun pos => alone (Eq.subst (motive := o) (hit_pos s t pos) h)⟩

omit links in
theorem beforeAt_pos {Q : List Passage} :
    ∀ {oo : Option Nat}, 0 < beforeAt Q oo → ∃ j, oo = some j ∧ 0 < (pick Q j).before
  | some j, pos => ⟨j, rfl, pos⟩
  | none, pos => absurd pos (Nat.lt_irrefl 0)

/-- What stands before the first step is in its family. -/
theorem stands_before_zero {c : Site o} (pos : 0 < (web σ ρ P o).level 0 c) :
    c ∈ family ρ P o 0 :=
  match c, pos with
  | .node _, pos => match beforeAt_pos pos with
    | ⟨j, tracked, stands⟩ => node_mem links tracked (pick_lt (q := Passage.before) rfl _ j stands)
  | .beyond _ _, pos => absurd pos (Nat.lt_irrefl 0)

theorem stands_before_step {s : Nat} {x : Nat × Nat}
    (onward : ∀ i, 0 < (pick (P s) i).after → ∃ j, σ s i = some j) :
    ∀ oo, track σ ρ x s = oo →
      0 < afterAt (P s) (beforeAt (P (s + 1)) (track σ ρ x (s + 1))) oo →
      (Site.node x : Site o) ∈ family ρ P o (s + 1)
  | some i, tracked, pos => match onward i pos with
    | ⟨j, linked⟩ =>
      have next : track σ ρ x (s + 1) = some j :=
        (track_succ σ ρ (tracked_from σ ρ tracked)).trans
          ((congrArg (fun oo => Option.bind oo (σ s)) tracked).trans linked)
      node_mem links next (pick_lt (q := Passage.before) rfl _ j
        (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (links.keeps s i j linked))))
  | none, _, pos => match beforeAt_pos pos with
    | ⟨j, tracked, stands⟩ => node_mem links tracked (pick_lt (q := Passage.before) rfl _ j stands)

/-- What stands before a later step is in its family, where what stands after the step before
leads on. -/
theorem stands_before_succ {s : Nat}
    (onward : ∀ i, 0 < (pick (P s) i).after → ∃ j, σ s i = some j) {c : Site o}
    (pos : 0 < (web σ ρ P o).level (s + 1) c) : c ∈ family ρ P o (s + 1) :=
  match c, pos with
  | .node x, pos => stands_before_step links onward (track σ ρ x s) rfl pos
  | .beyond _ _, pos => absurd pos (Nat.lt_irrefl 0)

theorem stands_after_step {t : Nat} {x : Nat × Nat}
    (backward : ∀ j, 0 < (pick (P (t + 1)) j).before → ∃ i, ρ t j = some i) :
    ∀ oo, track σ ρ x t = oo →
      0 < afterAt (P t) (beforeAt (P (t + 1)) (track σ ρ x (t + 1))) oo →
      (Site.node x : Site o) ∈ family ρ P o t
  | some i, tracked, pos => node_mem links tracked (pick_lt (q := Passage.after) rfl _ i pos)
  | none, untracked, pos => match beforeAt_pos pos with
    | ⟨j, tracked, stands⟩ => match backward j stands with
      | ⟨i, linked⟩ =>
        have born : x = origin ρ t i :=
          (origin_of_track σ ρ links.back tracked).symm.trans
            (congrArg (originStep (origin ρ t) (t + 1) j) linked)
        (none_ne_some (untracked.symm.trans ((congrArg (fun y => track σ ρ y t) born).trans
          (track_origin σ ρ links.forth t i)))).elim

/-- What stands after a step is in its family, where what stands before the next is led to. -/
theorem stands_after {t : Nat}
    (backward : ∀ j, 0 < (pick (P (t + 1)) j).before → ∃ i, ρ t j = some i) {c : Site o}
    (pos : 0 < (web σ ρ P o).level (t + 1) c) : c ∈ family ρ P o t :=
  match c, pos with
  | .node x, pos => stands_after_step links backward (track σ ρ x t) rfl pos
  | .beyond _ _, pos => absurd pos (Nat.lt_irrefl 0)

/-- Whatever stands before a step is in its family, where what stands after each step leads
on. -/
theorem stands_before (onward : ∀ s i, 0 < (pick (P s) i).after → ∃ j, σ s i = some j) :
    ∀ t (c : Site o), 0 < (web σ ρ P o).level t c → c ∈ family ρ P o t
  | 0, _, pos => stands_before_zero links pos
  | s + 1, _, pos => stands_before_succ links (onward s) pos

/-- With each passage balanced, each relatum giving at most what it takes less one, and what
stands covered, the family runs down across the step. -/
theorem runsDownOn {t : Nat} (sumd : total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : total (g t) (fun y => y) = total (P t) Passage.given)
    (balanced : ∀ p, p ∈ P t → p.Balanced)
    (shares : ∀ a, entry (g t) a + sign (entry (d t) a) ≤ entry (d t) a)
    (before : ∀ c : Site o, 0 < (web σ ρ P o).level t c → c ∈ family ρ P o t)
    (backward : ∀ j, 0 < (pick (P (t + 1)) j).before → ∃ i, ρ t j = some i) :
    (flow σ ρ P d g o).RunsDownOn (web σ ρ P o) (family ρ P o t) t :=
  ⟨distinct_family links t, before, fun _ pos => stands_after links backward pos,
   balancesOn links sumd sumg balanced, dissipatesOn links sumd sumg shares⟩

omit links

/-! ### Kinds of links -/

/-- No links: each position of each step begins its own chain. -/
def unlinked : Nat → Nat → Option Nat := fun _ _ => none

theorem unlinked_links (P : Nat → List Passage) : Links unlinked unlinked P :=
  ⟨fun _ _ _ h => (none_ne_some h).elim, fun _ _ _ h => (none_ne_some h).elim,
   fun _ _ _ h => (none_ne_some h).elim⟩

/-- Each position leads to the same position at the next step. -/
def identical : Nat → Nat → Option Nat := fun _ i => some i

theorem identical_links (chain : Chained P) : Links identical identical P :=
  ⟨fun _ _ _ h => h.symm, fun _ _ _ h => h.symm,
   fun t i _ h => Eq.subst (motive := fun j => (pick (P t) i).after = (pick (P (t + 1)) j).before)
     (ListTests.some_inj h) (Witness.pick_map (f := Passage.after) (g := Passage.before) rfl (P t) (P (t + 1))
       (chain t) i)⟩

theorem origin_identical : ∀ t j, origin identical t j = (0, j)
  | 0, _ => rfl
  | t + 1, j => origin_identical t j

/-- With identical links, the family is the same at every step. -/
theorem family_identical (chain : Chained P) (t : Nat) :
    family identical P o t = (steps 0 (P 0).length).map fun j => .node (0, j) :=
  Eq.subst (motive := fun m => (steps 0 m).map (fun j => (Site.node (origin identical t j) : Site o))
      = (steps 0 (P 0).length).map fun j => .node (0, j)) (chain.lengths t).symm
    (map_eq_of (fun j => congrArg Site.node (origin_identical t j)) _)

/-- A run showing `P` at its first step and nothing after. -/
def onlyFirst (P : List Passage) : Nat → List Passage
  | 0 => P
  | _ + 1 => []

/-! ### Following the standing from step to step, by level and rank -/

/-- How many passages of `Q` read `v`. -/
def tally (q : Passage → Nat) (Q : List Passage) (v : Nat) : Nat :=
  total Q fun p => hit (q p) v

/-- How many passages of `Q` before position `i` read `v`. -/
def below (q : Passage → Nat) (Q : List Passage) (v i : Nat) : Nat :=
  total (steps 0 i) fun i' => hit (q (pick Q i')) v

def nthStep (rest : Nat → Nat) : Nat → Nat → Nat
  | 0, n => rest n + 1
  | _ + 1, 0 => 0
  | _ + 1, n + 1 => rest n + 1

/-- The position of the passage of `Q` with `n` before it reading `v`, itself reading `v`. -/
def nth (q : Passage → Nat) (v : Nat) : List Passage → Nat → Nat
  | [], _ => 0
  | p :: Q, n => nthStep (nth q v Q) (hit (q p) v) n

/-- A position where a level is positive, none where it is not. -/
def guard : Nat → Nat → Option Nat
  | 0, _ => none
  | _ + 1, j => some j

/-- What stands after step `t` at position `i` leads to the position of the next step that
stands at the same level with as many before it standing so. -/
def rankNext (P : Nat → List Passage) (t i : Nat) : Option Nat :=
  guard (pick (P t) i).after
    (nth Passage.before (pick (P t) i).after (P (t + 1)) (below Passage.after (P t) (pick (P t) i).after i))

/-- And back. -/
def rankPrev (P : Nat → List Passage) (t j : Nat) : Option Nat :=
  guard (pick (P (t + 1)) j).before
    (nth Passage.after (pick (P (t + 1)) j).before (P t)
      (below Passage.before (P (t + 1)) (pick (P (t + 1)) j).before j))

theorem guard_some : ∀ {a j j' : Nat}, guard a j = some j' → 0 < a ∧ j = j'
  | 0, _, _, nothing => (none_ne_some nothing).elim
  | _ + 1, _, _, same => ⟨Nat.succ_pos _, ListTests.some_inj same⟩

theorem guard_pos : ∀ {a : Nat} (j : Nat), 0 < a → guard a j = some j
  | 0, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, _, _ => rfl

theorem below_succ {q : Passage → Nat} {v : Nat} (p : Passage) (Q : List Passage) (i : Nat) :
    below q (p :: Q) v (i + 1) = hit (q p) v + below q Q v i :=
  congrArg (hit (q p) v + ·) (total_steps_shift (fun i' => hit (q (pick (p :: Q) i')) v) 1 0 i)

theorem nth_spec {q : Passage → Nat} {v : Nat} : ∀ (Q : List Passage) (n : Nat),
    n < tally q Q v →
      nth q v Q n < Q.length ∧ q (pick Q (nth q v Q n)) = v ∧ below q Q v (nth q v Q n) = n
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | p :: Q, n, lt => match hit_cases (q p) v with
    | .inl miss =>
      have step : nth q v (p :: Q) n = nth q v Q n + 1 :=
        congrArg (fun h => nthStep (nth q v Q) h n) miss
      match nth_spec Q n (Nat.lt_of_lt_of_le lt (Nat.le_of_eq
          ((congrArg (· + tally q Q v) miss).trans (Nat.zero_add _)))) with
      | ⟨within, reads, ranked⟩ =>
        Eq.subst (motive := fun m => m < (p :: Q).length ∧ q (pick (p :: Q) m) = v ∧
            below q (p :: Q) v m = n) step.symm
          ⟨Nat.succ_lt_succ within, reads, (below_succ p Q _).trans
            ((congrArg (· + below q Q v (nth q v Q n)) miss).trans ((Nat.zero_add _).trans ranked))⟩
    | .inr hits => match n, lt with
      | 0, _ => Eq.subst (motive := fun m => m < (p :: Q).length ∧ q (pick (p :: Q) m) = v ∧
            below q (p :: Q) v m = 0)
          (congrArg (fun h => nthStep (nth q v Q) h 0) hits).symm
          ⟨Nat.succ_pos _, hit_pos _ _ (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq hits.symm)),
           rfl⟩
      | n + 1, lt =>
        have step : nth q v (p :: Q) (n + 1) = nth q v Q n + 1 :=
          congrArg (fun h => nthStep (nth q v Q) h (n + 1)) hits
        match nth_spec Q n (Nat.lt_of_succ_lt_succ (Nat.lt_of_lt_of_le lt (Nat.le_of_eq
            ((congrArg (· + tally q Q v) hits).trans (Nat.add_comm 1 _))))) with
        | ⟨within, reads, ranked⟩ =>
          Eq.subst (motive := fun m => m < (p :: Q).length ∧ q (pick (p :: Q) m) = v ∧
              below q (p :: Q) v m = n + 1) step.symm
            ⟨Nat.succ_lt_succ within, reads, (below_succ p Q _).trans
              ((congrArg (· + below q Q v (nth q v Q n)) hits).trans
                ((Nat.add_comm 1 _).trans (congrArg (· + 1) ranked)))⟩

theorem nth_below {q : Passage → Nat} {v : Nat} : ∀ (Q : List Passage) (i : Nat), i < Q.length →
    q (pick Q i) = v → nth q v Q (below q Q v i) = i
  | [], _, lt, _ => absurd lt (Nat.not_lt_zero _)
  | _ :: Q, 0, _, same => congrArg (fun h => nthStep (nth q v Q) h 0) (hit_of_eq same)
  | p :: Q, i + 1, lt, same =>
    (congrArg (nth q v (p :: Q)) (below_succ p Q i)).trans (match hit_cases (q p) v with
      | .inl miss => (congrArg (fun h => nthStep (nth q v Q) h (h + below q Q v i)) miss).trans
          (congrArg (fun n => nth q v Q n + 1) (Nat.zero_add _) |>.trans
            (congrArg (· + 1) (nth_below Q i (Nat.lt_of_succ_lt_succ lt) same)))
      | .inr hits => (congrArg (fun h => nthStep (nth q v Q) h (h + below q Q v i)) hits).trans
          ((congrArg (nthStep (nth q v Q) 1) (Nat.add_comm 1 _)).trans
            (congrArg (· + 1) (nth_below Q i (Nat.lt_of_succ_lt_succ lt) same))))

theorem below_lt_tally {q : Passage → Nat} {v : Nat} : ∀ (Q : List Passage) (i : Nat),
    i < Q.length → q (pick Q i) = v → below q Q v i < tally q Q v
  | [], _, lt, _ => absurd lt (Nat.not_lt_zero _)
  | _ :: Q, 0, _, same => Nat.lt_of_lt_of_le (Nat.succ_pos 0)
      (Nat.le_trans (Nat.le_of_eq (hit_of_eq same).symm) (Nat.le_add_right _ (tally q Q v)))
  | p :: Q, i + 1, lt, same => Nat.lt_of_le_of_lt (Nat.le_of_eq (below_succ p Q i))
      (Nat.add_lt_add_left (below_lt_tally Q i (Nat.lt_of_succ_lt_succ lt) same) _)

/-- Matching by level and rank goes back where it came from, keeping the level, wherever the
readings tally alike at every positive level. -/
theorem match_back {q q' : Passage → Nat} (idle : q Passage.idle = 0) {Q Q' : List Passage}
    (same : ∀ v, 0 < v → tally q Q v = tally q' Q' v) {i j : Nat}
    (linked : guard (q (pick Q i)) (nth q' (q (pick Q i)) Q' (below q Q (q (pick Q i)) i)) =
      some j) :
    guard (q' (pick Q' j)) (nth q (q' (pick Q' j)) Q (below q' Q' (q' (pick Q' j)) j)) = some i ∧
      q (pick Q i) = q' (pick Q' j) :=
  match guard_some linked with
  | ⟨pos, found⟩ =>
    have lt : i < Q.length := pick_lt idle Q i pos
    have rank : below q Q (q (pick Q i)) i < tally q' Q' (q (pick Q i)) :=
      Nat.lt_of_lt_of_le (below_lt_tally Q i lt rfl) (Nat.le_of_eq (same _ pos))
    match nth_spec Q' _ rank with
    | ⟨_, reads, ranked⟩ =>
      have readsJ : q' (pick Q' j) = q (pick Q i) :=
        Eq.subst (motive := fun m => q' (pick Q' m) = q (pick Q i)) found reads
      have rankedJ : below q' Q' (q (pick Q i)) j = below q Q (q (pick Q i)) i :=
        Eq.subst (motive := fun m => below q' Q' (q (pick Q i)) m = below q Q (q (pick Q i)) i)
          found ranked
      ⟨Eq.subst (motive := fun w => guard w (nth q w Q (below q' Q' w j)) = some i) readsJ.symm
         ((congrArg (fun n => guard (q (pick Q i)) (nth q (q (pick Q i)) Q n)) rankedJ).trans
           ((guard_pos _ pos).trans (congrArg some (nth_below Q i lt rfl)))),
       readsJ.symm⟩

end Chain

/-! ## Continuity of what stands, up to order -/

/-- What stands after each step is what stands before the next, up to order: at every positive
level, as many members stand at it after a step as stand at it before the next. -/
def Continues (P : Nat → List Passage) : Prop :=
  ∀ t v, 0 < v → total (P t) (fun p => Witness.hit p.after v) =
    total (P (t + 1)) (fun p => Witness.hit p.before v)

/-- Passages that follow one another position by position continue. -/
theorem Chained.continues {P : Nat → List Passage} (chain : Chained P) : Continues P :=
  fun t v _ => (total_map Passage.after (fun a => Witness.hit a v) (P t)).symm.trans
    ((congrArg (fun l => total l fun a => Witness.hit a v) (chain t)).trans
      (total_map Passage.before (fun a => Witness.hit a v) (P (t + 1))))

namespace Chain

open Witness (hit hit_pos pick)

/-- With the standing continuing, matching by level and rank links the steps. -/
theorem rank_links {P : Nat → List Passage} (continues : Continues P) :
    Links (rankNext P) (rankPrev P) P :=
  ⟨fun t _ _ linked => (match_back (q := Passage.after) (q' := Passage.before) rfl
      (continues t) linked).1,
   fun t _ _ linked => (match_back (q := Passage.before) (q' := Passage.after) rfl
      (fun v pos => (continues t v pos).symm) linked).1,
   fun t _ _ linked => (match_back (q := Passage.after) (q' := Passage.before) rfl
      (continues t) linked).2⟩

theorem rankNext_onward (P : Nat → List Passage) (s i : Nat) (pos : 0 < (pick (P s) i).after) :
    ∃ j, rankNext P s i = some j :=
  ⟨_, guard_pos _ pos⟩

theorem rankPrev_backward (P : Nat → List Passage) (t j : Nat)
    (pos : 0 < (pick (P (t + 1)) j).before) : ∃ i, rankPrev P t j = some i :=
  ⟨_, guard_pos _ pos⟩

/-- Members of two lists without repetition each holding whatever stands at a level stand at
each positive level alike. -/
theorem covered_tally {X : Type} {lev : X → Nat} {l m : List X} (dl : Distinct l)
    (dm : Distinct m) (inl : ∀ c, 0 < lev c → c ∈ l) (inm : ∀ c, 0 < lev c → c ∈ m) {v : Nat}
    (pos : 0 < v) : total l (fun c => hit (lev c) v) = total m (fun c => hit (lev c) v) :=
  have stands : ∀ c, 0 < hit (lev c) v → 0 < lev c := fun _ h =>
    Eq.subst (motive := (0 < ·)) (hit_pos _ _ h).symm pos
  Nat.le_antisymm (total_le_of_support dl fun c _ h => inm c (stands c h))
    (total_le_of_support dm fun c _ h => inl c (stands c h))

/-! ### Shares -/

theorem pos_or_none {X k x : Nat} (sgn : sign X ≤ k) (none : X = 0 → x = 0) : 0 < k ∨ x = 0 :=
  match k, sgn with
  | 0, sgn => .inr (none (eq_zero_of_not_pos fun pos =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (sign_pos pos) sgn)))
  | _ + 1, _ => .inl (Nat.succ_pos _)

theorem excess_of_zero {X : Nat} (y : Nat) (zero : X = 0) : excess X y = 0 :=
  Eq.subst (motive := fun X => excess X y = 0) zero.symm rfl

/-- Shares taken: `X` over `k` takers. -/
theorem taking_shares {X k : Nat} (sgn : sign X ≤ k) (le : k ≤ X) :
    total (lift [] k (excess X k)) (fun y => y) = X ∧ count (lift [] k (excess X k)) (fun y => y) = k :=
  ⟨(total_lift (Nat.zero_le k) (pos_or_none sgn (excess_of_zero k))).trans
    ((congrArg (· + excess X k) (Nat.zero_add k)).trans (add_excess le)), count_lift [] k _⟩

/-- Shares taken by takers each giving its share of `gl` and taking one more: `X` over `k`. -/
theorem running_shares {X Y k : Nat} {gl : List Nat} (sgn : sign X ≤ k) (glen : gl.length ≤ k)
    (gsum : total gl (fun y => y) = Y) (fall : Y + k ≤ X) :
    total (lift gl k (excess X (Y + k))) (fun y => y) = X ∧
      count (lift gl k (excess X (Y + k))) (fun y => y) = k ∧
      ∀ a, entry gl a + sign (entry (lift gl k (excess X (Y + k))) a) ≤
        entry (lift gl k (excess X (Y + k))) a :=
  ⟨(total_lift glen (pos_or_none sgn (excess_of_zero (Y + k)))).trans
    ((congrArg (fun y => y + k + excess X (Y + k)) gsum).trans (add_excess fall)),
   count_lift gl k _, lift_dissipates glen _⟩

theorem self_le_mul {Y r : Nat} (sgn : sign Y ≤ r) : Y ≤ Y * r :=
  match Y, r, sgn with
  | 0, _, _ => Nat.zero_le _
  | _ + 1, 0, sgn => absurd sgn (Nat.not_succ_le_zero 0)
  | Y + 1, r + 1, _ => Nat.le_trans (Nat.le_of_eq (Nat.mul_one (Y + 1)).symm)
      (Nat.mul_le_mul_left (Y + 1) (Nat.succ_le_succ (Nat.zero_le r)))

/-! ### The witness at its first step -/

/-- The chain witness showing `P` at its first step. -/
def solo (P : List Passage) (d g : List Nat) (o : Prop) : World :=
  world unlinked unlinked (onlyFirst P) (fun _ => d) (fun _ => g) (fun _ => o)

/-- Its family at the first step. -/
def soloFamily (P : List Passage) (o : Prop) : List (Relatum ⊕ Site fun _ => o) :=
  (family unlinked (onlyFirst P) (fun _ => o) 0).map .inr

section Solo

variable {P : List Passage} {d g : List Nat} {o : Prop}
  (sumd : total d (fun y => y) = total P Passage.taken)
  (sumg : total g (fun y => y) = total P Passage.given)

include sumd sumg

theorem solo_shows :
    Distinct ((solo P d g o).flow.present 0) ∧
      (solo P d g o).flow.RealizesGivers (solo P d g o).web 0 (soloFamily P o) P
        (count d fun y => y) (count g fun y => y)
        (0 < total P Passage.taken ∨ 0 < total P Passage.given ∨ o) :=
  shows (σ := unlinked) (ρ := unlinked) (P := onlyFirst P) (d := fun _ => d) (g := fun _ => g)
    (o := fun _ => o) (t := 0) (unlinked_links _) sumd sumg

theorem solo_balancesOn (balanced : ∀ p, p ∈ P → p.Balanced) :
    (solo P d g o).flow.BalancesOn (solo P d g o).web (soloFamily P o) 0 :=
  Flow.BalancesOn.roles (balancesOn (σ := unlinked) (ρ := unlinked) (P := onlyFirst P)
    (d := fun _ => d) (g := fun _ => g) (o := fun _ => o) (t := 0) (unlinked_links _) sumd sumg
    balanced)

theorem solo_runsDownOn (balanced : ∀ p, p ∈ P → p.Balanced)
    (shares : ∀ a, entry g a + sign (entry d a) ≤ entry d a) :
    (solo P d g o).flow.RunsDownOn (solo P d g o).web (soloFamily P o) 0 :=
  Flow.RunsDownOn.roles (runsDownOn (σ := unlinked) (ρ := unlinked) (P := onlyFirst P)
    (d := fun _ => d) (g := fun _ => g) (o := fun _ => o) (t := 0) (unlinked_links _) sumd sumg
    balanced shares (fun _ pos => stands_before_zero (unlinked_links _) pos)
    (fun _ pos => absurd pos (Nat.lt_irrefl 0)))

omit sumd in
theorem solo_capacityAt {cap : Nat} (bounded : ∀ a, entry g a ≤ cap) :
    (solo P d g o).flow.CapacityAt (soloFamily P o) 0 cap :=
  Flow.CapacityAt.roles (capacityAt (σ := unlinked) (ρ := unlinked) (P := onlyFirst P)
    (d := fun _ => d) (g := fun _ => g) (o := fun _ => o) (t := 0) (unlinked_links _) sumg bounded)

end Solo

theorem solo_closedAt (P : List Passage) (d g : List Nat) :
    (solo P d g False).flow.ClosedAt (soloFamily P False) 0 :=
  Flow.ClosedAt.roles (closedAt (σ := unlinked) (ρ := unlinked) (P := onlyFirst P)
    (d := fun _ => d) (g := fun _ => g) (o := fun _ => False) (t := 0) (unlinked_links _) id)

theorem solo_active (P : List Passage) (d g : List Nat) (o : Prop) :
    (solo P d g o).flow.ActingAt (solo P d g o).web 0 ∧
      (solo P d g o).flow.TakingAt (solo P d g o).web 0 :=
  ⟨Flow.ActingAt.roles (actingAt 0), Flow.TakingAt.roles (takingAt 0)⟩

end Chain

/-! ## The givers in the pattern of one step: each condition adds exactly its law -/

/-- Some world shows the pattern with its givers across some step on some family where the
condition holds, listing each relatum taking part once. -/
def RealizedGivers (cond : (w : World) → Nat → List w.Relatum → Prop) (P : List Passage)
    (k r : Nat) (e : Prop) : Prop :=
  ∃ (w : World) (t : Nat) (es : List w.Relatum), cond w t es ∧ Distinct (w.flow.present t) ∧
    w.flow.RealizesGivers w.web t es P k r e

theorem RealizedGivers.weaken {cond cond' : (w : World) → Nat → List w.Relatum → Prop}
    (weaker : ∀ w t es, cond w t es → cond' w t es) {P : List Passage} {k r : Nat} {e : Prop} :
    RealizedGivers cond P k r e → RealizedGivers cond' P k r e
  | ⟨w, t, es, holds, distinct, realizes⟩ => ⟨w, t, es, weaker w t es holds, distinct, realizes⟩

/-- The pattern without its givers is shown exactly when it is shown with some number of
givers. -/
theorem realized_iff_givers (cond : (w : World) → Nat → List w.Relatum → Prop)
    (P : List Passage) (k : Nat) (e : Prop) :
    Realized cond P k e ↔ ∃ r, RealizedGivers cond P k r e :=
  ⟨fun ⟨w, t, es, holds, distinct, realizes⟩ => ⟨_, w, t, es, holds, distinct, realizes, rfl⟩,
   fun ⟨_, w, t, es, holds, distinct, realizes, _⟩ => ⟨w, t, es, holds, distinct, realizes⟩⟩

/-- The chain witness shows a pattern at its first step. -/
theorem Chain.realizedOnce {P : List Passage} {k r : Nat} {e : Prop} {d g : List Nat}
    (sumd : total d (fun y => y) = total P Passage.taken)
    (sumg : total g (fun y => y) = total P Passage.given)
    (countd : count d (fun y => y) = k) (countg : count g (fun y => y) = r) (o : Prop)
    (exchange : (0 < total P Passage.taken ∨ 0 < total P Passage.given ∨ o) ↔ e)
    {cond : (w : World) → Nat → List w.Relatum → Prop}
    (holds : cond (Chain.solo P d g o) 0 (Chain.soloFamily P o)) : RealizedGivers cond P k r e :=
  match Chain.solo_shows (o := o) sumd sumg with
  | ⟨distinct, realizes⟩ => ⟨_, 0, _, holds, distinct,
      ⟨⟨realizes.1.1, realizes.1.2.1.trans countd, realizes.1.2.2.trans exchange⟩,
       realizes.2.trans countg⟩⟩

/-- The open laws, with each giver giving at most `cap`: the witness shows the pattern under the
condition, every relatum active and drawing on what it takes from. -/
theorem Chain.realizedOpen {P : List Passage} {k r : Nat} {e : Prop} (every : Every P k e)
    (givers : Givers P r) {cap : Nat} (capacity : total P Passage.given ≤ cap * r) (o : Prop)
    (exchange : (0 < total P Passage.taken ∨ 0 < total P Passage.given ∨ o) ↔ e)
    {cond : (w : World) → Nat → List w.Relatum → Prop}
    (holds : ∀ d g : List Nat, total d (fun y => y) = total P Passage.taken →
      total g (fun y => y) = total P Passage.given → (∀ a, entry g a ≤ cap) →
      cond (Chain.solo P d g o) 0 (Chain.soloFamily P o)) :
    RealizedGivers cond P k r e :=
  match Chain.taking_shares every.1 every.2.1, Chain.fill_spec cap r _ givers.2 capacity with
  | ⟨sumd, countd⟩, ⟨sumg, countg, bounded⟩ =>
    Chain.realizedOnce sumd sumg countd countg o exchange (holds _ _ sumd sumg bounded)

/-- The running-down laws, with each giver giving at most `cap`. -/
theorem Chain.realizedRunning {P : List Passage} {k r : Nat} {e : Prop} (runs : RunsDown P k e)
    (givers : Givers P r) (fewer : r ≤ k) {cap : Nat}
    (capacity : total P Passage.given ≤ cap * r) (o : Prop)
    (exchange : (0 < total P Passage.taken ∨ 0 < total P Passage.given ∨ o) ↔ e)
    {cond : (w : World) → Nat → List w.Relatum → Prop}
    (holds : ∀ d g : List Nat, total d (fun y => y) = total P Passage.taken →
      total g (fun y => y) = total P Passage.given → (∀ a, entry g a ≤ cap) →
      (∀ a, entry g a + sign (entry d a) ≤ entry d a) →
      cond (Chain.solo P d g o) 0 (Chain.soloFamily P o)) :
    RealizedGivers cond P k r e :=
  match Chain.fill_spec cap r _ givers.2 capacity with
  | ⟨sumg, countg, bounded⟩ =>
    match Chain.running_shares runs.1.1.1
        (Nat.le_trans (Nat.le_of_eq (Chain.fill_length cap _ r)) fewer) sumg
        ((fall_iff_given runs.1.2).mp runs.2) with
    | ⟨sumd, countd, shares⟩ =>
      Chain.realizedOnce sumd sumg countd countg o exchange (holds _ _ sumd sumg bounded shares)

/-- **The givers in the law of every step.** A pattern with its givers is shown by some world
across some step on some family exactly when it satisfies the law of every step and the givers are
at least one where anything is given and at most what is given. -/
theorem every_givers_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun _ _ _ => True) P k r e ↔ Every P k e ∧ Givers P r :=
  ⟨fun ⟨_, _, _, _, _, realizes⟩ => ⟨realizes.1.every, realizes.givers⟩,
   fun ⟨every, givers⟩ => Chain.realizedOpen every givers (Chain.self_le_mul givers.1) e
     (exchange_open every.2.2) fun _ _ _ _ _ => trivial⟩

/-- A pattern with its givers is shown on a family balanced on exactly when it satisfies the law of
balance and the law of the givers. -/
theorem balance_givers_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.BalancesOn w.web es t) P k r e ↔
      Balance P k e ∧ Givers P r :=
  ⟨fun ⟨_, _, _, balances, _, realizes⟩ => ⟨realizes.1.balance balances, realizes.givers⟩,
   fun ⟨⟨every, balanced⟩, givers⟩ => Chain.realizedOpen every givers
     (Chain.self_le_mul givers.1) e (exchange_open every.2.2)
     fun _ _ sumd sumg _ => Chain.solo_balancesOn sumd sumg balanced⟩

/-- **Running down adds that every giver takes.** A pattern with its givers is shown on a family
running down exactly when it satisfies the law of running down and the law of the givers, and the
givers are at most the takers. -/
theorem runsDown_givers_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t) P k r e ↔
      RunsDown P k e ∧ Givers P r ∧ r ≤ k :=
  ⟨fun ⟨_, _, _, runs, _, realizes⟩ =>
    ⟨realizes.1.runsDown runs, realizes.givers, realizes.takers runs.2.2.2.2⟩,
   fun ⟨runs, givers, fewer⟩ => Chain.realizedRunning runs givers fewer
     (Chain.self_le_mul givers.1) e (exchange_open runs.1.1.2.2)
     fun _ _ sumd sumg _ shares => Chain.solo_runsDownOn sumd sumg runs.1.2 shares⟩

/-- A pattern with its givers is shown on a family closed across the step exactly when it satisfies
the law of closure and the law of the givers. -/
theorem closed_givers_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.ClosedAt es t) P k r e ↔ Closed P k e ∧ Givers P r :=
  ⟨fun ⟨_, _, _, closed, _, realizes⟩ => ⟨realizes.1.closed closed, realizes.givers⟩,
   fun ⟨⟨every, inward⟩, givers⟩ => Chain.realizedOpen every givers
     (Chain.self_le_mul givers.1) False (exchange_closed ⟨inward, every.2.2⟩)
     fun _ _ _ _ _ => Chain.solo_closedAt P _ _⟩

/-- A pattern with its givers is shown on a family running down closed exactly when it satisfies the
law of running down closed and the law of the givers, and the givers are at most the takers. -/
theorem runsDownClosed_givers_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k r e ↔
      RunsDownClosed P k e ∧ Givers P r ∧ r ≤ k :=
  ⟨fun ⟨_, _, _, ⟨runs, closed⟩, _, realizes⟩ =>
    ⟨realizes.1.runsDownClosed runs closed, realizes.givers, realizes.takers runs.2.2.2.2⟩,
   fun ⟨⟨runs, inward⟩, givers, fewer⟩ => Chain.realizedRunning runs givers fewer
     (Chain.self_le_mul givers.1) False (exchange_closed ⟨inward, runs.1.1.2.2⟩)
     fun _ _ sumd sumg _ shares => ⟨Chain.solo_runsDownOn sumd sumg runs.1.2 shares,
       Chain.solo_closedAt P _ _⟩⟩

/-! ### With the capacity of each giver -/

/-- **The capacity law is the whole law of capacity.** With each relatum giving the family at
most `cap` across the step, a pattern with its givers is shown exactly when it satisfies the law of
every step, the law of the givers, and what is given is at most `cap` for each giver
(`Flow.CapacityAt.replenishment_le`). -/
theorem every_capacity_iff (cap : Nat) (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.CapacityAt es t cap) P k r e ↔
      Every P k e ∧ Givers P r ∧ total P Passage.given ≤ cap * r :=
  ⟨fun ⟨_, _, _, capacity, _, realizes⟩ =>
    ⟨realizes.1.every, realizes.givers, realizes.capacity capacity⟩,
   fun ⟨every, givers, capacity⟩ => Chain.realizedOpen every givers capacity e
     (exchange_open every.2.2) fun _ _ _ sumg bounded => Chain.solo_capacityAt sumg bounded⟩

theorem balance_capacity_iff (cap : Nat) (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.BalancesOn w.web es t ∧ w.flow.CapacityAt es t cap)
      P k r e ↔ Balance P k e ∧ Givers P r ∧ total P Passage.given ≤ cap * r :=
  ⟨fun ⟨_, _, _, ⟨balances, capacity⟩, _, realizes⟩ =>
    ⟨realizes.1.balance balances, realizes.givers, realizes.capacity capacity⟩,
   fun ⟨⟨every, balanced⟩, givers, capacity⟩ => Chain.realizedOpen every givers capacity e
     (exchange_open every.2.2) fun _ _ sumd sumg bounded =>
       ⟨Chain.solo_balancesOn sumd sumg balanced, Chain.solo_capacityAt sumg bounded⟩⟩

theorem runsDown_capacity_iff (cap : Nat) (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.CapacityAt es t cap)
      P k r e ↔ RunsDown P k e ∧ Givers P r ∧ r ≤ k ∧ total P Passage.given ≤ cap * r :=
  ⟨fun ⟨_, _, _, ⟨runs, capacity⟩, _, realizes⟩ =>
    ⟨realizes.1.runsDown runs, realizes.givers, realizes.takers runs.2.2.2.2,
     realizes.capacity capacity⟩,
   fun ⟨runs, givers, fewer, capacity⟩ => Chain.realizedRunning runs givers fewer capacity e
     (exchange_open runs.1.1.2.2) fun _ _ sumd sumg bounded shares =>
       ⟨Chain.solo_runsDownOn sumd sumg runs.1.2 shares, Chain.solo_capacityAt sumg bounded⟩⟩

theorem closed_capacity_iff (cap : Nat) (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.ClosedAt es t ∧ w.flow.CapacityAt es t cap) P k r e ↔
      Closed P k e ∧ Givers P r ∧ total P Passage.given ≤ cap * r :=
  ⟨fun ⟨_, _, _, ⟨closed, capacity⟩, _, realizes⟩ =>
    ⟨realizes.1.closed closed, realizes.givers, realizes.capacity capacity⟩,
   fun ⟨⟨every, inward⟩, givers, capacity⟩ => Chain.realizedOpen every givers capacity False
     (exchange_closed ⟨inward, every.2.2⟩) fun _ _ _ sumg bounded =>
       ⟨Chain.solo_closedAt P _ _, Chain.solo_capacityAt sumg bounded⟩⟩

theorem runsDownClosed_capacity_iff (cap : Nat) (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => (w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) ∧
      w.flow.CapacityAt es t cap) P k r e ↔
      RunsDownClosed P k e ∧ Givers P r ∧ r ≤ k ∧ total P Passage.given ≤ cap * r :=
  ⟨fun ⟨_, _, _, ⟨⟨runs, closed⟩, capacity⟩, _, realizes⟩ =>
    ⟨realizes.1.runsDownClosed runs closed, realizes.givers, realizes.takers runs.2.2.2.2,
     realizes.capacity capacity⟩,
   fun ⟨⟨runs, inward⟩, givers, fewer, capacity⟩ => Chain.realizedRunning runs givers fewer
     capacity False (exchange_closed ⟨inward, runs.1.1.2.2⟩) fun _ _ sumd sumg bounded shares =>
       ⟨⟨Chain.solo_runsDownOn sumd sumg runs.1.2 shares, Chain.solo_closedAt P _ _⟩,
        Chain.solo_capacityAt sumg bounded⟩⟩

/-! ### With activity -/

/-- **Activity adds no law to the pattern.** With only active relata giving, and only active
relata taking and only from what they draw on, across the step, a pattern with its givers is
shown under each condition exactly when it is shown under the condition alone. -/
theorem every_active_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t _ => w.flow.ActingAt w.web t ∧ w.flow.TakingAt w.web t) P k r e ↔
      Every P k e ∧ Givers P r :=
  ⟨fun realized => (every_givers_iff P k r e).mp (realized.weaken fun _ _ _ _ => trivial),
   fun ⟨every, givers⟩ => Chain.realizedOpen every givers (Chain.self_le_mul givers.1) e
     (exchange_open every.2.2) fun _ _ _ _ _ => Chain.solo_active P _ _ e⟩

theorem balance_active_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.BalancesOn w.web es t ∧ w.flow.ActingAt w.web t ∧
      w.flow.TakingAt w.web t) P k r e ↔ Balance P k e ∧ Givers P r :=
  ⟨fun realized => (balance_givers_iff P k r e).mp (realized.weaken fun _ _ _ holds => holds.1),
   fun ⟨⟨every, balanced⟩, givers⟩ => Chain.realizedOpen every givers
     (Chain.self_le_mul givers.1) e (exchange_open every.2.2)
     fun _ _ sumd sumg _ => ⟨Chain.solo_balancesOn sumd sumg balanced, Chain.solo_active P _ _ e⟩⟩

theorem runsDown_active_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ActingAt w.web t ∧
      w.flow.TakingAt w.web t) P k r e ↔ RunsDown P k e ∧ Givers P r ∧ r ≤ k :=
  ⟨fun realized => (runsDown_givers_iff P k r e).mp (realized.weaken fun _ _ _ holds => holds.1),
   fun ⟨runs, givers, fewer⟩ => Chain.realizedRunning runs givers fewer
     (Chain.self_le_mul givers.1) e (exchange_open runs.1.1.2.2)
     fun _ _ sumd sumg _ shares => ⟨Chain.solo_runsDownOn sumd sumg runs.1.2 shares,
       Chain.solo_active P _ _ e⟩⟩

theorem closed_active_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => w.flow.ClosedAt es t ∧ w.flow.ActingAt w.web t ∧
      w.flow.TakingAt w.web t) P k r e ↔ Closed P k e ∧ Givers P r :=
  ⟨fun realized => (closed_givers_iff P k r e).mp (realized.weaken fun _ _ _ holds => holds.1),
   fun ⟨⟨every, inward⟩, givers⟩ => Chain.realizedOpen every givers
     (Chain.self_le_mul givers.1) False (exchange_closed ⟨inward, every.2.2⟩)
     fun _ _ _ _ _ => ⟨Chain.solo_closedAt P _ _, Chain.solo_active P _ _ False⟩⟩

theorem runsDownClosed_active_iff (P : List Passage) (k r : Nat) (e : Prop) :
    RealizedGivers (fun w t es => (w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) ∧
      w.flow.ActingAt w.web t ∧ w.flow.TakingAt w.web t) P k r e ↔
      RunsDownClosed P k e ∧ Givers P r ∧ r ≤ k :=
  ⟨fun realized => (runsDownClosed_givers_iff P k r e).mp
      (realized.weaken fun _ _ _ holds => holds.1),
   fun ⟨⟨runs, inward⟩, givers, fewer⟩ => Chain.realizedRunning runs givers fewer
     (Chain.self_le_mul givers.1) False (exchange_closed ⟨inward, runs.1.1.2.2⟩)
     fun _ _ sumd sumg _ shares => ⟨⟨Chain.solo_runsDownOn sumd sumg runs.1.2 shares,
       Chain.solo_closedAt P _ _⟩, Chain.solo_active P _ _ False⟩⟩

/-- A property of patterns with their givers that does not tell apart equivalent readings of
whether something exchanges. -/
def RespectsGivers (Q : List Passage → Nat → Nat → Prop → Prop) : Prop :=
  ∀ {P k r e e'}, (e ↔ e') → Q P k r e → Q P k r e'

/-- **No law of one step beyond the law, with the givers.** Where a law is exact for a
condition, a property of patterns with their givers holds of what every step shows where the
condition holds exactly when it holds of every pattern satisfying the law. -/
theorem laws_givers {cond : (w : World) → Nat → List w.Relatum → Prop}
    {Law : List Passage → Nat → Nat → Prop → Prop}
    (exact : ∀ P k r e, RealizedGivers cond P k r e ↔ Law P k r e)
    {Q : List Passage → Nat → Nat → Prop → Prop} (respects : RespectsGivers Q) :
    (∀ (w : World) (t : Nat) (es : List w.Relatum), cond w t es → Distinct (w.flow.present t) →
      Q (es.map (w.flow.passage w.web t)) (w.flow.takers es t) (w.flow.renewers es t)
        (w.flow.ExchangesAt t)) ↔
      ∀ P k r e, Law P k r e → Q P k r e :=
  ⟨fun shown P k r e law => match (exact P k r e).mpr law with
    | ⟨w, t, es, holds, distinct, ⟨passages, takers, exchanges⟩, givers⟩ =>
      respects exchanges (Eq.subst (motive := fun P => Q P k r (w.flow.ExchangesAt t)) passages
        (Eq.subst (motive := fun k => Q (es.map (w.flow.passage w.web t)) k r
          (w.flow.ExchangesAt t)) takers
          (Eq.subst (motive := fun r => Q (es.map (w.flow.passage w.web t)) (w.flow.takers es t) r
            (w.flow.ExchangesAt t)) givers (shown w t es holds distinct)))),
   fun law w t es holds distinct =>
    law _ _ _ _ ((exact _ _ _ _).mp ⟨w, t, es, holds, distinct, ⟨rfl, rfl, Iff.rfl⟩, rfl⟩)⟩

/-! ## Runs with their givers: on one family, and on families chosen step by step -/

/-- Some world shows the run of patterns with their givers across every step on one family where
the condition holds at every step, listing each relatum taking part once. -/
def RunRealizedGivers (cond : (w : World) → Nat → List w.Relatum → Prop) (P : Nat → List Passage)
    (k r : Nat → Nat) (e : Nat → Prop) : Prop :=
  ∃ (w : World) (es : List w.Relatum), ∀ t, cond w t es ∧ Distinct (w.flow.present t) ∧
    w.flow.RealizesGivers w.web t es (P t) (k t) (r t) (e t)

/-- Some world shows the run of patterns with their givers across every step, on a family chosen
at each step where the condition holds, listing each relatum taking part once. -/
def StepRealized (cond : (w : World) → Nat → List w.Relatum → Prop) (P : Nat → List Passage)
    (k r : Nat → Nat) (e : Nat → Prop) : Prop :=
  ∃ (w : World) (es : Nat → List w.Relatum), ∀ t, cond w t (es t) ∧ Distinct (w.flow.present t) ∧
    w.flow.RealizesGivers w.web t (es t) (P t) (k t) (r t) (e t)

section Runs

variable {cond : (w : World) → Nat → List w.Relatum → Prop} {P : Nat → List Passage}
  {k r : Nat → Nat} {e : Nat → Prop}

/-- Forgetting the givers. -/
theorem RunRealizedGivers.run : RunRealizedGivers cond P k r e → RunRealized cond P k e
  | ⟨w, es, holds⟩ => ⟨w, es, fun t => ⟨(holds t).1, (holds t).2.1, (holds t).2.2.1⟩⟩

/-- A run on one family is a run on families chosen step by step. -/
theorem RunRealizedGivers.steps : RunRealizedGivers cond P k r e → StepRealized cond P k r e
  | ⟨w, es, holds⟩ => ⟨w, fun _ => es, holds⟩

/-- **Continuity on families chosen step by step.** Where the condition makes the family of each
step hold what stands before and after it, as running down does, what stands after each step is
what stands before the next, up to order. -/
theorem StepRealized.continues
    (covers : ∀ w t es, cond w t es → w.flow.RunsDownOn w.web es t) :
    StepRealized cond P k r e → Continues P
  | ⟨w, es, holds⟩, t, v, pos =>
    have now := covers w t (es t) (holds t).1
    have next := covers w (t + 1) (es (t + 1)) (holds (t + 1)).1
    ((congrArg (fun l => total l fun p => Witness.hit p.after v) (holds t).2.2.1.1.symm).trans
      (total_map _ _ (es t))).trans
    ((Chain.covered_tally (lev := w.web.level (t + 1)) now.1 next.1 now.2.2.1 next.2.1 pos).trans
      ((total_map _ _ (es (t + 1))).symm.trans
        (congrArg (fun l => total l fun p => Witness.hit p.before v) (holds (t + 1)).2.2.1.1)))

end Runs

namespace Chain

open Witness (pick)

/-- What a linked run's witness shows at every step. -/
theorem showsAll {σ ρ : Nat → Nat → Option Nat} {P : Nat → List Passage} (links : Links σ ρ P)
    {k r : Nat → Nat} {e : Nat → Prop} {d g : Nat → List Nat}
    (sumd : ∀ t, total (d t) (fun y => y) = total (P t) Passage.taken)
    (sumg : ∀ t, total (g t) (fun y => y) = total (P t) Passage.given)
    (countd : ∀ t, count (d t) (fun y => y) = k t) (countg : ∀ t, count (g t) (fun y => y) = r t)
    (o : Nat → Prop)
    (exchange : ∀ t, (0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t) ↔ e t)
    (t : Nat) :
    Distinct ((world σ ρ P d g o).flow.present t) ∧
      (world σ ρ P d g o).flow.RealizesGivers (world σ ρ P d g o).web t
        ((family ρ P o t).map .inr) (P t) (k t) (r t) (e t) :=
  match shows links (d := d) (g := g) (o := o) (t := t) (sumd t) (sumg t) with
  | ⟨distinct, realizes⟩ => ⟨distinct,
      ⟨⟨realizes.1.1, realizes.1.2.1.trans (countd t), realizes.1.2.2.trans (exchange t)⟩,
       realizes.2.trans (countg t)⟩⟩

/-- Shares taken at each step of a run under an open law. -/
def openTaken (P : Nat → List Passage) (k : Nat → Nat) (t : Nat) : List Nat :=
  lift [] (k t) (excess (total (P t) Passage.taken) (k t))

/-- Shares given at each step of a run: what is given, over the givers. -/
def openGiven (P : Nat → List Passage) (r : Nat → Nat) (t : Nat) : List Nat :=
  fill (total (P t) Passage.given) (total (P t) Passage.given) (r t)

/-- Shares taken at each step of a run running down: each giver takes one more than it gives. -/
def runningTaken (P : Nat → List Passage) (k r : Nat → Nat) (t : Nat) : List Nat :=
  lift (openGiven P r t) (k t)
    (excess (total (P t) Passage.taken) (total (P t) Passage.given + k t))

section Shares

variable {P : Nat → List Passage} {k r : Nat → Nat} {e : Nat → Prop}

theorem openTaken_spec (every : ∀ t, Every (P t) (k t) (e t)) (t : Nat) :
    total (openTaken P k t) (fun y => y) = total (P t) Passage.taken ∧
      count (openTaken P k t) (fun y => y) = k t :=
  taking_shares (every t).1 (every t).2.1

theorem openGiven_spec (givers : ∀ t, Givers (P t) (r t)) (t : Nat) :
    total (openGiven P r t) (fun y => y) = total (P t) Passage.given ∧
      count (openGiven P r t) (fun y => y) = r t :=
  match fill_spec _ (r t) _ (givers t).2 (self_le_mul (givers t).1) with
  | ⟨sumg, countg, _⟩ => ⟨sumg, countg⟩

theorem runningTaken_spec (runs : ∀ t, RunsDown (P t) (k t) (e t))
    (givers : ∀ t, Givers (P t) (r t)) (fewer : ∀ t, r t ≤ k t) (t : Nat) :
    total (runningTaken P k r t) (fun y => y) = total (P t) Passage.taken ∧
      count (runningTaken P k r t) (fun y => y) = k t ∧
      ∀ a, entry (openGiven P r t) a + sign (entry (runningTaken P k r t) a) ≤
        entry (runningTaken P k r t) a :=
  running_shares (runs t).1.1.1 (Nat.le_trans (Nat.le_of_eq (fill_length _ _ (r t))) (fewer t))
    (openGiven_spec givers t).1 ((fall_iff_given (runs t).1.2).mp (runs t).2)

end Shares

section Realized

variable {P : Nat → List Passage} {k r : Nat → Nat} {e : Nat → Prop} {d g : Nat → List Nat}
  (sumd : ∀ t, total (d t) (fun y => y) = total (P t) Passage.taken)
  (sumg : ∀ t, total (g t) (fun y => y) = total (P t) Passage.given)
  (countd : ∀ t, count (d t) (fun y => y) = k t) (countg : ∀ t, count (g t) (fun y => y) = r t)
  (o : Nat → Prop)
  (exchange : ∀ t, (0 < total (P t) Passage.taken ∨ 0 < total (P t) Passage.given ∨ o t) ↔ e t)
  {cond : (w : World) → Nat → List w.Relatum → Prop}

include sumd sumg countd countg exchange

/-- The witness of a linked run shows it on the families chosen step by step. -/
theorem realizedSteps {σ ρ : Nat → Nat → Option Nat} (links : Links σ ρ P)
    (holds : ∀ t, cond (world σ ρ P d g o) t ((family ρ P o t).map .inr)) :
    StepRealized cond P k r e :=
  ⟨world σ ρ P d g o, fun t => (family ρ P o t).map .inr, fun t =>
    ⟨holds t, showsAll links sumd sumg countd countg o exchange t⟩⟩

/-- With identical links the family is one family: the witness shows a run whose passages follow
one another on one family. -/
theorem realizedRun (chain : Chained P)
    (holds : ∀ t, cond (world identical identical P d g o) t ((family identical P o t).map .inr)) :
    RunRealizedGivers cond P k r e :=
  ⟨world identical identical P d g o,
   ((steps 0 (P 0).length).map fun j => (Site.node (0, j) : Site o)).map .inr, fun t =>
    Eq.subst (motive := fun l => cond (world identical identical P d g o) t l ∧
        Distinct ((world identical identical P d g o).flow.present t) ∧
        (world identical identical P d g o).flow.RealizesGivers
          (world identical identical P d g o).web t l (P t) (k t) (r t) (e t))
      (congrArg (List.map Sum.inr) (family_identical chain t))
      ⟨holds t, showsAll (identical_links chain) sumd sumg countd countg o exchange t⟩⟩

end Realized

end Chain

section Runs

variable (P : Nat → List Passage) (k r : Nat → Nat) (e : Nat → Prop)

open Chain in
/-- **The law of every step with its givers is all the law of a run.** A run of patterns with
their givers is shown on one family across every step exactly when its passages follow one
another and each step satisfies the law of every step and the law of the givers. -/
theorem run_every_givers_iff :
    RunRealizedGivers (fun _ _ _ => True) P k r e ↔
      Chained P ∧ ∀ t, Every (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun realized => ⟨realized.run.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.every, (holds t).2.2.givers⟩⟩,
   fun ⟨chain, law⟩ =>
    have every := fun t => (law t).1
    have givers := fun t => (law t).2
    realizedRun (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (every t).2.2) chain fun _ => trivial⟩

open Chain in
/-- A run with its givers is shown on one family balanced on across every step exactly when its
passages follow one another and each step satisfies the law of balance and the law of the givers. -/
theorem run_balance_givers_iff :
    RunRealizedGivers (fun w t es => w.flow.BalancesOn w.web es t) P k r e ↔
      Chained P ∧ ∀ t, Balance (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun realized => ⟨realized.run.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.balance (holds t).1, (holds t).2.2.givers⟩⟩,
   fun ⟨chain, law⟩ =>
    have every := fun t => (law t).1.1
    have givers := fun t => (law t).2
    realizedRun (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (every t).2.2) chain fun t =>
        (balancesOn (identical_links chain) (o := e) ((openTaken_spec every t).1)
          ((openGiven_spec givers t).1) (law t).1.2).roles⟩

open Chain in
/-- **Running down on one family, with the givers.** A run with its givers is shown on one family
running down across every step exactly when its passages follow one another and each step satisfies
the law of running down, the law of the givers, and the givers are at most the takers. -/
theorem run_runsDown_givers_iff :
    RunRealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t) P k r e ↔
      Chained P ∧ ∀ t, RunsDown (P t) (k t) (e t) ∧ Givers (P t) (r t) ∧ r t ≤ k t :=
  ⟨fun realized => ⟨realized.run.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.runsDown (holds t).1, (holds t).2.2.givers,
        (holds t).2.2.takers (holds t).1.2.2.2.2⟩⟩,
   fun ⟨chain, law⟩ =>
    have runs := fun t => (law t).1
    have givers := fun t => (law t).2.1
    have spec := runningTaken_spec runs givers fun t => (law t).2.2
    realizedRun (fun t => (spec t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (spec t).2.1) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (runs t).1.1.2.2) chain fun t =>
        (runsDownOn (identical_links chain) (o := e) (spec t).1 (openGiven_spec givers t).1
          (runs t).1.2 (spec t).2.2 (stands_before (identical_links chain) (fun _ i _ => ⟨i, rfl⟩) t)
          fun j _ => ⟨j, rfl⟩).roles⟩

open Chain in
/-- A run with its givers is shown on one family closed across every step exactly when its
passages follow one another and each step satisfies the law of closure and the law of the givers. -/
theorem run_closed_givers_iff :
    RunRealizedGivers (fun w t es => w.flow.ClosedAt es t) P k r e ↔
      Chained P ∧ ∀ t, Closed (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun realized => ⟨realized.run.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.closed (holds t).1, (holds t).2.2.givers⟩⟩,
   fun ⟨chain, law⟩ =>
    have every := fun t => (law t).1.1
    have givers := fun t => (law t).2
    realizedRun (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) (fun _ => False)
      (fun t => exchange_closed ⟨(law t).1.2, (every t).2.2⟩) chain fun t =>
        (closedAt (identical_links chain) (d := openTaken P k) (g := openGiven P r)
          (o := fun _ => False) (t := t) id).roles⟩

open Chain in
/-- A run with its givers is shown on one family running down closed across every step exactly
when its passages follow one another and each step satisfies the law of running down closed, the law
of the givers, and the givers are at most the takers. -/
theorem run_runsDownClosed_givers_iff :
    RunRealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t)
      P k r e ↔ Chained P ∧ ∀ t, RunsDownClosed (P t) (k t) (e t) ∧ Givers (P t) (r t) ∧ r t ≤ k t :=
  ⟨fun realized => ⟨realized.run.chained, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.runsDownClosed (holds t).1.1 (holds t).1.2,
        (holds t).2.2.givers, (holds t).2.2.takers (holds t).1.1.2.2.2.2⟩⟩,
   fun ⟨chain, law⟩ =>
    have runs := fun t => (law t).1.1
    have givers := fun t => (law t).2.1
    have spec := runningTaken_spec runs givers fun t => (law t).2.2
    realizedRun (fun t => (spec t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (spec t).2.1) (fun t => (openGiven_spec givers t).2) (fun _ => False)
      (fun t => exchange_closed ⟨(law t).1.2, (runs t).1.1.2.2⟩) chain fun t =>
        ⟨(runsDownOn (identical_links chain) (o := fun _ => False) (spec t).1
          (openGiven_spec givers t).1 (runs t).1.2 (spec t).2.2
          (stands_before (identical_links chain) (fun _ i _ => ⟨i, rfl⟩) t)
          fun j _ => ⟨j, rfl⟩).roles,
         (closedAt (identical_links chain) (d := runningTaken P k r) (g := openGiven P r)
          (o := fun _ => False) (t := t) id).roles⟩⟩

/-! ### Families chosen step by step -/

open Chain in
/-- **Without a condition holding what stands, nothing joins the steps.** A run with its givers
is shown on families chosen step by step exactly when each step satisfies the law of every step and
the law of the givers: what stands after one step need not be what stands before the next. -/
theorem step_every_iff :
    StepRealized (fun _ _ _ => True) P k r e ↔ ∀ t, Every (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun ⟨_, _, holds⟩ t => ⟨(holds t).2.2.1.every, (holds t).2.2.givers⟩,
   fun law =>
    have every := fun t => (law t).1
    have givers := fun t => (law t).2
    realizedSteps (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (every t).2.2) (unlinked_links P) fun _ => trivial⟩

open Chain in
/-- Balance at each step joins no step to the next either. -/
theorem step_balance_iff :
    StepRealized (fun w t es => w.flow.BalancesOn w.web es t) P k r e ↔
      ∀ t, Balance (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun ⟨_, _, holds⟩ t => ⟨(holds t).2.2.1.balance (holds t).1, (holds t).2.2.givers⟩,
   fun law =>
    have every := fun t => (law t).1.1
    have givers := fun t => (law t).2
    realizedSteps (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (every t).2.2) (unlinked_links P) fun t =>
        (balancesOn (unlinked_links P) (o := e) ((openTaken_spec every t).1)
          ((openGiven_spec givers t).1) (law t).1.2).roles⟩

open Chain in
/-- Nor does closure. -/
theorem step_closed_iff :
    StepRealized (fun w t es => w.flow.ClosedAt es t) P k r e ↔
      ∀ t, Closed (P t) (k t) (e t) ∧ Givers (P t) (r t) :=
  ⟨fun ⟨_, _, holds⟩ t => ⟨(holds t).2.2.1.closed (holds t).1, (holds t).2.2.givers⟩,
   fun law =>
    have every := fun t => (law t).1.1
    have givers := fun t => (law t).2
    realizedSteps (fun t => (openTaken_spec every t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (openTaken_spec every t).2) (fun t => (openGiven_spec givers t).2) (fun _ => False)
      (fun t => exchange_closed ⟨(law t).1.2, (every t).2.2⟩) (unlinked_links P) fun t =>
        (closedAt (unlinked_links P) (d := openTaken P k) (g := openGiven P r)
          (o := fun _ => False) (t := t) id).roles⟩

open Chain in
/-- **Running down on families chosen step by step: continuity up to order replaces following
position by position.** A run with its givers is shown on families chosen step by step, each
running down, exactly when what stands after each step is what stands before the next up to
order (`OneStep.Continues`) and each step satisfies the law of running down, the law of the givers,
and the givers are at most the takers. -/
theorem step_runsDown_iff :
    StepRealized (fun w t es => w.flow.RunsDownOn w.web es t) P k r e ↔
      Continues P ∧ ∀ t, RunsDown (P t) (k t) (e t) ∧ Givers (P t) (r t) ∧ r t ≤ k t :=
  ⟨fun realized => ⟨realized.continues fun _ _ _ runs => runs, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.runsDown (holds t).1, (holds t).2.2.givers,
        (holds t).2.2.takers (holds t).1.2.2.2.2⟩⟩,
   fun ⟨continues, law⟩ =>
    have runs := fun t => (law t).1
    have givers := fun t => (law t).2.1
    have spec := runningTaken_spec runs givers fun t => (law t).2.2
    realizedSteps (fun t => (spec t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (spec t).2.1) (fun t => (openGiven_spec givers t).2) e
      (fun t => exchange_open (runs t).1.1.2.2) (rank_links continues) fun t =>
        (runsDownOn (rank_links continues) (o := e) (spec t).1 (openGiven_spec givers t).1
          (runs t).1.2 (spec t).2.2 (stands_before (rank_links continues) (rankNext_onward P) t)
          (rankPrev_backward P t)).roles⟩

open Chain in
/-- And closed as well. -/
theorem step_runsDownClosed_iff :
    StepRealized (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k r e ↔
      Continues P ∧ ∀ t, RunsDownClosed (P t) (k t) (e t) ∧ Givers (P t) (r t) ∧ r t ≤ k t :=
  ⟨fun realized => ⟨realized.continues fun _ _ _ holds => holds.1, match realized with
    | ⟨_, _, holds⟩ => fun t => ⟨(holds t).2.2.1.runsDownClosed (holds t).1.1 (holds t).1.2,
        (holds t).2.2.givers, (holds t).2.2.takers (holds t).1.1.2.2.2.2⟩⟩,
   fun ⟨continues, law⟩ =>
    have runs := fun t => (law t).1.1
    have givers := fun t => (law t).2.1
    have spec := runningTaken_spec runs givers fun t => (law t).2.2
    realizedSteps (fun t => (spec t).1) (fun t => (openGiven_spec givers t).1)
      (fun t => (spec t).2.1) (fun t => (openGiven_spec givers t).2) (fun _ => False)
      (fun t => exchange_closed ⟨(law t).1.2, (runs t).1.1.2.2⟩) (rank_links continues) fun t =>
        ⟨(runsDownOn (rank_links continues) (o := fun _ => False) (spec t).1
          (openGiven_spec givers t).1 (runs t).1.2 (spec t).2.2
          (stands_before (rank_links continues) (rankNext_onward P) t)
          (rankPrev_backward P t)).roles,
         (closedAt (rank_links continues) (d := runningTaken P k r) (g := openGiven P r)
          (o := fun _ => False) (t := t) id).roles⟩⟩

end Runs

/-! ### The pattern without its givers, on families chosen step by step -/

/-- Some world shows the run of patterns across every step, on a family chosen at each step
where the condition holds, listing each relatum taking part once. -/
def StepRunRealized (cond : (w : World) → Nat → List w.Relatum → Prop) (P : Nat → List Passage)
    (k : Nat → Nat) (e : Nat → Prop) : Prop :=
  ∃ (w : World) (es : Nat → List w.Relatum), ∀ t, cond w t (es t) ∧ Distinct (w.flow.present t) ∧
    w.flow.Realizes w.web t (es t) (P t) (k t) (e t)

section StepRuns

variable {cond : (w : World) → Nat → List w.Relatum → Prop} {P : Nat → List Passage}
  {k : Nat → Nat} {e : Nat → Prop}

/-- Without the givers the run is shown exactly when it is shown with some count of givers. -/
theorem stepRun_iff_givers : StepRunRealized cond P k e ↔ ∃ r, StepRealized cond P k r e :=
  ⟨fun ⟨w, es, holds⟩ => ⟨fun t => w.flow.renewers (es t) t, w, es, fun t =>
      ⟨(holds t).1, (holds t).2.1, (holds t).2.2, rfl⟩⟩,
   fun ⟨_, w, es, holds⟩ => ⟨w, es, fun t => ⟨(holds t).1, (holds t).2.1, (holds t).2.2.1⟩⟩⟩

theorem givers_sign (Q : List Passage) : Givers Q (sign (total Q Passage.given)) :=
  ⟨Nat.le_refl _, sign_le _⟩

/-- Running down, something given is something taken: the givers counted once each where
anything is given are at most the takers. -/
theorem RunsDown.sign_given_le {Q : List Passage} {k' : Nat} {e' : Prop} (runs : RunsDown Q k' e') :
    sign (total Q Passage.given) ≤ k' :=
  Nat.le_trans (sign_le_of_pos fun pos => Nat.lt_of_lt_of_le pos (Nat.le_trans
      (Nat.le_add_right _ k') ((fall_iff_given runs.1.2).mp runs.2))) runs.1.1.1

/-- **Running down on families chosen step by step, without the givers.** A run is shown on
families chosen step by step, each running down, exactly when what stands continues up to order
and each step satisfies the law of running down. -/
theorem stepRun_runsDown_iff :
    StepRunRealized (fun w t es => w.flow.RunsDownOn w.web es t) P k e ↔
      Continues P ∧ ∀ t, RunsDown (P t) (k t) (e t) :=
  stepRun_iff_givers.trans
    ⟨fun ⟨_, realized⟩ => match (step_runsDown_iff P k _ e).mp realized with
      | ⟨continues, law⟩ => ⟨continues, fun t => (law t).1⟩,
     fun ⟨continues, law⟩ => ⟨_, (step_runsDown_iff P k (fun t => sign (total (P t) Passage.given))
        e).mpr ⟨continues, fun t => ⟨law t, givers_sign _, (law t).sign_given_le⟩⟩⟩⟩

theorem stepRun_runsDownClosed_iff :
    StepRunRealized (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k e ↔
      Continues P ∧ ∀ t, RunsDownClosed (P t) (k t) (e t) :=
  stepRun_iff_givers.trans
    ⟨fun ⟨_, realized⟩ => match (step_runsDownClosed_iff P k _ e).mp realized with
      | ⟨continues, law⟩ => ⟨continues, fun t => (law t).1⟩,
     fun ⟨continues, law⟩ => ⟨_, (step_runsDownClosed_iff P k
        (fun t => sign (total (P t) Passage.given)) e).mpr
        ⟨continues, fun t => ⟨law t, givers_sign _, (law t).1.sign_given_le⟩⟩⟩⟩

/-- Under balance alone, a run is shown on families chosen step by step exactly when each step
satisfies the law of balance. -/
theorem stepRun_balance_iff :
    StepRunRealized (fun w t es => w.flow.BalancesOn w.web es t) P k e ↔
      ∀ t, Balance (P t) (k t) (e t) :=
  stepRun_iff_givers.trans
    ⟨fun ⟨_, realized⟩ t => ((step_balance_iff P k _ e).mp realized t).1,
     fun law => ⟨_, (step_balance_iff P k (fun t => sign (total (P t) Passage.given)) e).mpr
        fun t => ⟨law t, givers_sign _⟩⟩⟩

end StepRuns

/-! ### Continuity up to order is weaker than following position by position -/

/-- Two conditions standing at one and two, idle, listed in one order before the first step and
in the other ever after. -/
def swapped : Nat → List Passage
  | 0 => [⟨1, 1, 0, 0⟩, ⟨2, 2, 0, 0⟩]
  | _ + 1 => [⟨2, 2, 0, 0⟩, ⟨1, 1, 0, 0⟩]

theorem swapped_continues : Continues swapped
  | 0, v, _ => show Witness.hit 1 v + (Witness.hit 2 v + 0) = Witness.hit 2 v + (Witness.hit 1 v + 0)
      from (congrArg (Witness.hit 1 v + ·) (Nat.add_zero _)).trans ((Nat.add_comm _ _).trans
        (congrArg (Witness.hit 2 v + ·) (Nat.add_zero _).symm))
  | _ + 1, _, _ => rfl

theorem swapped_runsDown (t : Nat) :
    RunsDown (swapped t) 0 False ∧ Givers (swapped t) 0 ∧ 0 ≤ 0 :=
  have idle : ∀ p, p ∈ swapped t → p.Balanced := match t with
    | 0 => fun _ mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := Passage.Balanced) same.symm rfl
      | .inr mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Passage.Balanced) same.symm rfl
        | .inr nothing => nomatch nothing
    | _ + 1 => fun _ mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := Passage.Balanced) same.symm rfl
      | .inr mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Passage.Balanced) same.symm rfl
        | .inr nothing => nomatch nothing
  have quiet : total (swapped t) Passage.taken = 0 ∧ total (swapped t) Passage.given = 0 ∧
      total (swapped t) Passage.after = total (swapped t) Passage.before := match t with
    | 0 => ⟨rfl, rfl, rfl⟩
    | _ + 1 => ⟨rfl, rfl, rfl⟩
  ⟨⟨⟨⟨Nat.le_of_eq (congrArg sign quiet.1), Nat.zero_le _, fun moved => match moved with
        | .inl taken => absurd (Nat.lt_of_lt_of_le taken (Nat.le_of_eq quiet.1)) (Nat.lt_irrefl 0)
        | .inr given => absurd (Nat.lt_of_lt_of_le given (Nat.le_of_eq quiet.2.1))
            (Nat.lt_irrefl 0)⟩, idle⟩, Nat.le_of_eq quiet.2.2⟩,
   ⟨Nat.le_of_eq (congrArg sign quiet.2.1), Nat.zero_le _⟩, Nat.le_refl 0⟩

/-- **Continuity up to order is weaker.** Two idle conditions listed in one order at the first
step and in the other after it: the run is shown on families chosen step by step, each running
down, and on no single family running down, since its passages do not follow one another
position by position. -/
theorem steps_not_run :
    StepRealized (fun w t es => w.flow.RunsDownOn w.web es t) swapped (fun _ => 0) (fun _ => 0)
        (fun _ => False) ∧
      ¬ RunRealizedGivers (fun w t es => w.flow.RunsDownOn w.web es t) swapped (fun _ => 0)
        (fun _ => 0) (fun _ => False) :=
  ⟨(step_runsDown_iff _ _ _ _).mpr ⟨swapped_continues, swapped_runsDown⟩,
   fun realized => Nat.ne_of_lt (Nat.lt_succ_self 1)
     (congrArg Witness.first (((run_runsDown_givers_iff _ _ _ _).mp realized).1 0))⟩

/-- **Continuity is needed where what stands is held.** A condition standing at one before the
first step and at one after it, gone from the list after: each step satisfies the law of running
down, and balance shows the run on families chosen step by step, but no world shows it on
families each running down, since what stands after the first step is not what stands before the
next. -/
def vanishing : Nat → List Passage
  | 0 => [⟨1, 1, 0, 0⟩]
  | _ + 1 => []

theorem vanishing_not_continues : ¬ Continues vanishing :=
  fun continues => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.succ_pos 0)
    (Nat.le_of_eq (continues 0 1 (Nat.succ_pos 0))))

theorem vanishing_steps :
    StepRealized (fun w t es => w.flow.BalancesOn w.web es t) vanishing (fun _ => 0) (fun _ => 0)
        (fun _ => False) ∧
      ¬ StepRealized (fun w t es => w.flow.RunsDownOn w.web es t) vanishing (fun _ => 0)
        (fun _ => 0) (fun _ => False) :=
  have quiet : ∀ t, total (vanishing t) Passage.taken = 0 ∧ total (vanishing t) Passage.given = 0 :=
    fun t => match t with
    | 0 => ⟨rfl, rfl⟩
    | _ + 1 => ⟨rfl, rfl⟩
  ⟨(step_balance_iff _ _ _ _).mpr fun t =>
    ⟨⟨⟨Nat.le_of_eq (congrArg sign (quiet t).1), Nat.zero_le _, fun moved => match moved with
        | .inl taken => absurd (Nat.lt_of_lt_of_le taken (Nat.le_of_eq (quiet t).1))
            (Nat.lt_irrefl 0)
        | .inr given => absurd (Nat.lt_of_lt_of_le given (Nat.le_of_eq (quiet t).2))
            (Nat.lt_irrefl 0)⟩,
      match t with
      | 0 => fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Passage.Balanced) same.symm rfl
        | .inr nothing => nomatch nothing
      | _ + 1 => fun _ nothing => nomatch nothing⟩,
     ⟨Nat.le_of_eq (congrArg sign (quiet t).2), Nat.zero_le _⟩⟩,
   fun realized => vanishing_not_continues ((step_runsDown_iff _ _ _ _).mp realized).1⟩

end OneStep

end Becoming

section PassageWorlds

/-!
## Passage worlds: what the stated laws of one step and the following of passages give of worlds

`Becoming.OneStep` reads what a step of a flow shows of a condition as its passage
(`Flow.passage`), states the law of a family running down closed on a pattern of passages
(`OneStep.RunsDownClosed`), shows that the laws of one step as `Becoming.Locality` states them,
with the law that something taken has a taker, are that whole law
(`OneStep.runsDownClosed_iff_stated`), and that passages following one another position by
position continue up to order (`OneStep.Chained.continues`). A pattern is shown by a world when some step of its flow on some
family shows it (`OneStep.Realized`, `OneStep.RunRealized`). This section states those laws of the
steps of flows and of the worlds showing patterns, and proves them through the laws of patterns.

* **The stated laws are the whole law of a world's step.** A pattern is shown by some world across
  some step on a family running down closed exactly when it satisfies the stated laws and the law that
  something taken has a taker (`runsDownClosed_realized_iff`). Across a step of a flow at which a
  family runs down closed, the pattern the step shows satisfies the stated laws
  (`stated_of_runsDownClosed`).
* **What a flow shows on one family continues.** The passages a flow shows on one family across
  every step continue, at every positive level, as many members standing at it after each step as
  before the next (`passages_continue`); so does every run of patterns some world shows on one
  family (`RunRealized.continues`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace PassageWorlds

open OneStep

variable {F C : Type}

/-- **The stated laws with the taker law are the whole law of a world's step.** A pattern of
passages, takers and exchange is shown by some world across some step on a family running down
closed, listing each relatum taking part once, exactly when it satisfies the laws of one step as
`Becoming.Locality` states them together with the law that something taken from the family has a
relatum taking it. -/
theorem runsDownClosed_realized_iff (P : List Passage) (k : Nat) (e : Prop) :
    Realized (fun w t es => w.flow.RunsDownOn w.web es t ∧ w.flow.ClosedAt es t) P k e ↔
      Stated P k e ∧ sign (total P Passage.taken) ≤ k :=
  (runsDownClosed_iff P k e).trans (runsDownClosed_iff_stated P k e)

/-- **A flow's step running down closed satisfies the stated laws.** Across a step at which a family
runs down and is closed, the passages of its members, the number of relata taking from it and
whether something exchanges satisfy the laws of one step as `Becoming.Locality` states them. -/
theorem stated_of_runsDownClosed {L : Flow F C} {W : Web F C} {es : List C} {t : Nat}
    (runs : L.RunsDownOn W es t) (closed : L.ClosedAt es t) :
    Stated (es.map (L.passage W t)) (L.takers es t) (L.ExchangesAt t) :=
  ((runsDownClosed_iff_stated _ _ _).mp
    (Flow.Realizes.runsDownClosed ⟨rfl, rfl, Iff.rfl⟩ runs closed)).1

/-- **What a flow shows on one family continues.** Across every step, what stands after it at
each member of the family is what stands before the next step there, so at every positive level as
many members stand at it after each step as before the next. -/
theorem passages_continue (L : Flow F C) (W : Web F C) (es : List C) :
    Continues fun t => es.map (L.passage W t) :=
  Chained.continues fun t =>
    (map_comp_eq (L.passage W t) Passage.after es).trans
      (map_comp_eq (L.passage W (t + 1)) Passage.before es).symm

/-- **Every run some world shows on one family continues.** -/
theorem RunRealized.continues {cond : (w : World) → Nat → List w.Relatum → Prop}
    {P : Nat → List Passage} {k : Nat → Nat} {e : Nat → Prop}
    (realized : RunRealized cond P k e) : Continues P :=
  realized.chained.continues

end PassageWorlds

end Becoming

end PassageWorlds
