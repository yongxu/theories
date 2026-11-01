import Becoming.Dissipation

/-!
# Locality: the laws of one step, with their condition inside them

Each law here holds of every world. In place of a premise selected for every step, the
condition a proof uses is stated inside the law, as a fact about the world at the steps and
relata where the proof uses it; a premise selected for every step makes that condition hold
at every step, so the selection results are corollaries. Within the representation the
premises themselves are contingent (`World.contingent`, `World.independent`): what is derived
is the law with its local condition, never a premise. The move made here is localization.

Some of the laws stated here live in lower modules, each in the lowest module that needs it,
with names and statements unchanged: balance at a step and the laws of one condition across
one step (`Flow.BalancesOn`, `Flow.Balances.on`, `Flow.balances_iff_on`,
`Flow.BalancesOn.over`, `Flow.BalancesOn.rise_given`, `Flow.BalancesOn.fall_taken`,
`Flow.BalancesOn.rises_iff_gives`, `lt_iff_pos`) in `Becoming.Flow`; the lowering of a family
balanced and dissipated on (`Flow.BalancesOn.runs_down`, `Flow.BalancesOn.taking_lowers`,
`Flow.BalancesOn.fall_lowers`, `Flow.BalancesOn.rise_lowers`,
`Flow.BalancesOn.comes_from_standing`, `Flow.DissipatesOn.still_untaken`) in
`Becoming.Dissipation`; `came_between` in `Becoming.Population`.

* **Balance at a step.** The flow balances on a family across one step (`Flow.BalancesOn`);
  balance is balance on every family across every step (`Flow.balances_iff_on`).
* **Arising needs an active giver.** With balance at a condition, it comes to stand exactly
  when it stood at nothing and was given more than was taken from it, and ceases to stand
  exactly when it stood and what was taken from it is all it had with all it was given
  (`Flow.BalancesOn.comesToStand_iff`, `Flow.BalancesOn.ceasesToStand_iff`). Where nothing is
  taken from a family balanced on, a member rises exactly when something taking part gives
  to it (`Flow.BalancesOn.rises_iff_gives`), which dissipation on the family excludes
  (`Flow.DissipatesOn.still_untaken`). An embodied relatum arises exactly when it comes to
  stand, so by a giver, and an active one other than itself where only active relata give to
  it (`Flow.BalancesOn.arises_iff`, `Flow.BalancesOn.arises_given`). Nothing comes to stand
  from nothing across a step at which a family holding it is balanced and dissipated on
  (`Flow.BalancesOn.comes_from_standing`).
* **The law of one exchange.** Across a step at which a family holding whatever stands is
  balanced and dissipated on (`Flow.RunsDownOn`), some standing changes exactly when the
  family's total falls, and, the family closed across the step, something taking part takes
  or gives exactly then (`Flow.RunsDownOn.changes_iff`, `Flow.RunsDownOn.exchanges_iff`).
* **Continued change needs openness.** Where what stands is listed at each step
  (`Web.StandingCensus`), standing changes at arbitrarily late steps exactly when it changes
  at arbitrarily late steps across which what stands does not run down
  (`Flow.change_recurs_iff`); so with the exchange (`Flow.exchange_recurs_iff`).
* **Ceasing needs arising.** A list covers what holds at a step where every member holding
  there is on it (`Covers`). For any finite list, what holds of it at the end of a stretch,
  with its ceasings over the stretch, is what held of it at the start exactly when none of
  it comes to be across the stretch (`cohort_closes_iff`). With a list holding exactly what
  holds at `N` (`ListsAt`) and nothing coming to be across a stretch from `N`, what holds at
  its end with what ceased since `N` number exactly those holding at `N`
  (`ceasing_needs_arising`). Where some list covers what holds at arbitrarily late steps,
  ceasing recurring needs coming to be recurring (`coming_of_ceasing_covered`); a census
  covers every step (`Listed.covered`), so the census law is the corollary. Without
  decidability: with a list covering `N` and nothing coming to be from `N` on, ceasing does
  not recur (`Covers.ceasing_steps_within`, `Covers.ceasing_not_recurring`,
  `Covers.not_not_coming_from`).
* **Running down bounds change.** Over any stretch, what stands at its end with the steps at
  which the total standing fell number at most the total standing at its start with what it
  rose, and it rises only across steps at which what stands does not run down; with what
  stands running down from some step on, any count bounded by the total standing, with the
  steps of change since, stays within the total standing there (`Flow.standing_bounds_change`,
  `Flow.runsDown_bounds_change`, `Flow.runsDown_change_bound`).
-/

namespace Becoming

variable {F C : Type}

/-- A sum is positive exactly when its other part is below the total. -/
theorem pos_iff_lt {a b d : Nat} (sum : a + b = d) : 0 < a ↔ b < d :=
  ⟨fun pos => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_of_eq ((Nat.add_comm b a).trans sum)),
   fun lt => Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl b (Nat.lt_of_lt_of_le lt
      (Nat.le_of_eq (sum.symm.trans ((congrArg (· + b) zero).trans (Nat.zero_add b)))))⟩

/-- A total below another over the same list is below it at some member. -/
theorem exists_lt_of_total_lt {α : Type} {p q : α → Nat} :
    ∀ {as : List α}, total as p < total as q → ∃ a, a ∈ as ∧ p a < q a
  | [], less => absurd less (Nat.lt_irrefl 0)
  | a :: as, less => match Nat.decLt (p a) (q a) with
    | isTrue below => ⟨a, .head as, below⟩
    | isFalse notBelow => match exists_lt_of_total_lt (as := as) (Nat.lt_of_add_lt_add_left
        (Nat.lt_of_le_of_lt (Nat.add_le_add_right (Nat.ge_of_not_lt notBelow) _) less)) with
      | ⟨b, mem, below⟩ => ⟨b, .tail a mem, below⟩

