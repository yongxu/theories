import Becoming.Grammar
import Becoming.GrammarMap
import Becoming.Prelude

/-!
# The five master laws on the grammar (主律)

The master laws of the method chapter (08 §7) restated on the grammar of `Becoming.Grammar`, for
every carrier and every relation: closure, balance, finite runs (return, being drawn and rest),
lumping and order. Each is stated with what it uses: where a global form uses more (a fixed
successor everywhere, merging nothing everywhere, a successor everywhere, a list of the whole
carrier), it is a corollary of a local one stated beside it. This module imports only the grammar,
its map (`Becoming.GrammarMap`, for `«尽»`) and the prelude, so it sits below every model:
`Becoming.Frame` imports it, and the models' laws that are cases of these are proved from them in
their own modules (closure in `Frame` and `GrammarScope`; finite runs in `Recurrence`, `Attraction`
and `Amounts`; lumping bridged in `Laws` and proved from them in `Mechanism`, `GrammarRegularity`
and `IdentificationRuns`; order in `Admission`, `Regions` and `Weightings`). Balance alone is
represented, not derived: `Flow.Balances`, `Flow.BalancesOn`, `Flow.Balances.over` and
`balance_over_stretch_on` are each read on the grammar both ways (`Flow.balances_iff_units`,
`Flow.balancesOn_iff_units`, `Flow.over_iff_units`, `«程守数当且仅当可对»`), and their proofs and
their consumers' stay arithmetic, since each needs only the count.

| name | gloss |
|---|---|
| `«闭»` | a region closed under a relation: whatever a member bears it to is a member |
| `«所闭»` | lying within a closure: every region closed under the relation that holds `x` holds `y` |
| `«对»` | a perfect pairing of the places of two finite lists under a relation, each pair related |
| `«聚»` | lists gathered along a list of indices, joined |
| `«定后»`, `«定前»` | the successor is fixed (`R˘;R ⊆ 静`); the predecessor is fixed, nothing merged (`R;R˘ ⊆ 静`) |
| `«定后于»` | the successor is fixed at what `x` reaches (`«定后»` within `«所闭» R x`) |
| `«线不并»` | merging nothing at the first `N` places of a line |
| `«入»` | drawn in: a closed region `x` lies outside holds something `x` reaches |
| `«迭»` | `n` steps: the `n`-fold composition of a relation |
| `«屡»`, `«或屡»` | steps of a relation recur along a line; recur as far as can be refuted, from a place on |
| `«同行»` | `E` goes alike under `R`: `R˘;E;R ⊆ E` |
| `«像»` | the image of a relation along a map |
| `«逾»` | exceeds: relates something the other does not |
| `«广»`, `«齐»`, `«杂»` | widens (includes and exceeds); keeps (each includes the other); mixed (each exceeds the other) |

* **Closure.** `«所闭» R x y` is exactly `x = y ∨ «及» R x y` (`«所闭当且仅当同一或及»`): the least
  closed region holding `x` is `x` itself with what `x` reaches. It is reflexive, transitive, holds
  every step, grows with the relation, is symmetric for a symmetric relation, is itself closed,
  nothing within it bears the relation beyond it, and a region is `x`'s closure exactly where it
  holds `x`, is closed and lies within the closure (`«所闭之证»`).
* **Balance.** A perfect pairing (`«对»`) between finite lists under any relation conserves their
  count (`«对之长»`); under the one it is exactly equal count (`«一之对»`), and under an arbitrary
  relation equal count need not give one (`«等长而不对之例»`, under the empty relation). Pairings
  read backward are pairings under the converse (`«对之逆»`), compose under the composite
  (`«对之接»`: `«对» R a b` and `«对» S b c` give `«对» («而» R S) a c`; under a transitive relation,
  under itself, `«对之传»`), and join (`«对之并»`). So lists paired from what comes in (before, given)
  to what goes on (after, taken) have `after + taken = before + given` (`«对则守数»`), and every four
  numbers with that equation are the lengths of lists of units so paired under the one
  (`«守数当且仅当可对»`). Over a finite family, the members' pairings gather into the family's
  (`«对之族»`); over a stretch, pairings at each step under `R` give one, under `R`'s closure, of
  what stands before the stretch with everything given along it with what stands after it with
  everything taken along it (`«对之程»`), and the count law over a stretch is exactly such a
  pairing of units (`«程守数当且仅当可对»`). This is an exact cardinality representation of
  natural-number balance, near-definitional under the one: the pairing is supplied, not derived from
  the unfolding, and it establishes no trajectory of units.
* **Finite runs: return and being drawn.** For every relation, `x` is drawn exactly where it
  reaches something that does not reach back (`«入当且仅当有不返»`). With the successor fixed at
  what `x` reaches, `x`, reaching itself, is not drawn (`«定后于则返者不入»`, from
  `«定后于环则所及皆返»`); for every relation, an occurrence with a successor that does not reach
  itself is drawn (`«有后不返则入»`); so with the successor fixed there and some successor, drawn is
  exactly not reaching itself (`«定后于有后则入当且仅当不返»`). The global forms (`«定后环则所及皆返»`,
  `«定后则返者不入»`, `«定后有后则入当且仅当不返»`) are corollaries. The fixed successor cannot be
  omitted (`«入而返之例»`), nor can the successor (`«无后者不入亦不返»`), and the global fixed
  successor is more than the law uses (`«非定后返而不入之例»`: no fixed successor, yet a place that
  reaches itself is not drawn). Along a line whose places a list holds, merging nothing at the
  line's places brings the line back to its start within the list's length (`«线有限不并则回»`, by
  pigeonhole with no decidability, and back along the line, `«线不并则可退»`), so its start reaches
  itself (`«线有限不并则返»`); with the successor fixed at what its start reaches, its last place
  reaches itself (`«定后于线有限则末返»`). So where a list holds every occurrence and every
  occurrence has a successor, merging nothing makes every occurrence reach itself
  (`«有限遍后定前则皆返»`). Two occurrences that reach themselves, with the successor fixed at what
  each reaches, share no successor unless they are one (`«定后于二返则不并»`); so under a fixed
  successor every occurrence reaching itself makes the relation merge nothing (`«皆返定后则定前»`),
  and on a listed carrier with a successor everywhere the two are one (`«有限遍后定后则定前当且仅当皆返»`).
  Steps compose and cancel: with the successor fixed at what `x` reaches, `n` steps from `x` lead to
  one place (`«迭之定于»`), and merging nothing, `n` steps to one place come from one (`«迭之定前»`).
* **Finite runs: rest.** A line is at rest where its steps of `F` (a least fall, say) stop
  recurring (`«屡»`, `«或屡»`) while its steps are steps of `Q` (no rise, say). Where every course
  of `Q` steps then an `F` step ends from the line's place (`«尽» («而» («所闭» Q) F) «一»`, the
  grammar's ending), the `F` steps do not recur, as far as can be refuted (`«尽则不或屡»`) and so
  outright (`«尽则不屡»`), with no decision and no choice. `Amounts.rests_unrefuted` and
  `Amounts.rests` are this law at amounts (`Amounts.falls_end`: within fewer than `m` least losses
  the falls end), and `Amounts.FallsStop` is, by definition, the non-recurrence of strict falls
  (`Amounts.fallsStop_iff`). **Rest is not a case of being drawn in**: a fixed point is at rest and
  not drawn (`«止而不入之例»`), and a place can be drawn in while its steps of `F` recur
  (`«入而屡之例»`). Rest is a case of ending (`«尽»`), which `Becoming.GrammarMap` reads as
  degeneration (`«退化»`).
* **Lumping.** `«同行» R E` (`R˘;E;R ⊆ E`) says that `E`-alike occurrences go to `E`-alike
  occurrences (`«同行之逐点»`). Constancy (`«有常»`) gives it where the successor is fixed at the
  occurrences `E` leads to (`«有常局定后则同行»`); it gives constancy where a successor exists at
  each occurrence `E` leads to from one that has a successor (`«同行可续则有常»`), a hypothesis
  constancy itself gives (`«有常则可续»`); so with the successor fixed there, constancy is exactly
  going alike plus that availability (`«局定后则有常当且仅当同行可续»`). The global forms
  (`«有常定后则同行»`, `«同行遍后则有常»`) are corollaries. The image of a relation along a map has
  a fixed successor exactly where sameness under the map goes alike (`«像定后当且仅当同行»`): a part
  read alone carries a law, possibly partial, exactly where the rest makes no difference to where it
  goes. Going alike keeps lines of every length alike (`«同行之迭»`).
* **Order.** Widening (`«广» R S`: `S ⊆ R` and `R` relates something `S` does not) is irreflexive,
  asymmetric and transitive; it excludes keeping and being mixed, and keeping excludes being mixed.
  Where inclusion or exceeding is decided both ways, one of the four holds (`«四比之周»`); that it is
  decided for every pair of relations on every carrier is exactly excluded middle
  (`«则逾之定当且仅当排中»`). What a path or a course admits is read as a coreflexive relation (a
  partial identity: `Web.admitted`, `Weighting.admittedOn`), so the models' comparisons are these.

What is not shown: that any model's relation is functional, total or listed (the models supply
these); the n-step lines law for lines of different lengths; that a pairing under continuation
(`«对» («续» R E)`) adds anything to equal count, which is not stated; the converse of the law of
rest, from rest along every line to the ending of the courses, which would build an endless course
from endlessly many falls and needs dependent choice. Every statement is pointwise; no equality of
relations is used, and every declaration has an empty axiom report.
-/

namespace Becoming

universe u v

/-! ## Closure (闭) -/

section Closure

variable {α : Type u}

/-- A region closed under a relation (闭): whatever a member bears the relation to is a member. -/
def «闭» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y

