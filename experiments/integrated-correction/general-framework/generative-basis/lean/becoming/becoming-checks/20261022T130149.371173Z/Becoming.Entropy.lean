import Becoming.Resolution
import Becoming.Recurrence
import Becoming.Witnesses

/-!
# Entropy: what becoming leaves, and what holding it costs

Every change of a level is an exchange, so becoming leaves a history. This module asks
whether an exchange can lose nothing, where the spine's least loss per exchange
(`Flow.DissipatesOn`) comes from, and what never decreases.

* **The history, with no premise.** In a balanced flow every change of a member's level is
  an exchange with the family (`Flow.Balances.exchanges_of_change`). The history of the
  family's exchanges since `T` (`Flow.exchangeCount`) never shrinks (`Flow.history_mono`) and
  grows at every step at which anything is exchanged with it. An exchange and its reverse
  (`Flow.Reverses`: the same formations, each taking what it gave and giving what it took)
  restore every level, and the history counts both
  (`Flow.Balances.restores_levels_not_history`).
* **Zero loss.** Nothing from nothing (`Flow.Gainless`: every closed family without
  repetition gets back at most what is taken from it) and losing nothing
  (`Flow.Conserving`) are the first law at a fixed unit; dissipation is the first law with a
  least loss (`Flow.Dissipative.gainless`). Under the first law the reverse of an exchange
  is within the law exactly where the exchange loses nothing
  (`Flow.Reverses.gainlessOn_iff`); under dissipation no exchange is reversed
  (`Flow.Dissipative.irreversible`). Zero loss is possible: in `Passing` a carrier hands
  one unit back and forth between two sides; the world is finite, balanced, lossless and
  enclosed, each exchange is reversed across the next step, arising and ceasing recur,
  and the history grows by one at every step without end (`Passing.passes`,
  `Passing.history_grows`).
* **The least loss is a record held in the conserved amount.** Count the record of the
  exchanges as one more condition, given to by every formation taking part and taken from
  by none (`Flow.withRecord`, `Web.withRecord`); with it the flow balances exactly where it
  balances (`Flow.balances_withRecord`), and so at each step on each family
  (`Flow.balancesOn_withRecord`). A flow dissipates on a family across a step
  exactly where, with some record counted, every exchange conserves the family with its
  record exactly and leaves the record at least one unit
  (`Flow.dissipatesOn_iff_conserved`), and exactly where, with each exchange recorded at
  one unit, the family with its record gains nothing (`Flow.dissipatesOn_iff_unitRecord`,
  `Flow.dissipatesOn_iff_recorded`, `Flow.Dissipative.of_recorded`). Both parts are needed:
  recording nothing, the family with its record gains nothing but the record misses every
  exchange; recording one unit for each, the record holds every exchange but the family
  with it gains (`Passing.record_needs_both`). This decomposes the least loss; it does not
  derive it: given the first law, that each exchange leaves a record of at least one unit
  within the conserved amount is exactly the strict part of dissipation.
* **The amount dissipated.** What the family loses across a step (`Flow.lost`), summed
  since `T` (`Flow.dissipated`), never falls (`Flow.dissipated_mono`); under the first law
  the stock with it is conserved (`Flow.Balances.stock_dissipated`), and it is exactly what
  the record receives (`Flow.GainlessOn.residues_lost`). Dissipated on, it rises across a
  step by at least the formations taking from the family
  (`Flow.DissipatesOn.dissipated_rises`), and the history is within it, which is within
  the stock (`Flow.Balances.history_within`); losing nothing, nothing is dissipated
  (`Flow.dissipated_zero`). Under the first law loss does not recur
  (`Flow.Balances.loss_ceases`). Dissipated on in proportion `q` (`Flow.DissipatesBy` of
  `Becoming.Resolution`), what is taken is at most `q + 1` times what is lost
  (`Flow.DissipatesBy.uptake_le_lost`), so over any stretch everything taken is at most
  `q + 1` times the amount dissipated (`Flow.uptake_within_dissipated`).
* **Revisiting and the count of configurations.** Under the first law the family's
  configuration (`Web.config`, the level of each member) stays among the configurations
  totalling at most its stock at `T` (`configurationsWithin`), and losing nothing, among
  those totalling exactly that stock: `configurations n K` lists each way `K` units fall
  into `n` members exactly once (`configurations_exact`, `configurations_examples`). A
  family that never revisits a configuration (`Web.Revisits`) changes across at most that
  many steps (`Flow.Balances.changes_within`, `Flow.Balances.changes_within_conserving`) and
  comes to rest (`Flow.Balances.rests_of_never_revisits`). So under the first law change
  without end revisits (`Flow.Balances.unending_change_revisits`), and in a finite world
  arising without end revisits from every step on (`World.arising_revisits`). Under
  dissipation a family never revisits (`Flow.Balances.never_revisits`,
  `World.never_revisits`). Never revisiting brings rest without the least loss: in
  `Settling` one unit passes once, losing nothing, and the world rests
  (`Entropy.Settling.settles`).
* **No arrow of the levels while change goes on.** A quantity of the configuration that
  never falls and rises across every change (`Web.Arrow`) rules out revisiting
  (`Web.never_revisits_of_arrow`). So under the first law an arrow brings rest
  (`Flow.Balances.rests_of_arrow`), and while change goes on no quantity of the
  configuration is an arrow (`Flow.Balances.no_arrow`, `World.no_arrow`). In `Passing`
  none is (`Passing.no_arrow`) while the history grows: what rises with no premise is the
  history, not a quantity of the levels of a finite enclosure.
* **Holding the history.** Where the configuration carries the history
  (`Flow.CarriesHistory`: some reading of it gives the history), that reading is an arrow
  (`Flow.Balances.arrow_of_carries`), so the family never revisits
  (`Flow.Balances.never_revisits_of_carries`) and, under the first law, exchange with it
  stops within its configurations (`Flow.Balances.exchanges_within_of_carries`,
  `Flow.Balances.exchange_stops_of_carries`). A finite world under the first law that
  keeps exchanging forgets: from no step on does its configuration carry its history
  (`World.forgets`).
* **Merging configurations.** Where the change is a function of the configuration
  (`Web.Determined`), coming to rest after a change sends two configurations taken to the
  same (`Web.merges_of_settles`, `Web.Merges`); no law of the flow is used. Merging none,
  change once begun never stops (`Web.changes_persist`), so under the first law the family
  revisits (`Flow.Balances.revisits_of_apart`). Never revisiting, as under an arrow or
  under dissipation, change that is a function of the configuration merges
  (`Flow.Balances.merges_of_never_revisits`, `Flow.Balances.merges_of_arrow`,
  `Flow.Balances.merges_of_dissipates`). In `Passing` the sides swap, merging nothing
  (`Passing.history_without_arrow`); in `Settling` coming to rest merges, and the level of
  the side receiving the unit is an arrow (`Entropy.Settling.merges`).
* **The laws of change, read on the family.** `Becoming.Recurrence` states what every
  sequence and every determined law keeps, loses and returns to, with no premise. Revisiting
  after a change is revisiting (`Web.Revisits.recurs`), an arrow marks every change
  (`Web.Arrow.marks`), a merge along the family is a merge of the law (`Web.Merges.law`),
  and determined change runs along the law's orbit (`Web.Determined.orbit`). Under the
  first law the configurations stay within one list (`Flow.Balances.held`), so from every
  step on they take one value twice, constructively (`Flow.Balances.recurs`), an arrow
  stops change (`Flow.Balances.arrow_stops`), within that bound a law merging nothing
  brings the start back (`Flow.Balances.returns_of_conserving`; the bound does the work, as
  `Law.succ_open` merges nothing and never returns), the present forgets the kept history
  (`Flow.Balances.present_forgets`), and an arrow or dissipation rules out a law merging
  nothing (`Flow.Balances.not_conserving_of_arrow`, `Flow.Balances.not_conserving_of_dissipates`).
* **What a family gains, graded.** A family's inflow across a step (`Flow.inflow`) is what each
  formation taking part gives it beyond what it takes from it; it is zero exactly where the family
  gains nothing (`Flow.gainlessOn_iff_inflow`). In a balanced flow, across every step, the stock
  after it with what the family loses is the stock before with what it gains
  (`Flow.Balances.stock_gained`), which is at most the inflow (`Flow.gained_le_inflow`,
  `Flow.Balances.stock_inflow`); over a stretch the stock rises by at most the stretch's inflow
  (`Flow.Balances.stock_over_inflow`). `Flow.Balances.stock_lost` is the case of no inflow.
* **An arrow drawn from beyond.** In `Gathering` a record takes one unit from a new relatum
  at every step: every exchange conserves exactly, every step is enclosed, the exchange
  recurs, and the record's level is an arrow without end. The record gains by exchange
  beyond itself, and the world is not finite (`Gathering.gathers`), so the premises that
  the family gains nothing and that the world is finite do work.

So, in a finite enclosure under the first law, zero loss is possible: the configuration
then comes back and the history alone grows. Every rise of a quantity of the
configuration ends in rest; where the change is a function of the configuration, coming
to rest merges two configurations, and a finite world that keeps exchanging cannot hold
its history in its configuration. The least loss is the record of each exchange held in
the conserved amount itself: the first law with that record is the spine's dissipation,
neither derived from less nor replaced by it. An arrow without end under exact
conservation draws on what lies beyond the family. Correspondences to thermodynamics are
readings stated in the study, not physical derivations.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## Gaining nothing, losing nothing, and the reverse -/

namespace Flow

variable (L : Flow F C)

/-- Across the step from `t`, every formation taking part gives the family no more than it
takes from it: no exchange within the family adds to it. -/
def GainlessOn (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → total cs (L.give t f) ≤ total cs (L.take t f)

/-- Across the step from `t`, every formation taking part gives the family exactly what it
takes from it: its exchanges lose nothing. -/
def ConservingOn (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → total cs (L.give t f) = total cs (L.take t f)

/-- Nothing from nothing: across every step, every family without repetition closed across
it gains nothing. -/
def Gainless : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → L.GainlessOn cs t

/-- Across every step, every family without repetition closed across it loses nothing. -/
def Conserving : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → L.ConservingOn cs t

/-- The exchange across the step from `u` reverses the exchange across the step from `t`:
the same formations take part, each taking what it gave and giving what it took. -/
def Reverses (u t : Nat) : Prop :=
  L.present u = L.present t ∧ (∀ f c, L.take u f c = L.give t f c) ∧
    ∀ f c, L.give u f c = L.take t f c

/-- How many formations taking part exchange with the family across the step from `t`,
taking from it or giving to it: the step's entries in the history of the family's
exchanges. -/
def exchanges (cs : List C) (t : Nat) : Nat :=
  count (L.present t) fun f => total cs (L.take t f) + total cs (L.give t f)

variable {L} {W : Web F C} {cs : List C} {t u : Nat}

/-- Dissipated on, a family gains nothing. -/
theorem DissipatesOn.gainlessOn (dissipates : L.DissipatesOn cs t) : L.GainlessOn cs t :=
  fun f present => Nat.le_trans (Nat.le_add_right _ _) (dissipates f present)

theorem Dissipative.gainless (dissipative : L.Dissipative) : L.Gainless :=
  fun cs t distinct closed => (dissipative cs t distinct closed).gainlessOn

theorem ConservingOn.gainlessOn (lossless : L.ConservingOn cs t) : L.GainlessOn cs t :=
  fun f present => Nat.le_of_eq (lossless f present)

theorem Conserving.gainless (lossless : L.Conserving) : L.Gainless :=
  fun cs t distinct closed => (lossless cs t distinct closed).gainlessOn

/-- A number with its sign added is at most itself only where it is zero. -/
theorem eq_zero_of_add_sign_le : ∀ {a : Nat}, a + sign a ≤ a → a = 0
  | 0, _ => rfl
  | a + 1, le => absurd le (Nat.not_succ_le_self (a + 1))

/-- Dissipated on, an exchange that loses nothing exchanges nothing: a formation taking part
that gives the family what it takes from it neither takes nor gives. -/
theorem DissipatesOn.idle_of_conserving (dissipates : L.DissipatesOn cs t) {f : F}
    (present : f ∈ L.present t) (same : total cs (L.give t f) = total cs (L.take t f)) :
    total cs (L.take t f) = 0 ∧ total cs (L.give t f) = 0 :=
  have none : total cs (L.take t f) = 0 := eq_zero_of_add_sign_le
    (Nat.le_trans (Nat.le_of_eq (congrArg (· + sign (total cs (L.take t f))) same.symm))
      (dissipates f present))
  ⟨none, same.trans none⟩

theorem Reverses.mem (rev : L.Reverses u t) {f : F} (present : f ∈ L.present t) :
    f ∈ L.present u :=
  Eq.subst (motive := fun l => f ∈ l) rev.1.symm present

theorem Reverses.mem_back (rev : L.Reverses u t) {f : F} (present : f ∈ L.present u) :
    f ∈ L.present t :=
  Eq.subst (motive := fun l => f ∈ l) rev.1 present

theorem Reverses.take_total (rev : L.Reverses u t) (cs : List C) (f : F) :
    total cs (L.take u f) = total cs (L.give t f) :=
  total_congr (fun c => rev.2.1 f c) cs

theorem Reverses.give_total (rev : L.Reverses u t) (cs : List C) (f : F) :
    total cs (L.give u f) = total cs (L.take t f) :=
  total_congr (fun c => rev.2.2 f c) cs

/-- What the reverse takes from a condition is what the exchange gave it. -/
theorem Reverses.taken (rev : L.Reverses u t) (c : C) : L.taken u c = L.given t c :=
  (congrArg (fun l => total l fun f => L.take u f c) rev.1).trans
    (total_congr (fun f => rev.2.1 f c) (L.present t))

/-- What the reverse gives a condition is what the exchange took from it. -/
theorem Reverses.given (rev : L.Reverses u t) (c : C) : L.given u c = L.taken t c :=
  (congrArg (fun l => total l fun f => L.give u f c) rev.1).trans
    (total_congr (fun f => rev.2.2 f c) (L.present t))

/-- The reverse restores every level: in a balanced flow, where the exchange across the step
from `u` reverses that across the step from `t` and every level at `u` is what it was after
`t`, every level after `u` is what it was at `t`. -/
theorem Balances.reverse_restores (balances : L.Balances W) (rev : L.Reverses u t)
    (same : ∀ c, W.level u c = W.level (t + 1) c) (c : C) : W.level (u + 1) c = W.level t c :=
  add_right_cancel (L.given t c)
    ((congrArg (W.level (u + 1) c + ·) (rev.taken c).symm).trans
      ((balances u c).trans
        ((congr (congrArg (· + ·) (same c)) (rev.given c)).trans (balances t c))))

/-- The reverse of an exchange within a closed family is within it. -/
theorem Reverses.closedAt (rev : L.Reverses u t) (closed : L.ClosedAt cs t) :
    L.ClosedAt cs u :=
  fun f present c out => match closed f (rev.mem_back present) c out with
  | ⟨noTake, noGive⟩ => ⟨(rev.2.1 f c).trans noGive, (rev.2.2 f c).trans noTake⟩

/-- Under the first law the reverse of an exchange is within it exactly where the exchange
loses nothing: an exchange losing nothing is one that can be undone within the law. -/
theorem Reverses.gainlessOn_iff (rev : L.Reverses u t) (gainless : L.GainlessOn cs t) :
    L.GainlessOn cs u ↔ L.ConservingOn cs t :=
  ⟨fun back f present => Nat.le_antisymm (gainless f present)
      (Nat.le_trans (Nat.le_of_eq (rev.give_total cs f).symm)
        (Nat.le_trans (back f (rev.mem present)) (Nat.le_of_eq (rev.take_total cs f)))),
   fun lossless f present => Nat.le_of_eq ((rev.give_total cs f).trans
      ((lossless f (rev.mem_back present)).symm.trans (rev.take_total cs f).symm))⟩

/-- Under dissipation the reverse of an exchange is within it only where nothing is
exchanged. -/
theorem Reverses.idle_of_dissipates (rev : L.Reverses u t) (forth : L.DissipatesOn cs t)
    (back : L.DissipatesOn cs u) {f : F} (present : f ∈ L.present t) :
    total cs (L.take t f) = 0 ∧ total cs (L.give t f) = 0 :=
  forth.idle_of_conserving present
    (((rev.gainlessOn_iff forth.gainlessOn).mp back.gainlessOn) f present)

/-- What passes does not pass back: under dissipation, across a step at which a family
without repetition is closed, no exchange is reversed at any step. -/
theorem Dissipative.irreversible (dissipative : L.Dissipative) (distinct : Distinct cs)
    (closed : L.ClosedAt cs t) (rev : L.Reverses u t) {f : F} (present : f ∈ L.present t)
    {c : C} (exchanges : 0 < L.take t f c ∨ 0 < L.give t f c) : False :=
  match rev.idle_of_dissipates (dissipative cs t distinct closed)
      (dissipative cs u distinct (rev.closedAt closed)) present with
  | ⟨noTake, noGive⟩ =>
    have inside : ¬¬ c ∈ cs := fun out => match closed f present c out with
      | ⟨take0, give0⟩ => match exchanges with
        | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq take0))
        | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq give0))
    inside fun mem => match exchanges with
      | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          (total_pos_of_mem (q := L.take t f) mem takes) (Nat.le_of_eq noTake))
      | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          (total_pos_of_mem (q := L.give t f) mem gives) (Nat.le_of_eq noGive))