/-- Over the steps from `N`, an amount either ends no higher than at `N` or rises at some
step from `N`. -/
theorem rises_or_le (r : Nat → Nat) (N : Nat) :
    ∀ n, r (N + n) ≤ r N ∨ ∃ s, N ≤ s ∧ r s < r (s + 1)
  | 0 => .inl (Nat.le_refl _)
  | n + 1 => match rises_or_le r N n with
    | .inr risen => .inr risen
    | .inl low => match Nat.decLt (r (N + n)) (r (N + n + 1)) with
      | isTrue up => .inr ⟨N + n, Nat.le_add_right N n, up⟩
      | isFalse flat => .inl (Nat.le_trans (Nat.ge_of_not_lt flat) low)

section Recurrence

variable {r : Nat → Nat} {E Q : Nat → Prop}

/-- From any step, an event recurring finds a step at which it occurs without the condition,
or the amount falls below its value there. -/
theorem unmet_or_lower (lowers : ∀ t, Q t → E t → r (t + 1) < r t)
    (holds : ∀ t, Q t → r (t + 1) ≤ r t) (rising : ∀ t, r t < r (t + 1) → E t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ E t) (N : Nat) :
    (∃ t, N ≤ t ∧ ¬ Q t ∧ E t) ∨ ∃ t, N ≤ t ∧ r (t + 1) < r N :=
  match recurs N with
  | ⟨t, later, event⟩ => match Nat.decLt (r (t + 1)) (r t) with
    | isFalse stays => .inl ⟨t, later, fun met => stays (lowers t met event), event⟩
    | isTrue falls => match le_dest later with
      | ⟨m, same⟩ => match rises_or_le r N m with
        | .inr ⟨s, after, up⟩ =>
          .inl ⟨s, after, fun met => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le up (holds s met)),
            rising s up⟩
        | .inl low => .inr ⟨t, later, Nat.lt_of_lt_of_le falls
            (Nat.le_trans (Nat.le_of_eq (congrArg r same)) low)⟩

/-- So from any step at which the amount is at most `k`, the event occurs without the
condition at some later step: each step it occurs under the condition lowers the amount, and
the amount cannot fall more than `k` times without rising, which only the event does. -/
theorem unmet_from (lowers : ∀ t, Q t → E t → r (t + 1) < r t)
    (holds : ∀ t, Q t → r (t + 1) ≤ r t) (rising : ∀ t, r t < r (t + 1) → E t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ E t) : ∀ k N, r N ≤ k → ∃ t, N ≤ t ∧ ¬ Q t ∧ E t
  | 0, N, low => match unmet_or_lower lowers holds rising recurs N with
    | .inl found => found
    | .inr ⟨_, _, lower⟩ => absurd (Nat.lt_of_lt_of_le lower low) (Nat.not_lt_zero _)
  | k + 1, N, low => match unmet_or_lower lowers holds rising recurs N with
    | .inl found => found
    | .inr ⟨t, later, lower⟩ =>
      match unmet_from lowers holds rising recurs k (t + 1)
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lower low)) with
      | ⟨u, after, unmet, event⟩ =>
        ⟨u, Nat.le_trans later (Nat.le_trans (Nat.le_succ t) after), unmet, event⟩

/-- An event recurs exactly where it recurs at steps not meeting a condition, where the
condition makes it lower an amount that never rises under the condition, and every rise of
the amount is an occurrence of the event. -/
theorem recurs_iff_unmet (lowers : ∀ t, Q t → E t → r (t + 1) < r t)
    (holds : ∀ t, Q t → r (t + 1) ≤ r t) (rising : ∀ t, r t < r (t + 1) → E t) :
    (∀ N, ∃ t, N ≤ t ∧ E t) ↔ ∀ N, ∃ t, N ≤ t ∧ ¬ Q t ∧ E t :=
  ⟨fun recurs N => unmet_from lowers holds rising recurs (r N) N (Nat.le_refl _),
   fun recurs N => match recurs N with
    | ⟨t, later, _, event⟩ => ⟨t, later, event⟩⟩

end Recurrence

/-! ## Total standing -/

/-- What stands at each step is listed, each once: finitely many conditions stand at each
step. -/
def Web.StandingCensus (W : Web F C) (stand : Nat → List C) : Prop :=
  Listed (fun c t => 0 < W.level t c) stand

/-- The total standing over the list of what stands is the stock of any family without
repetition holding it. -/
theorem Web.StandingCensus.stock_eq {W : Web F C} {stand : Nat → List C}
    (census : W.StandingCensus stand) {es : List C} (distinct : Distinct es) {t : Nat}
    (within : ∀ c, c ∈ stand t → c ∈ es) : W.stock (stand t) t = W.stock es t :=
  Nat.le_antisymm (total_le_of_support (census t).1 fun c mem _ => within c mem)
    (total_le_of_support distinct fun c _ positive => ((census t).2 c).mp positive)

/-- Each condition standing at a step stands at one or more, so what stands numbers at most
its total standing. -/
theorem Web.StandingCensus.length_le_stock {W : Web F C} {stand : Nat → List C}
    (census : W.StandingCensus stand) (t : Nat) : (stand t).length ≤ W.stock (stand t) t :=
  Nat.le_trans (Nat.le_of_eq (total_ones (stand t)).symm)
    (total_le (stand t) fun c mem => ((census t).2 c).mpr mem)

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-! ## One condition across one step -/

variable {cs : List C} {t : Nat} {c : C}

