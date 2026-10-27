import Becoming.CausalGrowth

/-!
# Probes for the UE13 review (not part of the module)

Reviewer's probes of `Becoming.CausalGrowth`. Each block answers one finding of
`REVIEW-UE13.md`. Pure core: no `simp`, `omega`, `funext`, `propext` or `Classical`.
-/

namespace Becoming

open Generative

universe u

namespace CausalGrowth

namespace Probe

/-! ## P1. Precedence is the reach of its links, both ways; no finiteness needed -/

/-- The reach of the links lies within a transitive relation. -/
theorem reach_links_le {α : Type u} {O : «际» α} (trans : ∀ {i j k}, O i j → O j k → O i k)
    {i j : α} (reach : «及» (links O) i j) : O i j := by
  induction reach with
  | one link => exact link.1
  | more link _ ih => exact trans link.1 ih

/-- **Precedence is the reach of its links**, both inclusions, on a naturally labelled transitive
relation with decidable precedence. -/
theorem reach_links_iff {O : «际» Nat} [∀ i j, Decidable (O i j)]
    (trans : ∀ {i j k}, O i j → O j k → O i k) (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} :
    «及» (links O) i j ↔ O i j :=
  ⟨reach_links_le (O := O) trans, reach_links labelled⟩

theorem ordered_reach_links_iff {c : Causet} (ordered : c.Ordered) [∀ i j, Decidable (c.prec i j)]
    {i j : Nat} : «及» (links c.prec) i j ↔ c.prec i j :=
  reach_links_iff (O := c.prec) ordered.trans ordered.labelled

/-- Without transitivity only one inclusion holds: `0 → 1 → 2` is labelled and decidable, and its
links reach `(0, 2)`, which it does not relate. -/
def path (i j : Nat) : Prop := (i = 0 ∧ j = 1) ∨ (i = 1 ∧ j = 2)

instance (i j : Nat) : Decidable (path i j) := instDecidableOr

theorem path_not_reach_of_links : «及» (links path) 0 2 ∧ ¬ path 0 2 :=
  ⟨«及».more ⟨.inl ⟨rfl, rfl⟩, fun _ ⟨first, second⟩ => match first, second with
      | .inl ⟨_, one⟩, .inl ⟨zero, _⟩ => absurd (one.symm.trans zero) (by decide)
      | .inl ⟨_, _⟩, .inr ⟨_, two⟩ => absurd two (by decide)
      | .inr ⟨zero, _⟩, _ => absurd zero (by decide)⟩
    («及».one ⟨.inr ⟨rfl, rfl⟩, fun z ⟨first, second⟩ => match first, second with
      | .inl ⟨one, _⟩, _ => absurd one (by decide)
      | .inr ⟨_, two⟩, .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
      | .inr ⟨_, two⟩, .inr ⟨one, _⟩ => absurd (two.symm.trans one) (by decide)⟩),
   fun pair => match pair with
     | .inl ⟨_, one⟩ => absurd one (by decide)
     | .inr ⟨zero, _⟩ => absurd zero (by decide)⟩

/-- **Every net whose reach is a relation contains that relation's links** (any carrier): with
`reach_links_iff`, on a naturally labelled order with decidable precedence the links are the least
condition net whose reach is the precedence. -/
theorem links_least {α : Type u} {O R : «际» α} (generates : ∀ i j, «及» R i j ↔ O i j) {i j : α}
    (link : links O i j) : R i j :=
  link_of_reach ⟨(generates i j).mpr link.1,
    fun z ⟨first, second⟩ => link.2 z ⟨(generates i z).mp first, (generates z j).mp second⟩⟩

/-- `reach_links` needs no finiteness: on all the natural numbers in their order, an infinite
naturally labelled order (the limit of the chain), every pair is reached by links. -/
theorem nat_reach_links {i j : Nat} (lt : i < j) : «及» (links (fun a b : Nat => a < b)) i j :=
  @reach_links (fun a b : Nat => a < b) (fun a b => Nat.decLt a b) (fun h => h) i j lt

