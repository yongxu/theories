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
more than `m`: it holds no surplus. Each bound needs balance only on the family the lineage
occupies across the step. The module is a leaf: it joins two modules neither of which imports the
other, and nothing below needs it.

* **Offspring within what stood and what flowed in.** Across a step, list some relata and then
  the offspring of some parents, each offspring coming to stand across the step at `m` or more,
  the flow balancing on the list. The offspring, `m` for each, with what the first part stands at
  after the step, are at most what the first part stood at before and the list's inflow
  (`born_within_inflow`). Read on a parent and its offspring (`lineage`): its offspring number
  times `m` is at most what the parent stood at and what flowed into its lineage
  (`parent_within_inflow`); read on a generation and the next: the next generation's size times
  `m` is at most what the generation stood at and what flowed into it and its offspring
  (`generation_within_inflow`). Nothing in a lineage comes to stand but from what its parents
  stood at and what flowed in.
* **The response of a carried amount.** Count, for an amount read of each parent, what flows into
  each parent's lineage as often as the parent's amount (`carriedInflow`). With exact
  transmission the next generation's total of the amount is the parents' amounts weighted by
  their offspring numbers (`sum_exact`), so `m` times it is at most the parents' standings
  weighted by their amounts with the carried inflow (`offspring_within_carried`). Where the
  parents hold no surplus, `m` times the next total is at most `m` times this one with the
  carried inflow (`total_within_carried`): the total rises by at most the carried inflow over
  `m`. Where the population is not shrinking as well, `m` times the mean's rise,
  cross-multiplied, is at most the size times the carried inflow (`response_within_carried`), and
  since with exact transmission that rise is the selection term proper (`mean_step_exact`), `m`
  times the concordance is at most `m` times the discordance with the size times the carried
  inflow (`selection_within_carried`). Divided through: the mean of an exactly transmitted amount
  rises across a step by at most the carried inflow over `m` times the next generation's size.
* **A rise nothing pays for shrinks the population.** Parents holding no surplus and nothing
  flowing into the lineages carrying the amount, a rise of its mean across a step leaves the next
  generation smaller than this one (`unfed_rise_shrinks`): what selection gains without inflow it
  takes from the population's size.
* **Over a stretch: the cost of moving a mean.** Over a stretch of steps each meeting these
  premises, `m` times the final total is at most `m` times the first with the carried inflow over
  the stretch (`stretch_within_carried`); where the final generation is no smaller than the
  first, `m` times the mean's move, cross-multiplied, is at most the first size times the
  stretch's carried inflow (`moved_within_carried`); and where each step carries at most `I`, it
  is at most the first size times `T · I` (`steps_to_move`). Moving a mean by `D`,
  cross-multiplied, takes at least `m · D` over the first size times `I` steps: each unit gained
  needs `m` units drawn into the lineages carrying it.
* **Offspring number.** Read by offspring number with exact transmission across a step, `m` times
  the next size squared with the squared differences of offspring numbers over pairs is at most
  this size times what the next generation stands at and what flows into it and its offspring
  (`number_step_within_inflow`). Where the next generation holds no surplus and the population is
  not shrinking, `m` times those squared differences is at most the size times that inflow
  (`number_spread_within_inflow`): divided through, the variance of offspring number, which
  Fisher's theorem turns into the rise of the mean offspring number (the variance over the mean),
  is at most the inflow per member over `m`. With nothing flowing in, offspring numbers are
  uniform (`number_unfed_uniform`). Where besides an amount offspring number is itself transmitted
  exactly, the response of the amount, cross-multiplied and squared, times `m`, is at most the
  size times that inflow times the amount's squared differences over pairs
  (`response_sq_within_inflow`, reading the generations by offspring number, `numbered`):
  Cauchy–Schwarz in counts with the bound on the spread. That route needs offspring number
  transmitted exactly: in `Displacement` its squared differences are four while nothing flows in
  at the next step (`Displacement.spread_needs_inheritance`).
* **Not the inflow into the whole.** The bound is on what flows into the lineages carrying the
  amount, which may be drawn from other lineages, and not on what flows into the whole. In
  `Displacement` a family closed, balanced and dissipated on, its inflow nothing and its size
  staying at two, has the carriers' share rise from a half to the whole in one step, the
  carrier's lineage drawing one unit net from the other member and a pool
  (`Displacement.displacement`).
* **The bounds are attained.** In `Displacement` the response and selection laws hold with
  equality, and every world meeting the premises with its counts carries an inflow of at least
  one (`Displacement.least`); in `Fed`, where two offspring of one parent each take one unit from
  a source and give one to each of two of their own, the bound on the spread of offspring number
  holds with equality (`Fed.fed`), and every world meeting the premises with its counts has an
  inflow of at least two (`Fed.least`). The premises hold of both (`Displacement.premises`,
  `Fed.premises`).

