import Becoming.Commuting
import Becoming.Exclusion
import Becoming.SetPointOptimum

/-!
# What free-energy minimization does not guarantee

The free-energy principle's literature makes three claims that landed laws of the theory forbid
under a natural reading (board item UE16: candidates 1, 2 and 3 of the UE1 search for a third part).
This module states a small, explicit model of each claim in the principle's own terms and reads the
forbidding law on it: `Law.Commutes` of `Becoming.Commuting`, the outrun laws of
`Becoming.Exclusion`, the witnesses of joint excess of `Becoming.Continuation` and the held pair of
`Becoming.SetPointOptimum`, all unchanged. Each forbids a verbal generalization under its stated
hypotheses, not a paper's simulation: the simulations broke the symmetry by random starts and had
no shared draw.

* **Identical cells never part under a descent that reads no cell's number** (`IdenticalCells`;
  against Friston, Levin, Sengupta and Pezzulo 2015, where identical cells minimizing free energy
  from one location are "guaranteed" unique places). A configuration is the list of the cells'
  states, of any type (internal states, positions, expressions). The descent moves every cell by one
  rule, from its own state and the field it senses, read from its state and the configuration, never
  its number (`descent`). **Two neighbouring cells alike at the start are there, and alike, at every
  step, whatever the field reads** (`two_alike_stay_alike`), and so is every pair of neighbouring
  cells of a start with all cells alike (`all_alike_stay_alike`): the descent maps every cell by one
  function, so equal states get equal successors. Where in addition no exchange of two cells changes
  the field (`Exchangeable`), as for the field of the other cells (`othersField`,
  `othersField_exchangeable`), **the descent commutes with exchanging two neighbouring cells**
  (`descent_commutes`); then, by `Law.Commutes.keeps_fixed`, a start the exchange fixes stays fixed
  (`keeps_exchange_fixed`), and by `Law.Commutes.iterate` **the run from the exchanged start is the
  exchanged run** (`exchanged_run`): which cell ends where is the start's, and rests come in
  exchanged pairs (`rests_exchanged`). With an exchangeable field, a free energy summing each cell's
  own free energy at the field it senses is symmetric in the cells (`freeEnergy_symmetric`). For
  every free energy symmetric in the cells, among configurations of one number of cells (exchanging
  two keeps their number, `length_exchangeAt`), **minima come in exchanged pairs**
  (`minimum_exchanged`), **a unique minimum has every two neighbouring cells alike**
  (`unique_minimum_alike`, with `alike_of_fixed`), and a configuration that exchanging two
  neighbouring cells changes is not the unique minimum (`apart_not_unique`). Compared across numbers
  of cells, a summed free energy is uniquely least only at no cells (`unique_across_sizes_empty`). In
  `TwoCells` two cells hold expectations of their place from `0` (the head) to `3` (the tail), and
  each moves one unit away from the other's expectation, staying where the two are alike. Every
  configuration of two alike cells has free energy six (`TwoCells.alike_energy`), so from any two
  alike cells the free energy is six at every step, above the nothing of `[0, 3]`
  (`TwoCells.alike_never_least`); from `[1, 1]` they rest where they started
  (`TwoCells.alike_rests`). From `[1, 2]`, a small difference such as the paper's random initial
  expectations, they are at `[0, 3]` from step one on (`TwoCells.parts`), and from `[2, 1]` at
  `[3, 0]` (`TwoCells.exchanged_parts`, by `exchanged_run`). Both ends have free energy nothing, the
  least, so no two-cell configuration is the unique minimum among two-cell configurations
  (`TwoCells.minima`); other configurations reach nothing too (`TwoCells.other_minima`). The
  uniqueness clause has a core form beside it: a choice treating the cells alike singles out none of
  identical cells (`Relabel.EquivariantChoice.withholds_of_full_tie`).
* **Risk minimization does not keep a need the rest outruns** (`RiskAndNeeds`; against Albarracin
  and others 2024, where risk minimization ensures that needs are met; graded (b), weak). A chooser
  (`Chooser`) has what it may take across a step, a generative model predicting a level from what
  it reads and what it takes, and a preferred level. Its risk is the predicted distance from the
  preferred level (`Chooser.risk`, `gap`), and its choice the first action of least risk
  (`Chooser.chosen`; it minimizes risk and is among the actions, `Chooser.chosen_minimizes`,
  `Chooser.chosen_mem`). Under the premises of `Flow.outrun_below`, **whatever chooser gives the
  takes of a member outside the rest, with any actions, model, reading and preferred level, the
  level stays below the member's need from the rest's end on, and the member, so depending, is
  inactive** (`need_ends`): its takes enter no premise. With need one, **no score reading the
  condition only from then on tells the course in which the member takes its choice of least risk
  from the course in which it takes nothing** (`restraint_unread`, by `Flow.outrun_reading_alike`);
  there, at the last outrun step, from a level of at most one, a member outside the rest that takes
  part takes nothing (`outside_takes_nothing`), and the earlier outrun steps follow by the same
  count, not stated here.
  And **where a chooser reading the level expects, at no risk, a level at least the need, the level
  reached is below what it expects, from the rest's end on** (`expectation_not_course`): an
  expectation under the model,
  which is how the paper's own gloss reads the claim, is not a guarantee. In `Outrun`, at need three,
  the forager below takes its choice of least risk at no risk and ends with the condition, and so it
  does restrained (`Outrun.ends_either_way`). These apply landed laws with a chooser their premises
  do not read: they forbid the wording "ensures", not the authors' gloss.
* **Alike preferences are not one goal** (`SharedModels`; against Friston, Ramstead and others 2024
  and Da Costa and others 2025, where with one generative model and one set of preferences each
  agent's goal is the group's). In the held pair of `Becoming.SetPointOptimum` (`HeldPair`) each of
  two holders takes, at the two steps they take part, one model's choice of least risk at its own
  store, a condition of the web, at no risk, predicting its store's next level (`holder`,
  `heldPair_choices`): each store is at its set point at every step, each goal met, each holder
  takes within what a step gives the pool, together they take more, and the pool's renewal ends
  after two steps, neither holder coupling into the pool (`held_not_one`, by
  `Optimum.HeldPair.held_end` and `Flow.held_excess_ends`; `Optimum.TwoStores.jointly_broken` is a
  companion witness, a dweller's dependence broken at two takers' joint best response). So alike preferences, each over one's own, are not one goal. `Exceeding`'s two takers
  are foragers of one model (`forager`), each reading a stipulated store (`store`), using two units a
  step and preferring three, so taking two, its choice of least risk, at no risk, at the two steps
  they take part (`exceeding_choices`, `store_kept`); the same forager ends with the pair and
  continues alone (`alike_not_one`). In `OneGoal` both takers instead read the shared level and
  prefer it at four (`OneGoal.regulator`): they take two at four and nothing at two
  (`OneGoal.regulator_choice`), and all three members are active at every step
  (`OneGoal.continues`). Each regulator counts only its own take, so the course continues by what
  both read of the level, not by one goal: with three such regulators the first joint draw empties
  the condition and every member ends from step one (`OneGoal.three_end`). A goal over the shared
  level guarantees no continuing either; the forbidding needs the indexical reading, and the joint
  reading escapes it without that guarantee.