/-! ## P2. Decidability is needed: every pair reached by links on every causal set is excluded
middle -/

/-- Three elements: `0` before `2`, and `0` before `1` before `2` exactly where `P`. -/
def third (P : Prop) : Causet :=
  ⟨3, fun i j => (i = 0 ∧ j = 2) ∨ (i = 0 ∧ j = 1 ∧ P) ∨ (i = 1 ∧ j = 2 ∧ P)⟩

theorem third_ordered (P : Prop) : (third P).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨_, two⟩, .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
    | .inl ⟨_, two⟩, .inr (.inl ⟨zero, _, _⟩) => absurd (two.symm.trans zero) (by decide)
    | .inl ⟨_, two⟩, .inr (.inr ⟨one, _, _⟩) => absurd (two.symm.trans one) (by decide)
    | .inr (.inl ⟨_, one, _⟩), .inl ⟨zero, _⟩ => absurd (one.symm.trans zero) (by decide)
    | .inr (.inl ⟨_, one, _⟩), .inr (.inl ⟨zero, _, _⟩) => absurd (one.symm.trans zero) (by decide)
    | .inr (.inl ⟨zero, _, _⟩), .inr (.inr ⟨_, two, _⟩) => .inl ⟨zero, two⟩
    | .inr (.inr ⟨_, two, _⟩), .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
    | .inr (.inr ⟨_, two, _⟩), .inr (.inl ⟨zero, _, _⟩) => absurd (two.symm.trans zero) (by decide)
    | .inr (.inr ⟨_, two, _⟩), .inr (.inr ⟨one, _, _⟩) => absurd (two.symm.trans one) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨zero, two⟩ => by subst zero; subst two; exact (by decide : (0 : Nat) < 2)
    | .inr (.inl ⟨zero, one, _⟩) => by subst zero; subst one; exact (by decide : (0 : Nat) < 1)
    | .inr (.inr ⟨one, two, _⟩) => by subst one; subst two; exact (by decide : (1 : Nat) < 2)
  within := fun pair => match pair with
    | .inl ⟨_, two⟩ => by subst two; exact (by decide : (2 : Nat) < 3)
    | .inr (.inl ⟨_, one, _⟩) => by subst one; exact (by decide : (1 : Nat) < 3)
    | .inr (.inr ⟨_, two, _⟩) => by subst two; exact (by decide : (2 : Nat) < 3)

theorem third_not_from_two {P : Prop} {y : Nat} : ¬ (third P).prec 2 y :=
  fun pair => match pair with
  | .inl ⟨zero, _⟩ => absurd zero (by decide)
  | .inr (.inl ⟨zero, _, _⟩) => absurd zero (by decide)
  | .inr (.inr ⟨one, _, _⟩) => absurd one (by decide)

theorem third_no_reach_from_two {P : Prop} {y : Nat} : ¬ «及» (links (third P).prec) 2 y :=
  fun reach => match reach with
  | .one link => third_not_from_two link.1
  | .more link _ => third_not_from_two link.1

/-- Where `0` reaches `2` by links, `P` is decided. -/
theorem em_of_reach_third {P : Prop} (reach : «及» (links (third P).prec) 0 2) : P ∨ ¬ P :=
  match reach with
  | .one link => .inr fun p => link.2 1 ⟨.inr (.inl ⟨rfl, rfl, p⟩), .inr (.inr ⟨rfl, rfl, p⟩)⟩
  | .more link rest => match link.1 with
    | .inl ⟨_, two⟩ =>
      absurd (Eq.subst (motive := fun x => «及» (links (third P).prec) x 2) two rest)
        third_no_reach_from_two
    | .inr (.inl ⟨_, _, p⟩) => .inl p
    | .inr (.inr ⟨zero, _, _⟩) => absurd zero (by decide)

