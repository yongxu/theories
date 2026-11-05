import Becoming.LineageRegimes

/-!
# A lineage drawn below its need: the lineage reading without its gate

`Becoming.LineageRegimes` reads renewal gated on what it renews, run past what it gives, on a
lineage (`LineageRegimes.degeneration_of_family_excess`), and `Becoming.MapInstances` reads it on
the map (`Web.family_excess_gone`, `Web.family_excess_degenerates`). Their proofs use
`Flow.family_excess_ends` only at the step the excess reaches, where neither the coupled gate nor
the premise that only active formations give (`Acting`) is used. This module states those laws
without the two premises and shows each landed statement to be a case. Every law here composes
landed lemmas with premises dropped: a restatement, not a further result.

* **The ledger (restatements).** Under balance, a family's stock at `T + n` is below a need `m`
  exactly where its stock at `T`, with everything given to it across the `n` steps, is below `m`
  with everything taken from it (`below_iff`, read from `Flow.Balances.accumulates`, the landed
  `balance_over_stretch` at the stock); `n` steps of excess of the family's uptake over its
  replenishment from a stock below `n + m` leave it below `m` (`below_of_excess`,
  `Flow.family_excess_bounded` read at the need).
* **One decider through conditions.** Where activity needs support, the line from an active
  occurrence at a step not after `N` ends on every branch at the kind grain where everything it
  reaches at `N` requires, at a need of at least `m`, a member of a family whose stock at `N` is
  below `m` (`degeneration_of_unmet`, composing `Flow.family_ends_below_at` with
  `Web.kind_every_branch_ends_of_gone`); no flow premise enters. Read through the ledger
  (`degeneration_of_drawdown`), and through `n` steps of excess from a stock below `n + m`
  (`degeneration_of_excess`): the landed gated reading with its gate and `Acting` dropped. The landed
  statement is its case (`landed_of_excess`), its type that of
  `LineageRegimes.degeneration_of_family_excess` (`landed_of_excess_eq`, by `rfl`); where the census
  holds every continuation, every member of generation `N` so depending suffices
  (`degeneration_of_unmet_listed`).
* **The map's horizon law, likewise.** `Web.family_excess_gone` and `Web.family_excess_degenerates`
  hold without their gate and `Acting` (`gone_of_excess`, `horizon_of_excess`) and are their cases
  (`landed_gone`, `landed_horizon`; `landed_gone_eq`, `landed_horizon_eq`, by `rfl`).
* **On the census (near-definitional).** In generations of descent, where only active formations give
  and activity needs support, a generation every member of which requires, at a need of at least
  `m`, a member of a family whose stock at its step is below `m` has an empty next generation, every
  later generation is empty and the selection term proper is zero from that step on
  (`next_empty_of_unmet`, `ends_of_unmet`; through the ledger `ends_of_drawdown`,
  `no_term_of_drawdown`). These follow from activity needing support, only active formations giving
  and descent.
* **What the gate does.** It makes the formations' end last: under it `Flow.family_excess_ends` ends
  every formation requiring a member at such a need at every step from `T + n` on. Without it a
  formation inactive at `T + n` can be active again (`Restored.returns`, `Becoming.RelativePosition`).
  The laws here are verdicts on the line from before `T + n`, at the kind grain or the activity grain:
  a line at a class within activity cannot pass a step at which nothing it reaches is active.
* **A line drawn past renewal from outside (`Drain`, a witness with offspring numbers supplied).** On
  one law of a pool, its renewer and organisms, and one course of generations, the renewer either
  requires the pool at need one (the gate) or gives three units a step from no condition and requires
  none (from outside). The restrained member leaves no offspring and the drawer two, which then relay:
  selection at the first step only, and no growth. With the gate, eight steps of excess from a stock
  of eight meet the landed gated law with a nonempty generation at its horizon (`Drain.landed_met`).
  From outside the coupled gate fails at every need (`Drain.not_gated`), every other premise holds,
  and the line degenerates the same (`Drain.outside_ends`), while the renewer's own line goes on
  (`Drain.renewer_goes_on_outside`, a witness).

Modelling choices: discrete steps; natural-number levels, needs, gifts, takes and offspring numbers;
activity Prop-valued, decided in the witness by Booleans; a need a threshold on a level; giving not
drawn from the giver's own level unless it takes, so a renewer can give from no listed condition;
descent as giving to what comes to stand; in `Drain` each organism stands at one step only, takes its
own standing there, draws its draw from the pool while active and gives each of its offspring one
unit, the renewer gives three units a step while active, and the offspring numbers are supplied, not
derived from the draws. An empty axiom report says nothing of these.

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace LineageDrawdown

open LineageRegions

/-! ## The ledger -/

section Ledger

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **Below a need exactly where the draws outrun the stock** (a restatement of
`Flow.Balances.accumulates`): under balance, the family's stock at `T + n` is below `m` exactly
where its stock at `T`, with everything given to it across the `n` steps, is below `m` with
everything taken from it. -/
theorem below_iff (balances : L.Balances W) (ds : List C) (T n m : Nat) :
    W.stock ds (T + n) < m ↔
      W.stock ds T + total (steps T n) (L.replenishment ds) <
        m + total (steps T n) (L.uptake ds) :=
  have ledger := balances.accumulates ds T n
  ⟨fun below => Nat.lt_of_le_of_lt (Nat.le_of_eq ledger.symm) (Nat.add_lt_add_right below _),
   fun draws => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq ledger) draws)⟩