**Modelling choices.** Steps are discrete and synchronous, and levels, amounts, expectations and
free energies are natural numbers. Cells are numbered by their place in the list; the exchanges are
of neighbouring cells, and exchanges of other pairs, composites of these, are not stated. The field
reads a cell's own state and the configuration, never the cell's number: that is what makes the
cells identical, and all that never parting needs; `Exchangeable` asks in addition that exchanging
cells leaves the field unchanged, which the exchanged run and the paired minima need. The descent's
rule is any rule; `TwoCells`'s is one unit of descent of each cell's free energy given the field,
with no move at a tie. A chooser's actions are amounts taken; its generative model is any map to a
predicted level, a point prediction with no probability; risk is the distance `gap` of that
prediction from the preferred level; the choice is the least risk, ties to the earlier action. This
is faithful to active inference's risk for point predictions: for a predicted outcome `ô`, the risk
`KL[δ_ô ‖ P]` is `−ln P(ô)`, so under any preference falling with the distance from its mode on both
sides alike the choice of least risk is the one by `gap`, ties aside; ambiguity is nothing for a
deterministic model, and `chosen` is the limit of infinite policy precision. `Chooser.risk` is the
set point's order by distance (`Optimum.gapTo` on one condition). Readings are anything. The
foragers' stores are stipulated readings, not conditions of the web; the holders' stores are
conditions.

**What the model leaves out.** Probability densities and beliefs as distributions; variational free
energy and its bound on surprisal; expected free energy beyond risk in counting form (ambiguity, the
epistemic term); logarithms, precision and the softmax over policies (the choice is the argmin);
policies over more than one step; learning of the model or of the preferences; reserves an agent
keeps between itself and a renewal; Markov blankets; continuous time; and noise. Independent
fluctuations break the cells' symmetry almost surely, and the laws on identical cells then do not
apply: what is forbidden is the guarantee from a symmetric start under the deterministic descent.

**Known results.** The first forbidding is Curie's principle (1894), Turing's remark (1952) that
morphogenesis from a symmetric state needs random disturbances, and, for uniqueness, the symmetric
choices of anonymous networks (Angluin 1980); the second and third are the commons (Lloyd 1833;
Hardin 1968) and pivotality (Palfrey and Rosenthal 1984). What is the module's own is stating them
in the principle's terms, as instances of the landed laws. Every declaration has an empty axiom
report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace FreeEnergyGuarantees

/-! ## Counting -/

/-- A number not below another, by the test `Nat.blt`, is at least it. -/
theorem le_of_blt_false : ∀ {a b : Nat}, Nat.blt a b = false → b ≤ a
  | _, 0, _ => Nat.zero_le _
  | 0, 1, h => Bool.noConfusion h
  | 0, _ + 2, h => Bool.noConfusion h
  | a + 1, b + 1, h => Nat.succ_le_succ (le_of_blt_false (a := a) (b := b) h)

/-- The first of `best :: l` of least score: `best` stays until a later member scores strictly
less. -/
def firstMin {A : Type} (score : A → Nat) : A → List A → A
  | best, [] => best
  | best, a :: rest =>
    cond (Nat.blt (score a) (score best)) (firstMin score a rest) (firstMin score best rest)

/-- **The first of least score scores least**: no more than `best`, nor than any member of `l`. -/
theorem firstMin_le {A : Type} (score : A → Nat) :
    ∀ (best : A) (l : List A), score (firstMin score best l) ≤ score best ∧
      ∀ a, a ∈ l → score (firstMin score best l) ≤ score a
  | _, [] => ⟨Nat.le_refl _, fun _ mem => nomatch mem⟩
  | best, a :: rest =>
    match h : Nat.blt (score a) (score best) with
    | true =>
      have same : firstMin score best (a :: rest) = firstMin score a rest :=
        congrArg (fun b => cond b (firstMin score a rest) (firstMin score best rest)) h
      have lt : score a + 1 ≤ score best := Nat.le_of_ble_eq_true h
      match firstMin_le score a rest with
      | ⟨le, others⟩ =>
        Eq.subst (motive := fun z => score z ≤ score best ∧ ∀ b, b ∈ a :: rest → score z ≤ score b)
          same.symm
          ⟨Nat.le_trans le (Nat.le_of_lt lt), fun b mem => match mem with
            | .head _ => le
            | .tail _ inner => others b inner⟩
    | false =>
      have same : firstMin score best (a :: rest) = firstMin score best rest :=
        congrArg (fun b => cond b (firstMin score a rest) (firstMin score best rest)) h
      have ge : score best ≤ score a := le_of_blt_false h
      match firstMin_le score best rest with
      | ⟨le, others⟩ =>
        Eq.subst (motive := fun z => score z ≤ score best ∧ ∀ b, b ∈ a :: rest → score z ≤ score b)
          same.symm
          ⟨le, fun b mem => match mem with
            | .head _ => Nat.le_trans le ge
            | .tail _ inner => others b inner⟩

/-- The first of least score is `best` or a member of `l`. -/
theorem firstMin_mem {A : Type} (score : A → Nat) :
    ∀ (best : A) (l : List A), firstMin score best l = best ∨ firstMin score best l ∈ l
  | _, [] => .inl rfl
  | best, a :: rest =>
    match h : Nat.blt (score a) (score best) with
    | true =>
      have same : firstMin score best (a :: rest) = firstMin score a rest :=
        congrArg (fun b => cond b (firstMin score a rest) (firstMin score best rest)) h
      Eq.subst (motive := fun z => z = best ∨ z ∈ a :: rest) same.symm
        (match firstMin_mem score a rest with
          | .inl here => .inr (Eq.subst (motive := fun z => z ∈ a :: rest) here.symm (.head rest))
          | .inr inner => .inr (.tail a inner))
    | false =>
      have same : firstMin score best (a :: rest) = firstMin score best rest :=
        congrArg (fun b => cond b (firstMin score a rest) (firstMin score best rest)) h
      Eq.subst (motive := fun z => z = best ∨ z ∈ a :: rest) same.symm
        (match firstMin_mem score best rest with
          | .inl here => .inl here
          | .inr inner => .inr (.tail a inner))

/-! ## Identical cells -/

namespace IdenticalCells

variable {α γ : Type}

/-- Exchange cells `k` and `k + 1` of a configuration, the list of the cells' states; where there
is no cell `k + 1`, nothing changes. -/
def exchangeAt : Nat → List α → List α
  | 0, [] => []
  | 0, [a] => [a]
  | 0, a :: b :: r => b :: a :: r
  | _ + 1, [] => []
  | k + 1, a :: r => a :: exchangeAt k r

/-- Exchanging two cells does not change a total over the cells. -/
theorem total_exchangeAt (q : α → Nat) :
    ∀ (k : Nat) (l : List α), total (exchangeAt k l) q = total l q
  | 0, [] => rfl
  | 0, [_] => rfl
  | 0, a :: b :: r => Nat.add_left_comm (q b) (q a) (total r q)
  | _ + 1, [] => rfl
  | k + 1, a :: r => congrArg (q a + ·) (total_exchangeAt q k r)

/-- Mapping every cell commutes with exchanging two cells. -/
theorem map_exchangeAt {β : Type} (f : α → β) :
    ∀ (k : Nat) (l : List α), (exchangeAt k l).map f = exchangeAt k (l.map f)
  | 0, [] => rfl
  | 0, [_] => rfl
  | 0, _ :: _ :: _ => rfl
  | _ + 1, [] => rfl
  | k + 1, a :: r => congrArg (f a :: ·) (map_exchangeAt f k r)

