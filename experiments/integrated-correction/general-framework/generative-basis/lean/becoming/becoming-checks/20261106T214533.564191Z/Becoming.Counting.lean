import Becoming.Openness
import Becoming.Witnesses
import Becoming.CensusTable

/-!
# Counting: what the premises add to the laws of counting

`Becoming.Population` shows that the tally is the whole law of counting: a property of the
counts, how many hold at each step and how many cease and come to hold across it, holds
wherever what holds is listed exactly when it holds of every tally (`counting_laws`). This
module states what the premises of `Becoming.Premises` add to that law for the counts of a
census, how many relata are active at each step and how many cease and arise across it:
under all eight, under each of their 256 selections, with every step from some step on
enclosed, in finite worlds, and where the premises bind. Each law of counting is an
equivalence: a property of the counts holds of every census of every world meeting the
premises exactly when it holds of every tally meeting the added conditions, queues and
rings counting each such tally being the witnesses.

* **Counting under the premises.** Relata queuing with nothing flowing meet every premise
  but embodiment, and relata queuing that stand exactly while active meet every premise but
  balance (`World.queue_premised`, `World.embodiedQueue_premised`). So a property of the
  counts of a census holds in every world meeting either seven exactly when it holds of
  every tally (`World.counting_free`): premises lacking balance or embodiment leave counting
  free. Together, with only active relata giving, they bind it: what arises is given by a
  relatum active at the step, so under a census nothing arises across a step at which
  nothing is active, which is no law of tallies (`World.counting_binds_jointly`). That is
  all the eight premises add. An open queue, whose front gives to each relatum joining,
  takes from each leaving and, while active, exchanges a unit each way with every ground
  relatum, meets all eight wherever nothing joins an empty queue
  (`World.openQueue_premised`). So a property of the counts holds in every world meeting the
  eight exactly when it holds of every tally in which nothing arises across a step at which
  nothing is active (`World.premised_counting`). Three of the eight hold vacuously in the
  open queue: nothing taking part takes from a closed family, and nothing depends on
  anything (`World.openQueue_not_binds`). No step at which the front is active is enclosed;
  with enclosure from some step on change is bounded as well.
* **Counting under each selection.** Under each of the 256 selections of the premises
  (`World.Meets`) the laws of counting are of two kinds: the tally alone, or the tally with
  nothing arising across a step at which nothing is active, the second exactly where the
  selection binds counting (`World.counting_under`, `World.counting_binds_iff`): balance and
  embodiment, with only active relata giving, or with only active relata taking and
  dissipation. The second route needs no premise on giving: at a step at which nothing is
  active nothing is taken, whatever is given comes to stand and so is active after the step,
  the relata active after it form a closed family, and dissipation lets nothing be given to
  it (`World.taking_binds_counting`). At an enclosed step balance, dissipation and
  embodiment suffice (`World.enclosed_binds_counting`). Every other selection leaves every
  tally counted: a queue driven by an inactive ground relatum, exchanging a unit each way
  with every ground relatum, meets every premise but only active relata giving and taking
  (`World.drivenQueue_holds`), and the open queue, whatever its counts, every premise but
  only active relata giving and dissipation (`World.openQueue_holds`).
* **Enclosure bounds change.** In a world with a census whose relata are embodied, with a
  balanced, dissipative flow and every step from `T` on enclosed, the relata active at any
  later step, with the steps since `T` at which something arose or ceased, number at most
  the total standing at `T`: that total bounds change (`World.enclosure_bounds_change`,
  `ChangeBound`). A bound from some step is one from the first step
  (`changeBound_iff_zero`). An enclosed queue, whose front exchanges only within the queue
  and whose standing falls by one at each step at which a member joins or leaves, has every
  step enclosed (`World.enclosedQueue_enclosed`), and meets all eight premises wherever a
  bound from the first step holds of its counts and nothing joins an empty queue
  (`World.enclosedQueue_premised`); activity needing support and bounded transmission hold
  there vacuously, nothing depending on anything. So under the eight, with every step from
  some step on enclosed, the laws of counting are the tally, that nothing arises across a
  step at which nothing is active, and a change bound from the first step
  (`World.enclosed_counting`). On the finitely many places its members ever take, the queue
  is a finite world meeting the eight (`World.finiteQueue_premised`), in which dissipation
  binds and the bound of `World.enclosure_bounds_change` is attained
  (`World.finite_dissipation_binds`, `World.replaced_attains`); so finite worlds have the
  same laws of counting (`World.finite_counting`, `World.enclosed_iff_finite_counting`).
  Change then does not recur (`ChangeBound.not_recurring`), but a step after which nothing
  arises in every finite world meeting the eight would give `LPO`
  (`World.lpo_of_finite_ends`).
* **Counting under each selection, with enclosure.** In worlds enclosed from some step on,
  the laws of counting under each selection of the premises add one condition to those of
  `World.counting_under`, exactly where balance, embodiment and dissipation are selected:
  from some step on change stays within a bound and nothing arises across a step at which
  nothing is active (`World.enclosed_counting_under`). A change bound from some step is a
  law there exactly where the three are selected (`World.enclosed_change_bound_iff`), so
  enclosure adds no law exactly where they are not all selected. Where neither only active
  relata giving nor only active relata taking is selected, the witness is an enclosed queue
  closing at that step, every relatum exchanging a unit each way with the front before it
  (`World.closingQueue_dissipative`). The enclosed queue takes only while active whatever
  its counts (`World.enclosedQueue_taking`) and dissipates step by step
  (`World.enclosedQueue_dissipatesOn`).
* **Counting under each selection, in finite worlds.** Every step of a finite world is
  enclosed (`World.Finite.enclosed`), so there dissipation with balance and embodiment
  binds counting by itself. Under each selection the laws of counting in finite worlds are
  those of a tally with at most some number active at each step, and two more where
  selected (`World.finite_counting_under`): nothing arising across a step at which nothing
  is active, exactly where balance and embodiment are selected with only active relata
  giving or with dissipation (`World.finite_counting_binds_iff`), and a change bound from
  the first step, exactly where balance, embodiment and dissipation are selected
  (`World.finite_change_bound_iff`). So the 256 selections give three kinds of law. Finite
  worlds and worlds enclosed from some step on have the same laws under a selection exactly
  when it bounds change and binds counting, which is exactly where their tally conditions
  agree (`World.enclosed_iff_finite_tally`, `World.enclosed_iff_finite_counting_under`).
  The witnesses seat a queue round a ring of places, each member at the next place in turn
  (`Ring.slot`), so that those in the queue before or after any step hold distinct places
  and the ring counts what the queue counts (`Ring.slot_inj`, `Ring.counts`). With nothing
  standing, a ring meets every premise but embodiment (`World.ring_meets`); with each place
  standing while held, every premise but balance (`World.embodiedRing_meets`); with the
  front's place also taking what each place's standing loses and giving what it gains, every
  premise but dissipation, only active relata giving where nothing joins an empty queue
  (`World.balancedRing_meets`).
* **Counting where every premise binds.** A premise binds where its condition has an
  instance (`World.Premise.Binds`, `World.Binds`). Where embodiment binds, every census
  counts something arising (`World.binds_arising`), which is no law under the eight alone
  (`World.binds_adds`), and where every premise binds that is all binding adds. A queue
  closed once is open across every step but `T` at which it is not empty before or after; at
  `T` its front stands `E` more, and across `T` it exchanges only within the queue and loses
  that excess, so dissipation binds there. Every relatum depends on every relatum, needing
  what it stands at, so the conditions of activity needing support and bounded transmission
  have instances wherever something joins; but these two premises hold there whatever is
  active and whatever flows (`OnceClosedQueue.dependent_any_activity`,
  `OnceClosedQueue.transmits_any_flow`): they bind only as instances, and only dissipation
  excludes anything. Where the queue is not empty at `T`, its front stands more than join
  there and something joins across some step, every premise binds
  (`World.onceClosedQueue_binds`); with nothing joining an empty queue it meets the eight
  (`World.onceClosedQueue_premised`). So where every premise binds, the laws of counting
  under the eight are the tally, that nothing arises across a step at which nothing is
  active, and that something arises (`World.binding_counting`). A census binds only where
  the world is not finite, so no finite world binds every premise
  (`World.Finite.not_binds`), though in a finite world every other premise can bind
  (`World.finiteHatch_binds_but_census`); there the laws of counting under the eight are
  those of finite worlds and that something arises (`World.finite_binding_counting`), the
  finite queue with its web saturated witnessing them. With every step from some step on
  enclosed, the enclosed queue with its web saturated binds every premise, the census
  included (`World.enclosedQueue_saturated_binds`), so there the laws of counting under the
  eight are those under enclosure and that something arises
  (`World.enclosed_binding_counting`). Every premise binding decides neither
  rest nor change without end: `hatch` comes to rest, and in a queue closed once in which
  one member replaces another at every step arising and ceasing recur
  (`World.binding_contingent`).
* **Counting where the premises of each selection bind.** Saturating a web, every relatum
  depending on every relatum at what it stands at, makes activity needing support hold
  whatever is active, and bounded transmission whatever flows where levels are bounded
  (`Web.saturated`, `World.Premised.saturated`). Under each selection, where each selected
  premise binds, the laws of counting are those of `World.counting_under` and three more
  (`World.binding_counting_under`): something is active, exactly where activity needing
  support, only active relata giving, only active relata taking or embodiment is selected
  (`World.binding_activity_iff`); something arises, exactly where embodiment is
  (`World.binding_arising_iff`); and something arises across a step at which something is
  active, exactly where embodiment is selected and the selection either binds counting or
  selects only active relata giving and bounded transmission, transmission then binding at a
  descent from a relatum active at the step (`World.binding_joint_iff`). Each binding is an
  instance of a condition, and these are what the instances leave in the counts. The
  witnesses are a queue closed once, which binds every premise whatever joins an empty queue
  and then meets every premise but only active relata giving and taking
  (`World.onceClosedQueue_binding`); an open queue with its web saturated
  (`World.openQueue_saturated_binding`); a lossy queue, whose front across one step
  exchanges a unit each way with itself and each member joining and loses one unit more,
  which no standing records (`World.lossyQueue_binding`); and a relay beside a queue, which
  hands one of two units on to a ground relatum and loses the other
  (`World.relayQueue_binding`).
* **Counting in finite worlds where the premises of each selection bind.** No finite world
  binds the census, so under a selection with the census every property of the counts is a
  law there (`World.finite_binding_census`). Under each selection without it, where each
  selected premise binds, the laws of counting in finite worlds are those of
  `World.finite_counting_under` and three more (`World.finite_binding_counting_under`):
  something is active, exactly where activity needing support, only active relata giving,
  only active relata taking or embodiment is selected (`World.finite_binding_activity_iff`);
  something arises, exactly where embodiment is (`World.finite_binding_arising_iff`); and
  something arises across a step at which something is active, exactly where embodiment is
  selected and the selection binds counting or bounds change, or selects bounded transmission
  with only active relata giving or with only active relata taking and dissipation, which in
  a finite world give only active relata giving (`World.Finite.acting`,
  `World.finite_binding_joint_iff`). The witnesses are finite: a relay beside a ring, handing
  one of the two units one place stands at on to another, which comes to stand, whatever
  holds them (`World.relayRing_binding`); a lossy ring, whose front's place across one step
  exchanges a unit each way with itself and each place coming to be held and loses one unit
  more (`World.lossyRing_binding`); a ring whose front's place, across the step after
  something joins, exchanges one unit more each way with itself
  (`World.exchangingRing_binding`); and the finite queue with its web saturated
  (`World.finiteQueue_saturated_binds`).
* **Counting under enclosure where the premises of each selection bind.** With every step
  from some step on enclosed, where the premises of each selection bind, the laws of counting
  are those of `World.enclosed_counting_under` and the three of
  `World.binding_counting_under` (`World.enclosed_binding_counting_under`): enclosure and
  binding add their laws each on its own, each of the three added under exactly the same
  selections as where nothing is enclosed (`World.enclosed_binding_activity_iff`,
  `World.enclosed_binding_arising_iff`, `World.enclosed_binding_joint_iff`). What arises may
  arise before enclosure, so a change bound with dissipation does not make it arise at a step
  of activity, as it does in finite worlds, all of whose steps are enclosed. The relay is
  enclosed at every step, and the lossy queue from the step after its gift
  (`World.relayQueue_enclosed`, `World.lossyQueue_enclosed`); without dissipation a queue whose front exchanges one unit
  more with itself across the step after something joins is enclosed at every step
  (`World.exchangingQueue_binding`); and with balance, embodiment and dissipation but
  neither only active relata giving nor taking, dissipation binds at a closed step only
  where something stands to be lost, so a queue closing at a step at which something is
  active, from which on nothing arises across a step at which nothing is active
  (`Tally.occupied_from`), has its front shed a spare unit there
  (`World.sheddingQueue_binding`).

Every law of counting here is a census table (`World.census_table_marks_hold`,
`Becoming.CensusTable`): a counted soundness, the steps the class of worlds forces on every
counted census, and a witness lemma, the queues and rings counting each tally meeting them
(`World.counting_under_sound` and `World.counting_under_witnessed`, and so for each law:
`…_sound`, `…_witnessed`). The decided law and its counted form in `Becoming.CensusCounts` and
`Becoming.CensusBinding` are the same table read with the marks of a procedure and with counts
as relations. The counted binding steps are stated here (`World.active_of_coming_jointly`,
`World.active_of_coming_taking`, `World.active_of_coming_enclosed`,
`World.enclosure_bounds_change_counted`, `World.binds_arising_counted`,
`World.CountsOf.acts_of_binding`, `World.CountsOf.joint_of_binding`).

The counts are of activity; `Becoming.Standing` states what the premises add to the counts
of what stands and of what depends. Binding here is an instance of each condition; a sense of
binding in which each premise excludes something the representation allows would be a
further reading. A property of the counts respects their values at each step (`Pointwise`),
as function extensionality would give and the pure core does not assume. Activity is
supposed decidable where a theorem needs it, each such theorem stating it as its own condition. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {α : Type}

/-! ## Counting under the premises -/

namespace Queue

/-- Relata in a queue, each active from the step it joins to the step it leaves; nothing
stands, depends or draws. -/
def web (n c : Nat → Nat) : Web Nat Nat where
  level _ _ := 0
  active t k := holds n c k t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The same queue, each relatum standing exactly while it is active. -/
def embodied (n c : Nat → Nat) : Web Nat Nat :=
  { web n c with level := fun t k => mark (holds n c k t) }

/-- None at the first step, one from then on. -/
def lone : Nat → Nat := Witnesses.profile [0] 1

/-- One joins across the first step and none after. -/
def joins : Nat → Nat := Witnesses.profile [1] 0

/-- One relatum comes to be across the first step, from none, and stays. -/
theorem lone_tally : Tally lone (fun _ => 0) joins
  | 0 => ⟨0, rfl, rfl⟩
  | _ + 1 => ⟨1, rfl, rfl⟩

end Queue

namespace World

/-- Relata queue, with nothing flowing. -/
def queue (n c : Nat → Nat) : World :=
  World.of Nat Flow.still (Queue.web n c)

/-- Relata queue, each standing exactly while it is active, with nothing flowing. -/
def embodiedQueue (n c : Nat → Nat) : World :=
  World.of Nat Flow.still (Queue.embodied n c)

instance queue_decided (n c : Nat → Nat) : ∀ t x, Decidable ((queue n c).web.active t x) :=
  fun t x => inferInstanceAs (Decidable (Queue.holds n c x t))

instance embodiedQueue_decided (n c : Nat → Nat) :
    ∀ t x, Decidable ((embodiedQueue n c).web.active t x) :=
  fun t x => inferInstanceAs (Decidable (Queue.holds n c x t))

/-- A queue meets every premise but embodiment: nothing depends, stands or flows. -/
theorem queue_premised (n c : Nat → Nat) :
    (queue n c).Dependent ∧ (queue n c).Balanced ∧ (queue n c).Acting ∧
      (queue n c).Taking ∧ (queue n c).Dissipative ∧ (queue n c).Counted ∧
      (queue n c).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no), fun _ _ => rfl, (still_vacuous _).1, (still_vacuous _).2.1,
   (still_vacuous _).2.2.1, ⟨_, Queue.listed⟩, (still_vacuous _).2.2.2⟩

/-- A queue standing while active meets every premise but balance: its standing changes
with nothing flowing. -/
theorem embodiedQueue_premised (n c : Nat → Nat) :
    (embodiedQueue n c).Dependent ∧ (embodiedQueue n c).Acting ∧
      (embodiedQueue n c).Taking ∧ (embodiedQueue n c).Dissipative ∧
      (embodiedQueue n c).Embodied ∧ (embodiedQueue n c).Counted ∧
      (embodiedQueue n c).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no), (still_vacuous _).1, (still_vacuous _).2.1,
   (still_vacuous _).2.2.1, fun _ _ => mark_pos.symm, ⟨_, Queue.listed⟩,
   (still_vacuous _).2.2.2⟩

/-- **The witnesses of free counting.** Every tally is what the census of a queue counts: with
nothing standing, depending or flowing, the queue meets every premise but embodiment; standing
while active, every premise but balance. -/
theorem counting_free_witnessed :
    Witnessed (fun w x t => w.web.active t x) (fun _ => True) (fun _ _ _ => True) ∧
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Dependent ∧ w.Balanced ∧ w.Acting ∧
      w.Taking ∧ w.Dissipative ∧ w.Transmitting) (fun _ _ _ => True) ∧
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Dependent ∧ w.Acting ∧ w.Taking ∧
      w.Dissipative ∧ w.Embodied ∧ w.Transmitting) (fun _ _ _ => True) :=
  ⟨fun n c _ tally _ => ⟨queue n c, fun x t => queue_decided n c t x, Queue.line n c, trivial,
     Queue.listed, Queue.counts tally⟩,
   fun n c _ tally _ => match queue_premised n c with
    | ⟨dependent, balanced, acting, taking, dissipative, _, transmitting⟩ =>
      ⟨queue n c, fun x t => queue_decided n c t x, Queue.line n c,
       ⟨dependent, balanced, acting, taking, dissipative, transmitting⟩, Queue.listed,
       Queue.counts tally⟩,
   fun n c _ tally _ => match embodiedQueue_premised n c with
    | ⟨dependent, acting, taking, dissipative, embodied, _, transmitting⟩ =>
      ⟨embodiedQueue n c, fun x t => embodiedQueue_decided n c t x, Queue.line n c,
       ⟨dependent, acting, taking, dissipative, embodied, transmitting⟩, Queue.listed,
       Queue.counts tally⟩⟩

/-- The premises leave counting free. A property of the counts holds of every tally exactly
when it holds of the census of every world; and already when it holds of the census of
every world meeting every premise but embodiment, or of every world meeting every premise
but balance. -/
theorem counting_free {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    ((∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.CensusMarksHold Q) ∧
    ((∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Dependent → w.Balanced →
        w.Acting → w.Taking → w.Dissipative → w.Transmitting → w.CensusMarksHold Q) ∧
    ((∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Dependent → w.Acting →
        w.Taking → w.Dissipative → w.Embodied → w.Transmitting → w.CensusMarksHold Q) :=
  ⟨(census_table_marks_hold_free pointwise counting_free_witnessed.1).trans
      ⟨fun law w _ => law w trivial, fun law w _ _ => law w⟩,
   (census_table_marks_hold_free pointwise counting_free_witnessed.2.1).trans
      ⟨fun law w _ d b ac tk ds tr => law w ⟨d, b, ac, tk, ds, tr⟩,
       fun law w _ ⟨d, b, ac, tk, ds, tr⟩ => law w d b ac tk ds tr⟩,
   (census_table_marks_hold_free pointwise counting_free_witnessed.2.2).trans
      ⟨fun law w _ d ac tk ds e tr => law w ⟨d, ac, tk, ds, e, tr⟩,
       fun law w _ ⟨d, ac, tk, ds, e, tr⟩ => law w d ac tk ds e tr⟩⟩

/-- Together, balance and embodiment bind the counts. Where the flow balances, only active
relata give and whatever arises is embodied, what arises is given by a relatum active at
the step (`Web.Embodied.arises_given`), so under a census nothing arises across a step at
which nothing is active. This is no law of tallies: one relatum arising from none is
counted by a queue meeting every premise but embodiment, and by one meeting every premise
but balance. -/
theorem counting_binds_jointly :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Balanced → w.Acting →
      w.ArisingEmbodied → w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ∧
    ¬ (queue Queue.lone fun _ => 0).CensusMarksHold (fun n _ a => ∀ t, 0 < a t → 0 < n t) ∧
    ¬ (embodiedQueue Queue.lone fun _ => 0).CensusMarksHold
      (fun n _ a => ∀ t, 0 < a t → 0 < n t) :=
  ⟨fun _ _ balanced acting embodied alive census t arising =>
    match total_pos _ arising with
    | ⟨x, _, comes⟩ => match Web.Embodied.arises_given balanced acting
        (embodied t x (mark_pos.mp comes)) (mark_pos.mp comes) with
      | ⟨f, active, _⟩ => Nat.lt_of_lt_of_le (total_pos_of_mem (((census t).2 f).mp active)
          Nat.zero_lt_one) (Nat.le_of_eq (total_ones (alive t))),
   fun marks => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (marks _ Queue.listed 0
      (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq
        (Queue.comings_eq Queue.lone_tally 0).symm)))
      (Nat.le_of_eq (Queue.counts Queue.lone_tally 0).1)),
   fun marks => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (marks _ Queue.listed 0
      (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq
        (Queue.comings_eq Queue.lone_tally 0).symm)))
      (Nat.le_of_eq (Queue.counts Queue.lone_tally 0).1))⟩


/-- Where the flow balances, only active relata give and whatever arises is embodied, under a
census something coming to be across a step needs something active at it. -/
theorem active_of_coming_jointly {w : World} (balanced : w.Balanced) (acting : w.Acting)
    (embodied : w.ArisingEmbodied) {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    {t : Nat} {x : w.Relatum} (comes : ComesToBe (fun s => w.web.active s x) t) :
    0 < (alive t).length :=
  match Web.Embodied.arises_given balanced acting (embodied t x comes) comes with
  | ⟨f, active, _⟩ => Nat.lt_of_lt_of_le (total_pos_of_mem (((census t).2 f).mp active)
      Nat.zero_lt_one) (Nat.le_of_eq (total_ones (alive t)))

/-- Where the flow balances, only active relata take and only from what they draw on, the flow
dissipates and every relatum is embodied, under a census something coming to be across a step
needs something active at it, whoever gives. -/
theorem active_of_coming_taking {w : World} (balanced : w.Balanced) (taking : w.Taking)
    (dissipative : w.Dissipative) (embodied : w.Embodied) {alive : Nat → List w.Relatum}
    (census : w.web.Census alive) {t : Nat} {x : w.Relatum} (listed : x ∈ alive (t + 1))
    (comes : ComesToBe (fun s => w.web.active s x) t) : 0 < (alive t).length :=
  match Nat.eq_zero_or_pos (alive t).length with
  | .inr pos => pos
  | .inl empty =>
    have idle : ∀ f, ¬ w.web.active t f := fun f active =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (total_pos_of_mem (((census t).2 f).mp active) Nat.zero_lt_one)
        (Nat.le_of_eq (total_ones (alive t)))) (Nat.le_of_eq empty))
    have untaken : ∀ f c, f ∈ w.flow.present t → w.flow.take t f c = 0 :=
      fun f c present => eq_zero_of_not_pos fun takes => idle f (taking t f c present takes).1
    have flows : ∀ c, w.web.level (t + 1) c = w.flow.given t c := fun c =>
      (congrArg (w.web.level (t + 1) c + ·)
          ((total_congr_on (g := fun _ => 0) fun f present => untaken f c present).trans
            (total_zero _)).symm).trans
        ((balanced t c).trans ((congrArg (· + w.flow.given t c)
          (eq_zero_of_not_pos fun stands => idle c ((embodied c t).mpr stands))).trans
          (Nat.zero_add _)))
    have closed : w.flow.ClosedAt (alive (t + 1)) t := fun f present c outside =>
      ⟨untaken f c present, eq_zero_of_not_pos fun gives => outside
        (((census (t + 1)).2 c).mp ((embodied c (t + 1)).mpr (Nat.lt_of_lt_of_le
          (Nat.lt_of_lt_of_le gives (le_total_of_mem (q := fun g => w.flow.give t g c)
            present)) (Nat.le_of_eq (flows c).symm))))⟩
    False.elim ((dissipative _ t (census (t + 1)).1 closed).still_untaken (balanced.on _ t)
      (fun c _ => (total_congr_on (g := fun _ => 0) fun f present =>
        untaken f c present).trans (total_zero _))
      ⟨x, listed, Nat.lt_of_le_of_lt (Nat.le_of_eq (eq_zero_of_not_pos fun stands =>
        idle x ((embodied x t).mpr stands))) ((embodied x (t + 1)).mp comes.2)⟩)

end World

/-! ## Counting under all the premises -/

namespace OpenQueue

/-- The members of a queue, and ground relata. -/
inductive Relatum
  | member (k : Nat)
  | ground (k : Nat)

variable (n c : Nat → Nat)

/-- Members stand and are active exactly while in the queue; ground relata stand at nothing
and are never active. -/
def web : Web Relatum Relatum where
  level t x := match x with
    | .member k => mark (Queue.holds n c k t)
    | .ground _ => 0
  active t x := match x with
    | .member k => Queue.holds n c k t
    | .ground _ => False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The front of the queue takes part at every step. It gives one unit to each member
joining and takes one from each member leaving; while active it also gives one unit to every
ground relatum and takes one from each. -/
def flow : Flow Relatum Relatum where
  present t := [.member (Queue.gone c t)]
  take t _ x := match x with
    | .member k => mark (CeasesToBe (Queue.holds n c k) t)
    | .ground _ => mark (Queue.holds n c (Queue.gone c t) t)
  give t _ x := match x with
    | .member k => mark (ComesToBe (Queue.holds n c k) t)
    | .ground _ => mark (Queue.holds n c (Queue.gone c t) t)

def index : Relatum → Nat
  | .member k => k
  | .ground k => k

/-- No finite family holds every ground relatum. -/
theorem outside (cs : List Relatum) : ¬ Relatum.ground (beyond (cs.map index)) ∈ cs :=
  fun mem => beyond_not_mem _ (mem_map_of (g := index) mem)

theorem member_inj : ∀ a b : Nat, Relatum.member a = Relatum.member b → a = b :=
  fun _ _ same => Relatum.noConfusion same id

theorem ground_not_member {g : Nat} : ∀ {l : List Nat}, ¬ Relatum.ground g ∈ l.map .member
  | [], no => nomatch no
  | _ :: _, .tail _ mem => ground_not_member mem

variable {n c}

/-- The front of the queue is in it exactly while the queue is not empty. -/
theorem front {t : Nat} : Queue.holds n c (Queue.gone c t) t ↔ 0 < n t :=
  ⟨fun holds => Nat.lt_of_add_lt_add_left (n := Queue.gone c t) (k := 0) holds.2,
   fun pos => ⟨Nat.le_refl _, Nat.lt_add_of_pos_right pos⟩⟩

/-- A member in the queue means the queue is not empty. -/
theorem occupied {k t : Nat} (holds : Queue.holds n c k t) : 0 < n t :=
  Nat.lt_of_add_lt_add_left (n := Queue.gone c t) (k := 0) (Nat.lt_of_le_of_lt holds.1 holds.2)

/-- Where something joins only across a step at which the queue is not empty, a member
joining means the queue was not empty. -/
theorem joined {a : Nat → Nat} (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    {k t : Nat} (comes : ComesToBe (Queue.holds n c k) t) : 0 < n t :=
  company t (Nat.lt_of_lt_of_le (total_pos_of_mem (q := fun j => mark (ComesToBe
    (Queue.holds n c j) t)) (steps_of_within comes.2.1 comes.2.2) (mark_pos.mpr comes))
    (Nat.le_of_eq (Queue.comings_eq tally t)))

end OpenQueue

namespace World

/-- An open queue: its front gives to each relatum joining, takes from each
leaving, and while active exchanges one unit each way with every ground relatum. -/
def openQueue (n c : Nat → Nat) : World :=
  World.of OpenQueue.Relatum (OpenQueue.flow n c) (OpenQueue.web n c)

instance openQueue_decided (n c : Nat → Nat) :
    ∀ t x, Decidable ((openQueue n c).web.active t x)
  | t, .member k => inferInstanceAs (Decidable (Queue.holds n c k t))
  | _, .ground _ => isFalse id

/-- The census of an open queue is its members, listed as the queue lists them. -/
theorem openQueue_census (n c : Nat → Nat) :
    (openQueue n c).web.Census fun t => (Queue.line n c t).map .member :=
  fun _ => ⟨distinct_map OpenQueue.member_inj (steps_distinct _ _), fun x => match x with
    | .member _ => ⟨fun holds => mem_map_of (steps_of_within holds.1 holds.2),
        fun mem => match mem_of_map OpenQueue.member_inj mem with
          | listed => ⟨steps_mem listed, steps_within listed⟩⟩
    | .ground _ => ⟨False.elim, fun mem => OpenQueue.ground_not_member mem⟩⟩

/-- Its census counts what the queue counts. -/
theorem openQueue_counts {n c a : Nat → Nat} (tally : Tally n c a) (t : Nat) :
    ((Queue.line n c t).map OpenQueue.Relatum.member).length = n t ∧
      ceasings ((Queue.line n c t).map .member)
        (fun x s => (openQueue n c).web.active s x) t = c t ∧
      comings ((Queue.line n c (t + 1)).map .member)
        (fun x s => (openQueue n c).web.active s x) t = a t :=
  ⟨(total_ones _).symm.trans ((total_map _ _ _).trans ((total_ones _).trans (steps_length _ _))),
   (total_map OpenQueue.Relatum.member _ (Queue.line n c t)).trans (Queue.ceasings_eq tally t),
   (total_map OpenQueue.Relatum.member _ (Queue.line n c (t + 1))).trans
     (Queue.comings_eq tally t)⟩

/-- Whatever its counts, an open queue balances, only active relata take there and only from
what they draw on, every relatum is embodied, it has a census, and nothing depends on
anything. Only active relata giving and dissipation can fail: where something joins an
empty queue, its front gives while inactive. -/
theorem openQueue_holds (n c : Nat → Nat) :
    (openQueue n c).Dependent ∧ (openQueue n c).Balanced ∧ (openQueue n c).Taking ∧
      (openQueue n c).Embodied ∧ (openQueue n c).Counted ∧ (openQueue n c).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no),
   fun t x => match x with
    | .member k => mark_turn (Queue.holds n c k t) (Queue.holds n c k (t + 1))
    | .ground _ => rfl,
   fun _ f x present takes => match f, present, x, takes with
    | _, .head _, .member _, takes => ⟨OpenQueue.front.mpr (OpenQueue.occupied
        (mark_pos.mp takes).1), trivial⟩
    | _, .head _, .ground _, takes => ⟨mark_pos.mp takes, trivial⟩
    | _, .tail _ no, _, _ => (nomatch no),
   fun x => match x with
    | .member _ => fun _ => mark_pos.symm
    | .ground _ => fun _ => ⟨False.elim, fun no => absurd no (Nat.lt_irrefl 0)⟩,
   ⟨_, openQueue_census n c⟩,
   ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩⟩

/-- Where something arises only across a step at which something is active, an open queue
meets all eight premises. Not all of them bind: no step at which the front is active is
enclosed, and nothing depends on anything (`openQueue_not_binds`). -/
theorem openQueue_premised {n c a : Nat → Nat} (tally : Tally n c a)
    (company : ∀ t, 0 < a t → 0 < n t) : (openQueue n c).Premised :=
  match openQueue_holds n c with
  | ⟨dependent, balanced, taking, embodied, counted, transmitting⟩ =>
    .of dependent balanced
      (fun _ f x present gives => match f, present, x, gives with
        | _, .head _, .member _, gives => OpenQueue.front.mpr (OpenQueue.joined tally company
            (mark_pos.mp gives))
        | _, .head _, .ground _, gives => mark_pos.mp gives
        | _, .tail _ no, _, _ => (nomatch no))
      taking
      (fun cs t _ closed _ _ => match Nat.eq_zero_or_pos (n t) with
        | .inr pos => absurd ((mark_one (OpenQueue.front.mpr pos)).symm.trans
            (closed _ (.head _) _ (OpenQueue.outside cs)).2) (fun no => Nat.noConfusion no)
        | .inl empty => gives_nothing ((total_congr_on (g := fun _ => 0) fun x _ => match x with
            | .member _ => mark_zero fun comes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
                (OpenQueue.joined tally company comes) (Nat.le_of_eq empty))
            | .ground _ => mark_zero fun holds => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
                (OpenQueue.front.mp holds) (Nat.le_of_eq empty))).trans (total_zero cs)))
      embodied counted transmitting

/-- **The binding step under the eight premises, for every counted census**: nothing arises
across a step at which nothing is active (`active_of_coming_jointly`). -/
theorem premised_counting_sound (w : World) (premised : w.Premised) :
    w.CountsHold fun n _ a => ∀ t, 0 < a t → 0 < n t :=
  fun _ _ _ _ census counted t arising => match counted t with
    | ⟨length, _, came⟩ => match came.exists_of_pos arising with
      | ⟨_, _, comes⟩ => Nat.lt_of_lt_of_le (active_of_coming_jointly
          (premised _ (.tail _ (.head _))) (premised _ (.tail _ (.tail _ (.head _))))
          (Embodied.arising (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _
            (.head _))))))))
          census comes) (Nat.le_of_eq length.symm)

/-- **The witness under the eight premises**: every tally in which nothing arises across a step at
which nothing is active is what the census of an open queue counts. -/
theorem premised_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x) (·.Premised)
      fun n _ a => ∀ t, 0 < a t → 0 < n t :=
  fun n c _ tally company => ⟨openQueue n c, fun x t => openQueue_decided n c t x, _,
    openQueue_premised tally company, openQueue_census n c, openQueue_counts tally⟩

/-- Under all eight premises the laws of counting are the tally and that nothing arises
across a step at which nothing is active: a property of the counts holds of every census of
every world meeting the eight exactly when it holds of every tally in which something arises
only across a step at which something is active. -/
theorem premised_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.CensusMarksHold Q :=
  census_table_marks_hold pointwise premised_counting_sound premised_counting_witnessed

/-- In an open queue dissipation, activity needing support and bounded transmission hold
vacuously. Nothing taking part takes from a closed family: where something is taken the
front is active, and then it gives to a ground relatum beyond every finite family. Nothing
depends on anything. So not every premise binds there (the thirteenth review's probe). -/
theorem openQueue_not_binds {n c : Nat → Nat} :
    ¬ Premise.dissipative.Binds (openQueue n c) ∧ ¬ Premise.dependent.Binds (openQueue n c) ∧
      ¬ Premise.transmitting.Binds (openQueue n c) ∧ ¬ (openQueue n c).Binds :=
  have idle : ¬ Premise.dissipative.Binds (openQueue n c) :=
    fun ⟨cs, t, f, _, closed, present, takes⟩ => match total_pos cs takes with
      | ⟨x, _, positive⟩ =>
        have occupied : 0 < n t := match x, positive with
          | .member _, positive => OpenQueue.occupied (mark_pos.mp positive).1
          | .ground _, positive => OpenQueue.front.mp (mark_pos.mp positive)
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq
          ((mark_one (OpenQueue.front.mpr occupied)).symm.trans
            (closed f present _ (OpenQueue.outside cs)).2)))
  ⟨idle, fun ⟨_, _, _, _, no, _⟩ => no, fun ⟨_, _, _, _, _, no⟩ => no,
   fun binds => idle (binds .dissipative)⟩

