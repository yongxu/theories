import Becoming.Loops

/-!
# Remainder: what a cut loses, for every schedule of couplings

`Becoming.Loops` (P118) calculates the carried amount order by order and shows when a cut at a
finite order is exact. Its equivalence needs two premises: every coupling holds at every step, and
every condition is listed. A loop coupled at the first step only shows that the first cannot be
dropped as it stands (`Loops.Once.not_always`). This module states exactly what a cut loses and
where, for every schedule of couplings and any list of conditions, with no premise beyond the
strengths each statement names. Where the schedule has settled, the loops of the couplings that go
on decide.

* **The exact remainder.** One response carries to a condition what the strengths make of given
  levels, with no starting gap and no gap of the part (`responded`). `j` responses in turn carry
  what one response carries from what `j - 1` carry (`responses`). The carried amount is the orders
  below `j` plus what `j` responses in turn carry from the carried amount itself
  (`carried_eq_orderBelow_add`). So a cut at order `j` loses exactly what `j + 1` responses carry
  from the carried amount (`carried_eq_carriedWithin_add`). The proof only adds, since giving is
  additive in the levels read (`carriedGive_add`, `carriedFrom_add`). The loss shrinks as the order
  rises (`responses_antitone`). For every schedule it is at most the bound of `Becoming.Loops`
  (`responses_le_missBound`; read on the world the carrying law generates,
  `carriedWorld_within_cut`), and the self-loop loses exactly that (`Loops.SelfLoop.responses_eq`).
* **Where a cut loses.** One response carries something to `c` by step `t` exactly where, at a step
  before `t`, the level of a condition is coupled into `c` (`CouplesAt`) and is positive
  (`responded_pos_iff`). A gap is conveyed to `c` through `j` responses or more
  (`ConveyedThrough`) where `Becoming.Propagation`'s route in time (`Conveyed`) reaches a condition
  and `j` couplings carry it on to `c`, each at a step after the level it reads was reached. The
  orders below `j` miss something at `c` at step `t` exactly where a gap is conveyed there through
  `j` responses or more (`orderBelow_lt_iff`). Order `j` is exact there exactly where none is
  conveyed through `j + 1` (`carriedWithin_eq_iff`).
* **From every start.** A chain of `j` couplings in time order ends at `c` by step `t`
  (`CoupledIntoBy`) where each coupling reads a level the one before had reached. Order `j` is exact
  at `c` at step `t` from every starting gap exactly where no such chain of `j + 1` couplings ends
  there (`exact_every_start_iff`). A finite order is exact at `c` at every step from every start
  exactly where the chains in time order into `c` are bounded in length
  (`finite_order_iff_bounded`); one order then serves every start (`finite_order_uniform_iff`). A
  chain in time order of `j` couplings needs `j` steps (`CoupledIntoBy.le_steps`), and without time
  it is a chain of couplings (`CoupledIntoBy.coupledInto`).
* **Couplings that come and go.** A coupling recurs (`CouplingRecurs`) where it reads levels at steps
  as late as one likes.
  - Where a gap reaches a loop of recurring couplings, and recurring couplings lead from it to `c`,
    every order misses something at `c` (`carriedWithin_lt_of_recurring_loop`). The chains in time
    order into `c` are then unbounded (`unbounded_of_recurring_loop`).
  - Where no coupling reads a level from step `N` on, order `N` is exact everywhere
    (`exact_of_reading_before`).
  - Each coupling reads a listed condition, so a chain one longer than the list passes a loop, with
    no listing of every condition (`loop_of_coupledInto_succ`). Where no loop lies upstream of `c`,
    no chain in time order of more couplings than there are conditions ends there
    (`no_chain_of_no_loop`; one fewer with every condition listed, `no_chain_of_no_loop_listed`).
  - Where couplings hold at every step, they recur (`CouplesAlways.recurs`). So bounded chains are
    exactly no loop upstream (`bounded_iff_no_loop`), with no listing.
* **Where the schedule settles.** The strengths from step `N` on drop every reading of a level
  before `N` (`strengthsFrom`). A coupling recurs exactly where it is a coupling of the strengths
  from every step on (`couplingRecurs_iff`). Of a chain in time order of `N + j` couplings, the last
  `j` are a chain of the couplings from step `N` on (`CoupledIntoBy.tail`). So where no loop of those
  lies upstream, the chains are bounded (`no_chain_of_no_loop_from`). The schedule has settled by step
  `N` (`SettledFrom`) where every coupling from `N` on recurs; couplings at every step have settled
  from the first (`settledFrom_zero_of_always`). Where the schedule has settled, a finite order is
  exact at `c` from every start exactly where no loop of the couplings from step `N` on lies
  upstream of `c` (`bounded_iff_no_loop_from`, `finite_order_iff_no_loop_from`). Where no loop of the
  couplings from some step on lies upstream, the carried amount is at most a polynomial in the steps,
  whatever the schedule (`carried_le_polynomial_from`): the most difference that can arrive grows
  faster than every polynomial only through a loop of the couplings that go on. The loop of
  `Loops.Once` reads the first step only (`Loops.Once.reads_first`). It has no chain of two
  couplings in time order (`Loops.Once.no_chain_of_two`), and its schedule has settled from the
  second step with nothing coupling (`Loops.Once.none_from_one`, `Loops.Once.settled`).
* **`Becoming.Loops` as instances.** Its results on exactness are cases of these: order `j` is
  exact up to step `j` (`carriedWithin_exact`) because a chain in time order of `j + 1` couplings
  needs `j + 1` steps (`CoupledIntoBy.le_steps`, `exact_every_start_iff`), and no loop upstream
  suffices (`carriedWithin_exact_of_no_loop`) because no chain is then that long
  (`no_chain_of_no_loop_listed`). Its equivalence where couplings hold at every step is re-derived,
  now without its listing of every condition (`Remainder.finite_order_iff_no_loop`), and so is the
  loop coupled once (`Loops.Once.exact`).
* **For every law.** By `most_difference_arrives`, every gap of every law of what has stood with
  the strengths, from every start, is at most what order `j` carries exactly where no chain of
  `j + 1` couplings in time order ends there (`gap_within_order_iff`).