/-! ## The history of exchanges -/

/-- A reversed exchange is as many exchanges as the exchange it reverses. -/
theorem Reverses.exchanges_eq (rev : L.Reverses u t) (cs : List C) :
    L.exchanges cs u = L.exchanges cs t :=
  (congrArg (fun l => count l fun f => total cs (L.take u f) + total cs (L.give u f)) rev.1).trans
    (total_congr (p := fun f => sign (total cs (L.take u f) + total cs (L.give u f)))
      (q := fun f => sign (total cs (L.take t f) + total cs (L.give t f)))
      (fun f => congrArg sign ((congr (congrArg (· + ·) (rev.take_total cs f))
        (rev.give_total cs f)).trans (Nat.add_comm _ _))) (L.present t))

/-- Every change of a member's level is an exchange with the family: in a balanced flow,
where a member rises or falls across a step, some formation taking part exchanges with the
family. -/
theorem Balances.exchanges_of_change (balances : L.Balances W) {c : C} (mem : c ∈ cs)
    (changes : W.Rises t c ∨ W.Falls t c) : 0 < L.exchanges cs t :=
  match changes with
  | .inl rises => match total_pos (L.present t) (balances.rise_given rises) with
    | ⟨f, present, gives⟩ =>
      total_pos_of_mem (q := fun f => sign (total cs (L.take t f) + total cs (L.give t f)))
        present (sign_pos (Nat.lt_of_lt_of_le (total_pos_of_mem (q := L.give t f) mem gives)
          (Nat.le_add_left _ _)))
  | .inr falls => match total_pos (L.present t) (balances.fall_taken falls) with
    | ⟨f, present, takes⟩ =>
      total_pos_of_mem (q := fun f => sign (total cs (L.take t f) + total cs (L.give t f)))
        present (sign_pos (Nat.lt_of_lt_of_le (total_pos_of_mem (q := L.take t f) mem takes)
          (Nat.le_add_right _ _)))

/-- A change and its reverse restore every level, not the history: in a balanced flow in
which the exchange across the step from `t + 1` reverses that across the step from `t`,
every level after both is what it was at `t`, while the exchanges with any family across the
two steps are twice those across the first. -/
theorem Balances.restores_levels_not_history (balances : L.Balances W)
    (rev : L.Reverses (t + 1) t) (cs : List C) :
    (∀ c, W.level (t + 2) c = W.level t c) ∧
      total (steps t 2) (L.exchanges cs) = 2 * L.exchanges cs t :=
  ⟨balances.reverse_restores rev fun _ => rfl,
   (congrArg (L.exchanges cs t + ·) ((Nat.add_zero _).trans (rev.exchanges_eq cs))).trans
     (Nat.two_mul _).symm⟩

/-! ## The record counted -/

/-- The flow with the record of each exchange counted: the record is one more condition,
`none`; across the step from `t` each formation taking part gives it `ρ t f`, and nothing
takes from it. The flow's own conditions are the others. -/
def withRecord (L : Flow F C) (ρ : Nat → F → Nat) : Flow F (Option C) :=
  ⟨L.present,
   fun t f c => match c with
     | none => 0
     | some d => L.take t f d,
   fun t f c => match c with
     | none => ρ t f
     | some d => L.give t f d⟩

/-- Everything recorded before step `t`. -/
def recorded (L : Flow F C) (ρ : Nat → F → Nat) (t : Nat) : Nat :=
  total (steps 0 t) fun s => total (L.present s) (ρ s)

/-- Each exchange with the family recorded at one unit. -/
def unitRecord (L : Flow F C) (cs : List C) (t : Nat) (f : F) : Nat :=
  sign (total cs (L.take t f) + total cs (L.give t f))

/-- Across the step from `t`, every formation taking part that exchanges with the family
leaves a record of at least one unit. -/
def RecordsOn (L : Flow F C) (ρ : Nat → F → Nat) (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → 0 < total cs (L.take t f) + total cs (L.give t f) → 0 < ρ t f

end Flow

/-- The web with the record standing at everything recorded before each step: nothing
requires, needs or draws on it. -/
def Web.withRecord (W : Web F C) (L : Flow F C) (ρ : Nat → F → Nat) : Web F (Option C) :=
  ⟨fun t c => match c with
     | none => L.recorded ρ t
     | some d => W.level t d,
   W.active,
   fun t f c => match c with
     | none => False
     | some d => W.requires t f d,
   fun t f c => match c with
     | none => 0
     | some d => W.need t f d,
   fun t f c => match c with
     | none => False
     | some d => W.draws t f d⟩

/-- The record is no member of a family of the flow's own conditions. -/
theorem none_not_mem : ∀ cs : List C, ¬ (none : Option C) ∈ cs.map some
  | [], mem => nomatch mem
  | _ :: cs, mem => match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => none_not_mem cs mem

/-- A family without repetition, with the record, is without repetition. -/
theorem distinct_withRecord {cs : List C} (distinct : Distinct cs) :
    Distinct ((none : Option C) :: cs.map some) :=
  ⟨none_not_mem cs, distinct_map (fun _ _ same => Option.some.inj same) distinct⟩

/-- A total over a family with the record is the record's value with the family's total. -/
theorem total_withRecord (q : Option C → Nat) (cs : List C) :
    total ((none : Option C) :: cs.map some) q = q none + total cs fun c => q (some c) :=
  congrArg (q none + ·) (total_map some q cs)

/-- A number is at most what is positive wherever it is. -/
theorem sign_le_of {a r : Nat} (pos : 0 < a → 0 < r) : sign a ≤ r :=
  match a, pos with
  | 0, _ => Nat.zero_le r
  | _ + 1, pos => pos (Nat.succ_pos _)

/-- Counting an exchange by what is taken, or by what is taken and given, is the same where
nothing is given beyond what is taken. -/
theorem sign_exchange_iff : ∀ {a b : Nat}, b + sign a ≤ a ↔ b + sign (a + b) ≤ a
  | 0, b => ⟨fun le => Eq.subst (motive := fun x => x + sign (0 + x) ≤ 0)
        (Nat.eq_zero_of_le_zero le).symm (Nat.le_refl 0),
      fun le => Nat.le_trans (Nat.le_add_right b _) le⟩
  | a + 1, b =>
    have one : sign (a + 1 + b) = 1 := congrArg sign (Nat.succ_add a b)
    ⟨fun le => Nat.le_trans (Nat.le_of_eq (congrArg (b + ·) one)) le,
     fun le => Nat.le_trans (Nat.le_of_eq (congrArg (b + ·) one).symm) le⟩

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat} {ρ : Nat → F → Nat}

/-- The record never falls: across each step it rises by everything recorded across it. -/
theorem recorded_succ (L : Flow F C) (ρ : Nat → F → Nat) (t : Nat) :
    L.recorded ρ (t + 1) = L.recorded ρ t + total (L.present t) (ρ t) :=
  (steps_last _ 0 t).trans (congrArg (L.recorded ρ t + ·)
    (congrArg (fun s => total (L.present s) (ρ s)) (Nat.zero_add t)))

/-- With the record counted, the flow balances exactly where it balances: the record stands
at everything given to it. -/
theorem balances_withRecord : L.Balances W ↔ (L.withRecord ρ).Balances (W.withRecord L ρ) :=
  ⟨fun balances t c => match c with
    | none => (congrArg (L.recorded ρ (t + 1) + ·) (total_zero (L.present t))).trans
        (recorded_succ L ρ t)
    | some d => balances t d,
   fun balances t d => balances t (some d)⟩

/-- The same at one step and on one family: with the record counted, the flow balances on a
family across a step exactly where it balances on the family with its record across that
step. The record's own balance needs nothing of the family. -/
theorem balancesOn_withRecord :
    L.BalancesOn W cs t ↔
      (L.withRecord ρ).BalancesOn (W.withRecord L ρ) ((none : Option C) :: cs.map some) t :=
  ⟨fun balances x mem => match x, mem with
    | none, _ => (congrArg (L.recorded ρ (t + 1) + ·) (total_zero (L.present t))).trans
        (recorded_succ L ρ t)
    | some d, mem => balances d (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => mem_of_map (fun _ _ same => Option.some.inj same) mem),
   fun balances d mem => balances (some d) (.tail _ (mem_map_some mem))⟩

/-- A family with the record is closed for the flow with the record counted exactly where
the family is closed for the flow. -/
theorem closedAt_withRecord :
    (L.withRecord ρ).ClosedAt ((none : Option C) :: cs.map some) t ↔ L.ClosedAt cs t :=
  ⟨fun closed f present c out => closed f present (some c) fun mem =>
      match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => out (mem_of_map (fun _ _ same => Option.some.inj same) mem),
   fun closed f present x => match x with
     | none => fun out => absurd (.head _) out
     | some c => fun out => closed f present c fun mem => out (.tail _ (mem_map_of mem))⟩

/-- With the record counted, the family with its record gains nothing exactly where each
formation taking part gives the family, with what it records, no more than it takes from
it. -/
theorem gainlessOn_withRecord_iff :
    (L.withRecord ρ).GainlessOn ((none : Option C) :: cs.map some) t ↔
      ∀ f, f ∈ L.present t → total cs (L.give t f) + ρ t f ≤ total cs (L.take t f) :=
  ⟨fun gainless f present => calc
      total cs (L.give t f) + ρ t f = ρ t f + total cs (L.give t f) := Nat.add_comm _ _
      _ = total ((none : Option C) :: cs.map some) ((L.withRecord ρ).give t f) :=
          (total_withRecord ((L.withRecord ρ).give t f) cs).symm
      _ ≤ total ((none : Option C) :: cs.map some) ((L.withRecord ρ).take t f) :=
          gainless f present
      _ = 0 + total cs (L.take t f) := total_withRecord ((L.withRecord ρ).take t f) cs
      _ = total cs (L.take t f) := Nat.zero_add _,
   fun each f present => calc
      total ((none : Option C) :: cs.map some) ((L.withRecord ρ).give t f)
          = ρ t f + total cs (L.give t f) := total_withRecord ((L.withRecord ρ).give t f) cs
      _ = total cs (L.give t f) + ρ t f := Nat.add_comm _ _
      _ ≤ total cs (L.take t f) := each f present
      _ = 0 + total cs (L.take t f) := (Nat.zero_add _).symm
      _ = total ((none : Option C) :: cs.map some) ((L.withRecord ρ).take t f) :=
          (total_withRecord ((L.withRecord ρ).take t f) cs).symm⟩

/-- The least loss per exchange is the first law with the record of each exchange counted
at one unit: a flow dissipates on a family across a step exactly where, with each exchange
with the family recorded at one unit, the family with its record gains nothing. -/
theorem dissipatesOn_iff_unitRecord :
    L.DissipatesOn cs t ↔
      (L.withRecord (L.unitRecord cs)).GainlessOn ((none : Option C) :: cs.map some) t :=
  ⟨fun dissipates => gainlessOn_withRecord_iff.mpr fun f present =>
      sign_exchange_iff.mp (dissipates f present),
   fun gainless f present => sign_exchange_iff.mpr (gainlessOn_withRecord_iff.mp gainless f present)⟩

/-- The unit record records every exchange. -/
theorem unitRecord_records : L.RecordsOn (L.unitRecord cs) cs t :=
  fun _ _ exchanged => sign_pos exchanged

/-- Any record of at least one unit per exchange will do: where the family with such a
record counted gains nothing, the flow dissipates on it. -/
theorem DissipatesOn.of_recorded
    (gainless : (L.withRecord ρ).GainlessOn ((none : Option C) :: cs.map some) t)
    (records : L.RecordsOn ρ cs t) : L.DissipatesOn cs t :=
  fun f present => Nat.le_trans
    (Nat.add_le_add_left (sign_le_of fun takes => records f present
      (Nat.lt_of_lt_of_le takes (Nat.le_add_right _ _))) _)
    (gainlessOn_withRecord_iff.mp gainless f present)

/-- So the least loss per exchange is the first law with a record of each exchange counted:
a flow dissipates on a family across a step exactly where, for some record of at least one
unit per exchange, the family with that record counted gains nothing. -/
theorem dissipatesOn_iff_recorded :
    L.DissipatesOn cs t ↔ ∃ ρ : Nat → F → Nat,
      (L.withRecord ρ).GainlessOn ((none : Option C) :: cs.map some) t ∧ L.RecordsOn ρ cs t :=
  ⟨fun dissipates => ⟨L.unitRecord cs, dissipatesOn_iff_unitRecord.mp dissipates,
     unitRecord_records⟩,
   fun ⟨_, gainless, records⟩ => DissipatesOn.of_recorded gainless records⟩

/-- Read over the whole flow: where, with a record counted, the flow gains nothing on every
closed family without repetition, and the record holds at least one unit for every exchange
with every such family of the flow's own conditions, the flow is dissipative. -/
theorem Dissipative.of_recorded (gainless : (L.withRecord ρ).Gainless)
    (records : ∀ cs t, Distinct cs → L.ClosedAt cs t → L.RecordsOn ρ cs t) : L.Dissipative :=
  fun cs t distinct closed => DissipatesOn.of_recorded
    (gainless _ t (distinct_withRecord distinct) (closedAt_withRecord.mpr closed))
    (records cs t distinct closed)

/-- Read over the whole flow: a flow is dissipative exactly where, across every step, every
family without repetition closed across it, with each exchange with it recorded at one unit,
gains nothing together with its record. -/
theorem dissipative_iff_unitRecord :
    L.Dissipative ↔ ∀ cs t, Distinct cs → L.ClosedAt cs t →
      (L.withRecord (L.unitRecord cs)).GainlessOn ((none : Option C) :: cs.map some) t :=
  ⟨fun dissipative cs t distinct closed =>
     dissipatesOn_iff_unitRecord.mp (dissipative cs t distinct closed),
   fun recorded cs t distinct closed =>
     dissipatesOn_iff_unitRecord.mpr (recorded cs t distinct closed)⟩

/-- In a balanced flow, across a step at which each formation taking part gives the family,
with `loss f`, at most what it takes from it, the family falls by at least the total of
`loss`. -/
theorem Balances.lowered_by (balances : L.Balances W) {loss : F → Nat}
    (each : ∀ f, f ∈ L.present t → total cs (L.give t f) + loss f ≤ total cs (L.take t f)) :
    W.stock cs (t + 1) + total (L.present t) loss ≤ W.stock cs t :=
  have sums : L.replenishment cs t + total (L.present t) loss ≤ L.uptake cs t := calc
    L.replenishment cs t + total (L.present t) loss
        = total (L.present t) (fun f => total cs (L.give t f)) + total (L.present t) loss :=
          congrArg (· + _) (total_swap (fun c f => L.give t f c) (L.present t) cs)
    _ = total (L.present t) (fun f => total cs (L.give t f) + loss f) := (total_add _ _ _).symm
    _ ≤ total (L.present t) (fun f => total cs (L.take t f)) := total_le _ each
    _ = L.uptake cs t := total_swap (fun f c => L.take t f c) cs (L.present t)
  le_of_add_le_add_right (L.replenishment cs t) (calc
    W.stock cs (t + 1) + total (L.present t) loss + L.replenishment cs t
        = W.stock cs (t + 1) + (L.replenishment cs t + total (L.present t) loss) :=
          (Nat.add_assoc _ _ _).trans (congrArg (W.stock cs (t + 1) + ·) (Nat.add_comm _ _))
    _ ≤ W.stock cs (t + 1) + L.uptake cs t := Nat.add_le_add_left sums _
    _ = W.stock cs t + L.replenishment cs t := balances.over cs t)