So the identities of Price and Fisher admit a pace the flow forbids. Under balance, with each
offspring standing at `m` and parents holding no surplus, the mean of an exactly transmitted
amount rises in a population not shrinking only as far as what flows into the lineages carrying
it pays for, `m` units for each unit gained, and the variance of offspring number, read with
exact transmission, is at most the inflow per member over `m`. A rise nothing pays for shrinks
the population.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- Haldane (1957, *J. Genetics* 55): substituting one allele for another costs selective deaths,
  paid from the population's reproductive excess, which limits the rate of substitution (about
  one substitution in 300 generations under his estimates). Here: in a population kept at its
  size and holding no surplus, each unit an exactly transmitted amount gains costs `m` units drawn
  into the lineages carrying it (`total_within_carried`, `steps_to_move`), and a gain nothing pays
  for is paid in the population's size (`unfed_rise_shrinks`), the counting form of selective
  deaths. The two costs differ: Haldane's grows with the logarithm of the starting frequency,
  since selection acts there through relative fitness; the cost here is what the members gained
  stand at, conserved.
- Price (1970, *Nature* 227): the change of a mean is the selection term with the transmission
  term, an identity admitting every count; with exact transmission the response is the selection
  term (`mean_step_exact`), and the flow bounds it (`selection_within_carried`).
- Fisher (1930): the mean offspring number rises by the variance of offspring number over its
  mean in the exact case (`Reproduction.Generations.ByNumber.rises_exact_iff`); the flow bounds
  that variance by the inflow per member over `m` (`number_spread_within_inflow`). Fisher left
  the rest to "the deterioration of the environment", which Price (1972, *Ann. Hum. Genet.* 36)
  read as the transmission term; with nothing flowing into a population at its size and holding
  no surplus, exact transmission of offspring number allows no variance in it
  (`number_unfed_uniform`).
- Wallace (1975, *Evolution* 29), hard and soft selection: Haldane's cost presupposes hard
  selection; under soft selection, where what one lineage gains another loses, it largely
  disappears. Here the bound is on the inflow into the carrying lineages, and in `Displacement`
  that inflow is drawn from another lineage within a closed family: soft selection.
- Smith and Fretwell (1974, *Am. Nat.* 108): a parent's offspring, each of a size, are bounded by
  what it invests; `parent_within_inflow` is that budget read on standing and inflow.

What is not derived: that offspring stand at a least amount `m`, that parents hold no surplus,
that transmission is exact or that a population is not shrinking (premises, stated where used);
a bound by the inflow into the whole family, which is false (`Displacement`); Haldane's
logarithmic cost; a pace through each parent's fecundity, which the general law
(`offspring_within_carried`) carries where parents hold more than `m` but for which no stretch
law is stated; how long exact transmission of offspring number with growth can last within a
bounded inflow, whose closed case is `Reproduction.Flow.closed_lineage_lowered`; drift and
mutation. Dissipation is not used: each bound holds in a flow balanced on the lineage's family,
and where the family's takers dissipate, what the family loses would tighten it (not stated).
Modelling choices: natural-number amounts and standings, discrete steps, generations each listed
as the offspring of the last, each offspring coming to stand across its step; the least standing
`m` is a level, not the web's `need`; a lineage's family is listed as the parents and then their
offspring and may repeat a relatum (a parent among offspring, or one offspring under two
parents), the bounds holding all the same, while reading its inflow as the lineage's own needs
the listing without repetition. No ethical predicate, ranking or axiom occurs; every declaration
has an empty axiom report.
-/

namespace Becoming

namespace SelectionPace

open SelectionTerm

variable {X : Type} {L : Flow X X} {W : Web X X}

/-! ## Offspring within what stood and what flowed in -/

/-- Parents and their offspring across a step, listed together: the family a lineage occupies
across one step. -/
def lineage (ps : List X) (kids : X → List X) : List X := ps ++ ps.flatMap kids

/-- A parent's lineage lies within the lineage of any list of parents it belongs to. -/
theorem lineage_sub {p : X} {ps : List X} {kids : X → List X} (mp : p ∈ ps) :
    ∀ c, c ∈ lineage [p] kids → c ∈ lineage ps kids :=
  fun c mc => match mem_append_cases mc with
    | .inl here => match mem_cons_cases here with
      | .inl same => mem_append_of_left _ (Eq.subst (motive := fun x => x ∈ ps) same.symm mp)
      | .inr no => nomatch no
    | .inr there => match Reproduction.mem_flatMap_cases there with
      | ⟨_, mq, mk⟩ => match mem_cons_cases mq with
        | .inl same => mem_append_of_right _ (ListTests.mem_flatMap_iff.mpr
            ⟨p, mp, Eq.subst (motive := fun x => c ∈ kids x) same mk⟩)
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
the inflow (`Flow.replenishment_le_inflow`). -/
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
    Naturals.le_of_add_le_add_right (k := L.uptake (es ++ ps.flatMap kids) t)
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

