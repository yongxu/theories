import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Algebra.BigOperators.Field
import Mathlib.GroupTheory.Perm.Sign
import Becoming.FreeEnergyGuarantees

/-!
# Identical cells under noise: an exchangeable law stays exchangeable

The core's law on identical cells (`Becoming.FreeEnergyGuarantees.IdenticalCells`) is stated for a
deterministic descent: every cell moves by one rule from its own state and a field read off the
configuration, never off its own number, and cells alike at the start stay alike. Under noise that
law does not apply, since independent fluctuations can part alike cells
(`Witness.independentNoise_parts`). This module states what holds instead, over Mathlib's reals, for
finitely many cells with finitely many states each and weights on configurations moved by kernels in
discrete steps (board item UE24). Weights are any real function on configurations; a law is weights
that are nonnegative, of total one. The law under noise is proved for an exchangeable field,
unchanged by every exchange of neighbouring cells. A field reading no cell's own number is not
enough: a field reading the state of the first cell assigns the places from an exchangeable start
with no noise (`Witness.firstCell_assigns`).

* **Exchangeable weights stay exchangeable.** A kernel that reads the cells as a population under a
  rearrangement `σ`, changing no weight when both configurations are rearranged by `σ`
  (`KernelCommutes`), keeps all weights that `σ` leaves unchanged unchanged (`step_invariant`); so
  under kernels, one for each step, each commuting with every rearrangement, an exchangeable start,
  weights no rearrangement of the cells changes, gives exchangeable weights at every step
  (`weightsAt_invariant`, `weightsAt_exchangeable`). All cells in one state (`alike_exchangeable`)
  and the cells independent and of one law (`independent_exchangeable`, `independent_law`) are
  exchangeable starts.

* **What exchangeable weights leave undecided.** Every cell has the weights of every other
  (`marginal_eq`), and where the weights are a law each assignment of distinct states to the cells
  has weight at most one over the number of orderings of the cells (`distinct_le`). The law of one
  configuration is unchanged by `σ` exactly where the configuration is (`pointMass_invariant_iff`),
  so it is exchangeable only with all its cells alike (`pointMass_exchangeable_alike`).

* **Stationary weights.** Under a kernel commuting with `σ` the rearrangement by `σ` of stationary
  weights is stationary (`stationary_rearranged`), so under a kernel commuting with every
  rearrangement a unique stationary law is exchangeable (`unique_stationary_exchangeable`). Gibbs
  weights `exp (-κ F)` normalized, for any real `κ`, of a free energy no rearrangement changes, are
  exchangeable (`gibbs_exchangeable`); no kernel is shown here to keep them.

* **Noise.** Given a rule on configurations and a law of noise, each cell moves independently from
  the state the rule gives it by that one law (`noisy`); where the rule commutes with a
  rearrangement so does the rule with noise (`noisy_commutes`). With no noise (`noiseless`) the law
  of one configuration follows the rule's run (`weightsAt_noiseless`).

* **The core's descent with noise.** A configuration of `m` cells is read as a list (`List.ofFn`).
  Exchanging neighbouring cells `k` and `k + 1`, the core's `exchangeAt`, is rearranging by the
  transposition of `k` and `k + 1` (`ofFn_swap`), and these generate every rearrangement, so what no
  neighbouring exchange changes no rearrangement changes (`ofFn_rearranged`). The core's descent
  read cell by cell (`cellwise`, `ofFn_cellwise`) has the core's run as its run
  (`ofFn_iterate_cellwise`), so without noise the law weighs one exactly the configuration the
  core's run reaches (`noiseless_run`); read cell by cell, the core's never-parting law holds of any
  two cells whatever the field (`cellwise_alike`). With an exchangeable field the descent commutes
  with every rearrangement (`cellwise_commutes`), and the core's run from a rearranged start is the
  rearranged run (`run_rearranged`). With noise, each cell goes, independently and by one law, from
  its own state and the field it senses to its next state (`noisyDescent`; noise in what the cell
  senses, independent across cells, is a case, and so is noise after the core's update,
  `noisy_eq_noisyDescent`); it commutes with every rearrangement where the field is exchangeable
  (`noisyDescent_commutes`). So from an exchangeable start the weights are exchangeable at every
  step (`noisyDescent_exchangeable`), every cell has the weights of every other, and where the noise
  and the start are laws each assignment of distinct states has weight at most `1 / m!`
  (`noisyDescent_distinct_le`; from all cells in one state and from the cells independent and of one
  law, `noisyDescent_from_alike`, `noisyDescent_from_independent`). From all cells in one state some
  configuration of all cells alike has positive weight at every step (`alike_positive`): in finitely
  many states independent noise never parts identical cells with certainty. A free energy symmetric
  in the core's sense is unchanged by every rearrangement (`symmetric_rearranged`), and so are its
  Gibbs weights (`gibbs_symmetric_exchangeable`).

* **Two cells** (`Witness`). Noise of one law at each cell, a fair coin of its own, parts two alike
  cells with positive weight (`Witness.independentNoise_parts`). A kernel taking every configuration
  to one of the two parted ones with weight one half each (`Witness.toParted`) commutes with
  exchanging the cells (`Witness.toParted_commutes`) and parts alike cells with certainty, each
  parted configuration with weight one half (`Witness.alike_none`, `Witness.each_half`). It is the
  fair mixture of two rules, each assigning the places by the cells' numbers and neither commuting
  with the exchange (`Witness.toParted_eq_mixture`, `Witness.assign_not_commutes`), and no noise of
  one law at every cell: the parted half and half is no product of one weighting per cell
  (`Witness.partedUniform_not_product`, `Witness.toParted_not_noisy`,
  `Witness.toParted_not_noisyDescent`). Its only stationary law is the parted half and half
  (`Witness.toParted_stationary_iff`), exchangeable, here through `unique_stationary_exchangeable`
  (`Witness.partedUniform_exchangeable`): uniqueness gives exchangeability, not alike cells, where
  the core's unique minimum has its cells alike. A field reading the state of the first cell, with
  each cell flipping by it, is not exchangeable, and from the parted half and half with no noise
  gives one assignment weight one and the cells different laws (`Witness.firstCell_assigns`): a
  field reading the configuration as a list can read the cells' places through its order.

**Reading** [AI reading, D45]. Under noise of one law at every cell, which cell takes which place is
left to chance, the start's and the noise's: the law gives every rearrangement of an assignment one
weight and decides nothing of which cell takes which place.