/-- Lying within a closure (所闭): every region closed under `R` that holds `x` holds `y`. -/
def «所闭» (R : «际» α) : «际» α := fun x y => ∀ P : α → Prop, «闭» R P → P x → P y

/-- An occurrence lies within its own closure. -/
theorem «所闭之自反» (R : «际» α) (x : α) : «所闭» R x x := fun _ _ holds => holds

/-- A closure is transitive. -/
theorem «所闭之传递» {R : «际» α} {x y z : α} (h₁ : «所闭» R x y) (h₂ : «所闭» R y z) :
    «所闭» R x z :=
  fun P closed holds => h₂ P closed (h₁ P closed holds)

/-- What `x` bears the relation to lies within its closure. -/
theorem «缘在所闭» {R : «际» α} {x y : α} (h : R x y) : «所闭» R x y :=
  fun _ closed holds => closed x y holds h

/-- An occurrence's closure is closed. -/
theorem «所闭之闭» (R : «际» α) (x : α) : «闭» R («所闭» R x) :=
  fun _ _ within related => «所闭之传递» within («缘在所闭» related)

/-- A larger relation has a larger closure. -/
theorem «所闭之单调» {R S : «际» α} (h : «则» R S) : «则» («所闭» R) («所闭» S) :=
  fun _ _ within P closed holds => within P (fun a b inside related => closed a b inside (h a b related)) holds

/-- Under a symmetric relation the closure is symmetric. -/
theorem «所闭之对称» {R : «际» α} (h : «则» R («逆» R)) : «则» («所闭» R) («逆» («所闭» R)) :=
  fun x _ within => within (fun z => «所闭» R z x)
    (fun a b back related => «所闭之传递» («缘在所闭» (h a b related)) back) («所闭之自反» R x)

/-- Nothing within a closure bears the relation to what lies beyond it. -/
theorem «所闭之界» {R : «际» α} {x y z : α} (within : «所闭» R x y) (beyond : ¬ «所闭» R x z) :
    ¬ R y z :=
  fun related => beyond («所闭之传递» within («缘在所闭» related))

/-- A closed region holding `x` holds everything within `x`'s closure. -/
theorem «闭含所闭» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (within : «所闭» R x y) : P y :=
  within P closed holds

/-- **A certificate of a closure.** A region is `x`'s closure exactly where it holds `x`, is closed
under the relation and lies within `x`'s closure. -/
theorem «所闭之证» {R : «际» α} {P : α → Prop} {x : α} :
    (∀ y, P y ↔ «所闭» R x y) ↔ P x ∧ «闭» R P ∧ ∀ y, P y → «所闭» R x y :=
  ⟨fun exact => ⟨(exact x).mpr («所闭之自反» R x),
      fun a b inside related => (exact b).mpr («所闭之传递» ((exact a).mp inside) («缘在所闭» related)),
      fun y inside => (exact y).mp inside⟩,
   fun ⟨holds, closed, reached⟩ y => ⟨reached y, fun within => within P closed holds⟩⟩

/-- Where a closed region holds `x` but not `y`, `y` is not within `x`'s closure. -/
theorem «闭而外则不所闭» {R : «际» α} {P : α → Prop} {x y : α} (closed : «闭» R P) (holds : P x)
    (outside : ¬ P y) : ¬ «所闭» R x y :=
  fun within => outside (within P closed holds)

/-- A closed region holding `x` holds what `x` reaches. -/
theorem «闭之及» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (reach : «及» R x y) : P y := by
  induction reach with
  | one h => exact closed _ _ holds h
  | more h _ ih => exact ih (closed _ _ holds h)

/-- What `x` reaches lies within its closure. -/
theorem «及之所闭» {R : «际» α} : «则» («及» R) («所闭» R) :=
  fun _ _ reach _ closed holds => «闭之及» closed holds reach

/-- **The closure is what is reached.** `y` lies within `x`'s closure exactly where it is `x` or
`x` reaches it. -/
theorem «所闭当且仅当同一或及» {R : «际» α} {x y : α} : «所闭» R x y ↔ x = y ∨ «及» R x y :=
  ⟨fun within => within (fun z => x = z ∨ «及» R x z)
      (fun a b inside related => match inside with
        | .inl e => .inr (by cases e; exact .one related)
        | .inr reach => .inr («及之传递» reach (.one related)))
      (.inl rfl),
   fun reached => match reached with
    | .inl e => by cases e; exact «所闭之自反» R x
    | .inr reach => «及之所闭» x y reach⟩

/-- Reaching is a first step, then lying within the closure of where it leads. -/
theorem «及当且仅当一步而所闭» {R : «际» α} {x z : α} : «及» R x z ↔ ∃ y, R x y ∧ «所闭» R y z :=
  ⟨fun reach => match reach with
    | .one h => ⟨_, h, «所闭之自反» R _⟩
    | .more h rest => ⟨_, h, «及之所闭» _ _ rest⟩,
   fun ⟨_, h, within⟩ => match «所闭当且仅当同一或及».mp within with
    | .inl e => by cases e; exact .one h
    | .inr rest => .more h rest⟩

end Closure

/-! ## Lists (helpers, stated without `simp` so that no axiom enters)

Lemmas on numbers and lists, not statements of the grammar: pigeonhole (`revisits_within`) and the
list surgery that pairings need. `le_dest`, `ListTests.length_append`, `ListTests.append_assoc` and
`Naturals.add_congr` are the prelude's (`Becoming.Prelude`), used here, not restated. -/

namespace GrammarLaws

variable {α : Type u}

theorem length_insert : ∀ (b₁ : List α) (y : α) (b₂ : List α),
    (b₁ ++ y :: b₂).length = (b₁ ++ b₂).length + 1
  | [], _, _ => rfl
  | _ :: b₁, y, b₂ => congrArg Nat.succ (length_insert b₁ y b₂)

theorem length_replicate (x : α) : ∀ n, (List.replicate n x).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length_replicate x n)

theorem le_succ_cases {n K : Nat} (le : n ≤ K + 1) : n ≤ K ∨ n = K + 1 :=
  match Nat.lt_or_ge n (K + 1) with
  | .inl lt => Or.inl (Nat.le_of_lt_succ lt)
  | .inr ge => Or.inr (Nat.le_antisymm le ge)

theorem gap_of_lt {i j : Nat} (lt : i < j) : ∃ d, j = i + (d + 1) :=
  let ⟨d, same⟩ := le_dest lt
  ⟨d, same.trans (Nat.succ_add i d)⟩

theorem mem_cons_split {x a : α} {l : List α} (mem : x ∈ a :: l) : x = a ∨ x ∈ l := by
  cases mem with
  | head => exact Or.inl rfl
  | tail _ mem => exact Or.inr mem

/-- The `n`-th number other than `m`, counting from zero. -/
def skipAt : Nat → Nat → Nat
  | 0, n => n + 1
  | _ + 1, 0 => 0
  | m + 1, n + 1 => skipAt m n + 1

theorem skipAt_ne : ∀ m n, skipAt m n ≠ m
  | 0, _ => fun same => Nat.noConfusion same
  | _ + 1, 0 => fun same => Nat.noConfusion same
  | m + 1, n + 1 => fun same => skipAt_ne m n (Nat.succ.inj same)

theorem skipAt_le : ∀ m n, skipAt m n ≤ n + 1
  | 0, _ => Nat.le_refl _
  | _ + 1, 0 => Nat.zero_le _
  | m + 1, n + 1 => Nat.succ_le_succ (skipAt_le m n)

theorem skipAt_lt : ∀ m {i j : Nat}, i < j → skipAt m i < skipAt m j
  | 0, _, _, lt => Nat.succ_lt_succ lt
  | _ + 1, 0, _ + 1, _ => Nat.succ_pos _
  | m + 1, _ + 1, _ + 1, lt => Nat.succ_lt_succ (skipAt_lt m (Nat.lt_of_succ_lt_succ lt))
  | _ + 1, _, 0, lt => absurd lt (Nat.not_lt_zero _)

theorem split_at_head {g : Nat → α} {a : α} {l : List α} :
    ∀ K, (∀ n, n ≤ K → g n = a ∨ g n ∈ l) →
      (∃ i j, i < j ∧ j ≤ K ∧ g i = g j) ∨ (∀ n, n ≤ K → g n ∈ l) ∨
        (∃ m, m ≤ K ∧ g m = a ∧ ∀ n, n ≤ K → n ≠ m → g n ∈ l)
  | 0, held =>
    match held 0 (Nat.le_refl 0) with
    | .inl at_a => Or.inr (Or.inr ⟨0, Nat.le_refl 0, at_a,
        fun n le other => absurd (Nat.le_antisymm le (Nat.zero_le n)) other⟩)
    | .inr mem => Or.inr (Or.inl fun n le => by
        have same : n = 0 := Nat.le_antisymm le (Nat.zero_le n)
        subst same
        exact mem)
  | K + 1, held =>
    match split_at_head K (fun n le => held n (Nat.le_succ_of_le le)) with
    | .inl ⟨i, j, lt, le, same⟩ => Or.inl ⟨i, j, lt, Nat.le_succ_of_le le, same⟩
    | .inr (.inl all) =>
      match held (K + 1) (Nat.le_refl _) with
      | .inl at_a => Or.inr (Or.inr ⟨K + 1, Nat.le_refl _, at_a, fun n le other =>
          match le_succ_cases le with
          | .inl le => all n le
          | .inr same => absurd same other⟩)
      | .inr mem => Or.inr (Or.inl fun n le =>
          match le_succ_cases le with
          | .inl le => all n le
          | .inr same => by subst same; exact mem)
    | .inr (.inr ⟨m, le_m, at_m, rest⟩) =>
      match held (K + 1) (Nat.le_refl _) with
      | .inl at_a =>
        Or.inl ⟨m, K + 1, Nat.lt_succ_of_le le_m, Nat.le_refl _, at_m.trans at_a.symm⟩
      | .inr mem => Or.inr (Or.inr ⟨m, Nat.le_succ_of_le le_m, at_m, fun n le other =>
          match le_succ_cases le with
          | .inl le => rest n le other
          | .inr same => by subst same; exact mem⟩)

