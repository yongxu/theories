import Becoming.GrammarLaws

/-!
HE2's items 2, 3 and 4, checked outside the package before the rebuild: the laws as GrammarLaws
would state them. This module imports only `Becoming.GrammarLaws`, so each law uses only the grammar,
the prelude and `Init`. In GrammarLaws the namespace `HE2U4` is dropped. Each part goes to the
section of GrammarLaws its heading names (`KIT.md`).

The «» names are working names for OU's owner, who names the grammar's laws.
-/

namespace Becoming
namespace HE2U4

universe u

section Closure

variable {α : Type u}

/-! ## Item 3, into `section Closure` after `«所闭之对称»`: the closure under the converse -/

/-- **The closure under the converse is the converse of the closure.** `y` lies within `x`'s closure
under the converse of `R` exactly where `x` lies within `y`'s closure under `R`. -/
theorem «所闭之逆» {R : «际» α} {x y : α} : «所闭» («逆» R) x y ↔ «所闭» R y x :=
  ⟨fun within => within (fun z => «所闭» R z x)
      (fun _ _ back related => «所闭之传递» («缘在所闭» (R := R) related) back) («所闭之自反» R x),
   fun within => within (fun z => «所闭» («逆» R) z y)
      (fun _ _ back related => «所闭之传递» («缘在所闭» (R := «逆» R) related) back)
      («所闭之自反» («逆» R) y)⟩

/-! ## Item 4, into `section Closure` before `end Closure`: a closure read through another's steps -/

/-- **A closure through borrowed steps lies within two closures.** Where every step of `R'` is a step
of `R`, or a step of `R` from `a` taken at `o`, what lies within `o`'s closure under `R'` lies within
`o`'s or `a`'s closure under `R`. -/
theorem «借步之所闭在二所闭» {R R' : «际» α} {o a g : α}
    (split : ∀ x y, R' x y → R x y ∨ (x = o ∧ R a y)) (within : «所闭» R' o g) :
    «所闭» R o g ∨ «所闭» R a g :=
  within (fun z => «所闭» R o z ∨ «所闭» R a z)
    (fun x y inside related => match split x y related with
      | .inl step => match inside with
        | .inl w => .inl («所闭之传递» w («缘在所闭» step))
        | .inr w => .inr («所闭之传递» w («缘在所闭» step))
      | .inr ⟨_, step⟩ => .inr («缘在所闭» step))
    (.inl («所闭之自反» R o))

/-- **Two closures lie within the closure through borrowed steps.** Where `R` lies within `R'` and
`o` reaches `a` under `R'`, what lies within `o`'s or `a`'s closure under `R` lies within `o`'s under
`R'`. -/
theorem «二所闭在借步之所闭» {R R' : «际» α} {o a g : α} (larger : «则» R R')
    (reaches : «所闭» R' o a) (within : «所闭» R o g ∨ «所闭» R a g) : «所闭» R' o g :=
  match within with
  | .inl w => «所闭之单调» larger o g w
  | .inr w => «所闭之传递» reaches («所闭之单调» larger a g w)

end Closure

/-! ## Item 2's list helpers, into the `namespace GrammarLaws` block of list helpers, before its
`end GrammarLaws`: the filters and searches a census of a step needs -/

namespace GrammarLaws

variable {α : Type u}

/-- The units a test keeps, in order. -/
def keep (p : α → Bool) : List α → List α
  | [] => []
  | x :: l => cond (p x) (x :: keep p l) (keep p l)

theorem keep_append (p : α → Bool) : ∀ a b : List α,
    keep p (a ++ b) = keep p a ++ keep p b
  | [], _ => rfl
  | x :: a, b => by
    show cond (p x) (x :: keep p (a ++ b)) (keep p (a ++ b)) =
      cond (p x) (x :: keep p a) (keep p a) ++ keep p b
    rw [keep_append p a b]
    cases p x <;> rfl

theorem keep_congr {p q : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = q x) →
    keep p l = keep q l
  | [], _ => rfl
  | x :: l, same => by
    show cond (p x) (x :: keep p l) (keep p l) =
      cond (q x) (x :: keep q l) (keep q l)
    rw [same x (.head l), keep_congr l (fun y m => same y (.tail x m))]

theorem keep_all {p : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = true) →
    keep p l = l
  | [], _ => rfl
  | x :: l, all => by
    show cond (p x) (x :: keep p l) (keep p l) = x :: l
    rw [all x (.head l), keep_all l (fun y m => all y (.tail x m))]
    rfl

theorem mem_keep {p : α → Bool} {x : α} : ∀ {l : List α},
    x ∈ keep p l ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun h => (nomatch h), fun h => (nomatch h.1)⟩
  | y :: l => by
    show x ∈ cond (p y) (y :: keep p l) (keep p l) ↔ _
    cases hy : p y with
    | true =>
      show x ∈ y :: keep p l ↔ _
      constructor
      · intro m
        cases m with
        | head => exact ⟨.head _, hy⟩
        | tail _ m' => exact ⟨.tail _ (mem_keep.mp m').1, (mem_keep.mp m').2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact .head _
        | tail _ m' => exact .tail _ (mem_keep.mpr ⟨m', px⟩)
    | false =>
      show x ∈ keep p l ↔ _
      constructor
      · intro m
        exact ⟨.tail _ (mem_keep.mp m).1, (mem_keep.mp m).2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact nomatch hy.symm.trans px
        | tail _ m' => exact mem_keep.mpr ⟨m', px⟩