/-- Gaining nothing, a family's stock does not rise. -/
theorem Balances.nonrising (balances : L.Balances W) (gainless : L.GainlessOn cs t) :
    W.stock cs (t + 1) ≤ W.stock cs t :=
  Nat.le_trans (Nat.le_of_eq (congrArg (W.stock cs (t + 1) + ·) (total_zero (L.present t))).symm)
    (balances.lowered_by (loss := fun _ => 0) fun f present => gainless f present)

/-- The record is paid from the family: in a balanced flow, where the family with its record
counted gains nothing across a step, the family falls across it by at least everything
recorded across it. -/
theorem Balances.falls_by_record (balances : L.Balances W)
    (gainless : (L.withRecord ρ).GainlessOn ((none : Option C) :: cs.map some) t) :
    W.stock cs (t + 1) + total (L.present t) (ρ t) ≤ W.stock cs t :=
  balances.lowered_by (gainlessOn_withRecord_iff.mp gainless)

/-- Recording at least one unit per exchange, the record rises across a step by at least the
exchanges with the family. -/
theorem RecordsOn.exchanges_le (records : L.RecordsOn ρ cs t) :
    L.exchanges cs t ≤ total (L.present t) (ρ t) :=
  total_le _ fun f present => sign_le_of (records f present)

/-! ## The amount dissipated -/

/-- What the family loses across the step from `t`: what is taken from it beyond what is
given back to it. -/
def lost (L : Flow F C) (cs : List C) (t : Nat) : Nat :=
  excess (L.uptake cs t) (L.replenishment cs t)

/-- The amount dissipated from the family over the `N` steps from `T`: everything it lost
across them. Read with the record counted, it is what the record receives while the family
with its record conserves exactly (`Flow.GainlessOn.residues_lost`). -/
def dissipated (L : Flow F C) (cs : List C) (T N : Nat) : Nat :=
  total (steps T N) (L.lost cs)

/-! ## The inflow -/

/-- The family's inflow across the step from `t`: what each formation taking part gives it beyond
what it takes from it, summed over the formations. It is zero exactly where the family gains
nothing (`Flow.gainlessOn_iff_inflow`), and what the family gains across the step is at most it
(`Flow.gained_le_inflow`). -/
def inflow (L : Flow F C) (cs : List C) (t : Nat) : Nat :=
  total (L.present t) fun f => excess (total cs (L.give t f)) (total cs (L.take t f))

/-- An amount is at most another with its excess over it. -/
theorem le_add_excess (a b : Nat) : a ≤ b + excess a b :=
  Nat.le_trans (Nat.le_add_right a (excess b a)) (Nat.le_of_eq (excess_balance a b))

/-- What exceeds `x` by at most `y` has excess over `x` at most `y`. -/
theorem excess_le_of_le_add : ∀ {u x y : Nat}, u ≤ x + y → excess u x ≤ y
  | 0, _, _, _ => Nat.zero_le _
  | _ + 1, 0, y, le => Nat.le_trans le (Nat.le_of_eq (Nat.zero_add y))
  | u + 1, x + 1, y, le => excess_le_of_le_add (u := u) (x := x) (y := y)
      (Nat.le_of_succ_le_succ (Nat.le_trans le (Nat.le_of_eq (Nat.add_right_comm x 1 y))))

/-- **A family gains nothing exactly where its inflow is zero.** -/
theorem gainlessOn_iff_inflow : L.GainlessOn cs t ↔ L.inflow cs t = 0 :=
  ⟨fun gainless => total_eq_zero fun f present => excess_zero_of_le (gainless f present),
   fun zero _ present => Nat.ge_of_not_lt fun lt => Nat.not_lt_of_le
     (Nat.le_trans (le_total_of_mem (q := fun f => excess (total cs (L.give t f))
        (total cs (L.take t f))) present) (Nat.le_of_eq zero))
     (excess_pos.mpr lt)⟩

/-- **What a family is given is at most what is taken from it and its inflow.** -/
theorem replenishment_le_inflow (L : Flow F C) (cs : List C) (t : Nat) :
    L.replenishment cs t ≤ L.uptake cs t + L.inflow cs t :=
  Nat.le_trans (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) cs))
    (Nat.le_trans (total_le _ fun _ _ => le_add_excess _ _)
      (Nat.le_of_eq ((total_add (fun f => total cs (L.take t f))
          (fun f => excess (total cs (L.give t f)) (total cs (L.take t f))) (L.present t)).trans
        (congrArg (· + L.inflow cs t) (total_swap (fun f c => L.take t f c) cs (L.present t))))))

/-- **What a family gains is at most its inflow**: the excess of what it is given over what is
taken from it across a step. -/
theorem gained_le_inflow (L : Flow F C) (cs : List C) (t : Nat) :
    excess (L.replenishment cs t) (L.uptake cs t) ≤ L.inflow cs t :=
  excess_le_of_le_add (L.replenishment_le_inflow cs t)

/-- Gaining nothing, the family gets back at most what is taken from it: the case of no inflow. -/
theorem GainlessOn.replenishment_le (gainless : L.GainlessOn cs t) :
    L.replenishment cs t ≤ L.uptake cs t :=
  Nat.le_trans (L.replenishment_le_inflow cs t)
    (Nat.le_of_eq ((congrArg (L.uptake cs t + ·) (gainlessOn_iff_inflow.mp gainless)).trans
      (Nat.add_zero _)))

/-- Gaining nothing, what the family gets back and what it loses make up what is taken from
it. -/
theorem GainlessOn.replenishment_lost (gainless : L.GainlessOn cs t) :
    L.replenishment cs t + L.lost cs t = L.uptake cs t :=
  (excess_balance (L.replenishment cs t) (L.uptake cs t)).trans
    ((congrArg (L.uptake cs t + ·) (excess_zero_of_le gainless.replenishment_le)).trans
      (Nat.add_zero _))

/-- **What a family gains and loses, exactly.** In a balanced flow, across every step, the family's
stock after it with what it loses is its stock before with what it gains, the excess of what it is
given over what is taken from it, which is at most its inflow (`Flow.gained_le_inflow`). -/
theorem Balances.stock_gained (balances : L.Balances W) (cs : List C) (t : Nat) :
    W.stock cs (t + 1) + L.lost cs t =
      W.stock cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
  add_right_cancel (L.replenishment cs t) (calc
    W.stock cs (t + 1) + L.lost cs t + L.replenishment cs t
        = W.stock cs (t + 1) + (L.replenishment cs t + L.lost cs t) :=
          (Nat.add_assoc _ _ _).trans (congrArg (W.stock cs (t + 1) + ·) (Nat.add_comm _ _))
    _ = W.stock cs (t + 1) + (L.uptake cs t + excess (L.replenishment cs t) (L.uptake cs t)) :=
          congrArg (W.stock cs (t + 1) + ·) (excess_balance _ _)
    _ = W.stock cs (t + 1) + L.uptake cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
          (Nat.add_assoc _ _ _).symm
    _ = W.stock cs t + L.replenishment cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
          congrArg (· + _) (balances.over cs t)
    _ = W.stock cs t + excess (L.replenishment cs t) (L.uptake cs t) + L.replenishment cs t :=
          Nat.add_right_comm _ _ _)

/-- **Within the inflow.** In a balanced flow, across every step, the family's stock after it with
what it loses is at most its stock before with its inflow. -/
theorem Balances.stock_inflow (balances : L.Balances W) (cs : List C) (t : Nat) :
    W.stock cs (t + 1) + L.lost cs t ≤ W.stock cs t + L.inflow cs t :=
  Nat.le_trans (Nat.le_of_eq (balances.stock_gained cs t))
    (Nat.add_le_add_left (L.gained_le_inflow cs t) _)

/-- **Over a stretch, within its inflow.** In a balanced flow, a family's stock at the end of a
stretch is at most its stock at the start with the inflow across every step of the stretch. -/
theorem Balances.stock_over_inflow (balances : L.Balances W) (cs : List C) :
    ∀ S N, W.stock cs (S + N) ≤ W.stock cs S + total (steps S N) (L.inflow cs)
  | _, 0 => Nat.le_add_right _ _
  | S, N + 1 => Nat.le_trans
      (Nat.le_trans (Nat.le_add_right _ (L.lost cs (S + N))) (balances.stock_inflow cs (S + N)))
      (Nat.le_trans (Nat.add_le_add_right (balances.stock_over_inflow cs S N) _)
        (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans (congrArg (W.stock cs S + ·)
          (total_steps_add (L.inflow cs) S N 1).symm))))

/-- In a balanced flow, across a step at which the family gains nothing, its stock falls by
exactly what it loses: the case of `Flow.Balances.stock_gained` with nothing gained. -/
theorem Balances.stock_lost (balances : L.Balances W) (gainless : L.GainlessOn cs t) :
    W.stock cs (t + 1) + L.lost cs t = W.stock cs t :=
  (balances.stock_gained cs t).trans
    ((congrArg (W.stock cs t + ·) (excess_zero_of_le gainless.replenishment_le)).trans
      (Nat.add_zero _))

/-- Dissipated on, the family loses at least one unit for each formation taking from it. -/
theorem DissipatesOn.takers_le_lost (dissipates : L.DissipatesOn cs t) :
    L.takers cs t ≤ L.lost cs t :=
  le_of_add_le_add_right (L.replenishment cs t) (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
    (Nat.le_trans dissipates.replenishment_takers
      (Nat.le_of_eq (dissipates.gainlessOn.replenishment_lost.symm.trans (Nat.add_comm _ _)))))

/-- Dissipated on, a formation exchanging with the family takes from it: the exchanges with
the family are its takers. -/
theorem DissipatesOn.exchanges_le_takers (dissipates : L.DissipatesOn cs t) :
    L.exchanges cs t ≤ L.takers cs t :=
  total_le _ fun f present => sign_le_of fun exchanged => sign_pos
    (match Nat.decLt 0 (total cs (L.take t f)) with
     | isTrue takes => takes
     | isFalse idle => dissipates.takes_of_gives present (Nat.lt_of_lt_of_le exchanged
         (Nat.le_of_eq ((congrArg (· + total cs (L.give t f)) (eq_zero_of_not_pos idle)).trans
           (Nat.zero_add _)))))

/-- Losing nothing, the family loses nothing. -/
theorem ConservingOn.lost_zero (lossless : L.ConservingOn cs t) : L.lost cs t = 0 :=
  excess_zero_of_le (Nat.le_trans
    (Nat.le_of_eq (total_swap (fun f c => L.take t f c) cs (L.present t)).symm)
    (Nat.le_trans (total_le _ fun f present => Nat.le_of_eq (lossless f present).symm)
      (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) cs).symm)))

theorem dissipated_succ (L : Flow F C) (cs : List C) (T N : Nat) :
    L.dissipated cs T (N + 1) = L.dissipated cs T N + L.lost cs (T + N) :=
  steps_last (L.lost cs) T N

/-- The amount dissipated never falls. -/
theorem dissipated_mono (L : Flow F C) (cs : List C) (T N : Nat) :
    L.dissipated cs T N ≤ L.dissipated cs T (N + 1) :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (dissipated_succ L cs T N).symm)

/-- Dissipated on, it rises across a step by at least the formations taking from the
family. -/
theorem DissipatesOn.dissipated_rises {T N : Nat} (dissipates : L.DissipatesOn cs (T + N)) :
    L.dissipated cs T N + L.takers cs (T + N) ≤ L.dissipated cs T (N + 1) :=
  Nat.le_trans (Nat.add_le_add_left dissipates.takers_le_lost _)
    (Nat.le_of_eq (dissipated_succ L cs T N).symm)

/-- The family's stock with the amount dissipated is conserved: in a balanced flow over a
family gaining nothing at every step from `T` on, its stock after `N` steps, with the
amount dissipated over them, is its stock at `T`. -/
theorem Balances.stock_dissipated (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) :
    ∀ N, W.stock cs (T + N) + L.dissipated cs T N = W.stock cs T
  | 0 => rfl
  | N + 1 => calc
      W.stock cs (T + (N + 1)) + L.dissipated cs T (N + 1)
          = W.stock cs (T + N + 1) + L.lost cs (T + N) + L.dissipated cs T N :=
            (congrArg (_ + ·) ((dissipated_succ L cs T N).trans (Nat.add_comm _ _))).trans
              (Nat.add_assoc _ _ _).symm
      _ = W.stock cs (T + N) + L.dissipated cs T N :=
            congrArg (· + _) (balances.stock_lost (gainless (T + N) (Nat.le_add_right T N)))
      _ = W.stock cs T := Balances.stock_dissipated balances gainless N

/-- So the amount dissipated is at most the stock at the start. -/
theorem Balances.dissipated_le (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (N : Nat) : L.dissipated cs T N ≤ W.stock cs T :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (balances.stock_dissipated gainless N))

/-- Losing nothing, nothing is dissipated. -/
theorem dissipated_zero {T : Nat} (lossless : ∀ t, T ≤ t → L.ConservingOn cs t) (N : Nat) :
    L.dissipated cs T N = 0 :=
  total_eq_zero fun t mem => (lossless t (steps_mem mem)).lost_zero

/-- The history of exchanges is within the amount dissipated: in a balanced flow over a family
dissipated on at every step from `T` on, the exchanges with the family over the `N` steps
from `T` number at most the formations taking from it, which number at most the amount
dissipated, which is at most its stock at `T`. -/
theorem Balances.history_within (balances : L.Balances W) {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) (N : Nat) :
    total (steps T N) (L.exchanges cs) ≤ total (steps T N) (L.takers cs) ∧
      total (steps T N) (L.takers cs) ≤ L.dissipated cs T N ∧ L.dissipated cs T N ≤ W.stock cs T :=
  ⟨total_le _ fun t mem => (dissipates t (steps_mem mem)).exchanges_le_takers,
   total_le _ fun t mem => (dissipates t (steps_mem mem)).takers_le_lost,
   balances.dissipated_le (fun t later => (dissipates t later).gainlessOn) N⟩

/-- Under the first law loss does not recur: in a balanced flow over a family gaining nothing
at every step from `T` on, the family loses something at arbitrarily late steps nowhere. -/
theorem Balances.loss_ceases (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) : ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.lost cs t :=
  fun recurs => falls_not_recurring (W.stock cs) T
    (fun t later => Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_of_eq (balances.stock_lost (gainless t later))))
    fun N => match recurs (N + T) with
    | ⟨t, later, loses⟩ => ⟨t, Nat.le_trans (Nat.le_add_right N T) later,
        Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right loses)
          (Nat.le_of_eq (balances.stock_lost (gainless t (Nat.le_trans (Nat.le_add_left T N) later))))⟩

/-! ## Conservation with the record counted -/

/-- The record an exchange leaves where the family with its record conserves exactly: what
the formation takes from the family beyond what it gives back. -/
def residue (L : Flow F C) (cs : List C) (t : Nat) (f : F) : Nat :=
  excess (total cs (L.take t f)) (total cs (L.give t f))

/-- With the record counted, the family with its record loses nothing exactly where each
formation taking part gives the family, with what it records, exactly what it takes from
it. -/
theorem conservingOn_withRecord_iff :
    (L.withRecord ρ).ConservingOn ((none : Option C) :: cs.map some) t ↔
      ∀ f, f ∈ L.present t → total cs (L.give t f) + ρ t f = total cs (L.take t f) :=
  ⟨fun lossless f present => calc
      total cs (L.give t f) + ρ t f = ρ t f + total cs (L.give t f) := Nat.add_comm _ _
      _ = total ((none : Option C) :: cs.map some) ((L.withRecord ρ).give t f) :=
          (total_withRecord ((L.withRecord ρ).give t f) cs).symm
      _ = total ((none : Option C) :: cs.map some) ((L.withRecord ρ).take t f) :=
          lossless f present
      _ = 0 + total cs (L.take t f) := total_withRecord ((L.withRecord ρ).take t f) cs
      _ = total cs (L.take t f) := Nat.zero_add _,
   fun each f present => calc
      total ((none : Option C) :: cs.map some) ((L.withRecord ρ).give t f)
          = ρ t f + total cs (L.give t f) := total_withRecord ((L.withRecord ρ).give t f) cs
      _ = total cs (L.give t f) + ρ t f := Nat.add_comm _ _
      _ = total cs (L.take t f) := each f present
      _ = 0 + total cs (L.take t f) := (Nat.zero_add _).symm
      _ = total ((none : Option C) :: cs.map some) ((L.withRecord ρ).take t f) :=
          (total_withRecord ((L.withRecord ρ).take t f) cs).symm⟩

