import Becoming.LineageRegimes

/-!
# A lineage drawn below its need (EL7 (c), scratch)

Scratch module of the EL7 investigation (c), AI-written. Not landed; nothing here is claimed until a
reader has checked it.

* **The ledger.** Under balance, a family's stock after `n` steps, with everything taken from it
  across them, is its stock before, with everything given to it (`stock_ledger`). So the stock is
  below a need `m` after the `n` steps exactly where the stock before, with everything given, is
  below `m` with everything taken (`below_iff`): the exact condition, in the draws.
* **One decider through conditions.** Where activity needs support, a line from an active
  occurrence ends on every branch at the kind grain where everything it reaches at one step `N` not
  before it requires, at a need of at least `m`, a member of a family whose stock at `N` is below
  `m` (`degeneration_of_unmet`); no flow premise enters. Read through the ledger
  (`degeneration_of_drawdown`), and through `n` steps of excess (`degeneration_of_excess`), which is
  the landed `LineageRegimes.degeneration_of_family_excess` without its gate and without `Acting`:
  those two premises are idle in the landed proof (it uses `Flow.family_excess_ends` at `k = 0`,
  where the gate and the givers' support are not used) (`landed_of_excess`).
* **The map's horizon law, likewise.** `Web.family_excess_gone` and `Web.family_excess_degenerates`
  (`Becoming.MapInstances`) hold without their gate and `Acting` (`gone_of_excess`,
  `horizon_of_excess`) and are their cases (`landed_gone`, `landed_horizon`): the gate of
  `Flow.family_excess_ends` is used only for the steps after the one the excess reaches, and a line
  at a class within activity cannot pass a step at which nothing it reaches is active.
* **What it forbids, on the census.** In generations of descent, where only active formations give
  and activity needs support, a generation every member of which requires, at a need of at least
  `m`, a member of a family whose stock at its step is below `m` has an empty next generation
  (`next_empty_of_unmet`); every later generation is empty and the selection term proper is zero
  from that step on (`ends_of_unmet`, through the ledger `ends_of_drawdown`). So no course has a
  positive selection term at the step where its draws have passed its stock less the need
  (`no_term_of_drawdown`).
* **Selection on a draw past the renewal (`Drain`).** One law, three courses from one first
  generation and one pool, each with the renewer gated on the pool or giving from outside (`gate`).
  With selection on the draw (`courseS`: each drawer leaves as many offspring as it draws),
  concordance of offspring number with the draw is positive at every step but the last nonempty
  one, the drawers' share and the mean draw rise, the uptake meets the renewal at the first step and
  runs past it after, and the lineage degenerates, the restrained line with it: every active
  organism's line up to the step the ledger is met (`every_active_degenerates_S`). Without selection
  (`courseN`: every member leaves one), the same draws keep the pool at eight and the lineage
  generates, drawers included. With selection at the first step only and no growth (`courseP`: the
  restrained member leaves none, the drawer two, which then relay), eight steps of excess from a
  stock of eight meet the landed gated regime with a nonempty generation at its horizon
  (`landed_met`), and with renewal from outside, every premise but the gate, the line ends the same
  (`outside_ends`). The gate decides the renewal's fate, not the lineage's: with it and selection
  the renewer's line degenerates too (`renewer_degenerates_S`); without the gate it goes on in every
  course (`renewer_goes_on_outside`), and without selection with the gate (`renewer_goes_on_N`).

Modelling choices: discrete steps; natural-number levels, needs, gifts, takes and offspring numbers;
activity Prop-valued, decided in the witness by Booleans; a need a threshold on a level; giving not
drawn from the giver's own level unless it takes; descent as giving to what comes to stand; in
`Drain` each organism stands at one step only, takes its own standing there, draws its draw from the
pool while active and gives each offspring one unit, and the renewer gives three units a step while
active. An empty axiom report says nothing of these.
-/

namespace Becoming

namespace LineageDrawdown

open LineageRegions

/-! ## The ledger -/

section Ledger

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **The family's ledger over `n` steps**: under balance, the stock at `T + n`, with the family's
uptake across the `n` steps from `T`, is the stock at `T`, with its replenishment across them. -/
theorem stock_ledger (balances : L.Balances W) (ds : List C) :
    ∀ n T, W.stock ds (T + n) + total (steps T n) (L.uptake ds) =
      W.stock ds T + total (steps T n) (L.replenishment ds)
  | 0, _ => rfl
  | n + 1, T =>
    have ih := stock_ledger balances ds n (T + 1)
    have over := balances.over ds T
    have shift : T + (n + 1) = T + 1 + n := Nat.add_right_comm T n 1
    calc W.stock ds (T + (n + 1)) + (L.uptake ds T + total (steps (T + 1) n) (L.uptake ds))
        = (W.stock ds (T + 1 + n) + total (steps (T + 1) n) (L.uptake ds)) + L.uptake ds T := by
          rw [shift, Nat.add_left_comm, Nat.add_comm]
      _ = (W.stock ds (T + 1) + total (steps (T + 1) n) (L.replenishment ds)) + L.uptake ds T := by
          rw [ih]
      _ = (W.stock ds (T + 1) + L.uptake ds T) + total (steps (T + 1) n) (L.replenishment ds) :=
          Nat.add_right_comm _ _ _
      _ = (W.stock ds T + L.replenishment ds T) + total (steps (T + 1) n) (L.replenishment ds) := by
          rw [over]
      _ = W.stock ds T + (L.replenishment ds T + total (steps (T + 1) n) (L.replenishment ds)) :=
          Nat.add_assoc _ _ _

/-- **Below a need exactly where the draws outrun the stock**: under balance, the family's stock at
`T + n` is below `m` exactly where its stock at `T`, with everything given to it across the `n`
steps, is below `m` with everything taken from it. -/
theorem below_iff (balances : L.Balances W) (ds : List C) (T n m : Nat) :
    W.stock ds (T + n) < m ↔
      W.stock ds T + total (steps T n) (L.replenishment ds) <
        m + total (steps T n) (L.uptake ds) :=
  have ledger := stock_ledger balances ds n T
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
with its gate and `Acting` dropped. -/
theorem degeneration_of_excess (balances : L.Balances W) (dependent : W.Dependent)
    {ds : List X} {m T n : Nat}
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {x : Nat × X} (active : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (depends : ∀ y, «所及» (lineStep L W Q) (W.kindClass Q) x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires y.1 y.2 e ∧ m ≤ W.need y.1 y.2 e) :
    «退化» (lineStep L W Q) (W.kindClass Q) x :=
  degeneration_of_unmet dependent (below_of_excess balances excess start) active le depends

/-- The landed gated reading is the case of `degeneration_of_excess`: its gate and `Acting` are
not used. -/
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

/-- `Web.family_excess_gone` is the case of `gone_of_excess`: its gate and `Acting` are not used. -/
theorem landed_gone {W : Web F C} {L : Flow F C} (balances : L.Balances W)
    (_acting : L.Acting W) (dependent : W.Dependent) {ds : List C} {m : Nat}
    (_gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {y : Nat × F} (at_ : y.1 = T + n)
    (held : ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ W.active y.1 y.2 :=
  gone_of_excess balances dependent excess stock at_ held

/-- `Web.family_excess_degenerates` is the case of `horizon_of_excess`: its gate and `Acting` are
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

end Horizon

/-! ## What the drawdown forbids, on the census -/

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

/-! ## Selection on a draw past the renewal, and the same draws without it

Relata are numbered: `0` the pool, `1` its renewer, `2` and `3` the restrained relay (each draws one
unit from the pool and leaves one offspring, the other), `4` to `18` drawers (each draws two units).
The renewer gives the pool three units at every step it is active: what one drawer and one restrained
member draw together. `gate` says whether the renewer requires the pool (at need one). Every
organism requires the pool at need one, stands at its own step only, takes its own standing at that
step, and while active takes its draw from the pool and gives one unit to each of its offspring.

Three courses share the first generation (`2` and `4`) and the pool's eight. In `courseS` each
drawer leaves as many offspring as it draws (two: `4` leaves `5` and `6`, they leave `7` to `10`,
those `11` to `18`) and the restrained one. In `courseN` every member leaves one (`4` and `5` relay
each other, as `2` and `3` do). In `courseP` the restrained member leaves none and `4` leaves two
drawers, which then relay (`5` and `7`, `6` and `8`): selection at the first step only, and the
generation's size two throughout. -/

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

/-! ### The three courses -/

/-- With selection: the pool at eight, eight, six, then nothing; with the gate it stays at nothing,
without it the renewer restores it three units a step. -/
def phaseS (gate : Bool) : Nat → Phase
  | 0 => ⟨8, fun c => c == 2 || c == 4⟩
  | 1 => ⟨8, fun c => c == 3 || c == 5 || c == 6⟩
  | 2 => ⟨6, fun c => c == 2 || c == 7 || c == 8 || c == 9 || c == 10⟩
  | 3 => ⟨0, fun c => c == 3 || (Nat.ble 11 c && Nat.ble c 18)⟩
  | t + 4 => ⟨bif gate then 0 else 3 * (t + 1), fun _ => false⟩

def kidsS (t : Nat) : Nat → List Nat
  | 2 => bif t == 0 || t == 2 then [3] else []
  | 3 => bif t == 1 then [2] else []
  | 4 => [5, 6]
  | 5 => [7, 8]
  | 6 => [9, 10]
  | 7 => [11, 12]
  | 8 => [13, 14]
  | 9 => [15, 16]
  | 10 => [17, 18]
  | _ => []

def familyS : Nat → List Nat
  | 0 => [2, 4]
  | 1 => [3, 5, 6]
  | 2 => [2, 7, 8, 9, 10]
  | 3 => [3, 11, 12, 13, 14, 15, 16, 17, 18]
  | _ + 4 => []

def courseS (gate : Bool) : Course where
  phase := phaseS gate
  kids := kidsS
  members := familyS

/-- Without selection, by the relay's turn: the pool at eight, `2` and `4` standing at even steps,
`3` and `5` at odd ones. -/
def phaseN (e : Bool) : Phase :=
  ⟨8, fun c => (e && (c == 2 || c == 4)) || (!e && (c == 3 || c == 5))⟩

def kidsN : Nat → List Nat
  | 2 => [3]
  | 3 => [2]
  | 4 => [5]
  | 5 => [4]
  | _ => []

def familyN (e : Bool) : List Nat := bif e then [2, 4] else [3, 5]

def courseN : Course where
  phase t := phaseN (Reproduction.Relay.turn t)
  kids _ := kidsN
  members t := familyN (Reproduction.Relay.turn t)

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

theorem within (κ : Course) : WithinKind (generations κ) (oneKind Nat) :=
  fun _ _ _ _ _ => trivial

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

/-- From the renewer the line passes only to the renewer: it gives only to the pool, which is never
active. -/
theorem step_renewer {gate : Bool} {κ : Course} : ∀ {y z : Nat × Nat},
    «续» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat)) y z → y.2 = 1 → z.2 = 1
  | _, (_, 1), _, _ => rfl
  | (_, _), (_, 0), c, at1 => match c.1.2 with
    | .inl ⟨same, _⟩ => same.symm.trans at1
    | .inr ⟨⟨_, gives, _⟩, _⟩ =>
      absurd (c.2.1.mp (active_of_give _ 0 gives)) (fun h => nomatch h)
  | (t, _), (_, k + 2), c, at1 => match c.1.2 with
    | .inl ⟨same, _⟩ => same.symm.trans at1
    | .inr ⟨⟨_, gives, _⟩, _⟩ =>
      absurd (Eq.subst (motive := fun f => 0 < giveOf gate (κ.phase t) (κ.kids t) f (k + 2))
          at1 gives)
        (Nat.lt_irrefl 0)

theorem line_renewer {gate : Bool} {κ : Course} :
    ∀ {y z : Nat × Nat}, «及» («续» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat))) y z → y.2 = 1 → z.2 = 1
  | _, _, .one c, at1 => step_renewer c at1
  | _, _, .more c rest, at1 => line_renewer rest (step_renewer c at1)

