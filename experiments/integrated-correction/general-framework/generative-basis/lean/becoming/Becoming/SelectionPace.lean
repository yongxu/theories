import Becoming.Reproduction
import Becoming.Entropy

/-!
# Selection pace: how far selection moves a mean, within what flows in

`Becoming.Reproduction` bounds offspring numbers by what the flow gives and takes and, in a family
closed to inflow and dissipated on, ends a lineage, so that read by offspring number transmission
must at some step lower offspring number by more than selection and what transmission raised
together (`Reproduction.Flow.closed_lineage_lowered`). `Becoming.Entropy` bounds a family's rise
by its inflow, what each formation taking part gives it beyond what it takes from it
(`Flow.inflow`, `Flow.replenishment_le_inflow`). Price's equation and Fisher's step, in their
counting forms (`Becoming.price`, `SelectionTerm.Generations.mean_step`,
`Reproduction.Generations.ByNumber.step`), admit every pace: they are identities over offspring
counts, and the counts are free. This module joins the two modules to bound the pace of
selection, across a step and over a stretch, where each offspring stands at `m` or more after the
step that brings it to stand (its least standing) and, where stated, each parent stands at no
more than `m`. Each bound needs balance only on the family the lineage occupies across the step.
The module is a leaf: it joins two modules neither of which imports the other, and nothing below
needs it.

* **Offspring within what stood and what flowed in.** Across a step, list some relata and then
  the offspring of some parents, each offspring coming to stand across the step at `m` or more,
  the flow balancing on the list. The offspring, `m` for each, with what the first part stands at
  after the step, are at most what the first part stood at before and the list's inflow
  (`born_within_inflow`). Read on a parent and its offspring (`lineage`): its offspring number
  times `m` is at most what the parent stood at and what flowed into its lineage
  (`parent_within_inflow`); read on a generation and the next: the next generation's size times
  `m` is at most what the generation stood at and what flowed into it and its offspring
  (`generation_within_inflow`). So, each parent standing at no more than `m`, each offspring
  beyond one for each parent is fed by `m` units flowing into its lineage at its own step
  (`parent_within_factor`). A member of the next generation standing at `m` or more after the
  step that brings it to stand, and at no more than `m` then as a parent, stands at exactly `m`
  (`standing_pinned`): over a stretch of `T` steps whose parents each stand at no more than `m`,
  the members of generations `1` to `T - 1` stand at exactly the least, and those of generation
  `T` do where they stand at no more than `m` too. The least standing is a supplied level; where
  activity needs support (`Web.Dependent`), a relatum active at a step that requires its own
  standing then at need `m` or more stands at `m` or more (`stands_of_need`).
* **The response of a carried amount.** Count, for an amount read of each parent, what flows into
  each parent's lineage, summed lineage by lineage and weighted by the amount (`carriedInflow`):
  what passes between carrying lineages counts as inflow into the receiver and is not netted
  against the giver, so it is at least the inflow into the carriers' joint lineage
  (`joint_within_carried`; in `Swap` two against none). With exact transmission the next
  generation's total of the amount is the parents' amounts weighted by their offspring numbers
  (`sum_exact`), so `m` times it is at most the parents' standings weighted by their amounts with
  the carried inflow (`offspring_within_carried`). Where each parent stands at no more than `m`,
  `m` times the next total is at most `m` times this one with the carried inflow
  (`total_within_carried`): the total rises by at most the carried inflow over `m`. Where the
  population is not shrinking as well, `m` times the mean's rise, cross-multiplied, is at most the
  size times the carried inflow (`response_within_carried`), and since with exact transmission
  that rise is the selection term proper (`mean_step_exact`), `m` times the concordance is at most
  `m` times the discordance with the size times the carried inflow (`selection_within_carried`).
  Divided through: the mean of an exactly transmitted amount rises across a step by at most the
  carried inflow over `m` times the next generation's size.
* **The carriers and the rest of the whole.** For an amount of zero or one, its carriers listed as
  in the generation (`carriers`): `m` times the next total, with what the rest of a family stands
  at after the step, is at most `m` times this total with what the rest stood at before and the
  inflow into the carriers, the rest and the carriers' offspring (`share_within_rest`). Read with
  the rest of a whole, the carriers' rise is within what the rest falls by and what flows into the
  whole: the law that a rise past the inflow is drawn from beyond
  (`Flow.Balances.rise_le_inflow_beyond` and `Flow.Balances.rise_paid_from_beyond` in
  `Becoming.SelectionReach`, `Flow.Balances.rise_lowers_beyond` in `Becoming.DrawnBeyond`), read
  on offspring. With no rest, the total rises by at most the inflow into the carriers' joint
  lineage over `m` (`share_within_joint`).
* **A rise nothing feeds shrinks the population.** Each parent standing at no more than `m` and
  nothing flowing into the lineages carrying the amount, a rise of its mean across a step leaves
  the next generation smaller than this one (`unfed_rise_shrinks`).
* **Over a stretch.** Over a stretch of steps each meeting these premises, `m` times the final
  total is at most `m` times the first with the carried inflow over the stretch
  (`stretch_within_carried`); where the final generation is no smaller than the first, `m` times
  the mean's move, cross-multiplied, is at most the first size times the stretch's carried inflow
  (`moved_within_carried`); and where each step carries at most `I`, it is at most the first size
  times `T · I` (`steps_to_move`). This is a linear bound from a cap on the total: moving the
  share of an amount of zero or one from `p₀` to the whole at constant size `N` needs a carried
  inflow of at least `m · N · (1 - p₀)` over the stretch, which is at most `m · N` whatever `p₀`
  is.
* **A cap on each parent.** Where `m` is positive, each parent stands at no more than `m` and what
  flows into its lineage, with `m`, is at most `k · m` (the inflow at most `(k - 1) · m`), it
  leaves at most `k` offspring (`parent_within_factor`), so an exactly transmitted total
  multiplies by at most `k` a step (`total_within_factor`) and by at most `k ^ T` over `T` steps
  (`total_within_power`). Where the population is not shrinking, the share multiplies by at most
  `k ^ T` (`share_within_power`), and a final total reaching the final size needs the first size
  to be at most `k ^ T` times the first total (`whole_within_power`): one substitution, from `c`
  carriers among `N` to the whole, takes `T ≥ log_k (N / c)` steps, growing with the logarithm of
  the inverse of the starting share. The premises are asked of every parent, though a parent
  whose amount is nothing adds nothing to the total before or after the step; asking them of the
  carriers alone is left open here.
* **Offspring number.** Read by offspring number with exact transmission across a step, `m` times
  the next size squared with the squared differences of offspring numbers over pairs is at most this
  size times what the next generation stands at and what flows into it and its offspring
  (`number_step_within_inflow`). Where each member of the next generation stands at no more than `m`
  and the population is not shrinking, `m` times those squared differences is at most the size times
  that inflow (`number_spread_within_inflow`): divided through, the variance of offspring number,
  which Fisher's theorem turns into the rise of the mean offspring number (the variance over the
  mean), is at most the inflow per member over `m`. With nothing flowing in, offspring numbers are
  uniform (`number_unfed_uniform`). Where, besides an amount, offspring number is itself transmitted
  exactly, the response of the amount across a step, cross-multiplied and squared, times `m`, is at
  most the size times the inflow into the next generation and its offspring at the next step times
  the amount's squared differences over pairs (`response_sq_within_inflow`, reading the generations
  by offspring number, `numbered`): with offspring number inherited, its variance at one step is
  growth at the next, and that growth is what the next step's inflow feeds. With the inflow of the
  step itself in its place the bound fails even with offspring number inherited
  (`Inherited.same_step_fails`), and without inheritance the next-step form fails too
  (`Displacement.spread_needs_inheritance`).
* **The natural statement fails.** The pace is not bounded by what flows into the whole or into
  the population's own lineage. In `Displacement`, a family closed, balanced and dissipated on, its
  inflow nothing and the population's size staying at two, the carriers' share rises from a half
  to the whole in one step; the population's own lineage, members and offspring without the pool,
  gains nothing either, and the response law with either inflow in place of the carried inflow
  fails (`Displacement.natural_fails`). The carrier's lineage rises by one while the rest of the
  whole, the pool and the other member, falls by two (`Displacement.rest_falls`).