/-- Gaining nothing, each formation taking part gives the family, with its residue, exactly
what it takes from it. -/
theorem GainlessOn.conserves_residue (gainless : L.GainlessOn cs t) {f : F}
    (present : f ∈ L.present t) :
    total cs (L.give t f) + L.residue cs t f = total cs (L.take t f) :=
  (excess_balance (total cs (L.give t f)) (total cs (L.take t f))).trans
    ((congrArg (total cs (L.take t f) + ·) (excess_zero_of_le (gainless f present))).trans
      (Nat.add_zero _))

/-- Every exchange conserves exactly, and still the record rises: a flow dissipates on a
family across a step exactly where, with some record counted, the family with its record
loses nothing, and the record receives at least one unit from every exchange with the
family. -/
theorem dissipatesOn_iff_conserved :
    L.DissipatesOn cs t ↔ ∃ ρ : Nat → F → Nat,
      (L.withRecord ρ).ConservingOn ((none : Option C) :: cs.map some) t ∧ L.RecordsOn ρ cs t :=
  ⟨fun dissipates => ⟨L.residue cs,
     conservingOn_withRecord_iff.mpr fun _ present =>
       dissipates.gainlessOn.conserves_residue present,
     fun f present exchanged => excess_pos.mpr (Nat.lt_of_lt_of_le
       (Nat.lt_add_of_pos_right (sign_pos exchanged))
       (sign_exchange_iff.mp (dissipates f present)))⟩,
   fun ⟨_, lossless, records⟩ => DissipatesOn.of_recorded lossless.gainlessOn records⟩

/-- Gaining nothing, the residues across a step total what the family loses: the record
receives exactly what is dissipated. -/
theorem GainlessOn.residues_lost (gainless : L.GainlessOn cs t) :
    total (L.present t) (L.residue cs t) = L.lost cs t :=
  add_right_cancel (L.replenishment cs t) (calc
    total (L.present t) (L.residue cs t) + L.replenishment cs t
        = total (L.present t) (fun f => total cs (L.give t f)) +
            total (L.present t) (L.residue cs t) :=
          (Nat.add_comm _ _).trans
            (congrArg (· + _) (total_swap (fun c f => L.give t f c) (L.present t) cs))
    _ = total (L.present t) (fun f => total cs (L.give t f) + L.residue cs t f) :=
          (total_add _ _ _).symm
    _ = total (L.present t) (fun f => total cs (L.take t f)) :=
          Nat.le_antisymm
            (total_le _ fun _ present => Nat.le_of_eq (gainless.conserves_residue present))
            (total_le _ fun _ present => Nat.le_of_eq (gainless.conserves_residue present).symm)
    _ = L.uptake cs t := total_swap (fun f c => L.take t f c) cs (L.present t)
    _ = L.lost cs t + L.replenishment cs t :=
          gainless.replenishment_lost.symm.trans (Nat.add_comm _ _))

/-! ## The amount law and the amount dissipated -/

/-- Where the family gets back at most what is taken from it, what it gets back and what it
loses make up what is taken. -/
theorem replenishment_lost_of_le (le : L.replenishment cs t ≤ L.uptake cs t) :
    L.replenishment cs t + L.lost cs t = L.uptake cs t :=
  (excess_balance (L.replenishment cs t) (L.uptake cs t)).trans
    ((congrArg (L.uptake cs t + ·) (excess_zero_of_le le)).trans (Nat.add_zero _))

/-- Dissipated on in proportion `q`, the family loses at least a `(q + 1)`th of what is taken
from it: what is taken is at most `q + 1` times what is lost. -/
theorem DissipatesBy.uptake_le_lost {q : Nat} (dissipates : L.DissipatesBy q cs t) :
    L.uptake cs t ≤ (q + 1) * L.lost cs t :=
  le_of_add_le_add_right (q * L.uptake cs t) (calc
    L.uptake cs t + q * L.uptake cs t = (q + 1) * L.uptake cs t :=
        (Nat.add_comm _ _).trans (Nat.succ_mul q _).symm
    _ = (q + 1) * L.replenishment cs t + (q + 1) * L.lost cs t :=
        (congrArg ((q + 1) * ·) (replenishment_lost_of_le dissipates.replenishment_le).symm).trans
          (Nat.left_distrib _ _ _)
    _ ≤ q * L.uptake cs t + (q + 1) * L.lost cs t := Nat.add_le_add_right dissipates _
    _ = (q + 1) * L.lost cs t + q * L.uptake cs t := Nat.add_comm _ _)

/-- So over any stretch dissipated on in proportion `q`, everything taken from the family is
at most `q + 1` times the amount dissipated from it. -/
theorem uptake_within_dissipated {q T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesBy q cs t) (N : Nat) :
    total (steps T N) (L.uptake cs) ≤ (q + 1) * L.dissipated cs T N :=
  Nat.le_trans (total_le _ fun t mem => (dissipates t (steps_mem mem)).uptake_le_lost)
    (Nat.le_of_eq (total_mul (q + 1) (L.lost cs) (steps T N)))

end Flow

/-! ## Revisiting a configuration -/

/-- The family's configuration at step `t`: the level of each member, in order. -/
def Web.config (W : Web F C) (cs : List C) (t : Nat) : List Nat :=
  cs.map (W.level t)

/-- The family's configuration changes across the step from `t`. -/
def Web.Changes (W : Web F C) (cs : List C) (t : Nat) : Prop :=
  ¬ W.config cs (t + 1) = W.config cs t

instance (W : Web F C) (cs : List C) (t : Nat) : Decidable (W.Changes cs t) :=
  instDecidableNot

/-- The family revisits a configuration from `T` on: at some step its configuration is the
one it had at an earlier step from `T` on, though it changed across a step between. -/
def Web.Revisits (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∃ s v u, T ≤ s ∧ s ≤ v ∧ v < u ∧ W.Changes cs v ∧ W.config cs u = W.config cs s

/-- The pairs of numbers totalling `K`. -/
def splits : Nat → List (Nat × Nat)
  | 0 => [(0, 0)]
  | K + 1 => (0, K + 1) :: (splits K).map fun p => (p.1 + 1, p.2)

/-- The lists `g a` for the members `a` of a list, joined in order. -/
def EntropyLists.joinMap {α β : Type} : List α → (α → List β) → List β
  | [], _ => []
  | a :: as, g => g a ++ EntropyLists.joinMap as g

/-- The configurations of `n` amounts totalling `K`: the ways `K` units fall into `n`
places. -/
def configurations : Nat → Nat → List (List Nat)
  | 0, 0 => [[]]
  | 0, _ + 1 => []
  | n + 1, K => EntropyLists.joinMap (splits K) fun p => (configurations n p.2).map (p.1 :: ·)

/-- The configurations of `n` amounts totalling at most `K`. -/
def configurationsWithin (n K : Nat) : List (List Nat) :=
  EntropyLists.joinMap (downFrom K) (configurations n)

theorem EntropyLists.mem_joinMap {α β : Type} {g : α → List β} {b : β} :
    ∀ {as : List α} {a : α}, a ∈ as → b ∈ g a → b ∈ EntropyLists.joinMap as g
  | _ :: _, _, .head _, mem => mem_append_of_left _ mem
  | a' :: _, _, .tail _ inner, mem => mem_append_of_right (g a') (EntropyLists.mem_joinMap inner mem)

theorem head_splits : ∀ K, (0, K) ∈ splits K
  | 0 => .head _
  | _ + 1 => .head _

theorem mem_splits : ∀ i j, (i, j) ∈ splits (i + j)
  | 0, j => Eq.subst (motive := fun K => (0, j) ∈ splits K) (Nat.zero_add j).symm (head_splits j)
  | i + 1, j => Eq.subst (motive := fun K => (i + 1, j) ∈ splits K) (Nat.succ_add i j).symm
      (.tail _ (mem_map_of (g := fun p : Nat × Nat => (p.1 + 1, p.2)) (mem_splits i j)))

/-- Every list of numbers is among the configurations of its length and total. -/
theorem mem_configurations : ∀ l : List Nat, l ∈ configurations l.length (total l fun x => x)
  | [] => .head _
  | a :: l => EntropyLists.mem_joinMap (mem_splits a (total l fun x => x))
      (mem_map_of (g := (a :: ·)) (mem_configurations l))

theorem mem_configurationsWithin {l : List Nat} {K : Nat} (le : total l (fun x => x) ≤ K) :
    l ∈ configurationsWithin l.length K :=
  EntropyLists.mem_joinMap (mem_downFrom le) (mem_configurations l)

theorem EntropyLists.mem_append_cases {α : Type} {x : α} {m : List α} :
    ∀ {l : List α}, x ∈ l ++ m → x ∈ l ∨ x ∈ m
  | [], mem => .inr mem
  | _ :: _, .head _ => .inl (.head _)
  | a :: _, .tail _ mem => match EntropyLists.mem_append_cases mem with
    | .inl inl => .inl (.tail a inl)
    | .inr inm => .inr inm

theorem mem_joinMap_cases {α β : Type} {g : α → List β} {b : β} :
    ∀ {as : List α}, b ∈ EntropyLists.joinMap as g → ∃ a, a ∈ as ∧ b ∈ g a
  | a :: _, mem => match EntropyLists.mem_append_cases mem with
    | .inl here => ⟨a, .head _, here⟩
    | .inr later => match mem_joinMap_cases later with
      | ⟨a', inner, there⟩ => ⟨a', .tail a inner, there⟩

theorem EntropyLists.distinct_append {α : Type} {m : List α} (dm : Distinct m) :
    ∀ {l : List α}, Distinct l → (∀ x, x ∈ l → ¬ x ∈ m) → Distinct (l ++ m)
  | [], _, _ => dm
  | a :: _, ⟨fresh, dl⟩, apart =>
    ⟨fun mem => match EntropyLists.mem_append_cases mem with
      | .inl inl => fresh inl
      | .inr inm => apart a (.head _) inm,
     EntropyLists.distinct_append dm dl fun x mem => apart x (.tail a mem)⟩

/-- Joining lists without repetition, no two of which share a member, gives a list without
repetition. -/
theorem distinct_joinMap {α β : Type} {g : α → List β}
    (each : ∀ a, Distinct (g a)) :
    ∀ {as : List α}, Distinct as →
      (∀ a a' b, a ∈ as → a' ∈ as → b ∈ g a → b ∈ g a' → a = a') → Distinct (EntropyLists.joinMap as g)
  | [], _, _ => trivial
  | a :: _, ⟨fresh, das⟩, apart =>
    EntropyLists.distinct_append (distinct_joinMap each das fun x y b mx my => apart x y b (.tail a mx) (.tail a my))
      (each a) fun b here there => match mem_joinMap_cases there with
      | ⟨a', inner, there'⟩ => fresh (Eq.subst (motive := fun x => x ∈ _)
          (apart a a' b (.head _) (.tail a inner) here there').symm inner)

/-- Each pair among the splits of `K` totals `K`. -/
theorem sum_of_mem_splits : ∀ {K : Nat} {p : Nat × Nat}, p ∈ splits K → p.1 + p.2 = K
  | 0, _, .head _ => rfl
  | _ + 1, _, .head _ => Nat.zero_add _
  | K + 1, _, .tail _ mem => match preimage_of_mem_map mem with
    | ⟨q, inner, same⟩ => Eq.subst (motive := fun p : Nat × Nat => p.1 + p.2 = K + 1) same
        ((Nat.succ_add q.1 q.2).trans (congrArg (· + 1) (sum_of_mem_splits inner)))

