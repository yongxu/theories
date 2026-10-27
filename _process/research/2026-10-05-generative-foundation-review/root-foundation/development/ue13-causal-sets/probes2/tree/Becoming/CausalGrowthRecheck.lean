import Becoming.CausalGrowth

/-!
# UE13 re-check probes

AI-written probes for the independent re-check of `Becoming.CausalGrowth` (28 October 2026), built
against a byte-identical copy of the module. Pure-core style: only `Init` and the module; no `simp`,
`omega`, `funext`, `propext` or `Classical`, and every axiom report is to be empty.

* **A.** The explicit-pair converse, and the converse of `rangeWidens_stems_of_continuing`, are each,
  for every pair of courses from the empty set, *excluded middle*, not De Morgan's law
  (`pair_converse_iff_em`, `stems_converse_iff_em`).
* **B.** Several laws stated without their courses' start fail without it (`fromOne`, `fromTwo`,
  `oneAbove`, `chainFromOne`).
* **C.** Two courses growing configurations of one kind at every offset from `2` on are mixed on what
  can be born next (`wide_right_isomorphic`, `wide_right_mixed`).
* **D.** Small checks: the chain's last element ends; on links within the one class including stems
  never adds continuation; at offset `0` the extremes' kinds of birth are each among the other's;
  `Kinds.stems_carried_iff` needs no relabelling, only an injection with a left inverse; reaching
  every pair by links on every configuration of every course from the empty set is excluded middle.
-/

namespace Becoming

open Generative

namespace CausalGrowth

namespace Recheck

/-! ## A. The explicit-pair converse is excluded middle -/

/-- `2` born above `0` exactly where `P`, every other birth with the empty past. -/
def onlyIfPast (P : Prop) (t i : Nat) : Prop := t = 2 ∧ i = 0 ∧ P

theorem onlyIf_two {P : Prop} {t i : Nat} (d : onlyIfPast P t i) : t = 2 ∧ i < 2 :=
  ⟨d.1, by rw [d.2.1]; decide⟩

def onlyIf (P : Prop) : Run process := course (onlyIfPast P) (stems_of_two onlyIf_two)

/-- A pair of `onlyIf P` gives `P`. -/
theorem onlyIf_prec {P : Prop} {t i j : Nat} (pair : ((onlyIf P).state t).prec i j) : P :=
  ((grown_prec_iff (onlyIfPast P) t).mp pair).2.2.2

/-- With `¬¬P`, the antichain exceeds `onlyIf P`'s stems: at offset `3`, `{2}` is a stem of the
antichain's configuration and not of `onlyIf P`'s. -/
theorem antichain_exceeds_onlyIf {P : Prop} (notNot : ¬¬P) : antichain.RangeExceeds Stem (onlyIf P) :=
  ⟨3, (· = 2),
   ⟨fun d => by subst d; decide, fun _ pair => absurd pair (antichain_prec 3 _ _)⟩,
   fun stem => notNot fun p =>
     absurd (stem.closed (rfl : (2 : Nat) = 2)
       ((grown_prec_iff (onlyIfPast P) 3).mpr ⟨by decide, rfl, rfl, p⟩) : (0 : Nat) = 2) (by decide)⟩

theorem notNot_em (P : Prop) : ¬¬(P ∨ ¬ P) := fun no => no (.inr fun p => no (.inl p))

/-- **The explicit-pair converse, for every pair of courses from the empty set, gives excluded
middle**: on the antichain and `onlyIf (P ∨ ¬ P)`, which it exceeds by `¬¬`, the pair found is
`P ∨ ¬ P`. -/
theorem em_of_pair_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j)
    (P : Prop) : P ∨ ¬ P :=
  match converse antichain (onlyIf (P ∨ ¬ P)) rfl rfl (antichain_exceeds_onlyIf (notNot_em P)) with
  | ⟨_, _, _, pair', _⟩ => onlyIf_prec pair'

/-- The same from the converse read on widening only. -/
theorem em_of_widening_pair_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j)
    (P : Prop) : P ∨ ¬ P :=
  match converse antichain (onlyIf (P ∨ ¬ P)) rfl rfl
      ⟨antichain_rangeIncludes rfl, antichain_exceeds_onlyIf (notNot_em P)⟩ with
  | ⟨_, _, _, pair', _⟩ => onlyIf_prec pair'

