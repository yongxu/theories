import Becoming.Grammar

/-!
# The five master laws on the grammar (主律)

The master laws of the method chapter (08 §7) restated on the grammar of `Becoming.Grammar`, for
every carrier and every relation: closure, balance (at one step), finite runs, lumping and order.
Each is stated with what it uses; where a convenient global form uses more (a successor everywhere,
a list of the whole carrier), it is a corollary of a local one. This module imports only the
grammar, so it sits below every model: `Becoming.Frame` imports it, and the models' laws that are
cases of these are proved from them in their own modules (closure in `Frame` and `GrammarScope`,
finite runs in `Recurrence` and `Attraction`, lumping in `Laws`, `Mechanism`, `GrammarRegularity`
and `IdentificationRuns`, order in `Admission` and `Regions`); balance is read on the grammar in
`Flow` (`Flow.balances_iff_units`), not derived.

| name | gloss |
|---|---|
| `«闭»` | a region closed under a relation: whatever a member bears it to is a member |
| `«所闭»` | lying within a closure: every region closed under the relation that holds `x` holds `y` |
| `«对»` | two finite lists continued one to one: an explicit pairing of their places, each pair related |
| `«定后»`, `«定前»` | the successor is fixed (`R˘;R ⊆ 静`); the predecessor is fixed, nothing merged (`R;R˘ ⊆ 静`) |
| `«入»` | drawn in: a closed region `x` lies outside holds something `x` reaches |
| `«迭»` | `n` steps: the `n`-fold composition of a relation |
| `«同行»` | `E` goes alike under `R`: `R˘;E;R ⊆ E` |
| `«像»` | the image of a relation along a map |
| `«逾»` | exceeds: relates something the other does not |
| `«广»`, `«齐»`, `«杂»` | widens (includes and exceeds); keeps (each includes the other); mixed (each exceeds the other) |

* **Closure.** `«所闭» R x y` is exactly `x = y ∨ «及» R x y` (`«所闭当且仅当同一或及»`): the least
  closed region holding `x` is `x` itself with what `x` reaches. It is reflexive, transitive, holds
  every step, grows with the relation, is symmetric for a symmetric relation, is itself closed,
  nothing within it bears the relation beyond it, and a region is `x`'s closure exactly where it
  holds `x`, is closed and lies within the closure (`«所闭之证»`).
* **Balance, at one step.** A one-to-one continuation (`«对»`) between finite lists conserves their
  count (`«对之长»`); under the one it is exactly equal count (`«一之对»`). So lists matched from
  what comes in (before, given) to what goes on (after, taken) have `after + taken = before + given`
  (`«对则守数»`), and every four numbers with that equation are the lengths of lists of units so
  matched under the one (`«守数当且仅当可对»`). This is an exact cardinality representation of
  natural-number balance at one step, near-definitional: the matching is supplied, not derived from
  the unfolding, and for an arbitrary relation only matching gives balance, not the converse. It
  establishes no trajectory of units and no compatibility between successive matchings. Balance
  over a stretch (`balance_over_stretch_on`, telescoping) and over a family (`Flow.Balances.over`,
  sums over conditions) stay arithmetic: each adds equations already balanced, and routing that
  through lists would add a dependence and no content.
* **Finite runs.** For every relation, `x` is drawn exactly where it reaches something that does not
  reach back (`«入当且仅当有不返»`). Where the successor is fixed, an occurrence that reaches itself
  is not drawn (`«定后则返者不入»`); for every relation, an occurrence with a successor that does not
  reach itself is drawn (`«有后不返则入»`); so with a fixed successor and some successor, drawn is
  exactly not reaching itself (`«入当且仅当不返»`). The fixed successor cannot be omitted in general
  (`«入而返之例»`, a witness), nor can the successor (`«无后者不入亦不返»`). Along a line whose places
  a list holds, merging nothing makes the line's start reach itself (`«线有限定前则返»`, by
  pigeonhole with no decidability); so where a list holds every occurrence and every occurrence has a
  successor, every occurrence reaches itself (`«有限定前则皆返»`). Where the successor is fixed,
  every occurrence reaching itself makes the relation merge nothing (`«皆返定后则定前»`).
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
  (`«则逾之定当且仅当排中»`).