theorem any_false_mem {p : α → Bool} : ∀ {l : List α} {x : α}, l.any p = false →
    x ∈ l → p x = false
  | h :: t, _, hn, .head _ => by
    cases hp : p h with
    | false => rfl
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)
  | h :: t, _, hn, .tail _ m => by
    cases hp : p h with
    | false => exact any_false_mem (l := t) ((congrArg (· || t.any p) hp).symm.trans hn) m
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)

theorem any_split {p : α → Bool} : ∀ {l : List α}, l.any p = true →
    ∃ a₁ y a₂, l = a₁ ++ y :: a₂ ∧ p y = true
  | [], hn => Bool.noConfusion hn
  | h :: t, hs => by
    cases hp : p h with
    | true => exact ⟨[], h, t, rfl, hp⟩
    | false =>
      match any_split (l := t) ((congrArg (· || t.any p) hp).symm.trans hs) with
      | ⟨a₁, y, a₂, e, hy⟩ => exact ⟨h :: a₁, y, a₂, e ▸ rfl, hy⟩

theorem any_remove {p : α → Bool} {f : α} (off : p f = false) (a₂ : List α) :
    ∀ a₁ : List α, (a₁ ++ f :: a₂).any p = (a₁ ++ a₂).any p
  | [] => by
    show (p f || a₂.any p) = a₂.any p
    rw [off]; rfl
  | h :: a₁ => congrArg (p h || ·) (any_remove off a₂ a₁)

theorem any_true_of_mem {p : α → Bool} : ∀ {l : List α} {x : α}, x ∈ l → p x = true →
    l.any p = true
  | h :: t, _, .head _, px => by
    show (p h || t.any p) = true
    rw [px]; rfl
  | h :: t, _, .tail _ m, px => by
    show (p h || t.any p) = true
    rw [any_true_of_mem m px]
    cases p h <;> rfl

theorem any_false_of {p : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = false) →
    l.any p = false
  | [], _ => rfl
  | h :: t, all => by
    show (p h || t.any p) = false
    rw [all h (.head t), any_false_of t (fun x m => all x (.tail h m))]
    rfl

theorem mem_middle (y : α) (a₂ : List α) : ∀ a₁ : List α, y ∈ a₁ ++ y :: a₂
  | [] => .head a₂
  | h :: a₁ => .tail h (mem_middle y a₂ a₁)

theorem mem_of_removed {x y : α} {a₂ : List α} : ∀ {a₁ : List α}, x ∈ a₁ ++ a₂ →
    x ∈ a₁ ++ y :: a₂
  | [], m => .tail y m
  | h :: a₁, m => by
    cases m with
    | head => exact .head _
    | tail _ m => exact .tail h (mem_of_removed m)