**Readings (the AI's, D43).**
- On 12 October Ren asked about the loops: "how how accurate can we do that uh what is the
  limitation do we have losses". On 16 October Ren took the orders of `Becoming.Loops` as the same
  structural kind as the sum over histories, organized by the number of responses as Feynman
  diagrams are by their vertices. The exact remainder states what a cut of that expansion loses, in
  the form of a Neumann series's remainder: the orders below `j` are the terms of fewer than `j`
  responses, and a cut loses what `j` responses carry from the whole. As in time-ordered
  perturbation theory (the Dyson series), the responses of a route come in time order, each at a
  step after the level it reads was reached, and a cut loses exactly where a route in time with
  more responses arrives. The loss is the cut's, not the theory's: the carried amount itself is
  exact.
- Ren took, for now, that loops form and dissolve within the unfolding and that the theorems take
  them as they stand at each step. For a cut, what decides the loss is the time order of the
  couplings, not loops drawn without time: the loops that matter are those of the couplings that go
  on. Once the schedule has settled, a finite order is exact exactly where none of them lies
  upstream. A loop whose couplings stop is passing: what it carries, a finite order carries.
- Ren took "only a loop makes a difference run away", with couplings at only some steps open. For
  every schedule, the most difference that can arrive grows faster than every polynomial only
  through a loop of the couplings that go on (`carried_le_polynomial_from`). Whether it does so
  through every such loop is not derived here: a loop of recurring couplings leaves every finite
  order inexact (`carriedWithin_lt_of_recurring_loop`), which is not yet a rate.

What is not derived: the strengths themselves; that every schedule settles at some step (a coupling
that does not recur stops, but whether one recurs is not decided here, and the core assumes no
excluded middle); whether the most difference that can arrive runs away through every loop of
recurring couplings, and how fast a runaway is beyond the product of the strengths around a loop;
laws reading infinitely many conditions at a step; real amounts and continuous time. No ethical
predicate, ranking or axiom occurs.

**Classical sources.** The exact remainder is the remainder of a truncated Neumann (path-sum)
series, and the Dyson series is its time-ordered form; that a finite order is exact where no
chain of couplings in time order of the next length ends at a condition is, once the schedule is
fixed, nilpotence of the time-ordered couplings, the time-ordered form of "nilpotent exactly where
acyclic".
-/

namespace Becoming

variable {F C : Type}

namespace Remainder

/-- A product of positive numbers is positive. -/
theorem mul_pos_nat {a b : Nat} (pa : 0 < a) (pb : 0 < b) : 0 < a * b :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_zero a).symm) (Naturals.mul_lt_mul_of_pos pa pb)

end Remainder

/-! ## What responses carry, and the exact remainder -/