/-- Excluded middle gives the explicit-pair converse, with no `Decidable` instance. -/
theorem pair_converse_of_em (em : ∀ P : Prop, P ∨ ¬ P) :
    ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  fun r r' start start' exceeds =>
    match em (∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) with
    | .inl found => found
    | .inr absent =>
      match not_included_of_rangeExceeds start start' exceeds with
      | ⟨t, not⟩ => absurd (fun i j pair' => match em ((r.state t).prec i j) with
          | .inl pair => pair
          | .inr lacks => absurd ⟨t, i, j, pair', lacks⟩ absent) not

/-- **The explicit-pair converse for every pair of courses from the empty set is excluded middle.** -/
theorem pair_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨em_of_pair_converse, pair_converse_of_em⟩

/-- **That narrowing what can be born next always widens what continues gives excluded middle.** -/
theorem em_of_stems_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r)
    (P : Prop) : P ∨ ¬ P :=
  match (rangeWidens_continuing_iff (r := onlyIf (P ∨ ¬ P)) (r' := antichain) rfl rfl).mp
      (converse antichain (onlyIf (P ∨ ¬ P)) rfl rfl
        ⟨antichain_rangeIncludes rfl, antichain_exceeds_onlyIf (notNot_em P)⟩) with
  | ⟨_, _, _, _, pair, _⟩ => onlyIf_prec pair

theorem stems_converse_of_em (em : ∀ P : Prop, P ∨ ¬ P) :
    ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r :=
  fun r r' start start' widens =>
    (rangeWidens_continuing_iff start' start).mpr
      ⟨(rangeIncludes_iff start start').mp widens.1,
       pair_converse_of_em em r r' start start' widens.2⟩

/-- **That narrowing what can be born next always widens what continues is excluded middle.** -/
theorem stems_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨em_of_stems_converse, stems_converse_of_em⟩

/-! ## B. Starts -/

/-- One element, related to nothing. -/
def one : Causet := ⟨1, fun _ _ => False⟩

/-- Two elements, `0` before `1`. -/
def twoChain : Causet := ⟨2, fun i j => i = 0 ∧ j = 1⟩

/-- From a configuration, births with given pasts. -/
def grownFrom (c : Causet) (past : Nat → Nat → Prop) : Nat → Causet
  | 0 => c
  | t + 1 => birth (grownFrom c past t) (past t)

theorem grownFrom_size (c : Causet) (past : Nat → Nat → Prop) :
    ∀ t, (grownFrom c past t).size = c.size + t
  | 0 => rfl
  | t + 1 => congrArg Nat.succ (grownFrom_size c past t)

/-- The precedence after births from `c`: `c`'s, and `j = c.size + k` above its past `k`. -/
theorem grownFrom_prec_iff (c : Causet) (past : Nat → Nat → Prop) :
    ∀ t {i j : Nat}, (grownFrom c past t).prec i j ↔
      c.prec i j ∨ ∃ k, k < t ∧ j = c.size + k ∧ past k i
  | 0, _, _ => ⟨.inl, fun h => match h with
      | .inl p => p
      | .inr ⟨k, below, _⟩ => absurd below (Nat.not_lt_zero k)⟩
  | t + 1, i, j =>
    ⟨fun pair => match pair with
       | .inl p => match (grownFrom_prec_iff c past t).mp p with
         | .inl q => .inl q
         | .inr ⟨k, below, at_k, d⟩ => .inr ⟨k, Nat.lt_succ_of_lt below, at_k, d⟩
       | .inr ⟨top, d⟩ => .inr ⟨t, Nat.lt_succ_self t, top.trans (grownFrom_size c past t), d⟩,
     fun h => match h with
       | .inl q => .inl ((grownFrom_prec_iff c past t).mpr (.inl q))
       | .inr ⟨k, below, at_k, d⟩ =>
         match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
         | .inl lower => .inl ((grownFrom_prec_iff c past t).mpr (.inr ⟨k, lower, at_k, d⟩))
         | .inr same => .inr ⟨at_k.trans (by rw [same]; exact (grownFrom_size c past t).symm),
             by subst same; exact d⟩⟩

/-- With every past empty, the precedence stays the start's. -/
theorem grownFrom_empty_prec (c : Causet) :
    ∀ t {i j : Nat}, (grownFrom c (fun _ _ => False) t).prec i j ↔ c.prec i j
  | 0, _, _ => Iff.rfl
  | t + 1, _, _ => ⟨fun pair => match pair with
      | .inl p => (grownFrom_empty_prec c t).mp p
      | .inr ⟨_, d⟩ => (d : False).elim,
    fun p => .inl ((grownFrom_empty_prec c t).mpr p)⟩

/-- A course from `c`, every birth with the empty past. -/
def fromEmptyPasts (c : Causet) : Run process :=
  ⟨grownFrom c (fun _ _ => False), fun _ _ => False, fun _ => ⟨⟨False.elim, fun d _ => d⟩, rfl⟩⟩

/-- From one element, every birth with the empty past. -/
def fromOne : Run process := fromEmptyPasts one

theorem fromOne_prec (t : Nat) {i j : Nat} : ¬ (fromOne.state t).prec i j :=
  fun pair => (grownFrom_empty_prec one t).mp pair

theorem fromOne_size (t : Nat) : (fromOne.state t).size = 1 + t := grownFrom_size one _ t

theorem fromOne_stem_of_antichain {t : Nat} {D : Nat → Prop} (stem : Stem (antichain.state t) D) :
    Stem (fromOne.state t) D :=
  ⟨fun d => Nat.lt_of_lt_of_le
     (Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := antichain) rfl t)))
     (Nat.le_trans (Nat.le_add_left t 1) (Nat.le_of_eq (fromOne_size t).symm)),
   fun _ pair => absurd pair (fromOne_prec t)⟩

theorem fromOne_stem_zero : Stem (fromOne.state 0) (· = 0) :=
  ⟨fun d => by subst d; decide, fun _ pair => absurd pair (fromOne_prec 0)⟩

theorem not_stem_antichain_zero : ¬ Stem (antichain.state 0) (· = 0) :=
  fun stem => Nat.not_lt_zero 0 (stem.within rfl)

/-- `fromOne` widens the antichain's stems. -/
theorem fromOne_widens : fromOne.RangeWidens Stem antichain :=
  ⟨fun _ _ stem => fromOne_stem_of_antichain stem,
   ⟨0, (· = 0), fromOne_stem_zero, not_stem_antichain_zero⟩⟩

theorem antichain_not_continuing (t : Nat) (p : Nat × Nat) : ¬ continuing (antichain.state t) p :=
  fun line => match (line : «及» («续» (antichain.state t).prec «一») p.1 p.2) with
  | .one step => antichain_prec t _ _ step.1
  | .more step _ => antichain_prec t _ _ step.1

/-- **`not_rangeWidens_formsOrContinues` needs its starts**: `fromOne` widens the antichain read on
what can be born next and what continues together. -/
theorem fromOne_widens_formsOrContinues : fromOne.RangeWidens formsOrContinues antichain :=
  ⟨fun t x admitted => match x, admitted with
     | .inl _, stem => fromOne_stem_of_antichain stem
     | .inr p, line => absurd line (antichain_not_continuing t p),
   ⟨0, .inl (· = 0), fromOne_stem_zero, not_stem_antichain_zero⟩⟩

theorem not_rangeWidens_formsOrContinues_needs_starts :
    ¬ ∀ r r' : Run process, ¬ r.RangeWidens formsOrContinues r' :=
  fun noWidening => noWidening fromOne antichain fromOne_widens_formsOrContinues

/-- **`rangeIncludes_continuing_iff` needs its starts**: `fromOne` includes what continues in the
antichain, and the antichain does not include `fromOne`'s stems. -/
theorem rangeIncludes_continuing_iff_needs_starts :
    fromOne.RangeIncludes continuing antichain ∧ ¬ antichain.RangeIncludes Stem fromOne :=
  ⟨fun t p line => absurd line (antichain_not_continuing t p),
   fun included => not_stem_antichain_zero (included 0 (· = 0) fromOne_stem_zero)⟩

/-- **`not_widens_and_continues` needs its starts**: `fromOne` widens the antichain's stems and
continues at least as much within the one class. -/
theorem not_widens_and_continues_needs_starts :
    fromOne.RangeWidens Stem antichain ∧
      ∀ t, «则» («相续» (antichain.state t).prec «一») («相续» (fromOne.state t).prec «一») :=
  ⟨fromOne_widens, fun t x y line => absurd line (antichain_not_continuing t (x, y))⟩

/-- From the two-chain, every birth with the empty past. -/
def fromTwo : Run process := fromEmptyPasts twoChain

theorem fromTwo_prec_iff (t : Nat) {i j : Nat} : (fromTwo.state t).prec i j ↔ i = 0 ∧ j = 1 :=
  grownFrom_empty_prec twoChain t

/-- `1` born above `0`, every other birth with the empty past. -/
def onePast (t i : Nat) : Prop := t = 1 ∧ i = 0

theorem onePast_stems (t : Nat) : Stem (grown onePast t) (onePast t) :=
  ⟨fun ⟨at1, zero⟩ => by rw [grown_size, at1, zero]; decide,
   fun ⟨_, zero⟩ pair => absurd (zero.symm.trans ((grown_prec_iff onePast t).mp pair).2.1) (by decide)⟩

def oneAbove : Run process := course onePast onePast_stems

theorem oneAbove_prec {t i j : Nat} (pair : (oneAbove.state t).prec i j) : i = 0 ∧ j = 1 :=
  match (grown_prec_iff onePast t).mp pair with
  | ⟨_, at1, zero⟩ => ⟨zero, at1⟩

/-- **`mixed_of_pair` needs its starts**: `fromTwo` has the pair `(0, 1)` at offset `0`, which
`oneAbove` lacks there, and `oneAbove` exceeds `fromTwo` neither in what can be born next nor in what
continues. -/
theorem mixed_of_pair_needs_starts :
    (fromTwo.state 0).prec 0 1 ∧ ¬ (oneAbove.state 0).prec 0 1 ∧
      ¬ oneAbove.RangeExceeds formsOrContinues fromTwo :=
  ⟨⟨rfl, rfl⟩, fun pair => pair, fun ⟨t, x, yes, no⟩ => match x, yes, no with
    | .inl D, yes, no => no (show Stem (fromTwo.state t) D from
        ⟨fun d => Nat.lt_of_lt_of_le
           (Nat.lt_of_lt_of_le ((yes : Stem (oneAbove.state t) D).within d)
             (Nat.le_of_eq (size_of_run (r := oneAbove) rfl t)))
           (Nat.le_trans (Nat.le_add_left t 2) (Nat.le_of_eq (grownFrom_size twoChain _ t).symm)),
         fun d pair => match (fromTwo_prec_iff t).mp pair with
           | ⟨zero, at1⟩ => by
             subst zero; subst at1
             exact (yes : Stem (oneAbove.state t) D).closed d ((grown_prec_iff onePast t).mpr
               ⟨Nat.lt_of_lt_of_le ((yes : Stem (oneAbove.state t) D).within d)
                 (Nat.le_of_eq (size_of_run (r := oneAbove) rfl t)), rfl, rfl⟩)⟩)
    | .inr p, yes, no => no («及之单调» (R := «续» (oneAbove.state t).prec «一»)
        (S := «续» (fromTwo.state t).prec «一»)
        (fun _ _ step => ⟨(fromTwo_prec_iff t).mpr (oneAbove_prec step.1), step.2⟩) p.1 p.2 yes)⟩

theorem fromTwo_stem_all : Stem (fromTwo.state 0) (· < 2) :=
  ⟨fun d => d, fun _ pair => match (fromTwo_prec_iff 0).mp pair with
    | ⟨zero, _⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) (by decide)⟩

