import Becoming.Counting

/-!
# Standing: what the premises add to counting what stands and what depends

`Becoming.Counting` states what the premises add to the law of counting for the counts of a
census of activity. This module states it for the two other listings of `Becoming.Population`:
the counts of what stands (`Web.StandingCensus`), how many relata stand at each step and how
many cease to stand and come to stand across it, and the counts of what depends
(`Web.DependenceCensus`), how many dependences hold at each step and how many dissolve and
form across it.

* **Counting what stands.** Where every relatum is embodied, what stands is what is active,
  so the counts of the two censuses satisfy the same properties (`World.Embodied.standingMarksHold_iff`).
  Where embodiment is not selected, a queue whose members stand while in it and are never
  active, fed by a ground relatum active throughout and standing at nothing, which exchanges
  a unit each way with every ground relatum, meets every other premise whatever its counts
  (`World.sourcedQueue_holds`). So under each selection the laws of counting what stands are
  those of counting what is active (`World.standing_counting_under`,
  `World.standing_iff_counting`): the tally, and nothing coming to stand across a step at
  which nothing stands exactly where the selection binds counting
  (`World.standing_binds_iff`).
* **Enclosure bounds what stands under balance and dissipation alone.** With every step from
  `T` on enclosed, a balanced, dissipative flow keeps the total standing at `T` a bound on
  the change of any census of what stands from `T` (`World.enclosure_bounds_standing`), and
  nothing comes to stand across an enclosed step at which nothing stands
  (`World.enclosed_binds_standing`). No premise on activity is needed: what the flow takes
  and gives is standing. So in worlds enclosed from some step on, the laws of counting what stands under
  each selection are those of counting what is active (`World.enclosed_counting_under`) with
  embodiment dropped from the condition for a change bound: the tally, nothing coming to
  stand across a step at which nothing stands where the selection binds counting, and, where
  balance and dissipation are selected, from some step on change within a bound and nothing
  coming to stand across a step at which nothing stands
  (`World.enclosed_standing_counting_under`, `World.enclosed_standing_bound_iff`). Embodiment
  is what carries the bound from what stands to what is active. Where balance is selected
  without embodiment, the witnesses are waiting queues: closing queues whose next to join is
  active before it comes to stand, so that the front is active at every step, even with the
  queue empty (`World.waitingQueue_holds`). Closing at the first step, a waiting queue is
  enclosed at every step and meets every premise but dissipation and embodiment; closing at
  `T`, with a change bound from `T` and nothing joining an empty queue from `T` on, every
  premise but embodiment.
* **In finite worlds.** Every step of a finite world is enclosed, so there balance and
  dissipation bind what stands by themselves. Under each selection the laws of counting what
  stands in finite worlds are those of a tally with at most some number standing at each
  step, nothing coming to stand across a step at which nothing stands where the selection
  binds counting or selects balance and dissipation, and a change bound from the first step
  where it selects balance and dissipation (`World.finite_standing_counting_under`,
  `World.finite_standing_binds_iff`, `World.finite_standing_bound_iff`). The new witness is
  a ring each of whose places is active throughout and stands while held
  (`World.activeRing_holds`), meeting every premise but dissipation and embodiment.
* **Counting what depends.** The premises add nothing to the law of counting dependences:
  under each selection, in every world, in worlds enclosed from some step on and in finite
  worlds, a property of the counts of a census of dependences holds exactly when it holds of
  every tally, at most some number holding at each step in finite worlds
  (`World.dependence_counting`, `World.enclosed_dependence_counting`,
  `World.finite_dependence_counting`). Members of a queue, or places of a ring, depending
  while in it on a common condition, each needing a unit of it, which stands at one and is
  active throughout, with nothing flowing, meet all eight premises whatever the counts, every
  dependence met (`World.dependingQueue_premised`, `World.dependingRing_premised`). The premises bear on dependence only together with
  activity, standing and descent: activity needing support asks only that what an active
  relatum depends on supports it, and bounded transmission only that what a descendant depends
  on as it comes to stand its parent depended on, within a bound.

Each law is a census table of `Becoming.CensusTable` (`World.table_marks_hold`) for the listing of
what stands (`fun w x t => 0 < w.web.level t x`) or of what depends (pairs of relata,
`requires`): a counted soundness (`World.standing_counting_under_sound`,
`World.enclosed_standing_counting_under_sound`, `World.finite_standing_counting_under_sound`,
`World.finite_dependence_counting_sound`, with the counted binding steps
`World.enclosure_bounds_standing_counted` and `World.standing_of_coming_enclosed`) and a witness
lemma (`…_witnessed`; where embodiment is selected, those of counting what is active, read on
what stands, `World.WitnessedAt.congr`). Where the premises bind is not stated here for what
stands or what depends; `Becoming.Counting`
states it for activity. A property of the counts respects their values at each step
(`Pointwise`). Requiring is supposed decidable where the counts of dependences are taken. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {α : Type}

/-! ## Lists -/

/-- Every pair of a member of one list and a member of another. -/
def pairs {β : Type} : List α → List β → List (α × β)
  | [], _ => []
  | a :: l, m => m.map (Prod.mk a) ++ pairs l m

theorem mem_pairs {β : Type} {a : α} {b : β} :
    ∀ {l : List α} {m : List β}, a ∈ l → b ∈ m → (a, b) ∈ pairs l m
  | _ :: _, _, .head _, mem => mem_append_of_left _ (mem_map_of mem)
  | _ :: _, _, .tail _ listed, mem => mem_append_of_right _ (mem_pairs listed mem)

/-! ## Counting what stands -/

variable {F C : Type} {w : World} {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}

namespace World

