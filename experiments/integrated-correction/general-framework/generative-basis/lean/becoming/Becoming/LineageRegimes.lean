import Becoming.LineageRegions
import Becoming.Continuation
import Becoming.MutualDependence
import Becoming.Population

/-!
# Regime, not level: what decides a lineage's region, and what the stock sets

`Becoming.Continuation`, `Becoming.Reproduction` and `Becoming.MutualDependence` state three laws
that end what depends on a flow: renewal run past what it gives
(`Flow.excess_bounded`, `Flow.family_excess_bounded`, `Flow.joint_excess_ends`,
`Flow.family_excess_ends`); a lineage within a family dissipated on
(`Reproduction.Flow.lineage_ends`); and a draw on a condition given nothing
(`Flow.Balances.doubling_needs`). `Becoming.LineageRegions` reads a lineage on the map's regions.
This module reads each of the three laws, as a decider of a lineage's region under a premise on
the line's reach, as a regime with a horizon computed from the stock; shows that the stock alone
decides neither fate, at every stock; gives the draw a law on takers that need it; and gives the
boundary where none of the three binds. `Flow.joint_excess_ends` gets no lineage reading here.
The grains: the coarse class is a kind (`Web.kindClass`), the fine class the carrier
(`Web.carrierClass`, read as the organism); `«退化»` is stated at the kind grain, `«生成»` at
(kind, carrier).

* **Renewal run past what it gives (horizon wrappers).** Under balance,
  `n` steps of joint excess at a condition need its level to be at least `n`
  (`excess_within_level`), and `n` steps of excess of a family's uptake over its replenishment need
  its stock to be at least `n` (`family_excess_within_stock`), so no course has `stock + 1` such
  steps (`family_excess_not_past_stock`). These read `Flow.excess_bounded` and
  `Flow.family_excess_bounded` and are restatements, not results.
* **Renewal run past what it gives, on a lineage (new premise: the line's reach).** Where the flow
  balances and activity needs support, `n` steps of excess from a stock below `n + m` leave the
  family's stock below `m` at `T + n` (`Flow.below_of_excess`), whatever renews it. Read on a lineage,
  the line from an active occurrence at a step not after `T + n` degenerates (`«退化»`, at the kind
  grain) where everything it reaches at `T + n` requires a member of `ds` at a need of at least `m`
  (`degeneration_of_family_excess`, the lineage reading at the kind grain of EL3's
  `Web.family_excess_degenerates`, not a further result); where the census holds every continuation
  (`LineageRegions.ContinuationsListed`), it is enough that every member of generation `T + n` so
  depends (`degeneration_of_family_excess_listed`). At need one the horizon is the stock itself:
  `stock` steps of excess suffice (`degeneration_at_stock_horizon`), and no course has more. A gate on
  the renewal, with only active formations giving, makes the formations' end last
  (`Flow.family_excess_ends`); these laws do not use it. The premise on the line's reach is what the
  lineage reading adds.
* **Dissipation within the family (a corollary).** In `Descended` generations whose offspring
  stand within a family balanced and dissipated on across each step up to its stock, where the
  census holds every continuation, the line from every member of every generation degenerates
  (`dissipation_degenerates_every_member`): up to `stock + 1` by
  `LineageRegions.degeneration_of_dissipation`, and after it there are no members
  (`Reproduction.Flow.lineage_ends`, `Reproduction.Generations.empty_from`).
* **A draw on a condition given nothing (a generalization of `doubling_needs`).** Under balance,
  with nothing given to a condition across `n` steps, where the draw at the `j`-th of them is at
  least `2 ^ j`, the condition's level at the start is at least `2 ^ n - 1`:
  `2 ^ n ≤ level + 1` (`draw_doubling_needs`). A draw exceeding everything drawn before is at least
  `2 ^ j` at its `j`-th step (`exceeds_doubles`), so `Flow.Balances.doubling_needs` is the case of
  it (`doubling_needs_of_draw`).
* **Takers that need the draw.** Generations of takers from at least one, each
  generation at least doubling the one before (`multiplies`), each generation drawing at least a
  unit per member, on a condition given nothing, last at most `log₂ (level + 1)` generations:
  `2 ^ n ≤ level + 1` (`multiplying_takers_need`). Where each active member takes part and takes
  from the condition, and no generation lists a member twice, a generation draws at least its size
  (`size_le_taken`), so where `level + 1 < 2 ^ n` not every member of the first `n` generations
  stays active (`multiplying_takers_stop`). The premise that the condition is given nothing is
  kept in both statements. In `multiplying_takers_stop`, needing the take means being active only
  while taking (the premise `needs`); `Web.need` does not enter. The variant
  `multiplying_takers_stop_of_need` reads the need through the web: each active member requires
  the condition at a need of at least one and takes at least its need (the link from need to take
  is supplied: in the model a requirement by itself sets a support threshold and draws nothing).
  `MultiplyingTakers` meets every premise of both at level three: one taker, then two, each
  requiring the pool at need one and taking one unit; the pool stands at `3`, `2`, then nothing;
  every one of the four takers born at step two is unsupported and inactive, the generation after
  them is empty, and the line from the first degenerates (`MultiplyingTakers.multiplying`). In
  `DoublingDraw` (`Becoming.MutualDependence`) the formation needs nothing and ends nothing; here
  the takers require the pool at need one and end.
* **The stock decides neither fate.** A *handover* on two relata (`Handover.flow`): the
  relatum whose turn it is holds the step's amount, takes all of it from itself and hands the next
  step's amount to the other, each relatum active exactly while it stands and requiring its own
  standing at need one. Every handover balances (`Handover.balances`), its stock at each step is the
  step's amount (`Handover.stock_eq`), and the giver depends on a member of the pair at need one
  (`Handover.gated`). With the amount `s` at every step, the relay (`Handover.relay`): no excess, no
  dissipation, a lineage of one member per generation that generates (`«生成»`) at (kind, carrier)
  (`Handover.relay_generates`). At stock one its flow and levels are those of
  `Reproduction.Relay`; its web differs (`Handover.relay_one_flow`). With the amount `s - t`, the
  run-down (`Handover.runDown`): `s` steps of excess of the pair's uptake over its replenishment,
  dissipation at every step, and the line degenerates (`«退化»`), derived through the regime of excess
  at its horizon (`Handover.runDown_degenerates`); the census holds every continuation
  (`Handover.runDown_listed`), so the census reading of the regime of excess and the dissipation
  corollary apply too, generation `s` is empty and `lineage_ends` holds, while no handover meets
  the draw regime's premise over two or more steps (no condition is drawn on at least once and
  then at least twice at the next step, `Handover.draw_not_doubling`) (`Handover.runDown_every_regime`). These witnesses show that the
  premises hold together, not that a regime is needed: the census reading's premise on generation
  `s` holds vacuously, that generation being empty, and the run-down's degeneration follows from
  nothing being active at step `s` alone. For every stock `s ≥ 1` the two courses start from the
  same stock `s` (`Handover.both_fates`), so no verdict on the region follows from the stock alone
  (`stock_forces_neither`, under `GatedPairCourse`, which lists the premises both courses meet;
  a restatement of the pair with `«生成退化不并»`).
* **Renewal from outside: where none of the regimes binds (boundary).** In `FromOutside` a renewer
  gives two units at every step and does not require the condition; two takers each take one, each
  within what is given and together within it; nothing is in excess, the condition is fed and not
  dissipated on, and every formation is active and supported at every step
  (`FromOutside.from_outside`), so none of the three regimes' premises holds; a gate on the renewal
  fails too, at every need (`FromOutside.not_gated`). In the model a formation's giving is not drawn from
  its own level unless it takes, so "from outside" means from no listed condition.
  `Alone` (`Becoming.Continuation`) is the gated neighbour: its renewer requires the condition,
  which is never run past.

What the three regimes share, and what the module claims: each of the three landed ending laws,
read as a decider of a lineage's region under the premise on the line's reach, is a regime (gating
with excess, dissipation, a draw on a condition given nothing), and the stock enters each only as
the horizon: `stock` steps of excess at most, `stock + 1` generations under dissipation,
`log₂ (level + 1)` steps of a doubling draw (the level of the condition drawn on). The
classification is of these three laws.