What is not shown: that any model's relation is functional, total or listed (the models supply
these); the n-step lines law for lines of different lengths; composition of one-to-one
continuations; balance over a stretch or a family on the grammar (above). Of the anchors of 08 §7,
`Amounts.rests` is not represented: it concludes that marked steps do not recur under a least loss
within a finite budget (`¬ ∀ N, ∃ t, N ≤ t ∧ P t`), supplying neither a settling time nor an
absorbing region entered from outside, and a course already at rest need not be drawn, so rest is
not drawn in (`«入»`). Its lifting would have to keep the amount structure, the non-increase, the
least loss and the finite budget, and to distinguish non-recurrence from witnessed settling or
attraction. Every statement is pointwise; no equality of relations is used, and every declaration
has an empty axiom report.
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

/-! ## Lists (helpers, stated without `simp` so that no axiom enters) -/

namespace GrammarLaws

variable {α : Type u}

theorem length_insert : ∀ (b₁ : List α) (y : α) (b₂ : List α),
    (b₁ ++ y :: b₂).length = (b₁ ++ b₂).length + 1
  | [], _, _ => rfl
  | _ :: b₁, y, b₂ => congrArg Nat.succ (length_insert b₁ y b₂)

theorem length_append : ∀ (a b : List α), (a ++ b).length = a.length + b.length
  | [], b => (Nat.zero_add b.length).symm
  | _ :: a, b => (congrArg Nat.succ (length_append a b)).trans (Nat.succ_add a.length b.length).symm

theorem add_congr {a b c d : Nat} (h₁ : a = b) (h₂ : c = d) : a + c = b + d :=
  (congrArg (· + c) h₁).trans (congrArg (b + ·) h₂)

theorem length_replicate (x : α) : ∀ n, (List.replicate n x).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length_replicate x n)

/-- What is at least `a` is `a` and some more. -/
theorem le_dest {a b : Nat} (le : a ≤ b) : ∃ m, b = a + m := by
  induction le with
  | refl => exact ⟨0, rfl⟩
  | step _ earlier => exact match earlier with
    | ⟨m, same⟩ => ⟨m + 1, congrArg Nat.succ same⟩

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

/-- A sequence that begins at `x` and goes on with `h`. -/
def prepend (x : α) (h : Nat → α) : Nat → α
  | 0 => x
  | i + 1 => h i

end GrammarLaws

/-! ## Balance (对): one-to-one continuation conserves count -/

section Balance

variable {α : Type u}

/-- Two finite lists continued one to one under `R` (对): the head of the first is paired with some
place of the second, related to it by `R`, and the rest are so paired. It is an explicit perfect
matching of the places of the two lists, each pair related by `R`. -/
inductive «对» (R : «际» α) : List α → List α → Prop
  | nil : «对» R [] []
  | cons {x y : α} {a b₁ b₂ : List α} : R x y → «对» R a (b₁ ++ b₂) → «对» R (x :: a) (b₁ ++ y :: b₂)

/-- **A one-to-one continuation conserves count.** -/
theorem «对之长» {R : «际» α} {a b : List α} (h : «对» R a b) : a.length = b.length := by
  induction h with
  | nil => rfl
  | @cons _ y _ b₁ b₂ _ _ ih => exact (congrArg Nat.succ ih).trans (GrammarLaws.length_insert b₁ y b₂).symm

/-- Lists of equal length are continued one to one under the one. -/
theorem «等长则一对» : ∀ (a b : List α), a.length = b.length → «对» «一» a b
  | [], [], _ => .nil
  | [], _ :: _, e => Nat.noConfusion e
  | _ :: _, [], e => Nat.noConfusion e
  | _ :: a, _ :: b, e => .cons (b₁ := []) trivial («等长则一对» a b (Nat.succ.inj e))