theorem not_stem_antichain_all : ¬ Stem (antichain.state 0) (· < 2) :=
  fun stem => Nat.not_lt_zero 0 (stem.within (by decide : (0 : Nat) < 2))

/-- **`antichain_unbeaten` needs its start**: an order never reversing widening what can be born next
ranks `fromTwo`, which has a precedence pair, above the antichain. -/
theorem antichain_unbeaten_needs_start :
    ∃ above : Run process → Run process → Prop,
      (∀ r r', r.RangeWidens Stem r' → ¬ above r' r) ∧ (fromTwo.state 0).prec 0 1 ∧
        above fromTwo antichain :=
  ⟨fun r r' => r = fromTwo ∧ r' = antichain,
   fun r r' widens ⟨same', same⟩ => by
     subst same'; subst same
     exact not_stem_antichain_all (widens.1 0 _ fromTwo_stem_all),
   ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- From one element, every birth above every element. -/
def chainFromOnePast (t i : Nat) : Prop := i < 1 + t

theorem chainFromOne_prec_iff (t : Nat) {i j : Nat} :
    (grownFrom one chainFromOnePast t).prec i j ↔ ∃ k, k < t ∧ j = 1 + k ∧ i < 1 + k :=
  (grownFrom_prec_iff one chainFromOnePast t).trans
    ⟨fun h => match h with
       | .inl f => f.elim
       | .inr found => found,
     .inr⟩

theorem chainFromOne_labelled {t i j : Nat} (pair : (grownFrom one chainFromOnePast t).prec i j) :
    i < j :=
  match (chainFromOne_prec_iff t).mp pair with
  | ⟨_, _, at_k, below⟩ => Eq.subst (motive := fun x => i < x) at_k.symm below

def chainFromOne : Run process :=
  ⟨grownFrom one chainFromOnePast, chainFromOnePast, fun t =>
    ⟨⟨fun d => Nat.lt_of_lt_of_le d (Nat.le_of_eq (grownFrom_size one _ t).symm),
      fun d pair => Nat.lt_trans (chainFromOne_labelled pair) d⟩, rfl⟩⟩

theorem not_continuing_chain_one : ¬ continuing (chain.state 1) (0, 1) :=
  fun line => match (line : «及» («续» (chain.state 1).prec «一») 0 1) with
  | .one step => absurd ((chain_prec_iff 1).mp step.1).1 (by decide)
  | .more step _ => match (chain_prec_iff 1).mp step.1 with
    | ⟨later, earlier⟩ => absurd (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later)) (by decide)