theorem reach_renewer {gate : Bool} {κ : Course} {x y : Nat × Nat}
    (reached : «所及» (lineStep (flow gate κ) (web gate κ) (oneKind Nat))
      ((web gate κ).kindClass (oneKind Nat)) x y) (at1 : x.2 = 1) : y.2 = 1 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × Nat => z.2 = 1) same at1
  | .inr line => line_renewer line at1

/-- **Without the gate the renewer's line goes on** (`«延»`) in every course: it carries on as
itself at every step, requiring nothing. -/
theorem renewer_goes_on_outside (κ : Course) :
    «延» (lineStep (flow false κ) (web false κ) (oneKind Nat))
      ((web false κ).kindClass (oneKind Nat)) (0, 1) :=
  ⟨fun z => z.2 = 1, rfl, fun z at1 => ⟨(z.1 + 1, 1), rfl,
    ⟨⟨rfl, .inl ⟨at1, Eq.subst (motive := fun g => (web false κ).Supported z.1 g) at1.symm
        (fun _ req => nomatch req.1)⟩⟩,
     ⟨⟨fun _ => rfl, fun _ => Eq.subst (motive := fun g => (web false κ).active z.1 g)
        at1.symm rfl⟩, trivial⟩⟩⟩⟩

/-! ### The census -/