/-- Exchanging two cells keeps the number of cells. -/
theorem length_exchangeAt : ∀ (k : Nat) (l : List α), (exchangeAt k l).length = l.length
  | 0, [] => rfl
  | 0, [_] => rfl
  | 0, _ :: _ :: _ => rfl
  | _ + 1, [] => rfl
  | k + 1, _ :: r => congrArg Nat.succ (length_exchangeAt k r)

/-- **The descent**: every cell updates by one rule from its own state and the field it senses,
which is read from the cell's own state and the configuration, never from the cell's number. -/
def descent (update : α → γ → α) (field : α → List α → γ) (l : List α) : List α :=
  l.map fun x => update x (field x l)

/-- No exchange of two cells changes the field: it reads the configuration as a population. -/
def Exchangeable (field : α → List α → γ) : Prop :=
  ∀ k x l, field x (exchangeAt k l) = field x l

/-- **The field of the other cells**: what the cells of the configuration give at a cell in state
`x`, summed, less what that cell gives itself. -/
def othersField (give : α → α → Nat) (x : α) (l : List α) : Nat :=
  total l (give x) - give x x

/-- The field of the other cells is exchangeable. -/
theorem othersField_exchangeable (give : α → α → Nat) : Exchangeable (othersField give) :=
  fun k x l => congrArg (· - give x x) (total_exchangeAt (give x) k l)

/-- **A descent with an exchangeable field commutes with exchanging two cells.** Where no exchange
changes the field, updating every cell by one rule from its own state and its field, then
exchanging cells `k` and `k + 1`, is exchanging them and then updating. -/
theorem descent_commutes {update : α → γ → α} {field : α → List α → γ}
    (exchangeable : Exchangeable field) (k : Nat) :
    Law.Commutes (descent update field) (exchangeAt k) :=
  fun l => (map_eq_of (g := fun x => update x (field x (exchangeAt k l)))
      (h := fun x => update x (field x l))
      (fun x => congrArg (update x) (exchangeable k x l)) (exchangeAt k l)).trans
    (map_exchangeAt (fun x => update x (field x l)) k l)

/-- **What the exchange fixes, a commuting law keeps fixed** (`Law.Commutes.keeps_fixed`): from a
configuration that exchanging cells `k` and `k + 1` leaves unchanged, every configuration of the run
is one it leaves unchanged. -/
theorem keeps_exchange_fixed {T : List α → List α} {k : Nat}
    (commutes : Law.Commutes T (exchangeAt k)) {l : List α} (fixed : exchangeAt k l = l) :
    ∀ n, exchangeAt k ((Law.run T l).state n) = (Law.run T l).state n :=
  commutes.keeps_fixed fixed

/-- **The run from the exchanged start is the exchanged run** (`Law.Commutes.iterate`): which cell
ends where is the start's. -/
theorem exchanged_run {T : List α → List α} {k : Nat} (commutes : Law.Commutes T (exchangeAt k))
    (l : List α) :
    ∀ n, (Law.run T (exchangeAt k l)).state n = exchangeAt k ((Law.run T l).state n) :=
  commutes.iterate l

/-- **Rests come in exchanged pairs**: where the run from `l` rests at `l`, the run from the
exchanged configuration rests at it. -/
theorem rests_exchanged {T : List α → List α} {k : Nat} (commutes : Law.Commutes T (exchangeAt k))
    {l : List α} (rest : ∀ n, (Law.run T l).state n = l) :
    ∀ n, (Law.run T (exchangeAt k l)).state n = exchangeAt k l :=
  fun n => (commutes.iterate l n).trans (congrArg (exchangeAt k) (rest n))

/-! ### Reading the cells -/

/-- Reading a cell of a mapped configuration is mapping the cell read. -/
theorem nth_map {β : Type} (f : α → β) :
    ∀ (l : List α) (k : Nat), Copying.nth (l.map f) k = (Copying.nth l k).map f
  | [], _ => rfl
  | _ :: _, 0 => rfl
  | _ :: r, k + 1 => nth_map f r k

/-- Where exchanging cells `k` and `k + 1` leaves a configuration unchanged, the two cells, where
both are read, are alike. -/
theorem alike_of_fixed : ∀ (k : Nat) (l : List α), exchangeAt k l = l →
    ∀ a b : α, Copying.nth l k = some a → Copying.nth l (k + 1) = some b → a = b
  | 0, [], _, _, _, first, _ => nomatch first
  | 0, [_], _, _, _, _, second => nomatch second
  | 0, x :: y :: _, fixed, a, b, first, second =>
    have hx : x = a := Option.some.inj first
    have hy : y = b := Option.some.inj second
    have hyx : y = x := congrArg (fun l => l.headD x) fixed
    hx.symm.trans (hyx.symm.trans hy)
  | _ + 1, [], _, _, _, first, _ => nomatch first
  | k + 1, _ :: r, fixed, a, b, first, second =>
    alike_of_fixed k r (congrArg List.tail fixed) a b first second

/-- Two neighbouring cells alike: exchanging them leaves the configuration unchanged. -/
theorem fixed_of_alike : ∀ (k : Nat) (l : List α) (a : α),
    Copying.nth l k = some a → Copying.nth l (k + 1) = some a → exchangeAt k l = l
  | 0, [], _, first, _ => nomatch first
  | 0, [_], _, _, second => nomatch second
  | 0, x :: y :: r, a, first, second =>
    have hx : x = a := Option.some.inj first
    have hy : y = a := Option.some.inj second
    Eq.subst (motive := fun z => z :: x :: r = x :: z :: r) (hx.trans hy.symm) rfl
  | _ + 1, [], _, first, _ => nomatch first
  | k + 1, x :: r, a, first, second => congrArg (x :: ·) (fixed_of_alike k r a first second)

/-- The descent keeps the number of cells along its run. -/
theorem run_length {update : α → γ → α} {field : α → List α → γ} (l : List α) :
    ∀ n, ((Law.run (descent update field) l).state n).length = l.length
  | 0 => rfl
  | n + 1 => (length_map _ _).trans (run_length l n)

/-- Every cell of a configuration of `N` alike cells reads that state. -/
theorem nth_replicate (a : α) : ∀ (N k : Nat), k < N → Copying.nth (List.replicate N a) k = some a
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | N + 1, k + 1, lt => nth_replicate a N k (Nat.lt_of_succ_lt_succ lt)

/-- **Two cells alike stay alike, whatever the field reads.** Under every descent, two
neighbouring cells alike at the start are there and alike at every step: they never part. The
descent maps every cell by one function, so equal states get equal successors; no hypothesis on the
field is needed beyond its reading no cell's number. -/
theorem two_alike_stay_alike (update : α → γ → α) (field : α → List α → γ) {l : List α}
    {k : Nat} {a : α} (first : Copying.nth l k = some a) (second : Copying.nth l (k + 1) = some a) :
    ∀ n, ∃ b, Copying.nth ((Law.run (descent update field) l).state n) k = some b ∧
      Copying.nth ((Law.run (descent update field) l).state n) (k + 1) = some b
  | 0 => ⟨a, first, second⟩
  | n + 1 => match two_alike_stay_alike update field first second n with
    | ⟨b, here, there⟩ =>
      ⟨update b (field b ((Law.run (descent update field) l).state n)),
       (nth_map (fun x => update x (field x ((Law.run (descent update field) l).state n)))
          ((Law.run (descent update field) l).state n) k).trans (congrArg (Option.map _) here),
       (nth_map (fun x => update x (field x ((Law.run (descent update field) l).state n)))
          ((Law.run (descent update field) l).state n) (k + 1)).trans
          (congrArg (Option.map _) there)⟩