/-- Pigeonhole with no decidability: a list holding the first `l.length + 1` values of a sequence
holds two of them at one place. -/
theorem revisits_within : ∀ (l : List α) (g : Nat → α), (∀ n, n ≤ l.length → g n ∈ l) →
    ∃ i j, i < j ∧ j ≤ l.length ∧ g i = g j
  | [], _, held => nomatch held 0 (Nat.le_refl 0)
  | _ :: l, g, held =>
    match split_at_head (l.length + 1) (fun n le => mem_cons_split (held n le)) with
    | .inl found => found
    | .inr (.inl all) =>
      let ⟨i, j, lt, le, same⟩ :=
        revisits_within l g (fun n le => all n (Nat.le_succ_of_le le))
      ⟨i, j, lt, Nat.le_succ_of_le le, same⟩
    | .inr (.inr ⟨m, _, _, rest⟩) =>
      let ⟨i, j, lt, le, same⟩ := revisits_within l (fun n => g (skipAt m n)) (fun n le =>
        rest (skipAt m n) (Nat.le_trans (skipAt_le m n) (Nat.succ_le_succ le)) (skipAt_ne m n))
      ⟨skipAt m i, skipAt m j, skipAt_lt m lt, Nat.le_trans (skipAt_le m j) (Nat.succ_le_succ le),
        same⟩

/-- Where two joined lists are one list with `z` at some place, `z` lies in the first or the second. -/
theorem split_append : ∀ (d₁ : List α) {d₂ e₁ e₂ : List α} {z : α},
    d₁ ++ d₂ = e₁ ++ z :: e₂ →
      (∃ f, d₁ = e₁ ++ z :: f ∧ e₂ = f ++ d₂) ∨ (∃ f, e₁ = d₁ ++ f ∧ d₂ = f ++ z :: e₂)
  | [], _, e₁, _, _, h => .inr ⟨e₁, rfl, h⟩
  | a :: d₁, d₂, [], e₂, z, h => by
    injection h with h₁ h₂
    subst h₁
    exact .inl ⟨d₁, rfl, h₂.symm⟩
  | a :: d₁, d₂, b :: e₁, e₂, z, h => by
    injection h with h₁ h₂
    subst h₁
    match split_append d₁ h₂ with
    | .inl ⟨f, hd, he⟩ => exact .inl ⟨f, congrArg (List.cons _) hd, he⟩
    | .inr ⟨f, he, hd⟩ => exact .inr ⟨f, congrArg (List.cons _) he, hd⟩

/-- A sequence that begins at `x` and goes on with `h`. -/
def prepend (x : α) (h : Nat → α) : Nat → α
  | 0 => x
  | i + 1 => h i

end GrammarLaws

/-! ## Balance (对): a one-to-one pairing conserves count -/

section Balance

variable {α : Type u}

/-- A perfect pairing of the places of two finite lists under `R` (对): the head of the first is
paired with some place of the second, related to it by `R`, and the rest are so paired. It is a
matching under any relation, not continuation (`«续»`): `R` may be any relation of the grammar, and
under the one (`«一»`) a pairing is equal count. -/
inductive «对» (R : «际» α) : List α → List α → Prop
  | nil : «对» R [] []
  | cons {x y : α} {a b₁ b₂ : List α} : R x y → «对» R a (b₁ ++ b₂) → «对» R (x :: a) (b₁ ++ y :: b₂)

/-- **A one-to-one pairing conserves count.** -/
theorem «对之长» {R : «际» α} {a b : List α} (h : «对» R a b) : a.length = b.length := by
  induction h with
  | nil => rfl
  | @cons _ y _ b₁ b₂ _ _ ih => exact (congrArg Nat.succ ih).trans (GrammarLaws.length_insert b₁ y b₂).symm

/-- Lists of equal length are paired one to one under the one. -/
theorem «等长则一对» : ∀ (a b : List α), a.length = b.length → «对» «一» a b
  | [], [], _ => .nil
  | [], _ :: _, e => Nat.noConfusion e
  | _ :: _, [], e => Nat.noConfusion e
  | _ :: a, _ :: b, e => .cons (b₁ := []) trivial («等长则一对» a b (Nat.succ.inj e))

/-- **Under the one, a one-to-one pairing is exactly equal count.** -/
theorem «一之对» {a b : List α} : «对» «一» a b ↔ a.length = b.length :=
  ⟨«对之长», «等长则一对» a b⟩

/-- A larger relation pairs whatever a smaller one pairs. -/
theorem «对之单调» {R S : «际» α} (h : «则» R S) {a b : List α} (m : «对» R a b) : «对» S a b := by
  induction m with
  | nil => exact .nil
  | cons r _ ih => exact .cons (h _ _ r) ih

/-- Under a reflexive relation every list is paired with itself. -/
theorem «对之自反» {R : «际» α} (refl : ∀ x, R x x) : ∀ a : List α, «对» R a a
  | [] => .nil
  | x :: a => .cons (b₁ := []) (refl x) («对之自反» refl a)

/-- A pair can be put at any place of the first list. -/
theorem «对之左插» {S : «际» α} {y x : α} (r : S y x) :
    ∀ (l₁ : List α) {l₂ m : List α}, «对» S (l₁ ++ l₂) m → «对» S (l₁ ++ y :: l₂) (x :: m)
  | [], _, _, h => .cons (b₁ := []) r h
  | _ :: l₁, _, _, h => match h with
    | .cons (b₁ := m₁) rz rest => .cons (b₁ := x :: m₁) rz («对之左插» r l₁ rest)

/-- **A one-to-one pairing read backward is one** under the converse. -/
theorem «对之逆» {R : «际» α} {a b : List α} (h : «对» R a b) : «对» («逆» R) b a := by
  induction h with
  | nil => exact .nil
  | @cons x y _ b₁ _ r _ ih => exact «对之左插» (S := «逆» R) (y := y) (x := x) r b₁ ih

/-- **The balance reading.** What comes in (before, given), paired one to one with what goes on
(after, taken), has as many after and taken as before and given. -/
theorem «对则守数» {R : «际» α} {before given after taken : List α}
    (h : «对» R (before ++ given) (after ++ taken)) :
    after.length + taken.length = before.length + given.length :=
  (ListTests.length_append after taken).symm.trans
    ((«对之长» h).symm.trans (ListTests.length_append before given))

/-- **And every four numbers with that equation are realized**: four lists of units with those
lengths, the first two paired one to one, under the one, with the last two. -/
theorem «守数当且仅当可对» {p q r s : Nat} :
    r + s = p + q ↔ ∃ before given after taken : List Unit,
      before.length = p ∧ given.length = q ∧ after.length = r ∧ taken.length = s ∧
        «对» «一» (before ++ given) (after ++ taken) :=
  ⟨fun e => ⟨List.replicate p (), List.replicate q (), List.replicate r (), List.replicate s (),
      GrammarLaws.length_replicate () p, GrammarLaws.length_replicate () q,
      GrammarLaws.length_replicate () r, GrammarLaws.length_replicate () s,
      «一之对».mpr ((ListTests.length_append _ _).trans
        ((Naturals.add_congr (GrammarLaws.length_replicate () p) (GrammarLaws.length_replicate () q)).trans
          (e.symm.trans ((Naturals.add_congr (GrammarLaws.length_replicate () r)
            (GrammarLaws.length_replicate () s)).symm.trans (ListTests.length_append _ _).symm))))⟩,
   fun ⟨_, _, _, _, hb, hg, ha, ht, h⟩ => by
     have conserved := «对则守数» h
     subst hb hg ha ht
     exact conserved⟩

/-- **Equal count without a pairing**: under the empty relation two one-place lists have one length
and no pairing. So for an arbitrary relation a pairing gives equal count and not conversely. -/
theorem «等长而不对之例» : ∃ (R : «际» Unit) (a b : List Unit), a.length = b.length ∧ ¬ «对» R a b :=
  have empty : ∀ {a b : List Unit}, «对» (fun _ _ => False) a b → a = [] := fun h => by
    induction h with
    | nil => rfl
    | cons r _ _ => exact r.elim
  ⟨fun _ _ => False, [()], [()], rfl, fun h => nomatch empty h⟩