Not shown: which member of the takers' generations stops, and at which step (naming one asks to
decide activity, which is Prop-valued); that multiplying takers degenerate on the map in general
(the witness reads it, through EL3's `Web.kind_every_branch_ends_of_gone`); that every decider of a
lineage's region is one of the three regimes; that any actual flow meets the premises.

Modelling choices: discrete steps; natural-number levels, needs, gifts, takes and offspring
numbers; activity Prop-valued; giving not drawn from the giver's own level unless it takes (so a
renewer can give from no listed condition); descent as giving to what comes to stand on
`Flow X X`; generations listed (`SelectionTerm.Generations`), so the takers' sizes are census
sizes and each generation is asked to list no member twice; kinds supplied (`oneKind` in the
witnesses). An empty axiom report says nothing of these.

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace LineageRegimes

open LineageRegions

/-! ## Renewal run past what it gives: the horizon -/

section Horizon

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **Joint excess within the level** (a restatement of `Flow.excess_bounded`): under balance,
`n` steps of joint excess at a condition from `T` need its level at `T` to be at least `n`. -/
theorem excess_within_level (balances : L.Balances W) {c : C} {T n : Nat}
    (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c) : n ≤ W.level T c :=
  Nat.le_trans (Nat.le_add_left n _) (Flow.excess_bounded balances n excess)

/-- **Excess of a family within its stock** (a restatement of `Flow.family_excess_bounded`):
under balance, `n` steps of excess of a family's uptake over its replenishment from `T` need its
stock at `T` to be at least `n`. -/
theorem family_excess_within_stock (balances : L.Balances W) {ds : List C} {T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) :
    n ≤ W.stock ds T :=
  Nat.le_trans (Nat.le_add_left n _) (Flow.family_excess_bounded balances n excess)

/-- **No course has `stock + 1` steps of excess**: from stock `s`, at most `s` steps. -/
theorem family_excess_not_past_stock (balances : L.Balances W) {ds : List C} {T : Nat} :
    ¬ ∀ k, k < W.stock ds T + 1 → L.replenishment ds (T + k) < L.uptake ds (T + k) :=
  fun excess => Nat.not_succ_le_self _ (family_excess_within_stock balances excess)

end Horizon

/-! ## Renewal run past what it gives, on a lineage -/

section Excess

variable {X : Type} {L : Flow X X} {W : Web X X} {Q : X → X → Prop}