/-! ## The response of a carried amount -/

/-- The inflow an amount carries across a step: what flows into each parent's lineage, counted
as often as the parent's amount. -/
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
the next size times the total, with the concordance. -/
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

/-- **Holding no surplus, the total rises by at most the carried inflow over `m`.** Where besides
each parent stands at no more than `m` before the step: `m` times the next total is at most `m`
times this one with the carried inflow. -/
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

/-- **A rise nothing pays for shrinks the population.** With `m` positive, parents holding no
surplus and nothing flowing into the lineages carrying the amount, a rise of its mean across the
step leaves the next generation smaller than this one. -/
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

/-- **The cost of moving a mean.** Where besides the final generation is no smaller than the
first: `m` times the mean's move over the stretch, cross-multiplied, is at most the first size
times the stretch's carried inflow. -/
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
a mean by `D`, cross-multiplied, takes at least `m · D` over the first size times `I` steps. -/
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

/-- **Fisher's pace.** Where besides the next generation holds no surplus and the population is
not shrinking: `m` times the squared differences of offspring numbers over pairs is at most the
size times the inflow into the next generation and its offspring. Divided through by `m` and the
size squared, the variance of offspring number is at most the inflow per member over `m`. -/
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

/-- **The response of any amount, within the inflow and its spread.** Where besides the amount
offspring number is itself transmitted exactly across the step (each offspring leaving as many as
its parent), and the next step meets the premises of `number_spread_within_inflow`: `m` times the
mean's rise or fall across the step, cross-multiplied and squared, is at most the size times the
inflow into the next generation and its offspring times the squared differences of the amount
over pairs. Cauchy–Schwarz in counts (`Reproduction.Generations.response_sq_le`) with
`number_spread_within_inflow` read on `numbered`. -/
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
      (fun _ _ => rfl)
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
response and selection laws hold with equality, so the whole's inflow does not bound the pace and
the carried inflow does, exactly. `Fed`: two offspring of one parent, each standing at one, take
one unit each from a source and give one to each of two of their own; the bound on the spread of
offspring number holds with equality. -/

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

/-- **The share rises from a half to the whole in a closed family, and the bound is met.** Across
the first step the whole is closed, balanced and dissipated on, and its inflow is nothing; the
population stays at two and each member stands at one, the least standing `m`. The carriers'
share rises from a half to the whole (the cross-multiplied rise is two, the concordance two and
the discordance none), the carrier's lineage drawing one unit net from the other member and the
pool, so the carried inflow is one, and the response and selection laws hold with equality. The
bound is on what flows into the carrying lineages, not into the whole. -/
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

/-- **The spread of offspring number needs inheritance to be bounded.** Read by offspring number,
the squared differences over pairs at the first step are four, while nothing flows into the second
generation and its offspring at the next step; the flow balances there, the second generation
stands at no more than one and the population stays at two. Every premise of
`number_spread_within_inflow` holds but exact transmission of offspring number, which fails: the
carrier left two offspring, each of which leaves none. -/
theorem spread_needs_inheritance :
    concord (generations.family 0) (generations.offspringNumber 0)
        (generations.offspringNumber 0) = 4 ∧
      flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 = 0 ∧
      flow.BalancesOn web (lineage (generations.family 1) (generations.kids 1)) 1 ∧
      (∀ p, p ∈ generations.family 1 → web.level 1 p ≤ 1) ∧
      generations.size 0 ≤ generations.size 1 ∧
      ¬ ∀ p, p ∈ generations.family 0 → ∀ k, k ∈ generations.kids 0 p →
        generations.offspringNumber 1 k = generations.offspringNumber 0 p :=
  ⟨rfl, rfl, balances.on _ 1, capped_later, Nat.le_refl 2,
    fun inherited => absurd (inherited carrier (.head _) left (.head _)) (by decide)⟩

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
at the second each offspring takes its one unit from itself and one from the source and gives one
to each of its own two; nothing takes part after. -/
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
source,
so the inflow into the second generation and its offspring is two. Fisher's step within the
inflow and Fisher's pace hold with equality. -/
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

end SelectionPace

end Becoming