/-- **`rangeWidens_stems_of_continuing` needs its starts**: the chain from one element widens what
continues in the chain from the empty set, and the chain does not include its stems. -/
theorem rangeWidens_stems_of_continuing_needs_starts :
    chainFromOne.RangeWidens continuing chain ∧ ¬ chain.RangeIncludes Stem chainFromOne :=
  ⟨⟨fun t _ line => «及之单调» (R := «续» (chain.state t).prec «一»)
       (S := «续» (chainFromOne.state t).prec «一») (fun x y step => ⟨(chainFromOne_prec_iff t).mpr
       (match y, (chain_prec_iff t).mp step.1 with
        | 0, ⟨_, earlier⟩ => absurd earlier (Nat.not_lt_zero x)
        | k + 1, ⟨later, earlier⟩ =>
          ⟨k, Nat.lt_of_succ_lt later, Nat.add_comm k 1, Nat.lt_of_lt_of_le earlier
            (Nat.le_of_eq (Nat.add_comm k 1))⟩), trivial⟩) _ _ line,
    ⟨1, (0, 1), «及».one ⟨(chainFromOne_prec_iff 1).mpr ⟨0, by decide, rfl, by decide⟩, trivial⟩,
     not_continuing_chain_one⟩⟩,
   fun included => Nat.not_lt_zero 0 ((included 0 (· = 0)
     ⟨fun d => by subst d; decide, fun _ pair =>
       absurd pair (fun p => match (chainFromOne_prec_iff 0).mp p with
         | ⟨_, below, _, _⟩ => Nat.not_lt_zero _ below)⟩).within rfl)⟩