/-- **All cells alike stay all alike.** Under every descent, from `N` cells all in one state,
every two neighbouring cells are there and alike at every step. -/
theorem all_alike_stay_alike (update : α → γ → α) (field : α → List α → γ) (N : Nat) (a : α)
    {k : Nat} (within : k + 1 < N) (n : Nat) :
    ∃ b, Copying.nth ((Law.run (descent update field) (List.replicate N a)).state n) k = some b ∧
      Copying.nth ((Law.run (descent update field) (List.replicate N a)).state n) (k + 1) =
        some b :=
  two_alike_stay_alike update field (nth_replicate a N k (Nat.lt_of_succ_lt within))
    (nth_replicate a N (k + 1) within) n

/-! ### Free energy symmetric in the cells -/

/-- A free energy of configurations that no exchange of two cells changes. -/
def Symmetric (F : List α → Nat) : Prop := ∀ k l, F (exchangeAt k l) = F l

/-- **The free energy of a configuration**: each cell's own free energy at the field it senses,
summed over the cells. -/
def freeEnergy (energy : α → γ → Nat) (field : α → List α → γ) (l : List α) : Nat :=
  total l fun x => energy x (field x l)

/-- With an exchangeable field, the free energy is symmetric in the cells. -/
theorem freeEnergy_symmetric {energy : α → γ → Nat} {field : α → List α → γ}
    (exchangeable : Exchangeable field) : Symmetric (freeEnergy energy field) :=
  fun k l => (total_congr (p := fun x => energy x (field x (exchangeAt k l)))
      (q := fun x => energy x (field x l))
      (fun x => congrArg (energy x) (exchangeable k x l)) (exchangeAt k l)).trans
    (total_exchangeAt (fun x => energy x (field x l)) k l)

