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
* **Courses ranked over a horizon.** Where each step leaves at most the level with what is given
  and at most `r` is given at each step, what a course draws, what it leaves and everything the
  renewal falls short of `r` add to the starting level with `r` for each step
  (`Optimum.drawn_add_shortfall`, `Flow.Balances.taken_add_shortfall`); so of two balanced courses
  from one level, one takes at most what the other takes exactly where the other forgoes and leaves
  at most what the one does (`Flow.Balances.taken_le_iff`), and two given alike and ending alike
  take the same, whatever levels they pass through (`Flow.Balances.taken_eq_of_alike`). Where what
  is given is a law `R` of the level, a course draws across `n + 1` steps at most the start with
  what is given there and `r` for each step after (`Optimum.drawn_le_most`), exactly where it stands
  at a level where `R` gives `r` at every step to the `n`-th and leaves nothing after the last
  (`Optimum.most_iff`). Where such a level is within reach and the capacity, over at least two
  steps, every optimum of every order rising with what is drawn is such a course
  (`Optimum.frontier_holds`): it breaks at the first step a dependence whose need lies above every
  level of greatest renewal and leaves it unmet through the horizon (`Web.frontier_broken`), and
  keeps one that every such level meets through the horizon, breaking it at its end
  (`Web.frontier_kept`). `Holding` is the instance: from the level a dweller needs, under the
  logistic law `s (2 - s)`, the course holding the source at one, where the law renews most, is an
  optimum and breaks the dweller at the first step (`Holding.logistic_broken`); under a gate
  renewing one unit at every level from one, the courses holding the source at the dweller's need
  and below it are both optima and take the same (`Holding.gated_alike`).
* **What keeping a dependence forgoes.** Where what is given at every level at or above a need `m`
  is at most `q`, what a course keeping the condition at `m` or above through the horizon draws,
  with what it leaves, is at most the start with what is given there and `q` for each step after
  (`Optimum.keeping_le_most`, `Flow.Balances.keeping_taken_le`); among the courses keeping it,
  every optimum of every order rising with what is drawn holds a level where `q` is given and
  leaves exactly `m` (`Optimum.frontier_keeps`, `Web.frontier_keeps`), and the course holding such
  a level is one (`Optimum.continued_keeping_frontier`). So keeping forgoes, against the course
  holding a level of greatest renewal `r` and leaving nothing, `(r - q) n + m`: under an order
  adding to what a keeping course draws a coupling below that, every optimum falls below the need
  within the horizon, breaking the dependence (`Optimum.frontier_breaks_below`,
  `Web.frontier_breaks_below`); under one adding more to a keeping course and nothing to a course
  falling below the need, every optimum keeps it (`Optimum.frontier_keeps_above`,
  `Web.frontier_keeps_above`); and for a coupling of exactly `w` both have optima
  (`Optimum.continued_breaking_frontier`, `Optimum.continued_kept_frontier`). Where the capacity
  cannot draw down to nothing or to the need, the end it reaches enters the thresholds. Where the
  need lies above every level of greatest renewal, `q < r`, what keeping forgoes grows with the
  horizon, and every coupling below the horizon with the need is outweighed
  (`Optimum.forgone_grows`, `Web.frontier_breaks_long`). The courses attaining these bounds draw
  nothing after the horizon (`Optimum.continued`), so nothing is supposed beyond it; the identity
  and the holding course of the section above are generalized below it
  (`drawn_add_shortfall_after_up_to`, `holdingTo`). `Holding.logistic_coupled` is the instance:
  from the level the dweller needs, under the logistic law, keeping the dweller through `n + 2`
  steps forgoes `n + 3`, and the order by what the taker draws with a coupling `w` of the dweller
  has optima, all breaking it below that and all keeping it above.

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
lost. Ranking whole courses changes when, not whether: what a course draws, leaves and forgoes is
conservation over the horizon, so what a course draws registers its levels only through what is
renewed there, and every optimum of a far-sighted order rising with it holds a level of greatest
renewal, the maximum sustainable yield's level (half of room in the logistic law; Schaefer 1954), as
a sole owner does (Scott 1955), and draws everything at its horizon, the end of a finite-horizon
harvest (Clark 1976); a dependence beyond needing more than
those levels is lost at the first step however far the horizon, as single-species management leaves
predators of a forage stock uncounted (Pikitch and others 2012). What keeping such a dependence
forgoes is exact: the renewal given up at the need for each step and the need left at the end, so a
coupling of the dependence decides the optimum at that amount, and where the need lies above every
level of greatest renewal the amount grows with the horizon: the yield forgone by holding a stock
for what depends on it, the ecosystem constraint on a single-species yield, is no fixed sum, and a
far-sighted optimizer's gain from breaking the dependence grows with how far it sees.

What is not derived: outside the outcomes open to a part across one step of exchange, which
outcomes are eligible and whether there is room (hypotheses wherever they enter, with witnesses
that each binds); within them, the capacities, the family the part gives to, and that a member
may give what it takes to any condition of that family (a member giving only to some is not
covered); over a course, against a renewal varying with the level, the optimum where a level of
greatest renewal is out of reach or the capacity cannot draw down to it in one step or draw
everything at the horizon's last step, an order valuing what is left or earlier draws more (a
terminal value or a discount), several optimizers ranking courses, and how optimizers come to a
mutual best response; for several optimizers,
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

/-- **What stands and what was drawn.** Where each step leaves at most the level with what is
given, across `n` steps what stands after with everything drawn is the starting level with
everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn_of_within (within : ∀ t, x (t + 1) ≤ x t + g t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n
  | 0 => rfl
  | n + 1 => by
    show x (n + 1) + (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g (0 + n)) =
      x 0 + (Amounts.whole.sum g 0 n + g (0 + n))
    rw [Nat.zero_add]
    have back : x (n + 1) + drawnAt x g n = x n + g n := Naturals.add_sub_of_le (within n)
    rw [Nat.add_left_comm, back, ← Nat.add_assoc, Nat.add_comm (Amounts.whole.sum _ 0 n) (x n),
      level_add_drawn_of_within within n, Nat.add_assoc]

/-- **What stands and what was drawn** along a course whose steps take `d`: the case of
`level_add_drawn_of_within`. -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n :=
  level_add_drawn_of_within fun t => by rw [step t]; exact Nat.sub_le _ _

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

/-! ## Courses ranked over a horizon

Above, the part chooses again at each step. Here it ranks whole courses: an order on the courses
open to it at a condition beyond, rising with what a course draws there across a horizon of steps.
Where at most `r` is given at each step, what a course draws, what it leaves after the horizon and
everything the renewal falls short of `r` add to the starting level with `r` for each step; so
what is drawn ranks courses exactly as the renewal they forgo with what they leave does, reversed,
and registers a level only through what is given there. Where what is given is a law `R` of
the level, at most `r`, a course from a start draws across `n + 1` steps at most the start with what
is given there and `r` for each step after, exactly where it stands at a level of greatest renewal
at every step from the first to the `n`-th and leaves nothing after the last; where such a level is
within reach and the capacity, every optimum of every order rising with what is drawn is such a
course. So every optimum breaks at the first step a dependence whose need lies above every level of
greatest renewal and leaves it unmet through the horizon; a dependence every such level meets stands
through the horizon and is broken at its end; and where the renewal is the same at every level at or
above a need, two courses standing there and ending alike draw the same, whatever dependence above
the need one keeps and the other breaks. -/

namespace Optimum

section Horizon

variable {x g : Nat → Nat} {r : Nat}

/-- Sums over `n` steps of what agrees at each of them are the same. -/
theorem sum_eq_of_eq {f f' : Nat → Nat} :
    ∀ {n : Nat}, (∀ t, t < n → f t = f' t) →
      Amounts.whole.sum f 0 n = Amounts.whole.sum f' 0 n
  | 0, _ => rfl
  | n + 1, same => by
    show Amounts.whole.sum f 0 n + f (0 + n) = Amounts.whole.sum f' 0 n + f' (0 + n)
    rw [Nat.zero_add, sum_eq_of_eq (n := n) (fun t lt => same t (Nat.lt_succ_of_lt lt)),
      same n (Nat.lt_succ_self n)]

/-- A sum across `n + 1` steps is the first step with the sum across the `n` after it. -/
theorem sum_succ_first (f : Nat → Nat) :
    ∀ n, Amounts.whole.sum f 0 (n + 1) = f 0 + Amounts.whole.sum (fun t => f (t + 1)) 0 n
  | 0 => show 0 + f (0 + 0) = f 0 + 0 from (Nat.zero_add _).trans (Nat.add_zero _).symm
  | n + 1 => by
    show Amounts.whole.sum f 0 (n + 1) + f (0 + (n + 1)) =
      f 0 + (Amounts.whole.sum (fun t => f (t + 1)) 0 n + f (0 + n + 1))
    rw [sum_succ_first f n, Nat.add_assoc, Nat.zero_add, Nat.zero_add]

/-- Two amounts added and two more: the middle two exchanged. -/
theorem add_four (a b c d : Nat) : a + b + (c + d) = a + c + (b + d) := by
  rw [Nat.add_assoc, Nat.add_left_comm b c d, ← Nat.add_assoc]

/-- Nothing from two amounts added is nothing from each. -/
theorem eq_zero_of_add {a : Nat} : ∀ {b : Nat}, a + b = 0 → a = 0 ∧ b = 0
  | 0, zero => ⟨zero, rfl⟩
  | _ + 1, zero => absurd zero (Naturals.succ_ne_zero _)

/-- Adding the same amount first keeps two amounts apart. -/
theorem add_left_cancel_of {k a b : Nat} (same : k + a = k + b) : a = b :=
  Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same))
    (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same.symm))