/-- `n` steps of excess of the family's uptake over its replenishment from a stock below `n + m`
leave the stock below `m` (`Flow.family_excess_bounded`, read at the need). -/
theorem below_of_excess (balances : L.Balances W) {ds : List C} {m T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) : W.stock ds (T + n) < m :=
  Nat.lt_of_add_lt_add_left (n := n)
    (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm n _))
        (Flow.family_excess_bounded balances n excess))
      start)

end Ledger

/-! ## One decider through conditions -/

section Decider

variable {X : Type} {L : Flow X X} {W : Web X X} {Q : X → X → Prop}

/-- **A line ends on every branch where its reach's need goes unmet at one step**: where activity
needs support, the line from an active occurrence at a step not after `N` ends on every branch at
the kind grain where everything it reaches at `N` requires, at a need of at least `m`, a member of a
family whose stock at `N` is below `m`. No flow premise enters. -/
theorem degeneration_of_unmet (dependent : W.Dependent) {ds : List X} {m N : Nat}
    (below : W.stock ds N < m) {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ N)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = N →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  Web.kind_every_branch_ends_of_gone (W := W) (R := continuation L W Q) active le
    fun y hy at_ => match depends y hy at_ with
    | ⟨_, inside, req, high⟩ =>
      Flow.family_ends_below_at (dependent y.1 y.2)
        (Eq.subst (motive := fun s => W.stock ds s < m) at_.symm below) inside req high

/-- **The same, read on the census**: where the census holds every continuation at the kind grain
and every member of generation `N` requires, at a need of at least `m`, a member of a family whose
stock at `N` is below `m`, the line from every active member of a generation not after `N`
degenerates. -/
theorem degeneration_of_unmet_listed (dependent : W.Dependent) {ds : List X} {m N : Nat}
    (below : W.stock ds N < m) {G : SelectionTerm.Generations X}
    (listed : ContinuationsListed (lineStep L W Q) (W.kindClass Q) G)
    (members : ∀ q, q ∈ G.family N → ∃ e, e ∈ ds ∧ W.requires N q e ∧ m ≤ W.need N q e)
    {t : Nat} {p : X} (mp : p ∈ G.family t) (active : W.active t p) (le : t ≤ N) :
    «退化» (lineStep L W Q) (W.kindClass Q) (t, p) :=
  degeneration_of_unmet dependent below (x := (t, p)) active le fun y hy at_ =>
    Eq.subst (motive := fun s => ∃ e, e ∈ ds ∧ W.requires s y.2 e ∧ m ≤ W.need s y.2 e)
      at_.symm (members y.2 (Eq.subst (motive := fun s => y.2 ∈ G.family s) at_
        (reached_listed listed mp hy)))