/-- With balance at `c`, `c` comes to stand across the step exactly when it stood at nothing
and was given more than was taken from it. -/
theorem BalancesOn.comesToStand_iff (balances : L.BalancesOn W cs t) (mem : c ∈ cs) :
    W.ComesToStand t c ↔ W.level t c = 0 ∧ L.taken t c < L.given t c :=
  have fed : W.level t c = 0 → W.level (t + 1) c + L.taken t c = L.given t c := fun zero =>
    (balances c mem).trans ((congrArg (· + L.given t c) zero).trans (Nat.zero_add _))
  ⟨fun comes => ⟨eq_zero_of_not_pos comes.1,
      (pos_iff_lt (fed (eq_zero_of_not_pos comes.1))).mp comes.2⟩,
   fun ⟨zero, more⟩ => ⟨fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq zero)),
      (pos_iff_lt (fed zero)).mpr more⟩⟩

/-- With balance at `c`, `c` ceases to stand across the step exactly when it stood and what
was taken from it is all it had with all it was given. -/
theorem BalancesOn.ceasesToStand_iff (balances : L.BalancesOn W cs t) (mem : c ∈ cs) :
    W.CeasesToStand t c ↔ 0 < W.level t c ∧ L.taken t c = W.level t c + L.given t c :=
  ⟨fun ceases => ⟨ceases.1, (Nat.zero_add _).symm.trans
      ((congrArg (· + L.taken t c) (eq_zero_of_not_pos ceases.2)).symm.trans (balances c mem))⟩,
   fun ⟨stands, all⟩ => ⟨stands, fun pos => Nat.lt_irrefl (L.taken t c)
      (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
        (Nat.le_of_eq ((Nat.add_comm _ _).trans ((balances c mem).trans all.symm))))⟩⟩

/-! ## Rest -/

variable (L W)

/-- Across the step from `t` the family runs down: without repetition it holds whatever
stands before or after the step, and the flow balances and dissipates on it. -/
def RunsDownOn (es : List C) (t : Nat) : Prop :=
  Distinct es ∧ (∀ c, 0 < W.level t c → c ∈ es) ∧ (∀ c, 0 < W.level (t + 1) c → c ∈ es) ∧
    L.BalancesOn W es t ∧ L.DissipatesOn es t

/-- Across the step from `t` what stands runs down: some family runs down across it. This is
said of a world's flow; `OneStep.RunsDown` of `Becoming.OneStep` is the law of running down read
on a pattern of passages, and the patterns shown on a family running down are exactly those
satisfying it (`Flow.Realizes.runsDown`, `OneStep.runsDown_iff`). -/
def RunsDown (t : Nat) : Prop :=
  ∃ es, L.RunsDownOn W es t

/-- Across the step from `t` what stands runs down closed: some family runs down across it
and is closed across it. -/
def RunsDownClosed (t : Nat) : Prop :=
  ∃ es, L.RunsDownOn W es t ∧ L.ClosedAt es t

variable {L W} {es : List C}

/-- The law of one step: across a step at which a family runs down, some condition's
standing changes exactly when the family's total falls. -/
theorem RunsDownOn.changes_iff (runs : L.RunsDownOn W es t) :
    (∃ c, W.Rises t c ∨ W.Falls t c) ↔ W.stock es (t + 1) < W.stock es t :=
  match runs with
  | ⟨_, before, after, balances, dissipates⟩ =>
    ⟨fun ⟨c, changes⟩ => match changes with
      | .inl rises => balances.rise_lowers dissipates
          (after c (Nat.lt_of_le_of_lt (Nat.zero_le _) rises)) rises
      | .inr falls => balances.fall_lowers dissipates
          (before c (Nat.lt_of_le_of_lt (Nat.zero_le _) falls)) falls,
     fun lower => match exists_lt_of_total_lt lower with
      | ⟨c, _, falls⟩ => ⟨c, .inr falls⟩⟩

/-- Closed as well, something taking part takes or gives exactly when the family's total
falls. -/
theorem RunsDownOn.exchanges_iff (runs : L.RunsDownOn W es t) (closed : L.ClosedAt es t) :
    (∃ f c, f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)) ↔
      W.stock es (t + 1) < W.stock es t :=
  match runs with
  | ⟨_, _, _, balances, dissipates⟩ =>
    ⟨fun ⟨f, c, present, exchanges⟩ => Decidable.of_not_not fun stays =>
      have inside : ¬¬ c ∈ es := fun out => match closed f present c out with
        | ⟨noTake, noGive⟩ => match exchanges with
          | .inl takes => Nat.lt_irrefl 0 (Eq.subst (motive := fun k => 0 < k) noTake takes)
          | .inr gives => Nat.lt_irrefl 0 (Eq.subst (motive := fun k => 0 < k) noGive gives)
      inside fun mem => stays (balances.taking_lowers dissipates present (match exchanges with
        | .inl takes => total_pos_of_mem mem takes
        | .inr gives => dissipates.takes_of_gives present (total_pos_of_mem mem gives))),
     fun lower => match exists_lt_of_total_lt lower with
      | ⟨c, mem, falls⟩ => match total_pos (L.present t) (balances.fall_taken mem falls) with
        | ⟨f, present, takes⟩ => ⟨f, c, present, .inl takes⟩⟩

/-! ## Rest over the steps of a world whose standing is listed -/

variable {stand : Nat → List C}

/-- A family running down holds what the census lists before and after the step, so its
totals are the total standing. -/
theorem RunsDownOn.stock_eq (census : W.StandingCensus stand) (runs : L.RunsDownOn W es t) :
    W.stock (stand t) t = W.stock es t ∧ W.stock (stand (t + 1)) (t + 1) = W.stock es (t + 1) :=
  match runs with
  | ⟨distinct, before, after, _, _⟩ =>
    ⟨census.stock_eq distinct fun c mem => before c (((census t).2 c).mpr mem),
     census.stock_eq distinct fun c mem => after c (((census (t + 1)).2 c).mpr mem)⟩

