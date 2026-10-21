import Becoming.Premises

/-!
# Openness: continued change needs exchange beyond what stands

`Becoming.Space` brings a finite, balanced, dissipative world whose arising is embodied to
rest, and in a finite world arising recurs exactly when ceasing does. This module states
what does the work. The world need not be finite: what brings it to rest is finitely many
standing at each step and enclosure around them from some step on, with a census of what
is active; for arising and ceasing to recur together, a bound on that census. In a world
that comes to rest so, not unboundedly many relata ever stand or are active
(`World.rest_few`): beyond finite worlds, the rest theorem adds relata that never stand
or act, and the exchange does not recur either (`World.exchange_not_recurring`).
Under balance and dissipation, across a step whose exchange, together with whatever
stands before or after it, lies within finitely many conditions, the total standing does
not rise, and it falls whenever any condition's standing changes: a rise is given to, and
giving needs uptake there; a fall is taken from.

* **The laws of one step.** Each law below is a corollary of a law of `Becoming.Locality`
  stated for every world, its condition inside it: across a step at which a family holding
  whatever stands is balanced and dissipated on, some standing changes exactly when the total
  falls, and change recurs exactly when it recurs across steps at which what stands does not
  run down (`Flow.change_recurs_iff`). The premises supply that condition across a step
  enclosed around what stands (`Flow.AroundStanding.runsDownClosed`).
* **Total standing runs down.** Where what stands at each step is listed, each once
  (`Web.StandingCensus`), the total standing across a step enclosed around what stands
  (`Flow.AroundStanding`) does not rise (`Flow.standing_never_rises`), and any rise or
  fall of a condition's standing lowers it (`Flow.change_lowers`).
* **Standing stops changing, unrefuted.** So where every step from some step on is enclosed
  around what stands, that no condition's standing changes from some step on cannot be refuted
  (`Flow.change_stops_unrefuted_around`), and change does not recur
  (`Flow.change_not_recurring_from`).
* **The exchange does not recur.** Across such a step, a formation taking part that takes
  or gives anything lowers the total standing: the enclosing family holds what it
  exchanges, and giving to it needs taking from it (`Flow.exchange_lowers`). So where
  every step from some step on is enclosed around what stands, no formation takes or
  gives at arbitrarily late steps (`Flow.exchange_not_recurring_around`,
  `World.exchange_not_recurring`), with no census of activity and no embodiment. Each premise is
  needed, the exchange recurring without it (`World.exchange_needs`): without enclosure in
  `exposed`, which meets all eight premises; without dissipation in the cycle of `Becoming.Flow`,
  its one condition standing throughout and every step enclosed around it; without balance in
  `leaking`, finite and dissipative; and without the census of what stands in `throughput`,
  balanced, dissipative and enclosed at every step.
* **Ceasing needs arising.** In a world with a census whose activity is decided, ceasing
  recurs only where arising recurs (`World.arising_of_ceasing`, from
  `Listed.coming_of_ceasing`). Not conversely: `accretion` has a census and arises without end
  while nothing ceases; `attrition` keeps ceasing while nothing arises, so it has no census
  (`World.census_one_way`).
* **A bounded count keeps them together.** Where at most `B` relata are active at each
  step (`World.CountedWithin`), arising recurs exactly when ceasing does
  (`World.CountedWithin.arising_iff_ceasing`, from `Web.unceasing_iff_bounded`). Every
  census of a finite world is bounded, with no decidability
  (`World.Finite.census_bounded`), so where activity is decided the law of finite worlds,
  `World.arising_iff_ceasing`, is a case (`World.Finite.countedWithin`);
  `procession`, with one relatum active at a time among infinitely many, keeps arising and
  ceasing
  (`World.procession_world`); `accretion` has no bound (`World.accretion_unbounded`). The bound may
  grow between: where at most `B t` relata are active at each step `t`
  (`World.CountedBy`) and `B` returns to at most `K` at arbitrarily late steps, the two
  still recur together (`World.CountedBy.arising_iff_ceasing`). A bound growing without
  end does not keep them together, however slowly it grows: in `slow B`, for any
  non-decreasing, unbounded `B`, the relata below `B t` are active at step `t`, arising
  recurs and nothing ceases (`World.slow_world`). So a non-decreasing bound keeps arising
  and ceasing together in every world it counts where it stays within some number, and
  not where it grows without end; there ceasing recurs exactly where the count falls
  short of what was there with what arose since (`Listed.ceasing_iff_shortfall`), as
  where arising outpaces the bound (`Listed.ceasing_of_outpacing`). Read of
  standing, the same law holds under a census of what stands: what stands at the end
  with what ceased to stand is what stood at the start with what came to stand
  (`Web.StandingCensus.over_stretch`), ceasing to stand recurring needs coming to stand
  recurring, and with a bound from some step on the two recur together
  (`Web.StandingCensus.coming_of_ceasing`, `Web.StandingCensus.coming_iff_ceasing`).
* **The rest theorem.** Where what stands is listed, whatever arises is embodied, the
  flow balances and dissipates, and every step from some step on is enclosed around what
  stands, that arising stops from some step on cannot be refuted, since standing stops
  changing (`World.arising_stops_unrefuted`); so too where the flow is only not refuted to run
  down (`World.arising_stops_unrefuted_from`, from `Flow.change_stops_unrefuted`). With a
  census of what is active as well, that the world rests from some step on cannot be refuted
  (`World.comes_to_rest_unrefuted`, `World.RestsFrom`), so neither arising nor ceasing recurs
  (`World.not_recurring_of_rests_unrefuted`). No decision procedure is used, and of the census
  only that it covers what is active: under a covering list, ceasing left unrefuted after every
  step leaves a later arising unrefuted after every step (`Covers.not_not_coming_from`), which
  the unrefuted stopping of arising refutes (`World.comes_to_rest_unrefuted_from`). Naming the
  step is a principle of omniscience (`World.lpo_of_finite_ends`).
* **Each census does work.** Without the census of what is active, ceasing can go on:
  `attrition` meets every other premise and keeps ceasing (`World.rest_needs_census`). Without
  the census of what stands, arising can go on: in `throughput` what is active is listed,
  whatever arises is embodied, the flow balances and dissipates and every step is
  enclosed around every relatum ever active, yet every unburnt fuel stands; in `embodiedThroughput`,
  the same flow with every relatum embodied, every step is enclosed and nothing is listed
  (`World.rest_needs_standing`).
* **Its cases.** A finite world lists what stands and is enclosed around it at every step
  (`World.Finite.standing`), so the finite rest (`World.rests_unrefuted`, `Becoming.InAmounts`) is a case
  of the rest theorem, its relata covering whatever is active (`World.comes_to_rest_unrefuted_from`). Where every
  relatum is embodied, the census of what is
  active lists what stands (`World.rests_unrefuted_around`), and enclosure from some step on
  suffices, with no decision of equality: an enclosed step is not not enclosed around
  what stands, and the totals compared are numbers (`World.rests_unrefuted_enclosed`, stated since
  EC3 in `Becoming.InAmounts` as the whole-number case of the rest theorem over any amounts). Both
  conclude that the world rests from some step on is unrefuted, `¬ ¬ ∃ N, RestsFrom N`, under
  the census, embodiment, balance and dissipation, not that a step of rest is given. Read the
  other way, arising without end in such a world is incompatible with every step from
  some step on being enclosed: it exchanges beyond every finite family
  (`World.arising_opens`).
* **What comes to rest is few.** Where what holds is listed at each step and coming to be
  does not recur, not unboundedly many members ever hold (`Listed.few_of_quiet`), and with no
  decision procedure where that coming to be stops cannot be refuted
  (`Listed.few_of_stop_unrefuted`). So in every world
  that comes to rest under the rest theorem, not unboundedly many relata are ever active and
  not unboundedly many ever stand, with no decision procedure (`World.rest_few`); conversely, where
  some list holds every relatum ever active and activity is decided, a census exists
  (`World.counted_of_ever`). That stronger form, a list holding every member that ever
  holds, does not follow without omniscience: for a determination listed by at most one
  member and coming to hold at most once, it gives `LPO` (`Listed.lpo_of_few`, `Few`).
  Beyond finite worlds the rest theorem reaches only relata that never stand or act, as
  the idle ground of `hatch` (`World.hatch_idle`).
* **The premises decide neither enclosure nor openness.** The sides of `Shuttle`, also
  taking a unit from each of infinitely many ground relata and giving it back at every
  step, meet all eight premises of `Becoming.Premises` and arise without end. No step is
  enclosed, so dissipation, which binds only at enclosed steps, binds at none
  (`World.exposed_world`); nothing depends on anything, so activity needing support and
  bounded transmission hold vacuously too. Their openness is exchange at zero net: the
  total standing stays at one, and the ground relata stand at nothing
  (`World.exposed_standing`). Nor does openness with the eight give arising without
  end: a holder taking a unit from each ground relatum and giving it back at every step
  meets the eight with no step enclosed, and nothing arises or ceases
  (`World.holding_world`). Mutualists meet the eight with every step enclosed and come
  to rest (`World.openness_contingent`). So does `hatch`, in which every premise binds:
  after the child arises and the parent ceases, every step is enclosed and nothing
  changes, though the world is not finite (`World.hatch_rests_unrefuted`).