/-- `Q` holds of the counts of every census of what stands in the world: how many relata
stand at each step, how many cease to stand and how many come to stand across it. -/
def StandingMarksHold (w : World) (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ stand, w.web.StandingCensus stand → Q (fun t => (stand t).length)
    (fun t => ceasings (stand t) (fun x s => 0 < w.web.level s x) t)
    (fun t => comings (stand (t + 1)) (fun x s => 0 < w.web.level s x) t)

/-- Where every relatum is embodied, standing decides activity. -/
def Embodied.decided (embodied : w.Embodied) : ∀ t x, Decidable (w.web.active t x) :=
  fun t x => decidable_of_iff _ (embodied x t).symm

/-- Where every relatum is embodied, what stands is what is active: a census of what stands
is a census of activity and conversely, with the same counts, so the counts of the two satisfy
the same properties. -/
theorem Embodied.standingMarksHold_iff [decided : ∀ t x, Decidable (w.web.active t x)]
    (embodied : w.Embodied) (pointwise : Pointwise Q) : w.StandingMarksHold Q ↔ w.CensusMarksHold Q :=
  have same : ∀ (l : Nat → List w.Relatum) t,
      ceasings (l t) (fun x s => 0 < w.web.level s x) t =
        ceasings (l t) (fun x s => w.web.active s x) t ∧
      comings (l (t + 1)) (fun x s => 0 < w.web.level s x) t =
        comings (l (t + 1)) (fun x s => w.web.active s x) t := fun _ t =>
    ⟨ceasings_congr _ fun x => ⟨(embodied x t).symm, (embodied x (t + 1)).symm⟩,
     comings_congr _ fun x => ⟨(embodied x t).symm, (embodied x (t + 1)).symm⟩⟩
  ⟨fun marks alive census => pointwise (fun t => ⟨rfl, (same alive t).1, (same alive t).2⟩)
      (marks alive (standingCensus census embodied)),
   fun marks stand standing => pointwise
      (fun t => ⟨rfl, (same stand t).1.symm, (same stand t).2.symm⟩)
      (marks stand fun t => ⟨(standing t).1, fun x => (embodied x t).trans ((standing t).2 x)⟩)⟩

end World

/-! ## A queue fed from a source -/

namespace OpenQueue

/-- The members of a queue standing while in it and never active, and the ground relatum `0`
active throughout, standing at nothing. -/
def sourced (n c : Nat → Nat) : Web Relatum Relatum :=
  { web n c with active := fun _ x => match x with
      | .ground 0 => True
      | .ground (_ + 1) => False
      | .member _ => False }

end OpenQueue

namespace World

/-- A queue fed from a source: the driven queue (`drivenQueue`), its driver active throughout
and standing at nothing, its members standing while in the queue and never active. -/
def sourcedQueue (n c : Nat → Nat) : World :=
  World.of OpenQueue.Relatum (OpenQueue.driven n c) (OpenQueue.sourced n c)

/-- Whatever its counts, a queue fed from a source meets every premise but embodiment: it
balances, only its source gives and takes, and it is active, and no family is closed across
any step, so it dissipates. -/
theorem sourcedQueue_holds (n c : Nat → Nat) :
    (sourcedQueue n c).Dependent ∧ (sourcedQueue n c).Balanced ∧ (sourcedQueue n c).Acting ∧
      (sourcedQueue n c).Taking ∧ (sourcedQueue n c).Dissipative ∧
      (sourcedQueue n c).Counted ∧ (sourcedQueue n c).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no),
   fun t x => match x with
    | .member k => mark_turn (Queue.holds n c k t) (Queue.holds n c k (t + 1))
    | .ground _ => rfl,
   fun _ f _ present _ => match f, present with
    | _, .head _ => trivial
    | _, .tail _ no => (nomatch no),
   fun _ f _ present _ => match f, present with
    | _, .head _ => ⟨trivial, trivial⟩
    | _, .tail _ no => (nomatch no),
   fun cs _ _ closed => absurd (closed _ (.head _) _ (OpenQueue.outside cs)).2
     (fun no => Nat.noConfusion no),
   ⟨fun _ => [.ground 0], fun _ => ⟨⟨(fun no => nomatch no), trivial⟩, fun x => match x with
      | .ground 0 => ⟨fun _ => .head _, fun _ => trivial⟩
      | .ground (_ + 1) => ⟨False.elim, fun mem => match mem with
          | .tail _ no => nomatch no⟩
      | .member _ => ⟨False.elim, fun mem => match mem with
          | .tail _ no => nomatch no⟩⟩⟩,
   ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩⟩

/-- A queue fed from a source meets every selection without embodiment. -/
theorem sourcedQueue_meets (n c : Nat → Nat) {S : Premise → Bool}
    (free : S .embodied = false) : (sourcedQueue n c).Meets S :=
  match sourcedQueue_holds n c with
  | ⟨dependent, balanced, acting, taking, dissipative, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, _ => dissipative
    | .embodied, selected => nomatch free.symm.trans selected
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- What stands in a queue fed from a source is its members, listed as the queue lists
them. -/
theorem sourcedQueue_standing (n c : Nat → Nat) :
    (sourcedQueue n c).web.StandingCensus fun t => (Queue.line n c t).map .member :=
  fun t => ⟨(openQueue_census n c t).1, fun x => match x with
    | .member k => mark_pos.trans ((openQueue_census n c t).2 (.member k))
    | .ground _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0),
        fun mem => absurd mem OpenQueue.ground_not_member⟩⟩

/-- It counts what the queue counts. -/
theorem sourcedQueue_counts {n c a : Nat → Nat} (tally : Tally n c a) (t : Nat) :
    ((Queue.line n c t).map OpenQueue.Relatum.member).length = n t ∧
      ceasings ((Queue.line n c t).map .member)
        (fun x s => 0 < (sourcedQueue n c).web.level s x) t = c t ∧
      comings ((Queue.line n c (t + 1)).map .member)
        (fun x s => 0 < (sourcedQueue n c).web.level s x) t = a t :=
  have same : ∀ x : OpenQueue.Relatum, ∀ s, 0 < (sourcedQueue n c).web.level s x ↔
      (openQueue n c).web.active s x := fun x _ => match x with
    | .member _ => mark_pos
    | .ground _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), False.elim⟩
  ⟨(openQueue_counts tally t).1,
   (ceasings_congr (q := fun x s => (openQueue n c).web.active s x) _
     fun x => ⟨same x t, same x (t + 1)⟩).trans (openQueue_counts tally t).2.1,
   (comings_congr (q := fun x s => (openQueue n c).web.active s x) _
     fun x => ⟨same x t, same x (t + 1)⟩).trans
     (openQueue_counts tally t).2.2⟩

/-- **What a selection binds on what stands, for every counted census**: where it binds counting,
embodiment is selected, so what stands is what is active, and nothing comes to stand across a
step at which nothing stands (`counting_under_sound`). -/
theorem standing_counting_under_sound (S : Premise → Bool) (w : World) (meets : w.Meets S) :
    w.ListingHolds (fun w x t => 0 < w.web.level t x)
      fun n _ a => BindsCounting S → ∀ t, 0 < a t → 0 < n t :=
  fun l n c a listed counted binds =>
    have same : ∀ x t, 0 < w.web.level t x ↔ w.web.active t x := fun x t =>
      (meets _ binds.2.1 x t).symm
    counting_under_sound S w meets l n c a (listed.congr same) (counted.congr same) binds

/-- **The witnesses on what stands under each selection**: where embodiment is selected, those of
counting what is active (`counting_under_witnessed`), what stands being what is active; where it
is not, a queue fed from a source. -/
theorem standing_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => 0 < w.web.level t x) (·.Meets S)
      fun n _ a => BindsCounting S → ∀ t, 0 < a t → 0 < n t :=
  fun n c a tally quiet => match he : S .embodied with
  | true => (counting_under_witnessed S n c a tally quiet).congr fun _ meets x t =>
      meets _ he x t
  | false => ⟨sourcedQueue n c, fun _ _ => inferInstance, _, sourcedQueue_meets n c he,
      sourcedQueue_standing n c, sourcedQueue_counts tally⟩

/-- The laws of counting what stands under each selection of the premises are those of
counting what is active (`counting_under`): a property of the counts holds of every census of
what stands in every world meeting the selection exactly when it holds of every tally, and,
where the selection binds counting, of every tally in which nothing comes to stand across a
step at which nothing stands. Where embodiment is selected, what stands is what is active;
where it is not, a queue fed from a source counts every tally. -/
theorem standing_counting_under (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) → Q n c a) ↔
      ∀ w : World, w.Meets S → w.StandingMarksHold Q :=
  have table := table_marks_hold pointwise (standing_counting_under_sound S)
    (standing_counting_under_witnessed S)
  ⟨fun law w meets => table.mp law w meets,
   fun law => table.mpr fun _ _ meets => listingMarksHold_of_marksHold pointwise (law _ meets)⟩