/-- **`prec_iff_of_both` needs its starts**: the chain from one element includes the chain's stems
and continues at least as much within the one class, and at offset `1` it has a pair the chain lacks. -/
theorem prec_iff_of_both_needs_starts :
    chainFromOne.RangeIncludes Stem chain ∧
      (∀ t, «则» («相续» (chain.state t).prec «一») («相续» (chainFromOne.state t).prec «一»)) ∧
      (chainFromOne.state 1).prec 0 1 ∧ ¬ (chain.state 1).prec 0 1 :=
  ⟨fun t D stem =>
     ⟨fun d => Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := chain) rfl t)))
        (Nat.le_trans (Nat.le_add_left t 1) (Nat.le_of_eq (grownFrom_size one _ t).symm)),
      fun d pair => stem.closed d ((chain_prec_iff t).mpr
        ⟨Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := chain) rfl t)),
         chainFromOne_labelled pair⟩)⟩,
   fun t => «及之单调» (R := «续» (chain.state t).prec «一»)
       (S := «续» (chainFromOne.state t).prec «一») (fun x y step => ⟨(chainFromOne_prec_iff t).mpr
       (match y, (chain_prec_iff t).mp step.1 with
        | 0, ⟨_, earlier⟩ => absurd earlier (Nat.not_lt_zero x)
        | k + 1, ⟨later, earlier⟩ =>
          ⟨k, Nat.lt_of_succ_lt later, Nat.add_comm k 1, Nat.lt_of_lt_of_le earlier
            (Nat.le_of_eq (Nat.add_comm k 1))⟩), trivial⟩),
   (chainFromOne_prec_iff 1).mpr ⟨0, by decide, rfl, by decide⟩,
   fun pair => absurd ((chain_prec_iff 1).mp pair).1 (by decide)⟩

/-- **`rangeIncludes_strict_iff`, `rangeWidens_strict`, `not_included_of_rangeExceeds` and
`rangeExceeds_iff_pair` need their starts**: `fromOne` includes the antichain's stems strictly and
exceeds them, while each course's precedence, empty, is included in the other's. -/
theorem strict_needs_starts :
    (fromOne.RangeIncludes Stem antichain ∧ ¬ antichain.RangeIncludes Stem fromOne) ∧
      fromOne.RangeExceeds Stem antichain ∧
      (∀ t i j, (antichain.state t).prec i j → (fromOne.state t).prec i j) ∧
      (∀ t i j, (fromOne.state t).prec i j → (antichain.state t).prec i j) :=
  ⟨⟨fromOne_widens.1, rangeIncludes_continuing_iff_needs_starts.2⟩,
   fromOne_widens.2,
   fun t i j pair => absurd pair (antichain_prec t i j),
   fun t _ _ pair => absurd pair (fromOne_prec t)⟩

/-- **`rangeExceeds_of_pair` and `rangeWidens_of` need their starts**: `oneAbove`'s precedence is
included in `fromTwo`'s at every offset, `fromTwo` has a pair `oneAbove` lacks, and `oneAbove` does
not exceed `fromTwo`'s stems. -/
theorem rangeWidens_of_needs_starts :
    (∀ t i j, (oneAbove.state t).prec i j → (fromTwo.state t).prec i j) ∧
      (fromTwo.state 0).prec 0 1 ∧ ¬ (oneAbove.state 0).prec 0 1 ∧
      ¬ oneAbove.RangeExceeds Stem fromTwo :=
  ⟨fun t _ _ pair => (fromTwo_prec_iff t).mpr (oneAbove_prec pair),
   ⟨rfl, rfl⟩, fun pair => pair,
   fun ⟨t, D, yes, no⟩ => mixed_of_pair_needs_starts.2.2 ⟨t, .inl D, yes, no⟩⟩

/-- **`continuation_of_rangeIncludes` needs its starts**: the chain from one element includes the
chain's stems and, at offset `1`, continues from `0` to `1` within the one class where the chain does
not. -/
theorem continuation_of_rangeIncludes_needs_starts :
    chainFromOne.RangeIncludes Stem chain ∧ «相续» (chainFromOne.state 1).prec «一» 0 1 ∧
      ¬ «相续» (chain.state 1).prec «一» 0 1 :=
  ⟨prec_iff_of_both_needs_starts.1,
   «及».one ⟨prec_iff_of_both_needs_starts.2.2.1, trivial⟩,
   not_continuing_chain_one⟩