theorem distinct_removed {y : α} {a₂ : List α} : ∀ {a₁ : List α},
    Distinct (a₁ ++ y :: a₂) → Distinct (a₁ ++ a₂) ∧ ¬ y ∈ a₁ ++ a₂
  | [], d => ⟨d.2, d.1⟩
  | h :: a₁, d =>
    have rest := distinct_removed (a₁ := a₁) d.2
    ⟨⟨fun m => d.1 (mem_of_removed m), rest.1⟩, fun m => by
      cases m with
      | head => exact d.1 (mem_middle _ a₂ a₁)
      | tail _ m => exact rest.2 m⟩

theorem not_eq_true_iff {b : Bool} : (!b) = true ↔ b = false := by
  cases b
  · exact ⟨fun _ => rfl, fun _ => rfl⟩
  · exact ⟨fun h => (nomatch h), fun h => (nomatch h)⟩

end GrammarLaws

/-! ## Item 2, into `section Balance` before `end Balance`: counting on a region, and the count law
of a class -/

section Balance

variable {α : Type u}

/-! ### Counting (计): the count on a region, and the count law of a class

A region is read here as a test, `α → Bool`, so that a count is a function of the list. That is a
modelling choice: a region given as a proposition enters by `decide` where it is decidable. `«计»` is
the structural twin of Lean's `List.countP` (`GrammarLaws.count_eq_countP`); Init's own lemmas on
`List.countP` (`countP_cons`, `countP_append`) report `propext`, so the grammar keeps its own. -/

/-- How many units of a list a test holds of (计). A region enters as a test (`α → Bool`), a
modelling choice; a region given as a proposition enters by `decide`. -/
def «计» (p : α → Bool) : List α → Nat
  | [] => 0
  | x :: a => cond (p x) 1 0 + «计» p a

theorem GrammarLaws.count_append (p : α → Bool) : ∀ a b : List α,
    «计» p (a ++ b) = «计» p a + «计» p b
  | [], b => (Nat.zero_add («计» p b)).symm
  | x :: a, b => by
    show cond (p x) 1 0 + «计» p (a ++ b) = cond (p x) 1 0 + «计» p a + «计» p b
    rw [GrammarLaws.count_append p a b, Nat.add_assoc]

theorem GrammarLaws.count_insert (p : α → Bool) (y : α) : ∀ b₁ b₂ : List α,
    «计» p (b₁ ++ y :: b₂) = cond (p y) 1 0 + «计» p (b₁ ++ b₂)
  | [], _ => rfl
  | z :: b₁, b₂ => by
    show cond (p z) 1 0 + «计» p (b₁ ++ y :: b₂) = cond (p y) 1 0 + (cond (p z) 1 0 + «计» p (b₁ ++ b₂))
    rw [GrammarLaws.count_insert p y b₁ b₂, Nat.add_left_comm]

/-- Where a test holds of some unit, the list splits at one it holds of. -/
theorem GrammarLaws.split_of_count_pos {p : α → Bool} : ∀ {b : List α}, 0 < «计» p b →
    ∃ b₁ y b₂, b = b₁ ++ y :: b₂ ∧ p y = true
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | y :: b, pos => by
    cases hy : p y with
    | true => exact ⟨[], y, b, rfl, hy⟩
    | false =>
      have rest : 0 < «计» p b := by
        have e : «计» p (y :: b) = «计» p b := by
          show cond (p y) 1 0 + «计» p b = «计» p b
          rw [hy]; exact Nat.zero_add _
        exact e ▸ pos
      match GrammarLaws.split_of_count_pos rest with
      | ⟨b₁, z, b₂, e, hz⟩ => exact ⟨y :: b₁, z, b₂, e ▸ rfl, hz⟩

theorem GrammarLaws.count_go (p : α → Bool) : ∀ (l : List α) (acc : Nat),
    List.countP.go p l acc = acc + «计» p l
  | [], _ => rfl
  | x :: l, acc => by
    show (bif p x then List.countP.go p l (acc + 1) else List.countP.go p l acc) =
      acc + (cond (p x) 1 0 + «计» p l)
    cases p x with
    | true =>
      show List.countP.go p l (acc + 1) = acc + (1 + «计» p l)
      rw [GrammarLaws.count_go p l (acc + 1), Nat.add_assoc]
    | false =>
      show List.countP.go p l acc = acc + (0 + «计» p l)
      rw [GrammarLaws.count_go p l acc, Nat.zero_add]