* **Where the bounds are equalities.** Each response law is the stock law of the carrying lineages
  under the per-member bounds. The law of the total is an equality where the carrying parents
  stand at `m` before the step and at nothing after it, their offspring stand at `m`, and no
  formation takes more from a carrying lineage than it gives to it; the response and selection
  laws are equalities where besides the population's size stays. The witnesses are instances:
  `Displacement` of the response and selection laws (`Displacement.displacement`) and of the
  factor law with `k` two (`Displacement.factor`), `Inherited` of the stretch law over two steps
  and of the next-step law (`Inherited.stretch_attained`, `Inherited.next_step_attained`), and
  `Fed` of the step and spread laws of offspring number (`Fed.fed`). The premises hold of each
  (`Displacement.premises`, `Fed.premises`, and the laws' instances in `Inherited`);
  `Displacement.least` and `Fed.least` read the laws at fixed counts. Without parents standing at
  no more than `m` (`Uncapped`), or with the population shrinking (`Shrink`), the response law
  fails.

So the identities of Price and Fisher admit a pace the flow forbids. Under balance, with each
offspring standing at `m` and each parent at no more than `m`, the mean of an exactly transmitted
amount rises in a population not shrinking only as far as what flows into the lineages carrying
it allows, `m` units for each unit gained; with a cap on what flows into each parent's lineage the
share multiplies by at most a power of the cap; and the variance of offspring number, read with
exact transmission, is at most the inflow per member over `m`. A rise nothing feeds shrinks the
population.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- Malthus (1798), the main neighbour: reproduction is limited by what sustains it.
  `born_within_inflow` is that limit read on standing and inflow, and the response laws read it
  on the lineages carrying an amount.
- Haldane (1957, *J. Genetics* 55) put the cost of a substitution at a total of selective deaths,
  growing with the logarithm of the inverse of the starting frequency, and drew from it a limit on
  the rate of substitution; Nei (1971) and Felsenstein (1971) restated the limit from a
  reproductive excess, each parent leaving at most `k` offspring, so that substitutions are at
  least `ln (1 / p₀) / ln k` generations apart. `whole_within_power` bounds the steps one
  substitution takes from `p₀` under a cap on what flows into each parent's lineage,
  `T ≥ log_k (N / c)` from `c` carriers among `N`: the one-substitution form behind their limit,
  in counts. It is not the spacing of successive substitutions, which is not derived: with exact
  transmission a lineage carries all its amounts together, so two amounts starting in the same
  carriers reach the whole together. Haldane's cost itself is not modelled: the generations list
  only offspring that come to stand, and none is culled. `steps_to_move` is a linear bound from a
  cap on the total, the Malthusian bound read on the carrying lineages, and not Haldane's cost.
- Price (1970, *Nature* 227): the change of a mean is the selection term with the transmission
  term, an identity admitting every count; with exact transmission the response is the selection
  term (`mean_step_exact`), and the flow bounds it (`selection_within_carried`).
- Fisher (1930): with exact transmission the mean offspring number rises by the variance of
  offspring number over its mean (`Reproduction.Generations.ByNumber.step`), and rises exactly
  where offspring numbers differ (`Reproduction.Generations.ByNumber.rises_exact_iff`); the flow
  bounds that variance by the inflow per member over `m` (`number_spread_within_inflow`). Fisher
  left the rest to "the deterioration of the environment", which Price (1972, *Ann. Hum. Genet.*
  36) read as the transmission term; with nothing flowing into a population not shrinking whose
  members stand at no more than `m`, exact transmission of offspring number allows no variance in
  it (`number_unfed_uniform`): density regulation of heritable variance in fitness, in counts.
- Wallace (1975, *Evolution* 29): in `Displacement` the carriers' gain is a zero-sum draw within a
  closed whole, what one lineage gains the rest loses: the setting of Wallace's soft selection. It
  is a reading: one step of a supplied flow cannot show how a population's output responds to its
  composition.
- Smith and Fretwell (1974, *Am. Nat.* 108): `parent_within_inflow` is the budget constraint of
  their model read on standing and inflow, with offspring size fixed at `m` (its premise; its
  result, the best offspring size, is not read).

What is not derived: that offspring stand at a least amount `m`, that parents stand at no more
than `m`, that transmission is exact or that a population is not shrinking (premises, stated where
used); a bound by the inflow into the whole family or into the population's own lineage, which is
false (`Displacement.natural_fails`); Haldane's cost in selective deaths; the carriers' joint law
for an amount above one; how long exact transmission of offspring number with growth can last
within a bounded inflow, whose closed case is `Reproduction.Flow.closed_lineage_lowered`; drift
and mutation. Dissipation is not used. Dissipation on the lineage's own family would leave it no
inflow (`Flow.DissipatesOn.gainlessOn`, `Flow.gainlessOn_iff_inflow`), the case dissipated on
that `Reproduction.Flow.born_within_stock` treats; dissipation on a wider family does not tighten
these bounds: `Displacement` is dissipated on its whole family and attains the response and
selection laws. The spacing of successive substitutions is not derived. Modelling choices:
natural-number amounts and standings, discrete steps, generations each listed as the offspring of
the last, each offspring coming to stand across its step; the least standing `m` is a supplied
level, tied to the web's `need` only through `stands_of_need`; a lineage's family is listed as the
parents and then their offspring and may repeat a relatum (a parent among offspring, or one
offspring under two parents), the bounds holding all the same, while reading its inflow as the
lineage's own needs the listing without repetition. No ethical predicate, ranking or axiom occurs;
every declaration has an empty axiom report.
-/

namespace Becoming

namespace SelectionPace

open SelectionTerm

variable {X : Type} {L : Flow X X} {W : Web X X}

/-! ## Offspring within what stood and what flowed in -/

/-- Parents and their offspring across a step, listed together: the family a lineage occupies
across one step. -/
def lineage (ps : List X) (kids : X → List X) : List X := ps ++ ps.flatMap kids

/-- The lineage of some parents lies within the lineage of any list holding each of them. -/
theorem lineage_mono {cs ps : List X} {kids : X → List X} (sub : ∀ p, p ∈ cs → p ∈ ps) :
    ∀ c, c ∈ lineage cs kids → c ∈ lineage ps kids :=
  fun c mc => match mem_append_cases mc with
    | .inl here => mem_append_of_left _ (sub c here)
    | .inr there => match Reproduction.mem_flatMap_cases there with
      | ⟨p, mp, mk⟩ => mem_append_of_right _ (ListTests.mem_flatMap_iff.mpr ⟨p, sub p mp, mk⟩)

/-- A parent's lineage lies within the lineage of any list of parents it belongs to. -/
theorem lineage_sub {p : X} {ps : List X} {kids : X → List X} (mp : p ∈ ps) :
    ∀ c, c ∈ lineage [p] kids → c ∈ lineage ps kids :=
  lineage_mono fun _ mq => match mem_cons_cases mq with
    | .inl same => Eq.subst (motive := fun x => x ∈ ps) same.symm mp
    | .inr no => nomatch no

/-- Offspring coming to stand across a step stood at nothing before it. -/
theorem fresh_total {t : Nat} {ps : List X} {kids : X → List X}
    (arise : ∀ p k, p ∈ ps → k ∈ kids p → W.ComesToStand t k) :
    total (ps.flatMap kids) (W.level t) = 0 :=
  total_eq_zero fun k mk => match Reproduction.mem_flatMap_cases mk with
    | ⟨p, mp, mkp⟩ => eq_zero_of_not_pos (arise p k mp mkp).1

/-- Offspring standing at `m` or more after the step total at least `m` for each. -/
theorem standing_total {t m : Nat} {ps : List X} {kids : X → List X}
    (stands : ∀ p k, p ∈ ps → k ∈ kids p → m ≤ W.level (t + 1) k) :
    m * born ps kids ≤ total (ps.flatMap kids) (W.level (t + 1)) :=
  Nat.le_trans
    (Nat.le_of_eq ((congrArg (m * ·) (Reproduction.born_flatMap ps kids)).trans
      ((Nat.mul_comm _ _).trans (total_const m (ps.flatMap kids)).symm)))
    (total_le _ fun k mk => match Reproduction.mem_flatMap_cases mk with
      | ⟨p, mp, mkp⟩ => stands p k mp mkp)

/-- **Offspring within what stood and what flowed in.** Across a step at which the flow balances
on a list of some relata (`es`) followed by the offspring of some parents, each offspring coming to
stand across the step at `m` or more: the offspring, `m` for each, with what the first part stands
at after the step, are at most what the first part stood at before and the list's inflow. From the
balance on the list (`Flow.BalancesOn.over`) and what is given being at most what is taken with
the inflow (`Flow.replenishment_le_inflow`). The step from the balance to the stock is Entropy's
stock law (`Flow.Balances.stock_inflow`, stated for a balanced flow) on a list balanced on,
re-derived here unnamed; a balanced-on form in `Becoming.Entropy` would be its home. It is a
sibling of `Reproduction.Flow.born_within_stock` (distinct offspring anywhere in a family balanced
and dissipated on), and neither derives the other in the pure core: that law needs the offspring
distinct, this one lists them after `es`. -/
theorem born_within_inflow {t m : Nat} {es ps : List X} {kids : X → List X}
    (balanced : L.BalancesOn W (es ++ ps.flatMap kids) t)
    (arise : ∀ p k, p ∈ ps → k ∈ kids p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ ps → k ∈ kids p → m ≤ W.level (t + 1) k) :
    m * born ps kids + total es (W.level (t + 1)) ≤
      total es (W.level t) + L.inflow (es ++ ps.flatMap kids) t :=
  have after : m * born ps kids + total es (W.level (t + 1)) ≤
      W.stock (es ++ ps.flatMap kids) (t + 1) :=
    Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
      (Nat.le_trans (Nat.add_le_add_left (standing_total stands) _)
        (Nat.le_of_eq (total_append (W.level (t + 1)) (ps.flatMap kids) es).symm))
  have rises : W.stock (es ++ ps.flatMap kids) (t + 1) ≤
      W.stock (es ++ ps.flatMap kids) t + L.inflow (es ++ ps.flatMap kids) t :=
    le_of_add_le_add_right (L.uptake (es ++ ps.flatMap kids) t)
      (Nat.le_trans (Nat.le_of_eq balanced.over)
        (Nat.le_trans (Nat.add_le_add_left (L.replenishment_le_inflow _ t) _)
          (Nat.le_of_eq ((congrArg (W.stock (es ++ ps.flatMap kids) t + ·)
            (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm))))
  have before : W.stock (es ++ ps.flatMap kids) t = total es (W.level t) :=
    (total_append (W.level t) (ps.flatMap kids) es).trans
      ((congrArg (total es (W.level t) + ·) (fresh_total arise)).trans (Nat.add_zero _))
  Nat.le_trans after (Nat.le_trans rises
    (Nat.le_of_eq (congrArg (· + L.inflow (es ++ ps.flatMap kids) t) before)))

/-- **A parent's offspring within what it stood at and what flowed into its lineage.** Across a
step at which the flow balances on a parent and its offspring, each offspring coming to stand at
`m` or more: the offspring number times `m` is at most what the parent stood at before the step
and the inflow into its lineage. -/
theorem parent_within_inflow {t m : Nat} {p : X} {kids : X → List X}
    (balanced : L.BalancesOn W (lineage [p] kids) t)
    (arise : ∀ k, k ∈ kids p → W.ComesToStand t k)
    (stands : ∀ k, k ∈ kids p → m ≤ W.level (t + 1) k) :
    m * (kids p).length ≤ W.level t p + L.inflow (lineage [p] kids) t :=
  have only : ∀ {q k : X}, q ∈ [p] → k ∈ kids q → k ∈ kids p := fun mq mk =>
    match mem_cons_cases mq with
    | .inl same => Eq.subst (motive := fun x => _ ∈ kids x) same mk
    | .inr no => nomatch no
  Nat.le_trans (Nat.le_add_right _ (total [p] (W.level (t + 1))))
    (born_within_inflow (es := [p]) (ps := [p]) balanced
      (fun _ k mq mk => arise k (only mq mk)) (fun _ k mq mk => stands k (only mq mk)))

/-- **The next generation within what this one stood at and what flowed in.** Across a step at
which the flow balances on a generation and its offspring, each offspring coming to stand at `m`
or more: the next generation's size times `m` is at most what the generation stood at and the
inflow into it and its offspring. -/
theorem generation_within_inflow {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k) :
    m * G.size (t + 1) ≤
      total (G.family t) (W.level t) + L.inflow (lineage (G.family t) (G.kids t)) t :=
  Nat.le_trans (Nat.le_trans (Nat.le_of_eq (congrArg (m * ·) (G.born_eq t).symm))
      (Nat.le_add_right _ _))
    (born_within_inflow (es := G.family t) balanced arise stands)

/-- **A member of the next generation standing at no more than `m` stands at exactly `m`.** Where
each offspring of a generation stands at `m` or more after the step and each member of the next
generation stands at no more than `m` then, each member of the next generation stands at exactly
`m`. Over a stretch of `T` steps, with offspring standing at `m` or more after each step and
parents standing at no more than `m` at each step before `T`, the members of generations `1` to
`T - 1` stand at exactly `m`; those of generation `T` do only where they stand at no more than `m`
too. -/
theorem standing_pinned {G : Generations X} {t m : Nat}
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (capped : ∀ p, p ∈ G.family (t + 1) → W.level (t + 1) p ≤ m) :
    ∀ k, k ∈ G.family (t + 1) → W.level (t + 1) k = m :=
  fun k mk => match Reproduction.mem_flatMap_cases mk with
    | ⟨p, mp, mkp⟩ => Nat.le_antisymm (capped k mk) (stands p k mp mkp)

/-- **The least standing from a dependence.** In a web where a formation is active only where the
conditions it then depends on support it (`Web.Dependent`), a relatum active at a step that
requires its own standing then, at need `m` or more, stands at `m` or more: the least standing can
follow from a dependence instead of being supplied. -/
theorem stands_of_need {s m : Nat} {k : X} (dependent : W.Dependent) (active : W.active s k)
    (requires : W.requires s k k) (need : m ≤ W.need s k k) : m ≤ W.level s k :=
  Nat.le_trans need (dependent s k active k requires)

/-! ## The response of a carried amount -/

/-- The inflow an amount carries across a step: what flows into each parent's lineage, summed
lineage by lineage and weighted by the parent's amount. What passes from one carrying lineage to
another counts as inflow into the receiver and is not netted against the giver, so it is at least
the inflow into the carriers' joint lineage (`joint_within_carried`). -/
def carriedInflow (L : Flow X X) (G : Generations X) (t : Nat) : Nat :=
  total (G.family t) fun p => G.amount t p * L.inflow (lineage [p] (G.kids t)) t

/-- With exact transmission the next generation's total is the parents' amounts weighted by their
offspring numbers (`price`, with nothing raised or lowered). -/
theorem sum_exact {G : Generations X} {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.sum (t + 1) = selected (G.family t) (G.kids t) (G.amount t) :=
  (G.offspring_eq t).symm.trans ((Nat.add_zero _).symm.trans
    ((congrArg (_ + ·) (lowered_exact exact).symm).trans
      ((price _ _ _ _).trans ((congrArg (_ + ·) (raised_exact exact)).trans (Nat.add_zero _)))))

/-- Price's step with exact transmission: the size times the next total, with the discordance, is
the next size times the total, with the concordance. The same rewrite of
`SelectionTerm.Generations.mean_step` is made inline in
`SelectionTerm.Generations.balanced_exact_iff`, `SelectionTerm.Generations.raises_exact_iff`,
`Reproduction.Generations.response_sq_le` and `Reproduction.Breeding.response`; this is its fifth
statement, and `SelectionTerm` would be its home. -/
theorem mean_step_exact {G : Generations X} {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.size t * G.sum (t + 1) + G.discordAt t = G.size (t + 1) * G.sum t + G.concordAt t := by
  have step := G.mean_step t
  unfold SelectionTerm.Generations.raisedAt SelectionTerm.Generations.loweredAt at step
  rw [raised_exact exact, lowered_exact exact, Nat.mul_zero, Nat.zero_add, Nat.add_zero] at step
  exact step

/-- **What an exactly transmitted amount's offspring total is within.** Across a step at which the
flow balances on the generation and its offspring, each offspring coming to stand at `m` or more,
with exact transmission: `m` times the next generation's total is at most the parents' standings
weighted by their amounts with the carried inflow. -/
theorem offspring_within_carried {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    m * G.sum (t + 1) ≤
      total (G.family t) (fun p => G.amount t p * W.level t p) + carriedInflow L G t :=
  Nat.le_trans
    (Nat.le_of_eq ((congrArg (m * ·) (sum_exact exact)).trans
      ((total_mul m _ _).symm.trans (total_congr (fun p =>
        (congrArg (m * ·) (Nat.mul_comm _ _)).trans (mul_turn m (G.amount t p) _)) _))))
    (Nat.le_trans
      (total_le _ fun p mp => Nat.le_trans
        (Nat.mul_le_mul_left (G.amount t p)
          (parent_within_inflow (fun c mc => balanced c (lineage_sub mp c mc))
            (fun k mk => arise p k mp mk) (fun k mk => stands p k mp mk)))
        (Nat.le_of_eq (Nat.left_distrib _ _ _)))
      (Nat.le_of_eq (total_add _ _ _)))

/-- **The total rises by at most the carried inflow over `m`.** Where besides each parent stands
at no more than `m` before the step: `m` times the next total is at most `m` times this one with
the carried inflow. -/
theorem total_within_carried {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m) :
    m * G.sum (t + 1) ≤ m * G.sum t + carriedInflow L G t :=
  Nat.le_trans (offspring_within_carried balanced arise stands exact)
    (Nat.add_le_add_right
      (Nat.le_trans (total_le _ fun p mp => Nat.mul_le_mul_left (G.amount t p) (capped p mp))
        (Nat.le_of_eq ((total_congr (fun p => Nat.mul_comm (G.amount t p) m) _).trans
          (total_mul m _ _))))
      _)

/-- **The pace of a mean.** Where the population is not shrinking as well: `m` times the mean's
rise across the step, cross-multiplied, is at most the size times the carried inflow. -/
theorem response_within_carried {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m)
    (sustained : G.size t ≤ G.size (t + 1)) :
    m * (G.size t * G.sum (t + 1)) ≤
      m * (G.size (t + 1) * G.sum t) + G.size t * carriedInflow L G t :=
  Nat.le_trans (Nat.le_of_eq (mul_turn m (G.size t) (G.sum (t + 1))))
    (Nat.le_trans (Nat.mul_le_mul_left (G.size t)
        (total_within_carried balanced arise stands exact capped))
      (Nat.le_trans (Nat.le_of_eq (Nat.left_distrib _ _ _))
        (Nat.add_le_add_right
          (Nat.le_trans (Nat.le_of_eq (mul_turn (G.size t) m (G.sum t)))
            (Nat.mul_le_mul_left m (Nat.mul_le_mul_right (G.sum t) sustained)))
          _)))

/-- **The pace of selection proper.** Under the same premises, the selection term proper is
bounded so: `m` times the concordance is at most `m` times the discordance with the size times the
carried inflow. -/
theorem selection_within_carried {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m)
    (sustained : G.size t ≤ G.size (t + 1)) :
    m * G.concordAt t ≤ m * G.discordAt t + G.size t * carriedInflow L G t :=
  have scaled : m * (G.size t * G.sum (t + 1)) + m * G.discordAt t =
      m * (G.size (t + 1) * G.sum t) + m * G.concordAt t :=
    (Nat.left_distrib _ _ _).symm.trans
      ((congrArg (m * ·) (mean_step_exact exact)).trans (Nat.left_distrib _ _ _))
  Naturals.le_of_add_le_add_left (k := m * (G.size (t + 1) * G.sum t)) (Nat.le_trans
    (Nat.le_of_eq scaled.symm)
    (Nat.le_trans
      (Nat.add_le_add_right
        (response_within_carried balanced arise stands exact capped sustained) _)
      (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
        (congrArg (m * (G.size (t + 1) * G.sum t) + ·) (Nat.add_comm _ _))))))

/-- **A rise nothing feeds shrinks the population.** With `m` positive, each parent standing at no
more than `m` and nothing flowing into the lineages carrying the amount, a rise of its mean across
the step leaves the next generation smaller than this one. -/
theorem unfed_rise_shrinks {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m) (positive : 0 < m)
    (unfed : carriedInflow L G t = 0)
    (rises : G.size (t + 1) * G.sum t < G.size t * G.sum (t + 1)) :
    G.size (t + 1) < G.size t :=
  have within : G.sum (t + 1) ≤ G.sum t :=
    le_of_mul_le_mul positive
      (Nat.le_trans (total_within_carried balanced arise stands exact capped)
        (Nat.le_of_eq ((congrArg (m * G.sum t + ·) unfed).trans (Nat.add_zero _))))
  match Nat.lt_or_ge (G.size (t + 1)) (G.size t) with
  | .inl lt => lt
  | .inr ge => absurd (Nat.lt_of_lt_of_le rises
      (Nat.le_trans (Nat.mul_le_mul_left (G.size t) within) (Nat.mul_le_mul_right (G.sum t) ge)))
      (Nat.lt_irrefl _)

/-! ## The carriers and the rest of the whole -/

/-- The members of a generation carrying the amount: those at which it is not zero, listed as in
the generation. -/
def carriers (G : Generations X) (t : Nat) : List X :=
  (G.family t).filter fun p => nonzero (G.amount t p)

/-- A carrier is a member of its generation. -/
theorem mem_carriers {G : Generations X} {t : Nat} {p : X} (mp : p ∈ carriers G t) :
    p ∈ G.family t :=
  (ListTests.mem_filter_iff.mp mp).1

/-- A parent's lineage totals what the parent stands at and what its offspring stand at. -/
theorem total_lineage_one (q : X → Nat) (kids : X → List X) (p : X) :
    total (lineage [p] kids) q = q p + total (kids p) q :=
  congrArg (q p + ·) ((total_append q [] (kids p)).trans (Nat.add_zero _))

/-- The lineage of a list of parents totals as each parent's lineage, summed. -/
theorem total_lineage (q : X → Nat) (kids : X → List X) (ps : List X) :
    total (lineage ps kids) q = total ps fun p => total (lineage [p] kids) q :=
  (total_append q (ps.flatMap kids) ps).trans
    ((congrArg (total ps q + ·) (Generations.total_flatMap kids q ps)).trans
      ((total_add q (fun p => total (kids p) q) ps).symm.trans
        (total_congr (fun p => (total_lineage_one q kids p).symm) ps)))

/-- The excess of two sums is at most the sum of the excesses. -/
theorem excess_add_le (a b c d : Nat) : excess (a + b) (c + d) ≤ excess a c + excess b d :=
  excess_le_of_le_add
    (Nat.le_trans (Nat.add_le_add (le_add_excess a c) (le_add_excess b d))
      (Nat.le_of_eq (Nat.add_add_add_comm c (excess a c) d (excess b d))))

/-- The excess of two totals over a list is at most the total of the excesses. -/
theorem excess_total_le (g h : X → Nat) :
    ∀ ps : List X, excess (total ps g) (total ps h) ≤ total ps fun p => excess (g p) (h p)
  | [] => Nat.le_refl 0
  | p :: ps => Nat.le_trans (excess_add_le (g p) (total ps g) (h p) (total ps h))
      (Nat.add_le_add_left (excess_total_le g h ps) _)

/-- **What flows into a lineage is at most what flows into each parent's lineage, summed.** What a
formation gives to one parent's lineage and takes from another's is netted in the whole lineage
and counted in the sum. -/
theorem inflow_lineage_le (kids : X → List X) (ps : List X) (t : Nat) :
    L.inflow (lineage ps kids) t ≤ total ps fun p => L.inflow (lineage [p] kids) t :=
  Nat.le_trans
    (total_le (L.present t) fun f _ => Nat.le_trans
      (Nat.le_of_eq ((congrArg (excess · _) (total_lineage (L.give t f) kids ps)).trans
        (congrArg (excess _ ·) (total_lineage (L.take t f) kids ps))))
      (excess_total_le _ _ ps))
    (Nat.le_of_eq (total_swap (fun f p => excess (total (lineage [p] kids) (L.give t f))
      (total (lineage [p] kids) (L.take t f))) ps (L.present t)))

/-- The carriers' total of a quantity is at most the quantity weighted by the amount. -/
theorem total_carriers_le (a x : X → Nat) :
    ∀ ps : List X, total (ps.filter fun p => nonzero (a p)) x ≤ total ps fun p => a p * x p
  | [] => Nat.le_refl 0
  | p :: ps => by
    have rest := total_carriers_le a x ps
    show total (match nonzero (a p) with
        | true => p :: ps.filter fun p => nonzero (a p)
        | false => ps.filter fun p => nonzero (a p)) x ≤
      a p * x p + total ps fun p => a p * x p
    cases a p with
    | zero => exact Nat.le_trans rest (Nat.le_trans (Nat.le_add_left _ _)
        (Nat.le_of_eq (congrArg (· + _) (Nat.zero_mul (x p)).symm)))
    | succ n => exact Nat.add_le_add (Nat.le_trans (Nat.le_add_left (x p) (n * x p))
        (Nat.le_of_eq (Nat.succ_mul n (x p)).symm)) rest

/-- For an amount of zero or one, a quantity weighted by the amount totals as the carriers' total
of it. -/
theorem total_carriers_unit (a x : X → Nat) :
    ∀ ps : List X, (∀ p, p ∈ ps → a p ≤ 1) →
      total ps (fun p => a p * x p) = total (ps.filter fun p => nonzero (a p)) x
  | [], _ => rfl
  | p :: ps, unit => by
    have rest := total_carriers_unit a x ps fun q mq => unit q (.tail p mq)
    have here := unit p (.head ps)
    show a p * x p + total ps (fun p => a p * x p) = total (match nonzero (a p) with
        | true => p :: ps.filter fun p => nonzero (a p)
        | false => ps.filter fun p => nonzero (a p)) x
    revert here
    cases a p with
    | zero => exact fun _ =>
        (congrArg (· + _) (Nat.zero_mul (x p))).trans ((Nat.zero_add _).trans rest)
    | succ n =>
      cases n with
      | zero => exact fun _ =>
          (congrArg (· + _) (Nat.one_mul (x p))).trans (congrArg (x p + ·) rest)
      | succ n => exact fun le => absurd (Nat.le_of_succ_le_succ le) (Nat.not_succ_le_zero n)

/-- **The carriers' joint lineage draws at most the carried inflow.** Each carrier's amount is one
or more, so what flows into each carrying lineage, weighted by the amount and summed, is at least
what flows into the carriers' joint lineage, where what passes between carrying lineages is
netted. -/
theorem joint_within_carried (G : Generations X) (t : Nat) :
    L.inflow (lineage (carriers G t) (G.kids t)) t ≤ carriedInflow L G t :=
  Nat.le_trans (inflow_lineage_le (G.kids t) (carriers G t) t)
    (total_carriers_le (G.amount t) (fun p => L.inflow (lineage [p] (G.kids t)) t) (G.family t))

/-- **The carriers' rise within what the rest falls by and what flows in.** For an amount of zero
or one, across a step at which the flow balances on the carriers, some other relata (`rs`) and the
carriers' offspring, each offspring coming to stand at `m` or more, with exact transmission and
each carrier standing at no more than `m`: `m` times the next total, with what the rest stands at
after the step, is at most `m` times this total with what the rest stood at before and the inflow
into the list. Read with `rs` the rest of a whole, the carriers' rise is within what the rest of
the whole falls by and what flows into the whole. -/
theorem share_within_rest {G : Generations X} {t m : Nat} {rs : List X}
    (balanced : L.BalancesOn W ((carriers G t ++ rs) ++ (carriers G t).flatMap (G.kids t)) t)
    (arise : ∀ p k, p ∈ carriers G t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ carriers G t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ carriers G t → W.level t p ≤ m)
    (unit : ∀ p, p ∈ G.family t → G.amount t p ≤ 1) :
    m * G.sum (t + 1) + total rs (W.level (t + 1)) ≤
      m * G.sum t + total rs (W.level t) +
        L.inflow ((carriers G t ++ rs) ++ (carriers G t).flatMap (G.kids t)) t :=
  have next : G.sum (t + 1) = born (carriers G t) (G.kids t) :=
    (sum_exact exact).trans ((total_congr (fun p => Nat.mul_comm _ (G.amount t p)) _).trans
      (total_carriers_unit (G.amount t) (fun p => (G.kids t p).length) (G.family t) unit))
  have now : G.sum t = (carriers G t).length :=
    (total_congr (fun p => (Nat.mul_one (G.amount t p)).symm) _).trans
      ((total_carriers_unit (G.amount t) (fun _ => 1) (G.family t) unit).trans (total_ones _))
  have held : total (carriers G t) (W.level t) ≤ m * G.sum t :=
    Nat.le_trans (total_le (q := fun _ => m) _ capped)
      (Nat.le_of_eq ((total_const m _).trans
        ((Nat.mul_comm _ _).trans (congrArg (m * ·) now.symm))))
  have whole := born_within_inflow (es := carriers G t ++ rs) balanced arise stands
  Nat.le_trans (Nat.le_of_eq (congrArg (fun s => m * s + total rs (W.level (t + 1))) next))
    (Nat.le_trans
      (Nat.add_le_add_left (Nat.le_add_left _ (total (carriers G t) (W.level (t + 1)))) _)
      (Nat.le_trans (Nat.le_of_eq (congrArg (m * born (carriers G t) (G.kids t) + ·)
          (total_append (W.level (t + 1)) rs (carriers G t)).symm))
        (Nat.le_trans whole
          (Nat.le_trans (Nat.le_of_eq (congrArg (· + L.inflow _ t)
              (total_append (W.level t) rs (carriers G t))))
            (Nat.add_le_add_right (Nat.add_le_add_right held _) _)))))

/-- **The carriers' joint lineage.** With no rest: for an amount of zero or one, across a step at
which the flow balances on the carriers and their offspring, under the same premises, the total
rises by at most the inflow into the carriers' joint lineage over `m` (`share_within_rest` with
nothing else listed), which is at most the carried inflow over `m` (`joint_within_carried`). -/
theorem share_within_joint {G : Generations X} {t m : Nat}
    (balanced : L.BalancesOn W (lineage (carriers G t) (G.kids t)) t)
    (arise : ∀ p k, p ∈ carriers G t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ carriers G t → k ∈ G.kids t p → m ≤ W.level (t + 1) k)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ carriers G t → W.level t p ≤ m)
    (unit : ∀ p, p ∈ G.family t → G.amount t p ≤ 1) :
    m * G.sum (t + 1) ≤ m * G.sum t + L.inflow (lineage (carriers G t) (G.kids t)) t :=
  have same : (carriers G t ++ []) ++ (carriers G t).flatMap (G.kids t) =
      lineage (carriers G t) (G.kids t) :=
    congrArg (· ++ (carriers G t).flatMap (G.kids t)) (ListTests.append_nil (carriers G t))
  have law := share_within_rest (rs := [])
    (Eq.subst (motive := fun l => L.BalancesOn W l t) same.symm balanced)
    arise stands exact capped unit
  Eq.subst (motive := fun l => m * G.sum (t + 1) ≤ m * G.sum t + L.inflow l t) same
    (Nat.le_trans (Nat.le_of_eq (Nat.add_zero _).symm)
      (Nat.le_trans law (Nat.le_of_eq (congrArg (· + L.inflow _ t) (Nat.add_zero _)))))

/-! ## Over a stretch -/

/-- **Over a stretch, the total within the carried inflow.** Where each step of a stretch meets
the premises of `total_within_carried`, `m` times the final total is at most `m` times the first
with the carried inflow over the stretch. -/
theorem stretch_within_carried {G : Generations X} {m : Nat} :
    ∀ T : Nat,
      (∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t) →
      (∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k) →
      (∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k) →
      (∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) →
      (∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m) →
      m * G.sum T ≤ m * G.sum 0 + total (steps 0 T) (carriedInflow L G)
  | 0, _, _, _, _, _ => Nat.le_add_right _ _
  | T + 1, balanced, arise, stands, exact, capped =>
    have before := stretch_within_carried T
      (fun t lt => balanced t (Nat.lt_succ_of_lt lt))
      (fun t p k lt => arise t p k (Nat.lt_succ_of_lt lt))
      (fun t p k lt => stands t p k (Nat.lt_succ_of_lt lt))
      (fun t lt => exact t (Nat.lt_succ_of_lt lt)) (fun t p lt => capped t p (Nat.lt_succ_of_lt lt))
    have last := total_within_carried (t := T) (balanced T (Nat.lt_succ_self T))
      (fun p k => arise T p k (Nat.lt_succ_self T)) (fun p k => stands T p k (Nat.lt_succ_self T))
      (exact T (Nat.lt_succ_self T)) (fun p => capped T p (Nat.lt_succ_self T))
    Nat.le_trans last (Nat.le_trans (Nat.add_le_add_right before _)
      (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans (congrArg (m * G.sum 0 + ·)
        ((steps_last (carriedInflow L G) 0 T).trans
          (congrArg (total (steps 0 T) (carriedInflow L G) + carriedInflow L G ·)
            (Nat.zero_add T))).symm))))

/-- **Moving a mean needs the carried inflow.** Where besides the final generation is no smaller
than the first: `m` times the mean's move over the stretch, cross-multiplied, is at most the first
size times the stretch's carried inflow. -/
theorem moved_within_carried {G : Generations X} {m T : Nat}
    (balanced : ∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p →
      m ≤ W.level (t + 1) k)
    (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m)
    (sustained : G.size 0 ≤ G.size T) :
    m * (G.size 0 * G.sum T) ≤
      m * (G.size T * G.sum 0) + G.size 0 * total (steps 0 T) (carriedInflow L G) :=
  Nat.le_trans (Nat.le_of_eq (mul_turn m (G.size 0) (G.sum T)))
    (Nat.le_trans (Nat.mul_le_mul_left (G.size 0)
        (stretch_within_carried T balanced arise stands exact capped))
      (Nat.le_trans (Nat.le_of_eq (Nat.left_distrib _ _ _))
        (Nat.add_le_add_right
          (Nat.le_trans (Nat.le_of_eq (mul_turn (G.size 0) m (G.sum 0)))
            (Nat.mul_le_mul_left m (Nat.mul_le_mul_right (G.sum 0) sustained)))
          _)))

/-- **Steps to move a mean.** Where besides each step carries an inflow of at most `I`: `m` times
the mean's move over `T` steps, cross-multiplied, is at most the first size times `T · I`. Moving
a mean by `D`, cross-multiplied, takes at least `m · D` over the first size times `I` steps: a
linear bound from a cap on the total. -/
theorem steps_to_move {G : Generations X} {m T I : Nat}
    (balanced : ∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p → W.ComesToStand t k)
    (stands : ∀ t p k, t < T → p ∈ G.family t → k ∈ G.kids t p →
      m ≤ W.level (t + 1) k)
    (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m)
    (sustained : G.size 0 ≤ G.size T)
    (bounded : ∀ t, t < T → carriedInflow L G t ≤ I) :
    m * (G.size 0 * G.sum T) ≤ m * (G.size T * G.sum 0) + G.size 0 * (T * I) :=
  have within : total (steps 0 T) (carriedInflow L G) ≤ T * I :=
    Nat.le_trans (total_le (q := fun _ => I) _ fun t mt => bounded t
        (Nat.lt_of_lt_of_le (between_of_mem_steps mt).2 (Nat.le_of_eq (Nat.zero_add T))))
      (Nat.le_of_eq ((total_const I _).trans (congrArg (· * I) (steps_length 0 T))))
  Nat.le_trans (moved_within_carried balanced arise stands exact capped sustained)
    (Nat.add_le_add_left (Nat.mul_le_mul_left (G.size 0) within) _)

/-! ## A cap on each parent -/

/-- **A cap on what flows into a parent's lineage caps its offspring number.** Across a step at
which the flow balances on a parent and its offspring, each offspring coming to stand at `m` or
more, the parent standing at no more than `m` before the step, with `m` positive: where what flows
into its lineage, with `m`, is at most `k` times `m`, the parent leaves at most `k` offspring. -/
theorem parent_within_factor {t m k : Nat} {p : X} {kids : X → List X}
    (balanced : L.BalancesOn W (lineage [p] kids) t)
    (arise : ∀ c, c ∈ kids p → W.ComesToStand t c)
    (stands : ∀ c, c ∈ kids p → m ≤ W.level (t + 1) c)
    (capped : W.level t p ≤ m) (positive : 0 < m)
    (fed : L.inflow (lineage [p] kids) t + m ≤ k * m) :
    (kids p).length ≤ k :=
  le_of_mul_le_mul positive
    (Nat.le_trans (parent_within_inflow balanced arise stands)
      (Nat.le_trans (Nat.add_le_add_right capped _)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
          (Nat.le_trans fed (Nat.le_of_eq (Nat.mul_comm _ _))))))

/-- **So an exactly transmitted total multiplies by at most `k` a step.** Across a step at which
the flow balances on the generation and its offspring, each offspring coming to stand at `m` or
more, with exact transmission, each parent standing at no more than `m` and what flows into each
parent's lineage, with `m`, at most `k` times `m`: the next total is at most `k` times this one.
The premises are asked of every parent, though a parent whose amount is nothing adds nothing to
either total. -/
theorem total_within_factor {G : Generations X} {t m k : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p c, p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c)
    (stands : ∀ p c, p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m) (positive : 0 < m)
    (fed : ∀ p, p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m) :
    G.sum (t + 1) ≤ k * G.sum t :=
  Nat.le_trans (Nat.le_of_eq (sum_exact exact))
    (Nat.le_trans
      (total_le _ fun p mp => Nat.mul_le_mul_right (G.amount t p)
        (parent_within_factor (fun c mc => balanced c (lineage_sub mp c mc))
          (fun c mc => arise p c mp mc) (fun c mc => stands p c mp mc) (capped p mp) positive
          (fed p mp)))
      (Nat.le_of_eq (total_mul k _ _)))

/-- **And by at most `k ^ T` over `T` steps.** Where each step of a stretch meets the premises of
`total_within_factor`, the final total is at most `k ^ T` times the first. -/
theorem total_within_power {G : Generations X} {m k : Nat} (positive : 0 < m) :
    ∀ T : Nat,
      (∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t) →
      (∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c) →
      (∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c) →
      (∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) →
      (∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m) →
      (∀ t p, t < T → p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m) →
      G.sum T ≤ k ^ T * G.sum 0
  | 0, _, _, _, _, _, _ => Nat.le_of_eq (Nat.one_mul _).symm
  | T + 1, balanced, arise, stands, exact, capped, fed =>
    have before := total_within_power positive T
      (fun t lt => balanced t (Nat.lt_succ_of_lt lt))
      (fun t p c lt => arise t p c (Nat.lt_succ_of_lt lt))
      (fun t p c lt => stands t p c (Nat.lt_succ_of_lt lt))
      (fun t lt => exact t (Nat.lt_succ_of_lt lt))
      (fun t p lt => capped t p (Nat.lt_succ_of_lt lt))
      (fun t p lt => fed t p (Nat.lt_succ_of_lt lt))
    have last := total_within_factor (t := T) (balanced T (Nat.lt_succ_self T))
      (fun p c => arise T p c (Nat.lt_succ_self T)) (fun p c => stands T p c (Nat.lt_succ_self T))
      (exact T (Nat.lt_succ_self T)) (fun p => capped T p (Nat.lt_succ_self T)) positive
      (fun p => fed T p (Nat.lt_succ_self T))
    Nat.le_trans last (Nat.le_trans (Nat.mul_le_mul_left k before)
      (Nat.le_of_eq ((mul_assoc_nat k (k ^ T) (G.sum 0)).symm.trans
        (congrArg (· * G.sum 0) (Nat.mul_comm k (k ^ T))))))

/-- **The share multiplies by at most `k ^ T`.** Where besides the final generation is no smaller
than the first: the first size times the final total is at most `k ^ T` times the final size times
the first total, so the share at the end is at most `k ^ T` times the share at the start. -/
theorem share_within_power {G : Generations X} {m k T : Nat} (positive : 0 < m)
    (balanced : ∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c)
    (stands : ∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c)
    (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m)
    (fed : ∀ t p, t < T → p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m)
    (sustained : G.size 0 ≤ G.size T) :
    G.size 0 * G.sum T ≤ k ^ T * (G.size T * G.sum 0) :=
  Nat.le_trans (Nat.mul_le_mul_left (G.size 0)
      (total_within_power positive T balanced arise stands exact capped fed))
    (Nat.le_trans (Nat.le_of_eq (mul_turn (G.size 0) (k ^ T) (G.sum 0)))
      (Nat.mul_le_mul_left (k ^ T) (Nat.mul_le_mul_right (G.sum 0) sustained)))

/-- **Reaching the whole needs a power of the cap.** Where besides the final total reaches the
final size (for an amount of zero or one: every member of the final generation carries it), the
first size is at most `k ^ T` times the first total: from `c` carriers among `N`, `N ≤ k ^ T · c`,
so one substitution takes `T ≥ log_k (N / c)` steps. It bounds one substitution, not the spacing
of successive ones. -/
theorem whole_within_power {G : Generations X} {m k T : Nat} (positive : 0 < m)
    (balanced : ∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c)
    (stands : ∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c)
    (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m)
    (fed : ∀ t p, t < T → p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m)
    (sustained : G.size 0 ≤ G.size T) (whole : G.size T ≤ G.sum T) :
    G.size 0 ≤ k ^ T * G.sum 0 :=
  Nat.le_trans sustained (Nat.le_trans whole
    (total_within_power positive T balanced arise stands exact capped fed))

/-! ## Offspring number: Fisher's pace -/

/-- **Fisher's step within the inflow.** Read by offspring number, with exact transmission across
a step, and across the next step the flow balancing on the next generation and its offspring, each
coming to stand at `m` or more: `m` times the next size squared with the squared differences of
offspring numbers over pairs is at most this size times what the next generation stands at and
what flows into it and its offspring. Fisher's step identity
(`Reproduction.Generations.ByNumber.step`) with `generation_within_inflow`. -/
theorem number_step_within_inflow {G : Generations X} {t m : Nat}
    (number : Reproduction.Generations.ByNumber G)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (balanced : L.BalancesOn W (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1))
    (arise : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      W.ComesToStand (t + 1) k)
    (stands : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      m ≤ W.level (t + 1 + 1) k) :
    m * (G.size (t + 1) * G.size (t + 1) + G.concordAt t) ≤
      G.size t * (total (G.family (t + 1)) (W.level (t + 1)) +
        L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1)) :=
  have fisher : G.size t * G.size (t + 1 + 1) =
      G.size (t + 1) * G.size (t + 1) + G.concordAt t := by
    have h := Reproduction.Generations.ByNumber.step number t
    unfold SelectionTerm.Generations.raisedAt SelectionTerm.Generations.loweredAt at h
    rw [raised_exact exact, lowered_exact exact, Nat.mul_zero, Nat.add_zero, Nat.add_zero] at h
    exact h
  Nat.le_trans (Nat.le_of_eq ((congrArg (m * ·) fisher.symm).trans (mul_turn m (G.size t) _)))
    (Nat.mul_le_mul_left (G.size t) (generation_within_inflow balanced arise stands))