/-- Where embodiment binds, every census counts something arising: embodiment binds only
where something arises (the thirteenth review's probe). -/
theorem binds_arising (w : World) [∀ t x, Decidable (w.web.active t x)]
    (binds : Premise.embodied.Binds w) : w.CensusMarksHold fun _ _ a => ∃ t, 0 < a t :=
  fun _ census => match binds with
  | ⟨t, x, arises⟩ =>
    ⟨t, Nat.lt_of_lt_of_le (mark_pos.mpr arises)
      (le_total_of_mem (q := fun y => mark (ComesToBe (fun s => w.web.active s y) t))
        (((census (t + 1)).2 x).mp arises.2))⟩

/-- Under the eight premises something arising is no law of counting, as the empty tally
shows; where every premise binds it is one (`binds_arising`). The laws of
`premised_counting` hold of worlds in which some premises hold vacuously (the thirteenth
review's probe). -/
theorem binds_adds :
    ¬ ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised →
      w.CensusMarksHold fun _ _ a => ∃ t, 0 < a t :=
  fun law => match (premised_counting (Q := fun _ _ a => ∃ t, 0 < a t)
      (fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩)).mpr
      law (fun _ => 0) (fun _ => 0) (fun _ => 0) (fun _ => ⟨0, rfl, rfl⟩) (fun _ no => no) with
    | ⟨_, no⟩ => Nat.lt_irrefl 0 no

end World

/-! ## Counting under each selection -/

namespace OpenQueue

/-- An inactive ground relatum drives the queue: at every step it gives one unit to each member
joining, takes one from each member leaving, and exchanges one unit each way with every
ground relatum, so no family is closed across any step. -/
def driven (n c : Nat → Nat) : Flow Relatum Relatum where
  present _ := [.ground 0]
  take t _ x := match x with
    | .member k => mark (CeasesToBe (Queue.holds n c k) t)
    | .ground _ => 1
  give t _ x := match x with
    | .member k => mark (ComesToBe (Queue.holds n c k) t)
    | .ground _ => 1

end OpenQueue

namespace World

/-- A queue driven by an inactive relatum: the members of an open queue, the exchange driven
from a ground relatum never active. -/
def drivenQueue (n c : Nat → Nat) : World :=
  World.of OpenQueue.Relatum (OpenQueue.driven n c) (OpenQueue.web n c)

instance drivenQueue_decided (n c : Nat → Nat) :
    ∀ t x, Decidable ((drivenQueue n c).web.active t x) :=
  openQueue_decided n c

/-- Whatever its counts, a driven queue balances, dissipates, since no family is closed
across any step, has every relatum embodied and a census, and nothing depends on anything.
Only active relata giving and only active relata taking fail. -/
theorem drivenQueue_holds (n c : Nat → Nat) :
    (drivenQueue n c).Dependent ∧ (drivenQueue n c).Balanced ∧
      (drivenQueue n c).Dissipative ∧ (drivenQueue n c).Embodied ∧
      (drivenQueue n c).Counted ∧ (drivenQueue n c).Transmitting :=
  match openQueue_holds n c with
  | ⟨dependent, _, _, embodied, counted, _⟩ =>
    ⟨dependent,
     fun t x => match x with
      | .member k => mark_turn (Queue.holds n c k t) (Queue.holds n c k (t + 1))
      | .ground _ => rfl,
     fun cs _ _ closed => absurd (closed _ (.head _) _ (OpenQueue.outside cs)).2
       (fun no => Nat.noConfusion no),
     embodied, counted, ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩⟩

/-- Taking and dissipation can stand in for only active relata giving. Where the flow
balances, only active relata take and only from what they draw on, the flow dissipates and
every relatum is embodied, then under a census nothing arises across a step at which nothing
is active, whoever gives. At such a step nothing is taken and nothing stands; whatever is
given comes to stand, so it is active after the step, and the relata active after it form
a closed family, to which dissipation lets nothing be given without taking
(`Flow.DissipatesOn.still_untaken`). -/
theorem taking_binds_counting (w : World) [∀ t x, Decidable (w.web.active t x)]
    (balanced : w.Balanced) (taking : w.Taking) (dissipative : w.Dissipative)
    (embodied : w.Embodied) : w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t :=
  fun alive census t arising => match Nat.eq_zero_or_pos (alive t).length with
    | .inr pos => pos
    | .inl empty =>
      have idle : ∀ f, ¬ w.web.active t f := fun f active =>
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
          (total_pos_of_mem (((census t).2 f).mp active) Nat.zero_lt_one)
          (Nat.le_of_eq (total_ones (alive t)))) (Nat.le_of_eq empty))
      have untaken : ∀ f c, f ∈ w.flow.present t → w.flow.take t f c = 0 :=
        fun f c present => eq_zero_of_not_pos fun takes => idle f (taking t f c present takes).1
      have flows : ∀ c, w.web.level (t + 1) c = w.flow.given t c := fun c =>
        (congrArg (w.web.level (t + 1) c + ·)
            ((total_congr_on (g := fun _ => 0) fun f present => untaken f c present).trans
              (total_zero _)).symm).trans
          ((balanced t c).trans ((congrArg (· + w.flow.given t c)
            (eq_zero_of_not_pos fun stands => idle c ((embodied c t).mpr stands))).trans
            (Nat.zero_add _)))
      have closed : w.flow.ClosedAt (alive (t + 1)) t := fun f present c outside =>
        ⟨untaken f c present, eq_zero_of_not_pos fun gives => outside
          (((census (t + 1)).2 c).mp ((embodied c (t + 1)).mpr (Nat.lt_of_lt_of_le
            (Nat.lt_of_lt_of_le gives (le_total_of_mem (q := fun g => w.flow.give t g c)
              present)) (Nat.le_of_eq (flows c).symm))))⟩
      match total_pos _ arising with
      | ⟨x, listed, comes⟩ => False.elim
        ((dissipative _ t (census (t + 1)).1 closed).still_untaken (balanced.on _ t)
          (fun c _ => (total_congr_on (g := fun _ => 0) fun f present =>
            untaken f c present).trans (total_zero _))
          ⟨x, listed, Nat.lt_of_le_of_lt (Nat.le_of_eq (eq_zero_of_not_pos fun stands =>
            idle x ((embodied x t).mpr stands))) ((embodied x (t + 1)).mp (mark_pos.mp comes).2)⟩)

/-- Enclosure lets dissipation stand in for only active relata giving, too. Where the flow
balances and dissipates and every relatum is embodied, under a census nothing arises across
an enclosed step at which nothing is active, whoever gives and whoever takes: nothing stands
there, so a closed family's stock is nothing, and nothing comes to stand from nothing
(`Flow.BalancesOn.comes_from_standing`). -/
theorem enclosed_binds_counting (w : World) [∀ t x, Decidable (w.web.active t x)]
    (balanced : w.Balanced) (dissipative : w.Dissipative) (embodied : w.Embodied)
    {alive : Nat → List w.Relatum} (census : w.web.Census alive) {t : Nat}
    (enclosed : w.flow.Enclosed t)
    (arising : 0 < comings (alive (t + 1)) (fun x s => w.web.active s x) t) :
    0 < (alive t).length :=
  match Nat.eq_zero_or_pos (alive t).length, enclosed, total_pos _ arising with
  | .inr pos, _, _ => pos
  | .inl empty, ⟨cs, distinct, closed⟩, ⟨x, _, comes⟩ =>
    have idle : ∀ f, ¬ w.web.active t f := fun f active =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (total_pos_of_mem (((census t).2 f).mp active) Nat.zero_lt_one)
        (Nat.le_of_eq (total_ones (alive t)))) (Nat.le_of_eq empty))
    have nothing : w.web.stock cs t = 0 :=
      total_eq_zero fun c _ => eq_zero_of_not_pos fun stands => idle c ((embodied c t).mpr stands)
    have comes : w.web.ComesToStand t x :=
      ⟨fun stands => idle x ((embodied x t).mpr stands),
       (embodied x (t + 1)).mp (mark_pos.mp comes).2⟩
    match total_pos _ (Flow.Balances.rise_given balanced comes.rises) with
    | ⟨f, present, gives⟩ =>
      absurd (fun mem => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          ((balanced.on cs t).comes_from_standing (dissipative cs t distinct closed) mem comes)
          (Nat.le_of_eq nothing)))
        fun out => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives
          (Nat.le_of_eq (closed f present x out).2))

/-- A selection binds counting when it selects balance and embodiment, and either only
active relata giving or both only active relata taking and dissipation. -/
def BindsCounting (S : Premise → Bool) : Prop :=
  S .balanced = true ∧ S .embodied = true ∧
    (S .acting = true ∨ S .taking = true ∧ S .dissipative = true)

/-- A queue meets every selection without embodiment. -/
theorem queue_meets (n c : Nat → Nat) {S : Premise → Bool} (free : S .embodied = false) :
    (queue n c).Meets S :=
  match queue_premised n c with
  | ⟨dependent, balanced, acting, taking, dissipative, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, _ => dissipative
    | .embodied, selected => nomatch free.symm.trans selected
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- A queue standing while active meets every selection without balance. -/
theorem embodiedQueue_meets (n c : Nat → Nat) {S : Premise → Bool}
    (free : S .balanced = false) : (embodiedQueue n c).Meets S :=
  match embodiedQueue_premised n c with
  | ⟨dependent, acting, taking, dissipative, embodied, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, selected => nomatch free.symm.trans selected
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, _ => dissipative
    | .embodied, _ => embodied
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- An open queue meets every selection without only active relata giving and without
dissipation. -/
theorem openQueue_meets (n c : Nat → Nat) {S : Premise → Bool} (giving : S .acting = false)
    (dissipating : S .dissipative = false) : (openQueue n c).Meets S :=
  match openQueue_holds n c with
  | ⟨dependent, balanced, taking, embodied, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, selected => nomatch giving.symm.trans selected
    | .taking, _ => taking
    | .dissipative, selected => nomatch dissipating.symm.trans selected
    | .embodied, _ => embodied
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- A driven queue meets every selection without only active relata giving and without
only active relata taking. -/
theorem drivenQueue_meets (n c : Nat → Nat) {S : Premise → Bool} (giving : S .acting = false)
    (taking : S .taking = false) : (drivenQueue n c).Meets S :=
  match drivenQueue_holds n c with
  | ⟨dependent, balanced, dissipative, embodied, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, selected => nomatch giving.symm.trans selected
    | .taking, selected => nomatch taking.symm.trans selected
    | .dissipative, _ => dissipative
    | .embodied, _ => embodied
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- **The binding steps, for every counted census.** Under a selection binding counting, the
counts of every census, counts as relations with no decision procedure, have nothing arising
across a step at which nothing is active (`active_of_coming_jointly`,
`active_of_coming_taking`). -/
theorem counting_under_sound (S : Premise → Bool) (w : World) (meets : w.Meets S) :
    w.CountsHold fun n _ a => BindsCounting S → ∀ t, 0 < a t → 0 < n t :=
  fun _ _ _ _ census counted ⟨balanced, embodied, giving⟩ t arising => match counted t with
    | ⟨length, _, came⟩ => match came.exists_of_pos arising with
      | ⟨_, listed, comes⟩ => Nat.lt_of_lt_of_le (match giving with
        | .inl acting => active_of_coming_jointly (meets _ balanced) (meets _ acting)
            (Embodied.arising (meets _ embodied)) census comes
        | .inr ⟨taking, dissipative⟩ => active_of_coming_taking (meets _ balanced)
            (meets _ taking) (meets _ dissipative) (meets _ embodied) census listed comes)
        (Nat.le_of_eq length.symm)

/-- **The witnesses under each selection.** Every tally, with nothing arising across a step at
which nothing is active where the selection binds counting, is what the census of a queue meeting
the selection counts: standing while active where balance is not selected, with nothing standing
where embodiment is not, open where only active relata giving, or only active relata taking with
dissipation, is selected, driven by a ground relatum where neither giving nor taking is, and open
where taking is selected without dissipation. -/
theorem counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => w.web.active t x) (·.Meets S)
      fun n _ a => BindsCounting S → ∀ t, 0 < a t → 0 < n t :=
  fun n c _ tally quiet => match hb : S .balanced, he : S .embodied with
    | false, _ => ⟨embodiedQueue n c, fun x t => embodiedQueue_decided n c t x, Queue.line n c,
        embodiedQueue_meets n c hb, Queue.listed, Queue.counts tally⟩
    | true, false => ⟨queue n c, fun x t => queue_decided n c t x, Queue.line n c,
        queue_meets n c he, Queue.listed, Queue.counts tally⟩
    | true, true => match ha : S .acting, ht : S .taking, hd : S .dissipative with
      | true, _, _ => ⟨openQueue n c, fun x t => openQueue_decided n c t x, _,
          (openQueue_premised tally (quiet ⟨hb, he, .inl ha⟩)).meets S, openQueue_census n c,
          openQueue_counts tally⟩
      | false, true, true => ⟨openQueue n c, fun x t => openQueue_decided n c t x, _,
          (openQueue_premised tally (quiet ⟨hb, he, .inr ⟨ht, hd⟩⟩)).meets S,
          openQueue_census n c, openQueue_counts tally⟩
      | false, false, _ => ⟨drivenQueue n c, fun x t => drivenQueue_decided n c t x, _,
          drivenQueue_meets n c ha ht, openQueue_census n c, openQueue_counts tally⟩
      | false, true, false => ⟨openQueue n c, fun x t => openQueue_decided n c t x, _,
          openQueue_meets n c ha hd, openQueue_census n c, openQueue_counts tally⟩

/-- The laws of counting under each selection of the premises. A property of the counts
holds of every census of every world meeting the selection exactly when it holds of every
tally, and, where the selection binds counting, of every tally in which nothing arises across
a step at which nothing is active. So the laws of counting under the 256 selections are of
two kinds: the tally alone, or the tally and nothing arising at a step at which nothing is
active, the second exactly where balance, embodiment, and only active relata giving or
taking with dissipation are selected. -/
theorem counting_under (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.CensusMarksHold Q :=
  census_table_marks_hold pointwise (counting_under_sound S) (counting_under_witnessed S)

/-- Nothing arising across a step at which nothing is active is a law of counting under a
selection exactly when the selection binds counting. -/
theorem counting_binds_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ↔ BindsCounting S :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∀ t, 0 < a t → 0 < n t :=
    fun same law t pos => Nat.lt_of_lt_of_le (law t (Nat.lt_of_lt_of_le pos
      (Nat.le_of_eq (same t).2.2.symm))) (Nat.le_of_eq (same t).1)
  have unbound : ¬ BindsCounting S → ¬ ∀ (w : World) [∀ t x, Decidable (w.web.active t x)],
      w.Meets S → w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t := fun free law =>
    Nat.lt_irrefl 0 ((counting_under S pointwise).mpr law _ _ _ Queue.lone_tally
      (fun binds => absurd binds free) 0 Nat.zero_lt_one)
  ⟨fun law => match hb : S .balanced, he : S .embodied, ha : S .acting, ht : S .taking,
      hd : S .dissipative with
    | true, true, true, _, _ => ⟨hb, he, .inl ha⟩
    | true, true, false, true, true => ⟨hb, he, .inr ⟨ht, hd⟩⟩
    | false, _, _, _, _ => absurd law (unbound fun binds => nomatch hb.symm.trans binds.1)
    | true, false, _, _, _ => absurd law (unbound fun binds => nomatch he.symm.trans binds.2.1)
    | true, true, false, false, _ => absurd law (unbound fun binds => match binds.2.2 with
        | .inl acting => nomatch ha.symm.trans acting
        | .inr ⟨taking, _⟩ => nomatch ht.symm.trans taking)
    | true, true, false, true, false => absurd law (unbound fun binds => match binds.2.2 with
        | .inl acting => nomatch ha.symm.trans acting
        | .inr ⟨_, dissipative⟩ => nomatch hd.symm.trans dissipative),
   fun binds => (counting_under S pointwise).mp fun _ _ _ _ quiet => quiet binds⟩

end World

/-! ## Counting under enclosure -/

namespace World

variable {w : World}

/-- Under a census of embodied relata, each relatum active at a step stands there, so they
number at most the total standing. -/
theorem length_le_stock {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) (t : Nat) : (alive t).length ≤ w.web.stock (alive t) t :=
  Nat.le_trans (Nat.le_of_eq (total_ones (alive t)).symm) (total_le (alive t) fun x mem =>
    (embodied x t).mp (((census t).2 x).mpr mem))

/-- Enclosure bounds change. In a world with a census whose relata are embodied, with a
balanced, dissipative flow, in which every step from `T` on is enclosed, the total standing
at `T` bounds the change of the census from `T`: the relata active at any
later step, with the steps since `T` at which something arose or ceased, number at most
that total. The corollary of `Flow.runsDown_change_bound`: the premises make what stands run
down across those steps, and embodiment makes each arising and ceasing a change of
standing. -/
theorem enclosure_bounds_change [∀ t x, Decidable (w.web.active t x)]
    {alive : Nat → List w.Relatum} (census : w.web.Census alive) (embodied : w.Embodied)
    (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) :
    ChangeBound T (w.web.stock (alive T) T) (fun t => (alive t).length)
      (fun t => ceasings (alive t) (fun x s => w.web.active s x) t)
      (fun t => comings (alive (t + 1)) (fun x s => w.web.active s x) t) :=
  have standing := standingCensus census embodied
  Flow.runsDown_change_bound standing
    (fun t later down => (enclosed t later).aroundStanding_not_not alive fun around =>
      down (around.runsDownClosed balanced dissipative standing).runsDown)
    (fun t _ => length_le_stock census embodied t)
    fun t _ changes => match Nat.eq_zero_or_pos (ceasings (alive t)
        (fun x s => w.web.active s x) t) with
      | .inr ceasing => match total_pos _ ceasing with
        | ⟨x, _, ceases⟩ => ⟨x, .inr (falls_of_ceases embodied (mark_pos.mp ceases))⟩
      | .inl still => match total_pos _ (Nat.lt_of_lt_of_le changes (Nat.le_of_eq
          ((congrArg (· + _) still).trans (Nat.zero_add _)))) with
        | ⟨x, _, comes⟩ => ⟨x, .inl (rises_of_arises embodied (mark_pos.mp comes))⟩

/-! ## Enclosure bounds change, where the counts exist -/

/-- **Enclosure bounds change for every counted census.** In a world whose relata are embodied,
with a balanced, dissipative flow and every step from `T` on enclosed, the total standing at `T`
bounds the change of every counted census from `T`. No decidedness. -/
theorem enclosure_bounds_change_counted {w : World} {alive : Nat → List w.Relatum}
    (census : w.web.Census alive) {n c a : Nat → Nat} (counted : w.CountsOf alive n c a)
    (embodied : w.Embodied) (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) :
    ChangeBound T (w.web.stock (alive T) T) n c a :=
  have standing := standingCensus census embodied
  Flow.runsDown_change_bound standing
    (fun t later down => (enclosed t later).aroundStanding_not_not alive fun around =>
      down (around.runsDownClosed balanced dissipative standing).runsDown)
    (fun t _ => Nat.le_trans (Nat.le_of_eq (counted t).1) (length_le_stock census embodied t))
    fun t _ changes => match counted t with
    | ⟨_, ceased, came⟩ => match Nat.eq_zero_or_pos (c t) with
      | .inr ceasing => match ceased.exists_of_pos ceasing with
        | ⟨x, _, ceases⟩ => ⟨x, .inr (falls_of_ceases embodied ceases)⟩
      | .inl still => match came.exists_of_pos (Nat.lt_of_lt_of_le changes (Nat.le_of_eq
          ((congrArg (· + a t) still).trans (Nat.zero_add _)))) with
        | ⟨x, _, comes⟩ => ⟨x, .inl (rises_of_arises embodied comes)⟩

/-- At an enclosed step, where the flow balances and dissipates and every relatum is embodied,
under a census something coming to be across the step needs something active at it, whoever
gives and whoever takes. -/
theorem active_of_coming_enclosed (balanced : w.Balanced) (dissipative : w.Dissipative)
    (embodied : w.Embodied) {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    {t : Nat} (enclosed : w.flow.Enclosed t) {x : w.Relatum}
    (comes : ComesToBe (fun s => w.web.active s x) t) : 0 < (alive t).length :=
  match Nat.eq_zero_or_pos (alive t).length, enclosed with
  | .inr pos, _ => pos
  | .inl empty, ⟨cs, distinct, closed⟩ =>
    have idle : ∀ f, ¬ w.web.active t f := fun f active =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (total_pos_of_mem (((census t).2 f).mp active) Nat.zero_lt_one)
        (Nat.le_of_eq (total_ones (alive t)))) (Nat.le_of_eq empty))
    have nothing : w.web.stock cs t = 0 :=
      total_eq_zero fun c _ => eq_zero_of_not_pos fun stands => idle c ((embodied c t).mpr stands)
    have stands : w.web.ComesToStand t x :=
      ⟨fun standing => idle x ((embodied x t).mpr standing), (embodied x (t + 1)).mp comes.2⟩
    match total_pos _ (Flow.Balances.rise_given balanced stands.rises) with
    | ⟨f, present, gives⟩ =>
      absurd (fun mem => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          ((balanced.on cs t).comes_from_standing (dissipative cs t distinct closed) mem stands)
          (Nat.le_of_eq nothing)))
        fun out => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives
          (Nat.le_of_eq (closed f present x out).2))

end World

namespace EnclosedQueue

variable (n c a : Nat → Nat) (B : Nat)

/-- What stands: `B`, less one for each step at which something ceased or arose. -/
def store (t : Nat) : Nat :=
  B - occurrences 0 (fun s => c s + a s) t

/-- Standing in a queue whose front is `g` and which holds `m`: one, and `s` more at the
front. -/
def place (g m s k : Nat) : Nat :=
  if g ≤ k ∧ k < g + m then 1 + (if k = g then s else 0) else 0

/-- Members stand by their place in the queue, the front holding what the store holds
beyond one for each member. -/
def level (t k : Nat) : Nat :=
  place (Queue.gone c t) (n t) (store c a B t - n t) k

/-- Members stand and are active exactly while in the queue. -/
def web : Web Nat Nat where
  level := level n c a B
  active t k := Queue.holds n c k t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The front takes part at every step. It takes from each member what that member's
standing loses across the step and gives each what it gains. -/
def flow : Flow Nat Nat where
  present t := [Queue.gone c t]
  take t _ k := level n c a B t k - level n c a B (t + 1) k
  give t _ k := level n c a B (t + 1) k - level n c a B t k

/-- The members in the queue before or after the step from `t`. -/
def span (t : Nat) : List Nat :=
  steps (Queue.gone c t) (n t + a t)

variable {n c a : Nat → Nat} {B : Nat}

theorem place_pos {g m s k : Nat} : (g ≤ k ∧ k < g + m) ↔ 0 < place g m s k :=
  if h : g ≤ k ∧ k < g + m then
    ⟨fun _ => Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right 1 _))
      (Nat.le_of_eq (if_pos h).symm), fun _ => h⟩
  else
    ⟨fun holds => absurd holds h,
     fun pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg h))) (Nat.lt_irrefl 0)⟩

theorem place_zero {g m s k : Nat} (out : ¬ (g ≤ k ∧ k < g + m)) : place g m s k = 0 :=
  if_neg out

/-- A queue of `m + 1` stands at `m + 1`, and `s` more at its front. -/
theorem total_place (g m s : Nat) : total (steps g (m + 1)) (place g (m + 1) s) = m + 1 + s :=
  have front : place g (m + 1) s g = 1 + s :=
    (if_pos ⟨Nat.le_refl g, Nat.lt_add_of_pos_right (Nat.succ_pos m)⟩).trans
      (congrArg (1 + ·) (if_pos rfl))
  have rest : total (steps (g + 1) m) (place g (m + 1) s) = m :=
    (total_congr_on (g := fun _ => 1) fun _ mem =>
      (if_pos ⟨Nat.le_of_succ_le (steps_mem mem), Nat.lt_of_lt_of_le (steps_within mem)
        (Nat.le_of_eq (Nat.add_right_comm g 1 m))⟩).trans
        (congrArg (1 + ·) (if_neg fun same => Nat.lt_irrefl g (Nat.lt_of_lt_of_le
          (Nat.lt_succ_self g) (Nat.le_trans (steps_mem mem) (Nat.le_of_eq same)))))).trans
      ((total_ones _).trans (steps_length _ _))
  (congrArg (· + _) front).trans ((congrArg (1 + s + ·) rest).trans
    ((Nat.add_right_comm 1 s m).trans ((congrArg (· + s) (Nat.add_comm 1 m)))))

/-- Where a member's standing does not change, the front neither takes from nor gives to
it. -/
theorem still_flows {t k f : Nat} (same : level n c a B (t + 1) k = level n c a B t k) :
    (flow n c a B).take t f k = 0 ∧ (flow n c a B).give t f k = 0 :=
  ⟨(congrArg (level n c a B t k - ·) same).trans (Nat.sub_self _),
   (congrArg (· - level n c a B t k) same).trans (Nat.sub_self _)⟩

theorem still {t k f : Nat}
    (flows : (flow n c a B).take t f k = 0 ∧ (flow n c a B).give t f k = 0) :
    ¬ (0 < (flow n c a B).take t f k ∨ 0 < (flow n c a B).give t f k)
  | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq flows.1))
  | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq flows.2))

/-- An empty queue stays empty where nothing joins an empty queue. -/
theorem empty_stays (tally : Tally n c a) {t : Nat} (company : 0 < a t → 0 < n t)
    (empty : n t = 0) : n (t + 1) = 0 :=
  match tally t with
  | ⟨k, before, after⟩ =>
    have kept : k = 0 := Nat.eq_zero_of_le_zero
      (Nat.le_trans (Nat.le_add_right k (c t)) (Nat.le_of_eq (before.symm.trans empty)))
    have joined : a t = 0 := eq_zero_of_not_pos fun joins =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (company joins) (Nat.le_of_eq empty))
    after.trans ((congrArg (· + a t) kept).trans ((Nat.zero_add _).trans joined))

theorem outside_empty {k t : Nat} (empty : n t = 0) : ¬ Queue.holds n c k t :=
  fun holds => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (OpenQueue.occupied holds) (Nat.le_of_eq empty))

/-- Across a step from an empty queue nothing is taken or given. -/
theorem idle (tally : Tally n c a) {t : Nat} (company : 0 < a t → 0 < n t)
    (empty : n t = 0) (k f : Nat) :
    (flow n c a B).take t f k = 0 ∧ (flow n c a B).give t f k = 0 :=
  still_flows ((place_zero (outside_empty (empty_stays tally company empty))).trans
    (place_zero (outside_empty empty)).symm)

/-- Across a step at which nothing ceases or arises nothing changes. -/
theorem quiet_same (tally : Tally n c a) {t : Nat} (quiet : c t + a t = 0) (k : Nat) :
    level n c a B (t + 1) k = level n c a B t k :=
  have ceased : c t = 0 :=
    Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq quiet))
  have joined : a t = 0 :=
    Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq quiet))
  have front : Queue.gone c (t + 1) = Queue.gone c t :=
    (Queue.gone_succ t).trans (congrArg (_ + ·) ceased)
  have size : n (t + 1) = n t := match tally t with
    | ⟨_, before, after⟩ => after.trans ((congrArg (_ + ·) joined).trans
        ((congrArg (_ + ·) ceased).symm.trans before.symm))
  have kept : store c a B (t + 1) = store c a B t :=
    congrArg (B - ·) ((occurrences_succ _ (Nat.zero_le t)).trans (congrArg (_ + ·)
      (mark_zero fun changes => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le changes (Nat.le_of_eq quiet)))))
  (congrArg (fun g => place g (n (t + 1)) (store c a B (t + 1) - n (t + 1)) k) front).trans
    ((congrArg (fun m => place (Queue.gone c t) m (store c a B (t + 1) - m) k) size).trans
      (congrArg (fun s => place (Queue.gone c t) (n t) (s - n t) k) kept))

/-- What is in the queue before or after a step lies in its span. -/
theorem within_span (tally : Tally n c a) {t k : Nat}
    (holds : Queue.holds n c k t ∨ Queue.holds n c k (t + 1)) : k ∈ span n c a t :=
  match tally t, holds with
  | _, .inl now => steps_of_within now.1
      (Nat.lt_of_lt_of_le now.2 (Nat.add_le_add_left (Nat.le_add_right _ _) _))
  | ⟨_, before, after⟩, .inr next => steps_of_within
      (Nat.le_trans (Nat.le_trans (Nat.le_add_right _ (c t))
        (Nat.le_of_eq (Queue.gone_succ t).symm)) next.1)
      (Nat.lt_of_lt_of_le next.2 (Nat.le_of_eq ((congrArg (_ + ·) after).trans
        ((Nat.add_assoc _ _ _).symm.trans ((congrArg (· + a t) (Queue.kept_end before).symm).trans
          (Nat.add_assoc _ _ _))))))

/-- Whatever the front takes from or gives to lies in the span. -/
theorem moving_within (tally : Tally n c a) {t k f : Nat}
    (moves : 0 < (flow n c a B).take t f k ∨ 0 < (flow n c a B).give t f k) :
    k ∈ span n c a t :=
  if now : Queue.holds n c k t then within_span tally (.inl now)
  else if next : Queue.holds n c k (t + 1) then within_span tally (.inr next)
  else absurd moves (still (still_flows ((place_zero next).trans (place_zero now).symm)))

/-- Each step is enclosed by its span. -/
theorem closed (tally : Tally n c a) (t : Nat) : (flow n c a B).ClosedAt (span n c a t) t :=
  fun _ _ _ out => ⟨eq_zero_of_not_pos fun takes => out (moving_within tally (.inl takes)),
    eq_zero_of_not_pos fun gives => out (moving_within tally (.inr gives))⟩

theorem span_distinct (t : Nat) : Distinct (span n c a t) :=
  steps_distinct _ _

/-- Something taken or given means the queue is not empty. -/
theorem busy (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) {t k f : Nat}
    (moves : 0 < (flow n c a B).take t f k ∨ 0 < (flow n c a B).give t f k) : 0 < n t :=
  match Nat.eq_zero_or_pos (n t) with
  | .inl empty => absurd moves (still (idle tally (company t) empty k f))
  | .inr occupied => occupied

end EnclosedQueue

namespace World

/-- An enclosed queue: its front exchanges only within the queue, and what stands falls
by one at each step at which a member joins or leaves. -/
def enclosedQueue (n c a : Nat → Nat) (B : Nat) : World :=
  World.of Nat (EnclosedQueue.flow n c a B) (EnclosedQueue.web n c a B)

instance enclosedQueue_decided (n c a : Nat → Nat) (B : Nat) :
    ∀ t x, Decidable ((enclosedQueue n c a B).web.active t x) :=
  fun t k => inferInstanceAs (Decidable (Queue.holds n c k t))

/-- The census of an enclosed queue is the queue. -/
theorem enclosedQueue_census (n c a : Nat → Nat) (B : Nat) :
    (enclosedQueue n c a B).web.Census (Queue.line n c) :=
  Queue.listed

theorem enclosedQueue_embodied (n c a : Nat → Nat) (B : Nat) :
    (enclosedQueue n c a B).Embodied :=
  fun _ _ => EnclosedQueue.place_pos

theorem enclosedQueue_balanced (n c a : Nat → Nat) (B : Nat) :
    (enclosedQueue n c a B).Balanced :=
  fun t k => add_sub_turn (EnclosedQueue.level n c a B t k) (EnclosedQueue.level n c a B (t + 1) k)

variable {n c a : Nat → Nat} {B : Nat}

theorem enclosedQueue_acting (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) :
    (enclosedQueue n c a B).Acting :=
  fun _ f _ present gives => match f, present, gives with
    | _, .head _, gives => OpenQueue.front.mpr (EnclosedQueue.busy tally company (.inr gives))
    | _, .tail _ no, _ => (nomatch no)

/-- Only the front takes, and only from a member in the queue, so only while it is active,
whatever the counts. -/
theorem enclosedQueue_taking (n c a : Nat → Nat) (B : Nat) : (enclosedQueue n c a B).Taking :=
  fun _ f _ present takes => match f, present, takes with
    | _, .head _, takes => ⟨OpenQueue.front.mpr (OpenQueue.occupied (EnclosedQueue.place_pos.mpr
        (Nat.lt_of_lt_of_le takes (Nat.sub_le _ _)))), trivial⟩
    | _, .tail _ no, _ => (nomatch no)

/-- Where the queue fits its store, what stands is at most the store, and is the store
while the queue is not empty. -/
theorem enclosedQueue_stock {t : Nat} (fits : n t ≤ EnclosedQueue.store c a B t) :
    (enclosedQueue n c a B).web.stock (Queue.line n c t) t ≤ EnclosedQueue.store c a B t ∧
      (0 < n t → (enclosedQueue n c a B).web.stock (Queue.line n c t) t =
        EnclosedQueue.store c a B t) :=
  have whole : ∀ m, n t = m + 1 →
      (enclosedQueue n c a B).web.stock (Queue.line n c t) t = EnclosedQueue.store c a B t :=
    fun m size =>
      (congrArg (fun k => total (steps (Queue.gone c t) k)
        (EnclosedQueue.place (Queue.gone c t) k (EnclosedQueue.store c a B t - n t))) size).trans
        ((EnclosedQueue.total_place _ m _).trans ((congrArg (· + _) size.symm).trans
          (add_sub_of_le fits)))
  match Nat.eq_zero_or_pos (n t) with
  | .inl empty => ⟨Nat.le_trans (Nat.le_of_eq
      (congrArg (fun k => total (steps (Queue.gone c t) k)
        (EnclosedQueue.place (Queue.gone c t) k (EnclosedQueue.store c a B t - n t))) empty))
      (Nat.zero_le _), fun occupied => absurd (empty ▸ occupied) (Nat.lt_irrefl 0)⟩
  | .inr occupied => ⟨Nat.le_of_eq (whole _ (Nat.succ_pred_eq_of_pos occupied).symm),
      fun _ => whole _ (Nat.succ_pred_eq_of_pos occupied).symm⟩

/-- Across a step at which nothing joins an empty queue, with the queue within its store
before and after, the enclosed queue dissipates on every closed family: where something joins
or leaves, what stands falls by one, so the front takes more than it gives. -/
theorem enclosedQueue_dissipatesOn (tally : Tally n c a) {t : Nat}
    (company : 0 < a t → 0 < n t) (fits : n t ≤ EnclosedQueue.store c a B t)
    (fits' : n (t + 1) ≤ EnclosedQueue.store c a B (t + 1)) {cs : List Nat}
    (distinct : Distinct cs) (closed : (EnclosedQueue.flow n c a B).ClosedAt cs t) :
    (EnclosedQueue.flow n c a B).DissipatesOn cs t :=
  fun f present =>
    have still : (∀ k, (EnclosedQueue.flow n c a B).take t f k = 0 ∧
        (EnclosedQueue.flow n c a B).give t f k = 0) →
        total cs ((EnclosedQueue.flow n c a B).give t f) +
          sign (total cs ((EnclosedQueue.flow n c a B).take t f)) ≤
            total cs ((EnclosedQueue.flow n c a B).take t f) := fun flows =>
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (total_eq_zero fun k _ => (flows k).2)).trans
        ((Nat.zero_add _).trans (congrArg sign (total_eq_zero fun k _ => (flows k).1)))))
        (Nat.zero_le _)
    match Nat.eq_zero_or_pos (n t), Nat.eq_zero_or_pos (c t + a t) with
    | .inl empty, _ => still fun k => EnclosedQueue.idle tally company empty k f
    | .inr _, .inl quiet => still fun k =>
      EnclosedQueue.still_flows (EnclosedQueue.quiet_same tally quiet k)
    | .inr occupied, .inr changes =>
      have census := enclosedQueue_census n c a B
      have standing := standingCensus census (enclosedQueue_embodied n c a B)
      have before := standing.stock_eq (EnclosedQueue.span_distinct t) fun k mem =>
        EnclosedQueue.within_span tally (.inl (((census t).2 k).mpr mem))
      have after := standing.stock_eq (t := t + 1) (EnclosedQueue.span_distinct t) fun k mem =>
        EnclosedQueue.within_span tally (.inr (((census (t + 1)).2 k).mpr mem))
      have spent : EnclosedQueue.store c a B (t + 1) + 1 ≤ EnclosedQueue.store c a B t :=
        Nat.le_of_eq ((congrArg (fun u => B - u + 1) ((occurrences_succ _ (Nat.zero_le t)).trans
          (congrArg (_ + ·) (mark_one changes)))).trans (Nat.succ_pred_eq_of_pos
            (Nat.lt_of_lt_of_le occupied fits)))
      have lowered := Nat.le_trans (Nat.add_le_add_right (Nat.le_trans (Nat.le_of_eq after.symm)
          (enclosedQueue_stock fits').1) 1)
        (Nat.le_trans spent (Nat.le_of_eq (((enclosedQueue_stock fits).2
          occupied).symm.trans before)))
      have over := (enclosedQueue_balanced n c a B).over (EnclosedQueue.span n c a t) t
      have exceeds :
          total (EnclosedQueue.span n c a t) ((EnclosedQueue.flow n c a B).give t f) + 1 ≤
            total (EnclosedQueue.span n c a t) ((EnclosedQueue.flow n c a B).take t f) :=
        le_of_add_le_add_right _ (Nat.le_trans (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
          (congrArg (_ + ·) (Nat.add_comm _ _)))) (Nat.le_trans (Nat.add_le_add_left lowered _)
            (Nat.le_of_eq ((Nat.add_comm _ _).trans (over.symm.trans (Nat.add_comm _ _))))))
      Nat.le_trans (Nat.add_le_add (total_le_of_support distinct fun _ _ gives =>
          EnclosedQueue.moving_within tally (.inr gives)) (sign_le_one _))
        (Nat.le_trans exceeds (total_le_of_support (EnclosedQueue.span_distinct t) fun k _ takes =>
          match decideMem k cs with
          | .isTrue mem => mem
          | .isFalse out => absurd (Nat.lt_of_lt_of_le takes
              (Nat.le_of_eq (closed f present k out).1)) (Nat.lt_irrefl 0)))

/-- Under a change bound from the first step the enclosed queue dissipates. -/
theorem enclosedQueue_dissipative (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (bound : ChangeBound 0 B n c a) : (enclosedQueue n c a B).Dissipative :=
  fun _ t distinct closed => enclosedQueue_dissipatesOn tally (company t)
    (RelationalRenewal.le_sub_from_add (bound t (Nat.zero_le t)))
    (RelationalRenewal.le_sub_from_add (bound (t + 1) (Nat.zero_le _))) distinct closed

/-- Under a change bound from the first step, with nothing joining an empty queue, an
enclosed queue meets all eight premises. -/
theorem enclosedQueue_premised (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (bound : ChangeBound 0 B n c a) : (enclosedQueue n c a B).Premised :=
  .of (fun _ _ _ _ no => (nomatch no)) (enclosedQueue_balanced n c a B)
    (enclosedQueue_acting tally company) (enclosedQueue_taking n c a B)
    (enclosedQueue_dissipative tally company bound) (enclosedQueue_embodied n c a B)
    ⟨_, enclosedQueue_census n c a B⟩ ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩

/-- Every step of an enclosed queue is enclosed. -/
theorem enclosedQueue_enclosed (tally : Tally n c a) (t : Nat) :
    (enclosedQueue n c a B).flow.Enclosed t :=
  ⟨EnclosedQueue.span n c a t, EnclosedQueue.span_distinct t, EnclosedQueue.closed tally t⟩

/-- **The binding steps under the eight premises, enclosed from some step on, for every counted
census**: nothing arises across a step at which nothing is active, and the total standing where
enclosure begins bounds change from the first step (`active_of_coming_jointly`,
`enclosure_bounds_change_counted`). -/
theorem enclosed_counting_sound (w : World) (premised : w.Premised)
    (enclosed : ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) :
    w.CountsHold fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ B, ChangeBound 0 B n c a :=
  match enclosed with
  | ⟨_, enclosed⟩ => fun _ _ _ _ census counted =>
    ⟨fun _ => counted.company fun _ _ comes => active_of_coming_jointly
        (premised _ (.tail _ (.head _))) (premised _ (.tail _ (.tail _ (.head _))))
        (Embodied.arising (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _
          (.head _))))))))
        census comes,
     ⟨_, (enclosure_bounds_change_counted census counted
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
        (premised _ (.tail _ (.head _)))
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))) enclosed).from_zero⟩⟩

/-- **The witness under the eight premises, enclosed**: every tally with nothing arising across a
step at which nothing is active and a change bound from the first step is what the census of an
enclosed queue counts. -/
theorem enclosed_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x)
      (fun w => w.Premised ∧ ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t)
      fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ B, ChangeBound 0 B n c a :=
  fun n c a tally ⟨company, B, bound⟩ => ⟨enclosedQueue n c a B,
    fun x t => enclosedQueue_decided n c a B t x, Queue.line n c,
    ⟨enclosedQueue_premised tally company bound, 0, fun t _ => enclosedQueue_enclosed tally t⟩,
    enclosedQueue_census n c a B, Queue.counts tally⟩