/-- So under each selection, a property holds of the counts of what stands in every world
meeting it exactly when it holds of the counts of what is active in every such world. -/
theorem standing_iff_counting (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ w : World, w.Meets S → w.StandingMarksHold Q) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.CensusMarksHold Q :=
  (standing_counting_under S pointwise).symm.trans (counting_under S pointwise)

/-- Nothing coming to stand across a step at which nothing stands is a law of counting what
stands under a selection exactly when the selection binds counting. -/
theorem standing_binds_iff (S : Premise → Bool) :
    (∀ w : World, w.Meets S → w.StandingMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ↔
      BindsCounting S :=
  (standing_iff_counting S fun same law t pos => Nat.lt_of_lt_of_le (law t
    (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2.symm))) (Nat.le_of_eq (same t).1)).trans
    (counting_binds_iff S)

/-! ## Counting what stands under enclosure -/

/-- **Enclosure bounds what stands, for every counted census**: under balance and dissipation,
with every step from `T` on enclosed, the total standing at `T` bounds the change of any counts
of a census of what stands from `T`. -/
theorem enclosure_bounds_standing_counted {stand : Nat → List w.Relatum}
    (census : w.web.StandingCensus stand) {n c a : Nat → Nat}
    (counted : FamilyCounts (fun x s => 0 < w.web.level s x) stand n c a)
    (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) :
    ChangeBound T (w.web.stock (stand T) T) n c a :=
  Flow.runsDown_change_bound census
    (fun t later down => (enclosed t later).aroundStanding_not_not stand fun around =>
      down (around.runsDownClosed balanced dissipative census).runsDown)
    (fun t _ => Nat.le_trans (Nat.le_of_eq (counted t).1) (census.length_le_stock t))
    fun t _ changes => match counted t with
    | ⟨_, ceased, came⟩ => match Nat.eq_zero_or_pos (c t) with
      | .inr ceasing => match ceased.exists_of_pos ceasing with
        | ⟨x, _, ceases⟩ => ⟨x, .inr (Nat.lt_of_le_of_lt (Nat.le_of_eq
            (eq_zero_of_not_pos ceases.2)) ceases.1)⟩
      | .inl still => match came.exists_of_pos (Nat.lt_of_lt_of_le changes (Nat.le_of_eq
          ((congrArg (· + a t) still).trans (Nat.zero_add _)))) with
        | ⟨x, _, comes⟩ => ⟨x, .inl (Web.ComesToStand.rises (W := w.web) comes)⟩

/-- Enclosure bounds what stands, with no premise on activity. With a balanced, dissipative
flow and every step from `T` on enclosed, the total standing at `T` bounds the change of any
census of what stands from `T`: what stands at any later step, with the steps since `T` at
which something came to stand or ceased to stand, numbers at most that total. The corollary
of `Flow.runsDown_change_bound`, with no embodiment needed. -/
theorem enclosure_bounds_standing {stand : Nat → List w.Relatum}
    (census : w.web.StandingCensus stand) (balanced : w.Balanced) (dissipative : w.Dissipative)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) :
    ChangeBound T (w.web.stock (stand T) T) (fun t => (stand t).length)
      (fun t => ceasings (stand t) (fun x s => 0 < w.web.level s x) t)
      (fun t => comings (stand (t + 1)) (fun x s => 0 < w.web.level s x) t) :=
  enclosure_bounds_standing_counted census (familyCounts_decided stand) balanced dissipative
    enclosed

/-- At an enclosed step, under balance and dissipation, something coming to stand across the
step needs something standing at it, whatever is active. -/
theorem standing_of_coming_enclosed (balanced : w.Balanced) (dissipative : w.Dissipative)
    {stand : Nat → List w.Relatum} (census : w.web.StandingCensus stand) {t : Nat}
    (enclosed : w.flow.Enclosed t) {x : w.Relatum}
    (comes : ComesToBe (fun s => 0 < w.web.level s x) t) : 0 < (stand t).length :=
  match Nat.eq_zero_or_pos (stand t).length, enclosed with
  | .inr pos, _ => pos
  | .inl empty, ⟨cs, distinct, closed⟩ =>
    have nowhere : ∀ c, ¬ 0 < w.web.level t c := fun c stands =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (total_pos_of_mem (((census t).2 c).mp stands) Nat.zero_lt_one)
        (Nat.le_of_eq (total_ones (stand t)))) (Nat.le_of_eq empty))
    have nothing : w.web.stock cs t = 0 :=
      total_eq_zero fun c _ => eq_zero_of_not_pos (nowhere c)
    have comes : w.web.ComesToStand t x := comes
    match total_pos _ (Flow.Balances.rise_given balanced comes.rises) with
    | ⟨f, present, gives⟩ =>
      absurd (fun mem => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          ((balanced.on cs t).comes_from_standing (dissipative cs t distinct closed) mem comes)
          (Nat.le_of_eq nothing)))
        fun out => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives
          (Nat.le_of_eq (closed f present x out).2))

/-- Under balance and dissipation nothing comes to stand across an enclosed step at which
nothing stands, whatever is active: a closed family's stock is nothing there, and nothing
comes to stand from nothing (`Flow.BalancesOn.comes_from_standing`). -/
theorem enclosed_binds_standing (balanced : w.Balanced) (dissipative : w.Dissipative)
    {stand : Nat → List w.Relatum} (census : w.web.StandingCensus stand) {t : Nat}
    (enclosed : w.flow.Enclosed t)
    (coming : 0 < comings (stand (t + 1)) (fun x s => 0 < w.web.level s x) t) :
    0 < (stand t).length :=
  match total_pos _ coming with
  | ⟨_, _, comes⟩ => standing_of_coming_enclosed balanced dissipative census enclosed
      (mark_pos.mp comes)

/-- A selection bounds what stands under enclosure when it selects balance and
dissipation. -/
def BoundsStanding (S : Premise → Bool) : Prop :=
  S .balanced = true ∧ S .dissipative = true

end World

/-! ## A waiting queue -/

/-- The enclosed queue's web with the next to join active before it stands: the members in the
queue and the next to join are active, so that the front is active at every step. -/
def EnclosedQueue.waiting (n c a : Nat → Nat) (B : Nat) : Web Nat Nat :=
  { EnclosedQueue.web n c a B with active := fun t k => Queue.holds (fun s => n s + 1) c k t }

/-- The front of a waiting queue is active at every step, even with the queue empty. -/
theorem EnclosedQueue.waiting_front (n c : Nat → Nat) (t : Nat) :
    Queue.holds (fun s => n s + 1) c (Queue.gone c t) t :=
  OpenQueue.front.mpr (Nat.succ_pos (n t))

namespace World

/-- A waiting queue: a closing queue (`closingQueue`) whose next to join is active before it
comes to stand. -/
def waitingQueue (n c a : Nat → Nat) (B T : Nat) : World :=
  World.of Nat (EnclosedQueue.closing n c a B T) (EnclosedQueue.waiting n c a B)

variable {n c a : Nat → Nat} {B T : Nat}