/-- **Fisher's pace.** Where besides each member of the next generation stands at no more than `m`
and the population is not shrinking: `m` times the squared differences of offspring numbers over
pairs is at most the size times the inflow into the next generation and its offspring. Divided
through by `m` and the size squared, the variance of offspring number is at most the inflow per
member over `m`. -/
theorem number_spread_within_inflow {G : Generations X} {t m : Nat}
    (number : Reproduction.Generations.ByNumber G)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (balanced : L.BalancesOn W (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1))
    (arise : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      W.ComesToStand (t + 1) k)
    (stands : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      m ≤ W.level (t + 1 + 1) k)
    (capped : ∀ p, p ∈ G.family (t + 1) → W.level (t + 1) p ≤ m)
    (sustained : G.size t ≤ G.size (t + 1)) :
    m * G.concordAt t ≤
      G.size t * L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) :=
  have cappedTotal : total (G.family (t + 1)) (W.level (t + 1)) ≤ m * G.size (t + 1) :=
    Nat.le_trans (total_le (q := fun _ => m) _ capped)
      (Nat.le_of_eq ((total_const m _).trans (Nat.mul_comm _ _)))
  Naturals.le_of_add_le_add_left (k := m * (G.size (t + 1) * G.size (t + 1)))
    (Nat.le_trans (Nat.le_of_eq (Nat.left_distrib _ _ _).symm)
      (Nat.le_trans (number_step_within_inflow number exact balanced arise stands)
        (Nat.le_trans (Nat.mul_le_mul_left (G.size t) (Nat.add_le_add_right cappedTotal _))
          (Nat.le_trans (Nat.le_of_eq (Nat.left_distrib _ _ _))
            (Nat.add_le_add_right
              (Nat.le_trans (Nat.le_of_eq (mul_turn (G.size t) m (G.size (t + 1))))
                (Nat.mul_le_mul_left m (Nat.mul_le_mul_right (G.size (t + 1)) sustained)))
              _)))))