/-- A bounded search in `Prop`. -/
theorem searchBelow_or (p : Nat → Prop) (decided : ∀ z, p z ∨ ¬ p z) :
    ∀ n, (∃ z, z < n ∧ p z) ∨ ¬ ∃ z, z < n ∧ p z
  | 0 => .inr fun ⟨_, below, _⟩ => Nat.not_lt_zero _ below
  | n + 1 => match searchBelow_or p decided n with
    | .inl ⟨z, below, holds⟩ => .inl ⟨z, Nat.lt_succ_of_lt below, holds⟩
    | .inr absent => match decided n with
      | .inl last => .inl ⟨n, Nat.lt_succ_self n, last⟩
      | .inr last => .inr fun ⟨z, below, holds⟩ =>
        match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
        | .inl lower => absent ⟨z, lower, holds⟩
        | .inr same => last (same ▸ holds)

/-- `reach_links_within` with only betweenness decided, in `Prop`. -/
theorem reach_links_within_of_decided {O : «际» Nat}
    (decided : ∀ i z j, (O i z ∧ O z j) ∨ ¬ (O i z ∧ O z j))
    (labelled : ∀ {i j}, O i j → i < j) :
    ∀ n {i j : Nat}, j ≤ i + n → O i j → «及» (links O) i j
  | 0, _, _, gap, pair => absurd (Nat.lt_of_lt_of_le (labelled pair) gap) (Nat.lt_irrefl _)
  | n + 1, i, j, gap, pair =>
    match searchBelow_or (fun z => O i z ∧ O z j) (fun z => decided i z j) j with
    | .inl ⟨z, _, first, second⟩ =>
      «及之传递»
        (reach_links_within_of_decided decided labelled n
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (labelled second) gap)) first)
        (reach_links_within_of_decided decided labelled n
          (Nat.le_trans gap (by
            show Nat.succ (i + n) ≤ z + n
            rw [← Nat.succ_add]
            exact Nat.add_le_add_right (labelled first) n)) second)
    | .inr nothing =>
      .one ⟨pair, fun z ⟨first, second⟩ => nothing ⟨z, labelled second, first, second⟩⟩

/-- **Every pair is reached by links where betweenness is decided** (no `Decidable` instance). -/
theorem reach_links_of_decided {O : «际» Nat}
    (decided : ∀ i z j, (O i z ∧ O z j) ∨ ¬ (O i z ∧ O z j))
    (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} (pair : O i j) : «及» (links O) i j :=
  reach_links_within_of_decided decided labelled j (Nat.le_add_left j i) pair

/-- **Calibration: on every causal set every pair is reached by links exactly where excluded middle
holds.** Telling a link from a longer chain is deciding whether anything lies between. -/
theorem reach_links_all_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, c.prec i j → «及» (links c.prec) i j) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun every P => em_of_reach_third (every (third P) (third_ordered P) 0 2 (.inl ⟨rfl, rfl⟩)),
   fun em _ ordered _ _ pair => reach_links_of_decided (fun _ _ _ => em _) ordered.labelled pair⟩

/-! ## P3. The exact form of "widening is losing precedence": the strict parts -/