/-- No elements, and a precedence relating every pair. -/
def full : Causet := ⟨0, fun _ _ => True⟩

theorem full_stem_empty {t : Nat} {D : Nat → Prop} (stem : Stem ((fromEmptyPasts full).state t) D)
    {i : Nat} (held : D i) : False :=
  Nat.lt_irrefl _ (stem.within (stem.closed (i := ((fromEmptyPasts full).state t).size) held
    ((grownFrom_empty_prec full t).mpr trivial)))

/-- **`keepsWidening` needs its start** (the note's law 2): from `full`, every past empty, no stem
holds an element, and nothing keeps widening. -/
theorem keepsWidening_needs_start :
    ¬ Reaching.KeepsWidening (fun t => Stem ((fromEmptyPasts full).state t)) :=
  fun keeps => match keeps.2 0 with
  | ⟨_, _, stem, notNow⟩ =>
    notNow ⟨fun held => (full_stem_empty stem held).elim,
      fun held _ => (full_stem_empty stem held).elim⟩

/-! ## C. The order on courses is labelled -/

/-- `2` born above `1`, every other birth with the empty past (`Finer.wide` bears it above `0`). -/
def rightPast (t i : Nat) : Prop := t = 2 ∧ i = 1

theorem right_two {t i : Nat} (d : rightPast t i) : t = 2 ∧ i < 2 := ⟨d.1, by rw [d.2]; decide⟩

def right : Run process := course rightPast (stems_of_two right_two)

theorem swap_fixed {i : Nat} (h0 : ¬ i = 0) (h1 : ¬ i = 1) : Kinds.swap i = i := by
  unfold Kinds.swap; rw [if_neg h0, if_neg h1]

theorem swap_eq_two_iff (j : Nat) : Kinds.swap j = 2 ↔ j = 2 :=
  if h0 : j = 0 then by subst h0; decide
  else if h1 : j = 1 then by subst h1; decide
  else ⟨fun e => (swap_fixed h0 h1).symm.trans e, fun e => (swap_fixed h0 h1).trans e⟩

theorem swap_eq_one_iff (i : Nat) : Kinds.swap i = 1 ↔ i = 0 :=
  if h0 : i = 0 then by subst h0; decide
  else if h1 : i = 1 then by subst h1; decide
  else ⟨fun e => absurd ((swap_fixed h0 h1).symm.trans e) h1, fun e => absurd e h0⟩

theorem swap_below {n : Nat} (two : 2 ≤ n) {i : Nat} (below : i < n) : Kinds.swap i < n :=
  if h0 : i = 0 then by subst h0; exact Nat.lt_of_lt_of_le (by decide : Kinds.swap 0 < 2) two
  else if h1 : i = 1 then by subst h1; exact Nat.lt_of_lt_of_le (by decide : Kinds.swap 1 < 2) two
  else Eq.subst (motive := fun x => x < n) (swap_fixed h0 h1).symm below

theorem wide_right_prec (t : Nat) {i j : Nat} :
    (Finer.wide.state t).prec i j ↔ (right.state t).prec (Kinds.swap i) (Kinds.swap j) :=
  (grown_prec_iff Finer.widePast t).trans (Iff.trans
    (show (j < t ∧ (j = 2 ∧ i = 0)) ↔ (Kinds.swap j < t ∧ (Kinds.swap j = 2 ∧ Kinds.swap i = 1)) from
      ⟨fun ⟨below, two, zero⟩ =>
         ⟨Eq.subst (motive := fun x => x < t)
            (((swap_eq_two_iff j).mpr two).trans two.symm).symm below,
          (swap_eq_two_iff j).mpr two, (swap_eq_one_iff i).mpr zero⟩,
       fun ⟨below, two, isOne⟩ =>
         ⟨Eq.subst (motive := fun x => x < t) (two.trans ((swap_eq_two_iff j).mp two).symm) below,
          (swap_eq_two_iff j).mp two, (swap_eq_one_iff i).mp isOne⟩⟩)
    (grown_prec_iff rightPast t).symm)

/-- **From offset `2` on, `Finer.wide` and `right` grow configurations of one kind**, by exchanging
`0` and `1`. -/
theorem wide_right_isomorphic (k : Nat) :
    Kinds.Isomorphic (Finer.wide.state (k + 2)) (right.state (k + 2)) :=
  ⟨Kinds.swap, Kinds.swap,
   fun i below => ⟨Nat.lt_of_lt_of_le
       (swap_below (Nat.le_add_left 2 k)
         (Nat.lt_of_lt_of_le below (Nat.le_of_eq (size_of_run (r := Finer.wide) rfl (k + 2)))))
       (Nat.le_of_eq (size_of_run (r := right) rfl (k + 2)).symm),
     Kinds.swap_swap i⟩,
   fun j below => ⟨Nat.lt_of_lt_of_le
       (swap_below (Nat.le_add_left 2 k)
         (Nat.lt_of_lt_of_le below (Nat.le_of_eq (size_of_run (r := right) rfl (k + 2)))))
       (Nat.le_of_eq (size_of_run (r := Finer.wide) rfl (k + 2)).symm),
     Kinds.swap_swap j⟩,
   fun _ _ _ _ => wide_right_prec (k + 2)⟩

/-- **Each exceeds the other's stems**: the order on courses, labelled, leaves them mixed. -/
theorem wide_right_mixed : Finer.wide.RangeExceeds Stem right ∧ right.RangeExceeds Stem Finer.wide :=
  ⟨rangeExceeds_of_pair (r := Finer.wide) (r' := right) rfl rfl (t := 3) (i := 1) (j := 2)
     ((grown_prec_iff rightPast 3).mpr ⟨by decide, rfl, rfl⟩)
     (fun pair => absurd ((grown_prec_iff Finer.widePast 3).mp pair).2.2 (by decide)),
   rangeExceeds_of_pair (r := right) (r' := Finer.wide) rfl rfl (t := 3) (i := 0) (j := 2)
     ((grown_prec_iff Finer.widePast 3).mpr ⟨by decide, rfl, rfl⟩)
     (fun pair => absurd ((grown_prec_iff rightPast 3).mp pair).2.2 (by decide))⟩

/-! ## D. Small checks -/

/-- **At every offset the chain's last element ends**, on precedence and on links. -/
theorem chain_last_ends (t : Nat) :
    «亡» (chain.state (t + 1)).prec «一» t ∧ «亡» (links (chain.state (t + 1)).prec) «一» t :=
  ⟨fun ⟨_, step, _⟩ => match (chain_prec_iff (t + 1)).mp step with
     | ⟨later, earlier⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later)),
   fun ⟨_, link, _⟩ => match (chain_prec_iff (t + 1)).mp link.1 with
     | ⟨later, earlier⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later))⟩