/-- **Drawn below the need, in the draws**: under balance and where activity needs support, the line
from an active occurrence at a step not after `T + n` degenerates where the family's stock at `T`,
with everything given to it across the `n` steps from `T`, is below `m` with everything taken from
it, and everything the line reaches at `T + n` requires a member at a need of at least `m`. -/
theorem degeneration_of_drawdown (balances : L.Balances W) (dependent : W.Dependent)
    {ds : List X} {m T n : Nat}
    (draws : W.stock ds T + total (steps T n) (L.replenishment ds) <
      m + total (steps T n) (L.uptake ds))
    {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  degeneration_of_unmet dependent ((below_iff balances ds T n m).mpr draws) active le depends

/-- **Excess past the stock less the need, with no gate**: `LineageRegimes.degeneration_of_family_excess`
with its gate and `Acting` dropped, whatever renews the family. -/
theorem degeneration_of_excess (balances : L.Balances W) (dependent : W.Dependent)
    {ds : List X} {m T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  degeneration_of_unmet dependent (below_of_excess balances excess start) active le depends

/-- The landed gated reading as the case of `degeneration_of_excess`: its gate and `Acting` are not
used. -/
theorem landed_of_excess (balances : L.Balances W) (_acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (_gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  degeneration_of_excess balances dependent excess start active le depends

/-- `landed_of_excess` states exactly `LineageRegimes.degeneration_of_family_excess`: an equality
of the two that type-checks only where their statements are the same. -/
theorem landed_of_excess_eq :
    @landed_of_excess = @LineageRegimes.degeneration_of_family_excess := rfl

end Decider

/-! ## The map's horizon law, without its gate -/

section Horizon

variable {F C : Type}

/-- **Drawn beyond renewal, gated or not, an occurrence at the horizon is inactive**: under balance
and where activity needs support, `n` steps of excess of a family's uptake over its replenishment
from a stock below `n + m` leave inactive at `T + n` an occurrence depending there on a member at a
need of at least `m`. No gate and no `Acting`. -/
theorem gone_of_excess {W : Web F C} {L : Flow F C} (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List C} {m T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {y : Nat × F} (at_ : y.1 = T + n)
    (held : ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ W.active y.1 y.2 :=
  match held with
  | ⟨_, inside, depends, high⟩ =>
    Eq.subst (motive := fun s => ¬ W.active s y.2) at_.symm
      (Flow.family_ends_below_at (dependent (T + n) y.2) (below_of_excess balances excess stock)
        inside depends high)

/-- **The same on the map**: the line from an active occurrence at a step not after `T + n`
degenerates at the activity grain where everything it reaches at `T + n` so depends. -/
theorem horizon_of_excess {W : Web F C} {R : Nat → F → F → Prop} {L : Flow F C}
    (balances : L.Balances W) (dependent : W.Dependent) {ds : List C} {m T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (Web.continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    «退化» (Web.continuationStep R) W.activityClass x :=
  Web.activity_every_branch_ends_of_gone start le fun y hy at_ =>
    gone_of_excess balances dependent excess stock at_ (held y hy at_)

/-- `Web.family_excess_gone` as the case of `gone_of_excess`: its gate and `Acting` are not used. -/
theorem landed_gone {W : Web F C} {L : Flow F C} (balances : L.Balances W)
    (_acting : L.Acting W) (dependent : W.Dependent) {ds : List C} {m : Nat}
    (_gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {y : Nat × F} (at_ : y.1 = T + n)
    (held : ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ W.active y.1 y.2 :=
  gone_of_excess balances dependent excess stock at_ held

/-- `Web.family_excess_degenerates` as the case of `horizon_of_excess`: its gate and `Acting` are
not used. -/
theorem landed_horizon {W : Web F C} {R : Nat → F → F → Prop} {L : Flow F C}
    (balances : L.Balances W) (_acting : L.Acting W) (dependent : W.Dependent) {ds : List C}
    {m : Nat}
    (_gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (Web.continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    «退化» (Web.continuationStep R) W.activityClass x :=
  horizon_of_excess balances dependent excess stock start le held

/-- `landed_gone` states exactly `Web.family_excess_gone`. -/
theorem landed_gone_eq : @landed_gone = @Web.family_excess_gone := rfl

/-- `landed_horizon` states exactly `Web.family_excess_degenerates`. -/
theorem landed_horizon_eq : @landed_horizon = @Web.family_excess_degenerates := rfl

end Horizon

/-! ## What the drawdown forbids, on the census (near-definitional) -/

section Forbids

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- **A generation below its need leaves no offspring**: in generations of descent, where only
active formations give and activity needs support, a generation every member of which requires, at a
need of at least `m`, a member of a family whose stock at its step is below `m` has an empty next
generation. -/
theorem next_empty_of_unmet (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m N : Nat} (below : W.stock ds N < m)
    (members : ∀ q, q ∈ G.family N → ∃ e, e ∈ ds ∧ W.requires N q e ∧ m ≤ W.need N q e) :
    G.size (N + 1) = 0 :=
  length_zero_of_no_mem fun k mk =>
    match Reproduction.mem_flatMap_cases (f := G.kids N) (ps := G.family N) mk with
    | ⟨p, mp, kp⟩ => match members p mp with
      | ⟨_, inside, req, high⟩ =>
        Flow.family_ends_below_at (dependent N p) below inside req high
          ((descended N p k mp kp).active acting)

/-- **From there on, nothing**: under the same premises every generation after `N` is empty and the
selection term proper is zero at every step from `N` on. -/
theorem ends_of_unmet (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m N : Nat} (below : W.stock ds N < m)
    (members : ∀ q, q ∈ G.family N → ∃ e, e ∈ ds ∧ W.requires N q e ∧ m ≤ W.need N q e) :
    ∀ s, G.size (N + 1 + s) = 0 ∧ G.concordAt (N + s) = 0 ∧ G.discordAt (N + s) = 0 :=
  have empty := next_empty_of_unmet acting dependent descended below members
  fun s =>
    have later : G.size (N + 1 + s) = 0 := Reproduction.Generations.empty_from empty s
    ⟨later, SelectionShift.Generations.last_term_zero
      (Eq.subst (motive := fun k => G.size k = 0) (Nat.add_right_comm N 1 s) later)⟩

/-- **Drawn past its stock, a lineage ends and its selection term with it**: under balance, in
generations of descent where only active formations give and activity needs support, where the
family's stock at `T`, with everything given to it across the `n` steps from `T`, is below `m` with
everything taken from it, and every member of generation `T + n` requires a member at a need of at
least `m`, every generation after `T + n` is empty and the selection term proper is zero from
`T + n` on. -/
theorem ends_of_drawdown (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {ds : List X} {m T n : Nat}
    (draws : W.stock ds T + total (steps T n) (L.replenishment ds) <
      m + total (steps T n) (L.uptake ds))
    (members : ∀ q, q ∈ G.family (T + n) →
      ∃ e, e ∈ ds ∧ W.requires (T + n) q e ∧ m ≤ W.need (T + n) q e) :
    ∀ s, G.size (T + n + 1 + s) = 0 ∧ G.concordAt (T + n + s) = 0 ∧
      G.discordAt (T + n + s) = 0 :=
  ends_of_unmet acting dependent descended ((below_iff balances ds T n m).mpr draws) members

/-- **Forbidden: a selection term at the step where the draws have passed the stock.** Under the
same premises the selection term proper at `T + n` is not positive. -/
theorem no_term_of_drawdown (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {ds : List X} {m T n : Nat}
    (draws : W.stock ds T + total (steps T n) (L.replenishment ds) <
      m + total (steps T n) (L.uptake ds))
    (members : ∀ q, q ∈ G.family (T + n) →
      ∃ e, e ∈ ds ∧ W.requires (T + n) q e ∧ m ≤ W.need (T + n) q e)
    (pos : 0 < G.concordAt (T + n) ∨ 0 < G.discordAt (T + n)) : False :=
  match ends_of_drawdown balances acting dependent descended draws members 0 with
  | ⟨_, zc, zd⟩ => match pos with
    | .inl p => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le p (Nat.le_of_eq zc))
    | .inr p => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le p (Nat.le_of_eq zd))

end Forbids

/-! ## A line drawn past renewal from outside

Relata are numbered: `0` the pool, `1` its renewer, `2` and `3` restrained (each draws one unit from
the pool), `4` and on drawers (each draws two units); the course uses `2` and the drawers `4` to `8`.
The renewer gives the pool three units at every step it is active. `gate` says whether the renewer
requires the pool (at need one). Every organism requires the pool at need one, stands at its own step
only, takes its own standing at that step, and while active takes its draw from the pool and gives
one unit to each of its offspring.

The course starts from the first generation `2` and `4` and the pool's eight. The restrained `2`
leaves no offspring and the drawer `4` leaves two drawers, which then relay (`5` and `7`, `6` and
`8`): selection at the first step only, and the generation's size two throughout. The offspring
numbers are supplied by the course. -/

namespace Drain

/-- What a step reads: the pool's level and which organisms stand. -/
structure Phase where
  pool : Nat
  stands : Nat → Bool

/-- Each drawer draws two units, each restrained member one. -/
def draw : Nat → Nat
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | 3 => 1
  | _ + 4 => 2

def levelOf (φ : Phase) : Nat → Nat
  | 0 => φ.pool
  | 1 => 0
  | c + 2 => bif φ.stands (c + 2) then 1 else 0

def activeOf (gate : Bool) (φ : Phase) : Nat → Bool
  | 0 => false
  | 1 => !gate || decide (1 ≤ φ.pool)
  | c + 2 => φ.stands (c + 2) && decide (1 ≤ φ.pool)

def takeOf (gate : Bool) (φ : Phase) : Nat → Nat → Nat
  | 0, _ => 0
  | 1, _ => 0
  | f + 2, 0 => bif activeOf gate φ (f + 2) then draw (f + 2) else 0
  | f + 2, c + 1 => bif f + 2 == c + 1 then levelOf φ (f + 2) else 0

def giveOf (gate : Bool) (φ : Phase) (kids : Nat → List Nat) : Nat → Nat → Nat
  | 0, _ => 0
  | 1, 0 => bif activeOf gate φ 1 then 3 else 0
  | 1, _ + 1 => 0
  | _ + 2, 0 => 0
  | _ + 2, 1 => 0
  | f + 2, c + 2 =>
    bif activeOf gate φ (f + 2) && (kids (f + 2)).contains (c + 2) then 1 else 0

/-- A course: what each step reads, the offspring at each step, and the members of each
generation. -/
structure Course where
  phase : Nat → Phase
  kids : Nat → Nat → List Nat
  members : Nat → List Nat

def flow (gate : Bool) (κ : Course) : Flow Nat Nat where
  present t := 1 :: κ.members t
  take t := takeOf gate (κ.phase t)
  give t := giveOf gate (κ.phase t) (κ.kids t)

/-- Every organism requires the pool; the renewer requires it exactly where there is a gate. -/
def requires (gate : Bool) : Nat → Nat → Prop
  | 0, _ => False
  | 1, c => gate = true ∧ c = 0
  | _ + 2, c => c = 0

def web (gate : Bool) (κ : Course) : Web Nat Nat where
  level t := levelOf (κ.phase t)
  active t f := activeOf gate (κ.phase t) f = true
  requires _ := requires gate
  need _ _ _ := 1
  draws _ f c := requires gate f c ∨ (2 ≤ f ∧ c = f)

def generations (κ : Course) : SelectionTerm.Generations Nat where
  first := κ.members 0
  kids := κ.kids
  amount _ := draw

/-! ### The course -/

/-- Selection at the first step only: the pool at eight, eight, then one unit less a step, nothing
at step nine; with the gate it stays at nothing, without it the renewer restores it. -/
def phaseP (gate : Bool) : Nat → Phase
  | 0 => ⟨8, fun c => c == 2 || c == 4⟩
  | 1 => ⟨8, fun c => c == 5 || c == 6⟩
  | 2 => ⟨7, fun c => c == 7 || c == 8⟩
  | 3 => ⟨6, fun c => c == 5 || c == 6⟩
  | 4 => ⟨5, fun c => c == 7 || c == 8⟩
  | 5 => ⟨4, fun c => c == 5 || c == 6⟩
  | 6 => ⟨3, fun c => c == 7 || c == 8⟩
  | 7 => ⟨2, fun c => c == 5 || c == 6⟩
  | 8 => ⟨1, fun c => c == 7 || c == 8⟩
  | 9 => ⟨0, fun c => c == 5 || c == 6⟩
  | t + 10 => ⟨bif gate then 0 else 3 * (t + 1), fun _ => false⟩

def kidsP (t : Nat) : Nat → List Nat
  | 4 => bif t == 0 then [5, 6] else []
  | 5 => bif t == 9 then [] else [7]
  | 6 => bif t == 9 then [] else [8]
  | 7 => [5]
  | 8 => [6]
  | _ => []

def familyP : Nat → List Nat
  | 0 => [2, 4]
  | 1 => [5, 6]
  | 2 => [7, 8]
  | 3 => [5, 6]
  | 4 => [7, 8]
  | 5 => [5, 6]
  | 6 => [7, 8]
  | 7 => [5, 6]
  | 8 => [7, 8]
  | 9 => [5, 6]
  | _ + 10 => []

def courseP (gate : Bool) : Course where
  phase := phaseP gate
  kids := kidsP
  members := familyP

/-! ### Small facts on Booleans -/

theorem pos_of_bif {b : Bool} {x : Nat} : 0 < (bif b then x else 0) → b = true :=
  match b with
  | true => fun _ => rfl
  | false => fun h => absurd h (Nat.lt_irrefl 0)

theorem left_of_and {a b : Bool} : (a && b) = true → a = true :=
  match a with
  | true => fun _ => rfl
  | false => fun h => nomatch h

theorem right_of_and {a b : Bool} : (a && b) = true → b = true :=
  match a, b with
  | _, true => fun _ => rfl
  | true, false => fun h => nomatch h
  | false, false => fun h => nomatch h

theorem right_of_gate {g b : Bool} : (!g || b) = true → g = true → b = true :=
  match g with
  | true => fun h _ => h
  | false => fun _ no => nomatch no

/-! ### Premises met by every course -/

theorem active_of_give {gate : Bool} {φ : Phase} {kids : Nat → List Nat} :
    ∀ f c, 0 < giveOf gate φ kids f c → activeOf gate φ f = true
  | 0, _, h => absurd h (Nat.lt_irrefl 0)
  | 1, 0, h => pos_of_bif h
  | 1, _ + 1, h => absurd h (Nat.lt_irrefl 0)
  | _ + 2, 0, h => absurd h (Nat.lt_irrefl 0)
  | _ + 2, 1, h => absurd h (Nat.lt_irrefl 0)
  | _ + 2, _ + 2, h => left_of_and (pos_of_bif h)

/-- **Only active formations give.** -/
theorem acting (gate : Bool) (κ : Course) : (flow gate κ).Acting (web gate κ) :=
  fun _ f c _ gives => active_of_give f c gives

/-- **Activity needs support**: an active organism finds the pool at one or more, and so does an
active renewer where it requires the pool. -/
theorem dependent (gate : Bool) (κ : Course) : (web gate κ).Dependent := by
  intro t f active c req
  match f, c, req with
  | 1, 0, ⟨gated, _⟩ =>
    exact of_decide_eq_true (right_of_gate (g := gate) active gated)
  | _ + 2, 0, rfl =>
    exact of_decide_eq_true (right_of_and active)

/-- **The renewer is gated where there is a gate**: whatever gives to the pool requires it at
need one. -/
theorem gated (κ : Course) : ∀ t f, f ∈ (flow true κ).present t → ∀ d, d ∈ [0] →
    0 < (flow true κ).give t f d → ∃ e, e ∈ [0] ∧ (web true κ).requires t f e ∧
      1 ≤ (web true κ).need t f e := by
  intro t f _ d md gives
  match d, md with
  | _, .head _ =>
    match f, gives with
    | 0, h => exact absurd h (Nat.lt_irrefl 0)
    | 1, _ => exact ⟨0, .head _, ⟨rfl, rfl⟩, Nat.le_refl 1⟩
    | _ + 2, h => exact absurd h (Nat.lt_irrefl 0)
  | _, .tail _ no => exact nomatch no

/-- **Without the gate the renewer gives from outside**: at every step it gives the pool three
units and requires no condition. -/
theorem from_outside (κ : Course) (t : Nat) :
    0 < (flow false κ).give t 1 0 ∧ ∀ c, ¬ (web false κ).requires t 1 c :=
  ⟨Nat.zero_lt_succ 2, fun _ req => nomatch req.1⟩

/-- **Without the gate the coupled gate fails, at every need**: the renewer, taking part at every
step, gives the pool and requires no condition. -/
theorem not_gated (κ : Course) (m : Nat) : ¬ ∀ t f, f ∈ (flow false κ).present t → ∀ d, d ∈ [0] →
    0 < (flow false κ).give t f d → ∃ e, e ∈ [0] ∧ (web false κ).requires t f e ∧
      m ≤ (web false κ).need t f e :=
  fun coupled => match coupled 0 1 (List.Mem.head _) 0 (List.Mem.head _) (from_outside κ 0).1 with
    | ⟨e, _, req, _⟩ => (from_outside κ 0).2 e req

theorem org_of_give {gate : Bool} {φ : Phase} {kids : Nat → List Nat} :
    ∀ f c, 2 ≤ f → 0 < giveOf gate φ kids f c → 2 ≤ c
  | _ + 2, 0, _, h => absurd h (Nat.lt_irrefl 0)
  | _ + 2, 1, _, h => absurd h (Nat.lt_irrefl 0)
  | _ + 2, _ + 2, _, _ => Nat.le_add_left 2 _
  | 0, _, le, _ => absurd le (by decide)
  | 1, _, le, _ => absurd le (by decide)

/-- From an organism the line passes only to organisms: to itself, or to an offspring it gives. -/
theorem step_org {gate : Bool} {κ : Course} {y z : Nat × Nat}
    (c : «续» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat)) y z) (org : 2 ≤ y.2) : 2 ≤ z.2 :=
  match c.1.2 with
  | .inl ⟨same, _⟩ => Eq.subst (motive := fun n => 2 ≤ n) same org
  | .inr ⟨⟨_, gives, _⟩, _⟩ => org_of_give y.2 z.2 org gives

theorem line_org {gate : Bool} {κ : Course} :
    ∀ {y z : Nat × Nat}, «及» («续» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat))) y z → 2 ≤ y.2 → 2 ≤ z.2
  | _, _, .one c, org => step_org c org
  | _, _, .more c rest, org => line_org rest (step_org c org)

theorem reach_org {gate : Bool} {κ : Course} {x y : Nat × Nat}
    (reached : «所及» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat)) x y) (org : 2 ≤ x.2) : 2 ≤ y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × Nat => 2 ≤ z.2) same org
  | .inr line => line_org line org

/-- Everything the line from an organism reaches requires the pool at need one. -/
theorem depends_pool {gate : Bool} {κ : Course} {x : Nat × Nat} (org : 2 ≤ x.2) (N : Nat) :
    ∀ y, «所及» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat)) x y → y.1 = N →
      ∃ e, e ∈ [0] ∧ (web gate κ).requires y.1 y.2 e ∧ 1 ≤ (web gate κ).need y.1 y.2 e :=
  fun y hy _ => match y, reach_org hy org with
    | (_, 0), le => absurd le (Nat.not_succ_le_zero 1)
    | (_, 1), le => absurd le (Nat.not_succ_le_self 1)
    | (_, _ + 2), _ => ⟨0, .head _, rfl, Nat.le_refl 1⟩

/-- **Without the gate the renewer's line goes on** (`«延»`), a witness: it carries on as itself at
every step, requiring nothing. -/
theorem renewer_goes_on_outside (κ : Course) :
    «延» (lineStep (flow false κ) (web false κ) (oneKind Nat))
      ((web false κ).kindClass (oneKind Nat)) (0, 1) :=
  ⟨fun z => z.2 = 1, rfl, fun z at1 => ⟨(z.1 + 1, 1), rfl,
    ⟨⟨rfl, .inl ⟨at1, Eq.subst (motive := fun g => (web false κ).Supported z.1 g) at1.symm
        (fun _ req => nomatch req.1)⟩⟩,
     ⟨⟨fun _ => rfl, fun _ => Eq.subst (motive := fun g => (web false κ).active z.1 g)
        at1.symm rfl⟩, trivial⟩⟩⟩⟩

/-! ### The census -/

theorem familyP_step : ∀ t, (familyP t).flatMap (kidsP t) = familyP (t + 1)
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | 4 => rfl
  | 5 => rfl
  | 6 => rfl
  | 7 => rfl
  | 8 => rfl
  | 9 => rfl
  | _ + 10 => rfl

theorem familyP_eq (gate : Bool) : ∀ t, (generations (courseP gate)).family t = familyP t
  | 0 => rfl
  | t + 1 =>
    have before := familyP_eq gate t
    show ((generations (courseP gate)).family t).flatMap
        ((generations (courseP gate)).kids t) = familyP (t + 1)
    by rw [before]; exact familyP_step t

/-! ### Balance and descent -/

theorem stepP (gate : Bool) : ∀ t c,
    levelOf (phaseP gate (t + 1)) c +
        total (1 :: familyP t) (fun f => takeOf gate (phaseP gate t) f c) =
      levelOf (phaseP gate t) c +
        total (1 :: familyP t) (fun f => giveOf gate (phaseP gate t) (kidsP t) f c)
  | 0, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 1, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 2, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 3, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 4, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 5, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 6, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 7, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 8, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | 9, c => by cases gate <;> exact match c with | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 => rfl | _ + 9 => rfl
  | _ + 10, c => by cases gate <;> exact match c with | 0 | 1 => rfl | _ + 2 => rfl

/-- **The course balances**, with the gate or without it. -/
theorem balances_P (gate : Bool) : (flow gate (courseP gate)).Balances (web gate (courseP gate)) :=
  fun t c => stepP gate t c

theorem descendsP (gate : Bool) : ∀ t, t < 10 → ∀ p, p ∈ familyP t → ∀ k, k ∈ kidsP t p →
    0 < giveOf gate (phaseP gate t) (kidsP t) p k ∧
      ¬ 0 < levelOf (phaseP gate t) k ∧ 0 < levelOf (phaseP gate (t + 1)) k
  | 0, _ => by cases gate <;> decide
  | 1, _ => by cases gate <;> decide
  | 2, _ => by cases gate <;> decide
  | 3, _ => by cases gate <;> decide
  | 4, _ => by cases gate <;> decide
  | 5, _ => by cases gate <;> decide
  | 6, _ => by cases gate <;> decide
  | 7, _ => by cases gate <;> decide
  | 8, _ => by cases gate <;> decide
  | 9, _ => by cases gate <;> decide
  | t + 10, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 10 t))

theorem descends_atP (gate : Bool) : ∀ t p, p ∈ familyP t → ∀ k, k ∈ kidsP t p →
    (flow gate (courseP gate)).DescendsAt (web gate (courseP gate)) t k p
  | 0, p, m, k, mk => ⟨.tail _ m, descendsP gate 0 (by decide) p m k mk⟩
  | 1, p, m, k, mk => ⟨.tail _ m, descendsP gate 1 (by decide) p m k mk⟩
  | 2, p, m, k, mk => ⟨.tail _ m, descendsP gate 2 (by decide) p m k mk⟩
  | 3, p, m, k, mk => ⟨.tail _ m, descendsP gate 3 (by decide) p m k mk⟩
  | 4, p, m, k, mk => ⟨.tail _ m, descendsP gate 4 (by decide) p m k mk⟩
  | 5, p, m, k, mk => ⟨.tail _ m, descendsP gate 5 (by decide) p m k mk⟩
  | 6, p, m, k, mk => ⟨.tail _ m, descendsP gate 6 (by decide) p m k mk⟩
  | 7, p, m, k, mk => ⟨.tail _ m, descendsP gate 7 (by decide) p m k mk⟩
  | 8, p, m, k, mk => ⟨.tail _ m, descendsP gate 8 (by decide) p m k mk⟩
  | 9, p, m, k, mk => ⟨.tail _ m, descendsP gate 9 (by decide) p m k mk⟩
  | _ + 10, _, m, _, _ => nomatch m

/-- **The generations are generations of descent**, with the gate or without it. -/
theorem descended_P (gate : Bool) : SelectionTerm.Flow.Descended (flow gate (courseP gate))
    (web gate (courseP gate)) (generations (courseP gate)) :=
  fun t p k mp mk =>
    descends_atP gate t p (Eq.subst (motive := fun l => p ∈ l) (familyP_eq gate t) mp) k mk

/-! ### Selection at one step, no growth: the landed law met, and renewal from outside -/

/-- **Selection at the first step**: concordance two at step zero, with no discordance; the
generation's size is two at steps zero and one. -/
theorem selection_P (gate : Bool) :
    (generations (courseP gate)).concordAt 0 = 2 ∧ (generations (courseP gate)).discordAt 0 = 0 ∧
    (generations (courseP gate)).size 0 = 2 ∧ (generations (courseP gate)).size 1 = 2 := by
  cases gate <;> decide

theorem length_two_P : ∀ t, t < 10 → (familyP t).length = 2
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl
  | 8, _ => rfl
  | 9, _ => rfl
  | t + 10, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 10 t))