/-- Across a step at which what stands runs down, the total standing does not rise. -/
theorem RunsDown.standing_le (census : W.StandingCensus stand) :
    L.RunsDown W t → W.stock (stand (t + 1)) (t + 1) ≤ W.stock (stand t) t
  | ⟨_, runs⟩ => match runs.stock_eq census, runs with
    | ⟨now, next⟩, ⟨_, _, _, balances, dissipates⟩ =>
      Nat.le_trans (Nat.le_of_eq next)
        (Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _) (balances.runs_down dissipates))
          (Nat.le_of_eq now.symm))

/-- Across a step at which what stands runs down, some condition's standing changes exactly
when the total standing falls. -/
theorem RunsDown.changes_iff (census : W.StandingCensus stand) :
    L.RunsDown W t → ((∃ c, W.Rises t c ∨ W.Falls t c) ↔
      W.stock (stand (t + 1)) (t + 1) < W.stock (stand t) t)
  | ⟨_, runs⟩ => match runs.stock_eq census with
    | ⟨now, next⟩ => (runs.changes_iff).trans
        ⟨fun lower => Nat.lt_of_le_of_lt (Nat.le_of_eq next)
            (Nat.lt_of_lt_of_le lower (Nat.le_of_eq now.symm)),
         fun lower => Nat.lt_of_le_of_lt (Nat.le_of_eq next.symm)
            (Nat.lt_of_lt_of_le lower (Nat.le_of_eq now))⟩

/-- Across a step at which what stands runs down closed, something taking part takes or
gives exactly when the total standing falls. -/
theorem RunsDownClosed.exchanges_iff (census : W.StandingCensus stand) :
    L.RunsDownClosed W t → ((∃ f c, f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)) ↔
      W.stock (stand (t + 1)) (t + 1) < W.stock (stand t) t)
  | ⟨_, runs, closed⟩ => match runs.stock_eq census with
    | ⟨now, next⟩ => (runs.exchanges_iff closed).trans
        ⟨fun lower => Nat.lt_of_le_of_lt (Nat.le_of_eq next)
            (Nat.lt_of_lt_of_le lower (Nat.le_of_eq now.symm)),
         fun lower => Nat.lt_of_le_of_lt (Nat.le_of_eq next.symm)
            (Nat.lt_of_lt_of_le lower (Nat.le_of_eq now))⟩

/-- Under a census of what stands, a rise of the total standing is some condition's rise:
whatever stands after the step stood at most as much before it. -/
theorem rise_of_standing (census : W.StandingCensus stand)
    (rises : W.stock (stand t) t < W.stock (stand (t + 1)) (t + 1)) : ∃ c, W.Rises t c :=
  match exists_lt_of_total_lt (as := stand (t + 1)) (Nat.lt_of_le_of_lt
      (total_le_of_support (census (t + 1)).1 fun c _ positive => ((census t).2 c).mp positive)
      rises) with
  | ⟨c, _, rises⟩ => ⟨c, rises⟩

/-- Closed as well, what stands runs down. -/
theorem RunsDownClosed.runsDown : L.RunsDownClosed W t → L.RunsDown W t
  | ⟨es, runs, _⟩ => ⟨es, runs⟩

/-! ## Continued change needs openness -/

/-- Continued change needs openness, exactly. Under a census of what stands, some condition's
standing changes at arbitrarily late steps exactly when it changes at arbitrarily late steps
across which what stands does not run down. Across a step at which it runs down, a change
lowers the total standing, which never rises there, and every rise of the total is some
condition's rise. -/
theorem change_recurs_iff (census : W.StandingCensus stand) :
    (∀ N, ∃ t, N ≤ t ∧ ∃ c, W.Rises t c ∨ W.Falls t c) ↔
      ∀ N, ∃ t, N ≤ t ∧ ¬ L.RunsDown W t ∧ ∃ c, W.Rises t c ∨ W.Falls t c :=
  recurs_iff_unmet (r := fun t => W.stock (stand t) t)
    (fun _ runs changes => (runs.changes_iff census).mp changes)
    (fun _ runs => runs.standing_le census)
    fun _ up => match rise_of_standing census up with
      | ⟨c, rises⟩ => ⟨c, .inl rises⟩

/-- So with the exchange: under a census of what stands, something taking part takes or
gives, or some standing changes, at arbitrarily late steps exactly when this happens at
arbitrarily late steps across which what stands does not run down closed. -/
theorem exchange_recurs_iff (census : W.StandingCensus stand) :
    (∀ N, ∃ t, N ≤ t ∧ ((∃ f c, f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)) ∨
      ∃ c, W.Rises t c ∨ W.Falls t c)) ↔
      ∀ N, ∃ t, N ≤ t ∧ ¬ L.RunsDownClosed W t ∧
        ((∃ f c, f ∈ L.present t ∧ (0 < L.take t f c ∨ 0 < L.give t f c)) ∨
          ∃ c, W.Rises t c ∨ W.Falls t c) :=
  recurs_iff_unmet (r := fun t => W.stock (stand t) t)
    (fun _ runs event => match event with
      | .inl exchanges => (runs.exchanges_iff census).mp exchanges
      | .inr changes => (runs.runsDown.changes_iff census).mp changes)
    (fun _ runs => runs.runsDown.standing_le census)
    fun _ up => match rise_of_standing census up with
      | ⟨c, rises⟩ => .inr ⟨c, .inl rises⟩

/-! ## Running down bounds change -/

/-- Across a step at which what stands runs down, the total standing rises by nothing. -/
theorem RunsDown.rise_zero (census : W.StandingCensus stand) (runs : L.RunsDown W t) :
    rise (fun t => W.stock (stand t) t) t = 0 :=
  eq_zero_of_not_pos fun up => Nat.lt_irrefl _
    (Nat.lt_of_lt_of_le (excess_pos.mp up) (runs.standing_le census))