theorem familyS_eq (gate : Bool) : ∀ t, (generations (courseS gate)).family t = familyS t
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | 4 => rfl
  | t + 5 =>
    have before := familyS_eq gate (t + 4)
    show ((generations (courseS gate)).family (t + 4)).flatMap
        ((generations (courseS gate)).kids (t + 4)) = []
    by rw [before]; rfl

theorem familyN_eq : ∀ t, (generations courseN).family t = familyN (Reproduction.Relay.turn t)
  | 0 => rfl
  | t + 1 =>
    have before := familyN_eq t
    show ((generations courseN).family t).flatMap ((generations courseN).kids t) =
      familyN (!Reproduction.Relay.turn t)
    by
      rw [before]
      show (familyN (Reproduction.Relay.turn t)).flatMap kidsN =
        familyN (!Reproduction.Relay.turn t)
      cases Reproduction.Relay.turn t <;> rfl

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

/-! ### Balance, course by course -/

theorem stepN (gate e : Bool) (c : Nat) :
    levelOf (phaseN (!e)) c + total (1 :: familyN e) (fun f => takeOf gate (phaseN e) f c) =
      levelOf (phaseN e) c + total (1 :: familyN e) (fun f => giveOf gate (phaseN e) kidsN f c) := by
  cases gate <;> cases e <;>
    exact match c with
    | 0 | 1 | 2 | 3 | 4 | 5 => rfl
    | _ + 6 => rfl

