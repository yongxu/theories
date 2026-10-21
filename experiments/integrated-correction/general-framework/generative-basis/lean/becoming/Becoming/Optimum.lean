import Becoming.DrawnBeyond
import Becoming.Frontier

/-!
# Optimum: what optimizing through couplings does beyond them

`Becoming.DrawnBeyond` showed that where the whole gains nothing the beyond falls by the rise and
the loss, that above the slack a dependence beyond breaks, and that a selection rewarding the rise
rewards that break unseen. It did not say what an *optimum* does: how far a selection that takes
the best it can, by an order rising with what couples in, lowers what lies beyond. This module
states it, over any set of outcomes and any such order, and on a web's dependences. An outcome is
the levels after a step (`C → Nat`); the eligible outcomes are any set of them; an optimum is a
member of the frontier of `Requirement.Frontier` (eligible, with no eligible outcome ranked above
it). The family `ds` is what couples in, `rest` the conditions beyond, listed apart.

* **The drive to the least level, exactly.** Call an order *rising* with a family where it ranks
  above every outcome exceeding another on the family (at least as high at each of its conditions
  and higher at one), whatever either holds beyond (`Optimum.Rising`). Every rising order's optima
  stand at the least level beyond, condition by condition, among the eligible outcomes, exactly
  where every eligible outcome standing above another at a condition beyond is not unbeaten on the
  family (`Optimum.least_iff`). So, where lowering a condition beyond leaves the family room to
  rise (`Optimum.Room`), every optimum is at the least level beyond (`Optimum.least_of_room`); where
  it does not, an optimum need not be (`Drain.room_needed`). One case of room is *shared units*:
  the eligible outcomes are closed under moving a unit from a condition beyond that holds one into
  a condition of the family (`Optimum.Shared.room`, `Optimum.least_of_shared`).
* **Counting the beyond after the proxy changes nothing.** An order ranking above wherever a rising
  order does is rising (`Optimum.Rising.mono`): a lexicographic order with the family first and
  the beyond counted after has its optima at the least level beyond (`Drain.counted_after_drains`).
  The stock of the family is a rising order (`Optimum.rising_total`); an order rising only to a
  target is not, and its optima include the outcome keeping what lies beyond and the outcome
  ending it (`Drain.satisficing_either`).
* **An optimum breaks exactly what any outcome breaks.** On a web whose levels after the step are
  an optimum of a rising order with room, with each condition beyond depended on at a need it meets,
  a dependence beyond is broken exactly where some eligible outcome leaves its condition below the
  need (`Web.optimum_broken_iff`): of the dependences beyond, the optimum breaks the most any
  eligible outcome breaks. Where activity needs support and the dependence is as it was, the
  formation ends, it is no member of a group all of whose couplings are in the family, and no
  member couples into its condition (`Web.optimum_ends_beyond`). `Drain` is the instance: the
  store's optimum drains the source and the dweller ends (`Drain.drained_ends`).
* **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
  steps from equal totals, each gaining nothing on the whole, one leaves the family at most where
  the other does exactly where it leaves the beyond with the loss at least where the other does
  (`Flow.Balances.family_le_iff`); so among such moves the ones whose family stock is highest are
  exactly the ones leaving least beyond with the loss (`Flow.top_iff_least`).
* **Keeping each dependence, the optimum takes exactly the slack.** Restricted to the outcomes
  keeping every dependence beyond at its need, a rising order with room among them, where each
  need is attained by one of them, has its optimum stand at the needs: it breaks nothing, and in a
  balanced step gaining nothing on the whole the family rises, with the loss, by exactly the slack
  (`Flow.keeping_optimum_takes_slack`). `Drain.kept_takes_slack` is the instance: the keeping
  optimum is `DrawnBeyond.WithinSlack`'s world.
* **Room, read off the exchange.** The outcomes open to a part across one step are the levels
  after every step that balances in which the formations outside the part exchange as they do and
  each member of the part takes from each condition at most its capacity there, gives only to a
  listed family and gives it no more than it takes from it (`Flow.ActsWithin`, `Flow.Outcome`).
  Among them, above any floors, there is room, with no premise beyond listings without
  repetition: an outcome above another at a condition beyond is exceeded on the family, by a unit
  taken there through a member whose capacity the other step uses more, or a unit given there
  that can go to the family instead (`Optimum.Above.room`).
* **Every optimum beyond, exactly.** Above its floor, an optimum of every order rising with the
  family has each member take its whole capacity at a condition beyond and give nothing there
  (`Optimum.Above.full`), so it stands at its floor or at what the rest leaves less the capacity
  (`Optimum.Above.floor_or_full`); with no floor, at the level before, with what the rest gives
  and less what it takes, less the part's capacity, or at nothing (`Optimum.optimum_beyond`).
* **No drive where no units are shared; the drain exactly where they are.** Where no member may
  take from a condition beyond, every optimum leaves it where the rest leaves it
  (`Optimum.optimum_untouched`); an optimum lowers it below that exactly where the part has some
  capacity there and the rest leaves something there (`Optimum.optimum_lowers_iff`); on a web, a
  dependence beyond is broken exactly where its need exceeds what the rest leaves less the
  capacity (`Web.optimum_broken_iff_capacity`). `Drain.drawing_optimum` is the instance: a taker
  of capacity `k` drains the source to `2 - k`, and the dweller's dependence breaks exactly where
  `0 < k` (`Drain.drawing_broken_iff`).
* **Several optimizers at once.** Where several formations each optimize alone, by its own order
  rising with its own family, and each one's step is an optimum among the outcomes open to it, the
  others exchanging as they do in the step that happened (a mutual best response,
  `Optimum.MutualBest`), a condition beyond every optimizer's family stands after the step at what
  the formations outside every optimizer leave there less the optimizers' joint capacity, or at
  nothing (`Optimum.mutual_beyond`). Where something stands there, each optimizer takes its whole
  capacity there and gives nothing, so restraint is no mutual best response
  (`Optimum.MutualBest.full`); the optimizers leave the condition where every optimum of one part
  made of all of them would, by any order rising with any family (`Optimum.mutual_as_one`); it is
  lowered exactly where they have some capacity there and something is left
  (`Optimum.mutual_lowers_iff`), and a dependence on it breaks exactly where its need exceeds that
  level (`Web.mutual_broken_iff_capacity`). `TwoTakers` is the instance: two takers of capacity
  one at a source of two, each take within the slack of a need of one, leave nothing at their
  mutual best response (`TwoTakers.joint_best`, `TwoTakers.joint_drains`,
  `TwoTakers.within_slack_jointly_below`), and the step where one restrains is no mutual best
  response (`TwoTakers.restrained_not_mutual`).
* **A course of steps.** Where a part chooses again at every step, the levels after each an
  optimum among the outcomes open to it from the levels before (`Optimum.Reoptimizes`), a
  condition beyond stands after each step at the level before with what the rest gives, less what
  the rest takes and the part's capacity, or at nothing (`Optimum.course_beyond`); for several
  optimizers at a mutual best response at every step, less their joint capacity
  (`Optimum.mutual_course_beyond`). Where the rest renews the condition by exactly `r` a step
  while it stands at a positive need `m`, by at most `r` below, and the draw there is `k`, a
  dependence at that need is lost exactly where `r < k` (`Web.course_lost_iff`): above the renewal
  the level never rises, falls by at least one at every step while something stands, and stands
  below the need once the steps exceed its starting excess over it, for good
  (`Optimum.never_rises`, `Optimum.ends_within`, `Optimum.level_stays_below`); within it the level
  never falls (`Optimum.kept_at_need`). Several optimizers each within the renewal lose it where
  their joint capacity exceeds it (`Web.mutual_course_lost`). No course draws more than the
  starting level with `r` for each step (`Optimum.drawn_within`); within the renewal it draws `k`
  at every step (`Optimum.kept_drawn`). What the renewal does below the need decides only what is
  drawn: where it stops there (a gate), as where whatever renews the condition depends on it
  (`Flow.restGiven_unsupported`), a course above the renewal draws at most the starting level with
  `r` for each of its units, however long (`Optimum.ended_drawn_le`, `Web.course_ended_drawn`), so
  a positive draw is bounded exactly where `r < k` (`Optimum.drawn_bounded_iff`) and over a long
  enough course keeping draws more (`Optimum.keeping_draws_more`); where at least one is given at
  every step, the dependence is lost all the same and the draw has no bound
  (`Optimum.drawn_unbounded`, `Web.course_drawn_unbounded`). `Renewing` is the instance: a taker
  choosing the store's optimum at every step against a dweller renewing the source loses the
  dweller exactly where `r < k` (`Renewing.lost_iff`), its store bounded exactly then
  (`Renewing.store_bounded_iff`) and below a taker of capacity `r` after long enough
  (`Renewing.keeping_holds_more`); two takers of
  capacity one at a mutual best response at every step lose a source renewed by one, which either
  alone keeps (`Renewing.joint_course_lost`, `Renewing.alone_kept`), and hold less than the course
  in which one restrains, no step of which is a mutual best response
  (`Renewing.restrained_course_not_best`, `Renewing.restraint_holds_more`).