/-- **Minima come in exchanged pairs**: among configurations of one number of cells, exchanging two
cells of a minimum gives a minimum. -/
theorem minimum_exchanged {F : List α → Nat} (symmetric : Symmetric F) {l : List α}
    (least : ∀ l', l'.length = l.length → F l ≤ F l') (k : Nat) :
    ∀ l', l'.length = (exchangeAt k l).length → F (exchangeAt k l) ≤ F l' :=
  fun l' same => Nat.le_trans (Nat.le_of_eq (symmetric k l))
    (least l' (same.trans (length_exchangeAt k l)))

/-- **A unique minimum has every two neighbouring cells alike**: where `l` is the only
configuration of its number of cells of free energy at most its own, exchanging any two
neighbouring cells leaves it unchanged, so the two, where read, are alike (`alike_of_fixed`). -/
theorem unique_minimum_alike {F : List α → Nat} (symmetric : Symmetric F) {l : List α}
    (unique : ∀ l', l'.length = l.length → F l' ≤ F l → l' = l) (k : Nat) : exchangeAt k l = l :=
  unique (exchangeAt k l) (length_exchangeAt k l) (Nat.le_of_eq (symmetric k l))

/-- So a configuration in which exchanging two neighbouring cells changes something is not the
unique minimum among configurations of its number of cells. -/
theorem apart_not_unique {F : List α → Nat} (symmetric : Symmetric F) {l : List α} {k : Nat}
    (apart : exchangeAt k l ≠ l) : ¬ ∀ l', l'.length = l.length → F l' ≤ F l → l' = l :=
  fun unique => apart (unique_minimum_alike symmetric unique k)

/-- **Compared across numbers of cells, a summed free energy is uniquely least only at no cells**:
no cells sum to nothing, so minima are compared among configurations of one number of cells. -/
theorem unique_across_sizes_empty {energy : α → γ → Nat} {field : α → List α → γ} {l : List α}
    (unique : ∀ l', freeEnergy energy field l' ≤ freeEnergy energy field l → l' = l) : l = [] :=
  (unique [] (Nat.zero_le _)).symm

/-! ### Two cells, and a start that breaks the symmetry -/

namespace TwoCells

/-- What a cell in state `y` gives to the field at any cell: its expectation. -/
def give (_ y : Nat) : Nat := y

/-- The field a cell senses: the other cells' expectations, summed; for two cells, the other's. -/
abbrev field : Nat → List Nat → Nat := othersField give

/-- One unit of descent away from the field, within `0` to `3`; where they are alike, no move. -/
def away (x z : Nat) : Nat :=
  match Nat.blt x z, Nat.blt z x with
  | true, _ => x - 1
  | false, true => cond (Nat.blt x 3) (x + 1) x
  | false, false => x

/-- The witness's descent. -/
def step : List Nat → List Nat := descent away field

/-- A cell's free energy: three, less how far its expectation lies from the field. -/
def energy (x z : Nat) : Nat := 3 - gap x z

/-- The descent commutes with exchanging any two neighbouring cells. -/
theorem step_commutes (k : Nat) : Law.Commutes step (exchangeAt k) :=
  descent_commutes (othersField_exchangeable give) k

/-- **Identical cells rest where they started**: from `[1, 1]` the run stays at `[1, 1]`. -/
theorem alike_rests : ∀ n, (Law.run step [1, 1]).state n = [1, 1]
  | 0 => rfl
  | n + 1 => (congrArg step (alike_rests n)).trans (show step [1, 1] = [1, 1] from rfl)

/-- Every configuration of two alike cells has free energy six. -/
theorem alike_energy (a : Nat) : freeEnergy energy field [a, a] = 6 :=
  have sensed : field a [a, a] = a := Naturals.add_sub_cancel_left a (a + 0)
  have own : energy a (field a [a, a]) = 3 :=
    (congrArg (energy a) sensed).trans (congrArg (fun d => 3 - (d + d)) (Nat.sub_self a))
  congrArg (fun e => e + (e + 0)) own

/-- Two cells read alike are the configuration of two alike cells. -/
theorem pair_of_alike : ∀ {l : List Nat} {b : Nat}, l.length = 2 → Copying.nth l 0 = some b →
    Copying.nth l 1 = some b → l = [b, b]
  | [], _, two, _, _ => Nat.noConfusion two
  | [_], _, two, _, _ => Nat.noConfusion two fun one => Nat.noConfusion one
  | [x, y], b, _, first, second =>
    have hx : x = b := Option.some.inj first
    have hy : y = b := Option.some.inj second
    Eq.subst (motive := fun z => [x, z] = [b, b]) hy.symm
      (Eq.subst (motive := fun z => [z, b] = [b, b]) hx.symm rfl)
  | _ :: _ :: _ :: _, _, two, _, _ =>
    Nat.noConfusion two fun two' => Nat.noConfusion two' fun one => Nat.noConfusion one

/-- **Identical cells never reach the least free energy** (by `two_alike_stay_alike`): from two
alike cells, whatever their expectation, the free energy is six at every step, while `[0, 3]` has
nothing. -/
theorem alike_never_least (a n : Nat) :
    freeEnergy energy field ((Law.run step [a, a]).state n) = 6 ∧
      freeEnergy energy field [0, 3] < 6 :=
  ⟨match two_alike_stay_alike away field (l := [a, a]) (k := 0) (a := a) rfl rfl n with
    | ⟨b, first, second⟩ =>
      Eq.subst (motive := fun l => freeEnergy energy field l = 6)
        (pair_of_alike (run_length (update := away) (field := field) [a, a] n) first second).symm
        (alike_energy b),
   show 0 < 6 from Nat.zero_lt_succ 5⟩

/-- **A start breaking the symmetry parts them**: from `[1, 2]` the cells are at `[0, 3]`, one at
each end, from step one on. -/
theorem parts : ∀ n, (Law.run step [1, 2]).state (n + 1) = [0, 3]
  | 0 => rfl
  | n + 1 => (congrArg step (parts n)).trans (show step [0, 3] = [0, 3] from rfl)

/-- **Which cell is where is the start's** (`Law.Commutes.iterate`): from `[2, 1]` the cells are at
`[3, 0]` from step one on. -/
theorem exchanged_parts (n : Nat) : (Law.run step [2, 1]).state (n + 1) = [3, 0] :=
  ((step_commutes 0).iterate [1, 2] (n + 1)).trans (congrArg (exchangeAt 0) (parts n))

/-- **Both ends have the least free energy, so neither is the unique minimum**: `[0, 3]` and
`[3, 0]` have free energy nothing, and no two-cell configuration is the only one of two cells of
free energy at most its own. -/
theorem minima : freeEnergy energy field [0, 3] = 0 ∧ freeEnergy energy field [3, 0] = 0 ∧
    ∀ l : List Nat, l.length = 2 →
      ¬ ∀ l', l'.length = l.length → freeEnergy energy field l' ≤ freeEnergy energy field l →
        l' = l :=
  have zero03 : freeEnergy energy field [0, 3] = 0 := rfl
  have zero30 : freeEnergy energy field [3, 0] = 0 := rfl
  ⟨zero03, zero30, fun l two unique =>
    have here : [0, 3] = l := unique [0, 3] two.symm
      (Eq.subst (motive := fun e => e ≤ freeEnergy energy field l) zero03.symm (Nat.zero_le _))
    have there : [3, 0] = l := unique [3, 0] two.symm
      (Eq.subst (motive := fun e => e ≤ freeEnergy energy field l) zero30.symm (Nat.zero_le _))
    Nat.noConfusion (congrArg (fun l => l.headD 0) (here.trans there.symm))⟩

/-- Other configurations of free energy nothing: no cells, one cell at `3`, and two cells at `0`
and `4`. -/
theorem other_minima :
    freeEnergy energy field [] = 0 ∧ freeEnergy energy field [3] = 0 ∧
      freeEnergy energy field [0, 4] = 0 :=
  ⟨rfl, rfl, rfl⟩

end TwoCells

end IdenticalCells

/-! ## Risk minimization and needs -/

namespace RiskAndNeeds

/-- **A minimal active-inference chooser, in counting form**: what it may take across a step, in
order; a generative model predicting the level after the step from what it reads and what it
takes; and a preferred level. -/
structure Chooser (R : Type) where
  /-- The first of what it may take, chosen on a tie. -/
  first : Nat
  /-- The others it may take, in order. -/
  others : List Nat
  /-- The generative model: the level predicted after the step, from what is read and what is
  taken. -/
  predict : R → Nat → Nat
  /-- The preferred level. -/
  preferred : Nat

namespace Chooser

variable {R : Type} (ch : Chooser R)

/-- **Risk**: the predicted distance from the preferred level (`gap`). -/
def risk (r : R) (a : Nat) : Nat := gap (ch.predict r a) ch.preferred

/-- **The choice**: the first of what it may take of least risk. -/
def chosen (r : R) : Nat := firstMin (ch.risk r) ch.first ch.others

/-- **The choice minimizes risk** over what the chooser may take. -/
theorem chosen_minimizes (r : R) : ch.risk r (ch.chosen r) ≤ ch.risk r ch.first ∧
    ∀ a, a ∈ ch.others → ch.risk r (ch.chosen r) ≤ ch.risk r a :=
  firstMin_le (ch.risk r) ch.first ch.others

/-- The choice is among what the chooser may take. -/
theorem chosen_mem (r : R) : ch.chosen r = ch.first ∨ ch.chosen r ∈ ch.others :=
  firstMin_mem (ch.risk r) ch.first ch.others

/-- **Restraint**: the chooser that may take only nothing. -/
def restraint (R : Type) : Chooser R := ⟨0, [], fun _ _ => 0, 0⟩

theorem restraint_chosen (r : R) : (restraint R).chosen r = 0 := rfl

end Chooser

/-- **The forager**: one generative model, used for several takers below. It reads its own store,
uses two units of it across each step, and predicts its store after a step as what it held, with
what it takes, less what it uses; it may take nothing, one unit or two; it prefers its store at
three. -/
def forager : Chooser Nat := ⟨0, [1, 2], fun held taken => held + taken - 2, 3⟩

/-- Holding three, the forager takes two, its choice of least risk, at no risk. -/
theorem forager_choice : forager.chosen 3 = 2 ∧ forager.risk 3 (forager.chosen 3) = 0 :=
  ⟨rfl, rfl⟩

section Outrun

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **Risk minimization does not keep a need the rest outruns.** Under the premises of
`Flow.outrun_below` (balance, only active giving, activity needing support, the renewal gated at
need `m`, and the rest, listed without repetition, taking jointly more than is given at each of `n`
steps from `T`, from a level below `n + m`): whatever chooser gives the takes of a member outside
the rest, with any actions, generative model, reading and preferred level, the level is below `m` at
every step from `T + n` on, and the member, depending on the condition at a need of at least `m`,
is inactive there. The member's takes enter no premise, so this holds for the choice of least risk
as for any other. -/
theorem need_ends (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {T n : Nat} {rest : List F} (distinct : Distinct rest)
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (start : W.level T c < n + m) :
    ∀ (g : F) (R : Type) (ch : Chooser R) (reading : Nat → R), ¬ g ∈ rest →
      (∀ t, g ∈ L.present t → L.take t g c = ch.chosen (reading t)) →
      ∀ k, W.level (T + n + k) c < m ∧
        (W.requires (T + n + k) g c → m ≤ W.need (T + n + k) g c → ¬ W.active (T + n + k) g) :=
  fun g _ _ _ _ _ k =>
    ⟨Flow.outrun_below balances acting dependent gated distinct present outruns start k,
     Flow.outrun_ends balances acting dependent gated distinct present outruns start k g⟩

/-- **No reading after the end selects restraint** (`Flow.outrun_reading_alike`, need one). Two
courses, in each of which the rest outruns the gated renewal at each of `n` steps from `T`, from a
level at most `n`: in the first a member outside the rest takes what a chooser picks, with any
model and preferred level, in the second it takes nothing (`Chooser.restraint`). Every score of
level histories that reads the condition only from `T + n` on scores the two alike: no such score
ranks the restrained course above the other. With need one the outrun leaves a member outside
the rest little to take: at the last outrun step, from a level of at most one, it takes nothing
(`outside_takes_nothing`), the earlier outrun steps following by the same count, not stated. -/
theorem restraint_unread {L' : Flow F C} {W' : Web F C}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    (balances' : L'.Balances W') (acting' : L'.Acting W') (dependent' : W'.Dependent) {c : C}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ 1 ≤ W.need t e c)
    (gated' : ∀ t e, e ∈ L'.present t → 0 < L'.give t e c → W'.requires t e c ∧ 1 ≤ W'.need t e c)
    {T n : Nat} {rest rest' : List F} (distinct : Distinct rest) (distinct' : Distinct rest')
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (present' : ∀ j f, j < n → f ∈ rest' → 0 < L'.take (T + j) f c → f ∈ L'.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (outruns' : ∀ j, j < n → L'.given (T + j) c < total rest' fun f => L'.take (T + j) f c)
    (start : W.level T c < n + 1) (start' : W'.level T c < n + 1)
    {score : (Nat → C → Nat) → Nat}
    (reads : ∀ l l', (∀ k, l (T + n + k) c = l' (T + n + k) c) → score l = score l') :
    ∀ (g : F) (R : Type) (ch : Chooser R) (reading : Nat → R), ¬ g ∈ rest → ¬ g ∈ rest' →
      (∀ t, g ∈ L.present t → L.take t g c = ch.chosen (reading t)) →
      (∀ t, g ∈ L'.present t → L'.take t g c = (Chooser.restraint R).chosen (reading t)) →
      score W.level = score W'.level :=
  fun _ _ _ _ _ _ _ _ => Flow.outrun_reading_alike balances acting dependent balances' acting'
    dependent' gated gated' distinct distinct' present present' outruns outruns' start start' reads

/-- **With need one, a member outside the rest takes nothing at the last outrun step**: where the
level is at most one and the rest takes more than is given, balance leaves nothing for any other
taker present. -/
theorem outside_takes_nothing (balances : L.Balances W) {c : C} {T : Nat} {rest : List F} {g : F}
    (distinct : Distinct rest) (outside : ¬ g ∈ rest) (here : g ∈ L.present T)
    (present : ∀ f, f ∈ rest → 0 < L.take T f c → f ∈ L.present T)
    (outruns : L.given T c < total rest fun f => L.take T f c) (start : W.level T c ≤ 1) :
    L.take T g c = 0 :=
  have within : L.take T g c + total rest (fun f => L.take T f c) ≤ L.taken T c :=
    Flow.rest_le_taken (rest := g :: rest) ⟨outside, distinct⟩ fun f mem pos => match mem with
      | .head _ => here
      | .tail _ inner => present f inner pos
  have bounded : L.taken T c ≤ W.level T c + L.given T c :=
    Nat.le_trans (Nat.le_add_left (L.taken T c) (W.level (T + 1) c))
      (Nat.le_of_eq (balances T c))
  have low : W.level T c + L.given T c ≤ total rest fun f => L.take T f c :=
    Nat.le_trans (Nat.add_le_add_right start (L.given T c))
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (L.given T c))) outruns)
  Nat.eq_zero_of_le_zero (le_of_add_le_add_right (total rest fun f => L.take T f c)
    (Nat.le_trans within (Nat.le_trans bounded (Nat.le_trans low
      (Nat.le_of_eq (Nat.zero_add _).symm)))))

/-- **The model's expectation is not the course.** Under the premises of `Flow.outrun_below`, a
chooser reading the condition's level whose choice has no risk predicts its preferred level; where
that is at least the need `m`, the level reached across the step is below what it predicted, at
every step from `T + n` on. -/
theorem expectation_not_course (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t e, e ∈ L.present t → 0 < L.give t e c → W.requires t e c ∧ m ≤ W.need t e c)
    {T n : Nat} {rest : List F} (distinct : Distinct rest)
    (present : ∀ j f, j < n → f ∈ rest → 0 < L.take (T + j) f c → f ∈ L.present (T + j))
    (outruns : ∀ j, j < n → L.given (T + j) c < total rest fun f => L.take (T + j) f c)
    (start : W.level T c < n + m) (ch : Chooser Nat) (high : m ≤ ch.preferred) (k : Nat)
    (sure : ch.risk (W.level (T + n + k) c) (ch.chosen (W.level (T + n + k) c)) = 0) :
    W.level (T + n + (k + 1)) c <
      ch.predict (W.level (T + n + k) c) (ch.chosen (W.level (T + n + k) c)) :=
  Nat.lt_of_lt_of_le
    (Flow.outrun_below balances acting dependent gated distinct present outruns start (k + 1))
    (Nat.le_trans high (Nat.le_of_eq (gap_eq_zero_iff.mp sure).symm))

end Outrun

/-! ### A witness at need three -/

namespace Outrun

open Witnesses (Member)

/-- All three take part across the first step, none after. -/
def present : Nat → List Member
  | 0 => [.renewer, .first, .second]
  | _ + 1 => []

/-- The renewer gives two, the first takes the forager's choice at a store of three, and the
second, the rest, takes three. -/
def flow : Flow Member Unit := Witnesses.relay present 2 (forager.chosen 3) 3

/-- The same, with the first restrained. -/
def restrained : Flow Member Unit := Witnesses.relay present 2 ((Chooser.restraint Nat).chosen 3) 3

/-- The condition at three, then `after`; each member depends on it at need three, the renewer
included, and is active at step zero only; the takers draw on it. -/
def web (after : Nat) : Web Member Unit where
  level t _ := Witnesses.profile [3] after t
  active t _ := Witnesses.profile [True] False t
  requires _ _ _ := True
  need _ _ _ := 3
  draws _ f _ := match f with
    | .renewer => False
    | .first => True
    | .second => True

theorem balances : flow.Balances (web 0)
  | 0, () => rfl
  | _ + 1, () => rfl

theorem restrained_balances : restrained.Balances (web 2)
  | 0, () => rfl
  | _ + 1, () => rfl

theorem acting (after : Nat) : flow.Acting (web after)
  | 0, _, _, _, _ => trivial
  | _ + 1, _, _, absent, _ => nomatch absent

theorem restrained_acting (after : Nat) : restrained.Acting (web after)
  | 0, _, _, _, _ => trivial
  | _ + 1, _, _, absent, _ => nomatch absent

theorem dependent (after : Nat) : (web after).Dependent
  | 0, _, _, _, _ => Nat.le_refl 3
  | _ + 1, _, dead, _, _ => nomatch dead

theorem gated (after : Nat) (L : Flow Member Unit) :
    ∀ t f, f ∈ L.present t → 0 < L.give t f () → (web after).requires t f () ∧
      3 ≤ (web after).need t f () :=
  fun _ _ _ _ => ⟨trivial, Nat.le_refl 3⟩

/-- The rest, the second alone, listed without repetition. -/
theorem distinct : Distinct [Member.second] := ⟨(fun mem => nomatch mem), trivial⟩

/-- The second, the rest, takes part at step zero, in either flow. -/
theorem rest_present {L : Flow Member Unit} (same : L.present 0 = present 0) :
    ∀ j f, j < 1 → f ∈ [Member.second] → 0 < L.take (0 + j) f () → f ∈ L.present (0 + j) :=
  fun j f lt mem _ => match j, lt with
    | 0, _ => match f, mem with
      | .second, _ => same ▸ .tail _ (.tail _ (.head _))
      | .renewer, mem => absurd mem fun m => match m with
        | .tail _ no => nomatch no
      | .first, mem => absurd mem fun m => match m with
        | .tail _ no => nomatch no
    | _ + 1, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 _))

/-- The first is outside the rest. -/
theorem outside : ¬ Member.first ∈ [Member.second] :=
  fun mem => match mem with
    | .tail _ no => nomatch no

/-- **The need ends either way.** The first takes two, the forager's choice of least risk, at no
risk, and is active and supported at step zero; the second alone takes more than the renewer gives;
from step one the level is below three and the first is inactive, by `need_ends`, whether it took
its choice of least risk or, restrained, nothing. -/
theorem ends_either_way :
    (forager.chosen 3 = 2 ∧ forager.risk 3 (forager.chosen 3) = 0) ∧
      (web 0).active 0 .first ∧ (web 0).Supported 0 .first ∧
      (∀ k, (web 0).level (0 + 1 + k) () < 3 ∧ ¬ (web 0).active (0 + 1 + k) .first) ∧
      ∀ k, (web 2).level (0 + 1 + k) () < 3 ∧ ¬ (web 2).active (0 + 1 + k) .first :=
  ⟨forager_choice, trivial, fun _ _ => Nat.le_refl 3,
   fun k => match need_ends balances (acting 0) (dependent 0) (gated 0 flow) (T := 0) (n := 1)
      distinct (rest_present rfl)
      (fun j lt => match j, lt with
        | 0, _ => Nat.lt_succ_self 2
        | _ + 1, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
      (Nat.lt_succ_self 3) .first Nat forager (fun _ => 3) outside (fun _ _ => rfl) k with
    | ⟨low, ends⟩ => ⟨low, ends trivial (Nat.le_refl 3)⟩,
   fun k => match need_ends restrained_balances (restrained_acting 2) (dependent 2)
      (gated 2 restrained) (T := 0) (n := 1)
      distinct (rest_present rfl)
      (fun j lt => match j, lt with
        | 0, _ => Nat.lt_succ_self 2
        | _ + 1, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
      (Nat.lt_succ_self 3) .first Nat (Chooser.restraint Nat) (fun _ => 3) outside
      (fun _ _ => rfl) k with
    | ⟨low, ends⟩ => ⟨low, ends trivial (Nat.le_refl 3)⟩⟩

end Outrun

end RiskAndNeeds

/-! ## Shared models and preferences -/

namespace SharedModels

open RiskAndNeeds (Chooser forager)

/-! ### Two holders of one model, each at its own store -/

/-- **The holder**: one generative model for both holders of `Optimum.HeldPair`. It reads its own
store, loses one unit of it across each step, and predicts its store after a step as what it held,
with what it takes, less what it loses; it may take nothing, one unit or two; it prefers its store
at one, the held pair's set point. -/
def holder : Chooser Nat := ⟨0, [1, 2], fun held taken => held + taken - 1, 1⟩

/-- **Each holder takes one model's choice of least risk at its own store**, a condition of the
web, at no risk, at the two steps the holders take part, and the model predicts the store's next
level. -/
theorem heldPair_choices (t : Nat) (_ : t < 2) :
    Optimum.HeldPair.flow.take t .first .pool =
        holder.chosen (Optimum.HeldPair.web.level t .firstStore) ∧
      Optimum.HeldPair.flow.take t .second .pool =
        holder.chosen (Optimum.HeldPair.web.level t .secondStore) ∧
      holder.risk 1 (holder.chosen 1) = 0 ∧
      holder.predict (Optimum.HeldPair.web.level t .firstStore)
          (Optimum.HeldPair.flow.take t .first .pool) =
        Optimum.HeldPair.web.level (t + 1) .firstStore ∧
      holder.predict (Optimum.HeldPair.web.level t .secondStore)
          (Optimum.HeldPair.flow.take t .second .pool) =
        Optimum.HeldPair.web.level (t + 1) .secondStore :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **Alike preferences are not one goal.** In the held pair each holder takes, at the two steps
the holders take part, the holder model's choice of least risk at its own store, at no risk, and the
model's prediction is the store's next level; each store is at its set point at every step
(`Optimum.HeldPair.held`): each goal is met. Each takes within what a step gives the pool while the
two take more, the pool's renewal ends from step two, and neither holder couples into the pool
(`Optimum.HeldPair.held_end`, by `Flow.held_excess_ends`). -/
theorem held_not_one :
    (∀ t, t < 2 → Optimum.HeldPair.flow.take t .first .pool =
        holder.chosen (Optimum.HeldPair.web.level t .firstStore) ∧
      Optimum.HeldPair.flow.take t .second .pool =
        holder.chosen (Optimum.HeldPair.web.level t .secondStore) ∧
      holder.predict (Optimum.HeldPair.web.level t .firstStore)
          (Optimum.HeldPair.flow.take t .first .pool) =
        Optimum.HeldPair.web.level (t + 1) .firstStore ∧
      holder.predict (Optimum.HeldPair.web.level t .secondStore)
          (Optimum.HeldPair.flow.take t .second .pool) =
        Optimum.HeldPair.web.level (t + 1) .secondStore) ∧
    holder.risk 1 (holder.chosen 1) = 0 ∧
    (∀ t h, Optimum.AtSetPoint (Optimum.HeldPair.store h) Optimum.HeldPair.one
      (Optimum.HeldPair.web.level t)) ∧
    (∀ t, t < 2 → Optimum.HeldPair.flow.WithinOwn t .pool ∧
      ¬ Optimum.HeldPair.flow.WithinJoint t .pool) ∧
    (∀ k g, Optimum.HeldPair.web.requires (0 + 2 + k) g .pool →
      1 ≤ Optimum.HeldPair.web.need (0 + 2 + k) g .pool →
      ¬ Optimum.HeldPair.web.active (0 + 2 + k) g) ∧
    ∀ h, Optimum.HeldPair.holders h = true →
      ¬ Optimum.HeldPair.web.CoupledInto Optimum.HeldPair.observes h .pool :=
  ⟨fun t within => match heldPair_choices t within with
    | ⟨first, second, _, firstNext, secondNext⟩ => ⟨first, second, firstNext, secondNext⟩,
   (heldPair_choices 0 (Nat.zero_lt_succ 1)).2.2.1, Optimum.HeldPair.held, Optimum.HeldPair.held_end⟩

/-! ### Two foragers of one model, each reading a stipulated store -/

/-- Each taker's store, a stipulated reading rather than a condition of the web: three at every
step, for every member. -/
def store (_ : Witnesses.Member) (_ : Nat) : Nat := 3

/-- **In `Exceeding` each taker takes its forager's choice at its own store**, at the two steps they
take part: one model for both, alike preferences, each read at the taker's own store. -/
theorem exceeding_choices : ∀ t, t < 2 →
    Exceeding.flow.take t .first () = forager.chosen (store .first t) ∧
      Exceeding.flow.take t .second () = forager.chosen (store .second t) :=
  fun _ _ => ⟨rfl, rfl⟩

/-- With what it takes, a taker's store after the step, under the forager's model, is its store
at the next step, at the two steps they take part. -/
theorem store_kept : ∀ t, t < 2 →
    forager.predict (store .first t) (Exceeding.flow.take t .first ()) = store .first (t + 1) ∧
      forager.predict (store .second t) (Exceeding.flow.take t .second ()) = store .second (t + 1) :=
  fun _ _ => ⟨rfl, rfl⟩

/-- **The same forager ends with the pair and continues alone.** The first taker of `Exceeding`
and the taker of `Alone`, with the same renewer, are the same forager: at the steps it takes part
with the pair, and at every step alone, it reads the same stipulated store and takes its choice of
least risk, at no risk. In `Exceeding`, with a second forager of the same model and an alike
preference at its own store, each takes within what a step gives while together they take more,
and from step two no member is active, the renewer included; in `Alone` the taker takes jointly
within what is given, and it and the renewer are active at every step. What tells the two courses
apart is the joint draw, which no forager's preference reads. -/
theorem alike_not_one :
    (∀ t, t < 2 → Exceeding.flow.take t .first () = forager.chosen (store .first t) ∧
      Exceeding.flow.take t .second () = forager.chosen (store .second t)) ∧
    (∀ t, Alone.flow.take t .first () = forager.chosen (store .first t)) ∧
    (forager.chosen 3 = 2 ∧ forager.risk 3 (forager.chosen 3) = 0) ∧
    (∀ t, t < 2 → Exceeding.flow.WithinOwn t () ∧ ¬ Exceeding.flow.WithinJoint t ()) ∧
    (∀ n f, ¬ Exceeding.web.active (2 + n) f) ∧
    (∀ t, Alone.flow.WithinJoint t () ∧ Alone.web.active t .renewer ∧ Alone.web.active t .first) :=
  ⟨exceeding_choices, fun _ => rfl, RiskAndNeeds.forager_choice, Exceeding.own_not_joint,
   Exceeding.all_end,
   fun t => ⟨Alone.all_continue.2.2.1 t, (Alone.all_continue.2.2.2 t).1,
     (Alone.all_continue.2.2.2 t).2⟩⟩

/-! ### One goal, read by both -/

namespace OneGoal

open Exceeding (Member)

/-- **The regulator**: one generative model for both takers, of the shared condition itself. It
reads the condition's level and predicts the level after a step as what stands, with the two units
the renewer gives, less what it takes; it may take nothing, one unit or two; it prefers the level at
four. It counts only its own take. -/
def regulator : Chooser Nat := ⟨0, [1, 2], fun level taken => level + 2 - taken, 4⟩

/-- Reading four the regulator takes two, reading two it takes nothing. -/
theorem regulator_choice : regulator.chosen 4 = 2 ∧ regulator.chosen 2 = 0 := ⟨rfl, rfl⟩

/-- The level: four, then two, by turns. -/
def level : Nat → Nat
  | 0 => 4
  | 1 => 2
  | t + 2 => level t

/-- The renewer gives two units across each step, and each taker takes the regulator's choice at
the level it reads. -/
def flow : Flow Member Unit where
  present _ := [.renewer, .first, .second]
  take t f _ := match f with
    | .renewer => 0
    | .first => regulator.chosen (level t)
    | .second => regulator.chosen (level t)
  give _ f _ := match f with
    | .renewer => 2
    | .first => 0
    | .second => 0

/-- Each member depends on the condition at need one, the renewer included, and all are active. -/
def web : Web Member Unit := Witnesses.relayWeb level fun _ _ => True

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | t + 2, () => balances t ()

theorem level_two : ∀ t, 2 ≤ level t
  | 0 => Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le 2))
  | 1 => Nat.le_refl 2
  | t + 2 => level_two t

theorem dependent : web.Dependent :=
  fun t _ _ _ _ => Nat.le_trans (Nat.le_succ 1) (level_two t)

theorem acting : flow.Acting web :=
  fun _ _ _ _ _ => trivial

/-- Only the renewer gives, and it depends on the condition at need one. -/
theorem gated : ∀ t f, f ∈ flow.present t → 0 < flow.give t f () →
    web.requires t f () ∧ 1 ≤ web.need t f () :=
  fun _ _ _ _ => ⟨trivial, Nat.le_refl 1⟩

/-- **Two regulators continue** (one witness). The flow balances on the web, only the renewer gives
and it is gated at need one, and both takers take the regulator's choice at the one level they read,
at every step. At the first step each takes within what is given while together they take more; at
the second they take jointly within it; and all three members are active and supported at every
step. The course continues by what both read of the level, each counting only its own take. -/
theorem continues :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t f, f ∈ flow.present t → 0 < flow.give t f () → web.requires t f () ∧ 1 ≤ web.need t f ()) ∧
    (∀ t, flow.take t .first () = regulator.chosen (web.level t ()) ∧
      flow.take t .second () = regulator.chosen (web.level t ())) ∧
    (flow.WithinOwn 0 () ∧ ¬ flow.WithinJoint 0 () ∧ flow.WithinJoint 1 ()) ∧
    (∀ t f, web.active t f ∧ web.Supported t f) :=
  ⟨balances, acting, dependent, gated, fun _ => ⟨rfl, rfl⟩,
   ⟨fun f _ => match f with
      | .renewer => Nat.zero_le 2
      | .first => Nat.le_refl 2
      | .second => Nat.le_refl 2,
    fun within => Nat.not_succ_le_self 2 (Nat.le_trans (Nat.le_succ 3) (show 4 ≤ 2 from within)),
    Nat.zero_le 2⟩,
   fun t f => ⟨trivial, dependent t f trivial⟩⟩