/-- And it falls exactly when some condition's standing changes. -/
theorem RunsDown.fall_pos_iff (census : W.StandingCensus stand) (runs : L.RunsDown W t) :
    0 < fall (fun t => W.stock (stand t) t) t ↔ ∃ c, W.Rises t c ∨ W.Falls t c :=
  excess_pos.trans (runs.changes_iff census).symm

/-- It falls by at least the number of formations taking from a family running down. -/
theorem RunsDownOn.takers_le_fall (census : W.StandingCensus stand) (runs : L.RunsDownOn W es t) :
    L.takers es t ≤ fall (fun t => W.stock (stand t) t) t :=
  match runs.stock_eq census, runs with
  | ⟨now, next⟩, ⟨_, _, _, balances, dissipates⟩ =>
    have fell := across (fun t => W.stock (stand t) t) t
    le_of_add_le_add_right (W.stock (stand (t + 1)) (t + 1)) (Nat.le_trans
      (Nat.le_of_eq (Nat.add_comm _ _)) (Nat.le_trans (Nat.le_trans
        (Nat.le_trans (Nat.le_of_eq (congrArg (· + L.takers es t) next))
          (Nat.le_trans (balances.runs_down dissipates) (Nat.le_of_eq now.symm)))
        (Nat.le_trans (Nat.le_add_right _ (rise (fun t => W.stock (stand t) t) t))
          (Nat.le_of_eq fell.symm))) (Nat.le_of_eq (Nat.add_comm _ _))))

/-- Change within standing. Under a census of what stands, over any stretch the conditions
standing at its end, with the steps of it at which the total standing fell, number at most
the total standing at its start with everything it rose over the stretch. -/
theorem standing_bounds_change (census : W.StandingCensus stand) (T n : Nat) :
    (stand (T + n)).length + count (steps T n) (fall fun t => W.stock (stand t) t) ≤
      W.stock (stand T) T + total (steps T n) (rise fun t => W.stock (stand t) t) :=
  Nat.le_trans (Nat.add_le_add (census.length_le_stock (T + n)) (count_le _ (steps T n)))
    (Nat.le_of_eq (over_stretch (fun t => W.stock (stand t) t) T n))

/-- Across a step at which what stands runs down, the total standing falls by at least
one wherever a positive count marks some condition's standing changing. -/
theorem RunsDown.lowers_mark (census : W.StandingCensus stand) (runs : L.RunsDown W t) {q : Nat}
    (changes : 0 < q → ∃ c, W.Rises t c ∨ W.Falls t c) :
    W.stock (stand (t + 1)) (t + 1) + mark (0 < q) ≤ W.stock (stand t) t :=
  mark_cases (q := fun m => W.stock (stand (t + 1)) (t + 1) + m ≤ W.stock (stand t) t)
    (fun positive => (runs.changes_iff census).mp (changes positive))
    fun _ => runs.standing_le census

/-- Running down bounds change. Under a census of what stands, over a stretch from `T`
across each step of which what stands is not refuted to run down, the conditions standing at
its end, with the steps of it at which some condition's standing changed, number at most the
total standing at `T`: those are the steps at which the total fell, which needs no decision
of whether a standing changed. -/
theorem runsDown_bounds_change (census : W.StandingCensus stand) {T n : Nat}
    (runs : ∀ t, t ∈ steps T n → ¬¬ L.RunsDown W t) :
    (stand (T + n)).length + count (steps T n) (fall fun t => W.stock (stand t) t) ≤
      W.stock (stand T) T :=
  Nat.le_trans (standing_bounds_change census T n)
    (Nat.le_of_eq ((congrArg (W.stock (stand T) T + ·)
      (total_eq_zero fun t mem => Decidable.of_not_not fun moved => runs t mem fun down =>
        moved (down.rise_zero census))).trans (Nat.add_zero _)))

/-- So for any counts of change. Under a census of what stands, with what stands not refuted
to run down across any step from `T` on, a count never exceeding the total standing, with
the steps since `T` at which counted ceasing or coming occurred, stays within the total
standing at `T`, wherever each such occurrence is some condition's standing changing. -/
theorem runsDown_change_bound (census : W.StandingCensus stand) {T : Nat}
    (runs : ∀ t, T ≤ t → ¬¬ L.RunsDown W t) {n c a : Nat → Nat}
    (within : ∀ t, T ≤ t → n t ≤ W.stock (stand t) t)
    (changes : ∀ t, T ≤ t → 0 < c t + a t → ∃ x, W.Rises t x ∨ W.Falls t x) :
    ChangeBound T (W.stock (stand T) T) n c a :=
  fun t later => Nat.le_trans (Nat.add_le_add_right (within t later) _)
    (falls_by_occurrences (fun t => W.stock (stand t) t) _ (fun s after =>
      Decidable.of_not_not fun no => runs s after fun down =>
        no (down.lowers_mark census (changes s after))) later)

end Flow

/-! ## Arising needs an active giver -/

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X} {xs : List X} {t : Nat} {x : X}

/-- With balance at an embodied relatum, embodied at both ends of the step, it arises
exactly when it stood at nothing and was given more than was taken from it. -/
theorem BalancesOn.arises_iff (balances : L.BalancesOn W xs t) (mem : x ∈ xs)
    (before : W.active t x ↔ 0 < W.level t x)
    (after : W.active (t + 1) x ↔ 0 < W.level (t + 1) x) :
    W.Arises t x ↔ W.level t x = 0 ∧ L.taken t x < L.given t x :=
  (show W.Arises t x ↔ W.ComesToStand t x from
    ⟨fun ⟨idle, active⟩ => ⟨fun stands => idle (before.mpr stands), after.mp active⟩,
     fun ⟨low, stands⟩ => ⟨fun active => low (before.mp active), after.mpr stands⟩⟩).trans
    (balances.comesToStand_iff mem)