/-- Under all eight premises, with every step from some step on enclosed, the laws of
counting are the tally, that nothing arises across a step at which nothing is active, and a
change bound from the first step: a property of the counts holds of every census of every such
world exactly when it holds of every tally of this kind. -/
theorem enclosed_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised →
        (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CensusMarksHold Q :=
  census_table_marks_hold₂ pointwise enclosed_counting_sound enclosed_counting_witnessed

end World

/-! ## Counting in finite worlds -/

/-- The numbers of a list that are below `K`, as places among `K`. -/
def placesBelow (K : Nat) : List Nat → List (Fin K)
  | [] => []
  | k :: l => if h : k < K then ⟨k, h⟩ :: placesBelow K l else placesBelow K l

theorem mem_placesBelow {K : Nat} {i : Fin K} :
    ∀ {l : List Nat}, i ∈ placesBelow K l ↔ i.val ∈ l
  | [] => ⟨fun no => (nomatch no), fun no => (nomatch no)⟩
  | k :: l =>
    if h : k < K then
      have unfold : placesBelow K (k :: l) = ⟨k, h⟩ :: placesBelow K l := dif_pos h
      ⟨fun mem => match mem_cons_cases (Eq.mp (congrArg (i ∈ ·) unfold) mem) with
        | .inl same => Eq.subst (motive := fun v => v ∈ k :: l) (congrArg Fin.val same).symm
            (.head l)
        | .inr mem => .tail k (mem_placesBelow.mp mem),
       fun mem => Eq.mpr (congrArg (i ∈ ·) unfold) (match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun j => j ∈ (⟨k, h⟩ : Fin K) :: placesBelow K l)
            (Fin.eq_of_val_eq (i := ⟨k, h⟩) (j := i) same.symm) (.head _)
        | .inr mem => .tail _ (mem_placesBelow.mpr mem))⟩
    else
      have unfold : placesBelow K (k :: l) = placesBelow K l := dif_neg h
      ⟨fun mem => .tail k (mem_placesBelow.mp (Eq.mp (congrArg (i ∈ ·) unfold) mem)),
       fun mem => Eq.mpr (congrArg (i ∈ ·) unfold) (match mem_cons_cases mem with
        | .inl same => absurd (Eq.subst (motive := fun v => v < K) same i.isLt) h
        | .inr mem => mem_placesBelow.mpr mem)⟩

theorem placesBelow_distinct {K : Nat} :
    ∀ {l : List Nat}, Distinct l → Distinct (placesBelow K l)
  | [], _ => trivial
  | k :: _, ⟨fresh, distinct⟩ =>
    if h : k < K then
      Eq.mpr (congrArg Distinct (dif_pos h))
        ⟨fun mem => fresh (mem_placesBelow.mp mem), placesBelow_distinct distinct⟩
    else Eq.mpr (congrArg Distinct (dif_neg h)) (placesBelow_distinct distinct)

/-- Over a list of numbers below `K`, a quantity on places totals what it totals on the
numbers. -/
theorem total_placesBelow {K : Nat} {q : Fin K → Nat} {g : Nat → Nat}
    (same : ∀ i, q i = g i.val) :
    ∀ {l : List Nat}, (∀ k, k ∈ l → k < K) → total (placesBelow K l) q = total l g
  | [], _ => rfl
  | k :: l, within =>
    (congrArg (fun m => total m q) (dif_pos (within k (.head l)))).trans
      ((congrArg (· + total (placesBelow K l) q) (same ⟨k, within k (.head l)⟩)).trans
        (congrArg (g k + ·) (total_placesBelow same fun j mem => within j (.tail k mem))))

/-- The `K` places, each listed once. -/
theorem places_listed (K : Nat) : ∃ all : List (Fin K), Distinct all ∧ ∀ i, i ∈ all :=
  ⟨placesBelow _ (steps 0 K), placesBelow_distinct (steps_distinct _ _),
   fun i => mem_placesBelow.mpr (steps_of_within (Nat.zero_le _)
     (Nat.lt_of_lt_of_le i.isLt (Nat.le_of_eq (Nat.zero_add _).symm)))⟩

namespace FiniteQueue

variable (n c a : Nat → Nat) (B : Nat)

/-- Room for every member a queue counting a tally whose change `B` bounds ever holds
(`ChangeBound.reach`). -/
def size : Nat := B + B * B + 1

/-- The front of the queue where it lies within the room, the first place otherwise. -/
def front (t : Nat) : Fin (size B) :=
  if h : Queue.gone c t < size B then ⟨_, h⟩ else ⟨0, Nat.succ_pos _⟩

/-- The enclosed queue's web, on the places of the room. -/
def web : Web (Fin (size B)) (Fin (size B)) where
  level t i := EnclosedQueue.level n c a B t i.val
  active t i := Queue.holds n c i.val t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The enclosed queue's flow, on the places of the room. -/
def flow : Flow (Fin (size B)) (Fin (size B)) where
  present t := [front c B t]
  take t _ i := (EnclosedQueue.flow n c a B).take t (Queue.gone c t) i.val
  give t _ i := (EnclosedQueue.flow n c a B).give t (Queue.gone c t) i.val

/-- The members in the queue at each step, as places. -/
def alive (t : Nat) : List (Fin (size B)) :=
  placesBelow (size B) (Queue.line n c t)

variable {n c a : Nat → Nat} {B : Nat}

/-- Every member the queue holds has a place. -/
theorem placed (tally : Tally n c a) (bound : ChangeBound 0 B n c a) {k t : Nat}
    (holds : Queue.holds n c k t) : k < size B :=
  Nat.lt_of_lt_of_le holds.2 (Nat.le_succ_of_le (ChangeBound.reach tally bound t))

theorem front_val (tally : Tally n c a) (bound : ChangeBound 0 B n c a) (t : Nat) :
    (front c B t).val = Queue.gone c t :=
  congrArg Fin.val (dif_pos (Nat.lt_of_le_of_lt (Nat.le_add_right _ (n t))
    (Nat.lt_succ_of_le (ChangeBound.reach tally bound t))))

end FiniteQueue

namespace World

/-- An enclosed queue on the finitely many places its members ever take. -/
def finiteQueue (n c a : Nat → Nat) (B : Nat) : World :=
  World.of (Fin (FiniteQueue.size B)) (FiniteQueue.flow n c a B) (FiniteQueue.web n c a B)

instance finiteQueue_decided (n c a : Nat → Nat) (B : Nat) :
    ∀ t x, Decidable ((finiteQueue n c a B).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Queue.holds n c i.val t))

theorem finiteQueue_finite (n c a : Nat → Nat) (B : Nat) : (finiteQueue n c a B).Finite :=
  places_listed _

theorem finiteQueue_census (n c a : Nat → Nat) (B : Nat) :
    (finiteQueue n c a B).web.Census (FiniteQueue.alive n c B) :=
  fun _ => ⟨placesBelow_distinct (steps_distinct _ _), fun _ =>
    ⟨fun holds => mem_placesBelow.mpr (steps_of_within holds.1 holds.2),
     fun mem => ⟨steps_mem (mem_placesBelow.mp mem), steps_within (mem_placesBelow.mp mem)⟩⟩⟩

variable {n c a : Nat → Nat} {B : Nat}

/-- Under a change bound from the first step, its census counts what the queue counts. -/
theorem finiteQueue_counts (tally : Tally n c a) (bound : ChangeBound 0 B n c a) (t : Nat) :
    (FiniteQueue.alive n c B t).length = n t ∧
      ceasings (FiniteQueue.alive n c B t)
        (fun x s => (finiteQueue n c a B).web.active s x) t = c t ∧
      comings (FiniteQueue.alive n c B (t + 1))
        (fun x s => (finiteQueue n c a B).web.active s x) t = a t :=
  have within : ∀ s k, k ∈ Queue.line n c s → k < FiniteQueue.size B := fun _ _ mem =>
    FiniteQueue.placed tally bound ⟨steps_mem mem, steps_within mem⟩
  ⟨(total_ones _).symm.trans ((total_placesBelow (g := fun _ => 1) (fun _ => rfl)
      (within t)).trans ((total_ones _).trans (steps_length _ _))),
   (total_placesBelow (fun _ => rfl) (within t)).trans (Queue.ceasings_eq tally t),
   (total_placesBelow (fun _ => rfl) (within (t + 1))).trans (Queue.comings_eq tally t)⟩

/-- Under a change bound from the first step, with nothing joining an empty queue, the
finite queue meets all eight premises: it dissipates as the enclosed queue does. -/
theorem finiteQueue_premised (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (bound : ChangeBound 0 B n c a) : (finiteQueue n c a B).Premised :=
  have active : ∀ {t : Nat}, 0 < n t →
      (finiteQueue n c a B).web.active t (FiniteQueue.front c B t) :=
    fun occupied => Eq.subst (motive := fun v => Queue.holds n c v _)
      (FiniteQueue.front_val tally bound _).symm (OpenQueue.front.mpr occupied)
  .of (fun _ _ _ _ no => (nomatch no))
    (fun t i => enclosedQueue_balanced n c a B t i.val)
    (fun _ f _ present gives => match f, present, gives with
      | _, .head _, gives => active (EnclosedQueue.busy (f := 0) tally company (.inr gives))
      | _, .tail _ no, _ => (nomatch no))
    (fun _ f _ present takes => match f, present, takes with
      | _, .head _, takes => ⟨active (EnclosedQueue.busy (f := 0) tally company (.inl takes)),
          trivial⟩
      | _, .tail _ no, _ => (nomatch no))
    (fun cs t distinct closed f present =>
      have dissipates := enclosedQueue_dissipative tally company bound
        (cs.map Fin.val) t (distinct_map (fun _ _ same => Fin.eq_of_val_eq same) distinct)
        (fun _ _ (k : Nat) out =>
          if h : k < FiniteQueue.size B then
            closed f present ⟨k, h⟩ fun mem => out (mem_map_of (g := Fin.val) mem)
          else EnclosedQueue.still_flows
            ((EnclosedQueue.place_zero fun holds => h (FiniteQueue.placed tally bound holds)).trans
              (EnclosedQueue.place_zero fun holds =>
                h (FiniteQueue.placed tally bound holds)).symm))
        (Queue.gone c t) (.head _)
      have gives : total (cs.map Fin.val) ((EnclosedQueue.flow n c a B).give t (Queue.gone c t)) =
          total cs ((FiniteQueue.flow n c a B).give t f) := total_map _ _ cs
      have takes : total (cs.map Fin.val) ((EnclosedQueue.flow n c a B).take t (Queue.gone c t)) =
          total cs ((FiniteQueue.flow n c a B).take t f) := total_map _ _ cs
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) gives.symm).trans
          (congrArg (fun k => _ + sign k) takes.symm)))
        (Nat.le_trans dissipates (Nat.le_of_eq takes)))
    (fun _ _ => EnclosedQueue.place_pos)
    ⟨_, finiteQueue_census _ _ _ _⟩
    ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩

/-- **The binding steps in finite worlds**: every step of a finite world is enclosed
(`enclosed_counting_sound`). -/
theorem finite_counting_sound (w : World) (premised : w.Premised) (finite : w.Finite) :
    w.CountsHold fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ B, ChangeBound 0 B n c a :=
  enclosed_counting_sound w premised ⟨0, fun t _ => finite.enclosed t⟩

/-- **The witness in finite worlds**: the enclosed queue on the finitely many places its members
ever take. -/
theorem finite_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Premised ∧ w.Finite)
      fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ B, ChangeBound 0 B n c a :=
  fun n c a tally ⟨company, B, bound⟩ => ⟨finiteQueue n c a B,
    fun x t => finiteQueue_decided n c a B t x, _,
    ⟨finiteQueue_premised tally company bound, finiteQueue_finite n c a B⟩,
    finiteQueue_census n c a B, finiteQueue_counts tally bound⟩

/-- Under all eight premises, in a finite world, the laws of counting are those under
enclosure from some step on: the tally, that nothing arises across a step at which nothing
is active, and a change bound from the first step. -/
theorem finite_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.Finite →
        w.CensusMarksHold Q :=
  census_table_marks_hold₂ pointwise finite_counting_sound finite_counting_witnessed

/-- So under the eight premises, worlds enclosed from some step on and finite worlds have
the same laws of counting (the thirteenth review's probe). -/
theorem enclosed_iff_finite_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised →
      (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CensusMarksHold Q) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.Finite →
        w.CensusMarksHold Q :=
  (enclosed_counting pointwise).symm.trans (finite_counting pointwise)

/-- One member replaced across the first step, in a finite queue. -/
abbrev replaced : World :=
  finiteQueue (fun _ => 1) (Swap.change fun _ => true) (Swap.change fun _ => true) 2

/-- In the finite queue dissipation binds: where one member is replaced across the first
step, the front takes two units from the family of all places. -/
theorem finite_dissipation_binds :
    ∃ cs t f, Distinct cs ∧ replaced.flow.ClosedAt cs t ∧ f ∈ replaced.flow.present t ∧
      0 < total cs (replaced.flow.take t f) :=
  have takes : replaced.flow.take 0 (FiniteQueue.front (Swap.change fun _ => true) 2 0)
      ⟨0, Nat.succ_pos _⟩ = 2 := rfl
  match finiteQueue_finite (fun _ => 1) (Swap.change fun _ => true)
      (Swap.change fun _ => true) 2 with
  | ⟨all, distinct, every⟩ =>
    ⟨all, 0, FiniteQueue.front (Swap.change fun _ => true) 2 0, distinct,
     fun _ _ x out => absurd (every x) out, .head _,
     Nat.lt_of_lt_of_le Nat.zero_lt_two (Nat.le_trans (Nat.le_of_eq takes.symm)
       (le_total_of_mem (every ⟨0, Nat.succ_pos _⟩)))⟩

/-- And the bound of `enclosure_bounds_change` is attained there: what stands at the first step
totals two, and from the next step on one member is active with one step of change behind
it. -/
theorem replaced_attains :
    replaced.web.stock (FiniteQueue.alive (fun _ => 1) (Swap.change fun _ => true) 2 0) 0 = 2 ∧
      ∀ t, (FiniteQueue.alive (fun _ => 1) (Swap.change fun _ => true) 2 (t + 1)).length +
        occurrences 0 (fun u => Swap.change (fun _ => true) u + Swap.change (fun _ => true) u)
          (t + 1) = 2 :=
  ⟨rfl, fun t => (congrArg (· + _) (finiteQueue_counts (Swap.tally fun _ => true)
      (Swap.change_bound fun _ => true) (t + 1)).1).trans (congrArg (1 + ·)
        ((congrArg (_ + ·) (mark_zero fun c => Bool.noConfusion (ListTests.and_right c))).symm.trans
          (Swap.counted (fun _ => true) (t + 1))))⟩

/-- That arising does not recur in a finite world meeting the eight premises
(`premised_rests_unrefuted`) cannot be strengthened to a step after which nothing arises without
omniscience: if every such world whose activity is decided had one, `LPO` would hold, even
where one member is active throughout and replaced at most once (`Swap`; the thirteenth
review's probe). -/
theorem lpo_of_finite_ends
    (ends : ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.Finite →
      ∃ E, ∀ t x, E ≤ t → ¬ w.web.Arises t x) : LPO := fun s =>
  match ends (finiteQueue (fun _ => 1) (Swap.change s) (Swap.change s) 2)
      (finiteQueue_premised (Swap.tally s) (fun _ _ => Nat.zero_lt_one) (Swap.change_bound s))
      (finiteQueue_finite _ _ _ _) with
  | ⟨E, quiet⟩ => Swap.decide_of_end s (E := E) fun m ge c yes =>
    match total_pos _ (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq
        ((Swap.at_first s c yes).symm.trans
          (finiteQueue_counts (Swap.tally s) (Swap.change_bound s) m).2.2.symm))) with
    | ⟨x, _, arises⟩ => quiet m x ge (mark_pos.mp arises)

end World

/-! ## Counting under each selection, with enclosure -/

/-- The enclosed queue's flow opened before step `T`: there every relatum also exchanges one
unit each way with the front, so no family is closed across a step before `T`. -/
def EnclosedQueue.closing (n c a : Nat → Nat) (B T : Nat) : Flow Nat Nat where
  present t := [Queue.gone c t]
  take t f k := (EnclosedQueue.flow n c a B).take t f k + mark (t < T)
  give t f k := (EnclosedQueue.flow n c a B).give t f k + mark (t < T)

namespace World

/-- An enclosed queue closing at step `T`: before `T` every relatum also exchanges one unit
each way with the front. -/
def closingQueue (n c a : Nat → Nat) (B T : Nat) : World :=
  World.of Nat (EnclosedQueue.closing n c a B T) (EnclosedQueue.web n c a B)

instance closingQueue_decided (n c a : Nat → Nat) (B T : Nat) :
    ∀ t x, Decidable ((closingQueue n c a B T).web.active t x) :=
  enclosedQueue_decided n c a B

variable {n c a : Nat → Nat} {B T : Nat}

theorem closingQueue_balanced (n c a : Nat → Nat) (B T : Nat) :
    (closingQueue n c a B T).Balanced :=
  fun t k =>
    show EnclosedQueue.level n c a B (t + 1) k + (EnclosedQueue.level n c a B t k -
        EnclosedQueue.level n c a B (t + 1) k + mark (t < T)) =
      EnclosedQueue.level n c a B t k + (EnclosedQueue.level n c a B (t + 1) k -
        EnclosedQueue.level n c a B t k + mark (t < T)) from
    (Nat.add_assoc _ _ _).symm.trans ((congrArg (· + mark (t < T))
      (add_sub_turn (EnclosedQueue.level n c a B t k)
        (EnclosedQueue.level n c a B (t + 1) k))).trans (Nat.add_assoc _ _ _))

/-- From step `T` on, the closing queue's flow is the enclosed queue's. -/
theorem closing_flows {t : Nat} (later : T ≤ t) (f k : Nat) :
    (EnclosedQueue.closing n c a B T).take t f k = (EnclosedQueue.flow n c a B).take t f k ∧
      (EnclosedQueue.closing n c a B T).give t f k = (EnclosedQueue.flow n c a B).give t f k :=
  have opened : mark (t < T) = 0 := mark_zero (Nat.not_lt_of_le later)
  ⟨congrArg (_ + ·) opened, congrArg (_ + ·) opened⟩

/-- Every step from `T` on is enclosed by its span. -/
theorem closingQueue_enclosed (tally : Tally n c a) {t : Nat} (later : T ≤ t) :
    (closingQueue n c a B T).flow.Enclosed t :=
  ⟨EnclosedQueue.span n c a t, EnclosedQueue.span_distinct t, fun f present k out =>
    match EnclosedQueue.closed (B := B) tally t f present k out with
    | ⟨takes, gives⟩ => ⟨(closing_flows later f k).1.trans takes,
        (closing_flows later f k).2.trans gives⟩⟩

/-- With a change bound from step `T`, nothing joining an empty queue from `T` on, the
closing queue dissipates: before `T` no family is closed, and from `T` on it dissipates as
the enclosed queue does, its store larger by `T`. -/
theorem closingQueue_dissipative (tally : Tally n c a) {K : Nat} (bound : ChangeBound T K n c a)
    (company : ∀ t, T ≤ t → 0 < a t → 0 < n t) : (closingQueue n c a (K + T) T).Dissipative :=
  fun cs t distinct closed f present => match Nat.lt_or_ge t T with
  | .inl early => absurd (closed f present (beyond cs) (beyond_not_mem cs)).2
      fun nothing => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (mark_pos.mpr early) (Nat.le_add_left _ _)) (Nat.le_of_eq nothing))
  | .inr later =>
    have fits : ∀ s, T ≤ s → n s ≤ EnclosedQueue.store c a (K + T) s := fun s later =>
      RelationalRenewal.le_sub_from_add (Nat.le_trans (Nat.add_le_add_left
        (occurrences_zero_le _ s) _) (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _).symm)
          (Nat.add_le_add_right (bound s later) T)))
    have takes : total cs ((EnclosedQueue.closing n c a (K + T) T).take t f) =
        total cs ((EnclosedQueue.flow n c a (K + T)).take t f) :=
      total_congr (fun k => (closing_flows later f k).1) cs
    have gives : total cs ((EnclosedQueue.closing n c a (K + T) T).give t f) =
        total cs ((EnclosedQueue.flow n c a (K + T)).give t f) :=
      total_congr (fun k => (closing_flows later f k).2) cs
    Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) gives).trans
        (congrArg (fun u => _ + sign u) takes)))
      (Nat.le_trans (enclosedQueue_dissipatesOn tally (company t later) (fits t later)
          (fits (t + 1) (Nat.le_succ_of_le later)) distinct
          (fun g present k out => match closed g present k out with
            | ⟨took, gave⟩ => ⟨(closing_flows later g k).1.symm.trans took,
                (closing_flows later g k).2.symm.trans gave⟩) f present)
        (Nat.le_of_eq takes.symm))

/-- A selection bounds change under enclosure when it selects balance, embodiment and
dissipation. -/
def BoundsChange (S : Premise → Bool) : Prop :=
  S .balanced = true ∧ S .embodied = true ∧ S .dissipative = true

/-- Where nothing takes part, every step is enclosed. -/
theorem still_enclosed (w : World) (still : ∀ t, w.flow.present t = []) (t : Nat) :
    w.flow.Enclosed t :=
  ⟨[], trivial, fun _ present => nomatch (still t) ▸ present⟩

/-- **The binding steps under each selection, enclosed from some step on, for every counted
census**: those of `counting_under_sound`, and where balance, embodiment and dissipation are
selected, from where enclosure begins a change bound and nothing arising across a step at which
nothing is active (`enclosure_bounds_change_counted`, `active_of_coming_enclosed`). -/
theorem enclosed_counting_under_sound (S : Premise → Bool) (w : World) (meets : w.Meets S)
    (enclosed : ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) :
    w.CountsHold fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) :=
  match enclosed with
  | ⟨T, enclosed⟩ => fun alive n c a census counted =>
    ⟨counting_under_sound S w meets alive n c a census counted,
     fun ⟨balanced, embodied, dissipative⟩ => ⟨T, _, enclosure_bounds_change_counted census
      counted (meets _ embodied) (meets _ balanced) (meets _ dissipative) enclosed,
      fun t later => counted.company fun _ _ comes => active_of_coming_enclosed
        (meets _ balanced) (meets _ dissipative) (meets _ embodied) census (enclosed t later)
        comes⟩⟩

/-- **The witnesses under each selection, enclosed from some step on**: the queues of
`counting_under_witnessed` with nothing flowing where balance or embodiment is not selected; an
enclosed queue with no bound where dissipation is not, or with the bound from the first step
where only active relata giving or taking is; and where neither is, a queue closing at the step
from which change is bounded. -/
theorem enclosed_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => w.web.active t x)
      (fun w => w.Meets S ∧ ∃ T, ∀ t, T ≤ t → w.flow.Enclosed t)
      fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) :=
  fun n c a tally ⟨quiet, bounded⟩ =>
    match hb : S .balanced, he : S .embodied with
    | false, _ => ⟨embodiedQueue n c, fun _ _ => inferInstance, Queue.line n c,
        ⟨embodiedQueue_meets n c hb, 0, fun t _ => still_enclosed _ (fun _ => rfl) t⟩,
        Queue.listed, Queue.counts tally⟩
    | true, false => ⟨queue n c, fun _ _ => inferInstance, Queue.line n c,
        ⟨queue_meets n c he, 0, fun t _ => still_enclosed _ (fun _ => rfl) t⟩,
        Queue.listed, Queue.counts tally⟩
    | true, true => match hd : S .dissipative, ha : S .acting, ht : S .taking with
      | false, _, _ => ⟨enclosedQueue n c a 0, fun _ _ => inferInstance, Queue.line n c,
          ⟨fun
            | .dependent, _ => fun _ _ _ _ no => (nomatch no)
            | .balanced, _ => enclosedQueue_balanced n c a 0
            | .acting, selected => enclosedQueue_acting tally (quiet ⟨hb, he, .inl selected⟩)
            | .taking, _ => enclosedQueue_taking n c a 0
            | .dissipative, selected => nomatch hd.symm.trans selected
            | .embodied, _ => enclosedQueue_embodied n c a 0
            | .counted, _ => ⟨_, enclosedQueue_census n c a 0⟩
            | .transmitting, _ => ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩,
           0, fun t _ => enclosedQueue_enclosed tally t⟩,
          enclosedQueue_census n c a 0, Queue.counts tally⟩
      | true, true, _ => match bounded ⟨hb, he, hd⟩ with
        | ⟨_, _, bound, _⟩ => ⟨enclosedQueue n c a _, fun _ _ => inferInstance, Queue.line n c,
            ⟨(enclosedQueue_premised tally (quiet ⟨hb, he, .inl ha⟩) bound.from_zero).meets S,
             0, fun t _ => enclosedQueue_enclosed tally t⟩,
            enclosedQueue_census n c a _, Queue.counts tally⟩
      | true, false, true => match bounded ⟨hb, he, hd⟩ with
        | ⟨_, _, bound, _⟩ => ⟨enclosedQueue n c a _, fun _ _ => inferInstance, Queue.line n c,
            ⟨(enclosedQueue_premised tally (quiet ⟨hb, he, .inr ⟨ht, hd⟩⟩)
              bound.from_zero).meets S, 0, fun t _ => enclosedQueue_enclosed tally t⟩,
            enclosedQueue_census n c a _, Queue.counts tally⟩
      | true, false, false => match bounded ⟨hb, he, hd⟩ with
        | ⟨T, K, bound, company⟩ => ⟨closingQueue n c a (K + T) T, fun _ _ => inferInstance,
            Queue.line n c,
            ⟨fun
              | .dependent, _ => fun _ _ _ _ no => (nomatch no)
              | .balanced, _ => closingQueue_balanced n c a (K + T) T
              | .acting, selected => nomatch ha.symm.trans selected
              | .taking, selected => nomatch ht.symm.trans selected
              | .dissipative, _ => closingQueue_dissipative tally bound company
              | .embodied, _ => enclosedQueue_embodied n c a (K + T)
              | .counted, _ => ⟨_, enclosedQueue_census n c a (K + T)⟩
              | .transmitting, _ => ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩,
             T, fun _ later => closingQueue_enclosed tally later⟩,
            enclosedQueue_census n c a (K + T), Queue.counts tally⟩

/-- The laws of counting under each selection of the premises, in worlds enclosed from some
step on. A property of the counts holds of every census of every such world meeting the
selection exactly when it holds of every tally that meets two conditions: where the selection
binds counting, nothing arises across a step at which nothing is active; where it bounds
change, from some step `T` on change stays within a bound and nothing arises across a step at
which nothing is active. The second condition carries its step: that change does not recur
within the bound (`ChangeBound.not_recurring`) gives no such step by itself. -/
theorem enclosed_counting_under (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) →
        Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
        (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CensusMarksHold Q :=
  census_table_marks_hold₂ pointwise (enclosed_counting_under_sound S) (enclosed_counting_under_witnessed S)

/-- So in worlds enclosed from some step on, a change bound from some step is a law of
counting under a selection exactly when the selection bounds change: a count growing by one
at each step is counted by an enclosed world meeting any other selection, and stays within
no bound (the fourteenth review's probe). -/
theorem enclosed_change_bound_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
        w.CensusMarksHold fun n c a => ∃ T B, ChangeBound T B n c a) ↔ BoundsChange S :=
  have pointwise : Pointwise fun n (_ _ : Nat → Nat) => ∃ T B, ∀ t, T ≤ t → n t ≤ B :=
    fun same ⟨T, B, bounded⟩ => ⟨T, B, fun t later =>
      Nat.le_trans (Nat.le_of_eq (same t).1.symm) (bounded t later)⟩
  have growing : Tally (fun t => t + 1) (fun _ => 0) (fun _ => 1) := fun t => ⟨t + 1, rfl, rfl⟩
  ⟨fun law => if bounds : S .balanced = true ∧ S .embodied = true ∧ S .dissipative = true
      then bounds else
      match (enclosed_counting_under S pointwise).mpr
          (fun w _ meets enclosed alive census => match law w meets enclosed alive census with
            | ⟨T, B, bound⟩ => ⟨T, B, fun t later =>
                Nat.le_trans (Nat.le_add_right _ _) (bound t later)⟩)
          _ _ _ growing (fun _ t _ => Nat.zero_lt_succ t) (fun bound => absurd bound bounds) with
      | ⟨T, B, bounded⟩ => (Nat.not_succ_le_self B (Nat.le_trans
          (Nat.succ_le_succ (Nat.le_add_right B T)) (bounded (B + T) (Nat.le_add_left T B)))).elim,
   fun ⟨balanced, embodied, dissipative⟩ _ _ meets ⟨T, enclosed⟩ _ census =>
     ⟨T, _, enclosure_bounds_change census (meets _ embodied) (meets _ balanced)
       (meets _ dissipative) enclosed⟩⟩

end World

/-! ## Counting under each selection, in finite worlds -/

namespace Ring

/-- Members seated round a ring of `N` places in turn, the first at place `0`: the place of
the `k`th. -/
def slot (N : Nat) : Nat → Nat
  | 0 => 0
  | k + 1 => if slot N k + 1 < N then slot N k + 1 else 0

variable {N : Nat}

/-- The next member sits at the next place, or at the first once the ring is full. -/
theorem slot_step (N k : Nat) :
    (slot N (k + 1) = slot N k + 1 ∧ slot N k + 1 < N) ∨
      (slot N (k + 1) = 0 ∧ ¬ slot N k + 1 < N) :=
  if h : slot N k + 1 < N then .inl ⟨if_pos h, h⟩ else .inr ⟨if_neg h, h⟩

theorem slot_lt (pos : 0 < N) : ∀ k, slot N k < N
  | 0 => pos
  | k + 1 => match slot_step N k with
    | .inl ⟨same, below⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq same) below
    | .inr ⟨same, _⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq same) pos

/-- Fewer than `N` members on, the place is as many places on, or as many less a full
turn. -/
theorem slot_add (k : Nat) : ∀ {d : Nat}, d < N →
    slot N (k + d) = slot N k + d ∨ slot N (k + d) + N = slot N k + d
  | 0, _ => .inl rfl
  | d + 1, short =>
    have pos : 0 < N := Nat.lt_of_le_of_lt (Nat.zero_le _) short
    match slot_step N (k + d), slot_add k (Nat.lt_of_succ_lt short) with
    | .inl ⟨same, _⟩, .inl on => .inl (same.trans (congrArg (· + 1) on))
    | .inl ⟨same, _⟩, .inr round => .inr ((congrArg (· + N) same).trans
        ((Nat.add_right_comm _ 1 N).trans (congrArg (· + 1) round)))
    | .inr ⟨same, full⟩, on =>
      have turned : slot N (k + d) + 1 = N :=
        Nat.le_antisymm (slot_lt pos (k + d)) ((Nat.lt_or_ge _ _).resolve_left full)
      match on with
      | .inl on => .inr ((congrArg (· + N) same).trans ((Nat.zero_add N).trans
          (turned.symm.trans (congrArg (· + 1) on))))
      | .inr round => absurd (Nat.add_lt_add (slot_lt pos k) short)
          (Nat.not_lt_of_le (Nat.le_of_eq ((congrArg (· + N) turned).symm.trans
            ((Nat.add_right_comm _ 1 N).trans (congrArg (· + 1) round)))))

/-- Members fewer than a full turn apart sit at different places. -/
theorem slot_ne (k : Nat) {d : Nat} (pos : 0 < d) (short : d < N) :
    slot N (k + d) ≠ slot N k :=
  fun same => match slot_add k short with
  | .inl on => Nat.lt_irrefl (slot N k) (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_of_eq (on.symm.trans same)))
  | .inr round => Nat.lt_irrefl (slot N k + d) (Nat.lt_of_lt_of_le
      (Nat.add_lt_add_left short _) (Nat.le_of_eq ((congrArg (· + N) same).symm.trans round)))

/-- A member later than another, both within `L ≤ N` members from `g`, sits apart from
it. -/
theorem slot_apart {g L j k : Nat} (fits : L ≤ N) (start : g ≤ j) (before : j < k)
    (within : k < g + L) : slot N k ≠ slot N j :=
  match le_dest (Nat.le_of_lt before) with
  | ⟨_, split⟩ =>
    have ahead : j + _ < j + L := Eq.subst (motive := (· < j + L)) split
      (Nat.lt_of_lt_of_le within (Nat.add_le_add_right start L))
    fun same => slot_ne j (Nat.lt_of_add_lt_add_left (n := j)
        (Eq.subst (motive := (j + 0 < ·)) split before))
      (Nat.lt_of_lt_of_le (Nat.lt_of_add_lt_add_left ahead) fits)
      (Eq.subst (motive := fun x => slot N x = slot N j) split same)

/-- Among at most `N` members in turn, members at one place are one. -/
theorem slot_inj {g L j k : Nat} (fits : L ≤ N) (first : g ≤ j ∧ j < g + L)
    (second : g ≤ k ∧ k < g + L) (same : slot N j = slot N k) : j = k :=
  match Nat.lt_or_ge j k with
  | .inl before => absurd same.symm (slot_apart fits first.1 before second.2)
  | .inr after => match Nat.lt_or_ge k j with
    | .inl before => absurd same (slot_apart fits second.1 before first.2)
    | .inr after' => Nat.le_antisymm after' after

/-- Room for the members in a queue before or after any step, where at most `M` are in it
at each. -/
def size (M : Nat) : Nat := M + M + 1

/-- The `k`th member's place on the ring. -/
def seat (M k : Nat) : Fin (size M) :=
  ⟨slot (size M) k, slot_lt (Nat.succ_pos _) k⟩

variable (n c : Nat → Nat) (M : Nat)

/-- The places held at step `t`: the queue's members, each at its place. -/
def seated (t : Nat) : List (Fin (size M)) :=
  (Queue.line n c t).map (seat M)

/-- Place `i` is held at step `t`. -/
def holds (i : Fin (size M)) (t : Nat) : Prop :=
  i ∈ seated n c M t

instance (i : Fin (size M)) (t : Nat) : Decidable (holds n c M i t) :=
  decideMem i _

/-- The queue seated round the ring, each place standing at `level` and active while
held. -/
def web (level : Nat → Fin (size M) → Nat) : Web (Fin (size M)) (Fin (size M)) where
  level := level
  active t i := holds n c M i t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- Each place stands exactly while it is held. -/
def stands (t : Nat) (i : Fin (size M)) : Nat :=
  mark (holds n c M i t)

/-- The front's place takes part at every step. It takes from each place what that place's
standing loses across the step and gives each what it gains. -/
def flow : Flow (Fin (size M)) (Fin (size M)) where
  present t := [seat M (Queue.gone c t)]
  take t _ i := stands n c M t i - stands n c M (t + 1) i
  give t _ i := stands n c M (t + 1) i - stands n c M t i

variable {n c M} {a : Nat → Nat}

/-- A place held means the queue is not empty. -/
theorem occupied {i : Fin (size M)} {t : Nat} (held : holds n c M i t) : 0 < n t :=
  match preimage_of_mem_map held with
  | ⟨_, listed, _⟩ => OpenQueue.occupied ⟨steps_mem listed, steps_within listed⟩

/-- The front's place is held while the queue is not empty. -/
theorem front_holds {t : Nat} (pos : 0 < n t) : holds n c M (seat M (Queue.gone c t)) t :=
  mem_map_of (steps_of_within (OpenQueue.front.mpr pos).1 (OpenQueue.front.mpr pos).2)

/-- Where at most `M` are in the queue at each step, those in it before or after a step fit
on the ring. -/
theorem span_fits (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (t : Nat) :
    n t + a t ≤ size M :=
  match tally t with
  | ⟨_, _, after⟩ => Nat.le_succ_of_le (Nat.add_le_add (bounded t) (Nat.le_trans
      (Nat.le_add_left _ _) (Nat.le_trans (Nat.le_of_eq after.symm) (bounded (t + 1)))))

/-- A member in the span of the step from `t` holds its place at a step whose queue lies in
the span exactly when it is in the queue then. -/
theorem holds_iff (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) {t k s : Nat}
    (spanned : k ∈ EnclosedQueue.span n c a t)
    (inside : ∀ j, Queue.holds n c j s → j ∈ EnclosedQueue.span n c a t) :
    holds n c M (seat M k) s ↔ Queue.holds n c k s :=
  ⟨fun held => match preimage_of_mem_map held with
    | ⟨j, listed, same⟩ =>
      have member : Queue.holds n c j s := ⟨steps_mem listed, steps_within listed⟩
      have there := inside j member
      Eq.subst (motive := fun x => Queue.holds n c x s)
        (slot_inj (span_fits tally bounded t) ⟨steps_mem there, steps_within there⟩
          ⟨steps_mem spanned, steps_within spanned⟩ (congrArg Fin.val same)) member,
   fun holds => mem_map_of (steps_of_within holds.1 holds.2)⟩

/-- The ring lists the places held at each step, each once. -/
theorem census (bounded : ∀ t, n t ≤ M) (level : Nat → Fin (size M) → Nat) :
    (web n c M level).Census (seated n c M) :=
  fun t => ⟨distinct_map_on (fun _ _ first second same =>
      slot_inj (Nat.le_succ_of_le (Nat.le_trans (bounded t) (Nat.le_add_right M M)))
        ⟨steps_mem first, steps_within first⟩ ⟨steps_mem second, steps_within second⟩
        (congrArg Fin.val same)) (steps_distinct _ _), fun _ => Iff.rfl⟩

/-- Where at most `M` are in the queue at each step, the ring counts what the queue
counts. -/
theorem counts (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (t : Nat) :
    (seated n c M t).length = n t ∧ ceasings (seated n c M t) (holds n c M) t = c t ∧
      comings (seated n c M (t + 1)) (holds n c M) t = a t :=
  have now : ∀ j, Queue.holds n c j t → j ∈ EnclosedQueue.span n c a t :=
    fun _ holds => EnclosedQueue.within_span tally (.inl holds)
  have next : ∀ j, Queue.holds n c j (t + 1) → j ∈ EnclosedQueue.span n c a t :=
    fun _ holds => EnclosedQueue.within_span tally (.inr holds)
  ⟨(total_ones _).symm.trans ((total_map _ _ _).trans ((total_ones _).trans (steps_length _ _))),
   (total_map _ _ _).trans ((total_congr_on fun k listed =>
      have spanned := now k ⟨steps_mem listed, steps_within listed⟩
      mark_iff (ceasesToBe_congr (holds_iff tally bounded spanned now)
        (holds_iff tally bounded spanned next))).trans (Queue.ceasings_eq tally t)),
   (total_map _ _ _).trans ((total_congr_on fun k listed =>
      have spanned := next k ⟨steps_mem listed, steps_within listed⟩
      mark_iff (comesToBe_congr (holds_iff tally bounded spanned now)
        (holds_iff tally bounded spanned next))).trans (Queue.comings_eq tally t))⟩

/-- What the front takes from a place, the place held before the step. -/
theorem taken_held {t : Nat} {f i : Fin (size M)} (takes : 0 < (flow n c M).take t f i) :
    holds n c M i t :=
  mark_pos.mp (Nat.lt_of_lt_of_le takes (Nat.sub_le _ _))

/-- What the front gives to a place, the place held after the step. -/
theorem given_held {t : Nat} {f i : Fin (size M)} (gives : 0 < (flow n c M).give t f i) :
    holds n c M i (t + 1) :=
  mark_pos.mp (Nat.lt_of_lt_of_le gives (Nat.sub_le _ _))

end Ring

/-- From the step after it arises, the lone relatum is all there is and nothing changes. -/
theorem Queue.lone_settles : ChangeBound 1 1 Queue.lone (fun _ => 0) Queue.joins :=
  have still : ∀ t, occurrences 1 (fun s => 0 + Queue.joins s) t = 0 := fun t =>
    Nat.rec (motive := fun t => occurrences 1 (fun s => 0 + Queue.joins s) t = 0) rfl
      (fun t same => (congrArg (· + _) same).trans ((Nat.zero_add _).trans
        (mark_zero (p := 1 ≤ t ∧ 0 < 0 + Queue.joins t) fun ⟨later, pos⟩ =>
          match t, later, pos with
          | 0, later, _ => Nat.not_succ_le_zero 0 later
          | _ + 1, _, pos => Nat.lt_irrefl 0 pos))) t
  fun t later => match t, later with
  | 0, later => absurd later (Nat.not_succ_le_zero 0)
  | t + 1, _ => Nat.le_of_eq (congrArg (1 + ·) (still (t + 1)))

namespace World

/-- A queue seated round a ring of places, with nothing standing or flowing. -/
def ring (n c : Nat → Nat) (M : Nat) : World :=
  World.of (Fin (Ring.size M)) Flow.still (Ring.web n c M fun _ _ => 0)

/-- The same ring, each place standing exactly while it is held, with nothing flowing. -/
def embodiedRing (n c : Nat → Nat) (M : Nat) : World :=
  World.of (Fin (Ring.size M)) Flow.still (Ring.web n c M (Ring.stands n c M))

/-- The same ring, its front's place taking what each place's standing loses and giving what
it gains. -/
def balancedRing (n c : Nat → Nat) (M : Nat) : World :=
  World.of (Fin (Ring.size M)) (Ring.flow n c M) (Ring.web n c M (Ring.stands n c M))

instance ring_decided (n c : Nat → Nat) (M : Nat) :
    ∀ t x, Decidable ((ring n c M).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c M i t))

instance embodiedRing_decided (n c : Nat → Nat) (M : Nat) :
    ∀ t x, Decidable ((embodiedRing n c M).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c M i t))