/-- **Renewal run past what it gives ends a lineage on every branch** (a lineage reading, not a
further result: the kind-grain counterpart of EL3's `Web.family_excess_degenerates`, composing
`Flow.below_of_excess` and `Flow.family_ends_below_at` with EL3's
`Web.kind_every_branch_ends_of_gone`). Where the flow balances and activity needs support, `n` steps
of excess of the family's uptake over its replenishment from `T`, starting from a stock below
`n + m`, end the line from an active occurrence at a step not after `T + n` on every branch at the
kind grain, where everything the line reaches at `T + n` requires a member of `ds` at a need of at
least `m`, whatever renews the family. -/
theorem degeneration_of_family_excess (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  Web.kind_every_branch_ends_of_gone (W := W) (R := continuation L W Q) active le fun y hy at_ =>
    match depends y hy at_ with
    | ⟨e, inside, req, high⟩ =>
      have ends : W.requires (T + n) y.2 e → m ≤ W.need (T + n) y.2 e →
          ¬ W.active (T + n) y.2 :=
        Flow.family_ends_below_at (dependent (T + n) y.2) (Flow.below_of_excess balances excess start)
          inside
      Eq.subst (motive := fun s => W.requires s y.2 e → m ≤ W.need s y.2 e → ¬ W.active s y.2)
        at_.symm ends req high

/-- **The same, read on the census** (a restatement of `degeneration_of_family_excess` through
`LineageRegions.reached_listed`): where the census holds every continuation at the kind grain and
every member of generation `T + n` requires a member of `ds` at a need of at least `m`, the line
from every active member of a generation not after `T + n` degenerates. -/
theorem degeneration_of_family_excess_listed (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {G : SelectionTerm.Generations X}
    (listed : ContinuationsListed (lineStep L W Q) (W.kindClass Q) G)
    (members : ∀ q, q ∈ G.family (T + n) →
      ∃ e, e ∈ ds ∧ W.requires (T + n) q e ∧ m ≤ W.need (T + n) q e)
    {t : Nat} {p : X} (mp : p ∈ G.family t) (active : W.active t p) (le : t ≤ T + n) :
    «退化» (lineStep L W Q) (W.kindClass Q) (t, p) :=
  degeneration_of_family_excess balances dependent excess start (x := (t, p)) active
    le fun y hy at_ =>
      Eq.subst (motive := fun s => ∃ e, e ∈ ds ∧ W.requires s y.2 e ∧ m ≤ W.need s y.2 e)
        at_.symm (members y.2 (Eq.subst (motive := fun s => y.2 ∈ G.family s) at_
          (reached_listed listed mp hy)))

/-- **At need one the horizon is the stock** (a restatement of `degeneration_of_family_excess` at
`m = 1`, `n = stock`): `stock` steps of excess from `T` end the line from an active occurrence at a
step not after `T + stock`, where everything it reaches then requires a member at need at least
one. No course has more such steps (`family_excess_not_past_stock`). -/
theorem degeneration_at_stock_horizon (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List X}
    {T : Nat}
    (excess : ∀ k, k < W.stock ds T → L.replenishment ds (T + k) < L.uptake ds (T + k))
    {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + W.stock ds T)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + W.stock ds T →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ 1 ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  degeneration_of_family_excess balances dependent excess (Nat.lt_succ_self _) active
    le depends

end Excess

/-! ## Dissipation within the family -/

section Dissipation

variable {X : Type} {L : Flow X X} {W : Web X X} {Q : X → X → Prop}

/-- **Under dissipation every member's line degenerates** (a corollary of
`LineageRegions.degeneration_of_dissipation`): in `Descended` generations whose offspring stand
within a family balanced and dissipated on across each step up to its stock, where the census
holds every continuation, the line from every member of every generation ends on every branch;
after `stock + 1` generations there are none. -/
theorem dissipation_degenerates_every_member {G : SelectionTerm.Generations X} {ds : List X}
    (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (balances : ∀ t, t < W.stock ds 0 + 1 → L.BalancesOn W ds t)
    (dissipates : ∀ t, t < W.stock ds 0 + 1 → L.DissipatesOn ds t) {Lc : «际» (Nat × X)}
    (listed : ContinuationsListed (lineStep L W Q) Lc G) {t : Nat} {p : X}
    (mp : p ∈ G.family t) : «退化» (lineStep L W Q) Lc (t, p) :=
  match Nat.decLe t (W.stock ds 0 + 1) with
  | .isTrue le => degeneration_of_dissipation descended within balances dissipates listed mp le
  | .isFalse late => match le_dest (Nat.le_of_lt (Nat.gt_of_not_le late)) with
    | ⟨d, at_⟩ =>
      have empty : G.size t = 0 := Eq.subst (motive := fun s => G.size s = 0) at_.symm
        (Reproduction.Generations.empty_from
          (Reproduction.Flow.lineage_ends descended within balances dissipates) d)
      nomatch (Eq.subst (motive := fun l => p ∈ l)
        (nil_of_length_zero (g := G.family t) empty) mp)

end Dissipation

/-! ## A draw on a condition given nothing -/

/-- **Draws at least doubling what is drawn**: where the draw at each step `j` before `n` is at
least `2 ^ j`, two to the `j` is at most what has been drawn before `j`, plus one, for every `j`
up to `n`. -/
theorem pow_le_drawnBefore_of_ge {draw : Nat → Nat} {n : Nat}
    (doubles : ∀ j, j < n → 2 ^ j ≤ draw j) :
    ∀ j, j ≤ n → 2 ^ j ≤ drawnBefore draw j + 1
  | 0, _ => Nat.le_refl 1
  | j + 1, le =>
    have ih := pow_le_drawnBefore_of_ge doubles j (Nat.le_of_succ_le le)
    Nat.le_trans (Nat.le_of_eq (Nat.mul_two (2 ^ j)))
      (Nat.le_trans (Nat.add_le_add ih (doubles j (Nat.lt_of_succ_le le)))
        (Nat.le_of_eq (Nat.add_right_comm (drawnBefore draw j) 1 (draw j))))

/-- A draw exceeding everything drawn before it is at least `2 ^ j` at its `j`-th step. -/
theorem exceeds_doubles {draw : Nat → Nat} {n : Nat}
    (exceeds : ∀ j, j < n → drawnBefore draw j < draw j) : ∀ j, j < n → 2 ^ j ≤ draw j :=
  fun j lt => Nat.le_trans (pow_le_drawnBefore exceeds j (Nat.le_of_lt lt))
    (Nat.succ_le_of_lt (exceeds j lt))

section Draw

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **A draw at least doubling needs a doubled level.** Under balance, with nothing given to `c`
across the steps from `T` before `T + n`, where the draw at `T + j` is at least `2 ^ j`, the level
at `T` is at least `2 ^ n - 1`. -/
theorem draw_doubling_needs (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0)
    (doubles : ∀ j, j < n → 2 ^ j ≤ L.taken (T + j) c) : 2 ^ n ≤ W.level T c + 1 :=
  Nat.le_trans (pow_le_drawnBefore_of_ge (draw := fun i => L.taken (T + i) c) doubles n
      (Nat.le_refl n))
    (Nat.add_le_add_right (Flow.Balances.drawn_within balances unfed) 1)

/-- `Flow.Balances.doubling_needs` is the case of `draw_doubling_needs` (a restatement, so that the
generalization is checked). -/
theorem doubling_needs_of_draw (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0)
    (exceeds : ∀ j, j < n → drawnBefore (fun i => L.taken (T + i) c) j < L.taken (T + j) c) :
    2 ^ n ≤ W.level T c + 1 :=
  draw_doubling_needs balances unfed (exceeds_doubles exceeds)

end Draw

/-! ## Takers that need the draw -/

section Takers

variable {F C : Type} {L : Flow F C} {W : Web F C} {G : SelectionTerm.Generations F}

/-- Generations from at least one, each at least doubling the one before, have at least `2 ^ j`
members at the `j`-th. -/
theorem sizes_double {T n : Nat} (first : 1 ≤ G.size T)
    (multiplies : ∀ j, j + 1 < n → 2 * G.size (T + j) ≤ G.size (T + j + 1)) :
    ∀ j, j < n → 2 ^ j ≤ G.size (T + j)
  | 0, _ => first
  | j + 1, lt =>
    have ih := sizes_double first multiplies j (Nat.lt_of_succ_lt lt)
    Nat.le_trans (Nat.le_of_eq (Nat.mul_comm (2 ^ j) 2))
      (Nat.le_trans (Nat.mul_le_mul_left 2 ih) (multiplies j lt))

/-- **A generation draws at least its size** where it lists no member twice and each member takes
part and takes from the condition. -/
theorem size_le_taken {t : Nat} {c : C} (distinct : Distinct (G.family t))
    (takes : ∀ p, p ∈ G.family t → p ∈ L.present t ∧ 0 < L.take t p c) :
    G.size t ≤ L.taken t c :=
  Nat.le_trans (length_le_count (q := fun f => L.take t f c) distinct takes)
    (count_le _ (L.present t))

/-- **Multiplying takers need a doubled level** (a corollary: `draw_doubling_needs` composed with
`sizes_double`). Under balance, with nothing given to `c` across
the steps from `T` before `T + n`, generations of takers from at least one, each at least doubling
the one before, each drawing from `c` at least a unit per member, need the level of `c` at `T` to be
at least `2 ^ n - 1`: they last at most `log₂ (level + 1)` generations. -/
theorem multiplying_takers_need (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0) (first : 1 ≤ G.size T)
    (multiplies : ∀ j, j + 1 < n → 2 * G.size (T + j) ≤ G.size (T + j + 1))
    (draws : ∀ j, j < n → G.size (T + j) ≤ L.taken (T + j) c) :
    2 ^ n ≤ W.level T c + 1 :=
  draw_doubling_needs balances unfed fun j lt =>
    Nat.le_trans (sizes_double first multiplies j lt) (draws j lt)

/-- **Takers that need their take stop within the bound.** Under the premises of
`multiplying_takers_need` with the draw read off its takers (each generation lists no member
twice; each active member takes part and takes from `c`), where `level + 1 < 2 ^ n`, not every
member of the first `n` generations stays active. The condition is given nothing across the
`n` steps. Here needing the take means being active only while taking (`needs`); `Web.need` and
`Web.requires` do not enter (for that reading, `multiplying_takers_stop_of_need`). -/
theorem multiplying_takers_stop (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0) (first : 1 ≤ G.size T)
    (multiplies : ∀ j, j + 1 < n → 2 * G.size (T + j) ≤ G.size (T + j + 1))
    (distinct : ∀ j, j < n → Distinct (G.family (T + j)))
    (needs : ∀ j p, j < n → p ∈ G.family (T + j) → W.active (T + j) p →
      p ∈ L.present (T + j) ∧ 0 < L.take (T + j) p c)
    (beyond : W.level T c + 1 < 2 ^ n) :
    ¬ ∀ j p, j < n → p ∈ G.family (T + j) → W.active (T + j) p :=
  fun all => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le beyond
    (multiplying_takers_need balances unfed first multiplies fun j lt =>
      size_le_taken (distinct j lt) fun p mp => needs j p lt mp (all j p lt mp)))

/-- **Takers requiring the condition stop within the bound** (a variant of
`multiplying_takers_stop` with the need read through the web). Under the premises of
`multiplying_takers_need`, where each generation lists no member twice and each active member of
the first `n` generations takes part, requires `c` at a need of at least one and takes from `c` at
least its need, and where `level + 1 < 2 ^ n`, not every member of the first `n` generations stays
active. The link from need to take (`need ≤ take`) is a supplied premise: in the model a
requirement by itself sets only a support threshold and draws nothing. The requirement
(`W.requires`) is carried for the reading and not used in the proof. -/
theorem multiplying_takers_stop_of_need (balances : L.Balances W) {c : C} {T n : Nat}
    (unfed : ∀ i, i < n → L.given (T + i) c = 0) (first : 1 ≤ G.size T)
    (multiplies : ∀ j, j + 1 < n → 2 * G.size (T + j) ≤ G.size (T + j + 1))
    (distinct : ∀ j, j < n → Distinct (G.family (T + j)))
    (takesNeed : ∀ j p, j < n → p ∈ G.family (T + j) → W.active (T + j) p →
      p ∈ L.present (T + j) ∧ W.requires (T + j) p c ∧ 1 ≤ W.need (T + j) p c ∧
        W.need (T + j) p c ≤ L.take (T + j) p c)
    (beyond : W.level T c + 1 < 2 ^ n) :
    ¬ ∀ j p, j < n → p ∈ G.family (T + j) → W.active (T + j) p :=
  multiplying_takers_stop balances unfed first multiplies distinct
    (fun j p lt mp act => match takesNeed j p lt mp act with
      | ⟨present, _, one, within⟩ => ⟨present, Nat.lt_of_lt_of_le one within⟩)
    beyond

end Takers

/-! ## Witnesses -/

/-! ### Multiplying takers on a pool of three -/

namespace MultiplyingTakers

/-! Formations are numbered as a binary tree: `0` is the pool, `1` the first taker, and the
offspring of `k` are `2 * k` and `2 * k + 1`; the takers are `1` to `7`. -/

/-- The first taker takes part across the first step, its two offspring across the second, then
nothing. -/
def present : Nat → List Nat
  | 0 => [1]
  | 1 => [2, 3]
  | _ + 2 => []

/-- Each taker taking part takes one unit from the pool. -/
def take (_ _ : Nat) : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

/-- Each taker gives one unit to each of its two offspring. -/
def give (_ : Nat) : Nat → Nat → Nat
  | 1, 2 => 1
  | 1, 3 => 1
  | 2, 4 => 1
  | 2, 5 => 1
  | 3, 6 => 1
  | 3, 7 => 1
  | _, _ => 0

def flow : Flow Nat Nat := ⟨present, take, give⟩

/-- The pool stands at three, two, then nothing; each taker stands from its birth. -/
def level : Nat → Nat → Nat
  | 0, 0 => 3
  | 0, 1 => 1
  | 1, 0 => 2
  | 1, 1 => 1
  | 1, 2 => 1
  | 1, 3 => 1
  | _ + 2, 1 => 1
  | _ + 2, 2 => 1
  | _ + 2, 3 => 1
  | _ + 2, 4 => 1
  | _ + 2, 5 => 1
  | _ + 2, 6 => 1
  | _ + 2, 7 => 1
  | _, _ => 0

/-- Each taker requires the pool. -/
def needsPool : Nat → Nat → Prop
  | 0, _ => False
  | _ + 1, 0 => True
  | _ + 1, _ + 1 => False

/-- A taker is active exactly while it takes part; each requires the pool at need one. -/
def web : Web Nat Nat where
  level := level
  active t x := x ∈ present t
  requires _ := needsPool
  need _ _ _ := 1
  draws _ := needsPool

def kids : Nat → Nat → List Nat
  | 0, 1 => [2, 3]
  | 1, 2 => [4, 5]
  | 1, 3 => [6, 7]
  | _, _ => []

def generations : SelectionTerm.Generations Nat where
  first := [1]
  kids := kids
  amount _ _ := 0

theorem balances : flow.Balances web
  | 0, c => match c with
    | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | 4 => rfl | 5 => rfl | 6 => rfl | 7 => rfl
    | _ + 8 => rfl
  | 1, c => match c with
    | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | 4 => rfl | 5 => rfl | 6 => rfl | 7 => rfl
    | _ + 8 => rfl
  | _ + 2, c => match c with
    | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | 4 => rfl | 5 => rfl | 6 => rfl | 7 => rfl
    | _ + 8 => rfl

theorem unfed : ∀ i, flow.given i 0 = 0
  | 0 => rfl
  | 1 => rfl
  | _ + 2 => rfl

theorem acting : flow.Acting web := fun _ _ _ mem _ => mem

theorem pool_of_needs : ∀ {x c : Nat}, needsPool x c → c = 0
  | 0, _, no => no.elim
  | _ + 1, 0, _ => rfl
  | _ + 1, _ + 1, no => no.elim

/-- Active only while the pool stands: the takers taking part are supported. -/
theorem dependent : web.Dependent
  | 0, _, _, _, req => Eq.subst (motive := fun c => 1 ≤ level 0 c) (pool_of_needs req).symm
      (Nat.succ_le_succ (Nat.zero_le 2))
  | 1, _, _, _, req => Eq.subst (motive := fun c => 1 ≤ level 1 c) (pool_of_needs req).symm
      (Nat.succ_le_succ (Nat.zero_le 1))
  | _ + 2, _, no, _, _ => nomatch (no : _ ∈ ([] : List Nat))

theorem descended : SelectionTerm.Flow.Descended flow web generations := by
  intro t p k mp mk
  match t with
  | 0 =>
    have mp' : p ∈ [1] := mp
    cases mp' with
    | head =>
      have mk' : k ∈ [2, 3] := mk
      cases mk' with
      | head => exact ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | tail _ rest => cases rest with
        | head => exact ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | tail _ no => cases no
    | tail _ no => cases no
  | 1 =>
    have mp' : p ∈ [2, 3] := mp
    cases mp' with
    | head =>
      have mk' : k ∈ [4, 5] := mk
      cases mk' with
      | head => exact ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | tail _ rest => cases rest with
        | head => exact ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | tail _ no => cases no
    | tail _ rest => cases rest with
      | head =>
        have mk' : k ∈ [6, 7] := mk
        cases mk' with
        | head => exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | tail _ rest' => cases rest' with
          | head => exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | tail _ no => cases no
      | tail _ no => cases no
  | _ + 2 =>
    have mk' : k ∈ ([] : List Nat) := mk
    cases mk'

theorem family_two : generations.family 2 = [4, 5, 6, 7] := rfl

theorem family_three : generations.family 3 = [] := rfl

theorem distinct_first : Distinct [1] := steps_distinct 1 1

theorem distinct_second : Distinct [2, 3] := steps_distinct 2 2

theorem distinct_third : Distinct [4, 5, 6, 7] := steps_distinct 4 4

theorem distinct : ∀ j, j < 3 → Distinct (generations.family (0 + j))
  | 0, _ => distinct_first
  | 1, _ => distinct_second
  | 2, _ => distinct_third
  | _ + 3, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 _))

