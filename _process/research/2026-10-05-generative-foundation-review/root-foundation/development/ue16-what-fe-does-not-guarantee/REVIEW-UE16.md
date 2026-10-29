# Review of UE16: what free-energy minimization does not guarantee

29 October 2026. Independent review, AI-written, of `Becoming.FreeEnergyGuarantees` ([module](tree/Becoming/FreeEnergyGuarantees.lean), [notes](DRAFT-NOTES.md), [build](scratch-6.log)) against the [search](../ue1-fep-bridge/THIRD-PART-SEARCH.md), [NOTE](../ue1-fep-bridge/NOTE.md) §2–§3 and the laws instanced. The 2015 paper's and Da Costa and others' wording was checked at the source; Albarracin and others' publisher refused access, so the search's quotations stand for it. The probe's scratch tree is not kept; its source is below.

## Verdict

The Lean is sound and pure core: rebuilt with the probe (the cached compile and audit of the identical bytes reused), the module's 51 theorems in 74 declarations and the probe's 13 in 18 have empty axiom reports and no warnings, with no `simp`, `omega`, `funext`, `decide` or classical step, and no theorem has unsatisfiable hypotheses. Each part forbids its claim under a natural reading, and grading each as a verbal generalization, not a paper's simulation, is right [AI reading, D45]: the 2015 simulation started its cells with small random expectations and noisy receptors, and its guarantee rests only on where the minimum lies. But several statements say more or less than their words: the minima laws range over every length, so for the module's own free energy only the empty configuration can be uniquely least (F1), and one docstring is false (F2); never-parting uses a hypothesis it does not need (F3); Part C keeps its stores outside the web where landed witnesses have them as conditions (F4); `OneGoal` does not show what its text infers (F5); with need one, `restraint_unread` leaves the member nothing to take (F6). It can land after F1–F7; F8–F12 are improvements.

## Findings

**F1 (O). Minima over every length** (l. 382–398). `minimum_exchanged`, `unique_minimum_alike` and `apart_not_unique` quantify `l'` over all lists. Every `freeEnergy` is a total over cells, so `F [] = 0` and `∀ l', F l' ≤ F l → l' = l` can hold only at `l = []` (probe `global_unique_empty`): for the module's own free energy, `unique_minimum_alike` says nothing of any cells, while the paper's clause is uniqueness among configurations of its cells. *Fix:* add `length_exchangeAt` and range `l'` over configurations of the same number of cells, `(unique : ∀ l', l'.length = l.length → F l' ≤ F l → l' = l)` (probe `unique_minimum_alike_within`, the same proof); likewise `least` and `apart_not_unique`.

**F2 (E). `Parting.minima`'s docstring is false** (l. 474). "The minima come in an exchanged pair": `[]`, `[3]` and `[0, 4]` have free energy nothing too (probe `parting_other_minima`), so the third conjunct holds without the pairing. *Fix:* state it among two-cell configurations with states at most `3`, where the minima are exactly `[0, 3]` and `[3, 0]` (sixteen cases), with F1's uniqueness; or reword to "both ends, either way round, have free energy nothing, the least, so neither is the unique minimum".

**F3 (O). Never-parting needs no `Exchangeable`** (l. 330–362, 452–461; header l. 21–25). Every `descent update field` is a `map`, so equal states get equal successors whatever the field reads (probe `alike_kept`). The forbidding is stronger and plainer than stated: it needs only that the rule never reads a cell's number, the modelling note's "what makes the cells identical" (l. 76–78) and the notes' refutation condition; the commuting law adds the exchanged run and the paired rests and minima. *Fix:* add `alike_kept`, derive `two_alike_stay_alike` and `all_alike_stay_alike` from it without `exchangeable`, keep `keeps_exchange_fixed` as the instance of `Law.Commutes.keeps_fixed`, and say in the header which conclusion uses which hypothesis.