/-- Arising needs an active giver: with balance at a relatum embodied at both ends of the
step, where only active formations give to it, an arising relatum is given to by an active
formation taking part, another than itself. -/
theorem BalancesOn.arises_given (balances : L.BalancesOn W xs t) (mem : x ∈ xs)
    (before : W.active t x ↔ 0 < W.level t x)
    (after : W.active (t + 1) x ↔ 0 < W.level (t + 1) x)
    (acting : ∀ f, f ∈ L.present t → 0 < L.give t f x → W.active t f) (arises : W.Arises t x) :
    ∃ f, W.active t f ∧ f ∈ L.present t ∧ 0 < L.give t f x ∧ f ≠ x :=
  match total_pos (L.present t) (Nat.lt_of_le_of_lt (Nat.zero_le _)
      ((balances.arises_iff mem before after).mp arises).2) with
  | ⟨f, present, gives⟩ =>
    have active := acting f present gives
    ⟨f, active, present, gives, fun same => arises.1 (Eq.subst (motive := fun g => W.active t g)
      same active)⟩

end Flow

/-! ## Ceasing needs arising -/

section Census

variable {α : Type}

/-- A list covers what holds at step `N`: every member of which the determination holds
there is on it. -/
def Covers (p : α → Nat → Prop) (L : List α) (N : Nat) : Prop :=
  ∀ a, p a N → a ∈ L

/-- A list holds exactly what holds at step `N`, each member once: a census at one step. -/
def ListsAt (p : α → Nat → Prop) (L : List α) (N : Nat) : Prop :=
  Distinct L ∧ ∀ a, p a N ↔ a ∈ L

/-- Nothing comes to be across the steps of the stretch of `n` steps from `N`. -/
def NoneComes (p : α → Nat → Prop) (N n : Nat) : Prop :=
  ∀ s a, N ≤ s → s < N + n → ¬ ComesToBe (p a) s

/-- What fails at `S` and comes to be at none of the `n` steps from `S` fails at each step
up to `S + n`; no decidability is needed. -/
theorem stays_failing_within {q : Nat → Prop} {S : Nat} (fails : ¬ q S) :
    ∀ {n}, (∀ k, k < n → ¬ ComesToBe q (S + k)) → ∀ k, k ≤ n → ¬ q (S + k)
  | _, _, 0, _ => fails
  | 0, _, _ + 1, within => absurd within (Nat.not_succ_le_zero _)
  | n + 1, still, k + 1, within => fun holds =>
    still k (Nat.lt_of_succ_le within)
      ⟨stays_failing_within fails (n := n)
        (fun j below => still j (Nat.lt_succ_of_lt below)) k (Nat.le_of_succ_le_succ within),
       holds⟩

/-! ### A relatum's occurrences along its steps

The census laws below are the root's covering laws (`«所覆后亡屡则有生»`, `«所覆后亡屡则生未否»`,
`«间无生则间亡不过所覆»`) at the relata's occurrences `(t, a)` where `p a t` holds, each step one
stage on along `Steps.along` within the class of the determination, where coming to be and ceasing
to be are a beginning and an ending (`comesToBe_iff_sheng_along`, `ceasesToBe_iff_wang_along`). -/

section Occurrences

variable {p : α → Nat → Prop}

/-- Each step along the steps is one stage on. -/
theorem Steps.along_stage :
    ∀ x y : Nat × α, «续» Steps.along (Steps.alikeAt p) x y → y.1 = x.1 + 1 :=
  fun _ _ ⟨⟨next, _⟩, _⟩ => next

/-- What holds of a relatum's occurrence is a region nothing outside continues into: the class of
its determination is two-valued. -/
theorem Steps.along_back :
    «闭» («逆» («续» Steps.along (Steps.alikeAt p))) (fun x : Nat × α => p x.2 x.1) :=
  fun _ _ h ⟨_, alike⟩ => alike.mpr h

/-- No occurrence continues as two along the steps (`Steps.along_fixed`), in any region. -/
theorem Steps.along_noSplit {P : Nat × α → Prop} :
    ∀ v b b' : Nat × α, P b → P b' → «续» Steps.along (Steps.alikeAt p) v b →
      «续» Steps.along (Steps.alikeAt p) v b' → b = b' :=
  fun v b b' _ _ c c' => «定后之逐点».mp (Steps.along_fixed (Steps.alikeAt p)) v b b' c c'

/-- A list covering what holds at `N` gives a list covering the occurrences at stage `N`. -/
theorem Covers.occurrences {L : List α} {N : Nat} (covers : Covers p L N) :
    ∀ x : Nat × α, p x.2 x.1 → x.1 = N → x ∈ L.map (fun a => (N, a))
  | (_, a), h, rfl => ListTests.mem_map_of (covers a h)