/-- **On links within the one class, including stems never adds continuation**, with precedence
decidable: the note's sentence after law 7, from `continuation_links_one_iff` and
`rangeIncludes_iff`. -/
theorem continuation_links_one_of_rangeIncludes {r r' : Run process}
    (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    [∀ t i j, Decidable ((r.state t).prec i j)] [∀ t i j, Decidable ((r'.state t).prec i j)]
    (included : r.RangeIncludes Stem r') (t : Nat) :
    «则» («相续» (links (r.state t).prec) «一») («相续» (links (r'.state t).prec) «一») :=
  fun _ _ line => (continuation_links_one_iff (ordered_of_empty start' t)).mpr
    ((rangeIncludes_iff start start').mp included t _ _
      ((continuation_links_one_iff (ordered_of_empty start t)).mp line))

/-- **Read on what continues, the chain widens every course from the empty set lacking one of its
pairs** (the note's §1, by `rangeWidens_continuing_iff` and `rangeIncludes_chain`). -/
theorem chain_rangeWidens_continuing {r : Run process} (start : r.state 0 = empty) {t i j : Nat}
    (later : j < t) (earlier : i < j) (lacks : ¬ (r.state t).prec i j) :
    chain.RangeWidens continuing r :=
  (rangeWidens_continuing_iff (r := chain) (r' := r) rfl start).mpr
    ⟨(rangeIncludes_iff start rfl).mp (rangeIncludes_chain start),
     t, i, j, (chain_prec_iff t).mpr ⟨later, earlier⟩, lacks⟩

/-- **An order never reversing widening what can be born next ranks the chain above no course from
the empty set lacking one of its pairs** (the note's law 5, by `rangeWidens_chain`). -/
theorem chain_not_above (above : Run process → Run process → Prop)
    (never : ∀ r r', r.RangeWidens Stem r' → ¬ above r' r) {r : Run process}
    (start : r.state 0 = empty) {t i j : Nat} (later : j < t) (earlier : i < j)
    (lacks : ¬ (r.state t).prec i j) : ¬ above chain r :=
  never r chain (rangeWidens_chain start later earlier lacks)

/-- **At offset `0` each extreme's kinds of birth are among the other's**: the laws
`Kinds.not_included_*` are about offset `2`. -/
theorem included_at_zero :
    Kinds.Included (antichain.state 0) (chain.state 0) ∧
      Kinds.Included (chain.state 0) (antichain.state 0) :=
  ⟨fun D stem => ⟨D, stem, id, id, fun _ below => ⟨below, rfl⟩, fun _ below => ⟨below, rfl⟩,
     fun _ _ _ _ => Iff.rfl⟩,
   fun D stem => ⟨D, stem, id, id, fun _ below => ⟨below, rfl⟩, fun _ below => ⟨below, rfl⟩,
     fun _ _ _ _ => Iff.rfl⟩⟩

/-- **`Kinds.stems_carried_iff` needs no relabelling**: it applies to a configuration of one element
carried into one of two by `j ↦ j + 1`, with `j ↦ j - 1` a left inverse on the first's elements. -/
theorem stems_carried_unequal :
    ∀ D, Stem (antichain.state 2) D →
      Stem (antichain.state 1) (fun j => j < (antichain.state 1).size ∧ D (j + 1)) :=
  (Kinds.stems_carried_iff (c := antichain.state 1) (c' := antichain.state 2)
    (ordered_of_empty (r := antichain) rfl 1) (ordered_of_empty (r := antichain) rfl 2)
    (σ := fun j => j - 1) (τ := fun j => j + 1)
    (fun _ below => ⟨Nat.succ_lt_succ below, rfl⟩)).mpr
    (fun i j pair => absurd pair (antichain_prec 1 i j))

/-- `0` before `2`; `0` before `1` before `2` exactly where `P`: `Undecided.third P` grown. -/
def thirdPast (P : Prop) (t i : Nat) : Prop := (t = 1 ∧ i = 0 ∧ P) ∨ (t = 2 ∧ (i = 0 ∨ (i = 1 ∧ P)))

theorem thirdPast_stems (P : Prop) (t : Nat) : Stem (grown (thirdPast P) t) (thirdPast P t) :=
  ⟨fun d => match d with
     | .inl ⟨at1, zero, _⟩ => by rw [grown_size, at1, zero]; decide
     | .inr ⟨at2, .inl zero⟩ => by rw [grown_size, at2, zero]; decide
     | .inr ⟨at2, .inr ⟨isOne, _⟩⟩ => by rw [grown_size, at2, isOne]; decide,
   fun d pair => match d, (grown_prec_iff (thirdPast P) t).mp pair with
     | .inl ⟨_, zero, _⟩, ⟨_, .inl ⟨isOne, _, _⟩⟩ => absurd (zero.symm.trans isOne) (by decide)
     | .inl ⟨_, zero, _⟩, ⟨_, .inr ⟨two, _⟩⟩ => absurd (zero.symm.trans two) (by decide)
     | .inr ⟨at2, _⟩, ⟨_, .inl ⟨_, zero, _⟩⟩ => .inr ⟨at2, .inl zero⟩
     | .inr ⟨at2, _⟩, ⟨later, .inr ⟨two, _⟩⟩ =>
       absurd (Eq.subst (motive := fun x => x < 2) two (Nat.lt_of_lt_of_le later (Nat.le_of_eq at2)))
         (Nat.lt_irrefl 2)⟩

def thirdCourse (P : Prop) : Run process := course (thirdPast P) (thirdPast_stems P)

theorem thirdCourse_prec_iff (P : Prop) {i j : Nat} :
    ((thirdCourse P).state 3).prec i j ↔ (Undecided.third P).prec i j :=
  (grown_prec_iff (thirdPast P) 3).trans
    ⟨fun ⟨_, d⟩ => match d with
       | .inl ⟨at1, zero, p⟩ => .inr (.inl ⟨zero, at1, p⟩)
       | .inr ⟨at2, .inl zero⟩ => .inl ⟨zero, at2⟩
       | .inr ⟨at2, .inr ⟨isOne, p⟩⟩ => .inr (.inr ⟨isOne, at2, p⟩),
     fun pair => match pair with
       | .inl ⟨zero, at2⟩ => ⟨by rw [at2]; decide, .inr ⟨at2, .inl zero⟩⟩
       | .inr (.inl ⟨zero, at1, p⟩) => ⟨by rw [at1]; decide, .inl ⟨at1, zero, p⟩⟩
       | .inr (.inr ⟨isOne, at2, p⟩) => ⟨by rw [at2]; decide, .inr ⟨at2, .inr ⟨isOne, p⟩⟩⟩⟩

theorem links_of_iff {O O' : «际» Nat} (same : ∀ i j, O i j ↔ O' i j) {i j : Nat}
    (link : links O i j) : links O' i j :=
  ⟨(same i j).mp link.1, fun z ⟨first, second⟩ =>
    link.2 z ⟨(same i z).mpr first, (same z j).mpr second⟩⟩

/-- **Reaching every pair by links on every configuration of every course from the empty set is
excluded middle**: the growth reaches `Undecided.third P` at offset `3`, pointwise. -/
theorem reach_links_courses_iff_em :
    (∀ r : Run process, r.state 0 = empty → ∀ t i j, (r.state t).prec i j →
      «及» (links (r.state t).prec) i j) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun every P => Undecided.em_of_reach_third
     («及之单调» (fun _ _ link => links_of_iff (fun _ _ => thirdCourse_prec_iff P) link) 0 2
       (every (thirdCourse P) rfl 3 0 2 ((thirdCourse_prec_iff P).mpr (.inl ⟨rfl, rfl⟩)))),
   fun em _ start t _ _ pair =>
     reach_links_of_decided (fun _ _ _ => em _) (ordered_of_empty start t).labelled pair⟩

end Recheck

end CausalGrowth

end Becoming