/-- **With nothing flowing in, no variance in offspring number.** Under the premises of
`number_spread_within_inflow`, with `m` positive and nothing flowing into the next generation and
its offspring, offspring numbers are uniform across the step. -/
theorem number_unfed_uniform {G : Generations X} {t m : Nat}
    (number : Reproduction.Generations.ByNumber G)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (balanced : L.BalancesOn W (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1))
    (arise : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      W.ComesToStand (t + 1) k)
    (stands : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      m ≤ W.level (t + 1 + 1) k)
    (capped : ∀ p, p ∈ G.family (t + 1) → W.level (t + 1) p ≤ m)
    (sustained : G.size t ≤ G.size (t + 1)) (positive : 0 < m)
    (unfed : L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) = 0) :
    ∀ p q, p ∈ G.family t → q ∈ G.family t →
      G.offspringNumber t p = G.offspringNumber t q :=
  have none : G.concordAt t = 0 := Nat.eq_zero_of_le_zero (le_of_mul_le_mul positive
    (Nat.le_trans
      (number_spread_within_inflow number exact balanced arise stands capped sustained)
      (Nat.le_of_eq ((congrArg (G.size t * ·) unfed).trans
        ((Nat.mul_zero _).trans (Nat.mul_zero m).symm)))))
  (Reproduction.concord_self_zero_iff _ _).mp
    ((Reproduction.Generations.ByNumber.concord_eq number t).symm.trans none)