/-- **No growth**: the generation's size is two at every step through nine. -/
theorem sizes_P (gate : Bool) : ∀ t, t < 10 → (generations (courseP gate)).size t = 2 :=
  fun t lt => (congrArg List.length (familyP_eq gate t)).trans (length_two_P t lt)

theorem kids_one_P : ∀ t, t < 8 → ∀ p, p ∈ familyP (t + 1) → (kidsP (t + 1) p).length = 1
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | 5, _ => by decide
  | 6, _ => by decide
  | 7, _ => by decide
  | t + 8, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 8 t))

theorem uniform_P (gate : Bool) (t : Nat) (lt : t < 8) :
    (generations (courseP gate)).concordAt (t + 1) = 0 ∧
      (generations (courseP gate)).discordAt (t + 1) = 0 :=
  have same : ∀ p, p ∈ (generations (courseP gate)).family (t + 1) →
      (generations (courseP gate)).offspringNumber (t + 1) p = 1 := fun p mp =>
    kids_one_P t lt p (Eq.subst (motive := fun l => p ∈ l) (familyP_eq gate (t + 1)) mp)
  ⟨SelectionTerm.concord_uniform same _, SelectionTerm.discord_uniform same _⟩

/-- **The drawers' share goes from one of two to all**: the restrained member leaves none, the
drawer two. -/
theorem share_P (gate : Bool) :
    total ((generations (courseP gate)).family 0) (fun p => draw p - 1) = 1 ∧
    total ((generations (courseP gate)).family 1) (fun p => draw p - 1) = 2 := by
  cases gate <;> decide