What stands and what is active coincide only for embodied relata. The standing laws need
no embodiment; the rest theorem uses it only for what arises, turning arising into
rising, and reaches ceasing through a list covering what is active. Decidedness of activity
is not a commitment of the representation: it is the condition of the laws that find a step
where without it a step is only not refuted, the census law, the bounded laws and
`Listed.few_of_quiet`. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

variable {α : Type} {F C : Type}

/-! ## Total standing -/

/-- The census law read of standing: under a census of what stands, conditions ceasing to
stand at arbitrarily late steps need conditions coming to stand at arbitrarily late
steps (`coming_of_ceasing_covered`). -/
theorem Web.StandingCensus.coming_of_ceasing {W : Web F C} {stand : Nat → List C}
    (census : W.StandingCensus stand) (ceasing : ∀ N, ∃ t c, N ≤ t ∧ W.CeasesToStand t c) :
    ∀ N, ∃ t c, N ≤ t ∧ W.ComesToStand t c :=
  coming_of_ceasing_covered (Listed.covered census) ceasing

/-- With at most `B` conditions standing at each step from some step on, coming to stand
recurs exactly when ceasing to stand does (`Listed.coming_iff_ceasing`). -/
theorem Web.StandingCensus.coming_iff_ceasing {W : Web F C} {stand : Nat → List C}
    (census : W.StandingCensus stand) {T B : Nat}
    (bounded : ∀ t, T ≤ t → (stand t).length ≤ B) :
    (∀ N, ∃ t c, N ≤ t ∧ W.ComesToStand t c) ↔ ∀ N, ∃ t c, N ≤ t ∧ W.CeasesToStand t c :=
  Listed.coming_iff_ceasing census bounded

instance Web.decideComesToStand (W : Web F C) (t : Nat) (c : C) :
    Decidable (W.ComesToStand t c) :=
  instDecidableAnd

instance Web.decideCeasesToStand (W : Web F C) (t : Nat) (c : C) :
    Decidable (W.CeasesToStand t c) :=
  instDecidableAnd

/-- The census balance read of standing, over a stretch at each step of which what stands is
listed: the conditions standing at the end with those that ceased to stand are those
standing at the start with those that came to stand (`Listed.over_stretch_on`). -/
theorem Web.StandingCensus.over_stretch_on {W : Web F C} {stand : Nat → List C} {S n : Nat}
    (listing : ∀ s, S ≤ s → s ≤ S + n → Distinct (stand s) ∧ ∀ c, 0 < W.level s c ↔ c ∈ stand s) :
    (stand (S + n)).length + total (steps S n) (fun t => total (stand t) fun c =>
      mark (W.CeasesToStand t c)) =
      (stand S).length + total (steps S n) (fun t => total (stand (t + 1)) fun c =>
        mark (W.ComesToStand t c)) :=
  Listed.over_stretch_on (p := fun c t => 0 < W.level t c) listing

/-- The census balance read of standing: over any stretch, the conditions standing at the
end with those that ceased to stand are those standing at the start with those that came
to stand (`Listed.over_stretch`). -/
theorem Web.StandingCensus.over_stretch {W : Web F C} {stand : Nat → List C}
    (census : W.StandingCensus stand) (S n : Nat) :
    (stand (S + n)).length + total (steps S n) (fun t => total (stand t) fun c =>
      mark (W.CeasesToStand t c)) =
      (stand S).length + total (steps S n) (fun t => total (stand (t + 1)) fun c =>
        mark (W.ComesToStand t c)) :=
  Web.StandingCensus.over_stretch_on fun s _ _ => census s

/-- The step from `t` is enclosed around what stands across it: some family without
repetition, closed across the step, holds whatever stands before or after it. -/
def Flow.AroundStanding (L : Flow F C) (stand : Nat → List C) (t : Nat) : Prop :=
  ∃ es, Distinct es ∧ (∀ c, c ∈ stand t → c ∈ es) ∧ (∀ c, c ∈ stand (t + 1) → c ∈ es) ∧
    L.ClosedAt es t

/-- The flow exchanges at arbitrarily late steps: some formation taking part takes or gives
something. -/
def Flow.ExchangeRecurs (L : Flow F C) : Prop :=
  ∀ N, ∃ t f c, N ≤ t ∧ f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)

namespace Flow

variable {L : Flow F C} {W : Web F C} {stand : Nat → List C}

/-- With equality decided, a step enclosed by some family is enclosed around what
stands. -/
theorem Enclosed.aroundStanding [DecidableEq C] {t : Nat} (enclosed : L.Enclosed t)
    (stand : Nat → List C) : L.AroundStanding stand t :=
  match enclosed.around (stand t ++ stand (t + 1)) with
  | ⟨es, distinct, within, closed⟩ =>
    ⟨es, distinct, fun c mem => within c (mem_append_of_left _ mem),
     fun c mem => within c (mem_append_of_right _ mem), closed⟩

/-- Without decided equality, a step enclosed by some family is not not enclosed around
what stands (`Enclosed.around_not_not`). -/
theorem Enclosed.aroundStanding_not_not {t : Nat} (enclosed : L.Enclosed t)
    (stand : Nat → List C) : ¬¬ L.AroundStanding stand t :=
  fun no => enclosed.around_not_not (stand t ++ stand (t + 1))
    fun ⟨es, distinct, within, closed⟩ => no ⟨es, distinct,
      fun c mem => within c (mem_append_of_left _ mem),
      fun c mem => within c (mem_append_of_right _ mem), closed⟩