/-- **`«计»` is Lean's `List.countP`.** A structural twin, proved equal with no axiom. -/
theorem GrammarLaws.count_eq_countP (p : α → Bool) (l : List α) : «计» p l = l.countP p := by
  show «计» p l = List.countP.go p l 0
  rw [GrammarLaws.count_go p l 0, Nat.zero_add]

/-- A region read as a test, closed under a relation and its converse, is one the relation never
crosses: related units lie both in it or both outside it. -/
theorem GrammarLaws.uncrossed_of_closed {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true)) :
    ∀ x y, R x y → p x = p y := fun x y r => by
  cases hx : p x <;> cases hy : p y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans (backward y x hy r))
  · exact Bool.noConfusion (hy.symm.trans (forward x y hx r))
  · rfl

/-- **A pairing keeps the count on every region the relation does not cross.** Each pair lies both
in the region or both outside it. -/
theorem «对则不越域守数» {R : «际» α} {p : α → Bool} (closed : ∀ x y, R x y → p x = p y)
    {a b : List α} (h : «对» R a b) : «计» p a = «计» p b := by
  induction h with
  | nil => rfl
  | @cons x y a b₁ b₂ r _ ih =>
    show cond (p x) 1 0 + «计» p a = «计» p (b₁ ++ y :: b₂)
    rw [GrammarLaws.count_insert, closed x y r, ih]

/-- **A pairing keeps the count on every region closed both ways**: closed under the relation and
under its converse. Closed one way is not enough (`«对而单闭域不守数之例»`). -/
theorem «对则双闭域守数» {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true))
    {a b : List α} (h : «对» R a b) : «计» p a = «计» p b :=
  «对则不越域守数» (GrammarLaws.uncrossed_of_closed forward backward) h

/-- **A region closed one way, and the count not kept**, the scope of `«对则双闭域守数»`. Under one
step from `0` to `1`, the region holding `1` alone is closed (nothing it holds bears the step
beyond it), and the pairing of `[0]` with `[1]` counts none of it before and one after. -/
theorem «对而单闭域不守数之例» :
    «闭» (fun x y : Nat => x = 0 ∧ y = 1) (fun x => Nat.beq 1 x = true) ∧
    «对» (fun x y : Nat => x = 0 ∧ y = 1) [0] [1] ∧
    «计» (Nat.beq 1) [0] ≠ «计» (Nat.beq 1) [1] :=
  ⟨fun _ _ _ step => (congrArg (Nat.beq 1) step.2).trans rfl, .cons (b₁ := []) ⟨rfl, rfl⟩ .nil, fun h => Nat.noConfusion h⟩

section CountOfClass

variable {E : «际» α} {e : α → α → Bool}

/-- Related units are counted alike by every class's test. -/
theorem GrammarLaws.class_test_congr (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) {x y : α}
    (r : E x y) (z : α) : e z x = e z y := by
  cases hx : e z x <;> cases hy : e z y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans ((dec z x).mp (cls.trans ((dec z y).mpr hy) (cls.symm r))))
  · exact Bool.noConfusion (hy.symm.trans ((dec z y).mp (cls.trans ((dec z x).mpr hx) r)))
  · rfl

/-- Equal count in every class gives a pairing under the class. -/
theorem GrammarLaws.pair_of_class_counts (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) :
    ∀ (a b : List α), (∀ z, «计» (e z) a = «计» (e z) b) → «对» E a b
  | [], [], _ => .nil
  | [], y :: b, counts => by
    have hy : «计» (e y) (y :: b) = 1 + «计» (e y) b :=
      congrArg (fun v => cond v 1 0 + «计» (e y) b) ((dec y y).mp (cls.refl y))
    have zero : «计» (e y) (y :: b) = 0 := (counts y).symm
    exact Nat.noConfusion ((zero.symm.trans hy).trans (Nat.add_comm 1 _))
  | x :: a, b, counts => by
    have pos : 0 < «计» (e x) b := by
      have hx : «计» (e x) (x :: a) = 1 + «计» (e x) a :=
        congrArg (fun v => cond v 1 0 + «计» (e x) a) ((dec x x).mp (cls.refl x))
      have more : «计» (e x) b = «计» (e x) a + 1 :=
        (counts x).symm.trans (hx.trans (Nat.add_comm 1 _))
      rw [more]
      exact Nat.succ_pos _
    match GrammarLaws.split_of_count_pos pos with
    | ⟨b₁, y, b₂, e₁, hy⟩ =>
      cases e₁
      have r : E x y := (dec x y).mpr hy
      refine .cons r (GrammarLaws.pair_of_class_counts cls dec a (b₁ ++ b₂) fun z => ?_)
      have h : cond (e z x) 1 0 + «计» (e z) a = cond (e z y) 1 0 + «计» (e z) (b₁ ++ b₂) :=
        (counts z).trans (GrammarLaws.count_insert (e z) y b₁ b₂)
      rw [GrammarLaws.class_test_congr cls dec r z] at h
      exact Naturals.add_left_cancel h