variable {r r' : Run process}

/-- **The strict part of stem inclusion is the strict part of precedence inclusion, reversed**, at
every offset, with no decision. -/
theorem rangeIncludes_strict_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    (r.RangeIncludes Stem r' ∧ ¬ r'.RangeIncludes Stem r) ↔
      ((∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) ∧
        ¬ ∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) :=
  ⟨fun ⟨inc, notBack⟩ => ⟨(rangeIncludes_iff start start').mp inc,
     fun back => notBack ((rangeIncludes_iff start' start).mpr back)⟩,
   fun ⟨inside, notBack⟩ => ⟨(rangeIncludes_iff start start').mpr inside,
     fun back => notBack ((rangeIncludes_iff start' start).mp back)⟩⟩

theorem rangeWidens_strict (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens Stem r') :
    (∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) ∧
      ¬ ∀ t i j, (r'.state t).prec i j → (r.state t).prec i j :=
  (rangeIncludes_strict_iff start start').mp ⟨widens.1, widens.2.not_included⟩

/-! ## P4. The explicit pair: decided, it is found; for every pair of courses it is De Morgan -/

/-- With precedence decidable at an offset, a failed inclusion there gives an explicit pair the
first course lacks (a bounded search over pairs). -/
theorem pair_of_not_included (start' : r'.state 0 = empty) {t : Nat}
    [∀ i j, Decidable ((r.state t).prec i j)] [∀ i j, Decidable ((r'.state t).prec i j)]
    (not : ¬ ∀ i j, (r'.state t).prec i j → (r.state t).prec i j) :
    ∃ i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  match @searchBelow (fun j => ∃ i, i < j ∧ ((r'.state t).prec i j ∧ ¬ (r.state t).prec i j))
      (fun j => searchBelow (fun i => (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) j) t with
  | isTrue ⟨j, _, i, _, pair', lacks⟩ => ⟨i, j, pair', lacks⟩
  | isFalse absent => absurd (fun i j pair' =>
      match (inferInstance : Decidable ((r.state t).prec i j)) with
      | isTrue pair => pair
      | isFalse lacks => absurd ⟨j,
          Nat.lt_of_lt_of_le ((ordered_of_empty start' t).within pair')
            (Nat.le_of_eq (size_of_run start' t)),
          i, (ordered_of_empty start' t).labelled pair', pair', lacks⟩ absent) not

/-- **With precedence decidable, a course exceeds another's stems exactly where the other has a
pair it lacks.** -/
theorem rangeExceeds_iff_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    [∀ t i j, Decidable ((r.state t).prec i j)] [∀ t i j, Decidable ((r'.state t).prec i j)] :
    r.RangeExceeds Stem r' ↔ ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  ⟨fun exceeds => match not_included_of_rangeExceeds start start' exceeds with
     | ⟨t, not⟩ => match pair_of_not_included start' not with
       | ⟨i, j, pair', lacks⟩ => ⟨t, i, j, pair', lacks⟩,
   fun ⟨_, _, _, pair', lacks⟩ => rangeExceeds_of_pair start start' pair' lacks⟩

/-- Pasts born only at `2`, below `2`, give a course. -/
theorem stems_of_two {past : Nat → Nat → Prop} (two : ∀ {t i}, past t i → t = 2 ∧ i < 2)
    (t : Nat) : Stem (grown past t) (past t) :=
  ⟨fun d => by
     have h := two d
     rw [grown_size, h.1]
     exact h.2,
   fun d pair => by
     have later := ((grown_prec_iff past t).mp pair).1
     have born := two ((grown_prec_iff past t).mp pair).2
     have at2 := (two d).1
     rw [born.1, at2] at later
     exact absurd later (Nat.lt_irrefl 2)⟩

/-- `2` above `0` and `1`. -/
def bothPast (t i : Nat) : Prop := t = 2 ∧ i < 2

/-- `2` above `0` where `A`, above `1` where `B`. -/
def eitherPast (A B : Prop) (t i : Nat) : Prop := t = 2 ∧ ((i = 0 ∧ A) ∨ (i = 1 ∧ B))

def both : Run process := course bothPast (stems_of_two fun d => d)

theorem either_two {A B : Prop} {t i : Nat} (d : eitherPast A B t i) : t = 2 ∧ i < 2 :=
  ⟨d.1, match d.2 with
    | .inl ⟨zero, _⟩ => by rw [zero]; decide
    | .inr ⟨one, _⟩ => by rw [one]; decide⟩

def either (A B : Prop) : Run process := course (eitherPast A B) (stems_of_two either_two)

theorem either_rangeIncludes {A B : Prop} : (either A B).RangeIncludes Stem both :=
  (rangeIncludes_iff (r := either A B) (r' := both) rfl rfl).mpr fun t _ _ pair =>
    match (grown_prec_iff (eitherPast A B) t).mp pair with
    | ⟨later, d⟩ => (grown_prec_iff bothPast t).mpr ⟨later, either_two d⟩

/-- Where not both `A` and `B`, the principal stem at `2` of `either A B` is not a stem of `both`. -/
theorem either_exceeds {A B : Prop} (notBoth : ¬ (A ∧ B)) : (either A B).RangeExceeds Stem both :=
  ⟨3, principal ((either A B).state 3) 2,
   stem_principal (ordered_of_empty (r := either A B) rfl 3)
     (by show 2 < (grown (eitherPast A B) 3).size; rw [grown_size]; decide),
   fun stem =>
     have past : ∀ k, bothPast 2 k → principal (grown (eitherPast A B) 3) 2 k :=
       fun _ below => stem.closed (.inl rfl) ((grown_prec_iff bothPast 3).mpr ⟨by decide, below⟩)
     notBoth ⟨match past 0 ⟨rfl, by decide⟩ with
       | .inl same => absurd same (by decide)
       | .inr p => match ((grown_prec_iff (eitherPast A B) 3).mp p).2.2 with
         | .inl ⟨_, a⟩ => a
         | .inr ⟨one, _⟩ => absurd one (by decide),
       match past 1 ⟨rfl, by decide⟩ with
       | .inl same => absurd same (by decide)
       | .inr p => match ((grown_prec_iff (eitherPast A B) 3).mp p).2.2 with
         | .inl ⟨zero, _⟩ => absurd zero (by decide)
         | .inr ⟨_, b⟩ => b⟩⟩

/-- A pair of `both` that `either A B` lacks decides one of `A`, `B` negatively. -/
theorem deMorgan_of_pair {A B : Prop}
    (found : ∃ t i j, (both.state t).prec i j ∧ ¬ ((either A B).state t).prec i j) : ¬ A ∨ ¬ B :=
  match found with
  | ⟨t, i, _, pair', lacks⟩ =>
    match (grown_prec_iff bothPast t).mp pair' with
    | ⟨later, two, below⟩ =>
      match i, below, lacks with
      | 0, _, lacks =>
        .inl fun a => lacks ((grown_prec_iff (eitherPast A B) t).mpr ⟨later, two, .inl ⟨rfl, a⟩⟩)
      | 1, _, lacks =>
        .inr fun b => lacks ((grown_prec_iff (eitherPast A B) t).mpr ⟨later, two, .inr ⟨rfl, b⟩⟩)
      | k + 2, below, _ =>
        absurd (Nat.lt_of_le_of_lt (Nat.le_add_left 2 k) below) (Nat.lt_irrefl 2)

/-- **Calibration: finding the pair from exceeding, for every pair of courses from the empty set,
is De Morgan's law** `¬ (A ∧ B) → ¬ A ∨ ¬ B` (equivalently weak excluded middle). -/
theorem deMorgan_of_pair_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j)
    {A B : Prop} (notBoth : ¬ (A ∧ B)) : ¬ A ∨ ¬ B :=
  deMorgan_of_pair (converse (either A B) both rfl rfl (either_exceeds notBoth))

/-! ## P5. On a configuration nothing renews without end; in the limits the two extremes part -/

/-- **Where a relation raises the label and relates only below `n`, every element ceases**
(`«息»`) under every class. -/
theorem ceases_of_bounded {O : «际» Nat} (E : «际» Nat) (labelled : ∀ {i j}, O i j → i < j)
    {n : Nat} (bound : ∀ {i j}, O i j → j < n) : ∀ k x, n ≤ x + k → «息» O E x
  | 0, x, top => .mk fun _ ⟨_, step, _, _⟩ =>
      absurd (Nat.lt_of_lt_of_le (Nat.lt_trans (labelled step) (bound step)) top) (Nat.lt_irrefl x)
  | k + 1, x, top => .mk fun w ⟨_, step, _, line⟩ =>
      ceases_of_bounded E labelled bound k w (Nat.le_trans top (by
        show Nat.succ (x + k) ≤ w + k
        rw [← Nat.succ_add]
        exact Nat.add_le_add_right
          (Nat.lt_trans (labelled step) (labelled_of_reach (fun c => labelled c.1) line)) k))

/-- **On every causal set of the growth every element ceases, in every class, on precedence and
on links.** -/
theorem ordered_ceases {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    «息» c.prec E x ∧ «息» (links c.prec) E x :=
  ⟨ceases_of_bounded E ordered.labelled ordered.within c.size x (Nat.le_add_left _ _),
   ceases_of_bounded E (fun link => ordered.labelled link.1) (fun link => ordered.within link.1)
     c.size x (Nat.le_add_left _ _)⟩

/-- **So no configuration of the growth renews without end** (`«生生»`), in any class. -/
theorem ordered_not_renews {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    ¬ «生生» c.prec E x ∧ ¬ «生生» (links c.prec) E x :=
  ⟨fun renews => «生生不息» renews (ordered_ceases ordered E x).1,
   fun renews => «生生不息» renews (ordered_ceases ordered E x).2⟩

/-- The chain's limit: `i` before `j` at some offset. -/
def chainLimit (i j : Nat) : Prop := ∃ t, (chain.state t).prec i j

theorem chainLimit_iff {i j : Nat} : chainLimit i j ↔ i < j :=
  ⟨fun ⟨t, pair⟩ => ((chain_prec_iff t).mp pair).2,
   fun earlier => ⟨j + 1, (chain_prec_iff (j + 1)).mpr ⟨Nat.lt_succ_self j, earlier⟩⟩⟩

/-- The antichain's limit. -/
def antichainLimit (i j : Nat) : Prop := ∃ t, (antichain.state t).prec i j

/-- **On the antichain's limit nothing renews without end, in any class.** -/
theorem antichainLimit_not_renews (E : «际» Nat) (x : Nat) : ¬ «生生» antichainLimit E x :=
  fun renews => match «生生之展» renews with
  | ⟨_, _, ⟨t, pair⟩, _⟩ => antichain_prec t _ _ pair

def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

/-- The class pairing `2m` with `2m + 1`. -/
def pairs (i j : Nat) : Prop := half i = half j

theorem pairs_class : «类» pairs := ⟨fun _ => rfl, fun same => same.symm, fun a b => a.trans b⟩

theorem double_succ (m : Nat) : (m + 1) + (m + 1) = m + m + 2 :=
  show Nat.succ ((m + 1) + m) = Nat.succ (Nat.succ (m + m)) from congrArg Nat.succ (Nat.succ_add m m)

theorem half_double : ∀ m, half (m + m) = m
  | 0 => rfl
  | m + 1 => by rw [double_succ]; exact congrArg (· + 1) (half_double m)

theorem half_double_succ : ∀ m, half (m + m + 1) = m
  | 0 => rfl
  | m + 1 => by rw [double_succ]; exact congrArg (· + 1) (half_double_succ m)

theorem half_lt : ∀ x m, x < m + m → half x < m
  | _, 0, below => absurd below (Nat.not_lt_zero _)
  | 0, m + 1, _ => Nat.succ_pos m
  | 1, m + 1, _ => Nat.succ_pos m
  | n + 2, m + 1, below => Nat.succ_lt_succ (half_lt n m (by
      rw [double_succ] at below
      exact Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ below)))

/-- The odd elements. -/
def odd (z : Nat) : Prop := ∃ m, z = m + m + 1

/-- **On the chain's limit, under the class pairing `2m` with `2m + 1`, `1` renews without end**
(`«生生»`): each odd element conditions the next even one, which begins its pair, and the pair's
line goes on to the next odd element. -/
theorem chainLimit_renews : «生生» chainLimit pairs 1 :=
  ⟨odd, fun z ⟨m, oddZ⟩ => ⟨(m + 1) + (m + 1), (m + 1) + (m + 1) + 1,
     chainLimit_iff.mpr (by rw [oddZ, double_succ]; exact Nat.lt_succ_self _),
     fun ⟨x, before, same⟩ => by
       have h := half_lt x (m + 1) (chainLimit_iff.mp before)
       have same' : half x = half ((m + 1) + (m + 1)) := same
       rw [same', half_double] at h
       exact Nat.lt_irrefl _ h,
     «及».one ⟨chainLimit_iff.mpr (Nat.lt_succ_self _),
       show half ((m + 1) + (m + 1)) = half ((m + 1) + (m + 1) + 1) by
         rw [half_double, half_double_succ]⟩,
     ⟨m + 1, rfl⟩⟩,
   ⟨0, rfl⟩⟩

/-! ## P6. Two readings of what can form, reversed: no order contains both widenings -/

/-- What continues within the one class, read as what a configuration admits. -/
def continuing (c : Causet) (p : Nat × Nat) : Prop := «相续» c.prec «一» p.1 p.2

/-- **Including what continues is being included in what can be born next.** -/
theorem rangeIncludes_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeIncludes continuing r' ↔ r'.RangeIncludes Stem r :=
  ⟨fun inc => (rangeIncludes_iff start' start).mpr fun t i j pair =>
      (continuation_one_iff (ordered_of_empty start t)).mp
        (inc t (i, j) ((continuation_one_iff (ordered_of_empty start' t)).mpr pair)),
   fun inc t p line => (continuation_one_iff (ordered_of_empty start t)).mpr
      ((rangeIncludes_iff start' start).mp inc t p.1 p.2
        ((continuation_one_iff (ordered_of_empty start' t)).mp line))⟩

/-- **Widening what continues is exactly inclusion of precedence with a pair the other lacks**,
constructively. -/
theorem rangeWidens_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeWidens continuing r' ↔
      (∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) ∧
        ∃ t i j, (r.state t).prec i j ∧ ¬ (r'.state t).prec i j :=
  ⟨fun ⟨inc, t, p, line, notLine⟩ =>
     ⟨(rangeIncludes_iff start' start).mp ((rangeIncludes_continuing_iff start start').mp inc),
      t, p.1, p.2, (continuation_one_iff (ordered_of_empty start t)).mp line,
      fun pair' => notLine ((continuation_one_iff (ordered_of_empty start' t)).mpr pair')⟩,
   fun ⟨inside, t, i, j, pair, lacks⟩ =>
     ⟨(rangeIncludes_continuing_iff start start').mpr ((rangeIncludes_iff start' start).mpr inside),
      t, (i, j), (continuation_one_iff (ordered_of_empty start t)).mpr pair,
      fun line => lacks ((continuation_one_iff (ordered_of_empty start' t)).mp line)⟩⟩

/-- **Widening what continues narrows what can be born next.** -/
theorem rangeWidens_stems_of_continuing (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens continuing r') : r'.RangeWidens Stem r :=
  match (rangeWidens_continuing_iff start start').mp widens with
  | ⟨inside, _, _, _, pair, lacks⟩ => rangeWidens_of start' start inside pair lacks

/-- **Calibration: that narrowing what can be born next always widens what continues is De Morgan's
law.** -/
theorem deMorgan_of_stems_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r)
    {A B : Prop} (notBoth : ¬ (A ∧ B)) : ¬ A ∨ ¬ B :=
  match (rangeWidens_continuing_iff (r := both) (r' := either A B) rfl rfl).mp
      (converse (either A B) both rfl rfl ⟨either_rangeIncludes, either_exceeds notBoth⟩) with
  | ⟨_, found⟩ => deMorgan_of_pair found

/-- **No strict order contains both widenings**: widening what can be born next ranks the antichain
above the chain, widening what continues the chain above the antichain. -/
theorem no_order_contains_both :
    ¬ ∃ above : Run process → Run process → Prop,
      (∀ r, ¬ above r r) ∧ (∀ {r r' r''}, above r r' → above r' r'' → above r r'') ∧
      (∀ r r', r.RangeWidens Stem r' → above r r') ∧
      (∀ r r', r.RangeWidens continuing r' → above r r') :=
  fun ⟨above, irrefl, trans, stems, lines⟩ =>
    irrefl antichain (trans
      (stems antichain chain
        (antichain_rangeWidens (r := chain) rfl
          ((chain_prec_iff 2 (i := 0) (j := 1)).mpr ⟨by decide, by decide⟩)))
      (lines chain antichain ((rangeWidens_continuing_iff (r := chain) (r' := antichain) rfl rfl).mpr
        ⟨fun t i j pair => absurd pair (antichain_prec t i j),
         2, 0, 1, (chain_prec_iff 2 (i := 0) (j := 1)).mpr ⟨by decide, by decide⟩,
         antichain_prec 2 0 1⟩)))

/-- **An order never reversing widening what can be born next ranks nothing above the antichain**
among the courses with a precedence pair: 07's requirement, read on stems. -/
theorem antichain_unbeaten (above : Run process → Run process → Prop)
    (never : ∀ r r', r.RangeWidens Stem r' → ¬ above r' r)
    (start : r.state 0 = empty) {t i j : Nat} (pair : (r.state t).prec i j) : ¬ above r antichain :=
  never antichain r (antichain_rangeWidens start pair)

/-- The chain has the most continuation of every class read on precedence. -/
theorem continuation_le_chain (start : r.state 0 = empty) (E : «际» Nat) (t : Nat) :
    «则» («相续» (r.state t).prec E) («相续» (chain.state t).prec E) :=
  continuation_of_rangeIncludes start rfl (rangeIncludes_chain start) E t

/-! ## P7. What keeps widening is what each configuration admits, inside a possible that never grows -/

/-- **Every stem a course ever admits is possible from its start** (UE10's `Run.possible_from_start`):
what can be born next keeps widening inside a whole possible that never grows. -/
theorem stem_possible_from_start (r : Run process) (n : Nat) {D : Nat → Prop}
    (stem : Stem (r.state n) D) : Reaching.Possible process Stem (r.state 0) D :=
  Run.possible_from_start r n ⟨r.state n, Reach.refl _ _, stem⟩

/-! ## P8. Read on both together, widening holds between no two courses -/

/-- What can be born next and what continues within the one class, read together. -/
def formsOrContinues (c : Causet) : (Nat → Prop) ⊕ (Nat × Nat) → Prop
  | .inl D => Stem c D
  | .inr p => continuing c p

/-- **Read on what can be born next and what continues together, no course widens another**: the
two inclusions together force the same precedence at every offset. -/
theorem not_rangeWidens_formsOrContinues (start : r.state 0 = empty)
    (start' : r'.state 0 = empty) : ¬ r.RangeWidens formsOrContinues r' :=
  fun ⟨inc, t, x, yes, no⟩ =>
    have stems : r.RangeIncludes Stem r' := fun t D stem => inc t (.inl D) stem
    have lines : r.RangeIncludes continuing r' := fun t p line => inc t (.inr p) line
    have back : r'.RangeIncludes Stem r := (rangeIncludes_continuing_iff start start').mp lines
    have backLines : r'.RangeIncludes continuing r :=
      (rangeIncludes_continuing_iff start' start).mpr stems
    match x, yes, no with
    | .inl D, yes, no => no (back t D yes)
    | .inr p, yes, no => no (backLines t p yes)

/-- **Given a pair one course has and the other lacks, the two are mixed** on the joint reading:
the one lacking it exceeds in what can be born next, the other in what continues. -/
theorem mixed_of_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) :
    r.RangeExceeds formsOrContinues r' ∧ r'.RangeExceeds formsOrContinues r :=
  ⟨match rangeExceeds_of_pair start start' pair' lacks with
   | ⟨t, D, yes, no⟩ => ⟨t, .inl D, yes, no⟩,
   ⟨t, .inr (i, j), «及».one ⟨pair', trivial⟩,
    fun line => lacks ((continuation_one_iff (ordered_of_empty start t)).mp line)⟩⟩

/-! ## P9. Law 5's other direction: widening can also lose a finer class's continuation on links -/

theorem finer_loses : antichain.RangeWidens Stem Finer.wide ∧
    «相续» (links (Finer.wide.state 3).prec) Finer.classOf 0 2 ∧
    ¬ «相续» (links (antichain.state 3).prec) Finer.classOf 0 2 :=
  ⟨antichain_rangeWidens (r := Finer.wide) (t := 3) (i := 0) (j := 2) rfl
     ((grown_prec_iff Finer.widePast 3).mpr ⟨by decide, rfl, rfl⟩),
   Finer.continues,
   fun line => match line with
     | .one step => antichain_prec 3 0 2 step.1.1
     | .more step _ => antichain_prec 3 0 _ step.1.1⟩

end Probe

end CausalGrowth

end Becoming