theorem stepS (gate : Bool) : ∀ t c,
    levelOf (phaseS gate (t + 1)) c +
        total (1 :: familyS t) (fun f => takeOf gate (phaseS gate t) f c) =
      levelOf (phaseS gate t) c +
        total (1 :: familyS t) (fun f => giveOf gate (phaseS gate t) (kidsS t) f c)
  | 0, c => by
    cases gate <;>
      exact match c with
      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 => rfl
      | _ + 19 => rfl
  | 1, c => by
    cases gate <;>
      exact match c with
      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 => rfl
      | _ + 19 => rfl
  | 2, c => by
    cases gate <;>
      exact match c with
      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 => rfl
      | _ + 19 => rfl
  | 3, c => by
    cases gate <;>
      exact match c with
      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 => rfl
      | _ + 19 => rfl
  | _ + 4, c => by
    cases gate <;>
      exact match c with
      | 0 | 1 => rfl
      | _ + 2 => rfl

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

/-- **Every course balances.** -/
theorem balances_S (gate : Bool) : (flow gate (courseS gate)).Balances (web gate (courseS gate)) :=
  fun t c => stepS gate t c

theorem balances_N (gate : Bool) : (flow gate courseN).Balances (web gate courseN) :=
  fun t c => stepN gate (Reproduction.Relay.turn t) c

theorem balances_P (gate : Bool) : (flow gate (courseP gate)).Balances (web gate (courseP gate)) :=
  fun t c => stepP gate t c

/-! ### Descent, course by course -/

theorem descendsS (gate : Bool) : ∀ t, t < 4 → ∀ p, p ∈ familyS t → ∀ k, k ∈ kidsS t p →
    0 < giveOf gate (phaseS gate t) (kidsS t) p k ∧
      ¬ 0 < levelOf (phaseS gate t) k ∧ 0 < levelOf (phaseS gate (t + 1)) k
  | 0, _ => by cases gate <;> decide
  | 1, _ => by cases gate <;> decide
  | 2, _ => by cases gate <;> decide
  | 3, _ => by cases gate <;> decide
  | t + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 t))

theorem descendsN (gate e : Bool) : ∀ p, p ∈ familyN e → ∀ k, k ∈ kidsN p →
    0 < giveOf gate (phaseN e) kidsN p k ∧
      ¬ 0 < levelOf (phaseN e) k ∧ 0 < levelOf (phaseN (!e)) k := by
  cases gate <;> cases e <;> decide

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

/-- **The generations are generations of descent** in every course. -/
theorem descended_S (gate : Bool) : SelectionTerm.Flow.Descended (flow gate (courseS gate))
    (web gate (courseS gate)) (generations (courseS gate)) :=
  fun t p k mp mk =>
    have mp' : p ∈ familyS t := Eq.subst (motive := fun l => p ∈ l) (familyS_eq gate t) mp
    match t, mp' with
    | 0, m => ⟨.tail _ m, descendsS gate 0 (by decide) p m k mk⟩
    | 1, m => ⟨.tail _ m, descendsS gate 1 (by decide) p m k mk⟩
    | 2, m => ⟨.tail _ m, descendsS gate 2 (by decide) p m k mk⟩
    | 3, m => ⟨.tail _ m, descendsS gate 3 (by decide) p m k mk⟩
    | _ + 4, m => nomatch m

theorem descended_N (gate : Bool) : SelectionTerm.Flow.Descended (flow gate courseN)
    (web gate courseN) (generations courseN) :=
  fun t p k mp mk =>
    have mp' : p ∈ familyN (Reproduction.Relay.turn t) :=
      Eq.subst (motive := fun l => p ∈ l) (familyN_eq t) mp
    ⟨.tail _ mp', descendsN gate (Reproduction.Relay.turn t) p mp' k mk⟩

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