/-- **The count law of a class.** Under a class decided by a test, two lists are paired one to one
exactly where every class holds as many units of the one as of the other. The class does work:
two lists of one unit each, at different places, are paired under the whole relation `«一»` (one
class) and not under sameness `«静»` (a class for each place), `«一对而静不对之例»`. -/
theorem «类之对当且仅当类类等数» (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true)
    {a b : List α} : «对» E a b ↔ ∀ z, «计» (e z) a = «计» (e z) b :=
  ⟨fun h z => «对则不越域守数» (p := e z) (fun _ _ r => GrammarLaws.class_test_congr cls dec r z) h,
   GrammarLaws.pair_of_class_counts cls dec a b⟩

end CountOfClass

/-- **What a pairing under continuation adds to equal count.** Continuation relative to a class lies
within the class, so a pairing under it keeps the count in every class. -/
theorem «续之对则类类等数» {R E : «际» α} {e : α → α → Bool} (cls : «类» E)
    (dec : ∀ x y, E x y ↔ e x y = true) {a b : List α} (h : «对» («续» R E) a b) (z : α) :
    «计» (e z) a = «计» (e z) b :=
  («类之对当且仅当类类等数» cls dec).mp («对之单调» (fun _ _ (both : R _ _ ∧ E _ _) => both.2) h) z

/-- **Equal count, and no pairing under sameness**, the scope of `«类之对当且仅当类类等数»`: which
class does work. A unit at one place before and at another after is paired under the one, since
the counts are equal, and not under sameness, since the first place holds one unit before and
none after. -/
theorem «一对而静不对之例» : «对» «一» [0] [1] ∧ ¬ «对» («静» : «际» Nat) [0] [1] :=
  ⟨«等长则一对» [0] [1] rfl, fun h =>
    Nat.noConfusion («对则不越域守数» (p := Nat.beq 0) (fun x y (same : x = y) => congrArg (Nat.beq 0) same) h)⟩

end Balance

/-! ## Item 2, into a new `section Census` after `end Runs`, since it uses `«定后之逐点»` and
`«定前之逐点»` -/

/-! ## The census of a step (生, 亡): arising and ceasing paired

Units listed once before and after a step, under a continuation decided by a test: those before
that no unit after continues cease, and those after that continue no unit before arise. Where the
continuation fixes successors and predecessors, the census pairs them one to one; on a listing
closed at the step, arising and ceasing are the grammar's beginning (`«生»`) and ending (`«亡»`).
The listing and the test are supplied, as the pairing is in `section Balance`. -/

section Census

variable {α : Type u}

/-- The units before a step that no unit after continues, under a continuation decided by `k`: they
cease across the step. -/
def GrammarLaws.ceasing (k : α → α → Bool) (before after : List α) : List α :=
  GrammarLaws.keep (fun g => !(after.any (k g))) before

/-- The units after a step that continue no unit before, under a continuation decided by `k`: they
arise across the step. -/
def GrammarLaws.arising (k : α → α → Bool) (before after : List α) : List α :=
  GrammarLaws.keep (fun f => !(before.any (fun g => k g f))) after