/-- Whatever its counts, a waiting queue meets activity needing support, balance, only active
relata giving and taking, a census and bounded transmission. -/
theorem waitingQueue_holds (n c a : Nat → Nat) (B T : Nat) :
    (waitingQueue n c a B T).Dependent ∧ (waitingQueue n c a B T).Balanced ∧
      (waitingQueue n c a B T).Acting ∧ (waitingQueue n c a B T).Taking ∧
      (waitingQueue n c a B T).Counted ∧ (waitingQueue n c a B T).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no), closingQueue_balanced n c a B T,
   fun t f _ present _ => match f, present with
    | _, .head _ => EnclosedQueue.waiting_front n c t
    | _, .tail _ no => (nomatch no),
   fun t f _ present _ => match f, present with
    | _, .head _ => ⟨EnclosedQueue.waiting_front n c t, trivial⟩
    | _, .tail _ no => (nomatch no),
   ⟨_, Queue.listed (n := fun s => n s + 1) (c := c)⟩, ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩⟩

/-- Under a selection without embodiment, a waiting queue closing at the first step meets the
selection where it selects no dissipation, and one closing at `T`, with a change bound from
`T` and nothing joining an empty queue from `T` on, meets it whatever it selects. -/
theorem waitingQueue_meets {S : Premise → Bool} (free : S .embodied = false)
    (dissipative : S .dissipative = true → (waitingQueue n c a B T).Dissipative) :
    (waitingQueue n c a B T).Meets S :=
  match waitingQueue_holds n c a B T with
  | ⟨dependent, balanced, acting, taking, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, selected => dissipative selected
    | .embodied, selected => nomatch free.symm.trans selected
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- What stands in a waiting queue is the queue. -/
theorem waitingQueue_standing (n c a : Nat → Nat) (B T : Nat) :
    (waitingQueue n c a B T).web.StandingCensus (Queue.line n c) :=
  fun t => ⟨(Queue.listed t).1, fun k => EnclosedQueue.place_pos.symm.trans ((Queue.listed t).2 k)⟩

/-- It counts what the queue counts. -/
theorem waitingQueue_counts (tally : Tally n c a) (t : Nat) :
    (Queue.line n c t).length = n t ∧
      ceasings (Queue.line n c t) (fun x s => 0 < (waitingQueue n c a B T).web.level s x) t =
        c t ∧
      comings (Queue.line n c (t + 1)) (fun x s => 0 < (waitingQueue n c a B T).web.level s x)
        t = a t :=
  ⟨(Queue.counts tally t).1,
   (ceasings_congr (q := Queue.holds n c) _ fun _ =>
     ⟨EnclosedQueue.place_pos.symm, EnclosedQueue.place_pos.symm⟩).trans
     (Queue.counts tally t).2.1,
   (comings_congr (q := Queue.holds n c) _ fun _ =>
     ⟨EnclosedQueue.place_pos.symm, EnclosedQueue.place_pos.symm⟩).trans
     (Queue.counts tally t).2.2⟩

/-- **What a selection binds on what stands in worlds enclosed from some step on, for every
counted census**: that of `standing_counting_under_sound`, and, under balance and dissipation,
from the step on which enclosure holds, change within a bound and nothing coming to stand across a
step at which nothing stands (`enclosure_bounds_standing_counted`,
`standing_of_coming_enclosed`). -/
theorem enclosed_standing_counting_under_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) :
    w.ListingHolds (fun w x t => 0 < w.web.level t x)
      fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsStanding S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) :=
  match within with
  | ⟨meets, T, enclosed⟩ => fun l n c a listed counted =>
    ⟨standing_counting_under_sound S w meets l n c a listed counted,
     fun ⟨balanced, dissipative⟩ => ⟨T, _, enclosure_bounds_standing_counted listed counted
      (meets _ balanced) (meets _ dissipative) enclosed,
      fun t later => counted.company fun _ _ comes => standing_of_coming_enclosed
        (meets _ balanced) (meets _ dissipative) listed (enclosed t later) comes⟩⟩

/-- **The witnesses on what stands in worlds enclosed from some step on**: where embodiment is
selected, those of `enclosed_counting_under_witnessed`; where it is not, a queue standing while
active where balance is not selected, and waiting queues where it is. -/
theorem enclosed_standing_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => 0 < w.web.level t x) (fun w => w.Meets S ∧ ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t)
      fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsStanding S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) :=
  fun n c a tally ⟨quiet, bounded⟩ => match he : S .embodied with
  | true => (enclosed_counting_under_witnessed S n c a tally
        ⟨quiet, fun ⟨hb, _, hd⟩ => bounded ⟨hb, hd⟩⟩).congr fun _ within x t =>
      within.1 _ he x t
  | false => match hb : S .balanced, hd : S .dissipative with
    | false, _ => witnessedAt_of (L := fun w x t => w.web.active t x) (embodiedQueue n c)
        (decided := fun x t => embodiedQueue_decided n c t x) (Queue.line n c)
        ⟨embodiedQueue_meets n c hb, 0, fun t _ => still_enclosed _ (fun _ => rfl) t⟩
        (fun x t => (embodiedQueue_premised n c).2.2.2.2.1 x t) Queue.listed (Queue.counts tally)
    | true, false => ⟨waitingQueue n c a 0 0, fun _ _ => inferInstance, _,
        ⟨waitingQueue_meets he (fun selected => nomatch hd.symm.trans selected),
         0, fun _ later => closingQueue_enclosed (B := 0) tally later⟩,
        waitingQueue_standing n c a 0 0, waitingQueue_counts (B := 0) (T := 0) tally⟩
    | true, true => match bounded ⟨hb, hd⟩ with
      | ⟨T, K, bound, company⟩ => ⟨waitingQueue n c a (K + T) T, fun _ _ => inferInstance, _,
          ⟨waitingQueue_meets he fun _ => closingQueue_dissipative tally bound company,
           T, fun _ later => closingQueue_enclosed (B := K + T) tally later⟩,
          waitingQueue_standing n c a (K + T) T, waitingQueue_counts (B := K + T) (T := T) tally⟩

/-- The laws of counting what stands under each selection, in worlds enclosed from some step
on. A property of the counts holds of every census of what stands in every such world meeting
the selection exactly when it holds of every tally that meets two conditions: where the
selection binds counting, nothing comes to stand across a step at which nothing stands; where
it selects balance and dissipation, from some step `T` on change stays within a bound and
nothing comes to stand across a step at which nothing stands. These are the laws of
`enclosed_counting_under` with embodiment dropped from the second condition. -/
theorem enclosed_standing_counting_under (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsStanding S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) →
        Q n c a) ↔
      ∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.StandingMarksHold Q :=
  have table := table_marks_hold pointwise (enclosed_standing_counting_under_sound S)
    (enclosed_standing_counting_under_witnessed S)
  ⟨fun law w meets enclosed => table.mp (fun n c a tally ⟨quiet, bounded⟩ =>
      law n c a tally quiet bounded) w ⟨meets, enclosed⟩,
   fun law n c a tally quiet bounded => table.mpr (fun _ _ ⟨meets, enclosed⟩ =>
      listingMarksHold_of_marksHold pointwise (law _ meets enclosed)) n c a tally ⟨quiet, bounded⟩⟩