**Modelling choices.** Finitely many cells and states; weights on configurations, real numbers; a
kernel as a function of two configurations, with no measurability; discrete synchronous steps, the
kernel allowed to change from step to step; the noise independent across cells and of one law,
reading a cell's own state and the field it senses; the rearrangements are all permutations of the
cells. **What is not derived:** densities, continuous states or time, Langevin flows; whether a
realization parts (in continuous states with a density, exact alikeness has probability zero after
one step, while here alike configurations keep positive weight); which place a given cell reaches;
which asymmetry actually differentiates cells; any rate at which a law approaches a stationary one,
or that one exists or is unique for a given kernel. **Standing:** that a symmetric cause gives a
symmetric effect is Curie's principle (Curie 1894; Chalmers 1970), and its form for indeterministic
laws, a symmetric cause giving a symmetric distribution of effects, is in Ismael 1997 and Castellani
and Ismael 2016; that a symmetry the law keeps is broken only in realizations is spontaneous
symmetry breaking (Earman 2004); that no deterministic rule treating anonymous processors alike
singles one out is Angluin's (1980), and that independent coins, one for each processor, break the
symmetry with probability one, never with certainty within a bounded number of steps, is the
randomized answer (Itai and Rodeh 1990), of which `alike_positive` is the part on certainty. New are
the statements on the core's descent, joined to it, and their reading against the principle's
identical cells. `cellwise` has no axiom, and `ofFn_cellwise`, `ofFn_iterate_cellwise` and
`cellwise_alike` use no `Classical.choice`; their proofs use `propext` and `Quot.sound`, so a core
version would need proofs with an empty report (not attempted). Each declaration here depends on
Lean's standard axioms at most, through Mathlib; the checker reports each one's. No ethical premise
occurs.
-/

namespace Becoming.CellsUnderNoise

open Equiv Finset

section Laws

variable {ι S : Type} {p : (ι → S) → ℝ}

/-- **Rearranging the cells**: under `σ`, cell `i` takes the state cell `σ i` had. -/
def rearrange (σ : Perm ι) : (ι → S) ≃ (ι → S) where
  toFun c := c ∘ σ
  invFun c := c ∘ σ.symm
  left_inv c := funext fun i => congrArg c (σ.apply_symm_apply i)
  right_inv c := funext fun i => congrArg c (σ.symm_apply_apply i)

/-- Weights over configurations that rearranging the cells by `σ` leaves unchanged. -/
def Invariant (σ : Perm ι) (p : (ι → S) → ℝ) : Prop := ∀ c, p (c ∘ σ) = p c

/-- **Exchangeable weights**: no rearrangement of the cells changes the weight of a configuration.
The core's `IdenticalCells.Exchangeable` asks of a field that no exchange of neighbouring cells of
the list it reads changes it; through `ofFn_rearranged` that gives invariance under every
rearrangement. -/
def Exchangeable (p : (ι → S) → ℝ) : Prop := ∀ σ : Perm ι, Invariant σ p

/-- A kernel, the weight of going from each configuration to each, that reads the cells as a
population under `σ`: rearranging both configurations by `σ` changes no weight. -/
def KernelCommutes (σ : Perm ι) (K : (ι → S) → (ι → S) → ℝ) : Prop :=
  ∀ c c', K (c ∘ σ) (c' ∘ σ) = K c c'

/-- **One step**: the weight of `c'` after one step is the weight of each configuration times
that of going from it to `c'`, summed. -/
def step [Fintype ι] [DecidableEq ι] [Fintype S] (K : (ι → S) → (ι → S) → ℝ)
    (p : (ι → S) → ℝ) : (ι → S) → ℝ :=
  fun c' => ∑ c, p c * K c c'

/-- **The weights at step `n`** from the weights `p`, under the kernel `K k` at step `k`. -/
def weightsAt [Fintype ι] [DecidableEq ι] [Fintype S] (K : ℕ → (ι → S) → (ι → S) → ℝ)
    (p : (ι → S) → ℝ) : ℕ → (ι → S) → ℝ
  | 0 => p
  | n + 1 => step (K n) (weightsAt K p n)