/-- A renewer and three regulators. -/
inductive Three where
  | renewer
  | a
  | b
  | c

/-- The condition: four, then nothing. -/
def threeLevel : Nat → Nat := Witnesses.profile [4] 0

/-- The renewer gives two, and each of three takers takes the regulator's choice at the level, at
the first step; none takes part after. -/
def threeFlow : Flow Three Unit where
  present t := match t with
    | 0 => [.renewer, .a, .b, .c]
    | _ + 1 => []
  take t f _ := match f with
    | .renewer => 0
    | .a => regulator.chosen (threeLevel t)
    | .b => regulator.chosen (threeLevel t)
    | .c => regulator.chosen (threeLevel t)
  give _ f _ := match f with
    | .renewer => 2
    | .a => 0
    | .b => 0
    | .c => 0

/-- Each member depends on the condition at need one and is active at step zero only. -/
def threeWeb : Web Three Unit where
  level t _ := threeLevel t
  active t _ := Witnesses.profile [True] False t
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := True

theorem threeBalances : threeFlow.Balances threeWeb
  | 0, () => rfl
  | _ + 1, () => rfl

theorem threeActing : threeFlow.Acting threeWeb
  | 0, _, _, _, _ => trivial
  | _ + 1, _, _, absent, _ => nomatch absent

