import Becoming.EventualWideningInstances
import Becoming.Gain
import Becoming.MapInstances
import Becoming.Thresholds

/-!
# Keeping widening: what a range that keeps widening needs, and what carries it

`Becoming.EventualWidening` defines a course whose range keeps widening (`Web.KeepsWidening`: from
`T` on, along a continuation, nothing admitted is lost and something keeps being opened). This
module states what such a course needs (supply from beyond a finite family, and renewers
multiplying under upkeep), the form support passing on gives *opened by the opened*, how the map
reads keeping and carrying, that under the World premises nothing keeps opening along passing
of support, what keeping opening needs along any reading (beginnings: carrying renewals along
passing, and within a kind renewals one grain up), and a reading on which 全生成 and keeping
widening hold together. Each law is a property of one course
or one flow. None compares two courses, so none
is the second-order comparison the account leaves open. No ethical predicate, ranking or axiom
occurs.

* **The gain bridge: keeping widening passes every bound, and is fed from beyond.** Take a course
  keeping widening by name on the actual levels from `T`, every formation supported from `T` on
  requiring, fixed, only members of a family `cs` (`Web.RequiresWithin`). For every `n` it lists
  `n` steps at which the configurations of `cs` are pairwise distinct
  (`Web.KeepsWidening.distinct_configs`). So, by the list form of novelty
  (`Web.unbounded_of_distinct_configs`, in `Becoming.Novelty`), the stock of `cs` exceeds every
  bound at arbitrarily late steps (`Web.KeepsWidening.passes_every_bound`) and rises at arbitrarily
  late steps (`Web.KeepsWidening.rises_late`). Under the first law, with `cs` without repetition,
  at arbitrarily late steps the rest gives the family net or the family is not closed
  (`Web.KeepsWidening.from_rest_or_open`). Where the flow also balances on it from some step, it is
  not closed at arbitrarily late steps (`Web.KeepsWidening.open_late`). In a finite balanced world under the
  first law no course keeps widening by name with what its formations require fixed
  (`Flow.whole_not_keepsWidening`). No sequence is chosen, and nothing is decided beyond the order
  of numbers at finitely many listed steps.
* **Renewers multiply under upkeep.** Suppose every formation supported from `T` on takes part and
  takes at least a unit a step from `cs` (`Flow.TakesWhileSupported`). Then a course keeping
  widening by name makes ever more entries of the present list take from `cs`
  (`Web.KeepsWidening.more`), counted from below with no decision of equality (`length_le_count`,
  in `Becoming.Population`). If `cs` is balanced on from some step, its replenishment is bounded
  from no step on (`Web.KeepsWidening.replenishment_unbounded`). If each entry also gives it at
  most `g` a step, so are its renewers (`Web.KeepsWidening.renewers_unbounded`). Takers and
  renewers count entries of the present list, with repetition: they count formations where the
  list repeats none.
* **Opened by the opened, within a recency bound.** `Becoming.Admission` states the uniform form
  of support passing on: under balance, active giving, activity needing support, requirements that
  never loosen and no support lasting `K + 1` steps, a gain across the step from `S + K` is, up to
  double negation, given by a supported formation that gained support from `S` to before `S + K`
  (`Flow.gain_given_by_recent_gainer_at`, `Flow.gain_given_by_recent_gainer`). With support
  decided, and what the gainer requires listed and decided, the giver and its step are found
  (`Flow.gain_given_by_recent_gainer_decided`; it uses `upto_or_fails` of `Becoming.Novelty`, so it
  stands here, above Novelty). The law fixes the form of *opened by the opened*: a recency bound,
  with the double negation inside (`Flow.OpenedByOpenedWithin`). Gains before step `K` are not
  constrained, and within `0` holds of no flow (`Flow.not_within_zero`). Brief supports give it
  (`Flow.openedByOpenedWithin_of_brief`); it is monotone in the bound
  (`Flow.OpenedByOpenedWithin.mono`); it gives the lagged form of UE4's fixed origin
  (`Flow.OpenedByOpenedWithin.lagged`); UE4's form at every origin gives it with bound one
  (`Flow.openedByOpenedWithin_of_opened`). It replaces UE4's `Flow.OpenedByOpened` as a change of
  class, not a relaxation: the two forms are independent (`OpeningChain.forms_independent`).
* **The map reads keeping and carrying.** Read the web through what levels admit (`Web.admitting`).
  Then nothing admitted is lost along a continuation from `T` exactly where the admitted pattern's
  line from every admitted occurrence never ends, 不穷 (`Web.includesAcrossFrom_iff_endless`). By
  name, nothing lost gives 全守, and nothing is 全生成 by name (`Web.kept_of_includes_by_name`).
  Take the continuation "carry on, or pass support" (`Web.passingContinuation` of
  `Flow.PassesSupport`). There a carrying renewal 传 from a supported occurrence is exactly a
  passing of support (`Flow.passesSupport_carries_iff`), and every gain of support is one, up to
  double negation (`Flow.gain_carried`, from `Flow.gain_given_by_supported_at` of
  `Becoming.Admission`). Each successor comes with its case, carrying on or passing support;
  nothing is decided (`Flow.passes_or_carried_on`). Where no formation is supported at `K + 1`
  consecutive steps, every supported line that never ends is 全生成 (`Flow.generation_of_brief`,
  `Flow.generation_of_includes_brief`), and 全生成 is 生成 (`«全生成则生成»`, on the grammar). The
  generation read here is the admitted pattern's, on the actual levels the supported pattern's, not
  that of the web's own activity, which under `Web.Dependent` implies support but is not implied by
  it.
* **Under the World premises nothing keeps opening along passing of support.** With balance, only
  active formations giving, activity needing support and requirements never loosening, whatever is
  supported at a step is, up to double negation, linked along "carry on, or pass support" to
  something supported at any earlier step (`Flow.descends_along_passings`). So along every
  continuation containing it the levels exceed from no step to a later one
  (`Flow.not_exceedsAcross_along_passings`), and nothing keeps opening or keeps widening there
  (`Flow.not_keepsOpening_along_passings`, `Flow.not_keepsWidening_along_passings`). On names and
  on passing of support under the World premises, 全生成 and keeping widening do not hold
  together. These are derived from the law of beginnings below (board rule 9), their statements
  unchanged.
* **Keeping opening needs beginnings.** Along a continuation `R` containing carrying
  on of the supported, a passing of support *begins* along `R` where nothing supported continues
  into its end along `R` (`Flow.BeginsAlong`): it is not a step of `R` (`BeginsAlong.not_along`)
  and is a carrying renewal along passing of support at (activity, one formation)
  (`BeginsAlong.carries`); read on the map, its end begins a line of `R` under activity
  (`BeginsAlong.iff_begins`). Under the World
  premises, whatever is supported at `S + k` is, up to double negation, linked along `R` to
  something supported at `S` or to the end of a beginning across a step between
  (`Flow.descends_or_begun`). So where the levels exceed along `R` a beginning lies between
  (`Flow.begun_of_exceedsAcross`), and keeping opening needs one after every step
  (`Flow.begins_late_of_keepsOpening`); by name, a passing of support after every step
  (`Flow.passes_late_of_keepsOpening_byName`). The law is one way: a beginning opens only where
  nothing supported at the earlier step is linked to its end; on the relay with dormant carrying
  on by name, beginnings lie after every step and nothing keeps opening
  (`KindRelay.Runs.beginnings_without_opening`).
* **The ends of an interval of readings.** Along "carry on while supported, or pass support"
  (`Web.supportedPassing`) every passing is a step, so nothing begins: whatever is supported
  descends along it (`Flow.descends_along_supportedPassing`), and along every continuation
  containing it nothing is opened, keeps opening or keeps widening
  (`Flow.not_exceedsAcross_along_supportedPassing`, `Flow.not_keepsOpening_along_supportedPassing`,
  `Flow.not_keepsWidening_along_supportedPassing`). From an active occurrence it continues as "carry
  on, or pass support" does (`Web.supportedPassing_cont_iff`). Along "carry on while supported"
  (`Web.supportedItself`) a beginning is a passing (`Flow.beginsAlong_supportedItself_iff`) and
  nothing is 全生成 (`Web.supportedItself_not_generation`, by `Web.not_generation_of_within_itself`
  of `Becoming.MapInstances`, of which names are the other case).
* **Within a kind.** For a reflexive relation `Q` on formations, a kind, read "carry on while
  supported, or pass within a kind" (`Web.withinKind`) and the kind class (`Web.kindClass`). From a
  supported occurrence, continuing along it under activity is continuing along passing under the
  kind class (`Web.withinKind_cont_iff`); at an active occurrence a carrier begins along it exactly
  where it begins along passing (`Web.withinKind_begins_iff`); and from a supported giver a
  beginning along it is exactly a carrying renewal along passing at (activity, kind)
  (`Flow.BeginsAlong.carries_kind_iff`): the whole lineage goes on while a line of a kind begins,
  a renewal one grain up. The grains one formation, kind and activity read the map's orders
  (`Web.kindGrains`).
* **Degeneration at the kind grain.** Wherever a uniform horizon is known, one step, not before the
  start, at which nothing the line reaches under the kind class is active, a line from an active
  occurrence ends on every branch under the kind class (`«退化»`,
  `Web.kind_every_branch_ends_of_gone`), for every kind relation and every continuation, the lineage
  continuation included: the kind instance of `Becoming.MapInstances`' law
  (`Web.every_branch_ends_of_gone`), and the other side of the kind grain's generation laws. The
  horizon is a modelling choice. `Map.Undecided.kind_degenerates` meets its premise at every kind
  relation, on `Becoming.MapInstances`' witness `Map.Undecided`.
* **Where what is required is dissipated on, neither.** Where a list holds every condition any
  formation requires and the flow dissipates on it from some step, under the World premises
  nothing keeps opening or keeps widening along a continuation containing carrying on of the
  supported (`Flow.not_keepsOpening_of_dissipated_requirements`,
  `Flow.not_keepsWidening_of_dissipated_requirements`), and, with balance on the list alone, no
  supported occurrence is 全生成 along a continuation contained in "carry on, or pass support"
  (`Flow.not_generation_of_dissipated_requirements`): a passing of support takes from the list
  (`Flow.PassesSupport.takes`), and taking from it stops.
* **Where supports last one step**, along every continuation and under every class finer than
  activity every endless supported line is 全生成 (`Web.generation_of_one_step_supports`): what
  arises begins a carrier under every continuation (`Web.begins_of_arises`, in
  `Becoming.PatternPassing`).

**Witnesses.** `Ladder` meets every premise of the gain bridge together, nothing coming from
nothing (`Ladder.frontier_witness`; its family is open at every step). Under upkeep it meets the
premises of the gain bridge and of renewers multiplying together (`Ladder.upkept_witness`; its
renewers are bounded from no step on). A premise is shown needed by a witness meeting the other
premises in which the conclusion fails:
* passing every bound and being fed from beyond: nothing lost
  (`ClosedCycle.bounded_while_opening`), a finite family (`OpeningChain.fixed_but_unbounded`),
  fixed needs (`Loosening.bounded_while_widening`), the first law (`Source.from_nothing`);
* renewers multiplying: upkeep (`Ladder.upkeep_needed`), capacity (`Ladder.capacity_needed`),
  balance (`Ladder.balance_needed`), nothing lost (`ClosedCycle.renewers_bounded_while_opening`);
* opened by the opened within a bound: brevity (`OpeningChain.brevity_needed`, the single giver).
  Brevity is sufficient, not necessary: the relay, its supports lasting, is opened by the opened
  within one (`OpeningChain.carriers_within`). The two forms are independent
  (`OpeningChain.forms_independent`). The late single giver, which gained support across the first
  step and gives every later gain, meets UE4's form at origin `0` and the recency form at no bound
  (`OpeningChain.lateGiver_opened`, `OpeningChain.lateGiver_not_within`). The lagged relay meets
  the recency form within two and UE4's form at no origin
  (`OpeningChain.within_not_fixed_origin`); from step `2` on each of its gains is given by the
  formation that gained support two steps before, and its gains at steps `0` and `1` are given by
  formation `0`, which never gained support. UE4's witnesses restated for the recency form:
  `OwnCondition.not_within`, `OpeningChain.relay_within`, `OpeningChain.oneGiver_not_within`,
  `Saturated.still_not_within`, `Saturated.reverses_within`, `ClosedCycle.opened_within`,
  `ClosedCycle.cycle_within`;
* the map's generation: brevity (`Saturated.lasting_kept`: every line kept, none 全生成). The
  cycle is 全生成, and so 生成, at every supported occurrence, while along "carry on, or pass
  support" its levels exceed from no step to a later one, and by name it keeps widening from no
  step (`ClosedCycle.generation_without_widening`, `ClosedCycle.generates`). The rising course is kept
  by name (`OwnCondition.rising_kept`).
* 全生成 and keeping widening together, between the ends: the kind relay (`KindRelay`), six
  formations of two kinds whose units pass within and across kinds with period two. The reading,
  the kind `Q`, is chosen with the witness: `c` and `e` are of the kind opposite their givers, so the
  passings across kinds are the reading's beginnings, and its openings. Within kinds it keeps
  widening from step `0` (`KindRelay.keeps_widening`); every supported occurrence is 全生成 there
  (`KindRelay.generation`) and at two orders along passing of support, with the grains one
  formation, kind and activity (`KindRelay.Runs.generation_two_orders`); and renewal without end
  (`«生生»`) holds at the kind grain (`KindRelay.renews_without_end`). It balances, meets the World
  premises and `Flow.Taking`, conserves and lists its conditions (`KindRelay.balances`, `.acting`,
  `.dependent`, `.unloosened`, `.taking`, `.conserving`, `.requiresWithin`). By name (its supports
  last one step), carrying on while supported, along supported passings and within kinds with
  dormant carrying on by name it keeps widening from no step (`KindRelay.not_keepsWidening_byName`,
  `KindRelay.Runs.not_keepsWidening_supportedItself`, `KindRelay.not_keepsWidening_supportedPassing`,
  `KindRelay.not_keepsWidening_dormant`); it returns with period two (`KindRelay.returns`). The fed relay
  (`KindRelay.Fed`) adds a condition of fuel for each step, drawn on and taken a unit by each
  formation taking part and required by none; it is dissipative (`KindRelay.Fed.dissipative`) and
  meets `Flow.Taking`, its supports and passings are the closed relay's, and keeping widening within
  kinds, 全生成 at both orders, renewal without end and the exclusions by name, along supported
  passings and with dormant carrying on hold of it. On the six conditions its formations require it
  conserves exactly (`KindRelay.Fed.conserving_on_part`): the fuel pays only the loss dissipation
  asks for. No list holding what its formations require is dissipated on from any step
  (`KindRelay.Fed.requirements_not_dissipated`), since its requirements conserve and a list holds
  the fuel of only finitely many steps, and no list holds its conditions (`KindRelay.Fed.not_listed`). Both run one relay (`KindRelay.Runs`), on which the laws
  are proved once.

**Standing.** Every law here is a restatement or near-definitional. The first two read the
theory's gain and renewal laws (`Flow.newly_supported_from_rest_or_open`,
`Flow.More.renewers_unbounded_from`) for a course keeping widening. The recency form is
`Flow.gains_from_supported` with brevity. The map laws unfold the map's definitions beside the
pattern-passing law (`Web.begins_within`). The exclusion along passing of support follows the
gains of support back step by step, close to `Web.ByPassing.trace`, with the World premises
supplying each passing up to double negation: near-definitional, the theory's biogenesis. The law
of beginnings is the same induction along any reading containing carrying on of the supported,
with excluded middle on whether something supported continues into each gainer inside the double
negation. The exclusions are its corollaries, and so are the opening and widening laws for
dissipated requirements, with the rest law of `Becoming.Space` (`falls_stop_unrefuted`); the
generation law for dissipated requirements uses instead the renewals 全生成 gives and the
non-recurrence of taking (`Flow.taking_not_recurring_from`).

**Readings (the AI's, for UE7's note; not adopted).** A finite family whose kept widening goes on
is fed from beyond, by the rest or across its boundary; under upkeep its renewers multiply. Where
every support is brief, every balanced flow with recurring gains is opened by the opened, so the
property tells carriers apart only where some support lasts. Under the World premises nothing is
new along lineage, the theory's form of "every cell from a cell": a course keeps widening by name
only because names leave lineage out, a lead for what the second-order direction should count as
novel. Along any reading the price of keeping widening is fresh beginnings of it, carrying
renewals along lineage; on the kind relay, whose reading cuts the passings across kinds, they are
renewals one grain up, the relay keeps widening with 全生成 at two orders and renewal without end,
and what it can form by name only returns: renewal is necessary for keeping widening along a
reading and not sufficient for what can form, by name, to grow.

**What is not derived.** The second-order comparison of two courses; growth by kinds not given in
advance; requirements that tighten; which reading the widening order should be read on, beyond its
comparison by name; any law on the widening order beyond the exclusions; 生成 on the World where
全生成 fails; the capture loop.
The representation commits to discrete steps on one index, natural-number levels and amounts, and
a present list that may repeat entries; upkeep is at least a unit a step. The relay uses unit
amounts and needs of one, kinds given in advance, and in its fed form one condition of fuel for
each step. Passing every bound uses
that a finite family has finitely many configurations within a bound, which natural-number amounts
give. Every declaration has an empty axiom report (scratch build).
-/

namespace Becoming

variable {F C : Type}

/-! ## On the grammar: generation in the strong form is generation -/

/-- **全生成 is 生成.** The line from a point in the strong form, taken whole, is a branch: each
point it reaches is continued by a point it reaches, and ahead of each lies a carrying renewal
between points it reaches. -/
theorem «全生成则生成» {α : Type _} {R L E : «际» α} {x : α} (h : «全生成» R L E x) :
    «生成» R L E x :=
  ⟨fun z => «所及» R L x z, .inl rfl,
   fun z hz => match h.1 z hz with
     | ⟨w, c⟩ => ⟨w, «所及之传递» hz (.inr (.one c)), c⟩,
   fun z hz => match h.2 z hz with
     | ⟨u, v, hu, c⟩ =>
       ⟨u, v, «所及之传递» hz hu, «所及之传递» («所及之传递» hz hu) (.inr (.one c.1)), hu, c⟩⟩

namespace Web

variable {W : Web F C} {cs : List C}

/-! ## The gain bridge: a range keeping widening passes every bound, and is fed from beyond -/

/-- **Keeping widening lists steps of distinct configurations.** A course keeping widening by name
on the actual levels from `T`, whose formations supported from `T` on each require, fixed, only
members of `cs`, gives for every `n` a list of `n` steps from `T`, all at most some step `S`, at
which the configurations of `cs` are pairwise distinct. Each new step comes with a formation
supported there and not before (keeping opening); nothing lost keeps it unsupported at every
listed step, and what it requires reads the configuration. -/
theorem KeepsWidening.distinct_configs {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) :
    ∀ n, ∃ ss : List Nat, ∃ S, T ≤ S ∧ ss.length = n ∧ (∀ s, s ∈ ss → T ≤ s ∧ s ≤ S) ∧
      Distinct (ss.map (W.config cs))
  | 0 => ⟨[], T, Nat.le_refl T, rfl, (fun _ mem => nomatch mem), trivial⟩
  | n + 1 => match KeepsWidening.distinct_configs keeps req n with
    | ⟨ss, S, from_, length, within, distinct⟩ => match keeps.2 S from_ with
      | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
        | ⟨g, supported, before⟩ =>
          ⟨U :: ss, U, Nat.le_trans from_ later, congrArg Nat.succ length,
           fun s mem => match mem_cons_cases mem with
            | .inl same => ⟨Eq.subst (motive := fun x => T ≤ x) same.symm
                (Nat.le_trans from_ later), Nat.le_of_eq same⟩
            | .inr mem => ⟨(within s mem).1, Nat.le_trans (within s mem).2 later⟩,
           ⟨fun mem => match preimage_of_mem_map mem with
              | ⟨s, listed, same⟩ =>
                before ((includesAcross_itself_iff (within s listed).2).mp
                  (keeps.1 s S (within s listed).1 (within s listed).2) g
                  (supported_of_config (req U g (Nat.le_trans from_ later) supported) same
                    supported)),
            distinct⟩⟩