/-- **Eight steps of excess**: from step one the two drawers take four units a step against the
renewal's three. -/
theorem excess_P (gate : Bool) : ∀ k, k < 8 →
    (flow gate (courseP gate)).replenishment [0] (1 + k) <
      (flow gate (courseP gate)).uptake [0] (1 + k)
  | 0, _ => by cases gate <;> decide
  | 1, _ => by cases gate <;> decide
  | 2, _ => by cases gate <;> decide
  | 3, _ => by cases gate <;> decide
  | 4, _ => by cases gate <;> decide
  | 5, _ => by cases gate <;> decide
  | 6, _ => by cases gate <;> decide
  | 7, _ => by cases gate <;> decide
  | k + 8, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 8 k))

/-- No excess at step zero: one drawer and one restrained member draw the renewal exactly. -/
theorem no_excess_first_P (gate : Bool) :
    (flow gate (courseP gate)).uptake [0] 0 = 3 ∧
      (flow gate (courseP gate)).replenishment [0] 0 = 3 := by
  cases gate <;> decide

/-- From a stock of eight at step one, below eight steps plus the need. -/
theorem start_P (gate : Bool) : (web gate (courseP gate)).stock [0] 1 < 8 + 1 := by
  cases gate <;> decide

/-- **The ledger, met at the horizon**: the pool's eight at step one, with the twenty-four units the
renewer gives across the eight steps of excess, is below the need with the thirty-two units the
drawers take. -/
theorem draws_past_P (gate : Bool) :
    (web gate (courseP gate)).stock [0] 1 +
        total (steps 1 8) ((flow gate (courseP gate)).replenishment [0]) <
      1 + total (steps 1 8) ((flow gate (courseP gate)).uptake [0]) := by
  cases gate <;> decide