/-- The same generations, each member read by its offspring number. -/
def numbered (G : Generations X) : Generations X where
  first := G.first
  kids := G.kids
  amount t p := (G.kids t p).length

theorem numbered_family (G : Generations X) : ∀ t, (numbered G).family t = G.family t
  | 0 => rfl
  | t + 1 => congrArg (fun l : List X => l.flatMap (G.kids t)) (numbered_family G t)

/-- The generations read by offspring number are read by offspring number
(`Reproduction.Generations.ByNumber`). -/
theorem numbered_number (G : Generations X) : Reproduction.Generations.ByNumber (numbered G) :=
  fun _ _ => rfl

/-- **The response of any amount, within the next step's inflow and its spread.** Where besides
the amount offspring number is itself transmitted exactly across the step (each offspring leaving
as many as its parent), and the next step meets the premises of `number_spread_within_inflow`: `m`
times the mean's rise or fall across the step, cross-multiplied and squared, is at most the size
times the inflow into the next generation and its offspring at the next step times the squared
differences of the amount over pairs. Cauchy–Schwarz in counts
(`Reproduction.Generations.response_sq_le`) with `number_spread_within_inflow` read on `numbered`.
The inflow is the next step's: with offspring number inherited, its variance at this step is
growth at the next. -/
theorem response_sq_within_inflow {G : Generations X} {t m : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inherited : ∀ p, p ∈ G.family t → ∀ k, k ∈ G.kids t p →
      G.offspringNumber (t + 1) k = G.offspringNumber t p)
    (balanced : L.BalancesOn W (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1))
    (arise : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      W.ComesToStand (t + 1) k)
    (stands : ∀ p k, p ∈ G.family (t + 1) → k ∈ G.kids (t + 1) p →
      m ≤ W.level (t + 1 + 1) k)
    (capped : ∀ p, p ∈ G.family (t + 1) → W.level (t + 1) p ≤ m)
    (sustained : G.size t ≤ G.size (t + 1)) :
    m * ((G.size t * G.sum (t + 1) - G.size (t + 1) * G.sum t) *
        (G.size t * G.sum (t + 1) - G.size (t + 1) * G.sum t)) ≤
      G.size t * L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) *
        concord (G.family t) (G.amount t) (G.amount t) ∧
    m * ((G.size (t + 1) * G.sum t - G.size t * G.sum (t + 1)) *
        (G.size (t + 1) * G.sum t - G.size t * G.sum (t + 1))) ≤
      G.size t * L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) *
        concord (G.family t) (G.amount t) (G.amount t) :=
  have same := numbered_family G
  have spread : m * concord (G.family t) (G.offspringNumber t) (G.offspringNumber t) ≤
      G.size t * L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) := by
    have h := number_spread_within_inflow (G := numbered G) (L := L) (W := W) (t := t) (m := m)
      (numbered_number G)
      (fun p mp k mk => inherited p (same t ▸ mp) k mk)
      (fun c mc => balanced c (same (t + 1) ▸ mc))
      (fun p k mp mk => arise p k (same (t + 1) ▸ mp) mk)
      (fun p k mp mk => stands p k (same (t + 1) ▸ mp) mk)
      (fun p mp => capped p (same (t + 1) ▸ mp))
      (Nat.le_trans (Nat.le_of_eq (congrArg List.length (same t)))
        (Nat.le_trans sustained (Nat.le_of_eq (congrArg List.length (same (t + 1))).symm)))
    unfold SelectionTerm.Generations.concordAt SelectionTerm.Generations.size at h
    rw [same t, same (t + 1)] at h
    exact h
  have cs := Reproduction.Generations.response_sq_le exact
  have bound : ∀ r : Nat,
      r ≤ concord (G.family t) (G.offspringNumber t) (G.offspringNumber t) *
        concord (G.family t) (G.amount t) (G.amount t) →
      m * r ≤ G.size t * L.inflow (lineage (G.family (t + 1)) (G.kids (t + 1))) (t + 1) *
        concord (G.family t) (G.amount t) (G.amount t) := fun r le =>
    Nat.le_trans (Nat.mul_le_mul_left m le)
      (Nat.le_trans (Nat.le_of_eq (mul_assoc_nat _ _ _).symm)
        (Nat.mul_le_mul_right _ spread))
  ⟨bound _ cs.1, bound _ cs.2⟩

/-! ## Witnesses

`Displacement`: in a family closed, balanced and dissipated on, a carrier's share rises from a half
to the whole in one step at constant size, its lineage drawing on the other member and a pool; the
inflow into the whole and into the population's own lineage are nothing, and the response and
selection laws hold with equality, so the carried inflow bounds the pace and neither of those
does. It has `Reproduction.OnePool`'s shape, a parent taking three units and giving one to each of
two offspring, its three units drawn from a pool, the carrier itself and another member, read with
`SelectionTerm.Rising`'s counts. `Fed`: two offspring of one parent, each standing at one, take one
unit from themselves and one from a source and give one to each of two of their own; the bound on
the spread of offspring number holds with equality. `Inherited` extends `Displacement` by a step at
which each offspring leaves two, as the carrier did: the audit's candidate with the same step's
inflow fails, the next-step law and the stretch law hold with equality. `Swap`: two carriers give
their units to each other's offspring, so the carried inflow counts two that the joint lineage
nets. `Uncapped` and `Shrink`: without `capped`, or with the population shrinking, the response
law fails. -/

namespace Displacement

/-- A pool, a carrier, another member, and the carrier's two offspring. -/
inductive Relatum where
  | pool
  | carrier
  | other
  | left
  | right

open Relatum

def level : Nat → Relatum → Nat
  | 0, pool => 1
  | 0, carrier => 1
  | 0, other => 1
  | 0, left => 0
  | 0, right => 0
  | _ + 1, pool => 0
  | _ + 1, carrier => 0
  | _ + 1, other => 0
  | _ + 1, left => 1
  | _ + 1, right => 1

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- What the carrier takes at the first step: one unit each from the pool, from itself and from
the other member. -/
def takeFirst : Relatum → Relatum → Nat
  | carrier, pool => 1
  | carrier, carrier => 1
  | carrier, other => 1
  | carrier, left => 0
  | carrier, right => 0
  | pool, _ => 0
  | other, _ => 0
  | left, _ => 0
  | right, _ => 0

/-- What it gives at the first step: one unit to each offspring. -/
def giveFirst : Relatum → Relatum → Nat
  | carrier, left => 1
  | carrier, right => 1
  | carrier, pool => 0
  | carrier, carrier => 0
  | carrier, other => 0
  | pool, _ => 0
  | other, _ => 0
  | left, _ => 0
  | right, _ => 0

def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | _ + 1 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | _ + 1 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [carrier]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

/-- The whole: the pool, the two members and the offspring. -/
def family : List Relatum := [pool, carrier, other, left, right]

theorem every : ∀ c, c ∈ family
  | pool => .head _
  | carrier => .tail _ (.head _)
  | other => .tail _ (.tail _ (.head _))
  | left => .tail _ (.tail _ (.tail _ (.head _)))
  | right => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))

theorem balances : flow.Balances web
  | 0, pool => rfl
  | 0, carrier => rfl
  | 0, other => rfl
  | 0, left => rfl
  | 0, right => rfl
  | _ + 1, pool => rfl
  | _ + 1, carrier => rfl
  | _ + 1, other => rfl
  | _ + 1, left => rfl
  | _ + 1, right => rfl

theorem closed : flow.ClosedAt family 0 := fun _ _ c outside => absurd (every c) outside

theorem dissipates : flow.DissipatesOn family 0
  | _, .head _ => Nat.le_refl 3
  | _, .tail _ mem => nomatch mem

def firstKids : Relatum → List Relatum
  | carrier => [left, right]
  | pool => []
  | other => []
  | left => []
  | right => []

def kids : Nat → Relatum → List Relatum
  | 0 => firstKids
  | _ + 1 => fun _ => []

/-- Carrying the target: one at the carrier and its offspring, none elsewhere. -/
def marks : Relatum → Nat
  | carrier => 1
  | left => 1
  | right => 1
  | pool => 0
  | other => 0

/-- The carrier and the other member, then the carrier's two offspring; each read by whether it
carries the target. -/
def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem arise : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    1 ≤ web.level (0 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem capped : ∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- The amount is zero or one at the first step. -/
theorem unit : ∀ p, p ∈ generations.family 0 → generations.amount 0 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.zero_le 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **The share rises from a half to the whole in a closed family, and the bound is met.** Across
the first step the whole is closed, balanced and dissipated on, and its inflow is nothing; the
population's size stays at two and each member stands at one, the least standing `m`. The
carriers' share rises from a half to the whole (the cross-multiplied rise is two, the concordance
two and the discordance none), the carrier's lineage drawing one unit net from the other member
and the pool, so the carried inflow is one, and the response and selection laws hold with
equality. -/
theorem displacement :
    flow.ClosedAt family 0 ∧ flow.DissipatesOn family 0 ∧ flow.inflow family 0 = 0 ∧
      generations.size 0 = 2 ∧ generations.size 1 = 2 ∧
      generations.sum 0 = 1 ∧ generations.sum 1 = 2 ∧
      generations.concordAt 0 = 2 ∧ generations.discordAt 0 = 0 ∧
      carriedInflow flow generations 0 = 1 ∧
      1 * (generations.size 0 * generations.sum 1) =
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * carriedInflow flow generations 0 ∧
      1 * generations.concordAt 0 =
        1 * generations.discordAt 0 + generations.size 0 * carriedInflow flow generations 0 :=
  ⟨closed, dissipates, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **The natural statement fails.** What flows into the population's own lineage, the members and