/-- A member of a family dissipated on across the step falling lowers the family's stock:
it is taken from (`Flow.BalancesOn.fall_lowers`). -/
theorem fall_lowers_on (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (falls : W.Falls t c) :
    W.stock ds (t + 1) < W.stock ds t :=
  (balances.on ds t).fall_lowers dissipates mem falls

/-- Under balance and dissipation, a family closed across a step and holding what stands
before and after it runs down across it: the premises give the local condition of
`Becoming.Locality` there. -/
theorem AroundStanding.runsDownClosed (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {t : Nat} :
    L.AroundStanding stand t → L.RunsDownClosed W t
  | ⟨es, distinct, before, after, closed⟩ =>
    ⟨es, ⟨distinct, fun c positive => before c (((census t).2 c).mp positive),
      fun c positive => after c (((census (t + 1)).2 c).mp positive), balances.on es t,
      dissipative es t distinct closed⟩, closed⟩

/-- Under dissipation, across a step enclosed around what stands, the total standing falls
by at least the number of formations taking from the enclosing family. -/
theorem standing_runs_down (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {t : Nat} :
    L.AroundStanding stand t →
      ∃ es, W.stock (stand (t + 1)) (t + 1) + L.takers es t ≤ W.stock (stand t) t
  | around => match around.runsDownClosed balances dissipative census with
    | ⟨es, runs, _⟩ => match runs.stock_eq census, runs with
      | ⟨now, next⟩, ⟨_, _, _, balancesOn, dissipates⟩ =>
        ⟨es, Nat.le_trans (Nat.le_of_eq (congrArg (· + L.takers es t) next))
          (Nat.le_trans (balancesOn.runs_down dissipates) (Nat.le_of_eq now.symm))⟩

/-- So the total standing does not rise (`Flow.RunsDown.standing_le`). -/
theorem standing_never_rises (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {t : Nat} (around : L.AroundStanding stand t) :
    W.stock (stand (t + 1)) (t + 1) ≤ W.stock (stand t) t :=
  (around.runsDownClosed balances dissipative census).runsDown.standing_le census

/-- And any condition's standing rising or falling across the step lowers it
(`Flow.RunsDown.changes_iff`). -/
theorem change_lowers (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {t : Nat} (around : L.AroundStanding stand t) {c : C}
    (changes : W.Rises t c ∨ W.Falls t c) :
    W.stock (stand (t + 1)) (t + 1) < W.stock (stand t) t :=
  ((around.runsDownClosed balances dissipative census).runsDown.changes_iff census).mp
    ⟨c, changes⟩

/-- Change does not recur wherever what stands runs down from some step on: under a census
of what stands, where across every step from `T` on it is not refuted that what stands runs
down, no condition's standing changes at arbitrarily late steps. No premise is asked: the
corollary of `Flow.change_recurs_iff`; `Flow.change_stops_unrefuted` is the stronger form. -/
theorem change_not_recurring_from (census : W.StandingCensus stand) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ L.RunsDown W t) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ (W.Rises t c ∨ W.Falls t c) :=
  fun changing => match (change_recurs_iff census).mp (fun N => match changing N with
      | ⟨t, c, later, changes⟩ => ⟨t, later, c, changes⟩) T with
  | ⟨t, later, unmet, _⟩ => runs t later unmet

/-- That change stops from some step on cannot be refuted: under a census of what stands, where
across every step from `T` on it is not refuted that what stands runs down, it is not the case
that after every step from `T` on a later change of some standing stays unrefuted
(`stop_unrefuted_iff`). No premise; `change_not_recurring_from` is the weaker form,
that change does not recur. The least-loss law (`Amounts.rests_unrefuted`) at whole-number amounts:
each change lowers the total standing by at least one, and nothing is decided. -/
theorem change_stops_unrefuted (census : W.StandingCensus stand) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ L.RunsDown W t) :
    ¬ ∀ M, T ≤ M → ¬ ¬ ∃ t c, M ≤ t ∧ (W.Rises t c ∨ W.Falls t c) :=
  fun changing => Amounts.rests_unrefuted (M := Amounts.whole)
    (s := fun t => W.stock (stand t) t) (ε := 1) (P := fun t => ∃ c, W.Rises t c ∨ W.Falls t c)
    (m := W.stock (stand T) T + 1)
    (fun t later no => runs t later fun down => no (down.standing_le census))
    (fun t later changes no => runs t later fun down => no ((down.changes_iff census).mp changes))
    (Amounts.whole_within _)
    fun M from_ none_ => changing M from_ fun ⟨t, c, later, changes⟩ => none_ ⟨t, later, c, changes⟩

/-- That standing stops changing from some step on cannot be refuted where every step from
some step on is enclosed around what stands: it is not the case that after every step from
`T` on a later change of some standing stays unrefuted. It is enough that each of those
enclosures is not refuted: under the premises an enclosure around what stands is a step at
which what stands runs down (`Flow.change_stops_unrefuted`). -/
theorem change_stops_unrefuted_around (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {T : Nat}
    (around : ∀ t, T ≤ t → ¬¬ L.AroundStanding stand t) :
    ¬ ∀ M, T ≤ M → ¬ ¬ ∃ t c, M ≤ t ∧ (W.Rises t c ∨ W.Falls t c) :=
  change_stops_unrefuted census fun t later unmet => around t later fun enclosed =>
    unmet (enclosed.runsDownClosed balances dissipative census).runsDown

/-- Across a step enclosed around what stands, a formation taking part that takes or gives
anything lowers the total standing: the enclosing family holds what it exchanges, and
under dissipation giving to it needs taking from it (`Flow.RunsDownClosed.exchanges_iff`). -/
theorem exchange_lowers (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {t : Nat} (around : L.AroundStanding stand t) {f : F}
    {c : C} (present : f ∈ L.present t) (exchanges : 0 < L.take t f c ∨ 0 < L.give t f c) :
    W.stock (stand (t + 1)) (t + 1) < W.stock (stand t) t :=
  ((around.runsDownClosed balances dissipative census).exchanges_iff census).mp
    ⟨f, c, present, exchanges⟩

/-- The exchange does not recur wherever what stands runs down closed from some step on:
under a census of what stands, where across every step from `T` on it is not refuted that
what stands runs down closed, no formation takes or gives at arbitrarily late steps. The
corollary of `Flow.exchange_recurs_iff`, with no premise. -/
theorem exchange_not_recurring_from (census : W.StandingCensus stand) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ L.RunsDownClosed W t) : ¬ L.ExchangeRecurs :=
  fun exchanging => match (exchange_recurs_iff census).mp (fun N => match exchanging N with
      | ⟨t, f, c, later, present, exchanges⟩ => ⟨t, later, .inl ⟨f, c, present, exchanges⟩⟩) T with
  | ⟨t, later, unmet, _⟩ => runs t later unmet

/-- The exchange does not recur: where every step from some step on is not refuted to be
enclosed around what stands, no formation takes or gives at arbitrarily late steps. The
corollary of `Flow.exchange_recurs_iff`. -/
theorem exchange_not_recurring_around (balances : L.Balances W) (dissipative : L.Dissipative)
    (census : W.StandingCensus stand) {T : Nat}
    (around : ∀ t, T ≤ t → ¬¬ L.AroundStanding stand t) : ¬ L.ExchangeRecurs :=
  exchange_not_recurring_from census fun t later unmet => around t later fun enclosed =>
    unmet (enclosed.runsDownClosed balances dissipative census)

end Flow

/-! ## Arising and ceasing under a census -/

namespace World

/-- At most `B t` relata are active at each step `t`, listed each once (`Web.Census`). -/
def CountedBy (w : World) (B : Nat → Nat) : Prop :=
  ∃ alive, w.web.Census alive ∧ ∀ t, (alive t).length ≤ B t

/-- At most `B` relata are active at each step: counted by a bound that does not grow. -/
def CountedWithin (w : World) (B : Nat) : Prop :=
  w.CountedBy fun _ => B

variable {w : World}

/-- The census law: in a world with a census whose activity is decided, ceasing recurs
only where arising recurs. The corollary of `coming_of_ceasing_covered`, which needs lists
covering what is active only at arbitrarily late steps. -/
theorem arising_of_ceasing [∀ t x, Decidable (w.web.active t x)] (counted : w.Counted)
    (ceasing : w.CeasingRecurs) : w.ArisingRecurs :=
  match counted with
  | ⟨_, census⟩ => coming_of_ceasing_covered (Listed.covered census) ceasing

/-- With at most `B` relata active at each step, arising recurs exactly when ceasing does
(`Web.unceasing_iff_bounded`). -/
theorem CountedWithin.arising_iff_ceasing [∀ t x, Decidable (w.web.active t x)] {B : Nat}
    (counted : w.CountedWithin B) : w.ArisingRecurs ↔ w.CeasingRecurs :=
  match counted with
  | ⟨_, census, bounded⟩ => w.web.unceasing_iff_bounded census (T := 0) fun t _ => bounded t

/-- Where the bound returns to at most `K` at arbitrarily late steps, however large it grows
between, arising recurs exactly when ceasing does (`Listed.ceasing_of_returning`). -/
theorem CountedBy.arising_iff_ceasing [∀ t x, Decidable (w.web.active t x)] {B : Nat → Nat}
    {K : Nat} (counted : w.CountedBy B) (returns : ∀ N, ∃ t, N ≤ t ∧ B t ≤ K) :
    w.ArisingRecurs ↔ w.CeasingRecurs :=
  match counted with
  | ⟨alive, census, bounded⟩ =>
    ⟨Listed.ceasing_of_returning census fun N => match returns N with
      | ⟨t, later, low⟩ => ⟨t, later, Nat.le_trans (bounded t) low⟩,
     arising_of_ceasing ⟨alive, census⟩⟩

/-- Every census of a finite world counts within the number of its relata; no
decidability is needed (the eleventh review's probe). -/
theorem Finite.census_bounded (finite : w.Finite) :
    ∃ B, ∀ alive, w.web.Census alive → ∀ t, (alive t).length ≤ B :=
  match finite with
  | ⟨all, _, every⟩ =>
    ⟨all.length, fun _ census t => length_le_of_sub (census t).1 fun x _ => every x⟩

/-- A finite world whose activity is decided has a census (`Finite.counted`), and it counts
within the number of its relata. -/
theorem Finite.countedWithin [∀ t x, Decidable (w.web.active t x)] (finite : w.Finite) :
    ∃ B, w.CountedWithin B :=
  match finite.census_bounded, finite.counted with
  | ⟨B, bounded⟩, ⟨alive, census⟩ => ⟨B, alive, census, bounded alive census⟩

end World

namespace Accretion

/-- The relata of `World.accretion` active at step `t`: the formations that arose before it. -/
def alive : Nat → List (Nat ⊕ Unit)
  | 0 => []
  | t + 1 => .inl t :: alive t

theorem mem_alive : ∀ {t : Nat} {x : Nat ⊕ Unit}, x ∈ alive t ↔ World.accretion.web.active t x
  | 0, .inl f => ⟨fun mem => (nomatch mem), fun active => absurd active (Nat.not_lt_zero f)⟩
  | 0, .inr _ => ⟨fun mem => (nomatch mem), False.elim⟩
  | t + 1, .inl _ => ⟨fun mem => match mem with
      | .head _ => Nat.lt_succ_self _
      | .tail _ mem => Nat.lt_succ_of_lt ((mem_alive (t := t)).mp mem),
    fun active => match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ active) with
      | .inl same => same ▸ .head _
      | .inr lower => .tail _ ((mem_alive (t := t)).mpr lower)⟩
  | t + 1, .inr _ => ⟨fun mem => match mem with
      | .tail _ mem => (mem_alive (t := t)).mp mem, False.elim⟩

theorem alive_distinct : ∀ t, Distinct (alive t)
  | 0 => trivial
  | t + 1 => ⟨fun mem => Nat.lt_irrefl t (mem_alive.mp mem), alive_distinct t⟩

/-- At each step finitely many relata of `World.accretion` are active. -/
theorem census : World.accretion.web.Census alive :=
  fun t => ⟨alive_distinct t, fun _ => mem_alive.symm⟩

end Accretion

namespace World

/-- One way only. In `accretion`, which has a census, arising recurs while ceasing does not; in
`attrition` ceasing recurs while nothing arises, so by the census law it has no census. -/
theorem census_one_way :
    (accretion.Counted ∧ accretion.ArisingRecurs ∧ ¬ accretion.CeasingRecurs) ∧
    (attrition.CeasingRecurs ∧ ¬ attrition.ArisingRecurs ∧ ¬ attrition.Counted) :=
  match separate with
  | ⟨⟨arising, quiet, _⟩, ⟨ceasing, still, _⟩⟩ =>
    ⟨⟨⟨Accretion.alive, Accretion.census⟩, arising, quiet⟩,
     ⟨ceasing, still, fun counted => still (arising_of_ceasing counted ceasing)⟩⟩

/-- `accretion` has a census but no bound on it: arising recurs there while ceasing does not. -/
theorem accretion_unbounded (B : Nat) : ¬ accretion.CountedWithin B :=
  fun counted => census_one_way.1.2.2 (counted.arising_iff_ceasing.mp census_one_way.1.2.1)

end World

namespace Procession

/-- Relatum `x` is active at step `x` alone. -/
def web : Web Nat Nat where
  level _ _ := 0
  active t x := x = t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- One relatum is active at each step, listed once. -/
theorem census : web.Census fun t => [t] :=
  fun _ => ⟨⟨fun no => (nomatch no), trivial⟩, fun _ =>
    ⟨fun same => match same with | rfl => .head _, fun mem => match mem with
      | .head _ => rfl
      | .tail _ no => (nomatch no)⟩⟩

end Procession

namespace World

/-- Relatum `x` is active at step `x` alone: infinitely many relata, one active at a time.
-/
def procession : World :=
  World.of Nat Flow.still Procession.web

instance procession_decided : ∀ t x, Decidable (procession.web.active t x) :=
  fun t x => Nat.decEq x t

/-- The bounded law reaches beyond finite worlds: in `procession` one relatum is active at
each step, arising and ceasing both recur, and the relata are not finitely many. -/
theorem procession_world :
    procession.CountedWithin 1 ∧ procession.ArisingRecurs ∧ procession.CeasingRecurs ∧
    ¬ procession.Finite :=
  ⟨⟨fun t => [t], Procession.census, fun _ => Nat.le_refl 1⟩,
   fun N => ⟨N, N + 1, Nat.le_refl N, Nat.ne_of_gt (Nat.lt_succ_self N), rfl⟩,
   fun N => ⟨N, N, Nat.le_refl N, rfl, Nat.ne_of_lt (Nat.lt_succ_self N)⟩,
   fun ⟨all, _, every⟩ => beyond_not_mem all (every (beyond all))⟩

end World

namespace Slow

/-- Relatum `x` is active at step `t` while below `B t`. -/
def web (B : Nat → Nat) : Web Nat Nat where
  level _ _ := 0
  active t x := x < B t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem length : ∀ n, (Cycle.present n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length n)

/-- The relata below `B t`, listed as the cycle lists its formations, each once. -/
theorem census (B : Nat → Nat) : (web B).Census fun t => Cycle.present (B t) :=
  fun t => ⟨Cycle.distinct (B t), fun x => ⟨Cycle.listed (B t) x, Cycle.present_lt (B t) x⟩⟩

theorem grows_between {B : Nat → Nat} (grows : ∀ t, B t ≤ B (t + 1)) :
    ∀ {s t}, s ≤ t → B s ≤ B t
  | _, _, .refl => Nat.le_refl _
  | _, _, .step within => Nat.le_trans (grows_between grows within) (grows _)

end Slow

namespace World

/-- Relatum `x` is active at step `t` while below `B t`. -/
def slow (B : Nat → Nat) : World :=
  World.of Nat Flow.still (Slow.web B)

instance slow_decided (B : Nat → Nat) : ∀ t x, Decidable ((slow B).web.active t x) :=
  fun t x => Nat.decLt x (B t)

/-- No bound growing without end keeps arising and ceasing together, however slowly it
grows. In `slow B`, counted by a non-decreasing, unbounded `B`, relatum `B t` arises across
each step at which the bound grows, and nothing ceases. -/
theorem slow_world {B : Nat → Nat} (grows : ∀ t, B t ≤ B (t + 1))
    (unbounded : ∀ n, ∃ t, n < B t) :
    (slow B).CountedBy B ∧ (slow B).ArisingRecurs ∧ ∀ t x, ¬ (slow B).web.Ceases t x :=
  ⟨⟨fun t => Cycle.present (B t), Slow.census B, fun t => Nat.le_of_eq (Slow.length (B t))⟩,
   fun N => match unbounded (B N) with
    | ⟨T, higher⟩ => match Nat.lt_or_ge T N with
      | .inl earlier => absurd higher
          (Nat.not_lt_of_ge (Slow.grows_between grows (Nat.le_of_lt earlier)))
      | .inr later => match rises_between (q := B) later higher with
        | ⟨t, from_, _, up⟩ => ⟨t, B t, from_, Nat.lt_irrefl (B t), up⟩,
   fun t _ ceases => ceases.2 (Nat.lt_of_lt_of_le ceases.1 (grows t))⟩

/-! ## Worlds come to rest -/

variable {w : World}

/-- Arising does not recur wherever what stands runs down from some step on: where what stands
is listed and whatever arises is embodied, and across every step from `T` on it is not refuted
that what stands runs down, arising does not recur. No premise on the flow is asked;
`arising_stops_unrefuted_from` is the stronger form. -/
theorem arising_not_recurring_from {stand : Nat → List w.Relatum}
    (standing : w.web.StandingCensus stand) (embodied : w.ArisingEmbodied) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ w.flow.RunsDown w.web t) : ¬ w.ArisingRecurs :=
  fun arising => Flow.change_not_recurring_from standing runs fun N => match arising N with
    | ⟨t, x, later, arises⟩ =>
      ⟨t, x, later, .inl ((embodied t x arises).comesToStand arises).rises⟩

/-- That arising stops there from some step on cannot be refuted: it is not the case that after
every step from `T` on a later arising stays unrefuted (`stop_unrefuted_iff`). No premise on the
flow and no decision procedure (`Flow.change_stops_unrefuted`). -/
theorem arising_stops_unrefuted_from {stand : Nat → List w.Relatum}
    (standing : w.web.StandingCensus stand) (embodied : w.ArisingEmbodied) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ w.flow.RunsDown w.web t) :
    ¬ ∀ M, T ≤ M → ¬ ¬ ∃ t x, M ≤ t ∧ w.web.Arises t x :=
  fun arising => Flow.change_stops_unrefuted standing runs fun M from_ none_ =>
    arising M from_ fun ⟨t, x, later, arises⟩ =>
      none_ ⟨t, x, later, .inl ((embodied t x arises).comesToStand arises).rises⟩

/-- That arising stops from some step on cannot be refuted where what stands is listed,
whatever arises is embodied, the flow balances and dissipates, and every step from some step on
is enclosed around what stands: an enclosure around what stands is a step at which what stands
runs down (`arising_stops_unrefuted_from`). Ceasing need not stop (`rest_needs_census`). -/
theorem arising_stops_unrefuted {stand : Nat → List w.Relatum}
    (standing : w.web.StandingCensus stand) (embodied : w.ArisingEmbodied)
    (balanced : w.Balanced) (dissipative : w.Dissipative)
    {T : Nat} (around : ∀ t, T ≤ t → w.flow.AroundStanding stand t) :
    ¬ ∀ M, T ≤ M → ¬ ¬ ∃ t x, M ≤ t ∧ w.web.Arises t x :=
  arising_stops_unrefuted_from standing embodied fun t later unmet =>
    unmet ((around t later).runsDownClosed balanced dissipative standing).runsDown

/-- Rest wherever what stands runs down from some step on, unrefuted: in a world whose arising
is embodied, with a census of what stands and a list covering what is active at each step from
`T` on, across every step from `T` on of which it is not refuted that what stands runs down,
that the world rests from some step on cannot be refuted. No premise on the flow, no census of
activity and no decision procedure: that arising stops cannot be refuted
(`arising_stops_unrefuted_from`), and ceasing left unrefuted after every step would leave a
later arising unrefuted after every step (`Covers.not_not_coming_from`). -/
theorem comes_to_rest_unrefuted_from {stand : Nat → List w.Relatum} {T : Nat}
    (covered : ∀ t, T ≤ t → ∃ L : List w.Relatum, Covers (fun x s => w.web.active s x) L t)
    (standing : w.web.StandingCensus stand) (embodied : w.ArisingEmbodied)
    (runs : ∀ t, T ≤ t → ¬¬ w.flow.RunsDown w.web t) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have unrefuted := arising_stops_unrefuted_from standing embodied runs
  rests_unrefuted_iff.mpr
  ⟨fun arising => unrefuted fun M _ none_ => arising M none_,
   fun ceasing => unrefuted fun M from_ none_ => match covered M from_ with
     | ⟨_, covers⟩ => Covers.not_not_coming_from (p := fun x s => w.web.active s x) covers ceasing
         fun ⟨t, x, later, arises⟩ => none_ ⟨t, x, later, arises⟩⟩

/-- The rest theorem. In a world with a census of activity and of what stands, whose arising is
embodied, with a balanced, dissipative flow, in which every step from some step on is enclosed
around what stands, that the world rests from some step on cannot be refuted, with no decision
procedure: the census covers what is active (`comes_to_rest_unrefuted_from`). Neither arising
nor ceasing recurs, the weaker form (`not_recurring_of_rests_unrefuted`); naming the step is a
principle of omniscience (`World.lpo_of_finite_ends`). -/
theorem comes_to_rest_unrefuted (counted : w.Counted)
    {stand : Nat → List w.Relatum} (standing : w.web.StandingCensus stand)
    (embodied : w.ArisingEmbodied) (balanced : w.Balanced) (dissipative : w.Dissipative)
    {T : Nat} (around : ∀ t, T ≤ t → w.flow.AroundStanding stand t) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  match counted with
  | ⟨alive, census⟩ => comes_to_rest_unrefuted_from (T := T)
      (fun t _ => ⟨alive t, fun x active => ((census t).2 x).mp active⟩) standing embodied
      fun t later unmet =>
        unmet ((around t later).runsDownClosed balanced dissipative standing).runsDown

/-- A finite world lists what stands at each step, and every step is enclosed around it,
so `World.rests_unrefuted` is the finite case of the rest theorem, its relata covering whatever
is active (`comes_to_rest_unrefuted_from`). -/
theorem Finite.standing (finite : w.Finite) :
    ∃ stand, w.web.StandingCensus stand ∧ ∀ t, w.flow.AroundStanding stand t :=
  match finite with
  | ⟨all, distinct, every⟩ =>
    ⟨fun t => keep (fun x => 0 < w.web.level t x) all,
     fun _ => ⟨keep_distinct distinct, fun x =>
       ⟨fun standing => mem_keep.mpr ⟨every x, standing⟩, fun mem => (mem_keep.mp mem).2⟩⟩,
     fun _ => ⟨all, distinct, fun c _ => every c, fun c _ => every c,
       fun _ _ c outside => absurd (every c) outside⟩⟩

/-- The rest theorem needs its census of activity: in `attrition` nothing stands and nothing
takes part, so every other premise holds, every step is enclosed around what stands, and
ceasing recurs. -/
theorem rest_needs_census :
    attrition.web.StandingCensus (fun _ => []) ∧ attrition.ArisingEmbodied ∧ attrition.Balanced ∧
    attrition.Dissipative ∧ (∀ t, attrition.flow.AroundStanding (fun _ => []) t) ∧
    attrition.CeasingRecurs ∧ ¬ attrition.Counted :=
  ⟨fun _ => ⟨trivial, fun x => match x with
      | .inl _ => ⟨fun standing => absurd standing (Nat.lt_irrefl 0), fun mem => (nomatch mem)⟩
      | .inr _ => ⟨fun standing => absurd standing (Nat.lt_irrefl 0), fun mem => (nomatch mem)⟩⟩,
   fun t x arises => match x, arises with
      | .inl f, arises => absurd arises (Attrition.nothing_arises t f)
      | .inr _, arises => False.elim arises.2,
   fun _ x => match x with
      | .inl _ => rfl
      | .inr _ => rfl,
   fun _ _ _ _ _ present => (nomatch present),
   fun _ => ⟨[], trivial, fun _ mem => (nomatch mem), fun _ mem => (nomatch mem),
     fun _ present => (nomatch present)⟩,
   census_one_way.2.1, census_one_way.2.2.2⟩

/-- With a census of the active relata, every relatum embodied, what stands is listed. -/
theorem standingCensus {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) : w.web.StandingCensus alive :=
  fun t => ⟨(census t).1, fun x => (embodied x t).symm.trans ((census t).2 x)⟩

/-- An embodied relatum arising rises. -/
theorem rises_of_arises (embodied : w.Embodied) {t : Nat} {x : w.Relatum}
    (arises : w.web.Arises t x) : w.web.Rises t x :=
  Web.ComesToStand.rises (W := w.web)
    ⟨fun standing => arises.1 ((embodied x t).mpr standing), (embodied x (t + 1)).mp arises.2⟩

/-- An embodied relatum ceasing falls. -/
theorem falls_of_ceases (embodied : w.Embodied) {t : Nat} {x : w.Relatum}
    (ceases : w.web.Ceases t x) : w.web.Falls t x :=
  Nat.lt_of_le_of_lt
    (Nat.le_of_eq (eq_zero_of_not_pos fun standing => ceases.2 ((embodied x (t + 1)).mpr standing)))
    ((embodied x t).mp ceases.1)

/-- A world with a census whose relata are embodied, with a balanced, dissipative flow, in
which every step from some step on is enclosed around what stands: that it rests from some step
on cannot be refuted. -/
theorem rests_unrefuted_around {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (around : ∀ t, T ≤ t → w.flow.AroundStanding alive t) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
    comes_to_rest_unrefuted ⟨alive, census⟩
    (standingCensus census embodied) embodied.arising balanced dissipative around


/-- So arising without end, in a world with a census whose relata are embodied and
whose flow balances and dissipates, is incompatible with every step from any point on
being enclosed: the world exchanges beyond every finite family. -/
theorem arising_opens (counted : w.Counted)
    (embodied : w.Embodied) (balanced : w.Balanced) (dissipative : w.Dissipative)
    (arising : w.ArisingRecurs) (T : Nat) : ¬ ∀ t, T ≤ t → w.flow.Enclosed t :=
  fun enclosed => (not_recurring_of_rests_unrefuted
    (rests_unrefuted_enclosed counted embodied balanced dissipative enclosed)).1 arising

end World

/-! ## What comes to rest is few -/

/-- The lists of the steps up to `n`, joined. -/
def gather (l : Nat → List α) : Nat → List α
  | 0 => l 0
  | n + 1 => l (n + 1) ++ gather l n

theorem gather_self {l : Nat → List α} {a : α} : ∀ {s : Nat}, a ∈ l s → a ∈ gather l s
  | 0, mem => mem
  | _ + 1, mem => mem_append_of_left _ mem

theorem mem_gather {l : Nat → List α} {a : α} {s : Nat} (mem : a ∈ l s) :
    ∀ {n}, s ≤ n → a ∈ gather l n
  | _, .refl => gather_self mem
  | m + 1, .step within => mem_append_of_right (l (m + 1)) (mem_gather mem within)

/-- A determination failing at `N` and holding at a later `T` came to be across a step
from `N` on. -/
theorem comes_after {p : Nat → Prop} [∀ t, Decidable (p t)] {N : Nat} (fails : ¬ p N) :
    ∀ {T}, N ≤ T → p T → ∃ t, N ≤ t ∧ ComesToBe p t
  | _, .refl, holds => absurd holds fails
  | m + 1, .step within, holds =>
    if h : p m then comes_after fails within h else ⟨m, within, h, holds⟩

/-- The same, unrefuted, with no decision procedure. -/
theorem comes_after_unrefuted {p : Nat → Prop} {N : Nat} (fails : ¬ p N) :
    ∀ {T}, N ≤ T → p T → ¬ ¬ ∃ t, N ≤ t ∧ ComesToBe p t
  | _, .refl, holds => absurd holds fails
  | _ + 1, .step within, holds => fun none_ =>
      none_ ⟨_, within, fun h => comes_after_unrefuted fails within h none_, holds⟩

/-- Where what holds is listed at each step and coming to be does not recur, not
unboundedly many members ever hold: not every finite list misses a member holding at some
step (the eleventh review's probe). -/
theorem Listed.few_of_quiet {p : α → Nat → Prop} [∀ a t, Decidable (p a t)]
    {l : Nat → List α} (listed : Listed p l)
    (quiet : ¬ ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) :
    ¬ ∀ L : List α, ∃ t a, p a t ∧ ¬ a ∈ L :=
  fun many => quiet fun N => match many (gather l N) with
    | ⟨t, a, holds, out⟩ =>
      have fails : ¬ p a N := fun h => out (mem_gather (((listed N).2 a).mp h) (Nat.le_refl N))
      match Nat.decLe N t with
      | isTrue later => match comes_after fails later holds with
        | ⟨s, after, comes⟩ => ⟨s, a, after, comes⟩
      | isFalse early => absurd (mem_gather (((listed t).2 a).mp holds)
          (Nat.le_of_lt (Nat.gt_of_not_le early))) out

/-- Where what holds is listed at each step and that coming to be stops from some step on
cannot be refuted (`stop_unrefuted_iff` from step `0`), not unboundedly many members ever hold,
with no decision procedure: `Listed.few_of_quiet` from the unrefuted-stopping form of quiet. -/
theorem Listed.few_of_stop_unrefuted {p : α → Nat → Prop} {l : Nat → List α}
    (listed : Listed p l)
    (stopping : ¬ ∀ N, ¬ ¬ ∃ t a, N ≤ t ∧ ComesToBe (p a) t) :
    ¬ ∀ L : List α, ∃ t a, p a t ∧ ¬ a ∈ L :=
  fun many => stopping fun N none_ => match many (gather l N) with
    | ⟨t, a, holds, out⟩ =>
      have fails : ¬ p a N := fun h => out (mem_gather (((listed N).2 a).mp h) (Nat.le_refl N))
      match Nat.decLe N t with
      | isTrue later => comes_after_unrefuted fails later holds fun ⟨s, after, comes⟩ =>
          none_ ⟨s, a, after, comes⟩
      | isFalse early => out (mem_gather (((listed t).2 a).mp holds)
          (Nat.le_of_lt (Nat.gt_of_not_le early)))

namespace Few

/-- `[t]` where `b`, and `l` otherwise. -/
def pick : Bool → Nat → List Nat → List Nat
  | true, t, _ => [t]
  | false, _, l => l

variable (s : Nat → Bool)

/-- The first `true` of `s`, once it has passed. -/
def found : Nat → List Nat
  | 0 => []
  | t + 1 => pick (clear s t && s t) t (found t)

/-- Holding at `t`: being the first `true` of `s`, before `t`. -/
abbrev passed (a t : Nat) : Prop :=
  a < t ∧ clear s a = true ∧ s a = true

theorem distinct_pick : ∀ (b : Bool) (t : Nat) {l : List Nat}, Distinct l →
    Distinct (pick b t l)
  | true, _, _, _ => ⟨fun no => (nomatch no), trivial⟩
  | false, _, _, distinct => distinct

theorem distinct_found : ∀ t, Distinct (found s t)
  | 0 => trivial
  | t + 1 => distinct_pick (clear s t && s t) t (distinct_found t)

theorem mem_pick (t a : Nat) : ∀ b : Bool, (clear s t && s t) = b →
    (passed s a t ↔ a ∈ found s t) → (passed s a (t + 1) ↔ a ∈ pick b t (found s t))
  | true, first, _ =>
    ⟨fun ⟨_, c, yes⟩ => Eq.subst (motive := fun x => x ∈ [t])
        (Clear.first_unique s (ListTests.and_left first) (ListTests.and_right first) c yes) (.head []),
     fun mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun x => passed s x (t + 1)) same.symm
          ⟨Nat.lt_succ_self t, ListTests.and_left first, ListTests.and_right first⟩
      | .inr no => nomatch no⟩
  | false, notFirst, before =>
    ⟨fun ⟨lt, c, yes⟩ => before.mp ⟨match Nat.lt_or_ge a t with
        | .inl earlier => earlier
        | .inr ge => (Clear.not_both notFirst
            (Eq.subst (motive := fun x => (clear s x && s x) = true)
              (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge) (Clear.and_both _ _ c yes))).elim,
        c, yes⟩,
     fun mem => match before.mpr mem with
      | ⟨lt, c, yes⟩ => ⟨Nat.lt_succ_of_lt lt, c, yes⟩⟩

theorem mem_found : ∀ t a, passed s a t ↔ a ∈ found s t
  | 0, a => ⟨fun holds => absurd holds.1 (Nat.not_lt_zero a), fun no => nomatch no⟩
  | t + 1, a => mem_pick s t a (clear s t && s t) rfl (mem_found t a)

/-- Being the first `true`, once passed, is listed at each step by at most one member. -/
theorem listed : Listed (passed s) (found s) :=
  fun t => ⟨distinct_found s t, fun a => mem_found s t a⟩

/-- What comes to hold comes to hold at its own index. -/
theorem comes_at {a t : Nat} (comes : ComesToBe (passed s a) t) : a = t :=
  match comes with
  | ⟨fails, ⟨lt, c, yes⟩⟩ => match Nat.lt_or_ge a t with
    | .inl earlier => (fails ⟨earlier, c, yes⟩).elim
    | .inr ge => Nat.le_antisymm (Nat.le_of_lt_succ lt) ge

/-- Coming to hold does not recur: it happens at most once. -/
theorem coming_not_recurring : ¬ ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (passed s a) t :=
  fun all => match all 0 with
  | ⟨t₀, _, _, c₀⟩ => match all (t₀ + 1) with
    | ⟨_, _, later, c₁⟩ =>
      Nat.not_succ_le_self t₀ (Nat.le_trans later (Nat.le_of_eq
        (((comes_at s c₁).symm.trans
          (Clear.first_unique s c₁.2.2.1 c₁.2.2.2 c₀.2.2.1 c₀.2.2.2)).trans (comes_at s c₀))))

end Few

/-- `few_of_quiet` cannot be strengthened to a list holding every member that ever holds
without omniscience: if every determination decided and listed at each step, whose coming
to hold does not recur, had such a list, `LPO` would hold, even where at most one member is
listed at each step and coming to hold happens at most once (`Few`; the twelfth review's
probe). -/
theorem Listed.lpo_of_few
    (few : ∀ (p : Nat → Nat → Prop) (l : Nat → List Nat), (∀ a t, Decidable (p a t)) →
      Listed p l → (¬ ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) →
      ∃ L : List Nat, ∀ t a, p a t → a ∈ L) :
    LPO := fun s =>
  match few (Few.passed s) (Few.found s) (fun _ _ => inferInstance) (Few.listed s)
      (Few.coming_not_recurring s) with
  | ⟨L, covers⟩ => match Clear.or_first s (beyond L) with
    | .inr ⟨m, _, _, yes⟩ => .inl ⟨m, yes⟩
    | .inl c => .inr fun n => Clear.false_of_not (s n) fun yes =>
      match Clear.first_of_true s yes with
      | ⟨m, cm, ym⟩ => Clear.not_both
          (Clear.false_before s c (lt_beyond (covers (m + 1) m ⟨Nat.lt_succ_self m, cm, ym⟩))) ym

namespace World

variable {w : World}

/-- In every world to which the rest theorem applies, with enclosure from some step on not
refuted, not unboundedly many relata are ever active and not unboundedly many ever stand
(the eleventh review's probe), with no decision procedure: that change stops cannot be
refuted (`Flow.change_stops_unrefuted`), nor with it that coming to be stops
(`Listed.few_of_stop_unrefuted`). So the worlds it covers beyond finite ones add only relata
that never stand or act. -/
theorem rest_few (counted : w.Counted)
    {stand : Nat → List w.Relatum} (standing : w.web.StandingCensus stand)
    (embodied : w.ArisingEmbodied) (balanced : w.Balanced) (dissipative : w.Dissipative)
    {T : Nat} (around : ∀ t, T ≤ t → ¬¬ w.flow.AroundStanding stand t) :
    (¬ ∀ L : List w.Relatum, ∃ t x, w.web.active t x ∧ ¬ x ∈ L) ∧
    (¬ ∀ L : List w.Relatum, ∃ t x, 0 < w.web.level t x ∧ ¬ x ∈ L) :=
  have unrefuted := Flow.change_stops_unrefuted standing (T := T) fun t later unmet =>
    around t later fun enclosed => unmet (enclosed.runsDownClosed balanced dissipative standing).runsDown
  match counted with
  | ⟨_, census⟩ =>
    ⟨Listed.few_of_stop_unrefuted (p := fun x t => w.web.active t x) census fun all =>
        unrefuted fun M _ none_ => all M fun ⟨t, x, later, arises⟩ =>
          none_ ⟨t, x, later, .inl ((embodied t x arises).comesToStand arises).rises⟩,
     Listed.few_of_stop_unrefuted (p := fun x t => 0 < w.web.level t x) standing fun all =>
        unrefuted fun M _ none_ => all M fun ⟨t, x, later, comes⟩ =>
          none_ ⟨t, x, later, .inl (Web.ComesToStand.rises (W := w.web) comes)⟩⟩

/-- In such a world the exchange does not recur either: no relatum takes or gives at
arbitrarily late steps (`Flow.exchange_not_recurring_around`). This needs only the census of what
stands, balance, dissipation and enclosure, not a census of activity or embodiment. -/
theorem exchange_not_recurring {stand : Nat → List w.Relatum}
    (standing : w.web.StandingCensus stand)
    (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (around : ∀ t, T ≤ t → ¬¬ w.flow.AroundStanding stand t) : ¬ w.flow.ExchangeRecurs :=
  Flow.exchange_not_recurring_around balanced dissipative standing around

end World

/-! ## Openness cannot be dropped -/

namespace Exposed

inductive Relatum where
  | side (b : Bool)
  | ground (n : Nat)

/-- The sides stand as in `Shuttle`; the ground relata stand at nothing. -/
def level (t : Nat) : Relatum → Nat
  | .side b => Shuttle.stands b t
  | .ground _ => 0

/-- Across every step the side holding the standing hands it to the other, as in
`Shuttle`, and takes a unit from each ground relatum and gives it back. -/
def flow : Flow Relatum Relatum where
  present t := [.side (Shuttle.holder t)]
  take t x y := match x, y with
    | .side b, .side c => Shuttle.flow.take t b c
    | .side _, .ground _ => 1
    | .ground _, .side _ => 0
    | .ground _, .ground _ => 0
  give t x y := match x, y with
    | .side b, .side c => Shuttle.flow.give t b c
    | .side _, .ground _ => 1
    | .ground _, .side _ => 0
    | .ground _, .ground _ => 0

/-- A relatum is active while it stands; nothing depends on anything, and the sides draw
on everything. -/
def web : Web Relatum Relatum where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- Which side a side relatum is. -/
def sideOf : Relatum → Bool
  | .side b => b
  | .ground _ => false

/-- The index of a ground relatum. -/
def index : Relatum → Nat
  | .side _ => 0
  | .ground n => n

/-- No finite family holds every ground relatum. -/
theorem outside (cs : List Relatum) : ¬ Relatum.ground (beyond (cs.map index)) ∈ cs :=
  fun mem => beyond_not_mem _ (mem_map_of (g := index) mem)

/-- No step is enclosed: the side taking part takes from every ground relatum. -/
theorem open_at (t : Nat) : ¬ flow.Enclosed t :=
  fun ⟨cs, _, closed⟩ => Nat.zero_ne_one
    (closed (.side (Shuttle.holder t)) (.head _) _ (outside cs)).1.symm

/-- A side stands exactly when it holds the standing. -/
theorem stands_iff : ∀ (b : Bool) (t : Nat), 0 < Shuttle.stands b t ↔ b = Shuttle.holder t
  | true, 0 => ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
  | false, 0 => ⟨fun no => absurd no (Nat.lt_irrefl 0), fun no => Bool.noConfusion no⟩
  | true, 1 => ⟨fun no => absurd no (Nat.lt_irrefl 0), fun no => Bool.noConfusion no⟩
  | false, 1 => ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
  | true, t + 2 => stands_iff true t
  | false, t + 2 => stands_iff false t

/-- The side holding the standing is the one active relatum. -/
theorem census : web.Census fun t => [.side (Shuttle.holder t)] :=
  fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun x => match x with
    | .side b => ⟨fun standing => Eq.subst
          (motive := fun c => Relatum.side c ∈ [Relatum.side (Shuttle.holder t)])
          ((stands_iff b t).mp standing).symm (.head _),
        fun mem => (stands_iff b t).mpr (match mem_cons_cases mem with
          | .inl same => congrArg sideOf same
          | .inr no => nomatch no)⟩
    | .ground n => ⟨fun no => absurd no (Nat.lt_irrefl 0),
        fun (mem : Relatum.ground n ∈ [Relatum.side (Shuttle.holder t)]) => match mem with
          | .tail _ no => (nomatch no)⟩⟩

/-- The holder stands at one. -/
theorem holder_one : ∀ t, Shuttle.stands (Shuttle.holder t) t = 1
  | 0 => rfl
  | 1 => rfl
  | t + 2 => (Shuttle.stands_two (Shuttle.holder t) t).trans (holder_one t)

end Exposed

namespace Holding

/-- One side stands at one throughout; the other side and the ground stand at nothing. -/
def level (_ : Nat) : Exposed.Relatum → Nat
  | .side true => 1
  | .side false => 0
  | .ground _ => 0

/-- At every step the standing side takes a unit from each ground relatum and gives it
back. -/
def flow : Flow Exposed.Relatum Exposed.Relatum where
  present _ := [.side true]
  take _ x y := match x, y with
    | .side true, .ground _ => 1
    | .side true, .side _ => 0
    | .side false, _ => 0
    | .ground _, _ => 0
  give _ x y := match x, y with
    | .side true, .ground _ => 1
    | .side true, .side _ => 0
    | .side false, _ => 0
    | .ground _, _ => 0

/-- Every relatum is active while it stands, depends on nothing, and draws on everything. -/
def web : Web Exposed.Relatum Exposed.Relatum where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

theorem open_at (t : Nat) : ¬ flow.Enclosed t :=
  fun ⟨cs, _, closed⟩ => Nat.zero_ne_one
    (closed (.side true) (.head _) _ (Exposed.outside cs)).1.symm

theorem census : web.Census fun _ => [.side true] :=
  fun _ => ⟨⟨fun no => (nomatch no), trivial⟩, fun x => match x with
    | .side true => ⟨fun _ => .head _, fun _ => Nat.zero_lt_one⟩
    | .side false => ⟨fun no => absurd no (Nat.lt_irrefl 0),
        fun (mem : Exposed.Relatum.side false ∈ [Exposed.Relatum.side true]) => match mem with
          | .tail _ no => (nomatch no)⟩
    | .ground n => ⟨fun no => absurd no (Nat.lt_irrefl 0),
        fun (mem : Exposed.Relatum.ground n ∈ [Exposed.Relatum.side true]) => match mem with
          | .tail _ no => (nomatch no)⟩⟩

end Holding

namespace World

/-- The sides of `Shuttle` exchanging with an unbounded ground. -/
def exposed : World :=
  World.of Exposed.Relatum Exposed.flow Exposed.web

/-- `exposed` meets all eight premises and arising recurs in it: no step is enclosed, so
dissipation binds at none. -/
theorem exposed_world :
    exposed.Premised ∧ exposed.ArisingRecurs ∧ ∀ t, ¬ exposed.flow.Enclosed t :=
  ⟨.of (fun _ _ _ _ no => no.elim)
     (fun t c => match c with
      | .side c => Shuttle.balances t c
      | .ground _ => rfl)
     (fun t f _ present _ => match f, present with
      | _, .head _ => Shuttle.holder_stands t
      | _, .tail _ no => (nomatch no))
     (fun t f _ present _ => match f, present with
      | _, .head _ => ⟨Shuttle.holder_stands t, trivial⟩
      | _, .tail _ no => (nomatch no))
     (fun cs t distinct closed => absurd ⟨cs, distinct, closed⟩ (Exposed.open_at t))
     (fun _ _ => Iff.rfl) ⟨_, Exposed.census⟩ ⟨0, fun _ _ _ _ _ no => no.elim⟩,
   fun N => match Shuttle.recurs true N with
    | ⟨t, later, arises⟩ => ⟨t, .side true, later, arises⟩,
   Exposed.open_at⟩

/-- What stands in `exposed` is listed, the holder alone: the total standing is one at every
step, and the holder falls across every step. The world is not finite; what is unbounded
is the number of relata it exchanges with, each standing at nothing (the tenth review's
probe). -/
theorem exposed_standing :
    exposed.web.StandingCensus (fun t => [Exposed.Relatum.side (Shuttle.holder t)]) ∧
    (∀ t, exposed.web.stock [Exposed.Relatum.side (Shuttle.holder t)] t = 1) ∧
    (∀ t, exposed.web.Falls t (Exposed.Relatum.side (Shuttle.holder t))) ∧
    ¬ exposed.Finite :=
  ⟨standingCensus Exposed.census fun _ _ => Iff.rfl,
   fun t => show Shuttle.stands (Shuttle.holder t) t + 0 = 1 from Exposed.holder_one t,
   fun t => show Shuttle.stands (Shuttle.holder t) (t + 1) < Shuttle.stands (Shuttle.holder t) t
     from Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.le_of_eq (Shuttle.next_off t))
       Nat.zero_lt_one) (Nat.le_of_eq (Exposed.holder_one t).symm),
   fun ⟨all, _, every⟩ => Exposed.outside all (every _)⟩

/-- The eight premises decide neither enclosure nor openness: `exposed` meets them with no
step enclosed and keeps arising, and mutualists meet them with every step enclosed and do
not keep arising (the tenth review's probe). -/
theorem openness_contingent :
    (exposed.Premised ∧ (∀ t, ¬ exposed.flow.Enclosed t) ∧ exposed.ArisingRecurs) ∧
    (mutualism.Premised ∧ (∀ t, mutualism.flow.Enclosed t) ∧ ¬ mutualism.ArisingRecurs) :=
  ⟨⟨exposed_world.1, exposed_world.2.2, exposed_world.2.1⟩,
   ⟨mutualism_premised, mutualism_finite.enclosed, mutualism_world.2.1⟩⟩

/-- One side holding its standing while exchanging at zero net with an unbounded ground. -/
def holding : World :=
  World.of Exposed.Relatum Holding.flow Holding.web

/-- Openness with the eight premises does not give arising without end: `holding` meets all
eight with no step enclosed, and nothing ever arises or ceases (the eleventh review's
probe). Under a census, with every relatum embodied, balance and dissipation, openness is
necessary for arising without end (`arising_opens`), not sufficient. With only whatever
arises embodied it is not necessary: `throughput` is enclosed at every step and arises
without end (`rest_needs_standing`). -/
theorem holding_world :
    holding.Premised ∧ (∀ t, ¬ holding.flow.Enclosed t) ∧ ¬ holding.ArisingRecurs ∧
    ¬ holding.CeasingRecurs ∧ ¬ holding.Finite :=
  ⟨.of (fun _ _ _ _ no => no.elim)
     (fun _ c => match c with
      | .side true => rfl
      | .side false => rfl
      | .ground _ => rfl)
     (fun _ f _ present _ => match f, present with
      | _, .head _ => Nat.zero_lt_one
      | _, .tail _ no => (nomatch no))
     (fun _ f _ present _ => match f, present with
      | _, .head _ => ⟨Nat.zero_lt_one, trivial⟩
      | _, .tail _ no => (nomatch no))
     (fun cs t distinct closed => absurd ⟨cs, distinct, closed⟩ (Holding.open_at t))
     (fun _ _ => Iff.rfl) ⟨_, Holding.census⟩ ⟨0, fun _ _ _ _ _ no => no.elim⟩,
   Holding.open_at,
   fun arising => match arising 0 with
    | ⟨_, x, _, arises⟩ => match x, arises with
      | .side true, arises => arises.1 Nat.zero_lt_one
      | .side false, arises => absurd arises.2 (Nat.lt_irrefl 0)
      | .ground _, arises => absurd arises.2 (Nat.lt_irrefl 0),
   fun ceasing => match ceasing 0 with
    | ⟨_, x, _, ceases⟩ => match x, ceases with
      | .side true, ceases => ceases.2 Nat.zero_lt_one
      | .side false, ceases => absurd ceases.1 (Nat.lt_irrefl 0)
      | .ground _, ceases => absurd ceases.1 (Nat.lt_irrefl 0),
   fun ⟨all, _, every⟩ => Exposed.outside all (every _)⟩

/-- In a world meeting all eight premises with each binding (`hatch_binds`), that it rests
from some step on cannot be refuted. Across the first step the child arises and the parent
ceases; every step is enclosed within the food, the parent and the child, and finitely many
stand at each step, though the world is not finite. -/
theorem hatch_rests_unrefuted : hatch.web.Arises 0 .child ∧ hatch.web.Ceases 0 .parent ∧
    ¬ ¬ ∃ N, hatch.RestsFrom N :=
  ⟨⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩, ⟨Nat.zero_lt_one, Nat.lt_irrefl 0⟩,
   rests_unrefuted_enclosed hatch_counted (fun _ _ => Iff.rfl) hatch_balanced hatch_dissipative
     (T := 0) fun t _ => ⟨Hatch.kin, Hatch.kin_distinct, Hatch.closed t⟩⟩

end World

/-! ## Finitely many standing cannot be dropped -/

namespace Throughput

/-- Which side a side relatum is. -/
def sideOf : Relatum → Bool
  | .side x => x
  | .fuel _ => false

/-- The index of a fuel. -/
def index : Relatum → Nat
  | .side _ => 0
  | .fuel n => n

/-- Every fuel stands at the first step. -/
theorem fuel_stands : ∀ n, 0 < web.level 0 (.fuel n)
  | 0 => Nat.zero_lt_two
  | _ + 1 => Nat.zero_lt_two

/-- The holder is the one active relatum. -/
theorem census : web.Census fun t => [Relatum.side (Shuttle.holder t)] :=
  fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun x => match x with
    | .side b => ⟨fun active => Eq.subst
          (motive := fun c => Relatum.side c ∈ [Relatum.side (Shuttle.holder t)])
          ((Exposed.stands_iff b t).mp active).symm (.head _),
        fun mem => (Exposed.stands_iff b t).mpr (match mem_cons_cases mem with
          | .inl same => congrArg sideOf same
          | .inr no => nomatch no)⟩
    | .fuel _ => ⟨fun no => False.elim no, fun mem => match mem with
        | .tail _ no => (nomatch no)⟩⟩

/-- No list holds every fuel: a determination holding of every fuel lists none. -/
theorem unlisted {holds : Relatum → Prop} (l : List Relatum)
    (listed : ∀ x, holds x ↔ x ∈ l) (fuels : ∀ n, holds (.fuel n)) : False :=
  beyond_not_mem (l.map index)
    (mem_map_of (g := index) ((listed (.fuel (beyond (l.map index)))).mp (fuels _)))

end Throughput

namespace EmbodiedThroughput

/-- `Throughput`'s levels, each relatum active exactly while it stands, and no dependence. -/
def web : Web Throughput.Relatum Throughput.Relatum where
  level := Throughput.web.level
  active t c := 0 < Throughput.web.level t c
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

end EmbodiedThroughput

namespace World

/-- `Throughput`'s flow with every relatum active while it stands (the tenth review's
probe). -/
def embodiedThroughput : World :=
  World.of Throughput.Relatum Throughput.flow EmbodiedThroughput.web

/-- The rest theorem needs its census of what stands. In `throughput` what is active is
listed, whatever arises is embodied, the flow balances and dissipates, and every step is
enclosed around both sides, every relatum ever active; arising recurs, and what stands
cannot be listed, since every unburnt fuel stands. In `embodiedThroughput`, the same flow with every
relatum embodied, every step is enclosed and arising recurs; nothing active can be
listed (the tenth review's probes). -/
theorem rest_needs_standing :
    (throughput.Counted ∧ throughput.ArisingEmbodied ∧ throughput.Balanced ∧
      throughput.Dissipative ∧
      (∀ t, throughput.flow.Around [Throughput.Relatum.side true, .side false] t) ∧
      throughput.ArisingRecurs ∧ ∀ stand, ¬ throughput.web.StandingCensus stand) ∧
    ((∀ t, embodiedThroughput.flow.Enclosed t) ∧ embodiedThroughput.Embodied ∧
      embodiedThroughput.Balanced ∧ embodiedThroughput.Dissipative ∧
      embodiedThroughput.ArisingRecurs ∧ ¬ embodiedThroughput.Counted) :=
  ⟨⟨⟨_, Throughput.census⟩, throughput_arising, throughput_world.1, throughput_world.2.1,
    Throughput.around, throughput_world.2.2.2.1,
    fun stand census => Throughput.unlisted (stand 0) (census 0).2 Throughput.fuel_stands⟩,
   ⟨fun t => match Throughput.around t with
     | ⟨es, distinct, _, closed⟩ => ⟨es, distinct, closed⟩,
    fun _ _ => Iff.rfl, Throughput.balances, Throughput.dissipative,
    fun N => match Throughput.throughput.2.2.2.2.2 true N with
     | ⟨t, later, arises⟩ => ⟨t, .side true, later, arises⟩,
    fun ⟨alive, census⟩ => Throughput.unlisted (alive 0) (census 0).2 Throughput.fuel_stands⟩⟩

end World

/-! ## The exchange needs each premise -/

namespace World

/-- The exchange comes to rest only with each of its premises: in each world below every
other premise holds and the flow exchanges at arbitrarily late steps. Without enclosure:
`exposed` meets all eight premises with what stands listed, and no step is enclosed.
Without dissipation: in the cycle of `Becoming.Flow` the one condition stands throughout,
the flow balances and every step is enclosed around it. Without balance: `leaking` is
dissipative, and every step is enclosed around the side holding the standing. Without the
census of what stands: `throughput` is balanced and dissipative and every step is enclosed,
but what stands cannot be listed, so enclosure around the empty list says nothing about
it. -/
theorem exchange_needs :
    (exposed.web.StandingCensus (fun t => [Exposed.Relatum.side (Shuttle.holder t)]) ∧
      exposed.Balanced ∧ exposed.Dissipative ∧
      (∀ t, ¬ exposed.flow.AroundStanding
        (fun t => [Exposed.Relatum.side (Shuttle.holder t)]) t) ∧
      exposed.flow.ExchangeRecurs) ∧
    (Cycle.web.StandingCensus (fun _ => [()]) ∧ Cycle.flow.Balances Cycle.web ∧
      ¬ Cycle.flow.Dissipative ∧ (∀ t, Cycle.flow.AroundStanding (fun _ => [()]) t) ∧
      Cycle.flow.ExchangeRecurs) ∧
    (leaking.web.StandingCensus (fun t => [Shuttle.holder t]) ∧ ¬ leaking.Balanced ∧
      leaking.Dissipative ∧ (∀ t, leaking.flow.AroundStanding (fun t => [Shuttle.holder t]) t) ∧
      leaking.flow.ExchangeRecurs) ∧
    ((∀ stand, ¬ throughput.web.StandingCensus stand) ∧ throughput.Balanced ∧
      throughput.Dissipative ∧ (∀ t, throughput.flow.AroundStanding (fun _ => []) t) ∧
      throughput.flow.ExchangeRecurs) :=
  have takes : ∀ t (b : Bool), 0 < Shuttle.flow.take t b b := fun _ b => match b with
    | true => Nat.zero_lt_one
    | false => Nat.zero_lt_one
  ⟨⟨exposed_standing.1, exposed_world.1 _ (.tail _ (.head _)),
     exposed_world.1 _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))),
     fun t ⟨es, distinct, _, _, closed⟩ => Exposed.open_at t ⟨es, distinct, closed⟩,
     fun N => ⟨N, .side (Shuttle.holder N), .ground 0, Nat.le_refl N, .head _,
       .inl Nat.zero_lt_one⟩⟩,
   ⟨fun _ => ⟨⟨fun no => (nomatch no), trivial⟩, fun c => (match c with
      | () => ⟨fun _ => .head _, fun _ => Nat.zero_lt_one⟩)⟩,
    Cycle.closed_more.1, witnesses_not_dissipative.2.1,
    fun _ => ⟨[()], ⟨fun no => (nomatch no), trivial⟩, fun c _ => (match c with | () => .head _),
      fun c _ => (match c with | () => .head _),
      fun _ _ c outside => (match c with | () => absurd (.head _) outside)⟩,
    fun N => ⟨N + 1, N, (), Nat.le_succ N, .head _, .inl Nat.zero_lt_one⟩⟩,
   ⟨fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun b =>
      ⟨fun standing => show b ∈ [Shuttle.holder t] from
        Eq.subst (motive := fun c => c ∈ [Shuttle.holder t])
          ((Exposed.stands_iff b t).mp standing).symm (.head _),
       fun (mem : b ∈ [Shuttle.holder t]) => (Exposed.stands_iff b t).mpr (match mem with
        | .head _ => rfl
        | .tail _ no => (nomatch no))⟩⟩,
    leaking_world.2.2.2.2.1, leaking_world.2.2.1,
    fun t => ⟨[true, false], Shuttle.distinct, fun c _ => ListTests.mem_bools c,
      fun c _ => ListTests.mem_bools c, (leaking_world.2.2.2.2.2 t).1⟩,
    fun N => ⟨N, Shuttle.holder N, Shuttle.holder N, Nat.le_refl N, .head _,
      .inl (takes N (Shuttle.holder N))⟩⟩,
   ⟨fun stand census => Throughput.unlisted (stand 0) (census 0).2 Throughput.fuel_stands,
    throughput_world.1, throughput_world.2.1,
    fun t => match Throughput.around t with
      | ⟨es, distinct, _, closed⟩ => ⟨es, distinct, fun _ no => (nomatch no),
          fun _ no => (nomatch no), closed⟩,
    fun N => ⟨N, .side (Shuttle.holder N), .fuel N, Nat.le_refl N, .head _,
      .inl (Nat.lt_of_lt_of_le Nat.zero_lt_two
        (Nat.le_of_eq (congrArg (2 * ·) (Frontier.burning_self N)).symm))⟩⟩⟩

end World

end Becoming