/-- So in worlds enclosed from some step on, a change bound from some step is a law of
counting what stands under a selection exactly when it selects balance and dissipation:
embodiment, which a change bound of activity needs (`enclosed_change_bound_iff`), is not
needed for what stands. -/
theorem enclosed_standing_bound_iff (S : Premise → Bool) :
    (∀ w : World, w.Meets S → (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
      w.StandingMarksHold fun n c a => ∃ T B, ChangeBound T B n c a) ↔ BoundsStanding S :=
  have pointwise : Pointwise fun n (_ _ : Nat → Nat) => ∃ T B, ∀ t, T ≤ t → n t ≤ B :=
    fun same ⟨T, B, bounded⟩ => ⟨T, B, fun t later =>
      Nat.le_trans (Nat.le_of_eq (same t).1.symm) (bounded t later)⟩
  have growing : Tally (fun t => t + 1) (fun _ => 0) (fun _ => 1) := fun t => ⟨t + 1, rfl, rfl⟩
  ⟨fun law => if bounds : S .balanced = true ∧ S .dissipative = true then bounds else
      match (enclosed_standing_counting_under S pointwise).mpr
          (fun w meets enclosed stand census => match law w meets enclosed stand census with
            | ⟨T, B, bound⟩ => ⟨T, B, fun t later =>
                Nat.le_trans (Nat.le_add_right _ _) (bound t later)⟩)
          _ _ _ growing (fun _ t _ => Nat.zero_lt_succ t) (fun bound => absurd bound bounds) with
      | ⟨T, B, bounded⟩ => (Nat.not_succ_le_self B (Nat.le_trans
          (Nat.succ_le_succ (Nat.le_add_right B T)) (bounded (B + T) (Nat.le_add_left T B)))).elim,
   fun ⟨balanced, dissipative⟩ _ meets ⟨T, enclosed⟩ _ census =>
     ⟨T, _, enclosure_bounds_standing census (meets _ balanced) (meets _ dissipative) enclosed⟩⟩

end World

/-! ## Counting what stands in finite worlds -/

namespace World

/-- The balanced ring (`balancedRing`) with every place active throughout, standing while
held. -/
def activeRing (n c : Nat → Nat) (M : Nat) : World :=
  World.of (Fin (Ring.size M)) (Ring.flow n c M) ({ Ring.web n c M (Ring.stands n c M) with active := fun _ _ => True })

variable {n c a : Nat → Nat} {M : Nat}

/-- Whatever its counts, a ring active throughout is a finite world meeting every premise but
dissipation and embodiment. -/
theorem activeRing_holds (n c : Nat → Nat) (M : Nat) :
    (activeRing n c M).Dependent ∧ (activeRing n c M).Balanced ∧ (activeRing n c M).Acting ∧
      (activeRing n c M).Taking ∧ (activeRing n c M).Counted ∧
      (activeRing n c M).Transmitting ∧ (activeRing n c M).Finite :=
  match places_listed (Ring.size M) with
  | ⟨all, distinct, every⟩ =>
    ⟨fun _ _ _ _ no => (nomatch no),
     fun t i => add_sub_turn (Ring.stands n c M t i) (Ring.stands n c M (t + 1) i),
     fun _ _ _ _ _ => trivial, fun _ _ _ _ _ => ⟨trivial, trivial⟩,
     ⟨fun _ => all, fun _ => ⟨distinct, fun i => ⟨fun _ => every i, fun _ => trivial⟩⟩⟩,
     ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩, ⟨all, distinct, every⟩⟩

/-- A ring active throughout meets every selection without dissipation and embodiment. -/
theorem activeRing_meets (n c : Nat → Nat) (M : Nat) {S : Premise → Bool}
    (free : S .embodied = false) (still : S .dissipative = false) : (activeRing n c M).Meets S :=
  match activeRing_holds n c M with
  | ⟨dependent, balanced, acting, taking, counted, transmitting, _⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, selected => nomatch still.symm.trans selected
    | .embodied, selected => nomatch free.symm.trans selected
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- What stands in it is the places held, and where at most `M` are in the queue at each step
it counts what the queue counts. -/
theorem activeRing_counts (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) :
    (activeRing n c M).web.StandingCensus (Ring.seated n c M) ∧ ∀ t,
      (Ring.seated n c M t).length = n t ∧
      ceasings (Ring.seated n c M t) (fun x s => 0 < (activeRing n c M).web.level s x) t =
        c t ∧
      comings (Ring.seated n c M (t + 1)) (fun x s => 0 < (activeRing n c M).web.level s x) t =
        a t :=
  ⟨fun t => ⟨(Ring.census bounded (Ring.stands n c M) t).1,
     fun i => mark_pos.trans ((Ring.census bounded (Ring.stands n c M) t).2 i)⟩,
   fun t => ⟨(Ring.counts tally bounded t).1,
     (ceasings_congr (q := Ring.holds n c M) _ fun _ => ⟨mark_pos, mark_pos⟩).trans
       (Ring.counts tally bounded t).2.1,
     (comings_congr (q := Ring.holds n c M) _ fun _ => ⟨mark_pos, mark_pos⟩).trans
       (Ring.counts tally bounded t).2.2⟩⟩

/-- **What a selection binds on what stands in finite worlds, for every counted census**: at most
as many stand as there are relata; where the selection binds counting or selects balance and
dissipation, nothing comes to stand across a step at which nothing stands; and, under balance and
dissipation, change within a bound from the first step, every step being enclosed. -/
theorem finite_standing_counting_under_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ w.Finite) :
    w.ListingHolds (fun w x t => 0 < w.web.level t x)
      fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsStanding S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsStanding S → ∃ B, ChangeBound 0 B n c a) :=
  match within with
  | ⟨meets, finite⟩ => fun l n c a listed counted =>
    ⟨match finite with
      | ⟨all, _, every⟩ => ⟨all.length, fun t => Nat.le_trans (Nat.le_of_eq (counted t).1)
          (length_le_of_sub (listed t).1 fun x _ => every x)⟩,
     fun
      | .inl binds => standing_counting_under_sound S w meets l n c a listed counted binds
      | .inr ⟨balanced, dissipative⟩ => fun _ => counted.company fun _ _ comes =>
          standing_of_coming_enclosed (meets _ balanced) (meets _ dissipative) listed
            (finite.enclosed _) comes,
     fun ⟨balanced, dissipative⟩ => ⟨_, enclosure_bounds_standing_counted listed counted
      (meets _ balanced) (meets _ dissipative) fun t _ => finite.enclosed t⟩⟩