theorem multiplies : ∀ j, j + 1 < 3 →
    2 * generations.size (0 + j) ≤ generations.size (0 + j + 1)
  | 0, _ => Nat.le_refl 2
  | 1, _ => Nat.le_refl 4
  | _ + 2, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 _))

theorem draws : ∀ j, j < 2 → generations.size (0 + j) ≤ flow.taken (0 + j) 0
  | 0, _ => Nat.le_refl 1
  | 1, _ => Nat.le_refl 2
  | _ + 2, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))

theorem needs : ∀ j p, j < 3 → p ∈ generations.family (0 + j) → web.active (0 + j) p →
    p ∈ flow.present (0 + j) ∧ 0 < flow.take (0 + j) p 0 :=
  fun _ _ _ _ act => ⟨act, Nat.zero_lt_one⟩

/-- Every taker taking part requires the pool. -/
theorem pool_required : ∀ {t p : Nat}, p ∈ present t → needsPool p 0
  | 0, _, .head _ => trivial
  | 0, _, .tail _ no => nomatch no
  | 1, _, .head _ => trivial
  | 1, _, .tail _ (.head _) => trivial
  | 1, _, .tail _ (.tail _ no) => nomatch no
  | _ + 2, _, no => nomatch no

/-- Each active taker requires the pool at need one and takes its need (a witness of
`multiplying_takers_stop_of_need`'s premise). -/
theorem takesNeed : ∀ j p, j < 3 → p ∈ generations.family (0 + j) → web.active (0 + j) p →
    p ∈ flow.present (0 + j) ∧ web.requires (0 + j) p 0 ∧ 1 ≤ web.need (0 + j) p 0 ∧
      web.need (0 + j) p 0 ≤ flow.take (0 + j) p 0 :=
  fun _ _ _ _ act => ⟨act, pool_required act, Nat.le_refl 1, Nat.le_refl 1⟩

/-- Every one of the four takers born at step two finds the pool empty. -/
theorem unsupported : ∀ k, k ∈ generations.family 2 → ¬ web.Supported 2 k :=
  fun k mk =>
    have mk' : k ∈ [4, 5, 6, 7] := mk
    match k, mk' with
    | _, .head _ => fun sup => Nat.not_succ_le_zero 0 (sup 0 trivial)
    | _, .tail _ (.head _) => fun sup => Nat.not_succ_le_zero 0 (sup 0 trivial)
    | _, .tail _ (.tail _ (.head _)) => fun sup => Nat.not_succ_le_zero 0 (sup 0 trivial)
    | _, .tail _ (.tail _ (.tail _ (.head _))) => fun sup => Nat.not_succ_le_zero 0 (sup 0 trivial)
    | _, .tail _ (.tail _ (.tail _ (.tail _ no))) => nomatch no

theorem inactive (x : Nat) : ¬ web.active 2 x := fun no => nomatch (no : x ∈ ([] : List Nat))

/-- The line from the first taker ends on every branch: nothing is active at step two. -/
theorem degenerates (Q : Nat → Nat → Prop) :
    «退化» (lineStep flow web Q) (web.kindClass Q) (0, 1) :=
  Web.kind_every_branch_ends_of_gone (W := web) (R := continuation flow web Q) (x := (0, 1)) (N := 2)
    (.head _) (Nat.zero_le 2) fun y _ at_ =>
      Eq.subst (motive := fun s => ¬ web.active s y.2) at_.symm (inactive y.2)

/-- **Multiplying takers on a pool of three.** The flow balances, only takers taking part give, and
they are active only while supported; the generations are generations of descent, and the pool is
given nothing; each active taker requires the pool at need one. Over two generations, one taker
then two, each taking one unit, `multiplying_takers_need` holds with equality: `2 ^ 2` is the
pool's three with one. Over three, every premise of `multiplying_takers_stop` and of
`multiplying_takers_stop_of_need` holds, and so not every member of the three generations stays
active: every one of the four takers born at step two is unsupported, nothing is active at step
two, the generation after them is empty, and the line from the first taker degenerates at the kind
grain (through EL3's `Web.kind_every_branch_ends_of_gone`). The last conclusion also follows from
nothing being active at step two alone, without the takers' law. -/
theorem multiplying :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    SelectionTerm.Flow.Descended flow web generations ∧ (∀ i, flow.given i 0 = 0) ∧
    (∀ t f, flow.take t f 0 = 1) ∧
    web.level 0 0 = 3 ∧ web.level 1 0 = 2 ∧ (∀ t, web.level (t + 2) 0 = 0) ∧
    generations.size 0 = 1 ∧ generations.size 1 = 2 ∧ generations.size 2 = 4 ∧
    2 ^ 2 ≤ web.level 0 0 + 1 ∧ 2 ^ 2 = web.level 0 0 + 1 ∧
    (∀ t p, web.active t p → web.requires t p 0 ∧ web.need t p 0 = 1) ∧
    (¬ ∀ j p, j < 3 → p ∈ generations.family (0 + j) → web.active (0 + j) p) ∧
    (∀ k, k ∈ generations.family 2 → ¬ web.Supported 2 k) ∧ (∀ x, ¬ web.active 2 x) ∧
    generations.size 3 = 0 ∧
    «退化» (lineStep flow web (oneKind Nat)) (web.kindClass (oneKind Nat)) (0, 1) :=
  ⟨balances, acting, dependent, descended, unfed, fun _ _ => rfl, rfl, rfl, fun _ => rfl, rfl, rfl,
   rfl,
   multiplying_takers_need (G := generations) balances (T := 0) (n := 2) (fun i _ => unfed (0 + i))
     (Nat.le_refl 1) (fun j lt => multiplies j (Nat.lt_succ_of_lt lt)) draws,
   rfl, fun _ _ act => ⟨pool_required act, rfl⟩,
   multiplying_takers_stop (G := generations) balances (T := 0) (n := 3) (fun i _ => unfed (0 + i))
     (Nat.le_refl 1) multiplies distinct needs (by decide),
   unsupported, inactive, rfl, degenerates (oneKind Nat)⟩

/-- The same conclusion through the need (a witness of `multiplying_takers_stop_of_need`). -/
theorem stops_of_need :
    ¬ ∀ j p, j < 3 → p ∈ generations.family (0 + j) → web.active (0 + j) p :=
  multiplying_takers_stop_of_need (G := generations) balances (T := 0) (n := 3)
    (fun i _ => unfed (0 + i)) (Nat.le_refl 1) multiplies distinct takesNeed (by decide)

end MultiplyingTakers

/-! ### A handover: both fates at every stock -/

namespace Handover

/-- The relatum whose turn it is: `true` at even steps, `false` at odd
(`Reproduction.Relay.turn`). -/
abbrev holder : Nat → Bool := Reproduction.Relay.turn

/-- `k` at the relatum `e`, nothing at the other. -/
def pick : Bool → Bool → Nat → Nat
  | true, true, k => k
  | true, false, _ => 0
  | false, true, _ => 0
  | false, false, k => k

theorem pick_self : ∀ e k, pick e e k = k
  | true, _ => rfl
  | false, _ => rfl

theorem pick_other : ∀ e k, pick e (!e) k = 0
  | true, _ => rfl
  | false, _ => rfl

theorem pick_zero : ∀ e f, pick e f 0 = 0
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

theorem pick_le : ∀ e f k, pick e f k ≤ k
  | true, true, _ => Nat.le_refl _
  | true, false, _ => Nat.zero_le _
  | false, true, _ => Nat.zero_le _
  | false, false, _ => Nat.le_refl _

theorem pick_back : ∀ e k, pick (!e) e k = 0
  | true, _ => rfl
  | false, _ => rfl

theorem pick_pos : ∀ e f {k : Nat}, 0 < pick e f k → f = e ∧ 0 < k
  | true, true, _, pos => ⟨rfl, pos⟩
  | true, false, _, pos => absurd pos (Nat.lt_irrefl 0)
  | false, true, _, pos => absurd pos (Nat.lt_irrefl 0)
  | false, false, _, pos => ⟨rfl, pos⟩

theorem pick_pos_mono : ∀ e f {k j : Nat}, (0 < k → 0 < j) → 0 < pick e f k → 0 < pick e f j
  | true, true, _, _, mono, pos => mono pos
  | true, false, _, _, _, pos => absurd pos (Nat.lt_irrefl 0)
  | false, true, _, _, _, pos => absurd pos (Nat.lt_irrefl 0)
  | false, false, _, _, mono, pos => mono pos

/-- **The handover with amounts `amount`**: across the step from `t`, the relatum whose turn it is
holds `amount t`, takes all of it from itself, and gives `amount (t + 1)` to the other. -/
def flow (amount : Nat → Nat) : Flow Bool Bool where
  present t := [holder t]
  take t f c := pick (holder t) f (pick (holder t) c (amount t))
  give t f c := pick (holder t) f (pick (!holder t) c (amount (t + 1)))

/-- Each relatum is active exactly while it stands, and requires its own standing at need one. -/
def web (amount : Nat → Nat) : Web Bool Bool where
  level t x := pick (holder t) x (amount t)
  active t x := 0 < pick (holder t) x (amount t)
  requires _ f c := c = f
  need _ _ _ := 1
  draws _ f c := c = f

/-- The two relata read as one family. -/
abbrev family : List Bool := Reproduction.Relay.family

theorem exchange : ∀ (e c : Bool) (a b : Nat),
    pick (!e) c b + (pick e e (pick e c a) + 0) = pick e c a + (pick e e (pick (!e) c b) + 0)
  | true, true, a, _ => Nat.zero_add a
  | true, false, _, b => (Nat.zero_add b).symm
  | false, true, _, b => (Nat.zero_add b).symm
  | false, false, a, _ => Nat.zero_add a

/-- Every handover balances. -/
theorem balances (amount : Nat → Nat) : (flow amount).Balances (web amount) :=
  fun t c => exchange (holder t) c (amount t) (amount (t + 1))

theorem total_pick : ∀ (e : Bool) (a : Nat), pick e true a + (pick e false a + 0) = a
  | true, _ => rfl
  | false, a => Nat.zero_add a

/-- The pair's stock at each step is the step's amount. -/
theorem stock_eq (amount : Nat → Nat) (t : Nat) : (web amount).stock family t = amount t :=
  total_pick (holder t) (amount t)

theorem uptake_pick : ∀ (e : Bool) (a : Nat),
    pick e e (pick e true a) + 0 + (pick e e (pick e false a) + 0 + 0) = a
  | true, _ => rfl
  | false, a => Nat.zero_add a

theorem replenish_pick : ∀ (e : Bool) (b : Nat),
    pick e e (pick (!e) true b) + 0 + (pick e e (pick (!e) false b) + 0 + 0) = b
  | true, b => Nat.zero_add b
  | false, _ => rfl

/-- What the pair gives up across the step is the step's amount. -/
theorem uptake_eq (amount : Nat → Nat) (t : Nat) : (flow amount).uptake family t = amount t :=
  uptake_pick (holder t) (amount t)

/-- What the pair is given across the step is the next step's amount. -/
theorem replenishment_eq (amount : Nat → Nat) (t : Nat) :
    (flow amount).replenishment family t = amount (t + 1) :=
  replenish_pick (holder t) (amount (t + 1))

theorem take_total : ∀ (e : Bool) (a : Nat),
    pick e e (pick e true a) + (pick e e (pick e false a) + 0) = a
  | true, _ => rfl
  | false, a => Nat.zero_add a

theorem give_total : ∀ (e : Bool) (b : Nat),
    pick e e (pick (!e) true b) + (pick e e (pick (!e) false b) + 0) = b
  | true, b => Nat.zero_add b
  | false, _ => rfl

theorem mem_family : ∀ b : Bool, b ∈ family
  | true => .head _
  | false => .tail _ (.head _)

/-- Only an active relatum gives, where an amount handed on was held. -/
theorem acting (amount : Nat → Nat) (falls : ∀ t, 0 < amount (t + 1) → 0 < amount t) :
    (flow amount).Acting (web amount) :=
  fun t f c _ gives => pick_pos_mono (holder t) f
    (fun pos => falls t (Nat.lt_of_lt_of_le pos (pick_le (!holder t) c (amount (t + 1))))) gives

theorem dependent (amount : Nat → Nat) : (web amount).Dependent :=
  fun t _ active _ req =>
    Eq.subst (motive := fun d => 1 ≤ pick (holder t) d (amount t)) req.symm active

theorem embodied (amount : Nat → Nat) (x : Bool) : (web amount).Embodied x := fun _ => Iff.rfl

/-- **The handover is gated on what it renews**: whatever gives to the pair depends on a member at
need one, itself. -/
theorem gated (amount : Nat → Nat) : ∀ t f, f ∈ (flow amount).present t → ∀ d, d ∈ family →
    0 < (flow amount).give t f d →
      ∃ e, e ∈ family ∧ (web amount).requires t f e ∧ 1 ≤ (web amount).need t f e :=
  fun _ f _ _ _ _ => ⟨f, mem_family f, rfl, Nat.le_refl 1⟩

/-- Across a step that hands a positive amount on, the other relatum descends from the holder. -/
theorem descends (amount : Nat → Nat) (t : Nat) (pos : 0 < amount (t + 1)) :
    (flow amount).DescendsAt (web amount) t (!holder t) (holder t) :=
  ⟨.head _,
   Nat.lt_of_lt_of_le pos (Nat.le_of_eq
     ((pick_self (holder t) _).trans (pick_self (!holder t) (amount (t + 1)))).symm),
   fun before => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le before
     (Nat.le_of_eq (pick_other (holder t) (amount t)))),
   Nat.lt_of_lt_of_le pos (Nat.le_of_eq (pick_self (!holder t) (amount (t + 1))).symm)⟩

/-- What is taken from a relatum across the step from `t` is the step's amount where it is the
holder, nothing otherwise. -/
theorem taken_eq (amount : Nat → Nat) (t : Nat) (c : Bool) :
    (flow amount).taken t c = pick (holder t) c (amount t) :=
  (Nat.add_zero _).trans (pick_self (holder t) _)

/-- **No handover draws on a condition at least once and then at least twice at the next step**:
what is taken from a relatum at one step is positive only where it holds, and the other holds at the next, so no condition is drawn
on at least once and then at least twice. -/
theorem draw_not_doubling (amount : Nat → Nat) (T : Nat) (c : Bool) :
    ¬ (1 ≤ (flow amount).taken T c ∧ 2 ≤ (flow amount).taken (T + 1) c) :=
  fun ⟨once, twice⟩ =>
    match pick_pos (holder T) c (Nat.le_trans once (Nat.le_of_eq (taken_eq amount T c))) with
    | ⟨held, _⟩ =>
      have zero : (flow amount).taken (T + 1) c = 0 :=
        (taken_eq amount (T + 1) c).trans
          (Eq.subst (motive := fun e => pick (!holder T) e (amount (T + 1)) = 0) held.symm
            (pick_back (holder T) (amount (T + 1))))
      Nat.not_succ_le_zero 1 (Nat.le_trans twice (Nat.le_of_eq zero))

/-- **The draw regime's premise fails on every handover**: at no step and condition does the draw
at the `j`-th of two steps reach `2 ^ j` (`draw_doubling_needs` at `n = 2`). -/
theorem not_draw_regime (amount : Nat → Nat) (T : Nat) (c : Bool) :
    ¬ ∀ j, j < 2 → 2 ^ j ≤ (flow amount).taken (T + j) c :=
  fun doubles => draw_not_doubling amount T c
    ⟨doubles 0 (Nat.succ_pos 1), doubles 1 (Nat.succ_lt_succ (Nat.succ_pos 0))⟩

/-- Where an amount is nothing, nothing is active. -/
theorem none_active (amount : Nat → Nat) {N : Nat} (zero : amount N = 0) (x : Bool) :
    ¬ (web amount).active N x :=
  fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
    ((congrArg (pick (holder N) x) zero).trans (pick_zero (holder N) x))))