theorem descended_P (gate : Bool) : SelectionTerm.Flow.Descended (flow gate (courseP gate))
    (web gate (courseP gate)) (generations (courseP gate)) :=
  fun t p k mp mk =>
    descends_atP gate t p (Eq.subst (motive := fun l => p ∈ l) (familyP_eq gate t) mp) k mk

/-! ### Without selection the lineage generates -/

theorem embodiedN (gate e : Bool) : ∀ k, k ∈ [2, 3, 4, 5] →
    (activeOf gate (phaseN e) k = true ↔ 0 < levelOf (phaseN e) k) := by
  cases gate <;> cases e <;> decide

theorem embodied_N (gate : Bool) : EmbodiedOffspring (web gate courseN) (generations courseN) :=
  fun t p k mp mk s =>
    have mp' : p ∈ familyN (Reproduction.Relay.turn t) :=
      Eq.subst (motive := fun l => p ∈ l) (familyN_eq t) mp
    have mk' : k ∈ [2, 3, 4, 5] := match Reproduction.Relay.turn t, p, mp', mk with
      | true, _, .head _, mk => match k, (mk : k ∈ [3]) with
        | _, .head _ => .tail _ (.head _)
      | true, _, .tail _ (.head _), mk => match k, (mk : k ∈ [5]) with
        | _, .head _ => .tail _ (.tail _ (.tail _ (.head _)))
      | false, _, .head _, mk => match k, (mk : k ∈ [2]) with
        | _, .head _ => .head _
      | false, _, .tail _ (.head _), mk => match k, (mk : k ∈ [4]) with
        | _, .head _ => .tail _ (.tail _ (.head _))
    embodiedN gate (Reproduction.Relay.turn s) k mk'

theorem reproduces_N : ∀ s q, 0 ≤ s → q ∈ (generations courseN).family s →
    ∃ k, k ∈ (generations courseN).kids s q :=
  fun s q _ mq =>
    have mq' : q ∈ familyN (Reproduction.Relay.turn s) :=
      Eq.subst (motive := fun l => q ∈ l) (familyN_eq s) mq
    match Reproduction.Relay.turn s, q, mq' with
    | true, _, .head _ => ⟨3, List.Mem.head _⟩
    | true, _, .tail _ (.head _) => ⟨5, List.Mem.head _⟩
    | false, _, .head _ => ⟨2, List.Mem.head _⟩
    | false, _, .tail _ (.head _) => ⟨4, List.Mem.head _⟩

/-- **Without selection the lineage generates**, the drawer included, with the gate or without it:
every member leaves an offspring like itself, at the pool's eight, at every step. -/
theorem generates_N (gate : Bool) :
    «生成» (lineStep (flow gate courseN) (web gate courseN) (oneKind Nat))
        ((web gate courseN).kindClass (oneKind Nat)) (web gate courseN).carrierClass (0, 2) ∧
      «生成» (lineStep (flow gate courseN) (web gate courseN) (oneKind Nat))
        ((web gate courseN).kindClass (oneKind Nat)) (web gate courseN).carrierClass (0, 4) :=
  ⟨generation_of_reproducing (acting gate courseN) (descended_N gate) (within courseN)
     (embodied_N gate) reproduces_N (.head _),
   generation_of_reproducing (acting gate courseN) (descended_N gate) (within courseN)
     (embodied_N gate) reproduces_N (.tail _ (.head _))⟩

theorem pool_N (gate : Bool) (t : Nat) : (web gate courseN).level t 0 = 8 := rfl

theorem offspring_N : ∀ t p, p ∈ (generations courseN).family t →
    (generations courseN).offspringNumber t p = 1 :=
  fun t p mp =>
    have mp' : p ∈ familyN (Reproduction.Relay.turn t) :=
      Eq.subst (motive := fun l => p ∈ l) (familyN_eq t) mp
    match Reproduction.Relay.turn t, p, mp' with
    | true, _, .head _ => rfl
    | true, _, .tail _ (.head _) => rfl
    | false, _, .head _ => rfl
    | false, _, .tail _ (.head _) => rfl

/-- **Without selection the term is zero at every step**: every member leaves one offspring. -/
theorem selection_N (t : Nat) :
    (generations courseN).concordAt t = 0 ∧ (generations courseN).discordAt t = 0 :=
  ⟨SelectionTerm.concord_uniform (offspring_N t) _, SelectionTerm.discord_uniform (offspring_N t) _⟩