/-- A pairing with `y` at some place of the first list pairs `y` with some place of the second, and
the rest with the rest. -/
theorem «对之取» {S : «际» α} {l c : List α} (h : «对» S l c) :
    ∀ (b₁ : List α) {y : α} {b₂ : List α}, l = b₁ ++ y :: b₂ →
      ∃ c₁ z c₂, c = c₁ ++ z :: c₂ ∧ S y z ∧ «对» S (b₁ ++ b₂) (c₁ ++ c₂) := by
  induction h with
  | nil =>
    intro b₁ y b₂ e
    cases b₁ with
    | nil => cases e
    | cons _ _ => cases e
  | @cons x v a d₁ d₂ r rest ih =>
    intro b₁ y b₂ e
    cases b₁ with
    | nil =>
      injection e with e₁ e₂
      subst e₁
      subst e₂
      exact ⟨d₁, v, d₂, rfl, r, rest⟩
    | cons w b₁' =>
      injection e with e₁ e₂
      subst e₁
      obtain ⟨e₁', z, e₂', same, s, m⟩ := ih b₁' e₂
      cases GrammarLaws.split_append d₁ same with
      | inl hf =>
        obtain ⟨f, hd, he⟩ := hf
        subst hd
        subst he
        refine ⟨e₁', z, f ++ v :: d₂, ListTests.append_assoc e₁' (z :: f) (v :: d₂), s, ?_⟩
        have m' : «对» S (b₁' ++ b₂) ((e₁' ++ f) ++ d₂) :=
          Eq.subst (motive := fun l => «对» S (b₁' ++ b₂) l) (ListTests.append_assoc e₁' f d₂).symm m
        exact Eq.subst (motive := fun l => «对» S (x :: (b₁' ++ b₂)) l)
          (ListTests.append_assoc e₁' f (v :: d₂)) («对».cons (b₁ := e₁' ++ f) (b₂ := d₂) r m')
      | inr hf =>
        obtain ⟨f, he, hd⟩ := hf
        subst he
        subst hd
        refine ⟨d₁ ++ v :: f, z, e₂', (ListTests.append_assoc d₁ (v :: f) (z :: e₂')).symm, s, ?_⟩
        have m' : «对» S (b₁' ++ b₂) (d₁ ++ (f ++ e₂')) :=
          Eq.subst (motive := fun l => «对» S (b₁' ++ b₂) l) (ListTests.append_assoc d₁ f e₂') m
        exact Eq.subst (motive := fun l => «对» S (x :: (b₁' ++ b₂)) l)
          (ListTests.append_assoc d₁ (v :: f) e₂').symm («对».cons (b₁ := d₁) (b₂ := f ++ e₂') r m')

/-- **One-to-one pairings compose**: a pairing of `a` with `b` under `R` and of `b` with `c` under
`S` give one of `a` with `c` under `R` then `S` (`«而» R S`). -/
theorem «对之接» {R S : «际» α} {a b : List α} (h : «对» R a b) :
    ∀ {c : List α}, «对» S b c → «对» («而» R S) a c := by
  induction h with
  | nil =>
    intro c h'
    cases h'
    exact .nil
  | @cons x y a b₁ b₂ r rest ih =>
    intro c h'
    obtain ⟨c₁, z, c₂, e, s, m⟩ := «对之取» h' b₁ rfl
    subst e
    exact .cons ⟨y, r, s⟩ (ih m)

/-- Under a transitive relation, pairings compose under the relation itself. -/
theorem «对之传» {T : «际» α} (trans : ∀ x y z, T x y → T y z → T x z) {a b c : List α}
    (h : «对» T a b) (h' : «对» T b c) : «对» T a c :=
  «对之单调» (fun _ _ ⟨_, first, second⟩ => trans _ _ _ first second) («对之接» h h')

/-- **One-to-one pairings join**: pairings of `a₁` with `b₁` and of `a₂` with `b₂` give one of the
joined lists. -/
theorem «对之并» {R : «际» α} {a₁ b₁ : List α} (h₁ : «对» R a₁ b₁) :
    ∀ {a₂ b₂ : List α}, «对» R a₂ b₂ → «对» R (a₁ ++ a₂) (b₁ ++ b₂) := by
  induction h₁ with
  | nil => intro a₂ b₂ h₂; exact h₂
  | @cons x y a c₁ c₂ r rest ih =>
    intro a₂ b₂ h₂
    have m : «对» R (a ++ a₂) (c₁ ++ (c₂ ++ b₂)) :=
      Eq.subst (motive := fun l => «对» R (a ++ a₂) l) (ListTests.append_assoc c₁ c₂ b₂) (ih h₂)
    exact Eq.subst (motive := fun l => «对» R (x :: (a ++ a₂)) l)
      (ListTests.append_assoc c₁ (y :: c₂) b₂).symm («对».cons (b₁ := c₁) (b₂ := c₂ ++ b₂) r m)

/-- Under a reflexive relation, two joined lists are paired with the same lists joined the other way
round. -/
theorem «对之换» {R : «际» α} (refl : ∀ x, R x x) : ∀ (a b : List α), «对» R (a ++ b) (b ++ a)
  | [], b => Eq.subst (motive := fun l => «对» R b l) (ListTests.append_nil b).symm («对之自反» refl b)
  | x :: a, b => «对».cons (b₁ := b) (b₂ := a) (refl x) («对之换» refl a b)

/-- Lists gathered along a list of indices (聚): the list of each index in turn, joined. -/
def «聚» {ι : Type v} (f : ι → List α) : List ι → List α
  | [] => []
  | i :: is => f i ++ «聚» f is

/-- **Balance over a family**: pairings at every listed index give one of the gathered lists. -/
theorem «对之族» {ι : Type v} {R : «际» α} {a b : ι → List α} :
    ∀ (is : List ι), (∀ i, i ∈ is → «对» R (a i) (b i)) → «对» R («聚» a is) («聚» b is)
  | [], _ => .nil
  | i :: is, each => «对之并» (each i (.head is)) («对之族» is fun j mem => each j (.tail i mem))

/-- **Balance over a stretch**: where, at each step of a stretch, what stands before with what is
given is paired under `R` with what stands after with what is taken, what stands before the
stretch with everything given along it is paired, under the closure of `R` (`«所闭» R`), with what
stands after it with everything taken along it. A unit that stays several steps is paired through
several steps of `R`, so the stretch's relation is the closure. -/
theorem «对之程» {R : «际» α} {L G K : Nat → List α} :
    ∀ (S n : Nat), (∀ t, S ≤ t → t < S + n → «对» R (L t ++ G t) (L (t + 1) ++ K t)) →
      «对» («所闭» R) (L S ++ «聚» G (steps S n)) (L (S + n) ++ «聚» K (steps S n))
  | S, 0, _ => «对之自反» («所闭之自反» R) _
  | S, n + 1, across => by
    have refl : ∀ x, «所闭» R x x := «所闭之自反» R
    have trans : ∀ x y z, «所闭» R x y → «所闭» R y z → «所闭» R x z := fun _ _ _ h h' => «所闭之传递» h h'
    have first : «对» («所闭» R) (L S ++ G S) (L (S + 1) ++ K S) :=
      «对之单调» (fun _ _ r => «缘在所闭» r)
        (across S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos n)))
    have rest : «对» («所闭» R) (L (S + 1) ++ «聚» G (steps (S + 1) n))
        (L (S + 1 + n) ++ «聚» K (steps (S + 1) n)) :=
      «对之程» (S + 1) n fun t from_ below => across t (Nat.le_of_succ_le from_)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 n)))
    have a : «对» («所闭» R) (L S ++ (G S ++ «聚» G (steps (S + 1) n)))
        (L (S + 1) ++ (K S ++ «聚» G (steps (S + 1) n))) := by
      rw [← ListTests.append_assoc, ← ListTests.append_assoc]
      exact «对之并» first («对之自反» refl _)
    have b : «对» («所闭» R) (L (S + 1) ++ (K S ++ «聚» G (steps (S + 1) n)))
        ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S) := by
      rw [ListTests.append_assoc]
      exact «对之并» («对之自反» refl _) («对之换» refl _ _)
    have c : «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S)
        (L (S + 1 + n) ++ (K S ++ «聚» K (steps (S + 1) n))) := by
      have d := «对之并» rest («对之自反» refl (K S))
      have d' : «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S)
          (L (S + 1 + n) ++ («聚» K (steps (S + 1) n) ++ K S)) :=
        Eq.subst (motive := fun l => «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S) l)
          (ListTests.append_assoc _ _ _) d
      exact «对之传» trans d' («对之并» («对之自反» refl _) («对之换» refl _ _))
    have e : S + 1 + n = S + (n + 1) := Nat.add_right_comm S 1 n
    rw [e] at c
    exact «对之传» trans a («对之传» trans b c)

/-- The length of gathered lists is the total of their lengths. -/
theorem «聚之长» {ι : Type} (f : ι → List α) : ∀ is : List ι,
    («聚» f is).length = total is fun i => (f i).length
  | [] => rfl
  | i :: is => (ListTests.length_append _ _).trans (congrArg ((f i).length + ·) («聚之长» f is))

/-- Quantities that agree everywhere have the same total: proved here, below the frame, for the
pairing laws; `Becoming.total_congr` (in `Becoming.Flow`) is this. -/
theorem GrammarLaws.total_congr {ι : Type} {p q : ι → Nat} (same : ∀ i, p i = q i) :
    ∀ is : List ι, total is p = total is q
  | [] => rfl
  | i :: is => Naturals.add_congr (same i) (GrammarLaws.total_congr same is)

/-- **The count law over a stretch is pairing over the stretch**, both ways: a count that, at the
end of a stretch with everything lost along it, is the count at its start with everything gained
(`balance_over_stretch_on`'s conclusion) is exactly one whose units, before with those gained,
are paired under the one with its units after with those lost. An exact cardinality
representation: the pairing is built from the numbers. -/
theorem «程守数当且仅当可对» {q x y : Nat → Nat} {S n : Nat} :
    q (S + n) + total (steps S n) x = q S + total (steps S n) y ↔
      ∃ (level lost gained : Nat → List Unit),
        (∀ t, (level t).length = q t) ∧ (∀ t, (lost t).length = x t) ∧
          (∀ t, (gained t).length = y t) ∧
            «对» «一» (level S ++ «聚» gained (steps S n)) (level (S + n) ++ «聚» lost (steps S n)) :=
  have lengths : ∀ (level lost gained : Nat → List Unit), (∀ t, (level t).length = q t) →
      (∀ t, (lost t).length = x t) → (∀ t, (gained t).length = y t) →
        (level S ++ «聚» gained (steps S n)).length = q S + total (steps S n) y ∧
          (level (S + n) ++ «聚» lost (steps S n)).length = q (S + n) + total (steps S n) x :=
    fun _ lost gained hl hx hy =>
      ⟨(ListTests.length_append _ _).trans (Naturals.add_congr (hl S)
          ((«聚之长» gained _).trans (GrammarLaws.total_congr hy _))),
       (ListTests.length_append _ _).trans (Naturals.add_congr (hl (S + n))
          ((«聚之长» lost _).trans (GrammarLaws.total_congr hx _)))⟩
  ⟨fun e => ⟨fun t => List.replicate (q t) (), fun t => List.replicate (x t) (),
      fun t => List.replicate (y t) (), fun _ => GrammarLaws.length_replicate () _,
      fun _ => GrammarLaws.length_replicate () _, fun _ => GrammarLaws.length_replicate () _,
      «一之对».mpr (match lengths _ _ _ (fun _ => GrammarLaws.length_replicate () _)
        (fun _ => GrammarLaws.length_replicate () _) (fun _ => GrammarLaws.length_replicate () _) with
        | ⟨before, after⟩ => before.trans (e.symm.trans after.symm))⟩,
   fun ⟨level, lost, gained, hl, hx, hy, h⟩ => match lengths level lost gained hl hx hy with
    | ⟨before, after⟩ => after.symm.trans ((«对之长» h).symm.trans before)⟩

end Balance

/-! ## Finite runs (入) -/

section Runs

variable {α : Type u}

/-- The successor is fixed (定后): `R˘;R ⊆ 静`. -/
def «定后» (R : «际» α) : Prop := «则» («而» («逆» R) R) «静»

/-- The predecessor is fixed (定前), nothing merged: `R;R˘ ⊆ 静`. -/
def «定前» (R : «际» α) : Prop := «则» («而» R («逆» R)) «静»

theorem «定后之逐点» {R : «际» α} : «定后» R ↔ ∀ x y z, R x y → R x z → y = z :=
  ⟨fun h x y z r r' => h y z ⟨x, r, r'⟩, fun h y z ⟨x, r, r'⟩ => h x y z r r'⟩

theorem «定前之逐点» {R : «际» α} : «定前» R ↔ ∀ x y z, R x z → R y z → x = y :=
  ⟨fun h x y z r r' => h x y ⟨z, r, r'⟩, fun h x y ⟨z, r, r'⟩ => h x y z r r'⟩

/-- Nothing merged is a fixed successor read backward. -/
theorem «定前即逆之定后» {R : «际» α} : «定前» R ↔ «定后» («逆» R) :=
  ⟨fun h y z ⟨x, r, r'⟩ => h y z ⟨x, r, r'⟩, fun h x y ⟨z, r, r'⟩ => h x y ⟨z, r, r'⟩⟩

/-- `n` steps (迭): the `n`-fold composition of `R`, the first step first. -/
def «迭» (R : «际» α) : Nat → «际» α
  | 0 => «静»
  | n + 1 => «而» R («迭» R n)

/-- `n + 1` steps reach. -/
theorem «迭则及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R (n + 1) x y → «及» R x y
  | 0, _, _, ⟨_, r, e⟩ => by cases e; exact .one r
  | n + 1, _, _, ⟨_, r, rest⟩ => .more r («迭则及» n rest)

/-- **Reaching is some positive number of steps.** -/
theorem «及即迭» {R : «际» α} {x y : α} : «及» R x y ↔ ∃ n, «迭» R (n + 1) x y :=
  ⟨fun reach => by
    induction reach with
    | one r => exact ⟨0, _, r, rfl⟩
    | more r _ ih => exact match ih with
      | ⟨n, rest⟩ => ⟨n + 1, _, r, rest⟩,
   fun ⟨n, steps⟩ => «迭则及» n steps⟩

/-- Steps compose: `a` steps, then `b` steps, are `b + a` steps. -/
theorem «迭之接» {R : «际» α} : ∀ (a b : Nat) {x y z : α}, «迭» R a x y → «迭» R b y z → «迭» R (b + a) x z
  | 0, _, _, _, _, e, rest => by cases e; exact rest
  | a + 1, b, _, _, _, ⟨_, r, first⟩, rest => ⟨_, r, «迭之接» a b first rest⟩

/-- A loop of `p` steps is a loop of every multiple of `p` steps. -/
theorem «迭之周» {R : «际» α} {p : Nat} {x : α} (loop : «迭» R p x x) : ∀ k, «迭» R (p * k) x x
  | 0 => rfl
  | k + 1 => «迭之接» p (p * k) loop («迭之周» loop k)

/-- The successor is fixed at what `x` reaches (定后于): two successors of one occurrence within
`x`'s closure are one. It is `«定后»` read within `«所闭» R x` only, and the laws of return below
use a fixed successor only there. -/
def «定后于» (R : «际» α) (x : α) : Prop := ∀ a, «所闭» R x a → ∀ b c, R a b → R a c → b = c

/-- A fixed successor is fixed at what every occurrence reaches. -/
theorem «定后则定后于» {R : «际» α} (fixed : «定后» R) (x : α) : «定后于» R x :=
  fun _ _ b c r r' => fixed b c ⟨_, r, r'⟩

/-- Fixed at what `x` reaches, the successor is fixed at what anything within `x`'s closure reaches. -/
theorem «定后于之后» {R : «际» α} {x y : α} (fixed : «定后于» R x) (within : «所闭» R x y) :
    «定后于» R y :=
  fun a reach => fixed a («所闭之传递» within reach)

/-- With the successor fixed at what `x` reaches, `n` steps from `x` lead to one occurrence. -/
theorem «迭之定于» {R : «际» α} : ∀ (n : Nat) {x y z : α}, «定后于» R x →
    «迭» R n x y → «迭» R n x z → y = z
  | 0, _, _, _, _, e₁, e₂ => e₁.symm.trans e₂
  | n + 1, x, _, _, fixed, ⟨w, r, first⟩, ⟨w', r', second⟩ => by
    have e : w = w' := fixed x («所闭之自反» R x) w w' r r'
    subst e
    exact «迭之定于» n («定后于之后» fixed («缘在所闭» r)) first second

/-- With a fixed successor, `n` steps lead to one occurrence. -/
theorem «迭之定» {R : «际» α} (fixed : «定后» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x y → «迭» R n x z → y = z
  | n, x, _, _, first, second => «迭之定于» n («定后则定后于» fixed x) first second

/-- **Merging nothing, `n` steps to one occurrence come from one occurrence.** -/
theorem «迭之定前» {R : «际» α} (merges : «定前» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x z → «迭» R n y z → x = y
  | 0, _, _, _, e₁, e₂ => e₁.trans e₂.symm
  | n + 1, x, y, _, ⟨w, r, first⟩, ⟨w', r', second⟩ => by
    have e : w = w' := «迭之定前» merges n first second
    subst e
    exact merges x y ⟨w, r, r'⟩

/-- Drawn in (入): some region closed under `R` that `x` lies outside holds something `x` reaches. -/
def «入» (R : «际» α) (x : α) : Prop := ∃ P : α → Prop, «闭» R P ∧ ¬ P x ∧ ∃ y, «及» R x y ∧ P y

/-- **Drawn in is reaching something that does not reach back**, for every relation. -/
theorem «入当且仅当有不返» {R : «际» α} {x : α} : «入» R x ↔ ∃ y, «及» R x y ∧ ¬ «及» R y x :=
  ⟨fun ⟨_, closed, outside, y, reach, holds⟩ => ⟨y, reach, fun back => outside («闭之及» closed holds back)⟩,
   fun ⟨y, reach, never⟩ => ⟨fun z => y = z ∨ «及» R y z,
     fun a b inside related => match inside with
       | .inl e => .inr (by cases e; exact .one related)
       | .inr l => .inr («及之传递» l (.one related)),
     fun inside => match inside with
       | .inl e => never (by cases e; exact reach)
       | .inr back => never back,
     y, reach, .inl rfl⟩⟩

/-- **With the successor fixed at what `x` reaches, what `x` reaches, where `x` reaches itself,
reaches `x` back.** The occurrences within `x`'s closure that reach `x` form a closed region: the
one successor of such an occurrence is the next place on its way back. -/
theorem «定后于环则所及皆返» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x :=
  («闭之及» (P := fun z => «所闭» R x z ∧ «及» R z x)
    (fun a b inside related => ⟨«所闭之传递» inside.1 («缘在所闭» related),
      match inside.2 with
      | .one r => by
        have e : b = x := fixed a inside.1 b x related r
        cases e; exact loop
      | .more r rest => by
        have e : b = _ := fixed a inside.1 b _ related r
        cases e; exact rest⟩)
    ⟨«所闭之自反» R x, loop⟩ reach).2

/-- With a fixed successor, what an occurrence that reaches itself reaches reaches it back: the
global form of `«定后于环则所及皆返»`. -/
theorem «定后环则所及皆返» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x :=
  «定后于环则所及皆返» («定后则定后于» fixed x) loop reach

/-- **With the successor fixed at what `x` reaches, `x`, reaching itself, is not drawn.** -/
theorem «定后于则返者不入» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) :
    ¬ «入» R x :=
  fun drawn => match «入当且仅当有不返».mp drawn with
    | ⟨_, reach, never⟩ => never («定后于环则所及皆返» fixed loop reach)

/-- **With a fixed successor, an occurrence that reaches itself is not drawn**: the global form. -/
theorem «定后则返者不入» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) : ¬ «入» R x :=
  «定后于则返者不入» («定后则定后于» fixed x) loop

/-- **An occurrence with a successor that does not reach itself is drawn**, for every relation. -/
theorem «有后不返则入» {R : «际» α} {x y : α} (next : R x y) (never : ¬ «及» R x x) : «入» R x :=
  «入当且仅当有不返».mpr ⟨y, .one next, fun back => never (.more next back)⟩

/-- **With the successor fixed at what `x` reaches and some successor, `x` is drawn exactly where it
does not reach itself.** -/
theorem «定后于有后则入当且仅当不返» {R : «际» α} {x : α} (fixed : «定后于» R x)
    (next : ∃ y, R x y) : «入» R x ↔ ¬ «及» R x x :=
  ⟨fun drawn loop => «定后于则返者不入» fixed loop drawn,
   fun never => match next with
    | ⟨_, r⟩ => «有后不返则入» r never⟩

/-- **With a fixed successor and some successor, drawn is not reaching itself**: the global form. -/
theorem «定后有后则入当且仅当不返» {R : «际» α} (fixed : «定后» R) {x : α} (next : ∃ y, R x y) :
    «入» R x ↔ ¬ «及» R x x :=
  «定后于有后则入当且仅当不返» («定后则定后于» fixed x) next

/-- Without a successor an occurrence is neither drawn nor reaches itself: the successor hypothesis
of `«定后有后则入当且仅当不返»` cannot be omitted, since without it the reverse direction fails. -/
theorem «无后者不入亦不返» {R : «际» α} {x : α} (nothing : ∀ y, ¬ R x y) : ¬ «入» R x ∧ ¬ «及» R x x :=
  have first : ∀ {y}, ¬ «及» R x y := fun reach => match reach with
    | .one r => nothing _ r
    | .more r _ => nothing _ r
  ⟨fun ⟨_, _, _, _, reach, _⟩ => first reach, first⟩

/-- **An occurrence both drawn and reaching itself**, under a relation whose successor is not fixed
at what it reaches: `false` conditions itself and `true`, which conditions nothing. So the fixed
successor of `«定后于则返者不入»` cannot be omitted. -/
theorem «入而返之例» : ∃ (R : «际» Bool) (x : Bool), «入» R x ∧ «及» R x x :=
  ⟨fun a _ => a = false, false,
   ⟨fun z => z = true, fun a _ inside related => by cases inside; exact Bool.noConfusion related,
    fun inside => Bool.noConfusion inside, true, .one rfl, rfl⟩,
   .one rfl⟩

/-- **Reaching itself and not drawn, with no fixed successor**: `none` conditions only itself and
`some true` conditions everything, so the successor is not fixed, yet it is fixed at what `none`
reaches, and `none` reaches itself and is not drawn. So a relation with no fixed successor need not
draw what reaches itself, and the global fixed successor of `«定后则返者不入»` is more than the law
uses. -/
theorem «非定后返而不入之例» :
    ∃ (R : «际» (Option Bool)), ¬ «定后» R ∧ «及» R none none ∧ ¬ «入» R none :=
  have stays : ∀ a b : Option Bool, a = none → ((a = none ∧ b = none) ∨ a = some true) → b = none :=
    fun _ _ e r => match r with
      | .inl ⟨_, e'⟩ => e'
      | .inr e' => nomatch e.symm.trans e'
  have only : ∀ a, «所闭» (fun a b : Option Bool => (a = none ∧ b = none) ∨ a = some true) none a →
      a = none :=
    fun _ within => within (fun z => z = none) (fun a b inside r => stays a b inside r) rfl
  ⟨fun a b => (a = none ∧ b = none) ∨ a = some true,
   fun fixed => (nomatch fixed (some false) (some true) ⟨some true, .inr rfl, .inr rfl⟩),
   .one (.inl ⟨rfl, rfl⟩),
   «定后于则返者不入» (fun a within b c r r' =>
      (stays a b (only a within) r).trans (stays a c (only a within) r').symm) (.one (.inl ⟨rfl, rfl⟩))⟩

open GrammarLaws in
/-- Where every occurrence has a successor, a line of every length goes on from every occurrence. -/
theorem «遍后则有线» {R : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ (n : Nat) (x : α), ∃ g : Nat → α, g 0 = x ∧ ∀ i, i < n → R (g i) (g (i + 1))
  | 0, x => ⟨fun _ => x, rfl, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩
  | n + 1, x => match total x with
    | ⟨y, r⟩ => match «遍后则有线» total n y with
      | ⟨h, h0, steps⟩ => ⟨prepend x h, rfl, fun i lt => match i, lt with
        | 0, _ => Eq.subst (motive := fun w => R x w) h0.symm r
        | i + 1, lt => steps i (Nat.lt_of_succ_lt_succ lt)⟩

/-- Merging nothing at the line's places (线不并): two of the first `N` places of the line `g` with a
common successor hold one occurrence. It is `«定前»` read at those places only. -/
def «线不并» (R : «际» α) (g : Nat → α) (N : Nat) : Prop :=
  ∀ i j z, i < N → j < N → R (g i) z → R (g j) z → g i = g j

/-- A relation that merges nothing merges nothing at the places of every line. -/
theorem «定前则线不并» {R : «际» α} (merges : «定前» R) (g : Nat → α) (N : Nat) : «线不并» R g N :=
  fun _ _ z _ _ r r' => merges _ _ ⟨z, r, r'⟩

/-- **Merging nothing at the line's places, where two places of a line hold one occurrence, so do
the places as many before them, back to the first.** -/
theorem «线不并则可退» {R : «际» α} {g : Nat → α} {N : Nat} (merges : «线不并» R g N)
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d
  | 0, d, _, same => same.trans (congrArg g (Nat.zero_add d))
  | i + 1, d, le, same =>
    have shift : i + 1 + d = i + d + 1 := Nat.succ_add i d
    have le' : i + d + 1 ≤ N := Eq.subst (motive := fun k => k ≤ N) shift le
    have back : g (i + d + 1) = g (i + 1) := (congrArg g shift).symm.trans same.symm
    have r' : R (g (i + d)) (g (i + 1)) :=
      Eq.subst (motive := fun w => R (g (i + d)) w) back (steps (i + d) le')
    have lt : i < N := Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right i d)) le'
    «线不并则可退» merges steps i d (Nat.le_of_lt le') (merges i (i + d) _ lt le' (steps i lt) r')

/-- Merging nothing, where two places of a line hold one occurrence, so do the places as many before
them, back to the first: the global form of `«线不并则可退»`. -/
theorem «定前则线可退» {R : «际» α} (merges : «定前» R) {g : Nat → α} {N : Nat}
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d :=
  «线不并则可退» («定前则线不并» merges g N) steps

/-- A line of `k + 1` steps from place `m` reaches. -/
theorem «线则及» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ k m, m + (k + 1) ≤ N → «及» R (g m) (g (m + (k + 1)))
  | 0, m, le => .one (steps m le)
  | k + 1, m, le => «及之传递» («线则及» steps k m (Nat.le_trans (Nat.le_succ _) le))
      (.one (steps (m + (k + 1)) le))

/-- Every place of a line up to its length lies within the closure from its first place. -/
theorem «线则所闭» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ m, m ≤ N → «所闭» R (g 0) (g m)
  | 0, _ => «所闭之自反» R (g 0)
  | m + 1, le => «所闭之传递» («线则所闭» steps m (Nat.le_of_succ_le le)) («缘在所闭» (steps m le))

open GrammarLaws in
/-- **Along a line held by a list, merging nothing at its places, the line comes back to its start**
within as many steps as the list is long: pigeonhole along the line, with no decidability, then back
along it to its first place. Only the line and the list are used: the list need not hold every
occurrence, nothing beyond the line needs a successor, and the relation need merge nothing only at
the line's places. -/
theorem «线有限不并则回» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    ∃ d, 0 < d ∧ d ≤ l.length ∧ g d = g 0 :=
  match revisits_within l g held with
  | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ =>
      have le' : i + (d + 1) ≤ l.length := Eq.subst (motive := fun k => k ≤ l.length) gap le
      ⟨d + 1, Nat.succ_pos d, Nat.le_trans (Nat.le_add_left (d + 1) i) le',
        («线不并则可退» merges steps i (d + 1) le' (same.trans (congrArg g gap))).symm⟩

/-- **Along a line held by a list, merging nothing at its places, the line's start reaches
itself.** -/
theorem «线有限不并则返» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0) :=
  match «线有限不并则回» merges steps held with
  | ⟨0, pos, _, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨d + 1, _, le, back⟩ =>
    Eq.subst (motive := fun w => «及» R (g 0) w) ((congrArg g (Nat.zero_add (d + 1))).trans back)
      («线则及» steps d 0 (Nat.le_trans (Nat.le_of_eq (Nat.zero_add (d + 1))) le))

/-- **Along a line held by a list, merging nothing, the line's start reaches itself**: the global
form of `«线有限不并则返»`. -/
theorem «线有限定前则返» {R : «际» α} {l : List α} (merges : «定前» R) {g : Nat → α}
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0) :=
  «线有限不并则返» («定前则线不并» merges g l.length) steps held

open GrammarLaws in
/-- **Along a line held by a list, with the successor fixed at what its start reaches, the line's
last place reaches itself.** Pigeonhole gives a place the line comes back to; it reaches itself, the
last place lies on its way, and with the successor fixed there what it reaches reaches it back.
Nothing need be unmerged. -/
theorem «定后于线有限则末返» {R : «际» α} {l : List α} {g : Nat → α} (fixed : «定后于» R (g 0))
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g l.length) (g l.length) :=
  match revisits_within l g held with
  | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ =>
      have le' : i + (d + 1) ≤ l.length := Eq.subst (motive := fun k => k ≤ l.length) gap le
      have loop : «及» R (g i) (g i) :=
        Eq.subst (motive := fun w => «及» R (g i) w) ((congrArg g gap).symm.trans same.symm)
          («线则及» steps d i le')
      have fixed_i : «定后于» R (g i) :=
        «定后于之后» fixed («线则所闭» steps i (Nat.le_trans (Nat.le_add_right i (d + 1)) le'))
      match le_dest (Nat.le_trans (Nat.le_add_right i (d + 1)) le') with
      | ⟨0, rest⟩ => Eq.subst (motive := fun w => «及» R w w) (congrArg g rest).symm loop
      | ⟨e + 1, rest⟩ =>
        have reach : «及» R (g i) (g (i + (e + 1))) := «线则及» steps e i (Nat.le_of_eq rest.symm)
        Eq.subst (motive := fun w => «及» R w w) (congrArg g rest).symm
          («及之传递» («定后于环则所及皆返» fixed_i loop reach) reach)

/-- **Within finitely many occurrences, each with a successor, merging nothing, every occurrence
reaches itself.** Where a list holds every occurrence and every occurrence has a successor, a
relation that merges nothing has every occurrence reaching itself: the line law at a line of the
list's length from each occurrence. -/
theorem «有限遍后定前则皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (merges : «定前» R) (x : α) : «及» R x x :=
  match «遍后则有线» total all.length x with
  | ⟨_, g0, steps⟩ =>
    Eq.subst (motive := fun w => «及» R w w) g0 («线有限定前则返» merges steps (fun _ _ => every _))

/-- **Two occurrences that reach themselves, with the successor fixed at what each reaches, have no
common successor unless they are one.** Two loops through one successor have a common multiple of
their lengths, and the steps after the first lead from that successor to each. -/
theorem «定后于二返则不并» {R : «际» α} {x y z : α} (fx : «定后于» R x) (fy : «定后于» R y)
    (loopx : «及» R x x) (loopy : «及» R y y) (rx : R x z) (ry : R y z) : x = y :=
  match «及即迭».mp loopx, «及即迭».mp loopy with
  | ⟨p, hx⟩, ⟨q, hy⟩ =>
    have lx : «迭» R ((p + 1) * q + p + 1) x x := «迭之周» hx (q + 1)
    have ly : «迭» R ((q + 1) * p + q + 1) y y := «迭之周» hy (p + 1)
    have e : (p + 1) * q + p = (q + 1) * p + q := Nat.succ.inj (Nat.mul_comm (p + 1) (q + 1))
    match lx, ly with
    | ⟨w, rxw, restx⟩, ⟨w', ryw, resty⟩ =>
      have tox : «迭» R ((p + 1) * q + p) z x :=
        Eq.subst (motive := fun v => «迭» R _ v x) (fx x («所闭之自反» R x) w z rxw rx) restx
      have toy : «迭» R ((p + 1) * q + p) z y :=
        Eq.subst (motive := fun k => «迭» R k z y) e.symm
          (Eq.subst (motive := fun v => «迭» R _ v y) (fy y («所闭之自反» R y) w' z ryw ry) resty)
      «迭之定于» _ («定后于之后» fx («缘在所闭» rx)) tox toy

/-- **With a fixed successor, every occurrence reaching itself, nothing is merged**: the global form
of `«定后于二返则不并»`. -/
theorem «皆返定后则定前» {R : «际» α} (fixed : «定后» R) (loops : ∀ x, «及» R x x) : «定前» R :=
  fun x y ⟨_, rx, ry⟩ =>
    «定后于二返则不并» («定后则定后于» fixed x) («定后则定后于» fixed y) (loops x) (loops y) rx ry

/-- **Within finitely many occurrences, each with a successor, under a fixed successor, merging
nothing is every occurrence reaching itself.** -/
theorem «有限遍后定后则定前当且仅当皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (fixed : «定后» R) : «定前» R ↔ ∀ x, «及» R x x :=
  ⟨fun merges => «有限遍后定前则皆返» every total merges, «皆返定后则定前» fixed⟩

/-! ### Rest (止): falls that end

A line `g` whose steps from `T` on are steps of `Q` (no rise, say) is at rest where its steps of `F`
(a least fall, say) do not recur. Rest is a case of ending (`«尽»`, which `Becoming.GrammarMap`
reads as degeneration, `«退化»`): where every course of `Q` steps then an `F` step ends from the
line's place at `T`, the `F` steps along the line do not recur. It is not a case of being drawn in
(`«入»`): a place at rest need not be drawn, and a place drawn in need not come to rest. -/

/-- Steps of `F` recur along the line `g` (屡): after every place, a later step of `g` is one of `F`. -/
def «屡» (F : «际» α) (g : Nat → α) : Prop := ∀ N, ∃ t, N ≤ t ∧ F (g t) (g (t + 1))

/-- Steps of `F` recur along `g` from `T` on, as far as can be refuted (或屡): after every place from
`T` on, a later step of `F` is not refuted. -/
def «或屡» (F : «际» α) (g : Nat → α) (T : Nat) : Prop :=
  ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ F (g t) (g (t + 1))

/-- What recurs recurs as far as can be refuted. -/
theorem «屡则或屡» {F : «际» α} {g : Nat → α} (recurs : «屡» F g) (T : Nat) : «或屡» F g T :=
  fun N _ no => no (recurs N)

/-- Where the steps of a line from `T` on are, as far as can be refuted, steps of `Q`, each later
place lies, as far as can be refuted, within `Q`'s closure from the place at `T`. -/
theorem «线或在所闭» {Q : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) : ∀ k, ¬¬ «所闭» Q (g T) (g (T + k))
  | 0, no => no («所闭之自反» Q (g T))
  | k + 1, no => «线或在所闭» still k fun within =>
      still (T + k) (Nat.le_add_right T k) fun step => no («所闭之传递» within («缘在所闭» step))

/-- **Falls that end do not recur** (尽则不或屡). Where the steps of a line from `T` on are steps of
`Q`, each as far as can be refuted, and every course of `Q` steps then an `F` step ends from the
line's place at `T` (`«尽» («而» («所闭» Q) F) «一»`), it is not the case that the line's `F` steps
stay unrefuted after every place from `T` on. No decision and no choice is used: the ending is
inductive, and each `F` step found is one step further along a course that ends. -/
theorem «尽则不或屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «或屡» F g T :=
  have key : ∀ {x : α}, «尽» («而» («所闭» Q) F) «一» x → ∀ T, g T = x →
      (∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) → ¬ «或屡» F g T := by
    intro x ends
    induction ends with
    | mk _ ih =>
      intro T at_x still recurs
      exact recurs T (Nat.le_refl T) fun ⟨t, later, fall⟩ =>
        match le_dest later with
        | ⟨k, gap⟩ => «线或在所闭» still k fun within =>
          ih (g (t + 1)) ⟨⟨g t, Eq.subst (motive := fun w => «所闭» Q w (g t)) at_x
              (Eq.subst (motive := fun u => «所闭» Q (g T) (g u)) gap.symm within), fall⟩, trivial⟩
            (t + 1) rfl (fun u from_ => still u (Nat.le_trans later (Nat.le_of_succ_le from_)))
            (fun N from_ => recurs N (Nat.le_trans later (Nat.le_of_succ_le from_)))
  key ends T rfl still

/-- **Falls that end, outright, do not recur.** -/
theorem «尽则不屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «屡» F g :=
  fun recurs => «尽则不或屡» (fun t later no => no (still t later)) ends («屡则或屡» recurs T)

/-- **At rest and not drawn in**: on one occurrence that conditions itself, with no `F` step, the
constant line is at rest (its falls end and do not recur) and its place is not drawn in. A fixed
point is at rest without being drawn, so rest is not a case of `«入»`. -/
theorem «止而不入之例» : ∃ (Q F : «际» Unit) (g : Nat → Unit),
    (∀ t, Q (g t) (g (t + 1))) ∧ «尽» («而» («所闭» Q) F) «一» (g 0) ∧ ¬ «屡» F g ∧ ¬ «入» Q (g 0) :=
  have ends : «尽» («而» («所闭» («静» : «际» Unit)) (fun _ _ => False)) «一» () :=
    .mk fun _ ⟨⟨_, _, fall⟩, _⟩ => fall.elim
  ⟨«静», fun _ _ => False, fun _ => (), fun _ => rfl, ends,
   «尽则不屡» (T := 0) (fun _ _ => rfl) ends,
   «定后则返者不入» (fun _ _ ⟨_, e₁, e₂⟩ => e₁.symm.trans e₂) (.one rfl)⟩

/-- **Drawn in and not at rest**: along the successor on the whole numbers every step is an `F`
step, so the `F` steps recur, and `0` is drawn in, since what it reaches never reaches back. Being
drawn does not bring rest. -/
theorem «入而屡之例» : ∃ (Q F : «际» Nat) (g : Nat → Nat),
    (∀ t, Q (g t) (g (t + 1))) ∧ «屡» F g ∧ «入» Q (g 0) :=
  have up : ∀ {a b : Nat}, «及» (fun a b : Nat => b = a + 1) a b → a < b := fun reach => by
    induction reach with
    | one e => cases e; exact Nat.lt_succ_self _
    | more e _ ih => cases e; exact Nat.lt_trans (Nat.lt_succ_self _) ih
  ⟨fun a b => b = a + 1, fun a b => b = a + 1, fun t => t, fun _ => rfl,
   fun N => ⟨N, Nat.le_refl N, rfl⟩,
   «有后不返则入» (y := 1) rfl fun loop => Nat.lt_irrefl 0 (up loop)⟩

end Runs

/-! ## Lumping (同行) -/

section Lumping

variable {α : Type u}

/-- `E` goes alike under `R` (同行): `R˘;E;R ⊆ E`. -/
def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E

/-- The pointwise form: what `E` relates goes, by `R`, to what `E` relates. -/
theorem «同行之逐点» {R E : «际» α} :
    «同行» R E ↔ ∀ x x', E x x' → ∀ y y', R x y → R x' y' → E y y' :=
  ⟨fun h x x' e y y' r r' => h y y' ⟨x', ⟨x, r, e⟩, r'⟩,
   fun h y y' ⟨x', ⟨x, r, e⟩, r'⟩ => h x x' e y y' r r'⟩

/-- **Constancy, its successor fixed where `E` leads, is going alike.** The successor need be fixed
only at the occurrences `E` relates something to. -/
theorem «有常局定后则同行» {R E : «际» α} (constant : «有常» R E)
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E :=
  «同行之逐点».mpr fun x x' e y y' r r' =>
    match («有常之逐点» R E).mp constant x x' e y r with
    | ⟨v, rv, ev⟩ => by
      have same : v = y' := fixed x x' e v y' rv r'
      subst same
      exact ev

/-- **With a fixed successor, constancy is going alike.** -/
theorem «有常定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : «定后» R) : «同行» R E :=
  «有常局定后则同行» constant fun _ x' _ v w rv rw => fixed v w ⟨x', rv, rw⟩

/-- **Constancy gives a successor where `E` leads from one that has one.** -/
theorem «有常则可续» {R E : «际» α} (constant : «有常» R E) :
    ∀ u u' v, E u u' → R u v → ∃ v', R u' v' :=
  fun u u' v e r => match («有常之逐点» R E).mp constant u u' e v r with
    | ⟨v', r', _⟩ => ⟨v', r'⟩

/-- **Going alike, with a successor where `E` leads from one that has one, is constancy.** The
successor is needed only there; the hypothesis is necessary, since constancy gives it
(`«有常则可续»`). -/
theorem «同行可续则有常» {R E : «际» α} (alike : «同行» R E)
    (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E :=
  («有常之逐点» R E).mpr fun u u' e v r =>
    match onward u u' v e r with
    | ⟨v', r'⟩ => ⟨v', r', «同行之逐点».mp alike u u' e v v' r r'⟩

/-- **Where every occurrence has a successor, going alike is constancy.** -/
theorem «同行遍后则有常» {R E : «际» α} (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «有常» R E :=
  «同行可续则有常» alike fun _ u' _ _ _ => total u'

/-- **With the successor fixed where `E` leads, constancy is going alike with a successor where `E`
leads from one that has one.** The exact gap between the two: availability. -/
theorem «局定后则有常当且仅当同行可续» {R E : «际» α}
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) :
    «有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v' :=
  ⟨fun constant => ⟨«有常局定后则同行» constant fixed, «有常则可续» constant⟩,
   fun ⟨alike, onward⟩ => «同行可续则有常» alike onward⟩

/-- With a fixed successor that every occurrence has, going alike and constancy are one. -/
theorem «同行当且仅当有常» {R E : «际» α} (fixed : «定后» R) (total : ∀ x, ∃ y, R x y) :
    «同行» R E ↔ «有常» R E :=
  ⟨fun alike => «同行遍后则有常» alike total, fun constant => «有常定后则同行» constant fixed⟩

/-- For a class going alike under a relation every occurrence of which has a successor, the class
lies inside its own core. -/
theorem «类同行遍后则含于核» {R E : «际» α} (hE : «类» E) (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) :
    «则» E («核» R E) :=
  («类有常当且仅当含于核» R hE).mp («同行遍后则有常» alike total)

/-- **Going alike keeps lines of every length alike**: `E`-alike occurrences go, by `n` steps, to
`E`-alike occurrences. -/
theorem «同行之迭» {R E : «际» α} (alike : «同行» R E) :
    ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'
  | 0, _, _, _, _, e, e₁, e₂ => by cases e₁; cases e₂; exact e
  | n + 1, x, x', _, _, e, ⟨w, r, first⟩, ⟨w', r', second⟩ =>
    «同行之迭» alike n («同行之逐点».mp alike x x' e w w' r r') first second

/-- So `E` goes alike under every number of steps. -/
theorem «同行于迭» {R E : «际» α} (alike : «同行» R E) (n : Nat) : «同行» («迭» R n) E :=
  «同行之逐点».mpr fun _ _ e _ _ first second => «同行之迭» alike n e first second

variable {κ : Type v}

/-- The image of a relation along a map (像): `k` conditions `k'` where something read as `k`
conditions something read as `k'`. -/
def «像» (π : α → κ) (R : «际» α) : «际» κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'

/-- **The image along a map has a fixed successor exactly where sameness under the map goes
alike.** The read-alone part carries a law, possibly partial (nothing is said about a successor
existing), exactly where what the map leaves out makes no difference to where it goes. -/
theorem «像定后当且仅当同行» {π : α → κ} {R : «际» α} :
    «定后» («像» π R) ↔ «同行» R (fun s s' => π s = π s') :=
  ⟨fun fixed => «同行之逐点».mpr fun s s' e u u' r r' =>
      fixed (π u) (π u') ⟨π s, ⟨s, u, rfl, r, rfl⟩, ⟨s', u', e.symm, r', rfl⟩⟩,
   fun alike _ _ ⟨_, ⟨s, u, at_k, r, to⟩, ⟨s', u', at_k', r', to'⟩⟩ =>
    to.symm.trans ((«同行之逐点».mp alike s s' (at_k.trans at_k'.symm) u u' r r').trans to')⟩

end Lumping

/-! ## Order (广) -/

section Order

variable {α : Type u}

/-- `R` exceeds `S` (逾): it relates something `S` does not. -/
def «逾» (R S : «际» α) : Prop := ∃ x y, R x y ∧ ¬ S x y

/-- `R` widens `S` (广): it relates whatever `S` relates and exceeds it. -/
def «广» (R S : «际» α) : Prop := «则» S R ∧ «逾» R S

/-- `R` and `S` keep the same (齐): each relates whatever the other relates. -/
def «齐» (R S : «际» α) : Prop := «则» R S ∧ «则» S R

/-- `R` and `S` are mixed (杂): each exceeds the other. -/
def «杂» (R S : «际» α) : Prop := «逾» R S ∧ «逾» S R

/-- What exceeds is not included. -/
theorem «逾则不则» {R S : «际» α} (h : «逾» R S) : ¬ «则» R S :=
  fun inside => match h with
    | ⟨x, y, r, not⟩ => not (inside x y r)

/-- Widening includes and is not included: the inclusion-only form follows. -/
theorem «广则不则» {R S : «际» α} (h : «广» R S) : «则» S R ∧ ¬ «则» R S :=
  ⟨h.1, «逾则不则» h.2⟩

/-- **Nothing widens itself.** -/
theorem «广非自» (R : «际» α) : ¬ «广» R R :=
  fun h => «逾则不则» h.2 («则之自反» R)

/-- **Widening goes one way.** -/
theorem «广不可逆» {R S : «际» α} (h : «广» R S) : ¬ «广» S R :=
  fun back => «逾则不则» back.2 h.1

/-- **Widening is transitive.** -/
theorem «广之传递» {R S T : «际» α} (h₁ : «广» R S) (h₂ : «广» S T) : «广» R T :=
  ⟨«则之传递» h₂.1 h₁.1, match h₁.2 with
    | ⟨x, y, r, not⟩ => ⟨x, y, r, fun t => not (h₂.1 x y t)⟩⟩

/-- Keeping the same is pointwise equivalence. -/
theorem «齐即谓» {R S : «际» α} : «齐» R S ↔ «谓» R S :=
  ⟨fun ⟨h₁, h₂⟩ x y => ⟨h₁ x y, h₂ x y⟩, fun h => ⟨fun x y => (h x y).mp, fun x y => (h x y).mpr⟩⟩

theorem «齐之对称» {R S : «际» α} (h : «齐» R S) : «齐» S R := ⟨h.2, h.1⟩

theorem «杂之对称» {R S : «际» α} (h : «杂» R S) : «杂» S R := ⟨h.2, h.1⟩

/-- Widening is not keeping the same. -/
theorem «广则非齐» {R S : «际» α} (h : «广» R S) : ¬ «齐» R S :=
  fun keeps => «逾则不则» h.2 keeps.1

/-- Widening is not mixed. -/
theorem «广则非杂» {R S : «际» α} (h : «广» R S) : ¬ «杂» R S :=
  fun mixed => «逾则不则» mixed.2 h.1

/-- Keeping the same is not mixed. -/
theorem «齐则非杂» {R S : «际» α} (h : «齐» R S) : ¬ «杂» R S :=
  fun mixed => «逾则不则» mixed.1 h.1

/-- **The four cases.** Where inclusion or exceeding is decided both ways, `R` widens `S`, `S`
widens `R`, they keep the same, or they are mixed; by the theorems above, exactly one. -/
theorem «四比之周» {R S : «际» α} (one : «则» R S ∨ «逾» R S) (other : «则» S R ∨ «逾» S R) :
    «广» R S ∨ «广» S R ∨ «齐» R S ∨ «杂» R S :=
  match one, other with
  | .inl rs, .inl sr => .inr (.inr (.inl ⟨rs, sr⟩))
  | .inl rs, .inr sr => .inr (.inl ⟨rs, sr⟩)
  | .inr rs, .inl sr => .inl ⟨sr, rs⟩
  | .inr rs, .inr sr => .inr (.inr (.inr ⟨rs, sr⟩))

/-- **Deciding inclusion against exceeding for every pair of relations is exactly excluded
middle.** -/
theorem «则逾之定当且仅当排中» :
    (∀ (α : Type) (R S : «际» α), «则» R S ∨ «逾» R S) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit «一» (fun _ _ => P) with
    | .inl inside => exact .inl (inside () () trivial)
    | .inr ⟨_, _, _, not⟩ => exact .inr not
  · intro em α R S
    match em («逾» R S) with
    | .inl exceeds => exact .inr exceeds
    | .inr nothing => exact .inl fun x y r => match em (S x y) with
      | .inl s => s
      | .inr not => absurd ⟨x, y, r, not⟩ nothing

end Order

end Becoming