/-! #### The relay: the amount `s` at every step -/

/-- The relay at stock `s`. -/
abbrev relay (s : Nat) : Nat → Nat := fun _ => s

/-- **At stock one the relay's flow and levels are `Reproduction.Relay`'s**: it takes, gives and
leaves at each relatum what `Reproduction.Relay.flow` and `Reproduction.Relay.web` do. Its web
differs: here a relatum is active only while it stands and requires its own standing at need one,
there every relatum is always active and requires nothing. -/
theorem relay_one_flow (t : Nat) (f c : Bool) :
    (flow (relay 1)).take t f c = Reproduction.Relay.flow.take t f c ∧
    (flow (relay 1)).give t f c = Reproduction.Relay.flow.give t f c ∧
    (web (relay 1)).level t c = Reproduction.Relay.web.level t c := by
  show pick (holder t) f (pick (holder t) c 1) =
      Reproduction.Relay.on (holder t) f * Reproduction.Relay.on (holder t) c ∧
    pick (holder t) f (pick (!holder t) c 1) =
      Reproduction.Relay.on (holder t) f * Reproduction.Relay.on (!holder t) c ∧
    pick (holder t) c 1 = Reproduction.Relay.on (holder t) c
  cases holder t <;> cases f <;> cases c <;> exact ⟨rfl, rfl, rfl⟩