/-- **Without selection the renewer's line goes on too**, with the gate or without it: the pool
stays at eight. -/
theorem renewer_goes_on_N (gate : Bool) :
    «延» (lineStep (flow gate courseN) (web gate courseN) (oneKind Nat))
      ((web gate courseN).kindClass (oneKind Nat)) (0, 1) :=
  have sup : ∀ t, (web gate courseN).Supported t 1 := fun t c req =>
    Eq.subst (motive := fun c => (web gate courseN).need t 1 c ≤ (web gate courseN).level t c)
      req.2.symm (by decide : 1 ≤ 8)
  have act : ∀ t, (web gate courseN).active t 1 := fun _ => by cases gate <;> rfl
  ⟨fun z => z.2 = 1, rfl, fun z at1 => ⟨(z.1 + 1, 1), rfl,
    ⟨⟨rfl, .inl ⟨at1, Eq.subst (motive := fun g => (web gate courseN).Supported z.1 g) at1.symm
        (sup z.1)⟩⟩,
     ⟨⟨fun _ => act (z.1 + 1), fun _ => Eq.subst (motive := fun g => (web gate courseN).active z.1 g)
        at1.symm (act z.1)⟩, trivial⟩⟩⟩⟩

/-! ### With selection on the draw the lineage ends -/

/-- **With selection the lineage degenerates**, the restrained line with it, with the gate or
without it: at step three the pool is at nothing and everything the lines reach requires it at
one. -/
theorem degenerates_S (gate : Bool) :
    «退化» (lineStep (flow gate (courseS gate)) (web gate (courseS gate)) (oneKind Nat))
        ((web gate (courseS gate)).kindClass (oneKind Nat)) (0, 2) ∧
      «退化» (lineStep (flow gate (courseS gate)) (web gate (courseS gate)) (oneKind Nat))
        ((web gate (courseS gate)).kindClass (oneKind Nat)) (0, 4) :=
  have below : (web gate (courseS gate)).stock [0] 3 < 1 := Nat.zero_lt_one
  ⟨degeneration_of_unmet (dependent gate _) below (x := (0, 2)) rfl (Nat.zero_le 3)
     (depends_pool (Nat.le_refl 2) 3),
   degeneration_of_unmet (dependent gate _) below (x := (0, 4)) rfl (Nat.zero_le 3)
     (depends_pool (by decide) 3)⟩

theorem org_S : ∀ t q, q ∈ familyS t → 2 ≤ q
  | 0 => by decide
  | 1 => by decide
  | 2 => by decide
  | 3 => by decide
  | _ + 4 => fun _ m => nomatch m

/-- Every member of generation three requires the pool at need one. -/
theorem members_need_S (gate : Bool) : ∀ q, q ∈ (generations (courseS gate)).family (0 + 3) →
    ∃ e, e ∈ [0] ∧ (web gate (courseS gate)).requires (0 + 3) q e ∧
      1 ≤ (web gate (courseS gate)).need (0 + 3) q e :=
  fun q mq =>
    match q, org_S 3 q (Eq.subst (motive := fun l => q ∈ l) (familyS_eq gate 3) mq) with
    | 0, le => absurd le (Nat.not_succ_le_zero 1)
    | 1, le => absurd le (Nat.not_succ_le_self 1)
    | _ + 2, _ => ⟨0, .head _, rfl, Nat.le_refl 1⟩

/-- **Every active organism's line up to step three degenerates**, whatever cohort it is in, with the
gate or without it. -/
theorem every_active_degenerates_S (gate : Bool) {x : Nat × Nat} (org : 2 ≤ x.2)
    (active : (web gate (courseS gate)).active x.1 x.2) (le : x.1 ≤ 3) :
    «退化» (lineStep (flow gate (courseS gate)) (web gate (courseS gate)) (oneKind Nat))
      ((web gate (courseS gate)).kindClass (oneKind Nat)) x :=
  degeneration_of_unmet (dependent gate (courseS gate)) (ds := [0]) (m := 1) (N := 3)
    Nat.zero_lt_one active le (depends_pool org 3)

/-- The generation born at step three finds the pool empty: none of it is supported. -/
theorem stillborn_S (gate : Bool) : ∀ k, k ∈ (generations (courseS gate)).family 3 →
    ¬ (web gate (courseS gate)).Supported 3 k :=
  fun k mk sup =>
    match k, org_S 3 k (Eq.subst (motive := fun l => k ∈ l) (familyS_eq gate 3) mk), sup with
    | 0, le, _ => absurd le (Nat.not_succ_le_zero 1)
    | 1, le, _ => absurd le (Nat.not_succ_le_self 1)
    | _ + 2, _, sup => Nat.not_succ_le_zero 0 (sup 0 rfl)