instance balancedRing_decided (n c : Nat → Nat) (M : Nat) :
    ∀ t x, Decidable ((balancedRing n c M).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c M i t))

variable {n c a : Nat → Nat} {M : Nat}

/-- Where at most `M` are in the queue at each step, the ring meets every premise but
embodiment. -/
theorem ring_premised (bounded : ∀ t, n t ≤ M) :
    (ring n c M).Dependent ∧ (ring n c M).Balanced ∧ (ring n c M).Acting ∧
      (ring n c M).Taking ∧ (ring n c M).Dissipative ∧ (ring n c M).Counted ∧
      (ring n c M).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no), fun _ _ => rfl, (still_vacuous _).1, (still_vacuous _).2.1,
   (still_vacuous _).2.2.1, ⟨_, Ring.census bounded _⟩, (still_vacuous _).2.2.2⟩

/-- And the embodied ring every premise but balance. -/
theorem embodiedRing_premised (bounded : ∀ t, n t ≤ M) :
    (embodiedRing n c M).Dependent ∧ (embodiedRing n c M).Acting ∧
      (embodiedRing n c M).Taking ∧ (embodiedRing n c M).Dissipative ∧
      (embodiedRing n c M).Embodied ∧ (embodiedRing n c M).Counted ∧
      (embodiedRing n c M).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no), (still_vacuous _).1, (still_vacuous _).2.1,
   (still_vacuous _).2.2.1, fun _ _ => mark_pos.symm, ⟨_, Ring.census bounded _⟩,
   (still_vacuous _).2.2.2⟩

/-- The balanced ring meets every premise but dissipation and only active relata giving. -/
theorem balancedRing_holds (bounded : ∀ t, n t ≤ M) :
    (balancedRing n c M).Dependent ∧ (balancedRing n c M).Balanced ∧
      (balancedRing n c M).Taking ∧ (balancedRing n c M).Embodied ∧
      (balancedRing n c M).Counted ∧ (balancedRing n c M).Transmitting :=
  ⟨fun _ _ _ _ no => (nomatch no),
   fun t i => add_sub_turn (Ring.stands n c M t i) (Ring.stands n c M (t + 1) i),
   fun _ f _ present takes => match f, present, takes with
    | _, .head _, takes => ⟨Ring.front_holds (Ring.occupied
        (Ring.taken_held takes)), trivial⟩
    | _, .tail _ no, _ => (nomatch no),
   fun _ _ => mark_pos.symm, ⟨_, Ring.census bounded _⟩,
   ⟨0, fun _ _ _ _ _ no => (nomatch no)⟩⟩

/-- Where nothing joins an empty queue, only active relata give in the balanced ring. -/
theorem balancedRing_acting (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) :
    (balancedRing n c M).Acting :=
  fun t f _ present gives => match f, present, gives with
    | _, .head _, gives => Ring.front_holds (match Nat.eq_zero_or_pos (n t) with
      | .inl empty => absurd (Ring.occupied (Ring.given_held gives)) fun pos =>
          Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
            (EnclosedQueue.empty_stays tally (company t) empty)))
      | .inr pos => pos)
    | _, .tail _ no, _ => (nomatch no)

/-- A ring meets every selection without embodiment. -/
theorem ring_meets (bounded : ∀ t, n t ≤ M) {S : Premise → Bool} (free : S .embodied = false) :
    (ring n c M).Meets S :=
  match ring_premised bounded with
  | ⟨dependent, balanced, acting, taking, dissipative, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, _ => dissipative
    | .embodied, selected => nomatch free.symm.trans selected
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- An embodied ring meets every selection without balance. -/
theorem embodiedRing_meets (bounded : ∀ t, n t ≤ M) {S : Premise → Bool}
    (free : S .balanced = false) : (embodiedRing n c M).Meets S :=
  match embodiedRing_premised bounded with
  | ⟨dependent, acting, taking, dissipative, embodied, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, selected => nomatch free.symm.trans selected
    | .acting, _ => acting
    | .taking, _ => taking
    | .dissipative, _ => dissipative
    | .embodied, _ => embodied
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- A balanced ring meets every selection without dissipation, where it selects only active
relata giving only if nothing joins an empty queue. -/
theorem balancedRing_meets (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) {S : Premise → Bool}
    (giving : S .acting = true → ∀ t, 0 < a t → 0 < n t) (free : S .dissipative = false) :
    (balancedRing n c M).Meets S :=
  match balancedRing_holds (c := c) bounded with
  | ⟨dependent, balanced, taking, embodied, counted, transmitting⟩ => fun
    | .dependent, _ => dependent
    | .balanced, _ => balanced
    | .acting, selected => balancedRing_acting tally (giving selected)
    | .taking, _ => taking
    | .dissipative, selected => nomatch free.symm.trans selected
    | .embodied, _ => embodied
    | .counted, _ => counted
    | .transmitting, _ => transmitting

/-- **The binding steps under each selection in finite worlds, for every counted census**: at
most some number active at each step; nothing arising across a step at which nothing is active
where the selection binds counting or bounds change, every step being enclosed; and a change
bound from the first step where it bounds change (`active_of_coming_jointly`,
`active_of_coming_enclosed`, `enclosure_bounds_change_counted`). -/
theorem finite_counting_under_sound (S : Premise → Bool) (w : World) (meets : w.Meets S)
    (finite : w.Finite) :
    w.CountsHold fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ B, ChangeBound 0 B n c a) :=
  fun alive _ _ _ census counted =>
    ⟨match finite.census_bounded with
      | ⟨M, bounded⟩ => ⟨M, fun t => Nat.le_trans (Nat.le_of_eq (counted t).1)
          (bounded alive census t)⟩,
     fun selected _ => counted.company fun _ _ comes => match selected with
      | .inl ⟨balanced, embodied, .inl acting⟩ => active_of_coming_jointly (meets _ balanced)
          (meets _ acting) (Embodied.arising (meets _ embodied)) census comes
      | .inl ⟨balanced, embodied, .inr ⟨_, dissipative⟩⟩ | .inr ⟨balanced, embodied, dissipative⟩ =>
          active_of_coming_enclosed (meets _ balanced) (meets _ dissipative) (meets _ embodied)
            census (finite.enclosed _) comes,
     fun ⟨balanced, embodied, dissipative⟩ => ⟨_, enclosure_bounds_change_counted census counted
      (meets _ embodied) (meets _ balanced) (meets _ dissipative) fun t _ => finite.enclosed t⟩⟩

/-- **The witnesses under each selection in finite worlds**: a ring seating the queue where
balance, embodiment or dissipation is not selected (standing while held, with nothing standing,
or balanced by the front's place), and the finite queue where the three are. -/
theorem finite_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ w.Finite)
      fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ B, ChangeBound 0 B n c a) :=
  fun n c _ tally ⟨⟨M, bounded⟩, quiet, bounds⟩ =>
    match hb : S .balanced, he : S .embodied with
    | false, _ => ⟨embodiedRing n c M, fun _ _ => inferInstance, _,
        ⟨embodiedRing_meets bounded hb, places_listed _⟩, Ring.census bounded _,
        Ring.counts tally bounded⟩
    | true, false => ⟨ring n c M, fun _ _ => inferInstance, _,
        ⟨ring_meets bounded he, places_listed _⟩, Ring.census bounded _,
        Ring.counts tally bounded⟩
    | true, true => match hd : S .dissipative with
      | false => ⟨balancedRing n c M, fun _ _ => inferInstance, _,
          ⟨balancedRing_meets tally bounded (fun ha => quiet (.inl ⟨hb, he, .inl ha⟩)) hd,
           places_listed _⟩, Ring.census bounded _, Ring.counts tally bounded⟩
      | true => match bounds ⟨hb, he, hd⟩ with
        | ⟨_, bound⟩ => ⟨finiteQueue _ _ _ _, fun _ _ => inferInstance, _,
            ⟨(finiteQueue_premised tally (quiet (.inr ⟨hb, he, hd⟩)) bound).meets S,
             finiteQueue_finite _ _ _ _⟩, finiteQueue_census _ _ _ _,
            finiteQueue_counts tally bound⟩

/-- The laws of counting under each selection of the premises, in finite worlds. A property
of the counts holds of every census of every finite world meeting the selection exactly when
it holds of every tally that meets three conditions: at most some number are active at each
step; where the selection binds counting or bounds change, nothing arises across a step at
which nothing is active; where it bounds change, change stays within a bound from the first
step. Every step of a finite world is enclosed (`Finite.enclosed`), so dissipation with
balance and embodiment binds counting there by itself (`enclosed_binds_counting`). -/
theorem finite_counting_under (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) →
      (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ B, ChangeBound 0 B n c a) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
        w.CensusMarksHold Q :=
  census_table_marks_hold₃ pointwise (finite_counting_under_sound S) (finite_counting_under_witnessed S)

/-- So in finite worlds, nothing arising across a step at which nothing is active is a law of
counting under a selection exactly when the selection selects balance and embodiment, and
only active relata giving or dissipation. -/
theorem finite_counting_binds_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t) ↔ BindsCounting S ∨ BoundsChange S :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∀ t, 0 < a t → 0 < n t :=
    fun same law t pos => Nat.lt_of_lt_of_le (law t (Nat.lt_of_lt_of_le pos
      (Nat.le_of_eq (same t).2.2.symm))) (Nat.le_of_eq (same t).1)
  have unbound : ¬ (BindsCounting S ∨ BoundsChange S) → ¬ ∀ (w : World)
      [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
        w.CensusMarksHold fun n _ a => ∀ t, 0 < a t → 0 < n t := fun free law =>
    Nat.lt_irrefl 0 ((finite_counting_under S pointwise).mpr law _ _ _ Queue.lone_tally
      ⟨1, fun | 0 => Nat.zero_le 1 | _ + 1 => Nat.le_refl 1⟩
      (fun binds => absurd binds free) (fun bounds => absurd (.inr bounds) free)
      0 Nat.zero_lt_one)
  ⟨fun law => match hb : S .balanced, he : S .embodied, ha : S .acting,
      hd : S .dissipative with
    | true, true, true, _ => .inl ⟨hb, he, .inl ha⟩
    | true, true, false, true => .inr ⟨hb, he, hd⟩
    | false, _, _, _ => absurd law (unbound fun
        | .inl binds => nomatch hb.symm.trans binds.1
        | .inr bounds => nomatch hb.symm.trans bounds.1)
    | true, false, _, _ => absurd law (unbound fun
        | .inl binds => nomatch he.symm.trans binds.2.1
        | .inr bounds => nomatch he.symm.trans bounds.2.1)
    | true, true, false, false => absurd law (unbound fun
        | .inl ⟨_, _, .inl acting⟩ => nomatch ha.symm.trans acting
        | .inl ⟨_, _, .inr ⟨_, dissipative⟩⟩ => nomatch hd.symm.trans dissipative
        | .inr ⟨_, _, dissipative⟩ => nomatch hd.symm.trans dissipative),
   fun binds => (finite_counting_under S pointwise).mp fun _ _ _ _ _ quiet _ => quiet binds⟩

/-- And a change bound from the first step is a law of counting in finite worlds under a
selection exactly when the selection bounds change: one member replaced at every step is
counted by a finite world meeting any other selection. -/
theorem finite_change_bound_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      w.CensusMarksHold fun n c a => ∃ B, ChangeBound 0 B n c a) ↔ BoundsChange S :=
  have replaced : Tally (fun _ => 1) (fun _ => 1) (fun _ => 1) := fun _ => ⟨0, rfl, rfl⟩
  have bounded : ∀ t, (fun _ => 1 : Nat → Nat) t ≤ 1 := fun _ => Nat.le_refl 1
  have recurring : ¬ ∃ B, ChangeBound 0 B
      (fun t => (Ring.seated (fun _ => 1) (fun _ => 1) 1 t).length)
      (fun t => ceasings (Ring.seated (fun _ => 1) (fun _ => 1) 1 t)
        (Ring.holds (fun _ => 1) (fun _ => 1) 1) t)
      (fun t => comings (Ring.seated (fun _ => 1) (fun _ => 1) 1 (t + 1))
        (Ring.holds (fun _ => 1) (fun _ => 1) 1) t) :=
    fun ⟨_, bound⟩ => bound.not_recurring fun N => ⟨N, Nat.le_refl N,
      Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_trans
        (Nat.le_of_eq (Ring.counts replaced bounded N).2.1.symm) (Nat.le_add_right _ _))⟩
  ⟨fun law => match hb : S .balanced, he : S .embodied, hd : S .dissipative with
    | true, true, true => ⟨hb, he, hd⟩
    | false, _, _ => absurd (law (embodiedRing _ _ 1) (embodiedRing_meets bounded hb)
        (places_listed _) _ (Ring.census bounded _)) recurring
    | true, false, _ => absurd (law (ring _ _ 1) (ring_meets bounded he)
        (places_listed _) _ (Ring.census bounded _)) recurring
    | true, true, false => absurd (law (balancedRing _ _ 1)
        (balancedRing_meets replaced bounded (fun _ _ _ => Nat.zero_lt_one) hd)
        (places_listed _) _ (Ring.census bounded _)) recurring,
   fun ⟨balanced, embodied, dissipative⟩ _ _ meets finite _ census =>
    ⟨_, enclosure_bounds_change census (meets _ embodied) (meets _ balanced)
      (meets _ dissipative) fun t _ => finite.enclosed t⟩⟩

/-- **The tally conditions of worlds enclosed from some step on and of finite worlds agree under
a selection exactly when it bounds change and binds counting**, over any class of properties of
the counts that holds the pointwise ones: there a change bound from some step is one from the
first step (`ChangeBound.from_zero`) and bounds the count. Where the selection does not bound
change, a count growing without end meets the enclosed condition and not the finite one; where it
bounds change without binding counting, one relatum arising from none meets the enclosed
condition and not that nothing arises across a step at which nothing is active. -/
theorem enclosed_iff_finite_tally (S : Premise → Bool)
    {Props : ((Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) → Prop}
    (pointwise : ∀ Q, Pointwise Q → Props Q) :
    (∀ Q, Props Q →
      ((∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
          (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧
            ∀ t, T ≤ t → 0 < a t → 0 < n t) → Q n c a) ↔
        ∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) →
          (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) →
          (BoundsChange S → ∃ B, ChangeBound 0 B n c a) → Q n c a)) ↔
      BoundsChange S ∧ BindsCounting S :=
  ⟨fun law =>
    have growing : ¬ ¬ BoundsChange S := fun free =>
      match (law _ (pointwise (fun n (_ _ : Nat → Nat) => ∃ M, ∀ t, n t ≤ M)
          fun same ⟨M, bounded⟩ => ⟨M, fun t => Nat.le_trans (Nat.le_of_eq (same t).1.symm)
            (bounded t)⟩)).mpr (fun _ _ _ _ bounded _ _ => bounded)
          (fun t => t + 1) (fun _ => 0) (fun _ => 1) (fun t => ⟨t + 1, rfl, rfl⟩)
          (fun _ _ _ => Nat.succ_pos _) (fun bounds => absurd bounds free) with
      | ⟨M, bounded⟩ => Nat.lt_irrefl M (bounded M)
    have arising : BoundsChange S → ¬ ¬ BindsCounting S := fun bounds free =>
      Nat.lt_irrefl 0 ((law _ (pointwise (fun n (_ : Nat → Nat) a => ∀ t, 0 < a t → 0 < n t)
          fun same law t pos => Nat.lt_of_lt_of_le (law t (Nat.lt_of_lt_of_le pos
            (Nat.le_of_eq (same t).2.2.symm))) (Nat.le_of_eq (same t).1))).mpr
          (fun _ _ _ _ _ quiet _ => quiet (.inr bounds)) _ _ _ Queue.lone_tally
        (fun binds => absurd binds free)
        (fun _ => ⟨1, 1, Queue.lone_settles, fun t later pos => match t, later, pos with
          | 0, later, _ => absurd later (Nat.not_succ_le_zero 0)
          | _ + 1, _, pos => absurd pos (Nat.lt_irrefl 0)⟩)
        0 Nat.zero_lt_one)
    match hb : S .balanced, he : S .embodied, hd : S .dissipative, ha : S .acting,
      ht : S .taking with
    | true, true, true, true, _ => ⟨⟨hb, he, hd⟩, ⟨hb, he, .inl ha⟩⟩
    | true, true, true, false, true => ⟨⟨hb, he, hd⟩, ⟨hb, he, .inr ⟨ht, hd⟩⟩⟩
    | true, true, true, false, false => (arising ⟨hb, he, hd⟩ fun
        | ⟨_, _, .inl acting⟩ => nomatch ha.symm.trans acting
        | ⟨_, _, .inr ⟨taking, _⟩⟩ => nomatch ht.symm.trans taking).elim
    | false, _, _, _, _ => (growing fun bounds => nomatch hb.symm.trans bounds.1).elim
    | true, false, _, _, _ => (growing fun bounds => nomatch he.symm.trans bounds.2.1).elim
    | true, true, false, _, _ => (growing fun bounds => nomatch hd.symm.trans bounds.2.2).elim,
   fun ⟨bounds, binds⟩ _ _ =>
    ⟨fun law n c a tally _ quiet bounded => law n c a tally (fun _ => quiet (.inl binds))
        fun _ => match bounded bounds with
          | ⟨_, bound⟩ => ⟨0, _, bound, fun t _ => quiet (.inl binds) t⟩,
      fun law n c a tally quiet bounded => match bounded bounds with
        | ⟨_, _, bound, _⟩ => law n c a tally ⟨_, fun t => Nat.le_trans (Nat.le_add_right _ _)
            (bound.from_zero t (Nat.zero_le t))⟩ (fun _ => quiet binds)
            (fun _ => ⟨_, bound.from_zero⟩)⟩⟩

/-- Finite worlds and worlds enclosed from some step on have the same laws of counting under a
selection exactly when it bounds change and binds counting: there a change bound from some
step is one from the first step (`ChangeBound.from_zero`) and bounds the count. Where the
selection does not bound change, a count growing without end is counted in a world enclosed
at every step and in no finite world; where it bounds change without binding counting, one
relatum arising from none before enclosure is counted in an enclosed world and in no finite
world. -/
theorem enclosed_iff_finite_counting_under (S : Premise → Bool) :
    (∀ Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop, Pointwise Q →
      ((∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
          (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.CensusMarksHold Q) ↔
        ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
          w.CensusMarksHold Q)) ↔
      BoundsChange S ∧ BindsCounting S :=
  Iff.trans ⟨fun law Q pointwise => (enclosed_counting_under S pointwise).trans
      ((law Q pointwise).trans (finite_counting_under S pointwise).symm),
    fun law Q pointwise => (enclosed_counting_under S pointwise).symm.trans
      ((law Q pointwise).trans (finite_counting_under S pointwise))⟩
    (enclosed_iff_finite_tally S fun _ => id)

end World

/-! ## Counting where every premise binds -/

namespace EnclosedQueue

/-- A member stands at one, and at most `s` more. -/
theorem place_le (g m s k : Nat) : place g m s k ≤ 1 + s :=
  if h : g ≤ k ∧ k < g + m then
    Nat.le_trans (Nat.le_of_eq (if_pos h)) (Nat.add_le_add_left
      (if front : k = g then Nat.le_of_eq (if_pos front)
       else Nat.le_trans (Nat.le_of_eq (if_neg front)) (Nat.zero_le s)) 1)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

/-- A queue stands at most at its length, and `s` more. -/
theorem total_place_le (g m s : Nat) : total (steps g m) (place g m s) ≤ m + s :=
  match m with
  | 0 => Nat.zero_le _
  | _ + 1 => Nat.le_of_eq (total_place g _ s)

/-- A queue not empty stands at its length, and `s` more at its front. -/
theorem total_place_pos {g m : Nat} (s : Nat) (occupied : 0 < m) :
    total (steps g m) (place g m s) = m + s :=
  match m, occupied with
  | _ + 1, _ => total_place g _ s

end EnclosedQueue

namespace OnceClosedQueue

variable (n c : Nat → Nat) (T E : Nat)

/-- What the front stands at beyond one: `E` at step `T`, nothing at any other step. -/
def excess (t : Nat) : Nat :=
  if t = T then E else 0

/-- Members stand by their place in the queue, the front `E` more at step `T`. -/
def level (t k : Nat) : Nat :=
  EnclosedQueue.place (Queue.gone c t) (n t) (excess T E t) k

/-- Across every step but `T` at which the queue is not empty before or after, one unit is
exchanged each way. -/
def exchange (t : Nat) : Nat :=
  mark ((0 < n t ∨ 0 < n (t + 1)) ∧ ¬ t = T)

/-- Members are active exactly while in the queue. Every relatum depends on every relatum,
needing what it stands at. -/
def web : Web Nat Nat where
  level := level n c T E
  active t k := Queue.holds n c k t
  requires _ _ _ := True
  need t _ k := level n c T E t k
  draws _ _ _ := True

/-- The front takes part at every step. It takes from each member what that member's
standing loses across the step and gives each what it gains, and across every step but `T` at
which the queue is not empty before or after it exchanges one unit more each way with every
relatum. -/
def flow : Flow Nat Nat where
  present t := [Queue.gone c t]
  take t _ k := level n c T E t k - level n c T E (t + 1) k + exchange n T t
  give t _ k := level n c T E (t + 1) k - level n c T E t k + exchange n T t

variable {n c a : Nat → Nat} {T E : Nat}

theorem excess_le (t : Nat) : excess T E t ≤ E :=
  if same : t = T then Nat.le_of_eq (if_pos same)
  else Nat.le_trans (Nat.le_of_eq (if_neg same)) (Nat.zero_le E)

/-- No member stands at more than one and the excess. -/
theorem level_le (t k : Nat) : level n c T E t k ≤ 1 + E :=
  Nat.le_trans (EnclosedQueue.place_le _ _ _ k) (Nat.add_le_add_left (excess_le t) 1)

/-- Where a member's standing does not change and nothing is exchanged, the front neither
takes from nor gives to it. -/
theorem still_flows {t k f : Nat} (same : level n c T E (t + 1) k = level n c T E t k)
    (shut : exchange n T t = 0) :
    (flow n c T E).take t f k = 0 ∧ (flow n c T E).give t f k = 0 :=
  ⟨((congrArg (level n c T E t k - · + exchange n T t) same).trans
      (congrArg (level n c T E t k - level n c T E t k + ·) shut)).trans (Nat.sub_self _),
   ((congrArg (· - level n c T E t k + exchange n T t) same).trans
      (congrArg (level n c T E t k - level n c T E t k + ·) shut)).trans (Nat.sub_self _)⟩

theorem still {t k f : Nat}
    (flows : (flow n c T E).take t f k = 0 ∧ (flow n c T E).give t f k = 0) :
    ¬ (0 < (flow n c T E).take t f k ∨ 0 < (flow n c T E).give t f k)
  | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq flows.1))
  | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq flows.2))

/-- Across a step at which the queue is empty before and after, nothing is taken or given. -/
theorem idle {t : Nat} (empty : n t = 0) (stays : n (t + 1) = 0) (k f : Nat) :
    (flow n c T E).take t f k = 0 ∧ (flow n c T E).give t f k = 0 :=
  still_flows ((EnclosedQueue.place_zero (EnclosedQueue.outside_empty stays)).trans
      (EnclosedQueue.place_zero (EnclosedQueue.outside_empty empty)).symm)
    (mark_zero fun ⟨occupied, _⟩ => match occupied with
      | .inl now => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le now (Nat.le_of_eq empty))
      | .inr next => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le next (Nat.le_of_eq stays)))

/-- Where nothing joins an empty queue, something taken or given means the queue is not
empty. -/
theorem busy (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) {t k f : Nat}
    (moves : 0 < (flow n c T E).take t f k ∨ 0 < (flow n c T E).give t f k) : 0 < n t :=
  match Nat.eq_zero_or_pos (n t) with
  | .inl empty => absurd moves (still (idle empty
      (EnclosedQueue.empty_stays tally (company t) empty) k f))
  | .inr occupied => occupied

/-- Across a step at which nothing is exchanged, whatever the front takes from or gives to
lies in the span. -/
theorem moving_within (tally : Tally n c a) {t k f : Nat} (shut : exchange n T t = 0)
    (moves : 0 < (flow n c T E).take t f k ∨ 0 < (flow n c T E).give t f k) :
    k ∈ EnclosedQueue.span n c a t :=
  if now : Queue.holds n c k t then EnclosedQueue.within_span tally (.inl now)
  else if next : Queue.holds n c k (t + 1) then EnclosedQueue.within_span tally (.inr next)
  else absurd moves (still (still_flows ((EnclosedQueue.place_zero next).trans
    (EnclosedQueue.place_zero now).symm) shut))

/-- Such a step is enclosed by its span. -/
theorem closed (tally : Tally n c a) {t : Nat} (shut : exchange n T t = 0) :
    (flow n c T E).ClosedAt (EnclosedQueue.span n c a t) t :=
  fun _ _ _ out => ⟨eq_zero_of_not_pos fun takes => out (moving_within tally shut (.inl takes)),
    eq_zero_of_not_pos fun gives => out (moving_within tally shut (.inr gives))⟩

/-- Activity needing support holds in its web whatever is active: each need is the level of
what is needed (the fourteenth review's probe). -/
theorem dependent_any_activity (active : Nat → Nat → Prop) :
    Web.Dependent ({ web n c T E with active } : Web Nat Nat) :=
  fun _ _ _ _ _ => Nat.le_refl _

/-- And every flow transmits each dependence within one and the excess, the levels being
bounded by it. So in this witness activity needing support and bounded transmission bind
only in that their conditions have instances: they exclude no activity and no exchange. -/
theorem transmits_any_flow (L : Flow Nat Nat) (k : Nat) :
    L.TransmitsWithin (web n c T E) k (1 + E) :=
  fun t _ _ _ _ => ⟨trivial, Nat.le_trans (level_le (t + 1) k) (Nat.le_add_left _ _)⟩

/-- Across every other step at which the queue is not empty before or after, no family is
closed. -/
theorem not_closed {t : Nat} (occupied : 0 < n t ∨ 0 < n (t + 1)) (other : ¬ t = T)
    (cs : List Nat) :
    ¬ (flow n c T E).ClosedAt cs t :=
  fun closed => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one
    (Nat.le_trans (Nat.le_of_eq (mark_one ⟨occupied, other⟩).symm) (Nat.le_add_left _ _)))
    (Nat.le_of_eq (closed _ (.head _) (beyond cs) (beyond_not_mem cs)).1))

end OnceClosedQueue

namespace World

/-- A queue closed once: open across every step but `T` at which it is not empty before or
after; across `T` its front, standing `E` more, exchanges only within the queue and loses that
excess. -/
def onceClosedQueue (n c : Nat → Nat) (T E : Nat) : World :=
  World.of Nat (OnceClosedQueue.flow n c T E) (OnceClosedQueue.web n c T E)

instance onceClosedQueue_decided (n c : Nat → Nat) (T E : Nat) :
    ∀ t x, Decidable ((onceClosedQueue n c T E).web.active t x) :=
  fun t k => inferInstanceAs (Decidable (Queue.holds n c k t))

/-- The census of a queue closed once is the queue. -/
theorem onceClosedQueue_census (n c : Nat → Nat) (T E : Nat) :
    (onceClosedQueue n c T E).web.Census (Queue.line n c) :=
  Queue.listed

theorem onceClosedQueue_embodied (n c : Nat → Nat) (T E : Nat) :
    (onceClosedQueue n c T E).Embodied :=
  fun _ _ => EnclosedQueue.place_pos

theorem onceClosedQueue_balanced (n c : Nat → Nat) (T E : Nat) :
    (onceClosedQueue n c T E).Balanced :=
  fun t k => add_sub_turn_add (OnceClosedQueue.level n c T E t k)
    (OnceClosedQueue.level n c T E (t + 1) k) (OnceClosedQueue.exchange n T t)

variable {n c a : Nat → Nat} {T E : Nat}

theorem onceClosedQueue_acting (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) :
    (onceClosedQueue n c T E).Acting :=
  fun _ f _ present gives => match f, present, gives with
    | _, .head _, gives => OpenQueue.front.mpr (OnceClosedQueue.busy tally company (.inr gives))
    | _, .tail _ no, _ => (nomatch no)

theorem onceClosedQueue_taking (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t) :
    (onceClosedQueue n c T E).Taking :=
  fun _ f _ present takes => match f, present, takes with
    | _, .head _, takes =>
      ⟨OpenQueue.front.mpr (OnceClosedQueue.busy tally company (.inl takes)), trivial⟩
    | _, .tail _ no, _ => (nomatch no)

/-- Across step `T`, with the queue not empty and its front standing more than join across
the step, the front takes from the span more than it gives: what stands falls. -/
theorem onceClosedQueue_exceeds (tally : Tally n c a) {t : Nat} (same : t = T)
    (occupied : 0 < n t) (excess : a t < E) (f : Nat) :
    total (EnclosedQueue.span n c a t) ((onceClosedQueue n c T E).flow.give t f) + 1 ≤
      total (EnclosedQueue.span n c a t) ((onceClosedQueue n c T E).flow.take t f) :=
  have census := onceClosedQueue_census n c T E
  have standing := standingCensus census (onceClosedQueue_embodied n c T E)
  have before := standing.stock_eq (EnclosedQueue.span_distinct t) fun k mem =>
    EnclosedQueue.within_span tally (.inl (((census t).2 k).mpr mem))
  have after := standing.stock_eq (t := t + 1) (EnclosedQueue.span_distinct t) fun k mem =>
    EnclosedQueue.within_span tally (.inr (((census (t + 1)).2 k).mpr mem))
  have full : (onceClosedQueue n c T E).web.stock (Queue.line n c t) t = n t + E :=
    (EnclosedQueue.total_place_pos _ occupied).trans (congrArg (n t + ·) (if_pos same))
  have spent : (onceClosedQueue n c T E).web.stock (Queue.line n c (t + 1)) (t + 1) ≤ n (t + 1) :=
    Nat.le_trans (EnclosedQueue.total_place_le _ _ _) (Nat.le_of_eq (congrArg (n (t + 1) + ·)
      (if_neg fun later => Nat.succ_ne_self t (later.trans same.symm))))
  have grows : n (t + 1) + 1 ≤ n t + E :=
    Nat.le_trans (Nat.add_le_add_right (Nat.le_trans (Nat.le_add_right _ (c t))
      (Nat.le_of_eq (tally.balance t))) 1)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _)) (Nat.add_le_add_left excess _))
  have lowered := Nat.le_trans (Nat.add_le_add_right (Nat.le_trans (Nat.le_of_eq after.symm)
      spent) 1) (Nat.le_trans grows (Nat.le_of_eq (full.symm.trans before)))
  have over := (onceClosedQueue_balanced n c T E).over (EnclosedQueue.span n c a t) t
  le_of_add_le_add_right _ (Nat.le_trans (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
    (congrArg (_ + ·) (Nat.add_comm _ _)))) (Nat.le_trans (Nat.add_le_add_left lowered _)
      (Nat.le_of_eq ((Nat.add_comm _ _).trans (over.symm.trans (Nat.add_comm _ _))))))

/-- Where the front stands more than join across `T`, and the queue is not empty at `T` if
something joins there, a queue closed once dissipates: no family is closed across a step at
which one unit is exchanged each way, nothing moves across a step at which the queue is empty
before and after, and across `T` what stands falls. Whether something joins an empty queue
elsewhere does not matter. -/
theorem onceClosedQueue_dissipative (tally : Tally n c a) (front : 0 < a T → 0 < n T)
    (excess : a T < E) : (onceClosedQueue n c T E).Dissipative :=
  fun cs t distinct closed f present =>
    if same : t = T then match Nat.eq_zero_or_pos (n t) with
      | .inl empty => gives_nothing (total_eq_zero fun k _ => (OnceClosedQueue.idle empty
          (EnclosedQueue.empty_stays tally (fun joins => Nat.lt_of_lt_of_le (front
            (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (congrArg a same))))
            (Nat.le_of_eq (congrArg n same).symm)) empty) k f).2)
      | .inr occupied =>
        have shut : OnceClosedQueue.exchange n T t = 0 := mark_zero fun ⟨_, other⟩ => other same
        Nat.le_trans (Nat.add_le_add (total_le_of_support distinct fun _ _ gives =>
            OnceClosedQueue.moving_within tally shut (.inr gives)) (sign_le_one _))
          (Nat.le_trans (onceClosedQueue_exceeds tally same occupied
              (Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg a same)) excess) f)
            (total_le_of_support (EnclosedQueue.span_distinct t) fun k _ takes =>
              match decideMem k cs with
              | .isTrue mem => mem
              | .isFalse out => absurd (Nat.lt_of_lt_of_le takes
                  (Nat.le_of_eq (closed f present k out).1)) (Nat.lt_irrefl 0)))
    else match Nat.eq_zero_or_pos (n t), Nat.eq_zero_or_pos (n (t + 1)) with
      | .inr occupied, _ => absurd closed (OnceClosedQueue.not_closed (.inl occupied) same cs)
      | _, .inr next => absurd closed (OnceClosedQueue.not_closed (.inr next) same cs)
      | .inl empty, .inl stays =>
        gives_nothing (total_eq_zero fun k _ => (OnceClosedQueue.idle empty stays k f).2)

/-- With nothing joining an empty queue and the front standing more than join across `T`, a
queue closed once meets all eight premises. -/
theorem onceClosedQueue_premised (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (excess : a T < E) : (onceClosedQueue n c T E).Premised :=
  .of (OnceClosedQueue.dependent_any_activity (n := n) (c := c) (T := T) (E := E) _)
    (onceClosedQueue_balanced n c T E)
    (onceClosedQueue_acting tally company) (onceClosedQueue_taking tally company)
    (onceClosedQueue_dissipative tally (company T) excess) (onceClosedQueue_embodied n c T E)
    ⟨_, onceClosedQueue_census n c T E⟩
    ⟨1 + E, OnceClosedQueue.transmits_any_flow (n := n) (c := c) (T := T) (E := E) _⟩

/-- Where the queue is not empty at `T`, its front standing more than join there, and
something joins across some step `J`, every premise binds: the front is active at `T` and
depends on its own standing; across `J` the front gives to a member joining, which comes to
stand depending on what it stands at; across `T` the front takes from the span more than it
gives, the span closed; and no finite list holds every relatum. Binding needs neither that
nothing joins an empty queue nor that `J` is `T`. -/
theorem onceClosedQueue_binds (tally : Tally n c a) (occupied : 0 < n T) (excess : a T < E)
    {J : Nat} (joins : 0 < a J) : (onceClosedQueue n c T E).Binds :=
  have front : Queue.holds n c (Queue.gone c T) T := OpenQueue.front.mpr occupied
  have shut : OnceClosedQueue.exchange n T T = 0 := mark_zero fun ⟨_, other⟩ => other rfl
  have takes := Nat.lt_of_lt_of_le (Nat.zero_lt_succ _)
    (onceClosedQueue_exceeds tally rfl occupied excess (Queue.gone c T))
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally J).symm)),
      total_pos _ takes with
  | ⟨x, _, comes⟩, ⟨k, _, taken⟩ =>
    have comes := mark_pos.mp comes
    have stands : 0 < OnceClosedQueue.level n c T E (J + 1) x := EnclosedQueue.place_pos.mp comes.2
    have gives : 0 < (onceClosedQueue n c T E).flow.give J (Queue.gone c J) x :=
      Nat.lt_of_lt_of_le stands (Nat.le_trans (Nat.le_of_eq (congrArg
        (OnceClosedQueue.level n c T E (J + 1) x - ·) (EnclosedQueue.place_zero comes.1).symm))
        (Nat.le_add_right _ _))
    fun
    | .dependent => ⟨T, _, _, front, trivial, EnclosedQueue.place_pos.mp front⟩
    | .balanced => ⟨J, x, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
        (Nat.le_of_eq (same.trans (EnclosedQueue.place_zero comes.1))))⟩
    | .acting => ⟨J, _, x, .head _, gives⟩
    | .taking => ⟨T, _, k, .head _, taken⟩
    | .dissipative => ⟨_, T, _, EnclosedQueue.span_distinct T, OnceClosedQueue.closed tally shut,
        .head _, takes⟩
    | .embodied => ⟨J, x, comes⟩
    | .counted => fun ⟨all, _, every⟩ => beyond_not_mem all (every _)
    | .transmitting => ⟨J, x, _, x, ⟨.head _, gives, fun standing =>
        comes.1 (EnclosedQueue.place_pos.mpr standing), stands⟩, trivial⟩