theorem relay_descended {s : Nat} (pos : 0 < s) :
    SelectionTerm.Flow.Descended (flow (relay s)) (web (relay s)) Reproduction.Relay.generations :=
  fun t p k mp mk =>
    match mem_cons_cases (Eq.subst (motive := fun l => p ∈ l) (Reproduction.Relay.family_eq t) mp),
      mem_cons_cases mk with
    | .inl hp, .inl hk =>
      Eq.subst (motive := fun q => (flow (relay s)).DescendsAt (web (relay s)) t k q) hp.symm
        (Eq.subst (motive := fun j => (flow (relay s)).DescendsAt (web (relay s)) t j (holder t))
          (hk.trans (congrArg (fun b => !b) hp)).symm (descends (relay s) t pos))
    | _, .inr mem => nomatch mem
    | .inr mem, _ => nomatch mem

/-- The relay is never in excess: what the pair gives up is what it is given. -/
theorem relay_no_excess (s t : Nat) :
    ¬ (flow (relay s)).replenishment family t < (flow (relay s)).uptake family t :=
  fun lt => Nat.lt_irrefl s (Nat.lt_of_lt_of_le
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (replenishment_eq (relay s) t).symm) lt)
    (Nat.le_of_eq (uptake_eq (relay s) t)))

theorem one_le_sign : ∀ {s : Nat}, 0 < s → 1 ≤ sign s
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, _ => Nat.le_refl 1

/-- The relay at a positive stock is not dissipated on. -/
theorem relay_not_dissipates {s : Nat} (pos : 0 < s) (t : Nat) :
    ¬ (flow (relay s)).DissipatesOn family t :=
  fun dissipates =>
    have at_holder := dissipates (holder t) (.head _)
    have given : s + sign (total family ((flow (relay s)).take t (holder t))) ≤
        total family ((flow (relay s)).take t (holder t)) :=
      Eq.subst (motive := fun a => a + sign (total family ((flow (relay s)).take t (holder t))) ≤
        total family ((flow (relay s)).take t (holder t))) (give_total (holder t) s) at_holder
    have taken : s + sign s ≤ s :=
      Eq.subst (motive := fun b => s + sign b ≤ b) (take_total (holder t) s) given
    Nat.not_succ_le_self s (Nat.le_trans (Nat.add_le_add_left (one_le_sign pos) s) taken)

/-- **The relay generates**: at every stock `s ≥ 1` the lineage of one member per generation lies in
generation (`«生成»`) at (kind, carrier), at the grain of activity. -/
theorem relay_generates {s : Nat} (pos : 0 < s) :
    «生成» (lineStep (flow (relay s)) (web (relay s)) (oneKind Bool))
      ((web (relay s)).kindClass (oneKind Bool)) (web (relay s)).carrierClass (0, true) :=
  generation_of_reproducing (Q := oneKind Bool) (G := Reproduction.Relay.generations)
    (acting (relay s) fun _ _ => pos) (relay_descended pos) (fun _ _ _ _ _ => trivial)
    (fun _ _ k _ _ => embodied (relay s) k) (t := 0) (fun _ q _ _ => ⟨!q, .head _⟩) (.head _)

/-! #### The run-down: one unit less at each step -/

/-- The run-down from stock `s`. -/
abbrev runDown (s : Nat) : Nat → Nat := fun t => s - t

/-- The holder hands on offspring while something positive is handed on. -/
def runKids (s t : Nat) (p : Bool) : List Bool := if t + 1 < s then [!p] else []

def runGenerations (s : Nat) : SelectionTerm.Generations Bool where
  first := [true]
  kids := runKids s
  amount _ _ := 1

theorem run_kid {s t : Nat} {p k : Bool} (mk : k ∈ runKids s t p) : t + 1 < s ∧ k = !p :=
  match Nat.decLt (t + 1) s with
  | .isTrue lt => ⟨lt, match mem_cons_cases (Eq.subst (motive := fun l => k ∈ l)
      (if_pos lt : runKids s t p = [!p]) mk) with
    | .inl e => e
    | .inr m => nomatch m⟩
  | .isFalse no => nomatch (Eq.subst (motive := fun l => k ∈ l)
      (if_neg no : runKids s t p = []) mk)

theorem run_turn {s : Nat} : ∀ t p, p ∈ (runGenerations s).family t → p = holder t
  | 0, _, mp => match mem_cons_cases mp with
    | .inl e => e
    | .inr m => nomatch m
  | t + 1, _, mp => match ListTests.mem_flatMap_iff.mp mp with
    | ⟨q, mq, mk⟩ => (run_kid mk).2.trans (congrArg (fun b => !b) (run_turn t q mq))

theorem runDown_falls (s t : Nat) (pos : 0 < s - (t + 1)) : 0 < s - t :=
  Nat.lt_of_lt_of_le pos (Nat.pred_le (s - t))