/-- **Concordance of offspring number with the draw** is one, two and four, with no discordance,
and both are zero at the last nonempty generation; the generation after it is empty. -/
theorem selection_S (gate : Bool) :
    (generations (courseS gate)).concordAt 0 = 1 ∧ (generations (courseS gate)).discordAt 0 = 0 ∧
    (generations (courseS gate)).concordAt 1 = 2 ∧ (generations (courseS gate)).discordAt 1 = 0 ∧
    (generations (courseS gate)).concordAt 2 = 4 ∧ (generations (courseS gate)).discordAt 2 = 0 ∧
    (generations (courseS gate)).concordAt 3 = 0 ∧ (generations (courseS gate)).discordAt 3 = 0 ∧
    (generations (courseS gate)).size 4 = 0 := by
  cases gate <;> decide

/-- **The mean draw rises at each step**: three over two, five over three, nine over five,
seventeen over nine (means compared by cross-multiplying). -/
theorem mean_rises_S (gate : Bool) :
    (generations (courseS gate)).size 1 * (generations (courseS gate)).sum 0 <
        (generations (courseS gate)).size 0 * (generations (courseS gate)).sum 1 ∧
      (generations (courseS gate)).size 2 * (generations (courseS gate)).sum 1 <
        (generations (courseS gate)).size 1 * (generations (courseS gate)).sum 2 ∧
      (generations (courseS gate)).size 3 * (generations (courseS gate)).sum 2 <
        (generations (courseS gate)).size 2 * (generations (courseS gate)).sum 3 := by
  cases gate <;> decide

/-- **The drawers' share rises**: one of two, two of three, four of five, eight of nine. -/
theorem share_rises_S (gate : Bool) :
    total ((generations (courseS gate)).family 0) (fun p => draw p - 1) = 1 ∧
    total ((generations (courseS gate)).family 1) (fun p => draw p - 1) = 2 ∧
    total ((generations (courseS gate)).family 2) (fun p => draw p - 1) = 4 ∧
    total ((generations (courseS gate)).family 3) (fun p => draw p - 1) = 8 ∧
    (generations (courseS gate)).size 0 = 2 ∧ (generations (courseS gate)).size 1 = 3 ∧
    (generations (courseS gate)).size 2 = 5 ∧ (generations (courseS gate)).size 3 = 9 := by
  cases gate <;> decide

/-- **Offspring number is the draw** at every member of the generations that reproduce. -/
theorem offspring_is_draw_S (gate : Bool) : ∀ t, t < 3 → ∀ p,
    p ∈ (generations (courseS gate)).family t →
      (generations (courseS gate)).offspringNumber t p = draw p
  | 0, _ => by cases gate <;> decide
  | 1, _ => by cases gate <;> decide
  | 2, _ => by cases gate <;> decide
  | t + 3, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 t))

/-- **The excess is selection's**: at step zero the uptake is the renewal, three; it is five and
nine at the next two steps, against the same three. -/
theorem excess_S (gate : Bool) :
    (flow gate (courseS gate)).uptake [0] 0 = 3 ∧ (flow gate (courseS gate)).replenishment [0] 0 = 3 ∧
    (flow gate (courseS gate)).uptake [0] 1 = 5 ∧ (flow gate (courseS gate)).replenishment [0] 1 = 3 ∧
    (flow gate (courseS gate)).uptake [0] 2 = 9 ∧
      (flow gate (courseS gate)).replenishment [0] 2 = 3 := by
  cases gate <;> decide

/-- **The exact condition, met at three steps**: the stock at the start with what is given across
the three steps is below the need with what is taken. -/
theorem draws_past_S (gate : Bool) :
    (web gate (courseS gate)).stock [0] 0 +
        total (steps 0 3) ((flow gate (courseS gate)).replenishment [0]) <
      1 + total (steps 0 3) ((flow gate (courseS gate)).uptake [0]) := by
  cases gate <;> decide

/-- **And not at two**: across the first two steps the draws have not passed the stock. -/
theorem short_at_two_S (gate : Bool) :
    ¬ ((web gate (courseS gate)).stock [0] 0 +
        total (steps 0 2) ((flow gate (courseS gate)).replenishment [0]) <
      1 + total (steps 0 2) ((flow gate (courseS gate)).uptake [0])) := by
  cases gate <;> decide