/-- **The witnesses on what stands in finite worlds**: where embodiment is selected, those of
`finite_counting_under_witnessed`; where it is not, a ring standing while active where balance is
not selected, a ring each of whose places is active throughout where balance is and dissipation
is not, and a finite queue where both are. -/
theorem finite_standing_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => 0 < w.web.level t x) (fun w => w.Meets S ∧ w.Finite)
      fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsStanding S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsStanding S → ∃ B, ChangeBound 0 B n c a) :=
  fun n c a tally ⟨⟨M, bounded⟩, quiet, bound⟩ => match he : S .embodied with
  | true => (finite_counting_under_witnessed S n c a tally ⟨⟨M, bounded⟩,
        (fun
          | .inl binds => quiet (.inl binds)
          | .inr ⟨hb, _, hd⟩ => quiet (.inr ⟨hb, hd⟩)),
        fun ⟨hb, _, hd⟩ => bound ⟨hb, hd⟩⟩).congr fun _ within x t => within.1 _ he x t
  | false => match hb : S .balanced, hd : S .dissipative with
    | false, _ => witnessedAt_of (L := fun w x t => w.web.active t x) (embodiedRing n c M)
        (Ring.seated n c M) ⟨embodiedRing_meets bounded hb, places_listed _⟩
        (fun x t => (embodiedRing_premised bounded).2.2.2.2.1 x t) (Ring.census bounded _)
        (Ring.counts tally bounded)
    | true, false => ⟨activeRing n c M, fun _ _ => inferInstance, _,
        ⟨activeRing_meets n c M he hd, (activeRing_holds n c M).2.2.2.2.2.2⟩,
        (activeRing_counts tally bounded).1, (activeRing_counts tally bounded).2⟩
    | true, true => match bound ⟨hb, hd⟩ with
      | ⟨B, bound⟩ =>
        have premised := finiteQueue_premised tally (quiet (.inr ⟨hb, hd⟩)) bound
        witnessedAt_of (L := fun w x t => w.web.active t x) (finiteQueue n c a B)
          (decided := fun x t => finiteQueue_decided n c a B t x) _
          ⟨premised.meets S, finiteQueue_finite n c a B⟩
          (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
          (finiteQueue_census n c a B) (finiteQueue_counts tally bound)

/-- The laws of counting what stands under each selection, in finite worlds. A property of the
counts holds of every census of what stands in every finite world meeting the selection
exactly when it holds of every tally that meets three conditions: at most some number stand at
each step; where the selection binds counting or selects balance and dissipation, nothing comes
to stand across a step at which nothing stands; where it selects balance and dissipation,
change stays within a bound from the first step. These are the laws of `finite_counting_under`
with embodiment dropped from where balance and dissipation bind. -/
theorem finite_standing_counting_under (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) →
      (BindsCounting S ∨ BoundsStanding S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsStanding S → ∃ B, ChangeBound 0 B n c a) → Q n c a) ↔
      ∀ w : World, w.Meets S → w.Finite → w.StandingMarksHold Q :=
  have table := table_marks_hold pointwise (finite_standing_counting_under_sound S)
    (finite_standing_counting_under_witnessed S)
  ⟨fun law w meets finite => table.mp (fun n c a tally ⟨bounded, quiet, bound⟩ =>
      law n c a tally bounded quiet bound) w ⟨meets, finite⟩,
   fun law n c a tally bounded quiet bound => table.mpr (fun _ _ ⟨meets, finite⟩ =>
      listingMarksHold_of_marksHold pointwise (law _ meets finite)) n c a tally ⟨bounded, quiet, bound⟩⟩