/-- Of two equal sums of two amounts, the first amount of one is at most the first of the other
exactly where the second of the other is at most the second of the one. -/
theorem le_iff_of_add_eq {a b a' b' : Nat} (same : a + b = a' + b') : a ≤ a' ↔ b' ≤ b :=
  ⟨fun le => Naturals.le_of_add_le_add_left (k := a')
      (Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_right le b)),
   fun le => Naturals.le_of_add_le_add_right (k := b)
      (Nat.le_trans (Nat.le_of_eq same) (Nat.add_le_add_left le a'))⟩

/-- Nothing left of `n` less `m` is `n` at most `m`. -/
theorem le_of_sub_zero {n m : Nat} (zero : n - m = 0) : n ≤ m :=
  match Nat.lt_or_ge m n with
  | .inl lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq
      ((Naturals.sub_add_cancel (Nat.le_of_lt lt)).symm.trans
        ((congrArg (· + m) zero).trans (Nat.zero_add m))))) (Nat.lt_irrefl m)
  | .inr ge => ge

/-- A sum over `n` steps is nothing exactly where each step is nothing. -/
theorem sum_eq_zero_iff {f : Nat → Nat} :
    ∀ {n : Nat}, Amounts.whole.sum f 0 n = 0 ↔ ∀ t, t < n → f t = 0
  | 0 => ⟨fun _ _ lt => absurd lt (Nat.not_lt_zero _), fun _ => rfl⟩
  | n + 1 => ⟨fun zero =>
      have both := eq_zero_of_add (a := Amounts.whole.sum f 0 n) (b := f (0 + n)) zero
      fun t lt => match Nat.lt_or_ge t n with
        | .inl before => sum_eq_zero_iff.mp both.1 t before
        | .inr later => (congrArg f ((Nat.le_antisymm (Nat.le_of_lt_succ lt) later).trans
            (Nat.zero_add n).symm)).trans both.2,
     fun all => show Amounts.whole.sum f 0 n + f (0 + n) = 0 from
       (congrArg (· + f (0 + n))
         (sum_eq_zero_iff.mpr fun t lt => all t (Nat.lt_succ_of_lt lt))).trans
         ((Nat.zero_add _).trans
           ((congrArg f (Nat.zero_add n)).trans (all n (Nat.lt_succ_self n))))⟩