/-- **The landed gated law, met with a nonempty generation at its horizon**: every premise of
`LineageRegimes.degeneration_of_family_excess` holds with the gate, at `T = 1`, `n = 8`, `m = 1`,
and generation nine has two members, each requiring the pool. -/
theorem landed_met :
    «退化» (lineStep (flow true (courseP true)) (web true (courseP true)) (oneKind Nat))
      ((web true (courseP true)).kindClass (oneKind Nat)) (0, 4) :=
  LineageRegimes.degeneration_of_family_excess (balances_P true) (acting true _)
    (dependent true _) (gated _) (excess_P true) (start_P true) (x := (0, 4)) rfl
    (Nat.zero_le _) (depends_pool (by decide) _)

/-- **Renewal from outside, the same excess, the same end**: without the gate the renewer gives
three units at every step and requires nothing (`from_outside`), the coupled gate fails
(`not_gated`), every other premise of the landed law holds, and the line degenerates
(`degeneration_of_excess`). -/
theorem outside_ends :
    «退化» (lineStep (flow false (courseP false)) (web false (courseP false)) (oneKind Nat))
      ((web false (courseP false)).kindClass (oneKind Nat)) (0, 4) :=
  degeneration_of_excess (balances_P false) (dependent false _) (excess_P false) (start_P false)
    (x := (0, 4)) rfl (Nat.zero_le _) (depends_pool (by decide) _)