the offspring without the pool, is nothing at the first step, as is what flows into the whole; the
response law with either in place of the carried inflow fails. -/
theorem natural_fails :
    flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 = 0 ∧
      ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * flow.inflow family 0) ∧
      ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 *
            flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0) :=
  ⟨rfl, by decide, by decide⟩

/-- The premises of the response law hold of `Displacement`'s first step, with `m` one. -/
theorem premises :
    flow.BalancesOn web (lineage (generations.family 0) (generations.kids 0)) 0 ∧
      (∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
        web.ComesToStand 0 k) ∧
      (∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
        1 ≤ web.level (0 + 1) k) ∧
      Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
        (generations.amount (0 + 1)) ∧
      (∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1) ∧
      generations.size 0 ≤ generations.size (0 + 1) :=
  ⟨balances.on _ 0, arise, stands, exact, capped, Nat.le_refl 2⟩

/-- **The carriers' rise within what the rest of the whole falls by.** Read with the pool and the
other member as the rest of the whole: the carrier is the one carrier, the rest falls from two to
nothing, the whole's inflow is nothing, and `share_within_rest` holds (`2 + 0 ≤ 1 + 2 + 0`; the
slack is the one unit the carrier takes and gives to none). -/
theorem rest_falls :
    carriers generations 0 = [carrier] ∧
      total [pool, other] (web.level 0) = 2 ∧ total [pool, other] (web.level 1) = 0 ∧
      flow.inflow (([carrier] ++ [pool, other]) ++ [carrier].flatMap (generations.kids 0)) 0 = 0 ∧
      1 * generations.sum (0 + 1) + total [pool, other] (web.level (0 + 1)) ≤
        1 * generations.sum 0 + total [pool, other] (web.level 0) +
          flow.inflow ((carriers generations 0 ++ [pool, other]) ++
            (carriers generations 0).flatMap (generations.kids 0)) 0 :=
  ⟨rfl, rfl, rfl, rfl,
    share_within_rest (balances.on _ 0)
      (fun p k mp mk => arise p k (mem_carriers mp) mk)
      (fun p k mp mk => stands p k (mem_carriers mp) mk) exact
      (fun p mp => capped p (mem_carriers mp)) unit⟩

/-- What flows into each parent's lineage at the first step, with one, is at most two: the
carrier's lineage draws one, the other member's none. -/
theorem fedEach : ∀ p, p ∈ generations.family 0 →
    flow.inflow (lineage [p] (generations.kids 0)) 0 + 1 ≤ 2 * 1
  | _, .head _ => by decide
  | _, .tail _ (.head _) => by decide
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **The factor law with `k` two, met with equality.** Each parent's lineage meets the cap with
`k` two (`fedEach`), so the total at most doubles (`total_within_factor`), and it doubles: the
share multiplies by two. -/
theorem factor :
    generations.sum (0 + 1) ≤ 2 * generations.sum 0 ∧ generations.sum 1 = 2 * generations.sum 0 ∧
      generations.size 0 * generations.sum 1 = 2 ^ 1 * (generations.size 1 * generations.sum 0) :=
  ⟨total_within_factor (t := 0) (balances.on _ 0) arise stands exact capped (Nat.succ_pos 0)
      fedEach, rfl, rfl⟩

/-- **No less inflow realizes these counts.** In any world, across a step at which the flow
balances on a generation and its offspring, each offspring coming to stand at one or more, with
exact transmission and each parent standing at no more than one: where the generation and the next
number two each and the totals are one and two, the carried inflow is at least one. Price's
identity admits these counts with nothing flowing in. -/
theorem least {Y : Type} {L' : Flow Y Y} {W' : Web Y Y} {G : Generations Y}
    (balanced : L'.BalancesOn W' (lineage (G.family 0) (G.kids 0)) 0)
    (arise : ∀ p k, p ∈ G.family 0 → k ∈ G.kids 0 p → W'.ComesToStand 0 k)
    (stands : ∀ p k, p ∈ G.family 0 → k ∈ G.kids 0 p → 1 ≤ W'.level 1 k)
    (exact : Exact (G.family 0) (G.kids 0) (G.amount 0) (G.amount 1))
    (capped : ∀ p, p ∈ G.family 0 → W'.level 0 p ≤ 1)
    (sizes : G.size 0 = 2 ∧ G.size 1 = 2) (sums : G.sum 0 = 1 ∧ G.sum 1 = 2) :
    1 ≤ carriedInflow L' G 0 :=
  have law : 1 * (G.size 0 * G.sum 1) ≤
      1 * (G.size 1 * G.sum 0) + G.size 0 * carriedInflow L' G 0 :=
    response_within_carried (t := 0) balanced arise stands exact capped
      (Nat.le_of_eq (sizes.1.trans sizes.2.symm))
  have counted : 2 + 2 * 1 ≤ 2 + 2 * carriedInflow L' G 0 := by
    rw [sizes.1, sizes.2, sums.1, sums.2] at law
    exact law
  le_of_mul_le_mul (Nat.succ_pos 1) (Naturals.le_of_add_le_add_left counted)

/-- The second generation stands at no more than one. -/
theorem capped_later : ∀ p, p ∈ generations.family 1 → web.level 1 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **The spread of offspring number needs inheritance to be bounded.** Read by offspring number
(`numbered generations`), every premise of `number_spread_within_inflow` holds at the first step
but exact transmission of offspring number, which fails: the carrier left two offspring, each of
which leaves none. The flow balances at the next step, the second generation stands at no more
than one, the population stays at two, and the premises on offspring coming to stand hold
vacuously, the second generation having none. The squared differences of offspring numbers over
pairs are four while nothing flows into the second generation and its offspring at the next step,
so the spread bound fails, and so does the next-step bound on the response squared. -/
theorem spread_needs_inheritance :
    concord (generations.family 0) (generations.offspringNumber 0)
        (generations.offspringNumber 0) = 4 ∧
      flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 = 0 ∧
      flow.BalancesOn web (lineage (generations.family 1) (generations.kids 1)) 1 ∧
      (∀ p k, p ∈ generations.family 1 → k ∈ generations.kids 1 p → web.ComesToStand 1 k) ∧
      (∀ p k, p ∈ generations.family 1 → k ∈ generations.kids 1 p →
        1 ≤ web.level (1 + 1) k) ∧
      (∀ p, p ∈ generations.family 1 → web.level 1 p ≤ 1) ∧
      generations.size 0 ≤ generations.size 1 ∧
      ¬ (∀ p, p ∈ generations.family 0 → ∀ k, k ∈ generations.kids 0 p →
        generations.offspringNumber 1 k = generations.offspringNumber 0 p) ∧
      ¬ (1 * concord (generations.family 0) (generations.offspringNumber 0)
          (generations.offspringNumber 0) ≤
        generations.size 0 * flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1) ∧
      ¬ (1 * ((generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0) *
            (generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0)) ≤
        generations.size 0 * flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 *
          concord (generations.family 0) (generations.amount 0) (generations.amount 0)) :=
  ⟨rfl, rfl, balances.on _ 1, (fun _ _ _ mk => nomatch mk), (fun _ _ _ mk => nomatch mk),
    capped_later, Nat.le_refl 2,
    fun inherited => absurd (inherited carrier (.head _) left (.head _)) (by decide),
    by decide, by decide⟩

end Displacement

namespace Fed

/-- A parent and an idle member; the parent's two offspring; their four offspring; a source. -/
inductive Relatum where
  | parent
  | idle
  | first
  | second
  | firstLeft
  | firstRight
  | secondLeft
  | secondRight
  | source

open Relatum

/-- Standings at the first step: the parent two, the idle member one, the source two. -/
def levelFirst : Relatum → Nat
  | parent => 2
  | idle => 1
  | first => 0
  | second => 0
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 2

/-- At the second step: the parent's two offspring one each, the idle member one, the source
two. -/
def levelSecond : Relatum → Nat
  | parent => 0
  | idle => 1
  | first => 1
  | second => 1
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 2

/-- From the third step on: the four of the third generation one each, the idle member one. -/
def levelLater : Relatum → Nat
  | parent => 0
  | idle => 1
  | first => 0
  | second => 0
  | firstLeft => 1
  | firstRight => 1
  | secondLeft => 1
  | secondRight => 1
  | source => 0

def level : Nat → Relatum → Nat
  | 0 => levelFirst
  | 1 => levelSecond
  | _ + 2 => levelLater

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The parent takes its two units from itself. -/
def fromParent : Relatum → Nat
  | parent => 2
  | idle => 0
  | first => 0
  | second => 0
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 0

/-- The first offspring takes one unit from itself and one from the source. -/
def fromFirst : Relatum → Nat
  | parent => 0
  | idle => 0
  | first => 1
  | second => 0
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 1

/-- The second offspring takes one unit from itself and one from the source. -/
def fromSecond : Relatum → Nat
  | parent => 0
  | idle => 0
  | first => 0
  | second => 1
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 1

/-- The parent gives one unit to each of its two offspring. -/
def toPair : Relatum → Nat
  | parent => 0
  | idle => 0
  | first => 1
  | second => 1
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 0
  | secondRight => 0
  | source => 0

/-- The first offspring gives one unit to each of its own two. -/
def toFirstPair : Relatum → Nat
  | parent => 0
  | idle => 0
  | first => 0
  | second => 0
  | firstLeft => 1
  | firstRight => 1
  | secondLeft => 0
  | secondRight => 0
  | source => 0

/-- The second offspring gives one unit to each of its own two. -/
def toSecondPair : Relatum → Nat
  | parent => 0
  | idle => 0
  | first => 0
  | second => 0
  | firstLeft => 0
  | firstRight => 0
  | secondLeft => 1
  | secondRight => 1
  | source => 0

def takeFirst : Relatum → Relatum → Nat
  | parent => fromParent
  | idle => fun _ => 0
  | first => fun _ => 0
  | second => fun _ => 0
  | firstLeft => fun _ => 0
  | firstRight => fun _ => 0
  | secondLeft => fun _ => 0
  | secondRight => fun _ => 0
  | source => fun _ => 0

def takeSecond : Relatum → Relatum → Nat
  | parent => fun _ => 0
  | idle => fun _ => 0
  | first => fromFirst
  | second => fromSecond
  | firstLeft => fun _ => 0
  | firstRight => fun _ => 0
  | secondLeft => fun _ => 0
  | secondRight => fun _ => 0
  | source => fun _ => 0

def giveFirst : Relatum → Relatum → Nat
  | parent => toPair
  | idle => fun _ => 0
  | first => fun _ => 0
  | second => fun _ => 0
  | firstLeft => fun _ => 0
  | firstRight => fun _ => 0
  | secondLeft => fun _ => 0
  | secondRight => fun _ => 0
  | source => fun _ => 0

def giveSecond : Relatum → Relatum → Nat
  | parent => fun _ => 0
  | idle => fun _ => 0
  | first => toFirstPair
  | second => toSecondPair
  | firstLeft => fun _ => 0
  | firstRight => fun _ => 0
  | secondLeft => fun _ => 0
  | secondRight => fun _ => 0
  | source => fun _ => 0

/-- At the first step the parent takes its two units from itself and gives one to each offspring;
at the second each offspring takes one unit from itself and one from the source and gives one to
each of its own two; nothing takes part after. -/
def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | 1 => takeSecond
  | _ + 2 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | 1 => giveSecond
  | _ + 2 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [parent]
  | 1 => [first, second]
  | _ + 2 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web
  | 0, parent => rfl
  | 0, idle => rfl
  | 0, first => rfl
  | 0, second => rfl
  | 0, firstLeft => rfl
  | 0, firstRight => rfl
  | 0, secondLeft => rfl
  | 0, secondRight => rfl
  | 0, source => rfl
  | 1, parent => rfl
  | 1, idle => rfl
  | 1, first => rfl
  | 1, second => rfl
  | 1, firstLeft => rfl
  | 1, firstRight => rfl
  | 1, secondLeft => rfl
  | 1, secondRight => rfl
  | 1, source => rfl
  | _ + 2, parent => rfl
  | _ + 2, idle => rfl
  | _ + 2, first => rfl
  | _ + 2, second => rfl
  | _ + 2, firstLeft => rfl
  | _ + 2, firstRight => rfl
  | _ + 2, secondLeft => rfl
  | _ + 2, secondRight => rfl
  | _ + 2, source => rfl

def kidsFirst : Relatum → List Relatum
  | parent => [first, second]
  | idle => []
  | first => []
  | second => []
  | firstLeft => []
  | firstRight => []
  | secondLeft => []
  | secondRight => []
  | source => []

def kidsSecond : Relatum → List Relatum
  | parent => []
  | idle => []
  | first => [firstLeft, firstRight]
  | second => [secondLeft, secondRight]
  | firstLeft => []
  | firstRight => []
  | secondLeft => []
  | secondRight => []
  | source => []

def kids : Nat → Relatum → List Relatum
  | 0 => kidsFirst
  | 1 => kidsSecond
  | _ + 2 => fun _ => []

/-- Three generations, each member read by its offspring number. -/
def generations : Generations Relatum where
  first := [parent, idle]
  kids := kids
  amount t p := (kids t p).length

theorem number : Reproduction.Generations.ByNumber generations := fun _ _ => rfl

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem arise : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    web.ComesToStand (0 + 1) k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    1 ≤ web.level (0 + 1 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.head _) => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem capped : ∀ p, p ∈ generations.family (0 + 1) → web.level (0 + 1) p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **Fisher's pace attained.** The parent leaves two offspring and the idle member none, so the
squared differences of offspring numbers over pairs are four; each offspring leaves two, as its
parent did (exact transmission), so the sizes are two, two and four. At the second step each
offspring stands at one, the least standing `m`, and takes one unit from itself and one from the
source, so the inflow into the second generation and its offspring is two. Fisher's step within
the inflow and Fisher's pace hold with equality. -/
theorem fed :
    generations.size 0 = 2 ∧ generations.size 1 = 2 ∧ generations.size 2 = 4 ∧
      generations.concordAt 0 = 4 ∧
      total (generations.family 1) (web.level 1) = 2 ∧
      flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 = 2 ∧
      1 * (generations.size 1 * generations.size 1 + generations.concordAt 0) =
        generations.size 0 * (total (generations.family 1) (web.level 1) +
          flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1) ∧
      1 * generations.concordAt 0 =
        generations.size 0 * flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- The premises of Fisher's pace hold of `Fed`, with `m` one. -/
theorem premises :
    Reproduction.Generations.ByNumber generations ∧
      Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
        (generations.amount (0 + 1)) ∧
      flow.BalancesOn web (lineage (generations.family (0 + 1)) (generations.kids (0 + 1)))
        (0 + 1) ∧
      (∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
        web.ComesToStand (0 + 1) k) ∧
      (∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
        1 ≤ web.level (0 + 1 + 1) k) ∧
      (∀ p, p ∈ generations.family (0 + 1) → web.level (0 + 1) p ≤ 1) ∧
      generations.size 0 ≤ generations.size (0 + 1) :=
  ⟨number, exact, balances.on _ _, arise, stands, capped, Nat.le_refl 2⟩

/-- **No less inflow realizes these counts.** In any world meeting the premises of Fisher's pace
with `m` one, where the first two generations number two each and the squared differences of
offspring numbers over pairs are four, the inflow into the second generation and its offspring is
at least two. Fisher's theorem admits these counts with nothing flowing in. -/
theorem least {Y : Type} {L' : Flow Y Y} {W' : Web Y Y} {G : Generations Y}
    (number : Reproduction.Generations.ByNumber G)
    (exact : Exact (G.family 0) (G.kids 0) (G.amount 0) (G.amount 1))
    (balanced : L'.BalancesOn W' (lineage (G.family 1) (G.kids 1)) 1)
    (arise : ∀ p k, p ∈ G.family 1 → k ∈ G.kids 1 p → W'.ComesToStand 1 k)
    (stands : ∀ p k, p ∈ G.family 1 → k ∈ G.kids 1 p → 1 ≤ W'.level 2 k)
    (capped : ∀ p, p ∈ G.family 1 → W'.level 1 p ≤ 1)
    (sizes : G.size 0 = 2 ∧ G.size 1 = 2) (spread : G.concordAt 0 = 4) :
    2 ≤ L'.inflow (lineage (G.family 1) (G.kids 1)) 1 :=
  have law : 1 * G.concordAt 0 ≤ G.size 0 * L'.inflow (lineage (G.family 1) (G.kids 1)) 1 :=
    number_spread_within_inflow (t := 0) number exact balanced arise stands capped
      (Nat.le_of_eq (sizes.1.trans sizes.2.symm))
  have counted : 2 * 2 ≤ 2 * L'.inflow (lineage (G.family 1) (G.kids 1)) 1 := by
    rw [spread, sizes.1] at law
    exact law
  le_of_mul_le_mul (Nat.succ_pos 1) counted

end Fed

namespace Inherited

/-- A pool, a carrier, another member, the carrier's two offspring and their four. -/
inductive Relatum where
  | pool
  | carrier
  | other
  | left
  | right
  | leftLeft
  | leftRight
  | rightLeft
  | rightRight

open Relatum

/-- Standings at the first step: the pool five, the carrier and the other member one each. -/
def levelFirst : Relatum → Nat
  | pool => 5
  | carrier => 1
  | other => 1
  | left => 0
  | right => 0
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- At the second step: the pool four, the carrier's two offspring one each. -/
def levelSecond : Relatum → Nat
  | pool => 4
  | carrier => 0
  | other => 0
  | left => 1
  | right => 1
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- From the third step on: the four of the third generation one each. -/
def levelLater : Relatum → Nat
  | pool => 0
  | carrier => 0
  | other => 0
  | left => 0
  | right => 0
  | leftLeft => 1
  | leftRight => 1
  | rightLeft => 1
  | rightRight => 1

def level : Nat → Relatum → Nat
  | 0 => levelFirst
  | 1 => levelSecond
  | _ + 2 => levelLater

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The carrier takes one unit each from the pool, from itself and from the other member. -/
def fromCarrier : Relatum → Nat
  | pool => 1
  | carrier => 1
  | other => 1
  | left => 0
  | right => 0
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- The left offspring takes one unit from itself and two from the pool. -/
def fromLeft : Relatum → Nat
  | pool => 2
  | carrier => 0
  | other => 0
  | left => 1
  | right => 0
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- The right offspring takes one unit from itself and two from the pool. -/
def fromRight : Relatum → Nat
  | pool => 2
  | carrier => 0
  | other => 0
  | left => 0
  | right => 1
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- The carrier gives one unit to each of its two offspring. -/
def toPair : Relatum → Nat
  | pool => 0
  | carrier => 0
  | other => 0
  | left => 1
  | right => 1
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 0
  | rightRight => 0

/-- The left offspring gives one unit to each of its own two. -/
def toLeftPair : Relatum → Nat
  | pool => 0
  | carrier => 0
  | other => 0
  | left => 0
  | right => 0
  | leftLeft => 1
  | leftRight => 1
  | rightLeft => 0
  | rightRight => 0

/-- The right offspring gives one unit to each of its own two. -/
def toRightPair : Relatum → Nat
  | pool => 0
  | carrier => 0
  | other => 0
  | left => 0
  | right => 0
  | leftLeft => 0
  | leftRight => 0
  | rightLeft => 1
  | rightRight => 1

def takeFirst : Relatum → Relatum → Nat
  | pool => fun _ => 0
  | carrier => fromCarrier
  | other => fun _ => 0
  | left => fun _ => 0
  | right => fun _ => 0
  | leftLeft => fun _ => 0
  | leftRight => fun _ => 0
  | rightLeft => fun _ => 0
  | rightRight => fun _ => 0

def takeSecond : Relatum → Relatum → Nat
  | pool => fun _ => 0
  | carrier => fun _ => 0
  | other => fun _ => 0
  | left => fromLeft
  | right => fromRight
  | leftLeft => fun _ => 0
  | leftRight => fun _ => 0
  | rightLeft => fun _ => 0
  | rightRight => fun _ => 0

def giveFirst : Relatum → Relatum → Nat
  | pool => fun _ => 0
  | carrier => toPair
  | other => fun _ => 0
  | left => fun _ => 0
  | right => fun _ => 0
  | leftLeft => fun _ => 0
  | leftRight => fun _ => 0
  | rightLeft => fun _ => 0
  | rightRight => fun _ => 0

def giveSecond : Relatum → Relatum → Nat
  | pool => fun _ => 0
  | carrier => fun _ => 0
  | other => fun _ => 0
  | left => toLeftPair
  | right => toRightPair
  | leftLeft => fun _ => 0
  | leftRight => fun _ => 0
  | rightLeft => fun _ => 0
  | rightRight => fun _ => 0

/-- At the first step the carrier takes one unit each from the pool, itself and the other member
and gives one to each offspring; at the second each offspring takes one unit from itself and two
from the pool and gives one to each of its own two; nothing takes part after. -/
def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | 1 => takeSecond
  | _ + 2 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | 1 => giveSecond
  | _ + 2 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [carrier]
  | 1 => [left, right]
  | _ + 2 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

/-- The whole: the pool, the two members and two generations of offspring. -/
def family : List Relatum :=
  [pool, carrier, other, left, right, leftLeft, leftRight, rightLeft, rightRight]

theorem every : ∀ c, c ∈ family
  | pool => .head _
  | carrier => .tail _ (.head _)
  | other => .tail _ (.tail _ (.head _))
  | left => .tail _ (.tail _ (.tail _ (.head _)))
  | right => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))
  | leftLeft => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))
  | leftRight => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))
  | rightLeft => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
  | rightRight =>
    .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))))