section Cut

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **What one response carries.** What arrives at `c` by step `t` through one response reading the
levels `l`: the carrying law with no starting gap and no gap of the part, read from `l`. -/
def responded (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (l : Nat → C → Nat) : Nat → C → Nat :=
  carriedFrom cs part (fun _ _ _ => 0) k present (fun _ => 0) l

/-- **What `j` responses in turn carry** from the levels `l`: none carry `l` itself; `j + 1` carry
what one response carries from what `j` carry. -/
def responses (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (l : Nat → C → Nat) : Nat → Nat → C → Nat
  | 0 => l
  | j + 1 => responded cs part k present (responses cs part k present l j)

/-- One response carries nothing to the start. -/
theorem responded_zero (l : Nat → C → Nat) (c : C) : responded cs part k present l 0 c = 0 := rfl

/-- Across each step, what one response carries grows by what the formations present give from the
levels, the part giving nothing. -/
theorem responded_succ (l : Nat → C → Nat) (t : Nat) (c : C) :
    responded cs part k present l (t + 1) c =
      responded cs part k present l t c +
        total (present t) fun h => carriedGive cs part (fun _ _ _ => 0) k t h c l := rfl

/-- **Giving is additive in the levels read.** What a formation gives from two sets of levels
together is what it gives from the first, with the part's gaps, and from the second, with none. -/
theorem carriedGive_add (t : Nat) (h : F) (c : C) (l m : Nat → C → Nat) :
    carriedGive cs part σ k t h c (fun s d => l s d + m s d) =
      carriedGive cs part σ k t h c l + carriedGive cs part (fun _ _ _ => 0) k t h c m :=
  match hp : part h with
  | true =>
    have first : carriedGive cs part σ k t h c l = σ t h c := carriedGive_of_part hp
    have second : carriedGive cs part (fun _ _ _ => 0) k t h c m = 0 := carriedGive_of_part hp
    (carriedGive_of_part hp).trans ((Nat.add_zero _).symm.trans
      (Naturals.add_congr first.symm second.symm))
  | false =>
    (carriedGive_of_rest hp).trans
      ((total_congr_on fun _ _ => (total_congr_on fun _ _ => Nat.left_distrib _ _ _).trans
          (total_add _ _ _)).trans
        ((total_add _ _ _).trans
          (Naturals.add_congr (carriedGive_of_rest hp).symm (carriedGive_of_rest hp).symm)))

/-- **What is carried is additive in the levels read.** Carried from two sets of levels together:
what is carried from the first, with the starting gaps and the part's gaps, and what one response
carries from the second. -/
theorem carriedFrom_add (l m : Nat → C → Nat) :
    ∀ t c, carriedFrom cs part σ k present δ (fun s d => l s d + m s d) t c =
      carriedFrom cs part σ k present δ l t c + responded cs part k present m t c
  | 0, _ => rfl
  | t + 1, c =>
    (Naturals.add_congr (carriedFrom_add l m t c)
        ((total_congr_on fun h _ => carriedGive_add t h c l m).trans (total_add _ _ _))).trans
      (Nat.add_add_add_comm _ _ _ _)

/-- **The exact remainder.** The carried amount is the orders below `j` plus what `j` responses in
turn carry from the carried amount itself, for every schedule of couplings. -/
theorem carried_eq_orderBelow_add :
    ∀ j t c, carried cs part σ k present δ t c =
      orderBelow cs part σ k present δ j t c +
        responses cs part k present (carried cs part σ k present δ) j t c
  | 0, _, _ => (Nat.zero_add _).symm
  | j + 1, t, c =>
    (carriedFrom_carried t c).symm.trans
      ((carriedFrom_congr t (l' := fun s d => orderBelow cs part σ k present δ j s d +
          responses cs part k present (carried cs part σ k present δ) j s d)
          (fun s d _ _ => carried_eq_orderBelow_add j s d) c).trans
        ((carriedFrom_add (orderBelow cs part σ k present δ j)
            (responses cs part k present (carried cs part σ k present δ) j) t c).trans
          (congrArg (· + _) (carriedWithin_eq_carriedFrom j t c).symm)))

/-- **What a cut loses.** The carried amount is order `j` plus what `j + 1` responses in turn carry
from the carried amount: a cut at order `j` loses exactly that. -/
theorem carried_eq_carriedWithin_add (j t : Nat) (c : C) :
    carried cs part σ k present δ t c =
      carriedWithin cs part σ k present δ j t c +
        responses cs part k present (carried cs part σ k present δ) (j + 1) t c :=
  carried_eq_orderBelow_add (j + 1) t c

/-- **The loss shrinks as the order rises.** What `j'` responses carry from the carried amount is
at most what `j` carry, wherever `j ≤ j'`. -/
theorem responses_antitone {j j' : Nat} (le : j ≤ j') (t : Nat) (c : C) :
    responses cs part k present (carried cs part σ k present δ) j' t c ≤
      responses cs part k present (carried cs part σ k present δ) j t c :=
  Naturals.le_of_add_le_add_left (Nat.le_trans (Nat.le_of_eq (carried_eq_orderBelow_add j' t c).symm)
    (Nat.le_trans (Nat.le_of_eq (carried_eq_orderBelow_add j t c))
      (Nat.add_le_add_right (orderBelow_mono le t c) _)))

/-- **How much a cut loses, for every schedule.** With the part giving no gap, starting gaps at most
`D` and the strengths into each condition summing to at most `M` at each step, what a cut at order
`j` loses is at most `Loops.missBound M D j t`, whatever the schedule of couplings. -/
theorem responses_le_missBound {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) (j t : Nat) (c : C) :
    responses cs part k present (carried cs part (fun _ _ _ => 0) k present δ) (j + 1) t c ≤
      Loops.missBound M D j t :=
  Naturals.le_of_add_le_add_left (Nat.le_trans (Nat.le_of_eq (carried_eq_carriedWithin_add j t c).symm)
    (carried_le_carriedWithin_add start into j t c))

/-- **What a cut loses, read on the world the carrying law generates.** In the carried world with the
part giving no gap, the standing of each condition at step `t` is within what the cut at order `j`
carries, with `Loops.missBound M D j t`: the base reading of `responses_le_missBound`, whatever the
schedule of couplings. -/
theorem carriedWorld_within_cut {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) (j t : Nat) (c : C) :
    (carriedWorld cs part (fun _ _ _ => 0) k present δ).web.level t (.inr c) ≤
      carriedWithin cs part (fun _ _ _ => 0) k present δ j t c + Loops.missBound M D j t :=
  Nat.le_trans (Nat.le_of_eq ((carriedWorld_level t c).trans (carried_eq_carriedWithin_add j t c)))
    (Nat.add_le_add_left (responses_le_missBound start into j t c) _)

end Cut

/-- **The self-loop loses exactly the bound.** With starting gap `D` and strength `M`, what a cut at
order `j` loses is `Loops.missBound M D j t`. -/
theorem Loops.SelfLoop.responses_eq (M D j t : Nat) :
    responses [()] (fun _ => false) (Loops.SelfLoop.strengths M) (fun _ => [()])
        (carried [()] (fun _ => false) (fun _ _ _ => 0) (Loops.SelfLoop.strengths M) (fun _ => [()])
          (fun _ => D)) (j + 1) t () =
      Loops.missBound M D j t :=
  Naturals.add_left_cancel ((carried_eq_carriedWithin_add j t ()).symm.trans
    (Loops.SelfLoop.attained M D j t))

/-! ## Where a cut loses -/

section Where

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **Coupled at a step.** At step `u` a formation present there, outside the part, exchanges with
`c` with positive strength on the level of `d` at step `s`, no later than `u`. -/
def CouplesAt (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (u s : Nat) (d c : C) : Prop :=
  ∃ h, h ∈ present u ∧ part h = false ∧ s ≤ u ∧ d ∈ cs ∧ 0 < k u h c s d

/-- Coupled is coupled at some step. -/
theorem couples_iff_couplesAt {d c : C} :
    Couples cs part k present d c ↔ ∃ u s, CouplesAt cs part k present u s d c :=
  ⟨fun ⟨u, h, s, mem, out, le, dMem, pos⟩ => ⟨u, s, h, mem, out, le, dMem, pos⟩,
   fun ⟨u, s, h, mem, out, le, dMem, pos⟩ => ⟨u, h, s, mem, out, le, dMem, pos⟩⟩

/-- **Where one response carries something.** One response carries something to `c` by step `t`
exactly where, at a step before `t`, the level of a condition is coupled into `c` and positive. -/
theorem responded_pos_iff (l : Nat → C → Nat) :
    ∀ t c, 0 < responded cs part k present l t c ↔
      ∃ u s d, u < t ∧ CouplesAt cs part k present u s d c ∧ 0 < l s d := by
  intro t
  induction t with
  | zero =>
    intro c
    exact ⟨fun pos => absurd pos (Nat.lt_irrefl 0),
      fun ⟨_, _, _, lt, _⟩ => absurd lt (Nat.not_lt_zero _)⟩
  | succ t ih =>
    intro c
    constructor
    · intro pos
      match Loops.zero_or_pos (responded cs part k present l t c) with
      | .inr before =>
        obtain ⟨u, s, d, lt, at_, lpos⟩ := (ih c).mp before
        exact ⟨u, s, d, Nat.lt_succ_of_lt lt, at_, lpos⟩
      | .inl zero =>
        have now : 0 < total (present t) fun h =>
            carriedGive cs part (fun _ _ _ => 0) k t h c l :=
          Nat.lt_of_lt_of_le pos (Nat.le_of_eq ((responded_succ l t c).trans
            ((congrArg (· + _) zero).trans (Nat.zero_add _))))
        obtain ⟨h, mem, given⟩ := total_pos _ now
        match hp : part h with
        | true =>
          exact absurd (Nat.lt_of_lt_of_le given (Nat.le_of_eq (carriedGive_of_part hp)))
            (Nat.lt_irrefl 0)
        | false =>
          have inner : 0 < total (steps 0 (t + 1)) fun s => total cs fun d =>
              k t h c s d * l s d :=
            Nat.lt_of_lt_of_le given (Nat.le_of_eq (carriedGive_of_rest hp))
          obtain ⟨s, sMem, atS⟩ := total_pos _ inner
          obtain ⟨d, dMem, prod⟩ := total_pos _ atS
          obtain ⟨kpos, lpos⟩ := Propagation.pos_of_mul_pos prod
          exact ⟨t, s, d, Nat.lt_succ_self t,
            ⟨h, mem, hp, Propagation.le_of_mem_steps_upto sMem, dMem, kpos⟩, lpos⟩
    · intro ⟨u, s, d, lt, ⟨h, mem, hp, le, dMem, kpos⟩, lpos⟩
      match Nat.lt_or_ge u t with
      | .inl before =>
        exact Nat.lt_of_lt_of_le ((ih c).mpr ⟨u, s, d, before, ⟨h, mem, hp, le, dMem, kpos⟩, lpos⟩)
          (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (responded_succ l t c).symm))
      | .inr after =>
        have same : u = t := Nat.le_antisymm (Nat.le_of_lt_succ lt) after
        subst same
        have given : 0 < carriedGive cs part (fun _ _ _ => 0) k u h c l :=
          Nat.lt_of_lt_of_le
            (total_pos_of_mem (Propagation.mem_steps_upto le)
              (total_pos_of_mem dMem (Remainder.mul_pos_nat kpos lpos)))
            (Nat.le_of_eq (carriedGive_of_rest hp).symm)
        exact Nat.lt_of_lt_of_le (total_pos_of_mem mem given)
          (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (responded_succ l u c).symm))

/-- **Conveyed through `j` responses or more.** With none, a gap is conveyed to `c` by step `t`
(`Conveyed`); with `j + 1`, at a step before `t` the level of a condition `d`, at a step to which a
gap was conveyed through `j` responses or more, is coupled into `c`. -/
def ConveyedThrough (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) :
    Nat → Nat → C → Prop
  | 0, t, c => Conveyed cs part σ k present δ t c
  | j + 1, t, c => ∃ u s d, u < t ∧ CouplesAt cs part k present u s d c ∧
      ConveyedThrough cs part σ k present δ j s d

/-- **What `j` responses carry from the carried amount is positive exactly where a gap is conveyed
through `j` responses or more.** -/
theorem responses_pos_iff :
    ∀ j t c, 0 < responses cs part k present (carried cs part σ k present δ) j t c ↔
      ConveyedThrough cs part σ k present δ j t c
  | 0, t, c => carried_pos_iff t c
  | j + 1, t, c =>
    (responded_pos_iff _ t c).trans
      ⟨fun ⟨u, s, d, lt, at_, pos⟩ => ⟨u, s, d, lt, at_, (responses_pos_iff j s d).mp pos⟩,
       fun ⟨u, s, d, lt, at_, conv⟩ => ⟨u, s, d, lt, at_, (responses_pos_iff j s d).mpr conv⟩⟩

/-- **Where the orders below `j` miss.** They miss something at `c` at step `t` exactly where a gap
is conveyed there through `j` responses or more. -/
theorem orderBelow_lt_iff (j t : Nat) (c : C) :
    orderBelow cs part σ k present δ j t c < carried cs part σ k present δ t c ↔
      ConveyedThrough cs part σ k present δ j t c :=
  (lt_iff_pos (carried_eq_orderBelow_add j t c)).trans (responses_pos_iff j t c)

/-- **Where order `j` misses.** It misses something at `c` at step `t` exactly where a gap is
conveyed there through `j + 1` responses or more. -/
theorem carriedWithin_lt_iff (j t : Nat) (c : C) :
    carriedWithin cs part σ k present δ j t c < carried cs part σ k present δ t c ↔
      ConveyedThrough cs part σ k present δ (j + 1) t c :=
  orderBelow_lt_iff (j + 1) t c

/-- **Where order `j` is exact.** It carries everything to `c` at step `t` exactly where no gap is
conveyed there through `j + 1` responses or more. -/
theorem carriedWithin_eq_iff (j t : Nat) (c : C) :
    carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c ↔
      ¬ ConveyedThrough cs part σ k present δ (j + 1) t c :=
  ⟨fun eq conv => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le ((carriedWithin_lt_iff j t c).mpr conv)
      (Nat.le_of_eq eq.symm)),
   fun none => match Nat.lt_or_ge (carriedWithin cs part σ k present δ j t c)
      (carried cs part σ k present δ t c) with
    | .inl lt => absurd ((carriedWithin_lt_iff j t c).mp lt) none
    | .inr ge => Nat.le_antisymm (carriedWithin_le_carried j t c) ge⟩

end Where

/-! ## Chains of couplings in time order -/

section InTime

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **A chain of couplings in time order.** A chain of `j` couplings ends at `c` by step `t`, each
coupling reading a level the one before had reached: with none, at every condition and step; with
`j + 1`, at a step before `t` the level of `d`, at a step that a chain of `j` reached, is coupled
into `c`. -/
def CoupledIntoBy (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) : Nat → Nat → C → Prop
  | 0, _, _ => True
  | j + 1, t, c => ∃ u s d, u < t ∧ CouplesAt cs part k present u s d c ∧
      CoupledIntoBy cs part k present j s d

/-- What is conveyed through `j` responses travels a chain of `j` couplings in time order. -/
theorem ConveyedThrough.coupledIntoBy :
    ∀ {j t : Nat} {c : C}, ConveyedThrough cs part σ k present δ j t c →
      CoupledIntoBy cs part k present j t c
  | 0, _, _, _ => trivial
  | _ + 1, _, _, ⟨u, s, d, lt, at_, conv⟩ => ⟨u, s, d, lt, at_, ConveyedThrough.coupledIntoBy conv⟩

/-- With a starting gap at every condition, a gap is conveyed everywhere at every step. -/
theorem conveyed_ones : ∀ t c, Conveyed cs part σ k present (fun _ => 1) t c
  | 0, _ => .start (Nat.succ_pos 0)
  | t + 1, c => .hold (conveyed_ones t c)

/-- With a starting gap at every condition, every chain of couplings in time order conveys it. -/
theorem CoupledIntoBy.conveyedThrough_ones :
    ∀ {j t : Nat} {c : C}, CoupledIntoBy cs part k present j t c →
      ConveyedThrough cs part σ k present (fun _ => 1) j t c
  | 0, t, c, _ => conveyed_ones t c
  | _ + 1, _, _, ⟨u, s, d, lt, at_, chain⟩ =>
    ⟨u, s, d, lt, at_, CoupledIntoBy.conveyedThrough_ones chain⟩

/-- A chain that has reached `c` by a step has reached it by every later step. -/
theorem CoupledIntoBy.later :
    ∀ {j t t' : Nat} {c : C}, CoupledIntoBy cs part k present j t c → t ≤ t' →
      CoupledIntoBy cs part k present j t' c
  | 0, _, _, _, _, _ => trivial
  | _ + 1, _, _, _, ⟨u, s, d, lt, at_, chain⟩, le => ⟨u, s, d, Nat.lt_of_lt_of_le lt le, at_, chain⟩

/-- **The last couplings of a chain in time order are a chain in time order.** -/
theorem CoupledIntoBy.shorten :
    ∀ {i j t : Nat} {c : C}, i ≤ j → CoupledIntoBy cs part k present j t c →
      CoupledIntoBy cs part k present i t c
  | 0, _, _, _, _, _ => trivial
  | _ + 1, 0, _, _, le, _ => absurd le (Nat.not_succ_le_zero _)
  | _ + 1, _ + 1, _, _, le, ⟨u, s, d, lt, at_, chain⟩ =>
    ⟨u, s, d, lt, at_, CoupledIntoBy.shorten (Nat.le_of_succ_le_succ le) chain⟩

/-- **A chain in time order of `j` couplings needs `j` steps.** -/
theorem CoupledIntoBy.le_steps :
    ∀ {j t : Nat} {c : C}, CoupledIntoBy cs part k present j t c → j ≤ t
  | 0, _, _, _ => Nat.zero_le _
  | _ + 1, _, _, ⟨_, _, _, lt, ⟨_, _, _, le, _, _⟩, chain⟩ =>
    Nat.succ_le_of_lt (Nat.lt_of_le_of_lt (Nat.le_trans (CoupledIntoBy.le_steps chain) le) lt)

/-- **Forgetting time, a chain in time order is a chain of couplings.** -/
theorem CoupledIntoBy.coupledInto :
    ∀ {j t : Nat} {c : C}, CoupledIntoBy cs part k present j t c →
      CoupledInto cs part k present j c
  | 0, _, c, _ => coupledInto_zero c
  | _ + 1, _, _, ⟨u, s, _, _, ⟨h, mem, out, le, dMem, pos⟩, chain⟩ =>
    (CoupledIntoBy.coupledInto chain).succ ⟨u, h, s, mem, out, le, dMem, pos⟩

/-- **Exact from every start.** Order `j` carries everything to `c` at step `t` from every starting
gap exactly where no chain of `j + 1` couplings in time order ends at `c` by `t`. -/
theorem exact_every_start_iff (j t : Nat) (c : C) :
    (∀ δ : C → Nat, carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ¬ CoupledIntoBy cs part k present (j + 1) t c :=
  ⟨fun exact chain => (carriedWithin_eq_iff (δ := fun _ => 1) j t c).mp (exact _)
      chain.conveyedThrough_ones,
   fun none _ => (carriedWithin_eq_iff j t c).mpr fun conv => none conv.coupledIntoBy⟩

/-- **A finite order is exact exactly where the chains in time order are bounded.** For every
schedule of couplings and any list of conditions: some order carries everything to `c` at every
step, from every starting gap, exactly where the chains of couplings in time order into `c` are
bounded in length. -/
theorem finite_order_iff_bounded (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c :=
  ⟨fun finite => match finite (fun _ => 1) with
    | ⟨j, exact⟩ => ⟨j, fun t chain =>
        (carriedWithin_eq_iff (δ := fun _ => 1) j t c).mp (exact t) chain.conveyedThrough_ones⟩,
   fun ⟨J, bounded⟩ _ => ⟨J, fun t =>
      (carriedWithin_eq_iff J t c).mpr fun conv => bounded t conv.coupledIntoBy⟩⟩

/-- **One order serves every start.** Where some order is exact from every start, one order is
exact from all starts at once. -/
theorem finite_order_uniform_iff (c : C) :
    (∃ J, ∀ (δ : C → Nat) t,
        carriedWithin cs part σ k present δ J t c = carried cs part σ k present δ t c) ↔
      ∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c :=
  ⟨fun ⟨J, exact⟩ => ⟨J, fun t => (exact_every_start_iff J t c).mp fun δ => exact δ t⟩,
   fun ⟨J, bounded⟩ => ⟨J, fun δ t => (exact_every_start_iff J t c).mpr (bounded t) δ⟩⟩

end InTime

/-! ## Couplings that come and go -/

section ComeAndGo

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **A coupling that recurs.** The level of `d` is coupled into `c` at steps as late as one likes:
for every `N`, some coupling reads a level of `d` at a step from `N` on. -/
def CouplingRecurs (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (d c : C) : Prop :=
  ∀ N, ∃ u s, N ≤ s ∧ CouplesAt cs part k present u s d c

/-- A coupling that holds at every step recurs. -/
theorem CouplesAlways.recurs {d c : C} (always : CouplesAlways cs part k present d c) :
    CouplingRecurs cs part k present d c :=
  fun N => match always N with
    | ⟨h, mem, out, dMem, pos⟩ => ⟨N, N, Nat.le_refl N, h, mem, out, Nat.le_refl N, dMem, pos⟩

/-- A gap conveyed by a step is conveyed by every later step. -/
theorem Conveyed.later {t : Nat} {c : C} (conveyed : Conveyed cs part σ k present δ t c) :
    ∀ {t' : Nat}, t ≤ t' → Conveyed cs part σ k present δ t' c := by
  intro t' le
  induction le with
  | refl => exact conveyed
  | step _ ih => exact .hold ih

/-- What is conveyed through `j` responses by a step is conveyed so by every later step. -/
theorem ConveyedThrough.later :
    ∀ {j t t' : Nat} {c : C}, ConveyedThrough cs part σ k present δ j t c → t ≤ t' →
      ConveyedThrough cs part σ k present δ j t' c
  | 0, _, _, _, conveyed, le => Conveyed.later conveyed le
  | _ + 1, _, _, _, ⟨u, s, d, lt, at_, conv⟩, le => ⟨u, s, d, Nat.lt_of_lt_of_le lt le, at_, conv⟩

/-- **Along recurring couplings, what is conveyed goes on.** What is conveyed to the start of a chain
of recurring couplings through `j` responses is conveyed to its end, at some step, through `j + p`.
-/
theorem conveyedThrough_along {v : Nat → C} {j T : Nat}
    (start : ConveyedThrough cs part σ k present δ j T (v 0)) :
    ∀ {p : Nat}, (∀ i, i < p → CouplingRecurs cs part k present (v i) (v (i + 1))) →
      ∃ T', ConveyedThrough cs part σ k present δ (j + p) T' (v p)
  | 0, _ => ⟨T, start⟩
  | p + 1, chain =>
    match conveyedThrough_along start (fun i lt => chain i (Nat.lt_succ_of_lt lt)) with
    | ⟨T', reached⟩ =>
      match chain p (Nat.lt_succ_self p) T' with
      | ⟨u, s, late, at_⟩ => ⟨u + 1, u, s, v p, Nat.lt_succ_self u, at_, reached.later late⟩

/-- **Around a loop of recurring couplings, what is conveyed goes round without end.** Each time
around adds the loop's length to the responses it is conveyed through. -/
theorem conveyedThrough_around {v : Nat → C} {m : Nat} {e : C} (start : v 0 = e) (back : v m = e)
    (loop : ∀ i, i < m → CouplingRecurs cs part k present (v i) (v (i + 1))) {j T : Nat}
    (reached : ConveyedThrough cs part σ k present δ j T e) :
    ∀ R, ∃ T', ConveyedThrough cs part σ k present δ (j + m * R) T' e
  | 0 => ⟨T, reached⟩
  | R + 1 =>
    match conveyedThrough_around start back loop reached R with
    | ⟨T', again⟩ =>
      match conveyedThrough_along (v := v)
          (Eq.subst (motive := fun x => ConveyedThrough cs part σ k present δ (j + m * R) T' x)
            start.symm again) loop with
      | ⟨T'', once⟩ =>
        ⟨T'', Eq.subst (motive := fun x =>
            ConveyedThrough cs part σ k present δ (j + (m * R + m)) T'' x) back
          (Eq.subst (motive := fun y => ConveyedThrough cs part σ k present δ y T'' (v m))
            (Nat.add_assoc j (m * R) m) once)⟩

/-- **A fed loop whose couplings recur leaves every order inexact.** Where a gap is conveyed to a
loop of recurring couplings, and recurring couplings lead from it to `c`, every order misses
something at `c` at some step. With couplings holding at every step this is
`carriedWithin_lt_of_loop`. -/
theorem carriedWithin_lt_of_recurring_loop {s : Nat} {e c : C}
    (fed : Conveyed cs part σ k present δ s e) {v : Nat → C} {m : Nat} (pos : 0 < m)
    (start : v 0 = e) (back : v m = e)
    (loop : ∀ i, i < m → CouplingRecurs cs part k present (v i) (v (i + 1)))
    {u : Nat → C} {q : Nat} (from_ : u 0 = e) (to : u q = c)
    (path : ∀ i, i < q → CouplingRecurs cs part k present (u i) (u (i + 1))) (J : Nat) :
    ∃ t, carriedWithin cs part σ k present δ J t c < carried cs part σ k present δ t c :=
  match conveyedThrough_around start back loop (j := 0) fed (J + 1) with
  | ⟨T, around⟩ =>
    match conveyedThrough_along (v := u)
        (Eq.subst (motive := fun x => ConveyedThrough cs part σ k present δ (0 + m * (J + 1)) T x)
          from_.symm around) path with
    | ⟨T', along⟩ =>
      have many : J + 1 ≤ 0 + m * (J + 1) + q :=
        Nat.le_trans (Loops.le_mul_of_pos pos (J + 1))
          (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _).symm) (Nat.le_add_right _ q))
      ⟨T', Nat.lt_of_le_of_lt (orderBelow_mono many T' c) ((orderBelow_lt_iff _ T' c).mpr
        (Eq.subst (motive := fun x =>
          ConveyedThrough cs part σ k present δ (0 + m * (J + 1) + q) T' x) to along))⟩

/-- **A loop whose couplings recur makes the chains in time order unbounded.** Where a loop of
recurring couplings lies upstream of `c` through recurring couplings, chains of couplings in time
order of every length end at `c`, so no order is exact at `c` at every step from every start
(`finite_order_iff_bounded`). -/
theorem unbounded_of_recurring_loop {e c : C} {v : Nat → C} {m : Nat} (pos : 0 < m)
    (start : v 0 = e) (back : v m = e)
    (loop : ∀ i, i < m → CouplingRecurs cs part k present (v i) (v (i + 1)))
    {u : Nat → C} {q : Nat} (from_ : u 0 = e) (to : u q = c)
    (path : ∀ i, i < q → CouplingRecurs cs part k present (u i) (u (i + 1))) :
    ¬ ∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c :=
  fun ⟨J, bounded⟩ =>
    match carriedWithin_lt_of_recurring_loop (σ := fun _ _ _ => 0) (δ := fun _ => 1) (s := 0)
        (.start (Nat.succ_pos 0)) pos start back loop from_ to path J with
    | ⟨t, lt⟩ => bounded t ((carriedWithin_lt_iff J t c).mp lt).coupledIntoBy

/-- **Where couplings stop, a finite order is exact.** Where no coupling reads a level from step `N`
on, a chain in time order has at most `N` couplings, so order `N` is exact at every condition and
step from every start. -/
theorem exact_of_reading_before {N : Nat}
    (before : ∀ u s d c, CouplesAt cs part k present u s d c → s < N) (δ : C → Nat) (t : Nat)
    (c : C) :
    carriedWithin cs part σ k present δ N t c = carried cs part σ k present δ t c :=
  (exact_every_start_iff N t c).mpr (fun ⟨_, _, _, _, at_, chain⟩ =>
    Nat.lt_irrefl N (Nat.lt_of_le_of_lt chain.le_steps (before _ _ _ _ at_))) δ

/-- **A chain one longer than the list passes a loop**, with no listing of every condition: each
coupling reads a listed condition, so the first `cs.length + 1` conditions of a chain of
`cs.length + 1` couplings are listed, and one of them comes again. -/
theorem loop_of_coupledInto_succ {c : C} :
    CoupledInto cs part k present (cs.length + 1) c →
      ∃ e, OnLoop cs part k present e ∧ Upstream cs part k present e c
  | ⟨v, ends, chain⟩ =>
    match revisits_within cs v (fun n le => match chain n (Nat.lt_succ_of_le le) with
        | ⟨_, _, _, _, _, _, dMem, _⟩ => dMem) with
    | ⟨i, _, lt, le, same⟩ =>
      match gap_of_lt lt,
          le_dest (Nat.le_of_lt (Nat.lt_of_lt_of_le lt (Nat.le_succ_of_le le))) with
      | ⟨m, around⟩, ⟨r, rest⟩ =>
        ⟨v i,
          ⟨fun l => v (i + l), m + 1, Nat.succ_pos m, rfl,
            (congrArg v around.symm).trans same.symm,
            fun l lt' => chain (i + l)
              (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt' i)
                (Nat.le_trans (Nat.le_of_eq around.symm) (Nat.le_succ_of_le le)))⟩,
          ⟨fun l => v (i + l), r, rfl, (congrArg v rest.symm).trans ends,
            fun l lt' => chain (i + l)
              (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt' i) (Nat.le_of_eq rest.symm))⟩⟩

/-- **No loop upstream, no long chain in time order.** Where no loop lies upstream of `c`, no chain
in time order of more couplings than there are conditions ends at `c`: forgetting time, it would
pass a loop (`loop_of_coupledInto_succ`). This needs no premise on the schedule and no listing of
every condition. -/
theorem no_chain_of_no_loop {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length + 1 ≤ n) (t : Nat) : ¬ CoupledIntoBy cs part k present n t c :=
  fun chain => match loop_of_coupledInto_succ (chain.coupledInto.shorten long) with
    | ⟨e, onLoop, up⟩ => noLoop e up onLoop

/-- **With every condition listed, one coupling fewer.** Where every condition is listed and no
loop lies upstream of `c`, no chain in time order of as many couplings as there are conditions
ends at `c` (`loop_of_coupledInto`). -/
theorem no_chain_of_no_loop_listed (every : ∀ c, c ∈ cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n) (t : Nat) : ¬ CoupledIntoBy cs part k present n t c :=
  fun chain => match loop_of_coupledInto every (chain.coupledInto.shorten long) with
    | ⟨e, onLoop, up⟩ => noLoop e up onLoop

/-- **Where couplings hold at every step, bounded chains in time order are exactly no loop
upstream.** With every coupling holding at every step: the chains of couplings in time order into
`c` are bounded in length exactly where no loop lies upstream of `c`. With
`finite_order_iff_bounded` this gives `finite_order_iff_no_loop` without its listing of every
condition (`Remainder.finite_order_iff_no_loop`). -/
theorem bounded_iff_no_loop
    (always : ∀ d c, Couples cs part k present d c → CouplesAlways cs part k present d c)
    (c : C) :
    (∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c) ↔
      ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e :=
  ⟨fun bounded _ ⟨_, _, from_, to, path⟩ ⟨_, _, pos, start, back, loop⟩ =>
    unbounded_of_recurring_loop pos start back (fun i lt => (always _ _ (loop i lt)).recurs)
      from_ to (fun i lt => (always _ _ (path i lt)).recurs) bounded,
   fun noLoop => ⟨cs.length, no_chain_of_no_loop noLoop (Nat.le_refl _)⟩⟩

end ComeAndGo

/-! ## Where the schedule settles -/

section Settles

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **The strengths from step `N` on.** Every reading of a level before step `N` is dropped. -/
def strengthsFrom (N : Nat) (k : Nat → F → C → Nat → C → Nat) : Nat → F → C → Nat → C → Nat :=
  fun u h c s d => bif Nat.ble N s then k u h c s d else 0

/-- A coupling reading a level at a step from `N` on is a coupling of the strengths from step `N`
on. -/
theorem couplesAt_strengthsFrom {N u s : Nat} {d c : C} (late : N ≤ s)
    (at_ : CouplesAt cs part k present u s d c) :
    CouplesAt cs part (strengthsFrom N k) present u s d c :=
  match at_ with
  | ⟨h, mem, out, le, dMem, pos⟩ =>
    ⟨h, mem, out, le, dMem, Nat.lt_of_lt_of_le pos (Nat.le_of_eq
      (congrArg (fun b => bif b then k u h c s d else 0) (Nat.ble_eq_true_of_le late)).symm)⟩

/-- **A coupling from step `N` on** is a coupling reading a level at a step from `N` on. -/
theorem couples_strengthsFrom_iff {N : Nat} {d c : C} :
    Couples cs part (strengthsFrom N k) present d c ↔
      ∃ u s, N ≤ s ∧ CouplesAt cs part k present u s d c :=
  ⟨fun ⟨u, h, s, mem, out, le, dMem, pos⟩ =>
    match hb : Nat.ble N s with
    | false =>
      absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        (congrArg (fun b => bif b then k u h c s d else 0) hb))) (Nat.lt_irrefl 0)
    | true =>
      ⟨u, s, Nat.le_of_ble_eq_true hb, h, mem, out, le, dMem, Nat.lt_of_lt_of_le pos
        (Nat.le_of_eq (congrArg (fun b => bif b then k u h c s d else 0) hb))⟩,
   fun ⟨u, s, late, at_⟩ => couples_iff_couplesAt.mpr ⟨u, s, couplesAt_strengthsFrom late at_⟩⟩

/-- **A coupling recurs exactly where it is a coupling from every step on.** -/
theorem couplingRecurs_iff {d c : C} :
    CouplingRecurs cs part k present d c ↔ ∀ N, Couples cs part (strengthsFrom N k) present d c :=
  ⟨fun recurs N => couples_strengthsFrom_iff.mpr (recurs N),
   fun from_ N => couples_strengthsFrom_iff.mp (from_ N)⟩

/-- **The last couplings of a chain in time order read late levels.** Of a chain in time order of
`N + j` couplings, the last `j` read levels at steps from `N` on: they are a chain in time order of
the couplings from step `N` on. -/
theorem CoupledIntoBy.tail {N : Nat} :
    ∀ {j t : Nat} {c : C}, CoupledIntoBy cs part k present (N + j) t c →
      CoupledIntoBy cs part (strengthsFrom N k) present j t c
  | 0, _, _, _ => trivial
  | _ + 1, _, _, ⟨u, s, d, lt, at_, chain⟩ =>
    ⟨u, s, d, lt, couplesAt_strengthsFrom (Nat.le_trans (Nat.le_add_right N _) chain.le_steps) at_,
      CoupledIntoBy.tail chain⟩

/-- **No loop of the couplings from step `N` on upstream, no long chain in time order.** Where no
loop of the couplings from step `N` on lies upstream of `c` through them, no chain in time order of
`N + 1` couplings more than there are conditions ends at `c`, whatever the schedule. -/
theorem no_chain_of_no_loop_from {N : Nat} {c : C}
    (noLoop : ∀ e, Upstream cs part (strengthsFrom N k) present e c →
      ¬ OnLoop cs part (strengthsFrom N k) present e) (t : Nat) :
    ¬ CoupledIntoBy cs part k present (N + (cs.length + 1)) t c :=
  fun chain => no_chain_of_no_loop noLoop (Nat.le_refl _) t chain.tail

/-- **The schedule has settled by step `N`.** Every coupling from step `N` on recurs. -/
def SettledFrom (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (N : Nat) : Prop :=
  ∀ d c, Couples cs part (strengthsFrom N k) present d c → CouplingRecurs cs part k present d c

/-- Couplings holding at every step have settled from the first step. -/
theorem settledFrom_zero_of_always
    (always : ∀ d c, Couples cs part k present d c → CouplesAlways cs part k present d c) :
    SettledFrom cs part k present 0 :=
  fun d c from_ => match couples_strengthsFrom_iff.mp from_ with
    | ⟨u, s, _, at_⟩ => (always d c (couples_iff_couplesAt.mpr ⟨u, s, at_⟩)).recurs

/-- **Where the schedule has settled, bounded chains in time order are exactly no loop of the
couplings from then on.** With the schedule settled by step `N`: the chains of couplings in time
order into `c` are bounded in length exactly where no loop of the couplings from step `N` on lies
upstream of `c` through them. -/
theorem bounded_iff_no_loop_from {N : Nat}
    (settled : SettledFrom cs part k present N) (c : C) :
    (∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c) ↔
      ∀ e, Upstream cs part (strengthsFrom N k) present e c →
        ¬ OnLoop cs part (strengthsFrom N k) present e :=
  ⟨fun bounded _ ⟨_, _, from_, to, path⟩ ⟨_, _, pos, start, back, loop⟩ =>
    unbounded_of_recurring_loop pos start back (fun i lt => settled _ _ (loop i lt))
      from_ to (fun i lt => settled _ _ (path i lt)) bounded,
   fun noLoop => ⟨N + cs.length, no_chain_of_no_loop_from noLoop⟩⟩

/-- **Where the schedule has settled, a finite order is exact exactly where no loop of the
couplings from then on lies upstream.** For every schedule settled by step `N`, and any list of
conditions: some order is exact at `c` at every step from every start exactly where no loop of the
couplings from step `N` on lies upstream of `c` through them. Couplings holding at every step have
settled from the first step (`settledFrom_zero_of_always`). -/
theorem finite_order_iff_no_loop_from {N : Nat}
    (settled : SettledFrom cs part k present N) (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∀ e, Upstream cs part (strengthsFrom N k) present e c →
        ¬ OnLoop cs part (strengthsFrom N k) present e :=
  (finite_order_iff_bounded c).trans (bounded_iff_no_loop_from settled c)

/-- **Faster than every polynomial only through a loop of the couplings that go on.** With the part
giving no gap after the start, starting gaps at most `D` and the strengths into each condition
summing to at most `M` at each step: where no loop of the couplings from step `N` on lies upstream
of `c`, whatever the schedule and with no listing of every condition, the carried amount at `c`, the
most difference that can arrive (`most_difference_arrives`), is at most `D` times a polynomial in
the steps of degree `N` plus the number of conditions. -/
theorem carried_le_polynomial_from {N : Nat} {c : C}
    (noLoop : ∀ e, Upstream cs part (strengthsFrom N k) present e c →
      ¬ OnLoop cs part (strengthsFrom N k) present e)
    {M D : Nat} (start : ∀ c, δ c ≤ D) (into : ∀ t c, inflow cs part k present t c ≤ M) (t : Nat) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * Loops.orderSum M (N + cs.length) t :=
  Nat.le_trans
    (Nat.le_of_eq ((exact_every_start_iff (N + cs.length) t c).mpr
      (no_chain_of_no_loop_from noLoop t) δ).symm)
    (Nat.le_trans (carriedWithin_le_withinBound start into (N + cs.length) t c)
      (Nat.le_of_eq (Loops.withinBound_eq M D (N + cs.length) t)))

end Settles

/-! ## A loop coupled once -/

namespace Loops.Once

/-- **It reads the first step only.** Every coupling of the loop of `Loops.Once` reads the level at
the first step, so order one is exact at every step from every start (`Once.exact`, through
`exact_of_reading_before`). -/
theorem reads_first :
    ∀ u s d c, CouplesAt [()] (fun _ => false) strengths (fun _ => [()]) u s d c → s < 1 :=
  fun u s _ _ ⟨_, _, _, le, _, pos⟩ =>
    match hu : Nat.beq u 0 with
    | false =>
      absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        (congrArg (fun b => cond (b && Nat.beq s 0) 1 0) hu))) (Nat.lt_irrefl 0)
    | true => Nat.lt_succ_of_le (Nat.le_trans le (Nat.le_of_eq (Nat.eq_of_beq_eq_true hu)))

/-- **No chain of two couplings in time order**, although a loop lies upstream (`Loops.Once.onLoop`):
its chains in time order are bounded. -/
theorem no_chain_of_two (t : Nat) :
    ¬ CoupledIntoBy [()] (fun _ => false) strengths (fun _ => [()]) 2 t () :=
  fun ⟨_, _, _, _, at_, chain⟩ =>
    Nat.lt_irrefl 1 (Nat.lt_of_le_of_lt chain.le_steps (reads_first _ _ _ _ at_))

/-- **Nothing couples from the second step on**, so its loop is no loop of the couplings from then
on. -/
theorem none_from_one (d c : Unit) :
    ¬ Couples [()] (fun _ => false) (strengthsFrom 1 strengths) (fun _ => [()]) d c :=
  fun from_ => match couples_strengthsFrom_iff.mp from_ with
    | ⟨_, _, late, at_⟩ => Nat.lt_irrefl 1 (Nat.lt_of_le_of_lt late (reads_first _ _ _ _ at_))

/-- **The schedule has settled from the second step**, with nothing coupling from then on, so
`finite_order_iff_no_loop_from` applies with no loop. -/
theorem settled : SettledFrom [()] (fun _ => false) strengths (fun _ => [()]) 1 :=
  fun d c from_ => absurd from_ (none_from_one d c)

end Loops.Once

/-! ## `Becoming.Loops` as instances -/

namespace Remainder

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **`finite_order_iff_no_loop` as an instance**, of `finite_order_iff_bounded` and
`bounded_iff_no_loop`, without its listing of every condition. -/
theorem finite_order_iff_no_loop
    (always : ∀ d c, Couples cs part k present d c → CouplesAlways cs part k present d c)
    (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e :=
  (finite_order_iff_bounded c).trans (bounded_iff_no_loop always c)

end Remainder

/-! ## For every law -/

section EveryLaw

variable [DecidableEq C] {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}

/-- **Every gap is within order `j` exactly where no chain in time order is longer.** With each
condition listed once: for every law of what has stood with the coupling strengths `k`, and every
two balanced flows of it as in `most_difference_arrives`, every gap at `c` at `T`, from every start,
is at most what order `j` carries there exactly where no chain of `j + 1` couplings in time order
ends at `c` by `T`. -/
theorem gap_within_order_iff (every : ∀ c, c ∈ cs) (distinct : Distinct cs) (j T : Nat) (c : C) :
    (∀ δ : C → Nat, ∀ (law : ExchangeLaw F C) (L L' : Flow F C) (W W' : Web F C),
      law.Nonanticipating → L.Balances W → L'.Balances W' → (∀ t, L.present t = present t) →
      (∀ t, L'.present t = present t) → L.Follows law part W.level → L'.Follows law part W'.level →
      (∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d)) →
      (∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c) →
      (∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) →
      gap (W.level T c) (W'.level T c) ≤ carriedWithin cs part σ k present δ j T c) ↔
      ¬ CoupledIntoBy cs part k present (j + 1) T c :=
  Iff.trans (b := ∀ δ : C → Nat,
      carriedWithin cs part σ k present δ j T c = carried cs part σ k present δ T c)
    ⟨fun within δ => Nat.le_antisymm (carriedWithin_le_carried j T c)
        ((most_difference_arrives every distinct T c _).mp (within δ)),
     fun exact δ => (most_difference_arrives every distinct T c _).mpr
        (Nat.le_of_eq (exact δ).symm)⟩
    (exact_every_start_iff j T c)

end EveryLaw

end Becoming