/-- **Something arising is counted.** Where something arises across a step, a counted census
counts something arising there. -/
theorem CountsOf.arising_pos {w : World} {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (counted : w.CountsOf alive n c a) (census : w.web.Census alive) {t : Nat} {x : w.Relatum}
    (arises : w.web.Arises t x) : 0 < a t :=
  (counted t).2.2.pos_of_mem (((census (t + 1)).2 x).mp arises.2) arises

/-- Where embodiment binds, every counted census counts something arising. -/
theorem binds_arising_counted {w : World} (binds : Premise.embodied.Binds w) :
    w.CountsHold fun _ _ a => ∃ t, 0 < a t :=
  fun _ _ _ _ census counted => match binds with
  | ⟨_, _, arises⟩ => ⟨_, counted.arising_pos census arises⟩

/-- **The binding steps where every premise binds, for every counted census**: nothing arises
across a step at which nothing is active, and something arises (`active_of_coming_jointly`,
`binds_arising_counted`). -/
theorem binding_counting_sound (w : World) (premised : w.Premised) (binds : w.Binds) :
    w.CountsHold fun n _ a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ t, 0 < a t :=
  fun alive n c a census counted =>
    ⟨premised_counting_sound w premised alive n c a census counted,
     binds_arising_counted (binds .embodied) alive n c a census counted⟩

/-- **The witness where every premise binds**: a queue closed once, its front standing more than
join at the step it closes. -/
theorem binding_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Premised ∧ w.Binds)
      fun n _ a => (∀ t, 0 < a t → 0 < n t) ∧ ∃ t, 0 < a t :=
  fun n c a tally ⟨company, T, joins⟩ => ⟨onceClosedQueue n c T (a T + 1),
    fun _ _ => inferInstance, Queue.line n c,
    ⟨onceClosedQueue_premised tally company (Nat.lt_succ_self _),
     onceClosedQueue_binds tally (company T joins) (Nat.lt_succ_self _) joins⟩,
    onceClosedQueue_census _ _ _ _, Queue.counts tally⟩

/-- Where every premise binds, the laws of counting under the eight are the tally, that
nothing arises across a step at which nothing is active, and that something arises: a
property of the counts holds of every census of every world meeting the eight and binding
each exactly when it holds of every tally of this kind. Binding adds one law, which binding
embodiment gives by itself (`binds_arising`, `binds_adds`). Binding is `Binds`: each
condition has an instance. -/
theorem binding_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ t, 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.Binds →
        w.CensusMarksHold Q :=
  census_table_marks_hold₂ pointwise binding_counting_sound binding_counting_witnessed

/-- Every premise binding decides neither rest nor change without end: in `hatch` every
premise binds and arising does not recur (`hatch_rests_unrefuted`); in a queue closed once in which
one member replaces another at every step every premise binds and arising and ceasing recur. -/
theorem binding_contingent :
    (hatch.Premised ∧ hatch.Binds ∧ ¬ hatch.ArisingRecurs) ∧
      ((onceClosedQueue (fun _ => 1) (fun _ => 1) 0 2).Premised ∧
        (onceClosedQueue (fun _ => 1) (fun _ => 1) 0 2).Binds ∧
        (onceClosedQueue (fun _ => 1) (fun _ => 1) 0 2).ArisingRecurs ∧
        (onceClosedQueue (fun _ => 1) (fun _ => 1) 0 2).CeasingRecurs) :=
  have tally : Tally (fun _ => 1) (fun _ => 1) (fun _ => 1) := fun _ => ⟨0, rfl, rfl⟩
  have company : ∀ t, 0 < (fun _ => 1 : Nat → Nat) t → 0 < (fun _ => 1 : Nat → Nat) t :=
    fun _ pos => pos
  ⟨⟨hatch_binds.1, hatch_binds.2, (not_recurring_of_rests_unrefuted hatch_rests_unrefuted.2.2).1⟩,
   ⟨onceClosedQueue_premised tally company (Nat.lt_succ_self 1),
    onceClosedQueue_binds tally Nat.zero_lt_one (Nat.lt_succ_self 1) (J := 0) Nat.zero_lt_one,
    fun N => match total_pos _ (Nat.lt_of_lt_of_le Nat.zero_lt_one
        (Nat.le_of_eq (Queue.comings_eq tally N).symm)) with
      | ⟨x, _, comes⟩ => ⟨N, x, Nat.le_refl N, mark_pos.mp comes⟩,
    fun N => match total_pos _ (Nat.lt_of_lt_of_le Nat.zero_lt_one
        (Nat.le_of_eq (Queue.ceasings_eq tally N).symm)) with
      | ⟨x, _, ceases⟩ => ⟨N, x, Nat.le_refl N, mark_pos.mp ceases⟩⟩⟩

end World

/-! ## Saturated dependence -/

namespace Web

variable {F C : Type}

/-- A web saturated with dependence: every relatum depends on every condition, needing what
the condition stands at. -/
def saturated (W : Web F C) : Web F C :=
  { W with requires := fun _ _ _ => True, need := fun t _ c => W.level t c }

/-- Activity needing support holds in a saturated web whatever is active. -/
theorem saturated_dependent (W : Web F C) : W.saturated.Dependent :=
  fun _ _ _ _ _ => Nat.le_refl _

end Web

/-- Where no level exceeds `B`, every flow transmits each dependence of a saturated web
within `B`. -/
theorem Flow.transmits_saturated {X : Type} (L : Flow X X) {W : Web X X} {B : Nat}
    (bounded : ∀ t x, W.level t x ≤ B) (c : X) : L.TransmitsWithin W.saturated c B :=
  fun t _ _ _ _ => ⟨trivial, Nat.le_trans (bounded (t + 1) c) (Nat.le_add_left _ _)⟩

/-- Something arising across a step leaves something after it. -/
theorem Tally.after_pos {n c a : Nat → Nat} (tally : Tally n c a) {t : Nat} (joins : 0 < a t) :
    0 < n (t + 1) :=
  match tally t with
  | ⟨k, _, after⟩ =>
    Nat.lt_of_lt_of_le joins (Nat.le_trans (Nat.le_add_left _ k) (Nat.le_of_eq after.symm))

namespace World

/-- A world with its web saturated: the same flow, levels and activity, every relatum
depending on every relatum at what it stands at. -/
def saturated (w : World) : World :=
  World.of w.Relatum w.flow w.web.saturated

instance saturated_decided (w : World) [decided : ∀ t x, Decidable (w.web.active t x)] :
    ∀ t x, Decidable (w.saturated.web.active t x) :=
  decided

/-- Saturating keeps every premise but activity needing support and bounded transmission as
it is, and makes those two hold where levels are bounded. -/
theorem Premised.saturated {w : World} (premised : w.Premised) {B : Nat}
    (bounded : ∀ t x, w.web.level t x ≤ B) : w.saturated.Premised :=
  .of w.web.saturated_dependent (premised _ (.tail _ (.head _)))
    (premised _ (.tail _ (.tail _ (.head _)))) (premised _ (.tail _ (.tail _ (.tail _ (.head _)))))
    (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))
    (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
    (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))))
    ⟨B, w.flow.transmits_saturated bounded⟩

/-- A census counts something at a step at which something is active. -/
theorem counts_active {w : World} {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    {t : Nat} {f : w.Relatum} (active : w.web.active t f) : 0 < (alive t).length :=
  Nat.lt_of_lt_of_le (total_pos_of_mem (((census t).2 f).mp active) Nat.zero_lt_one)
    (Nat.le_of_eq (total_ones (alive t)))

/-- And something arising across a step at which something arises. -/
theorem counts_arising {w : World} [∀ t x, Decidable (w.web.active t x)]
    {alive : Nat → List w.Relatum} (census : w.web.Census alive) {t : Nat} {x : w.Relatum}
    (arises : w.web.Arises t x) : 0 < comings (alive (t + 1)) (fun x s => w.web.active s x) t :=
  Nat.lt_of_lt_of_le (mark_pos.mpr arises)
    (le_total_of_mem (q := fun y => mark (ComesToBe (fun s => w.web.active s y) t))
      (((census (t + 1)).2 x).mp arises.2))

/-- **Something active is counted.** Where something is active at a step, a counted census
counts something active there. -/
theorem CountsOf.active_pos {w : World} {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (counted : w.CountsOf alive n c a) (census : w.web.Census alive) {t : Nat} {f : w.Relatum}
    (active : w.web.active t f) : 0 < n t :=
  Nat.lt_of_lt_of_le (counts_active census active) (Nat.le_of_eq (counted t).1.symm)

/-- Where a selection binds counting, a counted census of a world meeting it counts something
active at every step across which something arises. -/
theorem CountsOf.company_binding {w : World} {S : Premise → Bool} (meets : w.Meets S)
    (binds : BindsCounting S) {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (counted : w.CountsOf alive n c a) (census : w.web.Census alive) :
    ∀ t, 0 < a t → 0 < n t :=
  match binds with
  | ⟨balanced, embodied, giving⟩ => fun _ => counted.company fun _ listed comes =>
    match giving with
    | .inl acting => active_of_coming_jointly (meets _ balanced) (meets _ acting)
        (Embodied.arising (meets _ embodied)) census comes
    | .inr ⟨taking, dissipative⟩ => active_of_coming_taking (meets _ balanced)
        (meets _ taking) (meets _ dissipative) (meets _ embodied) census listed comes

/-- Where activity needing support, only active relata giving or only active relata taking is
selected and binds, a counted census counts something active at some step. -/
theorem CountsOf.acts_of_binding {w : World} {S : Premise → Bool} (meets : w.Meets S)
    (binds : ∀ p, S p = true → p.Binds w) {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (counted : w.CountsOf alive n c a) (census : w.web.Census alive) :
    S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t := fun selected =>
  match selected with
  | .inl dependent => match binds _ dependent with
    | ⟨t, _, _, active, _, _⟩ => ⟨t, counted.active_pos census active⟩
  | .inr (.inl acting) => match binds _ acting with
    | ⟨t, _, _, present, gives⟩ => ⟨t, counted.active_pos census (meets _ acting t _ _ present gives)⟩
  | .inr (.inr taking) => match binds _ taking with
    | ⟨t, _, _, present, takes⟩ =>
      ⟨t, counted.active_pos census (meets _ taking t _ _ present takes).1⟩

/-- Where every relatum is embodied, only active relata give and bounded transmission binds, a
counted census counts, at some step, something active and something arising across it. -/
theorem CountsOf.joint_of_binding {w : World} (embodied : w.Embodied) (acting : w.Acting)
    (binds : Premise.transmitting.Binds w) {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (counted : w.CountsOf alive n c a) (census : w.web.Census alive) :
    ∃ t, 0 < n t ∧ 0 < a t :=
  match binds with
  | ⟨t, x, _, _, ⟨present, gives, comes⟩, _⟩ =>
    ⟨t, counted.active_pos census (acting t _ _ present gives),
     counted.arising_pos census ⟨fun active => comes.1 ((embodied x t).mp active),
       (embodied x (t + 1)).mpr comes.2⟩⟩

end World

/-! ## Counting where the premises of each selection bind -/

namespace OpenQueue

variable {n c : Nat → Nat}

/-- No member of an open queue stands at more than one. -/
theorem level_le (t : Nat) : ∀ x, (web n c).level t x ≤ 1
  | .member _ => mark_le_one _
  | .ground _ => Nat.zero_le 1

end OpenQueue

namespace LossyQueue

variable (n c : Nat → Nat) (U : Nat)

/-- What the front exchanges each way with a relatum across a step: one unit, across `U`, with
itself and with each member joining. -/
def exchanged (t : Nat) : OpenQueue.Relatum → Nat
  | .member k => mark (t = U ∧ (k = Queue.gone c t ∨ ComesToBe (Queue.holds n c k) t))
  | .ground _ => 0

/-- What the front takes from a relatum beyond what it gives: one unit, across `U`, from
itself. -/
def lost (t : Nat) : OpenQueue.Relatum → Nat
  | .member k => mark (t = U ∧ k = Queue.gone c t)
  | .ground _ => 0

/-- The front and a ground relatum take part at every step. Across `U` the front exchanges
one unit each way with itself and with each member joining, and takes one unit more from
itself; across each step `t` the ground relatum gives `gift t` to every relatum. -/
def flow (gift : Nat → Nat) : Flow OpenQueue.Relatum OpenQueue.Relatum where
  present t := [.member (Queue.gone c t), .ground 0]
  take t f x := match f with
    | .member _ => exchanged n c U t x + lost c U t x
    | .ground _ => 0
  give t f x := match f with
    | .member _ => exchanged n c U t x
    | .ground _ => gift t

variable {n c U}

/-- The front exchanges and loses only across `U`. -/
theorem moving {t : Nat} : ∀ {x : OpenQueue.Relatum}, 0 < exchanged n c U t x + lost c U t x → t = U
  | .member _, moves => if now : t = U then now else absurd moves fun pos => Nat.lt_irrefl 0
      (Nat.lt_of_lt_of_le pos (Nat.le_of_eq ((congrArg (· + _) (mark_zero fun ⟨same, _⟩ =>
        now same)).trans ((Nat.zero_add _).trans (mark_zero fun ⟨same, _⟩ => now same)))))
  | .ground _, moves => absurd moves (Nat.lt_irrefl 0)

end LossyQueue

namespace World

/-- A lossy queue: members stand and are active exactly while in the queue; across `U` the
front exchanges one unit each way with itself and with each member joining and loses one
unit more, which no standing records; across each step `t` a ground relatum gives `gift t` to
every relatum. Every relatum depends on every relatum, needing what it stands at. -/
def lossyQueue (n c : Nat → Nat) (U : Nat) (gift : Nat → Nat) : World :=
  World.of OpenQueue.Relatum (LossyQueue.flow n c U gift) ((OpenQueue.web n c).saturated)

instance lossyQueue_decided (n c : Nat → Nat) (U : Nat) (gift : Nat → Nat) :
    ∀ t x, Decidable ((lossyQueue n c U gift).web.active t x) :=
  openQueue_decided n c

variable {n c a : Nat → Nat} {U : Nat} {gift : Nat → Nat}

/-- A lossy queue dissipates, whatever its counts and gifts: the front takes from a closed
family what it gives there and, across `U`, one unit more, itself lying in the family; and no
family is closed across a step at which the ground relatum gives. -/
theorem lossyQueue_dissipative (n c : Nat → Nat) (U : Nat) (gift : Nat → Nat) :
    (lossyQueue n c U gift).Dissipative :=
  fun cs t _ closed f present => match f, present with
    | _, .head _ =>
      have split : total cs ((lossyQueue n c U gift).flow.take t (.member (Queue.gone c t))) =
          total cs (LossyQueue.exchanged n c U t) + total cs (LossyQueue.lost c U t) :=
        total_add _ _ cs
      if now : t = U then
        match Nat.eq_zero_or_pos (total cs (LossyQueue.lost c U t)) with
        | .inr pos => Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _)
            (Nat.le_trans (Nat.add_le_add_left pos _) (Nat.le_of_eq split.symm))
        | .inl zero =>
          have own : LossyQueue.lost c U t (.member (Queue.gone c t)) = 1 := mark_one ⟨now, rfl⟩
          absurd (closed _ (.head _) (.member (Queue.gone c t)) fun mem => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_trans (Nat.le_of_eq own.symm)
                (Nat.le_trans (le_total_of_mem mem) (Nat.le_of_eq zero))))).1
            (Nat.ne_of_gt (Nat.lt_of_lt_of_le Nat.zero_lt_one
              (Nat.le_trans (Nat.le_of_eq own.symm) (Nat.le_add_left _ _))))
      else gives_nothing (total_eq_zero fun x _ => match x with
        | .member _ => mark_zero fun ⟨same, _⟩ => now same
        | .ground _ => rfl)
    | _, .tail _ (.head _) => match Nat.eq_zero_or_pos (gift t) with
      | .inl zero => gives_nothing (total_eq_zero fun _ _ => zero)
      | .inr given => absurd (closed _ (.tail _ (.head _)) _ (OpenQueue.outside cs)).2
          (Nat.ne_of_gt given)
    | _, .tail _ (.tail _ no) => (nomatch no)

/-- Where the queue is not empty at `U`, only active relata take in a lossy queue. -/
theorem lossyQueue_taking (occupied : 0 < n U) : (lossyQueue n c U gift).Taking :=
  fun _ f _ present takes => match f, present, takes with
    | _, .head _, takes => ⟨OpenQueue.front.mpr (Nat.lt_of_lt_of_le occupied
        (Nat.le_of_eq (congrArg n (LossyQueue.moving takes).symm))), trivial⟩
    | _, .tail _ (.head _), takes => absurd takes (Nat.lt_irrefl 0)
    | _, .tail _ (.tail _ no), _ => (nomatch no)

/-- Where moreover nothing is given to every relatum, only active relata give. -/
theorem lossyQueue_acting (occupied : 0 < n U) (ungiven : ∀ t, gift t = 0) :
    (lossyQueue n c U gift).Acting :=
  fun t f x present gives => match f, present, gives with
    | _, .head _, gives => OpenQueue.front.mpr (Nat.lt_of_lt_of_le occupied
        (Nat.le_of_eq (congrArg n (LossyQueue.moving (U := U) (x := x)
          (Nat.lt_of_lt_of_le gives (Nat.le_add_right _ _))).symm)))
    | _, .tail _ (.head _), gives => absurd (ungiven t) (Nat.ne_of_gt gives)
    | _, .tail _ (.tail _ no), _ => (nomatch no)

/-- Where the queue is not empty at `U`, something joins across `T` and nothing is given to
every relatum across `U`, every premise but balance binds in a lossy queue, bounded
transmission where moreover `T` is `U` or something is given to every relatum across `T`:
the front is active at `U` and depends on its own standing, gives to itself and takes more
from itself, the span closed across `U`; a member joining across `T` arises and descends
from the front or the ground relatum; and no finite list holds every relatum. -/
theorem lossyQueue_binds (tally : Tally n c a) (occupied : 0 < n U) {T : Nat}
    (joins : 0 < a T) (shut : gift U = 0) :
    ∀ p : Premise, p ≠ .balanced → (p = .transmitting → T = U ∨ 0 < gift T) →
      p.Binds (lossyQueue n c U gift) :=
  have front : Queue.holds n c (Queue.gone c U) U := OpenQueue.front.mpr occupied
  have own : 0 < LossyQueue.exchanged n c U U (.member (Queue.gone c U)) :=
    mark_pos.mpr ⟨rfl, .inl rfl⟩
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally T).symm)) with
  | ⟨k, _, comes⟩ =>
    have comes := mark_pos.mp comes
    have stands : (lossyQueue n c U gift).web.ComesToStand T (.member k) :=
      ⟨fun standing => comes.1 (mark_pos.mp standing), mark_pos.mpr comes.2⟩
    fun
    | .dependent, _, _ => ⟨U, .member (Queue.gone c U), .member (Queue.gone c U), front, trivial,
        mark_pos.mpr front⟩
    | .balanced, other, _ => absurd rfl other
    | .acting, _, _ => ⟨U, _, .member (Queue.gone c U), .head _, own⟩
    | .taking, _, _ => ⟨U, _, .member (Queue.gone c U), .head _,
        Nat.lt_of_lt_of_le own (Nat.le_add_right _ _)⟩
    | .dissipative, _, _ =>
      have spanned : ∀ {j : Nat}, ¬ OpenQueue.Relatum.member j ∈
          (EnclosedQueue.span n c a U).map .member → ¬ (j = Queue.gone c U ∨
            ComesToBe (Queue.holds n c j) U) := fun out moves => out (mem_map_of (match moves with
        | .inl same => same ▸ EnclosedQueue.within_span tally (.inl front)
        | .inr comes => EnclosedQueue.within_span tally (.inr comes.2)))
      ⟨_, U, _, distinct_map OpenQueue.member_inj (EnclosedQueue.span_distinct U),
       fun f present x out => match f, present, x with
        | _, .head _, .member _ =>
          have still : LossyQueue.exchanged n c U U (.member _) = 0 :=
            mark_zero fun ⟨_, moves⟩ => spanned out moves
          ⟨(congrArg (· + _) still).trans ((Nat.zero_add _).trans
             (mark_zero fun ⟨_, same⟩ => spanned out (.inl same))), still⟩
        | _, .head _, .ground _ => ⟨rfl, rfl⟩
        | _, .tail _ (.head _), _ => ⟨rfl, shut⟩
        | _, .tail _ (.tail _ no), _ => (nomatch no),
       .head _, Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le own (Nat.le_add_right _ _))
         (le_total_of_mem (q := (lossyQueue n c U gift).flow.take U (.member (Queue.gone c U)))
           (mem_map_of (EnclosedQueue.within_span tally (.inl front))))⟩
    | .embodied, _, _ => ⟨T, .member k, comes⟩
    | .counted, _, _ => fun ⟨all, _, every⟩ => OpenQueue.outside all (every _)
    | .transmitting, _, route => match route rfl with
      | .inl same => ⟨T, .member k, .member (Queue.gone c T), .member k,
          ⟨.head _, mark_pos.mpr ⟨same, .inr comes⟩, stands⟩, trivial⟩
      | .inr given => ⟨T, .member k, .ground 0, .member k, ⟨.tail _ (.head _), given, stands⟩,
          trivial⟩

/-- So under each selection without balance a lossy queue meets the selection and each
selected premise binds there, given what binding needs: the queue not empty at `U`, something
joining across `T`, nothing given across `U`, nothing given at all where only active relata
giving is selected, and where bounded transmission is, `T` being `U` or something given to
every relatum across `T`. -/
theorem lossyQueue_binding (tally : Tally n c a) (occupied : 0 < n U) {T : Nat}
    (joins : 0 < a T) (shut : gift U = 0) {S : Premise → Bool} (unbalanced : S .balanced = false)
    (giving : S .acting = true → ∀ t, gift t = 0)
    (descends : S .transmitting = true → T = U ∨ 0 < gift T) :
    ∀ p, S p = true → p.Holds (lossyQueue n c U gift) ∧ p.Binds (lossyQueue n c U gift) :=
  fun p selected =>
    have binds := lossyQueue_binds tally occupied joins shut p
      (fun same => absurd (unbalanced.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => descends (same ▸ selected))
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (OpenQueue.web n c), binds⟩
    | .balanced, selected => nomatch unbalanced.symm.trans selected
    | .acting, selected => ⟨lossyQueue_acting occupied (giving selected), binds⟩
    | .taking, _ => ⟨lossyQueue_taking occupied, binds⟩
    | .dissipative, _ => ⟨lossyQueue_dissipative n c U gift, binds⟩
    | .embodied, _ => ⟨(openQueue_holds n c).2.2.2.1, binds⟩
    | .counted, _ => ⟨⟨_, openQueue_census n c⟩, binds⟩
    | .transmitting, _ => ⟨⟨1, Flow.transmits_saturated _ OpenQueue.level_le⟩, binds⟩

end World

namespace RelayQueue

variable (U : Nat)

/-- What the ground relata stand at: ground `1` at two up to `U`, ground `0` at one after
it, the rest at nothing. -/
def level (t : Nat) : OpenQueue.Relatum → Nat
  | .ground 0 => mark (U < t)
  | .ground 1 => mark (t ≤ U) + mark (t ≤ U)
  | .ground (_ + 2) => 0
  | .member _ => 0

/-- `g` takes part at every step; across `U` it takes the two units ground `1` stands at and
gives one to ground `0`. -/
def flow (g : OpenQueue.Relatum) : Flow OpenQueue.Relatum OpenQueue.Relatum where
  present _ := [g]
  take t _ x := match x with
    | .ground 1 => mark (t = U) + mark (t = U)
    | .ground 0 => 0
    | .ground (_ + 2) => 0
    | .member _ => 0
  give t _ x := match x with
    | .ground 0 => mark (t = U)
    | .ground (_ + 1) => 0
    | .member _ => 0

/-- Up to `U` is before it or at it. -/
theorem up_to (t : Nat) : mark (t + 1 ≤ U) + mark (t = U) = mark (t ≤ U) :=
  if before : t + 1 ≤ U then
    (congrArg (· + _) (mark_one before)).trans ((congrArg (1 + ·) (mark_zero fun same =>
      Nat.lt_irrefl t (Nat.lt_of_lt_of_le before (Nat.le_of_eq same.symm)))).trans
        (mark_one (Nat.le_of_succ_le before)).symm)
  else if now : t = U then
    (congrArg (· + _) (mark_zero before)).trans ((Nat.zero_add _).trans
      ((mark_one now).trans (mark_one (Nat.le_of_eq now)).symm))
  else (congrArg (· + _) (mark_zero before)).trans ((Nat.zero_add _).trans ((mark_zero now).trans
    (mark_zero fun le => match Nat.eq_or_lt_of_le le with
      | .inl same => now same
      | .inr lt => before lt).symm))

/-- After `U` is after the step from `U` or at it. -/
theorem after (t : Nat) : mark (U < t + 1) = mark (U < t) + mark (t = U) :=
  if later : U < t then
    (mark_one (Nat.lt_succ_of_lt later)).trans ((congrArg (· + mark (t = U)) (mark_one later)).trans
      (congrArg (1 + ·) (mark_zero fun same =>
        Nat.lt_irrefl U (Nat.lt_of_lt_of_le later (Nat.le_of_eq same))))).symm
  else if now : t = U then
    (mark_one (Nat.lt_succ_of_le (Nat.le_of_eq now.symm))).trans ((mark_one now).symm.trans
      ((Nat.zero_add _).symm.trans (congrArg (· + _) (mark_zero later).symm)))
  else (mark_zero fun le => match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ le) with
      | .inl same => now same.symm
      | .inr lt => later lt).trans
    ((congrArg (· + mark (t = U)) (mark_zero later)).trans ((Nat.zero_add _).trans
      (mark_zero now))).symm

end RelayQueue

namespace World

/-- A relay beside a queue: members active exactly while in the queue, standing at nothing;
across `U`, `g` hands one of the two units ground `1` stands at on to ground `0`, which comes
to stand, and the other is lost. Every relatum depends on every relatum, needing what it
stands at. -/
def relayQueue (n c : Nat → Nat) (U : Nat) (g : OpenQueue.Relatum) : World :=
  World.of OpenQueue.Relatum (RelayQueue.flow U g) (Web.saturated ({ OpenQueue.web n c with level := RelayQueue.level U } : Web _ _))

instance relayQueue_decided (n c : Nat → Nat) (U : Nat) (g : OpenQueue.Relatum) :
    ∀ t x, Decidable ((relayQueue n c U g).web.active t x) :=
  openQueue_decided n c

variable {n c : Nat → Nat} {U : Nat} {g : OpenQueue.Relatum}

theorem relayQueue_balanced (n c : Nat → Nat) (U : Nat) (g : OpenQueue.Relatum) :
    (relayQueue n c U g).Balanced
  | _, .member _ => rfl
  | t, .ground 0 => RelayQueue.after U t
  | t, .ground 1 => (Nat.add_add_add_comm (mark (t + 1 ≤ U)) (mark (t + 1 ≤ U)) (mark (t = U))
      (mark (t = U))).trans (congrArg (fun m => m + m) (RelayQueue.up_to U t))
  | _, .ground (_ + 2) => rfl

/-- A relay dissipates, whoever relays: across `U` it gives a closed family at most one unit
and takes at least two. -/
theorem relayQueue_dissipative (n c : Nat → Nat) (U : Nat) (g : OpenQueue.Relatum) :
    (relayQueue n c U g).Dissipative :=
  fun cs t distinct closed f present =>
    if now : t = U then
      have lost : 2 ≤ total cs ((relayQueue n c U g).flow.take t f) :=
        match Nat.lt_or_ge (total cs ((relayQueue n c U g).flow.take t f)) 2 with
        | .inr enough => enough
        | .inl short =>
          have two : (relayQueue n c U g).flow.take t f (.ground 1) = 2 :=
            (congrArg (· + mark (t = U)) (mark_one now)).trans (congrArg (1 + ·) (mark_one now))
          absurd (closed f present (.ground 1) fun mem => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le short
              (Nat.le_trans (Nat.le_of_eq two.symm) (le_total_of_mem mem)))).1
            (Nat.ne_of_gt (Nat.lt_of_lt_of_le Nat.zero_lt_two (Nat.le_of_eq two.symm)))
      Nat.le_trans (Nat.add_le_add (Nat.le_trans (total_le_at (a := .ground 0)
          (fun b gives => match b, gives with
            | .ground 0, _ => rfl
            | .ground (_ + 1), gives => absurd gives (Nat.lt_irrefl 0)
            | .member _, gives => absurd gives (Nat.lt_irrefl 0)) distinct)
          (mark_le_one _)) (sign_le_one _)) lost
    else gives_nothing (total_eq_zero fun x _ => match x with
      | .ground 0 => mark_zero now
      | .ground (_ + 1) => rfl
      | .member _ => rfl)

/-- Where `g` is active across `U`, only active relata give and take there. -/
theorem relayQueue_acts (active : (relayQueue n c U g).web.active U g) :
    (relayQueue n c U g).Acting ∧ (relayQueue n c U g).Taking :=
  have at_relay : ∀ {t : Nat}, 0 < mark (t = U) → (relayQueue n c U g).web.active t g :=
    fun moves => Eq.subst (motive := fun s => (relayQueue n c U g).web.active s g)
      (mark_pos.mp moves).symm active
  ⟨fun _ f x present gives => match f, present, x, gives with
    | _, .head _, .ground 0, gives => at_relay gives
    | _, .head _, .ground (_ + 1), gives => absurd gives (Nat.lt_irrefl 0)
    | _, .head _, .member _, gives => absurd gives (Nat.lt_irrefl 0)
    | _, .tail _ no, _, _ => (nomatch no),
   fun _ f x present takes => match f, present, x, takes with
    | _, .head _, .ground 1, takes => ⟨match Nat.eq_zero_or_pos (mark (_ = U)) with
        | .inr moves => at_relay moves
        | .inl zero => absurd takes (Nat.lt_irrefl 0 ∘ fun pos => Nat.lt_of_lt_of_le pos
            (Nat.le_of_eq ((congrArg (· + _) zero).trans (congrArg (0 + ·) zero)))), trivial⟩
    | _, .head _, .ground 0, takes => absurd takes (Nat.lt_irrefl 0)
    | _, .head _, .ground (_ + 2), takes => absurd takes (Nat.lt_irrefl 0)
    | _, .head _, .member _, takes => absurd takes (Nat.lt_irrefl 0)
    | _, .tail _ no, _, _ => (nomatch no)⟩

/-- Every premise but embodiment binds in a relay beside a queue, activity needing support
where `g` is active across `U`: `g` depends on ground `1` standing at two, gives to ground `0`
and takes from ground `1`, the two closed across `U`; ground `0` comes to stand, descending
from `g`; and no finite list holds every relatum. -/
theorem relayQueue_binds :
    ∀ p : Premise, p ≠ .embodied → (p = .dependent → (relayQueue n c U g).web.active U g) →
      p.Binds (relayQueue n c U g)
  | .dependent, _, active => ⟨U, g, .ground 1, active rfl, trivial,
      Nat.lt_of_lt_of_le (mark_pos.mpr (Nat.le_refl U)) (Nat.le_add_right _ _)⟩
  | .balanced, _, _ => ⟨U, .ground 0, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      (mark_pos.mpr (Nat.lt_succ_self U)) (Nat.le_of_eq (same.trans (mark_zero (Nat.lt_irrefl U)))))⟩
  | .acting, _, _ => ⟨U, g, .ground 0, .head _, mark_pos.mpr rfl⟩
  | .taking, _, _ => ⟨U, g, .ground 1, .head _,
      Nat.lt_of_lt_of_le (mark_pos.mpr rfl) (Nat.le_add_right _ _)⟩
  | .dissipative, _, _ => ⟨[.ground 1, .ground 0], U, g,
      ⟨fun mem => match mem with | .tail _ no => (nomatch no), fun no => (nomatch no), trivial⟩,
      fun _ _ x out => match x with
        | .ground 0 => absurd (.tail _ (.head _)) out
        | .ground 1 => absurd (.head _) out
        | .ground (_ + 2) => ⟨rfl, rfl⟩
        | .member _ => ⟨rfl, rfl⟩,
      .head _, Nat.lt_of_lt_of_le (mark_pos.mpr rfl)
        (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))⟩
  | .embodied, other, _ => absurd rfl other
  | .counted, _, _ => fun ⟨all, _, every⟩ => OpenQueue.outside all (every _)
  | .transmitting, _, _ => ⟨U, .ground 0, g, .ground 0,
      ⟨.head _, mark_pos.mpr rfl, fun pos => Nat.lt_irrefl U (mark_pos.mp pos),
       mark_pos.mpr (Nat.lt_succ_self U)⟩, trivial⟩

/-- So under each selection without embodiment a relay beside a queue meets the selection and
each selected premise binds there, wherever `g` is active across `U` if activity needing
support, only active relata giving or only active relata taking is selected. -/
theorem relayQueue_binding {S : Premise → Bool} (disembodied : S .embodied = false)
    (active : S .dependent = true ∨ S .acting = true ∨ S .taking = true →
      (relayQueue n c U g).web.active U g) :
    ∀ p, S p = true → p.Holds (relayQueue n c U g) ∧ p.Binds (relayQueue n c U g) :=
  fun p selected =>
    have binds := relayQueue_binds p
      (fun same => absurd (disembodied.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => active (.inl (same ▸ selected)))
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent ({ OpenQueue.web n c with level := RelayQueue.level U } : Web _ _), binds⟩
    | .balanced, _ => ⟨relayQueue_balanced n c U g, binds⟩
    | .acting, selected => ⟨(relayQueue_acts (active (.inr (.inl selected)))).1, binds⟩
    | .taking, selected => ⟨(relayQueue_acts (active (.inr (.inr selected)))).2, binds⟩
    | .dissipative, _ => ⟨relayQueue_dissipative n c U g, binds⟩
    | .embodied, selected => nomatch disembodied.symm.trans selected
    | .counted, _ => ⟨⟨_, openQueue_census n c⟩, binds⟩
    | .transmitting, _ => ⟨⟨2, Flow.transmits_saturated (W := ({ OpenQueue.web n c with level := RelayQueue.level U } : Web _ _)) _ fun _ x => match x with
        | .ground 0 => Nat.le_succ_of_le (mark_le_one _)
        | .ground 1 => Nat.add_le_add (mark_le_one _) (mark_le_one _)
        | .ground (_ + 2) => Nat.zero_le 2
        | .member _ => Nat.zero_le 2⟩, binds⟩

variable {a : Nat → Nat} {T E J : Nat}

/-- Under each selection without only active relata giving and without only active relata
taking, a queue closed once meets the selection and every premise binds there, where the
queue is not empty at `T`, its front stands more than join there, and something joins across
some step `J`; nothing joining an empty queue is not needed. -/
theorem onceClosedQueue_binding (tally : Tally n c a) (occupied : 0 < n T) (excess : a T < E)
    (joins : 0 < a J) {S : Premise → Bool} (giving : S .acting = false)
    (taking : S .taking = false) :
    ∀ p, S p = true → p.Holds (onceClosedQueue n c T E) ∧ p.Binds (onceClosedQueue n c T E)
  | .dependent, _ => ⟨OnceClosedQueue.dependent_any_activity _,
      onceClosedQueue_binds tally occupied excess joins _⟩
  | .balanced, _ => ⟨onceClosedQueue_balanced n c T E,
      onceClosedQueue_binds tally occupied excess joins _⟩
  | .acting, selected => nomatch giving.symm.trans selected
  | .taking, selected => nomatch taking.symm.trans selected
  | .dissipative, _ => ⟨onceClosedQueue_dissipative tally (fun _ => occupied) excess,
      onceClosedQueue_binds tally occupied excess joins _⟩
  | .embodied, _ => ⟨onceClosedQueue_embodied n c T E,
      onceClosedQueue_binds tally occupied excess joins _⟩
  | .counted, _ => ⟨⟨_, onceClosedQueue_census n c T E⟩,
      onceClosedQueue_binds tally occupied excess joins _⟩
  | .transmitting, _ => ⟨⟨1 + E, OnceClosedQueue.transmits_any_flow _⟩,
      onceClosedQueue_binds tally occupied excess joins _⟩

/-- Under each selection without only active relata giving and without dissipation, an open
queue with its web saturated meets the selection and every premise binds there, where
something joins across `T`: a member joining arises, changing its standing, and descends from
the front; after `T` the front is active, depends on its own standing and takes from every
ground relatum. -/
theorem openQueue_saturated_binding (tally : Tally n c a) (joins : 0 < a T)
    {S : Premise → Bool} (giving : S .acting = false) (dissipating : S .dissipative = false) :
    ∀ p, S p = true → p.Holds (openQueue n c).saturated ∧ p.Binds (openQueue n c).saturated :=
  have front : Queue.holds n c (Queue.gone c (T + 1)) (T + 1) :=
    OpenQueue.front.mpr (tally.after_pos joins)
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally T).symm)),
      openQueue_holds n c with
  | ⟨k, _, comes⟩, ⟨_, balanced, taking, embodied, counted, _⟩ =>
    have comes := mark_pos.mp comes
    fun
    | .dependent, _ => ⟨Web.saturated_dependent (openQueue n c).web, ⟨T + 1, .member k, .member k, comes.2, trivial,
        mark_pos.mpr comes.2⟩⟩
    | .balanced, _ => ⟨balanced, ⟨T, .member k, fun same => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le (mark_pos.mpr comes.2) (Nat.le_of_eq (same.trans (mark_zero comes.1))))⟩⟩
    | .acting, selected => nomatch giving.symm.trans selected
    | .taking, _ => ⟨taking, ⟨T + 1, _, .ground 0, .head _, mark_pos.mpr front⟩⟩
    | .dissipative, selected => nomatch dissipating.symm.trans selected
    | .embodied, _ => ⟨embodied, ⟨T, .member k, comes⟩⟩
    | .counted, _ => ⟨counted, fun ⟨all, _, every⟩ => OpenQueue.outside all (every _)⟩
    | .transmitting, _ => ⟨⟨1, Flow.transmits_saturated _ OpenQueue.level_le⟩,
        ⟨T, .member k, _, .member k, ⟨.head _, mark_pos.mpr comes,
          fun standing => comes.1 (mark_pos.mp standing), mark_pos.mpr comes.2⟩, trivial⟩⟩