/-- **A course keeping widening passes every bound.** Keeping widening by name on the actual levels
from `T`, its formations supported from `T` on each requiring, fixed, only members of `cs`, the
stock of `cs` exceeds every bound at arbitrarily late steps: from every step it lists steps of
distinct configurations of every length (`unbounded_of_distinct_configs`). No sequence is chosen
and nothing is decided beyond the order of numbers at finitely many listed steps. -/
theorem KeepsWidening.passes_every_bound {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) (K M : Nat) :
    ∃ t, M ≤ t ∧ K < W.stock cs t :=
  unbounded_of_distinct_configs (fun M' n =>
      match KeepsWidening.distinct_configs (KeepsWidening.later (Nat.le_add_left T M') keeps)
          (fun t f later => req t f (Nat.le_trans (Nat.le_add_left T M') later)) n with
      | ⟨ss, _, _, length, within, distinct⟩ =>
        ⟨ss, length, fun s mem => Nat.le_trans (Nat.le_add_right M' T) (within s mem).1, distinct⟩)
    K M

/-- **A course keeping widening rises at arbitrarily late steps**, on a finite family fixing what
its formations require. -/
theorem KeepsWidening.rises_late {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) (M : Nat) :
    ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1) :=
  match keeps.passes_every_bound req (W.stock cs M) M with
  | ⟨_, later, over⟩ => match rises_between (q := W.stock cs) later over with
    | ⟨u, from_, _, up⟩ => ⟨u, from_, up⟩

/-- **The gain bridge.** Under the first law, a course keeping widening by name on the actual
levels, its formations supported from `T` on each requiring, fixed, only members of a family
without repetition, has the family given more than it takes, by the rest or across its boundary, at
arbitrarily late steps. The flow need not balance: the rest is counted. -/
theorem KeepsWidening.from_rest_or_open {L : Flow F C} {T : Nat}
    (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f)
    (gainless : L.Gainless) (distinct : Distinct cs) (M : Nat) :
    ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t) :=
  match keeps.rises_late req M with
  | ⟨t, later, up⟩ => ⟨t, later, Flow.rise_from_rest_or_open gainless distinct up⟩

/-- **Balanced as well, the family is open at arbitrarily late steps**: where the flow balances on
it from `T₀` on, the rest gives it nothing net there, so it is given across its boundary. -/
theorem KeepsWidening.open_late {L : Flow F C} {T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f)
    (gainless : L.Gainless) (distinct : Distinct cs)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (M : Nat) :
    ∃ t, M ≤ t ∧ ¬ L.ClosedAt cs t :=
  match keeps.from_rest_or_open req gainless distinct (M + T₀) with
  | ⟨t, later, .inl rest⟩ => absurd rest (Flow.BalancesOn.rest_not_netGiver
      (balances t (Nat.le_trans (Nat.le_add_left T₀ M) later)))
  | ⟨t, later, .inr open_⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T₀) later, open_⟩

end Web

namespace Flow

/-- **In a finite balanced world under the first law nothing keeps widening by name.** Where a list without
repetition holds every condition, the flow balances on it from `T₀` on and nothing comes from
nothing, no course keeps widening by name on the actual levels with what its formations require
fixed: the whole has no boundary to be given across. -/
theorem whole_not_keepsWidening {L : Flow F C} {W : Web F C} {all : List C}
    (every : ∀ c, c ∈ all) (distinct : Distinct all) (gainless : L.Gainless) {T₀ : Nat}
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W all t) {T : Nat}
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin all f) :
    ¬ W.KeepsWidening Web.itself W.level T :=
  fun keeps => match keeps.open_late req gainless distinct balances 0 with
    | ⟨_, _, open_⟩ => open_ fun _ _ c out => absurd (every c) out

/-! ## Renewers multiply under upkeep -/

/-- **Taking while supported**: from step `T` on, every formation supported at a step takes part in
it and takes at least a unit from the family `cs`. -/
def TakesWhileSupported (L : Flow F C) (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∀ t f, T ≤ t → W.Supported t f → f ∈ L.present t ∧ 0 < total cs (L.take t f)

end Flow

namespace Web

variable {W : Web F C} {cs : List C}

/-- **Keeping widening under upkeep is more without end.** A course keeping widening by name on the
actual levels from `T`, every formation supported from `T` on taking at least a unit a step from
`cs`, makes at least `K` entries of the present list take from `cs` at every step from some step on,
for every `K`: the formations gathered at one step stay supported (nothing lost) and so keep taking.
Takers count entries of the present list, with repetition. -/
theorem KeepsWidening.more {L : Flow F C} {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (takes : L.TakesWhileSupported W cs T) : L.More cs :=
  fun K => match keeps.gathers K with
    | ⟨_, S, from_, length, distinct, all⟩ => ⟨S, fun t later =>
        Eq.subst (motive := fun n => n ≤ L.takers cs t) length
          (length_le_count distinct fun f mem =>
            takes t f (Nat.le_trans from_ later)
              ((includesAcross_itself_iff later).mp (keeps.1 S t from_ later) f (all f mem)))⟩

/-- **Keeping widening under upkeep needs replenishment without bound**, where the family is
balanced on from `T₀` on. -/
theorem KeepsWidening.replenishment_unbounded {L : Flow F C} {T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T) (takes : L.TakesWhileSupported W cs T)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (R : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R :=
  (keeps.more takes).replenishment_unbounded_from balances R

/-- **Renewers multiply.** A course keeping widening by name on the actual levels from `T`, every
formation supported from `T` on taking at least a unit a step from `cs`, with the family balanced
on from `T₀` on and each entry of the present list giving it at most `g` a step: no bound holding
from `T₀` on bounds how many entries renew the family. They count formations where the present
list repeats none. -/
theorem KeepsWidening.renewers_unbounded {L : Flow F C} {g T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T) (takes : L.TakesWhileSupported W cs T)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (capacity : L.Capacity cs g) (M : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M :=
  (keeps.more takes).renewers_unbounded_from balances capacity M

end Web

/-! ## Opened by the opened, within a recency bound -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- **Decided, the recent gainer is found.** Where support is decided at every step, and what `f`
requires across the step from `S + K` is decided and lies in a list, the giver and the step at
which it gained support are found: `gain_given_by_recent_gainer_at` holds positively. Its double
negations locate exactly these two things. It uses `upto_or_fails` of `Becoming.Novelty`, which
`Becoming.Admission` does not import. -/
theorem gain_given_by_recent_gainer_decided {S K : Nat} {f : F}
    (decided : ∀ t g, Decidable (W.Supported t g)) {cs : List C}
    (listed : ∀ c, W.requires (S + K) f c → c ∈ cs)
    (decidedReq : ∀ c, Decidable (W.requires (S + K) f c))
    (balances : ∀ c, W.requires (S + K) f c → L.BalancesOn W [c] (S + K))
    (givers : ∀ c, W.requires (S + K) f c → L.GiversSupported W (S + K) c)
    (unloosened : W.Unloosened (S + K) f)
    (brief : ∀ g, ¬ ∀ i, i ≤ K → W.Supported (S + i) g)
    (gains : W.GainsSupport (S + K) f) :
    ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g :=
  match decideSome (p := fun c => W.requires (S + K) f c ∧ W.Rises (S + K) c)
      (decide := fun c => @instDecidableAnd _ _ (decidedReq c) (Nat.decLt _ _)) cs with
  | isFalse absent => absurd (fun c requires rises => absent ⟨c, listed c requires, requires, rises⟩)
      (gains.rises unloosened)
  | isTrue ⟨c, _, requires, rises⟩ =>
    match rise_given_by_supported_at (balances c requires) (givers c requires) rises with
    | ⟨g, mem, gives, supported⟩ =>
      match @upto_or_fails (fun i => W.Supported (S + i) g) (fun i => decided (S + i) g) K with
      | .inl all => absurd all (brief g)
      | .inr ⟨i, le, fails⟩ =>
        match @came_between (fun j => W.Supported j g) (fun j => decided j g) (S + i) (S + K)
            (Nat.add_le_add_left le S) fails supported with
        | ⟨u, from_, below, comes⟩ =>
          ⟨c, g, u, requires, rises, mem, gives, supported,
           Nat.le_trans (Nat.le_add_right S i) from_, below, comes⟩

/-- **Opened by the opened within `K`**: gains of support recur, and for every step `S`, every gain
of support across the step from `S + K` is, up to double negation, given on a condition the gainer
requires and that rises across the step, by a supported formation taking part that gained support
across a step from `S` to before `S + K`. The form `gain_given_by_recent_gainer` fixes: a recency
bound, with the double negation inside. Gains before step `K` are not constrained; there formations
supported from the start, which never gained support, may give. Within `0` holds of no flow
(`not_within_zero`). It replaces UE4's `OpenedByOpened` as a change of class, not a relaxation: it
drops a giver that gained support once after the origin and carries every later gain, and it admits
givers that gained support within `K` steps, whatever the origin; the two forms are independent
(`OpeningChain.forms_independent`). -/
def OpenedByOpenedWithin (L : Flow F C) (W : Web F C) (K : Nat) : Prop :=
  (∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) ∧
    ∀ S f, W.GainsSupport (S + K) f → ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧
      g ∈ L.present (S + K) ∧ 0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧
      u < S + K ∧ W.GainsSupport u g

/-- **Brief support gives it**: in a balanced flow where only active formations give and activity
needs support, with requirements never loosening, gains recurring and no formation supported at
`K + 1` consecutive steps, the flow is opened by the opened within `K`. -/
theorem openedByOpenedWithin_of_brief (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {K : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (recurs : ∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) : L.OpenedByOpenedWithin W K :=
  ⟨recurs, fun _ _ gains => gain_given_by_recent_gainer balances acting dependent unloosened brief
    gains⟩

/-- **Within zero holds of no flow**: with gains recurring, the window from `S` to before `S` holds
no gainer. -/
theorem not_within_zero : ¬ L.OpenedByOpenedWithin W 0 :=
  fun ⟨recur, within⟩ => match recur 0 with
    | ⟨t, f, _, gains⟩ => within t f gains
        fun ⟨_, _, _, _, _, _, _, _, from_, below, _⟩ =>
          Nat.lt_irrefl _ (Nat.lt_of_le_of_lt from_ below)

/-- **The end of degeneration is opened by the opened within no bound**: where nothing is supported
from some step on, no gain recurs. -/
theorem OpenedByOpenedWithin.not_of_unsupported {T : Nat}
    (none_ : ∀ t f, T ≤ t → ¬ W.Supported t f) (K : Nat) : ¬ L.OpenedByOpenedWithin W K :=
  fun ⟨recur, _⟩ => match recur T with
    | ⟨t, f, from_, gains⟩ => none_ (t + 1) f (Nat.le_succ_of_le from_) gains.2

/-- Opened by the opened within `K` is opened by the opened within `K + 1`. -/
theorem OpenedByOpenedWithin.succ {K : Nat} (opened : L.OpenedByOpenedWithin W K) :
    L.OpenedByOpenedWithin W (K + 1) :=
  ⟨opened.1, fun S f gains =>
    have same : S + 1 + K = S + (K + 1) := (Nat.add_right_comm S 1 K).trans (Nat.add_assoc S K 1)
    fun none => (Eq.subst (motive := fun x => ¬ ¬ ∃ c g u, W.requires x f c ∧ W.Rises x c ∧
        g ∈ L.present x ∧ 0 < L.give x g c ∧ W.Supported x g ∧ S + 1 ≤ u ∧ u < x ∧
        W.GainsSupport u g) same
      (opened.2 (S + 1) f (Eq.subst (motive := fun x => W.GainsSupport x f) same.symm gains)))
      fun ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
        none ⟨c, g, u, requires, rises, mem, gives, supported, Nat.le_of_succ_le from_, below,
          gained⟩⟩

/-- Opened by the opened within `K` is opened by the opened within `K + m`. -/
theorem OpenedByOpenedWithin.add {K : Nat} (opened : L.OpenedByOpenedWithin W K) :
    ∀ m, L.OpenedByOpenedWithin W (K + m)
  | 0 => opened
  | m + 1 => (OpenedByOpenedWithin.add opened m).succ

/-- **The bound is monotone.** -/
theorem OpenedByOpenedWithin.mono {K K' : Nat} (le : K ≤ K') (opened : L.OpenedByOpenedWithin W K) :
    L.OpenedByOpenedWithin W K' :=
  match le_dest le with
  | ⟨m, at_⟩ => Eq.subst (motive := fun x => L.OpenedByOpenedWithin W x) at_.symm (opened.add m)

/-- **The lagged form of a fixed origin.** Within `K`, every gain at a step from `T + K` is, up to
double negation, given by a formation that gained support from `T` on, earlier. -/
theorem OpenedByOpenedWithin.lagged {K : Nat} (opened : L.OpenedByOpenedWithin W K) {T t : Nat}
    {f : F} (late : T + K ≤ t) (gains : W.GainsSupport t f) :
    ¬ ¬ ∃ c g u, W.requires t f c ∧ W.Rises t c ∧ g ∈ L.present t ∧ 0 < L.give t g c ∧
      W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g :=
  match le_dest late with
  | ⟨m, at_⟩ =>
    have same : T + m + K = t := (Nat.add_right_comm T m K).trans at_.symm
    fun none => (Eq.subst (motive := fun x => ¬ ¬ ∃ c g u, W.requires x f c ∧ W.Rises x c ∧
        g ∈ L.present x ∧ 0 < L.give x g c ∧ W.Supported x g ∧ T + m ≤ u ∧ u < x ∧
        W.GainsSupport u g) same
      (opened.2 (T + m) f (Eq.subst (motive := fun x => W.GainsSupport x f) same.symm gains)))
      fun ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
        none ⟨c, g, u, requires, rises, mem, gives, supported,
          Nat.le_trans (Nat.le_add_right T m) from_, below, gained⟩

/-- **UE4's form at every origin gives the bound one.** At a single origin it gives no bound in
general (`OpeningChain.lateGiver_opened`, `OpeningChain.lateGiver_not_within`). -/
theorem openedByOpenedWithin_of_opened (opened : ∀ T, L.OpenedByOpened W T) :
    L.OpenedByOpenedWithin W 1 :=
  ⟨(opened 0).1, fun S f gains => fun none =>
    match (opened S).2 (S + 1) f (Nat.lt_succ_self S) gains with
    | ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
      none ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩⟩

end Flow

/-! ## The map's generation and keeping, read on widening -/

namespace Web

/-- **The web read through what levels admit**: a formation is active at a step where the levels `l`
admit it there; levels, requirements, needs and draws are the web's. On the actual levels its
activity is support. -/
def admitting (W : Web F C) (l : Nat → C → Nat) : Web F C :=
  ⟨W.level, fun t f => W.Admits (l t) t f, W.requires, W.need, W.draws⟩

variable {R : Nat → F → F → Prop}

/-- A link chain goes forward. -/
theorem Linked.steps_le : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h → s ≤ u
  | _, _, _, _, .here _ _ => Nat.le_refl _
  | _, _, _, _, .next _ rest => Nat.le_of_succ_le (Linked.steps_le rest)

/-- A link chain from a step to the same step stays at one formation. -/
theorem Linked.same_of_at : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h → u = s →
    g = h
  | _, _, _, _, .here _ _, _ => rfl
  | s, _, _, _, .next _ rest, at_ =>
    absurd (Nat.le_trans (Linked.steps_le rest) (Nat.le_of_eq at_)) (Nat.not_succ_le_self s)

/-- A link chain across one step is one step of the continuation. -/
theorem Linked.one_step : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h →
    u = s + 1 → R s g h
  | s, _, _, _, .here _ _, at_ => absurd (Nat.le_of_eq at_.symm) (Nat.not_succ_le_self s)
  | s, g, _, _, .next r rest, at_ =>
    Eq.subst (motive := fun x => R s g x) (Linked.same_of_at rest at_) r

/-- A link chain continued by one more step of the continuation is a link chain. -/
theorem Linked.snoc : ∀ {s : Nat} {f : F} {t : Nat} {g h : F},
    Linked R s f t g → R t g h → Linked R s f (t + 1) h
  | _, _, _, _, _, .here t _, r => .next r (.here (t + 1) _)
  | _, _, _, _, _, .next r' rest, r => .next r' (Linked.snoc rest r)

/-- A link chain is the occurrence itself, or a link chain followed by one step. -/
theorem Linked.last : ∀ {s : Nat} {f : F} {u : Nat} {h : F}, Linked R s f u h →
    (s = u ∧ f = h) ∨ ∃ t g, t + 1 = u ∧ Linked R s f t g ∧ R t g h
  | _, _, _, _, .here _ _ => .inl ⟨rfl, rfl⟩
  | s, f, _, _, .next step rest => match Linked.last rest with
    | .inl ⟨at_, same⟩ =>
      .inr ⟨s, f, at_, .here s f, Eq.subst (motive := fun x => R s f x) same step⟩
    | .inr ⟨t, g, at_, linked, last⟩ => .inr ⟨t, g, at_, .next step linked, last⟩

/-- What a line reaches is linked to its start. -/
theorem linked_of_reached {E : «际» (Nat × F)} {x y : Nat × F}
    (reached : «所及» (continuationStep R) E x y) : Linked R x.1 x.2 y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × F => Linked R x.1 x.2 z.1 z.2) same
      (.here x.1 x.2)
  | .inr line => line_linked («及之单调» (fun _ _ k => ⟨k.1, trivial⟩) _ _ line)

/-- **Nothing lost is the admitted pattern never ending.** From `T` on, along a continuation `R`,
nothing the levels `l` admit is lost exactly where, from every occurrence they admit from `T` on,
the line of the admitted pattern (the web read through `l`, with activity as its class) never
ends (不穷). -/
theorem includesAcrossFrom_iff_endless {W : Web F C} {l : Nat → C → Nat} {T : Nat} :
    W.IncludesAcrossFrom R l T ↔ ∀ S f, T ≤ S → W.Admits (l S) S f →
      «不穷» (continuationStep R) (W.admitting l).activityClass (S, f) :=
  ⟨fun includes S f from_ admitted y reached =>
     have admittedY : W.Admits (l y.1) y.1 y.2 :=
       active_along_line (W := W.admitting l) (x := (S, f)) admitted reached
     match includes y.1 (y.1 + 1) (Nat.le_trans from_ (reached_later reached)) (Nat.le_succ _)
         y.2 admittedY with
     | ⟨g, linked, admittedG⟩ =>
       ⟨(y.1 + 1, g), ⟨⟨rfl, Linked.one_step linked rfl⟩, ⟨fun _ => admittedG, fun _ => admittedY⟩⟩⟩,
   fun endless S U from_ le f admitted => match le_dest le with
     | ⟨k, at_⟩ => match reaches_onward (endless S f from_ admitted) k with
       | ⟨y, reached, step⟩ =>
         have here : y.1 = U := step.trans at_.symm
         ⟨y.2, Eq.subst (motive := fun s => Linked R S f s y.2) here (linked_of_reached reached),
          Eq.subst (motive := fun s => W.Admits (l s) s y.2) here
            (active_along_line (W := W.admitting l) (x := (S, f)) admitted reached)⟩⟩

/-- **By name, nothing lost gives 全守, and nothing is 全生成 by name.** Where nothing the levels `l`
admit is lost by name from `T` on, at every occurrence they admit from `T` on the admitted pattern's
line is 全守; by name no line is 全生成 (`itself_not_generation`). A course keeping widening by name
is a case, through its first half. -/
theorem kept_of_includes_by_name {W : Web F C} {l : Nat → C → Nat} {T : Nat}
    (includes : W.IncludesAcrossFrom itself l T) {S : Nat} {f : F} (from_ : T ≤ S)
    (admitted : W.Admits (l S) S f) :
    «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass
        (S, f) ∧
      ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass
        (W.admitting l).carrierClass (S, f) :=
  ⟨itself_keeps (includesAcrossFrom_iff_endless.mp includes S f from_ admitted),
   itself_not_generation (S, f)⟩

end Web

namespace Flow

/-- **`g` passes support to `f`** across the step from `t`: `g` takes part and is supported, gives
to a condition `f` requires that rises across the step, and `f` gains support across it. -/
def PassesSupport (L : Flow F C) (W : Web F C) (t : Nat) (g f : F) : Prop :=
  g ∈ L.present t ∧ W.Supported t g ∧ W.GainsSupport t f ∧
    ∃ c, W.requires t f c ∧ W.Rises t c ∧ 0 < L.give t g c

variable {L : Flow F C} {W : Web F C}

/-- **Passings of support are the carrying renewals of support.** Read through the actual levels
(activity is support), along the continuation in which each formation carries on or passes support
to another, a carrying renewal (`«传»`) from a supported occurrence is exactly a passing of
support. -/
theorem passesSupport_carries_iff {t : Nat} {g f : F} (supported : W.Supported t g) :
    «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (t, g) (t + 1, f) ↔
      L.PassesSupport W t g f :=
  ⟨fun c => ((Web.passing_carries_iff (V := W.admitting W.level) supported).mp c).1,
   fun passes => (Web.passing_carries_iff (V := W.admitting W.level) supported).mpr
     ⟨passes, passes.2.2.1⟩⟩

/-- **Every gain of support is a carrying renewal**, up to double negation: with balance at each
condition `f` requires across the step, whatever gives to such a condition supported, and `f`'s
requirements not loosening, a gain of support by `f` is the end of a carrying renewal from a
supported occurrence along "carry on, or pass support" (`gain_given_by_supported_at`). -/
theorem gain_carried {t : Nat} {f : F}
    (balances : ∀ c, W.requires t f c → L.BalancesOn W [c] t)
    (givers : ∀ c, W.requires t f c → L.GiversSupported W t c)
    (unloosened : W.Unloosened t f) (gains : W.GainsSupport t f) :
    ¬ ¬ ∃ g, W.Supported t g ∧
      «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (t, g) (t + 1, f) :=
  fun none => gain_given_by_supported_at balances givers gains unloosened
    fun ⟨c, g, requires, rises, mem, gives, supported⟩ =>
      none ⟨g, supported, (passesSupport_carries_iff supported).mpr
        ⟨mem, supported, gains, c, requires, rises, gives⟩⟩

/-- Along "carry on, or pass support", from an occurrence `y` reached from a supported start whose
line never ends, a passing of support lies ahead, or `y`'s formation is carried on and supported
through the next `j` steps. Each successor is given with the case it is (carrying on, or a passing
of support); nothing is decided. -/
theorem passes_or_carried_on {x : Nat × F} (start : W.Supported x.1 x.2)
    (endless : «不穷» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass x)
    {y : Nat × F} (reached : «所及» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass x y) :
    ∀ j, (∃ z w, «所及» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        (W.admitting W.level).activityClass y z ∧
        «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
          (W.admitting W.level).activityClass (W.admitting W.level).carrierClass z w) ∨
      ((∀ i, i ≤ j → W.Supported (y.1 + i) y.2) ∧
        ∃ z, «所及» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
          (W.admitting W.level).activityClass y z ∧ z.1 = y.1 + j ∧ z.2 = y.2)
  | 0 => .inr ⟨fun _ le => Eq.subst (motive := fun k => W.Supported (y.1 + k) y.2)
        (Nat.eq_zero_of_le_zero le).symm
        (Web.active_along_line (W := W.admitting W.level) (x := x) start reached),
      y, .inl rfl, rfl, rfl⟩
  | j + 1 => match passes_or_carried_on start endless reached j with
    | .inl found => .inl found
    | .inr ⟨carried, z, toZ, atZ, formZ⟩ =>
      have fromX := «所及之传递» reached toZ
      have supportedZ : W.Supported z.1 z.2 :=
        Web.active_along_line (W := W.admitting W.level) start fromX
      match endless z fromX with
      | ⟨w, step⟩ => match step.1.2 with
        | .inl same =>
          have atW : w.1 = y.1 + (j + 1) := step.1.1.trans (congrArg (· + 1) atZ)
          have formW : w.2 = y.2 := same.symm.trans formZ
          have supportedW : W.Supported w.1 w.2 :=
            Web.active_along_line (W := W.admitting W.level) start
              («所及之传递» fromX (.inr (.one step)))
          .inr ⟨fun i le => match le_succ_cases le with
              | .inl before => carried i before
              | .inr now => Eq.subst (motive := fun k => W.Supported (y.1 + k) y.2) now.symm
                  (Eq.subst (motive := fun s => W.Supported s y.2) atW
                    (Eq.subst (motive := fun g => W.Supported w.1 g) formW supportedW)),
            w, «所及之传递» toZ (.inr (.one step)), atW, formW⟩
        | .inr passes => .inl ⟨z, w, toZ,
            Eq.subst (motive := fun s => «传» (Web.continuationStep
                (Web.passingContinuation (L.PassesSupport W))) (W.admitting W.level).activityClass
                (W.admitting W.level).carrierClass z (s, w.2))
              step.1.1.symm ((passesSupport_carries_iff supportedZ).mpr passes)⟩

/-- **Brief supports make every lasting supported line generation.** Where no formation is supported
at `K + 1` consecutive steps, every supported occurrence whose line along "carry on, or pass
support" never ends is 全生成: ahead of every point of the line lies a passing of support, within
`K` steps. -/
theorem generation_of_brief {K : Nat} (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    {x : Nat × F} (start : W.Supported x.1 x.2)
    (endless : «不穷» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass x) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass x :=
  ⟨endless, fun y reached => match passes_or_carried_on start endless reached K with
    | .inl found => found
    | .inr ⟨carried, _⟩ => absurd carried (brief y.1 y.2)⟩

/-- **Losing nothing along passings, with brief supports, is generation.** Where nothing supported
is lost along "carry on, or pass support" from `T` on and no formation is supported at `K + 1`
consecutive steps, every occurrence supported from `T` on is 全生成. -/
theorem generation_of_includes_brief {K T : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (includes : W.IncludesAcrossFrom (Web.passingContinuation (L.PassesSupport W)) W.level T)
    {S : Nat} {f : F} (from_ : T ≤ S) (supported : W.Supported S f) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (S, f) :=
  generation_of_brief brief supported
    (Web.includesAcrossFrom_iff_endless.mp includes S f from_ supported)

end Flow

/-! ## Beginnings along a reading: what keeping opening needs -/

namespace Web

variable {W : Web F C}

/-- **Carrying on while supported**: each formation continues only itself, and only across a step
from which it is supported. Unlike `itself`, it links no dormant formation. -/
def supportedItself (W : Web F C) : Nat → F → F → Prop := fun t g f => g = f ∧ W.Supported t g

/-- **Carry on while supported, or pass**: across the step from `t`, `f` continues `g` where `g` is
supported there and carries on as `f`, or `g` passes to `f`. Unlike `passingContinuation`, it links
no dormant formation to itself. -/
def supportedPassing (W : Web F C) (passes : Nat → F → F → Prop) : Nat → F → F → Prop :=
  fun t g f => (g = f ∧ W.Supported t g) ∨ passes t g f

/-- **Within a kind**: across the step from `t`, `f` continues `g` where `g` is supported there and
carries on as `f`, or `g` passes to `f` and the two are of one kind `Q`. -/
def withinKind (W : Web F C) (Q : F → F → Prop) (passes : Nat → F → F → Prop) :
    Nat → F → F → Prop :=
  fun t g f => (g = f ∧ W.Supported t g) ∨ (passes t g f ∧ Q g f)

/-- **The kind class** on a web's occurrences: alike in activity, and of one kind `Q`. -/
def kindClass (V : Web F C) (Q : F → F → Prop) : «际» (Nat × F) :=
  «合» V.activityClass (fun x y => Q x.2 y.2)

/-- **The grains of a kind**, for the map's orders (`«阶全生成»`): one formation (`0`), the kind
(`1`), activity (`2` and above). -/
def kindGrains (V : Web F C) (Q : F → F → Prop) : Nat → «际» (Nat × F)
  | 0 => V.carrierClass
  | 1 => V.kindClass Q
  | _ + 2 => V.activityClass

theorem kindClass_within {V : Web F C} {Q : F → F → Prop} :
    ∀ x y, V.kindClass Q x y → V.activityClass x y :=
  fun _ _ alike => alike.1

/-- **Degeneration at the kind grain**: for every kind relation `Q` and every continuation, the
lineage continuation `Web.withinKind W Q passes` included, a line from an active occurrence,
nothing it reaches under the kind class being active at one step `N` not before the start, ends on
every branch under the kind class. The kind instance of `Web.every_branch_ends_of_gone`. -/
theorem kind_every_branch_ends_of_gone {R : Nat → F → F → Prop} {Q : F → F → Prop}
    {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) (W.kindClass Q) x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) (W.kindClass Q) x :=
  every_branch_ends_of_gone kindClass_within start le gone

theorem supportedItself_within : ∀ t g f, W.supportedItself t g f → itself t g f :=
  fun _ _ _ step => step.1

theorem supportedPassing_within {passes : Nat → F → F → Prop} :
    ∀ t g f, W.supportedPassing passes t g f → passingContinuation passes t g f
  | _, _, _, .inl step => .inl step.1
  | _, _, _, .inr p => .inr p

theorem withinKind_within {Q : F → F → Prop} {passes : Nat → F → F → Prop} :
    ∀ t g f, W.withinKind Q passes t g f → W.supportedPassing passes t g f
  | _, _, _, .inl step => .inl step
  | _, _, _, .inr step => .inr step.1

/-- **Along a class finer than activity, a line from a supported occurrence stays supported**,
read through the actual levels. -/
theorem supported_along {R : Nat → F → F → Prop} {L : «际» (Nat × F)}
    (within : ∀ x y, L x y → (W.admitting W.level).activityClass x y) {x y : Nat × F}
    (start : W.Supported x.1 x.2) (reached : «所及» (continuationStep R) L x y) :
    W.Supported y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × F => W.Supported z.1 z.2) same start
  | .inr line => active_along_line (W := W.admitting W.level) start
      (.inr («及之单调» (fun _ _ k => ⟨k.1, within _ _ k.2⟩) _ _ line))

/-- **A line that always has a successor never ends**: along a class finer than activity, where
every supported occurrence has a successor under it, the line from a supported occurrence never
ends (不穷). -/
theorem endless_of_successor {R : Nat → F → F → Prop} {L : «际» (Nat × F)}
    (within : ∀ x y, L x y → (W.admitting W.level).activityClass x y)
    (next : ∀ y : Nat × F, W.Supported y.1 y.2 → «有后» (continuationStep R) L y) {x : Nat × F}
    (start : W.Supported x.1 x.2) : «不穷» (continuationStep R) L x :=
  fun _ reached => next _ (supported_along within start reached)

/-- **Where supports last one step, every endless supported line generates**: where no formation
is supported at two steps running, along every continuation and under every class finer than
activity, every supported occurrence whose line never ends is 全生成 at (that class, one
formation). Each step of the line ends where a formation arises, which begins a carrier
(`begins_of_arises`). `Flow.generation_of_brief` takes any bound on supports, along passing of
support under activity. -/
theorem generation_of_one_step_supports {R : Nat → F → F → Prop} {L : «际» (Nat × F)}
    (within : ∀ x y, L x y → (W.admitting W.level).activityClass x y)
    (brief : ∀ t g, W.Supported t g → ¬ W.Supported (t + 1) g) {x : Nat × F}
    (start : W.Supported x.1 x.2) (endless : «不穷» (continuationStep R) L x) :
    «全生成» (continuationStep R) L (W.admitting W.level).carrierClass x :=
  ⟨endless, fun y reached =>
    have sy : W.Supported y.1 y.2 := supported_along within start reached
    match endless y reached with
    | ⟨w, step⟩ =>
      have sw : W.Supported (y.1 + 1) w.2 :=
        Eq.subst (motive := fun s => W.Supported s w.2) step.1.1 ((within _ _ step.2).mp sy)
      ⟨y, w, .inl rfl, step,
       Eq.subst (motive := fun s => «生» (continuationStep R) (W.admitting W.level).carrierClass
           (s, w.2)) step.1.1.symm
         (begins_of_arises (V := W.admitting W.level)
           ⟨fun before => brief y.1 w.2 before sw, sw⟩)⟩⟩

/-- **Carrying on while supported, nothing generates**: the bottom of the interval of readings. -/
theorem supportedItself_not_generation (x : Nat × F) :
    ¬ «全生成» (continuationStep W.supportedItself) (W.admitting W.level).activityClass
      (W.admitting W.level).carrierClass x :=
  not_generation_of_within_itself (W := W.admitting W.level) supportedItself_within x

/-- **From an active occurrence the two passing readings continue alike**: read through the actual
levels, from a supported occurrence, continuing along "carry on while supported, or pass" under
activity is continuing along "carry on, or pass" under activity. -/
theorem supportedPassing_cont_iff {passes : Nat → F → F → Prop} {x y : Nat × F}
    (supported : W.Supported x.1 x.2) :
    «续» (continuationStep (W.supportedPassing passes)) (W.admitting W.level).activityClass x y ↔
      «续» (continuationStep (passingContinuation passes)) (W.admitting W.level).activityClass x y :=
  ⟨fun ⟨⟨at_, step⟩, alike⟩ => ⟨⟨at_, supportedPassing_within _ _ _ step⟩, alike⟩,
   fun ⟨⟨at_, step⟩, alike⟩ => ⟨⟨at_, match step with
     | .inl same => .inl ⟨same, supported⟩
     | .inr p => .inr p⟩, alike⟩⟩

/-- **Within a kind under activity is passing under the kind class**, from a supported occurrence:
read through the actual levels, with `Q` reflexive, continuing along `withinKind Q` under activity
is continuing along "carry on, or pass" under the kind class. At a dormant occurrence the two
differ: "carry on, or pass" carries a dormant formation on, and `withinKind Q` does not. -/
theorem withinKind_cont_iff {Q : F → F → Prop} (refl : ∀ f, Q f f)
    {passes : Nat → F → F → Prop} {x y : Nat × F} (supported : W.Supported x.1 x.2) :
    «续» (continuationStep (W.withinKind Q passes)) (W.admitting W.level).activityClass x y ↔
      «续» (continuationStep (passingContinuation passes)) ((W.admitting W.level).kindClass Q)
        x y :=
  ⟨fun ⟨⟨at_, step⟩, alike⟩ => match step with
     | .inl ⟨same, _⟩ => ⟨⟨at_, .inl same⟩, alike,
         Eq.subst (motive := fun f => Q x.2 f) same (refl x.2)⟩
     | .inr ⟨p, q⟩ => ⟨⟨at_, .inr p⟩, alike, q⟩,
   fun ⟨⟨at_, step⟩, alike, q⟩ => match step with
     | .inl same => ⟨⟨at_, .inl ⟨same, supported⟩⟩, alike⟩
     | .inr p => ⟨⟨at_, .inr ⟨p, q⟩⟩, alike⟩⟩

/-- **At an active occurrence, a carrier begins within a kind exactly where it begins along
passing**: read through the actual levels, at a supported occurrence, beginning under (activity, one
formation) along `withinKind Q` is beginning so along "carry on, or pass", since either is refuted
only by the formation carrying on from an active occurrence. -/
theorem withinKind_begins_iff {Q : F → F → Prop} {passes : Nat → F → F → Prop} {y : Nat × F}
    (supported : W.Supported y.1 y.2) :
    «生» (continuationStep (W.withinKind Q passes)) (W.admitting W.level).carrierClass y ↔
      «生» (continuationStep (passingContinuation passes)) (W.admitting W.level).carrierClass y :=
  ⟨fun begins ⟨z, ⟨at_, _⟩, alike, same⟩ =>
     begins ⟨z, ⟨at_, .inl ⟨same, alike.mpr supported⟩⟩, alike, same⟩,
   fun begins ⟨z, ⟨at_, step⟩, carrier⟩ =>
     begins ⟨z, ⟨at_, supportedPassing_within _ _ _ (withinKind_within _ _ _ step)⟩, carrier⟩⟩

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- **A passing of support begins a line of `R`** across the step from `t`: `g` passes support to
`h`, and nothing supported at `t` continues into `h` along `R`. Read on the map, it begins a line
of `R` at `(t + 1, h)` under activity (`«生»`); it is not the founding of `Becoming.Founding`. -/
def BeginsAlong (L : Flow F C) (W : Web F C) (R : Nat → F → F → Prop) (t : Nat) (g h : F) : Prop :=
  L.PassesSupport W t g h ∧ ∀ f, R t f h → ¬ W.Supported t f

/-- A beginning along `R` is not a step of `R`: its giver is supported. -/
theorem BeginsAlong.not_along {R : Nat → F → F → Prop} {t : Nat} {g h : F}
    (begins : L.BeginsAlong W R t g h) : ¬ R t g h :=
  fun step => begins.2 g step begins.1.2.1

/-- **A beginning is a carrying renewal along passing of support**, at (activity, one formation). -/
theorem BeginsAlong.carries {R : Nat → F → F → Prop} {t : Nat} {g h : F}
    (begins : L.BeginsAlong W R t g h) :
    «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (t, g) (t + 1, h) :=
  (passesSupport_carries_iff begins.1.2.1).mpr begins.1

/-- **A beginning along `R` is a passing whose end begins a line of `R`** (`«生»`), read through the
actual levels under activity: nothing supported at `t` continues into `h` along `R`. -/
theorem BeginsAlong.iff_begins {R : Nat → F → F → Prop} {t : Nat} {g h : F} :
    L.BeginsAlong W R t g h ↔ L.PassesSupport W t g h ∧
      «生» (Web.continuationStep R) (W.admitting W.level).activityClass (t + 1, h) :=
  ⟨fun ⟨passes, fresh⟩ => ⟨passes, fun ⟨⟨s, f⟩, ⟨at_, step⟩, alike⟩ =>
     match s, Nat.succ.inj at_ with
     | _, rfl => fresh f step (alike.mpr passes.2.2.1.2)⟩,
   fun ⟨passes, begins⟩ => ⟨passes, fun f step sf =>
     begins ⟨(t, f), ⟨rfl, step⟩, ⟨fun _ => passes.2.2.1.2, fun _ => sf⟩⟩⟩⟩

/-- **A beginning within a kind is a renewal one grain up**: from a supported giver, with `Q`
reflexive, a beginning along `withinKind Q` is exactly a carrying renewal along "carry on, or pass
support" at (activity, kind): the whole lineage goes on while a line of a kind begins. -/
theorem BeginsAlong.carries_kind_iff {Q : F → F → Prop} (refl : ∀ f, Q f f) {t : Nat} {g h : F}
    (supported : W.Supported t g) :
    L.BeginsAlong W (W.withinKind Q (L.PassesSupport W)) t g h ↔
      «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        (W.admitting W.level).activityClass ((W.admitting W.level).kindClass Q) (t, g)
        (t + 1, h) :=
  ⟨fun ⟨passes, fresh⟩ =>
     ⟨⟨⟨rfl, .inr passes⟩, ⟨fun _ => passes.2.2.1.2, fun _ => supported⟩⟩,
      fun ⟨⟨s, f⟩, ⟨at_, step⟩, alike, q⟩ =>
        match s, Nat.succ.inj at_ with
        | _, rfl => fresh f (match step with
            | .inl same => .inl ⟨same, alike.mpr passes.2.2.1.2⟩
            | .inr p => .inr ⟨p, q⟩) (alike.mpr passes.2.2.1.2)⟩,
   fun ⟨⟨⟨_, step⟩, alike⟩, begins⟩ =>
     have passes : L.PassesSupport W t g h := match step with
       | .inl same => absurd ⟨(t, g), ⟨rfl, .inl same⟩, alike,
           Eq.subst (motive := fun f => Q g f) same (refl g)⟩ begins
       | .inr p => p
     ⟨passes, fun f step' sf => begins ⟨(t, f),
       ⟨rfl, Web.supportedPassing_within _ _ _ (Web.withinKind_within _ _ _ step')⟩,
       ⟨fun _ => passes.2.2.1.2, fun _ => sf⟩,
       match step' with
       | .inl ⟨same, _⟩ => Eq.subst (motive := fun x => Q f x) same (refl f)
       | .inr ⟨_, q⟩ => q⟩⟩⟩

/-- **Carrying on while supported, a beginning is a passing of support.** -/
theorem beginsAlong_supportedItself_iff {t : Nat} {g h : F} :
    L.BeginsAlong W W.supportedItself t g h ↔ L.PassesSupport W t g h :=
  ⟨fun begins => begins.1, fun passes => ⟨passes, fun _ step sf =>
    passes.2.2.1.1 (Eq.subst (motive := fun x => W.Supported t x) step.1 sf)⟩⟩

/-- **What is supported descends from what was supported, or from a beginning.** Under the World
premises (balance, only active formations giving, activity needing support, requirements never
loosening), along any continuation `R` containing carrying on of the supported, whatever is
supported at `S + k` is, up to double negation, linked along `R` to something supported at `S`,
or linked along `R` to the end of a beginning along `R` across a step from `S` to before `S + k`.
The double negation holds excluded middle on whether some supported formation continues into each
gainer, and the World premises supply each gain's passing (`gain_given_by_supported_at`). -/
theorem descends_or_begun (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (carries : ∀ t f, W.Supported t f → R t f f) (S : Nat) :
    ∀ k g, W.Supported (S + k) g →
      ¬ ¬ ((∃ f, Web.Linked R S f (S + k) g ∧ W.Supported S f) ∨
        ∃ j g' h, j < k ∧ L.BeginsAlong W R (S + j) g' h ∧ Web.Linked R (S + j + 1) h (S + k) g)
  | 0, g, supported => fun none => none (.inl ⟨g, .here S g, supported⟩)
  | k + 1, g, supported => fun none =>
    (fun em : ¬ ¬ ((∃ f, W.Supported (S + k) f ∧ R (S + k) f g) ∨
        ¬ ∃ f, W.Supported (S + k) f ∧ R (S + k) f g) => em fun decided =>
      match decided with
      | .inl ⟨f, sf, step⟩ =>
        descends_or_begun balances acting dependent unloosened carries S k f sf fun found =>
          match found with
          | .inl ⟨f₀, linked, s₀⟩ => none (.inl ⟨f₀, Web.Linked.snoc linked step, s₀⟩)
          | .inr ⟨j, g', h, lt, begins, linked⟩ =>
            none (.inr ⟨j, g', h, Nat.lt_succ_of_lt lt, begins, Web.Linked.snoc linked step⟩)
      | .inr fresh =>
        have gains : W.GainsSupport (S + k) g :=
          ⟨fun before => fresh ⟨g, before, carries _ _ before⟩, supported⟩
        gain_given_by_supported_at (fun c _ => balances.on [c] (S + k))
          (fun c _ => acting.giversSupported dependent (S + k) c) gains (unloosened (S + k) g)
          fun ⟨c, g', requires, rises, mem, gives, sg'⟩ =>
            none (.inr ⟨k, g', g, Nat.lt_succ_self k,
              ⟨⟨mem, sg', gains, c, requires, rises, gives⟩, fun f step sf => fresh ⟨f, sf, step⟩⟩,
              .here _ g⟩))
      (fun no => no (.inr fun holds => no (.inl holds)))

/-- **Where the levels exceed, a beginning lies between**: under the World premises, along a
continuation containing carrying on of the supported, where the actual levels exceed from `S` to
`U` a beginning along it lies, up to double negation, across a step from `S` to before `U`, linked
along it to the formation that opens at `U`: supported there, and linked along it to nothing
supported at `S`. -/
theorem begun_of_exceedsAcross (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (carries : ∀ t f, W.Supported t f → R t f f) {S U : Nat} (le : S ≤ U)
    (exceeds : W.ExceedsAcross R W.level S U) :
    ¬ ¬ ∃ j g h, S ≤ j ∧ j < U ∧ L.BeginsAlong W R j g h ∧
      ∃ g', Web.Linked R (j + 1) h U g' ∧ W.Supported U g' ∧
        ∀ f, Web.Linked R S f U g' → ¬ W.Supported S f :=
  match exceeds, le_dest le with
  | ⟨g', admitted, apart⟩, ⟨k, at_⟩ => fun none =>
    descends_or_begun balances acting dependent unloosened carries S k g'
      (Eq.subst (motive := fun x => W.Supported x g') at_ admitted) fun found =>
      match found with
      | .inl ⟨f, linked, sf⟩ =>
        apart f (Eq.subst (motive := fun x => Web.Linked R S f x g') at_.symm linked) sf
      | .inr ⟨j, g, h, lt, begins, linked⟩ =>
        none ⟨S + j, g, h, Nat.le_add_right S j,
          Eq.subst (motive := fun x => S + j < x) at_.symm (Nat.add_lt_add_left lt S), begins, g',
          Eq.subst (motive := fun x => Web.Linked R (S + j + 1) h x g') at_.symm linked, admitted,
          apart⟩

/-- **Keeping opening needs a beginning after every step**: under the World premises, along a
continuation containing carrying on of the supported, where the actual levels keep opening from
`T`, after every step from `T` a beginning along it lies, up to double negation. -/
theorem begins_late_of_keepsOpening (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (carries : ∀ t f, W.Supported t f → R t f f) {T : Nat} (opens : W.KeepsOpening R W.level T) :
    ∀ S, T ≤ S → ¬ ¬ ∃ j g h, S ≤ j ∧ L.BeginsAlong W R j g h :=
  fun S from_ none => match opens S from_ with
    | ⟨_, le, exceeds⟩ => begun_of_exceedsAcross balances acting dependent unloosened carries le
        exceeds fun ⟨j, g, h, after, _, begins, _⟩ => none ⟨j, g, h, after, begins⟩

/-- **Keeping opening by name needs passings of support after every step**: under the World
premises, where the actual levels keep opening by name from `T`, after every step from `T` a
supported formation passes support, up to double negation. By name reads more links than carrying
on while supported, so it opens only where that does (`ExceedsAcross.anti`), and there a
beginning is a passing (`beginsAlong_supportedItself_iff`). -/
theorem passes_late_of_keepsOpening_byName (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {T : Nat}
    (opens : W.KeepsOpening Web.itself W.level T) :
    ∀ S, T ≤ S → ¬ ¬ ∃ j g h, S ≤ j ∧ L.PassesSupport W j g h :=
  fun S from_ none =>
    begins_late_of_keepsOpening balances acting dependent unloosened (R := W.supportedItself)
      (fun _ _ s => ⟨rfl, s⟩)
      (fun S' from' => match opens S' from' with
        | ⟨U, le, exceeds⟩ => ⟨U, le, Web.ExceedsAcross.anti Web.supportedItself_within exceeds⟩)
      S from_ fun ⟨j, g, h, after, begins⟩ => none ⟨j, g, h, after, begins.1⟩

/-- **What is supported descends from what was supported, along supported passings.** Under the
World premises, whatever is supported at `S + k` is, up to double negation, linked along "carry on
while supported, or pass support" to something supported at `S`. Every passing is a step of it, so
nothing begins along it (`descends_or_begun`). -/
theorem descends_along_supportedPassing (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (S : Nat) :
    ∀ k g, W.Supported (S + k) g →
      ¬ ¬ ∃ f, Web.Linked (W.supportedPassing (L.PassesSupport W)) S f (S + k) g ∧
        W.Supported S f :=
  fun k g supported none =>
    descends_or_begun balances acting dependent unloosened
      (R := W.supportedPassing (L.PassesSupport W)) (fun _ _ s => .inl ⟨rfl, s⟩) S k g supported
      fun found => match found with
        | .inl descends => none descends
        | .inr ⟨_, _, _, _, begins, _⟩ => begins.not_along (.inr begins.1)

/-! ### Under the World premises nothing keeps opening along passing of support -/

/-- **What is supported descends from what was supported, along passings.** Under the World
premises (balance, only active formations giving, activity needing support, requirements never
loosening), whatever is supported at `S + k` is, up to double negation, linked along "carry on, or
pass support" to something supported at `S`: each gain of support on the way is a passing from a
supported formation, as `gain_carried` states. Derived from the law along supported passings
(`descends_along_supportedPassing`), whose continuation the passing continuation contains. -/
theorem descends_along_passings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (S : Nat) :
    ∀ k g, W.Supported (S + k) g →
      ¬ ¬ ∃ f, Web.Linked (Web.passingContinuation (L.PassesSupport W)) S f (S + k) g ∧
        W.Supported S f :=
  fun k g supported none =>
    descends_along_supportedPassing balances acting dependent unloosened S k g supported
      fun ⟨f, linked, sf⟩ => none ⟨f, Web.Linked.mono Web.supportedPassing_within linked, sf⟩

/-- **Under the World premises nothing is opened along supported passings.** Along every
continuation that contains "carry on while supported, or pass support", the actual levels exceed
from no step to a later one: a beginning along it would be a passing that is not one of its steps
(`begun_of_exceedsAcross`). -/
theorem not_exceedsAcross_along_supportedPassing (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, W.supportedPassing (L.PassesSupport W) t g f → R t g f)
    {S U : Nat} (le : S ≤ U) : ¬ W.ExceedsAcross R W.level S U :=
  fun exceeds => begun_of_exceedsAcross balances acting dependent unloosened
    (R := W.supportedPassing (L.PassesSupport W)) (fun _ _ s => .inl ⟨rfl, s⟩) le
    (Web.ExceedsAcross.anti contains exceeds)
    fun ⟨_, _, _, _, _, begins, _⟩ => begins.not_along (.inr begins.1)

/-- **Under the World premises nothing keeps opening along supported passings**, from any step,
along every continuation that contains "carry on while supported, or pass support". -/
theorem not_keepsOpening_along_supportedPassing (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, W.supportedPassing (L.PassesSupport W) t g f → R t g f) (T : Nat) :
    ¬ W.KeepsOpening R W.level T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨_, le, exceeds⟩ =>
      not_exceedsAcross_along_supportedPassing balances acting dependent unloosened contains le
        exceeds

/-- So, under the World premises, nothing keeps widening along such a continuation either. -/
theorem not_keepsWidening_along_supportedPassing (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, W.supportedPassing (L.PassesSupport W) t g f → R t g f) (T : Nat) :
    ¬ W.KeepsWidening R W.level T :=
  fun keeps =>
    not_keepsOpening_along_supportedPassing balances acting dependent unloosened contains T keeps.2

/-- **Under the World premises nothing is opened along passings.** Along every continuation that
contains "carry on, or pass support", the actual levels exceed from no step to a later one: no
formation supported at a step is apart from everything supported at an earlier step. A case of the
law along supported passings, which that continuation contains. -/
theorem not_exceedsAcross_along_passings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, Web.passingContinuation (L.PassesSupport W) t g f → R t g f)
    {S U : Nat} (le : S ≤ U) : ¬ W.ExceedsAcross R W.level S U :=
  not_exceedsAcross_along_supportedPassing balances acting dependent unloosened
    (fun t g f step => contains t g f (Web.supportedPassing_within t g f step)) le

/-- **Under the World premises nothing keeps opening along passings**, from any step, along every
continuation that contains "carry on, or pass support". -/
theorem not_keepsOpening_along_passings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, Web.passingContinuation (L.PassesSupport W) t g f → R t g f) (T : Nat) :
    ¬ W.KeepsOpening R W.level T :=
  not_keepsOpening_along_supportedPassing balances acting dependent unloosened
    (fun t g f step => contains t g f (Web.supportedPassing_within t g f step)) T

/-- So, under the World premises, nothing keeps widening along such a continuation either. -/
theorem not_keepsWidening_along_passings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {R : Nat → F → F → Prop}
    (contains : ∀ t g f, Web.passingContinuation (L.PassesSupport W) t g f → R t g f) (T : Nat) :
    ¬ W.KeepsWidening R W.level T :=
  not_keepsWidening_along_supportedPassing balances acting dependent unloosened
    (fun t g f step => contains t g f (Web.supportedPassing_within t g f step)) T

/-! ### Where what is required is dissipated on, neither -/

/-- **Under dissipation a passing of support takes**: across a step at which a family holding what
the gainer requires is dissipated on, some formation takes from it, since the giver gives to it. -/
theorem PassesSupport.takes {cs : List C} {t : Nat} {g h : F}
    (required : ∀ c, W.requires t h c → c ∈ cs) (passes : L.PassesSupport W t g h)
    (dissipates : L.DissipatesOn cs t) : 0 < L.takers cs t :=
  match passes with
  | ⟨mem, _, _, c, requires, _, gives⟩ =>
    total_pos_of_mem (q := fun f => sign (total cs (L.take t f))) mem
      (sign_pos (dissipates.takes_of_gives mem (total_pos_of_mem (required c requires) gives)))

/-- **Where what is required is dissipated on, nothing keeps opening.** Where a list holds every
condition any formation requires and the flow dissipates on it from `T₀`, under the World
premises, along any continuation containing carrying on of the supported the actual levels keep
opening from no step. Keeping opening needs a beginning after every step, up to double negation
(`begins_late_of_keepsOpening`); each is a passing of support, which takes from the list
(`PassesSupport.takes`), and the list's stock then falls; that its falls stop cannot be refuted
(`falls_stop_unrefuted`). -/
theorem not_keepsOpening_of_dissipated_requirements (balances : L.Balances W)
    (acting : L.Acting W) (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f)
    {all : List C} (required : ∀ t f c, W.requires t f c → c ∈ all) {T₀ : Nat}
    (dissipates : ∀ t, T₀ ≤ t → L.DissipatesOn all t)
    {R : Nat → F → F → Prop} (carries : ∀ t f, W.Supported t f → R t f f) (T : Nat) :
    ¬ W.KeepsOpening R W.level T :=
  fun opens => falls_stop_unrefuted (q := W.stock all) (T := T + T₀)
    (fun t later => Nat.le_trans (Nat.le_add_right _ _)
      ((balances.on all t).runs_down (dissipates t (Nat.le_trans (Nat.le_add_left T₀ T) later))))
    fun M from_ none =>
      begins_late_of_keepsOpening balances acting dependent unloosened carries opens M
        (Nat.le_trans (Nat.le_add_right T T₀) from_) fun ⟨j, _, h, after, begins⟩ =>
          have later : T₀ ≤ j := Nat.le_trans (Nat.le_add_left T₀ T) (Nat.le_trans from_ after)
          none ⟨j, after, Nat.lt_of_lt_of_le
            (Nat.add_lt_add_left (begins.1.takes (required j h) (dissipates j later))
              (W.stock all (j + 1)))
            ((balances.on all j).runs_down (dissipates j later))⟩

/-- So nothing keeps widening along such a continuation either. -/
theorem not_keepsWidening_of_dissipated_requirements (balances : L.Balances W)
    (acting : L.Acting W) (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f)
    {all : List C} (required : ∀ t f c, W.requires t f c → c ∈ all) {T₀ : Nat}
    (dissipates : ∀ t, T₀ ≤ t → L.DissipatesOn all t)
    {R : Nat → F → F → Prop} (carries : ∀ t f, W.Supported t f → R t f f) (T : Nat) :
    ¬ W.KeepsWidening R W.level T :=
  fun keeps => not_keepsOpening_of_dissipated_requirements balances acting dependent unloosened
    required dissipates carries T keeps.2

/-- **Where what is required is dissipated on, nothing generates along passing.** Where a list holds
every condition any formation requires and the flow balances and dissipates on it from `T₀`, along
any continuation contained in "carry on, or pass support" no supported occurrence is 全生成 at
(activity, one formation). 全生成 renews at arbitrarily late steps (`Web.generation_renews_late`);
along such a continuation a carrying renewal from a supported occurrence is a passing of support
(`Web.carries_iff`), which takes from the list (`PassesSupport.takes`), and taking from it does not
recur (`taking_not_recurring_from`). No World premise beyond balance on the list is used, and not the
law of beginnings. -/
theorem not_generation_of_dissipated_requirements {all : List C}
    (required : ∀ t f c, W.requires t f c → c ∈ all) {T₀ : Nat}
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W all t)
    (dissipates : ∀ t, T₀ ≤ t → L.DissipatesOn all t) {R : Nat → F → F → Prop}
    (within : ∀ t g f, R t g f → Web.passingContinuation (L.PassesSupport W) t g f)
    {x : Nat × F} (start : W.Supported x.1 x.2) :
    ¬ «全生成» (Web.continuationStep R) (W.admitting W.level).activityClass
      (W.admitting W.level).carrierClass x :=
  fun generates => taking_not_recurring_from balances dissipates fun N =>
    match Web.generation_renews_late (W := W.admitting W.level) generates (N + T₀) with
    | ⟨z, _, reached, later, carries⟩ =>
      have sz : W.Supported z.1 z.2 :=
        Web.active_along_line (W := W.admitting W.level) start reached
      have from₀ : T₀ ≤ z.1 := Nat.le_trans (Nat.le_add_left T₀ N) later
      match (Web.carries_iff (W := W.admitting W.level) sz).mp carries with
      | ⟨step, _, fresh⟩ => match within _ _ _ step.2 with
        | .inl same => absurd ⟨Eq.subst (motive := fun f => W.Supported z.1 f) same sz,
            Eq.subst (motive := fun f => R z.1 f _) same step.2⟩ fresh
        | .inr passes => ⟨z.1, Nat.le_trans (Nat.le_add_right N T₀) later,
            passes.takes (required z.1 _) (dissipates z.1 from₀)⟩

end Flow

/-! ## Witnesses -/

namespace OwnCondition

theorem rung_le_one : ∀ c t, rung c t ≤ 1
  | 0, _ => Nat.le_refl 1
  | _ + 1, 0 => Nat.zero_le 1
  | c + 1, t + 1 => (rung_le_one c t : rung c t ≤ 1)

/-- **By name, the rising course is kept**: at every occurrence it admits, the admitted pattern's
line is 全守; it is not 全生成, as nothing is by name. -/
theorem rising_kept {S n : Nat} (le : n ≤ S) :
    «全守» (Web.continuationStep Web.itself) (web.admitting rising).activityClass
        (web.admitting rising).carrierClass (S, n) ∧
      ¬ «全生成» (Web.continuationStep Web.itself) (web.admitting rising).activityClass
        (web.admitting rising).carrierClass (S, n) :=
  Web.kept_of_includes_by_name rising_keeps_widening.1 (Nat.zero_le S) (rising_iff.mpr le)

/-- **On this web no flow is opened by the opened within any bound**: nothing is ever supported, so
no gain recurs (`not_opened`, restated for the recency form). -/
theorem not_within (L : Flow Nat Nat) (K : Nat) : ¬ Flow.OpenedByOpenedWithin L web K :=
  Flow.OpenedByOpenedWithin.not_of_unsupported (T := 0)
    (fun _ f _ supported => Nat.not_succ_le_zero 0 (supported f rfl)) K

end OwnCondition

/-! ### The ladder: the gain bridge's premises and those of renewers multiplying, together -/

namespace Ladder

/-- One at condition zero, nothing elsewhere. -/
def atZero : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

theorem atZero_pos : ∀ {c : Nat}, 0 < atZero c → c = 0
  | 0, _ => rfl
  | _ + 1, pos => absurd pos (Nat.lt_irrefl 0)

/-- One where the two agree, nothing elsewhere. -/
def same : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ + 1 => 0
  | _ + 1, 0 => 0
  | a + 1, b + 1 => same a b

theorem same_self : ∀ n, same n n = 1
  | 0 => rfl
  | n + 1 => same_self n

/-- At step `t`, one while `t` is at most `c`, nothing after: the unit standing at condition `c + 1`
until it is taken. -/
def unusedAt : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 0
  | t + 1, c + 1 => unusedAt t c

theorem unused_step : ∀ c t, unusedAt (t + 1) c + same c t = unusedAt t c
  | 0, 0 => rfl
  | _ + 1, 0 => rfl
  | 0, _ + 1 => rfl
  | c + 1, t + 1 => unused_step c t

/-- Condition `0` stands at `t + 1` at step `t`; condition `c + 1` holds one unit up to step `c`. -/
def levelAt : Nat → Nat → Nat
  | t, 0 => t + 1
  | t, c + 1 => unusedAt t c

/-- The carrier `none` requires nothing; formation `some n` requires condition `0`. -/
def requiresOf : Option Nat → Nat → Prop
  | none, _ => False
  | some _, c => c = 0

/-- Formation `some n` needs `n + 1` of condition `0`. -/
def needOf : Option Nat → Nat
  | none => 0
  | some n => n + 1

/-- The carrier is active throughout; formation `some n` from step `n` on. -/
def activeAt : Nat → Option Nat → Prop
  | _, none => True
  | t, some n => n ≤ t

/-- **The ladder**: condition `0` rises by one a step; formation `some n`, requiring `n + 1` of it,
is supported from step `n` on; the carrier `none` requires nothing; and each condition `c + 1`
holds a unit up to step `c`. -/
def web : Web (Option Nat) Nat :=
  ⟨levelAt, activeAt, fun _ => requiresOf, fun _ f _ => needOf f, fun _ _ _ => False⟩

theorem supported_some {t n : Nat} : web.Supported t (some n) ↔ n ≤ t :=
  ⟨fun supported => Nat.le_of_succ_le_succ (supported 0 rfl),
   fun le _ same => Eq.subst (motive := fun x => n + 1 ≤ levelAt t x) same.symm
     (Nat.succ_le_succ le)⟩

theorem supported_none {t : Nat} : web.Supported t none := fun _ no => nomatch no

/-- **The ladder keeps widening by name.** -/
theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun f admitted =>
      match f, admitted with
      | none, _ => supported_none
      | some _, admitted => supported_some.mpr (Nat.le_trans (supported_some.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨some (S + 1), supported_some.mpr (Nat.le_refl _),
       fun admitted => Nat.not_succ_le_self S (supported_some.mp admitted)⟩⟩⟩

/-- What every formation requires is fixed and lies within `[0]`. -/
theorem requiresWithin : ∀ f, web.RequiresWithin [0] f
  | some _, _, _, _, req => ⟨req, rfl, Eq.subst (motive := fun x => x ∈ [0]) req.symm (.head [])⟩
  | none, _, _, _, req => nomatch req

/-- **The frontier**: at step `t` the carrier alone takes part; it takes the unit standing at
condition `t + 1` and gives it to condition `0`. -/
def frontier : Flow (Option Nat) Nat :=
  ⟨fun _ => [none], fun t _ c => same c (t + 1), fun _ _ c => atZero c⟩

theorem frontier_balances : frontier.Balances web := fun t c => match c with
  | 0 => rfl
  | c + 1 => unused_step c t

/-- Under the frontier nothing comes from nothing. -/
theorem frontier_gainless : frontier.Gainless := fun cs t distinct closed f mem =>
  have notOut : ¬ ¬ (t + 1) ∈ cs := fun out =>
    Nat.noConfusion ((same_self (t + 1)).symm.trans (closed f mem (t + 1) out).1)
  Thresholds.le_of_not_not fun notLe => notOut fun inside => notLe
    (Nat.le_trans (total_le_at (a := 0) (fun _ pos => atZero_pos pos) distinct)
      (Nat.le_trans (Nat.le_of_eq (same_self (t + 1)).symm)
        (le_total_of_mem (q := fun c => same c (t + 1)) inside)))

/-- Under the frontier the family `[0]` is open at every step. -/
theorem frontier_open (t : Nat) : ¬ frontier.ClosedAt [0] t := fun closed =>
  Nat.noConfusion ((same_self (t + 1)).symm.trans
    (closed none (.head []) (t + 1) fun mem => match mem_cons_cases mem with
      | .inl same => Nat.noConfusion same
      | .inr no => nomatch no).1)

/-- **The gain bridge's premises hold together**: the ladder keeps widening by name, what its
formations require is fixed within `[0]`, and the frontier balances under the first law. `[0]` is
open at every step: its frontier of fresh conditions is what the gain bridge says must exist. -/
theorem frontier_witness :
    web.KeepsWidening Web.itself web.level 0 ∧ (∀ f, web.RequiresWithin [0] f) ∧
      frontier.Gainless ∧ frontier.Balances web ∧ ∀ t, ¬ frontier.ClosedAt [0] t :=
  ⟨keeps_widening, requiresWithin, frontier_gainless, frontier_balances, frontier_open⟩

/-- The stock of `[0]` passes every bound, by the gain bridge. -/
theorem stock_unbounded : ∀ K M, ∃ t, M ≤ t ∧ K < web.stock [0] t :=
  keeps_widening.passes_every_bound fun _ f _ _ => requiresWithin f

/-- At step `t` the carrier and the formations `some 0`, …, `some t` take part. -/
def takingPart (t : Nat) : List (Option Nat) := none :: (Undecided.upto (t + 1)).map some

/-- Under upkeep each takes a unit from condition `0`; the carrier also takes the unit standing at
condition `t + 1`. -/
def upkeepTake (t : Nat) : Option Nat → Nat → Nat
  | none, c => atZero c + same c (t + 1)
  | some _, c => atZero c

/-- Under upkeep each gives a unit back to condition `0`; the carrier gives one more. -/
def upkeepGive : Option Nat → Nat → Nat
  | none, c => atZero c + atZero c
  | some _, c => atZero c

/-- **Upkeep**: every supported formation takes part, takes a unit from condition `0` and gives it
back; the carrier also brings the unit standing at condition `t + 1`. -/
def upkept : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, fun _ => upkeepGive⟩

/-- A balance kept when the same amount is added to what is taken and given. -/
theorem shift_balance {a b s z x : Nat} (h : a + s = b + z) :
    a + ((z + s) + x) = b + ((z + z) + x) :=
  (congrArg (a + ·) ((congrArg (· + x) (Nat.add_comm z s)).trans (Nat.add_assoc s z x))).trans
    ((Nat.add_assoc a s (z + x)).symm.trans
      ((congrArg (· + (z + x)) h).trans
        ((Nat.add_assoc b z (z + x)).trans (congrArg (b + ·) (Nat.add_assoc z z x).symm))))

theorem upkept_balances : upkept.Balances web := fun t c =>
  have base : web.level (t + 1) c + same c (t + 1) = web.level t c + atZero c :=
    frontier_balances t c
  (shift_balance (x := total ((Undecided.upto (t + 1)).map some) (fun f => upkeepTake t f c))
    base).trans
    (congrArg (fun x => web.level t c + ((atZero c + atZero c) + x))
      ((total_map some (fun f => upkeepTake t f c) (Undecided.upto (t + 1))).trans
        (total_map some (fun f => upkeepGive f c) (Undecided.upto (t + 1))).symm))

theorem upkept_takes : upkept.TakesWhileSupported web [0] 0 := fun _ f _ supported =>
  match f, supported with
  | none, _ => ⟨.head _, Nat.zero_lt_one⟩
  | some _, supported => ⟨.tail none (mem_map_of
      (Undecided.mem_upto (Nat.lt_succ_of_le (supported_some.mp supported)))), Nat.zero_lt_one⟩

theorem upkept_capacity : upkept.Capacity [0] 2 := fun _ f _ => match f with
  | none => Nat.le_refl 2
  | some _ => Nat.le_succ 1

/-- Under upkeep nothing comes from nothing. -/
theorem upkept_gainless : upkept.Gainless := fun cs t distinct closed f mem =>
  match f, mem with
  | some _, _ => Nat.le_refl _
  | none, mem =>
    have notOut : ¬ ¬ (t + 1) ∈ cs := fun out =>
      Nat.noConfusion ((same_self (t + 1)).symm.trans
        ((Nat.zero_add _).symm.trans (closed none mem (t + 1) out).1))
    have inner : total cs atZero ≤ total cs (fun c => same c (t + 1)) :=
      Thresholds.le_of_not_not fun notLe => notOut fun inside => notLe
        (Nat.le_trans (total_le_at (a := 0) (fun _ pos => atZero_pos pos) distinct)
          (Nat.le_trans (Nat.le_of_eq (same_self (t + 1)).symm)
            (le_total_of_mem (q := fun c => same c (t + 1)) inside)))
    show total cs (fun c => atZero c + atZero c) ≤ total cs (fun c => atZero c + same c (t + 1)) from
      Nat.le_trans (Nat.le_of_eq (total_add atZero atZero cs))
        (Nat.le_trans (Nat.add_le_add_left inner _)
          (Nat.le_of_eq (total_add atZero (fun c => same c (t + 1)) cs).symm))

/-- **The premises of renewers multiplying hold together, under the first law as well**: the ladder
keeps widening by name; under upkeep every supported formation takes a unit a step from `[0]`, the
flow balances, each entry gives at most two, and nothing comes from nothing. Its renewers of `[0]`
are bounded from no step on (its present list repeats no formation). -/
theorem upkept_witness :
    web.KeepsWidening Web.itself web.level 0 ∧ upkept.TakesWhileSupported web [0] 0 ∧
      upkept.Balances web ∧ upkept.Capacity [0] 2 ∧ upkept.Gainless ∧
      ∀ M, ¬ ∀ t, 0 ≤ t → upkept.renewers [0] t ≤ M :=
  ⟨keeps_widening, upkept_takes, upkept_balances, upkept_capacity, upkept_gainless,
   fun M => keeps_widening.renewers_unbounded upkept_takes (fun t _ => upkept_balances.on [0] t)
     upkept_capacity M⟩

theorem frontier_capacity : frontier.Capacity [0] 1 := fun _ _ _ => Nat.le_refl 1

theorem frontier_renewers (t : Nat) : frontier.renewers [0] t ≤ 1 :=
  show sign (total [0] (frontier.give t none)) + 0 ≤ 1 from sign_le_one _

/-- **Upkeep cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: without it the
frontier keeps the ladder widening with one renewer a step, balanced and with capacity one. -/
theorem upkeep_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ frontier.Balances web ∧ frontier.Capacity [0] 1 ∧
      ∀ t, frontier.renewers [0] t ≤ 1 :=
  ⟨keeps_widening, frontier_balances, frontier_capacity, frontier_renewers⟩

/-- What the one renewer gives: all that is taken from condition `0`, and one unit more. -/
def oneGive (t : Nat) : Option Nat → Nat → Nat
  | none, 0 => total (takingPart t) (fun f => upkeepTake t f 0) + 1
  | none, _ + 1 => 0
  | some _, _ => 0

/-- **One renewer**: as under upkeep, but the carrier alone gives. -/
def oneRenewer : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, oneGive⟩

theorem oneRenewer_balances : oneRenewer.Balances web := fun t c => match c with
  | 0 =>
    (Nat.succ_add (t + 1) (total (takingPart t) (fun f => upkeepTake t f 0))).trans
      (congrArg (fun x => (t + 1) + ((total (takingPart t) (fun f => upkeepTake t f 0) + 1) + x))
        ((total_map some (fun f => oneGive t f 0) (Undecided.upto (t + 1))).trans
          (total_zero (Undecided.upto (t + 1)))).symm)
  | c + 1 =>
    (congrArg (fun x => unusedAt (t + 1) c + ((0 + same c t) + x))
      ((total_map some (fun f => upkeepTake t f (c + 1)) (Undecided.upto (t + 1))).trans
        (total_zero (Undecided.upto (t + 1))))).trans
    ((congrArg (fun x => unusedAt (t + 1) c + x) (Nat.zero_add (same c t))).trans
      ((unused_step c t).trans
        (congrArg (fun x => unusedAt t c + (0 + x))
          ((total_map some (fun f => oneGive t f (c + 1)) (Undecided.upto (t + 1))).trans
            (total_zero (Undecided.upto (t + 1)))).symm)))

theorem oneRenewer_renewers (t : Nat) : oneRenewer.renewers [0] t ≤ 1 :=
  Nat.le_trans (Nat.le_of_eq (congrArg (sign (total [0] (oneGive t none)) + ·)
      ((total_map some (fun f => sign (total [0] (oneGive t f))) (Undecided.upto (t + 1))).trans
        (total_zero (Undecided.upto (t + 1))))))
    (sign_le_one _)

/-- **Capacity cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: with the carrier
giving all that is taken, and one more, every premise but capacity holds and one formation renews
the family. -/
theorem capacity_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ oneRenewer.TakesWhileSupported web [0] 0 ∧
      oneRenewer.Balances web ∧ ∀ t, oneRenewer.renewers [0] t ≤ 1 :=
  ⟨keeps_widening, upkept_takes, oneRenewer_balances, oneRenewer_renewers⟩

/-- **No giving**: as under upkeep, but nothing gives. -/
def unbalanced : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, fun _ _ _ => 0⟩

/-- **Balance cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: without it nothing
ties the renewers to the uptake; here nothing gives, with every other premise holding. -/
theorem balance_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ unbalanced.TakesWhileSupported web [0] 0 ∧
      unbalanced.Capacity [0] 0 ∧ ∀ t, unbalanced.renewers [0] t = 0 :=
  ⟨keeps_widening, upkept_takes, fun _ _ _ => Nat.le_refl 0,
   fun t => total_zero (takingPart t)⟩

end Ladder

/-! ### The cycle: what nothing lost does in the first two laws, and generation without widening -/

namespace ClosedCycle

theorem mark_sum : ∀ b : Bool, mark false b + (mark true b + 0) = 1
  | true => rfl
  | false => rfl

/-- In the cycle nothing comes from nothing. -/
theorem gainless : flow.Gainless := fun cs _ distinct closed g mem =>
  have notOut : ¬ ¬ g ∈ cs := fun out =>
    Nat.noConfusion ((mark_self g).symm.trans (closed g mem g out).1)
  Thresholds.le_of_not_not fun notLe => notOut fun inside => notLe
    (Nat.le_trans (Nat.le_trans (total_le_at (a := !g) (fun _ pos => mark_pos_iff.mp pos) distinct)
        (Nat.le_of_eq (mark_self (!g))))
      (Nat.le_trans (Nat.le_of_eq (mark_self g).symm) (le_total_of_mem (q := fun c => mark c g)
        inside)))

/-- By name the cycle keeps opening from step `0`. -/
theorem keeps_opening_by_name : web.KeepsOpening Web.itself web.level 0 :=
  fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
    ⟨parity (S + 1), supported_iff.mpr rfl,
     fun supported => ListTests.not_ne_self (parity S) (supported_iff.mp supported)⟩⟩

theorem requiresWithin : ∀ f, web.RequiresWithin [false, true] f :=
  fun _ _ _ c req => ⟨req, rfl, listed c⟩

theorem stock_one (t : Nat) : web.stock [false, true] t = 1 := mark_sum (parity t)

theorem closed (t : Nat) : flow.ClosedAt [false, true] t := fun _ _ c out => absurd (listed c) out

theorem distinct : Distinct [false, true] :=
  ⟨fun mem => match mem_cons_cases mem with
    | .inl same => Bool.noConfusion same
    | .inr no => (nomatch no),
   (fun no => nomatch no), trivial⟩

/-- **Nothing lost cannot be dropped from the gain bridge**: the cycle keeps opening by name with
what its formations require fixed within `[false, true]`, a list without repetition, balanced under
the first law, while the family's stock is one throughout and it is never given from beyond. -/
theorem bounded_while_opening :
    flow.Gainless ∧ flow.Balances web ∧ web.KeepsOpening Web.itself web.level 0 ∧
      (∀ f, web.RequiresWithin [false, true] f) ∧ Distinct [false, true] ∧
      (∀ t, web.stock [false, true] t = 1) ∧
      ∀ t, ¬ ((flow.withImbalance web).NetGiver [false, true] t none ∨
        ¬ flow.ClosedAt [false, true] t) :=
  ⟨gainless, balances, keeps_opening_by_name, requiresWithin, distinct, stock_one,
   fun t given => match given with
    | .inl rest => Flow.BalancesOn.rest_not_netGiver (balances.on [false, true] t) rest
    | .inr open_ => open_ (closed t)⟩

theorem takes_while_supported : flow.TakesWhileSupported web [false, true] 0 :=
  fun t f _ supported =>
    have same : f = parity t := supported_iff.mp supported
    ⟨Eq.subst (motive := fun x => x ∈ flow.present t) same.symm (.head []),
     Eq.subst (motive := fun x => 0 < x) (mark_sum f).symm Nat.zero_lt_one⟩

theorem capacity : flow.Capacity [false, true] 1 := fun _ f _ => Nat.le_of_eq (mark_sum (!f))

theorem renewers_le (t : Nat) : flow.renewers [false, true] t ≤ 1 :=
  show sign (total [false, true] (flow.give t (parity t))) + 0 ≤ 1 from sign_le_one _

/-- **Nothing lost cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: keeping opening
by name under upkeep, balanced, with capacity one, the cycle has one renewer a step. -/
theorem renewers_bounded_while_opening :
    web.KeepsOpening Web.itself web.level 0 ∧ flow.TakesWhileSupported web [false, true] 0 ∧
      flow.Balances web ∧ flow.Capacity [false, true] 1 ∧ ∀ t, flow.renewers [false, true] t ≤ 1 :=
  ⟨keeps_opening_by_name, takes_while_supported, balances, capacity, renewers_le⟩

/-- No formation of the cycle is supported at two consecutive steps. -/
theorem brief : ∀ t g, ¬ ∀ i, i ≤ 1 → web.Supported (t + i) g := fun t _ all =>
  ListTests.not_ne_self (parity t) ((supported_iff.mp (all 1 (Nat.le_refl 1))).symm.trans
    (supported_iff.mp (all 0 (Nat.zero_le 1))))

theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- **The cycle is opened by the opened within one**, by brevity (`opened`, restated for the
recency form). -/
theorem opened_within : Flow.OpenedByOpenedWithin flow web 1 :=
  Flow.openedByOpenedWithin_of_brief balances acting dependent unloosened brief opened.1

/-- **Opened by the opened without widening, within one** (`cycle`, restated for the recency form).
The cycle balances with only active formations giving and activity needing support, is opened by
the opened within one, keeps its range along the passing continuation, and keeps widening neither
along it nor by name. -/
theorem cycle_within :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧ Flow.OpenedByOpenedWithin flow web 1 ∧
      web.IncludesAcrossFrom passing web.level 0 ∧ (∀ T, ¬ web.KeepsOpening passing web.level T) ∧
      ∀ T, ¬ web.KeepsWidening Web.itself web.level T :=
  ⟨balances, acting, dependent, opened_within, includes_across, not_opening,
   not_keeps_widening_by_name⟩

/-- The active formation passes support to the other at every step. -/
theorem passesSupport_next (t : Nat) : flow.PassesSupport web t (parity t) (parity (t + 1)) :=
  ⟨.head [], supported_iff.mpr rfl, gains_iff.mpr rfl, parity (t + 1), rfl, rises_at rfl,
   give_pos rfl⟩

theorem linked_along_passings : ∀ (k S : Nat),
    Web.Linked (Web.passingContinuation (flow.PassesSupport web)) S (parity S) (S + k)
      (parity (S + k))
  | 0, S => .here S (parity S)
  | k + 1, S => .next (f := parity (S + 1)) (.inr (passesSupport_next S))
      (Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.PassesSupport web))
          (S + 1) (parity (S + 1)) x (parity x))
        (Nat.succ_add S k) (linked_along_passings k (S + 1)))

theorem linked_along_passings_to {S U : Nat} (le : S ≤ U) :
    Web.Linked (Web.passingContinuation (flow.PassesSupport web)) S (parity S) U (parity U) :=
  match le_dest le with
  | ⟨k, at_⟩ => Eq.subst (motive := fun x =>
      Web.Linked (Web.passingContinuation (flow.PassesSupport web)) S (parity S) x (parity x))
      at_.symm (linked_along_passings k S)

/-- Along "carry on, or pass support" nothing supported is lost. -/
theorem includes_along_passings :
    web.IncludesAcrossFrom (Web.passingContinuation (flow.PassesSupport web)) web.level 0 :=
  fun S U _ le _ admitted => ⟨parity U,
    Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.PassesSupport web)) S x U
        (parity U))
      (supported_iff.mp admitted).symm (linked_along_passings_to le),
    supported_iff.mpr rfl⟩

/-- **Along "carry on, or pass support" the cycle's levels exceed from no step to a later one**, so
it keeps opening from no step there: the instance of `Flow.not_exceedsAcross_along_passings`. -/
theorem not_opening_along {S U : Nat} (le : S ≤ U) :
    ¬ web.ExceedsAcross (Web.passingContinuation (flow.PassesSupport web)) web.level S U :=
  Flow.not_exceedsAcross_along_passings balances acting dependent unloosened
    (fun _ _ _ step => step) le

/-- **Generation without widening.** At every supported occurrence of the cycle the line along
"carry on, or pass support" is 全生成, while along it the levels exceed from no step to a later
one, and by name the range keeps widening from no step. -/
theorem generation_without_widening :
    (∀ S f, web.Supported S f →
      «全生成» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
        (web.admitting web.level).activityClass (web.admitting web.level).carrierClass (S, f)) ∧
      (∀ S U, S ≤ U →
        ¬ web.ExceedsAcross (Web.passingContinuation (flow.PassesSupport web)) web.level S U) ∧
      ∀ T, ¬ web.KeepsWidening Web.itself web.level T :=
  ⟨fun S _ supported => Flow.generation_of_includes_brief brief includes_along_passings
     (Nat.zero_le S) supported,
   fun _ _ le => not_opening_along le, not_keeps_widening_by_name⟩

/-- **The cycle is 生成 at every supported occurrence**, along "carry on, or pass support": its
全生成 there gives it (`«全生成则生成»`). -/
theorem generates {S : Nat} {f : Bool} (supported : web.Supported S f) :
    «生成» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
      (web.admitting web.level).activityClass (web.admitting web.level).carrierClass (S, f) :=
  «全生成则生成» (Flow.generation_of_includes_brief brief includes_along_passings (Nat.zero_le S)
    supported)

end ClosedCycle

/-! ### One range, two carriers: what the recency bound separates -/

namespace OpeningChain

open OwnCondition

/-- The rising course, as the web's own levels, keeps widening by name. -/
theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

theorem stock_le (cs : List Nat) (t : Nat) : web.stock cs t ≤ cs.length :=
  Nat.le_trans (total_le cs fun c _ => rung_le_one c t) (Nat.le_of_eq (total_ones cs))

/-- **A finite family cannot be dropped from the gain bridge**: the rising web keeps widening by
name with what each formation requires fixed, but on no single finite family, and no finite
family's stock passes its length. -/
theorem fixed_but_unbounded :
    web.KeepsWidening Web.itself web.level 0 ∧ relay.Balances web ∧
      (∀ s t f c, web.requires s f c → web.requires t f c ∧ web.need s f c = web.need t f c) ∧
      ∀ cs, ¬ ∀ K M, ∃ t, M ≤ t ∧ K < web.stock cs t :=
  ⟨keeps_widening, relay_balances, fun _ _ _ _ req => ⟨req, rfl⟩,
   fun cs passes => match passes cs.length 0 with
    | ⟨t, _, over⟩ => Nat.not_le_of_gt over (stock_le cs t)⟩

/-- **The relay is opened by the opened within one**, though its supports last (`relay_opened`,
restated for the recency form). -/
theorem relay_within : Flow.OpenedByOpenedWithin relay web 1 :=
  ⟨fun N => ⟨N, N + 1, Nat.le_refl N, gains_iff.mpr rfl⟩,
   fun S f gains => fun none =>
    have same : f = S + 1 + 1 := gains_iff.mp gains
    none ⟨f, S + 1, S, rfl,
      Eq.subst (motive := fun x => web.Rises (S + 1) x) same.symm (rises_next (S + 1)), .head [],
      Eq.subst (motive := fun x => 0 < opening (S + 1) x) same.symm (opening_pos (S + 1)),
      supported_iff.mpr (Nat.le_refl (S + 1)), Nat.le_refl S, Nat.lt_succ_self S,
      gains_iff.mpr rfl⟩⟩

/-- Support on the rising web lasts: no bound makes it brief. -/
theorem lasting (K : Nat) : ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g :=
  fun brief => brief 0 0 fun _ _ => supported_iff.mpr (Nat.zero_le _)

/-- **The single giver is opened by the opened within no bound** (`oneGiver_not_opened`, restated
for the recency form). -/
theorem oneGiver_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  fun ⟨_, within⟩ => within 0 (0 + K + 1) (gains_iff.mpr rfl)
    fun ⟨_, _, u, _, _, mem, _, _, _, _, gained⟩ => match mem_cons_cases mem with
      | .inl same => gained.1 (supported_iff.mpr
          (Eq.subst (motive := fun x => x ≤ u) same.symm (Nat.zero_le u)))
      | .inr inner => nomatch inner

/-- **Brevity is sufficient, not necessary, and the bound separates the carriers**: the relay is
opened by the opened within one with lasting supports; the single giver, on the same web, within
no bound (`carried`, restated for the recency form). -/
theorem carriers_within :
    Flow.OpenedByOpenedWithin relay web 1 ∧ (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ K, ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  ⟨relay_within, lasting, oneGiver_not_within⟩

/-- On the rising web requirements never loosen. -/
theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- On the rising web gains of support recur. -/
theorem gains_recur (N : Nat) : ∃ t f, N ≤ t ∧ web.GainsSupport t f :=
  ⟨N, N + 1, Nat.le_refl N, gains_iff.mpr rfl⟩

/-- **Brevity cannot be dropped from the uniform law**: with the single giver every other premise of
`Flow.openedByOpenedWithin_of_brief` holds, supports last, and within no bound is the flow opened
by the opened, so the uniform law fails at some gain for every bound. -/
theorem brevity_needed :
    oneGiver.Balances web ∧ oneGiver.Acting web ∧ web.Dependent ∧ (∀ t f, web.Unloosened t f) ∧
      (∀ N, ∃ t f, N ≤ t ∧ web.GainsSupport t f) ∧
      (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ K, ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  ⟨oneGiver_balances, oneGiver_acting, dependent, unloosened, gains_recur, lasting,
   oneGiver_not_within⟩

/-- Formation `0` at step `0`, formation `t` at step `t + 1`. -/
def lagging : Nat → List Nat
  | 0 => [0]
  | t + 1 => [t]

/-- **The lagged relay**: at step `t + 1` formation `t` alone takes part (for `t ≥ 1`, two steps
after it gained support) and gives the unit that steps the rising course; formation `0`, which
never gained support, takes part at steps `0` and `1`. -/
def laggedRelay : Flow Nat Nat := ⟨lagging, fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem laggedRelay_balances : laggedRelay.Balances web := fun t c => match t with
  | 0 => show rung c 1 + (0 + 0) = rung c 0 + (opening 0 c + 0) from balanced_step 0 c
  | t + 1 => show rung c (t + 1 + 1) + (0 + 0) = rung c (t + 1) + (opening (t + 1) c + 0) from
      balanced_step (t + 1) c

theorem laggedRelay_acting : laggedRelay.Acting web := fun t _ _ mem _ => match t, mem with
  | 0, mem => match mem_cons_cases mem with
    | .inl same => Nat.le_of_eq same
    | .inr inner => nomatch inner
  | t + 1, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ≤ t + 1) same.symm (Nat.le_succ t)
    | .inr inner => nomatch inner

/-- **The lagged relay is opened by the opened within two.** From step `2` on, each gain is given
by the formation that gained support two steps before. The gains at steps `0` and `1` are given by
formation `0`, which never gained support, and within two leaves gains before step `2`
unconstrained. -/
theorem laggedRelay_within : Flow.OpenedByOpenedWithin laggedRelay web 2 :=
  ⟨gains_recur, fun S f gains => fun none =>
    have same : f = S + 2 + 1 := gains_iff.mp gains
    none ⟨f, S + 1, S, rfl,
      Eq.subst (motive := fun x => web.Rises (S + 2) x) same.symm (rises_next (S + 2)), .head [],
      Eq.subst (motive := fun x => 0 < opening (S + 2) x) same.symm (opening_pos (S + 2)),
      supported_iff.mpr (Nat.le_succ (S + 1)), Nat.le_refl S,
      Nat.lt_of_lt_of_le (Nat.lt_succ_self S) (Nat.le_succ (S + 1)), gains_iff.mpr rfl⟩⟩

/-- **At no origin is the lagged relay opened by the opened in UE4's form**: the gain across the
step from `T + 1` is given by formation `T` alone, which gained support before `T`. -/
theorem laggedRelay_not_opened (T : Nat) : ¬ Flow.OpenedByOpened laggedRelay web T :=
  fun ⟨_, opened⟩ => match opened (T + 1) (T + 1 + 1) (Nat.lt_succ_self T) (gains_iff.mpr rfl) with
    | ⟨_, _, u, _, _, mem, _, _, from_, _, gained⟩ => match mem_cons_cases mem with
      | .inl same => Nat.not_succ_le_self u
          (Eq.subst (motive := fun x => x ≤ u) (same.symm.trans (gains_iff.mp gained)) from_)
      | .inr inner => nomatch inner

/-- **The recency form admits what UE4's form excludes at every origin.** On the rising web the
lagged relay balances, only active formations give, activity needs support and gains recur; it is
opened by the opened within two, and at no origin in UE4's form. -/
theorem within_not_fixed_origin :
    laggedRelay.Balances web ∧ laggedRelay.Acting web ∧ web.Dependent ∧
      (∀ N, ∃ t f, N ≤ t ∧ web.GainsSupport t f) ∧ Flow.OpenedByOpenedWithin laggedRelay web 2 ∧
      ∀ T, ¬ Flow.OpenedByOpened laggedRelay web T :=
  ⟨laggedRelay_balances, laggedRelay_acting, dependent, gains_recur, laggedRelay_within,
   laggedRelay_not_opened⟩

/-- Formation `0` at step `0`, formation `1` at every later step. -/
def lateGiving : Nat → List Nat
  | 0 => [0]
  | _ + 1 => [1]

theorem lateGiving_succ (n : Nat) : lateGiving (n + 1) = [1] := rfl

/-- **A late single giver**: formation `1`, which gained support across the step from `0`, gives
every later unit. -/
def lateGiver : Flow Nat Nat := ⟨lateGiving, fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem lateGiver_balances : lateGiver.Balances web := fun t c => match t with
  | 0 => show rung c 1 + (0 + 0) = rung c 0 + (opening 0 c + 0) from balanced_step 0 c
  | t + 1 => show rung c (t + 1 + 1) + (0 + 0) = rung c (t + 1) + (opening (t + 1) c + 0) from
      balanced_step (t + 1) c

theorem lateGiver_acting : lateGiver.Acting web := fun t _ _ mem _ => match t, mem with
  | 0, mem => match mem_cons_cases mem with
    | .inl same => Nat.le_of_eq same
    | .inr inner => nomatch inner
  | t + 1, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ≤ t + 1) same.symm
        (Nat.succ_le_succ (Nat.zero_le t))
    | .inr inner => nomatch inner

/-- **In UE4's form, from origin `0`, the late single giver is opened by the opened**: its one
lasting carrier gained support after the origin. -/
theorem lateGiver_opened : Flow.OpenedByOpened lateGiver web 0 :=
  ⟨gains_recur, fun t f after gains => match t, after, gains_iff.mp gains with
    | s + 1, _, same => ⟨f, 1, 0, rfl,
        Eq.subst (motive := fun x => web.Rises (s + 1) x) same.symm (rises_next (s + 1)),
        .head [],
        Eq.subst (motive := fun x => 0 < opening (s + 1) x) same.symm (opening_pos (s + 1)),
        supported_iff.mpr (Nat.succ_le_succ (Nat.zero_le s)), Nat.le_refl 0, Nat.zero_lt_succ s,
        gains_iff.mpr rfl⟩⟩

/-- **In the recency form the late single giver is opened by the opened within no bound**: the
gain across the step from `1 + K` is given by formation `1` alone, which gained support before
step `1`. -/
theorem lateGiver_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin lateGiver web K :=
  fun ⟨_, within⟩ => within 1 (1 + K + 1) (gains_iff.mpr rfl)
    fun ⟨_, g, u, _, _, mem, _, _, from_, _, gained⟩ =>
      have listed : lateGiving (1 + K) = [1] :=
        (congrArg lateGiving (Nat.add_comm 1 K)).trans (lateGiving_succ K)
      match mem_cons_cases (Eq.subst (motive := fun l => g ∈ l) listed mem) with
      | .inl same =>
        Nat.not_succ_le_self u (Eq.subst (motive := fun x => x ≤ u)
          (same.symm.trans (gains_iff.mp gained)) from_)
      | .inr inner => nomatch inner

/-- **The two forms are independent**: on one web, the late single giver meets UE4's form at origin
`0` and the recency form at no bound; the lagged relay meets the recency form within two and UE4's
form at no origin. -/
theorem forms_independent :
    lateGiver.Balances web ∧ lateGiver.Acting web ∧ Flow.OpenedByOpened lateGiver web 0 ∧
      (∀ K, ¬ Flow.OpenedByOpenedWithin lateGiver web K) ∧
      Flow.OpenedByOpenedWithin laggedRelay web 2 ∧ ∀ T, ¬ Flow.OpenedByOpened laggedRelay web T :=
  ⟨lateGiver_balances, lateGiver_acting, lateGiver_opened, lateGiver_not_within,
   laggedRelay_within, laggedRelay_not_opened⟩

end OpeningChain

/-! ### Saturation: lasting support keeps and never generates -/

namespace Saturated

theorem supported (t n : Nat) : web.Supported t n := fun _ _ => Nat.le_refl 1

theorem no_carry (z w : Nat × Nat) :
    ¬ «传» (Web.continuationStep (Web.passingContinuation (still.PassesSupport web)))
      (web.admitting web.level).activityClass (web.admitting web.level).carrierClass z w :=
  fun ⟨⟨⟨next, kind⟩, alike⟩, begins⟩ => match kind with
    | .inl same => begins ⟨z, ⟨next, kind⟩, alike, same⟩
    | .inr passes => nomatch passes.1

theorem endless (x : Nat × Nat) :
    «不穷» (Web.continuationStep (Web.passingContinuation (still.PassesSupport web)))
      (web.admitting web.level).activityClass x :=
  fun y _ => ⟨(y.1 + 1, y.2), ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => supported _ _, fun _ => supported _ _⟩⟩⟩

/-- **Brevity cannot be dropped from the generation law**: with every formation supported
throughout, every line along "carry on, or pass support" never ends and keeps (全守), and none is
全生成. -/
theorem lasting_kept :
    (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ x, «全守» (Web.continuationStep (Web.passingContinuation (still.PassesSupport web)))
          (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x ∧
        ¬ «全生成» (Web.continuationStep (Web.passingContinuation (still.PassesSupport web)))
          (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x :=
  ⟨fun _ brief => brief 0 0 fun _ _ => supported _ _,
   fun x => ⟨⟨endless x, x, .inl rfl, fun z w _ c => no_carry z w c⟩,
     fun ⟨_, ahead⟩ => match ahead x (.inl rfl) with
       | ⟨z, w, _, c⟩ => no_carry z w c⟩⟩

/-- **Nothing still is opened by the opened within any bound**: everything is supported throughout,
so nothing gains support, and no gain recurs (`still_not_opened`, restated for the recency
form). -/
theorem still_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin still web K :=
  fun ⟨recur, _⟩ => match recur 0 with
    | ⟨_, _, _, gains⟩ => gains.1 (fun _ _ => Nat.le_refl 1)

/-- **Ranking by opened by the opened within a bound reverses widening** (`reverses`, restated for
the recency form). The relay is opened by the opened within one and its levels are the rising
course; a flow opened by the opened within no bound, on a web whose levels are the saturated
course, has levels that widen the rising course (read on the same requirements). -/
theorem reverses_within :
    Flow.OpenedByOpenedWithin OpeningChain.relay OpeningChain.web 1 ∧
      OpeningChain.web.level = OwnCondition.rising ∧
      (∀ K, ¬ Flow.OpenedByOpenedWithin still web K) ∧ web.level = OwnCondition.full ∧
      OwnCondition.web.Widens OwnCondition.full OwnCondition.rising :=
  ⟨OpeningChain.relay_within, OpeningChain.level_rising, still_not_within, level_full,
   OwnCondition.full_widens_rising⟩

end Saturated

/-! ### Loosening needs: what fixed requirements do in the gain bridge -/

namespace Loosening

/-- One once `n` is at most `t`, two before. -/
def strict : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 2
  | n + 1, t + 1 => strict n t

theorem strict_le_one_iff : ∀ {n t : Nat}, strict n t ≤ 1 ↔ n ≤ t
  | 0, _ => ⟨fun _ => Nat.zero_le _, fun _ => Nat.le_refl 1⟩
  | _ + 1, 0 => ⟨fun le => absurd le (Nat.not_succ_le_self 1),
      fun le => absurd le (Nat.not_succ_le_zero _)⟩
  | n + 1, t + 1 => ⟨fun le => Nat.succ_le_succ ((strict_le_one_iff (n := n) (t := t)).mp le),
      fun le => (strict_le_one_iff (n := n) (t := t)).mpr (Nat.le_of_succ_le_succ le)⟩

/-- One condition standing at one throughout; formation `n` requires it, at need one from step `n`
on and two before: what the formations need loosens. -/
def web : Web Nat Unit :=
  ⟨fun _ _ => 1, fun t n => n ≤ t, fun _ _ _ => True, fun t n _ => strict n t, fun _ _ _ => False⟩

theorem supported_iff {t n : Nat} : web.Supported t n ↔ n ≤ t :=
  ⟨fun supported => strict_le_one_iff.mp (supported () trivial),
   fun le _ _ => strict_le_one_iff.mpr le⟩

theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

/-- **Fixed needs cannot be dropped from the gain bridge**: the course keeps widening by name with
every requirement within `[()]`, but needs loosen, and the stock is one throughout. -/
theorem bounded_while_widening :
    web.KeepsWidening Web.itself web.level 0 ∧ (∀ t f c, web.requires t f c → c ∈ [()]) ∧
      web.need 0 1 () ≠ web.need 1 1 () ∧ ∀ t, web.stock [()] t = 1 :=
  ⟨keeps_widening, fun _ _ c _ => match c with | () => .head [],
   fun same => Nat.lt_irrefl 1 (Eq.subst (motive := fun x => 1 < x) same (Nat.lt_succ_self 1)),
   fun _ => rfl⟩

end Loosening

/-! ### A source from nothing: what the first law does in the gain bridge -/

namespace Source

/-- One condition standing at `t + 1` at step `t`; formation `n` requires it at need `n + 1`. -/
def web : Web Nat Unit :=
  ⟨fun t _ => t + 1, fun t n => n ≤ t, fun _ _ _ => True, fun _ n _ => n + 1, fun _ _ _ => False⟩

/-- Formation `0` gives one unit a step and takes nothing. -/
def flow : Flow Nat Unit := ⟨fun _ => [0], fun _ _ _ => 0, fun _ _ _ => 1⟩

theorem supported_iff {t n : Nat} : web.Supported t n ↔ n ≤ t :=
  ⟨fun supported => Nat.le_of_succ_le_succ (supported () trivial),
   fun le _ _ => Nat.succ_le_succ le⟩

theorem balances : flow.Balances web := fun _ _ => rfl

theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

theorem every : ∀ c : Unit, c ∈ [()]
  | () => .head []

theorem distinct : Distinct [()] := ⟨(fun no => nomatch no), trivial⟩

theorem requiresWithin : ∀ f, web.RequiresWithin [()] f :=
  fun _ _ _ c _ => ⟨trivial, rfl, every c⟩

theorem closed (t : Nat) : flow.ClosedAt [()] t := fun _ _ c out => absurd (every c) out

theorem not_gainless : ¬ flow.Gainless := fun gainless =>
  Nat.not_succ_le_zero 0 (gainless [()] 0 distinct (closed 0) 0 (.head []))

/-- **The first law cannot be dropped from the gain bridge**: a balanced finite world, its one
condition fed from nothing, keeps widening by name with fixed requirements, while its family is
closed and never given from beyond. -/
theorem from_nothing :
    flow.Balances web ∧ web.KeepsWidening Web.itself web.level 0 ∧
      (∀ f, web.RequiresWithin [()] f) ∧ (∀ c, c ∈ [()]) ∧ Distinct [()] ∧ ¬ flow.Gainless ∧
      ∀ t, ¬ ((flow.withImbalance web).NetGiver [()] t none ∨ ¬ flow.ClosedAt [()] t) :=
  ⟨balances, keeps_widening, requiresWithin, every, distinct, not_gainless,
   fun t given => match given with
    | .inl rest => Flow.BalancesOn.rest_not_netGiver (balances.on [()] t) rest
    | .inr open_ => open_ (closed t)⟩

end Source

/-! ### The kind relay: 全生成 at two orders and keeping widening, together -/

namespace KindRelay

open ClosedCycle (parity)

/-- Parity returns after two steps. -/
theorem parity_two (t : Nat) : parity (t + 2) = parity t := Bool.not_not (parity t)

/-- After an odd step comes an even one. -/
theorem odd_of_next_even {t : Nat} (even : parity (t + 1) = false) : parity t = true :=
  (Bool.not_not (parity t)).symm.trans (congrArg (fun b => !b) even)

/-- Six formations of two kinds: `a0`, `a1` and `e` of one, `b0`, `b1` and `c` of the other. -/
inductive Form
  | a0 | a1 | e | b0 | b1 | c
  deriving DecidableEq

open Form

/-- Membership among the formations, decided by `decideMem`. -/
abbrev memDecidable (a : Form) (l : List Form) : Decidable (a ∈ l) := decideMem a l

attribute [local instance] memDecidable

/-- The six formations, listed. -/
def allForms : List Form := [a0, a1, e, b0, b1, c]

theorem every_form : ∀ f, f ∈ allForms := by
  intro f; cases f <;> decide

theorem distinct_forms : Distinct allForms :=
  ⟨by decide, by decide, by decide, by decide, by decide, (fun no => nomatch no), trivial⟩

/-- The kind of a formation. -/
def kind : Form → Bool
  | a0 => false | a1 => false | e => false
  | b0 => true | b1 => true | c => true

/-- Two formations of one kind. -/
def sameKind (g f : Form) : Prop := kind g = kind f

theorem sameKind_refl (f : Form) : sameKind f f := rfl

/-- What each formation's own condition holds at a step of each parity: at even steps `a0` and `b0`
hold two units, at odd steps `a1`, `e`, `b1` and `c` one each. -/
def amount : Bool → Form → Nat
  | false, a0 => 2 | false, a1 => 0 | false, e => 0
  | false, b0 => 2 | false, b1 => 0 | false, c => 0
  | true, a0 => 0 | true, a1 => 1 | true, e => 1
  | true, b0 => 0 | true, b1 => 1 | true, c => 1

/-- Supported at a step of the parity: its own condition holds its need of one. -/
abbrev Holds (p : Bool) (f : Form) : Prop := 1 ≤ amount p f

/-- Where each formation moves its units across a step of each parity. Across an even step `a0`
moves a unit to `a1` and one to `c`, and `b0` one to `b1` and one to `e`; across an odd step `a1`
and `e` move theirs to `a0`, and `b1` and `c` theirs to `b0`. -/
def giveSupport : Bool → Form → List Form
  | false, a0 => [a1, c] | false, a1 => [] | false, e => []
  | false, b0 => [b1, e] | false, b1 => [] | false, c => []
  | true, a0 => [] | true, a1 => [a0] | true, e => [a0]
  | true, b0 => [] | true, b1 => [b0] | true, c => [b0]

/-- The units a formation moves to a condition across a step of each parity. -/
def giveAt (p : Bool) (g f : Form) : Nat := total (giveSupport p g) fun x => if x = f then 1 else 0

/-- Each formation taking part takes all its own condition holds. -/
def takeAt (p : Bool) (g x : Form) : Nat := if x = g then amount p g else 0

/-- The formations taking part at a step of each parity: the supported ones. -/
def presentAt : Bool → List Form
  | false => [a0, b0]
  | true => [a1, e, b1, c]

/-- Where each supported formation's unit goes on within its kind. -/
def lineage : Bool → Form → Form
  | false, a0 => a1 | false, a1 => a1 | false, e => e
  | false, b0 => b1 | false, b1 => b1 | false, c => c
  | true, a0 => a0 | true, a1 => a0 | true, e => a0
  | true, b0 => b0 | true, b1 => b0 | true, c => b0

/-- Where a supported formation at an even step begins a line of the other kind. -/
def starter : Form → Form
  | a0 => c | a1 => a1 | e => e | b0 => e | b1 => b1 | c => c

/-- What gives a formation supported at an even step its units, within its kind. -/
def back : Form → Form
  | a0 => a1 | a1 => a1 | e => e | b0 => b1 | b1 => b1 | c => c

/-! #### The relay's facts, by cases -/

theorem holds_brief : ∀ p f, Holds p f → ¬ Holds (!p) f := by
  intro p f; cases p <;> cases f <;> decide

theorem present_holds : ∀ p f, f ∈ presentAt p → Holds p f := by
  intro p f; cases p <;> cases f <;> decide

theorem moves_facts : ∀ p g f, 0 < giveAt p g f →
    g ∈ presentAt p ∧ Holds p g ∧ ¬ Holds p f ∧ Holds (!p) f ∧ amount p f < amount (!p) f := by
  intro p g f; cases p <;> cases g <;> cases f <;> decide

theorem lineage_facts : ∀ p f, Holds p f →
    0 < giveAt p f (lineage p f) ∧ kind f = kind (lineage p f) ∧ Holds (!p) (lineage p f) := by
  intro p f; cases p <;> cases f <;> decide

theorem starter_facts : ∀ f, Holds false f →
    0 < giveAt false f (starter f) ∧ ¬ Holds false (starter f) := by
  intro f; cases f <;> decide

theorem starter_fresh : ∀ f g, Holds false f → 0 < giveAt false g (starter f) →
    kind g ≠ kind (starter f) := by
  intro f g; cases f <;> cases g <;> decide

theorem back_facts : ∀ f, Holds false f →
    Holds true (back f) ∧ 0 < giveAt true (back f) f ∧ kind (back f) = kind f := by
  intro f; cases f <;> decide

/-! #### Any web and flow that run the relay -/

/-- A web and a flow on the six formations **run the relay** where a formation is supported exactly
where its own condition holds at the step's parity, and passes support exactly where it moves a
unit. The closed relay and the fed one both run it. -/
structure Runs {C : Type} (W : Web Form C) (L : Flow Form C) : Prop where
  supported : ∀ t f, W.Supported t f ↔ Holds (parity t) f
  passes : ∀ t g f, L.PassesSupport W t g f ↔ 0 < giveAt (parity t) g f

namespace Runs

variable {C : Type} {W : Web Form C} {L : Flow Form C}

/-- Each supported formation passes support within its kind. -/
theorem step (run : Runs W L) {t : Nat} {f : Form} (supported : W.Supported t f) :
    L.PassesSupport W t f (lineage (parity t) f) ∧ sameKind f (lineage (parity t) f) ∧
      W.Supported (t + 1) (lineage (parity t) f) :=
  match lineage_facts (parity t) f ((run.supported t f).mp supported) with
  | ⟨moves, same, holds⟩ =>
    ⟨(run.passes t f _).mpr moves, same, (run.supported (t + 1) _).mpr holds⟩

theorem along (run : Runs W L) {t : Nat} {f : Form} (supported : W.Supported t f) :
    W.withinKind sameKind (L.PassesSupport W) t f (lineage (parity t) f) :=
  .inr ⟨(run.step supported).1, (run.step supported).2.1⟩

/-- No formation is supported at two steps running. -/
theorem brief (run : Runs W L) (t : Nat) (g : Form) (supported : W.Supported t g) :
    ¬ W.Supported (t + 1) g :=
  fun after => holds_brief _ g ((run.supported t g).mp supported) ((run.supported (t + 1) g).mp after)

/-- Every supported formation is linked, within its kind, to a formation supported at every later
step. -/
theorem linked (run : Runs W L) (S : Nat) {f : Form} (supported : W.Supported S f) :
    ∀ k, ∃ g, Web.Linked (W.withinKind sameKind (L.PassesSupport W)) S f (S + k) g ∧
      W.Supported (S + k) g
  | 0 => ⟨f, .here S f, supported⟩
  | k + 1 => match run.linked S supported k with
    | ⟨g, linked, sg⟩ =>
      ⟨lineage (parity (S + k)) g, Web.Linked.snoc linked (run.along sg), (run.step sg).2.2⟩

/-- **Within kinds nothing admitted is lost.** -/
theorem includes (run : Runs W L) :
    W.IncludesAcrossFrom (W.withinKind sameKind (L.PassesSupport W)) W.level 0 :=
  fun S _ _ le f admitted => match le_dest le with
    | ⟨k, at_⟩ => match run.linked S admitted k with
      | ⟨g, linked, sg⟩ =>
        ⟨g, Eq.subst (motive := fun x => Web.Linked (W.withinKind sameKind (L.PassesSupport W)) S f
            x g) at_.symm linked,
         Eq.subst (motive := fun x => W.Supported x g) at_.symm sg⟩

/-- Across an even step nothing continues, within its kind, into a formation begun there. -/
theorem not_into (run : Runs W L) {t : Nat} (even : parity t = false) {f : Form}
    (holds : Holds false f) (g : Form) :
    ¬ W.withinKind sameKind (L.PassesSupport W) t g (starter f) :=
  fun step => match step with
  | .inl ⟨same, sg⟩ => (starter_facts f holds).2
      (Eq.subst (motive := fun p => Holds p (starter f)) even
        (Eq.subst (motive := fun x => Holds (parity t) x) same ((run.supported t g).mp sg)))
  | .inr ⟨passes, kinds⟩ => starter_fresh f g holds
      (Eq.subst (motive := fun q => 0 < giveAt q g (starter f)) even ((run.passes t g _).mp passes))
      kinds

/-- **At every odd step something is open**: `c`, begun across the even step before, is linked
within its kind to nothing at any earlier step. -/
theorem exceeds (run : Runs W L) {S U : Nat} (lt : S < U) (odd : parity U = true) :
    W.ExceedsAcross (W.withinKind sameKind (L.PassesSupport W)) W.level S U :=
  ⟨c, (run.supported U c).mpr (Eq.subst (motive := fun p => Holds p c) odd.symm (by decide)),
   fun _ linked _ => match Web.Linked.last linked with
    | .inl ⟨at_, _⟩ => Nat.lt_irrefl S (Eq.subst (motive := fun x => S < x) at_.symm lt)
    | .inr ⟨t, g, at_, _, step⟩ =>
      run.not_into (f := a0)
        (ListTests.false_of_not (b := parity t)
          (Eq.subst (motive := fun x => parity x = true) at_.symm odd))
        (by decide) g step⟩

/-- **Within kinds something keeps being opened.** -/
theorem opens (run : Runs W L) :
    W.KeepsOpening (W.withinKind sameKind (L.PassesSupport W)) W.level 0 :=
  fun S _ => match h : parity S with
    | false => ⟨S + 1, Nat.le_succ S, run.exceeds (Nat.lt_succ_self S)
        (show (!parity S) = true from Eq.subst (motive := fun b => (!b) = true) h.symm rfl)⟩
    | true => ⟨S + 2, Nat.le_add_right S 2,
        run.exceeds (Nat.lt_of_lt_of_le (Nat.lt_succ_self S) (Nat.le_succ (S + 1)))
          ((parity_two S).trans h)⟩

/-- **The relay keeps widening within kinds**, from step `0`. -/
theorem keeps_widening (run : Runs W L) :
    W.KeepsWidening (W.withinKind sameKind (L.PassesSupport W)) W.level 0 :=
  ⟨run.includes, run.opens⟩

/-- **Every supported occurrence is 全生成 within kinds**, at (activity, one formation): each
lineage renews through brief carriers at every step. -/
theorem generation (run : Runs W L) {x : Nat × Form} (start : W.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (W.withinKind sameKind (L.PassesSupport W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass x :=
  Web.generation_of_one_step_supports (fun _ _ alike => alike) run.brief start
    (Web.endless_of_successor (fun _ _ alike => alike)
      (fun y sy => ⟨(y.1 + 1, lineage (parity y.1) y.2), ⟨rfl, run.along sy⟩,
        ⟨fun _ => (run.step sy).2.2, fun _ => sy⟩⟩) start)

/-- At an even step a supported formation begins a line of the other kind, while its lineage goes
on: a carrying renewal along passing of support at (activity, kind). -/
theorem renews_even (run : Runs W L) {t : Nat} (even : parity t = false) {f : Form}
    (supported : W.Supported t f) :
    «传» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass ((W.admitting W.level).kindClass sameKind) (t, f)
      (t + 1, starter f) :=
  have holds : Holds false f :=
    Eq.subst (motive := fun p => Holds p f) even ((run.supported t f).mp supported)
  (Flow.BeginsAlong.carries_kind_iff sameKind_refl supported).mp
    ⟨(run.passes t f _).mpr (Eq.subst (motive := fun p => 0 < giveAt p f (starter f)) even.symm
        (starter_facts f holds).1),
     fun g step _ => run.not_into even holds g step⟩

/-- **Every supported occurrence is 全生成 one grain up**, along passing of support at (activity,
kind): from every point of the whole lineage, `a0` or `b0` begins a line of a kind within two
steps. -/
theorem generation_one_up (run : Runs W L) {x : Nat × Form} (start : W.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      (W.admitting W.level).activityClass ((W.admitting W.level).kindClass sameKind) x :=
  ⟨Web.endless_of_successor (fun _ _ alike => alike)
     (fun y sy => ⟨(y.1 + 1, lineage (parity y.1) y.2), ⟨rfl, .inr (run.step sy).1⟩,
       ⟨fun _ => (run.step sy).2.2, fun _ => sy⟩⟩) start,
   fun y reached =>
     have sy : W.Supported y.1 y.2 := Web.active_along_line (W := W.admitting W.level) start reached
     match h : parity y.1 with
     | false => ⟨y, (y.1 + 1, starter y.2), .inl rfl, run.renews_even h sy⟩
     | true =>
       have sz : W.Supported (y.1 + 1) (lineage (parity y.1) y.2) := (run.step sy).2.2
       ⟨(y.1 + 1, lineage (parity y.1) y.2), (y.1 + 1 + 1, starter (lineage (parity y.1) y.2)),
        .inr (.one ⟨⟨rfl, .inr (run.step sy).1⟩, ⟨fun _ => sz, fun _ => sy⟩⟩),
        run.renews_even (t := y.1 + 1) (show (!parity y.1) = false from
          Eq.subst (motive := fun b => (!b) = false) h.symm rfl) sz⟩⟩

/-- **Every supported occurrence is 全生成 at order 0**, along passing of support at (kind, one
formation): each kind's line renews through brief carriers at every step. -/
theorem generation_order_zero (run : Runs W L) {x : Nat × Form} (start : W.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      ((W.admitting W.level).kindClass sameKind) (W.admitting W.level).carrierClass x :=
  Web.generation_of_one_step_supports Web.kindClass_within run.brief start
    (Web.endless_of_successor Web.kindClass_within
      (fun y sy => ⟨(y.1 + 1, lineage (parity y.1) y.2), ⟨rfl, .inr (run.step sy).1⟩,
        ⟨fun _ => (run.step sy).2.2, fun _ => sy⟩, (run.step sy).2.1⟩) start)

/-- **全生成 at two orders**: on passing of support, with the grains one formation, the kind and
activity (`Web.kindGrains`), every supported occurrence is 全生成 at order 0 and at order 1
(`«阶全生成»`). -/
theorem generation_two_orders (run : Runs W L) {x : Nat × Form} (start : W.Supported x.1 x.2) :
    «阶全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        ((W.admitting W.level).kindGrains sameKind) 0 x ∧
      «阶全生成» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
        ((W.admitting W.level).kindGrains sameKind) 1 x :=
  ⟨run.generation_order_zero start, run.generation_one_up start⟩

/-- **Renewal without end at the kind grain** (`«生生»`): from `(0, a0)`, `a0` conditions the
beginning of `c`'s kind-line, which goes on into `b0`; `b0` begins `e`'s, which reaches `a0`; and so
on, the family being the supported occurrences at even steps. -/
theorem renews_without_end (run : Runs W L) :
    «生生» (Web.continuationStep (Web.passingContinuation (L.PassesSupport W)))
      ((W.admitting W.level).kindClass sameKind) (0, a0) :=
  ⟨fun z => parity z.1 = false ∧ W.Supported z.1 z.2,
   fun z ⟨even, sz⟩ => match run.renews_even even sz with
     | ⟨⟨stepP, alike⟩, begins⟩ =>
       have sy : W.Supported (z.1 + 1) (starter z.2) := alike.mp sz
       ⟨(z.1 + 1, starter z.2), (z.1 + 1 + 1, lineage (parity (z.1 + 1)) (starter z.2)), stepP,
        begins,
        .one ⟨⟨rfl, .inr (run.step sy).1⟩, ⟨fun _ => (run.step sy).2.2, fun _ => sy⟩,
          (run.step sy).2.1⟩,
        ⟨(parity_two z.1).trans even, (run.step sy).2.2⟩⟩,
   ⟨rfl, (run.supported 0 a0).mpr (by decide)⟩⟩

/-- Read with dormant carrying on by name, nothing opens from an odd step: whatever is supported
later is linked, within its kind, to something supported there. -/
theorem dormant_not_exceeds (run : Runs W L) {S U : Nat} (odd : parity S = true) (le : S ≤ U) :
    ¬ W.ExceedsAcross (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f)
      W.level S U :=
  fun ⟨g, sgU, apart⟩ => match hU : parity U with
  | true =>
    apart g (Web.Linked.mono (fun _ _ _ same => .inl same) (Web.Linked.itself_of_le le))
      ((run.supported S g).mpr (Eq.subst (motive := fun p => Holds p g) (hU.trans odd.symm)
        ((run.supported U g).mp sgU)))
  | false => match le_dest le with
    | ⟨0, at_⟩ => Bool.noConfusion (odd.symm.trans
        (Eq.subst (motive := fun x => parity x = false) at_ hU))
    | ⟨k + 1, at_⟩ =>
      have holds : Holds false g :=
        Eq.subst (motive := fun p => Holds p g) hU ((run.supported U g).mp sgU)
      have odd' : parity (S + k) = true :=
        odd_of_next_even (Eq.subst (motive := fun x => parity x = false) at_ hU)
      apart (back g)
        (Eq.subst (motive := fun x => Web.Linked
            (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f) S (back g) x g)
          at_.symm
          (Web.Linked.snoc (Web.Linked.mono (fun _ _ _ same => .inl same)
              (Web.Linked.itself_of_le (Nat.le_add_right S k)))
            (.inr ⟨(run.passes (S + k) (back g) g).mpr
                (Eq.subst (motive := fun p => 0 < giveAt p (back g) g) odd'.symm (back_facts g holds).2.1),
              (back_facts g holds).2.2⟩)))
        ((run.supported S (back g)).mpr
          (Eq.subst (motive := fun p => Holds p (back g)) odd.symm (back_facts g holds).1))

/-- **Read with dormant carrying on by name, the relay keeps opening from no step**: there `c`,
begun across an even step, is linked to `c` supported at the step before it, so nothing opens from
odd steps. The reading counts names, not lineages. -/
theorem not_keepsOpening_dormant (run : Runs W L) (T : Nat) :
    ¬ W.KeepsOpening (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f)
      W.level T :=
  fun opens => match h : parity T with
  | true => match opens T (Nat.le_refl T) with
    | ⟨_, le, exceeds⟩ => run.dormant_not_exceeds h le exceeds
  | false => match opens (T + 1) (Nat.le_succ T) with
    | ⟨_, le, exceeds⟩ => run.dormant_not_exceeds (S := T + 1)
        (show (!parity T) = true from Eq.subst (motive := fun b => (!b) = true) h.symm rfl) le exceeds

/-- **With dormant carrying on by name, beginnings still recur**: across every even step `a0`'s
passing to `c` begins along the reading, since nothing supported there continues into `c` within
its kind. -/
theorem begins_dormant (run : Runs W L) {t : Nat} (even : parity t = false) :
    L.BeginsAlong W (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f)
      t a0 c :=
  ⟨(run.passes t a0 c).mpr (Eq.subst (motive := fun p => 0 < giveAt p a0 c) even.symm (by decide)),
   fun g step sg => run.not_into (f := a0) even (by decide) g (match step with
     | .inl same => .inl ⟨same, sg⟩
     | .inr passes => .inr passes)⟩

/-- **The law of beginnings is one way**: with dormant carrying on by name, a reading containing
carrying on of the supported, a beginning lies after every step and nothing keeps opening from
any step. Beginnings open only where nothing supported earlier is linked to them. -/
theorem beginnings_without_opening (run : Runs W L) :
    (∀ S, ∃ j g h, S ≤ j ∧ L.BeginsAlong W
        (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f) j g h) ∧
      ∀ T, ¬ W.KeepsOpening
        (Web.passingContinuation fun t g f => L.PassesSupport W t g f ∧ sameKind g f) W.level T :=
  ⟨fun S => match h : parity S with
    | false => ⟨S, a0, c, Nat.le_refl S, run.begins_dormant h⟩
    | true => ⟨S + 1, a0, c, Nat.le_succ S, run.begins_dormant (t := S + 1)
        (show (!parity S) = false from Eq.subst (motive := fun b => (!b) = false) h.symm rfl)⟩,
   run.not_keepsOpening_dormant⟩

/-- Something is supported at every step. -/
theorem some_supported (run : Runs W L) (t : Nat) : ∃ f, W.Supported t f :=
  match h : parity t with
  | false => ⟨a0, (run.supported t a0).mpr (Eq.subst (motive := fun p => Holds p a0) h.symm
      (by decide))⟩
  | true => ⟨a1, (run.supported t a1).mpr (Eq.subst (motive := fun p => Holds p a1) h.symm
      (by decide))⟩

/-- **By name, or carrying on while supported, nothing admitted is kept across a step**: along any
continuation in which each formation continues only itself, since no formation is supported at two
steps running. -/
theorem not_includes_within_itself (run : Runs W L) {R : Nat → Form → Form → Prop}
    (within : ∀ t g f, R t g f → Web.itself t g f) (T : Nat) : ¬ W.IncludesAcrossFrom R W.level T :=
  fun includes => match run.some_supported T with
    | ⟨f, sf⟩ => match includes T (T + 1) (Nat.le_refl T) (Nat.le_succ T) f sf with
      | ⟨_, linked, sg⟩ => run.brief T f sf (Eq.subst (motive := fun h => W.Supported (T + 1) h)
          (within _ _ _ (Web.Linked.one_step linked rfl)).symm sg)

/-- **By name the relay keeps widening from no step.** -/
theorem not_keepsWidening_byName (run : Runs W L) (T : Nat) :
    ¬ W.KeepsWidening Web.itself W.level T :=
  fun keeps => run.not_includes_within_itself (fun _ _ _ same => same) T keeps.1

/-- **Carrying on while supported, the relay keeps widening from no step**: it loses at every
step. -/
theorem not_keepsWidening_supportedItself (run : Runs W L) (T : Nat) :
    ¬ W.KeepsWidening W.supportedItself W.level T :=
  fun keeps => run.not_includes_within_itself Web.supportedItself_within T keeps.1

end Runs

/-! #### The closed relay -/

/-- Six formations, each requiring its own condition at need one; the levels are `amount` at the
step's parity. -/
def web : Web Form Form :=
  ⟨fun t x => amount (parity t) x, fun t f => Holds (parity t) f, fun _ f x => x = f,
   fun _ _ _ => 1, fun _ f x => x = f⟩

/-- The supported formations take all their units and move them as `giveAt` says. -/
def flow : Flow Form Form :=
  ⟨fun t => presentAt (parity t), fun t g x => takeAt (parity t) g x,
   fun t g x => giveAt (parity t) g x⟩

theorem supported_iff {t : Nat} {f : Form} : web.Supported t f ↔ Holds (parity t) f :=
  ⟨fun s => s f rfl, fun h _ same =>
    Eq.subst (motive := fun x => 1 ≤ amount (parity t) x) same.symm h⟩

theorem passes_iff {t : Nat} {g f : Form} :
    flow.PassesSupport web t g f ↔ 0 < giveAt (parity t) g f :=
  ⟨fun ⟨_, _, _, _, same, _, gives⟩ =>
     Eq.subst (motive := fun x => 0 < giveAt (parity t) g x) same gives,
   fun gives => match moves_facts (parity t) g f gives with
    | ⟨mem, hg, nf, hf, rises⟩ => ⟨mem, supported_iff.mpr hg,
        ⟨fun s => nf (supported_iff.mp s), supported_iff.mpr hf⟩, f, rfl, rises, gives⟩⟩

/-- The closed relay runs the relay. -/
theorem runs : Runs web flow := ⟨fun _ _ => supported_iff, fun _ _ _ => passes_iff⟩

theorem balance_at : ∀ p x, amount (!p) x + total (presentAt p) (fun f => takeAt p f x) =
    amount p x + total (presentAt p) (fun f => giveAt p f x) := by
  intro p x; cases p <;> cases x <;> rfl

/-- The relay balances: units move, nothing is made. -/
theorem balances : flow.Balances web := fun t x => balance_at (parity t) x

/-- Only supported formations give. -/
theorem acting : flow.Acting web := fun t f _ mem _ => present_holds (parity t) f mem

theorem dependent : web.Dependent := fun _ _ active => supported_iff.mpr active

theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- What a formation takes is its own condition. -/
theorem takes_own {p : Bool} {f x : Form} (pos : 0 < takeAt p f x) : x = f :=
  match decEq x f with
  | .isTrue same => same
  | .isFalse other =>
    absurd (Eq.subst (motive := fun n => 0 < n) (if_neg other) pos) (Nat.lt_irrefl 0)

/-- Only supported formations take, and only from what they draw on. -/
theorem taking : flow.Taking web := fun t f _ mem pos =>
  ⟨present_holds (parity t) f mem, takes_own pos⟩

/-- What each formation requires is fixed, and within the six conditions. -/
theorem requiresWithin : ∀ f, web.RequiresWithin allForms f :=
  fun _ _ _ x same => ⟨same, rfl, every_form x⟩

theorem give_support : ∀ p f a, 0 < giveAt p f a → a ∈ giveSupport p f := by
  intro p f a; cases p <;> cases f <;> cases a <;> decide

theorem take_support : ∀ p f a, 0 < takeAt p f a → a ∈ [f] := by
  intro p f a; cases p <;> cases f <;> cases a <;> decide

theorem single_distinct (f : Form) : Distinct [f] := ⟨(fun no => nomatch no), trivial⟩

theorem pair_distinct {f g : Form} (other : f ≠ g) : Distinct [f, g] :=
  ⟨fun mem => match mem_cons_cases mem with
    | .inl same => other same
    | .inr no => (nomatch no),
   (fun no => nomatch no), trivial⟩

theorem give_distinct : ∀ p f, Distinct (giveSupport p f) := by
  intro p f; cases p <;> cases f <;>
    first
    | exact trivial
    | exact single_distinct _
    | exact pair_distinct (by decide)

/-- Each formation taking part moves exactly what it takes. -/
theorem moves_taken : ∀ p f, f ∈ presentAt p →
    total (giveSupport p f) (giveAt p f) = total [f] (takeAt p f) := by
  intro p f; cases p <;> cases f <;> decide

/-- A formation taking part touches only conditions of a family closed across the step. -/
theorem inside {C : Type} [DecidableEq C] {L : Flow Form C} {cs : List C} {t : Nat}
    (closed : L.ClosedAt cs t) {f : Form} (mem : f ∈ L.present t) {q : C → Nat}
    (zero : ∀ a, L.take t f a = 0 ∧ L.give t f a = 0 → q a = 0) : ∀ a, 0 < q a → a ∈ cs :=
  fun a pos => match decideMem a cs with
    | .isTrue h => h
    | .isFalse out => absurd (Eq.subst (motive := fun x => 0 < x)
        (zero a (closed f mem a out)) pos) (Nat.lt_irrefl 0)

/-- **The relay conserves**: every formation taking part gives every family closed across the step
exactly what it takes. -/
theorem conserving : flow.Conserving := fun _ _ distinct closed f mem =>
  (total_eq_of_supports distinct (give_distinct _ f) (give_support _ f)
      (inside closed mem fun _ none => none.2)).trans
    ((moves_taken _ f mem).trans
      (total_eq_of_supports distinct (single_distinct f) (take_support _ f)
        (inside closed mem fun _ none => none.1)).symm)

theorem gainless : flow.Gainless := conserving.gainless

/-- **Keeping widening within kinds**, the closed relay. -/
theorem keeps_widening :
    web.KeepsWidening (web.withinKind sameKind (flow.PassesSupport web)) web.level 0 :=
  runs.keeps_widening

/-- **全生成 within kinds at every supported occurrence**, the closed relay. -/
theorem generation {x : Nat × Form} (start : web.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (web.withinKind sameKind (flow.PassesSupport web)))
      (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x :=
  runs.generation start

/-- **全生成 one grain up at every supported occurrence**, the closed relay. -/
theorem generation_one_up {x : Nat × Form} (start : web.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
      (web.admitting web.level).activityClass ((web.admitting web.level).kindClass sameKind) x :=
  runs.generation_one_up start

/-- **Renewal without end at the kind grain**, the closed relay. -/
theorem renews_without_end :
    «生生» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
      ((web.admitting web.level).kindClass sameKind) (0, a0) :=
  runs.renews_without_end

/-- **By name the closed relay keeps widening from no step**: no formation is supported at two
steps running (`Runs.not_keepsWidening_byName`). -/
theorem not_keepsWidening_byName (T : Nat) : ¬ web.KeepsWidening Web.itself web.level T :=
  runs.not_keepsWidening_byName T

/-- **The closed relay meets the finite-whole law's premises**: its six conditions are listed without
repetition, it balances, nothing comes from nothing and what its formations require is fixed, so
`Flow.whole_not_keepsWidening` gives the same exclusion by name. -/
theorem not_keepsWidening_byName_of_whole (T : Nat) : ¬ web.KeepsWidening Web.itself web.level T :=
  Flow.whole_not_keepsWidening every_form distinct_forms gainless (T₀ := 0)
    (fun t _ => balances.on allForms t) fun _ f _ _ => requiresWithin f

/-- **Along supported passings the closed relay keeps widening from no step**: it meets the World
premises (`Flow.not_keepsWidening_along_supportedPassing`). -/
theorem not_keepsWidening_supportedPassing (T : Nat) :
    ¬ web.KeepsWidening (web.supportedPassing (flow.PassesSupport web)) web.level T :=
  Flow.not_keepsWidening_along_supportedPassing balances acting dependent unloosened
    (fun _ _ _ step => step) T

/-- **Read with dormant carrying on by name, the closed relay keeps widening from no step.** -/
theorem not_keepsWidening_dormant (T : Nat) :
    ¬ web.KeepsWidening
      (Web.passingContinuation fun t g f => flow.PassesSupport web t g f ∧ sameKind g f)
      web.level T :=
  fun keeps => runs.not_keepsOpening_dormant T keeps.2

/-- **The closed relay returns**: its levels and its flow repeat with period two. -/
theorem returns (t : Nat) :
    (∀ x, web.level (t + 2) x = web.level t x) ∧ flow.present (t + 2) = flow.present t ∧
      (∀ g x, flow.take (t + 2) g x = flow.take t g x) ∧
      ∀ g x, flow.give (t + 2) g x = flow.give t g x :=
  ⟨fun x => congrArg (fun p => amount p x) (parity_two t),
   congrArg presentAt (parity_two t),
   fun g x => congrArg (fun p => takeAt p g x) (parity_two t),
   fun g x => congrArg (fun p => giveAt p g x) (parity_two t)⟩

/-! #### The fed relay: dissipative, the loss paid by fuel no formation requires -/

namespace Fed

/-- The fuel a step uses: a unit for each formation taking part. -/
def fuelNeed : Bool → Nat
  | false => 2
  | true => 4

theorem fuel_present : ∀ p, total (presentAt p) (fun _ => 1) = fuelNeed p
  | false => rfl
  | true => rfl

/-- The levels: each formation's own condition as in the closed relay; the fuel of step `t` holds
what step `t` uses until step `t`, and nothing after. -/
def level (s : Nat) : Form ⊕ Nat → Nat
  | .inl f => amount (parity s) f
  | .inr t => if s ≤ t then fuelNeed (parity t) else 0

/-- The fed relay's web: the formations and their requirements are the closed relay's; each draws
on its own condition and on the step's fuel. -/
def web : Web Form (Form ⊕ Nat) :=
  ⟨level, fun t f => Holds (parity t) f, fun _ f x => x = .inl f, fun _ _ _ => 1,
   fun s f x => x = .inl f ∨ x = .inr s⟩

/-- Each formation taking part takes as in the closed relay, and one unit of the step's fuel. -/
def take (s : Nat) (g : Form) : Form ⊕ Nat → Nat
  | .inl x => takeAt (parity s) g x
  | .inr t => if s = t then 1 else 0

/-- Each formation taking part gives as in the closed relay, and no fuel. -/
def give (s : Nat) (g : Form) : Form ⊕ Nat → Nat
  | .inl x => giveAt (parity s) g x
  | .inr _ => 0

def flow : Flow Form (Form ⊕ Nat) := ⟨fun t => presentAt (parity t), take, give⟩

theorem supported_iff {t : Nat} {f : Form} : web.Supported t f ↔ Holds (parity t) f :=
  ⟨fun s => s (.inl f) rfl, fun h _ same =>
    Eq.subst (motive := fun x => 1 ≤ level t x) same.symm h⟩

theorem passes_iff {t : Nat} {g f : Form} :
    flow.PassesSupport web t g f ↔ 0 < giveAt (parity t) g f :=
  ⟨fun ⟨_, _, _, _, same, _, gives⟩ =>
     Eq.subst (motive := fun x => 0 < give t g x) same gives,
   fun gives => match moves_facts (parity t) g f gives with
    | ⟨mem, hg, nf, hf, rises⟩ => ⟨mem, supported_iff.mpr hg,
        ⟨fun s => nf (supported_iff.mp s), supported_iff.mpr hf⟩, .inl f, rfl, rises, gives⟩⟩

/-- The fed relay runs the relay: supports and passings are the closed relay's. -/
theorem runs : Runs web flow := ⟨fun _ _ => supported_iff, fun _ _ _ => passes_iff⟩

theorem fuel_balance (s t : Nat) :
    level (s + 1) (.inr t) + total (presentAt (parity s)) (fun g => take s g (.inr t)) =
      level s (.inr t) + total (presentAt (parity s)) (fun g => give s g (.inr t)) :=
  have given : total (presentAt (parity s)) (fun g => give s g (.inr t)) = 0 :=
    total_eq_zero fun _ _ => rfl
  match Nat.decEq s t with
  | .isTrue same =>
    have taken : total (presentAt (parity s)) (fun g => take s g (.inr t)) = fuelNeed (parity s) :=
      (total_congr (fun _ => if_pos same) _).trans (fuel_present (parity s))
    have after : level (s + 1) (.inr t) = 0 :=
      if_neg (Eq.subst (motive := fun x => ¬ s + 1 ≤ x) same (Nat.not_succ_le_self s))
    have before : level s (.inr t) = fuelNeed (parity s) :=
      (if_pos (Nat.le_of_eq same)).trans (congrArg (fun x => fuelNeed (parity x)) same.symm)
    (congrArg (· + total (presentAt (parity s)) (fun g => take s g (.inr t))) after).trans
      ((Nat.zero_add _).trans (taken.trans
        (before.symm.trans (congrArg (level s (.inr t) + ·) given).symm)))
  | .isFalse other =>
    have taken : total (presentAt (parity s)) (fun g => take s g (.inr t)) = 0 :=
      total_eq_zero fun _ _ => if_neg other
    have alike : level (s + 1) (.inr t) = level s (.inr t) := match Nat.decLe (s + 1) t with
      | .isTrue later => (if_pos later).trans (if_pos (Nat.le_of_succ_le later)).symm
      | .isFalse notLater => (if_neg notLater).trans (if_neg fun le =>
          match Nat.eq_or_lt_of_le le with
          | .inl same => other same
          | .inr lt => notLater lt).symm
    (congrArg (level (s + 1) (.inr t) + ·) taken).trans
      (alike.trans (congrArg (level s (.inr t) + ·) given).symm)

/-- The fed relay balances, at the formations' conditions and at the fuel. -/
theorem balances : flow.Balances web := fun s x => match x with
  | .inl x => balance_at (parity s) x
  | .inr t => fuel_balance s t

theorem acting : flow.Acting web := fun t f _ mem _ => present_holds (parity t) f mem

theorem dependent : web.Dependent := fun _ _ active => supported_iff.mpr active

theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- Only supported formations take, and only from their own condition and the step's fuel. -/
theorem taking : flow.Taking web := fun s f x mem pos =>
  ⟨present_holds (parity s) f mem, match x with
    | .inl _ => .inl (congrArg Sum.inl (takes_own (p := parity s) pos))
    | .inr t => match Nat.decEq s t with
      | .isTrue same => .inr (congrArg Sum.inr same.symm)
      | .isFalse other => absurd (Eq.subst (motive := fun n => 0 < n) (if_neg other) pos)
          (Nat.lt_irrefl 0)⟩

theorem give_support (s : Nat) (f : Form) :
    ∀ a, 0 < give s f a → a ∈ (giveSupport (parity s) f).map Sum.inl
  | .inl a, pos => mem_map_of (KindRelay.give_support _ f a pos)
  | .inr _, pos => absurd pos (Nat.lt_irrefl 0)

theorem take_support (s : Nat) (f : Form) : ∀ a, 0 < take s f a → a ∈ [.inl f, .inr s]
  | .inl a, pos => match mem_cons_cases (KindRelay.take_support _ f a pos) with
    | .inl same => Eq.subst (motive := fun x => Sum.inl x ∈ [Sum.inl f, Sum.inr s]) same.symm
        (.head _)
    | .inr no => nomatch no
  | .inr t, pos => match Nat.decEq s t with
    | .isTrue same => Eq.subst (motive := fun x => Sum.inr x ∈ [Sum.inl f, Sum.inr s]) same
        (.tail _ (.head _))
    | .isFalse other => absurd (Eq.subst (motive := fun x => 0 < x) (if_neg other) pos)
        (Nat.lt_irrefl 0)

theorem map_distinct {l : List Form} (distinct : Distinct l) :
    Distinct (l.map (Sum.inl (β := Nat))) :=
  distinct_map_on (fun _ _ _ _ same => Sum.inl.inj same) distinct

theorem take_distinct (s : Nat) (f : Form) : Distinct [Sum.inl (β := Nat) f, .inr s] :=
  ⟨fun mem => (match mem with
    | .tail _ no => nomatch no), (fun no => nomatch no), trivial⟩

/-- **The fed relay dissipates**: every formation taking part gives every family closed across the
step a unit less than it takes, the unit of fuel. -/
theorem dissipative : flow.Dissipative := fun cs s distinct closed f mem =>
  have given : total cs (flow.give s f) = total [f] (takeAt (parity s) f) :=
    (total_eq_of_supports distinct (map_distinct (give_distinct _ f)) (give_support s f)
        (inside closed mem fun _ none => none.2)).trans
      ((total_map Sum.inl (give s f) _).trans (moves_taken _ f mem))
  have taken : total cs (flow.take s f) = total [f] (takeAt (parity s) f) + 1 :=
    (total_eq_of_supports distinct (take_distinct s f) (take_support s f)
        (inside closed mem fun _ none => none.1)).trans
      (congrArg (fun x => takeAt (parity s) f f + (x + 0)) (if_pos rfl))
  Eq.subst (motive := fun x => x + sign (total cs (flow.take s f)) ≤ total cs (flow.take s f))
    given.symm
    (Eq.subst (motive := fun y => total [f] (takeAt (parity s) f) + sign y ≤ y) taken.symm
      (Nat.le_refl _))

theorem gainless : flow.Gainless := dissipative.gainless

theorem part_conserves : ∀ p f, f ∈ presentAt p →
    total allForms (giveAt p f) = total allForms (takeAt p f) := by
  intro p f; cases p <;> cases f <;> decide

/-- **The fed relay's part conserves**: on the six conditions the formations require, every
formation taking part gives exactly what it takes. Its dissipation lies in the fuel, which no
formation requires. -/
theorem conserving_on_part (s : Nat) : flow.ConservingOn (allForms.map Sum.inl) s := fun f mem =>
  (total_map Sum.inl (give s f) allForms).trans
    ((part_conserves _ f mem).trans (total_map Sum.inl (take s f) allForms).symm)

/-- A bound above every step whose fuel a list holds. -/
def fuelBound : List (Form ⊕ Nat) → Nat
  | [] => 0
  | .inl _ :: l => fuelBound l
  | .inr t :: l => t + 1 + fuelBound l

theorem lt_fuelBound : ∀ {l : List (Form ⊕ Nat)} {t : Nat}, Sum.inr t ∈ l → t < fuelBound l
  | .inl _ :: l, _, .tail _ mem => lt_fuelBound (l := l) mem
  | .inr _ :: _, _, .head _ => Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_add_right _ _)
  | .inr _ :: _, _, .tail _ mem => Nat.lt_of_lt_of_le (lt_fuelBound mem) (Nat.le_add_left _ _)

/-- **No list holds the fed relay's conditions**: the fuel of every step is a condition, so the
laws for a world whose conditions are listed do not apply to it. -/
theorem not_listed : ¬ ∃ all : List (Form ⊕ Nat), ∀ x, x ∈ all :=
  fun ⟨all, every⟩ => Nat.lt_irrefl _ (lt_fuelBound (every (.inr (fuelBound all))))

/-- **Keeping widening within kinds**, the fed relay. -/
theorem keeps_widening :
    web.KeepsWidening (web.withinKind sameKind (flow.PassesSupport web)) web.level 0 :=
  runs.keeps_widening

/-- **No list holding what the fed relay's formations require is dissipated on from any step**:
otherwise nothing would keep widening within kinds (`Flow.not_keepsWidening_of_dissipated_requirements`),
which the fed relay does. Its requirements conserve, and a list holds the fuel of only finitely many
steps. -/
theorem requirements_not_dissipated :
    ¬ ∃ (all : List (Form ⊕ Nat)) (T₀ : Nat), (∀ t f x, web.requires t f x → x ∈ all) ∧
      ∀ t, T₀ ≤ t → flow.DissipatesOn all t :=
  fun ⟨_, T₀, required, dissipates⟩ =>
    Flow.not_keepsWidening_of_dissipated_requirements balances acting dependent unloosened
      required dissipates (R := web.withinKind sameKind (flow.PassesSupport web))
      (fun _ _ s => .inl ⟨rfl, s⟩) T₀ (Web.KeepsWidening.later (Nat.zero_le T₀) keeps_widening)

/-- **全生成 within kinds at every supported occurrence**, the fed relay. -/
theorem generation {x : Nat × Form} (start : web.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (web.withinKind sameKind (flow.PassesSupport web)))
      (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x :=
  runs.generation start

/-- **全生成 one grain up at every supported occurrence**, the fed relay. -/
theorem generation_one_up {x : Nat × Form} (start : web.Supported x.1 x.2) :
    «全生成» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
      (web.admitting web.level).activityClass ((web.admitting web.level).kindClass sameKind) x :=
  runs.generation_one_up start

/-- **Renewal without end at the kind grain**, the fed relay. -/
theorem renews_without_end :
    «生生» (Web.continuationStep (Web.passingContinuation (flow.PassesSupport web)))
      ((web.admitting web.level).kindClass sameKind) (0, a0) :=
  runs.renews_without_end

/-- **By name the fed relay keeps widening from no step.** -/
theorem not_keepsWidening_byName (T : Nat) : ¬ web.KeepsWidening Web.itself web.level T :=
  runs.not_keepsWidening_byName T

/-- **Along supported passings the fed relay keeps widening from no step**: it meets the World
premises. -/
theorem not_keepsWidening_supportedPassing (T : Nat) :
    ¬ web.KeepsWidening (web.supportedPassing (flow.PassesSupport web)) web.level T :=
  Flow.not_keepsWidening_along_supportedPassing balances acting dependent unloosened
    (fun _ _ _ step => step) T

/-- **Read with dormant carrying on by name, the fed relay keeps widening from no step.** -/
theorem not_keepsWidening_dormant (T : Nat) :
    ¬ web.KeepsWidening
      (Web.passingContinuation fun t g f => flow.PassesSupport web t g f ∧ sameKind g f)
      web.level T :=
  fun keeps => runs.not_keepsOpening_dormant T keeps.2

/-- **The fed relay's part returns while its fuel is spent**: the formations' own levels and the
moves between them repeat with period two. -/
theorem returns (t : Nat) :
    (∀ f, web.level (t + 2) (.inl f) = web.level t (.inl f)) ∧
      flow.present (t + 2) = flow.present t ∧
      ∀ g f, flow.give (t + 2) g (.inl f) = flow.give t g (.inl f) :=
  ⟨fun f => congrArg (fun p => amount p f) (parity_two t),
   congrArg presentAt (parity_two t),
   fun g f => congrArg (fun p => giveAt p g f) (parity_two t)⟩

end Fed

end KindRelay

/-! ### Degeneration at the kind grain, witnessed -/

namespace Map.Undecided

/-- **The premise of the degeneration law holds at the kind grain**, for every kind relation, and
the pattern read at the kind degenerates. -/
theorem kind_degenerates (P : Prop) (Q : Bool → Bool → Prop) :
    (∀ y, «所及» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) y →
        y.1 = 2 → ¬ web.active y.1 y.2) ∧
      «退化» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) :=
  have gone : ∀ y, «所及» (Web.continuationStep (continuation P)) (web.kindClass Q) (0, false) y →
      y.1 = 2 → ¬ web.active y.1 y.2 := fun y _ at_ =>
    Eq.subst (motive := fun s => ¬ web.active s y.2) at_.symm (inactive_two y.2)
  ⟨gone, Web.kind_every_branch_ends_of_gone (.inl ⟨rfl, rfl⟩) (Nat.zero_le 2) gone⟩

end Map.Undecided

end Becoming