/-- Two splits of `K` with the same first part are the same. -/
theorem splits_apart {K : Nat} {p p' : Nat × Nat} (mem : p ∈ splits K) (mem' : p' ∈ splits K)
    (same : p.1 = p'.1) : p = p' :=
  have second : p.2 = p'.2 := add_right_cancel p.1 ((Nat.add_comm _ _).trans
    ((sum_of_mem_splits mem).trans ((sum_of_mem_splits mem').symm.trans
      ((congrArg (· + p'.2) same.symm).trans (Nat.add_comm _ _)))))
  show (p.1, p.2) = (p'.1, p'.2) from congr (congrArg Prod.mk same) second

theorem distinct_splits : ∀ K, Distinct (splits K)
  | 0 => ⟨fun no => (nomatch no), trivial⟩
  | K + 1 => ⟨fun mem => match preimage_of_mem_map mem with
      | ⟨_, _, same⟩ => Nat.noConfusion (congrArg Prod.fst same),
     distinct_map (fun p p' same => show (p.1, p.2) = (p'.1, p'.2) from
       congr (congrArg Prod.mk (Nat.succ.inj (congrArg Prod.fst same))) (congrArg Prod.snd same))
       (distinct_splits K)⟩

/-- Each configuration of `n` amounts totalling `K` totals `K`. -/
theorem total_of_mem_configurations :
    ∀ {n K : Nat} {l : List Nat}, l ∈ configurations n K → total l (fun x => x) = K
  | 0, 0, _, .head _ => rfl
  | 0, 0, _, .tail _ no => nomatch no
  | 0, _ + 1, _, mem => nomatch mem
  | _ + 1, K, _, mem => match mem_joinMap_cases mem with
    | ⟨p, inp, inl⟩ => match preimage_of_mem_map inl with
      | ⟨_, inl', same⟩ => Eq.subst (motive := fun x => total x (fun x => x) = K) same
          ((congrArg (p.1 + ·) (total_of_mem_configurations inl')).trans (sum_of_mem_splits inp))

/-- Each configuration of `n` amounts is a list of `n` numbers. -/
theorem length_of_mem_configurations :
    ∀ {n K : Nat} {l : List Nat}, l ∈ configurations n K → l.length = n
  | 0, 0, _, .head _ => rfl
  | 0, 0, _, .tail _ no => nomatch no
  | 0, _ + 1, _, mem => nomatch mem
  | n + 1, _, _, mem => match mem_joinMap_cases mem with
    | ⟨_, _, inl⟩ => match preimage_of_mem_map inl with
      | ⟨_, inl', same⟩ => Eq.subst (motive := fun x : List Nat => x.length = n + 1) same
          (congrArg (· + 1) (length_of_mem_configurations inl'))

/-- No configuration is listed twice. -/
theorem distinct_configurations : ∀ n K, Distinct (configurations n K)
  | 0, 0 => ⟨fun no => (nomatch no), trivial⟩
  | 0, _ + 1 => trivial
  | n + 1, K => distinct_joinMap
      (fun p => distinct_map (fun _ _ same => (List.cons.inj same).2)
        (distinct_configurations n p.2))
      (distinct_splits K) fun _ _ _ mp mp' inp inp' => splits_apart mp mp'
        (match preimage_of_mem_map inp, preimage_of_mem_map inp' with
         | ⟨_, _, same⟩, ⟨_, _, same'⟩ => (List.cons.inj (same.trans same'.symm)).1)

/-- The configurations of `n` amounts totalling `K` are exactly the lists of `n` numbers
totalling `K`, each listed once: the length of the list counts the ways `K` units fall into
`n` places. -/
theorem configurations_exact (n K : Nat) :
    Distinct (configurations n K) ∧
      ∀ l : List Nat, l ∈ configurations n K ↔ l.length = n ∧ total l (fun x => x) = K :=
  ⟨distinct_configurations n K, fun l =>
    ⟨fun mem => ⟨length_of_mem_configurations mem, total_of_mem_configurations mem⟩,
     fun ⟨length, sum⟩ => Eq.subst (motive := fun k => l ∈ configurations n k) sum
       (Eq.subst (motive := fun m => l ∈ configurations m (total l fun x => x)) length
         (mem_configurations l))⟩⟩

/-- Two counts: three units fall into two members in four ways, and two units into three
members in six. -/
theorem configurations_examples :
    (configurations 2 3).length = 4 ∧ (configurations 3 2).length = 6 :=
  ⟨rfl, rfl⟩

theorem distinct_downFrom : ∀ K, Distinct (downFrom K)
  | 0 => ⟨fun no => (nomatch no), trivial⟩
  | K + 1 => ⟨fun mem => Nat.not_succ_le_self K (le_of_mem_downFrom mem), distinct_downFrom K⟩

/-- No configuration within a bound is listed twice. -/
theorem distinct_configurationsWithin (n K : Nat) : Distinct (configurationsWithin n K) :=
  distinct_joinMap (distinct_configurations n) (distinct_downFrom K) fun _ _ _ _ _ ink ink' =>
    (total_of_mem_configurations ink).symm.trans (total_of_mem_configurations ink')

namespace Web

variable {W : Web F C} {cs : List C}

/-- A family's configuration totals its stock. -/
theorem config_total (W : Web F C) (cs : List C) (t : Nat) :
    total (W.config cs t) (fun x => x) = W.stock cs t :=
  total_map (W.level t) (fun x => x) cs

/-- A family's configuration is among the configurations of its members within any bound on
its stock. -/
theorem config_within {t K : Nat} (le : W.stock cs t ≤ K) :
    W.config cs t ∈ configurationsWithin cs.length K :=
  Eq.subst (motive := fun n => W.config cs t ∈ configurationsWithin n K)
    (length_map (W.level t) cs)
    (mem_configurationsWithin (Nat.le_trans (Nat.le_of_eq (W.config_total cs t)) le))

/-- A family's configuration is among the configurations of its members totalling its
stock. -/
theorem config_exact {t K : Nat} (same : W.stock cs t = K) :
    W.config cs t ∈ configurations cs.length K :=
  Eq.subst (motive := fun n => W.config cs t ∈ configurations n K)
    (length_map (W.level t) cs)
    (Eq.subst (motive := fun k => W.config cs t ∈ configurations (W.config cs t).length k)
      ((W.config_total cs t).trans same) (mem_configurations (W.config cs t)))

/-- Where two configurations of a family agree, so does each member's level. -/
theorem level_of_config {u s : Nat} :
    ∀ {cs : List C} {c : C}, W.config cs u = W.config cs s → c ∈ cs → W.level u c = W.level s c
  | _ :: _, _, same, .head _ => (List.cons.inj same).1
  | _ :: _, _, same, .tail _ mem => level_of_config (List.cons.inj same).2 mem

/-- A member rising or falling changes the family's configuration. -/
theorem changes_of_member {t : Nat} {c : C} (mem : c ∈ cs)
    (moves : W.Rises t c ∨ W.Falls t c) : W.Changes cs t :=
  fun same => match moves with
  | .inl rises => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le rises
      (Nat.le_of_eq (level_of_config same mem)))
  | .inr falls => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le falls
      (Nat.le_of_eq (level_of_config same mem).symm))

/-- A change of the family's configuration is a member rising or falling. -/
theorem changes_member {t : Nat} :
    ∀ {cs : List C}, W.Changes cs t → ∃ c, c ∈ cs ∧ (W.Rises t c ∨ W.Falls t c)
  | [], changes => absurd rfl changes
  | c :: cs, changes => match Nat.decEq (W.level (t + 1) c) (W.level t c) with
    | isTrue same =>
      match changes_member (cs := cs) fun rest =>
          have whole : W.level (t + 1) c :: cs.map (W.level (t + 1)) =
              W.level t c :: cs.map (W.level t) := congr (congrArg List.cons same) rest
          changes whole with
      | ⟨d, mem, moves⟩ => ⟨d, .tail c mem, moves⟩
    | isFalse other => ⟨c, .head cs, match Nat.lt_or_gt_of_ne other with
      | .inl falls => .inr falls
      | .inr rises => .inl rises⟩

/-- Never revisiting, the configurations a family took after changing are distinct and
within any list holding every configuration it takes from `T` on, and the steps across which
it changed are no more than those configurations. -/
theorem seen_changes (E : List (List Nat)) {T : Nat}
    (within : ∀ t, T ≤ t → W.config cs t ∈ E) (never : ¬ W.Revisits cs T) :
    ∀ N, ∃ seen : List (List Nat), Distinct seen ∧ (∀ x, x ∈ seen → x ∈ E) ∧
      (∀ x, x ∈ seen → ∃ t, T ≤ t ∧ t < T + N ∧ W.Changes cs t ∧ W.config cs (t + 1) = x) ∧
      total (steps T N) (fun t => mark (W.Changes cs t)) ≤ seen.length
  | 0 => ⟨[], And.intro trivial (And.intro (fun _ no => nomatch no)
      (And.intro (fun _ no => nomatch no) (Nat.zero_le _)))⟩
  | N + 1 => match seen_changes E within never N with
    | ⟨seen, distinct, inE, made, counted⟩ =>
      have last := steps_last (fun t => mark (W.Changes cs t)) T N
      match (inferInstance : Decidable (W.Changes cs (T + N))) with
      | isFalse still =>
        ⟨seen, distinct, inE,
         fun x mem => match made x mem with
           | ⟨t, from_, before, changes, same⟩ =>
             ⟨t, from_, Nat.lt_succ_of_lt before, changes, same⟩,
         Nat.le_trans (Nat.le_of_eq (last.trans
           ((congrArg (total (steps T N) (fun t => mark (W.Changes cs t)) + ·)
             (mark_zero still)).trans (Nat.add_zero _)))) counted⟩
      | isTrue changes =>
        have fresh : ¬ W.config cs (T + N + 1) ∈ seen := fun mem => match made _ mem with
          | ⟨t, from_, before, _, same⟩ => never ⟨t + 1, T + N, T + N + 1,
              Nat.le_succ_of_le from_, before, Nat.lt_succ_self _, changes, same.symm⟩
        ⟨W.config cs (T + N + 1) :: seen, ⟨fresh, distinct⟩,
         fun x mem => match mem_cons_cases mem with
           | .inl same => Eq.subst (motive := fun y => y ∈ E) same.symm
               (within (T + N + 1) (Nat.le_succ_of_le (Nat.le_add_right T N)))
           | .inr mem => inE x mem,
         fun x mem => match mem_cons_cases mem with
           | .inl same => ⟨T + N, Nat.le_add_right T N, Nat.lt_succ_self _, changes, same.symm⟩
           | .inr mem => match made x mem with
             | ⟨t, from_, before, changes', same⟩ =>
               ⟨t, from_, Nat.lt_succ_of_lt before, changes', same⟩,
         Nat.le_trans (Nat.le_of_eq (last.trans
           (congrArg (total (steps T N) (fun t => mark (W.Changes cs t)) + ·) (mark_one changes))))
           (Nat.succ_le_succ counted)⟩

/-- A family that never revisits a configuration changes across at most as many steps as
there are configurations it can take: where from `T` on its configuration is always in a
list `E`, the steps of any stretch from `T` across which it changes number at most the
length of `E`. -/
theorem changes_within (E : List (List Nat)) {T : Nat}
    (within : ∀ t, T ≤ t → W.config cs t ∈ E) (never : ¬ W.Revisits cs T) (N : Nat) :
    total (steps T N) (fun t => mark (W.Changes cs t)) ≤ E.length :=
  match seen_changes E within never N with
  | ⟨_, distinct, inE, _, counted⟩ => Nat.le_trans counted (length_le_of_sub distinct inE)

/-- So it comes to rest: its configuration does not change at arbitrarily late steps. -/
theorem rests_of_never_revisits (E : List (List Nat)) {T : Nat}
    (within : ∀ t, T ≤ t → W.config cs t ∈ E) (never : ¬ W.Revisits cs T) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t :=
  fun changing => match recurring_accumulates (q := fun t => mark (W.Changes cs t))
      (fun N => match changing N with
        | ⟨t, later, changes⟩ => ⟨t, later, mark_pos.mpr changes⟩) T (E.length + 1) with
  | ⟨n, many⟩ => Nat.not_succ_le_self _ (Nat.le_trans many (changes_within E within never n))

end Web

/-- An amount that does not rise from `T` on is, at any later step, at most what it was at
any earlier step from `T` on. -/
theorem nonrising_from {q : Nat → Nat} {T : Nat} (step : ∀ t, T ≤ t → q (t + 1) ≤ q t)
    {s : Nat} (from_ : T ≤ s) : ∀ m, q (s + m) ≤ q s
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (step (s + m) (Nat.le_trans from_ (Nat.le_add_right s m)))
      (nonrising_from step from_ m)

theorem nonrising_between {q : Nat → Nat} {T : Nat} (step : ∀ t, T ≤ t → q (t + 1) ≤ q t)
    {s u : Nat} (from_ : T ≤ s) (le : s ≤ u) : q u ≤ q s :=
  match le_dest le with
  | ⟨m, same⟩ => Eq.subst (motive := fun x => q x ≤ q s) same.symm (nonrising_from step from_ m)

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- Under dissipation a family never revisits a configuration: in a balanced flow over a
family dissipated on at every step from `T` on, across a step at which its configuration
changes its stock falls, and it never rises. -/
theorem Balances.never_revisits (balances : L.Balances W) {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) : ¬ W.Revisits cs T :=
  fun ⟨s, v, u, from_, sv, vu, changes, same⟩ =>
    have step : ∀ t, T ≤ t → W.stock cs (t + 1) ≤ W.stock cs t := fun t later =>
      balances.nonrising (dissipates t later).gainlessOn
    have falls : W.stock cs (v + 1) < W.stock cs v := match Web.changes_member changes with
      | ⟨_, mem, .inl rises⟩ => rise_lowers_on balances (dissipates v (Nat.le_trans from_ sv)) mem rises
      | ⟨_, mem, .inr falls⟩ => fall_lowers_on balances (dissipates v (Nat.le_trans from_ sv)) mem falls
    have back : W.stock cs u = W.stock cs s :=
      (W.config_total cs u).symm.trans ((congrArg (total · fun x => x) same).trans
        (W.config_total cs s))
    Nat.lt_irrefl (W.stock cs s) (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq back.symm)
        (nonrising_between step (Nat.le_trans from_ (Nat.le_trans sv (Nat.le_succ v))) vu))
      (Nat.lt_of_lt_of_le falls (nonrising_between step from_ sv)))

/-- Never revisiting under the first law, a family changes across at most as many steps as it
has configurations within its stock: in a balanced flow over a family gaining nothing at
every step from `T` on, where it never revisits a configuration, the steps of any stretch
from `T` across which its configuration changes number at most the configurations of its
members totalling at most its stock at `T`. -/
theorem Balances.changes_within (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (never : ¬ W.Revisits cs T) (N : Nat) :
    total (steps T N) (fun t => mark (W.Changes cs t)) ≤
      (configurationsWithin cs.length (W.stock cs T)).length :=
  Web.changes_within _ (fun _ later => Web.config_within
    (nonrising_between (fun s l => balances.nonrising (gainless s l)) (Nat.le_refl T) later))
    never N

/-- Losing nothing, it changes across at most as many steps as there are ways its stock falls
into its members: Boltzmann's count of the configurations of that stock. -/
theorem Balances.changes_within_conserving (balances : L.Balances W) {T : Nat}
    (lossless : ∀ t, T ≤ t → L.ConservingOn cs t) (never : ¬ W.Revisits cs T) (N : Nat) :
    total (steps T N) (fun t => mark (W.Changes cs t)) ≤
      (configurations cs.length (W.stock cs T)).length :=
  Web.changes_within _ (fun _ later => match le_dest later with
    | ⟨m, same⟩ => Web.config_exact (Eq.subst (motive := fun x => W.stock cs x = W.stock cs T)
        same.symm ((congrArg (W.stock cs (T + m) + ·) (dissipated_zero lossless m).symm).trans
          (balances.stock_dissipated (fun t later => (lossless t later).gainlessOn) m))))
    never N

/-- Rest without the least loss: in a balanced flow over a family gaining nothing at every
step from `T` on, where it never revisits a configuration, its configuration does not change
at arbitrarily late steps. -/
theorem Balances.rests_of_never_revisits (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (never : ¬ W.Revisits cs T) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t :=
  Web.rests_of_never_revisits _ (fun _ later => Web.config_within
    (nonrising_between (fun s l => balances.nonrising (gainless s l)) (Nat.le_refl T) later))
    never

/-- Zero loss, unending, revisits: in a balanced flow over a family gaining nothing at every
step from `T` on, where its configuration changes at arbitrarily late steps, it is not the
case that it never revisits a configuration. -/
theorem Balances.unending_change_revisits (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (changing : ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t) :
    ¬¬ W.Revisits cs T :=
  fun never => balances.rests_of_never_revisits gainless never changing

end Flow

/-! ## An arrow of the configuration -/

/-- A quantity `S` of the family's configuration is an arrow of time from `T` on: it never
falls, and it rises across every step at which the configuration changes. -/
def Web.Arrow (W : Web F C) (cs : List C) (T : Nat) (S : List Nat → Nat) : Prop :=
  (∀ t, T ≤ t → S (W.config cs t) ≤ S (W.config cs (t + 1))) ∧
    ∀ t, T ≤ t → W.Changes cs t → S (W.config cs t) < S (W.config cs (t + 1))

/-- An amount that does not fall from `T` on is, at any later step, at least what it was at
any earlier step from `T` on. -/
theorem nonfalling_from {q : Nat → Nat} {T : Nat} (step : ∀ t, T ≤ t → q t ≤ q (t + 1))
    {s : Nat} (from_ : T ≤ s) : ∀ m, q s ≤ q (s + m)
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (nonfalling_from step from_ m)
      (step (s + m) (Nat.le_trans from_ (Nat.le_add_right s m)))

theorem nonfalling_between {q : Nat → Nat} {T : Nat} (step : ∀ t, T ≤ t → q t ≤ q (t + 1))
    {s u : Nat} (from_ : T ≤ s) (le : s ≤ u) : q s ≤ q u :=
  match le_dest le with
  | ⟨m, same⟩ => Eq.subst (motive := fun x => q s ≤ q x) same.symm (nonfalling_from step from_ m)

/-- With an arrow, the family never revisits a configuration: across the change between, the
arrow rises, and it never falls back. -/
theorem Web.never_revisits_of_arrow {W : Web F C} {cs : List C} {T : Nat}
    {S : List Nat → Nat} (arrow : W.Arrow cs T S) : ¬ W.Revisits cs T :=
  fun ⟨s, v, _, from_, sv, vu, changes, same⟩ =>
    Nat.lt_irrefl (S (W.config cs s)) (Nat.lt_of_lt_of_le
      (Nat.lt_of_le_of_lt (nonfalling_between (q := fun t => S (W.config cs t)) arrow.1 from_ sv)
        (arrow.2 v (Nat.le_trans from_ sv) changes))
      (Nat.le_trans (nonfalling_between (q := fun t => S (W.config cs t)) arrow.1
          (Nat.le_trans from_ (Nat.le_trans sv (Nat.le_succ v))) vu)
        (Nat.le_of_eq (congrArg S same))))

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- An arrow brings rest under the first law: in a balanced flow over a family gaining nothing
at every step from `T` on, where some quantity of its configuration is an arrow from `T` on,
its configuration does not change at arbitrarily late steps. -/
theorem Balances.rests_of_arrow (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {S : List Nat → Nat} (arrow : W.Arrow cs T S) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t :=
  balances.rests_of_never_revisits gainless (Web.never_revisits_of_arrow arrow)

/-- So under the first law no quantity of the configuration is an arrow while change goes on:
in a balanced flow over a family gaining nothing at every step from `T` on, whose
configuration changes at arbitrarily late steps, no quantity of its configuration is an arrow
from `T` on. -/
theorem Balances.no_arrow (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (changing : ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t)
    (S : List Nat → Nat) : ¬ W.Arrow cs T S :=
  fun arrow => balances.rests_of_arrow gainless arrow changing

end Flow

/-! ## Merging configurations -/

/-- From `T` on, the family's change is a function of its configuration: its configuration
after each step is `next` of its configuration before it. -/
def Web.Determined (W : Web F C) (cs : List C) (T : Nat) (next : List Nat → List Nat) : Prop :=
  ∀ t, T ≤ t → W.config cs (t + 1) = next (W.config cs t)

/-- From `T` on, `next` merges two of the family's configurations: across some step at which
the configuration changes, the configurations before and after it go to the same. -/
def Web.Merges (W : Web F C) (cs : List C) (T : Nat) (next : List Nat → List Nat) : Prop :=
  ∃ t, T ≤ t ∧ W.Changes cs t ∧ next (W.config cs (t + 1)) = next (W.config cs t)

namespace Web

variable {W : Web F C} {cs : List C}

/-- Coming to rest after a change merges two configurations: where the family's change is a
function of its configuration from `T` on, if its configuration changes across a step from
`T` on and stays the same across a later one, `next` sends two different configurations it
took to the same. No law of the flow is used. -/
theorem merges_of_settles {T : Nat} {next : List Nat → List Nat}
    (determined : W.Determined cs T next) {v : Nat} (from_ : T ≤ v) (changes : W.Changes cs v) :
    ∀ n, W.config cs (v + n + 1) = W.config cs (v + n) → W.Merges cs T next
  | 0, same => absurd same changes
  | n + 1, same => match (inferInstance : Decidable (W.Changes cs (v + n))) with
    | isTrue moved => ⟨v + n, Nat.le_trans from_ (Nat.le_add_right v n), moved,
        (determined (v + n + 1) (Nat.le_trans from_ (Nat.le_succ_of_le (Nat.le_add_right v n)))).symm.trans
          (same.trans (determined (v + n) (Nat.le_trans from_ (Nat.le_add_right v n))))⟩
    | isFalse still => merges_of_settles determined from_ changes n
        (match decEq (W.config cs (v + n + 1)) (W.config cs (v + n)) with
         | isTrue same' => same'
         | isFalse other => absurd other still)

/-- Merging nothing, change goes on: where the family's change is a function of its
configuration from `T` on and `next` merges none of its configurations, once its
configuration changes across a step from `T` on, it changes across every later step. -/
theorem changes_persist {T : Nat} {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (apart : ¬ W.Merges cs T next) {v : Nat}
    (from_ : T ≤ v) (changes : W.Changes cs v) : ∀ n, W.Changes cs (v + n) :=
  fun n same => apart (merges_of_settles determined from_ changes n same)

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- Merging nothing under the first law, a family that changes revisits a configuration: in a
balanced flow over a family gaining nothing at every step from `T` on, whose change is a
function of its configuration merging none of its configurations, once its configuration
changes from `T` on it is not the case that it never revisits a configuration. -/
theorem Balances.revisits_of_apart (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (apart : ¬ W.Merges cs T next) {v : Nat}
    (from_ : T ≤ v) (changes : W.Changes cs v) : ¬¬ W.Revisits cs T :=
  balances.unending_change_revisits gainless fun N =>
    ⟨v + N, Nat.le_add_left N v, Web.changes_persist determined apart from_ changes N⟩

/-- Never revisiting under the first law, change that is a function of the configuration
merges: in a balanced flow over a family gaining nothing at every step from `T` on, where
its change is a function of its configuration and it never revisits a configuration, once
its configuration changes from `T` on, it is not the case that `next` merges none of its
configurations. -/
theorem Balances.merges_of_never_revisits (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (never : ¬ W.Revisits cs T) {v : Nat}
    (from_ : T ≤ v) (changes : W.Changes cs v) : ¬¬ W.Merges cs T next :=
  fun apart => balances.revisits_of_apart gainless determined apart from_ changes never

/-- So an arrow merges: under the first law, where the family's change is a function of its
configuration and some quantity of its configuration is an arrow, once it changes it is not
the case that `next` merges none of its configurations. -/
theorem Balances.merges_of_arrow (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) {S : List Nat → Nat} (arrow : W.Arrow cs T S)
    {v : Nat} (from_ : T ≤ v) (changes : W.Changes cs v) : ¬¬ W.Merges cs T next :=
  balances.merges_of_never_revisits gainless determined (Web.never_revisits_of_arrow arrow)
    from_ changes

/-- And dissipation merges: in a balanced flow over a family dissipated on at every step from
`T` on, whose change is a function of its configuration, once it changes it is not the case
that `next` merges none of its configurations. -/
theorem Balances.merges_of_dissipates (balances : L.Balances W) {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) {v : Nat} (from_ : T ≤ v)
    (changes : W.Changes cs v) : ¬¬ W.Merges cs T next :=
  balances.merges_of_never_revisits (fun t later => (dissipates t later).gainlessOn) determined
    (balances.never_revisits dissipates) from_ changes

end Flow

/-! ## The laws of change on a family's configuration

`Becoming.Recurrence` states, with no premise, what every sequence of configurations and every
determined law keeps, loses and returns to. A family's configurations from `T` on are such a
sequence, and where its change is a function of its configuration, `next` is such a law.
Revisiting after a change is revisiting, an arrow marks every change, and a merge along the
family is a merge of the law; under the first law the configurations stay within one list,
so the pigeonhole, the stopping of marked change and the forgetting present apply to it. -/

namespace Web

variable {W : Web F C} {cs : List C}

/-- Revisiting after a change is revisiting: the family's configurations from `T` on take one
value at two steps. -/
theorem Revisits.recurs {T : Nat} (revisits : W.Revisits cs T) :
    Becoming.Revisits (fun n => W.config cs (T + n)) :=
  match revisits with
  | ⟨_, _, _, from_, sv, vu, _, same⟩ =>
    match le_dest from_, le_dest (Nat.le_trans from_ (Nat.le_trans sv (Nat.le_of_lt vu))) with
    | ⟨i, si⟩, ⟨j, uj⟩ =>
      ⟨i, j, Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq si.symm)
          (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt sv vu) (Nat.le_of_eq uj))),
        (congrArg (W.config cs) si).symm.trans (same.symm.trans (congrArg (W.config cs) uj))⟩

/-- An arrow marks every change: a quantity of the configuration that is an arrow from `T` on
marks the changes of the family's configurations from `T` on. -/
theorem Arrow.marks {T : Nat} {S : List Nat → Nat} (arrow : W.Arrow cs T S) :
    Marks S (fun n => W.config cs (T + n)) :=
  fun n => ⟨arrow.1 (T + n) (Nat.le_add_right T n), arrow.2 (T + n) (Nat.le_add_right T n)⟩

/-- A merge along the family is a merge of its law. -/
theorem Merges.law {T : Nat} {next : List Nat → List Nat} (merges : W.Merges cs T next) :
    Law.Merges next :=
  match merges with
  | ⟨t, _, changes, merged⟩ => Law.merges_iff.mpr ⟨W.config cs (t + 1), W.config cs t, changes, merged⟩

/-- Where the family's change is a function of its configuration from `T` on, its
configuration `n` steps after `T` is the orbit of its configuration at `T` under `next`. -/
theorem Determined.orbit {T : Nat} {next : List Nat → List Nat}
    (determined : W.Determined cs T next) :
    ∀ n, W.config cs (T + n) = Law.orbit next (W.config cs T) n
  | 0 => rfl
  | n + 1 => (determined (T + n) (Nat.le_add_right T n)).trans
      (congrArg next (Determined.orbit determined n))

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- Under the first law the family's configurations from `T` on stay within one list: those
of its members totalling at most its stock at `T`. -/
theorem Balances.held (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (n : Nat) :
    W.config cs (T + n) ∈ configurationsWithin cs.length (W.stock cs T) :=
  Web.config_within (nonrising_between (fun s l => balances.nonrising (gainless s l))
    (Nat.le_refl T) (Nat.le_add_right T n))

/-- So, where its change from `T` on is the law `next`, the orbit of its configuration at `T`
stays within that list. -/
theorem Balances.orbit_held (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (n : Nat) :
    Law.orbit next (W.config cs T) n ∈ configurationsWithin cs.length (W.stock cs T) :=
  Eq.subst (motive := fun x => x ∈ configurationsWithin cs.length (W.stock cs T))
    (determined.orbit n) (balances.held gainless n)

/-- **Under the first law the configuration recurs**, with no decision and no further
premise: in a balanced flow over a family gaining nothing at every step from `T` on, from
every step on its configurations take one value at two steps (`revisits_from`). -/
theorem Balances.recurs (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (M : Nat) :
    ∃ i j, M ≤ i ∧ i < j ∧ W.config cs (T + i) = W.config cs (T + j) :=
  revisits_from (g := fun n => W.config cs (T + n)) (balances.held gainless) M

/-- An arrow stops change under the first law, as every marked change within finitely many
configurations stops (`Marks.change_not_recurring`). -/
theorem Balances.arrow_stops (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {S : List Nat → Nat} (arrow : W.Arrow cs T S) :
    ¬ ∀ M, ∃ k, M ≤ k ∧ W.Changes cs (T + k) :=
  fun recurs => Marks.change_not_recurring (g := fun n => W.config cs (T + n)) arrow.marks
    (balances.held gainless) recurs

/-- **Merging nothing within the bound of the first law, the start returns.** The bound does
the work, not losing alone: `Law.succ_open` merges nothing and never returns. In a balanced
flow over a family gaining nothing at every step from `T` on, the configurations stay among
those of its members totalling at most its stock at `T` (`Flow.Balances.orbit_held`); where
its change from `T` on is the law `next` and `next` merges no two configurations, the
configuration at `T` comes back. -/
theorem Balances.returns_of_conserving (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (lossless : Law.Lossless next) :
    Law.Returns next (W.config cs T) :=
  match revisits_of_held (g := Law.orbit next (W.config cs T))
      (balances.orbit_held gainless determined) with
  | ⟨i, _, lt, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ => Law.returns_iff.mpr ⟨d + 1, Nat.succ_pos d, lossless.cancel i
        ((Law.orbit_add next (W.config cs T) (d + 1) i).symm.trans
          ((congrArg (Law.orbit next (W.config cs T)) (Nat.add_comm (d + 1) i)).trans
            ((congrArg (Law.orbit next (W.config cs T)) gap.symm).trans same.symm)))⟩

/-- **A finite present forgets**, for the family: under the first law, where its change from
`T` on is the law `next`, from every step on two different kept histories of its
configuration share one present (`Law.present_forgets`). -/
theorem Balances.present_forgets (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) (M : Nat) :
    ∃ i j, M ≤ i ∧ i < j ∧
      (Law.orbit (Law.withHistory next) (W.config cs T, []) i).1 =
        (Law.orbit (Law.withHistory next) (W.config cs T, []) j).1 ∧
      Law.orbit (Law.withHistory next) (W.config cs T, []) i ≠
        Law.orbit (Law.withHistory next) (W.config cs T, []) j :=
  Law.present_forgets next (balances.orbit_held gainless determined) M

/-- So an arrow rules out a law merging nothing: under the first law, where the family's
change is the law `next` and some quantity of its configuration is an arrow, once it changes
`next` merges two configurations somewhere (`Law.rise_not_lossless`, here with no list of
every configuration). -/
theorem Balances.not_conserving_of_arrow (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) {S : List Nat → Nat} (arrow : W.Arrow cs T S)
    {v : Nat} (from_ : T ≤ v) (changes : W.Changes cs v) : ¬ Law.Lossless next :=
  fun lossless => balances.merges_of_arrow gainless determined arrow from_ changes
    fun merges => merges.law.not_lossless lossless

/-- And so does dissipation. -/
theorem Balances.not_conserving_of_dissipates (balances : L.Balances W) {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) {next : List Nat → List Nat}
    (determined : W.Determined cs T next) {v : Nat} (from_ : T ≤ v)
    (changes : W.Changes cs v) : ¬ Law.Lossless next :=
  fun lossless => balances.merges_of_dissipates dissipates determined from_ changes
    fun merges => merges.law.not_lossless lossless

end Flow

/-! ## Carrying the history -/

/-- A mark is at most the mark of what it implies. -/
theorem mark_mono {p q : Prop} [Decidable p] [Decidable q] (imp : p → q) : mark p ≤ mark q :=
  mark_cases (q := fun m => m ≤ mark q) (fun holds => Nat.le_of_eq (mark_one (imp holds)).symm)
    (fun _ => Nat.zero_le _)

/-- Adding on the left preserves no more than order. -/
theorem le_of_add_le_add_left {a b : Nat} (k : Nat) (le : k + a ≤ k + b) : a ≤ b :=
  le_of_add_le_add_right k (Nat.le_trans (Nat.le_of_eq (Nat.add_comm a k))
    (Nat.le_trans le (Nat.le_of_eq (Nat.add_comm k b))))

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- The history of the family's exchanges over the `N` steps from `T`: how many exchanges
with it took place across them. -/
def exchangeCount (L : Flow F C) (cs : List C) (T N : Nat) : Nat :=
  total (steps T N) (L.exchanges cs)

/-- The history never shrinks. -/
theorem history_mono (L : Flow F C) (cs : List C) (T : Nat) {a b : Nat} (le : a ≤ b) :
    L.exchangeCount cs T a ≤ L.exchangeCount cs T b :=
  match le_dest le with
  | ⟨m, same⟩ => Eq.subst (motive := fun z => L.exchangeCount cs T a ≤ L.exchangeCount cs T z) same.symm
      (steps_mono (L.exchanges cs) T a m)

/-- The family's configuration carries its history from `T` on: some reading of its
configuration at each step from `T` on gives the number of exchanges with it since `T`. -/
def CarriesHistory (L : Flow F C) (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∃ read : List Nat → Nat, ∀ N, read (W.config cs (T + N)) = L.exchangeCount cs T N

/-- A formation taking part that takes from or gives to a member of the family exchanges
with it. -/
theorem exchanges_pos {t : Nat} {f : F} (present : f ∈ L.present t) {c : C} (mem : c ∈ cs)
    (exchanged : 0 < L.take t f c ∨ 0 < L.give t f c) : 0 < L.exchanges cs t :=
  total_pos_of_mem (q := fun f => sign (total cs (L.take t f) + total cs (L.give t f))) present
    (sign_pos (match exchanged with
      | .inl takes => Nat.lt_of_lt_of_le (total_pos_of_mem (q := L.take t f) mem takes)
          (Nat.le_add_right _ _)
      | .inr gives => Nat.lt_of_lt_of_le (total_pos_of_mem (q := L.give t f) mem gives)
          (Nat.le_add_left _ _)))

/-- Carrying its history, the family's configuration changes across every step at which
anything is exchanged with it: the history grows, so what carries it changes. -/
theorem CarriesHistory.changes {T : Nat} (carries : L.CarriesHistory W cs T) {N : Nat}
    (exchanged : 0 < L.exchanges cs (T + N)) : W.Changes cs (T + N) :=
  fun same => match carries with
  | ⟨read, reads⟩ => Nat.lt_irrefl (L.exchangeCount cs T N) (Nat.lt_of_lt_of_le
      (Nat.lt_add_of_pos_right exchanged)
      (Nat.le_of_eq ((steps_last (L.exchanges cs) T N).symm.trans
        ((reads (N + 1)).symm.trans ((congrArg read same).trans (reads N))))))

/-- Carrying its history, a family never revisits a configuration: in a balanced flow every
change is an exchange, so across a change the history grows, and equal configurations carry
equal histories. -/
theorem Balances.never_revisits_of_carries (balances : L.Balances W) {T : Nat}
    (carries : L.CarriesHistory W cs T) : ¬ W.Revisits cs T :=
  fun ⟨_, _, _, from_, sv, vu, changes, same⟩ => match carries with
  | ⟨read, reads⟩ =>
    match le_dest from_, le_dest (Nat.le_trans from_ sv),
      le_dest (Nat.le_trans from_ (Nat.le_trans sv (Nat.le_of_lt vu))) with
    | ⟨a, sa⟩, ⟨c, vc⟩, ⟨b, ub⟩ =>
      have ac : a ≤ c := le_of_add_le_add_left T
        (Nat.le_trans (Nat.le_of_eq sa.symm) (Nat.le_trans sv (Nat.le_of_eq vc)))
      have cb : c + 1 ≤ b := le_of_add_le_add_left T
        (Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) vc).symm) (Nat.le_trans vu (Nat.le_of_eq ub)))
      have exchanged : 0 < L.exchanges cs (T + c) :=
        match Web.changes_member (Eq.subst (motive := fun x => W.Changes cs x) vc changes) with
        | ⟨_, mem, moves⟩ => balances.exchanges_of_change mem moves
      have back : L.exchangeCount cs T b = L.exchangeCount cs T a :=
        (reads b).symm.trans ((congrArg (fun x => read (W.config cs x)) ub.symm).trans
          ((congrArg read same).trans ((congrArg (fun x => read (W.config cs x)) sa).trans (reads a))))
      Nat.lt_irrefl (L.exchangeCount cs T a) (Nat.lt_of_le_of_lt (L.history_mono cs T ac)
        (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right exchanged)
          (Nat.le_trans (Nat.le_of_eq (steps_last (L.exchanges cs) T c).symm)
            (Nat.le_trans (L.history_mono cs T cb) (Nat.le_of_eq back)))))

/-- A finite enclosure cannot carry an unending history under the first law: in a balanced
flow over a family gaining nothing at every step from `T` on, whose configuration carries its
history, the steps of any stretch from `T` at which anything is exchanged with it number at
most its configurations within its stock at `T`. -/
theorem Balances.exchanges_within_of_carries (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (carries : L.CarriesHistory W cs T) (N : Nat) :
    total (steps T N) (fun t => mark (0 < L.exchanges cs t)) ≤
      (configurationsWithin cs.length (W.stock cs T)).length :=
  Nat.le_trans (total_le _ fun _ mem => mark_mono fun exchanged =>
      match le_dest (steps_mem mem) with
      | ⟨_, same⟩ => Eq.subst (motive := fun x => W.Changes cs x) same.symm
          (carries.changes (Eq.subst (motive := fun x => 0 < L.exchanges cs x) same exchanged)))
    (balances.changes_within gainless (balances.never_revisits_of_carries carries) N)

/-- So exchange with it stops: carrying its history under the first law, nothing is exchanged
with the family at arbitrarily late steps. -/
theorem Balances.exchange_stops_of_carries (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) (carries : L.CarriesHistory W cs T) :
    ¬ ∀ M, ∃ t, M ≤ t ∧ 0 < L.exchanges cs t :=
  fun exchanging => match recurring_accumulates (q := fun t => mark (0 < L.exchanges cs t))
      (fun M => match exchanging M with
        | ⟨t, later, exchanged⟩ => ⟨t, later, mark_pos.mpr exchanged⟩) T
      ((configurationsWithin cs.length (W.stock cs T)).length + 1) with
  | ⟨n, many⟩ => Nat.not_succ_le_self _
      (Nat.le_trans many (balances.exchanges_within_of_carries gainless carries n))

/-- Carried, the history is an arrow: in a balanced flow, where the family's configuration
carries its history from `T` on, the reading that gives the history is an arrow from `T` on,
since every change is an exchange. -/
theorem Balances.arrow_of_carries (balances : L.Balances W) {T : Nat}
    (carries : L.CarriesHistory W cs T) : ∃ S, W.Arrow cs T S :=
  match carries with
  | ⟨read, reads⟩ =>
    have at_ : ∀ n, read (W.config cs (T + n)) ≤ read (W.config cs (T + n + 1)) ∧
        (W.Changes cs (T + n) → read (W.config cs (T + n)) < read (W.config cs (T + n + 1))) :=
      fun n => ⟨Nat.le_trans (Nat.le_of_eq (reads n))
          (Nat.le_trans (L.history_mono cs T (Nat.le_succ n)) (Nat.le_of_eq (reads (n + 1)).symm)),
        fun changes => match Web.changes_member changes with
        | ⟨_, mem, moves⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq (reads n))
            (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (balances.exchanges_of_change mem moves))
              (Nat.le_of_eq ((steps_last (L.exchanges cs) T n).symm.trans (reads (n + 1)).symm)))⟩
    ⟨read, fun _ later => match le_dest later with
       | ⟨n, same⟩ => Eq.subst (motive := fun x => read (W.config cs x) ≤ read (W.config cs (x + 1)))
           same.symm (at_ n).1,
     fun _ later => match le_dest later with
       | ⟨n, same⟩ => Eq.subst (motive := fun x => W.Changes cs x →
           read (W.config cs x) < read (W.config cs (x + 1))) same.symm (at_ n).2⟩

end Flow

/-! ## Finite worlds -/

namespace World

variable {w : World}

/-- Rest without the least loss, in a finite world: where finitely many relata are all there
is, each embodied, and the flow balances and gains nothing, a world that from some step on
never revisits a configuration comes to rest: neither arising nor ceasing recurs. -/
theorem rests_of_never_revisits {all : List w.Relatum} (distinct : Distinct all)
    (every : ∀ x, x ∈ all) (embodied : w.Embodied) (balanced : w.Balanced)
    (gainless : w.flow.Gainless) {T : Nat} (never : ¬ w.web.Revisits all T) :
    ¬ w.ArisingRecurs ∧ ¬ w.CeasingRecurs :=
  have still := Flow.Balances.rests_of_never_revisits balanced
    (fun t _ => gainless all t distinct fun _ _ c out => absurd (every c) out) never
  ⟨fun arising => still fun N => match arising N with
     | ⟨t, x, later, arises⟩ =>
       ⟨t, later, Web.changes_of_member (every x) (.inl (rises_of_arises embodied arises))⟩,
   fun ceasing => still fun N => match ceasing N with
     | ⟨t, x, later, ceases⟩ =>
       ⟨t, later, Web.changes_of_member (every x) (.inr (falls_of_ceases embodied ceases))⟩⟩

/-- So, in a finite world under the first law, arising without end revisits a configuration
from every step on. -/
theorem arising_revisits {all : List w.Relatum} (distinct : Distinct all)
    (every : ∀ x, x ∈ all) (embodied : w.Embodied) (balanced : w.Balanced)
    (gainless : w.flow.Gainless) (arising : w.ArisingRecurs) (T : Nat) :
    ¬¬ w.web.Revisits all T :=
  fun never => (rests_of_never_revisits distinct every embodied balanced gainless never).1 arising

/-- Under dissipation a finite world never revisits a configuration. -/
theorem never_revisits {all : List w.Relatum} (distinct : Distinct all)
    (every : ∀ x, x ∈ all) (balanced : w.Balanced) (dissipative : w.Dissipative) (T : Nat) :
    ¬ w.web.Revisits all T :=
  Flow.Balances.never_revisits balanced fun t _ =>
    dissipative all t distinct fun _ _ c out => absurd (every c) out

/-- A finite world under the first law that keeps exchanging forgets: where finitely many
relata are all there is and the flow balances and gains nothing, if anything is exchanged at
arbitrarily late steps, from no step on does the world's configuration carry its history. -/
theorem forgets {all : List w.Relatum} (distinct : Distinct all) (every : ∀ x, x ∈ all)
    (balanced : w.Balanced) (gainless : w.flow.Gainless) (exchanging : w.flow.ExchangeRecurs)
    (T : Nat) : ¬ w.flow.CarriesHistory w.web all T :=
  fun carries => Flow.Balances.exchange_stops_of_carries balanced
    (fun t _ => gainless all t distinct fun _ _ c out => absurd (every c) out) carries
    fun M => match exchanging M with
    | ⟨t, _, c, later, present, exchanged⟩ =>
      ⟨t, later, Flow.exchanges_pos present (every c) exchanged⟩

/-- So in a finite world under the first law where arising recurs, no quantity of the
configuration of all relata is an arrow from any step on. -/
theorem no_arrow {all : List w.Relatum} (distinct : Distinct all)
    (every : ∀ x, x ∈ all) (embodied : w.Embodied) (balanced : w.Balanced)
    (gainless : w.flow.Gainless) (arising : w.ArisingRecurs) (T : Nat) (S : List Nat → Nat) :
    ¬ w.web.Arrow all T S :=
  fun arrow => arising_revisits distinct every embodied balanced gainless arising T
    (Web.never_revisits_of_arrow arrow)

end World

/-! ## A unit carried back and forth -/

namespace Passing

/-- One where the unit is, zero elsewhere. -/
def holds : Bool → Bool → Nat
  | true, true => 1
  | false, false => 1
  | true, false => 0
  | false, true => 0

/-- The side holding the unit at step `t`: `true` at the first step, the other side after
each step. -/
def side : Nat → Bool
  | 0 => true
  | t + 1 => !side t

/-- The carrier `none` stands at one throughout; a side `some b` stands at one while it holds
the unit. -/
def level (t : Nat) : Option Bool → Nat
  | none => 1
  | some b => holds b (side t)

/-- One unit at the side `s`, nothing at the carrier or the other side. -/
def at_ (s : Bool) : Option Bool → Nat
  | none => 0
  | some b => holds b s

/-- Across each step the carrier takes the unit from the side holding it and gives it to the
other. -/
def flow : Flow (Option Bool) (Option Bool) where
  present _ := [none]
  take t _ := at_ (side t)
  give t _ := at_ (!side t)

/-- What stands is active; nothing depends on anything. -/
def web : Web (Option Bool) (Option Bool) where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def world : World := World.of (Option Bool) flow web

/-- The carrier and both sides. -/
def all : List (Option Bool) := [none, some true, some false]

/-- One is not zero. -/
theorem one_ne_zero : ¬ (1 : Nat) = 0 := fun same => Nat.noConfusion same

theorem holds_self : ∀ b, holds b b = 1
  | true => rfl
  | false => rfl

theorem holds_not : ∀ b, holds (!b) b = 0
  | true => rfl
  | false => rfl

theorem holds_to_not : ∀ b, holds b (!b) = 0
  | true => rfl
  | false => rfl

theorem holds_pos : ∀ {a b : Bool}, 0 < holds a b → a = b
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, pos => absurd pos (Nat.lt_irrefl 0)
  | false, true, pos => absurd pos (Nat.lt_irrefl 0)

theorem every : ∀ x : Option Bool, x ∈ all
  | none => .head _
  | some true => .tail _ (.head _)
  | some false => .tail _ (.tail _ (.head _))

theorem distinct : Distinct all :=
  ⟨(fun mem => match mem with
    | .tail _ (.tail _ no) => nomatch no),
   ⟨(fun mem => match mem with
    | .tail _ no => nomatch no),
    ⟨fun no => (nomatch no), trivial⟩⟩⟩

theorem total_at_all : ∀ s, total all (at_ s) = 1
  | true => rfl
  | false => rfl

/-- Over a family without repetition holding the side `s`, one unit is at `s`. -/
theorem total_at {cs : List (Option Bool)} (distinct : Distinct cs) {s : Bool}
    (mem : some s ∈ cs) : total cs (at_ s) = 1 :=
  Nat.le_antisymm
    (Nat.le_trans (total_le_at (q := at_ s) (a := some s) (fun x positive => match x, positive with
        | none, positive => absurd positive (Nat.lt_irrefl 0)
        | some _, positive => congrArg some (holds_pos positive)) distinct)
      (Nat.le_of_eq (holds_self s)))
    (Nat.le_trans (Nat.le_of_eq (holds_self s).symm) (le_total_of_mem (q := at_ s) mem))

/-- A family outside which nothing is at `s` holds the side `s`. -/
theorem holds_side {cs : List (Option Bool)} {s : Bool}
    (zero : ∀ c, ¬ c ∈ cs → at_ s c = 0) : some s ∈ cs :=
  match decideMem (some s) cs with
  | .isTrue mem => mem
  | .isFalse out => absurd ((holds_self s).symm.trans (zero _ out)) one_ne_zero

theorem balances : flow.Balances web := fun t c => match c with
  | none => rfl
  | some b => Nat.add_comm (holds b (!side t)) (holds b (side t))

/-- Every family without repetition closed across a step loses nothing: it holds both sides,
and one unit is taken from one and given to the other. -/
theorem conserving : flow.Conserving := fun _ _ distinct closed f present =>
  (total_at distinct (holds_side fun c out => (closed f present c out).2)).trans
    (total_at distinct (holds_side fun c out => (closed f present c out).1)).symm

theorem closed (t : Nat) : flow.ClosedAt all t :=
  fun _ _ c out => absurd (every c) out

theorem reverses (t : Nat) : flow.Reverses (t + 1) t :=
  ⟨rfl, fun _ _ => rfl, fun _ c => congrArg (fun s => at_ s c) (ListTests.not_not (side t))⟩

theorem embodied : world.Embodied := fun _ _ => Iff.rfl

theorem mem_alive {b s : Bool} : some b ∈ [none, some s] → b = s
  | .tail _ (.head _) => rfl
  | .tail _ (.tail _ no) => nomatch no

theorem counted : world.Counted :=
  ⟨fun t => [none, some (side t)], fun t =>
    ⟨⟨(fun mem => match mem with
        | .tail _ no => nomatch no),
      ⟨fun no => (nomatch no), trivial⟩⟩,
     fun x => match x with
      | none => ⟨fun _ => .head _, fun _ => Nat.one_pos⟩
      | some _ => ⟨fun positive => Eq.subst (motive := fun y => some y ∈ [none, some (side t)])
            (holds_pos positive).symm (.tail _ (.head _)),
          fun mem => Eq.subst (motive := fun y => 0 < holds y (side t)) (mem_alive mem).symm
            (Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_of_eq (holds_self (side t)).symm))⟩⟩⟩

theorem config_back (T : Nat) : web.config all (T + 2) = web.config all T :=
  map_eq_of (fun x => match x with
    | none => rfl
    | some b => congrArg (holds b) (ListTests.not_not (side T))) all

theorem changes (T : Nat) : web.Changes all T := fun same =>
  one_ne_zero ((holds_self (side T)).symm.trans
    ((Web.level_of_config (W := web) same (every (some (side T)))).symm.trans
      (holds_to_not (side T))))

/-- The carrier's exchange across each step is one exchange with all three. -/
theorem exchanges_one (t : Nat) : flow.exchanges all t = 1 :=
  show sign (total all (at_ (side t)) + total all (at_ (!side t))) + 0 = 1 from
    congrArg (fun x => sign x + 0)
      ((congrArg (· + total all (at_ (!side t))) (total_at_all (side t))).trans
        (congrArg (1 + ·) (total_at_all (!side t))))

/-- The history of exchanges grows by one at every step, without end. -/
theorem history_grows (T N : Nat) : flow.exchangeCount all T N = N :=
  (total_congr exchanges_one (steps T N)).trans ((total_ones (steps T N)).trans (steps_length T N))

/-- The configuration of all three comes back every two steps, though it changes across
each. -/
theorem revisits (T : Nat) : web.Revisits all T :=
  ⟨T, T, T + 2, Nat.le_refl T, Nat.le_refl T, Nat.lt_succ_of_lt (Nat.lt_succ_self T),
   changes T, config_back T⟩

/-- A unit carried back and forth. The world is finite, its relata embodied and counted; its
flow balances and loses nothing, every step is enclosed, and the carrier's exchange across
each step is reversed across the next; arising and ceasing recur. The world revisits its
configuration every two steps; it is not dissipative; nothing is dissipated, while the
history of exchanges grows by one at every step. -/
theorem passes :
    world.Finite ∧ world.Embodied ∧ world.Counted ∧ world.Balanced ∧ flow.Conserving ∧
    (∀ t, flow.Enclosed t) ∧ (∀ t, flow.Reverses (t + 1) t) ∧
    world.ArisingRecurs ∧ world.CeasingRecurs ∧ (∀ T, web.Revisits all T) ∧
    ¬ world.Dissipative ∧ (∀ T N, flow.dissipated all T N = 0) ∧ (∀ t, flow.exchanges all t = 1) :=
  ⟨⟨all, distinct, every⟩, embodied, counted, balances, conserving,
   fun t => ⟨all, distinct, closed t⟩, reverses,
   fun N => ⟨N, some (!side N), Nat.le_refl N,
     fun active => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le active (Nat.le_of_eq (holds_not (side N)))),
     Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_of_eq (holds_self (!side N)).symm)⟩,
   fun N => ⟨N, some (side N), Nat.le_refl N,
     Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_of_eq (holds_self (side N)).symm),
     fun active => Nat.lt_irrefl 0
       (Nat.lt_of_lt_of_le active (Nat.le_of_eq (holds_to_not (side N))))⟩,
   revisits,
   fun dissipative => Nat.not_succ_le_self 1
     (dissipative all 0 distinct (closed 0) none (.head _)),
   fun _ N => Flow.dissipated_zero (fun t _ => conserving all t distinct (closed t)) N,
   exchanges_one⟩

/-- Both parts of the reading of dissipation are needed. Recording nothing, the family with
its record gains nothing, but the record misses every exchange; recording one unit for each
exchange, the record holds every exchange, but the family with its record gains. -/
theorem record_needs_both (t : Nat) :
    (flow.withRecord fun _ _ => 0).GainlessOn ((none : Option (Option Bool)) :: all.map some) t ∧
      ¬ flow.RecordsOn (fun _ _ => 0) all t ∧ flow.RecordsOn (fun _ _ => 1) all t ∧
      ¬ (flow.withRecord fun _ _ => 1).GainlessOn
        ((none : Option (Option Bool)) :: all.map some) t :=
  ⟨Flow.gainlessOn_withRecord_iff.mpr fun _ _ => Nat.le_of_eq
     ((total_at_all (!side t)).trans (total_at_all (side t)).symm),
   fun records => Nat.lt_irrefl 0 (records none (.head _)
     (Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_add_right_of_le
       (Nat.le_of_eq (total_at_all (side t)).symm)))),
   fun _ _ _ => Nat.one_pos,
   fun gainless => Nat.not_succ_le_self 1 (Nat.le_trans
     (Nat.le_of_eq (congrArg (· + 1) (total_at_all (!side t)).symm))
     (Nat.le_trans (Flow.gainlessOn_withRecord_iff.mp gainless none (.head _))
       (Nat.le_of_eq (total_at_all (side t)))))⟩

/-- So no quantity of the configuration is an arrow. -/
theorem no_arrow (T : Nat) (S : List Nat → Nat) : ¬ web.Arrow all T S :=
  fun arrow => Web.never_revisits_of_arrow arrow (revisits T)

/-- The sides exchanged: the carrier stays, the sides swap. -/
def swap : List Nat → List Nat
  | [] => []
  | [a] => [a]
  | [a, b] => [a, b]
  | a :: b :: c :: rest => a :: c :: b :: rest

theorem swap_side : ∀ s : Bool,
    ([1, holds true (!s), holds false (!s)] : List Nat) = [1, holds false s, holds true s]
  | true => rfl
  | false => rfl

/-- The change is a function of the configuration: the sides swap. -/
theorem determined : web.Determined all 0 swap :=
  fun t _ => swap_side (side t)

/-- Swapping merges none of the configurations it takes. -/
theorem apart : ¬ web.Merges all 0 swap :=
  fun ⟨t, _, changes, same⟩ => changes
    ((determined t (Nat.zero_le t)).trans (same.symm.trans
      ((determined (t + 1) (Nat.zero_le _)).symm.trans (config_back t))))

/-- Lossless becoming keeps its history and no arrow. Every exchange conserves exactly and is
reversed across the next step; the change is a function of the configuration merging none
of its configurations; the history of exchanges grows by one at every step without end,
while the configuration comes back every two steps and no quantity of it is an arrow. -/
theorem history_without_arrow :
    flow.Conserving ∧ (∀ t, flow.Reverses (t + 1) t) ∧ web.Determined all 0 swap ∧
    ¬ web.Merges all 0 swap ∧ (∀ T N, flow.exchangeCount all T N = N) ∧
    (∀ T, web.Revisits all T) ∧ ∀ T S, ¬ web.Arrow all T S :=
  ⟨conserving, reverses, determined, apart, history_grows, revisits, no_arrow⟩

end Passing

/-! ## One passing, then rest -/

namespace Entropy.Settling

open Passing (holds at_ all)

/-- Where the unit is at step `t`: at `true` at the first step, at `false` after it. -/
def settled : Nat → Bool := Witnesses.profile [true] false

/-- The carrier stands at one throughout; a side stands at one while it holds the unit. -/
def level (t : Nat) : Option Bool → Nat
  | none => 1
  | some b => holds b (settled t)

/-- The carrier passes the unit once, across the first step, and then takes no part. -/
def flow : Flow (Option Bool) (Option Bool) where
  present t := match t with
    | 0 => [none]
    | _ + 1 => []
  take _ _ := at_ true
  give _ _ := at_ false

/-- What stands is active; nothing depends on anything. -/
def web : Web (Option Bool) (Option Bool) where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def world : World := World.of (Option Bool) flow web

theorem balances : flow.Balances web := fun t c => match t, c with
  | 0, none => rfl
  | 0, some b => Nat.add_comm (holds b false) (holds b true)
  | _ + 1, _ => rfl

theorem conserving : flow.Conserving := fun _ t distinct closed f present => match t, present with
  | 0, present =>
    (Passing.total_at distinct (Passing.holds_side fun c out => (closed f present c out).2)).trans
      (Passing.total_at distinct (Passing.holds_side fun c out => (closed f present c out).1)).symm

theorem closed (t : Nat) : flow.ClosedAt all t :=
  fun _ _ c out => absurd (Passing.every c) out

/-- The configuration of all three changes across the first step. -/
theorem changed : web.Changes all 0 := fun same =>
  Passing.one_ne_zero (Web.level_of_config (W := web) same (Passing.every (some false)))

/-- Every configuration goes to the settled one. -/
def rest : List Nat → List Nat := fun _ => [1, 0, 1]

/-- The level of the third member. -/
def third : List Nat → Nat
  | [] => 0
  | [_] => 0
  | [_, _] => 0
  | _ :: _ :: c :: _ => c

/-- Coming to rest merges. The change is a function of the configuration, which sends the
configuration before the passing and the one after it to the same; the level of the side
receiving the unit is an arrow, rising once. -/
theorem merges :
    web.Determined all 0 rest ∧ web.Merges all 0 rest ∧ web.Arrow all 0 third :=
  ⟨fun _ _ => rfl, ⟨0, Nat.le_refl 0, changed, rfl⟩,
   fun t _ => match t with
     | 0 => Nat.zero_le 1
     | _ + 1 => Nat.le_refl 1,
   fun t _ changes => match t, changes with
     | 0, _ => Nat.one_pos
     | _ + 1, changes => absurd rfl changes⟩

/-- One passing, then rest. The world's relata are embodied, its flow balances and loses
nothing, every step is enclosed, and its configuration changes across the first step; it
never revisits a configuration and is not dissipative; neither arising nor ceasing recurs, by
`World.rests_of_never_revisits`. Never revisiting brings rest without the least loss. -/
theorem settles :
    world.Embodied ∧ world.Balanced ∧ flow.Conserving ∧ (∀ t, flow.Enclosed t) ∧
    web.Changes all 0 ∧ ¬ web.Revisits all 0 ∧ ¬ world.Dissipative ∧
    ¬ world.ArisingRecurs ∧ ¬ world.CeasingRecurs :=
  have never : ¬ web.Revisits all 0 := fun ⟨s, v, u, _, sv, vu, changes, same⟩ =>
    match v, sv, vu, changes with
    | 0, sv, vu, _ => match u, vu with
      | _ + 1, _ =>
        have start : s = 0 := Nat.eq_zero_of_le_zero sv
        Passing.one_ne_zero (Eq.subst (motive := fun x => web.level x (some true) = 1) start.symm
          (rfl : web.level 0 (some true) = 1) |>.symm.trans
          (Web.level_of_config (W := web) same (Passing.every (some true))).symm)
    | _ + 1, _, _, changes => changes rfl
  ⟨fun _ _ => Iff.rfl, balances, conserving, fun t => ⟨all, Passing.distinct, closed t⟩,
   changed, never,
   fun dissipative => Nat.not_succ_le_self 1
     (dissipative all 0 Passing.distinct (closed 0) none (.head _)),
   (World.rests_of_never_revisits (w := world) Passing.distinct Passing.every
      (fun _ _ => Iff.rfl) balances conserving.gainless never).1,
   (World.rests_of_never_revisits (w := world) Passing.distinct Passing.every
      (fun _ _ => Iff.rfl) balances conserving.gainless never).2⟩

end Entropy.Settling

/-! ## A record gathered from beyond -/

namespace Gathering

/-- One unit at `a`, nothing elsewhere. -/
def unit (a x : Nat) : Nat := mark (x = a)

/-- The record `0` stands at the number of steps taken; each other relatum `k + 1` holds one
unit until step `k`, when it is gathered. -/
def level (t : Nat) : Nat → Nat
  | 0 => t
  | k + 1 => mark (t ≤ k)

/-- Across each step the record takes the unit from the relatum `t + 1` and gives it to
itself. -/
def flow : Flow Nat Nat where
  present _ := [0]
  take t _ := unit (t + 1)
  give _ _ := unit 0

/-- What stands is active; nothing depends on anything. -/
def web : Web Nat Nat where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def world : World := World.of Nat flow web

theorem unit_self (a : Nat) : unit a a = 1 := mark_one rfl

theorem unit_off {a x : Nat} (other : ¬ x = a) : unit a x = 0 := mark_zero other

theorem succ_not_zero {n : Nat} : ¬ n + 1 = 0 := fun same => Nat.noConfusion same

/-- Over a family without repetition holding `a`, one unit is at `a`. -/
theorem total_unit {cs : List Nat} (distinct : Distinct cs) {a : Nat} (mem : a ∈ cs) :
    total cs (unit a) = 1 :=
  Nat.le_antisymm
    (Nat.le_trans (total_le_at (q := unit a) (a := a) (fun _ positive => mark_pos.mp positive)
        distinct) (Nat.le_of_eq (unit_self a)))
    (Nat.le_trans (Nat.le_of_eq (unit_self a).symm) (le_total_of_mem (q := unit a) mem))

/-- A family outside which nothing is at `a` holds `a`. -/
theorem unit_mem {cs : List Nat} {a : Nat} (zero : ∀ c, ¬ c ∈ cs → unit a c = 0) : a ∈ cs :=
  match decideMem a cs with
  | .isTrue mem => mem
  | .isFalse out => absurd ((unit_self a).symm.trans (zero _ out)) Passing.one_ne_zero

/-- Four equalities carry one sum to another. -/
theorem sums_eq {x₁ x₂ x₃ x₄ y₁ y₂ y₃ y₄ : Nat} (e₁ : x₁ = y₁) (e₂ : x₂ = y₂) (e₃ : x₃ = y₃)
    (e₄ : x₄ = y₄) (same : y₁ + y₂ = y₃ + y₄) : x₁ + x₂ = x₃ + x₄ :=
  (congrArg (· + x₂) e₁).trans ((congrArg (y₁ + ·) e₂).trans (same.trans
    ((congrArg (· + y₄) e₃.symm).trans (congrArg (x₃ + ·) e₄.symm))))

theorem balances : flow.Balances web := fun t c => match c with
  | 0 => sums_eq (x₁ := t + 1) (y₁ := t + 1) rfl
      (unit_off (a := t + 1) (x := 0) fun same => succ_not_zero same.symm)
      (x₃ := t) (y₃ := t) rfl (unit_self 0) rfl
  | k + 1 =>
    have outside : unit 0 (k + 1) = 0 := unit_off succ_not_zero
    match Nat.lt_or_ge t k with
    | .inl before => sums_eq (y₁ := 1) (y₂ := 0) (y₃ := 1) (y₄ := 0)
        (mark_one before)
        (unit_off (a := t + 1) (x := k + 1) fun same =>
          Nat.lt_irrefl t (Eq.subst (motive := fun x => t < x) (Nat.succ.inj same) before))
        (mark_one (Nat.le_of_lt before)) outside rfl
    | .inr after => match Nat.eq_or_lt_of_le after with
      | .inl now => sums_eq (y₁ := 0) (y₂ := 1) (y₃ := 1) (y₄ := 0)
          (mark_zero fun le => Nat.not_succ_le_self t
            (Eq.subst (motive := fun x => t + 1 ≤ x) now le))
          (mark_one (p := k + 1 = t + 1) (congrArg (· + 1) now))
          (mark_one (Nat.le_of_eq now.symm)) outside rfl
      | .inr gone => sums_eq (y₁ := 0) (y₂ := 0) (y₃ := 0) (y₄ := 0)
          (mark_zero fun le => Nat.not_succ_le_self k
            (Nat.le_trans gone (Nat.le_trans (Nat.le_succ t) le)))
          (unit_off (a := t + 1) (x := k + 1) fun same =>
            Nat.lt_irrefl k (Eq.subst (motive := fun x => k < x) (Nat.succ.inj same).symm gone))
          (mark_zero fun le => Nat.lt_irrefl k (Nat.lt_of_lt_of_le gone le)) outside rfl

/-- Every family without repetition closed across a step loses nothing: it holds the relatum
gathered from and the record, and one unit passes from the one to the other. -/
theorem conserving : flow.Conserving := fun _ _ distinct closed f present =>
  (total_unit distinct (unit_mem fun c out => (closed f present c out).2)).trans
    (total_unit distinct (unit_mem fun c out => (closed f present c out).1)).symm

/-- Every step is enclosed by the record and the relatum it gathers from. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  ⟨[0, t + 1],
   ⟨(fun mem => match mem with
      | .tail _ no => nomatch no),
    ⟨fun no => (nomatch no), trivial⟩⟩,
   fun _ _ c out =>
     ⟨unit_off (a := t + 1) (x := c) fun same => out
        (Eq.subst (motive := fun x => x ∈ [0, t + 1]) same.symm (.tail _ (.head _))),
      unit_off (a := 0) (x := c) fun same => out (Eq.subst (motive := fun x => x ∈ [0, t + 1]) same.symm
        (.head _))⟩⟩

/-- A record gathered from beyond. Every exchange conserves exactly, every step is enclosed
and the exchange recurs; the record's level is an arrow from the start, rising at every
step without end. The record gains at every step, by exchange with relata beyond it, and
the world is not finite. So the premises of `Flow.Balances.no_arrow` that the family gains
nothing and of `World.no_arrow` that the world is finite do work: an arrow rising forever
under exact conservation draws from beyond what it holds. -/
theorem gathers :
    world.Balanced ∧ flow.Conserving ∧ (∀ t, flow.Enclosed t) ∧ flow.ExchangeRecurs ∧
    web.Arrow [0] 0 (fun l => total l fun x => x) ∧ (∀ t, ¬ flow.GainlessOn [0] t) ∧
    ¬ world.Finite :=
  ⟨balances, conserving, enclosed,
   fun N => ⟨N, 0, 0, Nat.le_refl N, .head _,
     .inr (Nat.lt_of_lt_of_le Nat.one_pos (Nat.le_of_eq (unit_self 0).symm))⟩,
   ⟨fun t _ => show t + 0 ≤ t + 1 + 0 from Nat.le_succ t,
    fun t _ _ => show t + 0 < t + 1 + 0 from Nat.lt_succ_self t⟩,
   fun t gainless => Nat.not_succ_le_zero 0 (Nat.le_trans
     (Nat.le_of_eq (congrArg (· + 0) (unit_self 0)).symm)
     (Nat.le_trans (gainless 0 (.head _))
       (Nat.le_of_eq (unit_off (a := t + 1) (x := 0) fun same => succ_not_zero same.symm)))),
   fun ⟨all, _, every⟩ => beyond_not_mem all (every (beyond all))⟩

end Gathering

end Becoming

section LevelWebs

/-!
## Level webs: laws of a condition's level and a family's configuration on a web

`Becoming.Change` states that an amount never rising from some step on does not fall at
arbitrarily late steps (`falls_not_recurring_from_floor`); `Becoming.Space` states that it staying
the same from some step on cannot be refuted (`amount_still_unrefuted`); `Becoming.Population`
states that a count balanced across each step is balanced over any stretch
(`balance_over_stretch`); `Becoming.Entropy` lists each way `K` units fall into `n` members exactly
once (`configurations_exact`). A web carries the amounts these laws are about: the level of a
condition at each step (`Web.level`), and a family's configuration, the level of each member
(`Web.config`); a balanced flow changes each level by what it takes and gives. This section states
those laws of a web's levels and proves them through the general laws.

* **A level with a floor.** A condition's level that never rises from some step on does not fall
  at arbitrarily late steps (`level_falls_not_recurring`), and that it stays the same from some step
  on cannot be refuted (`level_still_unrefuted`); no decidedness is needed.
* **A balanced level over a stretch.** In a balanced flow, a condition's level at the end of any
  stretch with everything taken from it is its level at the start with everything given to it
  (`Balances.level_over_stretch`).
* **A family's configuration among the configurations.** A family's configuration is among the
  configurations of its members totalling `K` exactly when its stock is `K`
  (`config_mem_iff`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace LevelWebs

variable {F C : Type}

/-- **A level that never rises from some step on does not fall at arbitrarily late steps.** -/
theorem level_falls_not_recurring {W : Web F C} {c : C} {T : Nat}
    (still : ∀ n, T ≤ n → ¬ W.Rises n c) : ¬ ∀ N, ∃ n, N ≤ n ∧ W.Falls n c :=
  falls_not_recurring (fun t => W.level t c) T
    fun n later => Nat.ge_of_not_lt (still n later)

/-- **That a level never rising from some step on stays the same from some step on cannot be
refuted.** No decidedness is needed. -/
theorem level_still_unrefuted {W : Web F C} {c : C} {T : Nat}
    (still : ∀ n, T ≤ n → ¬ W.Rises n c) :
    ¬ ¬ ∃ M, T ≤ M ∧ ∀ t, M ≤ t → W.level (t + 1) c = W.level t c :=
  amount_still_unrefuted (q := fun t => W.level t c)
    fun n later => Nat.ge_of_not_lt (still n later)

/-- **A balanced level over a stretch.** In a balanced flow, over any stretch, a condition's level
at the end with everything taken from it is its level at the start with everything given to it. -/
theorem Balances.level_over_stretch {L : Flow F C} {W : Web F C} (balances : L.Balances W)
    (c : C) (S n : Nat) :
    W.level (S + n) c + total (steps S n) (fun t => L.taken t c) =
      W.level S c + total (steps S n) (fun t => L.given t c) :=
  balance_over_stretch (q := fun t => W.level t c) (fun t => balances t c) S n

/-- **A family's configuration is among the configurations totalling `K` exactly when its stock is
`K`.** -/
theorem config_mem_iff (W : Web F C) (cs : List C) (t K : Nat) :
    W.config cs t ∈ configurations cs.length K ↔ W.stock cs t = K :=
  ((configurations_exact cs.length K).2 (W.config cs t)).trans
    ⟨fun ⟨_, sum⟩ => (W.config_total cs t).symm.trans sum,
     fun same => ⟨length_map (W.level t) cs, (W.config_total cs t).trans same⟩⟩

end LevelWebs

end Becoming

end LevelWebs