/-- **A kernel commuting with a rearrangement keeps weights it leaves unchanged unchanged.** -/
theorem step_invariant [Fintype ι] [DecidableEq ι] [Fintype S] {σ : Perm ι}
    {K : (ι → S) → (ι → S) → ℝ} (commutes : KernelCommutes σ K) (invariant : Invariant σ p) :
    Invariant σ (step K p) :=
  fun c' => (Fintype.sum_equiv (rearrange σ) _ _ fun c => by
    simp only [rearrange, Equiv.coe_fn_mk, invariant c, commutes c c']).symm

/-- So at every step, under kernels each commuting with `σ`. -/
theorem weightsAt_invariant [Fintype ι] [DecidableEq ι] [Fintype S] {σ : Perm ι}
    {K : ℕ → (ι → S) → (ι → S) → ℝ} (commutes : ∀ k, KernelCommutes σ (K k))
    (invariant : Invariant σ p) : ∀ n, Invariant σ (weightsAt K p n)
  | 0 => invariant
  | n + 1 => step_invariant (commutes n) (weightsAt_invariant commutes invariant n)

/-- **From an exchangeable start, under kernels each commuting with every rearrangement of the
cells, the weights are exchangeable at every step.** -/
theorem weightsAt_exchangeable [Fintype ι] [DecidableEq ι] [Fintype S]
    {K : ℕ → (ι → S) → (ι → S) → ℝ} (commutes : ∀ k σ, KernelCommutes σ (K k))
    (exchangeable : Exchangeable p) (n : ℕ) : Exchangeable (weightsAt K p n) :=
  fun σ => weightsAt_invariant (fun k => commutes k σ) (exchangeable σ) n

/-- A step keeps weights nonnegative under a nonnegative kernel. -/
theorem step_nonneg [Fintype ι] [DecidableEq ι] [Fintype S] {K : (ι → S) → (ι → S) → ℝ}
    (kernel : ∀ c c', 0 ≤ K c c') (nonneg : ∀ c, 0 ≤ p c) (c' : ι → S) : 0 ≤ step K p c' :=
  Finset.sum_nonneg fun c _ => mul_nonneg (nonneg c) (kernel c c')

/-- A step keeps the total under a kernel whose weights from each configuration total one. -/
theorem step_total [Fintype ι] [DecidableEq ι] [Fintype S] {K : (ι → S) → (ι → S) → ℝ}
    (rows : ∀ c, ∑ c', K c c' = 1) : ∑ c', step K p c' = ∑ c, p c := by
  unfold step
  rw [Finset.sum_comm]
  exact Finset.sum_congr rfl fun c _ => by rw [← Finset.mul_sum, rows c, mul_one]

/-- So from a law the weights at every step are a law: nonnegative, of total one. -/
theorem weightsAt_law [Fintype ι] [DecidableEq ι] [Fintype S] {K : ℕ → (ι → S) → (ι → S) → ℝ}
    (kernel : ∀ k c c', 0 ≤ K k c c') (rows : ∀ k c, ∑ c', K k c c' = 1) (nonneg : ∀ c, 0 ≤ p c)
    (total : ∑ c, p c = 1) : ∀ n, (∀ c, 0 ≤ weightsAt K p n c) ∧ ∑ c, weightsAt K p n c = 1
  | 0 => ⟨nonneg, total⟩
  | n + 1 => ⟨step_nonneg (kernel n) (weightsAt_law kernel rows nonneg total n).1,
      (step_total (rows n)).trans (weightsAt_law kernel rows nonneg total n).2⟩

/-! ### Identical cells at the start -/

/-- **The law of one configuration**: weight one there, nothing elsewhere. -/
def pointMass [Fintype ι] [DecidableEq S] (c₀ : ι → S) (c : ι → S) : ℝ :=
  if c = c₀ then 1 else 0

/-- **The law of one configuration is unchanged by a rearrangement exactly where the configuration
is.** -/
theorem pointMass_invariant_iff [Fintype ι] [DecidableEq S] (σ : Perm ι) (c₀ : ι → S) :
    Invariant σ (pointMass c₀) ↔ c₀ ∘ σ = c₀ := by
  constructor
  · intro invariant
    have h := invariant c₀
    simp only [pointMass] at h
    by_contra ne
    rw [if_neg ne] at h
    exact zero_ne_one h
  · intro fixed c
    have back : c₀ ∘ σ.symm = c₀ := by
      conv_lhs => rw [← fixed]
      funext i; simp
    simp only [pointMass]
    congr 1
    apply propext
    constructor
    · intro h; rw [← back, ← h]; funext i; simp
    · intro h; rw [h, fixed]

/-- **A law of one configuration is exchangeable only with all its cells alike.** -/
theorem pointMass_exchangeable_alike [Fintype ι] [DecidableEq ι] [DecidableEq S] {c₀ : ι → S}
    (exchangeable : Exchangeable (pointMass c₀)) (i j : ι) : c₀ i = c₀ j := by
  have := congrFun ((pointMass_invariant_iff (swap i j) c₀).mp (exchangeable (swap i j))) i
  simpa [eq_comm] using this

/-- All cells in one state: no rearrangement changes the configuration. -/
theorem alike_fixed (a : S) (σ : Perm ι) : (fun _ : ι => a) ∘ σ = fun _ => a := rfl

/-- **Identical cells as one configuration**: the law of all cells in one state is
exchangeable. -/
theorem alike_exchangeable [Fintype ι] [DecidableEq S] (a : S) :
    Exchangeable (pointMass (fun _ : ι => a)) :=
  fun σ => (pointMass_invariant_iff σ _).mpr (alike_fixed a σ)

/-- **Identical cells independent and of one law**: each cell's state weighted by `q₀`, the cells
independent, gives exchangeable weights. -/
theorem independent_exchangeable [Fintype ι] (q₀ : S → ℝ) :
    Exchangeable fun c : ι → S => ∏ i, q₀ (c i) :=
  fun σ c => Equiv.prod_comp σ fun i => q₀ (c i)

/-- Where `q₀` is a law, so are the cells independent and each of it. -/
theorem independent_law [Fintype ι] [DecidableEq ι] [Fintype S] {q₀ : S → ℝ}
    (nonneg : ∀ s, 0 ≤ q₀ s) (total : ∑ s, q₀ s = 1) :
    (∀ c : ι → S, 0 ≤ ∏ i, q₀ (c i)) ∧ ∑ c : ι → S, ∏ i, q₀ (c i) = 1 :=
  ⟨fun _ => Finset.prod_nonneg fun _ _ => nonneg _,
   by rw [← Fintype.prod_sum]; exact Finset.prod_eq_one fun _ _ => total⟩

/-- The law of one configuration is a law: nonnegative, of total one. -/
theorem pointMass_law [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S] (c₀ : ι → S) :
    (∀ c, 0 ≤ pointMass c₀ c) ∧ ∑ c, pointMass c₀ c = 1 :=
  ⟨fun c => by unfold pointMass; split <;> norm_num, by simp [pointMass]⟩

/-! ### What an exchangeable law leaves undecided -/

/-- **The weights of one cell's state**: the weight of the configurations in which cell `i` is in
state `s`. -/
def marginal [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S] (p : (ι → S) → ℝ) (i : ι)
    (s : S) : ℝ :=
  ∑ c, if c i = s then p c else 0

/-- **Under exchangeable weights every cell has the weights of every other.** -/
theorem marginal_eq [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S]
    (exchangeable : Exchangeable p) (i j : ι) (s : S) : marginal p i s = marginal p j s :=
  Fintype.sum_equiv (rearrange (swap i j)) _ _ fun c => by
    simp only [rearrange, Equiv.coe_fn_mk, Function.comp_apply, swap_apply_right,
      exchangeable (swap i j) c]

/-- **Under an exchangeable law, nonnegative and of total one, each assignment of distinct states to
the cells has weight at most
one over the number of orderings of the cells**: its `(card ι)!` rearrangements are distinct
configurations of one weight. -/
theorem distinct_le [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S]
    (exchangeable : Exchangeable p) (nonneg : ∀ c, 0 ≤ p c) (total : ∑ c, p c = 1) {c : ι → S}
    (distinct : Function.Injective c) : p c ≤ 1 / (Fintype.card ι).factorial := by
  have injective : Function.Injective fun σ : Perm ι => c ∘ σ := fun σ τ h =>
    Equiv.ext fun i => distinct (congrFun h i)
  have orbit : ∑ σ : Perm ι, p (c ∘ σ) = (Fintype.card ι).factorial * p c := by
    simp only [fun σ => exchangeable σ c, Finset.sum_const, Finset.card_univ, Fintype.card_perm,
      nsmul_eq_mul]
  have within : ∑ σ : Perm ι, p (c ∘ σ) ≤ 1 := by
    rw [← total, ← Finset.sum_image (f := p) fun σ _ τ _ h => injective h]
    exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _) fun c _ _ => nonneg c
  rw [le_div_iff₀ (by exact_mod_cast Nat.factorial_pos _), mul_comm, ← orbit]
  exact within

/-! ### Stationary laws -/

/-- **Stationary weights**: one step leaves them unchanged. -/
def Stationary [Fintype ι] [DecidableEq ι] [Fintype S] (K : (ι → S) → (ι → S) → ℝ)
    (p : (ι → S) → ℝ) : Prop :=
  step K p = p

/-- **Stationary weights come in rearranged sets**: under a kernel commuting with `σ`, the
rearrangement of stationary weights is stationary. -/
theorem stationary_rearranged [Fintype ι] [DecidableEq ι] [Fintype S] {σ : Perm ι}
    {K : (ι → S) → (ι → S) → ℝ} (commutes : KernelCommutes σ K) (stationary : Stationary K p) :
    Stationary K fun c => p (c ∘ σ) := by
  funext c'
  have h := congrFun stationary (c' ∘ σ)
  rw [← h]
  exact Fintype.sum_equiv (rearrange σ) _ _ fun c => by
    simp only [rearrange, Equiv.coe_fn_mk, commutes c c']

/-- **A unique stationary law is exchangeable**: under a kernel commuting with every
rearrangement, where `p` is the only stationary law that is nonnegative and of total one, no
rearrangement changes it. -/
theorem unique_stationary_exchangeable [Fintype ι] [DecidableEq ι] [Fintype S]
    {K : (ι → S) → (ι → S) → ℝ} (commutes : ∀ σ, KernelCommutes σ K) (nonneg : ∀ c, 0 ≤ p c)
    (total : ∑ c, p c = 1) (stationary : Stationary K p)
    (unique : ∀ q : (ι → S) → ℝ, (∀ c, 0 ≤ q c) → ∑ c, q c = 1 → Stationary K q → q = p) :
    Exchangeable p := fun σ c =>
  congrFun (unique (fun c => p (c ∘ σ)) (fun _ => nonneg _)
    ((Equiv.sum_comp (rearrange σ) p).trans total)
    (stationary_rearranged (commutes σ) stationary)) c

/-- **Gibbs weights** `exp (-κ F)` normalized, for any real `κ`, of a free energy no rearrangement
changes, are exchangeable; no kernel is shown here to keep them. -/
theorem gibbs_exchangeable [Fintype ι] [DecidableEq ι] [Fintype S] (κ : ℝ) {F : (ι → S) → ℝ}
    (symmetric : ∀ σ : Perm ι, ∀ c, F (c ∘ σ) = F c) :
    Exchangeable fun c => Real.exp (-κ * F c) / ∑ c', Real.exp (-κ * F c') :=
  fun σ c => by simp only [symmetric σ c]

/-! ### Noise after a rule -/

/-- **A rule with noise of one law at every cell**: from `c`, cell `i` goes from the state `f c i`
the rule gives it to `s'` with weight `q (f c i) s'`, the cells independently. -/
def noisy [Fintype ι] (f : (ι → S) → ι → S) (q : S → S → ℝ) (c c' : ι → S) : ℝ :=
  ∏ i, q (f c i) (c' i)

/-- **Where the rule commutes with a rearrangement, so does the rule with noise of one law at
every cell.** -/
theorem noisy_commutes [Fintype ι] {σ : Perm ι} {f : (ι → S) → ι → S} (q : S → S → ℝ)
    (commutes : ∀ c, f (c ∘ σ) = f c ∘ σ) : KernelCommutes σ (noisy f q) := fun c c' => by
  simp only [noisy, commutes c, Function.comp_apply]
  exact Equiv.prod_comp σ fun i => q (f c i) (c' i)

/-- **No noise**: each cell goes where the rule sends it. -/
def noiseless [DecidableEq S] (s s' : S) : ℝ := if s = s' then 1 else 0

/-- With no noise the rule moves the law of one configuration to the law of its image. -/
theorem step_noiseless [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S]
    (f : (ι → S) → ι → S) (c₀ : ι → S) :
    step (noisy f noiseless) (pointMass c₀) = pointMass (f c₀) := by
  funext c'
  simp only [step, pointMass, ite_mul, one_mul, zero_mul, Finset.sum_ite_eq', Finset.mem_univ,
    if_true, noisy, noiseless]
  rw [Finset.prod_boole]
  by_cases h : c' = f c₀
  · subst h; simp
  · rw [if_neg h, if_neg]
    exact fun all => h (funext fun i => (all i (Finset.mem_univ i)).symm)

/-- **With no noise the law of one configuration follows the rule's run**: at step `n` it is the
law of the configuration the rule reaches. -/
theorem weightsAt_noiseless [Fintype ι] [DecidableEq ι] [Fintype S] [DecidableEq S]
    (f : (ι → S) → ι → S) (c₀ : ι → S) :
    ∀ n, weightsAt (fun _ => noisy f noiseless) (pointMass c₀) n = pointMass (f^[n] c₀)
  | 0 => rfl
  | n + 1 => by
    show step (noisy f noiseless) (weightsAt (fun _ => noisy f noiseless) (pointMass c₀) n) = _
    rw [weightsAt_noiseless f c₀ n, step_noiseless, Function.iterate_succ_apply']

end Laws

/-! ### The core's descent, with noise -/

section Join

open FreeEnergyGuarantees.IdenticalCells (exchangeAt descent)

variable {S γ : Type}

/-- Exchanging neighbouring cells `k` and `k + 1` of a configuration read as a list is
rearranging it by the transposition of `k` and `k + 1`. -/
theorem ofFn_swap : ∀ {m : ℕ} (c : Fin (m + 1) → S) (k : Fin m),
    List.ofFn (c ∘ swap k.castSucc k.succ) = exchangeAt (k : ℕ) (List.ofFn c)
  | 0, _, k => k.elim0
  | m + 1, c, k => by
    refine Fin.cases ?_ (fun j => ?_) k
    · have far : ∀ i : Fin m, swap (0 : Fin (m + 2)) 1 i.succ.succ = i.succ.succ := fun i =>
        swap_apply_of_ne_of_ne (Fin.succ_ne_zero _) (Fin.succ_succ_ne_one i)
      simp only [List.ofFn_succ, Fin.castSucc_zero, Fin.succ_zero_eq_one, Function.comp_apply,
        swap_apply_left, swap_apply_right, far, Fin.val_zero, exchangeAt]
    · have first : swap j.succ.castSucc j.succ.succ (0 : Fin (m + 2)) = 0 :=
        swap_apply_of_ne_of_ne (Fin.succ_castSucc j ▸ Fin.succ_ne_zero _).symm
          (Fin.succ_ne_zero _).symm
      have rest : (c ∘ swap j.succ.castSucc j.succ.succ) ∘ Fin.succ =
          (c ∘ Fin.succ) ∘ swap j.castSucc j.succ := by
        funext i
        simp only [Function.comp_apply, ← Fin.succ_castSucc]
        rw [Fin.succ_injective _ |>.swap_apply]
      rw [List.ofFn_succ, List.ofFn_succ (n := m + 1), Function.comp_apply, first]
      have tail := ofFn_swap (c ∘ Fin.succ) j
      simp only [Fin.val_succ, exchangeAt]
      congr 1
      exact (congrArg List.ofFn rest).trans tail

/-- **What no exchange of neighbouring cells changes, no rearrangement changes**: the
transpositions of neighbours generate every rearrangement. -/
theorem ofFn_rearranged {β : Type} {g : List S → β}
    (exchange : ∀ k l, g (exchangeAt k l) = g l) :
    ∀ {m : ℕ} (σ : Perm (Fin m)) (c : Fin m → S), g (List.ofFn (c ∘ σ)) = g (List.ofFn c)
  | 0, σ, c => congrArg g (congrArg List.ofFn (funext fun i => i.elim0))
  | m + 1, σ, c => by
    let kept : Submonoid (Perm (Fin (m + 1))) :=
      { carrier := {σ | ∀ c : Fin (m + 1) → S, g (List.ofFn (c ∘ σ)) = g (List.ofFn c)}
        one_mem' := fun c => rfl
        mul_mem' := fun {σ τ} hσ hτ c => by
          show g (List.ofFn (c ∘ (σ * τ))) = _
          rw [Perm.coe_mul, ← Function.comp_assoc, hτ (c ∘ σ), hσ c] }
    have generated :
        Submonoid.closure (Set.range fun i : Fin m => swap i.castSucc i.succ) ≤ kept :=
      Submonoid.closure_le.mpr fun _ ⟨k, hk⟩ c => by
        rw [← hk]
        show g (List.ofFn (c ∘ swap k.castSucc k.succ)) = _
        rw [ofFn_swap, exchange]
    have all : σ ∈ kept := generated (by rw [Perm.mclosure_swap_castSucc_succ]; trivial)
    exact all c

/-- **The core's descent read cell by cell**: every cell updates by one rule from its own state
and the field it senses, read from the configuration as a list. -/
def cellwise {m : ℕ} (update : S → γ → S) (field : S → List S → γ) (c : Fin m → S) :
    Fin m → S :=
  fun i => update (c i) (field (c i) (List.ofFn c))

/-- Read as a list, it is the core's descent. -/
theorem ofFn_cellwise {m : ℕ} (update : S → γ → S) (field : S → List S → γ) (c : Fin m → S) :
    List.ofFn (cellwise update field c) = descent update field (List.ofFn c) := by
  rw [descent, List.map_ofFn]; rfl

/-- **Its run read as a list is the core's run** of its descent from the start read as a list. -/
theorem ofFn_iterate_cellwise {m : ℕ} (update : S → γ → S) (field : S → List S → γ)
    (c : Fin m → S) : ∀ n, List.ofFn ((cellwise update field)^[n] c) =
      (Law.run (descent update field) (List.ofFn c)).state n
  | 0 => rfl
  | n + 1 => by
    rw [Function.iterate_succ_apply', ofFn_cellwise, ofFn_iterate_cellwise update field c n]
    rfl

/-- **The core's never-parting law, cell by cell, for any two cells**: two cells alike at the start
are alike at every step, whatever the field reads. -/
theorem cellwise_alike {m : ℕ} (update : S → γ → S) (field : S → List S → γ) {c₀ : Fin m → S}
    {i j : Fin m} (alike : c₀ i = c₀ j) :
    ∀ n, (cellwise update field)^[n] c₀ i = (cellwise update field)^[n] c₀ j
  | 0 => alike
  | n + 1 => by
    simp only [Function.iterate_succ_apply', cellwise, cellwise_alike update field alike n]

/-- **With no noise the law weighs one exactly the configuration the core's run reaches**: at step
`n`, from the law of one configuration, a configuration has weight one exactly where, read as a
list, it is the core's run of its descent at step `n`. -/
theorem noiseless_run [Fintype S] [DecidableEq S] {m : ℕ} (update : S → γ → S)
    (field : S → List S → γ) (c₀ c : Fin m → S) (n : ℕ) :
    weightsAt (fun _ => noisy (cellwise update field) noiseless) (pointMass c₀) n c = 1 ↔
      List.ofFn c = (Law.run (descent update field) (List.ofFn c₀)).state n := by
  rw [weightsAt_noiseless, ← ofFn_iterate_cellwise, List.ofFn_inj]
  simp only [pointMass]; split <;> simp_all

/-- **With an exchangeable field the descent commutes with every rearrangement of the cells.** -/
theorem cellwise_commutes {m : ℕ} {update : S → γ → S} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field) (σ : Perm (Fin m))
    (c : Fin m → S) : cellwise update field (c ∘ σ) = cellwise update field c ∘ σ :=
  funext fun i => congrArg (update (c (σ i)))
    (ofFn_rearranged (g := field (c (σ i))) (exchangeable · (c (σ i))) σ c)

/-- **The core's run from a rearranged start is the rearranged run**, for every rearrangement,
where the field is exchangeable. -/
theorem run_rearranged {m : ℕ} {update : S → γ → S} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field) (σ : Perm (Fin m))
    (c : Fin m → S) (n : ℕ) :
    (Law.run (descent update field) (List.ofFn (c ∘ σ))).state n =
      List.ofFn ((cellwise update field)^[n] c ∘ σ) := by
  rw [← ofFn_iterate_cellwise]
  congr 1
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih, cellwise_commutes exchangeable,
      Function.iterate_succ_apply']

/-- **A free energy symmetric in the cells is unchanged by every rearrangement.** -/
theorem symmetric_rearranged {m : ℕ} {F : List S → ℕ}
    (symmetric : FreeEnergyGuarantees.IdenticalCells.Symmetric F)
    (σ : Perm (Fin m)) (c : Fin m → S) : F (List.ofFn (c ∘ σ)) = F (List.ofFn c) :=
  ofFn_rearranged symmetric σ c

/-- **The Gibbs weights of a free energy symmetric in the cells are exchangeable**: `exp (-κ F)`
normalized, `F` symmetric in the core's sense, as the core's `freeEnergy` is at an exchangeable
field (`freeEnergy_symmetric`), read on the configuration as a list. -/
theorem gibbs_symmetric_exchangeable [Fintype S] {m : ℕ} (κ : ℝ) {F : List S → ℕ}
    (symmetric : FreeEnergyGuarantees.IdenticalCells.Symmetric F) :
    Exchangeable fun c : Fin m → S =>
      Real.exp (-κ * F (List.ofFn c)) / ∑ c' : Fin m → S, Real.exp (-κ * F (List.ofFn c')) :=
  gibbs_exchangeable κ fun σ c => by rw [symmetric_rearranged symmetric σ c]

/-- **The core's descent with noise of one law at every cell**: from `c`, each cell, in state `x`
and sensing the field `z` read from the configuration as a list, goes to `s'` with weight
`r x z s'`, the cells independently; noise in what the cell senses, independent across cells, is a
case. -/
def noisyDescent {m : ℕ} (r : S → γ → S → ℝ) (field : S → List S → γ) (c c' : Fin m → S) : ℝ :=
  ∏ i, r (c i) (field (c i) (List.ofFn c)) (c' i)

/-- Noise after the core's update is a case. -/
theorem noisy_eq_noisyDescent {m : ℕ} (update : S → γ → S) (field : S → List S → γ)
    (q : S → S → ℝ) :
    noisy (cellwise update field) q =
      noisyDescent (m := m) (fun x z s' => q (update x z) s') field :=
  rfl

/-- **With an exchangeable field the descent with noise commutes with every rearrangement.** -/
theorem noisyDescent_commutes {m : ℕ} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    (r : S → γ → S → ℝ) (σ : Perm (Fin m)) : KernelCommutes σ (noisyDescent r field) :=
  fun c c' => by
    have h : ∀ x, field x (List.ofFn (c ∘ σ)) = field x (List.ofFn c) :=
      fun x => ofFn_rearranged (g := field x) (exchangeable · x) σ c
    simp only [noisyDescent, Function.comp_apply, h]
    exact Equiv.prod_comp σ fun i => r (c i) (field (c i) (List.ofFn c)) (c' i)

/-- The descent with noise is nonnegative where the noise is. -/
theorem noisyDescent_nonneg {m : ℕ} {r : S → γ → S → ℝ} {field : S → List S → γ}
    (nonneg : ∀ x z s', 0 ≤ r x z s') (c c' : Fin m → S) : 0 ≤ noisyDescent r field c c' :=
  Finset.prod_nonneg fun _ _ => nonneg _ _ _

/-- Its weights from each configuration total one where the noise's from each state and field
do. -/
theorem noisyDescent_rows [Fintype S] {m : ℕ} {r : S → γ → S → ℝ} {field : S → List S → γ}
    (rows : ∀ x z, ∑ s', r x z s' = 1) (c : Fin m → S) : ∑ c', noisyDescent r field c c' = 1 := by
  unfold noisyDescent
  rw [← Fintype.prod_sum]
  exact Finset.prod_eq_one fun _ _ => rows _ _

/-- **Identical cells under the core's descent with noise of one law at every cell: exchangeable
weights stay exchangeable.** Under a descent with an exchangeable field and noise `r k` at step `k`,
from an exchangeable start, the weights are exchangeable at every step; so every cell has the
weights of every other (`marginal_eq`). -/
theorem noisyDescent_exchangeable [Fintype S] {m : ℕ} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    (r : ℕ → S → γ → S → ℝ) {p : (Fin m → S) → ℝ} (start : Exchangeable p) (n : ℕ) :
    Exchangeable (weightsAt (fun k => noisyDescent (r k) field) p n) :=
  weightsAt_exchangeable (fun k σ => noisyDescent_commutes exchangeable (r k) σ) start n

/-- **No assignment of distinct states has more than its share**: with an exchangeable field, from
an exchangeable start, where the noise and the start are laws, each assignment of distinct states
to the `m` cells has weight at most `1 / m!` at every step. -/
theorem noisyDescent_distinct_le [Fintype S] [DecidableEq S] {m : ℕ} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    {r : ℕ → S → γ → S → ℝ} (nonneg : ∀ k x z s', 0 ≤ r k x z s')
    (rows : ∀ k x z, ∑ s', r k x z s' = 1) {p : (Fin m → S) → ℝ} (start : Exchangeable p)
    (start_nonneg : ∀ c, 0 ≤ p c) (start_total : ∑ c, p c = 1) (n : ℕ) {c : Fin m → S}
    (distinct : Function.Injective c) :
    weightsAt (fun k => noisyDescent (r k) field) p n c ≤ 1 / m.factorial := by
  have law := weightsAt_law (K := fun k => noisyDescent (r k) field)
    (fun k => noisyDescent_nonneg (nonneg k)) (fun k => noisyDescent_rows (rows k))
    start_nonneg start_total n
  have h := distinct_le (noisyDescent_exchangeable exchangeable r start n) law.1 law.2 distinct
  rwa [Fintype.card_fin] at h

/-- **From all cells in one state** (`noisyDescent_distinct_le`, with the start
`alike_exchangeable`). -/
theorem noisyDescent_from_alike [Fintype S] [DecidableEq S] {m : ℕ} {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    {r : ℕ → S → γ → S → ℝ} (nonneg : ∀ k x z s', 0 ≤ r k x z s')
    (rows : ∀ k x z, ∑ s', r k x z s' = 1) (a : S) (n : ℕ) {c : Fin m → S}
    (distinct : Function.Injective c) :
    weightsAt (fun k => noisyDescent (r k) field) (pointMass fun _ => a) n c ≤ 1 / m.factorial :=
  noisyDescent_distinct_le exchangeable nonneg rows (alike_exchangeable a) (pointMass_law _).1
    (pointMass_law _).2 n distinct

/-- **From the cells independent and of one law** (`noisyDescent_distinct_le`, with the start
`independent_exchangeable`). -/
theorem noisyDescent_from_independent [Fintype S] [DecidableEq S] {m : ℕ}
    {field : S → List S → γ}
    (exchangeable : FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    {r : ℕ → S → γ → S → ℝ} (nonneg : ∀ k x z s', 0 ≤ r k x z s')
    (rows : ∀ k x z, ∑ s', r k x z s' = 1) {q₀ : S → ℝ} (q₀_nonneg : ∀ s, 0 ≤ q₀ s)
    (q₀_total : ∑ s, q₀ s = 1) (n : ℕ) {c : Fin m → S} (distinct : Function.Injective c) :
    weightsAt (fun k => noisyDescent (r k) field) (fun c => ∏ i, q₀ (c i)) n c ≤ 1 / m.factorial :=
  noisyDescent_distinct_le exchangeable nonneg rows (independent_exchangeable q₀)
    (independent_law q₀_nonneg q₀_total).1 (independent_law q₀_nonneg q₀_total).2 n distinct

/-- **In finitely many states independent noise never parts identical cells with certainty**: from
all cells in one state, under the descent with noise that is a law, some configuration of all cells
alike has positive weight at every step. -/
theorem alike_positive [Fintype S] [DecidableEq S] {m : ℕ} {field : S → List S → γ}
    {r : ℕ → S → γ → S → ℝ} (nonneg : ∀ k x z s', 0 ≤ r k x z s')
    (rows : ∀ k x z, ∑ s', r k x z s' = 1) (a : S) :
    ∀ n, ∃ b, 0 < weightsAt (fun k => noisyDescent (r k) field) (pointMass fun _ : Fin m => a) n
      (fun _ => b)
  | 0 => ⟨a, by simp [weightsAt, pointMass]⟩
  | n + 1 => by
    obtain ⟨b, pos⟩ := alike_positive (m := m) (field := field) nonneg rows a n
    set z := field b (List.ofFn fun _ : Fin m => b)
    obtain ⟨b', hb'⟩ : ∃ b', 0 < r n b z b' := by
      by_contra none
      simp only [not_exists, not_lt] at none
      have : ∑ s', r n b z s' = 0 :=
        Finset.sum_eq_zero fun s _ => le_antisymm (none s) (nonneg n b z s)
      rw [rows n b z] at this; exact one_ne_zero this
    refine ⟨b', ?_⟩
    have law := weightsAt_law (K := fun k => noisyDescent (r k) field)
      (fun k => noisyDescent_nonneg (nonneg k)) (fun k => noisyDescent_rows (rows k))
      (pointMass_law (fun _ : Fin m => a)).1 (pointMass_law _).2 n
    have kernel : noisyDescent (r n) field (fun _ : Fin m => b) (fun _ => b') = r n b z b' ^ m := by
      simp [noisyDescent, z]
    show 0 < ∑ c, weightsAt (fun k => noisyDescent (r k) field) (pointMass fun _ : Fin m => a) n c *
      noisyDescent (r n) field c (fun _ => b')
    calc 0 < weightsAt (fun k => noisyDescent (r k) field) (pointMass fun _ => a) n (fun _ => b) *
          noisyDescent (r n) field (fun _ => b) (fun _ => b') := by
          rw [kernel]; exact mul_pos pos (pow_pos hb' m)
      _ ≤ _ := Finset.single_le_sum (f := fun c => weightsAt (fun k => noisyDescent (r k) field)
          (pointMass fun _ => a) n c * noisyDescent (r n) field c (fun _ => b'))
          (fun c _ => mul_nonneg (law.1 c) (noisyDescent_nonneg (nonneg n) _ _))
          (Finset.mem_univ _)

end Join

/-! ### Two cells: independent noise parts them with positive weight, a kernel assigning the places
by the cells' numbers with certainty; a field reading the first cell assigns the places -/

namespace Witness

open FreeEnergyGuarantees.IdenticalCells (exchangeAt)

/-- Two cells, each on or off. -/
abbrev Two := Fin 2 → Bool

/-- A sum over the four configurations of two cells. -/
theorem sum_two (g : Two → ℝ) :
    ∑ c, g c = g ![false, false] + g ![false, true] + g ![true, false] + g ![true, true] := by
  rw [← (piFinTwoEquiv fun _ => Bool).symm.sum_comp g]
  simp only [Fintype.sum_prod_type, Fintype.sum_bool, piFinTwoEquiv_symm_apply]
  have e : ∀ a b : Bool, (Fin.cons a (Fin.cons b finZeroElim) : Fin 2 → Bool) = ![a, b] :=
    fun a b => by funext i; fin_cases i <;> rfl
  simp only [e]; ring

/-- **The parted half and half**: weight one half on each parted configuration, none on the
alike ones. -/
noncomputable def partedUniform (c : Two) : ℝ := if c 0 ≠ c 1 then 1 / 2 else 0

/-- It is a law: nonnegative, of total one. -/
theorem partedUniform_law : (∀ c, 0 ≤ partedUniform c) ∧ ∑ c, partedUniform c = 1 := by
  refine ⟨fun c => by unfold partedUniform; split <;> norm_num, ?_⟩
  rw [sum_two]; simp [partedUniform]; norm_num

/-- **The parted half and half is no product of one weighting per cell**: independent cells cannot
give it. -/
theorem partedUniform_not_product :
    ¬ ∃ w : Fin 2 → Bool → ℝ, ∀ c : Two, partedUniform c = w 0 (c 0) * w 1 (c 1) := by
  rintro ⟨w, v⟩
  have tt := v ![true, true]
  have tf := v ![true, false]
  have ft := v ![false, true]
  simp [partedUniform] at tt tf ft
  rcases tt with h | h
  · rw [h] at tf; norm_num at tf
  · rw [h] at ft; norm_num at ft

/-- Every rearrangement of two cells keeps them parted or alike. -/
theorem parted_rearranged (σ : Perm (Fin 2)) (c : Two) : (c (σ 0) ≠ c (σ 1)) ↔ (c 0 ≠ c 1) := by
  have apart : σ 0 ≠ σ 1 := fun h => absurd (σ.injective h) (by decide)
  generalize σ 0 = a, σ 1 = b at apart ⊢
  fin_cases a <;> fin_cases b <;> simp_all [ne_comm]

/-- **A kernel to the parted half and half**: from any configuration the cells go to one of the two
parted configurations, each with weight one half. -/
noncomputable def toParted (_ c' : Two) : ℝ := partedUniform c'

/-- It commutes with every rearrangement. -/
theorem toParted_commutes (σ : Perm (Fin 2)) : KernelCommutes σ toParted := fun c c' => by
  simp only [toParted, partedUniform, Function.comp_apply, parted_rearranged]

/-- **It is no rule with noise of one law at every cell.** -/
theorem toParted_not_noisy (f : Two → Fin 2 → Bool) (q : Bool → Bool → ℝ) :
    toParted ≠ noisy f q := fun h => partedUniform_not_product
  ⟨fun i s => q (f ![false, false] i) s, fun c' => by
    have := congrFun (congrFun h ![false, false]) c'
    simpa [toParted, noisy, Fin.prod_univ_two] using this⟩

/-- **Nor is it the core's descent with noise of one law at every cell.** -/
theorem toParted_not_noisyDescent {γ : Type} (r : Bool → γ → Bool → ℝ)
    (field : Bool → List Bool → γ) : toParted ≠ noisyDescent r field := fun h =>
  partedUniform_not_product
  ⟨fun i s => r (![false, false] i) (field (![false, false] i) (List.ofFn ![false, false])) s,
    fun c' => by
      have := congrFun (congrFun h ![false, false]) c'
      simpa [toParted, noisyDescent, Fin.prod_univ_two] using this⟩

/-- **A rule assigning the places by the cells' numbers**: cell `0` on and cell `1` off, whatever
the configuration. -/
def assign (_ : Two) : Two := ![true, false]

/-- It does not commute with exchanging the cells. -/
theorem assign_not_commutes : ¬ ∀ c : Two, assign (c ∘ swap 0 1) = assign c ∘ swap 0 1 := by
  intro h
  have := congrFun (h ![false, false]) 0
  simp [assign] at this

/-- **The kernel to the parted half and half is the fair mixture of the rule assigning the places by
the cells' numbers and its exchange**, each with no noise. -/
theorem toParted_eq_mixture (c c' : Two) :
    toParted c c' = 1 / 2 * noisy assign noiseless c c' +
      1 / 2 * noisy (fun c => assign c ∘ swap 0 1) noiseless c c' := by
  obtain ⟨a, b, rfl⟩ : ∃ a b : Bool, c' = ![a, b] :=
    ⟨c' 0, c' 1, by funext i; fin_cases i <;> rfl⟩
  cases a <;> cases b <;>
  simp [toParted, partedUniform, noisy, noiseless, assign, Fin.prod_univ_two]

/-- **Independent noise can part identical cells**: with each cell's next state set by a fair coin
of its own, from two cells off, after one step cell `0` off and cell `1` on has weight one
quarter. -/
theorem independentNoise_parts :
    weightsAt (fun _ => noisyDescent (fun _ _ _ => (1 / 2 : ℝ))
        fun (_ : Bool) (_ : List Bool) => ())
      (pointMass fun _ => false) 1 ![false, true] = 1 / 4 := by
  simp [weightsAt, step, pointMass, noisyDescent, Finset.sum_ite_eq']
  norm_num

/-- From two alike cells the law after one step is the parted half and half. -/
theorem toParted_once (b : Bool) :
    weightsAt (fun _ => toParted) (pointMass fun _ => b) 1 = partedUniform := by
  funext c'
  simp [weightsAt, step, pointMass, toParted, Finset.sum_ite_eq']

/-- **Parting is certain**: after one step from either alike start the alike configurations have
no weight. -/
theorem alike_none (b b' : Bool) :
    weightsAt (fun _ => toParted) (pointMass fun _ => b) 1 (fun _ => b') = 0 := by
  rw [toParted_once]; simp [partedUniform]

/-- **Which cell is which is even**: each parted configuration has weight one half, the bound one
over the two orderings of the cells. -/
theorem each_half (b : Bool) :
    weightsAt (fun _ => toParted) (pointMass fun _ => b) 1 ![true, false] = 1 / 2 ∧
      weightsAt (fun _ => toParted) (pointMass fun _ => b) 1 ![false, true] = 1 / 2 := by
  rw [toParted_once]; simp [partedUniform]

/-- **The only stationary law gives the alike configurations no weight**: a law of total one is
stationary under it exactly where it is the parted half and half. -/
theorem toParted_stationary_iff (p : Two → ℝ) (total : ∑ c, p c = 1) :
    Stationary toParted p ↔ p = partedUniform := by
  have once : step toParted p = partedUniform := by
    funext c'
    simp only [step, toParted, ← Finset.sum_mul, total, one_mul]
  unfold Stationary
  rw [once]
  exact ⟨fun h => h.symm, fun h => h.symm⟩

/-- **Unique, so exchangeable**: here through `unique_stationary_exchangeable` (`parted_rearranged`
gives it directly), with all its weight on parted configurations. -/
theorem partedUniform_exchangeable : Exchangeable partedUniform :=
  unique_stationary_exchangeable toParted_commutes partedUniform_law.1 partedUniform_law.2
    ((toParted_stationary_iff _ partedUniform_law.2).mpr rfl)
    (fun q _ total stationary => (toParted_stationary_iff q total).mp stationary)

/-- **A field reading the state of the first cell**: it reads no cell's own number, but reads the
cells' places through the order of the list. -/
def firstCell (_ : Bool) (l : List Bool) : Bool := l.headD false

/-- Each cell flips where the field is on. -/
def flipBy (x z : Bool) : Bool := xor x z

/-- The field reading the first cell is not exchangeable. -/
theorem firstCell_not_exchangeable :
    ¬ FreeEnergyGuarantees.IdenticalCells.Exchangeable firstCell := by
  intro h
  have := h 0 false [true, false]
  simp [firstCell, exchangeAt] at this

/-- **A field that is not exchangeable can assign the places**: from the parted half and half,
which no rearrangement changes, with no noise, the descent by the field reading the first cell gives
cell `0` off and cell `1` on weight one, above one half, and the two cells different laws. -/
theorem firstCell_assigns :
    weightsAt (fun _ => noisy (cellwise flipBy firstCell) noiseless) partedUniform 1
        ![false, true] = 1 ∧
      marginal (weightsAt (fun _ => noisy (cellwise flipBy firstCell) noiseless) partedUniform 1)
        0 false = 1 ∧
      marginal (weightsAt (fun _ => noisy (cellwise flipBy firstCell) noiseless) partedUniform 1)
        1 false = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;>
  simp [marginal, weightsAt, step, noisy, cellwise, noiseless, partedUniform, firstCell, flipBy,
    sum_two, Fin.prod_univ_two] <;> norm_num

end Witness

end Becoming.CellsUnderNoise