theorem threeDependent : threeWeb.Dependent
  | 0, _, _, _, _ => Nat.succ_le_succ (Nat.zero_le 3)
  | _ + 1, _, dead, _, _ => nomatch dead

theorem threeGated : ∀ t f, f ∈ threeFlow.present t → 0 < threeFlow.give t f () →
    threeWeb.requires t f () ∧ 1 ≤ threeWeb.need t f () :=
  fun _ _ _ _ => ⟨trivial, Nat.le_refl 1⟩

/-- **Three regulators end at the first step.** Each reads four and takes two at no risk, each
within what is given, while the three take six against a level of four and a renewal of two; from
step one no member is active (`Flow.stays_below`, `Flow.ends_below`). A goal over the shared level,
each counting only its own take, guarantees no continuing. -/
theorem three_end :
    (regulator.chosen 4 = 2 ∧ regulator.risk 4 2 = 0) ∧
    (threeFlow.WithinOwn 0 () ∧ ¬ threeFlow.WithinJoint 0 ()) ∧
    ∀ n f, ¬ threeWeb.active (1 + n) f :=
  ⟨⟨rfl, rfl⟩,
   ⟨fun f _ => match f with
      | .renewer => Nat.zero_le 2
      | .a => Nat.le_refl 2
      | .b => Nat.le_refl 2
      | .c => Nat.le_refl 2,
    fun within => Nat.not_succ_le_self 2
      (Nat.le_trans (Nat.le_add_left 3 3) (show 6 ≤ 2 from within))⟩,
   fun n f => Flow.ends_below (W := threeWeb) (c := ()) (m := 1) (T := 1) threeDependent
     (Flow.stays_below threeBalances threeActing threeDependent threeGated (T := 1)
       Nat.zero_lt_one) n f trivial (Nat.le_refl 1)⟩

end OneGoal

end SharedModels

end FreeEnergyGuarantees

end Becoming