/-- **Under the one, a one-to-one continuation is exactly equal count.** -/
theorem «一之对» {a b : List α} : «对» «一» a b ↔ a.length = b.length :=
  ⟨«对之长», «等长则一对» a b⟩

/-- A larger relation continues one to one whatever a smaller one does. -/
theorem «对之单调» {R S : «际» α} (h : «则» R S) {a b : List α} (m : «对» R a b) : «对» S a b := by
  induction m with
  | nil => exact .nil
  | cons r _ ih => exact .cons (h _ _ r) ih

/-- Under a reflexive relation every list continues itself one to one. -/
theorem «对之自反» {R : «际» α} (refl : ∀ x, R x x) : ∀ a : List α, «对» R a a
  | [] => .nil
  | x :: a => .cons (b₁ := []) (refl x) («对之自反» refl a)

/-- A pair can be put at any place of the first list. -/
theorem «对之左插» {S : «际» α} {y x : α} (r : S y x) :
    ∀ (l₁ : List α) {l₂ m : List α}, «对» S (l₁ ++ l₂) m → «对» S (l₁ ++ y :: l₂) (x :: m)
  | [], _, _, h => .cons (b₁ := []) r h
  | _ :: l₁, _, _, h => match h with
    | .cons (b₁ := m₁) rz rest => .cons (b₁ := x :: m₁) rz («对之左插» r l₁ rest)

/-- **A one-to-one continuation read backward is one** under the converse. -/
theorem «对之逆» {R : «际» α} {a b : List α} (h : «对» R a b) : «对» («逆» R) b a := by
  induction h with
  | nil => exact .nil
  | @cons x y _ b₁ _ r _ ih => exact «对之左插» (S := «逆» R) (y := y) (x := x) r b₁ ih

/-- **The balance reading.** What comes in (before, given), continued one to one into what goes on
(after, taken), has as many after and taken as before and given. -/
theorem «对则守数» {R : «际» α} {before given after taken : List α}
    (h : «对» R (before ++ given) (after ++ taken)) :
    after.length + taken.length = before.length + given.length :=
  (GrammarLaws.length_append after taken).symm.trans
    ((«对之长» h).symm.trans (GrammarLaws.length_append before given))

/-- **And every four numbers with that equation are realized**: four lists of units with those
lengths, the first two continued one to one, under the one, into the last two. -/
theorem «守数当且仅当可对» {p q r s : Nat} :
    r + s = p + q ↔ ∃ before given after taken : List Unit,
      before.length = p ∧ given.length = q ∧ after.length = r ∧ taken.length = s ∧
        «对» «一» (before ++ given) (after ++ taken) :=
  ⟨fun e => ⟨List.replicate p (), List.replicate q (), List.replicate r (), List.replicate s (),
      GrammarLaws.length_replicate () p, GrammarLaws.length_replicate () q,
      GrammarLaws.length_replicate () r, GrammarLaws.length_replicate () s,
      «一之对».mpr ((GrammarLaws.length_append _ _).trans
        ((GrammarLaws.add_congr (GrammarLaws.length_replicate () p) (GrammarLaws.length_replicate () q)).trans
          (e.symm.trans ((GrammarLaws.add_congr (GrammarLaws.length_replicate () r)
            (GrammarLaws.length_replicate () s)).symm.trans (GrammarLaws.length_append _ _).symm))))⟩,
   fun ⟨_, _, _, _, hb, hg, ha, ht, h⟩ => by
     have conserved := «对则守数» h
     subst hb hg ha ht
     exact conserved⟩

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