/-- **What is given and what it falls short of.** Where at most `r` is given at each step,
everything given across `n` steps, with everything it falls short of `r`, is `r` for each step. -/
theorem sum_add_shortfall (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n
  | 0 => rfl
  | n + 1 => by
    show Amounts.whole.sum g 0 n + g (0 + n) +
        (Amounts.whole.sum (fun t => r - g t) 0 n + (r - g (0 + n))) = r * (n + 1)
    rw [Nat.zero_add, add_four, sum_add_shortfall renews n, Naturals.add_sub_of_le (renews n),
      Nat.mul_succ]

/-- **What is given and what it falls short of, at the steps counted.** Where at most `r` is given at
each of `n` steps, everything given across them, with everything it falls short of `r`, is `r` for
each step: `sum_add_shortfall` for what is given at those steps and nothing after. -/
theorem sum_add_shortfall_up_to {n : Nat} (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n := by
  have given : Amounts.whole.sum g 0 n =
      Amounts.whole.sum (fun t => if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => (if_pos lt).symm
  have short : Amounts.whole.sum (fun t => r - g t) 0 n =
      Amounts.whole.sum (fun t => r - if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => congrArg (r - ·) (if_pos lt).symm
  rw [given, short]
  exact sum_add_shortfall (g := fun t => if t < n then g t else 0) (fun t => by
    show (if t < n then g t else 0) ≤ r
    match Nat.lt_or_ge t n with
    | .inl lt => rw [if_pos lt]; exact renews t lt
    | .inr ge => rw [if_neg (Nat.not_lt_of_ge ge)]; exact Nat.zero_le r) n

/-- **What a course draws, leaves and forgoes.** Where each step leaves at most the level with what
is given and at most `r` is given at each of `n` steps, what is drawn across them, with what stands
after them and everything the renewal falls short of `r`, is the starting level with `r` for each
step. -/
theorem drawn_add_shortfall_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n := by
  rw [Nat.add_comm (Amounts.whole.sum (drawnAt x g) 0 n), level_add_drawn_of_within within n,
    Nat.add_assoc, sum_add_shortfall_up_to renews]

/-- **What a course draws, leaves and forgoes**, where at most `r` is given at every step: the case
of `drawn_add_shortfall_up_to`. -/
theorem drawn_add_shortfall (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n :=
  drawn_add_shortfall_up_to within fun t _ => renews t

/-- **What a course draws after its first step, leaves and forgoes.** Where each step leaves at most
the level with what is given and at most `r` is given at each of the `n` steps after the first,
what is drawn across `n + 1` steps, with what stands after them and everything the renewal falls
short of `r` at those steps, is the starting level with what is given at the first step and `r` for
each step after. -/
theorem drawn_add_shortfall_after_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g (t + 1) ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n := by
  have later : Amounts.whole.sum (fun t => drawnAt x g (t + 1)) 0 n + x (n + 1) +
      Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 1 + r * n :=
    drawn_add_shortfall_up_to (x := fun t => x (t + 1)) (g := fun t => g (t + 1))
      (fun t => within (t + 1)) renews
  have first : x 1 + drawnAt x g 0 = x 0 + g 0 := Naturals.add_sub_of_le (within 0)
  rw [sum_succ_first, Nat.add_assoc (drawnAt x g 0), Nat.add_assoc (drawnAt x g 0), later,
    ← Nat.add_assoc, Nat.add_comm (drawnAt x g 0), first]

/-- **What a course draws after its first step, leaves and forgoes**, where at most `r` is given at
every step: the case of `drawn_add_shortfall_after_up_to`. -/
theorem drawn_add_shortfall_after (within : ∀ t, x (t + 1) ≤ x t + g t)
    (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n :=
  drawn_add_shortfall_after_up_to within fun t _ => renews (t + 1)

/-- **The most a course draws.** Where each step leaves at most the level with what is given and at
most `r` is given at each step, no course draws across `n + 1` steps more than the starting level
with what is given at the first step and `r` for each step after. -/
theorem drawn_le_most (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) ≤ x 0 + g 0 + r * n :=
  Nat.le_trans (Nat.le_add_right _ (x (n + 1))) (Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_of_eq (drawn_add_shortfall_after within renews n)))

/-- **Exactly which courses draw the most.** Where each step leaves at most the level with what is
given and at most `r` is given at each step, a course draws across `n + 1` steps the starting level
with what is given at the first step and `r` for each step after exactly where `r` is given at every
step after the first and nothing stands after the last. -/
theorem most_iff (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) = x 0 + g 0 + r * n ↔
      x (n + 1) = 0 ∧ ∀ t, t < n → g (t + 1) = r :=
  have whole := drawn_add_shortfall_after within renews n
  ⟨fun most =>
    have rest : x (n + 1) + Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      add_left_cancel_of ((Nat.add_assoc _ _ _).symm.trans
        (whole.trans (most.symm.trans (Nat.add_zero _).symm)))
    have both := eq_zero_of_add rest
    ⟨both.1, fun t lt => Nat.le_antisymm (renews (t + 1))
        (le_of_sub_zero (sum_eq_zero_iff.mp both.2 t lt))⟩,
   fun ⟨left, renewed⟩ => by
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      sum_eq_zero_iff.mpr fun t lt => (congrArg (r - ·) (renewed t lt)).trans (Nat.sub_self r)
    rw [left, none] at whole
    exact whole⟩

end Horizon

/-- What a course of levels `x` draws across `n` steps where `R` gives at each level. -/
def drawnOver (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (drawnAt x fun t => R (x t)) 0 n

/-- **The courses open from a start.** From level `s`, where `R` gives at each level and at most
`k` may be drawn a step: each step leaves at most the level with what is given, and draws at most
`k`. -/
def OpenCourse (R : Nat → Nat) (k s : Nat) (x : Nat → Nat) : Prop :=
  x 0 = s ∧ ∀ t, x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k

/-- The order of courses by what they draw across `n + 1` steps: more is better. -/
def byDrawn (R : Nat → Nat) (n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) < drawnOver R b (n + 1)

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at `e` after. -/
def holdingTo (s y e n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then y else e

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at nothing after: the
course holding `y` and ending at nothing. -/
def holding (s y n : Nat) : Nat → Nat := holdingTo s y 0 n

variable {R : Nat → Nat} {k r s y e n : Nat}

/-- The course holding `y` stands there from the first step to the `n`-th. -/
theorem holdingTo_before {t : Nat} (before : t < n) : holdingTo s y e n (t + 1) = y :=
  if_pos before

/-- The course holding `y` and ending at `e` stands at `e` after the `n`-th step. -/
theorem holdingTo_after {t : Nat} (after : n ≤ t) : holdingTo s y e n (t + 1) = e :=
  if_neg (Nat.not_lt_of_ge after)

/-- After its start, the course holding `y` and ending at `e` at most `y` stands at `e` or above. -/
theorem holdingTo_ge (settles : e ≤ y) (t : Nat) : e ≤ holdingTo s y e n (t + 1) :=
  match Nat.lt_or_ge t n with
  | .inl before => Nat.le_trans settles (Nat.le_of_eq (holdingTo_before before).symm)
  | .inr after => Nat.le_of_eq (holdingTo_after after).symm

/-- Each step of the course holding `y` and ending at `e` at most `y` leaves at most the level with
what is given, where `y` is within the start with what is given there. -/
theorem holdingTo_within (reach : y ≤ s + R s) (settles : e ≤ y) :
    ∀ t, holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holdingTo_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge)) (Nat.le_trans settles reach)
  | t + 1 => match Nat.lt_or_ge (t + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq ((holdingTo_before lt).trans
        (holdingTo_before (Nat.lt_of_succ_lt lt)).symm)) (Nat.le_add_right _ _)
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge))
        (Nat.le_trans (holdingTo_ge settles t) (Nat.le_add_right _ _))

/-- The holding course stands at `y` from the first step to the `n`-th. -/
theorem holding_before {t : Nat} (before : t < n) : holding s y n (t + 1) = y :=
  holdingTo_before before

/-- The holding course stands at nothing after the `n`-th step. -/
theorem holding_after {t : Nat} (after : n ≤ t) : holding s y n (t + 1) = 0 :=
  holdingTo_after after

/-- Each step of the holding course leaves at most the level with what is given, where `y` is
within the start with what is given there. -/
theorem holding_within (reach : y ≤ s + R s) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ holding s y n t + R (holding s y n t) :=
  holdingTo_within reach (Nat.zero_le y)

/-- **A course holding a level of greatest renewal draws the most.** Where `R` gives at most `r` at
every level and `r` at `y`, within the start with what is given there, the course holding `y` draws
across `n + 1` steps the start with what is given there and `r` for each step after. -/
theorem holding_most (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (n : Nat) : drawnOver R (holding s y n) (n + 1) = s + R s + r * n :=
  (most_iff (x := holding s y n) (g := fun t => R (holding s y n t)) (holding_within reach n)
    (fun _ => renews _) n).mpr
    ⟨holding_after (Nat.le_refl n), fun _ lt => (congrArg R (holding_before lt)).trans greatest⟩

/-- What a step draws is at most `k` where the level with what is given is at most the level after
with `k`. -/
theorem drawnAt_le_of {a b c k : Nat} (le : a + b ≤ c + k) : a + b - c ≤ k :=
  Nat.le_trans (sub_le_sub_right_of_le le c) (Nat.le_of_eq (Naturals.add_sub_cancel_left c k))

/-- **The steps of the course holding `y` and ending at `e` within the horizon.** Over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`
down to `e`, each step to the `n`-th leaves at most the level with what is given and draws at most
`k`. -/
theorem holdingTo_steps (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k
  | 0, _ => ⟨holdingTo_within reach settles 0, drawnAt_le_of (Nat.le_trans drawsDown
      (Nat.le_of_eq (congrArg (· + k) (holdingTo_before long).symm)))⟩
  | t + 1, le => ⟨holdingTo_within reach settles (t + 1), drawnAt_le_of (by
      show holdingTo s y e n (t + 1) + R (holdingTo s y e n (t + 1)) ≤
        holdingTo s y e n (t + 1 + 1) + k
      rw [holdingTo_before (Nat.lt_of_succ_le le), greatest]
      match Nat.lt_or_ge (t + 1) n with
      | .inl lt =>
        rw [holdingTo_before lt]
        exact Nat.le_trans holds (Nat.add_le_add_right settles k)
      | .inr ge =>
        rw [holdingTo_after ge]
        exact holds)⟩

/-- **The course holding `y` and ending at `e` is open**, over a horizon of at least two steps, with
a capacity covering what the first step draws down to `y`, `y` with `r` down to `e`, and what is
given at `e`. -/
theorem holdingTo_open (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (rests : R e ≤ k) (long : 0 < n) :
    OpenCourse R k s (holdingTo s y e n) :=
  ⟨rfl, fun t => match Nat.lt_or_ge t (n + 1) with
    | .inl lt =>
      holdingTo_steps greatest reach settles drawsDown holds long t (Nat.le_of_lt_succ lt)
    | .inr ge => ⟨holdingTo_within reach settles t, match t, ge with
      | 0, ge => absurd ge (Nat.not_succ_le_zero n)
      | j + 1, ge => drawnAt_le_of (by
          show holdingTo s y e n (j + 1) + R (holdingTo s y e n (j + 1)) ≤
            holdingTo s y e n (j + 1 + 1) + k
          rw [holdingTo_after (Nat.le_of_succ_le_succ ge),
            holdingTo_after (Nat.le_succ_of_le (Nat.le_of_succ_le_succ ge))]
          exact Nat.add_le_add_left rests e)⟩⟩

/-- **The holding course is open**, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`: the case of `holdingTo_open` ending at
nothing. -/
theorem holding_open (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    OpenCourse R k s (holding s y n) :=
  holdingTo_open greatest reach (Nat.zero_le y) drawsDown
    (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm))
    (Nat.le_trans (renews 0) (Nat.le_trans (Nat.le_add_left r y) holds)) long

/-- No open course draws across `n + 1` steps more than the start with what is given there and `r`
for each step after, where `R` gives at most `r`. -/
theorem open_le_most (renews : ∀ z, R z ≤ r) {x : Nat → Nat} (opens : OpenCourse R k s x)
    (n : Nat) : drawnOver R x (n + 1) ≤ s + R s + r * n :=
  Eq.subst (motive := fun z => drawnOver R x (n + 1) ≤ z + R z + r * n) opens.1
    (drawn_le_most (fun t => (opens.2 t).1) (fun t => renews (x t)) n)

/-- **The holding course is an optimum** of the order by what is drawn. -/
theorem holding_frontier (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawn R n) (holding s y n) :=
  ⟨holding_open renews greatest reach drawsDown holds long, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_le_most renews opens n)
      (Nat.le_of_eq (holding_most renews greatest reach n).symm))⟩

/-- **Every optimum holds a level of greatest renewal and leaves nothing.** Where `R` gives at most
`r` at every level and `r` at some `y` within the start with what is given there, over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with
`r`, every optimum of every order on the courses open from the start that rises with what is drawn
across `n + 1` steps draws the most: it
stands at a level of greatest renewal at every step from the first to the `n`-th and at nothing
after the last. -/
theorem frontier_holds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    x (n + 1) = 0 ∧ ∀ t, t < n → R (x (t + 1)) = r :=
  have most : drawnOver R x (n + 1) = s + R s + r * n :=
    Nat.le_antisymm (open_le_most renews front.1 n)
      (match Nat.lt_or_ge (drawnOver R x (n + 1)) (s + R s + r * n) with
      | .inl less => absurd (rising x (holding s y n) (Nat.lt_of_lt_of_le less
          (Nat.le_of_eq (holding_most renews greatest reach n).symm)))
          (front.2 _ (holding_open renews greatest reach drawsDown holds long))
      | .inr ge => ge)
  (most_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) = z + R z + r * n) front.1.1.symm most)

end Optimum

namespace Flow

open Optimum