**Reading (the AI's).** This is the spine's form of a known result: optimizing a proxy that
references only some attributes drives the others to their lower bounds (Zhuang and
Hadfield-Menell, "Consequences of Misaligned AI", 2020, Theorem 1). What the spine's form adds:
the characterization is over any order rising with what couples in, not a scalar proxy, and exact
on any set of outcomes (`least_iff`), with shared resources one sufficient case; no utility over
what lies beyond is assumed, the degradation being read as dependences broken and formations
ended, exactly those some outcome breaks; and the conservation identity says by how much: the
beyond with the loss falls by exactly what the family rises. Counting the beyond only after the
proxy keeps nothing, and restricting to keeping outcomes uses the slack and no more, which is less
than holding the beyond where it was (their Proposition 2). It does not reach their continuous
setting, the compactness characterization of their Theorem 2, or the interactive improvement of
their Theorem 3 and Propositions 4 and 5. Their Theorem 1 assumes a resource constraint shared by
the attributes; read off the exchange it is conservation with capacity: what a part's members
take they give, and what they may take is their capacity, so the drain lies exactly where the
part shares units with what lies beyond, by the capacity, and nowhere else. With several
optimizers each blind to the same condition, the drain is the sum of their capacities: how many
optimize, and whether they act together or each alone, does not change where the condition stands
(the tragedy of the commons, Hardin 1968, and open access, Gordon 1954, in the spine's form). Over
a course against a renewal this is the open-access depletion of a renewable resource (Gordon 1954;
Clark, *Mathematical Bioeconomics*, 1976) and, with several optimizers, the dynamic commons
(Levhari and Mirman 1980): what the form adds is that the threshold is exact over any orders
rising with any families, the dependence lost exactly above it whatever the renewal does below the
need, and that the gate decides the optimizer's own draw, the measure its order rises with: where
the renewal stops below the need that draw is bounded, and after long enough below what a capacity
at the renewal draws; where it does not, the draw goes on without bound after the dependence is
lost.

What is not derived: outside the outcomes open to a part across one step of exchange, which
outcomes are eligible and whether there is room (hypotheses wherever they enter, with witnesses
that each binds); within them, the capacities, the family the part gives to, and that a member
may give what it takes to any condition of that family (a member giving only to some is not
covered); over a course, a renewal varying with the level at or above the need (one growing with
the level, as in logistic growth, is not stated), an optimizer ranking courses rather than steps,
and how optimizers come to a mutual best response; for several optimizers,
that a mutual best response exists in general (the instance has one) and where a condition lies
within some optimizer's family; that a given optimizer's order rises with just the couplings listed (supplied, as in `Becoming.SelectionGap`); which formation depends on which
condition beyond and at what need (named by `dep`). That an order keeping what lies beyond
separates outcomes differing only beyond, and so goes through a member coupled into it, is
`Direction.widening_selected_by_pool`, not repeated here. The representation commits to discrete
steps and natural amounts. No ethical predicate, ranking of the beyond or axiom occurs.
-/

namespace Becoming

open Requirement

variable {F C : Type}

namespace Optimum

/-- One outcome exceeds another on a family: at least as high at each of its conditions and higher
at one. -/
def Exceeds (ds : List C) (o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → o c ≤ o' c) ∧ ∃ c, c ∈ ds ∧ o c < o' c

/-- An order rises with a family: it ranks every outcome exceeding another on the family above
it, whatever either holds elsewhere. -/
def Rising (ds : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', Exceeds ds o' o → better o' o

/-- Room beyond: an eligible outcome standing above another at a condition beyond is exceeded on
the family by an eligible outcome. -/
def Room (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
    ∃ o'', eligible o'' ∧ Exceeds ds o'' o

/-- At the least level beyond: at each condition beyond, no eligible outcome stands lower. -/
def Least (rest : List C) (eligible : (C → Nat) → Prop) (o : C → Nat) : Prop :=
  ∀ c, c ∈ rest → ∀ o', eligible o' → o c ≤ o' c

variable {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- Where an outcome exceeds another on a family, the family's total under it is higher. -/
theorem Exceeds.total_lt {o o' : C → Nat} :
    ∀ {ds : List C}, Exceeds ds o' o → total ds o < total ds o'
  | [], ⟨_, _, mem, _⟩ => nomatch mem
  | a :: ds, ⟨le, c, mem, lt⟩ => match mem_cons_cases mem with
    | .inl same =>
      Nat.add_lt_add_of_lt_of_le (Eq.subst (motive := fun y => o y < o' y) same lt)
        (total_le ds fun b listed => le b (.tail a listed))
    | .inr rest =>
      Nat.add_lt_add_of_le_of_lt (le a (.head ds))
        (Exceeds.total_lt ⟨fun b listed => le b (.tail a listed), c, rest, lt⟩)

/-- **The family's stock is a rising order.** -/
theorem rising_total (ds : List C) : Rising ds fun o' o => total ds o < total ds o' :=
  fun _ _ exceeds => exceeds.total_lt

/-- **An order ranking above wherever a rising order does is rising**: a lexicographic order with
the family first, whatever it counts after, is one. -/
theorem Rising.mono (rising : Rising ds better) {better' : (C → Nat) → (C → Nat) → Prop}
    (above : ∀ o' o, better o' o → better' o' o) : Rising ds better' :=
  fun o o' exceeds => above o' o (rising o o' exceeds)

/-- **The drive to the least level, exactly.** Every order rising with the family has its optima
at the least level beyond, condition by condition, among the eligible outcomes, exactly where every
eligible outcome standing above another at a condition beyond is not unbeaten on the family. -/
theorem least_iff :
    (∀ better, Rising ds better → ∀ o, Frontier eligible better o → Least rest eligible o) ↔
      ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
        ¬ ¬ ∃ o'', eligible o'' ∧ Exceeds ds o'' o :=
  ⟨fun drives o o' eligibleO eligibleO' c mem lower unbeaten =>
      Nat.not_le_of_gt lower
        (drives (fun o₁ o₂ => Exceeds ds o₁ o₂) (fun _ _ exceeds => exceeds) o
          ⟨eligibleO, fun o'' eligible'' exceeds => unbeaten ⟨o'', eligible'', exceeds⟩⟩
          c mem o' eligibleO'),
   fun beaten _ rising o optimum c mem o' eligibleO' => Nat.ge_of_not_lt fun lower =>
      beaten o o' optimum.1 eligibleO' c mem lower fun ⟨o'', eligible'', exceeds⟩ =>
        optimum.2 o'' eligible'' (rising o o'' exceeds)⟩

/-- **With room, every optimum is at the least level beyond.** -/
theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o :=
  least_iff.mpr (fun o o' eligibleO eligibleO' c mem lower unbeaten =>
    unbeaten (room o o' eligibleO eligibleO' c mem lower)) better rising o optimum

/-! ## Shared units -/

/-- One unit moved from `c` to `d`. -/
def transfer [DecidableEq C] (c d : C) (o : C → Nat) : C → Nat :=
  fun x => if x = c then o c - 1 else if x = d then o d + 1 else o x

/-- Shared units: the eligible outcomes are closed under moving a unit from a condition beyond
that holds one into a condition of the family. -/
def Shared [DecidableEq C] (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o, eligible o → ∀ c d, c ∈ rest → d ∈ ds → 0 < o c → eligible (transfer c d o)

/-- A unit moved from outside a family into it exceeds on the family. -/
theorem transfer_exceeds [DecidableEq C] {c d : C} (out : ¬ c ∈ ds) (inside : d ∈ ds)
    (o : C → Nat) : Exceeds ds (transfer c d o) o :=
  have kept : ∀ x, x ∈ ds → transfer c d o x = if x = d then o d + 1 else o x :=
    fun _ listed => if_neg fun same => out (Eq.subst (motive := fun y => y ∈ ds) same listed)
  ⟨fun x listed => Nat.le_trans
      (match decEq x d with
        | .isTrue same => Nat.le_trans (Nat.le_succ (o x))
            (Nat.le_of_eq ((congrArg (o · + 1) same).trans (if_pos same).symm))
        | .isFalse other => Nat.le_of_eq (if_neg other).symm)
      (Nat.le_of_eq (kept x listed).symm),
   d, inside, Nat.lt_of_lt_of_le (Nat.lt_succ_self (o d))
      (Nat.le_of_eq (((if_pos (rfl : d = d) : (if d = d then o d + 1 else o d) = o d + 1).symm).trans
        (kept d inside).symm))⟩

/-- **Shared units give room.** With the conditions beyond apart from a family holding at least
one condition, shared units give room beyond. -/
theorem Shared.room [DecidableEq C] (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) : Room ds rest eligible :=
  fun o _ eligibleO _ c mem lower =>
    ⟨transfer c d o, shared o eligibleO c d mem inside (Nat.lt_of_le_of_lt (Nat.zero_le _) lower),
     transfer_exceeds (apart c mem) inside o⟩

/-- **With shared units, every optimum is at the least level beyond.** -/
theorem least_of_shared [DecidableEq C] (rising : Rising ds better)
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) {o : C → Nat} (optimum : Frontier eligible better o) :
    Least rest eligible o :=
  least_of_room rising (shared.room apart inside) optimum

end Optimum

/-! ## On a web: what an optimum breaks -/

namespace Web

variable {W : Web F C} {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F} {t : Nat}

/-- **An optimum breaks exactly what any outcome breaks.** Where the levels after the step are an
optimum of an order rising with the family, with room beyond, and each condition beyond is
depended on at a need it meets, a dependence beyond is broken across the step exactly where some
eligible outcome leaves its condition below the need. -/
theorem optimum_broken_iff (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest eligible) (optimum : Frontier eligible better (W.level (t + 1)))
    (met : W.MetOn dep rest t) {c : C} (mem : c ∈ rest) :
    W.Broken t (dep c) c ↔ ∃ o, eligible o ∧ o c < W.need t (dep c) c :=
  ⟨fun broken => ⟨W.level (t + 1), optimum.1, broken.2.2⟩,
   fun ⟨_, eligibleO, below⟩ => ⟨(met c mem).1, (met c mem).2,
     Nat.lt_of_le_of_lt (Optimum.least_of_room rising room optimum c mem _ eligibleO) below⟩⟩

/-- **The formations beyond end, unseen.** Under the conditions of `Web.optimum_broken_iff`, where
activity needs support, some eligible outcome leaves a condition beyond below the need of the
dependence on it, and that dependence is as it was across the step, the dependence is broken and
its formation is not active after the step; where every condition a member of a group couples
into is in the family, that formation is no member, and no member couples into the condition. -/
theorem optimum_ends_beyond {obs : F → C → Prop} {members : F → Prop}
    (rising : Optimum.Rising ds better) (room : Optimum.Room ds rest eligible)
    (optimum : Frontier eligible better (W.level (t + 1))) (met : W.MetOn dep rest t)
    (dependent : W.Dependent) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds) {c : C} (mem : c ∈ rest)
    {o : C → Nat} (eligibleO : eligible o) (below : o c < W.need t (dep c) c)
    (fixed : W.requires (t + 1) (dep c) c ∧ W.need t (dep c) c ≤ W.need (t + 1) (dep c) c) :
    W.Broken t (dep c) c ∧ ¬ W.active (t + 1) (dep c) ∧ ¬ members (dep c) ∧
      ∀ h, members h → ¬ W.CoupledInto obs h c :=
  have broken := (optimum_broken_iff rising room optimum met mem).mpr ⟨o, eligibleO, below⟩
  have unseen : ∀ h, members h → ¬ W.CoupledInto obs h c :=
    fun h member couples => apart c mem (listed h c member couples)
  ⟨broken,
   fun active => Nat.not_le_of_gt broken.2.2
     (Nat.le_trans fixed.2 (dependent (t + 1) (dep c) active c fixed.1)),
   fun member => unseen (dep c) member (.inl ⟨t, broken.1⟩), unseen⟩

end Web

/-! ## Conservation: the family's rise is the beyond's fall with the loss -/

namespace Flow

variable {ds rest : List C} {t : Nat}

/-- **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
steps from equal totals of the family and the beyond, each gaining nothing on the whole, one
leaves the family's stock at most where the other does exactly where it leaves the beyond's stock
with the loss at least where the other does. -/
theorem Balances.family_le_iff {L L' : Flow F C} {W W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') (gainless : L.GainlessOn (ds ++ rest) t)
    (gainless' : L'.GainlessOn (ds ++ rest) t)
    (start : W.stock ds t + W.stock rest t = W'.stock ds t + W'.stock rest t) :
    W.stock ds (t + 1) ≤ W'.stock ds (t + 1) ↔
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t ≤
        W.stock rest (t + 1) + L.lost (ds ++ rest) t :=
  have same : W.stock ds (t + 1) + (W.stock rest (t + 1) + L.lost (ds ++ rest) t) =
      W'.stock ds (t + 1) + (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t) :=
    (Nat.add_assoc _ _ _).symm.trans ((balances.beyond_falls_exactly gainless).trans
      (start.trans ((balances'.beyond_falls_exactly gainless').symm.trans (Nat.add_assoc _ _ _))))
  have turned : W.stock rest (t + 1) + L.lost (ds ++ rest) t + W.stock ds (t + 1) =
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t + W'.stock ds (t + 1) :=
    (Nat.add_comm _ _).trans (same.trans (Nat.add_comm _ _))
  ⟨fun le => le_of_add_le_add_right (W.stock ds (t + 1))
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq turned.symm)),
   fun le => le_of_add_le_add_right (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t)
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq same))⟩

/-- **The top of the family is the least beyond.** Among moves, each a balanced step from equal
totals gaining nothing on the whole, a move leaves the family's stock at least where every move
does exactly where it leaves the beyond's stock with the loss at most where every move does. -/
theorem top_iff_least {A : Type} {L : A → Flow F C} {W : A → Web F C}
    (balances : ∀ a, (L a).Balances (W a)) (gainless : ∀ a, (L a).GainlessOn (ds ++ rest) t)
    (start : ∀ a b, (W a).stock ds t + (W a).stock rest t = (W b).stock ds t + (W b).stock rest t)
    (a : A) :
    (∀ b, (W b).stock ds (t + 1) ≤ (W a).stock ds (t + 1)) ↔
      ∀ b, (W a).stock rest (t + 1) + (L a).lost (ds ++ rest) t ≤
        (W b).stock rest (t + 1) + (L b).lost (ds ++ rest) t :=
  ⟨fun top b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mp (top b),
   fun least b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mpr (least b)⟩

variable {L : Flow F C} {W : Web F C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F}

/-- **Keeping each dependence, the optimum takes exactly the slack.** Restrict the outcomes to
those keeping every dependence beyond at its need. Where the levels after a balanced step gaining
nothing on the whole are an optimum among them of an order rising with the family, with room among
them, each condition beyond depended on at a need it meets, and each need attained by one of them,
no dependence beyond is broken, and the family's stock after the step, with what the whole loses,
is its stock before with the slack. -/
theorem keeping_optimum_takes_slack (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c)
    (attained : ∀ c, c ∈ rest → ∃ o, (eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) ∧
      o c ≤ W.need t (dep c) c)
    (optimum : Frontier (fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) better
      (W.level (t + 1))) :
    (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
      W.stock ds (t + 1) + L.lost (ds ++ rest) t = W.stock ds t + W.slack dep rest t :=
  have least := Optimum.least_of_room rising room optimum
  have atNeed : ∀ c, c ∈ rest → W.level (t + 1) c = W.need t (dep c) c :=
    fun c mem => match attained c mem with
      | ⟨_, keeping, atMost⟩ =>
        Nat.le_antisymm (Nat.le_trans (least c mem _ keeping) atMost) (optimum.1.2 c mem)
  have beyond : W.stock rest (t + 1) = total rest fun c => W.need t (dep c) c :=
    total_congr_on atNeed
  have exact : W.stock ds (t + 1) + L.lost (ds ++ rest) t + total rest
      (fun c => W.need t (dep c) c) =
      W.stock ds t + W.slack dep rest t + total rest fun c => W.need t (dep c) c :=
    (Nat.add_right_comm _ _ _).trans
      ((congrArg (W.stock ds (t + 1) + · + L.lost (ds ++ rest) t) beyond.symm).trans
        ((balances.beyond_falls_exactly gainless).trans
          ((congrArg (W.stock ds t + ·) (met.stock_eq.trans (Nat.add_comm _ _))).trans
            (Nat.add_assoc _ _ _).symm)))
  ⟨fun c mem broken => Nat.not_le_of_gt broken.2.2 (optimum.1.2 c mem),
   add_right_cancel _ exact⟩

end Flow

/-! ## Witnesses -/

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- Every split of three units between the source and the store. -/
def Split (o : Place → Nat) : Prop :=
  o .source + o .store = 3

/-- The store's stock order. -/
def storeOrder (o' o : Place → Nat) : Prop :=
  total [Place.store] o < total [Place.store] o'

/-- The source three at the start; after the step, everything in the store. -/
def drainedLevel (t : Nat) : Place → Nat
  | .source => Witnesses.profile [3] 0 t
  | .store => Witnesses.profile [0] 3 t

/-- The store's stock order rises with the store. -/
theorem storeOrder_rising : Rising [Place.store] storeOrder :=
  rising_total [Place.store]

/-- The splits are shared units between the source and the store. -/
theorem split_shared : Shared [Place.store] [Place.source] Split :=
  fun o split _ d beyond inside positive =>
    match mem_cons_cases beyond, mem_cons_cases inside with
    | .inr nothing, _ => nomatch nothing
    | _, .inr nothing => nomatch nothing
    | .inl atSource, .inl atStore =>
      Eq.subst (motive := fun x => Split (transfer x d o)) atSource.symm
        (Eq.subst (motive := fun y => Split (transfer Place.source y o)) atStore.symm
          (show o .source - 1 + (o .store + 1) = 3 from
            (Nat.add_left_comm _ _ _).trans
              ((congrArg (o .store + ·) (Naturals.sub_add_cancel
                (Eq.subst (motive := fun x => 0 < o x) atSource positive))).trans
                ((Nat.add_comm _ _).trans split))))

/-- Draining the source into the store is an optimum of the store's order among the splits. -/
theorem drained_optimum : Frontier Split storeOrder ((web drainedLevel).level 1) :=
  ⟨rfl, fun o split above => Nat.not_le_of_gt above
    (show o .store ≤ 3 from Nat.le_trans (Nat.le_add_left (o .store) (o .source)) (Nat.le_of_eq split))⟩

/-- The taker couples into the store alone, whatever the levels. -/
theorem taker_couples_store (level : Nat → Place → Nat) : ∀ h c, h = Formation.taker →
    (web level).CoupledInto gauge h c → c ∈ [Place.store] :=
  fun _ c same => Eq.subst
    (motive := fun x => (web level).CoupledInto gauge x c → c ∈ [Place.store]) same.symm
    fun couples => match couples with
      | .inl ⟨_, requires⟩ => False.elim (requires : False)
      | .inr observes => match c with
        | .source => False.elim (observes : False)
        | .store => .head []

/-- **The optimum drains the source and the dweller ends.** In the splits of three units, the
store's optimum leaves the source below the dweller's need: the dweller's dependence is broken,
the dweller is not active after the step, it is not the taker, and the taker does not couple into
the source; derived from `Web.optimum_ends_beyond`. -/
theorem drained_ends :
    (web drainedLevel).Broken 0 .dweller .source ∧ ¬ (web drainedLevel).active 1 .dweller ∧
      ¬ dwellerOn Place.source = Formation.taker ∧
      ¬ (web drainedLevel).CoupledInto gauge .taker .source :=
  match Web.optimum_ends_beyond (W := web drainedLevel) (ds := [Place.store])
      (rest := [Place.source]) (t := 0) (dep := dwellerOn) (obs := gauge)
      (members := fun h => h = Formation.taker) storeOrder_rising
      (split_shared.room source_apart (.head [])) drained_optimum
      (met_source drainedLevel 0 (Nat.le_succ 2)) (dependent drainedLevel) source_apart
      (taker_couples_store drainedLevel) (.head []) (o := (web drainedLevel).level 1) rfl
      (Nat.zero_lt_succ 1) (fixed_source drainedLevel 0 Place.source (.head [])) with
  | ⟨broken, ended, other, unseen⟩ => ⟨broken, ended, other, unseen .taker rfl⟩

/-- Counting the source after the store: the store's order first, the source among outcomes
alike on the store. -/
def countedAfter (o' o : Place → Nat) : Prop :=
  storeOrder o' o ∨ (o' .store = o .store ∧ o .source < o' .source)

/-- **Counting the beyond after the proxy changes nothing.** Every optimum among the splits of the
order counting the source after the store leaves the source empty. -/
theorem counted_after_drains {o : Place → Nat} (optimum : Frontier Split countedAfter o) :
    o .source = 0 :=
  Nat.le_zero.mp
    (least_of_shared (storeOrder_rising.mono fun _ _ above => .inl above) source_apart
      (.head []) split_shared optimum Place.source (.head []) ((web drainedLevel).level 1) rfl)

/-- Keeping the source at its need, the slack moved to the store. -/
def keptLevel : Place → Nat := WithinSlack.level 1

/-- One unit in each place. -/
def low : Place → Nat
  | .source => 1
  | .store => 1

/-- Two units in the store, none in the source. -/
def high : Place → Nat
  | .source => 0
  | .store => 2

/-- An order satisfied at a store of one: it ranks an outcome reaching one above one that does
not. -/
def satisficing (o' o : Place → Nat) : Prop :=
  1 ≤ o' .store ∧ o .store < 1

/-- **A satisficing order neither drives nor protects.** It is not rising with the store, and
among the splits both the outcome keeping the dweller's need and the outcome draining the source
are its optima. -/
theorem satisficing_either :
    ¬ Rising [Place.store] satisficing ∧ Frontier Split satisficing keptLevel ∧
      Frontier Split satisficing ((web drainedLevel).level 1) ∧
      (web DrawnBeyond.WithinSlack.level).need 0 .dweller .source ≤ keptLevel .source ∧
      (web drainedLevel).level 1 .source < (web drainedLevel).need 0 .dweller .source :=
  ⟨fun rising => Nat.lt_irrefl 1
      (rising low high
        ⟨fun _ mem => (match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun y => low y ≤ high y) same.symm (Nat.le_succ 1)
          | .inr nothing => nomatch nothing),
         .store, .head [], Nat.lt_succ_self 1⟩).2,
   ⟨rfl, fun _ _ above => Nat.lt_irrefl 1 above.2⟩,
   ⟨rfl, fun _ _ above => Nat.not_lt_zero 2 (Nat.lt_of_succ_lt_succ above.2)⟩,
   Nat.le_refl 2, Nat.zero_lt_succ 1⟩

/-- Spilling the source: two outcomes, the source kept or spilled, the store empty in both. -/
def Spilling (o : Place → Nat) : Prop :=
  o = drainedLevel 0 ∨ o = fun _ => 0

/-- **Without room, an optimum need not be at the least level.** Where lowering the source frees
nothing for the store, keeping the source is an optimum of the store's order, and it is not at
the least level beyond. -/
theorem room_needed :
    Frontier Spilling storeOrder (drainedLevel 0) ∧
      ¬ Least [Place.source] Spilling (drainedLevel 0) :=
  ⟨⟨.inl rfl, fun _ spilling above => match spilling with
      | .inl same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)
      | .inr same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)⟩,
   fun least => Nat.not_succ_le_zero 2 (least Place.source (.head []) (fun _ => 0) (.inr rfl))⟩

/-- The outcomes keeping the dweller's need. -/
def Keeping (o : Place → Nat) : Prop :=
  Split o ∧ ∀ c, c ∈ [Place.source] →
    (web WithinSlack.level).need 0 (dwellerOn c) c ≤ o c

/-- Among the splits keeping the need, an outcome standing above another at the source is
exceeded on the store by one. -/
theorem keeping_room : Room [Place.store] [Place.source] Keeping :=
  fun o o' keeping keeping' c mem lower =>
    have atSource : c = Place.source := match mem_cons_cases mem with
      | .inl same => same
      | .inr nothing => nomatch nothing
    have above : 3 ≤ o .source := Nat.lt_of_le_of_lt (keeping'.2 .source (.head []))
      (Eq.subst (motive := fun x => o' x < o x) atSource lower)
    ⟨transfer .source .store o,
     ⟨split_shared o keeping.1 .source .store (.head []) (.head [])
        (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 2) above),
      fun _ listed => Eq.subst (motive := fun y =>
          (web WithinSlack.level).need 0 (dwellerOn y) y ≤ transfer .source .store o y)
        (match mem_cons_cases listed with
          | .inl same => same.symm
          | .inr nothing => nomatch nothing)
        (Nat.sub_le_sub_right above 1)⟩,
     transfer_exceeds (source_apart .source (.head [])) (.head []) o⟩

/-- **Keeping the dweller's need, the optimum takes exactly the slack.** The keeping outcome of
`DrawnBeyond.WithinSlack` is the store's optimum among the splits keeping the need: no dependence
on the source breaks, and the store rises by exactly the slack; derived from
`Flow.keeping_optimum_takes_slack`. -/
theorem kept_takes_slack :
    Frontier Keeping storeOrder ((web WithinSlack.level).level 1) ∧
      (∀ c, c ∈ [Place.source] → ¬ (web WithinSlack.level).Broken 0 (dwellerOn c) c) ∧
      (web WithinSlack.level).stock [Place.store] 1 + diverting.lost ([Place.store] ++ [Place.source]) 0 =
        (web WithinSlack.level).stock [Place.store] 0 +
          (web WithinSlack.level).slack dwellerOn [Place.source] 0 :=
  have optimum : Frontier Keeping storeOrder ((web WithinSlack.level).level 1) :=
    ⟨⟨rfl, fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun y =>
            (web WithinSlack.level).need 0 (dwellerOn y) y ≤ WithinSlack.level 1 y)
            same.symm (Nat.le_refl 2)
        | .inr nothing => nomatch nothing⟩,
     fun o keeping above => Nat.not_le_of_gt above
       (show o .store ≤ 1 from le_of_add_le_add_right 2
         (show o .store + 2 ≤ 1 + 2 from Nat.le_trans
           (Nat.add_le_add_left (keeping.2 .source (.head [])) (o .store))
           (Nat.le_of_eq ((Nat.add_comm _ _).trans keeping.1))))⟩
  ⟨optimum, Flow.keeping_optimum_takes_slack (eligible := Split) WithinSlack.balances
     (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
     (met_source WithinSlack.level 0 (Nat.le_succ 2)) storeOrder_rising keeping_room
     (fun _ mem => match mem_cons_cases mem with
       | .inl same => ⟨(web WithinSlack.level).level 1, optimum.1,
           Eq.subst (motive := fun y => (web WithinSlack.level).level 1 y ≤
             (web WithinSlack.level).need 0 (dwellerOn y) y) same.symm (Nat.le_refl 2)⟩
       | .inr nothing => nomatch nothing)
     optimum⟩

end Drain

end Optimum


/-! ## Room from the exchange

Above, which outcomes are eligible and whether there is room are supplied. Here both are read off
one step of exchange. A part's members take from each condition at most their capacity there,
give only to a listed family and gain nothing on it, and the formations outside the part exchange
as they do; the outcomes open to the part are the levels after every such step that balances.
Room follows, and every optimum stands at each condition beyond at what the rest leaves there,
less the part's capacity there. -/

/-- A quantity one more at one member and the same elsewhere totals one more, over a list in
which that member stands once. -/
theorem total_raise_at {α : Type} {p q : α → Nat} {a : α} (at_a : p a = q a + 1)
    (off : ∀ x, ¬ x = a → p x = q x) :
    ∀ {l : List α}, Distinct l → a ∈ l → total l p = total l q + 1
  | b :: l, ⟨fresh, distinct⟩, mem =>
    match mem_cons_cases mem with
    | .inl same =>
      have rest : total l p = total l q :=
        total_congr_on fun x listed => off x fun xa =>
          fresh (Eq.subst (motive := fun y => y ∈ l) (xa.trans same) listed)
      (congrArg (· + total l p) (Eq.subst (motive := fun y => p y = q y + 1) same at_a)).trans
        ((congrArg (q b + 1 + ·) rest).trans (Nat.add_right_comm (q b) 1 (total l q)))
    | .inr later =>
      (congrArg (· + total l p)
          (off b fun ba => fresh (Eq.subst (motive := fun y => y ∈ l) ba.symm later))).trans
        ((congrArg (q b + ·) (total_raise_at at_a off distinct later)).trans
          (Nat.add_assoc _ _ _).symm)

/-- A total splits into the members outside a part and the members of it. -/
theorem total_split {α : Type} (part : α → Bool) (f : α → Nat) (l : List α) :
    total l f = total l (fun a => bif part a then 0 else f a) +
      total l (fun a => bif part a then f a else 0) :=
  (total_congr (fun a => Bool.casesOn
      (motive := fun b => f a = (bif b then 0 else f a) + (bif b then f a else 0)) (part a)
      (Nat.add_zero (f a)).symm (Nat.zero_add (f a)).symm) l).trans (total_add _ _ l)

/-- Less by some amount is less exactly where the amount and what it is taken from are
positive. -/
theorem sub_lt_self_iff (n k : Nat) : n - k < n ↔ 0 < k ∧ 0 < n :=
  ⟨fun lt => ⟨match k with
      | 0 => absurd lt (Nat.lt_irrefl n)
      | _ + 1 => Nat.succ_pos _,
     Nat.lt_of_le_of_lt (Nat.zero_le _) lt⟩,
   fun ⟨positive, from_⟩ => match n, k, positive, from_ with
     | n + 1, k + 1, _, _ => Nat.lt_of_le_of_lt
         (Nat.le_of_eq (Naturals.succ_sub_succ n k)) (Nat.lt_succ_of_le (Nat.sub_le n k))⟩

namespace Flow

variable (L : Flow F C) (part : F → Bool)

/-- What the formations outside a part take from a condition across the step from `t`. -/
def restTaken (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then 0 else L.take t h c

/-- What the formations outside a part give to a condition across the step from `t`. -/
def restGiven (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then 0 else L.give t h c

/-- A part's capacity at a condition: the most its members taking part may take from it across
the step from `t`. -/
def capacity (cap : F → C → Nat) (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then cap h c else 0

/-- Across the step from `t`, `L'` exchanges as `L` does outside a part, with the same formations
taking part, and each member of the part takes from each condition at most its capacity there,
gives only to the family `cs`, and gives the family no more than it takes from it. -/
def ActsWithin (cap : F → C → Nat) (cs : List C) (t : Nat) (L' : Flow F C) : Prop :=
  L'.present t = L.present t ∧
    (∀ h c, part h = false → L'.take t h c = L.take t h c ∧ L'.give t h c = L.give t h c) ∧
    (∀ h c, part h = true → L'.take t h c ≤ cap h c) ∧
    (∀ h c, part h = true → ¬ c ∈ cs → L'.give t h c = 0) ∧
    ∀ h, part h = true → total cs (L'.give t h) ≤ total cs (L'.take t h)

/-- The outcomes open to a part: the levels after a step within its capacity that balances from
the levels `l`. -/
def Outcome (l : C → Nat) (cap : F → C → Nat) (cs : List C) (t : Nat) (o : C → Nat) : Prop :=
  ∃ L', L.ActsWithin part cap cs t L' ∧ ∀ c, o c + L'.taken t c = l c + L'.given t c

variable {L part}

/-- **The step that happened is open.** Where the step balances and the part acts within its
capacity, the levels after it are an outcome open to the part. -/
theorem Outcome.of_balances {W : Web F C} {cap : F → C → Nat} {cs : List C} {t : Nat}
    (balances : L.Balances W) (acts : L.ActsWithin part cap cs t L) :
    L.Outcome part (W.level t) cap cs t (W.level (t + 1)) :=
  ⟨L, acts, balances t⟩

/-- Where no member taking part may take from a condition, the part's capacity there is
nothing. -/
theorem capacity_eq_zero {cap : F → C → Nat} {t : Nat} {c : C}
    (none : ∀ h, h ∈ L.present t → part h = true → cap h c = 0) :
    L.capacity part cap t c = 0 :=
  (total_congr_on fun h mem => by
    show (bif part h then cap h c else 0) = 0
    cases member : part h
    · rfl
    · exact none h mem member).trans (total_zero (L.present t))

variable {cap : F → C → Nat} {cs : List C} {t : Nat} {L' : Flow F C}

/-- What a step within the part's capacity takes from a condition: what the rest takes, with
what the part's members take. -/
theorem ActsWithin.taken_eq (acts : L.ActsWithin part cap cs t L') (c : C) :
    L'.taken t c = L.restTaken part t c +
      total (L.present t) fun h => bif part h then L'.take t h c else 0 :=
  (congrArg (fun ps => total ps fun h => L'.take t h c) acts.1).trans
    ((total_split part (fun h => L'.take t h c) (L.present t)).trans
      (congrArg (· + _) (total_congr (fun h => by
        show (bif part h then 0 else L'.take t h c) = (bif part h then 0 else L.take t h c)
        cases member : part h
        · exact (acts.2.1 h c member).1
        · rfl) _)))

/-- What a step within the part's capacity gives to a condition: what the rest gives, with what
the part's members give. -/
theorem ActsWithin.given_eq (acts : L.ActsWithin part cap cs t L') (c : C) :
    L'.given t c = L.restGiven part t c +
      total (L.present t) fun h => bif part h then L'.give t h c else 0 :=
  (congrArg (fun ps => total ps fun h => L'.give t h c) acts.1).trans
    ((total_split part (fun h => L'.give t h c) (L.present t)).trans
      (congrArg (· + _) (total_congr (fun h => by
        show (bif part h then 0 else L'.give t h c) = (bif part h then 0 else L.give t h c)
        cases member : part h
        · exact (acts.2.1 h c member).2
        · rfl) _)))

/-- The part's members take from a condition at most the part's capacity there. -/
theorem ActsWithin.part_taken_le (acts : L.ActsWithin part cap cs t L') (c : C) :
    (total (L.present t) fun h => bif part h then L'.take t h c else 0) ≤
      L.capacity part cap t c :=
  total_le _ fun h _ => by
    show (bif part h then L'.take t h c else 0) ≤ (bif part h then cap h c else 0)
    cases member : part h
    · exact Nat.le_refl 0
    · exact acts.2.2.1 h c member

/-- A member of the part is no formation outside it. -/
theorem other_of_out {h : F} (member : part h = true) {g : F} (out : part g = false) : ¬ g = h :=
  fun same => Bool.noConfusion
    ((Eq.subst (motive := fun y => part y = true) same.symm member).symm.trans out)

/-! ### Moving one unit -/

variable [DecidableEq F] [DecidableEq C]

/-- One more unit taken by `h` from `c` and given to `d` across the step from `t`. -/
def moveUnit (L : Flow F C) (t : Nat) (h : F) (c d : C) : Flow F C :=
  ⟨L.present, fun s g x => if s = t ∧ g = h ∧ x = c then L.take s g x + 1 else L.take s g x,
    fun s g x => if s = t ∧ g = h ∧ x = d then L.give s g x + 1 else L.give s g x⟩

/-- One unit `h` gave to `c` across the step from `t` given to `d` instead. -/
def redirect (L : Flow F C) (t : Nat) (h : F) (c d : C) : Flow F C :=
  ⟨L.present, L.take, fun s g x => if s = t ∧ g = h ∧ x = c then L.give s g x - 1
    else if s = t ∧ g = h ∧ x = d then L.give s g x + 1 else L.give s g x⟩

variable {h : F} {c d : C}

theorem moveUnit_take (g : F) (x : C) :
    (L'.moveUnit t h c d).take t g x =
      if g = h ∧ x = c then L'.take t g x + 1 else L'.take t g x := by
  show (if t = t ∧ g = h ∧ x = c then _ else _) = _
  by_cases at_ : g = h ∧ x = c
  · rw [if_pos ⟨rfl, at_⟩, if_pos at_]
  · rw [if_neg fun same => at_ same.2, if_neg at_]

theorem moveUnit_give (g : F) (x : C) :
    (L'.moveUnit t h c d).give t g x =
      if g = h ∧ x = d then L'.give t g x + 1 else L'.give t g x := by
  show (if t = t ∧ g = h ∧ x = d then _ else _) = _
  by_cases at_ : g = h ∧ x = d
  · rw [if_pos ⟨rfl, at_⟩, if_pos at_]
  · rw [if_neg fun same => at_ same.2, if_neg at_]

theorem redirect_give (g : F) (x : C) :
    (L'.redirect t h c d).give t g x =
      if g = h ∧ x = c then L'.give t g x - 1
      else if g = h ∧ x = d then L'.give t g x + 1 else L'.give t g x := by
  show (if t = t ∧ g = h ∧ x = c then _ else if t = t ∧ g = h ∧ x = d then _ else _) = _
  by_cases first : g = h ∧ x = c
  · rw [if_pos ⟨rfl, first⟩, if_pos first]
  · rw [if_neg fun same => first same.2, if_neg first]
    by_cases second : g = h ∧ x = d
    · rw [if_pos ⟨rfl, second⟩, if_pos second]
    · rw [if_neg fun same => second same.2, if_neg second]

/-- The moved unit raises what is taken from `c` by one. -/
theorem moveUnit_taken_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t) :
    (L'.moveUnit t h c d).taken t c = L'.taken t c + 1 :=
  total_raise_at (p := fun g => (L'.moveUnit t h c d).take t g c)
    (q := fun g => L'.take t g c) (a := h)
    ((moveUnit_take h c).trans (if_pos ⟨rfl, rfl⟩))
    (fun g gh => (moveUnit_take g c).trans (if_neg fun same => gh same.1)) distinct mem

theorem moveUnit_taken_off {x : C} (off : ¬ x = c) :
    (L'.moveUnit t h c d).taken t x = L'.taken t x :=
  total_congr (fun g => (moveUnit_take g x).trans (if_neg fun same => off same.2)) _

/-- The moved unit raises what is given to `d` by one. -/
theorem moveUnit_given_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t) :
    (L'.moveUnit t h c d).given t d = L'.given t d + 1 :=
  total_raise_at (p := fun g => (L'.moveUnit t h c d).give t g d)
    (q := fun g => L'.give t g d) (a := h)
    ((moveUnit_give h d).trans (if_pos ⟨rfl, rfl⟩))
    (fun g gh => (moveUnit_give g d).trans (if_neg fun same => gh same.1)) distinct mem

theorem moveUnit_given_off {x : C} (off : ¬ x = d) :
    (L'.moveUnit t h c d).given t x = L'.given t x :=
  total_congr (fun g => (moveUnit_give g x).trans (if_neg fun same => off same.2)) _

/-- The redirected unit lowers what is given to `c` by one. -/
theorem redirect_given_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t)
    (gave : 0 < L'.give t h c) :
    (L'.redirect t h c d).given t c + 1 = L'.given t c :=
  (total_raise_at (p := fun g => L'.give t g c)
    (q := fun g => (L'.redirect t h c d).give t g c) (a := h)
    ((Naturals.sub_add_cancel gave).symm.trans
      (congrArg (· + 1) ((if_pos ⟨rfl, rfl⟩).symm.trans (redirect_give h c).symm)))
    (fun g gh => ((if_neg fun same => gh same.1).trans
        (if_neg fun same => gh same.1)).symm.trans (redirect_give g c).symm)
    distinct mem).symm

/-- The redirected unit raises what is given to `d` by one. -/
theorem redirect_given_to (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t)
    (apart : ¬ c = d) :
    (L'.redirect t h c d).given t d = L'.given t d + 1 :=
  total_raise_at (p := fun g => (L'.redirect t h c d).give t g d)
    (q := fun g => L'.give t g d) (a := h)
    ((redirect_give h d).trans ((if_neg fun same => apart same.2.symm).trans (if_pos ⟨rfl, rfl⟩)))
    (fun g gh => (redirect_give g d).trans ((if_neg fun same => gh same.1).trans
      (if_neg fun same => gh same.1))) distinct mem

theorem redirect_given_off {x : C} (offC : ¬ x = c) (offD : ¬ x = d) :
    (L'.redirect t h c d).given t x = L'.given t x :=
  total_congr (fun g => (redirect_give g x).trans ((if_neg fun same => offC same.2).trans
    (if_neg fun same => offD same.2))) _

/-- **A moved unit balances into a transfer.** Where a step balances from `l` to `o` and `o`
holds a unit at `c`, the step with one more unit taken by a member taking part from `c` and given
to `d` balances from `l` to the transfer of that unit. -/
theorem moveUnit_balances {l o : C → Nat} (distinct : Distinct (L'.present t))
    (mem : h ∈ L'.present t) (apart : ¬ c = d) (positive : 0 < o c)
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x) (x : C) :
    Optimum.transfer c d o x + (L'.moveUnit t h c d).taken t x =
      l x + (L'.moveUnit t h c d).given t x := by
  show (if x = c then o c - 1 else if x = d then o d + 1 else o x) + _ = _
  by_cases xc : x = c
  · subst xc
    rw [if_pos rfl, moveUnit_taken_at distinct mem, moveUnit_given_off apart, ← Nat.add_assoc,
      Nat.add_right_comm, Naturals.sub_add_cancel positive]
    exact balances x
  · rw [if_neg xc, moveUnit_taken_off xc]
    by_cases xd : x = d
    · subst xd
      rw [if_pos rfl, moveUnit_given_at distinct mem, Nat.add_right_comm, balances x,
        Nat.add_assoc]
    · rw [if_neg xd, moveUnit_given_off xd]
      exact balances x

/-- **A redirected unit balances into a transfer.** Where a step balances from `l` to `o`, `o`
holds a unit at `c` and a member taking part gave `c` a unit, the step giving that unit to `d`
instead balances from `l` to the transfer of that unit. -/
theorem redirect_balances {l o : C → Nat} (distinct : Distinct (L'.present t))
    (mem : h ∈ L'.present t) (apart : ¬ c = d) (positive : 0 < o c)
    (gave : 0 < L'.give t h c) (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x)
    (x : C) :
    Optimum.transfer c d o x + (L'.redirect t h c d).taken t x =
      l x + (L'.redirect t h c d).given t x := by
  show (if x = c then o c - 1 else if x = d then o d + 1 else o x) + L'.taken t x = _
  by_cases xc : x = c
  · subst xc
    rw [if_pos rfl]
    apply Naturals.add_right_cancel (k := 1)
    rw [Nat.add_right_comm, Naturals.sub_add_cancel positive, Nat.add_assoc,
      redirect_given_at distinct mem gave]
    exact balances x
  · rw [if_neg xc]
    by_cases xd : x = d
    · subst xd
      rw [if_pos rfl, redirect_given_to distinct mem apart, Nat.add_right_comm, balances x,
        Nat.add_assoc]
    · rw [if_neg xd, redirect_given_off xc xd]
      exact balances x

/-- **A moved unit keeps the step within the part's capacity.** Where a member takes from `c`
less than its capacity, taking one more from `c` and giving it to `d`, both in the family, keeps
the step within the part's capacity. -/
theorem ActsWithin.moveUnit (acts : L.ActsWithin part cap cs t L') (member : part h = true)
    (room : L'.take t h c < cap h c) (distinct : Distinct cs) (inC : c ∈ cs) (inD : d ∈ cs) :
    L.ActsWithin part cap cs t (L'.moveUnit t h c d) := by
  refine ⟨acts.1, fun g x out => ?_, fun g x inside => ?_, fun g x inside outside => ?_,
    fun g inside => ?_⟩
  · rw [moveUnit_take, moveUnit_give, if_neg fun same => other_of_out member out same.1,
      if_neg fun same => other_of_out member out same.1]
    exact acts.2.1 g x out
  · rw [moveUnit_take]
    by_cases at_ : g = h ∧ x = c
    · rw [if_pos at_]
      rcases at_ with ⟨rfl, rfl⟩
      exact room
    · rw [if_neg at_]
      exact acts.2.2.1 g x inside
  · rw [moveUnit_give, if_neg fun same =>
      outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inD)]
    exact acts.2.2.2.1 g x inside outside
  · by_cases gh : g = h
    · subst gh
      have gives : total cs (fun x => (L'.moveUnit t g c d).give t g x) =
          total cs (L'.give t g) + 1 :=
        total_raise_at (a := d) ((moveUnit_give g d).trans (if_pos ⟨rfl, rfl⟩))
          (fun x xd => (moveUnit_give g x).trans (if_neg fun same => xd same.2)) distinct inD
      have takes : total cs (fun x => (L'.moveUnit t g c d).take t g x) =
          total cs (L'.take t g) + 1 :=
        total_raise_at (a := c) ((moveUnit_take g c).trans (if_pos ⟨rfl, rfl⟩))
          (fun x xc => (moveUnit_take g x).trans (if_neg fun same => xc same.2)) distinct inC
      exact Nat.le_trans (Nat.le_of_eq gives) (Nat.le_trans
        (Nat.add_le_add_right (acts.2.2.2.2 g inside) 1) (Nat.le_of_eq takes.symm))
    · exact Nat.le_trans (Nat.le_of_eq (total_congr
          (fun x => (moveUnit_give g x).trans (if_neg fun same => gh same.1)) cs))
        (Nat.le_trans (acts.2.2.2.2 g inside) (Nat.le_of_eq (total_congr
          (fun x => (moveUnit_take g x).trans (if_neg fun same => gh same.1)) cs).symm))

/-- **A redirected unit keeps the step within the part's capacity.** Where a member gives `c` a
unit, giving it to `d` instead, both in the family, keeps the step within the part's
capacity. -/
theorem ActsWithin.redirect (acts : L.ActsWithin part cap cs t L') (member : part h = true)
    (distinct : Distinct cs) (inC : c ∈ cs) (inD : d ∈ cs) (apart : ¬ c = d)
    (gave : 0 < L'.give t h c) :
    L.ActsWithin part cap cs t (L'.redirect t h c d) := by
  refine ⟨acts.1, fun g x out => ?_, fun g x inside => acts.2.2.1 g x inside,
    fun g x inside outside => ?_, fun g inside => ?_⟩
  · refine ⟨(acts.2.1 g x out).1, ?_⟩
    rw [redirect_give, if_neg fun same => other_of_out member out same.1,
      if_neg fun same => other_of_out member out same.1]
    exact (acts.2.1 g x out).2
  · rw [redirect_give, if_neg fun same =>
        outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inC),
      if_neg fun same => outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inD)]
    exact acts.2.2.2.1 g x inside outside
  · show total cs (fun x => (L'.redirect t h c d).give t g x) ≤ total cs (L'.take t g)
    by_cases gh : g = h
    · subst gh
      have raised : total cs (fun x => if x = d then L'.give t g x + 1 else L'.give t g x) =
          total cs (L'.give t g) + 1 :=
        total_raise_at (a := d) (if_pos rfl) (fun x xd => if_neg xd) distinct inD
      have lowered : total cs (fun x => if x = d then L'.give t g x + 1 else L'.give t g x) =
          total cs (fun x => (L'.redirect t g c d).give t g x) + 1 :=
        total_raise_at (a := c)
          ((if_neg (c := c = d) apart).trans ((Naturals.sub_add_cancel gave).symm.trans
            (congrArg (· + 1) ((if_pos (c := g = g ∧ c = c) ⟨rfl, rfl⟩).symm.trans
              (redirect_give g c).symm))))
          (fun x xc => by
            rw [redirect_give, if_neg (c := g = g ∧ x = c) fun same => xc same.2]
            by_cases xd : x = d
            · rw [if_pos (c := x = d) xd, if_pos (c := g = g ∧ x = d) ⟨rfl, xd⟩]
            · rw [if_neg (c := x = d) xd, if_neg (c := g = g ∧ x = d) fun same => xd same.2])
          distinct inC
      exact Nat.le_trans (Nat.le_of_eq (Naturals.add_right_cancel (k := 1)
        (lowered.symm.trans raised))) (acts.2.2.2.2 g inside)
    · exact Nat.le_trans (Nat.le_of_eq (total_congr (fun x => (redirect_give g x).trans
          ((if_neg fun same => gh same.1).trans (if_neg fun same => gh same.1))) cs))
        (acts.2.2.2.2 g inside)

end Flow

namespace Optimum

open Flow

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {t : Nat} {l : C → Nat}
  {ds rest : List C} {better : (C → Nat) → (C → Nat) → Prop}

/-- The outcomes open to a part standing at each condition beyond at least at its floor. -/
def Above (L : Flow F C) (part : F → Bool) (l : C → Nat) (cap : F → C → Nat) (ds rest : List C)
    (t : Nat) (floor : C → Nat) (o : C → Nat) : Prop :=
  L.Outcome part l cap (ds ++ rest) t o ∧ ∀ c, c ∈ rest → floor c ≤ o c

/-- A transfer from a condition beyond above its floor into the family keeps every floor
beyond. -/
theorem transfer_above [DecidableEq C] {floor o : C → Nat} {c d : C}
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) (inside : d ∈ ds) (above : floor c < o c)
    (floors : ∀ x, x ∈ rest → floor x ≤ o x) : ∀ x, x ∈ rest → floor x ≤ transfer c d o x :=
  fun x mem => by
    show floor x ≤ if x = c then o c - 1 else if x = d then o d + 1 else o x
    by_cases xc : x = c
    · subst xc
      rw [if_pos rfl]
      exact Naturals.le_sub_of_add_le (a := 1)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (floor x))) above)
    · rw [if_neg xc, if_neg fun same => apart x mem
        (Eq.subst (motive := fun y => y ∈ ds) same.symm inside)]
      exact floors x mem

/-- **A unit moved or redirected above the floor reaches an outcome exceeding on the family.**
Where an outcome open to the part stands above the floor at a condition beyond, and a member of
the part, taking part, either takes there less than its capacity or gives there something, the
transfer of one unit from that condition into the family is open to the part above every
floor. -/
theorem Above.transfer [DecidableEq F] [DecidableEq C] {floor o : C → Nat} {L' : Flow F C}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {c d : C} (mem : c ∈ rest) (inside : d ∈ ds)
    (acts : L.ActsWithin part cap (ds ++ rest) t L')
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x)
    (floors : ∀ x, x ∈ rest → floor x ≤ o x) (above : floor c < o c) {h : F}
    (present : h ∈ L.present t) (member : part h = true)
    (spare : L'.take t h c < cap h c ∨ 0 < L'.give t h c) :
    Above L part l cap ds rest t floor (transfer c d o) :=
  have cd : ¬ c = d := fun same =>
    apart c mem (Eq.subst (motive := fun y => y ∈ ds) same.symm inside)
  have inC : c ∈ ds ++ rest := ListTests.mem_append_iff.mpr (.inr mem)
  have inD : d ∈ ds ++ rest := ListTests.mem_append_iff.mpr (.inl inside)
  have distinct' : Distinct (L'.present t) := Eq.subst (motive := Distinct) acts.1.symm distinct
  have present' : h ∈ L'.present t := Eq.subst (motive := (h ∈ ·)) acts.1.symm present
  have positive : 0 < o c := Nat.lt_of_le_of_lt (Nat.zero_le _) above
  ⟨match spare with
    | .inl room => ⟨L'.moveUnit t h c d, acts.moveUnit member room cdistinct inC inD,
        moveUnit_balances distinct' present' cd positive balances⟩
    | .inr gave => ⟨L'.redirect t h c d, acts.redirect member cdistinct inC inD cd gave,
        redirect_balances distinct' present' cd positive gave balances⟩,
   transfer_above apart inside above floors⟩

/-- Under two steps within the part's capacity whose totals at a condition differ, some member
taking part differs the same way. -/
theorem member_below {L₁ L₂ : Flow F C} {cs : List C} (acts₁ : L.ActsWithin part cap cs t L₁)
    (acts₂ : L.ActsWithin part cap cs t L₂) {q₁ q₂ : F → Nat}
    (lt : total (L₁.present t) q₁ < total (L₂.present t) q₂)
    (outside : ∀ g, part g = false → q₁ g = q₂ g) :
    ∃ g, g ∈ L.present t ∧ part g = true ∧ q₁ g < q₂ g :=
  match exists_lt_of_total_lt (Nat.lt_of_le_of_lt (Nat.le_of_eq
      (congrArg (total · q₁) acts₁.1.symm)) (Nat.lt_of_lt_of_le lt
        (Nat.le_of_eq (congrArg (total · q₂) acts₂.1)))) with
  | ⟨g, listed, below⟩ => match member : part g with
    | true => ⟨g, listed, member, below⟩
    | false => absurd (Eq.subst (motive := fun y => q₁ g < y) (outside g member).symm below)
        (Nat.lt_irrefl _)

/-- **Room, read off the exchange.** Among the outcomes open to a part above any floors, an
outcome standing above another at a condition beyond is exceeded on the family by an outcome
open to the part: the other's step takes more there through some member, which this step can
also take and give to the family, or gives less there through some member, whose unit this step
can give to the family instead. -/
theorem Above.room [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (floor : C → Nat) :
    Room ds rest (Above L part l cap ds rest t floor) :=
  fun o _ ⟨⟨L₁, acts₁, balances₁⟩, floors⟩ ⟨⟨L₂, acts₂, balances₂⟩, floors'⟩ c mem lower =>
    have above : floor c < o c := Nat.lt_of_le_of_lt (floors' c mem) lower
    ⟨Optimum.transfer c d o,
     match Nat.lt_or_ge (L₁.taken t c) (L₂.taken t c) with
     | .inl more =>
       match member_below acts₁ acts₂ (q₁ := fun g => L₁.take t g c)
           (q₂ := fun g => L₂.take t g c) more
           (fun g out => (acts₁.2.1 g c out).1.trans (acts₂.2.1 g c out).1.symm) with
       | ⟨_, listed, member, below⟩ =>
         Above.transfer distinct cdistinct apart mem inside acts₁ balances₁ floors above listed
           member (.inl (Nat.lt_of_lt_of_le below (acts₂.2.2.1 _ c member)))
     | .inr ge =>
       match member_below acts₂ acts₁ (q₁ := fun g => L₂.give t g c)
           (q₂ := fun g => L₁.give t g c)
           (Naturals.le_of_add_le_add_left (k := l c) (a := L₂.given t c + 1)
             (Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (balances₂ c).symm))
               (Nat.le_trans (Nat.add_lt_add_of_lt_of_le lower ge)
                 (Nat.le_of_eq (balances₁ c)))))
           (fun g out => (acts₂.2.1 g c out).2.trans (acts₁.2.1 g c out).2.symm) with
       | ⟨_, listed, member, below⟩ =>
         Above.transfer distinct cdistinct apart mem inside acts₁ balances₁ floors above listed
           member (.inr (Nat.lt_of_le_of_lt (Nat.zero_le _) below)),
     transfer_exceeds (apart c mem) inside o⟩

/-- **Above its floor, an optimum takes the part's whole capacity and gives nothing there.** Where an
optimum of an order rising with the family, among the outcomes open to the part above the
floors, stands above the floor at a condition beyond, every step reaching it has each member
taking part take its whole capacity there and give nothing there. -/
theorem Above.full [DecidableEq F] [DecidableEq C] {floor o : C → Nat} {L' : Flow F C}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Rising ds better)
    (optimum : Frontier (Above L part l cap ds rest t floor) better o)
    (acts : L.ActsWithin part cap (ds ++ rest) t L')
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x) {c : C} (mem : c ∈ rest)
    (above : floor c < o c) {h : F} (present : h ∈ L.present t) (member : part h = true) :
    L'.take t h c = cap h c ∧ L'.give t h c = 0 :=
  have beaten : (L'.take t h c < cap h c ∨ 0 < L'.give t h c) → False := fun spare =>
    optimum.2 _ (Above.transfer distinct cdistinct apart mem inside acts balances optimum.1.2
      above present member spare) (rising _ _ (transfer_exceeds (apart c mem) inside o))
  ⟨Nat.le_antisymm (acts.2.2.1 h c member) (Nat.ge_of_not_lt fun lt => beaten (.inl lt)),
   match gave : L'.give t h c with
   | 0 => rfl
   | n + 1 => absurd (.inr (Nat.lt_of_lt_of_le (Nat.succ_pos n) (Nat.le_of_eq gave.symm)))
       beaten⟩

/-- **Every optimum stands at its floor or takes the whole capacity.** Where an optimum of an order
rising with the family, among the outcomes open to the part above the floors, stands at a
condition beyond, it stands at its floor there, or there the part takes its whole capacity and
gives nothing: what it leaves, with what the rest takes and the capacity, is the level before
with what the rest gives. -/
theorem Above.floor_or_full [DecidableEq F] [DecidableEq C] {floor o : C → Nat}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Rising ds better)
    (optimum : Frontier (Above L part l cap ds rest t floor) better o) {c : C} (mem : c ∈ rest) :
    o c = floor c ∨
      o c + L.restTaken part t c + L.capacity part cap t c = l c + L.restGiven part t c :=
  match optimum.1, Nat.lt_or_ge (floor c) (o c) with
  | _, .inr atMost => Or.inl (Nat.le_antisymm atMost (optimum.1.2 c mem))
  | ⟨⟨L', acts, balances⟩, _⟩, .inl above => by
    have full := fun h (present : h ∈ L.present t) (member : part h = true) =>
      Above.full distinct cdistinct apart inside rising optimum acts balances mem above
        present member
    have takes : (total (L.present t) fun h => bif part h then L'.take t h c else 0) =
        L.capacity part cap t c :=
      total_congr_on fun h present => by
        show (bif part h then L'.take t h c else 0) = (bif part h then cap h c else 0)
        cases member : part h
        · rfl
        · exact (full h present member).1
    have gives : (total (L.present t) fun h => bif part h then L'.give t h c else 0) = 0 :=
      (total_congr_on fun h present => by
        show (bif part h then L'.give t h c else 0) = 0
        cases member : part h
        · rfl
        · exact (full h present member).2).trans (total_zero (L.present t))
    have taken := acts.taken_eq c
    have given := acts.given_eq c
    rw [takes] at taken
    rw [gives, Nat.add_zero] at given
    refine Or.inr ?_
    rw [Nat.add_assoc, ← taken, ← given]
    exact balances c

/-- An optimum among the outcomes open to the part is an optimum above the floor nothing. -/
theorem above_nothing {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) :
    Frontier (Above L part l cap ds rest t fun _ => 0) better o :=
  ⟨⟨optimum.1, fun _ _ => Nat.zero_le _⟩, fun b eligible => optimum.2 b eligible.1⟩

/-- **Every optimum stands beyond at what the rest leaves less the part's capacity.** Among the
outcomes open to a part, every optimum of every order rising with the family stands at each
condition beyond at the level before, with what the rest gives and less what the rest takes,
less the part's whole capacity there, or at nothing. -/
theorem optimum_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest) :
    o c = l c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c :=
  match Above.floor_or_full distinct cdistinct apart inside rising (above_nothing optimum) mem with
  | .inr full => by
    rw [← full, Naturals.sub_sub, Nat.add_assoc, Naturals.add_sub_cancel]
  | .inl nothing => by
    have nothing : o c = 0 := nothing
    obtain ⟨L', acts, balances⟩ := optimum.1
    have reach : l c + L.restGiven part t c ≤ L.restTaken part t c + L.capacity part cap t c :=
      calc l c + L.restGiven part t c
          ≤ l c + L'.given t c := Nat.add_le_add_left (by
            rw [acts.given_eq c]
            exact Nat.le_add_right _ _) _
        _ = o c + L'.taken t c := (balances c).symm
        _ = L'.taken t c := by rw [nothing, Nat.zero_add]
        _ ≤ L.restTaken part t c + L.capacity part cap t c := by
            rw [acts.taken_eq c]
            exact Nat.add_le_add_left (acts.part_taken_le c) _
    rw [nothing, Naturals.sub_sub, sub_eq_zero_of_le reach]

/-- **No drive where no units are shared.** At a condition beyond from which no member of the
part taking part may take, every optimum among the outcomes open to the part stands where the
rest leaves it. -/
theorem optimum_untouched [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest)
    (none : ∀ h, h ∈ L.present t → part h = true → cap h c = 0) :
    o c = l c + L.restGiven part t c - L.restTaken part t c :=
  (optimum_beyond distinct cdistinct apart inside rising optimum mem).trans
    (congrArg (_ - ·) (capacity_eq_zero none))

/-- **The drain, exactly where units are shared.** Every optimum among the outcomes open to a
part lowers a condition beyond below where the rest leaves it exactly where the part has some
capacity there and the rest leaves something there. -/
theorem optimum_lowers_iff [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest) :
    o c < l c + L.restGiven part t c - L.restTaken part t c ↔
      0 < L.capacity part cap t c ∧ 0 < l c + L.restGiven part t c - L.restTaken part t c :=
  Eq.subst (motive := fun y => y < l c + L.restGiven part t c - L.restTaken part t c ↔
      0 < L.capacity part cap t c ∧ 0 < l c + L.restGiven part t c - L.restTaken part t c)
    (optimum_beyond distinct cdistinct apart inside rising optimum mem).symm
    (sub_lt_self_iff _ _)

end Optimum

namespace Web

open Flow

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {t : Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **An optimum breaks a dependence beyond exactly where its need exceeds what the rest leaves
less the part's capacity.** Where the levels after the step are an optimum, among the outcomes
open to a part, of an order rising with the family, and each condition beyond is depended on at a
need it meets, a dependence beyond is broken across the step exactly where its need exceeds the
level before, with what the rest gives and less what it takes, less the part's capacity there. -/
theorem optimum_broken_iff_capacity [DecidableEq F] [DecidableEq C] {W : Web F C} {dep : C → F}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Optimum.Rising ds better)
    (optimum : Frontier (L.Outcome part (W.level t) cap (ds ++ rest) t) better (W.level (t + 1)))
    (met : W.MetOn dep rest t) {c : C} (mem : c ∈ rest) :
    W.Broken t (dep c) c ↔
      W.level t c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c <
        W.need t (dep c) c :=
  have at_ := Optimum.optimum_beyond distinct cdistinct apart inside rising optimum mem
  ⟨fun broken => Eq.subst (motive := fun y => y < W.need t (dep c) c) at_ broken.2.2,
   fun below => ⟨(met c mem).1, (met c mem).2,
     Eq.subst (motive := fun y => y < W.need t (dep c) c) at_.symm below⟩⟩

end Web

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- Equality of formations is decided. -/
instance : DecidableEq Formation
  | .taker, .taker => isTrue rfl
  | .dweller, .dweller => isTrue rfl
  | .taker, .dweller => isFalse fun same => nomatch same
  | .dweller, .taker => isFalse fun same => nomatch same

/-- The part: the taker. -/
def takerPart : Formation → Bool
  | .taker => true
  | .dweller => false

/-- The taker may take `k` from the source and nothing from the store. -/
def takerCap (k : Nat) : Formation → Place → Nat
  | .taker, .source => k
  | .taker, .store => 0
  | .dweller, _ => 0

/-- The taker takes `k` units of the source and gives them to the store; the dweller exchanges
nothing. -/
def drawing (k : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take _ f c := match f, c with
    | .taker, .source => k
    | .taker, .store => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .taker, .store => k
    | .taker, .source => 0
    | .dweller, _ => 0

/-- Two units at the source and nothing in the store. -/
def before : Place → Nat
  | .source => 2
  | .store => 0

/-- The source less `k`, the store at `k`. -/
def drawnTo (k : Nat) : Place → Nat
  | .source => 2 - k
  | .store => k

/-- The levels: `before` at the start, `drawnTo k` after. -/
def drawnLevel (k : Nat) : Nat → Place → Nat
  | 0 => before
  | _ + 1 => drawnTo k

/-- The taker and the dweller, without repetition. -/
theorem formations_distinct : Distinct [Formation.taker, Formation.dweller] :=
  show ¬ Formation.taker ∈ [Formation.dweller] ∧ (¬ Formation.dweller ∈ ([] : List Formation) ∧ True)
    from ⟨fun mem => (match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

/-- The store and the source, without repetition. -/
theorem store_source_distinct : Distinct ([Place.store] ++ [Place.source]) :=
  show ¬ Place.store ∈ [Place.source] ∧ (¬ Place.source ∈ ([] : List Place) ∧ True) from
  ⟨fun mem => (match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

/-- The taker drawing `k` acts within its capacity `k`. -/
theorem drawing_within (k : Nat) :
    (drawing k).ActsWithin takerPart (takerCap k) ([Place.store] ++ [Place.source]) 0
      (drawing k) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker, .source, _ => Nat.le_refl k
    | .taker, .store, _ => Nat.le_refl 0,
   fun h c _ outside => match h, c with
    | .taker, .store => absurd (.head _) outside
    | .taker, .source => rfl
    | .dweller, _ => rfl,
   fun h member => match h, member with
    | .taker, _ => Nat.le_of_eq ((Nat.add_zero (k + 0)).trans (Nat.add_comm k 0))⟩

/-- **Within capacity `k` of two, the taker's drawing is an optimum of the store's order.**
Every outcome open to the taker leaves the store at most `k`: the taker gives the family no
more than it takes, and takes at most `k`, from the source alone. -/
theorem drawing_optimum {k : Nat} (within : k ≤ 2) :
    Frontier ((drawing k).Outcome takerPart before (takerCap k) ([Place.store] ++ [Place.source]) 0)
      storeOrder (drawnTo k) :=
  ⟨⟨drawing k, drawing_within k, fun c => match c with
      | .source => Naturals.sub_add_cancel within
      | .store => (Nat.add_zero k).trans (Nat.zero_add k).symm⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have store : o .store + L'.taken 0 .store = 0 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 .taker .store + (L'.give 0 .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have conserved : L'.give 0 .taker .store + (L'.give 0 .taker .source + 0) ≤
        L'.take 0 .taker .store + (L'.take 0 .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take 0 .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take 0 .taker .source ≤ k := acts.2.2.1 .taker .source rfl
    have atMost : o .store ≤ k :=
      calc o .store ≤ o .store + L'.taken 0 .store := Nat.le_add_right _ _
        _ = L'.given 0 .store := store.trans (Nat.zero_add _)
        _ = L'.give 0 .taker .store := by rw [gives, dweller]; rfl
        _ ≤ L'.give 0 .taker .store + (L'.give 0 .taker .source + 0) := Nat.le_add_right _ _
        _ ≤ L'.take 0 .taker .store + (L'.take 0 .taker .source + 0) := conserved
        _ ≤ 0 + (k + 0) := Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0)
        _ = k := Nat.zero_add k
    exact Nat.not_le_of_gt above atMost⟩

/-- **The dweller's dependence breaks exactly where the taker shares units with the source.**
Within capacity `k` of two, at the store's optimum the dweller's dependence on the source, at
need two, is broken across the first step exactly where the taker may take something from the
source; derived from `Web.optimum_broken_iff_capacity`. -/
theorem drawing_broken_iff {k : Nat} (within : k ≤ 2) :
    (Diversion.web (drawnLevel k)).Broken 0 .dweller .source ↔ 0 < k :=
  (Web.optimum_broken_iff_capacity (W := Diversion.web (drawnLevel k)) (dep := dwellerOn)
    (ds := [Place.store]) (rest := [Place.source]) formations_distinct store_source_distinct
    source_apart (.head []) storeOrder_rising (drawing_optimum within)
    (met_source (drawnLevel k) 0 (Nat.le_refl 2)) (.head [])).trans
    ((sub_lt_self_iff 2 k).trans ⟨fun both => both.1, fun positive => ⟨positive, by decide⟩⟩)

end Drain

end Optimum

/-! ## Several optimizers at once

Above, one part optimizes and the formations outside it exchange as they do. Here several
formations optimize at once, each alone, by its own order rising with its own family, and each
one's step is an optimum among the outcomes open to it, the others exchanging as they do in the
step that happened: a mutual best response. At a condition beyond every optimizer's family the
levels after the step are then exact: what the formations outside every optimizer leave there,
less the optimizers' joint capacity there, or nothing. -/

namespace Optimum

open Flow

/-- One formation as a part. -/
def alone [DecidableEq F] (h : F) : F → Bool := fun g => decide (g = h)

/-- A formation is the one part it forms alone. -/
theorem alone_self [DecidableEq F] (h : F) : alone h h = true :=
  decide_eq_true rfl

/-- **A mutual best response.** Across the step from `t`, each optimizer taking part acts within
its capacity in `L`, and the levels `o` are an optimum of its order among the outcomes open to it
alone, every other formation exchanging as it does in `L`. -/
def MutualBest [DecidableEq F] (L : Flow F C) (optimizer : F → Bool) (l : C → Nat)
    (cap : F → C → Nat) (ds rest : F → List C) (better : F → (C → Nat) → (C → Nat) → Prop)
    (t : Nat) (o : C → Nat) : Prop :=
  ∀ h, h ∈ L.present t → optimizer h = true →
    L.ActsWithin (alone h) cap (ds h ++ rest h) t L ∧
      Frontier (L.Outcome (alone h) l cap (ds h ++ rest h) t) (better h) o

variable {L : Flow F C} {optimizer : F → Bool} {l : C → Nat} {cap : F → C → Nat}
  {ds rest : F → List C} {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {o : C → Nat}

/-- **Restraint is no mutual best response.** Where something stands at a condition beyond an
optimizer's family after a mutual best response, that optimizer takes its whole capacity there and
gives nothing there. -/
theorem MutualBest.full [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {h : F}
    (present : h ∈ L.present t) (opt : optimizer h = true) {c : C} (mem : c ∈ rest h)
    (positive : 0 < o c) : L.take t h c = cap h c ∧ L.give t h c = 0 :=
  (inside h opt).elim fun _ there =>
    Above.full distinct (cdistinct h opt) (apart h opt) there (rising h opt)
      (above_nothing (best h present opt).2) (best h present opt).1 balances mem positive
      present (alone_self h)

/-- **Several optimizers beyond, exactly.** After a mutual best response, at a condition beyond
every optimizer's family, the levels stand at the level before, with what the formations outside
every optimizer give and less what they take, less the optimizers' joint capacity there, or at
nothing. Where nothing stands, balance and capacity alone give it; where something stands, every
optimizer takes its whole capacity there and gives nothing. -/
theorem mutual_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c = l c + L.restGiven optimizer t c - L.restTaken optimizer t c -
      L.capacity optimizer cap t c :=
  have taken := total_split optimizer (fun h => L.take t h c) (L.present t)
  have given := total_split optimizer (fun h => L.give t h c) (L.present t)
  match Nat.eq_zero_or_pos (o c) with
  | .inl nothing => by
    have within : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) ≤
        L.capacity optimizer cap t c :=
      total_le _ fun h present => by
        show (bif optimizer h then L.take t h c else 0) ≤ (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · exact Nat.le_refl 0
        · exact (best h present opt).1.2.2.1 h c (alone_self h)
    have reach : l c + L.restGiven optimizer t c ≤
        L.restTaken optimizer t c + L.capacity optimizer cap t c :=
      calc l c + L.restGiven optimizer t c
          ≤ l c + L.given t c := Nat.add_le_add_left (by
            rw [show L.given t c = _ from given]
            exact Nat.le_add_right _ _) _
        _ = o c + L.taken t c := (balances c).symm
        _ = L.taken t c := by rw [nothing, Nat.zero_add]
        _ ≤ L.restTaken optimizer t c + L.capacity optimizer cap t c := by
            rw [show L.taken t c = _ from taken]
            exact Nat.add_le_add_left within _
    rw [nothing, Naturals.sub_sub, sub_eq_zero_of_le reach]
  | .inr positive => by
    have takes : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) =
        L.capacity optimizer cap t c :=
      total_congr_on fun h present => by
        show (bif optimizer h then L.take t h c else 0) = (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).1
    have gives : (total (L.present t) fun h => bif optimizer h then L.give t h c else 0) = 0 :=
      (total_congr_on fun h present => by
        show (bif optimizer h then L.give t h c else 0) = 0
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).2).trans (total_zero (L.present t))
    have full : o c + L.restTaken optimizer t c + L.capacity optimizer cap t c =
        l c + L.restGiven optimizer t c := by
      have step := balances c
      rw [show L.taken t c = _ from taken, show L.given t c = _ from given, takes, gives,
        Nat.add_zero, ← Nat.add_assoc] at step
      exact step
    rw [← full, Naturals.sub_sub, Nat.add_assoc, Naturals.add_sub_cancel]

/-- **Several optimizers leave the beyond where one with their joint capacity would.** At a
condition beyond every optimizer's family, the levels after a mutual best response stand where
every optimum of one part made of all the optimizers, of any order rising with any family apart
from that condition, would leave them. -/
theorem mutual_as_one [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    {dsJ restJ : List C} (cdistinctJ : Distinct (dsJ ++ restJ))
    (apartJ : ∀ c, c ∈ restJ → ¬ c ∈ dsJ) {dJ : C} (insideJ : dJ ∈ dsJ)
    {betterJ : (C → Nat) → (C → Nat) → Prop} (risingJ : Rising dsJ betterJ) {o' : C → Nat}
    (optimum : Frontier (L.Outcome optimizer l cap (dsJ ++ restJ) t) betterJ o')
    (memJ : c ∈ restJ) : o c = o' c :=
  (mutual_beyond distinct cdistinct apart inside rising best balances beyond).trans
    (optimum_beyond distinct cdistinctJ apartJ insideJ risingJ optimum memJ).symm

/-- **Lowered exactly where the optimizers can take.** After a mutual best response, a condition
beyond every optimizer's family stands below where the formations outside every optimizer leave it
exactly where the optimizers have some capacity there and something is left there. -/
theorem mutual_lowers_iff [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c :=
  Eq.subst (motive := fun y => y < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c)
    (mutual_beyond distinct cdistinct apart inside rising best balances beyond).symm
    (sub_lt_self_iff _ _)

end Optimum

namespace Web

open Flow Optimum

/-- **Several optimizers break a dependence beyond exactly where its need exceeds what the rest
leaves less their joint capacity.** Where the levels after the step are a mutual best response and
a condition beyond every optimizer's family is depended on at a need it meets, the dependence is
broken across the step exactly where its need exceeds the level before, with what the formations
outside every optimizer give and less what they take, less the optimizers' joint capacity. -/
theorem mutual_broken_iff_capacity [DecidableEq F] [DecidableEq C] {W : Web F C} {L : Flow F C}
    {optimizer : F → Bool} {cap : F → C → Nat} {ds rest : F → List C}
    {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {g : F} {c : C}
    (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer (W.level t) cap ds rest better t (W.level (t + 1)))
    (balances : ∀ x, W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    (depends : W.requires t g c) (meets : W.need t g c ≤ W.level t c) :
    W.Broken t g c ↔
      W.level t c + L.restGiven optimizer t c - L.restTaken optimizer t c -
        L.capacity optimizer cap t c < W.need t g c :=
  have at_ := mutual_beyond distinct cdistinct apart inside rising best balances beyond
  ⟨fun broken => Eq.subst (motive := fun y => y < W.need t g c) at_ broken.2.2,
   fun below => ⟨depends, meets, Eq.subst (motive := fun y => y < W.need t g c) at_.symm below⟩⟩

end Web

namespace Optimum

namespace TwoTakers

open Diversion

/-- Two takers and a dweller. -/
inductive Member where
  | taker (which : Bool)
  | dweller

/-- Equality of members is decided. -/
instance : DecidableEq Member
  | .taker true, .taker true => isTrue rfl
  | .taker false, .taker false => isTrue rfl
  | .taker true, .taker false => isFalse fun same => nomatch same
  | .taker false, .taker true => isFalse fun same => nomatch same
  | .dweller, .dweller => isTrue rfl
  | .taker _, .dweller => isFalse fun same => nomatch same
  | .dweller, .taker _ => isFalse fun same => nomatch same

/-- The optimizers: the two takers. -/
def takers : Member → Bool
  | .taker _ => true
  | .dweller => false

/-- Each taker may take one unit of the source and nothing of the store; the dweller nothing. -/
def capOf : Member → Place → Nat
  | .taker _, .source => 1
  | .taker _, .store => 0
  | .dweller, _ => 0

/-- What each taker gives: one unit to the store. -/
def giveOf : Member → Place → Nat
  | .taker _, .store => 1
  | .taker _, .source => 0
  | .dweller, _ => 0

/-- Both takers take one unit of the source and give it to the store. -/
def joint : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ := capOf
  give _ := giveOf

/-- The second taker takes and gives as in `joint`; the first takes nothing. -/
def restrained : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f with
    | .taker true => 0
    | .taker false => capOf (.taker false) c
    | .dweller => 0
  give _ f c := match f with
    | .taker true => 0
    | .taker false => giveOf (.taker false) c
    | .dweller => 0

/-- After both takers draw: the source empty, the store at two. -/
def drained : Place → Nat
  | .source => 0
  | .store => 2

/-- After the second alone draws: one unit in each. -/
def kept : Place → Nat
  | .source => 1
  | .store => 1

/-- The members, without repetition. -/
theorem members_distinct :
    Distinct [Member.taker true, Member.taker false, Member.dweller] :=
  show ¬ Member.taker true ∈ [Member.taker false, Member.dweller] ∧
      (¬ Member.taker false ∈ [Member.dweller] ∧ (¬ Member.dweller ∈ ([] : List Member) ∧ True))
    from ⟨fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => match mem_cons_cases mem with
        | .inl same => nomatch same
        | .inr mem => nomatch mem),
     fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => nomatch mem),
     fun mem => (nomatch mem), trivial⟩

/-- Each taker acts within its capacity in `joint`. -/
theorem joint_within (w : Bool) :
    joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 joint :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩, fun _ _ _ => Nat.le_refl _,
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun g member => match g, member with
    | .taker _, _ => Nat.le_refl 1
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- `joint` balances from `Drain.before` into `drained`. -/
theorem joint_balances : ∀ x, drained x + joint.taken 0 x = Drain.before x + joint.given 0 x
  | .source => rfl
  | .store => rfl

/-- Under a step within a taker's capacity, it gives the store at most one unit. -/
theorem gives_at_most_one {w : Bool} {L' : Flow Member Place}
    (acts : joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 L') :
    L'.give 0 (.taker w) .store ≤ 1 :=
  have conserved : L'.give 0 (.taker w) .store + (L'.give 0 (.taker w) .source + 0) ≤
      L'.take 0 (.taker w) .store + (L'.take 0 (.taker w) .source + 0) :=
    acts.2.2.2.2 (.taker w) (alone_self _)
  have fromStore : L'.take 0 (.taker w) .store ≤ 0 := acts.2.2.1 (.taker w) .store (alone_self _)
  have fromSource : L'.take 0 (.taker w) .source ≤ 1 :=
    acts.2.2.1 (.taker w) .source (alone_self _)
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved
    (Nat.le_trans (Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0))
      (Nat.le_refl 1)))

/-- **Each taker's draw is an optimum of the store's order, given the other's.** Every outcome open
to one taker alone, the other taking and giving as in `joint`, leaves the store at most two. -/
theorem joint_optimum (w : Bool) :
    Frontier (joint.Outcome (alone (Member.taker w)) Drain.before capOf
      ([Place.store] ++ [Place.source]) 0) Drain.storeOrder drained :=
  ⟨⟨joint, joint_within w, joint_balances⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have store : o .store + L'.taken 0 .store = 0 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 (.taker true) .store +
        (L'.give 0 (.taker false) .store + (L'.give 0 .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have atMost : L'.given 0 .store ≤ 2 := by
      rw [gives, dweller]
      cases w with
      | true =>
        rw [(acts.2.1 (.taker false) .store rfl).2]
        exact Nat.add_le_add_right (gives_at_most_one acts) _
      | false =>
        rw [(acts.2.1 (.taker true) .store rfl).2]
        exact Nat.add_le_add_left (Nat.add_le_add_right (gives_at_most_one acts) _) _
    exact Nat.not_le_of_gt above (Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_trans (Nat.le_of_eq (store.trans (Nat.zero_add _))) atMost))⟩

/-- **Both takers drawing is a mutual best response.** -/
theorem joint_best :
    MutualBest joint takers Drain.before capOf (fun _ => [Place.store]) (fun _ => [Place.source])
      (fun _ => Drain.storeOrder) 0 drained :=
  fun h _ opt => match h, opt with
    | .taker w, _ => ⟨joint_within w, joint_optimum w⟩

/-- The hypotheses on the takers' lists and orders. -/
theorem lists :
    (∀ h, takers h = true → Distinct ([Place.store] ++ [Place.source])) ∧
      (∀ h, takers h = true → ∀ c, c ∈ [Place.source] → ¬ c ∈ [Place.store]) ∧
      (∀ h, takers h = true → ∃ d, d ∈ [Place.store]) ∧
      (∀ h, takers h = true → Rising [Place.store] Drain.storeOrder) :=
  ⟨fun _ _ => Drain.store_source_distinct, fun _ _ => DrawnBeyond.source_apart,
   fun _ _ => ⟨_, .head []⟩, fun _ _ => Drain.storeOrder_rising⟩

/-- **The source falls by the takers' joint capacity, to nothing.** Derived from `mutual_beyond`:
the source stood at two, the dweller neither gives nor takes there, and the takers' joint capacity
there is two. -/
theorem joint_drains : drained .source = Drain.before .source - joint.capacity takers capOf 0 .source ∧
    joint.capacity takers capOf 0 .source = 2 :=
  ⟨mutual_beyond (ds := fun _ => [Place.store]) (rest := fun _ => [Place.source])
    members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2 joint_best joint_balances
    (fun _ _ _ => .head []), rfl⟩

/-- **Each take is within the slack of a need of one; together they fall below it.** Each taker
takes one unit, leaving the source at the need of one or above were it alone, and the mutual best
response leaves the source below that need. -/
theorem within_slack_jointly_below :
    (∀ w, joint.take 0 (.taker w) .source + 1 ≤ Drain.before .source) ∧ drained .source < 1 :=
  ⟨fun _ => Nat.le_refl 2, Nat.succ_pos 0⟩

/-- `restrained` balances from `Drain.before` into `kept`. -/
theorem restrained_balances :
    ∀ x, kept x + restrained.taken 0 x = Drain.before x + restrained.given 0 x
  | .source => rfl
  | .store => rfl

/-- **One taker's restraint is no mutual best response.** Where the first taker takes nothing and
the second draws, a unit stands at the source, so the first does not take its whole capacity there:
whatever the orders, families and listings, the step is no mutual best response. -/
theorem restrained_not_mutual :
    ¬ MutualBest restrained takers Drain.before capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => Drain.storeOrder) 0 kept := fun best =>
  absurd (MutualBest.full (L := restrained) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best restrained_balances (h := .taker true) (.head _) rfl (.head [])
    (Nat.succ_pos 0)).1 fun same => nomatch same

end TwoTakers

end Optimum

/-! ## A course of steps

Above, one step. Here a part chooses again at every step of a course: at each, the levels after
are an optimum of its order among the outcomes open to it from the levels before, the formations
outside it exchanging as they do in that step. At a condition beyond, each step's level is read off
the one before by the law of one step: the level with what the rest gives, less what the rest takes
and the part's capacity, or nothing. Where what the rest gives there is at most `r` a step,
however low the level, a draw above `r` brings it below any positive need `m` once the steps
exceed its starting excess over `m`, and for good, and a dependence at that need is lost; where it
renews by exactly `r` while it stands at the need, a draw of `k` keeps it there exactly where
`k ≤ r`. Over `n` steps no course draws more than the starting level with `r` for each step. What
the renewal does below the need decides only what is drawn: where it stops below the need (a
gate), a draw above the renewal draws at most the starting level with `r` for each of its units,
however long the course; where at least one is given at every step, however low the level, the
draw has no bound, everything given drawn and the dependence lost all the same. A draw of
`k ≤ r` draws `k` at every step. -/

namespace Optimum

/-! ### Levels renewed and drawn

A level `x` along a course, `g t` given to it and `d t` taken from it at the step from `t`, each
step taking at most what stands with what is given: `x (t + 1) = x t + g t - d t`. -/

section Levels

variable {x g d : Nat → Nat} {r m : Nat}

/-- Less the same amount keeps the order (as `Nat.sub_le_sub_right`, with an empty axiom
report). -/
theorem sub_le_sub_right_of_le {n k : Nat} (le : n ≤ k) : ∀ a, n - a ≤ k - a
  | 0 => le
  | a + 1 => Nat.pred_le_pred (sub_le_sub_right_of_le le a)

/-- Less more is at most less less (as `Nat.sub_le_sub_left`, with an empty axiom report). -/
theorem sub_le_sub_left_of_le {a b : Nat} (le : a ≤ b) (n : Nat) : n - b ≤ n - a :=
  match le_dest le with
  | ⟨j, same⟩ => Eq.subst (motive := fun y => n - y ≤ n - a) same.symm
      (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub n a j).symm) (Nat.sub_le (n - a) j))

/-- **Above the renewal, the level never rises.** Where at most `r` is given and more than `r`
taken at a step, the level after is at most the level before. -/
theorem never_rises (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) : x (t + 1) ≤ x t := by
  rw [step t]
  exact Nat.le_trans (sub_le_sub_left_of_le (Nat.le_trans renews (Nat.le_of_lt over)) _)
    (Nat.le_of_eq (Naturals.add_sub_cancel _ _))

/-- **Above the renewal, below the need the level stays below.** Where at most `r` is given and
more than `r` taken at every step, a level below the need at one step is below it at every later
step, whatever is given below the need. -/
theorem level_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m
  | 0 => below
  | j + 1 => Nat.lt_of_le_of_lt (never_rises step (renews (s + j)) (over (s + j)))
      (level_stays_below step renews over below j)

/-- Above the renewal, the level stays within its start. -/
theorem level_le_start (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) : ∀ t, x t ≤ x 0
  | 0 => Nat.le_refl _
  | t + 1 => Nat.le_trans (never_rises step (renews t) (over t)) (level_le_start step renews over t)

/-- **Above the renewal, a positive level falls.** Where at most `r` is given and more than `r`
taken at a step, a positive level falls by at least one across it. -/
theorem falls_over (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) (positive : 0 < x t) : x (t + 1) + 1 ≤ x t :=
  calc x (t + 1) + 1 = x t + g t - d t + 1 := by rw [step t]
    _ ≤ x t + r - (r + 1) + 1 :=
        Nat.add_le_add_right (Nat.le_trans (sub_le_sub_right_of_le (Nat.add_le_add_left renews _) _)
          (sub_le_sub_left_of_le over _)) 1
    _ = x t := by
        rw [← Naturals.sub_sub, Naturals.add_sub_cancel,
          Naturals.sub_add_cancel (c := 1) positive]

/-- **Above the renewal, the level falls below any need, within its starting excess over it.**
Where at every step at most `r` is given, however low the level, and more than `r` is taken, the
level stands below a positive need `m` at every step `t` with `x 0 < m + t`, so at every step from
`x 0` on. -/
theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) (needs : 0 < m) :
    ∀ t, x 0 < m + t → x t < m :=
  have falling : ∀ t, x t = 0 ∨ x t + t ≤ x 0 := fun t => by
    induction t with
    | zero => exact .inr (Nat.le_refl _)
    | succ t ih =>
      match Nat.eq_zero_or_pos (x t) with
      | .inl gone => exact .inl (Nat.eq_zero_of_le_zero
          (Nat.le_trans (never_rises step (renews t) (over t)) (Nat.le_of_eq gone)))
      | .inr positive =>
        match ih with
        | .inl gone => exact (absurd (Eq.subst (motive := fun y => 0 < y) gone positive)
            (Nat.lt_irrefl 0))
        | .inr fell =>
          exact .inr (calc x (t + 1) + (t + 1) = x (t + 1) + 1 + t :=
                (Nat.add_assoc _ _ _).symm.trans (Nat.add_right_comm _ _ _)
            _ ≤ x t + t := Nat.add_le_add_right (falls_over step (renews t) (over t) positive) t
            _ ≤ x 0 := fell)
  fun t within => match falling t with
    | .inl gone => Nat.lt_of_le_of_lt (Nat.le_of_eq gone) needs
    | .inr fell => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt fell within)

/-- **Within the renewal, the level stays at the need and never falls.** Where exactly `r` is
given while the level stands at the need or above and at most `r` is taken at every step, a level
starting at the need stands at it or above at every step and does not fall across any. -/
theorem kept_at_need (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renewing : ∀ t, m ≤ x t → g t = r) (within : ∀ t, d t ≤ r) (start : m ≤ x 0) :
    ∀ t, m ≤ x t ∧ x t ≤ x (t + 1) :=
  have rises : ∀ t, m ≤ x t → x t ≤ x (t + 1) := fun t atNeed => by
    rw [step t, renewing t atNeed]
    exact Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_cancel _ _).symm)
      (sub_le_sub_left_of_le (within t) _)
  have stands : ∀ t, m ≤ x t := fun t => by
    induction t with
    | zero => exact start
    | succ t ih => exact Nat.le_trans ih (rises t ih)
  fun t => ⟨stands t, rises t (stands t)⟩

/-- What is given at a step is at most `r` where it is `r` at the need or above and nothing
below. -/
theorem renews_of (renewing : ∀ t, m ≤ x t → g t = r)
    (unsupported : ∀ t, x t < m → g t = 0) (t : Nat) : g t ≤ r :=
  match Nat.lt_or_ge (x t) m with
  | .inl below => Nat.le_trans (Nat.le_of_eq (unsupported t below)) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (renewing t atNeed)

/-- **Kept exactly within the renewal.** Where exactly `r` is given while the level stands at a
positive need `m` or above, at most `r` below it, and `k` is taken at every step, a level starting
at the need stands at it at every step exactly where `k ≤ r`. -/
theorem kept_iff_within (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (start : m ≤ x 0) :
    (∀ t, m ≤ x t) ↔ k ≤ r :=
  ⟨fun kept => match Nat.lt_or_ge r k with
    | .inl over => absurd (kept (x 0)) (Nat.not_le_of_gt (ends_within step renews
        (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs (x 0)
        (Nat.lt_add_of_pos_left needs)))
    | .inr within => within,
   fun within t => (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start t).1⟩

/-- What the step from `t` takes from a level `x` given `g`: the level with what is given, less
what stands after. -/
def drawnAt (x g : Nat → Nat) (t : Nat) : Nat := x t + g t - x (t + 1)

/-- **What stands and what was drawn.** Across `n` steps, what stands after with everything drawn
is the starting level with everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n
  | 0 => rfl
  | n + 1 => by
    show x (n + 1) + (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g (0 + n)) =
      x 0 + (Amounts.whole.sum g 0 n + g (0 + n))
    rw [Nat.zero_add]
    have back : x (n + 1) + drawnAt x g n = x n + g n :=
      Naturals.add_sub_of_le (show x (n + 1) ≤ x n + g n by rw [step n]; exact Nat.sub_le _ _)
    rw [Nat.add_left_comm, back, ← Nat.add_assoc, Nat.add_comm (Amounts.whole.sum _ 0 n) (x n),
      level_add_drawn step n, Nat.add_assoc]

/-- A sum of at most `r` at each step is at most `r` for each step. -/
theorem sum_le_mul (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * n
  | 0 => Nat.zero_le _
  | n + 1 => Nat.le_trans
      (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)))
      (Nat.le_trans (Nat.add_le_add (sum_le_mul renews n) (renews n))
        (Nat.le_of_eq (Nat.mul_succ r n).symm))

/-- Where at most `r` is given at each step and nothing from `N` on, the sum over any number of
steps is at most `r` for each step before `N`. -/
theorem sum_le_mul_until {N : Nat} (renews : ∀ t, g t ≤ r)
    (after : ∀ t, N ≤ t → g t = 0) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * N
  | 0 => Nat.zero_le _
  | n + 1 => match Nat.lt_or_ge n N with
    | .inl before => Nat.le_trans (sum_le_mul renews (n + 1)) (Nat.mul_le_mul_left r before)
    | .inr later => Nat.le_trans (Nat.le_of_eq ((congrArg (Amounts.whole.sum g 0 n + g ·)
        (Nat.zero_add n)).trans ((congrArg (_ + ·) (after n later)).trans (Nat.add_zero _))))
        (sum_le_mul_until renews after n)

/-- **No course draws more than its start and the renewal.** Where at most `r` is given at each
step, everything drawn across `n` steps is at most the starting level with `r` for each step. -/
theorem drawn_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (n : Nat) : Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * n :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul renews n) _))

/-- **Gated, above the renewal a course draws a bounded amount, however long.** Where at most `r`
is given at each step, nothing while the level stands below a positive need (the gate), and more
than `r` is taken at each step, everything drawn across any number of steps is at most the
starting level with `r` for each of its units. -/
theorem ended_drawn_le (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * x 0 :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul_until (N := x 0) renews (fun t later => unsupported t
      (ends_within step renews over needs t
        (Nat.lt_of_le_of_lt later (Nat.lt_add_of_pos_left needs)))) n) _))

/-- A sum of at least `a` at each step is at least `a` for each step. -/
theorem mul_le_sum {a : Nat} (gives : ∀ t, a ≤ g t) : ∀ n, a * n ≤ Amounts.whole.sum g 0 n
  | 0 => Nat.le_trans (Nat.le_of_eq (Nat.mul_zero a)) (Nat.zero_le _)
  | n + 1 => Nat.le_trans (Nat.le_of_eq (Nat.mul_succ a n))
      (Nat.le_trans (Nat.add_le_add (mul_le_sum gives n) (gives n))
        (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)).symm))

/-- **Where the level ends no higher than it started, everything given was drawn.** -/
theorem given_le_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {n : Nat} (within : x n ≤ x 0) :
    Amounts.whole.sum g 0 n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Naturals.le_of_add_le_add_left (k := x 0)
    (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n).symm) (Nat.add_le_add_right within _))

/-- **Above the renewal, everything given is drawn.** Where at least `a` and at most `r` is given at
every step, however low the level, and more than `r` is taken, everything drawn across `n` steps is
at least `a` for each step: with `a = r`, as much as a level kept at its need by a draw of `r`
yields (`kept_drawn`). -/
theorem drawn_at_least (step : ∀ t, x (t + 1) = x t + g t - d t) {a : Nat} (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, a ≤ g t) (over : ∀ t, r < d t) (n : Nat) :
    a * n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Nat.le_trans (mul_le_sum gives n) (given_le_drawn step (level_le_start step renews over n))

/-- **Ungated, above the renewal the draw has no bound.** Where at least one and at most `r` is
given at every step, however low the level, and more than `r` is taken, everything drawn has no
bound, at least one a step, while the level falls below any positive need all the same
(`ends_within`). -/
theorem drawn_unbounded (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, 0 < g t) (over : ∀ t, r < d t) :
    ¬ ∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B :=
  fun ⟨B, bounded⟩ => Nat.not_succ_le_self B
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (drawn_at_least step renews gives over (B + 1)) (bounded _)))

/-- A level less what is left of it after `k` is taken is `k`, where `k` is within it. -/
theorem sub_sub_of_le {a k : Nat} (within : k ≤ a) : a - (a - k) = k :=
  (congrArg (· - (a - k)) (Naturals.add_sub_of_le within).symm).trans
    (Naturals.add_sub_cancel k (a - k))

/-- **Within the renewal, a course draws its whole take at every step.** Where exactly `r` is
given while the level stands at the need or above and `k ≤ r` is taken at every step, a level
starting at the need has `k` drawn at every step: `k` for each step of the course. -/
theorem kept_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (draws : ∀ t, d t = k) (within : k ≤ r)
    (start : m ≤ x 0) : ∀ n, Amounts.whole.sum (drawnAt x g) 0 n = k * n
  | 0 => rfl
  | n + 1 =>
    have atNeed := (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start n).1
    have each : drawnAt x g n = k := by
      show x n + g n - x (n + 1) = k
      rw [step n, renewing n atNeed, draws n]
      exact sub_sub_of_le (Nat.le_trans within (Nat.le_add_left r (x n)))
    (congrArg (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g ·) (Nat.zero_add n)).trans
      ((congrArg (· + drawnAt x g n) (kept_drawn step renewing draws within start n)).trans
        ((congrArg (k * n + ·) each).trans (Nat.mul_succ k n).symm))

/-- **Gated, over a long enough course keeping draws more.** Of two levels from the same kind of
renewal, `r` a step at a positive need and nothing below, one drawn above `r` at every step and one
drawn `r` at every step from a start at the need: over `n` steps with `x 0 + r * x 0 < r * n`, the
second has had more drawn from it. -/
theorem keeping_draws_more {x' g' d' : Nat → Nat} (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renews : ∀ t, g t ≤ r) (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t)
    (needs : 0 < m) (step' : ∀ t, x' (t + 1) = x' t + g' t - d' t)
    (renewing' : ∀ t, m ≤ x' t → g' t = r) (draws' : ∀ t, d' t = r) (start' : m ≤ x' 0)
    {n : Nat} (long : x 0 + r * x 0 < r * n) :
    Amounts.whole.sum (drawnAt x g) 0 n < Amounts.whole.sum (drawnAt x' g') 0 n :=
  Nat.lt_of_le_of_lt (ended_drawn_le step renews unsupported over needs n)
    (Nat.lt_of_lt_of_le long (Nat.le_of_eq
      (kept_drawn step' renewing' draws' (Nat.le_refl r) start' n).symm))

/-- **Gated, the draw is bounded exactly above the renewal.** Where exactly `r` is given while the
level stands at a positive need or above, nothing below it, and `k > 0` is taken at every step, a
level starting at the need has a bound on everything ever drawn from it exactly where `r < k`. -/
theorem drawn_bounded_iff (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (unsupported : ∀ t, x t < m → g t = 0)
    (draws : ∀ t, d t = k) (positive : 0 < k) (needs : 0 < m) (start : m ≤ x 0) :
    (∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B) ↔ r < k :=
  ⟨fun ⟨B, bounded⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (bounded (B + 1)) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le
        (Nat.lt_succ_self B) (Nat.le_trans (Nat.le_of_eq (Nat.one_mul (B + 1)).symm)
          (Nat.le_trans (Nat.mul_le_mul_right (B + 1) positive)
            (Nat.le_of_eq (kept_drawn step renewing draws within start (B + 1)).symm))))),
   fun over => ⟨x 0 + r * x 0, ended_drawn_le step (renews_of renewing unsupported) unsupported
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs⟩⟩

/-- Where a decided property holds at `0` and fails at `n`, it holds at some step before `n` and
fails at the next. -/
theorem last_before {P : Nat → Prop} [DecidablePred P] (first : P 0) :
    ∀ {n : Nat}, ¬ P n → ∃ T, T < n ∧ P T ∧ ¬ P (T + 1)
  | 0, fails => absurd first fails
  | n + 1, fails =>
    if holds : P n then ⟨n, Nat.lt_succ_self n, holds, fails⟩
    else match last_before first holds with
      | ⟨T, lt, at_, next⟩ => ⟨T, Nat.lt_succ_of_lt lt, at_, next⟩

end Levels

open Flow

/-- **A course of re-optimizing steps.** At every step, the levels after are an optimum of the
part's order among the outcomes open to it from the levels before, the formations outside it
exchanging as they do in that step. -/
def Reoptimizes (L : Flow F C) (W : Web F C) (part : F → Bool) (cap : F → C → Nat)
    (ds rest : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ t, Frontier (L.Outcome part (W.level t) cap (ds ++ rest) t) better (W.level (t + 1))

variable {L : Flow F C} {W : Web F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **Each step of the course read off the one before.** Over a course of re-optimizing steps, at
a condition beyond, the level after each step is the level before with what the rest gives, less
what the rest takes and the part's capacity, or nothing. -/
theorem course_beyond [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    {c : C} (mem : c ∈ rest) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven part t c -
      (L.restTaken part t c + L.capacity part cap t c) :=
  (optimum_beyond (distinct t) cdistinct apart inside rising (course t) mem).trans
    (Naturals.sub_sub _ _ _)

/-- **Several optimizers along a course.** Where every step of a balanced course is a mutual best
response, at a condition beyond every optimizer's family the level after each step is the level
before with what the formations outside every optimizer give, less what they take and the
optimizers' joint capacity, or nothing. -/
theorem mutual_course_beyond [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W) {c : C}
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven optimizer t c -
      (L.restTaken optimizer t c + L.capacity optimizer cap t c) :=
  (mutual_beyond (distinct t) cdistinct apart inside rising (best t) (balances t)
    (beyond t)).trans (Naturals.sub_sub _ _ _)

end Optimum

namespace Flow

/-- **A renewal needs support.** Where whatever gives to `c` across the step from `t` is
supported there (`Flow.GiversSupported`, as where only active formations give and activity needs
support) and every formation outside a part giving to `c` depends on `c` at a need of at least
`m`, nothing outside the part gives to `c` across a step from a level below `m`: the gate on which
`Flow.stays_below` turns, for the formations outside a part. -/
theorem restGiven_unsupported {L : Flow F C} {W : Web F C} {part : F → Bool} {t : Nat} {c : C}
    {m : Nat} (givers : L.GiversSupported W t c)
    (gated : ∀ h, h ∈ L.present t → part h = false → 0 < L.give t h c →
      W.requires t h c ∧ m ≤ W.need t h c)
    (below : W.level t c < m) : L.restGiven part t c = 0 :=
  (total_congr_on fun h present => by
    show (bif part h then 0 else L.give t h c) = 0
    cases out : part h
    · show L.give t h c = 0
      match zero : L.give t h c with
      | 0 => rfl
      | n + 1 =>
        have positive : 0 < L.give t h c :=
          Eq.subst (motive := fun y => 0 < y) zero.symm (Nat.succ_pos n)
        exact absurd (Nat.le_trans (gated h present out positive).2
            (givers h present positive c (gated h present out positive).1))
          (Nat.not_le_of_gt below)
    · rfl).trans (total_zero _)

end Flow

namespace Web

open Flow Optimum

variable {W : Web F C} {c : C} {f : F} {r m : Nat}

/-- **Above the renewal, a dependence on the condition is lost.** Where a condition's level is
given at most `r` at each step, however low it stands, more than `r` is taken at each step, and a
formation depends on it at a positive need `m` throughout, starting met, the dependence is broken
at some step and never met again. -/
theorem lost_over {g d : Nat → Nat} (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) : W.Lost c :=
  have ended := ends_within (x := fun t => W.level t c) step renews over needs
  match last_before (P := fun t => m ≤ W.level t c) start (n := W.level 0 c)
      (Nat.not_le_of_gt (ended _ (Nat.lt_add_of_pos_left needs))) with
  | ⟨T, _, met, fails⟩ =>
    have next : W.level (T + 1) c < m := Nat.gt_of_not_le fails
    ⟨f, T, ⟨depends T, Nat.le_trans (Nat.le_of_eq (need T)) met,
        Nat.lt_of_lt_of_le next (Nat.le_of_eq (need T).symm)⟩,
     fun _ later => match le_dest later with
      | ⟨j, same⟩ => Eq.subst (motive := fun y => W.level y c < W.need T f c) same.symm
          (Nat.lt_of_lt_of_le
            (level_stays_below (x := fun t => W.level t c) step renews over next j)
            (Nat.le_of_eq (need T).symm))⟩

/-- **Lost exactly above the renewal.** Where a condition's level is given exactly `r` while it
stands at a positive need `m` or above, at most `r` below it, `k` is taken at every step, and a
formation depends on it at that need throughout, starting met, the dependence is lost exactly where
`r < k`; where `k ≤ r` the level does not fall across any step. -/
theorem lost_iff {g d : Nat → Nat} {k : Nat}
    (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renewing : ∀ t, m ≤ W.level t c → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (depends : ∀ t, W.requires t f c)
    (need : ∀ t, W.need t f c = m) (start : m ≤ W.level 0 c) : W.Lost c ↔ r < k :=
  ⟨fun ⟨_, T, broken, _⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (Nat.lt_of_lt_of_le broken.2.2 broken.2.1)
        (Nat.not_lt_of_ge (kept_at_need (x := fun t => W.level t c) step renewing
          (fun t => Nat.le_trans (Nat.le_of_eq (draws t)) within) start T).2),
   fun over => lost_over step renews
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs depends need start⟩

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **A re-optimizing course loses a dependence beyond exactly where its draw exceeds the
renewal.** Over a course of re-optimizing steps, at a condition beyond that the rest renews by
exactly `r` while it stands at a positive need `m`, by at most `r` below, with what the rest takes
and the part's capacity there `k` at every step, and a formation depending on it at `m` throughout,
starting met, the dependence is lost exactly where `r < k`. -/
theorem course_lost_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ↔ r < k :=
  lost_iff (course_beyond distinct cdistinct apart inside rising course mem) renewing renews
    draws needs depends need start

/-- **A re-optimizing course keeps a condition beyond at its need exactly within the renewal.**
Over a course of re-optimizing steps, at a condition beyond that the rest renews by exactly `r`
while it stands at a positive need `m`, by at most `r` below, with what the rest takes and the
part's capacity there `k` at every step, from a start at the need, the condition stands at the need
at every step exactly where `k ≤ r`. -/
theorem course_kept_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (start : m ≤ W.level 0 c) : (∀ t, m ≤ W.level t c) ↔ k ≤ r :=
  kept_iff_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renewing renews draws
    needs start

/-- **No re-optimizing course draws more than its start and the renewal.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step, everything
drawn there across `n` steps (the level with what the rest gives, less what stands after) is at
most the starting level with `r` for each step. -/
theorem course_drawn_within [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * n :=
  drawn_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews n

/-- **Gated, a re-optimizing course above the renewal draws a bounded amount.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step and nothing while
it stands below a positive need `m`, with what the rest takes and the part's capacity there above
`r` at every step, everything ever drawn there is at most the starting level with `r` for each of
its units. -/
theorem course_ended_drawn [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (unsupported : ∀ t, W.level t c < m → L.restGiven part t c = 0)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * W.level 0 c :=
  ended_drawn_le (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews unsupported over
    needs n

/-- **Ungated, a re-optimizing course above the renewal loses the dependence and draws without
bound.** Over a course of re-optimizing steps, at a condition beyond that the rest gives at least
`a` and at most `r` at every step, however low it stands, with what the rest takes and the part's
capacity there above `r` at every step, a dependence on it at a positive need `m` throughout,
starting met, is lost, while everything drawn there across `n` steps is at least `a` for each step
and, for a positive `a`, has no bound: where the dependence is lost, the gate is what bounds the
draw. -/
theorem course_drawn_unbounded [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    {a : Nat} (renews : ∀ t, L.restGiven part t c ≤ r) (gives : ∀ t, a ≤ L.restGiven part t c)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ∧ (∀ n, a * n ≤
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n) ∧
      (0 < a → ¬ ∃ B, ∀ n,
        Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤ B) :=
  have step := course_beyond distinct cdistinct apart inside rising course mem
  ⟨lost_over step renews over needs depends need start,
   drawn_at_least (x := fun t => W.level t c) step renews gives over,
   fun positive => drawn_unbounded (x := fun t => W.level t c) step renews
     (fun t => Nat.lt_of_lt_of_le positive (gives t)) over⟩

/-- **Several optimizers each within the renewal can lose it together.** Where every step of a
balanced course is a mutual best response, a condition beyond every optimizer's family is given by
the formations outside them at most `r` a step, however low it stands, what those formations take
with the optimizers' joint capacity there exceeds `r` at every step, and a formation depends on it
at a positive need `m` throughout, starting met, the dependence is lost, however small each
optimizer's own capacity. -/
theorem mutual_course_lost [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W)
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h)
    (renews : ∀ t, L.restGiven optimizer t c ≤ r)
    (over : ∀ t, r < L.restTaken optimizer t c + L.capacity optimizer cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c :=
  lost_over (mutual_course_beyond distinct cdistinct apart inside rising best balances beyond)
    renews over needs depends need start

end Web

namespace Optimum

namespace Renewing

open Diversion DrawnBeyond Drain

/-- What the dweller gives the source across a step from level `s`: `r` where the source meets its
need of two, nothing below. -/
def renewal (r s : Nat) : Nat := if 2 ≤ s then r else 0

/-- The source along the course from `s₀`: each step adds the renewal and the taker takes `k`, or
all there is. -/
def source (k r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => source k r s₀ t + renewal r (source k r s₀ t) - k

/-- What the dweller gives the source at each step of the course. -/
def renewed (k r s₀ : Nat) (t : Nat) : Nat := renewal r (source k r s₀ t)

/-- What the taker takes from the source at the step from `t`. -/
def draw (k r s₀ : Nat) : Nat → Nat := drawnAt (source k r s₀) (renewed k r s₀)

/-- The store along the course: everything the taker has drawn. -/
def store (k r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store k r s₀ t + draw k r s₀ t

/-- The levels along the course. -/
def level (k r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => source k r s₀ t
  | .store => store k r s₀ t

/-- At each step the taker takes what it draws from the source and gives it to the store; the
dweller gives the source the renewal. -/
def course (k r s₀ : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw k r s₀ t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw k r s₀ t
    | .taker, .source => 0
    | .dweller, .source => renewed k r s₀ t
    | .dweller, .store => 0

variable {k r s₀ : Nat}

/-- What the step leaves is within the level with the renewal. -/
theorem source_within (t : Nat) :
    source k r s₀ (t + 1) ≤ source k r s₀ t + renewed k r s₀ t :=
  Nat.sub_le _ _

/-- The renewal is `r` where the source stands at its need. -/
theorem renewed_at {t : Nat} (atNeed : 2 ≤ source k r s₀ t) : renewed k r s₀ t = r :=
  if_pos atNeed

/-- Nothing is renewed where the source stands below its need. -/
theorem renewed_below {t : Nat} (below : source k r s₀ t < 2) : renewed k r s₀ t = 0 :=
  if_neg (Nat.not_le_of_gt below)

/-- The renewal is at most `r`. -/
theorem renewal_le (r s : Nat) : renewal r s ≤ r :=
  match Nat.lt_or_ge s 2 with
  | .inl below => Nat.le_trans (Nat.le_of_eq (if_neg (Nat.not_le_of_gt below))) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (if_pos atNeed)

/-- What the taker draws at a step is at most `k`. -/
theorem draw_le (t : Nat) : draw k r s₀ t ≤ k :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans (Nat.sub_le _ _) (Nat.le_of_lt below)
  | .inr within => Nat.le_of_eq (sub_sub_of_le within)

/-- At most `k`, and at most the level with the renewal, is at most what the taker draws. -/
theorem le_draw {a : Nat} (t : Nat) (atMostK : a ≤ k)
    (atMostLevel : a ≤ source k r s₀ t + renewed k r s₀ t) : a ≤ draw k r s₀ t :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans atMostLevel (Nat.le_of_eq (show source k r s₀ t +
      renewed k r s₀ t = source k r s₀ t + renewed k r s₀ t -
        (source k r s₀ t + renewed k r s₀ t - k) by
      rw [sub_eq_zero_of_le (Nat.le_of_lt below), Nat.sub_zero]))
  | .inr within => Nat.le_trans atMostK (Nat.le_of_eq (sub_sub_of_le within).symm)

/-- The course balances: the source loses what the taker draws and gains the renewal; the store
gains what the taker draws. -/
theorem course_balances : (course k r s₀).Balances (web (level k r s₀)) := fun t c =>
  match c with
  | .source => show source k r s₀ (t + 1) + (draw k r s₀ t + 0) =
      source k r s₀ t + (0 + (renewed k r s₀ t + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (source_within t)
  | .store => show store k r s₀ (t + 1) + (0 + 0) = store k r s₀ t + (draw k r s₀ t + 0) from
    rfl

/-- The taker acts within its capacity `k` at every step. -/
theorem course_within (t : Nat) :
    (course k r s₀).ActsWithin takerPart (takerCap k) ([Place.store] ++ [Place.source]) t
      (course k r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker, .source, _ => draw_le t
    | .taker, .store, _ => Nat.le_refl 0,
   fun h c member outside => match h, c, member with
    | .taker, .store, _ => absurd (.head _) outside
    | .taker, .source, _ => rfl,
   fun h member => match h, member with
    | .taker, _ => show draw k r s₀ t + (0 + 0) ≤ 0 + (draw k r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm⟩

/-- **At every step, the taker's draw is an optimum of the store's order.** Every outcome open to
the taker leaves the store at most where its draw does: it gives the store no more than it takes,
takes at most `k`, from the source alone, and at most what stands there with the renewal. -/
theorem course_optimum (t : Nat) :
    Frontier ((course k r s₀).Outcome takerPart (level k r s₀ t) (takerCap k)
      ([Place.store] ++ [Place.source]) t) storeOrder (level k r s₀ (t + 1)) :=
  ⟨⟨course k r s₀, course_within t, course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = store k r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = source k r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t .taker .store + (L'.give t .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t .taker .source + (L'.take t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source =
        L'.give t .taker .source + (L'.give t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    have dwellerStore : L'.give t .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have dwellerTake : L'.take t .dweller .source = 0 := (acts.2.1 .dweller .source rfl).1
    have dwellerGive : L'.give t .dweller .source = renewed k r s₀ t :=
      (acts.2.1 .dweller .source rfl).2
    have conserved : L'.give t .taker .store + (L'.give t .taker .source + 0) ≤
        L'.take t .taker .store + (L'.take t .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take t .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take t .taker .source ≤ k := acts.2.2.1 .taker .source rfl
    rw [dwellerStore] at gives
    rw [dwellerTake] at takes
    rw [dwellerGive] at renews
    have gives : L'.given t .store = L'.give t .taker .store := gives
    have takes : L'.taken t .source = L'.take t .taker .source := takes
    have renews : L'.given t .source = L'.give t .taker .source + renewed k r s₀ t := renews
    have conserved : L'.give t .taker .store + L'.give t .taker .source ≤
        L'.take t .taker .store + L'.take t .taker .source := conserved
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t .taker .source ≤
        source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source :=
      calc L'.take t .taker .source ≤ o .source + L'.take t .taker .source := Nat.le_add_left _ _
        _ = source k r s₀ t + (L'.give t .taker .source + renewed k r s₀ t) := src
        _ = source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source := by
            rw [Nat.add_comm (L'.give t .taker .source), Nat.add_assoc]
    have atMostLevel : L'.give t .taker .store ≤ source k r s₀ t + renewed k r s₀ t :=
      Naturals.le_of_add_le_add_right (Nat.le_trans conserved toSource)
    have atMostK : L'.give t .taker .store ≤ k :=
      Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource)
    have atMost : o .store ≤ store k r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = store k r s₀ t + L'.give t .taker .store := by rw [atStore, gives]
        _ ≤ store k r s₀ t + draw k r s₀ t :=
            Nat.add_le_add_left (le_draw t atMostK atMostLevel) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The taker re-optimizes at every step of the course.** -/
theorem course_reoptimizes :
    Reoptimizes (course k r s₀) (web (level k r s₀)) takerPart (takerCap k) [Place.store]
      [Place.source] storeOrder :=
  course_optimum

/-- **Each step of the source read off the one before, by the law of the course.** Derived from
`Optimum.course_beyond`. -/
theorem source_beyond (t : Nat) :
    (web (level k r s₀)).level (t + 1) .source = (web (level k r s₀)).level t .source +
      (course k r s₀).restGiven takerPart t .source -
        ((course k r s₀).restTaken takerPart t .source +
          (course k r s₀).capacity takerPart (takerCap k) t .source) :=
  course_beyond (fun _ => formations_distinct) store_source_distinct source_apart (.head [])
    storeOrder_rising course_reoptimizes (.head []) t

/-- What the dweller gives the source is the renewal. -/
theorem restGiven_source (t : Nat) :
    (course k r s₀).restGiven takerPart t .source = renewed k r s₀ t :=
  show 0 + (renewed k r s₀ t + 0) = renewed k r s₀ t from Nat.zero_add _

/-- Nothing outside the taker takes from the source, and the taker's capacity there is `k`. -/
theorem draws_source (t : Nat) :
    (course k r s₀).restTaken takerPart t .source +
      (course k r s₀).capacity takerPart (takerCap k) t .source = k :=
  show 0 + (0 + 0) + (k + (0 + 0)) = k from Nat.zero_add k

/-- The renewal is `r` where the source stands at its need of two. -/
theorem renewing_source (t : Nat) (atNeed : 2 ≤ (web (level k r s₀)).level t .source) :
    (course k r s₀).restGiven takerPart t .source = r :=
  (restGiven_source t).trans (renewed_at atNeed)

/-- Nothing is renewed where the source stands below its need. -/
theorem unsupported_source (t : Nat) (below : (web (level k r s₀)).level t .source < 2) :
    (course k r s₀).restGiven takerPart t .source = 0 :=
  (restGiven_source t).trans (renewed_below below)

/-- **The dweller's dependence is lost exactly where the taker's capacity exceeds the renewal.**
From a source at its need of two or above, at every step of the course the store's optimum, the
dweller's dependence on the source is lost exactly where `r < k`; derived from
`Web.course_lost_iff`. -/
theorem lost_iff (start : 2 ≤ s₀) : (web (level k r s₀)).Lost .source ↔ r < k :=
  Web.course_lost_iff (f := Formation.dweller) (fun _ => formations_distinct) store_source_distinct
    source_apart (.head []) storeOrder_rising course_reoptimizes (.head []) renewing_source
    (fun t => Nat.le_trans (Nat.le_of_eq (restGiven_source t)) (renewal_le r _)) draws_source
    (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- The store holds everything drawn. -/
theorem store_eq_sum : ∀ n, store k r s₀ n = Amounts.whole.sum (draw k r s₀) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + draw k r s₀ n) (store_eq_sum n)).trans
      (congrArg (Amounts.whole.sum (draw k r s₀) 0 n + draw k r s₀ ·) (Nat.zero_add n).symm)

/-- **Above the renewal, the store stays bounded however long the course.** -/
theorem store_bounded (over : r < k) (n : Nat) :
    (web (level k r s₀)).level n .store ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (store_eq_sum n)) (ended_drawn_le (x := source k r s₀) (m := 2)
    (g := renewed k r s₀) (d := fun _ => k) (fun _ => rfl) (renews_of (x := source k r s₀)
      (g := renewed k r s₀) (fun _ atNeed => renewed_at atNeed)
      (fun _ below => renewed_below below))
    (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) n)

/-- **Within the renewal, the store gains `k` at every step.** -/
theorem store_kept (start : 2 ≤ s₀) (within : k ≤ r) (n : Nat) :
    (web (level k r s₀)).level n .store = k * n :=
  (store_eq_sum n).trans (kept_drawn (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) within
    start n)

/-- **Re-optimizing the store with more capacity than the renewal leaves less in the store.** From
a source at its need, the taker of capacity `r < k`, choosing the store's optimum at every step,
holds less in the store after `n` steps with `s₀ + r * s₀ < r * n` than a taker of capacity `r`
does, choosing the same way. -/
theorem keeping_holds_more (start : 2 ≤ s₀) (over : r < k) {n : Nat}
    (long : s₀ + r * s₀ < r * n) :
    (web (level k r s₀)).level n .store < (web (level r r s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (store_eq_sum n))
    (Nat.lt_of_lt_of_le (keeping_draws_more (x := source k r s₀) (m := 2) (g := renewed k r s₀)
      (d := fun _ => k) (x' := source r r s₀) (g' := renewed r r s₀) (d' := fun _ => r)
      (fun _ => rfl) (renews_of (x := source k r s₀) (g := renewed k r s₀)
        (fun _ atNeed => renewed_at atNeed) (fun _ below => renewed_below below))
      (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) (fun _ => rfl)
      (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) start long)
      (Nat.le_of_eq (store_eq_sum n).symm))

/-- **The store is bounded exactly where the capacity exceeds the renewal.** From a source at its
need, with `0 < k`, the store has a bound over every course length exactly where `r < k`. -/
theorem store_bounded_iff (start : 2 ≤ s₀) (positive : 0 < k) :
    (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔ r < k :=
  have sums : (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔
      ∃ B, ∀ n, Amounts.whole.sum (drawnAt (source k r s₀) (renewed k r s₀)) 0 n ≤ B :=
    ⟨fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n).symm)
        (bounded n)⟩,
     fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n))
        (bounded n)⟩⟩
  sums.trans (drawn_bounded_iff (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed)
    (fun _ below => renewed_below below) (fun _ => rfl) positive (Nat.succ_pos 1) start)

/-! ### Two takers along a course

Two takers, each of capacity one at the source, each ordering by the store, and the dweller
renewing the source by `r` while it stands at its need of two. At every step both drawing what
there is is a mutual best response. With `r < 2` the joint capacity exceeds the renewal and the
dweller's dependence is lost, though with `r = 1` either taker alone would keep it; the store stays
bounded, while the course in which one taker restrains, none of whose steps is a mutual best
response, gains a unit at every step. -/

section Pair

open TwoTakers

/-- One unit where something stands: the amount less what is left after one. -/
def takeOne (a : Nat) : Nat := a - (a - 1)

/-- At most one unit. -/
theorem takeOne_le_one : ∀ a, takeOne a ≤ 1
  | 0 => Nat.zero_le 1
  | n + 1 => Nat.le_of_eq (succ_sub_self n)

/-- What is left after one unit: the amount less one. -/
theorem sub_takeOne : ∀ a, a - takeOne a = a - 1
  | 0 => rfl
  | n + 1 => congrArg (n + 1 - ·) (succ_sub_self n)

/-- One unit and what is left make the amount. -/
theorem takeOne_split (a : Nat) : takeOne a + (a - 1) = a :=
  (congrArg (takeOne a + ·) (sub_takeOne a).symm).trans
    (Naturals.add_sub_of_le (Nat.sub_le a (a - 1)))

/-- At most one, and at most the amount, is at most one unit of it. -/
theorem le_takeOne {x : Nat} : ∀ {a : Nat}, x ≤ 1 → x ≤ a → x ≤ takeOne a
  | 0, _, within => within
  | n + 1, one, _ => Nat.le_trans one (Nat.le_of_eq (succ_sub_self n).symm)

/-- The source along the two takers' course from `s₀`: each step adds the renewal and the two take
one unit each, or what there is. -/
def jointSource (r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => jointSource r s₀ t + renewal r (jointSource r s₀ t) - 2

/-- What stands at the source with the renewal across the step from `t`. -/
def avail (r s₀ t : Nat) : Nat := jointSource r s₀ t + renewal r (jointSource r s₀ t)

/-- The first taker takes one unit where one stands with the renewal. -/
def first (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t)

/-- The second takes one unit where one is left. -/
def second (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t - 1)

/-- The store along the course: everything the two have drawn. -/
def jointStore (r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => jointStore r s₀ t + (first r s₀ t + second r s₀ t)

/-- The levels along the two takers' course. -/
def jointLevel (r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => jointSource r s₀ t
  | .store => jointStore r s₀ t

/-- Each taker takes its unit from the source and gives it to the store; the dweller gives the
source the renewal. -/
def jointCourse (r s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take t f c := match f, c with
    | .taker true, .source => first r s₀ t
    | .taker false, .source => second r s₀ t
    | .taker _, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker true, .store => first r s₀ t
    | .taker false, .store => second r s₀ t
    | .taker _, .source => 0
    | .dweller, .source => renewal r (jointSource r s₀ t)
    | .dweller, .store => 0

/-- The dweller requires the source at need two and is active exactly while it stands so; the
takers require nothing, are active throughout and draw on the source. -/
def jointWeb (level : Nat → Place → Nat) : Web Member Place where
  level := level
  active t f := match f with
    | .taker _ => True
    | .dweller => 2 ≤ level t .source
  requires _ f c := match f, c with
    | .dweller, .source => True
    | .dweller, .store => False
    | .taker _, _ => False
  need _ _ _ := 2
  draws _ f c := match f, c with
    | .taker _, .source => True
    | .taker _, .store => False
    | .dweller, _ => False

variable {r s₀ : Nat}

/-- What the two draw and what stands after make what stood with the renewal. -/
theorem joint_split (t : Nat) :
    jointSource r s₀ (t + 1) + (first r s₀ t + second r s₀ t) = avail r s₀ t :=
  have rest : second r s₀ t + jointSource r s₀ (t + 1) = avail r s₀ t - 1 :=
    (congrArg (takeOne (avail r s₀ t - 1) + ·)
      (Naturals.sub_sub (avail r s₀ t) 1 1)).symm.trans
      (takeOne_split (avail r s₀ t - 1))
  (Nat.add_comm _ _).trans ((Nat.add_assoc _ _ _).trans
    ((congrArg (first r s₀ t + ·) rest).trans (takeOne_split (avail r s₀ t))))

/-- The two takers' course balances. -/
theorem joint_course_balances : (jointCourse r s₀).Balances (jointWeb (jointLevel r s₀)) :=
  fun t c => match c with
  | .source => show jointSource r s₀ (t + 1) + (first r s₀ t + (second r s₀ t + 0)) =
      jointSource r s₀ t + (0 + (0 + (renewal r (jointSource r s₀ t) + 0))) by
    rw [Nat.add_zero (second r s₀ t), Nat.add_zero (renewal r (jointSource r s₀ t)),
      Nat.zero_add (0 + renewal r (jointSource r s₀ t)),
      Nat.zero_add (renewal r (jointSource r s₀ t))]
    exact joint_split t
  | .store => show jointStore r s₀ (t + 1) + (0 + (0 + 0)) =
      jointStore r s₀ t + (first r s₀ t + (second r s₀ t + 0)) from rfl

/-- Each taker acts within its capacity of one in the two takers' course. -/
theorem joint_course_within (w : Bool) (t : Nat) :
    (jointCourse r s₀).ActsWithin (alone (Member.taker w)) capOf
      ([Place.store] ++ [Place.source]) t (jointCourse r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker true, .source, _ => takeOne_le_one _
    | .taker false, .source, _ => takeOne_le_one _
    | .taker true, .store, _ => Nat.le_refl 0
    | .taker false, .store, _ => Nat.le_refl 0
    | .dweller, _, member => absurd (of_decide_eq_true member) fun same => (nomatch same),
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun h member => match h, member with
    | .taker true, _ => show first r s₀ t + (0 + 0) ≤ 0 + (first r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .taker false, _ => show second r s₀ t + (0 + 0) ≤ 0 + (second r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- **The first taker's draw is an optimum of the store's order, given the second's.** Every
outcome open to the first taker alone leaves the store at most where the course does: it gives the
store at most one unit, and with the second's draw at most what stands with the renewal. -/
theorem first_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker true)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within true t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker false) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker false) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker false) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = L'.give t (.taker true) .store + second r s₀ t := gives
    have takes : L'.taken t .source = L'.take t (.taker true) .source + second r s₀ t := takes
    have renews : L'.given t .source =
        L'.give t (.taker true) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (congrArg (L'.give t (.taker true) .source + ·)
        (Nat.zero_add (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker true) .store + L'.give t (.taker true) .source ≤
        L'.take t (.taker true) .store + L'.take t (.taker true) .source :=
      acts.2.2.2.2 (.taker true) (alone_self _)
    have fromStore : L'.take t (.taker true) .store ≤ 0 :=
      acts.2.2.1 (.taker true) .store (alone_self _)
    have fromSource : L'.take t (.taker true) .source ≤ 1 :=
      acts.2.2.1 (.taker true) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t (.taker true) .source + second r s₀ t ≤
        avail r s₀ t + L'.give t (.taker true) .source :=
      calc L'.take t (.taker true) .source + second r s₀ t
          ≤ o .source + (L'.take t (.taker true) .source + second r s₀ t) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker true) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker true) .source := by
            rw [Nat.add_comm (L'.give t (.taker true) .source), ← Nat.add_assoc]; rfl
    have withSecond : L'.give t (.taker true) .store + second r s₀ t ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker true) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
          (Nat.le_trans (Nat.add_le_add_right conserved _) toSource))
    have atMostFirst : L'.give t (.taker true) .store ≤ first r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Nat.le_add_right _ _) withSecond)
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (L'.give t (.taker true) .store + second r s₀ t) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_right atMostFirst _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The second taker's draw is an optimum of the store's order, given the first's.** -/
theorem second_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker false)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within false t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker true) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker true) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker true) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = first r s₀ t + L'.give t (.taker false) .store := gives
    have takes : L'.taken t .source = first r s₀ t + L'.take t (.taker false) .source := takes
    have renews : L'.given t .source =
        L'.give t (.taker false) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (Nat.zero_add (L'.give t (.taker false) .source +
        (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker false) .store + L'.give t (.taker false) .source ≤
        L'.take t (.taker false) .store + L'.take t (.taker false) .source :=
      acts.2.2.2.2 (.taker false) (alone_self _)
    have fromStore : L'.take t (.taker false) .store ≤ 0 :=
      acts.2.2.1 (.taker false) .store (alone_self _)
    have fromSource : L'.take t (.taker false) .source ≤ 1 :=
      acts.2.2.1 (.taker false) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : first r s₀ t + L'.take t (.taker false) .source ≤
        avail r s₀ t + L'.give t (.taker false) .source :=
      calc first r s₀ t + L'.take t (.taker false) .source
          ≤ o .source + (first r s₀ t + L'.take t (.taker false) .source) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker false) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker false) .source := by
            rw [Nat.add_comm (L'.give t (.taker false) .source), ← Nat.add_assoc]; rfl
    have withFirst : first r s₀ t + L'.give t (.taker false) .store ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker false) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _))
          (Nat.le_trans (Nat.add_le_add_left conserved _) toSource))
    have atMostSecond : L'.give t (.taker false) .store ≤ second r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Naturals.le_sub_of_add_le withFirst)
          (Nat.le_of_eq (sub_takeOne (avail r s₀ t))))
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (first r s₀ t + L'.give t (.taker false) .store) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_left atMostSecond _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **At every step both drawing is a mutual best response.** -/
theorem joint_course_best (t : Nat) :
    MutualBest (jointCourse r s₀) takers (jointLevel r s₀ t) capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => storeOrder) t (jointLevel r s₀ (t + 1)) :=
  fun h _ opt => match h, opt with
    | .taker true, _ => ⟨joint_course_within true t, first_optimum t⟩
    | .taker false, _ => ⟨joint_course_within false t, second_optimum t⟩

/-- What the dweller gives the source in the two takers' course is the renewal. -/
theorem joint_restGiven (t : Nat) :
    (jointCourse r s₀).restGiven takers t .source = renewal r (jointSource r s₀ t) :=
  show 0 + (0 + (renewal r (jointSource r s₀ t) + 0)) = renewal r (jointSource r s₀ t) from
    (Nat.zero_add _).trans (Nat.zero_add _)

/-- **Each within the renewal, jointly above it: the dependence is lost.** From a source at its
need, with a renewal `r < 2`, the two takers' joint capacity of two exceeds it, and at mutual best
responses at every step the dweller's dependence on the source is lost; derived from
`Web.mutual_course_lost`. -/
theorem joint_course_lost (start : 2 ≤ s₀) (below : r < 2) :
    (jointWeb (jointLevel r s₀)).Lost .source :=
  Web.mutual_course_lost (f := Member.dweller) (fun _ => members_distinct) lists.1 lists.2.1
    lists.2.2.1 lists.2.2.2 joint_course_best joint_course_balances (fun _ _ _ _ => .head [])
    (fun t => Nat.le_trans (Nat.le_of_eq (joint_restGiven t)) (renewal_le r _))
    (fun _ => below) (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- **Alone, a taker of capacity one keeps a source renewed by one.** -/
theorem alone_kept (start : 2 ≤ s₀) : ¬ (web (level 1 1 s₀)).Lost .source :=
  fun lost => Nat.lt_irrefl 1 ((lost_iff start).mp lost)

/-- The two takers' store holds everything drawn from the source. -/
theorem joint_store_eq_sum : ∀ n, jointStore r s₀ n =
    Amounts.whole.sum (drawnAt (jointSource r s₀) fun t => renewal r (jointSource r s₀ t)) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + (first r s₀ n + second r s₀ n)) (joint_store_eq_sum n)).trans
      ((congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + ·)
        ((Naturals.add_sub_cancel_left (jointSource r s₀ (n + 1)) _).symm.trans
          (congrArg (· - jointSource r s₀ (n + 1)) (joint_split n)))).trans
        (congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + drawnAt (jointSource r s₀)
            (fun t => renewal r (jointSource r s₀ t)) ·) (Nat.zero_add n).symm))

/-- **Above the renewal jointly, the two takers' store stays bounded however long the course.** -/
theorem joint_store_bounded (below : r < 2) (n : Nat) : jointStore r s₀ n ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (joint_store_eq_sum n)) (ended_drawn_le (x := jointSource r s₀)
    (m := 2) (g := fun t => renewal r (jointSource r s₀ t)) (d := fun _ => 2) (fun _ => rfl)
    (fun _ => renewal_le r _) (fun _ low => if_neg (Nat.not_le_of_gt low)) (fun _ => below)
    (Nat.succ_pos 1) n)

/-- One taker draws a unit at every step and the other nothing; the dweller renews by one. -/
def restrainedCourse (s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f, c with
    | .taker true, .source => 1
    | .taker true, .store => 0
    | .taker false, _ => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .taker true, .store => 1
    | .taker true, .source => 0
    | .taker false, _ => 0
    | .dweller, .source => renewal 1 s₀
    | .dweller, .store => 0

/-- The levels of the restrained course: the source where it started, the store at the step
count. -/
def restrainedLevel (s₀ : Nat) (t : Nat) : Place → Nat
  | .source => s₀
  | .store => t

/-- The restrained course balances from a source at its need. -/
theorem restrained_course_balances (start : 2 ≤ s₀) :
    (restrainedCourse s₀).Balances (jointWeb (restrainedLevel s₀)) := fun t c =>
  match c with
  | .source => show s₀ + (1 + (0 + (0 + 0))) = s₀ + (0 + (0 + (renewal 1 s₀ + 0))) from
      (congrArg (fun y => s₀ + (0 + (0 + (y + 0)))) (if_pos start : renewal 1 s₀ = 1)).symm
  | .store => show t + 1 + (0 + (0 + (0 + 0))) = t + (1 + (0 + (0 + 0))) from rfl

/-- **No step of the restrained course is a mutual best response.** Something stands at the
source after each step, and the restraining taker does not take its whole capacity there. -/
theorem restrained_course_not_best (start : 2 ≤ s₀) (t : Nat) :
    ¬ MutualBest (restrainedCourse s₀) takers (restrainedLevel s₀ t) capOf
      (fun _ => [Place.store]) (fun _ => [Place.source]) (fun _ => storeOrder) t
      (restrainedLevel s₀ (t + 1)) := fun best =>
  absurd (MutualBest.full (L := restrainedCourse s₀) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best (restrained_course_balances start t) (h := .taker false) (.tail _ (.head _)) rfl
    (.head []) (Nat.lt_of_lt_of_le (Nat.succ_pos 1) start)).1 fun same => nomatch same

/-- **Restraint, which no mutual best response allows, holds more.** From a source at its need
renewed by one, after `n` steps with `s₀ + s₀ < n` the two takers' store at mutual best
responses at every step holds less than the restrained course's. -/
theorem restraint_holds_more {n : Nat} (long : s₀ + s₀ < n) :
    (jointWeb (jointLevel 1 s₀)).level n .store < (jointWeb (restrainedLevel s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_trans (joint_store_bounded (Nat.lt_succ_self 1) n)
    (Nat.le_of_eq (congrArg (s₀ + ·) (Nat.one_mul s₀)))) long

end Pair

end Renewing

end Optimum

end Becoming