theorem balances : flow.Balances web
  | 0, pool => rfl
  | 0, carrier => rfl
  | 0, other => rfl
  | 0, left => rfl
  | 0, right => rfl
  | 0, leftLeft => rfl
  | 0, leftRight => rfl
  | 0, rightLeft => rfl
  | 0, rightRight => rfl
  | 1, pool => rfl
  | 1, carrier => rfl
  | 1, other => rfl
  | 1, left => rfl
  | 1, right => rfl
  | 1, leftLeft => rfl
  | 1, leftRight => rfl
  | 1, rightLeft => rfl
  | 1, rightRight => rfl
  | _ + 2, pool => rfl
  | _ + 2, carrier => rfl
  | _ + 2, other => rfl
  | _ + 2, left => rfl
  | _ + 2, right => rfl
  | _ + 2, leftLeft => rfl
  | _ + 2, leftRight => rfl
  | _ + 2, rightLeft => rfl
  | _ + 2, rightRight => rfl

theorem closedFirst : flow.ClosedAt family 0 := fun _ _ c outside => absurd (every c) outside

theorem closedSecond : flow.ClosedAt family 1 := fun _ _ c outside => absurd (every c) outside

theorem dissipatesFirst : flow.DissipatesOn family 0
  | _, .head _ => Nat.le_refl 3
  | _, .tail _ mem => nomatch mem

theorem dissipatesSecond : flow.DissipatesOn family 1
  | _, .head _ => Nat.le_refl 3
  | _, .tail _ (.head _) => Nat.le_refl 3
  | _, .tail _ (.tail _ mem) => nomatch mem

def kidsFirst : Relatum → List Relatum
  | pool => []
  | carrier => [left, right]
  | other => []
  | left => []
  | right => []
  | leftLeft => []
  | leftRight => []
  | rightLeft => []
  | rightRight => []

def kidsSecond : Relatum → List Relatum
  | pool => []
  | carrier => []
  | other => []
  | left => [leftLeft, leftRight]
  | right => [rightLeft, rightRight]
  | leftLeft => []
  | leftRight => []
  | rightLeft => []
  | rightRight => []

def kids : Nat → Relatum → List Relatum
  | 0 => kidsFirst
  | 1 => kidsSecond
  | _ + 2 => fun _ => []

/-- Carrying the target: one at the carrier and its descendants, none elsewhere. -/
def marks : Relatum → Nat
  | pool => 0
  | carrier => 1
  | other => 0
  | left => 1
  | right => 1
  | leftLeft => 1
  | leftRight => 1
  | rightLeft => 1
  | rightRight => 1