/-- **The binding steps where the premises of each selection bind, for every counted census**:
those of `counting_under_sound`; something active where activity needing support, only active
relata giving or only active relata taking is selected (`CountsOf.acts_of_binding`); something
arising where embodiment is (`binds_arising_counted`); and something arising across a step at
which something is active where embodiment, only active relata giving and bounded transmission
are (`CountsOf.joint_of_binding`). -/
theorem binding_counting_under_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ ∀ p, S p = true → p.Binds w) :
    w.CountsHold fun n _ a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true → S .transmitting = true →
          ∃ t, 0 < n t ∧ 0 < a t) :=
  match within with
  | ⟨meets, binds⟩ => fun alive n c a census counted =>
    ⟨counting_under_sound S w meets alive n c a census counted,
     counted.acts_of_binding meets binds census,
     fun embodied => binds_arising_counted (binds _ embodied) alive n c a census counted,
     fun embodied acting transmitting => counted.joint_of_binding (meets _ embodied)
      (meets _ acting) (binds _ transmitting) census⟩

/-- **The witnesses where the premises of each selection bind**: a relay queue where embodiment
is not selected; where it is, a queue closed once, or, where only active relata giving and
taking are not both left out, saturated ones (`onceClosedQueue_binding`,
`openQueue_saturated_binding`), and lossy queues where balance is not selected. -/
theorem binding_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ ∀ p, S p = true → p.Binds w)
      fun n _ a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true → S .transmitting = true →
          ∃ t, 0 < n t ∧ 0 < a t) :=
  fun n c a tally ⟨quiet, acts, arises, joint⟩ =>
    have within : ∀ {w : World}, (∀ p, S p = true → p.Holds w ∧ p.Binds w) →
        w.Meets S ∧ ∀ p, S p = true → p.Binds w := fun binding =>
      ⟨fun p selected => (binding p selected).1, fun p selected => (binding p selected).2⟩
    have relayed : S .embodied = false → ∀ U g, (S .dependent = true ∨ S .acting = true ∨
        S .taking = true → (relayQueue n c U g).web.active U g) →
        WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ ∀ p, S p = true → p.Binds w) n c a :=
      fun disembodied _ _ active => ⟨_, fun _ _ => inferInstance, _,
        within (relayQueue_binding disembodied active), openQueue_census n c,
        openQueue_counts tally⟩
    have lossy : ∀ (T U : Nat) (gift : Nat → Nat), 0 < a T → 0 < n U → gift U = 0 →
        S .balanced = false →
        (S .acting = true → ∀ t, gift t = 0) →
        (S .transmitting = true → T = U ∨ 0 < gift T) →
        WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ ∀ p, S p = true → p.Binds w) n c a :=
      fun _ _ _ joins occupied shut unbalanced giving descends => ⟨_, fun _ _ => inferInstance, _,
        within (lossyQueue_binding tally occupied joins shut unbalanced giving descends),
        openQueue_census n c, openQueue_counts tally⟩
    match he : S .embodied with
    | false => match hp : S .dependent, ha : S .acting, ht : S .taking with
      | false, false, false => relayed he 0 (.ground 1) fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected
      | true, _, _ => match acts (.inl hp) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
      | false, true, _ => match acts (.inr (.inl ha)) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
      | false, false, true => match acts (.inr (.inr ht)) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
    | true => match arises he with
      | ⟨T, joins⟩ =>
        have once : (∀ t, 0 < a t → 0 < n t) →
            WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ ∀ p, S p = true → p.Binds w) n c a := fun company =>
          ⟨onceClosedQueue n c T (a T + 1), fun _ _ => inferInstance, Queue.line n c,
           ⟨(onceClosedQueue_premised tally company (Nat.lt_succ_self _)).meets S,
            fun p _ => onceClosedQueue_binds tally (company T joins) (Nat.lt_succ_self _) joins p⟩,
           onceClosedQueue_census n c T (a T + 1), Queue.counts tally⟩
        match hb : S .balanced, ha : S .acting, ht : S .taking, hd : S .dissipative,
            hr : S .transmitting with
        | true, true, _, _, _ => once (quiet ⟨hb, he, .inl ha⟩)
        | true, false, true, true, _ => once (quiet ⟨hb, he, .inr ⟨ht, hd⟩⟩)
        | true, false, false, _, _ => ⟨_, fun _ _ => inferInstance, Queue.line n c,
            within (onceClosedQueue_binding tally (tally.after_pos joins)
              (Nat.lt_succ_self (a (T + 1))) joins ha ht),
            onceClosedQueue_census n c (T + 1) (a (T + 1)).succ,
            Queue.counts tally⟩
        | true, false, true, false, _ => ⟨_, fun _ _ => inferInstance, _,
            within (openQueue_saturated_binding tally joins ha hd), openQueue_census n c,
            openQueue_counts tally⟩
        | false, true, _, _, true => match joint he ha hr with
          | ⟨U, occupied, here⟩ => lossy U U (fun _ => 0) here occupied rfl hb (fun _ _ => rfl)
              fun _ => .inl rfl
        | false, true, _, _, false => lossy T (T + 1) (fun _ => 0) joins (tally.after_pos joins)
            rfl hb (fun _ _ => rfl) fun selected => nomatch hr.symm.trans selected
        | false, false, _, _, _ => lossy T (T + 1) (fun t => mark (t = T)) joins
            (tally.after_pos joins) (mark_zero (Nat.succ_ne_self T)) hb
            (fun selected => nomatch ha.symm.trans selected) fun _ => .inr (mark_pos.mpr rfl)

/-- The laws of counting where the premises of each selection bind. A property of the counts
holds of every census of every world meeting a selection in which each selected premise binds
exactly when it holds of every tally meeting the laws of `counting_under` and three more:
something is active, where activity needing support, only active relata giving or only active
relata taking is selected; something arises, where embodiment is; and something arises across
a step at which something is active, where embodiment, only active relata giving and bounded
transmission are. Binding adds nothing else: each binding is an instance of a condition, and
these are what the instances leave in the counts. -/
theorem binding_counting_under (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true → S .transmitting = true →
        ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
        (∀ p, S p = true → p.Binds w) → w.CensusMarksHold Q :=
  have table := census_table_marks_hold pointwise (binding_counting_under_sound S)
    (binding_counting_under_witnessed S)
  ⟨fun law w _ meets binds => table.mp (fun n c a tally ⟨quiet, acts, arises, joint⟩ =>
      law n c a tally quiet acts arises joint) w ⟨meets, binds⟩,
   fun law n c a tally quiet acts arises joint => table.mpr (fun w _ ⟨meets, binds⟩ =>
      law w meets binds) n c a tally ⟨quiet, acts, arises, joint⟩⟩


instance (S : Premise → Bool) : Decidable (BindsCounting S) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

/-- So binding adds that something is active exactly where activity needing support, only
active relata giving, only active relata taking or embodiment is selected. -/
theorem binding_activity_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  have pointwise : Pointwise fun n (_ _ : Nat → Nat) => ∃ t, 0 < n t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩
  ⟨fun law => match hp : S .dependent, ha : S .acting, ht : S .taking, he : S .embodied with
    | true, _, _, _ => .inl rfl
    | false, true, _, _ => .inr (.inl rfl)
    | false, false, true, _ => .inr (.inr (.inl rfl))
    | false, false, false, true => .inr (.inr (.inr rfl))
    | false, false, false, false => match (binding_counting_under S pointwise).mpr law
        (fun _ => 0) (fun _ => 0) (fun _ => 0) (fun _ => ⟨0, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun selected => (binding_counting_under S pointwise).mp fun _ _ _ tally _ acts arises _ =>
    match selected with
    | .inl dependent => acts (.inl dependent)
    | .inr (.inl acting) => acts (.inr (.inl acting))
    | .inr (.inr (.inl taking)) => acts (.inr (.inr taking))
    | .inr (.inr (.inr embodied)) => match arises embodied with
      | ⟨t, joins⟩ => ⟨t + 1, tally.after_pos joins⟩⟩

/-- Binding adds that something arises exactly where embodiment is selected. -/
theorem binding_arising_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun _ _ a => ∃ t, 0 < a t) ↔
      S .embodied = true :=
  have pointwise : Pointwise fun (_ _ : Nat → Nat) a => ∃ t, 0 < a t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | true => rfl
    | false => match (binding_counting_under S pointwise).mpr law (fun _ => 1) (fun _ => 0)
        (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun embodied => (binding_counting_under S pointwise).mp fun _ _ _ _ _ _ arises _ =>
     arises embodied⟩

/-- And that something arises across a step at which something is active exactly where
embodiment is selected and either the selection binds counting or only active relata giving
and bounded transmission are selected: there what arises descends from a relatum active at
the step. -/
theorem binding_joint_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ S .acting = true ∧ S .transmitting = true) :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∃ t, 0 < n t ∧ 0 < a t :=
    fun same ⟨t, active, arising⟩ => ⟨t, Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
      Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | false => match (binding_counting_under S pointwise).mpr law (fun _ => 1) (fun _ => 0)
        (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, _, no⟩ => absurd no (Nat.lt_irrefl 0)
    | true => if both : BindsCounting S ∨ S .acting = true ∧ S .transmitting = true then
        ⟨rfl, both⟩
      else match (binding_counting_under S pointwise).mpr law Queue.lone (fun _ => 0) Queue.joins
          Queue.lone_tally (fun binds => absurd (.inl binds) both) (fun _ => ⟨1, Nat.zero_lt_one⟩)
          (fun _ => ⟨0, Nat.zero_lt_one⟩)
          (fun _ acting transmitting => absurd (.inr ⟨acting, transmitting⟩) both) with
        | ⟨0, empty, _⟩ => absurd empty (Nat.lt_irrefl 0)
        | ⟨_ + 1, _, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun ⟨embodied, both⟩ => (binding_counting_under S pointwise).mp
    fun _ _ _ _ quiet _ arises joint => match both with
    | .inl binds => match arises embodied with
      | ⟨t, joins⟩ => ⟨t, quiet binds t joins, joins⟩
    | .inr ⟨acting, transmitting⟩ => joint embodied acting transmitting⟩

end World

/-! ## Counting in finite worlds where every premise but the census binds -/

namespace EnclosedQueue

variable {n c a : Nat → Nat} {B : Nat}

/-- No member of an enclosed queue stands at more than one and its store. -/
theorem level_le (t k : Nat) : level n c a B t k ≤ 1 + B :=
  Nat.le_trans (place_le _ _ _ k)
    (Nat.add_le_add_left (Nat.le_trans (Nat.sub_le _ _) (Nat.sub_le _ _)) 1)

end EnclosedQueue

namespace World

variable {n c a : Nat → Nat} {B T : Nat}

/-- Under a change bound from the first step, with nothing joining an empty queue and
something joining across `T`, every premise but the census binds in the finite queue with its
web saturated: a member joining across `T` arises, changing its standing, and descends from
the front, after `T` active and depending on its own standing; and the front takes from the
family of all places, which is closed, since dissipation lets it give there only less than it
takes. -/
theorem finiteQueue_saturated_binds (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (bound : ChangeBound 0 B n c a) (joins : 0 < a T) :
    ∀ p : Premise, p ≠ .counted → p.Binds (finiteQueue n c a B).saturated :=
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally T).symm)),
      finiteQueue_finite n c a B with
  | ⟨x, _, comes⟩, ⟨all, distinct, every⟩ =>
    have comes := mark_pos.mp comes
    have placed : x < FiniteQueue.size B := FiniteQueue.placed tally bound comes.2
    have stands : 0 < EnclosedQueue.level n c a B (T + 1) x := EnclosedQueue.place_pos.mp comes.2
    have gives : 0 < (finiteQueue n c a B).flow.give T (FiniteQueue.front c B T) ⟨x, placed⟩ :=
      Nat.lt_of_lt_of_le stands (Nat.le_of_eq (congrArg (EnclosedQueue.level n c a B (T + 1) x - ·)
        (EnclosedQueue.place_zero comes.1).symm))
    have closed : (finiteQueue n c a B).flow.ClosedAt all T := fun _ _ y out => absurd (every y) out
    have takes : 0 < total all ((finiteQueue n c a B).flow.take T (FiniteQueue.front c B T)) :=
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le gives (Nat.le_trans (le_total_of_mem (every _))
          (Nat.le_add_right _ _)))
        ((finiteQueue_premised tally company bound) _
          (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))) all T distinct closed _ (.head _))
    fun
    | .dependent, _ => ⟨T + 1, ⟨x, placed⟩, ⟨x, placed⟩, comes.2, trivial, stands⟩
    | .balanced, _ => ⟨T, ⟨x, placed⟩, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
        (Nat.le_of_eq (same.trans (EnclosedQueue.place_zero comes.1))))⟩
    | .acting, _ => ⟨T, _, ⟨x, placed⟩, .head _, gives⟩
    | .taking, _ => match total_pos _ takes with
      | ⟨i, _, taken⟩ => ⟨T, _, i, .head _, taken⟩
    | .dissipative, _ => ⟨all, T, _, distinct, closed, .head _, takes⟩
    | .embodied, _ => ⟨T, ⟨x, placed⟩, comes⟩
    | .counted, other => absurd rfl other
    | .transmitting, _ => ⟨T, ⟨x, placed⟩, _, ⟨x, placed⟩, ⟨.head _, gives,
        fun standing => comes.1 (EnclosedQueue.place_pos.mpr standing), stands⟩, trivial⟩

/-- **The steps in finite worlds in which every premise but the census binds, for every counted census**: nothing arises across a step at which
nothing is active (`active_of_coming_jointly`), change stays within a bound from the first step
(`enclosure_bounds_change_counted`), and something arises (`binds_arising_counted`). -/
theorem finite_binding_counting_sound (w : World)
    (within : w.Premised ∧ w.Finite ∧ ∀ p : Premise, p ≠ .counted → p.Binds w) :
    w.CountsHold fun n c a =>
      (∀ t, 0 < a t → 0 < n t) ∧ (∃ B, ChangeBound 0 B n c a) ∧ ∃ t, 0 < a t :=
  match within with
  | ⟨premised, finite, binds⟩ => fun alive n c a census counted =>
    ⟨fun _ => counted.company fun _ _ comes => active_of_coming_jointly
        (premised _ (.tail _ (.head _))) (premised _ (.tail _ (.tail _ (.head _))))
        (Embodied.arising (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _
          (.head _))))))))
        census comes,
      ⟨_, (enclosure_bounds_change_counted census counted
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
        (premised _ (.tail _ (.head _)))
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))
        (T := 0) fun t _ => finite.enclosed t).from_zero⟩,
      binds_arising_counted (binds .embodied fun same => nomatch same) alive n c a census counted⟩

/-- **The witnesses in finite worlds in which every premise but the census binds**: finite queues, saturated (`finiteQueue_saturated_binds`). -/
theorem finite_binding_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x)
      (fun w => w.Premised ∧ w.Finite ∧ ∀ p : Premise, p ≠ .counted → p.Binds w)
      fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ (∃ B, ChangeBound 0 B n c a) ∧ ∃ t, 0 < a t :=
  fun n c a tally ⟨company, ⟨B, bound⟩, ⟨_, joins⟩⟩ =>
    ⟨(finiteQueue n c a B).saturated, fun _ _ => inferInstance, _,
      ⟨(finiteQueue_premised tally company bound).saturated
          fun t i => EnclosedQueue.level_le (n := n) (c := c) (a := a) (B := B) t i.val,
        finiteQueue_finite n c a B, finiteQueue_saturated_binds tally company bound joins⟩,
      finiteQueue_census n c a B, finiteQueue_counts tally bound⟩

/-- In finite worlds in which every premise but the census binds, the laws of counting under
the eight are those of finite worlds and that something arises: a property of the counts
holds of every census of every finite world meeting the eight in which every premise but the
census binds exactly when it holds of every tally in which nothing arises across a step at
which nothing is active, change stays within a bound from the first step, and something
arises. -/
theorem finite_binding_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      (∃ t, 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised → w.Finite →
        (∀ p : Premise, p ≠ .counted → p.Binds w) → w.CensusMarksHold Q :=
  have table := census_table_marks_hold pointwise finite_binding_counting_sound
    finite_binding_counting_witnessed
  ⟨fun law w _ premised finite binds => table.mp (fun n c a tally ⟨company, bound, arises⟩ =>
      law n c a tally company bound arises) w ⟨premised, finite, binds⟩,
   fun law n c a tally company bound arises => table.mpr (fun w _ ⟨premised, finite, binds⟩ =>
      law w premised finite binds) n c a tally ⟨company, bound, arises⟩⟩

end World


/-! ## Counting under enclosure where every premise binds -/

namespace World

variable {n c a : Nat → Nat} {B T : Nat}

/-- Under a change bound from the first step, with nothing joining an empty queue and
something joining across `T`, every premise binds in the enclosed queue with its web
saturated: a member joining across `T` arises, changing its standing, and descends from the
front, after `T` active and depending on its own standing; the front takes from the span,
which is closed, since dissipation lets it give there only less than it takes; and no finite
list holds every relatum. -/
theorem enclosedQueue_saturated_binds (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (bound : ChangeBound 0 B n c a) (joins : 0 < a T) : (enclosedQueue n c a B).saturated.Binds :=
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally T).symm)) with
  | ⟨x, _, comes⟩ =>
    have comes := mark_pos.mp comes
    have stands : 0 < EnclosedQueue.level n c a B (T + 1) x := EnclosedQueue.place_pos.mp comes.2
    have gives : 0 < (enclosedQueue n c a B).flow.give T (Queue.gone c T) x :=
      Nat.lt_of_lt_of_le stands (Nat.le_of_eq (congrArg (EnclosedQueue.level n c a B (T + 1) x - ·)
        (EnclosedQueue.place_zero comes.1).symm))
    have closed := EnclosedQueue.closed (B := B) tally T
    have takes : 0 < total (EnclosedQueue.span n c a T)
        ((enclosedQueue n c a B).flow.take T (Queue.gone c T)) :=
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le gives (Nat.le_trans
          (le_total_of_mem (EnclosedQueue.within_span tally (.inr comes.2)))
          (Nat.le_add_right _ _)))
        (enclosedQueue_dissipative tally company bound _ T (EnclosedQueue.span_distinct T) closed _
          (.head _))
    fun
    | .dependent => ⟨T + 1, x, x, comes.2, trivial, stands⟩
    | .balanced => ⟨T, x, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
        (Nat.le_of_eq (same.trans (EnclosedQueue.place_zero comes.1))))⟩
    | .acting => ⟨T, _, x, .head _, gives⟩
    | .taking => match total_pos _ takes with
      | ⟨k, _, taken⟩ => ⟨T, _, k, .head _, taken⟩
    | .dissipative => ⟨_, T, _, EnclosedQueue.span_distinct T, closed, .head _, takes⟩
    | .embodied => ⟨T, x, comes⟩
    | .counted => fun ⟨all, _, every⟩ => beyond_not_mem all (every _)
    | .transmitting => ⟨T, x, _, x, ⟨.head _, gives,
        fun standing => comes.1 (EnclosedQueue.place_pos.mpr standing), stands⟩, trivial⟩

/-- **The steps under enclosure from some step on, where every premise binds, for every counted census**: nothing arises across a step at which
nothing is active (`active_of_coming_jointly`), change stays within a bound from the first step
(`enclosure_bounds_change_counted`), and something arises (`binds_arising_counted`). -/
theorem enclosed_binding_counting_sound (w : World)
    (within : w.Premised ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ w.Binds) :
    w.CountsHold fun n c a =>
      (∀ t, 0 < a t → 0 < n t) ∧ (∃ B, ChangeBound 0 B n c a) ∧ ∃ t, 0 < a t :=
  match within with
  | ⟨premised, ⟨_, enclosed⟩, binds⟩ => fun alive n c a census counted =>
    ⟨fun _ => counted.company fun _ _ comes => active_of_coming_jointly
        (premised _ (.tail _ (.head _))) (premised _ (.tail _ (.tail _ (.head _))))
        (Embodied.arising (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _
          (.head _))))))))
        census comes,
      ⟨_, (enclosure_bounds_change_counted census counted
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
        (premised _ (.tail _ (.head _)))
        (premised _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))) enclosed).from_zero⟩,
      binds_arising_counted (binds .embodied) alive n c a census counted⟩

/-- **The witnesses under enclosure from some step on, where every premise binds**: enclosed queues, saturated (`enclosedQueue_saturated_binds`). -/
theorem enclosed_binding_counting_witnessed :
    Witnessed (fun w x t => w.web.active t x)
      (fun w => w.Premised ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ w.Binds)
      fun n c a => (∀ t, 0 < a t → 0 < n t) ∧ (∃ B, ChangeBound 0 B n c a) ∧ ∃ t, 0 < a t :=
  fun n c a tally ⟨company, ⟨B, bound⟩, ⟨_, joins⟩⟩ =>
    ⟨(enclosedQueue n c a B).saturated, fun _ _ => inferInstance, _,
      ⟨(enclosedQueue_premised tally company bound).saturated
          fun t k => EnclosedQueue.level_le (n := n) (c := c) (a := a) (B := B) t k,
        ⟨0, fun t _ => enclosedQueue_enclosed tally t⟩,
        enclosedQueue_saturated_binds tally company bound joins⟩,
      enclosedQueue_census n c a B, Queue.counts tally⟩

/-- Under all eight premises, with every step from some step on enclosed, where every premise
binds the laws of counting are those under enclosure and that something arises: a property of
the counts holds of every census of every such world exactly when it holds of every tally in
which nothing arises across a step at which nothing is active, change stays within a bound
from the first step, and something arises. -/
theorem enclosed_binding_counting {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∀ t, 0 < a t → 0 < n t) → (∃ B, ChangeBound 0 B n c a) →
      (∃ t, 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Premised →
        (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → w.Binds → w.CensusMarksHold Q :=
  have table := census_table_marks_hold pointwise enclosed_binding_counting_sound
    enclosed_binding_counting_witnessed
  ⟨fun law w _ premised enclosed binds => table.mp (fun n c a tally ⟨company, bound, arises⟩ =>
      law n c a tally company bound arises) w ⟨premised, enclosed, binds⟩,
   fun law n c a tally company bound arises => table.mpr (fun w _ ⟨premised, enclosed, binds⟩ =>
      law w premised enclosed binds) n c a tally ⟨company, bound, arises⟩⟩

end World

/-! ## Counting in finite worlds where the premises of each selection bind -/

namespace RelayRing

/-- What a relay beside a ring takes from a place across a step: across `U`, the two units
place `1` stands at. -/
def taken (U t : Nat) : Nat → Nat
  | 0 => 0
  | 1 => mark (t = U) + mark (t = U)
  | _ + 2 => 0

/-- What it gives a place: across `U`, one unit to place `0`. -/
def given (U t : Nat) : Nat → Nat
  | 0 => mark (t = U)
  | _ + 1 => 0

/-- What the places stand at: place `1` at two up to `U`, place `0` at one after it, the
rest at nothing, whatever holds them. -/
def level (U t : Nat) : Nat → Nat
  | 0 => mark (U < t)
  | 1 => mark (t ≤ U) + mark (t ≤ U)
  | _ + 2 => 0

/-- `g` takes part at every step; across `U` it takes the two units place `1` stands at and
gives one to place `0`. -/
def flow {K : Nat} (U : Nat) (g : Fin K) : Flow (Fin K) (Fin K) where
  present _ := [g]
  take t _ i := taken U t i.val
  give t _ i := given U t i.val

variable (M : Nat)

/-- The place the relay gives to. -/
abbrev sink : Fin (Ring.size (M + 1)) := ⟨0, Nat.zero_lt_succ _⟩

/-- The place it takes from. -/
abbrev source : Fin (Ring.size (M + 1)) := ⟨1, Nat.succ_lt_succ (Nat.zero_lt_succ _)⟩

end RelayRing

namespace World

/-- A relay beside a ring: a queue seated round a ring of places, each place active while
held; across `U`, `g` hands one of the two units place `1` stands at on to place `0`, which
comes to stand, and the other is lost. Every place depends on every place, needing what it
stands at. -/
def relayRing (n c : Nat → Nat) (M U : Nat) (g : Fin (Ring.size (M + 1))) : World :=
  World.of (Fin (Ring.size (M + 1))) (RelayRing.flow U g) ((Ring.web n c (M + 1) fun t i => RelayRing.level U t i.val).saturated)

instance relayRing_decided (n c : Nat → Nat) (M U : Nat) (g : Fin (Ring.size (M + 1))) :
    ∀ t x, Decidable ((relayRing n c M U g).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c (M + 1) i t))

variable {n c : Nat → Nat} {M U : Nat} {g : Fin (Ring.size (M + 1))}

theorem relayRing_balanced (n c : Nat → Nat) (M U : Nat) (g : Fin (Ring.size (M + 1))) :
    (relayRing n c M U g).Balanced
  | t, ⟨0, _⟩ => RelayQueue.after U t
  | t, ⟨1, _⟩ => (Nat.add_add_add_comm (mark (t + 1 ≤ U)) (mark (t + 1 ≤ U)) (mark (t = U))
      (mark (t = U))).trans (congrArg (fun m => m + m) (RelayQueue.up_to U t))
  | _, ⟨_ + 2, _⟩ => rfl

/-- A relay beside a ring dissipates, whoever relays: across `U` it gives a closed family at
most one unit and takes at least two. -/
theorem relayRing_dissipative (n c : Nat → Nat) (M U : Nat) (g : Fin (Ring.size (M + 1))) :
    (relayRing n c M U g).Dissipative :=
  fun cs t distinct closed f present =>
    if now : t = U then
      have lost : 2 ≤ total cs ((relayRing n c M U g).flow.take t f) :=
        match Nat.lt_or_ge (total cs ((relayRing n c M U g).flow.take t f)) 2 with
        | .inr enough => enough
        | .inl short =>
          have two : (relayRing n c M U g).flow.take t f (RelayRing.source M) = 2 :=
            (congrArg (· + mark (t = U)) (mark_one now)).trans (congrArg (1 + ·) (mark_one now))
          absurd (closed f present (RelayRing.source M) fun mem => Nat.lt_irrefl _
              (Nat.lt_of_lt_of_le short (Nat.le_trans (Nat.le_of_eq two.symm)
                (le_total_of_mem mem)))).1
            (Nat.ne_of_gt (Nat.lt_of_lt_of_le Nat.zero_lt_two (Nat.le_of_eq two.symm)))
      Nat.le_trans (Nat.add_le_add (Nat.le_trans (total_le_at (a := RelayRing.sink M)
          (fun b gives => match b, gives with
            | ⟨0, _⟩, _ => rfl
            | ⟨_ + 1, _⟩, gives => absurd gives (Nat.lt_irrefl 0)) distinct)
          (mark_le_one _)) (sign_le_one _)) lost
    else gives_nothing (total_eq_zero fun x _ => match x with
      | ⟨0, _⟩ => mark_zero now
      | ⟨_ + 1, _⟩ => rfl)

/-- Where `g` is active across `U`, only active relata give and take there. -/
theorem relayRing_acts (active : (relayRing n c M U g).web.active U g) :
    (relayRing n c M U g).Acting ∧ (relayRing n c M U g).Taking :=
  have at_relay : ∀ {t : Nat}, 0 < mark (t = U) → (relayRing n c M U g).web.active t g :=
    fun moves => Eq.subst (motive := fun s => (relayRing n c M U g).web.active s g)
      (mark_pos.mp moves).symm active
  ⟨fun _ f x present gives => match f, present, x, gives with
    | _, .head _, ⟨0, _⟩, gives => at_relay gives
    | _, .head _, ⟨_ + 1, _⟩, gives => absurd gives (Nat.lt_irrefl 0)
    | _, .tail _ no, _, _ => (nomatch no),
   fun _ f x present takes => match f, present, x, takes with
    | _, .head _, ⟨1, _⟩, takes => ⟨match Nat.eq_zero_or_pos (mark (_ = U)) with
        | .inr moves => at_relay moves
        | .inl zero => absurd takes (Nat.lt_irrefl 0 ∘ fun pos => Nat.lt_of_lt_of_le pos
            (Nat.le_of_eq ((congrArg (· + _) zero).trans (congrArg (0 + ·) zero)))), trivial⟩
    | _, .head _, ⟨0, _⟩, takes => absurd takes (Nat.lt_irrefl 0)
    | _, .head _, ⟨_ + 2, _⟩, takes => absurd takes (Nat.lt_irrefl 0)
    | _, .tail _ no, _, _ => (nomatch no)⟩

/-- Every premise but embodiment and the census binds in a relay beside a ring, activity
needing support where `g` is active across `U`: `g` depends on place `1` standing at two,
gives to place `0` and takes from place `1`, the two closed across `U`; and place `0` comes
to stand, descending from `g`. -/
theorem relayRing_binds :
    ∀ p : Premise, p ≠ .embodied → p ≠ .counted →
      (p = .dependent → (relayRing n c M U g).web.active U g) → p.Binds (relayRing n c M U g)
  | .dependent, _, _, active => ⟨U, g, RelayRing.source M, active rfl, trivial,
      Nat.lt_of_lt_of_le (mark_pos.mpr (Nat.le_refl U)) (Nat.le_add_right _ _)⟩
  | .balanced, _, _, _ => ⟨U, RelayRing.sink M, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      (mark_pos.mpr (Nat.lt_succ_self U)) (Nat.le_of_eq (same.trans (mark_zero (Nat.lt_irrefl U)))))⟩
  | .acting, _, _, _ => ⟨U, g, RelayRing.sink M, .head _, mark_pos.mpr rfl⟩
  | .taking, _, _, _ => ⟨U, g, RelayRing.source M, .head _,
      Nat.lt_of_lt_of_le (mark_pos.mpr rfl) (Nat.le_add_right _ _)⟩
  | .dissipative, _, _, _ => ⟨[RelayRing.source M, RelayRing.sink M], U, g,
      ⟨fun mem => match mem with | .tail _ no => (nomatch no), fun no => (nomatch no), trivial⟩,
      fun _ _ x out => match x with
        | ⟨0, _⟩ => absurd (.tail _ (.head _)) out
        | ⟨1, _⟩ => absurd (.head _) out
        | ⟨_ + 2, _⟩ => ⟨rfl, rfl⟩,
      .head _, Nat.lt_of_lt_of_le (mark_pos.mpr rfl)
        (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))⟩
  | .embodied, other, _, _ => absurd rfl other
  | .counted, _, other, _ => absurd rfl other
  | .transmitting, _, _, _ => ⟨U, RelayRing.sink M, g, RelayRing.sink M,
      ⟨.head _, mark_pos.mpr rfl, fun pos => Nat.lt_irrefl U (mark_pos.mp pos),
       mark_pos.mpr (Nat.lt_succ_self U)⟩, trivial⟩

/-- So under each selection without embodiment and the census a relay beside a ring meets the
selection and each selected premise binds there, wherever `g` is active across `U` if activity needing support, only active
relata giving or only active relata taking is selected. -/
theorem relayRing_binding {S : Premise → Bool}
    (disembodied : S .embodied = false) (uncounted : S .counted = false)
    (active : S .dependent = true ∨ S .acting = true ∨ S .taking = true →
      (relayRing n c M U g).web.active U g) :
    ∀ p, S p = true → p.Holds (relayRing n c M U g) ∧ p.Binds (relayRing n c M U g) :=
  fun p selected =>
    have binds := relayRing_binds p
      (fun same => absurd (disembodied.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => absurd (uncounted.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => active (.inl (same ▸ selected)))
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (Ring.web n c (M + 1) fun t i => RelayRing.level U t i.val), binds⟩
    | .balanced, _ => ⟨relayRing_balanced n c M U g, binds⟩
    | .acting, selected => ⟨(relayRing_acts (active (.inr (.inl selected)))).1, binds⟩
    | .taking, selected => ⟨(relayRing_acts (active (.inr (.inr selected)))).2, binds⟩
    | .dissipative, _ => ⟨relayRing_dissipative n c M U g, binds⟩
    | .embodied, selected => nomatch disembodied.symm.trans selected
    | .counted, selected => nomatch uncounted.symm.trans selected
    | .transmitting, _ => ⟨⟨2, Flow.transmits_saturated (W := (Ring.web n c (M + 1) fun t i => RelayRing.level U t i.val)) _ fun _ x => match x with
        | ⟨0, _⟩ => Nat.le_succ_of_le (mark_le_one _)
        | ⟨1, _⟩ => Nat.add_le_add (mark_le_one _) (mark_le_one _)
        | ⟨_ + 2, _⟩ => Nat.zero_le 2⟩, binds⟩

end World

namespace LossyRing

variable (n c : Nat → Nat) (M U : Nat)

/-- What the front's place exchanges each way with a place across a step: one unit, across
`U`, with itself and with each place coming to be held. -/
def exchanged (t : Nat) (i : Fin (Ring.size M)) : Nat :=
  mark (t = U ∧ (i = Ring.seat M (Queue.gone c t) ∨ ComesToBe (Ring.holds n c M i) t))

/-- What it takes from a place beyond what it gives: one unit, across `U`, from itself. -/
def lost (t : Nat) (i : Fin (Ring.size M)) : Nat :=
  mark (t = U ∧ i = Ring.seat M (Queue.gone c t))

/-- The front's place takes part at every step. Across `U` it exchanges one unit each way
with itself and with each place coming to be held, and takes one unit more from itself. -/
def flow : Flow (Fin (Ring.size M)) (Fin (Ring.size M)) where
  present t := [Ring.seat M (Queue.gone c t)]
  take t _ i := exchanged n c M U t i + lost c M U t i
  give t _ i := exchanged n c M U t i

variable {n c M U}

/-- The front's place exchanges and loses only across `U`. -/
theorem moving {t : Nat} {i : Fin (Ring.size M)}
    (moves : 0 < exchanged n c M U t i + lost c M U t i) : t = U :=
  if now : t = U then now else absurd moves fun pos => Nat.lt_irrefl 0
    (Nat.lt_of_lt_of_le pos (Nat.le_of_eq ((congrArg (· + _) (mark_zero fun ⟨same, _⟩ =>
      now same)).trans ((Nat.zero_add _).trans (mark_zero fun ⟨same, _⟩ => now same)))))

end LossyRing

namespace World

/-- A lossy ring: a queue seated round a ring of places, each place standing exactly while it
is held; across `U` the front's place exchanges one unit each way with itself and with each
place coming to be held and loses one unit more, which no standing records. Every place
depends on every place, needing what it stands at. -/
def lossyRing (n c : Nat → Nat) (M U : Nat) : World :=
  World.of (Fin (Ring.size M)) (LossyRing.flow n c M U) ((Ring.web n c M (Ring.stands n c M)).saturated)

instance lossyRing_decided (n c : Nat → Nat) (M U : Nat) :
    ∀ t x, Decidable ((lossyRing n c M U).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c M i t))

variable {n c a : Nat → Nat} {M U T : Nat}

/-- A lossy ring dissipates, whatever its counts: the front's place takes from a closed
family what it gives there and, across `U`, one unit more, itself lying in the family. -/
theorem lossyRing_dissipative (n c : Nat → Nat) (M U : Nat) : (lossyRing n c M U).Dissipative :=
  fun cs t _ closed f present => match f, present with
    | _, .head _ =>
      have split : total cs ((lossyRing n c M U).flow.take t (Ring.seat M (Queue.gone c t))) =
          total cs (LossyRing.exchanged n c M U t) + total cs (LossyRing.lost c M U t) :=
        total_add _ _ cs
      if now : t = U then
        match Nat.eq_zero_or_pos (total cs (LossyRing.lost c M U t)) with
        | .inr pos => Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _)
            (Nat.le_trans (Nat.add_le_add_left pos _) (Nat.le_of_eq split.symm))
        | .inl zero =>
          have own : LossyRing.lost c M U t (Ring.seat M (Queue.gone c t)) = 1 :=
            mark_one ⟨now, rfl⟩
          absurd (closed _ (.head _) (Ring.seat M (Queue.gone c t)) fun mem => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_trans (Nat.le_of_eq own.symm)
                (Nat.le_trans (le_total_of_mem mem) (Nat.le_of_eq zero))))).1
            (Nat.ne_of_gt (Nat.lt_of_lt_of_le Nat.zero_lt_one
              (Nat.le_trans (Nat.le_of_eq own.symm) (Nat.le_add_left _ _))))
      else gives_nothing (total_eq_zero fun _ _ => mark_zero fun ⟨same, _⟩ => now same)
    | _, .tail _ no => (nomatch no)

/-- Where the queue is not empty at `U`, only active relata take in a lossy ring. -/
theorem lossyRing_taking (occupied : 0 < n U) : (lossyRing n c M U).Taking :=
  fun _ f _ present takes => match f, present, takes with
    | _, .head _, takes => ⟨Ring.front_holds (Nat.lt_of_lt_of_le occupied
        (Nat.le_of_eq (congrArg n (LossyRing.moving takes).symm))), trivial⟩
    | _, .tail _ no, _ => (nomatch no)

/-- And only active relata give. -/
theorem lossyRing_acting (occupied : 0 < n U) : (lossyRing n c M U).Acting :=
  fun _ f _ present gives => match f, present, gives with
    | _, .head _, gives => Ring.front_holds (Nat.lt_of_lt_of_le occupied
        (Nat.le_of_eq (congrArg n (LossyRing.moving (Nat.lt_of_lt_of_le gives
          (Nat.le_add_right _ _))).symm)))
    | _, .tail _ no, _ => (nomatch no)

/-- Where at most `M` are in the queue at each step and something joins across `T`, every
premise but the census binds in a lossy ring, bounded transmission where moreover `T` is `U`:
a place coming to be held across `T` arises, changing its standing, after `T` active and
depending on its own standing; the front's place gives to itself across `U` and takes more
from itself, the family of all places closed; and where `T` is `U` the place coming to be
held descends from the front's. -/
theorem lossyRing_binds (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (joins : 0 < a T) :
    ∀ p : Premise, p ≠ .counted → (p = .transmitting → T = U) → p.Binds (lossyRing n c M U) :=
  have own : 0 < LossyRing.exchanged n c M U U (Ring.seat M (Queue.gone c U)) :=
    mark_pos.mpr ⟨rfl, .inl rfl⟩
  match total_pos _ (Nat.lt_of_lt_of_le joins
      (Nat.le_of_eq (Ring.counts tally bounded T).2.2.symm)), places_listed (Ring.size M) with
  | ⟨i, _, comes⟩, ⟨all, distinct, every⟩ =>
    have comes := mark_pos.mp comes
    fun
    | .dependent, _, _ => ⟨T + 1, i, i, comes.2, trivial, mark_pos.mpr comes.2⟩
    | .balanced, _, _ => ⟨T, i, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
        (mark_pos.mpr comes.2) (Nat.le_of_eq (same.trans (mark_zero comes.1))))⟩
    | .acting, _, _ => ⟨U, _, Ring.seat M (Queue.gone c U), .head _, own⟩
    | .taking, _, _ => ⟨U, _, Ring.seat M (Queue.gone c U), .head _,
        Nat.lt_of_lt_of_le own (Nat.le_add_right _ _)⟩
    | .dissipative, _, _ => ⟨all, U, _, distinct, fun _ _ x out => absurd (every x) out, .head _,
        Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le own (Nat.le_add_right _ _))
          (le_total_of_mem (q := (lossyRing n c M U).flow.take U (Ring.seat M (Queue.gone c U)))
            (every (Ring.seat M (Queue.gone c U))))⟩
    | .embodied, _, _ => ⟨T, i, comes⟩
    | .counted, other, _ => absurd rfl other
    | .transmitting, _, route => ⟨T, i, _, i, ⟨.head _, mark_pos.mpr ⟨route rfl, .inr comes⟩,
        fun standing => comes.1 (mark_pos.mp standing), mark_pos.mpr comes.2⟩, trivial⟩