/-- With a fixed successor, `n` steps lead to one occurrence. -/
theorem «迭之定» {R : «际» α} (fixed : «定后» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x y → «迭» R n x z → y = z
  | 0, _, _, _, e₁, e₂ => e₁.symm.trans e₂
  | n + 1, x, _, _, ⟨w, r, first⟩, ⟨w', r', second⟩ => by
    have e : w = w' := fixed w w' ⟨x, r, r'⟩
    subst e
    exact «迭之定» fixed n first second

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

/-- With a fixed successor, what an occurrence that reaches itself reaches reaches it back. -/
theorem «环则所及皆返» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x :=
  «闭之及» (P := fun z => «及» R z x)
    (fun a b back related => match back with
      | .one r => by
        have e : b = x := fixed b x ⟨a, related, r⟩
        cases e; exact loop
      | .more r rest => by
        have e : b = _ := fixed b _ ⟨a, related, r⟩
        cases e; exact rest)
    loop reach

/-- **With a fixed successor, an occurrence that reaches itself is not drawn.** -/
theorem «定后则返者不入» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) : ¬ «入» R x :=
  fun drawn => match «入当且仅当有不返».mp drawn with
    | ⟨_, reach, never⟩ => never («环则所及皆返» fixed loop reach)

/-- **An occurrence with a successor that does not reach itself is drawn**, for every relation. -/
theorem «有后不返则入» {R : «际» α} {x y : α} (next : R x y) (never : ¬ «及» R x x) : «入» R x :=
  «入当且仅当有不返».mpr ⟨y, .one next, fun back => never (.more next back)⟩

/-- **With a fixed successor and some successor, drawn is not reaching itself.** -/
theorem «入当且仅当不返» {R : «际» α} (fixed : «定后» R) {x : α} (next : ∃ y, R x y) :
    «入» R x ↔ ¬ «及» R x x :=
  ⟨fun drawn loop => «定后则返者不入» fixed loop drawn,
   fun never => match next with
    | ⟨_, r⟩ => «有后不返则入» r never⟩

/-- Without a successor an occurrence is neither drawn nor reaches itself: the successor hypothesis
of `«入当且仅当不返»` cannot be omitted, since without it the reverse direction fails. -/
theorem «无后者不入亦不返» {R : «际» α} {x : α} (nothing : ∀ y, ¬ R x y) : ¬ «入» R x ∧ ¬ «及» R x x :=
  have first : ∀ {y}, ¬ «及» R x y := fun reach => match reach with
    | .one r => nothing _ r
    | .more r _ => nothing _ r
  ⟨fun ⟨_, _, _, _, reach, _⟩ => first reach, first⟩

/-- **An occurrence both drawn and reaching itself**, under a relation whose successor is not fixed:
`false` conditions itself and `true`, which conditions nothing. A witness, not a characterization:
the fixed successor of `«入当且仅当不返»` cannot be omitted in general, and a relation with no fixed
successor need not draw what reaches itself. -/
theorem «入而返之例» : ∃ (R : «际» Bool) (x : Bool), «入» R x ∧ «及» R x x :=
  ⟨fun a _ => a = false, false,
   ⟨fun z => z = true, fun a _ inside related => by cases inside; exact Bool.noConfusion related,
    fun inside => Bool.noConfusion inside, true, .one rfl, rfl⟩,
   .one rfl⟩

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

/-- Merging nothing, where two places of a line hold one occurrence, so do the places as many before
them, back to the first. -/
theorem «定前则线可退» {R : «际» α} (merges : «定前» R) {g : Nat → α} {N : Nat}
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d
  | 0, d, _, same => same.trans (congrArg g (Nat.zero_add d))
  | i + 1, d, le, same =>
    have shift : i + 1 + d = i + d + 1 := Nat.succ_add i d
    have le' : i + d + 1 ≤ N := Eq.subst (motive := fun k => k ≤ N) shift le
    have back : g (i + d + 1) = g (i + 1) := (congrArg g shift).symm.trans same.symm
    have r' : R (g (i + d)) (g (i + 1)) :=
      Eq.subst (motive := fun w => R (g (i + d)) w) back (steps (i + d) le')
    have r : R (g i) (g (i + 1)) :=
      steps i (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right i d)) le')
    «定前则线可退» merges steps i d (Nat.le_of_lt le') (merges _ _ ⟨_, r, r'⟩)