theorem runDown_descended (s : Nat) :
    SelectionTerm.Flow.Descended (flow (runDown s)) (web (runDown s)) (runGenerations s) :=
  fun t p k mp mk => match run_kid mk with
    | ⟨lt, hk⟩ =>
      have hp := run_turn t p mp
      Eq.subst (motive := fun q => (flow (runDown s)).DescendsAt (web (runDown s)) t k q) hp.symm
        (Eq.subst
          (motive := fun j => (flow (runDown s)).DescendsAt (web (runDown s)) t j (holder t))
          (hk.trans (congrArg (fun b => !b) hp)).symm
          (descends (runDown s) t (SupportGated.sub_pos_of_lt lt)))

/-- The run-down is in excess at each of its `s` steps: the pair gives up `s - t` and is given
`s - (t + 1)`. -/
theorem runDown_excess (s : Nat) : ∀ k, k < s →
    (flow (runDown s)).replenishment family (0 + k) < (flow (runDown s)).uptake family (0 + k) :=
  fun k lt =>
    have lt' : 0 + k < s := Eq.subst (motive := fun u => u < s) (Nat.zero_add k).symm lt
    Nat.lt_of_le_of_lt (Nat.le_of_eq (replenishment_eq (runDown s) (0 + k)))
      (Nat.lt_of_lt_of_le (Nat.pred_lt (Nat.ne_of_gt (SupportGated.sub_pos_of_lt lt')))
        (Nat.le_of_eq (uptake_eq (runDown s) (0 + k)).symm))

theorem pred_sign : ∀ a : Nat, Nat.pred a + sign a ≤ a
  | 0 => Nat.le_refl 0
  | _ + 1 => Nat.le_refl _

/-- The run-down is dissipated on at every step. -/
theorem runDown_dissipates (s t : Nat) : (flow (runDown s)).DissipatesOn family t :=
  fun _ mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun g => total family ((flow (runDown s)).give t g) +
          sign (total family ((flow (runDown s)).take t g)) ≤
            total family ((flow (runDown s)).take t g)) same.symm
        (Eq.subst (motive := fun a =>
            a + sign (total family ((flow (runDown s)).take t (holder t))) ≤
              total family ((flow (runDown s)).take t (holder t)))
          (give_total (holder t) (s - (t + 1))).symm
          (Eq.subst (motive := fun b => Nat.pred (s - t) + sign b ≤ b)
            (take_total (holder t) (s - t)).symm (pred_sign (s - t))))
    | .inr no => nomatch no

/-- A member of a generation after the first was handed on across a step before `s - 1`. -/
theorem run_member_before {s : Nat} (t : Nat) (p : Bool)
    (mp : p ∈ (runGenerations s).family (t + 1)) : t + 1 < s :=
  match ListTests.mem_flatMap_iff.mp mp with
  | ⟨_, _, mk⟩ => (run_kid mk).1

/-- Generation `s` of the run-down is empty. -/
theorem run_empty : ∀ {s : Nat}, 0 < s → ∀ q, ¬ q ∈ (runGenerations s).family s
  | 0, pos, _, _ => absurd pos (Nat.lt_irrefl 0)
  | s + 1, _, q, mq => Nat.lt_irrefl (s + 1) (run_member_before s q mq)

/-- **The census holds every continuation of the run-down** at the kind grain: every descent from
a member is listed, and no member carries on as itself, since the holder stands with nothing after
handing on (`LineageRegions.listed_of_census`). -/
theorem runDown_listed (s : Nat) (Q : Bool → Bool → Prop) :
    ContinuationsListed (lineStep (flow (runDown s)) (web (runDown s)) Q)
      ((web (runDown s)).kindClass Q) (runGenerations s) :=
  listed_of_census
    (fun t q f mq d _ =>
      have hq := run_turn t q mq
      have gives : 0 < pick (holder t) (holder t) (pick (!holder t) f (s - (t + 1))) :=
        Eq.subst (motive := fun g => 0 < pick (holder t) g (pick (!holder t) f (s - (t + 1)))) hq
          d.2.1
      have inner : 0 < pick (!holder t) f (s - (t + 1)) :=
        Nat.lt_of_lt_of_le gives (Nat.le_of_eq (pick_self (holder t) _))
      match pick_pos (!holder t) f inner with
      | ⟨hf, positive⟩ => match Nat.decLt (t + 1) s with
        | .isTrue lt => Eq.subst (motive := fun l => f ∈ l)
            (if_pos lt : runKids s t q = [!q]).symm
            (Eq.subst (motive := fun b => b ∈ [!q])
              (hf.trans (congrArg (fun b => !b) hq.symm)).symm (.head _))
        | .isFalse no => absurd positive (Eq.subst (motive := fun n => ¬ 0 < n)
            (sub_eq_zero_of_le (Nat.ge_of_not_lt no)).symm (Nat.lt_irrefl 0)))
    (fun t q mq sup alike =>
      have hq := run_turn t q mq
      have now : (web (runDown s)).active t q := sup q rfl
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (alike.mp now) (Nat.le_of_eq
        ((congrArg (fun g => pick (!holder t) g (s - (t + 1))) hq).trans
          (pick_back (holder t) _)))))

/-- **The run-down degenerates**, derived through the regime of excess at its horizon: from stock
`s ≥ 1`, `s` steps of excess of the pair's uptake over its replenishment at need one end the line
from the first member on every branch at the kind grain (`degeneration_at_stock_horizon`). A
witness that the regime's premises hold together, not that the regime is needed: the same
degeneration follows from nothing being active at step `s` (`none_active`,
EL3's `Web.kind_every_branch_ends_of_gone`). -/
theorem runDown_degenerates {s : Nat} (pos : 0 < s) :
    «退化» (lineStep (flow (runDown s)) (web (runDown s)) (oneKind Bool))
      ((web (runDown s)).kindClass (oneKind Bool)) (0, true) :=
  degeneration_at_stock_horizon (balances (runDown s))
    (dependent (runDown s)) (T := 0)
    (fun k lt => runDown_excess s k (Eq.subst (motive := fun n => k < n) (stock_eq (runDown s) 0)
      lt))
    (x := (0, true)) pos (Nat.zero_le _)
    fun y _ _ => ⟨y.2, mem_family y.2, rfl, Nat.le_refl 1⟩

/-- **The run-down read under each regime.** Two regimes' premises hold and the third's fails. Its
line from the first member degenerates through renewal run past what it gives, read on the census
(`degeneration_of_family_excess_listed`), whose premise on generation `s` holds vacuously, that
generation being empty; the line from every member of every generation degenerates through
dissipation (`dissipation_degenerates_every_member`); generation `s` is empty and generation
`s + 1` is empty by `Reproduction.Flow.lineage_ends`; and no step and condition meet the draw
regime's premise of a draw doubling across two steps (`not_draw_regime`). The witness shows that
the premises of the first two hold together, not that either is needed. -/
theorem runDown_every_regime {s : Nat} (pos : 0 < s) :
    «退化» (lineStep (flow (runDown s)) (web (runDown s)) (oneKind Bool))
      ((web (runDown s)).kindClass (oneKind Bool)) (0, true) ∧
    (∀ t p, p ∈ (runGenerations s).family t →
      «退化» (lineStep (flow (runDown s)) (web (runDown s)) (oneKind Bool))
        ((web (runDown s)).kindClass (oneKind Bool)) (t, p)) ∧
    (runGenerations s).size s = 0 ∧ (runGenerations s).size (s + 1) = 0 ∧
    (∀ T c, ¬ ∀ j, j < 2 → 2 ^ j ≤ (flow (runDown s)).taken (T + j) c) :=
  ⟨degeneration_of_family_excess_listed (balances (runDown s))
      (dependent (runDown s)) (m := 1) (T := 0)
      (n := s) (runDown_excess s)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (stock_eq (runDown s) 0)) (Nat.lt_succ_self s))
      (runDown_listed s (oneKind Bool))
      (fun q mq => absurd (Eq.subst (motive := fun n => q ∈ (runGenerations s).family n)
        (Nat.zero_add s) mq) (run_empty pos q))
      (t := 0) (p := true) (.head _) pos (Nat.zero_le _),
   fun _ _ mp => dissipation_degenerates_every_member (runDown_descended s)
     (fun _ _ k _ _ => mem_family k) (fun t _ => (balances (runDown s)).on family t)
     (fun t _ => runDown_dissipates s t) (runDown_listed s (oneKind Bool)) mp,
   match h : (runGenerations s).family s with
   | [] => congrArg List.length h
   | q :: _ => absurd (Eq.subst (motive := fun l => q ∈ l) h.symm (List.Mem.head _))
       (run_empty pos q),
   Eq.subst (motive := fun n => (runGenerations s).size (n + 1) = 0) (stock_eq (runDown s) 0)
     (Reproduction.Flow.lineage_ends (runDown_descended s) (fun _ _ k _ _ => mem_family k)
       (fun t _ => (balances (runDown s)).on family t) (fun t _ => runDown_dissipates s t)),
   not_draw_regime (runDown s)⟩