/-- So under each selection without balance and the census, where at most `M` are in the
queue at each step and something joins across `T`, a lossy ring meets the selection and each
selected premise binds there, given what binding needs: the queue not empty at `U` where only
active relata giving or only active relata taking is selected, and `T` being `U` where
bounded transmission is. -/
theorem lossyRing_binding (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (joins : 0 < a T)
    {S : Premise → Bool} (unbalanced : S .balanced = false) (uncounted : S .counted = false)
    (occupied : S .acting = true ∨ S .taking = true → 0 < n U)
    (descends : S .transmitting = true → T = U) :
    ∀ p, S p = true → p.Holds (lossyRing n c M U) ∧ p.Binds (lossyRing n c M U) :=
  fun p selected =>
    have binds := lossyRing_binds tally bounded joins p
      (fun same => absurd (uncounted.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => descends (same ▸ selected))
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (Ring.web n c M (Ring.stands n c M)), binds⟩
    | .balanced, selected => nomatch unbalanced.symm.trans selected
    | .acting, selected => ⟨lossyRing_acting (occupied (.inl selected)), binds⟩
    | .taking, selected => ⟨lossyRing_taking (occupied (.inr selected)), binds⟩
    | .dissipative, _ => ⟨lossyRing_dissipative n c M U, binds⟩
    | .embodied, _ => ⟨fun _ _ => mark_pos.symm, binds⟩
    | .counted, selected => nomatch uncounted.symm.trans selected
    | .transmitting, _ => ⟨⟨1, Flow.transmits_saturated (W := (Ring.web n c M (Ring.stands n c M))) _ fun _ _ => mark_le_one _⟩, binds⟩

end World

namespace Ring

variable (n c : Nat → Nat) (M : Nat)

/-- What the front's place exchanges each way with a place across a step besides what the
place's standing loses or gains: one unit, across `V`, with itself. -/
def exchanged (V t : Nat) (i : Fin (size M)) : Nat :=
  mark (t = V ∧ i = seat M (Queue.gone c t))

/-- The ring's flow with, across `V`, one unit more each way between the front's place and
itself. -/
def exchanging (V : Nat) : Flow (Fin (size M)) (Fin (size M)) where
  present t := [seat M (Queue.gone c t)]
  take t f i := (flow n c M).take t f i + exchanged c M V t i
  give t f i := (flow n c M).give t f i + exchanged c M V t i

end Ring

namespace World

/-- An exchanging ring: a queue seated round a ring of places, each standing exactly while it
is held; the front's place takes what each place's standing loses and gives what it gains,
and across `V` exchanges one unit more each way with itself. Every place depends on every
place, needing what it stands at. -/
def exchangingRing (n c : Nat → Nat) (M V : Nat) : World :=
  World.of (Fin (Ring.size M)) (Ring.exchanging n c M V) ((Ring.web n c M (Ring.stands n c M)).saturated)

instance exchangingRing_decided (n c : Nat → Nat) (M V : Nat) :
    ∀ t x, Decidable ((exchangingRing n c M V).web.active t x) :=
  fun t i => inferInstanceAs (Decidable (Ring.holds n c M i t))

variable {n c a : Nat → Nat} {M T V : Nat}

theorem exchangingRing_balanced (n c : Nat → Nat) (M V : Nat) :
    (exchangingRing n c M V).Balanced :=
  fun t i => add_sub_turn_add (Ring.stands n c M t i) (Ring.stands n c M (t + 1) i) _

/-- Where the queue is not empty at `V`, only active relata take in an exchanging ring. -/
theorem exchangingRing_taking (occupied : 0 < n V) : (exchangingRing n c M V).Taking :=
  fun t f i present takes => match f, present, takes with
    | _, .head _, takes => ⟨Ring.front_holds (match Nat.eq_zero_or_pos
          (Ring.exchanged c M V t i) with
        | .inr exchanges => Nat.lt_of_lt_of_le occupied (Nat.le_of_eq (congrArg n
            (mark_pos.mp exchanges).1.symm))
        | .inl zero => Ring.occupied (Ring.taken_held (f := Ring.seat M (Queue.gone c t)) (Nat.lt_of_lt_of_le takes
            (Nat.le_of_eq (congrArg (_ + ·) zero))))), trivial⟩
    | _, .tail _ no, _ => (nomatch no)

/-- Where moreover nothing joins an empty queue, only active relata give. -/
theorem exchangingRing_acting (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (occupied : 0 < n V) : (exchangingRing n c M V).Acting :=
  fun t f i present gives => match f, present, gives with
    | _, .head _, gives => Ring.front_holds (match Nat.eq_zero_or_pos
          (Ring.exchanged c M V t i), Nat.eq_zero_or_pos (n t) with
        | .inr exchanges, _ => Nat.lt_of_lt_of_le occupied (Nat.le_of_eq (congrArg n
            (mark_pos.mp exchanges).1.symm))
        | .inl _, .inr pos => pos
        | .inl zero, .inl empty => absurd (Ring.occupied (Ring.given_held (f := Ring.seat M (Queue.gone c t))
            (Nat.lt_of_lt_of_le gives
            (Nat.le_of_eq (congrArg (_ + ·) zero))))) fun pos => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                (EnclosedQueue.empty_stays tally (company t) empty))))
    | _, .tail _ no, _ => (nomatch no)

/-- Where at most `M` are in the queue at each step and something joins across `T`, every
premise but dissipation and the census binds in a ring exchanging across the next step: a
place coming to be held across `T` arises, changing its standing, and descends from the
front's place, after `T` active and depending on its own standing; and across the next step
the front's place takes from itself. -/
theorem exchangingRing_binds (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (joins : 0 < a T) :
    ∀ p : Premise, p ≠ .dissipative → p ≠ .counted → p.Binds (exchangingRing n c M (T + 1)) :=
  match total_pos _ (Nat.lt_of_lt_of_le joins
      (Nat.le_of_eq (Ring.counts tally bounded T).2.2.symm)) with
  | ⟨i, _, comes⟩ =>
    have comes := mark_pos.mp comes
    have gives : 0 < (exchangingRing n c M (T + 1)).flow.give T (Ring.seat M (Queue.gone c T)) i :=
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (mark_pos.mpr comes.2) (Nat.le_of_eq
          (congrArg (Ring.stands n c M (T + 1) i - ·) (mark_zero comes.1)).symm))
        (Nat.le_add_right _ _)
    fun
    | .dependent, _, _ => ⟨T + 1, i, i, comes.2, trivial, mark_pos.mpr comes.2⟩
    | .balanced, _, _ => ⟨T, i, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
        (mark_pos.mpr comes.2) (Nat.le_of_eq (same.trans (mark_zero comes.1))))⟩
    | .acting, _, _ => ⟨T, _, i, .head _, gives⟩
    | .taking, _, _ => ⟨T + 1, _, Ring.seat M (Queue.gone c (T + 1)), .head _,
        Nat.lt_of_lt_of_le (mark_pos.mpr ⟨rfl, rfl⟩) (Nat.le_add_left _ _)⟩
    | .dissipative, other, _ => absurd rfl other
    | .embodied, _, _ => ⟨T, i, comes⟩
    | .counted, _, other => absurd rfl other
    | .transmitting, _, _ => ⟨T, i, _, i, ⟨.head _, gives,
        fun standing => comes.1 (mark_pos.mp standing), mark_pos.mpr comes.2⟩, trivial⟩

/-- So under each selection without dissipation and the census, where at most `M` are in
the queue at each step and something joins across `T`, a ring exchanging across the next
step meets the selection and each selected premise binds there, where nothing joins an empty
queue if only active relata giving is selected. -/
theorem exchangingRing_binding (tally : Tally n c a) (bounded : ∀ t, n t ≤ M) (joins : 0 < a T)
    {S : Premise → Bool} (dissipating : S .dissipative = false) (uncounted : S .counted = false)
    (giving : S .acting = true → ∀ t, 0 < a t → 0 < n t) :
    ∀ p, S p = true →
      p.Holds (exchangingRing n c M (T + 1)) ∧ p.Binds (exchangingRing n c M (T + 1)) :=
  fun p selected =>
    have binds := exchangingRing_binds tally bounded joins p
      (fun same => absurd (dissipating.symm.trans (same ▸ selected)) Bool.noConfusion)
      (fun same => absurd (uncounted.symm.trans (same ▸ selected)) Bool.noConfusion)
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (Ring.web n c M (Ring.stands n c M)), binds⟩
    | .balanced, _ => ⟨exchangingRing_balanced n c M (T + 1), binds⟩
    | .acting, selected => ⟨exchangingRing_acting tally (giving selected) (tally.after_pos joins),
        binds⟩
    | .taking, _ => ⟨exchangingRing_taking (tally.after_pos joins), binds⟩
    | .dissipative, selected => nomatch dissipating.symm.trans selected
    | .embodied, _ => ⟨fun _ _ => mark_pos.symm, binds⟩
    | .counted, selected => nomatch uncounted.symm.trans selected
    | .transmitting, _ => ⟨⟨1, Flow.transmits_saturated (W := (Ring.web n c M (Ring.stands n c M))) _ fun _ _ => mark_le_one _⟩, binds⟩

instance (S : Premise → Bool) : Decidable (BoundsChange S) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

/-- No finite world binds the census, so under each selection with the census every property
of the counts is a law in finite worlds where the selected premises bind. -/
theorem finite_binding_census {S : Premise → Bool} (counted : S .counted = true)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} :
    ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold Q :=
  fun _ _ _ finite binds => absurd finite (binds _ counted)

/-- **The steps in finite worlds where the premises of each selection without the census bind,
for every counted census**: the counts are bounded (`Finite.census_bounded`); nothing arises
across a step at which nothing is active (`active_of_coming_jointly`,
`active_of_coming_enclosed`); change stays within a bound (`enclosure_bounds_change_counted`);
and the three binding steps of `binding_counting_under_sound`, the last with only active relata
giving or, in a finite world, with only active relata taking and dissipation
(`Finite.acting`). -/
theorem finite_binding_counting_under_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w) :
    w.CountsHold fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ B, ChangeBound 0 B n c a) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true ∨ S .taking = true ∧ S .dissipative = true →
          S .transmitting = true → ∃ t, 0 < n t ∧ 0 < a t) :=
  match within with
  | ⟨meets, finite, binds⟩ => fun alive n c a census counted =>
    ⟨match finite.census_bounded with
      | ⟨M, bounded⟩ => ⟨M, fun t => Nat.le_trans (Nat.le_of_eq (counted t).1)
          (bounded alive census t)⟩,
     fun selected _ => counted.company fun _ _ comes => match selected with
      | .inl ⟨balanced, embodied, .inl acting⟩ => active_of_coming_jointly (meets _ balanced)
          (meets _ acting) (Embodied.arising (meets _ embodied)) census comes
      | .inl ⟨balanced, embodied, .inr ⟨_, dissipative⟩⟩ | .inr ⟨balanced, embodied, dissipative⟩ =>
          active_of_coming_enclosed (meets _ balanced) (meets _ dissipative) (meets _ embodied)
            census (finite.enclosed _) comes,
     fun ⟨balanced, embodied, dissipative⟩ => ⟨_, enclosure_bounds_change_counted census counted
      (meets _ embodied) (meets _ balanced) (meets _ dissipative) fun t _ => finite.enclosed t⟩,
     counted.acts_of_binding meets binds census,
     fun embodied => binds_arising_counted (binds _ embodied) alive n c a census counted,
     fun embodied giving transmitting =>
      have acting : w.Acting := match giving with
        | .inl acting => meets _ acting
        | .inr ⟨taking, dissipative⟩ => finite.acting (meets _ taking) (meets _ dissipative)
      counted.joint_of_binding (meets _ embodied) acting (binds _ transmitting) census⟩

/-- **The witnesses in finite worlds where the premises of each selection without the census
bind**: a relay beside a ring where embodiment is not selected; where it is, a finite queue,
saturated, where balance and dissipation are, an exchanging ring where dissipation is not and
balance or only active relata giving is not, and lossy rings where balance is not. -/
theorem finite_binding_counting_under_witnessed (S : Premise → Bool)
    (uncounted : S .counted = false) :
    Witnessed (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w)
      fun n c a => (∃ M, ∀ t, n t ≤ M) ∧
        (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ B, ChangeBound 0 B n c a) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true ∨ S .taking = true ∧ S .dissipative = true →
          S .transmitting = true → ∃ t, 0 < n t ∧ 0 < a t) :=
  fun n c a tally ⟨⟨M, bounded⟩, quiet, bounds, acts, arises, joint⟩ =>
    have within : ∀ {w : World}, w.Finite → (∀ p, S p = true → p.Holds w ∧ p.Binds w) →
        w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w := fun finite binding =>
      ⟨fun p selected => (binding p selected).1, finite, fun p selected => (binding p selected).2⟩
    have wider : ∀ t, n t ≤ M + 1 := fun t => Nat.le_succ_of_le (bounded t)
    have relayed : S .embodied = false → ∀ U g, (S .dependent = true ∨ S .acting = true ∨
        S .taking = true → (relayRing n c M U g).web.active U g) →
        WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w) n c a :=
      fun disembodied U g active => ⟨relayRing n c M U g, fun _ _ => inferInstance, _,
        within (places_listed _) (relayRing_binding disembodied uncounted active),
        Ring.census wider fun t i => RelayRing.level U t i.val, Ring.counts tally wider⟩
    match he : S .embodied with
    | false => match hp : S .dependent, ha : S .acting, ht : S .taking with
      | false, false, false => relayed he 0 (RelayRing.sink M) fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected
      | true, _, _ => match acts (.inl hp) with
        | ⟨U, occupied⟩ => relayed he U (Ring.seat (M + 1) (Queue.gone c U)) fun _ =>
            Ring.front_holds occupied
      | false, true, _ => match acts (.inr (.inl ha)) with
        | ⟨U, occupied⟩ => relayed he U (Ring.seat (M + 1) (Queue.gone c U)) fun _ =>
            Ring.front_holds occupied
      | false, false, true => match acts (.inr (.inr ht)) with
        | ⟨U, occupied⟩ => relayed he U (Ring.seat (M + 1) (Queue.gone c U)) fun _ =>
            Ring.front_holds occupied
    | true => match arises he with
      | ⟨T, joins⟩ =>
        have exchanging : S .dissipative = false → (S .acting = true → ∀ t, 0 < a t → 0 < n t) →
            WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w) n c a := fun dissipating giving =>
          ⟨exchangingRing n c M (T + 1), fun _ _ => inferInstance, _,
           within (places_listed _)
            (exchangingRing_binding tally bounded joins dissipating uncounted giving),
           Ring.census bounded (Ring.stands n c M), Ring.counts tally bounded⟩
        have lossy : ∀ J U, 0 < a J → S .balanced = false →
            (S .acting = true ∨ S .taking = true → 0 < n U) → (S .transmitting = true → J = U) →
            WitnessedAt (fun w x t => w.web.active t x) (fun w => w.Meets S ∧ w.Finite ∧ ∀ p, S p = true → p.Binds w) n c a := fun _ U joins unbalanced occupied descends =>
          ⟨lossyRing n c M U, fun _ _ => inferInstance, _, within (places_listed _)
            (lossyRing_binding tally bounded joins unbalanced uncounted occupied descends),
           Ring.census bounded (Ring.stands n c M), Ring.counts tally bounded⟩
        match hb : S .balanced, hd : S .dissipative, ha : S .acting, ht : S .taking,
            hr : S .transmitting with
        | true, true, _, _, _ => match bounds ⟨hb, he, hd⟩ with
          | ⟨B, bound⟩ =>
            have company := quiet (.inr ⟨hb, he, hd⟩)
            ⟨(finiteQueue n c a B).saturated, fun _ _ => inferInstance, _,
             ⟨((finiteQueue_premised tally company bound).saturated
                fun t i => EnclosedQueue.level_le (n := n) (c := c) (a := a) (B := B) t i.val).meets S,
              finiteQueue_finite n c a B,
              fun p selected => finiteQueue_saturated_binds tally company bound joins p
                fun same => absurd (uncounted.symm.trans (same ▸ selected)) Bool.noConfusion⟩,
             finiteQueue_census n c a B, finiteQueue_counts tally bound⟩
        | true, false, _, _, _ => exchanging hd fun acting => quiet (.inl ⟨hb, he, .inl acting⟩)
        | false, false, false, _, _ => exchanging hd fun selected => nomatch ha.symm.trans selected
        | false, _, true, _, true => match joint he (.inl ha) hr with
          | ⟨U, occupied, here⟩ => lossy U U here hb (fun _ => occupied) fun _ => rfl
        | false, true, false, true, true => match joint he (.inr ⟨ht, hd⟩) hr with
          | ⟨U, occupied, here⟩ => lossy U U here hb (fun _ => occupied) fun _ => rfl
        | false, _, true, _, false => lossy T (T + 1) joins hb (fun _ => tally.after_pos joins)
            fun selected => nomatch hr.symm.trans selected
        | false, true, false, true, false => lossy T (T + 1) joins hb
            (fun _ => tally.after_pos joins) fun selected => nomatch hr.symm.trans selected
        | false, true, false, false, _ => lossy T T joins hb (fun
            | .inl selected => nomatch ha.symm.trans selected
            | .inr selected => nomatch ht.symm.trans selected) fun _ => rfl

/-- The laws of counting in finite worlds where the premises of each selection without the
census bind. A property of the counts holds of every census of every finite world meeting
the selection in which each selected premise binds exactly when it holds of every tally
meeting the laws of `finite_counting_under` and three more: something is active, where
activity needing support, only active relata giving or only active relata taking is
selected; something arises, where embodiment is; and something arises across a step at which
something is active, where embodiment and bounded transmission are with only active relata
giving or with both only active relata taking and dissipation, which in a finite world give
only active relata giving (`Finite.acting`). -/
theorem finite_binding_counting_under (S : Premise → Bool) (uncounted : S .counted = false)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (∃ M, ∀ t, n t ≤ M) →
      (BindsCounting S ∨ BoundsChange S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ B, ChangeBound 0 B n c a) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true ∨ S .taking = true ∧ S .dissipative = true →
        S .transmitting = true → ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
        (∀ p, S p = true → p.Binds w) → w.CensusMarksHold Q :=
  have table := census_table_marks_hold pointwise (finite_binding_counting_under_sound S)
    (finite_binding_counting_under_witnessed S uncounted)
  ⟨fun law w _ meets finite binds => table.mp (fun n c a tally ⟨bounded, quiet, bounds, acts, arises, joint⟩ =>
      law n c a tally bounded quiet bounds acts arises joint) w ⟨meets, finite, binds⟩,
   fun law n c a tally bounded quiet bounds acts arises joint => table.mpr (fun w _ ⟨meets, finite, binds⟩ =>
      law w meets finite binds) n c a tally ⟨bounded, quiet, bounds, acts, arises, joint⟩⟩

/-- So in finite worlds where the premises of a selection without the census bind, something
is active exactly where activity needing support, only active relata giving, only active
relata taking or embodiment is selected. -/
theorem finite_binding_activity_iff (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  have pointwise : Pointwise fun n (_ _ : Nat → Nat) => ∃ t, 0 < n t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩
  ⟨fun law => match hp : S .dependent, ha : S .acting, ht : S .taking, he : S .embodied with
    | true, _, _, _ => .inl rfl
    | false, true, _, _ => .inr (.inl rfl)
    | false, false, true, _ => .inr (.inr (.inl rfl))
    | false, false, false, true => .inr (.inr (.inr rfl))
    | false, false, false, false => match (finite_binding_counting_under S uncounted
          pointwise).mpr law (fun _ => 0) (fun _ => 0) (fun _ => 0) (fun _ => ⟨0, rfl, rfl⟩)
        ⟨0, fun _ => Nat.le_refl 0⟩ (fun _ _ no => absurd no (Nat.lt_irrefl 0))
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun selected => (finite_binding_counting_under S uncounted pointwise).mp
    fun _ _ _ tally _ _ _ acts arises _ => match selected with
    | .inl dependent => acts (.inl dependent)
    | .inr (.inl acting) => acts (.inr (.inl acting))
    | .inr (.inr (.inl taking)) => acts (.inr (.inr taking))
    | .inr (.inr (.inr embodied)) => match arises embodied with
      | ⟨t, joins⟩ => ⟨t + 1, tally.after_pos joins⟩⟩

/-- Something arises exactly where embodiment is selected. -/
theorem finite_binding_arising_iff (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun _ _ a => ∃ t, 0 < a t) ↔
      S .embodied = true :=
  have pointwise : Pointwise fun (_ _ : Nat → Nat) a => ∃ t, 0 < a t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | true => rfl
    | false => match (finite_binding_counting_under S uncounted pointwise).mpr law (fun _ => 1)
        (fun _ => 0) (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩) ⟨1, fun _ => Nat.le_refl 1⟩
        (fun _ _ _ => Nat.zero_lt_one)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun embodied => (finite_binding_counting_under S uncounted pointwise).mp
     fun _ _ _ _ _ _ _ _ arises _ => arises embodied⟩

/-- And something arises across a step at which something is active exactly where embodiment
is selected and either the selection binds counting or bounds change, or bounded transmission
is selected with only active relata giving or with both only active relata taking and
dissipation: there what arises descends from a relatum active at the step. -/
theorem finite_binding_joint_iff (S : Premise → Bool) (uncounted : S .counted = false) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S → w.Finite →
      (∀ p, S p = true → p.Binds w) → w.CensusMarksHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ BoundsChange S ∨
        (S .acting = true ∨ S .taking = true ∧ S .dissipative = true) ∧
          S .transmitting = true) :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∃ t, 0 < n t ∧ 0 < a t :=
    fun same ⟨t, active, arising⟩ => ⟨t, Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
      Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | false => match (finite_binding_counting_under S uncounted pointwise).mpr law (fun _ => 1)
        (fun _ => 0) (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩) ⟨1, fun _ => Nat.le_refl 1⟩
        (fun _ _ _ => Nat.zero_lt_one)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, _, no⟩ => absurd no (Nat.lt_irrefl 0)
    | true => if both : BindsCounting S ∨ BoundsChange S ∨
          (S .acting = true ∨ S .taking = true ∧ S .dissipative = true) ∧
            S .transmitting = true then ⟨rfl, both⟩
      else match (finite_binding_counting_under S uncounted pointwise).mpr law Queue.lone
          (fun _ => 0) Queue.joins Queue.lone_tally
          ⟨1, fun | 0 => Nat.zero_le 1 | _ + 1 => Nat.le_refl 1⟩
          (fun bound => absurd (match bound with
            | .inl binds => .inl binds
            | .inr bounds => .inr (.inl bounds)) both)
          (fun bounds => absurd (.inr (.inl bounds)) both) (fun _ => ⟨1, Nat.zero_lt_one⟩)
          (fun _ => ⟨0, Nat.zero_lt_one⟩)
          (fun _ giving transmitting => absurd (.inr (.inr ⟨giving, transmitting⟩)) both) with
        | ⟨0, empty, _⟩ => absurd empty (Nat.lt_irrefl 0)
        | ⟨_ + 1, _, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun ⟨embodied, both⟩ => (finite_binding_counting_under S uncounted pointwise).mp
    fun _ _ _ _ _ quiet _ _ arises joint => match both with
    | .inl binds => match arises embodied with
      | ⟨t, joins⟩ => ⟨t, quiet (.inl binds) t joins, joins⟩
    | .inr (.inl bounds) => match arises embodied with
      | ⟨t, joins⟩ => ⟨t, quiet (.inr bounds) t joins, joins⟩
    | .inr (.inr ⟨giving, transmitting⟩) => joint embodied giving transmitting⟩

end World

/-! ## Counting under enclosure where the premises of each selection bind -/

namespace World

variable {n c a : Nat → Nat} {U T : Nat} {g : OpenQueue.Relatum} {gift : Nat → Nat}

/-- A relay beside a queue is enclosed at every step: what it takes and gives lies within the
two ground relata it relays between. -/
theorem relayQueue_enclosed (n c : Nat → Nat) (U : Nat) (g : OpenQueue.Relatum) (t : Nat) :
    (relayQueue n c U g).flow.Enclosed t :=
  ⟨[.ground 0, .ground 1], ⟨(fun mem => nomatch mem), (fun mem => nomatch mem), trivial⟩,
   fun _ _ x out => match x with
    | .ground 0 => absurd (.head _) out
    | .ground 1 => absurd (.tail _ (.head _)) out
    | .ground (_ + 2) => ⟨rfl, rfl⟩
    | .member _ => ⟨rfl, rfl⟩⟩

/-- Across each step at which the ground relatum gives nothing, a lossy queue not empty at `U`
is enclosed by the members in the queue before or after the step. -/
theorem lossyQueue_enclosed (tally : Tally n c a) (occupied : 0 < n U) {t : Nat}
    (still : gift t = 0) : (lossyQueue n c U gift).flow.Enclosed t :=
  have within : ∀ k, t = U → (k = Queue.gone c t ∨ ComesToBe (Queue.holds n c k) t) →
      OpenQueue.Relatum.member k ∈ (EnclosedQueue.span n c a t).map .member :=
    fun _ now which => mem_map_of (EnclosedQueue.within_span tally (match which with
      | .inl front => .inl (front ▸ OpenQueue.front.mpr (now ▸ occupied))
      | .inr comes => .inr comes.2))
  ⟨(EnclosedQueue.span n c a t).map .member,
   distinct_map OpenQueue.member_inj (EnclosedQueue.span_distinct t),
   fun f present x out => match f, present, x with
    | _, .head _, .member k =>
      have exchanged : LossyQueue.exchanged n c U t (.member k) = 0 :=
        mark_zero fun ⟨now, which⟩ => out (within k now which)
      have lost : LossyQueue.lost c U t (.member k) = 0 :=
        mark_zero fun ⟨now, front⟩ => out (within k now (.inl front))
      ⟨(congrArg (· + _) exchanged).trans ((Nat.zero_add _).trans lost), exchanged⟩
    | _, .head _, .ground _ => ⟨rfl, rfl⟩
    | _, .tail _ (.head _), _ => ⟨rfl, still⟩
    | _, .tail _ (.tail _ no), _ => (nomatch no)⟩

end World

namespace EnclosedQueue

variable (n c a : Nat → Nat) (B V : Nat)

/-- What the front exchanges each way with a member across a step besides what the member's
standing loses or gains: one unit, across `V`, with itself. -/
def exchanged (t k : Nat) : Nat :=
  mark (t = V ∧ k = Queue.gone c t)

/-- The enclosed queue's flow with, across `V`, one unit more each way between the front and
itself. -/
def exchanging : Flow Nat Nat where
  present t := [Queue.gone c t]
  take t f k := (flow n c a B).take t f k + exchanged c V t k
  give t f k := (flow n c a B).give t f k + exchanged c V t k

end EnclosedQueue

namespace World

/-- An exchanging queue: members stand by their place in the queue, the front holding the
store; the front takes what each member's standing loses and gives what it gains, and across
`V` exchanges one unit more each way with itself. Every relatum depends on every relatum,
needing what it stands at. -/
def exchangingQueue (n c a : Nat → Nat) (B V : Nat) : World :=
  World.of Nat (EnclosedQueue.exchanging n c a B V) ((EnclosedQueue.web n c a B).saturated)

instance exchangingQueue_decided (n c a : Nat → Nat) (B V : Nat) :
    ∀ t x, Decidable ((exchangingQueue n c a B V).web.active t x) :=
  enclosedQueue_decided n c a B

variable {B V : Nat}

theorem exchangingQueue_balanced (n c a : Nat → Nat) (B V : Nat) :
    (exchangingQueue n c a B V).Balanced :=
  fun t k => add_sub_turn_add (EnclosedQueue.level n c a B t k)
    (EnclosedQueue.level n c a B (t + 1) k) _

/-- Where the queue is not empty at `V`, only active relata take in an exchanging queue. -/
theorem exchangingQueue_taking (occupied : 0 < n V) : (exchangingQueue n c a B V).Taking :=
  fun t f k present takes => match f, present, takes with
    | _, .head _, takes => match Nat.eq_zero_or_pos (EnclosedQueue.exchanged c V t k) with
      | .inr exchanges => ⟨OpenQueue.front.mpr ((mark_pos.mp exchanges).1 ▸ occupied), trivial⟩
      | .inl zero => enclosedQueue_taking n c a B t _ k (.head _)
          (Nat.lt_of_lt_of_le takes (Nat.le_of_eq (congrArg (_ + ·) zero)))
    | _, .tail _ no, _ => (nomatch no)

/-- Where moreover nothing joins an empty queue, only active relata give. -/
theorem exchangingQueue_acting (tally : Tally n c a) (company : ∀ t, 0 < a t → 0 < n t)
    (occupied : 0 < n V) : (exchangingQueue n c a B V).Acting :=
  fun t f k present gives => match f, present, gives with
    | _, .head _, gives => match Nat.eq_zero_or_pos (EnclosedQueue.exchanged c V t k) with
      | .inr exchanges => OpenQueue.front.mpr ((mark_pos.mp exchanges).1 ▸ occupied)
      | .inl zero => enclosedQueue_acting (B := B) tally company t _ k (.head _)
          (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (congrArg (_ + ·) zero)))
    | _, .tail _ no, _ => (nomatch no)

/-- Where the queue is not empty at `V`, every step of an exchanging queue is enclosed by its
span. -/
theorem exchangingQueue_enclosed (tally : Tally n c a) (occupied : 0 < n V) (t : Nat) :
    (exchangingQueue n c a B V).flow.Enclosed t :=
  ⟨EnclosedQueue.span n c a t, EnclosedQueue.span_distinct t, fun f present k out =>
    have exchanged : EnclosedQueue.exchanged c V t k = 0 := mark_zero fun ⟨now, front⟩ =>
      out (EnclosedQueue.within_span tally (.inl (front ▸ OpenQueue.front.mpr (now ▸ occupied))))
    match EnclosedQueue.closed (B := B) tally t f present k out with
    | ⟨takes, gives⟩ => ⟨(congrArg (· + _) takes).trans ((Nat.zero_add _).trans exchanged),
        (congrArg (· + _) gives).trans ((Nat.zero_add _).trans exchanged)⟩⟩

/-- Where something joins across `T`, every premise but dissipation binds in a queue
exchanging across the next step: a member joining across `T` arises, changing its standing,
and descends from the front, after `T` active and depending on its own standing; across the
next step the front takes from itself; and no finite list holds every relatum. -/
theorem exchangingQueue_binds (tally : Tally n c a) (joins : 0 < a T) :
    ∀ p : Premise, p ≠ .dissipative → p.Binds (exchangingQueue n c a B (T + 1)) :=
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally T).symm)) with
  | ⟨x, _, comes⟩ =>
    have comes := mark_pos.mp comes
    have stands : 0 < EnclosedQueue.level n c a B (T + 1) x := EnclosedQueue.place_pos.mp comes.2
    have gives : 0 < (exchangingQueue n c a B (T + 1)).flow.give T (Queue.gone c T) x :=
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le stands (Nat.le_of_eq
          (congrArg (EnclosedQueue.level n c a B (T + 1) x - ·)
            (EnclosedQueue.place_zero comes.1).symm))) (Nat.le_add_right _ _)
    fun
    | .dependent, _ => ⟨T + 1, x, x, comes.2, trivial, stands⟩
    | .balanced, _ => ⟨T, x, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
        (Nat.le_of_eq (same.trans (EnclosedQueue.place_zero comes.1))))⟩
    | .acting, _ => ⟨T, _, x, .head _, gives⟩
    | .taking, _ => ⟨T + 1, _, Queue.gone c (T + 1), .head _,
        Nat.lt_of_lt_of_le (mark_pos.mpr ⟨rfl, rfl⟩) (Nat.le_add_left _ _)⟩
    | .dissipative, other => absurd rfl other
    | .embodied, _ => ⟨T, x, comes⟩
    | .counted, _ => fun ⟨all, _, every⟩ => beyond_not_mem all (every _)
    | .transmitting, _ => ⟨T, x, _, x, ⟨.head _, gives,
        fun standing => comes.1 (EnclosedQueue.place_pos.mpr standing), stands⟩, trivial⟩

/-- So under each selection without dissipation, where something joins across `T`, a queue
exchanging across the next step meets the selection and each selected premise binds there,
where nothing joins an empty queue if only active relata giving is selected. -/
theorem exchangingQueue_binding (tally : Tally n c a) (joins : 0 < a T) {S : Premise → Bool}
    (dissipating : S .dissipative = false) (giving : S .acting = true → ∀ t, 0 < a t → 0 < n t) :
    ∀ p, S p = true →
      p.Holds (exchangingQueue n c a B (T + 1)) ∧ p.Binds (exchangingQueue n c a B (T + 1)) :=
  fun p selected =>
    have binds := exchangingQueue_binds (B := B) tally joins p
      (fun same => absurd (dissipating.symm.trans (same ▸ selected)) Bool.noConfusion)
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (EnclosedQueue.web n c a B), binds⟩
    | .balanced, _ => ⟨exchangingQueue_balanced n c a B (T + 1), binds⟩
    | .acting, selected => ⟨exchangingQueue_acting tally (giving selected) (tally.after_pos joins),
        binds⟩
    | .taking, _ => ⟨exchangingQueue_taking (tally.after_pos joins), binds⟩
    | .dissipative, selected => nomatch dissipating.symm.trans selected
    | .embodied, _ => ⟨fun _ _ => EnclosedQueue.place_pos, binds⟩
    | .counted, _ => ⟨⟨_, Queue.listed⟩, binds⟩
    | .transmitting, _ => ⟨⟨1 + B, Flow.transmits_saturated (W := EnclosedQueue.web n c a B) _ fun t k =>
        EnclosedQueue.level_le (n := n) (c := c) (a := a) (B := B) t k⟩, binds⟩

end World

/-- Below a step at which a count is positive lies a last such step. -/
theorem last_positive {n : Nat → Nat} : ∀ m, (∃ s, s < m ∧ 0 < n s) →
    ∃ s, s < m ∧ 0 < n s ∧ ∀ u, s < u → u < m → n u = 0
  | 0, ⟨_, lt, _⟩ => absurd lt (Nat.not_lt_zero _)
  | m + 1, ⟨s, lt, pos⟩ => match Nat.eq_zero_or_pos (n m) with
    | .inr occupied => ⟨m, Nat.lt_succ_self m, occupied, fun _ gt lt =>
        absurd lt (Nat.not_lt_of_le gt)⟩
    | .inl empty =>
      have below : s < m := match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ lt) with
        | .inl same => absurd (Nat.lt_of_lt_of_le pos
            (Nat.le_of_eq ((congrArg n same).trans empty))) (Nat.lt_irrefl 0)
        | .inr below => below
      match last_positive m ⟨s, below, pos⟩ with
      | ⟨r, lt, pos, rest⟩ => ⟨r, Nat.lt_succ_of_lt lt, pos, fun u gt within =>
          match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ within) with
          | .inl same => (congrArg n same).trans empty
          | .inr lt => rest u gt lt⟩

namespace Tally

variable {n c a : Nat → Nat}

/-- Where from `T` on nothing arises across a step at which nothing is active, and something
arises across some step, there is a step at which something is active from which on nothing
arises across a step at which nothing is active: `T` if something is active there; if not,
the step at which something arises if it is not before `T`, or else the last step before `T`
at which something is active. -/
theorem occupied_from (tally : Tally n c a) {T J : Nat}
    (company : ∀ t, T ≤ t → 0 < a t → 0 < n t) (joins : 0 < a J) :
    ∃ T', 0 < n T' ∧ ∀ t, T' ≤ t → 0 < a t → 0 < n t :=
  match Nat.eq_zero_or_pos (n T), Nat.lt_or_ge J T with
  | .inr occupied, _ => ⟨T, occupied, company⟩
  | .inl _, .inr later => ⟨J, company J later joins, fun t le => company t (Nat.le_trans later le)⟩
  | .inl empty, .inl early =>
    have none : ∀ {u}, u = T → ¬ 0 < n u := fun same pos =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq ((congrArg n same).trans empty)))
    have after : J + 1 < T := match Nat.eq_or_lt_of_le early with
      | .inl same => absurd (tally.after_pos joins) (none same)
      | .inr lt => lt
    match last_positive T ⟨J + 1, after, tally.after_pos joins⟩ with
    | ⟨s, _, occupied, rest⟩ => ⟨s, occupied, fun t le arising => match Nat.lt_or_ge t T with
      | .inr later => company t later arising
      | .inl below => match Nat.eq_or_lt_of_le le with
        | .inl same => Nat.lt_of_lt_of_le occupied (Nat.le_of_eq (congrArg n same))
        | .inr gt => absurd (tally.after_pos arising) (match Nat.eq_or_lt_of_le below with
          | .inl same => none same
          | .inr lt => fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
              (rest (t + 1) (Nat.lt_succ_of_lt gt) lt))))⟩

end Tally

namespace EnclosedQueue

variable (n c a : Nat → Nat) (B T : Nat)

/-- The unit the front stands at across `T` beyond its place: one, at `T`, at the front. -/
def spare (t k : Nat) : Nat :=
  mark (t = T ∧ k = Queue.gone c t)

/-- Members stand by their place in the queue, and the front at `T` one unit more. -/
def held (t k : Nat) : Nat :=
  level n c a B t k + spare c T t k

/-- Members stand by what they hold and are active exactly while in the queue. -/
def sheddingWeb : Web Nat Nat :=
  { web n c a B with level := held n c a B T }

/-- The front takes part at every step. It takes from each member what that member's
standing loses across the step and gives each what it gains, and before `T` exchanges one
unit each way with every relatum. -/
def shedding : Flow Nat Nat where
  present t := [Queue.gone c t]
  take t _ k := held n c a B T t k - held n c a B T (t + 1) k + mark (t < T)
  give t _ k := held n c a B T (t + 1) k - held n c a B T t k + mark (t < T)

variable {n c a : Nat → Nat} {B T : Nat}

/-- Taking more away leaves no more. -/
theorem sub_add_le (B k : Nat) : ∀ m, B - (k + m) ≤ B - k
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (Nat.pred_le _) (sub_add_le B k m)