/-- **Every active organism's line up to step nine degenerates**, with the gate or without it. -/
theorem every_active_degenerates_P (gate : Bool) {x : Nat × Nat} (org : 2 ≤ x.2)
    (active : (web gate (courseP gate)).active x.1 x.2) (le : x.1 ≤ 9) :
    «退化» (lineStep (flow gate (courseP gate)) (web gate (courseP gate)) (oneKind Nat))
      ((web gate (courseP gate)).kindClass (oneKind Nat)) x :=
  degeneration_of_unmet (dependent gate (courseP gate)) (ds := [0]) (m := 1) (N := 9)
    Nat.zero_lt_one active le (depends_pool org 9)

/-- Every member of generation nine requires the pool at need one. -/
theorem members_need_P (gate : Bool) : ∀ q, q ∈ (generations (courseP gate)).family 9 →
    ∃ e, e ∈ [0] ∧ (web gate (courseP gate)).requires 9 q e ∧
      1 ≤ (web gate (courseP gate)).need 9 q e :=
  fun q mq =>
    have mq' : q ∈ [5, 6] := Eq.subst (motive := fun l => q ∈ l) (familyP_eq gate 9) mq
    match q, mq' with
    | _, .head _ => ⟨0, .head _, rfl, Nat.le_refl 1⟩
    | _, .tail _ (.head _) => ⟨0, .head _, rfl, Nat.le_refl 1⟩