/-- **Both fates at every stock.** For every stock `s ≥ 1`, two handovers on the same pair, with
generations of descent, start from the same stock `s`: the relay keeps the stock at `s`, is never in
excess and never dissipated on, and its lineage generates (`«生成»`); the run-down is in excess at
each of its `s` steps and dissipated on at every step, and its lineage degenerates (`«退化»`). That
both are balanced, gated at need one, every relatum embodied and active only while supported, is
not stated here: those are `GatedPairCourse`'s fields, met in `stock_forces_neither`'s proof. -/
theorem both_fates {s : Nat} (pos : 0 < s) :
    (web (relay s)).stock family 0 = s ∧ (web (runDown s)).stock family 0 = s ∧
    (∀ t, (web (relay s)).stock family t = s) ∧
    (∀ t, Reproduction.Relay.generations.size t = 1) ∧
    (∀ t, ¬ (flow (relay s)).replenishment family t < (flow (relay s)).uptake family t) ∧
    (∀ t, ¬ (flow (relay s)).DissipatesOn family t) ∧
    (∀ k, k < s →
      (flow (runDown s)).replenishment family (0 + k) < (flow (runDown s)).uptake family (0 + k)) ∧
    (∀ t, (flow (runDown s)).DissipatesOn family t) ∧
    SelectionTerm.Flow.Descended (flow (relay s)) (web (relay s)) Reproduction.Relay.generations ∧
    SelectionTerm.Flow.Descended (flow (runDown s)) (web (runDown s)) (runGenerations s) ∧
    «生成» (lineStep (flow (relay s)) (web (relay s)) (oneKind Bool))
      ((web (relay s)).kindClass (oneKind Bool)) (web (relay s)).carrierClass (0, true) ∧
    «退化» (lineStep (flow (runDown s)) (web (runDown s)) (oneKind Bool))
      ((web (runDown s)).kindClass (oneKind Bool)) (0, true) :=
  ⟨stock_eq (relay s) 0, stock_eq (runDown s) 0, stock_eq (relay s),
   fun t => congrArg List.length (Reproduction.Relay.family_eq t), relay_no_excess s,
   relay_not_dissipates pos, runDown_excess s, runDown_dissipates s, relay_descended pos,
   runDown_descended s, relay_generates pos, runDown_degenerates pos⟩

end Handover

/-! ## The stock decides neither fate -/

/-- **A gated course on a pair**: balanced, only active formations giving, activity needing
support, every relatum embodied, generations of descent from the first relatum, the giving gated at
need one on the pair, and the pair's stock at the start `s`. It encodes no verdict on the region. -/
def GatedPairCourse (s : Nat) (L : Flow Bool Bool) (W : Web Bool Bool) (G : SelectionTerm.Generations Bool) :
    Prop :=
  L.Balances W ∧ L.Acting W ∧ W.Dependent ∧ (∀ x, W.Embodied x) ∧
    SelectionTerm.Flow.Descended L W G ∧ G.first = [true] ∧
    (∀ t f, f ∈ L.present t → ∀ d, d ∈ Handover.family → 0 < L.give t f d →
      ∃ e, e ∈ Handover.family ∧ W.requires t f e ∧ 1 ≤ W.need t f e) ∧
    W.stock Handover.family 0 = s

/-- **The stock forces neither fate** (a restatement of the pair in `Handover.both_fates`, with
`«生成退化不并»`, under `GatedPairCourse`). For every stock `s ≥ 1`, some gated course on a pair
with stock `s` generates and some degenerates, so neither region follows from the stock: not every
such course degenerates, and not every such course generates. -/
theorem stock_forces_neither {s : Nat} (pos : 0 < s) :
    (¬ ∀ L W G, GatedPairCourse s L W G →
      «退化» (lineStep L W (oneKind Bool)) (W.kindClass (oneKind Bool)) (0, true)) ∧
    ¬ ∀ L W G, GatedPairCourse s L W G →
      «生成» (lineStep L W (oneKind Bool)) (W.kindClass (oneKind Bool)) W.carrierClass (0, true) :=
  ⟨fun all => «生成退化不并» ⟨Handover.relay_generates pos,
      all _ _ Reproduction.Relay.generations
        ⟨Handover.balances _, Handover.acting _ fun _ _ => pos, Handover.dependent _,
         Handover.embodied _, Handover.relay_descended pos, rfl, Handover.gated _,
         Handover.stock_eq _ 0⟩⟩,
   fun all => «生成退化不并» ⟨all _ _ (Handover.runGenerations s)
        ⟨Handover.balances _, Handover.acting _ (Handover.runDown_falls s), Handover.dependent _,
         Handover.embodied _, Handover.runDown_descended s, rfl, Handover.gated _,
         Handover.stock_eq _ 0⟩,
      Handover.runDown_degenerates pos⟩⟩

/-! ### Renewal from outside -/

namespace FromOutside

open Witnesses (Member)

/-- The renewer gives two units at every step and takes nothing; each taker takes one. -/
def flow : Flow Member Unit := Witnesses.relay (fun _ => [.renewer, .first, .second]) 2 1 1

/-- The condition stands at two; every member is active; the takers require the condition at need
one, the renewer does not. -/
def web : Web Member Unit where
  level _ _ := 2
  active _ _ := True
  requires _ f _ := match f with
    | .renewer => False
    | .first => True
    | .second => True
  need _ _ _ := 1
  draws _ f _ := match f with
    | .renewer => False
    | .first => True
    | .second => True

theorem balances : flow.Balances web := fun _ _ => rfl

theorem acting : flow.Acting web := fun _ _ _ _ _ => trivial

theorem supported (t : Nat) (f : Member) : web.Supported t f :=
  fun _ _ => Nat.succ_le_succ (Nat.zero_le 1)

theorem dependent : web.Dependent := fun t f _ => supported t f

/-- **No gate binds it**: at every need, a gate on the renewal fails, since the renewer gives
without requiring the condition. -/
theorem not_gated (m : Nat) : ¬ ∀ t f, f ∈ flow.present t → 0 < flow.give t f () →
    web.requires t f () ∧ m ≤ web.need t f () :=
  fun gated => (gated 0 .renewer (.head _) (Nat.succ_pos 1)).1

/-- **Renewal from outside.** The flow balances; at every step the renewer gives two units and
does not require the condition; each taker takes within what the step gives and together they
take within it, so nothing is in excess; the condition is fed and not dissipated on; the level
stays at two, and every member is active and supported at every step. -/
theorem from_outside :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t, flow.give t .renewer () = 2 ∧ ¬ web.requires t .renewer ()) ∧
    (∀ t, flow.take t .first () = 1 ∧ flow.take t .second () = 1) ∧
    (∀ t, flow.WithinOwn t () ∧ flow.WithinJoint t ()) ∧
    (∀ t, ¬ flow.given t () < flow.taken t ()) ∧
    (∀ t, 0 < flow.given t ()) ∧ (∀ t, ¬ flow.DissipatesOn [()] t) ∧
    (∀ t, web.level t () = 2) ∧ (∀ t f, web.active t f ∧ web.Supported t f) :=
  ⟨balances, acting, dependent, fun _ => ⟨rfl, fun no => no⟩, fun _ => ⟨rfl, rfl⟩,
   fun _ => ⟨fun f _ => match f with
      | .renewer => Nat.zero_le 2
      | .first => Nat.succ_le_succ (Nat.zero_le 1)
      | .second => Nat.succ_le_succ (Nat.zero_le 1), Nat.le_refl 2⟩,
   fun _ lt => Nat.lt_irrefl 2 lt, fun _ => Nat.succ_pos 1,
   fun _ dissipates => Nat.not_succ_le_zero 1 (dissipates .renewer (.head _)),
   fun _ => rfl, fun t f => ⟨trivial, supported t f⟩⟩

end FromOutside

end LineageRegimes

end Becoming

-- recompiled against the final upstream scratch module (round 4)