/-- So in finite worlds, nothing coming to stand across a step at which nothing stands is a law
of counting what stands under a selection exactly when the selection binds counting or selects
balance and dissipation. -/
theorem finite_standing_binds_iff (S : Premise → Bool) :
    (∀ w : World, w.Meets S → w.Finite →
      w.StandingMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ↔
      BindsCounting S ∨ BoundsStanding S :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∀ t, 0 < a t → 0 < n t :=
    fun same law t pos => Nat.lt_of_lt_of_le (law t (Nat.lt_of_lt_of_le pos
      (Nat.le_of_eq (same t).2.2.symm))) (Nat.le_of_eq (same t).1)
  have unbound : ¬ (BindsCounting S ∨ BoundsStanding S) → ¬ ∀ w : World, w.Meets S →
      w.Finite → w.StandingMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t := fun free law =>
    Nat.lt_irrefl 0 ((finite_standing_counting_under S pointwise).mpr law _ _ _ Queue.lone_tally
      ⟨1, fun | 0 => Nat.zero_le 1 | _ + 1 => Nat.le_refl 1⟩
      (fun binds => absurd binds free) (fun bounds => absurd (.inr bounds) free)
      0 Nat.zero_lt_one)
  ⟨fun law => match hb : S .balanced, hd : S .dissipative, he : S .embodied,
      ha : S .acting with
    | true, true, _, _ => .inr ⟨hb, hd⟩
    | true, false, true, true => .inl ⟨hb, he, .inl ha⟩
    | false, _, _, _ => absurd law (unbound fun
        | .inl binds => nomatch hb.symm.trans binds.1
        | .inr bounds => nomatch hb.symm.trans bounds.1)
    | true, false, false, _ => absurd law (unbound fun
        | .inl binds => nomatch he.symm.trans binds.2.1
        | .inr bounds => nomatch hd.symm.trans bounds.2)
    | true, false, true, false => absurd law (unbound fun
        | .inl ⟨_, _, .inl acting⟩ => nomatch ha.symm.trans acting
        | .inl ⟨_, _, .inr ⟨_, dissipative⟩⟩ => nomatch hd.symm.trans dissipative
        | .inr bounds => nomatch hd.symm.trans bounds.2),
   fun binds => (finite_standing_counting_under S pointwise).mp fun _ _ _ _ _ quiet _ =>
     quiet binds⟩

/-- And a change bound from the first step is a law of counting what stands in finite worlds
under a selection exactly when it selects balance and dissipation: one member replaced at
every step is counted by a finite world meeting any other selection, and change recurs
there. -/
theorem finite_standing_bound_iff (S : Premise → Bool) :
    (∀ w : World, w.Meets S → w.Finite →
      w.StandingMarksHold fun n c a => ∃ B, ChangeBound 0 B n c a) ↔ BoundsStanding S :=
  have pointwise : Pointwise fun (_ c a : Nat → Nat) => ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < c t + a t :=
    fun {_ _ a _ c' _} same settles recurs => settles fun N => match recurs N with
      | ⟨t, later, changes⟩ => ⟨t, later, Nat.lt_of_lt_of_le changes (Nat.le_of_eq
          ((congrArg (· + a t) (same t).2.1).trans (congrArg (c' t + ·) (same t).2.2)).symm)⟩
  have replaced : Tally (fun _ => 1) (fun _ => 1) (fun _ => 1) := fun _ => ⟨0, rfl, rfl⟩
  ⟨fun law => if bounds : S .balanced = true ∧ S .dissipative = true then bounds else
      ((finite_standing_counting_under S pointwise).mpr
        (fun w meets finite stand census => match law w meets finite stand census with
          | ⟨_, bound⟩ => bound.not_recurring)
        _ _ _ replaced ⟨1, fun _ => Nat.le_refl 1⟩ (fun _ _ _ => Nat.zero_lt_one)
        (fun bounds' => absurd bounds' bounds) fun N => ⟨N, Nat.le_refl N, Nat.zero_lt_succ _⟩).elim,
   fun ⟨balanced, dissipative⟩ _ meets finite _ census =>
    ⟨_, enclosure_bounds_standing census (meets _ balanced) (meets _ dissipative)
      fun t _ => finite.enclosed t⟩⟩

end World

/-! ## Counting what depends -/

namespace World

/-- `Q` holds of the counts of every census of the dependences of the world: how many hold at
each step, how many dissolve and how many form across it. -/
def DependenceMarksHold (w : World) [∀ t f c, Decidable (w.web.requires t f c)]
    (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ deps, w.web.DependenceCensus deps → Q (fun t => (deps t).length)
    (fun t => ceasings (deps t) (fun d s => w.web.requires s d.1 d.2) t)
    (fun t => comings (deps (t + 1)) (fun d s => w.web.requires s d.1 d.2) t)

end World

/-- Members of a queue depending on relatum `0` while in it, each needing a unit of it, with
relatum `0` standing at one and active throughout, and nothing else standing or active. -/
def Queue.depending (n c : Nat → Nat) : Web Nat Nat where
  level _ x := match x with
    | 0 => 1
    | _ + 1 => 0
  active _ x := match x with
    | 0 => True
    | _ + 1 => False
  requires t f g := Queue.holds n c f t ∧ g = 0
  need _ _ _ := 1
  draws _ _ _ := True

namespace World

/-- A depending queue: members of a queue depending on a common condition while in it, with
nothing flowing. -/
def dependingQueue (n c : Nat → Nat) : World :=
  World.of Nat Flow.still (Queue.depending n c)

instance dependingQueue_decided (n c : Nat → Nat) :
    ∀ t f g, Decidable ((dependingQueue n c).web.requires t f g) :=
  fun t (f g : Nat) => inferInstanceAs (Decidable (Queue.holds n c f t ∧ g = 0))

/-- With nothing flowing and every level staying, a web meets every premise where it meets
the three that are about the web alone: activity needing support, embodiment and a census. -/
theorem still_premised {R : Type} (W : Web R R) (steady : ∀ t x, W.level (t + 1) x = W.level t x)
    (dependent : W.Dependent) (embodied : ∀ x, W.Embodied x) (counted : ∃ alive, W.Census alive) :
    (World.of R Flow.still W : World).Premised :=
  match still_vacuous W with
  | ⟨acting, taking, dissipative, transmitting⟩ =>
    .of dependent (fun t x => congrArg (· + 0) (steady t x)) acting taking dissipative embodied
      counted transmitting

/-- A depending queue meets all eight premises: every dependence is met, and relatum `0`, the
only one standing, is the only one active. -/
theorem dependingQueue_premised (n c : Nat → Nat) : (dependingQueue n c).Premised :=
  still_premised _ (fun _ _ => rfl)
    (fun _ _ _ g dep => match g, dep with
      | 0, _ => Nat.le_refl 1
      | _ + 1, ⟨_, no⟩ => nomatch no)
    (fun x _ => match x with
      | 0 => ⟨fun _ => Nat.succ_pos 0, fun _ => trivial⟩
      | _ + 1 => ⟨False.elim, fun pos => absurd pos (Nat.lt_irrefl 0)⟩)
    ⟨fun _ => [0], fun _ => ⟨⟨(fun no => nomatch no), trivial⟩, fun x => match x with
      | 0 => ⟨fun _ => .head _, fun _ => trivial⟩
      | _ + 1 => ⟨False.elim, fun mem => match mem with
          | .tail _ no => nomatch no⟩⟩⟩

/-- Its dependences are its members, each with the common condition. -/
theorem dependingQueue_census (n c : Nat → Nat) :
    (dependingQueue n c).web.DependenceCensus fun t => (Queue.line n c t).map (·, (0 : Nat)) :=
  fun t => ⟨distinct_map (fun _ _ same => congrArg Prod.fst same) (Queue.listed t).1,
    fun d => match d with
    | (f, _) => ⟨fun ⟨holds, common⟩ => Eq.subst (motive := fun x =>
          (f, x) ∈ (Queue.line n c t).map (·, (0 : Nat))) common.symm
          (mem_map_of (g := (·, (0 : Nat))) (((Queue.listed t).2 f).mp holds)),
        fun mem => match preimage_of_mem_map mem with
        | ⟨k, listed, same⟩ => ⟨Eq.subst (motive := fun x => Queue.holds n c x t)
            (congrArg Prod.fst same) (((Queue.listed t).2 k).mpr listed),
          (congrArg Prod.snd same).symm⟩⟩⟩

/-- It counts what the queue counts. -/
theorem dependingQueue_counts {n c a : Nat → Nat} (tally : Tally n c a) (t : Nat) :
    ((Queue.line n c t).map (·, (0 : Nat))).length = n t ∧
      ceasings ((Queue.line n c t).map (·, (0 : Nat)))
        (fun d s => (dependingQueue n c).web.requires s d.1 d.2) t = c t ∧
      comings ((Queue.line n c (t + 1)).map (·, (0 : Nat)))
        (fun d s => (dependingQueue n c).web.requires s d.1 d.2) t = a t :=
  have same : ∀ (k : Nat) s, (dependingQueue n c).web.requires s k (0 : Nat) ↔
      Queue.holds n c k s :=
    fun _ _ => ⟨fun both => both.1, fun holds => ⟨holds, rfl⟩⟩
  ⟨(total_ones _).symm.trans ((total_map _ _ _).trans ((total_ones _).trans (steps_length _ _))),
   (total_map _ _ _).trans ((total_congr (fun k => mark_iff
      (ceasesToBe_congr (same k t) (same k (t + 1)))) _).trans (Queue.ceasings_eq tally t)),
   (total_map _ _ _).trans ((total_congr (fun k => mark_iff
      (comesToBe_congr (same k t) (same k (t + 1)))) _).trans (Queue.comings_eq tally t))⟩

/-- **The witnesses on what depends**: a depending queue, meeting all eight premises with every
step enclosed, counts every tally. -/
theorem dependence_witnessed (S : Premise → Bool) :
    Witnessed (fun w (d : w.Relatum × w.Relatum) t => w.web.requires t d.1 d.2)
      (fun w => w.Meets S ∧ ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) fun _ _ _ => True :=
  fun n c _ tally _ => ⟨dependingQueue n c, fun _ _ => inferInstance, _,
    ⟨(dependingQueue_premised n c).meets S, 0, fun t _ => still_enclosed _ (fun _ => rfl) t⟩,
    dependingQueue_census n c, dependingQueue_counts tally⟩

/-- The premises add nothing to the law of counting dependences: under each selection, a
property of the counts holds of every census of the dependences of every world meeting it
exactly when it holds of every tally. -/
theorem dependence_counting (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t f c, Decidable (w.web.requires t f c)], w.Meets S → w.DependenceMarksHold Q :=
  have table := table_marks_hold_free pointwise
    (fun n c a tally _ => match dependence_witnessed S n c a tally trivial with
      | ⟨w, decided, l, within, listed, counts⟩ => ⟨w, decided, l, within.1, listed, counts⟩)
  ⟨fun law w inst meets =>
    have marks := table.mp law
    @marks w (fun d t => inst t d.1 d.2) meets,
   fun law => table.mpr fun w inst meets => @law w (fun t f c => inst (f, c) t) meets⟩

/-- Nor does enclosure: the depending queue has every step enclosed. -/
theorem enclosed_dependence_counting (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t f c, Decidable (w.web.requires t f c)], w.Meets S →
        (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.DependenceMarksHold Q :=
  have table := table_marks_hold_free pointwise (dependence_witnessed S)
  ⟨fun law w inst meets enclosed =>
    have marks := table.mp law
    @marks w (fun d t => inst t d.1 d.2) ⟨meets, enclosed⟩,
   fun law => table.mpr fun w inst ⟨meets, enclosed⟩ =>
    @law w (fun t f c => inst (f, c) t) meets enclosed⟩

end World

/-- The first place of the ring. -/
def Ring.first (M : Nat) : Fin (Ring.size M) :=
  ⟨0, Nat.succ_pos _⟩

/-- Places of a ring depending on its first place while held, each needing a unit of it, with
the first place standing at one and active throughout, and nothing else standing or active. -/
def Ring.depending (n c : Nat → Nat) (M : Nat) : Web (Fin (Ring.size M)) (Fin (Ring.size M)) where
  level _ i := match i.val with
    | 0 => 1
    | _ + 1 => 0
  active _ i := match i.val with
    | 0 => True
    | _ + 1 => False
  requires t i j := Ring.holds n c M i t ∧ j.val = 0
  need _ _ _ := 1
  draws _ _ _ := True

namespace World

/-- A depending ring: places of a ring depending on its first place while held, with nothing
flowing. -/
def dependingRing (n c : Nat → Nat) (M : Nat) : World :=
  World.of (Fin (Ring.size M)) Flow.still (Ring.depending n c M)

instance dependingRing_decided (n c : Nat → Nat) (M : Nat) :
    ∀ t i j, Decidable ((dependingRing n c M).web.requires t i j) :=
  fun t i j => inferInstanceAs (Decidable (Ring.holds n c M i t ∧ j.val = 0))

/-- A depending ring meets all eight premises. -/
theorem dependingRing_premised (n c : Nat → Nat) (M : Nat) : (dependingRing n c M).Premised :=
  still_premised _ (fun _ _ => rfl)
    (fun _ _ _ j dep => match j, dep with
      | ⟨0, _⟩, _ => Nat.le_refl 1
      | ⟨_ + 1, _⟩, ⟨_, no⟩ => nomatch no)
    (fun i _ => match i with
      | ⟨0, _⟩ => ⟨fun _ => Nat.succ_pos 0, fun _ => trivial⟩
      | ⟨_ + 1, _⟩ => ⟨False.elim, fun pos => absurd pos (Nat.lt_irrefl 0)⟩)
    ⟨fun _ => [Ring.first M], fun _ => ⟨⟨(fun no => nomatch no), trivial⟩, fun i => match i with
      | ⟨0, _⟩ => ⟨fun _ => .head _, fun _ => trivial⟩
      | ⟨_ + 1, _⟩ => ⟨False.elim, fun mem => match mem with
          | .tail _ no => nomatch no⟩⟩⟩

/-- Where at most `M` are in the queue at each step, its dependences are the places held, each
with the first place, and it counts what the queue counts. -/
theorem dependingRing_counts {n c a : Nat → Nat} {M : Nat} (tally : Tally n c a)
    (bounded : ∀ t, n t ≤ M) :
    (dependingRing n c M).web.DependenceCensus (fun t => (Ring.seated n c M t).map
      (·, Ring.first M)) ∧ ∀ t,
      ((Ring.seated n c M t).map (·, Ring.first M)).length = n t ∧
      ceasings ((Ring.seated n c M t).map (·, Ring.first M))
        (fun d s => (dependingRing n c M).web.requires s d.1 d.2) t = c t ∧
      comings ((Ring.seated n c M (t + 1)).map (·, Ring.first M))
        (fun d s => (dependingRing n c M).web.requires s d.1 d.2) t = a t :=
  have census := Ring.census (c := c) bounded (fun _ _ => 0)
  have same : ∀ i s, (dependingRing n c M).web.requires s i (Ring.first M) ↔
      Ring.holds n c M i s := fun _ _ => ⟨fun both => both.1, fun held => ⟨held, rfl⟩⟩
  ⟨fun t => ⟨distinct_map (fun _ _ same => congrArg Prod.fst same) (census t).1,
    fun d => match d with
    | (i, j) => ⟨fun ⟨held, first⟩ => Eq.subst (motive := fun x =>
          (i, x) ∈ (Ring.seated n c M t).map (·, Ring.first M))
          (Fin.eq_of_val_eq (i := Ring.first M) (j := j) first.symm)
          (mem_map_of (g := (·, Ring.first M)) (((census t).2 i).mp held)),
        fun mem => match preimage_of_mem_map mem with
        | ⟨k, listed, same⟩ => ⟨Eq.subst (motive := fun x => Ring.holds n c M x t)
            (congrArg Prod.fst same) (((census t).2 k).mpr listed),
          congrArg Fin.val (congrArg Prod.snd same).symm⟩⟩⟩,
   fun t => ⟨(total_ones _).symm.trans ((total_map _ _ _).trans ((total_ones _).trans
      (Ring.counts tally bounded t).1)),
    (total_map _ _ _).trans ((total_congr (fun i => mark_iff
      (ceasesToBe_congr (same i t) (same i (t + 1)))) _).trans (Ring.counts tally bounded t).2.1),
    (total_map _ _ _).trans ((total_congr (fun i => mark_iff
      (comesToBe_congr (same i t) (same i (t + 1)))) _).trans (Ring.counts tally bounded t).2.2)⟩⟩

/-- **What finiteness binds on what depends, for every counted census**: dependences are pairs
of relata, finitely many in a finite world. -/
theorem finite_dependence_counting_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ w.Finite) :
    w.ListingHolds (fun w (d : w.Relatum × w.Relatum) t => w.web.requires t d.1 d.2)
      fun n _ _ => ∃ M, ∀ t, n t ≤ M :=
  match within with
  | ⟨_, all, _, every⟩ => fun _ _ _ _ listed counted => ⟨(pairs all all).length, fun t =>
      Nat.le_trans (Nat.le_of_eq (counted t).1)
        (length_le_of_sub (listed t).1 fun d _ => mem_pairs (every d.1) (every d.2))⟩

/-- **The witnesses on what depends in finite worlds**: a depending ring, meeting all eight
premises, counts every tally with at most some number holding at each step. -/
theorem finite_dependence_counting_witnessed (S : Premise → Bool) :
    Witnessed (fun w (d : w.Relatum × w.Relatum) t => w.web.requires t d.1 d.2) (fun w => w.Meets S ∧ w.Finite)
      fun n _ _ => ∃ M, ∀ t, n t ≤ M :=
  fun n c _ tally ⟨M, bounded⟩ => ⟨dependingRing n c M, fun _ _ => inferInstance, _,
    ⟨(dependingRing_premised n c M).meets S, places_listed _⟩,
    (dependingRing_counts tally bounded).1, (dependingRing_counts tally bounded).2⟩

/-- In finite worlds the laws of counting dependences under each selection are those of a tally
with at most some number holding at each step: dependences are pairs of relata, finitely many
in a finite world. -/
theorem finite_dependence_counting (S : Premise → Bool) (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) → Q n c a) ↔
      ∀ (w : World) [∀ t f c, Decidable (w.web.requires t f c)], w.Meets S → w.Finite →
        w.DependenceMarksHold Q :=
  have table := table_marks_hold pointwise (finite_dependence_counting_sound S)
    (finite_dependence_counting_witnessed S)
  ⟨fun law w inst meets finite =>
    have marks := table.mp law
    @marks w (fun d t => inst t d.1 d.2) ⟨meets, finite⟩,
   fun law => table.mpr fun w inst ⟨meets, finite⟩ =>
    @law w (fun t f c => inst (f, c) t) meets finite⟩

end World

end Becoming