/-- **And on the census, through the ledger**: every premise of `ends_of_drawdown` holds at `T = 1`,
`n = 8`, `m = 1`, with the gate or without it, so every generation after step nine is empty and the
selection term is zero from step nine on. -/
theorem ends_P (gate : Bool) : ∀ s, (generations (courseP gate)).size (1 + 8 + 1 + s) = 0 ∧
    (generations (courseP gate)).concordAt (1 + 8 + s) = 0 ∧
    (generations (courseP gate)).discordAt (1 + 8 + s) = 0 :=
  ends_of_drawdown (balances_P gate) (acting gate _) (dependent gate _) (descended_P gate)
    (draws_past_P gate) (members_need_P gate)

/-- **And nothing after the first step**: the selection term proper is zero at every step after
step zero, each drawer leaving one offspring until step nine and none from it on. -/
theorem selection_after_P (gate : Bool) : ∀ t,
    (generations (courseP gate)).concordAt (t + 1) = 0 ∧
      (generations (courseP gate)).discordAt (t + 1) = 0
  | 0 => uniform_P gate 0 (by decide)
  | 1 => uniform_P gate 1 (by decide)
  | 2 => uniform_P gate 2 (by decide)
  | 3 => uniform_P gate 3 (by decide)
  | 4 => uniform_P gate 4 (by decide)
  | 5 => uniform_P gate 5 (by decide)
  | 6 => uniform_P gate 6 (by decide)
  | 7 => uniform_P gate 7 (by decide)
  | t + 8 => Eq.subst (motive := fun k => (generations (courseP gate)).concordAt k = 0 ∧
        (generations (courseP gate)).discordAt k = 0)
      (Nat.add_comm 9 t) (ends_P gate t).2

end Drain

end LineageDrawdown

end Becoming