variable {L L' : Flow F C} {W W' : Web F C} {c : C} {r : Nat}

/-- **Under balance, what is drawn is what is taken.** -/
theorem Balances.drawnAt_eq (balances : L.Balances W) (c : C) (t : Nat) :
    drawnAt (fun t => W.level t c) (fun t => L.given t c) t = L.taken t c :=
  (congrArg (· - W.level (t + 1) c) (balances t c).symm).trans
    ((congrArg (· - W.level (t + 1) c) (Nat.add_comm _ _)).trans (Naturals.add_sub_cancel _ _))

/-- Under balance, each step leaves at most the level with what is given. -/
theorem Balances.within (balances : L.Balances W) (c : C) (t : Nat) :
    W.level (t + 1) c ≤ W.level t c + L.given t c :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (balances t c))

/-- Under balance, everything taken from a condition across `n` steps is what is drawn there. -/
theorem Balances.sum_taken (balances : L.Balances W) (c : C) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n =
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.given t c) 0 n :=
  sum_eq_of_eq fun t _ => (balances.drawnAt_eq c t).symm

/-- **What a balanced course takes, leaves and forgoes.** Where the formations taking part give a
condition at most `r` a step, what they take from it across `n` steps, with its level after them and
everything given there falls short of `r`, is its starting level with `r` for each step. -/
theorem Balances.taken_add_shortfall (balances : L.Balances W) (renews : ∀ t, L.given t c ≤ r)
    (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n + W.level n c +
        Amounts.whole.sum (fun t => r - L.given t c) 0 n = W.level 0 c + r * n := by
  rw [balances.sum_taken c n]
  exact drawn_add_shortfall (balances.within c) renews n

/-- **Balanced courses ranked by what they forgo and leave.** Of two balanced courses from one
level at a condition, each given at most `r` there a step, the first takes from it across `n` steps
at most what the second takes exactly where what the second leaves with everything given to it
falls short of `r` is at most the first's: what is taken registers the levels a course passes
through only through what is given at them. -/
theorem Balances.taken_le_iff (balances : L.Balances W) (balances' : L'.Balances W')
    (renews : ∀ t, L.given t c ≤ r) (renews' : ∀ t, L'.given t c ≤ r)
    (same : W'.level 0 c = W.level 0 c) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n ≤
        Amounts.whole.sum (fun t => L'.taken t c) 0 n ↔
      W'.level n c + Amounts.whole.sum (fun t => r - L'.given t c) 0 n ≤
        W.level n c + Amounts.whole.sum (fun t => r - L.given t c) 0 n :=
  le_iff_of_add_eq (by
    rw [← Nat.add_assoc, ← Nat.add_assoc, balances.taken_add_shortfall renews n,
      balances'.taken_add_shortfall renews' n, same])

/-- **Alike in what is given and left, alike in what is taken.** Two balanced courses from one
level at a condition, given the same there at each of `n` steps and leaving the same after them,
take the same from it across them, whatever levels they pass through. -/
theorem Balances.taken_eq_of_alike (balances : L.Balances W) (balances' : L'.Balances W')
    (same : W'.level 0 c = W.level 0 c) {n : Nat}
    (given : ∀ t, t < n → L'.given t c = L.given t c)
    (left : W'.level n c = W.level n c) :
    Amounts.whole.sum (fun t => L'.taken t c) 0 n = Amounts.whole.sum (fun t => L.taken t c) 0 n :=
  add_left_cancel_of (k := W.level n c)
    (calc W.level n c + Amounts.whole.sum (fun t => L'.taken t c) 0 n
        = W'.level n c + Amounts.whole.sum (drawnAt (fun t => W'.level t c)
            fun t => L'.given t c) 0 n := by rw [left, balances'.sum_taken c n]
      _ = W'.level 0 c + Amounts.whole.sum (fun t => L'.given t c) 0 n :=
          level_add_drawn_of_within (x := fun t => W'.level t c) (g := fun t => L'.given t c)
            (balances'.within c) n
      _ = W.level 0 c + Amounts.whole.sum (fun t => L.given t c) 0 n := by
          rw [same, sum_eq_of_eq given]
      _ = W.level n c + Amounts.whole.sum (drawnAt (fun t => W.level t c)
            fun t => L.given t c) 0 n :=
          (level_add_drawn_of_within (x := fun t => W.level t c) (g := fun t => L.given t c)
            (balances.within c) n).symm
      _ = W.level n c + Amounts.whole.sum (fun t => L.taken t c) 0 n := by
          rw [balances.sum_taken c n])

/-- **A balanced course is open.** Where what is given to a condition is a law `R` of its level and
what is taken there is at most `k` a step, the course of its levels is open from its start. -/
theorem Balances.open_course {R : Nat → Nat} {k : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (within : ∀ t, L.taken t c ≤ k) :
    OpenCourse R k (W.level 0 c) fun t => W.level t c :=
  ⟨rfl, fun t => ⟨Nat.le_trans (balances.within c t) (Nat.le_of_eq
      (congrArg (W.level t c + ·) (renewal t))),
    Nat.le_trans (Nat.le_of_eq ((congrArg (fun z => W.level t c + z - W.level (t + 1) c)
      (renewal t)).symm.trans (balances.drawnAt_eq c t))) (within t)⟩⟩

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k r y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Far-sight breaks at the first step a dependence above every level of greatest renewal.** Where
what is given to a condition is a law `R` of its level, at most `r` at every level and `r` at some
`y` within the start with what is given there, over a horizon of at least two steps, with a capacity
covering what the first step draws down to `y` and `y` with `r`, and every level where `R` gives `r`
lies below a formation's need on the condition, met at the start: every optimum, among the courses
open from the start, of every order rising with what is drawn across `n + 1` steps breaks the
dependence at the first step and leaves it unmet through the horizon. -/
theorem frontier_broken (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < n + 1 → W.level (t + 1) c < m :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have unmet : ∀ t, t < n + 1 → W.level (t + 1) c < m := fun t lt =>
    match Nat.lt_or_ge t n with
    | .inl before => above _ (held.2 t before)
    | .inr after => Eq.subst (motive := fun z => W.level (z + 1) c < m)
        (Nat.le_antisymm after (Nat.le_of_lt_succ lt))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq held.1)
          (Nat.lt_of_le_of_lt (Nat.zero_le y) (above y greatest)))
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) start,
    Nat.lt_of_lt_of_le (unmet 0 (Nat.succ_pos n)) (Nat.le_of_eq need.symm)⟩, unmet⟩

/-- **Far-sight keeps a dependence every level of greatest renewal meets through the horizon, and
breaks it at its end.** Where what is given to a condition is a law `R` of its level, at most `r` at
every level and `r` at some `y` within the start with what is given there, over a horizon of at
least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`,
and every level where `R` gives `r` meets a formation's positive need on the condition, met at the
start: under every optimum, among the
courses open from the start, of every order rising with what is drawn across `n + 1` steps, the
dependence stands at every step to the `n`-th and is broken at the last. -/
theorem frontier_kept (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (meets : ∀ z, R z = r → m ≤ z) (needs : 0 < m) (depends : W.requires n f c)
    (need : W.need n f c = m) (start : m ≤ W.level 0 c) :
    (∀ t, t ≤ n → m ≤ W.level t c) ∧ W.Broken n f c :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have stands : ∀ t, t ≤ n → m ≤ W.level t c := fun t le => match t, le with
    | 0, _ => start
    | t + 1, le => meets _ (held.2 t (Nat.lt_of_succ_le le))
  ⟨stands, depends, Nat.le_trans (Nat.le_of_eq need) (stands n (Nat.le_refl n)),
    Nat.lt_of_le_of_lt (Nat.le_of_eq held.1) (Nat.lt_of_lt_of_le needs (Nat.le_of_eq need.symm))⟩

end Web

namespace Optimum

namespace Holding

open Diversion DrawnBeyond Drain

/-- What the taker draws from the source at each step of the holding course. -/
def draw (R : Nat → Nat) (s y n : Nat) : Nat → Nat :=
  drawnAt (holding s y n) fun t => R (holding s y n t)

/-- The store along the holding course: everything the taker has drawn. -/
def store (R : Nat → Nat) (s y n : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store R s y n t + draw R s y n t

/-- The levels along the holding course. -/
def level (R : Nat → Nat) (s y n : Nat) (t : Nat) : Place → Nat
  | .source => holding s y n t
  | .store => store R s y n t

/-- At each step the taker takes what the holding course draws from the source and gives it to the
store; the dweller gives the source what `R` gives at its level. -/
def course (R : Nat → Nat) (s y n : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw R s y n t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw R s y n t
    | .taker, .source => 0
    | .dweller, .source => R (holding s y n t)
    | .dweller, .store => 0

variable {R : Nat → Nat} {s y n : Nat}

/-- The holding course balances: the source loses what the taker draws and gains what `R` gives;
the store gains what the taker draws. -/
theorem course_balances (reach : y ≤ s + R s) : (course R s y n).Balances (web (level R s y n)) :=
  fun t c => match c with
  | .source => show holding s y n (t + 1) + (draw R s y n t + 0) =
      holding s y n t + (0 + (R (holding s y n t) + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (holding_within reach n t)
  | .store => show store R s y n (t + 1) + (0 + 0) = store R s y n t + (draw R s y n t + 0) from
    rfl

/-- The logistic law with room for two, `s (2 - s)`: one unit renewed at level one, nothing at
none or at two or more. -/
def logistic (s : Nat) : Nat := s * (2 - s)

/-- The logistic law gives one unit at one and nothing from two on. -/
theorem logistic_beyond (s : Nat) : logistic (s + 2) = 0 :=
  (congrArg ((s + 2) * ·) (sub_eq_zero_of_le (Nat.le_add_left 2 s))).trans (Nat.mul_zero _)

/-- The logistic law gives at most one. -/
theorem logistic_le : ∀ s, logistic s ≤ 1
  | 0 => Nat.zero_le 1
  | 1 => Nat.le_refl 1
  | s + 2 => Nat.le_trans (Nat.le_of_eq (logistic_beyond s)) (Nat.zero_le 1)

/-- The logistic law gives one only at one, below the dweller's need. -/
theorem logistic_greatest : ∀ z, logistic z = 1 → z < 2
  | 0, zero => absurd zero (Naturals.succ_ne_zero 0).symm
  | 1, _ => Nat.lt_succ_self 1
  | s + 2, one => absurd ((logistic_beyond s).symm.trans one) (Naturals.succ_ne_zero 0).symm

/-- **The logistic witness: far-sight breaks the dweller.** From a source at two, the level the
dweller needs and where the logistic law renews nothing, the course holding the source at one, where
the law renews most, balances and is an optimum of the order by what the taker draws across
`n + 2` steps among the courses open to it with capacity two; it breaks the dweller's dependence at
the first step and leaves it unmet through the horizon, as every such optimum does
(`Web.frontier_broken`). -/
theorem logistic_broken (n : Nat) :
    (course logistic 2 1 (n + 1)).Balances (web (level logistic 2 1 (n + 1))) ∧
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) ∧
      (web (level logistic 2 1 (n + 1))).Broken 0 .dweller .source ∧
      ∀ t, t < n + 2 → (web (level logistic 2 1 (n + 1))).level (t + 1) .source < 2 :=
  have front :
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) :=
    holding_frontier logistic_le rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2)
      (Nat.succ_pos n)
  ⟨course_balances (Nat.le_succ 1), front,
   Web.frontier_broken (W := web (level logistic 2 1 (n + 1))) (c := Place.source)
     (f := Formation.dweller) (y := 1) logistic_le (fun _ _ more => more) rfl (Nat.le_succ 1)
     (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front logistic_greatest trivial rfl
     (Nat.le_refl 2)⟩

/-- A gate: one unit renewed at every level from one, nothing at none. -/
def gate : Nat → Nat
  | 0 => 0
  | _ + 1 => 1

/-- The gate gives at most one. -/
theorem gate_le : ∀ s, gate s ≤ 1
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

/-- **The gated witness: the order registers nothing of a dependence above the gate.** From a source
at two, under a gate renewing one unit at every level from one, the course holding the source at two
and the course holding it at one are both optima of the order by what the taker draws across `n + 2`
steps among the courses open to it with capacity three, and the taker takes the same from the
source along both (`Flow.Balances.taken_eq_of_alike`); the first keeps the dweller's dependence at
every step to the `(n + 1)`-th, the second breaks it at the first step. -/
theorem gated_alike (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 1 (n + 1)) ∧
      Amounts.whole.sum (fun t => (course gate 2 1 (n + 1)).taken t .source) 0 (n + 2) =
        Amounts.whole.sum (fun t => (course gate 2 2 (n + 1)).taken t .source) 0 (n + 2) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      (web (level gate 2 1 (n + 1))).Broken 0 .dweller .source :=
  have alike : ∀ t, t < n + 2 →
      (course gate 2 1 (n + 1)).given t .source = (course gate 2 2 (n + 1)).given t .source :=
    fun t lt => congrArg (fun z => 0 + (z + 0)) (match t, lt with
      | 0, _ => rfl
      | _ + 1, lt =>
        have before := Nat.lt_of_succ_lt_succ lt
        (congrArg gate (holding_before (s := 2) (y := 1) before)).trans
          (congrArg gate (holding_before (s := 2) (y := 2) before)).symm)
  ⟨holding_frontier gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n),
   holding_frontier gate_le rfl (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2)) (Nat.le_succ 3)
     (Nat.le_succ 2) (Nat.succ_pos n),
   Flow.Balances.taken_eq_of_alike (L := course gate 2 2 (n + 1))
     (W := web (level gate 2 2 (n + 1)))
     (L' := course gate 2 1 (n + 1)) (W' := web (level gate 2 1 (n + 1))) (c := Place.source)
     (n := n + 2) (course_balances (Nat.le_succ 2))
     (course_balances (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2))) rfl alike
     ((holding_after (s := 2) (y := 1) (Nat.le_refl (n + 1))).trans
       (holding_after (s := 2) (y := 2) (Nat.le_refl (n + 1))).symm),
   fun t le => match t, le with
     | 0, _ => Nat.le_refl 2
     | _ + 1, le => Nat.le_of_eq (holding_before (s := 2) (y := 2) (Nat.lt_of_succ_le le)).symm,
   trivial, Nat.le_refl 2,
   Nat.lt_of_le_of_lt (Nat.le_of_eq (holding_before (s := 2) (y := 1) (Nat.succ_pos n)))
     (Nat.lt_succ_self 1)⟩

end Holding

end Optimum

/-! ## What keeping a dependence forgoes over a horizon

Above, every optimum of an order rising with what is drawn holds a level of greatest renewal. Here
a condition is kept at a need `m` or above through the `n + 1` steps of a horizon. Where what is
given at or above `m` is at most `q`, what a course keeping it draws, with what it leaves, is at
most the start with what is given there and `q` for each step after; among the courses keeping it,
the optima of every order rising with what is drawn hold a level where `q` is given and leave
exactly `m`. Against the course holding a level where `r` is given and leaving nothing, keeping
forgoes `(r - q) n + m`. So an order adding to what a keeping course draws a coupling below that
has only optima falling below the need within the horizon, and one adding more to a keeping course
and nothing to a course falling below the need has only optima keeping it; where the worth adds
exactly the coupling, both have optima, so neither holds vacuously. Where `q < r`, what
keeping forgoes grows with the horizon, and every coupling below the horizon with the need is
outweighed. The courses that attain these bounds draw nothing after the horizon, so nothing is
supposed about what lies beyond it; where the capacity cannot draw down to nothing or to the need,
the end `e` it can reach enters the thresholds. -/

namespace Optimum

/-- A course keeps its level at `m` or above through the `n + 1` steps of a horizon. -/
def Keeps (m n : Nat) (x : Nat → Nat) : Prop := ∀ t, t ≤ n + 1 → m ≤ x t

/-- A step at most one past `n` is at most `n` or one past it. -/
theorem le_or_eq_succ {t n : Nat} (le : t ≤ n + 1) : t ≤ n ∨ t = n + 1 :=
  match Nat.lt_or_ge t (n + 1) with
  | .inl lt => .inl (Nat.le_of_lt_succ lt)
  | .inr ge => .inr (Nat.le_antisymm le ge)

variable {R : Nat → Nat} {k q r s y m n : Nat}

/-- **What a course keeping a need draws and leaves.** Where each step leaves at most the level with
what `R` gives there, `R` gives at most `q` at every level at or above `m`, and a course keeps its
level at `m` or above through `n + 1` steps, what it draws across them with what it leaves is at
most its start with what is given there and `q` for each step after. -/
theorem keeping_le_most (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + x (n + 1) ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq
    (drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n) within
      fun t lt => above _ (keeps (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))))

/-- What a course keeping a need draws, with the need, is at most its start with what is given there
and `q` for each step after. -/
theorem keeping_drawn_le (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + m ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.add_le_add_left (keeps (n + 1) (Nat.le_refl _)) _)
    (keeping_le_most above within keeps)

/-- **What the course holding a level draws.** Where `R` gives `r` at `y`, within the start with
what is given there, the course holding `y` to the `n`-th step and ending at `e` at most `y` draws
across `n + 1` steps, with `e`, the start with what is given there and `r` for each step after. -/
theorem holdingTo_most {e : Nat} (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (n : Nat) : drawnOver R (holdingTo s y e n) (n + 1) + e = s + R s + r * n := by
  have whole := drawn_add_shortfall_after_up_to (x := holdingTo s y e n)
    (g := fun t => R (holdingTo s y e n t)) (r := r) (n := n) (holdingTo_within reach settles)
    fun t lt => Nat.le_of_eq ((congrArg R (holdingTo_before lt)).trans greatest)
  have none : Amounts.whole.sum (fun t => r - R (holdingTo s y e n (t + 1))) 0 n = 0 :=
    sum_eq_zero_iff.mpr fun t lt =>
      (congrArg (fun z => r - R z) (holdingTo_before lt)).trans
        ((congrArg (r - ·) greatest).trans (Nat.sub_self r))
  rw [holdingTo_after (Nat.le_refl n), none, Nat.add_zero] at whole
  exact whole

/-- The course holding `y` at or above `m`, from a start at or above `m` and ending at `e` at or
above `m`, keeps its level at `m` or above. -/
theorem holdingTo_keeps {e : Nat} (meets : m ≤ s) (needs : m ≤ y) (ends : m ≤ e) :
    Keeps m n (holdingTo s y e n) :=
  fun t _ => match t with
  | 0 => meets
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl before => Nat.le_trans needs (Nat.le_of_eq (holdingTo_before before).symm)
    | .inr after => Nat.le_trans ends (Nat.le_of_eq (holdingTo_after after).symm)

/-- The course `x` through the `n + 1` steps of a horizon, drawing nothing after them. -/
def continued (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat → Nat
  | 0 => x 0
  | t + 1 => if t ≤ n then x (t + 1) else continued R x n t + R (continued R x n t)

/-- The continued course stands where the course does through the horizon. -/
theorem continued_le {x : Nat → Nat} : ∀ {t : Nat}, t ≤ n + 1 → continued R x n t = x t
  | 0, _ => rfl
  | _ + 1, le => if_pos (Nat.le_of_succ_le_succ le)

/-- After the horizon the continued course draws nothing. -/
theorem continued_after {x : Nat → Nat} {t : Nat} (after : n < t) :
    continued R x n (t + 1) = continued R x n t + R (continued R x n t) :=
  if_neg (Nat.not_le_of_gt after)

/-- **A course open through the horizon continues openly.** A course from `s` whose steps to the
`n`-th leave at most the level with what is given and draw at most `k`, continued by drawing
nothing after them, is open. -/
theorem continued_open {x : Nat → Nat} (start : x 0 = s)
    (steps : ∀ t, t ≤ n → x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k) :
    OpenCourse R k s (continued R x n) :=
  ⟨start, fun t => match Nat.lt_or_ge n t with
    | .inr le => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_le (Nat.le_succ_of_le le), continued_le (Nat.succ_le_succ le)]
      exact steps t le
    | .inl after => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_after after, Nat.sub_self]
      exact ⟨Nat.le_refl _, Nat.zero_le k⟩⟩

/-- The continued course draws across the horizon what the course draws. -/
theorem continued_drawn {x : Nat → Nat} :
    drawnOver R (continued R x n) (n + 1) = drawnOver R x (n + 1) :=
  sum_eq_of_eq fun t lt => by
    show continued R x n t + R (continued R x n t) - continued R x n (t + 1) =
      x t + R (x t) - x (t + 1)
    rw [continued_le (Nat.le_succ_of_le (Nat.le_of_lt_succ lt)),
      continued_le (Nat.succ_le_succ (Nat.le_of_lt_succ lt))]

/-- The continued course keeps its level at `m` or above through the horizon where the course
does. -/
theorem continued_keeps {x : Nat → Nat} (keeps : Keeps m n x) : Keeps m n (continued R x n) :=
  fun t le => Nat.le_trans (keeps t le) (Nat.le_of_eq (continued_le le).symm)

/-- Comparing worths below what keeping forgoes. -/
theorem lt_of_forgone_below {A D Wa Da S w q' r' e : Nat} (coupled : A ≤ D + w)
    (kept : D + m ≤ S + q') (most : Da + e = S + r') (draws : Da ≤ Wa)
    (below : w + q' + e < r' + m) : A < Wa := by
  have less : A + (m + e) < Wa + (m + e) :=
    calc A + (m + e) ≤ D + w + (m + e) := Nat.add_le_add_right coupled _
      _ = D + m + (w + e) := by
        rw [Nat.add_assoc D w, Nat.add_assoc D m, Nat.add_left_comm w m e]
      _ ≤ S + q' + (w + e) := Nat.add_le_add_right kept _
      _ = S + (w + q' + e) := by
        rw [Nat.add_assoc S q' (w + e), Nat.add_left_comm q' w e, Nat.add_assoc w q' e]
      _ < S + (r' + m) := Nat.add_lt_add_left below _
      _ = Da + e + m := by rw [← Nat.add_assoc, ← most]
      _ ≤ Wa + e + m := Nat.add_le_add_right (Nat.add_le_add_right draws e) m
      _ = Wa + (m + e) := by rw [Nat.add_assoc, Nat.add_comm e m]
  exact Nat.lt_of_add_lt_add_right less

/-- Comparing worths beyond what keeping forgoes. -/
theorem lt_of_forgone_beyond {A D Wa Da S w q' r' e : Nat} (uncoupled : A ≤ D)
    (bound : D ≤ S + r') (most : Da + e = S + q') (coupled : Da + w ≤ Wa)
    (beyond : r' + e < w + q') : A < Wa := by
  have less : A + e < Wa + e :=
    calc A + e ≤ S + r' + e := Nat.add_le_add_right (Nat.le_trans uncoupled bound) e
      _ = S + (r' + e) := Nat.add_assoc _ _ _
      _ < S + (w + q') := Nat.add_lt_add_left beyond _
      _ = Da + e + w := by rw [Nat.add_comm w q', ← Nat.add_assoc, ← most]
      _ = Da + w + e := Nat.add_right_comm _ _ _
      _ ≤ Wa + e := Nat.add_le_add_right coupled e
  exact Nat.lt_of_add_lt_add_right less

/-- **Among the courses keeping a need, the optima hold its greatest renewal and leave the need.**
Where `R` gives at most `q` at every level at or above `m` and `q` at some `y` at or above `m`
within the start with what is given there, from a start meeting `m`, over a horizon of at least two
steps, with a capacity covering what the first step draws down to `y` and `y` with `q` down to
`m`: every optimum, among the open courses keeping their level at `m` or above through the horizon,
of every order rising with what is drawn across `n + 1` steps stands where `R` gives `q` at every
step to the `n`-th and at `m` after the last. -/
theorem frontier_keeps {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) better x) :
    x (n + 1) = m ∧ ∀ t, t < n → R (x (t + 1)) = q := by
  have opens : OpenCourse R k s (continued R (holdingTo s y m n) n) :=
    continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long)
  have most := holdingTo_most (n := n) greatest reach needs
  have atLeast : drawnOver R (holdingTo s y m n) (n + 1) ≤ drawnOver R x (n + 1) :=
    Nat.ge_of_not_lt fun less =>
      front.2 _ ⟨opens, continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩
        (rising x _ (Nat.lt_of_lt_of_le less (Nat.le_of_eq continued_drawn.symm)))
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = x 0 + R (x 0) + q * n :=
    drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n)
      (fun t => (front.1.1.2 t).1)
      fun t lt => above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))
  rw [front.1.1.1, ← most, Nat.add_assoc] at whole
  have rest : x (n + 1) + Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n ≤ m :=
    Naturals.le_of_add_le_add_left (k := drawnOver R x (n + 1))
      (Nat.le_trans (Nat.le_of_eq whole) (Nat.add_le_add_right atLeast m))
  have stands : m ≤ x (n + 1) := front.1.2 (n + 1) (Nat.le_refl _)
  have none : Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = 0 :=
    Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := x (n + 1))
      (Nat.le_trans rest (Nat.le_trans stands (Nat.le_of_eq (Nat.add_zero _).symm))))
      (Nat.zero_le _)
  exact ⟨Nat.le_antisymm (Nat.le_trans (Nat.le_add_right _ _) rest) stands, fun t lt =>
    Nat.le_antisymm (above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt))))
      (le_of_sub_zero (sum_eq_zero_iff.mp none t lt))⟩

/-- A course from a start meeting `m` either keeps its level at `m` or above through the `n + 1`
steps of a horizon or falls below `m`, at some step to the `n`-th, from a level meeting it. -/
theorem keeps_or_drops {x : Nat → Nat} (start : m ≤ x 0) :
    ∀ n, Keeps m n x ∨ ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m
  | 0 => match Nat.lt_or_ge (x 1) m with
    | .inl lt => .inr ⟨0, Nat.le_refl 0, start, lt⟩
    | .inr ge => .inl fun t le => match le_or_eq_succ le with
      | .inl first => Eq.subst (motive := fun z => m ≤ x z)
          (Nat.le_antisymm first (Nat.zero_le t)).symm start
      | .inr second => Eq.subst (motive := fun z => m ≤ x z) second.symm ge
  | n + 1 => match keeps_or_drops start n with
    | .inr ⟨t, le, met, lt⟩ => .inr ⟨t, Nat.le_succ_of_le le, met, lt⟩
    | .inl keeps => match Nat.lt_or_ge (x (n + 1 + 1)) m with
      | .inl lt => .inr ⟨n + 1, Nat.le_refl _, keeps (n + 1) (Nat.le_refl _), lt⟩
      | .inr ge => .inl fun t le => match le_or_eq_succ le with
        | .inl earlier => keeps t earlier
        | .inr last => Eq.subst (motive := fun z => m ≤ x z) last.symm ge

/-- A course from a start meeting `m` that does not keep its level at `m` or above through the
horizon falls below `m`, at some step to the `n`-th, from a level meeting it. -/
theorem drops_of_not_keeps {x : Nat → Nat} (start : m ≤ x 0) (fails : ¬ Keeps m n x) :
    ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m :=
  match keeps_or_drops start n with
  | .inl keeps => absurd keeps fails
  | .inr drops => drops

/-- A course either keeps its level at `m` or above through the `n + 1` steps of a horizon or stands
below `m` at some step through them. -/
theorem keeps_or_below {x : Nat → Nat} : Keeps m n x ∨ ∃ t, t ≤ n + 1 ∧ x t < m :=
  match Nat.lt_or_ge (x 0) m with
  | .inl lt => .inr ⟨0, Nat.zero_le _, lt⟩
  | .inr start => match keeps_or_drops start n with
    | .inl keeps => .inl keeps
    | .inr ⟨t, le, _, lt⟩ => .inr ⟨t + 1, Nat.succ_le_succ le, lt⟩

/-- **The optimum among the courses keeping a need.** Under the premises of `frontier_keeps`, the
course holding `y` to the `n`-th step, standing at `m` after the last and drawing nothing after it,
is an optimum, among the open courses keeping their level at `m` or above through the horizon, of
the order by what is drawn. -/
theorem continued_keeping_frontier (above : ∀ z, m ≤ z → R z ≤ q)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) (byDrawn R n)
      (continued R (holdingTo s y m n) n) :=
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  ⟨⟨continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long),
    continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩,
   fun b ⟨opens, keeps⟩ more => by
    have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
    rw [opens.1] at kept
    exact Nat.not_le_of_gt more
      (Naturals.le_of_add_le_add_right (Nat.le_trans kept (Nat.le_of_eq most.symm)))⟩

/-- **What keeping forgoes grows with the horizon.** Where `q < r`, every coupling `w` that with an
end `e` is below the horizon with the need is below what keeping forgoes against the course leaving
`e`, `(r - q) n + m - e`, stated as `w + q n + e < r n + m`. -/
theorem forgone_grows {w e : Nat} (less : q < r) (short : w + e < n + m) :
    w + q * n + e < r * n + m :=
  have grows : q * n + n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (Nat.succ_mul q n).symm)
      (Nat.mul_le_mul_right n (Nat.succ_le_of_lt less))
  calc w + q * n + e = q * n + (w + e) := by rw [Nat.add_right_comm, Nat.add_comm (w + e)]
    _ < q * n + (n + m) := Nat.add_lt_add_left short _
    _ = q * n + n + m := (Nat.add_assoc _ _ _).symm
    _ ≤ r * n + m := Nat.add_le_add_right grows m

/-- **A coupling below what keeping forgoes leaves no optimum keeping the need.** Where `R` gives
`r` at `y`, within the start with what is given there, over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y` and `y` with `r` down to some `e` at most
`y`, and `R` gives at most `q` at every level at or above `m`: every optimum, among the open
courses, of every order rising with a worth at least what a course draws and at most `w` more for a
course keeping its level at `m` or above falls below `m` within the horizon, where
`w + q n + e < r n + m`. -/
theorem frontier_breaks_below {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := by
  intro keeps
  have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
    continued_open (x := holdingTo s y e n) rfl
      (holdingTo_steps greatest reach settles drawsDown holds long)
  have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + r * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach settles n
  have kept := keeping_drawn_le above (fun t => (front.1.2 t).1) keeps
  rw [front.1.1] at kept
  exact front.2 _ opens
    (rising x _ (lt_of_forgone_below (coupled x front.1 keeps) kept most (draws _) below))

/-- **An optimum falling below the need.** Where `R` gives at most `r` at every level, under the
premises of `frontier_breaks_below` with the course ending at nothing, and for a worth adding
nothing to what a course standing below `m` within the horizon draws: the course holding `y` to the
`n`-th step, at nothing after the last and drawing nothing after it, is an optimum, among the open
courses, of the order by the worth. -/
theorem continued_breaking_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b) (continued R (holding s y n) n) :=
  have most : drawnOver R (continued R (holding s y n) n) (n + 1) = s + R s + r * n :=
    continued_drawn.trans (holding_most renews greatest reach n)
  ⟨continued_open (x := holding s y n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long),
   fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
      rw [opens.1] at kept
      exact Nat.le_of_lt (lt_of_forgone_below (e := 0) (coupled b opens keeps) kept
        ((Nat.add_zero _).trans most) (draws _) below)
    | .inr ⟨t, le, lt⟩ => Nat.le_trans (uncoupled b t opens le lt)
        (Nat.le_trans (open_le_most renews opens n)
          (Nat.le_trans (Nat.le_of_eq most.symm) (draws _))))⟩

/-- **A coupling beyond what keeping forgoes leaves no optimum falling below the need.** Where `R`
gives at most `r` at every level and `q` at some `y` within the start with what is given there, from
a start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q` down to some `e` between `m` and `y`: every optimum, among
the open courses, of every order rising with a worth adding at least `w` to what a course keeping
its level at `m` or above draws and nothing to what a course falling below `m` within the horizon
draws keeps its level at `m` or above through the horizon, where `r n + e < w + q n`. -/
theorem frontier_keeps_above {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  fun t le => match Nat.lt_or_ge (x t) m with
  | .inr ge => ge
  | .inl lt => by
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e =
        s + R s + q * n := by
      rw [continued_drawn]
      exact holdingTo_most greatest reach settles n
    exact absurd (rising x _ (lt_of_forgone_beyond (uncoupled x t front.1 le lt)
      (open_le_most renews front.1 n) most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      beyond)) (front.2 _ opens)

/-- **An optimum keeping the need.** Where `R` gives at most `r` at every level, at most `q` at
every level at or above `m`, and `q` at some `y` at or above `m` within the start with what is given
there, from a start meeting `m`, over a horizon of at least two steps, with a capacity covering what
the first step draws down to `y` and `y` with `q` down to `m`, and for a worth adding exactly `w` to
what a course keeping its level at `m` or above draws and nothing to what a course standing below
`m` within the horizon draws, where `r n + m < w + q n`: the course holding `y` to the `n`-th step,
at `m` after the last and drawing nothing after it, is an optimum, among the open courses, of the
order by the worth. -/
theorem continued_kept_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (beyond : r * n + m < w + q * n)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  have least := coupled _ optimum.1.1 optimum.1.2
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) w) least)
    | .inr ⟨t, le, lt⟩ => Nat.le_of_lt (lt_of_forgone_beyond (uncoupled b t opens le lt)
        (open_le_most renews opens n) most least beyond))⟩

end Optimum

namespace Flow

open Optimum

variable {L : Flow F C} {W : Web F C} {c : C}

/-- **What a balanced course keeping a need takes.** Where what is given to a condition is a law
`R` of its level, at most `q` at every level at or above `m`, and the course of its levels keeps
them at `m` or above through `n + 1` steps, what is taken there across them, with `m`, is at most
the starting level with what is given there and `q` for each step after. -/
theorem Balances.keeping_taken_le {R : Nat → Nat} {q m n : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (above : ∀ z, m ≤ z → R z ≤ q)
    (keeps : Optimum.Keeps m n fun t => W.level t c) :
    Amounts.whole.sum (fun t => L.taken t c) 0 (n + 1) + m ≤
      W.level 0 c + R (W.level 0 c) + q * n :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + m) (sum_eq_of_eq fun t _ =>
      ((congrArg (fun z => W.level t c + z - W.level (t + 1) c) (renewal t)).symm.trans
        (balances.drawnAt_eq c t)).symm)))
    (keeping_drawn_le above (fun t => Nat.le_trans (balances.within c t)
      (Nat.le_of_eq (congrArg (W.level t c + ·) (renewal t)))) keeps)

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k q r s y m n w e : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop} {worth : (Nat → Nat) → Nat}

/-- **Among the courses keeping a dependence, the optima leave exactly its need.** Under the
premises of `Optimum.frontier_keeps`, with a formation's need on the condition `m` at the horizon's
last step: every optimum, among the open courses keeping the condition at `m` or above through the
horizon, of every order rising with what is drawn stands at exactly the need after the last step,
and where `R` gives `q` at every step to the `n`-th. -/
theorem frontier_keeps (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    (front : Frontier (fun a => OpenCourse R k s a ∧ Optimum.Keeps m n a) better
      fun t => W.level t c)
    (need : W.need (n + 1) f c = m) :
    W.level (n + 1) c = W.need (n + 1) f c ∧ ∀ t, t < n → R (W.level (t + 1) c) = q :=
  have held := Optimum.frontier_keeps above rising greatest needs meets reach drawsDown holds long
    front
  ⟨held.1.trans need.symm, held.2⟩

/-- **A coupling below what keeping forgoes breaks the dependence within the horizon.** Under the
premises of `Optimum.frontier_breaks_below`, with a formation depending on the condition at the need
`m` at every step, met at the start: every optimum, among the open courses, of every order rising
with a worth at least what a course draws and at most `w` more for a course keeping the condition at
`m` or above breaks the dependence at some step to the `n`-th, where `w + q n + e < r n + m`. -/
theorem frontier_breaks_below
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start)
      (Optimum.frontier_breaks_below rising draws coupled above below greatest reach settles
        drawsDown holds long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

/-- **Far-sight breaks a dependence above every level of greatest renewal against every coupling
short of the horizon.** Under the premises of `Web.frontier_breaks_below`, where the renewal at or
above the need is below the greatest, `q < r`, and the coupling with the end `e` is below the
horizon with the need: every optimum breaks the dependence within the horizon. -/
theorem frontier_breaks_long
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (less : q < r) (short : w + e < n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  Web.frontier_breaks_below rising draws coupled above (forgone_grows less short) greatest reach
    settles drawsDown holds long front depends need start

/-- **A coupling beyond what keeping forgoes keeps the dependence through the horizon.** Under the
premises of `Optimum.frontier_keeps_above`, with a formation's need on the condition `m` at every
step: every optimum, among the open courses, of every order rising with a worth adding at least `w`
to what a course keeping the condition at `m` or above draws and nothing to what a course falling
below `m` within the horizon draws meets the need at every step through the horizon, where
`r n + e < w + q n`. -/
theorem frontier_keeps_above
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_above rising coupled uncoupled renews beyond greatest meets ends reach
      settles drawsDown holds long front t le)

end Web

namespace Optimum

namespace Holding

open Diversion

/-- One where a course stands at `m` or above at every step to the `T`-th, nothing otherwise. -/
def metThrough (m : Nat) (x : Nat → Nat) : Nat → Nat
  | 0 => if m ≤ x 0 then 1 else 0
  | t + 1 => if m ≤ x (t + 1) then metThrough m x t else 0

/-- A course standing at `m` or above at every step to the `T`-th is met through it. -/
theorem metThrough_of_keeps {m : Nat} {x : Nat → Nat} :
    ∀ {T : Nat}, (∀ t, t ≤ T → m ≤ x t) → metThrough m x T = 1
  | 0, keeps => show (if m ≤ x 0 then 1 else 0) = 1 from if_pos (keeps 0 (Nat.le_refl 0))
  | T + 1, keeps => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 1 from
      (if_pos (keeps (T + 1) (Nat.le_refl _))).trans
        (metThrough_of_keeps fun t le => keeps t (Nat.le_succ_of_le le))

/-- A course below `m` at some step to the `T`-th is not met through it. -/
theorem metThrough_of_below {m : Nat} {x : Nat → Nat} :
    ∀ {T t : Nat}, t ≤ T → x t < m → metThrough m x T = 0
  | 0, t, le, lt => show (if m ≤ x 0 then 1 else 0) = 0 from
      if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m)
        (Nat.le_antisymm le (Nat.zero_le t)) lt))
  | T + 1, _, le, lt => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 0 from
    match le_or_eq_succ le with
    | .inl earlier => match Nat.lt_or_ge (x (T + 1)) m with
      | .inl below => if_neg (Nat.not_le_of_gt below)
      | .inr meets => (if_pos meets).trans (metThrough_of_below earlier lt)
    | .inr last => if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m) last lt))

/-- What a course draws across `n + 1` steps under `R`, with `w` where it stands at `m` or above at
every step through them. -/
def coupledDraw (R : Nat → Nat) (m w n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + w * metThrough m x (n + 1)

/-- A course keeping its level at `m` or above through the horizon adds `w` to what it draws. -/
theorem coupledDraw_of_keeps {R : Nat → Nat} {m w n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    coupledDraw R m w n x = drawnOver R x (n + 1) + w :=
  congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_keeps keeps)).trans (Nat.mul_one w))

/-- A course standing below `m` at some step through the horizon adds nothing to what it draws. -/
theorem coupledDraw_of_below {R : Nat → Nat} {m w n t : Nat} {x : Nat → Nat} (le : t ≤ n + 1)
    (below : x t < m) : coupledDraw R m w n x = drawnOver R x (n + 1) :=
  (congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_below le below)).trans (Nat.mul_zero w))).trans
      (Nat.add_zero _)

/-- The levels with the source along a course and the store empty. -/
def onSource (x : Nat → Nat) (t : Nat) : Place → Nat
  | .source => x t
  | .store => 0

/-- Under the logistic law nothing is renewed at two or above. -/
theorem logistic_above : ∀ z, 2 ≤ z → logistic z ≤ 0 := fun _ le =>
  match le_dest le with
  | ⟨j, same⟩ => Nat.le_of_eq ((congrArg logistic (same.trans (Nat.add_comm 2 j))).trans
      (logistic_beyond j))

/-- **The logistic witness: what keeping the dweller forgoes.** From a source at two, the level the
dweller needs, under the logistic law with capacity two, keeping the dweller through `n + 2` steps
forgoes `n + 3`. Under the order by what the taker draws with `w` added where the source stays at
two or above through the horizon: where `w < n + 3`, the course drawing the source to one and then
holding it there has the greatest worth (`continued_breaking_frontier`) and every optimum breaks
the dweller's dependence within the horizon (`Web.frontier_breaks_below`); where `n + 3 < w`, the
course staying at two has the greatest worth (`continued_kept_frontier`) and every optimum keeps the
dependence met through the horizon (`Web.frontier_keeps_above`). -/
theorem logistic_coupled (n w : Nat) :
    (w < n + 3 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holding 2 1 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) ∧
    (n + 3 < w →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) :=
  have draws : ∀ a, drawnOver logistic a (n + 1 + 1) ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ => Nat.le_add_right _ _
  have bounded : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + w :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps)
  have coupled : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      drawnOver logistic a (n + 1 + 1) + w ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps).symm
  have uncoupled : ∀ a t, OpenCourse logistic 2 2 a → t ≤ n + 1 + 1 → a t < 2 →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) :=
    fun _ _ _ le below => Nat.le_of_eq (coupledDraw_of_below le below)
  ⟨fun short =>
    have below : w + 0 * (n + 1) < 1 * (n + 1) + 2 := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact short
    ⟨continued_breaking_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 1) (q := 0) (r := 1) draws bounded uncoupled logistic_le logistic_above below rfl
      (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_breaks_below (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 1) (q := 0) (r := 1) (e := 0)
        (fun _ _ less => less) draws bounded logistic_above below rfl (Nat.le_succ 1)
        (Nat.zero_le 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front
        (fun _ => trivial) (fun _ => rfl) (Nat.le_refl 2)⟩,
   fun beyond' =>
    have beyond : 1 * (n + 1) + 2 < w + 0 * (n + 1) := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact beyond'
    ⟨continued_kept_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) coupled bounded uncoupled logistic_le logistic_above beyond rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
      (Nat.le_add_right 2 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_keeps_above (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 2) (q := 0) (r := 1) (e := 2)
        (fun _ _ less => less) coupled uncoupled logistic_le
        (Nat.le_trans (Nat.le_of_eq (Nat.add_zero _)) beyond) rfl (Nat.le_refl 2)
        (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩⟩

end Holding

end Optimum

end Becoming