/-- A line of `k + 1` steps from place `m` reaches. -/
theorem «线则及» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ k m, m + (k + 1) ≤ N → «及» R (g m) (g (m + (k + 1)))
  | 0, m, le => .one (steps m le)
  | k + 1, m, le => «及之传递» («线则及» steps k m (Nat.le_trans (Nat.le_succ _) le))
      (.one (steps (m + (k + 1)) le))

open GrammarLaws in
/-- **Along a line held by a list, merging nothing, the line's start reaches itself.** Where a line
of as many steps as a list is long has its places held by the list, a relation that merges nothing
has the line's first place reaching itself: pigeonhole along the line, with no decidability, then
back along it to its first place. Only the line and the list are used: the list need not hold every
occurrence, and nothing beyond the line needs a successor. -/
theorem «线有限定前则返» {R : «际» α} {l : List α} (merges : «定前» R) {g : Nat → α}
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0) :=
  match revisits_within l g held with
  | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ =>
      have le' : i + (d + 1) ≤ l.length := Eq.subst (motive := fun k => k ≤ l.length) gap le
      have back : g 0 = g (d + 1) :=
        «定前则线可退» merges steps i (d + 1) le' (same.trans (congrArg g gap))
      have reach := «线则及» steps d 0
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add (d + 1))) (Nat.le_trans (Nat.le_add_left (d + 1) i) le'))
      have e : g (0 + (d + 1)) = g 0 := (congrArg g (Nat.zero_add (d + 1))).trans back.symm
      Eq.subst (motive := fun w => «及» R (g 0) w) e reach

/-- **Within finitely many occurrences, merging nothing, every occurrence reaches itself.** Where a
list holds every occurrence and every occurrence has a successor, a relation that merges nothing has
every occurrence reaching itself: the line law at a line of the list's length from each occurrence. -/
theorem «有限定前则皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (merges : «定前» R) (x : α) : «及» R x x :=
  match «遍后则有线» total all.length x with
  | ⟨_, g0, steps⟩ =>
    Eq.subst (motive := fun w => «及» R w w) g0 («线有限定前则返» merges steps (fun _ _ => every _))

/-- **With a fixed successor, every occurrence reaching itself, nothing is merged.** Two loops
through one successor have a common multiple of their lengths, and the steps after the first lead
from that successor to each. -/
theorem «皆返定后则定前» {R : «际» α} (fixed : «定后» R) (loops : ∀ x, «及» R x x) : «定前» R :=
  fun x y ⟨z, rx, ry⟩ =>
    match «及即迭».mp (loops x), «及即迭».mp (loops y) with
    | ⟨p, hx⟩, ⟨q, hy⟩ =>
      have lx : «迭» R ((p + 1) * q + p + 1) x x := «迭之周» hx (q + 1)
      have ly : «迭» R ((q + 1) * p + q + 1) y y := «迭之周» hy (p + 1)
      have e : (p + 1) * q + p = (q + 1) * p + q := Nat.succ.inj (Nat.mul_comm (p + 1) (q + 1))
      match lx, ly with
      | ⟨w, rxw, restx⟩, ⟨w', ryw, resty⟩ =>
        have tox : «迭» R ((p + 1) * q + p) z x :=
          Eq.subst (motive := fun v => «迭» R _ v x) (fixed w z ⟨x, rxw, rx⟩) restx
        have toy : «迭» R ((p + 1) * q + p) z y :=
          Eq.subst (motive := fun k => «迭» R k z y) e.symm
            (Eq.subst (motive := fun v => «迭» R _ v y) (fixed w' z ⟨y, ryw, ry⟩) resty)
        «迭之定» fixed _ tox toy

/-- **Within finitely many occurrences, merging nothing is every occurrence reaching itself**, for
a relation with a fixed successor that every occurrence has, on a carrier a list holds. -/
theorem «有限定前当且仅当皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (fixed : «定后» R) : «定前» R ↔ ∀ x, «及» R x x :=
  ⟨fun merges => «有限定前则皆返» every total merges, «皆返定后则定前» fixed⟩

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