**F4 (O). Part C's store is stipulated, and landed witnesses are missed** (l. 615–659). `store` is a constant reading outside the web, so `store_kept` holds at every `t` only because `Exceeding.flow.take t .first ()` is 2 also from step two, where `.first` is absent (its own model would then lower its store). The record what-a-set-point-optimum-does-beyond (`Becoming.SetPointOptimum`, core, L1) already forbids claim 3 with stores as conditions: law 25, `Optimum.TwoStores.jointly_broken`, two takers each at an optimum of the order by distance, each within the slack, together break a dependence; law 26, `Optimum.HeldPair.held_end` by `Flow.held_excess_ends`, two holders each keeping its store at a set point and within what the pool is given end the pool's renewal, neither coupling into it. There each holder's goal holds at every step while the shared renewal ends, the sharper "alike, not one" [AI reading, D45]. That module leaves the course of choices unformalized; UE16's chooser supplies it. *Fix:* import `Becoming.SetPointOptimum` (still L1), add `holder` and `heldPair_choices` (probe P4: each holder's take is one model's choice of least risk at its own store, at no risk, predicting the web's next store level), and state Part C on `HeldPair.held_end` with them, citing law 25; keep `alike_not_one` restricted to `t < 2`, with `store` called a stipulated reading.

**F5 (O). `OneGoal` overreaches** (l. 67–72, 667–738). `regulator` counts only its own take: at the first step each predicts four at no risk and the level reached is two, so the course continues by feedback through the level both read, not by one goal. With three such regulators the first joint draw is six, against a level of four and a renewal of two, and all end at step one (probe `three_end`, through `Flow.stays_below` and `Flow.ends_below`). `OneGoal` also changes what is read with what is preferred. *Fix:* add `three_end` and reword: "with two such regulators the course continues, with three it ends at the first step: a goal over the shared level, each counting only its own take, guarantees no continuing either; the forbidding needs the indexical reading, and the joint reading escapes it without that guarantee".

**F6 (O). With need one the outrun pins the course** (l. 50–53, 561–585). `start < n + 1` and `n` steps of excess force the level to `n, n − 1, …, 0` from `T`, so the rest takes exactly one more than is given and a member outside it that takes part takes nothing (probe `outside_takes_nothing`, one step; `n` steps likewise with `Flow.excess_bounded_at`). In the window, the course "in which the member takes its choice of least risk" is one where that choice is nothing; the takes can differ only before `T`, or where the member is one of the rest. *Fix:* say so in the docstring and header; the landed law's record ("however a member's act differs") could carry the same note.

**F7 (O). "The takes enter no premise" needs a member outside the rest** (l. 539–559). `need_ends` allows `g ∈ rest`, whose takes enter `outruns`. *Fix:* add `¬ g ∈ rest →` after `(reading : Nat → R)` in `need_ends` and `restraint_unread` (unused, as the chooser is), and "a member outside the rest" in the text.

**F8 (I). A witness for Part B,** at a need of two or more (F6). With `Witnesses.relay present 2 2 3` (the rest `[.second]` takes three, `.first` takes `forager.chosen 3 = 2` at no risk), a web at need three and level three at step 0, `need_ends` applies with `n = 1`: the level is nothing from step one, and `.first`, active and supported at step 0, is inactive after; restrained, the level is two and it ends too.

**F9 (I). The chooser is the landed set-point order.** `deviation` is `Becoming.gap`, `Chooser.risk` is `Optimum.gapTo` on one condition, `chosen` an optimum of `Optimum.byGap` among the predicted outcomes, and `eq_of_deviation_zero` is `gap_eq_zero_iff.mp`. *Fix:* use `gap` (in scope with F4's import) and add to "Modelling choices": for a point prediction ô, active inference's risk KL[δ_ô ‖ P] is −ln P(ô), so under any preference falling with the distance from its mode on both sides alike the choice of least risk is the one by `gap`, ties aside; ambiguity is nothing for a deterministic model, and `chosen` is the limit of infinite policy precision. That is what makes the counting form faithful.

**F10 (I). Part A's connections.** The uniqueness clause has a core form, `Relabel.EquivariantChoice.withholds_of_full_tie` (record selection-through-a-model-of-the-options): a choice treating the cells alike singles out none of identical cells; cite it, and Angluin (1980) on anonymous networks beside Curie and Turing. `Branching.law_symmetric (descent_commutes exchangeable k)` puts the descent on processes in one line; `Law.Commutes.pairs_goAlike`, whose record line reaches the grammar, needs a reading forgetting which of the two cells is which (for `Nat` states, the pair ordered).

**F11 (O). Part B's standing.** `need_ends` and `restraint_unread` are landed laws with an unused chooser: they forbid the wording "ensures", the authors' gloss survives, and only `expectation_not_course` involves the model. The paper's own example, storing food, puts a store between agent and forest, which F4's laws cover and `need_ends` does not. *Fix:* grade B "(b), weak" in the record, claim no new law for it, cite pivotality (Palfrey and Rosenthal 1984) beside the commons, and list reserves under "What the model leaves out".

**F12 (S). Names and duplicates.** `IdenticalCells.length_replicate` (l. 318) duplicates `GrammarLaws.length_replicate`, in scope. `IdenticalCells.Parting` (l. 402) repeats the landed `Becoming.Parting`, in the import closure: rename it `TwoCells`. `Chooser.rest` (l. 502) reuses the outrun's `rest` in another sense: rename it `others`. `store` is three at every step for every member, not "at every step it takes part". `alike_never_minimal` states six: add `freeEnergy energy field [0, 3] < …` or rename it.

## Probe

`python3 -B scratch_build.py <tree> Becoming.FreeEnergyGuarantees Becoming.UE16ReviewProbe`, from the package folder, the module byte-identical to the kit's: 13 theorems in 18 declarations, every axiom report empty, no warnings.

```lean
import Becoming.FreeEnergyGuarantees
import Becoming.SetPointOptimum

/-! Review probe for UE16: not for landing. -/

namespace Becoming

namespace UE16ReviewProbe

open FreeEnergyGuarantees FreeEnergyGuarantees.IdenticalCells
open FreeEnergyGuarantees.RiskAndNeeds (Chooser)

/-! ## P1. Two alike cells stay alike under every descent, its field exchangeable or not -/

theorem nth_map {α β : Type} (f : α → β) :
    ∀ (l : List α) (k : Nat), Copying.nth (l.map f) k = (Copying.nth l k).map f
  | [], _ => rfl
  | _ :: _, 0 => rfl
  | _ :: r, k + 1 => nth_map f r k

theorem alike_kept {α γ : Type} (update : α → γ → α) (field : α → List α → γ) {l : List α}
    {k : Nat} {a : α} (first : Copying.nth l k = some a) (second : Copying.nth l (k + 1) = some a) :
    ∀ n, ∃ b, Copying.nth ((Law.run (descent update field) l).state n) k = some b ∧
      Copying.nth ((Law.run (descent update field) l).state n) (k + 1) = some b
  | 0 => ⟨a, first, second⟩
  | n + 1 => match alike_kept update field first second n with
    | ⟨b, here, there⟩ =>
      ⟨update b (field b ((Law.run (descent update field) l).state n)),
       (nth_map (fun x => update x (field x ((Law.run (descent update field) l).state n)))
          ((Law.run (descent update field) l).state n) k).trans (congrArg (Option.map _) here),
       (nth_map (fun x => update x (field x ((Law.run (descent update field) l).state n)))
          ((Law.run (descent update field) l).state n) (k + 1)).trans
          (congrArg (Option.map _) there)⟩

/-! ## P2. Minima among configurations of one number of cells -/

theorem length_exchangeAt {α : Type} :
    ∀ (k : Nat) (l : List α), (exchangeAt k l).length = l.length
  | 0, [] => rfl
  | 0, [_] => rfl
  | 0, _ :: _ :: _ => rfl
  | _ + 1, [] => rfl
  | k + 1, _ :: r => congrArg Nat.succ (length_exchangeAt k r)

theorem unique_minimum_alike_within {α : Type} {F : List α → Nat} (symmetric : Symmetric F)
    {l : List α} (unique : ∀ l', l'.length = l.length → F l' ≤ F l → l' = l) (k : Nat) :
    exchangeAt k l = l :=
  unique (exchangeAt k l) (length_exchangeAt k l) (Nat.le_of_eq (symmetric k l))

/-- Over configurations of every length, a summed free energy is uniquely least only at `[]`. -/
theorem global_unique_empty {α γ : Type} {energy : α → γ → Nat} {field : α → List α → γ}
    {l : List α}
    (unique : ∀ l', freeEnergy energy field l' ≤ freeEnergy energy field l → l' = l) : l = [] :=
  (unique [] (Nat.zero_le _)).symm

theorem parting_other_minima :
    freeEnergy Parting.energy Parting.field [] = 0 ∧
      freeEnergy Parting.energy Parting.field [3] = 0 ∧
      freeEnergy Parting.energy Parting.field [0, 4] = 0 :=
  ⟨rfl, rfl, rfl⟩

/-! ## P3. `OneGoal`'s regulators, three of them, end at the first step -/

inductive Three where
  | renewer
  | a
  | b
  | c

def threeLevel : Nat → Nat := Witnesses.profile [4] 0

def threeFlow : Flow Three Unit where
  present t := match t with
    | 0 => [.renewer, .a, .b, .c]
    | _ + 1 => []
  take t f _ := match f with
    | .renewer => 0
    | .a => SharedModels.OneGoal.regulator.chosen (threeLevel t)
    | .b => SharedModels.OneGoal.regulator.chosen (threeLevel t)
    | .c => SharedModels.OneGoal.regulator.chosen (threeLevel t)
  give _ f _ := match f with
    | .renewer => 2
    | .a => 0
    | .b => 0
    | .c => 0

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

theorem three_end :
    (SharedModels.OneGoal.regulator.chosen 4 = 2 ∧ SharedModels.OneGoal.regulator.risk 4 2 = 0) ∧
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

/-! ## P4. `HeldPair`'s takes are a set-point chooser's choices at its own store -/

def holder : Chooser Nat := ⟨0, [1, 2], fun held taken => held + taken - 1, 1⟩

theorem heldPair_choices (t : Nat) :
    Optimum.HeldPair.flow.take t .first .pool =
        holder.chosen (Optimum.HeldPair.web.level t .firstStore) ∧
      Optimum.HeldPair.flow.take t .second .pool =
        holder.chosen (Optimum.HeldPair.web.level t .secondStore) ∧
      holder.risk 1 (holder.chosen 1) = 0 ∧
      holder.predict (Optimum.HeldPair.web.level t .firstStore)
          (Optimum.HeldPair.flow.take t .first .pool) =
        Optimum.HeldPair.web.level (t + 1) .firstStore :=
  ⟨rfl, rfl, rfl, rfl⟩

/-! ## P5. With need one, a member outside the rest takes nothing at an outrun step -/

theorem outside_takes_nothing {F C : Type} {L : Flow F C} {W : Web F C}
    (balances : L.Balances W) {c : C} {T : Nat} {rest : List F} {g : F}
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

end UE16ReviewProbe

end Becoming
```