/-- **The landed count of excess steps does not reach step three in this course**: there is no
excess at step zero, eight is not below two plus one, nor six below one plus one; only the step
itself (no steps of excess) does, which is `degeneration_of_unmet`. -/
theorem count_short_S (gate : Bool) :
    ¬ (flow gate (courseS gate)).replenishment [0] 0 < (flow gate (courseS gate)).uptake [0] 0 ∧
    ¬ (web gate (courseS gate)).stock [0] 1 < 2 + 1 ∧
    ¬ (web gate (courseS gate)).stock [0] 2 < 1 + 1 := by
  cases gate <;> decide

/-- **The drawdown law, met**: every premise of `ends_of_drawdown` holds at `T = 0`, `n = 3`,
`m = 1`, so every generation after step three is empty and the selection term is zero from step
three on. -/
theorem ends_S (gate : Bool) : ∀ s, (generations (courseS gate)).size (0 + 3 + 1 + s) = 0 ∧
    (generations (courseS gate)).concordAt (0 + 3 + s) = 0 ∧
    (generations (courseS gate)).discordAt (0 + 3 + s) = 0 :=
  ends_of_drawdown (balances_S gate) (acting gate _) (dependent gate _) (descended_S gate)
    (draws_past_S gate) (members_need_S gate)

/-- **With the gate and selection the renewal ends with the lineage**: from step three the pool
stays at nothing and the renewer is never active again. -/
theorem renewal_ends_S : ∀ n, (web true (courseS true)).level (n + 3) 0 = 0 ∧
    ¬ (web true (courseS true)).active (n + 3) 1
  | 0 => ⟨rfl, fun h => nomatch h⟩
  | _ + 1 => ⟨rfl, fun h => nomatch h⟩

/-- **Without the gate the renewal goes on after the lineage**: the renewer stays active and the
pool comes back three units a step. -/
theorem renewal_goes_on_S : (web false (courseS false)).level 3 0 = 0 ∧
    (web false (courseS false)).active 3 1 ∧
    ∀ n, (web false (courseS false)).level (n + 4) 0 = 3 * (n + 1) ∧
      (web false (courseS false)).active (n + 4) 1 :=
  ⟨rfl, rfl, fun _ => ⟨rfl, rfl⟩⟩

/-- **With the gate and selection the renewer's line degenerates** (a lineage reading of the
drawers' joint excess ending the renewal): at step three it requires the pool at one, and the pool
is at nothing. -/
theorem renewer_degenerates_S :
    «退化» (lineStep (flow true (courseS true)) (web true (courseS true)) (oneKind Nat))
      ((web true (courseS true)).kindClass (oneKind Nat)) (0, 1) :=
  degeneration_of_unmet (dependent true (courseS true)) (ds := [0]) (m := 1) (N := 3)
    Nat.zero_lt_one
    (x := (0, 1)) rfl (Nat.zero_le 3) fun y hy _ =>
      Eq.subst (motive := fun k => ∃ e, e ∈ [0] ∧ (web true (courseS true)).requires y.1 k e ∧
          1 ≤ (web true (courseS true)).need y.1 k e)
        (reach_renewer hy rfl).symm ⟨0, .head _, ⟨rfl, rfl⟩, Nat.le_refl 1⟩

/-! ### Selection at one step, no growth: the landed count form met, with renewal from outside -/

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

/-- **The landed gated regime, met with a nonempty generation at its horizon**: every premise of
`LineageRegimes.degeneration_of_family_excess` holds with the gate, at `T = 1`, `n = 8`, `m = 1`,
and generation nine has two members, each requiring the pool. -/
theorem landed_met :
    «退化» (lineStep (flow true (courseP true)) (web true (courseP true)) (oneKind Nat))
      ((web true (courseP true)).kindClass (oneKind Nat)) (0, 4) :=
  LineageRegimes.degeneration_of_family_excess (balances_P true) (acting true _)
    (dependent true _) (gated _) (excess_P true) (start_P true) (x := (0, 4)) rfl
    (Nat.zero_le _) (depends_pool (by decide) _)

/-- **Renewal from outside, the same regime, the same end**: without the gate the renewer gives
three units at every step and requires nothing (`from_outside`), every premise of the landed regime
but the gate holds, and the line degenerates (`degeneration_of_excess`). -/
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

/-- **And on the census**: every generation after step nine is empty and the selection term is
zero from step nine on. -/
theorem ends_P (gate : Bool) : ∀ s, (generations (courseP gate)).size (9 + 1 + s) = 0 ∧
    (generations (courseP gate)).concordAt (9 + s) = 0 ∧
    (generations (courseP gate)).discordAt (9 + s) = 0 :=
  ends_of_unmet (acting gate _) (dependent gate _) (descended_P gate)
    (Nat.zero_lt_one : (web gate (courseP gate)).stock [0] 9 < 1) (members_need_P gate)

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