/-- Ceasing to be at arbitrarily late steps is an ending at arbitrarily late stages. -/
theorem Steps.along_ending (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∀ M, ∃ x : Nat × α, M ≤ x.1 ∧ p x.2 x.1 ∧ «亡» Steps.along (Steps.alikeAt p) x :=
  fun M => match ceasing M with
  | ⟨t, a, later, ceases⟩ => ⟨(t, a), later, ceasesToBe_iff_wang_along.mp ceases⟩

end Occurrences

section Decided

variable {p : α → Nat → Prop} [∀ a t, Decidable (p a t)]

/-- A list covering what holds at `N` covers every later step of a stretch across which
nothing comes to be. -/
theorem Covers.within {L : List α} {N n : Nat} (covers : Covers p L N)
    (none : NoneComes p N n) {k : Nat} (within : k ≤ n) : Covers p L (N + k) :=
  fun a holds => if held : p a N then covers a held
    else match came_between (Nat.le_add_right N k) held holds with
    | ⟨s, from_, below, comes⟩ =>
      absurd comes (none s a from_ (Nat.lt_of_lt_of_le below (Nat.add_le_add_left within N)))

/-- The cohort law: for any finite list, what holds of it at the end of a stretch with its
ceasings over the stretch is what held of it at the start exactly when none of it comes
to be across the stretch. No premise about the unfolding is used. -/
theorem cohort_closes_iff (L : List α) (N n : Nat) :
    total L (fun a => mark (p a (N + n))) + total (steps N n) (ceasings L p) =
        total L (fun a => mark (p a N)) ↔
      ∀ s a, s ∈ steps N n → a ∈ L → ¬ ComesToBe (p a) s :=
  ⟨fun closes _ _ mem memA comes =>
    Nat.lt_irrefl (total L fun a => mark (p a N))
      (Nat.lt_of_lt_of_le
        (Nat.lt_add_of_pos_right (total_pos_of_mem mem (total_pos_of_mem memA
          (mark_pos.mpr comes))))
        (Nat.le_of_eq ((held_over_stretch N n).symm.trans closes))),
   fun none => (held_over_stretch N n).trans (congrArg (_ + ·)
     ((total_congr_on fun s mem => (total_congr_on fun a memA =>
        mark_zero (none s a mem memA)).trans (total_zero L)).trans
       (total_zero (steps N n))))⟩

/-- Law 2, ceasing needs arising. With a list holding exactly what holds at `N`, each member
once, and nothing coming to be across the stretch of `n` steps from `N`: every relatum
holding at a step of the stretch is on the list, every relatum ceasing there is on it, and
what holds at the end with what ceased since `N` number exactly those holding at `N`. -/
theorem ceasing_needs_arising {L : List α} {N n : Nat} (lists : ListsAt p L N)
    (none : NoneComes p N n) :
    (∀ k, k ≤ n → Covers p L (N + k)) ∧
      (∀ s a, N ≤ s → s < N + n → CeasesToBe (p a) s → a ∈ L) ∧
      total L (fun a => mark (p a (N + n))) + total (steps N n) (ceasings L p) = L.length :=
  have covers : Covers p L N := fun a held => (lists.2 a).mp held
  ⟨fun _ within => covers.within none within,
   fun _ a from_ below ceases => match le_dest from_ with
    | ⟨_, same⟩ => covers.within none
        (Nat.le_of_lt (Nat.lt_of_add_lt_add_left (n := N) (same ▸ below)))
        a (Eq.subst (motive := fun t => p a t) same ceases.1),
   ((cohort_closes_iff L N n).mpr fun s a mem _ => none s a (steps_mem mem)
      (steps_within mem)).trans
     ((total_congr_on fun a mem => mark_one ((lists.2 a).mpr mem)).trans (total_ones L))⟩

/-- Under a decided determination, an occurrence that holds begins or has a predecessor along the
steps: at step `0` it begins (`Steps.along_sheng_zero`); after it, it has one where the relatum held
a step before, and comes to be where not. -/
theorem Steps.along_decided :
    ∀ y : Nat × α, p y.2 y.1 →
      «生» Steps.along (Steps.alikeAt p) y ∨ «有前» Steps.along (Steps.alikeAt p) y
  | (0, a), _ => .inl (Steps.along_sheng_zero _ a)
  | (t + 1, a), h =>
    if held : p a t then .inr (Steps.along_hasPred_iff.mpr ⟨fun _ => h, fun _ => held⟩)
    else .inl (comesToBe_iff_sheng_along.mp ⟨held, h⟩).2

/-- Ceasing at arbitrarily late steps, with a list covering step `N`, needs coming to be at
some step from `N`: the root's `«所覆后亡屡则有生»` at the relata's occurrences, whether a relatum
held a step before decided. A beginning after stage `N` lies at a step `t + 1` with `N ≤ t`, coming
to be across the step from `t`. -/
theorem Covers.coming_from_of_ceasing {L : List α} {N : Nat} (covers : Covers p L N)
    (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∃ s a, N ≤ s ∧ ComesToBe (p a) s :=
  match «所覆后亡屡则有生» (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
      Steps.along_stage Steps.along_back Steps.along_noSplit covers.occurrences
      (fun y h _ => Steps.along_decided y h) (Steps.along_ending ceasing) with
  | ⟨(0, _), late, _, _⟩ => absurd late (Nat.not_lt_zero N)
  | ⟨(t + 1, a), late, h, b⟩ =>
    ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- Where some list covers what holds at arbitrarily late steps, ceasing at arbitrarily
late steps needs coming to be at arbitrarily late steps. -/
theorem coming_of_ceasing_covered (covered : ∀ M, ∃ N L, M ≤ N ∧ Covers p L N)
    (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ∀ M, ∃ t a, M ≤ t ∧ ComesToBe (p a) t :=
  fun M => match covered M with
  | ⟨_, _, later, covers⟩ => match covers.coming_from_of_ceasing ceasing with
    | ⟨s, a, from_, comes⟩ => ⟨s, a, Nat.le_trans later from_, comes⟩

omit [∀ a t, Decidable (p a t)] in
/-- A census covers what holds at every step. -/
theorem Listed.covered {l : Nat → List α} (listed : Listed p l) :
    ∀ M, ∃ N L, M ≤ N ∧ Covers p L N :=
  fun M => ⟨M, l M, Nat.le_refl M, fun a held => ((listed M).2 a).mp held⟩

end Decided

/-! ## Without decidability -/

section Undecided

variable {p : α → Nat → Prop}

/-- With a list covering what holds at `N` and nothing coming to be across a stretch from
`N`, no more steps of the stretch see something cease than the list has members: the root's
`«间无生则间亡不过所覆»` at the relata's occurrences, each ceasing step read as an occurrence that ends
there (`exists_pairs_over`), distinct steps giving distinct occurrences. No decidability is
needed. -/
theorem Covers.ceasing_steps_within {L : List α} {N n : Nat} (covers : Covers p L N)
    (none : NoneComes p N n) {E : List Nat} (distinct : Distinct E)
    (ceasing : ∀ t, t ∈ E → N ≤ t ∧ t < N + n ∧ ∃ a, CeasesToBe (p a) t) :
    E.length ≤ L.length :=
  match exists_pairs_over (Q := fun t a => N ≤ t ∧ t < N + n ∧ CeasesToBe (p a) t)
      (fun t mem => match ceasing t mem with
        | ⟨from_, below, a, ceases⟩ => ⟨a, from_, below, ceases⟩) with
  | ⟨D, same, all⟩ =>
    Nat.le_trans (Nat.le_of_eq ((congrArg List.length same).symm.trans (length_map Prod.fst D)))
      (Nat.le_trans («间无生则间亡不过所覆» (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
          (U := N + n) Steps.along_stage Steps.along_back Steps.along_noSplit covers.occurrences
          (fun z hz late below b => match z, hz, late, below, b with
            | (0, _), _, late, _, _ => Nat.not_lt_zero N late
            | (s + 1, c), hz, late, below, b => none s c (Nat.le_of_lt_succ late)
                (Nat.lt_trans (Nat.lt_succ_self s) below) (comesToBe_iff_sheng_along.mpr ⟨hz, b⟩))
          (distinct_of_map (Eq.subst (motive := Distinct) same.symm distinct))
          fun x mx => ⟨(all x mx).1, (all x mx).2.1, (all x mx).2.2.1,
            (ceasesToBe_iff_wang_along.mp (all x mx).2.2).2⟩)
        (Nat.le_of_eq (length_map _ L)))

/-- Where something ceases at arbitrarily late steps, any number of distinct steps from `N`
see something cease, all before some step. -/
theorem ceasing_steps_found (ceasing : ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) (N : Nat) :
    ∀ k, ∃ E U, Distinct E ∧ E.length = k ∧ N ≤ U ∧
      ∀ t, t ∈ E → N ≤ t ∧ t < U ∧ ∃ a, CeasesToBe (p a) t
  | 0 => ⟨[], N, trivial, rfl, Nat.le_refl N, fun _ mem => nomatch mem⟩
  | k + 1 => match ceasing_steps_found ceasing N k with
    | ⟨E, U, distinct, length, from_, all⟩ => match ceasing U with
      | ⟨t, a, later, ceases⟩ =>
        ⟨t :: E, t + 1,
         ⟨fun mem => Nat.lt_irrefl t (Nat.lt_of_lt_of_le (all t mem).2.1 later), distinct⟩,
         congrArg Nat.succ length,
         Nat.le_trans from_ (Nat.le_trans later (Nat.le_succ t)),
         fun s mem => match mem_cons_cases mem with
           | .inl same => Eq.subst (motive := fun x => N ≤ x ∧ x < t + 1 ∧
                 ∃ a, CeasesToBe (p a) x) same.symm
               ⟨Nat.le_trans from_ later, Nat.lt_succ_self t, a, ceases⟩
           | .inr mem => ⟨(all s mem).1,
               Nat.lt_of_lt_of_le (all s mem).2.1 (Nat.le_trans later (Nat.le_succ t)),
               (all s mem).2.2⟩⟩

/-- With a list covering what holds at `N`, a later ceasing left unrefuted after every step
refutes that nothing comes to be from `N` on: `Covers.coming_from_of_ceasing` doubly negated, with no
decidability, the root's `«所覆后亡屡则生未否»` at the relata's occurrences. Ceasing at arbitrarily
late steps is the case it was first stated for. -/
theorem Covers.not_not_coming_from {L : List α} {N : Nat} (covers : Covers p L N)
    (ceasing : ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t) :
    ¬ ¬ ∃ s a, N ≤ s ∧ ComesToBe (p a) s :=
  fun nothing => «所覆后亡屡则生未否» (τ := Prod.fst) (P := fun x : Nat × α => p x.2 x.1)
    Steps.along_stage Steps.along_back Steps.along_noSplit covers.occurrences
    (fun M no => ceasing M fun ⟨t, a, later, ceases⟩ =>
      no ⟨(t, a), later, ceasesToBe_iff_wang_along.mp ceases⟩)
    fun ⟨y, late, h, b⟩ => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero N late
      | (t + 1, a), late, h, b =>
        nothing ⟨t, a, Nat.le_of_lt_succ late, comesToBe_iff_sheng_along.mpr ⟨h, b⟩⟩

/-- With a list covering what holds at `N` and nothing coming to be from `N` on, that ceasing
stops from some step on cannot be refuted: it is not the case that after every step a later
ceasing stays unrefuted (`stop_unrefuted_iff` reads it), by `Covers.not_not_coming_from`. No
decidability is needed. -/
theorem Covers.ceasing_stops_unrefuted {L : List α} {N : Nat} (covers : Covers p L N)
    (none : ∀ n, NoneComes p N n) : ¬ ∀ M, ¬ ¬ ∃ t a, M ≤ t ∧ CeasesToBe (p a) t :=
  fun ceasing => covers.not_not_coming_from ceasing fun ⟨s, a, from_, comes⟩ =>
    none (s + 1) s a from_
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self s) (Nat.le_add_left (s + 1) N)) comes

/-- With a list covering what holds at `N` and nothing coming to be from `N` on, ceasing does
not recur: the weaker form of `Covers.ceasing_stops_unrefuted`. No decidability is needed. -/
theorem Covers.ceasing_not_recurring {L : List α} {N : Nat} (covers : Covers p L N)
    (none : ∀ n, NoneComes p N n) : ¬ ∀ M, ∃ t a, M ≤ t ∧ CeasesToBe (p a) t :=
  fun ceasing => covers.ceasing_stops_unrefuted none fun M no => no (ceasing M)

end Undecided

end Census

end Becoming