/-- The carrier and the other member, the carrier's two offspring, and their four; each read by
whether it carries the target. -/
def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem ariseFirst : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem standsFirst : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    1 ≤ web.level (0 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exactFirst : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem cappedFirst : ∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- Each of the carrier's offspring leaves two, as the carrier did. -/
theorem inherited : ∀ p, p ∈ generations.family 0 → ∀ k, k ∈ generations.kids 0 p →
    generations.offspringNumber (0 + 1) k = generations.offspringNumber 0 p
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem ariseSecond : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    web.ComesToStand (0 + 1) k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem standsSecond : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    1 ≤ web.level (0 + 1 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.head _) => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exactSecond : Exact (generations.family (0 + 1)) (generations.kids (0 + 1))
    (generations.amount (0 + 1)) (generations.amount (0 + 1 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem cappedSecond : ∀ p, p ∈ generations.family (0 + 1) → web.level (0 + 1) p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **The audit's candidate fails with offspring number inherited.** The whole is closed,
dissipated on and gains nothing at both steps, and the population's own lineage gains nothing at
the first; each of the carrier's offspring leaves two, as the carrier did. The response across the
first step is two, squared four, and the amount's squared differences over pairs are one, so the
response squared is not within the size times the same step's inflow times that spread. -/
theorem same_step_fails :
    flow.ClosedAt family 0 ∧ flow.ClosedAt family 1 ∧
      flow.DissipatesOn family 0 ∧ flow.DissipatesOn family 1 ∧
      flow.inflow family 0 = 0 ∧ flow.inflow family 1 = 0 ∧
      flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 = 0 ∧
      (∀ p, p ∈ generations.family 0 → ∀ k, k ∈ generations.kids 0 p →
        generations.offspringNumber (0 + 1) k = generations.offspringNumber 0 p) ∧
      ¬ (1 * ((generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0) *
            (generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0)) ≤
        generations.size 0 * flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 *
          concord (generations.family 0) (generations.amount 0) (generations.amount 0)) :=
  ⟨closedFirst, closedSecond, dissipatesFirst, dissipatesSecond, rfl, rfl, rfl, inherited,
    by decide⟩

/-- **The next-step law, met with equality.** The premises of `response_sq_within_inflow` hold at
the first step with `m` one; what flows into the second generation and its offspring at the second
step is two, and the response squared is the size times that inflow times the spread. -/
theorem next_step_attained :
    flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 = 2 ∧
      1 * ((generations.size 0 * generations.sum (0 + 1) -
            generations.size (0 + 1) * generations.sum 0) *
          (generations.size 0 * generations.sum (0 + 1) -
            generations.size (0 + 1) * generations.sum 0)) ≤
        generations.size 0 *
            flow.inflow (lineage (generations.family (0 + 1)) (generations.kids (0 + 1))) (0 + 1) *
          concord (generations.family 0) (generations.amount 0) (generations.amount 0) ∧
      1 * ((generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0) *
          (generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0)) =
        generations.size 0 * flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 *
          concord (generations.family 0) (generations.amount 0) (generations.amount 0) :=
  ⟨rfl, (response_sq_within_inflow (L := flow) (W := web) (G := generations) (t := 0) (m := 1)
      exactFirst inherited (balances.on _ _) ariseSecond standsSecond cappedSecond
      (Nat.le_refl 2)).1, rfl⟩

theorem ariseBoth : ∀ t p k, t < 2 → p ∈ generations.family t → k ∈ generations.kids t p →
    web.ComesToStand t k
  | 0, p, k, _, mp, mk => ariseFirst p k mp mk
  | 1, p, k, _, mp, mk => ariseSecond p k mp mk
  | _ + 2, _, _, lt, _, _ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))

theorem standsBoth : ∀ t p k, t < 2 → p ∈ generations.family t → k ∈ generations.kids t p →
    1 ≤ web.level (t + 1) k
  | 0, p, k, _, mp, mk => standsFirst p k mp mk
  | 1, p, k, _, mp, mk => standsSecond p k mp mk
  | _ + 2, _, _, lt, _, _ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))

theorem exactBoth : ∀ t, t < 2 →
    Exact (generations.family t) (generations.kids t) (generations.amount t)
      (generations.amount (t + 1))
  | 0, _ => exactFirst
  | 1, _ => exactSecond
  | _ + 2, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))

theorem cappedBoth : ∀ t p, t < 2 → p ∈ generations.family t → web.level t p ≤ 1
  | 0, p, _, mp => cappedFirst p mp
  | 1, p, _, mp => cappedSecond p mp
  | _ + 2, _, lt, _ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))

/-- **The stretch law over two steps, met with equality.** The premises of
`stretch_within_carried` hold over the first two steps with `m` one; the carried inflow is one at
the first step and two at the second, the total goes from one to four, and
`1 · 4 = 1 · 1 + (1 + 2)`. -/
theorem stretch_attained :
    carriedInflow flow generations 0 = 1 ∧ carriedInflow flow generations 1 = 2 ∧
      generations.sum 2 = 4 ∧
      1 * generations.sum 2 ≤
        1 * generations.sum 0 + total (steps 0 2) (carriedInflow flow generations) ∧
      1 * generations.sum 2 =
        1 * generations.sum 0 + total (steps 0 2) (carriedInflow flow generations) :=
  ⟨rfl, rfl, rfl,
    stretch_within_carried (L := flow) (W := web) (G := generations) (m := 1) 2
      (fun t _ => balances.on _ t) ariseBoth standsBoth exactBoth cappedBoth,
    rfl⟩

end Inherited

namespace Swap

/-- Two members, each carrying the amount, and an offspring of each. -/
inductive Relatum where
  | left
  | right
  | leftKid
  | rightKid

open Relatum

def levelFirst : Relatum → Nat
  | left => 1
  | right => 1
  | leftKid => 0
  | rightKid => 0

def levelLater : Relatum → Nat
  | left => 0
  | right => 0
  | leftKid => 1
  | rightKid => 1

def level : Nat → Relatum → Nat
  | 0 => levelFirst
  | _ + 1 => levelLater

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The left member takes its unit from itself. -/
def fromLeft : Relatum → Nat
  | left => 1
  | right => 0
  | leftKid => 0
  | rightKid => 0

/-- The right member takes its unit from itself. -/
def fromRight : Relatum → Nat
  | left => 0
  | right => 1
  | leftKid => 0
  | rightKid => 0

/-- The left member gives its unit to the right member's offspring. -/
def toRightKid : Relatum → Nat
  | left => 0
  | right => 0
  | leftKid => 0
  | rightKid => 1

/-- The right member gives its unit to the left member's offspring. -/
def toLeftKid : Relatum → Nat
  | left => 0
  | right => 0
  | leftKid => 1
  | rightKid => 0

def takeFirst : Relatum → Relatum → Nat
  | left => fromLeft
  | right => fromRight
  | leftKid => fun _ => 0
  | rightKid => fun _ => 0

def giveFirst : Relatum → Relatum → Nat
  | left => toRightKid
  | right => toLeftKid
  | leftKid => fun _ => 0
  | rightKid => fun _ => 0

def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | _ + 1 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | _ + 1 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [left, right]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web
  | 0, left => rfl
  | 0, right => rfl
  | 0, leftKid => rfl
  | 0, rightKid => rfl
  | _ + 1, left => rfl
  | _ + 1, right => rfl
  | _ + 1, leftKid => rfl
  | _ + 1, rightKid => rfl

def kidsFirst : Relatum → List Relatum
  | left => [leftKid]
  | right => [rightKid]
  | leftKid => []
  | rightKid => []

def kids : Nat → Relatum → List Relatum
  | 0 => kidsFirst
  | _ + 1 => fun _ => []

/-- Both members carry the amount, and so do their offspring. -/
def generations : Generations Relatum where
  first := [left, right]
  kids := kids
  amount _ _ := 1

/-- **What passes between carrying lineages counts.** Each member gives its unit to the other's
offspring: what flows into each carrying lineage is one, so the carried inflow is two, while the
carriers' joint lineage, where the two gifts net, draws nothing, and nothing is gained. -/
theorem swap :
    carriedInflow flow generations 0 = 2 ∧ carriers generations 0 = [left, right] ∧
      flow.inflow (lineage (carriers generations 0) (generations.kids 0)) 0 = 0 ∧
      generations.size 0 = 2 ∧ generations.size 1 = 2 ∧
      generations.sum 0 = 2 ∧ generations.sum 1 = 2 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Swap

namespace Uncapped

/-- A carrier standing at two, another member, and the carrier's two offspring. -/
inductive Relatum where
  | carrier
  | other
  | left
  | right

open Relatum

def levelFirst : Relatum → Nat
  | carrier => 2
  | other => 1
  | left => 0
  | right => 0

def levelLater : Relatum → Nat
  | carrier => 0
  | other => 0
  | left => 1
  | right => 1

def level : Nat → Relatum → Nat
  | 0 => levelFirst
  | _ + 1 => levelLater

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The carrier takes its two units from itself. -/
def fromCarrier : Relatum → Nat
  | carrier => 2
  | other => 0
  | left => 0
  | right => 0

/-- The other member's unit is taken from it and given to none. -/
def fromOther : Relatum → Nat
  | carrier => 0
  | other => 1
  | left => 0
  | right => 0

/-- The carrier gives one unit to each of its offspring. -/
def toPair : Relatum → Nat
  | carrier => 0
  | other => 0
  | left => 1
  | right => 1

def takeFirst : Relatum → Relatum → Nat
  | carrier => fromCarrier
  | other => fromOther
  | left => fun _ => 0
  | right => fun _ => 0

def giveFirst : Relatum → Relatum → Nat
  | carrier => toPair
  | other => fun _ => 0
  | left => fun _ => 0
  | right => fun _ => 0

def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | _ + 1 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | _ + 1 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [carrier, other]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web
  | 0, carrier => rfl
  | 0, other => rfl
  | 0, left => rfl
  | 0, right => rfl
  | _ + 1, carrier => rfl
  | _ + 1, other => rfl
  | _ + 1, left => rfl
  | _ + 1, right => rfl

def kidsFirst : Relatum → List Relatum
  | carrier => [left, right]
  | other => []
  | left => []
  | right => []

def kids : Nat → Relatum → List Relatum
  | 0 => kidsFirst
  | _ + 1 => fun _ => []

/-- Carrying the target: one at the carrier and its offspring, none at the other member. -/
def marks : Relatum → Nat
  | carrier => 1
  | other => 0
  | left => 1
  | right => 1

def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem arise : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    1 ≤ web.level (0 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

/-- **Without `capped` the response law fails.** A carrier standing at two leaves two offspring
from its own standing while the other member's standing is lost: nothing flows into the carrying
lineage, the size stays at two, and the share rises from a half to the whole. Every premise of
`response_within_carried` holds with `m` one but `capped`. -/
theorem uncapped :
    carriedInflow flow generations 0 = 0 ∧
      flow.BalancesOn web (lineage (generations.family 0) (generations.kids 0)) 0 ∧
      (∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p → web.ComesToStand 0 k) ∧
      (∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
        1 ≤ web.level (0 + 1) k) ∧
      Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
        (generations.amount (0 + 1)) ∧
      generations.size 0 ≤ generations.size (0 + 1) ∧
      ¬ (∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1) ∧
      ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * carriedInflow flow generations 0) :=
  ⟨rfl, balances.on _ 0, arise, stands, exact, Nat.le_refl 2,
    fun capped => absurd (capped carrier (.head _)) (by decide), by decide⟩

end Uncapped

namespace Shrink

/-- A carrier, another member, and the carrier's one offspring. -/
inductive Relatum where
  | carrier
  | other
  | kid

open Relatum

def levelFirst : Relatum → Nat
  | carrier => 1
  | other => 1
  | kid => 0

def levelLater : Relatum → Nat
  | carrier => 0
  | other => 1
  | kid => 1

def level : Nat → Relatum → Nat
  | 0 => levelFirst
  | _ + 1 => levelLater

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The carrier takes its unit from itself. -/
def fromCarrier : Relatum → Nat
  | carrier => 1
  | other => 0
  | kid => 0

/-- The carrier gives its unit to its offspring. -/
def toKid : Relatum → Nat
  | carrier => 0
  | other => 0
  | kid => 1

def takeFirst : Relatum → Relatum → Nat
  | carrier => fromCarrier
  | other => fun _ => 0
  | kid => fun _ => 0

def giveFirst : Relatum → Relatum → Nat
  | carrier => toKid
  | other => fun _ => 0
  | kid => fun _ => 0

def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | _ + 1 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | _ + 1 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [carrier]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web
  | 0, carrier => rfl
  | 0, other => rfl
  | 0, kid => rfl
  | _ + 1, carrier => rfl
  | _ + 1, other => rfl
  | _ + 1, kid => rfl

def kidsFirst : Relatum → List Relatum
  | carrier => [kid]
  | other => []
  | kid => []

def kids : Nat → Relatum → List Relatum
  | 0 => kidsFirst
  | _ + 1 => fun _ => []

/-- Carrying the target: one at the carrier and its offspring, none at the other member. -/
def marks : Relatum → Nat
  | carrier => 1
  | other => 0
  | kid => 1

def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem arise : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ mem => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    1 ≤ web.level (0 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ mem => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ mem => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem capped : ∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- **With the population shrinking the response law fails, and an unfed rise shrinks it.** The
carrier leaves one offspring from its own standing and the other member none: nothing flows into
the carrying lineage, the share rises from a half to the whole, and the size falls from two to
one, as `unfed_rise_shrinks` concludes from its premises, which hold here; the response law
fails. -/
theorem shrink :
    carriedInflow flow generations 0 = 0 ∧ generations.size (0 + 1) < generations.size 0 ∧
      ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * carriedInflow flow generations 0) :=
  ⟨rfl, unfed_rise_shrinks (L := flow) (W := web) (G := generations) (t := 0) (m := 1)
      (balances.on _ 0) arise stands exact capped (Nat.succ_pos 0) rfl (by decide),
    by decide⟩

end Shrink

end SelectionPace

end Becoming