/-- The store never grows. -/
theorem store_succ_le (t : Nat) : store c a B (t + 1) ≤ store c a B t :=
  sub_add_le B _ _

/-- Off the step `T` nothing is spare. -/
theorem spare_zero {t k : Nat} (other : t ≠ T) : spare c T t k = 0 :=
  mark_zero fun ⟨same, _⟩ => other same

/-- From `T` on, what lies outside the span stands at nothing before and after the step. -/
theorem held_outside (tally : Tally n c a) (occupied : 0 < n T) {t k : Nat} (later : T ≤ t)
    (out : ¬ k ∈ span n c a t) : held n c a B T t k = 0 ∧ held n c a B T (t + 1) k = 0 :=
  ⟨(congrArg (· + _) (place_zero fun now => out (within_span tally (.inl now)))).trans
      ((Nat.zero_add _).trans (mark_zero fun ⟨now, front⟩ => out (within_span tally
        (.inl (front ▸ OpenQueue.front.mpr (now ▸ occupied)))))),
   (congrArg (· + _) (place_zero fun next => out (within_span tally (.inr next)))).trans
      ((Nat.zero_add _).trans (spare_zero fun same => Nat.lt_irrefl t
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self t) (Nat.le_trans (Nat.le_of_eq same) later))))⟩

/-- Every step from `T` on is enclosed by its span. -/
theorem shedding_closed (tally : Tally n c a) (occupied : 0 < n T) {t : Nat} (later : T ≤ t) :
    (shedding n c a B T).ClosedAt (span n c a t) t :=
  fun _ _ _ out =>
    have opened : mark (t < T) = 0 := mark_zero (Nat.not_lt_of_le later)
    match held_outside (B := B) tally occupied later out with
    | ⟨now, next⟩ =>
      ⟨(congrArg (· + _) ((congrArg (· - _) now).trans (Nat.zero_sub _))).trans
          ((Nat.zero_add _).trans opened),
       (congrArg (· + _) ((congrArg (· - _) next).trans (Nat.zero_sub _))).trans
          ((Nat.zero_add _).trans opened)⟩

/-- After `T` the flow is the enclosed queue's. -/
theorem shedding_flows {t : Nat} (later : T < t) (f k : Nat) :
    (shedding n c a B T).take t f k = (flow n c a B).take t f k ∧
      (shedding n c a B T).give t f k = (flow n c a B).give t f k :=
  have now : spare c T t k = 0 := spare_zero fun same =>
    Nat.lt_irrefl T (Nat.lt_of_lt_of_le later (Nat.le_of_eq same))
  have next : spare c T (t + 1) k = 0 := spare_zero fun same =>
    Nat.lt_irrefl T (Nat.lt_of_lt_of_le (Nat.lt_succ_of_lt later) (Nat.le_of_eq same))
  have opened : mark (t < T) = 0 := mark_zero (Nat.not_lt_of_le (Nat.le_of_lt later))
  have held_now : held n c a B T t k = level n c a B t k := (congrArg (_ + ·) now).trans rfl
  have held_next : held n c a B T (t + 1) k = level n c a B (t + 1) k :=
    (congrArg (_ + ·) next).trans rfl
  ⟨(congrArg (· + _) ((congrArg (· - held n c a B T (t + 1) k) held_now).trans
      (congrArg (level n c a B t k - ·) held_next))).trans (congrArg (_ + ·) opened),
   (congrArg (· + _) ((congrArg (· - held n c a B T t k) held_next).trans
      (congrArg (level n c a B (t + 1) k - ·) held_now))).trans (congrArg (_ + ·) opened)⟩

end EnclosedQueue

namespace World

/-- A shedding queue: an enclosed queue closing at `T`, whose front stands one unit more at
`T` and sheds it across `T`; before `T` every relatum also exchanges one unit each way with
the front. Every relatum depends on every relatum, needing what it stands at. -/
def sheddingQueue (n c a : Nat → Nat) (B T : Nat) : World :=
  World.of Nat (EnclosedQueue.shedding n c a B T) ((EnclosedQueue.sheddingWeb n c a B T).saturated)

instance sheddingQueue_decided (n c a : Nat → Nat) (B T : Nat) :
    ∀ t x, Decidable ((sheddingQueue n c a B T).web.active t x) :=
  enclosedQueue_decided n c a B

variable {n c a : Nat → Nat} {B T : Nat}

theorem sheddingQueue_balanced (n c a : Nat → Nat) (B T : Nat) :
    (sheddingQueue n c a B T).Balanced :=
  fun t k => add_sub_turn_add (EnclosedQueue.held n c a B T t k)
    (EnclosedQueue.held n c a B T (t + 1) k) _

/-- Where the queue is not empty at `T`, a shedding queue is embodied. -/
theorem sheddingQueue_embodied (occupied : 0 < n T) : (sheddingQueue n c a B T).Embodied :=
  fun k t => ⟨fun holds => Nat.lt_of_lt_of_le (EnclosedQueue.place_pos.mp holds)
      (Nat.le_add_right _ _),
    fun stands => match Nat.eq_zero_or_pos (EnclosedQueue.spare c T t k) with
      | .inl nothing => EnclosedQueue.place_pos.mpr (Nat.lt_of_lt_of_le stands
          (Nat.le_of_eq ((congrArg (_ + ·) nothing).trans rfl)))
      | .inr spare => match mark_pos.mp spare with
        | ⟨now, front⟩ => front ▸ OpenQueue.front.mpr (now ▸ occupied)⟩

/-- Every step from `T` on is enclosed. -/
theorem sheddingQueue_enclosed (tally : Tally n c a) (occupied : 0 < n T) {t : Nat}
    (later : T ≤ t) : (sheddingQueue n c a B T).flow.Enclosed t :=
  ⟨EnclosedQueue.span n c a t, EnclosedQueue.span_distinct t,
    EnclosedQueue.shedding_closed tally occupied later⟩

end World

namespace World

variable {n c a : Nat → Nat} {B T J : Nat}

/-- No member of a shedding queue stands at more than its place and the spare unit. -/
theorem sheddingQueue_level_le (t k : Nat) : (sheddingQueue n c a B T).web.level t k ≤ 1 + B + 1 :=
  Nat.add_le_add (EnclosedQueue.level_le (n := n) (c := c) (a := a) (B := B) t k) (mark_le_one _)

/-- Across `T`, with the queue not empty and within its store before and after the step, the
front takes from the span more than it gives there: the span stands at the store and the
spare unit before the step, and at no more than the store after it. -/
theorem sheddingQueue_exceeds (tally : Tally n c a) (occupied : 0 < n T)
    (fits : n T ≤ EnclosedQueue.store c a B T)
    (fits' : n (T + 1) ≤ EnclosedQueue.store c a B (T + 1)) :
    total (EnclosedQueue.span n c a T)
        ((sheddingQueue n c a B T).flow.give T (Queue.gone c T)) + 1 ≤
      total (EnclosedQueue.span n c a T)
        ((sheddingQueue n c a B T).flow.take T (Queue.gone c T)) :=
  have census := enclosedQueue_census n c a B
  have standing := standingCensus census (enclosedQueue_embodied n c a B)
  have before := standing.stock_eq (EnclosedQueue.span_distinct T) fun k mem =>
    EnclosedQueue.within_span tally (.inl (((census T).2 k).mpr mem))
  have after := standing.stock_eq (t := T + 1) (EnclosedQueue.span_distinct T) fun k mem =>
    EnclosedQueue.within_span tally (.inr (((census (T + 1)).2 k).mpr mem))
  have kept : total (EnclosedQueue.span n c a T) (EnclosedQueue.level n c a B (T + 1)) ≤
      total (EnclosedQueue.span n c a T) (EnclosedQueue.level n c a B T) :=
    Nat.le_trans (Nat.le_of_eq after.symm) (Nat.le_trans (enclosedQueue_stock fits').1
      (Nat.le_trans (EnclosedQueue.store_succ_le T)
        (Nat.le_of_eq (((enclosedQueue_stock fits).2 occupied).symm.trans before))))
  have one : EnclosedQueue.spare c T T (Queue.gone c T) = 1 := mark_one ⟨rfl, rfl⟩
  have spared : 1 ≤ total (EnclosedQueue.span n c a T) (EnclosedQueue.spare c T T) :=
    Nat.le_trans (Nat.le_of_eq one.symm)
      (le_total_of_mem (EnclosedQueue.within_span tally (.inl (OpenQueue.front.mpr occupied))))
  have shed : total (EnclosedQueue.span n c a T) (EnclosedQueue.spare c T (T + 1)) = 0 :=
    total_eq_zero fun _ _ => EnclosedQueue.spare_zero fun same =>
      Nat.lt_irrefl T (Nat.lt_of_lt_of_le (Nat.lt_succ_self T) (Nat.le_of_eq same))
  have lowered : (sheddingQueue n c a B T).web.stock (EnclosedQueue.span n c a T) (T + 1) + 1 ≤
      (sheddingQueue n c a B T).web.stock (EnclosedQueue.span n c a T) T :=
    Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) ((total_add (EnclosedQueue.level n c a B (T + 1))
        (EnclosedQueue.spare c T (T + 1)) (EnclosedQueue.span n c a T)).trans
          ((congrArg (_ + ·) shed).trans (Nat.add_zero _)))))
      (Nat.le_trans (Nat.add_le_add kept spared) (Nat.le_of_eq (total_add
        (EnclosedQueue.level n c a B T) (EnclosedQueue.spare c T T)
          (EnclosedQueue.span n c a T)).symm))
  have over := (sheddingQueue_balanced n c a B T).over (EnclosedQueue.span n c a T) T
  le_of_add_le_add_right _ (Nat.le_trans (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
    (congrArg (_ + ·) (Nat.add_comm _ _)))) (Nat.le_trans (Nat.add_le_add_left lowered _)
      (Nat.le_of_eq ((Nat.add_comm _ _).trans (over.symm.trans (Nat.add_comm _ _))))))

/-- Under a change bound from the first step, with nothing joining an empty queue from `T` on
and the queue not empty at `T`, a shedding queue dissipates: before `T` no family is closed;
across `T` the front sheds its spare unit; and after `T` it dissipates as the enclosed queue
does. -/
theorem sheddingQueue_dissipative (tally : Tally n c a) (bound : ChangeBound 0 B n c a)
    (company : ∀ t, T ≤ t → 0 < a t → 0 < n t) (occupied : 0 < n T) :
    (sheddingQueue n c a B T).Dissipative :=
  have fits : ∀ t, n t ≤ EnclosedQueue.store c a B t := fun t =>
    RelationalRenewal.le_sub_from_add (bound t (Nat.zero_le t))
  have sheds : ∀ {cs : List Nat}, Distinct cs →
      (EnclosedQueue.shedding n c a B T).ClosedAt cs T →
        (EnclosedQueue.shedding n c a B T).DissipatesOn cs T :=
    fun {cs} distinct closed f present => match f, present with
    | _, .head _ =>
      have spanned := EnclosedQueue.shedding_closed (B := B) tally occupied (Nat.le_refl T)
      Nat.le_trans (Nat.add_le_add (total_le_of_support distinct fun k _ gives =>
          match decideMem k (EnclosedQueue.span n c a T) with
          | .isTrue mem => mem
          | .isFalse out => absurd gives (fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos
              (Nat.le_of_eq (spanned _ (.head _) k out).2))))
          (sign_le_one _))
        (Nat.le_trans (sheddingQueue_exceeds tally occupied (fits T) (fits (T + 1)))
          (total_le_of_support (EnclosedQueue.span_distinct T) fun k _ takes =>
            match decideMem k cs with
            | .isTrue mem => mem
            | .isFalse out => absurd takes (fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos
                (Nat.le_of_eq (closed _ (.head _) k out).1)))))
    | _, .tail _ no => (nomatch no)
  fun cs t distinct closed f present => match Nat.lt_or_ge t T with
  | .inl early => absurd (closed f present (beyond cs) (beyond_not_mem cs)).2
      fun nothing => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (mark_pos.mpr early) (Nat.le_add_left _ _)) (Nat.le_of_eq nothing))
  | .inr later => match Nat.eq_or_lt_of_le later with
    | .inl same => Eq.rec (motive := fun s _ => (EnclosedQueue.shedding n c a B T).ClosedAt cs s →
        (EnclosedQueue.shedding n c a B T).DissipatesOn cs s) (sheds distinct) same closed f present
    | .inr after =>
      have takes : total cs ((sheddingQueue n c a B T).flow.take t f) =
          total cs ((EnclosedQueue.flow n c a B).take t f) :=
        total_congr (fun k => (EnclosedQueue.shedding_flows after f k).1) cs
      have gives : total cs ((sheddingQueue n c a B T).flow.give t f) =
          total cs ((EnclosedQueue.flow n c a B).give t f) :=
        total_congr (fun k => (EnclosedQueue.shedding_flows after f k).2) cs
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) gives).trans
          (congrArg (fun u => _ + sign u) takes)))
        (Nat.le_trans (enclosedQueue_dissipatesOn tally (company t later) (fits t) (fits (t + 1))
            distinct (fun g present k out => match closed g present k out with
              | ⟨took, gave⟩ => ⟨(EnclosedQueue.shedding_flows after g k).1.symm.trans took,
                  (EnclosedQueue.shedding_flows after g k).2.symm.trans gave⟩) f present)
          (Nat.le_of_eq takes.symm))

/-- Under a change bound from the first step, with the queue not empty at `T` and something
joining across `J`, every premise binds in a shedding queue: a member joining across `J`
arises, changing its standing, and descends from the front, after `J` active and depending on
its own standing; across `T` the front takes from the span, which is closed; and no finite
list holds every relatum. -/
theorem sheddingQueue_binds (tally : Tally n c a) (bound : ChangeBound 0 B n c a)
    (occupied : 0 < n T) (joins : 0 < a J) : (sheddingQueue n c a B T).Binds :=
  match total_pos _ (Nat.lt_of_lt_of_le joins (Nat.le_of_eq (Queue.comings_eq tally J).symm)) with
  | ⟨x, _, comes⟩ =>
    have comes := mark_pos.mp comes
    have stands : 0 < EnclosedQueue.held n c a B T (J + 1) x :=
      Nat.lt_of_lt_of_le (EnclosedQueue.place_pos.mp comes.2) (Nat.le_add_right _ _)
    have absent : EnclosedQueue.held n c a B T J x = 0 := eq_zero_of_not_pos fun standing =>
      comes.1 ((sheddingQueue_embodied (B := B) occupied x J).mpr standing)
    have gives : 0 < (sheddingQueue n c a B T).flow.give J (Queue.gone c J) x :=
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le stands (Nat.le_of_eq
          (congrArg (EnclosedQueue.held n c a B T (J + 1) x - ·) absent).symm))
        (Nat.le_add_right _ _)
    have takes := Nat.lt_of_lt_of_le (Nat.zero_lt_succ _) (sheddingQueue_exceeds tally occupied
      (RelationalRenewal.le_sub_from_add (bound T (Nat.zero_le T)))
      (RelationalRenewal.le_sub_from_add (bound (T + 1) (Nat.zero_le _))))
    fun
    | .dependent => ⟨J + 1, x, x, comes.2, trivial, stands⟩
    | .balanced => ⟨J, x, fun same => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
        (Nat.le_of_eq (same.trans absent)))⟩
    | .acting => ⟨J, _, x, .head _, gives⟩
    | .taking => match total_pos _ takes with
      | ⟨k, _, taken⟩ => ⟨T, _, k, .head _, taken⟩
    | .dissipative => ⟨_, T, _, EnclosedQueue.span_distinct T,
        EnclosedQueue.shedding_closed tally occupied (Nat.le_refl T), .head _, takes⟩
    | .embodied => ⟨J, x, comes⟩
    | .counted => fun ⟨all, _, every⟩ => beyond_not_mem all (every _)
    | .transmitting => ⟨J, x, _, x, ⟨.head _, gives, fun standing => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le standing (Nat.le_of_eq absent)), stands⟩, trivial⟩

/-- So under each selection without only active relata giving and without only active
relata taking, a shedding queue meets the selection and each selected premise binds there,
under a change bound from the first step, with nothing joining an empty queue from `T` on, the
queue not empty at `T` and something joining across some step. -/
theorem sheddingQueue_binding (tally : Tally n c a) (bound : ChangeBound 0 B n c a)
    (company : ∀ t, T ≤ t → 0 < a t → 0 < n t) (occupied : 0 < n T) (joins : 0 < a J)
    {S : Premise → Bool} (giving : S .acting = false) (taking : S .taking = false) :
    ∀ p, S p = true → p.Holds (sheddingQueue n c a B T) ∧ p.Binds (sheddingQueue n c a B T) :=
  fun p selected =>
    have binds := sheddingQueue_binds tally bound occupied joins p
    match p, selected with
    | .dependent, _ => ⟨Web.saturated_dependent (EnclosedQueue.sheddingWeb n c a B T), binds⟩
    | .balanced, _ => ⟨sheddingQueue_balanced n c a B T, binds⟩
    | .acting, selected => nomatch giving.symm.trans selected
    | .taking, selected => nomatch taking.symm.trans selected
    | .dissipative, _ => ⟨sheddingQueue_dissipative tally bound company occupied, binds⟩
    | .embodied, _ => ⟨sheddingQueue_embodied occupied, binds⟩
    | .counted, _ => ⟨⟨_, Queue.listed⟩, binds⟩
    | .transmitting, _ => ⟨⟨1 + B + 1, Flow.transmits_saturated _ sheddingQueue_level_le⟩, binds⟩

end World

namespace World

/-- **The steps in worlds enclosed from some step on where the premises of each selection
bind, for every counted census**: those of `binding_counting_under_sound`, with change within a
bound and nothing arising across a step at which nothing is active from the step on which
enclosure holds (`enclosure_bounds_change_counted`, `active_of_coming_enclosed`). -/
theorem enclosed_binding_counting_under_sound (S : Premise → Bool) (w : World)
    (within : w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w) :
    w.CountsHold fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true → S .transmitting = true →
          ∃ t, 0 < n t ∧ 0 < a t) :=
  match within with
  | ⟨meets, ⟨T, enclosed⟩, binds⟩ => fun alive n c a census counted =>
    ⟨fun bindsCounting => counted.company_binding meets bindsCounting census,
     fun ⟨balanced, embodied, dissipative⟩ => ⟨T, _, enclosure_bounds_change_counted census
      counted (meets _ embodied) (meets _ balanced) (meets _ dissipative) enclosed,
      fun t later => counted.company fun _ _ comes => active_of_coming_enclosed
        (meets _ balanced) (meets _ dissipative) (meets _ embodied) census (enclosed t later)
        comes⟩,
     counted.acts_of_binding meets binds census,
     fun embodied => binds_arising_counted (binds _ embodied) alive n c a census counted,
     fun embodied acting transmitting => counted.joint_of_binding (meets _ embodied)
      (meets _ acting) (binds _ transmitting) census⟩

/-- **The witnesses in worlds enclosed from some step on where the premises of each selection
bind**: a relay queue where embodiment is not selected; where it is and balance is, an
exchanging queue without dissipation, an enclosed queue, saturated, with only active relata
giving or taking, and a shedding queue with neither; lossy queues where balance is not. -/
theorem enclosed_binding_counting_under_witnessed (S : Premise → Bool) :
    Witnessed (fun w x t => w.web.active t x)
      (fun w => w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w)
      fun n c a => (BindsCounting S → ∀ t, 0 < a t → 0 < n t) ∧
        (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) ∧
        (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) ∧
        (S .embodied = true → ∃ t, 0 < a t) ∧
        (S .embodied = true → S .acting = true → S .transmitting = true →
          ∃ t, 0 < n t ∧ 0 < a t) :=
  fun n c a tally ⟨quiet, bounded, acts, arises, joint⟩ =>
    have within : ∀ {w : World}, (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) →
        (∀ p, S p = true → p.Holds w ∧ p.Binds w) →
        w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w :=
      fun enclosed binding => ⟨fun p selected => (binding p selected).1, enclosed,
        fun p selected => (binding p selected).2⟩
    have relayed : S .embodied = false → ∀ U g, (S .dependent = true ∨ S .acting = true ∨
        S .taking = true → (relayQueue n c U g).web.active U g) →
        WitnessedAt (fun w x t => w.web.active t x)
          (fun w => w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w) n c a :=
      fun disembodied U g active => ⟨relayQueue n c U g, fun _ _ => inferInstance, _,
        within ⟨0, fun t _ => relayQueue_enclosed n c _ _ t⟩
          (relayQueue_binding disembodied active), openQueue_census n c, openQueue_counts tally⟩
    have lossy : ∀ (T U E : Nat) (gift : Nat → Nat), 0 < a T → 0 < n U → gift U = 0 →
        (∀ t, E ≤ t → gift t = 0) → S .balanced = false →
        (S .acting = true → ∀ t, gift t = 0) →
        (S .transmitting = true → T = U ∨ 0 < gift T) →
        WitnessedAt (fun w x t => w.web.active t x)
          (fun w => w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w) n c a :=
      fun _ _ _ _ joins occupied shut still unbalanced giving descends =>
        ⟨_, fun _ _ => inferInstance, _,
         within ⟨_, fun _ later => lossyQueue_enclosed tally occupied (still _ later)⟩
          (lossyQueue_binding tally occupied joins shut unbalanced giving descends),
         openQueue_census n c, openQueue_counts tally⟩
    match he : S .embodied with
    | false => match hp : S .dependent, ha : S .acting, ht : S .taking with
      | false, false, false => relayed he 0 (.ground 1) fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected
      | true, _, _ => match acts (.inl hp) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
      | false, true, _ => match acts (.inr (.inl ha)) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
      | false, false, true => match acts (.inr (.inr ht)) with
        | ⟨U, occupied⟩ => relayed he U (.member (Queue.gone c U)) fun _ =>
            OpenQueue.front.mpr occupied
    | true => match arises he with
      | ⟨T, joins⟩ =>
        have saturated : S .balanced = true → S .dissipative = true →
            (∀ t, 0 < a t → 0 < n t) → WitnessedAt (fun w x t => w.web.active t x)
          (fun w => w.Meets S ∧ (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) ∧ ∀ p, S p = true → p.Binds w) n c a := fun hb hd company =>
          match changeBound_iff_zero.mp (match bounded ⟨hb, he, hd⟩ with
            | ⟨T, B, bound, _⟩ => ⟨T, B, bound⟩) with
          | ⟨B, bound⟩ => ⟨(enclosedQueue n c a B).saturated, fun _ _ => inferInstance, _,
              within ⟨0, fun t _ => enclosedQueue_enclosed tally t⟩
                (fun p selected => ⟨((enclosedQueue_premised tally company bound).saturated
                    fun t k => EnclosedQueue.level_le (n := n) (c := c) (a := a) t k).meets S p
                      selected,
                  enclosedQueue_saturated_binds tally company bound joins p⟩),
              enclosedQueue_census n c a B, Queue.counts tally⟩
        match hb : S .balanced, hd : S .dissipative, ha : S .acting, ht : S .taking,
            hr : S .transmitting with
        | true, false, _, _, _ => ⟨_, fun _ _ => inferInstance, _,
            within ⟨0, fun t _ => exchangingQueue_enclosed tally (tally.after_pos joins) t⟩
              (exchangingQueue_binding (B := 0) tally joins hd fun selected =>
                quiet ⟨hb, he, .inl selected⟩), Queue.listed, Queue.counts tally⟩
        | true, true, true, _, _ => saturated hb hd (quiet ⟨hb, he, .inl ha⟩)
        | true, true, false, true, _ => saturated hb hd (quiet ⟨hb, he, .inr ⟨ht, hd⟩⟩)
        | true, true, false, false, _ => match bounded ⟨hb, he, hd⟩ with
          | ⟨_, _, bound, company⟩ => match tally.occupied_from company joins with
            | ⟨_, occupied, company⟩ => ⟨_, fun _ _ => inferInstance, _,
                within ⟨_, fun _ later => sheddingQueue_enclosed tally occupied later⟩
                  (sheddingQueue_binding tally bound.from_zero company occupied joins ha ht),
                Queue.listed, Queue.counts tally⟩
        | false, _, true, _, true => match joint he ha hr with
          | ⟨U, occupied, here⟩ => lossy U U 0 (fun _ => 0) here occupied rfl (fun _ _ => rfl)
              hb (fun _ _ => rfl) fun _ => .inl rfl
        | false, _, true, _, false => lossy T (T + 1) 0 (fun _ => 0) joins (tally.after_pos joins)
            rfl (fun _ _ => rfl) hb (fun _ _ => rfl)
            fun selected => nomatch hr.symm.trans selected
        | false, _, false, _, _ => lossy T (T + 1) (T + 1) (fun t => mark (t = T)) joins
            (tally.after_pos joins) (mark_zero (Nat.succ_ne_self T))
            (fun _ later => mark_zero fun same =>
              Nat.not_succ_le_self T (Nat.le_trans later (Nat.le_of_eq same)))
            hb (fun selected => nomatch ha.symm.trans selected)
            fun _ => .inr (mark_pos.mpr rfl)

/-- The laws of counting in worlds enclosed from some step on where the premises of each
selection bind. A property of the counts holds of every census of every such world meeting a
selection in which each selected premise binds exactly when it holds of every tally meeting
the laws of `enclosed_counting_under` and the three of `binding_counting_under`: under
enclosure from some step on, enclosure and binding add their laws each on its own. Where the
selection bounds change without only active relata giving or taking, dissipation binds at a
closed step only where something stands to be lost, so the witness sheds a spare unit at a
step at which something is active, from which on nothing arises across a step at which
nothing is active (`Tally.occupied_from`). -/
theorem enclosed_binding_counting_under (S : Premise → Bool)
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q) :
    (∀ n c a, Tally n c a → (BindsCounting S → ∀ t, 0 < a t → 0 < n t) →
      (BoundsChange S → ∃ T B, ChangeBound T B n c a ∧ ∀ t, T ≤ t → 0 < a t → 0 < n t) →
      (S .dependent = true ∨ S .acting = true ∨ S .taking = true → ∃ t, 0 < n t) →
      (S .embodied = true → ∃ t, 0 < a t) →
      (S .embodied = true → S .acting = true → S .transmitting = true →
        ∃ t, 0 < n t ∧ 0 < a t) → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
        (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → (∀ p, S p = true → p.Binds w) →
          w.CensusMarksHold Q :=
  have table := census_table_marks_hold pointwise (enclosed_binding_counting_under_sound S)
    (enclosed_binding_counting_under_witnessed S)
  ⟨fun law w _ meets enclosed binds => table.mp (fun n c a tally ⟨quiet, bounded, acts, arises, joint⟩ =>
      law n c a tally quiet bounded acts arises joint) w ⟨meets, enclosed, binds⟩,
   fun law n c a tally quiet bounded acts arises joint => table.mpr (fun w _ ⟨meets, enclosed, binds⟩ =>
      law w meets enclosed binds) n c a tally ⟨quiet, bounded, acts, arises, joint⟩⟩

/-- So in worlds enclosed from some step on where the premises of a selection bind, something
is active exactly where activity needing support, only active relata giving, only active
relata taking or embodiment is selected. -/
theorem enclosed_binding_activity_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → (∀ p, S p = true → p.Binds w) →
        w.CensusMarksHold fun n _ _ => ∃ t, 0 < n t) ↔
      S .dependent = true ∨ S .acting = true ∨ S .taking = true ∨ S .embodied = true :=
  have pointwise : Pointwise fun n (_ _ : Nat → Nat) => ∃ t, 0 < n t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).1)⟩
  ⟨fun law => match hp : S .dependent, ha : S .acting, ht : S .taking, he : S .embodied with
    | true, _, _, _ => .inl rfl
    | false, true, _, _ => .inr (.inl rfl)
    | false, false, true, _ => .inr (.inr (.inl rfl))
    | false, false, false, true => .inr (.inr (.inr rfl))
    | false, false, false, false => match (enclosed_binding_counting_under S pointwise).mpr law
        (fun _ => 0) (fun _ => 0) (fun _ => 0) (fun _ => ⟨0, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun
          | .inl selected => nomatch hp.symm.trans selected
          | .inr (.inl selected) => nomatch ha.symm.trans selected
          | .inr (.inr selected) => nomatch ht.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun selected => (enclosed_binding_counting_under S pointwise).mp
    fun _ _ _ tally _ _ acts arises _ => match selected with
    | .inl dependent => acts (.inl dependent)
    | .inr (.inl acting) => acts (.inr (.inl acting))
    | .inr (.inr (.inl taking)) => acts (.inr (.inr taking))
    | .inr (.inr (.inr embodied)) => match arises embodied with
      | ⟨t, joins⟩ => ⟨t + 1, tally.after_pos joins⟩⟩

/-- Something arises exactly where embodiment is selected. -/
theorem enclosed_binding_arising_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → (∀ p, S p = true → p.Binds w) →
        w.CensusMarksHold fun _ _ a => ∃ t, 0 < a t) ↔
      S .embodied = true :=
  have pointwise : Pointwise fun (_ _ : Nat → Nat) a => ∃ t, 0 < a t :=
    fun same ⟨t, pos⟩ => ⟨t, Nat.lt_of_lt_of_le pos (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | true => rfl
    | false => match (enclosed_binding_counting_under S pointwise).mpr law (fun _ => 1)
        (fun _ => 0) (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun embodied => (enclosed_binding_counting_under S pointwise).mp
     fun _ _ _ _ _ _ _ arises _ => arises embodied⟩

/-- And something arises across a step at which something is active exactly where embodiment
is selected and either the selection binds counting or selects only active relata giving and
bounded transmission, as where nothing is enclosed (`binding_joint_iff`): a change bound with
dissipation does not force it, since what arises may arise from nothing before enclosure. -/
theorem enclosed_binding_joint_iff (S : Premise → Bool) :
    (∀ (w : World) [∀ t x, Decidable (w.web.active t x)], w.Meets S →
      (∃ T, ∀ t, T ≤ t → w.flow.Enclosed t) → (∀ p, S p = true → p.Binds w) →
        w.CensusMarksHold fun n _ a => ∃ t, 0 < n t ∧ 0 < a t) ↔
      S .embodied = true ∧ (BindsCounting S ∨ S .acting = true ∧ S .transmitting = true) :=
  have pointwise : Pointwise fun n (_ : Nat → Nat) a => ∃ t, 0 < n t ∧ 0 < a t :=
    fun same ⟨t, active, arising⟩ => ⟨t, Nat.lt_of_lt_of_le active (Nat.le_of_eq (same t).1),
      Nat.lt_of_lt_of_le arising (Nat.le_of_eq (same t).2.2)⟩
  ⟨fun law => match he : S .embodied with
    | false => match (enclosed_binding_counting_under S pointwise).mpr law (fun _ => 1)
        (fun _ => 0) (fun _ => 0) (fun _ => ⟨1, rfl, rfl⟩)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied)
        (fun ⟨_, embodied, _⟩ => nomatch he.symm.trans embodied) (fun _ => ⟨0, Nat.zero_lt_one⟩)
        (fun selected => nomatch he.symm.trans selected)
        (fun selected => nomatch he.symm.trans selected) with
      | ⟨_, _, no⟩ => absurd no (Nat.lt_irrefl 0)
    | true => if both : BindsCounting S ∨ S .acting = true ∧ S .transmitting = true then
        ⟨rfl, both⟩
      else match (enclosed_binding_counting_under S pointwise).mpr law Queue.lone (fun _ => 0)
          Queue.joins Queue.lone_tally (fun binds => absurd (.inl binds) both)
          (fun _ => ⟨1, 1, Queue.lone_settles, fun
            | 0, early, _ => absurd early (Nat.not_succ_le_zero 0)
            | _ + 1, _, _ => Nat.zero_lt_one⟩) (fun _ => ⟨1, Nat.zero_lt_one⟩)
          (fun _ => ⟨0, Nat.zero_lt_one⟩)
          (fun _ acting transmitting => absurd (.inr ⟨acting, transmitting⟩) both) with
        | ⟨0, empty, _⟩ => absurd empty (Nat.lt_irrefl 0)
        | ⟨_ + 1, _, no⟩ => absurd no (Nat.lt_irrefl 0),
   fun ⟨embodied, both⟩ => (enclosed_binding_counting_under S pointwise).mp
    fun _ _ _ _ quiet _ _ arises joint => match both with
    | .inl binds => match arises embodied with
      | ⟨t, joins⟩ => ⟨t, quiet binds t joins, joins⟩
    | .inr ⟨acting, transmitting⟩ => joint embodied acting transmitting⟩

end World

end Becoming

section TallyWorlds

/-!
## Tally worlds: the counts a world's census can have

`Becoming.Population` states that the counts some listing has are exactly the tallies
(`tally_iff_counted`), that a tally is the census balance with no more ceasing across a step
than were counted before it (`tally_iff`), that the balance alone is no tally
(`balance_not_tally`), and that a step after which nothing changes, asked of every tally with a
change bound, is the limited principle of omniscience (`ChangeBound.lpo_of_ends`). A census of a
world lists its active relata at each step (`Web.Census`), and `Becoming.Counting` reads every
tally as the census of a queue world (`World.queue`). This section states those laws of the
censuses of worlds and proves them through the laws of listings.

* **The counts of a world's census are exactly the tallies.** Some world's census counts `n`
  active at each step, `c` ceasing and `a` arising across it (`Shown`), exactly when `n`, `c`, `a`
  are a tally (`shown_iff_tally`); so exactly when they balance and no more cease across a step
  than were active before it (`shown_iff_balance`). The balance alone is not enough: none active,
  one ceasing and one arising across every step balance, and no world's census counts them
  (`balance_not_shown`).
* **The end of change asks for omniscience.** If every world's census whose change is bounded from
  the first step, with nothing arising across a step at which nothing is active, had a step after
  which nothing ceases or arises, `LPO` would hold (`lpo_of_census_ends`).

`World.counting_free` states that a property of the counts holds of every world's census exactly
when it holds of every tally. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace TallyWorlds

/-- Some world's census counts `n` active relata at each step, `c` ceasing and `a` arising across
the step from it. -/
def Shown (n c a : Nat → Nat) : Prop :=
  ∃ (w : World) (_ : ∀ t x, Decidable (w.web.active t x)) (alive : Nat → List w.Relatum),
    w.web.Census alive ∧ ∀ t, (alive t).length = n t ∧
      ceasings (alive t) (fun x s => w.web.active s x) t = c t ∧
      comings (alive (t + 1)) (fun x s => w.web.active s x) t = a t

/-- **The counts of a world's census are exactly the tallies.** Some world's census has the counts
`n`, `c`, `a` exactly when they are a tally; the queue world counts every tally. -/
theorem shown_iff_tally (n c a : Nat → Nat) : Shown n c a ↔ Tally n c a :=
  ⟨fun ⟨w, _, alive, census, same⟩ =>
     (tally_iff_counted n c a).mpr ⟨w.Relatum, fun x s => w.web.active s x, inferInstance, alive,
       census, same⟩,
   fun tally => ⟨World.queue n c, World.queue_decided n c, Queue.line n c, Queue.listed,
     Queue.counts tally⟩⟩

/-- **A world's census counts exactly what balances with ceasing within the count.** Some world's
census has the counts `n`, `c`, `a` exactly when, across each step, those active after it with
those ceasing are those active before it with those arising, and no more cease than were active
before it. -/
theorem shown_iff_balance (n c a : Nat → Nat) :
    Shown n c a ↔ Balance n c a ∧ ∀ t, c t ≤ n t :=
  (shown_iff_tally n c a).trans tally_iff

/-- **The balance alone is not a census.** With none active, one ceasing and one arising across
every step, the census balance holds and no world's census has these counts. -/
theorem balance_not_shown :
    Balance (fun _ => 0) (fun _ => 1) (fun _ => 1) ∧
      ¬ Shown (fun _ => 0) (fun _ => 1) (fun _ => 1) :=
  ⟨balance_not_tally.1, fun shown => balance_not_tally.2 ((shown_iff_tally _ _ _).mp shown)⟩

/-- Counting the steps at which a quantity is positive respects its values at each step. -/
theorem occurrences_congr {T : Nat} {q q' : Nat → Nat} (same : ∀ s, q s = q' s) :
    ∀ t, occurrences T q t = occurrences T q' t
  | 0 => rfl
  | t + 1 => (congr (congrArg (· + ·) (occurrences_congr same t))
      (mark_iff (p := T ≤ t ∧ 0 < q t) (q := T ≤ t ∧ 0 < q' t)
        ⟨fun ⟨later, pos⟩ => ⟨later, Eq.subst (motive := fun x => 0 < x) (same t) pos⟩,
         fun ⟨later, pos⟩ => ⟨later, Eq.subst (motive := fun x => 0 < x) (same t).symm pos⟩⟩) :
      occurrences T q t + mark (T ≤ t ∧ 0 < q t) = occurrences T q' t + mark (T ≤ t ∧ 0 < q' t))

/-- **The end of change in every world asks for omniscience.** If every census of every world
whose activity is decided, with change bounded from the first step and nothing arising across a
step at which nothing is active, had a step after which nothing ceases or arises, the limited
principle of omniscience would hold. -/
theorem lpo_of_census_ends
    (ends : ∀ (w : World) [∀ t x, Decidable (w.web.active t x)] (alive : Nat → List w.Relatum),
      w.web.Census alive →
      (∀ t, 0 < comings (alive (t + 1)) (fun x s => w.web.active s x) t → 0 < (alive t).length) →
      (∃ B, ChangeBound 0 B (fun t => (alive t).length)
        (fun t => ceasings (alive t) (fun x s => w.web.active s x) t)
        (fun t => comings (alive (t + 1)) (fun x s => w.web.active s x) t)) →
      ∃ E, ∀ t, E ≤ t → ceasings (alive t) (fun x s => w.web.active s x) t +
        comings (alive (t + 1)) (fun x s => w.web.active s x) t = 0) : LPO :=
  ChangeBound.lpo_of_ends fun n c _ tally company ⟨B, bound⟩ =>
    have counts := Queue.counts tally
    match ends (World.queue n c) (Queue.line n c) Queue.listed
        (fun t pos => Eq.subst (motive := fun x => 0 < x) (counts t).1.symm
          (company t (Eq.subst (motive := fun x => 0 < x) (counts t).2.2 pos)))
        ⟨B, fun t later => Nat.le_trans (Nat.le_of_eq (congr (congrArg (· + ·) (counts t).1)
            (occurrences_congr
              (fun s => congr (congrArg (· + ·) (counts s).2.1) (counts s).2.2) t)))
          (bound t later)⟩ with
    | ⟨E, quiet⟩ => ⟨E, fun t later =>
        (congr (congrArg (· + ·) (counts t).2.1) (counts t).2.2).symm.trans (quiet t later)⟩

end TallyWorlds

end Becoming

end TallyWorlds