/-- The census as a pairing, under a continuation decided by a test. Where units listed once at the
two ends of a step continue one to one (no unit continues as two, no two continue as one), the units
before with those arising are paired one to one with the units after with those ceasing, each pair
a continuation or the same unit. -/
theorem GrammarLaws.census_pairs (k : α → α → Bool) : ∀ (before after : List α),
    Distinct before → Distinct after →
    (∀ g f f', g ∈ before → f ∈ after → f' ∈ after → k g f = true → k g f' = true → f = f') →
    (∀ g g' f, g ∈ before → g' ∈ before → f ∈ after → k g f = true → k g' f = true → g = g') →
    «对» (fun x y => k x y = true ∨ x = y) (before ++ GrammarLaws.arising k before after)
      (after ++ GrammarLaws.ceasing k before after)
  | [], after, _, _, _, _ => by
    show «对» _ (GrammarLaws.keep (fun f => !(([] : List α).any (fun g => k g f))) after) (after ++ [])
    rw [ListTests.append_nil,
      GrammarLaws.keep_all (p := fun f => !(([] : List α).any fun g => k g f)) after (fun _ _ => rfl)]
    exact «对之自反» (R := fun x y => k x y = true ∨ x = y) (fun _ => Or.inr rfl) after
  | g :: before, after, ⟨gNot, dB⟩, dA, noSplit, noMerge => by
    cases hg : after.any (k g) with
    | false =>
      have cz : GrammarLaws.ceasing k (g :: before) after = g :: GrammarLaws.ceasing k before after := by
        show cond (!(after.any (k g))) (g :: GrammarLaws.ceasing k before after)
          (GrammarLaws.ceasing k before after) = _
        rw [hg]; rfl
      have az : GrammarLaws.arising k (g :: before) after = GrammarLaws.arising k before after :=
        GrammarLaws.keep_congr after fun f m => by
          show (!(k g f || before.any (fun g => k g f))) = !(before.any (fun g => k g f))
          rw [GrammarLaws.any_false_mem hg m]; rfl
      show «对» _ (g :: (before ++ GrammarLaws.arising k (g :: before) after))
        (after ++ GrammarLaws.ceasing k (g :: before) after)
      rw [az, cz]
      exact .cons (b₁ := after) (Or.inr rfl) (GrammarLaws.census_pairs k before after dB dA
        (fun g f f' mg => noSplit g f f' (.tail _ mg))
        (fun g g' f mg mg' => noMerge g g' f (.tail _ mg) (.tail _ mg')))
    | true =>
      match GrammarLaws.any_split hg with
      | ⟨a₁, f, a₂, e, kf⟩ =>
        cases e
        have dA' := GrammarLaws.distinct_removed dA
        have cz : GrammarLaws.ceasing k (g :: before) (a₁ ++ f :: a₂) =
            GrammarLaws.ceasing k before (a₁ ++ a₂) := by
          show cond (!((a₁ ++ f :: a₂).any (k g))) _ (GrammarLaws.ceasing k before (a₁ ++ f :: a₂)) = _
          rw [hg]
          exact GrammarLaws.keep_congr before fun g' m => by
            have off : k g' f = false := by
              cases h : k g' f with
              | false => rfl
              | true =>
                cases noMerge g g' f (.head _) (.tail _ m) (GrammarLaws.mem_middle f a₂ a₁) kf h
                exact absurd m gNot
            rw [GrammarLaws.any_remove off]
        have az : GrammarLaws.arising k (g :: before) (a₁ ++ f :: a₂) =
            GrammarLaws.arising k before (a₁ ++ a₂) := by
          show GrammarLaws.keep _ (a₁ ++ f :: a₂) = GrammarLaws.keep _ (a₁ ++ a₂)
          rw [GrammarLaws.keep_append, GrammarLaws.keep_append]
          show _ ++ cond (!(k g f || before.any (fun g => k g f))) _ _ = _
          rw [kf]
          show GrammarLaws.keep _ a₁ ++ GrammarLaws.keep _ a₂ = _
          rw [← GrammarLaws.keep_append, ← GrammarLaws.keep_append]
          exact GrammarLaws.keep_congr (a₁ ++ a₂) fun x m => by
            have off : k g x = false := by
              cases h : k g x with
              | false => rfl
              | true =>
                cases noSplit g x f (.head _) (GrammarLaws.mem_of_removed m)
                  (GrammarLaws.mem_middle f a₂ a₁) h kf
                exact absurd m dA'.2
            show (!(k g x || before.any (fun g => k g x))) = !(before.any (fun g => k g x))
            rw [off]; rfl
        show «对» _ (g :: (before ++ GrammarLaws.arising k (g :: before) (a₁ ++ f :: a₂)))
          ((a₁ ++ f :: a₂) ++ GrammarLaws.ceasing k (g :: before) (a₁ ++ f :: a₂))
        rw [az, cz, ListTests.append_assoc]
        have IH := GrammarLaws.census_pairs k before (a₁ ++ a₂) dB dA'.1
          (fun g x x' mg mx mx' => noSplit g x x' (.tail _ mg) (GrammarLaws.mem_of_removed mx)
            (GrammarLaws.mem_of_removed mx'))
          (fun g g' x mg mg' mx => noMerge g g' x (.tail _ mg) (.tail _ mg')
            (GrammarLaws.mem_of_removed mx))
        rw [ListTests.append_assoc] at IH
        exact .cons (b₁ := a₁) (b₂ := a₂ ++ GrammarLaws.ceasing k before (a₁ ++ a₂)) (Or.inl kf) IH

variable {R E : «际» α} {k : α → α → Bool}

/-- **The census on continuation.** Units listed once before and after a step, under a continuation
(`«续» R E`, decided by `k`) that fixes successors and predecessors: the units before with those
arising are paired one to one with the units after with those ceasing, each pair a continuation or
the same unit. -/
theorem «定后定前则前生对后亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    «对» (fun x y => «续» R E x y ∨ x = y) (before ++ GrammarLaws.arising k before after)
      (after ++ GrammarLaws.ceasing k before after) :=
  «对之单调» (fun x y r => match r with
      | .inl c => .inl ((dec x y).mpr c)
      | .inr e => .inr e)
    (GrammarLaws.census_pairs k before after dB dA
      (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' ((dec g f).mpr r) ((dec g f').mpr r'))
      (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f ((dec g f).mpr r) ((dec g' f).mpr r')))

/-- **Arising is beginning, on a closed step.** Where every predecessor of a unit after the step
stands before it, the units the census lists as arising are exactly the units after that begin
(`«生»`). -/
theorem «步闭则所列生者生» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (closedBefore : ∀ x f, f ∈ after → «续» R E x f → x ∈ before) {f : α} :
    f ∈ GrammarLaws.arising k before after ↔ f ∈ after ∧ «生» R E f := by
  constructor
  · intro m
    have h := GrammarLaws.mem_keep.mp m
    refine ⟨h.1, fun ⟨x, c⟩ => ?_⟩
    have off := GrammarLaws.not_eq_true_iff.mp h.2
    have on : before.any (fun g => k g f) = true :=
      GrammarLaws.any_true_of_mem (p := fun g => k g f) (closedBefore x f h.1 c) ((dec x f).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mf, begins⟩
    refine GrammarLaws.mem_keep.mpr ⟨mf, GrammarLaws.not_eq_true_iff.mpr
      (GrammarLaws.any_false_of (p := fun g => k g f) before fun g _ => ?_)⟩
    cases h : k g f with
    | false => exact h
    | true => exact absurd ⟨g, (dec g f).mpr h⟩ begins

/-- **Ceasing is ending, on a closed step.** Where every successor of a unit before the step stands
after it, the units the census lists as ceasing are exactly the units before that end (`«亡»`). -/
theorem «步闭则所列亡者亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (closedAfter : ∀ g y, g ∈ before → «续» R E g y → y ∈ after) {g : α} :
    g ∈ GrammarLaws.ceasing k before after ↔ g ∈ before ∧ «亡» R E g := by
  constructor
  · intro m
    have h := GrammarLaws.mem_keep.mp m
    refine ⟨h.1, fun ⟨y, c⟩ => ?_⟩
    have off := GrammarLaws.not_eq_true_iff.mp h.2
    have on : after.any (k g) = true :=
      GrammarLaws.any_true_of_mem (p := k g) (closedAfter g y h.1 c) ((dec g y).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mg, ends⟩
    refine GrammarLaws.mem_keep.mpr ⟨mg, GrammarLaws.not_eq_true_iff.mpr
      (GrammarLaws.any_false_of (p := k g) after fun f _ => ?_)⟩
    cases h : k g f with
    | false => rfl
    | true => exact absurd ⟨f, (dec g f).mpr h⟩ ends

end Census

end HE2U4
end Becoming
